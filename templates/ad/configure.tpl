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
<script type="text/html" id="configure">
    <div class="layui-card">
        <div class="layui-card-body layui-form">
            <div class="layui-form-item">
                <label for="enabled" class="layui-form-label">启用:</label>
                <div class="layui-input-inline">
                    <input type="checkbox" name="enabled" id="enabled" lay-skin="switch" lay-text="启用|禁用">
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
            {
                field: 'enabled', title: '启用', width: 100, align: 'center',
                event: 'enabled', templet: function (d) {
                    return '<input type="checkbox" lay-skin="switch" lay-text="启用|禁用"' + (d.enabled ? ' checked' : '') + '>';
                }
            },
            {field: 'method', title: '方法', width: 100, align: 'center'},
            {field: 'url', title: 'URL', sort: true},
            {field: 'note', title: '备注', width: 180},
            {
                field: 'updated', title: '时间', align: 'center', sort: true, width: 180, templet: function (d) {
                    return main.timestampFormat(d['updated']);
                }
            },
            {title: '操作', width: 120, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
        ]], {
            add: function () {
                main.popup({
                    title: '添加推送配置',
                    url: url + '/add',
                    content: '<div class="layui-card layui-form" style="height: 98%">' +
                        '<textarea class="layui-textarea" name="urls" style="height: 100%" placeholder="https://www.chowan.edu/search/&#123;{keyword}&#125;&#123;{random}&#125;  GET   备注">https://www.chowan.edu/search/&#123;{keyword}&#125;.&#123;{random}&#125;  GET   备注</textarea>' +
                        '<button class="layui-hide" lay-submit lay-filter="submit"></button>' +
                        '</div>',
                    done: 'table-list'
                });
            },
            enabled: function (obj) {
                let $this = this, enabled = !!$this.find('div.layui-unselect.layui-form-onswitch').size();
                main.request({
                    url: url + "/modify",
                    data: {id: obj.data.id, enabled: enabled, cols: 'enabled'},
                    error: function () {
                        $this.find('input[type=checkbox]').prop('checked', !enabled);
                        form.render('checkbox');
                    }
                });
            },
            modify: function (obj) {
                main.get(url + '/modify', {id: obj.data.id}, function (html) {
                    main.popup({
                        title: '修改规则',
                        content: html,
                        area: ['600px', '550px'],
                        url: url + '/modify',
                        done: 'table-list',
                    });
                });
            },
            log: function (obj) {
                main.ws.log('ad_configure.' + (obj.data ? obj.data.id : 0));
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
        });
        main.checkLNMP();
    });
</script>