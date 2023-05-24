<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <label for="title" class="layui-form-label">标题:</label>
            <div class="layui-input-block">
                <input class="layui-input" type="text" autocomplete="off" name="title" id="title" value="{{.obj.Title}}" lay-verify="required">
            </div>
        </div>
        <div class="layui-form-item">
            <label for="keywords" class="layui-form-label">关键词:</label>
            <div class="layui-input-block">
                <input class="layui-input" type="text" autocomplete="off" name="keywords" id="keywords" value="{{join .obj.Keywords ","}}">
            </div>
        </div>
        <div class="layui-form-item">
            <label for="description" class="layui-form-label">描述:</label>
            <div class="layui-input-block">
                <input class="layui-input" type="text" autocomplete="off" name="description" id="description" value="{{.obj.Description}}">
            </div>
        </div>
        <div class="layui-form-item">
            <label for="tags" class="layui-form-label">Tags:</label>
            <div class="layui-input-block">
                <input name="tags" id="tags" class="layui-textarea" placeholder="多个TAG用英文逗号隔开 如:tag1,tag2,tag3" value="{{join .obj.Tags ","}}">
            </div>
        </div>
        <div class="layui-form-item">
            <label for="title_pic" class="layui-form-label">图片地址:</label>
            <div class="layui-input-block">
                <input class="layui-input" type="text" autocomplete="off" name="title_pic" id="title_pic" value="{{.obj.TitlePic}}">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label for="site_id" class="layui-form-label">网站ID:</label>
                <div class="layui-input-inline">
                    <select name="site_id" id="site_id" lay-search lay-filter="site_id">
                        <option value="">搜索...</option>
                        {{range .sites -}}
                            <option value="{{.Id}}"{{if eq $.obj.SiteId .Id}} selected{{end}}>{{.Vhost}}</option>
                        {{end -}}
                    </select>
                </div>
            </div>
            <div class="layui-inline" lay-tips="选择栏目ID">
                <label for="source" class="layui-form-label">栏目ID:</label>
                <div class="layui-input-block" lay-filter="class_id">
                    {{.class_select}}
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <label for="source" class="layui-form-label">内容:</label>
            <div class="layui-input-block">
                <textarea class="layui-textarea" lay-verify="required" name="content"
                          rows="15" placeholder="内容区域">{{.obj.Content}}</textarea>
            </div>
        </div>
        <div class="layui-form-item">
            <label for="source" class="layui-form-label">采集源:</label>
            <div class="layui-input-block">
                <input type="text" autocomplete="off" class="layui-input" name="source" id="source" value="{{.obj.Source}}">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">原创率:</label>
            <div class="layui-input-block">
                <input type="radio" name="originality" value="0"
                       title="不检验"{{if eq .obj.Originality 0}} checked{{end}}>
                <input type="radio" name="originality" value="1"
                       title="未检验"{{if eq .obj.Originality 1}} checked{{end}}>
                <input type="radio" name="originality" value="2"
                       title="已检验"{{if eq .obj.Originality 2}} checked{{end}}>
            </div>
        </div>
        <div class="layui-form-item layui-hide">
            <input type="hidden" name="id" value="{{.obj.Id}}">
            <button class="layui-btn layui-btn-small" lay-submit>提交</button>
        </div>
    </div>
</div>
<script>
    layui.use([], function () {
        let form = layui.form,
            class_id = $('select[name=class_id]').val();
        form.on('select(site_id)', function (obj) {
            if (obj.value === 0 || obj.value === "") {
                $('div[lay-filter=class_id]').html('<select name="class_id" id="class_id"><option value="">无...</option></select>');
                form.render();
                return false;
            }
            layui.main.get('/site/class', {id: obj.value, class_id: class_id}, function (res) {
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