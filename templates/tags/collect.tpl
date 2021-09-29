<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label" lay-tips="是否启用定时更新">启用定时:</label>
                <div class="layui-input-block">
                    <input type="checkbox" name="enabled" lay-skin="switch" lay-text="开启|关闭"{{if .obj.Enabled}} checked{{end}}>
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label" lay-tips="定时规则">Spec:</label>
                <div class="layui-input-block">
                    <input type="text" name="spec" class="layui-input" value="{{.obj.Spec}}" placeholder="0 0 * * * ?">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label" lay-tips="采集最多tag个数">上限:</label>
                <div class="layui-input-block">
                    <input type="number" name="max" max="5000" min="1" class="layui-input" value="{{.obj.Max}}" placeholder="500">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label" lay-tips="采集前清空以前存在的Tags">置零:</label>
                <div class="layui-input-block">
                    <input type="checkbox" name="truncate" lay-skin="switch" lay-text="开启|关闭"{{if .obj.Truncate}} checked{{end}}>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label" lay-tips="必须包含关键词才采集">包含:</label>
                <div class="layui-input-block">
                    <textarea name="contains" class="layui-textarea" placeholder="必须包含的关键词一行一个">{{join .obj.Contains "\n"}}</textarea>
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label" lay-tips="必须不包含关键词才采集">排除:</label>
                <div class="layui-input-block">
                    <textarea name="excludes" class="layui-textarea" placeholder="排除关键词 一行一个">{{join .obj.Excludes "\n"}}</textarea>
                </div>
            </div>
        </div>
        <div class="layui-row layui-col-space25">
            <div class="layui-col-md3">
                <div class="layui-form-item">
                    <label class="layui-form-label">种子<i class="layui-icon layui-icon-down"></i></label>
                    <textarea rows="16" name="seeds" class="layui-textarea"
                              placeholder="关键词一行一个">{{join .obj.Seeds "\n"}}</textarea>
                </div>
            </div>
            <div class="layui-col-md9">
                <div class="layui-form-item">
                    <label class="layui-form-label">结果<i class="layui-icon layui-icon-down"></i></label>
                    <label class="layui-form-label" id="collect-status" style="min-width: 100px">状态:
                        <strong style="color: red" title="0">未运行</strong></label>
                    <label class="layui-form-label" style="color:#22849b;cursor:pointer" data-event="copy-keywords">
                        <i class="layui-icon iconfont icon-copy"></i>关键词</label>
                    <label class="layui-form-label" style="color:red;cursor: pointer" data-event="reset-record">
                        <i class="layui-icon layui-icon-delete"></i>记录</label>
                    <label class="layui-form-label" style="cursor:pointer" data-event="log">
                        <i class="layui-icon layui-icon-log"></i>日志</label>
                    <textarea rows="16" class="layui-textarea" id="collect-display"></textarea>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label"></label>
            <button class="layui-btn" lay-submit lay-filter="submit-save">
                <i class="iconfont icon-save"></i>保存配置
            </button>
            <button id="start-stop" class="layui-btn" lay-submit lay-filter="submit-start">
                <i class="layui-icon layui-icon-play"></i>开始
            </button>
        </div>
    </div>
</div>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let form = layui.form,
            main = layui.main;
        form.on('submit(submit-save)', function (obj) {
            main.req({
                url: url,
                data: obj.field,
            });
        });
        form.on('submit(submit-start)', function (obj) {
            obj.field.action = 'run';
            main.req({
                url: url,
                data: obj.field,
                ending: function () {
                    main.ws.log("tags.0");
                    return false;
                }
            });
        });
        form.on('submit(submit-stop)', function () {
            main.req({url: url + '/stop'});
        });
        main.ws.display({
            name: 'tags_collect.0',
            displaySelector: '#collect-display',
            statusSelector: '#collect-status'
        }, function (status) {
            if (status === '0') {
                $('#start-stop').attr('lay-filter', 'submit-start')
                    .removeClass('layui-bg-red')
                    .html('<i class="layui-icon layui-icon-play"></i>开始');
            } else {
                $('#start-stop').attr('lay-filter', 'submit-stop')
                    .addClass('layui-bg-red')
                    .html('<i class="layui-icon layui-icon-pause"></i>停止');
            }
        });
        let active = {
            "reset-record": function () {
                main.reset.log('tags_collect', [0], {
                    ending: function () {
                        $('#collect-display').val('');
                    }
                })
            },
            "copy-keywords": function () {
                let val = $('#collect-display').val(), values = val.split("\n"), result = [],
                    reg = /(?:入库成功|seed)=(.*?)$/;
                for (let i = 0; i < values.length; i++) {
                    let rs = reg.exec(values[i]);
                    if (rs) {
                        let keyword = rs[1].trim();
                        if (result.indexOf(keyword) === -1) {
                            result.push(keyword);
                        }
                    }
                }
                if (!result) {
                    layer.msg("关键词列表为空");
                    return false;
                }
                main.copy.exec(result.join("\n"), function () {
                    layer.msg("复制成功");
                });
            },
            "log": function () {
                main.ws.log("tags.0");
            }
        };
        $('[data-event]').off('click').on('click', function () {
            let $this = $(this), event = $this.data("event");
            active[event] && active[event].call($this);
        });
        main.cron('[name=spec]');
    });
</script>