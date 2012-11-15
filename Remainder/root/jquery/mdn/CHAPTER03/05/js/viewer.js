/**
 * image viewer
 * 
 * @copyright	keisuke YAMAMOTO <keisukey@ranadesign.com>
 * @link		http://kaelab.ranadesign.com/
 * @version		1.0
 * @date		Jun 02, 2011
 */
(function($) {

	// 実行
	// ドキュメントのロード後、プラグインを実行する。
	$(function() {
		// オプションでspeedとwaitを指定可納
		//	$(".mod-image").viewer({
		//		speed: 300,
		//		wait: 500
		//	});
		$(".mod-image").viewer();
	});

	// viewerメソッドを定義
	$.fn.viewer = function(options) {
		var config = {
				speed: 1000,	// ビジュアルを切り替えるのに要する時間
				wait: 2000		// 次の切り替わりまでの待ち時間
			};
		// メインビジュアルのli要素(画像の器)を変数に入れておく。
		var main = this.find(".main li");
		// サムネイルのli要素(画像の器)を変数に入れておく。
		var thumb = this.find(".thumb li");
		// インデックス番号を格納する変数を設定する。初期値は0。
		var i = 0;
		// タイマーIDを格納する変数を設定する。
		var timerId = 0;

		// 画像切替関数を定義。
		var changeImage = function(i) {
			thumb
				// 現在表示しているサムネイル指定枠をフェードアウトさせる。
				.find(".current").stop(true).fadeTo(config.speed, 0).end()
				// 次にターゲットにしようとしているサムネイル指定枠をフェードインさせる
				.eq(i).find(".current").stop(true).fadeTo(config.speed, 1);
			main
				// 指定インデックス以外の画像をフェードアウトさせる。
				.filter(function(index) { return index != i; }).fadeOut(config.speed).end()
				// 指定インデックスの画像をフェードインさせる。
				.eq(i).fadeIn(config.speed, function(){
					// インデックスが末尾まできている場合は、0に戻す。
					// それ以外は1つ進める。
					i = i === main.length - 1 ? 0 : i + 1;
					// 指定時間経過後に次の動作を行う。
					// タイマーをリセットする。
					clearTimeout(timerId);
					// タイマーをセットする。
					timerId = setTimeout(function(){
						// 次のインデックスを画像切替関数に渡し実行する。
						changeImage(i);
					}, config.wait);
				});
		};

		// 初期設定にユーザ設定を上書き。
		$.extend(config, options);

		// サムネイル設定。
		thumb.each(function() {
			// ターゲット枠を作成する。
			// classは予約語。
			var $current = $("<div>", { "class": "current" });
			$(this).append($current);
		}).click(function() {
			// クリックイベントの設定。
			// タイマーをリセットし、クリックされたインデックスを画像切替関数に渡し実行する。
			clearTimeout(timerId);
			changeImage($(this).index());
		}).hover(function() {
			// ホバー設定
			// マウスオーバーしたら、".current"というクラス名をつけて、中の画像の透過度を変更する。
			$("img", this).css("opacity", 1);
		}, function() {
			// マウスアウトしたら、".current"というクラス名を外し、中の画像の透過度を変更する。
			$("img", thumb).css("opacity", 0.6);
		});

		// ループを開始する。
		changeImage(i);
		
		// 自身(jQueryオブジェクト)返すことで、メソッドチェーンを可能にする。
		return this;
	};

})(jQuery);
