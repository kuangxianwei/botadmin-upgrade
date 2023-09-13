<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label for="name" class="layui-form-label">名称:</label>
                <div class="layui-input-block">
                    <input class="layui-input" type="text" name="name" id="name" value="{{.obj.Name}}" lay-verify="required">
                </div>
            </div>
            <div class="layui-inline">
                <label for="enabled" class="layui-form-label">启用定时:</label>
                <div class="layui-input-block">
                    <input type="checkbox" name="enabled" id="enabled" lay-skin="switch" lay-text="是|否"{{if .obj.Enabled}} checked{{end}}/>
                </div>
            </div>
            <div class="layui-inline">
                <label for="spec" class="layui-form-label">Spec:</label>
                <div class="layui-input-inline" lay-tips="双击修改定时任务">
                    <input type="text" name="spec" id="spec" value="{{.obj.Spec}}" class="layui-input">
                </div>
            </div>
        </div>
        <div class="layui-form-item layui-row">
            <div class="layui-col-sm6">
                <label for="keywords" class="layui-form-label">关键词:</label>
                <div class="layui-input-block">
                    <textarea name="keywords" id="keywords" class="layui-textarea" required lay-verify="keywords" placeholder="关键词1&#13;关键词2" rows="17">{{join .obj.Keywords "\n"}}</textarea>
                </div>
                <button class="layui-btn" style="margin-left:250px" id="fillTags">来自Tags库填充</button>
            </div>
            <div class="layui-col-sm6">
                <input type="hidden" name="config_ids" value="{{join .obj.ConfigIds ","}}">
                <div id="config-transfer" style="text-align:center;overflow:hidden;"></div>
            </div>
        </div>
        <div class="layui-hide">
            <input type="hidden" name="id" value="{{.obj.Id}}">
            <button class="layui-btn layui-btn-small" lay-submit id="submit">提交</button>
        </div>
    </div>
</div>
<script>
    layui.use(['transfer'], function () {
        let main = layui.main,
            transfer = layui.transfer,
            configData ={{.configData}};
        configData = configData || [];
        let getValue = function (title) {
            for (let i = 0; i < configData.length; i++) {
                if (configData[i].title === title) {
                    return configData[i].value;
                }
            }
            return '';
        };
        // 定时选择器
        main.cron('[name="spec"]');
        // 显示配置ID
        transfer.render({
            id: 'configData',
            elem: '#config-transfer',
            data: configData,
            title: ['全部配置', '已选配置'],
            value: {{.obj.ConfigIds}},
            showSearch: true
        });
        $('#fillTags').on('click', function () {
            main.request({
                url: '/tags/get',
                done: function (res) {
                    if (Array.isArray(res.data)) {
                        $('textarea[name=keywords]').val(res.data.join('\n'));
                    }
                    return false;
                }
            });
        });
        $('#submit').on('click', function () {
            let titles = transfer.getData('configData'), ids = [];
            layui.each(titles, function (i, v) {
                ids[i] = getValue(v.title);
            });
            $('input[name=config_ids]').val(ids.join());
        })
    });
</script>