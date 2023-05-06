<div class="layui-card">
    <div class="layui-card-header">
        <label class="layui-form-label">配置文件</label>
        <div class="layui-input-inline">
            <div class="layui-form-mid">{{.mycnf_path}}</div>
        </div>
    </div>
    <div class="layui-card-body">
        <div class="layui-btn-container">
            <button class="layui-btn layui-btn-small" lay-event="edit-sql"
                    id="editMyCnf"
                    data-url="/file/editor?path={{.mycnf_path}}">
                <i class="layui-icon layui-icon-edit"></i>编辑配置文件
            </button>
            <button class="layui-btn layui-btn-small" lay-event="recover-sql">
                <i class="layui-icon iconfont icon-sql"></i>恢复默认
            </button>
            <button class="layui-btn layui-btn-small layui-btn-warm" lay-event="reboot-sql">
                <i class="layui-icon layui-icon-refresh"></i>重启MySQL
            </button>
        </div>
    </div>
</div>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let main = layui.main;
        $('button[lay-event]').off('click').on('click', function () {
            switch ($(this).attr('lay-event')) {
                case 'edit-sql':
                    let loading = main.loading();
                    $.get('/file/editor?path={{.mycnf_path}}', {hide: true}, function (html) {
                        loading.close();
                        main.popup({
                            url: "/file/editor",
                            title: '编辑文件',
                            content: html,
                        });
                    });
                    break;
                case 'recover-sql':
                    main.request({url: url + '/recover'});
                    break;
                case 'reboot-sql':
                    main.request({
                        url: '/system/reboot',
                        data: {act: 'mysql'},
                    });
                    break;
            }
        });
    });
</script>