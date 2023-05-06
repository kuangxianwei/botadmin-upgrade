#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# Name:ftp
# Alias:Pure-Ftpd
# Intro:Pure-FTPd是一种快速、生产质量、符合标准的FTP服务器,基于Troll-FTPd
# Args:

# 插件名称
# shellcheck disable=SC2034
PLUGIN_NAME="Pure-Ftpd"
# 当前脚本目录
CUR_DIR=$(dirname "$(readlink -f "$0")")
. "$CUR_DIR/include/init.sh" || exit 1

# 安装
Install() {
  local pureFtpdVer=1.0.49
  if test -e /usr/local/pureftpd/bin/pure-pw; then
    echo "已经安装了过了"
    exit 0
  fi
  # 安装必要的插件
  for packages in make gcc gcc-c++ gcc-g77 openssl openssl-devel bzip2; do yum -y install $packages; done
  if ! cd "$SRC_DIR"; then
    Error "cd 失败"
  fi
  test -d "pure-ftpd-$pureFtpdVer" || rm -rf "pure-ftpd-$pureFtpdVer"
  if [ ! -s "pure-ftpd-$pureFtpdVer.tar.bz2" ]; then
    if ! wget -O "pure-ftpd-$pureFtpdVer.tar.bz2" "https://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-$pureFtpdVer.tar.bz2"; then
      \rm -rf "pure-ftpd-$pureFtpdVer.tar.bz2"
      Error "下载pure-ftpd失败"
    fi
  fi
  if ! tar -jxvf "pure-ftpd-$pureFtpdVer.tar.bz2"; then
    \rm -rf "pure-ftpd-$pureFtpdVer.tar.bz2"
    Error "解压 pure-ftpd-$pureFtpdVer.tar.bz2 失败"
  fi
  if ! cd "pure-ftpd-$pureFtpdVer"; then
    Error "cd 失败"
  fi
  ./configure --prefix=/usr/local/pureftpd CFLAGS=-O2 --with-puredb --with-quotas --with-cookie --with-virtualhosts --with-diraliases --with-sysquotas --with-ratios --with-altlog --with-paranoidmsg --with-shadow --with-welcomemsg --with-throttling --with-uploadscript --with-language=english --with-rfc2640 --with-ftpwho --with-tls
  Make_Install
  mkdir /usr/local/pureftpd/etc
  if ! \cp "${CUR_DIR}/conf/pure-ftpd.conf" /usr/local/pureftpd/etc/pure-ftpd.conf; then
    Error "复制失败"
  fi
  if [ -L /etc/init.d/pureftpd ]; then
    rm -f /etc/init.d/pureftpd
  fi
  if ! \cp "${CUR_DIR}/init.d/init.d.pureftpd" /etc/init.d/pureftpd; then
    Error "复制失败"
  fi
  if ! \cp "${CUR_DIR}/init.d/pureftpd.service" /etc/systemd/system/pureftpd.service; then
    Error "复制失败"
  fi
  if ! chmod +x /etc/init.d/pureftpd; then
    Error "/etc/init.d/pureftpd 添加执行权限失败"
  fi
  touch /usr/local/pureftpd/etc/pureftpd.passwd
  touch /usr/local/pureftpd/etc/pureftpd.pdb
  StartUp pureftpd
  if ! cd "$SRC_DIR"; then
    Error "cd 失败"
  fi
  rm -rf "pure-ftpd-$pureFtpdVer"

  # 开启端口
  Firewall_Enable 20000-30000/tcp 20/tcp 21/tcp

  if ! id -u www; then
    groupadd www
    useradd -s /sbin/nologin -g www www
  fi

  if [[ -s /usr/local/pureftpd/sbin/pure-ftpd && -s /usr/local/pureftpd/etc/pure-ftpd.conf && -s /etc/init.d/pureftpd ]]; then
    systemctl start pureftpd
    # /etc/init.d/pureftpd start
  else
    Error "Pure-Ftpd install failed!"
  fi
}
# 卸载
Uninstall() {
  if [ ! -f /usr/local/pureftpd/sbin/pure-ftpd ]; then
    Error "Pure-Ftpd was not installed!"
  fi
  echo "Stop Pure-Ftpd..."
  /etc/init.d/pureftpd stop
  echo "Remove service..."
  Remove_StartUp pureftpd
  echo "Delete files..."
  rm -f /etc/init.d/pureftpd
  rm -rf /usr/local/pureftpd
  echo "Pure-Ftpd uninstall completed."
  Firewall_Disable 20000-30000 20 21
}

# 执行安装或卸载
Execute "$@"
