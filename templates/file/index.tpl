<link rel="stylesheet" type="text/css" href="/static/file/icons/icons.css">
<link rel="stylesheet" type="text/css" href="/static/file/file.css">
<div class="layui-card">
	<div class="layui-card-body">
		<div class="layui-form">
			<div class="table-search" style="left:245px">
				<div class="layui-btn-group">
					<button class="layui-btn layui-btn-sm layui-btn-primary" data-event="terminal" lay-tips="打开终端">
						<i class="layui-icon iconfont icon-terminal"></i>
					</button>
					<button class="layui-btn layui-btn-sm" data-event="import" lay-tips="上传文件">
						<i class="layui-icon layui-icon-upload"></i>
					</button>
				</div>
				<div class="layui-inline">
					<div class="layui-inline">
						<div class="layui-input-inline">
							<input type="search" name="search" placeholder="搜索文件/目录" class="layui-input">
						</div>
					</div>
					<div class="layui-inline">
						<div class="layui-input-inline">
							<input type="checkbox" name="recursion" title="包含子目录">
						</div>
					</div>
					<button class="layui-btn layui-btn-sm layui-btn-primary" lay-submit lay-filter="search">
						<i class="layui-icon layui-icon-search"></i>
					</button>
				</div>
			</div>
			<div class="table-search file-toolbar" style="left:32px;top:56px">
				<button class="layui-btn layui-btn-sm layui-btn-primary" data-event="history"
						lay-tips="返回到前一次浏览">
					<i class="layui-icon layui-icon-return"></i>
				</button>
				<div class="layui-input-inline">
					<div id="current-path"></div>
					<input type="hidden" list="gotoHistories" name="path" value="" class="layui-input"
						   lay-verify="required">
					<datalist id="gotoHistories"></datalist>
					<button class="layui-hide" lay-submit lay-filter="submit"></button>
				</div>
				<button class="layui-btn layui-btn-sm" data-event="refresh" lay-tips="刷新当前目录">
					<i class="layui-icon layui-icon-refresh"></i>
				</button>
			</div>
		</div>
		<table class="layui-font" id="table-list" lay-filter="table-list"></table>
	</div>
</div>
<div class="layui-card">
	<div class="layui-card-body layui-form">
		<div class="layui-inline">
			<label for="action" class="layui-form-label">操作:</label>
			<div class="layui-input-block">
				<select name="action" id="action" lay-verify="" lay-filter="action" lay-search>
					<option value="compress" selected>打包</option>
					<option value="del">删除</option>
					<option value="move">移动/重命名</option>
					<option value="copy">复制</option>
					<option value="chmod">修改权限</option>
					<option value="chgroup">用户组:用户者</option>
				</select>
			</div>
		</div>
		<div class="layui-inline">
			<label for="value" class="layui-form-label"
				   lay-tips="打包名/权限值/用户名/组名/目标文件或目录名">值:</label>
			<div class="layui-input-block">
				<input name="value" id="value" type="search" class="layui-input layui-input-small"/>
			</div>
		</div>
		<div class="layui-inline">
			<div class="layui-input-inline">
				<input name="inherit" id="inherit" type="checkbox" title="继承" lay-skin="primary" checked/>
				<button class="layui-btn" lay-submit lay-filter="submit-acts">确定</button>
			</div>
		</div>
	</div>
</div>
<script type="text/html" id="toolbar">
	<div class="layui-btn-group">
		<button class="layui-btn layui-btn-sm" lay-event="gotoRoot" lay-tips="用户目录">
			<i class="layui-icon layui-icon-home"></i>
		</button>
		<button class="layui-btn layui-btn-sm" lay-event="gotoWww" lay-tips="所有网站目录">
			<i class="layui-icon layui-icon-app"></i>
		</button>
		<button class="layui-btn layui-btn-sm" lay-event="newFolder" lay-tips="在当前目录新建文件夹">
			<i class="layui-icon layui-icon-add-1"></i><i class="layui-icon layui-icon-template"></i>
		</button>
		<button class="layui-btn layui-btn-sm" lay-event="newFile" lay-tips="在当前目录新建文件">
			<i class="layui-icon layui-icon-add-1"></i><i class="layui-icon layui-icon-file"></i>
		</button>
	</div>
	<div class="layui-input-block"></div>
