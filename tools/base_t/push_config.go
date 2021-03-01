package base_t

import (
	"botadmin/tools/requests"
	"botadmin/tools/utils"
	"encoding/json"
	"net/url"
	"strings"
)

type Push struct {
	Api    string `json:"api" form:"api"`
	Alias  string `json:"alias" form:"alias"`   //别名
	Notice string `json:"notice" form:"notice"` //说明
}

//推送
func (p *Push) Send(pubs PubResults) (string, error) {
	r, err := requests.Post(
		p.Api,
		requests.Header{"Content-Type": "text/plain"},
		strings.Join(pubs.Urls(), "\n"),
	)
	if err != nil {
		return "", err
	}
	return r.Text("utf-8"), nil
}

type PushConfig []Push

// 替换变量
func (c *PushConfig) Tidy(host, site string) {
	replacer := strings.NewReplacer("{{host}}", host, "{{site}}", site)
	for i := 0; i < len(*c); i++ {
		(*c)[i].Api = replacer.Replace((*c)[i].Api)
	}
}

//加载来自数据库的数据到结构体中
func (c *PushConfig) FromDB(b []byte) error {
	if len(b) == 0 {
		*c = nil
		return nil
	}
	return json.Unmarshal(b, c)
}

//把结构体中的数据转为bytes
func (c *PushConfig) ToDB() ([]byte, error) {
	return json.Marshal(c)
}

//输出字符串
func (c PushConfig) String() string {
	var buf strings.Builder
	var start bool
	for _, v := range c {
		if strings.HasPrefix(v.Api, "#") {
			continue
		}
		if start {
			buf.WriteString("\n")
		}
		start = true
		if v.Api == "" {
			continue
		}
		buf.WriteString(v.Api)
		if v.Alias == "" {
			if strings.Contains(v.Api, ".baidu.") {
				v.Alias = "百度"
			} else if strings.Contains(v.Api, ".sm.") {
				v.Alias = "神马"
			} else {
				v.Alias = "API别名"
			}
		}
		buf.WriteString(" ")
		buf.WriteString(v.Alias)
		buf.WriteString(" ")
		if v.Notice == "" {
			v.Notice = "账号=username 密码=password"
		}
		buf.WriteString(v.Notice)
	}
	return buf.String()
}

//解析来自表单的数据
func (c *PushConfig) ParseForm(form url.Values, prefix string) {
	if c == nil {
		return
	}
	if values := form[prefix]; len(values) > 0 {
		exists := make(map[string]bool)
		for _, v := range values {
			if v = strings.TrimSpace(v); v != "" {
				for _, vv := range strings.Split(v, "\n") {
					fields := []string{"推送api", "别名", "账号=username 密码=password"}
					copy(fields, strings.SplitN(utils.TrimSpace(vv, 1), " ", 3))
					if !exists[fields[0]] {
						*c = append(*c, Push{Api: fields[0], Alias: fields[1], Notice: fields[2]})
						exists[fields[0]] = true
					}
				}
			}
		}
	}
}
