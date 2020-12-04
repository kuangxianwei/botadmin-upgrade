{{template "file/modify.html" .}}
<script src="/static/layui/layui.js"></script>
<script>
    layui.config({
        base: '/static/' //静态资源所在路径
    }).extend({
        index: 'lib/index', //主入口模块
        main: 'main'
    }).use(['index', 'form', 'main'], function () {
        let $ = layui.$,
            form = layui.form,
            main = layui.main,
            index = parent.layer.getFrameIndex(window.name),
            url = {{.current_uri}};
        form.render();
        $('.layui-form button[lay-submit]').attr('lay-filter', 'submit');
        form.on('submit(submit)', function (obj) {
            main.req({
                url: url,
                data: obj.field,
                ending: function () {
                    parent.layer.close(index);
                }
            });
            return false;
        });
        $('[lay-filter=cancel]').on('click', function () {
            parent.layer.close(index);
            return false;
        });
        $('#btnClear').on('click', function () {
            $('textarea[name=content]').text('').focus();
        });
    });
</script>
