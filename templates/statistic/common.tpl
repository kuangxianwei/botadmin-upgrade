<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <label for="enabled" class="layui-form-label">启用:</label>
            <div class="layui-input-inline">
                <input type="checkbox" lay-skin="switch" lay-text="启用|禁用" name="enabled" id="enabled"{{if .obj.Enabled}} checked{{end}}>
            </div>
        </div>
        <div class="layui-form-item">
            <label for="origin" class="layui-form-label">源:</label>
            <div class="layui-input-block">
                <input type="text" autocomplete="off" name="origin" id="origin" lay-verify="required"
                       class="layui-input" placeholder="http://www.botadmin.cn" value="{{.obj.Origin}}">
            </div>
        </div>
        <div class="layui-form-item">
            <label for="title" class="layui-form-label">标题:</label>
            <div class="layui-input-block">
                <input type="text" autocomplete="off" name="title" id="title" lay-verify="required"
                       class="layui-input" placeholder="站掌门站群-免费站群系统_批量建站_自动采集程序CMS" value="{{.obj.Title}}">
            </div>
        </div>
        <fieldset class="layui-elem-field">
            <legend>控制列表</legend>
            <div lay-filter="controls"></div>
            <label for="id" class="layui-form-label"></label>
            <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="add-control" lay-tips="添加控制">
                <i class="layui-icon layui-icon-addition"></i>
            </button>
        </fieldset>
        <div class="layui-form-item layui-hide">
            <input name="id" id="id" value="{{.obj.Id}}">
            <button lay-submit=""></button>
        </div>
        <input type="hidden" name="controls">
    </div>
</div>
<script type="text/html" id="control">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label for="controls.provider." class="layui-form-label">供应者:</label>
            <div class="layui-input-inline">
                <select name="controls.provider." id="controls.provider." class="layui-select">
                    {{range .providers -}}
                        <option value="{{.Name}}">{{.Alias}}</option>
                    {{end -}}
                </select>
            </div>
        </div>
        <div class="layui-inline">
            <label for="controls.token." class="layui-form-label">秘钥:</label>
            <div class="layui-input-inline">
                <input name="controls.token." id="controls.token." class="layui-input" value="">
            </div>
        </div>
        <i class="layui-icon layui-icon-delete" lay-tips="删除该条规则" lay-event="del"></i>
    </div>
</script>
<script>
    layui.use(['main'], function () {
        let main = layui.main,
            form = layui.form,
            controls = {{.obj.Controls}};

        function addControl(options, id) {
            id++;
            let dom = $($('#control').html());
            dom.find('[name*=".provider."]>option[value="' + options['provider'] + '"]').prop("selected", true);
            dom.find('[name*=".token."]').val(options.token);
            dom.find('[name]').each(function () {
                this.name += id
            });
            $('[lay-filter="controls"]').append(dom);
        }

        if (controls) {
            $.each(controls, function (i, v) {
                addControl(v, i);
            });
        }
        main.on.del();
        $('[lay-event="add-control"]').off('click').on('click', function () {
            let name = $('[lay-filter="controls"] [name]').last().attr("name"),
                id = 0;
            if (name) {
                let ls = name.split('.');
                id = +(ls.slice(ls.length - 1));
            }
            addControl({}, id);
            form.render();
            main.on.del();
        });
    });
</script>