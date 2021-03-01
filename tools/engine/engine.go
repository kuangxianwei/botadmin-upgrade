package engine

import (
	"botadmin/tools/utils"
	"errors"
	_ "github.com/go-sql-driver/mysql"
	"github.com/go-xorm/xorm"
	_ "github.com/mattn/go-sqlite3"
	"os"
	"time"
	"xorm.io/core"
)

type Engine struct {
	*xorm.Engine
	*Config
}

//初始化采集数据库
func (e *Engine) init(driverName string) (err error) {
	if e.Config == nil {
		return errors.New("数据库配置信息为空")
	}
	e.Config.DriverName = driverName
	if e.Engine, err = xorm.NewEngine(driverName, e.Config.GetSource()); err != nil {
		return err
	}
	e.Engine.SetMaxOpenConns(2000)
	return nil
}

// 设置debug
func (e *Engine) Debug(show bool) {
	if e.Engine != nil {
		e.Engine.ShowSQL(show) //显执行语句
		e.Engine.Logger().SetLevel(core.LOG_DEBUG)
	}
}

// 设置缓存
func (e *Engine) Cache(cache core.Cacher) {
	if e.Engine != nil {
		e.Engine.SetDefaultCacher(cache)
	}
}

//获取clos
func (e *Engine) Cols(obj interface{}) []string {
	if e.Engine == nil {
		return nil
	}
	return e.Engine.TableInfo(obj).ColumnsSeq()
}

//重置数据库
func (e *Engine) Reset(tableNames ...string) (err error) {
	if e.Engine == nil || e.Config == nil {
		return errors.New("数据库引擎为nil")
	}
	e.Config.DriverName = e.Engine.DriverName()
	switch e.Config.DriverName {
	case "sqlite3":
		fileName := e.GetSource()
		if err = os.Rename(fileName, fileName+"."+utils.StrByTimestamp(time.Now().Unix(), utils.Second)); err != nil {
			return err
		}
	case "mysql":
		if len(tableNames) == 0 {
			return errors.New("请输入数据表名称")
		}
		var db RootDb
		if db, err = NewRoot(""); err != nil {
			return err
		}
		defer db.Close()
		for _, tableName := range tableNames {
			if _, err = db.Engine().Exec("TRUNCATE " + e.Config.Dbname + "." + tableName); err != nil {
				return err
			}
		}
	default:
		return errors.New("驱动名称\"" + e.Engine.DriverName() + "\"不支持")
	}
	return e.init(e.Config.DriverName)
}

// 新建
func New(driverName string, cfg Config) (*Engine, error) {
	obj := &Engine{Config: &cfg}
	return obj, obj.init(driverName)
}
