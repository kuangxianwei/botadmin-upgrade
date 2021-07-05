<div class="layui-card">
    <div class="layui-card-header layuiadmin-card-header-auto">
        <button class="layui-btn layui-btn-primary">总日志: <span id="count"></span>条</button>
        <button class="layui-btn layui-btn-primary">运行中: <span id="active"></span>条</button>
        <button class="layui-btn layui-btn-primary">总协程数: <span id="goroutine"></span></button>
        <button class="layui-btn layui-btn-primary" lay-event="cron">定时任务: <span id="cron"></span>条</button>
    </div>
    <div class="layui-card-body">
        <table id="table-list" lay-filter="table-list" class="layui-table">
            <colgroup>
                <col width="200">
                <col width="100">
                <col width="120">
                <col>
            </colgroup>
            <thead>
            <tr>
                <th>Token</th>
                <th>
                    <div class="layui-table-cell" align="center"><span>Status</span></div>
                </th>
                <th>
                    <div class="layui-table-cell" align="center"><span>Size(字节)</span></div>
                </th>
                <th>Other</th>
            </tr>
            </thead>
            <tbody></tbody>
        </table>
    </div>
</div>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let main = layui.main,
            url = {{.current_uri}},
            w = new WebSocket((location.protocol === 'https:' ? 'wss://' : 'ws://') + location.host + '/ws/log/info');
        w.onopen = function () {
            w.send("show");
        };
        w.onmessage = function (e) {
            let field = JSON.parse(e.data);
            if (field) {
                if (field.data) {
                    let elem = $('#table-list>tbody').empty();
                    for (let i = 0; i < field.data.length; i++) {
                        let item = field.data[i], trElem = '<tr>';
                        trElem += '<td lay-event="view-log" style="cursor:pointer;color:#0a5b52" data-token="' + item.token + '">' + item.token + '</td>';
                        trElem += '<td align="center">' + (item.status === 0 ? '未运行' : '运行中') + '</td>';
                        trElem += '<td align="center">' + item.size + '</td>';
                        trElem += '<td>' + item.other + '</td>';
                        trElem += '</tr>';
                        elem.append(trElem);
                    }
                    $('[lay-event="view-log"]').click(function () {
                        main.ws.log($(this).data('token'));
                    });
                }
                $('#count').text(field.count);
                $('#active').text(field.active);
                $('#goroutine').text(field['goroutine']);
                $('#cron').text(field.cron);
            }
        };
        $("[lay-event=cron]").click(function () {
            main.req({
                url: url + "/cron",
                tips: function (res) {
                    main.msg(res.msg);
                }
            });
        });
    });
</script>