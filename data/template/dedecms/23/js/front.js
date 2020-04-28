$(function(){
	//选项卡 JSCode by JJ from lyabc.net @2013-10-19
	$("#i_promise_title ul li a").mouseenter(function(){
		var num = parseInt($(this).attr("num"));
		$("#i_promise_title ul li a").removeClass("current");

        $(this).delay(1500).addClass("current");

		$(".i_promise").hide().eq(num).show();

	});

});
