$(function(){
	/*顶部下拉菜单*/
	$('.nav li').each(function(){
		if($(this).children('ul').length > 0){
			$(this).children('a').after('<em></em>');
		}
	});
	$('.nav li').hover(function(){
		$(this).addClass('on').children('ul').addClass('show');
	},function(){
		$(this).removeClass('on').children('ul').removeClass('show');
	});
	/*搜索框*/
	$('.search .btn').click(function(){
		$(this).siblings('.searchForm').fadeToggle(0);
		$('.navBtn, .nav').removeClass('open');
	});
	/*手机导航按钮*/
	$('.navBtn').click(function(){
		$(this).toggleClass('open');
		$('.nav').toggleClass('open');
		$('.searchForm').removeAttr('style');
	});
	
	/*手机下拉菜单*/
	$('.nav li em').click(function(){
		$(this).toggleClass('open').siblings('ul').toggleClass('open').parent().siblings('li').children('em').removeClass('open').siblings('ul').removeClass('open');
	});
	/*手机二级菜单*/
	$('.subMenu span').click(function(){
		$(this).siblings('ul').toggleClass('open');
	});
	if($('.entry img').length > 0){
	    $('.entry img').removeAttr('height','auto');
	    $('.entry img').css('height','auto');
	}
	/*首页幻灯片*/
	if($('#slides').length > 0){
		$("#slides").on('initialize.owl.carousel initialized.owl.carousel ',
		function(e) {
			$('div.load').remove();                 
		});
		$('#slides').owlCarousel({
			items:1,
			loop:true, 
			mouseDrag:true,
			autoplay:true,
			nav:false,	
			dots:true
		}); 
	}
});
