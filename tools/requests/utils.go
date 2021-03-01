package requests

import (
	"fmt"
	"golang.org/x/net/html/charset"
	"io"
	"mime/multipart"
	"net/textproto"
	"os"
	"path/filepath"
	"strings"
)

var (
	ImgTypeMap = map[string]string{
		".tif":  "image/tiff",
		".fax":  "image/fax",
		".gif":  "image/gif",
		".ico":  "image/x-icon",
		".jfif": "image/jpeg",
		".jpe":  "image/jpeg",
		".jpeg": "image/jpeg",
		".jpg":  "image/jpeg",
		".net":  "image/pnetvue",
		".png":  "image/png",
		".rp":   "image/vnd.rn-realpix",
		".tiff": "image/tiff",
		".wbmp": "image/vnd.wap.wbmp",
	}
	quoteEscape = strings.NewReplacer("\\", "\\\\", `"`, "\\\"")
)

//替换
func escapeQuotes(s string) string {
	return quoteEscape.Replace(s)
}

//创建一个multipart 文件
func CreateFormFile(w *multipart.Writer, fieldName, filename string) (io.Writer, error) {
	h := make(textproto.MIMEHeader)
	h.Set("Content-Disposition",
		fmt.Sprintf(`form-data; name="%s"; filename="%s"`,
			escapeQuotes(fieldName), escapeQuotes(filepath.Base(filename))))
	contentType := "application/octet-stream"
	if t, ok := ImgTypeMap[filepath.Ext(filename)]; ok {
		contentType = t
	}
	h.Set("Content-Type", contentType)
	return w.CreatePart(h)
}

//复制文件
func copyFile(part io.Writer, filename string) error {
	file, err := os.Open(filename)
	if err != nil {
		return err
	}
	defer file.Close()
	if _, err = io.Copy(part, file); err != nil {
		return err
	}
	return nil
}

//自动识别编码
func decoderAuto(b []byte) []byte {
	e, _, _ := charset.DetermineEncoding(b, "")
	if bs, err := e.NewDecoder().Bytes(b); err == nil {
		return bs
	}
	return b
}
