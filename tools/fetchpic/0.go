package fetchpic

import (
	"botadmin/tools/utils"
	"bytes"
	"errors"
	"hash/crc32"
	"path/filepath"
	"sort"
	"strconv"
)

var (
	Fetches = make(fetches)
)

//输出主接口
type Fetcher interface {
	QueryData() error
	Results() []Picture // 结果
	Save()              // 保存
	Errors() []error
	Success() []Picture
	SetBuf(buf *bytes.Buffer)
}
type (
	// 配置
	Config struct {
		Engine   string             `json:"engine" form:"engine"`
		Keywords []string           `json:"keywords" form:"keywords" sep:"\n"`
		Begin    int                `json:"begin" form:"begin"`
		End      int                `json:"end" form:"end"`
		Limit    int                `json:"limit" form:"limit"` // 限制
		Delay    int64              `json:"delay" form:"delay"`
		Dirname  string             `json:"dirname" json:"dirname"` // 目录
		Thread   int                `json:"thread" json:"thread"`   // 线程
		results  map[string]Picture `form:"-"`
		Errs     []error            `json:"-" form:"-"`
		Success  []Picture          `json:"-" form:"-"`
		Buf      *bytes.Buffer      `json:"-" form:"-"`
	}
	// 转换器
	Fetch struct {
		Sort  int    // 排序
		Name  string // 名称
		Alias string // 别名
		Func  func(c Config) Fetcher
	}
	// 转换器集合map
	fetches map[string]Fetch
	Picture struct {
		Url      string
		Filename string
		Hash     uint32
	}
)

var exts = []string{".jpg", ".gif", ".png", ".jpeg"}

func (p *Picture) Tidy() bool {
	ext := filepath.Ext(p.Url)
	if utils.InSliceStr(ext, exts) {
		p.Hash = crc32.ChecksumIEEE([]byte(p.Url))
		p.Filename = strconv.FormatUint(uint64(p.Hash), 32) + ext
		return true
	}
	return false
}

// 列表
func (f fetches) Slice() []Fetch {
	fs := make([]Fetch, 0, len(f))
	for _, v := range f {
		fs = append(fs, v)
	}
	sort.SliceStable(fs, func(i, j int) bool {
		return fs[i].Sort < fs[j].Sort
	})
	return fs
}

// 获取
func (f fetches) Get(name string) (Fetch, bool) {
	obj, ok := f[name]
	return obj, ok
}

//把实例注册到总的转换器中
func (f fetches) Register(instance Fetch) (err error) {
	if instance.Func == nil || instance.Name == "" {
		return errors.New("fetches: Register instance is nil")
	}
	if _, ok := f[instance.Name]; ok {
		return errors.New("fetches: Register called twice for adapter " + instance.Name)
	}
	f[instance.Name] = instance
	return nil
}

func New(c Config) (Fetcher, error) {
	f, ok := Fetches.Get(c.Engine)
	if !ok {
		return nil, errors.New(c.Engine + " 不存在或者 实例为nil")
	}
	return f.Func(c), nil
}
