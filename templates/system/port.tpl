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
        let main = layui.main;
        main.table({
            cols: [[
                {type: 'numbers', width: 80, title: 'ID', sort: true},
                {field: 'prot', title: '协议', sort: true},
                {field: 'pid', title: 'PID', align: 'center', sort: true},
                {field: 'ip_port', title: 'IP端口', align: 'center', sort: true},
                {field: 'name', title: '应用程序', align: 'center', sort: true},
                {title: '操作', align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
            ]], page: false
        }, {
            kill: function (obj) {
                obj.data.act = 'kill';
                main.request({
                    url: url,
                    data: obj.data,
                    done: 'table-list'
                });
            }
        });
    });
</script>