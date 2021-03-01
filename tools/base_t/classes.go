package base_t

import (
	"botadmin/tools/pinyin"
	"encoding/json"
	"errors"
	"log"
	"math/rand"
	"net/url"
	"strings"
	"time"
)

//网站栏目
type Class struct {
	Id          int64             `json:"id"`          //栏目ID
	TopId       int64             `json:"top_id"`      //上级ID
	TopName     string            `json:"top_name"`    //栏目名称
	Name        string            `json:"name"`        //栏目名称
	Path        string            `json:"path"`        //栏目路径
	Url         string            `json:"url"`         //栏目url
	Alias       string            `json:"alias"`       //别名
	Keywords    []string          `json:"keywords"`    //关键词
	Description string            `json:"description"` //描述
	Hidden      bool              `json:"hidden"`      // 是否为隐藏 默认为显示
	IsFace      bool              `json:"is_face"`     //是否为不可发布文章的封面列表
	Options     map[string]string `json:"options"`     //可选选项
	Classes     Classes           `json:"classes"`     //子栏目列表
}

//bool 转string true = 1 false 0
func BoolToDigitStr(b bool) string {
	if b {
		return "1"
	}
	return "0"
}

//获取全部名称
func (c *Class) ByName(m map[string]Class) {
	if m != nil && c.Name != "" {
		m[c.Name] = *c
		for i := 0; i < len(c.Classes); i++ {
			c.Classes[i].ByName(m)
		}
	}
}

//获取全部ID
func (c *Class) ById(m map[int64]Class) {
	if m != nil && c.Id > 0 {
		m[c.Id] = *c
		for i := 0; i < len(c.Classes); i++ {
			c.Classes[i].ById(m)
		}
	}
}

//获取全部path
func (c *Class) ByPath(m map[string]Class) {
	if m != nil && c.Path != "" {
		m[c.Path] = *c
		for i := 0; i < len(c.Classes); i++ {
			c.Classes[i].ByPath(m)
		}
	}
}

//获取全部允许发布文章的栏目
func (c *Class) AllowPublish(m map[string]Class) {
	if m != nil {
		if len(c.Classes) > 0 {
			c.IsFace = true
			for _, obj := range c.Classes {
				obj.AllowPublish(m)
			}
		} else if c.IsFace == false && c.Id > 0 {
			m[c.Name] = *c
		}
	}
}

//栏目列表
type Classes []Class

//加载来自数据库的数据到结构体中
func (c *Classes) FromDB(b []byte) error {
	if len(b) == 0 {
		*c = nil
		return nil
	}
	return json.Unmarshal(b, c)
}

//把结构体中的数据转为bytes
func (c *Classes) ToDB() ([]byte, error) {
	return json.Marshal(c)
}

//加载来自表单数据
func (c *Classes) ParseForm(form url.Values, prefix string) {
	if val := strings.TrimSpace(form.Get(prefix)); val != "" {
		if err := json.Unmarshal([]byte(val), c); err != nil {
			log.Println(err.Error())
		}
	}
}

//加载来类型到结构体中
func (c *Classes) FromBytes(b []byte) error {
	if len(b) == 0 {
		*c = nil
		return nil
	}
	return json.Unmarshal(b, c)
}

//把结构体中的数据转为bytes
func (c *Classes) ToBytes() ([]byte, error) {
	return json.Marshal(c)
}

//获取栏目map
func (c *Classes) ByName() map[string]Class {
	m := make(map[string]Class)
	for _, v := range *c {
		v.ByName(m)
	}
	return m
}

//获取栏目map
func (c *Classes) ByPath() map[string]Class {
	m := make(map[string]Class)
	for _, v := range *c {
		v.ByPath(m)
	}
	return m
}

//获取栏目map
func (c *Classes) ById() map[int64]Class {
	m := make(map[int64]Class)
	for _, v := range *c {
		v.ById(m)
	}
	return m
}

//判断名称存在
func (c *Classes) HasName(name string) bool {
	for _, class := range *c {
		if class.Name == name {
			return true
		}
		if len(class.Classes) > 0 {
			if has := class.Classes.HasName(name); has {
				return true
			}
		}
	}
	return false
}

//获取全部允许发布文章的栏目
func (c *Classes) Allow() map[string]Class {
	m := make(map[string]Class)
	for _, v := range *c {
		v.AllowPublish(m)
	}
	return m
}

//获取全部允许发布文章的栏目
func (c *Classes) AllowById() map[int64]Class {
	allow := c.Allow()
	m := make(map[int64]Class, len(allow))
	for _, v := range allow {
		m[v.Id] = v
	}
	return m
}

