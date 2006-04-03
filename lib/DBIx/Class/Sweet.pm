package DBIx::Class::Sweet;

use warnings;
use strict;

use base qw/DBIx::Class/;

=head1 NAME

DBIx::Class::Sweet - Syntatic sugar for DBIx::Class

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

This module adds syntatic sugar for setting up your DBIx::Class classes. It's 
motivation came from the fact that __PACKAGE__ is a rather ugly construct, 
specially when you've got a dozen of them.

Here's what the code should look like when using it:

    package World::Person;

    use DBIx::Class::Sweet;

    setup_class {

        add_columns(qw/id name country_id/);
        set_primary_key('id');
        belongs_to( country => 'World::Country', 'country_id' );

    };

=head1 EXPORTS

=cut

=head2 setup_class { class setup code }

This function takes a code block as its only parameter and tries to give 
special meaning to the code inside it. Particularly, every function call is 
translated to a class method call.

Besides that, this function also does some "default" setting up of your 
DBIx::Class subclass. It automatically loads PK::Auto and Core components and 
sets the table name to a sane default: the last part of your class name, 
lower-cased. So the default table for MyDB::Whatever::MyTable whould be 
'mytable'.

=cut

sub setup_class (&) {
	my ($code) = shift;
	my ($caller) = (caller);

	# loads the usual components by default
	$caller->load_components(qw/PK::Auto Core/);

	# tries to use a sane default table name
	# e.g. MyDB::Whatever::MyTable uses 'mytable'
	(my $table_name = lc($caller)) =~ s/.*?::([^:]+)$/$1/;
	$caller->table($table_name);
	
	my $auto = sub {
		our $AUTOLOAD;
		(my $method = $AUTOLOAD) =~ s/.*?::([^:]+)$/$1/;
		my @isa;
		{
			no strict 'refs';
			@isa = @{"${caller}::ISA"};
		}

		# this might be sub-optimal
		# but after struggling with Class::C3, this was the best I could come
		# up with
		my $dispatch = $caller->can($method);

		unless ($dispatch) {
			require Carp;
			Carp::croak("unknown class setup method '$method' called at $caller");
		}
		
		$caller->$dispatch(@_);
	};
	
	{
		no strict 'refs';
		local *{"${caller}::AUTOLOAD"} = $auto;
		use strict 'refs';
		$code->();
	}
};

=head1 CLASS METHODS

=cut

=head2 import

Makes the caller our subclass (and, thus, DBIx::Class subclass).

=cut

sub import {
	my $class = shift;
	my ($caller) = (caller);
	
	{
		no strict 'refs';
		*{"${caller}::setup_class"} = \&setup_class;
		push(@{"${caller}::ISA"}, $class);
	}

}

=head1 TODO

Add some real test cases.

Add more syntatic sugar (auto-joins jump into my mind).

=cut

=head1 AUTHOR

Nilson Santos Figueiredo Júnior, C<< <nilsonsfj at cpan.org> >>

=head1 BUGS

This module does some tricky stuff. There might be some bugs lurking around.

Please report any bugs or feature requests directly to the author.
If you ask nicely it will probably be implemented.

=head1 SEE ALSO

L<DBIx::Class>

=head1 COPYRIGHT & LICENSE

Copyright 2006 Nilson Santos Figueiredo Júnior, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of DBIx::Class::Sweet
