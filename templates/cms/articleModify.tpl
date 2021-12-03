<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <label class="layui-form-label">标题:</label>
            <div class="layui-input-block">
                <input type="text" name="title" value="{{.obj.Title}}" lay-verify="required" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-row">
                <div class="layui-col-md6">
                    <label class="layui-form-label">关键词:</label>
                    <div class="layui-input-block">
                        <input type="text" name="keywords" value="{{join .obj.Keywords ","}}" class="layui-input">
                    </div>
                </div>
                <div class="layui-col-md6">
                    <label class="layui-form-label">Tags:</label>
                    <div class="layui-input-block">
                        <input type="text" name="tags" value="{{join .obj.Tags ","}}" class="layui-input">
                    </div>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">描述:</label>
            <div class="layui-input-block">
                <input type="text" name="description" value="{{.obj.Description}}" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">标题图片:</label>
            <div class="layui-input-block">
                <input type="text" name="title_pic" value="{{.obj.TitlePic}}" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">内容:</label>
            <div class="layui-input-block">
                <textarea name="content" class="layui-textarea" rows="12" lay-verify="required">{{.obj.Content}}</textarea>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" lay-tips="标准的json格式">其他:</label>
            <div class="layui-input-block">
                <textarea name="more" class="layui-textarea">{{json .obj.More}}</textarea>
            </div>
        </div>
        <div class="layui-form-item layui-hide">
            <input type="hidden" name="id" value="{{.id}}" disabled>
            <input type="hidden" name="ids" value="{{.obj.Id}}" disabled>
            <button lay-submit>提交</button>
        </div>
    </div>
</div>