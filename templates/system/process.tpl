<div class="layui-card">
    <div class="layui-card-body">
        <table id="table-list" lay-filter="table-list"></table>
    </div>
    <div class="layui-card-body">
        <blockquote class="layui-elem-quote">
            1:列表为当前系统所有运行中的进程或程序<br/>
            2:可用于检查系统是否有运行一些异常或其它的进程<br/>
            3:如有异常进程或要终止某进程，点击 右边 的终止即可<br/>
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
            headers: {'X-CSRF-Token':csrfToken},
            method: 'post',
            elem: '#table-list',
            url: url,
            cols: [[
                {field: 'pid', title: 'PID', width: 120, align: 'center', sort: true},
                {field: 'user', title: '用户', width: 120, align: 'center', sort: true},
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
            let data = obj.data;
            switch (obj.event) {
                case "kill":
                    data.act = 'kill';
                    break;
                default:
                    return false
            }
            main.req({
                url: url,
                data: data,
                ending: 'table-list',
            });
        });
    });
</script>
