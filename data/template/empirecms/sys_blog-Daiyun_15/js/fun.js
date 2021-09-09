$(function(){
	$(".phone-por-menu dl").each(function() {
		var $nav = $(this);
        if(window.location.href.indexOf($nav.find("a").attr("href")) != -1){
			$nav.addClass("left-hover")
				.siblings().removeClass("left-hover");
		};
    });
	
	$(".nav li").each(function() {
		var $nav = $(this);
        if(window.location.href.indexOf($nav.find("a").attr("href")) != -1){
			$nav.addClass("navon")
				.siblings().removeClass("navon");
		};
    });
	
	
	
})