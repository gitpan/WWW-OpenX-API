package WWW::OpenX::API::RPC::XML::Client;
use strict;
use warnings;
use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
use DateTime;

extends 'RPC::XML::Client';

sub FOREIGNBUILDARGS {
    my $package = shift;
    my %options = (@_);

    return ($options{'uri'});
}

sub implode {
    my $self = shift;
    my $response = shift;
    my $imploded;

    if(blessed($response) eq 'RPC::XML::array') {
        $imploded = [];
        push(@$imploded, $self->implode($_)) for(@$response);
    } elsif(blessed($response) eq 'RPC::XML::struct') {
        $imploded = {};
        $imploded->{$_} = $self->implode($response->{$_}) for(keys(%$response));
    } elsif(blessed($response) eq 'RPC::XML::datetime_iso8601') {
        my $v = $response->value;
        if($v =~ /(?<year>\d{4})(?<month>\d{2})(?<day>\d{2})T(?<hour>\d{2}):(?<minute>\d{2}):(?<second>\d{2})/) {
            $imploded = DateTime->new(
                year => $+{year},
                month => $+{month},
                day => $+{day},
                hour => $+{hour},
                minute => $+{minute},
                second => $+{second}
                );
        } else {
            die WWW::OpenX::API::Exception::ImplodeError->new(message => sprintf('Could not convert ISO8601 date (%s) to DateTime object during implosion', $v));
        }
    } else {
        $imploded = $response->value;
    }
    return $imploded;
}

sub send_request_and_implode {
    my $self = shift;
    
    return $self->implode($self->send_request(@_));
}
    
__PACKAGE__->meta->make_immutable();

1;

