<div class="layui-card">
	<div class="layui-card-body layui-form" lay-filter="form">
		<div class="layui-form-item">
			<label class="layui-form-label">线程:</label>
			<div class="layui-input-inline">
				<input class="layui-input" name="thread" type="number" min="1" max="1000" value="20"/>
			</div>
			<div class="layui-form-mid layui-word-aux">最多线程同时查询，线程太多服务器会崩溃</div>
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
    layui.use(['index', 'main'], function () {
        let main = layui.main;
        let active = {
            log: function () {
                main.ws.log($(this).data('value'));
            },
            query: function () {
                main.request({
                    data: layui.form.val('form'),
                    done: function () {
                        main.ws.log({{.token}});
                        return false
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