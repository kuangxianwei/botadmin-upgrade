#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# Name:waf
# Alias:ngx_lua_waf
# Intro:waf是一个功能比较全的应用服务器，是基于标准的nginx核心，可以扩展很多第三方模块
# Args:

# 插件名称
# shellcheck disable=SC2034
PLUGIN_NAME="WAF"
# 当前脚本目录
CUR_DIR=$(dirname "$(readlink -f "$0")")
. "$CUR_DIR/include/init.sh" || exit 1

# 安装
Install() {
	if [ ! -d /usr/local/nginx ]; then
		Error "还没有安装nginx"
	fi
	if [ ! -d "${SRC_DIR}/waf" ]; then
		Error "缺少waf源文件"
	fi
	if ! /usr/local/nginx/sbin/nginx -V 2>&1 | grep -Eqi 'lua-nginx-module'; then
		cd /root || Error "转到/root失败"
		\rm -rf ./lnmp2.0
		if [ ! -f lnmp2.0.tar.gz ]; then
			if ! wget https://soft.lnmp.com/lnmp/lnmp2.0.tar.gz -O lnmp2.0.tar.gz; then
				Error "下载lnmp失败"
			fi
		fi
		tar zxf lnmp2.0.tar.gz
		cd lnmp2.0 || Error "进入目录lnmp2.0失败"
		cat "$CUR_DIR/include/install_waf.sh" >>/root/lnmp2.0/include/upgrade_nginx.sh
		./upgrade.sh nginx
		if ! grep -Eqi 'lua_package_path' /usr/local/nginx/conf/nginx.conf; then
			Error "安装lua-nginx-module模块失败"
		fi
	fi

	echo "cd 进入${SRC_DIR}"
	cd "${SRC_DIR}" || Error "进入目录失败"

	# 复制模块文件
	\rm -rf /usr/local/nginx/lib/lua/waf
	if [ ! -d /usr/local/nginx/lib/lua ]; then
		if ! mkdir -p /usr/local/nginx/lib/lua; then
			Error "创建文件夹失败"
		fi
	fi
	if ! \cp -rf ./waf /usr/local/nginx/lib/lua; then
		Error "复制waf源失败"
	fi
	if ! mkdir -p /usr/local/nginx/lib/lua/waf/logs; then
		Error "创建文件夹失败"
	fi
	chown -R www:www /usr/local/nginx/lib/lua/waf/logs /usr/local/nginx/lib/lua/waf/conf/deny-ip
	if ! grep -Eqi 'lua_package_path' /usr/local/nginx/conf/nginx.conf; then
		sed -i '/include vhost\/\*.conf;/i\        lua_package_path "/usr/local/nginx/lib/lua/?.lua;;";' /usr/local/nginx/conf/nginx.conf
	fi
	if ! grep -Eqi 'access_by_lua_file' /usr/local/nginx/conf/nginx.conf; then
		sed -i '/lua_package_path/a\        access_by_lua_file /usr/local/nginx/lib/lua/waf/waf.lua;' /usr/local/nginx/conf/nginx.conf
	fi
	if ! grep -Eqi 'init_by_lua_file' /usr/local/nginx/conf/nginx.conf; then
		sed -i '/lua_package_path/a\        init_by_lua_file  /usr/local/nginx/lib/lua/waf/init.lua;' /usr/local/nginx/conf/nginx.conf
	fi
	if ! grep -Eqi 'lua_shared_dict\s+limiter' /usr/local/nginx/conf/nginx.conf; then
		sed -i '/lua_package_path/a\        lua_shared_dict limiter 20m;' /usr/local/nginx/conf/nginx.conf
	fi
	echo "重启NGINX"
	nginx -t
	if ! systemctl restart nginx; then
		Error "安装waf失败"
	fi
	echo "安装waf成功"
}
# 卸载
Uninstall() {
	echo "暂时没有提供卸载功能"
}
# 验证是否安装
Installed() {
	if ! /usr/local/nginx/sbin/nginx -V 2>&1 | grep -Eqi 'lua-nginx-module'; then
		exit 1
	fi
	if ! test -d /usr/local/nginx/lib/lua/waf; then
		exit 1
	fi
	if ! grep -Eqi 'lua_package_path' /usr/local/nginx/conf/nginx.conf; then
		exit 1
	fi
	if ! grep -Eqi 'access_by_lua_file' /usr/local/nginx/conf/nginx.conf; then
		exit 1
	fi
	if ! grep -Eqi 'init_by_lua_file' /usr/local/nginx/conf/nginx.conf; then
		exit 1
	fi
	grep -Eqi 'lua_shared_dict\s+limiter' /usr/local/nginx/conf/nginx.conf
}

# 执行安装或卸载
Execute "$@"
