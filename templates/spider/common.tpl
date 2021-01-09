<div class="step-header"></div>
<div class="step-content">
    <div>
        <div class="layui-form-item">
            <label class="layui-form-label" lay-tips="任务名称必须由中文、数字、字母、下划线组成 唯一">任务名称:</label>
            <div class="layui-input-block">
                <input type="hidden" name="id" value="{{.obj.Id}}" autocomplete="off" placeholder="本ID">
                <input type="text" name="name" value="{{.obj.Name}}" class="layui-input" required
                       lay-verify="name"
                       autocomplete="off" placeholder="采集名称">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-row layui-col-space10">
                <div class="layui-col-sm6">
                    <label class="layui-form-label" lay-tips="一行一条 如: https://www.nfivf.com">初始种子:</label>
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
                        <div id="trans-items">
                            {{range $i,$v:=.obj.Trans -}}
                                <div class="layui-form-item">
                                    <div class="layui-inline" style="top:-5px">
                                        <input type="checkbox" name="trans.enabled.{{$i}}" lay-skin="switch"
                                               lay-text="启用|关闭" checked>
                                    </div>
                                    <div class="layui-inline">
                                        <label class="layui-form-label-col">引擎:</label>
                                    </div>
                                    <div class="layui-inline width120">
                                        <select name="trans.engine.{{$i}}" lay-filter="trans.engine.{{$i}}">
                                            {{range $vv:=$.engines}}
                                                <option value="{{$vv.Name}}"{{if eq $vv.Name $v.Engine}} selected{{end}}>{{$vv.Alias}}</option>
                                            {{end}}
                                        </select>
                                    </div>
                                    <div class="layui-inline width120">
                                        <select name="trans.source.{{$i}}" lay-search>
                                            {{if $v.Source -}}
                                                <option value="{{$v.Source}}" selected>{{$v.Source}}</option>
                                            {{end -}}
                                        </select>
                                    </div>
                                    <div class="layui-inline">
                                        <label class="layui-form-label-col" style="color: #009688;">
                                            <i class="layui-icon layui-icon-spread-left"></i>
                                        </label>
                                    </div>
                                    <div class="layui-inline width120">
                                        <select name="trans.target.{{$i}}" lay-search>
                                            {{if $v.Target -}}
                                                <option value="{{$v.Target}}" selected>{{$v.Target}}</option>
                                            {{end -}}
                                        </select>
                                    </div>
                                    <div class="layui-inline">
                                        <label class="layui-form-label-col" style="color: #009688;">
                                            <i class="layui-icon layui-icon-set-sm" lay-tips="选择翻译配置"></i>
                                        </label>
                                    </div>
                                    <div class="layui-inline width120">
                                        <select name="trans.cfg_id.{{$i}}" lay-search>
                                            {{if ne $v.CfgId 0 -}}
                                                <option value="{{$v.CfgId}}" selected>{{$v.CfgId}}</option>
                                            {{end -}}
                                        </select>
                                    </div>
                                    <div class="layui-inline" lay-tips="删除该项">
                                        <button class="layui-btn layui-btn-primary"
                                                style="border:none;color: red"
                                                lay-event="del-trans">
                                            <i class="layui-icon layui-icon-delete"></i>
                                        </button>
                                    </div>
                                </div>
                            {{end -}}
                        </div>
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
                        <div class="layui-form-item">
                            <div class="layui-inline" style="width: 23%">
                                <label class="layui-form-label" lay-tips="原创度0-100 小于这个原创度的网站将丢弃">原创度:</label>
                                <div class="layui-input-block">
                                    <input type="text" name="original_rate" value="{{.obj.OriginalRate}}"
                                           autocomplete="off" placeholder="70"
                                           class="layui-input">
                                </div>
                            </div>
                            <div class="layui-inline" style="width: 23%"
                                 lay-tips="采集间隔 单位为秒 10-20 随机最少10秒最多20秒">
                                <label class="layui-form-label">Delay:</label>
                                <div class="layui-input-block">
                                    <input type="text" name="delay" class="layui-input" value="{{.obj.Delay}}"
                                           autocomplete="off" placeholder="10-20">
                                </div>
                            </div>
                            <div class="layui-inline" style="width: 23%" lay-tips="指定字符集">
                                <label class="layui-form-label">字符集:</label>
                                <div class="layui-input-block">
                                    <select name="charset">
                                        <option value="">自动</option>
                                        <option value="utf-8"{{if eq .obj.Charset "utf-8"}} selected{{end}}>
                                            UTF-8
                                        </option>
                                        <option value="gbk"{{if eq .obj.Charset "gbk"}} selected{{end}}>GBK
                                        </option>
                                    </select>
                                </div>
                            </div>
                            <div class="layui-inline" style="width: 23%" lay-tips="内容解码">
                                <label class="layui-form-label">解码:</label>
                                <div class="layui-input-block">
                                    <select name="decode">
                                        <option>无</option>
                                        {{range .decodes -}}
                                            <option value="{{.}}"{{if eq $.obj.Decode . }} selected{{end}}>{{.}}</option>
                                        {{end -}}
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div>
        <i class="layui-icon layui-icon-addition" lay-event="addListRule" lay-tips="点击无限添加列表规则"></i>
        <div class="layui-tab layui-tab-card" lay-filter="step-list" lay-allowclose="true">
            <ul class="layui-tab-title"></ul>
            <div class="layui-tab-content"></div>
        </div>
        <div class="layui-card-body">
            <button class="layui-hide" lay-submit lay-filter="testList"></button>
            <button class="layui-btn" data-event="testList">测试采集</button>
        </div>
    </div>
    <div>
        <i class="layui-icon layui-icon-addition" lay-event="addDetailRule" lay-tips="点击无限添加规则"></i>
        <div class="layui-tab layui-tab-card" lay-filter="step-detail" lay-allowclose="true">
            <ul class="layui-tab-title"></ul>
            <div class="layui-tab-content"></div>
        </div>
        <div class="layui-card-body">
            <button class="layui-hide" lay-submit lay-filter="testDetail"></button>
            <button class="layui-btn" data-event="testDetail">测试采集</button>
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
                <label class="layui-form-label">启用</label>
                <div class="layui-input-inline">
                    <input type="checkbox" name="cron_enabled" lay-skin="switch" lay-text="是|否"
                            {{if .obj.CronEnabled}} checked{{end}}>
                </div>
                <div class="layui-form-mid layui-word-aux">是否启用定时采集</div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">分:</label>
                <div class="layui-input-inline">
                    <input type="text" name="minute" value="{{.obj.Minute}}"
                           class="layui-input">
                </div>
                <div class="layui-form-mid layui-word-aux">0-59 *-,</div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">时:</label>
                <div class="layui-input-inline">
                    <input type="text" name="hour" value="{{.obj.Hour}}"
                           class="layui-input">
                </div>
                <div class="layui-form-mid layui-word-aux">0-23 *-,</div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">天:</label>
                <div class="layui-input-inline">
                    <input type="text" name="day" value="{{.obj.Day}}"
                           class="layui-input">
                </div>
                <div class="layui-form-mid layui-word-aux">1-31 *-,</div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">月:</label>
                <div class="layui-input-inline">
                    <input type="text" name="month" value="{{.obj.Month}}"
                           class="layui-input">
                </div>
                <div class="layui-form-mid layui-word-aux">1-12 *-,</div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">周:</label>
                <div class="layui-input-inline">
                    <input type="text" name="week" value="{{.obj.Week}}"
                           class="layui-input">
                </div>
                <div class="layui-form-mid layui-word-aux">0-6 *-,</div>
            </div>
        </fieldset>
    </div>
