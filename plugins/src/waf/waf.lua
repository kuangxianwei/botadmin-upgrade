local method = ngx.req.get_method()
local ngxMatch = ngx.re.match

if checkAllowIP() then --验证IP白名单
elseif checkDenyIP() then --验证IP黑名单
elseif checkAllowURL() then --验证URL白名单
elseif checkDenyCC() then --验证CC攻击
elseif ngx.var.http_Acunetix_Aspect then
	ngx.exit(444)
elseif ngx.var.http_X_Scan_Memo then
	ngx.exit(444)
elseif checkUseragent() then --验证Useragent
elseif checkURL() then --验证URL黑名单
elseif checkArgs() then --验证请求参数
elseif checkCookie() then --验证cookies
elseif PostEnabled then
	--验证POST请求
	if method == "POST" then
		local boundary = getBoundary()
		if boundary then
			local len = string.len
			local sock, _ = ngx.req.socket()
			if not sock then
				return
			end
			ngx.req.init_body(128 * 1024)
			sock:settimeout(0)
			local content_length
			content_length = tonumber(ngx.req.get_headers()['content-length'])
			local chunk_size = 4096
			if content_length < chunk_size then
				chunk_size = content_length
			end
			local size = 0
			local fileTranslate
			while size < content_length do
				local data, _, partial = sock:receive(chunk_size)
				data = data or partial
				if not data then
					return
				end
				ngx.req.append_body(data)
				if checkBody(data) then
					return true
				end
				size = size + len(data)
				local m = ngxMatch(data, [[Content-Disposition: form-data;(.+)filename="(.+)\\.(.*)"]], 'ijo')
				if m then
					checkFileExt(m[3])
					fileTranslate = true
				else
					if ngxMatch(data, "Content-Disposition:", 'isjo') then
						fileTranslate = false
					end
					if fileTranslate == false then
						if checkBody(data) then
							return true
						end
					end
				end
				local less = content_length - size
				if less < chunk_size then
					chunk_size = less
				end
			end
			ngx.req.finish_body()
		else
			ngx.req.read_body()
			local args = ngx.req.get_post_args()
			if not args then
				return
			end
			for key, val in pairs(args) do
				if type(val) == "table" then
					if type(val[1]) == "boolean" then
						return
					end
					data = table.concat(val, ", ")
				else
					data = val
				end
				if data and type(data) ~= "boolean" and checkBody(data) then
					checkBody(key)
				end
			end
		end
	end
elseif checkAllowUseragent() then --验证白名单Useragent 主要是放过搜索引擎的蜘蛛
elseif checkRedirect() then --验证做广告跳转
else
	return
end