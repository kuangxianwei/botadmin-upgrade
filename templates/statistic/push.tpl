<div class="layui-card">
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
        <button class="layui-btn layui-btn-sm" lay-event="exec" id="LAY_layer_iframe_exec">
            <i class="layui-icon layui-icon-play"></i>执行
        </button>
        <button class="layui-btn layui-btn-sm" lay-event="excludes" id="LAY_layer_iframe_excludes">
            <i class="layui-icon layui-icon-edit"></i>排除
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
        <button class="layui-btn layui-btn-sm" lay-event="crontab" data-crontab="statistic_push.">
            <i class="layui-icon iconfont icon-view"></i>任务
        </button>
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
        main.table([[
            {type: 'checkbox', fixed: 'left'},
            {field: 'id', width: 80, title: 'ID', align: 'center', sort: true},
            {
                field: 'enabled', title: '启用', width: 100, align: 'center',
                event: 'enabled_switch', templet: function (d) {
                    return '<input type="checkbox" lay-skin="switch" lay-text="启用|关闭"' + (d.enabled ? ' checked' : '') + '>';
                }
            },
            {field: 'range', title: '范围'},
            {field: 'spec', title: '定时'},
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
                        area: '800px',
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
                        area: '800px',
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
            exec: function (obj, ids) {
                if (ids.length === 0) {
                    return layer.msg('请选择数据');
                }
                layer.prompt(
                    {formType: 0, value: obj.data.length, title: '执行推送广告,请输入线程数量 太多会卡死'},
                    function (value, index) {
                        main.request({
                            url: url + '/exec',
                            data: {ids: ids.join(), thread: value},
                            index: index,
                            done: function () {
                                main.ws.log('statistic_push.0');
                                return false;
                            }
                        });
                    });
            },
            excludes: function () {
                main.get(url + '/exclude', function (html) {
                    main.popup({
                        url: url + '/exclude',
                        title: '排除列表',
                        content: html,
                    });
                });
            }
        });
    });
</script>