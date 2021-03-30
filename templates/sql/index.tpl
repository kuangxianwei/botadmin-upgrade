<div class="layui-card">
    <div class="layui-form layui-card-header layuiadmin-card-header-auto">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">用户名:</label>
                <div class="layui-input-inline">
                    <input type="text" name="username" placeholder="请输入数据库用户名" autocomplete="off"
                           class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">数据库名:</label>
                <div class="layui-input-inline">
                    <input type="text" name="dbname" placeholder="请输入数据库名称" autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <button class="layui-btn" data-type="reload" lay-submit lay-filter="search">
                    <i class="layui-icon layui-icon-search layuiadmin-button-btn"></i>
                </button>
            </div>
        </div>
    </div>
    <div class="layui-card-body">
        <table id="table-list" lay-filter="table-list"></table>
    </div>
</div>
<script type="text/html" id="toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm" lay-event="add">
            <i class="layui-icon layui-icon-add-1"></i>创建MySQL
        </button>
        <button class="layui-btn layui-btn-sm" lay-event="sync">
            <i class="layui-icon layui-icon-refresh-3"></i>同步MySQL
        </button>
    </div>
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm" lay-event="modifyroot">
            <i class="layui-icon layui-icon-edit"></i>修改密码
        </button>
        <button class="layui-btn layui-btn-sm" lay-event="resetroot">
            <i class="layui-icon layui-icon-refresh"></i>重置密码
        </button>
        <button class="layui-btn layui-btn-sm" lay-event="viewRoot">
            <i class="layui-icon  layui-icon-about"></i>复制密码
        </button>
        <button class="layui-hide" data-clipboard-text=""></button>
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
    </div>
</script>
<script src="/static/modules/clipboard.min.js"></script>
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
            url: {{.current_uri}},
            toolbar: '#toolbar',
            cols: [[
                {field: 'id', width: 80, title: 'ID', align: 'center', sort: true},
                {field: 'username', title: '用户名', align: 'center'},
                {field: 'password', title: '密码', align: 'center'},
                {field: 'dbname', title: '数据库名', align: 'center'},
                {field: 'charset', title: '编码', align: 'center', width: 66},
                {field: 'prefix', title: '前缀', hide: true},
                {field: 'hosts', title: '访问地址', align: 'center', width: 90},
                {field: 'site_id', title: '绑定站点', align: 'center'},
                {field: 'updated', title: '时间', align: 'center', sort: true},
                {field: 'note', title: '备注', align: 'center', hide: true},
                {title: '操作', width: 120, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
            ]],
            page: true,

            limit: 10,
            limits: [10, 15, 20, 25, 30],
            text: '对不起，加载出现异常！'
        });
        let clipboard = new ClipboardJS('*[data-clipboard-text]');
        clipboard.on('success', function (e) {
            layer.msg('root密码复制成功');
            e.clearSelection();
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
                            ending: obj.del
                        });
                    });
                    break;
                case 'modify':
                    $.get(url + '/modify', data, function (html) {
                        main.popup({
                            title: '修改MySQL',
                            content: html,
                            area: ['50%', '80%'],
                            url: url + '/modify',
                            ending: 'table-list',
                        });
                    });
                    break;
            }
        });

        //监听工具栏
        table.on('toolbar(table-list)', function (obj) {
            switch (obj.event) {
                case 'add':
                    $.get(url + '/add', {}, function (html) {
                        main.popup({
                            title: '创建数据库',
                            content: html,
                            area: ['50%', '80%'],
                            url: url + '/add',
                            ending: 'table-list',
                        });
                    });
                    break;
                case 'modifyroot':
                    $.get(url + '/modifyroot', {}, function (html) {
                        main.popup({
                            title: '修改root密码',
                            content: html,
                            url: url + '/modifyroot',
                            area: ['400px', '300px'],
                        });
                    });
                    break;
                case 'resetroot':
                    $.get(url + '/resetroot', {}, function (html) {
                        main.popup({
                            title: '重置root密码',
                            content: html,
                            url: url + '/resetroot',
                            area: ['400px', '280px'],
                        });
                    });
                    break;
                case 'viewRoot':
                    $.get(url + '/view', {}, function (html) {
                        $('*[data-clipboard-text]').attr('data-clipboard-text', html).click();
                    });
                    break;
                case 'sync':
                    layer.confirm('如无错误且无需同步，确定同步？', function (index) {
                        main.req({
                            url: url + '/sync',
                            index: index,
                            ending: 'table-list',
                        });
                    });
                    break;
                default:
                    break;
            }
        });
        //监听搜索
        form.on('submit(search)', function (data) {
            let field = data.field, cols = [];
            $.each(field, function (k, v) {
                if (v === "") {
                    delete field[k];
                } else {
                    cols.push(k);
                }
            });
            field.cols = cols.join();
            //执行重载
            table.reload('table-list', {
                where: field,
                page: {curr: 1}
            });
            return false;
        });
    });
</script>
