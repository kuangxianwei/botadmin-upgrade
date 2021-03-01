package utils

import (
	"crypto/md5"
	"crypto/sha1"
	"encoding/base64"
	"encoding/hex"
	"fmt"
	"regexp"
)

const SECRET = "wPNk4276pIgStcFEsaK4wSQUikvzC8Gv"

var (
	Md5Re = regexp.MustCompile(`^[a-z0-9]{32}$`)
)

func Sha1(str string) string {
	return fmt.Sprintf("%x", sha1.Sum([]byte(str)))
}

func Password(username string, secrets ...string) string {
	secret := SECRET
	if len(secrets) > 1 {
		secret = secrets[0]
	}
	secretSha := Sha1(secret)
	return Sha1(secretSha[8:] + Sha1(username) + secretSha[:8])
}

func Base64(input string) string {
	return base64.StdEncoding.EncodeToString([]byte(input))
}

func CreatePassword() (raw, password string) {
	raw = RandomBlend(8)
	password = Password(raw)
	return
}

// 生成32位MD5
func Md5(text string) string {
	ctx := md5.New()
	ctx.Write([]byte(text))
	return hex.EncodeToString(ctx.Sum(nil))
}

// 生成加密md5
func MD5(src, secret string) string {
	return Md5(Md5(src) + secret)
}

// 判断是md5
func IsMd5(text string) bool {
	return Md5Re.MatchString(text)
}
