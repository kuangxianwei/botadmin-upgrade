# ${RootPath} 是当前目录
echo "开始删除 ${RootPath}/data/template" | tee "${LogFile}"
rm -rf "${RootPath}/data/template"
