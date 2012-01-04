#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper;
use WebService::CityGrid::Content::Places;

use Getopt::Long;
use Pod::Usage;

# Config options
my $string = 0;
my ( $help, $man );

my $publisher = 'test';
my ( $what, $where );

pod2usage(1) unless @ARGV;
GetOptions(
    'publisher=s' => \$publisher,
    'what=s'      => \$what,
    'where=s'     => \$where,
    'help'        => \$help,
    'man'         => \$man,
) or pod2usage(2);

pod2usage(1) if $help;
pod2usage( -verbose => 2 ) if $man;


my $Cg = WebService::CityGrid::Content::Places->new( { publisher => $publisher, what => $what, where => $where } );

my $res = $Cg->query;

warn Dumper($res);
