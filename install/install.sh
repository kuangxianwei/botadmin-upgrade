#!/usr/bin/env bash
# -*- coding: utf-8 -*-
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:/usr/local/mysql/bin
[[ $(id -u) -ne 0 ]] && echo "Error: You must be root to run this script!" 1>&2 && exit 1

# 默认NGINX启用 第三方过滤替换模块 ngx_filter=off 为不启用
NgxFilter=on

# 默认下载镜像源
Mirror="https://github.com/kuangxianwei/botadmin/archive/master.zip"

# app 名称
AppName="botadmin"

# app 安装目录
AppDir="/data/$AppName"

# app 程序完整路径
App="$AppDir/$AppName"

# 进入到安装目录
test -d /data || mkdir /data
pushd /data || exit 1

# 设置参数
Set_Params() {
  # 参数 mirror=cn 则下载国内的镜像
  # 直接指定 mirror=https://github.com/kuangxianwei/botadmin/archive/master.zip
  # 默认是Github下载
  for param in "$@"; do
    if [[ "$param" =~ ^mirror= ]]; then
      case "${param#*=}" in
      [cC][nN])
        Mirror="http://download.botadmin.cn/master.zip"
        ;;
      http://* | https://*)
        Mirror="${param#*=}"
        ;;
      esac
    elif [[ "$param" =~ ^ngx_filter= ]]; then
      NgxFilter="${param#*=}"
    fi
  done
}
Set_Params "$@"

# 添加chromium 安装缺失的依赖库
Install_Chromium() {
  echo "添加chromium 安装缺失的依赖库"
  if ! yum install -y \
    alsa-lib.x86_64 \
    atk.x86_64 \
    cups-libs.x86_64 \
    GConf2.x86_64 \
    gtk3.x86_64 \
    ipa-gothic-fonts \
    libXcomposite.x86_64 \
    libXcursor.x86_64 \
    libXdamage.x86_64 \
    libXext.x86_64 \
    libXi.x86_64 \
    libXrandr.x86_64 \
    libXScrnSaver.x86_64 \
    libXtst.x86_64 \
    pango.x86_64 \
    wqy-unibit-fonts.noarch \
    wqy-zenhei-fonts.noarch \
    xorg-x11-fonts-100dpi \
    xorg-x11-fonts-75dpi \
    xorg-x11-fonts-cyrillic \
    xorg-x11-fonts-misc \
    xorg-x11-fonts-Type1 \
    xorg-x11-utils; then
    echo "安装chromium缺失的依赖库失败" 1>&2
    return 1
  fi
}

# 下载程序
Download_Botadmin() {
  if test ! -d botadmin; then
    if test ! -f botadmin-master.zip; then
      \rm -rf botadmin-master.zip
      if ! wget -cO botadmin-master.zip "$Mirror"; then
        echo "下载失败" 2>&1
        \rm -rf botadmin-master.zip
        exit 1
      fi
    fi
    if ! command -v unzip; then
      yum -y install unzip || exit 1
    fi
    if ! unzip -o botadmin-master.zip; then
      \rm -rf botadmin-master.zip
      exit 1
    fi
    \mv botadmin-master botadmin || exit 1
    \rm -rf botadmin-master.zip
  fi
}

# 写入开机启动
Write_botadmin_init() {
  # 写入init.d 开机启动本程序
  cat >"/etc/init.d/$AppName" <<EOF
#!/bin/bash
#
# $AppName - this script starts and stops the $AppName daemon
#
# chkconfig:   - 85 15
# description: BotAdmin system
# processname: $AppName
# Url http://www.botadmin.cn
# Last Updated 2020.06.01

# Source function library.
. /etc/rc.d/init.d/functions

# Source networking configuration.
. /etc/sysconfig/network

# Check that networking is up.
[ "\$NETWORKING" = "no" ] && exit 0

# 锁文件
lockfile="/var/lock/subsys/${AppName}"
prog=$AppName
cd $AppDir || exit 0

start() {
  echo -n "Starting \$prog: "
  $App &
  echo_success
  retval=\$?
  echo
  [ \$retval -eq 0 ] && touch \$lockfile
  return \$retval
}
stop() {
  echo -n "Stopping \$prog: "
  killproc "\$AppName" >/dev/null 2>&1
  echo_success
  retval=\$?
  echo
  [ \$retval -eq 0 ] && rm -f \$lockfile
  return \$retval
}

restart() {
  stop
  start
}

uninstall() {
  stop
  rm -fr $AppDir
  rm -f /etc/rc.d/init.d/${AppName}
}

rh_status() {
  status \$prog
}

rh_status_q() {
  rh_status >/dev/null 2>&1
}

case "\$1" in
start)
  rh_status_q && exit 0
  \$1
  ;;
