<div class="layui-card">
    <div class="layui-form layui-card-header layuiadmin-card-header-auto">
        <div class="layui-form-item" id="form-search" lay-event="search">
            <div class="layui-inline">
                <label class="layui-form-label">搜索类型:</label>
                <div class="layui-input-block">
                    <select lay-filter="search-type">
                        <option value="key">秘钥</option>
                        <option value="enabled">启用</option>
                        <option value="disabled">禁用</option>
                        <option value="type">状态类型</option>
                        <option value="message">提示信息</option>
                        <option value="http_code">状态码</option>
                    </select>
                </div>
            </div>
            <div class="layui-inline">
                <div class="layui-input-inline">
                    <input type="text" name="key" placeholder="搜索..." class="layui-input" id="search-input">
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
        <button class="layui-btn layui-btn-sm layui-btn-normal" lay-event="configure">
            <i class="layui-icon layui-icon-set"></i>
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
</script>
<script type="text/html" id="table-toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del" lay-tips="删除后不可恢复!">
            <i class="layui-icon layui-icon-delete"></i>
        </button>
        <button class="layui-btn layui-btn-xs layui-btn-primary" lay-event="log" lay-tips="查看日志">
            <i class="layui-icon layui-icon-log"></i>
        </button>
    </div>
</script>
<script type="text/html" id="configure">
    <div class="layui-card">
        <div class="layui-card-body layui-form">
            <div class="layui-form-item">
                <label class="layui-form-label">启用:</label>
                <div class="layui-input-inline">
                    <input type="checkbox" name="enabled" lay-skin="switch" lay-text="是|否" checked>
                </div>
                <i class="layui-icon layui-icon-delete" lay-event="del"></i>
            </div>
            <div class="layui-hide">
                <input type="hidden" name="ids" value="">
                <button class="layui-hide" lay-submit lay-filter="submit">提交</button>
            </div>
        </div>
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
                    field: 'enabled', title: '启用', width: 100, align: 'center',
                    event: 'enabled', templet: function (d) {
                        return '<input type="checkbox" lay-skin="switch" lay-text="启用|禁用"' + (d.enabled ? ' checked' : '') + '>';
                    }
                },
                {field: 'key', title: '秘钥', edit: true, event: 'key'},
                {field: 'http_code', width: 90, title: '状态码', align: 'center'},
                {
                    field: 'type', title: '类型', sort: true, templet: function (d) {
                        return d.type || 'Success';
                    }
                },
                {field: 'message', title: '提示', sort: true},
                {
                    field: 'updated', title: '时间', align: 'center', sort: true, templet: function (d) {
                        return main.timestampFormat(d['updated']);
                    }
                },
                {title: '操作', width: 100, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
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
                    main.ws.log('openai.token.' + data.id);
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
                    main.popup({
                        title: '添加Token',
                        url: url + '/add',
                        area: ['500px', '90%'],
                        content: '<div class="layui-card layui-form" style="height: 98%">' +
                            '<textarea class="layui-textarea" name="values" style="height: 100%" placeholder="输入Token一行一个&#10;sk-OcH55LhoKbJHvHsh5JCiT3BlbkF8FrmyJezBbd56XYKprXKJ"></textarea>' +
                            '<button class="layui-hide" lay-submit lay-filter="submit"></bbutton>' +
                            '</div>',
                        done: 'table-list'
                    });
                    break;
                case 'configure':
                    if (checkStatus.data.length === 0) {
                        return layer.msg('请选中数据');
                    }
                    main.popup({
                        title: '批量修改配置',
                        content: $('#configure').html(),
                        area: '400px',
                        success: function (dom) {
                            dom.find('[name=ids]').val(ids.join());
                            main.on.del();
                        },
                        url: url + '/modify',
                        done: 'table-list',
                    });
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
                            data: {'ids': ids.join()},
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
                    window.open(encodeURI('/openai/token/export?ids=' + ids.join()));
                    break;
                case 'import':
                    $('#import').click();
                    break;
                case 'log':
                    main.ws.log('openai.token.0');
                    break;
                case 'resetRecord':
                    main.reset.log('openai.token', ids);
                    break;
            }
        });
        // 监听搜索
        form.on('select(search-type)', function (obj) {
            let ele = $('#search-input');
            switch (obj.value) {
                case 'disabled':
                    table.reload('table-list', {
                        where: {cols: 'enabled', enabled: false, page: {curr: 1}}
                    });
                    ele.hide().val('');
                    break;
                case 'enabled':
                    table.reload('table-list', {
                        where: {
                            cols: 'enabled',
                            enabled: true,
                            page: {curr: 1}
                        }
                    });
                    ele.hide().val('');
                    break;
                case 'http_code':
                    ele.show().attr({type: 'number', name: obj.value}).val('');
                    table.reload('table-list', {where: {page: {curr: 1}}});
                    break;
                default:
                    ele.show().attr({type: 'text', name: obj.value}).val('');
                    table.reload('table-list', {where: {page: {curr: 1}}});
            }
        });
        main.onSearch();
        main.checkLNMP();
    });
</script>