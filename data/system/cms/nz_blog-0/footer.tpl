{{- if eq .Pager "index"}}
<div class="container hidden-xs j-partner">
    <div class="sec-panel">
        <div class="sec-panel-head">
            <h2>友情链接<small></small></h2>
        </div>
        <div class="sec-panel-body">
            <div class="list list-links">
                {{- range links 30}}
                {{HTML .}}
                {{- end}}
            </div>
        </div>
    </div>
</div>
{{- end}}
<footer class="footer">
  <div class="container">
    <div class="clearfix">
      <div class="footer-col footer-col-copy">
        <div class="menu">
          <ul>
            <a href="{{.Config.Hostname}}/" title="{{.Config.Title}}">首页</a>
            {{- range classes 12}}
            <a href="{{.Url}}" title="{{.Name}}">{{.Name}}</a>
            {{- end}}
          </ul>
        </div>
        <div class="copyright">
         {{HTML .Config.Copyright}}
          <p><a href="{{.Config.Hostname}}/sitemap.xml" target="_blank">百度地图</a></p>
        </div>
      </div>
    </div>
  </div>
</footer>
<div class="action" style="top:80%;">
  <div class="a-box gotop" id="j-top" style="display: block;"></div>
</div>
<script type='text/javascript'> /* <![CDATA[ */ var _wpcom_js = {"ajaxurl":"","slide_speed":"5000"}; /* ]]> */</script>
<script type='text/javascript' src='{{.Theme}}/js/main.js'></script>
<script type='text/javascript' src='{{.Theme}}/js/imagesloaded.min.js'></script>
<script type='text/javascript' src='{{.Theme}}/js/masonry.min.js'></script>
<script type='text/javascript' src='{{.Theme}}/js/jquery.masonry.min.js'></script>
<script>('click', function () {$(".site-navbar").toggle();}); </script>
</body>
</html>