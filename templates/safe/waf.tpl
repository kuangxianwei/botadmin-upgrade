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
				<div class="layui-input-inline" style="width: 100px" lay-tips="限制次/期间秒|封禁时间秒">
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

		<div class="layui-form-item">
			<label for="duration" class="layui-form-label" lay-tips="显示广告时间段">广告时间:</label>
			<div class="layui-input-inline">
				<input class="layui-input" id="duration" type="text" name="duration" value="{{.obj.Duration}}" placeholder="00:00:00 - 23:59:59">
			</div>
			<div class="layui-form-mid layui-word-aux">
				例如：00:00:00 - 23:59:59 00:00:00开始启用广告 23:59:59关闭广告
			</div>
		</div>
		<div class="layui-col-md12" id="referer">
			<div class="layui-form-item">
				<label class="layui-form-label">来源跳转:</label>
				<div class="layui-inline">
					<input class="layui-input" name="referer.pattern.0" value="" placeholder="baidu\\.com|sogou\\.com" lay-tips="正则匹配来源">
				</div>
				<div class="layui-inline">
					<label class="layui-form-label-col" style="color:#009688;"><i class="layui-icon layui-icon-spread-left"></i></label>
				</div>
				<div class="layui-inline">
					<input class="layui-input" name="referer.redirect.0" value="" placeholder="https://www.nfivf.com" lay-tips="跳转到网址/状态码">
				</div>
				<i class="layui-icon layui-icon-delete" lay-event="del" lay-tips="删除该规则"></i>
				<i class="layui-icon layui-icon-add-circle" lay-event="add" lay-tips="添加新来源规则"></i>
			</div>
		</div>
		<div class="layui-col-md6">
			<div class="layui-form-item">
				<label for="mobile_redirect" class="layui-form-label" lay-tips="开启：尽量把搜索引擎蜘蛛IP添加到白名单列表">移动跳转:</label>
				<div class="layui-input-block" lay-tips="移动端跳转到广告页/状态码">
					<input class="layui-input" id="mobile_redirect" type="text" name="mobile_redirect" value="{{.obj.MobileRedirect}}" placeholder="https://www.nfivf.com">
				</div>
			</div>
		</div>
		<div class="layui-col-md6">
			<div class="layui-form-item">
				<label for="pc_redirect" class="layui-form-label" lay-tips="开启：尽量把搜索引擎蜘蛛IP添加到白名单列表">PC端:</label>
				<div class="layui-input-block" lay-tips="PC端跳转到广告页/状态码">
					<input class="layui-input" id="pc_redirect" type="text" name="pc_redirect" value="{{.obj.PcRedirect}}" placeholder="https://www.nfivf.com">
				</div>
			</div>
		</div>
		<div class="layui-hide">
			<input type="hidden" name="referer" value="{{json .obj.Referer}}">
			<button lay-submit lay-filter="submit">保存配置</button>
			<button data-event="reset">初始化配置</button>
			<button data-event="nginx-restart">重启nginx</button>
			<button data-event="logs" lay-href="/file?path=/usr/local/nginx/lib/lua/waf/logs">拦截日志</button>
		</div>
		<div style="text-align: center;">
			<div class="layui-btn-group" lay-tips="验证顺序：只要匹配到其中一个，剩余的不再验证">
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
				<button class="layui-btn layui-btn-sm layui-btn-primary" data-path="user-agent">黑UA</button>
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
				<button class="layui-btn layui-btn-sm layui-btn-primary">白UA</button>
				<button class="layui-btn layui-btn-sm layui-bg-cyan">
					<i class="iconfont icon-arrow-right"></i>
				</button>
				<button class="layui-btn layui-btn-sm layui-btn-primary">来源跳转</button>
				<button class="layui-btn layui-btn-sm layui-bg-cyan">
					<i class="iconfont icon-arrow-right"></i>
				</button>
				<button class="layui-btn layui-btn-sm layui-btn-primary">跳转广告</button>
			</div>
		</div>
	</div>
</div>
<script type="text/html" id="referer-item">
	<div class="layui-form-item">
		<label class="layui-form-label">来源跳转:</label>
		<div class="layui-inline">
			<input class="layui-input" name="referer.pattern." value="" placeholder="baidu\\.com|sogou\\.com" lay-tips="正则匹配来源">
		</div>
		<div class="layui-inline">
			<label class="layui-form-label-col" style="color:#009688;"><i class="layui-icon layui-icon-spread-left"></i></label>
		</div>
		<div class="layui-inline">
			<input class="layui-input" name="referer.redirect." value="" placeholder="https://www.nfivf.com" lay-tips="跳转到网址/状态码">
		</div>
		<i class="layui-icon layui-icon-delete" lay-event="del" lay-tips="删除该规则"></i>
		<i class="layui-icon layui-icon-add-circle" lay-event="add" lay-tips="添加新来源规则"></i>
	</div>
