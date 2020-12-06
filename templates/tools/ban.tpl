<div class="layui-card">
    <div class="layui-card-header layuiadmin-card-header-auto layui-form">
        <div class="layui-form-item">
            <textarea class="layui-textarea layui-bg-black" name="content" rows="12"
                      style="color: white;"></textarea>
        </div>
        <div class="layui-form-item">
            <div class="layui-btn-group">
                <button class="layui-btn layui-btn-sm" lay-submit lay-filter="submit">提交</button>
                <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="reset">重置</button>
            </div>
        </div>
        <div class="layui-form-item">
            <textarea class="layui-textarea layui-bg-black layui-hide" rows="12"
                      style="color: white;" id="display"></textarea>
        </div>
    </div>
</div>
<script src="/static/layui/layui.js"></script>
<script>
    layui.config({
        base: '/static/' // 静态资源所在路径
    }).extend({
        index: 'lib/index', // 主入口模块
        main: 'main',
    }).use(['index', 'main'], function () {
        let $ = layui.$,
            form = layui.form,
            layer = layui.layer,
            main = layui.main;
        form.on('submit(submit)', function (obj) {
            let content = obj.field.content.trim()
            if (content.length === 0) {
                layer.alert("输入源为空", {icon: 2});
                return false;
            }
            main.req({
                url: '/tools/ban',
                data: {content: content},
                ending: function (res) {
                    $('#display').removeClass('layui-hide').val(res.data);
                }
            });
        });
        //清空值并且聚焦
        $('button[lay-event=reset]').click(function () {
            $('#display').addClass('layui-hide').val('');
            $('textarea[name=content]').val('').focus();
        });
    });
</script>