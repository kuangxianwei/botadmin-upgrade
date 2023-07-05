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
                <input type="text" autocomplete="off" name="search" class="layui-input" placeholder="输入搜索...">
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
            <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="addMany" lay-tips="批量添加">
                <i class="layui-icon iconfont icon-batchadd"></i>
            </button>
            <button class="layui-btn layui-btn-sm layui-btn-normal" lay-event="config">
                <i class="layui-icon layui-icon-set"></i>
            </button>
        </div>
        <div class="layui-btn-group">
            <ul class="layui-nav layui-bg-green botadmin-nav">
                <li class="layui-nav-item">
                    <a href="javascript:" lay-tips="操作用户信息" lay-direction="2">
                        <i class="layui-icon layui-icon-user"></i>
                    </a>
                    <dl class="layui-nav-child">
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="setProfile" lay-tips="设置用户信息">
                                设置信息
                            </button>
                        </dd>
                        <dd>
                            <button class="layui-btn layui-btn-sm" lay-event="getProfile" lay-tips="拉取用户信息">
                                拉取信息
                            </button>
                        </dd>
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="validProfile" lay-tips="拉取用户信息">
                                检验账号
                            </button>
                        </dd>
                    </dl>
                </li>
            </ul>
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
            <button class="layui-btn layui-btn-sm layui-btn-warm" lay-event="del">删除</button>
            <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="truncate" lay-tips="清空所有的数据，不可恢复！">
                清空
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
        <button class="layui-btn layui-btn-xs layui-btn-primary" lay-event="log" lay-tips="查看日志">
            <i class="layui-icon layui-icon-log"></i>
        </button>
    </div>
