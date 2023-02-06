<div class="footer">
  <div class="am-g">
    <div class="footer-b">
      <p>{{- range classes 12}}
          <a href="{{.Url}}" title="{{.Name}}">{{.Name}}</a>&nbsp;&nbsp;
          {{- end}}</p>
      <p>{{HTML .Config.Copyright}}All Right Reserved<a href="{{.Config.Hostname}}/sitemap.xml" target="_blank">百度地图</a> </p>
    </div>
  </div>
</div>
<mip-fixed type="gototop">
  <mip-gototop></mip-gototop>
</mip-fixed>
<script src="{{.Theme}}/js/mip.js"></script>
<script src="{{.Theme}}/js/mip-sidebar.js"></script>
<script src="{{.Theme}}/js/mip-fixed.js"></script>
<script src="{{.Theme}}/js/mip-gototop.js"></script>
<script src="{{.Theme}}/js/mip-stats-baidu.js"></script>
<script src="{{.Theme}}/js/mip-form.js"></script>
<script src="{{.Theme}}/js/mip-vd-tabs.js"></script>
<script src="{{.Theme}}/js/mip-semi-fixed.js"></script>
<script src="{{.Theme}}/js/mip-share.js"></script>
<script src="{{.Theme}}/js/mip-changyan.js"></script>
<script src="{{.Theme}}/js/mip-cambrian.js"></script>
<script src="{{.Theme}}/js/mip-anim.js"></script>
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