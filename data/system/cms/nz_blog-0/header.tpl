<!DOCTYPE HTML>
<html>
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=11,IE=10,IE=9,IE=8">
  <meta name="applicable-device" content="pc,mobile">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <title>{{.Title}}</title>
  <meta content="{{.Keywords}}" name="keywords">
  <meta content="{{.Description}}" name="description">
  <link rel="shortcut icon" href="{{.Theme}}/images/favicon.ico" type="image/x-icon" />
  <link rel="stylesheet" id="stylesheet-css" href="{{.Theme}}/css/style.css" type="text/css" media="all"/>
  <link rel="stylesheet" id="um_minified-css" href="{{.Theme}}/css/um.min.css" type="text/css" media="all"/>
  <script type="text/javascript" src="{{.Theme}}/js/jquery.min.js"></script>
  {{canonicalLabel .Url}}
    <meta content="webpage" property="og:type"/>
    <meta content="{{.Url}}" property="og:url"/>
    <meta content="{{.Config.Subtitle}}" property="og:site_name"/>
    <meta content="{{.Title}}" property="og:title"/>
    <meta content="{{.Description}}" property="og:description"/>
    <meta content="{{.TitlePic}}" property="og:image"/>
</head>
<body class="home blog">
<header class="header">
  <div class="container clearfix">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target=".navbar-collapse">
        <span class="icon-bar icon-bar-1"></span>
        <span class="icon-bar icon-bar-2"></span>
        <span class="icon-bar icon-bar-3"></span>
      </button>
      <h2 class="logo">
        <a href="{{.Config.Hostname}}/" title="{{.Config.Title}}" rel="home">
          <img src="{{.Theme}}/images/logo.png" alt="{{.Config.Title}}">
        </a>
      </h2>
    </div>
    <div class="collapse navbar-collapse">
      <nav class="navbar-left primary-menu">
        <ul id="menu-justnews-footer-menu" class="nav navbar-nav">
          <li class="menu-item menu-item-home active">
            <a href="{{.Config.Hostname}}/" title="{{.Config.Title}}">首页</a>
          </li>
          {{- range classes 12}}
          <li class="menu-item dropdown">
            <a href="{{.Url}}" title="{{.Name}}" class="dropdown-toggle">{{.Name}}</a>
            {{- if .Children}}
            <ul class="dropdown-menu">
              {{- range .Children -}}
              <li class="menu-item">
                <a href="{{.Url}}" title="{{.Alias}}">{{.Name}}</a>
              </li>
              {{- end -}}
              </li>
            </ul>
            {{- end}}
          </li>
          {{- end}}
        </ul>
      </nav>
    </div>
  </div>
</header>