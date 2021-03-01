package requests

import (
	"bytes"
	"errors"
	"io/ioutil"
	"mime/multipart"
	"net/http"
	"net/textproto"
	"net/url"
	"strings"
)

type (
	Header   map[string]string   //头部信息
	Param    map[string]string   //get query
	Data     map[string]string   // for post form
	File     map[string]string   // name, filename
	Form     map[string][]string //URL参数
	PostForm map[string][]string //post 数据
	Cookies  string              // cookies
	//form
	form struct {
		origin    string     //url
		params    []Param    // set params ?a=b&b=c
		data      []Data     // POST
		files     []File     //post file
		forms     []Form     //URL参数
		postForms []PostForm //post 请求格式
		texts     []string   //文本格式
	}
)

// 输出为字符串
func (c Cookies) String() string {
	return string(c)
}

// 整理cookies
func (c *Cookies) Tidy() string {
	cookies := c.Cookies()
	if len(cookies) > 0 {
		var buf strings.Builder
		buf.WriteString(cookies[0].String())
		for _, v := range cookies[1:] {
			buf.WriteString("; ")
			buf.WriteString(v.String())
		}
		*c = Cookies(buf.String())
	}
	return c.String()
}

// 输出Cookies
func (c *Cookies) Cookies() []*http.Cookie {
	h := make(http.Header)
	for _, row := range strings.Split(string(*c), "\n") {
		for _, cookie := range strings.Split(row, ";") {
			h.Add("Set-Cookie", cookie)
		}
	}
	return (&http.Response{Header: h}).Cookies()
}

//获取
func (v Form) Get(key string) string {
	if v == nil {
		return ""
	}
	vs := v[key]
	if len(vs) == 0 {
		return ""
	}
	return vs[0]
}

//设置
func (v Form) Set(key, value string) {
	v[key] = []string{value}
}

//添加
func (v Form) Add(key, value string) {
	v[key] = append(v[key], value)
}

//删除
func (v Form) Del(keys ...string) {
	for _, key := range keys {
		delete(v, key)
	}
}

//获取
func (v PostForm) Get(key string) string {
	if v == nil {
		return ""
	}
	vs := v[key]
	if len(vs) == 0 {
		return ""
	}
	return vs[0]
}

//设置
func (v PostForm) Set(key, value string) {
	v[key] = []string{value}
}

//添加
func (v PostForm) Add(key, value string) {
	v[key] = append(v[key], value)
}

//删除
func (v PostForm) Del(keys ...string) {
	for _, key := range keys {
		delete(v, key)
	}
}

//handle file multipart
func (r *form) MultipartBody(req *Request) error {
	var buf bytes.Buffer
	w := multipart.NewWriter(&buf)
	//纯文本类型
	for _, text := range r.texts {
		h := make(textproto.MIMEHeader)
		h.Set("Content-Type", "text/plain") //设置文件格式
		pa, err := w.CreatePart(h)
		if err != nil {
			return err
		}
		if _, err := pa.Write([]byte(text)); err != nil {
			return err
		}
	}
	//文件类型
	for _, file := range r.files {
		for k, v := range file {
			part, err := CreateFormFile(w, k, v)
			if err != nil {
				return errors.New("Upload " + v + " Error: %s" + err.Error())
			}
			if err := copyFile(part, v); err != nil {
				return errors.New("Upload " + v + " Error: %s" + err.Error())
			}
		}
	}
	//url.Values 类型
	for _, form := range r.postForms {
		for k, v := range form {
			for _, vv := range v {
				if err := w.WriteField(k, vv); err != nil {
					return err
				}
			}
		}
	}
	//url.Values 类型 key value
	for _, data := range r.data {
		for k, v := range data {
			if err := w.WriteField(k, v); err != nil {
				return err
			}
		}
	}
	contentType := w.FormDataContentType()
	if err := w.Close(); err != nil {
		return err
	}
	req.Req.Body = ioutil.NopCloser(bytes.NewReader(buf.Bytes()))
	req.Req.ContentLength = int64(buf.Len())
	req.Req.Header.Set("Content-Type", contentType)
	return nil
}

// 把参数设置到body中
func (r *form) PostBody(req *Request) {
	if len(r.texts) > 0 {
		//纯文本类型
		var buf bytes.Buffer
		for _, text := range r.texts {
			buf.WriteString(text)
		}
		req.Req.Body = ioutil.NopCloser(bytes.NewReader(buf.Bytes()))
		req.Req.ContentLength = int64(buf.Len())
		return
	}
	forms := make(url.Values)
	for _, postForm := range r.postForms {
		for k, v := range postForm {
			for _, vv := range v {
				forms.Add(k, vv)
			}
		}
	}
	for _, data := range r.data {
		for k, v := range data {
			forms.Add(k, v)
		}
	}
	data := forms.Encode()
	req.Req.Body = ioutil.NopCloser(strings.NewReader(data))
	req.Req.ContentLength = int64(len(data))
}

//添加请求到URL中
func (r *form) AddQueryParams(req *Request) error {
	URL, err := url.Parse(r.origin)
	if err != nil {
		return err
	}
	if req.limited {
		if err := func() error {
			if len(URL.Host) == 0 {
				return AllowedErr
			}
			if !req.allowed[URL.Host] {
				index := strings.Index(URL.Host, ".")
				if index == -1 {
					return AllowedErr
				}
				if !req.allowed["*"+URL.Host[index:]] {
					return AllowedErr
				}
			}
			return nil
		}(); err != nil {
			return AllowedErr
		}
	}
	if len(r.forms) > 0 || len(r.params) > 0 {
		Query := URL.Query()
		for _, form := range r.forms {
			for k, v := range form {
				for _, vv := range v {
					Query.Add(k, vv)
				}
			}
		}
		for _, param := range r.params {
			for key, value := range param {
				Query.Add(key, value)
			}
		}
		URL.RawQuery = Query.Encode()
	}
	req.Req.URL = URL
	return nil
}
