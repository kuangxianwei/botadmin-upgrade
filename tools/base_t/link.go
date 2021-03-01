package base_t

import (
	"botadmin/tools/utils"
	"bytes"
	"sort"
	"strings"
)

type (
	//链接
	Link struct {
		Title, Url string
	}
	Links []Link
)

//输出字符串格式 试管婴儿=>https://www.nfivf.com
func (l Link) String() string {
	return l.Title + "=>" + l.Url
}

//输出html格式
func (l Link) Html() string {
	return "<a href=\"" + l.Url + "\" title=\"" + l.Title + "\" target=\"_blank\">" + l.Title + "</a>"
}

//添加链接
func (l *Links) Add(s ...string) {
	for _, v := range s {
		if ls := strings.SplitN(v, "=>", 2); len(ls) == 2 {
			k := strings.TrimSpace(ls[0])
			u := strings.TrimSpace(ls[1])
			if k != "" && u != "" {
				*l = append(*l, Link{Title: k, Url: u})
			}
		}
	}
}

// 按标题长度排序
func (l *Links) Sort() {
	l.Unique()
	sort.SliceStable(*l, func(i, j int) bool {
		return (*l)[i].Title > (*l)[j].Title
	})
}

// 去除重复
func (l *Links) Unique() {
	titleMap := make(map[string]bool)
	urlMap := make(map[string]bool)
	for i := 0; i < len(*l); i++ {
		if titleMap[(*l)[i].Title] && urlMap[(*l)[i].Url] {
			*l = append((*l)[:i], (*l)[i+1:]...)
			i--
			continue
		}
		titleMap[(*l)[i].Title] = true
		urlMap[(*l)[i].Url] = true
	}
}
func (l *Links) Replace(textPtr *string) {
	l.Sort()
	if textPtr != nil {
		rs := make([]string, 0, len(*l)*2)
		for _, v := range *l {
			rs = append(rs, v.Title, v.Html())
		}
		*textPtr = strings.NewReplacer(rs...).Replace(*textPtr)
	}
}

//格式化输出
func (l Links) ToString() string {
	var buf bytes.Buffer
	length := len(l) - 1
	for _, v := range l[:length] {
		buf.WriteString(v.String())
		buf.WriteByte('\n')
	}
	buf.WriteString(l[length].String())
	return buf.String()
}

//格式化输出slice
func (l Links) ToSlice() []string {
	ls := make([]string, len(l))
	for i, v := range l {
		ls[i] = v.String()
	}
	utils.UniqueSliceStr(&ls, nil)
	return ls
}

//删除元素
func (l *Links) Del(links ...Link) {
	newLinks := make(Links, 0, len(links))
	for _, v := range *l {
		if !InLinks(v, links) {
			newLinks = append(newLinks, v)
		}
	}
	*l = newLinks
}

//随机选择一个
func (l Links) Choice() string {
	ls := l.ChoiceN(1)
	if len(ls) > 0 {
		return ls[0]
	}
	return ""
}

//随机选择N个
func (l Links) ChoiceN(n int) []string {
	links := make(Links, len(l))
	copy(links, l)
	return links.ReduceN(n)
}

//随机选择一个并删除所选
func (l *Links) Reduce() string {
	ls := l.ReduceN(1)
	if len(ls) > 0 {
		return ls[0]
	}
	return ""
}

//随机选择N个并删除所选
func (l *Links) ReduceN(n int) []string {
	rs := make([]string, 0, len(*l))
	for len(*l) > 0 && n > 0 {
		index := utils.Random(0, len(*l))
		rs = append(rs, (*l)[index].Html())
		*l = append((*l)[:index], (*l)[index+1:]...)
		n--
	}
	return rs
}

//判断链接存在
func InLinks(link Link, links Links) bool {
	for _, v := range links {
		if v == link {
			return true
		}
	}
	return false
}
