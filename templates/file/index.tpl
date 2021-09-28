<style>
    .toolbar {
    }

    .toolbar input, #current-path {
        background-color: #fff;
        border-radius: 5px;
        height: 30px;
        border: 1px solid #d2d2d2;
        line-height: 30px;
    }

    #current-path {
        cursor: pointer;
    }

    #current-path > span {
        padding-left: 3px;
    }

    #current-path > span:hover {
        color: #0a5b52;
        font-size: 1.1rem;
    }

    .toolbar input:hover, #current-path:hover {
        border: 1px solid #009688 !important;
    }

    .toolbar .layui-input-inline {
        width: 800px;
        white-space: nowrap;
        overflow: hidden;
    }
</style>
<div class="layui-card">
    <div class="layui-card-body">
        <div class="table-search" style="left:245px">
            <div class="layui-btn-group">
                <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="terminal" lay-tips="打开终端">
                    <i class="layui-icon iconfont icon-terminal"></i>
                </button>
                <button class="layui-btn layui-btn-sm" lay-event="upload" id="upload" lay-tips="上传文件">
                    <i class="layui-icon layui-icon-upload"></i>
                </button>
            </div>
            <div class="layui-inline layui-form">
                <div class="layui-inline">
                    <div class="layui-input-inline">
                        <input type="text" name="search" placeholder="搜索文件/目录" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <div class="layui-input-inline">
                        <input type="checkbox" name="action" title="包含子目录">
                    </div>
                </div>
                <button class="layui-btn layui-btn-sm layui-btn-primary" lay-submit lay-filter="search">
                    <i class="layui-icon layui-icon-search"></i>
                </button>
            </div>
        </div>
        <div class="table-search toolbar" style="left:32px;top:56px">
            <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="return-top" lay-tips="返回上层目录">
                <i class="layui-icon layui-icon-return"></i>
            </button>
            <div class="layui-input-inline layui-form">
                <div id="current-path"></div>
                <input type="hidden" name="goto" value="" class="layui-input" lay-verify="required">
                <button class="layui-hide" lay-submit lay-filter="submit-goto"></button>
            </div>
            <button class="layui-btn layui-btn-sm" lay-event="refresh" lay-tips="刷新当前目录">
                <i class="layui-icon layui-icon-refresh"></i>
            </button>
        </div>
        <table class="layui-font" id="table-list" lay-filter="table-list"></table>
    </div>
</div>
<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-inline">
            <label class="layui-form-label">操作:</label>
            <div class="layui-input-block">
                <select name="action" lay-verify="" lay-search>
                    <option value="compress" selected>打包</option>
                    <option value="del">删除</option>
                    <option value="move">移动/重命名</option>
                    <option value="copy">复制</option>
                    <option value="chmod">修改权限</option>
                    <option value="user">所有者</option>
                    <option value="group">所有组</option>
                </select>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label" lay-tips="打包名/权限值/用户名/组名/目标文件或目录名">值:</label>
            <div class="layui-input-block">
                <input name="value" type="text" class="layui-input layui-input-small"/>
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <input name="inherit" type="checkbox" title="继承" lay-skin="primary" checked/>
                <button class="layui-btn" lay-submit lay-filter="submit-acts">确定</button>
            </div>
        </div>
    </div>
</div>
<script type="text/html" id="toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm" lay-event="back_root" lay-tips="用户目录">
            <i class="layui-icon layui-icon-home"></i>
        </button>
        <button class="layui-btn layui-btn-sm" lay-event="back_www" lay-tips="所有网站目录">
            <i class="layui-icon layui-icon-app"></i>
        </button>
        <button class="layui-btn layui-btn-sm" lay-event="new_folder" lay-tips="在当前目录新建文件夹">
            <i class="layui-icon layui-icon-add-1"></i><i class="layui-icon layui-icon-template"></i>
        </button>
        <button class="layui-btn layui-btn-sm" lay-event="new_file" lay-tips="在当前目录新建文件">
            <i class="layui-icon layui-icon-add-1"></i><i class="layui-icon layui-icon-file"></i>
        </button>
    </div>
    <div class="layui-input-block"></div>
