<div class="layui-card">
    <div class="layui-form layui-card-header layuiadmin-card-header-auto">
        <div class="layui-form-item" id="form-search">
            <div class="layui-inline">
                <label class="layui-form-label">域名</label>
                <div class="layui-input-inline">
                    <input type="text" name="vhost" placeholder="请输入" autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">状态</label>
                <div class="layui-input-inline">
                    <select name="status">
                        <option value="-1">无</option>
                        {{range $i,$v:=.status -}}
                            <option value="{{$i}}">{{$v}}</option>
                        {{end -}}
                    </select>
                </div>
            </div>
            <div class="layui-inline">
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
<div class="layui-hide" id="import"></div>
<script type="text/html" id="import-form">
    <div class="layui-card">
        <div class="layui-card-body layui-form">
            <div class="layui-form-item">
                <label class="layui-form-label">状态:</label>
                <div class="layui-input-inline">
                    <input type="checkbox" name="status" lay-skin="switch" lay-text="外站|保持" checked>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">MySQL:</label>
                <div class="layui-input-inline">
                    <input type="checkbox" name="sql" lay-skin="switch" lay-text="外站|保持" checked>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">FTP:</label>
                <div class="layui-input-inline">
                    <input type="checkbox" name="ftp" lay-skin="switch" lay-text="外站|保持" checked>
                </div>
            </div>
            <div class="layui-form-item layui-hide">
                <button lay-submit lay-filter="submit-import"></button>
            </div>
        </div>
    </div>
</script>
<script type="text/html" id="toolbar">
    <div class="layui-btn-container">
        <div class="layui-btn-group">
            <button class="layui-btn layui-btn-sm" lay-event="add" lay-tips="单个添加网站">
                <i class="layui-icon layui-icon-add-1"></i>
            </button>
            <button class="layui-btn layui-btn-sm" lay-event="batch" lay-tips="批量添加网站">
                <i class="layui-icon iconfont icon-batchadd"></i>
            </button>
            <button class="layui-btn layui-btn-sm" lay-event="edit" lay-tips="批量修改网站">
                <i class="layui-icon layui-icon-edit"></i>
            </button>
        </div>
        <div class="layui-btn-group">
            <ul class="layui-nav layui-bg-green botadmin-nav">
                <li class="layui-nav-item">
                    <a href="javascript:" lay-tips="建站" lay-direction="2">
                        <i class="layui-icon layui-icon-website"></i>
                        <cite>建站</cite>
                        <span class="layui-nav-more"></span>
                    </a>
                    <dl class="layui-nav-child">
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-fluid" lay-event="found">创建</button>
                        </dd>
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-fluid" lay-event="install">安装</button>
                        </dd>
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-fluid" lay-event="setup">配置</button>
                        </dd>
                    </dl>
                </li>
            </ul>
        </div>
        <div class="layui-btn-group">
            <ul class="layui-nav layui-bg-green botadmin-nav">
                <li class="layui-nav-item">
                    <a href="javascript:" lay-tips="重载" lay-direction="2">
                        <i class="layui-icon layui-icon-refresh"></i>
                        <cite>重载</cite>
                        <span class="layui-nav-more"></span>
                    </a>
                    <dl class="layui-nav-child">
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-fluid" lay-event="reload_nginx">Nginx
                            </button>
                        </dd>
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-fluid" lay-event="reload_website_setup">
                                网站配置
                            </button>
                        </dd>
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-fluid" lay-event="update_website">更新网站
                            </button>
                        </dd>
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-fluid" lay-event="reload_cron">定时任务
                            </button>
                        </dd>
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-fluid" lay-event="pull_config">拉取配置
                            </button>
                        </dd>
                    </dl>
                </li>
            </ul>
        </div>
        <div class="layui-btn-group">
            <button class="layui-btn layui-btn-sm" lay-event="publish" lay-tips="选中的网站发布文章">
                <i class="layui-icon layui-icon-release"></i>
            </button>
            <button class="layui-btn layui-btn-sm" lay-event="export" lay-tips="导出配置">
                <i class="layui-icon iconfont icon-export"></i>
            </button>
            <button class="layui-btn layui-btn-sm" lay-event="import" lay-tips="导入配置">
                <i class="layui-icon iconfont icon-import"></i>
            </button>
            <button class="layui-btn layui-btn-sm" lay-event="vhosts" lay-tips="获取全部主机列表">
                <i class="layui-icon layui-icon-fonts-code"></i>
            </button>
        </div>
        <div class="layui-btn-group">
            <ul class="layui-nav layui-bg-green botadmin-nav">
                <li class="layui-nav-item">
                    <a href="javascript:" lay-tips="SEO" lay-direction="2">
                        <i class="layui-icon layui-icon-service"></i>
                        <cite>SEO</cite>
                        <span class="layui-nav-more"></span>
                    </a>
                    <dl class="layui-nav-child">
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-fluid" lay-event="links">添加友链
                            </button>
                        </dd>
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-bg-red layui-btn-fluid" lay-event="del_links">
                                删除友链
                            </button>
                        </dd>
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-fluid" lay-event="rank">拉取百度排名
                            </button>
                        </dd>
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-fluid" lay-event="del-rank">删除百度排名
                            </button>
                        </dd>
                    </dl>
                </li>
            </ul>
        </div>
        <div class="layui-btn-group">
            <ul class="layui-nav layui-bg-green botadmin-nav">
                <li class="layui-nav-item">
                    <a href="javascript:" lay-tips="定时发布文章" lay-direction="2">
                        <i class="layui-icon iconfont icon-work"></i>
                        <cite>任务</cite>
                        <span class="layui-nav-more"></span>
                    </a>
                    <dl class="layui-nav-child">
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-fluid" lay-event="jobs">查看全部任务
                            </button>
                        </dd>
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-bg-red layui-btn-fluid"
                                    lay-event="cron-disable">关闭任务
                            </button>
                        </dd>
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-fluid" lay-event="cron-enable">
                                开启任务
                            </button>
                        </dd>
                    </dl>
                </li>
            </ul>

        </div>
    </div>
