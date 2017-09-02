#!/usr/bin/perl

use warnings;
use strict;
use Math::Round;

my %numHash;
my $num;
my $i;
my $j;

for ($i=0;$i<=10;$i++) {
  for ($j=0;$j<=10;$j++) {
    $num = $i * $j;
    $numHash{$num} = 1;
  }
}

while (1) {
  $num = round(rand() * 100);
  if (exists($numHash{$num}) &&
      $numHash{$num} == 1) {
    print "$num\n";
    $numHash{$num} = 2;
    $num=<STDIN>;
  }
}
