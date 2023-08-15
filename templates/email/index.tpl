<div class="layui-card-header layuiadmin-card-header-auto layui-form">
    <div class="layui-form-item">
        <div class="layui-input-inline">
            <input type="text" autocomplete="off" name="host" placeholder="输入服务器" class="layui-input">
        </div>
        <div class="layui-input-inline">
            <input type="text" autocomplete="off" name="username" placeholder="输入用户名"
                   class="layui-input">
        </div>
        <button class="layui-btn" data-type="reload" lay-submit lay-filter="search">
            <i class="layui-icon layui-icon-search layuiadmin-button-btn"></i>
        </button>
    </div>
</div>
<div class="layui-card">
    <div class="layui-card-body">
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
            {field: 'host', title: '服务器'},
            {field: 'username', title: '用户名'},
            {field: 'password', title: '密码', hide: true},
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