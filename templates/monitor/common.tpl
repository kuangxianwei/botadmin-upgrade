<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <label class="layui-form-label">目标地址:</label>
            {{if .obj.Addr -}}
                <div class="layui-input-inline">
                    <input type="text" name="addr" lay-verify="required"
                           class="layui-input" placeholder="监控地址" value="{{.obj.Addr}}">
                </div>
            {{else -}}
                <div class="layui-input-inline">
                    <textarea name="address" class="layui-textarea" rows="3"></textarea>
                </div>
                <div class="layui-form-mid layui-word-aux">http://www.botadmin.cn 一行一条</div>
            {{end -}}
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">接收者:</label>
            <div class="layui-input-inline">
                <textarea name="to" class="layui-textarea"
                          rows="3">{{join .obj.To "\n"}}</textarea>
            </div>
            <div class="layui-form-mid layui-word-aux">接收者邮箱 一行一个</div>
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
                <div class="layui-inline">
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