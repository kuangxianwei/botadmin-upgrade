<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <label class="layui-form-label">名称:</label>
            <div class="layui-input-inline">
                <input type="text" name="name" value="{{.obj.Name}}" autocomplete="off" placeholder="名称"
                       class="layui-input">
            </div>
            <div class="layui-form-mid layui-word-aux">样式名称</div>
        </div>
        <div class="layui-row">
            <div class="layui-col-md4">
                <div class="layui-form-item">
                    <label class="layui-form-label">浮动:</label>
                    <div class="layui-input-block">
                        <input type="radio" name="float" value="0" title="靠右"{{if eq .obj.Float 0}} checked{{end}}>
                        <input type="radio" name="float" value="1" title="靠左"{{if gt .obj.Float 0}} checked{{end}}>
                    </div>
                </div>
            </div>
            <div class="layui-col-md6">
                <div class="layui-form-item">
                    <label class="layui-form-label">距顶:</label>
                    <div class="layui-input-inline">
                        <input type="text" name="top" value="{{.obj.Top}}" placeholder="22%"
                               class="layui-input">
                    </div>
                    <div class="layui-form-mid layui-word-aux">到网页顶部的距离 %或者px</div>
                </div>
            </div>
        </div>
        <div class="layui-row layui-col-space5">
            <div class="layui-col-md3">
                <label class="layui-form-label">文本颜色:</label>
                <div class="layui-input-inline" style="width: 100px;">
                    <input type="text" name="color" value="{{.obj.Color}}" placeholder="请选择颜色" class="layui-input">
                </div>
                <div class="layui-inline" style="left: -11px;">
                    <div id="color"></div>
                </div>
            </div>
            <div class="layui-col-md3">
                <label class="layui-form-label">背景颜色:</label>
                <div class="layui-input-inline" style="width: 100px;">
                    <input type="text" name="bg_color" value="{{.obj.BgColor}}" placeholder="请选择颜色"
                           class="layui-input">
                </div>
                <div class="layui-inline" style="left: -11px;">
                    <div id="bg_color"></div>
                </div>
            </div>
            <div class="layui-col-md3">
                <label class="layui-form-label">Svg颜色:</label>
                <div class="layui-input-inline" style="width: 100px;">
                    <input type="text" name="svg_color" value="{{.obj.SvgColor}}" placeholder="请选择颜色"
                           class="layui-input">
                </div>
                <div class="layui-inline" style="left: -11px;">
                    <div id="svg_color"></div>
                </div>
            </div>
            <div class="layui-col-md3">
                <label class="layui-form-label" lay-tips="鼠标在上面时候的颜色">Hover颜色:</label>
                <div class="layui-input-inline" style="width: 100px;">
                    <input type="text" name="hover_color" value="{{.obj.HoverColor}}" placeholder="请选择颜色"
                           class="layui-input">
                </div>
                <div class="layui-inline" style="left: -11px;">
                    <div id="hover_color"></div>
                </div>
            </div>
        </div>
        <div class="layui-form-item"></div>
        <div class="layui-form-item">
            <label class="layui-form-label" lay-tips="手机图标">手机Svg:</label>
            <div class="layui-input-inline" style="width: 80%">
                <input type="text" name="phone_svg" value="{{.obj.PhoneSvg}}" autocomplete="off" placeholder="手机图标代码"
                       class="layui-input">
                <input type="hidden" name="phone_text" value="{{.obj.PhoneText}}">
                <input type="hidden" name="mobile_phone_text" value="{{.obj.MobilePhoneText}}">
            </div>
            <button class="layui-btn" lay-event="phone">提示文本</button>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" lay-tips="微信图标">微信Svg:</label>
            <div class="layui-input-inline" style="width: 80%">
                <input type="text" name="wechat_svg" value="{{.obj.WechatSvg}}" placeholder="微信图标代码" autocomplete="off"
                       class="layui-input">
                <input type="hidden" name="wechat_text" value="{{.obj.WechatText}}">
                <input type="hidden" name="mobile_wechat_text" value="{{.obj.MobileWechatText}}">
            </div>
            <button class="layui-btn" lay-event="wechat">提示文本</button>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" lay-tips="咨询图标">咨询Svg:</label>
            <div class="layui-input-inline" style="width: 80%">
                <input type="text" name="consult_svg" value="{{.obj.ConsultSvg}}" placeholder="咨询图标代码"
                       autocomplete="off" class="layui-input">
                <input type="hidden" name="consult_text" value="{{.obj.ConsultText}}">
                <input type="hidden" name="mobile_consult_text" value="{{.obj.MobileConsultText}}">
            </div>
            <button class="layui-btn" lay-event="consult">提示文本</button>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label"></label>
            <button class="layui-btn" lay-event="pc-css">PC端自定义css</button>
            <button class="layui-btn" lay-event="mobile-css">移动端自定义css</button>
            <input type="hidden" name="pc_css" value="{{.obj.PcCss}}">
            <input type="hidden" name="mobile_css" value="{{.obj.MobileCss}}">
        </div>
        <div class="layui-form-item layui-hide">
            <input name="id" value="{{.obj.Id}}">
            <button lay-submit>提交</button>
        </div>
    </div>
