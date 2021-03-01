package requests

import (
	"bytes"
	"crypto/tls"
	"errors"
	"io/ioutil"
	"net/http"
	"net/http/cookiejar"
	"net/url"
	"strings"
	"sync"
	"time"
)

const (
	UTF8 = "utf-8"
	GBK  = "gbk"
)

var (
	AllowedErr = errors.New("domain name not allowed visit")
)

type (
	// 身份验证
	Auth struct {
		Username, Password string
	}
	//请求结构体
	Request struct {
		Req     *http.Request  //请求数据
		Resp    *http.Response //返回数据
		Client  *http.Client
		BaseURL *url.URL
		cookies []*http.Cookie
		allowed map[string]bool //允许的域名才可以访问
		limited bool            //启用过滤域名
		sync.Mutex
	}
	//请求接口
	Requester interface {
		// 设置userAgent
		SetUserAgent(text string)
		//设置允许的域名
		/*允许的格式 map[string]bool、string、[]string*/
		AllowDomains(domains ...string)
		//添加cookie
		AddCookie(cookies ...interface{})
		//设置cookies
		SetCookies(cookies interface{})
		//清除设置的cookies
		ClearCookies()
		//设置请求超时时间
		Timeout(n time.Duration)
		//设置代理
		Proxy(proxyurl string) error
		//设置URL
		URL(o interface{})
		//获取绝对URL
		AbsURL(u string) string
		//GET请求
		// 如果设置头部信息 就用 Header 类型
		// 如果设置URL的参数 就用 Param 类型
		// 如果设置POST的data 就用 Data 类型
		//File 上传文件
		//Auth 验证
		//也可以直接字符串 name=username&age=39
		Get(originUrl string, args ...interface{}) (Responder, error)
		Post(originUrl string, args ...interface{}) (Responder, error)
		Multipart(originUrl string, args ...interface{}) (Responder, error)
	}
)

//新建一个请求
func New() Requester {
	return new(Request).Init()
}

//初始化
func (r *Request) Init() *Request {
	r.Req = &http.Request{
		Method:     "GET",
		Header:     make(http.Header),
		Proto:      "HTTP/1.1",
		ProtoMajor: 1,
		ProtoMinor: 1,
	}
	r.Req.Header.Set("User-Agent", UserAgentChromeMac)
	r.Req.Header.Set("Assign", "*/*")
	r.Client = &http.Client{
		Transport: &http.Transport{TLSClientConfig: &tls.Config{InsecureSkipVerify: true}},
	}
	r.Client.Jar, _ = cookiejar.New(nil)
	r.Client.Timeout = 60 * time.Second
	r.allowed = make(map[string]bool)
	return r
}

// 设置user agent
func (r *Request) SetUserAgent(text string) {
	r.Req.Header.Set("User-Agent", text)
}

//设置自定义URL
func (r *Request) URL(o interface{}) {
	switch val := o.(type) {
	case string:
		if u, err := url.Parse(val); err == nil {
			r.BaseURL = u
		}
	case *url.URL:
		r.BaseURL = val
	}
}

//返回处理结果
func (r *Request) response() (Responder, error) {
	// 设置cookies
	r.setClientCookies()
	var err error
	if r.Resp, err = r.Client.Do(r.Req); err != nil {
		return nil, err
	}
	defer func() {
		if r.Resp != nil && r.Resp.Body != nil {
			r.Resp.Body.Close()
		}
	}()
	resp := &response{Request: r}
	resp.decompress(&r.Resp.Body)
	resp.bs, _ = ioutil.ReadAll(r.Resp.Body)
	resp.bs = bytes.TrimPrefix(resp.bs, []byte("\xef\xbb\xbf"))
	return resp, err
}

//get 请求
func (r *Request) Get(originUrl string, args ...interface{}) (Responder, error) {
	r.Lock()
	defer r.Unlock()
	req := form{origin: originUrl}
	delete(r.Req.Header, "Cookie")
	for _, arg := range args {
		switch val := arg.(type) {
		case Header:
			for k, v := range val {
				r.Req.Header.Set(k, v)
			}
		case Param:
			req.params = append(req.params, val)
		case Form:
			req.forms = append(req.forms, val)
		case Auth:
			r.Req.SetBasicAuth(val.Username, val.Password)
		}
	}
	r.Req.Method = "GET"
	r.Req.ContentLength = 0
	if err := req.AddQueryParams(r); err != nil {
		return nil, err
	}
	return r.response()
}

