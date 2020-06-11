/* ================================================================
This copyright notice must be untouched at all times.
Copyright (c) 2009 Stu Nicholls - stunicholls.com - all rights reserved.
=================================================================== */
$(document).ready(function(){
current = 1;
button = 1;
images = 5;
width = 1308;
$('#p1').animate({"left": "0px"}, 400, "swing");
$('#b'+current).css("backgroundPosition", "0 -14px")
$('#b'+current).css("width", "18px")
$('#b'+current).css("height", "18px");
window.onload = function(){ setInterval(start,5000)}
var start = function(){
button = current;
current++
if (current == (images+1) ) {current = 1}
animateLeft(current,button)
}
$("#next").click(function() {
button = current;
current++
if (current == (images+1) ) {current = 1}
animateLeft(current,button)
});
$("#previous").click(function() {
button = current;
current--
if (current == 0 ) {current = images}
animateRight(current,button)
});
$("#buttons div").click(function() {
button=current;
clickButton = $(this).attr('id');
current = parseInt(clickButton.slice(1));
if (current > button) {animateLeft(current,button)}
if (current < button) {animateRight(current,button)}
});
$("#buttons div b").mouseover(function() {
if (($(this).css("color")) == "#16a" || ($(this).css("color")) == "rgb(17, 102, 170)") {$(this).css("color","#000");}
});
$("#buttons div b").mouseout(function() {
if (($(this).css("color")) == "#000" || ($(this).css("color")) == "rgb(0, 0, 0)") {$(this).css("color","#16a");}
});
function animateLeft(current,button) {
$('#p'+current).css("left",width +"px");
$('#p'+current).animate({"left": "0px"}, 400, "swing");
$('#p'+button).animate({"left": -width+"px"}, 400, "swing");
setbutton()
}
function animateRight(current,button) {
$('#p'+current).css("left",-width+"px");
$('#p'+current).animate({"left": "0px"}, 400, "swing");
$('#p'+button).animate({"left": width+"px"}, 400, "swing");
setbutton()
}
function setbutton () {
$('#b'+button).css("backgroundPosition", "0px 1px")
$('#b'+button).css("width", "18px")
$('#b'+button).css("height", "18px");
$('#b'+current).css("backgroundPosition", "0 -14px")
$('#b'+current).css("width", "18px")
$('#b'+current).css("height", "18px");
}
});
