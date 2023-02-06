<!DOCTYPE html>
<html mip>
<head>
  <meta charset="utf-8">
  <title>{{.Title}}</title>
  <meta content="{{.Keywords}}" name="keywords">
  <meta content="{{.Description}}" name="description">
  <link href="{{.Theme}}/images/favicon.ico" rel="shortcut icon" type="image/x-icon"/>{{canonicalLabel .Url}}
  <meta name="viewport" content="width=device-width,minimum-scale=1,initial-scale=1">
  <link rel="stylesheet" type="text/css" href="https://c.mipcdn.com/static/v2/mip.css">
  <link rel="stylesheet" type="text/css" href="{{.Theme}}/css/main.css"/>
  <link rel="stylesheet" type="text/css" href="{{.Theme}}/css/viewer.min.css">
  <meta property="og:type" content="webpage"/>
  <meta content="webpage" property="og:type"/>
  <meta content="{{.Url}}" property="og:url"/>
  <meta content="{{.Config.Subtitle}}" property="og:site_name"/>
  <meta content="{{.Title}}" property="og:title"/>
  <meta content="{{.Description}}" property="og:description"/>
  <meta content="{{.TitlePic}}" property="og:image"/>
  <script type='text/javascript' src="{{.Theme}}/js/jquery.min.js"></script>
  <script type='text/javascript' src="{{.Theme}}/js/qrcode.js"></script>
  <script type='text/javascript' src="{{.Theme}}/js/utf.js"></script>
  <script type='text/javascript' src="{{.Theme}}/js/jq.qrcode.js"></script>
  <script type='text/javascript' src="{{.Theme}}/js/html2canvas.min.js"></script>
  <script type="text/javascript" src="{{.Theme}}/js/footprint.js"></script>
<script src="https://unpkg.com/smartphoto@1.1.0/js/smartphoto.min.js"></script>
	<link rel="stylesheet" href="https://unpkg.com/smartphoto@1.1.0/css/smartphoto.min.css">
  <style>
    .smartphoto {
      z-index: 99999 !important;
    }
  </style>
</head>

<body>
<header>
  <div class="pc_head">
    <div class="layout head1">
      <h2 alt="{{.Config.Title}}">
        <a href="{{.Config.Hostname}}/" data-type="mip" title="{{.Config.Title}}">
          <mip-img src="{{.Theme}}/images/logo.png" layout width="358" height="52" alt="{{.Config.Title}}"></mip-img>
        </a>
      </h2>
      <div>
        <div class="searchBox">
          <mip-form method="get" url="/" target="_top">
            <span>搜一搜:</span>
            <input type="text" id="search" name="keywords" placeholder="请输入关键词"/>
            <input type="submit" id="searchBtn" value="搜索"></input>
          </mip-form>
        </div>
        <!--联系电话 <div class="imgBox">
          <a href="#" data-type="mip">
            <mip-img src="{{.Theme}}/images/home_icon_sousuo.png" layout width="38" height="38">
            </mip-img>
          </a>
          <div>
            <p>试管预约 (微信同号) </p>
            <p></p>
          </div>
        </div>
        -->
      </div>
    </div>
    <mip-semi-fixed id="semi-fixed" fixedClassNames="fixedStyle">
      <div class="headTab" mip-semi-fixed-container>
        <div class="layout pc-header">
          <h2><a href="{{.Config.Hostname}}/" class="sel" title="{{.Config.Subtitle}}" data-type="mip">首页</a></h2>
            {{- range classes 12}}

              <h2><a href="{{.Url}}" target="_blank" title="{{.Name}}" data-type="mip">{{.Name}}</a></h2>
              {{- if .Children}}
                <ul>
                    {{- range .Children -}}
                      <h2><a href="{{.Url}}" class="" title="{{.Alias}}" data-type="mip">{{.Name}}</a></h2>
                    {{- end -}}
                </ul>
              {{- end}}

            {{- end}}
        </div>
      </div>
    </mip-semi-fixed>
  </div>

  <mip-fixed type="top" class="phone_head">
    <div class="head">
      <div alt="{{.Config.Subtitle}}">
        <a href="{{.Config.Hostname}}/" data-type="mip" title="{{.Config.Subtitle}}">
          <mip-img src="{{.Theme}}/images/logo2.png" layout width="102" height="40" alt="{{.Config.Subtitle}}"></mip-img>
        </a>
      </div>
      <div>
        <a href="{{.Config.Hostname}}/search.html" target="_top" data-type="mip">
          <mip-img src="{{.Theme}}/images/home_ic_ss.png" layout width="16" height="17"></mip-img>
        </a>
        <div on="tap:L1.toggle" id="btn-open" class="lightbox-btn inner-header-icon inner-header-icon-out">
          <span></span>
          <span></span>
          <span></span>
        </div>
      </div>
    </div>
  </mip-fixed>
  <mip-lightbox layout="nodisplay" class="mip-hidden" id="L1">
    <div class="lightbox">
      <div class="phone_head">
        <div class="head">
          <div alt="{{.Config.Subtitle}}">
            <a href="{{.Config.Hostname}}/" data-type="mip" title="{{.Config.Subtitle}}">
              <mip-img src="{{.Theme}}/images/logo2.png" layout width="102" height="40" alt="{{.Config.Subtitle}}"></mip-img>
            </a>
          </div>
          <div>
            <span on="tap:L1.toggle" class="lightbox-btn close-btn">X</span>
          </div>
        </div>
      </div>
      <div class="inner-title">导航</div>
      <div class="lightbox inner-nav">
        <h2 class="sel"><a href="{{.Config.Hostname}}/" title="{{.Config.Subtitle}}" data-type="mip"> 首页</a></h2>
          {{- range classes 12}}
            <h2 class="sel">
              <a href="{{.Url}}" target="_blank" title="{{.Name}}">{{.Name}}</a>
                {{- if .Children}}
                  <ul class="sub-menu">
                      {{- range .Children -}}
                        <h2 class="sel"><a href="{{.Url}}" title="{{.Alias}}">{{.Name}}</a></h2>
                      {{- end -}}
                  </ul>
                {{- end}}
            </h2>
          {{- end}}
      </div>
    </div>
  </mip-lightbox>
