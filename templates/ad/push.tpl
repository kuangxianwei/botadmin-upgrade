<div class="layui-card">
    <div class="layui-form layui-card-header layuiadmin-card-header-auto" lay-event="search">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">帅选:</label>
                <div class="layui-input-block">
                    <select name="enabled" class="layui-select" lay-filter="search-select">
                        <option value="">无</option>
                        <option value="false">禁用</option>
                        <option value="true">启用</option>
                    </select>
                </div>
            </div>
            <div class="layui-inline">
                <div class="layui-input-inline">
                    <input class="layui-input" name="url" placeholder="搜索输入...">
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
<script type="text/html" id="configure">
    <div class="layui-card">
        <div class="layui-card-body layui-form">
            <div class="layui-form-item">
                <label class="layui-form-label">启用:</label>
                <div class="layui-input-inline">
                    <input type="checkbox" name="enabled" lay-skin="switch" lay-text="启用|禁用">
                </div>
            </div>
            <div class="layui-hide">
                <input type="hidden" name="ids" value="">
                <button class="layui-hide" lay-submit lay-filter="submit">提交</button>
            </div>
        </div>
    </div>
</script>
<script type="text/html" id="toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="add" lay-tips="添加配置">
            <i class="layui-icon layui-icon-add-circle"></i>
        </button>
        <button class="layui-btn layui-btn-sm layui-btn-normal" lay-event="configure">
            <i class="layui-icon layui-icon-set"></i>
        </button>
    </div>
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm" lay-event="export" lay-tips="导出配置列表">
            <i class="layui-icon iconfont icon-export"></i>
        </button>
        <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="import" lay-tips="导入配置列表">
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
        <button class="layui-btn layui-btn-sm" lay-event="jobs" lay-tips="查看定时任务">
            <i class="layui-icon iconfont icon-work"></i>
        </button>
    </div>
</script>
<script type="text/html" id="table-toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-xs layui-btn-primary" lay-event="execute" lay-tips="执行">
            <i class="layui-icon layui-icon-play"></i>
        </button>
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
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let table = layui.table,
            form = layui.form,
            main = layui.main;
        main.upload();
        //日志管理
        main.table([[
            {type: 'checkbox', fixed: 'left'},
            {field: 'id', width: 80, title: 'ID', align: 'center', hide: true},
            {field: 'name', title: '名称', width: 100, align: 'center'},
            {
                field: 'enabled', title: '提取', width: 100, align: 'center',
                event: 'enabled', templet: function (d) {
                    return '<input type="checkbox" lay-skin="switch" lay-text="启用|禁用"' + (d.enabled ? ' checked' : '') + '>';
                }
            },
            {field: 'spec', title: '定时', sort: true},
            {field: 'keywords', title: '关键词', hide: true},
            {field: 'configure_ids', title: '配置', hide: true},
            {
                field: 'updated', title: '时间', align: 'center', sort: true, width: 180, templet: function (d) {
                    return main.timestampFormat(d['updated']);
                }
            },
            {title: '操作', width: 180, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
        ]]);
        let active = {
            add: function () {
                let loading = main.loading();
                $.get(url + '/add').always(function () {
                    loading.close();
                }).done(function (html) {
                    main.popup({
                        url: url + '/add',
                        title: '添加规则',
                        content: html,
                        done: 'table-list',
                    });
                });
            },
            enabled: function (obj) {
                let $this = this;
                let enabled = !!$this.find('div.layui-unselect.layui-form-onswitch').size();
                main.request({
                    url: url + "/modify",
                    data: {id: obj.data.id, enabled: enabled, cols: 'enabled'},
                    error: function () {
                        $this.find('input[type=checkbox]').prop('checked', !enabled);
                        form.render('checkbox');
                    }
                });
            },
            del: function (obj) {
                let data = {}, done = obj.del;
                if (obj.config) {
                    let ids = [];
                    $.each(table.checkStatus(obj.config.id).data, function () {
                        ids.push(this.id);
                    });
                    if (ids.length === 0) {
                        return layer.msg('请选择数据');
                    }
                    data.ids = ids.join();
                    done = 'table-list';
                } else {
                    data = obj.data;
                }
                layer.confirm('删除后不可恢复，确定删除？', function (index) {
                    main.request({
                        url: url + '/del',
                        data: data,
                        index: index,
                        done: done
                    });
                });
            },
            modify: function (obj) {
                let loading = layui.main.loading();
                $.get(url + '/modify', {id: obj.data.id}).always(function () {
                    loading.close();
                }).done(function (html) {
                    main.popup({
                        title: '修改推送规则',
                        content: html,
                        url: url + '/modify',
                        done: 'table-list',
                    });
                });
            },
            execute: function (obj) {
                main.request({
                    url: url + '/execute',
                    data: obj.data,
                    done: function () {
                        main.ws.log('ad_push.' + obj.data.id);
                        return false;
                    }
                });
            },
            truncate: function () {
                layer.confirm('清空全部数据，确定清空？', function (index) {
                    main.request({
                        url: url + '/truncate',
                        index: index,
                        done: 'table-list'
                    });
                });
            },
            log: function (obj) {
                main.ws.log('ad_push.' + (obj.data ? obj.data.id : 0));
            },
            resetRecord: function (obj) {
                let ids = [];
                $.each(table.checkStatus(obj.config.id).data, function () {
                    ids.push(this.id);
                });
                main.reset.log('ad_push', ids);
            },
            configure: function (obj) {
                let ids = [];
                $.each(table.checkStatus(obj.config.id).data, function () {
                    ids.push(this.id);
                });
                if (ids.length === 0) {
                    return layer.msg('请选择数据');
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
            },
            import: function () {
                $('#import').click();
            },
            export: function (obj) {
                let ids = [];
                $.each(table.checkStatus(obj.config.id).data, function () {
                    ids.push(this.id);
                });
                window.open(encodeURI('/ad/push/export?ids=' + ids.join()));
            },
            jobs: function () {
                main.request({
                    url: url + '/jobs',
                    done: function (res) {
                        main.msg(res.msg);
                        return false;
                    },
                });
            },
        };
        //监听工具条
        table.on('tool(table-list)', function (obj) {
            active[obj.event] && active[obj.event].call($(this), obj);
        });
        //监听工具栏
        table.on('toolbar(table-list)', function (obj) {
            active[obj.event] && active[obj.event].call(this, obj);
        });
        // 监听搜索
        main.onSearch();
        main.checkLNMP();
    });
</script>