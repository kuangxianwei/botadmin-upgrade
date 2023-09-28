<div class="layui-card">
	<div class="layui-card-body layui-form" lay-filter="form">
		<div class="layui-col-md3">
			<div class="layui-form-item">
				<label class="layui-form-label" for="thread"
					   lay-tips="最多线程同时查询，线程太多服务器会崩溃">多线程:</label>
				<div class="layui-input-block">
					<input class="layui-input" id="thread" name="thread" type="number" min="1" max="1000" value="20"/>
				</div>
			</div>
		</div>
		<div class="layui-col-md4">
			<label class="layui-form-label">引擎:</label>
			<div class="layui-input-block">
				<input type="radio" name="engine" value="qqwry" title="QQWry" checked>
				<input type="radio" name="engine" value="ip2region" title="ip2region">
			</div>
		</div>
		<div class="layui-col-md3">
			<button class="layui-btn layui-btn-radius" data-event="updateQQWry">获取QQWry最新IP库</button>
		</div>
		<div class="layui-form-item">
			<label class="layui-form-label">源列表:</label>
			<div class="layui-input-block">
				<textarea class="layui-textarea" name="content" rows="24" required lay-verify="content"></textarea>
			</div>
		</div>
		<div class="layui-form-item" style="text-align:center">
			<div class="layui-btn-group">
				<button class="layui-btn" data-event="query">
					<i class="layui-icon layui-icon-play"></i>查询
				</button>
				<button class="layui-btn layui-btn-primary" data-event="log" data-value="{{.token}}">
					<i class="iconfont icon-view"></i>查看结果
				</button>
			</div>
		</div>
	</div>
</div>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main', 'form'], function () {
        let main = layui.main, form = layui.form;
        let active = {
            log: function () {
                main.ws.log($(this).data('value'));
            },
            query: function () {
                main.request({
                    data: form.val('form'),
                    done: function () {
                        main.ws.log({{.token}});
                        return false
                    }
                })
            },
            updateQQWry: function () {
                main.request({
                    url: URL + '/qqwry/version',
                    done: function (res) {
                        layer.confirm(res.msg, {btn: false, title: false});
                        return false;
                    }
                })
            }
        };
        $('[data-event]').on('click', function () {
            let type = $(this).data('event');
            active[type] && active[type].call(this)
        });
    });
</script>