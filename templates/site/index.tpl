<div class="layui-card">
    <div class="layui-form layui-card-header layuiadmin-card-header-auto">
        <div class="layui-row" id="form-search" lay-event="search">
            <div class="layui-col-md3">
                <label class="layui-form-label">网站程序</label>
                <div class="layui-input-block">
                    <select name="system" lay-filter="search-select">
                        <option value="">全部</option>
                        {{range $k,$v:=.drivers -}}
                            <option value="{{$k}}">{{$v.Alias}}</option>
                        {{end -}}
                    </select>
                </div>
            </div>
            <div class="layui-col-md3">
                <label class="layui-form-label">IDS</label>
                <div class="layui-input-block">
                    <input type="text" name="ids" placeholder="1,2,4,5" class="layui-input">
                </div>
            </div>
            <div class="layui-col-md3">
                <label class="layui-form-label">域名:</label>
                <div class="layui-input-block">
                    <input type="text" name="vhost" placeholder="模糊匹配域名" class="layui-input">
                </div>
            </div>
            <div class="layui-col-md3">
                <label class="layui-form-label">状态</label>
                <div class="layui-input-block">
                    <select name="status" lay-filter="search-select">
                        <option value="">全部</option>
                        {{range $i,$v:=.status -}}
                            <option value="{{$i}}">{{$v.Alias}}</option>
                        {{end -}}
                    </select>
                </div>
            </div>
            <div class="layui-hide">
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
            <button class="layui-btn layui-btn-sm" lay-event="configure" lay-tips="批量修改配置">
                <i class="layui-icon layui-icon-set"></i>
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
                            <button class="layui-btn layui-btn-sm layui-btn-fluid" lay-event="reload_nginx">重启Nginx
                            </button>
                        </dd>
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-fluid" lay-event="reload_website_setup">
                                更新配置
                            </button>
                        </dd>
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-fluid" lay-event="update_website">更新HTML
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
            <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="export" lay-tips="导出配置">
                <i class="layui-icon iconfont icon-export"></i>
            </button>
            <button class="layui-btn layui-btn-sm" lay-event="import" lay-tips="导入配置">
                <i class="layui-icon iconfont icon-import"></i>
            </button>
            <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="mysql" lay-tips="备份/还原数据库">
                <i class="layui-icon iconfont icon-sql"></i>
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
                            <button class="layui-btn layui-btn-sm layui-btn-fluid" lay-event="links">
                                <i class="layui-icon layui-icon-link"></i>
                                添加友链
                            </button>
                        </dd>
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-bg-red layui-btn-fluid" lay-event="links_del">
                                <i class="layui-icon layui-icon-link"></i>
                                删除友链
                            </button>
                        </dd>
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-fluid" lay-event="rank">拉取百度排名
                            </button>
                        </dd>
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-fluid" lay-event="rank_del">删除百度排名
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
                            <button class="layui-btn layui-btn-sm layui-btn-fluid" lay-event="jobs">查看任务
                            </button>
                        </dd>
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-bg-red layui-btn-fluid"
                                    lay-event="cron_disable">关闭任务
                            </button>
                        </dd>
                        <dd>
                            <button class="layui-btn layui-btn-sm layui-btn-fluid" lay-event="cron_enable">
                                开启任务
                            </button>
                        </dd>
                    </dl>
                </li>
            </ul>
        </div>
        <div class="layui-btn-group">
            <button class="layui-btn layui-btn-sm" lay-event="log" lay-tips="查看日志">
                <i class="layui-icon layui-icon-log"></i>
            </button>
            <button class="layui-btn layui-btn-sm layui-bg-red" lay-event="record_reset" lay-tips="重置日志">
                <i class="layui-icon iconfont icon-reset"></i>Log
            </button>
        </div>
    </div>
</script>
<script type="text/html" id="table-copy">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-xs layui-bg-orange" lay-event="clipboard"
                data-type="web_user" lay-tips="复制管理用户名到粘贴板">
            <i class="layui-icon layui-icon-username"></i>
        </button>
        <button class="layui-btn layui-btn-xs layui-bg-orange" lay-event="clipboard"
                data-type="web_pwd" lay-tips="复制管理密码到粘贴板">
            <i class="layui-icon layui-icon-password"></i>
        </button>
        <button class="layui-btn layui-btn-xs layui-bg-orange" lay-event="clipboard"
                data-type="auth_code" lay-tips="复制管理认证码到粘贴板">
            <i class="layui-icon layui-icon-auz"></i>
        </button>
    </div>
