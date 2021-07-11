# 检查防火墙
CheckFirewall() {
  if ! systemctl list-units --type=service | grep firewalld.service | grep -v grep; then
    # 设置开机防火墙
    if ! systemctl enable firewalld.service; then
      echo "开机启动防火墙失败" 1>&2
      exit 1
    fi
    # 设置启动防火墙
    if ! systemctl start firewalld; then
      echo "启动防火墙失败" 1>&2
      exit 1
    fi
  fi
}
# 添加端口号
Firewall_Enable() {
  local port="$1"
  if [ -z "$port" ]; then
    echo "输入端口号 例如:8080" 1>&2
    exit 1
  fi
  if ! firewall-cmd --zone=public --list-ports | grep "$port/tcp"; then
    firewall-cmd --zone=public --add-port="$port"/tcp --permanent
  fi
  if ! firewall-cmd --zone=public --list-ports | grep "$port/udp"; then
    firewall-cmd --zone=public --add-port="$port"/udp --permanent
  fi
  firewall-cmd --reload
}
# 禁用端口号
Firewall_Disable() {
  local port="$1"
  if [ -z "$port" ]; then
    echo "输入端口号 例如:8080" 1>&2
    exit 1
  fi
  firewall-cmd --remove-port="$port"/tcp --permanent
  firewall-cmd --remove-port="$port"/udp --permanent
  firewall-cmd --reload
}
