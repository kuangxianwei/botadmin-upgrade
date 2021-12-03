<div class="layui-card layui-form">
    <div class="layui-card-header">
        <div class="layui-form-item">
            <label class="layui-form-label">当前文件</label>
            <div class="layui-input-inline">
                <div class="layui-form-mid" style="width:700px">{{ .path }}</div>
                <input name="path" type="hidden" value="{{ .path }}"/>
                <input name="act" type="hidden" value="editor"/>
                <input name="url" type="hidden" value="/file/editor"/>
            </div>
        </div>
    </div>
    <div class="layui-card-body">
        <div class="layui-form-item">
            <textarea class="layui-textarea" name="content" rows="22">{{ .content }}</textarea>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block">
                <button type="submit" class="layui-btn layui-btn-small" lay-submit lay-filter="submit">保存</button>
                <button class="layui-btn layui-btn-primary layui-btn-small" onclick="window.location.reload()">取消</button>
            </div>
        </div>
    </div>
</div>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let form = layui.form,
            main = layui.main,
            index = parent.layer.getFrameIndex(window.name);
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