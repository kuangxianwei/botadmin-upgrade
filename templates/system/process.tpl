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
        let main = layui.main;
        main.table({
            cols: [[
                {field: 'pid', title: 'PID', width: 120, align: 'center', sort: true},
                {field: 'user', title: '用户', width: 120, align: 'center', sort: true},
                {field: 'name', title: '应用程序', align: 'center', sort: true},
                {title: '操作', align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
            ]], page: false
        }, {
            kill: function (obj) {
                obj.data.act = 'kill';
                main.request({
                    url: URL,
                    data: obj.data,
                    done: 'table-list',
                });
            }
        });
    });
</script>