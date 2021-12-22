{{$tplTip:="{{phone}} 替换成手机号码<br>{{wechat}} 替换为微信号<br>{{alias}}  替换为别名<br>{{email}}  替换为电子邮箱<br>{{qr}}     替换为二维码图片地址<br>" -}}
<div class="layui-fluid" id="contact-common">
    <div class="layui-card">
        <div class="layui-card-body layui-form">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">PC样式:</label>
                    <div class="layui-input-inline">
                        <select name="pc_style_id" class="layui-select">
                            {{range $v:=.styles -}}
                                <option value="{{$v.Id}}"{{if eq $v.Id $.obj.PcStyleId}} selected{{end}}>{{$v.Name}}</option>
                            {{end -}}
                        </select>
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">Mobile样式:</label>
                    <div class="layui-input-inline">
                        <select name="mobile_style_id" class="layui-select">
                            {{range $v:=.styles -}}
                                <option value="{{$v.Id}}"{{if eq $v.Id $.obj.MobileStyleId}} selected{{end}}>{{$v.Name}}</option>
                            {{end -}}
                        </select>
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">启用PC:</label>
                    <div class="layui-input-block">
                        <input type="checkbox" name="pc_enabled" lay-skin="switch" lay-text="是|否"{{if .obj.PcEnabled}} checked{{end}}/>
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">启用Mobile:</label>
                    <div class="layui-input-block">
                        <input type="checkbox" name="mobile_enabled" lay-skin="switch" lay-text="是|否"{{if .obj.MobileEnabled}} checked{{end}}/>
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">排序:</label>
                    <div class="layui-input-inline">
                        <input type="number" name="sort" value="{{.obj.Sort}}" min="0" max="100" class="layui-input">
                    </div>
                    <div class="layui-form-mid layui-word-aux">值越大越排后面</div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-col-md6">
                    <label class="layui-form-label">用户名:</label>
                    <div class="layui-input-inline">
                        <input type="text" name="username" value="{{.obj.Username}}" lay-verify="required"
                               placeholder="liYi" class="layui-input"{{if .obj.Username}} disabled{{end}}>
                        {{if .obj.Username}}
                            <input type="hidden" name="username" value="{{.obj.Username}}" lay-verify="required">
                        {{end}}
                    </div>
                    <div class="layui-form-mid layui-word-aux">数字和字母组成</div>
                </div>
                <div class="layui-col-md6">
                    <label class="layui-form-label">别名:</label>
                    <div class="layui-input-inline">
                        <input type="text" name="alias" value="{{.obj.Alias}}" placeholder="李谊" class="layui-input">
                    </div>
                    <div class="layui-form-mid layui-word-aux">填写姓名</div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-col-md6">
                    <label class="layui-form-label">手机号:</label>
                    <div class="layui-input-inline">
                        <input type="text" name="phone" value="{{.obj.Phone}}" lay-verify="phone" placeholder="13724184818" class="layui-input">
                    </div>
                    <div class="layui-form-mid layui-word-aux">填写手机号码</div>
                </div>
                <div class="layui-col-md6">
                    <label class="layui-form-label">微信号:</label>
                    <div class="layui-input-inline">
                        <input type="text" name="wechat" value="{{.obj.Wechat}}" placeholder="13724184818" class="layui-input">
                    </div>
                    <div class="layui-form-mid layui-word-aux">留空默认为手机号码</div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-col-md6">
                    <label class="layui-form-label">最大限制:</label>
                    <div class="layui-input-inline">
                        <input type="number" name="max" value="{{.obj.Max}}" min="0" placeholder="0" class="layui-input">
                    </div>
                    <div class="layui-form-mid layui-word-aux">0为不限制</div>
                </div>
                <div class="layui-col-md6">
                    <label class="layui-form-label">权重:</label>
                    <div class="layui-input-inline">
                        <div id="weight" class="slider-inline"></div>
                        <input type="hidden" name="weight" value="{{$.obj.Weight}}" lay-verify="number">
                    </div>
                    <div class="layui-form-mid layui-word-aux">值越高 几率越高</div>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">电子邮箱:</label>
                <div class="layui-input-inline">
                    <input type="email" name="email" value="{{.obj.Email}}" placeholder="38050123@qq.com" class="layui-input">
                </div>
                <div class="layui-form-mid layui-word-aux">如开启了留言则发送到这个邮箱</div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">二维码:</label>
                    <div class="layui-input-inline">
                        <div class="layui-upload-drag" id="uploadFile">
                            <i class="layui-icon layui-icon-upload-drag"></i>
                            <p>点击上传文件，或将文件拖拽到此处！</p>
                        </div>
                    </div>
                </div>
                <div class="layui-inline">
                    <div class="layui-upload-list" id="uploadResult">
                        {{if .obj.QR -}}
                            <img height="130" width="130" alt="二维码" src="{{.obj.QR}}"/>
                        {{end -}}
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">在线咨询:</label>
                <div class="layui-input-inline" style="width: 50%">
                    <input name="consult" value="{{.obj.Consult}}" placeholder="填写在线咨询URL" class="layui-input">
                </div>
                <div class="layui-form-mid layui-word-aux">
                    <i class="layui-icon iconfont icon-fill" data-event="fill-consult" lay-tips="填充默认数据" style="color:#0c80ba"></i>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-col-md5">
                    <label class="layui-form-label"><cite lay-tips="一行一条规则(正则)">允许来路</cite>:<i class="layui-icon iconfont icon-fill" data-event="fill-allowed_referrer" lay-tips="填充全局配置" style="color:#0a5b52"></i></label>
                    <div class="layui-input-block">
                        <textarea class="layui-textarea" rows="3" name="allowed_referrer" placeholder="www.baidu.com&#13;www.sogou.com">{{join .obj.AllowedReferrer "\n"}}</textarea>
                    </div>
                </div>
                <div class="layui-col-md2">
                    <div class="layui-inline">
                        <label class="layui-form-label">电脑端:</label>
                        <div class="layui-input-block">
                            <input type="checkbox" name="enabled_referrer_pc" lay-skin="switch" lay-text="启用|禁用"{{if .obj.EnabledReferrerPc}} checked{{end}}>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <label class="layui-form-label">移动端:</label>
                        <div class="layui-input-block">
                            <input type="checkbox" name="enabled_referrer_mobile" lay-skin="switch" lay-text="启用|禁用"{{if .obj.EnabledReferrerMobile}} checked{{end}}>
                        </div>
                    </div>
                </div>
                <div class="layui-col-md5">
                    <label class="layui-form-label"><cite lay-tips="一行一条规则(正则)">拒绝来路</cite>:<i class="layui-icon iconfont icon-fill" data-event="fill-disallowed_referrer" lay-tips="填充全局配置" style="color:#0a5b52"></i></label>
                    <div class="layui-input-block">
                        <textarea class="layui-textarea" rows="3" name="disallowed_referrer" placeholder="www.google.com&#13;www.sogou.com">{{join .obj.DisallowedReferrer "\n"}}</textarea>
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">屏蔽区域:</label>
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
                    <button class="layui-btn layui-btn-sm" data-event="add-duration">
                        <i class="layui-icon layui-icon-add-circle"></i>
                    </button>
                    <button class="layui-btn layui-btn-sm layui-bg-red" data-event="del-duration" style="display:none;">
                        <i class="layui-icon layui-icon-fonts-del"></i>
                    </button>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label" lay-tips="例如百度统计客服代码">其他:</label>
                <div class="layui-input-inline" style="width: 50%">
                    <textarea name="other" class="layui-textarea" rows="4">{{.obj.Other}}</textarea>
                </div>
                <div class="layui-form-mid layui-word-aux">
                    <i class="layui-icon iconfont icon-fill" data-event="fill-other" lay-tips="填充默认数据" style="color:#0c80ba"></i>
                </div>
            </div>
            <div class="layui-hide">
                <input type="hidden" name="id" value="{{.obj.Id}}">
                <button lay-submit>提交</button>
                <button id="uploadSubmit"></button>
                <button id="submit"></button>
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
        cities = cities || [];
        durations = durations || [];
        if (citiesData && cities) {
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
        //滑块控制
        main.slider({elem: '#weight', value: {{.obj.Weight}}, max: 100});
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
            "fill-allowed_referrer": function () {
                main.req({
                    url: '/contact/fill',
                    data: {field: 'allowed_referrer'},
                    ending: function (res) {
                        $('[name=allowed_referrer]').val(res.data);
                    }
                });
            },
            "fill-disallowed_referrer": function () {
                main.req({
                    url: '/contact/fill',
                    data: {field: "disallowed_referrer"},
                    ending: function (res) {
                        $('[name=disallowed_referrer]').val(res.data);
                    }
                });
            },
            "fill-consult": function () {
                main.req({
                    url: '/contact/fill',
                    data: {field: "consult"},
                    ending: function (res) {
                        $('[name=consult]').val(res.data);
                    }
                });
            },
            "fill-other": function () {
                main.req({
                    url: '/contact/fill',
                    data: {field: "other"},
                    ending: function (res) {
                        $('[name=other]').val(res.data);
                    }
                });
            },
            "add-duration": function () {
                let layKey = this.parents('div.layui-form-item').find('input:last').attr('lay-key') || 0;
                layKey++;
                this.parent().before('<div class="layui-input-inline"><input type="text" name="duration" class="layui-input" id="date-' + layKey + '" placeholder=" - "></div>');
                layDate.render({elem: '#date-' + layKey, type: 'time', range: true});
                $('[data-event=del-duration]').show(200);
            },
            "del-duration": function () {
                this.parents('div.layui-form-item').find('input:last').parent().remove();
                let layKey = this.parents('div.layui-form-item').find('input:last').attr('lay-key');
                if (typeof layKey === 'undefined') {
                    $('[data-event=del-duration]').hide(200);
                }
            },
        };
        $('#contact-common [data-event]').off('click').on('click', function () {
            let $this = $(this), event = $this.data('event');
            active[event] && active[event].call($this);
        });
        if (durations) {
            durations.forEach(function (item, index) {
                index += 1;
                $('div[lay-filter=duration]>div.layui-btn-group').before('<div class="layui-input-inline"><input type="text" name="duration" value="' + item + '" class="layui-input" id="date-' + index + '" placeholder=" - "></div>');
                layDate.render({elem: '#date-' + index, type: 'time', range: true});
                $('[data-event=del-duration]').show(200);
            });
        }
        main.onFillContact();
    });
</script>