package utils

import (
	"bytes"
	"fmt"
	"golang.org/x/net/html/charset"
	"golang.org/x/text/encoding"
	"golang.org/x/text/encoding/simplifiedchinese"
	"reflect"
	"unicode"
	"unicode/utf8"
)

//判断是结构体
func IsStruct(t reflect.Type) bool {
	k := t.Kind()
	return (k == reflect.Ptr && t.Elem().Kind() == reflect.Struct) || (k == reflect.Struct)
}

//判断是结构体指针
func IsStructPtr(t reflect.Type) bool {
	return t.Kind() == reflect.Ptr && t.Elem().Kind() == reflect.Struct
}

//获取结构体的tag
func GetTag(fieldT reflect.StructField, tagName string) string {
	var tag string
	var ok bool
	if tag, ok = fieldT.Tag.Lookup(tagName); !ok {
		return ConvertU(fieldT.Name)
	}
	if tag == "" {
		return "-"
	}
	return tag
}

//反射获取type 和 value
func GetTypeValue(obj interface{}) (objT reflect.Type, objV reflect.Value, err error) {
	objT = reflect.TypeOf(obj)
	objV = reflect.ValueOf(obj)
	switch kind := objT.Kind(); {
	case kind == reflect.Ptr && objT.Elem().Kind() == reflect.Struct:
		objT = objT.Elem()
		objV = objV.Elem()
	case kind == reflect.Struct:
	default:
		return objT, objV, fmt.Errorf("%v must be  a struct or struct pointer", obj)
	}
	if !objV.IsValid() {
		return objT, objV, fmt.Errorf("%v 为 0 值", objV)
	}
	return objT, objV, nil
}

//反射获取 指针类型的type 和 value
func GetPtrTypeValue(obj interface{}) (objT reflect.Type, objV reflect.Value, err error) {
	objT = reflect.TypeOf(obj)
	objV = reflect.ValueOf(obj)
	if !IsStructPtr(objT) {
		return objT, objV, fmt.Errorf("%v must be a struct pointer", obj)
	}
	objT = objT.Elem()
	objV = objV.Elem()
	if !objV.IsValid() {
		return objT, objV, fmt.Errorf("%v 为 0 值", objV)
	}
	return objT, objV, nil
}

//field转为map
func doFieldToMap(data map[string]interface{}, objT reflect.Type, objV reflect.Value) {
	if !objV.IsValid() {
		return
	}
	for i := 0; i < objT.NumField(); i++ {
		fieldV := objV.Field(i)
		fieldT := objT.Field(i)
		if fieldT.Anonymous && fieldT.Type.Kind() == reflect.Struct {
			doFieldToMap(data, fieldT.Type, fieldV)
			continue
		}
		if !fieldV.CanInterface() {
			continue
		}
		var tag string
		if tag = GetTag(fieldT, "json"); tag == "-" {
			continue
		}
		if IsStruct(fieldT.Type) {
			data[tag] = StructToMap(fieldV.Interface())
			continue
		}
		data[tag] = fieldV.Interface()
	}
}

//struct转map
func StructToMap(obj interface{}) map[string]interface{} {
	data := make(map[string]interface{})
	if objT, objV, err := GetTypeValue(obj); err == nil {
		doFieldToMap(data, objT, objV)
	}
	return data
}

//执行递归获取tag
func doTagsFields(objT reflect.Type, objV reflect.Value, tag string) (tags []string) {
	if !objV.IsValid() {
		return tags
	}
	for i := 0; i < objT.NumField(); i++ {
		fieldT := objT.Field(i)
		fieldV := objV.Field(i)
		kind := fieldT.Type.Kind()
		if fieldT.Anonymous && kind == reflect.Struct {
			tags = append(tags, doTagsFields(fieldT.Type, fieldV, tag)...)
			continue
		}
		var val string
		if val = GetTag(fieldT, tag); val == "-" {
			continue
		}
		tags = append(tags, val)
	}
	return tags
}

// 判断是否是字母
func IsLetter(r rune) bool {
	return (r >= 'a' && r <= 'z') || (r >= 'A' && r <= 'Z')
}

//大写改小写下划线
func ConvertU(name string) string {
	var rs = []rune(name)
	count := len(rs)
	if count == 0 {
		return ""
	}
	isInsert := func(i int, r rune) bool {
		if r == '_' || rs[i] == '_' {
			return false
		}
		if i >= count-2 {
			return false
		}
		return (!IsLetter(rs[i]) && IsLetter(r)) || (unicode.IsLower(rs[i]) && unicode.IsUpper(r)) || (IsLetter(rs[i]) && !IsLetter(r)) || (unicode.IsUpper(r) && unicode.IsLower(rs[i+2]))
	}
	buf := new(bytes.Buffer)
	buf.Grow(len(rs)*2 + utf8.UTFMax)
	buf.WriteRune(unicode.ToLower(rs[0]))
	for i, r := range rs[1:] {
		if isInsert(i, r) {
			buf.WriteRune('_')
		}
		buf.WriteRune(unicode.ToLower(r))
	}
	return buf.String()
}

