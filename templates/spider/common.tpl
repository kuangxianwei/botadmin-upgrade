<div class="layui-card">
    <div class="layui-card-body step-header"></div>
    <div class="layui-card-body step-content">
        <div>
            <div class="layui-form-item">
                <label class="layui-form-label" lay-tips="任务名称必须由中文、数字、字母、下划线组成 唯一">任务名称:</label>
                <div class="layui-input-block">
                    <input type="hidden" name="id" value="{{.obj.Id}}" autocomplete="off" placeholder="本ID">
                    <input type="text" name="name" value="{{.obj.Name}}" class="layui-input" required lay-verify="name"
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
                                            <button class="layui-btn layui-btn-primary" style="border:none;color: red"
                                                    lay-event="del-trans">
                                                <i class="layui-icon layui-icon-delete"></i>
                                            </button>
                                        </div>
                                    </div>
                                {{end -}}
                            </div>
                            <button class="layui-btn layui-btn-sm layui-btn-radius" lay-event="add-trans"
                                    style="margin: 10px 40px" lay-tips="新增一次翻译 则多翻译一次 例如：中文 -> 泰文 -> 英文 -> 中文 这样就翻译了3次">
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
                                            <option value="utf-8"{{if eq .obj.Charset "utf-8"}} selected{{end}}>UTF-8
                                            </option>
                                            <option value="gbk"{{if eq .obj.Charset "gbk"}} selected{{end}}>GBK</option>
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
        <div class="layui-row">
            <div class="layui-col-md10 layui-col-md-offset1">
                <button class="layui-btn layui-btn-sm layui-btn-radius"
                        style="margin-bottom: -65px;margin-left: -35px" lay-event="addListRule" lay-tips="点击无限添加列表规则">+
                </button>
                <div class="layui-tab layui-tab-card" lay-filter="step-list" lay-allowclose="true">
                    <ul class="layui-tab-title">
                        {{range $i,$v:= .obj.List -}}
                            <li lay-id="{{$i}}"{{if eq $i 0 }} class="layui-this"{{end}}>Rule-{{increment $i}}</li>
                        {{end -}}
                    </ul>
                    <div class="layui-tab-content">
                        {{range $i,$v:= .obj.List -}}
                            <div class="layui-tab-item{{if eq $i 0 }} layui-show{{end}}">
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
                                                        <input type="text" name="list.limit.{{$i}}" value="{{$v.Limit}}"
                                                               autocomplete="off"
                                                               placeholder="&lt;html[^&gt;]*&gt;([\s\S]*?)&lt;/html&gt;"
                                                               class="layui-input">
                                                    </div>
                                                    <div class="layui-form-mid layui-word-aux">指定获取范围 为空则不指定 &lt;html[^&gt;]*&gt;([\s\S]*?)&lt;/html&gt;
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="layui-form-item">
                                                <div class="parse-method{{if ne $v.Reg ""}} layui-hide{{end}}">
                                                    <div class="layui-inline">
                                                        <label class="layui-form-label-col">DOM解析:</label>
                                                    </div>
                                                    <div class="layui-inline" lay-tips="一行一条规则，逐行匹配到则终止匹配">
                                                        <textarea class="layui-textarea"
                                                                  name="list.dom.{{$i}}">{{$v.Dom}}</textarea>
                                                    </div>
                                                    <div class="layui-inline" lay-tips="选择dom取值方法">
                                                        <div class="layui-input-inline" style="width: 80px">
                                                            <select name="list.method.{{$i}}">
                                                                <option value="attr"{{if eq $v.Method "attr"}}
                                                                selected{{end}}>Attr
                                                                </option>
                                                                <option value="text"{{if eq $v.Method "text"}}
                                                                selected{{end}}>Text
                                                                </option>
                                                                <option value="html"{{if eq $v.Method "html"}}
                                                                selected{{end}}>Html
                                                                </option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="layui-inline" lay-tips="属性名称 默认为 href">
                                                        <input type="text" name="list.attr_name.{{$i}}"
                                                               value="{{$v.AttrName}}" autocomplete="off"
                                                               placeholder="href" class="layui-input">
                                                    </div>
                                                    <div class="layui-inline">
                                                        <button class="layui-btn layui-btn-radius" parse-method>转为正则解析
                                                        </button>
                                                    </div>
                                                </div>
                                                <div class="parse-method{{if eq $v.Reg ""}} layui-hide{{end}}">
                                                    <div class="layui-inline">
                                                        <label class="layui-form-label-col">正则解析:</label>
                                                    </div>
                                                    <div class="layui-inline" style="width: 55%"
                                                         lay-tips="一行一条规则，逐行匹配到则终止匹配">
                                                        <textarea class="layui-textarea"
                                                                  name="list.reg.{{$i}}">{{$v.Reg}}</textarea>
                                                    </div>
                                                    <div class="layui-inline">
                                                        <button class="layui-btn layui-btn-radius" parse-method>转为DOM解析
                                                        </button>
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
                                                    <input type="text" name="list.match.{{$i}}" value="{{$v.Match}}"
                                                           autocomplete="off" placeholder="/index\.html$"
                                                           class="layui-input">
                                                </div>
                                            </div>
                                            <fieldset class="layui-elem-field layui-field-title">
                                                <legend>字符串、正则或DOM替换</legend>
                                            </fieldset>
                                            <div class="layui-form-item">
                                                <div class="layui-inline" style="width: 38%" lay-tips="原词 一行一条">
                                        <textarea name="list.olds.{{$i}}"
                                                  class="layui-textarea">{{join $v.Olds "\n"}}</textarea>
                                                </div>
                                                <div class="layui-inline">
                                                    <label class="layui-form-label-col" style="color: #009688;">
                                                        <i class="layui-icon layui-icon-spread-left"></i>
                                                    </label>
                                                </div>
                                                <div class="layui-inline" style="width: 38%" lay-tips="替换成 对应原词一行一条">
                                        <textarea name="list.news.{{$i}}"
                                                  class="layui-textarea">{{join $v.News "\n"}}</textarea>
                                                </div>
                                                <div class="layui-inline" style="width: 12%">
                                                    <select name="list.type.{{$i}}" class="layui-select">
                                                        <option value="0"{{if eq $v.Type 0}} selected{{end}}>字符串
                                                        </option>
                                                        <option value="1"{{if eq $v.Type 1}} selected{{end}}>正则
                                                        </option>
                                                        <option value="2"{{if eq $v.Type 2}} selected{{end}}>DOM
                                                        </option>
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
                                                    <input type="checkbox" name="list.page.enabled.{{$i}}"
                                                           lay-skin="switch"
                                                           lay-text="开启|关闭"{{if $v.Page.Enabled}} checked{{end}}>
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
                                                        <input type="text" name="list.page.limit.{{$i}}"
                                                               value="{{$v.Page.Limit}}" autocomplete="off"
                                                               placeholder="&lt;html[^&gt;]*&gt;([\s\S]*?)&lt;/html&gt;"
                                                               class="layui-input">
                                                    </div>
                                                    <div class="layui-form-mid layui-word-aux">指定获取范围 为空则不指定 &lt;html[^&gt;]*&gt;([\s\S]*?)&lt;/html&gt;
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="layui-form-item">
                                                <div class="parse-method{{if ne $v.Page.Reg ""}} layui-hide{{end}}">
                                                    <div class="layui-inline">
                                                        <label class="layui-form-label-col">DOM解析:</label>
                                                    </div>
                                                    <div class="layui-inline" lay-tips="一行一条规则，逐行匹配到则终止匹配">
                                                        <textarea class="layui-textarea"
                                                                  name="list.page.dom.{{$i}}">{{$v.Page.Dom}}</textarea>
                                                    </div>
                                                    <div class="layui-inline" lay-tips="选择dom取值方法">
                                                        <div class="layui-input-inline" style="width: 80px">
                                                            <select name="list.page.method.{{$i}}">
                                                                <option value="attr"{{if eq $v.Page.Method "attr"}}
                                                                selected{{end}}>Attr
                                                                </option>
                                                                <option value="text"{{if eq $v.Page.Method "text"}}
                                                                selected{{end}}>Text
                                                                </option>
                                                                <option value="html"{{if eq $v.Page.Method "html"}}
                                                                selected{{end}}>Html
                                                                </option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="layui-inline" lay-tips="属性名称 默认为 href">
                                                        <input type="text" name="list.page.attr_name.{{$i}}"
                                                               value="{{$v.Page.AttrName}}"
                                                               autocomplete="on" placeholder="href" class="layui-input">
                                                    </div>
                                                    <div class="layui-inline">
                                                        <button class="layui-btn layui-btn-radius" parse-method>转为正则解析
                                                        </button>
                                                    </div>
                                                </div>
                                                <div class="parse-method{{if eq $v.Page.Reg ""}} layui-hide{{end}}">
                                                    <div class="layui-inline">
                                                        <label class="layui-form-label-col">正则解析:</label>
                                                    </div>
                                                    <div class="layui-inline" style="width: 55%"
                                                         lay-tips="一行一条规则，逐行匹配到则终止匹配">
                                                        <textarea class="layui-textarea"
                                                                  name="list.page.reg.{{$i}}">{{$v.Page.Reg}}</textarea>
                                                    </div>
                                                    <div class="layui-inline">
                                                        <button class="layui-btn layui-btn-radius" parse-method>转为DOM解析
                                                        </button>
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
                                                    <input type="text" name="list.page.match.{{$i}}"
                                                           value="{{$v.Page.Match}}"
                                                           autocomplete="off" placeholder="/index\.html$"
                                                           class="layui-input">
                                                </div>
                                            </div>
                                            <fieldset class="layui-elem-field layui-field-title">
                                                <legend>字符串、正则或DOM替换</legend>
                                            </fieldset>
                                            <div class="layui-form-item">
                                                <div class="layui-inline" style="width: 38%" lay-tips="原词 一行一条">
                                        <textarea name="list.page.olds.{{$i}}"
                                                  class="layui-textarea">{{join $v.Page.Olds "\n"}}</textarea>
                                                </div>
                                                <div class="layui-inline">
                                                    <label class="layui-form-label-col" style="color: #009688;">
                                                        <i class="layui-icon layui-icon-spread-left"></i>
                                                    </label>
                                                </div>
                                                <div class="layui-inline" style="width: 38%" lay-tips="替换成 对应原词一行一条">
                                        <textarea name="list.page.news.{{$i}}"
                                                  class="layui-textarea">{{join $v.Page.News "\n"}}</textarea>
                                                </div>
                                                <div class="layui-inline" style="width: 12%">
                                                    <select name="list.page.type.{{$i}}" class="layui-select">
                                                        <option value="0"{{if eq $v.Page.Type 0}} selected{{end}}>字符串
                                                        </option>
                                                        <option value="1"{{if eq $v.Page.Type 1}} selected{{end}}>正则
                                                        </option>
                                                        <option value="2"{{if eq $v.Page.Type 2}} selected{{end}}>DOM
                                                        </option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        {{end -}}
                    </div>
                </div>
                <div class="layui-card-body">
                    <button class="layui-hide" lay-submit lay-filter="testList"></button>
                    <button class="layui-btn" data-event="testList">测试采集</button>
                </div>
            </div>
        </div>
        <div class="layui-row">
            <div class="layui-col-md10 layui-col-md-offset1">
                <button class="layui-btn layui-btn-sm layui-btn-radius"
                        style="margin-bottom: -65px;margin-left: -35px"
                        lay-event="addDetailRule" lay-tips="点击无限添加规则">+
                </button>
                <div class="layui-tab layui-tab-card" lay-filter="step-detail" lay-allowclose="true">
                    <ul class="layui-tab-title">
                        {{range $i,$v:= .obj.Detail -}}
                            <li lay-id="{{$i}}"{{if eq $i 0}} class="layui-this"{{end}}>{{$v.Alias}}</li>
                        {{end -}}
                    </ul>
                    <div class="layui-tab-content">
                        {{range $i,$v:= .obj.Detail -}}
                            <div class="layui-tab-item{{if eq $i 0}} layui-show{{end}}">
                                <div class="layui-form-item">
                                    <div class="layui-inline">
                                        <label class="layui-form-label-col">指定范围:</label>
                                    </div>
                                    <div class="layui-inline">
                                        <div class="layui-input-inline">
                                            <input type="text" name="detail.limit.{{$i}}" value="{{$v.Limit}}"
                                                   autocomplete="off"
                                                   placeholder="&lt;html[^&gt;]*&gt;([\s\S]*?)&lt;/html&gt;"
                                                   class="layui-input">
                                        </div>
                                        <div class="layui-form-mid layui-word-aux">指定获取范围 为空则不指定 &lt;html[^&gt;]*&gt;([\s\S]*?)&lt;/html&gt;</div>
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <div class="parse-method{{if ne $v.Reg ""}} layui-hide{{end}}">
                                        <div class="layui-inline">
                                            <label class="layui-form-label-col">DOM解析:</label>
                                        </div>
                                        <div class="layui-inline" lay-tips="一行一条规则，逐行匹配到则终止匹配">
                                            <textarea class="layui-textarea"
                                                      name="detail.dom.{{$i}}">{{$v.Dom}}</textarea>
                                        </div>
                                        <div class="layui-inline" lay-tips="选择dom取值方法">
                                            <div class="layui-input-inline" style="width: 80px">
                                                <select name="detail.method.{{$i}}" class="layui-select">
                                                    <option value="attr"{{if eq $v.Method "attr"}} selected{{end}}>Attr
                                                    </option>
                                                    <option value="text"{{if eq $v.Method "text"}} selected{{end}}>Text
                                                    </option>
                                                    <option value="html"{{if eq $v.Method "html"}} selected{{end}}>Html
                                                    </option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="layui-inline" lay-tips="属性名称 默认为 href">
                                            <input type="text" name="detail.attr_name.{{$i}}" value="{{$v.AttrName}}"
                                                   autocomplete="on" placeholder="href" class="layui-input">
                                        </div>
                                        <div class="layui-inline">
                                            <button class="layui-btn layui-btn-radius" parse-method>转为正则解析</button>
                                        </div>
                                    </div>
                                    <div class="parse-method{{if eq $v.Reg ""}} layui-hide{{end}}">
                                        <div class="layui-inline">
                                            <label class="layui-form-label-col">正则解析:</label>
                                        </div>
                                        <div class="layui-inline" style="width: 55%"
                                             lay-tips="一行一条规则，逐行匹配到则终止匹配">
                                            <textarea class="layui-textarea"
                                                      name="detail.reg.{{$i}}">{{$v.Reg}}</textarea>
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
                                        <input type="text" name="detail.match.{{$i}}" value="{{$v.Match}}"
                                               autocomplete="off" placeholder="/index\.html$" class="layui-input">
                                    </div>
                                </div>
                                <fieldset class="layui-elem-field layui-field-title">
                                    <legend>DOM替换</legend>
                                </fieldset>
                                <div class="layui-form-item">
                                    <div class="layui-inline" style="width: 45%" lay-tips="原词 一行一条">
                                                    <textarea name="detail.filter_dom.olds.{{$i}}"
                                                              class="layui-textarea">{{join $v.FilterDom.Olds "\n"}}</textarea>
                                    </div>
                                    <div class="layui-inline">
                                        <label class="layui-form-label-col" style="color: #009688;">
                                            <i class="layui-icon layui-icon-spread-left"></i>
                                        </label>
                                    </div>
                                    <div class="layui-inline" style="width: 45%" lay-tips="替换成 对应原词一行一条">
                                        <textarea name="detail.filter_dom.news.{{$i}}"
                                                  class="layui-textarea">{{join $v.FilterDom.News "\n"}}</textarea>
                                    </div>
                                </div>
                                <fieldset class="layui-elem-field layui-field-title">
                                    <legend>字符串、正则或DOM替换</legend>
                                </fieldset>
                                <div class="layui-form-item">
                                    <div class="layui-inline" style="width: 38%" lay-tips="原词 一行一条">
                                        <textarea name="detail.olds.{{$i}}"
                                                  class="layui-textarea">{{join $v.Olds "\n"}}</textarea>
                                    </div>
                                    <div class="layui-inline">
                                        <label class="layui-form-label-col" style="color: #009688;">
                                            <i class="layui-icon layui-icon-spread-left"></i>
                                        </label>
                                    </div>
                                    <div class="layui-inline" style="width: 38%" lay-tips="替换成 对应原词一行一条">
                                        <textarea name="detail.news.{{$i}}"
                                                  class="layui-textarea">{{join $v.News "\n"}}</textarea>
                                    </div>
                                    <div class="layui-inline" style="width: 12%">
                                        <select name="detail.type.{{$i}}" class="layui-select">
                                            <option value="0"{{if eq $v.Type 0}} selected{{end}}>字符串
                                            </option>
                                            <option value="1"{{if eq $v.Type 1}} selected{{end}}>正则
                                            </option>
                                            <option value="2"{{if eq $v.Type 2}} selected{{end}}>DOM
                                            </option>
                                        </select>
                                    </div>
                                </div>

                                <div class="layui-form-item">
                                    <div class="layui-inline">
                                        <input type="checkbox" name="detail.trim_html.{{$i}}"
                                               title="过滤html标签"{{if $v.TrimHtml}} checked{{end}}>
                                    </div>
                                </div>
                                <div class="layui-form-item layui-hide">
                                    <input type="hidden" name="detail.alias.{{$i}}" value="{{$v.Alias}}">
                                    <input type="hidden" name="detail.name.{{$i}}" value="{{$v.Name}}">
                                </div>
                            </div>
                        {{end -}}
                    </div>
                </div>
                <div class="layui-card-body">
                    <button class="layui-hide" lay-submit lay-filter="testDetail"></button>
                    <button class="layui-btn" data-event="testDetail">测试采集</button>
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
</div>
<!--翻译列表-->
<script type="text/template" id="trans-item">
    <div class="layui-form-item">
        <div class="layui-inline" style="top:-5px">
            <input type="checkbox" name="trans.enabled.{num}" lay-skin="switch"
                   lay-text="启用|关闭" class="layui-input">
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
                                <input type="text" name="list.limit.{id}" value="" class="layui-input"
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
                                <textarea class="layui-textarea" name="list.dom.{id}"></textarea>
                            </div>
                            <div class="layui-inline" lay-tips="选择dom取值方法">
                                <div class="layui-input-inline" style="width: 80px">
                                    <select name="list.method.{id}">
                                        <option value="attr">Attr</option>
                                        <option value="text">Text</option>
                                        <option value="html">Html</option>
                                    </select>
                                </div>
                            </div>
                            <div class="layui-inline" lay-tips="属性名称 默认为 href">
                                <input type="text" name="list.attr_name.{id}" value="href" class="layui-input">
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
                                <textarea class="layui-textarea" name="list.reg.{id}"></textarea>
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
                            <input type="text" name="list.match.{id}" value="" class="layui-input"
                                   autocomplete="off" placeholder="/\d+\.html$">
                        </div>
                    </div>
                    <fieldset class="layui-elem-field layui-field-title">
                        <legend>字符串、正则或DOM替换</legend>
                    </fieldset>
                    <div class="layui-form-item">
                        <div class="layui-inline" style="width: 38%" lay-tips="原词 一行一条">
                            <textarea name="list.olds.{id}" class="layui-textarea"></textarea>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label-col" style="color: #009688;">
                                <i class="layui-icon layui-icon-spread-left"></i>
                            </label>
                        </div>
                        <div class="layui-inline" style="width: 38%" lay-tips="替换成 对应原词一行一条">
                            <textarea name="list.news.{id}" class="layui-textarea"></textarea>
                        </div>
                        <div class="layui-inline" style="width: 12%">
                            <select name="list.type.{id}" class="layui-select">
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
                            <input type="checkbox" name="list.page.enabled.{id}" lay-skin="switch"
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
                                <input type="text" name="list.page.limit.{id}" value=""
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
                                <textarea class="layui-textarea" name="list.page.dom.{id}"></textarea>
                            </div>
                            <div class="layui-inline" lay-tips="选择dom取值方法">
                                <div class="layui-input-inline" style="width: 80px">
                                    <select name="list.page.method.{id}">
                                        <option value="attr">Attr</option>
                                        <option value="text">Text</option>
                                        <option value="html">Html</option>
                                    </select>
                                </div>
                            </div>
                            <div class="layui-inline" lay-tips="属性名称 默认为 href">
                                <input type="text" name="list.page.attr_name.{id}" value="href" class="layui-input">
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
                                <textarea class="layui-textarea" name="list.page.reg.{id}"></textarea>
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
                            <input type="text" name="list.page.match.{id}" value="" class="layui-input"
                                   autocomplete="off" placeholder="/\d+\.html$">
                        </div>
                    </div>
                    <fieldset class="layui-elem-field layui-field-title">
                        <legend>字符串、正则或DOM替换</legend>
                    </fieldset>
                    <div class="layui-form-item">
                        <div class="layui-inline" style="width: 38%" lay-tips="原词 一行一条">
                            <textarea name="list.page.olds.{id}" class="layui-textarea"></textarea>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label-col" style="color: #009688;">
                                <i class="layui-icon layui-icon-spread-left"></i>
                            </label>
                        </div>
                        <div class="layui-inline" style="width: 38%" lay-tips="替换成 对应原词一行一条">
                            <textarea name="list.page.news.{id}" class="layui-textarea"></textarea>
                        </div>
                        <div class="layui-inline" style="width: 12%">
                            <select name="list.page.type.{id}" class="layui-select">
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
                    <input type="text" name="detail.limit.{id}" value="" class="layui-input"
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
                    <textarea class="layui-textarea" name="detail.dom.{id}"></textarea>
                </div>
                <div class="layui-inline" lay-tips="选择dom取值方法">
                    <div class="layui-input-inline" style="width: 80px">
                        <select name="detail.method.{id}">
                            <option value="attr">Attr</option>
                            <option value="text">Text</option>
                            <option value="html">Html</option>
                        </select>
                    </div>
                </div>
                <div class="layui-inline" lay-tips="属性名称 默认为 href">
                    <input type="text" name="detail.attr_name.{id}" value="" class="layui-input">
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
                    <textarea class="layui-textarea" name="detail.reg.{id}"></textarea>
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
                <input type="text" name="detail.match.{id}" value="" class="layui-input"
                       autocomplete="off" placeholder="/\d+\.html$">
            </div>
        </div>
        <fieldset class="layui-elem-field layui-field-title">
            <legend>DOM替换</legend>
        </fieldset>
        <div class="layui-form-item">
            <div class="layui-inline" style="width: 45%" lay-tips="原词 一行一条">
                <textarea name="detail.filter_dom.olds.{id}" class="layui-textarea"></textarea>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label-col" style="color: #009688;">
                    <i class="layui-icon layui-icon-spread-left"></i>
                </label>
            </div>
            <div class="layui-inline" style="width: 45%" lay-tips="替换成 对应原词一行一条">
                <textarea name="detail.filter_dom.news.{id}" class="layui-textarea"></textarea>
            </div>
        </div>
        <fieldset class="layui-elem-field layui-field-title">
            <legend>字符串、正则或DOM替换</legend>
        </fieldset>
        <div class="layui-form-item">
            <div class="layui-inline" style="width: 38%" lay-tips="原词 一行一条">
                <textarea name="detail.olds.{id}" class="layui-textarea"></textarea>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label-col" style="color: #009688;">
                    <i class="layui-icon layui-icon-spread-left"></i>
                </label>
            </div>
            <div class="layui-inline" style="width: 38%" lay-tips="替换成 对应原词一行一条">
                <textarea name="detail.news.{id}" class="layui-textarea"></textarea>
            </div>
            <div class="layui-inline" style="width: 12%">
                <select name="detail.type.{id}" class="layui-select">
                    <option value="0" selected>字符串</option>
                    <option value="1">正则</option>
                    <option value="2">DOM</option>
                </select>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <input type="checkbox" name="detail.trim_html.{id}" title="过滤html标签" checked>
            </div>
        </div>
        <div class="layui-form-item layui-hide">
            <input type="hidden" name="detail.alias.{id}" value="{alias}">
            <input type="hidden" name="detail.name.{id}" value="{name}">
        </div>
    </div>
