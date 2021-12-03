<div class="layui-card">
    <div class="layui-card-body">
        <table id="table-list" lay-filter="table-list"></table>
    </div>
</div>
<script type="text/template" id="add-html">
    <div class="layui-card">
        <div class="layui-card-body layui-form">
            <div class="layui-form-item">
                <textarea class="layui-textarea" name="links" rows="6" placeholder="SEO=>http://www.botadmin.cn&#13;SEO培训=>http://www.botadmin.cn" lay-verify="required"></textarea>
            </div>
            <div class="layui-form-item layui-hide">
                <input type="hidden" name="id" value="">
                <button class="layui-btn" lay-submit lay-filter="submit">提交</button>
            </div>
        </div>
    </div>
</script>
<script type="text/template" id="modify-html">
    <div class="layui-card">
        <div class="layui-card-body layui-form">
            <div class="layui-form-item">
                <label class="layui-form-label">关键词:</label>
                <div class="layui-input-block">
                    <input name="keyword" value="" class="layui-input" lay-verify="required">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">URL:</label>
                <div class="layui-input-block">
                    <input name="url" value="" class="layui-input" lay-verify="required">
                </div>
            </div>
            <div class="layui-form-item layui-hide">
                <input type="hidden" name="id" value="">
                <input type="hidden" name="index" value="">
                <input type="hidden" name="links" value="">
                <button class="layui-btn" lay-submit lay-filter="submit">提交</button>
            </div>
        </div>
    </div>
</script>
<script type="text/template" id="toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm" lay-event="add">
            <i class="layui-icon layui-icon-add-circle"></i>
        </button>
        <button class="layui-btn layui-btn-sm layui-bg-red" lay-event="del">
            <i class="layui-icon layui-icon-delete"></i>
        </button>
    </div>
</script>
<script type="text/template" id="tool">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-xs" lay-event="edit">
            <i class="layui-icon layui-icon-edit"></i>
        </button>
        <button class="layui-btn layui-btn-xs layui-bg-red" lay-event="del">
            <i class="layui-icon layui-icon-delete"></i>
        </button>
    </div>
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let id = parseInt({{.id}}) || 0,
            table = layui.table,
            main = layui.main,
            active = {
                "edit": function (obj) {
                    main.popup({
                        title: "修改友情链接",
                        url: url + "/modify",
                        area: ['500px', '240px'],
                        content: $('#modify-html').html(),
                        success: function (dom) {
                            dom.find("[name=id]").val(id);
                            dom.find("[name=keyword]").val(obj.data.keyword);
                            dom.find("[name=url]").val(obj.data.url);
                            dom.find("[name=index]").val(obj.data.index);
                        },
                        yes: function (index, dom) {
                            dom.find("[name=links]").val(JSON.stringify([{
                                index: parseInt(dom.find('[name=index]').val()) || 0,
                                keyword: dom.find('[name=keyword]').val(),
                                url: dom.find('[name=url]').val(),
                            }]));
                        },
                        ending: "table-list",
                    });
                },
                "del": function (obj) {
                    let links = [];
                    links.push(obj.data);
                    layer.confirm('去除友情链接？', function (index) {
                        main.req({
                            url: url + '/del',
                            data: {id: id, links: JSON.stringify(links)},
                            index: index,
                            ending: obj.del(),
                        });
                    });
                }
            },
            activeBar = {
                "add": function () {
                    main.popup({
                        title: "添加友情链接",
                        url: url + "/add",
                        area: ['500px', '300px'],
                        content: $('#add-html').html(),
                        success: function (dom) {
                            dom.find("[name=id]").val(id);
                        },
                        ending: "table-list",
                    });
                },
                "del": function (data) {
                    if (data.length === 0) {
                        layer.msg("未选择", {icon: 2});
                        return false;
                    }
                    let links = [];
                    for (let i = 0; i < data.length; i++) {
                        links[i] = data[i];
                    }
                    layer.confirm('去除友情链接？', function (index) {
                        main.req({
                            url: url + '/del',
                            data: {id: id, links: JSON.stringify(links)},
                            index: index,
                            ending: 'table-list',
                        });
                    });
                }
            };
        table.render({
            headers: {'X-CSRF-Token': csrfToken},
            method: 'post',
            elem: '#table-list',
            toolbar: '#toolbar',
            url: url,
            where: {id: id},
            cols: [[
                {type: 'checkbox', fixed: 'left'},
                {field: 'index', title: '索引', sort: true, width: 80, align: 'center', hide: true},
                {field: 'keyword', title: '关键词'},
                {field: 'url', title: 'URL'},
                {title: '操作', width: 280, align: 'center', fixed: 'right', toolbar: '#tool'}
            ]],
            page: true,
            limit: 10,
            limits: [10, 50, 100, 200],
            text: '对不起，加载出现异常！',
        });
        //监听工具条
        table.on('tool(table-list)', function (obj) {
            active[obj.event] && active[obj.event].call($(this), obj);
        });

        //头工具栏事件
        table.on('toolbar(table-list)', function (obj) {
            let data = table.checkStatus(obj.config.id).data;
            activeBar[obj.event] && activeBar[obj.event].call(obj, data);
        });
    });
</script>