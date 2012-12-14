#!/usr/bin/perl
use strict;
use warnings;
use DateTime;

use Email::Sender::Simple qw(sendmail);
use Email::Simple;
use Email::Simple::Creator;
use Email::Sender::Transport::SMTP;

#ここまでで複数時間を指定してメールを時間に送信できる。
#DBからselect してmemoと時間を指定するだけ。

#時間は要素ごとに対応している。
my @hours = (5,5,9);
my @mins = (36,37,28);

my $hoursnum = scalar(@hours);

sub hourmin_entry{
    my ($hours,$mins,$hash,@memos) = @_;
    
    for (my $i=0;$i<$hoursnum;$i++){
            print "select time is ",$$hours[$i],$$mins[$i],"\n";
    }
    my $frommail = "remainder.information\@gmail.com";
    my $frommailpassword = "ol12dcdbl0jse1l";

    while(1){
        my $dt = DateTime->now( time_zone => 'Asia/Tokyo' );
        #my $hour = $dt->hour(),"\n";
        #my $min = $dt->minute(),"\n";
        print $dt,"\n";
        
        my $content = "";
        foreach(@memos){
                $content = $content.$_."\n";
        }
        #print $content,"\n";
        for(my $i =0;$i < $hoursnum;$i++){
        
                if(($$hours[$i] == $dt->hour()) && ($$mins[$i] == $dt->minute()) ){
                    #$func;
                    #last;

                    #sendmailjob
                    print "sendmail\n";
                    print $$hash{userid},"\n";
                    my $mailcontent = "$$hash{userid} さん\n\n内容:\n$content\n\n配信を停止する(http://localhost:3000/memo)\n\n-----------------------------------------------\n - Remainder -あなたの気になるをお知らせ-\n $frommail";

                    #print $$hash{userid},"\n";
                    #mail 送信
                    my $email = Email::Simple->create(
                        header => [
                            From    => '"Mail Remainder"'." <".$frommail.">",
                            To      => $$hash{userid}."さん"." <".$$hash{usermail}.">",#given
                            Subject => "$$hash{subject}",#given
                        ],
                        body => "$mailcontent",#given
                        );

                    my $transport = Email::Sender::Transport::SMTP->new({
                        ssl  => 1,
                        host => 'smtp.gmail.com',
                        port => 465,
                        sasl_username => $frommail,
                        sasl_password => $frommailpassword
                                                                        });
                    eval { sendmail($email, { transport => $transport }); };             
                    if ($@) { warn $@ }

                }
                
        }
        sleep(60);
    }
    
}

=pod
sub job{
    
        print "$_[0]\n";
    
}

=cut


=pod
sub time {
    while(1){
        my $dt = DateTime->now( time_zone => 'Asia/Tokyo' );
        my $dayabbr    = $dt->day_abbr;   # 曜日の省略名
    }
    return $dt;
}

=cut


=pod
sub subject{
    my $func = $_[0];
    $func;
    print "completed\n";
}
=cut

=pod
my @aaa=("aaa","bbb");
foreach (@aaa){
    &subject(\&callback($_));
}

=cut


my @aaa=("aaa","bbb");

my $bbb="bbb";
my $userid ="tashirohiro4";#given
my $usermail = "infinith4\@gmail.com";#given
my $subject = "[test] Remainder";
my @memos = ("memo1","memo2","memo3");



my %hash = ( userid => $userid, usermail => $usermail, subject => $subject);

#if文が適用されていない

&hourmin_entry(\@hours,\@mins,\%hash,@memos);

#1;
