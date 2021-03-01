package engine

import (
	"bytes"
	"database/sql"
	"errors"
	_ "github.com/go-sql-driver/mysql"
	"strings"
	"sync"
)

const (
	DatabaseName = "botadmin"
)

var (
	/*数据库编码*/
	Charsets = map[string]string{
		"utf8":   "` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;\n",
		"gbk":    "` DEFAULT CHARACTER SET gbk COLLATE gbk_chinese_ci;\n",
		"latin1": "` DEFAULT CHARACTER SET latin1 COLLATE latin1_general_ci;\n",
	}
)

type (
	rootDb struct {
		db *sql.DB
		sync.Mutex
		version string
	}
	RootDb interface {
		Version() (string, error)
		Close()
		Users() ([]string, error)
		UserHosts(user string) ([]string, error)
		Databases() ([]string, error)
		ExistDatabase(database string) (bool, error)
		ExistUser(user string) (bool, error)
		Engine() *sql.DB
		AddDatabase(qs ...SQL) error
		DelDatabase(qs ...SQL) error
		Modify(oldSql SQL, newSql SQL) ([]string, error) // 修改用户名或者密码
		Password(password string) error                  // 修改root密码
	}
)

// 版本
func (m *rootDb) Version() (string, error) {
	if m.version == "" {
		row := m.db.QueryRow("SELECT version();")
		if err := row.Err(); err != nil {
			return "", err
		}
		if err := row.Scan(&m.version); err != nil {
			return "", err
		}
		m.version = strings.SplitN(m.version, "-", 2)[0]
	}
	return m.version, nil
}

// 关闭连接
func (m *rootDb) Close() {
	if m.db != nil {
		_ = m.db.Close()
		m.db = nil
	}
}

// 连接
func (m *rootDb) conn(password string) error {
	var err error
	if password == "" {
		if RootIni == nil {
			if err = RootIni.Load(); err != nil {
				return err
			}
		}
		password = RootIni.Password
	}
	m.db, err = sql.Open("mysql", (&Config{
		DriverName: "mysql",
		Username:   "root",
		Password:   password,
		Charset:    "utf8",
		Hosts:      []string{"localhost"},
		Params:     map[string]string{"multiStatements": "true"},
	}).GetSource())
	if err != nil {
		return err
	}
	return m.db.Ping()
}

// 输出engine
func (m *rootDb) Engine() *sql.DB {
	return m.db
}

// 获取全部数据库名称
func (m *rootDb) Databases() ([]string, error) {
	rows, err := m.db.Query("SHOW DATABASES;")
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var rs []string
	for rows.Next() {
		var database string
		if err = rows.Scan(&database); err != nil {
			return nil, err
		}
		if !InDatabases(&database) {
			rs = append(rs, database)
		}
	}
	return rs, nil
}

// 获取全部数据库用户名
func (m *rootDb) Users() ([]string, error) {
	rows, err := m.db.Query("SELECT user FROM mysql.user;")
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var rs []string
	for rows.Next() {
		var user string
		if err = rows.Scan(&user); err != nil {
			return nil, err
		}
		user = strings.TrimSpace(user)
		if user != "root" && user != DatabaseName {
			rs = append(rs, user)
		}
	}
	return rs, nil
}

// 显示用户的所有host
func (m *rootDb) UserHosts(user string) ([]string, error) {
	var rows, err = m.db.Query("SELECT Host FROM mysql.user WHERE User=?;", user)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var rs []string
	for rows.Next() {
		var host string
		if err = rows.Scan(&host); err != nil {
			return nil, err
		}
		host = strings.TrimSpace(host)
		rs = append(rs, host)
	}
	return rs, nil
}

// 判断数据库名称存在
func (m *rootDb) ExistDatabase(database string) (bool, error) {
	row := m.db.QueryRow("SELECT COUNT(*) FROM information_schema.SCHEMATA WHERE SCHEMA_NAME = ?;", database)
	if err := row.Err(); err != nil {
		return false, err
	}
	var has bool
	if err := row.Scan(&has); err != nil {
		return false, err
	}
	return has, nil
}

// 判断数据库用户名存在
func (m *rootDb) ExistUser(user string) (bool, error) {
	var row = m.db.QueryRow("SELECT COUNT(*) FROM mysql.user WHERE User=?;", user)
	if err := row.Err(); err != nil {
		return false, err
	}
	var has bool
	if err := row.Scan(&has); err != nil {
		return false, err
	}
	return has, nil
}

