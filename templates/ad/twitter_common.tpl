<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item layui-row">
            <div class="layui-col-md6">
                <label for="name" class="layui-form-label">名称:</label>
                <div class="layui-input-block">
                    <input type="text" name="name" id="name" value="{{.obj.Name}}" placeholder="默认名称" class="layui-input" lay-verify="required">
                </div>
            </div>
            <div class="layui-col-md6">
                <label for="made" class="layui-form-label" lay-tips="合成背景图加广告图">合成推图:</label>
                <div class="layui-input-inline" style="width: 100px">
                    <input type="checkbox" name="made" id="made" lay-skin="switch" lay-text="启用|禁用" title="启用|禁用"{{if .obj.Made}} checked{{end}}>
                </div>
                <div class="layui-form-mid layui-word-aux" lay-tips="背景图库:background 前景图库:foreground 已编译图库:done">
                    <a lay-href="/file?path=data/ad/twitter/images" lay-text="推文图库" style="color: #0a93bf"><strong>推文图库管理</strong></a>
                </div>
            </div>
        </div>
        <div class="layui-form-item layui-row">
            <div class="layui-col-md4">
                <label for="enabled" class="layui-form-label">定时启用:</label>
                <div class="layui-input-block">
                    <input type="checkbox" name="enabled" id="enabled" lay-skin="switch" lay-text="启用|禁用" title="启用|禁用"{{if .obj.Enabled}} checked{{end}}>
                </div>
            </div>
            <div class="layui-col-md4">
                <label for="spec" class="layui-form-label">定时规则:</label>
                <div class="layui-input-block">
                    <input class="layui-input" type="text" name="spec" id="spec" value="{{.obj.Spec}}">
                </div>
            </div>
            <div class="layui-col-md4">
                <label class="layui-form-label">Tags范围:</label>
                <div class="layui-input-block">
                    <div id="tags_range" class="slider-block"></div>
                    <input type="hidden" name="tags_range" value="{{print .obj.TagsRange}}"/>
                </div>
            </div>
        </div>
        <div class="layui-form-item layui-row">
            <div class="layui-col-md6">
                <label for="tags" class="layui-form-label">Tag列表:</label>
                <div class="layui-input-block">
                    <textarea id="tags" name="tags" class="layui-textarea" placeholder="试管婴儿&#10;广州试管婴儿&#10;试管婴儿机构">{{join .obj.Tags "\n"}}</textarea>
                </div>
            </div>
            <div class="layui-col-md6">
                <label for="texts" class="layui-form-label" lay-tips="推文列表一行一条">推文列表:<br/>
                    <div class="layui-form-mid layui-word-aux" lay-tips="把推文写在一个文本文件里面,一行一条，系统会随机调用" style="display:inline-block;float: right">
                        <a lay-href="/file?path=data/ad/twitter/tweet" lay-text="推文管理" style="color: #0a93bf"><strong>推文管理</strong></a>
                    </div>
                </label>
                <div class="layui-input-block">
                    <textarea id="texts" name="texts" class="layui-textarea" placeholder="推文一&#10;推文二&#10;推文三">{{join .obj.Texts "\n"}}</textarea>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <input type="hidden" name="user_ids" value="{{join .obj.UserIds ","}}" lay-verify="userIds">
            <div id="user_ids" style="text-align:center"></div>
        </div>
        <div class="layui-hide">
            <input type="hidden" name="id" value="{{.obj.Id}}">
            <button class="layui-btn layui-btn-small" lay-submit id="submit">提交</button>
        </div>
    </div>
</div>
<script>
    layui.main.cron('[name=spec]');
    //显示
    layui.transfer.render({
        id: 'userIdsData',
        elem: '#user_ids',
        title: ['全部用户', '已选用户'],
        data: {{.userData}},
        value: {{.userValue}},
        showSearch: true,
        onchange: function () {
            let data = layui.transfer.getData('userIdsData');
            let ids = [];
            for (let i = 0; i < data.length; i++) {
                ids.push(data[i].value)
            }
            $('input[name=user_ids]').val(ids.join(','))
        }
    });
    layui.main.slider({elem: '#tags_range', range: true, min: 1, max: 10});
    layui.form.verify({
        userIds: function (value) {
            if (!value) {
                return '最少要选择一个用户列表到右边';
            }
        }
    });
</script>