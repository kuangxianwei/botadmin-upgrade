<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <label class="layui-form-label">目标地址:</label>
            {{if .obj.Addr -}}
                <div class="layui-input-block">
                    <input type="text" name="addr" value="{{.obj.Addr}}" lay-verify="required" class="layui-input" placeholder="http://www.botadmin.cn">
                </div>
            {{else -}}
                <div class="layui-input-block">
                    <textarea name="address" class="layui-textarea" rows="3" placeholder="http://www.botadmin.cn&#13;http://www.nfivf.com"></textarea>
                </div>
            {{end -}}
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">接收者:</label>
            <div class="layui-input-block">
                <textarea name="to" class="layui-textarea" rows="3" placeholder="38050123@qq.com&#13;88364809@qq.com">{{join .obj.To "\n"}}</textarea>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">方法:</label>
                <div class="layui-input-inline">
                    <select name="method">
                        {{range $i,$v:=.methods -}}
                            <option value="{{$i}}"{{if eq $.obj.Method $i}} selected{{end}}>{{$v}}</option>
                        {{end -}}
                    </select>
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">详情:</label>
                <input type="checkbox" name="detailed" lay-skin="switch"
                       lay-text="是|否"{{if .obj.Detailed}} checked{{end}}>
            </div>
        </div>
        <fieldset class="layui-elem-field">
            <legend>定时设置</legend>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">启用:</label>
                    <div class="layui-input-inline">
                        <input type="checkbox" name="cron_enabled" lay-skin="switch"
                               lay-text="是|否"{{if .obj.CronEnabled}} checked{{end}}>
                    </div>
                </div>
                <div class="layui-inline" lay-tips="双击修改定时任务">
                    <input type="text" name="spec" value="{{.obj.Spec}}" class="layui-input">
                </div>
            </div>
        </fieldset>
        <div class="layui-form-item layui-hide">
            <input name="id" value="{{.obj.Id}}">
            <button lay-submit>提交</button>
        </div>
    </div>
</div>
<script>
    layui.main.cron('[name="spec"]');
</script>