#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'WWW::OpenX::API' ) || print "Bail out!
";
}

diag( "Testing WWW::OpenX::API $WWW::OpenX::API::VERSION, Perl $], $^X" );
