<div class="layui-card">
    <div class="layui-card-body layui-form" id="youdao">
        <div class="layui-form-item">
            <label for="enabled" class="layui-form-label">启用:</label>
            <div class="layui-input-block">
                <input type="checkbox" name="enabled" id="enabled"
                       lay-skin="switch" lay-text="启用|关闭"{{if .obj.Enabled}} checked{{end}}>
            </div>
        </div>
        <div class="layui-form-item">
            <label for="app_id" class="layui-form-label" lay-tips="翻译平台获取">AppId:</label>
            <div class="layui-input-block">
                <input type="text" autocomplete="off" name="app_id" id="app_id" value="{{.obj.AppId}}" lay-verify="required"
                       placeholder="翻译平台获取" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label for="token" class="layui-form-label" lay-tips="翻译平台获取">Token:</label>
            <div class="layui-input-block">
                <input type="text" autocomplete="off" name="token" id="token" value="{{.obj.Token}}"
                       placeholder="翻译平台获取" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label for="delay" class="layui-form-label">源语言:</label>
                <div class="layui-input-inline">
                    {{.source}}
                </div>
            </div>
            <div class="layui-inline">
                <label for="delay" class="layui-form-label-col" style="color: #009688;">
                    <i class="layui-icon layui-icon-spread-left"></i>
                </label>
            </div>
            <div class="layui-inline">
                <label for="delay" class="layui-form-label">目标语言:</label>
                <div class="layui-input-inline">
                    {{.target}}
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <label for="delay" class="layui-form-label">延时:</label>
            <div class="layui-input-inline">
                <input type="text" autocomplete="off" name="delay" id="delay" value="{{print .obj.Delay}}" placeholder="输入秒"
                       class="layui-input">
            </div>
            <div class="layui-form-mid layui-word-aux">每次请求间隔多少秒</div>
        </div>
        <div class="layui-form-item">
            <label for="strict" class="layui-form-label">是否:</label>
            <div class="layui-input-inline">
                <input type="checkbox" name="strict" id="strict"
                       lay-skin="switch" lay-text="是|否"{{if .obj.Strict}} checked{{end}}>
            </div>
            <div class="layui-form-mid layui-word-aux">是否严格按照指定source和target进行翻译</div>
        </div>
        <div class="layui-form-item layui-hide">
            <input type="hidden" name="id" value="{{.obj.Id}}">
            <button lay-submit>提交</button>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label"></label>
            <button class="layui-btn layui-btn-radius" lay-filter="test">测试</button>
        </div>
    </div>
</div>
{{template "tanslatorTest.tpl" .}}
<script>
    layui.use(['index', 'main'], function () {
        let main = layui.main;
        $('[lay-filter="test"]').off('click').on('click', function () {
            let data = main.formData("#youdao");
            if (!data.app_id || !data.token) {
                main.error('AppId或者token为空');
                return false;
            }
            layer.open({
                type: 1,
                shadeClose: true,
                scrollbar: false,
                btnAlign: 'c',
                shade: 0.8,
                fixed: false,
                maxmin: true,
                btn: ['提交', '取消'],
                title: "测试翻译",
                content: $('#test').html(),
                area: "60%",
                yes: function (index, dom) {
                    data.query = dom.find('[name=query]').val();
                    if (!data.query) {
                        main.error('翻译的字符为空');
                        return false;
                    }
                    main.request({
                        url: '/trans/youdao/test',
                        data: data,
                        done: function (res) {
                            main.msg(res.msg);
                            return false;
                        },
                        index: index
                    });
                }
            });
        });
    })
</script>