</div>
<!--翻译列表-->
<script type="text/template" id="trans-item">
    <div class="layui-form-item">
        <div class="layui-inline" style="top:-5px">
            <input type="checkbox" name="trans.enabled.{num}" lay-skin="switch" lay-text="启用|关闭" checked>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label-col">引擎:</label>
        </div>
        <div class="layui-inline width120">
            <select name="trans.engine.{num}" lay-filter="trans.engine.{num}">
                {{range $v:=.engines}}
                    <option value="{{$v.Name}}">{{$v.Alias}}</option>
                {{end}}
            </select>
        </div>
        <div class="layui-inline width120">
            <select name="trans.source.{num}" lay-search></select>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label-col" style="color: #009688;">
                <i class="layui-icon layui-icon-spread-left"></i>
            </label>
        </div>
        <div class="layui-inline width120">
            <select name="trans.target.{num}" lay-search></select>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label-col" style="color: #009688;">
                <i class="layui-icon layui-icon-set-sm" lay-tips="选择翻译配置"></i>
            </label>
        </div>
        <div class="layui-inline width120">
            <select name="trans.cfg_id.{num}" lay-search></select>
        </div>
        <div class="layui-inline" lay-tips="删除该项">
            <button class="layui-btn layui-btn-primary" style="border:none;color: red" lay-event="del-trans">
                <i class="layui-icon layui-icon-delete"></i>
            </button>
        </div>
    </div>
