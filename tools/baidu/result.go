package baidu

import (
	"errors"
	"strconv"
)

//百度ai 处理结果
type Results struct {
	LogId     int64  `json:"log_id" form:"log_id"`
	ErrorCode int    `json:"error_code" form:"error_code"`
	ErrorMsg  string `json:"error_msg" form:"error_msg"`
}

//获取错误信息
func (r *Results) Err() error {
	if r.ErrorMsg != "" {
		return errors.New("code: " + strconv.Itoa(r.ErrorCode) + " msg: " + r.ErrorMsg)
	}
	return nil
}
