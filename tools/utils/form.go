package utils

import (
	"net/url"
	"reflect"
	"strconv"
	"strings"
	"time"
)

const (
	formatTime      = "15:04:05"
	formatDate      = "2006-01-02"
	formatDateTime  = "2006-01-02 15:04:05"
	formatDateTimeT = "2006-01-02T15:04:05"
)

/*
每一个结构体中优先使用:
//form 转换接口
type FormParser interface {
	//解析表单信息到结构体
	ParseForm(form url.Values) error
}
其次为:
type ConvBytes interface {
	//来自bytes 转为 结构体
	FromBytes([]byte) error
	//结构体转输出为bytes
	ToBytes() ([]byte, error)
}
*/
//表单赋值到结构体
func FormToStruct(form url.Values, objT reflect.Type, objV reflect.Value) (err error) {
	for i := 0; i < objT.NumField(); i++ {
		fieldV := objV.Field(i)
		//判断是否可设置
		if !fieldV.CanSet() {
			continue
		}
		fieldT := objT.Field(i)
		var tag string
		//判断接口类型
		if fieldV.CanAddr() && fieldV.Addr().CanInterface() {
			/*如果满足 接口类型则执行*/
			switch face := fieldV.Addr().Interface().(type) {
			case FormParser:
				//解析表单数据到结构体中
				if tag = GetTag(fieldT, "form"); tag != "-" {
					face.ParseForm(form, tag)
				}
				continue
			case ConvBytes:
				if tag = GetTag(fieldT, "form"); tag != "-" {
					if values := form[tag]; len(values) > 0 {
						if val := strings.TrimSpace(values[0]); val != "" {
							if err := face.FromBytes([]byte(val)); err != nil {
								return err
							}
						}
					}
				}
				continue
			}
		}
		kind := fieldT.Type.Kind()
		if fieldT.Anonymous && kind == reflect.Struct {
			if err = FormToStruct(form, fieldT.Type, fieldV); err != nil {
				return err
			}
			continue
		}
		if tag = GetTag(fieldT, "form"); tag == "-" {
			continue
		}
		values, has := form[tag]
		if !has && kind == reflect.Bool {
			fieldV.SetBool(false)
			continue
		}
		switch kind {
		case reflect.Struct:
			if fieldT.Type.String() != "time.Time" {
				if err = FormToStruct(form, fieldT.Type, fieldV); err != nil {
					return err
				}
				continue
			}
			if len(values) > 0 {
				var (
					t time.Time
				)
				value := strings.TrimSpace(values[0])
				if len(value) >= 25 {
					value = value[:25]
					t, err = time.ParseInLocation(time.RFC3339, value, time.Local)
				} else if strings.HasSuffix(strings.ToUpper(value), "Z") {
					t, err = time.ParseInLocation(time.RFC3339, value, time.Local)
				} else if len(value) >= 19 {
					if strings.Contains(value, "T") {
						value = value[:19]
						t, err = time.ParseInLocation(formatDateTimeT, value, time.Local)
					} else {
						value = value[:19]
						t, err = time.ParseInLocation(formatDateTime, value, time.Local)
					}
				} else if len(value) >= 10 {
					if len(value) > 10 {
						value = value[:10]
					}
					t, err = time.ParseInLocation(formatDate, value, time.Local)
				} else if len(value) >= 8 {
					if len(value) > 8 {
						value = value[:8]
					}
					t, err = time.ParseInLocation(formatTime, value, time.Local)
				}
				if err != nil {
					return err
				}
				fieldV.Set(reflect.ValueOf(t))
			} else {
				fieldV.Set(reflect.ValueOf(time.Time{}))
			}
		case reflect.Bool:
			if len(values) > 0 {
				fieldV.SetBool(ParseBool(strings.TrimSpace(values[0])))
			} else {
				fieldV.SetBool(false)
			}
		case reflect.Int, reflect.Int8, reflect.Int16, reflect.Int32, reflect.Int64:
			if len(values) > 0 {
				x, _ := strconv.ParseInt(strings.TrimSpace(values[0]), 10, 64)
				fieldV.SetInt(x)
			}
		case reflect.Uint, reflect.Uint8, reflect.Uint16, reflect.Uint32, reflect.Uint64:
			if len(values) > 0 {
				x, _ := strconv.ParseUint(strings.TrimSpace(values[0]), 10, 64)
				fieldV.SetUint(x)
			}
		case reflect.Float32, reflect.Float64:
			if len(values) > 0 {
				x, _ := strconv.ParseFloat(strings.TrimSpace(values[0]), 64)
				fieldV.SetFloat(x)
			}
		case reflect.String:
			if len(values) > 0 {
				fieldV.SetString(strings.TrimSpace(values[0]))
			}
		case reflect.Slice:
			if !has || !fieldV.CanInterface() {
				continue
			}
			sep := fieldT.Tag.Get("sep")
			if len(values) > 0 && len(sep) > 0 {
				values = strings.Split(values[0], sep)
			}
			switch fieldT.Type.Elem().Kind() {
			case reflect.String:
				if len(values) == 1 && len(values[0]) == 0 {
					fieldV.Set(reflect.ValueOf([]string{}))
				} else {
					fieldV.Set(reflect.ValueOf(values))
				}
			case reflect.Int:
				intS := StringsToInt(values)
				UniqueSliceInt(&intS, nil)
				fieldV.Set(reflect.ValueOf(intS))
			case reflect.Int64:
				i64s := StringsToInt64(values)
				UniqueSliceI64(&i64s, nil)
				fieldV.Set(reflect.ValueOf(i64s))
			}
		case reflect.Interface:
			if len(values) > 0 {
				fieldV.Set(reflect.ValueOf(values[0]))
			}
		}
	}
	return nil
}

// 字符串列表转int列表
func StringsToInt(ls []string) []int {
	is := make([]int, 0, len(ls))
	for _, v := range ls {
		if i, e := strconv.Atoi(v); e == nil {
			is = append(is, i)
		}
	}
	return is
}

func StringsToInt64(ls []string) []int64 {
	i64s := make([]int64, 0, len(ls))
	for _, v := range ls {
		if i64, err := strconv.ParseInt(v, 10, 64); err == nil {
			i64s = append(i64s, i64)
		}
	}
	return i64s
}

//解析表单值到结构体
func ParseForm(form url.Values, objPtr interface{}) (err error) {
	if len(form) == 0 {
		return nil
	}
	var objT reflect.Type
	var objV reflect.Value
	if objT, objV, err = GetPtrTypeValue(objPtr); err != nil {
		return err
	}
	if err = FormToStruct(form, objT, objV); err != nil {
		return err
	}
	if structField, has := objT.FieldByName("Cols"); has && structField.Type.Kind() == reflect.Slice {
		if fieldV := objV.FieldByName("Cols"); fieldV.CanAddr() && fieldV.Addr().CanInterface() {
			if cols, ok := fieldV.Interface().([]string); ok && len(cols) == 0 {
				cols = make([]string, 0, len(form))
				for name := range form {
					cols = append(cols, name)
				}
				fieldV.Set(reflect.ValueOf(cols))
			}
		}
	}
	return nil
}

type (
	//bytes 转换接口
	ConvBytes interface {
		// 来自bytes 转为 结构体
		FromBytes([]byte) error
		// 结构体转输出为bytes
		ToBytes() ([]byte, error)
	}
	// 解析表单
	FormParser interface {
		//解析表单信息到结构体
		ParseForm(form url.Values, prefix string)
	}
)
