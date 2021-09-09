function setCookies(cookieName,cookieValue,minutes){ let today = new Date(); let expire = new Date(); let exp=minutes*1000*60||1000*3600*24*365;expire.setTime(today.getTime() + exp); document.cookie = cookieName+'='+escape(cookieValue)+ ';expires='+expire.toGMTString()+'; path=/'; } 
function readCookies(cookieName){ let theCookie=''+document.cookie; let ind=theCookie.indexOf(cookieName); if (ind==-1 || cookieName=='') return ''; let ind1=theCookie.indexOf(';',ind); if (ind1==-1) ind1=theCookie.length; let rico_ret = theCookie.substring(ind+cookieName.length+1,ind1).replace(/%/g, '%25'); return unescape(decodeURI(rico_ret)); }

function login() {
    if ($.cookie('ss_username')) {
        document.writeln("<li><a href='/bookcase/' title='我的书架'>会员书架</a></li><li><a href='/logout/' title='退出登录'>退出</a></li>");
    } else {
        document.writeln("<li><a href='/login/'>登录</a></li><li><a href='/register/'>注册</a></li>");
    }
}

// ie7以下的浏览器提示
var isIE = !!window.ActiveXObject;
var isIE6 = isIE && !window.XMLHttpRequest;
var isIE8 = isIE && !!document.documentMode;
var isIE7 = isIE && !isIE6 && !isIE8;
function tip_ie7() {
    if (isIE && (isIE6 || isIE7 || isIE8)) {
        document.writeln("<div class=\"tip-browser-upgrade\">");
        document.writeln("    你正在使用IE低级浏览器，如果你想有更好的阅读体验，<br />强烈建议您立即 <a class=\"blue\" href=\"http://windows.microsoft.com/zh-cn/internet-explorer/download-ie\" target=\"_blank\" rel=\"nofollow\">升级IE浏览器</a> 或者用更快更安全的 <a class=\"blue\" href=\"https://www.google.com/intl/zh-CN/chrome/browser/?hl=zh-CN\" target=\"_blank\" rel=\"nofollow\">谷歌浏览器Chrome</a> 。");
        document.writeln("</div>");
    }
}

//阅读页键盘操作事件
function ReadKeyEvent() {
    var index_page = $("#linkIndex").attr("href");
    var prev_page =  $("#linkPrev").attr("href");
    var next_page = $("#linkNext").attr("href");
    function jumpPage() {
        var event = document.all ? window.event : arguments[0];
        if (event.keyCode == 37) document.location = prev_page;
        if (event.keyCode == 39) document.location = next_page;
        if (event.keyCode == 13) document.location = index_page;
    }
    document.onkeydown = jumpPage;
}

//是否移动端
function is_mobile() {
    var regex_match = /(nokia|iphone|android|motorola|^mot-|softbank|foma|docomo|kddi|up.browser|up.link|htc|dopod|blazer|netfront|helio|hosin|huawei|novarra|CoolPad|webos|techfaith|palmsource|blackberry|alcatel|amoi|ktouch|nexian|samsung|^sam-|s[cg]h|^lge|ericsson|philips|sagem|wellcom|bunjalloo|maui|symbian|smartphone|midp|wap|phone|windows ce|iemobile|^spice|^bird|^zte-|longcos|pantech|gionee|^sie-|portalmmm|jigs browser|hiptop|^benq|haier|^lct|operas*mobi|opera*mini|320x320|240x320|176x220)/i;
    var u = navigator.userAgent;
    if (null == u) {
        return true;
    }
    var result = regex_match.exec(u);
    if (null == result) {
        return false
    } else {
        return true
    }
}

function go_page(url){
	window.location.href=url;
	return false;
	$(this).href=url;
}

function backtotop() {
    document.writeln("<div class=\"back-to-top\" id=\"back-to-top\" title='返回顶部'><span class=\"glyphicon glyphicon-menu-up\" aria-hidden=\"true\"></span></div>");
    $("#back-to-top").css({right:10,bottom:"10%"});
    var isie6 = window.XMLHttpRequest ? false : true;
    function newtoponload() {
        var c = $("#back-to-top");
        function b() {
            var a = document.documentElement.scrollTop || window.pageYOffset || document.body.scrollTop;
            if (a > 100) {
                if (isie6) {
                    c.hide();
                    clearTimeout(window.show);
                    window.show = setTimeout(function () {
                        var d = document.documentElement.scrollTop || window.pageYOffset || document.body.scrollTop;
                        if (d > 0) {
                            c.fadeIn(100);
                        }
                    }, 300)
                } else {
                    c.fadeIn(100);
                }
            } else {
                c.fadeOut(100);
            }
        }
        if (isie6) {
            c.style.position = "absolute"
        }
        window.onscroll = b;
        b()
    }
    if (window.attachEvent) {
        window.attachEvent("onload", newtoponload)
    } else {
        window.addEventListener("load", newtoponload, false)
    }
    document.getElementById("back-to-top").onclick = function () {
        window.scrollTo(0, 0)
    };
}

