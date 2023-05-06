<div class="layui-card">
    <div class="layui-card-body layui-form" id="theme-form">
        <div class="layui-hide">
            <input name="driver" value="{{.obj.Driver}}">
            <input name="id" value="{{.obj.Id}}">
            <button lay-submit></button>
            <div id="uploadSubmit"></div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label" lay-tips="由3-30个英文数字或下划线组成">名称:</label>
                <div class="layui-input-inline">
                    <input type="text" name="name" value="{{.obj.Name}}" lay-verify="required" placeholder="blog-1" class="layui-input"{{if gt .obj.Id 0}} disabled{{end}}>
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">别名:</label>
                <div class="layui-input-inline">
                    <input type="text" name="alias" value="{{.obj.Alias}}" placeholder="仿博客模板" class="layui-input">
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">简介:</label>
            <div class="layui-input-block">
                <textarea name="intro" class="layui-textarea" placeholder="这个模板是仿www.xxx.com的博客模板">{{.obj.Intro}}</textarea>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">主题包:</label>
            <div class="layui-input-inline">
                <div class="layui-upload-drag" id="uploadPackage">
                    <i class="layui-icon layui-icon-upload-drag"></i>
                    <p>点击上传主题包,或将主题包拖拽到此处!</p>
                </div>
            </div>
            <div class="layui-form-mid layui-word-aux" id="packageName">
                <cite></cite>
                <p>只允许上传.tar.gz格式的压缩主题包</p></div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">Tags:</label>
            <div class="layui-form-mid layui-word-aux" id="tags-box"></div>
            <div class="layui-input-inline">
                <input type="text" class="layui-input" placeholder="用空格分隔多个标签" lay-event="tags">
                <input type="hidden" name="tags" value="{{join .obj.Tags ","}}">
            </div>
        </div>
    </div>
</div>
<script>
    layui.main.tags();
</script>
