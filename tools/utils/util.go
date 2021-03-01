package utils

import (
	"bufio"
	"bytes"
	"fmt"
	"io/ioutil"
	"net/http"
	"net/url"
	"os/user"
	"regexp"
	"strings"
)

const (
	B float64 = 1 << (iota * 10)
	KB
	MB
	GB
	TB
)
const (
	DomainSuffix   = `\b(?:[a-z]{1,4}\.cn|cn|com|net|cc|ph|info|org|hk|top|asia|biz|tv|mobi|me|co|vip|shop|ltd|group|xyz|site)\b`
	HostR          = `\b([a-zA-Z0-9-]+?\.` + DomainSuffix + `)`
	DomainR        = `\b((?:[a-zA-Z0-9-]+?\.)*?[a-zA-Z0-9-]+?\.` + DomainSuffix + `)`
	PhoneR         = `\b((?:\+\d{1,3})?(?:\+\d{1, 3})?1(?:3|4|5|7|8)\d{9})\b`
	Semicolon      = ";"
	Comma          = ","
	Arrow          = "=>"
	ArrowSeparator = "<==>" //箭头分隔符
)

var (
	HostExp    = regexp.MustCompile(HostR)
	DomainExp  = regexp.MustCompile(DomainR)
	PhoneExp   = regexp.MustCompile(PhoneR)
	LocalhostM = map[string]string{"0.0.0.0": "local", "localhost": "local", "127.0.0.1": "local"}
	LabelBigRe = regexp.MustCompile(`(?i)(?:<style|script|iframe)\b[\s\S]*?</(?:style|script|iframe)>`)
	TableRe    = regexp.MustCompile(`<[\s\S]*?>|&[a-zA-Z]+;`)
	EmptyRe    = regexp.MustCompile(`\s{2,}`)
)

/*用户信息*/
type UserInfo struct {
	Gid   uint32 `json:"gid" form:"gid"`
	Uid   uint32 `json:"uid" form:"uid"`
	Gname string `json:"gname" form:"gname"`
	Uname string `json:"uname" form:"uname"`
}

// cookies 来自于 字符串转换过来的
func CookiesFromString(text string) []*http.Cookie {
	cookies := strings.Split(strings.ReplaceAll(text, Semicolon, "\n"), "\n")
	h := http.Header{}
	for _, c := range cookies {
		h.Add("Set-Cookie", c)
	}
	return (&http.Response{Header: h}).Cookies()
}

// 字符串来自于cookies转换过来的
func StringFromCookies(cookies []*http.Cookie) string {
	cs := make([]string, len(cookies))
	for i, c := range cookies {
		cs[i] = c.String()
	}
	return strings.Join(cs, "\n")
}

// 判断包含指定cookie
func ContainsCookie(cookies []*http.Cookie, name string) bool {
	for _, c := range cookies {
		if c.Name == name {
			return true
		}
	}
	return false
}

// ParseBool returns the boolean value represented by the string.
//
// It accepts 1, 1.0, t, T, TRUE, true, True, YES, yes, Yes,Y, y, ON, on, On,
// 0, 0.0, f, F, FALSE, false, False, NO, no, No, N,n, OFF, off, Off.
// Any other value returns an error.
//解析boolean
func ParseBool(val interface{}) bool {
	if val != nil {
		switch v := val.(type) {
		case bool:
			return v
		case string:
			switch strings.ToLower(v) {
			case "1", "t", "true", "yes", "y", "on":
				return true
			case "", "0", "f", "false", "no", "n", "off":
				return false
			}
		case int8, int32, int64:
			strV := fmt.Sprintf("%d", v)
			if strV == "1" {
				return true
			} else if strV == "0" {
				return false
			}
		case float64:
			if v == 1.0 {
				return true
			} else if v == 0.0 {
				return false
			}
		}
	}
	return false
}

//bool 转string
func BoolToString(b bool) string {
	if b {
		return "true"
	}
	return "false"
}

// 检查 并且去除 BOM
func TrimBOM(buf *bufio.Reader) {
	head, err := buf.Peek(3)
	if err == nil && head[0] == 239 && head[1] == 187 && head[2] == 191 {
		for i := 1; i <= 3; i++ {
			_, _ = buf.ReadByte()
		}
	}
}

// 检查 并且去除 bytes BOM
func TrimBytesDOM(data []byte) ([]byte, error) {
	buf := bufio.NewReader(bytes.NewBuffer(data))
	// check the BOM
	head, err := buf.Peek(3)
	if err == nil && head[0] == 239 && head[1] == 187 && head[2] == 191 {
		for i := 1; i <= 3; i++ {
			_, _ = buf.ReadByte()
		}
	}
	return ioutil.ReadAll(buf)
}

//判断是本地地址
func IsLocalhost(name string) bool {
	_, ok := LocalhostM[name]
	return ok
}

//去除全部HTML标签
func TrimHtml(text string) string {
	text = LabelBigRe.ReplaceAllString(text, "\t")
	text = TableRe.ReplaceAllString(text, "\t")
	text = EmptyRe.ReplaceAllString(text, "\t")
	return TrimSpace(strings.TrimSpace(text), 1)
}

//获取HTML标签的索引
func GetLabelIndexs(runes []rune) []int {
	var has bool
	indexs := make([]int, 0, len(runes))
	for i, v := range runes {
		if v == 60 {
			indexs = append(indexs, i)
			has = true
		} else if v == 62 {
			indexs = append(indexs, i)
			has = false
		} else if has {
			indexs = append(indexs, i)
		}
	}
	return indexs
}

//获取当前用户名
func CurrentUsername() string {
	if u, err := user.Current(); err == nil {
		return u.Username
	}
	return "root"
}

//获取当前用户路径
func CurrentHomeDir() string {
	if u, err := user.Current(); err == nil {
		return u.HomeDir
	}
	return "/root"
}

//获取数字有多少位数
func GetDigitLen(i64 int64) int {
	count := 1
	if i64 < 0 {
		count = 2
	}
	if i64 < 10 && i64 > -10 {
		return count
	}
	for i64 > 9 || i64 < -9 {
		i64 /= 10
		count += 1
	}
	return count
}

var (
	imgSuffixs = []string{".jpg", ".png", ".gif", ".wbmp"}
)

//包含后缀
func HasImgSuffix(name string) bool {
	for _, v := range imgSuffixs {
		if strings.HasSuffix(name, v) {
			return true
		}
	}
	return false
}

// 获取表单第一个值
func GetFormVal(form url.Values, key string) (string, bool) {
	if form == nil {
		return "", false
	}
	var vs []string
	var ok bool
	if vs, ok = form[key]; ok && len(vs) > 0 {
		return vs[0], true
	}
	return "", ok
}

// 判断存在
func HasPrefix(res []string, prefix string) bool {
	for _, v := range res {
		if strings.HasPrefix(v, prefix) {
			return true
		}
	}
	return false
}
func HasSuffix(res []string, suffix string) bool {
	for _, v := range res {
		if strings.HasSuffix(v, suffix) {
			return true
		}
	}
	return false
}
