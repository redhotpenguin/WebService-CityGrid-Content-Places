#!/usr/bin/perl

use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'WebService-CityGrid-Content-Places',
    VERSION_FROM  => 'lib/WebService/CityGrid/Content/Places.pm',
    PREREQ_PM     => { 'Any::Moose' => 0 },
    ABSTRACT_FROM => 'lib/WebService/CityGrid/Content/Places.pm',
    AUTHOR        => 'Fred Moyer <fred@slwifi.com>'
);
