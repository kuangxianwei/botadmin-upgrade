{{template "header.tpl" .}}
<main class="mipcms-main">
  <div class="am-g cent" id="mt0">
    <div class="mbx">
      <ul class="list-unstyled d-flex red2">{{HTML .Positions}}>tags</ul>
    </div>
    <div class="cent-lf">
      <div class="mbx1">
        <h1><i class="am-icon-fire "></i>{{.Title}}</h1>
      </div>
      <div id="list-news">
        <ul class="list-lb">
          <!--调用列表-->
            {{- range .List}}
              <li>
                <div class="list-lf">
                  <a target="_blank" href="{{.Url}}" data-type="mip" data-title="{{.Title}}" title="{{.Title}}">
                    <mip-img layout="container" src="{{.TitlePic}}" alt="{{.Title}}" class="mip-element mip-layout-container mip-img-loaded" mip-firstscreen-element="">
                      <img class="mip-fill-content mip-replaced-content" src="{{.TitlePic}}" alt="{{.Title}}"></mip-img>
                  </a>
                </div>
                <div class="list-rt">
                  <h3><a target="_blank" href="{{.Url}}" data-type="mip" data-title="{{.Title}}" title="{{.Title}}">{{.Title}}</a></h3>
                  <p>{{sub .Description 80}}</p>
                  <div class="list-time">
                    <span class="list-more"><a target="_blank" href="{{.Url}}">阅读全文</a></span>
                    <span class="list-fenlei"><i class="am-icon-user"></i>{{class .Cid | HTML}}</span>
                    <span class="list-sj">发布日期:{{date .Updated "2006-01-02 15:04:05"}}</span>
                  </div>
                </div>
              </li>
            {{- end}}
        </ul>
        <div class="fenye">
          <ul>
            <span class="page now-page">{{HTML .Paginator}}</span>
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