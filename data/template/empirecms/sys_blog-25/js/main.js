
//手机版导航按钮
$(document).ready(function(){
  $("#mnav").click(function(){
    $("#navul").fadeToggle(500);
  });
});
(function() {
		window.scrollBox = function(a) {
			var b = this;
			b.box = a.box || ".scrollBox";
			b.top = a.top || "0px";
			b.minWidth = a.minWidth || 0;
			b.bottom = a.bottom || 0;
			b.space = a.space || 20;
			b.transition = a.transition == false ? false : true;
			if (a.maxHeightBox) {
				b.maxHeight = $(a.maxHeightBox).offset().top + $(a.maxHeightBox).height()
			}
			b.init()
		};
		scrollBox.prototype = {
			init: function() {
				var e = this,
					d = window.innerWidth,
					b = window.innerHeight;
				boxT = $(e.box).offset().top, boxH = $(e.box).height(), boxMT = 0;
				$(window).resize(function() {
					e.throttle(c, 200, 3000)()
				});
				if (d >= e.minWidth) {
					if (e.transition) {
						$(e.box).css("transition", "margin 0.1s ease-out");
						$(window).scroll(function() {
							e.throttle(a, 200, 3000)()
						})
					} else {
						$(window).scroll(function() {
							a()
						})
					}
					a()
				}
				function c() {
					d = window.innerWidth;
					b = window.innerHeight;
					boxT = $(e.box).offset().top - parseFloat($(e.box).css("margin-top"));
					boxH = $(e.box).height()
				}
				function a() {
					if (d >= e.minWidth) {
						if (e.maxHeight < boxT + boxH + e.space) {
							return false
						}
						var g = $(window).scrollTop();
						if (boxH > b - e.top - e.space * 2) {
							if (g <= (boxT - e.top - e.space)) {
								$(e.box).css({
									"margin-top": "0"
								})
							} else {
								if (e.maxHeight) {
									if (g > e.maxHeight + e.space - b) {
										$(e.box).css({
											"margin-top": e.maxHeight - boxT - boxH + "px"
										});
										return false
									}
								}
								var f = g - boxT - (boxH + e.bottom + e.space - b);
								if (f < boxMT) {
									if (g < $(e.box).offset().top - e.top - e.space) {
										boxMT = g - boxT + e.top + e.space
									}
								} else {
									boxMT = f
								}
								$(e.box).css({
									"margin-top": boxMT + "px"
								})
							}
						} else {
							if (g <= (boxT - e.top - e.space)) {
								$(e.box).css({
									"margin-top": "0"
								})
							} else {
								if (e.maxHeight) {
									if (g > e.maxHeight - boxH - e.top - e.space) {
										return false
									}
								}
								var f = g - boxT + e.top + e.space;
								$(e.box).css({
									"margin-top": f + "px"
								})
							}
						}
					}
				}
			},
			throttle: function(c, b, a) {
				var e = null;
				var d = null;
				return function() {
					var f = +new Date();
					!d && (d = f);
					if (a && f - d > a) {
						c();
						d = f
					} else {
						clearTimeout(e);
						e = setTimeout(function() {
							c();
							d = null
						}, b)
					}
				}
			}
		}
	}());