<div class="layui-card">
    <div class="layui-card-body">
        <div class="table-search" style="left:200px">
            <div class="layui-inline layui-form">
                <div class="layui-input-inline">
                    <input type="hidden" name="id" value="{{.obj.Id}}">
                    <input type="text" name="search" placeholder="搜索标题" class="layui-input">
                </div>
                <button class="layui-btn layui-btn-sm layui-btn-primary" lay-submit lay-filter="search">
                    <i class="layui-icon layui-icon-search"></i>
                </button>
            </div>
        </div>
        <table id="table-list" lay-filter="table-list"></table>
    </div>
</div>
<script type="text/html" id="toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm" lay-event="add">
            <i class="layui-icon layui-icon-add-circle"></i>
        </button>
        <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="del">
            <i class="layui-icon layui-icon-delete"></i>
        </button>
    </div>
</script>
<script type="text/html" id="tool">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-xs" lay-event="browse">
            <i class="iconfont icon-view"></i>
        </button>
        <button class="layui-btn layui-btn-xs" lay-event="edit">
            <i class="layui-icon layui-icon-edit"></i>
        </button>
        <button class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del">
            <i class="layui-icon layui-icon-delete"></i>
        </button>
    </div>
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let id = parseInt({{.obj.Id}}) || 0,
            table = layui.table,
            main = layui.main;
        //日志管理
        table.render({
            headers: {'X-CSRF-Token': csrfToken},
            method: 'post',
            elem: '#table-list',
            toolbar: '#toolbar',
            url: url,
            where: {id: id},
            cols: [[
                {type: 'checkbox', fixed: 'left'},
                {field: 'id', width: 80, title: 'ID', sort: true},
                {field: 'title', title: '标题', minWidth: 100},
                {
                    field: 'updated', title: '时间', width: 180, sort: true, templet: function (d) {
                        return main.timestampFormat(d['updated']);
                    }
                },
                {title: '操作', width: 150, align: 'center', fixed: 'right', toolbar: '#tool'}
            ]],
            page: true,
            limit: 10,
            limits: [10, 20, 30, 100],
            text: '对不起，加载出现异常！'
        });
        let active = {
                del: function () {
                    let othis = this;
                    layer.confirm('确定删除此条日志？', function (index) {
                        main.request({
                            url: url + '/del',
                            data: {id: id, ids: othis.data.id},
                            index: index,
                            done: function (){othis.del();}
                        });
                    });
                },
                edit: function () {
                    let loading = main.loading();
                    $.get(url + "/modify", {id: id, ids: this.data.id}, function (html) {
                        loading.close();
                        main.popup({
                            type: 1,
                            title: "修改文章",
                            url: url + "/modify",
                            content: html,
                            done: "table-list"
                        });
                    });
                },
                browse: function () {
                    let loading = main.loading();
                    $.get("/cms/url", {id: id, cid: this.data.class_id, aid: this.data.id}, function (res) {
                        loading.close();
                        if (res.code !== 0) {
                            main.error(res.msg);
                        } else {
                            window.open(res.msg, "_blank");
                        }
                    });
                }
            },
            activeBar = {
                add: function () {
                    let loading = main.loading();
                    $.get(url + "/classes", {id: id}, function (res) {
                        loading.close();
                        if (res.code !== 0) {
                            return main.error(res.msg);
                        }
                        if (!Array.isArray(res.data)) {
                            return main.error("网站没有添加任何栏目");
                        }
                        main.open({
                            title: "选择栏目",
                            area: ["800px", "500px"],
                            content: '<div class="layui-card"><div class="layui-card-body layui-form"></div></div>',
                            success: function (dom) {
                                let elem = '';
                                $.each(res.data, function (i) {
                                    elem += '<input type="radio" name="cid" value="' + this.id + '" title="' + this.name + '"' + (i === 0 ? " checked" : "") + '>';
                                });
                                dom.find('.layui-form').html(elem);
                                layui.form.render();
                            },
                            yes: function (index, dom) {
                                layer.close(index);
                                loading = main.loading();
                                $.get(url + "/add", {id: id, cid: main.formData(dom).cid}, function (html) {
                                    loading.close();
                                    main.popup({
                                        type: 1,
                                        title: "添加文章",
                                        url: url + "/add",
                                        content: html,
                                        done: "table-list"
                                    });
                                });
                            }
                        });
                    });
                },
                del: function (obj) {
                    if (obj.data.length === 0) {
                        return layer.msg('请选择数据');
                    }
                    layer.confirm('删除后不可恢复，确定删除吗？', function (index) {
                        let ids = [];
                        for (let i = 0; i < obj.data.length; i++) {
                            ids[i] = obj.data[i].id;
                        }
                        main.request({
                            url: url + '/del',
                            data: {id: id, ids: ids.join()},
                            index: index,
                            done: 'table-list'
                        });
                    });
                },
            };
        //监听工具条
        table.on('tool(table-list)', function (obj) {
            active[obj.event] && active[obj.event].call(obj);
        });

        //头工具栏事件
        table.on('toolbar(table-list)', function (obj) {
            activeBar[obj.event] && activeBar[obj.event].call(obj, table.checkStatus(obj.config.id));
        });
        // 监听搜索
        main.onSearch();
    });
</script>