stop)
  rh_status_q || exit 0
  \$1
  ;;
restart)
  \$1
  ;;
status)
  rh_status
  ;;
uninstall)
  \$1
  ;;
*)
  echo \$"Usage: \$0 {start|stop|status|restart}"
  exit 2
  ;;
esac
EOF
  chmod +x "/etc/init.d/$AppName"
  test -d "${AppDir}/data" || mkdir -p "${AppDir}/data"
   # systemctl服务
   cat >"/etc/systemd/system/$AppName.service"<<EOF
[Unit]
Description=$AppName Server
After=mysql.service

[Service]
Type=forking
ExecStart=/etc/init.d/$AppName start
ExecStop=/etc/init.d/$AppName stop
ExecReload=/etc/init.d/$AppName restart
Restart=no
PrivateTmp=false

[Install]
WantedBy=multi-user.target
EOF
  # 写入Mysql数据库 配置信息
  cat >"${AppDir}/data/.my.cnf" <<EOF
[client]
password=botadmin.cn
port=3306
socket=/tmp/mysql.sock
EOF
}

# 添加chromium 安装缺失的依赖库
Install_Chromium

# 下载解压程序
Download_Botadmin

#写入脚本#
Write_botadmin_init

#赋权限#
pushd "$AppDir" || exit 1
chmod +x -R ./$AppName ./install/* || exit 1
test -d ./data/contact || mkdir -p ./data/contact
chmod -R 0755 ./data
echo "open_basedir=${AppDir}/data/contact:/tmp/:/proc/" >./data/contact/.user.ini
command -v bzip2 || {
  yum -y install bzip2 || exit 1
}
isEnabledBotadmin=$(systemctl is-enabled $AppName)
test "$isEnabledBotadmin" = "disabled" && systemctl enable $AppName.service

#进入安装 军哥的lnmp#
pushd "${AppDir}/install/lnmp/src" || exit 1
test -d ./ngx_http_substitutions_filter_module && rm -rf ./ngx_http_substitutions_filter_module
test -d ./ngx_cache_purge-2.3 && rm -rf ./ngx_cache_purge-2.3
tar -jxvf ./ngx_http_substitutions_filter_module.tar.bz2 || exit 1
tar -jxvf ./ngx_cache_purge-2.3.tar.bz2 || exit 1
pushd "${AppDir}/install/lnmp" || exit 1

# NGINX 添加模块#
if [ "$NgxFilter" = "on" ]; then
  #lnmp 配置
  cat >"${AppDir}/install/lnmp/lnmp.conf" <<EOF
Download_Mirror='https://soft.vpser.net'
Nginx_Modules_Options='--add-module=${AppDir}/install/lnmp/src/ngx_http_substitutions_filter_module --add-module=${AppDir}/install/lnmp/src/ngx_cache_purge-2.3'
PHP_Modules_Options=''
##MySQL/MariaDB database directory##
MySQL_Data_Dir='/usr/local/mysql/var'
MariaDB_Data_Dir='/usr/local/mariadb/var'
##Default website home directory##
Default_Website_Dir='/home/wwwroot/default'
Enable_Nginx_Openssl='y'
Enable_PHP_Fileinfo='n'
Enable_Nginx_Lua='n'
Enable_Swap='y'
EOF
fi

#开始安装lnmp
LNMP_Auto="y" DBSelect="2" DB_Root_Password="botadmin.cn" InstallInnodb="y" PHPSelect="5" SelectMalloc="2" CheckMirror="n" ./install.sh lnmp
