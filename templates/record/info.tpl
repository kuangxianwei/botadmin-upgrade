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
                <button class="layui-btn layui-btn-primary" data-crontab>定时任务: <span id="cron"></span>条
                </button>
            </div>
        </div>
    </div>
    <div class="layui-card-body">
        <table id="table-info" lay-filter="table-info" class="layui-hide"></table>
    </div>
</div>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        layui.main.ws.info();
    });
</script>