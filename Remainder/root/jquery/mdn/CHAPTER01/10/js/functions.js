/*======================================================
初期設定
======================================================*/
//ページトップボタンのdiv要素id名
var pagetopID = "pagetopBtn";
//ページトップボタンが表示されるスクロール位置
var pagetop = 50;
//スクロール停止からページトップボタンが表示されるまでの時間
var delay = 500;
//ページトップボタンが表示する速度
var showSpeed = 1000;
//ページトップボタンが隠れる速度
var hideSpeed = 100;
//スクロールの速度
var scrollSpeed = 1000;

/*======================================================
ドキュメント読み込み後の処理
======================================================*/
$(document).ready(function() {

	//選択枠を隠す
	$('a').focus(function(e){this.blur()});

	//ページトップボタンのid名に#を追加
	pagetopID = "#" + pagetopID;

	//ページトップボタンの初期設定
	$(pagetopID).rotate(180);

	//スクロール、リサイズごとに実行される処理
	function onScroll(event) {
		$(pagetopID)
			.stopTime()
			.trigger("scrollStart")
			.oneTime(delay, function(){$(this).trigger("timerFinished")});
	}

	//スクロール、リサイズイベントに関数をbind
	$(window).bind("scroll resize", onScroll);

	//ページトップボタンを表示する
	$(pagetopID).bind("timerFinished", function(event){
		if($(window).scrollTop() >= pagetop){
			$(this).addClass("show").rotate({
				duration: showSpeed,
				animateTo: 90,
				easing: $.easing.easeOutElastic,
				callback:function(){
				}
			});
		}
	});

	//ページトップボタンを隠す
	$(pagetopID).bind("scrollStart", function(event){
		if($(this).hasClass("show")){
			$(this).removeClass("show").rotate({
				duration: hideSpeed,
				animateTo: 180,
				easing: $.easing.easeOutQuart,
				callback:function(){
				}
			});
		}
	});

});

/*======================================================
スクロール
======================================================*/
function pageScroll(obj){
	if(!obj){
		$.scrollTo({ top:0, left:0 }, scrollSpeed, {easing:"easeInOutQuart"});
	} else {
		$.scrollTo(obj, scrollSpeed, {easing:"easeInOutQuart"});
	}
}