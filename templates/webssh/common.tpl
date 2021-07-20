<div class="layui-card">
    <div class="layui-card-body layui-form" id="form">
        <div class="layui-form-item">
            <label class="layui-form-label">别名:</label>
            <div class="layui-input-inline">
                <input type="text" name="alias" placeholder="本机" value="{{.obj.Alias}}" class="layui-input">
            </div>
            <div class="layui-form-mid layui-word-aux">留空自动填充为host</div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">Host:</label>
                <div class="layui-input-inline">
                    <input type="text" name="host" placeholder="host" value="{{.obj.Host}}" class="layui-input" lay-verify="required">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">Port:</label>
                <div class="layui-input-inline">
                    <input type="number" name="port" placeholder="port" value="{{.obj.Port}}" class="layui-input" lay-verify="required">
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">认证类型:</label>
            <div class="layui-input-block">
                <input type="radio" name="auth" value="pwd" title="密码认证"
                       lay-filter="auth"{{if eq .obj.Auth "pwd"}} checked{{end}}>
                <input type="radio" name="auth" value="key" title="秘钥认证" lay-filter="auth"{{if eq .obj.Auth "key"}} checked{{end}}>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">User:</label>
                <div class="layui-input-inline">
                    <input type="text" name="user" placeholder="user" value="{{.obj.User}}" class="layui-input" lay-verify="required">
                </div>
            </div>
            <div class="layui-inline" id="auth">
                {{if eq .obj.Auth "pwd" -}}
                    <label class="layui-form-label">Passwd:</label>
                    <div class="layui-input-inline">
                        <input type="password" name="passwd" placeholder="passwd" value="{{.obj.Passwd}}" class="layui-input" lay-verify="required">
                    </div>
                {{else -}}
                    <label class="layui-form-label">SSH-KEY:</label>
                    <div class="layui-input-block">
                        <textarea name="ssh_key" class="layui-textarea" lay-verify="required">{{.obj.SshKey}}</textarea>
                    </div>
                {{end -}}
            </div>
        </div>
        <input type="hidden" name="id" value="{{.obj.Id}}">
        <button class="layui-hide" lay-submit></button>
    </div>
</div>
<script>
    layui.use(['index', 'main'], function () {
        let form = layui.form,
            defaultData ={{.obj}};
        if (!defaultData) {
            defaultData = {
                alias: "本机",
                host: "127.0.0.1",
                port: 22,
                auth: "pwd",
                user: "root",
                passwd: "",
                ssh_key: ""
            };
        }
        form.on('radio(auth)', (obj) => {
            let authElem = $('#auth');
            authElem.empty();
            if (obj.value === "pwd") {
                authElem.html(`<label class="layui-form-label">Passwd:</label>
                    <div class="layui-input-inline">
                        <input type="password" name="passwd" placeholder="passwd" value="` + defaultData.passwd + `" class="layui-input" lay-verify="required">
                    </div>`);
            } else {
                authElem.html(`<label class="layui-form-label">SSH-KEY:</label>
                    <div class="layui-input-block">
                        <textarea name="ssh_key" class="layui-textarea" lay-verify="required">` + defaultData.ssh_key + `</textarea>
                    </div>`);
            }
            form.render();
        });
    });
</script>

