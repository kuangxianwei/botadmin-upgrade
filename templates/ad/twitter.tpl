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
                <input type="text" autocomplete="off" name="search" class="layui-input" placeholder="输入搜索...">
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
            <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="tweet" lay-tips="发送推文">
                <i class="layui-icon layui-icon-play"></i>
            </button>
        </div>
        <div class="layui-btn-group">
            <ul class="layui-nav botadmin-nav">
                <li class="layui-nav-item">
                    <a href="javascript:" lay-tips="设置库" lay-direction="2">
                        <i class="layui-icon layui-icon-set"></i>
                    </a>
                    <dl class="layui-nav-child">
                        <dd>
                            <button class="layui-btn layui-btn-sm" lay-href="/file?path=data/ad/twitter/images/foreground" lay-text="前景图库">
                                前景图库
                            </button>
                        </dd>
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-primary" lay-href="/file?path=data/ad/twitter/images/background" lay-text="背景图库">
                                背景图库
                            </button>
                        </dd>
                        <dd>
                            <button class="layui-btn layui-btn-sm" lay-href="/file?path=data/ad/twitter/images/done" lay-text="已译图库">
                                已译图库
                            </button>
                        </dd>
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-primary" lay-href="/file?path=data/ad/twitter/tweet" lay-text="推文库">
                                推文文库
                            </button>
                        </dd>
                    </dl>
                </li>
            </ul>
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
                            <button class="layui-btn layui-btn-sm layui-btn-fluid" lay-event="crontab" data-crontab="twitter.">
                                查看任务
                            </button>
                        </dd>
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-bg-red layui-btn-fluid" lay-event="disable">
                                关闭任务
                            </button>
                        </dd>
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-fluid" lay-event="enabled">开启任务</button>
                        </dd>
                    </dl>
                </li>
            </ul>
        </div>
        <div class="layui-btn-group">
            <button class="layui-btn layui-btn-sm layui-btn-warm" lay-event="del">删除</button>
            <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="truncate" lay-tips="清空所有的数据，不可恢复！">
                清空
            </button>
        </div>
        <div class="layui-btn-group">
            <button class="layui-btn layui-btn-sm" lay-event="log" data-value="twitter" lay-tips="查看日志">
                <i class="layui-icon layui-icon-log"></i>
            </button>
            <button class="layui-btn layui-btn-sm layui-bg-red" lay-event="resetLog" data-value="twitter" lay-tips="重置日志">
                <i class="layui-icon iconfont icon-reset"></i>Log
            </button>
        </div>
    </div>
</script>
<script type="text/html" id="table-toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-xs layui-btn-primary" lay-event="tweet" lay-tips="发送推文">
            <i class="layui-icon layui-icon-play"></i></button>
        <button class="layui-btn layui-btn-xs" lay-event="modify">
            <i class="layui-icon layui-icon-edit"></i>
        </button>
        <button class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del">
            <i class="layui-icon layui-icon-delete"></i>
        </button>
        <button class="layui-btn layui-btn-xs layui-btn-primary" lay-event="log" data-value="twitter" lay-tips="查看日志">
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
                {field: 'name', title: '名称', width: 150, sort: true},
                {
                    field: 'enabled', title: '启用定时', width: 100, align: 'center',
                    event: 'enabled', templet: function (d) {
                        return '<input type="checkbox" lay-skin="switch" lay-text="启用|禁用"' + (d.enabled ? ' checked' : '') + '>';
                    }
                },
                {
                    field: 'made', title: '编译推图', width: 100, align: 'center',
                    event: 'made', templet: function (d) {
                        return '<input type="checkbox" lay-skin="switch" lay-text="启用|禁用"' + (d['made'] ? ' checked' : '') + '>';
                    }
                },
                {field: 'spec', title: '定时规则', hide: true},
                {field: 'user_ids', title: '用户列表', hide: true},
                {field: 'texts', title: '文本列表', hide: true},
                {field: 'tags', title: 'Tag列表'},
                {
                    field: 'updated', title: '时间', align: 'center', sort: true, width: 180,
                    templet: function (d) {
                        return main.timestampFormat(d['updated']);
                    }
                },
                {title: '操作', width: 120, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
            ]],
            done: function () {
                element.render();
            },
        }, {
            tweet: function (obj, ids) {
                if (main.isArray(ids)) {
                    if (ids.length === 0) {
                        return layer.msg("未选择")
                    }
                    return main.request({
                        url: url,
                        data: {ids: ids.join(), action: 'tweet'},
                    });
                }
                main.request({
                    url: url,
                    data: {id: obj.data.id, action: 'tweet'},
                    done: function () {
                        main.ws.log("twitter." + obj.data.id);
                        return false
                    }
                });
            },
            made: function (obj) {
                let $this = $(this);
                let enabled = !!$this.find('div.layui-unselect.layui-form-onswitch').size();
                main.request({
                    url: url + "/modify",
                    data: {id: obj.data.id, made: enabled, cols: 'made'},
                    error: function () {
                        $this.find('input[type=checkbox]').prop('checked', !enabled);
                        form.render('checkbox');
                    }
                });
            },
            enabled: function (obj, ids) {
                if (main.isArray(ids)) {
                    return main.request({
                        url: url + "/modify",
                        data: {ids: ids.join(), enabled: true, cols: 'enabled'},
                        done: 'table-list',
                    });
                }
                let $this = $(this);
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
            disable: function (obj, ids) {
                if (main.isArray(ids)) {
                    return main.request({
                        url: url + "/modify",
                        data: {ids: ids.join(), enabled: false, cols: 'enabled'},
                        done: 'table-list',
                    });
                }
            },
            add: function () {
                main.get(url + '/add', function (html) {
                    main.popup({
                        title: '添加规则',
                        url: url + '/add',
                        area: ['800px', '95%'],
                        content: html,
                        done: 'table-list'
                    });
                });
            },
            modify: function (obj) {
                main.get(url + '/modify', obj.data, function (html) {
                    main.popup({
                        title: '修改规则',
                        content: html,
                        area: ['800px', '95%'],
                        url: url + '/modify',
                        done: 'table-list',
                    });
                });
            },
        });
    });
</script>