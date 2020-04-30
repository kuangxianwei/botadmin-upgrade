layui.define(['form', 'element'], function (exports) {
    var $ = layui.jquery,
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
        /*渲染进度条HTML*/
        renderHeader = function () {
            var stepDiv = '<div class="lay-step">';
            for (var i = 0; i < options.data.length; i++) {
                stepDiv += '<div class="step-item">';
                // 线
                if (i < (options.data.length - 1)) {
                    if (i < options.position) {
                        stepDiv += '<div class="step-item-tail"><i class="step-item-tail-done"></i></div>';
                    } else {
                        stepDiv += '<div class="step-item-tail"><i class=""></i></div>';
                    }
                }
                // 数字
                var number = options.data[i].number;
                if (!number) {
                    number = i + 1;
                }
                if (i == options.position) {
                    stepDiv += '<div class="step-item-head step-item-head-active"><i class="layui-icon">' + number + '</i></div>';
                } else if (i < options.position) {
                    stepDiv += '<div class="step-item-head"><i class="layui-icon layui-icon-ok"></i></div>';
                } else {
                    stepDiv += '<div class="step-item-head "><i class="layui-icon">' + number + '</i></div>';
                }
                // 标题和描述
                var title = options.data[i].title;
                var desc = options.data[i].desc;
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
            $(options.elem).html(stepDiv);
            // 计算每一个条目的宽度
            var bfb = 100 / options.data.length;
            $('.step-item').css('width', bfb + '%');
        },
        /*渲染上一步 下一步*/
        renderGoto = function () {
            var next = options.position + 1,
                pre = options.position - 1,
                dataLen = options.data.length,
                btn = '';
            if (dataLen < 1) {
                return false;
            }
            if (dataLen == 1) {
                btn = '<a data-step-submit="' + options.position + '" style="background: #009688;color: #FFF">提交</a>';
            } else if (pre < 0) {
                btn = '<a data-step-next="' + next + '" style="background: #009688;color: #FFF">下一步</a>';
            } else if (next >= dataLen) {
                btn = '<a data-step-pre="' + pre + '">上一步</a><a data-step-submit="' + options.position + '" style="background: #009688;color: #FFF">提交</a>';
            } else {
                btn = '<a data-step-pre="' + pre + '">上一步</a><a data-step-next="' + next + '" style="background: #009688;color: #FFF">下一步</a>';
            }
            $('div.layui-layer-btn').html(btn + '<a data-step-close="' + options.position + '">取消</a>');
        },
        /*合并 选项*/
        mergeOptions = function (opts) {
            options = $.extend(options, opts || {});
            if (!options.contentW) {
                options.contentW = options.titleW;
            }
            if (options.position < 0) {
                options.position = 0;
            }
            if (options.position >= options.data.length) {
                options.position = options.data.length - 1;
            }
        },
        /*监测 事件*/
        onEvent = function (opts) {
            mergeOptions(opts);
            //监控关闭
            $('a[data-step-close]').click(function () {
                var index = parseInt($('div.layui-layer-shade[times]').attr('times'));
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
        /*显示select html*/
        displaySelectHtml = function (opts) {
            var opts = opts || {}, sourceHtml = '', targetHtml = '';
            if (opts.data.length == 0) {
                return false;
            }
            if (!opts.id) {
                opts.id = 0
            }
            var source = $('select[name="trans.source.' + opts.id + '"]').val(),
                target = $('select[name="trans.target.' + opts.id + '"]').val();
            opts = $.extend({
                id: 0,
                source: 'auto',
                target: 'auto',
                data: {},
            }, opts);
            if (typeof source === 'string' && source.length > 0) {
                opts.source = source;
            }
            if (typeof target === 'string' && target.length > 0) {
                opts.target = target;
            }
            $.each(opts.data, function (k, v) {
                if (k == opts.source) {
                    sourceHtml += '<option value="' + k + '" selected>' + v + '</option>';
                } else {
                    sourceHtml += '<option value="' + k + '">' + v + '</option>';
                }
                if (k == opts.target) {
                    targetHtml += '<option value="' + k + '" selected>' + v + '</option>';
                } else {
                    targetHtml += '<option value="' + k + '">' + v + '</option>';
                }
            });
            $("select[name='trans.source." + opts.id + "']").html(sourceHtml);
            $("select[name='trans.target." + opts.id + "']").html(targetHtml);
            form.render();
            return false;
        },
        //显示允许的
        transUsable = function (options) {
            if (typeof options.engine === 'undefined') {
                options.engine = $("select[name='trans.engine." + options.id + "']").val();
            }
            if (typeof options.engine !== 'string') {
                return false;
            }
            var datas = layui.sessionData('transUsable')[options.engine];
            if (Object.prototype.toString.call(datas) === '[object Object]') {
                return displaySelectHtml({id: options.id, data: datas})
            }
            $.get('/spider/usable', {engine: options.engine}, function (res) {
                if (res.code === 0) {
                    layui.sessionData('transUsable', {key: options.engine, value: res.data});
                    return displaySelectHtml({id: options.id, data: res.data});
                }
                layui.layer.alert(res.msg);
            });
            return false;
        },
        trans = {
            render: function () {
                //渲染现有的
                $('select[name^="trans.engine."][lay-filter^="trans.engine"]').each(function () {
                    var othis = $(this),
                        selection = othis.attr('name'),
                        ls = selection.split('.'),
                        index = parseInt(ls.slice(ls.length - 1));
                    if (!isNaN(index)) {
                        transUsable({id: index, engine: othis.val()});
                        form.on('select(trans.engine.' + index + ')', function (obj) {
                            transUsable({id: index, engine: obj.value});
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
                //监控添加
                $('button[lay-event=add-trans]').click(function () {
                    var othis = $('#trans-items'),
                        rs = othis.html().match(/name="trans\.engine\.(\d+)"/g),
                        index = 1;
                    if (rs) {
                        var ids = new Array();
                        $.each(rs, function (i, v) {
                            var ls = v.split('.'),
                                id = parseInt(ls.slice(ls.length - 1));
                            if (!isNaN(id)) {
                                ids.push(id);
                            }
                        });
                        if (ids.length > 0) {
                            index = Math.max.apply(null, ids) + 1;
                        }
                    }
                    var content = $('#trans-item').html().replace(/\{num\}/g, index);
                    othis.append(content);
                    var engine = $('select[name="trans.engine.' + index + '"]').val();
                    if (engine) {
                        transUsable({id: index, engine: engine});
                        form.on('select(trans.engine.' + index + ')', function (obj) {
                            transUsable({id: index, engine: obj.value});
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
                    var othis = $(this);
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
                mergeOptions(opts);
                //渲染头部
                renderHeader();
                $('.lay-step').css('width', options.titleW);
                /*内容区域加上宽度*/
                $('.step-content').css('width', options.contentW);
                //显示当前块
                $('.step-content>div').removeAttr('style').eq(options.position).css({'display': 'block'});
                /*给内容区 加上 layui-form 类和下一步标识*/
                $('div.step-content>div').addClass('layui-form').each(function (i, o) {
                    $(this).children().eq(0).before('<a class="layui-hide" lay-submit lay-filter="stepNext" data-step="' + i + '"></a>');
                });
                $('div.step-content>div:first').before('<a class="layui-hide" lay-submit lay-filter="stepSubmit"></a>');
                //渲染 上下步
                renderGoto();
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
                mergeOptions(opts)
                //显示当前块
                $('.step-content>div').removeAttr('style').eq(options.position).css({'display': 'block'});
                //渲染头部
                renderHeader();
                //渲染 上下步
                renderGoto();
                //监控事件
                onEvent();
            },
            //渲染翻译
            trans: trans,
        };
    exports('step', step);
});
