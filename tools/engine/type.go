package engine

import (
	"botadmin/tools/utils"
	"golang.org/x/net/publicsuffix"
	"net"
	"regexp"
	"strconv"
	"strings"
)

//ssl
const (
	SslDisabled     = iota //不启用ssl
	SslEnabled             //启用ssl
	SslEnabledForce        //强制启用ssl
)

//网站状态
const (
	Prepared  = iota //准备就绪
	Founded          //创建完成
	Installed        //安装完成
	LocalDone        //本地站完成
	ExtDone          //外部网站s
)

const (
	PublicHtml  = "public_html" //网站根目录名称
	Backup      = "backup"      //网站备份目录名称
	Logs        = "logs"        //网站日志目录名称
	UserIni     = ".user.ini"   //锁定跨目录文件名
	Del         = "del"
	SchemeHttp  = "http://"
	SchemeHttps = "https://"
)

var (
	//网站状态
	SiteStatus      = [5]string{Prepared: "准备就绪", Founded: "创建完成", Installed: "安装完成", LocalDone: "本地-正常", ExtDone: "外部-正常"}
	SiteStatusCount = len(SiteStatus)
	NamePattern     = regexp.MustCompile(`^[a-zA-Z0-9_]{1,16}$`)
	SrcRe           = regexp.MustCompile(`(?i)\bsrc\s*=\s*['"](\S+)['"]`)
)

//mysql 配置接口
type SQL interface {
	// 数据库名称
	GetDbname() string
	// 数据库用户名
	GetUsername() string
	// 数据库密码
	GetPassword() string
	// 数据库前缀
	GetPrefix() string
	// 数据库编码
	GetCharset() string
	// host
	GetHosts() []string
	// port
	GetPort() int
	//  Params
	GetParams() map[string]string
	// 更新指定字段
	Update(cols ...string) (int64, error)
	// 连接数据库字符串
	GetSource() string
}
type Config struct {
	DriverName string            `json:"driver_name" form:"driver_name"`          // 驱动名称
	Dbname     string            `json:"dbname" form:"dbname"`                    //数据库名称
	Username   string            `json:"username" form:"username"`                //用户名
	Password   string            `json:"password" form:"password"`                //密码
	Charset    string            `json:"charset" form:"charset"`                  //数据库编码 gbk utf8
	Prefix     string            `json:"prefix" form:"prefix"`                    //数据库前缀 bot_
	Hosts      []string          `json:"hosts" form:"hosts" xorm:"Text" sep:"\n"` // localhost
	Port       int               `json:"port" form:"port"`                        //port
	Source     string            `json:"source" form:"source"`                    // 直接写死字符串连接
	Params     map[string]string `json:"params" form:"params"`                    // 其他参数
	inited     bool              `form:"-" xorm:"-"`
}

// 整理默认数据
func (c *Config) SQL() SQL {
	if c.inited == false {
		c.inited = true
		if c.Charset == "" {
			c.Charset = "utf8"
		}
		for i := 0; i < len(c.Hosts); i++ {
			c.Hosts[i] = GetDomain(c.Hosts[i])
		}
		if len(c.Hosts) == 0 {
			c.Hosts = []string{"localhost"}
		} else {
			utils.UniqueSliceStr(&c.Hosts, nil)
		}
		if c.Port == 0 {
			c.Port = 3306
		}
		if c.Params == nil {
			c.Params = make(map[string]string)
		}
		c.Charset = strings.ToLower(c.Charset)
		if _, ok := Charsets[c.Charset]; !ok {
			c.Charset = "utf8"
		}
		if _, ok := c.Params["parseTime"]; !ok {
			c.Params["parseTime"] = "true"
		}
		if _, ok := c.Params["loc"]; !ok {
			c.Params["loc"] = "Local"
		}
		if c.Username == "" {
			c.Username = c.Dbname
		}
		if c.Prefix == "" {
			c.Prefix = "bot_"
		}
		if c.DriverName == "" {
			c.DriverName = "sqlite3"
		}
		switch c.DriverName {
		case "mysql":
			var buf strings.Builder
			buf.WriteString(c.Username)
			buf.WriteByte(':')
			buf.WriteString(c.Password)
			buf.WriteString("@tcp(")
			buf.WriteString(c.Hosts[0])
			buf.WriteByte(':')
			buf.WriteString(strconv.Itoa(c.Port))
			buf.WriteString(")/")
			buf.WriteString(c.Dbname)
			buf.WriteString("?charset=")
			buf.WriteString(c.Charset)
			for k, v := range c.Params {
				buf.WriteByte('&')
				buf.WriteString(k)
				buf.WriteByte('=')
				buf.WriteString(v)
			}
			c.Source = buf.String()
		default:
			if c.Source == "" {
				c.Source = "./default.db"
			}
		}
	}
	return c
}
func (c *Config) GetSource() string {
	c.SQL()
	return c.Source
}
func (c *Config) GetDbname() string {
	c.SQL()
	return c.Dbname
}
func (c *Config) GetUsername() string {
	c.SQL()
	return c.Username
}
func (c *Config) GetPassword() string {
	c.SQL()
	return c.Password
}
func (c *Config) GetPrefix() string {
	c.SQL()
	return c.Prefix
}
func (c *Config) GetCharset() string {
	c.SQL()
	return c.Charset
}
func (c *Config) GetHosts() []string {
	c.SQL()
	return c.Hosts
}
func (c *Config) GetPort() int {
	c.SQL()
	return c.Port
}
func (c *Config) GetParams() map[string]string {
	c.SQL()
	return c.Params
}
func (c *Config) Update(...string) (int64, error) {
	c.SQL()
	return 0, nil
}
func GetDomain(hostPort string) string {
	host := hostPort
	if tmp, _, err := net.SplitHostPort(hostPort); err == nil {
		host = tmp
	}
	switch host {
	// We could use the netutil.LoopbackRegex but leave it as it's for now, it's faster.
	case "localhost", "127.0.0.1", "0.0.0.0", "::1", "[::1]", "0:0:0:0:0:0:0:0", "0:0:0:0:0:0:0:1":
		return "localhost"
	default:
		if domain, err := publicsuffix.EffectiveTLDPlusOne(host); err == nil {
			host = domain
		}
		return host
	}
}
