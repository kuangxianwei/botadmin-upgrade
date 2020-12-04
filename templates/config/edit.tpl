<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <textarea class="layui-textarea layui-bg-black" name="content" rows="20"
                      style="color: white;">{{.content}}</textarea>
        </div>
        <div class="layui-hide">
            <input name="name" value="{{.name}}">
            <button class="layui-btn" lay-submit lay-filter="submit"></button>
        </div>
    </div>
</div>
