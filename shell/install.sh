#!/usr/bin/env bash
# -*- coding: utf-8 -*-
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:/usr/local/mysql/bin
export PATH
[[ $(id -u) -ne 0 ]] && echo "Error: You must be root to run this script!" 1>&2 && exit 1
APP_DIR=/data/botadmin
APP=$APP_DIR/botadmin
test -d /data || mkdir /data
pushd /data || exit 1

#下载程序#
Download_botadmin() {
  test -d botadmin || {
    if [ ! -f botadmin-master.zip ]; then
      wget -cO botadmin-master.zip https://github.com/kuangxianwei/botadmin/archive/master.zip || exit 1
    fi
    command -v unzip || {
      yum -y install unzip || exit 1
    }
    unzip -o botadmin-master.zip || {
      rm -f botadmin.zip
      exit 1
    }
    mv botadmin-master botadmin || exit 1
    rm -f botadmin.zip
  }
}

#写入脚本#
Write_botadmin() {
  #开机启动本程序#
  cat >"/etc/systemd/system/botadmin.service" <<EOF
[Unit]
Description=botadmin
After=network.target remote-fs.target nss-lookup.target mysql.service

[Service]
Type=forking
ExecStart=$APP fork
ExecStop=$APP stop
ExecReload=$APP restart
Restart=no
PrivateTmp=false

[Install]
WantedBy=multi-user.target
EOF
  [ $? -eq 0 ] || exit 1
  chmod 644 /etc/systemd/system/botadmin.service
  test -d "${APP_DIR}/data" || mkdir -p "${APP_DIR}/data"
  cat >"${APP_DIR}/data/.my.cnf" <<EOF
[client]
password=botadmin.cn
port=3306
socket=/tmp/mysql.sock
EOF
  [ $? -eq 0 ] || exit 1
}

#下载解压程序#
Download_botadmin
#写入脚本#
Write_botadmin
#赋权限#
pushd "$APP_DIR" || exit 1
chmod +x -R ./botadmin ./shell/* || exit 1
command -v bzip2 || {
  yum -y install bzip2 || exit 1
}
isEnabledBotadmin=$(systemctl is-enabled botadmin)
test "$isEnabledBotadmin" = "disabled" && systemctl enable botadmin.service
#进入安装 军哥的lnmp#
pushd "${APP_DIR}/shell/lnmp/src" || exit 1
test -d ./ngx_http_substitutions_filter_module && rm -rf ./ngx_http_substitutions_filter_module
test -d ./ngx_cache_purge-2.3 && rm -rf ./ngx_cache_purge-2.3
tar -jxvf ./ngx_http_substitutions_filter_module.tar.bz2 || exit 1
tar -jxvf ./ngx_cache_purge-2.3.tar.bz2 || exit 1
pushd "${APP_DIR}/shell/lnmp" || exit 1
#lnmp 配置
cat>"${APP_DIR}/shell/lnmp/lnmp.conf"<<EOF
Download_Mirror='https://soft.vpser.net'
Nginx_Modules_Options='--add-module=${APP_DIR}/shell/lnmp/src/ngx_http_substitutions_filter_module --add-module=${APP_DIR}/shell/lnmp/src/ngx_cache_purge-2.3'
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
#开始安装lnmp
LNMP_Auto="y" DBSelect="4" DB_Root_Password="botadmin.cn" InstallInnodb="y" PHPSelect="5" SelectMalloc="2" CheckMirror="n" ./install.sh lnmp
