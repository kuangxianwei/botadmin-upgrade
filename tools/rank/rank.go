package rank

import (
	"botadmin/tools/requests"
	"github.com/PuerkitoBio/goquery"
	"strconv"
	"strings"
	"time"
)

const (
	BaiduPcName     = "百度PC"
	BaiduMobileName = "百度移动"
	SmName          = "神马搜索"
	TouTiaoName     = "头条搜索"
	AllName         = "全部引擎"
	baiduPcUrl      = "https://www.baidu.com/s?ie=UTF-8&f=8&usm=0&sa=np&rsv_idx=2&rsv_page=1&rn=50&wd="
	baiduMobileUrl  = "http://m.baidu.com/s?ie=UTF-8&f=8&usm=0&sa=np&rsv_idx=2&rsv_page=1&word="
	smUrl           = "https://m.sm.cn/s?by=next&snum=6&layout=html&q="
	toutiaoUrl      = "https://m.toutiao.com/search?pd=synthesis&source=input&keyword="
)

//搜索引擎
var (
	EngineMap = map[string]Engine{
		BaiduPcName:     BaiduPc,
		BaiduMobileName: BaiduMobile,
		SmName:          Sm,
		TouTiaoName:     Toutiao,
	}
	Engines = []string{
		AllName,
		BaiduPcName,
		BaiduMobileName,
		SmName,
		TouTiaoName,
	}
)

//排名结果
type (
	Rank struct {
		Expect    string `json:"expect"`    //希望出现的词或网网址
		Keyword   string `json:"keyword"`   //检索的单词
		Level     int    `json:"level"`     //排在第N名次
		Timestamp int64  `json:"timestamp"` //创建时的时间戳
		Engine    string `json:"engine"`    //搜索引擎
		Err       error  `json:"err"`       //错误类型
	}
	Ranker interface {
		BaiduPc() Rank
		BaiduMobile() Rank
		Sm() Rank
		Toutiao() Rank
	}
	ranker struct {
		keyword string //关键词
		expect  string //期望值
	}
	Engine func(keyword, expect string) Rank
)

//百度PC版
func (r *ranker) BaiduPc() Rank {
	var dom *goquery.Document
	var err error
	var pn int
	//req := requests.New()
	var url = baiduPcUrl + r.keyword
	result := Rank{Keyword: r.keyword, Expect: r.expect, Engine: BaiduPcName}
	for pn < 100 {
		if dom, err = GetBaiduDOM(url + "&pn=" + strconv.Itoa(pn)); err != nil {
			result.Timestamp = time.Now().Local().UnixNano()
			result.Err = err
			return result
		}
		pn += 50
		dom.Find("#content_left > div").EachWithBreak(func(i int, selection *goquery.Selection) bool {
			if level, has := selection.Attr("id"); has {
				if strings.Contains(selection.Find("div.f13").First().Text(), r.expect) {
					result.Level, _ = strconv.Atoi(level)
					result.Timestamp = time.Now().Local().UnixNano()
					return false
				}
			}
			return true
		})
		if result.Level > 0 {
			break
		}
	}
	if result.Timestamp == 0 {
		result.Timestamp = time.Now().Local().UnixNano()
	}
	return result
}

//百度手机版
func (r *ranker) BaiduMobile() Rank {
	var dom *goquery.Document
	var err error
	var pn int
	req := new(requests.Request).Init()
	req.Req.Header.Set("User-Agent", requests.UserAgentIphone)
	var url = baiduMobileUrl + r.keyword
	result := Rank{Keyword: r.keyword, Expect: r.expect, Engine: BaiduMobileName}
	for pn <= 100 {
		if dom, err = GetBaiduDOM(url + "&pn=" + strconv.Itoa(pn)); err != nil {
			result.Err = err
			result.Timestamp = time.Now().Local().UnixNano()
			return result
		}
		pn += 10
		dom.Find("#results > div.result").EachWithBreak(func(i int, selection *goquery.Selection) bool {
			if rank, err := strconv.Atoi(selection.AttrOr("order", "0")); err == nil {
				if strings.Contains(selection.Find("div.c-result-content>article>section>div").Last().Text(), r.expect) {
					result.Timestamp = time.Now().Local().UnixNano()
					result.Level = rank
					return false
				}
			}
			return true
		})
		if result.Level > 0 {
			break
		}
	}
	if result.Timestamp == 0 {
		result.Timestamp = time.Now().Local().UnixNano()
	}
	return result
}

//神马搜索
func (r *ranker) Sm() Rank {
	var dom *goquery.Document
	var err error
	var page int
	req := new(requests.Request).Init()
	req.Req.Header.Set("User-Agent", requests.UserAgentIphone)
	var url = smUrl + r.keyword
	result := Rank{Keyword: r.keyword, Expect: r.expect, Engine: SmName}
	var rank int
	for page < 10 {
		if dom, err = GetSmDOM(req, url+"&page="+strconv.Itoa(page+1)); err != nil {
			result.Err = err
			result.Timestamp = time.Now().Local().UnixNano()
			return result
		}
		dom.Find("div.result").EachWithBreak(func(i int, selection *goquery.Selection) bool {
			if href, has := selection.Find("a.c-e-source").Attr("href"); has {
				if strings.Contains(href, r.expect) {
					result.Timestamp = time.Now().Local().UnixNano()
					result.Level = rank + i + 1
					return false
				}
			}
			if strings.Contains(selection.Find("a.c-e-source>span>span").First().Text(), r.expect) {
				result.Timestamp = time.Now().Local().UnixNano()
				result.Level = rank + i + 1
				return false
			}
			return true
		})
		rank += 10
		page++
		if result.Level > 0 {
			break
		}
	}
	if result.Timestamp == 0 {
		result.Timestamp = time.Now().Local().UnixNano()
	}
	return result
}

//今日头条搜索
func (r *ranker) Toutiao() Rank {
	var dom *goquery.Document
	var err error
	var page int
	req := new(requests.Request).Init()
	req.Req.Header.Set("User-Agent", requests.UserAgentIphone)
	var url = toutiaoUrl + r.keyword
	result := Rank{Keyword: r.keyword, Expect: r.expect, Engine: TouTiaoName}
	for url != "" && page < 10 {
		if dom, err = GetToutiaoDOM(req, url); err != nil {
			result.Err = err
			result.Timestamp = time.Now().Local().UnixNano()
			return result
		}
		url = dom.Find("#bottom-bar a").AttrOr("href", "")
		page++
		dom.Find("#results>div div.cs-source").EachWithBreak(func(i int, selection *goquery.Selection) bool {
			if strings.Contains(selection.Text(), r.expect) {
				result.Level = (page-1)*10 + i
				result.Timestamp = time.Now().Local().UnixNano()
				return false
			}
			return true
		})
	}
	if result.Timestamp == 0 {
		result.Timestamp = time.Now().Local().UnixNano()
	}
	return result
}

//新建排名查询
func New(keyword, expect string) Ranker {
	return &ranker{keyword: keyword, expect: expect}
}

//百度PC版
func BaiduPc(keyword, expect string) Rank {
	return New(keyword, expect).BaiduPc()
}

//百度手机版
func BaiduMobile(keyword, expect string) Rank {
	return New(keyword, expect).BaiduMobile()
}

//神马搜索
func Sm(keyword, expect string) Rank {
	return New(keyword, expect).Sm()
}

//今日头条搜索
func Toutiao(keyword, expect string) Rank {
	return New(keyword, expect).Toutiao()
}
