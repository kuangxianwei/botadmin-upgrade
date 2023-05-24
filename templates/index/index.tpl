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
                    <input type="text" name="search" autocomplete="off" placeholder="搜索..." class="layui-input layui-input-search"
                           layadmin-event="search" lay-action="template/search.html?keywords=">
                </li>
                <li class="layui-nav-item" lay-unselect>
                    {{.auth.Msg}}
                </li>
            </ul>
            <ul class="layui-nav layui-layout-right" lay-filter="layadmin-layout-right">
                <li class="layui-nav-item" lay-unselect>
                    <a data-event="log" lay-text="全局日志">
                        <i class="layui-icon layui-icon-log"></i>
                        {{if .changed -}}
                            <span class="layui-badge-dot"></span>
                        {{end -}}
                    </a>
                </li>
                <li class="layui-nav-item" lay-unselect>
                    <a lay-href="/record" layadmin-event="message" lay-text="消息中心">
                        <i class="layui-icon layui-icon-notice"></i>
                        {{if .latest -}}
                            <span class="layui-badge-dot"></span>
                        {{end -}}
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
                        <hr/>
                        <dd data-event="logout" style="text-align:center;"><a href="/auth/logout">退出</a></dd>
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
                                <a lay-href="/config" lay-tips="系统设置" lay-direction="2">
                                    <i class="iconfont icon-sys"></i>
                                    <cite>系统</cite>
                                </a>
                            </dd>
                            <dd data-name="set-site">
                                <a lay-href="/config/site" lay-tips="网站设置" lay-direction="2">
                                    <i class="iconfont icon-website-set"></i>
                                    <cite>网站</cite>
                                </a>
                            </dd>
                            <dd data-name="set-data">
                                <a lay-href="/config/site/data" lay-tips="资料设置" lay-direction="2">
                                    <i class="iconfont icon-data"></i>
                                    <cite>资料</cite>
                                </a>
                            </dd>
                            <dd data-name="collect-tags">
                                <a lay-href="/tags" lay-tips="管理tags" lay-direction="2">
                                    <i class="iconfont icon-tags-seo"></i>
                                    <cite>Tags</cite>
                                </a>
                            </dd>
                            <dd data-name="set-email">
                                <a lay-href="/email" lay-tips="邮箱设置" lay-direction="2">
                                    <i class="iconfont icon-email"></i>
                                    <cite>邮箱</cite>
                                </a>
                            </dd>
                            <dd data-name="about">
                                <a href="javascript:" lay-tips="联系方式" lay-direction="2">
                                    <i class="iconfont icon-about"></i>
                                    <cite>联系</cite>
                                </a>
                                <dl class="layui-nav-child">
                                    <dd data-name="contact-list">
                                        <a lay-href="/contact" lay-tips="联系列表" lay-direction="2">
                                            <i class="iconfont icon-consult"></i>
                                            <cite>联系列表</cite>
                                        </a>
                                    </dd>
                                    <dd data-name="contact-config">
                                        <a lay-href="/contact/config" lay-tips="基本配置" lay-direction="2">
                                            <i class="iconfont icon-host"></i>
                                            <cite>基本配置</cite>
                                        </a>
                                    </dd>
                                    <dd data-name="contact-style">
                                        <a lay-href="/contact/filter" lay-tips="过滤规则列表" lay-direction="2">
                                            <i class="iconfont icon-filter"></i>
                                            <cite>过滤列表</cite>
                                        </a>
                                    </dd>
                                    <dd data-name="contact-style">
                                        <a lay-href="/contact/style" lay-tips="样式列表" lay-direction="2">
                                            <i class="iconfont icon-style-text"></i>
                                            <cite>样式列表</cite>
                                        </a>
                                    </dd>
                                    <dd data-name="trace-list">
                                        <a lay-href="/trace" lay-tips="广告跟踪列表" lay-direction="2">
                                            <i class="iconfont icon-trace"></i>
                                            <cite>跟踪列表</cite>
                                        </a>
                                    </dd>
                                    <dd data-name="feedback-list">
                                        <a lay-href="/feedback" lay-tips="留言反馈列表" lay-direction="2">
                                            <i class="iconfont icon-feedback"></i>
                                            <cite>留言反馈</cite>
                                        </a>
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
                                <a lay-href="/site" lay-tips="网站列表" lay-direction="2">
                                    <i class="iconfont icon-list"></i>
                                    <cite>网站列表</cite>
                                </a>
                            </dd>
                            <dd data-name="seo">
                                <a href="javascript:" lay-tips="SEO设置" lay-direction="2">
                                    <i class="iconfont icon-seo-1"></i>
                                    <cite>SEO</cite>
                                </a>
                                <dl class="layui-nav-child">
                                    <dd data-name="site-baidu">
                                        <a lay-href="/file?path={{.rankDir}}" lay-tips="下载关键词" lay-direction="2">
                                            <i class="iconfont icon-download"></i>
                                            <cite>关键词</cite>
                                        </a>
                                    </dd>
                                    <dd data-name="site-rank">
                                        <a lay-href="/rank" lay-tips="关键词排名" lay-direction="2">
                                            <i class="iconfont icon-sort"></i>
                                            <cite>排名</cite>
                                        </a>
                                    </dd>
                                </dl>
                            </dd>
                            <dd data-name="modify-hosts">
                                <a lay-href="/file/editor?path=/etc/hosts" lay-tips="修改Hosts" lay-direction="2">
                                    <i class="iconfont icon-host"></i>
                                    <cite>Hosts</cite>
                                </a>
                            </dd>
                        </dl>
                    </li>
                    <li data-name="theme" class="layui-nav-item">
                        <a href="javascript:" lay-tips="主题管理" lay-direction="2">
                            <i class="layui-icon iconfont icon-theme"></i>
                            <cite>主题管理</cite>
                        </a>
                        <dl class="layui-nav-child">
                            <dd data-name="local-theme">
                                <a href="javascript:" lay-tips="已下载到本地主题" lay-direction="2">
                                    <i class="iconfont icon-local-shop"></i>
                                    <cite>本地主题</cite>
                                </a>
                                <dl class="layui-nav-child">
                                    {{range $system:=.systems -}}
                                        <dd data-name="site-{{$system.Driver}}">
                                            <a lay-href="/themes?driver={{$system.Driver}}" lay-tips="{{$system.Alias}}" lay-direction="2"><cite>{{$system.Alias}}</cite></a>
                                        </dd>
                                    {{end -}}
                                </dl>
                            </dd>
                            <dd data-name="remote-theme">
                                <a href="javascript:" lay-tips="主题商店" lay-direction="2">
                                    <i class="iconfont icon-shop"></i>
                                    <cite>主题商店</cite>
                                </a>
                                <dl class="layui-nav-child">
                                    {{range $system:=.systems -}}
                                        <dd data-name="site-{{$system.Driver}}">
                                            <a lay-href="/themes/shop?driver={{$system.Driver}}" lay-tips="{{$system.Alias}}"
                                               lay-direction="2"><cite>{{$system.Alias}}</cite></a>
                                        </dd>
                                    {{end -}}
                                </dl>
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
                                <a lay-href="/sql" lay-tips="MYSQL列表" lay-direction="2">
                                    <i class="iconfont icon-list-view"></i>
                                    <cite>MYSQL列表</cite>
                                </a>
                            </dd>
                            <dd data-name="sql-configure">
                                <a lay-href="/sql/configure" lay-tips="MySQL设置" lay-direction="2">
                                    <i class="iconfont icon-setting"></i>
                                    <cite>MySQL设置</cite>
                                </a>
                            </dd>
                            <dd data-name="sql-phpMyAdmin">
                                <a href="{{.phpmyadmin}}" lay-tips="使用 phpmyadmin 管理" lay-direction="2" target="_blank">
                                    <i class="iconfont icon-mysql"></i>
                                    <cite>PhpMyAdmin</cite>
                                </a>
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
                                <a lay-href="/ftp" lay-tips="FTP列表" lay-direction="2">
                                    <i class="iconfont icon-list-view"></i>
                                    <cite>FTP列表</cite>
                                </a>
                            </dd>
                        </dl>
                    </li>
                    <li data-name="spider" class="layui-nav-item">
                        <a href="javascript:" lay-tips="网站采集" lay-direction="2">
                            <i class="layui-icon iconfont icon-spider"></i>
                            <cite>网站采集</cite>
                        </a>
                        <dl class="layui-nav-child">
                            <dd data-name="spider-list">
                                <a lay-href="/spider" lay-tips="规则列表" lay-direction="2">
                                    <i class="iconfont icon-list-view"></i><cite>规则列表</cite>
                                </a>
                            </dd>
                            <dd data-name="site-data">
                                <a lay-href="/data" lay-tips="文章列表" lay-direction="2">
                                    <i class="iconfont icon-list-view"></i>
                                    <cite>文章列表</cite>
                                </a>
                            </dd>
                            <dd data-name="translate">
                                <a href="javascript:">
                                    <i class="iconfont icon-translate"></i>
                                    <cite>翻译配置</cite>
                                </a>
                                <dl class="layui-nav-child">
                                    {{range .trans -}}
                                        <dd><a lay-href="/trans/{{.Name}}">{{.Alias}}</a></dd>
                                    {{end -}}
                                </dl>
                            </dd>
                        </dl>
                    </li>
                    <li data-name="openai" class="layui-nav-item">
                        <a href="javascript:" lay-tips="OpenAI" lay-direction="2">
                            <i class="layui-icon iconfont icon-ai"></i>
                            <cite>OpenAI</cite>
                        </a>
                        <dl class="layui-nav-child">
                            <dd data-name="openai-models">
                                <a lay-href="/openai" lay-tips="OpenAI 模块列表" lay-direction="2">
                                    <i class="iconfont icon-models"></i>
                                    <cite>模块列表</cite>
                                </a>
                            </dd>
                            <dd data-name="openai-token">
                                <a lay-href="/openai/token" lay-tips="OpenAI 秘钥列表" lay-direction="2">
                                    <i class="iconfont icon-secretKey"></i>
                                    <cite>秘钥管理</cite>
                                </a>
                            </dd>
                        </dl>
                    </li>
                    <li data-name="push-ad" class="layui-nav-item">
                        <a href="javascript:" lay-tips="广告推送" lay-direction="2">
                            <i class="layui-icon iconfont icon-ad-big"></i>
                            <cite>广告推送</cite>
                        </a>
                        <dl class="layui-nav-child">
                            <dd data-name="ad">
                                <a href="javascript:" lay-tips="广告推送" lay-direction="2">
                                    <i class="iconfont icon-ad-small"></i>
                                    <cite>广告推送</cite>
                                </a>
                                <dl class="layui-nav-child">
                                    <dd data-name="ad-push">
                                        <a lay-href="/ad/push" lay-tips="推送规则列表" lay-direction="2">
                                            <i class="iconfont icon-list-view"></i>
                                            <cite>推送</cite>
                                        </a>
                                    </dd>
                                    <dd data-name="ad-result">
                                        <a lay-href="/ad/result" lay-tips="推送结果列表" lay-direction="2">
                                            <i class="iconfont icon-list-view"></i>
                                            <cite>推送结果</cite>
                                        </a>
                                    </dd>
                                    <dd data-name="ad-configure">
                                        <a lay-href="/ad/configure" lay-tips="推送配置" lay-direction="2">
                                            <i class="iconfont icon-list-view"></i>
                                            <cite>推送配置</cite>
                                        </a>
                                    </dd>
                                </dl>
                            </dd>
                        </dl>
                        <dl class="layui-nav-child">
                            <dd data-name="statistic">
                                <a href="javascript:" lay-tips="统计广告推送" lay-direction="2">
                                    <i class="iconfont icon-statistic"></i>
                                    <cite>统计广告</cite>
                                </a>
                                <dl class="layui-nav-child">
                                    <dd data-name="statistic-push">
                                        <a lay-href="/statistic/push" lay-tips="广告推送列表" lay-direction="2">
                                            <i class="iconfont icon-list-view"></i>
                                            <cite>推送列表</cite>
                                        </a>
                                    </dd>
                                    <dd data-name="statistic">
                                        <a lay-href="/statistic" lay-tips="统计广告列表" lay-direction="2">
                                            <i class="iconfont icon-list-view"></i>
                                            <cite>数据列表</cite>
                                        </a>
                                    </dd>
                                    <dd data-name="statistic-collect">
                                        <a lay-href="/statistic/collect" lay-tips="采集统计广告数据" lay-direction="2">
                                            <cite>采集数据</cite>
                                        </a>
                                    </dd>
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
                            <dd data-name="set-plugin">
                                <a lay-href="/plugin" lay-tips="插件管理" lay-direction="2">
                                    <i class="iconfont icon-plugin"></i>
                                    <cite>插件</cite>
                                </a>
                            </dd>
                            <dd data-name="webssh">
                                <a lay-href="/webssh" lay-tips="ssh管理" lay-direction="2">
                                    <i class="iconfont icon-ssh"></i>
                                    <cite>SSH</cite>
                                </a>
                            </dd>
                            <dd data-name="tools-ban">
                                <a lay-href="/tools/ban" lay-tips="过滤违禁词" lay-direction="2">
                                    <i class="iconfont icon-filter"></i>
                                    <cite>禁词</cite>
                                </a>
                            </dd>
                            <dd data-name="tools-rsa">
                                <a lay-href="/tools/rsa" lay-tips="生成RSA" lay-direction="2">
                                    <i class="iconfont icon-rsa"></i>
                                    <cite>RSA</cite>
                                </a>
                            </dd>
                            <dd data-name="tools-segment">
                                <a lay-href="/tools/segment" lay-tips="分词" lay-direction="2">
                                    <i class="iconfont icon-segment"></i>
                                    <cite>分词</cite>
                                </a>
                            </dd>
                            <dd data-name="monitor">
                                <a lay-href="/monitor" lay-tips="网站监控" lay-direction="2">
                                    <i class="iconfont icon-monitor"></i>
                                    <cite>监控</cite>
                                </a>
                            </dd>
                        </dl>
                    </li>
                    <li data-name="file" class="layui-nav-item">
                        <a href="javascript:" lay-tips="文件管理" lay-direction="2">
                            <i class="layui-icon iconfont icon-manager"></i>
                            <cite>文件管理</cite>
                        </a>
                        <dl class="layui-nav-child">
                            <dd data-name="file-list">
                                <a lay-href="/file" lay-tips="文件管理" lay-direction="2">
                                    <i class="iconfont icon-folder"></i>
                                    <cite>文件管理</cite>
                                </a>
                            </dd>
                            <dd data-name="file-pic">
                                <a lay-href="/file?path=data/pic" lay-tips="上传或者修改图片" lay-direction="2">
                                    <i class="iconfont icon-image"></i>
                                    <cite>图片目录</cite>
                                </a>
                            </dd>
                            <dd data-name="file-ssl">
                                <a lay-href="/file?path=/usr/local/nginx/conf/ssl" lay-tips="管理SSL配置文件" lay-direction="2">
                                    <cite>SSL配置文件</cite>
                                </a>
                            </dd>
                            <dd data-name="file-logs">
                                <a lay-href="/file?path=logs" lay-tips="本程序日志目录" lay-direction="2">
                                    <i class="iconfont icon-log-check"></i>
                                    <cite>程序日志</cite>
                                </a>
                            </dd>
                            <dd data-name="file-sys-log">
                                <a lay-href="/file?path=/var/log" lay-tips="系统日志目录" lay-direction="2">
                                    <i class="iconfont icon-log"></i>
                                    <cite>系统日志</cite>
                                </a>
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
                                <a lay-href="/system/service" lay-tips="启动服务" lay-direction="2">
                                    <i class="iconfont icon-reboot"></i>
                                    <cite>启动服务</cite>
                                </a>
                            </dd>
                            <dd data-name="system-Port">
                                <a lay-href="/system/port" lay-tips="端口管理" lay-direction="2">
                                    <i class="iconfont icon-port"></i>
                                    <cite>端口管理</cite>
                                </a>
                            </dd>
                            <dd data-name="system-process">
                                <a lay-href="/system/process" lay-tips="进程管理" lay-direction="2">
                                    <i class="iconfont icon-process-task"></i>
                                    <cite>进程管理</cite>
                                </a>
                            </dd>
                            <dd data-name="system-reboot">
                                <a lay-href="/system/reboot" lay-tips="服务重启" lay-direction="2">
                                    <i class="iconfont icon-reboot"></i>
                                    <cite>服务重启</cite>
                                </a>
                            </dd>
                            <dd data-name="system-time">
                                <a lay-href="/system/time" lay-tips="时间设置"
                                   lay-direction="2">
                                    <i class="iconfont icon-time"></i>
                                    <cite>时间设置</cite>
                                </a>
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
                                <a lay-href="/resource/disk" lay-tips="磁盘使用率" lay-direction="2">
                                    <i class="iconfont icon-disk"></i>
                                    <cite>磁盘使用率</cite>
                                </a>
                            </dd>
                            <dd data-name="resource-eth">
                                <a lay-href="/resource/eth" lay-tips="网卡流量" lay-direction="2">
                                    <i class="iconfont icon-wifi"></i>
                                    <cite>网卡流量</cite>
                                </a>
                            </dd>
                            <dd data-name="resource-mem">
                                <a lay-href="/resource/mem" lay-tips="内存管理" lay-direction="2">
                                    <i class="iconfont icon-memory"></i>
                                    <cite>内存管理</cite>
                                </a>
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
                                <a lay-href="/safe/login" lay-tips="登录设置" lay-direction="2">
                                    <i class="iconfont icon-login"></i>
                                    <cite>登录设置</cite>
                                </a>
                            </dd>
                            <dd data-name="safe-firewall">
                                <a lay-href="/safe/firewall" lay-tips="防火墙设置" lay-direction="2">
                                    <i class="iconfont icon-firewall"></i>
                                    <cite>防火墙设置</cite>
                                </a>
                            </dd>
                            <dd data-name="safe-ssh">
                                <a lay-href="/safe/ssh" lay-tips="SSH管理"
                                   lay-direction="2"><cite>SSH管理</cite></a>
                            </dd>
                            <dd data-name="safe-ping">
                                <a lay-href="/safe/ping" lay-tips="PING管理" lay-direction="2"><cite>PING管理</cite></a>
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
                <iframe src="/home" class="layadmin-iframe"></iframe>
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