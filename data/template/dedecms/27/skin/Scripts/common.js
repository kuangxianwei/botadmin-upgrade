// JavaScript Document
function doZoom(size)
{
 $("#NewsDetails").css("font-size",size+"px");
}
/***********加入收藏***************/
function AddFavorite(sURL, sTitle)
{
    try
    {
       window.external.addFavorite(sURL, sTitle); 
    }
    catch (e)
    {
        try
        {
            window.sidebar.addPanel(sTitle, sURL, "");
        }
        catch (e)
        {
            alert("加入收藏失败，请使用Ctrl+D进行添加");
        }
    }
}
/***********设为首页***************/
function SetHome(obj,vrl){
        try{
                obj.style.behavior='url(#default#homepage)';obj.setHomePage(vrl);
        }
        catch(e){
                if(window.netscape) {
                        try {
                                netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");  
                        }  
                        catch (e)  { 
                                alert("此操作被浏览器拒绝！请在浏览器地址栏输入“about:config”并回车然后将[signed.applets.codebase_principal_support]设置为'true'");  
                        }
                        var prefs = Components.classes['@mozilla.org/preferences-service;1'].getService(Components.interfaces.nsIPrefBranch);
                        prefs.setCharPref('browser.startup.homepage',vrl);
                 }
        }
}
function SetCookie(name,value,t)//两个参数，一个是cookie的名子，一个是值
{
    var Days = t; //此 cookie 将被保存 30 天
    var exp  = new Date();    //new Date("December 31, 9998");
    exp.setTime(exp.getTime() + Days*24*60*60*1000);
    document.cookie = name + "="+ escape (value) + ";expires=" + exp.toGMTString();
}
function getCookie(name)//取cookies函数        
{
    var arr = document.cookie.match(new RegExp("(^| )"+name+"=([^;]*)(;|$)"));
     if(arr != null) return unescape(arr[2]); return null;

}
function delCookie(name)//删除cookie
{
  var expDate=new Date();
  expDate.setTime(expDate.getTime()-1);
  document.cookie=name+'='+';expires='+expDate.toGMTString();
}
function isusername (s)
 {
         var regu = "^([_a-zA-Z]+[_0-9a-zA-Z]*)$"
         var re = new RegExp(regu);
         if (s.search(re) != -1) {
           return true;
         } else {
           return false;
         }
  }
 function ispassword (s)
 {
         var regu = "^([_a-zA-Z]+[_0-9a-zA-Z]*)$"
         var re = new RegExp(regu);
         if (s.search(re) != -1) {
           return true;
         } else {
           return false;
         }
  }
function isemail (s)
{
        if (s.length > 50)
        {
                return false;
        }
         var regu = "^(([0-9a-zA-Z]+)|([0-9a-zA-Z]+[_.0-9a-zA-Z-]*[_.0-9a-zA-Z]+))@([a-zA-Z0-9-]+[.])+(.+)$";
         var re = new RegExp(regu);
         if (s.search(re) != -1) {
               return true;
         } else {
               return false;
         }
}
function isMobile(object)   
{   
            var s =object;    
            var reg0 = /^13\d{5,9}$/;   
            var reg1 = /^153\d{4,8}$/;   
            var reg2 = /^159\d{4,8}$/;   
            var reg3 = /^0\d{10,11}$/;   
            var my = false;   
            if (reg0.test(s))my=true;   
            if (reg1.test(s))my=true;   
            if (reg2.test(s))my=true;   
            if (reg3.test(s))my=true;   
            return my;
}
/***********页面跳转****************/
function gourl(url,target)
{
	if(url!="")
	{
		if(target=="blank")
		{
		window.open(url);
		}else
		{
			location.href=url;
		}
	}
}
 function ResizeImages(w,h)
{
   var myimg,oldwidth,oldheight;
   var maxwidth=w;
   var maxheight=h
   var myimg = document.getElementById('imgContent');   //如果你定义的id不是article，请修改此处
     if(myimg.width > myimg.height)
     {
         if(myimg.width > maxwidth)
         {
            oldwidth = myimg.width;
            myimg.height = myimg.height * (maxwidth/oldwidth);
            myimg.width = maxwidth;
         }
     }else{
         if(myimg.height > maxheight)
         {
            oldheight = myimg.height;
            myimg.width = myimg.width * (maxheight/oldheight);
            myimg.height = maxheight;
         }
     }
}
 function submitForm(id,obj)
 {
	 $("#"+id).click(function(){$("#"+obj).submit();});
 }
 function playMusic(m_id,t)
 {
	 url=weburl+"music/play.asp?id="+m_id+"&t="+t+"";
	 //var mWindow=window.open("","mWindow","width=400,height=100,location=no,alwaysRaised=yes,left="+(window.screen.width-400)/2+",top="+(window.screen.height-100)/2+"");
	 var mWindow=window.open("","mWindow");
	 mWindow.location.href=url;
 }
$(function(){
$("#addNav").click(function(){AddFavorite(document.location.href,document.title);});
$("#homeNav").click(function(){SetHome(this,document.location.href);});
});