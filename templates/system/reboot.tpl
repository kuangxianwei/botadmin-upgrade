<div class="layui-card">
    <div class="layui-card-header">服务重启</div>
    <div class="layui-card-body">
        <div class="layui-carousel layadmin-carousel layadmin-shortcut" lay-anim="" style="width: 100%; height: 280px;">
            <div carousel-item="">
                <ul class="layui-row layui-col-space10 layui-this">
                    <li class="layui-col-xs4" data-reboot="lnmp restart">
                        <i class="layui-icon layui-icon-website"></i>
                        <cite>重启Web</cite>
                    </li>
                    <li class="layui-col-xs4" data-reboot="lnmp mysql restart">
                        <i class="layui-icon iconfont icon-sql"></i>
                        <cite>重启MySQL</cite>
                    </li>
                    <li class="layui-col-xs4" data-reboot="/etc/init.d/pureftpd restart">
                        <i class="layui-icon iconfont icon-ftp"></i>
                        <cite>重启FTP</cite>
                    </li>
                    <li class="layui-col-xs4" data-reboot="systemctl restart sshd">
                        <i class="layui-icon iconfont icon-ssh"></i>
                        <cite>重启SSH</cite>
                    </li>
                    <li class="layui-col-xs4" data-event="app">
                        <i class="layui-icon layui-icon-app"></i>
                        <cite>重启App</cite>
                    </li>
                    <li class="layui-col-xs4" data-event="service">
                        <i class="layui-icon iconfont icon-resource"></i>
                        <cite>重启服务器</cite>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</div>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let main = layui.main,
            active = {
                app: function () {
                    main.reboot.app();
                },
                service: function () {
                    main.reboot.service();
                },
            };
        $('[data-reboot]').off('click').on('click', function () {
            layui.main.webssh({stdin: $(this).data("reboot")});
        });
        $('[data-event]').on('click', function () {
            let $this = $(this), event = $this.data("event");
            active[event] && active[event].call($this);
        });
    });
</script>
