<style>
    input[data-field] + .layui-unselect {
        margin-top: 3px;
        margin-bottom: 3px;
    }
</style>
<div class="layui-card layui-form">
    <div class="layui-card-body">
        <fieldset class="layui-elem-field">
            <legend>修改目标</legend>
            <input type="checkbox" data-field="ad" title="广告代码" lay-filter="field">
            <input type="checkbox" data-field="replaces" title="灰词替换" lay-filter="field">
            <input type="checkbox" data-field="contact" title="联系方式" lay-filter="field">
            <input type="checkbox" data-field="insert_pic_deg" title="插图阈值" lay-filter="field">
            <input type="checkbox" data-field="pub_deg" title="发布阈值" lay-filter="field">
            <input type="checkbox" data-field="content_deg" title="内容阈值" lay-filter="field">
            <input type="checkbox" data-field="link_deg" title="内链阀值" lay-filter="field">
            <input type="checkbox" data-field="out_link_deg" title="外链阀值" lay-filter="field">
            <input type="checkbox" data-field="title_tag_deg" title="标题阀值" lay-filter="field">
            <input type="checkbox" data-field="pub_self" title="指定发布" lay-filter="field">
            <input type="checkbox" data-field="cron_enabled" title="定时发布" lay-filter="field">
            <input type="checkbox" data-field="push_config" title="推送配置" lay-filter="field">
            <input type="checkbox" data-field="originality_rate" title="原创阀值" lay-filter="field">
            <input type="checkbox" data-field="pic_save" title="保存远图" lay-filter="field">
            <input type="checkbox" data-field="pic_mark" title="图片水印" lay-filter="field">
            <input type="checkbox" data-field="order" title="发布顺序" lay-filter="field">
            <input type="checkbox" data-field="publish_mode" title="发布模式" lay-filter="field">
            <input type="checkbox" data-field="auth_code" title="认证码" lay-filter="field">
        </fieldset>
        <fieldset class="layui-elem-field">
            <legend>操作</legend>
            <div id="field"></div>
        </fieldset>
        <div class="layui-hide">
            <input name="ids" value="{{.ids}}">
            <button lay-submit></button>
        </div>
    </div>
</div>
<script type="text/html" id="contact-html">
    <div class="layui-form-item">
        <label class="layui-form-label" lay-tips="李谊:139-2235-2985 一行一条">联系方式:</label>
        <div class="layui-input-block">
            {{$contact:=`李谊:139-2235-2985
韩晶:135-3983-5229` -}}
            <textarea name="contact" class="layui-textarea" placeholder="{{$contact}}"></textarea>
        </div>
    </div>
