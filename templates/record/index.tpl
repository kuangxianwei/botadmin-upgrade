<div class="layui-card">
    <div class="layui-card-body">
        <div class="layui-tab layui-tab-card">
            <ul class="layui-tab-title">
                <li class="layui-this" style="color:#0a5b52">
                    <i class="layui-icon layui-icon-notice"></i>
                    <b>未读</b>
                </li>
                <li><b>已读</b></li>
            </ul>
            <div class="layui-tab-content">
                <div class="layui-form table-search" style="top:75px">
                    <div class="layui-inline">
                        <input type="text" autocomplete="off" name="search" class="layui-input" placeholder="输入搜索...">
                    </div>
                    <button class="layui-btn layui-btn-sm" lay-submit lay-filter="search">
                        <i class="layui-icon layui-icon-search"></i>
                    </button>
                </div>
                <div class="layui-tab-item layui-show">
                    <table id="table-list" lay-filter="table-list"></table>
                </div>
                <div class="layui-tab-item">
                    <table id="table-list-read" lay-filter="table-list-read"></table>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/html" id="tool">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="del" lay-tips="删除该项">
            <i class="layui-icon layui-icon-delete"></i>
        </button>
    </div>
</script>
<script type="text/html" id="toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm" lay-event="read" lay-tips="设为已读状态">
            <i class="layui-icon layui-icon-read"></i>
        </button>
        <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="del" lay-tips="删除选中">
            <i class="layui-icon layui-icon-delete"></i>
        </button>
    </div>
</script>
<script type="text/html" id="toolbar-read">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="del" lay-tips="删除选中">
            <i class="layui-icon layui-icon-delete"></i>
        </button>
        <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="truncate" lay-tips="清空全部 已读和未读都会被清空">
            清空
        </button>
    </div>
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let table = layui.table,
            main = layui.main,
            form = layui.form;
        // 未读消息
        main.table({
            cols: [[
                {type: 'checkbox', fixed: 'left'},
                {field: 'id', title: 'ID', hide: true},
                {field: 'level', title: 'Level', width: 80},
                {field: 'feedback', title: '反馈', sort: true, event: 'read', style: 'cursor:pointer;color:#22849a'},
                {field: 'position', title: '定位', hide: true},
                {
                    field: 'updated', title: '时间', width: 170, sort: true, templet: function (d) {
                        return main.timestampFormat(d['updated']);
                    }
                },
                {title: '操作', width: 150, align: 'center', fixed: 'right', toolbar: '#tool'}
            ]],
            where: {read: false},
        }, {
            del: function (obj, ids) {
                if (main.isArray(ids)) {
                    if (ids.length === 0) {
                        return layer.msg('请选择数据');
                    }
                    layer.confirm('删除后不可恢复，确定删除吗？', function (index) {
                        main.request({
                            url: url + '/sql/del',
                            data: {ids: ids.join()},
                            index: index,
                            done: 'table-list'
                        });
                    });
                    return
                }
                layer.confirm('确定删除此条日志？', function (index) {
                    main.request({
                        url: url + '/sql/del',
                        data: {id: obj.data.id},
                        index: index,
                        done: obj.del
                    });
                });
            },
            read: function (obj, ids) {
                if (main.isArray(ids)) {
                    main.request({
                        url: url + '/update',
                        data: {ids: ids.join(), read: true},
                        done: function () {
                            table.reload('table-list');
                            table.reload('table-list-read');
                        }
                    });
                    return
                }
                main.get(url + '/update', {'id': obj.data.id, read: true}, function (res) {
                    if (res.code === 0) {
                        table.reload('table-list');
                        table.reload('table-list-read');
                    } else {
                        layer.alert(res.msg, {icon: 2});
                    }
                });
                main.textarea(obj.data.feedback, {area: ['60%', '200px']});
            }
        });
        // 已读消息
        main.table('table-list-read', {
            toolbar: '#toolbar-read',
            cols: [[
                {type: 'checkbox', fixed: 'left'},
                {field: 'id', title: 'ID', hide: true},
                {field: 'level', title: 'Level', width: 80},
                {field: 'feedback', title: '反馈', sort: true, event: 'read', style: 'cursor:pointer'},
                {field: 'position', title: '定位', hide: true},
                {
                    field: 'updated', title: '时间', width: 170, sort: true, templet: function (d) {
                        return main.timestampFormat(d['updated']);
                    }
                },
                {title: '操作', width: 150, align: 'center', fixed: 'right', toolbar: '#tool'}
            ]],
            where: {read: true},
        });


        //监听工具条
        table.on('tool(table-list-read)', function (obj) {
            let data = obj.data;
            switch (obj.event) {
                case 'del':
                    layer.confirm('确定删除此条日志？', function (index) {
                        main.request({
                            url: url + '/sql/del',
                            data: {'id': data.id},
                            index: index,
                            done: obj.del
                        });
                    });
                    break;
                case 'read':
                    main.textarea(obj.data.feedback, {area: ['60%', '200px']});
                    break
            }
        });
        //头工具栏事件
        table.on('toolbar(table-list-read)', function (obj) {
            let checkStatus = table.checkStatus(obj.config.id),
                data = checkStatus.data, ids = [];
            for (let i = 0; i < data.length; i++) {
                ids[i] = data[i].id;
            }
            switch (obj.event) {
                case 'del':
                    if (data.length === 0) {
                        return layer.msg('请选择数据');
                    }
                    layer.confirm('删除后不可恢复，确定删除吗？', function (index) {
                        main.request({
                            url: url + '/sql/del',
                            data: {'ids': ids.join()},
                            index: index,
                            done: 'table-list-read'
                        });
                    });
                    break;
                case 'truncate':
                    layer.confirm('清空全部，未读和已读信息全部会被清空', function (index) {
                        main.request({
                            url: url + '/truncate',
                            index: index,
                            done: function () {
                                table.reload('table-list');
                                table.reload('table-list-read');
                            }
                        });
                    });
                    break
            }
        });
        // 监听搜索
        form.on('submit(search)', function (data) {
            let tableFilter = $('.layui-tab-item.layui-show>table').attr('lay-filter');
            data.field.read = tableFilter === 'table-list-read';
            //执行重载
            data.field.cols = 'search';
            table.reload(tableFilter, {
                where: data.field,
                page: {curr: 1}
            });
            return false;
        });
        // enter 搜索
        $('.table-search input,[lay-event=search] input').keydown(function (event) {
            if (event.keyCode === 13) {
                $('[lay-filter=search]').click();
            }
        });
    });
</script>