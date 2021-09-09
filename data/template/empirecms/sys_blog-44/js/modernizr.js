/* Modernizr 2.6.2 (Custom Build) | MIT & BSD
 * Build: http://modernizr.com/download/#-fontface-backgroundsize-borderimage-borderradius-boxshadow-flexbox-hsla-multiplebgs-opacity-rgba-textshadow-cssanimations-csscolumns-generatedcontent-cssgradients-cssreflections-csstransforms-csstransforms3d-csstransitions-applicationcache-canvas-canvastext-draganddrop-hashchange-history-audio-video-indexeddb-input-inputtypes-localstorage-postmessage-sessionstorage-websockets-websqldatabase-webworkers-geolocation-inlinesvg-smil-svg-svgclippaths-touch-webgl-shiv-mq-cssclasses-addtest-prefixed-teststyles-testprop-testallprops-hasevent-prefixes-domprefixes-load
 */
window.Modernizr = function(e, t, n) {
        function r(e) {
            m.cssText = e
        }

        function o(e, t) {
            return typeof e === t
        }

        function i(e, t) {
            return !!~("" + e).indexOf(t)
        }

        function a(e, t) {
            for (var r in e) {
                var o = e[r];
                if (!i(o, "-") && m[o] !== n) return "pfx" != t || o
            }
            return !1
        }

        function c(e, t, r) {
            var i = e.charAt(0).toUpperCase() + e.slice(1),
                c = (e + " " + E.join(i + " ") + i).split(" ");
            return o(t, "string") || o(t, "undefined") ? a(c, t) : function(e, t, r) {
                for (var i in e) {
                    var a = t[e[i]];
                    if (a !== n) return !1 === r ? e[i] : o(a, "function") ? a.bind(r || t) : a
                }
                return !1
            }(c = (e + " " + w.join(i + " ") + i).split(" "), t, r)
        }
        var s, l, u = {},
            f = t.documentElement,
            d = "modernizr",
            p = t.createElement(d),
            m = p.style,
            h = t.createElement("input"),
            g = ":)",
            v = {}.toString,
            y = " -webkit- -moz- -o- -ms- ".split(" "),
            b = "Webkit Moz O ms",
            E = b.split(" "),
            w = b.toLowerCase().split(" "),
            x = "http://www.w3.org/2000/svg",
            S = {},
            C = {},
            k = {},
            T = [],
            j = T.slice,
            N = function(e, n, r, o) {
                var i, a, c, s, l = t.createElement("div"),
                    u = t.body,
                    p = u || t.createElement("body");
                if (parseInt(r, 10))
                    for (; r--;) c = t.createElement("div"), c.id = o ? o[r] : d + (r + 1), l.appendChild(c);
                return i = ["&#173;", '<style id="s', d, '">', e, "</style>"].join(""), l.id = d, (u ? l : p).innerHTML += i, p.appendChild(l), u || (p.style.background = "", p.style.overflow = "hidden", s = f.style.overflow, f.style.overflow = "hidden", f.appendChild(p)), a = n(l, e), u ? l.parentNode.removeChild(l) : (p.parentNode.removeChild(p), f.style.overflow = s), !!a
            },
            M = function() {
                var e = {
                    select: "input",
                    change: "input",
                    submit: "form",
                    reset: "form",
                    error: "img",
                    load: "img",
                    abort: "img"
                };
                return function(r, i) {
                    i = i || t.createElement(e[r] || "div");
                    var a = (r = "on" + r) in i;
                    return a || (i.setAttribute || (i = t.createElement("div")), i.setAttribute && i.removeAttribute && (i.setAttribute(r, ""), a = o(i[r], "function"), o(i[r], "undefined") || (i[r] = n), i.removeAttribute(r))), i = null, a
                }
            }(),
            P = {}.hasOwnProperty;
        l = o(P, "undefined") || o(P.call, "undefined") ? function(e, t) {
            return t in e && o(e.constructor.prototype[t], "undefined")
        } : function(e, t) {
            return P.call(e, t)
        }, Function.prototype.bind || (Function.prototype.bind = function(e) {
            var t = this;
            if ("function" != typeof t) throw new TypeError;
            var n = j.call(arguments, 1),
                r = function() {
                    if (this instanceof r) {
                        var o = function() {};
                        o.prototype = t.prototype;
                        var i = new o,
                            a = t.apply(i, n.concat(j.call(arguments)));
                        return Object(a) === a ? a : i
                    }
                    return t.apply(e, n.concat(j.call(arguments)))
                };
            return r
        }), S.flexbox = function() {
            return c("flexWrap")
        }, S.canvas = function() {
            var e = t.createElement("canvas");
            return !!e.getContext && !!e.getContext("2d")
        }, S.canvastext = function() {
            return !!u.canvas && !!o(t.createElement("canvas").getContext("2d").fillText, "function")
        }, S.webgl = function() {
            return !!e.WebGLRenderingContext
        }, S.touch = function() {
            var n;
            return "ontouchstart" in e || e.DocumentTouch && t instanceof DocumentTouch ? n = !0 : N(["@media (", y.join("touch-enabled),("), d, ")", "{#modernizr{top:9px;position:absolute}}"].join(""), function(e) {
                n = 9 === e.offsetTop
            }), n
        }, S.geolocation = function() {
            return "geolocation" in navigator
        }, S.postmessage = function() {
            return !!e.postMessage
        }, S.websqldatabase = function() {
            return !!e.openDatabase
        }, S.indexedDB = function() {
            return !!c("indexedDB", e)
        }, S.hashchange = function() {
            return M("hashchange", e) && (t.documentMode === n || t.documentMode > 7)
        }, S.history = function() {
            return !!e.history && !!history.pushState
        }, S.draganddrop = function() {
            var e = t.createElement("div");
            return "draggable" in e || "ondragstart" in e && "ondrop" in e
        }, S.websockets = function() {
            return "WebSocket" in e || "MozWebSocket" in e
        }, S.rgba = function() {
            return r("background-color:rgba(150,255,150,.5)"), i(m.backgroundColor, "rgba")
        }, S.hsla = function() {
            return r("background-color:hsla(120,40%,100%,.5)"), i(m.backgroundColor, "rgba") || i(m.backgroundColor, "hsla")
        }, S.multiplebgs = function() {
            return r("background:url(https://),url(https://),red url(https://)"), /(url\s*\(.*?){3}/.test(m.background)
        }, S.backgroundsize = function() {
            return c("backgroundSize")
        }, S.borderimage = function() {
            return c("borderImage")
        }, S.borderradius = function() {
            return c("borderRadius")
        }, S.boxshadow = function() {
            return c("boxShadow")
        }, S.textshadow = function() {
            return "" === t.createElement("div").style.textShadow
        }, S.opacity = function() {
            return e = "opacity:.55", r(y.join(e + ";") + (t || "")), /^0.55$/.test(m.opacity);
            var e, t
        }, S.cssanimations = function() {
            return c("animationName")
        }, S.csscolumns = function() {
            return c("columnCount")
        }, S.cssgradients = function() {
            var e = "background-image:";
            return r((e + "-webkit- ".split(" ").join("gradient(linear,left top,right bottom,from(#9f9),to(white));" + e) + y.join("linear-gradient(left top,#9f9, white);" + e)).slice(0, -e.length)), i(m.backgroundImage, "gradient")
        }, S.cssreflections = function() {
            return c("boxReflect")
        }, S.csstransforms = function() {
            return !!c("transform")
        }, S.csstransforms3d = function() {
            var e = !!c("perspective");
            return e && "webkitPerspective" in f.style && N("@media (transform-3d),(-webkit-transform-3d){#modernizr{left:9px;position:absolute;height:3px;}}", function(t, n) {
                e = 9 === t.offsetLeft && 3 === t.offsetHeight
            }), e
        }, S.csstransitions = function() {
            return c("transition")
        }, S.fontface = function() {
            var e;
            return N('@font-face {font-family:"font";src:url("https://")}', function(n, r) {
                var o = t.getElementById("smodernizr"),
                    i = o.sheet || o.styleSheet,
                    a = i ? i.cssRules && i.cssRules[0] ? i.cssRules[0].cssText : i.cssText || "" : "";
                e = /src/i.test(a) && 0 === a.indexOf(r.split(" ")[0])
            }), e
        }, S.generatedcontent = function() {
            var e;
            return N(["#", d, "{font:0/0 a}#", d, ':after{content:"', g, '";visibility:hidden;font:3px/1 a}'].join(""), function(t) {
                e = t.offsetHeight >= 3
            }), e
        }, S.video = function() {
            var e = t.createElement("video"),
                n = !1;
            try {
                (n = !!e.canPlayType) && ((n = new Boolean(n)).ogg = e.canPlayType('video/ogg; codecs="theora"').replace(/^no$/, ""), n.h264 = e.canPlayType('video/mp4; codecs="avc1.42E01E"').replace(/^no$/, ""), n.webm = e.canPlayType('video/webm; codecs="vp8, vorbis"').replace(/^no$/, ""))
            } catch (e) {}
            return n
        }, S.audio = function() {
            var e = t.createElement("audio"),
                n = !1;
            try {
                (n = !!e.canPlayType) && ((n = new Boolean(n)).ogg = e.canPlayType('audio/ogg; codecs="vorbis"').replace(/^no$/, ""), n.mp3 = e.canPlayType("audio/mpeg;").replace(/^no$/, ""), n.wav = e.canPlayType('audio/wav; codecs="1"').replace(/^no$/, ""), n.m4a = (e.canPlayType("audio/x-m4a;") || e.canPlayType("audio/aac;")).replace(/^no$/, ""))
            } catch (e) {}
            return n
        }, S.localstorage = function() {
            try {
                return localStorage.setItem(d, d), localStorage.removeItem(d), !0
            } catch (e) {
                return !1
            }
        }, S.sessionstorage = function() {
            try {
                return sessionStorage.setItem(d, d), sessionStorage.removeItem(d), !0
            } catch (e) {
                return !1
            }
        }, S.webworkers = function() {
            return !!e.Worker
        }, S.applicationcache = function() {
            return !!e.applicationCache
        }, S.svg = function() {
            return !!t.createElementNS && !!t.createElementNS(x, "svg").createSVGRect
        }, S.inlinesvg = function() {
            var e = t.createElement("div");
            return e.innerHTML = "<svg/>", (e.firstChild && e.firstChild.namespaceURI) == x
        }, S.smil = function() {
            return !!t.createElementNS && /SVGAnimate/.test(v.call(t.createElementNS(x, "animate")))
        }, S.svgclippaths = function() {
            return !!t.createElementNS && /SVGClipPath/.test(v.call(t.createElementNS(x, "clipPath")))
        };
        for (var A in S) l(S, A) && (s = A.toLowerCase(), u[s] = S[A](), T.push((u[s] ? "" : "no-") + s));
        return u.input || (u.input = function(n) {
                for (var r = 0, o = n.length; r < o; r++) k[n[r]] = n[r] in h;
                return k.list && (k.list = !!t.createElement("datalist") && !!e.HTMLDataListElement), k
            }("autocomplete autofocus list placeholder max min multiple pattern required step".split(" ")), u.inputtypes = function(e) {
                for (var r, o, i, a = 0, c = e.length; a < c; a++) h.setAttribute("type", o = e[a]), r = "text" !== h.type, r && (h.value = g, h.style.cssText = "position:absolute;visibility:hidden;", /^range$/.test(o) && h.style.WebkitAppearance !== n ? (f.appendChild(h), i = t.defaultView, r = i.getComputedStyle && "textfield" !== i.getComputedStyle(h, null).WebkitAppearance && 0 !== h.offsetHeight, f.removeChild(h)) : /^(search|tel)$/.test(o) || (r = /^(url|email)$/.test(o) ? h.checkValidity && !1 === h.checkValidity() : h.value != g)), C[e[a]] = !!r;
                return C
            }("search tel url email datetime date month week time datetime-local number range color".split(" "))), u.addTest = function(e, t) {
                if ("object" == typeof e)
                    for (var r in e) l(e, r) && u.addTest(r, e[r]);
                else {
                    if (e = e.toLowerCase(), u[e] !== n) return u;
                    t = "function" == typeof t ? t() : t, f.className += " " + (t ? "" : "no-") + e, u[e] = t
                }
                return u
            }, r(""), p = h = null,
            function(e, t) {
                function n() {
                    var e = m.elements;
                    return "string" == typeof e ? e.split(" ") : e
                }

                function r(e) {
                    var t = p[e[f]];
                    return t || (t = {}, d++, e[f] = d, p[d] = t), t
                }

                function o(e, n, o) {
                    return n || (n = t), c ? n.createElement(e) : (o || (o = r(n)), (i = o.cache[e] ? o.cache[e].cloneNode() : u.test(e) ? (o.cache[e] = o.createElem(e)).cloneNode() : o.createElem(e)).canHaveChildren && !l.test(e) ? o.frag.appendChild(i) : i);
                    var i
                }

                function i(e) {
                    e || (e = t);
                    var i, s, l, u, f, d, p = r(e);
                    return m.shivCSS && !a && !p.hasCSS && (p.hasCSS = (u = "article,aside,figcaption,figure,footer,header,hgroup,nav,section{display:block}mark{background:#FF0;color:#000}", f = (l = e).createElement("p"), d = l.getElementsByTagName("head")[0] || l.documentElement, f.innerHTML = "x<style>" + u + "</style>", !!d.insertBefore(f.lastChild, d.firstChild))), c || (i = e, (s = p).cache || (s.cache = {}, s.createElem = i.createElement, s.createFrag = i.createDocumentFragment, s.frag = s.createFrag()), i.createElement = function(e) {
                        return m.shivMethods ? o(e, i, s) : s.createElem(e)
                    }, i.createDocumentFragment = Function("h,f", "return function(){var n=f.cloneNode(),c=n.createElement;h.shivMethods&&(" + n().join().replace(/\w+/g, function(e) {
                        return s.createElem(e), s.frag.createElement(e), 'c("' + e + '")'
                    }) + ");return n}")(m, s.frag)), e
                }
                var a, c, s = e.html5 || {},
                    l = /^<|^(?:button|map|select|textarea|object|iframe|option|optgroup)$/i,
                    u = /^(?:a|b|code|div|fieldset|h1|h2|h3|h4|h5|h6|i|label|li|ol|p|q|span|strong|style|table|tbody|td|th|tr|ul)$/i,
                    f = "_html5shiv",
                    d = 0,
                    p = {};
                ! function() {
                    try {
                        var e = t.createElement("a");
                        e.innerHTML = "<xyz></xyz>", a = "hidden" in e, c = 1 == e.childNodes.length || function() {
                            t.createElement("a");
                            var e = t.createDocumentFragment();
                            return void 0 === e.cloneNode || void 0 === e.createDocumentFragment || void 0 === e.createElement
                        }()
                    } catch (e) {
                        a = !0, c = !0
                    }
                }();
                var m = {
                    elements: s.elements || "abbr article aside audio bdi canvas data datalist details figcaption figure footer header hgroup mark meter nav output progress section summary time video",
                    shivCSS: !1 !== s.shivCSS,
                    supportsUnknownElements: c,
                    shivMethods: !1 !== s.shivMethods,
                    type: "default",
                    shivDocument: i,
                    createElement: o,
                    createDocumentFragment: function(e, o) {
                        if (e || (e = t), c) return e.createDocumentFragment();
                        for (var i = (o = o || r(e)).frag.cloneNode(), a = 0, s = n(), l = s.length; a < l; a++) i.createElement(s[a]);
                        return i
                    }
                };
                e.html5 = m, i(t)
            }(this, t), u._version = "2.6.2", u._prefixes = y, u._domPrefixes = w, u._cssomPrefixes = E, u.mq = function(t) {
                var n, r = e.matchMedia || e.msMatchMedia;
                return r ? r(t).matches : (N("@media " + t + " { #" + d + " { position: absolute; } }", function(t) {
                    n = "absolute" == (e.getComputedStyle ? getComputedStyle(t, null) : t.currentStyle).position
                }), n)
            }, u.hasEvent = M, u.testProp = function(e) {
                return a([e])
            }, u.testAllProps = c, u.testStyles = N, u.prefixed = function(e, t, n) {
                return t ? c(e, t, n) : c(e, "pfx")
            }, f.className = f.className.replace(/(^|\s)no-js(\s|$)/, "$1$2") + " js " + T.join(" "), u
    }(this, this.document),
    function(e, t, n) {
        function r(e) {
            return "[object Function]" == h.call(e)
        }

        function o(e) {
            return "string" == typeof e
        }

        function i() {}

        function a(e) {
            return !e || "loaded" == e || "complete" == e || "uninitialized" == e
        }

        function c() {
            var e = g.shift();
            v = 1, e ? e.t ? p(function() {
                ("c" == e.t ? f.injectCss : f.injectJs)(e.s, 0, e.a, e.x, e.e, 1)
            }, 0) : (e(), c()) : v = 0
        }

        function s(e, n, r, i, s) {
            return v = 0, n = n || "j", o(e) ? function(e, n, r, o, i, s, l) {
                function u(t) {
                    if (!h && a(d.readyState) && (w.r = h = 1, !v && c(), d.onload = d.onreadystatechange = null, t)) {
                        "img" != e && p(function() {
                            E.removeChild(d)
                        }, 50);
                        for (var r in k[n]) k[n].hasOwnProperty(r) && k[n][r].onload()
                    }
                }
                l = l || f.errorTimeout;
                var d = t.createElement(e),
                    h = 0,
                    y = 0,
                    w = {
                        t: r,
                        s: n,
                        e: i,
                        a: s,
                        x: l
                    };
                1 === k[n] && (y = 1, k[n] = []), "object" == e ? d.data = n : (d.src = n, d.type = e), d.width = d.height = "0", d.onerror = d.onload = d.onreadystatechange = function() {
                    u.call(this, y)
                }, g.splice(o, 0, w), "img" != e && (y || 2 === k[n] ? (E.insertBefore(d, b ? null : m), p(u, l)) : k[n].push(d))
            }("c" == n ? x : w, e, n, this.i++, r, i, s) : (g.splice(this.i++, 0, e), 1 == g.length && c()), this
        }

        function l() {
            var e = f;
            return e.loader = {
                load: s,
                i: 0
            }, e
        }
        var u, f, d = t.documentElement,
            p = e.setTimeout,
            m = t.getElementsByTagName("script")[0],
            h = {}.toString,
            g = [],
            v = 0,
            y = "MozAppearance" in d.style,
            b = y && !!t.createRange().compareNode,
            E = b ? d : m.parentNode,
            w = (d = e.opera && "[object Opera]" == h.call(e.opera), d = !!t.attachEvent && !d, y ? "object" : d ? "script" : "img"),
            x = d ? "script" : w,
            S = Array.isArray || function(e) {
                return "[object Array]" == h.call(e)
            },
            C = [],
            k = {},
            T = {
                timeout: function(e, t) {
                    return t.length && (e.timeout = t[0]), e
                }
            };
        (f = function(e) {
            function t(e, t, o, i, a) {
                var c = function(e) {
                        e = e.split("!");
                        var t, n, r, o = C.length,
                            i = e.pop(),
                            a = e.length;
                        for (i = {
                                url: i,
                                origUrl: i,
                                prefixes: e
                            }, n = 0; n < a; n++) r = e[n].split("="), (t = T[r.shift()]) && (i = t(i, r));
                        for (n = 0; n < o; n++) i = C[n](i);
                        return i
                    }(e),
                    s = c.autoCallback;
                c.url.split(".").pop().split("?").shift(), c.bypass || (t && (t = r(t) ? t : t[e] || t[i] || t[e.split("/").pop().split("?")[0]]), c.instead ? c.instead(e, t, o, i, a) : (k[c.url] ? c.noexec = !0 : k[c.url] = 1, o.load(c.url, c.forceCSS || !c.forceJS && "css" == c.url.split(".").pop().split("?").shift() ? "c" : n, c.noexec, c.attrs, c.timeout), (r(t) || r(s)) && o.load(function() {
                    l(), t && t(c.origUrl, a, i), s && s(c.origUrl, a, i), k[c.url] = 2
                })))
            }

            function a(e, n) {
                function a(e, i) {
                    if (e) {
                        if (o(e)) i || (f = function() {
                            var e = [].slice.call(arguments);
                            d.apply(this, e), p()
                        }), t(e, f, n, 0, l);
                        else if (Object(e) === e)
                            for (s in c = function() {
                                    var t, n = 0;
                                    for (t in e) e.hasOwnProperty(t) && n++;
                                    return n
                                }(), e) e.hasOwnProperty(s) && (!i && !--c && (r(f) ? f = function() {
                                var e = [].slice.call(arguments);
                                d.apply(this, e), p()
                            } : f[s] = function(e) {
                                return function() {
                                    var t = [].slice.call(arguments);
                                    e && e.apply(this, t), p()
                                }
                            }(d[s])), t(e[s], f, n, s, l))
                    } else !i && p()
                }
                var c, s, l = !!e.test,
                    u = e.load || e.both,
                    f = e.callback || i,
                    d = f,
                    p = e.complete || i;
                a(l ? e.yep : e.nope, !!u), u && a(u)
            }
            var c, s, u = this.yepnope.loader;
            if (o(e)) t(e, 0, u, 0);
            else if (S(e))
                for (c = 0; c < e.length; c++) s = e[c], o(s) ? t(s, 0, u, 0) : S(s) ? f(s) : Object(s) === s && a(s, u);
            else Object(e) === e && a(e, u)
        }).addPrefix = function(e, t) {
            T[e] = t
        }, f.addFilter = function(e) {
            C.push(e)
        }, f.errorTimeout = 1e4, null == t.readyState && t.addEventListener && (t.readyState = "loading", t.addEventListener("DOMContentLoaded", u = function() {
            t.removeEventListener("DOMContentLoaded", u, 0), t.readyState = "complete"
        }, 0)), e.yepnope = l(), e.yepnope.executeStack = c, e.yepnope.injectJs = function(e, n, r, o, s, l) {
            var u, d, h = t.createElement("script");
            o = o || f.errorTimeout;
            h.src = e;
            for (d in r) h.setAttribute(d, r[d]);
            n = l ? c : n || i, h.onreadystatechange = h.onload = function() {
                !u && a(h.readyState) && (u = 1, n(), h.onload = h.onreadystatechange = null)
            }, p(function() {
                u || (u = 1, n(1))
            }, o), s ? h.onload() : m.parentNode.insertBefore(h, m)
        }, e.yepnope.injectCss = function(e, n, r, o, a, s) {
            var l;
            o = t.createElement("link"), n = s ? c : n || i;
            o.href = e, o.rel = "stylesheet", o.type = "text/css";
            for (l in r) o.setAttribute(l, r[l]);
            a || (m.parentNode.insertBefore(o, m), p(n, 0))
        }
    }(this, document), Modernizr.load = function() {
        yepnope.apply(window, [].slice.call(arguments, 0))
    };