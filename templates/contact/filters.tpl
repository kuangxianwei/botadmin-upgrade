<div class="layui-card">
    <div class="layui-card-body">
        <table id="table-list" lay-filter="table-list"></table>
    </div>
</div>
<script type="text/html" id="toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm" lay-event="add"><i class="layui-icon layui-icon-addition"></i>添加</button>
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
        let table = layui.table, main = layui.main;

        //日志管理
        table.render({
            headers: {'X-CSRF-Token': csrfToken},
            method: 'post',
            elem: '#table-list',
            toolbar: '#toolbar',
            url: url,
            cols: [[
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
            ],],
            page: true,
            limit: 10,
            limits: [10, 15, 20, 25, 30],
            text: '对不起，加载出现异常！'
        });
        //监听工具条
        table.on('tool(table-list)', function (obj) {
            let data = obj.data;
            switch (obj.event) {
                case 'del':
                    layer.confirm('确定删除此条日志？', function (index) {
                        main.request({
                            url: url + '/del',
                            data: {id: data.id},
                            index: index,
                            done: obj.del
                        });
                    });
                    break;
                case 'modify':
                    let loading = main.loading();
                    $.get(url + "/modify", {id: data.id}, function (html) {
                        loading.close();
                        main.popup({
                            url: url + '/modify',
                            title: '修改过滤器',
                            content: html,
                            yes: function (index, dom) {
                                main.durations(dom)
                            },
                            done: "table-list",
                        });
                    });
                    break;
            }
        });
        //头工具栏事件
        table.on('toolbar(table-list)', function (obj) {
            let checkStatus = table.checkStatus(obj.config.id),
                data = checkStatus.data, ids = [];
            for (let i = 0; i < data.length; i++) {
                ids[i] = data[i].id;
            }
            switch (obj.event) {
                case 'add':
                    let loading = main.loading();
                    $.get(url + '/add', {}, function (html) {
                        loading.close();
                        main.popup({
                            url: url + '/add',
                            title: '添加过滤器',
                            content: html,
                            yes: function (index, dom) {
                                main.durations(dom)
                            },
                            done: "table-list",
                        });
                    });
                    break;
                case 'del':
                    if (data.length === 0) {
                        return layer.msg('请选择数据');
                    }
                    layer.confirm('删除后不可恢复，确定删除吗？', function (index) {
                        main.request({
                            url: url + '/del',
                            data: {ids: ids.join()},
                            index: index,
                            done: 'table-list'
                        });
                    });
                    break;
            }
        });
    });
</script>