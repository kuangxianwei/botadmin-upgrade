function showswf(file,w,h) {
    document.write('<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,19,0" width="'+w+'" height="'+h+'"> ');
    document.write('<param name="movie" value="' + file + '">');
    document.write('<param name="quality" value="high"> ');
    document.write('<param name="wmode" value="transparent"> ');
    document.write('<param name="menu" value="false"> ');
    document.write('<embed wmode="transparent" src="' + file + '" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="'+w+'" height="'+h+'"></embed> ');
    document.write('</object> ');
}

function showtime() {
today=new Date();
function initArray(){
this.length=initArray.arguments.length;
for(var i=0;i<this.length;i++)
this[i+1]=initArray.arguments[i]; }
var d=new initArray("星期日","星期一","星期二","星期三","星期四","星期五","星期六");
document.write("",today.getYear(),"年","",today.getMonth()+1,"月","",today.getDate(),"日 ",d[today.getDay()+1]);
}

function showbanner() {
        <!--
        var focus_width=1002
        var focus_height=288
        var text_height=0
        var swf_height = focus_height+text_height
		var pics='/template/images/banner1.jpg|/template/images/banner2.jpg|/template/images/banner3.jpg'
        var links='|'
        var texts='|'

        document.write('<object ID="focus_flash" classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0" width="'+ focus_width +'" height="'+ swf_height +'">');
        document.write('<param name="allowScriptAccess" value="sameDomain"><param name="movie" value="/template/images/adplay.swf"><param name="quality" value="high"><param name="bgcolor" value="#FFFFFF">');
        document.write('<param name="menu" value="false"><param name=wmode value="opaque">');
        document.write('<param name="FlashVars" value="pics='+pics+'&links='+links+'&texts='+texts+'&borderwidth='+focus_width+'&borderheight='+focus_height+'&textheight='+text_height+'">');
        document.write('<embed ID="focus_flash" src="/template/images/adplay.swf" wmode="opaque" FlashVars="pics='+pics+'&links='+links+'&texts='+texts+'&borderwidth='+focus_width+'&borderheight='+focus_height+'&textheight='+text_height+'" menu="false" bgcolor="#C5C5C5" quality="high" width="'+ focus_width +'" height="'+ swf_height +'" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />');document.write('</object>'); 
        //-->
}
