<div class="layui-card">
    <div class="layui-card-body">
        <div class="layui-form table-search" style="left: 20px">
            <div class="layui-inline">
                <input type="search" name="search" class="layui-input" placeholder="输入搜索...">
            </div>
            <button class="layui-btn layui-btn-sm" lay-submit="" lay-filter="search">
                <i class="layui-icon layui-icon-search"></i>
            </button>
        </div>
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
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let table = layui.table,
            main = layui.main;
        main.table({
            cols: [[
                {type: 'numbers', width: 80, title: 'ID', sort: true},
                {field: 'name', title: '名称', sort: true},
                {
                    field: 'enabled', title: '开机启动', align: 'center', sort: true,
                    templet: function (d) {
                        return '<input id="' + d.name + '" type="checkbox" lay-skin="switch" lay-text="开启|关闭" lay-filter="switchEnabled"' + (d.enabled ? ' checked>' : '>');
                    }
                }
            ]], page: false
        });
        layui.form.on('switch(switchEnabled)', function (obj) {
            let name = this.id,
                checked = this.checked;
            if (!name) {
                layer.tips('服务名称为空，无法操作！', obj.othis);
                return false;
            }
            main.request({
                url: url + '/enable',
                data: {name: name, enabled: checked},
                error: function () {
                    table.reload('table-list');
                }
            });
            return false;
        });
    });
</script>