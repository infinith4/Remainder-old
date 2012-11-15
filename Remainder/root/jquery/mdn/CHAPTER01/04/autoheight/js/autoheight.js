/**
 * auto height
 *
 * 汎用性をあげるため、min-heightに対応。
 * 
 * @copyright	keisuke YAMAMOTO <keisukey@ranadesign.com>
 * @link		http://kaelab.ranadesign.com/
 * @version		1.0
 * @date		Jun 10, 2011
 */

(function($) {

	// STEP-1 プロトタイプの拡張
	$.fn.extend({
		// STEP-1 メソッドの定義
		autoHeight: function(options) {
			// STEP-2 オプション対応
			var config = {
					// STEP-4 min-height省略に対応
					minHeight: "auto",
					footerHeight: 0,
					// top: $(this).offset().topだとIE6で2pxずれるため
					headerHeight: 0
				},
				// STEP-3 window.resize対応
				self = $(this),
				selfHeight = self.height();
			
			// STEP-2 オプション対応
			$.extend(config, options);
			
			// STEP-4 min-height省略に対応
			// min-heightをコンテンツ高さに設定する。
			var min = parseInt(config.minHeight, 10);
			config.minHeight =  min > selfHeight ? min : selfHeight;

			// STEP-3, 3.1(resize()での初回起動)
			$(window).resize(function() {
				// STEP-1 動的なサイズ変更
				var windowHeight = $(window).height(),
					h = windowHeight - (config.headerHeight + config.footerHeight);

				// ウィンドウサイズからヘッダー・フッター高さを除いたものと、指定した最小サイズのどちらが大きい方を取得する。
				// STEP-5 スクロールバーのちらつきに対応。
				// 指定した最小サイズよりウィンドウサイズが大きい場合に、body要素のoverflowをhiddenにする。
				if (h > config.minHeight) {
					// 新たな高さを設定する。
					self.height(h);
					// STEP-5 スクロールバーのちらつきに対応。
					$("body").css("overflow", "hidden");
				} else {
					// STEP-5 スクロールバーのちらつきに対応。
					$("body").css("overflow", "auto");
				}

				/**
				 * [動的コンテンツの対応]
				 * 動的に#containerの高さが変わるようなコンテンツの場合、self.height()を常に監視するようにする。
				 * 具体的には、下記のコードをif分の前に記述する。
				 * config.minHeight =  config.minHeight > self.height() ? config.minHeight : self.height();
				 * 常にサイズを取得する分、処理が増えるため、動的にサイズが変わらない場合は固定値を使うようにする。
				 */

			}).resize();
		
			// 自身(jQueryオブジェクト)を返すことで、メソッドチェーンを可能にする。
			return this;
		}

	});

})(jQuery);
