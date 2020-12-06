<div id="LAY_app">
    <div class="layui-layout layui-layout-admin">
        <div class="layui-header">
            <!-- 头部区域 -->
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
                    <input type="text" placeholder="搜索..." autocomplete="off" class="layui-input layui-input-search"
                           layadmin-event="serach" lay-action="template/search.html?keywords=">
                </li>
                <li class="layui-nav-item" lay-unselect>
                    {{.auth.Message}}
                </li>
            </ul>
            <ul class="layui-nav layui-layout-right" lay-filter="layadmin-layout-right">
                <li class="layui-nav-item" lay-unselect>
                    <a lay-href="" layadmin-event="message" lay-text="消息中心">
                        <i class="layui-icon layui-icon-notice"></i>
                        <!-- 如果有新消息，则显示小圆点 -->
                        <span class="layui-badge-dot"></span>
                    </a>
                </li>
                <li class="layui-nav-item layui-hide-xs" lay-unselect>
                    <a href="javascript:" layadmin-event="theme">
                        <i class="layui-icon layui-icon-theme"></i>
                    </a>
                </li>
                <li class="layui-nav-item layui-hide-xs" lay-unselect>
                    <a href="javascript:" layadmin-event="note">
                        <i class="layui-icon layui-icon-note"></i>
                    </a>
                </li>
                <li class="layui-nav-item layui-hide-xs" lay-unselect>
                    <a href="javascript:" layadmin-event="fullscreen">
                        <i class="layui-icon layui-icon-screen-full"></i>
                    </a>
                </li>
                <!-- 这里是登录后 -->
                <li class="layui-nav-item" lay-unselect>
                    <a href="javascript:">
                        <cite>{{.username}}</cite>
                    </a>
                    <dl class="layui-nav-child">
                        <dd><a lay-href="/auth">登录日志</a></dd>
                        <dd><a lay-href="/safe/login">登录设置</a></dd>
                        <hr>
                        <dd data-event="logout" style="text-align: center;"><a>退出</a></dd>
                    </dl>
                </li>
                <li class="layui-nav-item layui-hide-xs" lay-unselect>
                    <a href="javascript:" layadmin-event="about"><i
                                class="layui-icon layui-icon-more-vertical"></i></a>
                </li>
                <li class="layui-nav-item layui-show-xs-inline-block layui-hide-sm" lay-unselect>
                    <a href="javascript:" layadmin-event="more"><i class="layui-icon layui-icon-more-vertical"></i></a>
                </li>
            </ul>
        </div>
        <!-- 侧边菜单 -->
        <div class="layui-side layui-side-menu">
            <div class="layui-side-scroll">
                <div class="layui-logo" lay-href="/">
                    <span>BotAdmin</span>
                </div>
                <ul class="layui-nav layui-nav-tree" lay-shrink="all" id="LAY-system-side-menu"
                    lay-filter="layadmin-system-side-menu">
                    <li data-name="sys" class="layui-nav-item layui-nav-itemed">
                        <a href="javascript:" lay-tips="默认设置" lay-direction="2">
                            <i class="layui-icon layui-icon-set"></i>
                            <cite>默认设置</cite>
                        </a>
                        <dl class="layui-nav-child">
                            <dd data-name="set-config">
                                <a lay-href="/config" lay-tips="系统设置"
                                   lay-direction="2">系统设置</a>
                            </dd>
                            <dd data-name="set-site">
                                <a lay-href="/config/site" lay-tips="网站设置"
                                   lay-direction="2">网站设置</a>
                            </dd>
                            <dd data-name="set-data">
                                <a lay-href="/config/sitedata" lay-tips="资料设置" lay-direction="2">
                                    <cite>资料设置</cite>
                                </a>
                            </dd>
                            <dd data-name="set-email">
                                <a lay-href="/email" lay-tips="邮箱设置" lay-direction="2">
                                    <i class="layui-icon layui-icon-email"></i>
                                    <cite>邮箱设置</cite>
                                </a>
                            </dd>
                            <dd data-name="safe" class="layui-nav-item">
                                <a href="javascript:" lay-tips="联系方式" lay-direction="2">
                                    <i class="layui-icon layui-icon-about"></i>
                                    <cite>联系方式</cite>
                                </a>
                                <dl class="layui-nav-child">
                                    <dd data-name="contact-list">
                                        <a lay-href="/contact" lay-tips="联系列表" lay-direction="2">联系列表</a>
                                    </dd>
                                    <dd data-name="contact-config">
                                        <a lay-href="/contact/config" lay-tips="基本配置" lay-direction="2">基本配置</a>
                                    </dd>
                                </dl>
                            </dd>
                        </dl>
                    </li>
                    <li data-name="site" class="layui-nav-item">
                        <a href="javascript:" lay-tips="网站管理" lay-direction="2">
                            <i class="layui-icon iconfont icon-website"></i>
                            <cite>网站管理</cite>
                        </a>
                        <dl class="layui-nav-child">
                            <dd data-name="site-show">
                                <a lay-href="/site" lay-tips="网站列表"
                                   lay-direction="2">网站列表</a>
                            </dd>
                            <dd data-name="site-baidu">
                                <a lay-href="/file?path={{.rankDir}}" lay-tips="下载关键词"
                                   lay-direction="2">下载关键词</a>
                            </dd>
                            <dd data-name="site-rank">
                                <a lay-href="/rank" lay-tips="关键词排名"
                                   lay-direction="2">关键词排名</a>
                            </dd>
                            <dd data-name="modify-hosts">
                                <a lay-href="/file/editor?path=/etc/hosts" lay-tips="修改Hosts"
                                   lay-direction="2">Hosts</a>
                            </dd>
                        </dl>
                    </li>
                    <li data-name="sql" class="layui-nav-item">
                        <a href="javascript:" lay-tips="MYSQL管理" lay-direction="2">
                            <i class="layui-icon iconfont icon-sql"></i>
                            <cite>MYSQL管理</cite>
                        </a>
                        <dl class="layui-nav-child">
                            <dd data-name="sql-show">
                                <a lay-href="/sql" lay-tips="MYSQL列表"
                                   lay-direction="2">MYSQL列表</a>
                            </dd>
                            <dd data-name="sql-seter">
                                <a lay-href="/sql/configure" lay-tips="MySQL设置"
                                   lay-direction="2">MySQL设置</a>
                            </dd>
                            <dd data-name="sql-phpMyAdmin">
                                <a href="{{.phpmyadmin}}" lay-tips="使用 phpmyadmin 管理"
                                   lay-direction="2" target="_blank">PhpMyAdmin</a>
                            </dd>
                        </dl>
                    </li>
                    <li data-name="ftp" class="layui-nav-item">
                        <a href="javascript:" lay-tips="FTP管理" lay-direction="2">
                            <i class="layui-icon iconfont icon-ftp"></i>
                            <cite>FTP管理</cite>
                        </a>
                        <dl class="layui-nav-child">
                            <dd data-name="ftp-show">
                                <a lay-href="/ftp" lay-tips="FTP列表"
                                   lay-direction="2">FTP列表</a>
                            </dd>
                        </dl>
                    </li>
                    <li data-name="spider" class="layui-nav-item">
                        <a href="javascript:" lay-tips="网站采集" lay-direction="2">
                            <i class="layui-icon iconfont icon-spider"></i>
                            <cite>网站采集</cite>
                        </a>
                        <dl class="layui-nav-child">
                            <dd data-name="site-default">
                                <a lay-href="/spider" lay-tips="规则列表"
                                   lay-direction="2">规则列表</a>
                            </dd>
                            <dd data-name="site-data">
                                <a lay-href="/data" lay-tips="文章列表"
                                   lay-direction="2">文章列表</a>
                            </dd>
                            <dd data-name="translate">
                                <a href="javascript:">翻译配置</a>
                                <dl class="layui-nav-child">
                                    <dd><a lay-href="/trans/baidu">百度翻译</a></dd>
                                    <dd><a lay-href="/trans/tencent">腾讯翻译</a></dd>
                                    <dd><a lay-href="/trans/google">谷歌翻译</a></dd>
                                    <dd><a lay-href="/trans/youdao">有道翻译</a></dd>
                                </dl>
                            </dd>
                        </dl>
                    </li>
                    <li data-name="tools" class="layui-nav-item">
                        <a href="javascript:" lay-tips="常用工具" lay-direction="2">
                            <i class="layui-icon layui-icon-util"></i>
                            <cite>常用工具</cite>
                        </a>
                        <dl class="layui-nav-child">
                            <dd data-name="tools-ban">
                                <a lay-href="/tools/ban" lay-tips="过滤违禁词"
                                   lay-direction="2">过滤违禁词</a>
                            </dd>
                            <dd data-name="monitor">
                                <a lay-href="/monitor" lay-tips="网站监控"
                                   lay-direction="2">网站监控</a>
                            </dd>
                        </dl>
                    </li>
                    <li data-name="file" class="layui-nav-item">
                        <a href="javascript:" lay-tips="文件管理" lay-direction="2">
                            <i class="layui-icon iconfont icon-manager"></i>
                            <cite>文件管理</cite>
                        </a>
                        <dl class="layui-nav-child">
                            <dd data-name="file">
                                <a lay-href="/file" lay-tips="文件管理"
                                   lay-direction="2">文件管理</a>
                            </dd>
                            <dd data-name="file-template">
                                <a lay-href="/file?path=data/template" lay-tips="上传或者修改模板"
                                   lay-direction="2">模板目录</a>
                            </dd>
                            <dd data-name="file-pic">
                                <a lay-href="/file?path=data/pic" lay-tips="上传或者修改图片"
                                   lay-direction="2">图片目录</a>
                            </dd>
                            <dd data-name="file-logs">
                                <a lay-href="/file?path=logs" lay-tips="本程序日志目录"
                                   lay-direction="2">程序日志</a>
                            </dd>
                            <dd data-name="file-sys-log">
                                <a lay-href="/file?path=/var/log" lay-tips="系统日志目录"
                                   lay-direction="2">系统日志</a>
                            </dd>
                        </dl>
                    </li>
                    <li data-name="system" class="layui-nav-item">
                        <a href="javascript:" lay-tips="系统管理" lay-direction="2">
                            <i class="layui-icon iconfont icon-system"></i>
                            <cite>系统管理</cite>
                        </a>
                        <dl class="layui-nav-child">
                            <dd data-name="system-service">
                                <a lay-href="/system/service" lay-tips="启动服务" lay-direction="2">启动服务</a>
                            </dd>
                            <dd data-name="system-Port">
                                <a lay-href="/system/port" lay-tips="端口管理"
                                   lay-direction="2">端口管理</a>
                            </dd>
                            <dd data-name="system-process">
                                <a lay-href="/system/process" lay-tips="进程管理" lay-direction="2">进程管理</a>
                            </dd>
                            <dd data-name="system-ifconfig">
                                <a lay-href="/system/ifconfig" lay-tips="IP设置" lay-direction="2">IP设置</a>
                            </dd>
                            <dd data-name="system-resolv">
                                <a lay-href="/system/resolv" lay-tips="设置DNS" lay-direction="2">设置DNS</a>
                            </dd>
                            <dd data-name="system-cmd">
                                <a lay-href="/system/cmd" lay-tips="运行命令"
                                   lay-direction="2">运行命令</a>
                            </dd>
                            <dd data-name="system-reservice">
                                <a lay-href="/system/reservice" lay-tips="服务重启" lay-direction="2">服务重启</a>
                            </dd>
                            <dd data-name="system-time">
                                <a lay-href="/system/time" lay-tips="时间设置"
                                   lay-direction="2">时间设置</a>
                            </dd>
                        </dl>
                    </li>
                    <li data-name="resource" class="layui-nav-item">
                        <a href="javascript:" lay-tips="资源管理" lay-direction="2">
                            <i class="layui-icon iconfont icon-resource"></i>
                            <cite>资源管理</cite>
                        </a>
                        <dl class="layui-nav-child">
                            <dd data-name="resource-disk">
                                <a lay-href="/resource/disk" lay-tips="磁盘使用率" lay-direction="2">磁盘使用率</a>
                            </dd>
                            <dd data-name="resource-eth">
                                <a lay-href="/resource/eth" lay-tips="网卡流量"
                                   lay-direction="2">网卡流量</a>
                            </dd>
                            <dd data-name="resource-mem">
                                <a lay-href="/resource/mem" lay-tips="内存管理"
                                   lay-direction="2">内存管理</a>
                            </dd>
                        </dl>
                    </li>
                    <li data-name="safe" class="layui-nav-item">
                        <a href="javascript:" lay-tips="安全设置" lay-direction="2">
                            <i class="layui-icon iconfont icon-safe"></i>
                            <cite>安全设置</cite>
                        </a>
                        <dl class="layui-nav-child">
                            <dd data-name="safe-login">
                                <a lay-href="/safe/login" lay-tips="登录设置"
                                   lay-direction="2">登录设置</a>
                            </dd>
                            <dd data-name="safe-firewall">
                                <a lay-href="/safe/firewall" lay-tips="防火墙设置" lay-direction="2">防火墙设置</a>
                            </dd>
                            <dd data-name="safe-ssh">
                                <a lay-href="/safe/ssh" lay-tips="SSH管理"
                                   lay-direction="2">SSH管理</a>
                            </dd>
                            <dd data-name="safe-ping">
                                <a lay-href="/safe/ping" lay-tips="PING管理" lay-direction="2">PING管理</a>
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
            <div class="layadmin-tabsbody-item layui-show">
                <iframe src="/home" frameborder="0" class="layadmin-iframe"></iframe>
            </div>
        </div>
        <!-- 辅助元素，一般用于移动设备下遮罩 -->
        <div class="layadmin-body-shade" layadmin-event="shade"></div>
    </div>
</div>
<script src="/static/layui/layui.js"></script>
<script>
    layui.config({
        base: '/static/' //静态资源所在路径
    }).extend({
        index: 'lib/index' //主入口模块
    }).use(['index'], function () {
        layui.$('dd[data-event=logout]').click(function () {
            layui.view.exit(function () {
                location.href = '/auth/logout';
            });
        });
    });
</script>