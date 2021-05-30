<div class="layui-card">
    <div class="layui-card-body">
        <div class="layui-form table-search" style="left: 380px">
            <button class="layui-hide" lay-submit lay-filter="search">
                <i class="layui-icon layui-icon-search"></i>
            </button>
            <div class="layui-inline">
                <div class="layui-input-inline">
                    <select name="status" lay-filter="search-select" class="layui-select">
                        <option value="">全部</option>
                        <option value="enabled">已启用</option>
                        <option value="disabled">未启用</option>
                    </select>
                </div>
            </div>
        </div>
        <table id="table-list" lay-filter="table-list"></table>
    </div>
</div>
<div class="layui-hide" id="import"></div>
<script type="text/html" id="toolbar">
    <div class="layui-btn-container">
        <div class="layui-btn-group">
            <button class="layui-btn layui-btn-sm" lay-event="add">
                <i class="layui-icon layui-icon-add-circle"></i>
            </button>
            <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="del">
                <i class="layui-icon layui-icon-delete"></i>
            </button>
        </div>
        <div class="layui-btn-group">
            <button class="layui-btn layui-btn-sm" lay-event="enabled">开启</button>
            <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="disabled">关闭</button>
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
            <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="log" lay-tips="查看日志">
                <i class="layui-icon layui-icon-log"></i>
            </button>
        </div>
    </div>
</script>
<script type="text/html" id="table-toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-xs" lay-event="modify">
            <i class="layui-icon layui-icon-edit"></i></button>
        <button class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del">
            <i class="layui-icon layui-icon-delete"></i>
        </button>
    </div>
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let form = layui.form,
            table = layui.table,
            main = layui.main,
            url = {{.current_uri}};
        //渲染上传配置
        layui.upload.render({
            headers: {'X-CSRF-Token':{{.csrf_token}}},
            elem: '#import',
            url: '/trans/import',
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
        //日志管理
        table.render({
            headers: {'X-CSRF-Token':{{.csrf_token}}},
            method: 'post',
            elem: '#table-list',
            toolbar: '#toolbar',
            url: {{.current_uri}},
            cols: [[
                {type: 'checkbox', fixed: 'left'},
                {field: 'engine', title: '引擎', hide: true},
                {field: 'id', title: 'ID', width: 80, align: 'center', sort: true},
                {
                    field: 'enabled', title: '启用', width: 100, align: 'center',
                    event: 'enabled', templet: function (d) {
                        return '<input type="checkbox" lay-skin="switch" lay-text="启用|关闭"' + (d.enabled ? ' checked' : '') + '>';
                    }
                },
                {{if not .hide -}}
                {field: 'app_id', title: 'AppId', minWidth: 100, align: 'center', sort: true},
                {{end -}}
                {field: 'token', title: 'Token', minWidth: 100},
                {field: 'delay', title: '延时', width: 100, align: 'center', hide: true},
                {
                    field: 'created', title: '创建时间', width: 160, align: 'center', sort: true, templet: function (d) {
                        return main.timestampFormat(d['created']);
                    }
                },
                {title: '操作', width: 120, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
            ],],
            page: true,
            limit: 10,
            limits: [10, 30, 100, 500, 1000],
            text: '对不起，加载出现异常！'
        });
        //监听工具条
        table.on('tool(table-list)', function (obj) {
            let data = obj.data;
            switch (obj.event) {
                case 'enabled':
                    let othis = $(this),
                        enabled = !!othis.find('div.layui-unselect.layui-form-onswitch').size();
                    main.req({
                        url: url + "/switch",
                        data: {
                            id: data.id,
                            enabled: enabled
                        },
                        error: function () {
                            if (enabled) {
                                othis.find('div.layui-unselect.layui-form-switch').removeClass('layui-form-onswitch');
                            } else {
                                othis.find('div.layui-unselect.layui-form-switch').addClass('layui-form-onswitch');
                            }
                        }
                    });
                    break;
                case 'del':
                    layer.confirm('确定删除此条配置？', function (index) {
                        main.req({
                            url: url + "/del",
                            data: {'id': data.id},
                            index: index,
                            ending: obj.del
                        });
                    });
                    break;
                case 'modify':
                    $.get(url + '/modify', {id: data.id}, function (html) {
                        main.popup({
                            title: '修改翻译配置',
                            url: url + '/modify',
                            area: ['70%', '90%'],
                            content: html,
                            ending: 'table-list',
                        });
                    });
                    break;
            }
        });

        //头工具栏事件
        table.on('toolbar(table-list)', function (obj) {
            let data = table.checkStatus(obj.config.id).data,
                ids = [];
            layui.each(data, function (i, v) {
                ids[i] = v.id;
            });
            switch (obj.event) {
                case 'add':
                    $.get(url + '/add', {}, function (html) {
                        main.popup({
                            title: '添加翻译配置',
                            url: url + '/add',
                            area: ['70%', '80%'],
                            content: html,
                            ending: 'table-list',
                        });
                    });
                    break;
                case 'del':
                    if (ids.length === 0) {
                        layer.msg("未选中", {icon: 2});
                        return false;
                    }
                    layer.confirm('删除后不可恢复，确定删除吗？', function (index) {
                        main.req({
                            url: url + '/del',
                            data: {ids: ids.join()},
                            index: index,
                            ending: 'table-list'
                        });
                    });
                    break;
                case 'enabled':
                    if (ids.length === 0) {
                        layer.msg("未选中", {icon: 2});
                        return false;
                    }
                    main.req({
                        url: url + '/switch',
                        data: {ids: ids.join(), enabled: true},
                        ending: 'table-list'
                    });
                    break;
                case 'disabled':
                    if (ids.length === 0) {
                        layer.msg("未选中", {icon: 2});
                        return false;
                    }
                    main.req({
                        url: url + '/switch',
                        data: {ids: ids.join(), enabled: false},
                        ending: 'table-list'
                    });
                    break;
                case 'export':
                    if (ids.length === 0) {
                        layer.msg("未选中", {icon: 2});
                        return false;
                    }
                    window.open(encodeURI('/trans/export?engine=' + data[0].engine + '&ids=' + ids.join()));
                    break;
                case 'import':
                    $('#import').click();
                    break;
                case 'log':
                    main.ws.log("trans." + data.engine + ".0");
                    break;
            }
        });
        // 监听搜索
        main.onSearch();
    });
</script>
