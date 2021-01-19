<div class="layui-card">
    <div class="layui-form layui-card-header layuiadmin-card-header-auto">
        <div class="layui-row">
            <div class="layui-col-md3">
                <label class="layui-form-label" lay-tips="输入标题的部分或者全部">标题:</label>
                <div class="layui-input-inline">
                    <input class="layui-input" type="text" name="title" placeholder="请输入标题" autocomplete="off">
                </div>
            </div>
            <div class="layui-col-md3">
                <label class="layui-form-label" lay-tips="显示原创度小于这个这个的文章">原创度:</label>
                <div class="layui-input-inline">
                    <input type="text" name="original_rate" placeholder="70.00" autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-col-md4">
                <label class="layui-form-label" lay-tips="选择指定网站的文章">网站:</label>
                <div class="layui-input-inline">
                    <select name="site_id" lay-filter="select_site_id" lay-search>
                        <option value="0">搜索...</option>
                        {{range .sites -}}
                            <option value="{{.Id}}">{{.Vhost}}</option>
                        {{end -}}
                    </select>
                </div>
            </div>
            <div class="layui-col-md1">
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
        <button class="layui-btn layui-btn-sm" lay-event="import" id="import" lay-tips="导入 tag.gz|.zip 格式的压缩文件">
            <i class="layui-icon iconfont icon-import"></i>
        </button>
        <button class="layui-btn layui-btn-sm" lay-event="export" lay-tips="导出文章">
            <i class="layui-icon iconfont icon-export"></i>
        </button>
    </div>
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm" lay-event="recover" id="LAY_layer_iframe_recover"
                lay-tips="把所有已经发布的文章恢复到未发布">
            <i class="layui-icon layui-icon-refresh-3"></i>恢复
        </button>
        <button class="layui-btn layui-btn-sm" lay-event="original" id="LAY_layer_iframe_original"
                lay-tips="检查原创度 不勾选则检测全部">
            <i class="layui-icon layui-icon-vercode"></i>
        </button>
        <button class="layui-btn layui-btn-sm" lay-event="ban" id="LAY_layer_iframe_ban"
                lay-tips="过滤违禁词 不勾选则选择全部">
            <i class="layui-icon layui-icon-find-fill"></i>
        </button>
    </div>
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="del" id="LAY_layer_iframe_del"
                lay-tips="删除选中的文章列表">
            <i class="layui-icon layui-icon-delete"></i>
        </button>
        <button class="layui-btn layui-btn-sm  layui-btn-danger" lay-event="delused"
                id="LAY_layer_iframe_delused" lay-tips="删除所有已经发布过的文章">
            <i class="layui-icon layui-icon-delete"></i>已发布
        </button>
        <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="truncate"
                id="LAY_layer_iframe_truncate" lay-tips="清空所有的文章数据，不可恢复！">
            <i class="layui-icon layui-icon-delete"></i>清空
        </button>
    </div>
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm" lay-event="case" id="LAY_layer_iframe_case"
                lay-tips="查看采集文章范本">范
        </button>
        <button class="layui-btn layui-btn-sm" lay-event="translate" id="LAY_layer_iframe_translate"
                lay-tips="翻译成指定的语言">译
        </button>
    </div>
</script>
<script type="text/html" id="table-toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-xs" lay-event="modify">
            <i class="layui-icon layui-icon-edit"></i>
        </button>
        <button class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del">
            <i class="layui-icon layui-icon-delete"></i>
        </button>
        <button class="layui-btn layui-btn-xs" lay-event="log" lay-tips="查看日志">
            <i class="layui-icon layui-icon-log"></i></button>
    </div>
