<div class="layui-card">
	<div class="layui-card-body layui-form">
		<div class="layui-form-item">
			<label for="minute" class="layui-form-label">每分钟:</label>
			<div class="layui-input-inline">
				<input class="layui-input" id="minute" type="number" name="minute" min="1" value="{{.obj.Minute}}">
			</div>
			<div class="layui-form-mid layui-word-aux">
				每分钟最大请求次数,官网限制每分钟3次
			</div>
		</div>
		<div class="layui-form-item">
			<label for="day" class="layui-form-label">每天:</label>
			<div class="layui-input-inline">
				<input class="layui-input" id="day" type="number" name="day" min="10" value="{{.obj.Day}}">
			</div>
			<div class="layui-form-mid layui-word-aux">
				每天最大请求次数,官网限制每天200次
			</div>
		</div>
		<button class="layui-hide" lay-submit lay-filter="submit"></button>
	</div>
</div>