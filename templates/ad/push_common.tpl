<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label for="name" class="layui-form-label">名称:</label>
                <div class="layui-input-block">
                    <input class="layui-input" type="text" autocomplete="off" name="name" id="name" value="{{.obj.Name}}" lay-verify="required">
                </div>
            </div>
            <div class="layui-inline">
                <label for="enabled" class="layui-form-label">启用:</label>
                <div class="layui-input-block">
                    <input type="checkbox" name="enabled" id="enabled" lay-skin="switch" lay-text="是|否"{{if .obj.Enabled}} checked{{end}}/>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label for="visiting" class="layui-form-label" lay-tips="不访问则直接生成">访问:</label>
                <div class="layui-input-block">
                    <input type="checkbox" name="visiting" id="visiting" lay-skin="switch" lay-text="是|否"{{if .obj.Visiting}} checked{{end}}/>
                </div>
            </div>
            <div class="layui-inline">
                <label for="spec" class="layui-form-label">Spec:</label>
                <div class="layui-input-inline" lay-tips="双击修改定时任务">
                    <input type="text" autocomplete="off" name="spec" id="spec" value="{{.obj.Spec}}" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label for="delay" class="layui-form-label" lay-tips="发布期间间隔时间 单位为秒">延时:</label>
                <div class="layui-input-block">
                    <input type="number" autocomplete="off" name="delay" id="delay" value="{{.obj.Delay}}" class="layui-input" min="0">
                </div>
            </div>
        </div>
        <div class="layui-form-item layui-row">
            <div class="layui-col-sm6">
                <label for="keywords" class="layui-form-label">关键词:</label>
                <div class="layui-input-block">
                    <textarea name="keywords"id="keywords" class="layui-textarea" required lay-verify="keywords" placeholder="关键词1&#13;关键词2" rows="17">{{join .obj.Keywords "\n"}}</textarea>
                </div>
                <button class="layui-btn" style="margin-left:250px" id="fillTags">来自Tags库填充</button>
            </div>
            <div class="layui-col-sm6">
                <input type="hidden" name="configure_ids" value="{{join .obj.ConfigureIds ","}}">
                <div id="configure-transfer" style="text-align:center;overflow:hidden;"></div>
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
            configureData ={{.configureData}};
        configureData = configureData || [];
        let getValue = function (title) {
            for (let i = 0; i < configureData.length; i++) {
                if (configureData[i].title === title) {
                    return configureData[i].value;
                }
            }
            return '';
        };
        // 定时选择器
        main.cron('[name="spec"]');
        // 显示配置ID
        transfer.render({
            id: 'configureData',
            elem: '#configure-transfer',
            data: configureData,
            title: ['全部配置', '已选配置'],
            value: {{.obj.ConfigureIds}},
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
            let titles = transfer.getData('configureData'), ids = [];
            layui.each(titles, function (i, v) {
                ids[i] = getValue(v.title);
            });
            $('input[name=configure_ids]').val(ids.join());
        })
    });
</script>