</script>
<script src="/static/layui/layui.js"></script>
<script src="/static/file/jquery.dragsort-0.5.2.min.js"></script>
<script src="/static/file/ace/ace.js"></script>
<style>
	#referer .layui-inline > input{width: 320px;}
	i[lay-event="add"]{color: #009688;}
	.layui-fixbar li{width: 40px;height: 40px;line-height: 40px;font-size: 20px;}
</style>
<script>
    layui.use(['index', 'editor'], function () {
        let $ = layui.$, main = layui.main, layDate = layui.laydate,
            form = layui.form, util = layui.util;
        form.on('submit(submit)', function (obj) {
            main.request({
                url: URL,
                data: obj.field,
            });
        });
        $('[data-path]').on('click', function () {
            layui.editor('/usr/local/nginx/lib/lua/waf/conf/' + $(this).attr('data-path'))
        });
        $('[data-event=reset]').on('click', function () {
            layer.confirm('恢复到默认设置？所有修改过的规矩全部恢复到默认？', {
                title: false,
                closeBtn: false,
                icon: 3,
                btn: ['确定', '关闭']
            }, function (index) {
                layer.close(index);
                main.request({
                    url: URL,
                    data: {action: "reset"},
                    done: function () {
                        location.reload();
                        return false
                    }
                })
            });
        });
        $('[data-event="nginx-restart"]').on('click', function () {
            main.webssh({stdin: "lnmp nginx restart"});
        });
        main.cron('[name=check_dns_spec]');
        layDate.render({elem: '[name=duration]', type: 'time', range: true});
        let refererID = $('#referer'), refererItem = $('#referer-item');
        util.fixbar({
            bars: [{
                type: '保存配置',
                icon: 'iconfont icon-save',
                style: 'background-color: #16baaa;'
            }, {
                type: '初始化配置',
                icon: 'iconfont icon-reset',
                style: 'background-color: #FF5722;'
            }, {
                type: '重启服务',
                icon: 'iconfont icon-reboot',
            }, {
                type: '查看拦截日志',
                icon: 'iconfont icon-log',
            }],
            css: {left: '2px', top: '45%', width: '40px'},
            bgcolor: '#2f4056!important',
            on: {
                mouseenter: function (type) {
                    layer.tips(type, this, {tips: 4, fixed: true});
                },
                mouseleave: function () {
                    layer.closeAll('tips');
                }
            },
            click: function (type) {
                switch (type) {
                    case "保存配置":
                        let m = {};
                        refererID.find('.layui-form-item').each(function () {
                            let pattern = $(this).find('input[name^="referer.pattern."]').val();
                            if (pattern) {
                                let redirect = $(this).find('input[name^="referer.redirect."]').val();
                                if (redirect) {
                                    m[pattern] = redirect
                                }
                            }
                        });
                        $('input[name=referer]').val(JSON.stringify(m));
                        $('[lay-filter=submit]').click();
                        break;
                    case "初始化配置":
                        $('[data-event=reset]').click();
                        break;
                    case "重启服务":
                        $('[data-event="nginx-restart"]').click();
                        break;
                    case "查看拦截日志":
                        $('[data-event=logs]').click();
                        break
                }
            }
        });
        let insertReferer = function (pattern, redirect) {
            pattern = pattern || '';
            redirect = redirect || '';
            let index = -1;
            refererID.find('input[name^="referer.pattern."]').each(function () {
                let _index = parseInt(this.name.split(".").pop());
                if (_index > index) index = _index;
            });
            let item = $(refererItem.html());
            index++;
            item.find('input[name="referer.pattern."]').attr('name', 'referer.pattern.' + index).val(pattern);
            item.find('input[name="referer.redirect."]').attr('name', 'referer.redirect.' + index).val(redirect);
            refererID.find('[lay-event=add]').remove();
            refererID.append(item);
        };
        $(document).on('click', 'i[lay-event=del]', function () {
            if (refererID.find('input').length <= 2) return layer.msg('最后一项不允许删除');
            $(this).closest('.layui-form-item').remove();
            if (refererID.find('.layui-form-item:last-of-type i[lay-event=add]').length === 0)
                refererID.find('.layui-form-item:last-of-type i[lay-event=del]').after('<i class="layui-icon layui-icon-add-circle" lay-event="add" lay-tips="添加新来源规则"></i>')
        });
        $(document).on('click', 'i[lay-event=add]', function () {
            insertReferer();
        });
        let referer = JSON.parse($('input[name=referer]').val() || '{}');
        if (Object.keys(referer).length > 0) {
            refererID.empty();
            $.each(referer, function (pattern, redirect) {
                insertReferer(pattern, redirect)
            })
        }
    });
</script>