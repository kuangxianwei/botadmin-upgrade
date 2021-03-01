package base_t

import (
	"errors"
	"strings"
	"time"
)

type (
	// 间隔 开始到结束
	Interval struct {
		Begin  int64  `json:"begin"`
		End    int64  `json:"end"`
		Source string `json:"source"` //源
		Sep    string `json:"sep"`    //分隔符
		Prefix string `json:"prefix"` //前缀 "2006-01-02 "
	}
	Intervals []Interval
)

func (i *Interval) Parse() Interval {
	if i.Sep == "" {
		i.Sep = "-"
	}
	i.Source = strings.ReplaceAll(i.Source, " ", "")
	if i.Source != "" {
		ls := make([]string, 2)
		copy(ls, strings.SplitN(i.Source, "-", 2))
		if tmp, err := time.ParseInLocation("2006-01-02T15:04:05", i.Prefix+ls[0], time.Local); err == nil {
			i.Begin = tmp.Unix()
		}
		if tmp, err := time.ParseInLocation("2006-01-02T15:04:05", i.Prefix+ls[1], time.Local); err == nil {
			i.End = tmp.Unix()
		}
	}
	return *i
}
func (i *Interval) Valid() error {
	if i.Begin == i.End {
		return errors.New("开始时间和结束时间不可以同一时间")
	}
	if i.Begin <= 0 {
		return errors.New("开始时间戳不可以小于0")
	}
	if i.End <= 0 {
		return errors.New("结束时间戳不可以小于0")
	}
	return nil
}

// 判断在内
func (i *Interval) In(stamp int64) bool {
	if i.Begin > i.End {
		return stamp < i.End || stamp >= i.Begin
	}
	return stamp >= i.Begin && stamp < i.End
}

func (i *Intervals) Add(sources ...string) {
	var prefix string
	if nowTime := time.Unix(time.Now().Local().Unix(), 0).Format("2006-01-02T15:04:05"); len(nowTime) > 11 {
		prefix = nowTime[:11]
	}
	for _, v := range sources {
		interval := (&Interval{Source: v, Prefix: prefix}).Parse()
		if err := interval.Valid(); err == nil {
			*i = append(*i, interval)
		}
	}
}

func (i Intervals) In() bool {
	if len(i) == 0 {
		return true
	}
	stamp := time.Now().Local().Unix()
	for _, v := range i {
		if v.In(stamp) {
			return true
		}
	}
	return false
}

// 新建列表
func NewIntervals(sources ...string) Intervals {
	obj := make(Intervals, 0, len(sources))
	obj.Add(sources...)
	return obj
}
