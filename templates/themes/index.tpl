<style>
    .item {
        border-radius: 10px;
        background: #0a6e85;
        padding: 10px;
        margin: 10px;
        color: #ffffff;
        box-shadow: -2px 2px 2px #888;
        line-height: 35px;
    }

    .item i, .item > img {
        cursor: pointer;
    }

    .item > h3 > label {
        display: inline-block;
        overflow: hidden;
        margin-right: 10px;
    }

    .item > h3 > span {
        display: inline-block;
        width: 72%;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
    }

    .item > h3 > i {
        display: inline-block;
        float: right;
    }

    .item > h4 {
        margin-top: 10px;
        text-align: center;
    }

    .item > img {
        width: 100%;
        height: 200px;
        border-radius: 10px;
        margin-bottom: 10px;
        box-shadow: -2px 2px 2px #888;
    }
</style>
<div class="layui-card">
    <div class="layui-card-body">
        <button class="layui-btn" id="upload"><i class="layui-icon layui-icon-upload"></i>上传主题</button>
        只支持tar.gz 或者.zip 的压缩文件
    </div>
</div>
<div class="layui-row layui-col-space10">
    {{range $theme:=.themes -}}
        <div class="layui-col-md3">
            <div class="item" data-theme="{{json $theme}}">
                <img src="/theme/loading.svg" lay-src="{{$theme.Face}}" alt="{{$theme.Name}}" title="{{$theme.Alias}}">
                <h3>
                    <label>名称:</label>
                    <span class="alias">{{$theme.Alias}}</span>
                    <i class="layui-icon layui-icon-edit" data-event="alias"></i>
                </h3>
                <h3>
                    <label>简介:</label>
                    <span class="readme">{{$theme.Readme}}</span>
                    <i class="layui-icon layui-icon-edit" data-event="readme"></i>
                </h3>
                <h4 class="layui-btn-group">
                    <a class="layui-btn layui-btn-primary"
                       lay-href="/file?path=data/template/{{$theme.System}}/{{$theme.Name}}"
                       lay-text="{{$theme.Alias}}主题">主题<i class="layui-icon layui-icon-edit"></i></a>
                    <button class="layui-btn layui-btn-primary" data-event="face">换封面</button>
                    <button class="layui-btn layui-bg-red" data-event="del">删除</button>
                </h4>
            </div>
        </div>
    {{end -}}
</div>
<script type="text/html" id="edit">
    <div class="layui-form">
        <input name="alias" class="layui-input" value="">
        <textarea class="layui-textarea" name="readme" rows="6" lay-verify="required"></textarea>
        <input type="hidden" name="system" value="">
        <input type="hidden" name="name" value="">
        <input type="hidden" name="event" value="">
        <button class="layui-hide" lay-submit lay-filter="submit">提交</button>
    </div>
</script>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let main = layui.main,
            flow = layui.flow,
            upload = layui.upload,
            editHtml = $('#edit').html(),
            assign = function (othis, data) {
                othis.data('theme', data);
                othis.attr('data-theme', JSON.stringify(data));
                othis.find('img').attr({src: data.face, alt: data.name, title: data.alias});
                othis.find('.alias').text(data.alias);
                othis.find('.readme').text(data.readme);
                othis.find('a[lay-href][lay-text]').attr({
                    'lay-href': '/file?path=data/template/' + data.system + '/' + data.name,
                    'lay-text': data.alias + '主题',
                });
            };
        flow.lazyimg();
        $('.item>img').click(function () {
            main.msg('<img src="' + this.src + '" width="100%" height="auto">', {area: ['80%', '80%']});
        });
        $('.item [data-event]').click(function () {
            let othis = $(this), event = othis.data('event'), parentThis = othis.closest('.item'),
                theme = parentThis.data('theme');
            switch (event) {
                case 'readme':
                    main.popup({
                        title: '编辑说明',
                        url: '/themes/modify',
                        area: ['400px', '250px'],
                        content: editHtml,
                        success: function (dom) {
                            dom.find('[name=alias]').remove();
                            dom.find('[name=readme]').val(theme.readme);
                            dom.find('[name=system]').val(theme.system);
                            dom.find('[name=name]').val(theme.name);
                            dom.find('[name=event]').val(event);
                        },
                        ending: function (res) {
                            assign(parentThis, res.data);
                        },
                    });
                    break;
                case 'alias':
                    main.popup({
                        title: '编辑名称',
                        url: '/themes/modify',
                        area: ['200px', '150px'],
                        content: editHtml,
                        success: function (dom) {
                            dom.find('[name=alias]').val(theme.alias);
                            dom.find('[name=readme]').remove();
                            dom.find('[name=system]').val(theme.system);
                            dom.find('[name=name]').val(theme.name);
                            dom.find('[name=event]').val(event);
                        },
                        ending: function (res) {
                            assign(parentThis, res.data);
                        }
                    });
                    break;
                case 'face':
                    if ($('#' + theme.name).length === 0) {
                        parentThis.append('<div class="layui-hide" id="' + theme.name + '"></div>');
                    }
                    //普通图片上传
                    upload.render({
                        headers: {'X-CSRF-Token':{{.csrf_token}} },
                        elem: '#' + theme.name,
                        url: '/themes/face',
                        data: theme,
                        acceptMime: 'image/jpg,image/png,image/jpeg,image/gif',
                        done: function (res) {
                            if (res.code === 0) {
                                return parentThis.find($('img')).attr('src', res.data.face);
                            }
                            main.error(res.msg);
                        },
                    });
                    $('#' + theme.name).click();
                    break;
                case 'del':
                    layer.confirm('确定删除该主题?不可恢复', function (index) {
                        main.req({
                            url: '/themes/del',
                            data: theme,
                            ending: function () {
                                parentThis.parent().remove();
                            },
                            index: index
                        });
                    });
                    break;
            }
        });
        //普通图片上传
        upload.render({
            headers: {'X-CSRF-Token':{{.csrf_token}} },
            elem: '#upload',
            url: '/themes/upload',
            data: $('[data-theme]').first().data('theme'),
            exts: 'zip|tar.gz',
            done: function (res) {
                if (res.code === 0) {
                    return location.reload();
                }
                layer.alert(res.msg, {
                    skin: 'layui-layer-admin',
                    shadeClose: true,
                    icon: 2,
                    btn: '',
                    closeBtn: false,
                    anim: 6,
                    success: function (o, index) {
                        let elemClose = $('<i class="layui-icon" close>&#x1006;</i>');
                        o.append(elemClose);
                        elemClose.on('click', function () {
                            layer.close(index);
                        });
                    }
                });
            },
        });
        console.log(document.documentElement.clientHeight);
        console.log($(window).height());
        console.log($(document.body).outerHeight(true));
    });
</script>
