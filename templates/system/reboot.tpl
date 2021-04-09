<div class="layui-row layui-col-space15">
    <div class="layui-card">
        <div class="layui-card-header">时间设置</div>
        <div class="layui-card-body">
            <div class="layui-form-item">
                <div class="layui-input-block">
                    <button class="layui-btn layui-btn-mini" data-type="BotAdmin">
                        <i class="layui-icon iconfont icon-refresh"></i>重启BotAdmin
                    </button>
                    <button class="layui-btn layui-btn-mini" data-type="Nginx">
                        <i class="layui-icon iconfont icon-refresh"></i>重启Nginx
                    </button>
                    <button class="layui-btn layui-btn-mini" data-type="MySQL">
                        <i class="layui-icon iconfont icon-refresh"></i>重启MySQL
                    </button>
                    <button class="layui-btn layui-btn-mini" data-type="PureFtpd">
                        <i class="layui-icon iconfont icon-refresh"></i>重启PureFtpd
                    </button>
                    <button class="layui-btn layui-btn-mini" data-type="SSH">
                        <i class="layui-icon iconfont icon-refresh"></i>重启SSH
                    </button>
                    <button class="layui-btn layui-btn-mini" data-type="Reboot">
                        <i class="layui-icon iconfont icon-refresh"></i>重启服务器
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let main = layui.main,
            url = {{.current_uri}},
            active = {
                BotAdmin: function () {
                    req("确定要重启本管理器？", 'botadmin');
                },
                Nginx: function () {
                    req("确定要重启Nginx？", 'nginx');
                },
                MySQL: function () {
                    req("确定要重启MySQL？", 'mysql');
                },
                PureFtpd: function () {
                    req("确定要重启PureFtpd？", 'pureftpd');
                },
                SSH: function () {
                    req("确定要重启SSH？", 'ssh');
                },
                Reboot: function () {
                    req("确定要重启服务器？", 'reboot');
                }
            };

        function req(msg, act) {
            layer.confirm(msg, function (index) {
                main.req({
                    url: url,
                    data: {'act': act},
                    tips: function (res) {
                        main.msg(res.msg);
                    },
                    index: index
                });
            });
        }

        $(".layui-btn.layui-btn-mini").on("click", function () {
            let type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });
    });
</script>
