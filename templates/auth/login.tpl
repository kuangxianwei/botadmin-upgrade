<link rel="stylesheet" href="/static/style/login.css" media="all">
<div class="layadmin-user-login layadmin-user-display-show" id="LAY-user-login">
    <div class="layadmin-user-login-main">
        <div class="layadmin-user-login-box layadmin-user-login-header">
            <h2>{{.server_name}}</h2>
            <p>电话/微信: 13724184818</p>
        </div>
        <div class="layadmin-user-login-box layadmin-user-login-body layui-form">
            <div class="layui-form-item">
                <label class="layadmin-user-login-icon layui-icon layui-icon-username"
                       for="LAY-user-login-username"></label>
                <input type="text" name="username" id="LAY-user-login-username" lay-verify="required" placeholder="用户名"
                       class="layui-input">
            </div>
            <div class="layui-form-item">
                <label class="layadmin-user-login-icon layui-icon layui-icon-password"
                       for="LAY-user-login-password"></label>
                <input type="password" name="password" id="LAY-user-login-password" lay-verify="required"
                       placeholder="密码" class="layui-input">
                <input type="hidden" name="csrf.Token" value="{{.token}}">
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
            url = {{.current_uri}},
            referer = function () {
                let reg = new RegExp("(^|&)next=([^&]*)(&|$)"),
                    rs = window.location.search.substr(1).match(reg),
                    next = rs !== null && rs.length === 4 ? rs[2] : '/';
                if (/^\/(logout|login)\b/i.test(next) || next === '') {
                    return '/';
                }
                return unescape(next)
            }();
        form.render();
        $('[name="username"]').focus().keydown(function (event) {
            if (event.keyCode === 13 && this.value) {
                $('[name="password"]').focus();
            }
        });
        $('[name="password"]').focus(function () {
            $('[name="password"]').keydown(function (event) {
                if (event.keyCode === 13 && this.value) {
                    $('[lay-filter="login-submit"]').click();
                }
            });
        });
        //自定义验证
        form.verify({
            nickname: function (value) { //value：表单的值、item：表单的DOM对象
                if (!new RegExp("^[a-zA-Z0-9_\u4e00-\u9fa5\\s·]+$").test(value)) {
                    return '用户名不能有特殊字符';
                }
                if (/(^_)|(__)|(_+$)/.test(value)) {
                    return '用户名首尾不能出现下划线\'_\'';
                }
                if (/^\d+\d+\d$/.test(value)) {
                    return '用户名不能全为数字';
                }
            },
            //我们既支持上述函数式的方式，也支持下述数组的形式
            //数组的两个值分别代表：[正则匹配、匹配不符时的提示文字]
            pass: [
                /^[\S]{6,12}$/, '密码必须6到12位，且不能出现空格'
            ]
        });
        //提交
        form.on('submit(login-submit)', function (obj) {
            main.req({
                data: obj.field,
                url: url,
                ending: function () {
                    location.href = referer;
                }
            });
            return false;
        });
        main.formData();
    });
</script>