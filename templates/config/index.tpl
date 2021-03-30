<style>
    .cron .layui-input-inline {
        width: 50%;
    }

    .cron .layui-inline {
        width: 18%;
    }

    .cron .layui-input-block {
        margin-left: 80px;
    }

    .cron .layui-form-label {
        width: auto;
    }
</style>
<div class="layui-card">
    <div class="layui-card-body">
        <div class="layui-tab layui-tab-card">
            <ul class="layui-tab-title">
                <li class="layui-this">基本设置</li>
                <li>环境设置</li>
                <li>采集设置</li>
                <li>违禁设置</li>
                <li>监控服务</li>
            </ul>
            <div class="layui-tab-content">
                <div class="layui-tab-item layui-show layui-form">
                    <div class="layui-row">
                        <div class="layui-col-md3">
                            <div class="layui-form-item">
                                <label class="layui-form-label">用户名:</label>
                                <div class="layui-input-block">
                                    <input type="text" name="username" value="{{.base.Username}}" class="layui-input">
                                </div>
                            </div>
                        </div>
                        <div class="layui-col-md3">
                            <div class="layui-form-item">
                                <label class="layui-form-label">Host:</label>
                                <div class="layui-input-block">
                                    <input type="text" name="addr" value="{{.base.Addr}}" class="layui-input">
                                </div>
                            </div>
                        </div>
                        <div class="layui-col-md3">
                            <div class="layui-form-item">
                                <label class="layui-form-label">端口:</label>
                                <div class="layui-input-block">
                                    <input type="text" name="port" value="{{.base.Port}}" class="layui-input">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="layui-row">
                        <div class="layui-col-md3">
                            <div class="layui-form-item">
                                <label class="layui-form-label">运行模式:</label>
                                <div class="layui-input-block">
                                    <input type="radio" name="run_mode" value="prod"
                                           title="正常"{{if eq .base.RunMode "prod"}} checked{{end}}>
                                    <input type="radio" name="run_mode" value="dev"
                                           title="调试"{{if eq .base.RunMode "dev"}} checked{{end}}>
                                </div>
                            </div>
                        </div>
                        <div class="layui-col-md2">
                            <div class="layui-form-item">
                                <label class="layui-form-label">Gzip:</label>
                                <div class="layui-input-block">
                                    <input type="checkbox" name="gzip_enabled"
                                           lay-skin="switch" lay-text="打开|关闭"{{if .base.GzipEnabled}} checked{{end}}>
                                </div>
                            </div>
                        </div>
                        <div class="layui-col-md2">
                            <div class="layui-form-item">
                                <label class="layui-form-label">CSRF:</label>
                                <div class="layui-input-block">
                                    <input type="checkbox" name="csrf_enabled"
                                           lay-skin="switch" lay-text="打开|关闭"{{if .base.CsrfEnabled}} checked{{end}}>
                                </div>
                            </div>
                        </div>
                        <div class="layui-col-md2">
                            <div class="layui-form-item">
                                <label class="layui-form-label">广告缓存:</label>
                                <div class="layui-input-block">
                                    <input type="checkbox" name="ad_cached"
                                           lay-skin="switch" lay-text="打开|关闭"{{if .base.AdCached}} checked{{end}}>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">登录限制:</label>
                        <div class="layui-input-inline">
                            <input type="text" name="limit_login" value="{{.base.LimitLogin}}" class="layui-input">
                        </div>
                        <div class="layui-form-mid layui-word-aux">登录错误次数超过将限制N分钟后登录 0为不限制录</div>
                    </div>
                    <div class="layui-row">
                        <div class="layui-col-md5">
                            <div class="layui-form-item">
                                <label class="layui-form-label">csrf秘钥:</label>
                                <div class="layui-input-block">
                                    <input type="text" name="csrf_secret"
                                           value="{{.base.CsrfSecret}}" class="layui-input">
                                </div>
                            </div>
                        </div>
                        <div class="layui-col-md5">
                            <div class="layui-form-item">
                                <label class="layui-form-label">PhpMyAdmin:</label>
                                <div class="layui-input-block">
                                    <input type="text" name="php_my_admin_name" value="{{.base.PhpMyAdminName}}"
                                           class="layui-input">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="layui-row">
                        <div class="layui-col-md5">
                            <div class="layui-form-item">
                                <label class="layui-form-label">定时排名:</label>
                                <div class="layui-input-block">
                                    <input type="text" name="rank_spec" value="{{.base.RankSpec}}" class="layui-input">
                                </div>
                            </div>
                        </div>
                        <div class="layui-col-md5">
                            <div class="layui-form-item">
                                <label class="layui-form-label">定时重启:</label>
                                <div class="layui-input-block">
                                    <input type="text" name="reboot_spec" value="{{.base.RebootSpec}}"
                                           class="layui-input">
                                </div>
                            </div>
                        </div>
                    </div>
                    <input type="hidden" name="uid" value="{{.base.Uid}}">
                    <div class="layui-form-item">
                        <label class="layui-form-label"></label>
                        <div class="layui-btn-group">
                            <button class="layui-btn" lay-submit lay-filter="submit-base">立即提交</button>
                            <button class="layui-btn" data-event="reset" data-name="base" data-tip="Base 恢复出厂设置?">恢复默认
                            </button>
                        </div>
                    </div>
                </div>
                <div class="layui-tab-item layui-form">
                    {{.serverHtml}}
                    <div class="layui-form-item">
                        <label class="layui-form-label"></label>
                        <div class="layui-btn-group">
                            <button class="layui-btn" lay-submit lay-filter="submit-server">立即提交
                            </button>
                            <button class="layui-btn" data-event="reset" data-name="server" data-tip="Server 恢复出厂设置?">
                                恢复默认
                            </button>
                            <button class="layui-btn layui-btn-danger" data-event="reset" data-name="app"
                                    data-tip="抹去本程序所有数据?包括所建的网站等...">重置App
                            </button>
                        </div>
                    </div>
                </div>
                <div class="layui-tab-item layui-form">
                    {{.spiderHtml -}}
                    <div class="layui-form-item">
                        <label class="layui-form-label"></label>
                        <div class="layui-btn-group">
                            <button class="layui-btn" lay-submit lay-filter="submit-data">立即提交
                            </button>
                            <button class="layui-btn layui-btn-danger" data-event="reset" data-name="data"
                                    data-tip="清空所有已经采集的数据?不可恢复!">
                                清空采集数据
                            </button>
                        </div>
                    </div>
                </div>
                <div class="layui-tab-item layui-form">
                    {{.banHtml -}}
                    <div class="layui-form-item">
                        <label class="layui-form-label"></label>
                        <div class="layui-btn-group">
                            <button class="layui-btn" lay-submit lay-filter="submit-ban">立即提交</button>
                            <button class="layui-btn layui-btn-danger" data-event="reset" data-name="ban"
                                    data-tip="违禁设置恢复到出厂设置?">恢复默认
                            </button>
                            <button class="layui-btn" data-event="ban-test">测试</button>
                            <button class="layui-btn layui-btn-small layui-btn-normal" data-event="edit-ban">编辑禁词
                            </button>
                            <button class="layui-btn" data-event="ban-update" lay-tips="远程更新禁词">更新禁词</button>
                        </div>
                    </div>
                </div>
                <div class="layui-tab-item layui-form">
                    <fieldset class="layui-elem-field">
                        <legend>定时设置</legend>
                        <div class="layui-form-item">
                            <div class="layui-row cron">
                                <div class="layui-col-md2">
                                    <label class="layui-form-label">启用:</label>
                                    <div class="layui-input-inline">
                                        <input type="checkbox" name="enabled"
                                               lay-skin="switch" lay-text="启用|关闭"{{if .monitor.Enabled}} checked{{end}}>
                                    </div>
                                </div>
                                <div class="layui-col-md2">
                                    <label class="layui-form-label" lay-tips="0-59 *-,">分:</label>
                                    <div class="layui-input-inline">
                                        <input type="text" name="minute" value="{{.monitor.Minute}}"
                                               class="layui-input">
                                    </div>
                                </div>
                                <div class="layui-col-md2">
                                    <label class="layui-form-label" lay-tips="0-23 *-,">时:</label>
                                    <div class="layui-input-inline">
                                        <input type="text" name="hour" value="{{.monitor.Hour}}"
                                               class="layui-input">
                                    </div>
                                </div>
                                <div class="layui-col-md2">
                                    <label class="layui-form-label" lay-tips="1-31 *-,">天:</label>
                                    <div class="layui-input-inline">
                                        <input type="text" name="day" value="{{.monitor.Day}}"
                                               class="layui-input">
                                    </div>
                                </div>
                                <div class="layui-col-md2">
                                    <label class="layui-form-label" lay-tips="1-12 *-,">月:</label>
                                    <div class="layui-input-inline">
                                        <input type="text" name="month" value="{{.monitor.Month}}"
                                               class="layui-input">
                                    </div>
                                </div>
                                <div class="layui-col-md2">
                                    <label class="layui-form-label" lay-tips="0-6 *-,">周:</label>
                                    <div class="layui-input-inline">
                                        <input type="text" name="week" value="{{.monitor.Week}}"
                                               class="layui-input">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </fieldset>
                    <fieldset class="layui-elem-field">
                        <legend>监控服务设置</legend>
                        <div lay-filter="monitor"></div>
                    </fieldset>
                    <div class="layui-form-item">
                        <label class="layui-form-label"></label>
                        <div class="layui-btn-group">
                            <button class="layui-btn layui-btn-primary" lay-event="add" lay-tips="添加监控服务">
                                <i class="layui-icon layui-icon-addition"></i>
                            </button>
                            <button class="layui-btn" lay-submit lay-filter="submit-monitor">立即提交
                            </button>
                            <button class="layui-btn layui-btn-danger" data-event="reset" data-name="monitor"
                                    data-tip="监控设置恢复到出厂设置?">恢复默认
                            </button>
                            <button class="layui-btn" data-event="status" data-name="monitor"
                                    data-tip="查看定时状态">查看状态
                            </button>
                        </div>
                    </div>


                    <div id="layui-laydate1" class="layui-laydate layui-laydate-range" style="left: 0px; top: 0px;">
                        <div class="layui-laydate-main laydate-main-list-0 laydate-time-show">
                            <div class="layui-laydate-header">
                                <i class="layui-icon laydate-icon laydate-prev-y"></i><i class="layui-icon laydate-icon laydate-prev-m"></i>
                                <div class="laydate-set-ym">
                                    <span lay-ym="2021-3" lay-type="year">2021年</span><span lay-ym="2021-3" lay-type="month">3月</span><span class="laydate-time-text">开始时间</span>
                                </div>
                                <i class="layui-icon laydate-icon laydate-next-m"></i><i class="layui-icon laydate-icon laydate-next-y"></i>
                            </div>
                            <div class="layui-laydate-content">
                                <table>
                                    <thead>
                                    <tr>
                                        <th>日</th>
                                        <th>一</th>
                                        <th>二</th>
                                        <th>三</th>
                                        <th>四</th>
                                        <th>五</th>
                                        <th>六</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <td class="laydate-day-prev" lay-ymd="2021-2-28">28</td>
                                        <td lay-ymd="2021-3-1" class="">1</td>
                                        <td lay-ymd="2021-3-2" class="">2</td>
                                        <td lay-ymd="2021-3-3" class="">3</td>
                                        <td lay-ymd="2021-3-4" class="">4</td>
                                        <td lay-ymd="2021-3-5" class="">5</td>
                                        <td lay-ymd="2021-3-6" class="">6</td>
                                    </tr>
                                    <tr>
                                        <td lay-ymd="2021-3-7" class="">7</td>
                                        <td lay-ymd="2021-3-8" class="">8</td>
                                        <td lay-ymd="2021-3-9" class="">9</td>
                                        <td lay-ymd="2021-3-10" class="">10</td>
                                        <td lay-ymd="2021-3-11" class="">11</td>
                                        <td lay-ymd="2021-3-12" class="">12</td>
                                        <td lay-ymd="2021-3-13" class="">13</td>
                                    </tr>
                                    <tr>
                                        <td lay-ymd="2021-3-14" class="">14</td>
                                        <td lay-ymd="2021-3-15" class="">15</td>
                                        <td lay-ymd="2021-3-16" class="">16</td>
                                        <td lay-ymd="2021-3-17" class="">17</td>
                                        <td lay-ymd="2021-3-18" class="">18</td>
                                        <td lay-ymd="2021-3-19" class="">19</td>
                                        <td lay-ymd="2021-3-20" class="">20</td>
                                    </tr>
                                    <tr>
                                        <td lay-ymd="2021-3-21" class="">21</td>
                                        <td lay-ymd="2021-3-22" class="">22</td>
                                        <td lay-ymd="2021-3-23" class="">23</td>
                                        <td lay-ymd="2021-3-24" class="">24</td>
                                        <td lay-ymd="2021-3-25" class="">25</td>
                                        <td lay-ymd="2021-3-26" class="">26</td>
                                        <td lay-ymd="2021-3-27" class="">27</td>
                                    </tr>
                                    <tr>
                                        <td lay-ymd="2021-3-28" class="">28</td>
                                        <td lay-ymd="2021-3-29" class="">29</td>
                                        <td lay-ymd="2021-3-30" class="">30</td>
                                        <td lay-ymd="2021-3-31" class="">31</td>
                                        <td class="laydate-day-next" lay-ymd="2021-4-1">1</td>
                                        <td class="laydate-day-next" lay-ymd="2021-4-2">2</td>
                                        <td class="laydate-day-next" lay-ymd="2021-4-3">3</td>
                                    </tr>
                                    <tr>
                                        <td class="laydate-day-next" lay-ymd="2021-4-4">4</td>
                                        <td class="laydate-day-next" lay-ymd="2021-4-5">5</td>
                                        <td class="laydate-day-next" lay-ymd="2021-4-6">6</td>
                                        <td class="laydate-day-next" lay-ymd="2021-4-7">7</td>
                                        <td class="laydate-day-next" lay-ymd="2021-4-8">8</td>
                                        <td class="laydate-day-next" lay-ymd="2021-4-9">9</td>
                                        <td class="laydate-day-next" lay-ymd="2021-4-10">10</td>
                                    </tr>
                                    </tbody>
                                </table>
                                <ul class="layui-laydate-list laydate-time-list">
                                    <li><p>时</p>
                                        <ol>
                                            <li class="layui-this">00</li>
                                            <li class="">01</li>
                                            <li class="">02</li>
                                            <li class="">03</li>
                                            <li class="">04</li>
                                            <li class="">05</li>
                                            <li class="">06</li>
                                            <li class="">07</li>
                                            <li class="">08</li>
                                            <li class="">09</li>
                                            <li class="">10</li>
                                            <li class="">11</li>
                                            <li class="">12</li>
                                            <li class="">13</li>
                                            <li class="">14</li>
                                            <li class="">15</li>
                                            <li class="">16</li>
                                            <li class="">17</li>
                                            <li class="">18</li>
                                            <li class="">19</li>
                                            <li class="">20</li>
                                            <li class="">21</li>
                                            <li class="">22</li>
                                            <li class="">23</li>
                                        </ol>
                                    </li>
                                    <li><p>分</p>
                                        <ol>
                                            <li class="layui-this">00</li>
                                            <li class="">01</li>
                                            <li class="">02</li>
                                            <li class="">03</li>
                                            <li class="">04</li>
                                            <li class="">05</li>
                                            <li class="">06</li>
                                            <li class="">07</li>
                                            <li class="">08</li>
                                            <li class="">09</li>
                                            <li class="">10</li>
                                            <li class="">11</li>
                                            <li class="">12</li>
                                            <li class="">13</li>
                                            <li class="">14</li>
                                            <li class="">15</li>
                                            <li class="">16</li>
                                            <li class="">17</li>
                                            <li class="">18</li>
                                            <li class="">19</li>
                                            <li class="">20</li>
                                            <li class="">21</li>
                                            <li class="">22</li>
                                            <li class="">23</li>
                                            <li class="">24</li>
                                            <li class="">25</li>
                                            <li class="">26</li>
                                            <li class="">27</li>
                                            <li class="">28</li>
                                            <li class="">29</li>
                                            <li class="">30</li>
                                            <li class="">31</li>
                                            <li class="">32</li>
                                            <li class="">33</li>
                                            <li class="">34</li>
                                            <li class="">35</li>
                                            <li class="">36</li>
                                            <li class="">37</li>
                                            <li class="">38</li>
                                            <li class="">39</li>
                                            <li class="">40</li>
                                            <li class="">41</li>
                                            <li class="">42</li>
                                            <li class="">43</li>
                                            <li class="">44</li>
                                            <li class="">45</li>
                                            <li class="">46</li>
                                            <li class="">47</li>
                                            <li class="">48</li>
                                            <li class="">49</li>
                                            <li class="">50</li>
                                            <li class="">51</li>
                                            <li class="">52</li>
                                            <li class="">53</li>
                                            <li class="">54</li>
                                            <li class="">55</li>
                                            <li class="">56</li>
                                            <li class="">57</li>
                                            <li class="">58</li>
                                            <li class="">59</li>
                                        </ol>
                                    </li>
                                    <li><p>秒</p>
                                        <ol>
                                            <li class="layui-this">00</li>
                                            <li class="">01</li>
                                            <li class="">02</li>
                                            <li class="">03</li>
                                            <li class="">04</li>
                                            <li class="">05</li>
                                            <li class="">06</li>
                                            <li class="">07</li>
                                            <li class="">08</li>
                                            <li class="">09</li>
                                            <li class="">10</li>
                                            <li class="">11</li>
                                            <li class="">12</li>
                                            <li class="">13</li>
                                            <li class="">14</li>
                                            <li class="">15</li>
                                            <li class="">16</li>
                                            <li class="">17</li>
                                            <li class="">18</li>
                                            <li class="">19</li>
                                            <li class="">20</li>
                                            <li class="">21</li>
                                            <li class="">22</li>
                                            <li class="">23</li>
                                            <li class="">24</li>
                                            <li class="">25</li>
                                            <li class="">26</li>
                                            <li class="">27</li>
                                            <li class="">28</li>
                                            <li class="">29</li>
                                            <li class="">30</li>
                                            <li class="">31</li>
                                            <li class="">32</li>
                                            <li class="">33</li>
                                            <li class="">34</li>
                                            <li class="">35</li>
                                            <li class="">36</li>
                                            <li class="">37</li>
                                            <li class="">38</li>
                                            <li class="">39</li>
                                            <li class="">40</li>
                                            <li class="">41</li>
                                            <li class="">42</li>
                                            <li class="">43</li>
                                            <li class="">44</li>
                                            <li class="">45</li>
                                            <li class="">46</li>
                                            <li class="">47</li>
                                            <li class="">48</li>
                                            <li class="">49</li>
                                            <li class="">50</li>
                                            <li class="">51</li>
                                            <li class="">52</li>
                                            <li class="">53</li>
                                            <li class="">54</li>
                                            <li class="">55</li>
                                            <li class="">56</li>
                                            <li class="">57</li>
                                            <li class="">58</li>
                                            <li class="">59</li>
                                        </ol>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <div class="layui-laydate-main laydate-main-list-1 laydate-time-show">
                            <div class="layui-laydate-header">
                                <i class="layui-icon laydate-icon laydate-prev-y"></i><i class="layui-icon laydate-icon laydate-prev-m"></i>
                                <div class="laydate-set-ym">
                                    <span lay-ym="2021-4" lay-type="year">2021年</span><span lay-ym="2021-4" lay-type="month">4月</span><span class="laydate-time-text">结束时间</span>
                                </div>
                                <i class="layui-icon laydate-icon laydate-next-m"></i><i class="layui-icon laydate-icon laydate-next-y"></i>
                            </div>
                            <div class="layui-laydate-content">
                                <table>
                                    <thead>
                                    <tr>
                                        <th>日</th>
                                        <th>一</th>
                                        <th>二</th>
                                        <th>三</th>
                                        <th>四</th>
                                        <th>五</th>
                                        <th>六</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <td class="laydate-day-prev" lay-ymd="2021-3-28">28</td>
                                        <td class="laydate-day-prev" lay-ymd="2021-3-29">29</td>
                                        <td class="laydate-day-prev" lay-ymd="2021-3-30">30</td>
                                        <td class="laydate-day-prev" lay-ymd="2021-3-31">31</td>
                                        <td lay-ymd="2021-4-1" class="">1</td>
                                        <td lay-ymd="2021-4-2" class="">2</td>
                                        <td lay-ymd="2021-4-3" class="">3</td>
                                    </tr>
                                    <tr>
                                        <td lay-ymd="2021-4-4" class="">4</td>
                                        <td lay-ymd="2021-4-5" class="">5</td>
                                        <td lay-ymd="2021-4-6" class="">6</td>
                                        <td lay-ymd="2021-4-7" class="">7</td>
                                        <td lay-ymd="2021-4-8" class="">8</td>
                                        <td lay-ymd="2021-4-9" class="">9</td>
                                        <td lay-ymd="2021-4-10" class="">10</td>
                                    </tr>
                                    <tr>
                                        <td lay-ymd="2021-4-11" class="">11</td>
                                        <td lay-ymd="2021-4-12" class="">12</td>
                                        <td lay-ymd="2021-4-13" class="">13</td>
                                        <td lay-ymd="2021-4-14" class="">14</td>
                                        <td lay-ymd="2021-4-15" class="">15</td>
                                        <td lay-ymd="2021-4-16" class="">16</td>
                                        <td lay-ymd="2021-4-17" class="">17</td>
                                    </tr>
                                    <tr>
                                        <td lay-ymd="2021-4-18" class="">18</td>
                                        <td lay-ymd="2021-4-19" class="">19</td>
                                        <td lay-ymd="2021-4-20" class="">20</td>
                                        <td lay-ymd="2021-4-21" class="">21</td>
                                        <td lay-ymd="2021-4-22" class="">22</td>
                                        <td lay-ymd="2021-4-23" class="">23</td>
                                        <td lay-ymd="2021-4-24" class="">24</td>
                                    </tr>
                                    <tr>
                                        <td lay-ymd="2021-4-25" class="">25</td>
                                        <td lay-ymd="2021-4-26" class="">26</td>
                                        <td lay-ymd="2021-4-27" class="">27</td>
                                        <td lay-ymd="2021-4-28" class="">28</td>
                                        <td lay-ymd="2021-4-29" class="">29</td>
                                        <td lay-ymd="2021-4-30" class="">30</td>
                                        <td class="laydate-day-next" lay-ymd="2021-5-1">1</td>
                                    </tr>
                                    <tr>
                                        <td class="laydate-day-next" lay-ymd="2021-5-2">2</td>
                                        <td class="laydate-day-next" lay-ymd="2021-5-3">3</td>
                                        <td class="laydate-day-next" lay-ymd="2021-5-4">4</td>
                                        <td class="laydate-day-next" lay-ymd="2021-5-5">5</td>
                                        <td class="laydate-day-next" lay-ymd="2021-5-6">6</td>
                                        <td class="laydate-day-next" lay-ymd="2021-5-7">7</td>
                                        <td class="laydate-day-next" lay-ymd="2021-5-8">8</td>
                                    </tr>
                                    </tbody>
                                </table>
                                <ul class="layui-laydate-list laydate-time-list">
                                    <li><p>时</p>
                                        <ol>
                                            <li class="layui-this">00</li>
                                            <li class="">01</li>
                                            <li class="">02</li>
                                            <li class="">03</li>
                                            <li class="">04</li>
                                            <li class="">05</li>
                                            <li class="">06</li>
                                            <li class="">07</li>
                                            <li class="">08</li>
                                            <li class="">09</li>
                                            <li class="">10</li>
                                            <li class="">11</li>
                                            <li class="">12</li>
                                            <li class="">13</li>
                                            <li class="">14</li>
                                            <li class="">15</li>
                                            <li class="">16</li>
                                            <li class="">17</li>
                                            <li class="">18</li>
                                            <li class="">19</li>
                                            <li class="">20</li>
                                            <li class="">21</li>
                                            <li class="">22</li>
                                            <li class="">23</li>
                                        </ol>
                                    </li>
                                    <li><p>分</p>
                                        <ol>
                                            <li class="layui-this">00</li>
                                            <li class="">01</li>
                                            <li class="">02</li>
                                            <li class="">03</li>
                                            <li class="">04</li>
                                            <li class="">05</li>
                                            <li class="">06</li>
                                            <li class="">07</li>
                                            <li class="">08</li>
                                            <li class="">09</li>
                                            <li class="">10</li>
                                            <li class="">11</li>
                                            <li class="">12</li>
                                            <li class="">13</li>
                                            <li class="">14</li>
                                            <li class="">15</li>
                                            <li class="">16</li>
                                            <li class="">17</li>
                                            <li class="">18</li>
                                            <li class="">19</li>
                                            <li class="">20</li>
                                            <li class="">21</li>
                                            <li class="">22</li>
                                            <li class="">23</li>
                                            <li class="">24</li>
                                            <li class="">25</li>
                                            <li class="">26</li>
                                            <li class="">27</li>
                                            <li class="">28</li>
                                            <li class="">29</li>
                                            <li class="">30</li>
                                            <li class="">31</li>
                                            <li class="">32</li>
                                            <li class="">33</li>
                                            <li class="">34</li>
                                            <li class="">35</li>
                                            <li class="">36</li>
                                            <li class="">37</li>
                                            <li class="">38</li>
                                            <li class="">39</li>
                                            <li class="">40</li>
                                            <li class="">41</li>
                                            <li class="">42</li>
                                            <li class="">43</li>
                                            <li class="">44</li>
                                            <li class="">45</li>
                                            <li class="">46</li>
                                            <li class="">47</li>
                                            <li class="">48</li>
                                            <li class="">49</li>
                                            <li class="">50</li>
                                            <li class="">51</li>
                                            <li class="">52</li>
                                            <li class="">53</li>
                                            <li class="">54</li>
                                            <li class="">55</li>
                                            <li class="">56</li>
                                            <li class="">57</li>
                                            <li class="">58</li>
                                            <li class="">59</li>
                                        </ol>
                                    </li>
                                    <li><p>秒</p>
                                        <ol>
                                            <li class="layui-this">00</li>
                                            <li class="">01</li>
                                            <li class="">02</li>
                                            <li class="">03</li>
                                            <li class="">04</li>
                                            <li class="">05</li>
                                            <li class="">06</li>
                                            <li class="">07</li>
                                            <li class="">08</li>
                                            <li class="">09</li>
                                            <li class="">10</li>
                                            <li class="">11</li>
                                            <li class="">12</li>
                                            <li class="">13</li>
                                            <li class="">14</li>
                                            <li class="">15</li>
                                            <li class="">16</li>
                                            <li class="">17</li>
                                            <li class="">18</li>
                                            <li class="">19</li>
                                            <li class="">20</li>
                                            <li class="">21</li>
                                            <li class="">22</li>
                                            <li class="">23</li>
                                            <li class="">24</li>
                                            <li class="">25</li>
                                            <li class="">26</li>
                                            <li class="">27</li>
                                            <li class="">28</li>
                                            <li class="">29</li>
                                            <li class="">30</li>
                                            <li class="">31</li>
                                            <li class="">32</li>
                                            <li class="">33</li>
                                            <li class="">34</li>
                                            <li class="">35</li>
                                            <li class="">36</li>
                                            <li class="">37</li>
                                            <li class="">38</li>
                                            <li class="">39</li>
                                            <li class="">40</li>
                                            <li class="">41</li>
                                            <li class="">42</li>
                                            <li class="">43</li>
                                            <li class="">44</li>
                                            <li class="">45</li>
                                            <li class="">46</li>
                                            <li class="">47</li>
                                            <li class="">48</li>
                                            <li class="">49</li>
                                            <li class="">50</li>
                                            <li class="">51</li>
                                            <li class="">52</li>
                                            <li class="">53</li>
                                            <li class="">54</li>
                                            <li class="">55</li>
                                            <li class="">56</li>
                                            <li class="">57</li>
                                            <li class="">58</li>
                                            <li class="">59</li>
                                        </ol>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <div class="layui-laydate-footer">
                            <div class="laydate-footer-btns"><span lay-type="clear" class="laydate-btns-clear">清空</span><span lay-type="confirm" class="laydate-btns-confirm">确定</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/html" id="monitor">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">服务名称:</label>
            <div class="layui-input-inline">
                <input name="services.name." class="layui-input" value="">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">运行特征:</label>
            <div class="layui-input-inline">
                <input name="services.run_mark." class="layui-input" value="">
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">停止特征:</label>
            <div class="layui-input-inline">
                <input name="services.stop_mark." class="layui-input" value="">
            </div>
        </div>
        <i class="layui-icon layui-icon-delete" lay-event="del" lay-tips="删除该条服务监控"></i>
    </div>
