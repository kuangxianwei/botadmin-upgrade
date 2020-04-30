
//–≈œ¢«–ªª
$(".chanpin").hide();
$(".chanpin:eq(0)").show();
$(".chanpinfenlei li").each(function(index){
       $(this).mouseover(
	   	  function(){
			  $(".chanpinfenlei li").removeClass();
			  $(this).addClass("hover"+index+"");
			  $(".chanpin:visible").hide();
			  $(".chanpin:eq(" + index + ")").show();
	  })
   })


