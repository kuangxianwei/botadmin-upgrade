/*导出基本操作*/
layui.define(['form', 'slider', 'table', 'layer'], function (exports) {
    var $ = layui.jquery,
        layer = layui.layer,
        form = layui.form,
        table = layui.table,
        slider = layui.slider,
        uuid = function () {
            var len = 32,//32长度
                radix = 16,//16进制
                chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'.split(''),
                uuid = [], i,
                radix = radix || chars.length;
            if (len) {
                for (i = 0; i < len; i++) uuid[i] = chars[0 | Math.random() * radix];
            } else {
                var r;
                uuid[8] = uuid[13] = uuid[18] = uuid[23] = '-';
                uuid[14] = '4';
                for (i = 0; i < 36; i++) {
                    if (!uuid[i]) {
                        r = 0 | Math.random() * 16;
                        uuid[i] = chars[(i === 19) ? (r & 0x3) | 0x8 : r];
                    }
                }
            }
            return uuid.join('');
        },
        request = function (options) {
            options = options || {};
            if (typeof options.url !== 'string') {
                options.url = $('meta[name=current_uri]').attr('content');
            }
            options = $.extend({
                type: 'POST',
                dataType: 'json',
            }, options);
            // 加载中...
            var loading = layer.load(1, {shade: [0.7, '#000', true]}),
                isPost = options.type.toUpperCase() === 'POST';
            if (isPost) {
                options.headers = $.extend({'X-CSRF-Token': $('meta[name=csrf_token]').attr('content')}, options.headers || {});
            }
            var request = $.ajax(options);
            request.done(function (res) {
                res.msg = '<textarea class="layui-textarea" style="height:100%;">' + res.msg + '</textarea>';
                switch (res.code) {
                    case 0:
                        if ('index' in options) {
                            layer.close(options.index);
                        }
                        if (typeof options.ending === 'string' && options.ending !== '-') {
                            table.reload(options.ending, {page: {curr: 1}});
                        } else if (typeof options.ending === 'function') {
                            options.ending(res);
                        }
                        if (typeof options.tips === 'function') {
                            options.tips(res);
                        } else {
                            layer.msg(res.msg, {
                                icon: 1,
                                time: 2000,
                                shade: [0.6, '#000', true]
                            });
                        }
                        break;
                    case 1001:
                    case 403:
                        if (isPost) {
                            location.replace('/auth/login?next=' + $('meta[name=current_uri]').attr('content'));
                        } else {
                            location.href = '/auth/login?next=' + $('meta[name=current_uri]').attr('content');
                        }
                        break;
                    default:
                        if (typeof options.error === 'function') {
                            options.error(res);
                        }
                        layer.alert(res.msg, {
                            skin: 'layui-layer-admin',
                            shadeClose: true,
                            icon: 2,
                            btn: '',
                            closeBtn: false,
                            anim: 6,
                            success: function (o, index) {
                                var elemClose = $('<i class="layui-icon" close>&#x1006;</i>');
                                o.append(elemClose);
                                elemClose.on('click', function () {
                                    layer.close(index);
                                });
                            }
                        });
                }
            });
            request.fail(function (obj) {
                var msg = 'Fail: statusCode: ' + obj.status;
                if (obj.status === 403) {
                    msg = '登录超时或权限不够 statusCode: ' + obj.status;
                }
                layer.alert(msg, {
                    skin: 'layui-layer-admin',
                    shadeClose: true,
                    icon: 2,
                    btn: '',
                    closeBtn: false,
                    anim: 6,
                    success: function (o, index) {
                        var elemClose = $('<i class="layui-icon" close>&#x1006;</i>');
                        o.append(elemClose);
                        elemClose.on('click', function () {
                            layer.close(index);
                        });
                    }
                });
            });
            request.always(function () {
                layer.close(loading);
            });
        };
    exports('main', {
        getParam: function (key, url) {
            if (typeof key !== 'string') {
                return '';
            }
            if (typeof url !== 'string') {
                url = window.location.href;
            }
            var index = url.indexOf('?');
            if (index === -1) {
                return '';
            }
            var params = url.slice(index + 1).split('&');
            for (var i = 0; i < params.length; i++) {
                var param = params[i].split("=");
                if (param[0] === key) {
                    return param[1];
                }
            }
            return '';
        },
        uuid: uuid,
        req: request,
        popup: function (options) {
            options = options || {};
            var submit = options.submit || uuid(),
                url = options.url,
                ending = options.ending,
                base = {
                    type: 1,
                    shadeClose: true,
                    scrollbar: false,
                    btnAlign: 'c',
                    shade: 0.8,
                    fixed: false,
                    maxmin: true,
                    btn: ['提交', '取消'],
                    area: ['95%', '95%'],
                    zIndex: 200000,
                    yes: function (index, dom) {
                        if (typeof options.submit === "undefined") {
                            dom.find('.layui-form button[lay-submit]').attr('lay-filter', submit).click();
                        } else {
                            dom.find('.layui-form button[lay-submit]button[lay-filter=' + submit + ']').click();
                        }
                    },
                    success: function (dom, index) {
                        form.on('submit(' + submit + ')', function (obj) {
                            request({
                                url: url || obj.field.url,
                                data: obj.field,
                                index: index,
                                ending: ending,
                            });
                            return false;
                        });
                    }
                };
            delete options.ending;
            delete options.submit;
            delete options.url;
            delete options.ending;
            layer.open($.extend(base, options));
            form.render();
        },
        slider: function (options) {
            options = options || {};
            var pub_attr_deg = options.pub_attr_deg || 3,
                link_deg = options.link_deg || 3,
                out_link_deg = options.out_link_deg || 0,
                title_tag_deg = options.title_tag_deg || 3;
            //文章随机插入属性阈值
            slider.render({
                elem: '#pub_attr_deg',
                value: pub_attr_deg,
                min: 0,
                max: 10,
                setTips: function (value) {
                    $('input[name=pub_attr_deg]').val(value);
                    return value;
                }
            });
            //内链阈值
            slider.render({
                elem: '#link_deg',
                value: link_deg,
                min: 0,
                max: 10,
                setTips: function (value) {
                    $('input[name=link_deg]').val(value);
                    return value;
                }
            });
            //外链链阈值
            slider.render({
                elem: '#out_link_deg',
                value: out_link_deg,
                min: 0,
                max: 10,
                setTips: function (value) {
                    $('input[name=out_link_deg]').val(value);
                    return value;
                }
            });
            //标题tag阈值
            slider.render({
                elem: '#title_tag_deg',
                value: title_tag_deg,
                min: 0,
                max: 10,
                setTips: function (value) {
                    $('input[name=title_tag_deg]').val(value);
                    return value;
                }
            });
        },
        timestampFormat: function (timestamp) {
            var d = new Date(timestamp);   //创建一个指定的日期对象
            return d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate() + " " + d.getHours() + ":" + d.getMinutes() + ":" + d.getSeconds();
        }
    });
});