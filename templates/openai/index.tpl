<div class="layui-card" style="padding-top: 50px;padding-bottom: 50px;">
    <div class="layui-card-body layui-form layui-row" lay-filter="form">
        <div class="layui-col-sm4" style="padding-right: 10px">
            <div class="layui-form-item">
                <label for="name" class="layui-form-label">名称:</label>
                <div class="layui-input-block">
                    <input type="text" name="name" id="name" lay-verify="required" required class="layui-input" placeholder="模块名称" value="{{.obj.Name}}">
                </div>
            </div>
            <div class="layui-form-item">
                <label for="user_id" class="layui-form-label">秘钥:</label>
                <div class="layui-input-block">
                    <select name="user_id" id="user_id" lay-search>
                        <option value="0">随机秘钥</option>
                        <option value="-1"{{if eq .obj.UserId -1}} selected{{end}}>最新秘钥</option>
                        {{range .users -}}
                            <option value="{{.Id}}"{{if eq .Id $.obj.UserId}} selected{{end}}>{{.Key}}</option>
                        {{end -}}
                    </select>
                </div>
            </div>
            <div class="layui-form-item">
                <label for="driver" class="layui-form-label">引擎:</label>
                <div class="layui-input-block">
                    <select name="driver" id="driver" lay-filter="driver" lay-search>
                        {{range $i,$v:=$.engines -}}
                            <option value="{{$v.Driver}}"{{if eq $v.Driver $.obj.Driver}} selected{{end}}>{{$v.Alias}}</option>
                        {{end -}}
                    </select>
                </div>
            </div>
            <div class="layui-form-item">
                <label for="model" class="layui-form-label">模型:</label>
                <div class="layui-input-block">
                    <select name="model" id="model" lay-search>
                        {{range $i,$v:=$.models -}}
                            <option value="{{$v}}"{{if eq $v $.obj.Model}} selected{{end}}>{{$v}}</option>
                        {{end -}}
                    </select>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label" lay-tips="Maximum length参数指定了OpenAI API中文本生成模型的最大输出长度。它可以防止模型生成过长的文本，从而减少计算资源的消耗。请求最多可以使用在提示和完成之间共享的 2048 或 4000个字符。确切的限制因型号而异。(对于普通英文文本，一个标记大约是4个字符)">最大长度:</label>
                <div class="layui-input-block">
                    <div id="max_tokens" class="slider-block"></div>
                    <input type="hidden" name="max_tokens" value="{{.obj.MaxTokens}}">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label" lay-tips="它可以控制生成文本的多样性。Temperature参数越高，生成的文本就越多样化，但也可能会出现更多的语法错误和不通顺的句子。Temperature参数越低，生成的文本就越简单，但也可能会出现更多的重复句子。">温度:</label>
                <div class="layui-input-block">
                    <div id="temperature" class="slider-block"></div>
                    <input type="hidden" name="temperature" value="{{.obj.Temperature}}">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label" lay-tips="它用于控制生成的文本的多样性。它控制了模型生成的文本中最高概率的词语的比例，以便模型可以生成更多样化的文本。">TopP:</label>
                <div class="layui-input-block">
                    <div id="top_p" class="slider-block"></div>
                    <input type="hidden" name="top_p" value="{{.obj.TopP}}">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label" lay-tips="它的作用是控制算法在搜索过程中对频繁出现的结果的惩罚。它可以帮助算法更好地探索搜索空间，从而更有可能找到更好的结果。">频率惩罚:</label>
                <div class="layui-input-block">
                    <div id="frequency_penalty" class="slider-block"></div>
                    <input type="hidden" name="frequency_penalty" value="{{.obj.FrequencyPenalty}}">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label" lay-tips="它的作用是用来控制AI模型中的缺失值惩罚。它可以用来控制AI模型对缺失值的惩罚程度，从而改善模型的准确性和性能。">存在惩罚:</label>
                <div class="layui-input-block">
                    <div id="presence_penalty" class="slider-block"></div>
                    <input type="hidden" name="presence_penalty" value="{{.obj.PresencePenalty}}">
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-btn-group" style="margin-left:calc(50% - 20px);">
                    <button class="layui-btn layui-btn-sm" lay-submit lay-filter="submit">
                        <i class="iconfont icon-save"></i>保存
                    </button>
                    <button class="layui-btn layui-btn-sm layui-btn-danger" data-event="del">
                        <i class="layui-icon layui-icon-delete"></i>删除
                    </button>
                </div>
            </div>
        </div>
        <div class="layui-col-sm8" style="padding-left: 10px">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label for="id" class="layui-form-label">现有模块:</label>
                    <div class="layui-input-block">
                        <select id="id" name="id" lay-search lay-filter="id">
                            <option value="">新建</option>
                            {{range $i,$v:= .objs -}}
                                <option value="{{$v.Id}}"{{if eq $v.Id $.obj.Id}} selected{{end}}>{{$v.Name}}</option>
                            {{end -}}
                        </select>
                    </div>
                </div>
                <div class="layui-inline">
                    <label for="keyword" class="layui-form-label">关键词:</label>
                    <div class="layui-input-block">
                        <input type="text" name="keyword" id="keyword" class="layui-input" placeholder="试管婴儿" value="{{.obj.Keyword}}">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <textarea name="prompt" rows="20" class="layui-textarea" placeholder="写作要求" lay-verify="required" required>{{.obj.Prompt}}</textarea>
                <div class="insert-var">
                    <label class="layui-form-label" style="padding:5px 15px;color:coral">插入变量:</label>
                    <button class="layui-btn layui-btn-xs layui-btn-radius layui-btn-primary" data-write="${keyword}">
                        关键词变量
                    </button>
                </div>
                <div class="layui-inline" style="float: right">
                    <div class="layui-btn-group">
                        <button class="layui-btn layui-btn-xs" data-event="request">
                            <i class="layui-icon layui-icon-play"></i>请求
                        </button>
                        <button class="layui-btn layui-btn-xs layui-btn-primary" data-event="result">
                            <i class="iconfont icon-view"></i>结果
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        const objIdName = 'openaiObjID', ID = {{.obj.Id}}, model ={{.obj.Model}};
        let id = +(localStorage.getItem(objIdName));
        if (!ID && id) {
            return location.replace(URL + '?id=' + id);
        }
        localStorage.setItem(objIdName, ID);
        let main = layui.main, form = layui.form, engines = {{.engines}},
            resetModelDoc = function (driver) {
                driver = driver || $('#driver').val();
                for (let i = 0; i < engines.length; i++) {
                    if (engines[i].driver === driver) {
                        let elem = $('#model').empty();
                        $.each(engines[i]['models'], function (i, v) {
                            elem.append('<option value="' + v + (v === model ? '" selected>' : '">') + v + '</option>');
                        });
                        form.render('select');
                        return
                    }
                }
            };
        main.upload();
        form.on('select(driver)', function (obj) {
            resetModelDoc(obj.value);
        });
        form.on('select(id)', function (obj) {
            localStorage.setItem(objIdName, obj.value);
            location.replace(URL + '?id=' + obj.value);
        });
        form.on('submit(submit)', function (obj) {
            main.request({
                data: obj.field,
                done: function (res) {
                    if (res.data) {
                        localStorage.setItem(objIdName, res.data.id);
                        location.replace(URL + '?id=' + res.data.id);
                    }
                }
            });
        });
        main.slider(
            {elem: '#max_tokens', min: 1, max: 4000},
            {elem: '#temperature', min: 0, max: 200},
            {elem: '#top_p', min: 0, max: 100},
            {elem: '#frequency_penalty', min: 0, max: 200},
            {elem: '#presence_penalty', min: 0, max: 200}
        );
        let active = {
            del: function () {
                if (!ID) return;
                main.request({
                    url: URL + '/del',
                    data: {id: ID},
                    done: function () {
                        localStorage.setItem(objIdName, 0);
                        location.replace(URL);
                    }
                });
            },
            request: function () {
                let data = form.val('form');
                if (!data.prompt) {
                    return main.error('写作要求不可以为空!');
                }
                main.request({
                    url: URL + '/stream',
                    data: data,
                    done: function () {
                        main.ws.log('openai.stream.' + ID);
                        return false;
                    }
                });
            },
            result: function () {
                main.ws.log('openai.stream.' + ID)
            }
        };
        $('[data-event]').on('click', function () {
            let type = $(this).data('event');
            active[type] && active[type].call($(this));
        });
    })
</script>