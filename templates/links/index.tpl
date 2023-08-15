<div class="layui-card">
    <div class="layui-card-body">
        <div class="layui-form table-search" style="left:660px">
            <div class="layui-inline">
                <select name="enabled" class="layui-select" lay-filter="search-select">
                    <option value="">全部</option>
                    <option value="false">禁用</option>
                    <option value="true">启用</option>
                </select>
            </div>
            <div class="layui-inline">
                <input type="search" name="search" class="layui-input" placeholder="输入搜索...">
            </div>
            <button class="layui-hide" lay-submit="" lay-filter="search">
                <i class="layui-icon layui-icon-search"></i>
            </button>
        </div>
        <table id="table-list" lay-filter="table-list"></table>
    </div>
</div>
<script type="text/html" id="toolbar">
    <div class="layui-btn-container">
        <div class="layui-btn-group">
            <button class="layui-btn layui-btn-sm" lay-event="add" lay-tips="添加">
                <i class="layui-icon layui-icon-add-circle"></i>
            </button>
            <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="do" lay-tips="执行添加链接">
                <i class="layui-icon layui-icon-play"></i>
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
                    <a href="javascript:" lay-tips="定时发布推文任务" lay-direction="2">
                        <i class="layui-icon iconfont icon-work"></i>
                        <cite>任务</cite>
                    </a>
                    <dl class="layui-nav-child">
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-fluid" lay-event="crontab" data-value="links.">
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
            <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="remove">
                <i class="layui-icon layui-icon-link"></i>清除链接
            </button>
            <button class="layui-btn layui-btn-sm layui-btn-warm" lay-event="del">删除</button>
            <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="truncate" lay-tips="清空所有的数据，不可恢复！">
                清空
            </button>
        </div>
        <div class="layui-btn-group">
            <button class="layui-btn layui-btn-sm" lay-event="log" data-value="links" lay-tips="查看日志">
                <i class="layui-icon layui-icon-log"></i>
            </button>
            <button class="layui-btn layui-btn-sm layui-bg-red" lay-event="resetLog" lay-tips="重置日志">
                <i class="layui-icon iconfont icon-reset"></i>Log
            </button>
        </div>
    </div>
</script>
<script type="text/html" id="table-toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-xs layui-btn-primary" lay-event="do" lay-tips="执行添加链接">
            <i class="layui-icon layui-icon-play"></i></button>
        <button class="layui-btn layui-btn-xs" lay-event="modify">
            <i class="layui-icon layui-icon-edit"></i>
        </button>
        <button class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del">
            <i class="layui-icon layui-icon-delete"></i>
        </button>
        <button class="layui-btn layui-btn-xs layui-btn-primary" lay-event="log" data-value="links" lay-tips="查看日志">
            <i class="layui-icon layui-icon-log"></i>
        </button>
    </div>
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let main = layui.main, element = layui.element;
        main.upload();
        //日志管理
        main.table({
            cols: [[
                {type: 'checkbox', fixed: 'left'},
                {field: 'id', width: 80, title: 'ID', align: 'center', hide: true},
                {field: 'name', title: '名称', width: 120, sort: true},
                {
                    field: 'anchored', title: '启用锚链', width: 100, align: 'center',
                    event: 'switch', templet: function (d) {
                        return '<input type="checkbox" lay-skin="switch" lay-text="启用|禁用"' + (d['anchored'] ? ' checked' : '') + '>';
                    }
                },
                {
                    field: 'global', title: '全局添加', width: 100, align: 'center',
                    event: 'switch', templet: function (d) {
                        return '<input type="checkbox" lay-skin="switch" lay-text="启用|禁用"' + (d['global'] ? ' checked' : '') + '>';
                    }
                },
                {
                    field: 'customize', title: '定制链接', width: 100, align: 'center',
                    event: 'switch', templet: function (d) {
                        return '<input type="checkbox" lay-skin="switch" lay-text="启用|禁用"' + (d['customize'] ? ' checked' : '') + '>';
                    }
                },
                {
                    field: 'enabled', title: '启用定时', width: 100, align: 'center',
                    event: 'switch', templet: function (d) {
                        return '<input type="checkbox" lay-skin="switch" lay-text="启用|禁用"' + (d.enabled ? ' checked' : '') + '>';
                    }
                },
                {field: 'spec', title: '定时规则', width: 150, align: 'center'},
                {field: 'site_ids', title: '网站列表'},
                {field: 'range', title: '范围', hide: true},
                {field: 'css', title: 'CSS', hide: true},
                {
                    field: 'updated', title: '时间', align: 'center', sort: true, width: 180, hide: true,
                    templet: function (d) {
                        return main.timestampFormat(d['updated']);
                    }
                },
                {title: '操作', width: 140, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
            ]],
            done: function (res) {
                element.render();
                if (Array.isArray(res.data)) {
                    $.each(res.data, function (i, d) {
                        if (!d['site_ids'] || d['site_ids'].length === 0) {
                            $('div[lay-id=table-list] tr[data-index=' + i + ']>td').css('background-color', '#ffb800').attr('lay-tips', '网站列表为空，请指定网站列表')
                        }
                    });
                }
            },
        }, {
            do: function (obj, ids) {
                if (main.isArray(ids)) {
                    if (ids.length === 0) {
                        return layer.msg("未选择")
                    }
                    return main.request({data: {ids: ids.join(), action: 'do'}});
                }
                main.request({
                    data: {id: obj.data.id, action: 'do'},
                    done: function () {
                        main.ws.log("links." + obj.data.id);
                        return false
                    }
                });
            },
            remove: function (obj, ids) {
                if (main.isArray(ids)) {
                    if (ids.length === 0) {
                        return layer.msg("未选择")
                    }
                    return main.request({
                        data: {ids: ids.join(), action: 'remove'},
                    });
                }
                main.request({
                    data: {id: obj.data.id, action: 'remove'},
                    done: function () {
                        main.ws.log("links." + obj.data.id);
                        return false
                    }
                });
            },
            add: function () {
                main.get(URL + '/add', function (html) {
                    main.popup({
                        title: '添加规则',
                        url: URL + '/add',
                        area: ['800px', '95%'],
                        content: html,
                        done: 'table-list'
                    });
                });
            },
            modify: function (obj) {
                main.get(URL + '/modify', {id: obj.data.id}, function (html) {
                    main.popup({
                        title: '修改规则',
                        content: html,
                        area: ['800px', '95%'],
                        url: URL + '/modify',
                        done: 'table-list',
                    });
                });
            },
        });
    });
</script>