package crontab

import (
	"github.com/robfig/cron/v3"
	"strconv"
	"strings"
	"sync"
	"time"
)

type (
	Config struct {
		id    cron.EntryID
		Token string
		Spec  string
		Func  func()
	}
	Cron interface {
		Stop()
		Start()
		Restart()
		Clear() //清空任务
		Add(cfg Config) error
		Del(token string)
		Count() int
		JobMap() map[string]Config
		Jobs() []string
	}
	crontab struct {
		sync.Mutex
		m       map[string]Config
		cr      *cron.Cron
		running bool
	}
)

func (c Config) String() string {
	var b strings.Builder
	n := len(c.Token) + len(c.Spec)
	b.Grow(n)
	b.WriteString("EntryId => ")
	b.WriteString(strconv.Itoa(int(c.id)))
	b.WriteString(", Token => ")
	b.WriteString(c.Token)
	b.WriteString(", Spec => ")
	b.WriteString(c.Spec)
	return b.String()
}

//添加任务
func (c *crontab) Add(cfg Config) error {
	c.Lock()
	defer c.Unlock()
	c.Del(cfg.Token)
	id, err := c.cr.AddFunc(cfg.Spec, cfg.Func)
	if err != nil {
		return err
	}
	cfg.id = id
	c.m[cfg.Token] = cfg
	return nil
}

//删除任务
func (c *crontab) Del(token string) {
	if data, ok := c.m[token]; ok {
		c.cr.Remove(data.id)
		delete(c.m, token)
	}
}

//停止
func (c *crontab) Stop() {
	c.Lock()
	defer c.Unlock()
	if c.running == false {
		return
	}
	defer func() {
		c.running = false
	}()
	stopping := c.cr.Stop()
	for {
		select {
		case <-stopping.Done():
			return
		case <-time.After(200 * time.Second):
			return
		}
	}
}

//开始
func (c *crontab) Start() {
	c.Lock()
	defer c.Unlock()
	if c.running {
		return
	}
	c.running = true
	c.cr.Start()
}

//重新启动
func (c *crontab) Restart() {
	c.Stop()
	c.Start()
}

//总任务
func (c *crontab) Count() int {
	return len(c.cr.Entries())
}

//获取任务 返回 map
func (c *crontab) JobMap() map[string]Config {
	idMap := make(map[cron.EntryID]Config, len(c.m))
	for _, v := range c.m {
		idMap[v.id] = v
	}
	entries := c.cr.Entries()
	r := make(map[string]Config, len(entries))
	for _, v := range entries {
		if cfg, ok := idMap[v.ID]; ok {
			r[cfg.Token] = cfg
		} else {
			c.cr.Remove(v.ID)
		}
	}
	return r
}

//获取任务 返回 slice
func (c *crontab) Jobs() []string {
	m := c.JobMap()
	ls := make([]string, 0, len(m))
	for _, v := range m {
		ls = append(ls, v.String())
	}
	return ls
}
func (c *crontab) clear() {
	c.Lock()
	defer c.Unlock()
	entries := c.cr.Entries()
	for _, v := range entries {
		c.cr.Remove(v.ID)
	}
	c.m = make(map[string]Config)
}

//清除全部任务
func (c *crontab) Clear() {
	c.Stop()
	c.clear()
}
func New(withSeconds bool) Cron {
	obj := new(crontab)
	obj.m = make(map[string]Config)
	if withSeconds {
		obj.cr = cron.New(cron.WithSeconds())
	} else {
		obj.cr = cron.New()
	}
	return obj
}
