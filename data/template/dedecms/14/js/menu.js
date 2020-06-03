
	$(document).ready(function(){ 
		//mode:horizontal | vertical | fade 涓夌鍒囨崲妯″紡
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
		$(".menu ul li:last").css("background","none");
		$(".menu ul li:last a").css("width","120px");
		
		//$(".chanpin ul li:nth-child(3),.chanpin ul li:nth-child(6),.chanpin ul li:nth-child(9),.chanpin ul li:nth-child(12)").css("margin-right","0px");
		$(".chanpin ul li:nth-child(4),.chanpin ul li:nth-child(8),.chanpin ul li:nth-child(12)").css("margin-right","0px");
		$(".alzs dl:nth-child(4),.alzs dl:nth-child(8),.alzs dl:nth-child(12)").css("margin-right","0px");
		$(".fwxm a:nth-child(2),.fwxm a:nth-child(4),.fwxm a:nth-child(6)").css("margin-right","0px");

	});

// nav menu
var timeout	= 100;
var closetimer	= 0;
var ddmenuitem	= 0;

// open hidden layer
function mopen(id)
{	
	// cancel close timer
	mcancelclosetime();

	// close old layer
	if(ddmenuitem) ddmenuitem.style.visibility = 'hidden';

	// get new layer and show it
	ddmenuitem = document.getElementById(id);
	ddmenuitem.style.visibility = 'visible';

}
// close showed layer
function mclose()
{
	if(ddmenuitem) ddmenuitem.style.visibility = 'hidden';
}

// go close timer
function mclosetime()
{
	closetimer = window.setTimeout(mclose, timeout);
}

// cancel close timer
function mcancelclosetime()
{
	if(closetimer)
	{
		window.clearTimeout(closetimer);
		closetimer = null;
	}
}
