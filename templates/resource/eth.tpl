<div class="layui-card">
    <div class="layui-card-body">
        <table id="table-list" lay-filter="table-list"></table>
    </div>
    <div class="layui-card-body">
        <blockquote class="layui-elem-quote">
            1:lo表示本地环路连接<br/>
            2:OpenVZ虚拟机/VPS上的实时流量可能会有误
        </blockquote>
    </div>
</div>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let table = layui.table;

        //规则管理
        table.render({
            headers: {'X-CSRF-Token':csrfToken},
            method: 'post',
            elem: '#table-list',
            url: url,
            cols: [[
                {field: 'Face', title: '网卡', align: 'center'},
                {field: 'Flow', title: '流向', align: 'center'},
                {field: 'Bytes', title: '字节流', align: 'center', sort: true},
                {field: 'Packets', title: '收发包', align: 'center', sort: true},
                {field: 'Errs', title: '错误数', align: 'center'},
                {field: 'Drop', title: '拒绝数', align: 'center'},
                {field: 'Fifo', title: '先进先出', align: 'center'},
                {field: 'Frame', title: '框架', align: 'center'},
                {field: 'Compressed', title: '压缩', align: 'center'},
                {field: 'Multicast', title: '并发', align: 'center'}
            ]],
            page: false,
            limit: 10,
            limits: [10, 15, 20, 25, 30],
            text: '对不起，加载出现异常！'
        });
    });
</script>
