<div class="layui-card">
    <div class="layui-card-body">
        <div class="layui-inline layui-form">
            <div class="layui-input-inline">
                <input type="radio" name="display" value="1" title="存在数据" lay-filter="display" checked>
                <input type="radio" name="display" value="0" title="全部" lay-filter="display">
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-btn-group">
                <button class="layui-btn layui-btn-primary">总日志: <span id="count"></span>条</button>
                <button class="layui-btn layui-btn-primary">运行中: <span id="active"></span>条</button>
                <button class="layui-btn layui-btn-primary">总协程数: <span id="goroutine"></span></button>
                <button class="layui-btn layui-btn-primary" lay-event="cron">定时任务: <span id="cron"></span>条</button>
            </div>
        </div>
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
            form = layui.form,
            hasLocalStorage = typeof localStorage !== "undefined",
            w = new WebSocket((location.protocol === 'https:' ? 'wss://' : 'ws://') + location.host + '/ws/log/info');
        w.onopen = function () {
            w.send("show");
        };
        w.onmessage = function (e) {
            let field = JSON.parse(e.data);
            if (field) {
                if (field.data) {
                    let elem = $('#table-list>tbody').empty(),
                        display = localStorage.getItem('log_info') || '1';
                    for (let i = 0; i < field.data.length; i++) {
                        let item = field.data[i];
                        if (display === "1" && item.size === 0 && !item.other) {
                            continue
                        }
                        let trElem = '<tr>';
                        if (typeof item.other === 'string') {
                            item.other = item.other.toString();
                        } else if (item.other instanceof Object) {
                            item.other = JSON.stringify(item.other);
                        } else if (!item.other) {
                            item.other = '';
                        }
                        trElem += '<td lay-event="view-log" style="cursor:pointer;color:#0a5b52" data-token="' + item.token + '">' + item.token + '</td>';
                        trElem += '<td align="center">' + (item.status === 0 ? '未运行' : '运行中') + '</td>';
                        trElem += '<td align="center">' + item.size + '</td>';
                        trElem += '<td>' + item.other + '</td>';
                        trElem += '</tr>';
                        elem.append(trElem);
                    }
                    $('[lay-event="view-log"]').off('click').on('click',function () {
                        main.ws.log($(this).data('token'));
                    });
                }
                $('#count').text(field.count);
                $('#active').text(field.active);
                $('#goroutine').text(field['goroutine']);
                $('#cron').text(field.cron);
            }
        };
        $("[lay-event=cron]").off('click').on('click',function () {
            main.request({
                url: url + "/cron",
                done: function (res) {
                    main.msg(res.msg);
                    return false;
                },
            });
        });
        form.on('radio(display)', function (obj) {
            if (hasLocalStorage) {
                localStorage.setItem('log_info', obj.value);
                location.reload();
            }
        });
        if (hasLocalStorage) {
            $('input[type=radio][value="' + localStorage.getItem('log_info') + '"]').prop('checked', true);
        }
        form.render();
    });
</script>