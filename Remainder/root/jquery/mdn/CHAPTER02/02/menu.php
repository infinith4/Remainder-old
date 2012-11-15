<?php
require_once '_library/fb/facebook.php';

//Facebookアプリ設定
$config = array(
	'appId' => 'xxxxxxxxxxxxxxx',//アプリケーションID
	'secret' => 'xxxxxxxxxxxxxxx',//シークレット
);

$album_id = 'xxxxxxxxxxxxxxx';//FacebookアルバムのID
$callback = isset($_REQUEST['callback']) ? $_REQUEST['callback'] : '';

$file = 'json/'.$album_id.'.json';
if (!file_exists($file)){
	//フィードのキャッシュファイルが無い場合のみ、作成
	$facebook = new Facebook(array('appId'=>$config['appId'], 'secret'=>$config['secret']));
	$data = $facebook->api('/'.$album_id.'/photos?date_format=U&limit=50');
	for ($i=0; $i<sizeof($data['data']); $i++){
		$likes = $facebook->api('/'.$data['data'][$i]['id'].'/likes');
		$data['data'][$i]['likes'] = sizeof($likes['data']);
	}
	$json = json_encode($data);
	file_put_contents($file, $json);
} else {
	$json = file_get_contents($file);
}

if (empty($callback)) echo $json;
	else  echo "$callback($json)";
	
	