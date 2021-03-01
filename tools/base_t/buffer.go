package base_t

import (
	"bytes"
	"encoding/base64"
	"errors"
	"fmt"
	"log"
	"net/url"
	"runtime"
)

/*buf*/
type Buffer struct {
	bytes.Buffer
}

func (b *Buffer) MarshalJSON() ([]byte, error) {
	if b == nil {
		return []byte("null"), nil
	}
	return []byte(`"` + base64.StdEncoding.EncodeToString(b.Buffer.Bytes()) + `"`), nil
}
func (b *Buffer) UnmarshalJSON(bs []byte) error {
	if b == nil {
		return errors.New("base_t.Buffer: UnmarshalJSON on nil pointer")
	}
	b.Reset()
	count := len(bs)
	if count >= 2 && bs[0] == '"' && bs[count-1] == '"' {
		bs = bs[1 : len(bs)-1]
	}
	if len(bs) == 0 {
		return nil
	}
	bs, err := base64.StdEncoding.DecodeString(string(bs))
	if err != nil {
		return err
	}
	b.Buffer.Write(bs)
	return nil
}

//解析来自表单的数据
func (b *Buffer) ParseForm(form url.Values) error {
	if b == nil {
		return errors.New("Buffer.ParseForm 无效的内存地址")
	}
	if values := form["log"]; len(values) > 0 {
		if _, err := b.WriteString(values[0]); err != nil {
			return err
		}
	}
	return nil
}

//加载来自数据库的数据到结构体中
func (b *Buffer) FromDB(bs []byte) error {
	b.Reset()
	b.Grow(len(bs))
	_, err := b.Buffer.Write(bs)
	return err
}

//把结构体中的数据转为bytes
func (b *Buffer) ToDB() ([]byte, error) {
	if b == nil {
		return nil, nil
	}
	return b.Bytes(), nil
}

//写入错误
func (b *Buffer) Error(err error, msg ...string) error {
	if err != nil {
		for _, v := range msg {
			if _, e := b.WriteString(v); e != nil {
				log.Println(e.Error())
			}
		}
		if len(msg) > 0 {
			b.Buffer.WriteString(" ")
		}
		if _, file, line, ok := runtime.Caller(1); ok {
			if _, e := b.Buffer.WriteString(fmt.Sprintf("File => %s, Line => %d, Error: %s", file, line, err.Error())); e != nil {
				log.Println(e.Error())
			}
		}
		_ = b.Buffer.WriteByte('\n')
	}
	return err
}

//写人 字符串
func (b *Buffer) Write(a ...string) {
	for _, v := range a {
		if _, e := b.Buffer.WriteString(v); e != nil {
			log.Println(e.Error())
		}
	}
	b.Buffer.WriteByte('\n')
}
