<div class="layui-card">
    <div class="layui-card-header">下载图片 {{.obj.Dirname}} 已经存在<strong>{{.picCount}}</strong>张图片
        <button class="layui-btn layui-btn-radius layui-btn-sm layui-btn-primary"
                onclick="openPic();" style="margin-left: 20px">查看
        </button>
    </div>
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <div class="layui-row">
                <div class="layui-col-md6">
                    <label for="engine" class="layui-form-label">引擎:</label>
                    <div class="layui-input-inline">
                        <select name="engine" id="engine" lay-filter="engine">
                            {{range $engine:=.engines -}}
                                <option value="{{$engine.Name}}"{{if eq $.obj.Engine $engine.Name}} selected{{end}}>{{$engine.Alias}}</option>
                            {{end -}}
                        </select>
                    </div>
                </div>
                <div class="layui-col-md6">
                    <label for="begin" class="layui-form-label" lay-tips="关键词列表 一行一条">关键词:</label>
                    <div class="layui-input-block">
                        <textarea name="keywords" class="layui-textarea"
                                  required lay-verify="required">{{join .obj.Keywords "\n"}}</textarea>
                    </div>
                </div>
                <div class="layui-col-md3">
                    <label for="begin" class="layui-form-label" lay-tips="开始页">开始:</label>
                    <div class="layui-input-inline" style="width: 60px">
                        <input type="number" autocomplete="off" name="begin" id="begin" value="{{.obj.Begin}}" class="layui-input">
                    </div>
                </div>
                <div class="layui-col-md3">
                    <label for="end" class="layui-form-label" lay-tips="结束页">结束:</label>
                    <div class="layui-input-inline" style="width: 60px">
                        <input type="number" autocomplete="off" name="end" id="end" value="{{.obj.End}}" class="layui-input">
                    </div>
                </div>
                <div class="layui-col-md3">
                    <label for="limit" class="layui-form-label" lay-tips="每页显示量默认30个">页数:</label>
                    <div class="layui-input-inline" style="width: 60px">
                        <input type="number" autocomplete="off" name="limit" id="limit" value="{{.obj.Limit}}" class="layui-input">
                    </div>
                </div>
                <div class="layui-col-md3">
                    <label for="delay" class="layui-form-label" lay-tips="延迟时间秒">延迟:</label>
                    <div class="layui-input-inline" style="width: 60px">
                        <input type="number" autocomplete="off" name="delay" id="delay" value="{{print .obj.Delay}}" class="layui-input">
                    </div>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <label for="id" class="layui-form-label">Cookies:</label>
            <div class="layui-input-block">
                <textarea name="cookies" class="layui-textarea">{{.obj.Cookies}}</textarea>
            </div>
        </div>
        <div class="layui-hide">
            <input type="hidden" name="id" value="{{.id}}">
            <button class="layui-hide" lay-submit lay-filter="submit">立即提交</button>
        </div>
    </div>
</div>
<script>
    let picURL = "/file?path=" +{{.obj.Dirname}};

    function openPic() {
        window.open(picURL, '_blank');
    }
</script>