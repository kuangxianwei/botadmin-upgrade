{{template "theme.share" .}}
<div class="layui-card">
    <div class="layui-card-body">
        <header>
            <button class="layui-btn layui-btn-sm" data-event="add">
                <i class="layui-icon layui-icon-add-circle"></i>添加主题
            </button>
            <div class="layui-inline">
                <div class="layui-input-inline">
                    <input type="text" name="search" placeholder="搜索..." data-type="search" class="layui-input" style="height: 30px">
                </div>
                <button class="layui-btn layui-btn-sm" data-event="search">
                    <i class="layui-icon layui-icon-search"></i>
                </button>
            </div>
            <div class="layui-inline" id="tags"></div>
            <h4 id="result-count" style="position:fixed;z-index:19821027;left:300px;top:2px;color:#bd2c00">
                结果: <cite></cite>
            </h4>
        </header>
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
            <img src="/theme/loading.svg" alt="" data-type="img">
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
            <footer>
                <div class="layui-btn-group" data-type="btn-group">
                    <button class="layui-btn layui-btn-sm" data-event="download" lay-tips="下载该主题">
                        <i class="layui-icon layui-icon-download-circle"></i>
                    </button>
                    <button class="layui-btn layui-btn-sm layui-btn-normal" data-event="modify" lay-tips="编辑该主题">
                        <i class="layui-icon layui-icon-edit"></i>
                    </button>
                    <a class="layui-btn layui-btn-sm" data-type="open-theme" lay-tips="转到主题目录">
                        <i class="layui-icon layui-icon-fonts-code"></i>
                    </a>
                    <button class="layui-btn layui-btn-sm layui-btn-normal" data-type="face" lay-tips="替换该封面,只允许上传png格式图片">
                        <i class="layui-icon layui-icon-picture"></i>
                    </button>
                    <button class="layui-btn layui-btn-sm layui-btn-danger" data-event="del" lay-tips="删除该主题">
                        <i class="layui-icon layui-icon-delete"></i>
                    </button>
                    <button class="layui-btn layui-btn-sm layui-btn-primary" data-event="log" lay-tips="查看日志">
                        <i class="layui-icon layui-icon-log"></i>
                    </button>
                </div>
            </footer>
        </div>
    </div>
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let main = layui.main,
            flow = layui.flow,
            upload = layui.upload,
            paginatorCount = 0,
            paginatorLast = false,
            downEle = $('#down'),
            tagsEle = $('#tags'),
            themeEle = $('#theme-container'),
            driver = {{.driver}};

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
                    "img": function (d) {
                        this.attr({
                            "lay-tips": (d['intro'] || d['alias']),
                            "lay-src": d['small_face'],
                            "data-src": d['face'],
                            "alt": d['intro'],
                            "title": d['alias'],
                            "data-event": "magnifier"
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
                    "face": function (d) {
                        upload.render({
                            headers: {'X-CSRF-Token': csrfToken},
                            elem: this,
                            url: url + '/face',
                            data: {driver: driver, id: d.id},
                            acceptMime: 'image/png',
                            exts: 'png',
                            done: function (res) {
                                if (res.code === 0) {
                                    $('#' + d.id + " [data-type=img]").attr({
                                        "data-src": res.data["face"] + "?",
                                        "src": res.data["small_face"] + "?"
                                    });
                                    return layer.msg("封面替换成功");
                                }
                                main.err(res.msg);
                            },
                        });
                    },
                    "open-theme": function (d) {
                        this.attr({
                            "lay-text": d['name'] + "主题",
                            "lay-href": "/file?path=data/theme/" + d["driver"] + "/" + d["name"],
                        });
                    },
                    "btn-group": function (d) {
                        this.find("[data-event]").attr("data-id", d.id);
                    },
                    // 一下是绑定事件
                    "add": function (othis) {
                        let loading = layui.main.loading();
                        $.get(url + "/add", {driver: driver}, function (html) {
                            loading.close();
                            main.popup({
                                title: "添加主题",
                                url: url + "/add",
                                content: html,
                                area: '680px',
                                success: function (dom, popIndex) {
                                    upload.render({
                                        headers: {'X-CSRF-Token': $('meta[name=csrf_token]').attr("content")},
                                        elem: '#uploadPackage',
                                        url: url + "/add",
                                        size: 1024 * 50,
                                        accept: 'file',
                                        exts: 'tar.gz',
                                        multiple: true,
                                        auto: false,
                                        bindAction: '#uploadSubmit',
                                        before: function () {
                                            this.data = main.formData(dom);
                                            main.setCols(this.data, dom);
                                            this.loading = layer.load(1, {shade: [0.7, '#000', true]});
                                        },
                                        choose: function (obj) {
                                            obj.preview(function (index, file) {
                                                $('#packageName>cite').text('主题包: ' + file.name).data("filename", file.name);
                                            });
                                        },
                                        done: function (res, index) {
                                            this.loading && layer.close(this.loading);
                                            if (res.code === 0) {
                                                layer.close(index);
                                                layer.close(popIndex);
                                                othis.appendItem(res.data);
                                                flow.lazyimg();
                                                return false;
                                            }
                                            main.err(res.msg);
                                        },
                                        error: function (index) {
                                            layer.close(index);
                                            this.loading && layer.close(this.loading);
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
                                done: function (res) {
                                    if (res.data) {
                                        othis.appendItem(res.data);
                                        flow.lazyimg();
                                    }
                                    return false;
                                }
                            });
                        });
                    },
                    "modify": function (othis) {
                        let id = this.attr("data-id");
                        let loading = layui.main.loading();
                        $.get(url + "/modify", {driver: driver, id: id}, function (html) {
                            loading.close();
                            main.popup({
                                title: "修改主题",
                                url: url + "/modify",
                                content: html,
                                area: '720px',
                                success: function (dom, popIndex) {
                                    upload.render({
                                        headers: {'X-CSRF-Token': $('meta[name=csrf_token]').attr("content")},
                                        elem: '#uploadPackage',
                                        url: url + "/modify",
                                        size: 1024 * 50,
                                        accept: 'file',
                                        exts: 'tar.gz',
                                        multiple: true,
                                        auto: false,
                                        bindAction: '#uploadSubmit',
                                        before: function () {
                                            this.data = main.formData(dom);
                                            main.setCols(this.data, dom);
                                            this.data.name = dom.find("[name=name]").val();
                                            this.loading = layer.load(1, {shade: [0.7, '#000', true]});
                                        },
                                        choose: function (obj) {
                                            obj.preview(function (index, file) {
                                                $('#packageName>cite').text('主题包: ' + file.name).data("filename", file.name);
                                            });
                                        },
                                        done: function (res, index) {
                                            this.loading && layer.close(this.loading);
                                            if (res.code === 0) {
                                                layer.close(index);
                                                layer.close(popIndex);
                                                let ele = $("#" + res.data.id);
                                                othis.buildItem(ele, res.data)
                                                flow.lazyimg();
                                                return false;
                                            }
                                            main.err(res.msg);
                                        },
                                        error: function (index) {
                                            layer.close(index);
                                            this.loading && layer.close(this.loading);
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
                                done: function (res) {
                                    othis.buildItem($('#' + res.data.id), res.data);
                                }
                            });
                        });
                    },
                    "del": function () {
                        let id = this.data("id");
                        layer.confirm("删除不可恢复！确定删除该主题？", {icon: 3}, function (index) {
                            main.request({
                                url: url + "/del",
                                data: {driver: driver, id: id},
                                done: function () {
                                    $("#" + id).remove();
                                    layer.close(index);
                                    return false;
                                }
                            });
                        });
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
                    "magnifier": function () {
                        main.display({content: '<img src="' + this.data("src") + '" width="100%" height="auto" alt="' + this.attr("alt") + '">'});
                    },
                    "log": function () {
                        main.ws.log("theme." + driver + "." + this.data("id"));
                    },
                    "download": function () {
                        window.open(encodeURI(url + "/download?driver=" + driver + "&id=" + this.data("id")), "blank");
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
                    util.render(ele);
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