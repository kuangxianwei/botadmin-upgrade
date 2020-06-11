var tmpDate = new Date();
nowyear = tmpDate.getFullYear()
nowmonth = tmpDate.getMonth();
nowday = tmpDate.getDate();

$(document).ready (function(){
	$(".inpYear").val(nowyear)
	$(".inpMonth").val(nowmonth)
	$(".inpDay").val(nowday)
})

function haha()
{
if (health.year.value=="" || health.month.value=="" || health.day.value =="")
{
alert("请填写完整年月日!");
return false;
}
if (health.year.value>2050 || health.year.value<1990)
{
alert("请填写正确年份!");
health.year.focus();
return false;
}
if (health.month.value>12 || health.month.value<1)
{
alert("请填写正确月份!");
health.month.focus();
return false;
}
if (health.day.value>31 || health.day.value<1)
{
alert("请填写正确日子!");
health.day.focus();
return false;
}
if (!isDate(health.year.value ,health.month.value ,health.day.value))
{
alert("年月日组合有错,请重新填写!");
return false;
}
function isDate (year, month, day)
{
// month argument must be in the range 1 - 12
month = month - 1;  // javascript month range : 0- 11
var tempDate = new Date(year,month,day);
if ( (year2k(tempDate.getYear()) == year) && (month == tempDate.getMonth()) && (day == tempDate.getDate()) )
{    
return true;
}
else
{
return false;
}
}
function year2k(d) 
{ 
return (d < 1000) ? d + 1900 : d;
}        
if (health.mweek.value==3)
{
var stime = health.month.value + "/" + health.day.value + "/" + health.year.value;
var stime2 = Date.parse(stime) + 39*7*24*3600*1000;
var yuchan2 = new Date(stime2);
var yuchan4 = new String(yuchan2);
var yuchan3 = yuchan4.split(" ");
var yuchanmonth = "";
if (yuchan3[1]=="Jan") yuchanmonth="1";
if (yuchan3[1]=="Feb") yuchanmonth="2";
if (yuchan3[1]=="Mar") yuchanmonth="3";
if (yuchan3[1]=="Apr") yuchanmonth="4";
if (yuchan3[1]=="May") yuchanmonth="5";
if (yuchan3[1]=="Jun") yuchanmonth="6";
if (yuchan3[1]=="Jul") yuchanmonth="7";
if (yuchan3[1]=="Aug") yuchanmonth="8";
if (yuchan3[1]=="Sep") yuchanmonth="9";
if (yuchan3[1]=="Oct") yuchanmonth="10";
if (yuchan3[1]=="Nov") yuchanmonth="11";
if (yuchan3[1]=="Dec") yuchanmonth="12";
var yuchan2month = parseInt(yuchan2.getMonth())+1
var yuchan = yuchan2.getFullYear() + "-" + yuchan2month + "-" + yuchan2.getDate()
var nowt = new Date();
var nowtime = nowt.getTime();
var chatime = nowtime - Date.parse(stime);
var chaweek = Math.floor((chatime)/(1000*60*60*24*7));
if (chaweek<0) chaweek=0;
if (chaweek>41) alert("你的预产期已过!");		
document.health.yuchan.value = yuchan;
document.health.yuchan2.value = chaweek;
return false;
}
if (health.mweek.value==4)
{
var stime = health.month.value + "/" + health.day.value + "/" + health.year.value;
var stime2 = Date.parse(stime) + 40*7*24*3600*1000;
var yuchan2 = new Date(stime2);
var yuchan4 = new String(yuchan2);
var yuchan3 = yuchan4.split(" ");
var yuchanmonth = "";
if (yuchan3[1]=="Jan") yuchanmonth="1";
if (yuchan3[1]=="Feb") yuchanmonth="2";
if (yuchan3[1]=="Mar") yuchanmonth="3";
if (yuchan3[1]=="Apr") yuchanmonth="4";
if (yuchan3[1]=="May") yuchanmonth="5";
if (yuchan3[1]=="Jun") yuchanmonth="6";
if (yuchan3[1]=="Jul") yuchanmonth="7";
if (yuchan3[1]=="Aug") yuchanmonth="8";
if (yuchan3[1]=="Sep") yuchanmonth="9";
if (yuchan3[1]=="Oct") yuchanmonth="10";
if (yuchan3[1]=="Nov") yuchanmonth="11";
if (yuchan3[1]=="Dec") yuchanmonth="12";
var yuchan2month = parseInt(yuchan2.getMonth())+1
var yuchan = yuchan2.getFullYear() + "-" + yuchan2month + "-" + yuchan2.getDate()
var nowt = new Date();
var nowtime = nowt.getTime();
var chatime = nowtime - Date.parse(stime);
var chaweek = Math.floor((chatime)/(1000*60*60*24*7));
if (chaweek<0) chaweek=0;
if (chaweek>42) alert("你的预产期已过!");		
document.getElementById("yuchan").value = yuchan;
document.getElementById("yuchan2").value = chaweek;
return false;
}
if (health.mweek.value==5)
{
var stime = health.month.value + "/" + health.day.value + "/" + health.year.value;
var stime2 = Date.parse(stime) + 41*7*24*3600*1000;
var yuchan2 = new Date(stime2);
var yuchan4 = new String(yuchan2);
var yuchan3 = yuchan4.split(" ");
var yuchanmonth = "";
if (yuchan3[1]=="Jan") yuchanmonth="1";
if (yuchan3[1]=="Feb") yuchanmonth="2";
if (yuchan3[1]=="Mar") yuchanmonth="3";
if (yuchan3[1]=="Apr") yuchanmonth="4";
if (yuchan3[1]=="May") yuchanmonth="5";
if (yuchan3[1]=="Jun") yuchanmonth="6";
if (yuchan3[1]=="Jul") yuchanmonth="7";
if (yuchan3[1]=="Aug") yuchanmonth="8";
if (yuchan3[1]=="Sep") yuchanmonth="9";
if (yuchan3[1]=="Oct") yuchanmonth="10";
if (yuchan3[1]=="Nov") yuchanmonth="11";
if (yuchan3[1]=="Dec") yuchanmonth="12";
var yuchan2month = parseInt(yuchan2.getMonth())+1
var yuchan = yuchan2.getFullYear() + "-" + yuchan2month + "-" + yuchan2.getDate()
var nowt = new Date();
var nowtime = nowt.getTime();
var chatime = nowtime - Date.parse(stime);
var chaweek = Math.floor((chatime)/(1000*60*60*24*7));
if (chaweek<0) chaweek=0;
if (chaweek>43) alert("你的预产期已过!");
document.getElementById("yuchan").value = yuchan;
document.health.yuchan2.value = chaweek;
return false;
}	
}
