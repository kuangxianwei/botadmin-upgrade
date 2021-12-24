/*导出基本操作*/
layui.define(['form', 'slider', 'table', 'layer'], function (exports) {
    // 判断字符串结尾
    String.prototype.hasSuffix = function (suffix) {
        return this.indexOf(suffix, this.length - suffix.length) !== -1;
    }
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
    }
    const textareaHtml = `<style>.layui-layer-page .layui-layer-content {overflow:unset;}</style><textarea class="layui-textarea" style="border-radius:10px;margin:1%;padding:%0.5;height:94%;width:98%">`;

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
            this.zIndex = function (elem) {
                let index = 0;
                (elem ? elem.siblings() : $("*")).each(function () {
                    let _index = parseInt($(this).css('zIndex')) || 0;
                    if (_index > index) {
                        index = _index
                    }
                });
                return index + 1
            }
            this.isObject = function (obj) {
                return Object.prototype.toString.call(obj) === '[object Object]';
            }
            // 判断是密码col
            this.isPassword = function (colName) {
                return colName.hasSuffix("password") || colName.hasSuffix("passwd")
            }
            // 设置cols
            this.setCols = function (data, dom) {
                let othis = this;
                if (data && dom && !data.cols) {
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
            }
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
            this.err = function (content, options) {
                return layer.alert(content, $.extend({
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
            }
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
            this.copy = {
                exec: function (value, success) {
                    try {
                        let elem = document.createElement("span");
                        elem.style.position = "absolute";
                        elem.style.bottom = "-100%";
                        elem.innerText = value;
                        document.getElementsByTagName("body")[0].insertAdjacentElement("beforeend", elem);
                        let selection = window.getSelection()
                            , range = document.createRange();
                        range.selectNodeContents(elem);
                        selection.removeAllRanges();
                        selection.addRange(range);
                        document.execCommand("copy");
                        elem.remove();
                        typeof success === "function" && success(value)
                    } catch (e) {
                        console.error(e);
                        alert("复制失败");
                    }
                },
                on: function (selector, value, callback) {
                    let othis = this;
                    const elem = document.querySelector(selector);
                    if (typeof value === "undefined") {
                        value = elem.getAttribute("copy-text");
                    } else if (typeof value === "function") {
                        callback = value;
                        value = elem.getAttribute("copy-text");
                    }
                    elem.addEventListener('click', function () {
                        othis.exec(value, callback);
                    });
                },
            };
            // 加载中
            this.loading = function (options) {
                let loadIndex = layer.load(1, $.extend({shade: [0.7, '#000', true]}, options || {}));
                return {
                    index: loadIndex, close: function () {
                        layer.close(this.index);
                    }
                };
            }
        }

        // ajax 请求
        req(options, dom) {
            let othis = this;
            options = $.extend({type: 'POST', dataType: 'json'}, options || {});
            if (typeof options.url !== 'string') {
                options.url = $('meta[name=current_uri]').attr('content');
            }
            let reloadOptions = $.extend({}, options);
            // 加载中...
            let loading = layer.load(1, {shade: [0.7, '#000', true]});
            if (options.type.toUpperCase() === 'POST') {
                options.headers = $.extend({'X-CSRF-Token': $('meta[name=csrf_token]').attr('content')}, options.headers || {});
            }
            othis.setCols(options.data, dom);
            if (options.data) {
                $.each(options.data, function (k, v) {
                    if ((k.hasSuffix("password") || k.hasSuffix("passwd")) && v) {
                        options.data[k] = encrypt.encrypt(v);
                    }
                });
            }
            let request = $.ajax(options);
            request.done(function (res) {
                if (res.textarea === true && res.code === 0) {
                    let rows = res.msg.split('\n').length;
                    if (rows < 8) {
                        rows = 8
                    }
                    res.msg = '<textarea class="layui-textarea" rows="' + (rows > 12 ? 12 : rows) + '" style="min-width:500px;height:100%">' + res.msg + '</textarea>';
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
                        } else if (typeof options.ending === 'function' && options.ending(res) === false) {
                            return false;
                        }
                        layer.msg(res.msg, {icon: 1, shade: [0.6, '#000', true]});
                        break;
                    case 1001:
                    case 403:
                        window.location.replace('/auth/login?next=' + $('meta[name=current_uri]').attr('content'));
                        break;
                    default:
                        if (typeof options.error === 'function' && options.error(res) === false) {
                            return false;
                        }
                        return othis.err(res.msg);
                }
            });
            request.fail(function (obj) {
                if (typeof options.fail === 'function' && options.fail(obj) === false) {
                    return false;
                }
                let msg = 'Fail: statusCode: ' + obj.status;
                if (obj.status === 403) {
                    msg = '登录超时或权限不够 statusCode: ' + obj.status;
                }
                return othis.err(msg);
            });
            request.always(function () {
                layer.close(loading);
            });
            return {
                dom: dom, options: reloadOptions, reload: function (options, dom) {
                    return othis.req($.extend(true, this.options, options || {}), dom);
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
            let hasSubmit = typeof options.submit === 'string',
                success = typeof options.success === 'function' ? options.success : function () {
                    return true;
                }, yes = typeof options.yes === 'function' ? options.yes : function () {
                    return true;
                };
            delete options.success;
            delete options.yes;
            options.submit = hasSubmit ? options.submit : othis.uuid();
            othis.open($.extend({
                success: function (dom, index) {
                    form.render();
                    if (success(dom, index) === false) {
                        return false
                    }
                    form.on('submit(' + options.submit + ')', function (obj) {
                        othis.req({
                            url: options.url || obj.field.url,
                            data: obj.field,
                            index: index,
                            ending: options.ending,
                            tips: options.tips,
                        }, dom);
                        return false;
                    });
                }, yes: function (index, dom) {
                    if (yes(index, dom) === false) {
                        return false
                    }
                    let cols = [];
                    dom.find('[name]').each(function () {
                        if (this.name && this.name.indexOf(cols) === -1) {
                            cols.push(this.name);
                        }
                    });
                    if (cols) {
                        dom.find('.layui-form input[name=cols]').remove();
                        dom.find('.layui-form').append('<input type="hidden" name="cols" value="' + cols.join(",") + '">');
                    }
                    if (hasSubmit) {
                        dom.find('*[lay-submit][lay-filter=' + options.submit + ']').click();
                    } else {
                        dom.find('*[lay-submit]').attr('lay-filter', options.submit).click();
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

        // 填充内置CMS模板变量
        onFillTheme() {
            let othis = this,
                formHTML = '<div class="layui-card"><div class="layui-card-body layui-form"></div></div>',
                btnGroupHTML = `<div class="layui-row">
    <div class="layui-col-md6"><div class="layui-btn-group">
        <button class="layui-btn layui-btn-xs layui-btn-primary">全局标签</button>
        <button class="layui-btn layui-btn-xs" data-write="{{.Config.Hostname}}">Hostname</button>
        <button class="layui-btn layui-btn-xs" data-write="{{.Config.Title}}">站名</button>
        <button class="layui-btn layui-btn-xs" data-write="{{.Config.Subtitle}}">副站名</button>
        <button class="layui-btn layui-btn-xs" data-write="{{.Config.Keywords}}">关键词</button>
        <button class="layui-btn layui-btn-xs" data-write="{{.Config.City}}">城市名称</button>
        <button class="layui-btn layui-btn-xs" data-write="{{.Config.Province}}">省名称</button>
        <button class="layui-btn layui-btn-xs" data-write="{{.Config.About}}">关于我们</button>
        <button class="layui-btn layui-btn-xs" data-write="{{.Pager}}">页标识</button>
        <button class="layui-btn layui-btn-xs" data-write="{{HTML .Config.Copyright}}">版权</button>
        <button class="layui-btn layui-btn-xs" data-write='{{template "模板.tpl" .}}'>导入模板</button>
        <button class="layui-btn layui-btn-xs" data-write="nav">导航HTML</button>
        <button class="layui-btn layui-btn-xs" data-write="link">友链HTML</button>
        <button class="layui-btn layui-btn-xs" data-write="tags">Tags</button>
    </div></div>
    <div class="layui-col-md6"><div class="layui-btn-group">
        <button class="layui-btn layui-btn-xs layui-btn-primary" data-write="list">列表标签</button>
        <button class="layui-btn layui-btn-xs" data-write="{{HTML .Positions}}">当前位置</button>
        <button class="layui-btn layui-btn-xs" data-write="{{HTML .Paginator}}">分页</button>
    </div></div>
    <div class="layui-col-md6"><div class="layui-btn-group">
        <button class="layui-btn layui-btn-xs layui-btn-primary" data-write="loop">循环标签</button>
        <button class="layui-btn layui-btn-xs" data-write="{{.Title}}">标题</button>
        <button class="layui-btn layui-btn-xs" data-write="{{.Subtitle}}">副标题</button>
        <button class="layui-btn layui-btn-xs" data-write="{{.Url}}">URL</button>
        <button class="layui-btn layui-btn-xs" data-write="{{.TitlePic}}">标题图片</button>
        <button class="layui-btn layui-btn-xs" data-write="{{sub .Title 30}}">标题</button>
        <button class="layui-btn layui-btn-xs" data-write="{{sub .Description 150}}">描述</button>
        <button class="layui-btn layui-btn-xs" data-write='{{date .Updated "2006-01-02 15:04:05"}}'>时间</button>
        <button class="layui-btn layui-btn-xs" data-write='{{class .Cid | HTML}}'>栏目link</button>
        <button class="layui-btn layui-btn-xs" data-write="{{HTML .}}">HTML</button>
        <button class="layui-btn layui-btn-xs" data-write="{{imgHTML .}}">imgHTML</button>
    </div></div>
    <div class="layui-col-md6"><div class="layui-btn-group">
        <button class="layui-btn layui-btn-xs layui-btn-primary" data-write="head">头部标签</button>
        <button class="layui-btn layui-btn-xs" data-write="{{.Title}}">标题</button>
        <button class="layui-btn layui-btn-xs" data-write="{{.Keywords}}">关键词</button>
        <button class="layui-btn layui-btn-xs" data-write="{{.Description}}">描述</button>
        <button class="layui-btn layui-btn-xs" data-write="{{canonicalLabel .Url}}">Canonical</button>
        <button class="layui-btn layui-btn-xs" data-write="{{.Theme}}">主题路径</button>
    </div></div>
    <div class="layui-col-md6"><div class="layui-btn-group">
        <button class="layui-btn layui-btn-xs layui-btn-primary">文章标签</button>
        <button class="layui-btn layui-btn-xs" data-write="{{HTML .Positions}}">当前位置</button>
        <button class="layui-btn layui-btn-xs" data-write="{{.Article.Title}}">标题</button>
        <button class="layui-btn layui-btn-xs" data-write='{{date .Article.Created "2006-01-02 15:04:05"}}'>发布时间</button>
        <button class="layui-btn layui-btn-xs" data-write='<script src="{{.Config.Hostname}}/hot.js?aid={{.Article.Id}}"></script>'>点击量</button>
        <button class="layui-btn layui-btn-xs" data-write="{{source}}">来源</button>
        <button class="layui-btn layui-btn-xs" data-write="{{HTML .Article.Content}}">内容</button>
        <button class="layui-btn layui-btn-xs" data-write="{{call .Article.MipContent}}">Mip内容</button>
        <button class="layui-btn layui-btn-xs" data-write="tag">TagHTML</button>
        <button class="layui-btn layui-btn-xs" data-write="{{.PreNext.Pre}}">上一篇</button>
        <button class="layui-btn layui-btn-xs" data-write="{{.PreNext.Next}}">上一篇</button>
        <button class="layui-btn layui-btn-xs" data-write="like">相关文章HTML</button>
    </div></div>
</div>`,
                headHTML = `<head>
    <meta charset="UTF-8">
    <meta content="IE=11,IE=10,IE=9,IE=8" http-equiv="X-UA-Compatible">
    <meta content="pc,mobile" name="applicable-device">
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport">
    <title>{{.Title}}</title>
    <meta content="{{.Keywords}}" name="keywords">
    <meta content="{{.Description}}" name="description">
    <link href="{{.Theme}}/css/style.css" media="all" rel="stylesheet" type="text/css"/>
    <script src="{{.Theme}}/js/bootstrap.min.js" type="text/javascript"></script>
    {{canonicalLabel .Url}}
    <meta content="webpage" property="og:type"/>
    <meta content="{{.Url}}" property="og:url"/>
    <meta content="{{.Config.Subtitle}}" property="og:site_name"/>
    <meta content="{{.Title}}" property="og:title"/>
    <meta content="{{.Description}}" property="og:description"/>
    <meta content="{{.TitlePic}}" property="og:image"/>
</head>`,
                navHTML = `<ul class="nav">
    <li>
        <a href="{{.Config.Hostname}}/">首页</a>
    <li>
        {{- range classes 12}}
    <li{{if eq .Id $.Class.Id}} class="cur"{{end}}>
        <a href="{{.Url}}">{{.Name}}</a>
        {{- if .Children}}
        <ul>
            {{- range .Children}}
            <li{{if eq .Id $.Class.Id}} class="cur"{{end}}><a href="{{.Url}}">{{.Name}}</a></li>
            {{- end}}
        </ul>
        {{- end}}
    </li>
    {{- end}}
</ul>`,
                linkHTML = `<div class="layui-form-item">
    <label class="layui-form-label">限制:</label>
    <div class="layui-input-inline">
        <input class="layui-input" min="1" name="limit" type="number" value="30">
    </div>
</div><div class="layui-form-item">
    <label class="layui-form-label">显示:</label>
    <div class="layui-input-block">
        <input name="pager" title="全部" type="radio" value="all">
        <input checked name="pager" title="首页" type="radio" value="index">
        <input name="pager" title="封面" type="radio" value="face">
        <input name="pager" title="文章" type="radio" value="article">
        <input name="pager" title="TAG" type="radio" value="tag">
    </div>
</div>`,
                tagsHTML = `<div class="layui-form-item">
    <label class="layui-form-label">限制:</label>
    <div class="layui-input-inline">
        <input class="layui-input" min="1" name="limit" type="number" value="30">
    </div>
</div><div class="layui-form-item">
    <label class="layui-form-label">推荐:</label>
    <div class="layui-input-block">
        <input name="level" title="荐1" type="checkbox" value="1">
        <input name="level" title="荐2" type="checkbox" value="2">
        <input name="level" title="荐3" type="checkbox" value="3">
    </div>
</div><div class="layui-form-item">
    <label class="layui-form-label">排序:</label>
    <div class="layui-input-block">
        <input checked name="order" title="最火" type="radio" value="0">
        <input name="order" title="最新" type="radio" value="1">
        <input name="order" title="随机" type="radio" value="2">
    </div>
</div>`;
            $('#filepath').append('<button class="layui-btn layui-btn-sm layui-btn-radius" data-event="theme-func" style="margin-left:10px">查看模板支持函数</button>');
            $('.fill-theme').removeClass("layui-hide").html(btnGroupHTML);
            $('[data-write]').off("click").on("click", function () {
                let $this = $(this), elem = $this.closest(".layui-form").find("textarea[name=content]"),
                    write = $this.data("write");
                switch (write) {
                    case "head":
                        elem.insertAt(headHTML);
                        break;
                    case "nav":
                        elem.insertAt(navHTML);
                        break;
                    case "link":
                        othis.open({
                            area: ["600px", "280px"], title: "友情链接标签", content: formHTML, success: function (dom) {
                                dom.find(".layui-form").html(linkHTML);
                                form.render();
                            }, yes: function (index, dom) {
                                let data = othis.formData(dom);
                                if (data.pager === 'all') {
                                    elem.insertAt(`<ul class="link">
    {{- range links ` + data.limit + `}}
    <li>{{HTML .}}</li>
    {{- end}}
</ul>`);
                                } else {
                                    elem.insertAt(`{{if eq .Pager "` + data.pager + `"}}
<ul class="link">
    {{- range links ` + data.limit + `}}
    <li>{{HTML .}}</li>
    {{- end}}
</ul>
{{end}}`);
                                }
                                layer.close(index);
                            },
                        });
                        break;
                    case "tags":
                        othis.open({
                            area: ["600px", "280px"], title: "Tags标签", content: formHTML, success: function (dom) {
                                dom.find(".layui-form").html(tagsHTML);
                                form.render();
                            }, yes: function (index, dom) {
                                let data = othis.formData(dom),
                                    begin = "{{- range tags " + (parseInt(data.order) || 0) + " " + data.limit;
                                if (data.level) {
                                    begin += " \"level=" + data.level.join(",") + "\"";
                                }
                                begin += "}}"
                                elem.insertAt(`<ul class="tags">
    ` + begin + `
    <li>{{HTML .}}</li>
    {{- end}}
</ul>`);
                                layer.close(index);
                            },
                        });
                        break;
                    case "like":
                        othis.open({
                            area: ["600px", "280px"], title: "相关文章标签", content: formHTML, success: function (dom) {
                                dom.find(".layui-form").html(`<div class="layui-form-item">
    <label class="layui-form-label">限制:</label>
    <div class="layui-input-inline">
        <input class="layui-input" min="1" name="limit" type="number" value="30">
    </div>
</div>
<div class="layui-form-item">
    <label class="layui-form-label">显示:</label>
    <div class="layui-input-block">
        <input name="pager" title="全部" type="radio" value="all">
        <input checked name="pager" title="首页" type="radio" value="index">
        <input name="pager" title="封面" type="radio" value="face">
        <input name="pager" title="文章" type="radio" value="article">
        <input name="pager" title="TAG" type="radio" value="tag">
    </div>
</div>`);
                                form.render();
                            }, yes: function (index, dom) {
                                let data = othis.formData(dom);
                                if (data.pager === 'all') {
                                    elem.insertAt(`<ul class="like">
    {{- range like ` + data.limit + `}}
    <li>{{HTML .}}</li>
    {{- end}}
</ul>`);
                                } else {
                                    elem.insertAt(`{{if eq .Pager "` + data.pager + `"}}
<ul class="link">
    {{- range links ` + data.limit + `}}
    <li>{{HTML .}}</li>
    {{- end}}
</ul>
{{end}}`);
                                }
                                layer.close(index);
                            },
                        });
                        break;
                    case "loop":
                        othis.open({
                            area: ["900px", "460px"], title: "循环标签", content: formHTML, success: function (dom) {
                                dom.find(".layui-form").html(`<div class="layui-form-item">
    <div class="layui-inline">
        <label class="layui-form-label" lay-tips="留空为当前栏目">栏目ID:</label>
        <div class="layui-input-block">
            <input class="layui-input" name="id" placeholder="1,2,3,5,6" type="text" value="">
        </div>
    </div>
    <div class="layui-inline">
        <label class="layui-form-label">循环限制:</label>
        <div class="layui-input-block">
            <input class="layui-input" min="1" name="limit" type="number" value="8">
        </div>
    </div>
</div>
<div class="layui-form-item">
    <div class="layui-inline">
        <label class="layui-form-label">标题截取:</label>
        <div class="layui-input-block">
            <input class="layui-input" min="1" name="sub_title" type="number" value="60">
        </div>
    </div>
    <div class="layui-inline">
        <label class="layui-form-label">描述截取:</label>
        <div class="layui-input-block">
            <input class="layui-input" min="1" name="sub_description" type="number" value="180">
        </div>
    </div>
</div>
<div class="layui-form-item">
    <label class="layui-form-label">推荐:</label>
    <div class="layui-input-block">
        <input name="level" title="荐1" type="checkbox" value="1">
        <input name="level" title="荐2" type="checkbox" value="2">
        <input name="level" title="荐3" type="checkbox" value="3">
        <input name="level" title="荐4" type="checkbox" value="4">
        <input name="level" title="荐5" type="checkbox" value="5">
        <input name="level" title="荐6" type="checkbox" value="6">
    </div>
</div>
<div class="layui-form-item">
    <label class="layui-form-label">时间格式:</label>
    <div class="layui-input-block">
        <input checked name="time" title="01-02 15:04" type="radio" value="01-02 15:04:05">
        <input name="time" title="2006-01-02 15:04" type="radio" value="2006-01-02 15:04:05">
        <input name="time" title="2006-01-02" type="radio" value="2006-01-02">
    </div>
</div>
<div class="layui-form-item">
    <div class="layui-inline">
        <label class="layui-form-label">条件:</label>
        <div class="layui-input-block">
            <input checked name="where" title="任意" type="radio" value="">
            <input name="where" title="有图片" type="radio" value="title_pic=1">
        </div>
    </div>
    <div class="layui-inline">
        <label class="layui-form-label">排序:</label>
        <div class="layui-input-block">
            <input checked name="order" title="最新" type="radio" value="0">
            <input name="order" title="最火" type="radio" value="1">
            <input name="order" title="ID升序" type="radio" value="2">
            <input name="order" title="ID降序" type="radio" value="3">
            <input name="order" title="随机" type="radio" value="4">
        </div>
    </div>
</div>`);
                                form.render();
                            }, yes: function (index, dom) {
                                let data = othis.formData(dom), range = '{{- range loop';
                                if (data.id !== "") {
                                    range += ' "' + data.id + '"';
                                } else {
                                    range += ' ""';
                                }
                                range += ' ' + data.order;
                                range += ' ' + data.limit;
                                if (Array.isArray(data.level)) {
                                    range += ' "level=' + data.level.join() + '"';
                                } else if (data.level) {
                                    range += ' "level=' + data.level + '"';
                                }
                                if (data['where']) {
                                    range += ` "` + data['where'] + `"`;
                                }
                                range += "}}";
                                elem.insertAt(`<ul>
    ` + range + `
    <li>
        {{- if .TitlePic -}}
        <!--标题图片-->
        <img alt="{{.Subtitle}}" src="{{.TitlePic}}" title="{{.Title}}">
        {{- end -}}
        <!--标题链接-->
        <a href="{{.Url}}">{{sub .Title ` + data['sub_title'] + `}}</a>
        <!--描述-->
        <p>{{sub .Description ` + data['sub_description'] + `}}</p>
        <time>{{date .Updated "` + data.time + `"}}</time>
    </li>
    {{- end}}
</ul>`);
                                layer.close(index);
                            },
                        });
                        break;
                    case "list":
                        elem.insertAt(`<ul>
    {{- range .List}}
    <li>
        {{- if .TitlePic -}}
        <!--标题图片-->
        <img alt="{{.Subtitle}}" src="{{.TitlePic}}" title="{{.Title}}">
        {{- end -}}
        <!--标题链接-->
        <a href="{{.Url}}">{{sub .Title 30}}</a>
        <!--描述-->
        <p>{{sub .Description 150}}</p>
        <time>{{date .Updated "2006-01-02 15:04"}}</time>
    </li>
    {{- end}}
</ul>`);
                        break;
                    case "tag":
                        elem.insertAt(`<ul>
    {{- range .Tags}}
    <li>{{.}}</li>
    {{- end}}
</ul>`);
                        break;
                    default:
                        elem.insertAt(write);
                }
            });
            $('[data-event="theme-func"]').off("click").on("click", function () {
                $.get("/cms/help", {}, function (text) {
                    othis.display({
                        content: `<textarea class="layui-textarea" style="margin:2%;height:92%;width:96%;" disabled></textarea>`,
                        success: function (dom) {
                            dom.find('textarea').val(text);
                        }
                    });
                });
            });
        }
    }

    let $ = layui.jquery, layer = layui.layer, form = layui.form, table = layui.table, slider = layui.slider, // 范围
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
        }, main = new Main();
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
                area: ["560px", "430px"], btn: "确定", fixed: true, content: othis.render(), success: function () {
                    form.render();
                    layui.element.render();
                    return true;
                }, yes: function (index, dom) {
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
        tpl: function (tplName) {
            if (!tplName) {
                tplName = $('select[name=tpl_name]').val();
            }
            // 渲染模板图片
            if (tplName) {
                let loading = main.loading();
                $.get('/site/theme', {system: $('select[name=system]').val(), tpl_name: tplName}, function (res) {
                    loading.close();
                    if (res.code === 0 && res.data.face) {
                        let ele = $('<img width="100%" height="100%" alt="" src="">').attr({
                            src: res.data["small_face"],
                            "data-src": res.data["face"],
                            alt: res.data.alias,
                            title: res.data["intro"],
                        });
                        ele.off("click").on("click", function () {
                            let $this = $(this);
                            $this.attr("src", $this.data("src"));
                            main.display({content: $this.prop("outerHTML")});
                        });
                        $('#theme').html(ele);
                    } else {
                        main.err(res.msg);
                    }
                });
            }
        }
    };
    // websocket
    main.ws = {
        display: function (options, callback) {
            options = $.extend({name: '', displaySelector: '#display', statusSelector: '#status'}, options || {});
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
                main.req($.extend({
                    url: '/record/reset', index: index, data: {tokens: tokens},
                }, options || {}));
            });
        },
    };
    main.reboot = {
        app: function () {
            layer.confirm("确定重启App?", {icon: 3, title: false}, function (index) {
                main.req({
                    url: "/system/reboot", data: {act: "botadmin"}, index: index, ending: function () {
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
                main.req({
                    url: "/system/reboot", data: {act: "reboot"}, index: index, ending: function () {
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
    }
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
                    url: "/plugin/lnmp", title: "安装web服务器", content: html, area: ['560px', 'auto'], tips: function () {
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
    }
    exports('main', main);
});