#!/usr/bin/perl

use warnings;
use strict;
use Math::Round;

my %numHash;
my $num;
my $i=1;
my $j=1;

while (1) {
  $num = round(rand() * 100);
  if (!exists($numHash{$num})) {
    print "$num\n";
    $numHash{$num} = 1;
    $num=<STDIN>;
  }
}
