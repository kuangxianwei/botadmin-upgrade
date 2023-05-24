<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <div class="layui-col-md9">
                <label for="title" class="layui-form-label">标题:</label>
                <div class="layui-input-block">
                    <input type="text" autocomplete="off" name="title" id="title" value="{{.obj.Title}}" lay-verify="required" class="layui-input">
                </div>
            </div>
            <div class="layui-col-md3">
                <label for="cid" class="layui-form-label">栏目:</label>
                <div class="layui-input-block">
                    <select class="layui-select" name="cid" id="cid" lay-search{{if ne .obj.ClassId 0}} disabled{{end}}>
                        <option value="">搜索...</option>
                        {{range .classes -}}
                            <option value="{{.Id}}"{{if eq $.obj.ClassId .Id}} selected{{end}}>{{.Name}}</option>
                        {{end -}}
                    </select>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-row">
                <div class="layui-col-md6">
                    <label for="keywords" class="layui-form-label">关键词:</label>
                    <div class="layui-input-block">
                        <input type="text" autocomplete="off" name="keywords" id="keywords" value="{{join .obj.Keywords ","}}" class="layui-input">
                    </div>
                </div>
                <div class="layui-col-md6">
                    <label for="tags" class="layui-form-label">Tags:</label>
                    <div class="layui-input-block">
                        <input type="text" autocomplete="off" name="tags" id="tags" value="{{join .obj.Tags ","}}" class="layui-input">
                    </div>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <label for="description" class="layui-form-label">描述:</label>
            <div class="layui-input-block">
                <input type="text" autocomplete="off" name="description" id="description" value="{{.obj.Description}}" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label for="title_pic" class="layui-form-label">标题图片:</label>
            <div class="layui-input-block">
                <input type="text" autocomplete="off" name="title_pic" id="title_pic" value="{{.obj.TitlePic}}" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label for="id" class="layui-form-label">内容:</label>
            <div class="layui-input-block">
                <textarea name="content" class="layui-textarea" rows="12" lay-verify="required" id="editor">{{.obj.Content}}</textarea>
            </div>
        </div>
        <div class="layui-form-item">
            <label for="id" class="layui-form-label" lay-tips="标准的json格式">其他:</label>
            <div class="layui-input-block">
                <textarea name="more" class="layui-textarea" placeholder="{&#13;&#34;level&#34;: 0&#13;}">{{json .obj.More}}</textarea>
            </div>
        </div>
        <div class="layui-form-item layui-hide">
            <input type="hidden" name="id" value="{{.id}}" disabled>
            <input type="hidden" name="ids" value="{{.obj.Id}}" disabled>
            <button lay-submit>提交</button>
        </div>
    </div>
</div>
<link href="/static/codemirror/lib/codemirror.css" rel="stylesheet">
<link href="/static/codemirror/theme/3024-night.css" rel="stylesheet">
<script src="/static/codemirror/lib/codemirror.js"></script>
<script src="/static/codemirror/mode/javascript/javascript.js"></script>
<script>
    CodeMirror.fromTextArea(document.getElementById("editor"), {
        lineNumbers: true,
        styleActiveLine: true,
        matchBrackets: true,
        theme: "3024-night",
    });
</script>