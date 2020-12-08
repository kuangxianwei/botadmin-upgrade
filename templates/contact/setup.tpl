<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <div class="layui-row">
                <div class="layui-col-md3">
                    <label class="layui-form-label" lay-tips="不选择则展示全部">区域:</label>
                    <button class="layui-btn" lay-event="cities">选择城市</button>
                </div>
                <div class="layui-col-md6" id="cities" style="display:none;align-items: center;overflow: hidden;"></div>
            </div>
        </div>
        <div class="layui-form-item" lay-filter="duration">
            <label class="layui-form-label">时间范围:</label>
            <div class="layui-btn-group">
                <button class="layui-btn" lay-event="add-duration">
                    <i class="layui-icon layui-icon-add-circle"></i>
                </button>
                <button class="layui-btn layui-bg-red" lay-event="del-duration" style="display:none;">
                    <i class="layui-icon layui-icon-fonts-del"></i>
                </button>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">在线咨询:</label>
            <div class="layui-input-inline" style="width: 50%">
                <input name="consult" value="" autocomplete="off"
                       placeholder="http://p.qiao.baidu.com/cps/chat?siteId=15213845&userId=30737617&siteToken=b7387650dc45ac0bbeef7fc0f807ed9a"
                       class="layui-input">
            </div>
            <div class="layui-form-mid layui-word-aux">如QQ在线</div>
            <button class="layui-btn" lay-event="fill-consult">填充默认</button>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">其他:</label>
            <div class="layui-input-inline" style="width: 50%">
                <textarea name="other" class="layui-textarea" rows="4"></textarea>
            </div>
            <div class="layui-form-mid layui-word-aux">例如百度统计客服代码</div>
            <button class="layui-btn" lay-event="fill-other">填充默认</button>
        </div>
        <div class="layui-form-item layui-hide">
            <input name="usernames" value="{{.usernames}}">
            <button lay-submit lay-filter="setupSubmit">提交</button>
        </div>
    </div>
</div>
<script>
    layui.use(['main', 'transfer', 'laydate'], function () {
        let $ = layui.$,
            main = layui.main,
            layDate = layui.laydate,
            transfer = layui.transfer;
        // 填充咨询链接
        $('[lay-event="fill-consult"]').on('click', function () {
            main.req({
                url: '/contact/fill/consult', ending: function (res) {
                    $('[name="consult"]').val(res.data);
                }
            });
        });
        // 填充其他百度统计啥的
        $('[lay-event="fill-other"]').on('click', function () {
            main.req({
                url: '/contact/fill/other', ending: function (res) {
                    $('[name="other"]').val(res.data);
                }
            });
        });
        //显示城市搜索框
        transfer.render({
            id: 'cityData',
            elem: '#cities',
            data: {{.cityData}},
            title: ['全部城市', '城市'],
            value: '',
            showSearch: true
        });
        // 显示城市设置
        $('*[lay-event=cities]').click(function () {
            let obj = $('#cities');
            if (obj.css('display') === 'none') {
                obj.css('display', 'block');
            } else {
                obj.css('display', 'none');
            }
        });
        let delObj = $('*[lay-event=del-duration]');
        let addObj = $('*[lay-event=add-duration]');
        // 添加时间段
        addObj.click(function () {
            let layKey = $(this).parents('div.layui-form-item').find('input:last').attr('lay-key') || 0;
            layKey++
            $(this).parent().before('<div class="layui-input-inline"><input type="text" name="durations" class="layui-input" id="date-' + layKey + '" placeholder=" - "></div>');
            layDate.render({elem: '#date-' + layKey, type: 'time', range: true});
            delObj.css('display', 'inline-block');
        });
        // 删除时间段
        delObj.click(function () {
            $(this).parents('div.layui-form-item').find('input:last').parent().remove();
            let layKey = $(this).parents('div.layui-form-item').find('input:last').attr('lay-key');
            if (typeof layKey === 'undefined') {
                delObj.css('display', 'none');
            }
        });
    });
</script>

