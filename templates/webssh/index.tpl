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
                <label class="layui-form-label">协程:</label>
                <div class="layui-input-inline">
                    <input type="number" name="thread" value="10" max="30" class="layui-input">
                </div>
                <div class="layui-form-mid layui-word-aux">协程太多容易卡死或出错</div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">快捷:</label>
                <div class="layui-input-block">
                    <input type="radio" name="action" value="restart-app" title="重启APP" lay-filter="action" checked>
                    <input type="radio" name="action" value="reboot" lay-filter="action" title="服务器重启">
                    <input type="radio" name="action" value="shutdown" lay-filter="action" title="服务器关机">
                    <input type="radio" name="action" value="restart-lnmp" lay-filter="action" title="LNMP重启">
                    <input type="radio" name="action" value="scp" lay-filter="action" title="Scp">
                    <input type="radio" name="action" value="ssh-code" lay-filter="action" title="自定义代码">
                </div>
            </div>
            <div class="layui-form-item" id="stdin"></div>
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
            <button class="layui-btn layui-btn-sm layui-bg-cyan" lay-event="scan" lay-tips="批量检查控制台">
                <i class="iconfont icon-scan"></i>
            </button>
            <button class="layui-btn layui-btn-sm" lay-event="control-version" lay-tips="批量获取控制端版本">
                <i class="iconfont layui-icon-vercode"></i>
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
        url = url || '';
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
                {field: 'host', title: '主机', width: 160},
                {field: 'port', title: '端口', hide: true},
                {field: 'user', title: '用户名', hide: true},
                {
                    title: '控制台', width: 120, event: "login", align: 'center', templet: function (d) {
                        return '<button class="layui-btn layui-btn-xs"><i class="layui-icon layui-icon-username"></i> ' + (d['control_version'] ? d['control_version'] : 'unknown') + '</button>';
                    }
                },
                {
                    title: '设为默认', width: 120, event: "is_default", align: 'center', templet: function (d) {
                        if (d['is_default']) {
                            return `<button class="layui-btn layui-btn-xs">默认</button>`;
                        }
                        return `<button class="layui-btn layui-btn-xs layui-btn-primary">设为默认</button>`;
                    }
                },
                {field: 'auth', title: "认证", hide: true},
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
                            title: '修改SSH配置',
                            url: url + '/modify',
                            area: '700px',
                            content: html,
                            ending: 'table-list',
                        });
                    });
                    break;
                case 'login':
                    $.get(url + '/login', {id: data.id}, function (link) {
                        if (link) {
                            window.open(link, "_blank");
                        }
                    });
                    break;
                case 'execute':
                    main.webssh({id: data.id});
                    break;
                case 'log':
                    main.ws.log("webssh." + data.id);
                    break;
                case 'is_default':
                    main.req({
                        url: url + "/default",
                        data: {id: data.id},
                        ending: 'table-list',
                    });
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
                            title: '添加webSSH',
                            url: url + '/add',
                            area: '700px',
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
                                switch (obj.value) {
                                    case "ssh-code":
                                        dom.find("#stdin").html(`<textarea name="stdin" class="layui-textarea" rows="5" placeholder="cd ~ && ls -a" lay-verify="required"></textarea>`).find("textarea").blur(function () {
                                            localStorage.setItem("ssh-code", $(this).val());
                                        }).val(localStorage.getItem("ssh-code") || "");
                                        break;
                                    case "scp":
                                        dom.find("#stdin").html(`<div class="layui-input-block"><input type="text" name="stdin" placeholder="/本地路径 /远程路径" class="layui-input" lay-verify="required"></div>`);
                                        break;
                                    default:
                                        dom.find("#stdin").empty();
                                }
                            });
                            dom.find('[name=thread]').val(localStorage.getItem("ssh-thread") || 10).blur(function () {
                                localStorage.setItem("ssh-thread", $(this).val());
                            });
                        },
                        area: "600px",
                        tips: function () {
                            main.ws.log("webssh.0");
                        }
                    });
                    break;
                case 'scan':
                    if (ids.length === 0) {
                        return main.err('请选择数据');
                    }
                    main.req({
                        url: url + "/scan",
                        data: {ids: ids.join()},
                        tips: function () {
                            main.ws.log("webssh.0");
                        }
                    });
                    break;
                case 'control-version':
                    if (ids.length === 0) {
                        return main.err('请选择数据');
                    }
                    main.req({
                        url: url + "/version",
                        data: {ids: ids.join()},
                    });
                    break;
            }
        });
        // 监听搜索
        main.onSearch();
    });
</script>