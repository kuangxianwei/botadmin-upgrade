<div class="layui-card">
    <div class="layui-card-header">运行shell命令 只能运行非交互或非持续命令。</div>
    <div class="layui-card-body">
        <div class="layui-form">
            <div class="layui-form-item">
                <label class="layui-form-label">输入命令</label>
                <div class="layui-input-inline" style="width:794px">
                    <input type="text" name="cmd" autocomplete="off" class="layui-input" required
                           lay-verify="required">
                </div>
                <button class="layui-btn layui-btn-primary layui-btn-small" lay-submit lay-filter="execute">运行
                </button>
            </div>
        </div>
        <hr/>
        <div class="layui-form-item">
            <label class="layui-form-label">运行结果</label>
            <div class="layui-input-block">
                <textarea name="note" class="layui-textarea" style="width:850px;height:300px;"></textarea>
            </div>
        </div>
    </div>
</div>
{{template "JS" -}}
<script>
    JS.use(['index', 'main'], function () {
        layui.form.on('submit(execute)', function (obj) {
            $('.layui-textarea').text("");
            $.ajax({
                type: 'post',
                url: '/system/cmd',
                data: obj.field,
                headers: {'X-CSRF-Token': $('meta[name=csrf_token]').attr('content')},
                success: function (res) {
                    $('.layui-textarea').text(res);
                }
            });
            return false;
        });
    });
</script>
