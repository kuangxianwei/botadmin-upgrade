<div class="layui-card">
    <div class="layui-card-body">
        <div class="layui-form table-search" style="left: 260px">
            <button class="layui-hide" lay-submit lay-filter="search">
                <i class="layui-icon layui-icon-search"></i>
            </button>
            <div class="layui-inline">
                <div class="layui-input-inline">
                    <select name="waiter_id" lay-filter="search-select" class="layui-select">
                        <option value="">选择全部客服</option>
                        {{range $i,$v:=.waiters -}}
                            <option value="{{$v.Id}}">{{$v.Alias}}</option>
                        {{end -}}
                    </select>
                </div>
            </div>
            <div class="layui-inline">
                <input type="text" name="search" class="layui-input" placeholder="广州">
            </div>
            <div class="layui-inline">
                <div class="layui-input-inline">
                    <select name="duration" lay-filter="search-select" class="layui-select">
                        {{range $i,$v:=.durations -}}
                            <option value="{{$i}}">{{$v}}</option>
                        {{end -}}
                    </select>
                </div>
            </div>
        </div>
        <table id="table-list" lay-filter="table-list"></table>
    </div>
</div>
<script type="text/html" id="toolbar">
    <div class="layui-btn-group">
        <div class="layui-btn-group">
            <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="del" lay-tips="删除选中项">
                <i class="layui-icon layui-icon-delete"></i>
            </button>
            <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="truncate">清空</button>
        </div>
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
        <button class="layui-btn layui-btn-xs" lay-event="view" lay-tips="查看详情">
            <i class="iconfont icon-view"></i>
        </button>
        <button class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del">
            <i class="layui-icon layui-icon-delete"></i>
        </button>
    </div>
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let table = layui.table,
            main = layui.main,
            searchWaiterId = main.getParam('waiter_id'),
            tableOptions = {
                headers: {'X-CSRF-Token': csrfToken},
                method: 'post',
                elem: '#table-list',
                url: url,
                toolbar: '#toolbar',
                cols: [[
                    {type: 'checkbox', fixed: 'left'},
                    {field: 'id', title: 'ID', hide: true},
                    {field: 'waiter_id', title: '客服ID', hide: true},
                    {field: 'waiter_alias', width: 80, title: '客服', align: 'center'},
                    {
                        title: '终端', width: 80, templet: function (d) {
                            if (d['is_mobile']) {
                                return "手机端";
                            }
                            return "电脑端";
                        }
                    },
                    {field: 'name', title: '昵称', minWidth: 100},
                    {field: 'phone', title: '电话', minWidth: 100},
                    {field: 'wechat', title: '微信', minWidth: 100},
                    {field: 'message', title: '反馈', minWidth: 100},
                    {
                        title: 'IP', hide: true, templet: function (d) {
                            return d.ip;
                        }
                    },
                    {
                        title: '区域', minWidth: 100, templet: function (d) {
                            if (d['city']) {
                                return d['city'];
                            }
                            if (d['province']) {
                                return d['province'];
                            }
                            if (d['isp']) {
                                return d['isp'];
                            }
                            if (d['country']) {
                                return d['country'];
                            }
                            return '未知';
                        }
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
                limits: [10, 30, 50, 200],
                text: '对不起，加载出现异常！'
            };
        if (searchWaiterId) {
            $('select[name=waiter_id]>option[value=' + searchWaiterId + ']').attr('selected', true);
            layui.form.render('select');
            tableOptions = $.extend(tableOptions, {where: {waiter_id: searchWaiterId}});
        }
        //日志管理
        table.render(tableOptions);
        let active = {
                'del': function (obj) {
                    layer.confirm('删除后不可恢复，确定删除？', function (index) {
                        main.req({
                            url: url + '/del',
                            data: obj.data,
                            index: index,
                            ending: 'table-list'
                        });
                    });
                },
                'view': function (obj) {
                    let loading = layui.main.loading();
                    $.get(url + "/view", {id: obj.data.id}, function (content) {
                        loading.close();
                        main.display({
                            content: '<textarea class="layui-textarea" style="border-radius:20px;width:98%;height:96%;margin:1%">' + content + '</textarea>',
                            area: ['80%', '80%'],
                        });
                    });
                },
            },
            activeBar = {
                'del': function (obj, data, ids) {
                    if (data.length === 0) {
                        return layer.msg('请选择数据');
                    }
                    layer.confirm('删除后不可恢复，确定删除吗？', function (index) {
                        main.req({
                            url: url + '/del',
                            data: {'ids': ids.join()},
                            index: index,
                            ending: 'table-list'
                        });
                    });
                },
                'truncate': function () {
                    layer.confirm('清空全不可恢复', function (index) {
                        main.req({
                            url: url + '/reset',
                            index: index,
                            ending: 'table-list'
                        });
                    });
                },
                'reset-record': function (obj, data, ids) {
                    main.reset.log('feedback', ids);
                },
                'log': function () {
                    main.ws.log('feedback.0');
                },
            };
        //监听工具条
        table.on('tool(table-list)', function (obj) {
            active[obj.event] && active[obj.event].call(this, obj);
        });
        //监听工具栏
        table.on('toolbar(table-list)', function (obj) {
            let data = table.checkStatus(obj.config.id).data, ids = [];
            for (let i = 0; i < data.length; i++) {
                ids[i] = data[i].id;
            }
            activeBar[obj.event] && activeBar[obj.event].call(this, obj, data, ids);
        });
        // 搜索
        main.onSearch();
    });
</script>