// 悬浮导航
function topNavScroll(){  
    //获取当前窗口滚动条顶部所在的像素值 并取整
    var topScroll = Math.floor($(window).scrollTop());     
    //定义滚动条只要大于0 背景透明度就变成1 并且增加转换时间为1s
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
    $(".wap_display").toggle(150);
    $(this).toggleClass("isnavicon")
});

$('.thhotnews_con dl dd p').replaceWith(function(){
        return $("<span />", {html: $(this).html(), class:$(this).attr('class')});
    });

$('.detail-zhaiyao p').replaceWith(function(){
        return $("<span />", {html: $(this).html(), class:$(this).attr('class')});
    });

    $('.th_icon').click(function () {
        let menuWidth = $('.wap_nav').css("width");
        if (menuWidth == '0px') {
            $('.wap_nav').css("width", "150px");
            $('.mouk').show();
        } else {
            $('.wap_nav').css("width", "0px");
        }
    })

    $('.mouk').click(function (event) {
        let menuWidth = $('.wap_nav').css("width");
        if (menuWidth != '0px') {
            $('.wap_nav').css("width", "0px");
            $('.mouk').hide();
        }
    });
