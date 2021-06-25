function pcnav() {
    var fixednav = $(".nav"),st
    if($('div').hasClass('nav')){
        var fixednav1 = $(".nav").offset().top;
    }
    $(window).scroll(function () {
        st = Math.max(document.body.scrollTop || document.documentElement.scrollTop);
        if(st > fixednav1){
            fixednav.addClass("fixednav");
            $(".nav-seize1").css({"height":"60px"})
        }else{
            fixednav.removeClass("fixednav");
            $(".nav-seize1").css({"height":"0"})
        }
    });

    $(".nav>ul>li").hover(function() {
        if($(this).find("li").length > 0){
            $(this).children("ul").stop(true, true).slideDown();
            $(this).addClass("hover");
        }
    },function() {
        $(this).children("ul").stop(true, true).slideUp();
        $(this).removeClass("hover");
    });
    
    $(window).scroll(function(){
        if($(document).scrollTop()>=400){
            $(".gotop").fadeIn();
        }else{
            $(".gotop").fadeOut();
        }
    });
    $(".gotop").click(function(){
        $('body,html').animate({scrollTop:0},1000);
    });
}

function wapnav() {
    $(".nav-on").click(function() {
        $(".nav").fadeIn()
        $(".nav>ul").stop(true, true).animate({right:"0"});
    });
    $(".nav-seize").click(function() {
        $(".nav>ul").stop(true, true).animate({right:"-300"});
        $(".nav").fadeOut();
    });
}

$(function(){
    var winr=$(window); 
    var surl = location.href;
    var surl2 = $(".place a:eq(1)").attr("href");
    $(".nav li a").each(function() {
        if ($(this).attr("href")==surl || $(this).attr("href")==surl2) $(this).parent().addClass("on");
    });
    if(winr.width()>=1198){
        
        pcnav();
    }else{
        wapnav();
    }
    $(window).resize(function(){
        if( winr.width() >=1190){
            pcnav();
        }else{
            wapnav();
        }
    });
});


