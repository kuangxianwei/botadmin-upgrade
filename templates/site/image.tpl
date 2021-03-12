<div class="layui-card">
    <div class="layui-card-header">下载图片 {{.pic_dir}} 已经存在
        <a target="_blank" href="/file?path=data/pic/{{.pic_dirname}}">{{.pic_count}}</a> 张图片
    </div>
    <div class="layui-card-body layui-form">
        <div class="layui-row">
            <div class="layui-col-md6">
                <label class="layui-form-label">引擎:</label>
                <div class="layui-input-inline">
                    <select name="engine" lay-filter="engine">
                        {{range $engine:=.engines -}}
                            <option value="{{$engine.Name}}">{{$engine.Alias}}</option>
                        {{end -}}
                    </select>
                </div>
            </div>
            <div class="layui-col-md6">
                <label class="layui-form-label" lay-tips="关键词列表 一行一条">关键词:</label>
                <div class="layui-input-block">
                    <textarea name="keywords" class="layui-textarea" required lay-verify="required">试管婴儿</textarea>
                </div>
            </div>
            <div class="layui-col-md3">
                <label class="layui-form-label" lay-tips="开始页">开始:</label>
                <div class="layui-input-inline">
                    <input type="text" name="begin" value="0" class="layui-input">
                </div>
            </div>
            <div class="layui-col-md3">
                <label class="layui-form-label" lay-tips="结束页">结束:</label>
                <div class="layui-input-inline">
                    <input type="text" name="end" value="5" class="layui-input">
                </div>
            </div>
            <div class="layui-col-md3">
                <label class="layui-form-label" lay-tips="每页显示量默认30个">页数量:</label>
                <div class="layui-input-inline">
                    <input type="text" name="limit" value="30" class="layui-input">
                </div>
            </div>
            <div class="layui-col-md3">
                <label class="layui-form-label" lay-tips="延迟时间秒">延迟:</label>
                <div class="layui-input-inline">
                    <input type="text" name="delay" value="0" class="layui-input">
                </div>
            </div>
        </div>
        <div class="layui-hide">
            <input type="hidden" name="id" value="{{.id}}">
            <button class="layui-hide" lay-submit lay-filter="submit">立即提交</button>
        </div>
    </div>
</div>

