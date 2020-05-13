//固定方式
(function($){
jQuery.fn.PositionFixed = function(options) {
	var defaults = {
		css:'',
		x:0,
		y:0
	};
	var o = jQuery.extend(defaults, options);
	var isIe6=false;
	if($.browser.msie && parseInt($.browser.version)==6)isIe6=true;			
	var html= $('html');
	if (isIe6 && html.css('backgroundAttachment') !== 'fixed') {
		html.css('backgroundAttachment','fixed') 
    };
	return this.each(function() {
	var domThis=$(this)[0];
	var objThis=$(this);
		if(isIe6){
			var left = parseInt(o.x) - html.scrollLeft(),
				top = parseInt(o.y) - html.scrollTop();
			objThis.css('position' , 'absolute');
			domThis.style.setExpression('left', 'eval((document.documentElement).scrollLeft + ' + o.x + ') + "px"');
			domThis.style.setExpression('top', 'eval((document.documentElement).scrollTop + ' + o.y + ') + "px"');	
		}else{
			objThis.css('position' , 'fixed').css('top',o.y).css('right',0);
		}
	});
};
})(jQuery)
function olne_domx(type,onlinex){
	var maxr=document.body.offsetWidth-$('#onlinebox').width();
	if(type>1){
		onlinex=document.body.scrollWidth-$('#onlinebox').width()-onlinex;
	}
	if(onlinex<0)onlinex=0;
	if(onlinex > maxr){
		onlinex=maxr;
		if($.browser.msie && parseInt($.browser.version)==6)onlinex=maxr-18;
	}
	return onlinex;
}
function olne_app(msg,type,mx,my){
	$('body').append(msg);
	mx=Number(olne_domx(type,mx));
	my=Number(my);
	$('#onlinebox').PositionFixed({x:mx,y:my}); 
	$('#onlinebox').show();
}
