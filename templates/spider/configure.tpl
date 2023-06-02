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
            <input type="checkbox" data-field="user_agent" title="模拟访问" lay-filter="field">
            <input type="checkbox" data-field="delay" title="间隔" lay-filter="field">
            <input type="checkbox" data-field="page_enabled" title="分页" lay-filter="field">
            <input type="checkbox" data-field="cron_enabled" title="定时采集" lay-filter="field">
            <input type="checkbox" data-field="originality" title="原创检测" lay-filter="field">
            <input type="checkbox" data-field="conversion" title="繁简转换" lay-filter="field">
            <input type="checkbox" data-field="order" title="入库排序" lay-filter="field">
        </fieldset>
        <fieldset class="layui-elem-field">
            <legend>操作</legend>
            <div id="field"></div>
        </fieldset>
        <div class="layui-hide">
            <input name="ids" id="ids" value="{{.ids}}">
            <button lay-submit></button>
        </div>
    </div>
</div>
<script type="text/html" id="site-id">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label for="site_id" class="layui-form-label">网站ID:</label>
            <div class="layui-input-inline">
                <select name="site_id" id="site_id" lay-search lay-filter="site_id">
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
<script type="text/html" id="user-agent">
    <div class="layui-form-item">
        <label for="user_agent" class="layui-form-label" lay-tips="模拟访问 默认为百度蜘蛛">模拟访问:</label>
        <div class="layui-input-inline">
            <select name="user_agent" id="user_agent" class="layui-select" lay-search>
                {{range .userAgents -}}
                    <option value="{{.Value}}">{{.Alias}}</option>
                {{end -}}
            </select>
        </div>
    </div>
</script>
<script type="text/html" id="conversion">
    <div class="layui-form-item">
        <label for="conversion" class="layui-form-label" lay-tips="繁体简体转换">繁简转换:</label>
        <div class="layui-input-inline">
            <select name="conversion" id="conversion" class="layui-select" lay-search>
                <option>无...</option>
                {{range .conversions -}}
                    <option value="{{.Name}}">{{.Alias}}</option>
                {{end -}}
            </select>
        </div>
    </div>
</script>
<script>
    layui.use(['main'], function () {
        let form = layui.form,
            fieldElem = $("#field");
        let active = {
            'site_id': function (enabled) {
                if (enabled) {
                    fieldElem.append($('#site-id').html());
                    form.render('select');
                    form.on('select(site_id)', function (obj) {
                        if (obj.value === 0 || obj.value === "") {
                            $('div[lay-filter=class_id]').html('<select name="class_id" id="class_id"><option value="">无...</option></select>');
                            form.render('select');
                            return false;
                        }

                        layui.main.get('/site/class', {
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
            },
            'user_agent': function (enabled) {
                if (enabled) {
                    fieldElem.append($('#user-agent').html());
                    form.render('select');
                } else {
                    fieldElem.find('[name=user_agent]').closest('.layui-form-item').remove();
                }
            },
            'delay': function (enabled) {
                if (enabled) {
                    fieldElem.append(`<div class="layui-form-item">
            <label for="delay" class="layui-form-label" lay-tips="采集间隔 单位为秒 10-20 随机最少10秒最多20秒">Delay:</label>
            <div class="layui-input-inline">
                <input type="text" autocomplete="off" name="delay" id="delay" class="layui-input" value="" placeholder="10-20">
            </div>
        </div>`);
                    form.render('input');
                } else {
                    fieldElem.find('[name=delay]').closest('.layui-form-item').remove();
                }
            },
            'page_enabled': function (enabled) {
                if (enabled) {
                    fieldElem.append(`<div class="layui-form-item">
            <label for="page_enabled" class="layui-form-label">开启分页:</label>
            <div class="layui-input-inline">
                <input type="checkbox" name="page_enabled" id="page_enabled" lay-skin="switch" lay-text="是|否">
            </div>
        </div>`);
                    form.render('checkbox');
                } else {
                    fieldElem.find('[name=page_enabled]').closest('.layui-form-item').remove();
                }
            },
            'cron_enabled': function (enabled) {
                if (enabled) {
                    fieldElem.append(`<div class="layui-form-item">
            <label for="cron_enabled" class="layui-form-label">定时采集:</label>
            <div class="layui-input-inline">
                <input type="checkbox" name="cron_enabled" id="cron_enabled" lay-skin="switch" lay-text="是|否" checked>
            </div>
        </div>`);
                    form.render('checkbox');
                } else {
                    fieldElem.find('[name=cron_enabled]').closest('.layui-form-item').remove();
                }
            },
            'originality': function (enabled) {
                if (enabled) {
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
            },
            'conversion': function (enabled) {
                if (enabled) {
                    fieldElem.append($('#conversion').html());
                    form.render('select');
                } else {
                    fieldElem.find('[name=conversion]').closest('.layui-form-item').remove();
                }
            },
            'order': function (enabled) {
                if (enabled) {
                    fieldElem.append(`<div class="layui-form-item">
    <label for="order" class="layui-form-label" lay-tips="采集入库顺序">入库:</label>
    <div class="layui-input-block">
        <select name="order" id="order" class="layui-select">
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
            },
        };
        form.on('checkbox(field)', function (obj) {
            let $this = $(this), field = $this.data("field");
            active[field] && active[field].call($this, (obj.othis.attr('class').indexOf('layui-form-checked') !== -1));
        });
    });
</script>