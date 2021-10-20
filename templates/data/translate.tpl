<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label-col">引擎:</label>
            </div>
            <div class="layui-inline" style="width: 100px;">
                <select name="engine" lay-filter="engine">
                    {{range $v :=.engines}}
                        <option value="{{$v.Name}}">{{$v.Alias}}</option>
                    {{end}}
                </select>
            </div>
            <div class="layui-inline" style="width: 160px;">
                <select name="source" lay-search=""></select>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label-col" style="color: #009688;">
                    <i class="layui-icon layui-icon-spread-left"></i>
                </label>
            </div>
            <div class="layui-inline" style="width: 160px;">
                <select name="target" lay-search=""></select>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label-col">线程:</label>
            </div>
            <div class="layui-inline">
                <input name="thread" value="1" class="layui-input" style="width: 60px;">
            </div>
        </div>
        <div class="layui-form-item layui-hide">
            <div class="layui-input-block">
                <input type="hidden" name="ids" value="{{.ids}}">
                <button class="layui-btn" lay-submit lay-filter="submit">提交</button>
            </div>
        </div>
    </div>
</div>
<script>
    function displayUsable(engine) {
        engine = engine || $("select[name='engine']").val();
        let source_name = "source",
            target_name = "target",
            source_obj = $("select[name='source']"),
            target_obj = $("select[name='target']");
        /*服务器获取*/
        $.get('/spider/usable', {
            engine: engine,
            source_name: source_name,
            target_name: target_name,
            source_selected: source_obj.val() || 'en',
            target_selected: target_obj.val() || 'zh'
        }, function (res) {
            if (res.code === 0) {
                source_obj.replaceWith(res.data.source);
                target_obj.replaceWith(res.data.target);
                layui.form.render();
                return false;
            }
            layui.layer.alert(res.msg, {icon: 2});
        });
        return false;
    }

    displayUsable();
    layui.form.on('select(engine)', function (obj) {
        displayUsable(obj.value);
    });
</script>