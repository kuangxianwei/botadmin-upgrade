#!/usr/bin/env bash
# 这是升级APP后做一些收尾工作 例如测试 修改权限
# ${RootPath} APP程序根目录
# 记录初始路径
protoPath=$(pwd)
#转到APP程序根目录
# shellcheck disable=SC2154
cd "${RootPath}" || exit 1
# 逻辑代码开始
rm -rf before.sh after.sh
# 逻辑代码结束
cd "$protoPath" || exit 1