</header>
<!--广告
<a class="layout wiki" href="/" data-type="mip">
  <mip-img src="#" alt='' height="98"></mip-img>
</a>
-->
<div class="crumbs layout">
  <mip-img src="{{.Theme}}/images/list_ic_mbx.png" width="16" height="16" class="home-icon"></mip-img>
    {{HTML .Positions}}>内容
</div>
<div class="wiki-content layout">
  <div class="content-wiki-l wiki-detail">
    <h1 class="wiki-title">{{.Article.Title}}</h1>
    <div class="wiki-tags">
      <span>发布时间:{{date .Article.Updated "2006-01-02 15:04"}}</span>
    </div>
    <div class="wiki-content">
      <div id="viewer">
          {{call .Article.MipContent}}
      </div>
    </div>

    <div class="wiki-types" id="tuijiantag_2">
      <div class="types-title">推荐标签</div>
      <div class="types-wrap" id="tuijiantag_3">
          {{- range .Tags}} {{.}} {{- end}}
      </div>
    </div>

    <div class="relevant">
      <div class="relevant-title">
        <i>相关推荐</i>
      </div>
      <div class="relevant-wrap">
          {{- range like 6}}
            <a href="{{.Url}}" class="relevant-item"
               title="{{.Title}}">
              <mip-img
                src="{{.TitlePic}}"
                alt="{{.Title}}" height="196" width=264></mip-img>
              <h2>{{.Title}}</h2>
            </a>
          {{- end}}
      </div>
    </div>
  </div>
  <div class="content-wiki-r">
    <!--ads
    <a href="" data-type="mip">
      <mip-img src="#" alt='' height="390" width="320"></mip-img>
    </a> -->
    <div class="recommend RMTJ">
      <div class="recommend-title"><i></i>热门推荐<i></i></div>
        {{- range loop "" 0 8 "title_pic=1"}}
          <a href="{{.Url}}" class="recommend-item" title="{{.Title}}">
            <div class="posts">
              <mip-img src="{{.TitlePic}}" height="22" width="22"></mip-img>
            </div>
            <h3>{{.Title}}</h3>
          </a>
        {{- end}}
    </div>

    <div class="recommend">
      <div class="recommend-title"><i></i>猜你喜欢<i></i></div>
        {{- range loop "" 4 8 "title_pic=1"}}
          <a href="{{.Url}}" class="recommend-item hot-video"
             title="{{.Title}}">
            <div class="posts">
              <mip-img
                src="{{.TitlePic}}"
                width="116" height="70"></mip-img>
            </div>
            <div class="info">
              <h3>{{.Title}}</h3>
              <span>{{date .Updated "2006-01-02 15:04:05"}}</span>
            </div>
          </a>
        {{- end}}
    </div>

    <div class="recommend RMBQ">
      <div class="recommend-title"><i></i>热门标签<i></i></div>
      <div class="RMBQ-wrap">
          {{- range tags 0 10}}
            <h2><a href="{{.Url}}" title="{{.Name}}" class="RMBQ-item">{{.Name}}</a></h2>
          {{- end}}
      </div>

    </div>
  </div>
</div>

<div class="wiki-detail-m">
  <div class="wiki-detail">
    <h2 class="wiki-title">{{.Article.Title}}</h2>
    <div class="wiki-tags">
      <span>发布时间:{{date .Article.Updated "2006-01-02 15:04"}}</span>
    </div>
    <div class="wiki-content">
      <div id="viewer2"><!--内容-->
          {{call .Article.MipContent}}
      </div>
    </div>
    <div class="wiki-types" id="tuijiantag_0">
      <div class="types-title">推荐标签</div>
      <div class="types-wrap" id="tuijiantag_1">
          {{- range tags 2 10}}
            <h3><a href="{{.Url}}" title="{{.Name}}">{{.Name}}</a></h3>
          {{- end}}
      </div>
    </div>
  </div>
  <div class="m-line"></div>
  <div class="recommend-m">
    <div class="recommend-title">热门推荐</div>
      {{- range loop "" 0 8 "title_pic=1"}}
        <a href="{{.Url}}" class="recommend-item" title="{{.Title}}">
          <div class="posts">
            <mip-img src="{{.TitlePic}}" alt="{{.Title}}" width="122" height="73"></mip-img>
          </div>
          <div class="info"><h3>{{.Title}}</h3><i>{{date .Updated "2006-01-02 15:04:05"}}</i></div>
        </a>
      {{- end}}
  </div>
  <div class="m-line"></div>
  <div class="recommend-m">
    <div class="recommend-title">猜你喜欢</div>
      {{- range loop "" 4 6 "level=4,5,6" "title_pic=1"}}
        <a href="{{.Url}}" class="recommend-item" title="{{.Title}}">
          <div class="posts">
            <mip-img src="{{.TitlePic}}" alt="{{.Title}}" width="122" height="73"></mip-img>
          </div>
          <div class="info"><h3>{{.Title}}</h3><i>{{date .Updated "2006-01-02 15:04:05"}}</i></div>
        </a>
      {{- end}}
  </div>
</div>
{{template "footer.tpl" .}}