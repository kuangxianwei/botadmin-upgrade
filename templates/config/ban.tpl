<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-row layui-col-space10">
            <div class="layui-col-md6" style="text-align: center"><b>编辑黑名单</b></div>
            <div class="layui-col-md6" style="text-align: center"><b>编辑白名单</b></div>
            <div class="layui-col-md6">
                <textarea class="layui-textarea" name="denies" rows="20">{{join .ban.Denies "\n"}}</textarea>
            </div>
            <div class="layui-col-md6">
                <textarea class="layui-textarea" name="allows" rows="20">{{join .ban.Allows "\n"}}</textarea>
            </div>
        </div>
        <div class="layui-hide">
            <button class="layui-btn" lay-submit lay-filter="submit"></button>
        </div>
    </div>
</div>
