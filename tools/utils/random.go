package utils

import (
	"bytes"
	"math/rand"
	"strconv"
	"strings"
	"time"
	"unicode"
)

//生成随机数值
func RandomN(n int) int {
	if n <= 0 {
		return 0
	}
	return rand.New(rand.NewSource(time.Now().UnixNano())).Intn(n)
}

//生成指定范围内的随机数 包含最小数值 不包含最大数值
func Random(min, max int) int {
	if min == max {
		return min
	}
	if min > max {
		min, max = max, min
	}
	return rand.New(rand.NewSource(time.Now().UnixNano())).Intn(max-min) + min
}

//生成随机字符串
func randomString(size int, buf []byte) string {
	result := make([]byte, 0, size)
	r := rand.New(rand.NewSource(time.Now().UnixNano()))
	for i := 0; i < size; i++ {
		result = append(result, buf[r.Intn(len(buf))])
	}
	return string(result)
}

// 过滤字符串里面的数字
func FilterDigit(s string) (int, string) {
	var buf bytes.Buffer
	buf.Grow(len(s))
	for _, r := range s {
		if unicode.IsDigit(r) {
			buf.WriteRune(r)
		}
	}
	s = buf.String()
	if s == "" {
		s = "0"
	}
	i, _ := strconv.Atoi(s)
	return i, s
}

//编译随机数
func ParseMinMax(strPtr *string, sep ...string) (min, max int) {
	if strPtr == nil {
		return
	}
	if len(sep) == 0 {
		sep = []string{"-"}
	}
	var minMax = make([]string, 2)
	copy(minMax, strings.SplitN(*strPtr, sep[0], 2))
	min, minStr := FilterDigit(minMax[0])
	max, maxStr := FilterDigit(minMax[1])
	if min > max {
		*strPtr = maxStr + sep[0] + minStr
		return max, min
	}
	*strPtr = minStr + sep[0] + maxStr
	return min, max
}

//生成随机数字
func RandomNum(size int) string {
	return randomString(size, []byte("0123456789"))
}

//生成随机小写字母
func RandomLower(size int) string {
	return randomString(size, []byte("0123456789abcdefghijklmnopqrstuvwxyz"))
}

//生成随机大写字母
func RandomUpper(size int) string {
	return randomString(size, []byte("ABCDEFGHIJKLMNOPQRSTUVWXYZ"))
}

//生成随机小写、大写、数字混合
func RandomBlend(size int) string {
	return randomString(size, []byte("0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"))
}

//随机在列表中选择一个数元素 string
func ChoiceString(s []string) string {
	count := len(s)
	if count == 0 {
		return ""
	}
	r := rand.New(rand.NewSource(time.Now().UnixNano()))
	return s[r.Intn(count)]
}

//随机在列表中选择N个数元素
func ChoiceStringN(s []string, n int) (res []string) {
	/*随机抽N个元素 string*/
	length := len(s)
	if length <= 1 || n >= length {
		return s
	}
	rand.Seed(time.Now().UnixNano())
	for i := 0; i < 10000; i++ {
		if len(res) >= n {
			return res
		}
		elem := s[rand.Intn(length)]
		if !InSliceStr(elem, res) {
			res = append(res, elem)
		}
	}
	return res
}

//随机在列表中选择一个数元素 int
func ChoiceInt(s []int) int {
	count := len(s)
	if count == 0 || len(s) == 0 {
		return 0
	}
	r := rand.New(rand.NewSource(time.Now().UnixNano()))
	return s[r.Intn(count)]
}

//中奖 level为几率 1-10 数值越高中奖率越大
func Prize(level int) bool {
	if level >= 10 {
		return true
	}
	level *= 2
	for i := 0; i < level; i++ {
		if rand.New(rand.NewSource(time.Now().UnixNano())).Intn(30) == 5 {
			return true
		}
	}
	return false
}
