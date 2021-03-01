package originality

import (
	"bytes"
	"errors"
	"fmt"
	"github.com/go-rod/rod"
	"github.com/go-rod/rod/lib/input"
	"github.com/go-rod/rod/lib/launcher"
	"github.com/go-rod/rod/lib/proto"
	"github.com/kataras/iris/v12"
	"regexp"
	"strings"
	"sync"
	"time"
)

var (
	page        *rod.Page
	Originality = new(originality)
	replacer    = strings.NewReplacer("\n", "", "\r", "", " ", "", "&nbsp;", "")
	trimRe      = regexp.MustCompile(`</?[^>]*>`)
)

type originality struct {
	sync.Mutex
	Running bool
	log     *bytes.Buffer
}

// 初始化
func (o *originality) init() (err error) {
	if o.log == nil {
		o.log = new(bytes.Buffer)
	}
	if page == nil {
		var controlURL string
		if controlURL, err = launcher.New().
			Set("--no-sandbox", "false").
			Delete("--enable-automation").
			Launch(); err != nil {
			return err
		}
		browser := rod.New().
			ControlURL(controlURL).
			SlowMotion(250)
		if err = browser.Connect(); err != nil {
			return err
		}
		if page, err = browser.Page(proto.TargetCreateTarget{URL: "https://www.baidu.com"}); err == nil {
			o.Running = true
		}
	}
	return err
}

// 写文本
func (o *originality) vet(elem *rod.Element, text string) (rate float64, err error) {
	if _, err = elem.Eval("this.value=''"); err != nil {
		return 0, err
	}
	o.log.WriteString("\t搜索: " + text + "\n")
	for _, r := range []rune(text) {
		if err = elem.Input(string(r)); err != nil {
			return 0, err
		}
		time.Sleep(250 * time.Microsecond)
	}
	page.Keyboard.MustPress(input.Enter)
	page.MustWaitNavigation()
	if e, err := page.Element("title"); err == nil {
		if title, err := e.Text(); err == nil && title == "百度安全验证" {
			o.Close()
			return 0, errors.New("百度安全验证")
		}
	}
	ch := make(chan bool)
	go func() {
		if _, err = page.Element("#content_left"); err != nil {
			o.log.WriteString("\t查找 #content_left " + err.Error() + "\n")
		}
		ch <- true
	}()
Break:
	for {
		select {
		case <-ch:
			break Break
		case <-time.After(10 * time.Second):
			return 0, errors.New("查询超时")
		}
	}
	elements, err := page.Elements("#content_left div.c-abstract")
	if err != nil {
		return 0, err
	}
	var max int
	for _, ele := range elements {
		var emTexts []string
		if es, err := ele.Elements("em"); err == nil {
			for _, em := range es {
				if str, err := em.Text(); err == nil {
					emTexts = append(emTexts, str)
				}
			}
		}
		n := emCount(emTexts)
		if n > max {
			max = n
		}
	}
	if max == 0 {
		return 0, nil
	}
	if rate = float64(max) / float64(len(text)); rate > 1 {
		rate = 1
	}
	return rate, nil
}

// 关闭
func (o *originality) Close() {
	o.Running = false
	if page != nil {
		page.MustClose()
		page = nil
	}
}

// 设置
func (o *originality) SetLog(log *bytes.Buffer) {
	if log != nil {
		o.log = log
	}
}

// 执行
func (o *originality) Exec(src string) (rate float64, err error) {
	o.Lock()
	defer o.Unlock()
	defer func() {
		if e := recover(); e != nil {
			err = fmt.Errorf("%v", e)
		}
	}()
	if src = trimRe.ReplaceAllString(replacer.Replace(src), ""); src == "" {
		return 0, err
	}
	if err = o.init(); err != nil {
		return 0, err
	}
	o.log.Reset()
	var elem *rod.Element
	if elem, err = page.Element("#kw"); err != nil {
		return 0, err
	}
	rs := []rune(src)
	var sections []string
	count := len(rs)
	if count > 0 && count < 38 {
		sections = append(sections, string(rs[0:]))
	} else if count > 20 && count < 250 {
		if count > 57 {
			sections = append(sections, string(rs[20:58]))
		} else {
			sections = append(sections, string(rs[20:]))
		}
	}
	for len(rs) > 250 {
		sections = append(sections, string(rs[0:38]))
		rs = rs[250:]
	}
	for _, v := range sections {
		var per float64
		if per, err = o.vet(elem, v); err != nil {
			return 0, err
		}
		o.log.WriteString("\t\t存在率: " + fmt.Sprintf("%f\n", per))
		rate += per
	}
	rate /= float64(len(sections))
	rate = 1 - rate
	if rate > 1.00 {
		rate = 1.00
	} else if rate < 0 {
		rate = 0
	}
	o.log.WriteString("原创度: " + fmt.Sprintf("%f\n", rate))
	return rate, err
}

func emCount(l []string) (n int) {
	m := make(map[string]bool, len(l))
	for _, v := range l {
		if v = strings.TrimSpace(v); v != "" && m[v] == false {
			n += len(v)
		} else {
			m[v] = true
		}
	}
	return n
}

func init() {
	iris.RegisterOnInterrupt(func() {
		Originality.Close()
	})
}
