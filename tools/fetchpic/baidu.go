package fetchpic

import (
	"botadmin/tools/pool"
	"botadmin/tools/utils"
	"bytes"
	"encoding/json"
	"errors"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"net/url"
	"os"
	"path/filepath"
	"strconv"
	"time"
)

const baiduOrigin = "https://image.baidu.com/search/acjson"

type baidu struct {
	Config
}
type bdData struct {
	HoverURL  string `json:"hoverURL"`
	MiddleURL string `json:"middleURL"`
}

func (d bdData) Get() string {
	if d.MiddleURL != "" {
		return d.MiddleURL
	}
	return d.HoverURL
}

type bdResult struct {
	BdFmtDispNum       string   `json:"bdFmtDispNum"`
	BdIsClustered      string   `json:"bdIsClustered"`
	DisplayNum         int      `json:"displayNum"` // 显示数量
	Gsm                string   `json:"gsm"`
	IsNeedAsyncRequest int      `json:"isNeedAsyncRequest"`
	ListNum            int      `json:"listNum"`
	QueryEnc           string   `json:"queryEnc"`
	QueryExt           string   `json:"queryExt"`
	Data               []bdData `json:"data"`
}

func (b *baidu) init() {
	if b.results == nil {
		b.results = make(map[string]Picture)
		if b.Limit < 1 {
			b.Limit = 30
		}
		if b.Begin < 0 {
			b.Begin = 0
		}
		if b.End < 1 {
			b.End = 1
		}
		if b.Begin > b.End {
			b.Begin, b.End = b.End, b.Begin
		}
	}
	if b.Buf == nil {
		b.Buf = new(bytes.Buffer)
	}
}
func (b *baidu) SetBuf(buf *bytes.Buffer) {
	b.Buf = buf
}

// 获取列表结果
func (b *baidu) Results() []Picture {
	b.init()
	rs := make([]Picture, 0, len(b.results))
	for _, v := range b.results {
		rs = append(rs, v)
	}
	return rs
}
func (b *baidu) Errors() []error {
	return b.Errs
}
func (b *baidu) Success() []Picture {
	return b.Config.Success
}

// 获取json URL
func (b *baidu) jsonUrl(param map[string]string) string {
	params := url.Values{
		"tn":        []string{"resultjson_com"},
		"ipn":       []string{"rj"},
		"ct":        []string{"201326592"},
		"is":        []string{""},
		"fp":        []string{"result"},
		"cl":        []string{"2"},
		"lm":        []string{"-1"},
		"ie":        []string{"utf-8"},
		"oe":        []string{"utf-8"},
		"adpicid":   []string{""},
		"st":        []string{""},
		"z":         []string{""},
		"ic":        []string{""},
		"hd":        []string{""},
		"latest":    []string{""},
		"copyright": []string{""},
		"s":         []string{""},
		"se":        []string{""},
		"tab":       []string{""},
		"width":     []string{""},
		"height":    []string{""},
		"face":      []string{""},
		"istype":    []string{""},
		"qc":        []string{""},
		"nc":        []string{"1"},
		"fr":        []string{""},
		"expermode": []string{""},
		"force":     []string{""},
		"rn":        []string{"30"},
		"gsm":       []string{"78"},
		strconv.FormatInt(time.Now().UnixNano(), 10)[:13]: []string{""},
		"queryWord": []string{""},
		"word":      []string{""},
	}
	for k, v := range param {
		params.Set(k, v)
	}
	params.Set("rn", strconv.Itoa(b.Limit))
	URL, _ := url.Parse(baiduOrigin)
	URL.RawQuery = params.Encode()
	return URL.String()
}

// 查询
func (b *baidu) QueryData() error {
	b.init()
	count := b.End - b.Begin
	var err error
	for _, keyword := range b.Keywords {
		r := bdResult{}
		for i := 0; i < count; i++ {
			if i > 0 && r.DisplayNum <= i*b.Limit {
				break
			}
			if r, err = b.jsonData(keyword, r.Gsm, i*b.Limit); err != nil {
				return err
			}
		}
	}
	return nil
}

