package utils

import (
	"bufio"
	"bytes"
	"os"
)

//bytes 转 读接口
func BytesToReader(data []byte) (rd *bufio.Reader) {
	rd = bufio.NewReader(bytes.NewBuffer(EnUTF8(data)))
	// check the BOM
	head, err := rd.Peek(3)
	if err == nil && head[0] == 239 && head[1] == 187 && head[2] == 191 {
		for i := 1; i <= 3; i++ {
			_, _ = rd.ReadByte()
		}
	}
	return rd
}

//文件对象 转 读接口
func FileToReader(file *os.File) (rd *bufio.Reader) {
	rd = bufio.NewReader(file)
	// check the BOM
	head, err := rd.Peek(3)
	if err == nil && head[0] == 239 && head[1] == 187 && head[2] == 191 {
		for i := 1; i <= 3; i++ {
			_, _ = rd.ReadByte()
		}
	}
	return rd
}
