$(function(){
	
	// Googleマップの埋め込み
	var gmap = $("#gmap").gmap3({
		
		// 初期表示位置の指定
		latitude:   35.692125, // 緯度
		longitude: 139.742649, // 経度
		zoom: 15,              // ズームレベル
		
		// 各コントロールの表示／非表示
		navigationControl: true,
		mapTypeControl: false,
		scaleControl: true,
		
		// マーカーの設置
		markers: [
			{
				address: '〒102-0074 東京都千代田区九段南３−２−７',
				title: '株式会社ビズバナナ',
				content: '<div class="popup"><h4>株式会社ビズバナナ</h4><p>〒102-0074<br />東京都千代田区九段南３−２−７<br />COI九段三丁目ビル B1F</p></div>',
				icon: 'images/access/icn_marker.png',
				openInfo: true
			}
		]
	
	}).data('gmap');
	
	// カスタムマップタイプを設定
	var myStyledMapType = new google.maps.StyledMapType(
		[
			{
				featureType: "all",
				elementType: "all",
				stylers: [
					{ hue: '#f9c631' },
					{ lightness: 10 },
					{ saturation: -40 },
					{ gamma: .7 }
				]
			}
		]
	);
	
	// カスタムマップタイプの登録
	gmap.mapTypes.set('myMapType', myStyledMapType);
	gmap.setMapTypeId('myMapType');

});
