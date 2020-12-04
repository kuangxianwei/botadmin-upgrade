<div class="layui-card">
    <div class="layui-card-body">
        <table id="table-list" lay-filter="table-list"></table>
    </div>
</div>
<script type="text/html" id="table-toolbar">
    <button class="layui-btn layui-btn-xs layui-btn-danger" lay-event="kill">停止</button>
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.config({
        base: '/static/' //静态资源所在路径
    }).extend({
        index: 'lib/index', //主入口模块
        main: 'main'
    }).use(['index', 'table', 'main'], function () {
        let table = layui.table,
            main = layui.main,
            url = {{.current_uri}};

        //规则管理
        table.render({
            headers: {'X-CSRF-Token':{{.csrf_token}}},
            method: 'post',
            elem: '#table-list',
            url: {{.current_uri}},
            cols: [[
                {type: 'numbers', width: 50, title: 'ID', sort: true},
                {field: 'Filesystem', title: '文件系统', minWidth: 250},
                {field: 'Size', title: '总大小'},
                {field: 'Used', title: '已使用'},
                {field: 'Avail', title: '空闲'},
                {field: 'UsePer', title: '使用率'},
                {field: 'Mounted', title: '挂载', minWidth: 250}
            ]],
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
