<div class="layui-card">
    <div class="layui-card-header layuiadmin-card-header-auto layui-form">
        <div class="layui-form-item">
            <div class="layui-input-inline">
                <input type="text" autocomplete="off" name="username" placeholder="输入用户名" class="layui-input">
            </div>
            <div class="layui-input-inline">
                <input type="text" autocomplete="off" name="status" placeholder="输入状态" class="layui-input">
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
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="del">
            <i class="layui-icon layui-icon-delete"></i>删除
        </button>
    </div>
</script>
<script type="text/html" id="table-toolbar">
    <a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del"><i
                class="layui-icon layui-icon-delete"></i>删除</a>
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let main = layui.main;
        main.table([[
            {type: 'checkbox', fixed: 'left'},
            {field: 'id', hide: true},
            {type: 'numbers', width: 80, title: 'ID', sort: true},
            {field: 'username', title: '用户名', minWidth: 100},
            {field: 'password', title: '密码', minWidth: 100},
            {field: 'ip', title: 'IP', minWidth: 100},
            {field: 'status', title: '状态', minWidth: 100},
            {
                field: 'updated', title: '时间', minWidth: 100, sort: true, templet: function (d) {
                    return main.timestampFormat(d['updated']);
                }
            },
            {title: '操作', width: 150, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
        ]]);
    });
</script>