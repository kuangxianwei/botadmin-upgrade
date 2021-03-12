<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <label class="layui-form-label">用户名:</label>
            <div class="layui-input-inline">
                <input type="text" name="username" value="{{.obj.Username}}" required lay-verify="required"
                       class="layui-input" autocomplete="off"
                       placeholder="6-15个字符，由字母、数字、下划线组成"{{if ne .obj.Id 0}} disabled{{end}}>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">密码:</label>
            <div class="layui-input-inline">
                <input type="text" name="password" value="{{.obj.Password}}" autocomplete="off"
                       placeholder="6-15个字符，由字母、数字、下划线组成" class="layui-input">
            </div>
            <div class="layui-form-mid layui-word-aux">留空为8位随机密码</div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">确认密码:</label>
            <div class="layui-input-inline">
                <input type="password" name="password2" value="{{.obj.Password}}" placeholder="请确认新密码"
                       autocomplete="off"
                       class="layui-input">
            </div>
            <div class="layui-form-mid layui-word-aux">留空为8位随机密码</div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">数据库名:</label>
            <div class="layui-input-inline">
                <input type="text" name="dbname" value="{{.obj.Dbname}}" autocomplete="off"
                       placeholder="留空为用户名" class="layui-input"{{if ne .obj.Id 0}} disabled{{end}}>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">数据库前缀:</label>
            <div class="layui-input-inline">
                <input type="text" name="prefix" value="{{.obj.Prefix}}" placeholder="bot_" class="layui-input">
            </div>
            <div class="layui-form-mid layui-word-aux">字母开头下划线结尾 如：bot_</div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">数据库编码:</label>
            <div class="layui-input-block">
                <input type="radio" name="charset" value="utf8mb4"
                       title="utf8mb4"{{if eq .obj.Charset "utf8mb4"}} checked{{end}}>
                <input type="radio" name="charset" value="gbk"
                       title="gbk"{{if eq .obj.Charset "gbk"}} checked{{end}}>
                <input type="radio" name="charset" value="latin1"
                       title="latin1"{{if eq .obj.Charset "latin1"}} checked{{end}}>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">主机名:</label>
            <div class="layui-input-inline">
                <textarea name="hosts" class="layui-textarea">{{join .obj.Hosts "\n"}}</textarea>
            </div>
            <div class="layui-form-mid layui-word-aux">指定IP访问 10.211.55.2 一行一个</div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">备注:</label>
            <div class="layui-input-block">
                <input type="text" name="note" value="{{.obj.Note}}" autocomplete="off"
                       placeholder="备注" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item layui-hide">
            <input type="hidden" name="site_id" value="{{.obj.SiteId}}">
            <input type="hidden" name="id" value="{{.obj.Id}}">
            <button type="submit" lay-submit>保存</button>
        </div>
    </div>
</div>
