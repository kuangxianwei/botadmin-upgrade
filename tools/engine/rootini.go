package engine

import (
	"botadmin/tools/config"
	"botadmin/tools/utils"
	"fmt"
)

const (
	MyCnf = "./data/.my.cnf"
)

var (
	RootIni = new(rootIni)
)

type rootIni struct {
	Port      string           `json:"port" form:"port"`
	Socket    string           `json:"socket" form:"socket"`
	Password  string           `json:"password" form:"password"`
	Password2 string           `json:"password2" form:"password2"`
	Cfg       config.Configure `json:"-" form:"-"`
}

//加载
func (i *rootIni) Load() error {
	var err error
	if i.Cfg, err = config.New("ini", MyCnf); err != nil {
		return err
	}
	i.Password = i.Cfg.String("client::password")
	i.Port = i.Cfg.String("client::port")
	i.Socket = i.Cfg.String("client::socket")
	var changed bool
	if i.Password == "" {
		i.Password = "botadmin.cn"
		if err = i.Cfg.Set("client::password", i.Password); err != nil {
			return err
		}
		changed = true
	}
	if i.Port == "" {
		i.Port = "3306"
		if err := i.Cfg.Set("client::port", i.Port); err != nil {
			return err
		}
		changed = true
	}
	if i.Socket == "" {
		i.Socket = "/tmp/mysql.sock"
		if err := i.Cfg.Set("client::socket", i.Socket); err != nil {
			return err
		}
		changed = true
	}
	if changed {
		return i.Cfg.SaveConfigFile(MyCnf)
	}
	return nil
}

//保存
func (i *rootIni) Save() error {
	return i.Cfg.SaveConfigFile(MyCnf)
}

//格式化输出HTML
func (i *rootIni) FormHtml() string {
	html, _ := utils.ToForm(i)
	return html
}

/*强制重置数据库root密码 忘记密码的情况下*/
func (i *rootIni) ResetPassword() (err error) {
	if !utils.PatternPassword.MatchString(i.Password) {
		return fmt.Errorf("密码\"%s\"格式不合法", i.Password)
	}
	if _, err = utils.ResetRootPwd(i.Password); err != nil {
		return err
	}
	if i.Cfg == nil {
		if i.Cfg, err = config.New("ini", MyCnf); err != nil {
			return err
		}
	}
	if err = i.Cfg.Set("client::password", i.Password); err != nil {
		return err
	}
	if err = i.Save(); err != nil {
		return err
	}
	return RootIni.Load()
}

/*修改数据库root密码 已知密码的情况下*/
func (i *rootIni) Modify() error {
	obj := new(rootIni)
	if err := obj.Load(); err != nil {
		return err
	}
	if i.Password == obj.Password {
		return nil
	}
	if !utils.PatternName.MatchString(i.Password) {
		return fmt.Errorf("密码\"%s\"格式不合法", i.Password)
	}
	db, err := NewRoot(obj.Password)
	if err != nil {
		return err
	}
	if err = db.Password(i.Password); err != nil {
		return err
	}
	if i.Cfg == nil {
		if i.Cfg, err = config.New("ini", MyCnf); err != nil {
			return err
		}
	}
	if err = i.Cfg.Set("client::password", i.Password); err != nil {
		return err
	}
	if err = i.Save(); err != nil {
		return err
	}
	return RootIni.Load()
}

// 新建
func NewRootIni() *rootIni {
	return new(rootIni)
}
