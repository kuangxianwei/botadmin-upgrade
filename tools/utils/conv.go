package utils

import (
	"fmt"
	"strconv"
	"unicode"
)

// GetString convert interface to string.
func GetString(v interface{}) string {
	switch result := v.(type) {
	case string:
		return result
	case []byte:
		return string(result)
	default:
		return fmt.Sprint(result)
	}
}

// GetInt convert interface to int.
func GetInt(v interface{}) int {
	switch result := v.(type) {
	case int:
		return result
	case int32:
		return int(result)
	case int64:
		return int(result)
	default:
		if d := GetString(v); d != "" {
			value, _ := strconv.Atoi(d)
			return value
		}
	}
	return 0
}

// GetInt64 convert interface to int64.
func GetInt64(v interface{}) int64 {
	switch result := v.(type) {
	case int:
		return int64(result)
	case int32:
		return int64(result)
	case int64:
		return result
	default:
		if d := GetString(v); d != "" {
			value, _ := strconv.ParseInt(d, 10, 64)
			return value
		}
	}
	return 0
}

// GetFloat64 convert interface to float64.
func GetFloat64(v interface{}) float64 {
	switch result := v.(type) {
	case float64:
		return result
	default:
		if d := GetString(v); d != "" {
			value, _ := strconv.ParseFloat(d, 64)
			return value
		}
	}
	return 0
}

// GetBool convert interface to bool.
func GetBool(v interface{}) bool {
	switch result := v.(type) {
	case bool:
		return result
	default:
		if d := GetString(v); d != "" {
			value, _ := strconv.ParseBool(d)
			return value
		}
	}
	return false
}

func GetUint(v interface{}) uint {
	return uint(GetInt(v))
}

//删除里面的空格 \n\f\t 参数 n 为保留个数
func TrimSpace(s string, n int) string {
	return string(TrimSpaceRunes([]rune(s), n))
}

//删除里面的空格 \n\f\t 参数 n 为保留个数
func TrimSpaceRunes(rs []rune, n int) []rune {
	var spaceN int
	for i := 0; i < len(rs); i++ {
		if !unicode.IsSpace(rs[i]) {
			spaceN = 0
			continue
		}
		spaceN++
		if spaceN > n {
			rs = append(rs[0:i], rs[i+1:]...)
			i--
		}
	}
	return rs
}

//删除标签 <> seek 为到为止:[0:seek]
func TrimLabel(s string, seek int) string {
	return string(TrimLabelRunes(s, seek))
}

//删除标签 <> seek 为到为止:[0:seek]
func TrimLabelRunes(s string, seek int) []rune {
	if seek == 1 {
		return []rune{}
	}
	runes := []rune(s)
	if seek < 0 {
		seek = len(runes)
	}
	start, end := -1, -1
	for i := 0; i < len(runes); i++ {
		c := runes[i]
		if c == 60 {
			start = i
		} else if c == 62 {
			end = i
		}
		if start > -1 && end > 0 && start < end {
			runes = append(runes[0:start], runes[end+1:]...)
			i -= end - start
			i--
			start, end = -1, -1
		}
		if i >= seek {
			if i > len(runes) {
				i = len(runes)
			}
			return runes[0:i]
		}
	}
	return runes
}
