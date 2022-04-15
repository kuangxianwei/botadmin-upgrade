<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">搜索模式:</label>
                <div class="layui-input-block">
                    <input type="checkbox" name="search_mode" lay-skin="switch" lay-text="是|否" checked>
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">过滤:</label>
                <div class="layui-input-inline">
                    <input type="number" name="filter" value="0" class="layui-input" max="20">
                </div>
                <div class="layui-form-mid layui-word-aux">过滤小于该长度的列表</div>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">源:</label>
            <div class="layui-input-block">
                <textarea name="content" class="layui-textarea" rows="8" placeholder="输入源内容"></textarea>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">结果:</label>
            <div class="layui-input-block">
                <textarea id="results" class="layui-textarea" rows="12"></textarea>
            </div>
        </div>
        <div class="layui-form-item" style="text-align: center">
            <button class="layui-btn layui-btn-radius" lay-submit lay-filter="submit">
                提交
            </button>
        </div>
    </div>
</div>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let form = layui.form,
            main = layui.main;
        form.on('submit(submit)', function (obj) {
            main.request({
                url: "/tools/segment",
                data: obj.field,
                done: function (res) {
                    if (Array.isArray(res.data)) {
                        $('#results').val(res.data.join("\n"));
                    }
                    return false;
                }
            });
        });
        form.render();
    });
</script>