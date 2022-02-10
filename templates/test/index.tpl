<link href="/static/editor/ace.css" rel="stylesheet"/>
<style>
    .ace_catalogue_drag_icon > .fold_icon_container {
        color: white;
        display: inline-block;
        height: 50px;
        line-height: 50px;
        width: 16px;
        font-style: normal;
        font-weight: 400;
        position: absolute;
        z-index: 999;
        top: 50%;
        transform: translateY(-50%);
        left: -1px;
        background: #222;
        border-top-right-radius: 17px;
        border-bottom-right-radius: 17px;
        border: 1px solid #525252;
        border-left: none;
        cursor: pointer;
        margin-left: 0;
        padding-left: 0
    }
</style>
<div id="ace_container">
    <div class="ace_header" style="top:0">
        <span data-event="saveFile"><i class="iconfont icon-save-file"></i>保存</span>
        <span data-event="saveFileAll"><i class="iconfont icon-save-all-file"></i>全部保存</span>
        <span data-event="refresh"><i class="iconfont icon-refresh"></i>刷新</span>
        <span data-event="search"><i class="iconfont icon-search"></i>搜索</span>
        <span data-event="replaces"><i class="iconfont icon-replace"></i>替换</span>
        <span data-event="jumpLine"><i class="iconfont icon-pushpin"></i>跳转行</span>
        <span data-event="fontSize"><i class="iconfont icon-typeface"></i>字体</span>
        <span data-event="themes"><i class="iconfont icon-theme"></i>主题</span>
        <span data-event="setUp"><i class="iconfont icon-setting"></i>设置<div class="red-point" style="display:none;"></div></span>
        <span data-event="helps"><i class="iconfont icon-fast"></i>快捷键</span>
        <div data-event="pullDown" class="pull-down" title="隐藏工具条" style="top:0">
            <i class="layui-icon layui-icon-down"></i>
        </div>
    </div>
    <div class="ace_overall" style="top:35px;">
        <!-- 编辑器目录 -->
        <div class="ace_catalogue" style="left:0">
            <div class="ace_catalogue_title">目录:
                <div class="dir-menu-right"><span class="iconfont icon-minus"></span></div>
            </div>
            <div class="ace_dir_tools">
                <div data-event="upperLevel" title="返回上级目录">
                    <i class="iconfont icon-share"></i>
                    <span>上一级</span>
                </div>
                <div data-event="refreshDir" title="刷新当前目录">
                    <span class="iconfont icon-refresh"></span>
                    <span>刷新</span>
                </div>
                <div data-event="newFolder" title="新建文件/目录">
                    <i class="iconfont icon-add"></i>
                    <span>新建</span>
                    <ul class="folder_down_up">
                        <li data-type="2"><i class="layui-icon layui-icon-folder"></i>新建文件夹</li>
                        <li data-type="3"><i class="layui-icon layui-icon-file"></i>新建文件</li>
                    </ul>
                </div>
                <div data-event="searchFile" title="搜索内容">
                    <i class="iconfont icon-search"></i>
                </div>
                <span class="ace_editor_main_storey"></span>
            </div>
            <div class="ace_catalogue_list">
                <ul class="cd-accordion-menu"></ul>
                <ul class="ace_catalogue_menu">
                    <li data-type="0">
                        <i class="iconfont icon-refresh"></i><span>刷新目录</span>
                    </li>
                    <li data-type="1">
                        <i class="iconfont icon-folder-open"></i><span>打开子目录</span>
                    </li>
                    <li data-type="2">
                        <i class="folder-icon"></i><span>新建文件夹</span>
                    </li>
                    <li data-type="3">
                        <i class="text-icon"></i><span>新建文件</span>
                    </li>
                    <li data-type="4">
                        <i class="rename-icon img-icon"></i><span>重命名</span>
                    </li>
                    <li data-type="5">
                        <i class="down-icon img-icon"></i><span>下载</span>
                    </li>
                    <li data-type="6">
                        <i class="del-icon img-icon"></i><span>删除</span>
                    </li>
                </ul>
            </div>
            <div class="ace_catalogue_drag_icon">
                <div class="drag_icon_container"></div>
                <span data-event="foldX" class="fold_icon_container" title="隐藏文件目录"></span>
            </div>
        </div>
        <!-- 编辑内容 -->
        <div class="ace_editor_main" style="margin-left:265px">
            <ul class="ace_container_menu"></ul>
            <div class="ace_container_tips">
                <div class="tips"></div>
            </div>
            <div class="ace_editor_main_storey"></div>
            <div class="ace_container_editor"></div>
            // 编辑器终端
            <div class="term-parent">
                <div class="term-content" id="termContent"></div>
            </div>
            <div class="ace_container_toolbar">
                <div class="pull-left size_ellipsis">
                    <span data-type="path" class="size_ellipsis"></span>
                </div>
                <div class="pull-right">
                    <span data-type="cursor"></span>
                    <span data-type="history"></span>
                    <span data-type="tab"></span>
                    <span data-type="encoding"></span>
                    <span data-type="lang"></span>
                </div>
            </div>
        </div>
        <div class="ace_toolbar_menu" style="display: none;">
            <div class="menu-item menu-tabs" style="display: none;">
                <div class="menu-title">设置制表符</div>
                <ul class="tabsType">
                    <li data-value="nbsp">使用空格缩进</li>
                    <li data-value="tabs">使用 "Tab" 缩进</li>
                </ul>
                <div class="menu-title" style="margin-top:15px">设置制表符长度</div>
                <ul class="tabsSize">
                    <li data-value="1">1</li>
                    <li data-value="2">2</li>
                    <li data-value="3">3</li>
                    <li data-value="4">4</li>
                    <li data-value="5">5</li>
                    <li data-value="6">6</li>
                </ul>
            </div>
            <div class="menu-item menu-encoding" style="display: none;">
                <div class="menu-title">设置文件保存编码格式</div>
                <ul></ul>
            </div>
            <div class="menu-item menu-files" style="display: none;">
                <div class="menu-container">
                    <input type="text" class="menu-input" placeholder="输入语言模式">
                    <i class="fa fa-close"></i>
                </div>
                <div class="menu-title">设置文件语言关联</div>
                <ul></ul>
            </div>
            <div class="menu-item menu-fontSize" style="display: none;">
                <div class="menu-title">设置编辑器字体大小</div>
                <div class="menu-container">
                    <div class="set_font_size">
                        <input type="number" min="12" max="45"/>
                        <span class="tips error">字体设置范围 12-45</span>
                        <button class="btn-save">保存</button>
                    </div>
                </div>
            </div>
            <div class="menu-item menu-jumpLine" style="display: none;">
                <div class="menu-title">跳转到指定行</div>
                <div class="menu-container">
                    <div class="set_jump_line">
                        <input type="number" min="0"/>
                        <div class="jump_tips">当前：行&nbsp;<span></span>&nbsp;，列&nbsp;<span></span>&nbsp;，输入行数(介于&nbsp;1&nbsp;-&nbsp;<span></span>&nbsp;之间)
                        </div>
                    </div>
                </div>
            </div>
            <div class="menu-item menu-themes" style="display: none;">
                <div class="menu-title">设置编辑器主题</div>
                <ul></ul>
            </div>
            <div class="menu-item menu-history" style="display: none;">
                <div class="menu-title">文件历史版本</div>
                <ul></ul>
            </div>
            <div class="menu-item menu-setUp" style="display: none;">
                <div class="menu-title">编辑器设置【部分设置需要重新打开编辑生效】</div>
                <ul class="editor_menu">
                    <li data-type="wrap">自动换行</li>
                    <li data-type="enableLiveAutocompletion">代码自动完成</li>
                    <li data-type="enableSnippets">启用代码段</li>
                    <li data-type="showInvisible">显示隐藏字符</li>
                    <li data-type="showLineNumbers">显示行号</li>
                </ul>
            </div>
        </div>
    </div>
