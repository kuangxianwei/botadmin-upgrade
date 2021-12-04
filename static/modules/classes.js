layui.define(['main'], function (exports) {
    const main = layui.main,
        faceTool = '<div class="layui-btn-group"><i data-event="add" class="layui-icon layui-icon-add-circle"></i><i data-event="edit" class="layui-icon layui-icon-edit"></i></div>',
        listTool = '<div class="layui-btn-group"><i data-event="add" class="layui-icon layui-icon-add-circle"></i><i data-event="edit" class="layui-icon layui-icon-edit"></i><i data-event="del" class="layui-icon layui-icon-delete"></i></div>',
        toolBar = '<div class="layui-btn-group tool-bar"><i class="layui-icon layui-icon-add-circle" data-event="addTop" lay-tips="添加顶级栏目"></i><i class="layui-icon iconfont icon-copy" data-event="copy" lay-tips="复制栏目列表"></i><i class="layui-icon iconfont icon-paste" data-event="paste" lay-tips="粘贴栏目"></i><i class="layui-icon iconfont icon-fill" data-event="fill" lay-tips="随机填充栏目"></i></div>',
        fieldHTML = `<div class="layui-fluid">
    <div class="layui-card">
        <div class="layui-card-body layui-form">
            <div class="layui-form-item">
                <div class="layui-row">
                    <div class="layui-col-md6">
                        <label class="layui-form-label">栏目名称:</label>
                        <div class="layui-input-block">
                            <input class="layui-input" lay-verify="required" name="name" placeholder="费用套餐" required type="text">
                        </div>
                    </div>
                    <div class="layui-col-md6"><label class="layui-form-label">栏目别名:</label>
                        <div class="layui-input-block"><input class="layui-input" name="alias" placeholder="seo培训价格是多少" type="text"></div>
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-row">
                    <div class="layui-col-md4">
                        <label class="layui-form-label">路径名:</label>
                        <div class="layui-input-block"><input class="layui-input" name="path" placeholder="price" type="text"></div>
                    </div>
                    <div class="layui-col-md8">
                        <label class="layui-form-label" lay-tips="用于自动匹配发布文章">分词:</label>
                        <div class="layui-input-block"><input class="layui-input" name="segments" placeholder="有限公司,广州,网络,优化" type="text"></div>
                    </div>
                </div>
            </div>
            <div class="layui-form-item"><label class="layui-form-label">关键词:</label>
                <div class="layui-input-block"><input class="layui-input" name="keywords" placeholder="关键词1,关键词2,关键词3" type="text"></div>
            </div>
            <div class="layui-form-item"><label class="layui-form-label">描述:</label>
                <div class="layui-input-block"><input class="layui-input" name="description" placeholder="关于这个栏目的描述" type="text"></div>
            </div>
            <div class="layui-form-item">
                <div class="layui-row">
                    <div class="layui-col-md4"><label class="layui-form-label" lay-tips="隐藏则在导航不显示该栏目">隐藏栏目:</label>
                        <div class="layui-input-block"><input lay-skin="switch" lay-text="是|否" name="hidden" type="checkbox"></div>
                    </div>
                    <div class="layui-col-md4"><label class="layui-form-label" lay-tips="数值越大越靠前">排序:</label>
                        <div class="layui-input-block"><input class="layui-input" name="sort" type="number" value="0"></div>
                    </div>
                    <div class="layui-col-md4"><label class="layui-form-label" lay-tips="每页显示限制">限制:</label>
                        <div class="layui-input-block"><input class="layui-input" name="limit" type="number" value="10"></div>
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">文章排序:</label>
                <div class="layui-input-block">
                    <input checked name="order" title="最新文章" type="radio" value="0">
                    <input name="order" title="最旧文章" type="radio" value="1">
                    <input name="order" title="ID升序" type="radio" value="2">
                    <input name="order" title="ID降序" type="radio" value="3">
                </div>
            </div>
            <div class="layui-form-item"><label class="layui-form-label">其他配置:</label>
                <div class="layui-input-block"><textarea class="layui-textarea" name="options" placeholder="is_face=false&#13;is_mark=true"></textarea></div>
            </div>
        </div>
    </div>
</div>`;

    // tree-view
    class ClassTree {
        constructor() {
            layui.link('/static/style/tree.css');
            this.hasChildren = function (parentIndex) {
                for (let i = 0; i < this.data.length; i++) {
                    if (this.data[i] && this.data[i]['parent_index'] === parentIndex) {
                        return true;
                    }
                }
                return false;
            };
            this.assign = {
                name: function (othis, field, isEdit) {
                    let val = this.val().trim();
                    if (!/^(\w|[\u4e00-\u9fa5]){2,10}$/.test(val)) {
                        main.err("栏目名称不合法");
                        return false;
                    }
                    if (isEdit) {
                        if (othis.names[val] !== undefined && othis.names[val] !== field.index) {
                            main.err("栏目名称已经存在");
                            return false;
                        }
                        othis.names[field.name] = undefined;
                    } else if (othis.names[val] !== undefined) {
                        main.err("栏目名称已经存在");
                        return false;
                    }
                    othis.names[val] = field.index;
                    field.name = val;
                },
                order: function (othis, field) {
                    if (this.prop("checked") === true) {
                        field.order = parseInt(this.val().trim()) || 0;
                    }
                },
                sort: function (othis, field) {
                    field.sort = parseInt(this.val().trim()) || 0;
                },
                limit: function (othis, field) {
                    field.limit = parseInt(this.val().trim()) || 0;
                },
                alias: function (othis, field) {
                    field.alias = this.val().trim();
                },
                path: function (othis, field) {
                    field.path = this.val().trim();
                },
                segments: function (othis, field) {
                    let val = this.val().trim();
                    field.segments = val ? val.split(",") : null;
                },
                keywords: function (othis, field) {
                    let val = this.val().trim();
                    field.keywords = val ? val.split(",") : null;
                },
                description: function (othis, field) {
                    field.description = this.val().trim();
                },
                options: function (othis, field) {
                    let val = this.val().trim();
                    if (val) {
                        field.options = {};
                        $.each(val.split("\n"), function () {
                            if (this) {
                                let l = this.split("=", 2);
                                field.options[l[0].trim()] = l[1].trim();
                            }
                        });
                    } else {
                        field.options = null;
                    }
                }
            };
            this.active = {
                fill: function (othis) {
                    let items = sessionStorage.getItem("class_names");
                    items = typeof items === 'string' ? items.split(",") : items;
                    let num = parseInt($('input[name=class_num]').val()) || 8;
                    if (Array.isArray(items) && items.length > 0) {
                        let fields = [];
                        items = main.randomN(items, num);
                        for (let i = 0; i < items.length; i++) {
                            fields[i] = {name: items[i]};
                        }
                        othis.render("", fields);
                    } else {
                        main.err("请设置栏目名称库");
                        return false;
                    }
                }, addTop: function (othis) {
                    let elem = this.parent().parent();
                    layui.layer.open({
                        type: 1,
                        title: "新增栏目",
                        btn: ["确定", "取消"],
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
                            let isBreak = false, newField = {index: othis.index, parent_index: -1};
                            dom.find('[name]').each(function () {
                                if (othis.assign[this.name] && othis.assign[this.name].call($(this), othis, newField) === false) {
                                    isBreak = true;
                                }
                            });
                            if (isBreak) {
                                return false;
                            }
                            newField.hidden = dom.find('[name=hidden]').prop("checked");
                            othis.names[newField.name] = newField.index;
                            othis.data.push(newField);
                            othis.index++;
                            let citeElem = $('<cite></cite>').text(newField.name).attr("title", "ID: " + (newField.id || 0)),
                                fieldElem = $('<li></li>').attr("data-index", newField.index).append(citeElem).append(listTool);
                            elem.append(fieldElem);
                            othis.on(elem);
                            layui.layer.close(index);
                        }
                    });
                }, copy: function (othis) {
                    othis.done(function (fields) {
                        let trimId = function (data) {
                            for (let i = 0; i < data.length; i++) {
                                delete data[i].id;
                                delete data[i].parent_id;
                                if (data[i].children) {
                                    trimId(data[i].children);
                                }
                            }
                        }
                        trimId(fields);
                        main.copy.exec(JSON.stringify(fields), function () {
                            layui.layer.msg("栏目列表复制成功");
                        });
                    });
                }, paste: function (othis) {
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
                            main.err('格式错误,正确为:<br/>[{"name":"栏目1"},{"name":"栏目2"}]');
                            return false;
                        }
                        layer.close(index);
                        othis.render("", fields);
                    });
                }, add: function (othis) {
                    let elem = this.closest("li"), index = +elem.attr("data-index") || 0, field = othis.data[index];
                    layui.layer.open({
                        type: 1,
                        title: "新增栏目",
                        btn: ["确定", "取消"],
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
                                newField = {index: othis.index, parent_index: field.index, parent_id: field.id || 0};
                            dom.find('[name]').each(function () {
                                if (othis.assign[this.name] && othis.assign[this.name].call($(this), othis, newField) === false) {
                                    isBreak = true;
                                }
                            });
                            if (isBreak) {
                                return false;
                            }
                            newField.hidden = dom.find('[name=hidden]').prop("checked");
                            othis.names[newField.name] = newField.index;
                            othis.data.push(newField);
                            othis.index++;
                            let citeElem = $('<cite></cite>').text(newField.name).attr("title", "ID: " + (newField.id || 0)),
                                fieldElem = $('<li></li>').attr("data-index", newField.index).append(citeElem).append(listTool);
                            if (elem.find("ul").length === 0) {
                                elem.find("i[data-event=del]:first").remove();
                                elem.prepend('<i class="arrow-right arrow-down"></i>').append('<ul></ul>');
                            }
                            elem.find("ul").append(fieldElem);
                            othis.on(elem);
                            layui.layer.close(index);
                        }
                    });
                }, edit: function (othis) {
                    let elem = this.closest("li"), field = othis.data[(+elem.attr("data-index") || 0)];
                    layui.layer.open({
                        type: 1,
                        title: "修改栏目",
                        btn: ["确定", "取消"],
                        content: fieldHTML,
                        maxmin: true,
                        shadeClose: true,
                        scrollbar: false,
                        btnAlign: 'c',
                        shade: 0.8,
                        area: ['800px', '580px'],
                        success: function (dom) {
                            dom.find('[name]').each(function () {
                                switch (this.name) {
                                    case 'order':
                                        let $this = $(this);
                                        $this.prop('checked', false);
                                        if (parseInt($this.val()) === field.order) {
                                            $this.prop('checked', true);
                                        }
                                        break;
                                    case 'limit':
                                        $(this).val(field.limit);
                                        break;
                                    case 'sort':
                                        $(this).val(field.sort);
                                        break;
                                    case 'name':
                                        $(this).val(field.name);
                                        break;
                                    case 'alias':
                                        $(this).val(field.alias);
                                        break;
                                    case 'path':
                                        $(this).val(field.path);
                                        break;
                                    case 'hidden':
                                        $(this).prop('checked', field.hidden);
                                        break;
                                    case 'segments':
                                        if (Array.isArray(field.segments)) {
                                            $(this).val(field.segments.join());
                                        }
                                        break;
                                    case 'keywords':
                                        if (Array.isArray(field.keywords)) {
                                            $(this).val(field.keywords.join());
                                        }
                                        break;
                                    case 'description':
                                        $(this).val(field.description);
                                        break;
                                    case 'options':
                                        if (Object.prototype.toString.call(field.options) === '[object Object]') {
                                            let arr = [];
                                            $.each(field.options, function (k, v) {
                                                arr.push(k + "=" + v);
                                            })
                                            $(this).val(arr.join("\n"));
                                        }
                                        break;
                                }
                            });
                            layui.form.render();
                        },
                        yes: function (index, dom) {
                            let isBreak = false;
                            dom.find('[name]').each(function () {
                                if (othis.assign[this.name] && othis.assign[this.name].call($(this), othis, field, true) === false) {
                                    isBreak = true;
                                }
                            });
                            if (isBreak) {
                                return false;
                            }
                            field.hidden = dom.find('[name=hidden]').prop("checked");
                            elem.find('>cite').text(field.name);
                            othis.data[field.index] = field;
                            layui.layer.close(index);
                        }
                    });
                    return false;
                }, del: function (othis) {
                    let elem = this.closest("li"), index = +elem.attr("data-index") || 0,
                        parentIndex = othis.data[index]['parent_index'];
                    othis.names[othis.data[index].name] = undefined;
                    delete othis.data[index];
                    elem.remove();
                    if (othis.hasChildren(parentIndex) === false) {
                        $('li[data-index=' + parentIndex + ']>i.arrow-right').remove();
                        let toolElem = $(listTool);
                        $('li[data-index=' + parentIndex + ']>div.layui-btn-group').replaceWith(toolElem)
                        othis.on(toolElem);
                    }
                },
            };
            this.on = function (elem) {
                elem = elem || $("ul.tree");
                let othis = this;
                elem.find("i.arrow-right").each(function () {
                    let $this = $(this);
                    if (!$this.hasClass("arrow-down")) {
                        $this.nextAll("ul").hide();
                    }
                }).off("click").on("click", function () {
                    let $this = $(this);
                    $this.toggleClass("arrow-down");
                    $this.nextAll("ul").toggle();
                });
                elem.find("i[data-event]").off("click").on("click", function () {
                    let $this = $(this), event = $this.data("event");
                    othis.active[event] && othis.active[event].call($this, othis);
                });
            };
            this.init = function () {
                this.names = {};
                this.index = 0;
                this.data = [];
            };
            this.render = function (elem, rawData) {
                elem = elem ? $(elem) : $("#class-tree");
                rawData = rawData || JSON.parse($('input[name=classes]').val()) || [];
                this.init();
                let othis = this, boxElem = $('<ul class="tree"></ul>'), build = function (box, fields, parentIndex) {
                    for (let i = 0; i < fields.length; i++) {
                        fields[i].parent_index = parentIndex;
                        fields[i].index = othis.index;
                        othis.data[fields[i].index] = fields[i];
                        othis.names[fields[i].name] = fields[i].index;
                        othis.index++
                        let citeElem = $('<cite></cite>').text(fields[i].name).attr("title", "ID: " + (fields[i].id || 0)),
                            itemElem = $('<li></li>').attr('data-index', fields[i].index).append(citeElem);
                        if (Array.isArray(fields[i].children) && fields[i].children.length > 0) {
                            let elem = $('<ul></ul>');
                            itemElem.prepend('<i class="arrow-right"></i>').append(faceTool).append(elem);
                            box.append(itemElem);
                            build(elem, fields[i].children, fields[i].index);
                        } else {
                            box.append(itemElem.append(listTool));
                        }
                    }
                };
                boxElem.html(toolBar);
                build(boxElem, rawData, -1);
                elem.html(boxElem);
                this.on();
            };
            this.done = function (callback) {
                if (typeof callback !== 'function') {
                    callback = function (fields) {
                        $("input[name=classes]").val(JSON.stringify(fields));
                    }
                }
                let othis = this, toTree = function (nodes) {
                    for (let i = 0; i < nodes.length; i++) {
                        if (nodes[i]) {
                            nodes[i].children = null;
                        }
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
                    let treeData = [];
                    for (let i = 0; i < nodes.length; i++) {
                        if (nodes[i] && nodes[i].parent_index === -1) {
                            treeData.push(nodes[i]);
                        }
                    }
                    let trimTree = function (data) {
                        for (let i = 0; i < data.length; i++) {
                            delete data[i].index;
                            delete data[i].parent_index;
                            if (data[i].children) {
                                trimTree(data[i].children);
                            }
                        }
                    }
                    trimTree(treeData);
                    return treeData;
                };
                callback(toTree([].concat(othis.data)));
            };
        }
    }

    exports('classes', function (elem, data) {
        let tree = new ClassTree();
        tree.render(elem, data);
        return tree;
    });
});