</script>
<script type="text/html" id="table-copy">
    <div class="layui-btn-group">
        <a class="layui-btn layui-btn-xs layui-bg-orange" lay-event="clipboard"
           data-type="user" lay-tips="复制登录用户名到粘贴板">
            <i class="layui-icon layui-icon-username"></i>
        </a>
        <a class="layui-btn layui-btn-xs layui-bg-orange" lay-event="clipboard"
           data-type="pwd" lay-tips="复制登录密码到粘贴板">
            <i class="layui-icon layui-icon-password"></i>
        </a>
        <a class="layui-btn layui-btn-xs layui-bg-orange" lay-event="clipboard"
           data-type="auth" lay-tips="复制登录认证码到粘贴板">
            <i class="layui-icon layui-icon-auz"></i>
        </a>
    </div>
</script>
<script type="text/html" id="table-toolbar">
    <div class="layui-btn-group">
        <a class="layui-btn layui-btn-xs" lay-event="modify" lay-tips="编辑">
            <i class="layui-icon layui-icon-edit"></i>
        </a>
        <a class="layui-btn layui-btn-xs" lay-event="rank" lay-tips="获取关键词排名">
            <i class="layui-icon layui-icon-layim-download"></i></a>
        <a class="layui-btn layui-btn-xs" lay-event="push" lay-tips="推送链接">
            <i class="layui-icon layui-icon-export"></i>
        </a>
        <a class="layui-btn layui-btn-xs layui-bg-cyan" lay-event="pic_dir" lay-tips="设置文章图片">
            <i class="layui-icon layui-icon-picture"></i>
        </a>
        <a class="layui-btn layui-btn-xs" lay-event="link" lay-tips="添加友链">
            加<i class="layui-icon layui-icon-link"></i>
        </a>
        <a class="layui-btn layui-btn-xs layui-bg-red" lay-event="del_link" lay-tips="删除友链">
            删<i class="layui-icon layui-icon-link"></i>
        </a>
        <a class="layui-btn layui-btn-xs layui-btn-primary" lay-event="log" lay-tips="查看日志">
            <i class="layui-icon layui-icon-log"></i>
        </a>
    </div>
