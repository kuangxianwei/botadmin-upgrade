<div class="layui-card">
    <div class="layui-card-body">
        <div class="layui-form table-search" style="left:560px">
            <div class="layui-inline">
                <select name="enabled" class="layui-select" lay-filter="search-select">
                    <option value="">全部</option>
                    <option value="false">禁用</option>
                    <option value="true">启用</option>
                </select>
            </div>
            <div class="layui-inline">
                <input type="search" name="search" class="layui-input" placeholder="输入搜索...">
            </div>
            <button class="layui-btn layui-btn-sm" lay-submit="" lay-filter="search">
                <i class="layui-icon layui-icon-search"></i>
            </button>
        </div>
        <table id="table-list" lay-filter="table-list"></table>
    </div>
</div>
<script type="text/html" id="toolbar">
    <div class="layui-btn-container">
        <div class="layui-btn-group">
            <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="add" lay-tips="单个添加">
                <i class="layui-icon layui-icon-add-circle"></i>
            </button>
            <button class="layui-btn layui-btn-sm layui-btn-normal" lay-event="config">
                <i class="layui-icon layui-icon-set"></i>
            </button>
            <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="do" lay-tips="开始互动">
                <i class="layui-icon layui-icon-play"></i>
            </button>
        </div>
        <div class="layui-btn-group">
            <button class="layui-btn layui-btn-sm" lay-event="export" lay-tips="导出配置列表">
                <i class="layui-icon iconfont icon-export"></i>
            </button>
            <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="import" lay-tips="导入配置列表">
                <i class="layui-icon iconfont icon-import"></i>
            </button>
        </div>
        <div class="layui-btn-group">
            <ul class="layui-nav layui-bg-green botadmin-nav">
                <li class="layui-nav-item">
                    <a href="javascript:" lay-tips="定时发布推文任务" lay-direction="2">
                        <i class="layui-icon iconfont icon-work"></i>
                        <cite>任务</cite>
                    </a>
                    <dl class="layui-nav-child">
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-fluid" lay-event="crontab" data-value="twitter_interaction.">
                                查看任务
                            </button>
                        </dd>
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-bg-red layui-btn-fluid" lay-event="switch" data-field="enabled">
                                关闭任务
                            </button>
                        </dd>
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-fluid" lay-event="switch" data-field="enabled" data-value="true">
                                开启任务
                            </button>
                        </dd>
                    </dl>
                </li>
            </ul>
        </div>
        <div class="layui-btn-group">
            <button class="layui-btn layui-btn-sm layui-btn-warm" lay-event="del">删除</button>
            <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="truncate" lay-tips="清空所有的数据，不可恢复！">
                清空
            </button>
        </div>
        <div class="layui-btn-group">
            <button class="layui-btn layui-btn-sm" lay-event="log" data-value="twitter_interaction" lay-tips="查看日志">
                <i class="layui-icon layui-icon-log"></i>
            </button>
            <button class="layui-btn layui-btn-sm layui-bg-red" lay-event="resetLog" data-value="twitter_interaction" lay-tips="重置日志">
                <i class="layui-icon iconfont icon-reset"></i>Log
            </button>
        </div>
    </div>
</script>
<script type="text/html" id="table-toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-xs layui-btn-primary" lay-event="do" lay-tips="开始互动">
            <i class="layui-icon layui-icon-play"></i></button>
        <button class="layui-btn layui-btn-xs" lay-event="modify">
            <i class="layui-icon layui-icon-edit"></i>
        </button>
        <button class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del">
            <i class="layui-icon layui-icon-delete"></i>
        </button>
        <button class="layui-btn layui-btn-xs layui-btn-primary" lay-event="log" data-value="twitter_interaction" lay-tips="查看日志">
            <i class="layui-icon layui-icon-log"></i>
        </button>
    </div>
