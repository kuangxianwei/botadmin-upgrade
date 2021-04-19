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
	$('.schBtn').click(function(){
		$('.search').fadeToggle(0);
		$('.navBtn, .nav').removeClass('open');
	});
	/*手机导航按钮*/
	$('.navBtn').click(function(){
		$(this).toggleClass('open');
		$('body, .nav').toggleClass('open');
		$('.search').removeAttr('style');
	});
	
	/*手机下拉菜单*/
	$('.nav li em').click(function(){
		$(this).toggleClass('open').siblings('ul').toggleClass('open').parent().siblings('li').children('em').removeClass('open').siblings('ul').removeClass('open');
	});	
	if($('.entry img').length > 0){
	    $('.entry img').removeAttr('height','auto');
	    $('.entry img').css('height','auto');
	}
});

jQuery(document).ready(function() {
    jQuery('.sidebar').theiaStickySidebar({
      // Settings
      additionalMarginTop: 30
    });
  });

