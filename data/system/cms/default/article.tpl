{{template "header.tpl" .}}
<section class="container">
    <div class="list-head">{{HTML .Positions}}</div>
    <div class="content-wrap">
        <div class="content">
            <header class="article-header"><h1 class="article-title">{{.Article.Title}}</h1>
                <div class="article-meta">
<span class="item">{{date .Article.Updated "2006-01-02 15:04"}}</span>
<span class="item">来源：{{source}}</span>
<span class="item">点击：<script src="{{.Config.Hostname}}/hot.js?aid={{.Article.Id}}"></script>次</span>
</div>
            </header>
            <article class="article-content"> {{HTML .Article.Content}}</article>
            <div class="dw-box dw-box-info"><p>郑重声明：本文版权归原作者所有，转载文章仅为传播更多信息之目的，如作者信息标记有误，请第一时间联系我们修改或删除，多谢。</p></div>
            <div class="article_footer clearfix">
                <div class="fr tag">标签：{{- range .Tags}} {{.}} {{- end}}</div>
            </div>
            <nav class="article-nav">
                <span class="article-nav-prev">上一篇<br>{{.PreNext.Pre}}</span>
                <span class="article-nav-next">下一篇<br> {{.PreNext.Next}}</span>
            </nav>
            <div class="relates relates-thumb">
                <div class="title"><h3>猜你喜欢</h3></div>
                <ul>
                    {{- range like 10}}
                    <li><a href="{{.Url}}" target="_blank" title="{{.Title}}">{{.Title}}</a></li>
                    {{- end}}
                </ul>
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