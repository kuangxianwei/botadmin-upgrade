package utils

import (
	"errors"
	"io/ioutil"
	"os"
	"os/exec"
	"path/filepath"
	"time"
)

var (
	mysqlShellHead = []byte(`#!/usr/bin/env bash
# -*- coding: utf-8 -*-
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:/usr/local/mysql/bin
[[ $(id -u) -ne 0 ]] && echo "Error: You must be root to run this script!" 1>&2 && exit 1
if [[ -s /usr/local/mariadb/bin/mysql && -s /usr/local/mariadb/bin/mysqld_safe && -s /etc/my.cnf ]]; then
  DB_Name="mariadb"
  MySQL_Bin="/usr/local/mariadb/bin/mysql"
  MySQL_Ver=$(/usr/local/mariadb/bin/mysql_config --version)
  MySQL_Admin="/usr/local/mariadb/bin/mysqladmin"
elif [[ -s /usr/local/mysql/bin/mysql && -s /usr/local/mysql/bin/mysqld_safe && -s /etc/my.cnf ]]; then
  DB_Name="mysql"
  MySQL_Bin="/usr/local/mysql/bin/mysql"
  MySQL_Admin="/usr/local/mysql/bin/mysqladmin"
  MySQL_Ver=$(/usr/local/mysql/bin/mysql_config --version)
else
  echo "没有安装MySQL" 1>&2
  exit 1
fi
`)
	resetRootPwdCmd = []byte(`
echo "Stoping ${DB_Name}..."
/etc/init.d/${DB_Name} stop
echo "Starting ${DB_Name} with skip grant tables"
/usr/local/${DB_Name}/bin/mysqld_safe --skip-grant-tables >/dev/null 2>&1 &
sleep 5
echo "update ${DB_Name} root password..."
if echo "${MySQL_Ver}" | grep -Eqi '^8.0.|^5.7.|^10.[234].'; then
  /usr/local/${DB_Name}/bin/mysql -u root <<EOF
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_Root_Password}';
EOF
else
  /usr/local/${DB_Name}/bin/mysql -u root <<EOF
update mysql.user set password = Password('${DB_Root_Password}') where User = 'root';
EOF
fi

if [ $? -eq 0 ]; then
  echo "Password reset succesfully. Now killing mysqld softly"
  if Execute -v killall >/dev/null 2>&1; then
    killall mysqld
  else
    kill $(pidof mysqld)
  fi
  sleep 5
  echo "Restarting the actual ${DB_Name} service"
  /etc/init.d/${DB_Name} start
  echo "Password successfully reset to '${DB_Root_Password}'"
else
  echo "Reset ${DB_Name} root password failed!" 1>&2
  exit 1
fi
`)
	newPwdErr = errors.New("数据新密码不可为空")
)

//重置root密码
func ResetRootPwd(newPwd string) (string, error) {
	if newPwd == "" {
		return "", newPwdErr
	}
	shellFile := filepath.Join(TmpDir, ".mysql."+RandomBlend(64))
	for IsFile(shellFile) {
		shellFile = filepath.Join(TmpDir, ".mysql."+RandomBlend(64))
	}
	if err := ioutil.WriteFile(shellFile, append(mysqlShellHead, append([]byte("DB_Root_Password="+newPwd+"\n"), resetRootPwdCmd...)...), 0755); err != nil {
		return "", err
	}
	defer os.Remove(shellFile)
	if err := exec.Command("bash", "-f", shellFile).Start(); err != nil {
		return "", err
	}
	time.Sleep(5 * time.Second)
	return newPwd, nil
}
