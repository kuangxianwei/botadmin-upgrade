<div class="layui-card-header layuiadmin-card-header-auto layui-form">
    <div class="layui-form-item">
        <div class="layui-input-inline">
            <input type="text" name="host" placeholder="输入服务器" autocomplete="off" class="layui-input">
        </div>
        <div class="layui-input-inline">
            <input type="text" name="username" placeholder="输入用户名" autocomplete="off"
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
        <button class="layui-btn  layui-btn-danger layui-btn-sm" lay-event="del">
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
    layui.config({
        base: '/static/' //静态资源所在路径
    }).extend({
        index: 'lib/index', //主入口模块
        main: 'main'
    }).use(['index', 'form', 'table', 'main'], function () {
        let $ = layui.$,
            table = layui.table,
            main = layui.main,
            element = layui.element,
            form = layui.form,
            url = {{.current_uri}};

        // 渲染表格
        table.render({
            headers: {'X-CSRF-Token':{{.csrf_token}}},
            method: 'post',
            elem: '#table-list',
            url: {{.current_uri}},
            toolbar: '#toolbar',
            cols: [[
                {type: 'checkbox', fixed: 'left'},
                {field: 'id', width: 80, title: 'ID', align: 'center', sort: true},
                {field: 'host', title: '服务器'},
                {field: 'username', title: '用户名'},
                {field: 'password', title: '密码', hide: true},
                {field: 'to', title: '接收者'},
                {field: 'updated', title: '时间', align: 'center', sort: true},
                {title: '操作', width: 120, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
            ]],
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
                    layer.confirm('删除后不可恢复，确定删除？', function (index) {
                        main.req({
                            url: url + '/del',
                            data: data,
                            index: index,
                            ending: 'table-list'
                        });
                    });
                    break;
                case 'modify':
                    $.get(url + '/modify', data, function (html) {
                        main.popup({
                            title: '修改邮箱配置',
                            url: url + '/modify',
                            area: ['500px', '500px'],
                            content: html,
                            ending: 'table-list',
                        });
                        element.render();
                    });
                    break;
                case 'test':
                    layer.confirm('测试本配置有效果', function (index) {
                        main.req({
                            url: url + '/test',
                            data: data,
                            index: index
                        });
                    });
                    break;
            }
        });
        //监听工具栏
        table.on('toolbar(table-list)', function (obj) {
            let checkStatus = table.checkStatus(obj.config.id),
                data = checkStatus.data;
            switch (obj.event) {
                case 'add':
                    $.get(url + '/add', {}, function (html) {
                        main.popup({
                            title: '添加邮箱',
                            url: url + '/add',
                            area: ['500px', '500px'],
                            content: html,
                            ending: 'table-list',
                        });
                        element.render();
                    });
                    break;
                case 'del':
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
