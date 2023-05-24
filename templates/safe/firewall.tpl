<div class="layui-card">
    <div class="layui-card-body">
        <div class="layui-form table-search" style="left: 140px">
            <div class="layui-inline">
                <input type="text" autocomplete="off" name="search" class="layui-input" placeholder="输入搜索...">
            </div>
            <button class="layui-btn layui-btn-sm" lay-submit="" lay-filter="search">
                <i class="layui-icon layui-icon-search"></i>
            </button>
        </div>
        <table id="table-list" lay-filter="table-list"></table>
    </div>
</div>
<script type="text/html" id="toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm" lay-event="add" id="LAY_layer_iframe_add">
            <i class="layui-icon layui-icon-add-1"></i>添加端口
        </button>
    </div>
</script>
<script type="text/html" id="table-toolbar">
    <a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del">
        <i class="layui-icon layui-icon-delete"></i>删除
    </a>
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let main = layui.main;
        main.table({
            cols: [[
                {field: 'kind', title: '类型'},
                {field: 'val', title: '值'},
                {title: '操作', width: 150, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
            ]], page: false
        }, {
            add: function () {
                main.get(url + '/add', function (html) {
                    main.popup({
                        title: '添加规则',
                        content: html,
                        url: url + '/add',
                        area: "50%",
                        done: 'table-list',
                    });
                });
            }
        });
    });
</script>