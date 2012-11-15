/**
 * imgloader
 * 
 * @category    jQuery plugin
 * @license     http://www.opensource.org/licenses/mit-license.html  MIT License
 * @copyright   2010 RaNa design associates, inc.
 * @author      keisuke YAMAMOTO <keisukey@ranadesign.com>
 * @link        http://kaelab.ranadesign.com/
 * @version     1.0
 * @date        2011-06-21
 *
 * 画像の読み込みと生成を行い、完了またはタイムアウトを確認してからコールバックに設定した処理を行う。
 *
 * [オプション]
 * imglist: (Array) 画像のsrcに指定するパスを配列形式で指定。
 * callback: (function) コールバック処理を関数形式で指定。
 * timeout: (Number) タイムアウトをミリ秒で指定。省略時はタイムアウトしない。
 *
 */
(function($) {

	/**
	 * imgloader
	 */
	$.fn.imgloader = function(options) {
		var self = this,
			defaults = {
				imglist: [],
				callback: $.noop,
				timeout: 0
			},
			config = $.extend({}, defaults, options),
			images = [],
			start = new Date();

		for (var key in config.imglist) {
			var img = new Image();
			img.src = config.imglist[key];
			self.append(img);
			images.push(img);
		}

		setTimeout(function() {
			if (config.timeout > 0 && new Date() - start > config.timeout) {
				images.length = 0;
			}

			for (var i = images.length; i-- > 0; ) {
				if (images[i].complete || images[i].readyState === "complete") {
					images.splice(i, 1);
				}
			}

			if (images.length === 0) {
				($.proxy(config.callback, self))();
			} else {
				setTimeout(arguments.callee, 200);
			}
		}, 200);

		return this;
	};

})(jQuery);