//go判断字符串是否是utf-8
func preNUm(data byte) int {
	var mask byte = 0x80
	var num = 0
	//8bit中首个0bit前有多少个1bits
	for i := 0; i < 8; i++ {
		if (data & mask) == mask {
			num++
			mask = mask >> 1
		} else {
			break
		}
	}
	return num
}

//go判断字符串是否是utf-8
func IsUtf8(data []byte) bool {
	i := 0
	for i < len(data) {
		if (data[i] & 0x80) == 0x00 {
			// 0XXX_XXXX
			i++
			continue
		} else if num := preNUm(data[i]); num > 2 {
			// 110X_XXXX 10XX_XXXX
			// 1110_XXXX 10XX_XXXX 10XX_XXXX
			// 1111_0XXX 10XX_XXXX 10XX_XXXX 10XX_XXXX
			// 1111_10XX 10XX_XXXX 10XX_XXXX 10XX_XXXX 10XX_XXXX
			// 1111_110X 10XX_XXXX 10XX_XXXX 10XX_XXXX 10XX_XXXX 10XX_XXXX
			// preNUm() 返回首个字节的8个bits中首个0bit前面1bit的个数，该数量也是该字符所使用的字节数
			i++
			for j := 0; j < num-1; j++ {
				//判断后面的 num - 1 个字节是不是都是10开头
				if (data[i] & 0xc0) != 0x80 {
					return false
				}
				i++
			}
		} else {
			//其他情况说明不是utf-8
			return false
		}
	}
	return true
}

//go判断字符串是否是GBK
func IsGBK(data []byte) bool {
	length := len(data)
	var i = 0
	for i < length {
		if data[i] <= 0x7f {
			//编码0~127,只有一个字节的编码，兼容ASCII码
			i++
			continue
		} else {
			//大于127的使用双字节编码，落在gbk编码范围内的字符
			if data[i] >= 0x81 &&
				data[i] <= 0xfe &&
				data[i+1] >= 0x40 &&
				data[i+1] <= 0xfe &&
				data[i+1] != 0xf7 {
				i += 2
				continue
			} else {
				return false
			}
		}
	}
	return true
}

func EnUTF8(data []byte) []byte {
	if IsUtf8(data) {
		return data
	}
	if data, err := simplifiedchinese.GBK.NewDecoder().Bytes(data); err == nil {
		return data
	}
	return data
}

/*判断编码*/
func GetEncoding(b []byte) encoding.Encoding {
	e, _, _ := charset.DetermineEncoding(b, "")
	return e
}

//解码 GBK
func DecoderGB2312(b []byte) ([]byte, error) {
	return simplifiedchinese.HZGB2312.NewDecoder().Bytes(b)
}

//编码 GBK
func EncoderGB2312(b []byte) ([]byte, error) {
	return simplifiedchinese.HZGB2312.NewEncoder().Bytes(b)
}

//解码 GBK
func DecoderGBK(b []byte) ([]byte, error) {
	return simplifiedchinese.GBK.NewDecoder().Bytes(b)
}

//编码 GBK
func EncoderGBK(b []byte) ([]byte, error) {
	return simplifiedchinese.GBK.NewEncoder().Bytes(b)
}

//解码 GB18030
func DecoderGB18030(b []byte) ([]byte, error) {
	return simplifiedchinese.GB18030.NewDecoder().Bytes(b)
}

//编码 GB18030
func EncoderGB18030(b []byte) ([]byte, error) {
	return simplifiedchinese.GB18030.NewEncoder().Bytes(b)
}

//自动识别编码
func decoderAuto(b []byte) []byte {
	e, _, _ := charset.DetermineEncoding(b, "")
	if bs, err := e.NewDecoder().Bytes(b); err == nil {
		return bs
	}
	return b
}

//指定编码
func EncoderUTF8(b []byte, charsetName string) []byte {
	if charsetName == "" {
		return decoderAuto(b)
	}
	u, name := charset.Lookup(charsetName)
	switch name {
	case "gb18030", "gbk":
		if bs, err := u.NewDecoder().Bytes(b); err != nil {
			return b
		} else {
			return bs
		}
	case "utf-8":
		return b
	default:
		return decoderAuto(b)
	}
}
