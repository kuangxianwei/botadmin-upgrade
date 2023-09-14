<div class="layui-card">
    <div class="layui-card-body">
        <div class="layui-form table-search" style="left: 550px">
            <button class="layui-hide" lay-submit lay-filter="search">
                <i class="layui-icon layui-icon-search"></i>
            </button>
            <div class="layui-inline">
                <div class="layui-input-inline">
                    <input type="text" name="search" placeholder="输入搜索..." class="layui-input">
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
                <i class="layui-icon layui-icon-add-1"></i>添加
            </button>
            <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="do" lay-tips="执行">
                <i class="layui-icon layui-icon-play"></i>
            </button>
            <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="del">
                <i class="layui-icon layui-icon-delete"></i>删除
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
            <ul class="layui-nav layui-bg-green botadmin-nav">
                <li class="layui-nav-item">
                    <a href="javascript:" lay-tips="定时监控任务" lay-direction="2">
                        <i class="layui-icon iconfont icon-work"></i>
                        <cite>任务</cite>
                    </a>
                    <dl class="layui-nav-child">
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-fluid" lay-event="crontab" data-value="monitor.">
                                查看任务
                            </button>
                        </dd>
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-bg-red layui-btn-fluid" lay-event="switch" data-field="enabled">
                                关闭任务
                            </button>
                        </dd>
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-fluid" lay-event="switch" data-field="enabled" data-value="true">
                                开启任务
                            </button>
                        </dd>
                    </dl>
                </li>
            </ul>
        </div>
        <div class="layui-btn-group">
            <button class="layui-btn layui-btn-sm layui-bg-red" lay-event="resetLog" lay-tips="重置日志">
                <i class="layui-icon iconfont icon-reset"></i>Log
            </button>
            <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="truncate" lay-tips="清空所有的数据，不可恢复！">
                清空
            </button>
        </div>
    </div>
</script>
<script type="text/html" id="table-toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-xs layui-btn-primary" lay-event="do" lay-tips="执行">
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
        let main = layui.main;
        main.upload();
        main.table(
            {
                cols: [[
                    {type: 'checkbox', fixed: 'left'},
                    {field: 'id', width: 80, title: 'ID', align: 'center', hide: true},
                    {
                        field: 'enabled',
                        title: '启用',
                        align: 'center',
                        width: 92,
                        event: 'switch',
                        templet: function (d) {
                            return '<input type="checkbox" lay-skin="switch" lay-text="是|否"' + (d.enabled ? ' checked' : '') + '>';
                        }
                    },
                    {field: 'data', title: '目标地址', sort: true, event: 'copy'},
                    {field: 'to', title: '邮箱', event: 'copy'},
                    {
                        field: 'updated', title: '时间', align: 'center', sort: true, templet: function (d) {
                            return main.timestampFormat(d['updated']);
                        }
                    },
                    {title: '操作', width: 160, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
                ]],
                done: function () {
                    layui.element.render()
                }
            }, {
                modify: function (obj) {
                    main.get(URL + '/modify', {id: obj.data.id}, function (html) {
                        main.popup({
                            title: '修改监控',
                            url: URL + '/modify',
                            area: '600px',
                            content: html,
                            done: 'table-list',
                        });
                    });
                },
                do: function (obj, ids) {
                    if (main.isArray(obj.data)) {
                        if (obj.data.length === 0) {
                            layer.msg("最少需要选中一条！", {icon: 2});
                            return false;
                        }
                        obj.data = {ids: ids.join()};
                    }
                    main.request({
                        url: URL + '/do',
                        data: obj.data,
                        done: function () {
                            let id = 0;
                            if (ids && ids.length === 1) {
                                id = ids[0]
                            }
                            main.ws.log("monitor." + id);
                            return false
                        }
                    });
                },
                add: function () {
                    main.get(URL + '/add', function (html) {
                        main.popup({
                            title: '添加邮箱',
                            url: URL + '/add',
                            area: '600px',
                            content: html,
                            done: 'table-list',
                        });
                    });
                },
            });
    });
</script>