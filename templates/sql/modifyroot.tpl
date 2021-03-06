<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <label class="layui-form-label">密码:</label>
            <div class="layui-input-inline">
                <input type="password" name="password" lay-verify="required"
                       placeholder="6-15个字符，由字母、数字、下划线组成" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">确认密码:</label>
            <div class="layui-input-inline">
                <input type="password" name="password2" lay-verify="required"
                       placeholder="请确认新密码" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item layui-hide">
            <div class="layui-input-block">
                <button class="layui-btn" lay-submit lay-filter="submit">提交</button>
            </div>
        </div>
    </div>
</div>