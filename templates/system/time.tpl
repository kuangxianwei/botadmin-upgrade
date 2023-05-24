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
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let url = '/system/time';
        $("#ntpdate").off('click').on('click', function () {
            layer.confirm("确定要同步时间？", function () {
                window.location.replace(url + "?act=ntpdate");
            });
        });
    });
</script>