<style>
    .edit-field {
        display: none;
        width: 800px;
        height: auto;
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translateX(-50%) translateY(-50%)
    }

    .field li {
        margin-top: 20px;
        text-align: center;
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
        <div class="layui-form-item field">
            <ul class="layui-row layui-col-space10">
                <li class="layui-col-xs3" data-event="field">
                    <i class="layui-icon iconfont icon-phone"{{if not .obj.Phone.Enabled}} style="color:grey"{{end}}></i>
                    <cite>手机设置</cite>
                </li>
                <div class="layui-layer edit-field">
                    <div class="layui-layer-content">
                        <div class="layui-card">
                            <div class="layui-card-body">
                                <div class="layui-form-item">
                                    <label class="layui-form-label">启用:</label>
                                    <div class="layui-input-block">
                                        <input lay-skin="switch" lay-text="启用|关闭" name="phone.enabled" type="checkbox"{{if .obj.Phone.Enabled}} checked{{end}}>
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label">图标:</label>
                                    <div class="layui-input-block">
                                        <input class="layui-input" name="phone.icon" placeholder="iconfont图标 www.iconfont.cn去搜索" type="text" value="{{.obj.Phone.Icon}}">
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label">文字:</label>
                                    <div class="layui-input-block">
                                        <input class="layui-input" name="phone.text" placeholder="提示文字" type="text" value="{{.obj.Phone.Text}}">
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label">链接地址:</label>
                                    <div class="layui-input-block">
                                        <input class="layui-input" name="phone.href" placeholder="http://www.nfivf.com" type="text" value="{{.obj.Phone.Href}}">
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label">广告跟踪:</label>
                                    <div class="layui-input-block">
                                        <input class="layui-input" name="phone.trace" placeholder="跟踪名称 例如:拨打电话" type="text" value="{{.obj.Phone.Trace}}">
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label">弹窗代码:</label>
                                    <div class="layui-input-block">
                                        <textarea class="layui-textarea" name="phone.html" placeholder="输入弹窗的HTML代码">{{.obj.Phone.Html}}</textarea>
                                    </div>
                                    <div class="layui-input-block fill-contact" style="margin-top:-5px;"></div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label">选项:</label>
                                    <div class="layui-input-block">
                                        <textarea class="layui-textarea" name="phone.options" placeholder="{&#34;style&#34;: {&#34;top&#34;: &#34;50px&#34;, &#34;left&#34;: &#34;50px&#34;}}">{{.obj.Phone.Options}}</textarea>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <span class="layui-layer-setwin" data-event="close"><a class="layui-layer-ico layui-layer-close2" href="javascript:void(0);"></a></span>
                </div>
                <li class="layui-col-xs3" data-event="field">
                    <i class="layui-icon iconfont icon-wechat-full"{{if not .obj.Wechat.Enabled}} style="color:grey"{{end}}></i>
                    <cite>微信设置</cite>
                </li>
                <div class="layui-layer edit-field">
                    <div class="layui-layer-content">
                        <div class="layui-card">
                            <div class="layui-card-body">
                                <div class="layui-form-item">
                                    <label class="layui-form-label">启用:</label>
                                    <div class="layui-input-block">
                                        <input lay-skin="switch" lay-text="启用|关闭" name="wechat.enabled" type="checkbox"{{if .obj.Wechat.Enabled}} checked{{end}}>
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label">图标:</label>
                                    <div class="layui-input-block">
                                        <input class="layui-input" name="wechat.icon" placeholder="iconfont图标 www.iconfont.cn去搜索" type="text" value="{{.obj.Wechat.Icon}}">
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label">文字:</label>
                                    <div class="layui-input-block">
                                        <input class="layui-input" name="wechat.text" placeholder="提示文字" type="text" value="{{.obj.Wechat.Text}}">
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label">链接地址:</label>
                                    <div class="layui-input-block">
                                        <input class="layui-input" name="wechat.href" placeholder="http://www.nfivf.com" type="text" value="{{.obj.Wechat.Href}}">
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label">广告跟踪:</label>
                                    <div class="layui-input-block">
                                        <input class="layui-input" name="wechat.trace" placeholder="跟踪名称 例如:拨打电话" type="text" value="{{.obj.Wechat.Trace}}">
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label">弹窗代码:</label>
                                    <div class="layui-input-block">
                                        <textarea class="layui-textarea" name="wechat.html" placeholder="输入弹窗的HTML代码">{{.obj.Wechat.Html}}</textarea>
                                    </div>
                                    <div class="layui-input-block fill-contact" style="margin-top:-5px;"></div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label">选项:</label>
                                    <div class="layui-input-block">
                                        <textarea class="layui-textarea" name="wechat.options" placeholder="{&#34;style&#34;: {&#34;top&#34;: &#34;50px&#34;, &#34;left&#34;: &#34;50px&#34;}}">{{.obj.Wechat.Options}}</textarea>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <span class="layui-layer-setwin" data-event="close"><a class="layui-layer-ico layui-layer-close2" href="javascript:void(0);"></a></span>
                </div>
                <li class="layui-col-xs3" data-event="field">
                    <i class="layui-icon iconfont icon-consulting"{{if not .obj.Consult.Enabled}} style="color:grey"{{end}}></i>
                    <cite>在线咨询</cite>
                </li>
                <div class="layui-layer edit-field">
                    <div class="layui-layer-content">
                        <div class="layui-card">
                            <div class="layui-card-body">
                                <div class="layui-form-item">
                                    <label class="layui-form-label">启用:</label>
                                    <div class="layui-input-block">
                                        <input lay-skin="switch" lay-text="启用|关闭" name="consult.enabled" type="checkbox"{{if .obj.Consult.Enabled}} checked{{end}}>
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label">图标:</label>
                                    <div class="layui-input-block">
                                        <input class="layui-input" name="consult.icon" placeholder="iconfont图标 www.iconfont.cn去搜索" type="text" value="{{.obj.Consult.Icon}}">
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label">文字:</label>
                                    <div class="layui-input-block">
                                        <input class="layui-input" name="consult.text" placeholder="提示文字" type="text" value="{{.obj.Consult.Text}}">
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label">链接地址:</label>
                                    <div class="layui-input-block">
                                        <input class="layui-input" name="consult.href" placeholder="http://www.nfivf.com" type="text" value="{{.obj.Consult.Href}}">
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label">广告跟踪:</label>
                                    <div class="layui-input-block">
                                        <input class="layui-input" name="consult.trace" placeholder="跟踪名称 例如:拨打电话" type="text" value="{{.obj.Consult.Trace}}">
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label">弹窗代码:</label>
                                    <div class="layui-input-block">
                                        <textarea class="layui-textarea" name="consult.html" placeholder="输入弹窗的HTML代码">{{.obj.Consult.Html}}</textarea>
                                    </div>
                                    <div class="layui-input-block fill-contact" style="margin-top:-5px;"></div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label">选项:</label>
                                    <div class="layui-input-block">
                                        <textarea class="layui-textarea" name="consult.options" placeholder="{&#34;style&#34;: {&#34;top&#34;: &#34;50px&#34;, &#34;left&#34;: &#34;50px&#34;}}">{{.obj.Consult.Options}}</textarea>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <span class="layui-layer-setwin" data-event="close"><a class="layui-layer-ico layui-layer-close2" href="javascript:void(0);"></a></span>
                </div>
                <li class="layui-col-xs3" data-event="field">
                    <i class="layui-icon iconfont icon-feedback-1"{{if not .obj.Feedback.Enabled}} style="color:grey"{{end}}></i>
                    <cite>留言反馈</cite>
                </li>
                <div class="layui-layer edit-field">
                    <div class="layui-layer-content">
                        <div class="layui-card">
                            <div class="layui-card-body">
                                <div class="layui-form-item">
                                    <label class="layui-form-label">启用:</label>
                                    <div class="layui-input-block">
                                        <input lay-skin="switch" lay-text="启用|关闭" name="feedback.enabled" type="checkbox"{{if .obj.Feedback.Enabled}} checked{{end}}>
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label">图标:</label>
                                    <div class="layui-input-block">
                                        <input class="layui-input" name="feedback.icon" placeholder="iconfont图标 www.iconfont.cn去搜索" type="text" value="{{.obj.Feedback.Icon}}">
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label">文字:</label>
                                    <div class="layui-input-block">
                                        <input class="layui-input" name="feedback.text" placeholder="提示文字" type="text" value="{{.obj.Feedback.Text}}">
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label">链接地址:</label>
                                    <div class="layui-input-block">
                                        <input class="layui-input" name="feedback.href" placeholder="http://www.nfivf.com" type="text" value="{{.obj.Feedback.Href}}">
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label">广告跟踪:</label>
                                    <div class="layui-input-block">
                                        <input class="layui-input" name="feedback.trace" placeholder="跟踪名称 例如:拨打电话" type="text" value="{{.obj.Feedback.Trace}}">
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label">弹窗代码:</label>
                                    <div class="layui-input-block">
                                        <textarea class="layui-textarea" name="feedback.html" placeholder="输入弹窗的HTML代码">{{.obj.Feedback.Html}}</textarea>
                                    </div>
                                    <div class="layui-input-block fill-contact" style="margin-top:-5px;"></div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label">选项:</label>
                                    <div class="layui-input-block">
                                        <textarea class="layui-textarea" name="feedback.options" placeholder="{&#34;style&#34;: {&#34;top&#34;: &#34;50px&#34;, &#34;left&#34;: &#34;50px&#34;}}">{{.obj.Feedback.Options}}</textarea>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <span class="layui-layer-setwin" data-event="close"><a class="layui-layer-ico layui-layer-close2" href="javascript:void(0);"></a></span>
                </div>
                <li class="layui-col-xs3" data-event="field">
                    <i class="layui-icon iconfont icon-menu"{{if not .obj.Menu.Enabled}} style="color:grey"{{end}}></i>
                    <cite>菜单设置</cite>
                </li>
                <div class="layui-layer edit-field">
                    <div class="layui-layer-content">
                        <div class="layui-card">
                            <div class="layui-card-body">
                                <div class="layui-form-item">
                                    <label class="layui-form-label">启用:</label>
                                    <div class="layui-input-block">
                                        <input lay-skin="switch" lay-text="启用|关闭" name="menu.enabled" type="checkbox"{{if .obj.Menu.Enabled}} checked{{end}}>
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label">图标:</label>
                                    <div class="layui-input-block">
                                        <input class="layui-input" name="menu.icon" placeholder="iconfont图标 www.iconfont.cn去搜索" type="text" value="{{.obj.Menu.Icon}}">
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label">文字:</label>
                                    <div class="layui-input-block">
                                        <input class="layui-input" name="menu.text" placeholder="提示文字" type="text" value="{{.obj.Menu.Text}}">
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label">链接地址:</label>
                                    <div class="layui-input-block">
                                        <input class="layui-input" name="menu.href" placeholder="http://www.nfivf.com" type="text" value="{{.obj.Menu.Href}}">
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label">广告跟踪:</label>
                                    <div class="layui-input-block">
                                        <input class="layui-input" name="menu.trace" placeholder="跟踪名称 例如:拨打电话" type="text" value="{{.obj.Menu.Trace}}">
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label">弹窗代码:</label>
                                    <div class="layui-input-block">
                                        <textarea class="layui-textarea" name="menu.html" placeholder="输入弹窗的HTML代码">{{.obj.Menu.Html}}</textarea>
                                    </div>
                                    <div class="layui-input-block fill-contact" style="margin-top:-5px;"></div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label">选项:</label>
                                    <div class="layui-input-block">
                                        <textarea class="layui-textarea" name="menu.options" placeholder="{&#34;style&#34;: {&#34;top&#34;: &#34;50px&#34;, &#34;left&#34;: &#34;50px&#34;}}">{{.obj.Menu.Options}}</textarea>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <span class="layui-layer-setwin" data-event="close"><a class="layui-layer-ico layui-layer-close2" href="javascript:void(0);"></a></span>
                </div>
                <li class="layui-col-xs3" data-event="field">
                    <i class="layui-icon iconfont icon-css"{{if not .obj.CSS}} style="color:grey"{{end}}></i>
                    <cite>CSS</cite>
                </li>
                <div class="layui-layer edit-field" style="height:auto;">
                    <div class="layui-layer-content">
                        <div class="layui-card">
                            <div class="layui-card-body">
                                <div class="layui-form-item">
                                    <textarea class="layui-textarea" name="css" placeholder="img{height:100px;color:red;}" rows="18">{{.obj.CSS}}</textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                    <span class="layui-layer-setwin" data-event="close"><a class="layui-layer-ico layui-layer-close2" href="javascript:void(0);"></a></span>
                </div>
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
            <div class="layui-inline">
                <label class="layui-form-label">弹窗位置:</label>
                <div class="layui-input-block">
                    <input type="radio" name="position" value="0" title="中央"{{if eq .obj.Position 0}} checked{{end}}>
                    <input type="radio" name="position" value="1" title="左下"{{if eq .obj.Position 1}} checked{{end}}>
                    <input type="radio" name="position" value="2" title="右下"{{if eq .obj.Position 2}} checked{{end}}>
                    <input type="radio" name="position" value="3" title="底部"{{if eq .obj.Position 3}} checked{{end}}>
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">弹窗延时:</label>
                <div class="layui-input-inline">
                    <input type="number" name="popup_delay" value="{{.obj.PopupDelay}}" min="0" class="layui-input">
                </div>
                <div class="layui-form-mid layui-word-aux">单位为秒 0为禁止弹窗</div>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">弹窗HTML:</label>
            <div class="layui-input-block">
                <textarea name="popup" class="layui-textarea" placeholder="弹窗宣传语HTML代码">{{.obj.Popup}}</textarea>
            </div>
            <div class="layui-input-block fill-contact" style="margin-top:-5px;"></div>
        </div>
    </div>
</div>
<script type="text/html" id="insert-submenu">
    <div class="layui-form-item">
        <div class="layui-inline"><label class="layui-form-label-col">文本:</label></div>
        <div class="layui-inline width120"><input type="text" name="text" value="" class="layui-input"></div>
        <div class="layui-inline"><label class="layui-form-label-col">链接:</label></div>
        <div class="layui-inline" style="min-width:320px"><input type="text" name="href" value="" class="layui-input">
        </div>
        <div class="layui-inline"><label class="layui-form-label-col">跟踪:</label></div>
        <div class="layui-inline width120"><input type="text" name="trace" value="" class="layui-input"></div>
        <i class="layui-icon layui-icon-delete" style="color: red" lay-tips="删除该项" data-event="delMenu"></i>
    </div>
</script>
<script>
    layui.use(['main'], function () {
        let main = layui.main,
            colorpicker = layui.colorpicker,
            submenus = {{.obj.Submenu}},
            getId = function () {
                let id = 0;
                $('#menu-items [name]').each(function (i, v) {
                    let names = v.name.split('.'),
                        _id = parseInt(names.slice(names.length - 1, names.length).toString()) || 0;
                    id = _id > id ? _id : id;
                });
                id++;
                return id;
            },
            insertMenu = function (id, values) {
                let elem = $($('#insert-submenu').html());
                values = $.extend({text: "", href: "", trace: ""}, values || {});
                elem.find('[name=text]').attr('name', 'submenu.text.' + id).val(values.text);
                elem.find('[name=href]').attr('name', 'submenu.href.' + id).val(values.href);
                elem.find('[name=trace]').attr('name', 'submenu.trace.' + id).val(values.trace);
                $('#menu-items').append(elem);
                $('[data-event="delMenu"]').off('click').on('click', function () {
                    $(this).closest('div.layui-form-item').remove();
                });
            };
        if (submenus) {
            submenus.forEach(function (v, i) {
                insertMenu(i + 1, {text: v.text, href: v.href, trace: v.trace});
            });
        }
        // 表单赋值
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
            field: function () {
                let index = main.zIndex(this),
                    shadeDom = $('<div class="layui-layer-shade" style="z-index:' + index + '; background-color: rgb(0, 0, 0); opacity: 0.8;"></div>');
                this.before(shadeDom);
                shadeDom.on("click", function () {
                    $(this).nextAll("div.layui-layer").first().find("[data-event=close]").click();
                });
                this.next(".layui-layer").css({"z-index": index + 1, "display": "block"});
            },
            close: function () {
                this.parent().css({"display": "none", "z-index": "auto"});
                this.closest('div.layui-layer').siblings(".layui-layer-shade").remove();
                switch (this.parent().find('[type=checkbox][name]').prop('checked')) {
                    case false:
                        this.closest('div.layui-layer').prev("li").find("i").css("color", "grey");
                        break;
                    case true:
                        this.closest('div.layui-layer').prev("li").find("i").css("color", "");
                        break;
                    default:
                        if (this.parent().find('textarea[name]').val()) {
                            this.closest('div.layui-layer').prev("li").find("i").css("color", "");
                        } else {
                            this.closest('div.layui-layer').prev("li").find("i").css("color", "grey");
                        }
                }
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