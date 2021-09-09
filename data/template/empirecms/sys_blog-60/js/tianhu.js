
function topNavScroll(){

    var topScroll = Math.floor($(window).scrollTop());

    if(topScroll>0){
        $('.th_header').css('opacity',0.9);
        $('.th_header').css('transition','1s');
    }
    else{
        $('.th_header').css('opacity',1);
    }
}

$(window).on('scroll',function() {
    topNavScroll();
});


$("#go_top").click(function () {
    $('body,html').animate({ scrollTop: 0 }, 500);
    return false;
});


$("#guan").click(function () {
    $(this).toggleClass("isnight")
    $("body").toggleClass("style-night")
})


$(".wap_headerclick").click(function(){
    $(".wap_display").slideToggle("slow");
    $(this).toggleClass("isnavicon")
});

$('.thhotnews_con dl dd p').replaceWith(function(){
    return $("<span />", {html: $(this).html(), class:$(this).attr('class')});
});

$('.detail-zhaiyao p').replaceWith(function(){
    return $("<span />", {html: $(this).html(), class:$(this).attr('class')});
});


var ua = navigator.userAgent;

var ipad = ua.match(/(iPad).*OS\s([\d_]+)/),

    isIphone =!ipad && ua.match(/(iPhone\sOS)\s([\d_]+)/),

    isAndroid = ua.match(/(Android)\s+([\d.]+)/),

    isMobile = isIphone || isAndroid;



if(isMobile){
    $(".detail-con img").css({"width":"100%"});
}else{

}


$(".wap_headerclick").click(function () {
    $(".child").slideToggle("slow");
});

$(".dot").click(function () {
    $(this).next().slideToggle();
    $(this).parent().siblings().children("ul").slideUp();
});