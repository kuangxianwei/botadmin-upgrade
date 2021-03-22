$(function(){

    //=================右侧图片滚动
    var swiper1 = new Swiper('.swiper_hospital', {
        nextButton: '.swiper_hospital .swiper-button-next',
        prevButton: '.swiper_hospital .swiper-button-prev',
        slidesPerView:1,
        slidesPerGroup:1,
        autoplay:5000,
        loop: true,
        centeredSlides: false,
        paginationClickable: true,
        autoplayDisableOnInteraction: false
    });
    var swiper2 = new Swiper('.swiper_expert', {
        nextButton: '.swiper_expert .swiper-button-next',
        prevButton: '.swiper_expert .swiper-button-prev',
        slidesPerView:1,
        slidesPerGroup:1,
        autoplay:5000,
        loop: true,
        centeredSlides: false,
        paginationClickable: true,
        autoplayDisableOnInteraction: false
    });

    if($('.pageCost')){
        $(".pageCost .page_content_main img").each(function(i){

            $(this).wrap('<div class="box">'+$('.pageCost_bnt').html()+'</div>');
        });
    }



});
