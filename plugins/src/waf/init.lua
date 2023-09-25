local config = require("waf.config")
local ipMatcher = require("waf.ipMatcher")
local match = string.match
local ngxMatch = ngx.re.match
local unescape = ngx.unescape_uri
local headers = ngx.req.get_headers
local gsub = string.gsub
local ioOpen = io.open
local mobilePattern = "(?:hpw|i|web)os|alamofire|alcatel|amoi|android|avantgo|blackberry|blazer|cell|cfnetwork|darwin|dolfin|dolphin|fennec|htc|ip(?:hone|od|ad)|ipaq|j2me|kindle|midp|minimo|mobi|motorola|nec-|netfront|nokia|opera m(ob|in)i|palm|phone|pocket|portable|psp|silk-accelerated|skyfire|sony|ucbrowser|up.browser|up.link|windows ce|xda|zte|zune"
------------------------------------本地函数开始------------------------------------
--判断是手机端访问
local function isMobile()
	local useragent = ngx.var.http_user_agent
	if useragent ~= nil and ngxMatch(useragent, mobilePattern, "isjo") then
		return true
	end
	return false
end
-- 跳转到网址或者304
local function redirectExit(redirect)
	if redirect ~= nil and redirect ~= "" then
		if match(redirect, "^https?://") then
			ngx.status = 302
			ngx.redirect(redirect, 302)
			return true
		elseif match(redirect, "^%d+$") then
			ngx.status = tonumber(redirect)
			ngx.exit(ngx.status)
			return true
		end
	end
	return false
end
-- 日志写入文件
local function writeFile(filename, body)
	local fd = ioOpen(filename, "ab")
	if fd == nil then
		return
	end
	fd:write(body)
	fd:flush()
	fd:close()
end
-- 去除table重复
local function unique(t)
	if not t or type(t) ~= "table" then
		return {}
	end
	local t1, t2 = {}, {}
	for _, v in pairs(t) do
		t1[v] = true
	end
	for k, _ in pairs(t1) do
		table.insert(t2, k)
	end
	return t2
end
-- 获取客户端IP地址
local function getIP()
	local ip = headers()["X-Real-IP"]
	if ip == nil then
		ip = headers()["x_forwarded_for"]
	end
	if ip == nil then
		ip = ngx.var.remote_addr
	end
	return ip
end
-- 记录攻击日志
local function log(method, url, data, ruleTag)
	if config.LogEnabled then
		local data, _ = gsub(data, '"', '\"')
		local line = '{"ip":"' .. getIP() .. '", "time":"' .. ngx.localtime() .. '", "method":"' .. method .. '", "rule":"' .. ruleTag .. '", "url":"' .. url .. '", "data":"' .. data .. '", "useragent":"' .. ngx.var.http_user_agent .. '"}\n'
		local filename = config.LogPath .. '/' .. ngx.var.server_name .. "_" .. ngx.today() .. ".log"
		writeFile(filename, line)
	end
end
--读取过滤规则
local function readFile(filename)
	local file = ioOpen(config.RulePath .. "/" .. filename, "r")
	if file == nil then
		return {}
	end
	local t = {}
	for line in file:lines() do
		if line ~= nil then
			local line, _ = gsub(line, "^%s*(.-)%s*$", "%1")
			if line ~= "" then
				table.insert(t, line)
			end
		end
	end
	file:close()
	return unique(t)
end
--显示自定义HTML页面
local function sayHTML()
	if config.RedirectEnabled then
		ngx.header.content_type = "text/html"
		ngx.status = ngx.HTTP_FORBIDDEN
		ngx.say(config.HTML)
		ngx.exit(ngx.status)
	end
end
--设置值为true
local function Set (t)
	local set = {}
	for _, l in ipairs(t) do
		set[l] = true
	end
	return set
end
------------------------------------规则读取函数-------------------------------------------------------------------
local urlRules = readFile("url")
local argsRules = readFile("args")
local useragentRules = readFile("user-agent")
local allowUrlRules = readFile("allow-url")
local postRules = readFile("post")
local cookieRules = readFile("cookie")
local allowIP = ipMatcher.new(readFile("allow-ip"))
local denyIP = ipMatcher.new(readFile("deny-ip"))
local denyIPFilename = config.RulePath .. "/" .. "deny-ip"

--检查白名单URL
function checkAllowURL()
	if config.AllowUrlEnabled then
		if allowUrlRules ~= nil then
			for _, rule in pairs(allowUrlRules) do
				if ngxMatch(ngx.var.request_uri, rule, "isjo") then
					return true
				end
			end
		end
	end
	return false
