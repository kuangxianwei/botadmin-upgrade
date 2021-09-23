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
<div class="layui-card layui-form">
    <div class="layui-card-body">
        <div class="layui-tab layui-tab-card">
            <ul class="layui-tab-title">
                <li class="layui-this">建站设置</li>
                <li>数据库</li>
                <li>FTP</li>
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
                        <div class="layui-col">
                            <a lay-href="/themes/shop?driver={{.obj.System}}" class="layui-btn layui-btn-primary" id="theme-shop"><i class="layui-icon iconfont icon-shop"></i>主题商店</a>
                        </div>
                    </div>
                    <div class="layui-form-item"></div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">默认目录</label>
                        <div class="layui-input-inline">
                            <input type="text" name="webroot_path" value="{{.obj.WebrootPath}}"
                                   class="layui-input">
                        </div>
                        <div class="layui-form-mid layui-word-aux">创建网站和ftp时默认的根目录</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">备份目录</label>
                        <div class="layui-input-inline">
                            <input type="text" name="backup_path" class="layui-input"
                                   value="{{.obj.BackupPath}}">
                        </div>
                        <div class="layui-form-mid layui-word-aux">备份数据时默认的根目录</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">默认首页</label>
                        <div class="layui-input-inline">
                            <input type="text" name="indexes" value="{{join .obj.Indexes ","}}"
                                   class="layui-input" autocomplete="on" placeholder="index.html,index.php">
                        </div>
                        <div class="layui-form-mid layui-word-aux">留空为默认值，多个用英文逗号“,”分隔</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">栏目数量</label>
                        <div class="layui-input-inline">
                            <input name="class_num" class="layui-input" value="{{.obj.ClassNum}}">
                        </div>
                        <div class="layui-form-mid layui-word-aux">网站的默认栏目数量</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">后台目录</label>
                        <div class="layui-input-inline">
                            <input name="admin_dir" class="layui-input" value="{{.obj.AdminDir}}">
                        </div>
                        <div class="layui-form-mid layui-word-aux">网站后台目录</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">Ssl</label>
                        <div class="layui-input-inline">
                            <select name="ssl">
                                <option value="0"{{if eq .obj.Ssl 0}} selected{{end}}>不启用</option>
                                <option value="1"{{if eq .obj.Ssl 1}} selected{{end}}>启用</option>
                                <option value="2"{{if eq .obj.Ssl 2}} selected{{end}}>强制启用</option>
                            </select>
                        </div>
                        <div class="layui-form-mid layui-word-aux">开启需要有SSL证书文件，否则无效。可后台创建或
                            <a lay-href="/file?path={{.obj.SslPath}}" class="text-danger">自行上传</a>。
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">启用手机站</label>
                        <div class="layui-input-inline">
                            <input type="checkbox" name="wap_enabled" lay-skin="switch"
                                   lay-text="是|否"{{if .obj.WapEnabled}} checked{{end}}>
                        </div>
                        <div class="layui-form-mid layui-word-aux"><span
                                    class="text-danger">启用手机站</span>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">手机目录</label>
                        <div class="layui-input-inline">
                            <input type="text" name="wap_root_dir" value="{{.obj.WapRootDir}}"
                                   class="layui-input">
                        </div>
                        <div class="layui-form-mid layui-word-aux">手机站目录 一般为网站内目录</div>
                    </div>
                </div>
                <div class="layui-tab-item">
                    <div class="layui-form-item">
                        <label class="layui-form-label">启用SQL</label>
                        <div class="layui-input-inline">
                            <input type="checkbox" name="sql_enabled" lay-skin="switch" lay-text="是|否"
                                   {{if .obj.SqlEnabled}}checked{{end}}>
                        </div>
                        <div class="layui-form-mid layui-word-aux"><span
                                    class="text-danger">是否创建数据库</span></div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">SQL前缀</label>
                        <div class="layui-input-inline">
                            <input type="text" name="db_prefix" value="{{.obj.DbPrefix}}"
                                   class="layui-input">
                        </div>
                        <div class="layui-form-mid layui-word-aux">由字母、数字、下划线组成<span
                                    class="text-danger">不能全为数字</span>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">数据编码</label>
                        <div class="layui-input-inline">
                            <select name="db_charset">
                                <option value="utf8mb4"{{if eq .obj.DbCharset "utf8mb4" -}}
                                selected{{end -}}>UTF8
                                </option>
                                <option value="gbk"{{if eq .obj.DbCharset "gbk" -}}
                                selected{{end -}}>GBK
                                </option>
                                <option value="latin1"{{if eq .obj.DbCharset "latin1" -}}
                                selected{{end -}}>latin1
                                </option>
                            </select>
                        </div>
                        <div class="layui-form-mid layui-word-aux">数据库编码，一般是用utf8,gbk</div>
                    </div>
                </div>
                <div class="layui-tab-item">
                    <div class="layui-form-item">
                        <label class="layui-form-label">FTP</label>
                        <div class="layui-input-inline">
                            <input type="checkbox" name="ftp_enabled" lay-skin="switch"
                                   lay-text="是|否"{{if .obj.FtpEnabled}} checked{{end}}>
                        </div>
                        <div class="layui-form-mid layui-word-aux"><span
                                    class="text-danger">是否创建FTP帐户</span></div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">FTP端口</label>
                        <div class="layui-input-inline">
                            <input type="number" name="ftp_port" value="{{.obj.FtpPort}}"
                                   class="layui-input">
                        </div>
                    </div>
                </div>
                <div class="layui-tab-item">
                    <fieldset class="layui-elem-field">
                        <legend>错误提示页</legend>
                        <div class="layui-form-item">
                            <label class="layui-form-label"></label>
                            <input name="err400" type="checkbox" title="400"{{if .obj.Err400}} checked{{end}}/>
                            <input name="err401" type="checkbox" title="401"{{if .obj.Err401}} checked{{end}}/>
                            <input name="err403" type="checkbox" title="403"{{if .obj.Err403}} checked{{end}}/>
                            <input name="err404" type="checkbox" title="404"{{if .obj.Err404}} checked{{end}}/>
                            <input name="err405" type="checkbox" title="405"{{if .obj.Err405}} checked{{end}}/>
                            <input name="err500" type="checkbox" title="500"{{if .obj.Err500}} checked{{end}}/>
                            <input name="err503" type="checkbox" title="503"{{if .obj.Err503}} checked{{end}}/>
                        </div>
                    </fieldset>
                    <fieldset class="layui-elem-field">
                        <legend>301/302跳转</legend>
                        <div class="layui-form-item">
                            <label class="layui-form-label"></label>
                            <div class="layui-input-inline">
                                <select name="redirects">
                                    <option value="0"{{if eq .obj.Redirects 0}} selected{{end}}>不启用
                                    </option>
                                    <option value="301"{{if eq .obj.Redirects 301}} selected{{end}}>301跳转
                                    </option>
                                    <option value="302"{{if eq .obj.Redirects 302}} selected{{end}}>302跳转
                                    </option>
                                </select>
                            </div>
                            <div class="layui-input-inline">
                                <input type="text" name="redirects_url" value="{{.obj.RedirectsUrl}}"
                                       class="layui-input" placeholder="http://www.botadmin.cn">
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
                                       title="Access"{{if .obj.AccessLog}} checked{{end}}>
                                <input type="checkbox" name="error_log"
                                       title="Error"{{if .obj.ErrorLog}} checked{{end}}>
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
                                       title="限制跨目录"{{if .obj.LimitDir}} checked{{end}}>
                                <input type="checkbox" name="display_dir"
                                       title="列举目录" {{if .obj.DisplayDir}} checked{{end}}>
                            </div>
                            <div class="layui-inline">
                                <div class="layui-form-mid layui-word-aux">防止webshell跨目录跨站和没有默认首页时显示所有文件列表</div>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">防盗链类型</label>
                            <div class="layui-input-block">
                                <input type="text" name="safe_img_type" value="{{.obj.SafeImgType}}"
                                       class="layui-input" placeholder="jpg,gif,bmp">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">允许的域名</label>
                            <div class="layui-input-block">
                                <input type="text" name="allow_domains" value="{{.obj.AllowDomains}}"
                                       class="layui-input" placeholder="botadmin.cn,nfivf.com">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">盗链URL</label>
                            <div class="layui-input-block">
                                <input type="text" name="safe_img_src" value="{{.obj.SafeImgSrc}}" class="layui-input"
                                       placeholder="http://www.webrobot.cn/images/logo.png">
                            </div>
                        </div>
                    </fieldset>
                    <fieldset class="layui-elem-field">
                        <legend>站点设置</legend>
                        <div class="layui-form-item">
                            <label class="layui-form-label">gzip压缩</label>
                            <div class="layui-input-inline">
                                <input type="checkbox" name="web_gzip" lay-skin="switch"
                                       lay-text="是|否"{{if .obj.WebGzip}} checked{{end}}>
                            </div>
                            <div class="layui-form-mid layui-word-aux">此功能为可将部分网页压缩传输，可以节省带宽</div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">客户端缓存</label>
                            <div class="layui-input-inline">
                                <input type="checkbox" name="client_cache" lay-skin="switch"
                                       lay-text="是|否"{{if .obj.ClientCache}} checked{{end}}>
                            </div>
                            <div class="layui-form-mid layui-word-aux">此功能可减轻服务器负载，但有时更新可能不会及时显示</div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">删除站点</label>
                            <div class="layui-input-inline">
                                <input type="checkbox" name="del_site_all" lay-skin="switch"
                                       lay-text="是|否"{{if .obj.DelSiteAll}} checked{{end}}>
                            </div>
                            <div class="layui-form-mid layui-word-aux">删除站点时是否删除目录和数据</div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">删除ftp</label>
                            <div class="layui-input-inline">
                                <input type="checkbox" name="del_ftp_all" lay-skin="switch"
                                       lay-text="是|否"{{if .obj.DelFtpAll}} checked{{end}}>
                            </div>
                            <div class="layui-form-mid layui-word-aux">删除ftp用户时是否删除目录及数据</div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">随机城市</label>
                            <div class="layui-input-inline">
                                <input type="checkbox" name="city_enabled" lay-skin="switch"
                                       lay-text="是|否"{{if .obj.CityEnabled}} checked{{end}}>
                            </div>
                            <div class="layui-form-mid layui-word-aux">开启或者关闭随机城市选择</div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">泛域名支持</label>
                            <div class="layui-input-inline">
                                <input type="checkbox" name="unlimited_bind" lay-skin="switch"
                                       lay-text="是|否"{{if .obj.UnlimitedBind}} checked{{end}}>
                            </div>
                            <div class="layui-form-mid layui-word-aux"><span
                                        class="text-danger">对泛域名的支持，一般不需要开启</span>
                            </div>
                        </div>
                    </fieldset>
                </div>
                <div class="layui-tab-item">
                    <div class="layui-form-item">
                        <label class="layui-form-label">发布模式:</label>
                        <div class="layui-input-inline">
                            <select name="publish_mode" class="layui-select">
                                <option value="0"{{if eq .obj.PublishMode 0}} selected{{end}}>随机模式</option>
                                <option value="1"{{if eq .obj.PublishMode 1}} selected{{end}}>正常模式</option>
                                <option value="2"{{if eq .obj.PublishMode 2}} selected{{end}}>百科模式</option>
                            </select>
                        </div>
                    </div>
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
                        <div class="layui-input-inline">
                            <input type="text" name="pic_dir" value="{{.obj.PicDir}}" class="layui-input"/>
                        </div>
                        <div class="layui-form-mid layui-word-aux">
                            <a lay-href="/file?path=data/pic/{{.obj.PicDir}}" lay-text="默认图片">点击添加或删除图片</a>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">插图阈值:</label>
                        <div class="layui-input-inline">
                            <div id="insert_pic_deg" class="slider-inline"></div>
                            <input type="hidden" name="insert_pic_deg" value="{{print .obj.InsertPicDeg}}"/>
                        </div>
                        <div class="layui-form-mid layui-word-aux">随机插入图片数量</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label" lay-tips="随机发布1至3篇文章数量">发布阈值:</label>
                        <div class="layui-input-block">
                            <div id="pub_deg" class="slider-block"></div>
                            <input type="hidden" name="pub_deg" value="{{print .obj.PubDeg}}"/>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">内容阈值:</label>
                        <div class="layui-input-inline">
                            <div id="content_deg" class="slider-inline"></div>
                            <input type="hidden" name="content_deg" value="{{print .obj.ContentDeg}}"/>
                        </div>
                        <div class="layui-form-mid layui-word-aux">内容内随机插入关键词数量</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">原创度:</label>
                        <div class="layui-input-inline">
                            <div id="originality_rate" class="slider-inline"></div>
                            <input type="hidden" name="originality_rate" value="{{$.obj.OriginalityRate}}">
                        </div>
                        <div class="layui-form-mid layui-word-aux">大于或等于这个值才发布</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">属性阀值:</label>
                        <div class="layui-input-inline">
                            <div id="pub_attr_deg" class="slider-inline"></div>
                            <input type="hidden" name="pub_attr_deg" value="{{$.obj.PubAttrDeg}}">
                        </div>
                        <div class="layui-form-mid layui-word-aux">值越高 几率越高</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">内链阀值:</label>
                        <div class="layui-input-inline">
                            <div id="link_deg" class="slider-inline"></div>
                            <input type="hidden" name="link_deg" value="{{$.obj.LinkDeg}}">
                        </div>
                        <div class="layui-form-mid layui-word-aux">随机插入内链</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">外链阀值:</label>
                        <div class="layui-input-inline">
                            <div id="out_link_deg" class="slider-inline"></div>
                            <input type="hidden" name="out_link_deg" value="{{$.obj.OutLinkDeg}}">
                        </div>
                        <div class="layui-form-mid layui-word-aux">随机插入外链</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">标题阀值:</label>
                        <div class="layui-input-inline">
                            <div id="title_tag_deg" class="slider-inline"></div>
                            <input type="hidden" name="title_tag_deg" value="{{$.obj.TitleTagDeg}}">
                        </div>
                        <div class="layui-form-mid layui-word-aux">标题插入tag 值越高 几率越高</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">指定:</label>
                        <div class="layui-input-inline">
                            <input type="checkbox" name="pub_self" lay-skin="switch"
                                   lay-text="是|否"{{if .obj.PubSelf}} checked{{end}}>
                        </div>
                        <div class="layui-form-mid layui-word-aux">只发布指定本站的文章</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">保存图片:</label>
                        <div class="layui-input-inline">
                            <input type="checkbox" name="pic_save" lay-skin="switch"
                                   lay-text="是|否"{{if .obj.PicSave}} checked{{end}}>
                        </div>
                        <div class="layui-form-mid layui-word-aux">是否保存远程图片</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">图片水印:</label>
                        <div class="layui-input-inline">
                            <input type="checkbox" name="pic_mark" lay-skin="switch"
                                   lay-text="是|否"{{if .obj.PicMark}} checked{{end}}>
                        </div>
                        <div class="layui-form-mid layui-word-aux">图片是否加水印</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">删除已发:</label>
                        <div class="layui-input-inline">
                            <input type="checkbox" name="del_published" lay-skin="switch"
                                   lay-text="是|否"{{if .obj.DelPublished}} checked{{end}}>
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
                        <div class="layui-form-item">
                            <label class="layui-form-label"
                                   lay-tips="api 别名 说明 一行一条 &#123;&#123;site&#125;&#125; 代表: http://www.botadmin.cn &#123;&#123;host&#125;&#125; 代表: www.botadmin.cn">推送设置</label>
                            <div class="layui-input-block">
                                <textarea name="push_config" class="layui-textarea" rows="3">{{.push_config}}</textarea>
                            </div>
                        </div>
                    </fieldset>
                </div>
                <div class="layui-tab-item">
                    <div class="layui-row">
                        <div class="layui-col-md6">
                            <div class="layui-form-item">
                                <label class="layui-form-label" lay-tips="登录百度后的cookies">百度 Cookies:</label>
                                <div class="layui-input-block">
                                    <textarea name="bd_cookies" class="layui-textarea" rows="3"
                                              placeholder="BAIDUID=9FB739ED7E70EF8247B81415058BCB64:FG=1; PSTM=1620359085; PSINO=6; BD_CK_SAM=1; delPer=0; BIDUPSID=5296CC5C149D53A3462999AA795C8824; BAIDUID_BFESS=9FB739ED7E70EF8247B81415058BCB64:FG=1; COOKIE_SESSION=0_0_0_0_1_0_0_0_0_0_0_0_0_0_2_0_1620359088_0_1620359086%7C1%230_0_1620359086%7C1; H_PS_PSSID=33985_33820_31253_34004_33756_33676_33607_26350_33996; BD_UPN=12314753; BDORZ=B490B5EBF6F3CD402E515D22BCDA1598; BDUSS_BFESS=25VMmJwNzhLMTlGb3FTeE01Wk9jd3N-QUJhaGlLc2ZuTktxU1ZwaC02VkN3cjVnSVFBQUFBJCQAAAAAAAAAAAEAAADCjSYT2vfPzc6wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEI1l2BCNZdgU; BDUSS=25VMmJwNzhLMTlGb3FTeE01Wk9jd3N-QUJhaGlLc2ZuTktxU1ZwaC02VkN3cjVnSVFBQUFBJCQAAAAAAAAAAAEAAADCjSYT2vfPzc6wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEI1l2BCNZdgU; sugstore=1; H_PS_645EC=9350iLs1RL31aIit5ml8QCIhe79p5iPmI8yBGI1Dgr768BQf7SW%2Btb1IoTo; BA_HECTOR=a100ah20al2k21a0181g9edaf0r; WWW_ST=1620522324302">{{.obj.BdCookies}}</textarea>
                                </div>
                            </div>
                        </div>
                        <div class="layui-col-md6">
                            <div class="layui-form-item">
                                <label class="layui-form-label" lay-tips="忽略百度关键词列表">过滤:</label>
                                <div class="layui-input-block">
                                    {{$bd_ignores:=`小姐
代孕` -}}
                                    <textarea name="bd_ignores" class="layui-textarea" rows="3"
                                              placeholder="{{$bd_ignores}}">{{ join .obj.BdIgnores "\n"}}</textarea>
                                </div>
                            </div>
                        </div>
                        <div class="layui-col-md6">
                            <div class="layui-form-item">
                                <label class="layui-form-label"
                                       lay-tips="外链列表 关键词=>URL 例如：试管婴儿=>http://www.botadmin.cn/">外链列表:</label>
                                <div class="layui-input-block">
                                    {{$OutLinks:=`试管婴儿=>http://www.nfivf.com/
站掌门=>http://www.botadmin.cn/` -}}
                                    <textarea name="out_links" class="layui-textarea" rows="5"
                                              placeholder="{{$OutLinks}}">{{ join .obj.OutLinks "\n"}}</textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="layui-tab-item">
                    <div class="layui-form-item">
                        <label class="layui-form-label">Rewrite</label>
                        <div class="layui-input-inline">
                            <select name="rewrite">
                                <option value="">无</option>
                                {{range .rewrites -}}
                                    <option value="{{.}}"{{if eq $.obj.Rewrite . }} selected{{end}}>{{.}}</option>
                                {{end -}}
                            </select>
                        </div>
                        <div class="layui-form-mid layui-word-aux">如不知道或无使用，
                            <a lay-href="/file?path={{.server.RewritePath}}"
                               lay-text="Rewrite管理"
                            ><strong>Rewrite管理</strong></a>。也可以使用.htaccess格式(public_html)下
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">使用端口</label>
                        <div class="layui-input-inline">
                            <input type="number" name="port" value="{{.obj.Port}}" class="layui-input" placeholder="80">
                        </div>
                        <div class="layui-form-mid layui-word-aux">
                            只在需要使用非80端口时使用，否则请使用默认值。可在系统设置里设置或增加端口
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">IP并发数</label>
                        <div class="layui-input-inline">
                            <input type="number" name="conn" class="layui-input" value="{{.obj.Conn}}" placeholder="0">
                        </div>
                        <div class="layui-form-mid layui-word-aux">默认为0，即不限制 每IP的并发连接数</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">线程速度</label>
                        <div class="layui-input-inline">
                            <input type="number" name="conn_speed" class="layui-input"
                                   value="{{.obj.ConnSpeed}}" placeholder="0">
                        </div>
                        <div class="layui-form-mid layui-word-aux">默认为0，即不限制 每个连接线程的速度，单位KB/S</div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">Tags:</label>
                        <div class="layui-input-block">
                            <textarea name="tags" class="layui-textarea" placeholder="TAG 一行一个">{{join .obj.Tags "\n"}}</textarea>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label" lay-tips="留空为智能填充,建议用其他编辑器编写好了再粘贴过来">栏目列表:</label>
                        <div class="layui-input-block">
                            {{$classesExample:=`顶级栏目1(一个栏目一行,一个栏目不可换行)
---->二级栏目1
---->二级栏目2
-------->三级栏目
顶级栏目2
---->二级栏目
顶级栏目3` -}}
                            <div class="layui-form-mid layui-word-aux">
                                name=栏目名称 || alias=别名 || keywords=关键词1 || 关键词2 || 关键词3 || description=描述 ||
                                id=栏目ID || parent_id=父ID || parent_name=父栏目 || path=路径 || url=URL ||
                                hidden=false(隐藏栏目) || is_face=false(是封面) || level=0(几级栏目)
                            </div>
                            <textarea name="classes" class="layui-textarea" rows="7"
                                      placeholder="{{$classesExample}}">{{print .obj.Classes }}</textarea>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">广告代码</label>
                        <div class="layui-input-block">
                            <textarea name="ad" class="layui-textarea" placeholder="这里是放广告代码 主要是javascript 代码">{{.obj.Ad}}</textarea>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">关键词替换</label>
                        <div class="layui-input-inline">
                                        <textarea class="layui-textarea" name="replaces"
                                                  placeholder="小姐=>美女">{{join .obj.Replaces "\n"}}</textarea>
                        </div>
                        <div class="layui-form-mid layui-word-aux">留空为不启用 "代孕=>怀孕" 一行一个
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">联系方式:</label>
                        <div class="layui-input-inline">
                            {{$contact:=`李谊:139-2235-2985
韩晶:135-3983-5229`}}
                            <textarea class="layui-textarea" name="contact"
                                      placeholder="{{$contact}}">{{join .obj.Contact "\n"}}</textarea>
                        </div>
                        <div class="layui-form-mid layui-word-aux">联系方式一行一条 名称:139-2235-2985</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="layui-card-body layui-form-item">
            <div class="layui-btn-group">
                <button class="layui-btn" lay-submit lay-filter="submit">提交</button>
                <button class="layui-btn" data-event="reset"><i class="layui-icon iconfont icon-reset"></i>默认</button>
            </div>
        </div>
    </div>
