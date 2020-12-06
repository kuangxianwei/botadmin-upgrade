<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <label class="layui-form-label">标题:</label>
            <div class="layui-input-block">
                <input class="layui-input" type="text" name="title" value="{{.obj.Title}}" lay-verify="required">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">关键词:</label>
            <div class="layui-input-block">
                <input class="layui-input" type="text" name="keywords" value="{{join .obj.Keywords ","}}">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">描述:</label>
            <div class="layui-input-block">
                <input class="layui-input" type="text" name="description" value="{{.obj.Description}}">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">Tags:</label>
            <div class="layui-input-block">
                <input class="layui-input" type="text" name="tags" value="{{join .obj.Tags ","}}">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">图片地址:</label>
            <div class="layui-input-block">
                <input class="layui-input" type="text" name="title_pic" value="{{.obj.TitlePic}}">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">网站ID:</label>
                <div class="layui-input-inline">
                    <select name="site_id" lay-search lay-filter="site_id">
                        <option value="0">搜索...</option>
                        {{range .sites -}}
                            <option value="{{.Id}}"{{if eq $.obj.SiteId .Id}} selected{{end}}>{{.Vhost}}</option>
                        {{end -}}
                    </select>
                </div>
            </div>
            <div class="layui-inline" lay-tips="选择栏目ID">
                <label class="layui-form-label">栏目ID:</label>
                <div class="layui-input-block" lay-filter="class_id">
                    {{.class_select}}
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">内容:</label>
            <div class="layui-input-block">
                <textarea class="layui-textarea layui-bg-black" lay-verify="required" name="content"
                          rows="15">{{.obj.Content}}</textarea>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">采集源:</label>
            <div class="layui-input-block">
                <input type="text" class="layui-input" name="source" value="{{.obj.Source}}">
            </div>
        </div>
        <div class="layui-form-item layui-hide">
            <input type="hidden" name="id" value="{{.obj.Id}}">
            <input type="hidden" name="ban_vetted" value="{{.obj.BanVetted}}">
            <input type="hidden" name="original_rate" value="{{.obj.OriginalRate}}">
            <button class="layui-btn layui-btn-small" lay-submit>提交</button>
        </div>
    </div>
</div>
<script>
    layui.use(['layer'], function () {
        let $ = layui.$,
            form = layui.form,
            class_id = $('select[name=class_id]').val();
        form.on('select(site_id)', function (obj) {
            if (obj.value === 0 || obj.value === "") {
                return false;
            }
            $.get('/site/class', {'id': obj.value, 'class_id': class_id}, function (res) {
                switch (res.code) {
                    case -1:
                        layer.alert(res.msg, {icon: 2});
                        break;
                    case 0:
                        $('div[lay-filter=class_id]').html(res.data);
                        form.render();
                        break;
                }
            });
        });
    });
</script>