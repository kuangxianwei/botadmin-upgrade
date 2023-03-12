layui.define(['main'], function (exports) {
    Array.prototype.included = function (item) {
        for (let i = 0; i < this.length; i++) {
            if (this.indexOf(item) !== -1) return true;
        }
        return false;
    };
    let okIconHTML = '<span class="icon"><i class="iconfont icon-ok" aria-hidden="true"></i></span>',
        main = layui.main, form = layui.form, table = layui.table, upload = layui.upload,
        getUpper = function (path) {
            if (!path || path === '/') return '/';
            let arr = path.split('/');
            arr.splice(-1, 1);
            return arr.join('/') || '/';
        }, basename = function (path) {
            let paths = path.split('/');
            return paths[paths.length - 1];
        };

    class Editor {
        constructor(options) {
            this.path = options.path || '/';
            this.dom = options.dom;
            this.aceConfig = JSON.parse(localStorage.getItem('aceConfig'));  // ace配置参数
            this.editors = null;
            this.editorsLength = 0;
            this.aceActive = '';
            this.paths = [];
        }

        // 获取文件模型
        getFileType(filename) {
            let typeName = filename.split('.').pop().toLowerCase() || 'text';
            for (let name in this.aceConfig['supportedModes']) {
                let suffixes = this.aceConfig['supportedModes'][name][0].split('|');
                for (let i = 0; i < suffixes.length; i++) {
                    if (typeName === suffixes[i]) {
                        return {name: name, mode: name.toLowerCase()};
                    }
                }
            }
            return {name: 'Text', mode: 'text'};
        }

        // 获取当前活动的配置
        getActiveConfig() {
            let elem = this.dom.find('.cd-accordion-menu .has-children .file-fold.bg');
            if (elem.length === 0) return {
                elem: elem,
                boxElem: this.dom.find('.cd-accordion-menu'),
                type: 1, // 1=文件夹 2=文件
                level: 0, // 层次
                dirname: this.path,
                menuPath: this.path,
            };
            let type = elem.data('event') === 'openFile' ? 2 : 1,
                level = parseInt(elem.data('level')) || 1,
                menuPath = elem.data('menuPath');
            return {
                elem: elem,
                boxElem: type === 1 ? elem.next('ul') : elem.closest('ul'),
                type: type,
                level: level,
                dirname: type === 1 ? menuPath : getUpper(menuPath),
                menuPath: menuPath,
            };
        }

        // 渲染目录路径
        renderPath() {
            this.dom.find('.ace-catalogue-title').attr('title', this.path).text('目录: ' + this.path);
        }

        // 渲染文件列表
        renderFiles(options, callback) {
            let othis = this;
            options = $.extend({
                elem: othis.dom.find('.cd-accordion-menu'),
                level: 1,
                isEmpty: false,
                path: othis.path,
                search: '',
                recursive: false,
                name: '',
            }, options || {});
            if (options.level < 1) options.level = 1;
            main.request({
                type: 'GET',
                url: url + '/files',
                data: {
                    path: encodeURIComponent(options.path),
                    search: options.search,
                    recursive: options.recursive,
                    name: options.name,
                    action: options.action,
                },
                done: function (res) {
                    let dirsHTML = '', filesHTML = '', dist = options.level * 15;
                    $.each(res.data.dirs, function (k, v) {
                        dirsHTML += '<li class="has-children" title="' + v.path + '">\
                                        <div class="file-fold" data-level="' + options.level + '" data-menu-path="' + v.path + '" data-size="' + v.size + '" data-event="foldFolder" style="padding-left:' + (dist - 5) + 'px">\
                                            <span class="iconfont icon-arrow-right" style="left:' + (dist - 5) + 'px"></span>\
                                            <span class="file-title"><i class="folder-icon"></i><span>' + (options.search ? v.name.replace(options.search, '<b>' + options.search + '</b>') : v.name) + '</span></span>\
                                        </div>\
                                        <ul></ul>\
                                        <span class="has-children-separator" style="left:' + dist + 'px"></span>\
                                    </li>';
                    });
                    $.each(res.data.files, function (k, v) {
                        filesHTML += '<li class="has-children" title="' + v.path + '">\
                                        <div class="file-fold" data-level="' + options.level + '" data-menu-path="' + v.path + '" data-size="' + v.size + '" data-suffix="' + othis.getFileType(v.name).mode + '" data-event="openFile" style="padding-left:' + (dist - 5) + 'px">\
                                            <span class="file-title">\
                                            <i class="' + othis.getFileType(v.name).mode + '-icon"></i>\
                                            <span>' + (options.search ? v.name.replace(options.search, '<b>' + options.search + '</b>') : v.name) + '</span>\
                                            </span>\
                                        </div>\
                                    </li>';
                    });
                    if (options.level === 1) {
                        othis.path = res.data.path;
                        othis.renderPath();
                    }
                    if (options.isEmpty) options.elem.empty();
                    $(options.elem).append(dirsHTML + filesHTML);
                    typeof callback === 'function' && callback(res.data);
                    return false;
                },
            });
        }

        // 关闭全部
        closeAll() {
            this.dom.find('.folder-down-up').hide();
            this.dom.find('.ace-catalogue-menu').hide();
            this.dom.find('.ace-toolbar-menu').hide();
            this.dom.find('.file-fold .icon-del').click();
        }

        // 获取文件编码列表
        getEncodingList(type) {
            type = type.toUpperCase();
            let HTML = '', existed = false;
            for (let i = 0; i < this.aceConfig['encodingList'].length; i++) {
                let encoding = this.aceConfig['encodingList'][i];
                if (encoding === type) {
                    existed = true;
                    HTML += '<li data-value="' + encoding + '" class="active">' + encoding + okIconHTML;
                } else {
                    HTML += '<li data-value="' + encoding + '">' + encoding + '</li>';
                }
            }
            if (!existed) {
                this.aceConfig['encodingList'].push(type);
                HTML = ('<li data-value="' + type + '" class="active">' + type + okIconHTML) + HTML;
            }
            this.dom.find('.menu-encoding ul').html(HTML);
        }

        // 新建文件和文件夹
        newFileFolderDOM(action) {
            this.closeAll();
            let active = this.getActiveConfig(),
                boxElem = active.boxElem,
                level = active.type === 1 ? active.level + 1 : active.level,
                HTML = '', dist = level * 15;
            if (level > 1) {
                boxElem.prev().children('.iconfont').removeClass('icon-arrow-right').addClass('icon-arrow-down');
                boxElem.show();
            }
            HTML += '<li class="has-children"><div class="file-fold" data-level="' + level + '" data-edit="' + action + '" style="padding-left:' + (dist - 5) + 'px"><span class="file-input">';
            HTML += '<i class="' + (action === 1 ? 'folder' : 'text') + '-icon" style="left:' + (dist - 5) + 'px"></i>';
            HTML += '<input type="text" class="newly-file-input" name="name" value="">';
            HTML += '<span class="iconfont icon-ok" aria-hidden="true" data-event="ok"></span><span class="iconfont icon-del" aria-hidden="true" data-event="cancel"></span></span></div></li>';
            boxElem.prepend(HTML);
            setTimeout(function () {
                boxElem.find('.newly-file-input').focus();
            }, 200);
            boxElem.find('.file-fold .newly-file-input').width(boxElem.width() - dist - 80);
            return false;
        }

        // 获取文件内容
        getFileContent(data, done, error) {
            let othis = this;
            data.path = encodeURIComponent(data.path);
            main.request({
                type: 'GET',
                url: url + '/content',
                data: data,
                done: function (res) {
                    if (typeof done === 'function') {
                        return done(res.data);
                    }
                    return false;
                },
                error: function (res) {
                    if (othis.editorsLength === 0) layer.closeAll();
                    if (typeof error === 'function') {
                        return error(res.msg);
                    }
                },
                fail: function () {
                    layer.closeAll()
                },
            });
        }

        // 保存文件内容-请求
        saveFileContent(data, done, error) {
            main.request({
                url: url + '/content',
                timeout: 7000, //设置保存超时时间
                data: data,
                done: function (res) {
                    if (typeof done === 'function') {
                        return done(res);
                    }
                },
                error: function (res) {
                    if (typeof error === 'function') {
                        return error(res);
                    }
                },
            });
        }

        // 转为删除状态
        transformRemove(id) {
            this.dom.find('.item-tab-' + id + ' .icon-tool').removeClass('waiting icon-warning').addClass('icon-remove').removeAttr('title');
        }

        // 转为警告状态
        transformWarning(id) {
            this.dom.find('.item-tab-' + id + ' .icon-tool').removeClass('icon-remove').addClass('icon-warning');
        }

        // 	保存ace配置
        saveAceConfig(obj, callback) {
            let strObj = JSON.stringify(obj);
            this.saveFileContent({path: 'static/file/ace/ace.config.json', content: strObj}, function () {
                localStorage.setItem('aceConfig', strObj);
                callback && callback();
                layer.msg('设置成功', {icon: 1});
                return false;
            });
        }

        // 保存文件方法
        saveFileMethod(options) {
            if (!options.fileState || options.fileState === 0) {
                return layer.msg('当前文件未修改，无需保存!');
            }
            this.dom.find('.item-tab-' + options.id + ' .icon-tool').attr('title', '保存文件中，请稍后..').removeClass('icon-warning').addClass('waiting');
            let othis = this;
            this.saveFileContent(
                {path: options.path, content: options.ace.getValue(), encoding: options.encoding},
                function () {
                    options.fileState = 0;
                    othis.transformRemove(options.id);
                },
                function () {
                    options.fileState = 1;
                    othis.dom.find('.item-tab-' + options.id + ' .icon-tool').removeClass('icon-remove').addClass('waiting');
                }
            );
        }

        // 清除状态栏
        removeStatusBar() {
            this.dom.find('.ace-container-toolbar [data-event]').html('');
        }

        // 更新状态栏
        currentStatusBar(id) {
            let item = this.editors[id];
            if (item === undefined) {
                this.removeStatusBar();
                return false;
            }
            this.dom.find('.ace-container-toolbar [data-event=cursor]').html('行<i class="cursor-row">1</i>, 列<i class="cursor-line">0</i>');
            this.dom.find('.ace-container-toolbar [data-event=path]').html('文件位置：<i title="' + item.path + '">' + item.path + '</i>');
            this.dom.find('.ace-container-toolbar [data-event=tab]').html(item.softTabs ? '空格：<i>' + item.tabSize + '</i>' : '制表符长度：<i>' + item.tabSize + '</i>');
            this.dom.find('.ace-container-toolbar [data-event=encoding]').html('编码：<i>' + item.encoding.toUpperCase() + '</i>');
            this.dom.find('.ace-container-toolbar [data-event=lang]').html('语言：<i>' + item.type + '</i>');
            this.dom.find('.ace-container-toolbar span').attr('data-id', id);
            this.dom.find('.file-fold').removeClass('bg');
            this.dom.find('.file-fold[data-menu-path="' + item.path + '"]').addClass('bg active');
            item.ace.resize();
        }

        // 设置编辑器视图
        setEditorView() {
            let othis = this, aceEditorHeight = othis.dom.find('.aceEditors').height(),
                autoAceHeight = setInterval(function () {
                    let pageH = othis.dom.find('.aceEditors').height(),
                        aceContainerMenuH = othis.dom.find('.ace-container-menu').height(),
                        aceContainerToolbar = othis.dom.find('.ace-container-toolbar').height(),
                        height = pageH - (othis.dom.find('.pull-down .layui-icon').hasClass('layui-icon-down') ? 35 : 0) - aceContainerMenuH - aceContainerToolbar - 42;
                    othis.dom.find('.ace-container-editor').height(height);
                    if (aceEditorHeight === othis.dom.find('.aceEditors').height()) {
                        let editor = othis.editors[othis.aceActive];
                        if (editor) editor.ace.resize();
                        clearInterval(autoAceHeight);
                    } else {
                        aceEditorHeight = othis.dom.find('.aceEditors').height();
                    }
                }, 200);
        }

        // 新建编辑器视图-方法
        addEditorView(options, callback) {
            options = $.extend({
                id: main.uuid(8),
                type: 'shortcutKeys',
                title: '快捷键提示',
                html: '',
            }, options || {});
            this.dom.find('.ace-container-menu .item,.ace-container-editor .ace-editors').removeClass('active');
            this.dom.find('.ace-container-menu').append('<li class="item active item-tab-' + options.id + '" data-type="' + options.type + '" data-id="' + options.id + '" >\
			<div class="ace-item-box">\
				<span class="icon_file"><i class="text-icon"></i></span>\
				<span>' + options.title + '</span>\
				<i class="iconfont icon-remove icon-tool" aria-hidden="true" data-title="' + options.title + '"></i>\
			</div>\
		</li>');
            $('#ace-editor-' + options.id).siblings().removeClass('active');
            this.dom.find('.ace-container-editor').append('<div id="ace-editor-' + options.id + '" class="ace-editors active">' + options.html + '</div>');
            this.removeStatusBar();
            ++this.editorsLength;
            callback && callback();
        }

        // 创建ACE编辑器-对象
        createEditor(options) {
            let othis = this;
            this.dom.find('.ace-container-editor .ace-editors').css('fontSize', othis.aceConfig['aceEditor'].fontSize + 'px');
            $('#ace-editor-' + options.id).text(options.data || '');
            if (this.editors === null) this.editors = {};
            this.editors[options.id] = {
                ace: ace.edit("ace-editor-" + options.id, {
                    theme: "ace/theme/" + othis.aceConfig['aceEditor'].editorTheme, //主题
                    mode: "ace/mode/" + (options.filename !== undefined ? options.mode : 'text'), // 语言类型
                    wrap: othis.aceConfig['aceEditor'].wrap,
                    showInvisibles: othis.aceConfig['aceEditor'].showInvisibles,
                    showPrintMargin: false,
                    enableBasicAutocompletion: true,
                    enableSnippets: othis.aceConfig['aceEditor'].enableSnippets,
                    enableLiveAutocompletion: othis.aceConfig['aceEditor'].enableLiveAutocompletion,
                    useSoftTabs: othis.aceConfig['aceEditor'].useSoftTabs,
                    tabSize: othis.aceConfig['aceEditor'].tabSize,
                    keyboardHandler: 'sublime',
                    readOnly: options.readOnly === undefined ? false : options.readOnly
                }), //ACE编辑器对象
                id: options.id,
                wrap: othis.aceConfig['aceEditor'].wrap, // 是否换行
                path: options.path,
                tabSize: othis.aceConfig['aceEditor'].tabSize,
                softTabs: othis.aceConfig['aceEditor'].useSoftTabs,
                filename: options.filename,
                enableSnippets: true, //是否代码提示
                encoding: options.encoding ? options.encoding : 'utf-8', // 编码类型
                mode: options.filename ? options.mode : 'text', // 语言类型
                type: options.type,
                fileState: 0, // 文件状态
            };
            let ACE = this.editors[options.id];
            ACE.ace.moveCursorTo(0, 0); //设置鼠标焦点
            ACE.ace.focus();//设置焦点
            ACE.ace.resize(); //设置自适应
            ACE.ace.commands.addCommand({
                name: '保存文件',
                bindKey: {win: 'Ctrl-S', mac: 'Command-S'},
                exec: function () {
                    othis.saveFileMethod(ACE);
                },
                readOnly: false // 如果不需要使用只读模式，这里设置false
            });
            ACE.ace.commands.addCommand({
                name: '跳转行',
                bindKey: {win: 'Ctrl-I', mac: 'Command-I'},
                exec: function () {
                    othis.dom.find('.ace-header .jumpLine').click();
                },
                readOnly: false // 如果不需要使用只读模式，这里设置false
            });
            // 获取光标位置
            ACE.ace.getSession().selection.on('changeCursor', function () {
                let cursor = ACE.ace.selection.getCursor();
                othis.dom.find('[data-event=cursor]').html('行<i class="cursor-row">' + (cursor.row + 1) + '</i>, 列<i class="cursor-line">' + cursor.column + '</i>');
            });
            // 触发修改内容
            ACE.ace.getSession().on('change', function () {
                othis.transformWarning(ACE.id);
                ACE.fileState = 1;
                othis.dom.find('.ace-toolbar-menu').hide();
            });
            // 修改当前状态栏
            this.currentStatusBar(ACE.id);
        }

        // 打开编辑器文件
        openEditor(path, callback) {
            if (!path) return false;
            if (this.paths.included(path)) {
                this.dom.find('.ace-container-menu [title="' + path + '"]').click();
            } else {
                let othis = this, filename = basename(path), fileType = this.getFileType(filename),
                    type = fileType.name, mode = fileType.mode, id = main.uuid(8);
                this.getFileContent({path: path}, function (data) {
                    othis.paths.push(path);
                    othis.dom.find('.ace-container-menu .item').removeClass('active');
                    othis.dom.find('.ace-container-editor .ace-editors').removeClass('active');
                    othis.dom.find('.ace-container-menu').append('<li class="item active item-tab-' + id + '" title="' + path + '" data-type="' + type + '" data-mode="' + mode + '" data-id="' + id + '" data-filename="' + filename + '">' +
                        '<div class="ace-item-box">' +
                        '<span class="icon_file"><i class="' + mode + '-icon"></i></span><span title="' + path + '">' + filename + '</span>' +
                        '<i class="iconfont icon-remove icon-tool" aria-hidden="true" data-title="' + filename + '"></i>' +
                        '</div>' +
                        '</li>');
                    othis.dom.find('.ace-container-editor').append('<div id="ace-editor-' + id + '" class="ace-editors active" style="font-size:' + othis.aceConfig['aceEditor'].fontSize + 'px"></div>');
                    othis.dom.find('.file-fold.bg').removeClass('bg');
                    othis.dom.find('[data-menu-path="' + path + '"]').find('.file-fold').addClass('active bg');
                    othis.aceActive = id;
                    othis.editorsLength += 1;
                    othis.createEditor({
                        id: id,
                        filename: filename,
                        path: path,
                        mode: mode,
                        encoding: data.encoding,
                        data: data.content,
                        type: type,
                    });
                    if (callback) callback(data, othis.editors[othis.aceActive]);
                    return false;
                });
            }
            this.dom.find('.toolbar-menu').hide();
        }

        // 删除编辑器视图
        removeEditor(id) {
            if (!id) id = this.aceActive;
            let activeElem = this.dom.find('.item-tab-' + id);
            if (this.editorsLength > 1) {
                if (activeElem.next().length > 0) {
                    activeElem.next().click();
                } else if (activeElem.prev().length > 0) {
                    activeElem.prev().click();
                }
            }
            activeElem.remove();
            $('#ace-editor-' + id).remove();
            this.editorsLength--;
            let editor = this.editors[id];
            if (!editor) return false;
            for (let i = 0; i < this.paths.length; i++) {
                if (this.paths[i] === editor.path) {
                    this.paths.splice(i, 1);
                }
            }
            this.dom.find('.file-fold[data-menu-path="' + editor.path + '"]').removeClass('active bg');
            this.editors[id].ace.destroy();
            delete this.editors[id];
            if (this.editorsLength === 0) {
                this.aceActive = '';
                this.paths = [];
                this.removeStatusBar();
            } else {
                this.currentStatusBar(this.aceActive);
            }
        }

        // 渲染事件
        render(filename) {
            let othis = this,
                functions = {
                    ok: function () {
                        let name = this.prev().val().trim(),
                            action = parseInt(this.parent().parent().attr('data-edit')) || 1;
                        if (name === '') {
                            this.prev().css('border', '1px solid #f34a4a');
                            layer.tips(action === 1 ? '目录名称不能为空' : (action === 2 ? '文件名称不能为空' : '新名称不能为空'), this.prev(), {
                                tips: [1, '#f34a4a'],
                                time: 0
                            });
                            return false;
                        }
                        if (this.prev().data('type') === 1) return false;
                        let active = othis.getActiveConfig();
                        if (action === 3 && active.elem.find('.file-title span').text() === name) {
                            this.prev().css('border', '1px solid #f34a4a');
                            layer.tips('您并没有修改名称!', this.prev(), {tips: [1, '#f34a4a'], time: 0});
                            return false;
                        }
                        if (action === 3) {
                            othis.renderFiles({
                                elem: active.elem.parent().parent(),
                                path: active.menuPath,
                                level: active.level,
                                isEmpty: true,
                                name: name,
                                action: action,
                            });
                            return false;
                        }
                        othis.renderFiles({
                            elem: active.boxElem,
                            path: active.dirname,
                            level: active.type === 1 ? active.level + 1 : active.level,
                            isEmpty: true,
                            name: name,
                            action: action,
                        });
                    },
                    // 取消修改或者添加
                    cancel: function () {
                        layer.closeAll('tips');
                        let foldElem = this.closest('.file-fold');
                        if (foldElem.attr('data-menu-path')) {
                            foldElem.removeAttr('data-edit');
                            this.parent().siblings().show();
                            this.parent().remove();
                            return false;
                        }
                        foldElem.parent().remove();
                    },
                    // 菜单下拉
                    pullDown: function () {
                        if (this.find('i').hasClass('layui-icon-down')) {
                            othis.dom.find('.ace-header').css({'top': '-35px'});
                            othis.dom.find('.ace-overall').css({'top': '0'});
                            this.css({'top': '35px', 'height': '40px', 'line-height': '40px'});
                            this.find('i').addClass('layui-icon-up').removeClass('layui-icon-down');
                        } else {
                            othis.dom.find('.ace-header').css({'top': '0'});
                            othis.dom.find('.ace-overall').css({'top': '35px'});
                            this.removeAttr('style');
                            this.find('i').addClass('layui-icon-down').removeClass('layui-icon-up');
                        }
                        // _this.setEditorView();
                    },
                    // 返回上层目录
                    upperLevel: function () {
                        othis.dom.find('.folder-down-up').hide();
                        othis.path = getUpper(othis.path);
                        othis.renderFiles.call(othis, {isEmpty: true});
                    },
                    // 刷新目录
                    refresh: function () {
                        othis.closeAll();
                        othis.renderFiles.call(othis, {isEmpty: true});
                    },
                    // 显示新建面板
                    foldNew: function () {
                        othis.closeAll();
                        othis.dom.find('.folder-down-up').show();
                    },
                    // 新建文件夹
                    newFolder: function () {
                        othis.newFileFolderDOM(1);
                    },
                    // 新建文件
                    newFile: function () {
                        othis.newFileFolderDOM(2);
                    },
                    // 打开搜索面板
                    searchFile: function () {
                        othis.closeAll();
                        othis.dom.find('.ace-dir-tools').hide();
                        othis.dom.find('.ace-dir-tools.search-file-box').show();
                        othis.dom.find('.ace-catalogue-list').css('top', '150px');
                        othis.dom.find('.cd-accordion-menu').empty();
                        othis.retainPath = othis.path;
                    },
                    // 关闭搜索
                    searchClose: function () {
                        othis.dom.find('.ace-dir-tools').show();
                        othis.dom.find('.ace-dir-tools.search-file-box').hide();
                        othis.dom.find('.ace-catalogue-list').removeAttr('style');
                        othis.path = othis.retainPath;
                        othis.renderFiles({isEmpty: true});
                        $('#search-val').css('border', '');
                        layer.closeAll('tips');
                    },
                    // 搜索提交
                    searchSubmit: function () {
                        let searchID = $('#search-val'), search = searchID.val();
                        if (!search) {
                            searchID.css('border', '1px solid #f34a4a');
                            layer.tips('搜索内容不能为空', searchID, {tips: [1, '#f34a4a'], time: 0});
                            return searchID.focus();
                        }
                        othis.renderFiles({
                            search: search,
                            recursive: $('#search-recursive').is(':checked'),
                            isEmpty: true,
                        });
                    },
                    // 目录显示和隐藏
                    foldX: function () {
                        if (this.find('i').hasClass('icon-arrow-right')) {
                            this.find('i').removeClass('icon-arrow-right').addClass('icon-arrow-left');
                            othis.dom.find('.ace-catalogue').css('left', '0');
                            this.attr('title', '隐藏文件目录');
                            $('.ace-editor-main').css('marginLeft', othis.dom.find('.ace-catalogue').width());
                        } else {
                            this.find('i').removeClass('icon-arrow-left').addClass('icon-arrow-right');
                            othis.dom.find('.ace-catalogue').css('left', '-' + othis.dom.find('.ace-catalogue').width() + 'px');
                            this.attr('title', '显示文件目录');
                            $('.ace-editor-main').css('marginLeft', 0);
                        }
                        setTimeout(function () {
                            if (othis.aceActive) othis.editors[othis.aceActive].ace.resize();
                        }, 600);
                    },
                    // 折叠栏目
                    foldFolder: function () {
                        othis.closeAll();
                        othis.dom.find('.file-fold').removeClass('bg');
                        this.addClass('bg');
                        let elem = this.next('ul'), isFold = this.children('span').hasClass('icon-arrow-right');
                        if (isFold) {
                            this.children('span.iconfont').removeClass('icon-arrow-right').addClass('icon-arrow-down');
                            elem.show();
                        } else {
                            this.children('span.iconfont').removeClass('icon-arrow-down').addClass('icon-arrow-right');
                            elem.hide();
                        }
                        if (isFold && elem.is(':empty')) {
                            othis.renderFiles({
                                elem: elem,
                                path: this.data('menuPath'),
                                level: parseInt(this.data('level')) + 1,
                            });
                        }
                    },
                    // 打开文件
                    openFile: function () {
                        othis.closeAll();
                        othis.openEditor(this.data('menuPath'));
                    },
                    // 刷新当前目录
                    refreshDir: function () {
                        let active = othis.getActiveConfig();
                        othis.closeAll();
                        othis.renderFiles({
                            elem: active.boxElem,
                            path: active.dirname,
                            isEmpty: true,
                            level: active.level + 1
                        }, function () {
                            layer.msg('刷新成功', {icon: 1});
                        });
                    },
                    // 进入目录
                    cd: function () {
                        let active = othis.getActiveConfig();
                        othis.closeAll();
                        othis.renderFiles({path: active.dirname, isEmpty: true});
                    },
                    // 重命名
                    rename: function () {
                        let active = othis.getActiveConfig();
                        othis.closeAll();
                        if (active.elem.hasClass('active')) {
                            layer.msg('该文件已打开，无法修改名称', {icon: 0});
                            return false;
                        }
                        active.elem.attr('data-edit', 3);
                        active.elem.find('.file-title').hide();
                        active.elem.find('.iconfont').hide();
                        let name = active.elem.find('.file-title span').text();
                        active.elem.prepend('<span class="file-input"><i class="'
                            + (active.elem.data('event') === 'foldFolder' ? 'folder' : (othis.getFileType(name).mode))
                            + '-icon"></i><input type="text" class="newly-file-input" value="' + name
                            + '" data-event="edit"><span class="iconfont icon-ok" aria-hidden="true" data-event="ok"></span><span class="iconfont icon-del" aria-hidden="true" data-event="cancel"></span>');
                        active.elem.find('.newly-file-input').width(active.elem.width() - active.level * 15 - 80);
                        active.elem.find('.newly-file-input').focus();
                    },
                    // 删除文件或目录
                    del: function () {
                        let active = othis.getActiveConfig();
                        othis.closeAll();
                        layer.confirm(active.menuPath, {
                            icon: 3, title: '确定删除(不可恢复)?',
                            closeBtn: 2, btn: ['确认', '取消'],
                            zIndex: 999999999
                        }, function (index) {
                            layer.close(index);
                            othis.renderFiles({
                                elem: active.elem.parent().parent(),
                                path: active.menuPath,
                                isEmpty: true,
                                level: active.level,
                                action: 4,
                            });
                        });
                    },
                    // 下载文件
                    download: function () {
                        let active = othis.getActiveConfig();
                        othis.closeAll();
                        main.download(active.menuPath);
                    },
                    //保存
                    saveFile: function () {
                        othis.dom.find('span.ace_searchbtn_close').click();
                        othis.saveFileMethod(othis.editors[othis.aceActive]);
                    },
                    //保存全部
                    saveFileAll: function () {
                        othis.dom.find('span.ace_searchbtn_close').click();
                        layer.open({
                            type: 1,
                            area: ['350px', '130px'],
                            btn: ['保存全部', '取消'],
                            title: false,
                            content: '<div class="ace-clear-form"><div class="clear-icon"></div><div class="clear-title">是否保存对全部文件的更改？</div><div class="clear-tips">如果不保存，更改会丢失！</div></div>',
                            yes: function (index) {
                                for (let item in othis.editors) {
                                    if (othis.editors[item].fileState !== 0) {
                                        othis.saveFileContent(
                                            {
                                                path: othis.editors[item].path,
                                                content: othis.editors[item].ace.getValue(),
                                                encoding: othis.editors[item].encoding
                                            },
                                            function () {
                                                othis.editors[item].fileState = 0;
                                                othis.transformRemove(othis.editors[item].id);
                                                return false;
                                            },
                                            function () {
                                                othis.editors[item].fileState = 1;
                                                othis.dom.find('.item-tab-' + othis.editors[item].id + ' .icon-tool').removeClass('icon-remove').addClass('waiting');
                                            }
                                        );
                                    }
                                }
                                layer.close(index);
                            },
                        });
                    },
                    // 刷新文件
                    refreshFile: function () {
                        othis.dom.find('span.ace_searchbtn_close').click();
                        let editor = othis.editors[othis.aceActive];
                        if (!editor) return false;
                        if (editor.fileState === 0) {
                            othis.getFileContent(
                                {path: editor.path, encoding: editor.encoding},
                                function (data) {
                                    editor.ace.setValue(data.content);
                                    editor.fileState = 0;
                                    othis.transformRemove(editor.id);
                                    layer.msg('刷新成功', {icon: 1});
                                    return false;
                                });
                        } else {
                            layer.open({
                                type: 1,
                                area: ['350px', '130px'],
                                btn: ['继续', '取消'],
                                title: false,
                                content: '<div class="ace-clear-form"><div class="clear-icon"></div><div class="clear-title">是否刷新当前文件？</div><div class="clear-tips">刷新当前文件会覆盖当前修改,是否继续！</div></div>',
                                yes: function (index) {
                                    othis.getFileContent({path: editor.path, encoding: editor.encoding},
                                        function (data) {
                                            editor.ace.setValue(data.content);
                                            editor.fileState = 0;
                                            othis.transformRemove(editor.id);
                                            layer.msg('刷新成功', {icon: 1});
                                            return false;
                                        });
                                    layer.close(index);
                                },
                            });
                        }
                    },
                    // 查找
                    search: function () {
                        othis.dom.find('.ace-toolbar-menu').hide();
                        othis.editors[othis.aceActive].ace.execCommand('find');
                    },
                    // 查找替换
                    replaces: function () {
                        othis.dom.find('.ace-toolbar-menu').hide();
                        othis.editors[othis.aceActive].ace.execCommand('replace');
                    },
                    // 跳转到
                    jumpLine: function () {
                        othis.dom.find('span.ace_searchbtn_close').click();
                        othis.dom.find('.ace-toolbar-menu').show().find('.menu-jumpLine').show().siblings().hide();
                        othis.dom.find('.set-jump-line input').val('').focus();
                        let editor = othis.editors[othis.aceActive],
                            cursor = editor.ace.selection.getCursor();
                        othis.dom.find('.set-jump-line .jump-tips span:eq(0)').text(cursor.row);
                        othis.dom.find('.set-jump-line .jump-tips span:eq(1)').text(cursor.column);
                        othis.dom.find('.set-jump-line .jump-tips span:eq(2)').text(editor.ace.session.getLength());
                        othis.dom.find('.set-jump-line input').off('keyup').on('keyup', function (e) {
                            let val = $(this).val();
                            if ((e.keyCode >= 48 && e.keyCode <= 57) || (e.keyCode >= 96 && e.keyCode <= 105)) {
                                if (val !== '' && typeof parseInt(val) === 'number') {
                                    editor.ace.gotoLine(val);
                                }
                            }
                        });
                    },
                    // 设置文字大小
                    fontSize: function () {
                        othis.dom.find('span.ace_searchbtn_close').click();
                        othis.dom.find('.ace-toolbar-menu').show().find('.menu-fontSize').show().siblings().hide();
                        othis.dom.find('.menu-fontSize .set-font-size input').val(othis.aceConfig['aceEditor'].fontSize).focus();
                        othis.dom.find('.menu-fontSize set-font-size input').off('keypress onkeydown').on('keypress onkeydown', function (e) {
                            let val = $(this).val();
                            if (val === '') {
                                $(this).css('border', '1px solid red');
                                $(this).next('.tips').text('字体设置范围 12-45');
                            } else if (!isNaN(val)) {
                                $(this).removeAttr('style');
                                if (parseInt(val) > 11 && parseInt(val) < 45) {
                                    $('.ace-container-editor .ace-editors').css('fontSize', val + 'px')
                                } else {
                                    $('.ace-container-editor .ace-editors').css('fontSize', '13px');
                                    $(this).css('border', '1px solid red');
                                    $(this).next('.tips').text('字体设置范围 12-45');
                                }
                            } else {
                                $(this).css('border', '1px solid red');
                                $(this).next('.tips').text('字体设置范围 12-45');
                            }
                            e.stopPropagation();
                            e.preventDefault();
                        });
                        othis.dom.find('.menu-fontSize .menu-container .set-font-size input').off('change').change(function () {
                            let val = $(this).val();
                            $('.ace-container-editor .ace-editors').css('fontSize', val + 'px');
                        });
                        othis.dom.find('.set-font-size .btn-save').off('click').on('click', function () {
                            let fontSize = othis.dom.find('.set-font-size input').val();
                            othis.aceConfig['aceEditor'].fontSize = parseInt(fontSize);
                            othis.saveAceConfig(othis.aceConfig, function () {
                                $('.ace-editors').css('fontSize', fontSize + 'px');
                            });
                        });
                    },
                    // 主题设置
                    themes: function () {
                        othis.dom.find('span.ace_searchbtn_close').click();
                        othis.dom.find('.ace-toolbar-menu').show().find('.menu-themes').show().siblings().hide();
                        let HTML = '', arr = ['白色主题', '黑色主题'];
                        for (let i = 0; i < othis.aceConfig['themeList'].length; i++) {
                            if (othis.aceConfig['themeList'][i] !== othis.aceConfig['aceEditor'].editorTheme) {
                                HTML += '<li data-value="' + othis.aceConfig['themeList'][i] + '">' + othis.aceConfig['themeList'][i] + '【' + arr[i] + '】</li>';
                            } else {
                                HTML += '<li data-value="' + othis.aceConfig['themeList'][i] + '" class="active">' + othis.aceConfig['themeList'][i] + '【' + arr[i] + '】' + okIconHTML + '</li>';
                            }
                        }
                        othis.dom.find('.menu-themes ul').html(HTML);
                        othis.dom.find('.menu-themes ul li').on('click', function () {
                            let theme = $(this).attr('data-value');
                            $(this).addClass('active').append(okIconHTML).siblings().removeClass('active').find('.icon').remove();
                            othis.aceConfig['aceEditor'].editorTheme = theme;
                            othis.saveAceConfig(othis.aceConfig, function () {
                                for (let item in othis.editors) {
                                    othis.editors[item].ace.setTheme("ace/theme/" + theme);
                                }
                            });
                        });
                    },
                    // 设置
                    setup: function () {
                        othis.dom.find('span.ace_searchbtn_close').click();
                        othis.dom.find('.ace-toolbar-menu').show().find('.menu-setup').show().siblings().hide();
                        othis.dom.find('.menu-setup .editor-menu li').each(function (index, el) {
                            if (othis.aceConfig['aceEditor'][$(el).attr('data-event')]) $(el).addClass('active').append(okIconHTML);
                        });
                        othis.dom.find('.menu-setup .editor-menu li').off('click').on('click', function () {
                            let option = $(this).attr('data-event');
                            othis.aceConfig['aceEditor'][option] = !$(this).hasClass('active');
                            if ($(this).hasClass('active')) {
                                $(this).removeClass('active').find('.icon').remove();
                            } else {
                                $(this).addClass('active').append(okIconHTML);
                            }
                            othis.saveAceConfig(othis.aceConfig, function () {
                                for (let item in othis.editors) {
                                    othis.editors[item].ace.setOption(option, othis.aceConfig['aceEditor'][option]);
                                }
                            });
                        });
                    },
                    // 帮助
                    helps: function () {
                        othis.dom.find('span.ace_searchbtn_close').click();
                        if (othis.dom.find('[data-type=shortcutKeys]').length === 0) {
                            othis.addEditorView({
                                title: '快捷键提示',
                                type: 'shortcutKeys',
                                html: $('#aceShortcutKeys').html()
                            });
                        } else {
                            othis.dom.find('[data-type=shortcutKeys]').click();
                        }
                    },
                    // 模板语法
                    template: function () {
                        othis.dom.find('span.ace_searchbtn_close').click();
                        if (othis.dom.find('[data-type=template]').length === 0) {
                            othis.addEditorView({
                                title: '复制模板语法',
                                type: 'template',
                                html: `<div class="keysUp_left">
    <div class="keysUp-row">
        <div class="keysUp-title">全局标签</div>
        <div class="keysUp-content">
            <div class="keysUp-item">
                <span class="keysUp-btn">{{.Config.Hostname}}</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="{{.Config.Hostname}}">复制</span>
                <span class="keysUp-tips">域名链接</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">{{.Config.Title}}</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="{{.Config.Title}}">复制</span>
                <span class="keysUp-tips">首页标题</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">{{.Config.Subtitle}}</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="{{.Config.Subtitle}}">复制</span>
                <span class="keysUp-tips">网站副标题</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">{{.Config.Keywords}}</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="{{.Config.Keywords}}">复制</span>
                <span class="keysUp-tips">首页关键词</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">{{.Config.City}}</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="{{.Config.City}}">复制</span>
                <span class="keysUp-tips">城市名称</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">{{.Config.Province}}</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="{{.Config.Province}}">复制</span>
                <span class="keysUp-tips">省名称</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">{{.Config.About}}</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="{{.Config.About}}">复制</span>
                <span class="keysUp-tips">关于我们</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">{{.Pager}}</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="{{.Pager}}">复制</span>
                <span class="keysUp-tips">页面标识</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">{{HTML .Config.Copyright}}</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="{{HTML .Config.Copyright}}">复制</span>
                <span class="keysUp-tips">版权</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">{{template "模板.tpl" .}}</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value='{{template "模板.tpl" .}}'>复制</span>
                <span class="keysUp-tips">导入模板</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">nav...</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="nav">复制</span>
                <span class="keysUp-tips">导航HTML</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">link...</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="link">复制</span>
                <span class="keysUp-tips">友情链接</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">tags...</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="tags">复制</span>
                <span class="keysUp-tips">TagHTML</span>
            </div>
        </div>
    </div>
    <div class="keysUp-row">
        <div class="keysUp-title">头部标签</div>
        <div class="keysUp-content">
            <div class="keysUp-item">
                <span class="keysUp-btn">head...</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="head">复制</span>
                <span class="keysUp-tips">头部整体</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">{{.Title}}</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="{{.Title}}">复制</span>
                <span class="keysUp-tips">标题</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">{{.Keywords}}</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="{{.Keywords}}">复制</span>
                <span class="keysUp-tips">关键词</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">{{.Description}}</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="{{.Description}}">复制</span>
                <span class="keysUp-tips">描述</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">{{canonicalLabel .Url}}</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="{{canonicalLabel .Url}}">复制</span>
                <span class="keysUp-tips">聚权标签</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">{{.Theme}}</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="{{.Theme}}">复制</span>
                <span class="keysUp-tips">主题路径</span>
            </div>
        </div>
    </div>
    <div class="keysUp-row">
        <div class="keysUp-title">列表标签</div>
        <div class="keysUp-content">
            <div class="keysUp-item">
                <span class="keysUp-btn">list...</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="list">复制</span>
                <span class="keysUp-tips">列表整体</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">{{HTML .Positions}}</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="{{HTML .Positions}}">复制</span>
                <span class="keysUp-tips">当前位置</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">{{HTML .Paginator}}</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="{{HTML .Paginator}}">复制</span>
                <span class="keysUp-tips">分页标签</span>
            </div>
        </div>
    </div>
</div>;
<div class="keysUp_right">
    <div class="keysUp-row">
        <div class="keysUp-title">循环标签</div>
        <div class="keysUp-content">
            <div class="keysUp-item">
                <span class="keysUp-btn">loop...</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="loop">复制</span>
                <span class="keysUp-tips">循环整体</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">{{.Title}}</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="{{.Title}}">复制</span>
                <span class="keysUp-tips">循环标题</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">{{.Subtitle}}</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="{{.Subtitle}}">复制</span>
                <span class="keysUp-tips">循环副标题</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">{{.Url}}</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="{{.Url}}">复制</span>
                <span class="keysUp-tips">循环链接</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">{{.TitlePic}}</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="{{.TitlePic}}">复制</span>
                <span class="keysUp-tips">标题图片</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">{{sub .Title 30}}</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="{{sub .Title 30}}">复制</span>
                <span class="keysUp-tips">剪切标题</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">{{sub .Description 150}}</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="{{sub .Description 150}}">复制</span>
                <span class="keysUp-tips">剪切描述</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">{{date .Updated "2006-01-02 15:04:05"}}</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value='{{date .Updated "2006-01-02 15:04:05"}}'>复制</span>
                <span class="keysUp-tips">发布时间</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">{{class .Cid | HTML}}</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="{{class .Cid | HTML}}">复制</span>
                <span class="keysUp-tips">栏目link</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">{{HTML .}}</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="{{HTML .}}">复制</span>
                <span class="keysUp-tips">HTML</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">{{imgHTML .}}</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="{{imgHTML .}}">复制</span>
                <span class="keysUp-tips">图片HTML</span>
            </div>
        </div>
    </div>
    <div class="keysUp-row">
        <div class="keysUp-title">文章标签</div>
        <div class="keysUp-content">
            <div class="keysUp-item">
                <span class="keysUp-btn">{{HTML .Positions}}</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="{{HTML .Positions}}">复制</span>
                <span class="keysUp-tips">当前位置</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">{{.Article.Title}}</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="{{.Article.Title}}">复制</span>
                <span class="keysUp-tips">标题</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">{{date .Article.Created "2006-01-02 15:04:05"}}</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value='{{date .Article.Created "2006-01-02 15:04:05"}}'>复制</span>
                <span class="keysUp-tips">时间</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">{{.Config.Hostname}}/hot.js?aid={{.Article.Id}}</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value='<script src="{{.Config.Hostname}}/hot.js?aid={{.Article.Id}}"></script>'>复制</span>
                <span class="keysUp-tips">点击量</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">{{source}}</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="{{source}}">复制</span>
                <span class="keysUp-tips">文章来源</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">{{HTML .Article.Content}}</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="{{HTML .Article.Content}}">复制</span>
                <span class="keysUp-tips">内容HTML</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">{{call .Article.MipContent}}</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="{{call .Article.MipContent}}">复制</span>
                <span class="keysUp-tips">MIP内容</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">{{.PreNext.Pre}}</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="{{.PreNext.Pre}}">复制</span>
                <span class="keysUp-tips">上一篇</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">{{.PreNext.Next}}</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="{{.PreNext.Next}}">复制</span>
                <span class="keysUp-tips">下一篇</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">like...</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="like">复制</span>
                <span class="keysUp-tips">相关文章</span>
            </div>
            <div class="keysUp-item">
                <span class="keysUp-btn">tag...</span>
                <span class="keysUp-symbol">-></span>
                <span class="keysUp-btn" data-value="tag">复制</span>
                <span class="keysUp-tips">TagHTML</span>
            </div>
        </div>
    </div>
</div>`,
                            }, function () {

                            });
                        } else {
                            othis.dom.find('[data-type=template]').click();
                        }
                    },
                    // 设置编码
                    encoding: function () {
                        othis.dom.find('span.ace_searchbtn_close').click();
                        othis.getEncodingList(othis.editors[othis.aceActive].encoding);
                        othis.dom.find('.ace-toolbar-menu').show().find('.menu-encoding').show().siblings().hide();
                    },
                    // 设置tabs
                    tab: function () {
                        othis.dom.find('span.ace_searchbtn_close').click();
                        let editor = othis.editors[othis.aceActive];
                        othis.dom.find(".tabsType>li,.tabsSize>li").removeClass('active');
                        othis.dom.find('.ace-toolbar-menu').show().find('.menu-tabs').show().siblings().hide();
                        othis.dom.find('.tabsType').find(editor.softTabs ? '[data-value="nbsp"]' : '[data-value="tabs"]').addClass('active').append(okIconHTML);
                        othis.dom.find('.tabsSize [data-value="' + editor.tabSize + '"]').addClass('active').append(okIconHTML);
                    },
                    // 跳转到
                    cursor: function () {
                        othis.dom.find('span.ace_searchbtn_close').click();
                        othis.dom.find('.ace-toolbar-menu').hide();
                        othis.dom.find('.ace-header [data-event=jumpLine]').click();
                    },
                };
            if (!this.aceConfig) {
                let loading = main.loading(),
                    request = $.ajax({
                        type: 'GET',
                        async: false,
                        url: '/file/content',
                        data: {path: encodeURIComponent('static/file/ace/ace.config.json')}
                    });
                request.done(function (res) {
                    if (res.code !== 0) {
                        main.error(res.msg);
                        layer.closeAll();
                    } else {
                        localStorage.setItem('aceConfig', res.data.content);
                        othis.aceConfig = JSON.parse(res.data.content);
                    }
                });
                request.fail(function (xhr, status, error) {
                    main.error(error);
                    layer.closeAll();
                });
                request.always(function () {
                    loading.close();
                });
            }
            if (!this.aceConfig) return false;
            // 渲染当前栏目
            this.renderFiles({path: othis.path});
            // 打开当前文件
            this.openEditor(filename);
            // 监听所有自定义点击事件
            this.dom.on('click', '[data-event]', function (e) {
                let $this = $(this), event = $this.data('event');
                functions[event] && functions[event].call($this, e);
                e.preventDefault();
                e.stopPropagation();
            });
            // 移动编辑器文件目录
            this.dom.on('mousedown', '.drag-icon-container', function () {
                let left = $('.aceEditors')[0].offsetLeft;
                othis.dom.find('.ace_gutter-layer').css('cursor', 'col-resize');
                $('#ace-container').unbind().on('mousemove', function (ev) {
                    let width = (ev.clientX + 1) - left;
                    if (width >= 265 && width <= 450) {
                        othis.dom.find('.ace-catalogue').css({'width': width, 'transition': 'none'});
                        othis.dom.find('.ace-editor-main').css({'marginLeft': width, 'transition': 'none'});
                        othis.dom.find('.ace-catalogue-drag-icon').css('left', width);
                        let inputElem = othis.dom.find('.file-fold .newly-file-input');
                        inputElem.width(inputElem.parent().parent().parent().width() - 80 - (inputElem.parent().parent().attr('data-level') * 15));
                        let id = othis.dom.find('.ace-container-menu li.item.active').attr('data-id');
                        othis.editors[id] && othis.editors[id].ace.resize();
                    }
                }).on('mouseup', function () {
                    othis.dom.find('.ace_gutter-layer').css('cursor', 'inherit');
                    othis.dom.find('.ace-catalogue').css('transition', 'all 500ms');
                    othis.dom.find('.ace-editor-main').css('transition', 'all 500ms');
                    $(this).unbind('mouseup mousemove');
                });
            });
            // 右键菜单
            this.dom.on('mousedown', '.ace-catalogue-list .file-fold', function (e) {
                let $this = $(this), x = e.clientX, y = e.clientY,
                    boxElem = $('.aceEditors')[0], left = boxElem.offsetLeft, top = boxElem.offsetTop,
                    foldElem = othis.dom.find('.ace-catalogue-list .has-children .file-fold');
                if (e.which === 3) {
                    othis.closeAll();
                    othis.dom.find('.ace-catalogue-menu').css({'display': 'block', 'left': x - left, 'top': y - top});
                    foldElem.removeClass('bg');
                    $this.addClass('bg');
                    othis.dom.find('.ace-catalogue-menu li').show();
                    if ($this.data('event') === 'foldFolder') {
                        othis.dom.find('.ace-catalogue-menu li[data-event=download]').hide();
                    } else {
                        othis.dom.find('.ace-catalogue-menu li:nth-child(-n+4)').hide();
                    }
                    $(document).on('click', function () {
                        othis.dom.find('.ace-catalogue-menu').hide();
                        $(this).off('click');
                        return false;
                    });
                }
            });
            // 屏蔽浏览器右键菜单
            this.dom.find('.ace-catalogue-list')[0].oncontextmenu = function () {
                return false;
            };
            // 新建、重命名键盘事件
            this.dom.find('.cd-accordion-menu').on('keyup', '.has-children .file-fold input', function (e) {
                let $this = $(this), arr = $this.closest('li.has-children').siblings(),
                    action = parseInt($this.parent().parent().attr('data-edit')) || 1,
                    isFolder = $this.parent().parent().data('event') === 'foldFolder';
                /* 1=新建文件夹 2=新建文件 3=重命名 */
                for (let i = 0; i < arr.length; i++) {
                    if ($(arr[i]).find('.file-title span').text() === $this.val()) {
                        $this.css('border', '1px solid #f34a4a');
                        $this.attr('data-event', 1);
                        layer.tips(isFolder ? '存在同名目录' : '存在同名文件', $this[0], {
                            tips: [1, '#f34a4a'],
                            time: 0
                        });
                        return false
                    }
                }
                // 判断编辑文件
                if (!isFolder && action !== 1 && $this.val().indexOf('.')) $this.prev().removeAttr('class').addClass(othis.getFileType($this.val()).mode + '-icon');
                $this.css('border', '');
                $this.removeAttr('data-type');
                layer.closeAll('tips');
                if (e.keyCode === 13) $this.next().click();
                othis.dom.find('.ace-toolbar-menu').hide();
                e.preventDefault();
                e.stopPropagation();
            });
            // 搜索按键
            this.dom.find('.ace-catalogue').on('keyup', '.search-input-view input', function (e) {
                $(this).css('border', '');
                layer.closeAll('tips');
                e.preventDefault();
                e.stopPropagation();
            });
            // 菜单
            let aceContainerMenu = this.dom.find('.ace-container-menu');
            // 切换TAB视图
            aceContainerMenu.on('click', '.item', function () {
                let id = $(this).attr('data-id');
                othis.dom.find('.item-tab-' + id).addClass('active').siblings().removeClass('active');
                $('#ace-editor-' + id).addClass('active').siblings().removeClass('active');
                othis.aceActive = id;
                othis.currentStatusBar(id);
            });
            // 移上TAB按钮变化，仅文件被修改后
            aceContainerMenu.on('mouseover', '.item .icon-tool', function () {
                let editor = othis.editors[$(this).closest('li.item').attr('data-id')];
                if (editor && editor.fileState !== 0) {
                    $(this).removeClass('icon-warning').addClass('icon-remove');
                }
            });
            // 移出tab按钮变化，仅文件被修改后
            aceContainerMenu.on('mouseout', '.item .icon-tool', function () {
                let editor = othis.editors[$(this).closest('li.item').attr('data-id')];
                if (editor && editor.fileState !== 0) {
                    $(this).removeClass('icon-remove').addClass('icon-warning');
                }
            });
            // 关闭编辑视图
            aceContainerMenu.on('click', '.item .icon-tool', function (e) {
                let id = $(this).closest('li.item').attr('data-id'),
                    editor = othis.editors[id];
                if (editor && editor.fileState === 1) {
                    // 未保存
                    layer.open({
                        type: 1,
                        area: ['400px', '130px'],
                        title: false,
                        btn: ['不保存文件', '保存并关闭'],
                        content: '<div class="ace-clear-form"><div class="clear-icon"></div><div class="clear-title">检测到文件未保存，是否保存文件更改？</div><div class="clear-tips">如果不保存，更改会丢失！</div></div>',
                        yes: function (index) {
                            othis.removeEditor(id);
                            layer.close(index);
                        },
                        btn2: function () {
                            othis.saveFileMethod(editor);
                            othis.removeEditor(id);
                        }
                    });
                } else {
                    // 直接关闭
                    othis.removeEditor(id);
                }
                othis.dom.find('.ace-toolbar-menu').hide();
                e.stopPropagation();
                e.preventDefault();
            });
            let formHTML = '<div class="layui-card"><div class="layui-card-body layui-form"></div></div>',
                headHTML = `<head>
    <meta charset="UTF-8">
    <meta content="IE=11,IE=10,IE=9,IE=8" http-equiv="X-UA-Compatible">
    <meta content="pc,mobile" name="applicable-device">
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport">
    <title>{{.Title}}</title>
    <meta content="{{.Keywords}}" name="keywords">
    <meta content="{{.Description}}" name="description">
    <link href="{{.Theme}}/css/style.css" media="all" rel="stylesheet" type="text/css"/>
    <script src="{{.Theme}}/js/bootstrap.min.js" type="text/javascript"></script>
    {{canonicalLabel .Url}}
    <meta content="webpage" property="og:type"/>
    <meta content="{{.Url}}" property="og:url"/>
    <meta content="{{.Config.Subtitle}}" property="og:site_name"/>
    <meta content="{{.Title}}" property="og:title"/>
    <meta content="{{.Description}}" property="og:description"/>
    <meta content="{{.TitlePic}}" property="og:image"/>
</head>`,
                navHTML = `<ul class="nav">
    <li>
        <a href="{{.Config.Hostname}}/">首页</a>
    <li>
        {{- range classes 12}}
    <li{{if eq .Id $.Class.Id}} class="cur"{{end}}>
        <a href="{{.Url}}">{{.Name}}</a>
        {{- if .Children}}
        <ul>
            {{- range .Children}}
            <li{{if eq .Id $.Class.Id}} class="cur"{{end}}><a href="{{.Url}}">{{.Name}}</a></li>
            {{- end}}
        </ul>
        {{- end}}
    </li>
    {{- end}}
</ul>`,
                linkHTML = `<div class="layui-form-item">
    <label class="layui-form-label">限制:</label>
    <div class="layui-input-inline">
        <input class="layui-input" min="1" name="limit" type="number" value="30">
    </div>
</div><div class="layui-form-item">
    <label class="layui-form-label">显示:</label>
    <div class="layui-input-block">
        <input name="pager" title="全部" type="radio" value="all">
        <input checked name="pager" title="首页" type="radio" value="index">
        <input name="pager" title="封面" type="radio" value="face">
        <input name="pager" title="文章" type="radio" value="article">
        <input name="pager" title="TAG" type="radio" value="tag">
    </div>
</div>`,
                tagsHTML = `<div class="layui-form-item">
    <label class="layui-form-label">限制:</label>
    <div class="layui-input-inline">
        <input class="layui-input" min="1" name="limit" type="number" value="30">
    </div>
</div><div class="layui-form-item">
    <label class="layui-form-label">推荐:</label>
    <div class="layui-input-block">
        <input name="level" title="荐1" type="checkbox" value="1">
        <input name="level" title="荐2" type="checkbox" value="2">
        <input name="level" title="荐3" type="checkbox" value="3">
    </div>
</div><div class="layui-form-item">
    <label class="layui-form-label">排序:</label>
    <div class="layui-input-block">
        <input checked name="order" title="最火" type="radio" value="0">
        <input name="order" title="最新" type="radio" value="1">
        <input name="order" title="随机" type="radio" value="2">
    </div>
</div>`;
            // 复制模板标签
            this.dom.find('.ace-container-editor').on('click', '[data-value]', function (e) {
                let val = $(this).data('value');
                switch (val) {
                    case "head":
                        main.copy(headHTML);
                        break;
                    case "nav":
                        main.copy(navHTML);
                        break;
                    case "link":
                        main.open({
                            area: ["600px", "180px"],
                            maxmin: false,
                            title: false,
                            content: formHTML,
                            success: function (dom) {
                                dom.find(".layui-form").html(linkHTML);
                                form.render();
                            },
                            yes: function (index, dom) {
                                let data = main.formData(dom);
                                if (data.pager === 'all') {
                                    main.copy(`<ul class="link">
    {{- range links ` + data.limit + `}}
    <li>{{HTML .}}</li>
    {{- end}}
</ul>`);
                                } else {
                                    main.copy(`{{if eq .Pager "` + data.pager + `"}}
<ul class="link">
    {{- range links ` + data.limit + `}}
    <li>{{HTML .}}</li>
    {{- end}}
</ul>
{{end}}`);
                                }
                                layer.close(index);
                            },
                        });
                        break;
                    case "tags":
                        main.open({
                            area: ["600px", "220px"], maxmin: false,
                            title: false, content: formHTML, success: function (dom) {
                                dom.find(".layui-form").html(tagsHTML);
                                form.render();
                            }, yes: function (index, dom) {
                                let data = main.formData(dom),
                                    begin = "{{- range tags " + (parseInt(data.order) || 0) + " " + data.limit;
                                if (data.level) {
                                    begin += " \"level=" + (Array.isArray(data.level) ? data.level.join(",") : data.level) + "\"";
                                }
                                begin += "}}";
                                main.copy(`<ul class="tags">
    ` + begin + `
    <li>{{HTML .}}</li>
    {{- end}}
</ul>`);
                                layer.close(index);
                            },
                        });
                        break;
                    case "like":
                        main.open({
                            area: ["400px", "110px"],
                            maxmin: false,
                            title: false,
                            content: formHTML,
                            success: function (dom) {
                                dom.find(".layui-form").html(`<div class="layui-form-item">
    <label class="layui-form-label">限制:</label>
    <div class="layui-input-inline">
        <input class="layui-input" min="1" name="limit" type="number" value="30">
    </div>
</div>`);
                                form.render();
                            },
                            yes: function (index, dom) {
                                let data = main.formData(dom);
                                main.copy(`<ul class="like">
    {{- range like ` + data.limit + `}}
    <li>{{HTML .}}</li>
    {{- end}}
</ul>`);
                                layer.close(index);
                            },
                        });
                        break;
                    case "loop":
                        main.open({
                            area: ["900px", "400px"],
                            maxmin: false,
                            title: false,
                            content: formHTML,
                            success: function (dom) {
                                dom.find(".layui-form").html(`<div class="layui-form-item">
    <div class="layui-inline">
        <label class="layui-form-label" lay-tips="留空为当前栏目">栏目ID:</label>
        <div class="layui-input-block">
            <input class="layui-input" name="id" placeholder="1,2,3,5,6" type="text" value="">
        </div>
    </div>
    <div class="layui-inline">
        <label class="layui-form-label">循环限制:</label>
        <div class="layui-input-block">
            <input class="layui-input" min="1" name="limit" type="number" value="8">
        </div>
    </div>
</div>
<div class="layui-form-item">
    <div class="layui-inline">
        <label class="layui-form-label">标题截取:</label>
        <div class="layui-input-block">
            <input class="layui-input" min="1" name="sub_title" type="number" value="60">
        </div>
    </div>
    <div class="layui-inline">
        <label class="layui-form-label">描述截取:</label>
        <div class="layui-input-block">
            <input class="layui-input" min="1" name="sub_description" type="number" value="180">
        </div>
    </div>
</div>
<div class="layui-form-item">
    <label class="layui-form-label">推荐:</label>
    <div class="layui-input-block">
        <input name="level" title="荐1" type="checkbox" value="1">
        <input name="level" title="荐2" type="checkbox" value="2">
        <input name="level" title="荐3" type="checkbox" value="3">
        <input name="level" title="荐4" type="checkbox" value="4">
        <input name="level" title="荐5" type="checkbox" value="5">
        <input name="level" title="荐6" type="checkbox" value="6">
    </div>
</div>
<div class="layui-form-item">
    <label class="layui-form-label">时间格式:</label>
    <div class="layui-input-block">
        <input checked name="time" title="01-02 15:04" type="radio" value="01-02 15:04:05">
        <input name="time" title="2006-01-02 15:04" type="radio" value="2006-01-02 15:04:05">
        <input name="time" title="2006-01-02" type="radio" value="2006-01-02">
    </div>
</div>
<div class="layui-form-item">
    <div class="layui-inline">
        <label class="layui-form-label">条件:</label>
        <div class="layui-input-block">
            <input checked name="where" title="任意" type="radio" value="">
            <input name="where" title="有图片" type="radio" value="title_pic=1">
        </div>
    </div>
    <div class="layui-inline">
        <label class="layui-form-label">排序:</label>
        <div class="layui-input-block">
            <input checked name="order" title="最新" type="radio" value="0">
            <input name="order" title="最火" type="radio" value="1">
            <input name="order" title="ID升序" type="radio" value="2">
            <input name="order" title="ID降序" type="radio" value="3">
            <input name="order" title="随机" type="radio" value="4">
        </div>
    </div>
</div>`);
                                form.render();
                            },
                            yes: function (index, dom) {
                                let data = main.formData(dom), range = '{{- range loop';
                                if (data.id !== "") {
                                    range += ' "' + data.id + '"';
                                } else {
                                    range += ' ""';
                                }
                                range += ' ' + data.order;
                                range += ' ' + data.limit;
                                if (Array.isArray(data.level)) {
                                    range += ' "level=' + data.level.join() + '"';
                                } else if (data.level) {
                                    range += ' "level=' + data.level + '"';
                                }
                                if (data['where']) {
                                    range += ` "` + data['where'] + `"`;
                                }
                                range += "}}";
                                main.copy(`<ul>
    ` + range + `
    <li>
        {{- if .TitlePic -}}
        <!--标题图片-->
        <img alt="{{.Subtitle}}" src="{{.TitlePic}}" title="{{.Title}}">
        {{- end -}}
        <!--标题链接-->
        <a href="{{.Url}}">{{sub .Title ` + data['sub_title'] + `}}</a>
        <!--描述-->
        <p>{{sub .Description ` + data['sub_description'] + `}}</p>
        <time>{{date .Updated "` + data.time + `"}}</time>
    </li>
    {{- end}}
</ul>`);
                                layer.close(index);
                            },
                        });
                        break;
                    case "list":
                        main.copy(`<ul>
    {{- range .List}}
    <li>
        {{- if .TitlePic -}}
        <!--标题图片-->
        <img alt="{{.Subtitle}}" src="{{.TitlePic}}" title="{{.Title}}">
        {{- end -}}
        <!--标题链接-->
        <a href="{{.Url}}">{{sub .Title 30}}</a>
        <!--描述-->
        <p>{{sub .Description 150}}</p>
        <time>{{date .Updated "2006-01-02 15:04"}}</time>
    </li>
    {{- end}}
</ul>`);
                        break;
                    case "tag":
                        main.copy(`<ul>
    {{- range .Tags}}
    <li>{{.}}</li>
    {{- end}}
</ul>`);
                        break;
                    default:
                        main.copy(val);
                }
                e.stopPropagation();
                e.preventDefault();
            });
            // 拖拽排序
            aceContainerMenu.dragsort({
                dragSelector: '.icon_file',
                itemSelector: 'li'
            });
            // 最小化
            $('.aceEditors .layui-layer-min').on('click', function () {
                othis.setEditorView();
            });
            // 最大化
            $('.aceEditors .layui-layer-max').on('click', function () {
                othis.setEditorView();
            });

            $(window).resize(function () {
                if (othis.aceActive) othis.setEditorView();
                if ($('.aceEditors .layui-layer-maxmin').length > 0) {
                    $('.aceEditors').css({
                        'top': 0,
                        'left': 0,
                        'width': $(this)[0].innerWidth,
                        'height': $(this)[0].innerHeight
                    });
                }
            });
            $(document).on('click', function () {
                $('.ace-container-editor .ace-editors').css('fontSize', othis.aceConfig['aceEditor'].fontSize + 'px');
            });
            othis.dom.find('.ace-editor-main').on('click', function () {
                othis.dom.find('.ace-toolbar-menu').hide();
            });
            $(window).keyup(function (e) {
                if (e.keyCode === 116 && $('#ace-container').length === 1) {
                    layer.msg('编辑器模式下无法刷新网页，请关闭后重试');
                }
            });
            // 设置编码内容
            othis.dom.find('.menu-encoding').on('click', 'li', function () {
                let editor = othis.editors[othis.aceActive], encoding = $(this).attr('data-value');
                layer.msg('设置文件编码：' + encoding);
                othis.dom.find('.ace-container-toolbar [data-event=encoding]').html('编码：<i>' + encoding + '</i>');
                $(this).addClass('active').append(okIconHTML).siblings().removeClass('active').find('span').remove();
                editor.encoding = encoding;
                editor.fileState = 1;
                othis.dom.find('.ace-container-menu>.item-tab-' + editor.id + '>.ace-item-box>i').removeClass('icon-remove').addClass('icon-warning');
                layer.confirm('指定编码"' + encoding + '"重载? 会丢失已修改内容!', {
                    title: false,
                    icon: 3
                }, function (index) {
                    layer.close(index);
                    othis.getFileContent({path: editor.path, encoding: editor.encoding},
                        function (data) {
                            editor.ace.setValue(data.content);
                            editor.fileState = 0;
                            othis.transformRemove(editor.id);
                            layer.msg('重载成功', {icon: 1});
                            return false;
                        });
                });
            });
            // 设置换行符
            othis.dom.find('.menu-tabs').on('click', 'li', function (e) {
                let val = $(this).attr('data-value'), editor = othis.editors[othis.aceActive];
                if ($(this).parent().hasClass('tabsType')) {
                    editor.ace.getSession().setUseSoftTabs(val === 'nbsp');
                    editor.softTabs = (val === 'nbsp');
                } else {
                    editor.ace.getSession().setTabSize(val);
                    editor.tabSize = val;
                }
                $(this).siblings().removeClass('active').find('.icon').remove();
                $(this).addClass('active').append(okIconHTML);
                othis.currentStatusBar(editor.id);
                e.stopPropagation();
                e.preventDefault();
            });
        }
    }

    exports('file', function (options) {
        options = options || {};
        let url = options.url || $('meta[name=current_uri]').attr('content'),
            csrfToken = options['csrfToken'] || $('meta[name=csrf_token]').attr('content'),
            pathElem = typeof options.elem === 'string' ? $(options.elem) : $('#current-path'),
            appRoot = options.appRoot || '/data/botadmin',
            data = {path: options.path || main.getParam('path') || '/home/wwwroot'},
            renderPath = function () {
                data.path = data.path || '/';
                if (data.path.substring(0, 1) !== '/') {
                    data.path = appRoot + '/' + data.path;
                }
                pathElem.attr('title', data.path).show().parent().find('input').attr('type', 'hidden');
                let paths = data.path.split('/'), p = [], elem = '<span title="/">根目录</span>';
                for (let i = 1; i < paths.length; i++) {
                    paths[i] = paths[i].trim();
                    if (paths[i]) {
                        p.push(paths[i]);
                        elem += '<span>></span></span><span title="/' + p.join('/') + '">' + paths[i] + '</span>';
                    }
                }
                pathElem.html(elem);
                $('#current-path>span[title]').off('click').on('click', function () {
                    refresh(this.title);
                });
            },
            uploaded = upload.render({
                headers: {'X-CSRF-Token': csrfToken},
                elem: '#upload',
                url: url + '/upload',
                data: {path: data.path},
                accept: 'file',
                done: function (res) {
                    refresh();
                    layer.msg(res.msg);
                },
            }),
            tabled = table.render({
                headers: {'X-CSRF-Token': csrfToken},
                method: 'post',
                elem: '#table-list',
                url: url,
                toolbar: '#toolbar',
                where: {path: data.path},
                cols: [[{type: 'checkbox', fixed: 'left'},
                    {
                        field: 'name',
                        minWidth: 100,
                        title: '名称',
                        sort: true,
                        style: 'color:#0a6e85;cursor:pointer',
                        event: 'name',
                        templet: (d) => {
                            let name;
                            switch (d.type) {
                                case 0:
                                    name = '<i class="iconfont icon-folder"></i> ' + d.name;
                                    break;
                                case 1:
                                    name = '<i class="iconfont icon-file"></i> ' + d.name;
                                    break;
                                case 2:
                                    name = '<i class="iconfont icon-compress"></i> ' + d.name;
                                    break;
                                case 3:
                                    name = '<i class="iconfont icon-html"></i> ' + d.name;
                                    break;
                                case 4:
                                    name = '<i class="iconfont icon-php"></i> ' + d.name;
                                    break;
                                case 5:
                                    name = '<i class="iconfont icon-js"></i> ' + d.name;
                                    break;
                                case 6:
                                    name = '<i class="iconfont icon-css"></i> ' + d.name;
                                    break;
                                case 7:
                                    name = '<i class="iconfont icon-img"></i> ' + d.name;
                                    break;
                                case 8:
                                    name = '<i class="iconfont icon-iso"></i> ' + d.name;
                                    break;
                            }
                            return '<b title="' + d.path + '">' + name + '</b>';
                        }
                    }, {field: 'type', title: '类型', width: 100, hide: true},
                    {field: 'uname', title: '所有者', width: 80},
                    {field: 'gname', title: '所有组', width: 80},
                    {field: 'uid', title: '用户ID', hide: true},
                    {
                        field: 'gid', title: '组ID', hide: true
                    },
                    {
                        field: 'size',
                        title: 'Size',
                        width: 100,
                        sort: true,
                        style: 'color:#0a6e85;cursor:pointer',
                        event: "size",
                        align: 'center',
                        templet: (d) => {
                            if (d.type === 0) {
                                return "计算";
                            }
                            return d.size;
                        }
                    },
                    {field: 'mode', title: '权限', width: 100}, {
                        field: 'mtime',
                        title: '最后修改',
                        width: 170,
                        sort: true
                    },
                    {
                        title: '操作', minWidth: 180, align: 'center', fixed: 'right', templet: (d) => {
                            let html = '<div class="layui-btn-group">';
                            if (/data\/contact\/images\/[^\/]+\.(jpeg|gif|jpg|png)/i.test(d.path)) {
                                html += '<button class="layui-btn layui-btn-xs layui-btn-primary" lay-event="copy" lay-tips="复制图片地址"><i class="layui-icon iconfont icon-copy"></i></button>';
                            }
                            switch (d.type) {
                                case 2:
                                    html += '<button class="layui-btn layui-btn-xs" lay-event="decompress">解压</button><button class="layui-btn layui-btn-xs" lay-event="download" lay-tips="下载"><i class="layui-icon layui-icon-download-circle"></i></button>';
                                    break;
                                case 0:
                                    html += '<button class="layui-btn layui-btn-xs" lay-event="compress">压缩</button>';
                                    break;
                                default:
                                    html += '<button class="layui-btn layui-btn-xs" lay-event="download"><i class="layui-icon layui-icon-download-circle"></i></button>';
                            }
                            return html + '<button class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del"><i class="layui-icon layui-icon-delete"></i></button></div>';
                        }
                    }]],
                page: true,
                limit: 100,
                limits: [100, 200, 500, 1000],
                text: '对不起，加载出现异常！',
                done: function (res) {
                    if (this.where) {
                        delete this.where.search
                    }
                    data = res;
                    window.scrollTo(0, 0);
                    renderPath();
                    uploaded.reload({
                        data: {path: data.path},
                        done: function (res) {
                            refresh();
                            layer.msg(res.msg);
                        },
                    });
                }
            }),
            refresh = function (path) {
                tabled.reload({where: {path: path || data.path}});
            },
            active = {
                terminal: function () {
                    main.webssh({stdin: 'cd ' + data.path});
                },
                refresh: refresh,
                gotoTop: function () {
                    refresh(getUpper(data.path));
                },
                copy: function (obj) {
                    let name = obj.data.path.split('/images/', 2)[1];
                    if (name) {
                        main.copy('{{hostname}}/images/' + name);
                    }
                },
                size: function (obj) {
                    let elem = $(obj.tr.selector + ' [data-field=size]>div');
                    if (elem.find('img[src$=".svg"]').length > 0) {
                        return false;
                    }
                    elem.html(`<img alt="等待计算结果" src="/static/images/loading-small.svg">`);
                    $.get(url + '/size', {path: obj.data.path}, function (res) {
                        elem.text(res);
                    });
                },
                del: function (obj) {
                    layer.confirm('删除后不可恢复！确定删除 ' + obj.data.path + ' ?', function (index) {
                        main.request({
                            url: url + '/del', data: {name: obj.data.path}, index: index, done: obj.del,
                        });
                    });
                },
                name: function (obj) {
                    switch (obj.data.type) {
                        case 0:
                            refresh(obj.data.path);
                            break;
                        case 2:
                        case 7:
                            main.preview(obj.data.path);
                            break;
                        case 8:
                            layer.confirm('确定下载 ' + obj.data.name + ' ?', function (index) {
                                main.download(obj.data.path);
                                layer.close(index);
                            });
                            break;
                        default:
                            //'文本在线编辑器'
                            $('#LAY_app_flexible.layui-icon-shrink-right', window.parent.document).click();
                            main.open({
                                title: false,
                                shadeClose: false,
                                maxmin: false,
                                shade: 0.95,
                                skin: 'aceEditors',
                                btn: false,
                                content: $('#aceEditor').html(),
                                success: function (dom) {
                                    this.editor = new Editor({dom: dom, path: data.path});
                                    this.editor.render(obj.data.path);
                                },
                                resizing: function () {
                                    this.editor.setEditorView();
                                },
                            });
                    }
                },
                compress: function (obj) {
                    main.request({
                        url: url + '/compress',
                        data: {'name': obj.data.path},
                        done: function () {
                            refresh();
                        },
                    });
                },
                decompress: function (obj) {
                    main.request({
                        url: url + '/decompress',
                        data: {'name': obj.data.path},
                        done: function () {
                            refresh();
                        },
                    });
                },
                download: function (obj) {
                    main.download(obj.data.path);
                },
                gotoWww: function () {
                    refresh('/home/wwwroot');
                },
                gotoRoot: function () {
                    refresh('/root');
                },
                newFolder: function () {
                    layer.prompt({
                        formType: 0, value: 'botadmin.cn', title: '请输入文件夹名不要有空格!'
                    }, function (value, index) {
                        main.request({
                            url: url + '/new/folder',
                            data: {name: value, path: data.path},
                            index: index,
                            done: function () {
                                refresh();
                            },
                        });
                    });
                },
                newFile: function () {
                    layer.prompt({
                        formType: 0, value: 'botadmin.cn', title: '请输入文件名不要有空格!'
                    }, function (value, index) {
                        main.request({
                            url: url + '/new/file',
                            data: {name: value, path: data.path},
                            index: index,
                            done: function () {
                                refresh();
                            },
                        });
                    });
                },
            };
        // 监听工具条
        table.on('tool(table-list)', function (obj) {
            active[obj.event] && active[obj.event].call(this, obj);
        });
        // 监听工具栏
        table.on('toolbar(table-list)', function (obj) {
            active[obj.event] && active[obj.event].call(this, obj);
        });
        // 转到
        form.on('submit(submit-goto)', function (obj) {
            refresh(obj.field['goto']);
        });
        // 监听搜索
        form.on('submit(search)', function (obj) {
            let field = obj.field, cols = [];
            $.each(field, function (k, v) {
                let col = k.split('.')[0];
                if (v && col !== 'cols' && cols.indexOf(col) === -1) {
                    cols.push(col);
                } else {
                    delete field[k];
                }
            });
            field.cols = cols.join(',');
            if (!field.cols) {
                return location.reload();
            }
            field.path = data.path;
            //执行重载
            tabled.reload({where: field});
        });
        // 监听操作
        form.on('submit(submit-acts)', function (obj) {
            let checkData = table.checkStatus('table-list').data, // 得到选中的数据
                names = [];
            if (checkData.length === 0) {
                return layer.msg('请选择数据');
            }
            layui.each(checkData, function (k, v) {
                if (v.path !== undefined) {
                    names[k] = v.path;
                }
            });
            let field = obj.field;
            field.name = names.join();
            field.path = data.path;
            if (field.action === 'del') {
                layer.confirm('删除后不可恢复，确定批量删除吗？', function (index) {
                    main.request({
                        url: url + '/del',
                        data: field,
                        index: index,
                        done: function () {
                            refresh();
                        },
                    });
                });
            } else {
                main.request({
                    url: url + '/' + field.action,
                    data: field,
                    done: function () {
                        refresh();
                    },
                });
            }
            return false;
        });
        // 渲染路径
        renderPath();
        // 渲染
        pathElem.off('click').on('click', function () {
            pathElem.hide();
            $('input[name=goto]').attr('type', 'text').val(pathElem.attr('title'));
            form.render('input');
        });
        $('[data-event]').off('click').on('click', function () {
            let $this = $(this), event = $this.data('event');
            active[event] && active[event].call($this);
        });
        $('input[name=goto]').keydown(function (event) {
            if (event.keyCode === 13 && this.value) {
                $('[lay-filter=submit-goto]').click();
            }
        });
        $('input[name=search]').keydown(function (event) {
            if (event.keyCode === 13) {
                $('[lay-filter=search]').click();
            }
        });
    });
});