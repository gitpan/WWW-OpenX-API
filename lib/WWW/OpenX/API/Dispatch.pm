package WWW::OpenX::API::Dispatch;
use warnings;
use strict;
use Moose;
use namespace::autoclean;

has service => (is => 'ro', isa => 'Str', required => 1, default => undef );
has require_auth => (is => 'ro', isa => 'Bool', required => 0, default => 1 );
has no_implode => (is => 'ro', isa => 'Bool', required => 0, default => 0 );

__PACKAGE__->meta->make_immutable;

1;
