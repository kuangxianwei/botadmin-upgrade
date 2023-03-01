<div class="layui-fluid" id="contact-common">
    <div class="layui-card">
        <div class="layui-card-body layui-form">
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
                <div class="layui-inline">
                    <a lay-href="/contact/style" lay-text="样式列表" class="layui-btn layui-btn-radius">管理样式</a>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">PC过滤:</label>
                    <div class="layui-input-inline">
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
                    <div class="layui-input-inline">
                        <select name="mobile_filter_id" class="layui-select">
                            <option value="0">禁用</option>
                            {{range $v:=.filters -}}
                                <option value="{{$v.Id}}"{{if eq $v.Id $.obj.MobileFilterId}} selected{{end}}>{{$v.Name}}</option>
                            {{end -}}
                        </select>
                    </div>
                </div>
                <div class="layui-inline">
                    <a lay-href="/contact/filter" lay-text="过滤器列表" class="layui-btn layui-btn-radius">管理过滤规则</a>
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
                    <div class="layui-upload-list" id="uploadResult"></div>
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
                <label class="layui-form-label" lay-tips="例如百度统计客服代码">其他:</label>
                <div class="layui-input-inline" style="width: 50%">
                    <textarea name="other" class="layui-textarea" rows="4" placeholder="填写javascript脚本代码">{{.obj.Other}}</textarea>
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
            qrPath = {{.obj.QR}};
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
            "fill-consult": function () {
                main.request({
                    url: '/contact/fill',
                    data: {field: "consult"},
                    done: function (res) {
                        $('[name=consult]').val(res.data);
                    }
                });
            },
            "fill-other": function () {
                main.request({
                    url: '/contact/fill',
                    data: {field: "other"},
                    done: function (res) {
                        $('[name=other]').val(res.data);
                    }
                });
            },
        };
        $('#contact-common [data-event]').off('click').on('click', function () {
            let $this = $(this), event = $this.data('event');
            active[event] && active[event].call($this);
        });
        if (qrPath) {
            $.get("/file/view", {path: qrPath}, function (res) {
                if (res.code === 0) {
                    $('#uploadResult').html('<img height="130" width="130" alt="二维码" src="' + res.data['data'] + '"/>');
                } else {
                    main.error(res.msg);
                }
            });
        }
        main.onFillContact();
    });
</script>