</script>
<script>
    layui.use(['main'], function () {
        let form = layui.form,
            main = layui.main,
            fieldElem = $("#field");
        form.on('checkbox(field)', function (obj) {
            switch ($(this).attr('data-field')) {
                case 'ad':
                    if (obj.othis.attr('class').indexOf('layui-form-checked') !== -1) {
                        fieldElem.append(`<div class="layui-form-item">
    <label class="layui-form-label" lay-tips="网站广告代码一般为js代码">广告:</label>
    <div class="layui-input-block">
        <textarea name="ad" class="layui-textarea" placeholder="网站广告代码一般为js代码"></textarea>
    </div>
</div>`);
                    } else {
                        fieldElem.find('[name=ad]').closest('.layui-form-item').remove();
                    }
                    break;
                case 'replaces':
                    if (obj.othis.attr('class').indexOf('layui-form-checked') !== -1) {
                        fieldElem.append(`<div class="layui-form-item">
    <label class="layui-form-label" lay-tips="灰词=>替换成的是词 一行一条">灰词替换:</label>
    <div class="layui-input-block">
        <textarea name="replaces" class="layui-textarea"></textarea>
    </div>
</div>`);
                    } else {
                        fieldElem.find('[name=replaces]').closest('.layui-form-item').remove();
                    }
                    break;
                case 'contact':
                    if (obj.othis.attr('class').indexOf('layui-form-checked') !== -1) {
                        fieldElem.append($('#contact-html').html());
                    } else {
                        fieldElem.find('[name=contact]').closest('.layui-form-item').remove();
                    }
                    break;
                case 'insert_pic_deg':
                    if (obj.othis.attr('class').indexOf('layui-form-checked') !== -1) {
                        fieldElem.append(`<div class="layui-form-item">
                        <label class="layui-form-label">插图阈值:</label>
                        <div class="layui-input-inline">
                            <div id="insert_pic_deg" class="slider-inline"></div>
                            <input type="hidden" name="insert_pic_deg" value="0-3">
                        </div>
                        <div class="layui-form-mid layui-word-aux">随机插入图片数量</div>
                    </div>`);
                        main.slider({elem: '#insert_pic_deg', range: true});
                    } else {
                        fieldElem.find('[name=insert_pic_deg]').closest('.layui-form-item').remove();
                    }
                    break;
                case 'pub_deg':
                    if (obj.othis.attr('class').indexOf('layui-form-checked') !== -1) {
                        fieldElem.append(`<div class="layui-form-item">
                        <label class="layui-form-label" lay-tips="随机发布指定数量的文章">发布阈值:</label>
                        <div class="layui-input-block">
                            <div id="pub_deg" class="slider-block"></div>
                            <input type="hidden" name="pub_deg" value="1-3"/>
                        </div>
                    </div>`);
                        main.slider({elem: '#pub_deg', range: true, max: 100});
                    } else {
                        fieldElem.find('[name=pub_deg]').closest('.layui-form-item').remove();
                    }
                    break;
                case 'content_deg':
                    if (obj.othis.attr('class').indexOf('layui-form-checked') !== -1) {
                        fieldElem.append(`<div class="layui-form-item">
                        <label class="layui-form-label">内容阈值:</label>
                        <div class="layui-input-inline">
                            <div id="content_deg" class="slider-inline"></div>
                            <input type="hidden" name="content_deg" value="1-3"/>
                        </div>
                        <div class="layui-form-mid layui-word-aux">内容内随机插入关键词数量</div>
                    </div>`);
                        main.slider({elem: '#content_deg', range: true});
                    } else {
                        fieldElem.find('[name=content_deg]').closest('.layui-form-item').remove();
                    }
                    break;
                case 'link_deg':
                    if (obj.othis.attr('class').indexOf('layui-form-checked') !== -1) {
                        fieldElem.append(`<div class="layui-form-item">
                        <label class="layui-form-label">内链阀值:</label>
                        <div class="layui-input-inline">
                            <div id="link_deg" class="slider-inline"></div>
                            <input type="hidden" name="link_deg" value="3">
                        </div>
                        <div class="layui-form-mid layui-word-aux">随机插入内链</div>
                    </div>`);
                        main.slider({elem: '#link_deg', value: 3});
                    } else {
                        fieldElem.find('[name=link_deg]').closest('.layui-form-item').remove();
                    }
                    break;
                case 'out_link_deg':
                    if (obj.othis.attr('class').indexOf('layui-form-checked') !== -1) {
                        fieldElem.append(`<div class="layui-form-item">
                        <label class="layui-form-label">外链阀值:</label>
                        <div class="layui-input-inline">
                            <div id="out_link_deg" class="slider-inline"></div>
                            <input type="hidden" name="out_link_deg" value="0">
                        </div>
                        <div class="layui-form-mid layui-word-aux">随机插入外链</div>
                    </div>`);
                        main.slider({elem: '#out_link_deg', value: 0});
                    } else {
                        fieldElem.find('[name=out_link_deg]').closest('.layui-form-item').remove();
                    }
                    break;
                case 'title_tag_deg':
                    if (obj.othis.attr('class').indexOf('layui-form-checked') !== -1) {
                        fieldElem.append(`<div class="layui-form-item">
                        <label class="layui-form-label">标题阀值:</label>
                        <div class="layui-input-inline">
                            <div id="title_tag_deg" class="slider-inline"></div>
                            <input type="hidden" name="title_tag_deg" value="3">
                        </div>
                        <div class="layui-form-mid layui-word-aux">标题插入tag 值越高 几率越高</div>
                    </div>`);
                        main.slider({elem: '#title_tag_deg', value: 3});
                    } else {
                        fieldElem.find('[name=title_tag_deg]').closest('.layui-form-item').remove();
                    }
                    break;
                case 'pub_self':
                    if (obj.othis.attr('class').indexOf('layui-form-checked') !== -1) {
                        fieldElem.append(`<div class="layui-form-item">
                        <label class="layui-form-label">指定发布:</label>
                        <div class="layui-input-inline">
                            <input type="checkbox" name="pub_self" lay-skin="switch" lay-text="是|否" checked>
                        </div>
                        <div class="layui-form-mid layui-word-aux">限制只发布隶属本站文章</div>
                    </div>`);
                        form.render('checkbox');
                    } else {
                        fieldElem.find('[name=pub_self]').closest('.layui-form-item').remove();
                    }
                    break;
                case 'cron_enabled':
                    if (obj.othis.attr('class').indexOf('layui-form-checked') !== -1) {
                        fieldElem.append(`<div class="layui-form-item">
    <label class="layui-form-label">定时发布:</label>
    <div class="layui-input-inline">
        <input type="checkbox" name="cron_enabled" lay-skin="switch" lay-text="是|否" checked>
    </div>
    <div class="layui-form-mid layui-word-aux">是否启用定时发布任务</div>
</div>`);
                        form.render('checkbox');
                    } else {
                        fieldElem.find('[name=cron_enabled]').closest('.layui-form-item').remove();
                    }
                    break;
                case 'push_config':
                    if (obj.othis.attr('class').indexOf('layui-form-checked') !== -1) {
                        fieldElem.append(`<div class="layui-form-item">
    <label class="layui-form-label">推送配置:</label>
    <div class="layui-input-block">
<textarea name="push_config" class="layui-textarea" rows="3"
          placeholder="http://data.zz.baidu.com/urls?site=&#123;&#123;site&#125;&#125;&token=zjoYZiTU6B1rgblL 百度普通推送 账号=username 密码=password"></textarea>
    </div>
</div>`);
                    } else {
                        fieldElem.find('[name=push_config]').closest('.layui-form-item').remove();
                    }
                    break;
                case 'originality_rate':
                    if (obj.othis.attr('class').indexOf('layui-form-checked') !== -1) {
                        fieldElem.append(`<div class="layui-form-item">
                        <label class="layui-form-label">原创度:</label>
                        <div class="layui-input-inline">
                            <div id="originality_rate" class="slider-inline"></div>
                            <input type="hidden" name="originality_rate" value="0">
                        </div>
                        <div class="layui-form-mid layui-word-aux">大于或等于这个值才发布</div>
                    </div>`);
                        main.slider({elem: '#originality_rate', value: 0, max: 100});
                    } else {
                        fieldElem.find('[name=originality_rate]').closest('.layui-form-item').remove();
                    }
                    break;
                case 'pic_save':
                    if (obj.othis.attr('class').indexOf('layui-form-checked') !== -1) {
                        fieldElem.append(`<div class="layui-form-item">
                        <label class="layui-form-label">保存图片:</label>
                        <div class="layui-input-inline">
                            <input type="checkbox" name="pic_save" lay-skin="switch" lay-text="是|否">
                        </div>
                        <div class="layui-form-mid layui-word-aux">是否保存远程图片</div>
                    </div>`);
                        form.render('checkbox');
                    } else {
                        fieldElem.find('[name=pic_save]').closest('.layui-form-item').remove();
                    }
                    break;
                case 'pic_mark':
                    if (obj.othis.attr('class').indexOf('layui-form-checked') !== -1) {
                        fieldElem.append(`<div class="layui-form-item">
                        <label class="layui-form-label">图片水印:</label>
                        <div class="layui-input-inline">
                            <input type="checkbox" name="pic_mark" lay-skin="switch" lay-text="是|否">
                        </div>
                        <div class="layui-form-mid layui-word-aux">图片是否加水印</div>
                    </div>`);
                        form.render('checkbox');
                    } else {
                        fieldElem.find('[name=pic_mark]').closest('.layui-form-item').remove();
                    }
                    break;
                case 'order':
                    if (obj.othis.attr('class').indexOf('layui-form-checked') !== -1) {
                        fieldElem.append(`<div class="layui-form-item">
                        <label class="layui-form-label">发布顺序:</label>
                        <div class="layui-input-inline">
                            <select name="order" class="layui-select">
                                <option value="0" selected>最新采集</option>
                                <option value="1">最旧采集</option>
                                <option value="2">随机</option>
                            </select>
                        </div>
                        <div class="layui-form-mid layui-word-aux">发布文章顺序</div>
                    </div>`);
                        form.render('select');
                    } else {
                        fieldElem.find('[name=order]').closest('.layui-form-item').remove();
                    }
                    break;
                case 'publish_mode':
                    if (obj.othis.attr('class').indexOf('layui-form-checked') !== -1) {
                        fieldElem.append(`<div class="layui-form-item">
                        <label class="layui-form-label">发布模式:</label>
                        <div class="layui-input-inline">
                            <select name="publish_mode" class="layui-select">
                                <option value="0" selected>随机模式</option>
                                <option value="1">正常模式</option>
                                <option value="2">百科模式</option>
                            </select>
                        </div>
                    </div>`);
                        form.render('select');
                    } else {
                        fieldElem.find('[name=publish_mode]').closest('.layui-form-item').remove();
                    }
                    break;
                case 'auth_code':
                    if (obj.othis.attr('class').indexOf('layui-form-checked') !== -1) {
                        fieldElem.append(`<div class="layui-form-item">
    <label class="layui-form-label" lay-tips="网站后台登录认证码 15个字母或数字组成">认证码:</label>
    <div class="layui-input-inline">
        <input type="text" name="auth_code" class="layui-input" value="" placeholder="登录第二验证码">
    </div>
    <button class="layui-btn" id="auth_code">随机</button>
</div>`);
                        form.render('input');
                        $('#auth_code').off('click').on('click',function () {
                            $('input[name=auth_code]').val(main.uuid(15));
                        });
                        $('input[name=auth_code]').val(main.uuid(15));
                    } else {
                        fieldElem.find('[name=auth_code]').closest('.layui-form-item').remove();
                    }
                    break;
            }
        });
    });
</script>
