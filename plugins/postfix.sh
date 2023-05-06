#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# Name:postfix
# Alias:邮件服务器
# Intro:Postfix 由源代码构建，可以在类 UNIX 系统上运行，包括 AIX、BSD、HP-UX、Linux、MacOS X、Solaris 等,官网:http://www.postfix.org/
# Args:mail.nfivf.com

# 插件名称
# shellcheck disable=SC2034
PLUGIN_NAME="邮件服务器"
# 当前脚本目录
CUR_DIR=$(dirname "$(readlink -f "$0")")
. "$CUR_DIR/include/init.sh" || exit 1
# 安装
Install() {
  Firewall_Enable 25/tcp 25/udp
  # 安装mail 服务器 postfix
  if ! command -v postfix; then
    if ! yum install postfix -y; then
      Error "安装postfix失败"
    fi
  fi
  local mailHostname=$1
  if [ -n "$mailHostname" ]; then
    if ! sed -r -i \
      -e "s/^#?myhostname\s*=\s*.*?$/myhostname = $mailHostname/" \
      -e "s/^#?mydomain\s*=\s*.*?$/mydomain = ${mailHostname#*.}/" \
      -e "s/^#myorigin\s*=\s*\\\$myhostname\s*$/myorigin = \$myhostname/" \
      -e "s/^mydestination\s*=\s*\\\$myhostname,\s*localhost.\\\$mydomain,\s*localhost.*$/mydestination = \$myhostname, localhost.\$mydomain, localhost, $mailHostname/" \
      -e "s/^#relay_domains\s*=\s*\\\$mydestination\s*$/relay_domains = \$mydestination/" \
      /etc/postfix/main.cf; then
      Error "替换失败:/etc/postfix/main.cf"
    fi
  fi

  # 设置开机
  if ! systemctl enable postfix.service; then
    Error "设置开机启动postfix失败"
  fi

  # 设置启动
  if ! systemctl start postfix; then
    Error "启动postfix失败"
  fi
  if ! command -v mail; then
    if ! yum install -y mailx; then
      echo "安装 mailx 失败" 1>&2
      Uninstall
      exit 1
    fi
  fi
}
# 卸载
Uninstall() {
  # 关闭25端口
  Firewall_Disable 25
  yum remove postfix -y
  rm -rf /etc/postfix
  systemctl disable postfix.service 2>/dev/null
  yum remove mailx -y
  exit 0
}
# 执行安装或卸载
Execute "$@"