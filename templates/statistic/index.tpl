<div class="layui-card">
    <div class="layui-form layui-card-header layuiadmin-card-header-auto">
        <div class="layui-form-item" id="form-search" lay-event="search">
            <div class="layui-inline">
                <label class="layui-form-label">域名:</label>
                <div class="layui-input-inline">
                    <input type="text" name="origin" placeholder="www.botadmin.cn" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">标题:</label>
                <div class="layui-input-inline">
                    <input type="text" name="title" placeholder="站掌门" class="layui-input">
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
        <button class="layui-btn  layui-btn-danger layui-btn-sm" lay-event="del" id="LAY_layer_iframe_del">
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
        <button class="layui-btn layui-btn-sm layui-bg-red" lay-event="reset-record" lay-tips="重置日志">
            <i class="layui-icon iconfont icon-reset"></i>Log
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
            upload = layui.upload,
            url = {{.current_uri}};
        url = url || '';
        upload.render({
            headers: {'X-CSRF-Token':{{.csrf_token}}},
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
            headers: {'X-CSRF-Token':{{.csrf_token}}},
            method: 'post',
            elem: '#table-list',
            url: url,
            toolbar: '#toolbar',
            cols: [[
                {type: 'checkbox', fixed: 'left'},
                {field: 'id', width: 80, title: 'ID', align: 'center', sort: true},
                {
                    field: 'enabled', title: '启用', width: 100, align: 'center',
                    event: 'enabled_switch', templet: function (d) {
                        return '<input type="checkbox" lay-skin="switch" lay-text="启用|关闭"' + (d.enabled ? ' checked' : '') + '>';
                    }
                },
                {field: 'origin', title: '源'},
                {field: 'title', title: '标题'},
                {
                    field: 'controls', title: '控制列表', align: 'center', templet: function (d) {
                        return JSON.stringify(d.controls);
                    }, hide: true
                },
                {
                    field: 'updated', title: '时间', align: 'center', sort: true, templet: function (d) {
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

        //监听工具条
        table.on('tool(table-list)', function (obj) {
            let data = obj.data, othis = $(this);
            switch (obj.event) {
                case 'enabled_switch':
                    let enabled = !!othis.find('div.layui-unselect.layui-form-onswitch').size();
                    main.req({
                        url: url + '/modify',
                        data: {id: data.id, enabled: enabled, cols: 'enabled'},
                        error: function () {
                            othis.find('input[type=checkbox]').prop("checked", !enabled);
                            form.render('checkbox');
                            return false;
                        }
                    });
                    break;
                case 'del':
                    layer.confirm('删除后不可恢复，确定删除？', function (index) {
                        main.req({
                            url: url + '/del',
                            data: data,
                            index: index,
                            ending: 'table-list'
                        });
                    });
                    break;
                case 'modify':
                    $.get(url + '/modify', {id: data.id}, function (html) {
                        main.popup({
                            title: '修改',
                            url: url + '/modify',
                            area: ['800px', '500px'],
                            content: html,
                            ending: 'table-list',
                        });
                    });
                    break;
                case 'log':
                    main.ws.log('statistic.' + data.id);
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
                    $.get(url + '/add', function (html) {
                        main.popup({
                            title: '添加',
                            url: url + '/add',
                            area: ['800px', '500px'],
                            content: html,
                            ending: 'table-list',
                        });
                    });
                    break;
                case 'configure':
                    main.popup({
                        title: '批量修改配置',
                        content: $('#configure').html(),
                        area: ['400px', '200px'],
                        success: function (dom) {
                            dom.find('[name=ids]').val(ids.join());
                            main.on.del();
                        },
                        url: url + '/modify',
                        ending: 'table-list',
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
                        main.req({
                            url: url + '/del',
                            data: {'ids': ids.join()},
                            index: index,
                            ending: 'table-list'
                        });
                    });
                    break;
                case 'truncate':
                    layer.confirm('清空全部数据，确定清空？', function (index) {
                        main.req({
                            url: url + '/truncate',
                            index: index,
                            ending: 'table-list'
                        });
                    });
                    break;
                case 'export':
                    window.open(encodeURI('/statistic/export?ids=' + ids.join()));
                    break;
                case 'import':
                    $('#import').click();
                    break;
                case 'log':
                    main.ws.log('statistic.0');
                    break;
                case 'reset-record':
                    main.reset.log('statistic', ids);
                    break;
            }
        });

        //监听搜索
        form.on('submit(search)', function (data) {
            let field = data.field, cols = [];
            $.each(field, function (k, v) {
                if (v) {
                    cols.push(k);
                } else {
                    delete field[k];
                }
            });
            field.cols = cols.join();
            if (!field.cols) {
                return location.reload();
            }
            //执行重载
            table.reload('table-list', {
                where: field,
                page: {curr: 1}
            });
            return false;
        });
        // enter 搜索
        $('[lay-event=search] input').keydown(function (event) {
            if (event.keyCode === 13) {
                $('[lay-filter="search"]').click();
            }
        });
    });
</script>