</script>
<script type="text/html" id="push">
    <div class="layui-card">
        <div class="layui-card-body layui-form">
            <div class="layui-form-item">
                <label class="layui-form-label">数量:</label>
                <div class="layui-input-inline">
                    <input name="count" value="0">
                    <div class="layui-form-mid layui-word-aux">推送最后发布的N篇文章</div>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label" lay-tips="本网站的完整URL一行一条">Urls:</label>
                <div class="layui-input-block">
                    <textarea name="urls" class="layui-textarea" rows="6"></textarea>
                </div>
            </div>
            <div class="layui-form-item">
                <input type="hidden" name="id" value="">
                <button class="layui-hide" lay-filter="submit-push" lay-submit>提交</button>
            </div>
        </div>
    </div>
</script>
<script type="text/html" id="reload-setup">
    <div class="layui-card">
        <div class="layui-card-body layui-form">
            <div class="layui-form-item">
                <label class="layui-form-label">重载模板:</label>
                <div class="layui-input-inline">
                    <input type="checkbox" name="reload_tpl" lay-skin="switch" lay-text="是|否"/>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label" lay-tips="线程太多会卡死">线程:</label>
                <div class="layui-input-inline">
                    <input type="text" name="thread" value="10" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item layui-hide">
                <input name="ids" value="">
                <button lay-submit>提交</button>
            </div>
        </div>
    </div>
</script>
<script type="text/html" id="edit-options-html">
    <div class="layui-card">
        <div class="layui-card-body layui-form">
            <div class="layui-form-item">
                <label class="layui-form-label">选择修改项:</label>
                <div class="layui-input-block">
                    <input type="checkbox" name="ad" title="广告代码" checked>
                    <input type="checkbox" name="replaces" title="灰词替换">
                    <input type="checkbox" name="contact" title="联系方式">
                    <input type="checkbox" name="insert_pic_deg" title="插图阈值">
                    <input type="checkbox" name="pub_deg" title="发布阈值">
                    <input type="checkbox" name="content_deg" title="内容阈值">
                    <input type="checkbox" name="link_deg" title="内链阀值">
                    <input type="checkbox" name="out_link_deg" title="外链阀值">
                    <input type="checkbox" name="title_tag_deg" title="标题阀值">
                    <input type="checkbox" name="pub_self" title="指定发布">
                    <input type="checkbox" name="cron_enabled" title="定时发布">
                    <input type="checkbox" name="push_config" title="推送配置">
                </div>
            </div>
        </div>
    </div>
</script>
<script type="text/html" id="edit-html">
    <style>
        .layui-form i.layui-icon-delete {
            color: red;
            cursor: pointer;
        }

        .layui-form .layui-input-inline {
            min-width: 500px;
        }
    </style>
    <div class="layui-card">
        <div class="layui-card-body layui-form">
            <div class="layui-hide">
                <input type="text" name="ids" value="">
                <input type="text" name="cols" value="">
                <button lay-submit>提交</button>
            </div>
        </div>
    </div>