</script>
<script type="text/html" id="table-toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-xs" lay-event="modify" lay-tips="编辑">
            <i class="layui-icon layui-icon-edit"></i>
        </button>
        <button class="layui-btn layui-btn-xs" lay-event="rank" lay-tips="获取关键词排名">
            <i class="layui-icon layui-icon-layim-download"></i></button>
        <button class="layui-btn layui-btn-xs" lay-event="push" lay-tips="推送链接">
            <i class="layui-icon layui-icon-export"></i>
        </button>
        <button class="layui-btn layui-btn-xs layui-bg-cyan" lay-event="pic_dirname" lay-tips="设置文章图片">
            <i class="layui-icon layui-icon-picture"></i>
        </button>
        <button class="layui-btn layui-btn-xs" lay-event="link" lay-tips="操作内链或者外链">
            <i class="layui-icon layui-icon-link"></i></button>
        <button class="layui-btn layui-btn-xs" lay-event="mysql" lay-tips="备份/还原数据库">
            <i class="layui-icon iconfont icon-sql"></i>
        </button>
        <button class="layui-btn layui-btn-xs layui-btn-primary" lay-event="log" lay-tips="查看日志">
            <i class="layui-icon layui-icon-log"></i>
        </button>
    </div>
</script>
<script type="text/html" id="push">
    <div class="layui-card">
        <div class="layui-card-body layui-form">
            <div class="layui-form-item">
                <label class="layui-form-label">数量:</label>
                <div class="layui-input-inline">
                    <input name="count" value="0" class="layui-input">
                </div>
                <div class="layui-form-mid layui-word-aux">推送最后发布的N篇文章</div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label" lay-tips="本网站的完整URL一行一条">Urls:</label>
                <div class="layui-input-block">
                    <textarea name="urls" class="layui-textarea" rows="10"></textarea>
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
<script type="text/html" id="mysql-html">
    <div class="layui-card">
        <div class="layui-card-body layui-form">
            <div class="layui-form-item">
                <div class="layui-input-block">
                    <input type="radio" name="action" value="0" title="备份" lay-filter="mysql-action" checked>
                    <input type="radio" name="action" value="1" title="还原" lay-filter="mysql-action">
                </div>
            </div>
        </div>
    </div>
