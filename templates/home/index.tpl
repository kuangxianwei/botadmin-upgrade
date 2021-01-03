<div class="layui-row layui-col-space15">
    <div class="layui-col-sm6 layui-col-md3">
        <div class="layui-card">
            <div class="layui-card-header">
                站点/FTP/数据库（个）
                <span class="layui-badge layui-bg-blue layuiadmin-badge">Site</span>
            </div>
            <div class="layui-card-body layuiadmin-card-list">
                <p class="layuiadmin-big-font">{{.obj.SiteCount}} / {{.obj.FtpCount}}
                    / {{.obj.SqlCount}}</p>
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
                <p class="layuiadmin-big-font">{{.obj.Mem.Free}} MB</p>
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
                            <li class="layui-col-xs3">
                                <a lay-href="/site" lay-text="站点列表">
                                    <i class="layui-icon layui-icon-website"></i>
                                    <cite>创建站点</cite>
                                </a>
                            </li>
                            <li class="layui-col-xs3">
                                <a lay-href="/site/phps">
                                    <i class="layui-icon layui-icon-engine"></i>
                                    <cite>PHP版本</cite>
                                </a>
                            </li>
                            <li class="layui-col-xs3">
                                <a lay-href="/file?path={{.rewrite_path}}">
                                    <i class="layui-icon layui-icon-file"></i>
                                    <cite>伪静态规则</cite>
                                </a>
                            </li>
                            <li class="layui-col-xs3">
                                <a lay-href="/sql" lay-text="数据库列表">
                                    <i class="layui-icon iconfont icon-sql"></i>
                                    <cite>创建数据库</cite>
                                </a>
                            </li>
                            <li class="layui-col-xs3">
                                <a href="{{.obj.Phpmyadmin}}" target="_blank">
                                    <i class="layui-icon layui-icon-survey"></i>
                                    <cite>phpMyAdmin</cite>
                                </a>
                            </li>
                            <li class="layui-col-xs3">
                                <a lay-href="/ftp" lay-text="Ftp列表">
                                    <i class="layui-icon iconfont icon-ftp"></i>
                                    <cite>创建FTP</cite>
                                </a>
                            </li>
                            <li class="layui-col-xs3">
                                <a lay-href="/resource/eth">
                                    <i class="layui-icon layui-icon-chart-screen"></i>
                                    <cite>流量查看</cite>
                                </a>
                            </li>
                            <li class="layui-col-xs3">
                                <a lay-href="/system/service">
                                    <i class="layui-icon layui-icon-layer"></i>
                                    <cite>启动服务</cite>
                                </a>
                            </li>
                        </ul>
                        <ul class="layui-row layui-col-space10">
                            <li class="layui-col-xs3">
                                <a lay-href="/system/port">
                                    <i class="layui-icon layui-icon-set"></i>
                                    <cite>端口检查</cite>
                                </a>
                            </li>
                            <li class="layui-col-xs3">
                                <a lay-href="/system/process">
                                    <i class="layui-icon layui-icon-engine"></i>
                                    <cite>进程管理</cite>
                                </a>
                            </li>
                            <li class="layui-col-xs3">
                                <a lay-href="/safe/firewall">
                                    <i class="layui-icon layui-icon-auz"></i>
                                    <cite>防火墙</cite>
                                </a>
                            </li>
                            <li class="layui-col-xs3">
                                <a lay-href="/safe/ping">
                                    <i class="layui-icon iconfont icon-resource"></i>
                                    <cite>开关ping</cite>
                                </a>
                            </li>
                            <li class="layui-col-xs3">
                                <a lay-href="/safe/ssh">
                                    <i class="layui-icon iconfont icon-ssh"></i>
                                    <cite>SSH管理</cite>
                                </a>
                            </li>
                            <li class="layui-col-xs3">
                                <a lay-href="/system/reboot">
                                    <i class="layui-icon iconfont icon-system"></i>
                                    <cite>服务重启</cite>
                                </a>
                            </li>
                            <li class="layui-col-xs3">
                                <a lay-event="resetRecord">
                                    <i class="layui-icon layui-icon-log"></i>
                                    <cite>清空日志</cite>
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
                <div class="layui-carousel layadmin-carousel layadmin-shortcut">
                    <div carousel-item>
                        <ul class="layui-row layui-col-space10">
                            <li class="layui-col-xs4" data-reboot="web">
                                <i class="layui-icon layui-icon-website"></i>
                                <cite>重启Web</cite>
                            </li>
                            <li class="layui-col-xs4" data-reboot="mysql">
                                <i class="layui-icon iconfont icon-sql"></i>
                                <cite>重启MySQL</cite>
                            </li>
                            <li class="layui-col-xs4" data-reboot="pureftpd">
                                <i class="layui-icon iconfont icon-ftp"></i>
                                <cite>重启FTP</cite>
                            </li>
                            <li class="layui-col-xs4" data-reboot="ssh">
                                <i class="layui-icon iconfont icon-ssh"></i>
                                <cite>重启SSH</cite>
                            </li>
                            <li class="layui-col-xs4" data-reboot="botadmin">
                                <i class="layui-icon layui-icon-app"></i>
                                <cite>重启App</cite>
                            </li>
                            <li class="layui-col-xs4" data-reboot="reboot">
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
                    <colgroup>
                        <col width="105">
                        <col>
                    </colgroup>
                    <tbody>
                    <tr>
                        <td>管理系统:</td>
                        <td>{{.server_name}}</td>
                    </tr>
                    <tr>
                        <td>当前版本:</td>
                        <td><h2 style="display:inline-block; padding-right:20px;">{{.version}}</h2>
                            <a class="layui-btn layui-btn-sm"
                               href="https://github.com/kuangxianwei/botadmin-upgrade/releases" target="_blank">更新日志
                            </a>
                            <button class="layui-btn layui-btn-sm" lay-event="update-templates">更新建站模板</button>
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
                        <td><textarea class="layui-textarea" rows="5">{{join .obj.Ips "\n"}}</textarea></td>
                    </tr>
                    <tr>
                        <td>内存使用：</td>
                        <td>{{.obj.Mem.Info}}</td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="layui-col-md6">
        <div class="layui-card">
            <div class="layui-card-header">最新资讯</div>
            <div class="layui-card-body">
                <iframe id="iframeSRC" src="" scrolling="no" frameborder="0"
                        height="440px" width="100%"></iframe>
            </div>
        </div>
    </div>
    <div class="layui-col-md12">
        <div class="layui-card">
            <div class="layui-card-header">探针</div>
            <div class="layui-card-body">
                <a href="{{.p_url}}" target="_blank">查看探针详情</a>
            </div>
        </div>
    </div>
    <div class="layui-col-md12">
        <div class="layui-card">
            <div class="layui-card-header">OCP</div>
            <div class="layui-card-body">
                <iframe id="iframeOCP" src="{{.ocp_url}}" frameborder="0"
                        height="150px" width="100%" scrolling="no"></iframe>
            </div>
        </div>
    </div>
</div>
{{template "JS" -}}
<script>
    JS.use(['index', 'main', 'sample'], function () {
        let main = layui.main;
        $('li[data-reboot]').click(function () {
            let act = $(this).data("reboot");
            main.req({
                url: '/system/reboot',
                tips: function (res) {
                    main.msg(res.msg);
                },
                data: {act: act},
            });
        });
        $('[lay-event]').click(function () {
            switch ($(this).attr('lay-event')) {
                case 'resetRecord':
                    main.req({url: '/config/reset/record'});
                    break;
                case 'update-templates':
                    main.req({url: '/home/update/templates'});
                    break;
            }
        });
    });
</script>
