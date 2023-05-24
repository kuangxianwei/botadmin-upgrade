<div class="layui-field-box">
    <div class="layui-form">
        <div class="layui-form-item">
            <label class="layui-form-label">类型</label>
            <div class="layui-input-block">
                <input type="radio" name="kind" value="port" title="端口" checked>
                <input type="radio" name="kind" value="service" title="服务">
            </div>
        </div>
        <div class="layui-form-item">
            <label for="val" class="layui-form-label">值</label>
            <div class="layui-input-block">
                <input type="text" autocomplete="off" name="val" id="val" class="layui-input" placeholder="8080/tcp" required
                       lay-verify="required">
            </div>
        </div>
        <div class="layui-hide">
            <button class="layui-btn" lay-submit>立即提交</button>
        </div>
        <blockquote class="layui-elem-quote">
            开放端口 端口/{'tcp'|'udp'|'sctp'|'dccp'} 例如：8080/tcp<br/>
            服务 则填写存在的服务名称 例如:http mysql
        </blockquote>
    </div>
</div>