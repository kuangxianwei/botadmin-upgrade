<div class="layui-card">
    <div class="layui-form layui-card-header layuiadmin-card-header-auto" lay-event="search">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">IDS</label>
                <div class="layui-input-inline">
                    <input type="text" autocomplete="off" name="ids" placeholder="1,2,4,5" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">用户名:</label>
                <div class="layui-input-inline">
                    <input type="text" autocomplete="off" name="username" placeholder="请输入数据库用户名" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">数据库名:</label>
                <div class="layui-input-inline">
                    <input type="text" autocomplete="off" name="dbname" placeholder="请输入数据库名称" class="layui-input">
                </div>
            </div>
            <div class="layui-hide">
                <button class="layui-btn" data-type="reload" lay-submit lay-filter="search">
                    <i class="layui-icon layui-icon-search layuiadmin-button-btn"></i>
                </button>
            </div>
        </div>
    </div>
    <div class="layui-card-body">
        <table id="table-list" lay-filter="table-list"></table>
    </div>
</div>
<script type="text/html" id="toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm" lay-event="add">
            <i class="layui-icon layui-icon-add-1"></i>创建MySQL
        </button>
        <button class="layui-btn layui-btn-sm" lay-event="sync">
            <i class="layui-icon layui-icon-refresh-3"></i>同步MySQL
        </button>
    </div>
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm" lay-event="modifyroot">
            <i class="layui-icon layui-icon-edit"></i>修改密码
        </button>
        <button class="layui-btn layui-btn-sm" lay-event="resetroot">
            <i class="layui-icon layui-icon-refresh"></i>重置密码
        </button>
        <button class="layui-btn layui-btn-sm" lay-event="viewRoot">
            <i class="layui-icon  layui-icon-about"></i>复制密码
        </button>
    </div>
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="truncate" lay-tips="清空所有的数据，不可恢复！">
            清空
        </button>
    </div>
</script>
<script type="text/html" id="table-toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-xs" lay-event="modify">
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
        let main = layui.main;
        main.table([[
            {field: 'id', width: 80, title: 'ID', align: 'center', sort: true},
            {field: 'username', title: '用户名', align: 'center'},
            {field: 'password', title: '密码', align: 'center'},
            {field: 'dbname', title: '数据库名', align: 'center'},
            {field: 'charset', title: '编码', align: 'center', width: 66},
            {field: 'prefix', title: '前缀', hide: true},
            {field: 'hosts', title: '访问地址', align: 'center', width: 90},
            {field: 'site_id', title: '绑定站点', align: 'center'},
            {
                field: 'updated', title: '时间', align: 'center', sort: true, templet: function (d) {
                    return main.timestampFormat(d['updated']);
                }
            },
            {field: 'note', title: '备注', align: 'center', hide: true},
            {title: '操作', width: 120, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
        ]], {
            modify: function (obj) {
                main.get(URL + '/modify', {id: obj.data.id}, function (html) {
                    main.popup({
                        title: '修改MySQL',
                        content: html,
                        area: ['600px', '550px'],
                        url: URL + '/modify',
                        done: 'table-list',
                    });
                });
            },
            add: function () {
                main.get(URL + '/add', function (html) {
                    main.popup({
                        title: '创建数据库',
                        content: html,
                        area: ['600px', '550px'],
                        url: URL + '/add',
                        done: 'table-list',
                    });
                });
            },
            modifyroot: function () {
                main.get(URL + '/modifyroot', function (html) {
                    main.popup({
                        title: '修改root密码',
                        content: html,
                        url: URL + '/modifyroot',
                        area: '400px',
                    });
                });
            },
            resetroot: function () {
                main.get(URL + '/resetroot', function (html) {
                    main.popup({
                        title: '重置root密码',
                        content: html,
                        url: URL + '/resetroot',
                        area: '400px',
                    });
                });
            },
            viewRoot: function () {
                main.get(URL + '/view', function (pwd) {
                    main.copy(pwd, layer.msg('root密码复制成功'));
                });
            },
            sync: function () {
                layer.confirm('如无错误且无需同步，确定同步？', function (index) {
                    main.request({
                        url: URL + '/sync',
                        index: index,
                        done: 'table-list',
                    });
                });
            },
        });
    });
</script>