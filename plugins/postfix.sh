#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# Name:postfix
# Alias:邮件服务器
# Intro:Postfix 由源代码构建，可以在类 UNIX 系统上运行，包括 AIX、BSD、HP-UX、Linux、MacOS X、Solaris 等,官网:http://www.postfix.org/

export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
[[ $(id -u) -ne 0 ]] && echo "Error: You must be root to run this script!" 1>&2 && exit 1
currentDir=$(dirname "$0")
. "$currentDir/init.sh" || exit 1

mailHostname="$2"
# 安装
Install() {
  Check_Firewall
  Firewall_Enable 25
  # 安装mail 服务器 postfix
  if ! command -v postfix; then
    if ! yum install postfix -y; then
      echo "安装postfix失败" 1>&2
      exit 1
    fi
  fi
  if [ -n "$mailHostname" ]; then
    if ! sed -r -i \
      -e "s/^#?myhostname\s*=\s*.*?$/myhostname = $mailHostname/" \
      -e "s/^#?mydomain\s*=\s*.*?$/mydomain = ${mailHostname#*.}/" \
      -e "s/^#myorigin\s*=\s*\\\$myhostname\s*$/myorigin = \$myhostname/" \
      -e "s/^mydestination\s*=\s*\\\$myhostname,\s*localhost.\\\$mydomain,\s*localhost.*$/mydestination = \$myhostname, localhost.\$mydomain, localhost, $mailHostname/" \
      -e "s/^#relay_domains\s*=\s*\\\$mydestination\s*$/relay_domains = \$mydestination/" \
      /etc/postfix/main.cf; then
      echo "/etc/postfix/main.cf 替换失败" 1>&2
      exit 1
    fi
  fi

  # 设置开机
  if ! systemctl enable postfix.service; then
    echo "设置开机启动postfix失败" 1>&2
    exit 1
  fi

  # 设置启动
  if ! systemctl start postfix; then
    echo "启动postfix失败" 1>&2
    exit 1
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

case "$1" in
"install")
  echo "开始安装postfix"
  Install
  ;;
"uninstall")
  echo "开始卸载postfix"
  Uninstall
  ;;
*)
  echo "{install|uninstall} 例如:install mail.nfivf.com"
  ;;
esac
