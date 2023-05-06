<style>
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
                <li>违禁设置</li>
                <li>监控服务</li>
            </ul>
            <div class="layui-tab-content">
                <div class="layui-tab-item layui-show layui-form">
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">用户名:</label>
                            <div class="layui-input-block">
                                <input type="text" name="username" value="{{.base.Username}}" class="layui-input" placeholder="用户名">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">Host:</label>
                            <div class="layui-input-block">
                                <input type="text" name="addr" value="{{.base.Addr}}" class="layui-input" placeholder="localhost">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">端口:</label>
                            <div class="layui-input-block">
                                <input type="number" name="port" value="{{.base.Port}}" class="layui-input" placeholder="8080">
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">运行模式:</label>
                            <div class="layui-input-block">
                                <input type="radio" name="run_mode" value="prod"
                                       title="正常"{{if eq .base.RunMode "prod"}} checked{{end}}>
                                <input type="radio" name="run_mode" value="dev"
                                       title="调试"{{if eq .base.RunMode "dev"}} checked{{end}}>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">Gzip:</label>
                            <div class="layui-input-block">
                                <input type="checkbox" name="gzip_enabled"
                                       lay-skin="switch" lay-text="打开|关闭"{{if .base.GzipEnabled}} checked{{end}}>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">CSRF:</label>
                            <div class="layui-input-block">
                                <input type="checkbox" name="csrf_enabled"
                                       lay-skin="switch" lay-text="打开|关闭"{{if .base.CsrfEnabled}} checked{{end}}>
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">日志级别:</label>
                            <div class="layui-input-inline">
                                <select name="record_level" class="layui-select">
                                    {{range $i,$v:=.record_levels -}}
                                        <option value="{{$i}}"{{if eq $.base.RecordLevel $i}} selected{{end}}>{{$v.Name}}</option>
                                    {{end -}}
                                </select>
                            </div>
                            <div class="layui-form-mid layui-word-aux">重启App后生效</div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">广告缓存:</label>
                            <div class="layui-input-inline">
                                <input type="number" name="ad_cache" value="{{.base.AdCache}}" min="0" class="layui-input">
                            </div>
                            <div class="layui-form-mid layui-word-aux">
                                缓存过期时间(单位秒)
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label" lay-tips="开启性能监测">Pprof:</label>
                        <div class="layui-input-inline">
                            <input type="checkbox" name="pprof"
                                   lay-skin="switch" lay-text="打开|关闭"{{if .base.Pprof}} checked{{end}}>
                        </div>
                        <div class="layui-form-mid layui-word-aux">
                            仅调试启用(开发人员<a lay-href="/debug/pprof" lay-text="pprof">查看性能</a>)
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
                                <div class="layui-input-block" lay-tips="双击修改定时任务">
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
                    <input type="hidden" name="uid" value="{{.base.Id}}">
                    <div class="layui-form-item">
                        <label class="layui-form-label"></label>
                        <div class="layui-btn-group">
                            <button class="layui-btn" lay-submit lay-filter="submit-base">立即提交</button>
                            <button class="layui-btn" data-event="reset" data-name="base" data-tip="Base 恢复出厂设置?">
                                <i class="layui-icon iconfont icon-reset"></i>默认
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
                                <i class="layui-icon iconfont icon-reset"></i>默认
                            </button>
                            <button class="layui-btn layui-btn-danger" data-event="reset" data-name="app"
                                    data-tip="抹去本程序所有数据?包括所建的网站等...">重置App
                            </button>
                        </div>
                    </div>
                </div>
                <div class="layui-tab-item layui-form">
                    {{.spiderHtml -}}
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
                <div class="layui-tab-item layui-form">
                    {{.banHtml -}}
                    <div class="layui-form-item">
                        <label class="layui-form-label"></label>
                        <div class="layui-btn-group">
                            <button class="layui-btn" lay-submit lay-filter="submit-ban">立即提交</button>
                            <button class="layui-btn layui-btn-danger" data-event="reset" data-name="ban"
                                    data-tip="违禁设置恢复到出厂设置?">
                                <i class="layui-icon iconfont icon-reset"></i>默认
                            </button>
                            <button class="layui-btn" data-event="ban-test">测试</button>
                            <button class="layui-btn layui-btn-small layui-btn-normal" data-event="edit-ban">编辑禁词
                            </button>
                            <button class="layui-btn" data-event="ban-update" lay-tips="远程更新禁词">更新禁词</button>
                        </div>
                    </div>
                </div>
                <div class="layui-tab-item layui-form">
                    <fieldset class="layui-elem-field">
                        <legend>定时设置</legend>
                        <div class="layui-form-item">
                            <div class="layui-inline">
                                <label class="layui-form-label">启用:</label>
                                <div class="layui-input-inline">
                                    <input type="checkbox" name="enabled"
                                           lay-skin="switch" lay-text="启用|关闭"{{if .monitor.Enabled}} checked{{end}}>
                                </div>
                            </div>
                            <div class="layui-inline">
                                <label class="layui-form-label">Spec:</label>
                                <div class="layui-input-inline" lay-tips="双击修改定时任务">
                                    <input type="text" name="spec" value="{{.monitor.Spec}}" class="layui-input">
                                </div>
                            </div>
                            <button class="layui-btn layui-btn-radius" data-event="monitor-log">查看监控日志</button>
                        </div>
                    </fieldset>
                    <fieldset class="layui-elem-field">
                        <legend>监控服务设置</legend>
                        <div class="layui-form-item">
                            <div id="monitor" style="text-align:center"></div>
                        </div>
                    </fieldset>
                    <div style="text-align: center">
                        <div class="layui-btn-group">
                            <button class="layui-btn" lay-submit lay-filter="submit-monitor">立即提交</button>
                            <button class="layui-btn layui-btn-danger" data-event="reset" data-name="monitor"
                                    data-tip="监控设置恢复到出厂设置?">
                                <i class="layui-icon iconfont icon-reset"></i>默认
                            </button>
                            <button class="layui-btn" data-event="status" data-name="monitor"
                                    data-tip="查看定时监控服务状态">查看状态
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
    layui.use(['index', 'main'], function () {
        let $ = layui.$,
            layer = layui.layer,
            main = layui.main,
            form = layui.form,
            transfer = layui.transfer;
        //显示
        transfer.render({
            id: 'monitorData',
            elem: '#monitor',
            title: ['全部服务', '监控服务'],
            data: {{.serviceData}},
            value: {{.serviceValue}},
            showSearch: true
        });
        form.on('submit(submit-base)', function (obj) {
            main.request({
                url: url + '/base',
                data: obj.field,
            });
            return false;
        });
        form.on('submit(submit-server)', function (obj) {
            main.request({
                url: url + '/server',
                data: obj.field,
            });
            return false;
        });
        form.on('submit(submit-monitor)', function (obj) {
            let monitorData = transfer.getData('monitorData');
            obj.field.services = [];
            layui.each(monitorData, function (i, v) {
                obj.field.services[i] = v.title;
            });
            obj.field.services = obj.field.services.join();
            main.request({
                url: url + '/monitor',
                data: obj.field,
                multiple: true,
            });
        });
        form.on('submit(submit-ban)', function (obj) {
            main.request({
                url: url + '/ban',
                data: obj.field,
            });
            return false;
        });
        form.on('submit(submit-data)', function (obj) {
            main.request({
                url: url + '/data',
                data: obj.field,
            });
            return false;
        });
        let active = {
            'ban-update': function () {
                main.request({url: url + '/ban/update'});
            },
            'status': function () {
                let name = this.data('name'),
                    tip = this.data('tip');
                if (name.length === 0) {
                    return false;
                }
                layer.confirm(tip, function (index) {
                    main.request({
                        url: url + '/status',
                        data: {name: name},
                        index: index,
                        done: function (res) {
                            main.msg(res.msg);
                            return false;
                        },
                    });
                });
            },
            'reset': function () {
                let name = this.data('name'),
                    tip = this.data('tip');
                if (name.length === 0) {
                    return false;
                }
                layer.confirm(tip, function (index) {
                    main.request({
                        url: url + '/reset',
                        data: {name: name},
                        index: index,
                        done: function () {
                            document.location.reload();
                        }
                    });
                });
            },
            'ban-test': function () {
                main.popup({
                    title: '测试违禁词',
                    url: url + '/ban/test',
                    area: '70%',
                    done: function (res) {
                        main.msg(`<textarea class="layui-textarea" name="content" rows="10">` + res.msg.replaceAll("<br/>", "\n") + `</textarea>`, {area: ['500px', 'auto']});
                        return false;
                    },
                    content: '<div class="layui-card"><div class="layui-card-body layui-form"><div class="layui-form-item"><textarea class="layui-textarea" name="content" rows="15" placeholder="输入需要检查的内容..."></textarea></div><div class="layui-hide"><button class="layui-btn" lay-submit lay-filter="submit"></button></div></div></div>'
                });
            },
            'edit-ban': function () {
                let loading = main.loading();
                $.get('/config/ban/data', function (html) {
                    loading.close();
                    main.popup({
                        title: '编辑禁词',
                        content: html,
                        url: '/config/ban/data'
                    });
                });
            },
            'monitor-log': function () {
                main.ws.log("monitor_service.0");
            }
        };
        $('[data-event]').on('click', function () {
            let othis = $(this),
                event = othis.data('event');
            active[event] && active[event].call(othis);
        });
        main.cron('[name=reboot_spec]', '[name=rank_spec]', '[name=spec]');
    });
</script>