<style>
    [data-event] {
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
            <div class="layui-inline">
                <label class="layui-form-label">名称:</label>
                <div class="layui-input-inline">
                    <input type="text" name="name" value="{{.obj.Name}}" placeholder="名称" class="layui-input">
                </div>
                <div class="layui-form-mid layui-word-aux">样式名称</div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label" lay-tips="正则匹配到的URL则不显示广告">拒绝URL:</label>
                <div class="layui-input-inline">
                    <input type="text" name="deny" value="{{.obj.Deny}}" placeholder="\.(php|asp|js|css)(\?|$)" class="layui-input">
                </div>
                <button class="layui-btn layui-btn-radius layui-btn-sm" data-event="deny" style="margin-top:6px;">填充默认
                </button>
            </div>
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
                <li class="layui-col-xs3" data-event="field">
                    <i class="layui-icon iconfont icon-phone"{{if not .obj.Phone.Enabled}} style="color:grey"{{end}}></i>
                    <cite>手机设置</cite>
                    <input type="hidden" name="phone.enabled" value="{{.obj.Phone.Enabled}}">
                    <input type="hidden" name="phone.icon" value="{{.obj.Phone.Icon}}">
                    <input type="hidden" name="phone.text" value="{{.obj.Phone.Text}}">
                    <input type="hidden" name="phone.mobile_text" value="{{.obj.Phone.MobileText}}">
                    <input type="hidden" name="phone.href" value="{{.obj.Phone.Href}}">
                    <input type="hidden" name="phone.trace" value="{{.obj.Phone.Trace}}">
                </li>
                <li class="layui-col-xs3" data-event="field">
                    <i class="layui-icon iconfont icon-wechat-full"{{if not .obj.Wechat.Enabled}} style="color:grey"{{end}}></i>
                    <cite>微信设置</cite>
                    <input type="hidden" name="wechat.enabled" value="{{.obj.Wechat.Enabled}}">
                    <input type="hidden" name="wechat.icon" value="{{.obj.Wechat.Icon}}">
                    <input type="hidden" name="wechat.text" value="{{.obj.Wechat.Text}}">
                    <input type="hidden" name="wechat.mobile_text" value="{{.obj.Wechat.MobileText}}">
                    <input type="hidden" name="wechat.href" value="{{.obj.Wechat.Href}}">
                    <input type="hidden" name="wechat.trace" value="{{.obj.Wechat.Trace}}">
                </li>
                <li class="layui-col-xs3" data-event="field">
                    <i class="layui-icon iconfont icon-consulting"{{if not .obj.Consult.Enabled}} style="color:grey"{{end}}></i>
                    <cite>在线咨询</cite>
                    <input type="hidden" name="consult.enabled" value="{{.obj.Consult.Enabled}}">
                    <input type="hidden" name="consult.icon" value="{{.obj.Consult.Icon}}">
                    <input type="hidden" name="consult.text" value="{{.obj.Consult.Text}}">
                    <input type="hidden" name="consult.mobile_text" value="{{.obj.Consult.MobileText}}">
                    <input type="hidden" name="consult.href" value="{{.obj.Consult.Href}}">
                    <input type="hidden" name="consult.trace" value="{{.obj.Consult.Trace}}">
                </li>
                <li class="layui-col-xs3" data-event="field">
                    <i class="layui-icon iconfont icon-feedback-1"{{if not .obj.Feedback.Enabled}} style="color:grey"{{end}}></i>
                    <cite>留言反馈</cite>
                    <input type="hidden" name="feedback.enabled" value="{{.obj.Feedback.Enabled}}">
                    <input type="hidden" name="feedback.icon" value="{{.obj.Feedback.Icon}}">
                    <input type="hidden" name="feedback.text" value="{{.obj.Feedback.Text}}">
                    <input type="hidden" name="feedback.mobile_text" value="{{.obj.Feedback.MobileText}}">
                    <input type="hidden" name="feedback.href" value="{{.obj.Feedback.Href}}">
                    <input type="hidden" name="feedback.trace" value="{{.obj.Feedback.Trace}}">
                </li>
                <li class="layui-col-xs3" data-event="field">
                    <i class="layui-icon iconfont icon-menu"{{if not .obj.Menu.Enabled}} style="color:grey"{{end}}></i>
                    <cite>菜单设置</cite>
                    <input type="hidden" name="menu.enabled" value="{{.obj.Menu.Enabled}}">
                    <input type="hidden" name="menu.icon" value="{{.obj.Menu.Icon}}">
                    <input type="hidden" name="menu.text" value="{{.obj.Menu.Text}}">
                    <input type="hidden" name="menu.mobile_text" value="{{.obj.Menu.MobileText}}">
                    <input type="hidden" name="menu.href" value="{{.obj.Menu.Href}}">
                    <input type="hidden" name="menu.trace" value="{{.obj.Menu.Trace}}">
                </li>
                <li class="layui-col-xs3" data-event="css">
                    <i class="layui-icon iconfont icon-pc"{{if not .obj.PcCss}} style="color:grey"{{end}}></i>
                    <cite>CSS</cite>
                    <input type="hidden" name="pc_css" value="{{.obj.PcCss}}">
                </li>
                <li class="layui-col-xs3" data-event="css">
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
            <legend>
                <i class="layui-icon iconfont icon-menu"></i>
                <a href="javascript:void(0);" data-event="addMenu" lay-tips="新增子菜单">
                    <i class="layui-icon layui-icon-add-circle"></i>子菜单
                </a>
            </legend>
            <div id="menu-items"></div>
        </fieldset>
        <div class="layui-form-item">
            <label class="layui-form-label">弹窗位置:</label>
            <div class="layui-input-block">
                <input type="radio" name="pop_position" value="0" title="中央"{{if eq .obj.PopPosition 0}} checked{{end}}>
                <input type="radio" name="pop_position" value="1" title="左下"{{if eq .obj.PopPosition 1}} checked{{end}}>
                <input type="radio" name="pop_position" value="2" title="右下"{{if eq .obj.PopPosition 2}} checked{{end}}>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">电脑弹窗:</label>
            <div class="layui-input-block">
                <textarea name="pc_pop" class="layui-textarea" placeholder="弹窗宣传语HTML代码">{{.obj.PcPop}}</textarea>
            </div>
            <div class="layui-input-block fill-contact" style="margin-top:-5px;"></div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">手机弹窗:</label>
            <div class="layui-input-block">
                <textarea name="mobile_pop" class="layui-textarea" placeholder="弹窗宣传语HTML代码">{{.obj.MobilePop}}</textarea>
            </div>
            <div class="layui-input-block fill-contact" style="margin-top:-5px;"></div>
        </div>
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
        <i class="layui-icon layui-icon-delete" style="color: red" lay-tips="删除该项" data-event="delMenu"></i>
    </div>
</script>
<script>
    layui.use(['main'], function () {
        let main = layui.main,
            form = layui.form,
            colorpicker = layui.colorpicker,
            submenus = {{.obj.Submenu}},
            field = {
                icon: {label: "图标", tip: "iconfont图标 www.iconfont.cn去搜索"},
                href: {label: "链接地址", tip: "http://www.nfivf.com"},
                text: {label: "PC端文字", tip: "在电脑端显示名称"},
                mobile_text: {label: "移动端文字", tip: "在移动端显示名称"},
                trace: {label: "广告跟踪", tip: "跟踪名称 例如:拨打电话"},
                html: {label: "弹窗代码", tip: "弹窗HTML代码"},
            },
            getId = function () {
                let ids = [], id = 0;
                $('#menu-items').find('*[name]').each(function (i, v) {
                    let names = $(v).attr('name').split('.'),
                        id = parseInt(names.slice(names.length - 1, names.length).toString());
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
                elem.find('[name=pc]').attr('name', 'submenu.text.' + id).val(values.pc);
                elem.find('[name=mobile]').attr('name', 'submenu.mobile_text.' + id).val(values.mobile);
                elem.find('[name=href]').attr('name', 'submenu.href.' + id).val(values.href);
                elem.find('[name=trace]').attr('name', 'submenu.trace.' + id).val(values.trace);
                $('#menu-items').append(elem);
                $('[data-event="delMenu"]').off('click').on('click', function () {
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
        let active = {
            deny: function () {
                $("input[name=deny]").val("\\.(php|asp|js|css)(\\?|$)");
            },
            field: function () {
                let data = this.find('[name]').serializeArray(),
                    iconElem = this.find('i:first');
                main.display({
                    area: ["800px", "420px"],
                    btn: "OK",
                    content: "<div class=\"layui-fluid layui-form\"></div>",
                    success: function (dom) {
                        let insertElem = dom.find(".layui-form");
                        $.each(data, function (index, obj) {
                            let slice = obj.name.split('.'),
                                name = slice.slice(slice.length - 1, slice.length).toString();
                            if (name === 'enabled') {
                                insertElem.append('<div class="layui-form-item"><label class="layui-form-label">启用:</label><div class="layui-input-block"><input type="checkbox" name="' + obj.name + '" lay-skin="switch" lay-text="启用|关闭"' + (obj.value === 'true' ? ' checked' : '') + `></div></div>`);
                            } else {
                                let inputElem = $('<div class="layui-form-item"><label class="layui-form-label">' + field[name].label + ':</label><div class="layui-input-block"><input type="text" name="' + obj.name + '" value="" placeholder="' + field[name].tip + '" class="layui-input"></div></div>');
                                inputElem.find("input").val(obj.value);
                                insertElem.append(inputElem);
                            }
                        });
                        form.render();
                    },
                    yes: function (index, dom) {
                        $.each(dom.find("[name$='.enabled']"), function () {
                            let checked = $(this).prop("checked");
                            $('[name="' + this.name + '"]').val(checked);
                            if (checked) {
                                iconElem.css("color", "");
                            } else {
                                iconElem.css("color", "grey");
                            }
                        });
                        $.each(dom.find('[name]').serializeArray(), function (i, v) {
                            if (!v.name.hasSuffix('.enabled')) {
                                $('[name="' + v.name + '"]').val(v.value);
                            }
                        });
                        layer.close(index);
                    }
                });
            },
            css: function () {
                let inputElem = this.find('[name]'),
                    iconElem = this.find('i:first');
                main.textarea("", {
                    btn: "OK",
                    area: ['80%', '60%'],
                    success: function (dom) {
                        dom.find("textarea").val(inputElem.val());
                    },
                    yes: function (index, dom) {
                        let val = dom.find("textarea").val();
                        inputElem.val(val);
                        if (val) {
                            iconElem.css("color", "");
                        } else {
                            iconElem.css("color", "grey");
                        }
                        layer.close(index);
                    }
                });
            },
            addMenu: function () {
                insertMenu(getId());
            },
            delMenu: function () {
                $(this).closest('div.layui-form-item').remove();
            },
        };
        $('[data-event]').off('click').on('click', function () {
            let $this = $(this), event = $this.data("event");
            active && active[event].call($this);
        });
        main.onFillContact();
    });
</script>