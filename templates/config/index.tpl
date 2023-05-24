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
                            <label for="username" class="layui-form-label">用户名:</label>
                            <div class="layui-input-block">
                                <input type="text" autocomplete="off" name="username" id="username" value="{{.base.Username}}" class="layui-input" placeholder="用户名">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label for="addr" class="layui-form-label">Host:</label>
                            <div class="layui-input-block">
                                <input type="text" autocomplete="off" name="addr" id="addr" value="{{.base.Addr}}" class="layui-input" placeholder="localhost">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label for="port" class="layui-form-label">端口:</label>
                            <div class="layui-input-block">
                                <input type="number" autocomplete="off" name="port" id="port" value="{{.base.Port}}" class="layui-input" placeholder="8080">
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">运行模式:</label>
                            <div class="layui-input-block">
                                <input type="radio" name="run_mode" value="prod" title="正常"{{if eq .base.RunMode "prod"}} checked{{end}}>
                                <input type="radio" name="run_mode" value="dev" title="调试"{{if eq .base.RunMode "dev"}} checked{{end}}>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label for="gzip_enabled" class="layui-form-label">Gzip:</label>
                            <div class="layui-input-block">
                                <input type="checkbox" name="gzip_enabled" id="gzip_enabled" lay-skin="switch" lay-text="打开|关闭"{{if .base.GzipEnabled}} checked{{end}}>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label for="csrf_enabled" class="layui-form-label">CSRF:</label>
                            <div class="layui-input-block">
                                <input type="checkbox" name="csrf_enabled" id="csrf_enabled" lay-skin="switch" lay-text="打开|关闭"{{if .base.CsrfEnabled}} checked{{end}}>
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label for="record_level" class="layui-form-label">日志级别:</label>
                            <div class="layui-input-inline">
                                <select name="record_level" id="record_level" class="layui-select">
                                    {{range $i,$v:=.record_levels -}}
                                        <option value="{{$i}}"{{if eq $.base.RecordLevel $i}} selected{{end}}>{{$v.Name}}</option>
                                    {{end -}}
                                </select>
                            </div>
                            <div class="layui-form-mid layui-word-aux">重启App后生效</div>
                        </div>
                        <div class="layui-inline">
                            <label for="ad_cache" class="layui-form-label">广告缓存:</label>
                            <div class="layui-input-inline">
                                <input type="number" autocomplete="off" name="ad_cache" id="ad_cache" value="{{.base.AdCache}}" min="0" class="layui-input">
                            </div>
                            <div class="layui-form-mid layui-word-aux">缓存过期时间(单位秒)</div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="pprof" class="layui-form-label" lay-tips="开启性能监测">Pprof:</label>
                        <div class="layui-input-inline">
                            <input type="checkbox" name="pprof" id="pprof" lay-skin="switch" lay-text="打开|关闭"{{if .base.Pprof}} checked{{end}}>
                        </div>
                        <div class="layui-form-mid layui-word-aux">
                            仅调试启用(开发人员<a lay-href="/debug/pprof" lay-text="pprof">查看性能</a>)
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="limit_login" class="layui-form-label">登录限制:</label>
                        <div class="layui-input-inline">
                            <input type="text" autocomplete="off" name="limit_login" id="limit_login" value="{{.base.LimitLogin}}" class="layui-input">
                        </div>
                        <div class="layui-form-mid layui-word-aux">登录错误次数超过将限制N分钟后登录 0为不限制录</div>
                    </div>
                    <div class="layui-form-item layui-row">
                        <div class="layui-col-md5">
                            <label for="csrf_secret" class="layui-form-label">csrf秘钥:</label>
                            <div class="layui-input-block">
                                <input type="text" autocomplete="off" name="csrf_secret" id="csrf_secret" value="{{.base.CsrfSecret}}" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-col-md5">
                            <label for="php_my_admin_name" class="layui-form-label">PhpMyAdmin:</label>
                            <div class="layui-input-block">
                                <input type="text" autocomplete="off" name="php_my_admin_name" id="php_my_admin_name" value="{{.base.PhpMyAdminName}}" class="layui-input">
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item layui-row">
                        <div class="layui-col-md5">
                            <label for="rank_spec" class="layui-form-label">定时排名:</label>
                            <div class="layui-input-block" lay-tips="双击修改定时任务">
                                <input type="text" autocomplete="off" name="rank_spec" id="rank_spec" value="{{.base.RankSpec}}" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-col-md5">
                            <label for="reboot_spec" class="layui-form-label">定时重启:</label>
                            <div class="layui-input-block">
                                <input type="text" autocomplete="off" name="reboot_spec" id="reboot_spec" value="{{.base.RebootSpec}}"
                                       class="layui-input">
                            </div>
                        </div>
                    </div>
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
                    <div class="layui-form-item">
                        <label for="nginx_path" class="layui-form-label">Nginx路径:</label>
                        <div class="layui-input-block">
                            <input id="nginx_path" type="text" name="nginx_path" value="{{.server.NginxPath}}" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="nginx_conf_path" class="layui-form-label">配置路径:</label>
                        <div class="layui-input-block">
                            <input id="nginx_conf_path" type="text" name="nginx_conf_path" value="{{.server.NginxConfPath}}" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="rewrite_path" class="layui-form-label">伪静态目录:</label>
                        <div class="layui-input-block">
                            <input id="rewrite_path" type="text" name="rewrite_path" value="{{.server.RewritePath}}" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-form-item"><label for="ssl_path" class="layui-form-label">Ssl目录:</label>
                        <div class="layui-input-block">
                            <input id="ssl_path" type="text" name="ssl_path" value="{{.server.SslPath}}" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="mysql_ini" class="layui-form-label">MySQL配置:</label>
                        <div class="layui-input-block">
                            <input id="mysql_ini" type="text" name="mysql_ini" value="{{.server.MysqlIni}}" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="php_ini" class="layui-form-label">PHP配置:</label>
                        <div class="layui-input-block">
                            <input id="php_ini" type="text" name="php_ini" value="{{.server.PhpIni}}" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="probe_name" class="layui-form-label">探针名称:</label>
                        <div class="layui-input-block">
                            <input id="probe_name" type="text" name="probe_name" value="{{.server.ProbeName}}" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label"></label>
                        <div class="layui-btn-group">
                            <button class="layui-btn" lay-submit lay-filter="submit-server">立即提交</button>
                            <button class="layui-btn" data-event="reset" data-name="server" data-tip="Server 恢复出厂设置?">
                                <i class="layui-icon iconfont icon-reset"></i>默认
                            </button>
                            <button class="layui-btn layui-btn-danger" data-event="reset" data-name="app" data-tip="抹去本程序所有数据?包括所建的网站等...">
                                重置App
                            </button>
                        </div>
                    </div>
                </div>
                <div class="layui-tab-item layui-form">
                    <div class="layui-form-item">
                        <label for="password" class="layui-form-label">密码:</label>
                        <div class="layui-input-inline">
                            <input id="password" type="text" name="password" value="{{.spider.Password}}" class="layui-input">
                        </div>
                        <div class="layui-form-mid layui-word-aux">保存文章的数据库密码 不可超过15个字符</div>
                    </div>
                    <div class="layui-form-item">
                        <label for="order" class="layui-form-label">采集顺序:</label>
                        <div class="layui-input-inline">
                            <select name="order" id="order" class="layui-select">
                                <option value="0"{{if eq .spider.Order 0}} selected{{end}}>正序</option>
                                <option value="1"{{if eq .spider.Order 1}} selected{{end}}>倒序</option>
                                <option value="2"{{if eq .spider.Order 2}} selected{{end}}>URL升序</option>
                                <option value="3"{{if eq .spider.Order 3}} selected{{end}}>URL降序</option>
                            </select>
                        </div>
                        <div class="layui-form-mid layui-word-aux">采集入库顺序 默认为先采集先入库</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label" for="user_agent">模拟仿真:</label>
                        <div class="layui-input-inline">
                            <select name="user_agent" id="user_agent" class="layui-select">
                                {{range $k,$v:=.userAgents }}
                                    <option value="{{$v.Value}}"{{if eq $.spider.UserAgent $v.Value}} selected{{end}}>{{$v.Alias}}</option>
                                {{end}}
                            </select>
                        </div>
                        <div class="layui-form-mid layui-word-aux">模拟浏览器行为</div>
                    </div>
                    <div class="layui-form-item">
                        <label for="delay" class="layui-form-label">间隔:</label>
                        <div class="layui-input-inline">
                            <input id="delay" type="text" name="delay" value="{{.spider.Delay}}" class="layui-input">
                        </div>
                        <div class="layui-form-mid layui-word-aux">随机间隔时间范围</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">原创率:</label>
                        <div class="layui-input-block">
                            <input type="radio" name="originality" value="0" title="不检验"{{if eq .spider.Originality 0}} checked{{end}}>
                            <input type="radio" name="originality" value="1" title="未检验"{{if eq .spider.Originality 1}} checked{{end}}>
                            <input type="radio" name="originality" value="2" title="已检验"{{if eq .spider.Originality 2}} checked{{end}}>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="tag_enabled" class="layui-form-label">Tags:</label>
                        <div class="layui-input-inline">
                            <input type="checkbox" id="tag_enabled" name="tag_enabled" lay-skin="switch" lay-text="打开|关闭"{{if .spider.TagEnabled}} checked{{end}}>
                        </div>
                        <div class="layui-form-mid layui-word-aux">启用获取tags</div>
                    </div>
                    <div class="layui-form-item">
                        <label for="correct_enabled" class="layui-form-label">纠错:</label>
                        <div class="layui-input-inline">
                            <input type="checkbox" id="correct_enabled" name="correct_enabled" lay-skin="switch" lay-text="打开|关闭"{{if .spider.CorrectEnabled}} checked{{end}}>
                        </div>
                        <div class="layui-form-mid layui-word-aux">启用纠错功能</div>
                    </div>
                    <div class="layui-form-item">
                        <label for="description_enabled" class="layui-form-label">简介:</label>
                        <div class="layui-input-inline">
                            <input type="checkbox" id="description_enabled" name="description_enabled" lay-skin="switch" lay-text="打开|关闭"{{if .spider.DescriptionEnabled}} checked{{end}}>
                        </div>
                        <div class="layui-form-mid layui-word-aux">启用提取简介功能</div>
                    </div>
                    <div class="layui-form-item">
                        <label for="app_id" class="layui-form-label">应用ID:</label>
                        <div class="layui-input-block">
                            <input id="app_id" type="text" name="app_id" value="{{.spider.AppId}}" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="api_key" class="layui-form-label">ApiKey:</label>
                        <div class="layui-input-block">
                            <input id="api_key" type="text" name="api_key" value="{{.spider.ApiKey}}" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="secret" class="layui-form-label">秘钥:</label>
                        <div class="layui-input-block">
                            <input id="secret" type="text" name="secret" value="" class="layui-input">
                        </div>
                    </div>
                    <input type="hidden" name="token" value="{{.spider.Token}}">
                    <div class="layui-form-item">
                        <label class="layui-form-label"></label>
                        <div class="layui-btn-group">
                            <button class="layui-btn" lay-submit lay-filter="submit-data">立即提交</button>
                            <button class="layui-btn layui-btn-danger" data-event="reset" data-name="data" data-tip="清空所有已经采集的数据?不可恢复!">
                                清空采集数据
                            </button>
                        </div>
                    </div>
                </div>
                <div class="layui-tab-item layui-form">
                    <div class="layui-form-item">
                        <label for="ban_tag_enabled" class="layui-form-label">Tags:</label>
                        <div class="layui-input-inline">
                            <input type="checkbox" id="ban_tag_enabled" name="tag_enabled" lay-skin="switch" lay-text="打开|关闭" title="打开|关闭"{{if .ban.TagEnabled}} checked{{end}}>
                        </div>
                        <div class="layui-form-mid layui-word-aux">启用获取tags</div>
                    </div>
                    <div class="layui-form-item">
                        <label for="ban_app_id" class="layui-form-label">应用ID:</label>
                        <div class="layui-input-block">
                            <input id="ban_app_id" type="text" name="app_id" value="{{.ban.AppId}}" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="ban_api_key" class="layui-form-label">ApiKey:</label>
                        <div class="layui-input-block">
                            <input id="ban_api_key" type="text" name="api_key" value="{{.ban.ApiKey}}" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label for="ban_secret" class="layui-form-label">秘钥:</label>
                        <div class="layui-input-block">
                            <input id="ban_secret" type="text" name="secret" value="{{.ban.Secret}}" class="layui-input">
                        </div>
                    </div>
                    <input type="hidden" name="token" value="{{.ban.Token}}">
                    <div class="layui-form-item">
                        <label class="layui-form-label">过滤模式:</label>
                        <div class="layui-input-block">
                            <input type="radio" name="mode" value="0" title="离线"{{if eq .ban.Mode 0}} checked{{end}}>
                            <input type="radio" name="mode" value="1" title="在线"{{if eq .ban.Mode 1}} checked{{end}}>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label"></label>
                        <div class="layui-btn-group">
                            <button class="layui-btn" lay-submit lay-filter="submit-ban">立即提交</button>
                            <button class="layui-btn layui-btn-danger" data-event="reset" data-name="ban" data-tip="违禁设置恢复到出厂设置?">
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
                                <label for="enabled" class="layui-form-label">启用:</label>
                                <div class="layui-input-inline">
                                    <input type="checkbox" name="enabled" id="enabled" lay-skin="switch" lay-text="启用|关闭"{{if .monitor.Enabled}} checked{{end}}>
                                </div>
                            </div>
                            <div class="layui-inline">
                                <label for="spec" class="layui-form-label">Spec:</label>
                                <div class="layui-input-inline" lay-tips="双击修改定时任务">
                                    <input type="text" autocomplete="off" name="spec" id="spec" value="{{.monitor.Spec}}" class="layui-input">
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
                            <button class="layui-btn" data-crontab="monitor_service" lay-tips="查看定时监控服务状态">
                                查看状态
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
            reset: function () {
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

                main.get('/config/ban/data', function (html) {

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