</script>
<script type="text/html" id="table-toolbar">
    {{html .toolbar}}
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let form = layui.form,
            table = layui.table,
            main = layui.main,
            upload = layui.upload,
            url = "/file",
            curPath = new CurPath();
        curPath.data.path = main.getParam('path') || "/home/wwwroot";
        // 初始化
        curPath.init();
        // 渲染上传组件
        let uploaded = upload.render({
            headers: {'X-CSRF-Token': csrfToken},
            elem: '#upload',
            url: url + '/upload',
            data: {'path': curPath.data.path},
            accept: 'file',
            done: function (res) {
                table.reload('table-list', {where: {'path': curPath.data.path}});
                layer.msg(res.msg);
            },
        });
        // 列表管理
        let tabled = table.render({
            headers: {'X-CSRF-Token': csrfToken},
            method: 'post',
            elem: '#table-list',
            url: url,
            toolbar: '#toolbar',
            where: {'path': curPath.data.path},
            cols: [[
                {type: 'checkbox', fixed: 'left'},
                {
                    field: 'name', minWidth: 100, title: '名称', sort: true, style: 'color:#0a6e85;cursor:pointer',
                    event: 'name', templet: (d) => {
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
                },
                {field: 'type', title: '类型', width: 100, hide: true},
                {field: 'uname', title: '所有者', width: 80},
                {field: 'gname', title: '所有组', width: 80},
                {field: 'uid', title: '用户ID', hide: true},
                {field: 'gid', title: '组ID', hide: true},
                {
                    field: 'size', title: 'Size', width: 100, sort: true, style: 'color:#0a6e85;cursor:pointer',
                    event: "size", align: 'center', templet: (d) => {
                        if (d.type === 0) {
                            return "计算";
                        }
                        return d.size;
                    }
                },
                {field: 'mode', title: '权限', width: 100},
                {field: 'mtime', title: '最后修改', width: 170, sort: true},
                {title: '操作', minWidth: 180, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
            ]],
            page: true,
            limit: 100,
            limits: [100, 200, 500, 1000],
            text: '对不起，加载出现异常！',
            done: function (res) {
                if (this.where) {
                    delete this.where.search
                }
                curPath.data = res;
                curPath.data.path = curPath.data.path || "/";
                window.scrollTo(0, 0);
                curPath.render();
                uploaded.reload({
                    data: {'path': curPath.data.path},
                    done: function (res) {
                        tabled.reload({where: {path: curPath.data.path}});
                        layer.msg(res.msg);
                    },
                });
            }
        });
        // 监听工具条
        table.on('tool(table-list)', function (obj) {
            let d = obj.data;
            switch (obj.event) {
                case 'size':
                    let elem = $(obj.tr.selector + ' [data-field="size"]>div');
                    if (elem.find('img[src$=".svg"]').length > 0) {
                        return false;
                    }
                    elem.html(`<img alt="等待计算结果" src="/theme/loading2.svg">`);
                    $.get(url + "/size", {path: d.path}, function (res) {
                        elem.text(res);
                    });
                    break;
                case 'del':
                    layer.confirm('删除后不可恢复！确定删除 ' + d.path + ' ?', function (index) {
                        main.req({
                            url: url + '/del',
                            data: {'name': d.path},
                            index: index,
                            ending: obj.del,
                        });
                    });
                    break;
                case "name":
                    switch (d.type) {
                        case 0:
                            tabled.reload({where: {path: d.path}});
                            break;
                        case 2:
                        case 7:
                        case 8:
                            layer.confirm('确定下载 ' + d.name + ' ?', function (index) {
                                window.open(encodeURI(url + '/download?file=' + d.path));
                                layer.close(index);
                            });
                            break;
                        default:
                            if (d.size > 1024 * 1024 * 3) {
                                layer.msg("文件超大,不支持在线编辑", {icon: 5});
                                return
                            }
                            let loadIndex = layer.load(1, {shade: [0.6, '#000', true]});
                            $.get(url + '/editor', {path: d.path, hide: true}, function (html) {
                                layui.layer.close(loadIndex);
                                main.popup({title: false, content: html, maxmin: false, area: '95%'});
                                tabled.reload({where: {path: curPath.data.path}});
                            });
                    }
                    break;
                case 'compress':
                    main.req({
                        url: url + '/compress',
                        data: {'name': d.path},
                        ending: function () {
                            tabled.reload({where: {path: curPath.data.path}});
                        }
                    });
                    break;
                case 'decompress':
                    main.req({
                        url: url + '/decompress',
                        data: {'name': d.path},
                        ending: function () {
                            tabled.reload({where: {path: curPath.data.path}});
                        }
                    });
                    break;
                case 'download':
                    window.open(encodeURI(url + '/download?file=' + d.path));
                    break;
            }
        });
        // 监听工具栏
        table.on('toolbar(table-list)', function (obj) {
            switch (obj.event) {
                case 'rollback':
                    tabled.reload({where: {path: curPath.data.path}});
                    break;
                case 'back_www':
                    tabled.reload({where: {path: '/home/wwwroot'}});
                    break;
                case 'back_root':
                    tabled.reload({where: {path: '/root'}});
                    break;
                case 'new_folder':
                    layer.prompt(
                        {
                            formType: 0,
                            value: 'webrobot.cn',
                            title: '请输入文件夹名不要有空格!'
                        },
                        function (value, index) {
                            main.req({
                                url: url + '/new/folder',
                                data: {name: value, path: curPath.data.path},
                                index: index,
                                ending: function () {
                                    tabled.reload({where: {path: curPath.data.path}});
                                }
                            });
                        });
                    break;
                case 'new_file':
                    layer.prompt(
                        {
                            formType: 0,
                            value: 'webrobot.cn',
                            title: '请输入文件名不要有空格!'
                        },
                        function (value, index) {
                            main.req({
                                url: url + '/new/file',
                                data: {name: value, path: curPath.data.path},
                                index: index,
                                ending: function () {
                                    tabled.reload({where: {path: curPath.data.path}});
                                }
                            });
                        }
                    );
                    break;
            }
        });
        // 转到
        form.on('submit(submit-goto)', function (obj) {
            tabled.reload({where: {path: obj.field.goto}});
        });
        // 监听搜索
        form.on('submit(search)', function (data) {
            let field = data.field, cols = [];
            $.each(field, function (k, v) {
                let col = k.split('.')[0];
                if (v && col !== 'cols' && cols.indexOf(col) === -1) {
                    cols.push(col);
                } else {
                    delete field[k];
                }
            });
            field.cols = cols.join(",");
            if (!field.cols) {
                return location.reload();
            }
            field.path = curPath.data.path;
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
            field.path = curPath.data.path;
            if (field.action === 'del') {
                layer.confirm('删除后不可恢复，确定批量删除吗？', function (index) {
                    main.req({
                        url: url + '/del',
                        data: field,
                        index: index,
                        ending: function () {
                            tabled.reload({where: {path: curPath.data.path}});
                        }
                    });
                });
            } else {
                main.req({
                    url: url + '/' + field.action,
                    data: field,
                    ending: function () {
                        tabled.reload({where: {path: curPath.data.path}});
                    }
                });
            }
            return false;
        });
    });

    class CurPath {
        constructor() {
            this.currentPathElem = $('#current-path');
            this.data = {};
            this.init = () => {
                let othis = this;
                this.render();
                othis.currentPathElem.off('click').on('click', function () {
                    othis.currentPathElem.hide();
                    $('input[name=goto]').attr("type", "text").val(othis.currentPathElem.attr("title"));
                    layui.form.render("input");
                });
                $('.toolbar [lay-event="return-top"],.toolbar [lay-event=refresh]').off('click').on('click', function () {
                    othis.goto(this);
                });
                $('[lay-event=terminal]').off('click').on('click', function () {
                    layui.main.webssh({stdin: "cd " + othis.data.path});
                });
                $('input[name="goto"]').keydown(function (event) {
                    if (event.keyCode === 13 && this.value) {
                        $('[lay-filter="submit-goto"]').click();
                    }
                });
                $('input[name="search"]').keydown(function (event) {
                    if (event.keyCode === 13) {
                        $('[lay-filter=search]').click();
                    }
                });
            };
            this.render = () => {
                this.data.path = this.data.path || "/";
                if (this.data.path.substring(0, 1) !== "/") {
                    this.data.path = {{.app_root}}+"/" + this.data.path;
                }
                this.currentPathElem.attr("title", this.data.path).show().parent().find("input").attr("type", "hidden");
                let paths = this.data.path.split("/"), p = [],
                    elem = `<span title="/">根目录</span><span title="/">></span>`;
                for (let i = 1; i < paths.length; i++) {
                    paths[i] = paths[i].trim();
                    if (paths[i]) {
                        p.push(paths[i]);
                        let title = p.join("/");
                        elem += `<span title="/` + title + `">` + paths[i] + `</span><span title="/` + title + `">></span>`;
                    }
                }
                this.currentPathElem.html(elem);
                let othis = this;
                $('#current-path>span').off('click').on('click', function () {
                    othis.goto(this);
                });
                $('.toolbar [lay-event="return-top"]').attr("title", this.getTop(this.data.path));
                $('.toolbar [lay-event="refresh"]').attr("title", this.data.path);
            };
            this.goto = (othis) => {
                $('input[name=goto]').val(othis.title);
                $('[lay-filter="submit-goto"]').click();
            };
            this.getTop = (path) => {
                if (!path || path === "/") {
                    return "/";
                }
                path = path.trim();
                let paths = path.split("/"), p = "";
                for (let i = 0; i < paths.length - 1; i++) {
                    let name = paths[i].trim();
                    if (name) {
                        p += "/" + name
                    }
                }
                return p || "/";
            };
        }
    }
</script>