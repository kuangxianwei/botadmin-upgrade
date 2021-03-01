package config

import "errors"

//全部转换器的map
var Adapters = make(map[string]adapter)

//转换器
type adapter func(configFile string) (Configure, error)

//配置文件解析接口
type Configure interface {
	Set(key, val string) error   //support section::key type in given key when using ini type.
	String(key string) string    //support section::key type in key string when using ini and json type; Int,Int64,Bool,Float,DIY are same.
	Strings(key string) []string //get string slice
	Int(key string) (int, error)
	Int64(key string) (int64, error)
	Bool(key string) (bool, error)
	Float(key string) (float64, error)
	DefaultString(key string, defaultVal string) string      // support section::key type in key string when using ini and json type; Int,Int64,Bool,Float,DIY are same.
	DefaultStrings(key string, defaultVal []string) []string //get string slice
	DefaultInt(key string, defaultVal int) int
	DefaultInt64(key string, defaultVal int64) int64
	DefaultBool(key string, defaultVal bool) bool
	DefaultFloat(key string, defaultVal float64) float64
	DIY(key string) (interface{}, error)
	GetSection(section string) (map[string]string, error)
	SaveConfigFile(filename string) error
}

//注册到总转换器中
func register(adapterName string, obj adapter) {
	if _, ok := Adapters[adapterName]; ok || len(adapterName) == 0 {
		panic(adapterName + " 配置名称已经存在或名称不合法")
	}
	Adapters[adapterName] = obj
}

//新建
func New(adapterName, configFile string) (Configure, error) {
	if adapterFunc, ok := Adapters[adapterName]; ok {
		return adapterFunc(configFile)
	}
	return nil, errors.New(adapterName + " 转换器不存在")
}
