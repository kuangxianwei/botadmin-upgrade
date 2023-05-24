<div class="layui-row layui-col-space10">
    <div class="layui-col-sm12 layui-col-md6">
        <div class="layui-card">
            <div class="layui-card-header">概况<span class="layui-badge layui-bg-blue layuiadmin-badge">Info</span>
            </div>
            <div class="layui-card-body layuiadmin-card-list">
                <p>&nbsp;&nbsp;&nbsp;&nbsp;ID: {{.obj.Id}}</p>
                <p>主域: {{call .obj.HostnameFunc}}</p>
                <p>目录: {{call .obj.RootFunc}}</p>
                <p>标题: {{.obj.Title}}</p>
            </div>
        </div>
    </div>
    <div class="layui-col-sm12 layui-col-md6">
        <div class="layui-card">
            <div class="layui-card-header">
                栏目 / 文章 / TAG / 友情链接<span class="layui-badge layui-bg-blue layuiadmin-badge">Count</span>
            </div>
            <div class="layui-card-body layuiadmin-card-list">
                <p class="layuiadmin-big-font">{{print .info}}</p>
            </div>
        </div>
    </div>
</div>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
    });
</script>