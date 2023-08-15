<div class="layui-row layui-col-space10">
    <div class="layui-col-sm6 layui-col-md3">
        <div class="layui-card">
            <div class="layui-card-header">
                站点/FTP/数据库（个）
                <span class="layui-badge layui-bg-blue layuiadmin-badge">Site</span>
            </div>
            <div class="layui-card-body layuiadmin-card-list">
                <p class="layuiadmin-big-font">{{.obj.SiteCount}} / {{.obj.FtpCount}} / {{.obj.SqlCount}}</p>
            </div>
        </div>
    </div>
    <div class="layui-col-sm6 layui-col-md3">
        <div class="layui-card">
            <div class="layui-card-header">
                运行时间
                <span class="layui-badge layui-bg-cyan layuiadmin-badge">RunTime</span>
            </div>
            <div class="layui-card-body layuiadmin-card-list">
                <p class="layuiadmin-big-font">{{.obj.Uptime.Used}}</p>
            </div>
        </div>
    </div>
    <div class="layui-col-sm6 layui-col-md3">
        <div class="layui-card">
            <div class="layui-card-header">
                系统负载
                <span class="layui-badge layui-bg-green layuiadmin-badge">load</span>
            </div>
            <div class="layui-card-body layuiadmin-card-list">
                <p class="layuiadmin-big-font">{{.obj.Uptime.Load}}</p>
            </div>
        </div>
    </div>
    <div class="layui-col-sm6 layui-col-md3">
        <div class="layui-card">
            <div class="layui-card-header">
                可用内存
                <span class="layui-badge layui-bg-orange layuiadmin-badge">Free</span>
            </div>
            <div class="layui-card-body layuiadmin-card-list">
                <p id="free" class="layuiadmin-big-font"></p>
            </div>
        </div>
    </div>
    {{html .tips}}
    <div class="layui-col-md6">
        <div class="layui-card">
            <div class="layui-card-header">快捷操作</div>
            <div class="layui-card-body">
                <div class="layui-carousel layadmin-carousel layadmin-shortcut">
                    <div carousel-item>
                        <ul class="layui-row layui-col-space10">
                            <li class="layui-col-xs2">
                                <a href="javascript:" data-event="terminal" lay-text="打开终端">
                                    <i class="layui-icon iconfont icon-cmd"></i>
                                    <cite>终端</cite>
                                </a>
                            </li>
                            <li class="layui-col-xs2">
                                <a lay-href="/record/info" lay-text="全部日志概况">
                                    <i class="layui-icon layui-icon-log"></i>
                                    <cite>日志概况</cite>
                                </a>
                            </li>
                            <li class="layui-col-xs2">
                                <a lay-href="/site" lay-text="站点列表">
                                    <i class="layui-icon layui-icon-website"></i>
                                    <cite>创建站点</cite>
                                </a>
                            </li>
                            <li class="layui-col-xs2">
                                <a lay-href="/site/php">
                                    <i class="layui-icon layui-icon-engine"></i>
                                    <cite>PHP版本</cite>
                                </a>
                            </li>
                            <li class="layui-col-xs2">
                                <a lay-href="/file?path={{.rewritePath}}">
                                    <i class="layui-icon layui-icon-file"></i>
                                    <cite>伪静态规则</cite>
                                </a>
                            </li>
                            <li class="layui-col-xs2">
                                <a lay-href="/sql" lay-text="数据库列表">
                                    <i class="layui-icon iconfont icon-sql"></i>
                                    <cite>创建数据库</cite>
                                </a>
                            </li>
                            <li class="layui-col-xs2">
                                <a href="{{.obj.Phpmyadmin}}" target="_blank">
                                    <i class="layui-icon layui-icon-survey"></i>
                                    <cite>phpMyAdmin</cite>
                                </a>
                            </li>
                            <li class="layui-col-xs2">
                                <a lay-href="/ftp" lay-text="Ftp列表">
                                    <i class="layui-icon iconfont icon-ftp"></i>
                                    <cite>创建FTP</cite>
                                </a>
                            </li>
                            <li class="layui-col-xs2">
                                <a lay-href="/resource/eth">
                                    <i class="layui-icon layui-icon-chart-screen"></i>
                                    <cite>流量查看</cite>
                                </a>
                            </li>
                            <li class="layui-col-xs2">
                                <a lay-href="/system/service">
                                    <i class="layui-icon layui-icon-layer"></i>
                                    <cite>启动服务</cite>
                                </a>
                            </li>
                            <li class="layui-col-xs2">
                                <a lay-href="/system/port">
                                    <i class="layui-icon layui-icon-set"></i>
                                    <cite>端口检查</cite>
                                </a>
                            </li>
                            <li class="layui-col-xs2">
                                <a lay-href="/system/process">
                                    <i class="layui-icon layui-icon-engine"></i>
                                    <cite>进程管理</cite>
                                </a>
                            </li>
                        </ul>
                        <ul class="layui-row layui-col-space10">
                            <li class="layui-col-xs2">
                                <a lay-href="/safe/firewall">
                                    <i class="layui-icon layui-icon-auz"></i>
                                    <cite>防火墙</cite>
                                </a>
                            </li>
                            <li class="layui-col-xs2">
                                <a lay-href="/safe/ping">
                                    <i class="layui-icon iconfont icon-resource"></i>
                                    <cite>开关ping</cite>
                                </a>
                            </li>
                            <li class="layui-col-xs2">
                                <a lay-href="/safe/ssh">
                                    <i class="layui-icon iconfont icon-ssh"></i>
                                    <cite>SSH管理</cite>
                                </a>
                            </li>
                            <li class="layui-col-xs2">
                                <a lay-href="/system/reboot">
                                    <i class="layui-icon iconfont icon-system"></i>
                                    <cite>服务重启</cite>
                                </a>
                            </li>
                            <li class="layui-col-xs2">
                                <a lay-href="{{.pUrl}}" lay-text="探针">
                                    <i class="layui-icon layui-icon-chart"></i>
                                    <cite>探针</cite>
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="layui-col-md6">
        <div class="layui-card">
            <div class="layui-card-header">服务重启</div>
            <div class="layui-card-body">
                <div class="layui-carousel layadmin-carousel layadmin-shortcut" lay-anim="" style="width: 100%; height: 280px;">
                    <div carousel-item="">
                        <ul class="layui-row layui-col-space10 layui-this">
                            <li class="layui-col-xs4" data-reboot="lnmp restart">
                                <i class="layui-icon layui-icon-website"></i>
                                <cite>重启Web</cite>
                            </li>
                            <li class="layui-col-xs4" data-reboot="lnmp mysql restart">
                                <i class="layui-icon iconfont icon-sql"></i>
                                <cite>重启MySQL</cite>
                            </li>
                            <li class="layui-col-xs4" data-reboot="/etc/init.d/pureftpd restart">
                                <i class="layui-icon iconfont icon-ftp"></i>
                                <cite>重启FTP</cite>
                            </li>
                            <li class="layui-col-xs4" data-reboot="systemctl restart sshd">
                                <i class="layui-icon iconfont icon-ssh"></i>
                                <cite>重启SSH</cite>
                            </li>
                            <li class="layui-col-xs4" data-event="app">
                                <i class="layui-icon layui-icon-app"></i>
                                <cite>重启App</cite>
                            </li>
                            <li class="layui-col-xs4" data-event="service">
                                <i class="layui-icon iconfont icon-resource"></i>
                                <cite>重启服务器</cite>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="layui-col-md6">
        <div class="layui-card">
            <div class="layui-card-header">服务器信息</div>
            <div class="layui-card-body">
                <table class="layui-table" lay-even="" lay-skin="nob">
                    <tbody>
                    <tr>
                        <td>管理系统:</td>
                        <td>{{.server_name}}</td>
                    </tr>
                    <tr>
                        <td>当前版本:</td>
                        <td>
                            {{.version}}
                            <div class="layui-btn-group" style="margin-left:10px">
                                {{if not .remoteVersion -}}
                                    <button class="layui-btn layui-btn-sm layui-btn-checked" data-event="upgrade">
                                        正在查询最新版本...
                                    </button>
                                {{else if eq .version .remoteVersion -}}
                                    <button class="layui-btn layui-btn-sm" data-event="upgrade">
                                        已经是最新版本
                                    </button>
                                {{else -}}
                                    <button class="layui-btn layui-btn-sm layui-btn-danger" data-event="upgrade">
                                        升级到最新版本: {{.remoteVersion}}
                                    </button>
                                {{end -}}
                                <a class="layui-btn layui-btn-sm layui-btn-primary" href="https://github.com/kuangxianwei/botadmin-upgrade/releases" target="_blank">升级日志</a>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>操作系统：</td>
                        <td>{{.obj.SysName}}</td>
                    </tr>
                    <tr>
                        <td>主 机 名：</td>
                        <td>{{.obj.HostName}}</td>
                    </tr>

                    <tr>
                        <td>CPU参数：</td>
                        <td>{{.obj.CpuCount}}</td>
                    </tr>
                    <tr>
                        <td>CPU型号：</td>
                        <td>{{.obj.Cpu.ModelName}}</td>
                    </tr>
                    <tr>
                        <td>系统时间：</td>
                        <td>{{.obj.SysDate}}</td>
                    </tr>
                    <tr>
                        <td>服务器IP：</td>
                        <td>
                            <textarea name="address" autocomplete="off" class="layui-textarea" rows="5">{{join .obj.Ips "\n"}}</textarea>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="layui-col-md6">
        <div class="layui-card">
            <div class="layui-card-header" id="total"></div>
            <div class="layui-card-body">
                <div class="layuiadmin-card-list">
                    <span></span>
                    <div class="layui-progress layui-progress-big" lay-filter="free-progress">
                        <div class="layui-progress-bar" lay-percent="0%"></div>
                    </div>
                </div>
                <div class="layuiadmin-card-list">
                    <span></span>
                    <div class="layui-progress layui-progress-big" lay-filter="active-progress">
                        <div class="layui-progress-bar layui-bg-cyan" lay-percent="0%"></div>
                    </div>
                </div>
                <div class="layuiadmin-card-list">
                    <span></span>
                    <div class="layui-progress layui-progress-big" lay-filter="inactive-progress">
                        <div class="layui-progress-bar layui-bg-orange" lay-percent="0%"></div>
                    </div>
                </div>
                <div class="layuiadmin-card-list">
                    <span></span>
                    <div class="layui-progress layui-progress-big" lay-filter="used-progress">
                        <div class="layui-progress-bar layui-bg-red" lay-percent="0%"></div>
                    </div>
                </div>
                <div class="layuiadmin-card-list">
                    <span></span>
                    <div class="layui-progress layui-progress-big" lay-filter="available-progress">
                        <div class="layui-progress-bar" lay-percent="0%"></div>
                    </div>
                </div>
                <div class="layuiadmin-card-list">
                    <span></span>
                    <div class="layui-progress layui-progress-big" lay-filter="wired-progress">
                        <div class="layui-progress-bar layui-bg-cyan" lay-percent="0%"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="/static/layui/layui.js"></script>
