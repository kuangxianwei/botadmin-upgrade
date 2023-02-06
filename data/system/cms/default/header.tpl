<!DOCTYPE HTML>
<html lang="zh-cn">
<head>
    <meta charset="UTF-8">
    <meta content="IE=11,IE=10,IE=9,IE=8" http-equiv="X-UA-Compatible">
    <meta content="pc,mobile" name="applicable-device">
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport">
    <title>{{.Title}}</title>
    <meta content="{{.Keywords}}" name="keywords">
    <meta content="{{.Description}}" name="description">
    <link href='{{.Theme}}/css/bootstrap.min.css' id='_bootstrap-css' media='all' rel='stylesheet' type='text/css'/>
    <link href='{{.Theme}}/css/font-awesome.min.css' id='_fontawesome-css' media='all' rel='stylesheet' type='text/css'/>
    <link href='{{.Theme}}/css/main.css' id='_main-css' media='all' rel='stylesheet' type='text/css'/>
    {{canonicalLabel .Url}}
    <meta content="webpage" property="og:type"/>
    <meta content="{{.Url}}" property="og:url"/>
    <meta content="{{.Config.Subtitle}}" property="og:site_name"/>
    <meta content="{{.Title}}" property="og:title"/>
    <meta content="{{.Description}}" property="og:description"/>
    <meta content="{{.TitlePic}}" property="og:image"/>
</head>
<body class="home blog nav_fixed m-excerpt-cat m-excerpt-time topbar-off site-layout-2">
<header class="header">
    <div class="container">
        <div class="logo"><a href="{{.Config.Hostname}}/" title="{{.Config.Title}}"><img alt="{{.Config.Subtitle}}" src="{{.Theme}}/images/logo.png">{{.Config.Subtitle}}</a></div>
        <ul class="site-nav site-navbar" id="menu-list" style="background: white;">
            <li class="menu-item menu-item-type-custom menu-item-object-custom menu-item-49385">
                <a href="{{.Config.Hostname}}/" target="_blank"><i class="fa fa-book"></i>首页</a></li>
            {{- range classes 12}}
            <li class="menu-item menu-item-type-taxonomy menu-item-object-category menu-item-has-children">
                <a href="{{.Url}}" target="_blank"><i class="fa fa-book"></i>{{.Name}}</a>
                {{- if .Children}}
                <ul class="sub-menu">
                    {{- range .Children -}}
                    <li class="menu-item menu-item-type-taxonomy menu-item-object-category"><a href="{{.Url}}" title="{{.Alias}}">{{.Name}}</a></li>
                    {{- end -}}
                </ul>
                {{- end}}
            </li>
            {{- end}}
        </ul>
        <i class="fa fa-bars m-icon-nav" id="menu-btn"></i></div>
</header>