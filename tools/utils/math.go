package utils

import (
	"math"
	"strings"
)

// 四舍五入保留指定位数
func TruncFloat(f float64, n int) float64 {
	n10 := math.Pow10(n)
	return math.Trunc((f+0.5/n10)*n10) / n10
}

//是否包含http://或者https://
func HasScheme(text string) bool {
	return strings.HasPrefix(text, "http://") || strings.HasPrefix(text, "https://")
}
