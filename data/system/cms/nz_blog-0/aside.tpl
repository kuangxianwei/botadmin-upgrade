<aside class="sidebar">
  <div id="lastest-news-4" class="widget widget_lastest_news">
    <h3 class="widget-title">今日推荐</h3>
    <ul>
      {{- range loop "" 4 10 }}
      <li><a href="{{.Url}}" title="{{.Title}}" target="_blank">{{sub .Title 19}}</a></li>
      {{- end}}
    </ul>
  </div>
  <div id="lastest-news-2" class="widget widget_lastest_news">
    <h3 class="widget-title">热门文章</h3>
    <ul>
      {{- range loop "" 1 8 }}
      <li><a target="_blank" href="{{.Url}}" title="{{.Title}}">{{sub .Title 19}}</a></li>
      {{- end}}
    </ul>
  </div>
  <div id="post-thumb-4" class="widget widget_post_thumb">
    <h3 class="widget-title">读图</h3>
    <ul>
      {{- range loop "" 4 5  "title_pic=1"}}
      <li class="item">
        <div class="item-img">
          <a href="{{.Url}}" title="{{.Title}}" target="_blank">
            <img class="j-lazy" src="{{.TitlePic}}" alt="{{.Title}}" width="480" height="300">
          </a>
        </div>
        <div class="item-content">
          <p class="item-title">
            <a href="{{.Url}}" title="{{.Title}}" target="_blank">{{sub .Title 15}}</a>
          </p>
          <p class="item-date">{{date .Updated "2006-01-02 15:04:05"}}</p>
        </div>
      </li>
      {{- end}}
    </ul>
  </div>
</aside>