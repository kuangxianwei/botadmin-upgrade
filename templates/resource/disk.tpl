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
    layui.use(['index', 'main'], function () {
        let main = layui.main;
        main.table({
            cols: [[
                {type: 'numbers', width: 80, title: 'ID', sort: true},
                {field: 'Filesystem', title: '文件系统', minWidth: 250},
                {field: 'Size', title: '总大小'},
                {field: 'Used', title: '已使用'},
                {field: 'Avail', title: '空闲'},
                {field: 'UsePer', title: '使用率'},
                {field: 'Mounted', title: '挂载', minWidth: 250}
            ]], page: false
        }, {
            kill: function (obj) {
                obj.data.act = 'kill';
                main.request({
                    data: obj.data,
                    done: 'table-list',
                });
            }
        });
    });
</script>