local _M = {}
--初始化CC
_M.CCRate = {}
--规则列表
_M.RulePath = "/usr/local/nginx/lib/lua/waf/conf"
--是否开启攻击日志
_M.LogEnabled = true
--攻击日志目录
_M.LogPath = "/usr/local/nginx/lib/lua/waf/logs"
--是否开启url检查
_M.UrlEnabled = true
--拦截后是否跳转到自定义拦截页面
_M.RedirectEnabled = true
--是否启用cookie检查
_M.CookieEnabled = false
--是否启用post检查
_M.PostEnabled = true
--是否启用白名单检查URL
_M.AllowUrlEnabled = true
-- 拒绝上传的文件后缀
_M.DenyUploadExts = { "php", "jsp" }
-- 是否开启自动把IP加入永久黑名单（慎用，如果确定开启，请将搜索引擎蜘蛛IP加入到IP白名单列表）
_M.AddDenyEnabled = false
--是否开启拦截cc攻击(需要nginx.conf的http段增加lua_shared_dict limiter 20m;)
_M.CCDenyEnabled = true
--设置cc攻击频率，单位为秒. 默认1分钟同一个IP只能请求同一个地址100次
_M.CCRate.limit = 100
--期间内
_M.CCRate.interval = 60
--封禁期间单位为秒 默认封禁1小时
_M.CCRate.banInterval = 3600
--启用定时验证黑名单IP的DNS
_M.CheckDns = true
--检查DNS是定时规则，默认每小时检查一次
_M.CheckDnsSpec = "0 0 * ? * ?"
--Useragent白名单（正则匹配）Baiduspider|Googlebot|Sogou|360Spider|bingbot|Bytespider|YisouSpider
_M.AllowUseragent = "Baiduspider|Googlebot|Sogou|360Spider|bingbot|Bytespider|YisouSpider|Yandex"
--DNS白名单列表，在白名单内的DNS对应的IP自动进入白名单ip列表
_M.AllowDns = { ".baidu.com", ".baidu.jp", ".googlebot.com", ".google.com", ".googleusercontent.com", ".msn.com", ".sogou.com", ".yandex.com", ".bytedance.com", ".apple.com" }
--pc端302跳转
_M.PcRedirect = ""
--移动端跳转
_M.MobileRedirect = ""
--拒绝后的显示HTML
_M.HTML = [[
<!DOCTYPE html>
<html lang="zh-cn">
<head>
	<meta charset="UTF-8">
	<title>站掌门网络防火墙</title>
	<style>
		*{ -qt-block-indent: 0;list-style-type: none;margin: 0; text-decoration: none;text-indent: 0;}
		body{color: #555; font: 14px/1.5 Microsoft Yahei, 宋体, sans-serif; margin: 0; padding: 0;}
		.main{margin: 0 auto; overflow: hidden; padding-top: 70px; width: 1000px;}
		ul{ list-style-type: none;}
	</style>
</head>
<body>
<div class="main">
	<div style="width:600px; float:left;">
		<div style="height:40px; line-height:40px; color:#fff; font-size:16px; overflow:hidden; background:#226A62; padding-left:20px;">
			站掌门网络防火墙
		</div>
		<div style="border:1px dashed #226A62; border-top:none; font-size:14px; background:#fff; color:#555; line-height:24px; height:220px; padding:20px 20px 0 20px; overflow-y:auto;">
			<p><span style="font-weight:600; color:#fc4f03;">您的请求带有不合法参数，已被网站管理员设置拦截！</span></p>
			<p>可能原因：您提交的内容包含危险的攻击请求</p>
			<p>如何解决：</p>
			<ul style="-qt-list-indent: 1;">
				<li>1）检查提交内容；</li>
				<li>2）如网站托管，请联系空间提供商；</li>
				<li>3）普通网站访客，请联系网站管理员；</li>
			</ul>
			<p>进入<span><a href="http://www.botadmin.cn">站掌门Ai自动养站系统</a></span></p>
		</div>
	</div>
</div>
</body>
</html>
]]
return _M