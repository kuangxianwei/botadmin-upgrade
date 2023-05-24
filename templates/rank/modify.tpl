<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <label for="keyword" class="layui-form-label">关键词:</label>
            <div class="layui-input-inline">
                <input type="text" autocomplete="off" name="keyword" id="keyword" required lay-verify="required" value="{{.obj.Keyword}}" class="layui-input">
            </div>
            <div class="layui-form-mid layui-word-aux">
                <strong style="color:red;">*</strong>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" for="expect">网站:</label>
            <div class="layui-input-inline">
                <input type="text" autocomplete="off" name="expect" id="expect" required lay-verify="required" value="{{.obj.Expect}}"
                       class="layui-input">
            </div>
            <div class="layui-form-mid layui-word-aux">
                <strong style="color:red;">*</strong>
            </div>
        </div>
        <div class="layui-form-item">
            <label for="engine" class="layui-form-label">搜索引擎:</label>
            <div class="layui-input-inline">
                <select name="engine" id="engine">
                    {{range .engines -}}
                        <option value="{{.}}"{{if eq . $.obj.Engine}} selected{{end}}>{{.}}</option>
                    {{end -}}
                </select>
            </div>
        </div>
        <div class="layui-form-item layui-hide">
            <div class="layui-input-block">
                <input type="hidden" name="id" value="{{.obj.Id}}">
                <button class="layui-btn" lay-submit lay-filter="submit">提交</button>
            </div>
        </div>
    </div>
</div>