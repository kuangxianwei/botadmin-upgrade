function changeTwoDecimal(x)
{
var f_x = parseFloat(x);
if (isNaN(f_x))
{
alert('function:changeTwoDecimal->parameter error');
return false;
}
var f_x = Math.round(x*100)/100;
return f_x;
}
function isEmpty(str) {
if(str==null) return true;
return (str.replace(/ /g,"").replace(/\r\n/g,"")=="");
}
function isNumeric(str,bInt){
var nDotCount=0;
if(isEmpty(str)) return false;
for(var i=0;i<str.length;i++){
if(str.charCodeAt(i)<48||str.charCodeAt(i)>57){
if(str.charAt(i)=="."){
nDotCount++;
if(nDotCount<=1){
continue;
}
}
return false;
}
}
if(bInt){
return (nDotCount==0);
}
else{
return true;
}
}
function isInt(str){
return isNumeric(str,true);
} 
function isBetween(o,p,q){
if(o>=p&&o<=q){return true;}
else{return false;}
} 
function suan()
{
var g=document.baby.gender.value;
var y=document.baby.year.value;	
var m=document.baby.month.value;	
var d=document.baby.day.value;
var ms;//月龄
var ys;//年龄
var to=new Date();
var today=to.getTime();//格式化今天时间
var maxDays=31;
if (isInt(m)==false||isInt(d)==false||isInt(y)==false)
{alert("请填写完整年月日!");
return;}
if (y.length<4)
{alert("请填写正确年份!");
return;}
if (!isBetween(m,1,12))
{alert("请填写正确月份!");
return;}
if (m==4||m==6||m==9||m==11)
{maxDays=30;}
else if (m==2)
{
if (y%4==0){maxDays=29;}
else maxDays=28;
}
if (isBetween(d,1,maxDays)==false)
{alert("请填写正确日子!");
return}
var birthbady=new Date(y,m-1,d);//生成生日
var bday=birthbady.getTime();
if(bday>=today){alert("您填写的时间还没要到!请重新输入。");
return;}
var a=parseInt(((today-bday)/1000/3600/24));
ys=parseInt(a/365);
if(ys>=6)
{alert("您的孩子大于6岁啦!此工具只适合6岁以下儿童使用，请重新输入。");
return;}
ms=parseInt(a/30);
var age;
age=ys+"岁"+(ms%12)+"月"+(a%30)+"天";
document.getElementById("span_age").innerHTML=age;
var data=[{"data":[{"h":"48.2-52.8","w":"2.9-3.8","o":"32.00"},
{"h":"52.1-57.0","w":"3.6-5.0","o":"39.4"},
{"h":"55.5-60.7","w":"4.3-6.0","o":"39.84"},
{"h":"58.5-63.7","w":"5.0-6.9","o":"41.25"},
{"h":"61.0-66.4","w":"5.7-7.6","o":"42.30"},
{"h":"62.3-68.6","w":"6.3-8.2","o":"43.10"},
{"h":"65.1-70.5","w":"6.9-8.8","o":"44.32"},
{"h":"66.7-72.1","w":"7.4-9.3","o":"45"},
{"h":"68.3-73.6","w":"7.8-9.8","o":"45.74"},
{"h":"69.7-75.0","w":"8.2-10.2","o":"46"},
{"h":"71.0-76.3","w":"8.6-10.6","o":"46.09"},
{"h":"72.2-77.6","w":"8.9-11.0","o":"46.3"},
{"h":"84.3-91.0","w":"11.2-14.0","o":"48.2"},
{"h":"91.1-98.7","w":"13.0-16.4","o":"49.58"},
{"h":"98.7-107.2","w":"14.8-18.7","o":"49.93"},
{"h":"105.3-114.5","w":"16.6-21.1","o":"50.98"},
{"h":"111.2-121.0","w":"18.4-23.6","o":"51.07"}]},{"data":[
{"h":"47.7-52.0","w":"2.7-3.6","o":"33.05"},
{"h":"51.2-55.8","w":"3.4-4.5","o":"38.4"},
{"h":"54.4-59.2","w":"4.0-5.4","o":"38.67"},
{"h":"57.1-59.5","w":"4.7-6.2","o":"39.90"},
{"h":"59.4-64.5","w":"5.3-6.9","o":"41.20"},
{"h":"61.5-66.7","w":"5.8-7.5","o":"41.90"},
{"h":"63.3-68.6","w":"6.3-8.1","o":"43.20"},
{"h":"64.8-70.2","w":"6.8-8.6","o":"43.7"},
{"h":"66.4-71.8","w":"7.2-9.1","o":"45.20"},
{"h":"67.7-73.2","w":"7.6-9.5","o":"45.2"},
{"h":"69.0-74.5","w":"7.9-9.9","o":"44.89"},
{"h":"70.3-75.8","w":"8.2-10.3","o":"45.3"},
{"h":"83.3-89.8","w":"10.6-13.2","o":"47.1"},
{"h":"90.2-98.1","w":"12.6-16.1","o":"48.33"},
{"h":"97.6-105.7","w":"14.3-18.3","o":"48.33"},
{"h":"104.0-112.8","w":"15.7-20.4","o":"50.02"},
{"h":"109.7-119.6","w":"17.3-22.9","o":"50.98"}
]}];
fill(g,ms,data)
function fill(sex,month,data){
var d=data[1].data;
if(sex=="男"){d=data[0].data;}
if(ms>11){
ms=parseInt((ms-12)/12)+12;
}
height = document.getElementById("span_height"); 
weight = document.getElementById("span_weight");
head = document.getElementById("span_head");
height.innerHTML =d[ms].h;
weight.innerHTML =d[ms].w;
head.innerHTML =d[ms].o;		
}
}
