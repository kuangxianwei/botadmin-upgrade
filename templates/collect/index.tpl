<style>
    .layui-slider-input {
        top: 0;
    }
</style>
<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-row">
            <div class="layui-col-md2">
                <div class="layui-form-item">
                    <label class="layui-form-label" lay-tips="百度搜索关键词的深度">搜索深度:</label>
                    <div class="layui-input-block">
                        <input type="number" name="depth" value="{{$.obj.Depth}}" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-col-md10">
                <div class="layui-form-item">
                    <label class="layui-form-label" lay-tips="协程太多会卡死服务器">多协程:</label>
                    <div class="layui-input-block">
                        <div id="thread" class="slider-block"></div>
                        <input type="hidden" name="thread" value="{{$.obj.Thread}}">
                    </div>
                </div>
            </div>
        </div>
        <div class="layui-row layui-col-space25">
            <div class="layui-col-md3">
                <div class="layui-form-item">
                    <label class="layui-form-label">种子<i class="layui-icon layui-icon-down"></i></label>
                    <textarea rows="20" name="seeds" class="layui-textarea">{{join .obj.Seeds "\n"}}</textarea>
                </div>
            </div>
            <div class="layui-col-md9">
                <div class="layui-form-item">
                    <label class="layui-form-label">结果<i class="layui-icon layui-icon-down"></i></label>
                    <label class="layui-form-label" id="collect-status" style="min-width: 100px">状态:
                        <strong style="color: red" title="0">未运行</strong></label>
                    <label class="layui-form-label" style="color:#22849b;cursor: pointer" lay-filter="copy-urls">
                        <i class="layui-icon iconfont icon-copy"></i>URL</label>
                    <label class="layui-form-label" style="color:#22849b;cursor: pointer" lay-filter="copy-keywords">
                        <i class="layui-icon iconfont icon-copy"></i>关键词</label>
                    <label class="layui-form-label" style="color: red;cursor: pointer" lay-filter="reset-record">
                        <i class="layui-icon layui-icon-delete"></i>记录</label>
                    <textarea rows="20" class="layui-textarea layui-bg-black" id="collect-display"></textarea>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <button class="layui-btn" lay-submit lay-filter="submit-start">
                <i class="layui-icon layui-icon-play"></i>开始
            </button>
        </div>
    </div>
</div>
<script src="/static/modules/clipboard.min.js"></script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let form = layui.form,
            main = layui.main,
            url = {{.current_uri}};
        form.on('submit(submit-start)', function (obj) {
            main.req({
                url: url,
                data: obj.field,
            });
        });
        form.on('submit(submit-stop)', function () {
            main.req({url: url + '/stop'});
        });
        main.ws.display({
            name: 'collect',
            displaySelector: '#collect-display',
            statusSelector: '#collect-status'
        }, function (status) {
            if (status === '0') {
                $('[lay-submit]').attr('lay-filter', 'submit-start')
                    .removeClass('layui-bg-red')
                    .html('<i class="layui-icon layui-icon-play"></i>开始');
            } else {
                $('[lay-submit]').attr('lay-filter', 'submit-stop')
                    .addClass('layui-bg-red')
                    .html('<i class="layui-icon layui-icon-pause"></i>停止');
            }
        });
        $('[lay-filter="reset-record"]').click(function () {
            main.reset.log('collect', [0], {
                ending: function () {
                    $('#collect-display').val('');
                }
            })
        });
        $('[lay-filter="copy-keywords"]').click(function () {
            let val = $('#collect-display').val(), values = val.split("\n"), result = [], reg = /^相关搜索词:(.*?)$/;
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
        });
        $('[lay-filter="copy-urls"]').click(function () {
            let val = $('#collect-display').val(), values = val.split("\n"), result = [], reg = /(https?:\/\/\S+)/;
            for (let i = 0; i < values.length; i++) {
                let rs = reg.exec(values[i]);
                if (rs) {
                    let host = rs[1].trim();
                    if (result.indexOf(host) === -1) {
                        result.push(host);
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
        });
        main.slider({elem: '#thread', value: {{$.obj.Thread}}, max: 100});
    });
</script>