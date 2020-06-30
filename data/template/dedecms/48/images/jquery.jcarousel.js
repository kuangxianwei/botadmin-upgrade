/**
 *  jQuery jcarousel Plugin
 *  @requires jQuery v1.4.2
 *  http://www.designsor.com/jcarousel/
 *  auther:Xiaojue
 *  Version: 1.0
 *  Version: 2.0 //增加一些报错机制，滚动效果改为平滑的头尾相接
 */
(function($j){
	//jcarousel的初始化设置  
	 $j.fn.jcarousel = function(options){
		  var defaults = {
		   width:480, //宽
       	   height:180,	//高	
		   photo:[{"url":'images/home_banner_1.jpg',"href":'JavaScript:void(0)',"target":'_blank',"title":''},{"url":'images/home_banner_2.jpg',"href":"JavaScript:void(0)","target":"_blank","title":''},{'url':'images/home_banner_3.jpg',"href":'JavaScript:void(0)',"title":''},{"url":'images/home_banner_4.jpg.jpg',"href":'JavaScript:void(0)',"title":''},{'url':'images/home_banner_5.jpg',"href":'JavaScript:void(0)',"title":''}], //参数
		   jclass:"jcarousel", //默认样式
		   speed:300, //速度
		   timeout:3000 //间隔
	};
    var options = $j.extend(defaults, options);

	return this.each(function(index) {
							 
	 	var $jthis = $j(this);
		if(options.photo.length==0){return;}
		    $jthis.css({"width":options.width,"height":options.height});
		var myvars={}
		myvars.flg=0; //浮标
		myvars.t;
		//创建轮播层
		var creatcarousel=function(){
			var jcarousel=$j('<div class='+options.jclass+'>'); //最外层容器
			var picsloer=$j('<div class="slor">');
			var jul=$j('<ul>');
			jul.appendTo(jcarousel);
			picsloer.css({"position":"relative"}).appendTo(jcarousel);
			
			jcarousel.css({"overflow":"hidden",
						  "width":options.width,
						  "height":options.height,
						  "position":"relative"
						  }).appendTo($jthis);
			
			$j.each(options.photo,function(i,n){
			$j('<img>',{"src":options.photo[i]['url'],"width":options.width,"height":options.height,"title":options.photo[i]['title']})
			.css({"position":"absolute",
				 "top":0,
				 "left":i*options.width
				 })
			.appendTo(picsloer);
			
			$j('<li>',{text:(i+1)}).appendTo(jul);
			
			});
			
			
			picsloer.children('img').each(function(i){$j(this).wrap('<a href="'+options.photo[i]['href']+'"></a>')})
			
			
			$j('<img>',{"src":options.photo[0]['url'],"width":options.width,"height":options.height,"title":options.photo[0]['title'],"class":"clone"})
			.css({"position":"absolute",
				 "top":0,
				 "left":options.width
				 })
			.appendTo(jcarousel);
			
			
			$jthis.find("li").css({"cursor":"pointer"}).hover(function(){
							myvars.flg=$j(this).index();										  
							$j(this).addClass("lihover").siblings().removeClass("lihover");
							$jthis.find('.slor').stop(false);
							$jthis.find('.slor').animate({left:-(myvars.flg*options.width)},options.speed);
							myvars.flg=myvars.flg+1;
							},function(){});												 
		}
	  creatcarousel();
	  //自动定时滚动
	  var starmove=function(){
		  		if(options.photo.length!=1){
				if(myvars.flg==1){$jthis.find('.slor').css("left","0px");$jthis.find('.clone').css({"left":options.width});$jthis.find('.slor').animate({left:-(myvars.flg*options.width)},options.speed);}
				
				$jthis.find("li").removeClass('lihover').end().find("li:eq("+myvars.flg+")").addClass('lihover');
				
				
				$jthis.find('.slor').animate({left:-(myvars.flg*options.width)},options.speed);
				
				if(myvars.flg==options.photo.length){
				$jthis.find("li").removeClass('lihover').end().find("li:eq(0)").addClass('lihover');
				
				$jthis.find('.clone').animate({left:"0px"},options.speed);
				
				}
				
				
				
				if(myvars.flg==options.photo.length){myvars.flg=0;}
				
				myvars.flg=myvars.flg+1;
				
				myvars.t=setTimeout(starmove,options.timeout);
				
				}
	  }
	  starmove();
	  //控制
	  $jthis.hover(function(){
			clearTimeout(myvars.t);
						},function(){
			myvars.t=setTimeout(starmove,options.timeout)
						});
	  //clone
	  $jthis.find('.clone').hover(function(){
			$jthis.find('.clone').css({"left":options.width});
			$jthis.find('.slor').css({"left":"0px"});
										  },function(){})
	 return this;
	 });
}})(jQuery);
