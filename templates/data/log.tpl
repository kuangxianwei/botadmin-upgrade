<div class="layui-card-body layui-form">
    <div class="layui-form-item">
            <textarea class="layui-textarea layui-bg-black" name="log" rows="20"
                      style="color: white;">{{.log}}</textarea>
    </div>
    <div class="layui-hide">
        <input name="id" value="{{.obj.Id}}">
        <button class="layui-btn" lay-submit lay-filter="submit"></button>
    </div>
</div>
