<div class="layui-card">
    <div class="layui-card-body">
        <table id="table-list" lay-filter="table-list"></table>
    </div>
    <div class="layui-card-body">
        <blockquote class="layui-elem-quote">
            1:实际有效空闲内存为：空闲+缓存+缓冲<br/>
            2:虚拟内存一般不会用到，但若大量使用时，系统性能会立马下降，影响较大<br/>
            原则上，在安装系统时需要分配物理内存的两倍。<br/>
            3:由于OpenVZ虚拟化限制，释放内存在OpenVZ VPS上无效
        </blockquote>
    </div>
</div>
<script type="text/html" id="table-toolbar">
    <button class="layui-btn layui-btn-xs layui-btn-danger" lay-event="kill">停止</button>
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index'], function () {
        let table = layui.table;
        //规则管理
        table.render({
            headers: {'X-CSRF-Token':{{.csrf_token}}},
            method: 'post',
            elem: '#table-list',
            url: {{.current_uri}},
            cols: [[
                {field: 'Sector', title: '扇区'},
                {field: 'Total', title: '总内存', align: 'center'},
                {field: 'Used', title: '已使用', align: 'center'},
                {field: 'Free', title: '空闲', align: 'center'},
                {field: 'Cache', title: '缓存(cache)', align: 'center'},
                {field: 'Buffer', title: '缓冲(buffer)', align: 'center'},
            ]],
            page: false,

            limit: 10,
            limits: [10, 15, 20, 25, 30],
            text: '对不起，加载出现异常！'
        });
    });
</script>
