<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-form-item">
            <label for="keyword" class="layui-form-label" lay-tips="一行一个关键词">关键词:</label>
            <div class="layui-input-inline">
                <textarea name="keyword" id="keyword" class="layui-textarea" rows="3" required></textarea>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" for="expect">网站:</label>
            <div class="layui-input-inline">
                <input type="text" autocomplete="off" name="expect" id="expect" required lay-verify="required"
                       class="layui-input" placeholder="www.botadmin.cn">
            </div>
            <div class="layui-form-mid layui-word-aux">
                <strong style="color:red;">*</strong>
            </div>
        </div>
        <div class="layui-form-item">
            <label for="engine_0" class="layui-form-label">搜索引擎:</label>
            <div class="layui-input-block">
                <input type="checkbox" name="engine_0" id="engine_0" title="百度 PC" checked>
                <input type="checkbox" name="engine_1" id="engine_1" title="百度移动" checked>
                <input type="checkbox" name="engine_2" id="engine_2" title="神马搜索" checked>
                <input type="checkbox" name="engine_3" id="engine_3" title="头条搜索">
            </div>
        </div>
        <div class="layui-form-item layui-hide">
            <div class="layui-input-block">
                <button class="layui-btn" lay-submit lay-filter="submit">提交</button>
            </div>
        </div>
    </div>
</div>