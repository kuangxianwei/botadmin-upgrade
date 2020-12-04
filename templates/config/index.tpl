<div class="layui-card">
    <div class="layui-card-body">
        <div class="layui-tab layui-tab-card">
            <ul class="layui-tab-title">
                <li class="layui-this">基本设置</li>
                <li>环境设置</li>
                <li>采集设置</li>
                <li>翻译设置</li>
                <li>违禁设置</li>
                <li>监控服务</li>
            </ul>
            <div class="layui-tab-content">
                <div class="layui-tab-item layui-show layui-form">
                    <div class="layui-row">
                        <div class="layui-col-md3">
                            <div class="layui-form-item">
                                <label class="layui-form-label">用户名:</label>
                                <div class="layui-input-block">
                                    <input type="text" name="username" value="{{.base.Username}}" class="layui-input">
                                </div>
                            </div>
                        </div>
                        <div class="layui-col-md3">
                            <div class="layui-form-item">
                                <label class="layui-form-label">Host:</label>
                                <div class="layui-input-block">
                                    <input type="text" name="addr" value="{{.base.Addr}}" class="layui-input">
                                </div>
                            </div>
                        </div>
                        <div class="layui-col-md3">
                            <div class="layui-form-item">
                                <label class="layui-form-label">端口:</label>
                                <div class="layui-input-block">
                                    <input type="text" name="port" value="{{.base.Port}}" class="layui-input">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="layui-row">
                        <div class="layui-col-md3">
                            <div class="layui-form-item">
                                <label class="layui-form-label">运行模式:</label>
                                <div class="layui-input-block">
                                    <input type="radio" name="run_mode" value="prod"
                                           title="正常"{{if eq .base.RunMode "prod"}} checked{{end}}>
                                    <input type="radio" name="run_mode" value="dev"
                                           title="调试"{{if eq .base.RunMode "dev"}} checked{{end}}>
                                </div>
                            </div>
                        </div>
                        <div class="layui-col-md3">
                            <div class="layui-form-item">
                                <label class="layui-form-label">Gzip:</label>
                                <div class="layui-input-block">
                                    <input type="checkbox" name="gzip_enabled"
                                           lay-skin="switch" lay-text="打开|关闭"{{if .base.GzipEnabled}} checked{{end}}>
                                </div>
                            </div>
                        </div>
                        <div class="layui-col-md3">
                            <div class="layui-form-item">
                                <label class="layui-form-label">CSRF:</label>
                                <div class="layui-input-block">
                                    <input type="checkbox" name="csrf_enabled"
                                           lay-skin="switch" lay-text="打开|关闭"{{if .base.CsrfEnabled}} checked{{end}}>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">登录限制:</label>
                        <div class="layui-input-inline">
                            <input type="text" name="limit_login" value="{{.base.LimitLogin}}" class="layui-input">
                        </div>
                        <div class="layui-form-mid layui-word-aux">登录错误次数超过将限制N分钟后登录 0为不限制录</div>
                    </div>
                    <div class="layui-row">
                        <div class="layui-col-md5">
                            <div class="layui-form-item">
                                <label class="layui-form-label">csrf秘钥:</label>
                                <div class="layui-input-block">
                                    <input type="text" name="csrf_secret"
                                           value="{{.base.CsrfSecret}}" class="layui-input">
                                </div>
                            </div>
                        </div>
                        <div class="layui-col-md5">
                            <div class="layui-form-item">
                                <label class="layui-form-label">PhpMyAdmin:</label>
                                <div class="layui-input-block">
                                    <input type="text" name="php_my_admin_name" value="{{.base.PhpMyAdminName}}"
                                           class="layui-input">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="layui-row">
                        <div class="layui-col-md5">
                            <div class="layui-form-item">
                                <label class="layui-form-label">定时排名:</label>
                                <div class="layui-input-block">
                                    <input type="text" name="rank_spec" value="{{.base.RankSpec}}" class="layui-input">
                                </div>
                            </div>
                        </div>
                        <div class="layui-col-md5">
                            <div class="layui-form-item">
                                <label class="layui-form-label">定时重启:</label>
                                <div class="layui-input-block">
                                    <input type="text" name="reboot_spec" value="{{.base.RebootSpec}}"
                                           class="layui-input">
                                </div>
                            </div>
                        </div>
                    </div>
                    <input type="hidden" name="uid" value="{{.base.Uid}}">
                    <div class="layui-form-item">
                        <label class="layui-form-label"></label>
                        <div class="layui-btn-group">
                            <button class="layui-btn" lay-submit lay-filter="submit-base">立即提交</button>
                            <button class="layui-btn" data-event="reset" data-name="base" data-tip="Base 恢复出厂设置?">恢复默认
                            </button>
                        </div>
                    </div>
                </div>

                <div class="layui-tab-item layui-form">
                    {{.serverHtml}}
                    <div class="layui-form-item">
                        <label class="layui-form-label"></label>
                        <div class="layui-btn-group">
                            <button class="layui-btn" lay-submit lay-filter="submit-server">立即提交
                            </button>
                            <button class="layui-btn" data-event="reset" data-name="server" data-tip="Server 恢复出厂设置?">
                                恢复默认
                            </button>
                            <button class="layui-btn layui-btn-danger" data-event="reset" data-name="app"
                                    data-tip="抹去本程序所有数据?包括所建的网站等...">重置App
                            </button>
                        </div>
                    </div>
                </div>
                <div class="layui-tab-item layui-form">
                    {{.spiderHtml}}
                    <div class="layui-form-item">
                        <label class="layui-form-label"></label>
                        <div class="layui-btn-group">
                            <button class="layui-btn" lay-submit lay-filter="submit-data">立即提交
                            </button>
                            <button class="layui-btn layui-btn-danger" data-event="reset" data-name="data"
                                    data-tip="清空所有已经采集的数据?不可恢复!">
                                清空采集数据
                            </button>
                        </div>
                    </div>
                </div>
                <div class="layui-tab-item">
                    <div class="layui-fluid">
                        <div class="layui-row layui-col-space10">
                            <div class="layui-col-sm3">
                                <fieldset class="layui-elem-field layui-form">
                                    <legend>百度翻译</legend>
                                    {{.transBaiduHtml}}
                                </fieldset>
                            </div>
                            <div class="layui-col-sm3">
                                <fieldset class="layui-elem-field layui-form">
                                    <legend>腾讯翻译</legend>
                                    {{.transTencentHtml}}
                                </fieldset>
                            </div>
                            <div class="layui-col-sm3">
                                <fieldset class="layui-elem-field layui-form">
                                    <legend>有道翻译</legend>
                                    {{.transYoudaoHtml}}
                                </fieldset>
                            </div>
                            <div class="layui-col-sm3">
                                <fieldset class="layui-elem-field layui-form">
                                    <legend>谷歌翻译</legend>
                                    {{.transGoogleHtml}}
                                </fieldset>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="layui-tab-item layui-form">
                    {{.banHtml}}
                    <div class="layui-form-item">
                        <label class="layui-form-label"></label>
                        <div class="layui-btn-group">
                            <button class="layui-btn" lay-submit lay-filter="submit-ban">立即提交
                            </button>
                            <button class="layui-btn layui-btn-danger" data-event="reset" data-name="ban"
                                    data-tip="违禁设置恢复到出厂设置?">恢复出厂设置
                            </button>
                            <button class="layui-btn" data-event="ban-test">测试</button>
                            <button class="layui-btn layui-btn-small layui-btn-normal" data-event="edit-deny">编辑黑名单
                            </button>
                            <button class="layui-btn layui-btn-small layui-btn-normal" data-event="edit-allow">编辑白名单
                            </button>
                        </div>
                    </div>
                    <div class="layui-form-item" id="test-ban">
                        <textarea class="layui-textarea layui-bg-black layui-hide" name="content" rows="10"
                                  style="color: white;"></textarea>
                    </div>
                </div>
                <div class="layui-tab-item layui-form">
                    <div class="layui-form-item">
                        <label class="layui-form-label">Nginx:</label>
                        <div class="layui-input-inline">
                            <input type="checkbox" name="nginx_enabled" lay-skin="switch"
                                   lay-text="打开|关闭"{{if .monitor.NginxEnabled}} checked{{end}}>
                        </div>
                        <div class="layui-form-mid layui-word-aux">
                            <span class="text-danger">开启监控NGINX</span>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">MySQL:</label>
                        <div class="layui-input-inline">
                            <input type="checkbox" name="mysql_enabled" lay-skin="switch"
                                   lay-text="打开|关闭"{{if .monitor.MysqlEnabled}} checked{{end}}>
                        </div>
                        <div class="layui-form-mid layui-word-aux">
                            <span class="text-danger">开启监控MySQL</span>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">PHP:</label>
                        <div class="layui-input-inline">
                            <input type="checkbox" name="php_enabled" lay-skin="switch"
                                   lay-text="打开|关闭"{{if .monitor.PhpEnabled}} checked{{end}}>
                        </div>
                        <div class="layui-form-mid layui-word-aux">
                            <span class="text-danger">开启监控PHP</span>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <table>
                            <tbody>
                            <tr>
                                <th rowspan="2"><label class="layui-form-label">定时:</label></th>
                                <th align="center">分:0-59 *-,</th>
                                <th align="center">时:0-23 *-,</th>
                                <th align="center">天:1-31 *-,</th>
                                <th align="center">月:1-12 *-,</th>
                                <th align="center">周:0-6 *-,</th>
                            </tr>
                            <tr>
                                <td>
                                    <input type="text" name="minute" value="{{.monitor.Minute}}"
                                           class="layui-input">
                                </td>
                                <td style="padding-left: 2%;">
                                    <input type="text" name="hour" value="{{.monitor.Hour}}" class="layui-input">
                                </td>
                                <td style="padding-left: 2%;">
                                    <input type="text" name="day" value="{{.monitor.Day}}" class="layui-input">
                                </td>
                                <td style="padding-left: 2%;">
                                    <input type="text" name="month" value="{{.monitor.Month}}" class="layui-input">
                                </td>
                                <td style="padding-left: 2%;">
                                    <input type="text" name="week" value="{{.monitor.Week}}" class="layui-input">
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label"></label>
                        <div class="layui-btn-group">
                            <button class="layui-btn" lay-submit lay-filter="submit-monitor">立即提交
                            </button>
                            <button class="layui-btn layui-btn-danger" data-event="reset" data-name="monitor"
                                    data-tip="违禁设置恢复到出厂设置?">恢复出厂设置
                            </button>
                            <button class="layui-btn" data-event="status" data-name="monitor"
                                    data-tip="查看定时状态">查看状态
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="/static/layui/layui.js"></script>
<script>
    layui.config({
        base: '/static/' //静态资源所在路径
    }).extend({
        index: 'lib/index', //主入口模块
        main: 'main'
    }).use(['index', 'form', 'main'], function () {
        let $ = layui.$,
            layer = layui.layer,
            main = layui.main,
            form = layui.form,
            url = {{.current_uri}};

        form.on('submit(submit-base)', function (obj) {
            main.req({
                url: url + '/base',
                data: obj.field,
            });
            return false;
        });
        form.on('submit(submit-server)', function (obj) {
            main.req({
                url: url + '/server',
                data: obj.field,
            });
            return false;
        });
        form.on('submit(submit-monitor)', function (obj) {
            main.req({
                url: url + '/monitor',
                data: obj.field,
            });
            return false;
        });
        form.on('submit(submit-ban)', function (obj) {
            main.req({
                url: url + '/ban',
                data: obj.field,
            });
            return false;
        });
        form.on('submit(submit-data)', function (obj) {
            main.req({
                url: url + '/data',
                data: obj.field,
            });
            return false;
        });
        form.on('submit(submit-google)', function (obj) {
            main.req({
                url: url + '/google',
                data: obj.field,
            });
            return false;
        });
        form.on('submit(submit-baidu)', function (obj) {
            main.req({
                url: url + '/baidu',
                data: obj.field,
            });
            return false;
        });
        form.on('submit(submit-youdao)', function (obj) {
            main.req({
                url: url + '/youdao',
                data: obj.field,
            });
            return false;
        });
        form.on('submit(submit-tencent)', function (obj) {
            main.req({
                url: url + '/tencent',
                data: obj.field,
            });
            return false;
        });
        $('.layui-btn[data-event]').on('click', function () {
            let othis = $(this),
                event = othis.data('event'),
                tip, name;
            switch (event) {
                case 'status':
                    name = othis.data('name');
                    tip = othis.data('tip');
                    if (name.length === 0) {
                        return false;
                    }
                    layer.confirm(tip, function (index) {
                        main.req({
                            url: url + '/status',
                            data: {name: name},
                            index: index,
                            tips: function (res) {
                                layer.alert(res.msg, {area: ['500px', '450px']});
                            },
                        });
                    });
                    break;
                case 'reset':
                    name = othis.data('name');
                    tip = othis.data('tip');
                    if (name.length === 0) {
                        return false;
                    }
                    layer.confirm(tip, function (index) {
                        main.req({
                            url: url + '/reset',
                            data: {name: name},
                            index: index,
                            ending: function () {
                                document.location.reload();
                            }
                        });
                    });
                    break;
                case 'ban-test':
                    main.popup({
                        title: '测试违禁词',
                        url: url + '/test/ban',
                        area: ['70%', '70%'],
                        ending: function (res) {
                            $('#test-ban>textarea').removeClass('layui-hide').text(res.msg);
                        },
                        content: '<div class="layui-card"><div class="layui-card-body layui-form"><div class="layui-form-item"><textarea class="layui-textarea layui-bg-black" name="content" rows="15" style="color: white;">输入需要检查的内容...</textarea></div><div class="layui-hide"><button class="layui-btn" lay-submit lay-filter="submit"></button></div></div></div>'
                    });
                    break;
                case 'edit-deny':
                    $.get('/config/edit', {name: 'deny'}, function (html) {
                        main.popup({
                            title: '编辑黑名单',
                            content: html,
                            url: '/config/edit'
                        });
                    });
                    break
                case 'edit-allow':
                    $.get('/config/edit', {name: 'allow'}, function (html) {
                        main.popup({
                            title: '编辑白名单',
                            content: html,
                            url: '/config/edit'
                        });
                    });
                    break
            }
            return false;
        });
    });
</script>