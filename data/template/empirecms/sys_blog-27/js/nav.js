
$(window).scroll(function(){
	var scrolly = $(document).scrollTop();
    if (scrolly > 50){ 
    	$('#y-nav-top').fadeIn("slow");;
    }else{
    	$('#y-nav-top').fadeOut("fast");
    }
}) ;
$("#y-nav-top").click(function(){
	$('body,html').animate({scrollTop:0},1000);
});
$("#ynavadmin").on({  
	mouseover : function(){  
		$(".y-nav-admin").css("display","block");
	} ,  
	mouseout : function(){  
		$(".y-nav-admin").css("display","none") ;  
	}   
}) ;  
$("#ynavweixin").on({  
	mouseover : function(){  
		$(".y-nav-weixin").css("display","block");
	} ,  
	mouseout : function(){  
		$(".y-nav-weixin").css("display","none") ;  
	}   
}) ; 
//图片自适应大小不变形
var $ssimg = $("#ssimg").width();
var $simg = $ssimg/1.6;
$(".simg").css("height",$simg);
//移动导航  
$("#xiala").on("click", function(){$("#yd-nav").slideToggle(100);$(".waphead-lf i").toggleClass("fa-times onhover");});
$("#guanbi").on("click", function(){$("#yd-nav").slideToggle(100);});
//搜索
$("#sousuo").on("click", function(){$(".sousuo").slideToggle(500);$("#sousuo i").toggleClass("fa-times onhover");});
$("#sguanbi").on("click", function(){$(".sousuo").slideToggle(500);$(".waphead-lr i").toggleClass("fa-times onhover");$("#sousuo i").toggleClass("fa-times onhover");}); 