</script>
<script type="text/template" id="links-add-html">
    <div class="layui-card">
        <div class="layui-card-body layui-form">
            <div class="layui-form-item">
                <textarea class="layui-textarea" name="links" rows="6" placeholder="SEO=>http://www.botadmin.cn&#13;SEO培训=>http://www.botadmin.cn" lay-verify="required"></textarea>
            </div>
            <div class="layui-form-item layui-hide">
                <input type="hidden" name="ids" value="">
                <button class="layui-btn" lay-submit lay-filter="submit">提交</button>
            </div>
        </div>
    </div>
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let form = layui.form,
            table = layui.table,
            upload = layui.upload,
            element = layui.element,
            main = layui.main,
            status = {{.status}},
            //渲染上传配置
            importConfig = upload.render({
                headers: {'X-CSRF-Token': csrfToken},
                elem: '#import',
                url: '/site/import',
                accept: 'file',
                exts: 'txt|conf|json|tar.gz|zip',
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
        status = status || [];
        let active = {
                cron_switch: function (obj) {
                    let $this = this;
                    let enabled = !!$this.find('div.layui-unselect.layui-form-onswitch').size();
                    main.request({
                        url: url + "/cron/switch",
                        data: {id: obj.data.id, cron_enabled: enabled},
                        error: function () {
                            $this.find('input[type=checkbox]').prop("checked", !enabled);
                            form.render('checkbox');
                            return false;
                        }
                    });
                },
                rank: function (obj) {
                    main.request({
                        url: '/site/rank',
                        data: obj.data,
                        done: function (res) {
                            main.msg(res.msg);
                            return false;
                        },
                    });
                },
                del: function (obj) {
                    layer.confirm('确定删除此网站？不可恢复!', {icon: 3}, function (index) {
                        main.request({
                            url: url + '/del',
                            data: obj.data,
                            done: obj.del,
                            index: index
                        });
                    });
                },
                modify: function (obj) {
                    let loading = main.loading();
                    $.get(url + '/modify', {id: obj.data.id}).always(function () {
                        loading.close();
                    }).done(function (html) {
                        main.popup({
                            url: url + '/modify',
                            title: '修改网站设置',
                            content: html,
                            done: 'table-list',
                        });
                    });
                },
                link: function (obj) {
                    layer.confirm("请选择操作内链或外链！", {
                        icon: 3,
                        title: false,
                        btnAlign: 'c',
                        btn: ['内链', '外链'],
                        yes: function (index) {
                            layer.close(index);
                            let loading = main.loading();
                            $.get(url + '/link', {id: obj.data.id, action: 1}, function (res) {
                                loading.close();
                                if (res.code !== 0) {
                                    main.error(res.msg);
                                    return false;
                                }
                                main.popup({
                                    title: "修改内链",
                                    area: ['500px', '450px'],
                                    url: url + '/link',
                                    content: `<div class="layui-card"><div class="layui-card-body layui-form"><div class="layui-form-item"><textarea class="layui-textarea" placeholder="关键词=>https://www.nfivf.com/&#13;关键词2=>https://www.nfivf.com/" rows="12" name="links"></textarea></div><input name="id" type="hidden" value=""><input name="action" type="hidden" value="1"><button class="layui-hidden" lay-filter="submit" lay-submit></button></div></div>`,
                                    success: function (dom) {
                                        dom.find("[name=id]").val(obj.data.id);
                                        res.data && dom.find("textarea[name=links]").val(res.data);
                                    }
                                });
                            });
                        },
                        btn2: function (index) {
                            layer.close(index);
                            let loading = main.loading();
                            layer.open({
                                type: 2,
                                shadeClose: true,
                                scrollbar: false,
                                shade: 0.8,
                                maxmin: true,
                                btn: false,
                                area: ['95%', '95%'],
                                title: '友情链接',
                                content: url + '/link?id=' + obj.data.id,
                                success: function () {
                                    loading.close()
                                }
                            });
                        },
                    });
                },
                pic_dirname: function (obj) {
                    let loading = main.loading();
                    $.get(url + '/image', {id: obj.data.id}, function (html) {
                        loading.close();
                        main.popup({
                            url: url + '/image',
                            title: '添加图片',
                            content: html,
                            area: '800px',
                            done: function () {
                                main.ws.log('site.' + obj.data.id);
                                return false;
                            }
                        });
                        form.render();
                    });
                },
                mysql: function (obj) {
                    layer.open({
                        type: 1,
                        title: '备份/还原MySQL',
                        shadeClose: true,
                        scrollbar: false,
                        btnAlign: 'c',
                        shade: 0.8,
                        fixed: false,
                        area: ['450px', '300px'],
                        maxmin: true,
                        btn: ['确定', '取消'],
                        content: $('#mysql-html').html(),
                        success: function (dom, index) {
                            let uuid = main.uuid(), elem = dom.find('.layui-form');
                            elem.append('<input type="hidden" name="id" value="' + obj.data.id + '"><button class="layui-hide" lay-submit lay-filter="' + uuid + '"></button>');
                            form.render();
                            form.on('radio(mysql-action)', function (event) {
                                if (event.value === '1') {
                                    layer.confirm('导入SQL脚本会覆盖本数据库,不可恢复，确定覆盖？', function (index) {
                                        layer.close(index);
                                        let loading = main.loading();
                                        $.get(url + "/sql/backup", {webroot_path: obj.data['webroot_path']}, function (res) {
                                            loading.close();
                                            if (res.code !== 0) {
                                                main.error(res.msg);
                                                layer.close(index);
                                            } else {
                                                let selectElem = $('<div id="select-filename" class="layui-form-item"><label class="layui-form-label">选择备份:</label><div class="layui-input-block"><select name="filename" class="layui-select"></select></div></div>'),
                                                    insertElem = selectElem.find('select');
                                                for (let i = 0; i < res.data.length; i++) {
                                                    insertElem.append('<option value="' + res.data[i] + '">' + res.data[i] + '</option>');
                                                }
                                                elem.append(selectElem);
                                                form.render('select');
                                            }
                                        });
                                    });
                                } else {
                                    elem.find('#select-filename').remove();
                                }
                            });
                            form.on('submit(' + uuid + ')', function (obj) {
                                let field = obj.field;
                                main.request({
                                    url: url + "/mysql",
                                    data: field,
                                    index: index,
                                    done: function () {
                                        main.ws.log('site.' + field.id);
                                        return false;
                                    }
                                });
                                return false;
                            });
                        },
                        yes: function (index, dom) {
                            dom.find('button[lay-submit]').click();
                        },
                    });
                },
                push: function (obj) {
                    main.popup({
                        url: '/site/push',
                        title: "推送",
                        area: ['800px', 'auto'],
                        success: function (dom) {
                            dom.find('input[name=id]').val(obj.data.id);
                        },
                        content: $('#push').html()
                    });
                },
                log: function (obj) {
                    main.ws.log('site.' + obj.data.id);
                },
                clipboard: function (obj) {
                    main.copy(obj.data[this.data('type')]);
                },
                login: function (obj) {
                    if (obj.data.system === 'cms') {
                        window.open('/cms?id=' + obj.data.id, '_blank');
                    } else {
                        window.open(obj.data['admin_url'], '_blank');
                    }
                },
                valid_title: function () {
                    main.request({
                        url: '/site/valid',
                        data: {text: $('input[name=title]').val()}
                    });
                },
                valid_title_suffix: function () {
                    main.request({
                        url: '/site/valid',
                        data: {text: $('input[name=subtitle]').val()}
                    });
                },
                valid_description: function () {
                    main.request({
                        url: '/site/valid',
                        data: {text: $('input[name=description]').val()}
                    });
                },
            },
            activeBar = {
                log: function () {
                    main.ws.log('site.0');
                },
                configure: function (data, ids) {
                    if (data.length === 0) {
                        layer.msg("未选择", {icon: 2});
                        return false;
                    }
                    let loading = main.loading();
                    $.get(url + '/configure', {ids: ids.join()}, function (html) {
                        loading.close();
                        main.popup({
                            title: "批量修改配置",
                            url: url + '/configure',
                            content: html,
                            done: 'table-list',
                        });
                    });
                },
                del: function (data, ids) {
                    if (data.length === 0) {
                        layer.msg("未选择", {icon: 2});
                        return false;
                    }
                    layer.confirm('删除后不可恢复，确定删除吗？', function (index) {
                        main.request({
                            url: url + '/del',
                            data: {'ids': ids.join()},
                            index: index,
                            done: 'table-list',
                        });
                    });
                },
                add: function () {
                    let loading = main.loading();
                    $.get(url + '/add', {}, function (html) {
                        loading.close();
                        main.popup({
                            url: url + '/add',
                            title: '添加网站',
                            content: html,
                            done: 'table-list',
                        });
                    });
                },
                batch: function () {
                    let loading = main.loading();
                    $.get(url + '/batch', {}, function (html) {
                        loading.close();
                        main.popup({
                            url: url + '/batch',
                            title: '批量添加网站',
                            content: html,
                            done: 'table-list',
                        });
                    });
                },
                found: function (data, ids) {
                    if (data.length === 0) {
                        layer.msg("未选择", {icon: 2});
                        return false;
                    }
                    main.request({
                        url: url + '/found',
                        data: {'ids': ids.join()},
                        done: function (res) {
                            table.reload('table-list');
                            main.msg(res.msg);
                            return false;
                        },
                    });
                },
                install: function (data, ids) {
                    if (data.length === 0) {
                        layer.msg("未选择", {icon: 2});
                        return false;
                    }
                    main.request({
                        url: url + '/install',
                        data: {'ids': ids.join()},
                        done: function (res) {
                            table.reload('table-list');
                            main.msg(res.msg);
                            return false;
                        }
                    });
                },
                setup: function (data, ids) {
                    if (data.length === 0) {
                        layer.msg("未选择", {icon: 2});
                        return false;
                    }
                    main.request({
                        url: url + '/setup',
                        data: {'ids': ids.join()},
                        done: function () {
                            main.ws.log('site.0', function () {
                                table.reload('table-list');
                            });
                            return false;
                        },
                    });
                },
                publish: function (data, ids) {
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
                            main.request({
                                url: url + '/publish',
                                data: {'ids': ids.join(), 'thread': value},
                                index: index,
                                done: function () {
                                    main.ws.log('site.0', function () {
                                        table.reload('table-list');
                                    });
                                    return false;
                                }
                            });
                        });
                },
                reload_nginx: function (data, ids) {
                    main.request({
                        url: url + '/reload/nginx',
                        data: {'ids': ids.join()},
                        done: function (res) {
                            table.reload('table-list');
                            main.msg(res.msg);
                            return false;
                        },
                    });
                },
                reload_website_setup: function (data, ids) {
                    if (ids.length === 0) {
                        return main.error('请选择数据');
                    }
                    let contentObj = $($("#reload-setup").html());
                    contentObj.find('*[name=ids]').attr('value', ids.join());
                    main.popup({
                        title: '重新设置网站后台',
                        content: contentObj.prop('outerHTML'),
                        url: url + '/reload/website/setup',
                        area: '400px',
                        done: function () {
                            main.ws.log('site.0');
                            return false;
                        }
                    });
                },
                update_website: function (data, ids) {
                    layer.prompt({
                            formType: 0,
                            value: data.length,
                            title: '更新选中网站的文章和目录，请输入线程数量 太多会卡死'
                        },
                        function (value, index) {
                            main.request({
                                url: url + '/update/website',
                                data: {'ids': ids.join(), 'thread': value},
                                index: index,
                                done: function () {
                                    main.ws.log('site.0', function () {
                                        table.reload('table-list');
                                    });
                                    return false;
                                }
                            });
                        });
                },
                pull_config: function (data, ids) {
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
                            main.request({
                                url: url + '/pull/config',
                                data: {'ids': ids.join(), 'thread': value},
                                index: index,
                                done: function () {
                                    main.ws.log('site.0');
                                    return false;
                                }
                            });
                        });
                },
                jobs: function () {
                    main.request({
                        url: url + '/jobs',
                        done: function (res) {
                            main.msg(res.msg);
                            return false;
                        },
                    });
                },
                cron_enable: function (data, ids) {
                    main.request({
                        url: url + '/cron/switch',
                        data: {ids: ids.join(), cron_enabled: true},
                        done: 'table-list'
                    });
                },
                cron_disable: function (data, ids) {
                    main.request({
                        url: url + '/cron/switch',
                        data: {ids: ids.join(), cron_enabled: false},
                        done: 'table-list'
                    });
                },
                record_reset: function (data, ids) {
                    main.reset.log('site', ids);
                },
                export: function (data, ids) {
                    window.open(encodeURI(url + '/export?ids=' + ids.join()));
                },
                import: function () {
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
                },
                mysql: function (data, ids) {
                    if (ids.length === 0) {
                        return main.error('请选择数据');
                    }
                    layer.open({
                        type: 1,
                        title: '备份/还原MySQL',
                        shadeClose: true,
                        scrollbar: false,
                        btnAlign: 'c',
                        shade: 0.8,
                        fixed: false,
                        area: '450px',
                        maxmin: true,
                        btn: ['确定', '取消'],
                        content: $('#mysql-html').html(),
                        success: function (dom, index) {
                            let uuid = main.uuid(), elem = dom.find('.layui-form');
                            elem.append(`<button class="layui-hide" lay-submit lay-filter="` + uuid + `"></button>`);
                            form.render();
                            form.on('submit(' + uuid + ')', function (obj) {
                                let field = obj.field;
                                field.id = data.id;
                                field.ids = ids.join();
                                main.request({
                                    url: url + "/mysql",
                                    data: field,
                                    index: index,
                                    done: function () {
                                        main.ws.log('site.0');
                                        return false;
                                    }
                                });
                                return false;
                            });
                        },
                        yes: function (index, dom) {
                            dom.find('button[lay-submit]').click();
                        },
                    });
                },
                rank: function (data, ids) {
                    if (ids.length === 0) {
                        return main.error('请选择数据');
                    }
                    main.request({
                        url: '/site/rank',
                        data: {'ids': ids.join()},
                        done: function (res) {
                            table.reload('table-list');
                            main.msg(res.msg);
                            return false;
                        },
                    });
                },
                rank_del: function (data, ids) {
                    if (ids.length === 0) {
                        return main.error('请选择数据');
                    }
                    layer.confirm('删除后需要重新下载，确定删除？', function (index) {
                        main.request({
                            url: '/site/del/rank',
                            data: {'ids': ids.join()},
                            index: index,
                            done: 'table-list',
                        });
                    });
                },
                vhosts: function (data, ids) {
                    main.request({
                        url: url + '/vhosts',
                        data: {ids: ids.join()},
                        done: function (res) {
                            main.msg(res.msg);
                            return false;
                        },
                    });
                },
                links: function (data, ids) {
                    if (ids.length === 0) {
                        return main.error('请选择数据');
                    }
                    main.popup({
                        title: "添加友情链接",
                        url: url + "/link/add",
                        area: ['500px', '300px'],
                        content: $('#links-add-html').html(),
                        success: function (dom) {
                            dom.find("[name=ids]").val(ids.join());
                        },
                    });
                },
                links_del: function (data, ids) {
                    if (ids.length === 0) {
                        return main.error('请选择数据');
                    }
                    main.popup({
                        title: "删除友情链接",
                        url: url + "/link/del",
                        area: ['500px', '300px'],
                        content: $('#links-add-html').html(),
                        success: function (dom) {
                            dom.find("[name=ids]").val(ids.join());
                        },
                    });
                },
            };
        //列表管理
        table.render({
            headers: {'X-CSRF-Token': csrfToken},
            method: 'post',
            elem: '#table-list',
            toolbar: '#toolbar',
            url: url,
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
                        let icon = '';
                        switch (d.system) {
                            case 'cms':
                                icon = `<small class="iconfont icon-local-shop" style="padding-right:6px;color:rgba(0,0,0,0.3)" title="内置CMS"></small>`;
                                break;
                            case 'empirecms':
                                icon = `<small style="padding-right:6px;color:rgba(0,0,0,0.3)" title="帝国CMS">帝国</small>`;
                                break;
                            case 'dedecms':
                                icon = `<small style="padding-right:6px;color:rgba(0,0,0,0.3)" title="织梦CMS">织梦</small>`;
                                break;
                            case 'discuz':
                                icon = `<small style="padding-right:6px;color:rgba(0,0,0,0.3)" title="Discuz论坛">Discuz</small>`;
                                break;
                        }
                        if (d.status === 4) {
                            return icon + d.vhost;
                        }
                        return icon + '<a lay-href="/file?path=' + d['webroot_path'] + '" style="color:#01aaed" lay-tips="' + d['title'] + '">' + d.vhost + '</a>';
                    }
                },
                {
                    field: 'status', title: '状态', sort: true, width: 80, templet: function (d) {
                        let stat = status[d.status];
                        return '<strong style="color:' + stat.color + '" lay-tips="' + stat.alias + '">' + stat.name + '</strong>';
                    }
                },
                {
                    field: 'ftp_id', width: 120, title: 'FTP', align: 'center',
                    templet: function (d) {
                        return d['ftp_id'] ? d['ftp_name'] : '未绑定';
                    }
                },
                {
                    field: 'sql_id', width: 120, title: 'MySQL', align: 'center',
                    templet: function (d) {
                        return d['sql_id'] ? d.dbname : '未绑定';
                    }
                },
                {
                    field: 'admin_url', title: 'admin', align: 'center', event: 'login',
                    style: 'cursor:pointer;color:#01aaed;', width: 80, templet: function () {
                        return '管理';
                    }
                },
                {title: '复制', width: 126, align: 'center', fixed: 'right', toolbar: '#table-copy'},
                {field: 'web_user', title: '用户名', align: 'center', hide: true},
                {field: 'web_pwd', title: 'Pwd', align: 'center', hide: true},
                {field: 'auth_code', title: 'Auth', align: 'center', hide: true},
                {field: 'webroot_path', title: '网站路径', hide: true},
                {
                    field: 'updated', title: '时间', sort: true, hide: true, templet: function (d) {
                        return main.timestampFormat(d['updated']);
                    }
                },
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
                {title: '操作', width: 240, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
            ],],
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
            active[obj.event] && active[obj.event].call($(this), obj);
        });

        //头工具栏事件
        table.on('toolbar(table-list)', function (obj) {
            let data = table.checkStatus(obj.config.id).data,
                ids = [];
            for (let i = 0; i < data.length; i++) {
                ids[i] = data[i].id;
            }
            activeBar[obj.event] && activeBar[obj.event].call(obj, data, ids);
        });
        // 监听搜索
        main.onSearch();
        main.checkLNMP();
        $(document).on('click', '.layui-form [data-event]', function (e) {
            let $this = $(this), event = $this.data('event');
            active[event] && active[event].call($this);
            e.stopPropagation();
        });
    });
</script>