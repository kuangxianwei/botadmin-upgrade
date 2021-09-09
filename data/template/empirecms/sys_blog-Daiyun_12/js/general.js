function goTop() {
  let sTop = document.documentElement.scrollTop || document.body.scrollTop;
  if (sTop > 0) {
    window.requestAnimationFrame(goTop);
    window.scrollTo(0, sTop - sTop / 8);
  }
}
var tips;
var theTop = 120;
var old = theTop;

function initFloatTips() {
  document.getElementById("callme").style.display = "block";
  tips = document.getElementById("callme");
  moveTips();
}

function moveTips() {
  var tt = 50;
  if (window.innerHeight) {
    pos = window.pageYOffset;
  } else if (document.documentElement && document.documentElement.scrollTop) {
    pos = document.documentElement.scrollTop;
  } else if (document.body) {
    pos = document.body.scrollTop;
  }
  pos = pos - tips.offsetTop + theTop;
  pos = tips.offsetTop + pos / 10;
  if (pos < theTop) pos = theTop;
  if (pos != old) {
    tips.style.top = pos + "px";
    tt = 10;
  }
  old = pos;
  setTimeout(moveTips, tt);
}
initFloatTips();

$(".close").on("click", function () {
  $(".bt-callme").hide();
});

window.onscroll = function () {
  if ($(".svg-gotop").hasClass("svg-show") && $(window).scrollTop() < 800)
    return $(".svg-gotop").removeClass("svg-show");
  if (!$(".svg-gotop").hasClass("svg-show") && $(window).scrollTop() < 800)
    return;
  $(".svg-gotop").addClass("svg-show");
};

var visibleNav = false;

$(".img-nav").on("click", function () {});

$(".weixin-visible").on("click", function () {
  $(".modal-weixin").css("display", "block");
  $("body").css("overflow", "hidden");
});

$(".modal-weixin").on("click", function (e) {
  if (!$(e.target).hasClass("modal-weixin")) return;
  $("body").css("overflow", "auto");
  $(".modal-weixin").css("display", "none");
});

$("body").on("click", function (e) {
  if ($(e.target).hasClass("nav-less") || $(e.target).hasClass("img-nav")) {
    if (!visibleNav) $(".m-nav").css("display", "block");
    else $(".m-nav").css("display", "none");
    visibleNav = !visibleNav;
    return;
  }

  if (!$(".m-nav").find($(e.target)).length) {
    $(".m-nav").css("display", "none");
    visibleNav = false;
  }
});

function closeAside() {
  $("#callme").css("display", "none");
}



var allA = document.querySelectorAll('.ivf-issue-wrapper > .issue-item')

allA.forEach(p => {
  $(p).append($(p).next())
})

window.onload = function () {
  var scriptEl = document.createElement('script')
  scriptEl.src = 'http://dct.zoosnet.net/JS/LsJS.aspx?siteid=DCT22989713&float=1&lng=cn'
  document.body.append(scriptEl)
}