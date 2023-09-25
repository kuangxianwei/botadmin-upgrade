<div class="layui-card">
	<div class="layui-card-body layui-row layui-form">
		<div class="layui-col-md6">
			<div class="layui-form-item">
				<label for="log_enabled" class="layui-form-label">启用日志:</label>
				<div class="layui-input-inline">
					<input type="checkbox" id="log_enabled" name="log_enabled" lay-skin="switch"
						   lay-text="启用|禁用"{{if .obj.LogEnabled}} checked{{end}}>
				</div>
				<div class="layui-form-mid layui-word-aux">是否启用攻击日志记录</div>
			</div>
		</div>
		<div class="layui-col-md6">
			<div class="layui-form-item">
				<label for="log_path" class="layui-form-label">日志目录:</label>
				<div class="layui-input-inline" style="min-width: 40%">
					<input class="layui-input" id="log_path" type="text" name="log_path" value="{{.obj.LogPath}}">
				</div>
				<div class="layui-form-mid layui-word-aux">存放攻击日志的目录</div>
			</div>
		</div>
		<div class="layui-col-md6">
			<div class="layui-form-item">
				<label for="cc_deny_enabled" class="layui-form-label">CC防护:</label>
				<div class="layui-input-inline">
					<input type="checkbox" id="cc_deny_enabled" name="cc_deny_enabled" lay-skin="switch"
						   lay-text="启用|禁用"{{if .obj.CCDenyEnabled}} checked{{end}}>
				</div>
				<div class="layui-form-mid layui-word-aux">是否开启拦截cc攻击</div>
			</div>
		</div>
		<div class="layui-col-md6">
			<div class="layui-form-item">
				<label for="cc_rate" class="layui-form-label">CC频率:</label>
				<div class="layui-input-inline" style="width: 100px">
					<input class="layui-input" id="cc_rate" type="text" name="cc_rate" value="{{.obj.CCRate}}">
				</div>
				<div class="layui-form-mid layui-word-aux">单位为秒. 默认1分钟同一个IP只能请求100次</div>
			</div>
		</div>

		<div class="layui-col-md6">
			<div class="layui-form-item">
				<label for="url_enabled" class="layui-form-label">验证URL:</label>
				<div class="layui-input-inline">
					<input type="checkbox" id="url_enabled" name="url_enabled" lay-skin="switch"
						   lay-text="启用|禁用"{{if .obj.UrlEnabled}} checked{{end}}>
				</div>
				<div class="layui-form-mid layui-word-aux">是否启用验证URL</div>
			</div>
		</div>
		<div class="layui-col-md6">
			<div class="layui-form-item">
				<label for="allow_url_enabled" class="layui-form-label">白名单URL:</label>
				<div class="layui-input-inline">
					<input type="checkbox" id="allow_url_enabled" name="allow_url_enabled" lay-skin="switch"
						   lay-text="启用|禁用"{{if .obj.AllowUrlEnabled}} checked{{end}}>
				</div>
				<div class="layui-form-mid layui-word-aux">是否启用白名单URL</div>
			</div>
		</div>
		<div class="layui-col-md6">
			<div class="layui-form-item">
				<label for="redirect_enabled" class="layui-form-label">拦截显示:</label>
				<div class="layui-input-inline">
					<input type="checkbox" id="redirect_enabled" name="redirect_enabled" lay-skin="switch"
						   lay-text="启用|禁用"{{if .obj.RedirectEnabled}} checked{{end}}>
				</div>
				<div class="layui-form-mid layui-word-aux">拦截后是否跳转到自定义拦截页面</div>
			</div>
		</div>
		<div class="layui-col-md6">
			<div class="layui-form-item">
				<label for="cookie_enabled" class="layui-form-label">Cookie检查:</label>
				<div class="layui-input-inline">
					<input type="checkbox" id="cookie_enabled" name="cookie_enabled" lay-skin="switch"
						   lay-text="启用|禁用"{{if .obj.CookieEnabled}} checked{{end}}>
				</div>
				<div class="layui-form-mid layui-word-aux">是否启用cookie检查</div>
			</div>
		</div>
		<div class="layui-col-md6">
			<div class="layui-form-item">
				<label for="post_enabled" class="layui-form-label">POST检查:</label>
				<div class="layui-input-inline">
					<input type="checkbox" id="post_enabled" name="post_enabled" lay-skin="switch"
						   lay-text="启用|禁用"{{if .obj.PostEnabled}} checked{{end}}>
				</div>
				<div class="layui-form-mid layui-word-aux">是否启用POST检查</div>
			</div>
		</div>
		<div class="layui-col-md6">
			<div class="layui-form-item">
				<label for="add_deny_enabled" class="layui-form-label"
					   lay-tips="慎用，如果确定开启，请将搜索引擎蜘蛛IP加入到IP白名单列表并且开启定时验证DNS">自动黑名单:</label>
				<div class="layui-input-inline">
					<input type="checkbox" id="add_deny_enabled" name="add_deny_enabled" lay-skin="switch"
						   lay-text="启用|禁用"{{if .obj.AddDenyEnabled}} checked{{end}}>
				</div>
				<div class="layui-form-mid layui-word-aux">自动把拦截IP加入永久黑名单</div>
			</div>
		</div>
		<div class="layui-col-md6">
			<div class="layui-form-item">
				<label for="check_dns" class="layui-form-label">验证DNS:</label>
				<div class="layui-input-inline">
					<input type="checkbox" id="check_dns" name="check_dns" lay-skin="switch"
						   lay-text="启用|禁用"{{if .obj.CheckDns}} checked{{end}}>
				</div>
				<div class="layui-form-mid layui-word-aux">是否定时验证黑名单IP的DNS</div>
			</div>
		</div>
		<div class="layui-col-md6">
			<div class="layui-form-item">
				<label for="check_dns_spec" class="layui-form-label">定时规则:</label>
				<div class="layui-input-inline">
					<input class="layui-input" id="check_dns_spec" type="text" name="check_dns_spec"
						   value="{{.obj.CheckDnsSpec}}">
				</div>
				<div class="layui-form-mid layui-word-aux">默认一个小时检查一次黑名单</div>
			</div>
		</div>
		<div class="layui-form-item">
			<label for="deny_upload_exts" class="layui-form-label" lay-tips="拒绝上传文件的后缀，多个用英文逗号隔开">拦截后缀:</label>
			<div class="layui-input-inline" style="width: 60%">
				<input class="layui-input" id="deny_upload_exts" type="text" name="deny_upload_exts"
					   value="{{join .obj.DenyUploadExts ","}}">
			</div>
			<div class="layui-form-mid layui-word-aux">拒绝上传文件的后缀</div>
		</div>
		<div class="layui-form-item">
			<label for="allow_dns" class="layui-form-label" lay-tips="搜索引擎的DNS列表，逗号隔开">DNS白名单:</label>
			<div class="layui-input-inline" style="width: 60%">
				<input class="layui-input" id="allow_dns" type="text" name="allow_dns"
					   value="{{join .obj.AllowDns ","}}" placeholder=".baidu.com,.baidu.jp">
			</div>
			<div class="layui-form-mid layui-word-aux">搜索引擎的DNS列表</div>
		</div>
		<div class="layui-form-item">
			<label for="allow_useragent" class="layui-form-label"
				   lay-tips="Useragent白名单(正则表达式)主要是广告跳转的时候用处很大">UA白名单:</label>
			<div class="layui-input-inline" style="width: 60%">
				<input class="layui-input" id="allow_useragent" type="text" name="allow_useragent"
					   value="{{.obj.AllowUseragent}}"
					   placeholder="Baiduspider|Googlebot|Sogou|360Spider|bingbot|Bytespider|YisouSpider">
			</div>
			<div class="layui-form-mid layui-word-aux">搜索引擎Useragent正则</div>
		</div>
		<div class="layui-col-md6">
			<div class="layui-form-item">
				<label for="mobile_redirect" class="layui-form-label"
					   lay-tips="开启的前提必须把搜索引擎蜘蛛IP添加到白名单列表">移动端:</label>
				<div class="layui-input-inline">
					<input class="layui-input" id="mobile_redirect" type="text" name="mobile_redirect"
						   value="{{.obj.MobileRedirect}}">
				</div>
				<div class="layui-form-mid layui-word-aux">移动端跳转到广告页/状态码</div>
			</div>
		</div>
		<div class="layui-col-md6">
			<div class="layui-form-item">
				<label for="pc_redirect" class="layui-form-label"
					   lay-tips="开启的前提必须把搜索引擎蜘蛛IP添加到白名单列表">PC端:</label>
				<div class="layui-input-inline">
					<input class="layui-input" id="pc_redirect" type="text" name="pc_redirect"
						   value="{{.obj.PcRedirect}}">
				</div>
				<div class="layui-form-mid layui-word-aux">PC端跳转到广告页/状态码</div>
			</div>
		</div>
		<div class="layui-form-item" lay-tips="验证顺序：只要匹配到其中一个，剩余的不再验证">
			<div class="layui-btn-group" style="margin-top: 5px">
				<button class="layui-btn layui-btn-sm layui-btn-primary" data-path="allow-ip">白IP</button>
				<button class="layui-btn layui-btn-sm layui-bg-cyan">
					<i class="iconfont icon-arrow-right"></i>
				</button>
				<button class="layui-btn layui-btn-sm layui-btn-primary" data-path="deny-ip">黑IP</button>
				<button class="layui-btn layui-btn-sm layui-bg-cyan">
					<i class="iconfont icon-arrow-right"></i>
				</button>
				<button class="layui-btn layui-btn-sm layui-btn-primary" data-path="allow-url">白URl</button>
				<button class="layui-btn layui-btn-sm layui-bg-cyan">
					<i class="iconfont icon-arrow-right"></i>
				</button>
				<button class="layui-btn layui-btn-sm layui-btn-primary">CC拦截</button>
				<button class="layui-btn layui-btn-sm layui-bg-cyan">
					<i class="iconfont icon-arrow-right"></i>
				</button>
				<button class="layui-btn layui-btn-sm layui-btn-primary" data-path="user-agent">黑Useragent</button>
				<button class="layui-btn layui-btn-sm layui-bg-cyan">
					<i class="iconfont icon-arrow-right"></i>
				</button>
				<button class="layui-btn layui-btn-sm layui-btn-primary" data-path="url">黑URL</button>
				<button class="layui-btn layui-btn-sm layui-bg-cyan">
					<i class="iconfont icon-arrow-right"></i>
				</button>
				<button class="layui-btn layui-btn-sm layui-btn-primary" data-path="args">参数拦截</button>
				<button class="layui-btn layui-btn-sm layui-bg-cyan">
					<i class="iconfont icon-arrow-right"></i>
				</button>
				<button class="layui-btn layui-btn-sm layui-btn-primary" data-path="cookie">黑Cookie</button>
				<button class="layui-btn layui-btn-sm layui-bg-cyan">
					<i class="iconfont icon-arrow-right"></i>
				</button>
				<button class="layui-btn layui-btn-sm layui-btn-primary" data-path="post">黑POST</button>
				<button class="layui-btn layui-btn-sm layui-bg-cyan">
					<i class="iconfont icon-arrow-right"></i>
				</button>
				<button class="layui-btn layui-btn-sm layui-btn-primary">白Useragent</button>
				<button class="layui-btn layui-btn-sm layui-bg-cyan">
					<i class="iconfont icon-arrow-right"></i>
				</button>
				<button class="layui-btn layui-btn-sm layui-btn-primary">跳转广告</button>
			</div>
		</div>
		<div class="layui-btn-container" style="padding-left: 200px">
			<div class="layui-btn-group">
				<button class="layui-btn layui-btn-sm" lay-submit lay-filter="submit">保存配置</button>
				<button class="layui-btn layui-btn-sm layui-btn-primary" data-event="default">初始化配置</button>
				<button class="layui-btn layui-btn-sm layui-btn-primary" data-event="nginx-restart">重启生效</button>
				<button class="layui-btn layui-btn-primary layui-btn-sm"
						lay-href="/file?path=/usr/local/nginx/lib/lua/waf/logs">拦截日志
				</button>
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
        main.cron('[name=check_dns_spec]');
    });
</script>