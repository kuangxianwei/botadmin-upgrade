//重写了common.js里的同名函数
function RevertComment(i){$("#inpRevID").val(i);var frm=$('#comt-respond'),cancel=$("#cancel-reply"),temp=$('#temp-frm');var div=document.createElement('div');div.id='temp-frm';div.style.display='none';frm.before(div);$('#AjaxComment'+i).before(frm);frm.addClass("");cancel.show();cancel.click(function(){$("#inpRevID").val(0);var temp=$('#temp-frm'),frm=$('#comt-respond');if(!temp.length||!frm.length)return;temp.before(frm);temp.remove();$(this).hide();frm.removeClass("");$('.commentlist').before(frm);return false});try{$('#txaArticle').focus()}catch(e){}return false}
//重写GetComments，防止评论框消失
function GetComments(logid,page){$('.com-page').html("Waiting...");$.get(bloghost+"zb_system/cmd.php?act=getcmt&postid="+logid+"&page="+page,function(data){$('#AjaxCommentBegin').nextUntil('#AjaxCommentEnd').remove();$('#AjaxCommentEnd').before(data);$("#cancel-reply").click()})}
function CommentComplete(){$("#cancel-reply").click()};
//图片延迟加载
(function($){$.fn.lazyload=function(options){var settings={threshold:0,failurelimit:0,event:"scroll",effect:"show",container:window};if(options){$.extend(settings,options)}var elements=this;if("scroll"==settings.event){$(settings.container).bind("scroll",function(event){var counter=0;elements.each(function(){if($.abovethetop(this,settings)||$.leftofbegin(this,settings)){}else if(!$.belowthefold(this,settings)&&!$.rightoffold(this,settings)){$(this).trigger("appear")}else{if(counter++>settings.failurelimit){return false}}});var temp=$.grep(elements,function(element){return!element.loaded});elements=$(temp)})}this.each(function(){var self=this;if(undefined==$(self).attr("original")){$(self).attr("original",$(self).attr("src"))}if("scroll"!=settings.event||undefined==$(self).attr("src")||settings.placeholder==$(self).attr("src")||($.abovethetop(self,settings)||$.leftofbegin(self,settings)||$.belowthefold(self,settings)||$.rightoffold(self,settings))){if(settings.placeholder){$(self).attr("src",settings.placeholder)}else{$(self).removeAttr("src")}self.loaded=false}else{self.loaded=true}$(self).one("appear",function(){if(!this.loaded){$("<img />").bind("load",function(){$(self).hide().attr("src",$(self).attr("original"))[settings.effect](settings.effectspeed);self.loaded=true}).attr("src",$(self).attr("original"))}});if("scroll"!=settings.event){$(self).bind(settings.event,function(event){if(!self.loaded){$(self).trigger("appear")}})}});$(settings.container).trigger(settings.event);return this};$.belowthefold=function(element,settings){if(settings.container===undefined||settings.container===window){var fold=$(window).height()+$(window).scrollTop()}else{var fold=$(settings.container).offset().top+$(settings.container).height()}return fold<=$(element).offset().top-settings.threshold};$.rightoffold=function(element,settings){if(settings.container===undefined||settings.container===window){var fold=$(window).width()+$(window).scrollLeft()}else{var fold=$(settings.container).offset().left+$(settings.container).width()}return fold<=$(element).offset().left-settings.threshold};$.abovethetop=function(element,settings){if(settings.container===undefined||settings.container===window){var fold=$(window).scrollTop()}else{var fold=$(settings.container).offset().top}return fold>=$(element).offset().top+settings.threshold+$(element).height()};$.leftofbegin=function(element,settings){if(settings.container===undefined||settings.container===window){var fold=$(window).scrollLeft()}else{var fold=$(settings.container).offset().left}return fold>=$(element).offset().left+settings.threshold+$(element).width()};$.extend($.expr[':'],{"below-the-fold":"$.belowthefold(a, {threshold : 0, container: window})","above-the-fold":"!$.belowthefold(a, {threshold : 0, container: window})","right-of-fold":"$.rightoffold(a, {threshold : 0, container: window})","left-of-fold":"!$.rightoffold(a, {threshold : 0, container: window})"})})(jQuery);
$(function(){$('.side_con li:first-child').addClass('on');$(".side_con li").hover(function(){$(this).addClass("on").siblings().removeClass("on")});$(".postlist img,.entry img,.col-pic img,.post-img img,.cat-scale img,.layout-imgs img,.mx3-thumbnail img").lazyload({placeholder:bloghost+"zb_users/theme/koilee/style/images/grey.gif",effect:"fadeIn",threshold:2,failurelimit:5})});
eval(function(p,a,c,k,e,r){e=function(c){return(c<62?'':e(parseInt(c/62)))+((c=c%62)>35?String.fromCharCode(c+29):c.toString(36))};if('0'.replace(0,e)==0){while(c--)r[e(c)]=k[c];k=[function(e){return r[e]||e}];e=function(){return'([3-9df-hj-loq-zA-DF-Z]|1\\w)'};c=1};while(c--)if(k[c])p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c]);return p}('g(L).M(4(){5 6=$(".17");5 6=$(".6-sousuo,.18");$("#mo-so,.18 a").j(4(){$(".mini_search,.top_search").N()});$(".6-H i").j(4(){$(".17").N();$(".k-6").r("k-6");$(".w-d").I("m-w-d")});$(".zanter,.O-P-close i").j(4(){$(3).r("19");$(".O-P-mask,.O-P").I("19")});g(".s-d .6-J > q,.s-d .6-J > q x q").y(4(){g(3).l(".s-d .m-w-d").not(".9").Q(\'display\',\'none\');g(3).l(".s-d .toggle-btn").bind("j",4(){$(\'.s-d .m-w-d\').f(\'9\');g(3).l().f(4(){8(g(3).hasClass("9")){g(3).r("9");R""}R"9"});g(3).S(".s-d .m-w-d").N()})})});g(L).M(4($){$(\'#T-change span\').j(4(){5 U=\'.entry p\';5 V=1;5 1a=15;5 W=$(U).Q(\'1b\');5 z=parseFloat(W,10);5 1c=W.slice(-2);5 A=$(3).o(\'A\');switch(A){1d\'T-dec\':z-=V;1e;1d\'T-inc\':z+=V;1e;default:z=1a}$(U).Q(\'1b\',z+1c);R false})});g(L).M(4($){5 t=$(".k-6").o("B-type");$("#backTop").1f();$(\'.6-H i\').j(4(){$(\'.home\').I(\'h-X\')});$(\'.6-H i\').j(4(){$(\'.6-H i\').I(\'9\')});$(\'#monavber q\').hover(4(){$(3).f(\'X\')},4(){$(3).r(\'X\')});$(\'.1g\').y(4(){$(3).l().Y(0).show()});$(\'#Z\').y(4(){$(3).l().Y(0).f(\'11\')});$(\'#Z\').l().mouseover(4(){$(3).f(\'11\').S().r(\'11\');5 u=$(\'#Z\').l().u(3);$(\'.1g\').l().Y(u).fadeIn(300).S().1f()});$(".6-J>q ").y(4(){1h{5 v=$(3).o("A");8("u"==t){8(v=="1i-1j-u"){$("#1i-1j-u").f("9")}}C 8("D"==t){5 7=$(".k-6").o("B-7");8(7!=F){5 b=7.1k(\' \');1l(5 i=0;i<b.12;i++){8(v=="h-D-"+b[i]){$("#h-D-"+b[i]+"").f("9")}}}}C 8("article"==t){5 7=$(".k-6").o("B-7");8(7!=F){5 b=7.1k(\' \');1l(5 i=0;i<b.12;i++){8(v=="h-D-"+b[i]){$("#h-D-"+b[i]+"").f("9")}}}}C 8("13"==t){5 7=$(".k-6").o("B-7");8(7!=F){8(v=="h-13-"+7){$("#h-13-"+7+"").f("9")}}}C 8("14"==t){5 7=$(".k-6").o("B-7");8(7!=F){8(v=="h-14-"+7){$("#h-14-"+7+"").f("9")}}}}1m(E){}});$(".k-6").delegate("a","j",4(){$(".6-J>q").y(4(){$(3).r("9")});8($(3).G("x")!=F&&$(3).G("x").12!=0){8($(3).G("x").o("A")=="d-navigation"){$(3).f("9")}C{$(3).G("x").G("q").f("9")}}})});1h{1n.K&&1n.K.16&&(K.16("\\u4eb2\\u7231\\u6ef4\\u7ae5\\u978b\\uff0c\\u795d\\u8d3a\\u4f60\\u559c\\u63d0\\u5f69\\u86cb\\u007e\\n"),K.16("%c\\u6709\\u95ee\\u9898\\u8bf7\\u7559\\u8a00\\u53cd\\u9988\\uff01","color:red"))}1m(e){};',[],86,'|||this|function|var|nav|infoid|if|active||||menu||addClass|jQuery|navbar||click|header|children|||attr||li|removeClass|mobile|datatype|index|myid|sub|ul|each|fs_css_c|id|data|else|category||null|closest|sjlogo|toggleClass|pills|console|document|ready|slideToggle|rewards|popover|css|return|siblings|font|selector|increment|fs_css|on|eq|tab||tabhover|length|page|tag||log|mobile_aside|search_top|primary|font_size|fontSize|fs_unit|case|break|hide|con_one_list|try|nvabar|item|split|for|catch|window'.split('|'),0,{}))
$("<span class='toggle-btn'><i class='fa fa-plus'></i></span>").insertBefore(".sub-menu");$("#post_wy1,#post_box1,#post_box2,#post_box3,#shangxi,.sidebar_widget:nth-child(1),.sidebar_widget:nth-child(2)").removeClass("wow");$("#post_wy1,#post_box1,#post_box2,#post_box3,#shangxi,.sidebar_widget:nth-child(2)").removeClass("fadeInDown");$(function(){var lljtnav=$(".fixed-nav");var cubuk_seviye=$(document).scrollTop();var header_yuksekligi=$('.fixed-nav').outerHeight();$(window).scroll(function(){var kaydirma_cubugu=$(document).scrollTop();if(kaydirma_cubugu>header_yuksekligi){$('.fixed-nav').addClass('fixed-enabled')}else{$('.fixed-nav').removeClass('fixed-enabled')};if(kaydirma_cubugu>cubuk_seviye){$('.fixed-nav').removeClass('fixed-appear')}else{$('.fixed-nav').addClass('fixed-appear')};cubuk_seviye=$(document).scrollTop()})});
//快捷回复
$(document).keypress(function(e) {
  var s = $('.button');
  if (e.ctrlKey && e.which == 13 || e.which == 10) {
    s.click();
    document.body.focus();
    return
  };
  if (e.shiftKey && e.which == 13 || e.which == 10) s.click();
});
//导航高亮
$(function(){
  var surl = $(".place a:eq(1)").attr("href");
  var surl2 = location.href;
  $("#monavber ul li a").each(function () {
    if ($(this).attr("href") == surl || $(this).attr("href") == surl2){
      $(this).parent('li').addClass("active");
    } 
  });
});
//backtop
$(function() {
  $("#backtop").each(function() {
    $(this).find(".weixin").mouseenter(function() {
      $(this).find(".pic").fadeIn("fast")
    });
    $(this).find(".weixin").mouseleave(function() {
      $(this).find(".pic").fadeOut("fast")
    });
    $(this).find(".phone").mouseenter(function() {
      $(this).find(".phones").fadeIn("fast")
    });
    $(this).find(".phone").mouseleave(function() {
      $(this).find(".phones").fadeOut("fast")
    });
    $(this).find(".top").click(function() {
      $("html, body").animate({
        "scroll-top": 0
      },
      "fast")
    });
    $(".bottom").click(function() {
      $("html, body").animate({
        scrollTop:$(".footer").offset().top
      },800);
      return false;
    });
  });
  var lastRmenuStatus = false;
  $(window).scroll(function() {
    var _top = $(window).scrollTop();
    if (_top > 500) {
      $("#backtop").data("expanded", true)
    } else {
      $("#backtop").data("expanded", false)
    }
    if ($("#backtop").data("expanded") != lastRmenuStatus) {
      lastRmenuStatus = $("#backtop").data("expanded");
      if (lastRmenuStatus) {
        $("#backtop .top").slideDown()
      } else {
        $("#backtop .top").slideUp()
      }
    }
  })
});
//标签
(function() {
  var sc = $(document);
  var tags_a = $("#divTags ul li,#hottags ul li");
  tags_a.each(function() {
    var x = 10;
    var y = 0;
    var rand = parseInt(Math.random() * (x - y + 1) + y);
    $(this).addClass("divTags" + rand);
  });
})();
//UBB
function addNumber(a){document.getElementById("txaArticle").value+=a}
if($('#comment-tools').length){objActive="txaArticle";function InsertText(a,b,c){if(b==""){return("")}var d=document.getElementById(a);if(document.selection){if(d.currPos){if(c&&(d.value=="")){d.currPos.text=b}else{d.currPos.text+=b}}else{d.value+=b}}else{if(c){d.value=d.value.slice(0,d.selectionStart)+b+d.value.slice(d.selectionEnd,d.value.length)}else{d.value=d.value.slice(0,d.selectionStart)+b+d.value.slice(d.selectionStart,d.value.length)}}}
function ReplaceText(a,b,c){var d=document.getElementById(a);var e;if(document.selection&&document.selection.type=="Text"){if(d.currPos){var f=document.selection.createRange();f.text=b+f.text+c;return("")}else{e=b+c;return(e)}}else{if(d.selectionStart||d.selectionEnd){e=b+d.value.slice(d.selectionStart,d.selectionEnd)+c;return(e)}else{e=b+c;return(e)}}}
if($('#ComtoolsFrame').length){$(this).bind("click",function(a){if(a&&a.stopPropagation){a.stopPropagation()}else{a.cancelBubble=true}})}}
if($('.face-show').length){$("a.face-show").click(function(){$(".ComtoolsFrame").slideToggle()})}
function CommentComplete(){if($('.msgarticle,#divNewcomm,#divComments').length){$('.msgarticle,#divNewcomm,#divComments').each(function comreplace(){var a=$(this).html();a=a.replace(/\[B\](.*)\[\/B\]/g,'<strong>$1</strong>');a=a.replace(/\[U\](.*)\[\/U\]/g,'<u>$1</u>');a=a.replace(/\[S\](.*)\[\/S\]/g,'<del>$1</del>');a=a.replace(/\[I\](.*)\[\/I\]/g,'<em>$1</em>');a=a.replace(/\[([A-Za-z0-9]*)\]/g,'<img src="'+bloghost+'/zb_users/theme/koilee/include/emotion/$1.png">');$(this).html(a)})}}CommentComplete();
function GetComments(postid,page){$.get(bloghost+"zb_system/cmd.php?act=getcmt&postid="+postid+"&page="+page,function(data){$('#AjaxCommentBegin').nextUntil('#AjaxCommentEnd').remove();$('#AjaxCommentBegin').after(data);CommentComplete()})}