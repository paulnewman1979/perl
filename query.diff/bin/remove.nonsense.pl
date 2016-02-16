#!/usr/bin/perl

use warnings;
use strict;

my $line;
my $status = 0;
while ($line=<STDIN>)
{
    chomp $line;
    if ($line=~/a/)
    {
        next;
    }
    elsif ($line=~/b/)
    {
        $status = 1;
    }
    elsif ($line=~/^}/)
    {
        if ($status == 1)
        {
            $status = 2;
            next;
        }
        else
        {
            print "$line\n";
        }
    }
    elsif ($status == 1)
    {
        next;
    }
    elsif ($status == 2)
    {
        $status = 0;
        print "$line\n";
    }
    else
    {
        print "$line\n";
    }
}
if ($status == 2)
{
    print "\n";
}
