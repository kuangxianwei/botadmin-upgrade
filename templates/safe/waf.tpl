<div class="layui-card">
	<div class="layui-card-body layui-form">
		<div class="layui-form-item">
			<label for="log_path" class="layui-form-label">日志目录:</label>
			<div class="layui-input-inline" style="min-width: 40%">
				<input class="layui-input" id="log_path" type="text" name="log_path" value="{{.obj.LogPath}}">
			</div>
			<div class="layui-form-mid layui-word-aux">存放攻击日志的目录</div>
		</div>
		<div class="layui-form-item">
			<label for="deny_upload_exts" class="layui-form-label">拒绝后缀:</label>
			<div class="layui-input-inline" style="min-width: 40%">
				<input class="layui-input" id="deny_upload_exts" type="text" name="deny_upload_exts"
					   value="{{join .obj.DenyUploadExts ","}}">
			</div>
			<div class="layui-form-mid layui-word-aux">拒绝上传文件的后缀</div>
		</div>
		<div class="layui-form-item">
			<label for="cc_rate" class="layui-form-label">CC频率:</label>
			<div class="layui-input-inline">
				<input class="layui-input" id="cc_rate" type="text" name="cc_rate" value="{{.obj.CCRate}}">
			</div>
			<div class="layui-form-mid layui-word-aux">设置cc攻击频率，单位为秒.
				默认1分钟同一个IP只能请求同一个地址100次
			</div>
		</div>
		<div class="layui-form-item">
			<label for="log_enabled" class="layui-form-label">启用日志:</label>
			<div class="layui-input-inline">
				<input type="checkbox" id="log_enabled" name="log_enabled" lay-skin="switch"
					   lay-text="启用|禁用"{{if .obj.LogEnabled}} checked{{end}}>
			</div>
			<div class="layui-form-mid layui-word-aux">是否启用攻击日志记录</div>
		</div>
		<div class="layui-form-item">
			<label for="url_enabled" class="layui-form-label">URL检查:</label>
			<div class="layui-input-inline">
				<input type="checkbox" id="url_enabled" name="url_enabled" lay-skin="switch"
					   lay-text="启用|禁用"{{if .obj.UrlEnabled}} checked{{end}}>
			</div>
			<div class="layui-form-mid layui-word-aux">是否启用URL检查</div>
		</div>
		<div class="layui-form-item">
			<label for="redirect_enabled" class="layui-form-label">跳转:</label>
			<div class="layui-input-inline">
				<input type="checkbox" id="redirect_enabled" name="redirect_enabled" lay-skin="switch"
					   lay-text="启用|禁用"{{if .obj.RedirectEnabled}} checked{{end}}>
			</div>
			<div class="layui-form-mid layui-word-aux">拦截后是否跳转到自定义拦截页面</div>
		</div>
		<div class="layui-form-item">
			<label for="cookie_enabled" class="layui-form-label">Cookie检查:</label>
			<div class="layui-input-inline">
				<input type="checkbox" id="cookie_enabled" name="cookie_enabled" lay-skin="switch"
					   lay-text="启用|禁用"{{if .obj.CookieEnabled}} checked{{end}}>
			</div>
			<div class="layui-form-mid layui-word-aux">是否启用cookie检查</div>
		</div>
		<div class="layui-form-item">
			<label for="post_enabled" class="layui-form-label">POST检查:</label>
			<div class="layui-input-inline">
				<input type="checkbox" id="post_enabled" name="post_enabled" lay-skin="switch"
					   lay-text="启用|禁用"{{if .obj.PostEnabled}} checked{{end}}>
			</div>
			<div class="layui-form-mid layui-word-aux">是否启用POST检查</div>
		</div>
		<div class="layui-form-item">
			<label for="allow_url_enabled" class="layui-form-label">白名单URL:</label>
			<div class="layui-input-inline">
				<input type="checkbox" id="allow_url_enabled" name="allow_url_enabled" lay-skin="switch"
					   lay-text="启用|禁用"{{if .obj.AllowUrlEnabled}} checked{{end}}>
			</div>
			<div class="layui-form-mid layui-word-aux">是否启用白名单URL检查</div>
		</div>
		<div class="layui-form-item">
			<label for="add_deny_enabled" class="layui-form-label">自动黑名单:</label>
			<div class="layui-input-inline">
				<input type="checkbox" id="add_deny_enabled" name="add_deny_enabled" lay-skin="switch"
					   lay-text="启用|禁用"{{if .obj.AddDenyEnabled}} checked{{end}}>
			</div>
			<div class="layui-form-mid layui-word-aux">
				是否开启自动把IP加入永久黑名单（慎用，如果确定开启，请将搜索引擎蜘蛛IP加入到IP白名单列表）
			</div>
		</div>
		<div class="layui-form-item">
			<label for="cc_deny_enabled" class="layui-form-label">CC防护:</label>
			<div class="layui-input-inline">
				<input type="checkbox" id="cc_deny_enabled" name="cc_deny_enabled" lay-skin="switch"
					   lay-text="启用|禁用"{{if .obj.CCDenyEnabled}} checked{{end}}>
			</div>
			<div class="layui-form-mid layui-word-aux">
				是否开启拦截cc攻击(需要nginx.conf的http段增加lua_shared_dict limit 10m;)
			</div>
		</div>

		<div class="layui-btn-container">
			<div class="layui-btn-group">
				<button class="layui-btn layui-btn-sm" lay-submit lay-filter="submit">保存配置
				</button>
				<button class="layui-btn layui-btn-sm layui-btn-primary" data-event="default">初始化配置</button>
				<button class="layui-btn layui-btn-sm layui-btn-primary" data-event="nginx-restart">重启生效</button>
				<button class="layui-btn layui-btn-primary layui-btn-sm"
						lay-href="/file?path=/usr/local/nginx/lib/lua/waf/logs">拦截日志
				</button>
			</div>
			<div class="layui-inline" style="float: right">
				<label class="layui-form-label">编辑规则:</label>
				<div class="layui-btn-group">
					<button class="layui-btn layui-btn-sm layui-btn-primary" data-path="allow-ip">IP白名单</button>
					<button class="layui-btn layui-btn-sm layui-bg-cyan" data-path="deny-ip">IP黑名单</button>
					<button class="layui-btn layui-btn-sm layui-btn-primary" data-path="allow-url">URl白名单</button>
					<button class="layui-btn layui-btn-sm layui-bg-cyan" data-path="url">URL黑名单</button>
					<button class="layui-btn layui-btn-sm layui-btn-primary" data-path="cookie">Cookie规则</button>
					<button class="layui-btn layui-btn-sm layui-btn-primary" data-path="post">POST规则</button>
					<button class="layui-btn layui-btn-sm layui-btn-primary" data-path="user-agent">Useragent规则
					</button>
					<button class="layui-btn layui-btn-sm layui-btn-primary" data-path="args">请求参规则</button>
				</div>
			</div>
		</div>
	</div>
</div>
<script src="/static/layui/layui.js"></script>
<script src="/static/file/jquery.dragsort-0.5.2.min.js"></script>
<script src="/static/file/ace/ace.js"></script>
<script>
    layui.use(['index', 'editor'], function () {
        let $ = layui.$, main = layui.main,
            form = layui.form;
        form.on('submit(submit)', function (obj) {
            main.request({
                url: URL,
                data: obj.field,
            });
        });
        $('[data-path]').on('click', function () {
            layui.editor('/usr/local/nginx/lib/lua/waf/conf/' + $(this).attr('data-path'))
        });
        $('[data-event=default]').on('click', function () {
            layer.confirm('恢复到默认设置？所有修改过的规矩全部恢复到默认？', {
                btn: ['确定', '关闭'] //按钮
            }, function (index) {
                layer.close(index);
                main.request({
                    url: URL,
                    data: {action: "default"},
                    done: function (res) {
                        layer.msg(res.msg, function () {
                            location.reload();
                        });
                        return false
                    }
                })
            });
        });
        $('[data-event="nginx-restart"]').on('click', function () {
            main.webssh({stdin: "lnmp nginx restart"});
        });
    });
</script>