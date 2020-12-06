<div class="layui-card-header layuiadmin-card-header-auto layui-form">
    <div class="layui-form-item">
        <div class="layui-input-inline">
            <input type="text" name="addr" placeholder="输入目标地址" autocomplete="off" class="layui-input">
        </div>
        <div class="layui-input-inline">
            <select name="email_id" lay-filter="email_id" lay-search>
                <option>搜索...</option>
                {{range $v:=.emails}}
                    <option value="{{$v.Id}}">{{$v.Username}}</option>
                {{end}}
            </select>
        </div>
        <button class="layui-btn" data-type="reload" lay-submit lay-filter="search">
            <i class="layui-icon layui-icon-search layuiadmin-button-btn"></i>
        </button>
    </div>
</div>
<div class="layui-card">
    <div class="layui-card-body">
        <table id="table-list" lay-filter="table-list"></table>
    </div>
</div>
<script type="text/html" id="toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm" lay-event="add">
            <i class="layui-icon layui-icon-add-1"></i>添加
        </button>
        <button class="layui-btn  layui-btn-danger layui-btn-sm" lay-event="del">
            <i class="layui-icon layui-icon-delete"></i>删除
        </button>
    </div>
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm" lay-event="enabled">
            <i class="layui-icon layui-icon-email"></i>启用
        </button>
        <button class="layui-btn layui-btn-danger layui-btn-sm" lay-event="disabled">
            <i class="layui-icon layui-icon-email"></i>关闭
        </button>
    </div>
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-sm" lay-event="jobs" lay-tips="查看运行中的任务">
            <i class="layui-icon iconfont icon-work"></i>
        </button>
    </div>
</script>
<script type="text/html" id="table-toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-xs" lay-event="modify">
            <i class="layui-icon layui-icon-edit"></i>
        </button>
        <button class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del">
            <i class="layui-icon layui-icon-delete"></i>
        </button>
        <button class="layui-btn layui-btn-xs" lay-event="test">测试</button>
        <button class="layui-btn layui-btn-xs layui-btn-primary" lay-event="log" lay-tips="查看日志">
            <i class="layui-icon layui-icon-log"></i>
        </button>
    </div>
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.config({
        base: '/static/' //静态资源所在路径
    }).extend({
        index: 'lib/index', //主入口模块
        main: 'main'
    }).use(['index', 'form', 'table', 'main'], function () {
        let $ = layui.$,
            table = layui.table,
            main = layui.main,
            element = layui.element,
            form = layui.form,
            url = {{.current_uri}};

        // 渲染表格
        table.render({
            headers: {'X-CSRF-Token':{{.csrf_token}}},
            method: 'post',
            elem: '#table-list',
            url: {{.current_uri}},
            toolbar: '#toolbar',
            cols: [[
                {type: 'checkbox', fixed: 'left'},
                {field: 'id', width: 80, title: 'ID', align: 'center', hide: true},
                {
                    field: 'cron_enabled',
                    title: '启用',
                    align: 'center',
                    width: 92,
                    unresize: true,
                    templet: function (d) {
                        let msg = '<input id="' + d.id + '" type="checkbox" name="cron_enabled" lay-skin="switch" lay-text="是|否" lay-filter="switchCronEnabled"';
                        if (d.cron_enabled) {
                            msg += ' checked>';
                        } else {
                            msg += '>';
                        }
                        return msg;
                    }
                },
                {field: 'addr', title: '目标地址', sort: true},
                {field: 'email_id', title: '配置ID', width: 80, align: 'center'},
                {field: 'to', title: '邮箱'},
                {field: 'updated', title: '时间', align: 'center', sort: true},
                {title: '操作', width: 160, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
            ]],
            page: true,
            limit: 10,
            limits: [10, 15, 20, 25, 30],
            text: '对不起，加载出现异常!'
        });

        //监听工具条
        table.on('tool(table-list)', function (obj) {
            let data = obj.data;
            switch (obj.event) {
                case 'del':
                    layer.confirm('删除后不可恢复，确定删除？', function (index) {
                        main.req({
                            url: url + '/del',
                            data: data,
                            index: index,
                            ending: 'table-list'
                        });
                    });
                    break;
                case 'modify':
                    $.get(url + '/modify', data, function (html) {
                        main.popup({
                            title: '修改监控',
                            url: url + '/modify',
                            area: ['600px', '520px'],
                            content: html,
                            ending: 'table-list',
                        });
                        element.render();
                    });
                    break;
                case 'log':
                    $.get(url + '/log', data, function (html) {
                        main.popup({
                            title: '日志',
                            content: html,
                            url: url + '/log',
                        });
                    });
                    break;
                case 'test':
                    main.req({
                        url: url + '/test',
                        data: data
                    });
                    break;
            }
        });

        //监听工具栏
        table.on('toolbar(table-list)', function (obj) {
            let checkStatus = table.checkStatus(obj.config.id),
                data = checkStatus.data,
                ids = Array();
            switch (obj.event) {
                case 'add':
                    $.get(url + '/add', {}, function (html) {
                        main.popup({
                            title: '添加邮箱',
                            url: url + '/add',
                            area: ['600px', '520px'],
                            content: html,
                            ending: 'table-list',
                        });
                        element.render();
                    });
                    break;
                case 'del':
                    if (data.length === 0) {
                        return layer.msg('请选择数据');
                    }
                    layer.confirm('删除后不可恢复，确定删除吗？', function (index) {
                        let ids = Array();
                        for (let i = 0; i < data.length; i++) {
                            ids[i] = data[i].id;
                        }
                        main.req({
                            url: url + '/del',
                            data: {'ids': ids.join()},
                            index: index,
                            ending: 'table-list'
                        });
                    });
                    break;
                case 'enabled':
                    if (data.length === 0) {
                        return layer.msg('请选择数据');
                    }
                    ids = Array();
                    for (let i = 0; i < data.length; i++) {
                        ids[i] = data[i].id;
                    }
                    main.req({
                        url: url + '/switch',
                        data: {ids: ids.join(), cron_enabled: true},
                        ending: 'table-list'
                    });
                    break;
                case 'disabled':
                    if (data.length === 0) {
                        return layer.msg('请选择数据');
                    }
                    ids = Array();
                    for (let i = 0; i < data.length; i++) {
                        ids[i] = data[i].id;
                    }
                    main.req({
                        url: url + '/switch',
                        data: {ids: ids.join(), cron_enabled: false},
                        ending: 'table-list'
                    });
                    break;
                case 'jobs':
                    main.req({
                        url: url + '/jobs',
                        tips: function (res) {
                            layer.alert(res.msg, {area: ['500px', '450px']});
                        },
                    });
                    break;
            }
        });
        //监听搜索
        form.on('submit(search)', function (data) {
            let field = data.field;
            //$("#form-search :input").val("").removeAttr("checked").remove("selected");
            //执行重载
            table.reload('table-list', {
                where: field,
                page: {curr: 1}
            });
            return false;
        });
        //监控选择状态
        form.on('select(email_id)', function () {
            $('button[lay-filter=search]').click();
            return false;
        });
        form.on('switch(switchCronEnabled)', function (obj) {
            let id = this.id,
                checked = this.checked;
            if (!id) {
                layer.tips('ID为空，无法操作！', obj.othis);
                return false;
            }
            main.req({
                url: url + '/switch',
                data: {id: id, cron_enabled: checked},
                ending: 'table-list',
            });
            return false;
        });
    });
</script>