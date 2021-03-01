package base_t

import (
	"botadmin/tools/utils"
	"encoding/json"
	"strings"
)

//发布文章结果
type PubResult struct {
	Id        int64  `json:"id"`
	ClassId   int64  `json:"class_id"`
	ClassName string `json:"class_name"`
	Title     string `json:"title"`
	Url       string `json:"url"`
	Create    string `json:"create"`
	Author    string `json:"author"`
	Status    string `json:"status"`
}
type PubResults []PubResult

//加载来自数据库的数据到结构体中

func (r *PubResults) FromDB(b []byte) error {
	return json.Unmarshal(b, r)
}

//把结构体中的数据转为bytes
func (r *PubResults) ToDB() ([]byte, error) {
	return json.Marshal(r)
}

//获取全部URL
func (r PubResults) Urls() []string {
	ls := make([]string, 0, len(r))
	for _, v := range r {
		if v.Url != "" {
			ls = append(ls, v.Url)
		}
	}
	return ls
}

//获取全部标题
func (r PubResults) Title() []string {
	ls := make([]string, 0, len(r))
	for _, v := range r {
		if v.Title != "" {
			ls = append(ls, v.Title)
		}
	}
	return ls
}

//去除重复
func (r *PubResults) Unique() {
	urlMap := make(map[string]bool, len(*r))
	for i := 0; i < len(*r); i++ {
		(*r)[i].Url = strings.TrimSpace((*r)[i].Url)
		if !utils.HasScheme((*r)[i].Url) || urlMap[(*r)[i].Url] {
			*r = append((*r)[:i], (*r)[i+1:]...)
			i--
		}
	}
}

//存在URL
func (r PubResults) HasUrl(url string) bool {
	for _, v := range r {
		if v.Url == url {
			return true
		}
	}
	return false
}

//添加
func (r *PubResults) AddUrl(urls ...string) {
	for _, v := range urls {
		if !r.HasUrl(v) {
			*r = append(*r, PubResult{Url: v})
		}
	}
}
