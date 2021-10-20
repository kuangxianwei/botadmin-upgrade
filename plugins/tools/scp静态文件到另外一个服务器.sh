#!/usr/bin/env bash
if test -z "$1"; then
  echo "必须输入路径" 1>&2
  exit 1
fi
remote="154.85.57.152" #远程服务器host

if [ "${1::1}" = "/" ]; then
  publicDir="$1"
else
  publicDir="/home/wwwroot/$1/public_html" # 网站根目录
fi

if ! cd "$publicDir"; then
  echo "目录不存在" 1>&2
  exit 1
fi
arr=()
# shellcheck disable=SC2045
for dir in $(ls); do
  if [[ -d "$dir" && "$dir" != "d" && "$dir" != "e" && "$dir" != "ecachefiles" && "$dir" != "errpage" && "$dir" != "html" && "$dir" != "images" && "$dir" != "s" && "$dir" != "t" && "$dir" != "skin" && "$dir" != "search" && "$dir" != "testdata" ]]; then
    arr+=("$dir")
  fi
done
if [ ${#arr[@]} -eq 0 ]; then
  echo "没有需要打包的文件夹" 1>&2
  exit 1
fi
echo "开始压缩"
rm -rf web.tar.gz
if ! tar -zcvf web.tar.gz "${arr[@]}"; then
  echo "压缩失败" 1>&2
  exit 1
fi

scp -prq web.tar.gz root@$remote:"$publicDir/web.tar.gz"

# ps -ef | grep -v grep | grep "scp.sh"
