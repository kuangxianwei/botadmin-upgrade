package utils

import (
	"errors"
	"io/ioutil"
	"os"
	"os/user"
	"path/filepath"
	"strconv"
	"strings"
	"syscall"
)

const (
	FileType     = "file"
	CompressType = "compress"
	FolderType   = "folder"
)

var CompressExts = []string{".tar.gz", ".zip", ".tar.xz", ".tar.bz2", ".rar"}

//复制文件到新文件
func CopyFile(srcFilename, targetFilename string) (err error) {
	var f *os.File
	if f, err = os.Open(srcFilename); err != nil {
		return err
	}
	defer f.Close()
	var stat os.FileInfo
	if stat, err = os.Stat(srcFilename); err != nil {
		return err
	}
	var bs []byte
	if bs, err = ioutil.ReadAll(f); err != nil {
		return err
	}
	return ioutil.WriteFile(targetFilename, bs, stat.Mode())
}

// 判断路径存在
func PathExists(path string) bool {
	_, err := os.Stat(path)
	if err == nil {
		return true
	}
	if os.IsNotExist(err) {
		return false
	}
	return false
}

//判断是目录
func IsDir(path string) bool {
	var fi os.FileInfo
	var err error
	if fi, err = os.Stat(path); err == nil && fi.IsDir() {
		return true
	}
	return false
}

//判断是文件
func IsFile(path string) bool {
	var fi os.FileInfo
	var err error
	if fi, err = os.Stat(path); err == nil && !fi.IsDir() {
		return true
	}
	return false
}

//创建文件夹
func Mkdir(p string) (err error) {
	p = filepath.Clean(p)
	var fi os.FileInfo
	if fi, err = os.Stat(p); err != nil || !fi.IsDir() {
		temp := p
		for i := 0; i < 10; i++ {
			temp = filepath.Dir(temp)
			if f, err := os.Stat(temp); err == nil {
				err = os.MkdirAll(p, f.Mode())
				if err != nil {
					return err
				}
				sys := f.Sys().(*syscall.Stat_t)
				return os.Chown(p, int(sys.Uid), int(sys.Gid))
			}
		}
		return errors.New("目录层次超过10次")
	}
	return
}

//是一个空目录
func IsEmptyDir(dirname string) bool {
	var f *os.File
	var err error
	if f, err = os.Open(dirname); err == nil {
		defer f.Close()
		if list, err := f.Readdirnames(-1); err == nil {
			return len(list) == 0
		}
	}
	return true
}

//获取用户信息
func GetGUInfo(sys interface{}) (info UserInfo) {
	s := sys.(*syscall.Stat_t)
	info.Gid = s.Gid
	info.Uid = s.Uid
	if g, err := user.LookupGroupId(strconv.Itoa(int(s.Gid))); err == nil {
		info.Gname = g.Name
	}
	if u, err := user.LookupId(strconv.Itoa(int(s.Uid))); err == nil {
		info.Uname = u.Username
	}
	return
}

//判断是否是压缩文件
func IsTar(name string) bool {
	name = strings.ToLower(name)
	for _, v := range CompressExts {
		if strings.HasSuffix(name, v) {
			return true
		}
	}
	return false
}

//获取文件类型
func GetFileType(v os.FileInfo) string {
	if v.IsDir() {
		return FolderType
	}
	if IsTar(v.Name()) {
		return CompressType
	}
	return FileType
}

//获取文件权限
func FileMode(path string) os.FileMode {
	if !PathExists(path) {
		path = filepath.Dir(path)
	}
	var fi os.FileInfo
	var err error
	if fi, err = os.Stat(path); err != nil {
		return 0666
	}
	return fi.Mode()
}

//克隆文件属性
func CloneFileAttr(sourceFile, targetFile string) error {
	var fi os.FileInfo
	var err error
	if fi, err = os.Stat(sourceFile); err != nil {
		return err
	}
	sys := fi.Sys().(*syscall.Stat_t)
	if err = os.Chown(targetFile, int(sys.Uid), int(sys.Gid)); err != nil {
		return err
	}
	return os.Chmod(targetFile, fi.Mode())
}