</script>
{{template "JS" -}}
<script>
    JS.use(['index', 'main'], function () {
        let $ = layui.$,
            layer = layui.layer,
            main = layui.main,
            form = layui.form,
            services = {{.monitor.Services}},
            url = {{.current_uri}},
            addService = function (index, option) {
                option = option || {};
                let dom = $($('#monitor').html());
                dom.find('[name]').each(function () {
                    $(this).attr('name', this.name + index);
                });
                $.each(option, function (k, v) {
                    dom.find('[name^="services.' + k + '."]').val(v);
                });
                $('div[lay-filter="monitor"]').append(dom);
            };
        if (services) {
            $.each(services, function (index, v) {
                addService(index + 1, v);
            });
            form.render();
            main.on.del();
        }
        main.on.add(function () {
            let name = $('[lay-filter="monitor"] [name^="services.name."]').last().attr('name'),
                names = [],
                index = 0;
            if (name) {
                names = name.split('.');
                index = parseInt(names[names.length - 1]) || 0;
            }
            addService(index + 1);
        });
        form.on('submit(submit-base)', function (obj) {
            main.req({
                url: url + '/base',
                data: obj.field,
            });
            return false;
        });
        form.on('submit(submit-server)', function (obj) {
            main.req({
                url: url + '/server',
                data: obj.field,
            });
            return false;
        });
        form.on('submit(submit-monitor)', function (obj) {
            main.req({
                url: url + '/monitor',
                data: obj.field,
            });
            return false;
        });
        form.on('submit(submit-ban)', function (obj) {
            main.req({
                url: url + '/ban',
                data: obj.field,
            });
            return false;
        });
        form.on('submit(submit-data)', function (obj) {
            main.req({
                url: url + '/data',
                data: obj.field,
            });
            return false;
        });
        $('.layui-btn[data-event]').on('click', function () {
            let othis = $(this),
                event = othis.data('event'),
                tip, name;
            switch (event) {
                case 'ban-update':
                    main.req({
                        url: url + '/ban/update',
                    });
                    break;
                case 'status':
                    name = othis.data('name');
                    tip = othis.data('tip');
                    if (name.length === 0) {
                        return false;
                    }
                    layer.confirm(tip, function (index) {
                        main.req({
                            url: url + '/status',
                            data: {name: name},
                            index: index,
                            tips: function (res) {
                                main.msg(res.msg);
                            },
                        });
                    });
                    break;
                case 'reset':
                    name = othis.data('name');
                    tip = othis.data('tip');
                    if (name.length === 0) {
                        return false;
                    }
                    layer.confirm(tip, function (index) {
                        main.req({
                            url: url + '/reset',
                            data: {name: name},
                            index: index,
                            ending: function () {
                                document.location.reload();
                            }
                        });
                    });
                    break;
                case 'ban-test':
                    main.popup({
                        title: '测试违禁词',
                        url: url + '/ban/test',
                        area: ['70%', '70%'],
                        tips: function (res) {
                            main.msg(`<textarea class="layui-textarea layui-bg-black" name="content" rows="10" style="color: white;">` + res.msg.replaceAll("<br/>", "\n") + `</textarea>`, {area: ['500px', 'auto']});
                        },
                        content: '<div class="layui-card"><div class="layui-card-body layui-form"><div class="layui-form-item"><textarea class="layui-textarea layui-bg-black" name="content" rows="15" style="color: white;">输入需要检查的内容...</textarea></div><div class="layui-hide"><button class="layui-btn" lay-submit lay-filter="submit"></button></div></div></div>'
                    });
                    break;
                case 'edit-ban':
                    $.get('/config/ban/data', function (html) {
                        main.popup({
                            title: '编辑禁词',
                            content: html,
                            url: '/config/ban/data'
                        });
                    });
                    break
            }
            return false;
        });
    });
</script>