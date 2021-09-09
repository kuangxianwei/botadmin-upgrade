var mySwiper06 = new Swiper('.swiper-container06',{
effect : 'coverflow',
prevButton:'.swiper-button-prev',
nextButton:'.swiper-button-next',
loop:true,
paginationClickable: true,
autoplayDisableOnInteraction:false,
slidesPerView: 'auto',
centeredSlides: true,
initialSlide: 1,
coverflow: {
			rotate: 0,
			stretch: 144,
			depth: 100,
			modifier: 2,
			slideShadows : false
		}
});