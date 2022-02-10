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
            <pre id="editor"></pre>
        </div>
    </div>
    <div class="layui-card-body">
        <div class="layui-form-item">
            <textarea class="layui-textarea" name="content" rows="22" id="editor">{{ .content }}</textarea>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block">
                <button type="submit" class="layui-btn layui-btn-small" lay-submit lay-filter="submit">保存</button>
                <button class="layui-btn layui-btn-primary layui-btn-small" onclick="window.location.reload()">取消
                </button>
            </div>
        </div>
    </div>
</div>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let form = layui.form,
            main = layui.main;
        let mimetype = {{.mimetype}};
        form.render();
        $('.layui-form button[lay-submit]').attr('lay-filter', 'submit');
        form.on('submit(submit)', function (obj) {
            main.req({
                url: url,
                data: obj.field
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
<style>
    #editor {
        margin: 0;
        top: 0;
        bottom: 0;
        left: 0;
        right: 0;
    }
</style>
<script src="/static/ace/ace.js" type="text/javascript" charset="utf-8"></script>
<script src="/static/ace/ext-modelist.js"></script>
<script>
    const editor = ace.edit("editor", {
        theme: "ace/theme/twilight",
        mode: ace.require("ace/ext/modelist").getModeForPath("/static/ace/ace.js").mode,
        autoScrollEditorIntoView: true,
        maxLines: 30,
        minLines: 2,
        value: "9999922222222"
    });
</script>