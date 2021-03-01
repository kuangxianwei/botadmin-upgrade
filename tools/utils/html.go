package utils

import (
	"reflect"
	"strconv"
	"strings"
	"unicode"
)

const (
	HtmlTagName = "html"
	HtmlLabel   = "label"
	HtmlName    = "name"
	HtmlType    = "type"
	HtmlVet     = "vet"
	HtmlNote    = "note"
	HtmlTip     = "tip"
	HtmlAlias   = "alias"
	HtmlOpts    = "opts" //提供选项
)

//构造每个字段是formHTML标签
type buildFormItem struct {
	buf       *strings.Builder
	fieldName string //字段名称
	label     string //标签名称 input|textarea|select
	name      string //表单的name 名称
	value     string //表单的value 值
	opts      string //提供可选
	alias     string //别名 提示名称
	note      string //备注
	tip       string //提示 类似于备注
	vet       string //验证审查 名称 required lay-verify="required"
	typ       string //表单类型 text:普通字符串输入 checkbox:开关 hidden:隐藏 password:密码 radio:单选按钮 button:按钮 reset:重置
}

//初始化
func (i *buildFormItem) init(rawTag string) {
	tags := strings.Split(rawTag, ",")
	UniqueSliceStr(&tags, nil)
	tagMap := make(map[string]string, len(tags))
	for _, v := range tags {
		if kv := strings.SplitN(v, "=", 2); len(kv) == 2 {
			key := strings.ToLower(strings.TrimSpace(kv[0]))
			tagMap[key] = strings.TrimSpace(kv[1])
		}
	}
	var ok bool
	//标签名称 input textarea select
	if i.label, ok = tagMap[HtmlLabel]; !ok {
		i.label = "input"
	}

	//form表单 name
	if i.name, ok = tagMap[HtmlName]; !ok {
		i.name = ConvertU(i.fieldName)
	}
	//别名
	if i.alias, ok = tagMap[HtmlAlias]; !ok {
		i.alias = i.fieldName
	}
	//类型
	if i.typ, ok = tagMap[HtmlType]; !ok {
		i.typ = "text"
	}
	//验证 required
	i.vet = tagMap[HtmlVet]
	//备注说明
	i.note = tagMap[HtmlNote]
	//提示 lay-tips="提示"
	i.tip = tagMap[HtmlTip]
	//单选框 html:"type=radio,radio=prod->正常|dev->调试"
	i.opts = tagMap[HtmlOpts]
}

//每个开始item 必须的
func (i *buildFormItem) start() {
	i.buf.WriteString("<!--")
	i.buf.WriteString(i.fieldName)
	i.buf.WriteString("-start-->")
}

//每个item结束 必须的
func (i *buildFormItem) end() {
	i.buf.WriteString("<!--")
	i.buf.WriteString(i.fieldName)
	i.buf.WriteString("-end-->")
}

//如果是 label=hidden 就写这种
func (i *buildFormItem) hidden() {
	i.start()
	i.buf.WriteString("<input type=\"hidden\" name=\"")
	i.buf.WriteString(i.name)
	i.buf.WriteString("\" value=\"")
	i.buf.WriteString(i.value)
	i.buf.WriteString("\">")
	i.end()
}

//表单前div
func (i *buildFormItem) writeDiv() {
	className := "layui-input-block"
	if len(i.note) > 0 {
		className = "layui-input-inline"
	}
	i.buf.WriteString("<div class=\"")
	i.buf.WriteString(className)
	if len(i.tip) > 0 {
		i.buf.WriteString("\" lay-tips=\"")
		i.buf.WriteString(i.tip)
	}
	if i.label == "slide" {
		i.buf.WriteString("\" style=\"margin-top:18px;\">")
	} else {
		i.buf.WriteString("\">")
	}
}

//表单开始
func (i *buildFormItem) itemBegin() {
	i.start()
	i.buf.WriteString("<div class=\"layui-form-item\">")
	i.buf.WriteString("<label class=\"layui-form-label\">")
	i.buf.WriteString(i.alias)
	i.buf.WriteString(":</label>")
	i.writeDiv()
}

//表单结束
func (i *buildFormItem) itemEnd() {
	i.buf.WriteString("</div>")
	if len(i.note) > 0 {
		i.buf.WriteString("<div class=\"layui-form-mid layui-word-aux\">")
		i.buf.WriteString(i.note)
		i.buf.WriteString("</div>")
	}
	i.buf.WriteString("</div>")
	i.end()
}

//滑块
func (i *buildFormItem) slide() {
	i.itemBegin()
	i.buf.WriteString("<div id=\"")
	i.buf.WriteString(i.name)
	i.buf.WriteString("\"></div>")
	i.buf.WriteString("<input type=\"hidden\" name=\"")
	i.buf.WriteString(i.name)
	i.buf.WriteString("\" value=\"")
	i.buf.WriteString(i.value)
	i.buf.WriteString("\">")
	i.itemEnd()
}

