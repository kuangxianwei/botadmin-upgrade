#!/bin/sh
#
# botadmin - this script starts and stops the botadmin daemon
#
# chkconfig:   - 85 15
# description: BotAdmin system
# processname: botadmin
# Url http://www.botadmin.cn
# Last Updated 2020.06.01

# Source function library.
. /etc/rc.d/init.d/functions

# Source networking configuration.
. /etc/sysconfig/network

# Check that networking is up.
[ "$NETWORKING" = "no" ] && exit 0
# 程序名称
appName="botadmin"
# 程序目录
appDir="/data/botadmin"
# 程序路径
appPath="${appDir}/${appName}"
# 锁文件
lockfile="/var/lock/subsys/${appName}"
prog=$appName
cd $appDir || exit 0

start() {
  echo -n $"Starting $prog: "
  $appPath &
  echo_success
  retval=$?
  echo
  [ $retval -eq 0 ] && touch $lockfile
  return $retval
}
stop() {
  echo -n $"Stopping $prog: "
  killproc "$appName" >/dev/null 2>&1
  echo_success
  retval=$?
  echo
  [ $retval -eq 0 ] && rm -f $lockfile
  return $retval
}

restart() {
  stop
  start
}

uninstall() {
  stop
  rm -fr $appDir
  rm -f /etc/rc.d/init.d/${appName}
}

rh_status() {
  status $prog
}

rh_status_q() {
  rh_status >/dev/null 2>&1
}

case "$1" in
start)
  rh_status_q && exit 0
  $1
  ;;
stop)
  rh_status_q || exit 0
  $1
  ;;
restart)
  $1
  ;;
status)
  rh_status
  ;;
uninstall)
  $1
  ;;
*)
  echo $"Usage: $0 {start|stop|status|restart}"
  exit 2
  ;;
esac
