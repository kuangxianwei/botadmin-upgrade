<div class="layui-card">
    <div class="layui-card-body">
        <div class="layui-form table-search" style="left: 380px">
            <button class="layui-hide" lay-submit lay-filter="search">
                <i class="layui-icon layui-icon-search"></i>
            </button>
            <div class="layui-inline">
                <div class="layui-input-inline">
                    <select name="status" lay-filter="search-select" class="layui-select">
                        <option value="">全部</option>
                        <option value="enabled">已启用</option>
                        <option value="disabled">未启用</option>
                    </select>
                </div>
            </div>
        </div>
        <table id="table-list" lay-filter="table-list"></table>
    </div>
</div>
<script type="text/html" id="toolbar">
    <div class="layui-btn-container">
        <div class="layui-btn-group">
            <button class="layui-btn layui-btn-sm" lay-event="add">
                <i class="layui-icon layui-icon-add-circle"></i>
            </button>
            <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="del">
                <i class="layui-icon layui-icon-delete"></i>
            </button>
        </div>
        <div class="layui-btn-group">
            <button class="layui-btn layui-btn-sm" lay-event="enabled">开启</button>
            <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="disabled">关闭</button>
        </div>
        <div class="layui-btn-group">
            <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="export" lay-tips="导出配置">
                <i class="layui-icon iconfont icon-export"></i>
            </button>
            <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="import" lay-tips="导入配置">
                <i class="layui-icon iconfont icon-import"></i>
            </button>
        </div>
        <div class="layui-btn-group">
            <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="log" lay-tips="查看日志">
                <i class="layui-icon layui-icon-log"></i>
            </button>
        </div>
    </div>
</script>
<script type="text/html" id="table-toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-xs" lay-event="modify">
            <i class="layui-icon layui-icon-edit"></i></button>
        <button class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del">
            <i class="layui-icon layui-icon-delete"></i>
        </button>
    </div>
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let table = layui.table,
            main = layui.main;
        //渲染上传配置
        main.upload();
        //日志管理
        main.table([[
            {type: 'checkbox', fixed: 'left'},
            {field: 'engine', title: '引擎', hide: true},
            {field: 'id', title: 'ID', width: 80, align: 'center', sort: true},
            {
                field: 'enabled', title: '启用', width: 100, align: 'center',
                event: 'enabled', templet: function (d) {
                    return '<input type="checkbox" lay-skin="switch" lay-text="启用|关闭"' + (d.enabled ? ' checked' : '') + '>';
                }
            },
            {{if not .hide -}}
            {field: 'app_id', title: 'AppId', minWidth: 100, align: 'center', sort: true},
            {{end -}}
            {field: 'token', title: 'Token', minWidth: 100},
            {field: 'delay', title: '延时', width: 100, align: 'center', hide: true},
            {
                field: 'created', title: '创建时间', width: 160, align: 'center', sort: true, templet: function (d) {
                    return main.timestampFormat(d['created']);
                }
            },
            {title: '操作', width: 120, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
        ]], {
            enabled: function (obj, ids) {
                if (main.isArray(ids)) {
                    if (ids.length === 0) {
                        return main.error('请选择数据');
                    }
                    main.request({
                        url: url + '/switch',
                        data: {ids: ids.join(), enabled: true},
                        done: 'table-list'
                    });
                    return
                }
                let othis = $(this),
                    enabled = !!othis.find('div.layui-unselect.layui-form-onswitch').size();
                main.request({
                    url: url + "/switch",
                    data: {
                        id: obj.data.id,
                        enabled: enabled
                    },
                    error: function () {
                        if (enabled) {
                            othis.find('div.layui-unselect.layui-form-switch').removeClass('layui-form-onswitch');
                        } else {
                            othis.find('div.layui-unselect.layui-form-switch').addClass('layui-form-onswitch');
                        }
                    }
                });
            },
            modify: function (obj) {

                main.get(url + '/modify', {id: obj.data.id}, function (html) {

                    main.popup({
                        title: '修改翻译配置',
                        url: url + '/modify',
                        area: '70%',
                        content: html,
                        done: 'table-list',
                    });
                });
            },
            add: function () {
                main.get(url + '/add', function (html) {
                    main.popup({
                        title: '添加翻译配置',
                        url: url + '/add',
                        area: '70%',
                        content: html,
                        done: 'table-list',
                    });
                });
            },
            disabled: function (obj, ids) {
                if (ids.length === 0) {
                    return main.error('请选择数据');
                }
                main.request({
                    url: url + '/switch',
                    data: {ids: ids.join(), enabled: false},
                    done: 'table-list'
                });
            },
        });
    });
</script>