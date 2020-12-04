<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <label class="layui-form-label">启用:</label>
            <div class="layui-input-block">
                <input type="checkbox" name="enabled"
                       lay-skin="switch" lay-text="启用|关闭"{{if .obj.Enabled}} checked{{end}}>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" lay-tips="翻译平台获取">SecretId:</label>
            <div class="layui-input-block">
                <input type="text" name="app_id" value="{{.obj.AppId}}" lay-verify="required" autocomplete="off"
                       placeholder="翻译平台获取" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" lay-tips="翻译平台获取">SecretKey:</label>
            <div class="layui-input-block">
                <input type="text" name="token" value="{{.obj.Token}}" autocomplete="off"
                       placeholder="翻译平台获取" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">源语言:</label>
                <div class="layui-input-inline">
                    {{.source}}
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label-col" style="color: #009688;">
                    <i class="layui-icon layui-icon-spread-left"></i>
                </label>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">目标语言:</label>
                <div class="layui-input-inline">
                    {{.target}}
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">延时:</label>
            <div class="layui-input-inline">
                <input type="text" name="delay" value="{{.obj.Delay}}" autocomplete="off" placeholder="输入秒"
                       class="layui-input">
            </div>
            <div class="layui-form-mid layui-word-aux">每次请求间隔多少秒</div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">服务区域:</label>
            <div class="layui-input-inline">
                <select name="region" class="layui-select">
                    {{range $v:=.regions -}}
                        <option value="{{$v.Name}}"{{if eq $v.Name $.obj.Region}} selected{{end}}>{{$v.Alias}}</option>
                    {{end -}}
                </select>
            </div>
            <div class="layui-form-mid layui-word-aux">指定服务的区域</div>
        </div>
        <div class="layui-form-item layui-hide">
            <input type="hidden" name="id" value="{{.obj.Id}}">
            <button lay-submit>提交</button>
        </div>
    </div>
</div>
