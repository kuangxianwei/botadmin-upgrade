<div class="layui-card">
    <div class="layui-form layui-card-header layuiadmin-card-header-auto">
        <div class="layui-form-item" lay-event="search">
            <div class="layui-inline">
                <label class="layui-form-label">域名:</label>
                <div class="layui-input-inline">
                    <input type="text" autocomplete="off" name="origin" placeholder="www.botadmin.cn" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">标题:</label>
                <div class="layui-input-inline">
                    <input type="text" autocomplete="off" name="title" placeholder="站掌门" class="layui-input">
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
        <button class="layui-btn layui-btn-sm layui-bg-red" lay-event="resetLog" lay-tips="重置日志">
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
                <label for="enabled" class="layui-form-label">启用:</label>
                <div class="layui-input-inline">
                    <input type="checkbox" name="enabled" id="enabled" lay-skin="switch" lay-text="是|否" checked>
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
            form = layui.form;
        main.upload();
        main.table([[
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
        ]], {
            enabled_switch: function (obj) {
                let othis = this;
                let enabled = !!othis.find('div.layui-unselect.layui-form-onswitch').size();
                main.request({
                    url: url + '/modify',
                    data: {id: obj.data.id, enabled: enabled, cols: 'enabled'},
                    error: function () {
                        othis.find('input[type=checkbox]').prop("checked", !enabled);
                        form.render('checkbox');
                        return false;
                    }
                });
            },
            modify: function (obj) {
                main.get(url + '/modify', {id: obj.data.id}, function (html) {
                    main.popup({
                        title: '修改',
                        url: url + '/modify',
                        area: ['800px', '500px'],
                        content: html,
                        done: 'table-list',
                    });
                });
            },
            add: function () {
                main.get(url + '/add', function (html) {
                    main.popup({
                        title: '添加',
                        url: url + '/add',
                        area: ['800px', '500px'],
                        content: html,
                        done: 'table-list',
                    });
                });
            },
            configure: function (obj, ids) {
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
        });
        main.checkLNMP();
    });
</script>