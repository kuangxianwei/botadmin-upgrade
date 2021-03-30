<div class="layui-card">
    <div class="layui-card-body">
        <table id="table-list" lay-filter="table-list"></table>
    </div>
</div>
<script type="text/html" id="toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm" lay-event="add" id="LAY_layer_iframe_add">
            <i class="layui-icon layui-icon-add-1"></i>添加用户
        </button>
        <button class="layui-btn  layui-btn-danger layui-btn-sm" lay-event="del" id="LAY_layer_iframe_del">
            <i class="layui-icon layui-icon-delete"></i>批量删除用户
        </button>
        <button class="layui-btn layui-btn-sm" lay-event="sync" id="LAY_layer_iframe_sync">
            <i class="layui-icon layui-icon-refresh"></i>同步数据
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
    </div>
</script>
{{template "JS" -}}
<script>
    JS.use(['index', 'main'], function () {
        let table = layui.table,
            main = layui.main,
            element = layui.element,
            url = {{.current_uri}};

        //日志管理
        table.render({
            headers: {'X-CSRF-Token':{{.csrf_token}}},
            method: 'post',
            elem: '#table-list',
            url: {{.current_uri}},
            toolbar: '#toolbar',
            cols: [[
                {type: 'checkbox', fixed: 'left'},
                {field: 'id', width: 80, title: 'ID', align: 'center', sort: true},
                {field: 'username', title: '用户名'},
                {field: 'password', title: '密码', align: 'center'},
                {field: 'dir', title: '路径', align: 'center'},
                {field: 'site_id', title: '网站ID', align: 'center'},
                {field: 'quota_size', title: '空间大小M', align: 'center', hide: true},
                {field: 'quota_files', title: '文件数个', align: 'center', hide: true},
                {field: 'ulbandwidth', title: '上传带宽K', align: 'center', hide: true},
                {field: 'dlbandwidth', title: '下载带宽K', align: 'center', hide: true},
                {field: 'updated', title: '时间', align: 'center', sort: true},
                {field: 'node', title: '备注', align: 'center', hide: true},
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
                            title: '修改FTP',
                            url: url + '/modify',
                            content: html,
                            ending: 'table-list',
                        });
                        element.render();
                    });
                    break;
            }
        });

        //监听工具栏
        table.on('toolbar(table-list)', function (obj) {
            let checkStatus = table.checkStatus(obj.config.id);
            switch (obj.event) {
                case 'add':
                    $.get(url + '/add', {}, function (html) {
                        main.popup({
                            title: '添加FTP',
                            url: url + '/add',
                            area: ['70%', '80%'],
                            content: html,
                            ending: 'table-list',
                        });
                        element.render();
                    });
                    break;
                case 'del':
                    let data = checkStatus.data;
                    if (data.length === 0) {
                        return layer.msg('请选择数据');
                    }
                    layer.confirm('删除后不可恢复，确定删除吗？', function (index) {
                        let ids = [];
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
                case 'sync':
                    layer.confirm('如无错误且无需同步，确定同步？', function (index) {
                        main.req({
                            url: url + '/sync',
                            index: index,
                        });
                    });
                    break;
            }
        });
    });
</script>
