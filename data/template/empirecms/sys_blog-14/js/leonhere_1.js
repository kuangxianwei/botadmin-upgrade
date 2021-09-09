$(function(){	
	$('li.wx').click(function(){
		$(this).toggleClass('open');
	});
	$('.nav .menu > ul > li').each(function(){
		var $_ul = $(this).children('ul');
		if($_ul.length > 0){
			$(this).children('a').append('<i class="icon-down-open"></i>');
			$(this).append('<em></em>');
		}
	});
	$('.nav .menu ul li').hover(function(){
		$(this).addClass('on').children('ul').addClass('show');
	},function(){
		$(this).removeClass('on').children('ul').removeClass('show');
	});
	$('.navBtn').click(function(){
		$('.nav,body').addClass('open');
	});
	$('.navTitle .close, .navTitle .navMenu').click(function(){
		$('.nav,body').removeClass('open');
	});
	$('.nav li em').click(function(){
		$(this).siblings('ul').slideToggle('fast').parent().siblings().children('ul').slideUp('fast');
	});
	if($('.sideNav').length > 0){
		var $_sideNavText = $('.sideNav li.on').text();
		$('.sideNav > span').text($_sideNavText);
		$('.sideNav span').click(function(){
			$(this).toggleClass('open');
			$(this).siblings('ul').slideToggle('fast');
		});
	}
	$('.search_form .submit').click(function(){
		var $_val = $('.search_form .s').val();
		if($_val == ''){
			alert('请先输入搜索关键词');
			return false;
		}
	});
	$('#backtop').click(function(){
		$('html,body').animate({scrollTop:0},500);
	});
	var _hdOffsetTop = $('.header').offset().top;
	$(window).scroll(function(){
		var _scrollTop = $(window).scrollTop();
		if(_scrollTop >= _hdOffsetTop){
			$('.header').addClass('fixed');
		}else{
			$('.header').removeClass('fixed');
		}
	});
	$('.post .entry img').attr('height','auto');
	$('.post .entry img').css('height','auto');
});

zbp.plugin.on("comment.reply", "zbfifth", function(id) {
	var i = id;
	$("#inpRevID").val(i);
	var frm = $('#divCommentPost'),
		cancel = $("#cancel-reply");

	frm.before($("<div id='temp-frm' style='display:none'>")).addClass("reply-frm");
	$('#AjaxComment' + i).before(frm);

	cancel.show().click(function() {
		var temp = $('#temp-frm');
		$("#inpRevID").val(0);
		if (!temp.length || !frm.length) return;
		temp.before(frm);
		temp.remove();
		$(this).hide();
		frm.removeClass("reply-frm");
		return false;
	});
	try {
		$('#txaArticle').focus();
	} catch (e) {}
	return false;
});

zbp.plugin.on("comment.get", "zbfifth", function (logid, page) {
	$('span.commentspage').html("Waiting...");
	$.get(bloghost + "zb_system/cmd.php?act=getcmt&postid=" + logid + "&page=" + page, function(data) {
		$('#AjaxCommentBegin').nextUntil('#AjaxCommentEnd').remove();
		$('#AjaxCommentEnd').before(data);
		$("#cancel-reply").click();
	});
})

zbp.plugin.on("comment.postsuccess", "zbfifth", function () {
	$("#cancel-reply").click();
});