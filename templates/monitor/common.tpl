<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <label class="layui-form-label">目标地址:</label>
            {{if .obj.Addr -}}
                <div class="layui-input-inline">
                    <input type="text" name="addr" lay-verify="required" autocomplete="off"
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
            <label class="layui-form-label">邮箱配置:</label>
            <div class="layui-input-inline">
                <select name="email_id" lay-search>
                    {{range $v:=.emails}}
                        <option value="{{$v.Id}}"{{if eq $.obj.EmailId $v.Id}} selected{{end}}>{{$v.Username}}</option>
                    {{end}}
                </select>
            </div>
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
        <div class="layui-form-item" style="padding-left: 3%;">
            <table>
                <tr>
                    <th align="center" style="margin-right: 2%;">启用定时</th>
                    <th align="center">分:0-59 *-,</th>
                    <th align="center">时:0-23 *-,</th>
                    <th align="center">天:1-31 *-,</th>
                    <th align="center">月:1-12 *-,</th>
                    <th align="center">周:0-6 *-,</th>
                </tr>
                <tr>
                    <td style="padding-left: 2%;">
                        <input type="checkbox" name="cron_enabled" lay-skin="switch"
                               lay-text="是|否"{{if .obj.CronEnabled}} checked{{end}}>
                    </td>
                    <td style="padding-left: 4%;">
                        <input type="text" name="minute" value="{{.obj.Minute}}" class="layui-input">
                    </td>
                    <td style="padding-left: 2%;">
                        <input type="text" name="hour" value="{{.obj.Hour}}" class="layui-input">
                    </td>
                    <td style="padding-left: 2%;">
                        <input type="text" name="day" value="{{.obj.Day}}" class="layui-input">
                    </td>
                    <td style="padding-left: 2%;">
                        <input type="text" name="month" value="{{.obj.Month}}" class="layui-input">
                    </td>
                    <td style="padding-left: 2%;">
                        <input type="text" name="week" value="{{.obj.Week}}" class="layui-input">
                    </td>
                </tr>
            </table>
        </div>
        <div class="layui-form-item layui-hide">
            <input name="id" value="{{.obj.Id}}">
            <button lay-submit>提交</button>
        </div>
    </div>
</div>