func (b *baidu) jsonData(queryWord, gsm string, pn int) (bdResult, error) {
	r, err := http.Get(b.jsonUrl(map[string]string{
		"gsm":       gsm,
		"pn":        strconv.Itoa(pn),
		"queryWord": queryWord,
		"word":      queryWord,
	}))
	if err != nil {
		return bdResult{}, err
	}
	defer func() {
		r.Body.Close()
	}()
	bs, _ := ioutil.ReadAll(r.Body)
	bs = bytes.ReplaceAll(bs, []byte("\b"), []byte(""))
	var rJson bdResult
	if err := json.Unmarshal(bs, &rJson); err != nil {
		return bdResult{}, fmt.Errorf("%#v, Error: %s", string(bs), err.Error())
	}
	for _, v := range rJson.Data {
		if u := v.Get(); u != "" {
			if _, ok := b.results[u]; !ok {
				p := Picture{Url: u}
				if p.Tidy() {
					b.results[u] = p
				}
			}
		}
	}
	return rJson, nil
}
func (b *baidu) save(p Picture) error {
	defer func() {
		if e := recover(); e != nil {
			log.Println(e)
		}
	}()
	time.Sleep(time.Duration(b.Delay) * time.Second)
	b.Buf.WriteString("延迟 " + strconv.FormatInt(b.Delay, 10) + " 秒\n")
	request, err := http.NewRequest("GET", p.Url, nil)
	if err != nil {
		return errors.New(p.Url + " request " + err.Error())
	}
	request.Header.Add("Referer", baiduOrigin)
	client := &http.Client{}
	b.Buf.WriteString("开始请求: " + p.Url + "\n")
	resp, err := client.Do(request)
	if err != nil {
		return errors.New(p.Url + " res " + err.Error())
	}
	defer resp.Body.Close()
	bs, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return errors.New(p.Url + " 读取 " + err.Error())
	}
	if _, err = GetExt(bs); err != nil {
		return errors.New(p.Url + " " + err.Error())
	}
	return ioutil.WriteFile(filepath.Join(b.Dirname, p.Filename), bs, 0666)
}
func (b *baidu) Save() {
	if b.Dirname == "" {
		b.Buf.WriteString("保存目录为空\n")
		b.Errs = append(b.Errs, errors.New("保存目录为空"))
		return
	}
	if b.results == nil || b.Buf == nil {
		if err := b.QueryData(); err != nil {
			b.Errs = append(b.Errs, err)
			return
		}
	}
	count := len(b.results)
	if count == 0 {
		b.Buf.WriteString("无操作\n")
		b.Errs = append(b.Errs, errors.New("无操作"))
		return
	}
	if !utils.IsDir(b.Dirname) {
		if err := os.MkdirAll(b.Dirname, 0755); err != nil {
			b.Buf.WriteString(err.Error() + "\n")
			b.Errs = append(b.Errs, err)
			return
		}
	}
	if b.Thread < 1 {
		b.Thread = 1
	}
	if b.Thread > 50 {
		b.Thread = 50
	}
	jobs := make([]func() pool.Result, 0, count)
	for _, v := range b.results {
		var p = v
		jobs = append(jobs, func() pool.Result {
			if e := b.save(p); e != nil {
				b.Buf.WriteString(e.Error() + "\n")
				return pool.Result{Err: e}
			}
			b.Buf.WriteString(p.Url + " 成功下载到 " + p.Filename + "\n")
			return pool.Result{Res: p}
		})
	}
	p := pool.NewWithReturn(jobs...)
	p.Do(b.Thread)
	ok := true
	var r pool.Result
	for ok {
		r, ok = p.Next()
		if r.Err != nil {
			b.Errs = append(b.Errs, r.Err)
		} else {
			if pic, has := r.Res.(Picture); has {
				b.Config.Success = append(b.Config.Success, pic)
			}
		}
	}
}

func init() {
	if err := Fetches.Register(Fetch{
		Sort:  0,
		Name:  "baidu",
		Alias: "百度",
		Func: func(c Config) Fetcher {
			obj := new(baidu)
			obj.Config = c
			return obj
		},
	}); err != nil {
		panic(err.Error())
	}
}