</div>
<script src="/static/layui/layui.js"></script>
<script src="/static/editor/jquery.dragsort-0.5.2.min.js"></script>
<script src="/static/editor/file.js"></script>
<script>
    let events = {
        menuToggle: function () {
            if (this.hasClass("active")) {
                this.removeClass("active")
                    .css({top: "", height: "", lineHeight: ""}).children("i")
                    .removeClass("layui-icon-up").addClass("layui-icon-down");
                this.parent().css("top", 0).next(".ace_overall").css("top", "35px");
            } else {
                this.addClass("active")
                    .css({top: "35px", height: "40px", lineHeight: "40px"}).children("i")
                    .removeClass("layui-icon-down").addClass("layui-icon-up");
                this.parent().css("top", "-35px").next(".ace_overall").css("top", 0);
            }
        },
        foldX: function () {
            if (this.hasClass("active")) {
                this.removeClass("active").children("i")
                    .removeClass("icon-arrow-right").addClass("icon-arrow-left");
                this.closest(".ace_catalogue").css("left", 0)
                    .next(".ace_editor_main").css("marginLeft", "265px");
            } else {
                this.addClass("active").children("i")
                    .removeClass("icon-arrow-left").addClass("icon-arrow-right");
                this.closest(".ace_catalogue").css("left", "-265px")
                    .next(".ace_editor_main").css("marginLeft", 0);
            }
        },
        drag: function () {
            let dragElem = $('.drag_icon_container'),
                catalogueElem = $('.ace_catalogue'),
                editorElement = $('.ace_editor_main'),
                catalogueWidth = catalogueElem.outerWidth(),
                pageX = 0;
            dragElem.on({
                mousedown: function (e) {
                    pageX = e.pageX;
                    dragElem.on('mousemove', function (e) {
                        if (e.pageX < pageX) {
                            catalogueElem.css("width", (catalogueWidth - (pageX - e.pageX)) + "px");
                        } else if (e.pageX > pageX) {
                            catalogueElem.css("width", (catalogueWidth + (e.pageX - pageX)) + "px");
                        }
                    });
                    e.preventDefault()
                },
                mouseup: function (e) {
                    pageX = e.pageX;
                    dragElem.off('mousemove');
                }
            });
        }
    };
    events.drag();
    $('[data-event]').on("click", function () {
        let $this = $(this), event = $this.data('event');
        events[event] && events[event].call($this);
    });
</script>