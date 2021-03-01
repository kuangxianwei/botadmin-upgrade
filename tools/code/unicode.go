package code

import (
	"regexp"
	"strconv"
)

var unicodeRe = regexp.MustCompile(`\\[uU][a-zA-Z0-9]{2,4}`)

//解码Unicode
func DeUnicode(src string) string {
	return unicodeRe.ReplaceAllStringFunc(src, func(s string) string {
		if i64, err := strconv.ParseInt(s[2:], 16, 32); err == nil {
			return strconv.FormatInt(i64, 10)
		}
		return s
	})
}

//编码Unicode
func EnUnicode(src string) string {
	rs := []rune(src)
	tmpRs := make([]rune, 0, len(rs)*2)
	for _, r := range rs {
		if r < 128 {
			tmpRs = append(tmpRs, r)
		} else {
			tmpRs = append(tmpRs, []rune("\\u"+strconv.FormatInt(int64(r), 16))...)
		}
	}
	return string(tmpRs)
}
