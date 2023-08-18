<div class="layui-card">
    <div class="layui-card-body">
        <div class="layui-form table-search" style="left: 260px">
            <button class="layui-hide" lay-submit lay-filter="search">
                <i class="layui-icon layui-icon-search"></i>
            </button>
            <div class="layui-inline">
                <div class="layui-input-inline">
                    <select name="waiter_id" lay-filter="search-select" class="layui-select">
                        <option value="">选择全部客服</option>
                        {{range $i,$v:=.waiters -}}
                            <option value="{{$v.Id}}"{{if eq $v.Id $.selected}} selected{{end}}>{{$v.Alias}}</option>
                        {{end -}}
                    </select>
                </div>
            </div>
            <div class="layui-inline">
                <input type="search" name="search" class="layui-input" placeholder="搜索地理位置">
            </div>
            <div class="layui-inline">
                <div class="layui-input-inline">
                    <select name="duration" lay-filter="search-select" class="layui-select">
                        {{range $i,$v:=.durations -}}
                            <option value="{{$i}}">{{$v}}</option>
                        {{end -}}
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
            <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="del" lay-tips="删除选中项">
                <i class="layui-icon layui-icon-delete"></i>
            </button>
            <button class="layui-btn layui-btn-sm layui-btn-primary" lay-event="truncate">清空</button>
        </div>
    </div>
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm" lay-event="log" lay-tips="查看日志">
            <i class="layui-icon layui-icon-log"></i>
        </button>
        <button class="layui-btn layui-btn-sm layui-bg-red" lay-event="resetLog" lay-tips="重置日志">
            <i class="layui-icon iconfont icon-reset"></i>Log
        </button>
    </div>
</script>
<script type="text/html" id="table-toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-xs" lay-event="view" lay-tips="查看详情">
            <i class="iconfont icon-view"></i>
        </button>
        <button class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del">
            <i class="layui-icon layui-icon-delete"></i>
        </button>
    </div>
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let main = layui.main,
            where = {cols: []};
        $.each($("div.layui-form.table-search [name]").serializeArray(), function () {
            if (this.value !== "") {
                where[this.name] = this.value;
                where.cols.push(this.name);
            }
        });
        where.cols = where.cols.join();
        main.table({
            where: where,
            cols: [[
                {type: 'checkbox', fixed: 'left'},
                {field: 'id', title: 'ID', hide: true},
                {field: 'waiter_id', title: '客服ID', hide: true},
                {field: 'waiter_alias', width: 80, title: '客服', align: 'center'},
                {
                    title: '终端', width: 80, templet: function (d) {
                        if (d['is_mobile']) {
                            return "手机端";
                        }
                        return "电脑端";
                    }
                },
                {field: 'entrance', title: '入口', minWidth: 100},
                {
                    title: 'IP', minWidth: 100, templet: function (d) {
                        return d['ip'];
                    }
                },
                {
                    title: '区域', minWidth: 100, templet: function (d) {
                        if (d.city) {
                            return d.city
                        }
                        if (d['province']) {
                            return d['province'];
                        }
                        if (d['isp']) {
                            return d['isp'];
                        }
                        if (d['country']) {
                            return d['country'];
                        }
                        return '未知';
                    }
                },
                {
                    field: 'updated', title: '时间', align: 'center', sort: true, templet: function (d) {
                        return main.timestampFormat(d['updated']);
                    }
                },
                {title: '操作', width: 120, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
            ]],
        }, {
            view: function (obj) {
                main.get(URL + "/view", {id: obj.data.id}, function (content) {
                    main.display({
                        content: '<textarea class="layui-textarea" style="border-radius:20px;width:98%;height:96%;margin:1%">' + content + '</textarea>',
                        area: ['80%', '80%'],
                    });
                });
            }
        });
    });
</script>