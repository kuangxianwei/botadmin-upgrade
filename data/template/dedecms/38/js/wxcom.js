$(document).ready(function(){

//焦点图
var num=$(".bigpic li").length;
var fwidth=$(".bigpic li").width();
var sec=4000;
var btn = '<ul class="btn"><li class="on">1</li>';
var btnend = '</ul>';
for(i=2;i<=num;i++){btn += '<li>'+i+'</li>';};
btn += btnend;
if(num == 1){btn = null};
$(".focus").append(btn);
$(".bigpic").css("width",fwidth*num);
$(".btn li").bind("mouseover",function(){
  $(this).addClass("on").siblings().removeClass("on");
  var i=$(".btn li").index(this);var marginL=fwidth*i;
  $(".bigpic").animate({"left":-marginL},500);}
);
picTimer = setInterval(timeset,sec);
function timeset(){
  var j = $(".btn li").index($(".on"));
  var timew = fwidth*(j+1);
  if(j == num-1){$(".btn li").eq(0).addClass("on").siblings().removeClass("on");$(".bigpic").animate({"left":0},500);}
            else{$(".btn li").eq(j+1).addClass("on").siblings().removeClass("on");$(".bigpic").animate({"left":-timew},500);};
                  };
$(".focus").mouseover(function(){clearInterval(picTimer);});
$(".focus").bind("mouseout",function(){picTimer = setInterval(timeset,sec);}
);

//收藏夹
 $("#addfavo").click(function(){
if(!$.browser.msie)
{alert('你的浏览器不支持加入收藏夹，请按 Ctrl + D 手动添加');}
});

$(".addfav").animate({marginTop:0},500);
})
