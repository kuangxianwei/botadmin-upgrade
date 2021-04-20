<div class="layui-card" style="overflow-x: hidden;">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <label class="layui-form-label">启用:</label>
            <div class="layui-input-inline">
                <input type="checkbox" lay-skin="switch" lay-text="启用|禁用" name="enabled"{{if .obj.Enabled}} checked{{end}}>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" lay-tips="指定执行任务范围">范围:</label>
            <div class="layui-input-block">
                <div id="range" class="slider-block"></div>
                <input type="hidden" name="range" class="layui-input" value="{{print .obj.Range}}">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">Cron:</label>
            <div class="layui-input-inline">
                <input type="text" name="spec" class="layui-input" value="{{.obj.Spec}}">
            </div>
            <div class="layui-form-mid layui-word-aux">定时执行任务</div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">来路:</label>
            <div class="layui-input-block">
                <input type="text" name="referer" class="layui-input" value="{{.obj.Referer}}">
            </div>
        </div>
        <div class="layui-form-item layui-hide">
            <input name="id" value="{{.obj.Id}}">
            <button lay-submit=""></button>
        </div>
    </div>
</div>
<script>
    layui.use(['main'], function () {
        let main = layui.main,
            count ={{.count}};
        main.cron('[name="spec"]');
        main.slider({elem: '#range', range: true, min: 1, max: count || 0});
    });
</script>
