local content_length = tonumber(ngx.req.get_headers()['content-length'])
local method = ngx.req.get_method()
local ngxMatch = ngx.re.match
if checkAllowIP() then
elseif checkDenyIP() then
elseif checkAllowURL() then
elseif checkDenyCC() then
elseif ngx.var.http_Acunetix_Aspect then
	ngx.exit(444)
elseif ngx.var.http_X_Scan_Memo then
	ngx.exit(444)
elseif checkUseragent() then
elseif checkURL() then
elseif checkArgs() then
elseif checkCookie() then
elseif PostEnabled then
	if method == "POST" then
		local boundary = getBoundary()
		if boundary then
			local len = string.len
			local sock, err = ngx.req.socket()
			if not sock then
				return
			end
			ngx.req.init_body(128 * 1024)
			sock:settimeout(0)
			local content_length = nil
			content_length = tonumber(ngx.req.get_headers()['content-length'])
			local chunk_size = 4096
			if content_length < chunk_size then
				chunk_size = content_length
			end
			local size = 0
			while size < content_length do
				local data, err, partial = sock:receive(chunk_size)
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
else
	return
end