<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <div class="layui-input-inline">
                <select name="conversion" class="layui-select">
                    {{range $v:=.conversions}}
                        <option value="{{$v.Name}}">{{$v.Alias}}</option>
                    {{end}}
                </select>
            </div>
        </div>
        <div class="layui-form-item layui-hide">
            <div class="layui-input-block">
                <input type="hidden" name="ids" value="{{.ids}}">
                <button class="layui-btn" lay-submit lay-filter="submit">提交</button>
            </div>
        </div>
    </div>
</div>