$(function() {	
	var bLazy = new Blazy({
			breakpoints: [{
		}]
      , success: function(element){
	    setTimeout(function(){
		var parent = element.parentNode;
		parent.className = parent.className.replace(/\bloading\b/,'');
	    }, 200);
        }
   });
   if($('video,audio').length > 0) {
         $('video,audio').mediaelementplayer();
   }
    
  var bodyH = $(".post-body").outerHeight(true);
  var appid = $(".post-body").data("hight");
    if( bodyH > appid) {
         $('.post-body').css("height",appid)
         $('.post-body').addClass("umHight")
         $('.post-body').append('<div class="readmore"><a href="javascript:void(0);" target="_self">阅读全文</a></div>');
         //console.log(bodyH)
   }
   
    $('.readmore a').on('click',function(){
      $(this).parents().find('.post-body').css("height","auto");
      $(this).parents().find('.post-body').css("padding-bottom","0")
      $(this).parent().remove()
	});
    
    
	$('.zoom').magnificPopup({
		disableOn: 200,
		type: 'iframe',
		mainClass: 'mfp-fade',
		removalDelay: 160,
		preloader: true,
		fixedContentPos: true
	});
	$('.header').after('<div id="leftNav" class="leftNav"><div class="mNav"></div><div id="mNavBtn" class="mNavBtn"><i class="icon iconfont">&#xe600;</i></div>');
	$('.headBox .nav').clone(false).appendTo('.mNav');
	$('.mNavBtn').click(function() {
        $('.leftNav').toggleClass("mOpen").siblings(".leftNav").removeClass("mOpen");
        $('.mask').slideToggle(0).siblings(".mask").slideToggle(0);
        $('body').toggleClass("open").siblings("body").removeClass("open");
    })

	$('.dot1').click(function(e) {
		console.log("");
		dropSwift($(this), '.sub1');
		e.stopPropagation();
	});
	$('.dot2').click(function(e) {
		dropSwift($(this), '.sub2');
		e.stopPropagation();
	});
	
	$('.navBar li').hover(function(){
       $(this).addClass('on');  
     },
	 function(){
       $(this).removeClass('on'); 
    });

	function dropSwift(dom, drop) {
		dom.next().slideToggle();
		dom.parent().siblings().find('.iconfont').removeClass('open');
		dom.parent().siblings().find(drop).slideUp();
		var iconChevron = dom.find('.iconfont');
		if (iconChevron.hasClass('open')) {
			iconChevron.removeClass('open');
		} else {
			iconChevron.addClass('open');
		}
	}
	/*搜索*/
	$('.ssBtn').on('click',function(){
		var $div = $(this);
		if($div.hasClass('off')){
		  $div.removeClass('off').addClass('no').html('&#xe600;');
		  $('.ssFrom').css("top","0");
		  $('.ssFrom').css("visibility","visible");
		  $('.mask').fadeIn(200);
		}else{
		  $div.removeClass('no').addClass('off').html('&#xe627;');
		  $('.ssFrom').css("top","-180%");
		  $('.ssFrom').css("visibility","hidden");
		}
	});
	
	$('.fullRead').on('click',function(){
		var $divRead = $(this);
		if($divRead.hasClass('off')){
		  $divRead.removeClass('off').addClass('no').html('&#xe622;');
		  $('body').addClass('reading');
		}else{
		  $divRead.removeClass('no').addClass('off').html('&#xe625;');
		  $('body').removeClass('reading');
		}
	});
	
	$('.phoneNav li').on('click',function(){
	  $(this).toggleClass('cur');
	  $(this).siblings().removeClass("cur");
	});
	
	if ( $(".phoneNav li").length > 5 ) {
	   $('.phoneNav').addClass('max');
       console.log('大于4...')
    }
	
	$(window).resize(function(){
		var $body = $('body').width();
		if($body > 640){
			$('.phoneNav li').removeClass("cur");
		}
	});
	
	$(document).click(function(e){
	  var _con = $('.phoneNav li'); 
	  if(!_con.is(e.target) && _con.has(e.target).length === 0){
		   $('.phoneNav li').removeClass('cur');
	  }
	});
	
	$(".ummodule4 h4").click(function(){
            if($(this).parent("li").hasClass("in")){
				$(this).nextAll(".info").slideUp(300,function(){
                    $(this).parent("li").removeClass("in");
                });			
            }else{
                $(this).parents("ul").find(".info").slideUp(300,function(){
                    $(this).parents("ul").find("li").removeClass("in");
                });
                $(this).nextAll(".info").slideDown(300,function(){
                    $(this).parent("li").addClass("in");
                });
            }
     });
	

	$('.reward').click(function(){
		$('#reward,.mask').fadeIn('100');	
	});

	
	$('.mask').click(function(){
	  $(this).fadeOut(300);
	  $('.leftNav').removeClass("mOpen");
	  $('body').removeClass("open");
	  $('#reward').fadeOut(0);
	    $('.ssFrom').css("top","-180%");
	    $('.ssFrom').css("visibility","hidden");
		$('.ssBtn').removeClass('no').addClass('off').html('&#xe627;');
	});
	
	$('.ssFrom .close').click(function(){
	    $('.ssFrom').css("top","-180%");
		$('.ssFrom').css("visibility","hidden");
		$('.ssBtn').removeClass('no').addClass('off').html('&#xe627;');
		$('.mask').fadeOut('100');
	});

});


