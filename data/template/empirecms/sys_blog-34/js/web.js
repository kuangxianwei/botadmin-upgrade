$(document).ready(function(){
  $(".button").click(function(){
  $(".navul").slideToggle();
  });
});

//屏蔽右键菜单
document.oncontextmenu = function (event){
	if(window.event){
		event = window.event;
	}try{
		var the = event.srcElement;
		if (!((the.tagName == "INPUT" && the.type.toLowerCase() == "text") || the.tagName == "TEXTAREA")){
			return false;
		}
		return true;
	}catch (e){
		return false; 
	} 
}

//屏蔽粘贴
document.onpaste = function (event){
	if(window.event){
		event = window.event;
	}try{
		var the = event.srcElement;
		if (!((the.tagName == "INPUT" && the.type.toLowerCase() == "text") || the.tagName == "TEXTAREA")){
			return false;
		}
		return true;
	}catch (e){
		return false;
	}
}

//屏蔽复制
document.oncopy = function (event){
	if(window.event){
		event = window.event;
	}try{
		var the = event.srcElement;
		if(!((the.tagName == "INPUT" && the.type.toLowerCase() == "text") || the.tagName == "TEXTAREA")){
			return false;
		}
		return true;
	}catch (e){
		return false;
	}
}

//屏蔽剪切
document.oncut = function (event){
	if(window.event){
		event = window.event;
	}try{
		var the = event.srcElement;
		if(!((the.tagName == "INPUT" && the.type.toLowerCase() == "text") || the.tagName == "TEXTAREA")){
			return false;
		}
		return true;
	}catch (e){
		return false;
	}
}

//屏蔽选中
document.onselectstart = function (event){
	if(window.event){
		event = window.event;
	}try{
		var the = event.srcElement;
		if (!((the.tagName == "INPUT" && the.type.toLowerCase() == "text") || the.tagName == "TEXTAREA")){
			return false;
		}
		return true;
	} catch (e) {
		return false;
	}
}


var obj=null;
var As=document.getElementById('nav').getElementsByTagName('a');
    obj = As[0];
        for(i=1;i<As.length;i++){
            if(window.location.href.indexOf(As[i].href)>=0)
            obj=As[i];
        }
    obj.id='nav_current'