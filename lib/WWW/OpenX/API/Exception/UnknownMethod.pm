package WWW::OpenX::API::Exception::UnknownMethod;
use warnings;
use strict;
use Moose;
use namespace::autoclean;

with 'WWW::OpenX::API::Role::Exception';

__PACKAGE__->meta->make_immutable;

1;