<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <label for="enabled" class="layui-form-label">启用:</label>
            <div class="layui-input-block">
                <input type="checkbox" name="enabled" id="enabled"
                       lay-skin="switch" lay-text="启用|关闭"{{if .obj.Enabled}} checked{{end}}>
            </div>
        </div>
        <div class="layui-form-item{{if .hide}} layui-hide{{end}}">
            <label for="app_id" class="layui-form-label" lay-tips="翻译平台获取">AppId:</label>
            <div class="layui-input-block">
                <input type="text" name="app_id" id="app_id" value="{{.obj.AppId}}"{{if not .hide}} lay-verify="required"{{end}}
                       autocomplete="off" placeholder="翻译平台获取" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label for="token" class="layui-form-label" lay-tips="翻译平台获取">Token:</label>
            <div class="layui-input-block">
                <input type="text" autocomplete="off" name="token" id="token" value="{{.obj.Token}}"
                       placeholder="翻译平台获取" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label for="id" class="layui-form-label">源语言:</label>
                <div class="layui-input-inline">
                    {{.source}}
                </div>
            </div>
            <div class="layui-inline">
                <label for="id" class="layui-form-label-col" style="color: #009688;">
                    <i class="layui-icon layui-icon-spread-left"></i>
                </label>
            </div>
            <div class="layui-inline">
                <label for="id" class="layui-form-label">目标语言:</label>
                <div class="layui-input-inline">
                    {{.target}}
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <label for="id" class="layui-form-label">附加:</label>
            <div class="layui-input-block">
                <textarea name="other" rows="3" class="layui-textarea"
                          lay-tips="格式为:key=val 一行一条">{{.obj.Other}}</textarea>
            </div>
        </div>
        <div class="layui-form-item layui-hide">
            <input type="hidden" name="id" value="{{.obj.Id}}">
            <button lay-submit>提交</button>
        </div>
    </div>
</div>
