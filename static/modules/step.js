/*转换解析方法*/
function onMethod() {
    $('button[parse-method]').off('click').on('click', function () {
        let parent = $(this).closest("div.parse-method");
        parent.addClass("layui-hide");
        parent.siblings().removeClass("layui-hide");
    });
    /* jquery 解析方法 attr text html*/
    layui.form.on('select(method)', function (obj) {
        switch (obj.value) {
            case 'attr':
                obj.othis.closest('.parse-method').find('input[name*=".attr_name."]').attr('type', 'text');
                obj.othis.closest('.layui-tab-item').find('input[name*=".raw."]').parent().addClass("layui-hide");
                break;
            case 'html':
                obj.othis.closest('.layui-tab-item').find('input[name*=".raw."]').parent().removeClass("layui-hide");
                obj.othis.closest('.parse-method').find('input[name*=".attr_name."]').attr('type', 'hidden');
                break;
            default:
                obj.othis.closest('.layui-tab-item').find('input[name*=".raw."]').parent().addClass("layui-hide");
                obj.othis.closest('.parse-method').find('input[name*=".attr_name."]').attr('type', 'hidden');
        }
    });
}

/* 翻译*/
layui.define(['form'], function (exports) {
    let $ = layui.$,
        form = layui.form,
        Class = function (engines) {
            this.engines = engines || [];
            this.data = {};
        };
    // 获取可用语言列表
    Class.prototype.get = function (engine) {
        let othis = this;
        if (othis.data[engine]) {
            return othis.data[engine];
        }
        $.ajaxSettings.async = false;
        $.get('/trans/select', {engine: engine}, function (res) {
            if (res.code === 0) {
                othis.data[engine] = res.data;
            } else {
                layui.layer.alert(res.msg, {icon: 2});
            }
        });
        $.ajaxSettings.async = true;
        return othis.data[engine];
    };
    // 获取翻译序号
    Class.prototype.getId = function (id) {
        id = parseInt(id);
        if (!id) {
            let name = $('#trans-items [name]').last().attr('name');
            if (name) {
                let names = name.split('.');
                id = parseInt(names[names.length - 1]) || 0;
            } else {
                id = 0;
            }
        }
        id++;
        return id;
    };
    // 添加翻译
    Class.prototype.add = function (options) {
        options = options || {};
        let id = this.getId(options['id']), // 索引
            engine = options['engine'] || this.engines[0].name, // 引擎
            data = this.get(engine), // 引擎对应的数据
            dom = $(`<div class="layui-form-item"><div class="layui-inline" style="top:-5px"><input type="checkbox" name="trans.enabled." lay-skin="switch" lay-text="启用|禁用" checked></div><div class="layui-inline"><label class="layui-form-label-col">引擎:</label></div><div class="layui-inline width120"><select name="trans.engine." lay-filter="trans.engine"></select></div><div class="layui-inline width120"><select class="layui-select" name="trans.source." lay-search></select></div><div class="layui-inline"><label class="layui-form-label-col" style="color: #009688;"><i class="layui-icon layui-icon-spread-left"></i></label></div><div class="layui-inline width120"><select class="layui-select" name="trans.target." lay-search></select></div><div class="layui-inline"><label class="layui-form-label-col" style="color: #009688;"><i class="layui-icon layui-icon-set-sm" lay-tips="选择翻译配置"></i></label></div><div class="layui-inline width120"><select class="layui-select" name="trans.cfg_id." lay-search></select></div><i class="layui-icon layui-icon-delete" lay-event="del" lay-tips="删除该项"></i></div>`);
        if (!data) {
            console.error("翻译数据为空");
            return false;
        }
        // 全部name 加上序号
        dom.find('[name]').each(function () {
            let that = $(this);
            that.attr('name', that.attr('name') + id);
        });
        // 是否启用
        if ('enabled' in options) {
            dom.find('[name^="trans.enabled."]').first().prop('checked', options.enabled);
        }
        // 搜索引擎选择列表
        let engineHtml = '';
        $.each(this.engines, function (i, v) {
            if (engine === v['name']) {
                engineHtml += '<option value="' + v['name'] + '" selected>' + v['alias'] + '</option>';
            } else {
                engineHtml += '<option value="' + v['name'] + '">' + v['alias'] + '</option>';
            }
        });
        dom.find('select[name^="trans.engine."]').first().html(engineHtml);
        // 源语言选择列表
        let source = options['source'] || '',
            sourceHtml = '<option value="">搜索...</option>';
        $.each(data.sources, function (i, v) {
            if (source === v['name']) {
                sourceHtml += '<option value="' + v['name'] + '" selected>' + v['alias'] + '</option>';
            } else {
                sourceHtml += '<option value="' + v['name'] + '">' + v['alias'] + '</option>';
            }
        });
        dom.find('select[name^="trans.source."]').first().html(sourceHtml);
        // 目标语言选择列表
        let target = options['target'] || '',
            targetHtml = '<option value="">搜索...</option>';
        $.each(data['targets'], function (i, v) {
            if (target === v['name']) {
                targetHtml += '<option value="' + v['name'] + '" selected>' + v['alias'] + '</option>';
            } else {
                targetHtml += '<option value="' + v['name'] + '">' + v['alias'] + '</option>';
            }
        });
        dom.find('select[name^="trans.target."]').first().html(targetHtml);

        // 可选择的翻译ID
        let cfgId = parseInt(options['cfg_id']) || 0,
            cfgHtml = '<option value="">搜索...</option>';
        $.each(data['cfg_ids'], function (i, v) {
            if (cfgId === v) {
                cfgHtml += '<option value="' + v + '" selected>' + v + '</option>';
            } else {
                cfgHtml += '<option value="' + v + '">' + v + '</option>';
            }
        });
        dom.find('select[name^="trans.cfg_id."]').first().html(cfgHtml);
        $('#trans-items').append(dom);
    };
    // 监控已经改变的翻译引擎
    Class.prototype.changed = function () {
        let othis = this;
        form.on('select(trans.engine)', function (obj) {
            let parentThis = $($(obj.elem).closest('.layui-form-item')),
                data = othis.get(obj.value);
            if (data && parentThis) {
                // 源语言选择列表
                let sourceHtml = '<option value="">搜索...</option>';
                $.each(data.sources, function (i, v) {
                    sourceHtml += '<option value="' + v['name'] + '">' + v['alias'] + '</option>';
                });
                parentThis.find('select[name^="trans.source."]').first().html(sourceHtml);
                // 目标语言选择列表
                let targetHtml = '<option value="">搜索...</option>';
                $.each(data['targets'], function (i, v) {
                    targetHtml += '<option value="' + v['name'] + '">' + v['alias'] + '</option>';
                });
                parentThis.find('select[name^="trans.target."]').first().html(targetHtml);
                // 可选择的翻译ID
                let cfgHtml = '<option value="">搜索...</option>';
                $.each(data['cfg_ids'], function (i, v) {
                    cfgHtml += '<option value="' + v + '">' + v + '</option>';
                });
                parentThis.find('select[name^="trans.cfg_id."]').first().html(cfgHtml);
                // 重新渲染
                form.render('select');
            }
        });
    };
    // 渲染翻译
    Class.prototype.render = function (items) {
        let othis = this;
        $('[lay-event="add-trans"]').off('click').on('click', function () {
            othis.add();
            layui.main.on.del();
            othis.changed();
            form.render();
        });
        if (items) {
            $.each(items, function (i, v) {
                othis.add(v);
            });
            layui.main.on.del();
            othis.changed();
            form.render();
        }
    };
    exports('trans', function (options) {
        options = options || {};
        // 设置翻译引擎
        let obj = new Class(options['engines']);
        // 渲染翻译
        obj.render(options['items']);
    });
});
/*列表*/
layui.define(['form'], function (exports) {
    let $ = layui.$,
        form = layui.form,
        element = layui.element,
        Class = function (rules) {
            this.rules = rules || [];
            this.data = {};
        };
    // 获取序号
    Class.prototype.getId = function (id) {
        id = parseInt(id);
        if (!isNaN(id)) {
            return id;
        }
        id = parseInt($('[lay-filter=step-list]>.layui-tab-title>li[lay-id]').last().attr('lay-id'));
        if (!isNaN(id)) {
            id++;
            return id;
        }
        return 0;
    };
    // 添加
    Class.prototype.add = function (field) {
        field = field || {};
        let id = this.getId(field['id']), // 索引
            dom = $(`<div class="layui-tab-item layui-show"><div class="layui-collapse" lay-accordion><div class="layui-colla-item"><h2 class="layui-colla-title">列表采集</h2><div class="layui-colla-content layui-show"><fieldset class="layui-elem-field layui-field-title"><legend>获取</legend></fieldset><div class="layui-form-item"><div class="layui-inline"><label class="layui-form-label-col">指定范围:</label></div><div class="layui-inline"><div class="layui-input-inline"><input type="text" name="list.limit." value="" class="layui-input"                                    placeholder="&lt;html[^&gt;]*&gt;([\\\\s\\\\S]*?)&lt;/html&gt;"></div><div class="layui-form-mid layui-word-aux">指定获取范围 为空则不指定 &lt;html[^&gt;]*&gt;([\\\\s\\\\S]*?)&lt;/html&gt;</div></div></div><div class="layui-form-item"><div class="parse-method"><div class="layui-inline"><label class="layui-form-label-col" lay-tips="一行一条规则，逐行匹配到则终止匹配">DOM解析:</label></div><div class="layui-inline"><textarea class="layui-textarea" name="list.dom." placeholder="list>h3>a&#13;list-img>h3>a"></textarea></div><div class="layui-inline" lay-tips="选择dom取值方法"><div class="layui-input-inline" style="width: 80px"><select name="list.method." lay-filter="method"><option value="attr">Attr</option><option value="text">Text</option><option value="html">Html</option></select></div></div><div class="layui-inline" lay-tips="属性名称 默认为 href"><input type="text" name="list.attr_name." value="href" class="layui-input"></div><div class="layui-inline"><button class="layui-btn layui-btn-radius" parse-method>转为正则解析</button></div></div><div class="parse-method layui-hide"><div class="layui-inline"><label class="layui-form-label-col">正则解析:</label></div><div class="layui-inline" style="width: 55%" lay-tips="一行一条规则，逐行匹配到则终止匹配"><textarea class="layui-textarea" name="list.reg." placeholder="href=(https://.*?)&#13;href(.*?)"></textarea></div><div class="layui-inline"><button class="layui-btn layui-btn-radius" parse-method>转为DOM解析</button></div></div></div><fieldset class="layui-elem-field layui-field-title"><legend>正则过滤</legend></fieldset><div class="layui-form-item"><label class="layui-form-label"                           lay-tips="例如:只匹配以/index.html结尾的数据 /index\\\\.html$">正则匹配:</label><div class="layui-input-block"><input type="text" name="list.match." value="" class="layui-input"                                placeholder="/\\\\d+\\\\.html$"></div></div><fieldset class="layui-elem-field layui-field-title"><legend>字符串、正则或DOM替换</legend></fieldset><div class="layui-form-item"><div class="layui-inline" style="width: 38%" lay-tips="原词 一行一条"><textarea name="list.olds." class="layui-textarea" placeholder="ivf&#13;南方ivf"></textarea></div><div class="layui-inline"><label class="layui-form-label-col" style="color: #009688;"><i class="layui-icon layui-icon-spread-left"></i></label></div><div class="layui-inline" style="width: 38%" lay-tips="替换成 对应原词一行一条"><textarea name="list.news." class="layui-textarea" placeholder="试管婴儿&#13;南方39"></textarea></div><div class="layui-inline" style="width: 12%"><select name="list.type." class="layui-select"><option value="0" selected>字符串</option><option value="1">正则</option><option value="2">DOM</option></select></div></div></div></div><div class="layui-colla-item"><h2 class="layui-colla-title">分页采集</h2><div class="layui-colla-content"><div class="layui-form-item"><label class="layui-form-label">开启分页:</label><div class="layui-input-inline"><input type="checkbox" name="list.page.enabled." lay-skin="switch"                               lay-text="开启|关闭"></div></div><fieldset class="layui-elem-field layui-field-title"><legend>获取</legend></fieldset><div class="layui-form-item"><div class="layui-inline"><label class="layui-form-label-col">指定范围:</label></div><div class="layui-inline"><div class="layui-input-inline"><input type="text" name="list.page.limit." value=""                                   class="layui-input"                                   placeholder="&lt;html[^&gt;]*&gt;([\\\\s\\\\S]*?)&lt;/html&gt;"></div><div class="layui-form-mid layui-word-aux">指定获取范围 为空则不指定 &lt;html[^&gt;]*&gt;([\\\\s\\\\S]*?)&lt;/html&gt;</div></div></div><div class="layui-form-item"><div class="parse-method"><div class="layui-inline"><label class="layui-form-label-col">DOM解析:</label></div><div class="layui-inline" lay-tips="一行一条规则，逐行匹配到则终止匹配"><textarea class="layui-textarea" name="list.page.dom." placeholder="a&#13;title"></textarea></div><div class="layui-inline" lay-tips="选择dom取值方法"><div class="layui-input-inline" style="width: 80px"><select name="list.page.method." lay-filter="method"><option value="attr">Attr</option><option value="text">Text</option><option value="html">Html</option></select></div></div><div class="layui-inline" lay-tips="属性名称 默认为 href"><input type="text" name="list.page.attr_name." value="href" class="layui-input"></div><div class="layui-inline"><button class="layui-btn layui-btn-radius" parse-method>转为正则解析</button></div></div><div class="parse-method layui-hide"><div class="layui-inline"><label class="layui-form-label-col">正则解析:</label></div><div class="layui-inline" style="width: 55%" lay-tips="一行一条规则，逐行匹配到则终止匹配"><textarea class="layui-textarea" name="list.page.reg." placeholder="href=&#34;(.*?)&#34;"></textarea></div><div class="layui-inline"><button class="layui-btn layui-btn-radius" parse-method>转为DOM解析</button></div></div></div><fieldset class="layui-elem-field layui-field-title"><legend>正则过滤</legend></fieldset><div class="layui-form-item"><label class="layui-form-label"                           lay-tips="例如:只匹配以/index.html结尾的数据 /index\\\\.html$">正则匹配:</label><div class="layui-input-block"><input type="text" name="list.page.match." value="" class="layui-input"                               placeholder="/\\\\d+\\\\.html$"></div></div><fieldset class="layui-elem-field layui-field-title"><legend>字符串、正则或DOM替换</legend></fieldset><div class="layui-form-item"><div class="layui-inline" style="width: 38%" lay-tips="原词 一行一条"><textarea name="list.page.olds." class="layui-textarea" placeholder="ivf&#13;代孕"></textarea></div><div class="layui-inline"><label class="layui-form-label-col" style="color: #009688;"><i class="layui-icon layui-icon-spread-left"></i></label></div><div class="layui-inline" style="width: 38%" lay-tips="替换成 对应原词一行一条"><textarea name="list.page.news." class="layui-textarea" placeholder="试管婴儿&#13;助孕"></textarea></div><div class="layui-inline" style="width: 12%"><select name="list.page.type." class="layui-select"><option value="0" selected>字符串</option><option value="1">正则</option><option value="2">DOM</option></select></div></div></div></div></div></div>`);
        // 添加头部
        $('[lay-filter="step-list"]>.layui-tab-title>li').removeClass('layui-this');
        $('[lay-filter="step-list"]>.layui-tab-title').append('<li lay-id="' + id + '" class="layui-this">Rule-' + (id + 1) + '</li>');
        // 全部name 加上序号
        dom.find('[name]').each(function () {
            let that = $(this);
            that.attr('name', that.attr('name') + id);
        });
        if (field && typeof field.dom === 'string') {
            field = $.extend({limit: '', reg: '', method: 'attr', attr_name: '', match: '', type: 0}, field);
            field.olds = field.olds || [];
            field.news = field.news || [];
            dom.find('[name^="list.limit."]').val(field.limit);
            if (field.reg.length > 0) {
                dom.find('[name^="list.reg."]').val(field.reg)
                    .closest('.parse-method').removeClass('layui-hide');
                dom.find('[name^="list.dom."]')
                    .closest('.parse-method').addClass('layui-hide');
            } else {
                dom.find('[name^="list.dom."]').val(field.dom)
                    .closest('.parse-method').removeClass('layui-hide');
                dom.find('[name^="list.reg."]')
                    .closest('.parse-method').addClass('layui-hide');
            }
            dom.find('[name^="list.method."]>option[value=' + field.method + ']').prop('selected', true);
            dom.find('[name^="list.attr_name."]').val(field.attr_name);
            dom.find('[name^="list.match."]').val(field.match);
            dom.find('[name^="list.olds."]').val(field.olds.join('\n'));
            dom.find('[name^="list.news."]').val(field.news.join('\n'));
            dom.find('[name^="list.type."]>option[value=' + field.type + ']').prop('selected', true);
            if (field.page) {
                field.page = $.extend({
                    enabled: false,
                    limit: '',
                    method: '',
                    attr_name: '',
                    match: '',
                    type: 0,
                    reg: '',
                    dom: ''
                }, field.page);
                field.page.olds = field.page.olds || [];
                field.page.news = field.page.news || [];
                dom.find('[name^="list.page.enabled."]').prop('checked', field.page.enabled);
                dom.find('[name^="list.page.limit."]').val(field.page.limit);
                dom.find('[name^="list.page.method."]>option[value=' + field.page.method + ']').prop('selected', true);
                dom.find('[name^="list.page.attr_name."]').val(field.page.attr_name);
                dom.find('[name^="list.page.match."]').val(field.page.match);
                dom.find('[name^="list.page.olds."]').val(field.page.olds.join('\n'));
                dom.find('[name^="list.page.news."]').val(field.page.news.join('\n'));
                dom.find('[name^="list.page.type."]>option[value=' + field.page.type + ']').prop('selected', true);
                if (field.page.reg.length > 0) {
                    dom.find('[name^="list.page.reg."]').val(field.page.reg)
                        .closest('.parse-method').removeClass('layui-hide');
                    dom.find('[name^="list.page.dom."]')
                        .closest('.parse-method').addClass('layui-hide');
                } else {
                    dom.find('[name^="list.page.dom."]').val(field.page.dom)
                        .closest('.parse-method').removeClass('layui-hide');
                    dom.find('[name^="list.page.reg."]')
                        .closest('.parse-method').addClass('layui-hide');
                }
            }
        }
        $('[lay-filter="step-list"]>.layui-tab-content>.layui-tab-item').removeClass('layui-show');
        $('[lay-filter="step-list"]>.layui-tab-content').append(dom);
    };
    // 渲染
    Class.prototype.render = function (items) {
        let othis = this;
        items = $.isArray(items) ? items : [];
        if (items.length === 0) {
            items.push({});
        }
        $.each(items, function (i, v) {
            othis.add(v);
        });
        element.render();
        form.render();
        onMethod();
        $('[lay-filter="step-list"]>ul>li').first().click();
        // 监控 添加列表规则
        $("#add-rule").off('click').on('click', function () {
            othis.add();
            element.render();
            form.render();
            onMethod();
        });
    };
    exports('rules', function (options) {
        let obj = new Class();
        obj.render(options || {});

    });
});
/*详情列表*/
layui.define(['form'], function (exports) {
    let $ = layui.$,
        form = layui.form,
        element = layui.element,
        Class = function (rules) {
            this.rules = rules || [];
            this.data = {};
        };
    // 获取序号
    Class.prototype.getId = function (id) {
        id = parseInt(id);
        if (!isNaN(id)) {
            return id;
        }
        id = parseInt($('[lay-filter=step-detail]>.layui-tab-title>li[lay-id]').last().attr('lay-id'));
        if (!isNaN(id)) {
            id++;
            return id;
        }
        return 0;
    };
    // 添加
    Class.prototype.add = function (field) {
        if (Object.prototype.toString.call(field) !== '[object Object]' || typeof field.name !== 'string' || field.name.length === 0) {
            return false;
        }
        if (typeof field.alias !== 'string' || field.alias.length === 0) {
            field.alias = field.name.substring(0, 1).toUpperCase() + field.name.substring(1);
        }
        let id = this.getId(field['id']), // 索引
            dom = $(`<div class="layui-tab-item layui-show"><div class="layui-form-item"><div class="layui-inline"><label class="layui-form-label-col">指定范围:</label></div><div class="layui-inline"><div class="layui-input-inline"><input type="text" name="detail.limit." value="" class="layui-input" placeholder="&lt;html[^&gt;]*&gt;([\\\\s\\\\S]*?)&lt;/html&gt;"></div><div class="layui-form-mid layui-word-aux">指定获取范围 为空则不指定 &lt;html[^&gt;]*&gt;([\\\\s\\\\S]*?)&lt;/html&gt;</div></div></div><div class="layui-form-item"><div class="parse-method"><div class="layui-inline"><label class="layui-form-label-col" lay-tips="一行一条规则，逐行匹配到则终止匹配">DOM解析:</label></div><div class="layui-inline"><textarea class="layui-textarea" name="detail.dom." placeholder="a&#13;h3 a"></textarea></div><div class="layui-inline" lay-tips="选择dom取值方法"><div class="layui-input-inline" style="width: 80px"><select name="detail.method." lay-filter="method"><option value="text">Text</option><option value="attr">Attr</option><option value="html">Html</option></select></div></div><div class="layui-inline" lay-tips="属性名称 默认为 href"><input type="hidden" name="detail.attr_name." value="href" class="layui-input"></div><div class="layui-inline"><button class="layui-btn layui-btn-radius" parse-method>转为正则解析</button></div></div><div class="parse-method layui-hide"><div class="layui-inline"><label class="layui-form-label-col" lay-tips="一行一条规则，逐行匹配到则终止匹配">正则解析:</label></div><div class="layui-inline" style="width: 55%"><textarea class="layui-textarea" name="detail.reg." placeholder="href=&#34;(.*?)&#34;&#13;ivf"></textarea></div><div class="layui-inline"><button class="layui-btn layui-btn-radius" parse-method>转为DOM解析</button></div></div></div><fieldset class="layui-elem-field layui-field-title"><legend>正则过滤</legend></fieldset><div class="layui-form-item"><label class="layui-form-label" lay-tips="例如:只匹配以/index.html结尾的数据 /index\\\\.html$">正则匹配:</label><div class="layui-input-block"><input type="text" name="detail.match." value="" class="layui-input" placeholder="/\\\\d+\\\\.html$"></div></div><fieldset class="layui-elem-field layui-field-title"><legend>DOM替换</legend></fieldset><div class="layui-form-item"><div class="layui-inline" style="width: 45%" lay-tips="原词 一行一条"><textarea name="detail.filter_dom.olds." class="layui-textarea" placeholder="body>a&#13;h3>a"></textarea></div><div class="layui-inline"><label class="layui-form-label-col" style="color: #009688;"><i class="layui-icon layui-icon-spread-left"></i></label></div><div class="layui-inline" style="width: 45%" lay-tips="替换成 对应原词一行一条"><textarea name="detail.filter_dom.news." class="layui-textarea" placeholder="替换词1&#13;替换词2"></textarea></div></div><fieldset class="layui-elem-field layui-field-title"><legend>字符串、正则或DOM替换</legend></fieldset><div class="layui-form-item"><div class="layui-inline" style="width: 38%" lay-tips="原词 一行一条"><textarea name="detail.olds." class="layui-textarea" placeholder="原词1&#13;原词2"></textarea></div><div class="layui-inline"><label class="layui-form-label-col" style="color: #009688;"><i class="layui-icon layui-icon-spread-left"></i></label></div><div class="layui-inline" style="width: 38%" lay-tips="替换成 对应原词一行一条"><textarea name="detail.news." class="layui-textarea" placeholder="替换词1&#13;替换词2"></textarea></div><div class="layui-inline" style="width: 12%"><select name="detail.type." class="layui-select"><option value="0" selected>字符串</option><option value="1">正则</option><option value="2">DOM</option></select></div></div><div class="layui-form-item"><div class="layui-inline layui-hide"><input type="checkbox" name="detail.raw." title="原始"></div></div></div>`);
        // 删除头部显示类
        $('[lay-filter="step-detail"]>.layui-tab-title>li').removeClass('layui-this');
        // 添加头部
        $('[lay-filter="step-detail"]>.layui-tab-title').append('<li lay-id="' + id + '" class="layui-this">' + field.alias + '</li>');

        // 全部name 加上序号
        dom.find('[name]').each(function () {
            let that = $(this);
            that.attr('name', that.attr('name') + id);
        });
        if (typeof field.dom === 'string') {
            field = $.extend({
                limit: '',
                method: '',
                attr_name: '',
                match: '',
                type: 0,
                raw: false,
                reg: '',
                filter_dom: null
            }, field);
            field.olds = field.olds || [];
            field.news = field.news || [];
            dom.find('[name^="detail.limit."]').val(field.limit);
            dom.find('[name^="detail.method."]>option[value=' + field.method + ']').prop('selected', true);
            dom.find('[name^="detail.attr_name."]').val(field.attr_name);
            dom.find('[name^="detail.match."]').val(field.match);
            if (field.filter_dom) {
                field.filter_dom.olds = field.filter_dom.olds || [];
                field.filter_dom.news = field.filter_dom.news || [];
                dom.find('[name^="detail.filter_dom.olds."]').val(field.filter_dom.olds.join('\n'));
                dom.find('[name^="detail.filter_dom.news."]').val(field.filter_dom.news.join('\n'));
            }
            dom.find('[name^="detail.olds."]').val(field.olds.join('\n'));
            dom.find('[name^="detail.news."]').val(field.news.join('\n'));
            dom.find('[name^="detail.type."]>option[value=' + field.type + ']').prop('selected', true);
            dom.find('[name^="detail.raw."]').prop('checked', field.raw);
            if (field.reg.length > 0) {
                dom.find('[name^="detail.reg."]').val(field.reg)
                    .closest('.parse-method').removeClass('layui-hide');
                dom.find('[name^="detail.dom."]')
                    .closest('.parse-method').addClass('layui-hide');
            } else {
                dom.find('[name^="detail.dom."]').val(field.dom)
                    .closest('.parse-method').removeClass('layui-hide');
                dom.find('[name^="detail.reg."]')
                    .closest('.parse-method').addClass('layui-hide');
                if (field.method === 'html') {
                    dom.find('[name^="detail.raw."]').parent().removeClass('layui-hide');
                }
            }
        } else {
            switch (field.name) {
                case 'title':
                    dom.find('[name^="detail.dom."]').val('h1');
                    dom.find('[name^="detail.method."]>option[value=text]').prop('selected', true);
                    break;
                case 'tags':
                    dom.find('[name^="detail.dom."]').val('.tags a');
                    dom.find('[name^="detail.method."]>option[value=text]').prop('selected', true);
                    break;
                case 'content':
                    dom.find('[name^="detail.dom."]').val('body');
                    dom.find('[name^="detail.method."]>option[value=html]').prop('selected', true);
                    dom.find('[name^="detail.raw."]').parent().removeClass('layui-hide');
                    break;
                case 'keywords':
                    dom.find('[name^="detail.dom."]').val('meta[name=keywords]');
                    dom.find('[name^="detail.method."]>option[value=attr]').prop('selected', true);
                    dom.find('[name^="detail.attr_name."]').val('content').attr('type', 'text');
                    break;
                case 'description':
                    dom.find('[name^="detail.dom."]').val('meta[name=description]');
                    dom.find('[name^="detail.method."]>option[value=attr]').prop('selected', true);
                    dom.find('[name^="detail.attr_name."]').val('content').attr('type', 'text');
                    break;
            }
        }
        dom.append(`<div class="layui-hide"><input type="hidden" name="detail.alias.` + id + `" value="` + field.alias + `"><input type="hidden" name="detail.name.` + id + `" value="` + field.name + `"></div>`);
        $('[lay-filter="step-detail"]>.layui-tab-content>.layui-tab-item').removeClass('layui-show');
        $('[lay-filter="step-detail"]>.layui-tab-content').append(dom);
    };
    // 渲染
    Class.prototype.render = function (items) {
        let othis = this;
        if (items) {
            $.each(items, function (i, v) {
                v.id = i;
                othis.add(v);
            });
            element.render();
            form.render();
            onMethod();
            $('[lay-filter="step-detail"]>ul>li').first().click();
        }
        $("#add-detail").off('click').on('click', function () {
            let names = [], aliases = [];
            $('[lay-filter="step-detail"] [name^="detail.name."]').each(function () {
                names.push($(this).val());
            });
            $('[lay-filter="step-detail"] [name^="detail.alias."]').each(function () {
                aliases.push($(this).val());
            });
            layer.prompt({
                formType: 0,
                value: 'author',
                title: '输入标识 由字母下划线或数字组成 字母开头'
            }, function (name, index) {
                if (!/^[a-zA-Z][a-zA-Z0-9_]+/.test(name)) {
                    layer.alert('您输入的标识不合法!', {icon: 2});
                    return false;
                }
                if (names.indexOf(name) !== -1) {
                    layer.alert('您输入的标识"' + name + '"已经存在', {icon: 2});
                    return false;
                }
                layer.prompt({
                    formType: 0,
                    value: name.substring(0, 1).toUpperCase() + name.substring(1),
                    title: '请输入别名 例如:标题'
                }, function (alias, index) {
                    if (aliases.indexOf(alias) !== -1) {
                        layer.alert('您输入的别名"' + alias + '"已经存在', {icon: 2});
                        return false;
                    }
                    othis.add({name: name, alias: alias});
                    layer.close(index);
                    element.render();
                    form.render();
                    onMethod();
                });
                layer.close(index);
            });
        });
    };
    exports('detail', function (options) {
        let obj = new Class();
        obj.render(options || {});
    });
});
/*采集爬虫*/
layui.define(['form', 'trans', 'rules', 'detail', 'main'], function (exports) {
    let $ = layui.jquery,
        form = layui.form,
        main = layui.main,
        Class = function (position) {
            this.elem = '.step-header';
            this.titleW = '90%';
            this.position = parseInt(position) || 0;// 当前位置
            this.stepItems = [
                {title: '基本设置'},
                {title: '列表规则'},
                {title: '详情页'},
                {title: '定时采集'},
            ]; // 进度条
            this.classes = {};
            this.seeds = [];
            this.currentIndex = $('.step-content').closest('[times]').attr('times'); //先得到当前iframe层的索引;
        };
    // 渲染头部进度条
    Class.prototype.renderHeader = function () {
        let othis = this;
        let stepDiv = '<div class="lay-step">';
        for (let i = 0; i < this.stepItems.length; i++) {
            stepDiv += '<div class="step-item" data-step-item-index="' + i + '">';
            // 线
            if (i < (this.stepItems.length - 1)) {
                if (i < this.position) {
                    stepDiv += '<div class="step-item-tail"><i class="step-item-tail-done"></i></div>';
                } else {
                    stepDiv += '<div class="step-item-tail"><i></i></div>';
                }
            }
            // 数字
            let number = this.stepItems[i].number || i + 1;
            if (i === this.position) {
                stepDiv += '<div class="step-item-head step-item-head-active"><i class="layui-icon">' + number + '</i></div>';
            } else if (i < this.position) {
                stepDiv += '<div class="step-item-head"><i class="layui-icon layui-icon-ok"></i></div>';
            } else {
                stepDiv += '<div class="step-item-head "><i class="layui-icon">' + number + '</i></div>';
            }
            // 标题和描述
            let title = this.stepItems[i].title,
                desc = this.stepItems[i].desc;
            if (title || desc) {
                stepDiv += '<div class="step-item-main">';
                stepDiv += title ? '<div class="step-item-main-title">' + title + '</div>' : '';
                stepDiv += desc ? '<div class="step-item-main-desc">' + desc + '</div>' : '';
                stepDiv += '</div>';
            }
            stepDiv += '</div>';
        }
        stepDiv += '</div>';
        $(this.elem).html(stepDiv);
        // 计算每一个条目的宽度
        $('.step-item').css('width', (100 / this.stepItems.length) + '%');
        // 监控点击转到
        $('.step-item-head').off('click').on('click', function () {
            let index = parseInt($(this).parent().attr('data-step-item-index'));
            othis.position = isNaN(index) ? othis.position : index;
            othis.goto();
        });
    };
    /* 渲染上一步 下一步 */
    Class.prototype.renderGoto = function () {
        let next = this.position + 1,
            pre = this.position - 1,
            domAll = $('div.layui-layer-btn>a'),
            dom0 = $('div.layui-layer-btn>.layui-layer-btn0'),
            dom2 = $('div.layui-layer-btn>.layui-layer-btn2');
        switch (true) {
            case pre < 0:
                domAll.removeClass('layui-hide');
                $('div.layui-layer-btn>.layui-layer-btn0,div.layui-layer-btn>.layui-layer-btn1').addClass('layui-hide');
                break;
            case next >= this.stepItems.length:
                domAll.removeClass('layui-hide');
                dom2.addClass('layui-hide');
                break;
            default:
                domAll.removeClass('layui-hide');
                dom0.addClass('layui-hide');
                break;
        }
    };
    // 转到指定 position
    Class.prototype.goto = function () {
        //显示当前块
        this.showThis();
        //渲染头部
        this.renderHeader();
        //渲染 上下步
        this.renderGoto();
    };
    /* 监测 事件 */
    Class.prototype.events = function () {
        let othis = this;
        //监控上一步
        $('div.layui-layer-btn>.layui-layer-btn1').off('click').on('click', function () {
            othis.position--;
            othis.goto();
        });
        //监控下一步
        $('div.layui-layer-btn>.layui-layer-btn2').off('click').on('click', function () {
            $('.step-content>div').addClass('layui-form');
            $('a[data-step=' + othis.position + ']').click();
        });
        // 验证下一步
        form.on('submit(stepNext)', function () {
            othis.position++;
            othis.goto();
        });
    };
    // 绑定栏目
    Class.prototype.bindClass = function (site_id, class_id) {
        site_id = parseInt(site_id) || 0;
        class_id = parseInt(class_id) || 0;
        if (!site_id) {
            $('select[name=class_id]').html('<select name="class_id" lay-search><option value="">搜索...</option></select>');
            form.render('select');
            return false
        }
        if (typeof this.classes[site_id] === 'string' && this.classes[site_id].length > 10) {
            $('[lay-filter=class_id]').html(this.classes[site_id]);
            form.render();
            return false;
        }
        let othis = this;
        $.get('/site/class', {id: site_id, class_id: class_id}, function (res) {
            if (res.code === 0) {
                othis.classes[site_id] = res.data;
                $('[lay-filter=class_id]').html(res.data);
                form.render();
            } else {
                layer.alert(res.msg, {icon: 2});
            }
        });
    };
    // 显示当前块
    Class.prototype.showThis = function () {
        $('.step-content>div').removeAttr('style').eq(this.position).css({'display': 'block'});
    };
    // 总渲染
    Class.prototype.render = function () {
        layui.link('/static/style/step.css');
        this.contentW = this.contentW || this.titleW;
        if (this.position < 0) {
            this.position = 0;
        }
        if (this.position >= this.stepItems.length) {
            this.position = this.stepItems.length - 1;
        }
        // 渲染头部(进度条)
        this.renderHeader();
        $('.lay-step').css('width', this.titleW);
        /* 内容区域加上宽度 */
        $('.step-content').css('width', this.contentW);
        // 显示当前块
        this.showThis();
        /* 给内容区 加下一步标识*/
        $('.step-content>div').each(function (i) {
            $(this).children().eq(0).before('<a class="layui-hide" lay-submit lay-filter="stepNext" data-step="' + i + '"></a>');
        });
        // 添加提交按钮
        $('.step-content>div:first').before('<a class="layui-hide" lay-submit lay-filter="stepSubmit"></a>');
        // 渲染 上下步
        this.renderGoto();
        // 按钮添加样式
        $('div.layui-layer-btn>.layui-layer-btn0,div.layui-layer-btn>.layui-layer-btn2').css({
            background: '#009688', color: '#FFF'
        });
        /* 验证爬虫名称和种子 */
        form.verify({
            name: [/^.{2,}/, '第一步 爬虫名称必须2个字符以上！'],
            seeds: [/^\s*https?:\/\//i, '第一步 必须以http:// 或者 https:// 开头']
        });
        // 监控事件
        this.events();
    };
    // 导出接口
    exports('step', function (options) {
        options = options || {};
        let stepObj = new Class();
        $.extend(stepObj, options || {});
        stepObj.render();
        // 如果有翻译配置则
        if (layui.trans) {
            layui.trans(options.trans);
        }
        // 渲染列表
        layui.rules(options.rules);
        // 详情列表
        layui.detail(options.detail);
        // 监控下一个链接正则
        if ($('input[name="next_reg"]').val()) {
            $('#next-dom-toggle').click();
        }
        //监控选择网站ID
        form.on('select(site_id)', function (obj) {
            stepObj.bindClass(obj.value);
        });
        /*测试列表页*/
        $('button[data-event=testList]').off('click').on('click', function () {
            $('.step-content>div').removeClass('layui-form');
            $('button[lay-filter=testList]').click();
        });
        // 监控测试列表
        form.on('submit(testList)', function (obj) {
            main.req({
                    url: '/spider/test/list',
                    data: obj.field,
                    ending: function () {
                        main.ws.log("spider_test_list.0", function (dom) {
                            console.log(dom);
                        });
                        return false;
                    },
                    success: function (res) {
                        /*
                        if (res.code === 0 && res.data) {
                            stepObj.seeds = res.data;
                        }
                         */
                    }
                },
                $(obj.elem).closest(".layui-form"));
        });
        /*测试详情页*/
        $('button[data-event=testDetail]').off('click').on('click', function () {
            $('.step-content>div').removeClass('layui-form');
            $('button[lay-filter=testDetail]').click();
        });
        form.on('submit(testDetail)', function (obj) {
            if (stepObj.seeds.length === 0) {
                stepObj.seeds = obj.field.seeds.split("\n")
            }
            layer.prompt({
                formType: 0,
                value: stepObj.seeds[0],
                title: '请输入完整的URL地址 http 开头'
            }, function (value, index) {
                obj.field.detail_url = value;
                main.req({
                    url: '/spider/test/detail',
                    data: obj.field,
                    index: index,
                    ending: function (res) {
                        layer.open({
                            type: 1,
                            title: '测试详情页结果',
                            content: res.msg,
                            area: ['80%', '80%'],
                            btn: false,
                            maxmin: true,
                            shadeClose: true,
                        });
                        return false;
                    }
                });
            });
        });
        /*测试源码*/
        $('button[data-event=sourceCode]').off('click').on('click', function () {
            $('.step-content>div').removeClass('layui-form');
            $('button[lay-filter=sourceCode]').click();
        });
        /*提交测试源码*/
        form.on('submit(sourceCode)', function (obj) {
            if (stepObj.seeds.length === 0) {
                stepObj.seeds = obj.field.seeds.split("\n")
            }
            layer.prompt({
                formType: 0,
                value: stepObj.seeds[0],
                title: '请输入完整的URL地址 http 开头'
            }, function (value, index) {
                obj.field.detail_url = value;
                main.req({
                    url: '/spider/test/source',
                    data: obj.field,
                    index: index,
                    ending: function (res) {
                        layer.open({
                            type: 1,
                            title: '源码详情结果',
                            content: res.msg,
                            area: ['80%', '80%'],
                            btn: false,
                            maxmin: true,
                            shadeClose: true,
                        });
                        return false;
                    }
                });
            });
        });
        layui.element.render();
        form.render();
    });
});