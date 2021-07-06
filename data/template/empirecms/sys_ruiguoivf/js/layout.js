function nTabs(thisObj,Num){
    if(thisObj.className == "active")return;
    var tabObj = thisObj.parentNode.id;
    var tabList = document.getElementById(tabObj).getElementsByTagName("li");
    for(i=0; i <tabList.length; i++)
    {
        if (i == Num)
        {
            thisObj.className = "active";
            document.getElementById(tabObj+"_Content"+i).className = "active";
        }else{
            tabList[i].className = "normal";
            document.getElementById(tabObj+"_Content"+i).className = "none";
        }
    }
}
$(function(){
    var menuEn=['HOME','BABY','hospital','Case','cost','NEWS','project','about'];
    $('.headBox .menu>li').each(function(i){
        $(this).find('i').html(menuEn[i])
    });
    $('.headBox .menu>li').hover(function(i){
        $(this).addClass('cur');
        $(this).find('ul').show()
    },function(){
        $(this).removeClass('cur');
        $(this).find('ul').hide()
    });

    //==============固定顶部菜单
    var fixedHeader = $(".head_w");
    function header_class(){
        //判断滚动
        var $scrollTop=$(window).scrollTop();
        var docScrollTop=document.documentElement.scrollTop;
        var scrollTop=null;
        if($scrollTop){
            scrollTop=$scrollTop;
        }else{
            scrollTop=docScrollTop;
        }
        //动态加载过渡效果
        if(scrollTop>63){
            fixedHeader.addClass('fixed_head');
            fixedHeader.css({'position':'fixed','top':0,'z-index':999,'background':'#fff'});
        }else{
            fixedHeader.removeClass('fixed_head');
            fixedHeader.css({'position':'static'});
        }
    }
    //header_class();
    $(window).scroll( function (){
        //浏览器向下滚动

    });


    // 手机导航显示隐藏
    var onoff = true;
    $(".menu_open").click(function(){
        if(onoff){
            $(this).addClass('menu_open_show');
            $(".menu_wap").addClass('menu_wap_show');
            $("body").addClass('overflow_hidden');
            onoff = false;
        }else{
            $(this).removeClass('menu_open_show');
            $(".menu_wap").removeClass('menu_wap_show');
            $("body").removeClass('overflow_hidden');
            onoff = true;
        }
    });

    // 手机导航展开子类
    $(".menu_wap .menu_list>li>a").click(function(evt){
        if($(this).parent().find('ul').length!=0){
            evt.preventDefault();
        }

        $(this).parent('li').toggleClass("li_on").siblings('li').removeClass('li_on');
        $(this).siblings('.tow_ul').stop().slideToggle(400).parent('li').siblings('li').find('.tow_ul').stop().slideUp(400);

    });


    // 返回头部
    $(window).scroll(function(){
        var scr_top = $(this).scrollTop();
        if(scr_top >800){
            $(".return_top").fadeIn(300);
        }else{
            $(".return_top").fadeOut(300);
        }
    });
    $(".return_top").click(function(){
        $("html,body").stop().animate({scrollTop:0},600);
    });


// ============   flash ============
    if($('.ProcessImg')){
        (function(){
            var getFlashVersion = function() {
                try {
                    if(typeof window.ActiveXObject != 'undefined') {
                        console.log(1)
                        $('.ProcessBox video').css('display','none');
                        return parseInt((new ActiveXObject('ShockwaveFlash.ShockwaveFlash')).GetVariable("$version").split(" ")[1].split(",")[0], 10);
                    }else{
                        console.log(2)
                        $('.ProcessBox video').css('display','none');
                        return parseInt(navigator.plugins["Shockwave Flash"].description.split(' ')[2], 10);
                    }
                } catch(e){
                    $('.ProcessBox embed').css('display','none');
                    $('.ProcessBox video').css({'display':'block','opacity':'.6'});
                    $('.ProcessBox #ProcessImg').css('opacity','1');
                    console.log(0)
                    return 0;
                }
            };
            console.log(getFlashVersion());
        })();

        $('#ProcessMap area').each(function(i,v){
            $(this).hover(
                function () {
                    ProcessTxt_fn(
                        'block',
                        $(this).attr('alt'),
                        $(this).attr('coords').split(",")[0],
                        $(this).attr('coords').split(",")[1]

                    ) ;
                },function (){
                    ProcessTxt_fn('none','','');
                }
            );
        })
        function ProcessTxt_fn(showHid,con,LX,LY){
            var oTop = document.getElementById("ProcessTxt");
            var ProcessImg = document.getElementById("ProcessImg");
            oTop.style.display=showHid;
            oTop.innerText=con;
            document.onmousemove = function(event) {
                var oEvent = event || window.event;
                var scrollleft = document.documentElement.scrollLeft || document.body.scrollLeft;
                var scrolltop = document.documentElement.scrollTop || document.body.scrollTop;
                var x=oEvent.clientX  + 10;
                var y=oEvent.clientY  + 10;

                var new_LX=parseInt(LX);
                var new_LY=parseInt(LY);

                if(new_LX+10+oTop.offsetWidth>ProcessImg.offsetWidth){
                    new_LX=new_LX-10-oTop.offsetWidth
                }
                if(new_LY+oTop.offsetHeight>ProcessImg.offsetHeight){
                    new_LY=new_LX-20-oTop.offsetHeight

                }

                oTop.style.left =new_LX+10+ "px";
                oTop.style.top = new_LY+10+ "px";
            }
        }

    }
    // ============   flash end ============


    $('.footer_wx').hover(function(i){
        $('#footer_wx_img').show();
    },function(){
        $('#footer_wx_img').hide();
    });


    //浏览器发生变化时候
    $(window).resize(function () {
        // location.reload(true);

    });


});


//if(screen.width < 790 || $(window).width() < 790 ){ }






