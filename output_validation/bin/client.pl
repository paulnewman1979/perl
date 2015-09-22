#!/usr/bin/perl

use warnings;
use strict;
use WWW::Curl::Easy;

my $line;
my $index = 0;

my $old_server;
my $new_server;

my %index_hash;
my $use_index_hash = 0;
if ($#ARGV < 0)
{
	print "usage:\n";
	exit(1);
}
if ($#ARGV >= 1)
{
	$use_index_hash = 1;
	my @indexes = split(",", $ARGV[1]);
	for (my $i=0; $i<@indexes; $i++)
	{
		print "loading: $indexes[$i]\n";
		$index_hash{$indexes[$i]} = 1;
	}
}
print "$use_index_hash\n";

$index = -1;
open(FILE, "$ARGV[0]") || die "file missing";
while ($line=<FILE>)
{
	++ $index;
	next if (($use_index_hash == 1) && (!exists($index_hash{$index})) );

	chomp $line;
	if ($use_index_hash == 1)
	{
		print "processing: $index\n";
	}

	my $response_body;
	my $resp_header = "";

	# new
    my $curl = WWW::Curl::Easy->new;
	my $query;
	my @req_headers;
	($query, @req_headers) =split('\t', $line);
	$curl->setopt(CURLOPT_HTTPHEADER, \@req_headers);
	$curl->setopt(CURLOPT_URL, "http://$new_server$query&server=new&queryindex=$index\n");
    $curl->setopt(CURLOPT_WRITEDATA,\$response_body);
	$curl->setopt(CURLOPT_WRITEHEADER, \$resp_header);

	my $retcode = $curl->perform;

    open(FILEOUT, ">../result/new.resp/$index") || die "open new";
	print FILEOUT "$response_body\n";
	$resp_header=~s/Date:.*//g;
	$resp_header=~s/Set-Cookie: BX=[^;]*;/Set-Cookie: /g;
	$resp_header=~s/Set-Cookie: B=[^;]*;/Set-Cookie: /g;
	print FILEOUT "$resp_header";
	close(FILEOUT);

	# old
	$response_body = "";
	$resp_header = "";
	($query, @req_headers) =split('\t', $line);
	$curl->setopt(CURLOPT_HTTPHEADER, \@req_headers);
	$curl->setopt(CURLOPT_URL, "http://$old_server$query&server=old&queryindex=$index\n");
    $curl->setopt(CURLOPT_WRITEDATA,\$response_body);
	$curl->setopt(CURLOPT_WRITEHEADER, \$resp_header);

	$retcode = $curl->perform;

    open(FILEOUT, ">../result/old.resp/$index") || die "open old";
	print FILEOUT "$response_body\n";
	$resp_header=~s/Date:.*//g;
	$resp_header=~s/Set-Cookie: BX=[^;]*;/Set-Cookie: /g;
	$resp_header=~s/Set-Cookie: B=[^;]*;/Set-Cookie: /g;
	print FILEOUT "$resp_header";
	close(FILEOUT);

	#last if ($index > 0);
}
close(FILE);