//POST 请求
func (r *Request) Post(originUrl string, args ...interface{}) (Responder, error) {
	r.Lock()
	defer r.Unlock()
	r.Req.Method = "POST"
	r.Req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
	req := form{origin: originUrl}
	delete(r.Req.Header, "Cookie")
	for _, arg := range args {
		switch val := arg.(type) {
		case Header:
			for k, v := range val {
				r.Req.Header.Set(k, v)
			}
		case Param:
			req.params = append(req.params, val)
		case Data:
			req.data = append(req.data, val)
		case Form:
			req.forms = append(req.forms, val)
		case PostForm:
			req.postForms = append(req.postForms, val)
		case Auth:
			r.Req.SetBasicAuth(val.Username, val.Password)
		case string:
			req.texts = append(req.texts, val)
		}
	}
	req.PostBody(r)
	if err := req.AddQueryParams(r); err != nil {
		return nil, err
	}
	return r.response()
}

//multipart 请求
func (r *Request) Multipart(originUrl string, args ...interface{}) (Responder, error) {
	r.Lock()
	defer r.Unlock()
	r.Req.Method = "POST"
	req := form{origin: originUrl}
	delete(r.Req.Header, "Cookie")
	for _, arg := range args {
		switch val := arg.(type) {
		case Header:
			for k, v := range val {
				r.Req.Header.Set(k, v)
			}
		case Param:
			req.params = append(req.params, val)
		case Data:
			req.data = append(req.data, val)
		case Form:
			req.forms = append(req.forms, val)
		case PostForm:
			req.postForms = append(req.postForms, val)
		case File:
			req.files = append(req.files, val)
		case Auth:
			r.Req.SetBasicAuth(val.Username, val.Password)
		case string:
			req.texts = append(req.texts, val)
		}
	}
	if err := req.MultipartBody(r); err != nil {
		return nil, err
	}
	if err := req.AddQueryParams(r); err != nil {
		return nil, err
	}
	return r.response()
}

//添加cookie
func (r *Request) AddCookie(cookies ...interface{}) {
	for _, v := range cookies {
		switch val := v.(type) {
		case string:
			c := Cookies(val)
			r.cookies = append(r.cookies, c.Cookies()...)
		case *http.Cookie:
			r.cookies = append(r.cookies, val)
		case http.Cookie:
			r.cookies = append(r.cookies, &val)
		}
	}
}

//设置cookies
func (r *Request) SetCookies(cookies interface{}) {
	switch val := cookies.(type) {
	case Cookies:
		r.cookies = val.Cookies()
	case string:
		c2 := Cookies(val)
		r.cookies = c2.Cookies()
	case []*http.Cookie:
		r.cookies = val
	case *[]*http.Cookie:
		r.cookies = *val
	}
}

//设置允许的域名
func (r *Request) AllowDomains(domains ...string) {
	for _, domain := range domains {
		domain = strings.TrimSpace(domain)
		if domain != "" {
			if URL, err := url.Parse(domain); err == nil {
				if URL.Host != "" {
					r.allowed[URL.Host] = true
					r.limited = true
				} else if URL.Path != "" {
					r.allowed[URL.Path] = true
					r.limited = true
				}
			}
		}
	}
}

//清除cookie
func (r *Request) ClearCookies() {
	r.cookies = nil
	r.Client.Jar, _ = cookiejar.New(nil)
}

//设置客户端cookies
func (r *Request) setClientCookies() {
	if len(r.cookies) > 0 {
		r.Client.Jar.SetCookies(r.Req.URL, r.cookies)
	}
	r.cookies = nil
}

//设置超时时间
func (r *Request) Timeout(n time.Duration) {
	r.Client.Timeout = n * time.Second
}

//代理
func (r *Request) Proxy(proxyUrl string) error {
	r.Lock()
	defer r.Unlock()
	var err error
	var proxyURL *url.URL
	if proxyURL, err = url.Parse(proxyUrl); err != nil {
		return errors.New("Set proxy failed " + err.Error())
	}
	r.Client.Transport = &http.Transport{
		Proxy:                 http.ProxyURL(proxyURL),
		TLSClientConfig:       &tls.Config{InsecureSkipVerify: true},
		MaxIdleConnsPerHost:   10,
		ResponseHeaderTimeout: time.Second * 10,
	}
	return nil
}

//绝对URL
func (r *Request) AbsURL(u string) string {
	if strings.HasPrefix(u, "#") || strings.HasPrefix(u, "javascript:;") {
		return ""
	}
	var baseURL, absURL *url.URL
	switch {
	case r.BaseURL != nil:
		baseURL = r.BaseURL
	case r.Resp.Request.URL != nil:
		baseURL = r.Resp.Request.URL
	case r.Req.URL != nil:
		baseURL = r.Req.URL
	default:
		return u
	}
	var err error
	if absURL, err = baseURL.Parse(u); err != nil {
		return ""
	}
	return absURL.String()
}

//get 请求
func Get(originUrl string, args ...interface{}) (Responder, error) {
	return New().Get(originUrl, args...)
}

//post 请求
func Post(originUrl string, args ...interface{}) (Responder, error) {
	return New().Post(originUrl, args...)
}

//postMultipart 请求
func Multipart(this string, args ...interface{}) (Responder, error) {
	return New().Multipart(this, args...)
}
