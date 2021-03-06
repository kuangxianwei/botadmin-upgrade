<div class="layui-card">
    <div class="layui-card-header">所有标签:</div>
    <div class="layui-card-body">
        <table border="1">
            <tr>
                <th width="30%">标签</th>
                <th width="30%">类型</th>
                <th width="30%">说明</th>
            </tr>
            <tr>
                <td>uid</td>
                <td>int</td>
                <td>用户ID</td>
            </tr>
            <tr>
                <td>ftp_id</td>
                <td>int</td>
                <td>FTP ID</td>
            </tr>
            <tr>
                <td>sql_id</td>
                <td>int</td>
                <td>数据库 ID</td>
            </tr>
            <tr>
                <td>ftp_user</td>
                <td>string</td>
                <td>FTP 用户名</td>
            </tr>
            <tr>
                <td>ftp_pwd</td>
                <td>string</td>
                <td>FTP 密码</td>
            </tr>
            <tr>
                <td>db_name</td>
                <td>string</td>
                <td>数据库名称</td>
            </tr>
            <tr>
                <td>db_user</td>
                <td>string</td>
                <td>数据库用户名</td>
            </tr>
            <tr>
                <td>db_pwd</td>
                <td>string</td>
                <td>数据库密码</td>
            </tr>
            <tr>
                <td>vhost</td>
                <td>string</td>
                <td>主域名</td>
            </tr>
            <tr>
                <td>title</td>
                <td>string</td>
                <td>主域名标题</td>
            </tr>
            <tr>
                <td>title_suffix</td>
                <td>string</td>
                <td>标题后缀</td>
            </tr>
            <tr>
                <td>description</td>
                <td>string</td>
                <td>主域名描述</td>
            </tr>
            <tr>
                <td>keywords</td>
                <td>string</td>
                <td>主域名关键词</td>
            </tr>
            <tr>
                <td>about</td>
                <td>string</td>
                <td>关于我们</td>
            </tr>
            <tr>
                <td>binds</td>
                <td>string</td>
                <td>绑定域名</td>
            </tr>
            <tr>
                <td>wap_host</td>
                <td>string</td>
                <td>手机域名</td>
            </tr>
            <tr>
                <td>wap_title</td>
                <td>string</td>
                <td>手机域名标题</td>
            </tr>
            <tr>
                <td>wap_description</td>
                <td>string</td>
                <td>手机域名描述</td>
            </tr>
            <tr>
                <td>wap_keywords</td>
                <td>string</td>
                <td>手机域名关键词</td>
            </tr>
            <tr>
                <td>webroot_path</td>
                <td>string</td>
                <td>主域名目录</td>
            </tr>
            <tr>
                <td>cookies</td>
                <td>string</td>
                <td>cookies</td>
            </tr>
            <tr>
                <td>system</td>
                <td>string</td>
                <td> 网站程序</td>
            </tr>
            <tr>
                <td>webroot_path</td>
                <td>string</td>
                <td> 创建网站和ftp时默认的根目录</td>
            </tr>
            <tr>
                <td>backup_path</td>
                <td>string</td>
                <td> 备份数据时默认的根目录</td>
            </tr>
            <tr>
                <td>classs</td>
                <td>string</td>
                <td>主域名网站栏目</td>
            </tr>
            <tr>
                <td>ip_addr</td>
                <td>string</td>
                <td>绑定的IP地址</td>
            </tr>
            <tr>
                <td>city</td>
                <td>string</td>
                <td>城市名称</td>
            </tr>
            <tr>
                <td>tags</td>
                <td>string</td>
                <td>tags</td>
            </tr>
            <tr>
                <td>status</td>
                <td>string</td>
                <td>状态</td>
            </tr>
            <tr>
                <td>note</td>
                <td>string</td>
                <td>备注</td>
            </tr>
            <tr>
                <td>web_user</td>
                <td>string</td>
                <td>网站后台用户名</td>
            </tr>
            <tr>
                <td>web_pwd</td>
                <td>string</td>
                <td>网站后台密码</td>
            </tr>
            <tr>
                <td>php_my_admin_name</td>
                <td>string</td>
                <td> phpmyadmin目录</td>
            </tr>
            <tr>
                <td>wap_root_dir</td>
                <td>string</td>
                <td> 手机站目录</td>
            </tr>
            <tr>
                <td>index</td>
                <td>string</td>
                <td> 索引页</td>
            </tr>
            <tr>
                <td>db_prefix</td>
                <td>string</td>
                <td> 数据库前缀</td>
            </tr>
            <tr>
                <td>admin_dir</td>
                <td>string</td>
                <td>后台目录</td>
            </tr>
            <tr>
                <td>ssl</td>
                <td>int</td>
                <td> 开启ssl 0 禁止 1 开启 2 强制开启</td>
            </tr>
            <tr>
                <td>ssl_path</td>
                <td>string</td>
                <td> 开启ssl路径</td>
            </tr>
            <tr>
                <td>class_num</td>
                <td>int</td>
                <td> 总栏目数</td>
            </tr>
            <tr>
                <td>port</td>
                <td>int</td>
                <td> 绑定端口</td>
            </tr>
            <tr>
                <td>ftp_port</td>
                <td>int</td>
                <td> ftp端口</td>
            </tr>
            <tr>
                <td>conn</td>
                <td>int</td>
                <td> ip并发数 0为不限制</td>
            </tr>
            <tr>
                <td>redirects</td>
                <td>int</td>
                <td> 0不启用 301/302跳转</td>
            </tr>
            <tr>
                <td>conn_speed</td>
                <td>int</td>
                <td> 连接线程速度 0 为不限制</td>
            </tr>
            <tr>
                <td>del_site_all</td>
                <td>bool</td>
                <td> 删除站点时是否删除目录和数据</td>
            </tr>
            <tr>
                <td>del_ftp_all</td>
                <td>bool</td>
                <td> 删除ftp用户时是否删除目录及数据</td>
            </tr>
            <tr>
                <td>wap_enabled</td>
                <td>bool</td>
                <td> 启用手机站</td>
            </tr>
            <tr>
                <td>sql_enabled</td>
                <td>bool</td>
                <td> 启用数据库</td>
            </tr>
            <tr>
                <td>ftp_enabled</td>
                <td>bool</td>
                <td> 启用ftp</td>
            </tr>
            <tr>
                <td>err400</td>
                <td>bool</td>
                <td> 启用400</td>
            </tr>
            <tr>
                <td>err401</td>
                <td>bool</td>
                <td> 启用401</td>
            </tr>
            <tr>
                <td>err403</td>
                <td>bool</td>
                <td> 启用403</td>
            </tr>
            <tr>
                <td>err404</td>
                <td>bool</td>
                <td> 启用404</td>
            </tr>
            <tr>
                <td>err405</td>
                <td>bool</td>
                <td> 启用405</td>
            </tr>
            <tr>
                <td>err500</td>
                <td>bool</td>
                <td> 启用500</td>
            </tr>
            <tr>
                <td>err503</td>
                <td>bool</td>
                <td> 启用503</td>
            </tr>
            <tr>
                <td>access_log</td>
                <td>bool</td>
                <td> 启用日志记录</td>
            </tr>
            <tr>
                <td>error_log</td>
                <td>bool</td>
                <td> 启用错误日志记录</td>
            </tr>
            <tr>
                <td>limit_dir</td>
                <td>bool</td>
                <td> 启用限制夸目录</td>
            </tr>
            <tr>
                <td>display_dir</td>
                <td>bool</td>
                <td> 启用显示目录文件列表</td>
            </tr>
            <tr>
                <td>web_gzip</td>
                <td>bool</td>
                <td> 启用zip压缩</td>
            </tr>
            <tr>
                <td>client_cache</td>
                <td>bool</td>
                <td> 启用客户端缓存</td>
            </tr>
            <tr>
                <td>city_enabled</td>
                <td>bool</td>
                <td> 启用随机城市选择</td>
            </tr>
            <tr>
                <td>unlimited_bind</td>
                <td>bool</td>
                <td> 启用泛域名支持</td>
            </tr>
            <tr>
                <td>db_charset</td>
                <td>string</td>
                <td> 数据库编码</td>
            </tr>
            <tr>
                <td>tpl_name</td>
                <td>string</td>
                <td> 网站模板名称</td>
            </tr>
            <tr>
                <td>replace</td>
                <td>string</td>
                <td> 关键词替换</td>
            </tr>
            <tr>
                <td>article_path</td>
                <td>string</td>
                <td> 文章发布源路径</td>
            </tr>
            <tr>
                <td>rewrite</td>
                <td>string</td>
                <td> 重写规则文件名称</td>
            </tr>
            <tr>
                <td>redirects_url</td>
                <td>string</td>
                <td> 跳转地址</td>
            </tr>
            <tr>
                <td>safe_img_type</td>
                <td>string</td>
                <td> 防盗链类型 如多个用逗号“;”分隔,如“jpg;gif;bmp”</td>
            </tr>
            <tr>
                <td>allow_domains</td>
                <td>string</td>
                <td> 允许的域名 如多个用逗号“;”分隔，不带http://，如webrobot.cn;webrobot.com</td>
            </tr>
            <tr>
                <td>ad</td>
                <td>string</td>
                <td> 广告代码 如多个用逗号“;”分隔</td>
            </tr>
            <tr>
                <td>contact</td>
                <td>string</td>
                <td> 联系我们电话号码 如多个用逗号“,”分隔 例如：李谊:139-2235-2985,韩晶:135-3983-5229</td>
            </tr>
        </table>
    </div>
</div>