package WWW::OpenX::API;
use warnings;
use strict;
use Moose;
use Try::Tiny;

use WWW::OpenX::API::Types;
use WWW::OpenX::API::Dispatch;
use WWW::OpenX::API::Dispatch::Table;
use WWW::OpenX::API::Exception::ImplodeError;
use WWW::OpenX::API::Exception::InvalidCredentials;
use WWW::OpenX::API::Exception::MissingParameter;
use WWW::OpenX::API::Exception::NeedAuth;
use WWW::OpenX::API::Exception::RPC;
use WWW::OpenX::API::Exception::UnknownMethod;
use WWW::OpenX::API::RPC::XML::Client;

use namespace::autoclean;

our $VERSION = sprintf('0.1.%d', q|$Rev: 6 $| =~ /(\d+)/);

has 'address'           => ( is => 'rw', isa => 'Str', required => 1 );
has 'authenticated'     => ( is => 'rw', isa => 'Bool', default => 0, init_arg => undef, clearer => 'clear_authenticated' );
has 'sessionkey'        => ( is => 'rw', isa => 'Str', default => undef, init_arg => undef, clearer => 'clear_sessionkey' );
has 'servicecache'      => ( is => 'rw', isa => 'HashRef[Object]', init_arg => undef, default => sub { {} } );
has 'dispatchtable'     => ( is => 'rw', isa => 'HashRef[Object]', init_arg => undef, default => sub { {} } );

# the following are a few utility methods on top of things
sub login {
    my $self = shift;
    my %options = (@_);

    die WWW::OpenX::API::Exception::MissingParameter->new(message => 'login requires a username parameter') unless(defined($options{'username'}));
    die WWW::OpenX::API::Exception::MissingParameter->new(message => 'login requires a password parameter') unless(defined($options{'password'}));

    my $response;

    try {
        $response = $self->call('logon', $options{'username'}, $options{'password'});
    } catch {
        if(defined($_) && defined(blessed($_)) && blessed($_) =~ /^WWW::OpenX::API::Exception/i) {
            $_->rethrow_as('WWW::OpenX::API::Exception::InvalidCredentials') if(/the username .* not correct/i);
            $_->rethrow;
        } else {
            die $_;
        }
    };

    $self->authenticated(1);
    $self->sessionkey($response->value);
    return 1;
}

sub logout {
    my $self = shift;

    $self->call('logoff');
    $self->clear_sessionkey();
    $self->clear_authenticated();
}

sub service {
    my $self = shift;
    my $endpoint = shift;

    return $self->servicecache->{$endpoint} if(defined($self->servicecache->{$endpoint}));
    $self->servicecache->{$endpoint} = WWW::OpenX::API::RPC::XML::Client->new(uri => sprintf('%s/%s', $self->address, $endpoint));
    return $self->servicecache->{$endpoint};
}

sub dispatch {
    my $self = shift;
    my $function = shift; 

    return $self->dispatchtable->{$function} if(defined($self->dispatchtable->{$function}));
    return undef unless(defined(WWW::OpenX::API::Dispatch::Table->DISPATCH_TABLE->{$function}));
    $self->dispatchtable->{$function} = WWW::OpenX::API::Dispatch->new(%{ WWW::OpenX::API::Dispatch::Table->DISPATCH_TABLE->{$function} });
    return $self->dispatchtable->{$function};
}

sub call {
    my $self = shift;
    my $function = shift;
    my @args = (@_); 
    
    my $dispatch = $self->dispatch($function) || die WWW::OpenX::API::Exception::UnknownMethod->new(message => $function);

    die WWW::OpenX::API::Exception::NeedAuth->new(message => 'You need to call "login" first') if($dispatch->require_auth && !$self->authenticated);

    my @real_args = ();
    push(@real_args, $self->sessionkey) if($dispatch->require_auth);

    foreach my $arg (@args) {
        if(blessed($arg) && blessed($arg) eq 'DateTime') {
            push(@real_args, RPC::XML::datetime_iso8601->new($arg->strftime('%Y%m%dT%T')));
        } else {
            push(@real_args, $arg);
        }
    }

    my $service = $self->service($dispatch->service);
    my $response = $service->send_request($function, @real_args);

    die WWW::OpenX::API::Exception::RPC->new(code => $response->value->{faultCode}, message => sprintf('%s: %s', $function, $response->value->{faultString})) if(blessed($response) eq 'RPC::XML::fault');

    my $imploded_response = $service->implode($response);

    return ($dispatch->no_implode == 1) 
            ? $response
            : $imploded_response;
}

1;
__END__
=head1 NAME

WWW::OpenX::API - Access OpenX's XMLRPC API and manage your adserver from your perl scripts

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

Allows you to manipulate OpenX by way of XMLRPC. Comes in handy if you want to build some
custom tools for it.

    use WWW::OpenX::API;

    my $openx = WWW::OpenX::API->new(address => 'http://your.openx.server.here.com/www/api/v1/xmlrpc');
    
    if($openx->login(username => 'username', password => 'password')) {
        print "We are logged in!";
    }

=head1 SUBROUTINES/METHODS

=head2 login(%params)

Must be the first thing you call, parameters are 'username' and 'password'. This function will throw an exception if the username or password are incorrect, or when any other kind of error occurs.

=head2 call($function, @function_parameters)

Makes an XMLRPC call. See WWW::OpenX::API::Dispatch::Table for the full list of 'allowed' functions. Also see the OpenX API Documentation at http://developer.openx.org/api/.

Examples and notes:

=over 4

=item Calling differences

C<boolean getAgencyZoneStatistics(string $sessionId, integer $agencyId, date $oStartDate, date $oEndDate, recordSet &$rsStatisticsData)>

Is called as:

C<my $rsStatisticsData_ArrayRef = $openx->call('agencyZoneStatistics', $agencyId, $dateTime_startdate, $dateTime_enddate)>

=item Use of DateTime

When you see a reference to a 'date' value, feed it a DateTime object instead. The API module automatically converts it to the right format. 

=item When you need a struct

When you see a reference to any I<OA_Dll_xxxxxInfo>, you want to pass a hash reference as parameter. E.g.

C<$openx->call('updateAgency', { ... })>

=back

=head1 ERROR HANDLING

Errors aren't really handled, it's your job to do that ;) The call function will throw exceptions whenever something goes wrong. You can inspect them based on their class name, and every exception has two functions: 

=head2 code

Returns an error code, if applicable, but may be undef

=head2 message

Returns an error message.

Exceptions stringify to their message, in case you want to match on the message itself. All exception error messages are prefixed with the function call that caused the error to happen. 

An example using C<Try::Tiny>

    my $value;
    try {
        $value = $openx->call('getAgency', 10);
    } catch {
        blessed($_) eq 'WWW::OpenX::API::Exception::RPC' and print "Something went wrong with an RPC call: ", $_->message
    }


=head1 AUTHOR

Ben van Staveren, C<< <benvanstaveren at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-www-openx-api at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-OpenX-API>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

There are, undoubtedly, a few bugs. This is my first attempt at Moose, and as such there will undoubtedly be better or cleaner ways to do it. Please feel free to submit patches :)


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::OpenX::API


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-OpenX-API>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WWW-OpenX-API>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WWW-OpenX-API>

=item * Search CPAN

L<http://search.cpan.org/dist/WWW-OpenX-API/>

=back


=head1 LICENSE AND COPYRIGHT

Copyright 2010 Ben van Staveren.

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; version 2 dated June, 1991 or at your option
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

A copy of the GNU General Public License is available in the source tree;
if not, write to the Free Software Foundation, Inc.,
59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.


=cut
