package utils

import (
	"io/ioutil"
	"regexp"
	"strconv"
)

var memExp = regexp.MustCompile(`([A-Z]\w+):\s+(\d+)\s*kB`)

type MemInfoT struct {
	MemTotal     float64
	MemFree      float64
	Buffers      float64
	Cached       float64
	Active       float64
	VmallocTotal float64
	VmallocUsed  float64
	VmallocChunk float64
	SwapCached   float64
	SwapTotal    float64
	SwapFree     float64
}

func AtoIntFloat64(s string) float64 {
	if n, err := strconv.Atoi(s); err == nil {
		return float64(n)
	}
	return 0
}
func MemInfo() (meminfo *MemInfoT, err error) {
	data, err := ioutil.ReadFile("/proc/meminfo")
	if err != nil {
		return
	}
	meminfo = new(MemInfoT)
	for _, v := range memExp.FindAllStringSubmatch(string(data), -1) {
		if len(v) != 3 {
			continue
		}
		switch v[1] {
		case "MemTotal":
			meminfo.MemTotal = AtoIntFloat64(v[2]) * 1024
		case "MemFree":
			meminfo.MemFree = AtoIntFloat64(v[2]) * 1024
		case "Buffers":
			meminfo.Buffers = AtoIntFloat64(v[2]) * 1024
		case "Cached":
			meminfo.Cached = AtoIntFloat64(v[2]) * 1024
		case "Active":
			meminfo.Active = AtoIntFloat64(v[2]) * 1024
		case "VmallocTotal":
			meminfo.VmallocTotal = AtoIntFloat64(v[2]) * 1024
		case "VmallocUsed":
			meminfo.VmallocUsed = AtoIntFloat64(v[2]) * 1024
		case "VmallocChunk":
			meminfo.VmallocChunk = AtoIntFloat64(v[2]) * 1024
		case "SwapCached":
			meminfo.SwapCached = AtoIntFloat64(v[2]) * 1024
		case "SwapTotal":
			meminfo.SwapTotal = AtoIntFloat64(v[2]) * 1024
		case "SwapFree":
			meminfo.SwapFree = AtoIntFloat64(v[2]) * 1024
		}
	}
	return
}
