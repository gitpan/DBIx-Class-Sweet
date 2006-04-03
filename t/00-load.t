#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'DBIx::Class::Sweet' );
}

diag( "Testing DBIx::Class::Sweet $DBIx::Class::Sweet::VERSION, Perl $], $^X" );