$(function() {
	$(window).scroll(function(){		
		if($(window).scrollTop()>500){		
			$(".gotop").fadeIn('500');
		}else{
			$(".gotop").fadeOut('300');
		}
	});		
	$(".gotop").click(function(){
		$("body,html").animate({scrollTop:0},1500);
		return false;
	});		
});	

	$('.owl').owlCarousel({
	    loop:true,
		autoplay:true,
		autoplayTimeout:5000,
		autoplayHoverPause:true,
	    responsiveClass:false,
	    items:1,
		nav:false,
		autoHeight:false,
		dots:true,
		lazyLoad: true,
        lazyLoadEager: 1,
		navText : ["<i class='iconfont bx-prev'>&#xe660;</i>", "<i class='iconfont bx-next'>&#xe65f;</i>"],
	});
	
//导航高亮
jQuery(document).ready(function($){ 
var datatype=$("#navBox").attr("data-type");
    $(".nav>li").each(function(){
        try{
            var myid=$(this).attr("id");
            if("index"==datatype){
                if(myid=="nvabar-item-index"){
                    $("#nvabar-item-index").addClass("active");
                }
            }else if("category"==datatype){
                var infoid=$("#navBox").attr("data-infoid");
                if(infoid!=null){
                    var b=infoid.split(' ');
                    for(var i=0;i<b.length;i++){
                        if(myid=="navbar-category-"+b[i]){
                            $("#navbar-category-"+b[i]+"").addClass("active");
                        }
                    }
                }
	
            }else if("article"==datatype){
                var infoid=$("#navBox").attr("data-infoid");
                if(infoid!=null){
                    var b=infoid.split(' ');
                    for(var i=0;i<b.length;i++){
                        if(myid=="navbar-category-"+b[i]){
                            $("#navbar-category-"+b[i]+"").addClass("active");
                        }
                    }
                }
            }else if("page"==datatype){
                var infoid=$("#navBox").attr("data-infoid");
                if(infoid!=null){
                    if(myid=="navbar-page-"+infoid){
                        $("#navbar-page-"+infoid+"").addClass("active");
                    }
                }
            }else if("tag"==datatype){
                var infoid=$("#navBox").attr("data-infoid");
                if(infoid!=null){
                    if(myid=="navbar-tag-"+infoid){
                        $("#navbar-tag-"+infoid+"").addClass("active");
                    }
                }
            }
        }catch(E){}
    });
	$("#navBox").delegate("a","click",function(){
		$(".nav>li").each(function(){
			$(this).removeClass("active");
		});
		if($(this).closest("ul")!=null && $(this).closest("ul").length!=0){
			if($(this).closest("ul").attr("id")=="munavber"){
				$(this).addClass("active");
			}else{
				$(this).closest("ul").closest("li").addClass("active");
			}
		}
	});
});
//子分类高亮
jQuery(document).ready(function($){ 
var datatype=$("#subcate").attr("data-type");
    $(".subcate li").each(function(){
        try{
            var myid=$(this).attr("id");
            if("category"==datatype){
                var infoid=$("#subcate").attr("data-infoid");
                if(infoid!=null){
                    var b=infoid.split(' ');
                    for(var i=0;i<b.length;i++){
                        if(myid=="cate-category-"+b[i]){
                            $("#cate-category-"+b[i]+"").addClass("active");
                        }
                    }
                }
	
            } 
        }catch(E){}
    });
	
$("#subcate").delegate("a","click",function(){
		$(".subcate li").each(function(){
			$(this).removeClass("active");
		});
		if($(this).closest("ul")!=null && $(this).closest("ul").length!=0){
			if($(this).closest("ul").attr("id")=="subcate"){
				$(this).addClass("active");
			}else{
				$(this).closest("ul").closest("li").addClass("active");
			}
		}
	});	
});

///
$("#listCon div:first-child,#reward .list li:first-child").addClass("cur");
	$("#reward .list li:first-child").find("i").replaceWith('<i class="iconfont">&#xe67c;</i>');
	$("#reward .list li").click(function(){
	var i=$(this).index();
		$(this).addClass("cur").siblings().removeClass("cur");
		$("#listCon div:eq("+i+")").show().siblings().hide();
		$("#reward .list li").find("i").replaceWith('<i class="iconfont">&#xe67b;</i>');
		$(this).find("i").replaceWith('<i class="iconfont">&#xe67c;</i>');
});


$(function(){
    var umurl = location.href;
    $(".sbarBoxa li a").each(function() {
        if ($(this).attr("href")==umurl) $(this).parent().addClass("active");
    });
	
	
	$(".sbarBoxa li a").on("click", function() {
		var position = $(this)
			.parent()
			.position();
		var width = $(this)
			.parent()
			.width();
		$(".sbarBoxa .slide1").css({ opacity: 1, top: +position.top, width: width });
	});
	
	$(".sbarBoxa li a").on("mouseover", function() {
		var position = $(this)
			.parent()
			.position();
		var height = $(this)
			.parent()
			.height();
		$(".sbarBoxa .slide2")
			.css({
				opacity: 1,
				top: +position.top,
				height: height
			})
			.addClass("squeeze");
	});
	
	$(".sbarBoxa li a").on("mouseout", function() {
		$(".sidebar .slide2")
			.css({ opacity: 0 })
			.removeClass("squeeze");
	});
		
});