<script type="text/html" id="upgrade-html">
    <div class="layui-card" style="text-align:center">
        <div class="layui-card-body layui-form">
            <button class="layui-hide" lay-submit></button>
            <input type="radio" name="mirror" value="0" title="国外源" checked>
            <input type="radio" name="mirror" value="1" title="国内源">
            <input type="checkbox" name="force" id="force" lay-skin="switch" lay-text="启用强制|关闭强制">
        </div>
    </div>
</script>
<script>
    layui.use(['index', 'console', 'main'], function () {
        let main = layui.main, element = layui.element;
        {{if .reminded -}}
        main.display({
            type: 1,
            area: "auto",
            content: '<div class="layui-card"><div class="layui-card-body" style="background-color: #0a6e85;color: #F2F2F2;line-height: 2rem"><a lay-href="/resource/disk" style="color: #F2F2F2"><h2>本服务器储存剩余空间不足5%, 请扩充储存空间,详情查看</h2></a></div></div>',
        });
        {{end -}}
        let active = {
            record: function () {
                main.ws.info();
            },
            upgrade: function () {
                main.popup({
                    title: false,
                    maxmin: false,
                    url: '/home/upgrade',
                    content: $('#upgrade-html').html(),
                    area: '380px',
                    done: function () {
                        main.ws.log("app_upgrade");
                    }
                });
            },
            terminal: function () {
                main.webssh();
            },
            app: function () {
                main.reboot.app(URL + '/reboot');
            },
            service: function () {
                main.reboot.service(URL + '/reboot');
            },
        };
        $('[data-reboot]').off('click').on('click', function () {
            main.webssh({stdin: $(this).data("reboot")});
        });
        $('[data-event]').off('click').on('click', function () {
            let $this = $(this), event = $this.data("event");
            active[event] && active[event].call($this);
        });
        main.checkLNMP();
        element.render('progress');
        let progress = function (field, name, text) {
            element.progress(name + '-progress', field.percent);
            $('[lay-filter=' + name + '-progress]>.layui-progress-bar').html('<span class="layui-progress-text">' + field.percent + '</span>').parent().parent().find('>span').text(text + ': ' + field.value)
        };
        let getMemory = function () {
            $.get(URL + '/memory', function (res) {
                if (res) {
                    $('#free').text(res.free.value);
                    $('#total').text('总内存: ' + res.total.value);
                    progress(res['free'], 'free', '空闲内存');
                    progress(res['used'], 'used', '已用内存');
                    progress(res['active'], 'active', '活动内存');
                    progress(res['inactive'], 'inactive', '非活动内存');
                    progress(res['available'], 'available', '可申请内存');
                    progress(res['wired'], 'wired', '有线内存');
                }
            })
        };
        getMemory();
        setInterval(getMemory, 10000);
    });
</script>