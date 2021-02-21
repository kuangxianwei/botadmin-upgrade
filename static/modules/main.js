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
        err = function (content, options) {
            return layer.alert(content, $.extend({
                skin: 'layui-layer-admin',
                shadeClose: true,
                icon: 2,
                btn: '',
                shade: 0.7,
                closeBtn: false,
                anim: 6,
                title: false,
                success: function (o, index) {
                    let elemClose = $('<i class="layui-icon layui-icon-close-fill" close style="font-size:2rem;color:#ffffff;top:-28px;right: -28px"></i>');
                    o.append(elemClose);
                    elemClose.on('click', function () {
                        layer.close(index);
                    });
                }
            }, options));
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
                if (res.textarea === true && res.code === 0) {
                    let rows = res.msg.split('\n').length;
                    if (rows < 8) {
                        rows = 8
                    }
                    res.msg = '<textarea class="layui-textarea" rows="' + (rows > 12 ? 12 : rows) + '" style="width:500px;height:100%">' + res.msg + '</textarea>';
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
                        return err(res.msg);
                }
            });
            request.fail(function (obj) {
                let msg = 'Fail: statusCode: ' + obj.status;
                if (obj.status === 403) {
                    msg = '登录超时或权限不够 statusCode: ' + obj.status;
                }
                return err(msg);
            });
            request.always(function () {
                layer.close(loading);
            });
        },
        pop = function (options) {
            options = $.extend({
                opacity: '0.7',
                content: '',
                scroll: true,
                confirm: true,
                area: ['auto', 'auto'],
                success: function () {
                    return true;
                }, done: function () {
                    return true;
                },
                zIndex: 2147483000,
            }, options);
            let insertThis = $('div').first();
            if (insertThis.length === 0) {
                insertThis = $('body').last();
            }
            if (insertThis.length === 0) {
                return false;
            }
            let id = uuid();
            insertThis.before('<div id="' + id + '"></div>');
            let popupThis = $('#' + id);
            popupThis.append('<style>.shade{z-index:' + options.zIndex + ';position:fixed;visibility:visible;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,' + options.opacity + ')}.shade>div{min-width:150px;min-height:100px;width:' + options.area[0] + ';height:' + options.area[1] + ';position:absolute;top:50%;left:50%;-webkit-transform:translate(-50%,-50%);transform:translate(-50%,-50%);padding:1.5em;background:#fff;border-radius:10px;box-shadow:-2px 2px 2px #888}.shade>div>div{overflow:' + (options.scroll ? 'scroll' : 'hidden') + ';height:100%;width:100%}.shade>div>.shade-cancel,.shade>div>.shade-confirm{z-index:' + options.zIndex + 1 + ';height:28px;width:28px;line-height:28px;text-align:center;border-radius:14px;position:absolute}.shade>div>.shade-cancel{top:-17px;right:-17px;background-color:rgba(0,0,0,.8);box-shadow:-2px 2px 2px 2px #888}.shade>div>.shade-confirm{bottom:-30px;left:50%;-webkit-transform:translate(-50%,-50%);transform:translate(-50%,-50%);background-color:#0a6e85;box-shadow:-2px -2px 2px 2px #888}</style>');
            popupThis.append('<div class="shade"><div><a href="#" title="Cancel" class="shade-cancel"><svg viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" width="28" height="28"><path d="M810.666667 273.493333L750.506667 213.333333 512 451.84 273.493333 213.333333 213.333333 273.493333 451.84 512 213.333333 750.506667 273.493333 810.666667 512 572.16 750.506667 810.666667 810.666667 750.506667 572.16 512z" fill="#fff"></path></svg></a>' + (options.confirm ? '<a href="#" title="Confirm" class="shade-confirm"><svg viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" width="28" height="28"><path d="M448 864a32 32 0 0 1-18.88-6.08l-320-234.24a32 32 0 1 1 37.76-51.52l292.16 213.44 397.76-642.56a32 32 0 0 1 54.4 33.92l-416 672a32 32 0 0 1-21.12 14.4L448 864z" fill="#fff"></path></svg></a>' : '') + '<div>' + options.content + '</div></div></div>');
            options.success(popupThis);
            popupThis.find('.shade-cancel').click(function () {
                popupThis.remove();
            });
            popupThis.find('.shade-confirm').click(function () {
                if (options.done(popupThis) !== false) {
                    popupThis.remove();
                }
            });
        };
    exports('main', {
        tidyObj: tidyObj,
        getParam: getParam,
        uuid: uuid,
        error: err,
        req: req,
        popup: function (options) {
            options = tidyObj(options);
            let hasSubmit = typeof options.submit === 'string',
                success = typeof options.success === 'function' ? options.success : function () {
                    return true;
                },
                yes = typeof options.yes === 'function' ? options.yes : function () {
                    return true;
                };
            delete options.success;
            delete options.yes;
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
                success: function (dom, index) {
                    if (success(dom, index) === false) {
                        return false
                    }
                    form.render();
                    form.on('submit(' + options.submit + ')', function (obj) {
                        let reqOptions = {
                            url: options.url || obj.field.url,
                            data: obj.field,
                            index: index,
                            ending: options.ending,
                        }, cols = Array();
                        if (typeof options.tips === 'function') {
                            reqOptions.tips = options.tips;
                        }
                        dom.find('.layui-form [name]').each(function (i, v) {
                            if (v.disabled === false && v.name && v.name !== 'cols' && cols.indexOf(v.name) === -1) {
                                cols.push(v.name);
                            }
                        });
                        reqOptions.data.cols = cols.join();
                        req(reqOptions);
                        return false;
                    });
                },
                yes: function (index, dom) {
                    if (yes(index, dom) === false) {
                        return false
                    }
                    if (hasSubmit) {
                        dom.find('*[lay-submit][lay-filter=' + options.submit + ']').click();
                    } else {
                        dom.find('*[lay-submit]').attr('lay-filter', options.submit).click();
                    }
                },
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
                    items = elem.find('[name]').serializeArray();
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
        },
        pop: pop,
        msg: function (msg, options) {
            pop($.extend({content: msg, scroll: false, confirm: false}, options || {}));
        },
        confirm: function (msg, options) {
            pop($.extend({content: msg}, options || {}));
        },
        copy: function () {
            return new function () {
                this.exec = function (value, callback) {
                    let flag, textarea = document.createElement("textarea"),
                        currentFocus = document.activeElement,
                        body = document.getElementsByTagName("body")[0];
                    body.appendChild(textarea);
                    textarea.value = value;
                    textarea.readonly = "readonly";
                    textarea.focus({preventScroll: true});
                    if (textarea.setSelectionRange) {
                        textarea.setSelectionRange(0, textarea.value.length);
                    } else {
                        textarea.select();
                    }
                    try {
                        flag = document.execCommand("copy");
                    } catch (e) {
                        console.log(e);
                        flag = false;
                    }
                    body.removeChild(textarea);
                    currentFocus.focus({preventScroll: true});
                    if (flag && typeof callback === "function") {
                        callback(value);
                    }
                    return flag;
                };
                this.on = function (selector, value, callback) {
                    const othis = document.querySelector(selector);
                    if (typeof value === "undefined") {
                        value = othis.getAttribute("copy-text");
                    } else if (typeof value === "function") {
                        callback = value;
                        value = othis.getAttribute("copy-text");
                    }
                    othis.addEventListener('click', () => {
                        this.exec(value, callback);
                    });
                };
            }
        }(),
        onDel: function () {
            $('i[lay-event="del"]').click(function () {
                $(this).closest('.layui-form-item').remove();
            });
        },
        render: {
            tpl: function (tplName) {
                // 渲染模板图片
                tplName = tplName || $('select[name=tpl_name]').val();
                if (tplName) {
                    $.get('/site/theme', {system: $('select[name=system]').val(), tpl_name: tplName}, function (res) {
                        if (res.code === 0 && res.data.face) {
                            $('#theme').html('<img width="100%" height="100%" alt="' + res.data.alias + '" src="' + res.data.face + '" title="' + res.data.readme + '">');
                        }
                    });
                }
            }
        },
    });
});