</script>
{{template "JS" -}}
<script>
    JS.use(['index', 'main'], function () {
        let table = layui.table,
            main = layui.main,
            form = layui.form,
            upload = layui.upload,
            element = layui.element,
            url = {{.current_uri}};

        //日志管理
        table.render({
            headers: {'X-CSRF-Token':{{.csrf_token}}},
            method: 'post',
            elem: '#table-list',
            url: {{.current_uri}},
            toolbar: '#toolbar',
            cols: [[
                {type: 'checkbox', fixed: 'left'},
                {field: 'id', title: 'ID', hide: true},
                {field: 'title', title: '标题', event: 'modify', style: 'cursor:pointer;color:#01aaed;font-weight:bold'},
                {
                    field: 'original_rate',
                    title: '原创度',
                    align: 'center',
                    sort: true,
                    width: 120,
                    templet: function (d) {
                        if (d.original_rate < 70) {
                            return '<strong style="color:red;">' + d.original_rate.toFixed(2) + '%</strong>';
                        }
                        return '<strong style="color:#00a6ff;">' + d.original_rate.toFixed(2) + '%</strong>';
                    }
                },
                {field: 'description', title: '描述', hide: true},
                {field: 'tags', title: 'Tags', hide: true},
                {field: 'site_id', title: '绑定网站ID', hide: true},
                {field: 'class_id', title: '文章ID', hide: true},
                {
                    field: 'used', title: '使用', align: 'center', width: 92, unresize: true, event: 'used',
                    templet: function (d) {
                        let msg = '<input id="' + d.id + '" type="checkbox" name="used" lay-skin="switch" lay-text="是|否" lay-filter="switchUsed"';
                        if (d.used) {
                            msg += ' checked>';
                        } else {
                            msg += '>';
                        }
                        return msg;
                    }
                },
                {
                    field: 'ban_vetted', title: '过滤违禁', align: 'center', width: 92, unresize: true, event: 'ban_vetted',
                    templet: function (d) {
                        let msg = '<input id="' + d.id + '" type="checkbox" name="ban_vetted" lay-skin="switch" lay-text="是|否" lay-filter="switchBanVetted"';
                        if (d.ban_vetted) {
                            msg += ' checked>';
                        } else {
                            msg += '>';
                        }
                        return msg;
                    }
                },
                {field: 'updated', title: '时间', align: 'center', width: 180, sort: true},
                {title: '操作', width: 120, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
            ]],
            page: true,
            limit: 10,
            limits: [10, 15, 20, 25, 30, 200],
            done: function () {
                upload.render({
                    headers: {'X-CSRF-Token':{{.csrf_token}}},
                    elem: '#import',
                    url: url + '/import',
                    accept: 'file',
                    done: function (res) {
                        table.reload('table-list');
                        layer.msg(res.msg);
                    }
                });
            },
            text: '对不起，加载出现异常！'
        });
        //监听工具条
        table.on('tool(table-list)', function (obj) {
            let data = obj.data;
            switch (obj.event) {
                case 'del':
                    layer.confirm('删除后不可恢复，确定删除？', function (index) {
                        main.req({
                            url: url + '/del',
                            data: data,
                            index: index,
                            ending: 'table-list'
                        });
                    });
                    break;
                case 'modify':
                    $.get(url + '/modify', data, function (html) {
                        main.popup({
                            title: '修改文章',
                            url: url + '/modify',
                            content: html,
                            ending: 'table-list',
                        });
                        element.render();
                    });
                    break;
                case 'log':
                    $.get(url + '/log', data, function (html) {
                        main.popup({
                            title: '日志',
                            url: url + '/log',
                            content: html,
                        });
                    });
                    break;
            }
        });

        //监听工具栏
        table.on('toolbar(table-list)', function (obj) {
            let data = table.checkStatus(obj.config.id).data,
                isEmpty = data.length === 0,
                thread = isEmpty ? 10 : data.length,
                content = '',
                ids = Array();
            for (let i = 0; i < data.length; i++) {
                ids[i] = data[i].id;
            }
            switch (obj.event) {
                case 'add':
                    main.req({
                        url: url + '/add',
                        ending: 'table-list'
                    });
                    break;
                case 'del':
                    if (isEmpty) {
                        layer.msg('请勾选数据', {icon: 2});
                        return false;
                    }
                    layer.confirm('删除后不可恢复，确定删除选中吗？', function (index) {
                        main.req({
                            url: url + '/del',
                            data: {'ids': ids.join()},
                            index: index,
                            ending: 'table-list'
                        });
                    });
                    break;
                case 'truncate':
                    layer.confirm('清空全部数据，确定清空？', function (index) {
                        main.req({
                            url: url + '/truncate',
                            index: index,
                            ending: 'table-list'
                        });
                    });
                    break;
                case 'recover':
                    layer.confirm('把所有已经发布的文章更改为未发布？', function (index) {
                        main.req({
                            url: url + '/recover',
                            ids: ids.join(),
                            index: index,
                            ending: 'table-list'
                        });
                    });
                    break;
                case 'original':
                    content = '<div class="layui-card">\n<div class="layui-card-body layui-form">\n<div class="layui-form-item">\n<label class="layui-form-label">线程:</label>\n<div class="layui-input-inline">\n<input type="text" name="thread" value="thread" class="layui-input"/>\n</div>\n</div>\n<div class="layui-form-item">\n<label class="layui-form-label">强制:</label>\n<div class="layui-input-inline">\n<input type="checkbox" name="force" lay-skin="switch" lay-text="打开|关闭">\n</div>\n<div class="layui-form-mid layui-word-aux">不过滤已经检测过的</div>\n</div>\n<div class="layui-form-item">\n<div class="layui-hide">\n<input type="text" name="ids" value="ids" class="layui-input"/>\n<button class="layui-btn" lay-submit lay-filter="submit">立即提交</button>\n</div>\n</div>\n</div>\n</div>';
                    content = content.replace(/ value="thread"/, ' value="' + thread + '"');
                    content = content.replace(/ value="ids"/, ' value="' + ids.join() + '"');
                    main.popup({
                        title: '批量检测原创度',
                        content: content,
                        url: url + '/original',
                        area: ['400px', '280px'],
                    });
                    break;
                case 'ban':
                    main.req({
                        url: url + '/ban',
                        data: {thread: thread, ids: ids.join()},
                        ending: 'table-list'
                    });
                    break;
                case 'case':
                    $.get(url + '/case', {}, function (html) {
                        main.popup({
                            title: '采集范本',
                            content: html,
                            btn: ['关闭'],
                            yes: function (index) {
                                layer.close(index);
                                return false;
                            },
                        });
                    });
                    break;
                case 'translate':
                    if (isEmpty) {
                        layer.msg('请勾选数据', {icon: 2});
                        return false;
                    }
                    $.get(url + '/translate', {ids: ids.join()}, function (html) {
                        main.popup({
                            title: '翻译',
                            content: html,
                            url: url + '/translate',
                            area: ['750px', '400px'],
                        });
                        form.render();
                    });
                    break;
                case 'delused':
                    layer.confirm('删除所有已经发布是文章列表？', function (index) {
                        main.req({
                            url: url + '/delused',
                            index: index,
                            ending: 'table-list'
                        });
                    });
                    break;
                case 'export':
                    window.open(encodeURI(url + '/export?ids=' + ids.join()));
                    break;
            }
        });
        //监听搜索
        form.on('submit(search)', function (data) {
            let field = data.field;
            table.reload('table-list', {
                where: field,
                page: {curr: 1}
            });
            return false;
        });
        form.on('switch(switchUsed)', function (obj) {
            let id = this.id,
                checked = this.checked;
            if (!id) {
                layer.tips('ID为空，无法操作！', obj.othis);
                return false;
            }
            main.req({
                url: url + '/used',
                data: {'id': id, "used": checked},
                ending: 'table-list',
            });
            return false;
        });
        form.on('switch(switchBanVetted)', function (obj) {
            let id = this.id,
                checked = this.checked;
            if (!id) {
                layer.tips('ID为空，无法操作！', obj.othis);
                return false;
            }
            main.req({
                url: url + '/banvet',
                data: {'id': id, "ban_vetted": checked},
                ending: 'table-list',
            });
            return false;
        });
        //监控选择site id
        form.on('select(select_site_id)', function () {
            $('button[lay-filter=search]').click();
            return false;
        });
    });
</script>
