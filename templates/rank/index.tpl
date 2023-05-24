<div class="layui-card">
    <div class="layui-card-header layuiadmin-card-header-auto layui-form">
        <div class="layui-form-item">
            <div class="layui-inline">
                <div class="layui-input-inline">
                    <input type="text" autocomplete="off" name="keyword" value="" class="layui-input" placeholder="模糊匹配关键词">
                </div>
            </div>
            <div class="layui-inline">
                <div class="layui-input-inline">
                    <input type="text" autocomplete="off" name="expect" value="" class="layui-input" placeholder="模糊匹配网站">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label-col">引擎:</label>
            </div>
            <div class="layui-inline">
                <div class="layui-input-inline">
                    <select name="engine" lay-filter="select_engine">
                        {{range .engines -}}
                            <option value="{{.}}">{{.}}</option>
                        {{end -}}
                    </select>
                </div>
            </div>
            <div class="layui-inline">
                <button class="layui-btn" lay-submit lay-filter="search">
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
    <div class="layui-btn-container">
        <div class="layui-btn-group">
            <button class="layui-btn layui-btn-xs" lay-event="add">
                <i class="layui-icon layui-icon-add-circle"></i>添加
            </button>
            <button class="layui-btn layui-btn-xs" lay-event="exec">
                <i class="layui-icon layui-icon-play"></i>执行
            </button>
        </div>
        <div class="layui-btn-group">
            <button class="layui-btn layui-btn-xs layui-btn-primary" lay-event="reset">
                <i class="layui-icon layui-icon-refresh"></i>重置排名
            </button>
            <button class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del">
                <i class="layui-icon layui-icon-delete"></i>删除
            </button>
        </div>
        <div class="layui-btn-group">
            <button class="layui-btn layui-btn-xs layui-bg-red" lay-event="resetLog" lay-tips="重置日志">
                <i class="layui-icon iconfont icon-reset"></i>Log
            </button>
        </div>
    </div>
</script>
<script type="text/html" id="table-toolbar">
    <div class="layui-btn-group">
        <a class="layui-btn layui-btn-xs" lay-event="modify">
            <i class="layui-icon layui-icon-edit"></i>
        </a>
        <a class="layui-btn layui-btn-xs" lay-event="exec">
            <i class="layui-icon layui-icon-play"></i>
        </a>
        <a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del">
            <i class="layui-icon layui-icon-delete"></i>
        </a>
        <a class="layui-btn layui-btn-xs" lay-event="log" lay-tips="查看日志">
            <i class="layui-icon layui-icon-log"></i>
        </a>
    </div>
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let main = layui.main,
            form = layui.form;
        main.table([[
            {type: 'checkbox', fixed: 'left'},
            {field: 'id', title: 'Id', hide: true},
            {field: 'token', title: 'Token', hide: true},
            {field: 'keyword', title: '关键词', minWidth: 150, sort: true},
            {field: 'expect', title: '网站', minWidth: 150, sort: true},
            {field: 'engine', title: '引擎', minWidth: 150, align: 'center', sort: true},
            {field: 'first', title: '初排', width: 80, align: 'center', sort: true},
            {field: 'current', title: '新排', width: 80, align: 'center', sort: true},
            {
                field: 'changed', title: '变化', width: 80, align: 'center', sort: true, templet: function (d) {
                    if (d.changed < 0) {
                        return '<i style="color:red;">' + d.changed + '</i>'
                    }
                    if (d.changed < 0) {
                        return '<i style="color:blue;">' + d.changed + '</i>'
                    }
                    return d.changed
                }
            },
            {field: 'created', title: '创建时间', hide: true},
            {
                field: 'timestamp', title: '排名时间', hide: true, templet: function (obj) {
                    return main.timestampFormat(obj.timestamp / 1000000);
                }
            },
            {title: '操作', width: 150, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
        ]], {
            modify: function (obj) {
                main.get('/rank/modify', {id: obj.data.id}, function (html) {
                    main.popup({
                        title: '修改',
                        content: html,
                        url: '/rank/modify',
                        area: ['450px', '400px'],
                        done: 'table-list',
                    });
                });
            },
            exec: function (obj, ids) {
                if (main.isArray(ids)) {
                    if (obj.data.length === 0) {
                        return layer.msg('请选择数据');
                    }
                    layer.confirm('开始刷新排名', function (index) {
                        let tokens = [];
                        for (let i = 0; i < obj.data.length; i++) {
                            tokens[i] = obj.data[i].token;
                        }
                        main.request({
                            url: '/rank/exec',
                            data: {ids: tokens.join()},
                            index: index,
                            done: 'table-list',
                        });
                    });
                    return
                }
                layer.confirm('开始刷新排名?', function (index) {
                    main.request({
                        url: '/rank/exec',
                        data: {id: obj.data.id},
                        index: index,
                    });
                });
            },
            add: function (obj) {
                main.get('/rank/add', {id: obj.id}, function (html) {
                    main.popup({
                        title: '添加',
                        content: html,
                        url: '/rank/add',
                        area: '450px',
                        done: 'table-list',
                    });
                });
            },
            del: function (obj) {
                if (obj.data.length === 0) {
                    return layer.msg('请选择数据');
                }
                layer.confirm('删除后不可恢复，确定删除吗？', function (index) {
                    let tokens = [];
                    for (let i = 0; i < obj.data.length; i++) {
                        tokens[i] = obj.data[i].token;
                    }
                    main.request({
                        url: '/rank/del',
                        data: {tokens: tokens.join()},
                        index: index,
                        done: 'table-list',
                    });
                });
            },
            reset: function (obj) {
                if (obj.data.length === 0) {
                    return layer.msg('请选择数据');
                }
                let tokens = [];
                layer.confirm('重置排名?', function (index) {
                    for (let i = 0; i < obj.data.length; i++) {
                        tokens[i] = obj.data[i].token;
                    }
                    main.request({
                        url: '/rank/reset',
                        data: {ids: tokens.join()},
                        index: index,
                        done: 'table-list',
                    });
                });
            },
        });
        //监控选择
        form.on('select(select_engine)', function () {
            $('button[lay-filter=search]').click();
            return false;
        });
    });
</script>