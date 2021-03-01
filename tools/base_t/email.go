package base_t

import (
	"net/http"
	"net/smtp"
	"strings"
	"sync"
)

type Email struct {
	Host        string    `json:"host" form:"host" html:"alias=服务地址,note=smtp.qq.com:25"`                           // smtp.qq.com:25
	Username    string    `json:"username" form:"username" html:"alias=发信者,note=38050123@qq.com"`                   // 38050123@qq.com
	Password    string    `json:"password" form:"password" html:"alias=密码,note=38050123@qq.com"`                    // 密码
	ContentType string    `json:"content_type" form:"content_type" html:"alias=内容类型,note=text/html; charset=UTF-8"` // Content-Type: text/plain; charset=UTF-8
	auth        smtp.Auth `form:"-" xorm:"-"`                                                                       // 验证
	once        sync.Once `form:"-" xorm:"-"`                                                                       // 只执行一次
}

func (e *Email) init() {
	e.once.Do(func() {
		if e.Host == "" {
			e.Host = "smtp.qq.com:25"
		}
		e.auth = smtp.PlainAuth("", e.Username, e.Password, strings.Split(e.Host, ":")[0])
	})
}

func (e *Email) Send(to []string, subject, body string) error {
	e.init()
	contentType := e.ContentType
	if e.ContentType == "" {
		contentType = http.DetectContentType([]byte(body))
	}
	msg := []byte("To: " + strings.Join(to, ";") + "\r\nFrom: " + e.Username + ">\r\nSubject: " + subject + "\r\nContent-Type: " + contentType + "\r\n\r\n" + body)
	return smtp.SendMail(e.Host, e.auth, e.Username, to, msg)
}
