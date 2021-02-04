<div class="layui-card" style="height: 100%">
    <div class="layui-card-body layui-form" style="height: 100%">
        <textarea name="record" class="layui-textarea" style="height: 90%">{{.record}}</textarea>
        <div class="layui-form-item layui-hide">
            <input type="hidden" name="id" value="{{.obj.Id}}">
            <input type="hidden" name="engine" value="{{.obj.Engine}}">
            <button lay-submit>提交</button>
        </div>
    </div>
</div>
