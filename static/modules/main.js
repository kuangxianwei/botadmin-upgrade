/*导出基本操作*/
layui.define(['form', 'slider', 'table', 'layer'], function (exports) {
    class Class {
        constructor() {
            // 整理对象
            this.tidyObj = function (obj) {
                return Object.prototype.toString.call(obj) === '[object Object]' ? obj : {};
            };
            // 获取URL指定参数的值
            this.getParam = function (key, url) {
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
                let chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz',
                    maxPos = chars.length,
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
            // 监控
            this.on = {
                del: function (selector) {
                    $('i[lay-event="del"]').click(function () {
                        let othis = $(this);
                        layer.confirm('确定删除该项吗?', {icon: 3, btn: ['确定', '取消']},
                            function (index) {
                                layer.close(index);
                                return selector ? $(othis).closest(selector).remove() : $(othis).parent().remove();
                            });
                    });
                },
                add: function (addFunc, delSelector) {
                    let othis = this;
                    $('[lay-event="add"]').click(function () {
                        addFunc();
                        othis.del(delSelector);
                    });
                }
            };
            // 复制
            this.copy = function () {
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
                        const self = document.querySelector(selector);
                        if (typeof value === "undefined") {
                            value = self.getAttribute("copy-text");
                        } else if (typeof value === "function") {
                            callback = value;
                            value = self.getAttribute("copy-text");
                        }
                        self.addEventListener('click', () => {
                            this.exec(value, callback);
                        });
                    };
                };
            }();
        }

        // ajax 请求
        req(options) {
            let othis = this;
            options = $.extend({type: 'POST', dataType: 'json'}, othis.tidyObj(options));
            if (typeof options.url !== 'string') {
                options.url = $('meta[name=current_uri]').attr('content');
            }
            // 加载中...
            let loading = layer.load(1, {shade: [0.7, '#000', true]}),
                isPost = options.type.toUpperCase() === 'POST';
            if (isPost) {
                options.headers = $.extend({'X-CSRF-Token': $('meta[name=csrf_token]').attr('content')}, othis.tidyObj(options.headers));
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
                        } else if (typeof options.ending === 'function') {
                            options.ending(res);
                        }
                        if (typeof options.tips === 'function') {
                            options.tips(res);
                        } else {
                            layer.msg(res.msg, {
                                icon: 1,
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
                        return othis.err(res.msg);
                }
            });
            request.fail(function (obj) {
                let msg = 'Fail: statusCode: ' + obj.status;
                if (obj.status === 403) {
                    msg = '登录超时或权限不够 statusCode: ' + obj.status;
                }
                return othis.err(msg);
            });
            request.always(function () {
                layer.close(loading);
            });
        }

        // 弹窗
        popup(options) {
            let othis = this;
            options = othis.tidyObj(options);
            let hasSubmit = typeof options.submit === 'string',
                success = typeof options.success === 'function' ? options.success : function () {
                    return true;
                },
                yes = typeof options.yes === 'function' ? options.yes : function () {
                    return true;
                };
            delete options.success;
            delete options.yes;
            options.submit = hasSubmit ? options.submit : othis.uuid();
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
                        }, cols = [];
                        if (typeof options.tips === 'function') {
                            reqOptions.tips = options.tips;
                        }
                        dom.find('.layui-form [name]').each(function (i, v) {
                            if (v.disabled === false && v.name && v.name !== 'cols' && cols.indexOf(v.name) === -1) {
                                cols.push(v.name);
                            }
                        });
                        reqOptions.data.cols = cols.join();
                        othis.req(reqOptions);
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
            let d = new Date(timestamp);   //创建一个指定的日期对象
            return d.getFullYear() + '-' + (d.getMonth() + 1) + '-' + d.getDate() + " " + d.getHours() + ":" + d.getMinutes() + ":" + d.getSeconds();
        }

        // 获取表单数据
        formData(elem) {
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
        }

        // 弹窗
        pop(options) {
            let obj = new Pop();
            $.extend(obj, options);
            obj.render();
        }
    }

    let $ = layui.jquery,
        layer = layui.layer,
        form = layui.form,
        table = layui.table,
        slider = layui.slider,
        // 范围
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
        },
        // 每
        per = function (a, b, min, max) {
            if (a < min || a > max) {
                a = '*';
            }
            if (b < 1) {
                b = 1;
            }
            return a + '/' + b;
        },
        // 判断是否为空
        isNotBlank = function (str) {
            return str !== undefined && str !== '';
        },
        main = new Class();

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
        let othis = this,
            data = form.val('cronSecForm'),
            dataType = data['type[0]'];
        if (
            'range' === dataType &&
            isNotBlank(data['rangeStart']) &&
            isNotBlank(data['rangeEnd'])
        ) {
            othis.spec[0] = range(data['rangeStart'], data['rangeEnd'], 0, 59);
        } else if (
            'per' === dataType &&
            isNotBlank(data['perFrom']) &&
            isNotBlank(data['perVal'])
        ) {
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
        let othis = this,
            data = form.val('cronMinForm'),
            dataType = data['type[1]'];
        if (
            'range' === dataType &&
            isNotBlank(data['rangeStart']) &&
            isNotBlank(data['rangeEnd'])
        ) {
            othis.spec[1] = range(data['rangeStart'], data['rangeEnd'], 0, 59);
        } else if (
            'per' === dataType &&
            isNotBlank(data['perFrom']) &&
            isNotBlank(data['perVal'])
        ) {
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
        let othis = this,
            data = form.val('cronHourForm'),
            dataType = data['type[2]'];
        if (
            'range' === dataType &&
            isNotBlank(data['rangeStart']) &&
            isNotBlank(data['rangeEnd'])
        ) {
            othis.spec[2] = range(data['rangeStart'], data['rangeEnd'], 0, 23);
        } else if (
            'per' === dataType &&
            isNotBlank(data['perFrom']) &&
            isNotBlank(data['perVal'])
        ) {
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
        let othis = this,
            data = form.val('cronDayForm'),
            dataType = data['type[3]'];

        if (
            'range' === dataType &&
            isNotBlank(data['rangeStart']) &&
            isNotBlank(data['rangeEnd'])
        ) {
            othis.spec[3] = range(data['rangeStart'], data['rangeEnd'], 1, 31);
        } else if (
            'per' === dataType &&
            isNotBlank(data['perFrom']) &&
            isNotBlank(data['perVal'])
        ) {
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
        let othis = this,
            data = form.val('cronMonthForm'),
            dataType = data['type[4]'];
        if (
            'range' === dataType &&
            isNotBlank(data['rangeStart']) &&
            isNotBlank(data['rangeEnd'])
        ) {
            othis.spec[4] = range(data['rangeStart'], data['rangeEnd'], 1, 12);
        } else if (
            'per' === dataType &&
            isNotBlank(data['perFrom']) &&
            isNotBlank(data['perVal'])
        ) {
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
        let othis = this,
            data = form.val('cronWeekForm'),
            dataType = data['type[5]'];
        if (
            'range' === dataType &&
            isNotBlank(data['rangeStart']) &&
            isNotBlank(data['rangeEnd'])
        ) {
            othis.spec[5] = range(data['rangeStart'], data['rangeEnd'], 0, 6);
        } else if (
            'per' === dataType &&
            isNotBlank(data['perFrom']) &&
            isNotBlank(data['perVal'])
        ) {
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
        let othis = this,
            elem = '<div class="layui-tab-item layui-show layui-form" lay-filter="cronSecForm">',
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
        let othis = this,
            elem = '<div class="layui-tab-item layui-form" lay-filter="cronMinForm">',
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
        let othis = this,
            elem = '<div class="layui-tab-item layui-form" lay-filter="cronHourForm">',
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
        let othis = this,
            elem = '<div class="layui-tab-item layui-form" lay-filter="cronDayForm">',
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
        let othis = this,
            elem = '<div class="layui-tab-item layui-form" lay-filter="cronMonthForm">',
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
        let othis = this,
            elem = '<div class="layui-tab-item layui-form" lay-filter="cronWeekForm">',
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
        elemMain += '<div class="layui-tab-content" style="width:450px;">' +
            othis.secondsElem() + // 秒
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
            main.confirm(othis.render(), {
                scroll: false,
                success: function () {
                    form.render();
                    layui.element.render();
                    return true;
                },
                done: function (dom) {
                    return othis.done(dom);
                }
            });
        });
        othis.elem.eventHandler = true;
    };

    // 自定义弹窗
    let Pop = function () {
        this.opacity = '0.7';
        this.content = '';
        this.scroll = true;
        this.confirm = true;
        this.area = ['auto', 'auto'];
        this.zIndex = 2147483000;
    };
    // 渲染dom后执行
    Pop.prototype.success = function () {
        return true;
    };
    // 完成后执行
    Pop.prototype.done = function () {
        return true;
    };
    // 无人如何都要执行
    Pop.prototype.always = function (dom) {
    };
    // 关闭
    Pop.prototype.close = function (dom) {
        this.id = null;
        dom.remove();
    };
    // 渲染
    Pop.prototype.render = function () {
        if ($('#layuicss-pop').length > 0) {
            return;
        }
        let insertElem = $('body').first();
        if (!insertElem) {
            this.always();
            return false;
        }
        let dom = $('<div id="layuicss-pop"></div>');
        insertElem.append(dom);
        dom.append('<style>#layuicss-pop{height:100%;width:100%}.pop-container{z-index:' + (this.zIndex + 1) + ';min-width:150px;min-height:100px;width:' + this.area[0] + ';height:' + this.area[1] + ';position:absolute;top:50%;left:50%;-webkit-transform:translate(-50%,-50%);transform:translate(-50%,-50%);padding:1.5em;background:#fff;border-radius:10px;box-shadow:-2px 2px 2px #888}.pop-container>div{overflow:' + (this.scroll ? 'scroll' : 'hidden') + ';height:100%;width:100%}.pop-container>.shade-cancel,.pop-container>.shade-confirm{z-index:' + (this.zIndex + 2) + ';height:28px;width:28px;line-height:28px;text-align:center;border-radius:14px;position:absolute}.pop-container>.shade-cancel{top:-17px;right:-17px;background-color:rgba(0,0,0,.8);box-shadow:-2px 2px 2px 2px #888}.pop-container>.shade-confirm{bottom:-30px;left:50%;-webkit-transform:translate(-50%,-50%);transform:translate(-50%,-50%);background-color:#0a6e85;box-shadow:-2px -2px 2px 2px #888}</style>');
        dom.append('<div class="layui-layer-shade" style="z-index:' + this.zIndex + ';background-color:rgb(0, 0, 0);opacity:' + this.opacity + ';"></div>');
        dom.append('<div class="pop-container"><a href="#" title="Cancel" class="shade-cancel"><svg viewBox="0 0 1024 1024"  xmlns="http://www.w3.org/2000/svg" width="28" height="28"><path d="M810.666667 273.493333L750.506667 213.333333 512 451.84 273.493333 213.333333 213.333333 273.493333 451.84 512 213.333333 750.506667 273.493333 810.666667 512 572.16 750.506667 810.666667 810.666667 750.506667 572.16 512z" fill="#fff"></path></svg></a>' + (this.confirm ? '<a href="#" title="Confirm" class="shade-confirm"><svg viewBox="0 0 1024 1024"  xmlns="http://www.w3.org/2000/svg" width="28" height="28"><path d="M448 864a32 32 0 0 1-18.88-6.08l-320-234.24a32 32 0 1 1 37.76-51.52l292.16 213.44 397.76-642.56a32 32 0 0 1 54.4 33.92l-416 672a32 32 0 0 1-21.12 14.4L448 864z" fill="#fff"></path></svg></a>' : '') + '<div>' + this.content + '</div></div>');
        this.success(dom);
        $(document).scroll(function () {
            let windowElem = $(window),
                documentElem = $(document),
                top = (windowElem.height() - dom.height()) / 2,
                left = (windowElem.width() - dom.width()) / 2,
                scrollTop = documentElem.scrollTop(),
                scrollLeft = documentElem.scrollLeft();
            dom.css({position: 'absolute', 'top': top + scrollTop, left: left + scrollLeft});
        });
        let othis = this;
        dom.find('.shade-cancel,.layui-layer-shade').click(function () {
            othis.always(dom);
            othis.close(dom);
        });
        dom.find('.shade-confirm').click(function () {
            if (othis.done(dom) !== false) {
                othis.always(dom);
                othis.close(dom);
            }
        });
    };
    // 信息提示框
    main.msg = function (msg, options) {
        main.pop($.extend({content: msg, scroll: false, confirm: false}, options || {}));
    };
    // 确认框
    main.confirm = function (msg, options) {
        main.pop($.extend({content: msg}, options || {}));
    };
    // 渲染
    main.render = {
        tpl: function (tplName) {
            // 渲染模板图片
            tplName = tplName || $('select[name=tpl_name]').val();
            if (tplName) {
                $.get('/site/theme', {
                    system: $('select[name=system]').val(),
                    tpl_name: tplName
                }, function (res) {
                    if (res.code === 0 && res.data.face) {
                        $('#theme').html('<img width="100%" height="100%" alt="' + res.data.alias + '" src="' + res.data.face + '" title="' + res.data.readme + '">');
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
            let w = new WebSocket((location.protocol === 'https:' ? 'wss://' : 'ws://') + location.host + '/ws/log');
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
        },
        log: function (name) {
            if (!name) {
                return false;
            }
            let w = new WebSocket((location.protocol === 'https:' ? 'wss://' : 'ws://') + location.host + '/ws/log');
            main.pop({
                confirm: false,
                scroll: false,
                content: '<div style="position:fixed;padding:6px;top:-15px;background-color:#ffffff;border-radius:8px 8px 0 0" id="log-status">状态: <strong style="color: red" title="0">未运行</strong></div><textarea class="layui-textarea layui-bg-black" style="color:white;height:100%" id="log-display"></textarea>',
                area: ['75%', '75%'],
                success: function (dom) {
                    w.onopen = function () {
                        w.send(name);
                    };
                    w.onmessage = function (e) {
                        if (e.data) {
                            let statusCode = e.data.substr(0, 1);
                            if (statusCode === '0') {
                                dom.find('#log-status').html('状态: <strong style="color:red" title="' + statusCode + '">未运行</strong>');
                            } else {
                                dom.find('#log-status').html('状态: <strong style="color: #22849b" title="' + statusCode + '">运行中...</strong>');
                            }
                            let el = dom.find('#log-display');
                            el.val(el.val() + e.data.substr(1)).focus().scrollTop(el[0].scrollHeight);
                        }
                    };
                },
                always: function () {
                    w.close();
                }
            });
        },
        info: function (name) {
            name = name || "show";
            let w = new WebSocket((location.protocol === 'https:' ? 'wss://' : 'ws://') + location.host + '/ws/log/info');
            main.pop({
                confirm: false,
                scroll: false,
                content: '<textarea class="layui-textarea layui-bg-black" style="color:white;height:100%" id="log-display"></textarea>',
                area: ['75%', '75%'],
                success: function (dom) {
                    w.onopen = function () {
                        w.send(name);
                    };
                    w.onmessage = function (e) {
                        if (e.data) {
                            let el = dom.find('#log-display');
                            el.val(e.data).focus().scrollTop(el[0].scrollHeight);
                        }
                    };
                },
                always: function () {
                    w.close();
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
    exports('main', main);
});

