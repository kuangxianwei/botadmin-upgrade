$(function () {
    new WOW({
        mobile: false
    }).init();

    $('.menu-btn').on('click', function () {
        $('.header').find('.nav').toggle();
    });

    if ($(window).width() > 991) {
        $('.dropdown').hover(function () {
            $(this).addClass('open');
        }, function () {
            $(this).removeClass('open');
        });
    } else {
        $('.dropdown').find('.arr').on('click', function () {
            $(this).parent().toggleClass('open');
        });
    }

    $('.lanmu').find('.arr').on('click', function () {
        $(this).parent().toggleClass('open');
    });


});

function tabsSwiper(menu, con, allowTouchMove) {
    var swiper = new Swiper(con, {
        speed: 500,
        spaceBetween: 10,
        autoHeight: true,
        allowTouchMove: !allowTouchMove,
        on: {
            slideChangeTransitionStart: function () {
                $(menu).find('li').eq(this.activeIndex).addClass('active').siblings().removeClass('active');
            }
        }
    });
    $(menu).on('click', 'li', function (e) {
        $(this).addClass('active').siblings().removeClass('active');
        swiper.slideTo($(this).index());
    });
}

$(document).ready(function(){

	$("#leftsead a").hover(function(){
		if($(this).prop("className")=="youhui"){
			$(this).children("img.hides").show();
		}else{
			$(this).children("img.hides").show();
			$(this).children("img.shows").hide();
			$(this).children("img.hides").animate({marginRight:'0px'},'slow'); 
		}
	},function(){ 
		if($(this).prop("className")=="youhui"){
			$(this).children("img.hides").hide('slow');
		}else{
			$(this).children("img.hides").animate({marginRight:'-143px'},'slow',function(){$(this).hide();$(this).next("img.shows").show();});
		}
	});
	$("#top_btn").click(function(){if(scroll=="off") return;$("html,body").animate({scrollTop: 0}, 300);});

});


	$(function(){
    var banner = new Swiper('.banner', {
        autoplay: true,
        navigation: {
            prevEl: '.banner .swiper-button-prev',
            nextEl: '.banner .swiper-button-next'
        },
        pagination: {
            el: '.banner .swiper-pagination',
            clickable: true
        }
    });
    $('.in-honours').liMarquee({
        scrollamount: 20
    });
    tabsSwiper('.in-case-menu', '.in-case-con');
});
	
	$(function(){
    var surl = location.href;
	var surl2 = $(".curmbs a:eq(1)").attr("href");
	$("#jzclcd li a").each(function() {
		if ($(this).attr("href")==surl || $(this).attr("href")==surl2) $(this).parent().addClass("active")
	});
	$(".nav ul li a").each(function() {
		if ($(this).attr("href")==surl || $(this).attr("href")==surl2) $(this).parent().addClass("active")
	});
});
