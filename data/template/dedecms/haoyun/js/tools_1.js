var tmpDate = new Date();
nowyear = tmpDate.getFullYear()
nowmonth = tmpDate.getMonth();
nowday = tmpDate.getDate();

$(document).ready (function(){
	$(".inpYear").val(nowyear)
	$(".inpMonth").val(nowmonth)
	$(".inpDay").val(nowday)
})

//Hide this script from old browsers/
if (!document.layers&&!document.all)
event="test"
function showtip2(current,e,text,index){
if (document.all&&document.readyState=="complete"){
eval("var tooltip=document.getElementById('tooltip" + index + "');")
tooltip.innerHTML='' + text + '</table>'
tooltip.style.pixelLeft=0
tooltip.style.pixelTop=20
tooltip.style.display="block"
}
else if (document.layers){
eval("var tooltip=document.getElementById('tooltip" + index + "');")
eval("var nstip=document.getElementById('tooltip" + index + "document.getElementById('nstip" + index + "');")
nstip.document.write('<b>'+text+'</b>')
nstip.document.close()
nstip.left=0
//currentscroll=setInterval("scrolltip(" + index + ")",100)
tooltip.left=0
tooltip.top=20
tooltip.display="block"
}
}
function hidetip2(index){
if (document.all)
eval("tooltip=document.getElementById('tooltip" + index + "').style.display='none';");
else if (document.layers){
//clearInterval(currentscroll)
eval("tooltip=document.getElementById('tooltip" + index + "').display='none';")
}
}
function scrolltip(index){
eval("var nstip=document.getElementById('tooltip" + index + "document.getElementById('nstip" + index + "');")
if (nstip.left>=-nstip.document.width)
nstip.left-=0
else
nstip.left=0
}
function montharr(m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11)
{
this[0] = m0;
this[1] = m1;
this[2] = m2;
this[3] = m3;
this[4] = m4;
this[5] = m5;
this[6] = m6;
this[7] = m7;
this[8] = m8;
this[9] = m9;
this[10] = m10;
this[11] = m11;
}
var CalendarOuterHTML = '';
var Today = new Date();
var DaysPerMonth = 0;
//Get the number of day in some month
function GetDayPerMonth(year,month)
{
var monthDays = new montharr(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
if (((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0))
monthDays[1] = 29;
DaysPerMonth = monthDays[month];	
}
function GetCalendarOuterHTML(CalendarIndex,HaveLayer)
{
CalendarOuterHTML = '';		
var thisYear = document.getElementById('frmInput').txtYear.value;
var thisMonth = parseInt(document.getElementById('frmInput').txtMonth.value) +  CalendarIndex - 1 ;
//when thisMonth beyond 12
if (thisMonth > 12) 
{
thisYear = parseInt(thisYear) + 1;
thisMonth = thisMonth % 12;
}
//title of the calendar
CalendarOuterHTML = CalendarOuterHTML + "<table border='0' cellspacing='0' cellpadding='3' align='center' class='tTable' id=Calendar"+CalendarIndex+ ">";
CalendarOuterHTML = CalendarOuterHTML + "<tr class='dtitle1'><td colspan='7' height='15' align='center'>";
CalendarOuterHTML = CalendarOuterHTML + thisYear+' 年 ';
CalendarOuterHTML = CalendarOuterHTML + thisMonth +' 月';
CalendarOuterHTML = CalendarOuterHTML + "<tr class='dtitle2'><td width='30'>日<td width='30'>一<td width='30'>二<td width='30'>三<td width='30'>四<td width='30'>五<td width='30'>六";
CalendarOuterHTML = CalendarOuterHTML + "<tr bgcolor='#FFFFFF'>";
//Get the day of the first Day
var firstDay = new Date(Date.UTC(document.getElementById('frmInput').txtYear.value,(parseInt(document.getElementById('frmInput').txtMonth.value)-2+CalendarIndex),1));
testMe = firstDay.getDate();
if (testMe == 2)
firstDay.setDate(0); 
startDay = firstDay.getDay();
//display empty cells  before the first day of the month                
column = 0;
for (i=0; i<startDay; i++)
{
CalendarOuterHTML = CalendarOuterHTML + "<td width='30'>";
column++;
}
//display the grids in the calendar
var Lastday = new Date(Date.UTC(document.getElementById('frmInput').txtYear.value,(parseInt(document.getElementById('frmInput').txtMonth.value)-1),document.getElementById('frmInput').txtDay.value))	
GetDayPerMonth(thisYear,thisMonth-1)	
for (i=1; i<=DaysPerMonth; i++)
{
CalendarOuterHTML = CalendarOuterHTML + "<td width='30'>";
var color = "blue";		//default color without layer displayed
//Get layer HTML
if (HaveLayer)
{		
var ThisDay = new Date(Date.UTC(thisYear,thisMonth-1,i))
var msPerDay = 24 * 60 * 60 * 1000 ;
var mensesCyc = parseInt(document.getElementById('frmInput').txtMinMensesCyc.value);		//Min menses Cycle
var msDiff = ThisDay.getTime() - Lastday.getTime();
dayDiff = Math.floor(msDiff / msPerDay);						//get the days between thisday and lastday
dayRemainder =	(dayDiff % mensesCyc + mensesCyc) % mensesCyc;
//if (i<2)	{alert(ThisDay.toLocaleString()); alert(Lastday.toLocaleString()); alert(dayDiff);alert(dayRemainder);}
var tooltips ="";		//content of layer
if (dayRemainder>=0 && dayRemainder<=4)
{	color = "#FF9900";
tooltips = "这是月经期，要注意经期卫生，当然也要“节欲”，避免性事哦！"
}
if (dayRemainder>=5 && dayRemainder<=(mensesCyc-20))
{	color = "#009933";
tooltips = "这是安全期，性事一般不会受孕，您放心吧！";	
}
if (dayRemainder>=(mensesCyc-19) && dayRemainder<=(mensesCyc-10))
{	color = "#FF3300";
tooltips = "这是危险期，亦称排卵期，性事受孕可能性大，千万要注意哦！";
}
if (dayRemainder>=(mensesCyc-9) && dayRemainder<=(mensesCyc-1))	
{	color = "#009933";
tooltips = "这是安全期，性事一般不会受孕，您放心吧！";	
}
iLayerIndex = 40*CalendarIndex + i ;		//index of layer
tooltips = "<table border=0 cellpadding=2 cellspacing=1 width=100% align=center bgcolor=#008080>" +
"<tr><td style=background-color:white;color:" + color + ";>" +
tooltips + "</td></tr></table>";
CalendarOuterHTML = CalendarOuterHTML + "<span style=\"float:left; text-align:left; position: relative;\"><div id=\"tooltip" + iLayerIndex + "\" style=\"position:absolute;display:none;clip:rect(0 150 150 0);width:150px;background-color:seashell\">";
CalendarOuterHTML = CalendarOuterHTML + "<layer name=\"nstip" + iLayerIndex + "\" width=\"150px\" bgColor=\"seashell\" height=\"50px\"></layer></div></span>";
CalendarOuterHTML = CalendarOuterHTML + "<a onMouseOver=\"showtip2(this,event,'" + tooltips + "'," + iLayerIndex + ")\" onMouseOut=\"hidetip2(" + iLayerIndex + ")\">";
}
CalendarOuterHTML = CalendarOuterHTML + "<font color=\"" + color + "\">" + i + "</font>";
column++;
if (column == 7)
{
CalendarOuterHTML = CalendarOuterHTML + "<tr bgcolor='#FFFFFF'>"; 
column = 0;
}
}
//display empty cells  after the final day of the month    
var FinalDay = new Date(Date.UTC(document.getElementById('frmInput').txtYear.value,(parseInt(document.getElementById('frmInput').txtMonth.value)-2+CalendarIndex),DaysPerMonth));
testMe = FinalDay.getDate();
if (testMe == 2)
FinalDay.setDate(0); 
EndDay = FinalDay.getDay();
for (i=EndDay; i<6; i++)
{
CalendarOuterHTML = CalendarOuterHTML + "<td width='30'>";
}
CalendarOuterHTML = CalendarOuterHTML + "</table>";
}
//to check input errors and display both calendars
function check()
{
//check whether the date is legal
if (document.getElementById('frmInput').txtYear.value<1900||isNaN(document.getElementById('frmInput').txtYear.value))
{
alert("请输入合法年份！")
document.getElementById('frmInput').txtYear.focus();
return false;
}
if (isNaN(document.getElementById('frmInput').txtMonth.value) || document.getElementById('frmInput').txtMonth.value<1 || document.getElementById('frmInput').txtMonth.value>12)
{
alert("请输入合法月份！")
document.getElementById('frmInput').txtMonth.focus();
return false;
}
GetDayPerMonth(document.getElementById('frmInput').txtYear.value,document.getElementById('frmInput').txtMonth.value-1)
if (isNaN(document.getElementById('frmInput').txtDay.value) || document.getElementById('frmInput').txtDay.value<1 || document.getElementById('frmInput').txtDay.value>DaysPerMonth)
{
alert("请输入合法日期！")
document.getElementById('frmInput').txtDay.focus();
return false;
}
var Lastday = new Date(Date.UTC(document.getElementById('frmInput').txtYear.value,(parseInt(document.getElementById('frmInput').txtMonth.value)-1),document.getElementById('frmInput').txtDay.value))	
if ((Today.getTime() - Lastday.getTime())<0)
{
alert("请输入正确的上次月经时间(不能早于当前时间)！")
document.getElementById('frmInput').txtYear.focus();
return false;
}	
//check input
if(isNaN(document.getElementById('frmInput').txtMinMensesCyc.value))
{
alert("请输入数字！")
document.getElementById('frmInput').txtMinMensesCyc.focus();
return false;
}
if(parseInt(document.getElementById('frmInput').txtMinMensesCyc.value)>40 || parseInt(document.getElementById('frmInput').txtMinMensesCyc.value)<22 )
{
alert("您输入的最短月经周期与标准月经周期相差太大，程序无法测试，请仔细核对。\n\n如输入确无问题请咨询医生！")
document.getElementById('frmInput').txtMinMensesCyc.focus();
return false;
}
if(isNaN(document.getElementById('frmInput').txtMaxMensesCyc.value) || parseInt(document.getElementById('frmInput').txtMaxMensesCyc.value)<parseInt(document.getElementById('frmInput').txtMinMensesCyc.value))
{
alert("输入错误，请仔细核对您的输入周期！");
document.getElementById('frmInput').txtMaxMensesCyc.focus();
return false;
}
//display calendars
GetCalendarOuterHTML(1,1);
document.getElementById('Calendar1').innerHTML = CalendarOuterHTML;
GetCalendarOuterHTML(2,1);
document.getElementById('Calendar2').innerHTML = CalendarOuterHTML;
MM_showHideLayers('toolsr_1','','show');	
}
//Initialize
function InitialCalendar()
{
//Initialize the date input boxes
document.getElementById('frmInput').txtYear.value = Today.getYear();
document.getElementById('frmInput').txtMonth.value = Today.getMonth()+1;
document.getElementById('frmInput').txtDay.value = Today.getDate()-1;
//Initialize the calendars
GetCalendarOuterHTML(1,0);
document.getElementById('Calendar1').outerHTML = CalendarOuterHTML;
GetCalendarOuterHTML(2,0);
document.getElementById('Calendar2').outerHTML = CalendarOuterHTML;
//Set focus
//document.getElementById('frmInput').btnCalculate.focus();
}
//End Hiding Here
//MM_show & MM_findObj
function MM_findObj(n, d) { //v4.0
var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
if(!x && document.getElementById) x=document.getElementById(n); return x;
}
function MM_showHideLayers() { //v3.0
var i,p,v,obj,args=MM_showHideLayers.arguments;
for (i=0; i<(args.length-2); i+=3) if ((obj=MM_findObj(args[i]))!=null) { v=args[i+2];
if (obj.style) { obj=obj.style; v=(v=='show')?'block':(v='hide')?'none':v; }
obj.display=v; }
}