//历史记录
var _num = 100;
function LastRead(){
	this.bookList="bookList"
	}
LastRead.prototype={	
	set:function(bid,tid,title,texttitle,author,sortname){
		if(!(bid&&tid&&title&&texttitle&&author&&sortname))return;
		var v=bid+'#'+tid+'#'+title+'#'+texttitle+'#'+author+'#'+sortname;
		this.setItem(bid,v);
		this.setBook(bid)		
		},
	
	get:function(k){
		return this.getItem(k)?this.getItem(k).split("#"):"";						
		},
	
	remove:function(k){
		this.removeItem(k);
		this.removeBook(k)			
		},
	
	setBook:function(v){
		var reg=new RegExp("(^|#)"+v); 
		var books =	this.getItem(this.bookList);
		if(books==""){
			books=v
			}
		 else{
			 if(books.search(reg)==-1){
				 books+="#"+v				 
				 }
			 else{
				  books.replace(reg,"#"+v)
				 }	 
			 }	
			this.setItem(this.bookList,books)
		
		},
	
	getBook:function(){
		var v=this.getItem(this.bookList)?this.getItem(this.bookList).split("#"):Array();
		var books=Array();
		if(v.length){
			
			for(var i=0;i<v.length;i++){
				var tem=this.getItem(v[i]).split('#');	
				if(i>v.length-(_num+1)){
					if (tem.length>3)	books.push(tem);
				}
				else{
					lastread.remove(tem[0]);
				}
			}		
		}
		return books		
	},
	
	removeBook:function(v){		
	    var reg=new RegExp("(^|#)"+v); 
		var books =	this.getItem(this.bookList);
		if(!books){
			books=""
			}
		 else{
			 if(books.search(reg)!=-1){	
			      books=books.replace(reg,"")
				 }	 
			 
			 }	
			this.setItem(this.bookList,books)		
		
		},
	
	setItem:function(k,v){
		if(!!window.localStorage){		
			localStorage.setItem(k,v);		
		}
		else{
			var expireDate=new Date();
			  var EXPIR_MONTH=30*24*3600*1000;			
			  expireDate.setTime(expireDate.getTime()+12*EXPIR_MONTH)
			  document.cookie=k+"="+encodeURIComponent(v)+";expires="+expireDate.toGMTString()+"; path=/";		
			}			
		},
		
	getItem:function(k){
		var value=""
		var result=""				
		if(!!window.localStorage){
			result=window.localStorage.getItem(k);
			 value=result||"";	
		}
		else{
			var reg=new RegExp("(^| )"+k+"=([^;]*)(;|\x24)");
			var result=reg.exec(document.cookie);
			if(result){
				value=decodeURIComponent(result[2])||""}				
		}
		return value
		
		},
	
	removeItem:function(k){		
		if(!!window.localStorage){
		 window.localStorage.removeItem(k);		
		}
		else{
			var expireDate=new Date();
			expireDate.setTime(expireDate.getTime()-1000)	
			document.cookie=k+"= "+";expires="+expireDate.toGMTString()							
		}
		},	
	removeAll:function(){
		if(!!window.localStorage){
		 window.localStorage.clear();		
		}
		else{
		var v=this.getItem(this.bookList)?this.getItem(this.bookList).split("#"):Array();
		var books=Array();
		if(v.length){
			for( i in v ){
				var tem=this.removeItem(v[k])				
				}		
			}
			this.removeItem(this.bookList)				
		}
		}	
	}
function showbook(){
	var bookhtml='';
	var books=lastread.getBook();
	var books=books.reverse();
	if(books.length){
		for(var i=0 ;i<books.length;i++){
			bookhtml+='<tr><td class="hidden-xs">'+books[i][5]+'</td><td><a href="'+books[i][0]+'" target="_blank">'+books[i][2]+'</a></td><td><a href="'+books[i][1]+'">'+books[i][3]+'</a></td><td class="hidden-xs">'+books[i][4]+'</td><td class="delbutton"><a class="del_but" href="javascript:removebook(\''+books[i][0]+'\')" onclick="return confirm(\'确定要将本书移除吗？\')">删除</a></td></tr>';
		}
	}else{
		bookhtml+=''
	}
	document.write(bookhtml);
}
function removebook(k){
	lastread.remove(k);
	window.location.reload();
}
function removeall(){
	lastread.removeAll();
	window.location.reload();
}
window.lastread = new LastRead();