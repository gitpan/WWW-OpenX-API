use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'WWW::OpenX::API',
    license             => 'gpl',
    dist_author         => q{Ben van Staveren <benvanstaveren@gmail.com>},
    dist_version_from   => 'lib/WWW/OpenX/API.pm',
    dist_abstract       => 'An OpenX API',
    requires            => {
        'DateTime'                      =>  0,
        'DateTime::Format::ISO8601'     =>  0,
        'Moose'                         =>  0,
        'MooseX::NonMoose'              =>  0,
        'RPC::XML::Client'              =>  0, 
        'Try::Tiny'                     =>  0,
        },
    build_requires      => {
        'Test::More' => 0,
        },
    add_to_cleanup      => [ 'WWW-OpenX-API-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
