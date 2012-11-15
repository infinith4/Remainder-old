/*======================================================
初期設定
======================================================*/
//ページをめくるスピード
var speed = 500;
//写真のサイズ
var photoWidth = 400;
var photoHeight = 300;
//キャプションエリアの高さ
var captionHeight = 80;
//影とハイライトの幅
var shadowWidth = 150;

/*======================================================
各種宣言
======================================================*/
//現在表示されている見開きページ
var currentPageNumber;
//写真の総数
var totalImages0;
//左右ページ、それぞれを格納するための配列
var evenPageArray = new Array();
var oddPageArray = new Array();
//アニメーション動作中フラグ
var isTurn = false;

/*======================================================
ドキュメント読み込み後の処理
======================================================*/
$(document).ready(function(){
	
	//選択枠を隠す
	$('a').focus(function(e){this.blur()});

	//写真の数からトータルページ数を計算
	totalPages = $('ul.galleryContent li').length/2;

	//写真の数が奇数のとき、最後にブランクページを追加して偶数にする
	if(totalPages != Math.floor(totalPages)){
		$('ul.galleryContent').append('<li><img src="images/blank.jpg" width="400" height="300" alt="" /></li>');
	}

	//li要素を偶数ページと奇数ページに分ける
	evenPageArray = $('ul.galleryContent li:even');
	oddPageArray = $('ul.galleryContent li:odd');

	//レイヤーの深度を設定
	for(i=0; i< evenPageArray.length; i++){
		$(evenPageArray[i]).css('z-index', evenPageArray.length-i);
	}
	for(i=0; i< oddPageArray.length; i++){
		$(oddPageArray[i]).css('z-index', oddPageArray.length - i + evenPageArray.length);
	}
	
	//要素のスタイルをセットアップ実行
	gallerySetup();

});

/*======================================================
各要素のスタイルを設定
======================================================*/
function gallerySetup(){

	//写真のli要素をすべて取得
	var photos = $('ul.galleryContent li');

	//【CLASS追加】写真のimg要素にクラス属性を追加
	$(photos).find('img').attr('class','photo');

	//↓ここから必要な要素を追加-------------------------------

	//【要素追加】左ページ（偶数列）にオーバーレイするシャドウ画像
	$(evenPageArray).find('img.photo').after('<img src="images/shadow.png" class="overlay" />');

	//【要素追加】右ページ（奇数列）にオーバーレイするハイライト画像
	$(oddPageArray).find('img.photo').after('<img src="images/hilight.png" class="overlay" />');

	//【要素追加】ドロップシャドウ
	$(photos).find('img.photo').before('<div class="dropshadow"></div>')

	//【要素追加】キャプション
	$(photos).find('img.photo').before('<div class="caption"><p></p></div>');

	//↓ここから各要素のCSSを設定-------------------------------

	//ギャラリー全体のCSS
	$('ul.galleryContent')
		.css('width',photoWidth*2 + 'px')
		.css('height',photoHeight + captionHeight + 'px');
	$('div.galleryBook')
		.css('width',photoWidth*2 + 200 + 'px')
		.css('height',$('ul.galleryContent').height() + 'px');
	$(evenPageArray).css('left','0px');
	$(oddPageArray).css('right','0px');

	//ナビゲーションの表示をいったん隠す
	$('div.galleryBook div.prevButton').hide();
	$('div.galleryBook div.nextButton').hide();

	//li要素全体の共通CSS
	$(photos)
		.css('width',photoWidth + 'px')
		.css('height',photoHeight + captionHeight + 'px')
		.css('position','absolute')
		.css('overflow','hidden');

	//写真のimg要素の共通CSS
	$(photos).find('img.photo')
		.css('width',photoWidth + 'px')
		.css('height',photoHeight + 'px')
		.css('display','block')
		.css('position','absolute')
		.css('right','auto')
		.css('left','auto');

	//ページにオーバーレイするシャドウ・ハイライトの共通CSS
	$(photos).find('img.overlay')
		.css('width',shadowWidth + 'px')
		.css('height',photoHeight + captionHeight + 'px')
		.css('opacity','0.5')
		.css('display','block')
		.css('position','absolute')
		.css('top','0')
		.css('right','auto')
		.css('left','auto');

	//ドロップシャドウの共通CSS
	$(photos).find('div.dropshadow')
		.css('width',photoWidth + 'px')
		.css('height',photoHeight + captionHeight + 'px')
		.css('background','#000')
		.css('position','absolute')
		.css('right','auto')
		.css('left','auto');

	//キャプションエリアの共通CSS
	$(photos).find('div.caption')
		.css('overflow','hidden')
		.css('width',photoWidth + 'px')
		.css('height',captionHeight + 'px')
		.css('background','#f0f0f0')
		.css('display','block')
		.css('position','absolute')
		.css('top',photoHeight + 'px')
		.css('right','auto')
		.css('left','auto');

	//キャプションのCSS
	$(photos).find('div.caption p')
		.css('margin','15px')
		.css('font-size','91%')
		.css('color','#999')
		.hide();
	$(evenPageArray).find('div.caption p').css('text-align','left');
	$(oddPageArray).find('div.caption p').css('text-align','right');

	//左ページ（偶数列）の個別CSS
	$(evenPageArray).find('img.photo').css('right','0');
	$(evenPageArray).find('img.overlay').css('right','0');
	$(evenPageArray).find('div.dropshadow').css('right','0');
	$(evenPageArray).find('div.caption').css('right','0');

	//右ページ（奇数列）の個別CSS
	$(oddPageArray).find('img.photo').css('left','0');
	$(oddPageArray).find('img.overlay').css('left','0');
	$(oddPageArray).find('div.dropshadow').css('left','0');
	$(oddPageArray).find('div.caption').css('left','0');

	//↓ここからその他の処理-------------------------------

	//title属性から値を取得してキャプションに設定
	for(i=0; i< $(photos).length; i++){
		var captionStr = $(photos[i]).find('img.photo').attr('title');
		$(photos[i]).find('div.caption p').html(captionStr);
	}

	//最初のページ（レイヤー）を最上層へ移動させる
	currentPageNumber = 0;
	swapLayer(evenPageArray,currentPageNumber);
	swapLayer(oddPageArray,currentPageNumber);

	//初回の処理
	allActionComplete();
}

