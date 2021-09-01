<style>
    input[data-field] + .layui-unselect {
        margin-top: 3px;
        margin-bottom: 3px;
    }
</style>
<div class="layui-card layui-form">
    <div class="layui-card-body">
        <fieldset class="layui-elem-field">
            <legend>修改目标</legend>
            <input type="checkbox" data-field="site_id" title="绑定网站" lay-filter="field">
            <input type="checkbox" data-field="used" title="使用状态" lay-filter="field">
            <input type="checkbox" data-field="trans_failed" title="译错" lay-filter="field">
            <input type="checkbox" data-field="originality" title="原创检测" lay-filter="field">

        </fieldset>
        <fieldset class="layui-elem-field">
            <legend>操作</legend>
            <div id="field"></div>
        </fieldset>
        <div class="layui-hide">
            <input name="ids" value="{{.ids}}">
            <button lay-submit></button>
        </div>
    </div>
</div>
<script type="text/html" id="site-id">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">网站ID:</label>
            <div class="layui-input-inline">
                <select name="site_id" lay-search lay-filter="site_id">
                    <option value="">搜索...</option>
                    {{range .sites -}}
                        <option value="{{.Id}}">{{.Vhost}}</option>
                    {{end -}}
                </select>
            </div>
        </div>
        <div class="layui-inline" lay-tips="选择栏目ID">
            <label class="layui-form-label">栏目ID:</label>
            <div class="layui-input-block" lay-filter="class_id">
                <select name="class_id">
                    <option value="">无...</option>
                </select>
            </div>
        </div>
    </div>
</script>
<script>
    layui.use(['main'], function () {
        let form = layui.form,
            fieldElem = $("#field");
        form.on('checkbox(field)', function (obj) {
            switch ($(this).attr('data-field')) {
                case 'site_id':
                    if (obj.othis.attr('class').indexOf('layui-form-checked') !== -1) {
                        fieldElem.append($('#site-id').html());
                        form.render('select');
                        form.on('select(site_id)', function (obj) {
                            if (obj.value === 0 || obj.value === "") {
                                $('div[lay-filter=class_id]').html('<select name="class_id"><option value="">无...</option></select>');
                                form.render('select');
                                return false;
                            }
                            $.get('/site/class', {
                                id: obj.value,
                                class_id: $('select[name=class_id]').val()
                            }, function (res) {
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
                    } else {
                        fieldElem.find('[name=site_id]').closest('.layui-form-item').remove();
                    }
                    break;
                case 'used':
                    if (obj.othis.attr('class').indexOf('layui-form-checked') !== -1) {
                        fieldElem.append(`<div class="layui-form-item">
            <label class="layui-form-label">已使用:</label>
            <div class="layui-input-inline">
                <input type="checkbox" name="used" lay-skin="switch" lay-text="是|否">
            </div>
        </div>`);
                        form.render('checkbox');
                    } else {
                        fieldElem.find('[name=used]').closest('.layui-form-item').remove();
                    }
                    break;
                case 'trans_failed':
                    if (obj.othis.attr('class').indexOf('layui-form-checked') !== -1) {
                        fieldElem.append(`<div class="layui-form-item">
            <label class="layui-form-label" lay-tips="切换翻译错误">译错:</label>
            <div class="layui-input-inline">
                <input type="checkbox" name="trans_failed" lay-skin="switch" lay-text="是|否">
            </div>
        </div>`);
                        form.render('checkbox');
                    } else {
                        fieldElem.find('[name=trans_failed]').closest('.layui-form-item').remove();
                    }
                    break;
                case 'originality':
                    if (obj.othis.attr('class').indexOf('layui-form-checked') !== -1) {
                        fieldElem.append(`<div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">原创率:</label>
                <div class="layui-input-block">
                    <input type="radio" name="originality" value="0" title="不检验" checked>
                    <input type="radio" name="originality" value="1" title="未检验">
                    <input type="radio" name="originality" value="2" title="已检验">
                </div>
            </div>
        </div>`);
                        form.render('radio');
                    } else {
                        fieldElem.find('[name=originality]').closest('.layui-form-item').remove();
                    }
                    break;
                case 'conversion':
                    if (obj.othis.attr('class').indexOf('layui-form-checked') !== -1) {
                        fieldElem.append($('#conversion').html());
                        form.render('select');
                    } else {
                        fieldElem.find('[name=conversion]').closest('.layui-form-item').remove();
                    }
                    break;
                case 'order':
                    if (obj.othis.attr('class').indexOf('layui-form-checked') !== -1) {
                        fieldElem.append(`<div class="layui-form-item">
    <label class="layui-form-label" lay-tips="采集入库顺序">入库:</label>
    <div class="layui-input-block">
        <select name="order" class="layui-select">
            <option value="0" selected>正序</option>
            <option value="1">倒序</option>
            <option value="2">URL升序</option>
            <option value="3">URL降序</option>
        </select>
    </div>
</div>`);
                        form.render('select');
                    } else {
                        fieldElem.find('[name=order]').closest('.layui-form-item').remove();
                    }
                    break;
            }
        });
    });
</script>