{{template "theme.share" .}}
<div class="layui-card">
    <div class="layui-card-body">
        <header class="layui-inline">
            <div class="layui-input-inline">
                <input name="search" placeholder="搜索..." data-type="search" class="layui-input" style="height: 30px">
            </div>
            <button class="layui-btn layui-btn-sm" data-event="search">
                <i class="layui-icon layui-icon-search"></i>
            </button>
            <div class="layui-inline" id="tags"></div>
        </header>
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
            <img src="/static/images/loading.svg" alt="" data-type="face">
            <h4>
                <label>名称:</label>
                <span data-type="alias"></span>
            </h4>
            <h4>
                <label>简介:</label>
                <span data-type="intro"></span>
            </h4>
            <h4>
                <label>Tags:</label>
                <span data-type="tags"></span>
            </h4>
            <h4>
                <label>下载:</label>
                <span data-type="downloads"></span>
            </h4>
            <footer>
                <button class="layui-btn layui-btn-sm layui-btn-primary" style="color:yellow">
                    <i class="layui-icon iconfont icon-level-1"></i><cite data-type="level">0</cite>
                    ￥: <cite data-type="price">0</cite> 元
                </button>
                <div class="layui-btn-group" data-type="btn-group"></div>
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
            themeEle = $('#theme-container'),
            downEle = $('#down'),
            tagsEle = $('#tags'),
            admin = {{.admin}},
            driver = {{.driver}},
            authHost = {{.authHost}};

        class Util {
            constructor() {
                this.init = function () {
                    let loading = layui.main.loading();
                    $.get(url + "/tags", {driver: driver}, function (res) {
                        loading.close();
                        tagsEle.empty();
                        if (res.code === 0) {
                            for (let i = 0; i < res.data.length; i++) {
                                tagsEle.append('<button class="layui-btn layui-btn-sm layui-btn-primary" data-event="tag" title="' + res.data[i] + '"><i class="iconfont icon-tags"></i><cite>' + res.data[i] + '</cite></button>');
                            }
                            tagsEle.find('[data-event=tag]').off("click").on("click", function () {
                                downEle.hide();
                                paginatorLast = false;
                                paginatorCount = 0;
                                themeEle.empty();
                                req.reload({callback: null, data: {tag: this.title, cols: "tag", page: 1}});
                                $('[data-type=search]').val("");
                                layui.form.render("input");
                            });
                        } else {
                            console.log(res.msg);
                        }
                    });
                    // 监控 input
                    $('header input[data-type=search]').off("keydown").on("keydown", function (event) {
                        if (event.keyCode === 13) {
                            $('header [data-event=search]').click();
                        }
                    });
                    // 监控事件
                    this.render($('header'));
                    // 下拉加载更多
                    $(window).scroll(function () {
                        if (($(document).scrollTop() >= $(document).height() - $(window).height()) && $('img[lay-src]').length === 0 && !paginatorLast) {
                            req.options.data.page++
                            req.reload({callback: null});
                        }
                    });
                };
                this.req = function (options) {
                    let othis = this;
                    options = $.extend(true, {
                        url: url,
                        data: {driver: driver, page: 1, limit: 24},
                        error: function (res) {
                            paginatorLast = true
                            $('#result-count>cite').text(res.msg);
                            downEle.hide();
                            return false;
                        },
                        done: function (res) {
                            if (typeof options.callback === 'function') {
                                if (options.callback(res) === false) {
                                    return false;
                                }
                            }
                            paginatorCount += (res.data ? res.data.length : 0);
                            $('#result-count>cite').text("共" + res.count + "条，已加载" + paginatorCount + "条");
                            if (paginatorCount >= res.count) {
                                paginatorLast = true;
                                downEle.hide();
                            } else {
                                downEle.show();
                            }
                            $.each(res.data, function (i, d) {
                                othis.appendItem(d);
                            });
                            flow.lazyimg();
                            othis.render(themeEle);
                            return false;
                        }
                    }, options || {});
                    main.request(options);
                    return {
                        options: options,
                        reload: function (options) {
                            return othis.req($.extend(true, this.options, options));
                        }
                    }
                };
                this.active = {
                    "face": function (d) {
                        this.attr({
                            "lay-tips": "售:￥" + d['price'] + "元",
                            "lay-src": authHost + "/theme/" + d.driver + "/small_" + d['package'] + ".png",
                            "data-src": authHost + "/theme/" + d.driver + "/" + d['package'] + ".png",
                            alt: d['intro'], title: d['alias'], "data-event": "magnifier"
                        });
                    },
                    "alias": function (d) {
                        this.attr("lay-tips", d['alias']).text(d['alias']);
                    },
                    "intro": function (d) {
                        this.attr("lay-tips", d['intro']).text(d['intro']);
                    },
                    "tags": function (d) {
                        this.attr("lay-tips", d['tags']).text(d['tags']);
                    },
                    "downloads": function (d) {
                        this.text(d['downloads'] + " 次");
                    },
                    "level": function (d) {
                        this.attr("lay-tips", levels[d['level']]).text(d['level']);
                    },
                    "price": function (d) {
                        this.text(d['price']);
                    },
                    "btn-group": function (d) {
                        if (d['loaded']) {
                            this.html('<button class="layui-btn layui-btn-sm" data-event="download" lay-tips="重新下载该主题"><i class="layui-icon layui-icon-download-circle"></i>重新下载</button>');
                        } else if (d['price'] > 0 && !d['bought']) {
                            this.html('<button class="layui-btn layui-btn-sm" data-event="buy" lay-tips="购买该主题"><i class="layui-icon iconfont icon-shopping"></i>购买</button>');
                        } else if (d['unqualified']) {
                            this.html('<button class="layui-btn layui-btn-sm" data-event="upgrade" lay-tips="提升等级获取该主题"><i class="layui-icon iconfont icon-level-v"></i>升级账号</button>');
                        } else {
                            this.html('<button class="layui-btn layui-btn-sm" data-event="download" lay-tips="下载该主题"><i class="layui-icon layui-icon-download-circle"></i>下载</button>');
                        }
                        this.append('<button class="layui-btn layui-btn-sm" data-event="log" lay-tips="操作日志"><i class="layui-icon layui-icon-log"></i></button>');
                        this.find("button").attr("data-id", d.id);
                    },
                    // 绑定事件
                    "upgrade": function () {
                        layer.alert("请联系客服升级");
                    },
                    "buy": function (othis) {
                        let id = this.data("id");
                        main.request({
                            url: url + "/buy",
                            data: {driver: driver, token: admin.token, id: id},
                            done: function () {
                                let ele = $("#" + id + " [lay-filter=btn-group]");
                                ele.html('<button class="layui-btn layui-btn-sm" data-event="download" lay-tips="下载该主题"><i class="layui-icon layui-icon-download-circle"></i>下载</button><button class="layui-btn layui-btn-sm" data-event="log" lay-tips="操作日志"><i class="layui-icon layui-icon-log"></i></button>');
                                ele.find("button").attr("data-id", id);
                                othis.render(ele);
                            }
                        });
                    },
                    "download": function (othis) {
                        let id = this.data("id");
                        main.request({
                            url: url + "/download",
                            data: {driver: driver, token: admin.token, id: id},
                            done: function () {
                                main.ws.log("theme." + driver + "." + id, function () {
                                    let ele = $("#" + id + " [data-event=download]");
                                    ele.prop("outerHTML", '<button class="layui-btn layui-btn-sm layui-btn-primary" data-event="download" lay-tips="重新下载该主题" data-id="' + id + '"><i class="layui-icon layui-icon-download-circle"></i>重新下载</button>');
                                    othis.render(ele);
                                });
                                return false;
                            }
                        });
                    },
                    "magnifier": function () {
                        main.preview($(this).data("src"), '#theme-container .item>img', 'data-src');
                    },
                    "log": function () {
                        main.ws.log("theme." + driver + "." + this.data("id"));
                    },
                    "search": function () {
                        let search = $('input[name=search]').val().trim();
                        themeEle.empty();
                        if (search) {
                            downEle.hide();
                            paginatorLast = false;
                            paginatorCount = 0;
                            req.reload({
                                callback: null,
                                data: {search: search, cols: "search", page: 1}
                            });
                        } else {
                            location.reload();
                        }
                    },
                };
                this.buildItem = function (ele, d) {
                    let othis = this;
                    ele.attr("id", d.id).find("[data-type]").each(function () {
                        let $this = $(this), type = $this.data("type");
                        othis.active[type] && othis.active[type].call($this, d);
                    });
                };
                this.appendItem = function (d) {
                    let ele = $($('#item').html());
                    this.buildItem(ele, d);
                    themeEle.append(ele);
                };
                this.render = function (ele) {
                    let othis = this;
                    (ele ? ele.find('[data-event]') : $('[data-event]'))
                        .off("click")
                        .on("click", function () {
                            let $this = $(this), event = $this.data("event");
                            othis.active[event] && othis.active[event].call($this, othis);
                        });
                };
            }
        }

        let util = new Util();
        let req = util.req({
            callback: function () {
                themeEle.empty();
            }
        });
        util.init();
    });
</script>