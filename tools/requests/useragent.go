package requests

import (
	"math/rand"
	"time"
)

const (
	UserAgentChromeMac    = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.157 Safari/537.36"
	UserAgentChromeWin    = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.86 Safari/537.36"
	UserAgentFirefoxMac   = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:66.0) Gecko/20100101 Firefox/66.0"
	UserAgentFirefoxWin   = "Mozilla/5.0 (Windows NT 10.0; WOW64; rv:66.0) Gecko/20100101 Firefox/66.0"
	UserAgentSafari       = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.1 Safari/605.1.15"
	UserAgentSafariIphone = "Mozilla/5.0 (iPhone; CPU iPhone OS 13_1_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.1 Mobile/15E148 Safari/604.1"
	UserAgentOpera        = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36 OPR/58.0.3135.132"
	UserAgentQQ           = "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.25 Safari/537.36 Core/1.70.3676.400 QQBrowser/10.4.3469.400"
	UserAgentIE           = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36 Edge/18.18362"
	UserAgentIphone       = "Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_0 like Mac OS X; en-us) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 Mobile/8A293 Safari/6531.22.7"
	UserAgentIPad         = "Mozilla/5.0(iPad; U; CPU OS 4_3 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8F191 Safari/6533.18.5"
	UserAgentAndroid      = "Mozilla/5.0 (Linux; U; Android 2.2; en-us; Nexus One parsePc/FRF91) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1"

	UserAgentBaiduSpiderPC     = "Mozilla/5.0 (compatible; Baiduspider-render/2.0; +http://www.baidu.com/search/spider.html)"
	UserAgentBaiduSpiderMobile = "Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1 (compatible; Baiduspider-render/2.0; +http://www.baidu.com/search/spider.html)"
	UserAgentGoogleBot         = "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
	UserAgentYisouSpider       = "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.81 YisouSpider/5.0 Safari/537.36"
)

var (
	UA         = new(userAgent)
	UserAgents = new(userAgents)
)

type (
	userAgent struct {
		ChromeMac         string //苹果电脑谷歌浏览器
		ChromeWin         string //windows 电脑谷歌浏览器
		FirefoxMac        string //苹果电脑火狐浏览器
		FirefoxWin        string //windows电脑火狐浏览器
		Safari            string //苹果电脑自带浏览器
		Opera             string
		QQ                string
		IE                string
		Iphone            string
		Android           string
		IPad              string
		SafariIphone      string //苹果手机浏览器
		BaiduSpiderPC     string //百度蜘蛛 pc
		BaiduSpiderMobile string //百度蜘蛛 移动
		GoogleBot         string //谷歌蜘蛛
		YisouSpider       string //神马搜索蜘蛛
	}
	UserAgent struct {
		Type  int    `json:"type" form:"type"`
		Index int    `json:"index" form:"index"`
		Name  string `json:"name" form:"name"`
		Alias string `json:"alias" form:"alias"`
		Value string `json:"value" form:"value"`
	}
	userAgents []UserAgent
)

func (a *userAgent) load() {
	a.ChromeMac = UserAgentChromeMac
	a.ChromeWin = UserAgentChromeWin
	a.FirefoxMac = UserAgentFirefoxMac
	a.FirefoxWin = UserAgentFirefoxWin
	a.Safari = UserAgentSafari
	a.Opera = UserAgentOpera
	a.QQ = UserAgentQQ
	a.IE = UserAgentIE
	a.Iphone = UserAgentIphone
	a.Android = UserAgentAndroid
	a.IPad = UserAgentIPad
	a.SafariIphone = UserAgentSafariIphone
	a.BaiduSpiderPC = UserAgentBaiduSpiderPC
	a.BaiduSpiderMobile = UserAgentBaiduSpiderMobile
	a.GoogleBot = UserAgentGoogleBot
	a.YisouSpider = UserAgentYisouSpider
}
func (a *userAgents) load() {
	*a = []UserAgent{
		{Type: 0, Index: 0, Name: "UserAgentBaiduSpiderPC", Alias: "PC端百度蜘蛛", Value: UserAgentBaiduSpiderPC},
		{Type: 1, Index: 1, Name: "UserAgentBaiduSpiderMobile", Alias: "移动端百度蜘蛛", Value: UserAgentBaiduSpiderMobile},
		{Type: 0, Index: 2, Name: "UserAgentGoogleBot", Alias: "谷歌蜘蛛", Value: UserAgentGoogleBot},
		{Type: 0, Index: 3, Name: "UserAgentYisouSpider", Alias: "神马蜘蛛", Value: UserAgentYisouSpider},
		{Type: 0, Index: 4, Name: "UserAgentChromeMac", Alias: "谷歌浏览器forMac", Value: UserAgentChromeMac},
		{Type: 0, Index: 5, Name: "UserAgentChromeWin", Alias: "谷歌浏览器forWindow", Value: UserAgentChromeWin},
		{Type: 0, Index: 6, Name: "UserAgentFirefoxMac", Alias: "火狐浏览器forMac", Value: UserAgentFirefoxMac},
		{Type: 0, Index: 7, Name: "UserAgentFirefoxWin", Alias: "火狐浏览器forWindow", Value: UserAgentFirefoxWin},
		{Type: 0, Index: 8, Name: "UserAgentSafari", Alias: "Safari浏览器", Value: UserAgentSafari},
		{Type: 0, Index: 9, Name: "UserAgentOpera", Alias: "Opera浏览器", Value: UserAgentOpera},
		{Type: 1, Index: 10, Name: "UserAgentIphone", Alias: "手机浏览器苹果版", Value: UserAgentIphone},
		{Type: 1, Index: 11, Name: "UserAgentAndroid", Alias: "手机浏览器安卓版", Value: UserAgentAndroid},
		{Type: 1, Index: 12, Name: "UserAgentSafariIphone", Alias: "手机浏览器Safari", Value: UserAgentSafariIphone},
		{Type: 1, Index: 13, Name: "UserAgentIPad", Alias: "IPad", Value: UserAgentIPad},
	}
}

// 随机选择userAgent
func (a *userAgents) Choice() UserAgent {
	return choice(*a)
}

// 随机选择移动端userAgent
func (a *userAgents) ChoiceMobile() UserAgent {
	ls := make(userAgents, 0, len(*a))
	for _, v := range *a {
		if v.Type == 1 {
			ls = append(ls, v)
		}
	}
	return choice(ls)
}

// 随机选择PC端userAgent
func (a *userAgents) ChoicePc() UserAgent {
	ls := make(userAgents, 0, len(*a))
	for _, v := range *a {
		if v.Type == 0 {
			ls = append(ls, v)
		}
	}
	return choice(ls)
}

// 随机选择userAgent
func choice(us userAgents) UserAgent {
	count := len(us)
	if count == 0 {
		return UserAgent{}
	}
	return (us)[rand.New(rand.NewSource(time.Now().UnixNano())).Intn(count)]
}
func init() {
	UA.load()
	UserAgents.load()
}
