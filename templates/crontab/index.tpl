<div class="layui-card">
    <div class="layui-card-body">
        <div class="table-search" style="left:145px">
            <div class="layui-inline layui-form">
                <div class="layui-inline">
                    <div class="layui-input-inline">
                        <input type="search" name="search" placeholder="搜索唯一码" value="{{.search}}" class="layui-input">
                    </div>
                </div>
                <button class="layui-btn layui-btn-sm" lay-submit lay-filter="search">
                    <i class="layui-icon layui-icon-search"></i>
                </button>
            </div>
        </div>
        <table id="table-crontab" lay-filter="table-crontab"></table>
    </div>
</div>
<script type="text/html" id="toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del">
            <i class="layui-icon layui-icon-delete"></i></button>
    </div>
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let main = layui.main;
        main.table('table-crontab',
            {
                url: URL + "?search=" + $('input[name=search]').val(),
                cols: [[
                    {type: 'checkbox', fixed: 'left'},
                    {field: 'entry_id', width: 80, title: 'ID', align: 'center', sort: true},
                    {field: 'token', title: '唯一码'},
                    {field: 'spec', title: '规则', align: 'center', width: 200},
                    {field: 'work_pointer', title: '任务地址', align: 'center', width: 120},
                    {title: '操作', width: 120, align: 'center', fixed: 'right', toolbar: '#toolbar'}
                ]],
            },
            {
                del: function (obj, ids) {
                    if (main.isArray(ids)) {
                        if (ids.length === 0) {
                            return layer.msg('请选择数据');
                        }
                        layer.confirm('确定移除定时任务？', function (index) {
                            let tokens = [];
                            for (let i = 0; i < obj.data.length; i++) {
                                tokens[i] = obj.data[i].token;
                            }
                            main.request({
                                url: URL + '/del',
                                data: {tokens: tokens.join()},
                                index: index,
                                done: 'table-crontab'
                            });
                        });
                        return
                    }
                    layer.confirm('确定移除定时任务？', function (index) {
                        main.request({
                            url: URL + '/del',
                            data: {tokens: obj.data.token},
                            index: index,
                            done: 'table-crontab'
                        });
                    });
                }
            });
    });
</script>