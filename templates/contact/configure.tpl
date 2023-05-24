<style>
    .layui-form .layui-form-checkbox {
        margin-top: 3px;
        margin-bottom: 3px;
    }
</style>
<div class="layui-card layui-form">
    <div class="layui-card-body">
        <fieldset class="layui-elem-field">
            <legend>修改目标</legend>
            <input type="checkbox" data-field="pc_enabled" title="PC" lay-filter="field">
            <input type="checkbox" data-field="mobile_enabled" title="Mobile" lay-filter="field">
            <input type="checkbox" data-field="max" title="最大限制" lay-filter="field">
            <input type="checkbox" data-field="weight" title="权重" lay-filter="field">
            <input type="checkbox" data-field="consult" title="在线咨询" lay-filter="field">
            <input type="checkbox" data-field="other" title="其他" lay-filter="field">
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
<script>
    layui.use(['main'], function () {
        let main = layui.main,
            form = layui.form,
            fieldElem = $("#field");
        let active = {
            pc_enabled: function (enabled) {
                if (enabled) {
                    fieldElem.append('<div class="layui-form-item"><label class="layui-form-label">启用PC:</label><div class="layui-input-block"><input type="checkbox" name="pc_enabled" id="pc_enabled" lay-skin="switch" lay-text="启用|禁用" checked></div></div>');
                    form.render('checkbox');
                } else {
                    fieldElem.find('[name=pc_enabled]').closest('.layui-form-item').remove();
                }
            },
            mobile_enabled: function (enabled) {
                if (enabled) {
                    fieldElem.append('<div class="layui-form-item"><label class="layui-form-label">启用Mobile:</label><div class="layui-input-block"><input type="checkbox" name="mobile_enabled" id="mobile_enabled" lay-skin="switch" lay-text="是|否" checked></div></div>');
                    form.render('checkbox');
                } else {
                    fieldElem.find('[name=mobile_enabled]').closest('.layui-form-item').remove();
                }
            },
            max: function (enabled) {
                if (enabled) {
                    fieldElem.append('<div class="layui-form-item"><label class="layui-form-label">最大限制:</label><div class="layui-input-inline"><input type="number" autocomplete="off" name="max" id="max" value="0" min="0" class="layui-input"></div><div class="layui-form-mid layui-word-aux">0为不限制</div></div>');
                    form.render('checkbox');
                } else {
                    fieldElem.find('[name=max]').closest('.layui-form-item').remove();
                }
            },
            weight: function (enabled) {
                if (enabled) {
                    fieldElem.append('<div class="layui-form-item"><label class="layui-form-label">权重:</label><div class="layui-input-inline"><div id="weight" class="slider-inline"></div><input type="hidden" name="weight" value="0" lay-verify="number"></div><div class="layui-form-mid layui-word-aux">值越高 几率越高</div></div>');
                    //滑块控制
                    main.slider({elem: '#weight', value: 0, max: 100});
                } else {
                    fieldElem.find('[name=weight]').closest('.layui-form-item').remove();
                }
            },
            consult: function (enabled) {
                if (enabled) {
                    fieldElem.append(`<div class="layui-form-item">
            <label for="consult" class="layui-form-label">在线咨询:</label>
            <div class="layui-input-inline" style="width: 50%">
                <input name="consult" id="consult" value="" placeholder="https://domain.com" class="layui-input">
            </div>
            <div class="layui-form-mid layui-word-aux">如QQ在线</div>
            <button class="layui-btn" lay-event="fill-consult">填充默认</button>
        </div>`);
                    form.render('input');
                    // 填充咨询链接
                    $('[lay-event="fill-consult"]').on('click', function () {
                        main.request({
                            url: '/contact/fill',
                            data: {field: 'consult'},
                            done: function (res) {
                                $('[name="consult"]').val(res.data);
                            }
                        });
                    });
                } else {
                    fieldElem.find('[name=consult]').closest('.layui-form-item').remove();
                }
            },
            other: function (enabled) {
                if (enabled) {
                    fieldElem.append(`<div class="layui-form-item">
            <label class="layui-form-label">其他:</label>
            <div class="layui-input-inline" style="width: 50%">
                <textarea name="other" class="layui-textarea" rows="4"></textarea>
            </div>
            <div class="layui-form-mid layui-word-aux">例如百度统计客服代码</div>
            <button class="layui-btn" lay-event="fill-other">填充默认</button>
        </div>`);
                    form.render();
                    // 填充其他百度统计啥的
                    $('[lay-event="fill-other"]').off('click').on('click', function () {
                        main.request({
                            url: '/contact/fill',
                            data: {field: 'other'},
                            done: function (res) {
                                $('[name="other"]').val(res.data);
                                return false;
                            }
                        });
                    });
                } else {
                    fieldElem.find('[name=other]').closest('.layui-form-item').remove();
                }
            },
        };
        form.on('checkbox(field)', function (obj) {
            let $this = $(this), field = $this.data("field");
            active[field] && active[field].call($this, (obj.othis.attr('class').indexOf('layui-form-checked') !== -1));
        });
    });
</script>