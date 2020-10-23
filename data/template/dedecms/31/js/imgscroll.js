
var speed=30
var colee_left4=document.getElementById("colee_left4");
var colee_left3=document.getElementById("colee_left3");
var colee_lef=document.getElementById("colee_lef");
colee_left4.innerHTML=colee_left3.innerHTML
function Marquee3(){
if(colee_left4.offsetWidth-colee_lef.scrollLeft<=0)
colee_lef.scrollLeft-=colee_left3.offsetWidth
else{
colee_lef.scrollLeft++
}
}
var MyMar3=setInterval(Marquee3,speed)
colee_lef.onmouseover=function() {clearInterval(MyMar3)}
colee_lef.onmouseout=function() {MyMar3=setInterval(Marquee3,speed)}