</script>
<!--列表解析HTML-->
<script type="text/template" id="step-list-item">
    <div class="layui-tab-item layui-show">
        <div class="layui-collapse" lay-accordion>
            <div class="layui-colla-item">
                <h2 class="layui-colla-title">列表采集</h2>
                <div class="layui-colla-content layui-show">
                    <fieldset class="layui-elem-field layui-field-title">
                        <legend>获取</legend>
                    </fieldset>
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label-col">指定范围:</label>
                        </div>
                        <div class="layui-inline">
                            <div class="layui-input-inline">
                                <input type="text" name="list.limit." value="" class="layui-input"
                                       autocomplete="off" placeholder="&lt;html[^&gt;]*&gt;([\s\S]*?)&lt;/html&gt;">
                            </div>
                            <div class="layui-form-mid layui-word-aux">指定获取范围 为空则不指定 &lt;html[^&gt;]*&gt;([\s\S]*?)&lt;/html&gt;
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="parse-method">
                            <div class="layui-inline">
                                <label class="layui-form-label-col" lay-tips="一行一条规则，逐行匹配到则终止匹配">DOM解析:</label>
                            </div>
                            <div class="layui-inline">
                                <textarea class="layui-textarea" name="list.dom."></textarea>
                            </div>
                            <div class="layui-inline" lay-tips="选择dom取值方法">
                                <div class="layui-input-inline" style="width: 80px">
                                    <select name="list.method." lay-filter="method">
                                        <option value="attr">Attr</option>
                                        <option value="text">Text</option>
                                        <option value="html">Html</option>
                                    </select>
                                </div>
                            </div>
                            <div class="layui-inline" lay-tips="属性名称 默认为 href">
                                <input type="text" name="list.attr_name." value="href" class="layui-input">
                            </div>
                            <div class="layui-inline">
                                <button class="layui-btn layui-btn-radius" parse-method>转为正则解析</button>
                            </div>
                        </div>
                        <div class="parse-method layui-hide">
                            <div class="layui-inline">
                                <label class="layui-form-label-col">正则解析:</label>
                            </div>
                            <div class="layui-inline" style="width: 55%" lay-tips="一行一条规则，逐行匹配到则终止匹配">
                                <textarea class="layui-textarea" name="list.reg."></textarea>
                            </div>
                            <div class="layui-inline">
                                <button class="layui-btn layui-btn-radius" parse-method>转为DOM解析</button>
                            </div>
                        </div>
                    </div>
                    <fieldset class="layui-elem-field layui-field-title">
                        <legend>正则过滤</legend>
                    </fieldset>
                    <div class="layui-form-item">
                        <label class="layui-form-label"
                               lay-tips="例如:只匹配以/index.html结尾的数据 /index\.html$">正则匹配:</label>
                        <div class="layui-input-block">
                            <input type="text" name="list.match." value="" class="layui-input"
                                   autocomplete="off" placeholder="/\d+\.html$">
                        </div>
                    </div>
                    <fieldset class="layui-elem-field layui-field-title">
                        <legend>字符串、正则或DOM替换</legend>
                    </fieldset>
                    <div class="layui-form-item">
                        <div class="layui-inline" style="width: 38%" lay-tips="原词 一行一条">
                            <textarea name="list.olds." class="layui-textarea"></textarea>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label-col" style="color: #009688;">
                                <i class="layui-icon layui-icon-spread-left"></i>
                            </label>
                        </div>
                        <div class="layui-inline" style="width: 38%" lay-tips="替换成 对应原词一行一条">
                            <textarea name="list.news." class="layui-textarea"></textarea>
                        </div>
                        <div class="layui-inline" style="width: 12%">
                            <select name="list.type." class="layui-select">
                                <option value="0" selected>字符串</option>
                                <option value="1">正则</option>
                                <option value="2">DOM</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>
            <div class="layui-colla-item">
                <h2 class="layui-colla-title">分页采集</h2>
                <div class="layui-colla-content">
                    <div class="layui-form-item">
                        <label class="layui-form-label">开启分页:</label>
                        <div class="layui-input-inline">
                            <input type="checkbox" name="list.page.enabled." lay-skin="switch"
                                   lay-text="开启|关闭">
                        </div>
                    </div>
                    <fieldset class="layui-elem-field layui-field-title">
                        <legend>获取</legend>
                    </fieldset>
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label-col">指定范围:</label>
                        </div>
                        <div class="layui-inline">
                            <div class="layui-input-inline">
                                <input type="text" name="list.page.limit." value=""
                                       class="layui-input"
                                       autocomplete="off"
                                       placeholder="&lt;html[^&gt;]*&gt;([\s\S]*?)&lt;/html&gt;">
                            </div>
                            <div class="layui-form-mid layui-word-aux">指定获取范围 为空则不指定 &lt;html[^&gt;]*&gt;([\s\S]*?)&lt;/html&gt;
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="parse-method">
                            <div class="layui-inline">
                                <label class="layui-form-label-col">DOM解析:</label>
                            </div>
                            <div class="layui-inline" lay-tips="一行一条规则，逐行匹配到则终止匹配">
                                <textarea class="layui-textarea" name="list.page.dom."></textarea>
                            </div>
                            <div class="layui-inline" lay-tips="选择dom取值方法">
                                <div class="layui-input-inline" style="width: 80px">
                                    <select name="list.page.method." lay-filter="method">
                                        <option value="attr">Attr</option>
                                        <option value="text">Text</option>
                                        <option value="html">Html</option>
                                    </select>
                                </div>
                            </div>
                            <div class="layui-inline" lay-tips="属性名称 默认为 href">
                                <input type="text" name="list.page.attr_name." value="href" class="layui-input">
                            </div>
                            <div class="layui-inline">
                                <button class="layui-btn layui-btn-radius" parse-method>转为正则解析</button>
                            </div>
                        </div>
                        <div class="parse-method layui-hide">
                            <div class="layui-inline">
                                <label class="layui-form-label-col">正则解析:</label>
                            </div>
                            <div class="layui-inline" style="width: 55%" lay-tips="一行一条规则，逐行匹配到则终止匹配">
                                <textarea class="layui-textarea" name="list.page.reg."></textarea>
                            </div>
                            <div class="layui-inline">
                                <button class="layui-btn layui-btn-radius" parse-method>转为DOM解析</button>
                            </div>
                        </div>
                    </div>
                    <fieldset class="layui-elem-field layui-field-title">
                        <legend>正则过滤</legend>
                    </fieldset>
                    <div class="layui-form-item">
                        <label class="layui-form-label"
                               lay-tips="例如:只匹配以/index.html结尾的数据 /index\.html$">正则匹配:</label>
                        <div class="layui-input-block">
                            <input type="text" name="list.page.match." value="" class="layui-input"
                                   autocomplete="off" placeholder="/\d+\.html$">
                        </div>
                    </div>
                    <fieldset class="layui-elem-field layui-field-title">
                        <legend>字符串、正则或DOM替换</legend>
                    </fieldset>
                    <div class="layui-form-item">
                        <div class="layui-inline" style="width: 38%" lay-tips="原词 一行一条">
                            <textarea name="list.page.olds." class="layui-textarea"></textarea>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label-col" style="color: #009688;">
                                <i class="layui-icon layui-icon-spread-left"></i>
                            </label>
                        </div>
                        <div class="layui-inline" style="width: 38%" lay-tips="替换成 对应原词一行一条">
                            <textarea name="list.page.news." class="layui-textarea"></textarea>
                        </div>
                        <div class="layui-inline" style="width: 12%">
                            <select name="list.page.type." class="layui-select">
                                <option value="0" selected>字符串</option>
                                <option value="1">正则</option>
                                <option value="2">DOM</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>
