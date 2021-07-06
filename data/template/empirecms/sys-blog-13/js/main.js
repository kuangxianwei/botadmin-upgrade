$(function () {
    var surl = location.href;
    var surl2 = $(".place a:eq(1)").attr("href");
    $("#nav .zh1 li a").each(function () {
        if ($(this).attr("href") == surl || $(this).attr("href") == surl2) $(this).parent().addClass("on")
    });
});

$(document).ready(function () {
    var tags_a = $("#divTags a");
    tags_a.each(function () {
        var x = 9;
        var y = 0;
        var rand = parseInt(Math.random() * (x - y + 1) + y);
        $(this).addClass("tags" + rand);
    });
})


$("#nav>ul>li").hover(function() {
	if($(this).find("li").length > 0){
		$(this).children("ul").stop(true, true).fadeIn(400);
		$(this).addClass("hover");
	}
},function() {
	$(this).children("ul").stop(true, true).fadeOut();
	$(this).removeClass("hover");
});


$(".nav-on").click(function () {
    $("#nav>ul").fadeIn();
});
$(".nav-off").click(function () {
    $("#nav>ul").fadeOut();
});



$(function () {
    var nav = $("#nav"); //得到导航对象
    var win = $(window); //得到窗口对象
    var sc = $(document); //得到document文档对象。
    win.scroll(function () {
        if (sc.scrollTop() >= 100) {
            nav.addClass("fixednav");
            $(".navTmp").fadeIn();
        } else {
            nav.removeClass("fixednav");
            $(".navTmp").fadeOut();
        }
    })
})




$(document).ready(function() { 
    var tags_a = $("#divhottag a"); 
    tags_a.each(function(){ 
        var x = 6; 
        var y = 0; 
        var rand = parseInt(Math.random() * (x - y + 1) + y); 
        $(this).addClass("tags"+rand); 
    }); 
})  

$(document).ready(function() { 
    var tags_a = $("#divrandtag a"); 
    tags_a.each(function(){ 
        var x = 6; 
        var y = 0; 
        var rand = parseInt(Math.random() * (x - y + 1) + y); 
        $(this).addClass("tags"+rand); 
    }); 
})  

$(function(){
    $('.tx-tab-hd li').click(function(){
        $(this).addClass('tx-on').siblings().removeClass('tx-on');
        $('.tx-tab-bd ul').hide().eq($(this).index()).show();
    })
})