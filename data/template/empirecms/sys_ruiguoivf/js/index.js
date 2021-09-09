var fn_featureCarousel=$("#carousel").featureCarousel({
    smallFeatureWidth:0.8,
    smallFeatureHeight:0.8,
    sidePadding:0,
    topPadding:0,
    autoPlay:3500,
    smallFeatureOffset:'auto'
});

window.onload=function(){

    $('#carousel').prepend("<div class='clear_b'>&nbsp;</div>");
    $('#carousel .sImg').append("<div id='carousel-left'></div><div id='carousel-right'></div>");
}


$(function(){


    //=================banner
    var swiper = new Swiper('.index_banner', {
        nextButton: '.index_banner .swiper-button-next',
        prevButton: '.index_banner .swiper-button-prev',
        slidesPerView:1,
        slidesPerGroup:1,
        pagination:'.index_banner .swiper-pagination',
        autoplay:5500,
        loop: true,
        centeredSlides: false,
        paginationClickable: true,
        autoplayDisableOnInteraction: false
    });

    //=================专家
    var swiper0 =new Swiper('#myTab2_Content0 .swiper_inTeam', {
        nextButton: '#myTab2_Content0 .swiper-button-next',
        prevButton: '#myTab2_Content0 .swiper-button-prev',
        slidesPerView:4,
        slidesPerGroup:1,
        spaceBetween:20,
        breakpoints: {
            780: { slidesPerView:3, slidesPerGroup:1, spaceBetween:10 }, 480: { slidesPerView:2, slidesPerGroup:2, spaceBetween:10 }, 380: { slidesPerView:1, slidesPerGroup:1, spaceBetween:10 }
        },
        autoplay:5500,
        loop: true,
        centeredSlides: false,
        paginationClickable: true,
        autoplayDisableOnInteraction: false
    });
    var swiper1 = new Swiper('#myTab2_Content1 .swiper_inTeam', {
        nextButton: '#myTab2_Content1 .swiper-button-next',
        prevButton: '#myTab2_Content1 .swiper-button-prev',
        slidesPerView:4,
        slidesPerGroup:1,
        spaceBetween:20,
        breakpoints: {
            780: { slidesPerView:3, slidesPerGroup:1, spaceBetween:10 }, 480: { slidesPerView:2, slidesPerGroup:2, spaceBetween:10 }, 380: { slidesPerView:1, slidesPerGroup:1, spaceBetween:10 }
        },
        autoplay:5500,
        loop: true,
        centeredSlides: false,
        paginationClickable: true,
        autoplayDisableOnInteraction: false
    });
    var swiper2 =new Swiper('#myTab2_Content2 .swiper_inTeam', {
        nextButton: '#myTab2_Content2 .swiper-button-next',
        prevButton: '#myTab2_Content2 .swiper-button-prev',
        slidesPerView:4,
        slidesPerGroup:1,
        spaceBetween:20,
        breakpoints: {
            780: { slidesPerView:3, slidesPerGroup:1, spaceBetween:10 }, 480: { slidesPerView:2, slidesPerGroup:2, spaceBetween:10 }, 380: { slidesPerView:1, slidesPerGroup:1, spaceBetween:10 }
        },
        autoplay:5500,
        loop: true,
        centeredSlides: false,
        paginationClickable: true,
        autoplayDisableOnInteraction: false
    });
    var swiper3 =new Swiper('#myTab2_Content3 .swiper_inTeam', {
        nextButton: '#myTab2_Content3 .swiper-button-next',
        prevButton: '#myTab2_Content3 .swiper-button-prev',
        slidesPerView:4,
        slidesPerGroup:1,
        spaceBetween:20,
        breakpoints: {
            780: { slidesPerView:3, slidesPerGroup:1, spaceBetween:10 }, 480: { slidesPerView:2, slidesPerGroup:2, spaceBetween:10 }, 380: { slidesPerView:1, slidesPerGroup:1, spaceBetween:10 }
        },
        autoplay:5500,
        loop: true,
        centeredSlides: false,
        paginationClickable: true,
        autoplayDisableOnInteraction: false
    });
    var swiper4 =new Swiper('#myTab2_Content4 .swiper_inTeam', {
        nextButton: '#myTab2_Content4 .swiper-button-next',
        prevButton: '#myTab2_Content4 .swiper-button-prev',
        slidesPerView:4,
        slidesPerGroup:1,
        spaceBetween:20,
        breakpoints: {
            780: { slidesPerView:3, slidesPerGroup:1, spaceBetween:10 }, 480: { slidesPerView:2, slidesPerGroup:2, spaceBetween:10 }, 380: { slidesPerView:1, slidesPerGroup:1, spaceBetween:10 }
        },
        autoplay:5500,
        loop: true,
        centeredSlides: false,
        paginationClickable: true,
        autoplayDisableOnInteraction: false
    });


        $('.in_hospital .TabContent .con2 i').each(function(index,li){
            li.innerHTML=li.innerHTML.substring(0,48)+' …'
        });





});
