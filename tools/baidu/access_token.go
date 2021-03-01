package baidu

import (
	"botadmin/tools/requests"
	"errors"
	"time"
)

type AccessToken struct {
	AppId     int64  `json:"app_id" form:"app_id" html:"alias=应用ID"` //APP ID
	ApiKey    string `json:"api_key" form:"api_key"`                 //api key
	Secret    string `json:"secret" form:"secret" html:"alias=秘钥"`   //秘钥
	Token     string `json:"token" form:"token" html:"type=hidden"`  //凭证
	Timestamp int64  `json:"timestamp" form:"timestamp" html:"-"`    //token 更新时间
	Expires   int64  `json:"expires" form:"expires" html:"-"`        //过期时间
}

//设置百度token
func (t *AccessToken) SetToken() (err error) {
	if t.Token == "" || t.Expires < 1 || (time.Now().UTC().Unix()-t.Timestamp) > t.Expires {
		if len(t.ApiKey) != 24 || t.Secret == "" {
			return errors.New("百度api: 请设置apiKey或者secret")
		}
		var r requests.Responder
		if r, err = requests.Get("https://aip.baidubce.com/oauth/2.0/token", requests.Param{
			"client_id":     t.ApiKey,
			"client_secret": t.Secret,
			"grant_type":    "client_credentials",
		}); err != nil {
			return err
		}
		m := make(map[string]interface{})
		if err = r.Json(&m, "utf-8"); err != nil {
			return err
		}
		var ok bool
		if t.Token, ok = m["access_token"].(string); ok {
			if e64, ok := m["expires_in"].(float64); ok {
				t.Expires = int64(e64)
				t.Timestamp = time.Now().UTC().Unix()
				return nil
			}
		}
		return errors.New("获取百度access_token " + r.Text())
	}
	if t.Token == "" {
		return errors.New("百度api Token 为空")
	}
	return nil
}
