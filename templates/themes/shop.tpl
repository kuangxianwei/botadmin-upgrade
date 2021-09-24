<style>
    .item {
        border-radius: 12px;
        background: #0a6e85;
        margin: 5px;
        padding: 6px;
        color: #ffffff;
        box-shadow: 1px 1px 1px 1px #888;
        line-height: 20px;
    }

    .layui-card-body > hr {
        box-shadow: 1px 1px 1px #888;
    }

    .item > img {
        width: 100%;
        height: 200px;
        border-radius: 10px;
        margin-bottom: 10px;
        box-shadow: 1px 1px 1px 1px #888;
        cursor: pointer;
    }

    .item > h4 > label {
        display: inline-block;
        overflow: hidden;
        margin-right: 5px;
    }

    .item > h4 > span {
        display: inline-block;
        width: 80%;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
    }

    .item > footer {
        margin-top: 10px;
        text-align: center;
    }

    .item > footer button {
        color: white;
    }

    .layui-btn + .layui-btn {
        margin: 2px;
    }

    #tags + button.layui-btn-primary {
        margin-left: 5px
    }
</style>
<div class="layui-card">
    <div class="layui-card-body">
        <div class="layui-inline" id="tags">
            <div class="layui-input-inline">
                <input name="search" placeholder="搜索..." lay-filter="search" class="layui-input" style="height: 30px">
            </div>
            <button class="layui-btn layui-btn-sm" lay-event="search">
                <i class="layui-icon layui-icon-search"></i>
            </button>
        </div>
        <h4 id="result-count" style="position:fixed;z-index:19821027;left:300px;top:2px;color:#bd2c00">
            结果: <cite></cite>
        </h4>
        <hr/>
        <div class="layui-row" id="theme-container"></div>
        <h4 style="position:fixed;z-index:19821027;left:48%;bottom:10px;color: gray" id="down">
            <i class="layui-icon layui-icon-down"></i><cite>下拉加载更多</cite>
        </h4>
    </div>
