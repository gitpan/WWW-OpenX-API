package WWW::OpenX::API::Types;
use strict;
use warnings;
use Moose;
use Moose::Util::TypeConstraints;
use namespace::autoclean;

subtype 'DateTime' 
    => as 'Object'
    => where { $_->isa('DateTime') };


1;
