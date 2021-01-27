<div class="layui-fluid" id="spider-tabs">
    <div class="layui-row">
        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-header layuiadmin-card-header-auto layui-form">
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <div class="layui-input-inline">
                                <input type="text" name="name" value="" class="layui-input" autocomplete="off"
                                       placeholder="模糊匹配名称">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label-col">状态:</label>
                        </div>
                        <div class="layui-inline">
                            <div class="layui-input-inline">
                                <select name="status" lay-filter="select_status">
                                    <option value="-1">全部</option>
                                    <option value="0">采集前</option>
                                    <option value="1">采集中</option>
                                    <option value="2">采集后</option>
                                </select>
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
<div class="layui-hide" id="import"></div>
<script type="text/html" id="import-form">
    <div class="layui-card">
        <div class="layui-card-body layui-form">
            <div class="layui-form-item">
                <label class="layui-form-label">保留绑定:</label>
                <div class="layui-input-inline">
                    <input type="checkbox" name="site_id" lay-skin="switch" lay-text="是|否">
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
            <button class="layui-btn layui-btn-sm" lay-event="addrule">
                <i class="layui-icon layui-icon-add-circle"></i>添加
            </button>
            <button class="layui-btn layui-btn-sm layui-btn-normal" lay-event="status">
                <i class="layui-icon layui-icon-star"></i>状态
            </button>
            <button class="layui-btn layui-btn-sm" lay-event="exec">
                <i class="layui-icon iconfont icon-spider"></i>采集
            </button>
        </div>
        <div class="layui-btn-group">
            <ul class="layui-nav layui-bg-green botadmin-nav">
                <li class="layui-nav-item">
                    <a href="javascript:" lay-tips="批量删除或清除" lay-direction="2" class="layui-bg-red">
                        <i class="layui-icon layui-icon-fonts-del"></i>
                        <cite>清除</cite>
                        <span class="layui-nav-more"></span>
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
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-fluid layui-btn-primary"
                                    lay-event="disable-page">关闭分页
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
                        <span class="layui-nav-more"></span>
                    </a>
                    <dl class="layui-nav-child">
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-fluid layui-btn-primary"
                                    lay-event="syncCron">
                                同步任务
                            </button>
                        </dd>
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-fluid"
                                    lay-event="jobs">查看任务
                            </button>
                        </dd>
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-fluid layui-bg-red"
                                    lay-event="cron-disable">关闭任务
                            </button>
                        </dd>
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-fluid"
                                    lay-event="cron-enable">启用任务
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
<script type="text/html" id="table-status">
    <div class="layui-card">
        <div class="layui-card-body layui-form">
            <div class="layui-form-item">
                <div class="layui-input-inline">
                    <select name="status">
                        <option value="0">采集前</option>
                        <option value="1">采集中</option>
                        <option value="2">采集后</option>
                    </select>
                </div>
                <button class="layui-hide" lay-submit lay-filter="subStatus"></button>
            </div>
        </div>
    </div>
