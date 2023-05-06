<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <title>{{.server_name}}</title>
    <meta name="version" content="{{.version}}">
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <meta name="current_uri" content="{{.current_uri}}">
    <meta name="csrf_token" content="{{.csrf_token}}">
    <meta name="public_key" content="{{.public_key}}">
    <link rel="icon" href="/static/favicon.ico" type="image/x-icon"/>
    <link rel="shortcut icon" href="/static/favicon.ico" type="image/x-icon"/>
    <link rel="stylesheet" href="/static/layui/css/layui.css" media="all">
    <link rel="stylesheet" href="/static/style/admin.css" media="all">
    <link rel="stylesheet" href="/static/layui/iconfont/iconfont.css" media="all">
    <link rel="stylesheet" href="/static/style/botadmin.css" media="all">
    <script>let url ={{.current_uri}}, csrfToken ={{.csrf_token}}, publicKey ={{.public_key}}</script>
</head>
<body class="layui-fluid">
{{ yield .}}
</body>
</html>