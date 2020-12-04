var setY, setM, setD;
var weeks = [ "星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六" ];
var tbtitArr = ["孕月","孕周"];
var widths = [52, 58, 73, 73, 73, 73, 73, 73, 73, 80]
var bzs = { 
   8:"领准生证", 
   9:"<span title='去医院建立档案'>建卡</span>,唐筛1项", 
   12:"产检", 
   16:"产检", 
   17:"唐筛2项",
   20:"产检",
   24:"产检",
   28:"产检",
   32:"产检",
   34:"产检", 
   36:"产检",
   37:"产检",
   38:"产检",
   39:"产检" }
cDate =new Date();
curY = cDate.getFullYear()
curM = cDate.getMonth()+1;
curD = cDate.getDate()

var mDate = new Date(new Date()-1000*60*60*24*279) 
myear = mDate.getFullYear()
mmonth = mDate.getMonth()+1;
mday = mDate.getDate();

$("#year_0").val(myear)
$("#month_0").val(mmonth)
$("#day_0").val(mday)
	 
function setWeeks(){
	var days=0, curDays=0, wDays=0, curWdays=0, curWs=0;
	if( !document.getElementById('year_0').value || !document.getElementById('month_0').value || !document.getElementById('day_0').value){ alert("请输入末次月经第一天的日期"); return;}
	//else if( !document.getElementById('year_1').value || !document.getElementById('month_1').value || !document.getElementById('day_1').value){ alert("请输入预产日期"); return;}
	var mcyjDateObj =new Date(document.getElementById('year_0').value,document.getElementById('month_0').value-1,document.getElementById('day_0').value);
	var mcyjTime = mcyjDateObj.getTime()/1000;
	//var ycqDateObj =new Date(document.getElementById('year_1').value,document.getElementById('month_1').value-1,document.getElementById('day_1').value);
	var ycqDateObj =new Date(mcyjDateObj.getTime()+1000*60*60*24*280);
	var ycqTime = ycqDateObj.getTime()/1000;
	var yqDays = (ycqTime - mcyjTime)/(3600 * 24);
	var yws = Math.ceil( (yqDays+1)/7 );
	if( yqDays < 259   ){
		alert("预产期应该至少未次月经后37周，请正确输入日期。");
		document.getElementById('year_1').click(); document.getElementById('year_1').value = ""; 
		return;
	}else if( yqDays > 314 ){
		alert("对不起，本工具最大计算孕周为45周，无法完成您要求的计算。");
		document.getElementById('year_1').click(); document.getElementById('year_1').value = ""; 
		return;
	}
	syDate = document.getElementById('year_0').value+"-"+document.getElementById('month_0').value+"-"+document.getElementById('day_0').value
	//ycDate = document.getElementById('year_1').value+"-"+document.getElementById('month_1').value+"-"+document.getElementById('day_1').value
	ycDate = ycqDateObj.getFullYear()+"-"+(ycqDateObj.getMonth()+1)+"-"+ycqDateObj.getDate()
	setY = mcyjDateObj.getFullYear(); setM = mcyjDateObj.getMonth()+1; setD = mcyjDateObj.getDate();
	var uk = mcyjDateObj.getDay();
	var nWeeks1 = weeks.slice( 0, uk );
	var nWeeks2 = weeks.slice( uk );
	tbtits = tbtitArr.concat(nWeeks2,nWeeks1,"重点提示");
	try{  document.getElementById('tb').removeChild( document.getElementById('tb').childNodes[1] ) }catch(e){}
	var tbd = document.createElement("tbody");
	document.getElementById('tb').appendChild( tbd );
	var nTr = document.createElement("tr");
	for( i=0; i<10; i++ ){
		var nTh = document.createElement("th");
		nTh.innerHTML = tbtits[i];
		nTh.style.width = widths[i]+"px"
		nTr.appendChild( nTh );
	}
	tbd.appendChild( nTr );
	
	var ms = 0, catid=518, showD=true;
	var tdback = "#f4f4f4";
	for( i=0; i < yws; i++ ){
		nTr = document.createElement("tr");
		if( !(i%4) ){  
			ms++;
			nTd = document.createElement("td");
			switch(ms){
				case 1:
				nTd.innerHTML = "孕"+ms+"月"
				break
				case 2:
				nTd.innerHTML = "孕"+ms+"月"
				break
				case 3:
				nTd.innerHTML = "孕"+ms+"月"
				break
				case 4:
				nTd.innerHTML = "孕"+ms+"月"
				break
				case 5:
				nTd.innerHTML = "孕"+ms+"月"
				break
				case 6:
				nTd.innerHTML = "孕"+ms+"月"
				break
				case 7:
				nTd.innerHTML = "孕"+ms+"月"
				break
				case 8:
				nTd.innerHTML = "孕"+ms+"月"
				break
				case 9:
				nTd.innerHTML = "孕"+ms+"月"
				break
				case 10:
				nTd.innerHTML = "孕"+ms+"月"
				break
				default:
				nTd.innerHTML = "孕"+ms+"月"
			}
			nTd.rowSpan = "4";
			nTr.appendChild( nTd );
		}
		wDays=1;
		for( j=0; j<9; j++ ){
		   nTd = document.createElement("td");
		   if( j==1 && i==0 ) nTd.style.cssText = "color:red;font-weight:bold"
		   if( j==0 ){
				switch (i){
					case 0:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 1:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 2:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 3:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 4:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 5:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 6:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 7:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 8:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 9:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 10:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 11:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 12:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 13:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 14:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 15:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 16:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 17:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 18:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 19:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 20:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 21:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 22:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 23:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 24:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 25:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 26:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 27:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 28:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 29:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 30:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 31:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 32:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 33:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 34:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 35:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 36:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 37:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 38:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break
					case 39:
					nTd.innerHTML = "孕"+(i+1)+"周"
					break					
					default:
					nTd.innerHTML = "孕"+(i+1)+"周"
				}
				/* if( i<37 ) catid = 518 + i;
				 else if(i==37) catid = 559;
				 else if(i==38) catid = 558;
				 else if(i==39) catid = 1089;
			   nTd.innerHTML = ( i<40 ) ? "孕"+(i+1)+"周" : "孕"+(i+1)+"周";*/
		   }else if( j==8 ){
				 if(bzs[i])   nTd.innerHTML = bzs[i]
		   }else{ 
			   nTd.innerHTML = getDate( ( j==1 && !i ) ? 1 : false );
			   var sDate =new Date( setY, setM-1, setD  );
			   if( showD && ycDate == setY + "-" + setM + "-" + setD ){
					nTd.style.background = "#99cde6";
					nTd.style.color = "#fff";
					nTd.innerHTML += "<br>(预产期)";
					showD = false;
					
			   }else if( sDate.getTime()<cDate.getTime() ){
					nTd.style.background = tdback;
			   }
	
			   if( curY==setY && curM==setM && curD==setD){
					curDays = days+1;
					curWs = i;
					curWdays = wDays;
			   }
			   wDays++;	
			   days++;
		   }
		   nTr.appendChild( nTd );
		}
		tbd.appendChild( nTr );
	}
	
	document.getElementById("tb").style.display = "block";
	document.getElementById("today").innerHTML = curY + "-" + curM + "-" + curD;
	document.getElementById("curdays").innerHTML = curDays+"天（"+curWs + "周+"+curWdays+"天）";
	document.getElementById("moredays").innerHTML = (yqDays - curDays) + "天";
	document.getElementById("outdays").innerHTML = ycDate;
	
	
	$("#toolsr_1").show()
}
   


   function getDate( init ){
   	  var monDays = [0,31,28,31,30,31,30,31,31,30,31,30,31];
   	  if( init ) return setY + "-" + setM + "-" + setD;
 	    if ( ( setY%100 && !(setY%4) ) || !(setY%400) ) monDays[2] = 29;
   	  setD++;
   	  if( setD > monDays[setM] ){
   	  	 setD=1;
   	  	 setM++;
   	  	 if(setM>12) { 
   	  	 	 setY++; 
   	  	 	 setM=1;
   	  	 	 return "<strong style='font-Size:14px;color:red'>"+setY + "年" + setM + "月</strong> ";
   	  	 }
   	  	 return "<strong style='font-Size:14px;color:red'>"+setM + "月</strong > ";
   	  }
      return setD;
   }
   
