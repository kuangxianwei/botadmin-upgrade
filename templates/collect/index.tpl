<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <label class="layui-form-label">多协程:</label>
            <div class="layui-input-inline" style="margin-top:18px;">
                <div id="thread"></div>
                <input type="hidden" name="thread" value="{{$.obj.Thread}}">
            </div>
            <div class="layui-form-mid layui-word-aux">协程太多会卡死服务器</div>
        </div>
        <div class="layui-row layui-col-space25">
            <div class="layui-col-md3">
                <div class="layui-form-item">
                    <label class="layui-form-label">种子<i class="layui-icon layui-icon-down"></i></label>
                    <textarea rows="10" name="seeds" class="layui-textarea">{{join .obj.Seeds "\n"}}</textarea>
                </div>
            </div>
            <div class="layui-col-md9">
                <div class="layui-form-item">
                    <label class="layui-form-label">结果<i class="layui-icon layui-icon-down"></i></label>
                    <label class="layui-form-label" style="color: red;cursor: pointer" lay-filter="reset-record">清空记录<i class="layui-icon layui-icon-delete"></i></label>
                    <textarea rows="10" class="layui-textarea layui-bg-black" id="display-result"></textarea>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <button class="layui-btn" lay-submit lay-filter="submit">开始采集</button>
        </div>
    </div>
</div>
<script src="/static/modules/clipboard.min.js"></script>
{{template "JS" -}}
<script>
    JS.use(['index', 'main'], function () {
        let form = layui.form,
            main = layui.main,
            url = {{.current_uri}};
        form.on('submit(submit)', function (obj) {
            main.req({
                url: url,
                data: obj.field,
            });
        });
        main.ws.display('#display-result', 'collect');
        $('[lay-filter="reset-record"]').click(function () {
            main.req({
                url: '/record/reset',
                data: {keys: 'collect.0'},
                ending: function () {
                    $('#display-result').val('');
                }
            });
        });
        main.slider({elem: '#thread', value: {{$.obj.Thread}}, max: 100});
    });
</script>