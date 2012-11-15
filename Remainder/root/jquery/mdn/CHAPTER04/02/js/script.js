	
	/**
	 * jQuery 拡張
	 */
	jQuery.fn.outerHTML = function(s) {
		return (s)
		? this.before(s).remove()
		: jQuery("<p>").append(this.eq(0).clone()).html();
	}
	
	/**
	 * isFunction
	 * オブジェクトが関数かどうかを返す
	 */
	function isFunction(obj){
		return (typeof(obj) == "function");
	}
	
	
	/**
	 * getCurrentPosition
	 * 現在地の緯度経度を取得。
	 * (navigator.geolocation)を利用。利用できない場合は、東京都付近の座標を固定値で返す 
	 */
	var TOKYO = { lat: 35.658063, lng: 139.751587 };
	function getCurrentPosition(callback) {
		if(navigator.geolocation) {
			navigator.geolocation.getCurrentPosition(function (position) {
				callback({
					lat: position.coords.latitude,
					lng: position.coords.longitude
				});
			}, function (err) {
		    callback(TOKYO);
			});
		}else{
			callback(TOKYO);
		}
	}
	
	/***
	 * expandShortUrl
	 * 短縮URLを展開
	 */
	var resolveCache = {};
	function expandShortUrl(shortUrl, callback) {
		// キャッシュに有る場合はそれを利用する
		if(resolveCache[shortUrl]) callback(resolveCache[shortUrl]);
		// ない場合はAPIに問合せ
		$.getJSON(
			'http://orgurl.turutosiya.com/api/v1/?callback=?',
			{
				url:shortUrl
			},
			function(data){
				// キャッシュに入れる
				resolveCache[shortUrl] = data.orgUrl;
				// コールバックの呼び出し
				callback(data.orgUrl); 
			});
	}
	
	/**
	 * getAddressName
	 * 行い地名を取得（逆ジオコーディング）
	 */
	var geocoder = null;
	function getAddressName(position, callback) {
		
		// google.maps.Geocoder を生成
		if(!geocoder) geocoder = new google.maps.Geocoder();
		
		// 逆ジオコーディング実行
		geocoder.geocode({
			location: new google.maps.LatLng(position.lat, position.lng)
		}, function(results, status) {
			if(google.maps.GeocoderStatus.OK) {
				callback(results[0].formatted_address);
			}else{
				callback('経度:'+position.lat+', 緯度:'+position.lng);
			} 
		});
	}
	
	/**
	 * initializeUstCanvas
	 * Ust の要素表示用の領域を初期化する
	 */
	function initializeUstCanvas(param, callback){
		var $ustCanvas = $('#'+param.ustCanvasId);
		
		// 現在地点の地名を取得
		getAddressName(param.position, function(addressName){
			
			// 近辺のツイートを取得し、その人が見ている Ustream Channel 情報を表示
	    $ustCanvas
	    	.html($('<h2>')
	    		.append($('<b>')
	    			.css('font-weight', 'bold')
	    			.text(addressName))
	    		.append($('<span>')
	    			.text(' 付近 ('+round+'圏内) の人が見ているUStream')))
				.css('display', 'block')
				;
				
			// コンテナを作成
			$('<ul>')
				.selectable({
		      selected: function(event, ui) { // 選択された際に録画ビデオの詳細情報をポップアップ
		      	$('#jqDialogCanvas')
		      		.empty()
							.attr('title', $(ui.selected).attr('data-ust-title'))
		      		.append($($(ui.selected).attr('data-ust-embed')))
		      		.append($($(ui.selected).attr('data-ust-embed-chat')))
		      		.dialog({
	              width: 600,
	              height: 600,
	              close: function(event, ui) {
	          			$('#jqDialogCanvas').empty();    	
	              }
							});
		      }
		    })
		    .appendTo($ustCanvas);
		    
		   callback($ustCanvas);
		});
		
	}
	
	/**
	 * getTweetsNearBy
	 * 近辺のつぶやきを取得
	 */
	var round = '25km';
	function getTweetsNearBy(position, callback) {
		var pageMax = 1;
		var rpp = 30;
		
		for(var page = 1; page <= pageMax; ++page) {
			// 近辺のつぶやき取得
			$.getJSON(
				'http://search.twitter.com/search.json?callback=?',
				{
					q: '"ustre.am"',
					page: page,
					rpp: rpp,
					geocode: position.lat+','+position.lng+','+round
				},
				function(data){
					callback(data.results); 
				});	
		}
	}
	
	/**
	 * getSocialStreamsNearBy
	 * 近くのソーシャルストリームを取得
	 */
	function getSocialStreamsNearBy(param, callback) {
		getTweetsNearBy(param.position, function(tweets) {
			$.each(tweets, function(index, tweet){
				if(isFunction(param.eventHandlers.socialStreamFound))
					setTimeout(function(tweet){
						param.eventHandlers.socialStreamFound({
							type: 'twitter',
							data: tweet
						});	
					},1000,tweet);
			});
		});
	}
	
	/**
	 * getUstInfoByShortUrl
	 */
	function getUstInfoByShortUrl(shortUrl, callback) {
		
		// 短縮URLを展開
		expandShortUrl(shortUrl, function(orgUrl) {
			// "http://www.ustream.tv/subject/uid/" 
			var matches = orgUrl.match(/^http:\/\/www\.ustream\.tv\/(\w+)\/(.+)\//);
			if(!matches) callback(null);
			var subject = matches[1];
			var uid = matches[2]; 
			// UStream API の呼び出し
			$.getJSON(
				'http://api.ustream.tv/json/'+subject+'/'+uid+'/getInfo?callback=?',
				{
					key: 'F65CF43AB36C6EA8CA544C551CFB5494'
				},
				function(subject){
					callback(subject);
				});
		});
	}
	
	/**
	 * buildTweetElement
	 * つぶやきを表示するためのエレメントを構築
	 */
	function buildTweetElement(tweet, callback){
		var $elem = $('<div>')
			.addClass('tweet')
			.css('vertical-align', 'middle')
			.append($('<img>')
				.attr('src', tweet.profile_image_url)
				.attr('width', '1.2em')
				.css('width', '1.2em'))
			.append($('<span>')
				.text(' ' +tweet.text));
		callback($elem);
	}
	
	/**
	 * showTweetWithEffect
	 * つぶやきを表示する際にエフェクトをかける
	 */
	function showTweetWithEffect($container, tweet, callback) {
		buildTweetElement(tweet, function($tweet){
			$container.append(
				$tweet
					.css('background-color', '#BA017E')
					.animate({
				    backgroundColor: 'white'
				  }, 1500 )
			);
			if(!$container.hasClass('fading')) {
				$container
					.addClass('fading')
					.fadeIn('fast', function(){
						setTimeout(function($this){
							$this.fadeOut('slow', function(){
								$(this)
									.css('display', '') // $.fadeOut() は 該当要素をdisplay:noneにしてしまう為
									.removeClass('fading');
									
								callback($tweet);
							});	
						},2000,$(this));
					});
			}else{
				callback($tweet);
			}
		});
	}
	
	/**
	 * updateUstCanvas
	 * 近くの人が見ている番組リストの表示を更新
	 */
	function updateUstCanvas(param, callback) {
		// Ustの番組表示用領域の初期化
		initializeUstCanvas(param, function($ustCanvas){
			
			// 付近のソーシャルストリームを取得
			getSocialStreamsNearBy({
				position:param.position,
				eventHandlers:{
					// 付近のソーシャルストリームが検索にヒットした際のイベントハンドラ
					socialStreamFound: function(socialStream){
						switch(socialStream.type){
							// Twitter の場合 - - - - - - - - - - - - - - - - - - - -  
							case 'twitter':
								var tweet = socialStream.data; 
								// ""http://ustre.am/xxxx" を探す
								var matches = tweet.text.match(/http:\/\/ustre\.am\/(\w+)/);
								if(!matches) return;
								var ustShortUrl = matches[0];
								//  このURLについての要素を検索
								var $li = $ustCanvas.find('ul li[data-ust-short-url="'+ustShortUrl+'"]');
								
								if($li.size() < 1) {
									
									// コンテナ要素の構築
									$li = $('<li>')
										.addClass('ui-widget-content')
										.attr('data-ust-short-url', ustShortUrl)
										.attr('display','none')
										.append($('<a>')		// タイトルの表示域
											.addClass('title')
											.text('loading...'))
										.append($('<img>')	// 番組のイメージ画像
											.addClass('image')
											.attr('src', 'img/na.png')
											.attr('width', 120)
											.css('width', 120))
										.append($('<a>')		// 視聴者数の表示域
											.addClass('views'))			
										.append($('<div>')
											.addClass('tweets')
											.append($('<span>').text('この動画に関するつぶやき'))
											.append($('<hr>')))
										.appendTo($ustCanvas.find('ul'))
										.fadeIn('fast');
												
									// 短縮URLからUstream API を使って情報を取得
									getUstInfoByShortUrl(ustShortUrl, function(subject){
										$li
							  			.attr('data-ust-id', subject.id)
							  			.attr('data-ust-title', subject.title)
							  			.attr('data-ust-embed', $(subject.embedTag).find('embed').attr('width', '100%').attr('height', '70%').parent().outerHTML())
											.attr('data-ust-embed-chat', $(subject.chat.embedTag).attr('width', '100%').attr('height', '25%').outerHTML())
											
										$li.find('.title')
											.attr('href', subject.url)
							  			.text(subject.title);
							  			
							  		$li.find('.views')
							  			.text(subject.numberOf.views+' views');
							  			
										if(subject.imageUrl)
											$li.find('.image')
												.attr('src', (subject.imageUrl) ? subject.imageUrl.small : '');
										
										showTweetWithEffect($li.find('.tweets:first'), tweet, function($tweet){
											// nothing to do
										});
									});
								}else{
									showTweetWithEffect($li.find('.tweets:first'), tweet, function($tweet){
										// nothing to do
									});
								}
								break;
						}
					}
				}
			}, function(){
				
			});
		});
	}
	
	/**
	 * initializeMap
	 * 地図(Google Map)の初期化
	 */
	function initializeMap(param, callback) {
		// 高さをあわせる
		$('#'+param.canvasId)
			.css('height', $(window).height() - 60);
    // Google Map の生成
    var gmap = new google.maps.Map(
    	document.getElementById(param.canvasId),
    	{
	      zoom: 14,
	      streetViewControl: false,
	      mapTypeId: google.maps.MapTypeId.ROADMAP
	    });
	  
	  // イベントハンドラの設定
	  $.each(param.eventHandlers, function(key, value) {
	  	google.maps.event.addListener(gmap, key, value);
	  });
	  
		// コールバックを呼び出す
    callback(gmap);
	}
	
	$(function(){
		
		// 画面一杯に地図を表示させる
		$(window).resize(function() {
			var height = $('html').height() - $('#header-container').height();
			$('#gglMapCanvas')
				.attr('height', height)
				.css('height', height);
		});
		$(window).resize();
		
		// 地図の初期化
		var lastTimer = null;
		initializeMap({
			canvasId: "gglMapCanvas",
			eventHandlers: {
				// 地図の中心点が変更された時のイベントハンドラ
				'center_changed': function(){
					var map = this;
	    		// 現在中心となっている場所の緯度経度を取得
	    		var latlng = map.getCenter();
	    		
	    		// 表示されている場合は非表示にする
					// if ($('#ustCanvas').is(':visible')) $('#ustCanvas').('display', 'none');
					$('#ustCanvas').html($('<h2>').append('Searching social streams ...'));
					 
	    		// 断続的に中心点が移動されている場合の為の対策として 600 ミリ秒待機
	    		if(lastTimer) clearTimeout(lastTimer);
	    		lastTimer = setTimeout(function(position){
	    			// 番組一覧の表示を更新
	    			updateUstCanvas({
    					ustCanvasId: 'ustCanvas',
    					position: position
	    			});
	    		}, 600, {lat:latlng.lat(), lng:latlng.lng()});
	    	}
			}
		}, function(map) {
			getCurrentPosition(function(position) {
	    	map.setCenter(new google.maps.LatLng(position.lat, position.lng));
	    });	
		});
		
	});
