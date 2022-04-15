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
            <div class="layui-form-item">
                <div class="layui-col-md4">
                    <label class="layui-form-label">封面模板:</label>
                    <div class="layui-input-block">
                        <input class="layui-input" name="face_tpl" value="" placeholder="face.tpl">
                    </div>
                </div>
                <div class="layui-col-md4">
                    <label class="layui-form-label">列表模板:</label>
                    <div class="layui-input-block">
                        <input class="layui-input" name="list_tpl" value="" placeholder="list.tpl">
                    </div>
                </div>
                <div class="layui-col-md4">
                    <label class="layui-form-label">文章模板:</label>
                    <div class="layui-input-block">
                        <input class="layui-input" name="article_tpl" value="" placeholder="article.tpl">
                    </div>
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
            this.push = {
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
                    if (Object.prototype.toString.call(field.options) === '[object Object]') {
                        let arr = [];
                        $.each(field.options, function (k, v) {
                            arr.push(k + "=" + v);
                        });
                        this.val(arr.join("\n"));
                    }
                },
            };
            this.pull = {
                name: function (field, othis, isEdit) {
                    if (!/^(\w|[\u4e00-\u9fa5]){2,10}$/.test(this.value)) {
                        main.err("栏目名称不合法");
                        return false;
                    }
                    if (isEdit) {
                        if (othis.names[this.value] !== undefined && othis.names[this.value] !== field.index) {
                            main.err("栏目名称已经存在");
                            return false;
                        }
                        othis.names[field.name] = undefined;
                    } else if (othis.names[this.value] !== undefined) {
                        main.err("栏目名称已经存在");
                        return false;
                    }
                    othis.names[this.value] = field.index;
                    field.name = this.value;
                },
                order: function (field) {
                    field.order = parseInt(this.value) || 0;
                },
                hidden: function (field) {
                    field.hidden = this.value !== "false" && this.value !== "off";
                },
                sort: function (field) {
                    field.sort = parseInt(this.value) || 0;
                },
                limit: function (field) {
                    field.limit = parseInt(this.value) || 0;
                },
                segments: function (field) {
                    field.segments = this.value ? this.value.split(",") : null;
                },
                keywords: function (field) {
                    field.keywords = this.value ? this.value.split(",") : null;
                },
                options: function (field) {
                    if (this.value) {
                        field.options = {};
                        $.each(this.value.split(/\r\n|\n|\r/), function () {
                            if (this) {
                                let l = this.split("=", 2);
                                field.options[l[0].trim()] = l[1] ? l[1].trim() : "";
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
                },
                addTop: function (othis) {
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
                            let field = {index: othis.index, parent_index: -1, hidden: false}, isBreak = false;
                            $.each(dom.find("[name]").serializeArray(), function () {
                                this.value = this.value.trim();
                                if (othis.pull[this.name]) {
                                    if (othis.pull[this.name].call(this, field, othis) === false) {
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
                                if (field[ts[i]] && !field[ts[i]].hasSuffix(".tpl")) {
                                    main.err("模板名称必须以.tpl结尾");
                                    return false;
                                }
                            }
                            othis.names[field.name] = field.index;
                            othis.data.push(field);
                            othis.index++;
                            let citeElem = $('<cite></cite>').text(field.name).attr("title", "ID: " + (field.id || 0)),
                                fieldElem = $('<li></li>').attr("data-index", field.index).append(citeElem).append(listTool);
                            elem.append(fieldElem);
                            othis.on(elem);
                            layui.layer.close(index);
                        }
                    });
                },
                copy: function (othis) {
                    othis.done(function (fields) {
                        let trimId = function (data) {
                            for (let i = 0; i < data.length; i++) {
                                delete data[i].id;
                                delete data[i].parent_id;
                                if (data[i].children) {
                                    trimId(data[i].children);
                                }
                            }
                        };
                        trimId(fields);
                        main.copy.exec(JSON.stringify(fields), function () {
                            layui.layer.msg("栏目列表复制成功");
                        });
                    });
                },
                paste: function (othis) {
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
                },
                add: function (othis) {
                    let elem = this.closest("li"), index = +elem.attr("data-index") || 0, oldField = othis.data[index];
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
                                field = {
                                    index: othis.index,
                                    parent_index: oldField.index,
                                    parent_id: oldField.id || 0,
                                    hidden: false
                                };
                            $.each(dom.find("[name]").serializeArray(), function () {
                                this.value = this.value.trim();
                                if (othis.pull[this.name]) {
                                    if (othis.pull[this.name].call(this, field, othis) === false) {
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
                                if (field[ts[i]] && !field[ts[i]].hasSuffix(".tpl")) {
                                    main.err("模板名称必须以.tpl结尾");
                                    return false;
                                }
                            }
                            othis.names[field.name] = field.index;
                            othis.data.push(field);
                            othis.index++;
                            let citeElem = $('<cite></cite>').text(field.name).attr("title", "ID: " + (field.id || 0)),
                                fieldElem = $('<li></li>').attr("data-index", field.index).append(citeElem).append(listTool);
                            if (elem.find("ul").length === 0) {
                                elem.find("i[data-event=del]:first").remove();
                                elem.prepend('<i class="arrow-right arrow-down"></i>').append('<ul></ul>');
                            }
                            elem.find("ul").append(fieldElem);
                            othis.on(elem);
                            layui.layer.close(index);
                        }
                    });
                },
                edit: function (othis) {
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
                                if (othis.push[this.name]) {
                                    othis.push[this.name].call($(this), field);
                                } else {
                                    $(this).val(field[this.name]);
                                }
                            });
                            layui.form.render();
                        },
                        yes: function (index, dom) {
                            let isBreak = false;
                            field.hidden = false;
                            $.each(dom.find("[name]").serializeArray(), function () {
                                this.value = this.value.trim();
                                if (othis.pull[this.name]) {
                                    if (othis.pull[this.name].call(this, field, othis, true) === false) {
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
                                if (field[ts[i]] && !field[ts[i]].hasSuffix(".tpl")) {
                                    main.err("模板名称必须以.tpl结尾");
                                    return false;
                                }
                            }
                            elem.find('>cite').text(field.name);
                            othis.data[field.index] = field;
                            layui.layer.close(index);
                        }
                    });
                    return false;
                },
                del: function (othis) {
                    let elem = this.closest("li"), index = +elem.attr("data-index") || 0,
                        parentIndex = othis.data[index]['parent_index'];
                    othis.names[othis.data[index].name] = undefined;
                    delete othis.data[index];
                    elem.remove();
                    if (othis.hasChildren(parentIndex) === false) {
                        $('li[data-index=' + parentIndex + ']>i.arrow-right').remove();
                        let toolElem = $(listTool);
                        $('li[data-index=' + parentIndex + ']>div.layui-btn-group').replaceWith(toolElem);
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
                        othis.index++;
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
                    };
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