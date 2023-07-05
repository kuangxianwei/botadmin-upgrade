<div class="layui-card">
    <div class="layui-card-body">
        <div class="layui-form table-search" style="left: 420px">
            <div class="layui-inline">
                <select name="used" class="layui-select" lay-filter="search-select">
                    <option value="">全部</option>
                    <option value="false">未提取</option>
                    <option value="true">提取过</option>
                </select>
            </div>
            <button class="layui-hide" lay-submit="" lay-filter="search">
                <i class="layui-icon layui-icon-search"></i>
            </button>
        </div>
        <table id="table-list" lay-filter="table-list"></table>
    </div>
</div>
<script type="text/html" id="config">
    <div class="layui-card">
        <div class="layui-card-body layui-form">
            <div class="layui-form-item">
                <label for="used" class="layui-form-label">提取状态:</label>
                <div class="layui-input-inline">
                    <input type="checkbox" name="used" id="used" lay-skin="switch" lay-text="已取|未取">
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
        <button class="layui-btn layui-btn-sm layui-btn-normal" lay-event="config">
            <i class="layui-icon layui-icon-set"></i>
        </button>
    </div>
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="export" lay-tips="提取URL">
            <i class="layui-icon iconfont icon-export"></i>
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
        <button class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del">
            <i class="layui-icon layui-icon-delete"></i>
        </button>
    </div>
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let form = layui.form,
            main = layui.main;

        //日志管理
        main.table([[
            {type: 'checkbox', fixed: 'left'},
            {field: 'id', width: 80, title: 'ID', align: 'center', hide: true},
            {
                field: 'used', title: '提取', width: 100, align: 'center',
                event: 'used', templet: function (d) {
                    return '<input type="checkbox" lay-skin="switch" lay-text="已取|未取"' + (d.used ? ' checked' : '') + '>';
                }
            },
            {field: 'url', title: 'URL', sort: true},
            {
                field: 'updated', title: '时间', align: 'center', sort: true, width: 180, templet: function (d) {
                    return main.timestampFormat(d['updated']);
                }
            },
            {title: '操作', width: 80, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
        ]], {
            used: function (obj) {
                let $this = $(this);
                let enabled = !!$this.find('div.layui-unselect.layui-form-onswitch').size();
                main.request({
                    url: url + "/modify",
                    data: {id: obj.data.id, used: enabled, cols: 'used'},
                    error: function () {
                        $this.find('input[type=checkbox]').prop('checked', !enabled);
                        form.render('checkbox');
                    }
                });
            },
            modify: function (obj) {

                main.get(url + '/modify', {id: obj.data.id}, function (html) {

                    main.popup({
                        title: '修改MySQL',
                        content: html,
                        area: ['600px', '550px'],
                        url: url + '/modify',
                        done: 'table-list',
                    });
                });
            },
            config: function (obj, ids) {
                if (ids.length === 0) {
                    return layer.msg('请选择数据');
                }
                main.popup({
                    title: '批量修改配置',
                    content: $('#config').html(),
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
    });
</script>