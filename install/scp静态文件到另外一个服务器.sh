#!/usr/bin/env bash
publicDir="$1" # 网站根目录
if test -z "$publicDir"; then
  echo "参数不正确" 1>&2
  exit 1
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

scp -prq web.tar.gz root@154.85.57.152:"$publicDir/web.tar.gz"
