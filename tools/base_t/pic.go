package base_t

import (
	"math/rand"
	"time"
)

type (
	Pic struct {
		Path     string
		Name     string
		Url      string
		SmallUrl string
		Type     string
	}
	Pics []Pic
)

//获取URL列表
func (p Pics) Urls() []string {
	urls := make([]string, 0, len(p))
	for _, v := range p {
		if v.Url != "" {
			urls = append(urls, v.Url)
		}
	}
	return urls
}

//判断名称是否存在
func (p Pics) HasName(name string) bool {
	for _, v := range p {
		if v.Name == name {
			return true
		}
	}
	return false
}

//判断url是否存在
func (p Pics) HasUrl(u string) bool {
	for _, v := range p {
		if v.Url == u {
			return true
		}
	}
	return false
}

//判断缩微图是否存在
func (p Pics) HasSmall(u string) bool {
	for _, v := range p {
		if v.SmallUrl == u {
			return true
		}
	}
	return false
}

//随机获取一个
func (p Pics) Choice() Pic {
	count := len(p)
	if count == 0 {
		return Pic{}
	}
	r := rand.New(rand.NewSource(time.Now().UnixNano()))
	return p[r.Intn(count)]
}

//判断存在元素
func (p Pics) Has(pic Pic) bool {
	for _, v := range p {
		if v == pic {
			return true
		}
	}
	return false
}

//随机获取N个路径
func (p Pics) ChoiceN(n int) Pics {
	if n == 0 {
		return nil
	}
	if n < 0 || n >= len(p) {
		return p
	}
	newPics := make(Pics, 0, n)
	for i := 0; i < 1000; i++ {
		v := p.Choice()
		if !newPics.Has(v) {
			newPics = append(newPics, v)
			if len(newPics) >= n {
				break
			}
		}
	}
	return newPics
}
