<div class="layui-card">
    <div class="layui-card-body">
        <div class="layui-btn-group">
            <button class="layui-btn" data-type="add">
                <i class="layui-icon layui-icon-add-1"></i>添加
            </button>
        </div>
        <table id="table-list" lay-filter="table-list"></table>
    </div>
</div>
<script type="text/html" id="table-toolbar">
    <a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del">
        <i class="layui-icon layui-icon-delete"></i>删除
    </a>
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let table = layui.table,
            main = layui.main;
        //规则管理
        table.render({
            headers: {'X-CSRF-Token':csrfToken},
            method: 'post',
            elem: '#table-list',
            url: url,
            cols: [[
                {field: 'kind', title: '类型'},
                {field: 'val', title: '值'},
                {title: '操作', width: 150, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
            ]],
            page: false,
            limit: 10,
            limits: [10, 15, 20, 25, 30],
            text: '对不起，加载出现异常！'
        });

        //监听工具条
        table.on('tool(table-list)', function (obj) {
            let data = obj.data;
            if (obj.event === 'del') {
                layer.confirm('确定删除此条规则？', function (index) {
                    main.req({
                        url: url + '/del',
                        data: data,
                        index: index,
                        ending: 'table-list'
                    });
                });
            }
        });

        //点击添加
        let active = {
            add: function () {
                $.get(url + '/add', {}, function (html) {
                    main.popup({
                        title: '添加规则',
                        content: html,
                        url: url + '/add',
                        area: "50%",
                        ending: 'table-list',
                    });
                });
            },
        };

        $('.layui-btn').on('click', function () {
            let type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });
    });
</script>
