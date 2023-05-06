# 错误退出
Error() {
  test -n "$1" && echo "Error: $1" 1>&2
  test -n "$2" && \rm -rf "${@:2}"
  exit 1
}
# 初始化
init() {
  export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
  # 必须root权限运行
  if [ "$(id -u)" -ne 0 ]; then
    Error "You must be root to run this script!"
  fi
  # 资源存放目录
  SRC_DIR=$CUR_DIR/src
  test -d "$SRC_DIR" || mkdir "$SRC_DIR"
  if [ "$(pgrep -fc "$(basename "$0")")" -gt 2 ]; then
    Error "$PLUGIN_NAME 正在执行安装或卸载"
  fi
}
#安装开机启动服务#
StartUp() {
  local app=$1
  echo "Add ${app} service at system startup..."
  if command -v systemctl >/dev/null 2>&1 && [[ -s /etc/systemd/system/${app}.service || -s /lib/systemd/system/${app}.service || -s /usr/lib/systemd/system/${app}.service ]]; then
    systemctl enable "${app}.service"
  else
    if [ "$PM" = "yum" ]; then
      chkconfig --add "${app}"
      chkconfig "${app}" on
    elif [ "$PM" = "apt" ]; then
      update-rc.d -f "${app}" defaults
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
  local app=$1
  echo "Removing ${app} service at system startup..."
  if command -v systemctl >/dev/null 2>&1 && [[ -s /etc/systemd/system/${app}.service || -s /lib/systemd/system/${app}.service || -s /usr/lib/systemd/system/${app}.service ]]; then
    systemctl disable "${app}.service"
  else
    if [ "$PM" = "yum" ]; then
      chkconfig "${app}" off
      chkconfig --del "${app}"
    elif [ "$PM" = "apt" ]; then
      update-rc.d -f "${app}" remove
    fi
  fi
}
# 检查防火墙
Check_Firewall() {
  if ! systemctl list-units --type=service | grep firewalld.service | grep -v grep; then
    # 设置开机防火墙
    if ! systemctl enable firewalld.service; then
      Error "开机启动防火墙失败"
    fi
    # 设置启动防火墙
    if ! systemctl start firewalld; then
      Error "启动防火墙失败"
    fi
  fi
}
# 添加端口号
Firewall_Enable() {
  Check_Firewall
  for port in "$@"; do
    if ! firewall-cmd --zone=public --list-ports | grep -q "$port"; then
      firewall-cmd --zone=public --add-port="$port" --permanent
    fi
  done
  firewall-cmd --reload
}
# 禁用端口号
Firewall_Disable() {
  for port in "$@"; do
    if firewall-cmd --zone=public --list-ports | grep -q "$port/tcp"; then
      firewall-cmd --remove-port="$port/tcp" --permanent
    fi
    if firewall-cmd --zone=public --list-ports | grep -q "$port/udp"; then
      firewall-cmd --remove-port="$port/udp" --permanent
    fi
  done
  firewall-cmd --reload
}
# 执行安装或卸载
Execute() {
  case "$1" in
  "install")
    echo "开始安装 $PLUGIN_NAME"
    Install "${@:2}"
    ;;
  "uninstall")
    echo "开始卸载 $PLUGIN_NAME"
    Uninstall "${@:2}"
    ;;
  *)
    Error "{install|uninstall} 例如:install"
    ;;
  esac
}
init "$@"