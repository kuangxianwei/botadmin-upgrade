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
        <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="del" id="LAY_layer_iframe_del">
            <i class="layui-icon layui-icon-delete"></i>删除
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
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let main = layui.main;
        main.table([[
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
            {
                field: 'updated', title: '时间', align: 'center', sort: true, templet: function (d) {
                    return main.timestampFormat(d['updated']);
                }
            },
            {field: 'node', title: '备注', align: 'center', hide: true},
            {title: '操作', width: 120, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
        ]], {
            modify: function (obj) {
                main.get(url + '/modify', {id: obj.data.id}, function (html) {
                    main.popup({
                        title: '修改FTP',
                        url: url + '/modify',
                        content: html,
                        done: 'table-list',
                    });
                });
            },
            add: function () {
                main.get(url + '/add', function (html) {
                    main.popup({
                        title: '添加FTP',
                        url: url + '/add',
                        area: ['70%', '95%'],
                        content: html,
                        done: 'table-list',
                    });
                });
            },
            sync: function () {
                layer.confirm('如无错误且无需同步，确定同步？', function (index) {
                    main.request({
                        url: url + '/sync',
                        index: index,
                    });
                });
            }
        });
    });
</script>