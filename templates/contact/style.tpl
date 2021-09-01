<style>
    *[lay-event], *[data-event] {
        cursor: pointer;
        text-align: center;
        margin-top: 20px;
    }

    legend > a > i {
        color: #0a6e85;
    }

    ul.layui-row > li > i {
        width: 100%;
        color: #0a6e85;
        font-size: 50px;
        display: inline-block;
    }
</style>
<div class="layui-card" id="custom-style">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <label class="layui-form-label">名称:</label>
            <div class="layui-input-inline">
                <input type="text" name="name" value="{{.obj.Name}}" placeholder="名称" class="layui-input">
            </div>
            <div class="layui-form-mid layui-word-aux">样式名称</div>
        </div>
        <div class="layui-row">
            <div class="layui-col-md4">
                <div class="layui-form-item">
                    <label class="layui-form-label">浮动:</label>
                    <div class="layui-input-block">
                        <input type="radio" name="float" value="1" title="靠左"{{if gt .obj.Float 0}} checked{{end}}>
                        <input type="radio" name="float" value="0" title="靠右"{{if eq .obj.Float 0}} checked{{end}}>
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
                <label class="layui-form-label">图标颜色:</label>
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
        <div class="layui-form-item">
            <ul class="layui-row layui-col-space10">
                <li class="layui-col-xs3" lay-event="phone">
                    <i class="layui-icon iconfont icon-phone"{{if not .obj.Phone.Enabled}} style="color:grey"{{end}}></i>
                    <cite>手机设置</cite>
                    <input type="hidden" name="phone.enabled" value="{{.obj.Phone.Enabled}}">
                    <input type="hidden" name="phone.icon" value="{{.obj.Phone.Icon}}">
                    <input type="hidden" name="phone.text" value="{{.obj.Phone.Text}}">
                    <input type="hidden" name="phone.mobile_text" value="{{.obj.Phone.MobileText}}">
                    <input type="hidden" name="phone.href" value="{{.obj.Phone.Href}}">
                    <input type="hidden" name="phone.trace" value="{{.obj.Phone.Trace}}">
                </li>
                <li class="layui-col-xs3" lay-event="wechat">
                    <i class="layui-icon iconfont icon-wechat-full"{{if not .obj.Wechat.Enabled}} style="color:grey"{{end}}></i>
                    <cite>微信设置</cite>
                    <input type="hidden" name="wechat.enabled" value="{{.obj.Wechat.Enabled}}">
                    <input type="hidden" name="wechat.icon" value="{{.obj.Wechat.Icon}}">
                    <input type="hidden" name="wechat.text" value="{{.obj.Wechat.Text}}">
                    <input type="hidden" name="wechat.mobile_text" value="{{.obj.Wechat.MobileText}}">
                    <input type="hidden" name="wechat.href" value="{{.obj.Wechat.Href}}">
                    <input type="hidden" name="wechat.trace" value="{{.obj.Wechat.Trace}}">
                </li>
                <li class="layui-col-xs3" lay-event="consult">
                    <i class="layui-icon iconfont icon-consulting"{{if not .obj.Consult.Enabled}} style="color:grey"{{end}}></i>
                    <cite>在线咨询</cite>
                    <input type="hidden" name="consult.enabled" value="{{.obj.Consult.Enabled}}">
                    <input type="hidden" name="consult.icon" value="{{.obj.Consult.Icon}}">
                    <input type="hidden" name="consult.text" value="{{.obj.Consult.Text}}">
                    <input type="hidden" name="consult.mobile_text" value="{{.obj.Consult.MobileText}}">
                    <input type="hidden" name="consult.href" value="{{.obj.Consult.Href}}">
                    <input type="hidden" name="consult.trace" value="{{.obj.Consult.Trace}}">
                </li>
                <li class="layui-col-xs3" lay-event="feedback">
                    <i class="layui-icon iconfont icon-feedback-1"{{if not .obj.Feedback.Enabled}} style="color:grey"{{end}}></i>
                    <cite>留言反馈</cite>
                    <input type="hidden" name="feedback.enabled" value="{{.obj.Feedback.Enabled}}">
                    <input type="hidden" name="feedback.icon" value="{{.obj.Feedback.Icon}}">
                    <input type="hidden" name="feedback.text" value="{{.obj.Feedback.Text}}">
                    <input type="hidden" name="feedback.mobile_text" value="{{.obj.Feedback.MobileText}}">
                    <input type="hidden" name="feedback.href" value="{{.obj.Feedback.Href}}">
                    <input type="hidden" name="feedback.trace" value="{{.obj.Feedback.Trace}}">
                </li>
                <li class="layui-col-xs3" lay-event="menu">
                    <i class="layui-icon iconfont icon-menu"{{if not .obj.Menu.Enabled}} style="color:grey"{{end}}></i>
                    <cite>菜单设置</cite>
                    <input type="hidden" name="menu.enabled" value="{{.obj.Menu.Enabled}}">
                    <input type="hidden" name="menu.icon" value="{{.obj.Menu.Icon}}">
                    <input type="hidden" name="menu.text" value="{{.obj.Menu.Text}}">
                    <input type="hidden" name="menu.mobile_text" value="{{.obj.Menu.MobileText}}">
                    <input type="hidden" name="menu.href" value="{{.obj.Menu.Href}}">
                    <input type="hidden" name="menu.trace" value="{{.obj.Menu.Trace}}">
                </li>
                <li class="layui-col-xs3" lay-event="pc-css">
                    <i class="layui-icon iconfont icon-pc"{{if not .obj.PcCss}} style="color:grey"{{end}}></i>
                    <cite>CSS</cite>
                    <input type="hidden" name="pc_css" value="{{.obj.PcCss}}">
                </li>
                <li class="layui-col-xs3" lay-event="mobile-css">
                    <i class="layui-icon iconfont icon-mobile"{{if not .obj.MobileCss}} style="color:grey"{{end}}></i>
                    <cite>CSS</cite>
                    <input type="hidden" name="mobile_css" value="{{.obj.MobileCss}}">
                </li>
            </ul>
        </div>
        <div class="layui-hide">
            <input name="id" value="{{.obj.Id}}">
            <button lay-submit>提交</button>
        </div>
        <fieldset class="layui-elem-field">
            <legend><i class="layui-icon iconfont icon-menu"></i>
                <a href="javascript:void(0);" lay-event="add-menu" lay-tips="新增子菜单">
                    <i class="layui-icon layui-icon-add-circle"></i>子菜单
                </a>
            </legend>
            <div id="menu-items"></div>
        </fieldset>
    </div>