//执行操作
func (i *buildFormItem) do() {
	switch i.label {
	case "slide":
		i.slide()
	case "input":
		switch i.typ {
		case "hidden":
			i.hidden()
		case "checkbox":
			i.itemBegin()
			i.buf.WriteString("<input type=\"checkbox\" name=\"")
			i.buf.WriteString(i.name)
			i.buf.WriteString("\" lay-skin=\"switch\" lay-text=\"打开|关闭\"")
			if i.value == "true" {
				i.buf.WriteString(" checked>")
			} else {
				i.buf.WriteString(">")
			}
			i.itemEnd()
		case "text":
			i.itemBegin()
			i.buf.WriteString("<input type=\"text\" name=\"")
			i.buf.WriteString(i.name)
			i.buf.WriteString("\" value=\"")
			i.buf.WriteString(i.value)
			i.buf.WriteString("\" class=\"layui-input\"")
			if len(i.vet) > 0 {
				i.buf.WriteString(" required lay-verify=\"")
				i.buf.WriteString(i.vet)
				i.buf.WriteString("\">")
			} else {
				i.buf.WriteString(">")
			}
			i.itemEnd()
		case "password":
			i.itemBegin()
			i.buf.WriteString("<input type=\"password\" name=\"")
			i.buf.WriteString(i.name)
			i.buf.WriteString("\" value=\"")
			i.buf.WriteString(i.value)
			i.buf.WriteString("\" class=\"layui-input\"")
			if len(i.vet) > 0 {
				i.buf.WriteString(" required lay-verify=\"")
				i.buf.WriteString(i.vet)
				i.buf.WriteString("\">")
			} else {
				i.buf.WriteString(">")
			}
			i.itemEnd()
		case "radio":
			i.itemBegin()
			if len(i.opts) > 0 {
				radios := strings.Split(i.opts, "|")
				for _, v := range radios {
					vt := strings.SplitN(v, "->", 2)
					switch len(vt) {
					case 1:
						i.buf.WriteString("<input type=\"radio\" name=\"")
						i.buf.WriteString(i.name)
						i.buf.WriteString("\" value=\"")
						i.buf.WriteString(vt[0])
						i.buf.WriteString("\" title=\"")
						i.buf.WriteString(vt[0])
						if i.value == vt[0] {
							i.buf.WriteString("\" checked>")
						} else {
							i.buf.WriteString("\">")
						}
					case 2:
						if len(vt[1]) == 0 {
							vt[1] = vt[0]
						}
						i.buf.WriteString("<input type=\"radio\" name=\"")
						i.buf.WriteString(i.name)
						i.buf.WriteString("\" value=\"")
						i.buf.WriteString(vt[0])
						i.buf.WriteString("\" title=\"")
						i.buf.WriteString(vt[1])
						if i.value == vt[0] {
							i.buf.WriteString("\" checked>")
						} else {
							i.buf.WriteString("\">")
						}
					}
				}
			} else {
				i.buf.WriteString("<!--" + i.fieldName + "-radio-->")
			}
			i.itemEnd()
		}
	case "select":
		i.itemBegin()
		if len(i.opts) > 0 {
			radios := strings.Split(i.opts, "|")
			i.buf.WriteString("<select name=\"")
			i.buf.WriteString(i.name)
			i.buf.WriteString("\" class=\"layui-select\">")
			for _, v := range radios {
				vt := strings.SplitN(v, "->", 2)
				switch len(vt) {
				case 1:
					i.buf.WriteString("<option value=\"")
					i.buf.WriteString(vt[0])
					if i.value == vt[0] {
						i.buf.WriteString("\" selected>")
					} else {
						i.buf.WriteString("\">")
					}
					i.buf.WriteString(vt[0])
					i.buf.WriteString("</option>")
				case 2:
					if len(vt[1]) == 0 {
						vt[1] = vt[0]
					}
					i.buf.WriteString("<option value=\"")
					i.buf.WriteString(vt[0])
					if i.value == vt[0] {
						i.buf.WriteString("\" selected>")
					} else {
						i.buf.WriteString("\">")
					}
					i.buf.WriteString(vt[1])
					i.buf.WriteString("</option>")
				}
			}
			i.buf.WriteString("</select>")
		} else {
			i.buf.WriteString("<!--" + i.fieldName + "-select-->")
		}
		i.itemEnd()
	case "textarea":
		i.itemBegin()
		i.buf.WriteString("<textarea name=\"")
		i.buf.WriteString(i.name)
		i.buf.WriteString("\" class=\"layui-textarea\">")
		i.buf.WriteString(i.value)
		i.buf.WriteString("</textarea>")
		i.itemEnd()
	default:
		i.itemBegin()
		i.buf.WriteString("<!--" + i.fieldName + "-->")
		i.itemEnd()
	}
}

