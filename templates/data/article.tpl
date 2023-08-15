<div class="layui-card">
    <div class="layui-form layui-card-header layuiadmin-card-header-auto" lay-event="search">
        <div class="layui-inline">
            <input type="text" autocomplete="off" name="ids" placeholder="搜索ID:1,2,3" class="layui-input">
        </div>
        <div class="layui-inline">
            <input class="layui-input" type="text" autocomplete="off" name="title" placeholder="请输入标题部分或全部">
        </div>
        <div class="layui-inline" style="width: 80px" lay-tips="原创度 例如:70.00">
            <input type="number" autocomplete="off" name="originality_rate" placeholder="70.00" class="layui-input">
        </div>
        <div class="layui-inline">
            <select name="site_id" lay-filter="search-select" lay-search>
                <option value="">隶属网站</option>
                {{range .sites -}}
                    <option value="{{.Id}}">{{.Vhost}}</option>
                {{end -}}
            </select>
        </div>
        <div class="layui-inline" style="width: 100px">
            <select name="used" lay-filter="search-select" lay-search>
                <option value="">使用状态</option>
                <option value="true">已使用</option>
                <option value="false">未使用</option>
            </select>
        </div>
        <div class="layui-inline" style="width: 100px">
            <select name="trans_failed" lay-filter="search-select" lay-search>
                <option value="">翻译状态</option>
                <option value="true">已出错</option>
                <option value="false">未出错</option>
            </select>
        </div>
        <div class="layui-inline" style="width: 100px">
            <select name="originality" lay-filter="search-select">
                <option value="">原创状态</option>
                <option value="0">不检验</option>
                <option value="1">未检验</option>
                <option value="2">已检验</option>
            </select>
        </div>
        <button class="layui-btn" data-type="reload" lay-submit lay-filter="search">
            <i class="layui-icon layui-icon-search layuiadmin-button-btn"></i>
        </button>
    </div>
    <div class="layui-card-body">
        <table id="table-list" lay-filter="table-list"></table>
    </div>
