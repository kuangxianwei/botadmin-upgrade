$(function(){
$(".banner1").slide({ titCell:".num ul" , mainCell:".banner_pic" , effect:"leftLoop", autoPlay:true, delayTime:700 , autoPage:true });

	/*首页搜索下拉*/
	$(".drop_down").click(function(event) {
		if (event.stopPropagation) {
			//阻止时间冒泡
			event.stopPropagation(); 
			$(".dd_list").slideToggle(200)
		}else{
			event.cancelBubble = true;
			$(".dd_list").slideToggle(200)
		};
	});

	$(".dd_list span").click(function(event) {
		var val = $(this).html();

		$(".dd_list").slideUp(200);
		$(this).addClass('current_dd_span').siblings().removeClass('current_dd_span');
		$(".drop_down").html(val);

	});

	//点击空白处收起
	$("body").click(function(event) {
		$(".dd_list").slideUp(200);
	});

	/*导航下拉*/
	
	$('.nav ul li').mouseover(function(){
	
	$(this).find('.nav_dd').stop(true,true).slideDown();
	$(this).children("a").addClass("cur");
	});
	$('.nav ul li').mouseleave(function(){
	
	$(this).find('.nav_dd').stop(true,true).slideUp('fast');
	$(this).children("a").removeClass("cur");
	});

	/*自定义轮播*/
	$(".small_pic a").hover(function() {
		var index = $(".small_pic a").index(this);

		$(".big_pic a").eq(index).stop().fadeIn(100).siblings().stop().fadeOut(100);
		$(this).addClass('current_small_pic_a').siblings().removeClass('current_small_pic_a')
	});
	
	/*案例遮罩*/
	$(".anli_content ul li").hover(function() {
		$(this).find('.anli_zz').stop().animate({top:0,opacity:'1'}, 300)
	},function(){
		$(this).find('.anli_zz').stop().animate({top:'100%',opacity:0}, 300)
	});

	/*右侧定位导航*/
	$(".tel,.QQ,.back_top").hover(function() {
		$(this).find('a').stop().animate({'width':'140px','left':'-80px'}, 300)
	},function(){
		$(this).find('a').stop().animate({'width':'60px','left':0}, 300)
	});

	$(".side_nav ul li").eq(0).addClass('side_nav_3')//控制二维码
	$(".side_nav ul li").eq(0).hover(function() {
		$(this).find('span').stop().toggle(300)
	});
     //返顶
	 $('.back_top').click(function(){
        $('body,html').animate({scrollTop:0},500)
    });
	$('.linktop').click(function(){
        $('body,html').animate({scrollTop:0},500)
    });

	//首页快速导航特效
	$('.an1').hover(function(){$(this).addClass('bounce')},function(){$(this).removeClass('bounce')})
	$('.an2').hover(function(){$(this).addClass('jello')},function(){$(this).removeClass('jello')})
	$('.an3').hover(function(){$(this).addClass('rubberBand')},function(){$(this).removeClass('rubberBand')})
	$('.an4').hover(function(){$(this).addClass('fadeIn')},function(){$(this).removeClass('fadeIn')})
	$('.an5').hover(function(){$(this).addClass('flip')},function(){$(this).removeClass('flip')})
	$('.an6').hover(function(){$(this).addClass('swing')},function(){$(this).removeClass('swing')})
	//分享
	$(".shareDiv").hover(function(){
	 $(".shareList").css("display","block");	
  },function(){
	 $(".shareList").css("display","none");	
  })
	/*细节样式*/
	$(".zhuanjia_list ul li").first().siblings().css('margin-left', '6px');
	$(".anli_content ul li").first().css({
		'width': '350px',
		'height': '325px'
	});
	$(".anli_content ul li").eq(4).css({
		'width': '429px'
	});

	$(".anli_content ul li").first().siblings().css({'margin-left':'3px','margin-bottom':"3px"});

	//子页导航动画按钮
	

	aaa(31)//li的高度
	
	function aaa(hh){

		var h = hh;

		var ul = $("#left-type"); //
		var index_i = 0; //计数器
		var allH = $(".con1_class").height(); //容器高
		var oneN = parseInt(allH/h)-1; //容器内的个数

		$(".class_down").click(function(event) {
			var length = parseInt($("#left-type").height()/h);

			index_i++;

			if(index_i>=length-oneN){
				index_i = 0;
			}
			ul.stop().animate({top:-(index_i*h)}, 200)
		});

		$(".class_up").click(function(event) {
			var length = $("#left-type li").length;
			index_i--;
			if(index_i == -1){
				index_i = 0;
			}
			ul.stop().animate({top:-(index_i*h)}, 200)
		});
	}

})
