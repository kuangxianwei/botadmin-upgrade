<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <label for="username" class="layui-form-label">账号:</label>
            <div class="layui-input-block">
                <input class="layui-input" type="text" name="username" id="username" value="{{.obj.Username}}">
            </div>
        </div>
        <div class="layui-form-item">
            <label for="password" class="layui-form-label">密码:</label>
            <div class="layui-input-block">
                <input class="layui-input" type="text" name="password" id="password" value="{{.obj.Password}}">
            </div>
        </div>
        <div class="layui-form-item">
            <label for="key" class="layui-form-label">Key:</label>
            <div class="layui-input-block">
                <input type="text" name="key" value="{{.obj.Key}}" placeholder="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" id="key" class="layui-input">
            </div>
        </div>
        <div class="layui-hide">
            <input type="hidden" name="id" value="{{.obj.Id}}">
            <button class="layui-hide" lay-submit id="submit">提交</button>
        </div>
    </div>
</div>