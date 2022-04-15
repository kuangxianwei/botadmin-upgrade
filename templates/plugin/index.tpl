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
<script type="text/html" id="install-html">
    <div class="layui-card" style="padding: 20px 20px 0 20px">
        <div class="layui-card-header">安装参数,多个参数空格隔开</div>
        <div class="layui-card-body layui-form">
            <input name="args" value="" class="layui-input" placeholder="参数1 参数2">
            <button class="layui-hide" lay-submit></button>
        </div>
    </div>
</script>
<script>
    layui.use(['index', 'main'], function () {
        let table = layui.table,
            main = layui.main;
        //日志管理
        table.render({
            headers: {'X-CSRF-Token': csrfToken},
            method: 'post',
            elem: '#table-list',
            toolbar: '#toolbar',
            url: url,
            cols: [[
                {field: 'id', hide: true},
                {
                    title: '名称', width: 150, align: "center", templet: function (d) {
                        return '<img src="' + d['icon'] + '" title="' + d['alias'] + '" alt="' + d['alias'] + '"' + (d['installed'] ? '' : ' class="grey"') + '><br/>' + d['alias'];
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
            limits: [10, 20, 30],
            text: '对不起，加载出现异常！'
        });
        //监听工具条
        table.on('tool(table-list)', function (obj) {
            let data = obj.data;
            switch (obj.event) {
                case 'install':
                    if (data.args instanceof Array && data.args.length > 0) {
                        main.popup({
                            url: url + "/install",
                            title: false,
                            maxmin: false,
                            content: $('#install-html').html(),
                            area: '350px',
                            done: function () {
                                main.ws.log("plugin." + data.id, function () {
                                    table.reload('table-list');
                                });
                                return false;
                            },
                            success: function (dom) {
                                dom.find('input[name="args"]').attr("placeholder", data.args.join(" "));
                                dom.find('.layui-form').append('<input type="hidden" name="id" value="' + data.id + '">');
                            }
                        });
                    } else {
                        main.request({
                            url: url + "/install",
                            data: {id: data.id},
                            done: function () {
                                main.ws.log("plugin." + data.id, function () {
                                    table.reload('table-list');
                                });
                                return false;
                            },
                        });
                    }
                    break;
                case 'uninstall':
                    main.request({
                        url: url + "/uninstall",
                        data: {id: data.id},
                        done: function () {
                            main.ws.log("plugin." + data.id, function () {
                                table.reload('table-list');
                            });
                            return false;
                        },
                    });
                    break;
                case 'log':
                    main.ws.log("plugin." + data.id);
                    break;
            }
        });
        main.checkLNMP();
    });
</script>