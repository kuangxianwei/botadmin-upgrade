<div class="layui-card">
	<div class="layui-card-body">
		<div class="layui-form table-search" style="left: 520px">
			<div class="layui-inline">
				<input type="search" name="search" class="layui-input" placeholder="输入搜索...">
			</div>
			<button class="layui-btn layui-btn-sm" lay-submit="" lay-filter="search">
				<i class="layui-icon layui-icon-search"></i>
			</button>
		</div>
		<table id="table-list" lay-filter="table-list"></table>
	</div>
</div>
<script type="text/html" id="modify">
	<div class="layui-card">
		<div class="layui-card-body layui-form">
			<div class="layui-form-item">
				<label class="layui-form-label">URL:</label>
				<div class="layui-input-block">
					<input name="url" value="" class="layui-input">
				</div>
			</div>
			<div class="layui-form-item">
				<label class="layui-form-label">备注:</label>
				<div class="layui-input-block">
					<input name="note" value="" class="layui-input">
				</div>
			</div>
			<div class="layui-hide">
				<input type="hidden" name="id" value="">
				<button class="layui-hide" lay-submit lay-filter="submit">提交</button>
			</div>
		</div>
	</div>
</script>
<script type="text/html" id="toolbar">
	<div class="layui-btn-group">
		<button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="add" lay-tips="添加配置">
			<i class="layui-icon layui-icon-add-circle"></i>
			添加配置
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
		<button class="layui-btn layui-btn-xs" lay-event="modify">
			<i class="layui-icon layui-icon-edit"></i>
		</button>
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
        let main = layui.main;
        main.upload();
        //日志管理
        main.table([[
            {type: 'checkbox', fixed: 'left'},
            {field: 'id', width: 80, title: 'ID', align: 'center', hide: true},
            {field: 'url', title: 'URL', event: 'copy', sort: true},
            {field: 'note', title: '备注', width: 180},
            {
                field: 'updated', title: '时间', align: 'center', sort: true, width: 180, templet: function (d) {
                    return main.timestampFormat(d['updated']);
                }
            },
            {title: '操作', width: 120, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
        ]], {
            add: function () {
                main.popup({
                    title: `添加推送配置 $&#123;random1-8&#125`,
                    url: URL + '/add',
                    content: '<div class="layui-card layui-form" style="height: 98%">' +
                        '<textarea class="layui-textarea" name="urls" style="height: 100%" placeholder="https://www.chowan.edu/search/${keyword}${random}   备注">https://www.chowan.edu/search/${keyword}.${random}   备注</textarea>' +
                        '<button class="layui-hide" lay-submit lay-filter="submit"></button>' +
                        '</div>',
                    done: 'table-list'
                });
            },
            modify: function (obj) {
                main.popup({
                    title: '修改规则',
                    content: $('#modify').html(),
                    area: ['600px', '280px'],
                    success: function (dom) {
                        dom.find('input[name=url]').val(obj.data.url);
                        dom.find('input[name=note]').val(obj.data.note);
                        dom.find('input[name=id]').val(obj.data.id);
                    },
                    url: URL + '/modify',
                    done: 'table-list',
                });
            },
        });
    });
</script>