</script>
<script type="text/html" id="aceEditor">
	<div id="ace-container">
		<div class="ace-header" style="top:0">
			<span data-event="saveFile"><i class="iconfont icon-save-file"></i>保存</span>
			<span data-event="saveFileAll"><i class="iconfont icon-save-all-file"></i>全部保存</span>
			<span data-event="refreshFile"><i class="iconfont icon-refresh"></i>刷新</span>
			<span data-event="search"><i class="iconfont icon-search"></i>搜索</span>
			<span data-event="replaces"><i class="iconfont icon-replace"></i>替换</span>
			<span data-event="jumpLine"><i class="iconfont icon-pushpin"></i>跳转行</span>
			<span data-event="fontSize"><i class="iconfont icon-typeface"></i>字体</span>
			<span data-event="themes"><i class="iconfont icon-theme"></i>主题</span>
			<span data-event="setup"><i class="iconfont icon-setting"></i>设置<div class="red-point"
																				   style="display:none;"></div></span>
			<span data-event="helps"><i class="iconfont icon-fast"></i>快捷键</span>
			<span data-event="template"><i class="layui-icon layui-icon-template"></i>模板语法</span>
			<div data-event="pullDown" class="pull-down" title="隐藏工具条" style="top:0">
				<i class="layui-icon layui-icon-down"></i>
			</div>
		</div>
		<div class="ace-overall" style="top:35px;">
			<!-- 编辑器目录 -->
			<div class="ace-catalogue" style="left:0">
				<div class="ace-catalogue-title"></div>
				<div class="ace-dir-tools">
					<div data-event="upperLevel" title="返回上级目录">
						<i class="iconfont icon-share"></i>
						<span>上一级</span>
					</div>
					<div data-event="refresh" title="刷新当前目录">
						<span class="iconfont icon-refresh"></span>
						<span>刷新</span>
					</div>
					<div data-event="foldNew" title="新建文件/目录">
						<i class="layui-icon layui-icon-add-1"></i>
						<span>新建</span>
						<ul class="folder-down-up">
							<li data-event="newFolder"><i class="folder-icon"></i>新建文件夹</li>
							<li data-event="newFile"><i class="text-icon"></i>新建文件</li>
						</ul>
					</div>
					<div data-event="searchFile" title="搜索内容">
						<i class="iconfont icon-search"></i>
						<span>搜索</span>
					</div>
					<span class="ace-editor-main-storey"></span>
				</div>
				<div class="ace-dir-tools search-file-box">
					<div class="search-input-title">搜索目录文件</div>
					<div class="search-close" data-event="searchClose" title="关闭">
						<i class="layui-icon layui-icon-close"></i><span>关闭</span>
					</div>
					<div class="search-input-view">
						<form>
							<input type="text" id="search-val" class="ser-text pull-left" placeholder="文件|文件夹名称">
							<button type="button" class="ser-sub pull-left" data-event="searchSubmit"></button>
							<div class="search-box">
								<input id="search-recursive" type="checkbox">
								<label for="search-recursive"><span>包含子目录文件</span></label>
							</div>
						</form>
					</div>
				</div>
				<div class="ace-catalogue-list">
					<ul class="cd-accordion-menu"></ul>
					<ul class="ace-catalogue-menu">
						<li data-event="refreshDir">
							<i class="iconfont icon-refresh"></i><span>刷新目录</span>
						</li>
						<li data-event="cd">
							<i class="iconfont icon-goto-right"></i><span>转到目录</span>
						</li>
						<li data-event="newFolder">
							<i class="folder-icon"></i><span>新建文件夹</span>
						</li>
						<li data-event="newFile">
							<i class="text-icon"></i><span>新建文件</span>
						</li>
						<li data-event="rename">
							<i class="rename-icon img-icon"></i><span>重命名</span>
						</li>
						<li data-event="download">
							<i class="down-icon img-icon"></i><span>下载</span>
						</li>
						<li data-event="del">
							<i class="del-icon img-icon"></i><span>删除</span>
						</li>
					</ul>
				</div>
				<div class="ace-catalogue-drag-icon">
					<div class="drag-icon-container"></div>
					<span data-event="foldX" class="fold-icon-container" title="隐藏文件目录">
                        <i class="iconfont icon-arrow-left"></i>
                    </span>
				</div>
			</div>
			<!-- 编辑内容 -->
			<div class="ace-editor-main" style="margin-left:265px">
				<ul class="ace-container-menu"></ul>
				<div class="ace-container-tips">
					<div class="tips"></div>
				</div>
				<div class="ace-editor-main-storey"></div>
				<div class="ace-container-editor"></div>
				<div class="term-parent">
					<div class="term-content" id="termContent"></div>
				</div>
				<div class="ace-container-toolbar">
					<div class="pull-left size-ellipsis">
						<span data-event="path" class="size-ellipsis"></span>
					</div>
					<div class="pull-right">
						<span data-event="cursor"></span>
						<span data-event="tab"></span>
						<span data-event="encoding"></span>
						<span data-event="lang"></span>
					</div>
				</div>
			</div>
			<!-- 工具栏 -->
			<div class="ace-toolbar-menu" style="display: none;">
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
				<div class="menu-item menu-encoding" style="display:none;">
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
						<div class="set-font-size">
							<input type="number" min="12" max="45"/>
							<span class="tips error">字体设置范围 12-45</span>
							<button class="btn-save">保存</button>
						</div>
					</div>
				</div>
				<div class="menu-item menu-jumpLine" style="display: none;">
					<div class="menu-title">跳转到指定行</div>
					<div class="menu-container">
						<div class="set-jump-line">
							<input type="number" min="0"/>
							<div class="jump-tips">当前：行&nbsp;<span></span>&nbsp;，列&nbsp;<span></span>&nbsp;，输入行数(介于&nbsp;1&nbsp;-&nbsp;<span></span>&nbsp;之间)
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
				<div class="menu-item menu-setup" style="display: none;">
					<div class="menu-title">编辑器设置【部分设置需要重新打开编辑生效】</div>
					<ul class="editor-menu">
						<li data-event="wrap">自动换行</li>
						<li data-event="enableLiveAutocompletion">代码自动完成</li>
						<li data-event="enableSnippets">启用代码段</li>
						<li data-event="showInvisible">显示隐藏字符</li>
						<li data-event="showLineNumbers">显示行号</li>
					</ul>
				</div>
			</div>
		</div>
	</div>