</div>
<script type="text/html" id="toolbar">
    <div class="layui-btn-container">
        <div class="layui-btn-group">
            <button class="layui-btn layui-btn-sm" lay-event="import" lay-tips="导入 tag.gz|.zip 格式的压缩文件">
                <i class="layui-icon iconfont icon-import"></i>
            </button>
            <button class="layui-btn layui-btn-sm" lay-event="export" lay-tips="导出文章">
                <i class="layui-icon iconfont icon-export"></i>
            </button>
            <button class="layui-btn layui-btn-sm" lay-event="configure" lay-tips="批量修改配置">
                <i class="layui-icon layui-icon-set"></i>
            </button>
        </div>
        <div class="layui-btn-group">
            <button class="layui-btn layui-btn-sm" lay-event="ban" id="LAY_layer_iframe_ban"
                    lay-tips="过滤违禁词">
                <i class="layui-icon layui-icon-find-fill"></i>检违禁
            </button>
            <button class="layui-btn layui-btn-sm" lay-event="originalityExec">
                <i class="layui-icon layui-icon-vercode"></i>检原创
            </button>
            <button class="layui-btn layui-btn-sm" lay-event="conversionExec">
                转换简繁体
            </button>
        </div>
        <div class="layui-btn-group">
            <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="del" id="LAY_layer_iframe_del"
                    lay-tips="删除选中的文章列表">
                <i class="layui-icon layui-icon-delete"></i>
            </button>
            <button class="layui-btn layui-btn-sm  layui-btn-danger" lay-event="delUsed"
                    id="LAY_layer_iframe_delUsed" lay-tips="删除所有已经发布过的文章">
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
        <div class="layui-btn-group">
            <button class="layui-btn layui-btn-sm" lay-event="log" lay-tips="查看日志">
                <i class="layui-icon layui-icon-log"></i>
            </button>
            <button class="layui-btn layui-btn-sm layui-bg-red" lay-event="resetLog" lay-tips="重置日志">
                <i class="layui-icon iconfont icon-reset"></i>Log
            </button>
        </div>
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
            <i class="layui-icon layui-icon-log"></i>
        </button>
    </div>
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let main = layui.main,
            form = layui.form;
        main.upload();
        main.table([[
            {type: 'checkbox', fixed: 'left'},
            {field: 'id', title: 'ID', hide: true},
            {
                field: 'title',
                title: '标题',
                event: 'modify',
                style: 'cursor:pointer;color:#01aaed;font-weight:bold'
            },
            {
                field: 'originality_rate',
                title: '原创率',
                align: 'center',
                sort: true,
                width: 120,
                hide: true,
                templet: function (d) {
                    let val = (d['originality_rate'] * 100).toFixed(2) + '%';
                    if (d['originality_rate'] < 0.35) {
                        return '<b style="color: red">' + val + '</b>';
                    }
                    if (d['originality_rate'] > 0.69) {
                        return '<b style="color:#01aaed;">' + val + '</b>';
                    }
                    return val;
                },
            },
            {field: 'description', title: '描述', hide: true},
            {field: 'tags', title: 'Tags', hide: true},
            {field: 'site_id', title: '绑定网站ID', hide: true},
            {field: 'class_id', title: '文章ID', hide: true},
            {
                field: 'used', title: '已使用', align: 'center', width: 92, unresize: true, event: 'switch',
                sort: true,
                templet: function (d) {
                    return '<input type="checkbox" lay-skin="switch" lay-text="是|否"' + (d.used ? ' checked>' : '>');
                }
            },
            {
                field: 'ban_vetted',
                title: '滤违禁',
                align: 'center',
                width: 92,
                unresize: true,
                event: 'switch',
                sort: true,
                templet: function (d) {
                    return '<input type="checkbox" lay-skin="switch" lay-text="是|否"' + (d['ban_vetted'] ? ' checked>' : '>');
                },
            },
            {
                field: 'trans_failed',
                title: '译错',
                align: 'center',
                width: 92,
                event: 'switch',
                templet: function (d) {
                    return '<input type="checkbox" lay-skin="switch" lay-text="是|否"' + (d.trans_failed ? ' checked>' : '>');
                },
                sort: true
            },
            {
                field: 'updated', title: '时间', align: 'center', width: 180, sort: true, templet: function (d) {
                    return main.timestampFormat(d['updated']);
                }
            },
            {title: '操作', width: 120, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}]], {
            modify: function (obj) {
                main.get(URL + '/modify', {id: obj.data.id}, function (html) {
                    main.popup({
                        title: '修改文章',
                        url: URL + '/modify',
                        content: html,
                        done: 'table-list',
                    });
                });
            },
            configure: function (obj, ids) {
                if (obj.data.length === 0) {
                    layer.msg('请勾选数据', {icon: 2});
                    return false;
                }
                main.get(URL + '/configure', {ids: ids.join()}, function (html) {
                    main.popup({
                        title: "批量修改配置",
                        content: html,
                        url: URL + '/configure',
                        done: 'table-list',
                    });
                });
            },
            originalityExec: function (obj, ids) {
                if (obj.data.length === 0) {
                    layer.msg('请勾选数据', {icon: 2});
                    return false;
                }
                main.request({
                    url: URL + '/original',
                    data: {ids: ids.join()},
                    done: function () {
                        main.ws.log('article.0');
                        return false;
                    },
                });
            },
            conversionExec: function (obj, ids) {
                if (obj.data.length === 0) {
                    layer.msg('请勾选数据', {icon: 2});
                    return false;
                }
                main.get(URL + '/convert', {ids: ids.join()}, function (html) {
                    main.popup({
                        title: '简繁体转换',
                        content: html,
                        url: URL + '/convert',
                        area: ['280px', '300px'],
                        done: 'table-list'
                    });
                });
            },
            originality: function (obj, ids) {
                if (obj.data.length === 0) {
                    layer.msg('请勾选数据', {icon: 2});
                    return false;
                }
                let val = this.value;
                main.request({
                    url: URL + '/original',
                    data: {ids: ids.join(), originality: val},
                    done: "table-list"
                });
            },
            ban: function (obj, ids) {
                if (obj.data.length === 0) {
                    layer.msg('请勾选数据', {icon: 2});
                    return false;
                }
                main.request({
                    url: URL + '/ban',
                    data: {thread: obj.data.length, ids: ids.join()},
                    done: function () {
                        main.ws.log('article.0');
                        return false;
                    }
                });
            },
            case: function () {
                main.get(URL + '/case', function (html) {
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
            },
            translate: function (obj, ids) {
                if (obj.data.length === 0) {
                    layer.msg('请勾选数据', {icon: 2});
                    return false;
                }
                main.get(URL + '/translate', {ids: ids.join()}, function (html) {
                    main.popup({
                        title: '翻译',
                        content: html,
                        url: URL + '/translate',
                        area: ['750px', '300px'],
                        done: function () {
                            main.ws.log('article.0');
                            return false;
                        },
                    });
                    form.render();
                });
            },
            delUsed: function () {
                layer.confirm('删除所有已经发布是文章列表？', function (index) {
                    main.request({
                        url: URL + '/del/used',
                        index: index,
                        done: 'table-list'
                    });
                });
            },
        });
    });
</script>