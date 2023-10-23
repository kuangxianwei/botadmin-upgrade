<div class="layui-card">
	<div class="layui-card-body" id="show-error">
        {{.content}}
	</div>
</div>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        $('#show-error').on('click', function () {
            setTimeout(function () {
                parent.$('#LAY_app_tabsheader [lay-id="' + URL + '"] .layui-tab-close').click();
            }, 1000);
        });
    });
</script>
