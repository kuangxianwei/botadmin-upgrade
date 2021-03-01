package utils

import "github.com/shirou/gopsutil/cpu"

func GetCPUInfo() cpu.InfoStat {
	info, err := cpu.Info()
	if err != nil || len(info) < 1 {
		return cpu.InfoStat{}
	}
	return info[0]
}
