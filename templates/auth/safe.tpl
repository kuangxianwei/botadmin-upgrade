<div class="layui-card">
    <div class="layui-card-header">登录安全设置</div>
    <div class="layui-card-body layui-form">
        <div class="layui-form" lay-filter="component-form-element">
            <div class="layui-form-item">
                <label class="layui-form-label" lay-tips="登录错误次数超过将限制N分钟后登录,0为不限制录">登录限制:</label>
                <div class="layui-input-block">
                    <div id="login_limit" class="slider-block"></div>
                    <input type="hidden" name="login_limit" value="{{.obj.LoginLimit}}">
                </div>
            </div>
            <div class="layui-form-item">
                <label for="addr" class="layui-form-label">授权域名:</label>
                <div class="layui-input-inline">
                    <input type="text" autocomplete="off" name="addr" id="addr" value="{{.obj.Addr}}" class="layui-input"/>
                </div>
                <div class="layui-form-mid layui-word-aux">设置后只可使用该域名访问后台,不可以包含http://</div>
            </div>
            <div class="layui-form-item">
                <label for="port" class="layui-form-label">指定端口:</label>
                <div class="layui-input-inline">
                    <input type="number" autocomplete="off" name="port" id="port" min="80" value="{{.obj.Port}}" class="layui-input"/>
                </div>
                <div class="layui-form-mid layui-word-aux">设置后只可使用该端口号访问后台,建议5000-9000</div>
            </div>
            <div class="layui-form-item">
                <div class="layui-input-block">
                    <button class="layui-btn" lay-submit lay-filter="submit">立即提交</button>
                </div>
            </div>
        </div>
        <blockquote class="layui-elem-quote">
            重新启动重新后生效
        </blockquote>
    </div>
</div>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let main = layui.main,
            form = layui.form;
        form.on('submit(submit)', function (obj) {
            main.request({data: obj.field});
            return false;
        });
        main.slider({elem: '#login_limit', value: $('input[name=login_limit]').val(), min: 0, max: 10});
    });
</script>