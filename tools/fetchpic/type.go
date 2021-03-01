package fetchpic

import (
	"errors"
	"net/http"
)

var ImgExtMap = map[string]string{
	"image/x-icon": "icon",
	"image/bmp":    "bmp",
	"image/gif":    "gif",
	"image/webp":   "webp",
	"image/png":    "png",
	"image/jpeg":   "jpg",
	"image/jpg":    "jpg",
}

func GetExt(bs []byte) (string, error) {
	if len(bs) > 512 {
		bs = bs[:512]
	}
	if ext, ok := ImgExtMap[http.DetectContentType(bs)]; ok {
		return ext, nil
	}
	return "", errors.New("invalid image type")
}
