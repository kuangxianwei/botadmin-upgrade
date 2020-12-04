/*导出基本操作*/
layui.define(['form', 'slider', 'table', 'layer'], function (exports) {
    let $ = layui.jquery,
        layer = layui.layer,
        form = layui.form,
        table = layui.table,
        slider = layui.slider,
        tidyObj = function (obj) {
            return Object.prototype.toString.call(obj) === '[object Object]' ? obj : {};
        },
        getParam = function (key, url) {
            if (typeof key !== 'string') {
                return '';
            }
            if (typeof url !== 'string') {
                url = window.location.href;
            }
            let index = url.indexOf('?');
            if (index === -1) {
                return '';
            }
            let params = url.slice(index + 1).split('&');
            for (let i = 0; i < params.length; i++) {
                let param = params[i].split("=");
                if (param[0] === key) {
                    return param[1];
                }
            }
            return '';
        },
        uuid = function () {
            let len = 32,//32长度
                radix = 16,//16进制
                chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'.split(''),
                uuid = [], i;
            radix = radix || chars.length;
            if (len) {
                for (i = 0; i < len; i++) uuid[i] = chars[0 | Math.random() * radix];
            } else {
                let r;
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
        req = function (options) {
            options = $.extend({type: 'POST', dataType: 'json'}, tidyObj(options));
            if (typeof options.url !== 'string') {
                options.url = $('meta[name=current_uri]').attr('content');
            }
            // 加载中...
            let loading = layer.load(1, {shade: [0.7, '#000', true]}),
                isPost = options.type.toUpperCase() === 'POST';
            if (isPost) {
                options.headers = $.extend({'X-CSRF-Token': $('meta[name=csrf_token]').attr('content')}, tidyObj(options.headers));
            }
            let request = $.ajax(options);
            request.done(function (res) {
                if (res.textarea === true && res.msg.length > 50) {
                    res.msg = '<textarea class="layui-textarea" style="height:100%;">' + res.msg + '</textarea>';
                } else {
                    let reg = new RegExp('\n', 'g');
                    res.msg = res.msg.replace(reg, '<br/>');
                }
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
                                let elemClose = $('<i class="layui-icon" close>&#x1006;</i>');
                                o.append(elemClose);
                                elemClose.on('click', function () {
                                    layer.close(index);
                                });
                            }
                        });
                }
            });
            request.fail(function (obj) {
                let msg = 'Fail: statusCode: ' + obj.status;
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
                        let elemClose = $('<i class="layui-icon" close>&#x1006;</i>');
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
        tidyObj: tidyObj,
        getParam: getParam,
        uuid: uuid,
        req: req,
        popup: function (options) {
            options = tidyObj(options);
            let hasSubmit = typeof options.submit === 'string';
            options.submit = hasSubmit ? options.submit : uuid();
            layer.open($.extend({
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
                    if (hasSubmit) {
                        dom.find('*[lay-submit][lay-filter=' + options.submit + ']').click();
                    } else {
                        dom.find('*[lay-submit]').attr('lay-filter', options.submit).click();
                    }
                },
                success: function (dom, index) {
                    form.render();
                    form.on('submit(' + options.submit + ')', function (obj) {
                        req({
                            url: options.url || obj.field.url,
                            data: obj.field,
                            index: index,
                            ending: options.ending,
                        });
                        return false;
                    });
                }
            }, options));
        },
        slider: function () {
            $.each(arguments, function (i, v) {
                let obj = tidyObj(v);
                if (typeof (obj.setTips) !== 'function') {
                    obj.setTips = function (value) {
                        $('input[name=' + obj.elem.slice(1) + ']').val(value);
                        return value;
                    }
                }
                slider.render($.extend({value: 0, min: 0, max: 10}, obj));
            });
        },
        timestampFormat: function (timestamp) {
            let d = new Date(timestamp);   //创建一个指定的日期对象
            return d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate() + " " + d.getHours() + ":" + d.getMinutes() + ":" + d.getSeconds();
        },
        formData: function (elem) {
            let data = {},
                items = {};
            switch (typeof elem) {
                case 'undefined':
                    items = $('.layui-form *[name]').serializeArray();
                    break;
                case 'string':
                    items = $(elem + ' *[name]').serializeArray();
                    break;
                case 'object':
                    items = elem.serializeArray();
                    break;
                default:
                    return {};
            }
            $.each(items, function () {
                let field = data[this.name];
                switch (typeof field) {
                    case 'undefined':
                        data[this.name] = this.value;
                        break;
                    case 'string':
                        if (field !== this.value) {
                            data[this.name] = [field, this.value];
                        }
                        break;
                    case 'object':
                        if (Array.isArray(field) && field.indexOf(this.value) === -1) {
                            field.push(this.value);
                            data[this.name] = field;
                        }
                        break;
                }
            });
            return data;
        }
    });
});