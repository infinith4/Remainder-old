$(document).ready(function() {
	/*リスト要素の順番を反転*/
	var li = $('#contentsList li').toArray().reverse();
	$('#contentsList').empty().append(li);
	/*アコーディオンの設定*/
	$("#contentsList").zAccordion({
		timeout: 10000,
		slideWidth: 460,
		width: 760,
		height: 400,
		speed: 500,
		startingSlide: 5,
		slideClass: "frame",
		slideOpenClass: "frame-open",
		slideClosedClass: "frame-closed",
		slidePreviousClass: "frame-previous",
		easing: "easeInOutCubic",
		invert: true
	});
});