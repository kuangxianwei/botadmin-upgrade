<div class="layui-card">
    <div class="layui-card-body">
        <div class="layui-form table-search" style="left: 260px">
            <button class="layui-hide" lay-submit lay-filter="search">
                <i class="layui-icon layui-icon-search"></i>
            </button>
            <div class="layui-inline">
                <input type="search" name="search" class="layui-input" placeholder="Baiduspider">
            </div>
            <div class="layui-inline">
                <div class="layui-input-inline">
                    <select name="action" lay-filter="search-select" class="layui-select">
                        <option value="">全部</option>
                        <option value="Baiduspider">百度</option>
                        <option value="Googlebot">谷歌</option>
                        <option value="Sogou">搜狗</option>
                        <option value="360Spider">360</option>
                        <option value="Bytespider">头条</option>
                        <option value="bingbot">必应</option>
                        <option value="YisouSpider">神马</option>
                    </select>
                </div>
            </div>
        </div>
        <table id="table-list" lay-filter="table-list"></table>
    </div>
</div>
<script type="text/html" id="toolbar">
    <div class="layui-btn-group">
        <div class="layui-btn-group">
            <button class="layui-btn layui-btn-sm layui-bg-cyan" lay-event="roboter" lay-tips="编辑机器人蜘蛛列表">
                <i class="iconfont icon-spider"></i>
            </button>
            <button class="layui-btn layui-btn-sm layui-btn-primary" lay-href="/robot/chart" lay-text="机器人爬虫" lay-tips="以图表方式查看">
                <i class="layui-icon layui-icon-chart"></i>
            </button>
        </div>
        <div class="layui-btn-group">
            <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="del" lay-tips="删除选中项">
                <i class="layui-icon layui-icon-delete"></i>
            </button>
            <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="truncate">清空</button>
        </div>
    </div>
</script>
<script type="text/html" id="table-toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del">
            <i class="layui-icon layui-icon-delete"></i>
        </button>
    </div>
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let main = layui.main;
        main.table([[
            {type: 'checkbox', fixed: 'left'},
            {field: 'id', title: 'ID', hide: true},
            {field: 'roboter', width: 120, title: '机器人'},
            {field: 'ip', title: 'IP', width: 110, align: 'center'},
            {field: 'visit', title: '访问'},
            {
                field: 'useragent', title: 'UA', hide: true, templet: function (d) {
                    return d['useragent']['value'];
                }
            },
            {
                field: 'updated', width: 150, title: '时间', align: 'center', sort: true, templet: function (d) {
                    return main.timestampFormat(d['updated']);
                }
            },
            {title: '操作', width: 80, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
        ]], {
            roboter: function () {
                main.get(url + '/roboter', function (html) {
                    main.popup({
                        title: "编辑机器人蜘蛛",
                        url: url + '/roboter',
                        content: html,
                        area: ["300px", "500px"]
                    });
                });
            }
        });
    });
</script>