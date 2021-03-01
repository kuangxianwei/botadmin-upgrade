package requests

import (
	"bytes"
	"compress/gzip"
	"encoding/json"
	"errors"
	"fmt"
	"github.com/PuerkitoBio/goquery"
	"golang.org/x/net/html/charset"
	"io"
	"io/ioutil"
	"log"
	"net/http"
	"net/url"
	"regexp"
	"strings"
	"sync"
)

//请求响应结果
type Responder interface {
	/*获取 cookies */
	Cookies() []*http.Cookie
	/*cookies 结果文本格式*/
	CookiesText() string
	//获取301 跳转路径
	Location() string
	//获取DOM
	DOM() (*goquery.Document, error)
	//获取bytes 转为utf8格式
	Bytes(charsets ...string) []byte
	//获取 读接口类型
	Reader(charsets ...string) io.Reader
	//字符串类型
	Text(charsets ...string) string
	//保存到文件
	SaveFile(filename string, statusCodes ...int) error
	//json 格式
	Json(v interface{}, charsets ...string) error
	//状态码
	StatusCode() int
	//获取请求的URL 返回 *url.URL
	URL() *url.URL
	//获取绝对URL
	AbsURL(u string) string
	//获取请求的URL 返回 string
	Url() string
	//获取表单 goquery 解析
	Form(selector ...string) (PostForm, error)
	//获取表单 正则解析
	FormRe(matcher ...string) (PostForm, error)
	//原始
	DIY() *Request
}
type response struct {
	*Request
	bs        []byte
	encodeOne sync.Once
	text      string
	charset   string
}

/*cookies 结果*/
func (r *response) Cookies() []*http.Cookie {
	return r.Client.Jar.Cookies(r.Req.URL)
}

/*cookies 结果文本格式*/
func (r *response) CookiesText() string {
	cs := r.Cookies()
	if len(cs) == 0 {
		return ""
	}
	buf := bytes.NewBuffer([]byte(cs[0].String()))
	for _, v := range cs[1:] {
		buf.WriteString("; ")
		buf.WriteString(v.String())
	}
	return buf.String()
}

//获取301 跳转路径
func (r *response) Location() string {
	if r.Resp.Request != nil {
		return r.Resp.Request.Header.Get("Location")
	}
	return ""
}

//解压缩
func (r *response) decompress(rb *io.ReadCloser) {
	if r.Resp.Header.Get("Content-Encoding") == "gzip" {
		if reader, err := gzip.NewReader(*rb); err != nil {
			log.Panicln(err.Error())
		} else {
			*rb = reader
		}
	}
}

//指定编码
func (r *response) EncoderUTF8(charsets ...string) {
	r.encodeOne.Do(func() {
		if len(charsets) > 0 {
			r.charset = charsets[0]
		}
		if r.charset == "" {
			r.bs = decoderAuto(r.bs)
		}
		u, name := charset.Lookup(r.charset)
		switch name {
		case "gb18030", "gbk":
			if bs, err := u.NewDecoder().Bytes(r.bs); err == nil {
				r.bs = bs
			}
		case "utf-8":
		default:
			r.bs = decoderAuto(r.bs)
		}
	})
}

//获取bytes 转为utf8格式
func (r *response) Bytes(charsets ...string) []byte {
	r.EncoderUTF8(charsets...)
	return r.bs
}

//获取读类型
func (r *response) Reader(charsets ...string) io.Reader {
	r.EncoderUTF8(charsets...)
	return bytes.NewReader(r.bs)
}

//获取string类型
func (r *response) Text(charsets ...string) string {
	if r.text == "" {
		r.EncoderUTF8(charsets...)
		r.text = string(r.bs)
	}
	return r.text
}

//保存为文件
func (r *response) SaveFile(filename string, statusCodes ...int) error {
	r.EncoderUTF8()
	statusCode := 200
	if len(statusCodes) > 0 {
		statusCode = statusCodes[0]
	}
	if r.StatusCode() != statusCode {
		return fmt.Errorf("download code=%d", r.StatusCode())
	}
	if r.bs == nil {
		return errors.New("文件内容为空")
	}
	return ioutil.WriteFile(filename, r.bs, 0755)
}

