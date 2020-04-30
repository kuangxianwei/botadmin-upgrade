// JavaScript Document

function Time(){
 var time = document.getElementById("dayShow");
 var Timer=new Date();
 var date = Timer.getDate();
 var day = Timer.getDay();
 var month = Timer.getMonth() + 1;
 var year = Timer.getFullYear();
 switch(day)
 {
 	case 1:Day="一";break;
	case 2:Day="二";break;
	case 3:Day="三";break;
	case 4:Day="四";break;
	case 5:Day="五";break;
	case 6:Day="六";break;
	case 0:Day="日";break;
 }
 myclock=year+"."+month+"."+date+" "+" "+"星期"+Day;
 time.innerHTML=myclock;
 }