/*构造 添加命令*/
func (m *rootDb) buildAddQuery(q SQL, buf *bytes.Buffer) error {
	existHosts, err := m.UserHosts(q.GetUsername())
	if err != nil {
		return err
	}
	charset := Charsets[q.GetCharset()] //"utf8" "gbk" "latin1"
	hosts := q.GetHosts()
	for i := 0; i < len(hosts); i++ {
		if InSliceStr(hosts[i], existHosts) {
			hosts = append(hosts[:i], hosts[i+1:]...)
			i--
		}
	}
	//创建 用户
	for _, host := range hosts {
		buf.WriteString("CREATE USER '")
		buf.WriteString(q.GetUsername())
		buf.WriteString("'@'")
		buf.WriteString(host)
		buf.WriteString("' IDENTIFIED BY '")
		buf.WriteString(q.GetPassword())
		buf.WriteString("';\n")
	}
	//绑定数据库
	if strings.HasPrefix(m.version, "8.0.") {
		for _, host := range hosts {
			buf.WriteString("GRANT USAGE ON *.* TO '")
			buf.WriteString(q.GetUsername()) // 用户名
			buf.WriteString("'@'")
			buf.WriteString(host)
			buf.WriteString("';\n")
		}
	} else {
		for _, host := range hosts {
			buf.WriteString("GRANT USAGE ON *.* TO '")
			buf.WriteString(q.GetUsername()) // 用户名
			buf.WriteString("'@'")
			buf.WriteString(host)
			buf.WriteString("' IDENTIFIED BY '")
			buf.WriteString(q.GetPassword())
			buf.WriteString("';\n")
		}
	}
	buf.WriteString("CREATE DATABASE IF NOT EXISTS `")
	buf.WriteString(q.GetDbname()) // 数据库名称
	buf.WriteString(charset)
	//赋给用户权限
	for _, host := range hosts {
		buf.WriteString("GRANT ALL PRIVILEGES ON `")
		buf.WriteString(q.GetDbname()) // 数据库名
		buf.WriteString("`.* TO '")
		buf.WriteString(q.GetUsername())
		buf.WriteString("'@'")
		buf.WriteString(host)
		buf.WriteString("';\n")
	}
	return nil
}

// 添加数据库和用户
func (m *rootDb) AddDatabase(qs ...SQL) error {
	m.Lock()
	defer m.Unlock()
	var err error
	if _, err = m.Version(); err != nil {
		return err
	}
	var buf bytes.Buffer
	buf.Grow(1024)
	for _, c := range qs {
		if err = m.buildAddQuery(c, &buf); err != nil {
			return err
		}
	}
	if buf.Len() > 0 {
		buf.WriteString("FLUSH PRIVILEGES;\n")
		_, err = m.db.Exec(buf.String())
	}
	return err
}

// 删除数据库和用户
func (m *rootDb) DelDatabase(qs ...SQL) error {
	m.Lock()
	defer m.Unlock()
	var err error
	var buf strings.Builder
	buf.Grow(1024)
	for _, q := range qs {
		var hosts []string
		if hosts, err = m.UserHosts(q.GetUsername()); err != nil {
			return err
		}
		for _, v := range hosts {
			buf.WriteString("DROP USER '")
			buf.WriteString(q.GetUsername())
			buf.WriteString("'@'")
			buf.WriteString(v)
			buf.WriteString("';\n")
		}
		buf.WriteString("DROP DATABASE IF EXISTS `")
		buf.WriteString(q.GetDbname())
		buf.WriteString("`;\n")
		buf.WriteString("DROP DATABASE IF EXISTS `")
		buf.WriteString(q.GetUsername())
		buf.WriteString("`;\n")
	}
	if buf.Len() > 0 {
		buf.WriteString("FLUSH PRIVILEGES;\n")
		_, err = m.db.Exec(buf.String())
	}
	return err
}

// 修改密码
func (m *rootDb) Modify(oldSql SQL, newSql SQL) ([]string, error) {
	var err error
	if _, err = m.Version(); err != nil {
		return nil, err
	}
	var cols []string
	var buf bytes.Buffer
	if newSql.GetPassword() != "" && newSql.GetPassword() != oldSql.GetPassword() {
		var hosts []string
		if hosts, err = m.UserHosts(oldSql.GetUsername()); err != nil {
			return nil, err
		}
		cols = append(cols, "password")
		switch true {
		case strings.HasPrefix(m.version, "5.7."):
			buf.WriteString("UPDATE mysql.user SET authentication_string=PASSWORD('")
			buf.WriteString(newSql.GetPassword())
			buf.WriteString("') WHERE User='")
			buf.WriteString(oldSql.GetUsername())
			buf.WriteString("';\n")
		case strings.HasPrefix(m.version, "8.0."):
			for _, host := range hosts {
				buf.WriteString("SET PASSWORD FOR '")
				buf.WriteString(oldSql.GetUsername())
				buf.WriteString("'@'")
				buf.WriteString(host)
				buf.WriteString("' = '")
				buf.WriteString(newSql.GetPassword())
				buf.WriteString("';\n")
			}
		default:
			buf.WriteString("UPDATE mysql.user SET Password=PASSWORD('")
			buf.WriteString(newSql.GetPassword())
			buf.WriteString("') WHERE User='")
			buf.WriteString(oldSql.GetUsername())
			buf.WriteString("';\n")
		}
	}
	if newSql.GetUsername() != "" && oldSql.GetUsername() != newSql.GetUsername() {
		cols = append(cols, "username")
		buf.WriteString("UPDATE mysql.user SET User = '")
		buf.WriteString(newSql.GetUsername())
		buf.WriteString("' WHERE User ='")
		buf.WriteString(oldSql.GetUsername())
		buf.WriteString("';\n")
		buf.WriteString("UPDATE mysql.db SET User = '")
		buf.WriteString(newSql.GetUsername())
		buf.WriteString("' WHERE User ='")
		buf.WriteString(oldSql.GetUsername())
		buf.WriteString("';\n")
	}
	if buf.Len() > 0 {
		buf.WriteString("FLUSH PRIVILEGES;\n")
		_, err = m.db.Exec(buf.String())
	}
	return cols, err
}

// 修改root密码
func (m *rootDb) Password(password string) error {
	if password == "" {
		return errors.New("新密码不可以为空")
	}
	_, err := m.Modify(&Config{Username: "root"}, &Config{Password: password})
	return err
}

func NewRoot(password string) (RootDb, error) {
	db := new(rootDb)
	if err := db.conn(password); err != nil {
		return nil, err
	}
	return db, nil
}
