package Remainder::Controller::Root;
use Moose;
use namespace::autoclean;

use Data::Dumper;

use Schedule::Cron;

use Email::Sender::Simple qw(sendmail);
use Email::Simple;
use Email::Simple::Creator;
use Email::Sender::Transport::SMTP;

use DateTime;
use Catalyst::Plugin::Unicode;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=head1 NAME

Remainder::Controller::Root - Root Controller for Remainder

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

#sub index :Path :Args(0) {
sub index :Local {
    my ( $self, $c ) = @_;

    # Hello World
    #$c->response->body( $c->welcome_message );
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

sub remainder :Local {
	my ($self ,$c) = @_;
	#$c->response->body('こんにちは');
    #$c->stash->{list} = [$c->model('CatalDB::Book')->all];
    #$c->stash->{title} = 'Remainder - あなたの気になるをお知らせ！ -';
   
}

sub memo :Local {
    my ($self ,$c) = @_;
    #$c->stash->{list} = [$c->model('CatalDB::Book')->all];
    #my $memo = "";
    my $memo = $c->request->body_params->{'memo'};
    #print "$memo\n";
    my $weektimes = $c->request->body_params->{'weektimes'};
    my $days = $c->request->body_params->{'days'};
    #print $days,"\n";
    #$c->stash->{day} = join ',',@$day;
    my $notification = $c->request->body_params->{'notification'};
	#$c->stash->{list} = [$c->model('CatalremaindDB::RemainderMemo')->all];
    #レコードへ登録
    $memo =$memo.".";

    if($memo ne ""){
        my $row = $c->model('RemainderDB::RemainderMemo')->create({
            memo => $memo,
            #weektimes => $weektimes,
            days => $days,
            notification => $notification,
            #created => 'NOW()',
            #updated => 'NOW()',
        });
    }

    $c->stash->{remaindermemo} = [$c->model('RemainderDB::RemainderMemo')->all];
    #$c->response->body('success')

    #print $day;
    #$c->stash->{day} = join ',',@$day;

    #mail 送信 START #########################################
    sub dispatcher{
        print "ID: ", shift, "\n";
        print "Args:","@_", "\n";
    }

    sub job{#mail 送信job
        #mail 送信
        my $email = Email::Simple->create(
            header => [
                From    => '"from name" <remainder.information@gmail.com>',
                To      => '"to name" <remainder.infomation@gmail.com>',#given
                Subject => "testmemo mail subject",#given
            ],
            body => "Job test\n",#given
            );

        my $transport = Email::Sender::Transport::SMTP->new({
            ssl  => 1,
            host => 'smtp.gmail.com',
            port => 465,
            sasl_username => 'remainder.information@gmail.com',
            sasl_password => 'ol12dcdbl0jse1l'
                                                            });
        eval { sendmail($email, { transport => $transport }); };             
        if ($@) { warn $@ }

    }

    my $cron = new Schedule::Cron(\&dispatcher);
    my $min = 12;#given
    my $hour = 17;#given
    my $days = "Sun,Mon,Wed,Sat";#given
    my @daylist = split(/,/,$days);

    if(scalar(@daylist) != 0){
        for(my $i = 0;$i < scalar(@daylist);$i++){
            $cron->add_entry("$min $hour * * $daylist[$i]", \&job);
        }
    }

#    $cron->run();

    #mail送信 END ################################################

    #日付を指定して生成
    my $dt = DateTime->new(
        time_zone => 'Asia/Tokyo',
        year      => 2008,
        month     => 8,
        day       => 4,
        hour      => 15,
        minute    => 0,
        second    => 0
        );

    #epochから生成
    $dt = DateTime->from_epoch( time_zone => 'Asia/Tokyo', epoch => 1217829600 );
    
    #現在の日付(時間ふくむ)
    $dt = DateTime->now( time_zone => 'Asia/Tokyo' );
    $c->stash->{datetimenow} = $dt;
    print $dt,"\n";
    my $dtto = DateTime->now( time_zone => 'Asia/Tokyo' )->add(months => 12 );
    #$dtto=$dtto->add( months => 12 );
    $c->stash->{datetimeto} = $dtto;

    #月末日を取得
    my $dt2 = DateTime->last_day_of_month( year => 2008, month => 11 );
    $c->stash->{day} = $dt2->day;
    
    #tag付け
    my $tags = "tag1,タグ2,タグ3,ＴＡＧＵ4,Tag 5,tag6";#日本語が使えない;use utf8しておくと２バイト文字が表示できない
    #my $tag1 = "tag1";
    #my $tag2 = "tag2";
    my @tagsarray=();
    my @list=split(/,/,$tags);
    foreach(@list){
        push(@tagsarray, $_);
    }
        #@list = ['Perl', 'php'];
    #$c->stash->{array_t} = \@list; #stashに渡すのは,['perl','php']でないと,うまくいかない
    #my %hash = {'Practical' => 'Perl', 'PP' => 'php'};
    #my @tags = [$tag1,$tag2];
    #$c->stash->{tagslist} = \@tags;# {'Practical' => 'Perl', 'PP' => 'php'}#%hash; #stashに渡すのは,['perl','php']でないと,うまくいかない
    my @array = ( 'test1', 'test2', 'test3' );#日本語が使えない

    $c->stash->{tagsarray} = \@tagsarray; # ハッシュや配列の場合はリファレンスでセットする
    #$c->stash->{textjp} = 'テスト';
    #my %hash = {text1 => 'テスト１',text2 => 'テスト２' };

    #$c->stash->{messageh} = \%hash; # ハッシュや配列の場合はリファレンスでセットする

}

sub memolist :Local {
	my ($self ,$c) = @_;
	$c->stash->{list} = [$c->model('RemainderDB::RemainderMemo')->all];
}

sub oauth :Local {
	my ($self ,$c) = @_;
	
}

sub oauthphp :Local {
	my ($self ,$c) = @_;
	
}

=head1 AUTHOR

th4,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
