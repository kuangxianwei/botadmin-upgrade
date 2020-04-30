$(function(){
	$("#cod").click(function(){
		$(this).attr("src","./data/vdimgck.php?" + Math.random());
	})

	$("input,textarea").not(".G_botton").each(function(){
		$(this).focus(function(){
			$(this).css("background","#F6F6F6");
		}).blur(function(){
			$(this).css("background","#FFF");
		}).hover(function(){
			$(this).css("background","#FAFAFA");
		},function(){
			$(this).css("background","#fff");
		});
	});
	
	$(".borderLi").hover(function(){
		$(this).css("border-bottom","1px solid #dedede");
		$(this).css("color","#F00");
	},function(){
		$(this).css("border-bottom","1px dashed #dedede");
		$(this).css("color","#000");
	});
	
	$("#leave_word").submit(function(){
		if($.trim($("input[name='name']").val())==''){
			alert("对不起，请填写您的姓名！");
			$("input[name='name']").focus();
			return false;
		}else if($.trim($("input[name='telephone']").val())==''){
			alert("对不起，请填写您的联系电话！");
			$("input[name='telephone']").focus();
			return false;
		}else if($.trim($("input[name='address']").val())==''){
			alert("对不起，请填写您的联系地址！");
			$("input[name='address']").focus();
			return false;
		}else if($.trim($("textarea").val())==''){
			alert("对不起，请填写留言内容！");
			$("textarea").focus();
			return false;
		}else if($.trim($("input[name='checkCode']").val())==''){
			alert("对不起，请填写验证码！");
			$("input[name='checkCode']").focus();
			return false;
		}
	});
	$("#forTheJob").submit(function(){
		var error = 0;
		$(".inputText,textarea").each(function(){
			var val = $.trim($(this).val());
			if(val==''){
				alert("请认真填写您的信息，以便我们能更多的了解您！");
				error++;
				$(this).focus();
				return false;
			}
		});
		if(error>0){
			return false;
			$("input[error='0']").focus();
		}
	});

	$("#online_order").submit(function(){
		if($.trim($("input[name='name']").val())==''){
			alert("请填写您的姓名！");
			$("input[name='name']").focus();
			return false;
		}else if($.trim($("input[name='telephone']").val())==''){
			alert("请填写您的联系电话！");
			$("input[name='telephone']").focus();
			return false;
		}else if($.trim($("input[name='address']").val())==''){
			alert("请填写您的联系地址！");
			$("input[name='address']").focus();
			return false;
		}else if($.trim($("input[name='num']").val())==''){
			alert("请填写您的订购数量！");
			$("input[name='num']").focus();
			return false;
		}else if($.trim($("input[name='checkCode']").val())==''){
			alert("请填写验证码！");
			$("input[name='checkCode']").focus();
			return false;
		}
		if(!confirm("确定提交订单信息吗？")){
			return false;
		}
	});
	jQuery.extend({
		FlashFont:function(obj){
			//$(obj).css("color",$(obj).css("color")=="#297eae"?"#f00":"#297eae");
			//$(obj).css("color",$(obj).css("color")=="rgb(41, 126, 174)"?"rgb(255, 0, 0)":"rgb(41, 126, 174)");
			$(obj).css("color",$(obj).css("color")=="red"?"steelblue":"red");
		}
	});
	setInterval("$.FlashFont('#topPhone')",750);
	
	$("#nav_menu").hover(function(){
		$(this).removeClass("nav").addClass("nav_hover");
		$("#nav_menu_list").show();
	},function(){
		$(this).removeClass("nav_hover").addClass("nav");
		$("#nav_menu_list").hide();
	});
	
	//HEADER SLIDE START
	$("#slide_bg").fadeTo('fast',0.3);
	
	 var len  = $("#idNum > ul > li").length;
	 var index = 0;
	 $("#idNum li").mouseover(function(){
		index  =   $("#idNum li").index(this);
		showImg(index);
	});	
	 //滑入 停止动画，滑出开始动画.
	 $('#flashLeft').hover(function(){
			  if(MyTime){
				 clearInterval(MyTime);
			  }
	 },function(){
			  MyTime = setInterval(function(){
			    showImg(index)
				index++;
				if(index==len){index=0;}
			  } , 2000);
	 });
	 //自动开始
	 var MyTime = setInterval(function(){
		showImg(index)
		
		if(index==0){++index;s=0;}
		else{
			if(index<len && s==0){
				++index;
			}
			if(index<=len && s==1){
				--index;
				s=1
			}
			if(index==len){		
				index=len-1;
				s=1
			}
		}
	 } , 2000);	
})

function showImg(i){
		$("#idSlider").stop(true,false).animate({top : -263*i},800);
		 $("#idNum li")
			.eq(i).addClass("on")
			.siblings().removeClass("on");
}

function addFavourite()
{
    if (document.all)
       {
         window.external.addFavorite(document.URL,document.title);
       }
      else if (window.sidebar)
      {
          window.sidebar.addPanel(document.title,document.URL,"");
    }
}


//设为首页
function setHomepage(){
  if (document.all){
    document.body.style.behavior='url(#default#homepage)';
    document.body.setHomePage(document.URL);
  }else if (window.sidebar){
        if(window.netscape){
       try{
          netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
       }catch (e){
                    alert( "该操作被浏览器拒绝，如果想启用该功能，请在地址栏内输入 about:config,然后将项 signed.applets.codebase_principal_support 值该为true" );
       }
        }
    var prefs = Components.classes['_40mozilla.org/preferences-service;1'].getService(Components. interfaces.nsIPrefBranch);
    prefs.setCharPref('browser.startup.homepage',document.URL);
    }
}

//resize image
function DrawImage(ImgD,FitWidth,FitHeight){  
    var image=new Image();  
    image.src=ImgD.src;  
    if(image.width>0 && image.height>0){  
        if(image.width/image.height>= FitWidth/FitHeight){  
            if(image.width>FitWidth){  
                ImgD.width=FitWidth;  
                ImgD.height=(image.height*FitWidth)/image.width;  
            }  
            else{  
                ImgD.width=image.width;  
                ImgD.height=image.height;  
            }  
        }  
        else{  
            if(image.height>FitHeight){  
                ImgD.height=FitHeight;  
                ImgD.width=(image.width*FitHeight)/image.height;  
            }  
            else{  
                ImgD.width=image.width;  
                ImgD.height=image.height;  
            }  
        }  
    }  
}  
