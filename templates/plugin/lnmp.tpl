<div class="layui-card">
    <div class="layui-card-body layui-form">
        <input type="hidden" name="action" value="install">
        <button class="layui-hide" lay-submit></button>
        <div class="layui-form-item">
            <label class="layui-form-label">架构模式:</label>
            <input type="radio" name="stack" value="lnmp" title="LNMP" lay-filter="stack" checked>
            <input type="radio" name="stack" value="lnmpa" title="LNMPA" lay-filter="stack">
        </div>
        <div class="layui-form-item">
            <div class="layui-inline"><label class="layui-form-label">MySQL版本:</label>
                <div class="layui-input-block" style="width: 120px">
                    <select name="db_select" class="layui-select">
                        <option value="1">MySQL 5.1</option>
                        <option value="2" selected>MySQL 5.5</option>
                        <option value="3">MySQL 5.6</option>
                        <option value="4">MySQL 5.7</option>
                        <option value="5">MySQL 8.0</option>
                        <option value="6">MariaDB 5.5</option>
                        <option value="7">MariaDB 10.1</option>
                        <option value="8">MariaDB 10.2</option>
                        <option value="9">MariaDB 10.3</option>
                        <option value="10">MariaDB 10.4</option>
                        <option value="0">不安装数据库</option>
                    </select>
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label" lay-tips="数据库Root密码">密码:</label>
                <div class="layui-input-block" style="width: 120px">
                    <input type="text" name="db_root_password" value="{{.obj.DBRootPassword}}" class="layui-input">
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">启用InnoDB:</label>
            <div class="layui-input-block">
                <input type="checkbox" name="install_innodb" lay-skin="switch" lay-text="打开|关闭" checked>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">PHP版本:</label>
                <div class="layui-input-inline" style="width: 120px">
                    <select name="php_select" class="layui-select">
                        <option value="1">PHP 5.2</option>
                        <option value="2">PHP 5.3</option>
                        <option value="3">PHP 5.4</option>
                        <option value="4">PHP 5.5</option>
                        <option value="5" selected>PHP 5.6</option>
                        <option value="6">PHP 7.0</option>
                        <option value="7">PHP 7.1</option>
                        <option value="8">PHP 7.2</option>
                        <option value="9">PHP 7.3</option>
                        <option value="10">PHP 7.4</option>
                        <option value="11">PHP 8.0</option>
                    </select>
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">内存分配器:</label>
                <div class="layui-input-block" style="width: 120px">
                    <select name="select_malloc" class="layui-select">
                        <option value="1" selected>不安装</option>
                        <option value="2">Jemalloc</option>
                        <option value="3">TCMalloc</option>
                    </select>
                </div>
            </div>
        </div>
        <div id="lnmpa" style="display: none">
            <div class="layui-form-item">
                <label class="layui-form-label">Apache版本:</label>
                <div class="layui-input-inline">
                    <select name="apache_select" class="layui-select">
                        <option value="1">Apache 2.2</option>
                        <option value="2" selected>Apache 2.4</option>
                    </select>
                </div>
                <div class="layui-form-mid layui-word-aux">仅LNMPA</div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">管理员邮箱:</label>
                <div class="layui-input-inline">
                    <input type="email" name="server_admin" value="webmaster@example.com" class="layui-input">
                </div>
                <div class="layui-form-mid layui-word-aux">仅LNMPA</div>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">离线安装:</label>
            <div class="layui-input-block">
                <input type="checkbox" name="check_mirror" lay-skin="switch" lay-text="打开|关闭">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-form-mid layui-word-aux">
                安装时间大概是1个小时,安装成功后重启APP<br/>
                卸载:在终端执行 cd /root/lnmp && sh uninstall.sh
            </div>
        </div>
    </div>
</div>
<script>
    layui.form.on('radio(stack)', function (obj) {
        if (obj.value === "lnmp") {
            $('#lnmpa').css("display", "none");
        } else {
            $('#lnmpa').css("display", "block");
        }
    });
</script>
