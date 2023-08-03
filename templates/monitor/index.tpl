<div class="layui-card">
    <div class="layui-card-body">
        <div class="layui-form table-search" style="left: 450px">
            <button class="layui-hide" lay-submit lay-filter="search">
                <i class="layui-icon layui-icon-search"></i>
            </button>
            <div class="layui-inline">
                <div class="layui-input-inline">
                    <input type="text" autocomplete="off" name="addr" placeholder="输入目标地址" class="layui-input">
                </div>
            </div>
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
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm" lay-event="switch" data-field="enabled" data-value="true">
            <i class="layui-icon layui-icon-email"></i>启用
        </button>
        <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="switch" data-field="enabled">
            <i class="layui-icon layui-icon-email"></i>关闭
        </button>
    </div>
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm" lay-event="crontab" data-value="monitor." lay-tips="查看运行中的任务">
            <i class="layui-icon iconfont icon-work"></i>
        </button>
    </div>
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm layui-bg-red" lay-event="resetLog" lay-tips="重置日志">
            <i class="layui-icon iconfont icon-reset"></i>Log
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
        <button class="layui-btn layui-btn-xs layui-btn-primary" lay-event="log" lay-tips="查看日志">
            <i class="layui-icon layui-icon-log"></i>
        </button>
    </div>
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let main = layui.main,
            form = layui.form;
        main.table([[
            {type: 'checkbox', fixed: 'left'},
            {field: 'id', width: 80, title: 'ID', align: 'center', hide: true},
            {
                field: 'cron_enabled',
                title: '启用',
                align: 'center',
                width: 92,
                event: 'switch',
                templet: function (d) {
                    return '<input type="checkbox" lay-skin="switch" lay-text="是|否"' + (d.cron_enabled ? ' checked' : '') + '>';
                }
            },
            {field: 'addr', title: '目标地址', sort: true},
            {field: 'to', title: '邮箱'},
            {
                field: 'updated', title: '时间', align: 'center', sort: true, templet: function (d) {
                    return main.timestampFormat(d['updated']);
                }
            },
            {title: '操作', width: 160, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
        ]], {
            modify: function (obj) {
                main.get(url + '/modify', {id: obj.data.id}, function (html) {
                    main.popup({
                        title: '修改监控',
                        url: url + '/modify',
                        area: '600px',
                        content: html,
                        done: 'table-list',
                    });
                });
            },
            test: function (obj) {
                main.request({
                    url: url + '/test',
                    data: {id: obj.data.id}
                });
            },
            add: function () {
                main.get(url + '/add', function (html) {
                    main.popup({
                        title: '添加邮箱',
                        url: url + '/add',
                        area: '600px',
                        content: html,
                        done: 'table-list',
                    });
                });
            },
        });
    });
</script>