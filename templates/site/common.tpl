<style>
    #theme > img {
        max-width: 80px;
        max-height: 80px;
    }

    #theme > img:hover {
        max-width: 200px;
        max-height: 200px;
        cursor: pointer;
    }
</style>
<div class="layui-card">
    <div class="layui-card-body">
        <div class="layui-tab layui-tab-card layui-form">
            <ul class="layui-tab-title">
                <li class="layui-this">建站设置</li>
                <li>web设置</li>
                <li>手机站</li>
                <li>数据库</li>
                <li>FTP帐户</li>
                <li>基本控制</li>
                <li>发布设置</li>
                <li>SEO设置</li>
                <li>设置更多选项</li>
            </ul>
            <div class="layui-tab-content">
                <div class="layui-tab-item layui-show">
                    <div class="layui-row layui-col-space5">
                        <div class="layui-col-md3">
                            <label class="layui-form-label">网站类型:</label>
                            <div class="layui-input-block">
                                <select name="system" lay-filter="system" {{if gt .obj.Status 0}} disabled{{end}}>
                                    {{range $system:=.systems -}}
                                        <option value="{{$system.Name}}" {{if eq $.obj.System $system.Name}} selected{{end}}>{{$system.Alias}}</option>
                                    {{end -}}
                                </select>
                            </div>
                        </div>
                        <div class="layui-col-md4">
                            <label class="layui-form-label">选择模板:</label>
                            <div class="layui-input-inline" lay-filter="tpl_name">
                                {{.tpl_select}}
                            </div>
                        </div>
                        <div class="layui-col" id="theme">
                            {{if .theme.Face -}}
                                <img width="100%" height="100%" alt="{{.theme.Alias}}" src="{{.theme.Face}}"
                                     title="{{.theme.Readme}}">
                            {{end -}}
                        </div>
                    </div>
                    <div class="layui-form-item"></div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">站点域名:</label>
                        <div class="layui-input-inline">
                            <input type="text" name="vhost" required lay-verify="required" autocomplete="off"
                                   class="layui-input" placeholder="如:webrobot.cn"
                                   value="{{.obj.Vhost}}" {{if gt .obj.Status 0}} disabled{{end}}>
                        </div>
                        <div class="layui-form-mid layui-word-aux">
                            <span class="text-danger"><strong style="color:red;">*</strong> 不带http://，创建后不可修改</span>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">绑定域名:</label>
                        <div class="layui-input-inline">
                            <input type="text" name="binds" autocomplete="off" class="layui-input"
                                   placeholder="如:blog.webrobot.cn,nfivf.com" value='{{join .obj.Binds ","}}'>
                        </div>
                        <div class="layui-form-mid layui-word-aux">多个请用英文逗号","分隔</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">默认首页:</label>
                        <div class="layui-input-inline">
                            <input type="text" name="indexes" class="layui-input" value="{{join .obj.Indexes ","}}"
                                   autocomplete="on" placeholder="index.html,index.php">
                        </div>
                        <div class="layui-form-mid layui-word-aux">留空为默认值，多个用英文逗号","分隔</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">https支持:</label>
                        <div class="layui-input-inline">
                            <select name="ssl" {{if gt .obj.Status 0}} disabled{{end}}>
                                <option value="0" {{if eq .obj.Ssl 0}} selected{{end}}>不启用</option>
                                <option value="1" {{if eq .obj.Ssl 1}} selected{{end}}>启用</option>
                                <option value="2" {{if eq .obj.Ssl 2}} selected{{end}}>强制启用</option>
                            </select>
                        </div>
                        <div class="layui-form-mid layui-word-aux">开启需要有SSL证书文件，否则无效。可后台创建或
                            <a lay-href="/file?path={{.ssl_path}}" class="text-danger">自行上传</a>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">泛域名支持:</label>
                        <div class="layui-input-inline">
                            <input type="checkbox" name="unlimited_bind" lay-skin="switch"
                                   lay-text="打开|关闭" {{if .obj.UnlimitedBind}} checked{{end}}>
                        </div>
                        <div class="layui-form-mid layui-word-aux">
                            <span class="text-danger">对泛域名的支持，一般不需要开启</span>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">状态:</label>
                        <div class="layui-input-inline">
                            <select name="status">
                                {{range $i,$v:=.status}}
                                    <option value="{{$i}}" {{if eq $.obj.Status $i}} selected{{end}}>{{$v}}</option>
                                {{end}}
                            </select>
                        </div>
                        <div class="layui-form-mid layui-word-aux">外部站只允许发布文章</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">备注信息:</label>
                        <div class="layui-input-inline">
                            <input type="text" name="note" value="{{.obj.Note}}" autocomplete="off" class="layui-input"
                                   placeholder="可选">
                        </div>
                    </div>
                </div>
                <div class="layui-tab-item">
                    <fieldset class="layui-elem-field">
                        <legend>后台登录</legend>
                        <div class="layui-form-item">
                            <div class="layui-row">
                                <div class="layui-col-sm6">
                                    <label class="layui-form-label" lay-tips="由3-15个字母或数字组成">用户名:</label>
                                    <div class="layui-input-block">
                                        <input type="text" name="web_user" value="{{.obj.WebUser}}" autocomplete="off"
                                               class="layui-input" placeholder="3-15个字符">
                                    </div>
                                </div>
                                <div class="layui-col-sm5">
                                    <label class="layui-form-label" lay-tips="由6-15个字符组成">密码:</label>
                                    <div class="layui-input-block">
                                        <input type="text" name="web_pwd" value="{{.obj.WebPwd}}" autocomplete="off"
                                               class="layui-input" placeholder="6-15个字符">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </fieldset>
                    <fieldset class="layui-elem-field">
                        <legend>后台设置</legend>
                        <div class="layui-form-item">
                            <div class="layui-row layui-col-space10">
                                <div class="layui-col-sm5">
                                    <label class="layui-form-label" lay-tips="主标题，如:广州南方39助孕网">首页标题:</label>
                                    <div class="layui-input-block">
                                        <input type="text" name="title" value="{{.obj.Title}}" class="layui-input"
                                               autocomplete="off" placeholder="广州南方39助孕网">
                                    </div>
                                </div>
                                <div class="layui-col-sm1">
                                    <button class="layui-btn layui-btn-radius" lay-event="valid-title">验证合规</button>
                                </div>
                                <div class="layui-col-sm4">
                                    <label class="layui-form-label" lay-tips="每个网页的标题后缀 如:南方39助孕网">副标题:</label>
                                    <div class="layui-input-block">
                                        <input type="text" name="title_suffix" value="{{.obj.TitleSuffix}}"
                                               autocomplete="off" class="layui-input" placeholder="39助孕网">
                                    </div>
                                </div>
                                <div class="layui-col-sm1">
                                    <button class="layui-btn layui-btn-radius" lay-event="valid-title-suffix">验证合规
                                    </button>
                                </div>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <div class="layui-row">
                                <div class="layui-col-sm6">
                                    <label class="layui-form-label" lay-tips="多个关键词用英文逗号,隔开">关键词:</label>
                                    <div class="layui-input-block">
                                        <input type="text" name="keywords" value='{{join .obj.Keywords ","}}'
                                               autocomplete="off" class="layui-input" placeholder="关键词1,关键词2">
                                    </div>
                                </div>
                                <div class="layui-col-sm5">
                                    <label class="layui-form-label" lay-tips="多个Tag用英文逗号,隔开">Tags:</label>
                                    <div class="layui-input-block">
                                        <input type="text" name="tags" value='{{join .obj.Tags ","}}' autocomplete="off"
                                               class="layui-input" placeholder="Tag1,tag2">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <div class="layui-row layui-col-space10">
                                <div class="layui-col-sm10">
                                    <label class="layui-form-label" lay-tips="用80-120个字符描述网站">描述:</label>
                                    <div class="layui-input-block">
                                        <input type="text" name="description" value="{{.obj.Description}}"
                                               autocomplete="off" class="layui-input" placeholder="网站描述">
                                    </div>
                                </div>
                                <div class="layui-col-sm1">
                                    <button class="layui-btn layui-btn-radius" lay-event="valid-description">验证合规
                                    </button>
                                </div>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label"
                                   lay-tips="[{&quot;name&quot;:&quot;栏目1&quot;,&quot;&quot;:[{&quot;name&quot;:&quot;子栏目1&quot;},{&quot;name&quot;:&quot;子栏目2&quot;}]},{&quot;name&quot;:&quot;栏目2&quot;}]">栏目名称:</label>
                            <div class="layui-input-inline" style="width: 50%">
                                <textarea name="classes" class="layui-textarea"
                                          rows="7">{{jsonIndent .obj.Classes}}</textarea>
                            </div>
                            <div class="layui-input-inline" style="width: 30%">