</script>
{{template "JS" -}}
<script>
    let url = {{.current_uri}};
    JS.extend({step: 'step'}).use(['index', 'main'], function () {
        let form = layui.form,
            table = layui.table,
            upload = layui.upload,
            main = layui.main,
            url = {{.current_uri}},
            //渲染上传配置
            importConfig = upload.render({
                headers: {'X-CSRF-Token':{{.csrf_token}}},
                elem: '#import',
                url: {{.current_uri}} +'/import',
                accept: 'file',
                exts: 'txt|conf|json',
                before: function () {
                    layer.load(); //上传loading
                },
                done: function (res) {
                    layer.closeAll('loading'); //关闭loading
                    if (res.code === 0) {
                        layer.msg(res.msg);
                        table.reload('table-list');
                    } else {
                        layer.alert(res.msg, {icon: 2});
                    }
                },
            });
        table.render({
            headers: {'X-CSRF-Token':{{.csrf_token}}},
            method: 'post',
            elem: '#table-list',
            toolbar: '#toolbar',
            url: {{.current_uri}},
            cols: [[
                {type: 'checkbox', fixed: 'left'},
                {
                    field: 'cron_enabled', title: '定时任务', width: 100, align: 'center',
                    event: 'cron_switch', templet: function (d) {
                        return '<input type="checkbox" lay-skin="switch" lay-text="启用|关闭"' + (d.cron_enabled ? ' checked' : '') + '>';
                    }
                },
                {field: 'id', width: 80, title: 'ID', hide: true},
                {field: 'seeds', title: '种子', hide: true},
                {
                    field: 'name', title: '规则名称', width: 200,
                    event: 'modify', style: 'cursor:pointer;color:#01aaed;',
                },
                {
                    field: 'status', title: '状态', width: 100, align: 'center',
                    event: 'status', style: 'cursor:pointer;color:#01aaed;',
                    templet: function (d) {
                        let text = '采集前';
                        if (d.status === 1) {
                            text = "采集中";
                        } else if (d.status === 2) {
                            text = "采集后";
                        }
                        return text;
                    }
                },
                {
                    field: 'site_id', title: "绑定", sort: true,
                    event: 'site_id', style: 'cursor:pointer;color:#01aaed;', align: 'center',
                    templet: function (d) {
                        return d['vhost'] ? d['vhost'] : '未绑定';
                    }
                },
                {field: 'note', title: '备注', minWidth: 100},
                {field: 'updated', title: '时间', minWidth: 100, hide: true, sort: true},
                {title: '操作', width: 200, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
            ],],
            page: true,
            limit: 10,
            limits: [10, 15, 50, 100, 200, 1000],
            text: '对不起，加载出现异常！',
            done: function () {
                layui.element.render();
            }
        });
        table.on('tool(table-list)', function (obj) {
            let data = obj.data, othis = $(this);
            switch (obj.event) {
                case 'cron_switch':
                    let enabled = !!othis.find('div.layui-unselect.layui-form-onswitch').size();
                    main.req({
                        url: url + "/cron/switch",
                        data: {
                            id: data.id,
                            cron_enabled: enabled
                        },
                        error: function () {
                            othis.find('input[type=checkbox]').prop("checked", !enabled);
                            form.render('checkbox');
                            return false;
                        }
                    });
                    break;
                case 'del':
                    layer.confirm('确定删除此条日志？', function (index) {
                        main.req({
                            url: url + '/del',
                            data: {id: data.id},
                            index: index,
                            ending: obj.del,
                        });
                    });
                    break;
                case 'modify':
                    $.get(url + '/modify', {id: data.id}, function (html) {
                        main.popup({
                            title: '修改规则',
                            content: html,
                            url: url + '/modify',
                            submit: 'stepSubmit',
                            ending: 'table-list',
                        });
                    });
                    break;
                case 'copy':
                    layer.confirm('确定复制:' + data.name + '?', function (index) {
                        main.req({
                            url: url + '/copy',
                            data: {id: data.id},
                            index: index,
                            ending: 'table-list',
                        });
                    });
                    break;
                case 'exec':
                    layer.confirm('开始采集入库？', function (index) {
                        main.req({
                            url: url + '/exec',
                            data: {id: data.id, thread: 1},
                            index: index,
                            ending: 'table-list',
                        });
                    });
                    break;
                case 'status':
                    othis = $($('#table-status').html());
                    othis.find('div.layui-form:first').prepend('<input type="hidden" name="id" value="' + data.id + '">');
                    othis.find('select[name=status]:first>option[value=' + data.status + ']').attr("selected", true);
                    main.popup({
                        title: '修改状态',
                        content: othis.html(),
                        area: ['240px', '300px'],
                        url: url + '/status',
                        ending: function (res) {
                            obj.update({status: res.status});
                        },
                    });
                    break;
                case 'site_id':
                    $.get(url + '/bind', {'id': data.id}, function (html) {
                        main.popup({
                            title: '绑定网站',
                            content: html,
                            url: url + '/bind',
                            area: ['750px', '300px'],
                            ending: 'table-list',
                        });
                    });
                    break;
                case 'log':
                    $.get(url + '/log', {'id': data.id}, function (html) {
                        main.popup({
                            title: '日志',
                            content: html,
                            url: url + '/log',
                        });
                    });
                    break;
            }
        });
        table.on('toolbar(table-list)', function (obj) {
            let checkStatus = table.checkStatus(obj.config.id),
                data = checkStatus.data,
                ids = Array();
            layui.each(data, function (i, item) {
                ids[i] = item.id;
            });
            switch (obj.event) {
                case 'del':
                    if (ids.length === 0) {
                        return layer.msg('请选择数据');
                    }
                    layer.confirm('删除后不可恢复，确定删除吗？', function (index) {
                        main.req({
                            url: url + '/del',
                            data: {ids: ids.join()},
                            index: index,
                            ending: 'table-list',
                        });
                    });
                    break;
                case 'addrule':
                    $.get(url + '/add', {}, function (html) {
                        main.popup({
                            title: '添加规则',
                            content: html,
                            url: url + '/add',
                            submit: 'stepSubmit',
                            ending: 'table-list'
                        });
                    });
                    break;
                case 'status':
                    if (ids.length === 0) {
                        return layer.msg('请选择数据');
                    }
                    let othis = $($('#table-status').html());
                    othis.find('div.layui-form:first').prepend('<input type="hidden" name="ids" value="' + ids.join() + '">');
                    main.popup({
                        title: '修改状态',
                        content: othis.html(),
                        area: ['240px', '300px'],
                        url: url + '/status',
                        ending: 'table-list',
                    });
                    break;
                case 'exec':
                    if (ids.length === 0) {
                        return layer.msg('请选择数据');
                    }
                    layer.prompt({
                        formType: 0,
                        value: ids.length,
                        title: '采集入库:输入线程数,太多会卡死'
                    }, function (value, index) {
                        main.req({
                            url: url + '/exec',
                            data: {ids: ids.join(), thread: value},
                            index: index,
                            ending: 'table-list',
                        });
                    });
                    break;
                case 'recordDel':
                    layer.confirm('确定清空采集记录?清空后可导致重复采集', function (index) {
                        main.req({
                            url: url + '/record/del',
                            data: {ids: ids.join()},
                            index: index
                        });
                    });
                    break;
                case "disable-page":
                    layer.confirm('确定关闭选中规则的分页采集？', function (index) {
                        main.req({
                            url: url + '/disable/page',
                            data: {ids: ids.join()},
                            index: index,
                            ending: 'table-list',
                        });
                    });
                    break;
                case 'syncCron':
                    main.req({
                        url: url + '/sync/cron',
                        ending: 'table-list',
                    });
                    break;
                case 'jobs':
                    main.req({
                        url: url + '/jobs',
                        tips: function (res) {
                            main.msg(res.msg);
                        }
                    });
                    break;
                case 'cron-enable':
                    main.req({
                        url: url + '/cron/switch',
                        data: {ids: ids.join(), cron_enabled: true},
                        ending: 'table-list'
                    });
                    break;
                case 'cron-disable':
                    main.req({
                        url: url + '/cron/switch',
                        data: {ids: ids.join(), cron_enabled: false},
                        ending: 'table-list'
                    });
                    break;
                case 'export':
                    window.open(encodeURI('/spider/export?ids=' + ids.join()));
                    break;
                case 'import':
                    layer.open({
                        type: 1,
                        title: "导入配置",
                        btn: ['导入', '取消'],
                        shadeClose: true,
                        scrollbar: false,
                        shade: 0.8,
                        fixed: false,
                        maxmin: true,
                        btnAlign: 'c',
                        content: $('#import-form').html(),
                        yes: function (index, dom) {
                            dom.find('.layui-form button[lay-submit]button[lay-filter=submit-import]').click();
                            layer.close(index);
                        },
                        success: function () {
                            form.on('submit(submit-import)', function (obj) {
                                importConfig.reload({data: obj.field});
                                $('#import').click();
                                return false;
                            });
                        }
                    });
                    form.render();
                    break;
            }
        });
        //监控搜索
        form.on('submit(search)', function (obj) {
            table.reload('table-list', {
                where: obj.field,
                page: {curr: 1}
            });
            return false;
        })
        //监控选择site id
        form.on('select(select_site_id)', function () {
            $('button[lay-filter=search]').click();
            return false;
        });
        //监控选择状态
        form.on('select(select_status)', function () {
            $('button[lay-filter=search]').click();
            return false;
        });
    });
</script>
