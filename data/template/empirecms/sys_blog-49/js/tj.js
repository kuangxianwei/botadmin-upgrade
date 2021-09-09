//高度计算
$(function() {
		//高度计算
		$("i.lpic img").height($("i.lpic img").width() / (4 / 3));
		
		$(".in_right3 img").height($(".in_right3 img").width() / (4 / 3));
		$(".inleft_new img").height($(".inleft_new img").width() / (4 / 3));
		
		
		//手机图片居中
		
		$(".content_cn p img").parent().addClass("phone_img")

});

//统计

var _hmt = _hmt || [];
(function() {
  var hm = document.createElement("script");
  hm.src = "https://hm.baidu.com/hm.js?92c7e4aa6b0f06ff7e3509d0fe109730";
  var s = document.getElementsByTagName("script")[0]; 
  s.parentNode.insertBefore(hm, s);
})();


//百度推送

document.write ('<script data-ad-client="ca-pub-4693782011258163" async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>');
