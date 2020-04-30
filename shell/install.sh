#!/usr/bin/env bash
# -*- coding: utf-8 -*-
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:/usr/local/mysql/bin
export PATH
[[ $(id -u) -ne 0 ]] && echo "Error: You must be root to run this script!" 1>&2 && exit 1
test -d /data || mkdir /data
pushd /data || exit 1
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
}
pushd /data/botadmin || exit 1
chmod +x -R ./shell/*
chmod +x ./botadmin || exit 1
test -d /data/botadmin/data || mkdir -p /data/botadmin/data
cat >"/data/botadmin/data/.my.cnf" <<EOF
[client]
password=botadmin.cn
port=3306
socket=/tmp/mysql.sock
EOF
pushd /data/botadmin/shell/lnmp/src || exit 1
test -d ./ngx_http_substitutions_filter_module && rm -rf ./ngx_http_substitutions_filter_module
tar -xjf ngx_http_substitutions_filter_module.tar.bz2 || exit 1
pushd /data/botadmin/shell/lnmp || exit 1
LNMP_Auto="y" DBSelect="4" DB_Root_Password="botadmin.cn" InstallInnodb="y" PHPSelect="5" SelectMalloc="2" CheckMirror="n" ./install.sh lnmp
