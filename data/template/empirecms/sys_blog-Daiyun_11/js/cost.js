// 消费表标题点击换表
$(".cost-title").on("click", function () {
  $(this).siblings().removeClass("active");
  $(this).addClass("active");
  var index = $(".cost-title").index(this);
  var length = $(".table").length;
  for (let i = 0; i < length; i++) {
    if (i != index) {
      $(".table")[i].style.display = "none";
    }
  }
  if (length > index) $(".table")[index].style.display = "block";
});

var div = document.createElement("div");
div.className = "container";

$(div).append($(".content-box").children());

$(".content-box").append(div);

document.getElementsByClassName("cost-title")[0].click();
