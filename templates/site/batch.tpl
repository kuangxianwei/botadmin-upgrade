<div class="layui-card">
    <div class="layui-card-header">一行一个主域名，如需更多配置 用JSON格式
        www.botadmin.cn或{"wap_host":"m.botadmin.cn"}
        <a class="layui-btn" lay-href="/site/label">查看全部标签</a></div>
    <div class="layui-card-body layui-form">
        <div class="layui-form-item layui-form-text">
            <div class="layui-input-block">
                <textarea id="addMany" class="layui-textarea" name="content" rows="16" lay-verify="required">{"vhost":"www.nfivf.com", "title":"", "sql_enabled":true}</textarea>
            </div>
        </div>
        <div class="layui-form-item layui-hide">
            <div class="layui-input-block">
                <button class="layui-btn" lay-submit lay-filter="">提交</button>
            </div>
        </div>
    </div>
</div>
<script>
    layui.use(['index', 'main'], function () {
        $("#addMany").on('keypress', function (e) {
            if (e.keyCode === 13) {
                let $this = $(this),
                    val = $this.val(),
                    position = $this.getPosition();
                $(this).insertAt((val.indexOf('\n', position - 1) === val.indexOf('\n', position) ? '\n' : '') + '{"vhost":"www.nfivf.com", "title":"", "sql_enabled":true}');
            }
        });
    });
</script>