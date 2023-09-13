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
        <button class="layui-btn layui-btn-sm" lay-event="configure">
            <i class="layui-icon layui-icon-set"></i>
        </button>
    </div>
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm" lay-event="log" lay-tips="查看日志">
            <i class="layui-icon layui-icon-log"></i>
        </button>
        <button class="layui-btn layui-btn-sm layui-bg-red" lay-event="resetLog" lay-tips="重置日志">
            <i class="layui-icon iconfont icon-reset"></i>Log
        </button>
    </div>
</script>
<script type="text/html" id="table-toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-xs" lay-event="modify" lay-tips="修改">
            <i class="layui-icon layui-icon-edit"></i></button>
        <button class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del" lay-tips="删除该条">
            <i class="layui-icon layui-icon-delete"></i></button>
        <button class="layui-btn layui-btn-xs" lay-event="testEmail" lay-tips="测试发送邮件">
            <i class="layui-icon layui-icon-email"></i>
        </button>
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
            upload = layui.upload;
        main.table([[
            {type: 'checkbox', fixed: 'left'},
            {field: 'id', title: 'ID', hide: true},
            {
                field: 'pc_enabled', title: 'PC', align: 'center', width: 100, unresize: true,
                event: 'switch',
                templet: function (d) {
                    return '<input type="checkbox" lay-skin="switch" lay-text="启用|关闭"' + (d['pc_enabled'] ? ' checked>' : '>');
                }
            },
            {
                field: 'mobile_enabled',
                title: 'Mobile',
                align: 'center',
                width: 100,
                event: 'switch',
                templet: function (d) {
                    return '<input type="checkbox" lay-skin="switch" lay-text="启用|关闭"' + (d['mobile_enabled'] ? ' checked>' : '>');
                }
            },
            {field: 'username', title: '用户名', hide: true},
            {field: 'alias', title: '别名', minWidth: 100},
            {field: 'wechat', title: '微信', hide: true},
            {field: 'phone', title: '手机', minWidth: 100},
            {field: 'uv', title: 'UV', minWidth: 100},
            {field: 'pv', title: 'PV', minWidth: 100},
            {
                title: '跟踪', width: 60, align: 'center',
                templet: function (d) {
                    return '<a style="color:#27818a;" lay-href="/trace?waiter_id=' + d.id + '" lay-text="跟踪-' + d.alias + '"><i class="iconfont icon-trace"></i></a>';
                }
            },
            {field: 'qr', title: '二维码', hide: true},
            {field: 'weight', title: '权重', hide: true},
            {field: 'style_id', title: '样式', hide: true},
            {field: 'history_enabled', title: '历史记录', hide: true},
            {field: 'other', title: '其他', hide: true},
            {title: '操作', width: 150, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
        ]], {
            modify: function (obj) {
                main.get(URL + "/modify", {id: obj.data.id}, function (html) {
                    let loading;
                    main.popup({
                        title: "修改客服",
                        url: URL + "/modify",
                        content: html,
                        area: ['95%', '95%'],
                        success: function (dom, layerIndex) {
                            upload.render({
                                elem: '#uploadFile',
                                url: URL + '/modify',
                                headers: {'X-CSRF-Token': CSRF_TOKEN},
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
                                        $('#uploadResult').attr("data-filename", file.name).html('<img height="130" width="130" alt="二维码" src="' + result + '" title="' + file.name + '"/>');
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
                                    main.error(res.msg);
                                },
                                error: function (index) {
                                    layer.close(index);
                                    layer.close(loading);
                                    main.error("网络错误");
                                },
                            });
                        },
                        yes: function (index, dom) {
                            let arr = [];
                            dom.find('input[name=duration]').each(function () {
                                let val = $(this).val();
                                if (val && arr.indexOf(val) === -1) {
                                    arr.push(val);
                                }
                            });
                            if (arr) {
                                dom.find('input[name=durations]').val(arr.join(","));
                            }
                            if (dom.find('#uploadResult').data("filename")) {
                                dom.find('#uploadSubmit').click();
                                return false;
                            }
                        },
                        done: 'table-list'
                    });
                });
            },
            testEmail: function (obj) {
                main.request({
                    url: URL + "/email/test",
                    data: {id: obj.data.id}
                });
            },
            add: function () {
                main.get(URL + '/add', {}, function (html) {
                    let loading;
                    main.popup({
                        title: "添加客服",
                        url: URL + "/add",
                        content: html,
                        area: ['95%', '95%'],
                        success: function (dom, layerIndex) {
                            upload.render({
                                elem: '#uploadFile',
                                url: URL + '/add',
                                headers: {'X-CSRF-Token': CSRF_TOKEN},
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
                                        $('#uploadResult').attr("data-filename", file.name).html('<img height="130" width="130" alt="二维码" src="' + result + '" title="' + file.name + '"/>');
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
                                    main.error(res.msg);
                                },
                                error: function (index) {
                                    layer.close(index);
                                    layer.close(loading);
                                    main.error("网络错误");
                                },
                            });
                        },
                        yes: function (index, dom) {
                            let arr = [];
                            dom.find('input[name=duration]').each(function () {
                                let val = $(this).val();
                                if (val && arr.indexOf(val) === -1) {
                                    arr.push(val);
                                }
                            });
                            if (arr) {
                                dom.find('input[name=durations]').val(arr.join(","));
                            }
                            if (dom.find('#uploadResult').data("filename")) {
                                dom.find('#uploadSubmit').click();
                                return false;
                            }
                        },
                        done: 'table-list'
                    });
                });
            },
            configure: function (obj, ids) {
                if (obj.data.length === 0) {
                    return layer.msg('请选择数据');
                }
                main.get(URL + '/configure', {ids: ids.join()}, function (html) {
                    main.popup({
                        title: '批量设置',
                        content: html,
                        url: URL + '/modify',
                        done: 'table-list',
                        area: ['95%', '95%'],
                        yes: function (index, dom) {
                            let field = main.formData(dom);
                            if (Array.isArray(field['duration'])) {
                                dom.find('[name=durations]').val(field['duration'].join());
                            }
                        },
                    });
                });
            },
        });
    });
</script>