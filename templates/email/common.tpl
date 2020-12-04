<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <label class="layui-form-label">服务器:</label>
            <div class="layui-input-inline">
                <input type="text" name="host" lay-verify="required" autocomplete="off"
                       class="layui-input" placeholder="服务器地址" value="{{.obj.Host}}">
            </div>
            <div class="layui-form-mid layui-word-aux">smtp.qq.com:25</div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">用户名:</label>
            <div class="layui-input-inline">
                <input type="text" name="username" lay-verify="required" autocomplete="off"
                       class="layui-input" placeholder="邮箱用户名" value="{{.obj.Username}}">
            </div>
            <div class="layui-form-mid layui-word-aux">38050123@qq.com</div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">密码:</label>
            <div class="layui-input-inline">
                <input type="password" name="password" autocomplete="off" lay-verify="required"
                       class="layui-input" placeholder="邮箱登录密码" value="{{.obj.Password}}">
            </div>
            <div class="layui-form-mid layui-word-aux">邮箱登录密码</div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">发送到:</label>
            <div class="layui-input-inline">
                <textarea name="to" class="layui-textarea"
                          rows="3">{{join .obj.To "\n"}}</textarea>
            </div>
            <div class="layui-form-mid layui-word-aux">目标邮箱 一行一个</div>
        </div>
        <div class="layui-form-item layui-hide">
            <input name="id" value="{{.obj.Id}}">
            <button lay-submit>提交</button>
        </div>
    </div>
</div>
