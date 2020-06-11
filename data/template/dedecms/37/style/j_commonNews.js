/**
* name: none
* author: zjf    qq:383975892
* effect: 通用滑动门切换效果 [ base on jQuery ]
* date: 2013-1-23
* use: 在标签上添加属性“data-tabs”，不用任何其它设置即可完成效果
        形如：<ul id="tabs" data-tabs="#tabs li,#content>div,tabsActive,consActive"><li>滑动1</li><li>滑动1</li></ul>
              <div id="content">
                    <div>show1</div>
                    <div>show2</div>
              </div>
        data-tabs说明：以逗号分隔的5个字符串参数
            第一个参数：jQuery选取 tabs每子元素 的选择器表达式
            第二个参数：jQuery选取 content每子元素 的选择器表达式
            第三个参数：tabs上当前激活子元素的css_className
            第四个参数：content上当前显示的子元素的css_className
                            如果传入空字符串值''或'toggleDisplay'，则默认为简单切换各content子元素的显隐，
                            如果传入其它字符串值，则鼠标移上对应的当前项content子元素 应用此样式，其它子元素项移除此样式。[此时要想实现显隐请在此参数代表的css_class中设定display]
            第五个参数[可选]：初始时激活第几项，不传入默认为1
                简单使用示例 （三个参数）：<ul data-tabs=".tabsEach,.contentEach,tabsActive"><ul>
                            （四个参数）：<ul data-tabs=".tabsEach,.contentEach,tabsActive,my_consActive_class"><ul>
                                         <ul data-tabs=".tabsEach,.contentEach,tabsActive,toggleDisplay"><ul>
                            （五个参数）：<ul data-tabs=".tabsEach,.contentEach,tabsActive,,2"><ul>
                                         <ul data-tabs=".tabsEach,.contentEach,tabsActive,my_consActive_class,2"><ul>
        on-what说明:此方法默认按mouseover方式切换，如果想改成click方式，请再将标签上多添加属性"on-what"，属性值可设为'click'或'mouseover'
            形如：<ul data-tabs=".tabsEach,.contentEach,tabsActive" on-what="click"><ul>

* notify: 此方法未做容错处理（比如可能情况之一：只传入了一个参数）
* */
(function(j){
    j(function(){
        j('[data-tabs]').each(function(){
            var sArr=j(this).attr('data-tabs').split(',');for(var s=0,l=sArr.length;s<l;s++){sArr[s]=j.trim(sArr[s]);}
            var arg4=sArr[3]?sArr[3]:'toggleDisplay',flag=sArr[4]?sArr[4]-1:0,eventType=j(this).attr('on-what')?j(this).attr('on-what'):'mouseover';
            j(sArr[0]).each(function(ii){
                if(ii==flag){
                    j(sArr[0]).removeClass(sArr[2]).eq(ii).addClass(sArr[2]);
                    arg4=='toggleDisplay'?j(sArr[1]).hide().eq(ii).show():j(sArr[1]).removeClass(arg4).eq(ii).addClass(arg4);
                }
            }).bind(eventType,function(){
                var i=j(sArr[0]).index(this); j(sArr[0]).removeClass(sArr[2]).eq(i).addClass(sArr[2]);
                arg4=='toggleDisplay'?j(sArr[1]).hide().eq(i).show():j(sArr[1]).removeClass(arg4).eq(i).addClass(arg4);
                return false;
            });
        });
    });
})(jQuery);