</div>
<script type="text/html" id="item">
    <div class="layui-col-md3">
        <div class="item">
            <img src="/theme/loading.svg" alt="" lay-filter="face">
            <h4>
                <label>名称:</label>
                <span lay-filter="alias"></span>
            </h4>
            <h4>
                <label>简介:</label>
                <span lay-filter="intro"></span>
            </h4>
            <h4>
                <label>Tags:</label>
                <span lay-filter="tags"></span>
            </h4>
            <h4>
                <label>下载:</label>
                <span lay-filter="downloads"></span>
            </h4>
            <footer>
                <button class="layui-btn layui-btn-sm layui-btn-primary" style="color:yellow">
                    <i class="layui-icon iconfont icon-level-1"></i><cite lay-filter="level">0</cite>
                    ￥: <cite lay-filter="price">0</cite> 元
                </button>
                <div class="layui-btn-group" lay-filter="btn-group"></div>
            </footer>
        </div>
    </div>
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let main = layui.main,
            flow = layui.flow,
            layer = layui.layer,
            upload = layui.upload,
            levels = {
                0: "已封禁 上限0个站",
                1: "个人版 上限1个站",
                2: "初级版 上限10个站",
                3: "中级版 上限50个站",
                4: "高级版 上限100个站",
                5: "旗舰版 上限500个站",
                6: "超级版 上限5000个站",
            },
            paginatorCount = 0,
            paginatorLast = false,
            themeElem = $('#theme-container'),
            downElem = $('#down'),
            admin = {{.admin}},
            driver = {{.driver}},
            authHost = {{.authHost}},
            url = {{.current_uri}};
        admin = admin || {};
        driver = driver || '';
        url = url || '';

        let utils = {
            req: function (options) {
                options = $.extend(true, {
                    url: url,
                    data: {driver: driver, page: 1, limit: 24},
                    error: function (res) {
                        paginatorLast = true
                        $('#result-count>cite').text(res.msg);
                        downElem.addClass('layui-hide');
                        return false;
                    },
                    ending: function (res) {
                        if (typeof options.callback === 'function') {
                            if (options.callback(res) === false) {
                                return false;
                            }
                        }
                        paginatorCount += (res.data ? res.data.length : 0);
                        $('#result-count>cite').text("共" + res.count + "条，已加载" + paginatorCount + "条");
                        if (paginatorCount >= res.count) {
                            paginatorLast = true;
                            $('#down').addClass('layui-hide');
                        }
                        $.each(res.data, function (i, d) {
                            utils.createItem(d);
                        });
                        flow.lazyimg();
                        utils.render(themeElem);
                        return false;
                    }
                }, options || {});
                main.req(options);
                return {
                    options: options,
                    reload: function (options) {
                        return utils.req($.extend(true, this.options, options));
                    }
                }
            },
            init: function () {
                $.get(url + "/tags", {driver: driver}, function (res) {
                    if (res.code === 0) {
                        let elem = $('#tags');
                        for (let i = 0; i < res.data.length; i++) {
                            elem.after('<button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="tag" title="' + res.data[i] + '"><i class="iconfont icon-tags"></i><cite>' + res.data[i] + '</cite></button>');
                        }
                        $('[lay-event=tag]').click(function () {
                            downElem.removeClass('layui-hide');
                            paginatorLast = false;
                            paginatorCount = 0;
                            themeElem.empty();
                            req.reload({callback: null, data: {tag: this.title, cols: "tag", page: 1}});
                        });
                    } else {
                        console.log(res.msg);
                    }
                });
                // 监控 input
                $('input[lay-filter=search]').keydown(function (event) {
                    if (event.keyCode === 13) {
                        $('[lay-event=search]').click();
                    }
                });
                // 监控事件
                $('[lay-event]').click(function () {
                    switch ($(this).attr("lay-event")) {
                        case "add":
                            $.get(url + "/add", {driver: driver}, function (html) {
                                main.popup({
                                    title: "添加主题",
                                    url: url + "/add",
                                    content: html,
                                    area: '720px',
                                    success: function (dom, layerIndex) {
                                        let loading;
                                        upload.render({
                                            elem: '#uploadPackage',
                                            url: url + "/add",
                                            size: 1024 * 50,
                                            accept: 'file',
                                            exts: 'tar.gz',
                                            multiple: true,
                                            auto: false,
                                            bindAction: '#uploadSubmit',
                                            before: function () {
                                                this.data = main.formData(dom.selector);
                                                main.setCols(this.data, dom);
                                                loading = layer.load(1, {shade: [0.7, '#000', true]});
                                            },
                                            choose: function (obj) {
                                                obj.preview(function (index, file) {
                                                    $('#packageName>cite').text('主题包: ' + file.name).data("filename", file.name);
                                                });
                                            },
                                            done: function (res, index) {
                                                layer.close(loading);
                                                if (res.code === 0) {
                                                    location.reload();
                                                    layer.close(layerIndex);
                                                    layer.msg(res.msg, {icon: 1}, function () {
                                                        layer.close(index);
                                                    });
                                                    return false;
                                                }
                                                main.err(res.msg);
                                            },
                                            error: function (index) {
                                                layer.close(index);
                                                layer.close(loading);
                                                main.err("网络错误");
                                            },
                                        });
                                    },
                                    yes: function (index, dom) {
                                        if (dom.find('#packageName>cite').data("filename")) {
                                            dom.find('#uploadSubmit').click();
                                            return false;
                                        }
                                    },
                                });
                            });
                            break;
                        case "search":
                            let search = $('input[name=search]').val().trim();
                            if (search) {
                                $('#down').removeClass('layui-hide');
                                paginatorLast = false;
                                paginatorCount = 0;
                                themeElem.empty();
                                req.reload({
                                    callback: null,
                                    data: {search: search, cols: "search", page: 1}
                                });
                            } else {
                                location.reload();
                            }
                            break;
                    }
                });
                // 下拉加载更多
                $(window).scroll(function () {
                    if (($(document).scrollTop() >= $(document).height() - $(window).height()) && $('img[lay-src]').length === 0 && !paginatorLast) {
                        req.options.data.page++
                        req.reload({callback: null});
                    }
                });
            },
            buildItem: function (elem, d) {
                elem.attr("id", d.id).find("[lay-filter]").each(function () {
                    let obj = $(this)
                    switch (obj.attr("lay-filter")) {
                        case "face":
                            obj.attr({
                                "lay-tips": "售:￥" + d['price'] + "元",
                                "lay-src": authHost + "/theme/" + d.driver + "/" + d['package'] + ".png",
                                alt: d['intro'], title: d['alias'], "data-event": "magnifier"
                            });
                            break;
                        case "alias":
                            obj.attr("lay-tips", d['alias']).text(d['alias']);
                            break;
                        case "intro":
                            obj.attr("lay-tips", d['intro']).text(d['intro']);
                            break;
                        case "tags":
                            obj.attr("lay-tips", d['tags']).text(d['tags']);
                            break;
                        case "downloads":
                            obj.text(d['downloads'] + " 次");
                            break;
                        case "level":
                            obj.attr("lay-tips", levels[d['level']]).text(d['level']);
                            break;
                        case "price":
                            obj.text(d['price']);
                            break;
                        case "btn-group":
                            if (d['loaded']) {
                                obj.html('<button class="layui-btn layui-btn-sm" data-event="download" lay-tips="重新下载该主题"><i class="layui-icon layui-icon-download-circle"></i>重新下载</button>');
                            } else if (d['price'] > 0 && !d['bought']) {
                                obj.html('<button class="layui-btn layui-btn-sm" data-event="buy" lay-tips="购买该主题"><i class="layui-icon iconfont icon-shopping"></i>购买</button>');
                            } else if (d['unqualified']) {
                                obj.html('<button class="layui-btn layui-btn-sm" data-event="upgrade" lay-tips="提升等级获取该主题"><i class="layui-icon iconfont icon-level-v"></i>升级账号</button>');
                            } else {
                                obj.html('<button class="layui-btn layui-btn-sm" data-event="download" lay-tips="下载该主题"><i class="layui-icon layui-icon-download-circle"></i>下载</button>');
                            }
                            obj.append('<button class="layui-btn layui-btn-sm" data-event="log" lay-tips="操作日志"><i class="layui-icon layui-icon-log"></i></button>');
                            obj.find("button").attr("data-id", d.id);
                            break;
                    }
                });
            },
            createItem: function (d) {
                let elem = $($('#item').html());
                elem.attr("id", d.id);
                utils.buildItem(elem, d);
                themeElem.append(elem);
            },
            render: function (ele) {
                (ele ? ele.find('[data-event]') : $('[data-event]')).click(function () {
                    let othis = $(this),
                        id = othis.data("id");
                    switch (othis.data("event")) {
                        case "upgrade":
                            layer.alert("请联系客服升级");
                            break;
                        case "buy":
                            main.req({
                                url: url + "/buy",
                                data: {driver: driver, token: admin.token, id: id},
                                ending: function () {
                                    let ele = $("#" + id + " [lay-filter=btn-group]");
                                    ele.html('<button class="layui-btn layui-btn-sm" data-event="download" lay-tips="下载该主题"><i class="layui-icon layui-icon-download-circle"></i>下载</button><button class="layui-btn layui-btn-sm" data-event="log" lay-tips="操作日志"><i class="layui-icon layui-icon-log"></i></button>');
                                    ele.find("button").attr("data-id", id);
                                    utils.render(ele);
                                }
                            });
                            break;
                        case "download":
                            main.req({
                                url: url + "/download",
                                data: {driver: driver, token: admin.token, id: id},
                                ending: function () {
                                    main.ws.log("theme." + driver + "." + id, function () {
                                        let ele = $("#" + id + " [data-event=download]");
                                        ele.prop("outerHTML", '<button class="layui-btn layui-btn-sm layui-btn-primary" data-event="download" lay-tips="重新下载该主题" data-id="' + id + '"><i class="layui-icon layui-icon-download-circle"></i>重新下载</button>');
                                        utils.render(ele);
                                    });
                                    return false;
                                }
                            });
                            break;
                        case "magnifier":
                            main.display({content: '<img src="' + this.src + '" width="100%" height="auto" alt="' + this.alt + '">'});
                            break;
                        case "log":
                            main.ws.log("theme." + driver + "." + id);
                            break;
                    }
                });
            },
        };
        let req = utils.req({
            callback: function () {
                themeElem.empty();
            }
        });
        utils.init();
    });
</script>