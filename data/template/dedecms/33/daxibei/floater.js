lastScrollY = 0;
function heartBeat(){
 var diffY;
 if (document.documentElement && document.documentElement.scrollTop)
  diffY = document.documentElement.scrollTop;
 else if (document.body)
  diffY = document.body.scrollTop
 percent=.1*(diffY-lastScrollY);
 if(percent>0){
  percent=Math.ceil(percent);
 }
 else{
  percent=Math.floor(percent);
 }
//document.getElementById("leftDiv").style.top = parseInt(document.getElementById("leftDiv").style.top)+percent+"px";
 document.getElementById("rightDiv").style.top = parseInt(document.getElementById("rightDiv").style.top)+percent+"px";
 lastScrollY=lastScrollY+percent;
}
//del this,the div won't float
window.setInterval("heartBeat()",1);
//close button
function close_left(){
    document.getElementById('left1').style.visibility='hidden';
}
function close_right(){
    document.getElementById('right1').style.visibility='hidden';
}
//css set
document.writeln("<style type=\"text\/css\">");
document.writeln("#leftDiv,#rightDiv{position:absolute}");
document.writeln("<\/style>");
//------leftDiv begin
//document.writeln("<div id=\"leftDiv\" style=\"top:100px;left:5px\">");
//document.writeln("<div id=\"left1\">");
//document.writeln("<a href=\"javascript:close_left();\">close<\/a>");
//document.writeln("<\/div>");
//document.writeln("<\/div>");
//------leftDiv over,right begin
document.writeln("<div id=\"rightDiv\" style=\"top:195px;right:5px\">");
document.writeln("<div id=\"right1\">");
document.writeln("<div class=\"qqtop\"><a href=\"javascript:close_right();\" title=\"close\"><\/a></div>");
document.writeln("<div class=\"qqmid\"><a target=blank href=tencent://message/?uin=1248641960&Site=&Menu=yes></a></div>");
document.writeln("<div class=\"qqmid\"><a target=blank href=tencent://message/?uin=1248641960&Site=&Menu=yes></a></div>");
document.writeln("<div class=\"qqmid\"><br><a target=blank href=\"http://store.taobao.com/shop/view_shop.htm?asker=wangwang&shop_nick=nyyyb%B3%A7%BC%D2%D6%B1%CF%FA%B5%EA\"><img src=/template/images/online.gif /></a></div>");
document.writeln("<div class=\"qqbot1\"></div>");
document.writeln("<div class=\"qqbot\"></div>");
document.writeln("<\/div>");
document.writeln("<\/div>");
//------right over