//新建
func newBuildFormItem(buf *strings.Builder, rawTag, fieldName string) *buildFormItem {
	obj := &buildFormItem{buf: buf, fieldName: fieldName}
	obj.init(rawTag)
	return obj
}

//把结构体转为HTML表单输出
func toForm(buf *strings.Builder, objT reflect.Type, objV reflect.Value) {
	if !objV.IsValid() {
		return
	}
	buf.Grow(objT.NumField() * 250)
	for i := 0; i < objT.NumField(); i++ {
		fieldV := objV.Field(i)
		fieldT := objT.Field(i)
		kind := fieldT.Type.Kind()
		if fieldT.Anonymous && kind == reflect.Struct {
			toForm(buf, fieldT.Type, fieldV)
			continue
		}
		if !fieldV.CanInterface() {
			continue
		}
		rawTag := fieldT.Tag.Get(HtmlTagName)
		if rawTag == "-" {
			continue
		}
		obj := newBuildFormItem(buf, rawTag, fieldT.Name)
		val := fieldV.Interface()
		switch kind {
		case reflect.String:
			obj.value = val.(string)
			obj.do()
		case reflect.Int:
			obj.value = strconv.Itoa(val.(int))
			obj.do()
		case reflect.Int64:
			obj.value = strconv.FormatInt(val.(int64), 10)
			obj.do()
		case reflect.Float64:
			obj.value = strconv.FormatFloat(val.(float64), 'f', 2, 64)
			obj.do()
		case reflect.Bool:
			if val.(bool) {
				obj.value = "true"
			} else {
				obj.value = "false"
			}
			obj.typ = "checkbox"
			obj.do()
		case reflect.Slice:
			sep := fieldT.Tag.Get("sep")
			if sep == "\n" {
				obj.label = "textarea"
			}
			switch vs := val.(type) {
			case []string:
				obj.value = strings.Join(vs, sep)
				obj.do()
			case []int:
				ls := make([]string, len(vs))
				for i, v := range vs {
					ls[i] = strconv.Itoa(v)
				}
				obj.value = strings.Join(ls, sep)
				obj.do()
			case []int64:
				ls := make([]string, len(vs))
				for i, v := range vs {
					ls[i] = strconv.FormatInt(v, 10)
				}
				obj.value = strings.Join(ls, sep)
				obj.do()
			}
		}
	}
}

//把结构体转为HTML表单输出
/*
tag 设置
tag名称 html
字段：
	label [input,slide,hidden,select,textarea]
	type [text, checkbox, radio, reset, button, password]
	vet [required ... //验证审查
	note [对这个字段的说明
	alias //标题
提示:
	html:"tip=这个标签的作用是xxx"
表现形式
	html:"label=slide,type=text,vet=required,note=说明,alias=标题"
单选框表现
	html:"type=radio,opts=prod->正常|dev->调试"
	如果是value 和title 相同 html:"type=radio,opts=prod|dev"
	opts 用于 radio select 供给选择的数据
下拉框表现
	html:"label=select,opts=prod->正常|dev->调试"
*/
func ToForm(o interface{}) (string, error) {
	objT, objV, err := GetTypeValue(o)
	if err != nil {
		return "", err
	}
	var buf strings.Builder
	toForm(&buf, objT, objV)
	return buf.String(), nil
}

type KeyVal struct {
	Key, Val string
}

//构造select html
func BuildSelectHtml(name string, opts []KeyVal, def string) string {
	isGt10 := len(opts) > 10
	n := 66
	if isGt10 {
		n = 80
	}
	n += len(name)
	for _, v := range opts {
		n += len(v.Key) + len(v.Val) + 26
	}
	var buf strings.Builder
	buf.Grow(n)
	buf.WriteString("<select name=\"")
	buf.WriteString(name)
	if isGt10 {
		buf.WriteString("\" lay-search>")
		buf.WriteString("<option value=\"\">搜索...</option>")
	} else {
		buf.WriteString("\">")
		buf.WriteString("<option value=\"\">无...</option>")
	}
	for _, v := range opts {
		buf.WriteString("<option value=\"")
		buf.WriteString(v.Key)
		if def == v.Key {
			buf.WriteString("\" selected>")
		} else {
			buf.WriteString("\">")
		}
		buf.WriteString(v.Val)
		buf.WriteString("</option>")
	}
	buf.WriteString("</select>")
	return buf.String()
}

