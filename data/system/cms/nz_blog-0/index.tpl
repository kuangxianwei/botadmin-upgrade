{{template "header.tpl" .}}
<div id="wrap">
    <div class="main container">
        <div class="content">
            <div class="slider-wrap clearfix">
                <div class="main-slider flexslider pull-left">
                    <ul class="slides"><!--推荐4-3条-随机-带图-->
                        {{- range loop "" 1 3 "level=1,2,3,4,5,6" "title_pic=1"}}
                            <li class="slide-item">
                                <a href="{{.Url}}" target="_blank" title="{{.Title}}">{{imgHTML .}}</a>
                                <h3 class="slide-title">{{HTML .}}</h3>
                            </li>
                        {{- end}}
                    </ul>
                </div>
                <ul class="feature-post pull-right"><!--推2-3条-带图-->
                    {{- range loop "" 0 3 "level=1,2,3,4" "title_pic=1"}}
                        <li>
                            <a href="{{.Url}}" target="_blank" title="{{.Title}}">{{imgHTML .}}</a>
                            <span>{{sub .Title 15}}</span>
                        </li>
                    {{- end}}
                </ul>
            </div>
            <div class="sec-panel topic-recommend">
                <div class="sec-panel-head">
                    <h2>热点推荐</h2>
                </div>
                <div class="sec-panel-body">
                    <ul class="list topic-list">
                        {{- range loop "" 1 4 "level=1,2,4,5,6" "title_pic=1"}}
                            <li class="topic">
                                <a class="topic-wrap" href="{{.Url}}" target="_blank" title="{{.Title}}">
                                    <div class="cover-container">
                                        <img alt="{{.Title}}" src="{{.TitlePic}} " style="width:198px;height:124px">
                                    </div>
                                    <span>{{sub .Title 15}} </span>
                                </a>
                            </li>
                        {{- end}}
                    </ul>
                </div>
            </div>
            <div class="sec-panel main-list">
                <div class="sec-panel-head">
                    <ul class="list tabs" id="j-newslist">
                        <li class="tab active">
                            <a data-id="0" href="javascript:void(0);">最新文章</a>
                        </li>
                    </ul>
                </div>
                <ul class="article-list tab-list active"><!--调用最新15条-->
                    {{- range loop "" 0 15}}
                        <li class="item">
                            <div class="item-img">
                                <a href="{{.Url}}" target="_blank" title="{{.Title}}">
                                    <img alt="{{.Title}}" class="j-lazy" height="300" src="{{.TitlePic}}" style="display: inline;" width="480">
                                </a>
                            </div>
                            <div class="item-content item-content2">
                                <h2 class="item-title">{{HTML .}}</h2>
                                <div class="item-excerpt"><p>{{sub .Description 50}}</p></div>
                                <div class="item-meta">
                                    <span class="item-meta-li date">{{date .Updated "2006-01-02 15:04:05"}}</span>
                                </div>
                            </div>
                        </li>
                    {{- end}}
                </ul>
            </div>
        </div>
        <!--aside-->
        {{template "aside.tpl" .}}
    </div>
</div>
<!--footer-->
{{template "footer.tpl" .}}