</div>
<script>
    layui.use(['main', 'colorpicker'], function () {
        let $ = layui.$,
            main = layui.main,
            colorpicker = layui.colorpicker;
        //表单赋值
        colorpicker.render({
            elem: '#color',
            color: $('*[name=color]').val(),
            done: function (color) {
                $('*[name=color]').val(color);
            }
        });
        colorpicker.render({
            elem: '#bg_color',
            color: $('*[name=bg_color]').val(),
            done: function (color) {
                $('*[name=bg_color]').val(color);
            }
        });
        colorpicker.render({
            elem: '#svg_color',
            color: $('*[name=svg_color]').val(),
            done: function (color) {
                $('*[name=svg_color]').val(color);
            }
        });
        colorpicker.render({
            elem: '#hover_color',
            color: $('*[name=hover_color]').val(),
            done: function (color) {
                $('*[name=hover_color]').val(color);
            }
        });
        $('*[lay-event=phone]').click(function () {
            main.confirm($('#text').html(), {
                scroll: false,
                success: function (dom) {
                    dom.find('*[name=pc]').val($('*[name=phone_text]').val());
                    dom.find('*[name=mobile]').val($('*[name=mobile_phone_text]').val());
                },
                done: function (dom) {
                    $('*[name=phone_text]').val(dom.find('*[name=pc]').val());
                    $('*[name=mobile_phone_text]').val(dom.find('*[name=mobile]').val());
                }
            });
        });
        $('*[lay-event=wechat]').click(function () {
            main.confirm($('#text').html(), {
                scroll: false,
                success: function (dom) {
                    dom.find('*[name=pc]').val($('*[name=wechat_text]').val());
                    dom.find('*[name=mobile]').val($('*[name=mobile_wechat_text]').val());
                },
                done: function (dom) {
                    $('*[name=wechat_text]').val(dom.find('*[name=pc]').val());
                    $('*[name=mobile_wechat_text]').val(dom.find('*[name=mobile]').val());
                }
            });
        });
        $('*[lay-event=consult]').click(function () {
            main.confirm($('#text').html(), {
                scroll: false,
                success: function (dom) {
                    dom.find('*[name=pc]').val($('*[name=consult_text]').val());
                    dom.find('*[name=mobile]').val($('*[name=mobile_consult_text]').val());
                },
                done: function (dom) {
                    $('*[name=consult_text]').val(dom.find('*[name=pc]').val());
                    $('*[name=mobile_consult_text]').val(dom.find('*[name=mobile]').val());
                }
            });
        });
        $('*[lay-event=pc-css]').click(function () {
            main.confirm($('#css').html(), {
                scroll: false,
                area: ['70%', '70%'],
                success: function (dom) {
                    dom.find('*[name=css]').val($('*[name=pc_css]').val());
                },
                done: function (dom) {
                    $('*[name=pc_css]').val(dom.find('*[name=css]').val());
                }
            });
        });
        $('*[lay-event=mobile-css]').click(function () {
            main.confirm($('#css').html(), {
                scroll: false,
                area: ['70%', '70%'],
                success: function (dom) {
                    dom.find('*[name=css]').val($('*[name=mobile_css]').val());
                },
                done: function (dom) {
                    $('*[name=mobile_css]').val(dom.find('*[name=css]').val());
                }
            });
        });
    });
</script>
<script type="text/html" id="text">
    <div class="layui-form-item">
        <label class="layui-form-label">PC:</label>
        <div class="layui-input-inline">
            <input type="text" name="pc" value="" class="layui-input">
        </div>
        <div class="layui-form-mid layui-word-aux">PC端的文本说明</div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">Mobile:</label>
        <div class="layui-input-inline">
            <input type="text" name="mobile" value="" class="layui-input">
        </div>
        <div class="layui-form-mid layui-word-aux">移动端的文本说明</div>
    </div>
</script>
<script type="text/html" id="css">
    <textarea class="layui-textarea" name="css" style="width: 100%;height: 100%"></textarea>
</script>
