<style>
    .layui-form i.layui-icon.layui-icon-delete {
        color: red;
        cursor: pointer;
        display: inline-block;
    }
</style>
<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <label class="layui-form-label">启用PC:</label>
            <input type="checkbox" name="pc_enabled" lay-skin="switch" lay-text="是|否" checked/>
            <i class="layui-icon layui-icon-delete" lay-event="del"></i>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">启用Mobile:</label>
            <input type="checkbox" name="mobile_enabled" lay-skin="switch" lay-text="是|否" checked/>
            <i class="layui-icon layui-icon-delete" lay-event="del"></i>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">历史记录:</label>
            <input type="checkbox" name="history_enabled" lay-skin="switch" lay-text="是|否"/>
            <i class="layui-icon layui-icon-delete" lay-event="del"></i>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" lay-tips="不选择则展示全部">区域:</label>
            <button class="layui-btn" lay-event="cities">选择城市</button>
            <input type="hidden" name="cities" value="">
            <i class="layui-icon layui-icon-delete" lay-event="del"></i>
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
            <i class="layui-icon layui-icon-delete" lay-event="del"></i>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">在线咨询:</label>
            <div class="layui-input-inline" style="width: 50%">
                <input name="consult" value=""
                       placeholder="http://p.qiao.baidu.com/cps/chat?siteId=15213845&userId=30737617&siteToken=b7387650dc45ac0bbeef7fc0f807ed9a"
                       class="layui-input">
            </div>
            <div class="layui-form-mid layui-word-aux">如QQ在线</div>
            <button class="layui-btn" lay-event="fill-consult">填充默认</button>
            <i class="layui-icon layui-icon-delete" lay-event="del"></i>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">其他:</label>
            <div class="layui-input-inline" style="width: 50%">
                <textarea name="other" class="layui-textarea" rows="4"></textarea>
            </div>
            <div class="layui-form-mid layui-word-aux">例如百度统计客服代码</div>
            <button class="layui-btn" lay-event="fill-other">填充默认</button>
            <i class="layui-icon layui-icon-delete" lay-event="del"></i>
        </div>
        <div class="layui-form-item layui-hide">
            <input name="ids" value="{{.ids}}">
            <button lay-submit lay-filter="setupSubmit">提交</button>
        </div>
    </div>
</div>
<script>
    layui.use(['main'], function () {
        let main = layui.main,
            layDate = layui.laydate,
            transfer = layui.transfer,
            citiesData = {{.cityData}};
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
        // 监控城市
        $('*[lay-event=cities]').click(function () {
            main.pop({
                content: `<div id="cities"></div>`,
                success: function (dom) {
                    //显示城市搜索框
                    transfer.render({
                        title: ['全部城市', '城市'],
                        id: 'cityData',
                        elem: dom.find('#cities'),
                        data: citiesData,
                        value: $('*[name=cities]').val().split(','),
                        showSearch: true,
                    });
                },
                done: function () {
                    let cityData = transfer.getData('cityData'),
                        cities = [];
                    $.each(cityData, function (i, v) {
                        cities[i] = v.value;
                    });
                    $('*[name=cities]').val(cities.join())
                }
            });
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
        $('.layui-form>.layui-form-item>i[lay-event=del]').on('click', function () {
            $(this).parent().remove();
        });
    });
</script>

