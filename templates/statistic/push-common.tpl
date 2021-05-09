<div class="layui-card" style="overflow-x: hidden;">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <label class="layui-form-label">启用:</label>
            <div class="layui-input-inline">
                <input type="checkbox" lay-skin="switch" lay-text="启用|禁用" name="enabled"{{if .obj.Enabled}} checked{{end}}>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" lay-tips="延迟时间秒">延迟:</label>
            <div class="layui-input-block">
                <div id="slow" class="slider-block"></div>
                <input type="hidden" name="slow" class="layui-input" value="{{print .obj.Slow}}">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" lay-tips="指定执行任务范围">范围:</label>
            <div class="layui-input-block">
                <div id="range" class="slider-block"></div>
                <input type="hidden" name="range" class="layui-input" value="{{print .obj.Range}}">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" lay-tips="定时规则">Cron:</label>
            <div class="layui-input-inline">
                <input type="text" name="spec" class="layui-input" value="{{.obj.Spec}}">
            </div>
            <div class="layui-form-mid layui-word-aux">定时执行任务</div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">搜索引擎:</label>
            <div class="layui-input-inline">
                <select class="layui-select" name="search_engine" lay-filter="search-engine">
                    {{range .searches -}}
                        <option value="{{.Name}}"{{if eq .Name $.obj.SearchEngine}} selected{{end}}>{{.Alias}}</option>
                    {{end -}}
                    <option value="">自定义</option>
                </select>
            </div>
            <div class="layui-form-mid layui-word-aux">第三方来路页面，例如百度搜索来路</div>
        </div>
        <div class="layui-form-item custom-engine">
            <label class="layui-form-label">自定义引擎:</label>
            <div class="layui-input-block">
                <input type="text" name="custom_engine" class="layui-input" value="{{.obj.CustomEngine}}" placeholder="http://www.botadmin.cn/">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" lay-tips="搜索引擎搜索关键词">搜索词:</label>
            <div class="layui-input-block">
                <input class="layui-input" type="text" name="search_keyword" value="{{.obj.SearchKeyword}}"
                       placeholder="站掌门">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" lay-tips="入口页面URL 默认为空">入口页面:</label>
            <div class="layui-input-block">
                <input class="layui-input" type="text" name="referer" value="{{.obj.Referer}}"
                       placeholder="http://www.botadmin.cn/">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" lay-tips="后缀加广告词 默认为空">后缀广告:</label>
            <div class="layui-input-block">
                <input class="layui-input" type="text" name="suffix" value="{{.obj.Suffix}}"
                       placeholder="站掌门站群">
            </div>
        </div>
        <div class="layui-form-item layui-hide">
            <input name="id" value="{{.obj.Id}}">
            <button lay-submit=""></button>
        </div>
    </div>
</div>
<script>
    layui.use(['main'], function () {
        let main = layui.main,
            count ={{.count}};
        main.cron('[name="spec"]');
        main.slider(
            {elem: '#range', range: true, min: 1, max: count || 0},
            {elem: '#slow', range: true, min: 0, max: 100},
        );
        layui.form.on('select(search-engine)', function (obj) {
            if (obj.value) {
                $(".custom-engine").removeClass("layui-hide").addClass("layui-show").find('input').focus();
            } else {
                $(".custom-engine").removeClass("layui-show").addClass("layui-hide");
            }
        });
    });
</script>
