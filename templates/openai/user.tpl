<div class="layui-card">
	<div class="layui-card-header layuiadmin-card-header-auto">
		<div class="layui-form-item layui-form" lay-event="search">
			<div class="layui-inline">
				<label class="layui-form-label">搜索类型:</label>
				<div class="layui-input-block">
					<select lay-filter="search-type">
						<option value="search">全部</option>
						<option value="key">秘钥</option>
						<option value="username">账号</option>
						<option value="enabled">启用</option>
						<option value="disabled">禁用</option>
						<option value="type">状态类型</option>
						<option value="message">提示信息</option>
						<option value="http_code">状态码</option>
					</select>
				</div>
			</div>
			<div class="layui-inline">
				<div class="layui-input-inline">
					<input id="search-input" type="text" name="search" placeholder="搜索..." class="layui-input">
				</div>
			</div>
			<div class="layui-inline">
				<button class="layui-btn" data-type="reload" lay-submit lay-filter="search">
					<i class="layui-icon layui-icon-search layuiadmin-button-btn"></i>
				</button>
			</div>
		</div>
	</div>
	<div class="layui-card-body">
		<table id="table-list" lay-filter="table-list"></table>
	</div>
</div>
<script type="text/html" id="toolbar">
	<div class="layui-btn-group">
		<button class="layui-btn layui-btn-sm" lay-event="add">
			<i class="layui-icon layui-icon-add-circle"></i>添加
		</button>
		<button class="layui-btn layui-btn-sm layui-btn-normal" lay-event="configure">
			<i class="layui-icon layui-icon-set"></i>
		</button>
		<button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="validate" lay-tips="验证KEY正常">
			<i class="layui-icon layui-icon-vercode"></i>
		</button>
		<button class="layui-btn layui-btn-sm" lay-event="rate" lay-tips="设置限速">
			<i class="iconfont icon-speed"></i>
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
		<button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="del" id="LAY_layer_iframe_del">
			<i class="layui-icon layui-icon-delete"></i>删除
		</button>
		<button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="truncate"
				id="LAY_layer_iframe_truncate" lay-tips="清空所有的数据，不可恢复！">
			<i class="layui-icon layui-icon-delete"></i>清空所有
		</button>
	</div>
	<div class="layui-btn-group">
		<button class="layui-btn layui-btn-sm" lay-event="log" lay-tips="查看日志">
			<i class="layui-icon layui-icon-log"></i>
		</button>
		<button class="layui-btn layui-btn-sm layui-bg-red" lay-event="resetLog" lay-tips="重置日志">
			<i class="layui-icon iconfont icon-reset"></i>Log
		</button>
	</div>
</script>
<script type="text/html" id="table-toolbar">
	<div class="layui-btn-group">
		<button class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del" lay-tips="删除后不可恢复!">
			<i class="layui-icon layui-icon-delete"></i>
		</button>
		<button class="layui-btn layui-btn-xs" lay-event="modify"><i class="layui-icon layui-icon-edit"></i></button>
		<button class="layui-btn layui-btn-xs layui-btn-primary" lay-event="log" lay-tips="查看日志">
			<i class="layui-icon layui-icon-log"></i>
		</button>
		<button class="layui-btn layui-btn-xs layui-bg-cyan" lay-event="status" lay-tips="查看使用状态">
			<i class="iconfont icon-speed"></i>
		</button>
	</div>
