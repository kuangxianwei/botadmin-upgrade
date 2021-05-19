<div class="layui-card">
    <div class="layui-card-body">
        <div class="layui-form table-search" style="left: 400px">
            <div class="layui-inline">
                <input type="text" name="value" class="layui-input" placeholder="输入搜索...">
            </div>
            <button class="layui-btn layui-btn-sm" lay-submit lay-filter="search">
                <i class="layui-icon layui-icon-search"></i>
            </button>
        </div>
        <table id="table-list" lay-filter="table-list"></table>
    </div>
</div>
<div class="layui-hide" id="import"></div>
<script type="text/html" id="toolbar">
    <div class="layui-btn-group">
        <a class="layui-btn layui-btn-sm" lay-href="/tags/collect" lay-text="定时采集Tags">
            <i class="layui-icon layui-icon-add-circle"></i>采集
        </a>
        <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="add" lay-tips="手工添加Tags">
            <i class="layui-icon layui-icon-add-circle"></i>手工
        </button>
    </div>
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm" lay-event="export" lay-tips="导出Tags">
            <i class="layui-icon iconfont icon-export"></i>
        </button>
        <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="import" lay-tips="导入Tags">
            <i class="layui-icon iconfont icon-import"></i>
        </button>
    </div>
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="del" lay-tips="删除选中项">
            <i class="layui-icon layui-icon-delete"></i>
        </button>
        <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="truncate">清空</button>
    </div>
</script>
<script type="text/html" id="table-toolbar">
    <a class="layui-btn layui-btn-danger layui-btn-xs layui-btn-danger" lay-event="del"><i
                class="layui-icon layui-icon-delete"></i>删除</a>
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let form = layui.form,
            table = layui.table,
            main = layui.main,
            url = {{.current_uri}};
        url = url || '';
        layui.upload.render({
            headers: {'X-CSRF-Token':{{.csrf_token}}},
            elem: '#import',
            url: url + '/import',
            accept: 'file',
            exts: 'conf|txt',
            before: function () {
                layer.load(); //上传loading
            },
            done: function (res) {
                layer.closeAll('loading'); //关闭loading
                if (res.code === 0) {
                    layer.msg(res.msg);
                    table.reload('table-list');
                } else {
                    layer.alert(res.msg, {icon: 2});
                }
            },
        });

        //日志管理
        table.render({
            headers: {'X-CSRF-Token':{{.csrf_token}}},
            method: 'post',
            elem: '#table-list',
            toolbar: '#toolbar',
            url: {{.current_uri}},
            cols: [[
                {type: 'checkbox', fixed: 'left'},
                {field: 'id', hide: true},
                {type: 'numbers', width: 80, title: 'ID', sort: true},
                {field: 'value', title: 'Tag'},
                {
                    field: 'updated', title: '时间', width: 150, sort: true, templet: function (d) {
                        return main.timestampFormat(d['updated']);
                    }
                },
                {title: '操作', width: 150, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
            ]],
            page: true,
            limit: 10,
            limits: [10, 50, 100, 500],
            text: '对不起，加载出现异常！'
        });
        //监听工具条
        table.on('tool(table-list)', function (obj) {
            let data = obj.data;
            if (obj.event === 'del') {
                layer.confirm('确定删除此条日志？', function (index) {
                    main.req({
                        url: url + '/del',
                        data: {'id': data.id},
                        index: index,
                        ending: obj.del
                    });
                });
            }
        });

        //头工具栏事件
        table.on('toolbar(table-list)', function (obj) {
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
                        main.req({
                            url: url + '/del',
                            data: {'ids': ids.join()},
                            index: index,
                            ending: 'table-list'
                        });
                    });
                    break;
                case 'add':
                    main.popup({
                        title: '添加Tags',
                        url: url + '/add',
                        content: '<div class="layui-card layui-form" style="height: 98%">' +
                            '<textarea class="layui-textarea" name="values" style="height: 100%" placeholder="输入关键词一行一个"></textarea>' +
                            '<button class="layui-hide" lay-submit lay-filter="submit"></bbutton>' +
                            '</div>',
                        ending: 'table-list'
                    });
                    break;
                case 'truncate':
                    layer.confirm('清空全部Tags', function (index) {
                        main.req({
                            url: url + '/reset',
                            index: index,
                            ending: function () {
                                table.reload('table-list');
                            }
                        });
                    });
                    break;
                case 'export':
                    window.open(encodeURI(url + '/export?ids=' + ids.join()));
                    break;
                case 'import':
                    $('#import').click();
                    break;
            }
        });

        //监听搜索
        form.on('submit(search)', function (data) {
            //执行重载
            table.reload('table-list', {
                where: data.field,
                page: {curr: 1}
            });
            return false;
        });
        // enter 搜索
        $('input[name=value]').keydown(function (event) {
            if (event.keyCode === 13) {
                $('[lay-filter="search"]').click();
            }
        });
    });
</script>
