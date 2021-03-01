package utils

import (
	"bytes"
	"io/ioutil"
	"net"
	"net/http"
	"strconv"
	"strings"
)

//获取全部IP列表
func GetIps() (ips []string) {
	if addrs, err := net.InterfaceAddrs(); err == nil {
		ips = make([]string, 0, len(addrs))
		for _, address := range addrs {
			// 检查ip地址判断是否回环地址
			if ipnet, ok := address.(*net.IPNet); ok && !ipnet.IP.IsLoopback() && ipnet.IP.To4() != nil {
				ips = append(ips, ipnet.IP.String())
			}
		}
	}
	if len(ips) == 0 {
		return []string{"127.0.0.1"}
	}
	return ips
}

//获取公网IP
func GetPulicIP() string {
	if r, err := http.Get("http://ipinfo.io/ip"); err == nil {
		b, _ := ioutil.ReadAll(r.Body)
		ip := string(bytes.TrimSpace(b))
		if _ip := net.ParseIP(ip); _ip != nil {
			return ip
		}
	}
	return "0.0.0.0"
}

func isLocal(s string) bool {
	if strings.HasPrefix(s, "10.") || strings.HasPrefix(s, "192.168.") || s == "127.0.0.1" || s == "0.0.0.0" {
		return true
	}
	if strings.HasPrefix(s, "172.") {
		if ls := strings.Split(s, "."); len(ls) > 3 {
			i, _ := strconv.Atoi(ls[1])
			if i > 15 && i < 32 {
				return true
			}
		}
	}
	return false
}

//local ips
func GetLocalIps() []string {
	ips := GetIps()
	for i := 0; i < len(ips); i++ {
		if isLocal(ips[i]) {
			ips = append(ips[:i], ips[i+1:]...)
			i--
		}
	}
	return ips
}
