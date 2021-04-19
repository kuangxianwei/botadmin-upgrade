<div class="layui-card">
    <div class="layui-card-header layuiadmin-card-header-auto layui-form">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">文件名称</label>
                <div class="layui-input-inline">
                    <input type="text" name="search_name" placeholder="请输入" autocomplete="off"
                           class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">类型</label>
                <div class="layui-input-inline">
                    <select name="search_type" lay-filter="search_type">
                        <option value="" selected>未指定</option>
                        <option value="file">文件</option>
                        <option value="folder">目录</option>
                        <option value="compress">压缩文件</option>
                    </select>
                </div>
            </div>
            <div class="layui-inline">
                <button class="layui-btn" data-type="reload" lay-submit lay-filter="search"
                        id="search">
                    <i class="layui-icon layui-icon-search layuiadmin-button-btn"></i>
                </button>
            </div>
        </div>
    </div>
    <div class="layui-card-body">
        <table class="layui-font" id="table-list" lay-filter="table-list"></table>
    </div>
</div>
<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-inline">
            <label class="layui-form-label">操作:</label>
            <div class="layui-input-block">
                <select name="act" lay-verify="" lay-search>
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
                <input name="actname" type="text" class="layui-input layui-input-small"/>
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
        <button class="layui-btn layui-btn-sm" lay-event="rollback" lay-tips="上一层目录">
            <i class="layui-icon layui-icon-up"></i>
        </button>
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
        <button class="layui-btn layui-btn-sm" lay-event="upload" id="upload" lay-tips="上传文件">
            <i class="layui-icon layui-icon-upload"></i>
        </button>
        <button class="layui-btn layui-btn-sm" lay-event="refresh" lay-tips="刷新当前路径">
            <i class="layui-icon layui-icon-refresh-3"></i>
        </button>
    </div>
    <div class="layui-form">
        <label>当前路径: <strong id="currentpath"></strong>&nbsp;&nbsp;&nbsp;</label>
        <i class="layui-icon layui-icon-right"></i>
        <div class="layui-input-inline">
            <input type="text" name="goto" placeholder="/root" autocomplete="off"
                   class="layui-input" style="height: 30px" required lay-verify="required">
        </div>
        <button class="layui-btn layui-btn-sm" lay-submit lay-filter="submit-goto" lay-tips="跳转到指定目录">
            <i class="layui-icon layui-icon-triangle-r"></i>
        </button>
    </div>
</script>
<script type="text/html" id="table-toolbar">
    {{ html .operation }}
