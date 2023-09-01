<div class="layui-card">
    <div class="layui-card-body">
        <div class="layui-tab layui-tab-card layui-form">
            <ul class="layui-tab-title">
                <li class="layui-this">基本设置</li>
                <li>模型设置</li>
            </ul>
            <div class="layui-tab-content">
                <div class="layui-tab-item layui-show">
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label for="name" class="layui-form-label">模块名称:</label>
                            <div class="layui-input-inline">
                                <input type="text" autocomplete="off" name="name" id="name" required
                                       class="layui-input" placeholder="文章模块1" autofocus="autofocus" value="{{.obj.Name}}">
                            </div>
                            <div class="layui-form-mid layui-word-aux">
                                <span class="text-danger"><strong style="color:red;">*</strong>模块名称不可以重复</span>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label for="user_id" class="layui-form-label">秘钥:</label>
                            <div class="layui-input-block">
                                <select name="user_id" id="user_id" lay-search>
                                    <option value="">顺序秘钥</option>
                                    {{range .users -}}
                                        <option value="{{.Id}}"{{if eq .Id $.Id}} selected{{end}}>{{.Key}}</option>
                                    {{end -}}
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item layui-row">
                        <div class="layui-col-sm6">
                            <label for="site_id" class="layui-form-label">问题列表:</label>
                            <div class="layui-input-block">
                                <textarea name="asks" class="layui-textarea" placeholder="免费b站推广网站有哪些?&#13;永久免费建站最好用的平台?" rows="5">{{join .obj.Asks "\n"}}</textarea>
                            </div>
                        </div>
                        <div class="layui-col-sm6">
                            <label for="site_id" class="layui-form-label">Tag列表:</label>
                            <div class="layui-input-block">
                                <textarea name="tags" rows="5" class="layui-textarea" placeholder="SEO公司&#13;SEO集团">{{join .obj.Tags "\n"}}</textarea>
                            </div>
                        </div>
                        <div class="layui-col-sm6">
                            <label for="site_id" class="layui-form-label">标题规则:</label>
                            <div class="layui-input-block">
                                <textarea name="titles" class="layui-textarea" placeholder="&#123;&#123;ask&#125;&#125;(&#123;&#123;ask&#125;&#125;)-&#123;&#123;tag&#125;&#125;" rows="5">{{join .obj.Titles "\n"}}</textarea>
                            </div>
                            <div class="layui-input-block fill-contact" style="margin-top:-5px;">
                                <label for="site_id" class="layui-form-label" style="padding:5px 15px;color:coral">插入变量:</label>
                                <button class="layui-btn layui-btn-xs layui-btn-radius layui-btn-primary" data-write="&#123;&#123;ask&#125;&#125;">
                                    问题变量
                                </button>
                                <button class="layui-btn layui-btn-xs layui-btn-radius layui-btn-primary" data-write="&#123;&#123;tag&#125;&#125;">
                                    Tag变量
                                </button>
                            </div>
                        </div>
                        <div class="layui-col-sm6">
                            <label for="site_id" class="layui-form-label">提问规则:</label>
                            <div class="layui-input-block">
                                <textarea name="rules" rows="5" class="layui-textarea" placeholder="给我写一篇以 &#123;&#123;ask&#125;&#125; 为标题的文章">{{join .obj.Rules "\n"}}</textarea>
                            </div>
                            <div class="layui-input-block fill-contact" style="margin-top:-5px;">
                                <label for="site_id" class="layui-form-label" style="padding:5px 15px;color:coral">插入变量:</label>
                                <button class="layui-btn layui-btn-xs layui-btn-radius layui-btn-primary" data-write="&#123;&#123;ask&#125;&#125;">
                                    问题变量
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label for="site_id" class="layui-form-label">绑定网站:</label>
                            <div class="layui-input-block">
                                <select name="site_id" id="site_id" lay-filter="site_id" lay-search>
                                    <option value="">搜索...</option>
                                    {{range .sites -}}
                                        <option value="{{.Id}}"{{if eq .Id $.obj.SiteId}} selected{{end}}>{{.Vhost}}</option>
                                    {{end -}}
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label for="enabled" class="layui-form-label">绑定栏目:</label>
                            <div class="layui-input-block" lay-filter="class_id">
                                {{.classHTML}}
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label for="enabled" class="layui-form-label">定时启用</label>
                            <div class="layui-input-block">
                                <input type="checkbox" name="enabled" id="enabled" lay-skin="switch" lay-text="启用|禁用" {{if .obj.Enabled}} checked{{end}}>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label for="spec" class="layui-form-label">定时规则:</label>
                            <div class="layui-input-inline" lay-tips="双击修改定时任务">
                                <input type="text" autocomplete="off" name="spec" id="spec" value="{{.obj.Spec}}" class="layui-input">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="layui-tab-item layui-row">
                    <div class="layui-col-sm4" id="sidebar">
                        <div class="layui-form-item">
                            <label for="driver" class="layui-form-label">接口:</label>
                            <div class="layui-input-block">
                                <select name="driver" id="driver" lay-filter="driver" lay-search>
                                    {{range $i,$v:=$.adapters -}}
                                        <option value="{{$v.Driver}}"{{if eq $v.Driver $.obj.Driver}} selected{{end}}>{{$v.Alias}}</option>
                                    {{end -}}
                                </select>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label for="model" class="layui-form-label">模型:</label>
                            <div class="layui-input-block">
                                <select name="model" id="model" lay-search>
                                    <option value="{{.obj.Model}}">{{.obj.Model}}</option>
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
                            <div class="layui-col-sm6">
                                <label for="text_begin" class="layui-form-label" lay-tips="文本段落开始标签,例如:<p>">Begin:</label>
                                <div class="layui-input-block">
                                    <input class="layui-input" type="text" autocomplete="off" name="text_begin" id="text_begin" value="{{.obj.TextBegin}}">
                                </div>
                            </div>
                            <div class="layui-col-sm6">
                                <label for="text_end" class="layui-form-label" lay-tips="文本段落结束标签,例如:</p>">End:</label>
                                <div class="layui-input-block">
                                    <input class="layui-input" type="text" autocomplete="off" name="text_end" id="text_end" value="{{.obj.TextEnd}}">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="layui-col-sm8">
                        <div class="layui-form-item">
                            <div class="layui-input-block" style="margin-left:30px;margin-right:15px;">
                                <input type="search" class="layui-input" name="prompt" value="给我写一篇以 &#123;&#123;ask&#125;&#125; 为标题的文章" placeholder="测试请求" style="background-color: black;color:white">
                                <textarea id="show-stream" rows="17" class="layui-textarea" placeholder="这里显示请求结果" style="margin-top: 10px"></textarea>
                                <button class="layui-btn" id="test" data-event="test">测试模块</button>
                                <button class="layui-btn layui-btn-primary" data-event="saveDefault" style="float:right">
                                    保存当前配置为系统默认
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="layui-form-item layui-hide">
                <div class="layui-input-block">
                    <input type="hidden" name="id" value="{{.obj.Id}}">
                    <button class="layui-btn" lay-submit lay-filter="submit">提交</button>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    layui.use(['main'], function () {
        let main = layui.main,
            form = layui.form,
            classes = {},
            bindClass = function (id, classId) {
                if (isNaN(parseInt(id))) {
                    $('select[name=class_id]').html(`<option value="">搜索...</option>`);
                    form.render('select');
                    return false
                }
                if (typeof classes[id] === 'string' && classes[id].length > 10) {
                    $('[lay-filter=class_id]').html(classes[id]);
                    form.render();
                    return false;
                }

                main.get('/site/class', {id: id, class_id: classId}, function (res) {

                    if (res.code === 0) {
                        classes[id] = res.data;
                        $('[lay-filter=class_id]').html(res.data);
                        form.render();
                    } else {
                        main.error(res.msg);
                    }
                });
            };
        let model = {{.obj.Model}}, adapters = {{.adapters}}, resetModelDoc = function (driver) {
            driver = driver || $('#driver').val();
            for (let i = 0; i < adapters.length; i++) {
                if (adapters[i].driver === driver) {
                    let elem = $('#model').empty();
                    $.each(adapters[i]['models'], function (i, v) {
                        if (v === model) {
                            elem.append(`<option value="` + v + `" selected>` + v + `</option>`);
                        } else {
                            elem.append(`<option value="` + v + `">` + v + `</option>`);
                        }
                    });
                    form.render("select");
                    return
                }
            }
        };
        resetModelDoc();
        form.on('select(driver)', function (obj) {
            resetModelDoc(obj.value);
        });
        //监控选择网站ID
        form.on('select(site_id)', function (obj) {
            bindClass(obj.value);
        });
        // 定时选择器
        main.cron('[name="spec"]');
        //滑块控制
        main.slider(
            {elem: '#max_tokens', min: 1, max: 4000},
            {elem: '#temperature', min: 0, max: 200},
            {elem: '#top_p', min: 0, max: 100},
            {elem: '#frequency_penalty', min: 0, max: 200},
            {elem: '#presence_penalty', min: 0, max: 200},
        );
        let active = {
            test: function () {
                let data = main.formData(this.closest(".layui-form"));
                main.request({
                    url: URL + "/test",
                    data: data,
                    done: function () {
                        let testElem = $('#test'),
                            promptElem = $('#show-stream').val(''),
                            ws = main.newWS();
                        ws.onopen = function () {
                            ws.send(JSON.stringify({action: 'log', token: "openai.stream.0"}));
                        };
                        ws.onmessage = function (e) {
                            let obj = JSON.parse(e.data);
                            if (obj.error) {
                                if (obj.error) main.error(obj.error);
                                return ws.close();
                            }
                            if (obj.running) {
                                testElem.addClass("layui-btn-disabled").removeAttr('data-event');
                            } else {
                                ws.close();
                                testElem.removeClass("layui-btn-disabled").attr('data-event', 'test');
                            }
                            promptElem.val(promptElem.val() + obj.data).focus().scrollTop(promptElem[0].scrollHeight);
                        };
                        return false;
                    }
                });
            },
            saveDefault: function () {
                let data = main.formData(this.closest(".layui-form"));
                main.request({
                    url: URL + "/default/save",
                    data: data,
                    done: function (res) {
                        if (Array.isArray(res.data)) {
                            let ele = $('select[name=model]'), val = ele.val(), html = '';
                            $.each(res.data, function (k, v) {
                                html += '<option value="' + v + '"' + (v === val ? ' selected' : '') + '>' + v + '</option>';
                            });
                            ele.html(html);
                            form.render('select');
                        }
                    }
                });
            }
        };
        // 填充关键词变量
        $('[data-write]').off("click").on("click", function () {
            $(this).parent().prev().find('textarea').insertAt($(this).data('write'));
        });
        $('[data-event]').off("click").on("click", function () {
            let $this = $(this), event = $this.data('event');
            active[event] && active[event].call($this);
        });
        $('[name=stop]').on("keydown", function (e) {
            if (e.keyCode === 13) {
                let val = $(e.target).val();
                $(e.target).val(val ? val + " ↵" : val + "↵");
            }
        });
    });
</script>