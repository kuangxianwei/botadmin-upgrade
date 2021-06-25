$(function(){
	//链接打开方式
	if (window.screen.width < 760) {
		$("a").attr("target", "_self")
	};
	//导航
	$('#navClick').click(function() {
		$('.navBox').slideToggle()
	});
});

document.writeln("<div style=\'display:none\'><script type=\'text/javascript\' src=\'https://s4.cnzz.com/z_stat.php?id=110&web_id=120\'></script></div>");