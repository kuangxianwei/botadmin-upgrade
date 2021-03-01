package base_t

import (
	"botadmin/tools/city"
	"botadmin/tools/utils"
	"reflect"
	"strings"
	"unicode"
)

//网站配置信息
type SiteConfig struct {
	Title       string   `json:"title" form:"title"`               //标题
	TitleSuffix string   `json:"title_suffix" form:"title_suffix"` //标题后缀
	Keywords    []string `json:"keywords" form:"keywords"`         //关键词列表
	Description string   `json:"description" form:"description"`   //描述
	About       string   `json:"about" form:"about"`               //关于我们
	City        string   `json:"city" form:"city"`                 //城市
	Province    string   `json:"province" form:"province"`         //省份
	Contact     []string `json:"contact" form:"contact"`           //联系方式
	Ad          string   `json:"ad" form:"ad"`                     //广告
}

//填充数据
func (c *SiteConfig) Fill() {
	if c.City != "" && c.Province == "" {
		if province, ok := city.Map[c.City]; ok {
			c.Province = province.Province
		}
	}
}

//循环赋值
func (c *SiteConfig) loopDo(objT reflect.Type, objV reflect.Value, m map[string]bool) {
	if !objV.IsValid() {
		return
	}
	for i := 0; i < objT.NumField(); i++ {
		fieldV := objV.Field(i)
		if !fieldV.CanSet() {
			continue
		}
		fieldT := objT.Field(i)
		kind := fieldT.Type.Kind()
		if fieldT.Anonymous && kind == reflect.Struct {
			c.loopDo(fieldT.Type, fieldV, m)
			continue
		}
		if !fieldV.CanInterface() {
			continue
		}
		tName := utils.ConvertU(fieldT.Name)
		switch fieldV.Interface().(type) {
		case string:
			switch fieldT.Name {
			case "Title":
				m[tName] = true
				fieldV.SetString(c.Title)
			case "Description":
				m[tName] = true
				fieldV.SetString(c.Description)
			case "About":
				m[tName] = true
				fieldV.SetString(c.About)
			case "City":
				m[tName] = true
				fieldV.SetString(c.City)
			case "Province":
				m[tName] = true
				fieldV.SetString(c.Province)
			case "Ad":
				m[tName] = true
				fieldV.SetString(c.Ad)
			case "TitleSuffix":
				m[tName] = true
				fieldV.SetString(c.TitleSuffix)
			}
		case []string:
			switch fieldT.Name {
			case "Keywords":
				m[tName] = true
				fieldV.Set(reflect.ValueOf(c.Keywords))
			case "Contact":
				m[tName] = true
				fieldV.Set(reflect.ValueOf(c.Contact))
			}
		}
	}
}

//赋值到
func (c *SiteConfig) AssignObj(structPtr interface{}) ([]string, error) {
	objT, objV, err := utils.GetPtrTypeValue(structPtr)
	if err != nil {
		return nil, err
	}
	m := make(map[string]bool, objT.NumField())
	c.loopDo(objT, objV, m)
	names := make([]string, 0, len(m))
	for k := range m {
		names = append(names, k)
	}
	return names, nil
}

//赋值
func (c *SiteConfig) Assign(k, v string) {
	switch k {
	case "title":
		c.Title = v
	case "keywords":
		c.Keywords = strings.FieldsFunc(v, unicode.IsPunct)
	case "description":
		c.Description = v
	case "title_suffix":
		c.TitleSuffix = v
	case "city":
		c.City = v
	case "province":
		c.Province = v
	case "about":
		c.About = v
	case "ad":
		c.Ad = v
	case "contact":
		c.Contact = strings.Split(v, "\n")
	}
}
