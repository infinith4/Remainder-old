use Encode;
use LWP;
$ua = LWP::UserAgent->new();
$res = $ua->get('http://oshiete.goo.ne.jp/qa/1758795.html');
if($res->is_success){
    $title=$res->title;
    #Encode::from_to($title, "euc-jp","shiftjis");
    print $title,"\n";
} else {
    print $res->status_line;
}