<!--详情解析 HTML-->
<script type="text/template" id="step-detail-item">
    <div class="layui-tab-item layui-show">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label-col">指定范围:</label>
            </div>
            <div class="layui-inline">
                <div class="layui-input-inline">
                    <input type="text" name="detail.limit." value="" class="layui-input"
                           autocomplete="off"
                           placeholder="&lt;html[^&gt;]*&gt;([\s\S]*?)&lt;/html&gt;">
                </div>
                <div class="layui-form-mid layui-word-aux">指定获取范围 为空则不指定 &lt;html[^&gt;]*&gt;([\s\S]*?)&lt;/html&gt;
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="parse-method">
                <div class="layui-inline">
                    <label class="layui-form-label-col" lay-tips="一行一条规则，逐行匹配到则终止匹配">DOM解析:</label>
                </div>
                <div class="layui-inline">
                    <textarea class="layui-textarea" name="detail.dom."></textarea>
                </div>
                <div class="layui-inline" lay-tips="选择dom取值方法">
                    <div class="layui-input-inline" style="width: 80px">
                        <select name="detail.method." lay-filter="method">
                            <option value="text">Text</option>
                            <option value="attr">Attr</option>
                            <option value="html">Html</option>
                        </select>
                    </div>
                </div>
                <div class="layui-inline" lay-tips="属性名称 默认为 href">
                    <input type="hidden" name="detail.attr_name." value="href" class="layui-input">
                </div>
                <div class="layui-inline">
                    <button class="layui-btn layui-btn-radius" parse-method>转为正则解析</button>
                </div>
            </div>
            <div class="parse-method layui-hide">
                <div class="layui-inline">
                    <label class="layui-form-label-col" lay-tips="一行一条规则，逐行匹配到则终止匹配">正则解析:</label>
                </div>
                <div class="layui-inline" style="width: 55%">
                    <textarea class="layui-textarea" name="detail.reg."></textarea>
                </div>
                <div class="layui-inline">
                    <button class="layui-btn layui-btn-radius" parse-method>转为DOM解析</button>
                </div>
            </div>
        </div>
        <fieldset class="layui-elem-field layui-field-title">
            <legend>正则过滤</legend>
        </fieldset>
        <div class="layui-form-item">
            <label class="layui-form-label" lay-tips="例如:只匹配以/index.html结尾的数据 /index\.html$">正则匹配:</label>
            <div class="layui-input-block">
                <input type="text" name="detail.match." value="" class="layui-input"
                       autocomplete="off" placeholder="/\d+\.html$">
            </div>
        </div>
        <fieldset class="layui-elem-field layui-field-title">
            <legend>DOM替换</legend>
        </fieldset>
        <div class="layui-form-item">
            <div class="layui-inline" style="width: 45%" lay-tips="原词 一行一条">
                <textarea name="detail.filter_dom.olds." class="layui-textarea"></textarea>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label-col" style="color: #009688;">
                    <i class="layui-icon layui-icon-spread-left"></i>
                </label>
            </div>
            <div class="layui-inline" style="width: 45%" lay-tips="替换成 对应原词一行一条">
                <textarea name="detail.filter_dom.news." class="layui-textarea"></textarea>
            </div>
        </div>
        <fieldset class="layui-elem-field layui-field-title">
            <legend>字符串、正则或DOM替换</legend>
        </fieldset>
        <div class="layui-form-item">
            <div class="layui-inline" style="width: 38%" lay-tips="原词 一行一条">
                <textarea name="detail.olds." class="layui-textarea"></textarea>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label-col" style="color: #009688;">
                    <i class="layui-icon layui-icon-spread-left"></i>
                </label>
            </div>
            <div class="layui-inline" style="width: 38%" lay-tips="替换成 对应原词一行一条">
                <textarea name="detail.news." class="layui-textarea"></textarea>
            </div>
            <div class="layui-inline" style="width: 12%">
                <select name="detail.type." class="layui-select">
                    <option value="0" selected>字符串</option>
                    <option value="1">正则</option>
                    <option value="2">DOM</option>
                </select>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline layui-hide">
                <input type="checkbox" name="detail.raw." title="原始">
            </div>
        </div>
    </div>
