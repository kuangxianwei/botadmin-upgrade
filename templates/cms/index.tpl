<div id="LAY_app">
    <div class="layui-layout layui-layout-admin">
        <!-- 头部区域 -->
        <div class="layui-header">
            <ul class="layui-nav layui-layout-left">
                <li class="layui-nav-item layadmin-flexible" lay-unselect>
                    <a href="javascript:" layadmin-event="flexible" title="侧边伸缩">
                        <i class="layui-icon layui-icon-shrink-right" id="LAY_app_flexible"></i>
                    </a>
                </li>
                <li class="layui-nav-item layui-hide-xs" lay-unselect>
                    <a href="/" target="_blank" title="前台">
                        <i class="layui-icon layui-icon-website"></i>
                    </a>
                </li>
                <li class="layui-nav-item" lay-unselect>
                    <a href="javascript:" layadmin-event="refresh" title="刷新">
                        <i class="layui-icon layui-icon-refresh-3"></i>
                    </a>
                </li>
                <li class="layui-nav-item layui-hide-xs" lay-unselect>
                    <input type="search" name="search" autocomplete="off" placeholder="搜索..." class="layui-input layui-input-search"
                           layadmin-event="search" lay-action="template/search.html?keywords=">
                </li>
            </ul>
        </div>
        <!-- 侧边菜单 -->
        <div class="layui-side layui-side-menu">
            <div class="layui-side-scroll">
                <div class="layui-logo">
                    <span>{{.obj.Vhost}}</span>
                </div>
                <ul class="layui-nav layui-nav-tree" lay-shrink="all" id="LAY-system-side-menu"
                    lay-filter="layadmin-system-side-menu">
                    <li data-name="article" class="layui-nav-item layui-nav-itemed">
                        <a href="javascript:" lay-tips="文章" lay-direction="2">
                            <i class="layui-icon layui-icon-list"></i>
                            <cite>文章</cite>
                        </a>
                        <dl class="layui-nav-child">
                            <dd data-name="set-config">
                                <a lay-href="/cms/article?id={{.obj.Id}}" lay-tips="文章列表" lay-direction="2">
                                    <i class="layui-icon layui-icon-list"></i>
                                    <cite>文章列表</cite>
                                </a>
                            </dd>
                        </dl>
                    </li>
                    <li data-name="tag" class="layui-nav-item">
                        <a href="javascript:" lay-tips="tag" lay-direction="2">
                            <i class="layui-icon iconfont icon-tags"></i>
                            <cite>TAG</cite>
                        </a>
                        <dl class="layui-nav-child">
                            <dd data-name="set-config">
                                <a lay-href="/cms/tag?id={{.obj.Id}}" lay-tips="TAG列表" lay-direction="2">
                                    <i class="layui-icon layui-icon-list"></i>
                                    <cite>TAG列表</cite>
                                </a>
                            </dd>
                        </dl>
                    </li>
                </ul>
            </div>
        </div>
        <!-- 页面标签 -->
        <div class="layadmin-pagetabs" id="LAY_app_tabs">
            <div class="layui-icon layadmin-tabs-control layui-icon-prev" layadmin-event="leftPage"></div>
            <div class="layui-icon layadmin-tabs-control layui-icon-next" layadmin-event="rightPage"></div>
            <div class="layui-icon layadmin-tabs-control layui-icon-down">
                <ul class="layui-nav layadmin-tabs-select" lay-filter="layadmin-pagetabs-nav">
                    <li class="layui-nav-item" lay-unselect>
                        <a href="javascript:"></a>
                        <dl class="layui-nav-child layui-anim-fadein">
                            <dd layadmin-event="closeThisTabs"><a href="javascript:">关闭当前标签页</a></dd>
                            <dd layadmin-event="closeOtherTabs"><a href="javascript:">关闭其它标签页</a></dd>
                            <dd layadmin-event="closeAllTabs"><a href="javascript:">关闭全部标签页</a></dd>
                        </dl>
                    </li>
                </ul>
            </div>
            <div class="layui-tab" lay-unauto lay-allowClose="true" lay-filter="layadmin-layout-tabs">
                <ul class="layui-tab-title" id="LAY_app_tabsheader">
                    <li lay-id="/" lay-attr="/" class="layui-this">
                        <i class="layui-icon layui-icon-home"></i>
                    </li>
                </ul>
            </div>
        </div>
        <!-- 主体内容 -->
        <div class="layui-body" id="LAY_app_body">
            <div class="layadmin-tabsbody-item layui-show" style="overflow: hidden">
                <iframe src="/cms/home?id={{.obj.Id}}" class="layadmin-iframe"></iframe>
            </div>
        </div>
        <!-- 辅助元素，一般用于移动设备下遮罩 -->
        <div class="layadmin-body-shade" layadmin-event="shade"></div>
    </div>
</div>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let active = {
            webssh: function () {
                layui.main.webssh();
            },
            logout: function () {
                layui.main.logout();
            },
            log: function () {
                $(this).find('span.layui-badge-dot').hide();
                layui.main.ws.log('record.global');
            }
        };
        $('[data-event]').off('click').on('click', function () {
            let $this = $(this), event = $this.data("event");
            active[event] && active[event].call($this);
        });
    });
</script>