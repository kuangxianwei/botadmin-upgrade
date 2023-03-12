<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">Scheme:</label>
                <div class="layui-input-block">
                    <input name="scheme" value="http://" type="radio" title="http://"{{if eq $.obj.Scheme "http://"}} checked{{end}}>
                    <input name="scheme" value="https://" type="radio" title="https://"{{if eq $.obj.Scheme "https://"}} checked{{end}}>
                </div>
            </div>
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
                <button class="layui-btn layui-btn-primary" data-event="copyJS">复制广告代码</button>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">PC样式:</label>
                <div class="layui-input-inline" style="width:120px">
                    <select name="pc_style_id" class="layui-select">
                        {{range $v:=.styles -}}
                            <option value="{{$v.Id}}"{{if eq $v.Id $.obj.PcStyleId}} selected{{end}}>{{$v.Name}}</option>
                        {{end -}}
                    </select>
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">Mobile样式:</label>
                <div class="layui-input-inline" style="width:120px">
                    <select name="mobile_style_id" class="layui-select">
                        {{range $v:=.styles -}}
                            <option value="{{$v.Id}}"{{if eq $v.Id $.obj.MobileStyleId}} selected{{end}}>{{$v.Name}}</option>
                        {{end -}}
                    </select>
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">PC过滤:</label>
                <div class="layui-input-inline" style="width:120px">
                    <select name="pc_filter_id" class="layui-select">
                        <option value="0">禁用</option>
                        {{range $v:=.filters -}}
                            <option value="{{$v.Id}}"{{if eq $v.Id $.obj.PcFilterId}} selected{{end}}>{{$v.Name}}</option>
                        {{end -}}
                    </select>
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">Mobile过滤:</label>
                <div class="layui-input-inline" style="width:120px">
                    <select name="mobile_filter_id" class="layui-select">
                        <option value="0">禁用</option>
                        {{range $v:=.filters -}}
                            <option value="{{$v.Id}}"{{if eq $v.Id $.obj.MobileFilterId}} selected{{end}}>{{$v.Name}}</option>
                        {{end -}}
                    </select>
                </div>
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
            <div class="layui-col-md6">
                <label class="layui-form-label">电子邮箱:</label>
                <div class="layui-input-inline">
                    <input name="email" value="{{.obj.Email}}" placeholder="38050123@qq.com" class="layui-input">
                </div>
                <div class="layui-form-mid layui-word-aux">主要用于在线留言提醒</div>
            </div>
            <div class="layui-col-md6">
                <label class="layui-form-label" lay-tips="匹配(正则)的页面则不显示广告">拒绝广告:</label>
                <div class="layui-input-block">
                    <input name="deny" value="{{.obj.Deny}}" type="text" class="layui-input" placeholder="\.(php|asp|js|css)(\?|$)">
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">在线咨询:</label>
            <div class="layui-input-inline" style="width: 50%">
                <input name="consult" value="{{.obj.Consult}}" placeholder="http://第三方在线客服链接" class="layui-input">
            </div>
            <div class="layui-form-mid layui-word-aux">第三方在线客服链接</div>
        </div>
        <div class="layui-form-item">
            <div class="layui-col-md6">
                <label class="layui-form-label" lay-tips="一行一条规则(正则)">来路白名单:</label>
                <div class="layui-input-block">
                    <textarea class="layui-textarea" name="allowed" placeholder="www.baidu.com&#13;www.sogou.com">{{join .obj.Allowed "\n"}}</textarea>
                </div>
            </div>
            <div class="layui-col-md6">
                <label class="layui-form-label" lay-tips="一行一条规则(正则)">来路黑名单:</label>
                <div class="layui-input-block">
                    <textarea class="layui-textarea" name="disallowed" placeholder="www.google.com&#13;www.sogou.com">{{join .obj.Disallowed "\n"}}</textarea>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" lay-tips="不选择则展示全部">屏蔽区域:</label>
            <input type="hidden" name="cities" value="{{join .obj.Cities ","}}">
            <div class="layui-form-mid layui-word-aux">
                <i class="layui-icon layui-icon-edit" data-event="cities" style="color:#22849b"></i>
                <cite style="margin-left:10px"></cite>
            </div>
        </div>
        <div class="layui-form-item" lay-filter="duration">
            <input type="hidden" name="durations">
            <label class="layui-form-label">开放时间:</label>
            <div class="layui-btn-group" style="line-height: 38px">
                <button class="layui-btn layui-btn-sm" data-event="addDuration">
                    <i class="layui-icon layui-icon-add-circle"></i>
                </button>
                <button class="layui-btn layui-btn-sm layui-bg-red" data-event="delDuration" style="display:none;">
                    <i class="layui-icon layui-icon-fonts-del"></i>
                </button>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">其他:</label>
            <div class="layui-input-inline" style="width: 50%">
                <textarea name="other" class="layui-textarea" placeholder="填写Javascript脚本代码" rows="4">{{.obj.Other}}</textarea>
            </div>
            <div class="layui-form-mid layui-word-aux">例如百度统计客服代码</div>
        </div>
        <div class="layui-form-item">
            <button class="layui-btn layui-btn-radius" data-event="submit" style="margin-left:40%">提交</button>
        </div>
    </div>
