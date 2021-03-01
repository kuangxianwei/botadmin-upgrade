package requests

import (
	"botadmin/tools/utils"
	"bytes"
	"errors"
	"log"
	"regexp"
	"testing"
)

func Login() (req Requester, err error) {
	var r Responder
	req = New()
	req.ClearCookies()
	payload := Data{
		"chkRemember": "on",
		"btnPost":     "登录",
		"username":    "www_zblog_com",
		"password":    utils.Md5("bZuEfaDPtmhn"),
		"savedate":    "30",
	}
	if r, err = req.Post("http://www.zblog.com/zb_system/cmd.php?act=verify", payload); err != nil {
		return req, err
	}
	if !bytes.Contains(r.Bytes(UTF8), []byte("<a class=\"logout\"")) {
		return req, errors.New("www.zblog.com 登录失败 " + r.Text())
	}
	return req, nil
}

var zbTokenRe = regexp.MustCompile(`/plugin/AppCentre/theme\.js\.php\?token=([a-z0-9]+)`)

func TestMultipart(t *testing.T) {
	url := "http://www.zblog.com/zb_users/plugin/AppCentre/app_upload.php"
	req, err := Login()
	if err != nil {
		panic(err)
	}
	r, err := req.Get("http://www.zblog.com/zb_system/admin/index.php?act=ThemeMng")
	if err != nil {
		panic(err)
	}
	var token string
	rs := zbTokenRe.FindStringSubmatch(r.Text())
	if len(rs) == 2 {
		token = rs[1]
	}
	r, err = req.Multipart(url,
		Data{"B1": "提交", "token": token},
		File{"edtFileLoad": "/root/botadmin/data/template/zblog/Hecms.zba"})
	if err != nil {
		panic(err)
	}
	log.Printf("POST\n%v\n\n", r.Text())
	log.Println(r.CookiesText())
}
