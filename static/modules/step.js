layui.define(['form', 'element'], function (exports) {
    /*判断是对象*/
    function defineObj(obj) {
        return Object.prototype.toString.call(obj) === '[object Object]' ? obj : {};
    }

    /*渲染进度条HTML*/
    function renderSpeed(opts) {
        let stepDiv = '<div class="lay-step">';
        for (let i = 0; i < opts.data.length; i++) {
            stepDiv += '<div class="step-item">';
            // 线
            if (i < (opts.data.length - 1)) {
                if (i < opts.position) {
                    stepDiv += '<div class="step-item-tail"><i class="step-item-tail-done"></i></div>';
                } else {
                    stepDiv += '<div class="step-item-tail"><i class=""></i></div>';
                }
            }
            // 数字
            let number = opts.data[i].number;
            if (!number) {
                number = i + 1;
            }
            if (i === opts.position) {
                stepDiv += '<div class="step-item-head step-item-head-active"><i class="layui-icon">' + number + '</i></div>';
            } else if (i < opts.position) {
                stepDiv += '<div class="step-item-head"><i class="layui-icon layui-icon-ok"></i></div>';
            } else {
                stepDiv += '<div class="step-item-head "><i class="layui-icon">' + number + '</i></div>';
            }
            // 标题和描述
            let title = opts.data[i].title,
                desc = opts.data[i].desc;
            if (title || desc) {
                stepDiv += '<div class="step-item-main">';
                if (title) {
                    stepDiv += '<div class="step-item-main-title">' + title + '</div>';
                }
                if (desc) {
                    stepDiv += '<div class="step-item-main-desc">' + desc + '</div>';
                }
                stepDiv += '</div>';
            }
            stepDiv += '</div>';
        }
        stepDiv += '</div>';
        $(opts.elem).html(stepDiv);
        // 计算每一个条目的宽度
        let bfb = 100 / opts.data.length;
        $('.step-item').css('width', bfb + '%');
        return false;
    }

    let $ = layui.jquery,
        form = layui.form,
        layer = layui.layer,
        element = layui.element,
        //默认选项
        options = {
            elem: '.step-header',
            titleW: '90%',
            data: [
                {title: '第一步'},
                {title: '第二步'},
                {title: '第三步'},
                {title: '第四步'},
            ],
            position: 0,
        },
        /*渲染上一步 下一步*/
        renderGoto = function (opts) {
            let next = opts.position + 1,
                pre = opts.position - 1,
                dataLen = opts.data.length,
                btn = '';
            if (dataLen < 1) {
                return false;
            }
            if (dataLen === 1) {
                btn = '<a data-step-submit="' + opts.position + '" style="background: #009688;color: #FFF">提交</a>';
            } else if (pre < 0) {
                btn = '<a data-step-next="' + next + '" style="background: #009688;color: #FFF">下一步</a>';
            } else if (next >= dataLen) {
                btn = '<a data-step-pre="' + pre + '">上一步</a><a data-step-submit="' + opts.position + '" style="background: #009688;color: #FFF">提交</a>';
            } else {
                btn = '<a data-step-pre="' + pre + '">上一步</a><a data-step-next="' + next + '" style="background: #009688;color: #FFF">下一步</a>';
            }
            $('div.layui-layer-btn').html(btn + '<a data-step-close="' + opts.position + '">取消</a>');
        },
        /*合并 选项*/
        mergeOptions = function (opts) {
            opts = $.extend(options, defineObj(opts));
            if (!opts.contentW) {
                opts.contentW = options.titleW;
            }
            if (opts.position < 0) {
                opts.position = 0;
            }
            if (opts.position >= opts.data.length) {
                opts.position = opts.data.length - 1;
            }
            return opts;
        },
        /*监测 事件*/
        onEvent = function () {
            //监控关闭
            $('a[data-step-close]').click(function () {
                let index = parseInt($('div.layui-layer-shade[times]').attr('times'));
                if (isNaN(index)) {
                    layer.closeAll(); //再执行关闭
                } else {
                    layer.close(index); //再执行关闭
                }
                window.location.reload();
                return false;
            });
            //监控上一步
            $('a[data-step-pre]').click(function () {
                step.goto({position: $(this).data("stepPre")});
            });
            //监控下一步
            $('a[data-step-next]').click(function () {
                $('.step-content:first').removeClass('layui-form');
                $('a[data-step=' + ($(this).data("stepNext") - 1) + ']').click();
            });
            //监控提交
            $('a[data-step-submit]').click(function () {
                $('.step-content:first').addClass('layui-form');
                $('[lay-filter=stepSubmit]').click();
            });
            //验证提交
            form.on('submit(stepNext)', function () {
                step.goto({position: $('a[data-step-next]').data("stepNext")});
            });
        },
        //显示可绑定翻译配置
        trans = {
            //显示允许的语言列表
            usable: function (opts) {
                opts.engine = opts.engine || $("select[name='trans.engine." + opts.id + "']").val();
                if (typeof opts.engine !== 'string' || opts.engine.length === 0) {
                    return false;
                }
                let source_name = "trans.source." + opts.id,
                    target_name = "trans.target." + opts.id,
                    cfg_name = "trans.cfg_id." + opts.id,
                    source_obj = $("select[name='" + source_name + "']"),
                    target_obj = $("select[name='" + target_name + "']"),
                    cfg_obj = $("select[name='" + cfg_name + "']");
                $.get('/trans/select', {
                    name: cfg_name,
                    engine: opts.engine,
                    selected: cfg_obj.val()
                }, function (res) {
                    if (res.code === 0) {
                        cfg_obj.replaceWith(res.data);
                        form.render();
                        return false;
                    }
                    layui.layer.alert(res.msg);
                });
                /*服务器获取*/
                $.get('/spider/usable', {
                    engine: opts.engine,
                    source_name: source_name,
                    target_name: target_name,
                    source_selected: source_obj.val(),
                    target_selected: target_obj.val()
                }, function (res) {
                    if (res.code === 0) {
                        source_obj.replaceWith(res.data.source);
                        target_obj.replaceWith(res.data.target);
                        form.render();
                        return false;
                    }
                    layui.layer.alert(res.msg);
                });
                return false;
            },
            // 获取新索引ID
            index: function () {
                let rs = $('#trans-items').html().match(/name="trans\.engine\.(\d+)"/g),
                    ids = [];
                $.each(rs, function (i, v) {
                    let ls = v.split('.'),
                        id = parseInt(ls.slice(ls.length - 1) || '');
                    if (!isNaN(id)) {
                        ids.push(id);
                    }
                });
                return ids.length > 0 ? Math.max.apply(null, ids) + 1 : 1;
            },
            //渲染
            render: function () {
                //渲染现有的
                $('select[name^="trans.engine."][lay-filter^="trans.engine"]').each(function () {
                    let othis = $(this),
                        selection = othis.attr('name'),
                        ls = selection.split('.'),
                        index = parseInt(ls.slice(ls.length - 1) || '');
                    if (!isNaN(index)) {
                        trans.usable({id: index, engine: othis.val()});
                        form.on('select(trans.engine.' + index + ')', function (obj) {
                            trans.usable({id: index, engine: obj.value});
                            return false;
                        });
                    }
                });
                //监控添加
                trans.add();
                //监控删除
                trans.del();
            },
            //添加
            add: function () {
                //监控添加按钮
                $('button[lay-event=add-trans]').click(function () {
                    let othis = $('#trans-items'),
                        index = trans.index(),
                        content = $('#trans-item').html().replace(/\{num\}/g, index);
                    othis.append(content);
                    let engine = $('select[name="trans.engine.' + index + '"]').val();
                    if (engine) {
                        trans.usable({id: index, engine: engine});
                        form.on('select(trans.engine.' + index + ')', function (obj) {
                            trans.usable({id: index, engine: obj.value});
                        });
                    } else {
                        element.render();
                        form.render();
                    }
                    trans.del();
                })
            },
            //删除
            del: function () {
                $('button[lay-event=del-trans]').click(function () {
                    let othis = $(this);
                    layer.confirm('确定删除该项吗?', {
                        btn: ['确定', '取消'] //按钮
                    }, function (index) {
                        othis.closest('div.layui-form-item').remove();
                        layer.close(index);
                    });
                });
            },
        },
        step = {
            render: function (opts) {
                layui.link('/static/style/step.css');
                //合并选项
                opts = mergeOptions(opts);
                //渲染头部
                renderSpeed(opts);
                $('.lay-step').css('width', opts.titleW);
                /*内容区域加上宽度*/
                $('.step-content').css('width', opts.contentW);
                //显示当前块
                $('.step-content>div').removeAttr('style').eq(opts.position).css({'display': 'block'});
                /*给内容区 加上 layui-form 类和下一步标识*/
                $('div.step-content>div').addClass('layui-form').each(function (i, o) {
                    $(this).children().eq(0).before('<a class="layui-hide" lay-submit lay-filter="stepNext" data-step="' + i + '"></a>');
                });
                $('div.step-content>div:first').before('<a class="layui-hide" lay-submit lay-filter="stepSubmit"></a>');
                //渲染 上下步
                renderGoto(opts);
                //监控事件
                onEvent();
                /*验证爬虫名称和种子*/
                form.verify({
                    name: [/^.{2,}/, '爬虫名称必须2个字符以上！'],
                    seeds: [/^\s*https?:\/\//i, '必须以http:// 或者 https:// 开头']
                });
                //渲染翻译
                step.trans.render();
            },
            goto: function (opts) {
                opts = mergeOptions(opts)
                //显示当前块
                $('.step-content>div').removeAttr('style').eq(opts.position).css({'display': 'block'});
                //渲染头部
                renderSpeed(opts);
                //渲染 上下步
                renderGoto(opts);
                //监控事件
                onEvent();
            },
            //渲染翻译
            trans: trans,
        };
    exports('step', step);
});