</script>
<!--自定义-->
<script>
    layui.use(['step', 'element', 'main'], function () {
        let $ = layui.$,
            step = layui.step,
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
                        let options = new utils.buildListItem('step-list-item'),
                            tabAdd = element.tabAdd('step-list', {
                                title: 'Rule-' + (options.id + 1),
                                content: options.content,
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
                                layer.alert('您输入的标识不合法!');
                                return false;
                            }
                            if (existsHtml.indexOf('value="' + name + '"') !== -1) {
                                layer.alert('您输入的标识"' + name + '"已经存在');
                                return false;
                            }
                            layer.prompt({
                                formType: 0,
                                value: name.substring(0, 1).toUpperCase() + name.substring(1),
                                title: '请输入别名 例如:标题'
                            }, function (alias, index) {
                                if (existsHtml.indexOf('value="' + alias + '"') !== -1) {
                                    layer.alert('您输入的别名"' + alias + '"已经存在');
                                    return false;
                                }
                                let opts = new utils.buildDetailItem($('#step-detail-item').html(), {
                                    name: name,
                                    alias: alias
                                });
                                if (!opts.content) {
                                    layer.alert('添加内容为空');
                                    return false;
                                }
                                element.tabAdd('step-detail', {
                                    title: alias,
                                    content: opts.content,
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
                                layer.alert(res.msg, {area: ['500px', '450px']});
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
                                    layer.alert(res.msg, {area: ['80%', '80%']});
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
                        }
                    });
                },
                /*获取lay-id*/
                getLayId: function (elem) {
                    let ids = Array(), id = 0;
                    $(elem).each(function () {
                        let layid = parseInt($(this).attr('lay-id'));
                        if (!isNaN(layid)) {
                            ids.push(layid);
                        }
                    });
                    if (ids.length > 0) {
                        id = Math.max.apply(null, ids) + 1;
                    }
                    return {id: id, ids: ids}
                },
                /*构建 详情 item*/
                buildDetailItem: function (content, field, id) {
                    if (typeof content !== 'string' || content.length === 0 || Object.prototype.toString.call(field) !== '[object Object]' || typeof field.name !== 'string') {
                        return false;
                    }
                    if (typeof field.alias !== 'string' || field.alias.length < 1) {
                        field.alias = field.name.substring(0, 1).toUpperCase() + field.name.substring(1);
                    }
                    let layId;
                    if (id) {
                        layId = {id: id, ids: [id]};
                    } else {
                        layId = utils.getLayId('[lay-filter=step-detail]>.layui-tab-title>li[lay-id]');
                    }
                    switch (field.name) {
                        case 'title':
                            content = content.replace(/name="detail\.dom\.\{id\}">/, 'name="detail.dom.{id}">h1')
                                .replace(/option\s+value="text"/, 'option value="text" selected');
                            break;
                        case 'tags':
                            content = content.replace(/name="detail\.dom\.\{id\}">/, 'name="detail.dom.{id}">.tags')
                                .replace(/option\s+value="text"/, 'option value="text" selected');
                            break;
                        case 'content':
                            content = content.replace(/name="detail\.dom\.\{id\}">/, 'name="detail.dom.{id}">body')
                                .replace(/option\s+value="html"/, 'option value="html" selected');
                            break;
                        case 'keywords':
                            content = content.replace(/name="detail\.dom\.\{id\}">/, 'name="detail.dom.{id}">meta[name=keywords]')
                                .replace(/name="detail\.attr_name\.\{id\}"\s+value=""/, 'name="detail.attr_name.{id}" value="content"');
                            break;
                        case 'description':
                            content = content.replace(/name="detail\.dom\.\{id\}">/, 'name="detail.dom.{id}">meta[name=description]')
                                .replace(/name="detail\.attr_name\.\{id\}"\s+value=""/, 'name="detail.attr_name.{id}" value="content"');
                            break;
                    }
                    this.content = content.replace(/\{id\}/g, layId.id.toString())
                        .replace(/\{name\}/g, field.name)
                        .replace(/\{alias\}/, field.alias);
                    this.id = layId.id;
                    this.ids = layId.ids;
                },
                /*构建 列表 item*/
                buildListItem: function (elem, id) {
                    if (typeof elem !== 'string') {
                        return false;
                    }
                    if (elem.substring(0, 1) === '#') {
                        elem = elem.substring(1);
                    }
                    let content = $('#' + elem).html(),
                        layId = {id: parseInt(id), ids: Array()};
                    if (!content) {
                        return false;
                    }
                    if (isNaN(layId.id)) {
                        layId = utils.getLayId('[lay-filter=step-list]>.layui-tab-title>li[lay-id]');
                    }
                    this.content = content.replace(/\{id\}/g, layId.id);
                    this.id = layId.id;
                    this.ids = layId.ids;
                },
                /*转换解析方法*/
                renderMethod: function () {
                    $('button[parse-method]').click(function () {
                        let othis = $(this),
                            parent = othis.closest('div.parse-method');
                        parent.addClass('layui-hide');
                        parent.siblings().removeClass('layui-hide');
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
                        tabTitleElem = $('[lay-filter=step-detail]>ul.layui-tab-title'),
                        tabContentElem = $('[lay-filter=step-detail]>div.layui-tab-content'),
                        titleHtml = '',
                        contentHtml = '',
                        detailContent = $('#step-detail-item').html();
                    $.each(fields, function (i, v) {
                        let opts = new utils.buildDetailItem(detailContent, v, i);
                        if (!opts.content) {
                            opts.content = `<div class="layui-tab-item layui-show"></div>`;
                        }
                        if (i === 0) {
                            titleHtml += '<li class="layui-this" lay-id="0">' + v.alias + '</li>';
                        } else {
                            titleHtml += '<li lay-id="' + i + '">' + v.alias + '</li>';
                            opts.content = opts.content.replace(/ layui-show/, '');
                        }
                        contentHtml += opts.content;
                    });
                    tabTitleElem.html(titleHtml);
                    tabContentElem.html(contentHtml);
                },
                /*初始化列表步骤*/
                initList: function () {
                    let tabTitleElem = $('[lay-filter=step-list]>ul.layui-tab-title'),
                        tabContentElem = $('[lay-filter=step-list]>div.layui-tab-content'),
                        opts = new utils.buildListItem('step-list-item', 0);
                    tabTitleElem.html('<li class="layui-this" lay-id="0">Rule-1</li>');
                    if (!opts.content) {
                        opts.content = `<div class="layui-tab-item  layui-show"></div>`;
                    }
                    tabContentElem.html(opts.content);
                }
            };
        /*渲染步骤*/
        step.render({
            position: 0,
            contentW: '90%',
            data: [{title: '基本设置'}, {title: '列表规则'},
                {title: '详情页'}, {title: '定时采集'}]
        });
        if (currentId > 0) {
            utils.bindClass($('select[name=site_id]').val(), $('select[name=class_id]').val());
        } else {
            /*初始化默认列表规则*/
            utils.initList();
            /*初始化默认详情规则*/
            utils.initDetail();
        }
        /*小工具渲染*/
        utils.render();
    });
</script>