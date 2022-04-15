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
            version = {{.version}};
        version = version || 'v0';
        version = parseInt(version.replaceAll(/[v.]/g, ''));
        //渲染上传配置
        layui.upload.render({
            headers: {'X-CSRF-Token': csrfToken},
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
            headers: {'X-CSRF-Token': csrfToken},
            method: 'post',
            elem: '#table-list',
            toolbar: '#toolbar',
            url: url,
            cols: [[
                {type: 'checkbox', fixed: 'left'},
                {field: 'id', title: 'ID', hide: true},
                {field: 'alias', title: '别名', sort: true},
                {field: 'host', title: '主机', width: 160},
                {field: 'port', title: '端口', hide: true},
                {field: 'user', title: '用户名', hide: true},
                {
                    title: '控制台', width: 120, event: "login", align: 'center', templet: function (d) {
                        let controlVersion = d['control_version'] ? d['control_version'] : 'unknown',
                            verInt = parseInt(controlVersion.replaceAll(/[v.]/g, ''));
                        if (isNaN(verInt) || verInt < version) {
                            return '<button class="layui-btn layui-btn-xs layui-bg-red"><i class="layui-icon layui-icon-username"></i> ' + controlVersion + '</button>';
                        }
                        return '<button class="layui-btn layui-btn-xs"><i class="layui-icon layui-icon-username"></i> ' + controlVersion + '</button>';
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
            limit: 20,
            limits: [20, 50, 100, 500, 1000],
            text: '对不起，加载出现异常！'
        });
        let active = {
                del: function (obj) {
                    layer.confirm('确定删除此条配置？', function (index) {
                        main.request({
                            url: url + "/del",
                            data: {'id': obj.data.id},
                            index: index,
                            done: obj.del
                        });
                    });
                },
                modify: function (obj) {
                    let loading = layui.main.loading();
                    $.get(url + '/modify', {id: obj.data.id}, function (html) {
                        loading.close();
                        main.popup({
                            title: '修改SSH配置',
                            url: url + '/modify',
                            area: '700px',
                            content: html,
                            done: 'table-list',
                        });
                    });
                },
                login: function (obj) {
                    let loading = layui.main.loading();
                    $.get(url + '/login', {id: obj.data.id}, function (link) {
                        loading.close();
                        if (link) {
                            window.open(link, "_blank");
                        }
                    });
                },
                execute: function (obj) {
                    main.webssh({id: obj.data.id});
                },
                log: function (obj) {
                    main.ws.log("webssh." + obj.data.id);
                },
                is_default: function (obj) {
                    main.request({
                        url: url + "/default",
                        data: {id: obj.data.id},
                        done: 'table-list',
                    });
                }
            },
            activeBar = {
                add: function () {
                    let loading = layui.main.loading();
                    $.get(url + '/add', {}, function (html) {
                        loading.close();
                        main.popup({
                            title: '添加webSSH',
                            url: url + '/add',
                            area: '700px',
                            content: html,
                            done: 'table-list',
                        });
                    });
                },
                del: function (data, ids) {
                    if (ids.length === 0) {
                        return main.err('请选择数据');
                    }
                    layer.confirm('删除后不可恢复，确定删除吗？', function (index) {
                        main.request({
                            url: url + '/del',
                            data: {ids: ids.join()},
                            index: index,
                            done: 'table-list'
                        });
                    });
                },
                export: function (data, ids) {
                    if (ids.length === 0) {
                        return main.err('请选择数据');
                    }
                    window.open(encodeURI('/webssh/export?ids=' + ids.join()));
                },
                import: function () {
                    $('#import').click();
                },
                log: function () {
                    main.ws.log("webssh.0");
                },
                execute: function (data, ids) {
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
                                        dom.find("#stdin").html(`<div class="layui-input-block"><input type="text" name="stdin" placeholder="/本地路径 /远程路径" class="layui-input" lay-verify="required"></div>`).find('input[name=stdin]').blur(function () {
                                            localStorage.setItem("ssh-scp", $(this).val())
                                        }).val(localStorage.getItem("ssh-scp") || "")
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
                        done: function () {
                            main.ws.log("webssh.0");
                            return false;
                        }
                    });
                },
                scan: function (data, ids) {
                    if (ids.length === 0) {
                        return main.err('请选择数据');
                    }
                    main.request({
                        url: url + "/scan",
                        data: {ids: ids.join()},
                        done: function () {
                            main.ws.log("webssh.0");
                            return false;
                        }
                    });
                },
                controlVersion: function () {
                    main.request({
                        url: url + "/version", done: function () {
                            return false;
                        }
                    });
                }
            };
        //监听工具条
        table.on('tool(table-list)', function (obj) {
            active[obj.event] && active[obj.event].call(this, obj);
        });
        //头工具栏事件
        table.on('toolbar(table-list)', function (obj) {
            let data = table.checkStatus(obj.config.id).data,
                ids = [];
            layui.each(data, function (i, v) {
                ids[i] = v.id;
            });
            activeBar[obj.event] && activeBar[obj.event].call(obj, data, ids);
        });
        // 监听搜索
        main.onSearch();
        setTimeout(function () {
            activeBar.controlVersion();
        }, 1000);
    });
</script>