// JavaScript Document




/*
jQuery("#leftMarquee").slide({ mainCell:".bd ul",effect:"leftMarquee",vis:5,interTime:40,autoPlay:true });
jQuery(".slideTxtBox").slide();


$(".menu ul li:last").css("background","none");
$(".fr .floor2 ul li:nth-child(4),.fr .floor2 ul li:nth-child(8),.fr .floor2 ul li:nth-child(12)").css("margin-right","0px");
$(".chanpin ul li:nth-child(4),.chanpin ul li:nth-child(8),.chanpin ul li:nth-child(12)").css("margin-right","0px");

*/

	$(document).ready(function(){ 
		//mode:horizontal | vertical | fade 三种切换模式
		//$('#slider6').bxSlider({ mode:'vertical',autoHover:true,auto:true,pager: true,pause: 5000,controls:false});
		
		/*
		var i=$(".menu ul li").length;
		var j=1002/i-0.01;
		var k=(j-58)/2;
		$(".menu ul li").css("width",j);
		$(".menu ul li .sbmenu").css("width",j-1);
		$(".menu ul li > a").css("padding-left",k)
		$(".menu ul li a span").css("padding-right",k);
		$(".menu ul li:first a span").css("width","56px");
		
		
		
		
		
		
		$('.topli').hover(function(){
			$(this).find('.sbmenu').slideDown(300);
			},function(){
				$(this).find('.sbmenu').slideUp(200);
				})	
				
		*/
		
		jQuery("#leftMarquee").slide({ mainCell:".bd ul",effect:"leftMarquee",vis:5,interTime:40,autoPlay:true });
		jQuery(".topLoop").slide({ mainCell:".bd ul",effect:"topLoop",autoPlay:true,vis:1,scroll:1,trigger:"click"});
		$(".menu").children("ul").find("li:last").css("background","none");
		
		$(".menu ul li:last").css("margin-right","0");
		$(".lanmu ul li:last").css("margin-bottom","0");
		$(".head .sub .subnav ul:last").css("border-right","none");
		$(".head .sub .subnav").children("ul").find("li:first").addClass("first");
		
		
  var timer;
    var $li = $(".menu > ul >li:eq(3)");
    $li.mouseover(function() {
        if (!$li.find(".submenu").is(':visible')) {
            timer = setTimeout(function() {
                $li.find(".submenu").slideDown();
            }, 200);
        }
    }).mouseleave(function() {
        timer && clearTimeout(timer);
        $li.find(".submenu").slideUp();
    });
		
		$(".floor2 a.pic").hover(function() {
		$(this).addClass("shake");
	}, function() {
		$(this).removeClass("shake");
	});
		
		
		/*
		
		$(".menu ul li:nth-child(2)").mouseenter(function(){
			$(this).find(".sub").slideDown();
	    }).mouseleave(function(){
			$(this).find(".sub").stop().slideUp();
			})
		
		*/
		
		for( var i=0;i<=7;i++){
			$(".brl ul > li:eq("+i+")").addClass("li"+i);
		}
		
		
		
		//$(".menu ul li:last a").css("width","63px");
		
		//$(".chanpin ul li:nth-child(3),.chanpin ul li:nth-child(6),.chanpin ul li:nth-child(9),.chanpin ul li:nth-child(12)").css("margin-right","0px");
		$(".chanpin ul li:nth-child(4),.chanpin ul li:nth-child(8),.chanpin ul li:nth-child(12)").css("margin-right","0px");
		$(".floor2 ul.cpzs li:nth-child(4),.floor2 ul.cpzs li:nth-child(8),.floor2 ul.cpzs li:nth-child(12)").css("margin-right","0px");
		$(".f1r ul li:nth-child(4),.f1r ul li:nth-child(8),.f1r ul li:nth-child(12)").css("margin-right","0px");
		$(".alzs dl:nth-child(4),.alzs dl:nth-child(8),.alzs dl:nth-child(12)").css("margin-right","0px");
		$(".fwxm a:nth-child(2),.fwxm a:nth-child(4),.fwxm a:nth-child(6)").css("margin-right","0px");

	});
