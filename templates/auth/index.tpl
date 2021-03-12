<div class="layui-card">
    <div class="layui-card-header layuiadmin-card-header-auto layui-form">
        <div class="layui-form-item">
            <div class="layui-input-inline">
                <input type="text" name="username" placeholder="输入用户名" autocomplete="off" class="layui-input">
            </div>
            <div class="layui-input-inline">
                <input type="text" name="status" placeholder="输入状态" autocomplete="off"
                       class="layui-input">
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
        <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="batchdel">
            <i class="layui-icon layui-icon-delete"></i>删除
        </button>
    </div>
</script>
<script type="text/html" id="table-toolbar">
    <a class="layui-btn layui-btn-danger layui-btn-xs layui-btn-danger" lay-event="del"><i
                class="layui-icon layui-icon-delete"></i>删除</a>
</script>
{{template "JS" -}}
<script>
    JS.use(['index', 'main'], function () {
        let form = layui.form,
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
                {field: 'id', hide: true},
                {type: 'numbers', width: 80, title: 'ID', sort: true},
                {field: 'username', title: '用户名', minWidth: 100},
                {field: 'password', title: '密码', minWidth: 100},
                {field: 'ip', title: 'IP', minWidth: 100},
                {field: 'status', title: '状态', minWidth: 100},
                {field: 'updated', title: '时间', minWidth: 100, sort: true},
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
            if (obj.event === 'del') {
                layer.confirm('确定删除此条日志？', function (index) {
                    main.req({
                        url: url + '/del',
                        data: {'id': data.id},
                        index: index,
                        ending: obj.del
                    });
                });
            }
        });

        //头工具栏事件
        table.on('toolbar(table-list)', function (obj) {
            let checkStatus = table.checkStatus(obj.config.id);
            switch (obj.event) {
                case 'batchdel':
                    let data = checkStatus.data;
                    if (data.length === 0) {
                        return layer.msg('请选择数据');
                    }
                    layer.confirm('删除后不可恢复，确定删除吗？', function (index) {
                        let ids = Array();
                        for (let i = 0; i < data.length; i++) {
                            ids[i] = data[i].id;
                        }
                        main.req({
                            url: url + '/del',
                            data: {'ids': ids.join()},
                            index: index,
                            ending: 'table-list'
                        });
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
    });
</script>
