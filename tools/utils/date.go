package utils

import (
	"time"
)

const (
	Day         = "2006-01-02"
	Hour        = "2006-01-02 15"
	HourFill    = "2006-01-02::15"
	Min         = "2006-01-02 15:04"
	Second      = "2006-01-02 15:04:05"
	Millisecond = "2006-01-02 15:04:05.000"
)

func StrByTimestamp(timestamp int64, layout string) string {
	if timestamp <= 0 {
		return ""
	}
	return time.Unix(timestamp, 0).Format(layout)
}
func TimestampByStr(text, layout string) int64 {
	if text == "" {
		return 0
	}
	loc, _ := time.LoadLocation("Local")
	parse, _ := time.ParseInLocation(layout, text, loc)
	return parse.Unix()
}
func Timestamp() int64 {
	return time.Now().Local().Unix()
}

/*获取当前时间戳和格式化时间*/
func GetDate() string {
	return StrByTimestamp(Timestamp(), Second)
}
