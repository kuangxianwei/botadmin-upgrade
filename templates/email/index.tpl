<div class="layui-card">
    <div class="layui-card-body">
        <div class="layui-form table-search" style="left: 200px">
            <div class="layui-input-inline">
                <input type="text" name="search" placeholder="输入搜索" class="layui-input">
            </div>
            <button class="layui-hide" lay-submit lay-filter="search">
                <i class="layui-icon layui-icon-search"></i>
            </button>
        </div>
        <table id="table-list" lay-filter="table-list"></table>
    </div>
</div>
<script type="text/html" id="toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm" lay-event="add">
            <i class="layui-icon layui-icon-add-1"></i>添加
        </button>
        <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="del">
            <i class="layui-icon layui-icon-delete"></i>删除
        </button>
    </div>
</script>
<script type="text/html" id="table-toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-xs" lay-event="modify">
            <i class="layui-icon layui-icon-edit"></i>
        </button>
        <button class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del">
            <i class="layui-icon layui-icon-delete"></i>
        </button>
        <button class="layui-btn layui-btn-xs" lay-event="test">测试</button>
    </div>
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let main = layui.main;
        main.table([[
            {type: 'checkbox', fixed: 'left'},
            {field: 'id', width: 80, title: 'ID', align: 'center', sort: true},
            {
                field: 'enabled', title: '启用/禁用', width: 100, align: 'center',
                event: 'switch', templet: function (d) {
                    return '<input type="checkbox" name="enabled" lay-skin="switch" lay-text="启用|禁用"' + (d.enabled ? ' checked' : '') + '>';
                }
            },
            {field: 'host', title: '服务器'},
            {field: 'username', title: '用户名'},
            {field: 'password', title: '密码', hide: true},
            {field: 'alias', title: '别名', hide: true},
            {field: 'to', title: '接收者'},
            {
                field: 'updated', title: '时间', align: 'center', sort: true, templet: function (d) {
                    return main.timestampFormat(d['updated']);
                }
            },
            {title: '操作', width: 120, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
        ]], {
            modify: function (obj) {
                main.get(URL + '/modify', obj.data, function (html) {
                    main.popup({
                        title: '修改邮箱配置',
                        url: URL + '/modify',
                        area: '500px',
                        content: html,
                        done: 'table-list',
                    })
                })
            },
            test: function (obj) {
                layer.confirm('测试本配置有效果', function (index) {
                    main.request({
                        url: URL + '/test',
                        data: obj.data,
                        index: index
                    });
                });
            },
            add: function () {
                main.get(URL + '/add', function (html) {
                    main.popup({
                        title: '添加邮箱',
                        url: URL + '/add',
                        area: '500px',
                        content: html,
                        done: 'table-list',
                    });
                })
            },
        });
    });
</script>