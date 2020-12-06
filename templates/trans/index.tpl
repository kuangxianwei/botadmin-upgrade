<div class="layui-card">
    <div class="layui-card-header layuiadmin-card-header-auto layui-form">
        <div class="layui-form-item">
            <div class="layui-input-inline">
                {{if .hide -}}
                    <input type="text" name="token" placeholder="输入Token" autocomplete="off" class="layui-input">
                {{else -}}
                    <input type="text" name="app_id" placeholder="输入AppId" autocomplete="off" class="layui-input">
                {{end -}}
            </div>
            <div class="layui-input-inline">
                <select name="status" lay-filter="status">
                    <option value="">全部</option>
                    <option value="enabled">已启用</option>
                    <option value="disabled">未启用</option>
                </select>
            </div>
            <button class="layui-btn" data-type="reload" lay-submit lay-filter="search">
                <i class="layui-icon layui-icon-search layuiadmin-button-btn"></i>
            </button>
        </div>
    </div>
    <div class="layui-card-body">
        <table id="table-list" lay-filter="table-list"></table>
    </div>
</div>
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
<script src="/static/layui/layui.js?ver={{.version}}"></script>
<script>
    layui.config({
        base: '/static/' //静态资源所在路径
    }).extend({
        index: 'lib/index', //主入口模块
        main: 'main'//自定义请求模块
    }).use(['index', 'form', 'table', 'main'], function () {
        let $ = layui.$,
            form = layui.form,
            table = layui.table,
            main = layui.main,
            url = {{.current_uri}};
        //日志管理
        table.render({
            headers: {'X-CSRF-Token':{{.csrf_token}}},
            method: 'post',
            elem: '#table-list',
            toolbar: '#toolbar',
            url: {{.current_uri}},
            cols: [[
                {type: 'checkbox', fixed: 'left'},
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
                {field: 'delay', title: '延时', width: 100, align: 'center'},
                {field: 'updated', title: '时间', minWidth: 100, sort: true},
                {title: '操作', width: 150, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
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
                    layer.confirm('确定删除此条日志？', function (index) {
                        main.req({
                            url: url + "/del",
                            data: {'id': data.id},
                            index: index,
                            ending: obj.del
                        });
                    });
                    break;
                case 'modify':
                    $.get(url + '/modify', data, function (html) {
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
            }
        });

        //监听搜索
        form.on('submit(search)', function (data) {
            let field = data.field;
            //$("#form-search :input").val("").removeAttr("checked").remove("selected");
            //执行重载
            table.reload('table-list', {
                where: field,
                page: {curr: 1}
            });
            return false;
        });
        form.on('select(status)', function () {
            $('[lay-filter=search]').click();
        });
    });
</script>