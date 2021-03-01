package utils

import (
	"archive/tar"
	"archive/zip"
	"compress/gzip"
	"io"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"
)

const Separator = string(os.PathSeparator)

//压缩 使用gzip压缩成tar.gz
func Tar(dest string, files ...string) error {
	if err := doTar(dest, files...); err != nil {
		if e := os.RemoveAll(dest); e != nil {
			return e
		}
		return err
	}
	return nil
}

//开始压缩
func doTar(dest string, files ...string) error {
	d, _ := os.Create(dest)
	defer d.Close()
	gw := gzip.NewWriter(d)
	defer gw.Close()
	tw := tar.NewWriter(gw)
	defer tw.Close()
	for _, file := range files {
		if strings.HasSuffix(file, "/*") {
			file = strings.TrimRight(file, "*")
			infos, err := ioutil.ReadDir(file)
			if err != nil {
				return err
			}
			for _, v := range infos {
				if err := addTar(file+v.Name(), "", tw); err != nil {
					return err
				}
			}
		} else if err := addTar(file, "", tw); err != nil {
			return err
		}
	}
	return nil
}

//遍历添加压缩
func addTar(filename, prefix string, tw *tar.Writer) error {
	file, err := os.Open(filename)
	if err != nil {
		return err
	}
	info, err := file.Stat()
	if err != nil {
		return err
	}
	if info.IsDir() {
		prefix = prefix + "/" + info.Name()
		fileInfos, err := file.Readdir(-1)
		if err != nil {
			return err
		}
		for _, fi := range fileInfos {
			if err = addTar(file.Name()+Separator+fi.Name(), prefix, tw); err != nil {
				return err
			}
		}
	} else {
		header, err := tar.FileInfoHeader(info, "")
		if err != nil {
			return err
		}
		header.Name = prefix + "/" + header.Name
		if err = tw.WriteHeader(header); err != nil {
			return err
		}
		_, err = io.Copy(tw, file)
		file.Close()
		if err != nil {
			return err
		}
	}
	return nil
}

//解压 tar.gz
func UnTar(tarFile string, testes ...string) error {
	var dest string
	if len(testes) > 0 {
		dest = testes[0]
	} else {
		dest = "./"
	}
	if !strings.HasSuffix(dest, "/") {
		dest += "/"
	}
	srcFile, err := os.Open(tarFile)
	if err != nil {
		return err
	}
	defer srcFile.Close()
	gr, err := gzip.NewReader(srcFile)
	if err != nil {
		return err
	}
	defer gr.Close()
	tr := tar.NewReader(gr)
	for {
		hdr, err := tr.Next()
		if err == io.EOF {
			break
		} else if err != nil {
			return err
		}
		filename := dest + hdr.Name
		file, err := createFile(filename)
		if err != nil {
			return err
		}
		if _, err = io.Copy(file, tr); err != nil {
			return err
		}
	}
	return nil
}

//创建文件
func createFile(name string) (*os.File, error) {
	if err := os.MkdirAll(string([]rune(name)[0:strings.LastIndex(name, Separator)]), 0755); err != nil {
		return nil, err
	}
	return os.Create(name)
}

//执行zip压缩
func doZip(dest string, files ...string) error {
	zipFile, err := os.Create(dest)
	if err != nil {
		return err
	}
	defer zipFile.Close()
	zw := zip.NewWriter(zipFile)
	defer zw.Close()
	for _, file := range files {
		if strings.HasSuffix(file, "/*") {
			file = strings.TrimRight(file, "*")
			infos, err := ioutil.ReadDir(file)
			if err != nil {
				return err
			}
			for _, v := range infos {
				if err = filepath.Walk(file+v.Name(), func(path string, info os.FileInfo, err error) error {
					if err != nil {
						return err
					}
					header, err := zip.FileInfoHeader(info)
					if err != nil {
						return err
					}
					header.Name = path
					if info.IsDir() {
						header.Name += "/"
					} else {
						header.Method = zip.Deflate
					}
					writer, err := zw.CreateHeader(header)
					if err != nil {
						return err
					}
					if !info.IsDir() {
						file, err := os.Open(path)
						if err != nil {
							return err
						}
						defer file.Close()
						_, err = io.Copy(writer, file)
					}
					return err
				}); err != nil {
					return err
				}
			}
		} else if err = filepath.Walk(file, func(path string, info os.FileInfo, err error) error {
			if err != nil {
				return err
			}
			header, err := zip.FileInfoHeader(info)
			if err != nil {
				return err
			}
			header.Name = path
			if info.IsDir() {
				header.Name += "/"
			} else {
				header.Method = zip.Deflate
			}
			writer, err := zw.CreateHeader(header)
			if err != nil {
				return err
			}
			if !info.IsDir() {
				file, err := os.Open(path)
				if err != nil {
					return err
				}
				defer file.Close()
				_, err = io.Copy(writer, file)
			}
			return err
		}); err != nil {
			return err
		}
	}
	return nil
}

//压缩zip
func Zip(dest string, files ...string) error {
	if err := doZip(dest, files...); err != nil {
		if e := os.RemoveAll(dest); e != nil {
			return e
		}
		return err
	}
	return nil
}

// 循环解压 zip
func loopUnzip(f *zip.File, fPath string) (err error) {
	if err = os.MkdirAll(filepath.Dir(fPath), os.ModePerm); err != nil {
		return err
	}
	inFile, err := f.Open()
	if err != nil {
		return err
	}
	defer inFile.Close()
	outFile, err := os.OpenFile(fPath, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, f.Mode())
	if err != nil {
		return err
	}
	defer outFile.Close()
	_, err = io.Copy(outFile, inFile)
	return err
}

//解压 zip
func Unzip(zipFile string, dest string) error {
	if dest == "" {
		dest = "./"
	}
	if !strings.HasSuffix(dest, "/") {
		dest += "/"
	}
	zipReader, err := zip.OpenReader(zipFile)
	if err != nil {
		return err
	}
	defer zipReader.Close()
	for _, f := range zipReader.File {
		fPath := filepath.Join(dest, f.Name)
		if f.FileInfo().IsDir() {
			if err := os.MkdirAll(fPath, os.ModePerm); err != nil {
				return err
			}
		} else {
			if err := loopUnzip(f, fPath); err != nil {
				return err
			}
		}
	}
	return nil
}
