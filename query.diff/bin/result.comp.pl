#!/usr/bin/perl

use warnings;
use strict;

my $line;
my $ver;
my $label;
my $exp;
my $query;
my $other;
my $host1 = $ARGV[0];
my $host2 = $ARGV[1];

my $cmd1;
my $cmd2;

my $index = 0;

while ($line=<STDIN>)
{
    chomp $line;

    if ($line=~/.*/)
    {
        $ver = $1;
        $label = $2;
        $other = $3;
        $exp = $4;
        $query = $5;
        #print "$label\n\t$ver\n\t$other\n\t$exp\n\t$query\n\n";
        
        $cmd1 = "echo $query | ./curl.sh -s \"$host1\" -l $label -a \"$other\" 2>/dev/null > ../result/$host1/$index.txt";
        $cmd2 = "echo $query | ./curl.sh -s \"$host2\" -l $label -a \"$other\" 2>/dev/null > ../result/$host2/$index.txt";
        
        print "$cmd1\n";
        system("$cmd1");
        print "$cmd2\n";
        system("$cmd2");
    }

    ++ $index;
}