</script>
<script type="text/html" id="aceShortcutKeys">
	<div class="keysUp_left">
		<div class="keysUp-row">
			<div class="keysUp-title">常用快捷键</div>
			<div class="keysUp-content">
				<div class="keysUp-item">
					<span class="keysUp-btn">Ctrl</span>
					<span class="keysUp-symbol">+</span>
					<span class="keysUp-btn">S</span>
					<span class="keysUp-tips">保存文件</span>
				</div>
				<div class="keysUp-item">
					<span class="keysUp-btn">Ctrl</span>
					<span class="keysUp-symbol">+</span>
					<span class="keysUp-btn">C</span>
					<span class="keysUp-tips">复制内容</span>
				</div>
				<div class="keysUp-item">
					<span class="keysUp-btn">Ctrl</span>
					<span class="keysUp-symbol">+</span>
					<span class="keysUp-btn">X</span>
					<span class="keysUp-tips">剪切内容</span>
				</div>
				<div class="keysUp-item">
					<span class="keysUp-btn">Ctrl</span>
					<span class="keysUp-symbol">+</span>
					<span class="keysUp-btn">V</span>
					<span class="keysUp-tips">粘贴内容</span>
				</div>
				<div class="keysUp-item">
					<span class="keysUp-btn">Ctrl</span>
					<span class="keysUp-symbol">+</span>
					<span class="keysUp-btn">A</span>
					<span class="keysUp-tips">全选内容</span>
				</div>
				<div class="keysUp-item">
					<span class="keysUp-btn">Ctrl</span>
					<span class="keysUp-symbol">+</span>
					<span class="keysUp-btn">Z</span>
					<span class="keysUp-tips">撤销操作</span>
				</div>
				<div class="keysUp-item">
					<span class="keysUp-btn">Ctrl</span>
					<span class="keysUp-symbol">+</span>
					<span class="keysUp-btn">Y</span>
					<span class="keysUp-tips">反撤销操作</span>
				</div>
				<div class="keysUp-item">
					<span class="keysUp-btn">Ctrl</span>
					<span class="keysUp-symbol">+</span>
					<span class="keysUp-btn">F</span>
					<span class="keysUp-tips">搜索内容</span>
				</div>
				<div class="keysUp-item">
					<span class="keysUp-btn">Ctrl</span>
					<span class="keysUp-symbol">+</span>
					<span class="keysUp-btn">H</span>
					<span class="keysUp-tips">替换内容</span>
				</div>
				<div class="keysUp-item">
					<span class="keysUp-btn"><img alt=""
												  src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAACkElEQVQ4T62UTWhTQRDHZ6bhFZpK9CAetEoPocF6MG83jRaqFvHjIgrFQ9WLQkHsyZMWvAkFL978QET0YPVUxUuLFFK/Ynk7W0tAqeIHFFEoQqGGWKt9I6+Y2Mh7iQcX9jT//c3Of2cW4T8vXMmbnp5eNT8/34uIKtgAoESEEXGsubl5MJVKfa2Xvwo4OTm52/f9sahDWusqfZiuSuB53gARDYYJRWQ4k8n0WGsPAMAPpdTo37qJiYnNVUBmvg8AB0MzIx5TSt1m5msA0IeIIyIyS0SffN/fFNiDiLMVYD6fX+84znsAcMKAi4uLTZ2dnd+YeRYA1kZUca4CZOZDAHAvwr/XWuuU53ktRDQT5TEi/jHZGHMVEVsRsSAiz3zfd2KxWKvv+6cR8ZZS6gwznwKASxHAj1rrlsoNc7lcrLu7+2eI0RsaGxs3ptPpvDFmHBF3RgCva637KsBCobBmYWFhLxHtAYCEiIw2NDQ8d133VRlgrR0XkVAgIvYopYaXgcx8EgCuRGQe0lofLceMMSeIKCsiwct+EZG3sVjsoeM4hfb29uIy0BhzAxGPhwGJ6Kzruhestf2lUmmoq6trrta0IDM3IeKUiCTDhEtLS23ZbPYNMwsAzIjIIxGxIvKOiILeawuK1FpfDM6jMWYXIuYispa01nFr7X4RGanRLjuUUk+Wgcw8AACh4wYAd7TWR5g5aJWgZcLWy0QioZLJ5Pcy8DEitohIUPYHRNwOANuCoIj0ZjKZu7WmAwBuaq0r/qPneVs7OjqmVqY2xmwBgN5isXg+Ho+vJqLPNR6iX2t9uRyv+x3VmQ4goozruvzPwEBord0nIod/W7EOER8AwFMiepFOp6uqq3vDWj0XFvsFsp0JRWHn0UYAAAAASUVORK5CYII="/></span>
					<span class="keysUp-symbol">+</span>
					<span class="keysUp-btn">Alt</span>
					<span class="keysUp-symbol">+</span>
					<span class="keysUp-btn">0</span>
					<span class="keysUp-tips">折叠代码</span>
				</div>
				<div class="keysUp-item">
					<span class="keysUp-btn"><img alt=""
												  src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAACkElEQVQ4T62UTWhTQRDHZ6bhFZpK9CAetEoPocF6MG83jRaqFvHjIgrFQ9WLQkHsyZMWvAkFL978QET0YPVUxUuLFFK/Ynk7W0tAqeIHFFEoQqGGWKt9I6+Y2Mh7iQcX9jT//c3Of2cW4T8vXMmbnp5eNT8/34uIKtgAoESEEXGsubl5MJVKfa2Xvwo4OTm52/f9sahDWusqfZiuSuB53gARDYYJRWQ4k8n0WGsPAMAPpdTo37qJiYnNVUBmvg8AB0MzIx5TSt1m5msA0IeIIyIyS0SffN/fFNiDiLMVYD6fX+84znsAcMKAi4uLTZ2dnd+YeRYA1kZUca4CZOZDAHAvwr/XWuuU53ktRDQT5TEi/jHZGHMVEVsRsSAiz3zfd2KxWKvv+6cR8ZZS6gwznwKASxHAj1rrlsoNc7lcrLu7+2eI0RsaGxs3ptPpvDFmHBF3RgCva637KsBCobBmYWFhLxHtAYCEiIw2NDQ8d133VRlgrR0XkVAgIvYopYaXgcx8EgCuRGQe0lofLceMMSeIKCsiwct+EZG3sVjsoeM4hfb29uIy0BhzAxGPhwGJ6Kzruhestf2lUmmoq6trrta0IDM3IeKUiCTDhEtLS23ZbPYNMwsAzIjIIxGxIvKOiILeawuK1FpfDM6jMWYXIuYispa01nFr7X4RGanRLjuUUk+Wgcw8AACh4wYAd7TWR5g5aJWgZcLWy0QioZLJ5Pcy8DEitohIUPYHRNwOANuCoIj0ZjKZu7WmAwBuaq0r/qPneVs7OjqmVqY2xmwBgN5isXg+Ho+vJqLPNR6iX2t9uRyv+x3VmQ4goozruvzPwEBord0nIod/W7EOER8AwFMiepFOp6uqq3vDWj0XFvsFsp0JRWHn0UYAAAAASUVORK5CYII="/></span>
					<span class="keysUp-symbol">+</span>
					<span class="keysUp-btn">Alt</span>
					<span class="keysUp-symbol">+</span>
					<span class="keysUp-btn">Shift</span>
					<span class="keysUp-symbol">+</span>
					<span class="keysUp-btn">0</span>
					<span class="keysUp-tips">展开代码</span>
				</div>
				<div class="keysUp-item">
					<span class="keysUp-btn">Esc</span>
					<span class="keysUp-tips">退出搜索、取消自动提示</span>
				</div>
			</div>
		</div>
		<div class="keysUp-row">
			<div class="keysUp-title">光标移动</div>
			<div class="keysUp-content">
				<div class="keysUp-item">
					<span class="keysUp-btn">Home</span>
					<span class="keysUp-symbols">/</span>
					<span class="keysUp-btn">End</span>
					<span class="keysUp-symbols">/</span>
					<span class="keysUp-btn">Up</span>
					<span class="keysUp-symbols">/</span>
					<span class="keysUp-btn">Left</span>
					<span class="keysUp-symbols">/</span>
					<span class="keysUp-btn">Down</span>
					<span class="keysUp-symbols">/</span>
					<span class="keysUp-btn">Right</span>
				</div>
				<div class="keysUp-item">
					<span class="keysUp-btn">Ctrl</span>
					<span class="keysUp-symbol">+</span>
					<span class="keysUp-btn">Home</span>
					<span class="keysUp-symbols">/</span>
					<span class="keysUp-btn">End</span>
					<span class="keysUp-tips">光标移动到文档首/尾</span>
				</div>
				<div class="keysUp-item">
					<span class="keysUp-btn">Ctrl</span>
					<span class="keysUp-symbol">+</span>
					<span class="keysUp-btn">P</span>
					<span class="keysUp-tips">跳转到匹配的标签</span>
				</div>
				<div class="keysUp-item">
					<span class="keysUp-btn">pageUp</span>
					<span class="keysUp-symbols">/</span>
					<span class="keysUp-btn">pageDown</span>
					<span class="keysUp-tips">光标上/下翻页</span>
				</div>
				<div class="keysUp-item">
					<span class="keysUp-btn">Alt</span>
					<span class="keysUp-symbol">+</span>
					<span class="keysUp-btn">Left</span>
					<span class="keysUp-symbols">/</span>
					<span class="keysUp-btn">Right</span>
					<span class="keysUp-tips">光标移动到行首/尾</span>
				</div>
				<div class="keysUp-item">
					<span class="keysUp-btn">Ctrl</span>
					<span class="keysUp-symbol">+</span>
					<span class="keysUp-btn">I</span>
					<span class="keysUp-tips">跳转到指定行</span>
				</div>
				<div class="keysUp-item">
					<span class="keysUp-btn">Ctrl</span>
					<span class="keysUp-symbol">+</span>
					<span class="keysUp-btn">Alt</span>
					<span class="keysUp-symbol">+</span>
					<span class="keysUp-btn">Up</span>
					<span class="keysUp-symbols">/</span>
					<span class="keysUp-btn">Down</span>
					<span class="keysUp-tips">上/下增加光标</span>
				</div>
			</div>
		</div>
	</div>
	<div class="keysUp_right">
		<div class="keysUp-row">
			<div class="keysUp-title">内容选择</div>
			<div class="keysUp-content">
				<div class="keysUp-item">
					<span class="keysUp-btn">鼠标框选——拖动</span>
				</div>
				<div class="keysUp-item">
					<span class="keysUp-btn">Shift</span>
					<span class="keysUp-symbol">+</span>
					<span class="keysUp-btn">Home</span>
					<span class="keysUp-symbols">/</span>
					<span class="keysUp-btn">End</span>
					<span class="keysUp-symbols">/</span>
					<span class="keysUp-btn">Up</span>
					<span class="keysUp-symbols">/</span>
					<span class="keysUp-btn">Left</span>
					<span class="keysUp-symbols">/</span>
					<span class="keysUp-btn">Down</span>
					<span class="keysUp-symbols">/</span>
					<span class="keysUp-btn">Right</span>
				</div>
				<div class="keysUp-item">
					<span class="keysUp-btn">Shift</span>
					<span class="keysUp-symbol">+</span>
					<span class="keysUp-btn">pageUp</span>
					<span class="keysUp-symbols">/</span>
					<span class="keysUp-btn">PageDown</span>
					<span class="keysUp-tips">上下翻页选中</span>
				</div>
				<div class="keysUp-item">
					<span class="keysUp-btn">Ctrl</span>
					<span class="keysUp-symbol">+</span>
					<span class="keysUp-btn">Shift</span>
					<span class="keysUp-symbol">+</span>
					<span class="keysUp-btn">Home</span>
					<span class="keysUp-symbols">/</span>
					<span class="keysUp-tips">当前光标至头/尾</span>
				</div>
				<div class="keysUp-item">
					<span class="keysUp-btn">Alt</span>
					<span class="keysUp-symbol">+</span>
					<span class="keysUp-btn">鼠标拖动</span>
					<span class="keysUp-tips">块选择</span>
				</div>
			</div>
		</div>
		<div class="keysUp-row">
			<div class="keysUp-title">编辑</div>
			<div class="keysUp-content">
				<div class="keysUp-item">
					<span class="keysUp-btn">Ctrl</span>
					<span class="keysUp-symbol">+</span>
					<span class="keysUp-btn">/</span>
					<span class="keysUp-tips">注释&取消注释</span>
				</div>
				<div class="keysUp-item">
					<span class="keysUp-btn">Tab</span>
					<span class="keysUp-tips">对齐</span>
				</div>
				<div class="keysUp-item">
					<span class="keysUp-btn">Shift</span>
					<span class="keysUp-symbol">+</span>
					<span class="keysUp-btn">Tab</span>
					<span class="keysUp-tips">整体前移</span>
				</div>
				<div class="keysUp-item">
					<span class="keysUp-btn">Delete</span>
					<span class="keysUp-tips">删除</span>
				</div>
				<div class="keysUp-item">
					<span class="keysUp-btn">Ctrl</span>
					<span class="keysUp-symbol">+</span>
					<span class="keysUp-btn">D</span>
					<span class="keysUp-tips">删除整行</span>
				</div>
				<div class="keysUp-item">
					<span class="keysUp-btn">Alt</span>
					<span class="keysUp-symbol">+</span>
					<span class="keysUp-btn">Shift</span>
					<span class="keysUp-symbol">+</span>
					<span class="keysUp-btn">Up</span>
					<span class="keysUp-symbols">/</span>
					<span class="keysUp-btn">Down</span>
					<span class="keysUp-tips">复制行并添加到上一行/下一行</span>
				</div>
				<div class="keysUp-item">
					<span class="keysUp-btn">Alt</span>
					<span class="keysUp-symbol">+</span>
					<span class="keysUp-btn">Delete</span>
					<span class="keysUp-tips">删除光标右侧内容</span>
				</div>
				<div class="keysUp-item">
					<span class="keysUp-btn">Alt</span>
					<span class="keysUp-symbol">+</span>
					<span class="keysUp-btn">Up</span>
					<span class="keysUp-symbols">/</span>
					<span class="keysUp-btn">Down</span>
					<span class="keysUp-tips">当前行和上一行/下一行交换</span>
				</div>
				<div class="keysUp-item">
					<span class="keysUp-btn">Ctrl</span>
					<span class="keysUp-symbol">+</span>
					<span class="keysUp-btn">Shift</span>
					<span class="keysUp-symbol">+</span>
					<span class="keysUp-btn">D</span>
					<span class="keysUp-tips">复制行并添加到下面</span>
				</div>
			</div>
		</div>
	</div>
</script>
<script src="/static/layui/layui.js"></script>
<script src="/static/file/jquery.dragsort-0.5.2.min.js"></script>
<script src="/static/file/ace/ace.js"></script>
<script>
    layui.use(['index', 'file',], function () {
        layui.file({root:{{.root}}});
    });
</script>