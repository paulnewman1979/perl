#!/usr/bin/perl

use warnings;
use strict;

my $line;
my $query;
my $header;

my $in_query = 0;

while ($line=<STDIN>)
{
	chomp $line;
	$line=~s///g;
	
	if ($line=~/GET (\/d.*) HTTP\//)
	{
		$query = $1;
		$in_query = 1;
		print "$query";
	}
	elsif ($in_query == 1)
	{
		if ($line=~/^$/)
		{
			$in_query = 0;
			print "\n";
		}
		elsif ($line=~/^([^ ]*): ([^ ]+)/)
		{
			my $key = $1;
			my $value = $2;
			print "\t$key: $value";
		}
	}
}
