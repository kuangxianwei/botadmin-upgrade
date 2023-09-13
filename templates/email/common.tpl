<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <label for="enabled" class="layui-form-label">启用:</label>
            <div class="layui-input-inline">
                <input type="checkbox" name="enabled" id="enabled" lay-skin="switch" lay-text="启用|关闭"{{if .obj.Enabled}} checked{{end}}>
            </div>
            <div class="layui-form-mid layui-word-aux">是否启用这个配置</div>
        </div>
        <div class="layui-form-item">
            <label for="host" class="layui-form-label">服务器:</label>
            <div class="layui-input-inline">
                <input type="text" name="host" id="host" lay-verify="required" class="layui-input" placeholder="服务器地址" value="{{.obj.Host}}">
            </div>
            <div class="layui-form-mid layui-word-aux">smtp.qq.com:25</div>
        </div>
        <div class="layui-form-item">
            <label for="alias" class="layui-form-label">别名:</label>
            <div class="layui-input-inline">
                <input type="text" name="alias" id="alias" lay-verify="required" class="layui-input" placeholder="nfivf.com" value="{{.obj.Alias}}">
            </div>
            <div class="layui-form-mid layui-word-aux">BotAdmin</div>
        </div>
        <div class="layui-form-item">
            <label for="username" class="layui-form-label">用户名:</label>
            <div class="layui-input-inline">
                <input type="text" name="username" id="username" lay-verify="required" class="layui-input" placeholder="邮箱用户名" value="{{.obj.Username}}">
            </div>
            <div class="layui-form-mid layui-word-aux">38050123@qq.com</div>
        </div>
        <div class="layui-form-item">
            <label for="password" class="layui-form-label">密码:</label>
            <div class="layui-input-inline">
                <input type="password" name="password" id="password" lay-verify="required" class="layui-input" placeholder="邮箱登录密码" value="{{.obj.Password}}">
            </div>
            <div class="layui-form-mid layui-word-aux">邮箱登录密码或授权码</div>
        </div>
        <div class="layui-form-item">
            <label for="id" class="layui-form-label">发送到:</label>
            <div class="layui-input-inline">
                <textarea name="to" class="layui-textarea" rows="3">{{join .obj.To "\n"}}</textarea>
            </div>
            <div class="layui-form-mid layui-word-aux">目标邮箱 一行一个</div>
        </div>
        <div class="layui-form-item layui-hide">
            <input name="id" id="id" value="{{.obj.Id}}">
            <button lay-submit>提交</button>
        </div>
    </div>
</div>