</div>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let main = layui.main,
            layDate = layui.laydate,
            transfer = layui.transfer,
            citiesData = {{.cityData}},
            durations = {{.obj.Durations}},
            cities = {{.obj.Cities}};
        citiesData = citiesData || [];
        durations = durations || [];
        cities = cities || [];
        if (Array.isArray(citiesData) && Array.isArray(cities)) {
            let titles = [];
            for (let i = 0; i < cities.length; i++) {
                cities[i] = cities[i].toString();
            }
            $.each(citiesData, function (i, v) {
                if (cities.indexOf(v.value) !== -1) {
                    titles.push(v.title);
                }
            });
            $('[name=cities]+div>cite').text(titles.join());
        }
        let active = {
            submit: function () {
                let field = main.formData();
                field.durations = field.duration ? (Array.isArray(field.duration) ? field.duration.join() : field.duration) : '';
                main.request({url: url, data: field});
            },
            cities: function () {
                main.display({
                    type: 0,
                    btn: ['确定'],
                    content: `<div id="cities"></div>`,
                    success: function (dom) {
                        //显示城市搜索框
                        transfer.render({
                            title: ['全部区域', '屏蔽区域'],
                            id: 'cityData',
                            elem: dom.find('#cities'),
                            data: citiesData,
                            value: $('*[name=cities]').val().split(','),
                            showSearch: true,
                        });
                    },
                    yes: function (index) {
                        let cityData = transfer.getData('cityData'), cities = [], titles = [];
                        $.each(cityData, function (i, v) {
                            cities[i] = v.value;
                            titles[i] = v.title;
                        });
                        $('*[name=cities]').val(cities.join());
                        $('*[name=cities]+div>cite').text(titles.join());
                        layer.close(index);
                    },
                    area: ["540px", "450px"],
                });
            },
            copyJS: function () {
                let loading = main.loading();
                $.get(url + '/ad', {waiter: $('select[name=waiter]').val()}, function (jsCode) {
                    loading.close();
                    main.copy(jsCode, layer.msg('广告JS代码复制成功'));
                });
            },
            addDuration: function () {
                let layKey = this.parents('div.layui-form-item').find('input:last').attr('lay-key') || 0;
                layKey++;
                this.parent().before('<div class="layui-input-inline"><input type="text" name="duration" class="layui-input" id="date-' + layKey + '" placeholder=" - "></div>');
                layDate.render({elem: '#date-' + layKey, type: 'time', range: true});
                $('[data-event=delDuration]').show(200);
            },
            delDuration: function () {
                this.parents('div.layui-form-item').find('input:last').parent().remove();
                let layKey = this.parents('div.layui-form-item').find('input:last').attr('lay-key');
                if (typeof layKey === 'undefined') {
                    $('[data-event=delDuration]').hide(200);
                }
            },
        };
        $('[data-event]').off('click').on('click', function () {
            let $this = $(this), event = $this.data("event");
            active[event] && active[event].call($this);
        });
        if (durations) {
            durations.forEach(function (item, index) {
                index += 1;
                $('div[lay-filter=duration]>div.layui-btn-group').before('<div class="layui-input-inline"><input type="text" name="duration" value="' + item + '" class="layui-input" id="date-' + index + '" placeholder=" - "></div>');
                layDate.render({elem: '#date-' + index, type: 'time', range: true});
                $('[data-event=delDuration]').show(200);
            });
        }
        main.checkLNMP();
    });
</script>