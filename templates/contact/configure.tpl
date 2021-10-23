<div class="layui-card layui-form">
    <div class="layui-card-body">
        <fieldset class="layui-elem-field">
            <legend>修改目标</legend>
            <input type="checkbox" data-field="pc_enabled" title="PC" lay-filter="field">
            <input type="checkbox" data-field="mobile_enabled" title="Mobile" lay-filter="field">
            <input type="checkbox" data-field="max" title="最大限制" lay-filter="field">
            <input type="checkbox" data-field="weight" title="权重" lay-filter="field">
            <input type="checkbox" data-field="durations" title="开放时间" lay-filter="field">
            <input type="checkbox" data-field="cities" title="屏蔽区域" lay-filter="field">
            <input type="checkbox" data-field="tip_delay" title="延时弹窗" lay-filter="field">
            <input type="checkbox" data-field="consult" title="在线咨询" lay-filter="field">
            <input type="checkbox" data-field="other" title="其他" lay-filter="field">
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
<script>
    layui.use(['main'], function () {
        let main = layui.main,
            layDate = layui.laydate,
            form = layui.form,
            transfer = layui.transfer,
            citiesData = {{.cityData}},
            fieldElem = $("#field");
        let active = {
            'tip_delay': function (enabled) {
                if (enabled) {
                    fieldElem.append('<div class="layui-form-item"><label class="layui-form-label">弹窗延时:</label><div class="layui-input-inline"><input type="number" name="tip_delay" value="0" min="0" class="layui-input"></div><div class="layui-form-mid layui-word-aux">0为禁用弹窗</div></div>');
                    form.render('checkbox');
                } else {
                    fieldElem.find('[name=tip_delay]').closest('.layui-form-item').remove();
                }
            },
            'pc_enabled': function (enabled) {
                if (enabled) {
                    fieldElem.append('<div class="layui-form-item"><label class="layui-form-label">启用PC:</label><div class="layui-input-block"><input type="checkbox" name="pc_enabled" lay-skin="switch" lay-text="启用|禁用" checked></div></div>');
                    form.render('checkbox');
                } else {
                    fieldElem.find('[name=pc_enabled]').closest('.layui-form-item').remove();
                }
            },
            'mobile_enabled': function (enabled) {
                if (enabled) {
                    fieldElem.append('<div class="layui-form-item"><label class="layui-form-label">启用Mobile:</label><div class="layui-input-block"><input type="checkbox" name="mobile_enabled" lay-skin="switch" lay-text="是|否" checked></div></div>');
                    form.render('checkbox');
                } else {
                    fieldElem.find('[name=mobile_enabled]').closest('.layui-form-item').remove();
                }
            },
            'max': function (enabled) {
                if (enabled) {
                    fieldElem.append('<div class="layui-form-item"><label class="layui-form-label">最大限制:</label><div class="layui-input-inline"><input type="number" name="max" value="0" min="0" class="layui-input"></div><div class="layui-form-mid layui-word-aux">0为不限制</div></div>');
                    form.render('checkbox');
                } else {
                    fieldElem.find('[name=max]').closest('.layui-form-item').remove();
                }
            },
            'weight': function (enabled) {
                if (enabled) {
                    fieldElem.append('<div class="layui-form-item"><label class="layui-form-label">权重:</label><div class="layui-input-inline"><div id="weight" class="slider-inline"></div><input type="hidden" name="weight" value="0" lay-verify="number"></div><div class="layui-form-mid layui-word-aux">值越高 几率越高</div></div>');
                    //滑块控制
                    main.slider({elem: '#weight', value: 0, max: 100});
                } else {
                    fieldElem.find('[name=weight]').closest('.layui-form-item').remove();
                }
            },
            'cities': function (enabled) {
                if (enabled) {
                    fieldElem.append('<div class="layui-form-item"><label class="layui-form-label" lay-tips="不选择则展示全部">屏蔽区域:</label><input type="hidden" name="cities" value=""><div class="layui-form-mid layui-word-aux"><i class="layui-icon layui-icon-edit" lay-event="cities" style="color:#22849b"></i><cite style="margin-left:10px"></cite></div></div>');
                    // 监控城市
                    $('*[lay-event="cities"]').off('click').on('click', function () {
                        main.display({
                            type: 0,
                            btn: ['确定'],
                            content: `<div id="cities"></div>`,
                            success: function (dom) {
                                //显示城市搜索框
                                transfer.render({
                                    title: ['全部区域', '屏蔽区域'],
                                    id: 'cityData',
                                    elem: dom.find('#cities'),
                                    data: citiesData,
                                    value: $('*[name=cities]').val().split(','),
                                    showSearch: true,
                                });
                            },
                            yes: function (index) {
                                let cityData = transfer.getData('cityData'), cities = [], titles = [];
                                $.each(cityData, function (i, v) {
                                    cities[i] = v.value;
                                    titles[i] = v.title;
                                });
                                $('*[name=cities]').val(cities.join());
                                $('*[name=cities]+div>cite').text(titles.join());
                                layer.close(index);
                            },
                            area: ["540px", "450px"],
                        });
                    });
                } else {
                    fieldElem.find('[name=cities]').closest('.layui-form-item').remove();
                }
            },
            'durations': function (enabled) {
                if (enabled) {
                    fieldElem.append(`<div class="layui-form-item" lay-filter="duration">
    <input type="hidden" name="durations">
    <label class="layui-form-label">时间范围:</label>
    <div class="layui-btn-group" style="line-height: 38px">
        <button class="layui-btn layui-btn-sm" lay-event="add-duration">
            <i class="layui-icon layui-icon-add-circle"></i>
        </button>
        <button class="layui-btn layui-btn-sm layui-bg-red" lay-event="del-duration" style="display:none;">
            <i class="layui-icon layui-icon-fonts-del"></i>
        </button>
    </div>
</div>`);
                    let addElem = $('*[lay-event=add-duration]', fieldElem),
                        delElem = $('*[lay-event=del-duration]', fieldElem);
                    // 添加时间段
                    addElem.off('click').on('click', function () {
                        let layKey = $(this).parents('div.layui-form-item').find('input:last').attr('lay-key') || 0;
                        layKey++
                        $(this).parent().before('<div class="layui-input-inline"><input type="text" name="duration" class="layui-input" id="date-' + layKey + '" placeholder=" - "></div>');
                        layDate.render({elem: '#date-' + layKey, type: 'time', range: true});
                        delElem.show(200);
                        form.render('input');
                    });
                    // 删除时间段
                    delElem.off('click').on('click', function () {
                        $(this).parents('div.layui-form-item').find('input:last').parent().remove();
                        let layKey = $(this).parents('div.layui-form-item').find('input:last').attr('lay-key');
                        if (typeof layKey === 'undefined') {
                            delElem.hide(200);
                        }
                    });
                } else {
                    fieldElem.find('[name=durations]').closest('.layui-form-item').remove();
                }
            },
            'consult': function (enabled) {
                if (enabled) {
                    fieldElem.append(`<div class="layui-form-item">
            <label class="layui-form-label">在线咨询:</label>
            <div class="layui-input-inline" style="width: 50%">
                <input name="consult" value="" placeholder="https://domain.com" class="layui-input">
            </div>
            <div class="layui-form-mid layui-word-aux">如QQ在线</div>
            <button class="layui-btn" lay-event="fill-consult">填充默认</button>
        </div>`);
                    form.render('input');
                    // 填充咨询链接
                    $('[lay-event="fill-consult"]').on('click', function () {
                        main.req({
                            url: '/contact/fill/consult',
                            ending: function (res) {
                                $('[name="consult"]').val(res.data);
                            }
                        });
                    });
                } else {
                    fieldElem.find('[name=consult]').closest('.layui-form-item').remove();
                }
            },
            'other': function (enabled) {
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
                        main.req({
                            url: '/contact/fill/other',
                            ending: function (res) {
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