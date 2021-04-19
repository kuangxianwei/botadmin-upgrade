function Swipe(container, options) {

  "use strict";

  // utilities
  var noop = function() {}; // simple no operation function
  var offloadFn = function(fn) { setTimeout(fn || noop, 0) }; // offload a functions execution
  
  // check browser capabilities
  var browser = {
    addEventListener: !!window.addEventListener,
    touch: ('ontouchstart' in window) || window.DocumentTouch && document instanceof DocumentTouch,
    transitions: (function(temp) {
      var props = ['transitionProperty', 'WebkitTransition', 'MozTransition', 'OTransition', 'msTransition'];
      for ( var i in props ) if (temp.style[ props[i] ] !== undefined) return true;
      return false;
    })(document.createElement('swipe'))
  };

  // quit if no root element
  if (!container) return;
  var element = container.children[0];
  var slides, slidePos, width, length;
  options = options || {};
  var index = parseInt(options.startSlide, 10) || 0;
  var speed = options.speed || 300;
  options.continuous = options.continuous !== undefined ? options.continuous : true;

  function setup() {

    // cache slides
    slides = element.children;
    length = slides.length;

    // set continuous to false if only one slide
    if (slides.length < 3) options.continuous = false;

    //special case if two slides
    if (browser.transitions && options.continuous && slides.length < 3) {
      element.appendChild(slides[0].cloneNode(true));
      element.appendChild(element.children[1].cloneNode(true));
      slides = element.children;
    }

    // create an array to store current positions of each slide
    slidePos = new Array(slides.length);

    // determine width of each slide
    width = container.getBoundingClientRect().width || container.offsetWidth;

    element.style.width = (slides.length * width) + 'px';

    // stack elements
    var pos = slides.length;
    while(pos--) {

      var slide = slides[pos];

      slide.style.width = width + 'px';
      slide.setAttribute('data-index', pos);

      if (browser.transitions) {
        slide.style.left = (pos * -width) + 'px';
        move(pos, index > pos ? -width : (index < pos ? width : 0), 0);
      }

    }

    // reposition elements before and after index
    if (options.continuous && browser.transitions) {
      move(circle(index-1), -width, 0);
      move(circle(index+1), width, 0);
    }

    if (!browser.transitions) element.style.left = (index * -width) + 'px';

    container.style.visibility = 'visible';

  }

  function prev() {

    if (options.continuous) slide(index-1);
    else if (index) slide(index-1);

  }

  function next() {

    if (options.continuous) slide(index+1);
    else if (index < slides.length - 1) slide(index+1);

  }

  function circle(index) {

    // a simple positive modulo using slides.length
    return (slides.length + (index % slides.length)) % slides.length;

  }

  function slide(to, slideSpeed) {

    // do nothing if already on requested slide
    if (index == to) return;
    
    if (browser.transitions) {

      var direction = Math.abs(index-to) / (index-to); // 1: backward, -1: forward

      // get the actual position of the slide
      if (options.continuous) {
        var natural_direction = direction;
        direction = -slidePos[circle(to)] / width;

        // if going forward but to < index, use to = slides.length + to
        // if going backward but to > index, use to = -slides.length + to
        if (direction !== natural_direction) to =  -direction * slides.length + to;

      }

      var diff = Math.abs(index-to) - 1;

      // move all the slides between index and to in the right direction
      while (diff--) move( circle((to > index ? to : index) - diff - 1), width * direction, 0);
            
      to = circle(to);

      move(index, width * direction, slideSpeed || speed);
      move(to, 0, slideSpeed || speed);

      if (options.continuous) move(circle(to - direction), -(width * direction), 0); // we need to get the next in place
      
    } else {     
      
      to = circle(to);
      animate(index * -width, to * -width, slideSpeed || speed);
      //no fallback for a circular continuous if the browser does not accept transitions
    }

    index = to;
    offloadFn(options.callback && options.callback(index, slides[index]));
  }

  function move(index, dist, speed) {

    translate(index, dist, speed);
    slidePos[index] = dist;

  }

  function translate(index, dist, speed) {

    var slide = slides[index];
    var style = slide && slide.style;

    if (!style) return;

    style.webkitTransitionDuration = 
    style.MozTransitionDuration = 
    style.msTransitionDuration = 
    style.OTransitionDuration = 
    style.transitionDuration = speed + 'ms';

    style.webkitTransform = 'translate(' + dist + 'px,0)' + 'translateZ(0)';
    style.msTransform = 
    style.MozTransform = 
    style.OTransform = 'translateX(' + dist + 'px)';

  }

  function animate(from, to, speed) {

    // if not an animation, just reposition
    if (!speed) {

      element.style.left = to + 'px';
      return;

    }
    
    var start = +new Date;
    
    var timer = setInterval(function() {

      var timeElap = +new Date - start;
      
      if (timeElap > speed) {

        element.style.left = to + 'px';

        if (delay) begin();

        options.transitionEnd && options.transitionEnd.call(event, index, slides[index]);

        clearInterval(timer);
        return;

      }

      element.style.left = (( (to - from) * (Math.floor((timeElap / speed) * 100) / 100) ) + from) + 'px';

    }, 4);

  }

  // setup auto slideshow
  var delay = options.auto || 0;
  var interval;

  function begin() {

    interval = setTimeout(next, delay);

  }

  function stop() {

    delay = 0;
    clearTimeout(interval);

  }


  // setup initial vars
  var start = {};
  var delta = {};
  var isScrolling;      

  // setup event capturing
  var events = {

    handleEvent: function(event) {

      switch (event.type) {
        case 'touchstart': this.start(event); break;
        case 'touchmove': this.move(event); break;
        case 'touchend': offloadFn(this.end(event)); break;
        case 'webkitTransitionEnd':
        case 'msTransitionEnd':
        case 'oTransitionEnd':
        case 'otransitionend':
        case 'transitionend': offloadFn(this.transitionEnd(event)); break;
        case 'resize': offloadFn(setup.call()); break;
      }

      if (options.stopPropagation) event.stopPropagation();

    },
    start: function(event) {

      var touches = event.touches[0];

      // measure start values
      start = {

        // get initial touch coords
        x: touches.pageX,
        y: touches.pageY,

        // store time to determine touch duration
        time: +new Date

      };
      
      // used for testing first move event
      isScrolling = undefined;

      // reset delta and end measurements
      delta = {};

      // attach touchmove and touchend listeners
      element.addEventListener('touchmove', this, false);
      element.addEventListener('touchend', this, false);

    },
    move: function(event) {

      // ensure swiping with one touch and not pinching
      if ( event.touches.length > 1 || event.scale && event.scale !== 1) return

      if (options.disableScroll) event.preventDefault();

      var touches = event.touches[0];

      // measure change in x and y
      delta = {
        x: touches.pageX - start.x,
        y: touches.pageY - start.y
      }

      // determine if scrolling test has run - one time test
      if ( typeof isScrolling == 'undefined') {
        isScrolling = !!( isScrolling || Math.abs(delta.x) < Math.abs(delta.y) );
      }

      // if user is not trying to scroll vertically
      if (!isScrolling) {

        // prevent native scrolling 
        event.preventDefault();

        // stop slideshow
        stop();

        // increase resistance if first or last slide
        if (options.continuous) { // we don't add resistance at the end

          translate(circle(index-1), delta.x + slidePos[circle(index-1)], 0);
          translate(index, delta.x + slidePos[index], 0);
          translate(circle(index+1), delta.x + slidePos[circle(index+1)], 0);

        } else {

          delta.x = 
            delta.x / 
              ( (!index && delta.x > 0               // if first slide and sliding left
                || index == slides.length - 1        // or if last slide and sliding right
                && delta.x < 0                       // and if sliding at all
              ) ?                      
              ( Math.abs(delta.x) / width + 1 )      // determine resistance level
              : 1 );                                 // no resistance if false
          
          // translate 1:1
          translate(index-1, delta.x + slidePos[index-1], 0);
          translate(index, delta.x + slidePos[index], 0);
          translate(index+1, delta.x + slidePos[index+1], 0);
        }

      }

    },
    end: function(event) {

      // measure duration
      var duration = +new Date - start.time;

      // determine if slide attempt triggers next/prev slide
      var isValidSlide = 
            Number(duration) < 250               // if slide duration is less than 250ms
            && Math.abs(delta.x) > 20            // and if slide amt is greater than 20px
            || Math.abs(delta.x) > width/2;      // or if slide amt is greater than half the width

      // determine if slide attempt is past start and end
      var isPastBounds = 
            !index && delta.x > 0                            // if first slide and slide amt is greater than 0
            || index == slides.length - 1 && delta.x < 0;    // or if last slide and slide amt is less than 0

      if (options.continuous) isPastBounds = false;
      
      // determine direction of swipe (true:right, false:left)
      var direction = delta.x < 0;

      // if not scrolling vertically
      if (!isScrolling) {

        if (isValidSlide && !isPastBounds) {

          if (direction) {

            if (options.continuous) { // we need to get the next in this direction in place

              move(circle(index-1), -width, 0);
              move(circle(index+2), width, 0);

            } else {
              move(index-1, -width, 0);
            }

            move(index, slidePos[index]-width, speed);
            move(circle(index+1), slidePos[circle(index+1)]-width, speed);
            index = circle(index+1);  
                      
          } else {
            if (options.continuous) { // we need to get the next in this direction in place

              move(circle(index+1), width, 0);
              move(circle(index-2), -width, 0);

            } else {
              move(index+1, width, 0);
            }

            move(index, slidePos[index]+width, speed);
            move(circle(index-1), slidePos[circle(index-1)]+width, speed);
            index = circle(index-1);

          }

          options.callback && options.callback(index, slides[index]);

        } else {

          if (options.continuous) {

            move(circle(index-1), -width, speed);
            move(index, 0, speed);
            move(circle(index+1), width, speed);

          } else {

            move(index-1, -width, speed);
            move(index, 0, speed);
            move(index+1, width, speed);
          }

        }

      }

      // kill touchmove and touchend event listeners until touchstart called again
      element.removeEventListener('touchmove', events, false)
      element.removeEventListener('touchend', events, false)

    },
    transitionEnd: function(event) {

      if (parseInt(event.target.getAttribute('data-index'), 10) == index) {
        
        if (delay) begin();

        options.transitionEnd && options.transitionEnd.call(event, index, slides[index]);

      }

    }

  }

  // trigger setup
  setup();

  // start auto slideshow if applicable
  if (delay) begin();


  // add event listeners
  if (browser.addEventListener) {
    
    // set touchstart event on element    
    if (browser.touch) element.addEventListener('touchstart', events, false);

    if (browser.transitions) {
      element.addEventListener('webkitTransitionEnd', events, false);
      element.addEventListener('msTransitionEnd', events, false);
      element.addEventListener('oTransitionEnd', events, false);
      element.addEventListener('otransitionend', events, false);
      element.addEventListener('transitionend', events, false);
    }

    // set resize event on window
    window.addEventListener('resize', events, false);

  } else {

    window.onresize = function () { setup() }; // to play nice with old IE

  }

  // expose the Swipe API
  return {
    setup: function() {

      setup();

    },
    slide: function(to, speed) {
      
      // cancel slideshow
      stop();
      
      slide(to, speed);

    },
    prev: function() {

      // cancel slideshow
      stop();

      prev();

    },
    next: function() {

      // cancel slideshow
      stop();

      next();

    },
    getPos: function() {

      // return current index position
      return index;

    },
    getNumSlides: function() {
      
      // return total number of slides
      return length;
    },
    kill: function() {

      // cancel slideshow
      stop();

      // reset element
      element.style.width = 'auto';
      element.style.left = 0;

      // reset slides
      var pos = slides.length;
      while(pos--) {

        var slide = slides[pos];
        slide.style.width = '100%';
        slide.style.left = 0;

        if (browser.transitions) translate(pos, 0, 0);

      }

      // removed event listeners
      if (browser.addEventListener) {

        // remove current event listeners
        element.removeEventListener('touchstart', events, false);
        element.removeEventListener('webkitTransitionEnd', events, false);
        element.removeEventListener('msTransitionEnd', events, false);
        element.removeEventListener('oTransitionEnd', events, false);
        element.removeEventListener('otransitionend', events, false);
        element.removeEventListener('transitionend', events, false);
        window.removeEventListener('resize', events, false);

      }
      else {

        window.onresize = null;

      }

    }
  }

}

