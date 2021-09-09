$(window).load(function() {
	var sbWidth=$(window).width();
	function configIframe(){
		
		var  fullWidth_height=$('.top').height();
		$('.flickerplate').css('margin-top',fullWidth_height);
		$('.ny_banner').css('margin-top',fullWidth_height);
		$('nav').css('top',fullWidth_height);
		
		sbWidth=$(window).width();
		if ( matchMedia( 'only screen and (max-width:767px)' ).matches ) {
			$(".content_left").insertAfter($(".content_right"));
			var $children = $(".page_list").children();
			$(".page_list").empty().append($children);	
			if(!($(".page_list a").length > 0)) {
				//元素不存在时执行的代码
				$(".page_list").empty();
			}   	
		}
	
		if ( sbWidth>880) {
			$("nav").show();
		}
	
	}
	if ( matchMedia( 'only screen and (min-width:1400px)' ).matches ) {
		headerFixed();
	} 	
	
	configIframe();

	/*窗口改变事件*/
	window.onresize = function () {
		/*window.location.reload();*/
		configIframe();
		
	}
	
	/*头部菜单按钮点击展开菜单事件*/
	var menu_flag=0;
	$('.btn-menu').click(function(event){
		if(menu_flag==0){     	
			$(this).toggleClass('active');
			$('.wrap_z').show();
			$('nav').show();
			menu_flag=1;
		}else{
			$(this).toggleClass('active');
			$('.wrap_z').hide();
			$('nav').hide();
			menu_flag=0;
		 }
		event.stopPropagation();
	});
	$('nav').click(function(event){
		 event.stopPropagation();
	});
	
	$(document).click(function(){
		if ( sbWidth<879 ) {
			$("nav").hide();
			$('.wrap_z').hide();
			$('.btn-menu').removeClass('active');
			 menu_flag=0;
		 }
	});
	
});

/*产品目录收缩*/
$(".pro_mulu>ul>li").hover(function() {
  $(".pro_mulu>ul>li>div").hide();
  $(".pro_mulu>ul>li").removeClass('on');
  $(this).addClass('on');
  $(this).children('div').show();
}, function() {
  
});

/*联系方式tab切换*/
$(".contact .tags_title .one").hover(function(){
	$(this).removeClass('ron');
	$(".contact .tags_title .two").addClass('ron');
	$(".contact .content2").hide();
    $(".contact .content1").show();
},function(){
    
});
$(".contact .tags_title .two").hover(function(){
	$(this).removeClass('ron');
	$(".contact .tags_title .one").addClass('ron');
	$(".contact .content1").hide();
    $(".contact .content2").show();
},function(){
    
});

/*头部悬浮样式*/
var headerFixed = function() {        
	var hd_height = $('#header').height();           
	$(window).on('load scroll', function(){                
		if ( $(window).scrollTop() > hd_height + 30 ) {
			$('#header').addClass('downscrolled');                      
		} else {                    
			$('#header').removeClass('downscrolled');                   
		}
		if( $(window).scrollTop() > 145 ) {
			$('#header').addClass('upscrolled');                    
		} else {
			$('#header').removeClass('upscrolled');                    
		}
	})            
}   


/* -----QQ 侧边悬浮 ---- */
$( ".suspension .a").bind("mouseenter", function(){
	var _this = $(this);
	var s = $(".suspension");
	var isService = _this.hasClass("a-service");
	var isServicePhone = _this.hasClass("a-service-phone");
	var isQrcode = _this.hasClass("a-qrcode");
	if(isService){ s.find(".d-service").show().siblings(".d").hide();}
	if(isServicePhone){ s.find(".d-service-phone").show().siblings(".d").hide();}
	if(isQrcode){ s.find(".d-qrcode").show().siblings(".d").hide();}
});
$(".suspension, .suspension .a-top").bind("mouseleave", function(){
	$(".suspension").find(".d").hide();
});
$(".suspension .a-top").bind("mouseenter", function(){
	$(".suspension").find(".d").hide(); 
});
$(".suspension .a-top").bind("click", ".suspension .a-top", function(){
	$("html,body").animate({scrollTop: 0});
});
$(window).scroll(function(){
	var st = $(document).scrollTop();
	var $top = $(".suspension .a-top");
	if(st > 400){
		$top.css({display: 'block'});
	}else{
		if ($top.is(":visible")) {
			$top.hide();
		}
	}
});


$('nav ul li p span').on('click', function() {       
	$('nav ul li').hide(); 	
	$(this).parents('li').show();
	$(this).parents('li').children('.menu2').show(); 
	$('nav .menu2 li').show(); 
});
$('nav ul li .menu2 p span').on('click', function() {
	if($("nav .menu2 li div.mulu2").find("a").length==0){ 
		return false;
	}else{
		$('nav ul li div.return1').hide(); 	
		$('nav ul li').hide(); 	
		$(this).parents('li').show();
		$(this).parents('li').children('div.mulu2').show(); 
	}
});

$('nav ul li div.return1').on('click', function() {        	
	$('nav .menu2').hide(); 	
	$('nav ul li').show(); 
});
$('nav ul li div.return2').on('click', function() {        	
	$('nav .menu2 li div.mulu2').hide();
	$('nav ul li div.return1').show(); 	
	$(this).parents('.menu2').children('li').show();
});

			   
	