/*获取标签内的索引和rune*/
func LabelIndex(rs []rune, m map[int]rune) map[int]rune {
	var begin bool
	if m == nil {
		m = make(map[int]rune, len(rs))
	}
	tmp := make([]int, 0, 10)
	for index, r := range rs {
		if !begin && r == 60 {
			begin = true
		} else if begin && r == 60 {
			tmp = tmp[0:0]
		} else if begin && r == 62 {
			begin = false
			for _, i := range tmp {
				m[i] = rs[i]
			}
			tmp = tmp[0:0]
		} else if begin {
			tmp = append(tmp, index)
		}
	}
	return m
}

//判断是链接开始部分 <a>
func isaBegin(is []int, rs []rune) bool {
	return (rs[is[0]] == 97 || rs[is[0]] == 65) && (rs[is[1]] == 32 || rs[is[1]] == 62)
}

//判断是链接结束部分 </a>
func isaEnd(ls []int, rs []rune) bool {
	c := len(ls)
	if c < 4 {
		return false
	}
	l := ls[c-3:]
	return rs[l[0]] == 60 && rs[l[1]] == 47 && (rs[l[2]] == 97 || rs[l[2]] == 65)
}

/*获取标签内的索引和rune*/
func LinkIndex(rs []rune, m map[int]rune) map[int]rune {
	var begin bool
	if m == nil {
		m = make(map[int]rune)
	}
	tmp := make([]int, 0, 100)
	for index, r := range rs {
		if len(tmp) == 2 && !isaBegin(tmp, rs) {
			tmp = tmp[0:0]
			begin = false
		}
		if !begin && r == 60 {
			begin = true
		} else if begin && r == 62 && isaEnd(tmp, rs) {
			begin = false
			for _, i := range tmp {
				m[i] = rs[i]
			}
			tmp = tmp[0:0]
		} else if begin {
			tmp = append(tmp, index)
		}
	}
	return m
}

//排除的索引
func ExcludeIndex(rs []rune) map[int]rune {
	m := make(map[int]rune)
	LinkIndex(rs, m)
	LabelIndex(rs, m)
	return m
}

var (
	//在此字符前面插入tag
	prefixMap = map[rune]bool{
		24050: true, //已
		22312: true, //在
		26159: true, //是
		20449: true, //信
		34892: true, //行
	}
	//在此字符后面插入tag
	suffixMap = map[rune]bool{
		30340: true, //的
		27604: true, //比
		20570: true, //做
		20869: true, //内
	}
)

//随机插入关键词
func InsertRune(src, elem []rune, n int) []rune {
	if len(src) == 0 || len(elem) == 0 || n == 0 {
		return src
	}
	elemLen := len(elem)
	/*获取全部排除索引*/
	var excludeMap = ExcludeIndex(src)
	var indexes = make([]int, 0, len(src))
	//获取标点符号索引
	for i, v := range src {
		if unicode.IsPunct(v) {
			indexes = append(indexes, i)
		}
	}
	//获取自定义索引
	rsLen := len(src)
	for i, v := range src {
		if _, ok := prefixMap[v]; ok {
			indexes = append(indexes, i)
		} else if _, ok := suffixMap[v]; ok {
			indexes = append(indexes, i)
		} else if v == 60 && i+1 < rsLen && src[i+1] == 47 {
			indexes = append(indexes, i)
		}
	}
	//清除包含在标签内的索引
	for i := 0; i < len(indexes); i++ {
		if _, ok := excludeMap[indexes[i]]; ok {
			indexes = append(indexes[:i], indexes[i+1:]...)
			i--
		}
	}
	//开始插入
	for len(indexes) > 0 && n > 0 {
		n--
		index := ChoiceInt(indexes)
		for i := 0; i < len(indexes); i++ {
			if indexes[i] == index {
				indexes = append(indexes[:i], indexes[i+1:]...)
				i--
			} else if indexes[i] > index {
				indexes[i] += elemLen
			}
		}
		if _, ok := suffixMap[src[index]]; ok {
			index += 1
		}
		src = append(src[:index], append(elem, src[index:]...)...)
	}
	if n == 0 {
		return src
	}
	excludeMap = ExcludeIndex(src)
	indexes = make([]int, 0, len(src))
	for i := range src {
		if _, ok := excludeMap[i]; !ok {
			indexes = append(indexes, i)
		}
	}
	for i := 0; i < 100; i++ {
		if n < 1 {
			break
		}
		index := ChoiceInt(indexes)
		if src[index] == 60 || src[index] == 62 {
			continue
		}
		n--
		for i := 0; i < len(indexes); i++ {
			if indexes[i] == index {
				indexes = append(indexes[:i], indexes[i+1:]...)
				i--
			} else if indexes[i] > index {
				indexes[i] += elemLen
			}
		}
		src = append(src[:index], append(elem, src[index:]...)...)
	}
	return src
}

//随机插入字符串
func InsertString(src, elem string, n int) string {
	return string(InsertRune([]rune(src), []rune(elem), n))
}
