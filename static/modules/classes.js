layui.define(['main'], function (exports) {
    const main = layui.main,
        faceTool = '<div class="layui-btn-group"><i data-event="add" class="layui-icon layui-icon-add-circle" lay-tips="添加子栏目"></i><i data-event="edit" class="layui-icon layui-icon-edit"></i></div>',
        listTool = '<div class="layui-btn-group"><i data-event="add" class="layui-icon layui-icon-add-circle" lay-tips="添加子栏目"></i><i data-event="edit" class="layui-icon layui-icon-edit"></i><i data-event="del" class="layui-icon layui-icon-delete"></i></div>',
        boxHTML = '<ul class="tree"><div class="layui-btn-group tool-bar"><i class="layui-icon layui-icon-add-circle" data-event="addTop" lay-tips="添加顶级栏目"></i><i class="layui-icon iconfont icon-copy" data-event="copy" lay-tips="复制栏目列表"></i><i class="layui-icon iconfont icon-paste" data-event="paste" lay-tips="粘贴栏目"></i><i class="layui-icon iconfont icon-fill" data-event="fill" lay-tips="随机填充栏目"></i></div></ul>',
        fieldHTML = '<div class="layui-fluid"><div class="layui-card"><div class="layui-card-body layui-form"><div class="layui-form-item"><div class="layui-row"><div class="layui-col-md6"><label class="layui-form-label">栏目名称:</label><div class="layui-input-block"><input class="layui-input" lay-verify="required" name="name" placeholder="费用套餐" required type="text"></div></div><div class="layui-col-md6"><label class="layui-form-label">栏目别名:</label><div class="layui-input-block"><input class="layui-input" name="alias" placeholder="seo培训价格是多少" type="text"></div></div></div></div><div class="layui-form-item"><div class="layui-row"><div class="layui-col-md4"><label class="layui-form-label">路径名:</label><div class="layui-input-block"><input class="layui-input" name="path" placeholder="price" type="text"></div></div><div class="layui-col-md8"><label class="layui-form-label" lay-tips="用于自动匹配发布文章">分词:</label><div class="layui-input-block"><input class="layui-input" name="segments" placeholder="有限公司,广州,网络,优化" type="text"></div></div></div></div><div class="layui-form-item"><label class="layui-form-label">关键词:</label><div class="layui-input-block"><input class="layui-input" name="keywords" placeholder="关键词1,关键词2,关键词3" type="text"></div></div><div class="layui-form-item"><label class="layui-form-label">描述:</label><div class="layui-input-block"><input class="layui-input" name="description" placeholder="关于这个栏目的描述" type="text"></div></div><div class="layui-form-item"><div class="layui-row"><div class="layui-col-md4"><label class="layui-form-label" lay-tips="隐藏则在导航不显示该栏目">隐藏栏目:</label><div class="layui-input-block"><input lay-skin="switch" lay-text="是|否" name="hidden" type="checkbox"></div></div><div class="layui-col-md4"><label class="layui-form-label" lay-tips="数值越大越靠前">排序:</label><div class="layui-input-block"><input class="layui-input" name="sort" type="number" value="0"></div></div><div class="layui-col-md4"><label class="layui-form-label" lay-tips="每页显示限制">限制:</label><div class="layui-input-block"><input class="layui-input" name="limit" type="number" value="10"></div></div></div></div><div class="layui-form-item"><label class="layui-form-label">文章排序:</label><div class="layui-input-block"><input checked name="order" title="最新文章" type="radio" value="0"><input name="order" title="最旧文章" type="radio" value="1"><input name="order" title="ID升序" type="radio" value="2"><input name="order" title="ID降序" type="radio" value="3"></div></div><div class="layui-form-item"><div class="layui-col-md4"><label class="layui-form-label">封面模板:</label><div class="layui-input-block"><input class="layui-input" name="face_tpl" value="" placeholder="face.tpl"></div></div><div class="layui-col-md4"><label class="layui-form-label">列表模板:</label><div class="layui-input-block"><input class="layui-input" name="list_tpl" value="" placeholder="list.tpl"></div></div><div class="layui-col-md4"><label class="layui-form-label">文章模板:</label><div class="layui-input-block"><input class="layui-input" name="article_tpl" value="" placeholder="article.tpl"></div></div></div><div class="layui-form-item"><label class="layui-form-label">其他配置:</label><div class="layui-input-block"><textarea class="layui-textarea" name="options" placeholder="is_face=false&#13;is_mark=true"></textarea></div></div></div></div></div>';
    layui.link('/static/style/tree.css');

    // tree-view
    class ClassTree {
        constructor(options) {
            options = main.isObject(options) ? options : {};
            // 目录树的容器
            this.container = options.container || $('#classes-tree');
            // 接收数据的节点名称 如：input[name=classes]
            this.receiver = typeof options.receiver === 'string' ? options.receiver : 'input[name=classes]';
            // 全部目录名称
            this.classNames = Array.isArray(options.names) ? options.names : ($('[data-class-names]').data('classNames') || []);
            // 默认目录数量
            this.classNun = parseInt(options.classNun) || parseInt($('[name=class_num]').val()) || 8;
            // 内部私有
            this._names = {};
            this._index = 0;
            this._data = [];
        }

        // 归零
        zero() {
            this._names = {};
            this._index = 0;
            this._data = [];
        };

        // 平行数组转为树型
        toTree() {
            let nodes = $.extend(true, [], this._data),
                tidy = function (data) {
                    for (let i = 0; i < data.length; i++) {
                        delete data[i].index;
                        delete data[i].parent_index;
                        if (data[i].children) {
                            tidy(data[i].children);
                        }
                    }
                };
            for (let i = 0; i < nodes.length; i++) {
                if (nodes[i]) nodes[i].children = null;
            }
            for (let i = 0; i < nodes.length; i++) {
                if (nodes[i] && nodes[i].parent_index > -1) {
                    let parentIndex = nodes[i].parent_index;
                    if (nodes[parentIndex] && !Array.isArray(nodes[parentIndex].children)) {
                        nodes[parentIndex].children = [];
                    }
                    nodes[parentIndex].children.push(nodes[i]);
                }
            }
            let data = [];
            for (let i = 0; i < nodes.length; i++) {
                if (nodes[i] && nodes[i].parent_index === -1) {
                    data.push(nodes[i]);
                }
            }
            tidy(data);
            return data;
        };

        // 赋值到input
        assign() {
            $(this.receiver).val(JSON.stringify(this.toTree()));
        }

        // 合上
        closing(elem) {
            (elem || $('ul.tree')).find('i.arrow-right').each(function () {
                if (!$(this).hasClass('arrow-down')) {
                    $(this).nextAll('ul').hide();
                }
            })
        };


        // 判断有子栏目
        hasChildren(parentIndex) {
            for (let i = 0; i < this._data.length; i++) {
                if (this._data[i] && this._data[i]['parent_index'] === parentIndex) {
                    return true;
                }
            }
            return false;
        };

        // 构造HTML
        builder(box, fields, parentIndex) {
            for (let i = 0; i < fields.length; i++) {
                fields[i].parent_index = parentIndex;
                fields[i].index = this._index;
                this._data[fields[i].index] = fields[i];
                this._names[fields[i].name] = fields[i].index;
                this._index++;
                let citeElem = $('<cite></cite>').text(fields[i].name).attr('title', 'ID: ' + (fields[i].id || 0)),
                    itemElem = $('<li></li>').attr('data-index', fields[i].index).append(citeElem);
                if (Array.isArray(fields[i].children) && fields[i].children.length > 0) {
                    let elem = $('<ul></ul>');
                    itemElem.prepend('<i class="arrow-right"></i>').append(faceTool).append(elem);
                    box.append(itemElem);
                    this.builder(elem, fields[i].children, fields[i].index);
                } else {
                    box.append(itemElem.append(listTool));
                }
            }
            this.closing(box);
        }

        // 渲染
        render(data) {
            this.zero();
            data = Array.isArray(data) ? data : (JSON.parse($(this.receiver).val()) || []);
            // 创建目录树容器
            this.container.html(boxHTML);
            //创建已有的目录树
            this.builder(this.container.find('ul.tree'), data, -1);
            let othis = this,
                // 插入数据
                push = {
                    order: function (field) {
                        this.prop('checked', false);
                        if (parseInt(this.val()) === field.order) {
                            this.prop('checked', true);
                        }
                    },
                    hidden: function (field) {
                        this.prop('checked', field.hidden);
                    },
                    segments: function (field) {
                        if (Array.isArray(field.segments)) {
                            this.val(field.segments.join());
                        }
                    },
                    keywords: function (field) {
                        if (Array.isArray(field.keywords)) {
                            this.val(field.keywords.join());
                        }
                    },
                    options: function (field) {
                        if (main.isObject(field.options)) {
                            let arr = [];
                            $.each(field.options, function (k, v) {
                                arr.push(k + '=' + v);
                            });
                            this.val(arr.join('\n'));
                        }
                    },
                },
                // 拉取数据
                pull = {
                    name: function (field, isEdit) {
                        if (!/^(\w|[\u4e00-\u9fa5]){2,10}$/.test(this.value)) {
                            main.error('栏目名称不合法');
                            return false;
                        }
                        if (isEdit) {
                            if (othis._names[this.value] !== undefined && othis._names[this.value] !== field.index) {
                                main.error('栏目名称已经存在');
                                return false;
                            }
                            othis._names[field.name] = undefined;
                        } else if (othis._names[this.value] !== undefined) {
                            main.error('栏目名称已经存在');
                            return false;
                        }
                        othis._names[this.value] = field.index;
                        field.name = this.value;
                    },
                    order: function (field) {
                        field.order = parseInt(this.value) || 0;
                    },
                    hidden: function (field) {
                        field.hidden = this.value !== 'false' && this.value !== 'off';
                    },
                    sort: function (field) {
                        field.sort = parseInt(this.value) || 0;
                    },
                    limit: function (field) {
                        field.limit = parseInt(this.value) || 0;
                    },
                    segments: function (field) {
                        field.segments = this.value ? this.value.split(',') : null;
                    },
                    keywords: function (field) {
                        field.keywords = this.value ? this.value.split(',') : null;
                    },
                    options: function (field) {
                        if (this.value) {
                            field.options = {};
                            $.each(this.value.split(/\r\n|\n|\r/), function () {
                                if (this) {
                                    let l = this.split('=', 2);
                                    field.options[l[0].trim()] = l[1] ? l[1].trim() : '';
                                }
                            });
                        } else {
                            field.options = null;
                        }
                    }
                },
                active = {
                    fill: function () {
                        if (othis.classNames.length > 0) {
                            othis.zero();
                            let fields = [],
                                items = main.randomN(othis.classNames, othis.classNun);
                            for (let i = 0; i < items.length; i++) {
                                fields[i] = {name: items[i]};
                            }
                            othis.container.find('ul.tree>li').remove();
                            othis.builder(othis.container.find('ul.tree'), fields, -1);
                            othis.assign();
                        } else {
                            main.error('请设置栏目名称库');
                            return false;
                        }
                    },
                    addTop: function () {
                        let elem = this.parent().parent();
                        layui.layer.open({
                            type: 1,
                            title: '新增顶级栏目',
                            btn: ['确定', '取消'],
                            content: fieldHTML,
                            maxmin: true,
                            shadeClose: true,
                            scrollbar: false,
                            btnAlign: 'c',
                            shade: 0.8,
                            area: ['800px', '580px'],
                            success: function () {
                                layui.form.render();
                            },
                            yes: function (index, dom) {
                                let field = {index: othis._index, parent_index: -1, hidden: false}, isBreak = false;
                                $.each(dom.find('[name]').serializeArray(), function () {
                                    this.value = this.value.trim();
                                    if (pull[this.name]) {
                                        if (pull[this.name].call(this, field) === false) {
                                            isBreak = true;
                                            return false;
                                        }
                                    } else {
                                        field[this.name] = this.value;
                                    }
                                });
                                if (isBreak) {
                                    return false;
                                }
                                let ts = ['face_tpl', 'list_tpl', 'article_tpl'];
                                for (let i in ts) {
                                    if (field[ts[i]] && !field[ts[i]].hasSuffix('.tpl')) {
                                        main.error('模板名称必须以.tpl结尾');
                                        return false;
                                    }
                                }
                                othis._names[field.name] = field.index;
                                othis._data.push(field);
                                othis._index++;
                                let citeElem = $('<cite></cite>').text(field.name).attr('title', 'ID: ' + (field.id || 0)),
                                    fieldElem = $('<li></li>').attr('data-index', field.index).append(citeElem).append(listTool);
                                elem.append(fieldElem);
                                othis.assign();
                                layui.layer.close(index);
                            }
                        });
                    },
                    copy: function () {
                        main.copy.exec($(othis.receiver).val(), function () {
                            layui.layer.msg('栏目列表复制成功');
                        });
                    },
                    paste: function () {
                        layer.prompt({
                            formType: 2,
                            btnAlign: 'c',
                            title: 'control+v 粘贴已经复制的栏目数据',
                            maxlength: 100000,
                            area: ['600px', '250px']
                        }, function (value, index) {
                            let fields = [];
                            try {
                                fields = JSON.parse(value);
                            } catch (e) {
                                main.error('格式错误,正确为:<br/>[{"name":"栏目1"},{"name":"栏目2"}]');
                                return false;
                            }
                            layer.close(index);
                            othis.container.find('ul.tree>li').remove();
                            othis.zero();
                            othis.builder(othis.container.find('ul.tree'), fields, -1);
                            othis.assign();
                        });
                    },
                    add: function () {
                        let elem = this.closest('li'), index = parseInt(elem.attr('data-index')) || 0,
                            oldField = othis._data[index];
                        layui.layer.open({
                            type: 1,
                            title: '新增子栏目',
                            btn: ['确定', '取消'],
                            content: fieldHTML,
                            maxmin: true,
                            shadeClose: true,
                            scrollbar: false,
                            btnAlign: 'c',
                            shade: 0.8,
                            area: ['800px', '580px'],
                            success: function () {
                                layui.form.render();
                            },
                            yes: function (index, dom) {
                                let isBreak = false,
                                    field = {
                                        index: othis._index,
                                        parent_index: oldField.index,
                                        parent_id: oldField.id || 0,
                                        hidden: false
                                    };
                                $.each(dom.find('[name]').serializeArray(), function () {
                                    this.value = this.value.trim();
                                    if (pull[this.name]) {
                                        if (pull[this.name].call(this, field) === false) {
                                            isBreak = true;
                                            return false;
                                        }
                                    } else {
                                        field[this.name] = this.value;
                                    }
                                });
                                if (isBreak) {
                                    return false;
                                }
                                let ts = ['face_tpl', 'list_tpl', 'article_tpl'];
                                for (let i in ts) {
                                    if (field[ts[i]] && !field[ts[i]].hasSuffix('.tpl')) {
                                        main.error('模板名称必须以.tpl结尾');
                                        return false;
                                    }
                                }
                                othis._names[field.name] = field.index;
                                othis._data.push(field);
                                othis._index++;
                                let citeElem = $('<cite></cite>').text(field.name).attr('title', 'ID: ' + (field.id || 0)),
                                    fieldElem = $('<li></li>').attr('data-index', field.index).append(citeElem).append(listTool);
                                if (elem.find('ul').length === 0) {
                                    elem.find('i[data-event=del]:first').remove();
                                    elem.prepend('<i class="arrow-right arrow-down"></i>').append('<ul></ul>');
                                }
                                elem.find('ul').append(fieldElem);
                                othis.assign();
                                layui.layer.close(index);
                            }
                        });
                    },
                    edit: function () {
                        let elem = this.closest('li'), field = othis._data[(parseInt(elem.attr('data-index')) || 0)];
                        layui.layer.open({
                            type: 1,
                            title: '修改栏目',
                            btn: ['确定', '取消'],
                            content: fieldHTML,
                            maxmin: true,
                            shadeClose: true,
                            scrollbar: false,
                            btnAlign: 'c',
                            shade: 0.8,
                            area: ['800px', '580px'],
                            success: function (dom) {
                                dom.find('[name]').each(function () {
                                    if (push[this.name]) {
                                        push[this.name].call($(this), field);
                                    } else {
                                        $(this).val(field[this.name]);
                                    }
                                });
                                layui.form.render();
                            },
                            yes: function (index, dom) {
                                let isBreak = false;
                                field.hidden = false;
                                $.each(dom.find('[name]').serializeArray(), function () {
                                    this.value = this.value.trim();
                                    if (pull[this.name]) {
                                        if (pull[this.name].call(this, field, true) === false) {
                                            isBreak = true;
                                            return false;
                                        }
                                    } else {
                                        field[this.name] = this.value;
                                    }
                                });
                                if (isBreak) {
                                    return false;
                                }
                                let ts = ['face_tpl', 'list_tpl', 'article_tpl'];
                                for (let i in ts) {
                                    if (field[ts[i]] && !field[ts[i]].hasSuffix('.tpl')) {
                                        main.error('模板名称必须以.tpl结尾');
                                        return false;
                                    }
                                }
                                elem.find('>cite').text(field.name);
                                othis._data[field.index] = field;
                                othis.assign();
                                layui.layer.close(index);
                            }
                        });
                        return false;
                    },
                    del: function () {
                        let elem = this.closest('li'), index = parseInt(elem.attr('data-index')) || 0,
                            parentIndex = othis._data[index]['parent_index'];
                        othis._names[othis._data[index].name] = undefined;
                        delete othis._data[index];
                        elem.remove();
                        if (othis.hasChildren(parentIndex) === false) {
                            $('li[data-index=' + parentIndex + ']>i.arrow-right').remove();
                            $('li[data-index=' + parentIndex + ']>div.layui-btn-group').replaceWith($(listTool));
                        }
                        othis.assign();
                    },
                };
            // 活动事件
            this.container.off('click').on('click', 'ul.tree i[data-event]', function (e) {
                let $this = $(this), event = $this.data('event');
                active[event] && active[event].call($this);
                e.stopPropagation();
            });
            this.container.on('click', 'ul.tree i.arrow-right', function (e) {
                $(this).toggleClass('arrow-down');
                $(this).nextAll('ul').toggle();
                e.stopPropagation();
            });
        };
    }

    exports('classes', function (options) {
        let tree = new ClassTree(options);
        tree.render(options && options.data);
        return tree;
    });
});