<div class="step-header"></div>
<div class="step-content layui-form">
    <div>
        <div class="layui-form-item">
            <label class="layui-form-label" lay-tips="任务名称必须由中文、数字、字母、下划线组成 唯一">任务名称:</label>
            <div class="layui-input-block">
                <input type="hidden" name="id" value="{{.obj.Id}}" placeholder="本ID">
                <input type="text" name="name" value="{{.obj.Name}}" class="layui-input" required
                       lay-verify="name" placeholder="采集名称">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-row layui-col-space10">
                <div class="layui-col-sm6">
                    <label class="layui-form-label" lay-tips="一行一条 如: http://www.botadmin.cn">初始种子:</label>
                    <div class="layui-input-block">
                    <textarea name="seeds" class="layui-textarea" required
                              lay-verify="seeds">{{join .obj.Seeds "\n"}}</textarea>
                    </div>
                </div>
                <div class="layui-col-sm6">
                    <label class="layui-form-label">备注:</label>
                    <div class="layui-input-block">
                        <textarea name="note" class="layui-textarea">{{.obj.Note}}</textarea>
                    </div>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-collapse" lay-accordion>
                <div class="layui-colla-item">
                    <h2 class="layui-colla-title">翻译处理</h2>
                    <div class="layui-colla-content">
                        <div id="trans-items"></div>
                        <button class="layui-btn layui-btn-sm layui-btn-radius" lay-event="add-trans"
                                style="margin: 10px 40px"
                                lay-tips="新增一次翻译 则多翻译一次 例如：中文 -> 泰文 -> 英文 -> 中文 这样就翻译了3次">
                            <i class="layui-icon layui-icon-add-circle"></i>新增翻译引擎
                        </button>
                    </div>
                </div>
                <div class="layui-colla-item">
                    <h2 class="layui-colla-title">高级选项</h2>
                    <div class="layui-colla-content">
                        <div class="layui-form-item">
                            <div class="layui-inline">
                                <label class="layui-form-label" lay-tips="模拟访问 默认为百度蜘蛛">模拟访问:</label>
                                <div class="layui-input-inline">
                                    <select name="user_agent" class="layui-select" lay-search>
                                        {{range .userAgents -}}
                                            <option value="{{.Value}}"{{if eq $.obj.UserAgent .Value}} selected{{end}}>{{.Alias}}</option>
                                        {{end -}}
                                    </select>
                                </div>
                            </div>
                            <div class="layui-inline">
                                <label class="layui-form-label">原创率:</label>
                                <div class="layui-input-block">
                                    <input type="radio" name="originality" value="0"
                                           title="不检验"{{if eq .obj.Originality 0}} checked{{end}}>
                                    <input type="radio" name="originality" value="1"
                                           title="未检验"{{if eq .obj.Originality 1}} checked{{end}}>
                                    <input type="radio" name="originality" value="2"
                                           title="已检验"{{if eq .obj.Originality 2}} checked{{end}}>
                                </div>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <div class="layui-inline">
                                <label class="layui-form-label" lay-tips="采集入库顺序">入库:</label>
                                <div class="layui-input-block">
                                    <select name="order" class="layui-select">
                                        <option value="0"{{if eq .obj.Order 0}} selected{{end}}>正序</option>
                                        <option value="1"{{if eq .obj.Order 1}} selected{{end}}>倒序</option>
                                        <option value="2"{{if eq .obj.Order 2}} selected{{end}}>URL升序</option>
                                        <option value="3"{{if eq .obj.Order 3}} selected{{end}}>URL降序</option>
                                    </select>
                                </div>
                            </div>
                            <div class="layui-inline">
                                <label class="layui-form-label"
                                       lay-tips="采集间隔 单位为秒 10-20 随机最少10秒最多20秒">Delay:</label>
                                <div class="layui-input-block">
                                    <input type="text" name="delay" class="layui-input" value="{{print .obj.Delay}}"
                                           autocomplete="off" placeholder="10-20">
                                </div>
                            </div>
                            <div class="layui-inline">
                                <label class="layui-form-label" lay-tips="指定字符集">字符集:</label>
                                <div class="layui-input-block">
                                    <select name="charset" class="layui-select">
                                        <option value="">自动</option>
                                        <option value="utf-8"{{if eq .obj.Charset "utf-8"}} selected{{end}}>UTF-8
                                        </option>
                                        <option value="gbk"{{if eq .obj.Charset "gbk"}} selected{{end}}>GBK
                                        </option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <div class="layui-inline">
                                <label class="layui-form-label" lay-tips="内容解码">解码:</label>
                                <div class="layui-input-block">
                                    <select name="decode" class="layui-select">
                                        <option>无</option>
                                        {{range .decodes -}}
                                            <option value="{{.}}"{{if eq $.obj.Decode . }} selected{{end}}>{{.}}</option>
                                        {{end -}}
                                    </select>
                                </div>
                            </div>
                            <div class="layui-inline">
                                <label class="layui-form-label" lay-tips="繁体中文和简体中文转换">繁简转换:</label>
                                <div class="layui-input-block">
                                    <select name="conversion" class="layui-select">
                                        <option>无...</option>
                                        {{range .conversions -}}
                                            <option value="{{.Name}}"{{if eq $.obj.Conversion .Name }} selected{{end}}>{{.Alias}}</option>
                                        {{end -}}
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <div class="layui-inline" style="width: 48%"
                                 lay-tips="格式 key1=value1; key2=value2; 或者一行一条">
                                <label class="layui-form-label">cookies:</label>
                                <div class="layui-input-block">
                                    <textarea name="cookies" class="layui-textarea">{{.obj.Cookies}}</textarea>
                                </div>
                            </div>
                            <div class="layui-inline" style="width: 48%" lay-tips="允许的域名一行一条">
                                <label class="layui-form-label">允许域名:</label>
                                <div class="layui-input-block">
                                        <textarea name="allow_domains"
                                                  class="layui-textarea">{{.obj.AllowDomains}}</textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div>
        <i class="layui-icon layui-icon-addition" lay-event="add-rules" lay-tips="点击无限添加列表规则"></i>
        <div class="layui-tab layui-tab-card" lay-filter="step-list" lay-allowclose="true">
            <ul class="layui-tab-title"></ul>
            <div class="layui-tab-content"></div>
        </div>
        <div class="layui-card-body">
            <div class="layui-btn-group" style="float: right">
                <button class="layui-hide" lay-submit lay-filter="testList"></button>
                <button class="layui-btn" data-event="testList">测试</button>
                <button class="layui-hide" lay-submit lay-filter="sourceCode"></button>
                <button class="layui-btn" data-event="sourceCode">源码</button>
            </div>
        </div>
    </div>
    <div>
        <i class="layui-icon layui-icon-addition" lay-event="add-detail" lay-tips="点击无限添加规则"></i>
        <div class="layui-tab layui-tab-card" lay-filter="step-detail" lay-allowclose="true">
            <ul class="layui-tab-title"></ul>
            <div class="layui-tab-content"></div>
        </div>
        <div class="layui-card-body">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <div class="parse-method">
                        <div class="layui-inline">
                            <label class="layui-form-label-col" lay-tips="DOM匹配下一篇文章URL">NextLink:</label>
                        </div>
                        <div class="layui-inline" style="width: 280px">
                            <input class="layui-input" type="text" name="next_dom" value="{{.obj.NextDom}}"
                                   autocomplete="off" placeholder="div.next > a">
                        </div>
                        <div class="layui-inline" lay-tips="属性名称 默认为 href" style="width: 100px">
                            <input class="layui-input" type="text" name="next_attr_name" value="{{.obj.NextAttrName}}"
                                   autocomplete="off" placeholder="href">
                        </div>
                        <div class="layui-inline">
                            <button class="layui-btn layui-btn-radius" parse-method="" id="next-dom-toggle">转为正则解析
                            </button>
                        </div>
                    </div>
                    <div class="parse-method layui-hide">
                        <div class="layui-inline">
                            <label class="layui-form-label-col" lay-tips="正则匹配下一篇文章URL">NextLink:</label>
                        </div>
                        <div class="layui-inline" style="width: 390px">
                            <input class="layui-input" type="text" name="next_reg" value="{{.obj.NextReg}}"
                                   autocomplete="off" placeholder="<a href='(.*?)'">
                        </div>
                        <div class="layui-inline">
                            <button class="layui-btn layui-btn-radius" parse-method="">转为DOM解析</button>
                        </div>
                    </div>
                </div>
                <div class="layui-inline" style="float: right">
                    <div class="layui-btn-group">
                        <button class="layui-hide" lay-submit lay-filter="testDetail"></button>
                        <button class="layui-btn" data-event="testDetail">测试</button>
                        <button class="layui-btn" data-event="sourceCode">源码</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">绑定网站:</label>
                <div class="layui-input-block">
                    <select name="site_id" lay-filter="site_id" lay-search>
                        <option value="">搜索...</option>
                        {{range .sites -}}
                            <option value="{{.Id}}"{{if eq .Id $.obj.SiteId}} selected{{end}}>{{.Vhost}}</option>
                        {{end -}}
                    </select>
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">绑定栏目:</label>
                <div class="layui-input-block" lay-filter="class_id">
                    {{.class_html}}
                </div>
            </div>
        </div>
        <fieldset class="layui-elem-field">
            <legend>定时采集</legend>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">启用:</label>
                    <div class="layui-input-inline">
                        <input type="checkbox" name="cron_enabled" lay-skin="switch" lay-text="是|否"
                                {{if .obj.CronEnabled}} checked{{end}}>
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">Spec:</label>
                    <div class="layui-input-inline">
                        <input type="text" name="spec" value="{{.obj.Spec}}" class="layui-input">
                    </div>
                </div>
            </div>
        </fieldset>
    </div>
</div>
<!--自定义-->
<script>
    layui.main.cron('[name="spec"]');
    layui.use(['step'], function () {
        let step = layui.step,
            engines = {{.engines}},// 翻译引擎列表
            transList =   {{.obj.Trans}},// 翻译列表
            rules = {{.obj.List}},// 列表规则
            detail = {{.obj.Detail}};// 详情
        /*渲染*/
        step({
            // 进度条
            stepItems: [
                {title: '基本设置'},
                {title: '列表规则'},
                {title: '详情页'},
                {title: '定时采集'},
            ],
            // 翻译配置
            trans: {
                engines: engines || [], // 翻译引擎列表
                items: transList || [], // 已经存在的翻译列表
            },
            // 列表
            rules: rules || [],
            // 详情
            detail: detail || [
                {name: 'title', alias: '标题'},
                {name: 'content', alias: '内容'},
                {name: 'description', alias: '描述'},
                {name: 'keywords', alias: '关键词'},
                {name: 'tags', alias: 'Tags'},
            ],
        });
    });
</script>
