/* jshint esversion: 6 */

/*导出基本操作*/
layui.define(function (exports) {
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
            if (this.indexOf(item) !== -1) {
                return true;
            }
        }
        return false;
    };
    // 填充关键词变量
    $(document).on('click', '[data-write]', function () {
        let el = $(this).parent().prev('textarea');
        (el.length > 0 ? el : $(this).parent().prev('div').find('textarea')).insertAt($(this).data('write'));
    });
    exports('init', {});
});
layui.define(['init', 'form', 'slider', 'table', 'layer'], function (exports) {
    Array.prototype.delete = function (v) {
        for (let i = 0; i < this.length; i++) {
            if (this[i] === v) {
                this.splice(i, 1);
                i--
            }
        }
        return this;
    };
    String.prototype.unescapeHTML = function () {
        return this.replace(/&#123;/g, '{')
            .replace(/&#125;/g, '}')
            .replace(/&#60;/g, '<')
            .replace(/&#62;/g, '>')
            .replace(/&#34;/g, '"')
    };
    const codeHTML = '<pre class="layui-code popup-code layui-code-view layui-box layui-code-dark"><ol class="layui-code-ol"></ol><span class="layui-code-copy"><i class="layui-icon layui-icon-file-b" title="复制"></i></span></pre>',
        $ = layui.jquery, layer = layui.layer, form = layui.form, table = layui.table, slider = layui.slider;

    class Cron {
        constructor(selector) {

            this.elem = $(selector); // 输入点例如：input[name=spec]
            this.tabs = [
                {name: 'second', alias: '秒', min: 0, max: 59, value: '*', values: []},
                {name: 'minute', alias: '分', min: 0, max: 59, value: '*', values: []},
                {name: 'hour', alias: '时', min: 0, max: 23, value: '*', values: []},
                {name: 'day', alias: '日', min: 1, max: 31, value: '?', values: []},
                {name: 'month', alias: '月', min: 1, max: 12, value: '*', values: []},
                {name: 'week', alias: '周', min: 0, max: 6, value: '?', values: []}
            ];
            $.each(this.trimArray(this.elem.val().split(' ')), (i, v) => {
                if (i < 6) {
                    this.tabs[i].value = v;
                }
            });
            for (let i = 0; i < this.tabs.length; i++) {
                this.tabs[i] = this.tidy(this.tabs[i]);
            }
        }

        trimArray(arr) {
            for (let i = 0; i < arr.length; i++) {
                arr[i] = arr[i].trim();
                if (arr[i] === '') {
                    arr.splice(i, 1);
                    i--
                }
            }
            return arr;
        };

        tidy(field) {
            if (field.value === '?' || field.value === '*') {
                field.checked = 'all';
                return field;
            }
            if (field.value.indexOf('/') !== -1) {
                field.checked = 'per';
                field.values = this.trimArray(field.value.split('/'));
                if (field.values.length < 2) {
                    field.value = '*/' + field.max;
                    field.values = ['*', field.max];
                    return field;
                }
                let n = parseInt(field.values[0]);
                if (!isNaN(n) && (n > field.max || n < field.min)) {
                    field.values[0] = '*'
                }
                if (field.values[1] < '1') {
                    field.values[1] = field.max;
                }
                return field;
            }
            if (field.value.indexOf('-') !== -1) {
                field.checked = 'limit';
                field.values = this.trimArray(field.value.split('-')).sort();
                for (let i = 0; i < field.values.length; i++) {
                    if (isNaN(parseInt(field.values[i])) || field.values[i] < field.min.toString() || field.values[i] > field.max.toString()) {
                        field.values.splice(i, 1);
                        i--
                    }
                }
                if (field.values.length < 2) {
                    field.value = field.min + '-' + field.max;
                    field.values = [field.min, field.max];
                }
                return field;
            }
            if (!isNaN(parseInt(field.value)) || field.value.indexOf(',') !== -1) {
                field.checked = 'assign';
                field.values = field.value.split(',');
                for (let j = 0; j < field.values.length; j++) {
                    if (isNaN(parseInt(field.values[j]))) {
                        field.values.splice(j, 1);
                        j--
                    }
                }
                if (field.values.length === 0) {
                    field.values = [field.min];
                }
                return field;
            }
            field.checked = 'all';
            field.value = '*';
            return field;
        };

        buildHTML(field) {
            let html = '<div class="layui-tab-item layui-form' + (field.name === 'second' ? ' layui-show' : '') + '" lay-filter="' + field.name + '">';
            html += '<div><input name="' + field.name + '.type" title="每' + field.alias + '" type="radio" value="all"' + (field.checked === 'all' ? ' checked' : '') + '></div>';
            html += '<div><input name="' + field.name + '.type" title="范围" type="radio" value="limit"' + (field.checked === 'limit' ? ' checked' : '') + '><div class="cron-input-mid">最小</div><input placeholder="' + field.min + '" class="cron-input" value="' + (field.checked === 'limit' ? field.values[0] : '') + '" name="' + field.name + '.begin" type="number" min="' + field.min + '" max="' + field.max + '"><div class="cron-input-mid">-</div><input placeholder="' + field.max + '" class="cron-input"  value="' + (field.checked === 'limit' ? field.values[1] : '') + '" name="' + field.name + '.end" type="number" min="' + field.min + '" max="' + field.max + '"><div class="cron-input-mid">最大</div><span class="cron-tips">(' + field.min + '-' + field.max + ')</span></div>';
            html += '<div><input name="' + field.name + '.type" title="依照" type="radio" value="per"' + (field.checked === 'per' ? ' checked' : '') + '><div class="cron-input-mid">从</div><input placeholder="*" class="cron-input" value="' + (field.checked === 'per' ? field.values[0] : '') + '" name="' + field.name + '.from" type="text" pattern="^(\\*|[' + field.min + '-' + field.max + '][' + field.min + '-' + field.max + '])$"><div class="cron-input-mid">' + field.alias + '开始，每</div><input class="cron-input" placeholder="' + field.max + '" min="' + field.min + '" value="' + (field.checked === 'per' ? field.values[1] : '') + '" name="' + field.name + '.per" type="number"><div class="cron-input-mid">' + field.alias + '执行一次</div><span class="cron-tips">(' + field.min + '-' + field.max + ')</span></div>';
            html += '<div><input name="' + field.name + '.type" title="指定" type="radio" value="assign"' + (field.checked === 'assign' ? ' checked' : '') + '>';
            for (let i = field.min; i < field.max + 1; i++) {
                html += '<input lay-skin="primary" name="' + field.name + '.assign[' + i + ']" title="' + i + '" type="checkbox" value="' + i + '"' + (field.checked === 'assign' && field.values.includes(i.toString()) ? ' checked' : '') + '>'
            }
            return html + '</div></div>';
        };

        getHTML() {
            // box大盒子元素
            let othis = this, boxElem = $('<div class="layui-tab layui-tab-card"></div>'), // 标题 元素
                titleElem = $('<ul class="layui-tab-title"></ul>'), // 主体内容元素
                bodyElem = $('<div class="layui-tab-content"></div>');
            // 标题元素添加到盒子里面
            boxElem.append(titleElem);
            // 主体内容元素添加到盒子里面
            boxElem.append(bodyElem);
            // 渲染标题
            layui.each(this.tabs, function (i, field) {
                titleElem.append('<li' + (i === 0 ? ' class="layui-this">' : '>') + field.alias + '</li>');
                bodyElem.append(othis.buildHTML(field));
            });
            return $('<div class="layui-cron"></div>').html(boxElem).prop('outerHTML');
        };

        getForm(arr) {
            let form = {assign: []};
            for (let i = 0; i < arr.length; i++) {
                arr[i].value = arr[i].value.trim();
                let name = arr[i].name.split('.')[1],
                    n = +(arr[i].value);
                if (name.indexOf('assign[') === 0 && arr[i].value) {
                    form.assign.push(n)
                } else {
                    switch (name) {
                        case 'begin':
                        case 'end':
                        case 'per':
                            form[name] = n;
                            break;
                        case 'from':
                            if (arr[i].value === '*') {
                                form[name] = arr[i].value
                            } else {
                                form[name] = n
                            }
                            break;
                        default:
                            form[name] = arr[i].value
                    }
                }
            }
            return form;
        }

        error(dom, n) {
            layer.msg('参数超出范围或开始和结尾参数相等', {icon: 2});
            dom.find('.layui-tab-title>li:nth-child(' + n + ')').click();
            return false;
        }

        exceed(n, min, max) {
            return n < min || n > max;
        }

        done(dom) {
            let specs = [];
            for (let i = 0; i < this.tabs.length; i++) {
                let config = this.tabs[i],
                    form = this.getForm(dom.find('.layui-form[lay-filter=' + config.name + '] [name]').serializeArray());
                switch (form.type) {
                    case 'all':
                        specs.push(config.name === 'week' || config.name === 'day' ? '?' : '*');
                        break;
                    case 'limit':
                        if (form.begin > form.end) {
                            let end = form.end;
                            form.end = form.begin;
                            form.begin = end;
                        }
                        let limit = [form.begin, form.end];
                        if (form.begin === form.end || this.exceed(form.begin, config.min, config.max) || this.exceed(form.end, config.min, config.max)) {
                            return this.error(dom, i + 1);
                        }
                        specs.push(limit.join('-'));
                        break;
                    case 'per':
                        if (form.from !== '*' && this.exceed(form.from, config.min, config.max)) {
                            return this.error(dom, i + 1);
                        }
                        specs.push(form.from + '/' + form['per']);
                        break;
                    case 'assign':
                        for (let j = 0; j < form.assign.length; j++) {
                            if (this.exceed(form.assign[j], config.min, config.max)) {
                                return this.error(dom, i + 1);
                            }
                        }
                        specs.push(form.assign.join(','));
                        break;
                }
            }
            if (specs[5] !== '?' && specs[3] !== '?') {
                layer.msg('不支持周参数和日参数同时存在', {icon: 2, time: 3000});
                return false;
            }
            this.elem.val(specs.join(' '));
            return true;
        }
    }

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
                othis.controlElem.on('blur', function () {
                    othis.add(this.value.trim());
                    $(this).val("");
                });
                othis.del(othis.boxElem);
            };
        }
    }

// 主要
    class Main {

        constructor() {
            this.searchRendered = false;
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
            let T = Object.prototype.toString;
            this.isObject = function (obj) {
                return T.call(obj) === '[object Object]';
            };
            this.isString = function (obj) {
                return T.call(obj) === '[object String]';
            };
            this.isFunction = function (obj) {
                return T.call(obj) === '[object Function]';
            };
            this.isArray = function (obj) {
                return T.call(obj) === '[object Array]';
            };
            // 判断是密码column
            this.isPassword = function (column) {
                return column.hasSuffix('password') || column.hasSuffix('passwd') || column.hasSuffix('password2')
            };
            this.logPreffix = layui.url().pathname.join('_');
            // 设置cols
            this.setCols = function (data, dom) {
                dom = this.isObject(dom) ? dom : $('.layui-form');
                if (data && !data.cols && dom.length > 0) {
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
            this.history = function (datalistName) {
                datalistName = datalistName || 'searchHistories';
                let val = $('input[list="' + datalistName + '"]').val();
                if (val) {
                    let historiesName = datalistName + "_" + this.logPreffix;
                    let histories = JSON.parse(localStorage.getItem(historiesName)) || [];
                    if (histories.indexOf(val) === -1) {
                        histories.unshift(val);
                        localStorage.setItem(historiesName, JSON.stringify(histories));
                        let datalistEl = $('#' + datalistName).empty();
                        $.each(histories, function () {
                            datalistEl.append('<option value="' + this + '"></option>');
                        });
                        return true
                    }
                }
                return false;
            };
            let othis = this;
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
                },
                add: function (addFunc, delSelector) {
                    let othis = this;
                    $('[lay-event="add"]').off('click').on('click', function () {
                        addFunc();
                        othis.del(delSelector);
                    });
                },
                search: function (filter, options) {
                    if (othis.searchRendered) return false;
                    othis.searchRendered = true;
                    let searchCommit = $('[lay-filter=search]');
                    if (searchCommit.length === 0) {
                        return false;
                    }
                    if (othis.isObject(filter)) options = filter;
                    if (!othis.isString(filter)) filter = 'table-list';
                    form.on('submit(search)', function (data) {
                        let cols = [];
                        $.each(data.field, function (k, v) {
                            let col = k.split('.')[0];
                            if (v && col !== 'cols' && cols.indexOf(col) === -1) {
                                cols.push(col);
                            } else {
                                delete data.field[k];
                            }
                        });
                        data.field.cols = cols.join(",");
                        if (!data.field.cols) {
                            return window.location.reload();
                        }
                        if ($('table[lay-filter=' + filter + ']').length > 0) {
                            table.reload(filter, {
                                where: $.extend(data.field, options || {}), page: {curr: 1}
                            });
                        }
                        return false;
                    });
                    // 监控select
                    form.on('select(search-select)', function () {
                        searchCommit.click();
                    });
                    $('.table-search,[lay-event=search]').on('keydown', 'input', function (event) {
                        if (event.keyCode === 13) {
                            searchCommit.click();
                        }
                    });
                    if ($('#searchHistories').length === 0) {
                        $('input[type=search]').attr("list", "searchHistories").after('<datalist id="searchHistories"></datalist>');
                        searchCommit.on('click', function () {
                            othis.history('searchHistories');
                        });
                    }
                    return true;
                },
            };
            this.reset = {
                log: function (prefix, ids, options) {
                    if (othis.isObject(prefix)) {
                        options = prefix;
                        prefix = othis.logPreffix;
                    } else if (Array.isArray(prefix)) {
                        ids = prefix;
                        prefix = othis.logPreffix;
                    } else if (othis.isObject(ids)) {
                        options = ids;
                    }
                    prefix = prefix || othis.logPreffix;
                    let tokens = prefix;
                    if (Array.isArray(ids)) {
                        for (let i = 0; i < ids.length; i++) {
                            ids[i] = prefix + '.' + ids[i];
                        }
                        if (ids.length === 0) {
                            ids.push(prefix + '.0');
                        }
                        tokens = ids.join();
                    }
                    layer.confirm('清空日志记录? Tokens: <br/>' + tokens, function (index) {
                        othis.request($.extend({
                            url: '/record/reset',
                            index: index,
                            data: {tokens: tokens}
                        }, options || {}));
                    });
                },
            };
            this.copyHTML = function (value, success, error) {
                return this.copy(value.unescapeHTML(), success, error)
            };
            // 复制
            this.copy = function (value, success, error) {
                if (navigator.clipboard && navigator.permissions) {
                    navigator.clipboard.writeText(value).then(() => {
                        if (typeof success === 'function') return success(value);
                        layer.msg('复制成功', {icon: 1});
                    }).catch(() => {
                        if (typeof error === 'function') return error(value);
                        layer.msg('复制失败', {icon: 2});
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
                        layer.msg('复制成功', {icon: 1});
                    } catch (e) {
                        console.error(e);
                        if (typeof error === 'function') return error(value);
                        layer.msg('复制失败', {icon: 2});
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


        init() {
            // 定时
            let othis = this;
            $(document).on('click', '[lay-event=crontab]', function (e) {
                othis.crontab($(this).attr('data-value'));
                e.stopPropagation();
            });
            $(document).on('click', 'img', function (e) {
                othis.preview($(this).data('src'));
                e.stopPropagation();
            });
        }

        get(url, data, callback) {
            if (this.isFunction(data)) {
                callback = data;
                data = null;
            }
            let loading = this.loading();
            return $.get(url, data).always(function () {
                loading.close()
            }).done(callback);
        };

        //  filter=table-list
        table(filter, render, active) {
            let othis = this, cols = [], options = {};
            if (othis.isObject(filter)) {
                options = filter;
                active = render;
            } else if (othis.isArray(filter)) {
                cols = filter;
                active = render;
            } else if (othis.isObject(render)) {
                options = render
            } else if (othis.isArray(render)) {
                cols = render
            }
            if (!othis.isString(filter)) filter = 'table-list';
            active = $.extend({
                switch: function (obj, ids) {
                    let $this = $(this), field = $this.attr('data-field');
                    if (!field) return layer.msg('缺少属性data-field', {icon: 2});
                    // 多选操作
                    if (othis.isArray(ids)) {
                        if (ids.length === 0) return layer.msg("最少需要选中一条！", {icon: 2});
                        let data = {ids: ids.join(), cols: field};
                        data[field] = $this.attr('data-value') === 'true';
                        return othis.request({url: URL + '/modify', data: data, done: 'table-list'});
                    }
                    // 单选操作
                    let enabled = !!$this.find('div.layui-unselect.layui-form-onswitch').size(),
                        data = {id: obj.data.id, cols: field};
                    data[field] = enabled;
                    if (obj.data.spec) {
                        data.spec = obj.data.spec;
                        data.cols = field + ',spec';
                    }
                    othis.request({
                        url: URL + "/modify",
                        data: data,
                        error: function () {
                            $this.find('input[type=checkbox]').prop('checked', !enabled);
                            form.render('checkbox');
                        }
                    });
                },
                del: function (obj, ids) {
                    if (othis.isArray(obj.data)) {
                        if (obj.data.length === 0) {
                            layer.msg("最少需要选中一条！", {icon: 2});
                            return false;
                        }
                        obj.data = {ids: ids.join()};
                    }
                    layer.confirm('删除后不可恢复，确定删除吗？', {icon: 3}, function (index) {
                        othis.request({
                            url: URL + '/del',
                            data: obj.data,
                            index: index,
                            done: filter,
                        });
                    });
                },
                export: function (obj, ids) {
                    window.open(encodeURI(URL + '/export?ids=' + (othis.isArray(ids) ? ids.join() : '')));
                },
                import: function () {
                    $('#upload').click();
                },
                log: function (obj, ids) {
                    othis.ws.log(($(this).data('value') || othis.logPreffix) + '.' + (othis.isArray(ids) ? '0' : obj.data.id));
                },
                resetLog: function (obj, ids) {
                    othis.reset.log($(this).data('value') || othis.logPreffix, ids);
                },
                truncate: function () {
                    layer.confirm('清空全部数据不可恢复，确定清空？', function (index) {
                        othis.request({
                            url: URL + '/truncate', index: index, done: filter,
                        });
                    });
                },
                crontab: function () {
                    othis.crontab($(this).attr('data-value'));
                },
                copy: function (obj, ids) {
                    if (!othis.isArray(ids)) {
                        let field = $(this).data('field');
                        if (othis.isPassword(field)) {
                            othis.request({
                                url: '/tools/decrypt',
                                data: {password: obj.data[field]},
                                done: function (res) {
                                    othis.copy(res.msg);
                                    return false
                                }
                            })
                        } else {
                            othis.copy(obj.data[field]);
                        }
                    }
                },
            }, active || {});
            let tab = table.render($.extend({
                headers: {'X-CSRF-Token': CSRF_TOKEN},
                method: 'post',
                elem: '#' + filter,
                toolbar: '#toolbar',
                url: URL,
                cols: cols,
                page: true,
                limit: 10,
                limits: [10, 20, 50, 100, 500, 900],
                text: '对不起，加载出现异常！'
            }, options || {}));
            // 监听工具条
            table.on('tool(' + filter + ')', function (obj) {
                active[obj.event] && active[obj.event].call(this, obj);
            });
            //头工具栏事件
            table.on('toolbar(' + filter + ')', function (obj) {
                obj.data = table.checkStatus(obj.config.id).data;
                let ids = [];
                for (let i = 0; i < obj.data.length; i++) {
                    ids[i] = obj.data[i].id;
                }
                active[obj.event] && active[obj.event].call(this, obj, ids);
            });
            this.on.search(filter);
            return {table: tab, active: active}
        }

        upload(filter, options) {
            if (this.isObject(filter)) options = filter;
            if (!this.isString(filter)) filter = 'table-list';
            if ($('#upload').length === 0) {
                $('body').append('<div class="layui-hide" id="upload"></div>');
            }
            return layui.upload.render($.extend({
                headers: {'X-CSRF-Token': CSRF_TOKEN},
                elem: '#upload',
                url: URL + '/import',
                accept: 'file',
                before: function () {
                    layer.load(); //上传loading
                },
                done: function (res) {
                    layer.closeAll('loading'); //关闭loading
                    if (res.code === 0) {
                        layer.msg(res.msg);
                        if ($('#' + filter).length > 0) table.reload(filter);
                    } else {
                        layer.alert(res.msg, {icon: 2});
                    }
                },
            }, options || {}));
        };

        download(filename) {
            window.open('/file/download?filename=' + encodeURIComponent(filename));
        }

        // ajax 请求
        request(options, dom) {
            options = $.extend({type: 'POST', dataType: 'json', url: URL}, options);
            options.headers = $.extend({'X-CSRF-Token': CSRF_TOKEN}, options.headers || {});
            let othis = this, reloadOptions = $.extend({}, options), // 加载中...
                loading = layer.load(1, {shade: [0.7, '#000', true]});
            othis.setCols(options.data, dom);
            if (options.data) $.each(options.data, function (k, v) {
                if (v && othis.isPassword(k)) {
                    options.data[k] = encrypt.encrypt(v);
                }
            });
            let request = $.ajax(options);
            request.done(function (res) {
                switch (res.code) {
                    case 0:
                        if (typeof options.done === 'string') {
                            table.reload(options.done);
                        } else if (typeof options.done === 'function' && options.done(res) === false) {
                            return false;
                        }
                        if (res.action === 'code') {
                            othis.code(res.msg, {area: ['50%', '30%']});
                        } else {
                            layer.msg(res.msg, {icon: 1, shade: [0.6, '#000', true]});
                        }
                        break;
                    case 1001:
                    case 403:
                        window.location.replace('/auth/login?next=' + URL);
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
                if (options.index) layer.close(options.index);
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
            let hasSubmit = typeof options.submit === 'string', success = options.success, yes = options.yes,
                error = options.error;
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
                            url: options.url || obj.field.url || URL,
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
                }, yes: function (index, dom) {
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
                let field = othis.tidyObj(v), elem = $(field.elem);
                if (typeof field.value === 'undefined') {
                    let val = elem.siblings('input[name]').first().val() || '';
                    if (field.range) {
                        field.value = [];
                        $.each(val.split('-'), function (index, value) {
                            field.value[index] = parseInt(value) || 0;
                        });
                    } else {
                        field.value = parseInt(val) || 0;
                    }
                }
                if (!othis.isFunction(field.change)) {
                    field.change = function (value) {
                        if (field.range) {
                            elem.siblings('input[name]').first().val(value[0] + '-' + value[1]);
                        } else {
                            elem.siblings('input[name]').first().val(value);
                        }
                    }
                }
                slider.render($.extend({value: 0, min: 0, max: 10, input: true}, field));
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

        // 构造Code HTML
        __codeBuild(text) {
            let html = '';
            $.each(text.split('\n'), function () {
                html += '<li>' + layui.util.escape(this) + '</li>'
            });
            return html
        }

        __codeInit(dom, text, isLog) {
            const elem = dom.find('pre.popup-code'), othis = this;
            if (text) {
                elem.attr('data-value', text);
                elem.find('ol.layui-code-ol').html(othis.__codeBuild(text));
            }
            elem.parent().css({'overflow': 'hidden', 'padding': '0 10px 10px 10px'});
            if (isLog) {
                elem.parent().before('<div class="layer-status"><strong style="color:red" title="false">未运行</strong></div>');
            }
            dom.find('pre.popup-code>.layui-code-copy').off('click').on('click', function () {
                othis.copy(elem.attr('data-value') || '');
            });
            return elem;
        }

        // 弹窗展示 code
        code(text, options) {
            if (!this.isString(text)) return;
            let othis = this;
            this.display($.extend(true, {
                content: codeHTML,
                success: function (dom) {
                    othis.__codeInit(dom, text);
                },
            }, options || {}));
        }

        // tags
        // options {value:"tag1,tag2",inputElem:$('input[name=tags]'),boxElem:$('#tags-box')}
        tags(options) {
            let tags = new Tags();
            $.extend(tags, options);
            tags.render();
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

        // 获取目录
        dirname(path) {
            return path.substr(0, path.lastIndexOf('/'));
        }

        // 获取图片src
        getSrc(s) {
            if (/^(?:\/file\/download\?filename=|https?:\/\/)/.test(s)) {
                return s;
            }
            return '/file/download?filename=' + encodeURIComponent(s);
        }

        // 获取图片列表
        getPreviewList(elem, attrName) {
            if (elem === false) return false;
            let re = new RegExp(/\.(?:jpg|jpeg|gif|bmp|png)$/);
            attrName = attrName || 'title';
            let othis = this;
            (elem ? $(elem) : $('[data-field=name] [title]')).each(function () {
                let src = $(this).attr(attrName);
                if (src) {
                    src = othis.getSrc(src);
                    if (!othis.previewList.includes(src) && re.test(src)) {
                        othis.previewList.push(src);
                    }
                }
            });
            return this.previewList;
        }

        // 预览图片
        preview(src, elem, attrName) {
            if (!src || $('.preview-images-mask').length > 0) return false;
            src = this.getSrc(src);
            let othis = this, $body = $('body'),
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
                $('#preview-images').css({
                    width: config.currentWidth,
                    height: config.currentHeight,
                    top: config.currentTop,
                    left: config.currentLeft,
                    display: 'inline',
                    transform: 'rotate(' + config.rotate + 'deg)',
                    opacity: 1,
                    transition: 'all 400ms'
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
                            if (config.scale === 3 && index === 2 || config.scale === .2 && index === 3) return layer.msg(config.scale >= 1 ? "图像放大，已达到最大尺寸。" : "图像缩小，已达到最小尺寸。");
                            config.scale = (index === 2 ? Math.round(10 * (config.scale + .4)) : Math.round(10 * (config.scale - .4))) / 10;
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
                    let images = $(this), $mask = $(".preview-images-mask"), preview = $mask.offset(),
                        diffX = e.clientX - preview.left, diffY = e.clientY - preview.top;
                    $mask.on('mousemove', (function (e) {
                        let offsetX = e.clientX - preview.left - diffX, offsetY = e.clientY - preview.top - diffY,
                            rotate = Math.abs(config.rotate / 90),
                            previewW = rotate % 2 === 0 ? config.previewWidth : config.previewHeight,
                            previewH = rotate % 2 === 0 ? config.previewHeight : config.previewWidth, left, top;
                        if (config.currentWidth > previewW) {
                            let max_left = previewW - config.currentWidth;
                            (left = config.currentLeft + offsetX) > 0 ? left = 0 : left < max_left && (left = max_left), config.currentLeft = left
                        }
                        if (config.currentHeight > previewH) {
                            let max_top = previewH - config.currentHeight;
                            (top = config.currentTop + offsetY) > 0 ? top = 0 : top < max_top && (top = max_top), config.currentTop = top
                        }
                        config.currentHeight > previewH && config.currentTop <= 0 && config.currentHeight - previewH <= config.currentTop && (config.currentTop -= offsetY), images.css({
                            left: config.currentLeft, top: config.currentTop
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
                            left < 0 ? left = 0 : left > window.innerWidth - drag.width() && (left = window.innerWidth - drag.width()), top < 0 ? top = 0 : top > window.innerHeight - drag.height() && (top = window.innerHeight - drag.height()), drag.css({
                                left: left, top: top, margin: 0
                            })
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
            let othis = this, system = $('#site select[name=system]').val() || $('select[name=system]').val();
            // 渲染模板图片
            if (tplName && system) {
                let loading = this.loading();
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
                        othis.error(res.msg);
                    }
                });
            }
        }

        // 信息提示框
        msg(msg, options) {
            this.display($.extend({
                type: 0, area: "auto", content: msg, success: function (dom) {
                    dom.find("textarea").css("border-radius", "10px");
                }
            }, options || {}));
        };

        newWS() {
            return new WebSocket((window.location.protocol === 'https:' ? 'wss://' : 'ws://') + window.location.host + '/ws');
        };

        // 定时任务列表
        crontab(token, options) {
            this.open($.extend({
                type: 2,
                title: false,
                btn: false,
                area: ['800px', '600px'],
                maxmin: false,
                content: '/crontab?search=' + (token ? token : ''),
            }, options || {}));
        };

        // 定时任务规则
        cron() {
            let othis = this;
            layui.link('/static/style/cron.css');
            $.each(arguments, function (i, selector) {
                if (selector) {
                    // 绑定聚焦事件
                    $(selector).focus(function () {
                        $(this).off('dblclick').on('dblclick', function () {
                            let cron = new Cron(selector);
                            othis.display({
                                area: ['560px', '430px'],
                                btn: '确定',
                                fixed: true,
                                content: cron.getHTML(),
                                success: function (dom) {
                                    form.render();
                                    layui.element.render();
                                    dom.find('input').focus(function () {
                                        $(this).siblings('input[type=radio]').prop('checked', true);
                                        form.render('radio');
                                    });
                                    dom.find('.layui-form-checkbox').on('click', function () {
                                        $(this).parent().find('input[type=radio]').prop('checked', true);
                                        form.render('radio');
                                    });
                                    return true;
                                },
                                yes: function (index, dom) {
                                    if (cron.done(dom)) {
                                        layer.close(index)
                                    }
                                }
                            });
                        });
                    });
                }
            });
        };

        logout() {
            layui.view.exit();
            window.location.href = '/auth/logout?next=' + window.location.pathname;
        };

        // 暂停函数
        sleep(d) {
            for (let t = Date.now(); Date.now() - t <= d;) {
            }
        };

        checkLNMP() {
            if (localStorage.getItem("checkLNMP") === '1') {
                return
            }
            let othis = this;
            $.get("/plugin/lnmp", {}, function (html) {
                if (html) {
                    if (html === 'lnmp.0') {
                        othis.ws.log("lnmp.0");
                        return false;
                    }
                    othis.popup({
                        url: "/plugin/lnmp",
                        title: "安装web服务器",
                        content: html,
                        area: ['560px', 'auto'],
                        btn: ['提交', '取消', '不再提示'],
                        btn3: function (index) {
                            layer.confirm('以后不会再弹出提示框,清除浏览器缓存会再次弹出', function (index2) {
                                localStorage.setItem('checkLNMP', '1');
                                layer.close(index);
                                layer.close(index2);
                            });
                            return false;
                        },
                        tips: function () {
                            othis.ws.log("lnmp.0");
                        }
                    });
                }
            });
        };

        webssh(options) {
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

    }

    let main = new Main();
    main.init();
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
        }, theme: function () {
            //改变模板目录列表
            form.on('select(system)', function (obj) {
                $('#theme-shop').attr("lay-href", "/themes/shop?driver=" + obj.value);
                $.get('/site/admin', {system: obj.value}, function (html) {
                    $('#site input[name=admin_dir]').val(html);
                });
                $.get('/site/tpl', {
                    system: obj.value, tpl_name: $('#site select[name=tpl_name]').val()
                }, function (html) {
                    $('#site div[lay-filter=tpl_name]').html(html);
                    form.render();
                    $('#theme').empty();
                    main.displayTheme();
                });
                if (obj.value === 'cms') {
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
        log: function (token, callback) {
            if (main.isFunction(token)) {
                callback = token;
                token = main.logPreffix + ".0";
            } else if (!token) token = main.logPreffix + ".0";
            let ws = main.newWS();
            main.display({
                area: ['75%', '75%'],
                content: codeHTML,
                success: function (dom) {
                    let elem = main.__codeInit(dom, '', true),
                        statusElem = dom.find('.layer-status');
                    ws.onopen = function () {
                        ws.send(JSON.stringify({action: 'log', token: token}));
                    };
                    ws.onmessage = function (e) {
                        let obj = JSON.parse(e.data);
                        if (obj.error) {
                            if (obj.error) main.error(obj.error);
                            return ws.close();
                        }
                        if (obj.running) {
                            statusElem.html('<strong title="true">运行中...</strong>');
                        } else {
                            statusElem.html('<strong style="color:red" title="false">未运行</strong>');
                        }
                        let data = elem.attr('data-value') || '';
                        obj.data = data + obj.data;
                        elem.attr('data-value', obj.data);
                        let contentElem = elem.find('ol.layui-code-ol');
                        contentElem.html(main.__codeBuild(obj.data))
                            .scrollTop(contentElem[0].scrollHeight);
                    };
                },
                end: function () {
                    ws.close();
                    typeof callback === 'function' && callback();
                }
            });
        },
        scanned: function (path) {
            if (typeof path !== 'string') {
                return main.error('请输入扫描路径');
            }
            let ws = main.newWS();
            ws.onerror = function (e) {
                layer.msg(JSON.stringify(e), {icon: 2});
            };
            main.open({
                title: '扫描检测结果',
                content: `<div class="layui-card"><div class="layui-card-header"><label class="layui-form-label">扫描时间:</label><div class="layui-form-mid layui-word-aux" data-name="updated"></div><label class="layui-form-label">总文件:</label><div class="layui-form-mid layui-word-aux" data-name="total"></div><label class="layui-form-label">已扫描:</label><div class="layui-form-mid layui-word-aux" data-name="scanned"></div><label class="layui-form-label">疑是病毒:</label><div class="layui-form-mid layui-word-aux" data-name="detected"></div></div><div class="layui-card-body"><table class="layui-hide" id="table-scanned" lay-filter="table-scanned"></table></div></div>`,
                success: function (dom) {
                    // 已知数据渲染
                    let inst = table.render({
                        elem: '#table-scanned', cols: [[ //标题栏
                            {
                                field: 'path',
                                title: '路径',
                                event: 'path',
                                style: 'cursor:pointer;color:#01aaed;font-weight:bold',
                                sort: true
                            }, {field: 'descr', title: '扫描结果', width: 200}, {
                                field: 'lineno', title: '线路', width: 120
                            }, {
                                title: '操作',
                                width: 120,
                                align: 'center',
                                fixed: 'right',
                                toolbar: '<div class="layui-btn-group"><button class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del"><i class="layui-icon layui-icon-delete"></i></button></div>'
                            }]], data: [], page: true, // 是否显示分页
                        limits: [10, 20, 30], limit: 10, text: {none: '正在扫描中...'},
                    });
                    table.on('tool(table-scanned)', function (obj) {
                        switch (obj.event) {
                            case 'path':
                                let loading = main.loading();
                                $.get('/file/editor', {path: obj.data.path, pure: true}).always(function () {
                                    loading.close();
                                }).done(function (html) {
                                    if (typeof html === 'object') {
                                        return main.error(html.msg + " 病毒文件已经删除，请重新扫描");
                                    }
                                    main.popup({
                                        url: '/file/editor', title: '修改文件', content: html
                                    });
                                });
                                break;
                            case 'del':
                                layer.confirm('删除请慎重！删除后不可恢复,确定删除？', {
                                    icon: 3, btn: ['确定', '取消'] //按钮
                                }, function (index) {
                                    layer.close(index);
                                    main.request({
                                        url: '/file/del',
                                        data: {path: main.dirname(obj.data.path), names: obj.data.path},
                                        done: function () {
                                            obj.del();
                                        }
                                    });
                                });
                                break;
                        }
                    });
                    ws.onopen = function () {
                        ws.send(JSON.stringify({action: 'scanned', token: path}));
                    };
                    ws.onmessage = function (e) {
                        let obj = JSON.parse(e.data);
                        if (obj.error) {
                            if (obj.error) main.error(obj.error);
                            return ws.close();
                        }
                        if (obj.status === 'done') ws.close();
                        dom.find('[data-name=updated]').html(main.timestampFormat(obj['updated']));
                        dom.find('[data-name=total]').html(obj['total']);
                        dom.find('[data-name=scanned]').html(obj['scanned']);
                        dom.find('[data-name=detected]').html(obj['detected']);
                        inst.reloadData({data: obj.data});
                        if (obj['detected'] === 0 && obj.status === 'done') {
                            dom.find('.layui-table-main .layui-none').html('扫描完成，没有发现可疑文件');
                        }
                    };
                },
                end: function () {
                    ws.close();
                }
            });
        },
        info: function () {
            let ws = main.newWS(), inst = table.render({
                elem: '#table-info',
                cols: [[
                    {
                        field: 'running', title: '状态', sort: true, templet: function (d) {
                            return d.running ? '<b style="color:#226A62;">运行中</b>' : '未运行';
                        }, width: 100, align: 'center'
                    }, {
                        field: 'token',
                        title: '日志标识',
                        event: 'token',
                        style: 'cursor:pointer;color:#01aaed;font-weight:bold',
                    }, {
                        field: 'size', title: '字节', width: 200, templet: function (d) {
                            return d.size ? ('<b style="color:#01aaed;">' + d.size + '</b>') : 0;
                        }
                    }, {
                        title: '操作',
                        width: 120,
                        align: 'center',
                        fixed: 'right',
                        toolbar: '<div class="layui-btn-group"><button class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del"><i class="layui-icon layui-icon-delete"></i></button></div>'
                    }]],
                data: [],
                page: true,
                limits: [20, 40, 60],
                limit: 20,
                text: {none: '加载中...'},
                done: function () {
                    $('input[type=radio][value="' + localStorage.getItem('log_info') + '"]').prop('checked', true);
                    form.render('radio');
                }
            });
            form.on('radio(display)', function (obj) {
                localStorage.setItem('log_info', obj.value);
                location.reload();
            });
            table.on('tool(table-info)', function (obj) {
                switch (obj.event) {
                    case 'token':
                        main.ws.log(obj.data.token);
                        break;
                    case 'del':
                        layer.confirm('清除请慎重！清除后不可恢复,确定清除？', {
                            icon: 3, btn: ['确定', '取消'] //按钮
                        }, function (index) {
                            layer.close(index);
                            main.reset.log(obj.data.token);
                        });
                        break
                }
            });
            ws.onopen = function () {
                ws.send(JSON.stringify({action: 'info'}));
            };
            ws.onmessage = function (e) {
                let obj = JSON.parse(e.data);
                if (obj.error) {
                    if (obj.error) main.error(obj.error);
                    return ws.close();
                }
                let field = obj.data;
                if (field) {
                    if (field.data && (localStorage.getItem('log_info') || '1') === '1') {
                        for (let i = 0; i < field.data.length; i++) {
                            if (!field.data[i].size) {
                                field.data.splice(i, 1);
                                i--
                            }
                        }
                    }
                    inst.reloadData({data: field.data});
                    $('#count').text(field.count);
                    $('#active').text(field.active);
                    $('#goroutine').text(field['goroutine']);
                    $('#cron').text(field.cron);
                }
            }
        },
        display: function (options, callback) {
            options = $.extend({
                name: '', displaySelector: '#display', statusSelector: '#status'
            }, options || {});
            if (!options.name) {
                return false;
            }
            let ws = main.newWS();
            ws.onopen = function () {
                ws.send(JSON.stringify({action: 'log', token: options.name}));
            };
            ws.onmessage = function (e) {
                let obj = JSON.parse(e.data);
                if (obj.error) {
                    if (obj.error) main.error(obj.error);
                    return ws.close();
                }
                if (options.statusSelector) {
                    if (obj.running) {
                        $(options.statusSelector).html('状态: <strong style="color: #22849b" title="运行中">运行中...</strong>');
                    } else {
                        $(options.statusSelector).html('状态: <strong style="color: red" title="未运行">未运行</strong>');
                    }
                }
                let el = $(options.displaySelector);
                el.val(el.val() + obj.data).focus().scrollTop(el[0].scrollHeight);
                if (typeof callback === 'function') {
                    callback(obj.running, obj.data);
                }

            };
        }
    };
    main.reboot = {
        app: function (rebootURL) {
            rebootURL = rebootURL || URL;
            layer.confirm("确定重启App?", {icon: 3, title: false}, function (index) {
                main.request({
                    url: rebootURL, data: {action: "botadmin"}, index: index, done: function () {
                        main.sleep(3000);
                        layer.alert('重启App成功!', {title: false, icon: 1, btn: "重新登录"}, function (index) {
                            layer.close(index);
                            parent.location.replace("/auth/logout");
                        });
                        return false;
                    }
                });
            });
        }, service: function (rebootURL) {
            rebootURL = rebootURL || URL;
            layer.confirm("确定重启服务器?", {icon: 3, title: false}, function (index) {
                main.request({
                    url: rebootURL, data: {action: "reboot"}, index: index, done: function () {
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
    exports('main', main);
});