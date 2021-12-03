<div class="layui-card layui-form">
    <div class="layui-card-header">
        <div class="layui-form-item">
            <label class="layui-form-label">当前文件</label>
            <div class="layui-input-inline">
                <div class="layui-form-mid" style="width:700px">{{ .path }}</div>
                <input name="path" type="hidden" value="{{ .path }}" id="current-filename"/>
                <input name="act" type="hidden" value="editor"/>
                <input name="url" type="hidden" value="/file/editor"/>
                <button type="submit" class="layui-hide" lay-submit lay-filter="submit">保存</button>
            </div>
        </div>
    </div>
    <div class="layui-card-body">
        <div class="layui-form-item">
            <textarea class="layui-textarea" name="content" rows="22">{{ .content }}</textarea>
        </div>
        <div class="layui-form-item fill-theme layui-hide"></div>
    </div>
</div>
<script>
    layui.use(['main'], function () {
        if (/\/theme\/.*?\w+\.tpl$/i.test($('#current-filename').val())) {
            layui.main.onFillTheme();
        }
    });
</script>