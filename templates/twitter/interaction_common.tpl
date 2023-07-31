<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item layui-row">
            <div class="layui-col-md4">
                <label for="name" class="layui-form-label">名称:</label>
                <div class="layui-input-block">
                    <input type="text" name="name" id="name" value="{{.obj.Name}}" placeholder="默认1" class="layui-input" lay-verify="name">
                </div>
            </div>
            <div class="layui-col-md3">
                <label for="enabled" class="layui-form-label">定时:</label>
                <div class="layui-input-block">
                    <input type="checkbox" name="enabled" id="enabled" lay-skin="switch" lay-text="启用|禁用" title="启用|禁用"{{if .obj.Enabled}} checked{{end}}>
                </div>
            </div>
            <div class="layui-col-md5">
                <label for="spec" class="layui-form-label">定时规则:</label>
                <div class="layui-input-block">
                    <input type="text" name="spec" id="spec" value="{{.obj.Spec}}" class="layui-input">
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">互动项目:</label>
            <input name="retweet" type="checkbox" title="转发" {{if .obj.Retweet}} checked{{end}}/>
            <input name="reply" type="checkbox" title="回复" {{if .obj.Reply}} checked{{end}}/>
            <input name="like" type="checkbox" title="点赞" {{if .obj.Like}} checked{{end}}/>
            <input name="share" type="checkbox" title="分享" {{if .obj.Share}} checked{{end}}/>
            <input name="follow" type="checkbox" title="关注" {{if .obj.Follow}} checked{{end}}/>
        </div>
        <div class="layui-form-item">
            <label for="target_count" class="layui-form-label">目标数:</label>
            <div class="layui-input-inline">
                <input type="number" min="1" max="100" name="target_count" value="{{.obj.TargetCount}}" id="target_count" class="layui-input"/>
            </div>
            <div class="layui-form-mid layui-word-aux">每次随机抽取N个目标用户名称互动</div>
        </div>
        <div class="layui-form-item layui-row">
            <div class="layui-col-md6">
                <label for="targets" class="layui-form-label" lay-tips="被互动的用户名称列表，一行一个">目标列表:</label>
                <div class="layui-input-block">
                    <textarea class="layui-textarea" placeholder="留空则选择最新发布的推文&#10;用户名1&#10;用户名2" name="targets" id="targets">{{join .obj.Targets "\n"}}</textarea>
                </div>
            </div>
            <div class="layui-col-md6">
                <label for="texts" class="layui-form-label" lay-tips="回复的文本列表，一行一个">回复文本:
                    <br/>
                    <div class="layui-form-mid layui-word-aux" lay-tips="把推文写在一个文本文件里面,一行一条，系统会随机调用" style="display:inline-block;float: right">
                        <a lay-href="/file?path=data/ad/twitter/tweet" lay-text="推文管理" style="color: #0a93bf"><strong>推文管理</strong></a>
                    </div>
                </label>
                <div class="layui-input-block">
                    <textarea class="layui-textarea" placeholder="留空则随机选择文本库的语句&#10;推文1&#10;推文2" name="texts" id="texts">{{join .obj.Texts "\n"}}</textarea>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <input type="hidden" name="user_ids" value="{{join .obj.UserIds ","}}" lay-verify="userIds">
            <div id="user_ids" style="text-align:center"></div>
        </div>
        <div class="layui-hide">
            <input type="hidden" name="id" value="{{.obj.Id}}">
            <button lay-submit></button>
        </div>
    </div>
</div>
<script>
    // 定时选择器
    layui.main.cron('input[name=spec]');
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
    layui.form.verify({
        userIds: function (value) {
            if (!value) {
                return '最少要选择一个用户列表到右边';
            }
        }
    });
</script>