if ( window.jQuery || window.Zepto ) {
  (function($) {
    $.fn.Swipe = function(params) {
      return this.each(function() {
        $(this).data('Swipe', new Swipe($(this)[0], params));
      });
    }
  })( window.jQuery || window.Zepto )
}



// 导航
$(document).ready(function()
{
	//slides the element with class "menu_body" when paragraph with class "menu_head" is clicked 
	$("#firstpane a.menu_head").click(function()
    {
		$(this).next("div.menu_body").slideToggle(300).siblings("div.menu_body").slideUp("slow");
	});
	//slides the element with class "menu_body" when mouse is over the paragraph
	$("#secondpane a.menu_head").mouseover(function()
    {
	     $(this).next("div.menu_body").slideDown(500).siblings("div.menu_body").slideUp("slow");
	});
});


(function(window, undefined){
	var ADSupportsTouches = ("createTouch" in document) || ('ontouchstart' in window) || 0,
		doc=document.documentElement || document.getElementsByTagName('html')[0],
		ADSupportsTransition = ("WebkitTransition" in doc.style) 
							|| ("MsTransition" in doc.style) 
							|| ("MozTransition" in doc.style) 
							|| ("OTransition" in doc.style) 
							|| ("transition" in doc.style) 
							|| 0,
		ADStartEvent = ADSupportsTouches ? "touchstart" : "mousedown",
		ADMoveEvent = ADSupportsTouches ? "touchmove" : "mousemove",
		ADEndEvent = ADSupportsTouches ? "touchend" : "mouseup",
		TouchSlider=function(opt){
			this.opt=this.parse_args(opt);
			this.container=this.$(this.opt.id);
			try{
				if(this.container.nodeName.toLowerCase()=='ul'){
					this.element=this.container;
					this.container=this.element.parentNode;
				}else{
					this.element=this.container.getElementsByTagName('ul')[0];
				}
				if(typeof this.element==='undefined')throw new Error('Can\'t find "ul"');
				for(var i=0;i<this.instance.length;i++){
					if(this.instance[i]==this.container) throw new Error('An instance is running');
				}
				this.instance.push(this.container);
				this.setup();
			}catch(e){
				this.status=-1;
				this.errorInfo=e.message;
			}
		}
		
	TouchSlider.prototype={
		//榛樿閰嶇疆
		_default: {
			'id': 'slider', //骞荤伅瀹瑰櫒鐨刬d
			'fx': 'ease-out', //css3鍔ㄧ敾鏁堟灉锛坙inear,ease,ease-out,ease-in,ease-in-out锛夛紝涓嶆敮鎸乧ss3娴忚鍣ㄥ彧鏈塭ase-out鏁堟灉
			'auto': 0, //鏄惁鑷姩寮€濮嬶紝璐熸暟琛ㄧず闈炶嚜鍔ㄥ紑濮嬶紝0,1,2,3....琛ㄧず鑷姩寮€濮嬩互鍙婁粠绗嚑涓紑濮�
			'speed':600, //鍔ㄧ敾鏁堟灉鎸佺画鏃堕棿 ms
			'timeout':5000,//骞荤伅闂撮殧鏃堕棿 ms
			'className':'', //姣忎釜骞荤伅鎵€鍦ㄧ殑li鏍囩鐨刢lassname,
			'direction':'left', //left right up down
			'mouseWheel':false,
			'before':new Function(),
			'after':new Function()
		},
		instance:[],
		//鏍规嵁id鑾峰彇鑺傜偣
		$:function(id){
			return document.getElementById(id);
		},
		//鏍规嵁class銆佹爣绛捐幏鍙杙arent涓嬬殑鑺傜偣绨� getElementsByClass
		$E:function(classname, tagname, parent){
			var result=[],
				_array=parent.getElementsByTagName(tagname);
			for(var i=0,j=_array.length;i<j;i++){
				if((new RegExp("(?:^|\\s+)"+classname+"(?:\\s+|$)")).test(_array[i].className)){
					result.push(_array[i]);
				}
			}
			return result;
		},
		isIE:function(){ //涓嶅寘鎷琁E9+锛孖E9寮€濮嬫敮鎸乄3C缁濆ぇ閮ㄥ垎浜嬩欢 鏂规硶浜�
			return !-[1,];
		},
		//璁剧疆OR鑾峰彇鑺傜偣鏍峰紡
		css:(function(){
			var styleFilter=function(property){
					switch(property){
						case 'float' : return ("cssFloat" in document.body.style) ? 'cssFloat' : 'styleFloat';
									  break;
						case 'opacity' : return ("opacity" in document.body.style) ? 'opacity' :
										{
											get : function(el,style){
												var ft=style.filter;
												return ft&&ft.indexOf('opacity')>=0&&parseFloat(ft.match(/opacity=([^)]*)/i)[1])/100+''||'1';
											},
											set : function(el,va){
												el.style.filter='alpha(opacity='+va*100+')';
												el.style.zoom=1;
											}
										} ;
									  break;
						default:var arr=property.split('-');
								for(var i = 1; i < arr.length; i++)
									arr[i] = arr[i].substring(0,1).toUpperCase() + arr[i].substring(1);
								property = arr.join('');
								return property;
								break;
					}
				},
				getStyle=function(el,property){
					property=styleFilter(property);
					var value = el.style[property];
					if (!value) {
						var style = document.defaultView && document.defaultView.getComputedStyle && getComputedStyle(el, null) || el.currentStyle || el.style;
						if(typeof property=='string'){
							value=style[property];
						}else value=property.get(el,style);
					}
					return value == 'auto' ? '' : value;
				},
				setStyle=function(el,css){
					var attr;
					for(var key in css){
						attr=styleFilter(key);
						if(typeof attr=='string'){
							el.style[attr]=css[key];
						}else{
							attr.set(el,css[key]);
						}
					}
				}
				return function(el,css){
					return typeof css=='string'?getStyle(el,css):setStyle(el,css);
				}
		})(),
		//鏍煎紡鍖栧弬鏁�
		parse_args: function(r){
			var _default={}, toString=Object.prototype.toString;
			if(r && toString.call(r)=='[object Object]')
				for(var key in this._default){
					_default[key]=typeof r[key]==='undefined' ? this._default[key] : toString.call(this._default[key])=='[object Number]' ? parseInt(parseFloat(r[key])*100)/100 : r[key];
				}
			else _default=this._default;
			return _default;
		},
		//缁戝畾浜嬩欢
		addListener: function(e, n, o, u){
			if(e.addEventListener){
				e.addEventListener(n, o, u);
				return true;
			} else if(e.attachEvent){
				e.attachEvent('on' + n, o);
				return true;
			}
			return false;
		},
		//鑾峰彇榧犳爣鍧愭爣
		getMousePoint:function(ev) {
			var x = y = 0,
			doc = document.documentElement,
			body = document.body;
			if(!ev) ev=window.event;
			if (window.pageYoffset) {
				x = window.pageXOffset;
				y = window.pageYOffset;
			}else{
				x = (doc && doc.scrollLeft || body && body.scrollLeft || 0) - (doc && doc.clientLeft || body && body.clientLeft || 0);
				y = (doc && doc.scrollTop  || body && body.scrollTop  || 0) - (doc && doc.clientTop  || body && body.clientTop  || 0);
			}
			if(ADSupportsTouches && ev.touches.length){
				var evt = ev.touches[0];
				x += evt.clientX;
				y += evt.clientY;
			}else{
				x += ev.clientX;
				y += ev.clientY;
			}
			return {'x' : x, 'y' : y};
		},
		//淇鍑芥暟浣滅敤鐜
		bind:function(func, obj){
			return function(){
				return func.apply(obj, arguments);
			}
		},
		preventDefault:function(e){
			if(window.event)window.event.returnValue=false;
			else e.preventDefault();
		},
		//鍒濆鍖�
		setup: function(){
			this.status=0;//鐘舵€佺爜锛�0琛ㄧず鍋滄鐘舵€侊紝1琛ㄧず杩愯鐘舵€侊紝2琛ㄧず鏆傚仠鐘舵€侊紝-1琛ㄧず鍑洪敊
			this.slides=this.opt.className?this.$E(this.opt.className,'li',this.element):this.element.getElementsByTagName('li');
			this.length=this.slides.length; this.opt.timeout=Math.max(this.opt.timeout,this.opt.speed);
			this.touching=!!ADSupportsTouches; this.css3transition=!!ADSupportsTransition; 
			this.index=this.opt.auto<0 || this.opt.auto>=this.length ? 0:this.opt.auto;
			if(this.length<2)return;//灏忎簬2涓嶉渶瑕佹粴鍔�
			switch(this.opt.direction){
				case 'up': this.direction='up'; this.vertical=true; break;
				case 'down': this.direction='down'; this.vertical=true; break;
				case 'right': this.direction='right'; this.vertical=false; break;
				default:this.direction='left'; this.vertical=false; break;
			}
			this.resize(); this.begin();

			this.addListener(this.element,ADStartEvent,this.bind(this._start,this),false);
			this.addListener(document,ADMoveEvent,this.bind(this._move,this),false);
			this.addListener(document,ADEndEvent,this.bind(this._end,this),false);
			this.addListener(this.element,'webkitTransitionEnd',this.bind(this._transitionend,this),false);
			this.addListener(this.element,'msTransitionEnd',this.bind(this._transitionend,this),false);
			this.addListener(this.element,'oTransitionEnd',this.bind(this._transitionend,this),false);
			this.addListener(this.element,'transitionend',this.bind(this._transitionend,this),false);
			this.addListener(window,'resize',this.bind(function(){
				clearTimeout(this.resizeTimer);
				this.resizeTimer=setTimeout(this.bind(this.resize,this),100);
			},this),false);
			this.addListener(this.element,'mousewheel',this.bind(this.mouseScroll,this),false);
			this.addListener(this.element,'DOMMouseScroll',this.bind(this.mouseScroll,this),false);
		},
		resize:function(){
			var css;
			this.css(this.container,{'overflow':'hidden','visibility':'hidden','listStyle':'none','position':'relative'});
			this.width=this.container.clientWidth-parseInt(this.css(this.container,'padding-left'))-parseInt(this.css(this.container,'padding-right'));
			this.height=this.container.clientHeight-parseInt(this.css(this.container,'padding-top'))-parseInt(this.css(this.container,'padding-bottom'));
			css={'position':'relative','webkitTransitionDuration':'0ms','MozTransitionDuration':'0ms','msTransitionDuration':'0ms','OTransitionDuration':'0ms','transitionDuration':'0ms'}
			if(this.vertical){
				css['height']=this.height*this.length+'px';
				css['top']=-this.height*this.index+'px';
				this.css(this.container,{'height':this.height+'px'});
			}else{
				css['width']=this.width*this.length+'px';
				css['left']=-this.width*this.index+'px';
			}
			this.css(this.element,css);
			for(var i=0;i<this.length;i++){
				this.css(this.slides[i],{'width':this.width+'px',height:this.height+'px','display':this.vertical?'table-row':'table-cell',padding:0,margin:0,float:'left',verticalAlign:'top'});
			}
			this.css(this.container,{'visibility':'visible'});
		},
		slide:function(index, speed){
			var direction=this.vertical?'top':'left', size=this.vertical?'height':'width';
			index=index<0?this.length-1:index>=this.length?0:index;
			speed=typeof speed == 'undefined' ? this.opt.speed : parseInt(speed);
			var el=this.element, timer=null,
				style=el.style,
				_this=this,
				t=0, //鍔ㄧ敾寮€濮嬫椂闂�
				b=parseInt(style[direction]) || 0, //鍒濆閲�
				c=-index*this[size]-b, //鍙樺寲閲�
				d=Math.abs(c)<this[size]?Math.ceil(Math.abs(c)/this[size]*speed/10):speed/10,//鍔ㄧ敾鎸佺画鏃堕棿
				ani=function(t,b,c,d){ //缂撳姩鏁堟灉璁＄畻鍏紡
					return -c * ((t=t/d-1)*t*t*t - 1) + b;
				},
				run=function(){
					if(t<d && !ADSupportsTransition){
						t++;
						style[direction]=Math.ceil(ani(t,b,c,d))+'px';
						timer=setTimeout(run, 10);
					}else{
						style[direction]=-_this[size]*index+'px';
						_this.index=index;
						if(!ADSupportsTransition)_this._transitionend();
						_this.pause();_this.begin();
					}
				}
			style.WebkitTransition=style.MozTransition=style.msTransition=style.OTransition=style.transition = direction+' '+(d*10)+'ms '+this.opt.fx;
			this.opt.before.call(this, index, this.slides[this.index]); run();
		},
		begin:function(){
			if(this.timer || this.opt.auto<0)return true;
			this.timer=setTimeout(this.bind(function(){
				this.direction=='left'||this.direction=='up' ? this.next() : this.prev();
			},this), this.opt.timeout);
			this.status=1;
		},
		pause:function(){
			clearInterval(this.timer);
			this.timer=null;
			this.status=2;
		},
		stop:function(){
			this.pause();
			this.index=0;
			this.slide(0);
			this.status=0;
		},
		prev:function(offset){
			offset=typeof offset == 'undefined'?offset=1:offset%this.length;
			var index=offset>this.index?this.length+this.index-offset:this.index-offset;
			this.slide(index);
		},
		next:function(offset){
			if(typeof offset == 'undefined') offset=1;
			this.slide((this.index+offset)%this.length);
		},
		_start:function(e){
			if(!this.touching)this.preventDefault(e);
			this.element.onclick=null
			this.startPos=this.getMousePoint(e);
			var style=this.element.style;
			style.webkitTransitionDuration = style.MozTransitionDuration = style.msTransitionDuration = style.OTransitionDuration = style.transitionDuration = '0ms';
			this.scrolling=1;//婊氬姩灞忓箷
			this.startTime=new Date();
		},
		_move:function(e){
			if(!this.scrolling || e.touches && e.touches.length>1 || e.scale && e.scale !== 1) return;
			var direction=this.vertical?'top':'left', size=this.vertical?'height':'width', xy=this.vertical?'y':'x', yx=this.vertical?'x':'y';
			this.endPos=this.getMousePoint(e);
			var offx=this.endPos[xy]-this.startPos[xy];
			if(this.scrolling===2 || Math.abs(offx)>=Math.abs(this.endPos[yx]-this.startPos[yx])){
				this.preventDefault(e);
				this.pause(); //鏆傚仠骞荤伅
				offx=offx/((!this.index&&offx>0 || this.index==this.length-1&&offx<0) ? (Math.abs(offx)/this[size]+1) : 1);
				this.element.style[direction]=-this.index*this[size]+offx+'px';
				if(offx!=0)this.scrolling=2;//鏍囪鎷栧姩锛堟湁鏁堣Е鎽革級2
			}else this.scrolling=0;//璁剧疆涓烘憭寮冩爣璁�0
		},
		_end:function(e){
			if(typeof this.scrolling != 'undefined'){
				try{
					var xy=this.vertical?'y':'x', size=this.vertical?'height':'width', offx=this.endPos[xy]-this.startPos[xy];
					if(this.scrolling===2)this.element.onclick=new Function('return false;');
				}catch(err){
					offx=0;
				}
				if((new Date()-this.startTime<250 && Math.abs(offx)>this[size]*0.1 || Math.abs(offx)>this[size]/2) && ((offx<0 && this.index+1<this.length) || (offx>0 && this.index>0))){
					offx>0?this.prev():this.next();
				}else{
					this.slide(this.index);
				}
				delete this.scrolling;
				delete this.startPos;
				delete this.endPos;
				delete this.startTime;
				if(this.opt.auto>=0)this.begin();				
			}
		},
		mouseScroll:function(e){
			if(this.opt.mouseWheel){
				this.preventDefault(e);
				e=e||window.event;
				var wheelDelta=e.wheelDelta || e.detail && e.detail*-1 || 0,
					flag=wheelDelta/Math.abs(wheelDelta);
				wheelDelta>0?this.next():this.prev();
			}
		},
		_transitionend:function(e){
			this.opt.after.call(this, this.index, this.slides[this.index]);
		}
	}
	window.TouchSlider=TouchSlider;
})(window, undefined);

 