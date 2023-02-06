{{template "header.tpl" .}}
<!--广告
<a class="layout wiki" href="/" data-type="mip">
  <mip-img src="#" alt='' height="98"></mip-img>
</a>
-->
<div class="crumbs layout">
  <mip-img src="{{.Theme}}/images/list_ic_mbx.png" width="16" height="16" class="home-icon"></mip-img>
    {{HTML .Positions}}>列表
</div>
<div class="wiki-banner-m">

  <div class="banner-l-carousel">
    <mip-carousel autoplay layout="responsive" height="190" indicator width="345">
        {{- range loop "" 1 4 "title_pic=1"}}
          <a href="{{.Url}}" title="{{.Title}}">
            <mip-img src="{{.TitlePic}}" alt="{{.Title}}"></mip-img>
            <h2 class="mip-carousle-subtitle">{{.Title}}</h2>
          </a>
        {{- end}}
    </mip-carousel>
  </div>

  <div class="banner-l-hot">
      {{- range loop "" 2 3 "level=1" "title_pic=1"}}
        <a href="{{.Url}}" title="{{.Title}}">
          <mip-img src="{{.TitlePic}}" alt="{{.Title}}" width="105" height="65"></mip-img>
          <h2>{{.Title}}</h2>
        </a>
      {{- end}}
  </div>
</div>
<div class="m-line"></div>

<div class="wiki-content layout">
  <div class="content-wiki-l">
    <!-- <div style="width:100%; height:300px;background:#f00;"></div> -->
    <div class="wiki-banner-section">
      <div class="wiki-banner-l">
        <div class="banner-l-carousel">
          <mip-carousel autoplay layout="responsive" width="600" height="325" indicator>
              {{- range loop "" 4 4 "title_pic=1"}}
                <a href="{{.Url}}" title="{{.Title}}">
                  <mip-img src="{{.TitlePic}}" alt="{{.Title}}"></mip-img>
                  <h2 class="mip-carousle-subtitle">{{.Title}}</h2>
                </a>
              {{- end}}
          </mip-carousel>
        </div>

        <div class="banner-l-hot">
            {{- range loop "" 1 3 "level=1,2" "title_pic=1"}}
              <a href="{{.Url}}" title="{{.Title}}" target="_blank">
                <mip-img src="{{.TitlePic}}" alt="{{.Title}}" width="193" height="113"></mip-img>
                <h2>{{.Title}}</h2>
              </a>
            {{- end}}
        </div>

      </div>
      <div class="bannner-r-recommend">
          {{- range loop "" 1 3 "level=3,4,5" "title_pic=1"}}
            <a href="{{.Url}}" title="{{.Title}}">
              <mip-img src="{{.TitlePic}}" alt="{{.Title}}" width="240" height="143"></mip-img>
              <h2>{{.Title}}</h2>
            </a>
          {{- end}}
      </div>
    </div>

      {{- range .List}}
        <div class="wiki-item">
          <a href="{{.Url}}" title="{{.Title}}">
            <mip-img src="{{.TitlePic}}" alt="{{.Title}}" width="226" height="148"></mip-img>
          </a>
          <div class="wiki-info">
            <h2><a href="{{.Url}}" title="{{.Title}}">{{.Title}}</a></h2>
            <span><a href="{{.Url}}" title="{{.Title}}">{{sub .Description 40}}</a></span>
            <div class="wiki-item-other">
						<span>
							{{$.Class.Alias}}
						</span><i>|</i>
              <span>{{date .Updated "2006-01-02 15:04:05"}}</span>
            </div>
          </div>
        </div>
      {{- end}}
  </div>
  <div class="content-wiki-r">
    <!-- ads2
    <a href="" data-type="mip">
      <mip-img src="#" alt="" height="390" width="320"></mip-img>
    </a> -->
    <div class="recommend RMTJ">
      <div class="recommend-title"><i></i>热门推荐<i></i></div>
        {{- range loop "" 1 10}}
          <a href="{{.Url}}" class="recommend-item" title="{{.Title}}">
            <h3>{{.Title}}</h3>
          </a>
        {{- end}}
    </div>

    <div class="recommend">
      <div class="recommend-title"><i></i>猜你喜欢<i></i></div>
        {{- range loop "" 0 5 "level=4,5,6" "title_pic=1"}}
          <a href="{{.Url}}" class="recommend-item hot-video"
             title="{{.Title}}">
            <div class="posts">
              <mip-img src="{{.TitlePic}}" width="116" height="70"></mip-img>
            </div>
            <div class="info">
              <h3>{{.Title}}</h3>
              <span>{{date .Updated "2006-01-02"}}</span>
            </div>
          </a>
        {{- end}}
    </div>

    <div class="recommend RMBQ">
      <div class="recommend-title"><i></i>热门标签<i></i></div>
      <div class="RMBQ-wrap">
        <ul>
            {{- range tags 2 10}}
              <h2><a href="{{.Url}}" title="{{.Name}}" class="RMBQ-item">{{.Name}}</a></h2>
            {{- end}}
        </ul>
      </div>
    </div>
  </div>
</div>

<div class="wiki-content-m">
  <div class="wiki-list-m">
      {{- range .List}}
        <div class="wiki-item">
          <a href="{{.Url}}" title="{{.Title}}">
            <mip-img src="{{.TitlePic}}" alt="{{.Title}}" width="113" height="82"></mip-img>
          </a>
          <div class="wiki-info">
            <h2><a href="{{.Url}}" title="{{.Title}}">{{.Title}}</a></h2>
            <span><a href="{{.Url}}" title="{{.Title}}">{{sub .Description 100}}</a></span>
            <div class="wiki-item-other">
                {{$.Class.Alias}}<i>|</i>
              <span>{{date .Updated "2006-01-02 15:04:05"}}</span>
            </div>
          </div>
        </div>
      {{- end}}

    <div class="pagenation">
      <ul class=pagelist>{{HTML .Paginator}}</ul>
    </div>
  </div>
</div>
<div class="m-line"></div>
<div class="recommend-m">
  <div class="recommend-title">热门推荐</div>
    {{- range loop "" 1 8 "title_pic=1"}}
      <a href="{{.Url}}" class="recommend-item" title="{{.Title}}">
        <div class="posts">
          <mip-img src="{{.TitlePic}}" alt="{{.Title}}" width="122" height="73"></mip-img>
        </div>
        <div class="info">
          <h3>{{.Title}}</h3>
          <i>{{date .Updated "01-02 15:04:05"}}</i>
        </div>
      </a>
    {{- end}}
</div>

<div class="m-line"></div>
<div class="recommend-m">
  <div class="recommend-title">猜你喜欢</div>
    {{- range loop "" 4 6 "title_pic=1"}}
      <a href="{{.Url}}" class="recommend-item" title="{{.Title}}">
        <div class="posts">
          <mip-img src="{{.TitlePic}}" alt="{{.Title}}" width="122" height="73"></mip-img>
        </div>
        <div class="info">
          <h3>{{.Title}}</h3>
          <i>{{date .Updated "01-02 15:04:05"}}</i>
        </div>
      </a>
    {{- end}}
</div>
<div class="recommend-m RMTJ">
  <div class="recommend-title">热门标签</div>
  <div class="RMTJ-wrap">
      {{- range tags  0 10}}
        <h2><a href="{{.Url}}" title="{{.Name}}" class="RMBQ-item">{{.Name}}</a></h2>
      {{- end}}
  </div>
</div>
{{template "footer.tpl" .}}