{{template "header.tpl" .}}
<main class="mipcms-main">
  <div class="am-g cent" id="mt0">
    <div class="mbx">
      <ul class="list-unstyled d-flex red2">{{HTML .Positions}}>tags</ul>
    </div>
    <div class="cent-lf">
      <div class="wzzw">
        <div class="wzzw-title">
          <h1>{{.Article.Title}}</h1>
          <p><span>时间:{{date .Article.Updated "2006-01-02 15:04"}}</span><span>来源:{{source}}</span><span>阅读:<script src="{{.Config.Hostname}}/hot.js?aid={{.Article.Id}}"></script>次</span>
          </p>
        </div>
        <div class="wzzw-conet">
            {{call .Article.MipContent}}
        </div>
        <p class="hr"></p>
        <div class="bbm">
          TAG:
          <div class="mip-share-container ">
              {{- range .Tags}} {{.}} {{- end}}
          </div>
        </div>
        <div class="wzy-title">
          <p></p>
        </div>
        <div class="sxp">
          <p><strong>上一篇：</strong>
              {{.PreNext.Pre}}
          </p>
          <p><strong>下一篇：</strong>
              {{.PreNext.Next}}
          </p>
        </div>
        <div class="tishi"><span>温馨提示：</span>以上内容和图片整理于网络，仅供参考，希望对您有帮助！如有侵权行为请联系删除！</div>
        <div class="wztj">
          <h2>猜你喜欢</h2>
          <ul class="am-avg-sm-2 am-avg-md-4 am-thumbnails">
              {{- range like 4}}
                <li>
                  <img class="j-lazy" src="{{.TitlePic}}" alt="{{.Title}}">
                  <a href="{{.Url}}" title="{{.Title}}" target="_blank">{{.Title}}</a>
                </li>
              {{- end}}
          </ul>
        </div>
      </div>
    </div>
    <!--侧边栏-->
    <div class="sidebar ">
      <div class="youce ">
        <div class="title ">
          <h2><i class="am-icon-fire "></i>热门排行</h2>
        </div>
        <ul class="sidebar-sz ">
            {{- range loop "" 4 10 "level=1,2,3,4"}}
              <li><a target="_blank" href="{{.Url}}" data-type="mip" data-title="{{.Title}}" title='{{.Title}}'>{{.Title}}</a>
              </li>
            {{- end}}
        </ul>
      </div>
      <div class="youce">
        <div class="title">
          <h2><i class="am-icon-fire"></i>网友关注</h2>
        </div>
        <ul class="sidebar-tw">
            {{- range loop "" 2 5 "level=4,5,6" "title_pic=1"}}
              <li>
                <a target="_blank" href="{{.Url}}" rel="bookmark" class="cmsimg" title="{{.Title}}">
                  <div class="sidebar-tw-lf ">
                    <mip-img layout="container" src="{{.TitlePic}}"></mip-img>
                  </div>
                  <div class="sidebar-tw-rt">
                    <h3><a target="_blank" href="{{.Url}}" data-type="mip" data-title="{{.Title}}" title='{{.Title}}'>{{.Title}}</a></h3>
                    <p><span>{{date .Updated "2006-01-02 15:04:05"}}</span>
                    </p>
                  </div>
                </a>
              </li>
            {{- end}}
        </ul>
      </div>
      <div class="youce">
        <div class="title">
          <h2><i class="am-icon-fire"></i>看了又看</h2>
        </div>
        <ul class="sidebar-wz">
            {{- range loop "" 4 10 "level=1,5,6"}}
              <li><a target="_blank" href="{{.Url}}" data-type="mip" data-title="{{.Title}}" title='{{.Title}}'>{{.Title}}</a></li>
            {{- end}}
        </ul>
      </div>
      <div class="youce ">
        <div class="title ">
          <h2><i class="am-icon-fire "></i>热门标签</h2>
        </div>
        <ul class="sidebar-tags ">
            {{- range tags 2 30}}
              <li class="m-b-sm"> {{HTML .}}</li>
            {{- end}}
        </ul>
      </div>

    </div>

  </div>
  </div>
</main>
<div class="yqlj am-g">
  <h3>友情链接：</h3>
  <ul>
      {{- range links 30}}
          {{HTML .}}
      {{- end}}
  </ul>
</div>
<!--调用尾部-->
{{template "footer.tpl" .}}