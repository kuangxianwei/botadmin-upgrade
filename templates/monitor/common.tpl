<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <label for="data" class="layui-form-label">目标地址:</label>
            <div class="layui-input-block">
                <textarea id="data" name="data" rows="3" class="layui-textarea" lay-verify="required" placeholder="http://www.botadmin.cn 站掌门" required>{{join .obj.Data "\n"}}</textarea>
            </div>
        </div>
        <div class="layui-form-item">
            <label for="to" class="layui-form-label">接收者:</label>
            <div class="layui-input-block">
                <textarea id="to" name="to" class="layui-textarea" rows="3" placeholder="38050123@qq.com&#13;88364809@qq.com" lay-verify="required" required>{{join .obj.To "\n"}}</textarea>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label for="method" class="layui-form-label">方法:</label>
                <div class="layui-input-inline">
                    <select name="method" id="method">
                        {{range $i,$v:=.methods -}}
                            <option value="{{$i}}"{{if eq $.obj.Method $i}} selected{{end}}>{{$v}}</option>
                        {{end -}}
                    </select>
                </div>
            </div>
            <div class="layui-inline">
                <label for="detailed" class="layui-form-label">详情:</label>
                <input type="checkbox" name="detailed" id="detailed" lay-skin="switch"
                       lay-text="是|否"{{if .obj.Detailed}} checked{{end}}>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label for="enabled" class="layui-form-label">启用:</label>
                <div class="layui-input-inline">
                    <input type="checkbox" name="enabled" id="enabled" lay-skin="switch"
                           lay-text="是|否"{{if .obj.Enabled}} checked{{end}}>
                </div>
            </div>
            <div class="layui-inline" lay-tips="双击修改定时任务">
                <input type="text" name="spec" id="spec" value="{{.obj.Spec}}" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item layui-hide">
            <input name="id" id="id" value="{{.obj.Id}}">
            <button lay-submit>提交</button>
        </div>
    </div>
</div>
<script>
    layui.main.cron('[name="spec"]');
</script>