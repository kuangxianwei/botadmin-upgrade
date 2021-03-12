{{template "file/modify.tpl" .}}
{{template "JS" -}}
<script>
    JS.use(['index', 'main'], function () {
        let form = layui.form,
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
