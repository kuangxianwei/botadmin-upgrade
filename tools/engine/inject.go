package engine

import (
	"errors"
	"github.com/go-xorm/xorm"
	"log"
)

//接口
type Table interface {
	//设置IDS
	SetIds(ids ...int64)
	//设置ID
	SetId(id int64)
	//设置数据库 Session
	Session(s *xorm.Session)
	//插入数据
	Insert() (int64, error)
	//更新指定
	Update(cols ...string) (int64, error)
	//删除
	Del() (int64, error)
}

//转换器
type Adapter func(cfg map[string]interface{}) Table

//所有已经注册到转换器的实例
var AdapterMap = make(map[string]Adapter)

//把实例注册到map中
func Register(tableName string, obj Adapter) {
	if obj == nil || len(tableName) == 0 {
		log.Fatalln("engine: Register adapter is nil")
	}
	if _, has := AdapterMap[tableName]; has {
		log.Fatalln("engine: Register called twice for adapter " + tableName)
	}
	AdapterMap[tableName] = obj
}

func NewTable(tableName string, cfg map[string]interface{}) (Table, error) {
	if obj, has := AdapterMap[tableName]; has {
		return obj(cfg), nil
	}
	return nil, errors.New("website: unknown adapter name")
}