</script>
<script type="text/html" id="config">
    <div class="layui-card">
        <div class="layui-card-body">
            <fieldset class="layui-elem-field layui-form">
                <legend>修改目标</legend>
                <input type="checkbox" data-field="enabled" title="启用/禁用" lay-filter="field">
                <input type="checkbox" data-field="alias" title="修改网名" lay-filter="field">
                <input type="checkbox" data-field="description" title="修改简介" lay-filter="field">
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
                {
                    field: 'enabled', title: '启用', width: 100, align: 'center',
                    event: 'enabled', templet: function (d) {
                        return '<input type="checkbox" lay-skin="switch" lay-text="启用|禁用"' + (d.enabled ? ' checked' : '') + '>';
                    }
                },
                {field: 'username', title: '用户名', width: 150, event: 'copy', sort: true},
                {field: 'password', title: '密码', event: 'copy', hide: true},
                {field: 'email', title: '邮箱', event: 'copy', hide: true},
                {field: 'email_password', title: '邮箱密码', event: 'copy', hide: true},
                {field: 'phone', title: '手机', event: 'copy', hide: true},
                {field: 'verify', title: '双重验证', event: 'copy', hide: true},
                {field: 'spare', title: '备用码', event: 'copy', hide: true},
                {field: 'alias', title: '网名', event: 'copy'},
                {field: 'description', title: '简介', hide: true},
                {field: 'token', title: 'Token', event: 'copy'},
                {field: 'twitter_id', title: '规则ID', width: 80, align: 'center', hide: true},
                {field: 'status', title: '状态', width: 120},
                {field: 'note', title: '备注', width: 120},
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
                        if (d.status.indexOf("ERR") !== -1) {
                            $('div[lay-id=table-list] tr[data-index=' + i + ']').css('background-color', '#ffb800')
                        }
                    });
                }
            },
        }, {
            enabled: function (obj) {
                let $this = $(this);
                let enabled = !!$this.find('div.layui-unselect.layui-form-onswitch').size();
                main.request({
                    url: url + "/modify",
                    data: {id: obj.data.id, enabled: enabled, cols: 'enabled'},
                    error: function () {
                        $this.find('input[type=checkbox]').prop('checked', !enabled);
                        form.render('checkbox');
                    }
                });
            },
            add: function () {
                main.get(url + '/add', function (html) {
                    main.popup({
                        title: '添加账号',
                        url: url + '/add',
                        area: ['800px', '550px'],
                        content: html,
                        done: 'table-list'
                    });
                });
            },
            addMany: function () {
                main.popup({
                    title: '批量添加账号',
                    url: url + '/add',
                    content: '<div class="layui-card layui-form" style="height: 98%">' +
                        '<textarea class="layui-textarea" name="values" style="height: 100%" placeholder="账号-----密码----邮箱&#10;账号-----密码----邮箱----邮箱密码&#10;账号-----密码----邮箱----token&#10;账号-----密码----手机号----token&#10;账号-----密码----邮箱----邮箱密码----token&#10;账号-----密码----邮箱----邮箱密码---手机号----Token&#10;账号----密码----邮箱账号----邮箱密码----双重验证秘钥----备用码"></textarea>' +
                        '<button class="layui-hide" lay-submit lay-filter="submit"></button>' +
                        '</div>',
                    done: 'table-list'
                });
            },
            modify: function (obj) {
                main.get(url + '/modify', {id: obj.data.id}, function (html) {
                    main.popup({
                        title: '修改规则',
                        content: html,
                        area: ['800px', '550px'],
                        url: url + '/modify',
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
                        let form = layui.form, fieldElem = $("#field"), active = {
                            enabled: function (show) {
                                if (show) {
                                    fieldElem.append(`<div class="layui-form-item">
                <label for="enabled" class="layui-form-label">启用:</label>
                <div class="layui-input-inline">
                    <input type="checkbox" name="enabled" id="enabled" lay-skin="switch" lay-text="启用|禁用" checked>
                </div>
            </div>`);
                                    form.render('checkbox');
                                } else {
                                    fieldElem.find('input[name=enabled]').closest('.layui-form-item').remove();
                                }
                            },
                            alias: function (show) {
                                if (show) {
                                    fieldElem.append(`<div class="layui-form-item">
                <label for="alias" class="layui-form-label">网名:</label>
                <div class="layui-input-block">
                    <input type="text" name="alias" id="alias" class="layui-input" placeholder="随机字符串变量:&#123;&#123;random&#125;&#125;">
                <div class="layui-form-mid layui-word-aux">随机字符串变量:&#123;&#123;random&#125;&#125;&#10;</div></div></div>`);
                                    form.render('input');
                                } else {
                                    fieldElem.find('input[name=alias]').closest('.layui-form-item').remove();
                                }
                            },
                            description: function (show) {
                                if (show) {
                                    fieldElem.append(`<div class="layui-form-item">
                <label for="description" class="layui-form-label">简介:</label>
                <div class="layui-input-block">
                    <textarea class="layui-textarea" name="description" id="description" rows="3" placeholder="这是我的简介"></textarea>
<div class="layui-form-mid layui-word-aux">随机字符串变量:&#123;&#123;random&#125;&#125;&#10;网名变量:&#123;&#123;alias&#125;&#125;</div></div></div>`);
                                    form.render('input');
                                } else {
                                    fieldElem.find('input[name=description]').closest('.layui-form-item').remove();
                                }
                            },
                        };
                        form.on('checkbox(field)', function (obj) {
                            let $this = $(this), field = $this.data("field");
                            active[field] && active[field].call($this, (obj.othis.attr('class').indexOf('layui-form-checked') !== -1));
                        });
                    },
                    url: url + '/modify',
                    done: 'table-list',
                });
            },
            setProfile: function (obj, ids) {
                if (main.isArray(ids)) {
                    return main.request({
                        url: url,
                        data: {ids: ids.join(','), action: 'set_profile'},
                    });
                }
                main.request({
                    url: url,
                    data: {id: obj.data.id, action: 'set_profile'},
                    done: function () {
                        main.ws.log("twitter_user." + obj.data.id);
                        return false
                    }
                });
            },
            getProfile: function (obj, ids) {
                if (main.isArray(ids)) {
                    return main.request({
                        url: url,
                        data: {ids: ids.join(','), action: 'get_profile'},
                    });
                }
                main.request({
                    url: url,
                    data: {id: obj.data.id, action: 'get_profile'},
                    done: function () {
                        main.ws.log("twitter_user." + obj.data.id);
                        return false
                    }
                });
            },
            validProfile: function (obj, ids) {
                if (main.isArray(ids)) {
                    return main.request({
                        url: url,
                        data: {ids: ids.join(','), action: 'valid_profile'},
                    });
                }
                main.request({
                    url: url,
                    data: {id: obj.data.id, action: 'valid_profile'},
                    done: function () {
                        main.ws.log("twitter_user." + obj.data.id);
                        return false
                    }
                });
            },
        });
    });
</script>