</script>
<script type="text/html" id="table-content-name">
    {{ html .file_name }}
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let form = layui.form,
            table = layui.table,
            main = layui.main,
            upload = layui.upload,
            url = {{.current_uri}},
            current_path = main.getParam('path') || "/home/wwwroot";
        $('#currentpath').text(current_path);
        // 列表管理
        table.render({
            headers: {'X-CSRF-Token':{{.csrf_token}}},
            method: 'post',
            elem: '#table-list',
            url: {{.current_uri}},
            toolbar: '#toolbar',
            where: {'path': current_path},
            cols: [[
                {type: 'checkbox', fixed: 'left'},
                {
                    field: 'name', minWidth: 100, title: '名称', sort: true,
                    templet: '#table-content-name'
                },
                {field: 'type', title: '类型', width: 100, sort: true},
                {field: 'uname', title: '所有者', width: 80},
                {field: 'gname', title: '所有组', width: 80},
                {field: 'uid', title: '用户ID', hide: true},
                {field: 'gid', title: '组ID', hide: true},
                {field: 'size', title: '文件大小', width: 100, sort: true},
                {field: 'mode', title: '权限', width: 100},
                {field: 'mtime', title: '最后修改', minWidth: 100, sort: true},
                {title: '操作', minWidth: 180, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
            ]],
            page: false,
            limit: 10,
            limits: [10, 15, 20, 25, 30],
            text: '对不起，加载出现异常！',
            done: function (res) {
                window.scrollTo(0, 0);
                if (res.path) {
                    current_path = res.path;
                }
                $('#currentpath').text(current_path);
                if (this.where) {
                    delete this.where.search_name;
                    delete this.where.search_type;
                    delete this.where.goto;
                }
                upload.render({
                    headers: {'X-CSRF-Token':{{.csrf_token}}},
                    elem: '#upload',
                    url: url + '/upload',
                    data: {'path': current_path},
                    accept: 'file',
                    done: function (res) {
                        table.reload('table-list', {
                            url: url,
                            where: {'path': current_path}
                        });
                        layer.msg(res.msg);
                    },
                });
            }
        });

        // 监听工具条
        table.on('tool(table-list)', function (obj) {
            let d = obj.data;
            switch (obj.event) {
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
                case 'filename':
                    if (d.type === 'folder') {
                        table.reload('table-list', {
                            url: url,
                            where: {'path': d.path}
                        });
                    } else {
                        let loadIndex = layer.load(1, {shade: [0.6, '#000', true]});
                        $.get(url + '/editor', {'path': d.path, 'hide': true}, function (html) {
                            layui.layer.close(loadIndex);
                            main.popup({
                                title: '编辑文件',
                                content: html,
                            });
                            table.render();
                        });
                    }
                    break;
                case 'compress':
                    main.req({
                        url: url + '/compress',
                        data: {'name': d.path},
                        ending: function () {
                            table.reload('table-list', {
                                url: url,
                                where: {'path': current_path}
                            });
                        }
                    });
                    break;
                case 'decompress':
                    main.req({
                        url: url + '/decompress',
                        data: {'name': d.path},
                        ending: function () {
                            table.reload('table-list', {
                                url: url,
                                where: {'path': current_path}
                            });
                        }
                    });
                    break;
                case 'download':
                    window.open(encodeURI(url + '/download?file=' + d.path));
                    break;
            }
        });

        //监听工具栏
        table.on('toolbar(table-list)', function (obj) {
            switch (obj.event) {
                case 'rollback':
                    table.reload('table-list', {
                        url: url + '/rollback',
                        where: {'path': current_path}
                    });
                    break;
                case 'back_www':
                    table.reload('table-list', {
                        url: url,
                        where: {
                            path: '/home/wwwroot'
                        }
                    });
                    break;
                case 'back_root':
                    table.reload('table-list', {
                        url: url,
                        where: {
                            path: '/root'
                        }
                    });
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
                                url: url + '/newfolder',
                                data: {
                                    name: value,
                                    path: current_path
                                },
                                index: index,
                                ending: function () {
                                    table.reload('table-list', {
                                        url: url,
                                        where: {
                                            path: current_path
                                        }
                                    });
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
                                url: url + '/newfile',
                                data: {
                                    name: value,
                                    path: current_path
                                },
                                index: index,
                                ending: function () {
                                    table.reload('table-list', {
                                        url: url,
                                        where: {
                                            path: current_path
                                        }
                                    });
                                }
                            });
                        }
                    );
                    break;
                case "refresh":
                    table.reload('table-list', {
                        url: url,
                        where: {
                            path: current_path
                        }
                    });
            }
        });

        //转到
        form.on('submit(submit-goto)', function (obj) {
            let field = obj.field, cols = [];
            $.each(field, function (k, v) {
                if (v) {
                    cols.push(k);
                } else {
                    delete field[k];
                }
            });
            field.cols = cols.join();
            field.path = current_path;
            table.reload('table-list', {
                url: url,
                where: field,
            });
            return false;
        });

        // 监听搜索
        form.on('submit(search)', function (obj) {
            let field = obj.field, cols = [];
            $.each(field, function (k, v) {
                if (v) {
                    cols.push(k);
                } else {
                    delete field[k];
                }
            });
            field.cols = cols.join();
            field.path = current_path;
            table.reload('table-list', {
                url: url,
                where: field
            });
            return false;
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
            field.path = current_path;
            if (field.act === 'del') {
                layer.confirm('删除后不可恢复，确定批量删除吗？', function (index) {
                    main.req({
                        url: url + '/del',
                        data: field,
                        index: index,
                        ending: function () {
                            table.reload('table-list', {
                                url: url,
                                where: {path: current_path}
                            });
                        }
                    });
                });
            } else {
                main.req({
                    url: url + '/' + field.act,
                    data: field,
                    ending: function () {
                        table.reload('table-list', {
                            url: url,
                            where: {path: current_path}
                        });
                    }
                });
            }
            return false;
        });
        form.on('select(search_type)', function () {
            $('[lay-filter="search"]').click();
            return false;
        });
    });
</script>
