<link rel="stylesheet" href="/static/adminui/dist/css/login.css" media="all">
<div class="layadmin-user-login layadmin-user-display-show" id="LAY-user-login">
    <div class="layadmin-user-login-main">
        <div class="layadmin-user-login-box layadmin-user-login-header">
            <h2>{{.server_name}}</h2>
            <p>电话/微信: 13724184818</p>
        </div>
        <div class="layadmin-user-login-box layadmin-user-login-body layui-form">
            <div class="layui-form-item">
                <label class="layadmin-user-login-icon layui-icon layui-icon-username" for="username"></label>
                <input type="text" autocomplete="off" name="username" id="username" lay-verify="required" placeholder="用户名" class="layui-input" required>
                <span></span>
            </div>
            <div class="layui-form-item">
                <label class="layadmin-user-login-icon layui-icon layui-icon-password" for="password"></label>
                <input type="password" autocomplete="off" name="password" id="password" lay-verify="required" pattern="^\S{6,18}$" placeholder="密码" class="layui-input" required>
                <span></span>
            </div>
            <div class="layui-form-item">
                <button class="layui-btn layui-btn-fluid" lay-submit lay-filter="login-submit">登 入</button>
            </div>
        </div>
    </div>
    <div class="layui-trans layadmin-user-login-footer">
        <p>版本:{{.version}}</p>
        <p>© 2018 <a href="http://www.botadmin.cn/" target="_blank">站掌门BotAdmin</a></p>
    </div>
</div>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let main = layui.main,
            form = layui.form,
            referer = layui.url().search['next'] || '/';
        form.render();
        $('[name=username]').focus().keydown(function (event) {
            if (event.keyCode === 13 && this.value) {
                $('[name=password]').focus();
            }
        });
        $('[name=password]').focus(function () {
            $('[name=password]').keydown(function (event) {
                if (event.keyCode === 13 && this.value) {
                    $('[lay-filter="login-submit"]').click();
                }
            });
        });
        //自定义验证
        form.verify({
            username: function (value) { //value：表单的值、item：表单的DOM对象
                if (!new RegExp("^[a-zA-Z0-9_\u4e00-\u9fa5\\s·]+$").test(value)) {
                    return '用户名不能有特殊字符';
                }
                if (/^_|__|_+$/.test(value)) {
                    return '用户名首尾不能出现下划线\'_\'';
                }
                if (/^\d+\d+\d$/.test(value)) {
                    return '用户名不能全为数字';
                }
            },
            //我们既支持上述函数式的方式，也支持下述数组的形式
            //数组的两个值分别代表：[正则匹配、匹配不符时的提示文字]
            password: [
                /^\S{6,18}$/, '密码必须6到12位，且不能出现空格'
            ]
        });
        //提交
        form.on('submit(login-submit)', function (obj) {
            main.request({
                data: obj.field,
                done: function (res) {
                    layer.msg(res.msg, {}, function () {
                        location.replace(referer);
                    });
                    return false;
                },
            });
            return false;
        });
    });
</script>