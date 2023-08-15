<div class="layui-card">
    <div class="layui-card-body">
        <table id="table-list" lay-filter="table-list"></table>
    </div>
</div>
<script type="text/html" id="toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm" lay-event="add"><i class="layui-icon layui-icon-addition"></i>添加
        </button>
        <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="del">
            <i class="layui-icon layui-icon-delete"></i>删除
        </button>
    </div>
</script>
<script type="text/html" id="table-toolbar">
    <a class="layui-btn layui-btn-xs" lay-event="modify"><i class="layui-icon layui-icon-edit"></i>编辑</a>
    <a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del"><i class="layui-icon layui-icon-delete"></i>删除</a>
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let main = layui.main;
        main.table([[
            {type: 'checkbox', fixed: 'left'},
            {field: 'id', title: 'ID', width: 100, sort: true},
            {field: 'name', title: '名称', minWidth: 100},
            {field: 'deny', title: '拒绝广告', minWidth: 100},
            {field: 'durations', title: '允许时间段', hide: true},
            {field: 'cities', title: '屏蔽区域', hide: true},
            {field: 'allowed', title: '来路白名单', hide: true},
            {field: 'disallowed', title: '来路黑名单', hide: true},
            {
                field: 'updated', title: '更新时间', align: 'center', sort: true, templet: function (d) {
                    return main.timestampFormat(d['updated']);
                }
            },
            {title: '操作', width: 150, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
        ]], {
            modify: function (obj) {
                main.get(URL + '/modify', {id: obj.data.id}, function (html) {
                    main.popup({
                        url: URL + '/modify',
                        title: '修改过滤器',
                        content: html,
                        yes: function (index, dom) {
                            main.durations(dom)
                        },
                        done: "table-list",
                    });
                });
            },
            add: function () {
                main.get(URL + '/add', function (html) {
                    main.popup({
                        url: URL + '/add',
                        title: '添加过滤器',
                        content: html,
                        yes: function (index, dom) {
                            main.durations(dom)
                        },
                        done: "table-list",
                    });
                });
            }
        });
    });
</script>