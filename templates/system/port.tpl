<div class="layui-card">
    <div class="layui-card-body">
        <table id="table-list" lay-filter="table-list"></table>
    </div>
    <div class="layui-card-body">
        <blockquote class="layui-elem-quote">
            1:当前运行或监听的端口<br/>
            2:0.0.0.0表示本机所有IP<br/>
            3:类似:::这样的IP地址,是ipv6的地址格式<br/>
            4:如有些端口停止不了，可前往 “ 启动服务 ” 里停止<br/>
        </blockquote>
    </div>
</div>
<script type="text/html" id="table-toolbar">
    <button class="layui-btn layui-btn-xs layui-btn-danger" lay-event="kill">停止</button>
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let table = layui.table,
            main = layui.main,
            loadindex = layer.load(1, {shade: [0.5, '#000']});

        //规则管理
        table.render({
            headers: {'X-CSRF-Token': csrfToken},
            method: 'post',
            elem: '#table-list',
            url: url,
            cols: [[
                {type: 'numbers', width: 50, title: 'ID', sort: true},
                {field: 'prot', title: '协议', sort: true},
                {field: 'pid', title: 'PID', align: 'center', sort: true},
                {field: 'ip_port', title: 'IP端口', align: 'center', sort: true},
                {field: 'name', title: '应用程序', align: 'center', sort: true},
                {title: '操作', align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
            ]],
            done: function () {
                layer.close(loadindex);
            },
            page: false,
            limit: 10,
            limits: [10, 15, 20, 25, 30],
            text: '对不起，加载出现异常！'
        });

        //监听工具条
        table.on('tool(table-list)', function (obj) {
            if (obj.event === "kill") {
                obj.data.act = 'kill';
            } else {
                return false;
            }
            main.request({
                url: url,
                data: obj.data,
                done: 'table-list'
            });
        });
    });
</script>