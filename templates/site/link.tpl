<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <textarea class="layui-textarea" name="links" rows="10">{{join .links "\n"}}</textarea>
        </div>
        <div class="layui-form-item layui-hide">
            <div class="layui-input-block">
                <input type="hidden" name="id" value="{{.id}}">
                <input type="hidden" name="ids" value="{{.ids}}">
                <button class="layui-btn" lay-submit lay-filter="submit">提交</button>
            </div>
        </div>
        <blockquote class="layui-elem-quote">
            链接一行一条<br/>
            试管婴儿=>http://www.botadmin.cn<br/>
            南方39=>http://www.botadmin.cn
        </blockquote>
    </div>
</div>
