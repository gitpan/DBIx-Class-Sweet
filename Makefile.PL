use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'DBIx::Class::Sweet',
    AUTHOR              => 'Nilson Santos Figueiredo Júnior <nilsonsfj@cpan.org>',
    VERSION_FROM        => 'lib/DBIx/Class/Sweet.pm',
    ABSTRACT_FROM       => 'lib/DBIx/Class/Sweet.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More'  => 0,
		'DBIx::Class' => 0
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'DBIx-Class-Sweet-*' },
);
