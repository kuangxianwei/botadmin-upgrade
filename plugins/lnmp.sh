#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# Name:lnmp
# Alias:LNMP
# Intro:LNMP一键安装包是一个用Shell编写的可以为 Linux VPS或独立主机安装LNMP(Nginx/MySQL/PHP)、LNMPA(Nginx/MySQL/PHP/Apache)、LAMP(Apache/MySQL/PHP)生产环境的Shell程序
# Args:2.0

# 插件名称
# shellcheck disable=SC2034
PLUGIN_NAME="LNMP"
# 当前脚本目录
CUR_DIR=$(dirname "$(readlink -f "$0")")
. "$CUR_DIR/include/init.sh" || exit 1
lnmpVersion=2.0
if test -n "$2"; then
  lnmpVersion="$2"
fi
# 安装
Install() {
  command -v lnmp
}
# 卸载
Uninstall() {
  rm -rf "/root/lnmp${lnmpVersion}" "/root/lnmp${lnmpVersion}.tar.gz"
  wget "http://soft.vpser.net/lnmp/lnmp${lnmpVersion}.tar.gz" -cO "lnmp${lnmpVersion}.tar.gz" && tar zxf "lnmp${lnmpVersion}.tar.gz" && cd "lnmp${lnmpVersion}" && ./uninstall.sh lnmp
}

# 执行安装或卸载
Execute "$@"