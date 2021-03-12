<div class="layui-row layui-col-space15">
    <div class="layui-card">
        <div class="layui-card-header">时间设置</div>
        <div class="layui-card-body">
            <div class="layui-form-item">
                <label class="layui-form-label" style="width:100px">当前时间</label>
                <div class="layui-form-mid layui-word-aux">{{.NowTime}}</div>
                <div class="layui-input-block">
                    <button class="layui-btn layui-btn-mini" id="ntpdate">
                        <i class="layui-icon iconfont icon-refresh"></i>同步时间
                    </button>
                </div>
            </div>
            <blockquote class="layui-elem-quote">
                同步时间以中国/上海时区,新浪时间源为准
            </blockquote>
        </div>
    </div>
</div>
{{template "JS" -}}
<script>
    JS.use(['index', 'main'], function () {
        let url = '/system/time';
        $("#ntpdate").click(function () {
            layer.confirm("确定要同步时间？", function () {
                let loading = layer.load(1, {shade: [0.5, '#000']});
                window.location.replace(url + "?act=ntpdate", function () {
                    layer.close(loading)
                });
            });
        });
    });
</script>
