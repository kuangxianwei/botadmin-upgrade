<div class="layui-card">
    <div class="layui-card-body layui-form">
        <div class="layui-row">
            <div class="layui-col-md5">
                <div class="layui-form-item">
                    <label class="layui-form-label">启用:</label>
                    <div class="layui-input-inline">
                        <input type="checkbox" name="enabled" lay-skin="switch"
                               lay-text="是|否"{{if .obj.Enabled}} checked{{end}}/>
                    </div>
                </div>
            </div>
            <div class="layui-col-md6">
                <div class="layui-form-item">
                    <label class="layui-form-label">排序:</label>
                    <div class="layui-input-inline">
                        <input type="text" name="sort" value="{{.obj.Sort}}" autocomplete="off" placeholder="0"
                               class="layui-input">
                    </div>
                    <div class="layui-form-mid layui-word-aux">值越大越排后面</div>
                </div>
            </div>
        </div>
        <div class="layui-row">
            <div class="layui-col-md5">
                <div class="layui-form-item">
                    <label class="layui-form-label">用户名:</label>
                    <div class="layui-input-inline">
                        <input type="text" name="username" value="{{.obj.Username}}" lay-verify="required"
                               autocomplete="off" placeholder="liYi"
                               class="layui-input"{{if .obj.Username}} disabled{{end}}>
                        {{if .obj.Username}}
                            <input type="hidden" name="username" value="{{.obj.Username}}" lay-verify="required">
                        {{end}}
                    </div>
                    <div class="layui-form-mid layui-word-aux">数字和字母组成</div>
                </div>
            </div>
            <div class="layui-col-md6">
                <div class="layui-form-item">
                    <label class="layui-form-label">别名:</label>
                    <div class="layui-input-inline">
                        <input type="text" name="alias" value="{{.obj.Alias}}" autocomplete="off" placeholder="李谊"
                               class="layui-input">
                    </div>
                    <div class="layui-form-mid layui-word-aux">填写姓名</div>
                </div>
            </div>
        </div>
        <div class="layui-row">
            <div class="layui-col-md5">
                <div class="layui-form-item">
                    <label class="layui-form-label">手机号:</label>
                    <div class="layui-input-inline">
                        <input type="text" name="phone" value="{{.obj.Phone}}" lay-verify="phone"
                               autocomplete="off" placeholder="13922352985" class="layui-input">
                    </div>
                    <div class="layui-form-mid layui-word-aux">填写手机号码</div>
                </div>
            </div>
            <div class="layui-col-md6">
                <div class="layui-form-item">
                    <label class="layui-form-label">微信号:</label>
                    <div class="layui-input-inline">
                        <input type="text" name="wechat" value="{{.obj.Wechat}}"
                               autocomplete="off" placeholder="13922352985" class="layui-input">
                    </div>
                    <div class="layui-form-mid layui-word-aux">留空默认为手机号码</div>
                </div>
            </div>
        </div>
        <div class="layui-row">
            <div class="layui-col-md5">
                <div class="layui-form-item">
                    <label class="layui-form-label">限制:</label>
                    <div class="layui-input-inline">
                        <input type="text" name="max" value="{{.obj.Max}}" lay-verify="number"
                               autocomplete="on" placeholder="0" class="layui-input">
                    </div>
                    <div class="layui-form-mid layui-word-aux">超过则不启用 0为不限制</div>
                </div>
            </div>
            <div class="layui-col-md6">
                <div class="layui-form-item">
                    <label class="layui-form-label">权重:</label>
                    <div class="layui-input-inline" style="margin-top:18px;">
                        <div id="weight"></div>
                        <input type="hidden" name="weight" value="{{$.obj.Weight}}" lay-verify="number">
                    </div>
                    <div class="layui-form-mid layui-word-aux">值越高 几率越高</div>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-row">
                <div class="layui-col-md4">
                    <label class="layui-form-label">二维码:</label>
                    <div class="layui-input-inline">
                        <div class="layui-upload-drag" id="uploadFile">
                            <i class="layui-icon layui-icon-upload-drag"></i>
                            <p>点击上传文件，或将文件拖拽到此处！</p>
                        </div>
                    </div>
                </div>
                <div class="layui-col-md4">
                    <div class="layui-upload-list" id="uploadResult">
                        {{if .obj.QR -}}
                            <img height="130" width="130" alt="二维码" src="{{.obj.QR}}"/>
                        {{end -}}
                    </div>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">在线咨询:</label>
            <div class="layui-input-inline" style="width: 50%">
                <input name="consult" value="{{.obj.Consult}}" autocomplete="off"
                       placeholder="http://p.qiao.baidu.com/cps/chat?siteId=15213845&userId=30737617&siteToken=b7387650dc45ac0bbeef7fc0f807ed9a"
                       class="layui-input">
            </div>
            <div class="layui-form-mid layui-word-aux">如QQ在线</div>
            <button class="layui-btn" lay-event="fill-consult">填充默认</button>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">其他:</label>
            <div class="layui-input-inline" style="width: 50%">
                <textarea name="other" class="layui-textarea" rows="4">{{.obj.Other}}</textarea>
            </div>
            <div class="layui-form-mid layui-word-aux">例如百度统计客服代码</div>
            <button class="layui-btn" lay-event="fill-other">填充默认</button>
        </div>
        <div class="layui-form-item layui-hide">
            <button lay-submit>提交</button>
            <button id="uploadSubmit"></button>
            <button id="submit"></button>
        </div>
    </div>
</div>
<script>
    layui.use(['main'], function () {
        //滑块控制
        layui.main.slider({elem: '#weight', value: {{.obj.Weight}}, max: 100});
        layui.$('[lay-event="fill-consult"]').on('click', function () {
            layui.main.req({
                url: '/contact/fill/consult', ending: function (res) {
                    layui.$('[name="consult"]').val(res.data);
                }
            });
        });
        layui.$('[lay-event="fill-other"]').on('click', function () {
            layui.main.req({
                url: '/contact/fill/other', ending: function (res) {
                    layui.$('[name="other"]').val(res.data);
                }
            });
        });
    });
</script>
