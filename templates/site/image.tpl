<div class="layui-card">
	<div class="layui-card-header">下载图片 {{.dirname}} 已经存在<strong>{{.picCount}}</strong>张图片
		<a lay-href="/file?path={{.dirname}}" style="color: #0a5b52">管理图片</a>
	</div>
	<div class="layui-card-body layui-form">
		<div class="layui-form-item">
			<label for="keywords" class="layui-form-label" lay-tips="关键词列表 一行一条">关键词:</label>
			<div class="layui-input-block">
				<textarea name="keywords" id="keywords" class="layui-textarea" required lay-verify="required">{{join .keywords "\n"}}</textarea>
			</div>
		</div>
		<div class="layui-form-item">
			<label for="count" class="layui-form-label" lay-tips="最多获取图片">限制:</label>
			<div class="layui-input-block">
				<input type="number" name="count" id="count" value="{{.count}}" class="layui-input">
			</div>
		</div>
		<div class="layui-hide">
			<input type="hidden" name="id" value="{{.id}}">
			<button class="layui-hide" lay-submit lay-filter="submit">立即提交</button>
		</div>
	</div>
</div>