//解析到json
func (r *response) Json(obj interface{}, charsets ...string) error {
	r.EncoderUTF8(charsets...)
	if !json.Valid(r.bs) {
		return errors.New("error:不是标准JSON 格式\n" + string(r.bs))
	}
	return json.Unmarshal(r.bs, obj)
}

//获取为DOM
func (r *response) DOM() (*goquery.Document, error) {
	r.EncoderUTF8()
	return goquery.NewDocumentFromReader(bytes.NewReader(r.bs))
}

//获取状态码
func (r *response) StatusCode() int {
	return r.Resp.StatusCode
}

//获取请求的URL
func (r *response) URL() *url.URL {
	return r.Resp.Request.URL
}

//获取请求的URL
func (r *response) Url() string {
	return r.Resp.Request.URL.String()
}

//返回请求
func (r *response) DIY() *Request {
	return r.Request
}

//获取表单 goquery 解析
func (r *response) Form(selector ...string) (form PostForm, err error) {
	var dom *goquery.Document
	r.EncoderUTF8()
	form = make(PostForm)
	if dom, err = goquery.NewDocumentFromReader(bytes.NewReader(r.bs)); err != nil {
		return form, err
	}
	if len(selector) > 0 {
		dom.Selection = dom.Selection.Find(selector[0])
	}
	r.parseForm(form, dom.Selection)
	return form, nil
}

//正则获取
func (r *response) FormRe(matcher ...string) (form PostForm, err error) {
	var dom *goquery.Document
	r.EncoderUTF8()
	form = make(PostForm)
	bs := r.bs
	if len(matcher) > 0 {
		if re, err := regexp.Compile(matcher[0]); err != nil {
			return form, err
		} else {
			bs = re.Find(r.bs)
		}
	}
	if dom, err = goquery.NewDocumentFromReader(bytes.NewReader(bs)); err != nil {
		return form, err
	}
	r.parseForm(form, dom.Selection)
	return form, nil
}

//解析form数据
func (r *response) parseForm(form PostForm, selection *goquery.Selection) {
	//input 数据
	selection.Find("input").Each(func(i int, s *goquery.Selection) {
		if t, has := s.Attr("type"); has {
			switch strings.ToLower(t) {
			case "radio":
				if _, has := s.Attr("checked"); !has {
					return
				}
				if name, has := s.Attr("name"); has {
					form[name] = []string{s.AttrOr("value", name)}
				}
			case "checkbox":
				name, has := s.Attr("name")
				if !has {
					return
				}
				if _, has := s.Attr("checked"); has {
					value := s.AttrOr("value", "on")
					val, ok := form[name]
					if ok {
						val = append(val, value)
					} else {
						val = []string{value}
					}
					form[name] = val
				}
			case "file", "reset", "button":
			default:
				if name, has := s.Attr("name"); has {
					value := s.AttrOr("value", "")
					val, ok := form[name]
					if ok {
						val = append(val, value)
					} else {
						val = []string{value}
					}
					form[name] = val
				}
			}
		}
	})
	//textarea
	selection.Find("textarea").Each(func(i int, s *goquery.Selection) {
		if name, has := s.Attr("name"); has {
			form[name] = []string{s.Text()}
		}
	})
	//select
	selection.Find("select").Each(func(i int, s *goquery.Selection) {
		name, has := s.Attr("name")
		if !has {
			return
		}
		var selected bool
		notes := s.Find("option")
		notes.Each(func(i int, s *goquery.Selection) {
			if _, has := s.Attr("selected"); has {
				form[name] = []string{s.AttrOr("value", "")}
				selected = true
			}
		})
		if !selected {
			form[name] = []string{notes.First().AttrOr("value", "")}
		}
	})
}
