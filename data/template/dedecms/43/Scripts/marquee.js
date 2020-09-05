//多复制一份
function unionpro_init() {
	var strHtml = document.getElementById("unionpro1").innerHTML
		.replace( '<table border="0" cellspacing="0" cellpadding="0"><tbody><tr>', '' )
		.replace( '</tr></tbody></table>', '' );
	//alert( strHtml );
	strHtml = '<table border="0" cellspacing="0" cellpadding="0"><tbody><tr>' +
		strHtml + strHtml +
		'</tr></tbody></table>';
	document.getElementById("unionpro1").innerHTML = strHtml;
}
unionpro_init();

var unionpro = document.getElementById("unionpro");
var unionpro1 = document.getElementById("unionpro1");
var unionpro2 = document.getElementById("unionpro2");
var unionpro_speed = 30;    //数值越大滚动速度越慢
unionpro2.innerHTML = unionpro1.innerHTML;

function unionpro_Marquee(){
    if( unionpro2.offsetWidth - unionpro.scrollLeft <= 0 ) {
        unionpro.scrollLeft -= unionpro1.offsetWidth;
	}
    else {
		unionpro.scrollLeft++;
    }
}
var unionpro_MyMar = setInterval( unionpro_Marquee, unionpro_speed );
unionpro.onmouseover = function(){ clearInterval( unionpro_MyMar ); }
unionpro.onmouseout = function(){ unionpro_MyMar = setInterval( unionpro_Marquee, unionpro_speed ); }
