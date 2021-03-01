package openCC

import (
	"fmt"
	"path/filepath"
	"strings"
)

const (
	dictDir = "dictionary"
)

var Dirname = "./tools/openCC"

// Group holds a sequence of dicts
type Group struct {
	Files []string
	Dicts []*dict
}

func (g *Group) String() string {
	return fmt.Sprintf("%+v", g.Files)
}

// OpenCC contains the converter
type OpenCC struct {
	Config
	DictChains []*Group
}

// New construct an instance of OpenCC.
//
// Supported conversions: s2t, t2s, s2tw, tw2s, s2hk, hk2s, s2twp, tw2sp, t2tw, t2hk

func New(conversion string) (*OpenCC, error) {
	var cc *OpenCC
	var has bool
	if cc, has = Cache.Get(conversion); has && len(cc.DictChains) > 0 {
		return cc, nil
	}
	var cfg Config
	if cfg, has = conversionMap[conversion]; !has {
		return nil, fmt.Errorf("%s not valid", conversion)
	}
	cc = &OpenCC{Config: cfg}
	if err := cc.init(); err != nil {
		return nil, err
	}
	Cache.Add(cc)
	return cc, nil
}

// Convert string from Simplified Chinese to Traditional Chinese or vice versa
func (cc *OpenCC) Convert(in string) (string, error) {
	var token string
	for _, group := range cc.DictChains {
		r := []rune(in)
		var tokens []string
		for i := 0; i < len(r); {
			s := r[i:]
			max := 0
			for _, d := range group.Dicts {
				ret, err := d.PrefixMatch(string(s))
				if err != nil {
					return "", err
				}
				if len(ret) > 0 {
					o := ""
					for k, v := range ret {
						if len(k) > max {
							max = len(k)
							token = v[0]
							o = k
						}
					}
					i += len([]rune(o))
					break
				}
			}
			if max == 0 { //no match
				token = string(r[i])
				i++
			}
			tokens = append(tokens, token)
		}
		in = strings.Join(tokens, "")
	}
	return in, nil
}
func (cc *OpenCC) ConvertPtr(inPtr *string) error {
	text, err := cc.Convert(*inPtr)
	if err != nil {
		return err
	}
	*inPtr = text
	return nil
}

// 初始化
func (cc *OpenCC) init() error {
	for _, d := range cc.ConversionChain {
		group, err := cc.addDictChain(d)
		if err != nil {
			return err
		}
		cc.DictChains = append(cc.DictChains, group)
	}
	return nil
}

// 添加
func (cc *OpenCC) addDictChain(d Dict) (*Group, error) {
	ret := &Group{}
	switch d.Type {
	case "group":
		for _, dt := range d.Dicts {
			group, err := cc.addDictChain(dt)
			if err != nil {
				return nil, err
			}
			ret.Files = append(ret.Files, group.Files...)
			ret.Dicts = append(ret.Dicts, group.Dicts...)
		}
	case "txt":
		daDict, err := BuildFromFile(filepath.Join(Dirname, dictDir, d.File))
		if err != nil {
			return nil, err
		}
		ret.Files = append(ret.Files, d.File)
		ret.Dicts = append(ret.Dicts, daDict)
	default:
		return nil, fmt.Errorf("type should be txt or group")
	}
	return ret, nil
}

// 清除缓存
func (cc *OpenCC) ClearCached() {
	Cache.Clear()
}

// 删除当前缓存
func (cc *OpenCC) DelCached() {
	Cache.Del(cc.Name)
}
