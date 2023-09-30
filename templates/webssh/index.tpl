<div class="layui-card">
	<div class="layui-card-body">
		<div class="layui-form table-search" style="left: 450px">
			<button class="layui-hide" lay-submit lay-filter="search">
				<i class="layui-icon layui-icon-search"></i>
			</button>
			<div class="layui-inline">
				<div class="layui-input-inline">
					<input type="search" name="search" value="" placeholder="搜索:host/别名" class="layui-input">
				</div>
			</div>
		</div>
		<table id="table-list" lay-filter="table-list"></table>
	</div>
</div>
<script type="text/html" id="execute">
	<div class="layui-card">
		<div class="layui-card-body layui-form">
			<button class="layui-hide" lay-submit></button>
			<div class="layui-form-item">
				<label for="thread" class="layui-form-label">协程:</label>
				<div class="layui-input-inline">
					<input type="number" name="thread" id="thread" value="10" max="30" class="layui-input">
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
			<button class="layui-btn layui-btn-sm" lay-event="controlVersion" lay-tips="批量更新控制台版本号">
				更新版本号
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
        let main = layui.main,
            form = layui.form,
            version = {{.version}};
        version = version || 'v0';
        version = parseInt(version.replaceAll(/[v.]/g, ''));
        //渲染上传配置
        main.upload();
        let table = main.table([[
            {type: 'checkbox', fixed: 'left'},
            {field: 'id', title: 'ID', hide: true},
            {field: 'alias', title: '别名', sort: true},
            {field: 'host', title: '主机', width: 160},
            {field: 'port', title: '端口', hide: true},
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
            {field: 'user', title: 'SSH用户名', hide: true},
            {field: 'passwd', title: 'SSH密码', width: 100, event: 'copy'},
            {field: 'control_username', title: '控制台用户', width: 100, event: 'copy'},
            {field: 'control_password', title: '控制台密码', width: 100, event: 'copy'},
            {
                title: '设为默认', width: 120, event: "setDefault", align: 'center', templet: function (d) {
                    if (d['is_default']) {
                        return `<button class="layui-btn layui-btn-xs">默认</button>`;
                    }
                    return `<button class="layui-btn layui-btn-xs layui-btn-primary">设为默认</button>`;
                }
            },
            {field: 'auth', title: "认证", hide: true},
            {
                field: 'created',
                title: '创建时间',
                width: 160,
                align: 'center',
                sort: true,
                hide: true,
                templet: function (d) {
                    return main.timestampFormat(d['created']);
                }
            },
            {title: '操作', width: 180, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
        ]], {
            modify: function (obj) {
                main.get(URL + '/modify', {id: obj.data.id}, function (html) {
                    main.popup({
                        title: '修改SSH配置',
                        url: URL + '/modify',
                        area: '700px',
                        content: html,
                        done: 'table-list',
                    });
                });
            },
            login: function (obj) {
                main.get(URL + '/login', {id: obj.data.id}, function (link) {
                    if (link) {
                        window.open(link, "_blank");
                    }
                });
            },
            setDefault: function (obj) {
                main.request({
                    url: URL + "/default",
                    data: {id: obj.data.id},
                    done: 'table-list',
                });
            },
            add: function () {
                main.get(URL + '/add', function (html) {
                    main.popup({
                        title: '添加webSSH',
                        url: URL + '/add',
                        area: '700px',
                        content: html,
                        done: 'table-list',
                    });
                });
            },
            execute: function (obj, ids) {
                if (!main.isArray(ids)) {
                    return main.webssh({id: obj.data.id});
                }
                if (ids.length === 0) {
                    return main.error('请选择数据');
                }
                main.popup({
                    url: URL + "/execute",
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
                                    dom.find("#stdin").html(`<div class="layui-input-block"><input type="text" name="stdin" id="stdin" placeholder="/本地路径 /远程路径" class="layui-input" lay-verify="required"></div>`).find('input[name=stdin]').blur(function () {
                                        localStorage.setItem("ssh-scp", $(this).val())
                                    }).val(localStorage.getItem("ssh-scp") || "");
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
                        main.ws.log();
                        return false;
                    }
                });
            },
            scan: function (obj, ids) {
                if (ids.length === 0) {
                    return main.error('请选择数据');
                }
                main.request({
                    url: URL + "/scan",
                    data: {ids: ids.join()},
                    done: function () {
                        main.ws.log();
                        return false;
                    }
                });
            },
            controlVersion: function (obj, ids) {
                main.request({
                    url: URL + "/version",
                    data: {ids: ids.join()},
                    done: function () {
                        main.ws.log();
                        return false;
                    }
                });
            }
        });
    });
</script>