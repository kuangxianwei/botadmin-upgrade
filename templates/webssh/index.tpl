<div class="layui-card">
    <div class="layui-card-body">
        <div class="layui-form table-search" style="left: 380px">
            <button class="layui-hide" lay-submit lay-filter="search">
                <i class="layui-icon layui-icon-search"></i>
            </button>
            <div class="layui-inline">
                <div class="layui-input-inline">
                    <input type="text" name="host" value="" placeholder="搜索:host/别名" class="layui-input">
                </div>
            </div>
        </div>
        <table id="table-list" lay-filter="table-list"></table>
    </div>
</div>
<div class="layui-hide" id="import"></div>
<script type="text/html" id="execute">
    <div class="layui-card">
        <div class="layui-card-body layui-form">
            <button class="layui-hide" lay-submit></button>
            <div class="layui-form-item">
                <label class="layui-form-label">快捷:</label>
                <div class="layui-input-block">
                    <input type="radio" name="action" value="restart-app" title="重启APP" lay-filter="action" checked>
                    <input type="radio" name="action" value="reboot" lay-filter="action" title="服务器重启">
                    <input type="radio" name="action" value="shutdown" lay-filter="action" title="服务器关机">
                    <input type="radio" name="action" value="restart-lnmp" lay-filter="action" title="LNMP重启">
                    <input type="radio" name="action" value="custom-code" lay-filter="action" title="自定义代码">
                </div>
            </div>
            <div class="layui-form-item layui-hide" id="stdin">
                <textarea name="stdin" class="layui-textarea" rows="5" placeholder="ls -a"></textarea>
            </div>
        </div>
    </div>
</script>
<script type="text/html" id="toolbar">
    <div class="layui-btn-container">
        <div class="layui-btn-group">
            <button class="layui-btn layui-btn-sm" lay-event="add">
                <i class="layui-icon layui-icon-add-circle"></i>
            </button>
            <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="del">
                <i class="layui-icon layui-icon-delete"></i>
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
            <button class="layui-btn layui-btn-sm" lay-event="execute" lay-tips="批量执行shell代码">
                <i class="iconfont icon-terminal"></i>
            </button>
            <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="log" lay-tips="查看日志">
                <i class="layui-icon layui-icon-log"></i>
            </button>
        </div>
    </div>
</script>
<script type="text/html" id="table-toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-xs layui-btn-primary" lay-event="execute">
            <i class="iconfont icon-terminal"></i>
        </button>
        <button class="layui-btn layui-btn-xs" lay-event="modify">
            <i class="layui-icon layui-icon-edit"></i></button>
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
            main = layui.main,
            form = layui.form,
            url = {{.current_uri}};
        //渲染上传配置
        layui.upload.render({
            headers: {'X-CSRF-Token':{{.csrf_token}}},
            elem: '#import',
            url: url + '/import',
            accept: 'file',
            exts: 'txt|conf|json',
            before: function () {
                layer.load(); //上传loading
            },
            done: function (res) {
                layer.closeAll('loading'); //关闭loading
                if (res.code === 0) {
                    layer.msg(res.msg);
                    table.reload('table-list');
                } else {
                    main.err(res.msg);
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
                {field: 'id', title: 'ID', hide: true},
                {field: 'alias', title: '别名', sort: true},
                {field: 'host', title: '主机'},
                {field: 'port', title: '端口', hide: true},
                {field: 'user', title: '用户名'},
                {field: 'auth', title: "认证", hide: true},
                {field: 'passwd', title: '密码', hide: true},
                {field: 'ssh_key', title: '秘钥', hide: true},
                {
                    field: 'created', title: '创建时间', width: 160, align: 'center', sort: true, templet: function (d) {
                        return main.timestampFormat(d['created']);
                    }
                },
                {title: '操作', width: 180, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
            ],],
            page: true,
            limit: 10,
            limits: [10, 50, 100, 500, 1000],
            text: '对不起，加载出现异常！'
        });
        //监听工具条
        table.on('tool(table-list)', function (obj) {
            let data = obj.data;
            switch (obj.event) {
                case 'del':
                    layer.confirm('确定删除此条配置？', function (index) {
                        main.req({
                            url: url + "/del",
                            data: {'id': data.id},
                            index: index,
                            ending: obj.del
                        });
                    });
                    break;
                case 'modify':
                    $.get(url + '/modify', {id: data.id}, function (html) {
                        main.popup({
                            title: '修改翻译配置',
                            url: url + '/modify',
                            area: ['700px', '420px'],
                            content: html,
                            ending: 'table-list',
                        });
                    });
                    break;
                case 'execute':
                    main.webssh({id: data.id});
                    break;
                case 'log':
                    main.ws.log("webssh." + data.id);
                    break;
            }
        });
        //头工具栏事件
        table.on('toolbar(table-list)', function (obj) {
            let data = table.checkStatus(obj.config.id).data,
                ids = [];
            layui.each(data, function (i, v) {
                ids[i] = v.id;
            });
            switch (obj.event) {
                case 'add':
                    $.get(url + '/add', {}, function (html) {
                        main.popup({
                            title: '添加翻译配置',
                            url: url + '/add',
                            area: ['700px', '420px'],
                            content: html,
                            ending: 'table-list',
                        });
                    });
                    break;
                case 'del':
                    if (ids.length === 0) {
                        return main.err('请选择数据');
                    }
                    layer.confirm('删除后不可恢复，确定删除吗？', function (index) {
                        main.req({
                            url: url + '/del',
                            data: {ids: ids.join()},
                            index: index,
                            ending: 'table-list'
                        });
                    });
                    break;
                case 'export':
                    if (ids.length === 0) {
                        return main.err('请选择数据');
                    }
                    window.open(encodeURI('/webssh/export?ids=' + ids.join()));
                    break;
                case 'import':
                    $('#import').click();
                    break;
                case 'log':
                    main.ws.log("webssh.0");
                    break;
                case 'execute':
                    if (ids.length === 0) {
                        return main.err('请选择数据');
                    }
                    main.popup({
                        url: url + "/execute",
                        title: "批量执行shell",
                        content: $("#execute").html(),
                        success: function (dom) {
                            dom.find(".layui-form").append(`<input type="hidden" name="ids" value="` + ids.join() + `">`);
                            form.render();
                            form.on('radio(action)', function (obj) {
                                if (obj.value === "custom-code") {
                                    dom.find("#stdin").removeClass("layui-hide");
                                    dom.find("#stdin>textarea").attr("lay-verify", "required")
                                } else {
                                    dom.find("#stdin").addClass("layui-hide");
                                    dom.find("#stdin>textarea").removeAttr("lay-verify")
                                }
                            });
                        },
                        area: ["600px", "300px"],
                        tips: function () {
                            main.ws.log("webssh.0");
                        }
                    });
                    break;
            }
        });
        // 监听搜索
        main.onSearch();
    });
</script>