<div id="spider-tabs">
    <div class="layui-row">
        <div class="layui-col-md12">
            <div class="layui-card" lay-event="search">
                <div class="layui-card-header layuiadmin-card-header-auto layui-form">
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <div class="layui-input-inline">
                                <input type="text" autocomplete="off" name="ids" value="" class="layui-input" placeholder="IDS 多个用逗号分开">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <div class="layui-input-inline">
                                <input type="search" name="name" value="" class="layui-input" placeholder="模糊匹配名称">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label-col">绑定:</label>
                        </div>
                        <div class="layui-inline">
                            <div class="layui-input-inline">
                                <select name="site_id" lay-filter="select_site_id" lay-search>
                                    <option value="">搜索...</option>
                                    {{range .sites -}}
                                        <option value="{{.Id}}">{{.Vhost}}</option>
                                    {{end -}}
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <button class="layui-btn" lay-submit lay-filter="search">
                                <i class="layui-icon layui-icon-search layuiadmin-button-btn"></i>
                            </button>
                        </div>
                    </div>
                </div>
                <div class="layui-card-body">
                    <table id="table-list" lay-filter="table-list"></table>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/html" id="import-form">
    <div class="layui-card">
        <div class="layui-card-body layui-form">
            <div class="layui-form-item">
                <label for="site_id" class="layui-form-label">保留绑定:</label>
                <div class="layui-input-inline">
                    <input type="checkbox" name="site_id" id="site_id" lay-skin="switch" lay-text="是|否">
                </div>
            </div>
            <div class="layui-form-item layui-hide">
                <button lay-submit lay-filter="submit-import"></button>
            </div>
        </div>
    </div>
</script>
<script type="text/html" id="toolbar">
    <div class="layui-btn-container">
        <div class="layui-btn-group">
            <button class="layui-btn layui-btn-sm" lay-event="addRule">
                <i class="layui-icon layui-icon-add-circle"></i>添加
            </button>
            <button class="layui-btn layui-btn-sm" lay-event="exec">
                <i class="layui-icon iconfont icon-spider"></i>采集
            </button>
            <button class="layui-btn layui-btn-sm layui-btn-normal" lay-event="configure" lay-tips="批量配置">
                <i class="layui-icon layui-icon-set"></i>
            </button>
        </div>
        <div class="layui-btn-group">
            <ul class="layui-nav layui-bg-green botadmin-nav">
                <li class="layui-nav-item">
                    <a href="javascript:" lay-tips="批量删除或清除" lay-direction="2" class="layui-bg-red">
                        <i class="layui-icon layui-icon-fonts-del"></i>
                        <cite>清除</cite>
                    </a>
                    <dl class="layui-nav-child">
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-fluid layui-btn-primary" lay-event="del">
                                删除规则
                            </button>
                        </dd>
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-fluid layui-btn-primary"
                                    lay-event="recordDel">清除记录
                            </button>
                        </dd>
                    </dl>
                </li>
            </ul>
        </div>
        <div class="layui-btn-group">
            <ul class="layui-nav layui-bg-green botadmin-nav">
                <li class="layui-nav-item">
                    <a href="javascript:" lay-tips="定时采集任务" lay-direction="2">
                        <i class="layui-icon iconfont icon-work"></i>
                        <cite>任务</cite>
                    </a>
                    <dl class="layui-nav-child">
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-fluid" lay-event="crontab" data-value="spider.">
                                查看任务
                            </button>
                        </dd>
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-fluid layui-bg-red" lay-event="switch" data-field="cron_enabled">
                                关闭任务
                            </button>
                        </dd>
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-fluid" lay-event="switch" data-field="cron_enabled" data-value="true">
                                启用任务
                            </button>
                        </dd>
                    </dl>
                </li>
            </ul>
        </div>
        <div class="layui-btn-group">
            <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="export" lay-tips="导出配置">
                <i class="layui-icon iconfont icon-export"></i>
            </button>
            <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="import" lay-tips="导入配置">
                <i class="layui-icon iconfont icon-import"></i>
            </button>
        </div>
        <div class="layui-btn-group">
            <button class="layui-btn layui-btn-sm" lay-event="log" lay-tips="查看日志">
                <i class="layui-icon layui-icon-log"></i>
            </button>
            <button class="layui-btn layui-btn-sm layui-bg-orange" lay-event="resetLog" lay-tips="重置日志">
                <i class="layui-icon iconfont icon-reset"></i>Log
            </button>
            <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="truncate" lay-tips="清空所有的数据，不可恢复！">
                清空
            </button>
        </div>
    </div>