</script>
<script src="/static/modules/clipboard.min.js"></script>
{{template "JS" -}}
<script>
    JS.use(['index', 'main'], function () {
        let form = layui.form,
            table = layui.table,
            upload = layui.upload,
            element = layui.element,
            main = layui.main,
            url = {{.current_uri}},
            //渲染上传配置
            importConfig = upload.render({
                headers: {'X-CSRF-Token':{{.csrf_token}}},
                elem: '#import',
                url: '/site/import',
                accept: 'file',
                exts: 'txt|conf|json',
                before: function () {
                    layer.load(); //上传loading
                },
                done: function (res) {
                    layer.closeAll('loading'); //关闭loading
                    if (res.code === 0) {
                        layer.msg(res.msg);
                        table.reload('table-list');
                    } else {
                        layer.alert(res.msg, {icon: 2});
                    }
                },
            });
        //列表管理
        table.render({
            headers: {'X-CSRF-Token':{{.csrf_token}}},
            method: 'post',
            elem: '#table-list',
            toolbar: '#toolbar',
            url: {{.current_uri}},
            cols: [[
                {type: 'checkbox', fixed: 'left'},
                {field: 'id', title: 'ID', sort: true, width: 60, align: 'center', hide: true},
                {
                    field: 'cron_enabled', title: '定时发布', width: 100, align: 'center',
                    event: 'cron_switch', templet: function (d) {
                        return '<input type="checkbox" lay-skin="switch" lay-text="启用|关闭"' + (d.cron_enabled ? ' checked' : '') + '>';
                    }
                },
                {
                    field: 'vhost', title: '主域名',
                    style: 'cursor:pointer;color:#01aaed;font-weight:bold',
                    templet: function (d) {
                        if (d.status === 4) {
                            return d.vhost;
                        }
                        return '<a lay-href="/file?path=' + d['webroot_path'] + '" style="color:#01aaed">' + d.vhost + '</a>';
                    }
                },
                {
                    field: 'status', title: '状态', sort: true, width: 100, templet: function (d) {
                        switch (d.status) {
                            case 0:
                                return '准备就绪';
                            case 1:
                                return '创建完成';
                            case 2:
                                return '安装完成';
                            case 3:
                                return '本地-正常';
                            case 4:
                                return '外部-正常';
                        }
                        return '未知';
                    }
                },
                {
                    field: 'ftp_id', width: 80, title: 'FTP', align: 'center', event: 'ftp',
                    style: 'cursor:pointer;color:#01aaed;font-weight:bold'
                },
                {
                    field: 'sql_id', width: 80, title: 'MySQL', align: 'center', event: 'sql',
                    style: 'cursor:pointer;color:#01aaed;font-weight:bold'
                },
                {
                    field: 'admin_url', title: 'admin', align: 'center', event: 'login',
                    style: 'cursor:pointer;color:#01aaed;', width: 80, templet() {
                        return '登录';
                    }
                },
                {title: '复制', width: 126, align: 'center', fixed: 'right', toolbar: '#table-copy'},
                {field: 'web_user', title: '用户名', align: 'center', hide: true},
                {field: 'web_pwd', title: 'Pwd', align: 'center', hide: true},
                {field: 'auth_code', title: 'Auth', align: 'center', hide: true},
                {field: 'webroot_path', title: '网站路径', hide: true},
                {field: 'updated', title: '时间', sort: true, hide: true},
                {
                    field: 'id',
                    title: '删除',
                    width: 80,
                    event: 'del',
                    align: 'center',
                    style: 'cursor:pointer;color:red;',
                    hide: true,
                    templet: function () {
                        return '<i class="layui-icon layui-icon-delete"></i>';
                    }
                },
                {title: '操作', width: 260, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
            ],],
            where: {status: -1},
            page: true,
            limit: 10,
            limits: [10, 20, 100, 300, 500],
            text: '对不起，加载出现异常！',
            done: function () {
                element.render();
            }
        });

        //监听工具条
        table.on('tool(table-list)', function (obj) {
            let data = obj.data, othis = $(this);
            switch (obj.event) {
                case 'cron_switch':
                    let enabled = !!othis.find('div.layui-unselect.layui-form-onswitch').size();
                    main.req({
                        url: url + "/cron/switch",
                        data: {id: data.id, cron_enabled: enabled},
                        error: function () {
                            othis.find('input[type=checkbox]').prop("checked", !enabled);
                            form.render('checkbox');
                            return false;
                        }
                    });
                    break;
                case 'rank':
                    main.req({
                        url: '/site/rank',
                        tips: function (res) {
                            main.msg(res.msg);
                        },
                        data: data
                    });
                    break;
                case 'del':
                    layer.confirm('确定删除此条日志？', function (index) {
                        main.req({
                            url: url + '/del',
                            data: data,
                            ending: obj.del,
                            index: index
                        });
                    });
                    break;
                case 'modify':
                    $.get(url + '/modify', data, function (html) {
                        main.popup({
                            url: url + '/modify',
                            title: '修改网站设置',
                            content: html,
                            ending: 'table-list',
                        });
                        form.render();
                    });
                    break;
                case 'link':
                    $.get(url + '/link', data, function (html) {
                        main.popup({
                            url: url + '/link',
                            title: '添改友链',
                            content: html,
                            area: ['500px', '500px'],
                        });
                        form.render();
                    });
                    break;
                case 'del_link':
                    $.get(url + '/link', data, function (html) {
                        main.popup({
                            url: url + '/del/link',
                            title: '删除友链',
                            content: html,
                            area: ['500px', '500px'],
                        });
                        form.render();
                    });
                    break;
                case 'pic_dir':
                    $.get(url + '/image', data, function (html) {
                        main.popup({
                            url: url + '/image',
                            title: '添加图片',
                            content: html,
                            area: ['800px', '350px'],
                        });
                        form.render();
                    });
                    break;
                case "push":
                    let pushHtml = $('#push').html();
                    othis = $(pushHtml);
                    othis.find('input[name=id]').val(data.id);
                    main.popup({
                        url: '/site/push',
                        title: "推送",
                        content: othis.html()
                    });
                    break;
                case "ftp":
                    if (data.status === 4) {
                        layer.msg("外部网站不允许编辑FTP", {icon: 2});
                        return false;
                    }
                    $.get('/ftp/relationship',
                        {'id': data['ftp_id'], 'site_id': data.id, 'username': data.vhost},
                        function (html) {
                            main.popup({
                                url: '/ftp/relationship',
                                title: data['ftp_id'] > 0 ? '选择FTP' : '添加FTP',
                                content: html,
                                ending: 'table-list',
                            });
                            element.render();
                        });
                    break;
                case "sql":
                    if (data.status === 4) {
                        layer.msg("外部网站不允许编辑数据库", {icon: 2});
                        return false;
                    }
                    $.get('/sql/relationship',
                        {'id': data['sql_id'], 'site_id': data.id, 'username': data.vhost},
                        function (html) {
                            let title = data['sql_id'] > 0 ? '选择SQL' : '添加SQL';
                            main.popup({
                                url: '/sql/relationship',
                                title: title,
                                content: html,
                                ending: 'table-list',
                            });
                        });
                    break;
                case 'log':
                    $.get('/site/log', data, function (html) {
                        main.popup({
                            title: '日志',
                            content: html,
                            url: '/site/log',
                        });
                    });
                    break;
                case 'clipboard':
                    othis = $(this);
                    switch (othis.attr('data-type')) {
                        case 'user':
                            othis.attr('data-clipboard-text', data['web_user']);
                            break;
                        case 'pwd':
                            othis.attr('data-clipboard-text', data['web_pwd']);
                            break;
                        case 'auth':
                            othis.attr('data-clipboard-text', data['auth_code']);
                            break;
                        default:
                            layer.alert('出错了', {icon: 2})
                            return false;
                    }
                    let clipboard = new ClipboardJS('a[data-clipboard-text]');
                    clipboard.on('success', function (e) {
                        layer.msg('复制成功');
                        clipboard.destroy();  //解决多次弹窗
                        e.clearSelection();
                    });
                    break;
                case 'login':
                    window.open(data['admin_url'], '_blank');
                    break;
                default:
                    break;
            }
        });

        //头工具栏事件
        table.on('toolbar(table-list)', function (obj) {
            let data = table.checkStatus(obj.config.id).data,
                ids = Array();
            for (let i = 0; i < data.length; i++) {
                ids[i] = data[i].id;
            }
            switch (obj.event) {
                case 'edit':
                    if (data.length === 0) {
                        layer.msg("未选择", {icon: 2});
                        return false;
                    }
                    layer.open({
                        type: 1,
                        title: '批量修改配置',
                        shadeClose: true,
                        scrollbar: false,
                        btnAlign: 'c',
                        shade: 0.8,
                        fixed: false,
                        area: ['500px', '300px'],
                        maxmin: true,
                        zIndex: 200000,
                        btn: ['确定', '取消'],
                        content: $('#edit-options-html').html(),
                        success: function (dom, index) {
                            let uuid = main.uuid();
                            dom.find('.layui-form').append('<input type="hidden" name="ids" value="' + ids.join() + '">')
                                .append('<button class="layui-hide" lay-submit lay-filter="' + uuid + '"></button>');
                            form.render();
                            form.on('submit(' + uuid + ')', function (obj) {
                                let field = obj.field, count = 0;
                                for (let k in field) {
                                    if (field.hasOwnProperty(k)) {
                                        count++
                                    }
                                }
                                if (count < 2) {
                                    main.error('最少选择其中一项');
                                    return false;
                                }
                                layer.close(index);
                                main.popup({
                                    title: '批量修改配置',
                                    url: url + '/modify',
                                    content: $('#edit-html').html(),
                                    success: function (dom, index) {
                                        let formDom = dom.find('.layui-form');
                                        formDom.find('input[name=ids]').val(field.ids);
                                        delete field.ids;
                                        $.each(field, function (k, v) {
                                            switch (k) {
                                                case 'ad':
                                                    formDom.append(`<div class="layui-form-item"><label class="layui-form-label">广告代码:</label><div class="layui-input-inline"><textarea name="ad" class="layui-textarea"></textarea></div><i class="layui-icon layui-icon-delete" lay-event="del"></i></div>`);
                                                    break;
                                                case 'replaces':
                                                    formDom.append(`<div class="layui-form-item"><label class="layui-form-label">灰词替换:</label><div class="layui-input-inline"><textarea name="replaces" class="layui-textarea"></textarea></div><i class="layui-icon layui-icon-delete" lay-event="del"></i></div>`);
                                                    break;
                                                case 'contact':
                                                    formDom.append(`<div class="layui-form-item"><label class="layui-form-label">联系方式:</label><div class="layui-input-inline"><textarea name="contact" class="layui-textarea"></textarea></div><i class="layui-icon layui-icon-delete" lay-event="del"></i></div>`);
                                                    break;
                                                case 'insert_pic_deg':
                                                    formDom.append(`<div class="layui-form-item"><label class="layui-form-label">插图阈值:</label><div class="layui-input-inline"><input type="text" name="insert_pic_deg" value="1-3" class="layui-input"></div><i class="layui-icon layui-icon-delete" lay-event="del"></i></div>`);
                                                    break;
                                                case 'pub_deg':
                                                    formDom.append(`<div class="layui-form-item"><label class="layui-form-label">发布阈值:</label><div class="layui-input-inline"><input type="text" name="pub_deg" value="1-3" class="layui-input"></div><i class="layui-icon layui-icon-delete" lay-event="del"></i></div>`);
                                                    break;
                                                case 'content_deg':
                                                    formDom.append(`<div class="layui-form-item"><label class="layui-form-label">内容阈值:</label><div class="layui-input-inline"><input type="text" name="content_deg" value="1-3" class="layui-input"></div><i class="layui-icon layui-icon-delete" lay-event="del"></i></div>`);
                                                    break;
                                                case 'link_deg':
                                                    formDom.append(`<div class="layui-form-item"><label class="layui-form-label">内链阀值:</label><div class="layui-input-inline" style="margin-top:18px;"><div id="link_deg"></div><input type="hidden" name="link_deg" value="3"></div><i class="layui-icon layui-icon-delete" lay-event="del"></i><div class="layui-form-mid layui-word-aux">随机插入内链</div></div>`);
                                                    main.slider({elem: '#link_deg', value: 3});
                                                    break;
                                                case 'out_link_deg':
                                                    formDom.append(`<div class="layui-form-item"><label class="layui-form-label">外链阀值:</label><div class="layui-input-inline" style="margin-top:18px;"><div id="out_link_deg"></div><input type="hidden" name="out_link_deg" value="3"></div><i class="layui-icon layui-icon-delete" lay-event="del"></i><div class="layui-form-mid layui-word-aux">随机插入外链</div></div>`);
                                                    main.slider({elem: '#out_link_deg', value: 3});
                                                    break;
                                                case 'title_tag_deg':
                                                    formDom.append(`<div class="layui-form-item"><label class="layui-form-label">标题阀值:</label><div class="layui-input-inline" style="margin-top:18px;"><div id="title_tag_deg"></div><input type="hidden" name="title_tag_deg" value="3"></div><i class="layui-icon layui-icon-delete" lay-event="del"></i><div class="layui-form-mid layui-word-aux">标题插入tag 值越高 几率越高</div></div>`);
                                                    main.slider({elem: '#title_tag_deg', value: 3});
                                                    break;
                                                case 'pub_self':
                                                    formDom.append(`<div class="layui-form-item"><label class="layui-form-label">指定文章:</label><div class="layui-input-inline"><input type="checkbox" name="pub_self" lay-skin="switch" lay-text="是|否" checked></div><i class="layui-icon layui-icon-delete" lay-event="del"></i></div>`);
                                                    break;
                                                case 'cron_enabled':
                                                    formDom.append(`<div class="layui-form-item"><label class="layui-form-label">定时发布:</label><div class="layui-input-inline"><input type="checkbox" name="cron_enabled" lay-skin="switch" lay-text="是|否" checked></div><i class="layui-icon layui-icon-delete" lay-event="del"></i></div>`);
                                                    break;
                                                case 'push_config':
                                                    formDom.append(`<div class="layui-form-item"><label class="layui-form-label">推送配置:</label><div class="layui-input-inline"><textarea name="push_config" class="layui-textarea"></textarea></div><i class="layui-icon layui-icon-delete" lay-event="del"></i></div>`);
                                                    break;
                                            }
                                        });
                                        formDom.find('i[lay-event=del]').on('click', function () {
                                            $(this).parent().remove();
                                        });
                                    },
                                    yes: function (index, dom) {
                                        let cols = Array();
                                        dom.find('.layui-form [name]').each(function (i, v) {
                                            if (v.name && v.name !== 'cols') {
                                                cols.push(v.name);
                                            }
                                        });
                                        dom.find('.layui-form [name="cols"]').val(cols.join());
                                    },
                                    ending: 'table-list',
                                });
                                return false;
                            });
                        },
                        yes: function (index, dom) {
                            dom.find('button[lay-submit]').click();
                        },
                    });
                    break;
                case 'del':
                    if (data.length === 0) {
                        layer.msg("未选择", {icon: 2});
                        return false;
                    }
                    layer.confirm('删除后不可恢复，确定删除吗？', function (index) {
                        main.req({
                            url: url + '/del',
                            data: {'ids': ids.join()},
                            index: index,
                            ending: 'table-list',
                        });
                    });
                    break;
                case 'add':
                    $.get(url + '/add', {}, function (html) {
                        main.popup({
                            url: url + '/add',
                            title: '添加网站',
                            content: html,
                            ending: 'table-list',
                        });
                    });
                    break;
                case 'batch':
                    $.get(url + '/batch', {}, function (html) {
                        main.popup({
                            url: url + '/batch',
                            title: '批量添加网站',
                            content: html,
                            ending: 'table-list',
                        });
                    });
                    break;
                case 'found':
                    if (data.length === 0) {
                        layer.msg("未选择", {icon: 2});
                        return false;
                    }
                    main.req({
                        url: url + '/found',
                        data: {'ids': ids.join()},
                        tips: function (res) {
                            main.msg(res.msg);
                        },
                        ending: 'table-list',
                    });
                    break;
                case 'install':
                    if (data.length === 0) {
                        layer.msg("未选择", {icon: 2});
                        return false;
                    }
                    main.req({
                        url: url + '/install',
                        data: {'ids': ids.join()},
                        tips: function (res) {
                            main.msg(res.msg);
                        },
                        ending: 'table-list',
                    });
                    break;
                case 'setup':
                    if (data.length === 0) {
                        layer.msg("未选择", {icon: 2});
                        return false;
                    }
                    main.req({
                        url: url + '/setup',
                        data: {'ids': ids.join()},
                        tips: function (res) {
                            main.msg(res.msg);
                        },
                        ending: 'table-list',
                    });
                    break;
                case 'publish':
                    if (data.length === 0) {
                        layer.msg("未选择", {icon: 2});
                        return false;
                    }
                    layer.prompt({
                            formType: 0,
                            value: data.length,
                            title: '选中的网站发布文章，请输入线程数量 太多会卡死'
                        },
                        function (value, index) {
                            main.req({
                                url: url + '/publish',
                                data: {'ids': ids.join(), 'thread': value},
                                index: index,
                                tips: function (res) {
                                    main.msg(res.msg);
                                },
                                ending: 'table-list',
                            });
                        });
                    break;
                case 'reload_nginx':
                    layer.prompt({
                            formType: 0,
                            value: data.length,
                            title: '更新选中网站的NGINX配置，请输入线程数量 太多会卡死'
                        },
                        function (value, index) {
                            main.req({
                                url: url + '/reload/nginx',
                                data: {'ids': ids.join(), 'thread': value},
                                index: index,
                                tips: function (res) {
                                    main.msg(res.msg);
                                },
                                ending: 'table-list',
                            });
                        });
                    break;
                case 'reload_website_setup':
                    if (ids.length === 0) {
                        layer.msg('请选择数据', {icon: 2});
                        return false
                    }
                    let contentObj = $($("#reload-setup").html());
                    contentObj.find('*[name=ids]').attr('value', ids.join());
                    main.popup({
                        title: '重载Nginx',
                        content: contentObj.prop('outerHTML'),
                        url: url + '/reload/website/setup',
                        area: ['400px', '300px'],
                        tips: function (res) {
                            main.msg(res.msg);
                        },
                    });
                    break;
                case 'update_website':
                    layer.prompt({
                            formType: 0,
                            value: data.length,
                            title: '更新选中网站的文章和目录，请输入线程数量 太多会卡死'
                        },
                        function (value, index) {
                            main.req({
                                url: url + '/update/website',
                                data: {'ids': ids.join(), 'thread': value},
                                index: index,
                                tips: function (res) {
                                    main.msg(res.msg);
                                },
                                ending: 'table-list',
                            });
                        });
                    break;
                case 'reload_cron':
                    main.req({
                        url: url + '/reload/cron',
                        ending: 'table-list',
                    });
                    break;
                case 'pull_config':
                    if (data.length < 1) {
                        layer.msg("未选择", {icon: 2});
                        return false;
                    }
                    layer.prompt({
                            formType: 0,
                            value: data.length,
                            title: '远程网站配置覆盖本地，请输入线程数量 太多会卡死'
                        },
                        function (value, index) {
                            main.req({
                                url: url + '/pull/config',
                                data: {'ids': ids.join(), 'thread': value},
                                index: index,
                                tips: function (res) {
                                    main.msg(res.msg);
                                },
                            });
                        });
                    break;
                case 'jobs':
                    main.req({
                        url: url + '/jobs',
                        tips: function (res) {
                            main.msg(res.msg);
                        },
                    });
                    break;
                case 'cron-enable':
                    main.req({
                        url: url + '/cron/switch',
                        data: {ids: ids.join(), cron_enabled: true},
                        ending: 'table-list'
                    });
                    break;
                case 'cron-disable':
                    main.req({
                        url: url + '/cron/switch',
                        data: {ids: ids.join(), cron_enabled: false},
                        ending: 'table-list'
                    });
                    break;
                case 'export':
                    window.open(encodeURI('site/export?ids=' + ids.join()));
                    break;
                case 'import':
                    layer.open({
                        type: 1,
                        title: "导入配置",
                        btn: ['导入', '取消'],
                        shadeClose: true,
                        scrollbar: false,
                        shade: 0.8,
                        fixed: false,
                        maxmin: true,
                        btnAlign: 'c',
                        content: $('#import-form').html(),
                        yes: function (index, dom) {
                            dom.find('.layui-form button[lay-submit]button[lay-filter=submit-import]').click();
                            layer.close(index);
                        },
                        success: function () {
                            form.on('submit(submit-import)', function (obj) {
                                importConfig.reload({data: obj.field});
                                $('#import').click();
                                return false;
                            });
                        }
                    });
                    form.render();
                    break;
                case 'rank':
                    if (ids.length === 0) {
                        layer.msg("请选择数据!", {icon: 2});
                        return false;
                    }
                    main.req({
                        url: '/site/rank',
                        data: {'ids': ids.join()},
                        ending: 'table-list',
                        tips: function (res) {
                            main.msg(res.msg);
                        },
                    });
                    break;
                case 'del-rank':
                    if (ids.length === 0) {
                        layer.msg("请选择数据!", {icon: 2});
                        return false;
                    }
                    layer.confirm('删除后需要重新下载，确定删除？', function (index) {
                        main.req({
                            url: '/site/del/rank',
                            data: {'ids': ids.join()},
                            index: index,
                            ending: 'table-list',
                        });
                    });
                    break;
                case 'vhosts':
                    main.req({
                        url: url + '/vhosts',
                        data: {ids: ids.join()},
                        tips: function (res) {
                            main.msg(res.msg);
                        },
                    });
                    break;
                case 'links':
                    if (ids.length === 0) {
                        layer.msg("请选择数据!", {icon: 2});
                        return false;
                    }
                    $.get(url + '/link', {ids: ids.join()}, function (html) {
                        main.popup({
                            url: url + '/link',
                            title: '添加友链',
                            content: html,
                            area: ['500px', '500px'],
                        });
                        form.render();
                    });
                    break;
                case 'del_links':
                    if (ids.length === 0) {
                        layer.msg("请选择数据!", {icon: 2});
                        return false;
                    }
                    $.get(url + '/link', {ids: ids.join()}, function (html) {
                        main.popup({
                            url: url + '/del/link',
                            title: '删除友链',
                            content: html,
                            area: ['500px', '500px'],
                        });
                        form.render();
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
