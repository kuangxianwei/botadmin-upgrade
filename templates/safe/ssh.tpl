<div class="layui-row layui-col-space15">
    <div class="layui-col-md6">
        <div class="layui-card">
            <div class="layui-card-header">SSH设置</div>
            <div class="layui-card-body">
                <div class="layui-form">
                    <div class="layui-form-item">
                        <label class="layui-form-label">修改端口</label>
                        <div class="layui-input-inline" style="width:100px">
                            <input type="text" name="port" value="{{.sshPort}}" required lay-verify="number"
                                   placeholder="{{.sshPort}}" autocomplete="on"
                                   class="layui-input layui-input-small">
                        </div>
                        <div class="layui-input-inline">
                            <button class="layui-btn" lay-submit lay-filter="port-submit" lay-submit>修改</button>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label" style="width:100px">允许root登录</label>
                        <div class="layui-input-block">
                            <input type="checkbox" lay-skin='switch' lay-text="开启|关闭"
                                   lay-filter="used_root"{{if .usedRoot}} checked{{end}}>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label" style="width:100px">使用DNS解析</label>
                        <div class="layui-input-block">
                            <input type="checkbox" lay-skin='switch' lay-text="开启|关闭"
                                   lay-filter="used_dns"{{if .usedDns}} checked{{end}}>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="layui-col-md6">
        <div class="layui-card">
            <div class="layui-card-header">登录安全设置</div>
            <div class="layui-card-body">
                <div class="layui-form">
                    <div class="layui-form-item">
                        <label class="layui-form-label" style="width:100px">公钥验证登录</label>
                        <div class="layui-input-block">
                            <div class="layui-form-mid">
                                {{if .existRsa -}}
                                    <button class="layui-btn layui-btn-mini" data-type="recreate_key">重新生成密钥
                                    </button>
                                    <button class="layui-btn layui-btn-primary layui-btn-mini"
                                            lay-href="/file?path=/root/.ssh">管理SSH
                                    </button>
                                {{else -}}
                                    <button class="layui-btn layui-btn-mini" data-type="create_key">首次生成密钥</button>
                                {{end}}
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label" style="width:100px">密码验证登录</label>
                        <div class="layui-input-block">
                            <input type="checkbox" lay-skin='switch' lay-text="开启|关闭"
                                   lay-filter="used_password"{{if .usedPassword}} checked{{end}}>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="layui-row layui-col-space15">
    <blockquote class="layui-elem-quote">
        1:修改后需要重启SSH才会生效，现在就
        <button class="layui-btn layui-btn-sm" data-type="restart_sshd">重启</button>
        <br/>
        2:禁止使用DNS解释，能加快ssh的连接速度<br>
        3:修改端口前，需要在防火墙里开通相应端口，否则会无法连接<br>
        4:默认私钥密码为空，可生成后修改<br>
        5:关闭密码验证登录，也就是只能使用密钥文件登录方式<br>
        6:如果是使用PuTTy登录，需要使用puttygen生成.ppk格式的文件方可正常使用
    </blockquote>
</div>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let main = layui.main,
            form = layui.form;

        //修改端口号
        form.on('submit(port-submit)', function (obj) {
            let field = obj.field;
            field.act = 'modify_port';
            main.req({
                url: url,
                data: field,
            });
            return false;
        });

        //允许或禁止root登录
        form.on('switch(used_root)', function (obj) {
            main.req({
                url: url,
                data: {'act': 'used_root', 'switch': obj.elem.checked},
                done: function (res) {
                    layer.msg(res.msg);
                }
            });
            return false;
        });
        form.on('switch(used_dns)', function (obj) {
            main.req({
                url: url,
                data: {'act': 'used_dns', 'switch': obj.elem.checked},
            });
            return false;
        });
        form.on('switch(used_password)', function (obj) {
            main.req({
                url: url,
                data: {'act': 'used_password', 'switch': obj.elem.checked},
            });
            return false;
        });
        let active = {
            restart_sshd: function () {
                main.req({
                    url: url,
                    data: {'act': 'restart'},
                });
            },
            create_key: function () {
                main.req({
                    url: url,
                    data: {'act': 'create_key'},
                    ending: function () {
                        location.reload();
                        return false;
                    },
                });
            },
            recreate_key: function () {
                layer.confirm('重新生成会删除以前生成的key,确定生成？', function () {
                    main.req({
                        url: url,
                        data: {'act': 'create_key'},
                    });
                });
            },
        };

        $('.layui-btn').on('click', function () {
            let type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });

    });
</script>