<textarea class="layui-textarea" rows="7">[
    {"name": "栏目1", "classes": [
        {"name": "子栏目1"},
        {"name":"子栏目2"}
    ]},
    {"name": "栏目2"}
]</textarea>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <div class="layui-row">
                                <div class="layui-col-sm6">
                                    <label class="layui-form-label" lay-tips="网站后台登录认证码 15个字母或数字组成">认证码:</label>
                                    <div class="layui-input-block">
                                        <input type="text" name="auth_code" class="layui-input"
                                               value="{{.obj.AuthCode}}" autocomplete="off" placeholder="后台第二验证码">
                                    </div>
                                </div>
                                <div class="layui-col-sm5">
                                    <label class="layui-form-label" lay-tips="网站后台登录目录名称">后台目录:</label>
                                    <div class="layui-input-block">
                                        <input type="text" name="admin_dir" class="layui-input"
                                               value="{{.obj.AdminDir}}" autocomplete="off" placeholder="nfivf">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <div class="layui-row">
                                <div class="layui-col-sm6">
                                    <label class="layui-form-label" lay-tips="一般栏目数量设置不超过10个">栏目数量:</label>
                                    <div class="layui-input-block">
                                        <input type="text" name="class_num" class="layui-input"
                                               value="{{.obj.ClassNum}}" autocomplete="off" placeholder="8">
                                    </div>
                                </div>
                                <div class="layui-col-sm5">
                                    <label class="layui-form-label" lay-tips="选择城市必须是实际存在的">城市:</label>
                                    <div class="layui-input-block">
                                        <select name="city" lay-search>
                                            <option value="">直接选择或搜索选择</option>
                                            <option value="random">随机城市</option>
                                            {{range .cities -}}
                                                <option value="{{.}}" {{if eq . $.obj.City}} selected{{end}}>{{.}}</option>
                                            {{end -}}
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <div class="layui-row">
                                <div class="layui-col-sm6">
                                    <label class="layui-form-label" lay-tips="网站广告代码一般为js代码">广告:</label>
                                    <div class="layui-input-block">
                                        <textarea name="ad" class="layui-textarea">{{.obj.Ad}}</textarea>
                                    </div>
                                </div>
                                <div class="layui-col-sm5">
                                    <label class="layui-form-label" lay-tips="李谊:139-2235-2985 一行一条">联系方式:</label>
                                    <div class="layui-input-block">
                                        <textarea name="contact"
                                                  class="layui-textarea">{{join .obj.Contact "\n"}}</textarea>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <div class="layui-row">
                                <div class="layui-col-sm6">
                                    <label class="layui-form-label" lay-tips="灰词=>替换成的是词 一行一条">灰词替换:</label>
                                    <div class="layui-input-block">
                                        <textarea name="replaces"
                                                  class="layui-textarea">{{join .obj.Replaces "\n"}}</textarea>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </fieldset>
                </div>
                <div class="layui-tab-item">
                    <div class="layui-form-item">
                        <label class="layui-form-label">手机站:</label>
                        <div class="layui-input-inline">
                            <input type="checkbox" name="wap_enabled" lay-skin="switch"
                                   lay-text="是|否" {{if .obj.WapEnabled}} checked{{end}}>
                        </div>
                        <div class="layui-form-mid layui-word-aux"><span class="text-danger">创建手机站</span></div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">手机域名:</label>
                        <div class="layui-input-inline">
                            <input type="text" name="wap_host" value="{{.obj.WapHost}}" autocomplete="off"
                                   placeholder="如:m.webrobot.cn" class="layui-input">
                        </div>
                        <div class="layui-form-mid layui-word-aux">请确定域名已经解析到服务器ip</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">路径名:</label>
                        <div class="layui-input-inline">
                            <input type="text" name="wap_root_dir" class="layui-input" value="{{.obj.WapRootDir}}"
                                   autocomplete="off" placeholder="m">
                        </div>
                        <div class="layui-form-mid layui-word-aux">确保网站根目录下存在这个路径</div>
                    </div>
                </div>
                <div class="layui-tab-item">
                    <div class="layui-form-item">
                        <label class="layui-form-label">是否创建:</label>
                        <div class="layui-input-inline">
                            <input type="checkbox" name="sql_enabled" lay-skin="switch"
                                   lay-text="是|否" {{if .obj.SqlEnabled}} checked{{end}}{{if gt .obj.Status 0}}
                            disabled{{end}}>
                        </div>
                        <div class="layui-form-mid layui-word-aux"><span class="text-danger">创建数据库</span></div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">数据库名:</label>
                        <div class="layui-input-inline">
                            <input type="text" name="db_name" value="{{.obj.DbName}}" class="layui-input"
                                   autocomplete="off" placeholder="5-15个字符">
                        </div>
                        <div class="layui-form-mid layui-word-aux">由字母、数字、下划线组成，<span
                                    class="text-danger">不能全为数字</span>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">用户名:</label>
                        <div class="layui-input-inline">
                            <input type="text" name="db_user" value="{{.obj.DbUser}}" class="layui-input"
                                   autocomplete="off" placeholder="3-15个字符">
                        </div>
                        <div class="layui-form-mid layui-word-aux">由字母、数字、下划线组成，
                            <span class="text-danger">不能全为数字</span>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">密码:</label>
                        <div class="layui-input-inline">
                            <input type="text" name="db_pwd" value="{{.obj.DbPwd}}" class="layui-input"
                                   autocomplete="off" placeholder="6-15个字符">
                        </div>
                        <div class="layui-form-mid layui-word-aux">由字母、数字、下划线组成</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">数据库前缀:</label>
                        <div class="layui-input-inline">
                            <input type="text" name="db_prefix" value="{{.obj.DbPrefix}}"
                                   value="{{.obj.DbPrefix}}" class="layui-input">
                        </div>
                        <div class="layui-form-mid layui-word-aux">字母加下划线结尾</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">编码:</label>
                        <div class="layui-input-inline">
                            <select name="db_charset">
                                <option value="utf8mb4" {{if eq .obj.DbCharset "utf8mb4"}} selected{{end}}>UTF8</option>
                                <option value="gbk" {{if eq .obj.DbCharset "gbk"}} selected{{end}}>GBK</option>
                                <option value="latin1" {{if eq .obj.DbCharset "latin1"}} selected{{end}}>latin1</option>
                            </select>
                        </div>
                        <div class="layui-form-mid layui-word-aux">数据库编码，一般是用utf8,gbk</div>
                    </div>
                </div>
                <div class="layui-tab-item">
                    <div class="layui-form-item">
                        <label class="layui-form-label">FTP:</label>
                        <div class="layui-input-inline">
                            <input type="checkbox" name="ftp_enabled" lay-skin="switch"
                                   lay-text="是|否" {{if .obj.FtpEnabled}} checked{{end}}>
                        </div>
                        <div class="layui-form-mid layui-word-aux"><span class="text-danger">创建FTP帐户</span></div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">用户名:</label>
                        <div class="layui-input-inline">
                            <input type="text" name="ftp_user" value="{{.obj.FtpUser}}" autocomplete="off"
                                   class="layui-input" placeholder="3-12个字符">
                        </div>
                        <div class="layui-form-mid layui-word-aux">由字母、数字、下划线组成，且不可修改</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">密码:</label>
                        <div class="layui-input-inline">
                            <input type="text" name="ftp_pwd" value="{{.obj.FtpPwd}}" autocomplete="off"
                                   class="layui-input" placeholder="6-15个字符">
                        </div>
                        <div class="layui-form-mid layui-word-aux">由字母、数字、下划线组成</div>
                    </div>
                </div>
                <div class="layui-tab-item">
                    <fieldset class="layui-elem-field">
                        <legend>错误提示页</legend>
                        <div class="layui-form-item">
                            <label class="layui-form-label"></label>
                            <input name="err400" type="checkbox" title="400" {{if .obj.Err400}} checked{{end}}/>
                            <input name="err401" type="checkbox" title="401" {{if .obj.Err401}} checked{{end}}/>
                            <input name="err403" type="checkbox" title="403" {{if .obj.Err403}} checked{{end}}/>
                            <input name="err404" type="checkbox" title="404" {{if .obj.Err404}} checked{{end}}/>
                            <input name="err405" type="checkbox" title="405" {{if .obj.Err405}} checked{{end}}/>
                            <input name="err500" type="checkbox" title="500" {{if .obj.Err500}} checked{{end}}/>
                            <input name="err503" type="checkbox" title="503" {{if .obj.Err503}} checked{{end}}/>
                        </div>
                    </fieldset>
                    <fieldset class="layui-elem-field">
                        <legend>301/302跳转</legend>
                        <div class="layui-form-item">
                            <label class="layui-form-label"></label>
                            <div class="layui-input-inline">
                                <select name="redirects">
                                    <option value="0" {{if eq .obj.Redirects 0}} selected{{end}}>不启用
                                    </option>
                                    <option value="301" {{if eq .obj.Redirects 301}} selected{{end}}>301跳转
                                    </option>
                                    <option value="302" {{if eq .obj.Redirects 302}} selected{{end}}>302跳转
                                    </option>
                                </select>
                            </div>
                            <div class="layui-input-inline">
                                <input type="text" name="redirects_url" value="{{.obj.RedirectsUrl}}"
                                       class="layui-input" autocomplete="off" placeholder="http://www.botadmin.cn">
                            </div>
                            <div class="layui-form-mid layui-word-aux">跳转URL，如: http://www.webrobot.cn</div>
                        </div>
                    </fieldset>
                    <fieldset class="layui-elem-field">
                        <legend>网站日志</legend>
                        <div class="layui-form-item">
                            <label class="layui-form-label"></label>
                            <div class="layui-inline">
                                <input type="checkbox" name="access_log"
                                       title="Access" {{if .obj.AccessLog}} checked{{end}}>
                                <input type="checkbox" name="error_log"
                                       title="Error" {{if .obj.ErrorLog}} checked{{end}}>
                            </div>
                            <div class="layui-inline">
                                <div class="layui-form-mid layui-word-aux">记录详细的访问日志，会占服务器资源，如无特别需求，不建议开启</div>
                            </div>
                        </div>
                    </fieldset>
                    <fieldset class="layui-elem-field">
                        <legend>网站安全</legend>
                        <div class="layui-form-item">
                            <label class="layui-form-label"></label>
                            <div class="layui-inline">
                                <input type="checkbox" name="limit_dir"
                                       title="限制跨目录" {{if .obj.LimitDir}} checked{{end}}>
                                <input type="checkbox" name="display_dir"
                                       title="列举目录" {{if .obj.DisplayDir}} checked{{end}}>
                            </div>
                            <div class="layui-inline">
                                <div class="layui-form-mid layui-word-aux">防止webshell跨目录跨站和没有默认首页时显示所有文件列表</div>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">防盗链类型</label>
                            <div class="layui-input-inline">
                                <input type="text" name="safe_img_type" value="{{.obj.SafeImgType}}"
                                       class="layui-input">
                            </div>
                            <div class="layui-form-mid layui-word-aux">默认为空，则不启用
                                如多个用英文逗号“,”分隔,如“jpg,gif,bmp”
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">允许的域名</label>
                            <div class="layui-input-inline">
                                <input type="text" name="allow_domains" value="{{.obj.AllowDomains}}"
                                       class="layui-input">
                            </div>
                            <div class="layui-form-mid layui-word-aux">
                                此处可增加域名，如多个用英文逗号","分隔，不带http://，如botadmin.cn,botadmin.com
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">盗链URL</label>
                            <div class="layui-input-inline">
                                <input type="text" name="safe_img_src" value="{{.obj.SafeImgSrc}}"
                                       class="layui-input">
                            </div>
                            <div class="layui-form-mid layui-word-aux">
                                可访问的图片地址，完整URL，如http://www.webrobot.cn/images/logo.png
                            </div>
                        </div>
                    </fieldset>
                    <fieldset class="layui-elem-field">
                        <legend>站点设置</legend>
                        <div class="layui-form-item">
                            <label class="layui-form-label">gzip压缩</label>
                            <div class="layui-input-inline">
                                <input type="checkbox" name="web_gzip" lay-skin="switch"
                                       lay-text="是|否" {{if .obj.WebGzip}} checked{{end}}>
                            </div>
                            <div class="layui-form-mid layui-word-aux">此功能为可将部分网页压缩传输，可以节省带宽</div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">客户端缓存</label>
                            <div class="layui-input-inline">
                                <input type="checkbox" name="client_cache" lay-skin="switch"
                                       lay-text="是|否" {{if .obj.ClientCache}} checked{{end}}>
                            </div>
                            <div class="layui-form-mid layui-word-aux">此功能可减轻服务器负载，但有时更新可能不会及时显示</div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">删除站点</label>
                            <div class="layui-input-inline">
                                <input type="checkbox" name="del_site_all" lay-skin="switch"
                                       lay-text="是|否" {{if .obj.DelSiteAll}} checked{{end}}>
                            </div>
                            <div class="layui-form-mid layui-word-aux">删除站点时是否删除目录和数据</div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">删除ftp</label>
                            <div class="layui-input-inline">
                                <input type="checkbox" name="del_ftp_all" lay-skin="switch"
                                       lay-text="是|否" {{if .obj.DelFtpAll}} checked{{end}}>
                            </div>
                            <div class="layui-form-mid layui-word-aux">删除ftp用户时是否删除目录及数据</div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">随机城市</label>
                            <div class="layui-input-inline">
                                <input type="checkbox" name="city_enabled" lay-skin="switch"
                                       lay-text="是|否" {{if .obj.CityEnabled}} checked{{end}}>
                            </div>
                            <div class="layui-form-mid layui-word-aux">开启或者关闭随机城市选择</div>
                        </div>
                    </fieldset>
                </div>
                <div class="layui-tab-item">
                    <div class="layui-form-item">
                        <label class="layui-form-label">标题格式:</label>
                        <div class="layui-input-inline">
                            <textarea name="title_formats" rows="3"
                                      class="layui-textarea">{{join .obj.TitleFormats "\n"}}</textarea>
                        </div>
                        <div class="layui-form-mid layui-word-aux">
                            可用标签为&#123;&#123;tag&#125;&#125; &#123;&#123;title&#125;&#125; 标签为必须 一行一条
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">图片路径:</label>
                        <div class="layui-input-block">
                            <input type="text" name="pic_dir" value="{{.obj.PicDir}}" class="layui-input"/>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">插图阈值:</label>
                        <div class="layui-input-inline slider">
                            <div id="insert_pic_deg"></div>
                            <input type="hidden" name="insert_pic_deg" value="{{.obj.InsertPicDeg}}"/>
                        </div>
                        <div class="layui-form-mid layui-word-aux">随机插入图片数量</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">发布阈值:</label>
                        <div class="layui-input-inline slider">
                            <div id="pub_deg"></div>
                            <input type="hidden" name="pub_deg" value="{{.obj.PubDeg}}"/>
                        </div>
                        <div class="layui-form-mid layui-word-aux">随机发布指定数量的文章</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">内容阈值:</label>
                        <div class="layui-input-inline slider">
                            <div id="content_deg"></div>
                            <input type="hidden" name="content_deg" value="{{.obj.ContentDeg}}"/>
                        </div>
                        <div class="layui-form-mid layui-word-aux">内容内随机插入关键词数量</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">原创度:</label>
                        <div class="layui-input-inline slider">
                            <div id="originality_rate"></div>
                            <input type="hidden" name="originality_rate" value="{{$.obj.OriginalityRate}}">
                        </div>
                        <div class="layui-form-mid layui-word-aux">大于或等于这个值才发布</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">属性阀值:</label>
                        <div class="layui-input-inline slider">
                            <div id="pub_attr_deg"></div>
                            <input type="hidden" name="pub_attr_deg" value="{{$.obj.PubAttrDeg}}">
                        </div>
                        <div class="layui-form-mid layui-word-aux">值越高 几率越高</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">内链阀值:</label>
                        <div class="layui-input-inline slider">
                            <div id="link_deg"></div>
                            <input type="hidden" name="link_deg" value="{{$.obj.LinkDeg}}">
                        </div>
                        <div class="layui-form-mid layui-word-aux">随机插入内链</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">外链阀值:</label>
                        <div class="layui-input-inline slider">
                            <div id="out_link_deg"></div>
                            <input type="hidden" name="out_link_deg" value="{{$.obj.OutLinkDeg}}">
                        </div>
                        <div class="layui-form-mid layui-word-aux">随机插入外链</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">标题阀值:</label>
                        <div class="layui-input-inline slider">
                            <div id="title_tag_deg"></div>
                            <input type="hidden" name="title_tag_deg" value="{{$.obj.TitleTagDeg}}">
                        </div>
                        <div class="layui-form-mid layui-word-aux">标题插入tag 值越高 几率越高</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">指定:</label>
                        <div class="layui-input-inline">
                            <input type="checkbox" name="pub_self" lay-skin="switch"
                                   lay-text="是|否" {{if .obj.PubSelf}} checked{{end}}>
                        </div>
                        <div class="layui-form-mid layui-word-aux">只发布指定本站的文章</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">删除已发:</label>
                        <div class="layui-input-inline">
                            <input type="checkbox" name="del_published" lay-skin="switch"
                                   lay-text="是|否" {{if .obj.DelPublished}} checked{{end}}>
                        </div>
                        <div class="layui-form-mid layui-word-aux">发布后马上从数据库中删除该文章</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">发布顺序:</label>
                        <div class="layui-input-inline">
                            <select name="order" class="layui-select">
                                <option value="0"{{if eq .obj.Order 0}} selected{{end}}>最新采集</option>
                                <option value="1"{{if eq .obj.Order 1}} selected{{end}}>最旧采集</option>
                                <option value="2"{{if eq .obj.Order 2}} selected{{end}}>随机</option>
                            </select>
                        </div>
                        <div class="layui-form-mid layui-word-aux">发布文章顺序</div>
                    </div>
                    <fieldset class="layui-elem-field">
                        <legend>推送</legend>
                        <div class="layui-form-item" style="padding-left: 2%;padding-right: 2%;">
                            <textarea name="push_config" class="layui-textarea" rows="3">{{.push_config}}</textarea>
                        </div>
                    </fieldset>
                    <fieldset class="layui-elem-field">
                        <legend>定时发布</legend>
                        <div class="layui-form-item" style="padding-left: 3%;">
                            <table>
                                <tr>
                                    <th align="center" style="margin-right: 2%;">是否启用</th>
                                    <th align="center">分:0-59 *-,</th>
                                    <th align="center">时:0-23 *-,</th>
                                    <th align="center">天:1-31 *-,</th>
                                    <th align="center">月:1-12 *-,</th>
                                    <th align="center">周:0-6 *-,</th>
                                </tr>
                                <tr>
                                    <td style="padding-left: 2%;">
                                        <input type="checkbox" name="cron_enabled" lay-skin="switch"
                                               lay-text="是|否" {{if .obj.CronEnabled}} checked{{end}}>
                                    </td>
                                    <td style="padding-left: 4%;">
                                        <input type="text" name="minute" value="{{.obj.Minute}}" class="layui-input">
                                    </td>
                                    <td style="padding-left: 2%;">
                                        <input type="text" name="hour" value="{{.obj.Hour}}" class="layui-input">
                                    </td>
                                    <td style="padding-left: 2%;">
                                        <input type="text" name="day" value="{{.obj.Day}}" class="layui-input">
                                    </td>
                                    <td style="padding-left: 2%;">
                                        <input type="text" name="month" value="{{.obj.Month}}" class="layui-input">
                                    </td>
                                    <td style="padding-left: 2%;">
                                        <input type="text" name="week" value="{{.obj.Week}}" class="layui-input">
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </fieldset>
                </div>
                <div class="layui-tab-item">
                    <div class="layui-row">
                        <div class="layui-col-md6">
                            <div class="layui-form-item">
                                <label class="layui-form-label" lay-tips="登录百度后的cookies">百度 Cookies:</label>
                                <div class="layui-input-block">
                                    <textarea name="bd_cookies" class="layui-textarea"
                                              rows="3">{{.obj.BdCookies}}</textarea>
                                </div>
                            </div>
                        </div>
                        <div class="layui-col-md6">
                            <div class="layui-form-item">
                                <label class="layui-form-label" lay-tips="忽略百度关键词列表">过滤:</label>
                                <div class="layui-input-block">
                            <textarea name="bd_ignores" class="layui-textarea"
                                      rows="3">{{ join .obj.BdIgnores "\n"}}</textarea>
                                </div>
                            </div>
                        </div>
                        <div class="layui-col-md6">
                            <div class="layui-form-item">
                                <label class="layui-form-label"
                                       lay-tips="内链列表 关键词=>URL 例如：试管婴儿=>http://www.botadmin.cn/">内链列表:</label>
                                <div class="layui-input-block">
                            <textarea name="links" class="layui-textarea"
                                      rows="5">{{ join .obj.Links "\n"}}</textarea>
                                </div>
                            </div>
                        </div>
                        <div class="layui-col-md6">
                            <div class="layui-form-item">
                                <label class="layui-form-label"
                                       lay-tips="外链列表 关键词=>URL 例如：试管婴儿=>http://www.botadmin.cn/">外链列表:</label>
                                <div class="layui-input-block">
                            <textarea name="out_links" class="layui-textarea"
                                      rows="5">{{ join .obj.OutLinks "\n"}}</textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="layui-tab-item">
                    <div class="layui-form-item">
                        <label class="layui-form-label">Rewrite:</label>
                        <div class="layui-input-inline">
                            <select name="rewrite" lay-search>
                                <option value="">搜索...</option>
                                {{range .rewrites -}}
                                    <option value="{{.}}" {{if eq . $.obj.Rewrite}} selected{{end}}>{{.}}</option>
                                {{end -}}
                            </select>
                        </div>
                        <div class="layui-form-mid layui-word-aux">如不知道或无使用，
                            <a lay-href="/file?path={{.rewrite_path}}"
                               lay-text="Rewrite管理" style="color: #0a93bf"><strong>Rewrite管理</strong></a>。也可以使用.htaccess格式，上传到网站根目录(public_html)下
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">使用端口:</label>
                        <div class="layui-input-inline">
                            <input type="text" name="port" value="{{.obj.Port}}" class="layui-input">
                        </div>
                        <div class="layui-form-mid layui-word-aux">只在需要使用非80端口时使用，否则请使用默认值。可在系统设置里设置或增加端口</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">使用IP:</label>
                        <div class="layui-input-inline">
                            <select name="ip_addr" lay-search>
                                <option value="">搜索...</option>
                                {{range .ips}}
                                    <option value="{{.}}" {{if eq $.obj.IpAddr .}} selected{{end}}>{{.}}</option>
                                {{end}}
                            </select>
                        </div>
                        <div class="layui-form-mid layui-word-aux">此功能只在多IP且要域名指定IP时用，否则请留默认值。可在系统设置里设置或增加IP</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">IP并发数:</label>
                        <div class="layui-input-inline">
                            <input type="text" name="conn" class="layui-input" value="{{.obj.Conn}}">
                        </div>
                        <div class="layui-form-mid layui-word-aux">每IP的并发连接数 默认为0，即不限制</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">线程速度:</label>
                        <div class="layui-input-inline">
                            <input type="text" name="conn_speed" class="layui-input" value="{{.obj.ConnSpeed}}">
                        </div>
                        <div class="layui-form-mid layui-word-aux">默认为0，即不限制 每个连接线程的速度，单位KB/S</div>
                    </div>
                </div>
            </div>
            <div class="layui-form-item layui-hide">
                <div class="layui-input-block">
                    <input type="hidden" name="id" value="{{.obj.Id}}">
                    <button class="layui-btn" lay-submit lay-filter="submit">提交</button>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    JS.use(['main'], function () {
        let main = layui.main,
            form = layui.form,
            layer = layui.layer;
        $('[lay-event]').click(function () {
            switch ($(this).attr('lay-event')) {
                case 'valid-title':
                    main.req({
                        url: '/site/valid',
                        data: {text: $('input[name=title]').val()}
                    });
                    break;
                case 'valid-title-suffix':
                    main.req({
                        url: '/site/valid',
                        data: {text: $('input[name=title_suffix]').val()}
                    });
                    break;
                case 'valid-description':
                    main.req({
                        url: '/site/valid',
                        data: {text: $('input[name=description]').val()}
                    });
                    break;
                case 'assign-push':
                    $.get('/site/default/push', function (res) {
                        if (res.length === 0) {
                            layer.msg('默认数据为空');
                        }
                        $('textarea[name=push_config]').val(res);
                    });
                    break;
            }
        });
        main.render.tpl();
        //监控系统选择
        form.on('select(system)', function (obj) {
            $.get('/site/admin', {system: obj.value}, function (html) {
                $('input[name=admin_dir]').val(html);
            });
            $.get('/site/tpl', {system: obj.value, tpl_name: $('select[name=tpl_name]').val()}, function (html) {
                $('div[lay-filter=tpl_name]').html(html);
                form.render();
                $('#theme').empty();
                main.render.tpl();
            });
            if (obj.value === 'dedecms') {
                $('select[name=rewrite]>option').prop('selected', false);
            } else {
                $('select[name=rewrite]>option[value="' + obj.value + '.conf"]').prop('selected', true);
            }
            form.render('select');
        });
        //滑块控制
        main.slider(
            {elem: '#insert_pic_deg', range: true},
            {elem: '#pub_deg', range: true},
            {elem: '#content_deg', range: true},
            {elem: '#pub_attr_deg', value: {{$.obj.PubAttrDeg}}},
            {elem: '#originality_rate', value: {{$.obj.OriginalityRate}}, max: 100},
            {elem: '#link_deg', value: {{$.obj.LinkDeg}}},
            {elem: '#out_link_deg', value: {{$.obj.OutLinkDeg}}},
            {elem: '#title_tag_deg', value: {{$.obj.TitleTagDeg}}},
        );
        $('#theme').click(function () {
            main.msg($('#theme').html(), {area: ["80%", "80%"]});
        });
        //改变模板
        form.on('select(tpl_name)', function (obj) {
            $('#theme').empty();
            if (obj.value) {
                main.render.tpl(obj.value);
            }
        });
    });
</script>