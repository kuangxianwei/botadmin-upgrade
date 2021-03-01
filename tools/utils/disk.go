package utils

import "syscall"

type DiskStatus struct {
	All  float64
	Used float64
	Free float64
}

// disk usage of path/disk
func DiskUsage(path string) (disk DiskStatus) {
	fs := syscall.Statfs_t{}
	err := syscall.Statfs(path, &fs)
	if err != nil {
		return
	}
	disk.All = float64(fs.Blocks) * float64(fs.Bsize) / GB
	disk.Free = float64(fs.Bfree) * float64(fs.Bsize) / GB
	disk.Used = disk.All - disk.Free
	return
}
