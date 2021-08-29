<div class="layui-card layui-form">
    <div class="layui-card-body">
        <fieldset class="layui-elem-field">
            <legend>修改目标</legend>
            <input type="checkbox" data-field="pc_enabled" title="PC" lay-filter="field">
            <input type="checkbox" data-field="mobile_enabled" title="Mobile" lay-filter="field">
            <input type="checkbox" data-field="history_enabled" title="历史记录" lay-filter="field">
            <input type="checkbox" data-field="max" title="最大限制" lay-filter="field">
            <input type="checkbox" data-field="weight" title="权重" lay-filter="field">
            <input type="checkbox" data-field="durations" title="时间段" lay-filter="field">
            <input type="checkbox" data-field="cities" title="城市" lay-filter="field">
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
        form.on('checkbox(field)', function (obj) {
            switch ($(this).attr('data-field')) {
                case 'pc_enabled':
                    if (obj.othis.attr('class').indexOf('layui-form-checked') !== -1) {
                        fieldElem.append(`<div class="layui-form-item">
    <label class="layui-form-label">启用PC:</label>
    <div class="layui-input-block">
        <input type="checkbox" name="pc_enabled" lay-skin="switch" lay-text="启用|禁用" checked>
    </div>
</div>`);
                        form.render('checkbox');
                    } else {
                        fieldElem.find('[name=pc_enabled]').closest('.layui-form-item').remove();
                    }
                    break;
                case 'mobile_enabled':
                    if (obj.othis.attr('class').indexOf('layui-form-checked') !== -1) {
                        fieldElem.append(`<div class="layui-form-item">
    <label class="layui-form-label">启用Mobile:</label>
    <div class="layui-input-block">
        <input type="checkbox" name="mobile_enabled" lay-skin="switch" lay-text="是|否" checked>
    </div>
</div>`);
                        form.render('checkbox');
                    } else {
                        fieldElem.find('[name=mobile_enabled]').closest('.layui-form-item').remove();
                    }
                    break;
                case 'history_enabled':
                    if (obj.othis.attr('class').indexOf('layui-form-checked') !== -1) {
                        fieldElem.append(`<div class="layui-form-item">
    <label class="layui-form-label">历史记录:</label>
    <div class="layui-input-block">
        <input type="checkbox" name="history_enabled" lay-skin="switch" lay-text="是|否">
    </div>
</div>`);
                        form.render('checkbox');
                    } else {
                        fieldElem.find('[name=history_enabled]').closest('.layui-form-item').remove();
                    }
                    break;
                case 'max':
                    if (obj.othis.attr('class').indexOf('layui-form-checked') !== -1) {
                        fieldElem.append(`<div class="layui-form-item">
                    <label class="layui-form-label">最大限制:</label>
                    <div class="layui-input-inline">
                        <input type="number" name="max" value="0" min="0" class="layui-input">
                    </div>
                    <div class="layui-form-mid layui-word-aux">0为不限制</div>
                </div>`);
                        form.render('checkbox');
                    } else {
                        fieldElem.find('[name=max]').closest('.layui-form-item').remove();
                    }
                    break;
                case 'weight':
                    if (obj.othis.attr('class').indexOf('layui-form-checked') !== -1) {
                        fieldElem.append(`<div class="layui-form-item">
    <label class="layui-form-label">权重:</label>
    <div class="layui-input-inline">
        <div id="weight" class="slider-inline"></div>
        <input type="hidden" name="weight" value="0" lay-verify="number">
    </div>
    <div class="layui-form-mid layui-word-aux">值越高 几率越高</div>
</div>`);
                        //滑块控制
                        main.slider({elem: '#weight', value: 0, max: 100});
                    } else {
                        fieldElem.find('[name=weight]').closest('.layui-form-item').remove();
                    }
                    break;
                case 'cities':
                    if (obj.othis.attr('class').indexOf('layui-form-checked') !== -1) {
                        fieldElem.append('<div class="layui-form-item"><label class="layui-form-label" lay-tips="不选择则展示全部">区域:</label><button class="layui-btn" lay-event="cities">选择城市</button><input type="hidden" name="cities" value=""></div>');
                        // 监控城市
                        $('*[lay-event="cities"]').click(function () {
                            main.pop({
                                content: `<div id="cities"></div>`,
                                success: function (dom) {
                                    //显示城市搜索框
                                    transfer.render({
                                        title: ['全部城市', '城市'],
                                        id: 'cityData',
                                        elem: dom.find('#cities'),
                                        data: citiesData,
                                        value: $('*[name=cities]').val().split(','),
                                        showSearch: true,
                                    });
                                },
                                done: function () {
                                    let cityData = transfer.getData('cityData'),
                                        cities = [];
                                    $.each(cityData, function (i, v) {
                                        cities[i] = v.value;
                                    });
                                    $('*[name=cities]').val(cities.join())
                                }
                            });
                        });
                    } else {
                        fieldElem.find('[name=cities]').closest('.layui-form-item').remove();
                    }
                    break;
                case 'durations':
                    if (obj.othis.attr('class').indexOf('layui-form-checked') !== -1) {
                        fieldElem.append(`<div class="layui-form-item" lay-filter="duration">
    <input type="hidden" name="durations">
    <label class="layui-form-label">时间范围:</label>
    <div class="layui-btn-group">
        <button class="layui-btn" lay-event="add-duration">
            <i class="layui-icon layui-icon-add-circle"></i>
        </button>
        <button class="layui-btn layui-bg-red" lay-event="del-duration" style="display:none;">
            <i class="layui-icon layui-icon-fonts-del"></i>
        </button>
    </div>
</div>`);
                        let addElem = $('*[lay-event=add-duration]', fieldElem),
                            delElem = $('*[lay-event=del-duration]', fieldElem);
                        // 添加时间段
                        addElem.click(function () {
                            let layKey = $(this).parents('div.layui-form-item').find('input:last').attr('lay-key') || 0;
                            layKey++
                            $(this).parent().before('<div class="layui-input-inline"><input type="text" name="duration" class="layui-input" id="date-' + layKey + '" placeholder=" - "></div>');
                            layDate.render({elem: '#date-' + layKey, type: 'time', range: true});
                            delElem.css('display', 'inline-block');
                            form.render('input');
                        });
                        // 删除时间段
                        delElem.click(function () {
                            $(this).parents('div.layui-form-item').find('input:last').parent().remove();
                            let layKey = $(this).parents('div.layui-form-item').find('input:last').attr('lay-key');
                            if (typeof layKey === 'undefined') {
                                delElem.css('display', 'none');
                            }
                        });
                    } else {
                        fieldElem.find('[name=durations]').closest('.layui-form-item').remove();
                    }
                    break;
                case 'consult':
                    if (obj.othis.attr('class').indexOf('layui-form-checked') !== -1) {
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
                                url: '/contact/fill/consult', ending: function (res) {
                                    $('[name="consult"]').val(res.data);
                                }
                            });
                        });
                    } else {
                        fieldElem.find('[name=consult]').closest('.layui-form-item').remove();
                    }
                    break;
                case 'other':
                    if (obj.othis.attr('class').indexOf('layui-form-checked') !== -1) {
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
                        $('[lay-event="fill-other"]').on('click', function () {
                            main.req({
                                url: '/contact/fill/other', ending: function (res) {
                                    $('[name="other"]').val(res.data);
                                }
                            });
                        });
                    } else {
                        fieldElem.find('[name=other]').closest('.layui-form-item').remove();
                    }
                    break;
            }
        });
    });
</script>