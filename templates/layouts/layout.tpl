<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <title>{{.server_name}}</title>
    <meta name="version" content="{{.version}}">
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <meta name="current_uri" content="{{.current_uri}}">
    <meta name="csrf_token" content="{{.csrf_token}}">
    <link rel="icon" href="/static/favicon.ico" type="image/x-icon"/>
    <link rel="shortcut icon" href="/static/favicon.ico" type="image/x-icon"/>
    <link rel="stylesheet" href="/static/layui/css/layui.css" media="all">
    <link rel="stylesheet" href="/static/style/admin.css" media="all">
    <link rel="stylesheet" href="/static/layui/iconfont/iconfont.css" media="all">
    <style>
        .layui-textarea {min-height:auto;}
        div.parse-method > div:nth-child(4) {width:80px;}
        div.parse-method > div:nth-child(2) {width:40%;}
        .width100 {width:100px;}
        .width120 {width:120px;}
        .botadmin-nav {border-radius:2px;display:inline-block;margin-left:1px;top:-5px;height:30px;}
        .botadmin-nav,.botadmin-nav > .layui-nav-item,.botadmin-nav .layui-nav-child {padding:0;}
        .botadmin-nav > .layui-nav-item {line-height:30px;}
        .botadmin-nav > .layui-nav-item .layui-nav-child {top:30px;line-height:30px;}
        .layui-input,.layui-textarea {display:inline-block !important;}
        .layui-elem-field {padding:revert !important;}
        .layui-transfer-box {overflow:hidden !important;}
    </style>
    <script>
        var _hmt = _hmt || [];
        (function() {
            var hm = document.createElement("script");
            hm.src = "https://hm.baidu.com/hm.js?0b848dc46defa12af2edf9bfbb746270";
            var s = document.getElementsByTagName("script")[0];
            s.parentNode.insertBefore(hm, s);
        })();
    </script>
</head>
<body>
<div class="layui-fluid">
    {{ yield }}
</div>
</body>
</html>