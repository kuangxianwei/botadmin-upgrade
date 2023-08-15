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
<script type="text/html" id="args-html">
    <div class="layui-card" style="padding: 20px 20px 0 20px">
        <div class="layui-card-header">命令参数,可以为空</div>
        <div class="layui-card-body layui-form">
            <input name="args" id="args" value="" class="layui-input" placeholder="参数一 参数二 参数三">
            <input type="hidden" name="id" value="">
            <button class="layui-hide" lay-submit></button>
        </div>
    </div>
</script>
<script>
    layui.use(['index', 'main'], function () {
        let table = layui.table,
            main = layui.main;
        main.table([[
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
        ]], {
            install: function (obj) {
                main.popup({
                    url: URL + '/install',
                    title: false,
                    maxmin: false,
                    content: $('#args-html').html(),
                    area: '350px',
                    done: function () {
                        main.ws.log('plugin.' + obj.data.id, function () {
                            table.reload('table-list');
                        });
                        return false;
                    },
                    success: function (dom) {
                        if (Array.isArray(obj.data.args) && obj.data.args.length > 0) dom.find('input[name=args]').attr('placeholder', obj.data.args.join(' '));
                        dom.find('input[name=id]').val(obj.data.id);
                    }
                });
            },
            uninstall: function (obj) {
                main.popup({
                    url: URL + '/uninstall',
                    title: false,
                    maxmin: false,
                    content: $('#args-html').html(),
                    area: '350px',
                    done: function () {
                        main.ws.log('plugin.' + obj.data.id, function () {
                            table.reload('table-list');
                        });
                        return false;
                    },
                    success: function (dom) {
                        if (Array.isArray(obj.data.args) && obj.data.args.length > 0) dom.find('input[name=args]').attr('placeholder', obj.data.args.join(' '));
                        dom.find('input[name=id]').val(obj.data.id);
                    }
                });
            },
        });
    });
</script>