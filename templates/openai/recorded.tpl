<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <textarea name="content" class="layui-textarea" rows="30">{{.content}}</textarea>
        </div>
        <div class="layui-form-item layui-hide">
            <div class="layui-input-block">
                <button class="layui-btn" lay-submit lay-filter="submit">提交</button>
            </div>
        </div>
    </div>
</div>