package city

import (
	"math/rand"
	"time"
)

//判断包含列表中 string
func InSliceStr(ele string, l []string) bool {
	for _, v := range l {
		if v == ele {
			return true
		}
	}
	return false
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
