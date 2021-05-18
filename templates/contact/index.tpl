<div class="layui-card">
    <div class="layui-card-body">
        <div class="layui-form table-search" style="left: 400px">
            <div class="layui-inline">
                <input type="text" name="username" class="layui-input" placeholder="输入搜索...">
            </div>
            <button class="layui-btn layui-btn-sm" lay-submit lay-filter="search">
                <i class="layui-icon layui-icon-search"></i>
            </button>
        </div>
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
        <button class="layui-btn layui-btn-sm" lay-event="setup">
            <i class="layui-icon layui-icon-set"></i>
        </button>
        <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="reset-token" lay-tips="重置Token">
            <i class="iconfont icon-reset"></i>Token
        </button>
    </div>
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm" lay-event="log" lay-tips="查看日志">
            <i class="layui-icon layui-icon-log"></i>
        </button>
        <button class="layui-btn layui-btn-sm layui-bg-red" lay-event="reset-record" lay-tips="重置日志">
            <i class="layui-icon iconfont icon-reset"></i>Log
        </button>
    </div>
</script>
<script type="text/html" id="table-toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-xs" lay-event="modify" lay-tips="修改">
            <i class="layui-icon layui-icon-edit"></i></button>
        <button class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del" lay-tips="删除该条">
            <i class="layui-icon layui-icon-delete"></i></button>
        <button class="layui-btn layui-btn-xs layui-btn-primary" lay-event="log" lay-tips="查看日志">
            <i class="layui-icon layui-icon-log"></i>
        </button>
    </div>
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let form = layui.form,
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
                {field: 'id', title: 'ID', hide: true},
                {
                    field: 'pc_enabled', title: 'PC', align: 'center', width: 92, unresize: true, event: 'pc_enabled',
                    templet: function (d) {
                        return '<input data-id="' + d.id + '" type="checkbox" lay-skin="switch" lay-text="启用|关闭" lay-filter="togglePcEnabled"' + (d['pc_enabled'] ? ' checked>' : '>');
                    }
                },
                {
                    field: 'mobile_enabled',
                    title: 'Mobile',
                    align: 'center',
                    width: 92,
                    unresize: true,
                    event: 'mobile_enabled',
                    templet: function (d) {
                        return '<input data-id="' + d.id + '" type="checkbox" lay-skin="switch" lay-text="启用|关闭" lay-filter="toggleMobileEnabled"' + (d['mobile_enabled'] ? ' checked>' : '>');
                    }
                },
                {field: 'username', title: '用户名', hide: true},
                {field: 'alias', title: '别名', minWidth: 100},
                {field: 'wechat', title: '微信', hide: true},
                {field: 'phone', title: '手机', minWidth: 100},
                {field: 'uv', title: 'UV', minWidth: 100},
                {field: 'pv', title: 'PV', minWidth: 100},
                {field: 'qr', title: '二维码', hide: true},
                {field: 'token', title: 'Token', hide: true},
                {field: 'weight', title: '权重', hide: true},
                {field: 'style_id', title: '样式', hide: true},
                {field: 'history_enabled', title: '历史记录', hide: true},
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
                            data: {id: data.id},
                            index: index,
                            ending: obj.del
                        });
                    });
                    break;
                case 'modify':
                    $.get(url + "/modify", {id: data.id}, function (html) {
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
                                    let field = main.formData(dom.selector);
                                    if (field.durations instanceof Array) {
                                        field.durations = field.durations.join();
                                    }
                                    if (typeof field.durations === 'undefined') {
                                        field.durations = '';
                                    }
                                    main.req({
                                        url: url + '/modify',
                                        data: field,
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
                                        if (this.data.durations instanceof Array) {
                                            this.data.durations = this.data.durations.join();
                                        }
                                        if (typeof this.data.durations === 'undefined') {
                                            this.data.durations = '';
                                        }
                                        loading = layer.load(1, {shade: [0.7, '#000', true]});
                                    },
                                    choose: function (obj) {
                                        obj.preview(function (index, file, result) {
                                            $('#uploadResult').html('<img height="130" width="130" alt="二维码" src="' + result + '" title="' + file.name + '"/>');
                                        });
                                    },
                                    done: function (res, index) {
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
                                    error: function (index) {
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
                case 'log':
                    main.ws.log('contact.' + data.id);
                    break;
            }
        });
        //头工具栏事件
        table.on('toolbar(table-list)', function (obj) {
            let checkStatus = table.checkStatus(obj.config.id),
                data = checkStatus.data, ids = [];
            for (let i = 0; i < data.length; i++) {
                ids[i] = data[i].id;
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
                                    let field = main.formData(dom.selector);
                                    if (field.durations instanceof Array) {
                                        field.durations = field.durations.join();
                                    }
                                    main.req({
                                        url: url + '/add',
                                        data: field,
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
                                        if (this.data.durations instanceof Array) {
                                            this.data.durations = this.data.durations.join();
                                        }
                                        loading = layer.load(1, {shade: [0.7, '#000', true]});
                                    },
                                    choose: function (obj) {
                                        obj.preview(function (index, file, result) {
                                            $('#uploadResult').html('<img height="130" width="130" alt="二维码" src="' + result + '" title="' + file.name + '"/>');
                                        });
                                    },
                                    done: function (res, index) {
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
                                    error: function (index) {
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
                            data: {ids: ids.join()},
                            index: index,
                            ending: 'table-list'
                        });
                    });
                    break;
                case 'setup':
                    if (data.length === 0) {
                        return layer.msg('请选择数据');
                    }
                    $.get(url + '/setup', {ids: ids.join()}, function (html) {
                        layer.open({
                            title: '批量设置',
                            content: html,
                            type: 1,
                            shadeClose: true,
                            scrollbar: false,
                            btnAlign: 'c',
                            shade: 0.8,
                            fixed: false,
                            maxmin: true,
                            btn: ['提交', '取消'],
                            area: ['90%', '90%'],
                            yes: function (index, dom) {
                                dom.find('*[lay-submit]').click();
                            },
                            success: function (dom, layerIndex) {
                                form.render();
                                form.on('submit(setupSubmit)', function () {
                                    let field = main.formData(dom.selector);
                                    field.cols = [];
                                    dom.find('.layui-form [name]').each(function (i, v) {
                                        if (v.disabled === false && v.name && v.name !== 'cols' && field.cols.indexOf(v.name) === -1) {
                                            field.cols.push(v.name);
                                        }
                                    });
                                    if (field.durations instanceof Array) {
                                        field.durations = field.durations.join();
                                    } else if (dom.find('[lay-filter="duration"]').length > 0) {
                                        field.cols.push('durations');
                                    }
                                    field.cols = field.cols.join();
                                    main.req({
                                        url: url + '/update',
                                        data: field,
                                        index: layerIndex,
                                        ending: 'table-list'
                                    });
                                });
                            }
                        });
                    });
                    break;
                case 'reset-token':
                    if (data.length === 0) {
                        return layer.msg('请选择数据');
                    }
                    layer.confirm('重置Token后会影响客服接待数据，确定重置？', function (index) {
                        main.req({
                            url: url + '/update',
                            data: {ids: ids.join(), token: ''},
                            index: index,
                            ending: 'table-list'
                        });
                    });
                    break;
                case 'log':
                    main.ws.log('contact.0');
                    break;
                case 'reset-record':
                    main.reset.log('contact', ids);
                    break;
            }
        });
        // 切换PC端
        form.on('switch(togglePcEnabled)', function (obj) {
            let id = $(this).attr('data-id'),
                checked = this.checked;
            if (!id) {
                layer.tips('ID为空，无法操作！', obj.othis);
                return false;
            }
            main.req({
                url: url + '/update',
                data: {id: id, pc_enabled: checked},
                ending: 'table-list',
            });
            return false;
        });
        // 切换移动端
        form.on('switch(toggleMobileEnabled)', function (obj) {
            let id = $(this).attr('data-id'),
                checked = this.checked;
            if (!id) {
                layer.tips('ID为空，无法操作！', obj.othis);
                return false;
            }
            main.req({
                url: url + '/update',
                data: {id: id, mobile_enabled: checked},
                ending: 'table-list',
            });
            return false;
        });
        //监听搜索
        form.on('submit(search)', function (data) {
            let field = data.field;
            //执行重载
            table.reload('table-list', {
                where: field,
                page: {curr: 1}
            });
            return false;
        });
        // enter 搜索
        $('input[name=username]').keydown(function (event) {
            if (event.keyCode === 13) {
                $('[lay-filter="search"]').click();
            }
        });
    });
</script>