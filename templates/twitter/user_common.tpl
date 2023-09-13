<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item layui-row">
            <div class="layui-col-md3">
                <label for="enabled" class="layui-form-label">启用:</label>
                <div class="layui-input-block">
                    <input type="checkbox" name="enabled" id="enabled" lay-skin="switch" lay-text="启用|禁用" title="启用|禁用"{{if .obj.Enabled}} checked{{end}}>
                </div>
            </div>
            <div class="layui-col-md9">
                <label for="status" class="layui-form-label">状态:</label>
                <div class="layui-input-block">
                    <input type="text" name="status" id="status" value="{{.obj.Status}}" class="layui-input">
                </div>
            </div>
        </div>
        <div class="layui-form-item layui-row">
            <div class="layui-col-md6">
                <label for="username" class="layui-form-label">账号:</label>
                <div class="layui-input-block">
                    <input class="layui-input" type="text" name="username" id="username" value="{{.obj.Username}}" lay-verify="required"{{if .obj.Id}} disabled{{end}}>
                </div>
            </div>
            <div class="layui-col-md6">
                <label for="password" class="layui-form-label">密码:</label>
                <div class="layui-input-block">
                    <input class="layui-input" type="text" name="password" id="password" value="{{.obj.Password}}" lay-verify="required">
                </div>
            </div>
        </div>
        <div class="layui-form-item layui-row">
            <div class="layui-col-md6">
                <label for="email" class="layui-form-label">邮箱:</label>
                <div class="layui-input-block">
                    <input class="layui-input" type="email" name="email" id="email" value="{{.obj.Email}}">
                </div>
            </div>
            <div class="layui-col-md6">
                <label for="email_password" class="layui-form-label">邮箱密码:</label>
                <div class="layui-input-block">
                    <input class="layui-input" type="text" name="email_password" id="email_password" value="{{.obj.EmailPassword}}">
                </div>
            </div>
        </div>
        <div class="layui-form-item layui-row">
            <div class="layui-col-md6">
                <label for="verify" class="layui-form-label">双验证:</label>
                <div class="layui-input-block">
                    <input class="layui-input" type="text" name="verify" id="verify" value="{{.obj.Verify}}">
                </div>
            </div>
            <div class="layui-col-md6">
                <label for="spare" class="layui-form-label">备用码:</label>
                <div class="layui-input-block">
                    <input class="layui-input" type="text" name="spare" id="spare" value="{{.obj.Spare}}">
                </div>
            </div>
        </div>
        <div class="layui-form-item layui-row">
            <div class="layui-col-md6">
                <label for="phone" class="layui-form-label">手机号码:</label>
                <div class="layui-input-block">
                    <input class="layui-input" type="tel" name="phone" id="phone" value="{{.obj.Phone}}">
                </div>
            </div>
            <div class="layui-col-md6">
                <label for="token" class="layui-form-label">Token:</label>
                <div class="layui-input-block">
                    <input class="layui-input" type="text" name="token" id="token" value="{{.obj.Token}}">
                </div>
            </div>
        </div>
        <div class="layui-form-item layui-row">
            <div class="layui-col-md6">
                <label for="alias" class="layui-form-label">网名:</label>
                <div class="layui-input-block">
                    <input name="alias" value="{{.obj.Alias}}" type="text" placeholder="五娃神父" id="alias" class="layui-input">
                </div>
            </div>
            <div class="layui-col-md6">
                <label for="description" class="layui-form-label">简介:</label>
                <div class="layui-input-block">
                    <textarea name="description" class="layui-textarea" id="description" rows="2">{{.obj.Description}}</textarea>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <label for="note" class="layui-form-label">备注:</label>
            <div class="layui-input-block">
                <input type="text" name="note" value="{{.obj.Note}}" placeholder="备注信息" id="note" class="layui-input">
            </div>
        </div>
        <div class="layui-hide">
            <input type="hidden" name="id" value="{{.obj.Id}}">
            <button class="layui-btn layui-btn-small" lay-submit id="submit">提交</button>
        </div>
    </div>
</div>