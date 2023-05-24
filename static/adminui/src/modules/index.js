/**
 * 界面入口模块  
 */
 
layui.define('admin', function(exports){
  var setter = layui.setter;
  var element = layui.element;
  var admin = layui.admin;
  var tabsPage = admin.tabsPage;
  var view = layui.view;
  
  //打开标签页
  var openTabsPage = function(url, text){
    //遍历页签选项卡
    var matchTo
    ,tabs = $('#LAY_app_tabsheader>li')
    ,path = url.replace(/(^http(s*):)|(\?[\s\S]*$)/g, '');
    
    tabs.each(function(index){
      var li = $(this)
      ,layid = li.attr('lay-id');
      
      if(layid === url){
        matchTo = true;
        tabsPage.index = index;
      }
    });
    text = text || '新标签页';
    
    //定位当前tabs
    var setThisTab = function(){
      element.tabChange(FILTER_TAB_TBAS, url);
      admin.tabsBodyChange(tabsPage.index, {
        url: url
        ,text: text
      });
    };
    
    if(setter.pageTabs){
      //如果未在选项卡中匹配到，则追加选项卡
      if(!matchTo){
        //延迟修复 Firefox 空白问题
        setTimeout(function(){
          $(APP_BODY).append([
            '<div class="layadmin-tabsbody-item layui-show">'
              ,'<iframe src="'+ url +'" frameborder="0" class="layadmin-iframe"></iframe>'
            ,'</div>'
          ].join(''));
          setThisTab();
        }, 10);
        
        tabsPage.index = tabs.length;
        element.tabAdd(FILTER_TAB_TBAS, {
          title: '<span>'+ text +'</span>'
          ,id: url
          ,attr: path
        });
        
      }
    } else {
      var iframe = admin.tabsBody(admin.tabsPage.index).find('.layadmin-iframe');
      iframe[0].contentWindow.location.href = url;
    }
    
    setThisTab();
  };
  
  var APP_BODY = '#LAY_app_body';
  var FILTER_TAB_TBAS = 'layadmin-layout-tabs';
  var $ = layui.$;
  var $win = $(window);
  
  //初始
  if(admin.screen() < 2) admin.sideFlexible();
  
  view().autoRender();

  // 对外输出
  var adminuiIndex = {
    openTabsPage: openTabsPage
  };

  $.extend(admin, adminuiIndex);
  exports('adminIndex', adminuiIndex);
});
