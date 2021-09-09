if (typeof(page) == "undefined") {
  page = "0"
};

$(function() {


$(".g-banner").slide({titCell:".g-arrow li",mainCell:".g-banner-img ul",effect:"leftLoop",autoPlay:true,trigger:"click",titOnClassName:"m-hover"});

    $(".g-hot-color a").each(function() {
        index=$(this).index();
        $(this).addClass("cotx"+index);
    });



  $(".g-img-tank ul li").eq(1).css("margin-right","0px");
  $(".g-img-tank ul li").eq(3).css("margin-right","0px");

  $(".zt ul li:nth-child(16n)").after('<b></b>');

$("#linkSetFav").click(function(){
alert('您的浏览器暂不支持,请按 Ctrl+D 手动收藏!');
})

if(page.sskpage != "index"){


//导航附加背景
    var mentext = window.location.href;
    $(".g-nav li a").each(function(){
        var menturl =  $(this).attr('href');
        if(mentext.indexOf(menturl) != -1){
            $(this).addClass('m-hover');
        }
        $(".g-nav li").children("a:eq(0)").removeClass('m-hover');
    })

}


if(page.sskpage == "index"){
 //右侧悬浮
function gotoTop(min_height){
    //预定义返回代码，样式默认为不显示
    var gotoTop_html = '<div id="gotoBox" class="f-gotoBox"><a href="javascript:;" class="one m-hover">图片说说</a><a href="javascript:;" class="two">伤感说说</a><a href="javascript:;" class="three">个性说说</a><a href="javascript:;"  class="four">心情说说</a><a href="javascript:;" class="five">爱情说说</a><a href="javascript:;"  class="six">经典说说</a><a href="javascript:;"  class="seven">搞笑说说</a><a href="javascript:;"  class="gotop">返回顶部</a></div>';
    $("body").append(gotoTop_html);
    $(".gotop").click(
        function(){$('html,body').animate({scrollTop:0},700);
    }).hover(
        function(){$(this).addClass("hover");},
        function(){$(this).removeClass("hover");
    });
    //获取页面的最小高度，无传入值则默认为600像素
    min_height ? min_height = min_height : min_height = 100;

    //为窗口的scroll事件绑定处理函数
    $(window).scroll(function(){
        //获取窗口的滚动条的垂直位置
        var s = $(window).scrollTop();
        //当窗口的滚动条的垂直位置大于页面的最小高度时，让返回顶部元素渐现，否则渐隐
        if( s > min_height){
            //$("#gotoBox").addClass("u-block");
            $("#gotoBox").fadeIn();
        }else{
            //$("#gotoBox").removeClass("u-block");
            $("#gotoBox").fadeOut();
        };

        if(s >=$('#one').offset().top-50 && s<$('#two').offset().top-50){
            $('#gotoBox a').removeClass('m-hover').eq(0).addClass('m-hover');
        }else if(s>=$('#two').offset().top-50 && s<$('#three').offset().top-50){
            $('#gotoBox a').removeClass('m-hover').eq(1).addClass('m-hover');
        }else if(s>=$('#three').offset().top-50 && s<$('#four').offset().top-50){
            $('#gotoBox a').removeClass('m-hover').eq(2).addClass('m-hover');
        }else if(s>=$('#four').offset().top-50 && s<$('#five').offset().top-150){
            $('#gotoBox a').removeClass('m-hover').eq(3).addClass('m-hover');
        }else if(s>=$('#five').offset().top-50 && s<$('#six').offset().top-250){
            $('#gotoBox a').removeClass('m-hover').eq(4).addClass('m-hover');
        }else if(s>=$('#six').offset().top-150 && s<$('#seven').offset().top-150){
            $('#gotoBox a').removeClass('m-hover').eq(5).addClass('m-hover');
        }       else if(s>=$('#seven').offset().top-150){
            $('#gotoBox a').removeClass('m-hover').eq(6).addClass('m-hover');
        }
    });
     $('.one').click(function(){
        var sTop=$('#one').offset().top;
        $('html,body').animate({scrollTop:sTop+"px"},500)
    });
    $('.two').click(function(){
        var sTop=$('#two').offset().top;
        $('html,body').animate({scrollTop:sTop+"px"},500)
    });
    $('.three').click(function(){
        var sTop=$('#three').offset().top;
        $('html,body').animate({scrollTop:sTop+"px"},500)
    });
    $('.four').click(function(){
        var sTop=$('#four').offset().top;
        $('html,body').animate({scrollTop:sTop+"px"},500)
    });
    $('.five').click(function(){
        var sTop=$('#five').offset().top;
        $('html,body').animate({scrollTop:sTop+"px"},500)
    });
    $('.six').click(function(){
        var sTop=$('#six').offset().top;
        $('html,body').animate({scrollTop:sTop+"px"},500)
    });
    $('.seven').click(function(){
        var sTop=$('#seven').offset().top;
        $('html,body').animate({scrollTop:sTop+"px"},500)
    });
};
gotoTop();
}


});