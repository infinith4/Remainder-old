use strict;
use warnings;


my $tags="重要,perl,php,R Language";
my @tagslist=();
my @list=split(/,/,$tags);
foreach(@list){
	push(@tagslist, $_);
}

print @tagslist;