</div>
<script type="text/html" id="insert-submenu">
    <div class="layui-form-item">
        <div class="layui-inline"><label class="layui-form-label-col">PC文本:</label></div>
        <div class="layui-inline width120"><input name="pc" value="" class="layui-input"></div>
        <div class="layui-inline"><label class="layui-form-label-col">Wap文本:</label></div>
        <div class="layui-inline width120"><input name="mobile" value="" class="layui-input"></div>
        <div class="layui-inline"><label class="layui-form-label-col">链接:</label></div>
        <div class="layui-inline" style="min-width: 320px"><input name="href" value="" class="layui-input"></div>
        <div class="layui-inline"><label class="layui-form-label-col">跟踪:</label></div>
        <div class="layui-inline width120"><input name="trace" value="" class="layui-input"></div>
        <i class="layui-icon layui-icon-delete" style="color: red" lay-tips="删除该项" data-event="del-menu"></i>
    </div>
</script>
<script>
    layui.use(['main'], function () {
        let main = layui.main,
            form = layui.form,
            colorpicker = layui.colorpicker,
            submenus = {{.obj.Submenu}},
            kv = {
                'enabled': '启用',
                'icon': '图标',
                'href': '链接地址',
                'text': 'PC端文字',
                'mobile_text': '移动端文字',
                'trace': '广告跟踪',
            },
            getId = function () {
                let ids = [], id = 0;
                $('#menu-items').find('*[name]').each(function (i, v) {
                    let names = $(v).attr('name').split('.'),
                        id = parseInt(names.slice(names.length - 1, names.length));
                    if (!isNaN(id)) {
                        ids.push(id);
                    }
                });
                ids.forEach(function (i) {
                    if (i > id) {
                        id = i
                    }
                });
                id++;
                return id;
            },
            insertMenu = function (id, values) {
                let elem = $($('#insert-submenu').html());
                values = $.extend({pc: "", mobile: "", href: "", trace: ""}, values || {});
                elem.find('*[name=pc]').attr('name', 'submenu.text.' + id).val(values.pc);
                elem.find('*[name=mobile]').attr('name', 'submenu.mobile_text.' + id).val(values.mobile);
                elem.find('*[name=href]').attr('name', 'submenu.href.' + id).val(values.href);
                elem.find('*[name=trace]').attr('name', 'submenu.trace.' + id).val(values.trace);
                $('#menu-items').append(elem);
                $('[data-event="del-menu"]').click(function () {
                    $(this).closest('div.layui-form-item').remove();
                });
            };
        if (submenus) {
            submenus.forEach(function (v, i) {
                insertMenu(i, {pc: v.text, mobile: v.mobile_text, href: v.href, trace: v.trace});
            });
        }
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
        $('#custom-style [lay-event]').click(function () {
            let othis = $(this),
                event = othis.attr('lay-event'),
                data = othis.find('[name]').serializeArray(), elem;
            if (event === 'add-menu') {
                insertMenu(getId());
                return false;
            }
            if (event.lastIndexOf('-css') !== -1) {
                main.confirm('', {
                    scroll: false,
                    area: ['80%', '60%'],
                    success: function (dom) {
                        let containerElem = dom.find('.pop-container>div').first();
                        containerElem.addClass('layui-form');
                        $.each(data, function (index, obj) {
                            elem = $(`<textarea class="layui-textarea" name="" style="width: 100%;height: 100%"></textarea>`);
                            elem.attr('name', obj.name).val(obj.value);
                            containerElem.append(elem);
                        });
                        form.render();
                    },
                    done: function (dom) {
                        let d = dom.find('[name]').serializeArray(), enabled = false;
                        $.each(d, function (index, obj) {
                            obj.value = obj.value.trim();
                            if (obj.name.slice(obj.name.length - 3) === 'css' && obj.value.length > 0) {
                                enabled = true
                            }
                            $('*[name="' + obj.name + '"]').val(obj.value);
                        });
                        if (enabled) {
                            othis.find('i:nth-child(1)').css('color', '');
                        } else {
                            othis.find('i:nth-child(1)').css('color', 'grey');
                        }
                    }
                });
                return false;
            }
            main.confirm('', {
                scroll: false,
                area: ['50%', 'auto'],
                success: function (dom) {
                    let containerElem = dom.find('.pop-container>div').first();
                    containerElem.addClass("layui-form");
                    $.each(data, function (index, obj) {
                        let slice = obj.name.split('.'),
                            name = slice.slice(slice.length - 1, slice.length).toString();
                        if (name === 'enabled') {
                            elem = $('<div class="layui-form-item"><label class="layui-form-label">' + kv[name] + ':</label><div class="layui-input-block"><input type="checkbox" name="' + name + '" lay-skin="switch" lay-text="启用|关闭"' + (obj.value === 'true' ? ' checked' : '') + `></div></div>`);
                        } else {
                            elem = $('<div class="layui-form-item"><label class="layui-form-label">' + kv[name] + ':</label><div class="layui-input-block"><input type="text" name="" value="" class="layui-input"></div></div>');
                            elem.find('[name]').attr("name", name).val(obj.value);
                        }
                        containerElem.append(elem);
                    });
                    form.render();
                },
                done: function (dom) {
                    let d = dom.find('[name]').serializeArray(), enabled = false;
                    $.each(d, function (index, obj) {
                        if (obj.name === 'enabled') {
                            enabled = true;
                        } else {
                            $('*[name="' + event + '.' + obj.name + '"]').val(obj.value);
                        }
                    });
                    $('*[name="' + event + '.enabled"]').val(enabled);
                    if (enabled) {
                        othis.find('i:nth-child(1)').css('color', '');
                    } else {
                        othis.find('i:nth-child(1)').css('color', 'grey');
                    }
                }
            });
        });
    });
</script>
