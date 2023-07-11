<div class="layui-card">
    <div class="layui-card-body">
        <div class="layui-form table-search" style="left: 400px">
            <div class="layui-inline">
                <input type="search"  name="value" class="layui-input" placeholder="输入搜索...">
            </div>
            <button class="layui-btn layui-btn-sm" lay-submit lay-filter="search">
                <i class="layui-icon layui-icon-search"></i>
            </button>
        </div>
        <table id="table-list" lay-filter="table-list"></table>
    </div>
</div>
<script type="text/html" id="toolbar">
    <div class="layui-btn-group">
        <a class="layui-btn layui-btn-sm" lay-href="/tags/collect" lay-text="定时采集Tags">
            <i class="layui-icon layui-icon-add-circle"></i>采集
        </a>
        <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="add" lay-tips="手工添加Tags">
            <i class="layui-icon layui-icon-add-circle"></i>手工
        </button>
    </div>
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm" lay-event="export" lay-tips="导出Tags">
            <i class="layui-icon iconfont icon-export"></i>
        </button>
        <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="import" lay-tips="导入Tags">
            <i class="layui-icon iconfont icon-import"></i>
        </button>
    </div>
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="del" lay-tips="删除选中项">
            <i class="layui-icon layui-icon-delete"></i>
        </button>
        <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="truncate">清空</button>
        <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="log" lay-tips="查看日志">
            <i class="layui-icon layui-icon-log"></i>
        </button>
    </div>
</script>
<script type="text/html" id="table-toolbar">
    <a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del"><i
                class="layui-icon layui-icon-delete"></i>删除</a>
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let main = layui.main;
        main.upload();
        main.table([[
            {type: 'checkbox', fixed: 'left'},
            {field: 'id', hide: true},
            {type: 'numbers', width: 80, title: 'ID', sort: true},
            {field: 'value', title: 'Tag'},
            {
                field: 'updated', title: '时间', width: 150, sort: true, templet: function (d) {
                    return main.timestampFormat(d['updated']);
                }
            },
            {title: '操作', width: 150, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
        ]], {
            add: function () {
                main.popup({
                    title: '添加Tags',
                    url: url + '/add',
                    content: '<div class="layui-card layui-form" style="height: 98%">' +
                        '<textarea class="layui-textarea" name="values" style="height: 100%" placeholder="输入关键词一行一个"></textarea>' +
                        '<button class="layui-hide" lay-submit lay-filter="submit"></button>' +
                        '</div>',
                    done: 'table-list'
                });
            }
        });
    });
</script>