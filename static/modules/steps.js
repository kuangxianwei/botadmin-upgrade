/* 翻译*/
layui.define(['form'], function (exports) {
    let $ = layui.$, form = layui.form;

    class Translate {
        constructor(engines) {
            this.engines = engines || [];
            this.data = {};
        }

        // 获取可用语言列表
        get(engine) {
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
        getId(id) {
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
        add(options) {
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
            let source = options['source'] || '', sourceHtml = '<option value="">搜索...</option>';
            $.each(data.sources, function (i, v) {
                if (source === v['name']) {
                    sourceHtml += '<option value="' + v['name'] + '" selected>' + v['alias'] + '</option>';
                } else {
                    sourceHtml += '<option value="' + v['name'] + '">' + v['alias'] + '</option>';
                }
            });
            dom.find('select[name^="trans.source."]').first().html(sourceHtml);
            // 目标语言选择列表
            let target = options['target'] || '', targetHtml = '<option value="">搜索...</option>';
            $.each(data['targets'], function (i, v) {
                if (target === v['name']) {
                    targetHtml += '<option value="' + v['name'] + '" selected>' + v['alias'] + '</option>';
                } else {
                    targetHtml += '<option value="' + v['name'] + '">' + v['alias'] + '</option>';
                }
            });
            dom.find('select[name^="trans.target."]').first().html(targetHtml);

            // 可选择的翻译ID
            let cfgId = parseInt(options['cfg_id']) || 0, cfgHtml = '<option value="">搜索...</option>';
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
        changed() {
            let othis = this;
            form.on('select(trans.engine)', function (obj) {
                let parentThis = $($(obj.elem).closest('.layui-form-item')), data = othis.get(obj.value);
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
        render(items) {
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
    }

    exports('trans', function (options) {
        options = options || {};
        (new Translate(options['engines'])).render(options['items']);
    });
});


/*采集爬虫*/
layui.define(['form', 'trans', 'main'], function (exports) {
    let $ = layui.jquery, form = layui.form, main = layui.main,
        getIndex = function (index, dom) {
            index = parseInt(index);
            if (!isNaN(index)) {
                return index;
            }
            index = parseInt(dom.find('ul.layui-tab-title>li[lay-id]').last().attr('lay-id'));
            if (!isNaN(index)) {
                index++;
                return index;
            }
            return 0;
        };

    class Steps {
        constructor(options) {
            options = options || {};
            layui.link('/static/style/steps.css');
            this.layerIndex = 0; // 当前弹窗ID
            this.position = 0; // 当前位置
            this.stepsItems = Array.isArray(options.stepsItems) ? options.stepsItems : [{title: '基本设置'}, {title: '列表规则'}, {title: '详情页'}, {title: '定时采集'}]; // 进度条
            this.classes = {}; //栏目
            this.seeds = []; // 种子列表
            this.dom = null;
            this.url = options.url;
        }

        // 显示当前块
        showThis() {
            this.dom.find('.layui-layer-content').animate({scrollTop: 0}, 400);
            this.dom.find('.steps-content>div').hide();
            this.dom.find('.steps-content>div[data-index=' + this.position + ']').show();
            this.dom.find('.steps-header .steps-item-head-active').removeClass('steps-item-head-active');
            this.dom.find('.steps-header>.steps-item[data-index=' + this.position + '] .steps-item-head').addClass('steps-item-head-active');
            /* 渲染上一步 下一步 */
            let $0 = this.dom.find('.layui-layer-btn>.layui-layer-btn0'),// 上一步
                $1 = this.dom.find('.layui-layer-btn>.layui-layer-btn1'),// 下一步
                $2 = this.dom.find('.layui-layer-btn>.layui-layer-btn2'); // 提交
            this.dom.find('.layui-layer-btn>a').show().removeAttr('style');
            if (this.position === 0) {
                $0.hide();
                $1.attr('data-index', this.position + 1).css({
                    background: 'rgb(0, 150, 136)',
                    color: 'rgb(255, 255, 255)'
                });
                $2.hide();
            } else if (this.position === this.stepsItems.length - 1) {
                $0.attr('data-index', this.position - 1);
                $1.hide();
                $2.css({
                    background: '#009688',
                    color: '#FFF'
                });
            } else {
                $0.attr('data-index', this.position - 1);
                $1.attr('data-index', this.position + 1).css({
                    background: '#009688',
                    color: '#FFF'
                });
                $2.hide();
            }
        };

        // 渲染头部进度条
        header() {
            this.dom.find('.layui-layer-title').remove();
            this.dom.prepend('<div class="layui-layer-title" style="height:auto;"><div class="steps-header"></div></div>');
            let headerHTML = '', $header = $('.layui-layer.steps .layui-layer-title .steps-header'),
                $content = $('.layui-layer.steps .layui-layer-content');
            for (let i = 0; i < this.stepsItems.length; i++) {
                headerHTML += '<div class="steps-item" data-index="' + i + '">';
                // 线
                if (i < (this.stepsItems.length - 1)) {
                    if (i < this.position) {
                        headerHTML += '<div class="steps-item-tail"><i class="steps-item-tail-done"></i></div>';
                    } else {
                        headerHTML += '<div class="steps-item-tail"><i></i></div>';
                    }
                }
                // 数字
                let number = this.stepsItems[i].number || i + 1;
                if (i === this.position) {
                    headerHTML += '<div class="steps-item-head steps-item-head-active"><i class="layui-icon">' + number + '</i></div>';
                } else if (i < this.position) {
                    headerHTML += '<div class="steps-item-head"><i class="layui-icon layui-icon-ok"></i></div>';
                } else {
                    headerHTML += '<div class="steps-item-head "><i class="layui-icon">' + number + '</i></div>';
                }
                // 标题和描述
                let title = this.stepsItems[i].title, desc = this.stepsItems[i].desc;
                if (title || desc) {
                    headerHTML += '<div class="steps-item-main">';
                    headerHTML += title ? '<div class="steps-item-main-title">' + title + '</div>' : '';
                    headerHTML += desc ? '<div class="steps-item-main-desc">' + desc + '</div>' : '';
                    headerHTML += '</div>';
                }
                headerHTML += '</div>';
            }
            $header.html(headerHTML);
            // 计算每一个条目的宽度
            let itemWidth = 100 / (this.stepsItems.length + 1);
            $('.steps .steps-header>.steps-item').css('width', itemWidth + '%');
            $header.css('padding-left', itemWidth + '%');
            $content.height(($content.height() - 64) + 'px');
        }

        // 添加规则列表
        addRule(field) {
            field = field || {};
            let id = getIndex(field['id'], this.dom.find('[lay-filter=steps-list]')), // 索引
                dom = $(`<div class="layui-tab-item layui-show"><div class="layui-collapse" lay-accordion><div class="layui-colla-item"><h2 class="layui-colla-title">列表采集</h2><div class="layui-colla-content layui-show"><fieldset class="layui-elem-field layui-field-title"><legend>获取</legend></fieldset><div class="layui-form-item"><div class="layui-inline"><label class="layui-form-label-col">指定范围:</label></div><div class="layui-inline"><div class="layui-input-inline"><input type="text" name="list.limit." value="" class="layui-input"                                    placeholder="&lt;html[^&gt;]*&gt;([\\\\s\\\\S]*?)&lt;/html&gt;"></div><div class="layui-form-mid layui-word-aux">指定获取范围 为空则不指定 &lt;html[^&gt;]*&gt;([\\\\s\\\\S]*?)&lt;/html&gt;</div></div></div><div class="layui-form-item"><div class="parse-method"><div class="layui-inline"><label class="layui-form-label-col" lay-tips="一行一条规则，逐行匹配到则终止匹配">DOM解析:</label></div><div class="layui-inline"><textarea class="layui-textarea" name="list.dom." placeholder="list>h3>a&#13;list-img>h3>a"></textarea></div><div class="layui-inline" lay-tips="选择dom取值方法"><div class="layui-input-inline" style="width: 80px"><select name="list.method." lay-filter="method"><option value="attr">Attr</option><option value="text">Text</option><option value="html">Html</option></select></div></div><div class="layui-inline" lay-tips="属性名称 默认为 href"><input type="text" name="list.attr_name." value="href" class="layui-input"></div><div class="layui-inline"><button class="layui-btn layui-btn-radius" data-event="regMethod">转为正则解析</button></div></div><div class="parse-method" style="display:none;"><div class="layui-inline"><label class="layui-form-label-col">正则解析:</label></div><div class="layui-inline" style="width: 55%" lay-tips="一行一条规则，逐行匹配到则终止匹配"><textarea class="layui-textarea" name="list.reg." placeholder="href=(https://.*?)&#13;href(.*?)"></textarea></div><div class="layui-inline"><button class="layui-btn layui-btn-radius" data-event="domMethod">转为DOM解析</button></div></div></div><fieldset class="layui-elem-field layui-field-title"><legend>正则过滤</legend></fieldset><div class="layui-form-item"><label class="layui-form-label"                           lay-tips="例如:只匹配以/index.html结尾的数据 /index\\\\.html$">正则匹配:</label><div class="layui-input-block"><input type="text" name="list.match." value="" class="layui-input"                                placeholder="/\\\\d+\\\\.html$"></div></div><fieldset class="layui-elem-field layui-field-title"><legend>字符串、正则或DOM替换</legend></fieldset><div class="layui-form-item"><div class="layui-inline" style="width: 38%" lay-tips="原词 一行一条"><textarea name="list.olds." class="layui-textarea" placeholder="ivf&#13;南方ivf"></textarea></div><div class="layui-inline"><label class="layui-form-label-col" style="color: #009688;"><i class="layui-icon layui-icon-spread-left"></i></label></div><div class="layui-inline" style="width: 38%" lay-tips="替换成 对应原词一行一条"><textarea name="list.news." class="layui-textarea" placeholder="试管婴儿&#13;南方39"></textarea></div><div class="layui-inline" style="width: 12%"><select name="list.type." class="layui-select"><option value="0" selected>字符串</option><option value="1">正则</option><option value="2">DOM</option></select></div></div></div></div><div class="layui-colla-item"><h2 class="layui-colla-title">分页采集</h2><div class="layui-colla-content"><div class="layui-form-item"><label class="layui-form-label">开启分页:</label><div class="layui-input-inline"><input type="checkbox" name="list.page.enabled." lay-skin="switch"                               lay-text="开启|关闭"></div></div><fieldset class="layui-elem-field layui-field-title"><legend>获取</legend></fieldset><div class="layui-form-item"><div class="layui-inline"><label class="layui-form-label-col">指定范围:</label></div><div class="layui-inline"><div class="layui-input-inline"><input type="text" name="list.page.limit." value=""                                   class="layui-input"                                   placeholder="&lt;html[^&gt;]*&gt;([\\\\s\\\\S]*?)&lt;/html&gt;"></div><div class="layui-form-mid layui-word-aux">指定获取范围 为空则不指定 &lt;html[^&gt;]*&gt;([\\\\s\\\\S]*?)&lt;/html&gt;</div></div></div><div class="layui-form-item"><div class="parse-method"><div class="layui-inline"><label class="layui-form-label-col">DOM解析:</label></div><div class="layui-inline" lay-tips="一行一条规则，逐行匹配到则终止匹配"><textarea class="layui-textarea" name="list.page.dom." placeholder="a&#13;title"></textarea></div><div class="layui-inline" lay-tips="选择dom取值方法"><div class="layui-input-inline" style="width: 80px"><select name="list.page.method." lay-filter="method"><option value="attr">Attr</option><option value="text">Text</option><option value="html">Html</option></select></div></div><div class="layui-inline" lay-tips="属性名称 默认为 href"><input type="text" name="list.page.attr_name." value="href" class="layui-input"></div><div class="layui-inline"><button class="layui-btn layui-btn-radius" data-event="regMethod">转为正则解析</button></div></div><div class="parse-method" style="display:none;"><div class="layui-inline"><label class="layui-form-label-col">正则解析:</label></div><div class="layui-inline" style="width: 55%" lay-tips="一行一条规则，逐行匹配到则终止匹配"><textarea class="layui-textarea" name="list.page.reg." placeholder="href=&#34;(.*?)&#34;"></textarea></div><div class="layui-inline"><button class="layui-btn layui-btn-radius" data-event="domMethod">转为DOM解析</button></div></div></div><fieldset class="layui-elem-field layui-field-title"><legend>正则过滤</legend></fieldset><div class="layui-form-item"><label class="layui-form-label"                           lay-tips="例如:只匹配以/index.html结尾的数据 /index\\\\.html$">正则匹配:</label><div class="layui-input-block"><input type="text" name="list.page.match." value="" class="layui-input"                               placeholder="/\\\\d+\\\\.html$"></div></div><fieldset class="layui-elem-field layui-field-title"><legend>字符串、正则或DOM替换</legend></fieldset><div class="layui-form-item"><div class="layui-inline" style="width: 38%" lay-tips="原词 一行一条"><textarea name="list.page.olds." class="layui-textarea" placeholder="ivf&#13;代孕"></textarea></div><div class="layui-inline"><label class="layui-form-label-col" style="color: #009688;"><i class="layui-icon layui-icon-spread-left"></i></label></div><div class="layui-inline" style="width: 38%" lay-tips="替换成 对应原词一行一条"><textarea name="list.page.news." class="layui-textarea" placeholder="试管婴儿&#13;助孕"></textarea></div><div class="layui-inline" style="width: 12%"><select name="list.page.type." class="layui-select"><option value="0" selected>字符串</option><option value="1">正则</option><option value="2">DOM</option></select></div></div></div></div></div></div>`);
            // 添加头部
            this.dom.find('[lay-filter="steps-list"]>.layui-tab-title>li').removeClass('layui-this');
            this.dom.find('[lay-filter="steps-list"]>.layui-tab-title').append('<li lay-id="' + id + '" class="layui-this">Rule-' + (id + 1) + '</li>');
            // 全部name 加上序号
            dom.find('[name]').each(function () {
                $(this).attr('name', $(this).attr('name') + id);
            });
            if (field && typeof field.dom === 'string') {
                field = $.extend({limit: '', reg: '', method: 'attr', attr_name: '', match: '', type: 0}, field);
                field.olds = field.olds || [];
                field.news = field.news || [];
                dom.find('[name^="list.limit."]').val(field.limit);
                if (field.reg.length > 0) {
                    dom.find('[name^="list.reg."]').val(field.reg).closest('.parse-method').show();
                    dom.find('[name^="list.dom."]').closest('.parse-method').hide();
                } else {
                    dom.find('[name^="list.dom."]').val(field.dom).closest('.parse-method').show();
                    dom.find('[name^="list.reg."]').closest('.parse-method').hide();
                }
                dom.find('[name^="list.method."]>option[value=' + field.method + ']').prop('selected', true);
                dom.find('[name^="list.attr_name."]').val(field.attr_name);
                dom.find('[name^="list.match."]').val(field.match);
                dom.find('[name^="list.olds."]').val(field.olds.join('\n'));
                dom.find('[name^="list.news."]').val(field.news.join('\n'));
                dom.find('[name^="list.type."]>option[value=' + field.type + ']').prop('selected', true);
                if (field.page) {
                    field.page = $.extend({
                        enabled: false, limit: '', method: '', attr_name: '', match: '', type: 0, reg: '', dom: ''
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
                        dom.find('[name^="list.page.reg."]').val(field.page.reg).closest('.parse-method').show();
                        dom.find('[name^="list.page.dom."]').closest('.parse-method').hide();
                    } else {
                        dom.find('[name^="list.page.dom."]').val(field.page.dom).closest('.parse-method').show();
                        dom.find('[name^="list.page.reg."]').closest('.parse-method').hide();
                    }
                }
            }
            this.dom.find('[lay-filter="steps-list"]>.layui-tab-content>.layui-tab-item').removeClass('layui-show');
            this.dom.find('[lay-filter="steps-list"]>.layui-tab-content').append(dom);
        };

        // 渲染列表
        rules(rules) {
            let othis = this;
            if (!Array.isArray(rules)) rules = [];
            if (rules.length === 0) {
                rules.push({});
            }
            $.each(rules, function (i, v) {
                othis.addRule(v);
            });
            layui.element.render();
            layui.form.render();
            this.dom.find('[lay-filter="steps-list"]>ul>li').first().click();
        }

        // 添加详情
        addDetail = function (field) {
            if (Object.prototype.toString.call(field) !== '[object Object]' || typeof field.name !== 'string' || field.name.length === 0) {
                return false;
            }
            if (typeof field.alias !== 'string' || field.alias.length === 0) {
                field.alias = field.name.substring(0, 1).toUpperCase() + field.name.substring(1);
            }
            let id = getIndex(field['id'], this.dom.find('[lay-filter=steps-detail]')), // 索引
                dom = $(`<div class="layui-tab-item layui-show"><div class="layui-form-item"><div class="layui-inline"><label class="layui-form-label-col">指定范围:</label></div><div class="layui-inline"><div class="layui-input-inline"><input type="text" name="detail.limit." value="" class="layui-input" placeholder="&lt;html[^&gt;]*&gt;([\\\\s\\\\S]*?)&lt;/html&gt;"></div><div class="layui-form-mid layui-word-aux">指定获取范围 为空则不指定 &lt;html[^&gt;]*&gt;([\\\\s\\\\S]*?)&lt;/html&gt;</div></div></div><div class="layui-form-item"><div class="parse-method"><div class="layui-inline"><label class="layui-form-label-col" lay-tips="一行一条规则，逐行匹配到则终止匹配">DOM解析:</label></div><div class="layui-inline"><textarea class="layui-textarea" name="detail.dom." placeholder="a&#13;h3 a"></textarea></div><div class="layui-inline" lay-tips="选择dom取值方法"><div class="layui-input-inline" style="width: 80px"><select name="detail.method." lay-filter="method"><option value="text">Text</option><option value="attr">Attr</option><option value="html">Html</option></select></div></div><div class="layui-inline" lay-tips="属性名称 默认为 href"><input type="hidden" name="detail.attr_name." value="href" class="layui-input"></div><div class="layui-inline"><button class="layui-btn layui-btn-radius" data-event="regMethod">转为正则解析</button></div></div><div class="parse-method" style="display:none;"><div class="layui-inline"><label class="layui-form-label-col" lay-tips="一行一条规则，逐行匹配到则终止匹配">正则解析:</label></div><div class="layui-inline" style="width: 55%"><textarea class="layui-textarea" name="detail.reg." placeholder="href=&#34;(.*?)&#34;&#13;ivf"></textarea></div><div class="layui-inline"><button class="layui-btn layui-btn-radius" data-event="domMethod">转为DOM解析</button></div></div></div><fieldset class="layui-elem-field layui-field-title"><legend>正则过滤</legend></fieldset><div class="layui-form-item"><label class="layui-form-label" lay-tips="例如:只匹配以/index.html结尾的数据 /index\\\\.html$">正则匹配:</label><div class="layui-input-block"><input type="text" name="detail.match." value="" class="layui-input" placeholder="/\\\\d+\\\\.html$"></div></div><fieldset class="layui-elem-field layui-field-title"><legend>DOM替换</legend></fieldset><div class="layui-form-item"><div class="layui-inline" style="width: 45%" lay-tips="原词 一行一条"><textarea name="detail.filter_dom.olds." class="layui-textarea" placeholder="body>a&#13;h3>a"></textarea></div><div class="layui-inline"><label class="layui-form-label-col" style="color: #009688;"><i class="layui-icon layui-icon-spread-left"></i></label></div><div class="layui-inline" style="width: 45%" lay-tips="替换成 对应原词一行一条"><textarea name="detail.filter_dom.news." class="layui-textarea" placeholder="替换词1&#13;替换词2"></textarea></div></div><fieldset class="layui-elem-field layui-field-title"><legend>字符串、正则或DOM替换</legend></fieldset><div class="layui-form-item"><div class="layui-inline" style="width: 38%" lay-tips="原词 一行一条"><textarea name="detail.olds." class="layui-textarea" placeholder="原词1&#13;原词2"></textarea></div><div class="layui-inline"><label class="layui-form-label-col" style="color: #009688;"><i class="layui-icon layui-icon-spread-left"></i></label></div><div class="layui-inline" style="width: 38%" lay-tips="替换成 对应原词一行一条"><textarea name="detail.news." class="layui-textarea" placeholder="替换词1&#13;替换词2"></textarea></div><div class="layui-inline" style="width: 12%"><select name="detail.type." class="layui-select"><option value="0" selected>字符串</option><option value="1">正则</option><option value="2">DOM</option></select></div></div><div class="layui-form-item"><div class="layui-inline layui-hide"><input type="checkbox" name="detail.raw." title="原始"></div></div></div>`);
            // 删除头部显示类
            this.dom.find('[lay-filter="steps-detail"]>.layui-tab-title>li').removeClass('layui-this');
            // 添加头部
            this.dom.find('[lay-filter="steps-detail"]>.layui-tab-title').append('<li lay-id="' + id + '" class="layui-this">' + field.alias + '</li>');

            // 全部name 加上序号
            dom.find('[name]').each(function () {
                $(this).attr('name', $(this).attr('name') + id);
            });
            if (typeof field.dom === 'string') {
                field = $.extend({
                    limit: '', method: '', attr_name: '', match: '', type: 0, raw: false, reg: '', filter_dom: null
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
                        .closest('.parse-method').show();
                    dom.find('[name^="detail.dom."]')
                        .closest('.parse-method').hide();
                } else {
                    dom.find('[name^="detail.dom."]').val(field.dom)
                        .closest('.parse-method').show();
                    dom.find('[name^="detail.reg."]')
                        .closest('.parse-method').hide();
                    if (field.method === 'html') {
                        dom.find('[name^="detail.raw."]').parent().show();
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
                        dom.find('[name^="detail.raw."]').parent().show();
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
            this.dom.find('[lay-filter="steps-detail"]>.layui-tab-content>.layui-tab-item').removeClass('layui-show');
            this.dom.find('[lay-filter="steps-detail"]>.layui-tab-content').append(dom);
        };

        // 渲染列表
        details(details) {
            let othis = this;
            // 详情列表
            details = Array.isArray(details) ? details : [
                {"name": 'title', "alias": '标题'},
                {"name": 'content', "alias": '内容'},
                {"name": 'description', "alias": '描述'},
                {"name": 'keywords', "alias": '关键词'},
                {"name": 'tags', "alias": 'Tags'},
            ];
            if (details) {
                $.each(details, function (i, v) {
                    v.id = i;
                    othis.addDetail.call(othis, v);
                });
                layui.element.render();
                form.render();
                othis.dom.find('[lay-filter="steps-detail"]>ul>li').first().click();
            }
        }

        // 绑定栏目
        bindClass(siteId, classId) {
            siteId = parseInt(siteId) || 0;
            classId = parseInt(classId) || 0;
            let othis = this;
            if (!siteId) {
                othis.dom.find('select[name=class_id]').html('<select name="class_id" lay-search><option value="">搜索...</option></select>');
                form.render('select');
                return false
            }
            if (typeof this.classes[siteId] === 'string' && this.classes[siteId].length > 10) {
                othis.dom.find('[lay-filter=class_id]').html(this.classes[siteId]);
                form.render();
                return false;
            }
            $.get('/site/class', {id: siteId, class_id: classId}, function (res) {
                if (res.code === 0) {
                    othis.classes[siteId] = res.data;
                    othis.dom.find('[lay-filter=class_id]').html(res.data);
                    form.render();
                } else {
                    layer.alert(res.msg, {icon: 2});
                }
            });
        };

        // 全部监听事件
        onAll() {
            let othis = this,
                active = {
                    addRule: function () {
                        othis.addRule();
                        layui.element.render();
                        layui.form.render();
                    },
                    addDetail: function () {
                        let names = [], aliases = [];
                        othis.dom.find('[lay-filter="steps-detail"] [name^="detail.name."]').each(function () {
                            names.push($(this).val());
                        });
                        othis.dom.find('[lay-filter="steps-detail"] [name^="detail.alias."]').each(function () {
                            aliases.push($(this).val());
                        });
                        layer.prompt({
                            formType: 0, value: 'author', title: '输入标识 由字母下划线或数字组成 字母开头'
                        }, function (name, index) {
                            if (!/^[a-zA-Z]\w+/.test(name)) {
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
                                othis.addDetail({name: name, alias: alias});
                                layer.close(index);
                                layui.element.render();
                                form.render();
                            });
                            layer.close(index);
                        });
                    },
                    domMethod: function () {
                        $(this).closest('div.parse-method').hide().siblings().show();
                    },
                    regMethod: function () {
                        $(this).closest('div.parse-method').hide().siblings().show();
                    },
                    testList: function () {
                        othis.dom.find('[lay-filter=testList]').click();
                    },
                    sourceCode: function () {
                        othis.dom.find('[lay-filter=sourceCode]').click();
                    },
                    testDetail: function () {
                        othis.dom.find('[lay-filter=testDetail]').click();
                    },
                    testListLog: function () {
                        main.ws.log('spider_test_list.0');
                    },
                    testDetailLog: function () {
                        main.ws.log('spider_test_detail.0');
                    },
                };
            // 监听点击转到
            this.dom.off('click').on('click', '.steps-item-head', function (e) {
                othis.position = parseInt($(this).parent().data('index'));
                othis.showThis();
                e.stopPropagation();
            });
            // 监听自定义事件
            this.dom.on('click', '[data-event]', function (e) {
                let event = $(this).data('event');
                active[event] && active[event].call(this);
                e.stopPropagation();
            });

            /* jquery 解析方法 attr text html*/
            layui.form.on('select(method)', function (obj) {
                switch (obj.value) {
                    case 'attr':
                        obj.othis.closest('.parse-method').find('input[name*=".attr_name."]').attr('type', 'text');
                        obj.othis.closest('.layui-tab-item').find('input[name*=".raw."]').parent().hide();
                        break;
                    case 'html':
                        obj.othis.closest('.layui-tab-item').find('input[name*=".raw."]').parent().show();
                        obj.othis.closest('.parse-method').find('input[name*=".attr_name."]').attr('type', 'hidden');
                        break;
                    default:
                        obj.othis.closest('.layui-tab-item').find('input[name*=".raw."]').parent().hide();
                        obj.othis.closest('.parse-method').find('input[name*=".attr_name."]').attr('type', 'hidden');
                }
            });

            //监听选择网站ID
            form.on('select(site_id)', function (obj) {
                othis.bindClass(obj.value);
            });

            // 监控测试列表
            form.on('submit(testList)', function (obj) {
                main.request({
                    url: '/spider/test/list',
                    data: obj.field,
                    done: function () {
                        main.ws.log("spider_test_list.0");
                        return false;
                    }
                }, $(obj.elem).closest(".layui-form"));
            });

            // 监控测试详情
            form.on('submit(testDetail)', function (obj) {
                if (othis.seeds.length === 0) {
                    othis.seeds = obj.field.seeds.split("\n")
                }
                layer.prompt({
                    formType: 0,
                    value: othis.seeds[0],
                    title: '请输入完整的URL地址 http 开头'
                }, function (value, index) {
                    obj.field.detail_url = value;
                    main.request({
                        url: '/spider/test/detail',
                        data: obj.field,
                        index: index,
                        done: function (res) {
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

            // 监控测试源码
            form.on('submit(sourceCode)', function (obj) {
                if (othis.seeds.length === 0) {
                    othis.seeds = obj.field.seeds.split("\n")
                }
                layer.prompt({
                    formType: 0, value: othis.seeds[0], title: '请输入完整的URL地址 http 开头'
                }, function (value, index) {
                    obj.field.detail_url = value;
                    main.request({
                        url: '/spider/test/source', data: obj.field, index: index, done: function (res) {
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

            // 监听提交按钮
            form.on('submit(stepsSubmit)', function (obj) {
                main.request({
                    index: othis.layerIndex,
                    url: othis.url,
                    data: obj.field,
                    done: function () {
                        layui.table.reload('table-list', {page: {curr: 1}});
                    }
                }, $(obj.elem.closest('.layui-form')));
            });
        }

        // 总渲染
        init(dom, config) {
            if (this.dom) return false;
            this.dom = dom;
            config = config || {};
            /* 给内容区 加下一步标识*/
            this.dom.find('.steps-content>div').each(function (i) {
                $(this).attr('data-index', i);
            });
            // 渲染头部(进度条)
            this.header();
            // 翻译引擎
            layui.trans({
                engines: config.engines || [], // 翻译引擎列表
                items: config.trans || [], // 已经存在的翻译列表
            });
            // 渲染列表
            this.rules(config.rules);
            // 详情列表
            this.details(config.details);
            // 全部监听事件
            this.onAll();
            let othis = this;
            // 显示当前块
            this.showThis();
            /* 验证爬虫名称和种子 */
            form.verify({
                name: function (val) {
                    if (!new RegExp(/^.{2,}$/).test(val)) {
                        othis.position = 0;
                        othis.showThis();
                        return '爬虫名称必须2个字符以上';
                    }
                },
                seeds: function (val) {
                    if (!new RegExp(/^\s*https?:\/\//i).test(val)) {
                        othis.position = 0;
                        othis.showThis();
                        return '必须以http://或者https://开头';
                    }
                },
            });
            layui.main.cron(this.dom.find('[name=spec]'));
            // 如果下一个链接正则有值则点击
            if (this.dom.find('input[name=next_reg]').val()) {
                this.dom.find('[data-event=regMethod]').click();
            }
        };

        // 弹窗
        open(data) {
            let othis = this, loading = main.loading();
            $.get(this.url, data, function (html) {
                loading.close();
                layer.open({
                    type: 1,
                    title: false,
                    scrollbar: false,
                    btnAlign: 'c',
                    shade: 0.8,
                    btn: ['上一步', '下一步', '提交', '取消'],
                    skin: 'steps',
                    content: html,
                    area: ['95%', '95%'],
                    success: function (dom, index) {
                        othis.init(dom, JSON.parse(dom.find('#config').val() || '{}'));
                        othis.layerIndex = index;
                    },
                    btn1: function () {
                        --othis.position;
                        othis.showThis();
                        return false;
                    },
                    btn2: function () {
                        ++othis.position;
                        othis.showThis();
                        return false;
                    },
                    btn3: function () {
                        othis.dom.find('[lay-filter=stepsSubmit]').click();
                        return false;
                    },
                })
            });
        }
    }


    // 导出接口
    exports('steps', function (options) {
        options = options || {};
        (new Steps(options)).open(options.data || {});
    });
});