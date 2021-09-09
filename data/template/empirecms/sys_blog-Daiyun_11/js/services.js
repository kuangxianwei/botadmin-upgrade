const backTop = function (event) {
  event.stopPropagation();
  var timer = setInterval(function () {
    if (document.documentElement.scrollTop >= 3000)
      document.documentElement.scrollTop -= 100;
    else if (document.documentElement.scrollTop >= 2000)
      document.documentElement.scrollTop -= 90;
    else if (document.documentElement.scrollTop >= 1000)
      document.documentElement.scrollTop -= 80;
    else if (document.documentElement.scrollTop >= 500)
      document.documentElement.scrollTop -= 70;
    else document.documentElement.scrollTop -= 10;
    if (document.documentElement.scrollTop <= 0) {
      clearTimeout(timer);
    }
  }, 2);
};

const close = function (event) {
  $(".zhezhaocen3").addClass("cenclose");
  $(".zhezhaocen").addClass("cenclose");
};

$(".back").on("click", backTop);
$(".close").on("click", close);

// $(".hot_line_box").on("mouseover", function (e) {
//   $(".hot_line1").css("display", "block");
// });
// $(".hot_line_box").on("mouseout", function (e) {
//   $(".hot_line1").css("display", "none");
// });

$(".menuList").on("mousedown", function (e) {
  $(this).addClass("active");
  $(this).siblings().removeClass("active");
});

let listH2 = document.querySelectorAll("h2");
if (listH2 && listH2.length) {
  listH2.forEach((p) => {
    p.innerHTML = p.textContent.trim();
  });
}

var div = document.createElement("div");
div.className = "container";

$(div).append($(".wrapper-bottom").children());

$(".wrapper-bottom").append(div);

var div1 = document.createElement("div");
div1.className = "container";

$(div1).append($(".zhezhaocen").children()).append($(".zz-button"));

$(".zhezhaocen").append(div1);

var isShow = false;
$(".menu").on("click", function () {
  if (!isShow) {
    $(".header").removeClass("header-hide").addClass("header-show");
    $(".wrapper-head-no2 ul").removeClass("ul-hide").addClass("ul-show");
  } else {
    $(".header").removeClass("header-show").addClass("header-hide");
    $(".wrapper-head-no2 ul").removeClass("ul-show").addClass("ul-hide");
  }
  isShow = !isShow;
});

$(".checkedDoctor").on("click", function (e) {
  if (!e.target.className) {
    e.target.className = "doctorActive";
    $(".doctor-content").each(function (index, item) {
      if (window.innerWidth < 768) {
        return;
      } else {
        if ($(item).hasClass("hide_all")) {
          $(item).removeClass("hide_all");
          $(".doctorMore").children().eq(1).css("display", "block");
          $(".doctorMore").children().eq(0).css("display", "none");
        } else {
          $(item).addClass("hide_all");
          $(".doctorMore").children().eq(0).css("display", "block");
          $(".doctorMore").children().eq(1).css("display", "none");
        }
      }
    });

    if (window.innerWidth < 768) {
      if (e.target.innerHTML.indexOf("医院") !== -1) {
        $(".ivf-hospital-box").css("display", "flex");
        $(".ivf-doctor-box").css("display", "none");
      } else {
        $(".ivf-hospital-box").css("display", "none");
        $(".ivf-doctor-box").css("display", "flex");
      }
    }
    $(e.target).siblings().removeClass("doctorActive");
  }
});

$(".back-top").on("click", function () {
  window.scrollTo(0, 0);
});

$(".cancel").on("click", function () {
  $(".pop-up-wrapper").css("display", "none");
  $(".telephone-counseling").css("display", "none");
});

$(".phone-consult").on("click", function () {
  $(".pop-up-wrapper").css("display", "block");
  $(".telephone-counseling").css("display", "block");
});

$(".weixin-consult").on("click", function () {
  $(".pop-up-wrapper").css("display", "block");
  $(".service-weixin").css("display", "block");
});
$(".close").on("click", function () {
  $(".pop-up-wrapper").css("display", "none");
  $(".service-weixin").css("display", "none");
});
$(".menu").on("click", function () {
  if ($(".menu-list1 ul").hasClass("spread")) {
    $(".menu-list1 ul").removeClass("spread");
  } else {
    $(".menu-list1 ul").addClass("spread");
  }
});

