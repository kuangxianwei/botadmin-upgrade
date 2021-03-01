package utils

import (
	"io/ioutil"
	"regexp"
	"strconv"
	"strings"
)

var (
	DiskExp    = regexp.MustCompile(`(?i)(?:^|\n)(\S+)\s+(\d+\S+)\s+(\S+)\s+(\S+)\s+(\S+%)\s+(\S+)`)
	EthFlowExp = regexp.MustCompile(`(?i)\s*(\S+):\s*(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)`)
)

type Disk struct {
	Filesystem string
	Size       string
	Used       string
	Avail      string
	UsePer     string
	Mounted    string
}

type EthFlow struct {
	Face       string
	Flow       string
	Bytes      uint64
	Packets    uint64
	Errs       uint64
	Drop       uint64
	Fifo       uint64
	Frame      uint64
	Compressed uint64
	Multicast  uint64
}

func Ati64(s string) (n uint64) {
	if n1, err := strconv.Atoi(s); err == nil {
		return uint64(n1)
	}
	return
}
func GetDisk(params ...string) (data []Disk) {
	if len(params) == 0 {
		params = append(params, `df -h`)
	}
	data = make([]Disk, 0, 10)
	std := Command("bash", append([]string{`-c`}, params...)...)
	if std.Code != 0 {
		return
	}
	for _, v := range DiskExp.FindAllStringSubmatch(std.Out, -1) {
		data = append(data, Disk{
			Filesystem: v[1],
			Size:       v[2],
			Used:       v[3],
			Avail:      v[4],
			UsePer:     v[5],
			Mounted:    v[6]})
	}
	return
}

func GetEthFlow() (data []EthFlow, err error) {
	r, err := ioutil.ReadFile("/proc/net/dev")
	if err != nil {
		return
	}
	res := EthFlowExp.FindAllStringSubmatch(string(r), -1)
	data = make([]EthFlow, 0, len(res)*2)
	for _, v := range res {
		data = append(data, EthFlow{
			Face:       v[1],
			Flow:       "接收",
			Bytes:      Ati64(v[2]),
			Packets:    Ati64(v[3]),
			Errs:       Ati64(v[4]),
			Drop:       Ati64(v[5]),
			Fifo:       Ati64(v[6]),
			Frame:      Ati64(v[7]),
			Compressed: Ati64(v[8]),
			Multicast:  Ati64(v[9])})
		data = append(data, EthFlow{
			Face:       v[1],
			Flow:       "发送",
			Bytes:      Ati64(v[10]),
			Packets:    Ati64(v[11]),
			Errs:       Ati64(v[12]),
			Drop:       Ati64(v[13]),
			Fifo:       Ati64(v[14]),
			Frame:      Ati64(v[15]),
			Compressed: Ati64(v[16])})
	}
	return
}

//获取firewall
func GetFirewall() (map[string][]string, error) {
	std := Command("bash", "-c", "firewall-cmd --zone=public --list-all")
	if std.Code != 0 {
		return nil, std.Err
	}
	rows := strings.Split(std.Out, "\n")
	firewallMap := make(map[string][]string, len(rows))
	for _, row := range rows {
		keyVal := strings.SplitN(row, ":", 2)
		if len(keyVal) == 2 {
			firewallMap[strings.TrimSpace(keyVal[0])] = strings.Fields(keyVal[1])
		}
	}
	return firewallMap, nil
}

//添加防火墙
func AddFirewall(kind, val string) error {
	var buf strings.Builder
	buf.Grow(116 + len(kind)*2 + len(val)*2)
	buf.WriteString("firewall-cmd --zone=public --query-")
	buf.WriteString(kind)
	buf.WriteString("=")
	buf.WriteString(val)
	buf.WriteString(" || { firewall-cmd --zone=public --add-")
	buf.WriteString(kind)
	buf.WriteString("=")
	buf.WriteString(val)
	buf.WriteString(" --permanent && firewall-cmd --reload; }")
	std := Command("bash", "-c", buf.String())
	return std.Err
}
