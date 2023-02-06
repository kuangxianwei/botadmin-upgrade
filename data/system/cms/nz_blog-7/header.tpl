<!DOCTYPE html>
<html mip>
<head>
  <meta charset="utf-8">
  <meta name="applicable-device" content="pc,mobile">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=0">
  <meta http-equiv="Cache-Control" content="no-siteapp"/>
  <link rel="shortcut icon" href="{{.Theme}}/images/favicon.ico" type="image/x-icon"/>
  <title>{{.Title}}</title>
  <meta content="{{.Keywords}}" name="keywords">
  <meta content="{{.Description}}" name="description">
  <meta property="og:type" content="webpage"/>
  <meta content="webpage" property="og:type"/>
  <meta content="{{.Url}}" property="og:url"/>
  <meta content="{{.Config.Subtitle}}" property="og:site_name"/>
  <meta content="{{.Title}}" property="og:title"/>
  <meta content="{{.Description}}" property="og:description"/>
  <meta content="{{.TitlePic}}" property="og:image"/>{{canonicalLabel .Url}}
  <link rel="stylesheet" type="text/css" href="{{.Theme}}/css/mip.css">
  <link rel="stylesheet" type="text/css" href="{{.Theme}}/css/amazeui.css">
  <link rel="stylesheet" type="text/css" href="{{.Theme}}/css/web.css">
  <style mip-custom>

    #right-sidebar ul li {
      height: 42px;
      line-height: 42px;
      padding: 0px 25px;
      font-size: 16px;
      border-bottom: 1px solid #111;
      border-top: 1px solid #444;
      text-align: center;
    }

    #right-sidebar ul li button {
      width: 30px;
      font-size: 22px;
      background: #2b2b2b;
      color: #fff;
      border: 1px solid #2b2b2b;
      text-align: center;
    }

    #right-sidebar ul li a {
      color: #fff;
    }

    #right-sidebar {
      background: #2b2b2b !important;
    }

  </style>
</head>
<body>
<!--调用头部-->
<div class="tb">
  <div class="am-g">
    <span class="am-fl">欢迎来到{{.Config.Subtitle}}</span>
    <div class="am-fr">
      <a target="_blank" href="{{.Config.Hostname}}/sitemap.xml">网站地图</a>
    </div>
  </div>
</div>
<div class="tb1">
  <div class="tb1-a">
    <h2><a target="_blank" href="{{.Config.Hostname}}/">{{.Config.Subtitle}}</a></h2>
    <mip-form url="#" action="#" method="GET" target="_self" class="mip-element mip-layout-container">
      <input type="text" name="q" validatetarget="q" validatetype="must" placeholder="搜索" class="input search-txt">
      <input type="submit" value="提交" class="search-btn">
    </mip-form>
    <div class="tb1-b">
      <div on="tap:right-sidebar.open"><span><i></i></span></div>
    </div>
    <mip-sidebar id="right-sidebar" layout="nodisplay" side="right" class="mip-hidden" aria-hidden="true">
      <ul class="mtop">
        <li>
          <button on="tap:right-sidebar.close"> X</button>
        </li>
        <li class='active'>
          <a href="{{.Config.Hostname}}/" data-type="mip" data-title="{{.Config.Title}}" title='{{.Config.Title}}'>首页</a>
        </li>
          {{- range classes 12}}
            <li class="mipmb-dropdown-item">
              <a href="{{.Url}}" target="_blank" data-type="mip" data-title="{{.Name}}" title="{{.Name}}">{{.Name}}</a>
                {{- if .Children}}
                  <ul class="sub-menu">
                      {{- range .Children -}}
                        <li><a href="{{.Url}}" data-type="mip" data-title="{{.Alias}}" title="{{.Alias}}">{{.Name}}</a></li>
                      {{- end -}}
                  </ul>
                {{- end}}
            </li>
          {{- end}}
      </ul>
    </mip-sidebar>
  </div>
</div>
<div data-am-sticky id="nav">
  <header class="navdh am-g">
    <ul>
        {{- range classes 12}}
          <li class="mipmb-dropdown-item">
            <a href="{{.Url}}" target="_blank" data-type="mip" data-title="{{.Name}}" title="{{.Name}}">{{.Name}}</a>
              {{- if .Children}}
                <ul class="sub-menu">
                    {{- range .Children -}}
                      <li><a href="{{.Url}}" data-type="mip" data-title="{{.Alias}}" title="{{.Alias}}">{{.Name}}</a></li>
                    {{- end -}}
                </ul>
              {{- end}}
          </li>
        {{- end}}
    </ul>
  </header>
</div>