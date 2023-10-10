<div class="layui-card">
	<div class="layui-card-body layui-form">
		<div class="layui-form-item">
			<div class="layui-inline">
				<label class="layui-form-label">Scheme:</label>
				<div class="layui-input-block">
					<input name="scheme" value="http://" type="radio" title="http://"{{if eq $.obj.Scheme "http://"}} checked{{end}}>
					<input name="scheme" value="https://" type="radio" title="https://"{{if eq $.obj.Scheme "https://"}} checked{{end}}>
				</div>
			</div>
			<div class="layui-inline">
				<label for="host" class="layui-form-label">绑定域名:</label>
				<div class="layui-input-inline">
					<input type="text" name="host" id="host" value="{{.obj.Host}}" lay-verify="required" class="layui-input">
				</div>
			</div>
			<div class="layui-inline">
				<label for="waiter" class="layui-form-label">指定客服:</label>
				<div class="layui-input-block">
					<select name="waiter" id="waiter" class="layui-select">
						<option value="">全部</option>
                        {{range .waiters -}}
							<option value="{{.Username}}">{{.Alias}}</option>
                        {{end -}}
					</select>
				</div>
			</div>
			<div class="layui-inline">
				<button class="layui-btn layui-btn-primary" data-event="copyJS">复制广告代码</button>
			</div>
		</div>
		<div class="layui-form-item">
			<div class="layui-inline">
				<label for="pc_style_id" class="layui-form-label">PC样式:</label>
				<div class="layui-input-inline" style="width:120px">
					<select name="pc_style_id" id="pc_style_id" class="layui-select">
                        {{range $v:=.styles -}}
							<option value="{{$v.Id}}"{{if eq $v.Id $.obj.PcStyleId}} selected{{end}}>{{$v.Name}}</option>
                        {{end -}}
					</select>
				</div>
			</div>
			<div class="layui-inline">
				<label for="mobile_style_id" class="layui-form-label">Mobile样式:</label>
				<div class="layui-input-inline" style="width:120px">
					<select name="mobile_style_id" id="mobile_style_id" class="layui-select">
                        {{range $v:=.styles -}}
							<option value="{{$v.Id}}"{{if eq $v.Id $.obj.MobileStyleId}} selected{{end}}>{{$v.Name}}</option>
                        {{end -}}
					</select>
				</div>
			</div>
			<div class="layui-inline">
				<label for="pc_filter_id" class="layui-form-label">PC过滤:</label>
				<div class="layui-input-inline" style="width:120px">
					<select name="pc_filter_id" id="pc_filter_id" class="layui-select">
						<option value="0">禁用</option>
                        {{range $v:=.filters -}}
							<option value="{{$v.Id}}"{{if eq $v.Id $.obj.PcFilterId}} selected{{end}}>{{$v.Name}}</option>
                        {{end -}}
					</select>
				</div>
			</div>
			<div class="layui-inline">
				<label for="mobile_filter_id" class="layui-form-label">Mobile过滤:</label>
				<div class="layui-input-inline" style="width:120px">
					<select name="mobile_filter_id" id="mobile_filter_id" class="layui-select">
						<option value="0">禁用</option>
                        {{range $v:=.filters -}}
							<option value="{{$v.Id}}"{{if eq $v.Id $.obj.MobileFilterId}} selected{{end}}>{{$v.Name}}</option>
                        {{end -}}
					</select>
				</div>
			</div>
		</div>
		<div class="layui-form-item">
			<label class="layui-form-label">排序依据:</label>
			<div class="layui-input-block">
                {{range $k,$v:=.OrderBys -}}
					<input name="order_by" value="{{$k}}" type="radio"
						   title="{{$v}}"{{if eq $.obj.OrderBy $k}} checked{{end}}>
                {{end -}}
			</div>
		</div>
		<div class="layui-form-item">
			<div class="layui-col-md6">
				<label for="email" class="layui-form-label">电子邮箱:</label>
				<div class="layui-input-inline">
					<input name="email" id="email" value="{{.obj.Email}}" placeholder="38050123@qq.com" class="layui-input">
				</div>
				<div class="layui-form-mid layui-word-aux">主要用于在线留言提醒</div>
			</div>
			<div class="layui-col-md6">
				<label for="deny" class="layui-form-label" lay-tips="匹配(正则)的页面则不显示广告">拒绝广告:</label>
				<div class="layui-input-block">
					<input name="deny" id="deny" value="{{.obj.Deny}}" type="text" class="layui-input" placeholder="\.(php|asp|js|css)(\?|$)">
				</div>
			</div>
		</div>
		<div class="layui-form-item">
			<label for="consult" class="layui-form-label">在线咨询:</label>
			<div class="layui-input-inline" style="width: 50%">
				<input name="consult" id="consult" value="{{.obj.Consult}}" placeholder="http://第三方在线客服链接" class="layui-input">
			</div>
			<div class="layui-form-mid layui-word-aux">第三方在线客服链接</div>
		</div>
		<div class="layui-form-item">
			<div class="layui-col-md6">
				<label for="allowed" class="layui-form-label" lay-tips="一行一条规则(正则)">来路白名单:</label>
				<div class="layui-input-block">
					<textarea id="allowed" class="layui-textarea" name="allowed" placeholder="www.baidu.com&#13;www.sogou.com">{{join .obj.Allowed "\n"}}</textarea>
				</div>
			</div>
			<div class="layui-col-md6">
				<label for="disallowed" class="layui-form-label" lay-tips="一行一条规则(正则)">来路黑名单:</label>
				<div class="layui-input-block">
					<textarea class="layui-textarea" id="disallowed" name="disallowed" placeholder="www.google.com&#13;www.sogou.com">{{join .obj.Disallowed "\n"}}</textarea>
				</div>
			</div>
		</div>
		<div class="layui-form-item">
			<label class="layui-form-label" lay-tips="不选择则展示全部">屏蔽区域:</label>
			<input type="hidden" name="cities" value="{{join .obj.Cities ","}}">
			<div class="layui-form-mid layui-word-aux">
				<i class="layui-icon layui-icon-edit" data-event="cities" style="color:#22849b"></i>
				<cite style="margin-left:10px"></cite>
			</div>
		</div>
		<div class="layui-form-item">
			<label for="duration" class="layui-form-label">开放时间:</label>
			<div class="layui-input-inline">
				<input class="layui-input" id="duration" name="duration" value="{{.obj.Duration}}" placeholder="00:00:00 - 23:59:59">
			</div>
			<div class="layui-form-mid layui-word-aux">不在开放时间范围内则不展示广告</div>
		</div>
		<div class="layui-form-item">
			<label for="other" class="layui-form-label">其他:</label>
			<div class="layui-input-inline" style="width: 50%">
				<textarea id="other" name="other" class="layui-textarea" placeholder="填写Javascript脚本代码" rows="4">{{.obj.Other}}</textarea>
			</div>
			<div class="layui-form-mid layui-word-aux">例如百度统计客服代码</div>
		</div>
		<div class="layui-form-item">
			<button class="layui-btn layui-btn-radius" data-event="submit" lay-submit style="margin-left:40%">提交
			</button>
		</div>
	</div>
