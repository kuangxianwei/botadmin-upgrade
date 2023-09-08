<div class="layui-card">
    <div class="layui-card-body">
        <div class="layui-tab layui-tab-card layui-form" lay-filter="form">
            <ul class="layui-tab-title">
                <li class="layui-this">基本设置</li>
                <li>简介模型</li>
                <li>内容模型</li>
                <li>结尾模型</li>
            </ul>
            <div class="layui-tab-content" style="padding-bottom: 0">
                <div class="layui-tab-item layui-show">
                    <div class="layui-form-item layui-row">
                        <div class="layui-col-md6">
                            <label for="name" class="layui-form-label">名称:</label>
                            <div class="layui-input-inline">
                                <input type="text" name="name" id="name" required class="layui-input" placeholder="默认专业版模块" autofocus="autofocus" value="{{.obj.Name}}">
                            </div>
                            <div class="layui-form-mid layui-word-aux">
                                <span class="text-danger"><strong style="color:red;">*</strong>模块名称不可以重复</span>
                            </div>
                        </div>
                        <div class="layui-col-md6">
                            <div class="layui-inline">
                                <label for="enabled" class="layui-form-label">定时启用</label>
                                <div class="layui-input-block">
                                    <input type="checkbox" name="enabled" id="enabled" lay-skin="switch" lay-text="启用|禁用" {{if .obj.Enabled}} checked{{end}}>
                                </div>
                            </div>
                            <div class="layui-inline">
                                <label for="spec" class="layui-form-label">定时规则:</label>
                                <div class="layui-input-inline" lay-tips="双击修改定时任务">
                                    <input type="text" name="spec" id="spec" value="{{.obj.Spec}}" class="layui-input">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item layui-row">
                        <div class="layui-col-sm6">
                            <label for="keywords" class="layui-form-label">关键词列表:</label>
                            <div class="layui-input-block">
                                <textarea id="keywords" name="keywords" class="layui-textarea" placeholder="试管婴儿&#13;三代试管婴儿" rows="11">{{join .obj.Keywords "\n"}}</textarea>
                            </div>
                        </div>
                        <div class="layui-col-sm6">
                            <div class="layui-col-sm12">
                                <label for="brands" class="layui-form-label">品牌列表:</label>
                                <div class="layui-input-block">
                                    <textarea id="brands" name="brands" rows="5" class="layui-textarea" placeholder="南方39生殖中心&#13;南方39辅助生殖中心">{{join .obj.Brands "\n"}}</textarea>
                                </div>
                            </div>
                            <div class="layui-col-sm12">
                                <label for="titles" class="layui-form-label">标题规则:</label>
                                <div class="layui-input-block">
                                    <textarea id="titles" name="titles" class="layui-textarea" placeholder="&#123;&#123;title&#125;&#125;(&#123;&#123;title&#125;&#125;)-&#123;&#123;brand&#125;&#125;" rows="5">{{join .obj.Titles "\n"}}</textarea>
                                </div>
                                <div class="layui-input-block" style="margin-top:-5px;">
                                    <label class="layui-form-label" style="padding:5px 15px;color:coral">插入变量:</label>
                                    <button class="layui-btn layui-btn-xs layui-btn-radius layui-btn-primary" data-write="&#123;&#123;title&#125;&#125;">
                                        标题变量
                                    </button>
                                    <button class="layui-btn layui-btn-xs layui-btn-radius layui-btn-primary" data-write="&#123;&#123;brand&#125;&#125;">
                                        品牌变量
                                    </button>
                                </div>
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
                            <label class="layui-form-label">绑定栏目:</label>
                            <div class="layui-input-block" lay-filter="class_id">
                                {{.classHTML}}
                            </div>
                        </div>
                    </div>
                </div>
                <div class="layui-tab-item layui-row">
                    <div class="layui-col-sm4">
                        <div class="layui-form-item">
                            <label for="intro-user_id" class="layui-form-label">秘钥:</label>
                            <div class="layui-input-block">
                                <select name="intro.user_id" id="intro-user_id" lay-search>
                                    <option value="0">随机秘钥</option>
                                    <option value="-1"{{if eq .obj.Intro.UserId -1}} selected{{end}}>最新秘钥</option>
                                    {{range .users -}}
                                        <option value="{{.Id}}"{{if eq .Id $.obj.Intro.UserId}} selected{{end}}>{{.Key}}</option>
                                    {{end -}}
                                </select>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label for="intro-model" class="layui-form-label">模型:</label>
                            <div class="layui-input-block">
                                <select id="intro-model" name="intro.model" lay-search>
                                    {{range $i,$v:= .models -}}
                                        <option value="{{$v}}"{{if eq $v $.obj.Intro.Model}} selected{{end}}>{{$v}}</option>
                                    {{end -}}
                                </select>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label for="intro-role" class="layui-form-label">角色:</label>
                            <div class="layui-input-block">
                                <select id="intro-role" name="intro.role" lay-search>
                                    {{range $i,$v:= .roles -}}
                                        <option value="{{$v}}"{{if eq $v $.obj.Intro.Role}} selected{{end}}>{{$v}}</option>
                                    {{end -}}
                                </select>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label" lay-tips="Maximum length参数指定了OpenAI API中文本生成模型的最大输出长度。它可以防止模型生成过长的文本，从而减少计算资源的消耗。请求最多可以使用在提示和完成之间共享的 2048 或 4000个字符。确切的限制因型号而异。(对于普通英文文本，一个标记大约是4个字符)">最大长度:</label>
                            <div class="layui-input-block">
                                <div id="intro-max_tokens" class="slider-block"></div>
                                <input type="hidden" name="intro.max_tokens" value="{{.obj.Intro.MaxTokens}}">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label" lay-tips="它可以控制生成文本的多样性。Temperature参数越高，生成的文本就越多样化，但也可能会出现更多的语法错误和不通顺的句子。Temperature参数越低，生成的文本就越简单，但也可能会出现更多的重复句子。">温度:</label>
                            <div class="layui-input-block">
                                <div id="intro-temperature" class="slider-block"></div>
                                <input type="hidden" name="intro.temperature" value="{{.obj.Intro.Temperature}}">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label" lay-tips="它用于控制生成的文本的多样性。它控制了模型生成的文本中最高概率的词语的比例，以便模型可以生成更多样化的文本。">TopP:</label>
                            <div class="layui-input-block">
                                <div id="intro-top_p" class="slider-block"></div>
                                <input type="hidden" name="intro.top_p" value="{{.obj.Intro.TopP}}">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label" lay-tips="它的作用是控制算法在搜索过程中对频繁出现的结果的惩罚。它可以帮助算法更好地探索搜索空间，从而更有可能找到更好的结果。">频率惩罚:</label>
                            <div class="layui-input-block">
                                <div id="intro-frequency_penalty" class="slider-block"></div>
                                <input type="hidden" name="intro.frequency_penalty" value="{{.obj.Intro.FrequencyPenalty}}">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label" lay-tips="它的作用是用来控制AI模型中的缺失值惩罚。它可以用来控制AI模型对缺失值的惩罚程度，从而改善模型的准确性和性能。">存在惩罚:</label>
                            <div class="layui-input-block">
                                <div id="intro-presence_penalty" class="slider-block"></div>
                                <input type="hidden" name="intro.presence_penalty" value="{{.obj.Intro.PresencePenalty}}">
                            </div>
                        </div>
                    </div>
                    <div class="layui-col-sm8">
                        <div class="layui-input-block" style="margin:0 10px 0 10px;">
                            <div class="layui-col-sm12">
                                <textarea name="intro.prompt" rows="16" class="layui-textarea" placeholder="写作要求">{{.obj.Intro.Prompt}}</textarea>
                                <div class="insert-var">
                                    <label class="layui-form-label" style="padding:5px 15px;color:coral">插入变量:</label>
                                    <button class="layui-btn layui-btn-xs layui-btn-radius layui-btn-primary" data-write="&#123;&#123;keyword&#125;&#125;">
                                        关键词变量
                                    </button>
                                    <button class="layui-btn layui-btn-xs layui-btn-radius layui-btn-primary" data-write="&#123;&#123;brand&#125;&#125;">
                                        品牌变量
                                    </button>
                                </div>
                                <div class="layui-inline" style="float: right">
                                    <div class="layui-btn-group">
                                        <button class="layui-btn layui-btn-xs" data-value="intro" data-event="test">测试
                                        </button>
                                        <button class="layui-btn layui-btn-xs layui-btn-primary" data-value="intro" data-event="result">
                                            查看结果
                                        </button>
                                    </div>
                                </div>
                                <div class="layui-col-sm8">
                                    <textarea name="intro.olds" class="layui-textarea" placeholder="正则表达式&#10;<([a-z]+?)>">{{join .obj.Intro.Olds "\n"}}</textarea>
                                </div>
                                <div class="layui-col-sm4">
                                    <textarea name="intro.news" class="layui-textarea" placeholder="替换为&#10;<${1}>">{{join .obj.Intro.News "\n"}}</textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="layui-tab-item layui-row">
                    <div class="layui-col-sm4">
                        <div class="layui-form-item">
                            <label for="content-user_id" class="layui-form-label">秘钥:</label>
                            <div class="layui-input-block">
                                <select name="content.user_id" id="content-user_id" lay-search>
                                    <option value="0">随机秘钥</option>
                                    <option value="-1"{{if eq .obj.Content.UserId -1}} selected{{end}}>最新秘钥</option>
                                    {{range .users -}}
                                        <option value="{{.Id}}"{{if eq .Id $.obj.Content.UserId}} selected{{end}}>{{.Key}}</option>
                                    {{end -}}
                                </select>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label for="content-model" class="layui-form-label">模型:</label>
                            <div class="layui-input-block">
                                <select id="content-model" name="content.model" lay-search>
                                    {{range $i,$v:= .models -}}
                                        <option value="{{$v}}"{{if eq $v $.obj.Content.Model}} selected{{end}}>{{$v}}</option>
                                    {{end -}}
                                </select>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label for="content-role" class="layui-form-label">角色:</label>
                            <div class="layui-input-block">
                                <select id="content-role" name="content.role" lay-search>
                                    {{range $i,$v:= .roles -}}
                                        <option value="{{$v}}"{{if eq $v $.obj.Content.Role}} selected{{end}}>{{$v}}</option>
                                    {{end -}}
                                </select>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label" lay-tips="Maximum length参数指定了OpenAI API中文本生成模型的最大输出长度。它可以防止模型生成过长的文本，从而减少计算资源的消耗。请求最多可以使用在提示和完成之间共享的 2048 或 4000个字符。确切的限制因型号而异。(对于普通英文文本，一个标记大约是4个字符)">最大长度:</label>
                            <div class="layui-input-block">
                                <div id="content-max_tokens" class="slider-block"></div>
                                <input type="hidden" name="content.max_tokens" value="{{.obj.Content.MaxTokens}}">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label" lay-tips="它可以控制生成文本的多样性。Temperature参数越高，生成的文本就越多样化，但也可能会出现更多的语法错误和不通顺的句子。Temperature参数越低，生成的文本就越简单，但也可能会出现更多的重复句子。">温度:</label>
                            <div class="layui-input-block">
                                <div id="content-temperature" class="slider-block"></div>
                                <input type="hidden" name="content.temperature" value="{{.obj.Content.Temperature}}">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label" lay-tips="它用于控制生成的文本的多样性。它控制了模型生成的文本中最高概率的词语的比例，以便模型可以生成更多样化的文本。">TopP:</label>
                            <div class="layui-input-block">
                                <div id="content-top_p" class="slider-block"></div>
                                <input type="hidden" name="content.top_p" value="{{.obj.Content.TopP}}">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label" lay-tips="它的作用是控制算法在搜索过程中对频繁出现的结果的惩罚。它可以帮助算法更好地探索搜索空间，从而更有可能找到更好的结果。">频率惩罚:</label>
                            <div class="layui-input-block">
                                <div id="content-frequency_penalty" class="slider-block"></div>
                                <input type="hidden" name="content.frequency_penalty" value="{{.obj.Content.FrequencyPenalty}}">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label" lay-tips="它的作用是用来控制AI模型中的缺失值惩罚。它可以用来控制AI模型对缺失值的惩罚程度，从而改善模型的准确性和性能。">存在惩罚:</label>
                            <div class="layui-input-block">
                                <div id="content-presence_penalty" class="slider-block"></div>
                                <input type="hidden" name="content.presence_penalty" value="{{.obj.Content.PresencePenalty}}">
                            </div>
                        </div>
                    </div>
                    <div class="layui-col-sm8">
                        <div class="layui-input-block" style="margin:0 10px 0 10px;">
                            <textarea name="content.prompt" rows="16" class="layui-textarea" placeholder="写作要求">{{.obj.Content.Prompt}}</textarea>
                            <div class="insert-var">
                                <label class="layui-form-label" style="padding:5px 15px;color:coral">插入变量:</label>
                                <button class="layui-btn layui-btn-xs layui-btn-radius layui-btn-primary" data-write="&#123;&#123;keyword&#125;&#125;">
                                    关键词变量
                                </button>
                                <button class="layui-btn layui-btn-xs layui-btn-radius layui-btn-primary" data-write="&#123;&#123;brand&#125;&#125;">
                                    品牌变量
                                </button>
                            </div>
                            <div class="layui-inline" style="float:right;">
                                <div class="layui-btn-group">
                                    <button class="layui-btn layui-btn-xs" data-value="content" data-event="test">测试
                                    </button>
                                    <button class="layui-btn layui-btn-xs layui-btn-primary" data-value="content" data-event="result">
                                        查看结果
                                    </button>
                                </div>
                            </div>
                            <div class="layui-col-sm8">
                                <textarea name="content.olds" class="layui-textarea" placeholder="正则表达式&#10;<([a-z]+?)>">{{join .obj.Content.Olds "\n"}}</textarea>
                            </div>
                            <div class="layui-col-sm4">
                                <textarea name="content.news" class="layui-textarea" placeholder="替换为&#10;<${1}>">{{join .obj.Content.News "\n"}}</textarea>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="layui-tab-item layui-row">
                    <div class="layui-col-sm4">
                        <div class="layui-form-item">
                            <label for="end-user_id" class="layui-form-label">秘钥:</label>
                            <div class="layui-input-block">
                                <select name="end.user_id" id="end-user_id" lay-search>
                                    <option value="0">随机秘钥</option>
                                    <option value="-1"{{if eq .obj.End.UserId -1}} selected{{end}}>最新秘钥</option>
                                    {{range .users -}}
                                        <option value="{{.Id}}"{{if eq .Id $.obj.End.UserId}} selected{{end}}>{{.Key}}</option>
                                    {{end -}}
                                </select>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label for="end-model" class="layui-form-label">模型:</label>
                            <div class="layui-input-block">
                                <select id="end-model" name="end.model" lay-search>
                                    {{range $i,$v:= .models -}}
                                        <option value="{{$v}}"{{if eq $v $.obj.End.Model}} selected{{end}}>{{$v}}</option>
                                    {{end -}}
                                </select>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label for="end-role" class="layui-form-label">角色:</label>
                            <div class="layui-input-block">
                                <select id="end-role" name="end.role" lay-search>
                                    {{range $i,$v:= .roles -}}
                                        <option value="{{$v}}"{{if eq $v $.obj.End.Role}} selected{{end}}>{{$v}}</option>
                                    {{end -}}
                                </select>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label" lay-tips="Maximum length参数指定了OpenAI API中文本生成模型的最大输出长度。它可以防止模型生成过长的文本，从而减少计算资源的消耗。请求最多可以使用在提示和完成之间共享的 2048 或 4000个字符。确切的限制因型号而异。(对于普通英文文本，一个标记大约是4个字符)">最大长度:</label>
                            <div class="layui-input-block">
                                <div id="end-max_tokens" class="slider-block"></div>
                                <input type="hidden" name="end.max_tokens" value="{{.obj.End.MaxTokens}}">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label" lay-tips="它可以控制生成文本的多样性。Temperature参数越高，生成的文本就越多样化，但也可能会出现更多的语法错误和不通顺的句子。Temperature参数越低，生成的文本就越简单，但也可能会出现更多的重复句子。">温度:</label>
                            <div class="layui-input-block">
                                <div id="end-temperature" class="slider-block"></div>
                                <input type="hidden" name="end.temperature" value="{{.obj.End.Temperature}}">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label" lay-tips="它用于控制生成的文本的多样性。它控制了模型生成的文本中最高概率的词语的比例，以便模型可以生成更多样化的文本。">TopP:</label>
                            <div class="layui-input-block">
                                <div id="end-top_p" class="slider-block"></div>
                                <input type="hidden" name="end.top_p" value="{{.obj.End.TopP}}">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label" lay-tips="它的作用是控制算法在搜索过程中对频繁出现的结果的惩罚。它可以帮助算法更好地探索搜索空间，从而更有可能找到更好的结果。">频率惩罚:</label>
                            <div class="layui-input-block">
                                <div id="end-frequency_penalty" class="slider-block"></div>
                                <input type="hidden" name="end.frequency_penalty" value="{{.obj.End.FrequencyPenalty}}">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label" lay-tips="它的作用是用来控制AI模型中的缺失值惩罚。它可以用来控制AI模型对缺失值的惩罚程度，从而改善模型的准确性和性能。">存在惩罚:</label>
                            <div class="layui-input-block">
                                <div id="end-presence_penalty" class="slider-block"></div>
                                <input type="hidden" name="end.presence_penalty" value="{{.obj.End.PresencePenalty}}">
                            </div>
                        </div>
                    </div>
                    <div class="layui-col-sm8">
                        <div class="layui-input-block" style="margin:0 10px 0 10px;">
                            <div class="layui-col-sm12">
                                <textarea name="end.prompt" rows="16" class="layui-textarea" placeholder="写作要求">{{.obj.End.Prompt}}</textarea>
                                <div class="insert-var">
                                    <label class="layui-form-label" style="padding:5px 15px;color:coral">插入变量:</label>
                                    <button class="layui-btn layui-btn-xs layui-btn-radius layui-btn-primary" data-write="&#123;&#123;keyword&#125;&#125;">
                                        关键词变量
                                    </button>
                                    <button class="layui-btn layui-btn-xs layui-btn-radius layui-btn-primary" data-write="&#123;&#123;brand&#125;&#125;">
                                        品牌变量
                                    </button>
                                </div>
                                <div class="layui-inline" style="float:right;">
                                    <div class="layui-btn-group">
                                        <button class="layui-btn layui-btn-xs" data-value="end" data-event="test">测试
                                        </button>
                                        <button class="layui-btn layui-btn-xs layui-btn-primary" data-value="end" data-event="result">
                                            查看结果
                                        </button>
                                    </div>
                                </div>
                                <div class="layui-col-sm8">
                                    <textarea name="end.olds" class="layui-textarea" placeholder="正则表达式&#10;<([a-z]+?)>">{{join .obj.End.Olds "\n"}}</textarea>
                                </div>
                                <div class="layui-col-sm4">
                                    <textarea name="end.news" class="layui-textarea" placeholder="替换为&#10;<${1}>">{{join .obj.End.News "\n"}}</textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="layui-hide">
                <input name="id" value="{{.obj.Id}}">
                <button lay-submit lay-filter="submit"></button>
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
        //监控选择网站ID
        form.on('select(site_id)', function (obj) {
            bindClass(obj.value);
        });
        // 定时选择器
        main.cron('[name=spec]');
        $('[data-event=result]').on('click', function () {
            main.ws.log("openai.stream." + $(this).data('value'));
        });
        $('[data-event=test]').on('click', function () {
            let data = form.val('form');
            data.action = $(this).data('value');
            if (!data[data.action + '.prompt']) {
                return main.error('写作要求不可以为空');
            }
            main.request({
                url: URL + '/test',
                data: data,
                done: function () {
                    main.ws.log("openai.stream." + data.action);
                    return false;
                }
            });
        });
        //滑块控制
        main.slider(
            {elem: '#intro-max_tokens', min: 1, max: 4000},
            {elem: '#intro-temperature', min: 0, max: 200},
            {elem: '#intro-top_p', min: 0, max: 100},
            {elem: '#intro-frequency_penalty', min: 0, max: 200},
            {elem: '#intro-presence_penalty', min: 0, max: 200},
            {elem: '#content-max_tokens', min: 1, max: 4000},
            {elem: '#content-temperature', min: 0, max: 200},
            {elem: '#content-top_p', min: 0, max: 100},
            {elem: '#content-frequency_penalty', min: 0, max: 200},
            {elem: '#content-presence_penalty', min: 0, max: 200},
            {elem: '#end-max_tokens', min: 1, max: 4000},
            {elem: '#end-temperature', min: 0, max: 200},
            {elem: '#end-top_p', min: 0, max: 100},
            {elem: '#end-frequency_penalty', min: 0, max: 200},
            {elem: '#end-presence_penalty', min: 0, max: 200},
        );
    });
</script>