// JScript 文件

 //分别是关闭,最小化,最大化

    function showDiv(innerCall) {
        document.getElementById('PcPoPmarket').style.height = 245 + 'px';
        document.getElementById('showvod').style.display = 'none';
        document.getElementById('hidevod').style.display = 'block';
    }
    function hideDiv(innerCall) {
        if (document.getElementById('PcPoPmarket') == null) return;
        document.getElementById('PcPoPmarket').style.height = 29 + 'px';
        document.getElementById('hidevod').style.display = 'none';
        document.getElementById('showvod').style.display = 'block';
    }

    var s = "";
    var url = "../../message"; //链接
    try {
        //以下是为了兼容 xhtml1.0 和 html4两种情况 / ie6 ie7 ff 的兼容用hack
        document.compatMode && document.compatMode != 'BackCompat'
        s += ('<span id=tmpAreaLmtDiv><DIV style="z-index:9;right:0;bottom:0; height:245px;width:210px;overflow:hidden;POSITION:fixed;' + (/MSIE 7/.test(navigator.appVersion) ? '' : '_position:absolute; _margin-top:expression(document.documentElement.clientHeight-this.style.pixelHeight+document.documentElement.scrollTop);') + '" id="PcPoPmarket" >');
        s += (' <div style="z-index:9; POSITION: absolute; width:210px; height:29px; overflow:hidden;"><span style="CURSOR: pointer;float:left;clear:none; width:123px; height:13px; overflow:hidden; margin:10px 5px;"></span><span title="\u5C55\u5F00" style="background:url('+url+'/images/fd.png);CURSOR: pointer;float:right; width:15px; height:13px; overflow:hidden;clear:none;display:none; margin:9px 15px 0 0; " onclick=showDiv() id="showvod"></span><span title="\u6700\u5C0F\u5316" style="background:url('+url+'/images/sx.png);CURSOR: pointer;float:right;overflow:hidden; width:15px; height:13px; clear:none; display:bolck; margin:9px 15px 0 0;" onclick=hideDiv() id="hidevod"></span></div> ');
        s += ("<iframe scrolling=no frameborder=0 width=210 height=245 src=" + url + "/Message.htm></iframe>");
        s += ('</DIV></span>');
        document.write(s);
        //document.getElementById('tmpAreaLmtDiv').innerHTML = s;
        //setTimeout('hideDiv(true);', 1000);
    } catch (err) { document.write(err); }
    showDiv(true);
