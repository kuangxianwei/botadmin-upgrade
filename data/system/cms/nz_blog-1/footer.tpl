<div class="pc-footer">
  <div class="footer-content layout">
    <span>友情链接</span>
    <ul>{{- range links 30}}
            {{HTML .}}
        {{- end}}
    </ul>
    <p>{{HTML .Config.Copyright}}All Right Reserved<a href="{{.Config.Hostname}}/sitemap.xml" target="_blank">百度地图</a> </p>
  </div>
</div>
<script src="https://c.mipcdn.com/static/v2/mip.js" type="text/javascript"></script>
<script src="https://c.mipcdn.com/static/v1/mip-lightbox/mip-lightbox.js"></script>
<script src="https://c.mipcdn.com/static/v1/mip-form/mip-form.js"></script>
<script src="https://c.mipcdn.com/static/v1/mip-vd-tabs/mip-vd-tabs.js"></script>
<script src="https://c.mipcdn.com/static/v1/mip-semi-fixed/mip-semi-fixed.js"></script>
<script src="https://c.mipcdn.com/static/v1/mip-infinitescroll/mip-infinitescroll.js"></script>
<script src="https://c.mipcdn.com/static/v1/mip-mustache/mip-mustache.js"></script>
<script src="{{.Theme}}/js/main.js"></script>
<!--baidu-->
<script>
  (function () {
    var bp = document.createElement('script');
    var curProtocol = window.location.protocol.split(':')[0];
    if (curProtocol === 'https') {
      bp.src = 'https://zz.bdstatic.com/linksubmit/push.js';
    } else {
      bp.src = 'http://push.zhanzhang.baidu.com/push.js';
    }
    var s = document.getElementsByTagName("script")[0];
    s.parentNode.insertBefore(bp, s);
  })();
</script>
</body>
</html>