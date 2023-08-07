<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <textarea class="layui-textarea" name="values" rows="16">{{.values}}</textarea>
            <input type="hidden" name="id" value="{{.id}}">
        </div>
        <button class="layui-hide" lay-submit></button>
    </div>
</div>