<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <label class="layui-form-label">私钥:</label>
            <textarea class="layui-textarea" name="private_key" rows="16" readonly>{{.privateKey}}</textarea>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">公钥:</label>
            <textarea class="layui-textarea" name="public_key" rows="7" readonly>{{.publicKey}}</textarea>
        </div>
        <div class="layui-form-item" style="text-align: center">
            <button class="layui-btn layui-btn-radius" id="reload">
                <i class="layui-icon layui-icon-refresh"></i>重新生成
            </button>
        </div>
    </div>
</div>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let form = layui.form,
            main = layui.main;
        $("#reload").click(function () {
            main.req({
                url: "/tools/rsa", ending: function (res) {
                    $('[name="private_key"]').text(res.data.private_key);
                    $('[name="public_key"]').text(res.data.public_key);
                    form.render();
                }
            });
        });
    });
</script>