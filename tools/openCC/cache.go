package openCC

import "sync"

var Cache = new(cache)

type cache struct {
	store map[string]*OpenCC
	sync.Mutex
}

// 添加
func (c *cache) Add(cc *OpenCC) {
	c.Lock()
	defer c.Unlock()
	if cc != nil && len(cc.DictChains) > 0 {
		if c.store == nil {
			c.store = make(map[string]*OpenCC)
		}
		c.store[cc.Name] = cc
	}
}

// 获取
func (c *cache) Get(k string) (*OpenCC, bool) {
	c.Lock()
	defer c.Unlock()
	cc, ok := c.store[k]
	return cc, ok
}

// 清除
func (c *cache) Clear() {
	c.Lock()
	defer c.Unlock()
	c.store = make(map[string]*OpenCC)
}

// 清除当前
func (c *cache) Del(k string) {
	c.Lock()
	defer c.Unlock()
	if c.store != nil {
		delete(c.store, k)
	}
}
