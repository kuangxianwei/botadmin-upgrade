<div class="layui-card layui-form">
    <div class="layui-card-header">
        <div class="layui-form-item">
            <label class="layui-form-label">当前文件</label>
            <div class="layui-input-block">
                <div class="layui-col-md12" id="filepath">{{ .path }}</div>
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
        let mimetype = $.extend({{.mimetype}}, {});
        console.log(mimetype.type);

        if (/\/theme\/.*?\w+\.tpl$/i.test($('#current-filename').val())) {
            layui.main.onFillTheme();
        }
    });
</script>


<style>
    #editor {
        position: absolute;
        margin: 0;
        top: 0;
        bottom: 0;
        left: 0;
        right: 0;
    }
</style>
<pre id="editor" style="height: 300px;">function foo(items) {
    var i;
    for (i = 0; i &lt; items.length; i++) {
        alert("Ace Rocks " + items[i]);
    }
}</pre>
<script src="/static/ace/ace.js" type="text/javascript" charset="utf-8"></script>
<script>
    const editor = ace.edit("editor");
    editor.setTheme("ace/theme/twilight");
    editor.session.setMode("ace/mode/javascript");
</script>