{{template "header.tpl" .}}
<section class="container">
    <div class="content-wrap">
        <div class="content">
            <div class="sec-panel main-list">
                <div class="list-head">{{HTML .Positions}}</div>
                {{- range .List}}
                <article class="excerpt excerpt-1">
                    {{- if .TitlePic -}}
                    <a class="focus" href="{{.Url}}" target="_blank" title="{{.Title}}"><img alt="{{.Title}}" class="thumb" src="{{.TitlePic}}"></a>
                    {{- end -}}
                    <header>
                        <div class="cat">{{$.Class.Alias}}<i></i></div>
                        <h2><a href="{{.Url}}" target="_blank" title="{{.Title}}">{{.Title}}</a></h2></header>
                    <p class="meta">
                        <time><i class="fa fa-clock-o"></i>{{date .Updated "2006-01-02 15:04:05"}}</time>
                    </p>
                    <p class="note">{{sub .Description 150}}</p></article>
                {{- end}}
            </div>
            <div class="pagination">
                <div class="pageBox pTB20">
                    {{HTML .Paginator}}
                </div>
            </div>
        </div>
    </div>
    <div class="sidebar">
        <div class="widget widget_ui_posts"><h3>今日推荐</h3>
            <ul>
                {{- range loop "" 4 18}}
                <li>
                    <a href="{{.Url}}" target="_blank" title="{{.Title}}">
                        {{- if .TitlePic -}}
                        <span class="thumbnail"><img alt="{{.Title}}" class="thumb" src="{{.TitlePic}}"></span>
                        {{- end -}}
                        <span class="text">{{.Title}}</span>
                        <span class="muted">{{date .Updated "2006-01-02"}}</span>
                    </a>
                </li>
                {{- end}}
            </ul>
        </div>
        <div class="widget widget_text"></div>
    </div>
</section>
{{template "footer.tpl" .}}