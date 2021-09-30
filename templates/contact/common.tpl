{{$tplTip:="{{phone}} 替换成手机号码<br>{{wechat}} 替换为微信号<br>{{alias}}  替换为别名<br>{{email}}  替换为电子邮箱<br>{{qr}}     替换为二维码图片地址<br>"}}
<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-row">
            <div class="layui-col-md2">
                <label class="layui-form-label">启用PC:</label>
                <div class="layui-input-block">
                    <input type="checkbox" name="pc_enabled" lay-skin="switch" lay-text="是|否"{{if .obj.PcEnabled}} checked{{end}}/>
                </div>
            </div>
            <div class="layui-col-md2">
                <label class="layui-form-label">启用Mobile:</label>
                <div class="layui-input-block">
                    <input type="checkbox" name="mobile_enabled" lay-skin="switch" lay-text="是|否"{{if .obj.MobileEnabled}} checked{{end}}/>
                </div>
            </div>
            <div class="layui-col-md3">
                <label class="layui-form-label">样式:</label>
                <div class="layui-input-block">
                    <select name="style_id" class="layui-select">
                        {{range $v:=.styles -}}
                            <option value="{{$v.Id}}"{{if eq $v.Id $.obj.StyleId}} selected{{end}}>{{$v.Name}}</option>
                        {{end -}}
                    </select>
                </div>
            </div>
            <div class="layui-col-md2">
                <label class="layui-form-label" lay-tips="值越大越排后面">排序:</label>
                <div class="layui-input-block">
                    <input type="number" name="sort" value="{{.obj.Sort}}" min="0" max="100" class="layui-input">
                </div>
            </div>
            <div class="layui-col-md2">
                <label class="layui-form-label" lay-tips="开启历史记录功能比较耗内存">历史记录:</label>
                <div class="layui-input-block">
                    <input type="checkbox" name="history_enabled" lay-skin="switch" lay-text="是|否"{{if .obj.HistoryEnabled}} checked{{end}}/>
                </div>
            </div>
        </div>
        <div class="layui-form-item"></div>
        <div class="layui-row">
            <div class="layui-col-md5">
                <div class="layui-form-item">
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
            </div>
            <div class="layui-col-md6">
                <div class="layui-form-item">
                    <label class="layui-form-label">别名:</label>
                    <div class="layui-input-inline">
                        <input type="text" name="alias" value="{{.obj.Alias}}" placeholder="李谊" class="layui-input">
                    </div>
                    <div class="layui-form-mid layui-word-aux">填写姓名</div>
                </div>
            </div>
        </div>
        <div class="layui-row">
            <div class="layui-col-md5">
                <div class="layui-form-item">
                    <label class="layui-form-label">手机号:</label>
                    <div class="layui-input-inline">
                        <input type="text" name="phone" value="{{.obj.Phone}}" lay-verify="phone" placeholder="13724184818" class="layui-input">
                    </div>
                    <div class="layui-form-mid layui-word-aux">填写手机号码</div>
                </div>
            </div>
            <div class="layui-col-md6">
                <div class="layui-form-item">
                    <label class="layui-form-label">微信号:</label>
                    <div class="layui-input-inline">
                        <input type="text" name="wechat" value="{{.obj.Wechat}}" placeholder="13724184818" class="layui-input">
                    </div>
                    <div class="layui-form-mid layui-word-aux">留空默认为手机号码</div>
                </div>
            </div>
        </div>
        <div class="layui-row">
            <div class="layui-col-md5">
                <div class="layui-form-item">
                    <label class="layui-form-label">最大限制:</label>
                    <div class="layui-input-inline">
                        <input type="number" name="max" value="{{.obj.Max}}" min="0" placeholder="0" class="layui-input">
                    </div>
                    <div class="layui-form-mid layui-word-aux">0为不限制</div>
                </div>
            </div>
            <div class="layui-col-md6">
                <div class="layui-form-item">
                    <label class="layui-form-label">权重:</label>
                    <div class="layui-input-inline">
                        <div id="weight" class="slider-inline"></div>
                        <input type="hidden" name="weight" value="{{$.obj.Weight}}" lay-verify="number">
                    </div>
                    <div class="layui-form-mid layui-word-aux">值越高 几率越高</div>
                </div>
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
            <div class="layui-form-mid layui-word-aux">如QQ在线</div>
            <button class="layui-btn" lay-event="fill-consult">填充默认</button>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" lay-tips="选中的区域则不显示联系信息">屏蔽区域:</label>
            <button class="layui-btn layui-btn-radius layui-btn-primary" lay-event="cities">选择</button>
            <input type="hidden" name="cities" value="{{join .obj.Cities ","}}">
        </div>
        <div class="layui-form-item" lay-filter="duration">
            <input type="hidden" name="durations">
            <label class="layui-form-label">开放时间:</label>
            <div class="layui-btn-group" style="line-height: 38px">
                <button class="layui-btn layui-btn-sm" lay-event="add-duration">
                    <i class="layui-icon layui-icon-add-circle"></i>
                </button>
                <button class="layui-btn layui-btn-sm layui-bg-red" lay-event="del-duration" style="display:none;">
                    <i class="layui-icon layui-icon-fonts-del"></i>
                </button>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label" lay-tips="延时弹窗时间，单位为秒 0秒为关闭弹窗">延时弹窗:</label>
                <div class="layui-input-inline" style="width:60px">
                    <input type="number" name="tip_delay" value="{{.obj.TipDelay}}" min="0" class="layui-input">
                </div>
            </div>
            <div class="layui-inline" style="width:80px">
                <input type="radio" name="tip_pure" value="false" title="非纯"{{if not .obj.TipPure}} checked{{end}}>
                <input type="radio" name="tip_pure" value="true" title="纯净"{{if .obj.TipPure}} checked{{end}}>
            </div>
            <div class="layui-inline" style="width:650px">
                <textarea name="tip_html" class="layui-textarea" rows="3" placeholder="弹窗广告宣传语HTML代码">{{.obj.TipHtml}}</textarea>
                <div class="layui-input-block" style="margin-top:-5px;margin-bottom:-10px">
                    <button class="layui-btn layui-btn-xs layui-btn-radius layui-btn-primary" data-write="default">
                        填充默认
                    </button>
                    <button class="layui-btn layui-btn-xs layui-btn-radius" data-write="phone">插入手机号</button>
                    <button class="layui-btn layui-btn-xs layui-btn-radius" data-write="wechat">插入微信号</button>
                    <button class="layui-btn layui-btn-xs layui-btn-radius" data-write="alias">插入别名</button>
                    <button class="layui-btn layui-btn-xs layui-btn-radius" data-write="email">插入邮箱</button>
                    <button class="layui-btn layui-btn-xs layui-btn-radius" data-write="qr">插入二维码</button>
                    <i class="layui-icon layui-icon-tips" lay-tips="{{$tplTip}}" style="color:coral"></i>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">其他:</label>
            <div class="layui-input-inline" style="width: 50%">
                <textarea name="other" class="layui-textarea" rows="4">{{.obj.Other}}</textarea>
            </div>
            <div class="layui-form-mid layui-word-aux">例如百度统计客服代码</div>
            <button class="layui-btn" lay-event="fill-other">填充默认</button>
        </div>
        <div class="layui-hide">
            <input type="hidden" name="id" value="{{.obj.Id}}">
            <button lay-submit>提交</button>
            <button id="uploadSubmit"></button>
            <button id="submit"></button>
            <input type="hidden" name="cols" value="pc_enabled,mobile_enabled,style_id,sort,history_enabled,alias,phone,wechat,max,weight,email,consult,cities,durations,tip_delay,tip_pure,tip_html,other">
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
            addObj = $('*[lay-event=add-duration]'),
            delObj = $('*[lay-event=del-duration]');
        //滑块控制
        main.slider({elem: '#weight', value: {{.obj.Weight}}, max: 100});
        $('[lay-event="fill-consult"]').off('click').on('click', function () {
            main.req({
                url: '/contact/fill/consult', ending: function (res) {
                    $('[name="consult"]').val(res.data);
                }
            });
        });
        $('[lay-event="fill-other"]').off('click').on('click', function () {
            main.req({
                url: '/contact/fill/other', ending: function (res) {
                    $('[name="other"]').val(res.data);
                }
            });
        });
        // 监控城市
        $('*[lay-event=cities]').off('click').on('click', function () {
            main.pop({
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
        addObj.off('click').on('click', function () {
            let layKey = $(this).parents('div.layui-form-item').find('input:last').attr('lay-key') || 0;
            layKey++;
            $(this).parent().before('<div class="layui-input-inline"><input type="text" name="duration" class="layui-input" id="date-' + layKey + '" placeholder=" - "></div>');
            layDate.render({elem: '#date-' + layKey, type: 'time', range: true});
            delObj.show(200);
        });
        // 删除时间段
        delObj.off('click').on('click', function () {
            $(this).parents('div.layui-form-item').find('input:last').parent().remove();
            let layKey = $(this).parents('div.layui-form-item').find('input:last').attr('lay-key');
            if (typeof layKey === 'undefined') {
                delObj.hide(200);
            }
        });
        if (durations) {
            durations.forEach(function (item, index) {
                index += 1;
                $('div[lay-filter=duration]>div.layui-btn-group').before('<div class="layui-input-inline"><input type="text" name="duration" value="' + item + '" class="layui-input" id="date-' + index + '" placeholder=" - "></div>');
                layDate.render({elem: '#date-' + index, type: 'time', range: true});
                delObj.show(200);
            });
        }
        let tipHtmlElem = $("textarea[name=tip_html]");
        $('[data-write]').off("click").on("click", function () {
            let write = $(this).data("write"), val;
            switch (write) {
                case "qr":
                    val = tipHtmlElem.val() + '<img src="{{"{{"}}qr{{"}}"}}" alt="微信号:{{"{{"}}wechat{{"}}"}}" width="150" height="150">';
                    break;
                case "default":
                    val = "{{"{{"}}alias{{"}}"}}很高兴为您服务，您可以拨打电话{{"{{"}}phone{{"}}"}}、加微信{{"{{"}}wechat{{"}}"}}或者邮箱{{"{{"}}email{{"}}"}}联系我们！"
                    break;
                default:
                    val = tipHtmlElem.val() + "{{"{{"}}" + write + "{{"}}"}}";
            }
            tipHtmlElem.val(val).focus();
        });
    });
</script>