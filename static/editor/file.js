let aceEditor = {
    layerView: '',
    aceConfig: {},  //ace配置参数
    editor: null,
    pathArray: [],
    editorLength: 0,
    isAceView: true,
    aceActive: '',
    isResizing: false,
    menuPath: '', //当前文件目录根地址
    refreshConfig: {
        el: {}, // 需要重新获取的元素,为DOM对象
        path: '',// 需要获取的路径文件信息
        group: 1,// 当前列表层级，用来css固定结构
        isEmpty: true
    }, //刷新配置参数
    // 事件编辑器-方法，事件绑定
    eventEditor: function () {
        let othis = this,
            icon = '<span class="icon"><i class="layui-icon layui-icon-ok"></i></span>',
            aceContainerMenu = $('.ace_container_menu'),
            aceToolbarMenu = $('.ace_toolbar_menu'),
            aceCatalogueList = $('.ace_catalogue_list'),
            aceDirTools = $('.ace_dir_tools'),
            aceOverall = $('.ace_overall'),
            aceCatalogue = $('.ace_catalogue'),
            events = {
                init: function () {
                    $(window).resize(function () {
                        if (othis.ace_active !== undefined) othis.setEditorView();
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
                        aceToolbarMenu.hide();
                        $('.ace_container_editor .ace_editors').css('fontSize', othis.aceConfig['aceEditor'].fontSize + 'px');
                        $('.ace_toolbar_menu .menu-tabs,.ace_toolbar_menu .menu-encoding,.ace_toolbar_menu .menu-files').hide();
                    });
                    $('.ace_editor_main').on('click', function () {
                        aceToolbarMenu.hide();
                    });
                    aceToolbarMenu.on('click', function (e) {
                        e.stopPropagation();
                        e.preventDefault();
                    });
                    $(window).keyup(function (e) {
                        if (e.keyCode === 116 && $('#ace_container').length === 1) {
                            layer.msg('编辑器模式下无法刷新网页，请关闭后重试');
                        }
                    });
                },
                pullDown: function () {
                    if (this.find('i').hasClass('layui-icon-down')) {
                        $('.ace_header').css({'top': '-35px'});
                        aceOverall.css({'top': '0'});
                        this.css({'top': '35px', 'height': '40px', 'line-height': '40px'});
                        this.find('i').addClass('layui-icon-up').removeClass('layui-icon-down');
                    } else {
                        $('.ace_header').css({'top': '0'});
                        aceOverall.css({'top': '35px'});
                        this.removeAttr('style');
                        this.find('i').addClass('layui-icon-down').removeClass('layui-icon-up');
                    }
                    othis.setEditorView();
                },
                foldX: function () {
                    if (aceOverall.hasClass('active')) {
                        aceOverall.removeClass('active');
                        aceCatalogue.css('left', '0');
                        this.removeClass('active').attr('title', '隐藏文件目录');
                        $('.ace_editor_main').css('marginLeft', aceCatalogue.width());
                    } else {
                        aceOverall.addClass('active');
                        aceCatalogue.css('left', '-' + aceCatalogue.width() + 'px');
                        this.addClass('active').attr('title', '显示文件目录');
                        $('.ace_editor_main').css('marginLeft', 0);
                    }
                    setTimeout(function () {
                        if (othis.ace_active !== '') othis.editor[othis.ace_active].ace.resize();
                    }, 600);
                }
            };
        events.init();
        $('[data-event]').off('click').on('click', function () {
            let $this = $(this), event = $this.data('event');
            events[event] && events[event].call($this);
        });

        // 切换TAB视图
        aceContainerMenu.on('click', '.item', function () {
            let id = $(this).attr('data-id'), item = othis.editor[id];
            $('.item_tab_' + id).addClass('active').siblings().removeClass('active');
            $('#ace_editor_' + id).addClass('active').siblings().removeClass('active');
            othis.ace_active = id;
            othis.currentStatusBar(id);
            othis.isFileHistory(item);
        });
        // 移上TAB按钮变化，仅文件被修改后
        aceContainerMenu.on('mouseover', '.item .icon-tool', function () {
            let type = $(this).attr('data-file-state');
            if (type !== '0') {
                $(this).removeClass('glyphicon-exclamation-sign').addClass('glyphicon-remove');
            }
        });
        // 移出tab按钮变化，仅文件被修改后
        aceContainerMenu.on('mouseout', '.item .icon-tool', function () {
            let type = $(this).attr('data-file-state');
            if (type !== '0') {
                $(this).removeClass('glyphicon-remove').addClass('glyphicon-exclamation-sign');
            }
        });
        // 关闭编辑视图
        aceContainerMenu.on('click', '.item .icon-tool', function (e) {
            let $this = $(this),
                file_type = $this.attr('data-file-state'),
                file_title = $this.attr('data-title'),
                id = $this.parent().parent().attr('data-id');
            switch (file_type) {
                // 直接关闭
                case '0':
                    othis.removeEditor(id);
                    break;
                // 未保存
                case '1':
                    layer.open({
                        type: 1,
                        area: ['400px', '180px'],
                        title: '提示',
                        content: '<div class="ace-clear-form">\
							<div class="clear-icon"></div>\
							<div class="clear-title">是否保存对&nbsp<span class="size_ellipsis" style="max-width:150px;vertical-align: top;" title="' + file_title + '">' + file_title + '</span>&nbsp的更改？</div>\
							<div class="clear-tips">如果不保存，更改会丢失！</div>\
							<div class="ace-clear-btn" style="">\
								<button type="button" class="btn btn-sm btn-default" style="float:left" data-type="2">不保存文件</button>\
								<button type="button" class="btn btn-sm btn-default" style="margin-right:10px;" data-type="1">取消</button>\
								<button type="button" class="btn btn-sm btn-success" data-type="0">保存文件</button>\
							</div>\
						</div>',
                        success: function (layers, index) {
                            $('.ace-clear-btn .btn').on('click', function () {
                                let _type = $(this).attr('data-type'),
                                    _item = othis.editor[id];
                                switch (_type) {
                                    case '0': //保存文件
                                        othis.saveFileMethod(_item);
                                        break;
                                    case '1': //关闭视图
                                        layer.close(index);
                                        break;
                                    case '2': //取消保存
                                        othis.removeEditor(id);
                                        layer.close(index);
                                        break;
                                }
                            });
                        }
                    });
                    break;
            }
            aceToolbarMenu.hide();
            $('.ace_toolbar_menu .menu-tabs,.ace_toolbar_menu .menu-encoding,.ace_toolbar_menu .menu-files').hide();
            e.stopPropagation();
            e.preventDefault();
        });
        // 拖拽排序
        aceContainerMenu.dragsort({
            dragSelector: '.icon_file',
            itemSelector: 'li'
        });
        // 新建编辑器视图
        $('.ace_editor_add').on('click', function () {
            othis.addEditorView();
        });
        // 底部状态栏功能按钮
        $('.ace_container_toolbar .pull-right span').on('click', function (e) {
            let type = $(this).attr('data-type'),
                item = othis.editor[othis.ace_active];
            aceToolbarMenu.show();
            switch (type) {
                case 'cursor':
                    aceToolbarMenu.hide();
                    $('.ace_header .jumpLine').on('click',);
                    break;
                case 'history':
                    aceToolbarMenu.hide();
                    if (item.historys.length === 0) {
                        layer.msg('历史文件为空', {icon: 0});
                        return false;
                    }
                    othis.layer_view = layer.open({
                        type: 1,
                        area: '550px',
                        title: '文件历史版本[ ' + item.fileName + ' ]',
                        skin: 'history_layer',
                        content: '<div class="pd20">\
							<div class="divtable">\
								<table class="historys table table-hover">\
									<thead><tr><th>文件名</th><th>版本时间</th><th style="text-align:right;">操作</th></tr></thead>\
									<tbody></tbody>\
								</table>\
							</div>\
						</div>',
                        success: function (layeo, index) {
                            let _html = '';
                            for (let i = 0; i < item.historys.length; i++) {
                                _html += '<tr><td><span class="size_ellipsis" style="max-width:200px">' + item.fileName + '</span></td><td>' + bt.format_data(item.historys[i]) + '</td><td align="right"><a href="javascript:;" class="btlink open_history_file" data-time="' + item.historys[i] + '">打开文件</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="javascript:;" class="btlink recovery_file_historys" data-history="' + item.historys[i] + '" data-path="' + item.path + '">恢复</a></td></tr>'
                            }
                            if (_html === '') _html += '<tr><td colspan="3">当前文件无历史版本</td></tr>'
                            $('.historys tbody').html(_html);
                            $('.history_layer').css('top', ($(window).height() / 2) - ($('.history_layer').height() / 2) + 'px');
                            $('.open_history_file').on('click', function () {
                                let _history = $(this).attr('data-time');
                                othis.openHistoryEditorView({filename: item.path, history: _history}, function () {
                                    layer.close(index);
                                    $('.ace_container_tips').show();
                                    $('.ace_container_tips .tips').html('只读文件，文件为' + item.path + '，历史版本 [ ' + bt.format_data(new Number(_history)) + ' ]<a href="javascript:;" class="ml35 btlink" data-path="' + item.path + '" data-history="' + _history + '">点击恢复当前历史版本</a>');
                                });
                            });
                            $('.recovery_file_historys').on('click', function () {
                                othis.eventRecoverFile(this);
                            });
                        }
                    });
                    break;
                case 'tab':
                    $('.ace_toolbar_menu .menu-tabs').show().siblings().hide();
                    $('.tabsType').find(item.softTabs ? '[data-value="nbsp"]' : '[data-value="tabs"]').addClass('active').append(icon);
                    $('.tabsSize [data-value="' + item.tabSize + '"]').addClass('active').append(icon);
                    break;
                case 'encoding':
                    othis.getEncodingList(item.encoding);
                    $('.ace_toolbar_menu .menu-encoding').show().siblings().hide();
                    break;
                case 'lang':
                    aceToolbarMenu.hide();
                    layer.msg('暂不支持切换语言模式，敬请期待!', {icon: 6});
                    break;
            }
            e.stopPropagation();
            e.preventDefault();
        });
        // 隐藏目录
        $('.tips_fold_icon .glyphicon').on('click', function () {
            if ($(this).hasClass('glyphicon-menu-left')) {
                $('.ace_container_tips').css('right', '0');
                $('.tips_fold_icon').css('left', '0');
                $(this).removeClass('glyphicon-menu-left').addClass('glyphicon-menu-right');
            } else {
                $('.ace_container_tips').css('right', '-100%');
                $('.tips_fold_icon').css('left', '-25px');
                $(this).removeClass('glyphicon-menu-right').addClass('glyphicon-menu-left');
            }
        });
        // 设置换行符
        $('.menu-tabs').on('click', 'li', function (e) {
            let _val = $(this).attr('data-value'), _item = othis.editor[othis.ace_active];
            if ($(this).parent().hasClass('tabsType')) {
                _item.ace.getSession().setUseSoftTabs(_val === 'nbsp');
                _item.softTabs = _val === 'nbsp';
            } else {
                _item.ace.getSession().setTabSize(_val);
                _item.tabSize = _val;
            }
            $(this).siblings().removeClass('active').find('.icon').remove();
            $(this).addClass('active').append(icon);
            othis.currentStatusBar(_item.id);
            e.stopPropagation();
            e.preventDefault();
        });
        // 设置编码内容
        $('.menu-encoding').on('click', 'li', function (e) {
            let _item = othis.editor[othis.ace_active];
            layer.msg('设置文件编码：' + $(this).attr('data-value'));
            $('.ace_container_toolbar [data-type="encoding"]').html('编码：<i>' + $(this).attr('data-value') + '</i>');
            $(this).addClass('active').append(icon).siblings().removeClass('active').find('span').remove();
            _item.encoding = $(this).attr('data-value');
            othis.saveFileMethod(_item);
        });
        // 搜索内容键盘事件
        $('.menu-files .menu-input').keyup(function () {
            othis.searchRelevance($(this).val());
            if ($(this).val !== '') {
                $(this).next().show();
            } else {
                $(this).next().hide();
            }
        });
        // 清除搜索内容事件
        $('.menu-files .menu-container .fa').on('click', function () {
            $('.menu-files .menu-input').val('').next().hide();
            othis.searchRelevance();
        });
        // 顶部状态栏
        $('.ace_header>span').on('click', function (e) {
            let type = $(this).attr('class'), _item = othis.editor[othis.ace_active];
            if (othis.ace_active === '' && type !== 'helps') {
                return false;
            }
            switch (type) {
                case 'saveFile': //保存当时文件
                    othis.saveFileMethod(_item);
                    break;
                case 'saveFileAll': //保存全部
                    loadT = layer.open({
                        type: 1,
                        area: ['350px', '180px'],
                        title: '提示',
                        content: '<div class="ace-clear-form">\
							<div class="clear-icon"></div>\
							<div class="clear-title">是否保存对全部文件的更改？</div>\
							<div class="clear-tips">如果不保存，更改会丢失！</div>\
							<div class="ace-clear-btn" style="">\
								<button type="button" class="btn btn-sm btn-default clear-btn" style="margin-right:10px;" >取消</button>\
								<button type="button" class="btn btn-sm btn-success save-all-btn">保存文件</button>\
							</div>\
						</div>',
                        success: function (layers, index) {
                            $('.clear-btn').on('click', function () {
                                layer.close(index);
                            });
                            $('.save-all-btn').on('click', function () {
                                let _arry = [], editor = aceEditor['editor'];
                                for (let item in editor) {
                                    _arry.push({
                                        path: editor[item]['path'],
                                        data: editor[item]['ace'].getValue(),
                                        encoding: editor[item]['encoding'],
                                    })
                                }
                                othis.saveAllFileBody(_arry, function () {
                                    $('.ace_container_menu>.item').each(function (el, index) {
                                        $(this).find('i').attr('data-file-state', '0').removeClass('glyphicon-exclamation-sign').addClass('glyphicon-remove');
                                        _item.fileType = 0;
                                    });
                                    layer.close(index);
                                });
                            });
                        }
                    });
                    break;
                case 'refresh': //刷新文件
                    if (_item.fileType === 0) {
                        aceEditor.getFileBody({path: _item.path}, function (res) {
                            _item.ace.setValue(res.data);
                            _item.fileType = 0;
                            $('.item_tab_' + _item.id + ' .icon-tool').attr('data-file-state', '0').removeClass('glyphicon-exclamation-sign').addClass('glyphicon-remove');
                            layer.msg('刷新成功', {icon: 1});
                        });
                        return false;
                    }
                    let loadT = layer.open({
                        type: 1,
                        area: ['350px', '180px'],
                        title: '提示',
                        content: '<div class="ace-clear-form">\
							<div class="clear-icon"></div>\
							<div class="clear-title">是否刷新当前文件</div>\
							<div class="clear-tips">刷新当前文件会覆盖当前修改,是否继续！</div>\
							<div class="ace-clear-btn" style="">\
								<button type="button" class="btn btn-sm btn-default clear-btn" style="margin-right:10px;" >取消</button>\
								<button type="button" class="btn btn-sm btn-success save-all-btn">确定</button>\
							</div>\
						</div>',
                        success: function (layers, index) {
                            $('.clear-btn').on('click', function () {
                                layer.close(index);
                            });
                            $('.save-all-btn').on('click', function () {
                                aceEditor.getFileBody({path: _item.path}, function (res) {
                                    layer.close(index);
                                    _item.ace.setValue(res.data);
                                    _item.fileType === 0;
                                    $('.item_tab_' + _item.id + ' .icon-tool').attr('data-file-state', '0').removeClass('glyphicon-exclamation-sign').addClass('glyphicon-remove');
                                    layer.msg('刷新成功', {icon: 1});
                                });
                            });
                        }
                    });
                    break;
                // 搜索
                case 'search':
                    _item.ace.execCommand('find');
                    break;
                // 替换
                case 'replaces':
                    _item.ace.execCommand('replace');
                    break;
                // 跳转行
                case 'jumpLine':
                    aceToolbarMenu.show().find('.menu-jumpLine').show().siblings().hide();
                    $('.set_jump_line input').val('').focus();
                    let _cursor = aceEditor.editor[aceEditor.aceActive].ace.selection.getCursor();
                    $('.set_jump_line .jump_tips span:eq(0)').text(_cursor.row);
                    $('.set_jump_line .jump_tips span:eq(1)').text(_cursor.column);
                    $('.set_jump_line .jump_tips span:eq(2)').text(aceEditor.editor[aceEditor.aceActive].ace.session.getLength());
                    $('.set_jump_line input').unbind('keyup').on('keyup', function (e) {
                        let _val = $(this).val();
                        if ((e.keyCode >= 48 && e.keyCode <= 57) || (e.keyCode >= 96 && e.keyCode <= 105)) {
                            if (_val !== '' && typeof parseInt(_val) === 'number') {
                                _item.ace.gotoLine(_val);
                            }
                            ;
                        }
                    });
                    break;
                // 字体
                case 'fontSize':
                    aceToolbarMenu.show().find('.menu-fontSize').show().siblings().hide();
                    $('.menu-fontSize .set_font_size input').val(othis.aceConfig.aceEditor.fontSize).focus();
                    $('.menu-fontSize set_font_size input').unbind('keypress onkeydown').on('keypress onkeydown', function (e) {
                        let _val = $(this).val();
                        if (_val === '') {
                            $(this).css('border', '1px solid red');
                            $(this).next('.tips').text('字体设置范围 12-45');
                        } else if (!isNaN(_val)) {
                            $(this).removeAttr('style');
                            if (parseInt(_val) > 11 && parseInt(_val) < 45) {
                                $('.ace_container_editor .ace_editors').css('fontSize', _val + 'px')
                            } else {
                                $('.ace_container_editor .ace_editors').css('fontSize', '13px');
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
                    $('.menu-fontSize .menu-container .set_font_size input').unbind('change').change(function () {
                        let _val = $(this).val();
                        $('.ace_container_editor .ace_editors').css('fontSize', _val + 'px');
                    });
                    $('.set_font_size .btn-save').unbind('click').on('click', function () {
                        let _fontSize = $('.set_font_size input').val();
                        othis.aceConfig.aceEditor.fontSize = parseInt(_fontSize);
                        othis.saveAceConfig(othis.aceConfig, function (res) {
                            if (res.status) {
                                $('.ace_editors').css('fontSize', _fontSize + 'px');
                                layer.msg('设置成功', {icon: 1});
                            }
                        });
                    });
                    break;
                //主题
                case 'themes':
                    aceToolbarMenu.show().find('.menu-themes').show().siblings().hide();
                    let _html = '', _arry = ['白色主题', '黑色主题'];
                    for (let i = 0; i < othis.aceConfig.themeList.length; i++) {
                        if (othis.aceConfig.themeList[i] !== othis.aceConfig.aceEditor.editorTheme) {
                            _html += '<li data-value="' + othis.aceConfig.themeList[i] + '">' + othis.aceConfig.themeList[i] + '【' + _arry[i] + '】</li>';
                        } else {
                            _html += '<li data-value="' + othis.aceConfig.themeList[i] + '" class="active">' + othis.aceConfig.themeList[i] + '【' + _arry[i] + '】' + icon + '</li>';
                        }
                    }
                    $('.menu-themes ul').html(_html);
                    $('.menu-themes ul li').on('click', function () {
                        let _theme = $(this).attr('data-value');
                        $(this).addClass('active').append(icon).siblings().removeClass('active').find('.icon').remove();
                        othis.aceConfig.aceEditor.editorTheme = _theme;
                        othis.saveAceConfig(othis.aceConfig, function (res) {
                            for (let item in othis.editor) {
                                othis.editor[item].ace.setTheme("ace/theme/" + _theme);
                            }
                            layer.msg('设置成功', {icon: 1});
                        });
                    });
                    break;
                case 'setUp':
                    aceToolbarMenu.show().find('.menu-setUp').show().siblings().hide();
                    $('.menu-setUp .editor_menu li').each(function (index, el) {
                        let _type = othis.aceConfig.aceEditor[$(el).attr('data-type')];
                        if (_type) $(el).addClass('active').append(icon);
                    })
                    $('.menu-setUp .editor_menu li').unbind('click').on('click', function () {
                        let _type = $(this).attr('data-type');
                        othis.aceConfig.aceEditor[_type] = !$(this).hasClass('active');
                        if ($(this).hasClass('active')) {
                            $(this).removeClass('active').find('.icon').remove();
                        } else {
                            $(this).addClass('active').append(icon);
                        }
                        othis.saveAceConfig(othis.aceConfig, function (res) {
                            for (let item in othis.editor) {
                                othis.editor[item].ace.setOption(_type, othis.aceConfig.aceEditor[_type]);
                            }
                            layer.msg('设置成功', {icon: 1});
                        });
                    });
                    break;
                case 'helps':
                    if (!$('[data-type=shortcutKeys]').length !== 0) {
                        othis.addEditorView(1, {title: '快捷键提示', html: aceShortcutKeys.innerHTML});
                    } else {
                        $('[data-type=shortcutKeys]').on('click',);
                    }
                    break;
            }

            e.stopPropagation();
            e.preventDefault();
        });

        // 文件目录选择
        aceCatalogueList.on('click', '.has-children .file_fold', function (e) {
            let _layers = $(this).attr('data-layer'), _type = $(this).find('data-type'),
                _path = $(this).parent().attr('data-menu-path'), _menu = $(this).find('.glyphicon'),
                _group = parseInt($(this).attr('data-group')), _file = $(this).attr('data-file'), _tath = $(this);
            let _active = $('.ace_catalogue_list .has-children .file_fold.edit_file_group');
            if (_active.length > 0 && $(this).attr('data-edit') === undefined) {
                switch (_active.attr('data-edit')) {
                    case '2':
                        _active.find('.file_input').siblings().show();
                        _active.find('.file_input').remove();
                        _active.removeClass('edit_file_group').removeAttr('data-edit');
                        break;
                    case '1':
                    case '0':
                        _active.parent().remove();
                        break;
                }
                layer.closeAll('tips');
            }
            aceToolbarMenu.hide();
            $('.ace_toolbar_menu .menu-tabs,.ace_toolbar_menu .menu-encoding,.ace_toolbar_menu .menu-files').hide();
            if ($(this).hasClass('edit_file_group')) return false;
            $('.ace_catalogue_list .has-children .file_fold').removeClass('bg');
            $(this).addClass('bg');
            if ($(this).attr('data-file') === 'Dir') {
                if (_menu.hasClass('glyphicon-menu-right')) {
                    _menu.removeClass('glyphicon-menu-right').addClass('glyphicon-menu-down');
                    $(this).next().show();
                    if ($(this).next().find('li').length === 0) othis.readerFileDirMenu({
                        el: $(this).next(),
                        path: _path,
                        group: _group + 1
                    });
                } else {
                    _menu.removeClass('glyphicon-menu-down').addClass('glyphicon-menu-right');
                    $(this).next().hide();
                }
            } else {
                othis.openEditorView(_path, function (res) {
                    if (res.status) _tath.addClass('active');
                });
            }
            e.stopPropagation();
            e.preventDefault();
        });
        // 禁用目录选择（文件目录）
        aceCatalogue.bind("selectstart", function (e) {
            console.log(e.target.tagName.toLowerCase());
            let omitFormTags = ["input", "textarea"];
            omitFormTags = "|" + omitFormTags.join("|") + "|";
            return omitFormTags.indexOf("|" + e.target.tagName.toLowerCase() + "|") !== -1;
        });
        // 返回目录（文件目录主菜单）
        aceDirTools.on('click', '.upper_level', function () {
            let _paths = $(this).attr('data-menu-path');
            othis.readerFileDirMenu({path: _paths, is_empty: true});
            $('.ace_catalogue_title').html('目录：' + _paths).attr('title', _paths);
        });
        // 新建文件（文件目录主菜单）
        aceDirTools.on('click', '.new_folder', function (e) {
            let _paths = $(this).parent().find('.upper_level').attr('data-menu-path');
            $(this).find('.folder_down_up').show();
            $(document).on('click', function () {
                $('.folder_down_up').hide();
                $(this).unbind('click');
                return false;
            });
            aceToolbarMenu.hide();
            $('.ace_catalogue_menu').hide();
            $('.ace_toolbar_menu .menu-tabs,.ace_toolbar_menu .menu-encoding,.ace_toolbar_menu .menu-files').hide();
            e.stopPropagation();
            e.preventDefault();
        });
        // 刷新列表 (文件目录主菜单)
        aceDirTools.on('click', '.refresh_dir', function (e) {
            othis.refresh_config = {
                el: $('.cd-accordion-menu')[0],
                path: $('.ace_catalogue_title').attr('title'),
                group: 1,
                is_empty: true
            }
            othis.readerFileDirMenu(othis.refreshConfig, function () {
                layer.msg('刷新成功', {icon: 1});
            });
        });
        // 搜索内容 (文件目录主菜单)
        aceDirTools.on('click', '.search_file', function (e) {
            if ($(this).parent().find('.search_input_view').length === 0) {
                $(this).siblings('div').hide();
                $(this).css('color', '#ec4545').attr({'title': '关闭'}).find('.glyphicon').removeClass('glyphicon-search').addClass('glyphicon-remove').next().text("关闭");
                $(this).before('<div class="search_input_title">搜索目录文件</div>');
                $(this).after('<div class="search_input_view">\
					<form>\
                        <input type="text" id="search_input_val" class="ser-text pull-left" placeholder="">\
                        <button type="button" class="ser-sub pull-left"></button>\
                    </form>\
                    <div class="search_boxs">\
                        <input id="search_alls" type="checkbox">\
                        <label for="search_alls"><span>包含子目录文件</span></label>\
                    </div>\
                </div>');
                aceCatalogueList.css('top', '150px');
                aceDirTools.css('height', '110px');
                $('.cd-accordion-menu').empty();
            } else {
                $(this).siblings('div').show();
                $(this).parent().find('.search_input_view,.search_input_title').remove();
                $(this).removeAttr('style').attr({'title': '搜索内容'}).find('.glyphicon').removeClass('glyphicon-remove').addClass('glyphicon-search').next().text("搜索");
                aceCatalogueList.removeAttr('style');
                aceDirTools.removeAttr('style');
                othis.refresh_config = {
                    el: $('.cd-accordion-menu')[0],
                    path: $('.ace_catalogue_title').attr('title'),
                    group: 1,
                    is_empty: true
                }
                othis.readerFileDirMenu(othis.refreshConfig);
            }
        });

        // 搜索文件内容
        aceDirTools.on('click', '.search_input_view button', function (e) {
            let path = othis.menuPath,
                search = $('#search_input_val').val();
            othis.readerFileDirMenu({
                el: $('.cd-accordion-menu')[0],
                path: path,
                group: 1,
                search: search,
                all: $('#search_alls').is(':checked') ? 'True' : 'False',
                is_empty: true
            })
        });

        // 当前根目录操作，新建文件或目录
        aceDirTools.on('click', '.folder_down_up li', function (e) {
            let _type = parseInt($(this).attr('data-type')), element = $('.cd-accordion-menu'), group = 0, type = 'Dir';
            if ($('.file_fold.bg').length > 0 && $('.file_fold.bg').data('file') !== 'files') {
                element = $('.file_fold.bg');
                group = parseInt(element.data('group'));
                type = element.data('file');
                if (type === 'Files' && group !== 0) {
                    if (group === 1) {
                        element = element.parent().parent()
                    } else {
                        element = element.parent().parent().prev()
                    }
                    group = group - 1;
                }
            }
            console.log(element)
            switch (_type) {
                case 2:
                    othis.newFileTypeDom(element, group, 0);
                    break;
                case 3:
                    othis.newFileTypeDom(element, group, 1);
                    break;
            }
            othis.refresh_config = {
                el: $('.cd-accordion-menu')[0],
                path: $('.ace_catalogue_title').attr('title'),
                group: 1,
                is_empty: true
            };
            $(this).parent().hide();
            aceToolbarMenu.hide();
            $('.ace_toolbar_menu .menu-tabs,.ace_toolbar_menu .menu-encoding,.ace_toolbar_menu .menu-files').hide();
            e.preventDefault();
            e.stopPropagation();
        });
        // 移动编辑器文件目录
        $('.ace_catalogue_drag_icon .drag_icon_container').on('mousedown', function (e) {
            let _left = $('.aceEditors')[0].offsetLeft;
            $('.ace_gutter-layer').css('cursor', 'col-resize');
            $('#ace_container').unbind().on('mousemove', function (ev) {
                let _width = (ev.clientX + 1) - _left;
                if (_width >= 265 && _width <= 450) {
                    aceCatalogue.css({'width': _width, 'transition': 'none'});
                    $('.ace_editor_main').css({'marginLeft': _width, 'transition': 'none'});
                    $('.ace_catalogue_drag_icon ').css('left', _width);
                    $('.file_fold .newly_file_input').width($('.file_fold .newly_file_input').parent().parent().parent().width() - ($('.file_fold .newly_file_input').parent().parent().attr('data-group') * 15 - 5) - 20 - 30 - 53);
                }
            }).on('mouseup', function (ev) {
                $('.ace_gutter-layer').css('cursor', 'inherit');
                aceCatalogue.css('transition', 'all 500ms');
                $('.ace_editor_main').css('transition', 'all 500ms');
                $(this).unbind('mouseup mousemove');
            });
        });

        // 恢复历史文件
        $('.ace_container_tips').on('click', 'a', function () {
            othis.eventRecoverFile(this);
        });
        // 右键菜单
        aceCatalogueList.on('mousedown', '.has-children .file_fold', function (e) {
            let x = e.clientX, y = e.clientY, _left = $('.aceEditors')[0].offsetLeft,
                _top = $('.aceEditors')[0].offsetTop, _that = $('.ace_catalogue_list .has-children .file_fold'),
                _active = $('.ace_catalogue_list .has-children .file_fold.edit_file_group');
            aceToolbarMenu.hide();
            if (e.which === 3) {
                if ($(this).hasClass('edit_file_group')) return false;
                $('.ace_catalogue_menu').css({'display': 'block', 'left': x - _left, 'top': y - _top});
                _that.removeClass('bg');
                $(this).addClass('bg');
                _active.attr('data-edit') !== '2' ? _active.parent().remove() : '';
                _that.removeClass('edit_file_group').removeAttr('data-edit');
                _that.find('.file_input').siblings().show();
                _that.find('.file_input').remove();
                $('.ace_catalogue_menu li').show();
                if ($(this).attr('data-file') === 'Dir') {
                    $('.ace_catalogue_menu li:nth-child(6)').hide();
                } else {
                    $('.ace_catalogue_menu li:nth-child(-n+4)').hide();
                }
                $(document).on('click', function () {
                    $('.ace_catalogue_menu').hide();
                    $(this).unbind('click');
                    return false;
                });
                othis.refresh_config = {
                    el: $(this).parent().parent()[0],
                    path: othis.getFileDir($(this).parent().attr('data-menu-path'), 1),
                    group: parseInt($(this).attr('data-group')),
                    is_empty: true
                }
            }
        });
        // 文件目录右键功能
        $('.ace_catalogue_menu li').on('click', function (e) {
            othis.newFileType(this);
        });
        // 新建、重命名鼠标事件
        aceCatalogueList.on('click', '.has-children .edit_file_group .glyphicon-ok', function () {
            let _file_or_dir = $(this).parent().find('input').val(),
                _file_type = $(this).parent().parent().attr('data-file'),
                _path = $('.has-children .file_fold.bg').parent().attr('data-menu-path'),
                _type = parseInt($(this).parent().parent().attr('data-edit'));
            if ($(this).parent().parent().parent().attr('data-menu-path') === undefined && parseInt($(this).parent().parent().attr('data-group')) === 1) {
                console.log('根目录')
                _path = $('.ace_catalogue_title').attr('title');
            }
            // 			return false;
            if (_file_or_dir === '') {
                $(this).prev().css('border', '1px solid #f34a4a');
                layer.tips(_type === 0 ? '文件目录不能为空' : (_type === 1 ? '文件名称不能空' : '新名称不能为空'), $(this).prev(), {
                    tips: [1, '#f34a4a'],
                    time: 0
                });
                return false;
            } else if ($(this).prev().attr('data-type') === 0) {
                return false;
            }
            switch (_type) {
                case 0: //新建文件夹
                    othis.eventCreateDir({path: _path + '/' + _file_or_dir});
                    break;
                case 1: //新建文件
                    othis.eventCreateFile({path: _path + '/' + _file_or_dir});
                    break;
                case 2: //重命名
                    othis.eventRenameCurrency({
                        sfile: _path,
                        dfile: othis.getFileDir(_path, 1) + '/' + _file_or_dir
                    });
                    break;
            }
        });
        // 新建、重命名键盘事件
        aceCatalogueList.on('keyup', '.has-children .edit_file_group input', function (e) {
            let _type = $(this).parent().parent().attr('data-edit'),
                _arry = $('.has-children .file_fold.bg+ul>li');
            if (_arry.length === 0 && $(this).parent().parent().attr('data-group') === 1) _arry = $('.cd-accordion-menu>li')
            if (_type !== 2) {
                for (let i = 0; i < _arry.length; i++) {
                    if ($(_arry[i]).find('.file_title span').html() === $(this).val()) {
                        $(this).css('border', '1px solid #f34a4a');
                        $(this).attr('data-type', 0);
                        layer.tips(_type === 0 ? '文件目录存在同名目录' : '文件名称存在同名文件', $(this)[0], {
                            tips: [1, '#f34a4a'],
                            time: 0
                        });
                        return false
                    }
                }
            }
            if (_type === 1 && $(this).val().indexOf('.')) $(this).prev().removeAttr('class').addClass(othis.getFileSuffix($(this).val()) + '-icon');
            $(this).attr('data-type', 1);
            $(this).css('border', '1px solid #528bff');
            layer.closeAll('tips');
            if (e.keyCode === 13) $(this).next().on('click',);
            aceToolbarMenu.hide();
            $('.ace_toolbar_menu .menu-tabs,.ace_toolbar_menu .menu-encoding,.ace_toolbar_menu .menu-files').hide();
            e.stopPropagation();
            e.preventDefault();
        });
        // 新建、重命名鼠标点击取消事件
        aceCatalogueList.on('click', '.has-children .edit_file_group .glyphicon-remove', function () {
            layer.closeAll('tips');
            if ($(this).parent().parent().parent().attr('data-menu-path')) {
                $(this).parent().parent().removeClass('edit_file_group').removeAttr('data-edit');
                $(this).parent().siblings().show();
                $(this).parent().remove();
                return false;
            }
            $(this).parent().parent().parent().remove();
        });
        //屏蔽浏览器右键菜单
        aceCatalogueList[0].oncontextmenu = function () {
            return false;
        };
        this.setEditorView();
        this.readerFileDirMenu();
    },
    // 	设置本地存储，设置类型type：session或local
    setStorage: function (type, key, val) {
        if (type !== 'local' && type !== 'session') val = key, key = type, type = 'session';
        window[type + 'Storage'].setItem(key, val);
    },
    //获取指定本地存储，设置类型type：session或local
    getStorage: function (type, key) {
        if (type !== 'local' && type !== 'session') key = type, type = 'session';
        return window[type + 'Storage'].getItem(key);
    },
    //删除指定本地存储，设置类型type：session或local
    removeStorage: function (type, key) {
        if (type !== "local" && type !== "session") key = type, type = 'session';
        window[type + 'Storage'].removeItem(key);
    },
    // 	删除指定类型的所有存储信息
    clearStorage: function (type) {
        if (type !== "local" && type !== "session") key = type, type = 'session';
        window[type + 'Storage'].clear();
    },
    // 新建文件类型
    newFileType: function (that) {
        let _type = parseInt($(that).attr('data-type')),
            _active = $('.ace_catalogue .ace_catalogue_list .has-children .file_fold.bg'),
            _group = parseInt(_active.attr('data-group')),
            _path = _active.parent().attr('data-menu-path'), //当前文件夹新建
            othis = this;
        console.log(_type);
        switch (_type) {
            case 0: //刷新目录
                _active.next().empty();
                othis.readerFileDirMenu({
                    el: _active.next(),
                    path: _path,
                    group: parseInt(_active.attr('data-group')) + 1,
                    is_empty: true
                }, function () {
                    layer.msg('刷新成功', {icon: 1});
                });
                break;
            case 1: //打开文件
                othis.menu_path = _path;
                othis.readerFileDirMenu({
                    el: '.cd-accordion-menu',
                    path: othis.menuPath,
                    group: 1,
                    is_empty: true
                });
                break;
            case 2: //新建文件
            case 3:
                if (this.getFileDir(_path, 1) !== this.menuPath) { //判断当前文件上级是否为显示根目录
                    this.readerFileDirMenu({el: _active, path: _path, group: _group + 1}, function (res) {
                        othis.newFileTypeDom(_active, _group, _type === 2 ? 0 : 1);
                    });
                } else {
                    othis.newFileTypeDom(_active, _group, _type === 2 ? 0 : 1);
                }
                break;
            case 4: //文件重命名
                let _types = _active.attr('data-file');
                if (_active.hasClass('active')) {
                    layer.msg('该文件已打开，无法修改名称', {icon: 0});
                    return false;
                }
                _active.attr('data-edit', 2);
                _active.addClass('edit_file_group');
                _active.find('.file_title').hide();
                _active.find('.glyphicon').hide();
                _active.prepend('<span class="file_input"><i class="' + (_types === 'Dir' ? 'folder' : (othis.getFileSuffix(_active.find('.file_title span').html()))) + '-icon"></i><input type="text" class="newly_file_input" value="' + (_active.find('.file_title span').html()) + '"><span class="glyphicon glyphicon-ok" aria-hidden="true"></span><span class="glyphicon glyphicon-remove" aria-hidden="true"></span>')
                $('.file_fold .newly_file_input').width($('.file_fold .newly_file_input').parent().parent().parent().width() - ($('.file_fold .newly_file_input').parent().parent().attr('data-group') * 15 - 5) - 20 - 30 - 53);
                $('.file_fold .newly_file_input').focus();
                break;
            case 5:
                window.open('/download?filename=' + encodeURIComponent(_path));
                break;
            case 6:
                let is_files = _active.attr('data-file') === 'Files'
                layer.confirm(lan.get(is_files ? 'recycle_bin_confirm' : 'recycle_bin_confirm_dir', [_active.find('.file_title span').html()]), {
                    title: is_files ? lan.files.del_file : lan.files.del_dir,
                    closeBtn: 2,
                    icon: 3
                }, function (index) {
                    othis[is_files ? 'del_file_req' : 'del_dir_req']({path: _path}, function (res) {
                        layer.msg(res.msg, {icon: res.status ? 1 : 2});
                        if (res.status) {
                            if (_active.attr('data-group') !== 1) _active.parent().parent().prev().addClass('bg')
                            othis.readerFileDirMenu(othis.refreshConfig, function () {
                                layer.msg(res.msg, {icon: 1});
                            });
                        }
                    });
                });
                break;
        }
    },
    // 新建文件和文件夹
    newFileTypeDom: function (_active, _group, _type, _val) {
        let _html = '', othis = this, _nextLength = _active.next(':not(.ace_catalogue_menu)').length;
        if (_nextLength > 0) {
            _active.next().show();
            _active.find('.glyphicon').removeClass('glyphicon-menu-right').addClass('glyphicon-menu-down');
        }
        _html += '<li class="has-children children_' + (_group + 1) + '"><div class="file_fold edit_file_group group_' + (_group + 1) + '" data-group="' + (_group + 1) + '" data-edit="' + _type + '"><span class="file_input">';
        _html += '<i class="' + (_type === 0 ? 'folder' : (_type === 1 ? 'text' : (othis.getFileSuffix(_val || '')))) + '-icon"></i>'
        _html += '<input type="text" class="newly_file_input" value="' + (_val !== undefined ? _val : '') + '">'
        _html += '<span class="glyphicon glyphicon-ok" aria-hidden="true"></span><span class="glyphicon glyphicon-remove" aria-hidden="true"></span></span></div></li>'
        if (_nextLength > 0) {
            _active.next().prepend(_html);
        } else {
            _active.prepend(_html);
        }
        setTimeout(function () {
            $('.newly_file_input').focus()
        }, 100)
        $('.file_fold .newly_file_input').width($('.file_fold .newly_file_input').parent().parent().parent().width() - ($('.file_fold .newly_file_input').parent().parent().attr('data-group') * 15 - 5) - 20 - 30 - 53);
        return false;
    },
    // 通用重命名事件
    eventRenameCurrency: function (obj) {
        let _active = $('.ace_catalogue_list .has-children .file_fold.edit_file_group'), othis = this;
        this.renameCurrencyReq({sfile: obj.sfile, dfile: obj.dfile}, function (res) {
            layer.msg(res.msg, {icon: res.status ? 1 : 2});
            if (res.status) {
                othis.readerFileDirMenu(othis.refreshConfig, function () {
                    layer.msg(res.msg, {icon: 1});
                });
            } else {
                _active.find('.file_input').siblings().show();
                _active.find('.file_input').remove();
                _active.removeClass('edit_file_group').removeAttr('data-edit');
            }
        })
    },
    // 创建文件目录事件
    eventCreateDir: function (obj) {
        let othis = this;
        this.createDirReq({path: obj.path}, function (res) {
            layer.msg(res.msg, {icon: res.status ? 1 : 2});
            if (res.status) {
                othis.readerFileDirMenu(othis.refreshConfig, function () {
                    layer.msg(res.msg, {icon: 1});
                });
            }
        })
    },
    // 创建文件事件
    eventCreateFile: function (obj) {
        let othis = this;
        this.createFileReq({path: obj.path}, function (res) {
            layer.msg(res.msg, {icon: res.status ? 1 : 2});
            if (res.status) {
                othis.readerFileDirMenu(othis.refreshConfig, function () {
                    layer.msg(res.msg, {icon: 1});
                    othis.openEditorView(obj.path);
                });
            }
        })
    },
    // 重命名请求
    renameCurrencyReq: function (obj, callback) {
        let loadT = layer.msg('正在重命名文件或目录，请稍后...', {time: 0, icon: 16, shade: [0.3, '#000']});
        $.post("/files?action=MvFile", {
            sfile: obj.sfile,
            dfile: obj.dfile,
            rename: 'true'
        }, function (res) {
            layer.close(loadT);
            if (callback) callback(res);
        });
    },
    // 创建文件事件
    createFileReq: function (obj, callback) {
        let loadT = layer.msg('正在新建文件，请稍后...', {time: 0, icon: 16, shade: [0.3, '#000']});
        $.post("/files?action=CreateFile", {
            path: obj.path
        }, function (res) {
            layer.close(loadT);
            if (callback) callback(res);
        });
    },
    // 创建目录请求
    createDirReq: function (obj, callback) {
        let loadT = layer.msg('正在新建目录，请稍后...', {time: 0, icon: 16, shade: [0.3, '#000']});
        $.post("/files?action=CreateDir", {
            path: obj.path
        }, function (res) {
            layer.close(loadT);
            if (callback) callback(res);
        });
    },
    // 删除文件请求
    delFileReq: function (obj, callback) {
        let loadT = layer.msg('正在删除文件，请稍后...', {time: 0, icon: 16, shade: [0.3, '#000']});
        $.post("/files?action=DeleteFile", {
            path: obj.path
        }, function (res) {
            layer.close(loadT);
            if (callback) callback(res);
        });
    },
    // 删除目录请求
    delDirReq: function (obj, callback) {
        let loadT = layer.msg('正在删除文件目录，请稍后...', {time: 0, icon: 16, shade: [0.3, '#000']});
        $.post("/files?action=DeleteDir", {
            path: obj.path
        }, function (res) {
            layer.close(loadT);
            if (callback) callback(res);
        });
    },
    // 临时文件保存
    autoSaveTemp: function (obj, callback) {
        // let loadT = layer.msg('正在新建目录，请稍后...',{time: 0,icon: 16,shade: [0.3, '#000']});
        $.post("/files?action=auto_save_temp", {
            filename: obj.filename,
            body: obj.body
        }, function (res) {
            layer.close(loadT);
            if (callback) callback(res);
        });
    },
    // 获取临时文件内容
    getAutoSaveBody: function (obj, callback) {
        let loadT = layer.msg('正在获取自动保存文件信息，请稍后...', {time: 0, icon: 16, shade: [0.3, '#000']});
        $.post("/files?action=get_auto_save_body", {
            filename: obj.filename
        }, function (res) {
            layer.close(loadT);
            if (callback) callback(res);
        });
    },
    // 恢复历史文件事件
    eventRecoverFile: function (that) {
        let _path = $(that).attr('data-path'), _history = new Number($(that).attr('data-history')), othis = this;
        let loadT = layer.open({
            type: 1,
            area: ['400px', '180px'],
            title: '恢复历史文件',
            content: '<div class="ace-clear-form">\
				<div class="clear-icon"></div>\
				<div class="clear-title">是否恢复历史文件&nbsp<span class="size_ellipsis" style="max-width:150px;vertical-align: top;" title="' + bt.format_data(_history) + '">' + bt.format_data(_history) + '</span>?</div>\
				<div class="clear-tips">恢复历史文件后，当前文件内容将会被替换！</div>\
				<div class="ace-clear-btn" style="">\
					<button type="button" class="btn btn-sm btn-default" style="margin-right:10px;" data-type="1">取消</button>\
					<button type="button" class="btn btn-sm btn-success" data-type="0">恢复历史文件</button>\
				</div>\
			</div>',
            success: function (layero, index) {
                $('.ace-clear-btn .btn').on('click', function () {
                    let _type = $(this).attr('data-type');
                    switch (_type) {
                        case '0':
                            othis.recoveryFileHistory({
                                filename: _path,
                                history: _history
                            }, function (res) {
                                layer.close(index);
                                layer.msg(res.status ? '恢复历史文件成功' : '恢复历史文件失败', {icon: res.status ? 1 : 2});
                                if (res.status) {
                                    if (othis.editor[othis.ace_active].historys_file) {
                                        othis.removeEditor(othis.ace_active);
                                    }
                                    if ($('.ace_container_menu>[title="' + _path + '"]').length > 0) {
                                        $('.ace_header .refreshs').on('click',);
                                        layer.close(othis.layerView);
                                    }
                                }
                            });
                            break;
                        case '1':
                            layer.close(index);
                            break;
                    }
                });
            }
        });
    },
    // 判断是否为历史文件
    isFileHistory: function (_item) {
        if (_item === undefined) return false;
        if (_item.historys_file) {
            $('.ace_container_tips').show();
            $('#ace_editor_' + _item.id).css('bottom', '50px');
            $('.ace_container_tips .tips').html('只读文件，文件为' + _item.path + '，历史版本 [ ' + bt.format_data(new Number(_item.historys_active)) + ' ]<a href="javascript:;" class="ml35 btlink" style="margin-left:35px" data-path="' + _item.path + '" data-history="' + _item.historys_active + '">点击恢复当前历史版本</a>');
        } else {
            $('.ace_container_tips').hide();
        }
    },
    // 判断文件是否打开
    isFileOpen: function (path, callback) {
        let is_state = false
        for (let i = 0; i < this.pathArray.length; i++) {
            if (path === this.pathArray[i]) is_state = true
        }
        if (callback) {
            callback(is_state);
        } else {
            return is_state;
        }
    },
    // 恢复文件历史
    recoveryFileHistory: function (obj, callback) {
        let loadT = layer.msg('正在恢复历史文件，请稍后...', {time: 0, icon: 16, shade: [0.3, '#000']});
        $.post("/files?action=re_history", {
            filename: obj.filename,
            history: obj.history
        }, function (res) {
            layer.close(loadT);
            if (callback) callback(res);
        });
    },
    // 获取文件列表
    getFileDirList: function (obj, callback) {
        let loadT = layer.msg('正在获取文件列表，请稍后...', {time: 0, icon: 16, shade: [0.3, '#000']}), othis = this;
        if (obj['p'] === undefined) obj['p'] = 1;
        if (obj['showRow'] === undefined) obj['showRow'] = 200;
        if (obj['sort'] === undefined) obj['sort'] = 'name';
        if (obj['reverse'] === undefined) obj['reverse'] = 'False';
        if (obj['search'] === undefined) obj['search'] = '';
        if (obj['all'] === undefined) obj['all'] = 'False';
        $.post("/files?action=GetDir&tojs=GetFiles", {
            p: obj.p,
            showRow: obj.showRow,
            sort: obj.sort,
            reverse: obj.reverse,
            path: obj.path,
            search: obj.search
        }, function (res) {
            layer.close(loadT);
            if (callback) callback(res);
        });
    },
    // 获取历史文件
    getFileHistory: function (obj, callback) {
        let loadT = layer.msg('正在获取历史文件内容，请稍后...', {time: 0, icon: 16, shade: [0.3, '#000']}), othis = this;
        $.post("/files?action=read_history", {filename: obj.filename, history: obj.history}, function (res) {
            layer.close(loadT);
            if (callback) callback(res);
        });
    },
    // 渲染文件列表
    readerFileDirMenu: function (obj, callback) {
        let _path = getCookie('Path'), othis = this;
        if (obj === undefined) obj = {}
        if (obj['el'] === undefined) obj['el'] = '.cd-accordion-menu';
        if (obj['group'] === undefined) obj['group'] = 1;
        if (obj['p'] === undefined) obj['p'] = 1;
        if (obj['path'] === undefined) obj['path'] = _path;
        if (obj['search'] === undefined) obj['search'] = '';
        if (obj['is_empty'] === undefined) obj['is_empty'] = false;
        if (obj['all'] === undefined) obj['all'] = 'False'
        this.getFileDirList({p: obj.p, path: obj.path, search: obj.search, all: obj.all}, function (res) {
            let _dir = res.DIR, _files = res.FILES, _dir_dom = '', _files_dom = '', _html = '';
            othis.menu_path = res.PATH;
            for (let i = 0; i < _dir.length; i++) {
                let _data = _dir[i].split(';');
                if (_data[0] === '__pycache__') continue;
                _dir_dom += '<li class="has-children children_' + obj.group + '" title="' + (obj.path + '/' + _data[0]) + '" data-menu-path="' + (obj.path + '/' + _data[0]) + '" data-size="' + (_data[1]) + '">\
					<div class="file_fold group_' + obj.group + '" data-group="' + obj.group + '" data-file="Dir">\
						<span class="glyphicon glyphicon-menu-right"></span>\
						<span class="file_title"><i class="folder-icon"></i><span>' + _data[0] + '</span></span>\
					</div>\
					<ul data-group=""></ul>\
					<span class="has_children_separator"></span>\
				</li>';
            }
            for (let j = 0; j < _files.length; j++) {
                let _data = _files[j].split(';');
                if (_data[0].indexOf('.pyc') !== -1) continue;
                _files_dom += '<li class="has-children" title="' + (obj.path + '/' + _data[0]) + '" data-menu-path="' + (obj.path + '/' + _data[0]) + '" data-size="' + (_data[1]) + '" data-suffix="' + othis.getFileSuffix(_data[0]) + '">\
					<div class="file_fold  group_' + obj.group + '" data-group="' + obj.group + '" data-file="Files">\
						<span class="file_title"><i class="' + othis.getFileSuffix(_data[0]) + '-icon"></i><span>' + _data[0] + '</span></span>\
					</div>\
				</li>';
            }
            if (res.PATH !== '/' && obj['group'] === 1) {
                $('.upper_level').attr('data-menu-path', othis.getFileDir(res.PATH, 1));
                $('.ace_catalogue_title').html('目录：' + res.PATH).attr('title', res.PATH);
                $('.upper_level').html('<i class="glyphicon glyphicon-share-alt" aria-hidden="true"></i>上一级')
            } else if (res.PATH === '/') {
                $('.upper_level').html('<i class="glyphicon glyphicon-hdd" aria-hidden="true"></i>根目录')
            }
            if (obj.is_empty) $(obj.el).empty();
            $(obj.el).append(_html + _dir_dom + _files_dom);
            if (callback) callback(res);
        });
    },
    // 获取文件目录位置
    getFileDir: function (path, num) {
        let _arry = path.split('/');
        if (path === '/') return '/';
        _arry.splice(-1, num);
        return _arry === '' ? '/' : _arry.join('/');
    },
    // 获取文件全称
    getFileSuffix: function (fileName) {
        let filenames = fileName.match(/\.([0-9A-z]*)$/);
        filenames = (filenames === null ? 'text' : filenames[1]);
        for (let name in this.aceConfig.supportedModes) {
            let data = this.aceConfig.supportedModes[name], suffixs = data[0].split('|'), filename = name.toLowerCase();
            for (let i = 0; i < suffixs.length; i++) {
                if (filenames === suffixs[i]) return filename;
            }
        }
        return 'text';
    },
    // 设置编辑器视图
    setEditorView: function () {
        let aceEditorHeight = $('.aceEditors').height(), othis = this;
        let autoAceHeight = setInterval(function () {
            let page_height = $('.aceEditors').height();
            let ace_container_menu = $('.ace_container_menu').height();
            let ace_container_toolbar = $('.ace_container_toolbar').height();
            let _height = page_height - ($('.pull-down .glyphicon').hasClass('glyphicon-menu-down') ? 35 : 0) - ace_container_menu - ace_container_toolbar - 42;
            $('.ace_container_editor').height(_height);
            if (aceEditorHeight === $('.aceEditors').height()) {
                if (othis.ace_active) othis.editor[othis.ace_active].ace.resize();
                clearInterval(autoAceHeight);
            } else {
                aceEditorHeight = $('.aceEditors').height();
            }
        }, 200);
    },
    // 获取文件编码列表
    getEncodingList: function (type) {
        let _option = '';
        for (let i = 0; i < this.aceConfig.encodingList.length; i++) {
            let item = this.aceConfig.encodingList[i] === type.toUpperCase();
            _option += '<li data- data-value="' + this.aceConfig.encodingList[i] + '" ' + (item ? 'class="active"' : '') + '>' + this.aceConfig.encodingList[i] + (item ? '<span class="icon"><i class="glyphicon glyphicon-ok" aria-hidden="true"></i></span>' : '') + '</li>';
        }
        $('.menu-encoding ul').html(_option);
    },
    // 获取文件关联列表
    getRelevanceList: function (fileName) {
        let _option = '', _top = 0, fileType = this.getFileType(fileName), _set_tops = 0;
        for (let name in this.aceConfig.supportedModes) {
            let data = this.aceConfig.supportedModes[name], item = (name === fileType.name);
            _option += '<li data-height="' + _top + '" data-rule="' + this.aceConfig.supportedModes[name] + '" data-value="' + name + '" ' + (item ? 'class="active"' : '') + '>' + (this.aceConfig.nameOverrides[name] || name) + (item ? '<span class="icon"><i class="glyphicon glyphicon-ok" aria-hidden="true"></i></span>' : '') + '</li>'
            if (item) _set_tops = _top
            _top += 35;
        }
        $('.menu-files ul').html(_option);
        $('.menu-files ul').scrollTop(_set_tops);
    },
    // 搜索文件关联
    searchRelevance: function (search) {
        if (search === undefined) search = '';
        $('.menu-files ul li').each(function (index, el) {
            let val = $(this).attr('data-value').toLowerCase(),
                rule = $(this).attr('data-rule'),
                suffixs = rule.split('|'),
                _suffixs = false;
            search = search.toLowerCase();
            for (let i = 0; i < suffixs.length; i++) {
                if (suffixs[i].indexOf(search) > -1) _suffixs = true
            }
            if (search === '') {
                $(this).removeAttr('style');
            } else {
                if (val.indexOf(search) === -1) {
                    $(this).attr('style', 'display:none');
                } else {
                    $(this).removeAttr('style');
                }
                if (_suffixs) $(this).removeAttr('style')
            }
        });
    },
    // 设置编码类型
    setEncodingType: function (encode) {
        this.getEncodingList('UTF-8');
        $('.menu-encoding ul li').on('click', function (e) {
            layer.msg('设置文件编码：' + $(this).attr('data-value'));
            $(this).addClass('active').append('<span class="icon"><i class="glyphicon glyphicon-ok" aria-hidden="true"></i></span>').siblings().removeClass('active').find('span').remove();
        });
    },
    // 更新状态栏
    currentStatusBar: function (id) {
        let _item = this.editor[id];
        if (_item === undefined) {
            this.removerStatusBar();
            return false;
        }
        $('.ace_container_toolbar [data-type="cursor"]').html('行<i class="cursor-row">1</i>,列<i class="cursor-line">0</i>');
        $('.ace_container_toolbar [data-type="history"]').html('历史版本：<i>' + (_item.historys.length === 0 ? '无' : _item.historys.length + '份') + '</i>');
        $('.ace_container_toolbar [data-type="path"]').html('文件位置：<i title="' + _item.path + '">' + _item.path + '</i>');
        $('.ace_container_toolbar [data-type="tab"]').html(_item.softTabs ? '空格：<i>' + _item.tabSize + '</i>' : '制表符长度：<i>' + _item.tabSize + '</i>');
        $('.ace_container_toolbar [data-type="encoding"]').html('编码：<i>' + _item.encoding.toUpperCase() + '</i>');
        $('.ace_container_toolbar [data-type="lang"]').html('语言：<i>' + _item.type + '</i>');
        $('.ace_container_toolbar span').attr('data-id', id);
        $('.file_fold').removeClass('bg');
        $('[data-menu-path="' + (_item.path) + '"]').find('.file_fold').addClass('bg');
        if (_item.historys_file) {
            $('.ace_container_toolbar [data-type="history"]').hide();
        } else {
            $('.ace_container_toolbar [data-type="history"]').show();
        }
        _item.ace.resize();
    },
    // 清除状态栏
    removerStatusBar: function () {
        $('.ace_container_toolbar [data-type="history"]').html('');
        $('.ace_container_toolbar [data-type="path"]').html('');
        $('.ace_container_toolbar [data-type="tab"]').html('');
        $('.ace_container_toolbar [data-type="cursor"]').html('');
        $('.ace_container_toolbar [data-type="encoding"]').html('');
        $('.ace_container_toolbar [data-type="lang"]').html('');
    },
    // 创建ACE编辑器-对象
    creationEditor: function (obj, callabck) {
        let othis = this;
        $('#ace_editor_' + obj.id).text(obj.data || '');
        $('.ace_container_editor .ace_editors').css('fontSize', othis.fontSize + 'px');
        if (this.editor === null) this.editor = {};
        this.editor[obj.id] = {
            ace: ace.edit("ace_editor_" + obj.id, {
                theme: "ace/theme/" + othis.aceConfig.aceEditor.editorTheme, //主题
                mode: "ace/mode/" + (obj.fileName !== undefined ? obj.mode : 'text'), // 语言类型
                wrap: othis.aceConfig.aceEditor.wrap,
                showInvisibles: othis.aceConfig.aceEditor.showInvisibles,
                showPrintMargin: false,
                enableBasicAutocompletion: true,
                enableSnippets: othis.aceConfig.aceEditor.enableSnippets,
                enableLiveAutocompletion: othis.aceConfig.aceEditor.enableLiveAutocompletion,
                useSoftTabs: othis.aceConfig.aceEditor.useSoftTabs,
                tabSize: othis.aceConfig.aceEditor.tabSize,
                keyboardHandler: 'sublime',
                readOnly: obj.readOnly === undefined ? false : obj.readOnly
            }), //ACE编辑器对象
            id: obj.id,
            wrap: othis.aceConfig.aceEditor.wrap, //是否换行
            path: obj.path,
            tabSize: othis.aceConfig.aceEditor.tabSize,
            softTabs: othis.aceConfig.aceEditor.useSoftTabs,
            fileName: obj.fileName,
            enableSnippets: true, //是否代码提示
            encoding: (obj.encoding !== undefined ? obj.encoding : 'utf-8'), //编码类型
            mode: (obj.fileName !== undefined ? obj.mode : 'text'), //语言类型
            type: obj.type,
            fileType: 0, //文件状态
            historys: obj.historys,
            historys_file: obj.historys_file === undefined ? false : obj.historys_file,
            historys_active: obj.historys_active === '' ? false : obj.historys_active
        };
        let ACE = this.editor[obj.id];
        ACE.ace.moveCursorTo(0, 0); //设置鼠标焦点
        ACE.ace.focus();//设置焦点
        ACE.ace.resize(); //设置自适应
        ACE.ace.commands.addCommand({
            name: '保存文件',
            bindKey: {
                win: 'Ctrl-S',
                mac: 'Command-S'
            },
            exec: function (editor) {
                othis.saveFileMethod(ACE);
            },
            readOnly: false // 如果不需要使用只读模式，这里设置false
        });
        ACE.ace.commands.addCommand({
            name: '跳转行',
            bindKey: {
                win: 'Ctrl-I',
                mac: 'Command-I'
            },
            exec: function (editor) {
                $('.ace_header .jumpLine').on('click',);
            },
            readOnly: false // 如果不需要使用只读模式，这里设置false
        });
        // 获取光标位置
        ACE.ace.getSession().selection.on('changeCursor', function (e) {
            let _cursor = ACE.ace.selection.getCursor();
            $('[data-type="cursor"]').html('行<i class="cursor-row">' + (_cursor.row + 1) + '</i>,列<i class="cursor-line">' + _cursor.column + '</i>');
        });

        // 触发修改内容
        ACE.ace.getSession().on('change', function (editor) {
            $('.item_tab_' + ACE.id + ' .icon-tool').addClass('glyphicon-exclamation-sign').removeClass('glyphicon-remove').attr('data-file-state', '1');
            ACE.fileType = 1;
            toolbarMenuElem.hide();
        });
        this.currentStatusBar(ACE.id);
        this.isFileHistory(ACE);
    },
    // 保存文件方法
    saveFileMethod: function (ACE) {
        if ($('.item_tab_' + ACE.id + ' .icon-tool').attr('data-file-state') === 0) {
            layer.msg('当前文件未修改，无需保存!');
            return false;
        }
        $('.item_tab_' + ACE.id + ' .icon-tool').attr('title', '保存文件中，请稍后..').removeClass('glyphicon-exclamation-sign').addClass('glyphicon-repeat');
        layer.msg('保存文件中，请稍后<img src="/static/img/ns-loading.gif" style="width:15px;margin-left:5px">', {icon: 0});
        this.saveFileBody({
            path: ACE.path,
            data: ACE.ace.getValue(),
            encoding: ACE.encoding
        }, function (res) {
            ACE.fileType = 0;
            $('.item_tab_' + ACE.id + ' .icon-tool').attr('data-file-state', '0').removeClass('glyphicon-repeat').addClass('glyphicon-remove');
        }, function (res) {
            ACE.fileType = 1;
            $('.item_tab_' + ACE.id + ' .icon-tool').attr('data-file-state', '1').removeClass('glyphicon-remove').addClass('glyphicon-repeat');
        });
    },
    // 获取文件模型
    getFileType: function (fileName) {
        let filenames = fileName.match(/\.([0-9A-z]*)$/);
        filenames = (filenames === null ? 'text' : filenames[1]);
        for (let name in this.aceConfig.supportedModes) {
            let data = this.aceConfig.supportedModes[name], suffixs = data[0].split('|'), filename = name.toLowerCase();
            for (let i = 0; i < suffixs.length; i++) {
                if (filenames === suffixs[i]) {
                    return {name: name, mode: filename};
                }
            }
        }
        return {name: 'Text', mode: 'text'};
    },
    // 新建编辑器视图-方法
    addEditorView: function (type, conifg) {
        if (type === undefined) type = 0
        let _index = this.editorLength, _id = bt.get_random(8);
        $('.ace_container_menu .item').removeClass('active');
        $('.ace_container_editor .ace_editors').removeClass('active');
        $('.ace_container_menu').append('<li class="item active item_tab_' + _id + '" data-type="shortcutKeys" data-id="' + _id + '" >\
			<div class="ace_item_box">\
				<span class="icon_file"><i class="text-icon"></i></span>\
				<span>' + (type ? conifg.title : ('新建文件-' + _index)) + '</span>\
				<i class="glyphicon icon-tool glyphicon-remove" aria-hidden="true" data-file-state="0" data-title="' + (type ? conifg.title : ('新建文件-' + _index)) + '"></i>\
			</div>\
		</li>');
        $('#ace_editor_' + _id).siblings().removeClass('active');
        $('.ace_container_editor').append('<div id="ace_editor_' + _id + '" class="ace_editors active">' + (type ? aceShortcutKeys.innerHTML : '') + '</div>');
        switch (type) {
            case 0:
                this.creationEditor({id: _id});
                this.editorLength = this.editorLength + 1;
                break;
            case 1:
                this.removerStatusBar();
                this.editorLength = this.editorLength + 1;
                break;
        }
    },
    // 删除编辑器视图-方法
    removeEditor: function (id) {
        if (id === undefined) id = this.aceActive;
        if ($('.item_tab_' + id).next().length !== 0 && this.editorLength !== 1) {
            $('.item_tab_' + id).next().on('click',);
        } else if ($('.item_tab_' + id).prev.length !== 0 && this.editorLength !== 1) {
            $('.item_tab_' + id).prev().on('click',);
        }
        $('.item_tab_' + id).remove();
        $('#ace_editor_' + id).remove();
        this.editorLength--;
        if (this.editor[id] === undefined) return false;
        for (let i = 0; i < this.pathArray.length; i++) {
            if (this.pathArray[i] === this.editor[id].path) {
                this.pathArray.splice(i, 1);
            }
        }
        if (!this.editor[id].historys_file) $('[data-menu-path="' + (this.editor[id].path) + '"]').find('.file_fold').removeClass('active bg');
        this.editor[id].ace.destroy();
        delete this.editor[id];
        if (this.editorLength === 0) {
            this.aceActive = '';
            this.pathArray = [];
            this.removerStatusBar();
        } else {
            this.currentStatusBar(this.aceActive);
        }
        if (this.aceActive !== '') this.isFileHistory(this.editor[this.aceActive]);
    },
    // 打开历史文件文件-方法
    openHistoryEditorView: function (obj, callback) {
        // 文件类型（type，列如：JavaScript） 、文件模型（mode，列如：text）、文件标识（id,列如：x8AmsnYn）、文件编号（index,列如：0）、文件路径 (path，列如：/www/root/)
        let othis = this, path = obj.filename, paths = path.split('/'), _fileName = paths[paths.length - 1],
            _fileType = this.getFileType(_fileName), _type = _fileType.name, _mode = _fileType.mode,
            _id = bt.get_random(8), _index = this.editorLength;
        this.getFileHistory({filename: obj.filename, history: obj.history}, function (res) {
            othis.pathArray.push(path);
            $('.ace_container_menu .item').removeClass('active');
            $('.ace_container_editor .ace_editors').removeClass('active');
            $('.ace_container_menu').append('<li class="item active item_tab_' + _id + '" title="' + path + '" data-type="' + _type + '" data-mode="' + _mode + '" data-id="' + _id + '" data-fileName="' + _fileName + '">' +
                '<div class="ace_item_box">' +
                '<span class="icon_file"><img src="/static/img/ico-history.png"></span><span title="' + path + ' 历史版本[ ' + bt.format_data(obj.history) + ' ]' + '">' + _fileName + '</span>' +
                '<i class="glyphicon glyphicon-remove icon-tool" aria-hidden="true" data-file-state="0" data-title="' + _fileName + '"></i>' +
                '</div>' +
                '</li>');
            $('.ace_container_editor').append('<div id="ace_editor_' + _id + '" class="ace_editors active"></div>');
            $('[data-paths="' + path + '"]').find('.file_fold').addClass('active bg');
            othis.ace_active = _id;
            othis.editorLength = othis.editorLength + 1;
            othis.creationEditor({
                id: _id,
                fileName: _fileName,
                path: path,
                mode: _mode,
                encoding: res.encoding,
                data: res.data,
                type: _type,
                historys: res.historys,
                readOnly: true,
                historys_file: true,
                historys_active: obj.history
            });
            if (callback) callback(res);
        });
    },
    // 打开编辑器文件-方法
    openEditorView: function (path, callback) {
        if (path === undefined) return false;
        // 文件类型（type，列如：JavaScript） 、文件模型（mode，列如：text）、文件标识（id,列如：x8AmsnYn）、文件编号（index,列如：0）、文件路径 (path，列如：/www/root/)
        let othis = this, paths = path.split('/'), _fileName = paths[paths.length - 1],
            _fileType = this.getFileType(_fileName), _type = _fileType.name, _mode = _fileType.mode,
            _id = bt.get_random(8), _index = this.editorLength;
        othis.isFileOpen(path, function (is_state) {
            if (is_state) {
                $('.ace_container_menu').find('[title="' + path + '"]').on('click',);
            } else {
                othis.getFileBody({path: path}, function (res) {
                    othis.pathArray.push(path);
                    $('.ace_container_menu .item').removeClass('active');
                    $('.ace_container_editor .ace_editors').removeClass('active');
                    $('.ace_container_menu').append('<li class="item active item_tab_' + _id + '" title="' + path + '" data-type="' + _type + '" data-mode="' + _mode + '" data-id="' + _id + '" data-fileName="' + _fileName + '">' +
                        '<div class="ace_item_box">' +
                        '<span class="icon_file"><i class="' + _mode + '-icon"></i></span><span title="' + path + '">' + _fileName + '</span>' +
                        '<i class="glyphicon glyphicon-remove icon-tool" aria-hidden="true" data-file-state="0" data-title="' + _fileName + '"></i>' +
                        '</div>' +
                        '</li>');
                    $('.ace_container_editor').append('<div id="ace_editor_' + _id + '" class="ace_editors active" style="font-size:' + aceEditor.aceConfig.aceEditor.fontSize + 'px"></div>');
                    $('[data-menu-path="' + path + '"]').find('.file_fold').addClass('active bg');
                    othis.ace_active = _id;
                    othis.editorLength = othis.editorLength + 1;
                    othis.creationEditor({
                        id: _id,
                        fileName: _fileName,
                        path: path,
                        mode: _mode,
                        encoding: res.encoding,
                        data: res.data,
                        type: _type,
                        historys: res.historys
                    });
                    if (callback) callback(res, othis.editor[othis.ace_active]);
                });
            }
        });
        toolbarMenuElem.hide();
    },
    // 获取收藏夹列表-方法
    getFavoriteList: function () {
    },
    // 获取文件列表-请求
    getFileList: function () {
    },
    // 获取文件内容-请求
    getFileBody: function (obj, callback) {
        let loadT = layer.msg('正在获取文件内容，请稍后...', {time: 0, icon: 16, shade: [0.3, '#000']}), othis = this;
        $.post("/files?action=GetFileBody", "path=" + encodeURIComponent(obj.path), function (res) {
            layer.close(loadT);
            if (!res.status) {
                if (othis.editorLength === 0) layer.closeAll();
                layer.msg(res.msg, {icon: 2});

                return false;
            } else {
                if (!aceEditor.isAceView) {
                    let _path = obj.path.split('/');
                    layer.msg('已打开文件【' + (_path[_path.length - 1]) + '】');
                }
            }
            if (callback) callback(res);
        });
    },
    // 保存文件内容-请求
    saveFileBody: function (obj, success, error) {
        $.ajax({
            type: 'post',
            url: '/files?action=SaveFileBody',
            timeout: 7000, //设置保存超时时间
            data: {
                data: obj.data,
                encoding: obj.encoding.toLowerCase(),
                path: obj.path
            },
            success: function (rdata) {
                if (rdata.status) {
                    if (success) success(rdata)
                } else {
                    if (error) error(rdata)
                }
                if (!obj.tips) layer.msg(rdata.msg, {icon: rdata.status ? 1 : 2});
            },
            error: function (err) {
                if (error) error(err)
            }
        });
    },
    // 	保存ace配置
    saveAceConfig: function (data, callback) {
        let loadT = layer.msg('正在设置配置文件，请稍后...', {time: 0, icon: 16, shade: [0.3, '#000']}), othis = this;
        this.saveFileBody({
            path: '/www/server/panel/BTPanel/static/editor/ace.editor.config.json',
            data: JSON.stringify(data),
            encoding: 'utf-8',
            tips: true,
        }, function (rdata) {
            layer.close(loadT);
            othis.setStorage('aceConfig', JSON.stringify(data));
            if (callback) callback(rdata);
        });
    },
    // 获取配置文件
    getAceConfig: function (callback) {
        let loadT = layer.msg('正在获取配置文件，请稍后...', {time: 0, icon: 16, shade: [0.3, '#000']}), othis = this;
        this.getFileBody({path: '/www/server/panel/BTPanel/static/editor/ace.editor.config.json'}, function (rdata) {
            layer.close(loadT);
            othis.setStorage('aceConfig', JSON.stringify(rdata.data));
            if (callback) callback(JSON.parse(rdata.data));
        });
    },
    // 递归保存文件
    saveAllFileBody: function (arry, num, callabck) {
        let othis = this;
        if (typeof num === "function") {
            callabck = num;
            num = 0;
        } else if (typeof num === "undefined") {
            num = 0;
        }
        if (num === arry.length) {
            if (callabck) callabck();
            layer.msg('全部保存成功', {icon: 1});
            return false;
        }
        aceEditor.saveFileBody({
            path: arry[num].path,
            data: arry[num].data,
            encoding: arry[num].encoding
        }, function () {
            num = num + 1;
            aceEditor.saveAllFileBody(arry, num, callabck);
        });
    }
};


function openEditorView(type, path, callback) {
    let paths = path.split('/'),
        filename = paths[paths.length - 1],
        _aceTmplate = document.getElementById("aceTmplate").innerHTML;
    _aceTmplate = _aceTmplate.replace(/\<\\\/script\>/g, '</script>');
    if (aceEditor.editor !== null) {
        if (aceEditor.isAceView === false) {
            aceEditor.isAceView = true;
            $('.aceEditors .layui-layer-max').on('click',);
        }
        aceEditor.openEditorView(path);
        return false;
    }
    let r = layer.open({
        type: 1,
        maxmin: true,
        shade: false,
        area: ['80%', '80%'],
        title: "在线文本编辑器",
        skin: 'aceEditors',
        zIndex: 19821027,
        content: _aceTmplate,
        success: function (layero, index) {
            function set_edit_file() {
                aceEditor.aceActive = '';
                aceEditor.eventEditor();
                ace.require("/ace/ext/language_tools");
                ace.config.set("modePath", "/static/editor");
                ace.config.set("workerPath", "/static/editor");
                ace.config.set("themePath", "/static/editor");
                aceEditor.openEditorView(path, callback);
                $('#ace_container').addClass(aceEditor.aceConfig.aceEditor.editorTheme);
                $('.aceEditors .layui-layer-min').on('click', function (e) {
                    aceEditor.setEditorView();
                });
                $('.aceEditors .layui-layer-max').on('click', function (e) {
                    aceEditor.setEditorView();
                });
            }

            let aceConfig = aceEditor.getStorage('aceConfig');
            if (aceConfig === null) {
                // 获取编辑器配置
                aceEditor.getAceConfig(function (res) {
                    aceEditor.aceConfig = res; // 赋值配置参数
                    set_edit_file();
                });
            } else {
                aceEditor.aceConfig = JSON.parse(aceConfig);
                typeof aceEditor.aceConfig === 'string' ? aceEditor.aceConfig = JSON.parse(aceEditor.aceConfig) : ''
                set_edit_file();
            }
        },
        cancel: function () {
            for (let item in aceEditor.editor) {
                if (aceEditor.editor[item].fileType === 1) {
                    layer.open({
                        type: 1,
                        area: ['400px', '180px'],
                        title: '保存提示',
                        content: '<div class="ace-clear-form">\
							<div class="clear-icon"></div>\
							<div class="clear-title">检测到文件未保存，是否保存文件更改？</div>\
							<div class="clear-tips">如果不保存，更改会丢失！</div>\
							<div class="ace-clear-btn" style="">\
								<button type="button" class="btn btn-sm btn-default" style="float:left" data-type="2">不保存文件</button>\
								<button type="button" class="btn btn-sm btn-default" style="margin-right:10px;" data-type="1">取消</button>\
								<button type="button" class="btn btn-sm btn-success" data-type="0">保存文件</button>\
							</div>\
						</div>',
                        success: function (layers, indexs) {
                            $('.ace-clear-btn button').on('click', function () {
                                let _type = $(this).attr('data-type');
                                switch (_type) {
                                    case '2':
                                        aceEditor.editor = null;
                                        aceEditor.editorLength = 0;
                                        aceEditor.pathArray = [];
                                        layer.closeAll();
                                        break;
                                    case '1':
                                        layer.close(indexs);
                                        break;
                                    case '0':
                                        let _arry = [], editor = aceEditor['editor'];
                                        for (let item in editor) {
                                            _arry.push({
                                                path: editor[item]['path'],
                                                data: editor[item]['ace'].getValue(),
                                                encoding: editor[item]['encoding'],
                                            })
                                        }
                                        aceEditor.saveAllFileBody(_arry, function () {
                                            $('.ace_container_menu>.item').each(function (el, indexx) {
                                                let _id = $(this).attr('data-id');
                                                $(this).find('i').removeClass('glyphicon-exclamation-sign').addClass('glyphicon-remove').attr('data-file-state', '0')
                                                aceEditor.editor[_id].fileType = 0;
                                            });
                                            aceEditor.editor = null;
                                            aceEditor.pathArray = [];
                                            layer.closeAll();
                                        });
                                        break;
                                }
                            });
                        }
                    });
                    return false;
                }
            }
        },
        end: function () {
            aceEditor.aceActive = '';
            aceEditor.editor = null;
            aceEditor.pathArray = [];
            aceEditor.menuPath = '';
        }
    });
}

aceEditor.eventEditor();