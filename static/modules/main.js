/*导出基本操作*/
layui.define(['form', 'slider', 'table', 'layer'], function (exports) {
    window.document.loadJS = function (src, fn) {
        let id = src.replace(/[./]/g, "");
        if (document.getElementById(id)) {
            return false;
        }
        let script = document.createElement('script');
        script.id = id;
        script.src = src;
        script.onload = function () {
            fn && fn();
        };
        document.getElementsByTagName("head")[0].insertAdjacentElement("beforeend", script);
    };
    // 判断字符串结尾
    String.prototype.hasSuffix = function (suffix) {
        return this.indexOf(suffix, this.length - suffix.length) !== -1;
    };
    // 提取字符串中的数字 返回数字数组
    String.prototype.digits = function () {
        let arr = [];
        this.split(/\D+/).forEach(function (s) {
            let i = parseInt(s);
            if (!isNaN(i)) {
                arr.push(i);
            }
        });
        return arr;
    };
    // 存在数组中
    Array.prototype.included = function (item) {
        for (let i = 0; i < this.length; i++) {
            if (this.indexOf(item) !== -1) return true;
        }
        return false;
    };
    const textareaHtml = `<style>.layui-layer-page .layui-layer-content {overflow:unset;}</style><textarea class="layui-textarea" style="border-radius:10px;margin:1%;padding:%0.5;height:94%;width:98%">`;
    let $ = layui.jquery, layer = layui.layer, form = layui.form, table = layui.table, slider = layui.slider,
        range = function (a, b, min, max) {
            if (a > max) {
                a = max;
            }
            if (a < min) {
                a = min
            }
            if (b > max) {
                b = max;
            }
            if (b < min) {
                b = min
            }
            if (a > b) {
                return b + '-' + a;
            }
            if (a === b) {
                return '*';
            }
            return a + '-' + b;
        }, // 每
        per = function (a, b, min, max) {
            if (a < min || a > max) {
                a = '*';
            }
            if (b < 1) {
                b = 1;
            }
            return a + '/' + b;
        }, // 判断是否为空
        isNotBlank = function (str) {
            return str !== undefined && str !== '';
        };

    // tags
    class Tags {
        constructor() {
            // 操作input
            this.controlElem = $('input[lay-event=tags]');
            // 储存input
            this.inputElem = $('input[name=tags]');
            // 默认tag
            this.value = this.inputElem.val();
            // tag显示盒子
            this.boxElem = $('#tags-box');
            this.del = function (elem) {
                let othis = this;
                (elem ? elem.find('i.layui-icon-close-fill') : $('i.layui-icon-close-fill')).off('click').on('click', function () {
                    let thisText = $(this).parent().text(), tagsVal = othis.inputElem.val();
                    $(this).parent().remove();
                    if (tagsVal) {
                        let tags = tagsVal.split(','), newTags = [];
                        for (let i = 0; i < tags.length; i++) {
                            if (tags[i] !== thisText) {
                                newTags.push(tags[i]);
                            }
                        }
                        othis.inputElem.val(newTags.join(','));
                    }
                });
            };
            this.add = function (val) {
                if (val) {
                    let othis = this, tagsVal = othis.inputElem.val(), exists = tagsVal ? tagsVal.split(',') : [];
                    if (tagsVal) {
                        if ($.inArray(val, exists) !== -1) {
                            $(this).val('');
                            return false;
                        }
                        othis.inputElem.val(tagsVal + "," + val);
                    } else {
                        othis.inputElem.val(val);
                    }
                    let tagEle = $('<cite>' + val + '<i class="layui-icon layui-icon-close-fill" style="color:brown;cursor:pointer;"></i></cite>');
                    othis.boxElem.append(tagEle);
                    othis.del(tagEle);
                }
            };
            this.render = function () {
                let othis = this;
                if (othis.value) {
                    let arr = main.unique(othis.value.split(","));
                    othis.inputElem.val(arr.join(","));
                    othis.boxElem.empty();
                    for (let i = 0; i < arr.length; i++) {
                        othis.boxElem.append('<cite>' + arr[i] + '<i class="layui-icon layui-icon-close-fill" style="color:brown;cursor:pointer;"></i></cite>');
                    }
                }
                othis.controlElem.keydown(function (event) {
                    if (event.keyCode === 32) {
                        othis.add(this.value.trim());
                        $(this).val("");
                    }
                });
                othis.controlElem.blur(function () {
                    othis.add(this.value.trim());
                    $(this).val("");
                });
                othis.del(othis.boxElem);
            };
        }
    }

    class Main {
        constructor() {
            this.previewLoaded = false;
            this.previewList = [];
            this.zIndex = function (elem) {
                let index = 0;
                (elem ? elem.siblings() : $("*")).each(function () {
                    let _index = parseInt($(this).css('zIndex')) || 0;
                    if (_index > index) {
                        index = _index
                    }
                });
                return index + 1
            };
            this.isObject = function (obj) {
                return Object.prototype.toString.call(obj) === '[object Object]';
            };
            // 判断是密码col
            this.isPassword = function (colName) {
                return colName.hasSuffix("password") || colName.hasSuffix("passwd")
            };
            // 设置cols
            this.setCols = function (data, dom) {
                if (data && dom && !data.cols) {
                    let othis = this;
                    data.cols = [];
                    $(dom).find('[name]').each(function (i, v) {
                        if (othis.isPassword(v.name) && !v.value) {
                            return;
                        }
                        if (!v.disabled && v.name) {
                            let col = v.name.split('.')[0];
                            if (data.cols.indexOf(col) === -1) {
                                data.cols.push(col);
                            }
                        }
                    });
                    data.cols = data.cols.join(",");
                }
                return data;
            };
            // 整理对象
            this.tidyObj = function (obj) {
                return this.isObject(obj) ? obj : {};
            };
            // 获取URL指定参数的值
            this.getParam = function (key, url) {
                if (typeof key !== 'string') {
                    return '';
                }
                url = typeof url === 'string' ? url : window.location.href;
                let index = url.indexOf('?');
                if (index === -1) {
                    return '';
                }
                let params = url.slice(index + 1).split('&');
                for (let i = 0; i < params.length; i++) {
                    let param = params[i].split('=');
                    if (param[0] === key) {
                        return param[1];
                    }
                }
                return '';
            };
            // 获取一个UUID
            this.uuid = function (len) {
                len = len || 32;
                let chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', maxPos = chars.length,
                    pwd = '';
                for (let i = 0; i < len; i++) {
                    pwd += chars.charAt(Math.floor(Math.random() * maxPos));
                }
                return pwd;
            };
            // 自定义错误提示
            this.error = function (content, options) {
                return layer.alert(`<div style="padding-left:30px;">` + content + `</div>`, $.extend({
                    skin: 'layui-layer-admin',
                    shadeClose: true,
                    maxmin: false,
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
            };
            // 去除重复数组
            this.unique = function (arr) {
                if (Array.isArray(arr)) {
                    let newArr = [];
                    for (let i = 0; i < arr.length; i++) {
                        if ($.inArray(arr[i], newArr) === -1) {
                            newArr.push(arr[i]);
                        }
                    }
                    return newArr;
                }
                return arr;
            };
            // 随机获取列表
            this.randomN = function (items, n) {
                items = this.unique(items);
                let shuffled = items.slice(0), i = items.length;
                n = n > i ? i : n;
                let min = i - n, temp, index;
                while (i-- > min) {
                    index = Math.floor((i + 1) * Math.random());
                    temp = shuffled[index];
                    shuffled[index] = shuffled[i];
                    shuffled[i] = temp;
                }
                return shuffled.slice(min);
            };
            // 监控
            this.on = {
                del: function (selector) {
                    $('i[lay-event=del]').off('click').on('click', function () {
                        let othis = $(this);
                        layer.confirm('确定删除该项吗?', {icon: 3, btn: ['确定', '取消']}, function (index) {
                            layer.close(index);
                            return selector ? $(othis).closest(selector).remove() : $(othis).parent().remove();
                        });
                    });
                }, add: function (addFunc, delSelector) {
                    let othis = this;
                    $('[lay-event="add"]').off('click').on('click', function () {
                        addFunc();
                        othis.del(delSelector);
                    });
                }
            };
            // 复制
            this.copy = function (value, success, error) {
                if (navigator.clipboard && navigator.permissions) {
                    navigator.clipboard.writeText(value).then(() => {
                        if (typeof success === 'function') return success(value);
                        layer.msg('复制成功');
                    }).catch(() => {
                        if (typeof error === 'function') return error(value);
                        layer.msg('复制失败');
                    });
                } else {
                    try {
                        let elem = document.createElement('span');
                        elem.style.position = 'absolute';
                        elem.style.bottom = '-100%';
                        elem.innerText = value;
                        document.getElementsByTagName("body")[0].insertAdjacentElement("beforeend", elem);
                        let selection = window.getSelection(), range = document.createRange();
                        range.selectNodeContents(elem);
                        selection.removeAllRanges();
                        selection.addRange(range);
                        document.execCommand('copy');
                        elem.remove();
                        if (typeof success === 'function') return success(value);
                        layer.msg('复制成功');
                    } catch (e) {
                        console.error(e);
                        if (typeof error === 'function') return error(value);
                        layer.msg('复制失败');
                    }
                }
            };
            // 加载中
            this.loading = function (options) {
                let loadIndex = layer.load(1, $.extend({shade: [0.7, '#000', true]}, options || {}));
                return {
                    index: loadIndex, close: function () {
                        layer.close(this.index);
                    }
                };
            };
        }

        download(filename) {
            window.open('/file/download?filename=' + encodeURIComponent(filename));
        }

        // ajax 请求
        request(options, dom) {
            options = $.extend({type: 'POST', dataType: 'json'}, options);
            let othis = this, reloadOptions = $.extend({}, options),
                // 加载中...
                loading = layer.load(1, {shade: [0.7, '#000', true]});
            if (options.type.toUpperCase() === 'POST') options.headers = $.extend({'X-CSRF-Token': $('meta[name=csrf_token]').attr('content')}, options.headers || {});
            othis.setCols(options.data, dom);
            if (options.data) $.each(options.data, function (k, v) {
                if ((k.hasSuffix("password") || k.hasSuffix("passwd")) && v) {
                    options.data[k] = encrypt.encrypt(v);
                }
            });
            let request = $.ajax(options);
            request.done(function (res) {
                if (res.textarea === true && res.code === 0) {
                    let rows = res.msg.split('\n').length;
                    if (rows < 8) {
                        rows = 8
                    }
                    res.msg = '<textarea class="layui-textarea" rows="' + (rows > 12 ? 12 : rows) + '" style="min-width:500px;width:auto;height:100%;margin:10px;">' + res.msg + '</textarea>';
                } else {
                    let reg = new RegExp('\n', 'g');
                    res.msg = res.msg.replace(reg, '<br/>');
                }
                switch (res.code) {
                    case 0:
                        if (options.index) layer.close(options.index);
                        if (typeof options.done === 'string') {
                            table.reload(options.done, {page: {curr: 1}});
                        } else if (typeof options.done === 'function' && options.done(res) === false) {
                            return false;
                        }
                        if (res.textarea === true) {
                            layer.open({type: 1, title: false, content: res.msg, shade: 0.8});
                        } else {
                            layer.msg(res.msg, {icon: 1, shade: [0.6, '#000', true]});
                        }
                        break;
                    case 1001:
                    case 403:
                        window.location.replace('/auth/login?next=' + $('meta[name=current_uri]').attr('content'));
                        break;
                    default:
                        if (typeof options.error === 'function' && options.error(res) === false) {
                            return false;
                        }
                        return othis.error(res.msg);
                }
            });
            request.fail(function (xhr, status, error) {
                if (typeof options.fail === 'function' && options.fail(xhr, status, error) === false) {
                    return false;
                }
                return othis.error(error);
            });
            request.always(function (res) {
                if (typeof options.always === 'function' && options.always(res) === false) {
                    return false;
                }
                layer.close(loading);
            });
            return {
                dom: dom, options: reloadOptions, reload: function (options, dom) {
                    return othis.request($.extend(true, this.options, options || {}), dom);
                }
            };
        }

        // open
        open(options) {
            layer.open($.extend({
                type: 1,
                shadeClose: true,
                scrollbar: false,
                btnAlign: 'c',
                shade: 0.8,
                maxmin: true,
                btn: ['提交', '取消'],
                area: ['95%', '95%'],
            }, options || {}));
        }

        // 弹窗
        popup(options) {
            let othis = this;
            options = othis.tidyObj(options);
            let hasSubmit = typeof options.submit === 'string', success = options.success,
                yes = options.yes, error = options.error;
            delete options.success;
            delete options.yes;
            delete options.error;
            options.submit = hasSubmit ? options.submit : othis.uuid();
            othis.open($.extend({
                success: function (dom, index) {
                    form.render();
                    if (typeof success === 'function' && success(dom, index) === false) {
                        return false
                    }
                    let $this = this;
                    form.on('submit(' + options.submit + ')', function (obj) {
                        othis.request({
                            url: options.url || obj.field.url,
                            data: obj.field,
                            index: index,
                            done: options.done,
                            tips: options.tips,
                            error: function (res) {
                                typeof error === 'function' && error.call($this, res)
                            },
                        }, dom);
                        return false;
                    });
                },
                yes: function (index, dom) {
                    if (typeof yes === 'function' && yes(index, dom) === false) {
                        return false
                    }
                    if (hasSubmit) {
                        dom.find('[lay-submit][lay-filter=' + options.submit + ']').click();
                    } else {
                        dom.find('[lay-submit]').attr('lay-filter', options.submit).click();
                    }
                }
            }, options));
        }

        // 滑块
        slider() {
            let othis = this;
            $.each(arguments, function (i, v) {
                let obj = othis.tidyObj(v);
                if (typeof obj.value === 'undefined') {
                    let val = $(obj.elem).siblings('input[name]').first().val() || '';
                    if (obj.range) {
                        obj.value = [];
                        $.each(val.split('-'), function (index, value) {
                            obj.value[index] = parseInt(value) || 0;
                        });
                    } else {
                        obj.value = parseInt(val) || 0;
                    }
                }
                if (typeof obj.change !== 'function') {
                    obj.change = function (value) {
                        if (obj.range) {
                            $(obj.elem).siblings('input[name]').first().val(value[0] + '-' + value[1]);
                        } else {
                            $(obj.elem).siblings('input[name]').first().val(value);
                        }
                    }
                }
                slider.render($.extend({value: 0, min: 0, max: 10, input: true}, obj));
            });
        }

        // 格式时间
        timestampFormat(timestamp) {
            timestamp = timestamp ? timestamp.toString() : '0';
            if (timestamp.length > 13) {
                timestamp = timestamp.substring(0, 13)
            } else {
                while (timestamp.length < 13) {
                    timestamp += '0'
                }
            }
            let d = new Date(parseInt(timestamp));   //创建一个指定的日期对象
            return d.getFullYear() + '-' + (d.getMonth() + 1) + '-' + d.getDate() + " " + d.getHours() + ":" + d.getMinutes() + ":" + d.getSeconds();
        }

        // 获取表单数据
        formData(elem) {
            let data = {}, items = {};
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
        }

        durations(dom) {
            let formData = this.formData(dom);
            dom.find('[name=durations]').val(formData.duration ? (Array.isArray(formData.duration) ? formData.duration.join() : formData.duration) : '')
        }

        // 弹出展示
        // 默认不显示标题 不显示最大化和最小化 不显示按钮
        display(options) {
            layer.open($.extend(true, {
                type: 1,
                title: false,
                btn: false,
                maxmin: false,
                shadeClose: true,
                scrollbar: false,
                btnAlign: 'c',
                shade: 0.8,
                area: ['95%', '95%'],
            }, options || {}));
        }

        // 弹窗展示 textarea
        textarea(text, options) {
            if (typeof text !== 'string') {
                return false;
            }
            this.display($.extend(true, {content: textareaHtml + text + '</textarea>'}, options || {}));
        }

        // tags
        // options {value:"tag1,tag2",inputElem:$('input[name=tags]'),boxElem:$('#tags-box')}
        tags(options) {
            let tagClass = new Tags();
            $.extend(tagClass, options);
            tagClass.render();
        }

        // 填充客服变量
        onFillContact() {
            $('.fill-contact').html(`<label class="layui-form-label" style="padding:5px 15px;color:coral">插入变量:</label>
<button class="layui-btn layui-btn-xs layui-btn-radius layui-btn-primary" data-write="default">默认HTML</button>
<button class="layui-btn layui-btn-xs layui-btn-radius" data-write="{{phone}}">手机号</button>
<button class="layui-btn layui-btn-xs layui-btn-radius" data-write="{{wechat}}">微信号</button>
<button class="layui-btn layui-btn-xs layui-btn-radius" data-write="wechat">复制微信</button>
<button class="layui-btn layui-btn-xs layui-btn-radius" data-write="{{alias}}">别名</button>
<button class="layui-btn layui-btn-xs layui-btn-radius" data-write="{{email}}">邮箱</button>
<button class="layui-btn layui-btn-xs layui-btn-radius" data-write="{{qr}}">二维码URL</button>
<button class="layui-btn layui-btn-xs layui-btn-radius" data-write="qr">二维码HTML</button>
<button class="layui-btn layui-btn-xs layui-btn-radius" data-write="{{hostname}}">Host</button>
<button class="layui-btn layui-btn-xs layui-btn-radius" data-write="{{consult}}">在线URL</button>
<a class="layui-btn layui-btn-xs layui-btn-radius layui-btn-primary" lay-href="/file?path=data/contact/images" lay-text="图片管理">复制图片地址</a>
`);
            $('[data-write]').off("click").on("click", function () {
                let elem = $(this).closest("div.layui-form-item").find("textarea"), write = $(this).data("write");
                switch (write) {
                    case "qr":
                        elem.insertAt('<img src="{{qr}}" alt="微信号:{{wechat}}" title="{{wechat}}" width="150" height="150">');
                        break;
                    case "wechat":
                        elem.insertAt('<cite data-trace="复制微信" data-event="copy" data-value="{{wechat}}" title="点击复制微信号:{{wechat}}">复制微信</cite>');
                        break;
                    case "default":
                        elem.val('<img src="{{qr}}" alt="微信号:{{wechat}}" title="{{wechat}}" width="150" height="150">{{alias}}很高兴为您服务，您可以拨打电话{{phone}}、加微信{{wechat}}或者邮箱{{email}}联系我们!');
                        break;
                    default:
                        elem.insertAt(write);
                }
            });
        }

        // 获取文件名
        basename(path) {
            let paths = decodeURIComponent(path).split('/');
            return paths[paths.length - 1];
        }

        // 获取图片src
        getSrc(s) {
            if (/(^\/file\/download\?filename=)|(^https?:\/\/)/.test(s)) {
                return s;
            }
            return '/file/download?filename=' + encodeURIComponent(s);
        }

        // 获取图片列表
        getPreviewList(elem, attrName) {
            if (elem === false) return false;
            let re = new RegExp(/\.(jpg|jpeg|gif|bmp|png)$/);
            attrName = attrName || 'title';
            let othis = this;
            (elem ? $(elem) : $('[data-field=name] [title]')).each(function () {
                let path = $(this).attr(attrName);
                if (path) {
                    path = othis.getSrc(path);
                    if (!othis.previewList.includes(path) && re.test(path)) {
                        othis.previewList.push(path);
                    }
                }
            });
            return this.previewList;
        }

        // 预览图片
        preview(src, elem, attrName) {
            if (!src || $(".preview-images-mask").length > 0) return false;
            src = this.getSrc(src);
            let othis = this,
                $body = $('body'),
                $mask = $('<div class="preview-images-mask" style="z-index:2147483000"><div class="preview-head"><span class="preview-title">截图</span><span class="preview-small" title="缩小显示" style="display:none;"><span class="iconfont icon-resize-small" aria-hidden="true"></span></span><span class="preview-full" title="最大化显示"><span class="iconfont icon-resize-full" aria-hidden="true"></span></span><span class="preview-close" title="关闭图片预览视图"><span class="iconfont icon-remove" aria-hidden="true"></span></span></div><div class="preview-body"><img id="preview-images" src="' + src + '" alt=""/></div><div class="preview-toolbar"><a href="javascript:;" title="左旋转"><span class="iconfont icon-rotate-left" aria-hidden="true"></span></a><a href="javascript:;" title="右旋转"><span class="iconfont icon-rotate-right" aria-hidden="true"></span></a><a href="javascript:;" title="放大视图"><span class="iconfont icon-zoom-in" aria-hidden="true"></span></a><a href="javascript:;" title="缩小视图"><span class="iconfont icon-zoom-out" aria-hidden="true"></span></a><a href="javascript:;" title="重置视图"><span class="iconfont icon-refresh" aria-hidden="true"></span></a><a href="javascript:;" title="图片列表"><span class="iconfont icon-list" aria-hidden="true"></span></a></div><div class="preview-cut-view"><a href="javascript:;" title="上一张"><span class="iconfont icon-menu-left" aria-hidden="true"></span></a><a href="javascript:;" title="下一张"><span class="iconfont icon-menu-right" aria-hidden="true"></span></a></div></div>'),
                config = {
                    naturalWidth: 0,
                    naturalHeight: 0,
                    initWidth: 0,
                    initHeight: 0,
                    previewWidth: 0,
                    previewHeight: 0,
                    currentWidth: 0,
                    currentHeight: 0,
                    currentLeft: 0,
                    currentTop: 0,
                    rotate: 0,
                    scale: 1,
                    imagesMouse: false
                };
            $body.css('overflow', 'hidden').append($mask);
            config.previewWidth = $mask[0].clientWidth;
            config.previewHeight = $mask[0].clientHeight;

            // 自动大小
            function autoImagesSize() {
                let rotate = Math.abs(config.rotate / 90),
                    previewW = rotate % 2 === 0 ? config.previewWidth : config.previewHeight,
                    previewH = rotate % 2 === 0 ? config.previewHeight : config.previewWidth;
                config.initWidth = config.naturalWidth;
                config.initHeight = config.naturalHeight;
                if (config.initWidth > previewW) {
                    config.initWidth = previewW;
                    config.initHeight = parseFloat((previewW / config.naturalWidth * config.initHeight).toFixed(2));
                }
                if (config.initHeight > previewH) {
                    config.initWidth = parseFloat((previewH / config.naturalHeight * config.initWidth).toFixed(2));
                    config.initHeight = previewH;
                }
                config.currentWidth = config.initWidth * config.scale;
                config.currentHeight = config.initHeight * config.scale;
                config.currentLeft = parseFloat(((config.previewWidth - config.currentWidth) / 2).toFixed(2));
                config.currentTop = parseFloat(((config.previewHeight - config.currentHeight) / 2).toFixed(2));
                $("#preview-images").css({
                    width: config.currentWidth,
                    height: config.currentHeight,
                    top: config.currentTop,
                    left: config.currentLeft,
                    display: "inline",
                    transform: "rotate(" + config.rotate + "deg)",
                    opacity: 1,
                    transition: "all 400ms"
                });
            }

            let loading = this.loading();
            $('.preview-body img').load(function () {
                let img = $(this)[0];
                config.naturalWidth = img.naturalWidth;
                config.naturalHeight = img.naturalHeight;
                autoImagesSize();
                $('.preview-title').text(othis.basename(src) + ' W:' + img.naturalWidth + ' H:' + img.naturalHeight);
                loading.close();
            });
            if (Array.isArray(elem)) {
                this.previewList = elem;
            } else {
                this.getPreviewList(elem, attrName);
            }
            if (this.previewList.length < 2) {
                $('.preview-images-mask .preview-cut-view').hide();
            }
            if (!this.previewLoaded) {
                this.previewLoaded = true;
                $(document).on('click', '.preview-close', function (e) {
                    $(".preview-images-mask").remove();
                    $('body').css('overflow', '');
                    e.stopPropagation();
                });
                $(document).on('click', '.preview-full', function () {
                    $(this).hide().prev().show();
                    config.previewWidth = window.innerWidth;
                    config.previewHeight = window.innerHeight;
                    $('.preview-images-mask').css({
                        width: window.innerWidth,
                        height: window.innerHeight,
                        top: 0,
                        left: 0,
                        margin: 0,
                        zIndex: 2147483000
                    });
                    autoImagesSize();
                });
                $(document).on('click', '.preview-small', function () {
                    $(this).hide().next().show();
                    $('.preview-images-mask').removeAttr('style');
                    config.previewWidth = 750;
                    config.previewHeight = 650;
                    autoImagesSize();
                });
                $(document).on('click', '.preview-toolbar a', function () {
                    let index = $(this).index();
                    switch (index) {
                        case 0:
                        case 1:
                            config.rotate = index ? config.rotate + 90 : config.rotate - 90;
                            autoImagesSize();
                            break;
                        case 2:
                        case 3:
                            if (3 === config.scale && 2 === index || .2 === config.scale && 3 === index)
                                return layer.msg(config.scale >= 1 ? "图像放大，已达到最大尺寸。" : "图像缩小，已达到最小尺寸。");
                            config.scale = (2 === index ? Math.round(10 * (config.scale + .4)) : Math.round(10 * (config.scale - .4))) / 10;
                            autoImagesSize();
                            break;
                        case 4:
                            let scale_offset = config.rotate % 360;
                            scale_offset >= 180 ? config.rotate += 360 - scale_offset : config.rotate -= scale_offset;
                            config.scale = 1;
                            autoImagesSize();
                    }
                });
                $(document).on('mousedown', '#preview-images', function (e) {
                    $(this).onselectstart = $(this).ondrag = function () {
                        return false;
                    };
                    let images = $(this),
                        $mask = $(".preview-images-mask"),
                        preview = $mask.offset(),
                        diffX = e.clientX - preview.left,
                        diffY = e.clientY - preview.top;
                    $mask.on('mousemove', (function (e) {
                        let offsetX = e.clientX - preview.left - diffX,
                            offsetY = e.clientY - preview.top - diffY, rotate = Math.abs(config.rotate / 90),
                            previewW = rotate % 2 === 0 ? config.previewWidth : config.previewHeight,
                            previewH = rotate % 2 === 0 ? config.previewHeight : config.previewWidth,
                            left, top;
                        if (config.currentWidth > previewW) {
                            let max_left = previewW - config.currentWidth;
                            (left = config.currentLeft + offsetX) > 0 ? left = 0 : left < max_left && (left = max_left),
                                config.currentLeft = left
                        }
                        if (config.currentHeight > previewH) {
                            let max_top = previewH - config.currentHeight;
                            (top = config.currentTop + offsetY) > 0 ? top = 0 : top < max_top && (top = max_top),
                                config.currentTop = top
                        }
                        config.currentHeight > previewH && config.currentTop <= 0 && config.currentHeight - previewH <= config.currentTop && (config.currentTop -= offsetY),
                            images.css({
                                left: config.currentLeft,
                                top: config.currentTop
                            })
                    })).on('mouseup', (function () {
                        $(this).off('mousemove mouseup')
                    })).on('dragstart', (function () {
                        e.preventDefault()
                    }))
                });
                $(document).on('dragstart', '#preview-images', function () {
                    return false
                });
                $(document).on('mousedown', '.preview-images-mask .preview-head', function (e) {
                    let drag = $(this).parent();
                    if ($('body').addClass('select'), $(this).onselectstart = $(this).ondrag = function () {
                        return false;
                    }, !$(e.target).hasClass('preview-close')) {
                        let diffX = e.clientX - drag.offset().left, diffY = e.clientY - drag.offset().top;
                        $(document).on('mousemove', (function (e) {
                            let left = e.clientX - diffX, top = e.clientY - diffY;
                            left < 0 ? left = 0 : left > window.innerWidth - drag.width() && (left = window.innerWidth - drag.width()),
                                top < 0 ? top = 0 : top > window.innerHeight - drag.height() && (top = window.innerHeight - drag.height()),
                                drag.css({left: left, top: top, margin: 0})
                        })).on('mouseup', function () {
                            $(this).off('mousemove mouseup')
                        })
                    }
                });
                $(document).on('click', '.preview-cut-view a', function () {
                    let index = 0;
                    for (let i = 0; i < othis.previewList.length; i++) {
                        if (src === othis.previewList[i]) {
                            index = i;
                            break;
                        }
                    }
                    if ($(this).index()) {
                        index += 1;
                    } else {
                        index -= 1;
                    }
                    if (index >= othis.previewList.length) {
                        index = 0
                    } else if (index < 0) {
                        index = othis.previewList.length - 1;
                    }
                    src = othis.previewList[index];
                    let loading = othis.loading();
                    $('#preview-images').attr('src', src).load(function () {
                        let img = $(this)[0];
                        config.naturalWidth = img.naturalWidth;
                        config.naturalHeight = img.naturalHeight;
                        autoImagesSize();
                        $('.preview-title').text(othis.basename(src) + ' W:' + img.naturalWidth + ' H:' + img.naturalHeight);
                        loading.close();
                    });
                });
            }
        }

        displayTheme(tplName) {
            tplName = tplName || $('#site select[name=tpl_name]').val() || $('select[name=tpl_name]').val();
            let system = $('#site select[name=system]').val() || $('select[name=system]').val();
            // 渲染模板图片
            if (tplName && system) {
                let loading = main.loading();
                $.get('/site/theme', {system: system, tpl_name: tplName}).always(function () {
                    loading.close();
                }).done(function (res) {
                    if (res.code === 0 && res.data.face) {
                        $('#theme').html($('<img width="100%" height="100%" alt="" src="">').attr({
                            src: '/file/download?filename=' + res.data['small_face'],
                            'data-src': res.data['face'],
                            alt: res.data.alias,
                            title: res.data['intro'],
                        }));
                    } else {
                        main.error(res.msg);
                    }
                });
            }
        }
    }

    let main = new Main();
    $(document).on('click', 'img', function (e) {
        main.preview($(this).data('src'));
        e.stopPropagation();
    });
    // 定时规则spec
    let Cron = function (elem) {
        // 输入点例如：input[name=spec]
        this.elem = $(elem);
        this.spec = [];
        this.tabs = ['秒', '分', '时', '日', '月', '周'];
        layui.link('/static/style/cron.css');
        this.dom = null;
    };
    // 初始化
    Cron.prototype.init = function () {
        this.value = this.elem.val() || '* * * * * ?';
        let arr = this.value.split(' ');
        for (let i = 0; i < 6; i++) {
            if (i === 5) {
                this.spec[i] = arr[i] || '?';
            } else {
                this.spec[i] = arr[i] || '*';
            }
        }
        this.dom = $('<div class="layui-cron"></div>');
    };
    // 计算秒
    Cron.prototype.computeSeconds = function () {
        let othis = this, data = form.val('cronSecForm'), dataType = data['type[0]'];
        if ('range' === dataType && isNotBlank(data['rangeStart']) && isNotBlank(data['rangeEnd'])) {
            othis.spec[0] = range(data['rangeStart'], data['rangeEnd'], 0, 59);
        } else if ('per' === dataType && isNotBlank(data['perFrom']) && isNotBlank(data['perVal'])) {
            othis.spec[0] = per(data['perFrom'], data['perVal'], 0, 59);
        } else if ('assign' === dataType) {
            let checkbox = [];
            layui.each(data, function (key, value) {
                if (/^seconds/.test(key)) {
                    checkbox.push(value);
                }
            });
            if (checkbox.length) {
                othis.spec[0] = checkbox.join(',');
            } else {
                othis.spec[0] = '*';
            }
        } else if ('all' === dataType) {
            othis.spec[0] = '*';
        }
    };
    // 计算分
    Cron.prototype.computeMinutes = function () {
        let othis = this, data = form.val('cronMinForm'), dataType = data['type[1]'];
        if ('range' === dataType && isNotBlank(data['rangeStart']) && isNotBlank(data['rangeEnd'])) {
            othis.spec[1] = range(data['rangeStart'], data['rangeEnd'], 0, 59);
        } else if ('per' === dataType && isNotBlank(data['perFrom']) && isNotBlank(data['perVal'])) {
            othis.spec[1] = per(data['perFrom'], data['perVal'], 0, 59);
        } else if ('assign' === dataType) {
            let checkbox = [];
            layui.each(data, function (key, value) {
                if (/^minutes/.test(key)) {
                    checkbox.push(value);
                }
            });
            if (checkbox.length) {
                othis.spec[1] = checkbox.join(',');
            } else {
                othis.spec[1] = '*';
            }
        } else if ('all' === dataType) {
            othis.spec[1] = '*';
        }
    };
    // 计算时
    Cron.prototype.computeHours = function () {
        let othis = this, data = form.val('cronHourForm'), dataType = data['type[2]'];
        if ('range' === dataType && isNotBlank(data['rangeStart']) && isNotBlank(data['rangeEnd'])) {
            othis.spec[2] = range(data['rangeStart'], data['rangeEnd'], 0, 23);
        } else if ('per' === dataType && isNotBlank(data['perFrom']) && isNotBlank(data['perVal'])) {
            othis.spec[2] = per(data['perFrom'], data['perVal'], 0, 24);
        } else if ('assign' === dataType) {
            let checkbox = [];
            layui.each(data, function (key, value) {
                if (/^hours/.test(key)) {
                    checkbox.push(value);
                }
            });
            if (checkbox.length) {
                othis.spec[2] = checkbox.join(',');
            } else {
                othis.spec[2] = '*';
            }
        } else if ('all' === dataType) {
            othis.spec[2] = '*';
        }
    };
    // 计算天
    Cron.prototype.computeDays = function () {
        let othis = this, data = form.val('cronDayForm'), dataType = data['type[3]'];

        if ('range' === dataType && isNotBlank(data['rangeStart']) && isNotBlank(data['rangeEnd'])) {
            othis.spec[3] = range(data['rangeStart'], data['rangeEnd'], 1, 31);
        } else if ('per' === dataType && isNotBlank(data['perFrom']) && isNotBlank(data['perVal'])) {
            othis.spec[3] = per(data['perFrom'], data['perVal'], 1, 31);
        } else if ('assign' === dataType) {
            let checkbox = [];
            layui.each(data, function (key, value) {
                if (/^days/.test(key)) {
                    checkbox.push(value);
                }
            });
            if (checkbox.length) {
                othis.spec[3] = checkbox.join(',');
            } else {
                othis.spec[3] = '*';
            }
        } else if ('all' === dataType) {
            othis.spec[3] = '*';
        } else if ('none' === dataType) {
            othis.spec[3] = '?';
        }
    };
    // 计算月
    Cron.prototype.computeMonths = function () {
        let othis = this, data = form.val('cronMonthForm'), dataType = data['type[4]'];
        if ('range' === dataType && isNotBlank(data['rangeStart']) && isNotBlank(data['rangeEnd'])) {
            othis.spec[4] = range(data['rangeStart'], data['rangeEnd'], 1, 12);
        } else if ('per' === dataType && isNotBlank(data['perFrom']) && isNotBlank(data['perVal'])) {
            othis.spec[4] = per(data['perFrom'], data['perVal'], 1, 12);
        } else if ('assign' === dataType) {
            let checkbox = [];
            layui.each(data, function (key, value) {
                if (/^months/.test(key)) {
                    checkbox.push(value);
                }
            });
            if (checkbox.length) {
                othis.spec[4] = checkbox.join(',');
            } else {
                othis.spec[4] = '*';
            }
        } else if ('all' === dataType) {
            othis.spec[4] = '*';
        }
    };
    // 计算周
    Cron.prototype.computeWeeks = function () {
        let othis = this, data = form.val('cronWeekForm'), dataType = data['type[5]'];
        if ('range' === dataType && isNotBlank(data['rangeStart']) && isNotBlank(data['rangeEnd'])) {
            othis.spec[5] = range(data['rangeStart'], data['rangeEnd'], 0, 6);
        } else if ('per' === dataType && isNotBlank(data['perFrom']) && isNotBlank(data['perVal'])) {
            othis.spec[5] = per(data['perFrom'], data['perVal'], 0, 6);
        } else if ('assign' === dataType) {
            let checkbox = [];
            layui.each(data, function (key, value) {
                if (/^weeks/.test(key)) {
                    checkbox.push(value);
                }
            });
            if (checkbox.length) {
                othis.spec[5] = checkbox.join(',');
            } else {
                othis.spec[5] = '*';
            }
        } else if ('all' === dataType) {
            othis.spec[5] = '*';
        } else if ('none' === dataType) {
            othis.spec[5] = '?';
        }
    };
    // 渲染秒
    Cron.prototype.secondsElem = function () {
        let othis = this, elem = '<div class="layui-tab-item layui-show layui-form" lay-filter="cronSecForm">',
            radio = ['', '', '', ''], val = ['', '', '', '', []];
        if (othis.spec[0] === '*') {
            radio[0] = 'checked';
        } else if (othis.spec[0].split('-').length === 2) {
            let arr = othis.spec[0].split('-');
            radio[1] = 'checked';
            val[0] = arr[0];
            val[1] = arr[1];
        } else if (othis.spec[0].split('/').length === 2) {
            let arr = othis.spec[0].split('/');
            radio[2] = 'checked';
            val[2] = arr[0];
            val[3] = arr[1];
        } else {
            radio[3] = 'checked';
            val[4] = othis.spec[0].split(',');
        }
        elem += '<div><input type="radio" name="type[0]" value="all" title="每秒" ' + radio[0] + '></div>';
        elem += '<div><input type="radio" name="type[0]" value="range" title="周期" ' + radio[1] + '/>';
        elem += '<div class="cron-input-mid">从</div><input class="cron-input" type="number" name="rangeStart" value="' + val[0] + '"/>';
        elem += '<div class="cron-input-mid">-</div><input class="cron-input" type="number" name="rangeEnd" value="' + val[1] + '"/>';
        elem += '<div class="cron-input-mid">秒</div><span class="cron-tips">(0-59)</span></div>';
        elem += '<div><input type="radio" name="type[0]" value="per" title="按照" ' + radio[2] + '>';
        elem += '<div class="cron-input-mid">从</div><input class="cron-input" type="number" name="perFrom" value="' + val[2] + '"/>';
        elem += '<div class="cron-input-mid">秒开始，每</div><input class="cron-input" type="number" name="perVal" value="' + val[3] + '"/>';
        elem += '<div class="cron-input-mid">秒执行一次</div><span class="cron-tips">(0/59)</span></div>';
        elem += '<div><input type="radio" name="type[0]" value="assign" title="指定" ' + radio[3] + '></div>';
        elem += '<div>';
        for (let i = 0; i < 60; i++) {
            elem += '<input type="checkbox" lay-skin="primary" name="seconds[' + i + ']" value="' + i + '" title="' + i + '" ' + (val[4].indexOf('' + i) > -1 ? 'checked' : '') + '>';
        }
        elem += '</div></div>';
        return elem;
    };
    // 渲染分
    Cron.prototype.minutesElem = function () {
        let othis = this, elem = '<div class="layui-tab-item layui-form" lay-filter="cronMinForm">',
            radio = ['', '', '', ''], val = ['', '', '', '', []];
        if (othis.spec[1] === '*') {
            radio[0] = 'checked';
        } else if (othis.spec[1].split('-').length === 2) {
            let arr = othis.spec[1].split('-');
            radio[1] = 'checked';
            val[0] = arr[0];
            val[1] = arr[1];
        } else if (othis.spec[1].split('/').length === 2) {
            let arr = othis.spec[1].split('/');
            radio[2] = 'checked';
            val[2] = arr[0];
            val[3] = arr[1];
        } else {
            radio[3] = 'checked';
            val[4] = othis.spec[1].split(',');
        }
        elem += '<div><input type="radio" name="type[1]" value="all" title="每分" ' + radio[0] + '></div>';
        elem += '<div><input type="radio" name="type[1]" value="range" title="周期" ' + radio[1] + '/>';
        elem += '<div class="cron-input-mid">从</div><input class="cron-input" type="number" name="rangeStart" value="' + val[0] + '"/>';
        elem += '<div class="cron-input-mid">-</div><input class="cron-input" type="number" name="rangeEnd" value="' + val[1] + '"/>';
        elem += '<div class="cron-input-mid">分</div><span class="cron-tips">(0-59)</span></div>';
        elem += '<div><input type="radio" name="type[1]" value="per" title="按照" ' + radio[2] + '>';
        elem += '<div class="cron-input-mid">从</div><input class="cron-input" type="number" name="perFrom" value="' + val[2] + '"/>';
        elem += '<div class="cron-input-mid">分开始，每</div><input class="cron-input" type="number" name="perVal" value="' + val[3] + '"/>';
        elem += '<div class="cron-input-mid">分执行一次</div><span class="cron-tips">(0/59)</span></div>';
        elem += '<div><input type="radio" name="type[1]" value="assign" title="指定" ' + radio[3] + '></div>';
        elem += '<div>';
        for (let i = 0; i < 60; i++) {
            elem += '<input type="checkbox" lay-skin="primary" name="minutes[' + i + ']" value="' + i + '" title="' + i + '"' + (val[4].indexOf('' + i) > -1 ? 'checked' : '') + '>';
        }
        elem += '</div></div>';
        return elem;
    };
    // 渲染时
    Cron.prototype.hoursElem = function () {
        let othis = this, elem = '<div class="layui-tab-item layui-form" lay-filter="cronHourForm">',
            radio = ['', '', '', ''], val = ['', '', '', '', []];
        if (othis.spec[2] === '*') {
            radio[0] = 'checked';
        } else if (othis.spec[2].split('-').length === 2) {
            let arr = othis.spec[2].split('-');
            radio[1] = 'checked';
            val[0] = arr[0];
            val[1] = arr[1];
        } else if (othis.spec[2].split('/').length === 2) {
            let arr = othis.spec[2].split('/');
            radio[2] = 'checked';
            val[2] = arr[0];
            val[3] = arr[1];
        } else {
            radio[3] = 'checked';
            val[4] = othis.spec[2].split(',');
        }

        elem += '<div><input type="radio" name="type[2]" value="all" title="每小时" ' + radio[0] + '></div>';
        elem += '<div><input type="radio" name="type[2]" value="range" title="周期" ' + radio[1] + '/>';
        elem += '<div class="cron-input-mid">从</div><input class="cron-input" type="number" name="rangeStart" value="' + val[0] + '"/>';
        elem += '<div class="cron-input-mid">-</div><input class="cron-input" type="number" name="rangeEnd" value="' + val[1] + '"/>';
        elem += '<div class="cron-input-mid">时</div><span class="cron-tips">(0-23)</span></div>';
        elem += '<div><input type="radio" name="type[2]" value="per" title="按照" ' + radio[2] + '>';
        elem += '<div class="cron-input-mid">从</div><input class="cron-input" type="number" name="perFrom" value="' + val[2] + '"/>';
        elem += '<div class="cron-input-mid">时开始，每</div><input class="cron-input" type="number" name="perVal" value="' + val[3] + '"/>';
        elem += '<div class="cron-input-mid">时执行一次</div><span class="cron-tips">(0/23)</span></div>';
        elem += '<div><input type="radio" name="type[2]" value="assign" title="指定" ' + radio[3] + '></div>';
        elem += '<div>';
        for (let i = 0; i < 24; i++) {
            elem += '<input type="checkbox" lay-skin="primary" name="hours[' + i + ']" value="' + i + '" title="' + i + '" ' + (val[4].indexOf('' + i) > -1 ? 'checked' : '') + '>';
        }
        elem += '</div></div>';
        return elem;
    };
    // 渲染天
    Cron.prototype.daysElem = function () {
        let othis = this, elem = '<div class="layui-tab-item layui-form" lay-filter="cronDayForm">',
            radio = ['', '', '', '', ''], val = ['', '', '', '', []];
        if (othis.spec[3] === '*') {
            radio[0] = 'checked';
        } else if (othis.spec[3] === '?') {
            radio[1] = 'checked';
        } else if (othis.spec[3].split('-').length === 2) {
            let arr = othis.spec[3].split('-');
            radio[2] = 'checked';
            val[0] = arr[0];
            val[1] = arr[1];
        } else if (othis.spec[3].split('/').length === 2) {
            let arr = othis.spec[3].split('/');
            radio[3] = 'checked';
            val[2] = arr[0];
            val[3] = arr[1];
        } else {
            radio[4] = 'checked';
            val[4] = othis.spec[3].split(',');
        }
        elem += '<div><input type="radio" name="type[3]" value="all" title="每天" ' + radio[0] + '></div>';
        elem += '<div><input type="radio" name="type[3]" value="none" title="不指定" ' + radio[1] + '></div>';
        elem += '<div><input type="radio" name="type[3]" value="range" title="周期" ' + radio[2] + '/>';
        elem += '<div class="cron-input-mid">从</div><input class="cron-input" type="number" name="rangeStart" value="' + val[0] + '"/>';
        elem += '<div class="cron-input-mid">-</div><input class="cron-input" type="number" name="rangeEnd" value="' + val[1] + '"/>';
        elem += '<div class="cron-input-mid">日</div><span class="cron-tips">(1-31)</span></div>';
        elem += '<div><input type="radio" name="type[3]" value="per" title="按照" ' + radio[3] + '>';
        elem += '<div class="cron-input-mid">从</div><input class="cron-input" type="number" name="perFrom" value="' + val[2] + '"/>';
        elem += '<div class="cron-input-mid">日开始，每</div><input class="cron-input" type="number" name="perVal" value="' + val[3] + '"/>';
        elem += '<div class="cron-input-mid">日执行一次</div><span class="cron-tips">(1/31)</span></div>';
        elem += '<div><input type="radio" name="type[3]" value="assign" title="指定" ' + radio[4] + '></div>';
        elem += '<div>';
        for (let i = 1; i <= 31; i++) {
            elem += '<input type="checkbox" lay-skin="primary" name="days[' + i + ']" value="' + i + '" title="' + i + '" ' + (val[4].indexOf('' + i) > -1 ? 'checked' : '') + '>';
        }
        elem += '</div></div>';
        return elem;
    };
    // 渲染月
    Cron.prototype.monthsElem = function () {
        let othis = this, elem = '<div class="layui-tab-item layui-form" lay-filter="cronMonthForm">',
            radio = ['', '', '', ''], val = ['', '', '', '', []];
        if (othis.spec[4] === '*') {
            radio[0] = 'checked';
        } else if (othis.spec[4].split('-').length === 2) {
            let arr = othis.spec[4].split('-');
            radio[1] = 'checked';
            val[0] = arr[0];
            val[1] = arr[1];
        } else if (othis.spec[4].split('/').length === 2) {
            let arr = othis.spec[4].split('/');
            radio[2] = 'checked';
            val[2] = arr[0];
            val[3] = arr[1];
        } else {
            radio[3] = 'checked';
            val[4] = othis.spec[4].split(',');
        }
        elem += '<div><input type="radio" name="type[4]" value="all" title="每个月" ' + radio[0] + '></div>';
        elem += '<div><input type="radio" name="type[4]" value="range" title="周期" ' + radio[1] + '/>';
        elem += '<div class="cron-input-mid">从</div><input class="cron-input" type="number" name="rangeStart" value="' + val[0] + '"/>';
        elem += '<div class="cron-input-mid">-</div><input class="cron-input" type="number" name="rangeEnd" value="' + val[1] + '"/>';
        elem += '<div class="cron-input-mid">月</div><span class="cron-tips">(1-12)</span></div>';
        elem += '<div><input type="radio" name="type[4]" value="per" title="按照" ' + radio[2] + ">";
        elem += '<div class="cron-input-mid">从</div><input class="cron-input" type="number" name="perFrom" value="' + val[2] + '"/>';
        elem += '<div class="cron-input-mid">月开始，每</div><input class="cron-input" type="number" name="perVal" value="' + val[3] + '"/>';
        elem += '<div class="cron-input-mid">月执行一次</div><span class="cron-tips">(1/12)</span></div>';
        elem += '<div><input type="radio" name="type[4]" value="assign" title="指定" ' + radio[3] + '></div>';
        elem += '<div>';
        for (let i = 1; i <= 12; i++) {
            elem += '<input type="checkbox" lay-skin="primary" name="months[' + i + ']" value="' + i + '" title="' + i + '" ' + (val[4].indexOf('' + i) > -1 ? 'checked' : '') + '>';
        }
        elem += '</div></div>';
        return elem;
    };
    // 渲染周
    Cron.prototype.weeksElem = function () {
        let othis = this, elem = '<div class="layui-tab-item layui-form" lay-filter="cronWeekForm">',
            radio = ['', '', '', '', ''], val = ['', '', '', '', []];
        if (othis.spec[5] === '*') {
            radio[0] = 'checked';
        } else if (othis.spec[5] === '?') {
            radio[1] = 'checked';
        } else if (othis.spec[5].split('-').length === 2) {
            let arr = othis.spec[5].split('-');
            radio[2] = 'checked';
            val[0] = arr[0];
            val[1] = arr[1];
        } else if (othis.spec[5].split('/').length === 2) {
            let arr = othis.spec[5].split('/');
            radio[3] = 'checked';
            val[2] = arr[0];
            val[3] = arr[1];
        } else {
            radio[4] = 'checked';
            val[4] = othis.spec[5].split(',');
        }
        elem += '<div><input type="radio" name="type[5]" value="all" title="每个周" ' + radio[0] + '></div>';
        elem += '<div><input type="radio" name="type[5]" value="none" title="不指定" ' + radio[1] + '></div>';
        elem += '<div><input type="radio" name="type[5]" value="range" title="周期" ' + radio[2] + '/>';
        elem += '<div class="cron-input-mid">从</div><input class="cron-input" type="number" name="rangeStart" value="' + val[0] + '"/>';
        elem += '<div class="cron-input-mid">-</div><input class="cron-input" type="number" name="rangeEnd" value="' + val[1] + '"/>';
        elem += '<div class="cron-input-mid">周</div><span class="cron-tips">(1-7)</span></div>';
        elem += '<div><input type="radio" name="type[5]" value="per" title="按照" ' + radio[3] + '>';
        elem += '<div class="cron-input-mid">周</div><input class="cron-input" type="number" name="perFrom" value="' + val[2] + '"/>';
        elem += '<div class="cron-input-mid">开始,每</div><input class="cron-input" type="number" name="perVal" value="' + val[3] + '"/>';
        elem += '<div class="cron-input-mid">周执行一次</div><span class="cron-tips">(0-6/1-7)</span></div>';
        elem += '<div><input type="radio" name="type[5]" value="assign" title="指定" ' + radio[4] + '></div>';
        elem += '<div>';
        for (let i = 0; i <= 7; i++) {
            elem += '<input type="checkbox" lay-skin="primary" name="weeks[' + i + ']" value="' + i + '" title="' + i + '" ' + (val[4].indexOf('' + i) > -1 ? 'checked' : '') + '>';
        }
        elem += '</div></div>';
        return elem;
    };
    // 渲染视图
    Cron.prototype.render = function () {
        let othis = this;
        othis.init();
        // 主区域
        let elemMain = '<div class="layui-tab layui-tab-card">'; // tabs容器
        // 组装容器
        elemMain += '<ul class="layui-tab-title">';
        layui.each(othis.tabs, function (i, tab) {
            if (i === 0) {
                elemMain += '<li class="layui-this">' + tab + "</li>";
            } else {
                elemMain += '<li>' + tab + '</li>';
            }
        });
        elemMain += "</ul>";
        elemMain += '<div class="layui-tab-content" style="padding:10px;width:450px;">' + othis.secondsElem() + // 秒
            othis.minutesElem() + // 分
            othis.hoursElem() + // 时
            othis.daysElem() + // 日
            othis.monthsElem() + // 月
            othis.weeksElem(); // 周
        elemMain += '</div></div>';
        othis.dom.append(elemMain);
        return othis.dom.prop('outerHTML');
    };
    // 完成后
    Cron.prototype.done = function () {
        this.computeSeconds();
        this.computeMinutes();
        this.computeHours();
        this.computeDays();
        this.computeMonths();
        this.computeWeeks();
        if (this.spec[5] !== '?' && this.spec[3] !== '?') {
            layer.msg('不支持周参数和日参数同时存在', {icon: 2, time: 5000});
            return false;
        }
        this.elem.val(this.spec.join(' ').trim());
        return true;
    };
    // 事件
    Cron.prototype.events = function () {
        let othis = this;
        // 如果需要绑定的dom不存在或者已经绑定过了则退出
        if (!othis.elem || othis.elem.eventHandler) {
            return;
        }
        // 绑定聚焦事件
        othis.elem.focus(function () {
            main.display({
                area: ["560px", "430px"],
                btn: "确定",
                fixed: true,
                content: othis.render(),
                success: function () {
                    form.render();
                    layui.element.render();
                    return true;
                },
                yes: function (index, dom) {
                    othis.done(dom);
                    layer.close(index)
                }
            });
        });
        othis.elem.eventHandler = true;
    };


    // 信息提示框
    main.msg = function (msg, options) {
        main.display($.extend({
            type: 0, area: "auto", content: msg, success: function (dom) {
                dom.find("textarea").css("border-radius", "10px");
            }
        }, options || {}));
    };
    // 渲染
    main.render = {
        fill: function (options) {
            options = $.extend({selector: "input[data-type=fill]", max: 15, text: "自动填充"}, options || {});
            $(options.selector).each(function () {
                let $this = $(this),
                    elem = $('<button class="layui-btn layui-btn-radius">' + options.text + '</button>').on("click", function () {
                        $this.val(main.uuid(options.max));
                    });
                $this.parent().after(elem);
            });
        },
        theme: function () {
            //改变模板目录列表
            form.on('select(system)', function (obj) {
                $('#theme-shop').attr("lay-href", "/themes/shop?driver=" + obj.value);
                $.get('/site/admin', {system: obj.value}, function (html) {
                    $('#site input[name=admin_dir]').val(html);
                });
                $.get('/site/tpl', {
                    system: obj.value,
                    tpl_name: $('#site select[name=tpl_name]').val()
                }, function (html) {
                    $('#site div[lay-filter=tpl_name]').html(html);
                    form.render();
                    $('#theme').empty();
                    main.displayTheme();
                });
                if (obj.value === 'dedecms' || obj.value === 'cms') {
                    $('#site select[name=rewrite]>option').prop('selected', false);
                } else {
                    $('#site select[name=rewrite]>option[value="' + obj.value + '.conf"]').prop('selected', true);
                }
                form.render('select');
            });
            // 改变模板
            form.on('select(tpl_name)', function (obj) {
                $('#theme').empty();
                main.displayTheme(obj.value);
            });
            main.displayTheme();
        },
    };
    // websocket
    main.ws = {
        display: function (options, callback) {
            options = $.extend({
                name: '',
                displaySelector: '#display',
                statusSelector: '#status'
            }, options || {});
            if (!options.name) {
                return false;
            }
            let w = new WebSocket((window.location.protocol === 'https:' ? 'wss://' : 'ws://') + window.location.host + '/ws/log');
            w.onopen = function () {
                w.send(options.name);
            };
            w.onmessage = function (e) {
                if (e.data) {
                    let status = e.data.substr(0, 1),// 状态码
                        data = e.data.substr(1);// 内容
                    if (options.statusSelector) {
                        if (status === '0') {
                            $(options.statusSelector).html('状态: <strong style="color: red" title="' + status + '">未运行</strong>');
                        } else {
                            $(options.statusSelector).html('状态: <strong style="color: #22849b" title="' + status + '">运行中...</strong>');
                        }
                    }
                    let el = $(options.displaySelector);
                    el.val(el.val() + data).focus().scrollTop(el[0].scrollHeight);
                    if (typeof callback === 'function') {
                        callback(status, data);
                    }
                }
            };
        }, log: function (name, callback) {
            if (!name) {
                return false;
            }
            let w = new WebSocket((window.location.protocol === 'https:' ? 'wss://' : 'ws://') + window.location.host + '/ws/log');
            main.textarea("", {
                area: ["75%", "75%"],
                success: function (dom) {
                    let elem = dom.find("textarea");
                    elem.css("margin-top", "-20px").before('<div style="position:relative;z-index:29821027;left:20px;width:90px;padding:6px;top:-20px;background-color:#ffffff;border-radius:8px 8px 0 0" id="log-status">状态: <strong style="color: red" title="0">未运行</strong></div>');
                    let statusElem = dom.find('#log-status');
                    w.onopen = function () {
                        w.send(name);
                    };
                    w.onmessage = function (e) {
                        if (e.data) {
                            let statusCode = e.data.substr(0, 1);
                            if (statusCode === '0') {
                                statusElem.html('状态: <strong style="color:red" title="' + statusCode + '">未运行</strong>');
                            } else {
                                statusElem.html('状态: <strong style="color:#22849b" title="' + statusCode + '">运行中...</strong>');
                            }
                            elem.focus().append(e.data.substr(1)).scrollTop(elem[0].scrollHeight);
                        }
                    };
                },
                end: function () {
                    w.close();
                    typeof callback === 'function' && callback();
                }
            });
        },
    };
    // 定时任务规则
    main.cron = function () {
        $.each(arguments, function (i, elem) {
            if (elem) {
                let obj = new Cron(elem);
                obj.events();
            }
        });
    };
    main.reset = {
        log: function (prefix, ids, options) {
            if (!prefix) {
                return;
            }
            ids = ids || [];
            for (let i = 0; i < ids.length; i++) {
                ids[i] = prefix + '.' + ids[i];
            }
            if (ids.length === 0) {
                ids.push(prefix + '.0');
            }
            let tokens = ids.join();
            layer.confirm('清空日志记录? Tokens: <br/>' + tokens, function (index) {
                main.request($.extend({
                    url: '/record/reset', index: index, data: {tokens: tokens},
                }, options || {}));
            });
        },
    };
    main.reboot = {
        app: function () {
            layer.confirm("确定重启App?", {icon: 3, title: false}, function (index) {
                main.request({
                    url: "/system/reboot", data: {act: "botadmin"}, index: index, done: function () {
                        main.sleep(3000);
                        layer.alert('重启App成功!', {title: false, icon: 1, btn: "重新登录"}, function (index) {
                            layer.close(index);
                            parent.location.replace("/auth/logout");
                        });
                        return false;
                    }
                });
            });
        }, service: function () {
            layer.confirm("确定重启服务器?", {icon: 3, title: false}, function (index) {
                main.request({
                    url: "/system/reboot", data: {act: "reboot"}, index: index, done: function () {
                        main.sleep(5000);
                        layer.alert('重启服务器成功!', {title: false, icon: 1, btn: "重新登录"}, function (index) {
                            layer.close(index);
                            parent.location.replace("/auth/logout");
                        });
                        return false;
                    }
                });
            });
        },
    };
    main.logout = function () {
        layui.view.exit();
        window.location.href = '/auth/logout?next=' + window.location.pathname;
    };
    // 暂停函数
    main.sleep = function (d) {
        for (let t = Date.now(); Date.now() - t <= d;) {
        }
    };
    // 监听搜索
    main.onSearch = function (options) {
        form.on('submit(search)', function (data) {
            let field = data.field, cols = [];
            $.each(field, function (k, v) {
                let col = k.split('.')[0];
                if (v && col !== 'cols' && cols.indexOf(col) === -1) {
                    cols.push(col);
                } else {
                    delete field[k];
                }
            });
            field.cols = cols.join(",");
            if (!field.cols) {
                return window.location.reload();
            }
            // 执行重载
            table.reload('table-list', {
                where: $.extend(field, options || {}), page: {curr: 1}
            });
            return false;
        });
        // 监控select
        form.on('select(search-select)', function () {
            $('[lay-filter=search]').click();
        });
        // 监控 input
        $('.table-search input,[lay-event=search] input').keydown(function (event) {
            if (event.keyCode === 13) {
                $('[lay-filter=search]').click();
            }
        });
    };
    main.checkLNMP = function () {
        $.get("/plugin/lnmp", {}, function (html) {
            if (html) {
                if (html === 'lnmp.0') {
                    main.ws.log("lnmp.0");
                    return false;
                }
                main.popup({
                    url: "/plugin/lnmp",
                    title: "安装web服务器",
                    content: html,
                    area: ['560px', 'auto'],
                    tips: function () {
                        main.ws.log("lnmp.0");
                    }
                });
            }
        });
    };
    main.webssh = function (options) {
        options = $.extend({id: 0, stdin: ""}, options);
        layer.open({
            type: 2,
            shade: 0.8,
            maxmin: true,
            title: "连接ssh 执行cmd命令行",
            area: ["800px", "500px"],
            content: ["/webssh/terminal?id=" + options.id + "&stdin=" + options.stdin, 'no'],
        });
    };
    main.upload = function (options) {
        return layui.upload.render($.extend({
            headers: {'X-CSRF-Token': csrfToken},
            elem: '#import',
            url: url + '/import',
            accept: 'file',
            exts: 'conf|txt|json|tar.gz|zip',
            before: function () {
                layer.load(); //上传loading
            },
            done: function (res) {
                layer.closeAll('loading'); //关闭loading
                if (res.code === 0) {
                    layer.msg(res.msg);
                    table.reload('table-list');
                } else {
                    layer.alert(res.msg, {icon: 2});
                }
            },
        }, options || {}));
    };
    main.table = function (cols, options) {
        options = main.isObject(cols) ? cols : options;
        return table.render($.extend({
            headers: {'X-CSRF-Token': csrfToken},
            method: 'post',
            elem: '#table-list',
            toolbar: '#toolbar',
            url: url,
            cols: Array.isArray(cols) ? cols : [[]],
            page: true,
            limit: 10,
            limits: [10, 50, 100, 500],
            text: '对不起，加载出现异常！'
        }, options || {}));
    };
    exports('main', main);
});