</div>
<script src="/static/layui/layui.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let main = layui.main,
            layDate = layui.laydate,
            transfer = layui.transfer,
            citiesData = {{.cityData}},
            cities = {{.obj.Cities}};
        citiesData = citiesData || [];
        cities = cities || [];
        layDate.render({elem: 'input[name=duration]', type: 'time', range: true});
        if (Array.isArray(citiesData) && Array.isArray(cities)) {
            let titles = [];
            for (let i = 0; i < cities.length; i++) {
                cities[i] = cities[i].toString();
            }
            $.each(citiesData, function (i, v) {
                if (cities.indexOf(v.value) !== -1) {
                    titles.push(v.title);
                }
            });
            $('[name=cities]+div>cite').text(titles.join());
        }
        let active = {
            submit: function () {
                main.request({url: URL, data: main.formData()});
            },
            cities: function () {
                main.display({
                    type: 0,
                    btn: ['确定'],
                    content: `<div id="cities"></div>`,
                    success: function (dom) {
                        //显示城市搜索框
                        transfer.render({
                            title: ['全部区域', '屏蔽区域'],
                            id: 'cityData',
                            elem: dom.find('#cities'),
                            data: citiesData,
                            value: $('*[name=cities]').val().split(','),
                            showSearch: true,
                        });
                    },
                    yes: function (index) {
                        let cityData = transfer.getData('cityData'), cities = [], titles = [];
                        $.each(cityData, function (i, v) {
                            cities[i] = v.value;
                            titles[i] = v.title;
                        });
                        $('*[name=cities]').val(cities.join());
                        $('*[name=cities]+div>cite').text(titles.join());
                        layer.close(index);
                    },
                    area: ["540px", "450px"],
                });
            },
            copyJS: function () {
                main.get(URL + '/ad', {waiter: $('select[name=waiter]').val()}, function (jsCode) {
                    main.copy(jsCode, layer.msg('广告JS代码复制成功'));
                });
            }
        };
        $('[data-event]').off('click').on('click', function () {
            let $this = $(this), event = $this.data("event");
            active[event] && active[event].call($this);
        });
    });
</script>