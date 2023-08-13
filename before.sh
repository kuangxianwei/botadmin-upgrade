#!/usr/bin/env bash
# 这是升级APP前做一些预备工作 例如删除某些文件
# ${RootPath} APP程序根目录
# 记录初始路径
protoPath=$(pwd)
#转到APP程序根目录
# shellcheck disable=SC2154
cd "${RootPath}" || exit 1
# 逻辑代码开始
echo "进入：${RootPath}/data/db"
cd ./data/db || exit 1
if [ ! -f "./data/db/useragent.db" ]; then
  rm -rf "${RootPath}/data/db/client.db"
  sqlite3 ./contact.db <<EOF
  .DROP TABLE feedback;
  .quit
EOF
fi
#sqlite3 ./site.db <<EOF
#.dump a.sql
#.quit
#EOF

# 逻辑代码结束
cd "$protoPath" || exit 1