#!/usr/bin/perl

use strict;
use warnings;

use HTTP::Lite;
use HTML::TreeBuilder;
use HTML::TagParser;
use XML::FeedPP;

my $http = new HTTP::Lite;
my $url = "http://b.hatena.ne.jp/infinity_th4/atomfeed?tag=*book";
my $req = $http->request("$url") || die $!;

my $body = $http->body();

my $tree = HTML::TreeBuilder->new;
$tree->parse($body);
$tree->eof();

foreach my $a ($tree->find("title")) {
    print $a->as_text;
    print "\n";
}


foreach my $a ($tree->look_down("rel" , "related")) {
    print $a->attr("href");
    print "\n";
}

foreach my $a ($tree->look_down("rel" , "alternate")) {
    print $a->attr("href");
    print "\n";
}

#foreach my $a ($tree->find("dc:subject")) {
#    print $a->as_text;
#    print "\n";
#}

foreach my $a ($tree->find("dc:subject")) {
    print $a->as_text;
    print "\n";
}

#my $html = HTML::TagParser->new( "$url" );
#my @list = $html->getElementsByTagName( "dc:subject" );

=pod
    foreach my $elem ( @list ) {
        my $tagname = $elem->tagName;
        my $attr = $elem->attributes;
        my $text = $elem->innerText;
        print "<$tagname";
        foreach my $key ( sort keys %$attr ) {
            print " $key=\"$attr->{$key}\"";
        }
        if ( $text eq "" ) {
            print " />\n";
        } else {
            print ">$text</$tagname>\n";
        }
}
=cut

my $feed = XML::FeedPP->new( $url );
print "Title: ", $feed->title(), "\n";
print "Date: ", $feed->pubDate(), "\n";

foreach my $item ( $feed->get_item() ) {
    print "bookmarkURL: ", $item->link(), "\n";
    print "URL: ", $item->link("related"),"\n"; 
    print "Title: ", $item->title(), "\n";
    foreach my $a ($item->get("dc:subject")) {
        print "category: ", $a, "\n";
    }
    print "issued: ", $item->get("issued"), "\n";
}



#foreach my $a ($tree->find("issued")) {
#    print $a->as_text;
#    print "\n";
#}

exit;


