(window.MIP=window.MIP||[]).push({name:"mip-semi-fixed",func:function(){var e=function(e){var t={};function n(r){if(t[r])return t[r].exports;var i=t[r]={i:r,l:!1,exports:{}};return e[r].call(i.exports,i,i.exports,n),i.l=!0,i.exports}return n.m=e,n.c=t,n.d=function(e,t,r){n.o(e,t)||Object.defineProperty(e,t,{enumerable:!0,get:r})},n.r=function(e){"undefined"!=typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(e,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(e,"__esModule",{value:!0})},n.t=function(e,t){if(1&t&&(e=n(e)),8&t)return e;if(4&t&&"object"==typeof e&&e&&e.__esModule)return e;var r=Object.create(null);if(n.r(r),Object.defineProperty(r,"default",{enumerable:!0,value:e}),2&t&&"string"!=typeof e)for(var i in e)n.d(r,i,function(t){return e[t]}.bind(null,i));return r},n.n=function(e){var t=e&&e.__esModule?function(){return e.default}:function(){return e};return n.d(t,"a",t),t},n.o=function(e,t){return Object.prototype.hasOwnProperty.call(e,t)},n.p="https://c.mipcdn.com/static/v2/",n(n.s=227)}({0:function(e,t){e.exports=__mipComponentsWebpackHelpers__["@babel/runtime/helpers/esm/classCallCheck"]},1:function(e,t){e.exports=__mipComponentsWebpackHelpers__["@babel/runtime/helpers/esm/createClass"]},10:function(e,t){e.exports=__mipComponentsWebpackHelpers__["core-js/modules/_to-length"]},11:function(e,t){e.exports=__mipComponentsWebpackHelpers__["core-js/modules/_fails"]},13:function(e,t){e.exports=__mipComponentsWebpackHelpers__["core-js/modules/_to-integer"]},14:function(e,t){e.exports=__mipComponentsWebpackHelpers__["core-js/modules/_export"]},15:function(e,t){e.exports=__mipComponentsWebpackHelpers__["core-js/modules/_redefine"]},17:function(e,t){e.exports=__mipComponentsWebpackHelpers__["core-js/modules/_hide"]},19:function(e,t,n){"use strict";var r=n(21),i=RegExp.prototype.exec,o=String.prototype.replace,s=i,a=function(){var e=/a/,t=/b*/g;return i.call(e,"a"),i.call(t,"a"),0!==e.lastIndex||0!==t.lastIndex}(),c=void 0!==/()??/.exec("")[1];(a||c)&&(s=function(e){var t,n,s,l,u=this;return c&&(n=new RegExp("^"+u.source+"$(?!\\s)",r.call(u))),a&&(t=u.lastIndex),s=i.call(u,e),a&&s&&(u.lastIndex=u.global?s.index+s[0].length:t),c&&s&&s.length>1&&o.call(s[0],n,function(){for(l=1;l<arguments.length-2;l++)void 0===arguments[l]&&(s[l]=void 0)}),s}),e.exports=s},2:function(e,t){e.exports=__mipComponentsWebpackHelpers__["core-js/modules/_wks"]},21:function(e,t,n){"use strict";var r=n(3);e.exports=function(){var e=r(this),t="";return e.global&&(t+="g"),e.ignoreCase&&(t+="i"),e.multiline&&(t+="m"),e.unicode&&(t+="u"),e.sticky&&(t+="y"),t}},225:function(e,t,n){(e.exports=n(31)(!1)).push(["cd5aca68d24deaaa","mip-semi-fixed{position:relative;width:100%}.mip-fixedlayer div[mip-semi-fixed-scrollStatus],mip-semi-fixed div[mip-semi-fixed-scrollStatus]{position:absolute;z-index:1;width:100%;-webkit-transform:translateZ(0);transform:translateZ(0)}.mip-fixedlayer mip-semi-fixed{position:fixed!important;width:100%}.mip-fixedlayer div[mip-semi-fixed-fixedStatus],mip-semi-fixed div[mip-semi-fixed-fixedStatus]{position:fixed;width:100%;z-index:999}",""])},226:function(e,t,n){var r=n(225);"string"==typeof r&&(r=[[e.i,r,""]]),r.locals&&(e.exports=r.locals);(0,n(30).default)("4b4ecb34",r,!0,{})},227:function(e,t,n){"use strict";n.r(t),n.d(t,"default",function(){return C});n(49);var r=n(0),i=n.n(r),o=n(1),s=n.n(o),a=n(6),c=n.n(a),l=n(4),u=n.n(l),p=n(5),f=n.n(p),d=(n(226),MIP),m=d.CustomElement,x=d.util,h=d.viewport,v=d.viewer.fixedElement,_=x.log("mip-semi-fixed"),b=_.warn,g=_.error,y="mip-semi-fixed-fixedStatus";var C=function(e){function t(){return i()(this,t),c()(this,u()(t).apply(this,arguments))}return f()(t,e),s()(t,[{key:"build",value:function(){var e=this,t=this.element,n=x.rect.getElementOffset(t).top;if(!v||!v._fixedLayer||t.parentNode!==v._fixedLayer)if(this.container=t.querySelector("div[mip-semi-fixed-container]"),this.container){if(this.threshold=t.getAttribute("threshold")||0,this.fixedClassNames=function(e){var t=e.getAttribute("fixed-class-names");return t||(t=e.getAttribute("fixedClassNames"))&&b("[Deprecated] fixedClassNames 写法即将废弃，请使用 fixed-class-names"),t}(t),this.container.setAttribute("mip-semi-fixed-scrollStatus",""),!MIP.standalone&&x.platform.isIos()){try{var r=v._fixedLayer.querySelector("#"+t.id);this.fixedContainer=r.querySelector("div[mip-semi-fixed-container]"),this.fixedContainer.className+=" "+this.fixedClassNames,this.fixedContainer.setAttribute(y,""),this.fixedContainer.removeAttribute("mip-semi-fixed-scrollStatus"),x.css(this.fixedContainer,{top:this.threshold+"px",opacity:0})}catch(e){g(e)}h.on("scroll",function(){return e.onIframeScroll(h)}),document.body.addEventListener("touchmove",function(){return e.onIframeScroll(h)}),this.onIframeScroll(h)}else h.on("scroll",function(){return e.onScroll(h)}),document.body.addEventListener("touchmove",function(){return e.onScroll(h)}),this.onScroll(h);!x.platform.isIos()&&n<=this.threshold?(this.container.className.indexOf(this.fixedClassNames)<0&&(this.container.className+=" "+this.fixedClassNames),this.container.setAttribute(y,""),x.css(this.container,"top",this.threshold+"px")):x.platform.isIos()&&!MIP.standalone&&n<=this.threshold&&(x.css(this.fixedContainer.parentNode,{display:"block"}),x.css(this.fixedContainer,{opacity:1}),x.css(this.container,{opacity:0})),this.addEventAction("close",function(n){n&&n.preventDefault&&n.preventDefault(),x.css(t,{display:"none"}),MIP.standalone||x.css(e.fixedContainer,{display:"none"})})}else g("必须有 <div mip-semi-fixed-container> 子节点")}},{key:"onScroll",value:function(){var e=this.element,t=this.container,n=this.threshold,r=this.fixedClassNames;x.rect.getElementOffset(e).top<=n?(t.className.indexOf(r)<0&&(t.className+=" "+r),t.setAttribute(y,""),x.css(t,"top",n+"px")):(t.className=t.className.replace(" "+r,""),t.removeAttribute(y),x.css(t,"top",""))}},{key:"onIframeScroll",value:function(){var e=this.element,t=this.container,n=this.fixedContainer,r=this.threshold,i=this.fixedClassNames;x.rect.getElementOffset(e).top<=r?(t.className.indexOf(i)<0&&(t.className+=" "+i),t.setAttribute(y,""),x.css(t,"top",r+"px"),x.css(n.parentNode,{display:"block"}),x.css(n,{opacity:1}),x.css(t,{opacity:0})):(t.className=t.className.replace(" "+i,""),t.removeAttribute(y),x.css(t,"top",""),x.css(n.parentNode,{display:"none"}),x.css(n,{opacity:0}),x.css(t,{opacity:1}))}}]),t}(m)},25:function(e,t,n){"use strict";n(36);var r=n(15),i=n(17),o=n(11),s=n(7),a=n(2),c=n(19),l=a("species"),u=!o(function(){var e=/./;return e.exec=function(){var e=[];return e.groups={a:"7"},e},"7"!=="".replace(e,"$<a>")}),p=function(){var e=/(?:)/,t=e.exec;e.exec=function(){return t.apply(this,arguments)};var n="ab".split(e);return 2===n.length&&"a"===n[0]&&"b"===n[1]}();e.exports=function(e,t,n){var f=a(e),d=!o(function(){var t={};return t[f]=function(){return 7},7!=""[e](t)}),m=d?!o(function(){var t=!1,n=/a/;return n.exec=function(){return t=!0,null},"split"===e&&(n.constructor={},n.constructor[l]=function(){return n}),n[f](""),!t}):void 0;if(!d||!m||"replace"===e&&!u||"split"===e&&!p){var x=/./[f],h=n(s,f,""[e],function(e,t,n,r,i){return t.exec===c?d&&!i?{done:!0,value:x.call(t,n,r)}:{done:!0,value:e.call(n,t,r)}:{done:!1}}),v=h[0],_=h[1];r(String.prototype,e,v),i(RegExp.prototype,f,2==t?function(e,t){return _.call(e,this,t)}:function(e){return _.call(e,this)})}}},26:function(e,t,n){"use strict";var r=n(35),i=RegExp.prototype.exec;e.exports=function(e,t){var n=e.exec;if("function"==typeof n){var o=n.call(e,t);if("object"!=typeof o)throw new TypeError("RegExp exec method returned something other than an Object or null");return o}if("RegExp"!==r(e))throw new TypeError("RegExp#exec called on incompatible receiver");return i.call(e,t)}},27:function(e,t,n){"use strict";var r=n(34)(!0);e.exports=function(e,t,n){return t+(n?r(e,t).length:1)}},29:function(e,t){e.exports=__mipComponentsWebpackHelpers__["core-js/modules/_to-object"]},3:function(e,t){e.exports=__mipComponentsWebpackHelpers__["core-js/modules/_an-object"]},30:function(e,t){e.exports=__mipComponentsWebpackHelpers__["vue-style-loader/lib/addStylesClient"]},31:function(e,t){e.exports=__mipComponentsWebpackHelpers__["css-loader/lib/css-base"]},34:function(e,t,n){var r=n(13),i=n(7);e.exports=function(e){return function(t,n){var o,s,a=String(i(t)),c=r(n),l=a.length;return c<0||c>=l?e?"":void 0:(o=a.charCodeAt(c))<55296||o>56319||c+1===l||(s=a.charCodeAt(c+1))<56320||s>57343?e?a.charAt(c):o:e?a.slice(c,c+2):s-56320+(o-55296<<10)+65536}}},35:function(e,t,n){var r=n(9),i=n(2)("toStringTag"),o="Arguments"==r(function(){return arguments}());e.exports=function(e){var t,n,s;return void 0===e?"Undefined":null===e?"Null":"string"==typeof(n=function(e,t){try{return e[t]}catch(e){}}(t=Object(e),i))?n:o?r(t):"Object"==(s=r(t))&&"function"==typeof t.callee?"Arguments":s}},36:function(e,t,n){"use strict";var r=n(19);n(14)({target:"RegExp",proto:!0,forced:r!==/./.exec},{exec:r})},4:function(e,t){e.exports=__mipComponentsWebpackHelpers__["@babel/runtime/helpers/esm/getPrototypeOf"]},49:function(e,t,n){"use strict";var r=n(3),i=n(29),o=n(10),s=n(13),a=n(27),c=n(26),l=Math.max,u=Math.min,p=Math.floor,f=/\$([$&`']|\d\d?|<[^>]*>)/g,d=/\$([$&`']|\d\d?)/g,m=function(e){return void 0===e?e:String(e)};n(25)("replace",2,function(e,t,n,x){return[function(r,i){var o=e(this),s=void 0==r?void 0:r[t];return void 0!==s?s.call(r,o,i):n.call(String(o),r,i)},function(e,t){var i=x(n,e,this,t);if(i.done)return i.value;var p=r(e),f=String(this),d="function"==typeof t;d||(t=String(t));var v=p.global;if(v){var _=p.unicode;p.lastIndex=0}for(var b=[];;){var g=c(p,f);if(null===g)break;if(b.push(g),!v)break;""===String(g[0])&&(p.lastIndex=a(f,o(p.lastIndex),_))}for(var y="",C=0,S=0;S<b.length;S++){g=b[S];for(var k=String(g[0]),N=l(u(s(g.index),f.length),0),j=[],I=1;I<g.length;I++)j.push(m(g[I]));var w=g.groups;if(d){var A=[k].concat(j,N,f);void 0!==w&&A.push(w);var E=String(t.apply(void 0,A))}else E=h(k,f,N,j,w,t);N>=C&&(y+=f.slice(C,N)+E,C=N+k.length)}return y+f.slice(C)}];function h(e,t,r,o,s,a){var c=r+e.length,l=o.length,u=d;return void 0!==s&&(s=i(s),u=f),n.call(a,u,function(n,i){var a;switch(i.charAt(0)){case"$":return"$";case"&":return e;case"`":return t.slice(0,r);case"'":return t.slice(c);case"<":a=s[i.slice(1,-1)];break;default:var u=+i;if(0===u)return n;if(u>l){var f=p(u/10);return 0===f?n:f<=l?void 0===o[f-1]?i.charAt(1):o[f-1]+i.charAt(1):n}a=o[u-1]}return void 0===a?"":a})}})},5:function(e,t){e.exports=__mipComponentsWebpackHelpers__["@babel/runtime/helpers/esm/inherits"]},6:function(e,t){e.exports=__mipComponentsWebpackHelpers__["@babel/runtime/helpers/esm/possibleConstructorReturn"]},7:function(e,t){e.exports=__mipComponentsWebpackHelpers__["core-js/modules/_defined"]},9:function(e,t){var n={}.toString;e.exports=function(e){return n.call(e).slice(8,-1)}}});e.__esModule&&(e=e.default),e&&MIP.registerElement("mip-semi-fixed",e)}});