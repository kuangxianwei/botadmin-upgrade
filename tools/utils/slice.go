package utils

import (
	"math/rand"
	"strings"
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

//判断包含列表中 int
func InSliceInt(ele int, l []int) bool {
	for _, v := range l {
		if v == ele {
			return true
		}
	}
	return false
}

//判断包含列表中 int64
func InSliceInt64(ele int64, l []int64) bool {
	for _, v := range l {
		if v == ele {
			return true
		}
	}
	return false
}

//删除slice元素
func DelSliceStr(slicePtr *[]string, elems ...string) []string {
	for i := 0; i < len(*slicePtr); i++ {
		if InSliceStr((*slicePtr)[i], elems) {
			*slicePtr = append((*slicePtr)[:i], (*slicePtr)[i+1:]...)
			i--
		}
	}
	return *slicePtr
}

/*
去除重复字符串
如果函数 vets 为0 则去除每个
*/
func UniqueSliceStr(s *[]string, vet func(ptr *string) bool) {
	m := make(map[string]bool, len(*s))
	if vet == nil {
		vet = func(ptr *string) bool {
			*ptr = strings.TrimSpace(*ptr)
			return *ptr != ""
		}
	}
	for i := 0; i < len(*s); i++ {
		if !vet(&(*s)[i]) || m[(*s)[i]] {
			*s = append((*s)[:i], (*s)[i+1:]...)
			i--
			continue
		}
		m[(*s)[i]] = true
	}
}

//去除重复 int
func UniqueSliceInt(s *[]int, vet func(ptr *int) bool) {
	m := make(map[int]bool, len(*s))
	vetted := func(ptr *int) bool {
		if vet != nil {
			return vet(ptr)
		}
		return true
	}
	for i := 0; i < len(*s); i++ {
		if !vetted(&(*s)[i]) || m[(*s)[i]] {
			*s = append((*s)[:i], (*s)[i+1:]...)
			i--
			continue
		}
		m[(*s)[i]] = true
	}
}

//去除重复 int64
func UniqueSliceI64(s *[]int64, vet func(ptr *int64) bool) {
	m := make(map[int64]bool, len(*s))
	vetted := func(ptr *int64) bool {
		if vet != nil {
			return vet(ptr)
		}
		return true
	}
	for i := 0; i < len(*s); i++ {
		if !vetted(&(*s)[i]) || m[(*s)[i]] {
			*s = append((*s)[:i], (*s)[i+1:]...)
			i--
			continue
		}
		m[(*s)[i]] = true
	}
}

//随机选择一个并减去选择的元素
func Reduce(s *[]string) string {
	c := len(*s)
	if c > 0 {
		index := rand.New(rand.NewSource(time.Now().UnixNano())).Intn(c)
		elm := (*s)[index]
		*s = append((*s)[:index], (*s)[index+1:]...)
		return elm
	}
	return ""
}
