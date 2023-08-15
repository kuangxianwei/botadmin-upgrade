<div class="layui-card">
    <div class="layui-card-body">
        <div class="table-search" style="left:200px">
            <div class="layui-inline layui-form">
                <div class="layui-input-inline">
                    <input type="hidden" value="{{.obj.Id}}">
                    <input type="search" name="search" placeholder="搜索标题" class="layui-input">
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
            main = layui.main;
        main.table({
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
            ]]
        }, {
            del: function (obj, ids) {
                if (main.isArray(ids)) {
                    if (ids.length === 0) {
                        return layer.msg('请选择数据');
                    }
                    layer.confirm('删除后不可恢复，确定删除吗？', function (index) {
                        main.request({
                            url: URL + '/del',
                            data: {id: id, ids: ids.join()},
                            index: index,
                            done: 'table-list'
                        });
                    });
                    return
                }
                layer.confirm('确定删除此条日志？', function (index) {
                    main.request({
                        url: URL + '/del',
                        data: {id: id, ids: obj.data.id},
                        index: index,
                        done: function () {
                            obj.del();
                        }
                    });
                });
            },
            edit: function (obj) {
                main.get(URL + "/modify", {id: id, ids: obj.data.id}, function (html) {
                    main.popup({
                        type: 1,
                        title: "修改文章",
                        url: URL + "/modify",
                        content: html,
                        done: "table-list"
                    });
                });
            },
            browse: function (obj) {
                main.get("/cms/url", {id: id, cid: obj.data.class_id, aid: obj.data.id}, function (res) {
                    if (res.code === 0) {
                        window.open(res.msg, "_blank");
                    } else {
                        main.error(res.msg);
                    }
                });
            },
            add: function () {
                main.get(URL + "/classes", {id: id}, function (res) {
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
                            main.get(URL + "/add", {id: id, cid: main.formData(dom).cid}, function (html) {
                                main.popup({
                                    type: 1,
                                    title: "添加文章",
                                    url: URL + "/add",
                                    content: html,
                                    done: "table-list"
                                });
                            });
                        }
                    });
                });
            },
        });
    });
</script>