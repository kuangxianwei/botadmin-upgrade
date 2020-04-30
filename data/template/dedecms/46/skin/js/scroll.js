<!--
	  var speeds=20; //数字越大速度越慢
	  var tabs=document.getElementById("demos");
	  var tabs1=document.getElementById("demos1");
	  var tabs2=document.getElementById("demos2");
	  tabs2.innerHTML=tabs1.innerHTML;
	  function Marquees(){
	  if(tabs2.offsetWidth-tabs.scrollLeft<=0)
	  tabs.scrollLeft-=tabs1.offsetWidth
	  else{
	  tabs.scrollLeft++;
	  }
	  }
	  var MyMars=setInterval(Marquees,speeds);
	  tabs.onmouseover=function() {clearInterval(MyMars)};
	  tabs.onmouseout=function() {MyMars=setInterval(Marquees,speeds)};
	  -->
