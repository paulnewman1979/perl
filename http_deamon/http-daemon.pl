#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use HTTP::Daemon;
use HTTP::Response;
use HTTP::Status qw(:constants :is status_message);

my $d = HTTP::Daemon->new(LocalPort => 90) || die;
print "Please contact me at: <URL:", $d->url, ">\n";
while (my ($c, $peeraddr) = $d->accept) {
    next if fork();

     while (my $r = $c->get_request) {
         print STDERR Dumper($r);

         my $resp = HTTP::Response->new(HTTP_OK);
         $resp->content(scalar(localtime));
         $resp->content($r->uri->path);
         $resp->content($r->as_string);
         $c->send_response($resp);

         last;
     }
     $c->close;
     undef($c);
}

