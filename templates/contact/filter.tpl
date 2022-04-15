<div class="layui-fluid" id="contact-filter">
    <div class="layui-card">
        <div class="layui-card-body layui-form">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">名称:</label>
                    <div class="layui-input-inline">
                        <input name="name" value="{{.obj.Name}}" type="text" class="layui-input" lay-verify="required" placeholder="过滤器名称">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label" lay-tips="匹配(正则)的页面则不显示广告">拒绝广告:</label>
                    <div class="layui-input-block">
                        <input name="deny" value="{{.obj.Deny}}" type="text" class="layui-input" placeholder="\.(php|asp|js|css)(\?|$)">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label"><cite lay-tips="一行一条规则(正则)">允许来路</cite>:<i class="layui-icon iconfont icon-fill" data-event="fillAllowed" lay-tips="填充全局配置" style="color:#0a5b52"></i></label>
                <div class="layui-input-block">
                    <textarea class="layui-textarea" rows="3" name="allowed" placeholder="www.baidu.com&#13;www.sogou.com">{{join .obj.Allowed "\n"}}</textarea>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label"><cite lay-tips="一行一条规则(正则)">拒绝来路</cite>:<i class="layui-icon iconfont icon-fill" data-event="fillDisallowed" lay-tips="填充全局配置" style="color:#0a5b52"></i></label>
                <div class="layui-input-block">
                    <textarea class="layui-textarea" rows="3" name="disallowed" placeholder="www.google.com&#13;www.sogou.com">{{join .obj.Disallowed "\n"}}</textarea>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label"><cite>屏蔽区域</cite>:<i class="layui-icon iconfont icon-fill" data-event="fillCities" lay-tips="填充全局配置" style="color:#0a5b52"></i></label>
                <input type="hidden" name="cities" value="{{join .obj.Cities ","}}">
                <div class="layui-form-mid layui-word-aux">
                    <i class="layui-icon layui-icon-edit" data-event="cities" style="color:#22849b"></i>
                    <cite style="margin-left:10px"></cite>
                </div>
            </div>
            <div class="layui-form-item" lay-filter="duration">
                <input type="hidden" name="durations">
                <label class="layui-form-label"><cite>开放时间</cite>:<i class="layui-icon iconfont icon-fill" data-event="fillDurations" lay-tips="填充全局配置" style="color:#0a5b52"></i></label>
                <div class="layui-btn-group" style="line-height: 38px">
                    <button class="layui-btn layui-btn-sm" data-event="addDuration">
                        <i class="layui-icon layui-icon-add-circle"></i>
                    </button>
                    <button class="layui-btn layui-btn-sm layui-bg-red" data-event="delDuration" style="display:none;">
                        <i class="layui-icon layui-icon-fonts-del"></i>
                    </button>
                </div>
            </div>
            <div class="layui-hide">
                <input type="hidden" name="id" value="{{.obj.Id}}">
                <button lay-submit>提交</button>
            </div>
        </div>
    </div>
</div>
<script>
    layui.use(['main'], function () {
        let main = layui.main,
            layDate = layui.laydate,
            transfer = layui.transfer,
            citiesData = {{.cityData}},
            durations = {{.obj.Durations}},
            cities = {{.obj.Cities}};
        citiesData = citiesData || [];
        durations = durations || [];
        cities = cities || [];
        let fillCities = function (cities) {
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
                    $('[name=cities]').val(cities.join());
                }
            },
            fillDurations = function (durations) {
                if (durations) {
                    $('[name=duration]').parent().remove();
                    $('[data-event=delDuration]').hide();
                    durations.forEach(function (item, index) {
                        index += 1;
                        $('div[lay-filter=duration]>div.layui-btn-group').before('<div class="layui-input-inline"><input type="text" name="duration" value="' + item + '" class="layui-input" id="date-' + index + '" placeholder=" - "></div>');
                        layDate.render({elem: '#date-' + index, type: 'time', range: true});
                        $('[data-event=delDuration]').show(200);
                    });
                }
            }
        fillDurations(durations);
        fillCities(cities);
        let active = {
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
            fillAllowed: function () {
                main.request({
                    url: '/contact/fill',
                    data: {field: 'allowed'},
                    done: function (res) {
                        $('[name=allowed]').val(res.data);
                    }
                });
            },
            fillDisallowed: function () {
                main.request({
                    url: '/contact/fill',
                    data: {field: "disallowed"},
                    done: function (res) {
                        $('[name=disallowed]').val(res.data);
                    }
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
            fillCities: function () {
                main.request({
                    url: '/contact/fill',
                    data: {field: 'cities'},
                    done: function (res) {
                        fillCities(res.data);
                    }
                });
            },
            fillDurations: function () {
                main.request({
                    url: '/contact/fill',
                    data: {field: 'durations'},
                    done: function (res) {
                        fillDurations(res.data);
                    }
                });
            },
        };
        $('#contact-filter [data-event]').off('click').on('click', function () {
            let $this = $(this), event = $this.data('event');
            active[event] && active[event].call($this);
        });
        main.onFillContact();
    });
</script>