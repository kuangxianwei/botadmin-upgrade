$(document).ready(function($) {
	// 手机导航
	$('.menuBtn').append('<b></b><b></b><b></b>');
	$('.menuBtn').click(function(event) {
		$(this).toggleClass('open');
		var _winw = $(window).width();
		var _winh = $(window).height();
		if( $(this).hasClass('open') ){
			$('body').addClass('open');
			if( _winw<=767 ){
				$('.nav').stop().slideDown();
			}
		}else{
			$('body').removeClass('open');
			if( _winw<=767 ){
				$('.nav').stop().slideUp();
			}
		}
	});
	

	// 导航
	function myNav(){
		var _winw = $(window).width();
		if( _winw>767 ){
			$('.nav').show();
			$('.nav li').bind('mouseenter',function() {
				$(this).find('dl').stop().slideDown();
				if( $(this).find('dl').length ){
					$(this).addClass('ok');
				}
			});
			$('.nav li').bind('mouseleave',function() {
				$(this).removeClass('ok');
				$(this).find('dl').stop().slideUp();
			});
			$('body,.menuBtn').removeClass('open');
		}else{
			$('.nav').hide();
			$('.nav li').unbind('mouseenter mouseleave');
		}
	}
	myNav();
	$(window).resize(function(event) {
		myNav();
	});
	
	
	// 导航产品下拉
	$('.head-nav .nav .cpdh').bind('mouseenter',function() {
		$('body').find('.cp_class').stop().slideDown();
	});
	$('.head-nav .nav .cpdh').bind('mouseleave',function() {
		$('body').find('.cp_class').stop().slideUp();
	});
	
	$('.head-nav .cp_class').bind('mouseenter',function() {
		$('body').find('.cp_class').stop().slideDown();
	});
	$('.head-nav .cp_class').bind('mouseleave',function() {
		$('body').find('.cp_class').stop().slideUp();
	});
	
	
	// 切换语言
	$('.topBar .engdiv').bind('mouseenter',function() {
		$(this).find('.fr-eng').stop().slideDown();
	});
	$('.topBar .engdiv').bind('mouseleave',function() {
		$(this).find('.fr-eng').stop().slideUp();
	});
	
	// 顶部微信弹出
	$('.topBar .wxdiv').bind('mouseenter',function() {
		$(this).find('.fr-wx').stop().slideDown();
	});
	$('.topBar .wxdiv').bind('mouseleave',function() {
		$(this).find('.fr-wx').stop().slideUp();
	});

	
    // 微信弹出
    $('.phone-foot .wx').click(function(){
    	$('body').find('.foot-wx').fadeToggle();
    });
    $('.foot-wx .ewm-bg').click(function(){
    	$(this).parent('.foot-wx').fadeOut();
    });

    // 返回顶部
    $('.toTop').click(function(){
        $('body,html').animate({
            'scrollTop':0
        }, 500);
    });
    $(window).scroll(function(){
        var _top = $(window).scrollTop();
        if( _top<200 ){
            $('.toTop').stop().fadeOut(500);
        }else{
            $('.toTop').stop().fadeIn(500);
        }
    });



    $(".TAB li").mousemove(function(){
    	var $vv=$(this).parent(".TAB").attr("id");
    	$($vv).hide();
    	$(this).parent(".TAB").find("li").removeClass("hover");
    	var xx=$(this).parent(".TAB").find("li").index(this);
    	$($vv).eq(xx).show();
    	$(this).addClass("hover");
    });

    //侧导航
    	//$(".menu_first").click(function() {
//    	$(this).next('dd').slideToggle('fast').siblings('dd').stop().slideUp()
//     });
//
    	$(".phone-por-menu dt").click(function() {
    	    $(this).parents("dl").toggleClass("on").siblings('dl').removeClass('on').find('dd').stop().slideUp();
    	if($(this).parents('dl').hasClass('on')) {
    	    $(this).next("dd").stop().slideDown();
    	}else{
    	    $(this).next("dd").stop().slideUp();
    	}
    	});
});