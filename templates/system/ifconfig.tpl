<div class="layui-card">
    <div class="layui-card-body">
        <table id="table-list" lay-filter="table-list"></table>
    </div>
    <div class="layui-card-body">
        <blockquote class="layui-elem-quote">
            1:eth(0/1/2)是Linux的网卡名称，为第1，2，3块<br/>
            2:eth0:0 为绑定在第一块网卡(eth0)上的IP地址，如此类推，eth0:1，eth0:2...<br/>
            3:停用表示停止使用该IP，重启后恢复<br/>
            4:删除表示删除该IP的配置，永久删除，重启也不会恢复<br/>
            5:venet为OpenVZ虚拟机上的网卡名称
        </blockquote>
    </div>
</div>
<script type="text/html" id="toolbar">
    <div class="layui-btn-container">
        <button class="layui-btn" lay-event="AddIP" id="LAY_layer_iframe_add" lay-tips="点击添加IP地址">
            <i class="layui-icon layui-icon-add-1"></i>添加IP
        </button>
        <button class="layui-btn layui-btn-primary">默认网关：{{.Route}}</button>
    </div>
</script>
<script type="text/html" id="table-toolbar">
    <div class="layui-btn-group">
        <button class="layui-btn layui-btn-xs layui-btn-warm" lay-event="stop">停用</button>
        <button class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del">
            <i class="layui-icon layui-icon-delete"></i>
        </button>
    </div>
</script>
<script type="text/template" id="formAddIP">
    <div class="layui-field-box">
        <div class="layui-form">
            <div class="layui-form-item">
                <label class="layui-form-label">网卡名称</label>
                <div class="layui-input-inline" style="width:100px;">
                    <select name="eth">
                        <option value="eth0:0">eth0:0</option>
                        <option value="eth0:1">eth0:1</option>
                        <option value="eth0:2">eth0:2</option>
                        <option value="eth0:3">eth0:3</option>
                        <option value="eth0:4">eth0:4</option>
                        <option value="eth0:5">eth0:5</option>
                        <option value="eth1:0">eth1:0</option>
                        <option value="eth1:1">eth1:1</option>
                        <option value="eth1:2">eth1:2</option>
                        <option value="eth1:3">eth1:3</option>
                        <option value="eth1:4">eth1:4</option>
                        <option value="eth1:5">eth1:5</option>
                        <option value="venet0:1">venet0:1</option>
                        <option value="venet0:2">venet0:2</option>
                        <option value="venet0:3">venet0:3</option>
                        <option value="venet0:4">venet0:4</option>
                        <option value="venet0:5">venet0:5</option>
                    </select>
                </div>
                <div class="layui-form-mid">定义</div>
                <div class="layui-input-inline" style="width:100px">
                    <input type="text" name="eths" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">IP地址</label>
                <div class="layui-input-inline" style="width:248px">
                    <input type="text" name="ip" required lay-verify="required" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">子网掩码</label>
                <div class="layui-input-inline" style="width:248px">
                    <input type="text" name="mask" required lay-verify="required"
                           class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">重启生效</label>
                <div class="layui-input-inline" style="width:248px">
                    <input name="forever" type="checkbox" title="保存" lay-skin="switch" lay-text="打开|关闭"/>
                </div>
            </div>
            <div class="layui-form-item" style="display:none">
                <div class="layui-input-block">
                    <button class="layui-btn" lay-submit lay-filter="submitAddIP">提交</button>
                </div>
            </div>
            <blockquote class="layui-elem-quote">
                1:增加IP地址不用设置网关,选择网卡后，有IP和子网掩码就可以<br/>
                2:如要重启后生效，请打开&quot;重启生效&quot;开关，否则重启后无效<br>
                3:如果网卡名称列表找所用网卡名，可使用自定义设置
            </blockquote>
        </div>
    </div>
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let form = layui.form,
            table = layui.table,
            main = layui.main;

        table.render({
            headers: {'X-CSRF-Token':csrfToken},
            method: 'post',
            elem: '#table-list',
            url: url,
            toolbar: '#toolbar',
            cols: [[
                {type: 'numbers', width: 80, title: 'ID', align: 'center', sort: true},
                {field: 'eth', title: '网卡'},
                {field: 'ip', title: 'IP地址', align: 'center'},
                {field: 'mask', title: '子网掩码', align: 'center'},
                {title: '操作', width: 120, align: 'center', fixed: 'right', toolbar: '#table-toolbar'}
            ]],
            page: false,

            limit: 10,
            limits: [10, 15, 20, 25, 30],
            text: '对不起，加载出现异常！'
        });

        table.on('tool(table-list)', function (obj) {
            let data = obj.data,
                msg = "删除后不可恢复，确定删除？";
            switch (obj.event) {
                case 'stop':
                    data.Act = 'Stop';
                    msg = "重启服务器恢复，确定停用？";
                    break;
                case 'del':
                    data.Act = 'Del';
                    break;
                default:
                    return false;
            }
            layer.confirm(msg, function (index) {
                main.req({
                    url: url,
                    data: data,
                    index: index,
                    ending: obj.del
                });
            });
        });

        table.on('toolbar(table-list)', function (obj) {
            switch (obj.event) {
                case 'AddIP':
                    layer.open({
                        type: 1,
                        title: '添加用户',
                        shadeClose: true,
                        shade: 0.8,
                        fixed: false,
                        maxmin: true,
                        content: $("#formAddIP").html(),
                        btn: ['保存', '取消'],
                        area: '700px',
                        yes: function (index, obj) {
                            obj.find('button[lay-filter=submitAddIP]').click();
                        },
                        success: function (d, index) {
                            form.on('submit(submitAddIP)', function (obj) {
                                let field = obj.field;
                                field.Act = 'Add';
                                main.req({
                                    url: url,
                                    data: field,
                                    index: index,
                                    ending: 'table-list',
                                });
                                return false;
                            });
                        }
                    });
                    form.render();
                    break;
            }
        });
    });
</script>