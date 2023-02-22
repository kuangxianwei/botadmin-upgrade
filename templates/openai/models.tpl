<div class="layui-card">
    <div class="layui-form layui-card-header layuiadmin-card-header-auto">
        <div class="layui-form-item" id="form-search" lay-event="search">
            <div class="layui-inline">
                <label class="layui-form-label">模块名称:</label>
                <div class="layui-input-inline">
                    <input type="text" name="name" placeholder="请输入部分名称搜索" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">模型:</label>
                <div class="layui-input-inline">
                    <input type="text" name="model" placeholder="请输入部分模型搜索" class="layui-input">
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
<div class="layui-hide" id="import"></div>
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
        <button class="layui-btn layui-btn-sm layui-bg-red" lay-event="resetRecord" lay-tips="重置日志">
            <i class="layui-icon iconfont icon-reset"></i>Log
        </button>
    </div>
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm" lay-event="enableCron" lay-tips="启用定时任务">
            <i class="layui-icon layui-icon-play"></i>
        </button>
        <button class="layui-btn layui-btn-sm layui-bg-red" lay-event="disableCron" lay-tips="关闭定时任务">
            <i class="layui-icon iconfont icon-stop-circle"></i>
        </button>
        <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="jobs" lay-tips="查看定时任务">
            <i class="layui-icon iconfont icon-view"></i>
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
            table = layui.table,
            form = layui.form,
            upload = layui.upload;
        upload.render({
            headers: {'X-CSRF-Token': csrfToken},
            elem: '#import',
            url: url + '/import',
            accept: 'file',
            exts: 'conf|json|tar.gz|zip',
            before: function () {
                layer.load(); //上传loading
            },
            done: function (res) {
                layer.closeAll('loading'); //关闭loading
                if (res.code === 0) {
                    layer.msg(res.msg);
                    table.reload('table-list');
                } else {
                    layer.alert(res.msg, {icon: 2});
                }
            },
        });

        //日志管理
        table.render({
            headers: {'X-CSRF-Token': csrfToken},
            method: 'post',
            elem: '#table-list',
            url: url,
            toolbar: '#toolbar',
            cols: [[
                {type: 'checkbox', fixed: 'left'},
                {field: 'id', width: 80, title: 'ID', align: 'center', hide: true},
                {
                    field: 'enabled', title: '定时任务', width: 100, align: 'center',
                    event: 'enabled', templet: function (d) {
                        return '<input type="checkbox" lay-skin="switch" lay-text="启用|禁用"' + (d.enabled ? ' checked' : '') + '>';
                    }
                },
                {field: 'name', title: '名称'},
                {field: 'model', title: '模型',},
                {field: 'token_id', title: '秘钥ID', align: 'center', width: 80},
                {field: 'suffix', title: '后缀', align: 'center', hide: true},
                {field: 'max_tokens', title: '最大字节', align: 'center', width: 100},
                {field: 'temperature', title: '随机率', align: 'center', width: 100},
                {field: 'top_p', title: '质量', align: 'center', hide: true},
                {field: 'n', title: '回流进度', align: 'center', hide: true},
                {field: 'stream', title: '数据流', align: 'center', hide: true},
                {field: 'logprobs', title: '返回数量', align: 'center', hide: true},
                {field: 'echo', title: '回显提示', align: 'center', hide: true},
                {field: 'stop', title: '停止符', align: 'center', hide: true},
                {field: 'presence_penalty', title: '存在惩罚', align: 'center', hide: true},
                {field: 'frequency_penalty', title: '惩罚频率', align: 'center', hide: true},
                {field: 'best_of', title: '最佳', align: 'center', hide: true},
                {field: 'logit_bias', title: '可能性', align: 'center', hide: true},
                {field: 'user', title: '用户', align: 'center', hide: true},
                {
                    field: 'updated', title: '时间', align: 'center', sort: true, width: 180, templet: function (d) {
                        return main.timestampFormat(d['updated']);
                    }
                },
                {title: '操作', width: 120, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
            ]],
            page: true,
            limit: 10,
            limits: [10, 50, 100, 800],
            text: '对不起，加载出现异常！'
        });
        table.on('edit(table-list)', function (obj) {
            main.request({
                url: url + '/modify',
                data: {id: obj.data.id, key: obj.value, cols: 'key'},
                error: function () {
                    table.reload('table-list');
                }
            });
        });
        //监听工具条
        table.on('tool(table-list)', function (obj) {
            let data = obj.data, othis = $(this);
            switch (obj.event) {
                case 'modify':
                    let loading = main.loading();
                    $.get(url + '/modify', {id: obj.data.id}, function (html) {
                        loading.close();
                        main.popup({
                            url: url + '/modify',
                            title: '修改模块',
                            content: html,
                            done: 'table-list',
                        });
                        form.render();
                    });
                    break;
                case 'enabled':
                    let enabled = !!othis.find('div.layui-unselect.layui-form-onswitch').size();
                    main.request({
                        url: url + '/modify',
                        data: {id: data.id, enabled: enabled, cols: 'enabled'},
                        error: function () {
                            othis.find('input[type=checkbox]').prop("checked", !enabled);
                            form.render('checkbox');
                        }
                    });
                    break;
                case 'del':
                    layer.confirm('删除后不可恢复，确定删除？', function (index) {
                        main.request({
                            url: url + '/del',
                            data: data,
                            index: index,
                            done: function () {
                                obj.del();
                            }
                        });
                    });
                    break;
                case 'log':
                    main.ws.log('openai.models.' + data.id);
                    break;
            }
        });
        //监听工具栏
        table.on('toolbar(table-list)', function (obj) {
            let checkStatus = table.checkStatus(obj.config.id),
                data = checkStatus.data,
                ids = [];
            layui.each(data, function (i, item) {
                ids[i] = item.id;
            });
            switch (obj.event) {
                case 'add':
                    let loading = main.loading();
                    $.get(url + '/add', function (html) {
                        loading.close();
                        main.popup({
                            url: url + '/add',
                            title: '添加模块',
                            content: html,
                            done: 'table-list',
                        });
                    });
                    break;
                case 'enableCron':
                case 'disableCron':
                    if (checkStatus.data.length === 0) {
                        return layer.msg('请选中数据');
                    }
                    main.request({
                        url: url + '/modify',
                        data: {ids: ids.join(), cols: 'enabled', enabled: obj.event === 'enableCron'},
                        done: 'table-list',
                    });
                    break;
                case 'jobs':
                    main.request({url: url + '/jobs'});
                    break;
                case 'del':
                    let data = checkStatus.data;
                    if (data.length === 0) {
                        return layer.msg('请选择数据');
                    }
                    layer.confirm('删除后不可恢复，确定删除吗？', function (index) {
                        let ids = [];
                        for (let i = 0; i < data.length; i++) {
                            ids[i] = data[i].id;
                        }
                        main.request({
                            url: url + '/del',
                            data: {ids: ids.join()},
                            index: index,
                            done: 'table-list'
                        });
                    });
                    break;
                case 'truncate':
                    layer.confirm('清空全部数据，确定清空？', function (index) {
                        main.request({
                            url: url + '/truncate',
                            index: index,
                            done: 'table-list'
                        });
                    });
                    break;
                case 'export':
                    window.open(encodeURI('/openai/models/export?ids=' + ids.join()));
                    break;
                case 'import':
                    $('#import').click();
                    break;
                case 'log':
                    main.ws.log('openai.models.0');
                    break;
                case 'resetRecord':
                    main.reset.log('openai.models', ids);
                    break;
                case 'askRecorded':
                    let askLoading = main.loading();
                    $.get('/openai/recorded').always(function () {
                        askLoading.close();
                    }).done(function (html) {
                        main.popup({
                            url: '/openai/recorded',
                            title: false,
                            area: ['600px', '600px'],
                            content: html,
                            done: '-',
                        });
                    });
            }
        });
        // 监听搜索
        main.onSearch();
        main.checkLNMP();
    });
</script>