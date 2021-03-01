package cache

import (
	"botadmin/tools/base_t"
	"encoding/json"
	"fmt"
	"github.com/kataras/iris/v12"
	"log"
	"os"
	"sort"
	"sync"
	"time"
)

var interval = 10 * time.Second

type Record struct {
	Id     int64
	Status int
	Log    base_t.Buffer
}

type Recorder interface {
	Set(r *Record)
	Get(id int64) *Record
	Sync(forces ...bool) error // 同步到文件中保存
	Pagination(status int, page, limit int) base_t.Pagination
	Del(ids ...int64)
	Toggle(status int, ids ...int64) //切换状态
}

type recordCache struct {
	store        map[int64]*Record //储存库
	modified     bool              // 是否有修改
	sync.RWMutex                   //读写锁
	interval     time.Duration     //间隔时间
	sync.Once                      //只执行一次
	filename     string            // 文件名称
	filePtr      *os.File          //文件句柄
}

// 初始化
func (c *recordCache) init() error {
	var err error
	c.Do(func() {
		c.store = make(map[int64]*Record)
		if c.filename != "" {
			if c.filePtr, err = os.OpenFile(c.filename, os.O_CREATE|os.O_RDWR, 0666); err != nil {
				return
			}
			iris.RegisterOnInterrupt(func() {
				c.filePtr.Close()
			})
			var info os.FileInfo
			if info, err = c.filePtr.Stat(); err == nil && info.Size() > 0 {
				if err = json.NewDecoder(c.filePtr).Decode(&c.store); err != nil {
					return
				}
			}
			// 开启定时保存到文件
			c.timing()
		}
	})
	return err
}

// 添加
func (c *recordCache) Set(r *Record) {
	c.Lock()
	c.store[r.Id] = r
	c.modified = true
	c.Unlock()
}

// 删除
func (c *recordCache) Del(ids ...int64) {
	c.Lock()
	for _, id := range ids {
		delete(c.store, id)
	}
	c.modified = true
	c.Unlock()
}

// 切换状态
func (c *recordCache) Toggle(status int, ids ...int64) {
	c.Lock()
	for _, id := range ids {
		if r, has := c.store[id]; has {
			r.Status = status
		}
	}
	c.modified = true
	c.Unlock()
}

// 获取
func (c *recordCache) get(id int64) (*Record, bool) {
	c.RLock()
	defer c.RUnlock()
	r, has := c.store[id]
	return r, has
}

func (c *recordCache) Get(id int64) *Record {
	r, has := c.get(id)
	if has {
		return r
	}
	r = &Record{Id: id}
	c.Set(r)
	return r
}

// 分页
func (c *recordCache) Pagination(status int, page, limit int) base_t.Pagination {
	c.RLock()
	defer c.RUnlock()
	pag := base_t.Pagination{Page: page, Limit: limit}
	results := make([]Record, 0, len(c.store))
	for _, v := range c.store {
		if v.Status == status {
			pag.Count++
			results = append(results, *v)
		}
	}
	if pag.Count == 0 {
		pag.Tidy(nil)
		return pag
	}
	sort.SliceStable(results, func(i, j int) bool {
		return results[i].Id < results[j].Id
	})
	start, end := pag.Slice()
	pag.Data = results[start:end]
	pag.Msg = "Success"
	return pag
}

// 同步到数据库中保存Sync()
func (c *recordCache) Sync(forces ...bool) error {
	var err error
	if len(forces) > 0 {
		c.modified = forces[0]
	}
	if c.modified && c.filePtr != nil {
		defer func() {
			if e := recover(); e != nil {
				err = fmt.Errorf("%v", e)
			}
		}()
		if err = c.filePtr.Truncate(0); err != nil {
			return err
		}
		if _, err = c.filePtr.Seek(0, 0); err != nil {
			return err
		}
		if err = json.NewEncoder(c.filePtr).Encode(&c.store); err != nil {
			return err
		}
		c.modified = false
	}
	return err
}
// 设置定时时间
func (c *recordCache) Interval(interval time.Duration) {
	c.interval = interval
}
// 定时同步到数据库中去
func (c *recordCache) timing() {
	if c.interval == 0 {
		c.interval = interval
	}
	ch := make(chan int, 1)
	go func() {
		ch <- 1
		for {
			<-time.After(c.interval)
			if err := c.Sync(); err != nil {
				log.Println(err)
			}
		}
	}()
	<-ch
}

// 创建一个缓存
func NewRecord() Recorder {
	obj := new(recordCache)
	_ = obj.init()
	return obj
}

// 创建一个缓存 具备自动保存到文件
func NewRecordWithSave(filename string, interval ...time.Duration) (Recorder, error) {
	obj := &recordCache{filename: filename}
	if len(interval) > 0 {
		obj.interval = interval[0]
	}
	return obj, obj.init()
}
