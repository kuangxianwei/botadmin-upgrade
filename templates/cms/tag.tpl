<div class="layui-card">
    <div class="layui-card-body">
        <div class="table-search" style="left:150px">
            <div class="layui-inline layui-form">
                <div class="layui-input-inline">
                    <input type="hidden" name="id" value="{{.obj.Id}}">
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
        main.table([[
            {type: 'checkbox', fixed: 'left'},
            {field: 'index', width: 80, title: '索引', sort: true, align: 'center'},
            {field: 'name', title: '名称', minWidth: 100},
            {field: 'num', title: '调用次', width: 100, sort: true, align: 'center'},
            {title: '操作', width: 150, align: 'center', fixed: 'right', toolbar: '#tool'}
        ]], {
            edit: function () {
                let othis = this;
                main.get(url + "/modify", {id: id, ids: othis.data.index}, function (html) {
                    main.popup({
                        type: 1,
                        title: "修改TAG",
                        url: url + "/modify",
                        content: html,
                        done: "table-list",
                        area: ['600px', '500px'],
                    });
                });
            },
            add: function () {
                main.get(url + "/add", {id: id}, function (html) {
                    main.popup({
                        type: 1,
                        title: "添加TAG",
                        url: url + "/add",
                        content: html,
                        done: "table-list",
                        area: ['600px', '400px'],
                    });
                });
            },
        });
    });
</script>