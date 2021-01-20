<style>
    div[lay-filter="monitor"] i.layui-icon-delete {
        color: red;
        cursor: pointer;
    }

    .cron .layui-input-inline {
        width: 50%;
    }

    .cron .layui-inline {
        width: 18%;
    }

    .cron .layui-input-block {
        margin-left: 80px;
    }

    .cron .layui-form-label {
        width: auto;
    }
</style>
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
                        <div class="layui-col-md2">
                            <div class="layui-form-item">
                                <label class="layui-form-label">Gzip:</label>
                                <div class="layui-input-block">
                                    <input type="checkbox" name="gzip_enabled"
                                           lay-skin="switch" lay-text="打开|关闭"{{if .base.GzipEnabled}} checked{{end}}>
                                </div>
                            </div>
                        </div>
                        <div class="layui-col-md2">
                            <div class="layui-form-item">
                                <label class="layui-form-label">CSRF:</label>
                                <div class="layui-input-block">
                                    <input type="checkbox" name="csrf_enabled"
                                           lay-skin="switch" lay-text="打开|关闭"{{if .base.CsrfEnabled}} checked{{end}}>
                                </div>
                            </div>
                        </div>
                        <div class="layui-col-md2">
                            <div class="layui-form-item">
                                <label class="layui-form-label">广告缓存:</label>
                                <div class="layui-input-block">
                                    <input type="checkbox" name="ad_cached"
                                           lay-skin="switch" lay-text="打开|关闭"{{if .base.AdCached}} checked{{end}}>
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
                            <button class="layui-btn layui-btn-small layui-btn-normal" data-event="edit-ban">编辑禁词
                            </button>
                        </div>
                    </div>
                </div>
                <div class="layui-tab-item layui-form">
                    <fieldset class="layui-elem-field">
                        <legend>定时设置</legend>
                        <div class="layui-form-item">
                            <div class="layui-row cron">
                                <div class="layui-col-md2">
                                    <label class="layui-form-label">启用:</label>
                                    <div class="layui-input-inline">
                                        <input type="checkbox" name="enabled"
                                               lay-skin="switch" lay-text="启用|关闭"{{if .monitor.Enabled}} checked{{end}}>
                                    </div>
                                </div>
                                <div class="layui-col-md2">
                                    <label class="layui-form-label" lay-tips="0-59 *-,">分:</label>
                                    <div class="layui-input-inline">
                                        <input type="text" name="minute" value="{{.monitor.Minute}}"
                                               class="layui-input">
                                    </div>
                                </div>
                                <div class="layui-col-md2">
                                    <label class="layui-form-label" lay-tips="0-23 *-,">时:</label>
                                    <div class="layui-input-inline">
                                        <input type="text" name="hour" value="{{.monitor.Hour}}"
                                               class="layui-input">
                                    </div>
                                </div>
                                <div class="layui-col-md2">
                                    <label class="layui-form-label" lay-tips="1-31 *-,">天:</label>
                                    <div class="layui-input-inline">
                                        <input type="text" name="day" value="{{.monitor.Day}}"
                                               class="layui-input">
                                    </div>
                                </div>
                                <div class="layui-col-md2">
                                    <label class="layui-form-label" lay-tips="1-12 *-,">月:</label>
                                    <div class="layui-input-inline">
                                        <input type="text" name="month" value="{{.monitor.Month}}"
                                               class="layui-input">
                                    </div>
                                </div>
                                <div class="layui-col-md2">
                                    <label class="layui-form-label" lay-tips="0-6 *-,">周:</label>
                                    <div class="layui-input-inline">
                                        <input type="text" name="week" value="{{.monitor.Week}}"
                                               class="layui-input">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </fieldset>
                    <fieldset class="layui-elem-field">
                        <legend>监控服务设置</legend>
                        <div lay-filter="monitor"></div>
                    </fieldset>
                    <div class="layui-form-item">
                        <label class="layui-form-label"></label>
                        <div class="layui-btn-group">
                            <button class="layui-btn layui-btn-primary" lay-event="add" lay-tips="添加监控服务">
                                <i class="layui-icon layui-icon-addition"></i>
                            </button>
                            <button class="layui-btn" lay-submit lay-filter="submit-monitor">立即提交
                            </button>
                            <button class="layui-btn layui-btn-danger" data-event="reset" data-name="monitor"
                                    data-tip="监控设置恢复到出厂设置?">恢复出厂设置
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
<script type="text/html" id="monitor">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">服务名称:</label>
            <div class="layui-input-inline">
                <input name="services.name." class="layui-input" value="">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">运行特征:</label>
            <div class="layui-input-inline">
                <input name="services.run_mark." class="layui-input" value="">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">停止特征:</label>
            <div class="layui-input-inline">
                <input name="services.stop_mark." class="layui-input" value="">
            </div>
        </div>
        <i class="layui-icon layui-icon-delete" lay-tips="删除该条服务监控"></i>
    </div>
</script>
{{template "JS" -}}
<script>
    JS.use(['index', 'main'], function () {
        let $ = layui.$,
            layer = layui.layer,
            main = layui.main,
            form = layui.form,
            services = {{.monitor.Services}},
            url = {{.current_uri}},
            del = function () {
                $('[lay-filter="monitor"] i.layui-icon-delete').click(function () {
                    $(this).parent().remove();
                })
            },
            getIndex = function () {
                let index = 0;
                $('[lay-filter="monitor"] [name^="services.name."]').each(function (i, dom) {
                    i = parseInt(dom.name.split('.')[2]);
                    if (!isNaN(i) && i > index) {
                        index = i;
                    }
                });
                return index + 1;
            },
            addService = function (index, option) {
                index = index || getIndex();
                option = option || {};
                let dom = $($('#monitor').html());
                dom.find('[name]').each(function () {
                    $(this).attr('name', this.name + index);
                });
                $.each(option, function (k, v) {
                    dom.find('[name^="services.' + k + '."]').val(v);
                });
                $('div[lay-filter="monitor"]').append(dom);
            };
        if (services) {
            $.each(services, function (index, v) {
                addService(0, v);
            });
            form.render();
            del();
        }
        $('[lay-event="add"]').click(function () {
            addService();
            del();
        });
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
                                main.msg(res.msg);
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
                        tips: function (res) {
                            main.msg(`<textarea class="layui-textarea layui-bg-black" name="content" rows="10" style="color: white;">` + res.msg.replaceAll("<br/>", "\n") + `</textarea>`, {area: ['500px', 'auto']});
                        },
                        content: '<div class="layui-card"><div class="layui-card-body layui-form"><div class="layui-form-item"><textarea class="layui-textarea layui-bg-black" name="content" rows="15" style="color: white;">输入需要检查的内容...</textarea></div><div class="layui-hide"><button class="layui-btn" lay-submit lay-filter="submit"></button></div></div></div>'
                    });
                    break;
                case 'edit-ban':
                    $.get('/config/ban/data', function (html) {
                        main.popup({
                            title: '编辑禁词',
                            content: html,
                            url: '/config/ban/data'
                        });
                    });
                    break
            }
            return false;
        });
    });
</script>