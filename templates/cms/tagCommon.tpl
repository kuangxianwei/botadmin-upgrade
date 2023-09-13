<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <label for="name" class="layui-form-label">名称:</label>
            <div class="layui-input-block">
                <input type="text" name="name" id="name" value="{{.obj.Name}}" lay-verify="required" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label for="description" class="layui-form-label">描述:</label>
            <div class="layui-input-block">
                <input type="text" name="description" id="description" value="{{.obj.Description}}" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label for="aid" class="layui-form-label" lay-tips="多个用英文逗号隔开">文章ID:</label>
            <div class="layui-input-block">
                <input type="text" name="aid" id="aid" value="{{.obj.Aid}}" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">推荐:</label>
            <div class="layui-input-block">
                <input type="radio" name="level" value="0" title="常规"{{if eq .obj.Level 0}} checked{{end}}>
                <input type="radio" name="level" value="1" title="一级推荐"{{if eq .obj.Level 1}} checked{{end}}>
                <input type="radio" name="level" value="2" title="二级推荐"{{if eq .obj.Level 2}} checked{{end}}>
                <input type="radio" name="level" value="3" title="三级推荐"{{if eq .obj.Level 3}} checked{{end}}>
            </div>
        </div>
        <div class="layui-form-item">
            <label for="size" class="layui-form-label">限制:</label>
            <div class="layui-input-inline">
                <input type="number" name="size" id="size" value="{{.obj.Size}}" min="1" max="100" class="layui-input">
            </div>
            <div class="layui-form-mid layui-word-aux">每页生成条数,默认为10条</div>
        </div>
        <div class="layui-form-item">
            <label for="show" class="layui-form-label">生成全部:</label>
            <div class="layui-input-inline">
                <input type="checkbox" name="show" id="show" lay-skin="switch" lay-text="打开|关闭"{{if .obj.Show}} checked{{end}}>
            </div>
            <div class="layui-form-mid layui-word-aux">是否生成全部列表 默认只生成一页</div>
        </div>
        <div class="layui-form-item layui-hide">
            <input type="hidden" name="id" value="{{.id}}" disabled>
            <input type="hidden" name="index" value="{{.obj.Index}}" disabled>
            <button lay-submit>提交</button>
        </div>
    </div>
</div>