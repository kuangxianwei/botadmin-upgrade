#!/usr/bin/env bash
# -*- coding: utf-8 -*-
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:/usr/local/mysql/bin
[[ $(id -u) -ne 0 ]] && echo "Error: You must be root to run this script!" 1>&2 && exit 1
CUR_DIR=$(dirname "$(readlink -f "$0")")
# shellcheck disable=SC2164
pushd "$CUR_DIR" >/dev/null
. ./utils.sh || exit 1
test -d "${CUR_DIR}/src" || mkdir "${CUR_DIR}/src"
pureFtpdVer=1.0.49
#安装
Install_PureFtpd() {
  test -e /usr/local/pureftpd/bin/pure-pw && {
    echo "已经安装了过了" 1>&2
    exit 1
  }
  # shellcheck disable=SC2009
  count=$(ps -ef | grep -v grep | grep -Eic '\bpureftpd.sh\s+install\b')
  if [ "${count}" -gt 3 ]; then
    echo "正在安装中..." 1>&2
    exit 1
  fi
  for packages in make gcc gcc-c++ gcc-g77 openssl openssl-devel bzip2; do yum -y install $packages; done
  # shellcheck disable=SC2164
  pushd "${CUR_DIR}/src" >/dev/null
  test -d "pure-ftpd-${pureFtpdVer}" || rm -rf "pure-ftpd-${pureFtpdVer}"
  if [ ! -s "pure-ftpd-${pureFtpdVer}.tar.bz2" ]; then
    wget -O "pure-ftpd-${pureFtpdVer}.tar.bz2" "https://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-${pureFtpdVer}.tar.bz2" || exit 1
  fi
  tar -jxvf "pure-ftpd-${pureFtpdVer}.tar.bz2" || exit 1
  # shellcheck disable=SC2164
  pushd "${CUR_DIR}/src/pure-ftpd-${pureFtpdVer}" >/dev/null
  ./configure --prefix=/usr/local/pureftpd CFLAGS=-O2 --with-puredb --with-quotas --with-cookie --with-virtualhosts --with-diraliases --with-sysquotas --with-ratios --with-altlog --with-paranoidmsg --with-shadow --with-welcomemsg --with-throttling --with-uploadscript --with-language=english --with-rfc2640 --with-ftpwho --with-tls
  Make_Install
  mkdir /usr/local/pureftpd/etc
  \cp "${CUR_DIR}/conf/pure-ftpd.conf" /usr/local/pureftpd/etc/pure-ftpd.conf
  if [ -L /etc/init.d/pureftpd ]; then
    rm -f /etc/init.d/pureftpd
  fi
  \cp "${CUR_DIR}/init.d/init.d.pureftpd" /etc/init.d/pureftpd
  \cp "${CUR_DIR}/init.d/pureftpd.service" /etc/systemd/system/pureftpd.service
  chmod +x /etc/init.d/pureftpd
  touch /usr/local/pureftpd/etc/pureftpd.passwd
  touch /usr/local/pureftpd/etc/pureftpd.pdb
  StartUp pureftpd
  # shellcheck disable=SC2164
  popd >/dev/null
  test -d "pure-ftpd-${pureFtpdVer}" || rm -rf "pure-ftpd-${pureFtpdVer}"
  if command -v systemctl >/dev/null 2>&1; then
    systemctl unmask firewalld.service
    firewall-cmd --zone=public --add-port=20000-30000/tcp --permanent
    firewall-cmd --zone=public --add-port=20/tcp --permanent
    firewall-cmd --zone=public --add-port=21/tcp --permanent
    firewall-cmd --zone=public --add-port=8080/tcp --permanent
    firewall-cmd --reload
    systemctl restart firewalld.service
  elif command -v iptables >/dev/null 2>&1; then
    if [ -s /bin/lnmp ]; then
      iptables -I INPUT 7 -p tcp --dport 20 -j ACCEPT
      iptables -I INPUT 8 -p tcp --dport 21 -j ACCEPT
      iptables -I INPUT 9 -p tcp --dport 20000:30000 -j ACCEPT
    else
      iptables -I INPUT -p tcp --dport 20 -j ACCEPT
      iptables -I INPUT -p tcp --dport 21 -j ACCEPT
      iptables -I INPUT -p tcp --dport 20000:30000 -j ACCEPT
    fi
    service iptables save
    service iptables reload
  fi
  if ! id -u www; then
    groupadd www
    useradd -s /sbin/nologin -g www www
  fi

  if [[ -s /usr/local/pureftpd/sbin/pure-ftpd && -s /usr/local/pureftpd/etc/pure-ftpd.conf && -s /etc/init.d/pureftpd ]]; then
    /etc/init.d/pureftpd start
  else
    echo "Pureftpd install failed!" 1>&2
    exit 1
  fi
}

Uninstall_Pureftpd() {
  if [ ! -f /usr/local/pureftpd/sbin/pure-ftpd ]; then
    echo "Pureftpd was not installed!" 2>&1
    exit 1
  fi
  echo "Stop pureftpd..."
  /etc/init.d/pureftpd stop
  echo "Remove service..."
  Remove_StartUp pureftpd
  echo "Delete files..."
  rm -f /etc/init.d/pureftpd
  rm -rf /usr/local/pureftpd
  echo "Pureftpd uninstall completed."
}

case "$1" in
install)
  Install_PureFtpd 2>&1 | tee install_pureftpd.log
  exit $?
  ;;
uninstall)
  Uninstall_Pureftpd 2>&1 | tee uninstall_pureftpd.log
  ;;
*)
  echo "参数错误" 1>&2
  exit 1
  ;;
esac