</script>
<script type="text/html" id="configure">
	<div class="layui-card">
		<div class="layui-card-body layui-form">
			<div class="layui-form-item">
				<label for="enabled" class="layui-form-label">启用:</label>
				<div class="layui-input-inline">
					<input type="checkbox" name="enabled" id="enabled" lay-skin="switch" lay-text="是|否" checked>
				</div>
				<i class="layui-icon layui-icon-delete" lay-event="del"></i>
			</div>
			<div class="layui-hide">
				<input type="hidden" name="ids" value="">
				<button class="layui-hide" lay-submit lay-filter="submit">提交</button>
			</div>
		</div>
	</div>
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let main = layui.main,
            table = layui.table,
            form = layui.form;
        main.upload();
        main.table([[
            {type: 'checkbox', fixed: 'left'},
            {field: 'id', width: 80, title: 'ID', align: 'center', hide: true},
            {
                field: 'enabled', title: '启用', width: 100, align: 'center',
                event: 'switch', templet: function (d) {
                    return '<input type="checkbox" lay-skin="switch" lay-text="启用|禁用"' + (d.enabled ? ' checked' : '') + '>';
                }
            },
            {field: 'username', title: '用户名', event: 'copy'},
            {field: 'password', title: '密码', event: 'copy'},
            {field: 'key', title: '秘钥', event: 'copy'},
            {
                field: 'http_code', width: 90, title: '状态码', align: 'center', templet: (d) => {
                    return d['http_code'] || 0
                }
            },
            {field: 'message', title: '提示', event: 'copy'},
            {
                field: 'updated', hide: true, title: '时间', align: 'center', sort: true, templet: function (d) {
                    return main.timestampFormat(d['updated']);
                }
            },
            {title: '操作', width: 140, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
        ]], {
            add: function () {
                main.popup({
                    title: '添加Token',
                    url: URL + '/add',
                    area: ['80%', '90%'],
                    content: '<div class="layui-card layui-form" style="height: 98%">' +
                        '<textarea class="layui-textarea" name="values" style="height: 100%" placeholder="输入配置一行一个&#10;用户名----密码----key&#10;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"></textarea>' +
                        '<button class="layui-hide" lay-submit lay-filter="submit"></bbutton>' +
                        '</div>',
                    done: 'table-list'
                });
            },
            configure: function (obj, ids) {
                if (ids.length === 0) {
                    return layer.msg('请选中数据');
                }
                main.popup({
                    title: '批量修改配置',
                    content: $('#configure').html(),
                    area: '400px',
                    success: function (dom) {
                        dom.find('[name=ids]').val(ids.join());
                        main.on.del();
                    },
                    url: URL + '/modify',
                    done: 'table-list',
                });
            },
            modify: function (obj) {
                main.get(URL + '/modify', {id: obj.data.id}, function (html) {
                    main.popup({
                        title: '修改账号信息',
                        content: html,
                        url: URL + '/modify',
                        area: ['620px', '300px'],
                        done: 'table-list',
                    });
                });
            },
            validate: function (obj, ids) {
                main.request({
                    url: URL + '/validate',
                    data: {ids: ids.join()},
                    done: function () {
                        main.ws.log();
                        return false;
                    }
                })
            },
            status: function (obj) {
                main.get(URL + '/status', {id: obj.data.id}, function (res) {
                    layer.alert(res.msg, {title: false, btn: false});
                });
            },
            rate: function () {
                main.get(URL + '/rate', function (html) {
                    main.popup({
                        title: '修改限速',
                        content: html,
                        url: URL + '/rate',
                        area: ['620px', '300px'],
                    });
                });
            }
        });
        // 监听搜索
        form.on('select(search-type)', function (obj) {
            let ele = $('#search-input');
            switch (obj.value) {
                case 'disabled':
                    table.reload('table-list', {
                        where: {cols: 'enabled', enabled: false, page: {curr: 1}}
                    });
                    ele.hide().val('');
                    break;
                case 'enabled':
                    table.reload('table-list', {
                        where: {
                            cols: 'enabled',
                            enabled: true,
                            page: {curr: 1}
                        }
                    });
                    ele.hide().val('');
                    break;
                case 'http_code':
                    ele.show().attr({type: 'number', name: obj.value}).val('');
                    table.reload('table-list', {where: {page: {curr: 1}}});
                    break;
                default:
                    ele.show().attr({type: 'text', name: obj.value}).val('');
                    table.reload('table-list', {where: {page: {curr: 1}}});
            }
        });
    });
</script>