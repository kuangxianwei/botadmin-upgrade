<div class="layui-card layui-form">
    <div class="layui-card-body">
        <div class="layui-tab layui-tab-card">
            <ul class="layui-tab-title">
                <li class="layui-this">标题</li>
                <li>副标题</li>
                <li>关键词</li>
                <li>描述</li>
                <li>栏目</li>
                <li>城市</li>
                <li>IP</li>
                <li>关于</li>
                <li>随机词</li>
            </ul>
            <div class="layui-tab-content">
                <div class="layui-tab-item layui-show">
                    <div class="layui-form-item">
                        <textarea class="layui-textarea" name="titles" rows="15">{{join .obj.Titles "\n"}}</textarea>
                        <label class="layui-form-label">插入标签:</label>
                        <div class="layui-input-block">
                            <button class="layui-btn layui-btn-sm layui-btn-radius" data-write="city">城市名称</button>
                            <button class="layui-btn layui-btn-sm layui-btn-radius" data-write="province">省名称</button>
                            <button class="layui-btn layui-btn-sm layui-btn-radius" data-write="keyword">关键词</button>
                            <button class="layui-btn layui-btn-sm layui-btn-radius" data-write="domain">域名</button>
                            <button class="layui-btn layui-btn-sm layui-btn-radius" data-write="tag">Tag</button>
                            <button class="layui-btn layui-btn-sm layui-btn-radius" data-write="title_suffix">副标题
                            </button>
                        </div>
                    </div>
                    <div class="layui-collapse">
                        <div class="layui-colla-item">
                            <h2 class="layui-colla-title">帮助提示</h2>
                            <div class="layui-colla-content">
                                <p>可用标签是:</p>
                                <p>&#123;{city}&#125; 代表城市名称 例如:广州</p>
                                <p>&#123;{province}&#125; 代表省份 例如:广东</p>
                                <p>&#123;{title_suffix}&#125; 代表副标题 例如:南方39助孕网</p>
                                <p>&#123;{keyword}&#125; 代表关键词 例如:试管婴儿</p>
                                <p>&#123;{description}&#125; 描述</p>
                                <p>&#123;{domain}&#125; 代表当前域名 例如:www.botadmin.cn</p>
                                <p>&#123;{tag}&#125; 代表tag 例如:广州试管婴儿</p>
                                <p>&#123;{about}&#125; 代表一条关于我们</p>
                                <p>&#123;{link}&#125; 代表链接 例如:试管婴儿=>https://www.botadmin.cn</p>
                                <p>按照这些组成不同的标题</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="layui-tab-item">
                    <div class="layui-form-item">
                        <textarea class="layui-textarea" name="title_suffixes" rows="15">{{join .obj.TitleSuffixes "\n"}}</textarea>
                        <label class="layui-form-label">插入标签:</label>
                        <div class="layui-input-block">
                            <button class="layui-btn layui-btn-sm layui-btn-radius" data-write="city">城市名称</button>
                            <button class="layui-btn layui-btn-sm layui-btn-radius" data-write="province">省名称</button>
                            <button class="layui-btn layui-btn-sm layui-btn-radius" data-write="keyword">关键词</button>
                            <button class="layui-btn layui-btn-sm layui-btn-radius" data-write="domain">域名</button>
                            <button class="layui-btn layui-btn-sm layui-btn-radius" data-write="tag">Tag</button>
                        </div>
                    </div>
                    <div class="layui-collapse">
                        <div class="layui-colla-item">
                            <h2 class="layui-colla-title">帮助提示</h2>
                            <div class="layui-colla-content">
                                <p>可用标签是:</p>
                                <p>&#123;{city}&#125; 代表城市名称 例如:广州</p>
                                <p>&#123;{province}&#125; 代表省份 例如:广东</p>
                                <p>&#123;{title}&#125; 代表标题 例如:南方39试管婴儿助孕生殖网</p>
                                <p>&#123;{keyword}&#125; 代表关键词 例如:试管婴儿</p>
                                <p>&#123;{description}&#125; 描述</p>
                                <p>&#123;{domain}&#125; 代表当前域名 例如:www.botadmin.cn</p>
                                <p>&#123;{tag}&#125; 代表tag 例如:广州试管婴儿</p>
                                <p>&#123;{about}&#125; 代表一条关于我们</p>
                                <p>&#123;{link}&#125; 代表链接 例如:试管婴儿=>http://www.botadmin.cn</p>
                                <p>按照这些组成不同的标题后缀</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="layui-tab-item">
                    <div class="layui-form-item">
                        <textarea class="layui-textarea" name="keywords"
                                  rows="15">{{join .obj.Keywords "\n"}}</textarea>
                    </div>
                    <blockquote class="layui-elem-quote">
                        一行一条
                    </blockquote>
                </div>
                <div class="layui-tab-item">
                    <div class="layui-form-item">
                        <textarea class="layui-textarea" name="descriptions" rows="15">{{join .obj.Descriptions "\n"}}</textarea>
                        <label class="layui-form-label">插入标签:</label>
                        <div class="layui-input-block">
                            <button class="layui-btn layui-btn-sm layui-btn-radius" data-write="city">城市名称</button>
                            <button class="layui-btn layui-btn-sm layui-btn-radius" data-write="province">省名称</button>
                            <button class="layui-btn layui-btn-sm layui-btn-radius" data-write="title">标题</button>
                            <button class="layui-btn layui-btn-sm layui-btn-radius" data-write="keyword">关键词</button>
                            <button class="layui-btn layui-btn-sm layui-btn-radius" data-write="domain">域名</button>
                            <button class="layui-btn layui-btn-sm layui-btn-radius" data-write="tag">Tag</button>
                        </div>
                    </div>
                    <div class="layui-collapse">
                        <div class="layui-colla-item">
                            <h2 class="layui-colla-title">帮助提示</h2>
                            <div class="layui-colla-content">
                                <p>建站随机选择描述,可用标签是:</p>
                                <p>&#123;{city}&#125; 代表城市名称 例如:广州</p>
                                <p>&#123;{province}&#125; 代表省份 例如:广东</p>
                                <p>&#123;{title}&#125; 代表标题 例如:南方39试管婴儿助孕生殖网</p>
                                <p>&#123;{title_suffix}&#125; 代表副标题 例如:南方39助孕网</p>
                                <p>&#123;{keyword}&#125; 代表关键词 例如:试管婴儿</p>
                                <p>&#123;{domain}&#125; 代表当前域名 例如:www.botadmin.cn</p>
                                <p>&#123;{tag}&#125; 代表tag 例如:广州试管婴儿</p>
                                <p>&#123;{about}&#125; 代表一条关于我们</p>
                                <p>&#123;{link}&#125; 代表链接 例如:试管婴儿=>http://www.botadmin.cn</p>
                                <p>按照这些组成不同的描述</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="layui-tab-item">
                    <div class="layui-form-item">
                        <textarea class="layui-textarea" name="class_names" rows="15">{{join .obj.ClassNames "\n"}}</textarea>
                    </div>
                    <blockquote class="layui-elem-quote">
                        建站随机栏目列表
                    </blockquote>
                </div>
                <div class="layui-tab-item">
                    <div class="layui-form-item">
                        <div id="city" style="text-align:center;overflow:hidden;"></div>
                    </div>
                </div>
                <div class="layui-tab-item">
                    <div class="layui-form-item">
                        <textarea class="layui-textarea" name="ips" rows="15">{{join .obj.Ips "\n"}}</textarea>
                    </div>
                    <blockquote class="layui-elem-quote">
                        自定义IP<br/>
                        一行一条
                    </blockquote>
                </div>
                <div class="layui-tab-item">
                    <div class="layui-form-item">
                        <a class="layui-btn layui-btn-radius"
                           lay-href="/file?path={{.aboutDir}}" lay-tips="添加文件后,必须同步设置才生效">关于设置</a>
                    </div>
                    <blockquote class="layui-elem-quote">
                        一个文件一个关于我们的描述，程序建站时候回随机选择<br/>
                        修改后
                        <button class="layui-btn layui-btn-radius" data-event="sync">同步生效</button>
                    </blockquote>
                    <div class="layui-collapse">
                        <div class="layui-colla-item">
                            <h2 class="layui-colla-title">帮助提示</h2>
                            <div class="layui-colla-content">
                                <p>建站随机选择描述,可用标签是:</p>
                                <p>&#123;{city}&#125; 代表城市名称 例如:广州</p>
                                <p>&#123;{province}&#125; 代表省份 例如:广东</p>
                                <p>&#123;{title}&#125; 代表标题 例如:南方39试管婴儿助孕生殖网</p>
                                <p>&#123;{title_suffix}&#125; 代表副标题 例如:南方39助孕网</p>
                                <p>&#123;{keyword}&#125; 代表关键词 例如:试管婴儿</p>
                                <p>&#123;{domain}&#125; 代表当前域名 例如:www.botadmin.cn</p>
                                <p>&#123;{tag}&#125; 代表tag 例如:广州试管婴儿</p>
                                <p>&#123;{description}&#125; 代表一条描述</p>
                                <p>&#123;{link}&#125; 代表链接 例如:试管婴儿=>http://www.botadmin.cn</p>
                                <p>按照这些组成不同的关于我们</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="layui-tab-item">
                    <div class="layui-form-item">
                        <textarea class="layui-textarea" name="words" rows="15">{{join .obj.Words "\n"}}</textarea>
                    </div>
                    <blockquote class="layui-elem-quote">
                        发布文章时的随机词汇
                    </blockquote>
                </div>
            </div>
        </div>
    </div>
    <div class="layui-card-body layui-form-item">
        <label class="layui-form-label"></label>
        <div class="layui-btn-group">
            <button class="layui-btn" lay-submit lay-filter="submit">提交修改</button>
            <button class="layui-btn" data-event="reset">恢复出厂</button>
        </div>
    </div>
</div>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let main = layui.main,
            form = layui.form,
            transfer = layui.transfer;
        //显示搜索框
        transfer.render({
            id: 'cityData',
            elem: '#city',
            data: {{.cityData}},
            title: ['全部城市', '城市'],
            value: {{.cityValue}},
            showSearch: true
        });
        form.on('submit(submit)', function (obj) {
            let cityData = transfer.getData('cityData'),
                cities = [];
            layui.each(cityData, function (i, v) {
                cities[i] = v.title;
            });
            obj.field.cities = cities.join();
            main.req({
                url: url,
                multiple: true,
                data: obj.field,
            });
            return false;
        });
        $('.layui-btn[data-event]').on('click', function () {
            switch ($(this).data("event")) {
                case "sync":
                    main.req({url: url + '/sync'});
                    break;
                case "reset":
                    main.req({
                        url: url + '/reset',
                        ending: function () {
                            location.replace(url);
                        },
                    });
                    break;
            }
        });
        $('[data-write]').off("click").on("click", function () {
            let $this = $(this), write = $this.data("write"), textareaElem = $this.parent().prevAll("textarea");
            textareaElem.insertAt("{{"{{"}}" + write + "{{"}}"}}");
        });
    });
</script>
