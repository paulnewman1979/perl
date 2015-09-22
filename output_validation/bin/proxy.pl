#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use HTTP::Daemon;
use HTTP::Response;
use HTTP::Status qw(:constants :is status_message);
use WWW::Curl::Easy;

my $dest = "";

my %ignore_header = (
	"::std_case" => 1,
	"host" => 1
);


my $d = HTTP::Daemon->new(LocalPort => 3002) || die;
print "Please contact me at: <URL:", $d->url, ">\n";
while (my ($c, $peeraddr) = $d->accept) {
    next if fork();
	
    while (my $r = $c->get_request) {
		if ($r->uri->path eq "/status.html")
		{
			my $resp = HTTP::Response->new(HTTP_OK);
			$c->send_response($resp);
			last;
		}
		my $index = 0;
		my $server = "old";
        if ($r->uri=~/(&|\?)server=([^&]+)/)
        {
        	$server = $2;
        }
		if ($r->uri=~/(&|\?)queryindex=(\d+)/)
		{
			$index = $2;
		}
		my $request = $r->uri;
		$request=~s/&server=([^&]*)//g;

		print "$server\t$index\n";
		open(FILE, ">../result/$server.req/$index");
		print FILE "request:".$request."\n";
		my $tmp_headers = $r->headers;
		my %header_hash = %$tmp_headers;
		#print $header_hash."\n";
		my @headers = [];
		foreach my $header_key (sort {$a cmp $b } keys %header_hash)
		{
			next if (exists($ignore_header{$header_key}));

			if ($header_key eq "raw-query")
			{
				my $raw_req = $header_hash{$header_key};
				$raw_req=~s/&server=(old|new)//g;
				#print "$header_key\t$raw_req\n";
				print FILE "$header_key\t$raw_req\n";
				$header_hash{$header_key} = $raw_req;
				push @headers,"$header_key: $raw_req";
				next;
			}

			#print "$header_key\t$header_hash{$header_key}\n";
			push @headers, "$header_key: $header_hash{$header_key}";
			print FILE "$header_key\t$header_hash{$header_key}\n";
		}
		close(FILE);

        if ($server eq "new")
		{
            my $curl = WWW::Curl::Easy->new;
            #print $r->uri."\n";
            $curl->setopt(CURLOPT_URL, "http://$dest".$request);

        	my $response_body;
	        $curl->setopt(CURLOPT_WRITEDATA,\$response_body);
			$curl->setopt(CURLOPT_HTTPHEADER, \@headers);

    	    my $retcode = $curl->perform;
			my $httpcode = $curl->getinfo(CURLINFO_HTTP_CODE);
	        my $resp = HTTP::Response->new($httpcode);
    	    $resp->content($response_body);
        	$c->send_response($resp);

			open(FILE, ">../result/cache/$index.body");
			print FILE "$response_body";
			close(FILE);

			open(FILE, ">../result/cache/$index.header");
			for (my $i=0; $i<@headers; $i++)
			{
				print FILE "$headers[$i]\n";
			}
			close(FILE);

			open(FILE, ">../result/cache/$index.httpcode");
			print FILE "$httpcode";
			close(FILE);
		}
		else
		{
			my $line;
			my $httpcode;

			open(FILE, "../result/cache/$index.httpcode");
			while ($line=<FILE>)
			{
				$httpcode = $line;
			}
			close(FILE);

			open(FILE, "../result/cache/$index.header");
			while ($line=<FILE>)
			{
				chomp $line;
				push @headers, "$line";
			}
			close(FILE);

			my $response_body = "";
			open(FILE, "../result/cache/$index.body");
			while (my $line=<FILE>)
			{
				$response_body .= $line;
				#print "$line";
			}
			my $resp = HTTP::Response->new($httpcode);
			$resp->content($response_body);
			$c->send_response($resp);
		}

        last;
    }
    $c->close;
    undef($c);
}