</script>
<script type="text/html" id="table-toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-xs" lay-event="exec" lay-tips="开始采集">
            <i class="layui-icon iconfont icon-spider"></i>
        </button>
        <button class="layui-btn layui-btn-xs" lay-event="log" lay-tips="查看日志">
            <i class="layui-icon layui-icon-log"></i></button>
    </div>
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-xs" lay-event="copy" lay-tips="复制规则">
            <i class="layui-icon iconfont icon-copy"></i>
        </button>
        <button class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del">
            <i class="layui-icon layui-icon-delete"></i>
        </button>
    </div>
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.extend({steps: 'steps'}).use(['index', 'main', 'steps'], function () {
        let form = layui.form,
            table = layui.table,
            main = layui.main;
        //渲染上传配置
        let reupload = main.upload();
        main.table({
            cols: [[
                {type: 'checkbox', fixed: 'left'},
                {field: 'id', width: 80, title: 'ID'},
                {
                    field: 'cron_enabled', title: '定时任务', width: 100, align: 'center',
                    event: 'switch', templet: function (d) {
                        return '<input type="checkbox" name="cron_switch" lay-skin="switch" lay-text="启用|关闭"' + (d.cron_enabled ? ' checked' : '') + '>';
                    }
                },
                {field: 'seeds', title: '种子', hide: true},
                {
                    field: 'name', title: '规则名称', width: 200,
                    event: 'modify', style: 'cursor:pointer;color:#01aaed;',
                },
                {
                    field: 'site_id', title: "绑定", sort: true,
                    event: 'site_id', style: 'cursor:pointer;color:#01aaed;', align: 'center',
                    templet: function (d) {
                        return d['vhost'] ? d['vhost'] : '未绑定';
                    }
                },
                {field: 'note', title: '备注', minWidth: 100},
                {
                    field: 'updated', title: '时间', minWidth: 100, hide: true, sort: true, templet: function (d) {
                        return main.timestampFormat(d['updated']);
                    }
                },
                {title: '操作', width: 200, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
            ]],
            done: function () {
                layui.element.render();
            }
        }, {
            modify: function (obj) {
                layui.steps({url: URL + '/modify', data: {id: obj.data.id}});
            },
            copy: function (obj) {
                layer.confirm('确定复制:' + obj.data.name + '?', function (index) {
                    main.request({
                        url: URL + '/copy',
                        data: {id: obj.data.id},
                        index: index,
                        done: 'table-list',
                    });
                });
            },
            site_id: function (obj) {

                main.get(URL + '/bind', {id: obj.data.id}, function (html) {

                    main.popup({
                        title: '绑定网站',
                        content: html,
                        url: URL + '/bind',
                        area: ['720px', '300px'],
                        done: 'table-list',
                    });
                });
            },
            addRule: function () {
                layui.steps({url: URL + '/add'});
            },
            configure: function (obj, ids) {
                if (ids.length === 0) {
                    return main.error('请选择数据');
                }

                main.get(URL + '/configure', {ids: ids.join()}, function (html) {

                    main.popup({
                        title: '批量修改配置',
                        content: html,
                        url: URL + '/configure',
                        done: 'table-list',
                    });
                });
            },
            exec: function (obj, ids) {
                if (main.isArray(ids)) {
                    if (ids.length === 0) {
                        return main.error('请选择数据');
                    }
                    main.request({
                        url: URL + '/exec',
                        data: {ids: ids.join()},
                        done: 'table-list',
                    });
                    return
                }
                layer.confirm('开始采集入库？', function (index) {
                    main.request({
                        url: URL + '/exec',
                        data: {id: obj.data.id},
                        done: function () {
                            main.ws.log("spider." + obj.data.id, function () {
                                table.reload('table-list');
                            });
                            return false;
                        },
                        index: index,
                    });
                });
            },
            recordDel: function (obj, ids) {
                layer.confirm('确定清空采集记录?清空后可导致重复采集', function (index) {
                    main.request({
                        url: URL + '/record/del',
                        data: {ids: ids.join()},
                        index: index
                    });
                });
            },
            import: function () {
                layer.confirm('是否绑定网站ID？有可能网站ID不存在则会停止导入', {
                    title: false,
                    btn: ['绑定', '不绑定'] //按钮
                }, function (index) {
                    reupload.config.data = {site_id: true};
                    $('#upload').click();
                    layer.close(index)
                }, function (index) {
                    reupload.config.data = {site_id: false};
                    $('#upload').click();
                    layer.close(index)
                });
            },
        });
        //监控选择site id
        form.on('select(select_site_id)', function () {
            $('button[lay-filter=search]').click();
            return false;
        });
    });
</script>