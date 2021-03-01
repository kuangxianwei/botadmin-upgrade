package engine

import (
	"database/sql"
	_ "github.com/go-sql-driver/mysql"
	"strings"
)

// 新建一个MySQL连接
func NewMysqlConn(cfg SQL) (*sql.DB, error) {
	return sql.Open("mysql", cfg.GetSource())
}

var excludeDatabases = []string{"information_schema", "botadmin", "mysql", "performance_schema", "sys"}

func InDatabases(database *string) bool {
	for _, v := range excludeDatabases {
		if *database = strings.TrimSpace(*database); *database == v {
			return true
		}
	}
	return false
}

//判断包含列表中 string
func InSliceStr(ele string, l []string) bool {
	for _, v := range l {
		if v == ele {
			return true
		}
	}
	return false
}
