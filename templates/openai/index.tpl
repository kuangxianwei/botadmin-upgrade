<div class="layui-card">
    <div class="layui-form layui-card-header layuiadmin-card-header-auto">
        <div class="layui-form-item" lay-event="search">
            <div class="layui-inline">
                <label class="layui-form-label">模块名称:</label>
                <div class="layui-input-inline">
                    <input type="text" autocomplete="off" name="name" placeholder="请输入部分名称搜索" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">模型:</label>
                <div class="layui-input-inline">
                    <input type="text" autocomplete="off" name="model" placeholder="请输入部分模型搜索" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
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
            <i class="layui-icon layui-icon-add-circle"></i>添加
        </button>
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
        <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="del" id="LAY_layer_iframe_del">
            <i class="layui-icon layui-icon-delete"></i>删除
        </button>
        <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="truncate"
                id="LAY_layer_iframe_truncate" lay-tips="清空所有的数据，不可恢复！">
            <i class="layui-icon layui-icon-delete"></i>清空所有
        </button>
    </div>
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm" lay-event="log" lay-tips="查看日志">
            <i class="layui-icon layui-icon-log"></i>
        </button>
        <button class="layui-btn layui-btn-sm layui-bg-red" lay-event="resetLog" lay-tips="重置日志">
            <i class="layui-icon iconfont icon-reset"></i>Log
        </button>
    </div>
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm" lay-event="switch" data-field="enabled" data-value="true" lay-tips="启用定时任务">
            <i class="layui-icon layui-icon-play"></i>
        </button>
        <button class="layui-btn layui-btn-sm layui-bg-red" lay-event="switch" data-field="enabled" lay-tips="关闭定时任务">
            <i class="layui-icon iconfont icon-stop-circle"></i>
        </button>
        <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="crontab" data-value="openai." lay-tips="查看定时任务">
            <i class="iconfont icon-work"></i>
        </button>
    </div>
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm" lay-event="askRecorded" lay-tips="已经问过的记录，如果要重复同样的问题请删除记录">
            问答记录
        </button>
    </div>
</script>
<script type="text/html" id="table-toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-xs" lay-event="modify" lay-tips="编辑">
            <i class="layui-icon layui-icon-edit"></i>
        </button>
        <button class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del" lay-tips="删除后不可恢复!">
            <i class="layui-icon layui-icon-delete"></i>
        </button>
        <button class="layui-btn layui-btn-xs layui-btn-primary" lay-event="log" lay-tips="查看日志">
            <i class="layui-icon layui-icon-log"></i>
        </button>
    </div>
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let main = layui.main,
            table = layui.table;
        main.upload();
        main.table([[
            {type: 'checkbox', fixed: 'left'},
            {field: 'id', width: 80, title: 'ID', align: 'center', hide: true},
            {
                field: 'enabled', title: '定时任务', width: 100, align: 'center',
                event: 'switch', templet: function (d) {
                    return '<input type="checkbox" lay-skin="switch" lay-text="启用|禁用"' + (d.enabled ? ' checked' : '') + '>';
                }
            },
            {field: 'name', title: '名称'},
            {field: 'driver', title: '类型', hide: true},
            {field: 'model', title: '模型', hide: true},
            {
                field: 'user_id', title: '秘钥ID', align: 'center', width: 80, templet: (d) => {
                    return d.user_id ? d.user_id : '循序'
                }
            },
            {field: 'max_tokens', title: '最大字节', align: 'center', width: 100},
            {field: 'temperature', title: '温度', align: 'center', width: 100},
            {field: 'top_p', title: '质量', align: 'center', hide: true},
            {field: 'n', title: '回流进度', align: 'center', hide: true},
            {field: 'presence_penalty', title: '存在惩罚', align: 'center', hide: true},
            {field: 'frequency_penalty', title: '惩罚频率', align: 'center', hide: true},
            {
                field: 'updated', title: '时间', align: 'center', sort: true, width: 180, templet: function (d) {
                    return main.timestampFormat(d['updated']);
                }
            },
            {title: '操作', width: 120, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
        ]], {
            add: function () {
                main.get(URL + '/add', function (html) {
                    main.popup({
                        url: URL + '/add',
                        title: '添加模块',
                        content: html,
                        done: 'table-list',
                    });
                });
            },
            askRecorded: function () {
                main.get(URL + '/recorded', function (html) {
                    main.popup({
                        url: URL + '/recorded',
                        title: "问答记录",
                        area: ['600px', '600px'],
                        content: html,
                        done: '-',
                    });
                });
            },
            modify: function (obj) {
                main.get(URL + '/modify', {id: obj.data.id}, function (html) {
                    main.popup({
                        url: URL + '/modify',
                        title: '修改模块',
                        content: html,
                        done: 'table-list',
                    });
                });
            },
        });
        table.on('edit(table-list)', function (obj) {
            main.request({
                url: URL + '/modify',
                data: {id: obj.data.id, key: obj.value, cols: 'key'},
                error: function () {
                    table.reload('table-list');
                }
            });
        });
    });
</script>