export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:/usr/local/mysql/bin
[[ $(id -u) -ne 0 ]] && echo "Error: You must be root to run this script!" 1>&2 && exit 1
#安装服务#
StartUp() {
  init_name=$1
  echo "Add ${init_name} service at system startup..."
  if command -v systemctl >/dev/null 2>&1 && [[ -s /etc/systemd/system/${init_name}.service || -s /lib/systemd/system/${init_name}.service || -s /usr/lib/systemd/system/${init_name}.service ]]; then
    systemctl enable "${init_name}.service"
  else
    if [ "$PM" = "yum" ]; then
      chkconfig --add "${init_name}"
      chkconfig "${init_name}" on
    elif [ "$PM" = "apt" ]; then
      update-rc.d -f "${init_name}" defaults
    fi
  fi
}
#编译安装#
Make_Install() {
  if ! make -j "$(grep -c 'processor' /proc/cpuinfo)"; then
    make
  fi
  make install
}
#移除服务
Remove_StartUp() {
  init_name=$1
  echo "Removing ${init_name} service at system startup..."
  if command -v systemctl >/dev/null 2>&1 && [[ -s /etc/systemd/system/${init_name}.service || -s /lib/systemd/system/${init_name}.service || -s /usr/lib/systemd/system/${init_name}.service ]]; then
    systemctl disable "${init_name}.service"
  else
    if [ "$PM" = "yum" ]; then
      chkconfig "${init_name}" off
      chkconfig --del "${init_name}"
    elif [ "$PM" = "apt" ]; then
      update-rc.d -f "${init_name}" remove
    fi
  fi
}