//指定map 随机选择一个
func (c *Classes) _choice(m map[string]Class) (Class, error) {
	max := len(m)
	if max > 0 && m != nil {
		if max == 1 {
			for _, v := range m {
				return v, nil
			}
		}
		index := rand.New(rand.NewSource(time.Now().UnixNano())).Intn(max)
		var n int
		for _, v := range m {
			if n == index {
				return v, nil
			}
			n++
		}
	}
	return Class{}, errors.New("允许发布文章的栏目为空")
}

//随机选择一个允许发布文章的栏目
func (c *Classes) choice() (Class, error) {
	return c._choice(c.Allow())
}

//匹配标题随机抽取一个
func (c *Classes) Choice(titles ...string) (Class, error) {
	if len(titles) == 0 {
		return c.choice()
	}
	title := titles[0]
	m := c.Allow()
	newMap := make(map[string]Class, len(m))
	for k, v := range m {
		if strings.Contains(title, k) {
			newMap[k] = v
		}
	}
	if len(newMap) > 0 {
		return c._choice(newMap)
	}
	for k, v := range m {
		if strings.ContainsAny(title, v.Name) {
			newMap[k] = v
		}
	}
	if len(newMap) > 0 {
		return c._choice(newMap)
	}
	return c._choice(m)
}

var replacer = strings.NewReplacer("\n\r", "", "\r", "", "\n", "")

//填充数据
func (c *Classes) full(prefix string) {
	pool := make(map[string]bool, len(*c))
	for i := 0; i < len(*c); i++ {
		if (*c)[i].Name == "" || pool[(*c)[i].Name] {
			*c = append((*c)[:i], (*c)[i+1:]...)
			i--
			continue
		}
		pool[(*c)[i].Name] = true
		if (*c)[i].Alias == "" {
			(*c)[i].Alias = (*c)[i].Name
		}
		if (*c)[i].Path == "" {
			var name string
			if len((*c)[i].Name) > 12 {
				name = pinyin.First((*c)[i].Name)
			} else {
				name = pinyin.Fill((*c)[i].Name)
			}
			if prefix != "" {
				(*c)[i].Path = prefix + "/" + name
			} else {
				(*c)[i].Path = name
			}
		}
		(*c)[i].Description = replacer.Replace((*c)[i].Description)
		uniqueSliceStr(&(*c)[i].Keywords)
		if len((*c)[i].Classes) > 0 {
			(*c)[i].IsFace = true
			if prefix == "" {
				(*c)[i].Classes.full((*c)[i].Path)
			} else {
				(*c)[i].Classes.full(prefix + "/" + BaseName((*c)[i].Path))
			}
		}
	}
}

//插入数据
func (c *Classes) Insert(class Class) {
	for i := 0; i < len(*c); i++ {
		if (*c)[i].Name == class.Name {
			(*c)[i] = class
			return
		}
	}
	*c = append(*c, class)
}

//指定父ID插入到子栏目列表
func (c *Classes) InsertSon(id int64, sonClass Class) bool {
	for i := 0; i < len(*c); i++ {
		if (*c)[i].Id == id {
			sonClass.TopName = (*c)[i].Name
			(*c)[i].Classes.Insert(sonClass)
			return true
		}
		if len((*c)[i].Classes) > 0 {
			if has := (*c)[i].Classes.InsertSon(id, sonClass); has {
				return true
			}
		}
	}
	return false
}

//整理栏目数据
func (c *Classes) Tidy() {
	for i := 0; i < len(*c); i++ {
		if (*c)[i].TopId > 0 {
			(*c).InsertSon((*c)[i].TopId, (*c)[i])
		}
	}
	for i := 0; i < len(*c); i++ {
		if (*c)[i].TopId > 0 {
			*c = append((*c)[:i], (*c)[i+1:]...)
			i--
		}
	}
	c.full("")
}

//获取路径的最后名称
func BaseName(s string) string {
	index := -1
	for i, v := range s {
		if v == '/' {
			index = i
		}
	}
	if index == -1 {
		return s
	}
	return s[index+1:]
}

//分割路径 返回 路径部分 和 最后名称部分
func BaseDirName(s string) (string, string) {
	index := -1
	for i, v := range s {
		if v == '/' {
			index = i
		}
	}
	if index == -1 {
		return "", s
	}
	return s[:index+1], s[index+1:]
}

//去除重复字符串
func uniqueSliceStr(s *[]string) {
	exists := make(map[string]bool, len(*s)/2)
	for i := 0; i < len(*s); i++ {
		(*s)[i] = strings.TrimSpace((*s)[i])
		v := (*s)[i]
		if v == "" || exists[v] {
			*s = append((*s)[:i], (*s)[i+1:]...)
			i--
		}
		exists[v] = true
	}
}