</script>
<script type="text/html" id="config">
    <div class="layui-card">
        <div class="layui-card-body">
            <fieldset class="layui-elem-field layui-form">
                <legend>修改目标</legend>
                <input type="checkbox" data-field="retweet" title="转发" lay-filter="field">
                <input type="checkbox" data-field="reply" title="回复" lay-filter="field">
                <input type="checkbox" data-field="like" title="点赞" lay-filter="field">
                <input type="checkbox" data-field="share" title="分享" lay-filter="field">
                <input type="checkbox" data-field="follow" title="关注" lay-filter="field">
            </fieldset>
            <fieldset class="layui-elem-field layui-form">
                <legend>操作</legend>
                <div id="field"></div>
                <div class="layui-hide">
                    <input name="ids" id="ids" value="">
                    <button lay-submit></button>
                </div>
            </fieldset>
        </div>
    </div>
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let main = layui.main, element = layui.element;
        main.upload();

        //日志管理
        main.table({
            cols: [[
                {type: 'checkbox', fixed: 'left'},
                {field: 'id', width: 80, title: 'ID', align: 'center', hide: true},
                {field: 'name', title: '名称', width: 150, event: 'copy', sort: true},
                {
                    field: 'enabled', title: '定时', width: 100, align: 'center',
                    event: 'switch', templet: function (d) {
                        return '<input type="checkbox" lay-skin="switch" lay-text="启用|禁用"' + (d.enabled ? ' checked' : '') + '>';
                    }
                },
                {
                    field: 'retweet', title: '转推', width: 100, align: 'center',
                    event: 'switch', templet: function (d) {
                        return '<input type="checkbox" lay-skin="switch" lay-text="启用|禁用"' + (d['retweet'] ? ' checked' : '') + '>';
                    }
                },
                {
                    field: 'reply', title: '回复', width: 100, align: 'center',
                    event: 'switch', templet: function (d) {
                        return '<input type="checkbox" lay-skin="switch" lay-text="启用|禁用"' + (d.reply ? ' checked' : '') + '>';
                    }
                },
                {
                    field: 'like', title: '点赞', width: 100, align: 'center',
                    event: 'switch', templet: function (d) {
                        return '<input type="checkbox" lay-skin="switch" lay-text="启用|禁用"' + (d['like'] ? ' checked' : '') + '>';
                    }
                },
                {
                    field: 'share', title: '分享', width: 100, align: 'center',
                    event: 'switch', templet: function (d) {
                        return '<input type="checkbox" lay-skin="switch" lay-text="启用|禁用"' + (d.share ? ' checked' : '') + '>';
                    }
                },
                {
                    field: 'follow', title: '关注', width: 100, align: 'center',
                    event: 'switch', templet: function (d) {
                        return '<input type="checkbox" lay-skin="switch" lay-text="启用|禁用"' + (d.follow ? ' checked' : '') + '>';
                    }
                },
                {field: 'target_count', title: '目标数', width: 80, align: 'center', hide: true},
                {field: 'targets', title: '目标列表', hide: true},
                {field: 'user_ids', title: '用户列表'},
                {field: 'texts', title: '回复列表', hide: true},
                {field: 'spec', title: '定时规则', hide: true},
                {
                    field: 'updated', title: '时间', align: 'center', sort: true, width: 180, hide: true,
                    templet: function (d) {
                        return main.timestampFormat(d['updated']);
                    }
                },
                {title: '操作', width: 120, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
            ]],
            done: function (res) {
                element.render();
                if (Array.isArray(res.data)) {
                    $.each(res.data, function (i, d) {
                        if (!d['user_ids'] || d['user_ids'].length === 0) {
                            $('div[lay-id=table-list] tr[data-index=' + i + ']>td').css('background-color', '#ffb800').attr('lay-tips', '用户列表为空，请指定用户列表')
                        }
                    });
                }
            },
        }, {
            add: function () {
                main.get(URL + '/add', function (html) {
                    main.popup({
                        title: '添加账号',
                        url: URL + '/add',
                        area: ['800px', '95%'],
                        content: html,
                        done: 'table-list'
                    });
                });
            },
            modify: function (obj) {
                main.get(URL + '/modify', {id: obj.data.id}, function (html) {
                    main.popup({
                        title: '修改规则',
                        content: html,
                        area: ['800px', '95%'],
                        url: URL + '/modify',
                        done: 'table-list',
                    });
                });
            },
            config: function (obj, ids) {
                if (ids.length === 0) {
                    return layer.msg('请选择数据');
                }
                main.popup({
                    title: '批量修改配置',
                    content: $('#config').html(),
                    area: ['500px', '580px'],
                    success: function (dom) {
                        dom.find('[name=ids]').val(ids.join());
                        let form = layui.form, fieldElem = $("#field"),
                            buildHTML = function (show, name, label) {
                                if (show) {
                                    fieldElem.append('<div class="layui-form-item"><label for="' + name + '" class="layui-form-label">' + label + ':</label><div class="layui-input-inline"><input type="checkbox" name="' + name + '" id="' + name + '" lay-skin="switch" lay-text="启用|禁用" checked></div></div>');
                                    form.render('checkbox');
                                } else {
                                    fieldElem.find('input[name=' + name + ']').closest('.layui-form-item').remove();
                                }
                            };
                        form.on('checkbox(field)', function (obj) {
                            let $this = $(this), field = $this.data("field");
                            buildHTML(obj.othis.attr('class').indexOf('layui-form-checked') !== -1, field, $this.attr("title"));
                        });
                    },
                    url: URL + '/modify',
                    done: 'table-list',
                });
            },
            do: function (obj, ids) {
                if (main.isArray(ids)) {
                    if (ids.length === 0) {
                        return layer.msg("未选择")
                    }
                    return main.request({
                        url: URL,
                        data: {ids: ids.join(), action: 'do'},
                    });
                }
                main.request({
                    url: URL,
                    data: {id: obj.data.id, action: 'do'},
                    done: function () {
                        main.ws.log("twitter_interaction." + obj.data.id);
                        return false
                    }
                });
            },
        });
    });
</script>