/*======================================================
配列内の要素の深度を1つずつ下げて、指定の要素を最上層へ
======================================================*/
function swapLayer(array,index){
	var maxZ = parseInt($(array[0]).css('z-index'));
	for(i=0; i< array.length; i++){
		var currentZ = parseInt($(array[i]).css('z-index'));
		if(currentZ > maxZ){
			maxZ = currentZ;
		}		
		$(array[i]).css('z-index', currentZ-1);
	}
	$(array[index]).css('z-index', maxZ);
}

/*======================================================
実行用関数
======================================================*/
function turnpage(way){
	switch (way){
		case "next":
			if(currentPageNumber < totalPages-1 && !isTurn){
				turnup("next");
			}
			break;
		case "prev":
			if(currentPageNumber > 0 && !isTurn){
				turnup("prev");
			}
			break;
		default:
			break;
	}
}

/*======================================================
ページをめくり上げる動作
======================================================*/
function turnup(way){

	//動作中フラグを立てる
	isTurn = true;

	//キャプションを隠す
	$('div.caption p').hide();

	//アニメーション対象要素の取得と終了後の関数を設定
	var currentPage;
	var onComplateFunction;
	switch (way){
		case "prev":
			currentPage = $(evenPageArray[currentPageNumber]);
			onComplateFunction = function(){
				--currentPageNumber;
				turndown("prev");
			}
			break;
		case "next":
			currentPage = $(oddPageArray[currentPageNumber]);
			onComplateFunction = function(){
				++currentPageNumber;
				turndown("next");
			}
			break;
		default:
			break;
	}

	//ページをアニメーション前の形に変形
	$(currentPage).find('img.photo').css('width',photoWidth + 'px');
	$(currentPage).find('img.overlay').css('width',shadowWidth + 'px');
	$(currentPage).find('div.caption').css('width',photoWidth + 'px');
	$(currentPage).find('div.dropshadow').css('opacity','1').css('width',photoWidth + 'px');

	//アニメーション実行
	$(currentPage).find('img.photo').animate({
		width: "0"
	}, speed, "easeInSine", onComplateFunction);
	$(currentPage).find('img.overlay').animate({
		width: "0"
	}, speed, "easeInSine");
	$(currentPage).find('div.caption').animate({
		width: "0"
	}, speed, "easeInSine");
	$(currentPage).find('div.dropshadow').animate({
		width: photoWidth / 4 + "px",
		opacity: "0"
	}, speed, "easeInSine");	
}

/*======================================================
ページをたたむ動作
======================================================*/
function turndown(way){

	//アニメーション対象要素の取得
	var currentPage;
	switch (way){
		case "next":
			currentPage = $(evenPageArray[currentPageNumber]);
			swapLayer(evenPageArray,currentPageNumber);
			break;
		case "prev":
			currentPage = $(oddPageArray[currentPageNumber]);
			swapLayer(oddPageArray,currentPageNumber);
			break;
		default:
			break;
	}

	//ページをアニメーション前の形に変形
	$(currentPage).find('img.photo').css('width','0px');
	$(currentPage).find('img.overlay').css('width','0px');
	$(currentPage).find('div.caption').css('width','0px');
	$(currentPage).find('div.dropshadow').css('opacity','0').css('width',photoWidth / 4 + 'px');
	
	//アニメーション実行
	$(currentPage).find('img.photo').animate({
		width: photoWidth + 'px'
	}, speed, "easeOutSine", allActionComplete);
	$(currentPage).find('img.overlay').animate({
		width: shadowWidth + "px"
	}, speed, "easeOutSine");
	$(currentPage).find('div.caption').animate({
		width: photoWidth + 'px'
	}, speed, "easeOutSine");
	$(currentPage).find('div.dropshadow').animate({
		width: photoWidth + 'px',
		opacity: "1"
	}, speed, "easeOutSine");
}

/*======================================================
すべてのアクションが終了したあとの処理
======================================================*/
function allActionComplete(){

	//キャプションをフェードインして表示
	$('div.caption p').fadeIn(speed);

	//動作中フラグを下ろす
	isTurn = false;

	//先頭に到達している場合はナビゲーションを隠す
	var prevButton = $('div.galleryBook div.prevButton');
	if(currentPageNumber <= 0){
		$(prevButton).fadeOut(speed / 2);
	}else if($(prevButton).css('display') == 'none'){
		$(prevButton).fadeIn(speed / 2);
	}

	//最終に到達している場合はナビゲーションを隠す
	var nextButton = $('div.galleryBook div.nextButton');
	if(currentPageNumber >= totalPages - 1) {
		$(nextButton).fadeOut(speed / 2);
	}else if($(nextButton).css('display') == 'none'){
		$(nextButton).fadeIn(speed / 2);
	}
}
