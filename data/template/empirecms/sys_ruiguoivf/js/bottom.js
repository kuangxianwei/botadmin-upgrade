$(".navside-fkzr-short").click(function(){
	$(".navside-fkzr-mask").removeClass("hide");
	$(".navside-fkzr-main").animate({'left':'50%'},500).removeClass("hide");
	$(".navside-fkzr-short").hide();
});
$(".navside-fkzr-close").click(function(){
	$(".navside-fkzr-mask").addClass("hide");
	$(".navside-fkzr-main").animate({'left':'0'},500).addClass("hide");
	$(".navside-fkzr-short").show();
});