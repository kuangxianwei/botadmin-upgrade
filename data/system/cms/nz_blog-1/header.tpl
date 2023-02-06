<!DOCTYPE html>
<html mip>
<head>
  <meta charset="utf-8">
  <title>{{.Title}}</title>
  <meta content="{{.Keywords}}" name="keywords">
  <meta content="{{.Description}}" name="description">
  <link href="{{.Theme}}/images/favicon.ico" rel="shortcut icon" type="image/x-icon"/>
  <meta name="viewport" content="width=device-width,minimum-scale=1,initial-scale=1">
  <link rel="stylesheet" type="text/css" href="https://c.mipcdn.com/static/v2/mip.css">{{canonicalLabel .Url}}
  <link rel="stylesheet" type="text/css" href="{{.Theme}}/css/main.css"/>
  <meta property="og:type" content="webpage"/>
  <meta content="webpage" property="og:type"/>
  <meta content="{{.Url}}" property="og:url"/>
  <meta content="{{.Config.Subtitle}}" property="og:site_name"/>
  <meta content="{{.Title}}" property="og:title"/>
  <meta content="{{.Description}}" property="og:description"/>
  <meta content="{{.TitlePic}}" property="og:image"/>
</head>
<body>
<header>
  <div class="pc_head">
    <div class="layout head1">
      <h1 alt="{{.Config.Title}}">
        <a href="{{.Config.Hostname}}/" data-type="mip" title="{{.Config.Title}}">
          <mip-img src="{{.Theme}}/images/logo.png" layout width="358" height="52" alt="{{.Config.Title}}"></mip-img>
        </a>
      </h1>
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
          <h2><a href="{{.Config.Hostname}}/" title="{{.Config.Subtitle}}" data-type="mip"{{if eq .Pager "index"}} class="sel"{{end}}>首页</a></h2>
            {{- range classes 12}}
              <h2><a href="{{.Url}}" target="_blank" title="{{.Name}}" data-type="mip"{{if eq .Id $.Class.Id}} class="sel"{{end}}>{{.Name}}</a></h2>
              {{- if .Children}}
                <ul>
                    {{- range .Children -}}
                      <h2><a href="{{.Url}}" class="" title="{{.Alias}}" data-type="mip"{{if eq .Id $.Class.Id}} class="sel"{{end}}>{{.Name}}</a></h2>
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