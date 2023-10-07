<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<meta charset="utf-8">
	<title>{{.server_name}}</title>
	<meta name="version" content="{{.version}}">
	<meta name="renderer" content="webkit">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
	<link rel="icon" href="/static/favicon.ico" type="image/x-icon"/>
	<link rel="shortcut icon" href="/static/favicon.ico" type="image/x-icon"/>
	<link rel="stylesheet" href="/static/layui/css/layui.css" media="all">
	<link rel="stylesheet" href="/static/adminui/dist/css/admin.css" media="all">
	<link rel="stylesheet" href="/static/style/iconfont/iconfont.css" media="all">
	<link rel="stylesheet" href="/static/style/botadmin.css" media="all">
	<script>const URL ={{.URL}}, CSRF_TOKEN ={{.CSRF_TOKEN}}, PUBLIC_KEY ={{.PUBLIC_KEY}};</script>
</head>
<body class="layui-fluid">
{{ yield .}}
<div id="help-document" style="display:none;color:#0a5b52;cursor:pointer;position:fixed;top:30%;right:5px;width:10px;">
	<i class="layui-icon layui-icon-help"></i>帮助
</div>
</body>
</html>