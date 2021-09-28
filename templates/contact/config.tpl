<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">样式:</label>
                <div class="layui-input-inline">
                    <select name="style_id" class="layui-select">
                        {{range $v:=.styles -}}
                            <option value="{{$v.Id}}"{{if eq $v.Id $.obj.StyleId}} selected{{end}}>{{$v.Name}}</option>
                        {{end -}}
                    </select>
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label" lay-tips="开启历史记录功能比较耗内存">历史记录:</label>
                <div class="layui-input-inline">
                    <input type="checkbox" name="history_enabled" lay-skin="switch"
                           lay-text="是|否"{{if .obj.HistoryEnabled}} checked{{end}}/>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">绑定域名:</label>
                <div class="layui-input-inline">
                    <input type="text" name="host" value="{{.obj.Host}}" lay-verify="required" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">指定客服:</label>
                <div class="layui-input-block">
                    <select name="waiter" class="layui-select">
                        <option value="">全部</option>
                        {{range .waiters -}}
                            <option value="{{.Username}}">{{.Alias}}</option>
                        {{end -}}
                    </select>
                </div>
            </div>
            <div class="layui-inline">
                <button class="layui-btn layui-btn-primary" lay-event="copy-js">复制广告代码</button>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">排序依据:</label>
            <div class="layui-input-block">
                {{range $k,$v:=.OrderBys -}}
                    <input name="order_by" value="{{$k}}" type="radio"
                           title="{{$v}}"{{if eq $.obj.OrderBy $k}} checked{{end}}>
                {{end -}}
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">在线咨询:</label>
            <div class="layui-input-inline" style="width: 50%">
                <input name="consult" value="{{.obj.Consult}}"
                       placeholder="http://p.qiao.baidu.com/cps/chat?siteId=15213845&userId=30737617&siteToken=b7387650dc45ac0bbeef7fc0f807ed9a"
                       class="layui-input">
            </div>
            <div class="layui-form-mid layui-word-aux">如QQ在线</div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" lay-tips="不选择则展示全部">区域:</label>
            <button class="layui-btn" lay-event="cities">选择城市</button>
            <input type="hidden" name="cities" value="{{join .obj.Cities ","}}">
        </div>
        <div class="layui-form-item" lay-filter="duration">
            <input type="hidden" name="durations">
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
            <label class="layui-form-label">其他:</label>
            <div class="layui-input-inline" style="width: 50%">
                <textarea name="other" class="layui-textarea" rows="4">{{.obj.Other}}</textarea>
            </div>
            <div class="layui-form-mid layui-word-aux">例如百度统计客服代码</div>
        </div>
        <div class="layui-form-item">
            <div class="layui-row">
                <div class="layui-col-md4">
                    <label class="layui-form-label">二维码:</label>
                    <div class="layui-input-inline">
                        <div class="layui-upload-drag" id="uploadFile">
                            <i class="layui-icon layui-icon-upload-drag"></i>
                            <p>点击上传文件，或将文件拖拽到此处！</p>
                        </div>
                    </div>
                </div>
                <div class="layui-col-md4">
                    <div class="layui-upload-list" id="uploadResult">
                        {{if .obj.QR -}}
                            <img height="130" width="130" alt="二维码" src="{{.obj.QR}}"/>
                        {{end -}}
                    </div>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label"></label>
            <button class="layui-btn" lay-submit lay-filter="submit">提交</button>
        </div>
        <div class="layui-hide">
            <button id="uploadSubmit"></button>
            <button id="submit"></button>
        </div>
    </div>
</div>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let main = layui.main,
            upload = layui.upload,
            transfer = layui.transfer,
            layDate = layui.laydate,
            loading,
            citiesData = {{.cityData}},
            durations = {{.obj.Durations}},
            delObj = $('*[lay-event=del-duration]'),
            addObj = $('*[lay-event=add-duration]');
        $('*[lay-submit][lay-filter="submit"]').click(function () {
            if ($('[name=host]').val() === '') {
                layer.tips("Host 不能为空", '[name=host]', {tips: 1, time: 10000});
                return false;
            }
            if ($('[name=file]').val()) {
                $('#uploadSubmit').click();
            } else {
                $('#submit').click();
            }
            return false;
        });
        $('#submit').click(function () {
            let field = main.formData();
            if (field.durations instanceof Array) {
                field.durations = field.durations.join();
            }
            main.req({url: url, data: field});
        });
        upload.render({
            elem: '#uploadFile',
            url: url,
            headers: {'X-CSRF-Token': csrfToken},
            size: 1024 * 50,
            accept: 'images',
            acceptMime: 'image/jpg,image/png',
            multiple: true,
            auto: false,
            bindAction: '#uploadSubmit',
            before: function () {
                this.data = main.formData();
                if (this.data.durations instanceof Array) {
                    this.data.durations = this.data.durations.join();
                }
                loading = layer.load(1, {shade: [0.7, '#000', true]});
            },
            choose: function (obj) {
                obj.preview(function (index, file, result) {
                    $('#uploadResult').html('<img height="130" width="130" alt="二维码" src="' + result + '" title="' + file.name + '"/>');
                });
            },
            done: function (res, index) {
                layer.close(loading);
                if (res.code === 0) {
                    layer.msg(res.msg, {icon: 1}, function () {
                        layer.close(index);
                    });
                    return false;
                }
                layer.alert(res.msg, {
                    skin: 'layui-layer-admin',
                    shadeClose: true,
                    icon: 2,
                    btn: '',
                    closeBtn: false,
                    anim: 6,
                    success: function (o, index) {
                        let elemClose = $('<i class="layui-icon" close>&#x1006;</i>');
                        o.append(elemClose);
                        elemClose.on('click', function () {
                            layer.close(index);
                        });
                    }
                });
            },
            error: function (index) {
                layer.close(index);
                layer.close(loading);
                main.err("网络错误");
            },
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
        // 添加时间段
        addObj.click(function () {
            let layKey = $(this).parents('div.layui-form-item').find('input:last').attr('lay-key') || 0;
            layKey++;
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
        if (durations) {
            durations.forEach(function (item, index) {
                index += 1;
                $('div[lay-filter=duration]>div.layui-btn-group').before('<div class="layui-input-inline"><input type="text" name="durations" value="' + item + '" class="layui-input" id="date-' + index + '" placeholder=" - "></div>');
                layDate.render({elem: '#date-' + index, type: 'time', range: true});
                delObj.css('display', 'inline-block');
            });
        }
        $('[lay-event="copy-js"]').click(function () {
            $.get(url + '/ad', {waiter: $('select[name=waiter]').val()}, function (jsCode) {
                main.copy.exec(jsCode, layer.msg('广告JS代码复制成功'));
            });
        });
        main.checkLNMP();
    });
</script>