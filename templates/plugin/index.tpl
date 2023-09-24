<style>
	#table-list + div .layui-table-cell{
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
            main = layui.main;
        main.table([[
            {
                field: 'nane', title: '名称', width: 150, align: "center", templet: function (d) {
                    return '<img width="150" src="' + d['icon'] + '" title="' + d['alias'] + '" alt="' + d['alias'] + '"' + (d['installed'] ? '' : ' class="grey"') + '><br/>' + d['alias'];
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
        ]], {
            install: function (obj) {
                layer.prompt({title: '输入命令参数，多个参数空格隔开'}, function (args, index) {
                    layer.close(index);
                    obj.data.args = args;
                    main.request({
                        url: URL + "/install",
                        data: obj.data,
                        done: function () {
                            main.ws.log('plugin.' + obj.data.name, function () {
                                table.reload('table-list');
                            });
                            return false;
                        },
                    });
                });
            },
            uninstall: function (obj) {
                layer.prompt({title: '输入命令参数，多个参数空格隔开'}, function (args, index) {
                    layer.close(index);
                    obj.data.args = args;
                    main.request({
                        url: URL + "/uninstall",
                        data: obj.data,
                        done: function () {
                            main.ws.log('plugin.' + obj.data.name, function () {
                                table.reload('table-list');
                            });
                            return false;
                        },
                    });
                });
            },
            log: function (obj) {
                main.ws.log('plugin.' + obj.data.name)
            }
        });
    });
</script>