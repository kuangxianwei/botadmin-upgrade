<style>
    #table-list + div .layui-table-cell {
        height: auto;
        white-space: normal;
    }
</style>
<div class="layui-card">
    <div class="layui-card-body">
        <table id="table-list" lay-filter="table-list"></table>
    </div>
</div>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let table = layui.table,
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
                {field: 'id', hide: true},
                {
                    title: '名称', width: 150, align: "center", templet: function (d) {
                        return '<img src="' + d['icon'] + '" title="' + d['alias'] + '"><br/>' + d['alias'];
                    }
                },
                {field: 'alias', title: '别名', hide: true},
                {field: 'installed', title: '状态', hide: true},
                {field: 'args', title: '参数', hide: true},
                {field: 'intro', title: '简介说明', minWidth: 200},
                {
                    title: '操作', width: 250, align: 'center', fixed: 'right', templet: function (d) {
                        let msg;
                        if (d['installed']) {
                            msg = '<div class="layui-btn-group"><button class="layui-btn layui-btn-danger" lay-event="uninstall">卸载</button>';
                        } else {
                            msg = '<div class="layui-btn-group"><button class="layui-btn" lay-event="install">安装</button>';
                        }
                        return msg + '<button class="layui-btn layui-btn-primary" lay-event="log" lay-tips="查看日志"><i class="layui-icon layui-icon-log"></i></button></div>';
                    }
                }
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
                case 'install':
                    layer.prompt({
                        title: '邮箱域名,必须解析到本服务器',
                        formType: 0,
                        value: 'mail.nfivf.com'
                    }, function (args, index) {
                        layer.close(index);
                        main.req({
                            url: url + "/install",
                            data: {id: data.id, args: args},
                            ending: main.ws.log("plugin." + data.id, function () {
                                table.reload('table-list');
                            })
                        });
                    });
                    break;
                case 'uninstall':
                    main.req({
                        url: url + "/uninstall",
                        data: {id: data.id},
                        ending: main.ws.log("plugin." + data.id, function () {
                            table.reload('table-list');
                        })
                    });
                    break;
                case 'log':
                    main.ws.log("plugin." + data.id);
                    break;
            }
        });
    });
</script>