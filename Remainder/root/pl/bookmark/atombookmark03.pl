#!/usr/bin/perl

use strict;
use warnings;

use HTTP::Lite;
use HTML::TreeBuilder;
use HTML::TagParser;
use XML::FeedPP;

my $http = new HTTP::Lite;
my $userid = "infinity_th4";
#my $tag = $c->request->body_params->{'tag'};
my $tag = "*book";#日本語が使えない
my $url = "http://b.hatena.ne.jp/".$userid."/atomfeed?tag=".$tag;
my $req = $http->request("$url") || die $!;

my $body = $http->body();

my $tree = HTML::TreeBuilder->new;
$tree->parse($body);
$tree->eof();


my @urls = ();
#URL 
foreach my $a ($tree->look_down("rel" , "related")) {
    print $a->attr("href");
    push(@urls, $a->attr("href"));
    print "\n";
}

print $_,"\n" ,foreach @urls;

my $feed = XML::FeedPP->new( $url );
print "Title: ", $feed->title(), "\n";
print "Date: ", $feed->pubDate(), "\n";

my @bookmarkurls = ();
my @titles = ();
my @reltags = ();
my @issueds = ();
foreach my $item ( $feed->get_item() ) {
    print "bookmarkURL: ", $item->link(), "\n"; #bookmarkURL
    push(@bookmarkurls, $item->link());
    print "Title: ", $item->title(), "\n";      #Title
    push(@titles, $item->title());
    my $reltag ="";
    foreach my $a ($item->get("dc:subject")) {
        print "category: ", $a, "\n"; #relation Tag
        $reltag = $reltag.$a.",";
    }
    push(@reltags,$reltag);
    print "issued: ", $item->get("issued"), "\n";#登録日時
    push(@issueds, $item->get("issued"));
}


for(0 .. 19){
    print $bookmarkurls[$_],"\n";
}

print "length:",length(@bookmarkurls),"\n";#変


foreach (@reltags){
    print $_,"\n";
}

#foreach my $a ($tree->find("issued")) {
#    print $a->as_text;
#    print "\n";
#}

exit;


