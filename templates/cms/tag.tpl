<div class="layui-card">
    <div class="layui-card-body">
        <div class="table-search" style="left:150px">
            <div class="layui-inline layui-form">
                <div class="layui-input-inline">
                    <input type="hidden" name="id" value="{{.obj.Id}}">
                    <input type="text" name="search" placeholder="搜索标题" class="layui-input">
                </div>
                <button class="layui-btn layui-btn-sm layui-btn-primary" lay-submit lay-filter="search">
                    <i class="layui-icon layui-icon-search"></i>
                </button>
            </div>
        </div>
        <table id="table-list" lay-filter="table-list"></table>
    </div>
</div>
<script type="text/html" id="toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm" lay-event="add">
            <i class="layui-icon layui-icon-add-circle"></i>
        </button>
        <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="del">
            <i class="layui-icon layui-icon-delete"></i>
        </button>
    </div>
</script>
<script type="text/html" id="tool">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-xs" lay-event="edit">
            <i class="layui-icon layui-icon-edit"></i>
        </button>
        <button class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del">
            <i class="layui-icon layui-icon-delete"></i>
        </button>
    </div>
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let id = parseInt({{.obj.Id}}) || 0,
            table = layui.table,
            main = layui.main;
        //日志管理
        table.render({
            headers: {'X-CSRF-Token': csrfToken},
            method: 'post',
            elem: '#table-list',
            toolbar: '#toolbar',
            url: url,
            where: {id: id},
            cols: [[
                {type: 'checkbox', fixed: 'left'},
                {field: 'index', width: 80, title: '索引', sort: true, align: 'center'},
                {field: 'name', title: '名称', minWidth: 100},
                {field: 'num', title: '调用次', width: 100, sort: true, align: 'center'},
                {title: '操作', width: 150, align: 'center', fixed: 'right', toolbar: '#tool'}
            ]],
            page: true,
            limit: 10,
            limits: [10, 20, 30, 100],
            text: '对不起，加载出现异常！'
        });
        let active = {
                del: function () {
                    let othis = this;
                    layer.confirm('确定删除此条TAG？', function (index) {
                        main.req({
                            url: url + '/del',
                            data: {id: id, ids: othis.data.index},
                            index: index,
                            ending: othis.del
                        });
                    });
                },
                edit: function () {
                    let othis = this;
                    let loading = main.loading();
                    $.get(url + "/modify", {id: id, ids: othis.data.index}, function (html) {
                        loading.close();
                        main.popup({
                            type: 1,
                            title: "修改TAG",
                            url: url + "/modify",
                            content: html,
                            ending: "table-list",
                            area: ['600px', '500px'],
                        });
                    });
                }
            },
            activeBar = {
                add: function () {
                    let loading = main.loading();
                    $.get(url + "/add", {id: id}, function (html) {
                        loading.close();
                        main.popup({
                            type: 1,
                            title: "添加TAG",
                            url: url + "/add",
                            content: html,
                            ending: "table-list",
                            area: ['600px', '400px'],
                        });
                    });
                },
                del: function (obj) {
                    if (obj.data.length === 0) {
                        return layer.msg('请选择数据');
                    }
                    layer.confirm('删除后不可恢复，确定删除吗？', function (index) {
                        let ids = [];
                        for (let i = 0; i < obj.data.length; i++) {
                            ids[i] = obj.data[i].index;
                        }
                        main.req({
                            url: url + '/del',
                            data: {id: id, ids: ids.join()},
                            index: index,
                            ending: 'table-list'
                        });
                    });
                }
            };
        //监听工具条
        table.on('tool(table-list)', function (obj) {
            active[obj.event] && active[obj.event].call(obj);
        });

        //头工具栏事件
        table.on('toolbar(table-list)', function (obj) {
            activeBar[obj.event] && activeBar[obj.event].call(obj, table.checkStatus(obj.config.id));
        });
        // 监听搜索
        main.onSearch();
    });
</script>