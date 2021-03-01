package base_t

import (
	"sort"
	"strings"
)

type (
	oldNew struct {
		old, new string
	}
	Ban struct {
		Denies   []string          `json:"denies" form:"denies" xorm:"denies" sep:"\n"` //禁令词列表
		Allows   []string          `json:"allows" form:"allows" xorm:"allows" sep:"\n"` //允许词列表
		replacer *strings.Replacer `form:"-" xorm:"-"`                                  // 禁令词替换列表
		denyMap  map[string]bool   `form:"-" xorm:"-"`
	}
)

func (b *Ban) SetMap() {
	if b.denyMap == nil {
		b.denyMap = make(map[string]bool)
	}
	unique(&b.Denies)
	unique(&b.Allows)
	for _, v := range b.Denies {
		b.denyMap[v] = true
	}
}
func (b *Ban) Add(denies ...string) {
	var modified bool
	if b.denyMap == nil {
		b.denyMap = make(map[string]bool)
	}
	for _, v := range denies {
		if !b.denyMap[v] {
			b.Denies = append(b.Denies, v)
			b.denyMap[v] = true
			modified = true
		}
	}
	if modified {
		b.BuildReplacer()
	}
}

// 构造禁令词替换列表
func (b *Ban) BuildReplacer() {
	var denies = make([]string, len(b.Denies))
	copy(denies, b.Denies)
	for i := 0; i < len(denies); i++ {
		if inSlice(denies[i], b.Allows) {
			denies = append(denies[:i], denies[i+1:]...)
			i--
		}
	}
	replaces := make([]oldNew, 0, len(denies)+len(b.Allows))
	for _, v := range denies {
		replaces = append(replaces, oldNew{old: v, new: strings.Repeat("*", len([]rune(v)))})
	}
	for _, v := range b.Allows {
		replaces = append(replaces, oldNew{old: v, new: v})
	}
	sort.SliceStable(replaces, func(i, j int) bool {
		return replaces[i].old > replaces[j].old
	})
	rs := make([]string, 0, len(replaces)*2)
	for _, v := range replaces {
		rs = append(rs, v.old, v.new)
	}
	b.replacer = strings.NewReplacer(rs...)
}

// 执行替换
func (b *Ban) Do(src string) string {
	if b.replacer == nil {
		unique(&b.Denies)
		b.BuildReplacer()
	}
	return b.replacer.Replace(src)
}
func vet(strPtr *string) bool {
	*strPtr = strings.TrimSpace(*strPtr)
	return *strPtr != ""
}
func unique(s *[]string) {
	m := make(map[string]bool, len(*s))
	for i := 0; i < len(*s); i++ {
		if !vet(&(*s)[i]) || m[(*s)[i]] {
			*s = append((*s)[:i], (*s)[i+1:]...)
			i--
			continue
		}
		m[(*s)[i]] = true
	}
}

//判断包含列表中 string
func inSlice(ele string, l []string) bool {
	for _, v := range l {
		if v == ele {
			return true
		}
	}
	return false
}
