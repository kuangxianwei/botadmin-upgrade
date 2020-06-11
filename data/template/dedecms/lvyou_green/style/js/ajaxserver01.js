//触发服务器事件
function AjaxServer()
{

}

//创建XMLhttp对象
AjaxServer.CreateHttpObj=function(){
	var objhttp;
	try
	{
		//IE浏览器
		try
		{
			objhttp = new ActiveXObject("Msxml.XMLHTTP");
		}
		catch(e)
		{
			objhttp = new ActiveXObject("Microsoft.XMLHTTP");
		}
	}
	catch(e)
	{
		//不是IE浏览器
		try
		{
			objhttp = new XMLHttpRequest();
		}
		catch(e)
		{
			objhttp = null;
		}
	}
	return objhttp
}


//获取新闻点击量
AjaxServer.getHits = function(id,pathstr)
{
	var xmlhttp = AjaxServer.CreateHttpObj();
	if(xmlhttp)
	{
		if (pathstr == "" ) pathstr = "/"
		xmlhttp.open("GET", pathstr +"www/js/server.asp?flag=hits&ID="+ id, false);
		xmlhttp.send(null);
		if(xmlhttp.status==200)
		{
			document.getElementById("show").innerHTML = xmlhttp.responseText
		}
	}
}

AjaxServer.ShowMenu = function(sort)
{
	var xmlhttp = AjaxServer.CreateHttpObj();
	if(xmlhttp)
	{
		xmlhttp.open("GET","/www/js/server.asp?flag=showmenu&sort="+sort+"&num="+Math.random(),false);
		xmlhttp.send();
		if(xmlhttp.status==200)
		{
			document.getElementById("submenu").innerHTML = xmlhttp.responseText;
		}
	}
}

//设为主页
function setHomePage(obj,siteurl){
	try{
		obj.style.behavior='url(#default#homepage)';obj.setHomePage(siteurl);
	}
	catch(e){
		if(window.netscape) {
			try {
				netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			}
			catch (e) {
				alert("此操作被浏览器拒绝！\n请在浏览器地址栏输入“about:config”并回车\n然后将 [signed.applets.codebase_principal_support]的值设置为'true',双击即可。");
			}
			var prefs = Components.classes['@mozilla.org/preferences-service;1'].getService(Components.interfaces.nsIPrefBranch);
			prefs.setCharPref('browser.startup.homepage',siteurl);
		}
	}
}

//加入收藏
function addFavorite(sitename,siteurl){
	if(document.all){window.external.addFavorite(siteurl,sitename);}else if(window.sidebar){window.sidebar.addPanel(sitename, siteurl,'');}
}


//返回顶部
function scrolltop(){
	window.scroll(0,0)
}

//字体大小
function fontZoom(size){
	document.getElementById("showcontent").style.fontSize = size +'px';
}
