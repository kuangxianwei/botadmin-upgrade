(window.MIP=window.MIP||[]).push({name:"mip-stats-cnzz",func:function(){var e=function(e){var t={};function n(r){if(t[r])return t[r].exports;var o=t[r]={i:r,l:!1,exports:{}};return e[r].call(o.exports,o,o.exports,n),o.l=!0,o.exports}return n.m=e,n.c=t,n.d=function(e,t,r){n.o(e,t)||Object.defineProperty(e,t,{enumerable:!0,get:r})},n.r=function(e){"undefined"!=typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(e,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(e,"__esModule",{value:!0})},n.t=function(e,t){if(1&t&&(e=n(e)),8&t)return e;if(4&t&&"object"==typeof e&&e&&e.__esModule)return e;var r=Object.create(null);if(n.r(r),Object.defineProperty(r,"default",{enumerable:!0,value:e}),2&t&&"string"!=typeof e)for(var o in e)n.d(r,o,function(t){return e[t]}.bind(null,o));return r},n.n=function(e){var t=e&&e.__esModule?function(){return e.default}:function(){return e};return n.d(t,"a",t),t},n.o=function(e,t){return Object.prototype.hasOwnProperty.call(e,t)},n.p="https://c.mipcdn.com/static/v2/",n(n.s=210)}({0:function(e,t){e.exports=__mipComponentsWebpackHelpers__["@babel/runtime/helpers/esm/classCallCheck"]},1:function(e,t){e.exports=__mipComponentsWebpackHelpers__["@babel/runtime/helpers/esm/createClass"]},10:function(e,t){e.exports=__mipComponentsWebpackHelpers__["core-js/modules/_to-length"]},11:function(e,t){e.exports=__mipComponentsWebpackHelpers__["core-js/modules/_fails"]},13:function(e,t){e.exports=__mipComponentsWebpackHelpers__["core-js/modules/_to-integer"]},14:function(e,t){e.exports=__mipComponentsWebpackHelpers__["core-js/modules/_export"]},15:function(e,t){e.exports=__mipComponentsWebpackHelpers__["core-js/modules/_redefine"]},17:function(e,t){e.exports=__mipComponentsWebpackHelpers__["core-js/modules/_hide"]},19:function(e,t,n){"use strict";var r=n(21),o=RegExp.prototype.exec,i=String.prototype.replace,c=o,s=function(){var e=/a/,t=/b*/g;return o.call(e,"a"),o.call(t,"a"),0!==e.lastIndex||0!==t.lastIndex}(),u=void 0!==/()??/.exec("")[1];(s||u)&&(c=function(e){var t,n,c,a,l=this;return u&&(n=new RegExp("^"+l.source+"$(?!\\s)",r.call(l))),s&&(t=l.lastIndex),c=o.call(l,e),s&&c&&(l.lastIndex=l.global?c.index+c[0].length:t),u&&c&&c.length>1&&i.call(c[0],n,function(){for(a=1;a<arguments.length-2;a++)void 0===arguments[a]&&(c[a]=void 0)}),c}),e.exports=c},2:function(e,t){e.exports=__mipComponentsWebpackHelpers__["core-js/modules/_wks"]},20:function(e,t){e.exports=__mipComponentsWebpackHelpers__["core-js/modules/_is-object"]},21:function(e,t,n){"use strict";var r=n(3);e.exports=function(){var e=r(this),t="";return e.global&&(t+="g"),e.ignoreCase&&(t+="i"),e.multiline&&(t+="m"),e.unicode&&(t+="u"),e.sticky&&(t+="y"),t}},210:function(e,t,n){"use strict";n.r(t),n.d(t,"default",function(){return y});n(49),n(66),n(53);var r=n(0),o=n.n(r),i=n(1),c=n.n(i),s=n(6),u=n.n(s),a=n(4),l=n.n(a),p=n(5),f=n.n(p),d=MIP,v=d.fn,h=d.Gesture,g=d.util,m=g.jsonParse,_=(0,g.log)("mip-stats-cnzz"),x="data-stats-cnzz-flag",b="data-stats-cnzz-obj",y=function(e){function t(){return o()(this,t),u()(this,l()(t).apply(this,arguments))}return f()(t,e),c()(t,[{key:"build",value:function(){var e=this.element,t=e.getAttribute("token"),n=e.getAttribute("setconfig"),r=e.getAttribute("nodes"),o=11;if(r){var i=r.split(",");o=i[Math.round(Math.random()*(i.length-1))],isNaN(+o)&&(o=11)}if(t){window._czc=window._czc||[],_czc.push(["_setAccount",t]);var c=document.createElement("script"),s="//s".concat(o,".cnzz.com/z_stat.php?id=").concat(t,"&web_id=").concat(t);n&&_czc.push(k(decodeURIComponent(n))),c.src=s,e.appendChild(c),function(){var e=Date.now(),t=setInterval(function(){!function(e){for(var t=0;t<e.length;t++){var n=e[t],r=n.getAttribute(b),o=n.hasAttribute(x);if(r&&!o){try{r=m(decodeURIComponent(r))}catch(e){_.warn(n,"事件追踪 ".concat(b," 数据不是合法的 JSON"));continue}var i=r.type;if(r.data){var c=k(r.data);if(!("click"!==i&&"mouseup"!==i&&"load"!==i||n.classList.contains("mip-stats-eventload"))){if(n.classList.add("mip-stats-eventload"),"load"===i)_czc.push(c);else if("click"===i&&n.hasAttribute("on")&&n.getAttribute("on").match("tap:")&&v.hasTouch()){var s=new h(n);s.on("tap",C)}else n.addEventListener(i,C,!1);n.setAttribute(x,"1")}}}}}(document.querySelectorAll("*[".concat(b,"]"))),Date.now()-e>=8e3&&clearInterval(t)},100)}()}else _.warn(e,"请配置统计所需 token")}}]),t}(MIP.CustomElement);function C(){var e=this.getAttribute(b);if(e)try{var t=m(decodeURIComponent(e));if(!t.data)return;var n=k(t.data);_czc.push(n)}catch(e){return _.warn(this,"事件追踪 ".concat(b," 数据不是合法的 JSON"))}}function k(e){var t=e,n=[];if(e){"string"==typeof e&&(t=e.replace(/['"[\]\s]+/g,"").split(","));for(var r=0;r<t.length;r++){var o=t[r].replace(/(^\s*)|(\s*$)/g,"").replace(/'/g,"");"false"!==o&&"true"!==o||(o=Boolean(o)),n.push(o)}return n}}},25:function(e,t,n){"use strict";n(36);var r=n(15),o=n(17),i=n(11),c=n(7),s=n(2),u=n(19),a=s("species"),l=!i(function(){var e=/./;return e.exec=function(){var e=[];return e.groups={a:"7"},e},"7"!=="".replace(e,"$<a>")}),p=function(){var e=/(?:)/,t=e.exec;e.exec=function(){return t.apply(this,arguments)};var n="ab".split(e);return 2===n.length&&"a"===n[0]&&"b"===n[1]}();e.exports=function(e,t,n){var f=s(e),d=!i(function(){var t={};return t[f]=function(){return 7},7!=""[e](t)}),v=d?!i(function(){var t=!1,n=/a/;return n.exec=function(){return t=!0,null},"split"===e&&(n.constructor={},n.constructor[a]=function(){return n}),n[f](""),!t}):void 0;if(!d||!v||"replace"===e&&!l||"split"===e&&!p){var h=/./[f],g=n(c,f,""[e],function(e,t,n,r,o){return t.exec===u?d&&!o?{done:!0,value:h.call(t,n,r)}:{done:!0,value:e.call(n,t,r)}:{done:!1}}),m=g[0],_=g[1];r(String.prototype,e,m),o(RegExp.prototype,f,2==t?function(e,t){return _.call(e,this,t)}:function(e){return _.call(e,this)})}}},26:function(e,t,n){"use strict";var r=n(35),o=RegExp.prototype.exec;e.exports=function(e,t){var n=e.exec;if("function"==typeof n){var i=n.call(e,t);if("object"!=typeof i)throw new TypeError("RegExp exec method returned something other than an Object or null");return i}if("RegExp"!==r(e))throw new TypeError("RegExp#exec called on incompatible receiver");return o.call(e,t)}},27:function(e,t,n){"use strict";var r=n(34)(!0);e.exports=function(e,t,n){return t+(n?r(e,t).length:1)}},29:function(e,t){e.exports=__mipComponentsWebpackHelpers__["core-js/modules/_to-object"]},3:function(e,t){e.exports=__mipComponentsWebpackHelpers__["core-js/modules/_an-object"]},34:function(e,t,n){var r=n(13),o=n(7);e.exports=function(e){return function(t,n){var i,c,s=String(o(t)),u=r(n),a=s.length;return u<0||u>=a?e?"":void 0:(i=s.charCodeAt(u))<55296||i>56319||u+1===a||(c=s.charCodeAt(u+1))<56320||c>57343?e?s.charAt(u):i:e?s.slice(u,u+2):c-56320+(i-55296<<10)+65536}}},35:function(e,t,n){var r=n(9),o=n(2)("toStringTag"),i="Arguments"==r(function(){return arguments}());e.exports=function(e){var t,n,c;return void 0===e?"Undefined":null===e?"Null":"string"==typeof(n=function(e,t){try{return e[t]}catch(e){}}(t=Object(e),o))?n:i?r(t):"Object"==(c=r(t))&&"function"==typeof t.callee?"Arguments":c}},36:function(e,t,n){"use strict";var r=n(19);n(14)({target:"RegExp",proto:!0,forced:r!==/./.exec},{exec:r})},4:function(e,t){e.exports=__mipComponentsWebpackHelpers__["@babel/runtime/helpers/esm/getPrototypeOf"]},42:function(e,t,n){var r=n(20),o=n(9),i=n(2)("match");e.exports=function(e){var t;return r(e)&&(void 0!==(t=e[i])?!!t:"RegExp"==o(e))}},49:function(e,t,n){"use strict";var r=n(3),o=n(29),i=n(10),c=n(13),s=n(27),u=n(26),a=Math.max,l=Math.min,p=Math.floor,f=/\$([$&`']|\d\d?|<[^>]*>)/g,d=/\$([$&`']|\d\d?)/g,v=function(e){return void 0===e?e:String(e)};n(25)("replace",2,function(e,t,n,h){return[function(r,o){var i=e(this),c=void 0==r?void 0:r[t];return void 0!==c?c.call(r,i,o):n.call(String(i),r,o)},function(e,t){var o=h(n,e,this,t);if(o.done)return o.value;var p=r(e),f=String(this),d="function"==typeof t;d||(t=String(t));var m=p.global;if(m){var _=p.unicode;p.lastIndex=0}for(var x=[];;){var b=u(p,f);if(null===b)break;if(x.push(b),!m)break;""===String(b[0])&&(p.lastIndex=s(f,i(p.lastIndex),_))}for(var y="",C=0,k=0;k<x.length;k++){b=x[k];for(var j=String(b[0]),w=a(l(c(b.index),f.length),0),S=[],I=1;I<b.length;I++)S.push(v(b[I]));var z=b.groups;if(d){var A=[j].concat(S,w,f);void 0!==z&&A.push(z);var E=String(t.apply(void 0,A))}else E=g(j,f,w,S,z,t);w>=C&&(y+=f.slice(C,w)+E,C=w+j.length)}return y+f.slice(C)}];function g(e,t,r,i,c,s){var u=r+e.length,a=i.length,l=d;return void 0!==c&&(c=o(c),l=f),n.call(s,l,function(n,o){var s;switch(o.charAt(0)){case"$":return"$";case"&":return e;case"`":return t.slice(0,r);case"'":return t.slice(u);case"<":s=c[o.slice(1,-1)];break;default:var l=+o;if(0===l)return n;if(l>a){var f=p(l/10);return 0===f?n:f<=a?void 0===i[f-1]?o.charAt(1):i[f-1]+o.charAt(1):n}s=i[l-1]}return void 0===s?"":s})}})},5:function(e,t){e.exports=__mipComponentsWebpackHelpers__["@babel/runtime/helpers/esm/inherits"]},53:function(e,t,n){"use strict";var r=n(42),o=n(3),i=n(61),c=n(27),s=n(10),u=n(26),a=n(19),l=n(11),p=Math.min,f=[].push,d=!l(function(){RegExp(4294967295,"y")});n(25)("split",2,function(e,t,n,l){var v;return v="c"=="abbc".split(/(b)*/)[1]||4!="test".split(/(?:)/,-1).length||2!="ab".split(/(?:ab)*/).length||4!=".".split(/(.?)(.?)/).length||".".split(/()()/).length>1||"".split(/.?/).length?function(e,t){var o=String(this);if(void 0===e&&0===t)return[];if(!r(e))return n.call(o,e,t);for(var i,c,s,u=[],l=(e.ignoreCase?"i":"")+(e.multiline?"m":"")+(e.unicode?"u":"")+(e.sticky?"y":""),p=0,d=void 0===t?4294967295:t>>>0,v=new RegExp(e.source,l+"g");(i=a.call(v,o))&&!((c=v.lastIndex)>p&&(u.push(o.slice(p,i.index)),i.length>1&&i.index<o.length&&f.apply(u,i.slice(1)),s=i[0].length,p=c,u.length>=d));)v.lastIndex===i.index&&v.lastIndex++;return p===o.length?!s&&v.test("")||u.push(""):u.push(o.slice(p)),u.length>d?u.slice(0,d):u}:"0".split(void 0,0).length?function(e,t){return void 0===e&&0===t?[]:n.call(this,e,t)}:n,[function(n,r){var o=e(this),i=void 0==n?void 0:n[t];return void 0!==i?i.call(n,o,r):v.call(String(o),n,r)},function(e,t){var r=l(v,e,this,t,v!==n);if(r.done)return r.value;var a=o(e),f=String(this),h=i(a,RegExp),g=a.unicode,m=(a.ignoreCase?"i":"")+(a.multiline?"m":"")+(a.unicode?"u":"")+(d?"y":"g"),_=new h(d?a:"^(?:"+a.source+")",m),x=void 0===t?4294967295:t>>>0;if(0===x)return[];if(0===f.length)return null===u(_,f)?[f]:[];for(var b=0,y=0,C=[];y<f.length;){_.lastIndex=d?y:0;var k,j=u(_,d?f:f.slice(y));if(null===j||(k=p(s(_.lastIndex+(d?0:y)),f.length))===b)y=c(f,y,g);else{if(C.push(f.slice(b,y)),C.length===x)return C;for(var w=1;w<=j.length-1;w++)if(C.push(j[w]),C.length===x)return C;y=b=k}}return C.push(f.slice(b)),C}]})},57:function(e,t){e.exports=__mipComponentsWebpackHelpers__["core-js/modules/_a-function"]},6:function(e,t){e.exports=__mipComponentsWebpackHelpers__["@babel/runtime/helpers/esm/possibleConstructorReturn"]},61:function(e,t,n){var r=n(3),o=n(57),i=n(2)("species");e.exports=function(e,t){var n,c=r(e).constructor;return void 0===c||void 0==(n=r(c)[i])?t:o(n)}},66:function(e,t,n){"use strict";var r=n(3),o=n(10),i=n(27),c=n(26);n(25)("match",1,function(e,t,n,s){return[function(n){var r=e(this),o=void 0==n?void 0:n[t];return void 0!==o?o.call(n,r):new RegExp(n)[t](String(r))},function(e){var t=s(n,e,this);if(t.done)return t.value;var u=r(e),a=String(this);if(!u.global)return c(u,a);var l=u.unicode;u.lastIndex=0;for(var p,f=[],d=0;null!==(p=c(u,a));){var v=String(p[0]);f[d]=v,""===v&&(u.lastIndex=i(a,o(u.lastIndex),l)),d++}return 0===d?null:f}]})},7:function(e,t){e.exports=__mipComponentsWebpackHelpers__["core-js/modules/_defined"]},9:function(e,t){var n={}.toString;e.exports=function(e){return n.call(e).slice(8,-1)}}});e.__esModule&&(e=e.default),e&&MIP.registerElement("mip-stats-cnzz",e)}});