end
--检查上传文件后缀
function checkFileExt(ext)
	local items = Set(config.DenyUploadExts)
	ext = string.lower(ext)
	if ext then
		for rule in pairs(items) do
			if ngxMatch(ext, rule, "isjo") then
				log('POST', ngx.var.host .. ngx.var.request_uri, "-", "file attack with ext " .. ext)
				sayHTML()
			end
		end
	end
	return false
end
--检查参数
function checkArgs()
	for _, rule in pairs(argsRules) do
		local args = ngx.req.get_uri_args()
		for _, val in pairs(args) do
			if type(val) == 'table' then
				local t = {}
				for _, v in pairs(val) do
					if v == true then
						v = ""
					end
					table.insert(t, v)
				end
				data = table.concat(t, " ")
			else
				data = val
			end
			if data and type(data) ~= "boolean" and rule ~= "" and ngxMatch(unescape(data), rule, "isjo") then
				log('GET', ngx.var.host .. ngx.var.request_uri, "-", rule)
				sayHTML()
				return true
			end
		end
	end
	return false
end
--检查URL
function checkURL()
	if config.UrlEnabled then
		for _, rule in pairs(urlRules) do
			if rule ~= "" and ngxMatch(ngx.var.request_uri, rule, "isjo") then
				log('GET', ngx.var.host .. ngx.var.request_uri, "-", rule)
				sayHTML()
				return true
			end
		end
	end
	return false
end
--检查useragent
function checkUseragent()
	if useragent ~= nil then
		for _, rule in pairs(useragentRules) do
			if rule ~= "" and ngxMatch(useragent, rule, "isjo") then
				log('UA', ngx.var.host .. ngx.var.request_uri, "-", rule)
				sayHTML()
				return true
			end
		end
	end
	return false
end
--检查POST body内容
function checkBody(data)
	if config.PostEnabled then
		for _, rule in pairs(postRules) do
			if rule ~= "" and data ~= "" and ngxMatch(unescape(data), rule, "isjo") then
				log('POST', ngx.var.host .. ngx.var.request_uri, data, rule)
				sayHTML()
				return true
			end
		end
	end
	return false
end
--检查cookie
function checkCookie()
	local ck = ngx.var.http_cookie
	if config.CookieEnabled and ck then
		for _, rule in pairs(cookieRules) do
			if rule ~= "" and ngxMatch(ck, rule, "isjo") then
				log('Cookie', ngx.var.host .. ngx.var.request_uri, "-", rule)
				sayHTML()
				return true
			end
		end
	end
	return false
end
--检查CC攻击
function checkDenyCC()
	if config.CCDenyEnabled then
		local ccCount = tonumber(match(config.CCRate, '(.*)/'))
		local ccSeconds = tonumber(match(config.CCRate, '/(.*)'))
		local ip = getIP()
		local token = ip .. ngx.var.host
		local limiter = ngx.shared.limit
		local req, _ = limiter:get(token)
		if req then
			if req > ccCount then
				if config.AddDenyEnabled then
					writeFile(denyIPFilename, ip .. "\n")
					allowIP = ipMatcher.new(readFile("allow-ip"))
				end
				ngx.exit(503)
				return true
			else
				limiter:incr(token, 1)
			end
		else
			limiter:set(token, 1, ccSeconds)
		end
	end
	return false
end
--获取Boundary
function getBoundary()
	local header = headers()["content-type"]
	if not header then
		return nil
	end

	if type(header) == "table" then
		header = header[1]
	end
	local m = match(header, ";%s*boundary=\"([^\"]+)\"")
	if m then
		return m
	end
	return match(header, ";%s*boundary=([^\",;]+)")
end
--检查白名单IP
function checkAllowIP()
	return allowIP:match(getIP())
end
-- 检查黑名单IP
function checkDenyIP()
	if denyIP:match(getIP()) then
		ngx.exit(403)
		return true
	end
	return false
end
-- 判断跳转
function checkRedirect()
	if config.PcRedirect ~= "" or config.MobileRedirect ~= "" then
		local isMobile = isMobile()
		if isMobile and config.MobileRedirect ~= "" then
			return redirectExit(config.MobileRedirect)
		elseif isMobile == false and config.PcRedirect ~= "" then
			return redirectExit(config.PcRedirect)
		end
	end
	return false
end
-- 验证useragent白名单
function checkAllowUseragent()
	if config.AllowUseragent ~= "" and ngxMatch(ngx.var.http_user_agent, config.AllowUseragent, "isjo") then
		return true
	end
	return false
end