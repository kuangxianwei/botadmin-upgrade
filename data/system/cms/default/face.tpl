{{template "header.tpl" .}}
<section class="container">
    <div class="content-wrap">
        <div class="content">
            <div class="carousel slide" data-ride="carousel" id="focusslide">
                <ol class="carousel-indicators">
                    <li class="active" data-slide-to="0" data-target="#focusslide"></li>
                    <li data-slide-to="1" data-target="#focusslide"></li>
                    <li data-slide-to="2" data-target="#focusslide"></li>
                </ol>
                <div class="carousel-inner" role="listbox">
                    {{- range $i,$v:=loop "" 0 3 "title_pic=1"}}
                    <div class="item{{if eq $i 0}} active{{end}}">
                        <a href="{{$v.Url}}" target="_blank" title="{{$v.Title}}"><img alt="{{$v.Title}}" src="{{$v.TitlePic}}" width="100%"></a>
                    </div>
                    {{- end}}
                </div>
            </div>
            <div class="sec-panel main-list">
                <div class="sec-panel-head" style="background-color:#FFFFFF">
                    <ul class="list tabs" id="j-newslist">
                        <li class="tab active"><a href="javascript:void(0);">最新文章</a></li>
                        {{- range children 12}}
                        <li class="tab"><a href="{{.Url}}" target="_blank" title="{{.Alias}}">{{.Name}}</a></li>
                        {{- end}}
                    </ul>
                </div>
                {{- range loop "" 0 15}}
                <article class="excerpt excerpt-1">
                    {{- if .TitlePic -}}
                    <a class="focus" href="{{.Url}}" target="_blank" title="{{.Title}}"><img alt="{{.Title}}" class="thumb" src="{{.TitlePic}}"></a>
                    {{- end}}
                    <header>
                        <div class="cat">{{class .Cid | HTML}}<i></i></div>
                        <h2><a href="{{.Url}}" target="_blank" title="{{.Title}}">{{.Title}}</a></h2>
                    </header>
                    <p class="meta">
                        <time><i class="fa fa-clock-o"></i>{{date .Updated "2006-01-02 15:04:05"}}</time>
                    </p>
                    <p class="note">{{sub .Description 180}}</p>
                </article>
                {{- end}}
            </div>
        </div>
    </div>
    <div class="sidebar">
        <div class="widget widget_ui_textasb">
            {{- range loop "" 0 3 "level=1,2"}}
            <a class="style02" href="{{.Url}}" target="_blank" title="{{.Title}}"><strong>特别推荐</strong>
                <h2>{{.Title}}</h2>
                <p>{{sub .Description 32}}...</p>
            </a>
            {{- end}}
        </div>
        <div class="widget widget_ui_posts xiaoquzb"><h3>站长推荐</h3>
            <ul>
                {{- range loop "" 0 10 "level=3,4,5,6"}}
                <li><a href="{{.Url}}" target="_blank" title="{{.Title}}"><span class="text">{{.Title}}</span></a></li>
                {{- end}}
            </ul>
        </div>
        <div class="widget widget_ui_posts"><h3>热门文章</h3>
            <ul>
                {{- range loop "" 1 12 "title_pic=1"}}
                <li>
                    <a href="{{.Url}}" target="_blank" title="{{.Title}}"><span class="thumbnail"><img alt="{{.Title}}" class="thumb" src="{{.TitlePic}}"></span><span class="text">{{.Title}}</span><span class="muted">{{date .Updated "2006-01-02"}}</span></a>
                </li>
                {{- end}}
            </ul>
        </div>
        <div class="widget widget_text"></div>
    </div>
</section>
{{template "footer.tpl" .}}