</script>
<!--自定义-->
<script>
    JS.use(['step'], function () {
        let step = layui.step,
            element = layui.element,
            main = layui.main,
            form = layui.form,
            currentIndex = $('.step-content').closest('[times]').attr('times'), //先得到当前iframe层的索引;
            currentId = $('input[name=id][type=hidden]').val() || 0,
            seeds = Array(), //种子列表
            classes = {}, //栏目HTML
            utils = {
                /*总渲染*/
                render: function () {
                    //添加列表规则
                    $('[lay-event=addListRule]').click(function () {
                        let listTabTitleThis = $('[lay-filter=step-list]>ul.layui-tab-title'),
                            isEmpty = listTabTitleThis.children().length === 0;
                        if (isEmpty) {
                            listTabTitleThis.html('<li lay-id="0" class="layui-this">Rule-1</li>');
                        }
                        let options = new utils.buildListItem(),
                            tabAdd = element.tabAdd('step-list', {
                                title: 'Rule-' + (options.id + 1),
                                content: options.dom.html(),
                                id: options.id
                            });
                        if (isEmpty) {
                            listTabTitleThis.html('<li lay-id="0" class="layui-this">Rule-1</li>');
                            tabAdd.tabChange('step-list', 0);
                        } else {
                            tabAdd.tabChange('step-list', options.id);
                        }
                        element.render();
                        form.render();
                        utils.renderMethod();
                    });
                    //添加详情规则
                    $('[lay-event=addDetailRule]').click(function () {
                        let existsHtml = $('[lay-filter=step-detail]').html();
                        layer.prompt({
                            formType: 0,
                            value: 'author',
                            title: '输入标识 由字母下划线或数字组成 字母开头'
                        }, function (name, index) {
                            if (!/^[a-zA-Z][a-zA-Z0-9_]+/.test(name)) {
                                layer.alert('您输入的标识不合法!', {icon: 2});
                                return false;
                            }
                            if (existsHtml.indexOf('value="' + name + '"') !== -1) {
                                layer.alert('您输入的标识"' + name + '"已经存在', {icon: 2});
                                return false;
                            }
                            layer.prompt({
                                formType: 0,
                                value: name.substring(0, 1).toUpperCase() + name.substring(1),
                                title: '请输入别名 例如:标题'
                            }, function (alias, index) {
                                if (existsHtml.indexOf('value="' + alias + '"') !== -1) {
                                    layer.alert('您输入的别名"' + alias + '"已经存在', {icon: 2});
                                    return false;
                                }
                                let opts = new utils.buildDetailItem({name: name, alias: alias});
                                if (!opts.dom || opts.dom.length === 0) {
                                    layer.alert('添加内容为空', {icon: 2});
                                    return false;
                                }
                                element.tabAdd('step-detail', {
                                    title: alias,
                                    content: opts.dom.html(),
                                    id: opts.id
                                }).tabChange('step-detail', opts.id);
                                layer.close(index);
                                element.render();
                                form.render();
                                utils.renderMethod();
                            });
                            layer.close(index);
                        });
                    });
                    //监控选择网站ID
                    form.on('select(site_id)', function (obj) {
                        utils.bindClass(obj.value);
                    });
                    /*测试列表页*/
                    $('button[data-event=testList]').click(function () {
                        $('.step-content').addClass('layui-form');
                        $('button[lay-filter=testList]').click();
                    });
                    form.on('submit(testList)', function (obj) {
                        $('.step-content').removeClass('layui-form');
                        main.req({
                            url: '/spider/test/list',
                            data: obj.field,
                            tips: function (res) {
                                main.msg(res.msg);
                            },
                            success: function (res) {
                                if (res.code === 0) {
                                    seeds = res.data;
                                }
                            }
                        });
                    });
                    /*测试详情页*/
                    $('button[data-event=testDetail]').click(function () {
                        $('.step-content').addClass('layui-form');
                        $('button[lay-filter=testDetail]').click();
                    });
                    form.on('submit(testDetail)', function (obj) {
                        $('.step-content').removeClass('layui-form');
                        if (seeds.length === 0) {
                            seeds = obj.field.seeds.split("\n")
                        }
                        layer.prompt({
                            formType: 0,
                            value: seeds[0],
                            title: '请输入完整的URL地址 http 开头'
                        }, function (value, index) {
                            obj.field.detail_url = value;
                            main.req({
                                url: '/spider/test/detail',
                                data: obj.field,
                                index: index,
                                tips: function (res) {
                                    main.msg(res.msg);
                                }
                            });
                        });
                    });
                    //验证提交
                    form.on('submit(stepSubmit)', function (obj) {
                        if (typeof currentIndex === 'undefined') {
                            currentIndex = function () {
                                layer.closeAll();
                            }
                        }
                        main.req({
                            url: currentId > 0 ? '/spider/modify' : '/spider/add',
                            data: obj.field,
                            index: currentIndex,
                            ending: function () {
                                location.reload();
                            }
                        });
                    });
                    element.render();
                    utils.renderMethod();
                    form.render();
                },
                /*绑定栏目*/
                bindClass: function (id, classId) {
                    if (isNaN(parseInt(id))) {
                        $('select[name=class_id]').replaceWith(`<select name="class_id" lay-search><option value="">搜索...</option></select>`);
                        form.render('select');
                        return false
                    }
                    if (typeof classes[id] === 'string' && classes[id].length > 10) {
                        $('[lay-filter=class_id]').html(classes[id]);
                        form.render();
                        return false;
                    }
                    $.get('/site/class', {id: id, class_id: classId}, function (res) {
                        if (res.code === 0) {
                            classes[id] = res.data;
                            $('[lay-filter=class_id]').html(res.data);
                            form.render();
                        } else {
                            layer.alert(res.msg, {icon: 2});
                        }
                    });
                },
                /*获取lay-id*/
                getLayId: function (elem) {
                    let ids = Array(), id = 0;
                    $(elem).each(function () {
                        let layId = parseInt($(this).attr('lay-id'));
                        if (!isNaN(layId)) {
                            ids.push(layId);
                        }
                    });
                    if (ids.length > 0) {
                        id = Math.max.apply(null, ids) + 1;
                    }
                    return id
                },
                /*构建 详情 item*/
                buildDetailItem: function (field, id) {
                    if (Object.prototype.toString.call(field) !== '[object Object]' || typeof field.name !== 'string') {
                        return false;
                    }
                    if (typeof field.alias !== 'string' || field.alias.length === 0) {
                        field.alias = field.name.substring(0, 1).toUpperCase() + field.name.substring(1);
                    }
                    id = parseInt(id);
                    if (isNaN(id)) {
                        id = utils.getLayId('[lay-filter=step-detail]>.layui-tab-title>li[lay-id]');
                    }
                    let dom = $($('#step-detail-item').html());
                    dom.find('[name]').each(function () {
                        let othis = $(this);
                        othis.attr('name', othis.attr('name') + id);
                    });
                    if (field && typeof field.dom === 'string') {
                        field = $.extend({
                            limit: '',
                            method: '',
                            attr_name: '',
                            match: '',
                            type: 0,
                            raw: false,
                            reg: '',
                            filter_dom: null
                        }, field);
                        field.olds = field.olds || [];
                        field.news = field.news || [];
                        dom.find('[name="detail.limit.' + id + '"]').val(field.limit);
                        dom.find('[name="detail.method.' + id + '"]>option[value=' + field.method + ']').prop('selected', true);
                        dom.find('[name="detail.attr_name.' + id + '"]').val(field.attr_name);
                        dom.find('[name="detail.match.' + id + '"]').val(field.match);
                        if (field.filter_dom) {
                            field.filter_dom.olds = field.filter_dom.olds || [];
                            field.filter_dom.news = field.filter_dom.news || [];
                            dom.find('[name="detail.filter_dom.olds.' + id + '"]').val(field.filter_dom.olds.join('\n'));
                            dom.find('[name="detail.filter_dom.news.' + id + '"]').val(field.filter_dom.news.join('\n'));
                        }
                        dom.find('[name="detail.olds.' + id + '"]').val(field.olds.join('\n'));
                        dom.find('[name="detail.news.' + id + '"]').val(field.news.join('\n'));
                        dom.find('[name="detail.type.' + id + '"]>option[value=' + field.type + ']').prop('selected', true);
                        dom.find('[name="detail.raw.' + id + '"]').prop('checked', field.raw);
                        if (field.reg.length > 0) {
                            dom.find('[name="detail.reg.' + id + '"]').val(field.reg)
                                .closest('.parse-method').removeClass('layui-hide');
                            dom.find('[name="detail.dom.' + id + '"]')
                                .closest('.parse-method').addClass('layui-hide');
                        } else {
                            dom.find('[name="detail.dom.' + id + '"]').val(field.dom)
                                .closest('.parse-method').removeClass('layui-hide');
                            dom.find('[name="detail.reg.' + id + '"]')
                                .closest('.parse-method').addClass('layui-hide');
                            if (field.method === 'html') {
                                dom.find('[name="detail.raw.' + id + '"]').parent().removeClass('layui-hide');
                            }
                        }
                        if (id > 0) {
                            dom.removeClass('layui-show');
                        }
                    } else {
                        switch (field.name) {
                            case 'title':
                                dom.find('[name="detail.dom.' + id + '"]').val('h1');
                                dom.find('[name="detail.method.' + id + '"]>option[value=text]').prop('selected', true);
                                break;
                            case 'tags':
                                dom.find('[name="detail.dom.' + id + '"]').val('.tags');
                                dom.find('[name="detail.method.' + id + '"]>option[value=text]').prop('selected', true);
                                break;
                            case 'content':
                                dom.find('[name="detail.dom.' + id + '"]').val('body');
                                dom.find('[name="detail.method.' + id + '"]>option[value=html]').prop('selected', true);
                                dom.find('[name="detail.raw.' + id + '"]').parent().removeClass('layui-hide');
                                break;
                            case 'keywords':
                                dom.find('[name="detail.dom.' + id + '"]').val('meta[name=keywords]');
                                dom.find('[name="detail.method.' + id + '"]>option[value=attr]').prop('selected', true);
                                dom.find('[name="detail.attr_name.' + id + '"]').val('content').attr('type', 'text');
                                break;
                            case 'description':
                                dom.find('[name="detail.dom.' + id + '"]').val('meta[name=description]');
                                dom.find('[name="detail.method.' + id + '"]>option[value=attr]').prop('selected', true);
                                dom.find('[name="detail.attr_name.' + id + '"]').val('content').attr('type', 'text');
                                break;
                        }
                    }
                    dom.append(`<div class="layui-hide"><input type="hidden" name="detail.alias.` + id + `" value="` + field.alias + `"><input type="hidden" name="detail.name.` + id + `" value="` + field.name + `"></div>`);
                    this.dom = dom;
                    this.id = id;
                },
                /*构建 列表 item*/
                buildListItem: function (id, field) {
                    let dom = $($('#step-list-item').html());
                    id = parseInt(id);
                    if (isNaN(id)) {
                        id = utils.getLayId('[lay-filter=step-list]>.layui-tab-title>li[lay-id]');
                    }
                    dom.find('[name]').each(function () {
                        let othis = $(this);
                        othis.attr('name', othis.attr('name') + id);
                    });
                    if (field && typeof field.dom === 'string') {
                        field = $.extend({
                            limit: '',
                            reg: '',
                            method: 'attr',
                            attr_name: '',
                            match: '',
                            type: 0
                        }, field);
                        field.olds = field.olds || [];
                        field.news = field.news || [];
                        dom.find('[name="list.limit.' + id + '"]').val(field.limit);
                        if (field.reg.length > 0) {
                            dom.find('[name="list.reg.' + id + '"]').val(field.reg)
                                .closest('.parse-method').removeClass('layui-hide');
                            dom.find('[name="list.dom.' + id + '"]')
                                .closest('.parse-method').addClass('layui-hide');
                        } else {
                            dom.find('[name="list.dom.' + id + '"]').val(field.dom)
                                .closest('.parse-method').removeClass('layui-hide');
                            dom.find('[name="list.reg.' + id + '"]')
                                .closest('.parse-method').addClass('layui-hide');
                        }
                        dom.find('[name="list.method.' + id + '"]>option[value=' + field.method + ']').prop('selected', true);
                        dom.find('[name="list.attr_name.' + id + '"]').val(field.attr_name);
                        dom.find('[name="list.match.' + id + '"]').val(field.match);
                        dom.find('[name="list.olds.' + id + '"]').val(field.olds.join('\n'));
                        dom.find('[name="list.news.' + id + '"]').val(field.news.join('\n'));
                        dom.find('[name="list.type.' + id + '"]>option[value=' + field.type + ']').prop('selected', true);
                        if (field.page) {
                            field.page = $.extend({
                                enabled: false,
                                limit: '',
                                method: '',
                                attr_name: '',
                                match: '',
                                type: 0,
                                reg: '',
                                dom: '',
                            }, field.page);
                            field.page.olds = field.page.olds || [];
                            field.page.news = field.page.news || [];
                            dom.find('[name="list.page.enabled.' + id + '"]').prop('checked', field.page.enabled);
                            dom.find('[name="list.page.limit.' + id + '"]').val(field.page.limit);
                            dom.find('[name="list.page.method.' + id + '"]>option[value=' + field.page.method + ']').prop('selected', true);
                            dom.find('[name="list.page.attr_name.' + id + '"]').val(field.page.attr_name);
                            dom.find('[name="list.page.match.' + id + '"]').val(field.page.match);
                            dom.find('[name="list.page.olds.' + id + '"]').val(field.page.olds.join('\n'));
                            dom.find('[name="list.page.news.' + id + '"]').val(field.page.news.join('\n'));
                            dom.find('[name="list.page.type.' + id + '"]>option[value=' + field.page.type + ']').prop('selected', true);
                            if (field.page.reg.length > 0) {
                                dom.find('[name="list.page.reg.' + id + '"]').val(field.page.reg)
                                    .closest('.parse-method').removeClass('layui-hide');
                                dom.find('[name="list.page.dom.' + id + '"]')
                                    .closest('.parse-method').addClass('layui-hide');
                            } else {
                                dom.find('[name="list.page.dom.' + id + '"]').val(field.page.dom)
                                    .closest('.parse-method').removeClass('layui-hide');
                                dom.find('[name="list.page.reg.' + id + '"]')
                                    .closest('.parse-method').addClass('layui-hide');
                            }
                        }
                        if (id > 0) {
                            dom.removeClass('layui-show');
                        }
                    }
                    this.dom = dom;
                    this.id = id;
                },
                /*转换解析方法*/
                renderMethod: function () {
                    $('button[parse-method]').click(function () {
                        let othis = $(this),
                            parent = othis.closest('div.parse-method');
                        parent.addClass('layui-hide');
                        parent.siblings().removeClass('layui-hide');
                    });
                    /* jquery 解析方法 attr text html*/
                    form.on('select(method)', function (obj) {
                        switch (obj.value) {
                            case 'attr':
                                obj.othis.closest('.parse-method').find('input[name*=".attr_name."]').attr('type', 'text');
                                obj.othis.closest('.layui-tab-item').find('input[name*=".raw."]').parent().addClass("layui-hide");
                                break;
                            case 'html':
                                obj.othis.closest('.layui-tab-item').find('input[name*=".raw."]').parent().removeClass("layui-hide");
                                obj.othis.closest('.parse-method').find('input[name*=".attr_name."]').attr('type', 'hidden');
                                break;
                            default:
                                obj.othis.closest('.layui-tab-item').find('input[name*=".raw."]').parent().addClass("layui-hide");
                                obj.othis.closest('.parse-method').find('input[name*=".attr_name."]').attr('type', 'hidden');
                        }
                    });
                },
                /*初始化详情步骤*/
                initDetail: function () {
                    let fields = [
                            {name: 'title', alias: '标题'},
                            {name: 'content', alias: '内容'},
                            {name: 'description', alias: '描述'},
                            {name: 'keywords', alias: '关键词'},
                            {name: 'tags', alias: 'Tags'},
                        ],
                        tabTitleDom = $('[lay-filter=step-detail]>ul.layui-tab-title'),
                        tabContentDom = $('[lay-filter=step-detail]>div.layui-tab-content');
                    $.each(fields, function (i, v) {
                        let opts = new utils.buildDetailItem(v, i);
                        if (opts.id === 0) {
                            tabTitleDom.append('<li class="layui-this" lay-id="' + opts.id + '">' + v.alias + '</li>');
                        } else {
                            tabTitleDom.append('<li lay-id="' + opts.id + '">' + v.alias + '</li>');
                            opts.dom.removeClass('layui-show');
                        }
                        if (!opts.dom || opts.dom.length === 0) {
                            tabContentDom.append('<div class="layui-tab-item layui-show"></div>');
                        } else {
                            tabContentDom.append(opts.dom);
                        }
                    });
                },
                /*初始化列表步骤*/
                initList: function () {
                    let opts = new utils.buildListItem(0);
                    $('[lay-filter=step-list]>ul.layui-tab-title').html('<li class="layui-this" lay-id="0">Rule-1</li>');
                    if (!opts.dom || opts.dom.length === 0) {
                        $('[lay-filter=step-list]>div.layui-tab-content').html(`<div class="layui-tab-item  layui-show"></div>`);
                    } else {
                        $('[lay-filter=step-list]>div.layui-tab-content').html(opts.dom);
                    }
                }
            },
            stepList = {{.obj.List}},
            detailList = {{.obj.Detail}};
        /* 初始化已经存在的列表*/
        if (stepList) {
            let titleDom = $('.layui-tab[lay-filter="step-list"]>ul.layui-tab-title'),
                contentDom = $('.layui-tab[lay-filter="step-list"]>div.layui-tab-content');
            $.each(stepList, function (index, field) {
                let opts = new utils.buildListItem(index, field);
                titleDom.append(`<li lay-id="` + opts.id + `"` + (opts.id === 0 ? ' class="layui-this"' : '') + `>Rule-` + (opts.id + 1) + `</li>`);
                contentDom.append(opts.dom);
            })
        }

        /*初始化已经存在的详情列表*/
        if (detailList) {
            let titleDom = $('.layui-tab[lay-filter="step-detail"]>ul.layui-tab-title'),
                contentDom = $('.layui-tab[lay-filter="step-detail"]>div.layui-tab-content');
            $.each(detailList, function (index, field) {
                let opts = new utils.buildDetailItem(field, index);
                titleDom.append(`<li lay-id="` + opts.id + `"` + (opts.id === 0 ? ' class="layui-this"' : '') + `>` + field.alias + `</li>`);
                contentDom.append(opts.dom);
            })
        }

        /*渲染步骤*/
        step.render({
            position: 0,
            contentW: '90%',
            data: [{title: '基本设置'}, {title: '列表规则'},
                {title: '详情页'}, {title: '定时采集'}]
        });
        if (currentId < 1) {
            /*初始化默认列表规则*/
            utils.initList();
            /*初始化默认详情规则*/
            utils.initDetail();
        }
        /*小工具渲染*/
        utils.render();
    });
</script>