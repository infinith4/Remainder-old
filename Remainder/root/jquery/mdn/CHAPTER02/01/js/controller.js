$(function(){
	
	var viewerSetting = {
		color : 'rgb(255,255,255)',
		backgroundColor : 'rgb(0,0,0)',
		fontSize : '14px',
		lineHeight : '1.5em',
		letterSpacing : '0em'
	}

	if($.cookies.test() && $.cookies.get('viewerSetting')){
		$.cookies.get('viewerSetting');
		viewerSetting = $.cookies.get('viewerSetting');
	}
	
	$('#Viewer').css(viewerSetting);
	
	
	function setValue(key, value)
	{
		$('#Viewer')
			.css(key,value);
		
		if($.cookies.test()){
			viewerSetting[key] = value;
			$.cookies.set('viewerSetting',viewerSetting)
		}
	}
	
	$('#FontColor>ul>li')
		.each(function(){
			if($(this).css('backgroundColor') == $('#Viewer').css('color'))
			{
				$(this).addClass('current');
			}
		})
		.click(function(e){
			
			setValue('color',$(this).css('background-color'));
			
			$('#FontColor>ul>li').removeClass('current')
			$(this).addClass('current');
			
		});
	
	$('#BgColor>ul>li')
		.each(function(){
			if($(this).css('backgroundColor') == $('#Viewer').css('backgroundColor'))
			{
				$(this).addClass('current');
			}
		})
		.click(function(e){
			setValue('backgroundColor',$(this).css('background-color'));
			
			$('#BgColor>ul>li').removeClass('current')
			$(this).addClass('current');
			
		});
	
	$('#SizeSelector')
		.slider({
			min : 8,
			max : 64,
			step : 1,
			value : viewerSetting['fontSize'].substring(0,viewerSetting['fontSize'].length-2),
			slide : function(event ,ui)
			{
				setValue('fontSize',ui.value + 'px');
			}
		});
	
	$('#HeightSelector')
		.slider({
			min : 1,
			max : 3,
			step : .1,
			value : viewerSetting['lineHeight'].substring(0,viewerSetting['lineHeight'].length-2),
			slide : function(event ,ui)
			{
				setValue('lineHeight', ui.value + 'em');
			}
		});
	
	$('#SpaceSelector')
		.slider({
			min : 0,
			max : 2,
			step : .1,
			value : viewerSetting['letterSpacing'].substring(0,viewerSetting['letterSpacing'].length-2),
			slide : function(event ,ui)
			{
				setValue('letterSpacing',ui.value + 'em');
			}
		});
	
});