{{template "header.tpl" .}}
<div id="wrap">
    <div class="main container">
        <div class="content">
            <article class="post-24881 post type-post status-publish format-standard hentry category-news" id="post-24881">
                <div class="entry-info" style="margin-bottom:10px;">{{HTML .Positions}}</div>
                <div class="entry">
                    <div class="entry-head">
                        <h1 class="entry-title">{{.Article.Title}}</h1>
                        <div class="entry-info">
                            <span class="dot">日期:</span>
                            <span>{{date .Article.Updated "2006-01-02 15:04"}}</span>
                            <span>来源：{{source}}</span>
                            <span>点击：<script src="{{.Config.Hostname}}/hot.js?aid={{.Article.Id}}"></script>次</span>
                        </div>
                    </div>
                    <div class="entry-content clearfix">{{HTML .Article.Content}}</div>
                    <div id="pages">
                        {{- range .Tags}} {{.}} {{- end}}
                    </div>
                    <div class="entry-footer">
                        <h3 class="entry-related-title">相关推荐</h3>
                        <ul class="entry-related clearfix">
                            {{- range like 10}}
                            <li><img alt="{{.Title}} " class="j-lazy" src="{{.TitlePic}}">{{HTML .}}</li>
                            {{- end}}
                        </ul>
                    </div>
                </div>
            </article>
        </div>
        <!--aside-->
        {{template "aside.tpl" .}}
    </div>
</div>
{{template "footer.tpl" .}}