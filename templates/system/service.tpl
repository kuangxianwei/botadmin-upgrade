<div class="layui-card">
    <div class="layui-card-body">
        <table id="table-list" lay-filter="table-list"></table>
    </div>
    <div class="layui-card-body">
        <blockquote class="layui-elem-quote">
            1:启动表示启动当前服务<br/>
            2:开机自启表示设置为随系统启动,机器重启后会自动启动<br/>
            3:关闭表示停止服务<br/>
            4:禁止开机自启表示关闭随系统启动，机器重启后不会启动
        </blockquote>
    </div>
</div>
<script type="text/html" id="table-toolbar">
    {{ html .ChkToolbar}}
</script>
<script src="/static/layui/layui.js?v={{.Version}}"></script>
<script>
    layui.config({
        base: '/static/' //静态资源所在路径
    }).extend({
        index: 'lib/index', //主入口模块
        main: 'main'
    }).use(['index', 'main', 'table'], function () {
        let table = layui.table,
            main = layui.main,
            url = {{.current_uri}},
            loadindex = layer.load(1, {shade: [0.5, '#000']});

        //规则管理
        table.render({
            headers: {'X-CSRF-Token':{{.csrf_token}}},
            method: 'post',
            elem: '#table-list',
            url: {{.current_uri}},
            cols: [[
                {type: 'numbers', width: 50, title: 'ID', sort: true},
                {field: 'name', title: '名称', sort: true},
                {
                    field: 'enabled', title: '开机启动', event: 'enabled', align: 'center', sort: true,
                    templet: function (d) {
                        let msg = '<input id="' + d.name + '" type="checkbox" lay-skin="switch" lay-text="开启|关闭" lay-filter="switchEnabled"';
                        if (d.enabled) {
                            msg += ' checked>';
                        } else {
                            msg += '>';
                        }
                        return msg;
                    }
                }
            ]],
            done: function () {
                layer.close(loadindex);
            },
            page: false,
            limit: 10,
            limits: [10, 15, 20, 25, 30],
            text: '对不起，加载出现异常！'
        });

        layui.form.on('switch(switchEnabled)', function (obj) {
            let name = this.id,
                checked = this.checked;
            if (!name) {
                layer.tips('服务名称为空，无法操作！', obj.othis);
                return false;
            }
            main.req({
                url: url + '/enable',
                data: {'name': name, "enabled": checked},
                ending: '-',
                error: function () {
                    table.reload('table-list');
                }
            });
            return false;
        });
    });
</script>
