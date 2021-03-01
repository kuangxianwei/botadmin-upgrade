package base_t

type Client struct {
	Ip        string `json:"ip" form:"ip"`     // 客户端IP地址
	Area      string `json:"area" form:"area"` //地区
	City      string `json:"city" form:"city"` // 城市
	Host      string `json:"host" form:"host"` // 被访问的URL
	UserAgent string `json:"user_agent" form:"user_agent"`
	Referrer  string `json:"referrer" form:"referrer"`   // 来源
	IsMobile  bool   `json:"is_mobile" form:"is_mobile"` // 是否是移动端访问
	Token     string `json:"token" form:"is_mobile"`
}


