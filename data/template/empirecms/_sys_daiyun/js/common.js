//关闭click.bs.dropdown.data-api事件，使顶级菜单可点击
$(document).off('click.bs.dropdown.data-api');
//自动展开
$('.nav li').mouseenter(function(){
	$(this).addClass('open');
});
//自动关闭
$('.nav li').mouseleave(function(){
	$(this).removeClass('open');
});

//动态数字计数
jQuery(document).ready(function($) {

    $.fn.countTo = function(a) {
        a = a || {};
        return $(this).each(function() {
            var c = $.extend({},
            $.fn.countTo.defaults, {
                from: $(this).data("from"),
                to: $(this).text(),
                speed: 3000,
                refreshInterval: $(this).data("refresh-interval"),
                decimals: $(this).data("decimals")
            },
            a);
            var h = Math.ceil(c.speed / c.refreshInterval),
            i = (c.to - c.from) / h;
            var j = this,
            f = $(this),
            e = 0,
            g = c.from,
            d = f.data("countTo") || {};
            f.data("countTo", d);
            if (d.interval) {
                clearInterval(d.interval)
            }
            d.interval = setInterval(k, c.refreshInterval);
            b(g);
            function k() {
                g += i;
                e++;
                b(g);
                if (typeof(c.onUpdate) == "function") {
                    c.onUpdate.call(j, g)
                }
                if (e >= h) {
                    f.removeData("countTo");
                    clearInterval(d.interval);
                    g = c.to;
                    if (typeof(c.onComplete) == "function") {
                        c.onComplete.call(j, g)
                    }
                }
            }
            function b(m) {
                var l = c.formatter.call(j, m, c);
                f.html(l)
            }
        })
    };
    $.fn.countTo.defaults = {
        from: 0,
        to: 0,
        speed: 1000,
        refreshInterval: 100,
        decimals: 0,
        formatter: formatter,
        onUpdate: null,
        onComplete: null
    };
    function formatter(b, a) {
        return b.toFixed();
    }
    $(".timer").data("countToOptions", {
        formatter: function(b, a) {
            return b.toFixed().replace(/\B(?=(?:\d{3})+(?!\d))/g, ",");
        }
    });
    $(".timer").each(count);
    function count(a) {
        var b = $(this);
        a = $.extend({},
        a || {},
        b.data("countToOptions") || {});
        b.countTo(a)
    };
});


//tab
$(document).ready(function(){
	$(".div-tab-head>li").click( function(){
		var index=$(this).index();
		$(this).addClass("head-on").siblings().removeClass("head-on");
		$(".week").addClass("week-on").eq(index).siblings(".week").removeClass("week-on");
	});
})


//不间断滚动
var timer='';//设置一个定时器
var $box1=$('#box1').children().clone(true);/*克隆box1的子元素*/
$('#box2').append($box1);//将复制的元素插入到#box2中
var $left=parseInt($('.box').css('left'));//获取.box的left值
var scroll=function(){
    $left-=2;//设置滚动速度为2
    $('.box').css('left',$left+'px');//left赋值
    if($left<-1460){//当box值小于-1500px时，重置.box left值为0；
    $('.box').css('left','0');
    $left=0;
}
timer =setTimeout(scroll,30);
}
setTimeout(scroll,100);
$('.wrap').hover(function(){
    clearTimeout(timer);
},function(){
    setTimeout(scroll,100);
});


; (function ($) {
    $.extend({
        'foucs': function (con) {
            var $container = $('#index_b_hero')
                , $imgs = $container.find('li.hero')
            , $leftBtn = $container.find('a.prev')
            , $rightBtn = $container.find('a.next')
            , config = {
                interval: con && con.interval || 3500,
                animateTime: con && con.animateTime || 500,
                direction: con && (con.direction === 'right'),
                _imgLen: $imgs.length
            }
            , i = 0
            , getNextIndex = function (y) { return i + y >= config._imgLen ? i + y - config._imgLen : i + y; }
            , getPrevIndex = function (y) { return i - y < 0 ? config._imgLen + i - y : i - y; }
            , silde = function (d) {
                $imgs.eq((d ? getPrevIndex(2) : getNextIndex(2))).css('left', (d ? '-1920px' : '1920px'))
                $imgs.animate({
                    'left': (d ? '+' : '-') + '=960px'
                }, config.animateTime);
                i = d ? getPrevIndex(1) : getNextIndex(1);
            }
            , s = setInterval(function () { silde(config.direction); }, config.interval);
            $imgs.eq(i).css('left', 0).end().eq(i + 1).css('left', '960px').end().eq(i - 1).css('left', '-960px');
            $container.find('.hero-wrap').add($leftBtn).add($rightBtn).hover(function () { clearInterval(s); }, function () { s = setInterval(function () { silde(config.direction); }, config.interval); });
            $leftBtn.click(function () {
                if ($(':animated').length === 0) {
                    silde(false);
                }
            });
            $rightBtn.click(function () {
                if ($(':animated').length === 0) {
                    silde(true);
                }
            });
        }
    });
}(jQuery));


; (function ($) {
    $.extend({
        'foucs1': function (con) {
            var $container = $('#index_b_hero1')
                , $imgs = $container.find('li.hero')
            , $leftBtn = $container.find('a.prev')
            , $rightBtn = $container.find('a.next')
            , config = {
                interval: con && con.interval || 3500,
                animateTime: con && con.animateTime || 500,
                direction: con && (con.direction === 'right'),
                _imgLen: $imgs.length
            }
            , i = 0
            , getNextIndex = function (y) { return i + y >= config._imgLen ? i + y - config._imgLen : i + y; }
            , getPrevIndex = function (y) { return i - y < 0 ? config._imgLen + i - y : i - y; }
            , silde = function (d) {
                $imgs.eq((d ? getPrevIndex(2) : getNextIndex(2))).css('left', (d ? '-1920px' : '1920px'))
                $imgs.animate({
                    'left': (d ? '+' : '-') + '=960px'
                }, config.animateTime);
                i = d ? getPrevIndex(1) : getNextIndex(1);
            }
            , s = setInterval(function () { silde(config.direction); }, config.interval);
            $imgs.eq(i).css('left', 0).end().eq(i + 1).css('left', '960px').end().eq(i - 1).css('left', '-960px');
            $container.find('.hero-wrap').add($leftBtn).add($rightBtn).hover(function () { clearInterval(s); }, function () { s = setInterval(function () { silde(config.direction); }, config.interval); });
            $leftBtn.click(function () {
                if ($(':animated').length === 0) {
                    silde(false);
                }
            });
            $rightBtn.click(function () {
                if ($(':animated').length === 0) {
                    silde(true);
                }
            });
        }
    });
}(jQuery));

$.foucs({ direction: 'right' });
$.foucs1({ direction: 'right' });

