<style> @media screen and (max-width: 959px) {
    .copyright-link {
        display: none
    }
}</style>
<footer class="footer">
    <div class="container">
{{HTML .Config.Copyright}}
        <p>{{.Config.Subtitle}} <a href="{{.Config.Hostname}}/sitemap.xml" target="_blank">百度地图</a>  </p>
        <p class="copyright-link">友情链接：
{{if eq .Pager "index"}}
    {{- range links 30}}
    {{HTML .}}|
    {{- end}}
{{end}}
            </p></div>
</footer>
<script>(function () {
    var bp = document.createElement('script');
    var curProtocol = window.location.protocol.split(':')[0];
    if (curProtocol === 'https') {
        bp.src = 'https://zz.bdstatic.com/linksubmit/push.js';
    } else {
        bp.src = 'http://push.zhanzhang.baidu.com/push.js';
    }
    var s = document.getElementsByTagName("script")[0];
    s.parentNode.insertBefore(bp, s);
})();</script>
<script src='{{.Theme}}/js/jquery.min.js' type='text/javascript'></script>
<script src='{{.Theme}}/js/bootstrap.min.js' type='text/javascript'></script>
<script async="async" defer="defer" src="//cpro.baidustatic.com/cpro/ui/cm.js" type="text/javascript"></script>
<script> $("#menu-btn").on('click', function () { $(".site-navbar").toggle();}); </script>
</body>
</html>