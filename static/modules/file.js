layui.define(['main', 'editor'], function (exports) {
    Array.prototype.included = function (item) {
        for (let i = 0; i < this.length; i++) {
            if (this.indexOf(item) !== -1) return true;
        }
        return false;
    };
    Array.prototype.delete = function (v) {
        for (let i = 0; i < this.length; i++) {
            if (this[i] === v) {
                this.splice(i, 1);
                i--
            }
        }
        return this;
    };
    let main = layui.main, form = layui.form, table = layui.table;

    class File {
        constructor(options) {
            options = options || {};
            this.root = options.root || '/data/botadmin';
            this.config = {path: options.path || main.getParam('path') || '/home/wwwroot'};
            this.pathElem = typeof options.elem === 'string' ? $(options.elem) : $('#current-path');
        }

        // 刷新
        refresh(path, page) {
            path = path || '/';
            $('.table-search input[name=search]').val('');
            $('.table-search input[name=recursion]').prop('checked', false);
            $('.table-search input[name=path]').val(path);
            form.render('checkbox');
            if (page) return table.reload('table-list', {where: {path: path}, page: {curr: 1}});
            return table.reload('table-list', {where: {path: path}});
        }

        // 渲染路径
        renderPath() {
            this.config.path = this.config.path || '/';
            if (this.config.path.substring(0, 1) !== '/') {
                this.config.path = this.root + '/' + this.config.path;
            }
            this.pathElem.attr('title', this.config.path).show().parent().find('input').attr('type', 'hidden');
            let paths = this.config.path.split('/'), p = [], elem = '<span title="/">根目录</span>';
            for (let i = 1; i < paths.length; i++) {
                paths[i] = paths[i].trim();
                if (paths[i]) {
                    p.push(paths[i]);
                    elem += '<span>></span></span><span title="/' + p.join('/') + '">' + paths[i] + '</span>';
                }
            }
            this.pathElem.html(elem);
            $('.table-search input[name=path]').val(this.config.path);
            if ($('select[name=action]').val() === 'compress') {
                $('input[name=value]').val(main.basename(this.pathElem.attr('title')) + '.tar.gz');
            }
            form.render('input');
        }

        // 监听
        listen(active) {
            let othis = this;
            othis.pathElem.on('click', '>span[title]', function () {
                othis.refresh(this.title, 1);
            });
            // 渲染
            othis.pathElem.on('click', function () {
                $('.table-search input[name=search]').val('');
                $('.table-search input[name=recursion]').prop('checked', false);
                form.render('checkbox');
                othis.pathElem.hide();
                $('.table-search input[name=path]').attr('type', 'search');
                form.render('input');
            });
            $(document).on('click', '[data-event]', function () {
                let $this = $(this), event = $this.data('event');
                active[event] && active[event].call($this);
            });
            $('.table-search').on('blur', 'input[name=path]', function () {
                othis.renderPath()
            });
            // 监听操作
            form.on('submit(submit-acts)', function (obj) {
                let checkData = table.checkStatus('table-list').data, // 得到选中的数据
                    names = [];
                if (checkData.length === 0) {
                    return layer.msg('请选择数据');
                }
                layui.each(checkData, function (k, v) {
                    if (v.name !== undefined) {
                        names[k] = v.name;
                    }
                });
                let field = obj.field;
                field.names = names.join('\n');
                field.path = othis.config.path;
                if (field.action === 'del') {
                    layer.confirm('删除后不可恢复，确定批量删除吗？', function (index) {
                        main.request({
                            url: URL + '/del',
                            data: field,
                            index: index,
                            done: function () {
                                othis.refresh(othis.config.path, 1);
                            },
                        });
                    });
                } else {
                    main.request({
                        url: URL + '/' + field.action,
                        data: field,
                        done: function () {
                            othis.refresh(othis.config.path, 1);
                        },
                    });
                }
                return false;
            });
            form.on('select(action)', function (obj) {
                let parentName = main.basename(othis.pathElem.attr('title')),
                    valElem = obj.othis.closest('.layui-form').find('input[name=value]');
                switch (obj.value) {
                    case 'compress':
                        valElem.val(parentName + '.tar.gz');
                        break;
                    case 'del':
                        valElem.val('');
                        break;
                    case 'copy':
                    case 'move':
                        valElem.val('新文件名');
                        break;
                    case 'chmod':
                        valElem.val('0755');
                        break;
                    case 'chgroup':
                        valElem.val('www:www');
                        break;
                }
            });
        }

        // 渲染
        render() {
            let othis = this;
            main.upload({
                url: URL + '/upload',
                data: {
                    path: function () {
                        return othis.config.path
                    }
                },
                done: function (res) {
                    layer.closeAll('loading'); //关闭loading
                    othis.refresh(othis.config.path);
                    layer.msg(res.msg);
                },
                error: function () {
                    layer.closeAll('loading'); //关闭loading
                }
            });
            let tabled = main.table({
                where: {path: othis.config.path},
                cols: [[{type: 'checkbox', fixed: 'left'},
                    {field: 'path', title: '目录', hide: true},
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
                            return '<b title="' + d.path + '/' + d.name + '">' + name + '</b>';
                        }
                    },
                    {field: 'type', title: '类型', width: 100, hide: true},
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
                    {field: 'mode', title: '权限', width: 100},
                    {field: 'mtime', title: '最后修改', width: 170, sort: true},
                    {
                        title: '操作', minWidth: 180, align: 'center', fixed: 'right', templet: (d) => {
                            let html = '<div class="layui-btn-group">';
                            if (/data\/contact\/images\/[^\/]+\.(?:jpeg|gif|jpg|png)/i.test(d.path)) {
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
                            if (d.type === 0 || d.type === 1 || d.type === 2 || d.type === 4 || d.type === 8) {
                                html += '<button class="layui-btn layui-btn-xs layui-btn-warm" lay-event="scan" lay-tips="扫描病毒文件"><i class="iconfont icon-scanner"></i></button>';
                                html += '<button class="layui-btn layui-btn-xs layui-btn-primary" lay-event="scanned" lay-tips="查看扫描结果"><i class="iconfont icon-safe"></i></button>';
                            }
                            return html + '<button class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del"><i class="layui-icon layui-icon-delete"></i></button></div>';
                        }
                    }]],
                limits: [50, 100, 200, 500, 1000],
                limit: 50,
                done: function (res) {
                    if (this.where) {
                        delete this.where.search;
                    }
                    $.extend(othis.config, res);
                    window.scrollTo(0, 0);
                    othis.renderPath();
                    layui.main.history('gotoHistories');
                    let histories = JSON.parse(localStorage.getItem('histories')) || [];
                    if (histories[histories.length - 1] !== othis.config.path) {
                        histories.push(othis.config.path);
                    }
                    localStorage.setItem('histories', JSON.stringify(histories))
                }
            }, {
                terminal: function () {
                    main.webssh({stdin: 'cd ' + othis.config.path});
                },
                refresh: function () {
                    othis.refresh(othis.config.path);
                },
                history: function () {
                    let path = othis.config.path, histories = JSON.parse(localStorage.getItem('histories'));
                    if (Array.isArray(histories) && histories.length > 1) {
                        path = histories[histories.length - 2];
                        histories.splice(histories.length - 2, 1);
                        localStorage.setItem('histories', JSON.stringify(histories));
                    }
                    othis.refresh(path, 1)
                },
                copy: function (obj) {
                    let name = obj.data.path.split('/images/', 2)[1];
                    if (name) {
                        main.copyHTML('&#123;&#123;hostname&#125;&#125;/images/' + name);
                    }
                },
                size: function (obj) {
                    let elem = $(obj.tr.selector + ' [data-field=size]>div');
                    if (elem.find('img[src$=".svg"]').length > 0) {
                        return false;
                    }
                    elem.html('<img alt="等待计算结果" src="/static/images/loading-small.svg">');
                    $.get(URL + '/size', obj.data, function (res) {
                        elem.text(res);
                    });
                },
                del: function (obj) {
                    let filename = obj.data.path + '/' + obj.data.name;
                    layer.confirm('删除后不可恢复！确定删除 ' + filename + ' ?', function (index) {
                        main.request({
                            url: URL + '/del',
                            data: {path: obj.data.path, names: filename},
                            index: index,
                            done: obj.del,
                        });
                    });
                },
                name: function (obj) {
                    let filename = obj.data.path + '/' + obj.data.name;
                    switch (obj.data.type) {
                        case 0:
                            othis.refresh(filename, 1);
                            break;
                        case 7:
                            main.preview(filename);
                            break;
                        case 2:
                        case 8:
                            layer.confirm('确定下载 ' + obj.data.name + ' ?', function (index) {
                                main.download(filename);
                                layer.close(index);
                            });
                            break;
                        default:
                            //文本在线编辑器
                            layui.editor(filename);

                    }
                },
                compress: function (obj) {
                    main.request({
                        url: URL + '/compress',
                        data: {path: obj.data.path, names: obj.data.name},
                        done: function () {
                            othis.refresh(othis.config.path);
                        },
                    });
                },
                decompress: function (obj) {
                    main.request({
                        url: URL + '/decompress',
                        data: obj.data,
                        done: function () {
                            othis.refresh(othis.config.path);
                        },
                    });
                },
                download: function (obj) {
                    main.download(obj.data.path + '/' + obj.data.name);
                },
                gotoWww: function () {
                    othis.refresh('/home/wwwroot', 1);
                },
                gotoRoot: function () {
                    othis.refresh('/root', 1);
                },
                newFolder: function () {
                    layer.prompt({
                        formType: 0, value: 'folder', title: '请输入文件夹名不要有空格!'
                    }, function (value, index) {
                        main.request({
                            url: URL + '/new/folder',
                            data: {name: value, path: othis.config.path},
                            index: index,
                            done: function () {
                                othis.refresh(othis.config.path, 1);
                            },
                        });
                    });
                },
                newFile: function () {
                    layer.prompt({
                        formType: 0, value: 'filename.txt', title: '请输入文件名不要有空格!'
                    }, function (value, index) {
                        main.request({
                            url: URL + '/new/file',
                            data: {name: value, path: othis.config.path},
                            index: index,
                            done: function () {
                                othis.refresh(othis.config.path, 1);
                            },
                        });
                    });
                },
                scan: function (obj) {
                    layer.prompt({title: '扫描排除文件名或路径(不可用绝对路径)', placeholder: '.html, .doc, .csv'},
                        function (pass, index) {
                            layer.close(index);
                            let filename = obj.data.path + '/' + obj.data.name;
                            main.request({
                                url: '/file/scan',
                                data: {path: filename, excludes: pass}
                            });
                        });
                },
                scanned: function (obj) {
                    main.ws.scanned(obj.data.path + '/' + obj.data.name);
                }
            });
            this.listen(tabled.active);
        }
    }

    exports('file', function (options) {
        let file = new File(options);
        file.render();
    });
});