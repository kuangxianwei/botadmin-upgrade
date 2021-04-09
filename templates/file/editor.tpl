{{template "file/modify.tpl" .}}
<script>
    function loadJS(url) {
        let _doc = document.getElementsByTagName('head')[0], js = document.createElement('script');
        js.setAttribute('type', 'text/javascript');
        js.setAttribute('src', url);
        _doc.appendChild(js);
        js.onload = function () {
            layui.use(['index', 'main'], function () {
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
        }
    }

    if (typeof layui === 'undefined') {
        loadJS('/static/layui/layui.js');
    } else {
        layui.use(['index', 'main'], function () {
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
    }
</script>
