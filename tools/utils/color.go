package utils

import (
	"bytes"
	"strconv"
	"strings"
)

var s = []byte("0123456789ABCDEF")

// 转为rgb
func HexToRGB(hexStr string) (r, g, b int) {
	hexStr = strings.TrimPrefix(strings.TrimPrefix(hexStr, "#"), "0x") //过滤掉16进制前缀
	color64, err := strconv.ParseInt(hexStr, 16, 32)                   //字串到数据整型
	if err != nil {
		return 0, 0, 0
	}
	color := int(color64)
	return color >> 16, (color & 0x00FF00) >> 8, color & 0x0000FF
}
func HexToRGBString(hexStr string) (r, g, b string) {
	ri, gi, bi := HexToRGB(hexStr)
	return strconv.Itoa(ri), strconv.Itoa(gi), strconv.Itoa(bi)
}

// 转为color
func RgbToHex(r, g, b int) string {
	if r >= 0 && r < 256 && g >= 0 && g < 256 && b >= 0 && b < 256 {
		var x, y, z int
		var buf bytes.Buffer
		buf.WriteByte('#')
		x = r % 16
		buf.WriteByte(s[(r-x)/16])
		buf.WriteByte(s[x])
		y = g % 16
		buf.WriteByte(s[(g-y)/16])
		buf.WriteByte(s[y])
		z = b % 16
		buf.WriteByte(s[(b-z)/16])
		buf.WriteByte(s[z])
		return buf.String()
	}
	return ""
}
