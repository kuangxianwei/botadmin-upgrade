<div class="layui-card">
    <div class="layui-card-header layuiadmin-card-header-auto layui-form">
        <div class="layui-form-item">
            <div class="layui-input-inline">
                <input type="text" name="username" placeholder="输入用户名" autocomplete="off" class="layui-input">
            </div>
            <div class="layui-input-inline">
                <button class="layui-btn" data-type="reload" lay-submit lay-filter="search">
                    <i class="layui-icon layui-icon-search layuiadmin-button-btn"></i>
                </button>
            </div>
        </div>
    </div>
    <div class="layui-card-body">
        <table id="table-list" lay-filter="table-list"></table>
    </div>
</div>
<script type="text/html" id="toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm" lay-event="add">
            <i class="layui-icon layui-icon-addition"></i>添加
        </button>
        <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="del">
            <i class="layui-icon layui-icon-delete"></i>删除
        </button>
    </div>
</script>
<script type="text/html" id="table-toolbar">
    <a class="layui-btn layui-btn-xs" lay-event="modify">
        <i class="layui-icon layui-icon-edit"></i>编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">
        <i class="layui-icon layui-icon-delete"></i>删除</a>
</script>
<script src="/static/layui/layui.js?ver={{.version}}"></script>
<script>
    layui.config({
        base: '/static/' //静态资源所在路径
    }).extend({
        index: 'lib/index', //主入口模块
        main: 'main'//自定义请求模块
    }).use(['index', 'form', 'table', 'main', 'upload'], function () {
        let $ = layui.$,
            form = layui.form,
            table = layui.table,
            main = layui.main,
            upload = layui.upload,
            url = {{.current_uri}};

        //日志管理
        table.render({
            headers: {'X-CSRF-Token':{{.csrf_token}}},
            method: 'post',
            elem: '#table-list',
            toolbar: '#toolbar',
            url: {{.current_uri}},
            cols: [[
                {type: 'checkbox', fixed: 'left'},
                {
                    field: 'enabled', title: '启用', align: 'center', width: 92, unresize: true, event: 'enabled',
                    templet: function (d) {
                        let msg = '<input username="' + d.username + '" type="checkbox" name="enabled" lay-skin="switch" lay-text="是|否" lay-filter="toggleEnabled"';
                        if (d.enabled) {
                            msg += ' checked>';
                        } else {
                            msg += '>';
                        }
                        return msg;
                    }
                },
                {field: 'username', title: '用户名', minWidth: 100},
                {field: 'alias', title: '别名', hide: true},
                {field: 'wechat', title: '微信', minWidth: 100},
                {field: 'phone', title: '手机', minWidth: 100},
                {field: 'qr', title: '二维码', hide: true},
                {field: 'weight', title: '权重', hide: true},
                {field: 'done', title: '完成', minWidth: 100},
                {field: 'other', title: '其他', hide: true},
                {title: '操作', width: 150, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
            ],],
            page: true,
            limit: 10,
            limits: [10, 15, 20, 25, 30],
            text: '对不起，加载出现异常！'
        });
        //监听工具条
        table.on('tool(table-list)', function (obj) {
            let data = obj.data;
            switch (obj.event) {
                case 'del':
                    layer.confirm('确定删除此条日志？', function (index) {
                        main.req({
                            url: url + '/del',
                            data: {username: data.username},
                            index: index,
                            ending: obj.del
                        });
                    });
                    break;
                case 'modify':
                    $.get(url + "/modify", data, function (html) {
                        layer.open({
                            url: url + '/modify',
                            title: '修改客服',
                            content: html,
                            type: 1,
                            shadeClose: true,
                            scrollbar: false,
                            btnAlign: 'c',
                            shade: 0.8,
                            fixed: false,
                            maxmin: true,
                            btn: ['提交', '取消'],
                            area: ['95%', '95%'],
                            zIndex: 200000,
                            yes: function (index, dom) {
                                if ($(dom.find('*[lay-submit]').click().context).find('input.layui-form-danger').length === 0) {
                                    if ($('[name=file]').val()) {
                                        $('#uploadSubmit').click();
                                    } else {
                                        $('#submit').click();
                                    }
                                }
                                return false;
                            },
                            success: function (dom, layerIndex) {
                                form.render();
                                let loading;
                                dom.find('#submit').on('click', function () {
                                    main.req({
                                        url: url + '/modify',
                                        data: main.formData(dom.selector),
                                        index: layerIndex,
                                        ending: 'table-list',
                                    });
                                });
                                upload.render({
                                    elem: '#uploadFile',
                                    url: url + '/modify',
                                    headers: {'X-CSRF-Token':{{.csrf_token}}},
                                    size: 1024 * 50,
                                    accept: 'images',
                                    acceptMime: 'image/jpg,image/png',
                                    multiple: true,
                                    auto: false,
                                    bindAction: '#uploadSubmit',
                                    before: function () {
                                        this.data = main.formData(dom.selector);
                                        loading = layer.load(1, {shade: [0.7, '#000', true]});
                                    },
                                    choose: function (obj) {
                                        obj.preview(function (index, file, result) {
                                            $('#uploadResult').html('<img height="130" width="130" alt="二维码" src="' + result + '" title="' + file.name + '"/>');
                                        });
                                    },
                                    done: function (res, index, upload) {
                                        layer.close(loading);
                                        if (res.code === 0) {
                                            table.reload('table-list', {page: {curr: 1}});
                                            layer.close(layerIndex);
                                            layer.msg(res.msg, {icon: 1}, function () {
                                                layer.close(index);
                                            });
                                            return false;
                                        }
                                        layer.alert(res.msg, {
                                            skin: 'layui-layer-admin',
                                            shadeClose: true,
                                            icon: 2,
                                            btn: '',
                                            closeBtn: false,
                                            anim: 6,
                                            success: function (o, index) {
                                                let elemClose = $('<i class="layui-icon" close>&#x1006;</i>');
                                                o.append(elemClose);
                                                elemClose.on('click', function () {
                                                    layer.close(index);
                                                });
                                            }
                                        });
                                    },
                                    error: function (index, upload) {
                                        layer.close(index);
                                        layer.close(loading);
                                        layer.alert("网络错误", {
                                            skin: 'layui-layer-admin',
                                            shadeClose: true,
                                            icon: 2,
                                            btn: '',
                                            closeBtn: false,
                                            anim: 6,
                                            success: function (o, index) {
                                                let elemClose = $('<i class="layui-icon" close>&#x1006;</i>');
                                                o.append(elemClose);
                                                elemClose.on('click', function () {
                                                    layer.close(index);
                                                });
                                            }
                                        });
                                    },
                                });
                            }
                        });
                    });
                    break;
            }
        });
        form.on('switch(toggleEnabled)', function (obj) {
            let username = $(this).attr('username'),
                checked = this.checked;
            if (!username) {
                layer.tips('ID为空，无法操作！', obj.othis);
                return false;
            }
            main.req({
                url: url + '/toggle/enable',
                data: {username: username, enabled: checked},
                ending: 'table-list',
            });
            return false;
        });

        //头工具栏事件
        table.on('toolbar(table-list)', function (obj) {
            let checkStatus = table.checkStatus(obj.config.id),
                data = checkStatus.data,
                usernames = Array();
            for (let i = 0; i < data.length; i++) {
                usernames[i] = data[i].username;
            }
            switch (obj.event) {
                case 'add':
                    $.get(url + '/add', {}, function (html) {
                        layer.open({
                            url: url + '/add',
                            title: '添加客服',
                            content: html,
                            type: 1,
                            shadeClose: true,
                            scrollbar: false,
                            btnAlign: 'c',
                            shade: 0.8,
                            fixed: false,
                            maxmin: true,
                            btn: ['提交', '取消'],
                            area: ['95%', '95%'],
                            zIndex: 200000,
                            yes: function (index, dom) {
                                if ($(dom.find('*[lay-submit]').click().context).find('input.layui-form-danger').length === 0) {
                                    if ($('[name=file]').val()) {
                                        $('#uploadSubmit').click();
                                    } else {
                                        $('#submit').click();
                                    }
                                }
                                return false;
                            },
                            success: function (dom, layerIndex) {
                                form.render();
                                let loading;
                                dom.find('#submit').on('click', function () {
                                    main.req({
                                        url: url + '/add',
                                        data: main.formData(dom.selector),
                                        index: layerIndex,
                                        ending: 'table-list',
                                    });
                                });
                                upload.render({
                                    elem: '#uploadFile',
                                    url: url + '/add',
                                    headers: {'X-CSRF-Token':{{.csrf_token}}},
                                    size: 1024 * 50,
                                    accept: 'images',
                                    acceptMime: 'image/jpg,image/png',
                                    multiple: true,
                                    auto: false,
                                    bindAction: '#uploadSubmit',
                                    before: function () {
                                        this.data = main.formData(dom.selector);
                                        loading = layer.load(1, {shade: [0.7, '#000', true]});
                                    },
                                    choose: function (obj) {
                                        obj.preview(function (index, file, result) {
                                            $('#uploadResult').html('<img height="130" width="130" alt="二维码" src="' + result + '" title="' + file.name + '"/>');
                                        });
                                    },
                                    done: function (res, index, upload) {
                                        layer.close(loading);
                                        if (res.code === 0) {
                                            table.reload('table-list', {page: {curr: 1}});
                                            layer.close(layerIndex);
                                            layer.msg(res.msg, {icon: 1}, function () {
                                                layer.close(index);
                                            });
                                            return false;
                                        }
                                        layer.alert(res.msg, {
                                            skin: 'layui-layer-admin',
                                            shadeClose: true,
                                            icon: 2,
                                            btn: '',
                                            closeBtn: false,
                                            anim: 6,
                                            success: function (o, index) {
                                                let elemClose = $('<i class="layui-icon" close>&#x1006;</i>');
                                                o.append(elemClose);
                                                elemClose.on('click', function () {
                                                    layer.close(index);
                                                });
                                            }
                                        });
                                    },
                                    error: function (index, upload) {
                                        layer.close(index);
                                        layer.close(loading);
                                        layer.alert("网络错误", {
                                            skin: 'layui-layer-admin',
                                            shadeClose: true,
                                            icon: 2,
                                            btn: '',
                                            closeBtn: false,
                                            anim: 6,
                                            success: function (o, index) {
                                                let elemClose = $('<i class="layui-icon" close>&#x1006;</i>');
                                                o.append(elemClose);
                                                elemClose.on('click', function () {
                                                    layer.close(index);
                                                });
                                            }
                                        });
                                    },
                                });
                            }
                        });
                    });
                    break;
                case 'del':
                    if (data.length === 0) {
                        return layer.msg('请选择数据');
                    }
                    layer.confirm('删除后不可恢复，确定删除吗？', function (index) {
                        main.req({
                            url: url + '/del',
                            data: {usernames: usernames.join()},
                            index: index,
                            ending: 'table-list'
                        });
                    });
                    break;
            }
        });

        //监听搜索
        form.on('submit(search)', function (data) {
            let field = data.field;
            //$("#form-search :input").val("").removeAttr("checked").remove("selected");
            //执行重载
            table.reload('table-list', {
                where: field,
                page: {curr: 1}
            });
            return false;
        });
    });
</script>