package crontab

import (
	"botadmin/tools/utils"
	"encoding/json"
	"github.com/robfig/cron/v3"
	"math/rand"
	"strconv"
	"strings"
	"time"
)

/*定时任务规格*/
type Spec struct {
	Second string `json:"second" form:"second" html:"note=0-59,alias=秒"` // 秒 0-59	*/,-
	Minute string `json:"minute" form:"minute" html:"note=0-59,alias=分"` // 分(Minutes)	0-59	*/,-
	Hour   string `json:"hour" form:"hour" html:"note=0-23,alias=时"`     // 小时(Hours)	0-23	*/,-
	Day    string `json:"day" form:"day" html:"note=1-31,alias=天"`       // 一个月中的某一天(Day of month)	1-31	*/,-?
	Month  string `json:"month" form:"month" html:"note=1-12,alias=月"`   // 月(Month)	1-12 or JAN-DEC	*/,-
	Week   string `json:"week" form:"week" html:"note=0-6,alias=周"`      // 星期几(Day of week)	0-6 or SUN-SAT	*/,-?
}

//填充默认值
func (s *Spec) Fill() {
	if s.Second == "" {
		s.Second = random(0, 60)
	}
	if s.Minute == "" {
		s.Minute = random(0, 60)
	}
	if s.Hour == "" {
		s.Hour = random(0, 24)
	}
	if s.Day == "" {
		s.Day = "*"
	}
	if s.Month == "" {
		s.Month = "*"
	}
	if s.Week == "" {
		s.Week = "?"
	}
}

//格式化输出
func (s *Spec) Format(withSeconds bool) string {
	s.Fill()
	var buf strings.Builder
	buf.Grow(100)
	if withSeconds {
		buf.WriteString(s.Second)
		buf.WriteString(" ")
	}
	buf.WriteString(s.Minute)
	buf.WriteString(" ")
	buf.WriteString(s.Hour)
	buf.WriteString(" ")
	buf.WriteString(s.Day)
	buf.WriteString(" ")
	buf.WriteString(s.Month)
	buf.WriteString(" ")
	buf.WriteString(s.Week)
	return buf.String()
}

//验证合法
func (s *Spec) Valid() error {
	c := cron.New(cron.WithSeconds())
	_, err := c.AddFunc(s.Format(true), func() {})
	return err
}

//加载来自数据库的数据到结构体中
func (s *Spec) FromDB(b []byte) error {
	return json.Unmarshal(b, s)
}

//把结构体中的数据转为bytes
func (s *Spec) ToDB() ([]byte, error) {
	return json.Marshal(s)
}

//输出表单
func (s *Spec) ToForm() (string, error) {
	return utils.ToForm(s)
}

// 随机数
func random(min, max int) string {
	if min == max {
		return strconv.Itoa(min)
	}
	if min > max {
		min, max = max, min
	}
	return strconv.Itoa(rand.New(rand.NewSource(time.Now().UnixNano())).Intn(max-min) + min)
}
