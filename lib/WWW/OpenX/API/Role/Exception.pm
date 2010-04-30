package WWW::OpenX::API::Role::Exception;
use warnings;
use strict;
use Moose::Role;
use namespace::autoclean;

has 'message'           => ( is => 'ro', isa => 'Str' );
has 'code'              => ( is => 'ro', isa => 'Int' );

sub _stringify {
    my $self = shift;
    
    return (defined($self->message)) ? $self->message : blessed($self);
}

sub rethrow { 
    my $self = shift;
    die $self;
}

sub rethrow_as {
    my $self = shift;
    my $as = shift;     

    $as = $as->new(code => $self->code, message => $self->message) unless(blessed($as) =~ /^WWW::OpenX::API::Exception/);
    die $as;
}

__PACKAGE__->meta->add_package_symbol('&()' => sub { }); # dummy
__PACKAGE__->meta->add_package_symbol('&(""' => sub { shift->_stringify });

no Moose::Role;

1;
