<div class="layui-card">
    <div class="layui-card-body">
        <table id="table-list" lay-filter="table-list"></table>
    </div>
</div>
<script type="text/html" id="toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm" lay-event="add">
            <i class="layui-icon layui-icon-addition"></i>添加
        </button>
        <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="del">
            <i class="layui-icon layui-icon-delete"></i>删除
        </button>
    </div>
</script>
<script type="text/html" id="table-toolbar">
    <a class="layui-btn layui-btn-xs" lay-event="modify">
        <i class="layui-icon layui-icon-edit"></i>编辑</a>
    <a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del">
        <i class="layui-icon layui-icon-delete"></i>删除</a>
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let main = layui.main;
        main.table([[
            {type: 'checkbox', fixed: 'left'},
            {field: 'id', title: 'ID', width: 100, sort: true},
            {field: 'name', title: '名称', minWidth: 100},
            {
                field: 'float', title: '浮动', width: 80, templet: function (d) {
                    return d.float > 0 ? '左' : '右';
                }
            },
            {field: 'top', title: 'Top', hide: true},
            {field: 'color', title: '颜色', hide: true},
            {field: 'bg_color', title: '背景', hide: true},
            {field: 'svg_color', title: 'Svg颜色', hide: true},
            {field: 'hover_color', title: 'HoverColor', hide: true},
            {field: 'pc_css', title: 'PcCss', hide: true},
            {field: 'mobile_css', title: 'MobileCss', hide: true},
            {title: '操作', width: 150, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
        ]], {
            modify: function (obj) {
                main.get(URL + "/modify", {id: obj.data.id}, function (html) {
                    main.popup({
                        url: URL + '/modify',
                        title: '修改样式',
                        content: html,
                        done: 'table-list',
                    });
                })
            },
            add: function () {
                main.get(URL + "/add", function (html) {
                    main.popup({
                        url: URL + '/add',
                        title: '添加样式',
                        content: html,
                        done: "table-list",
                    });
                })
            }
        });
    });
</script>