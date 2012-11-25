use strict;
use warnings;

my $tag="重要,普通,微妙,perl,php,R Language";

my @list=split(/,/,$tag);

print $list[1],"\n";
foreach my $parts(@list){
    print "$parts\n";
}


my $tags="重要,perl,php,R Language";
my @tagslist=();
my @list=split(/,/,$tags);
foreach(@list){
	push(@tagslist, $_);
}



