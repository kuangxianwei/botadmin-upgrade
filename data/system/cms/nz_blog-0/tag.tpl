{{template "header.tpl" .}}
<div id="wrap">
  <div class="main container">
    <div class="content">
      <div class="sec-panel archive-list">
        <div class="sec-panel-head daohangq">
          {{HTML .Positions}}>列表
        </div>
        <ul class="article-list tab-list active">
          {{- range .List}}
          <li class="item">
            <div class="item-img">
              <a href="{{.Url}}" title="{{.Title}}" target="_blank">
                <img class="j-lazy" src="{{.TitlePic}}" alt="{{.Title}}" width="480" height="300" style="display: inline;"/>
              </a>
            </div>
            <div class="item-content item-content2">
              <h2 class="item-title">
                {{HTML .}}
              </h2>
              <div class="item-excerpt">
                <p>{{sub .Description 100}}</p>
              </div>
              <div class="item-meta">
                <span class="item-meta-li date">{{date .Updated "2006-01-02 15:04:05"}}</span>
              </div>
            </div>
          </li>
          {{- end}}
        </ul>
        <!--分页-->
        <div id="pages" class="text-c mt25" style="margin:20px 0 0;padding-bottom:20px;">{{HTML .Paginator}}</div>
      </div>
    </div>
    <!--aside-->
    {{template "aside.tpl" .}}
  </div>
</div>
<!--footer-->
{{template "footer.tpl" .}}
</body>
</html>