</div>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let main = layui.main,
            form = layui.form,
            //获取模板目录名称
            tplName = $('select[name=tpl_name]').val(),
            url = {{.current_uri}};
        //改变模板目录列表
        form.on('select(system)', function (obj) {
            $('#theme-shop').attr("lay-href", "/themes/shop?driver=" + obj.value);
            let tplUrl = '/site/tpl?system=' + obj.value;
            if (tplName) {
                tplUrl = tplUrl + '&tpl_name=' + tplName;
            }
            $.get(tplUrl, {}, function (html) {
                $('div[lay-filter=tpl_name]').html(html);
                form.render();
                $('#theme').empty();
                main.render.tpl();
            });
        });
        form.on('submit(submit)', function (obj) {
            main.req({
                url: url,
                data: obj.field,
            });
            return false;
        });
        $('.layui-btn[data-event]').on('click', function () {
            let event = $(this).data('event');
            switch (event) {
                case 'reset':
                    main.req({
                        url: url + '/reset',
                        ending: function () {
                            location.replace(url);
                        }
                    });
                    break;
            }
            return false;
        });
        //滑块控制
        main.slider(
            {elem: '#insert_pic_deg', range: true},
            {elem: '#pub_deg', range: true, max: 100},
            {elem: '#content_deg', range: true},
            {elem: '#originality_rate', value: {{$.obj.OriginalityRate}}, max: 100},
            {elem: '#pub_attr_deg', value: {{$.obj.PubAttrDeg}}},
            {elem: '#link_deg', value: {{$.obj.LinkDeg}}},
            {elem: '#out_link_deg', value: {{$.obj.OutLinkDeg}}},
            {elem: '#title_tag_deg', value: {{$.obj.TitleTagDeg}}},
        );
        $('#theme').click(function () {
            main.display({content: $('#theme').html()});
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