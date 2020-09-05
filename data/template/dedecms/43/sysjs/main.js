function killErrors() {
	return true;
}
window.onerror = killErrors;


function slideSwitch() {
	var $current = $("#slideshow div.current");

	// 判断div.current个数为0的时候 $current的取值
	if ( $current.length == 0 ) $current = $("#slideshow div:last");

	// 判断div.current存在时则匹配$current.next(),否则转到第一个div
	var $next =  $current.next().length ? $current.next() : $("#slideshow div:first");
	$current.addClass('prev');

	$next.css({opacity: 0.0}).addClass("current").animate({opacity: 1.0}, 1000, function() {
			//因为原理是层叠,删除类,让z-index的值只放在轮转到的div.current,从而最前端显示
			$current.removeClass("current prev");
		});
}
/*
function slideProduct() {
	var $current = $("#ihotpro div.current");

	// 判断div.current个数为0的时候 $current的取值
	if ( $current.length == 0 ) $current = $("#ihotpro div:last");

	// 判断div.current存在时则匹配$current.next(),否则转到第一个div
	var $next =  $current.next().length ? $current.next() : $("#ihotpro div:first");
	$current.addClass('prev');

	$next.css({opacity: 0.0}).addClass("current").animate({opacity: 1.0}, 1000, function() {
			//因为原理是层叠,删除类,让z-index的值只放在轮转到的div.current,从而最前端显示
			$current.removeClass("current prev");
		});
}*/

//等比例缩放图片
 /**
   * ImgD：原图
   * maxWidth：允许的最大宽度
   * maxHeight：允许的最大高度
   */

function DrawImage(ImgD, maxWidth, maxHeight){
  var image=new Image();
  var iwidth = maxWidth; //定义允许图片宽度
  var iheight = maxHeight; //定义允许图片高度
  image.src=ImgD.src;
  if(image.width>0 && image.height>0){
   flag=true;
   if(image.width/image.height>= iwidth/iheight){
    if(image.width>iwidth){
     ImgD.width=iwidth;
     ImgD.height=(image.height*iwidth)/image.width;
    }else{
     ImgD.width=image.width;
     ImgD.height=image.height;
    }
    //ImgD.alt=image.width+"×"+image.height;
   } else{
    if(image.height>iheight){
     ImgD.height=iheight;
     ImgD.width=(image.width*iheight)/image.height;
    }else{
     ImgD.width=image.width;
     ImgD.height=image.height;
    }
    //ImgD.alt=image.width+"×"+image.height;
   }
  }
 }

function showproduct(value){
	for (var ii = 0; ii <= 10; ii++){
		var mainpro = document.getElementById("mainpro" + ii);
		var subpro = document.getElementById("subpro" + ii);
		if( mainpro == null ) break;
		if(ii == value){
			mainpro.className="current";
			subpro.style.display="block";
		}else if(ii != value){
			mainpro.className="";
			subpro.style.display="none";
		}
	}
}

function AutoScroll(obj){
        $(obj).find("li:first").animate({
                marginTop:"-25px"
        },500,function(){
                $(this).css({marginTop:"0px"}).find("li:first").appendTo(this);
        });
}


function includefile( filename ) {
	var new_script = document.createElement( "script" );
	new_script.defer=true;
	//window.open(to_url);
	new_script.src = filename;
	//alert( new_script );
	document.body.appendChild(new_script);
	//document.getElementsByTagName("HEAD")[0].appendChild(new_script);
	//alert(gg);
}


function NavigationSelect( obj, classId ) {
	$("#"+obj +" a").each(function(){
		$(this).removeClass( "current" );
		//alert( $(this).html() );
	});

	$("#lnk"+classId).addClass( "current" );
}


$(document).ready(function(){
	$("#slideshow div").eq(1).addClass("current");
	//$(".current").css("opacity","1.0");

	// 设定时间为3秒(1000=1秒)
	slideSwitch();
    setInterval( "slideSwitch()", 5000 );

	if ( $('.dvbi_image') != null ) {
		if ( $('.dvbi_image img') != null ) {
			if ( $('.dvbi_image img').eq(0).attr("src") != "undefined" ) {
				$('.dvbi_image').hide();
			}
		}
	}	//if ( $('.dvbi_image') != null ) {


	includefile( "sysimages/MessageLeftBox.js" );
});
