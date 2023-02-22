<div class="layui-card">
    <div class="layui-card-header layuiadmin-card-header-auto" style="color:red">
        <div class="layui-form-item">
            <h2 class="layui-inline">{{if .title}}{{.title}}{{else}}错误提示{{end}}</h2>
            {{if .link -}}
                <div class="layui-inline">
                    <a lay-href="{{.link}}"{{if .link_name}} lay-text="{{.link_name}}"{{end}} class="layui-btn layui-btn-radius" id="setter">马上配置</a>
                </div>
            {{end -}}
        </div>
    </div>
    <div class="layui-card-body">
        {{.content}}
    </div>
</div>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let main = layui.main;
        $('#setter').off('click').on('click', function () {
            setTimeout(layui.layer.closeAll, 2000);
        });
        {{.js}}
    });
</script>