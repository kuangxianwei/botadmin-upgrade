package rank

import (
	"botadmin/tools/requests"
	"errors"
	"github.com/PuerkitoBio/goquery"
	"log"
	"time"
)

//获取百度搜索结果
func GetBaiduDOM(url string) (dom *goquery.Document, err error) {
	var r requests.Responder
	for i := 0; i < 30; i++ {
		if r, err = requests.Get(url); err != nil {
			return nil, err
		}
		if dom, err = r.DOM(); err != nil {
			return nil, err
		}
		if dom.Find("title").Text() == "百度安全验证" {
			time.Sleep(1 * time.Second)
			continue
		}
		return dom, err
	}
	return nil, errors.New(url + " " + r.Text())
}

//获取神马搜索结果
func GetSmDOM(req requests.Requester, url string) (dom *goquery.Document, err error) {
	var r requests.Responder
	for i := 0; i < 30; i++ {
		if r, err = req.Get(url); err != nil {
			return nil, err
		}
		if dom, err = r.DOM(); err != nil {
			return nil, err
		}
		if dom.Find("p.page-index").Index() == -1 {
			log.Println(dom.Text())
			continue
		}
		return dom, err
	}
	return nil, errors.New(url + " " + r.Text())
}

//获取头条搜索结果
func GetToutiaoDOM(req requests.Requester, url string) (dom *goquery.Document, err error) {
	var r requests.Responder
	for i := 0; i < 30; i++ {
		if r, err = req.Get(url); err != nil {
			return nil, err
		}
		if dom, err = r.DOM(); err != nil {
			return nil, err
		}
		if dom.Find("#results").Index() == -1 {
			log.Println(dom.Text())
			continue
		}
		return dom, err
	}
	return nil, errors.New(url + " " + r.Text())
}
