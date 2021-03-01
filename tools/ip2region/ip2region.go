package ip2region

import (
	"encoding/json"
	"errors"
	"github.com/kataras/iris/v12"
	"io/ioutil"
	"log"
	"os"
	"strconv"
	"strings"
)

const (
	indexBlockLength  = 12
	totalHeaderLength = 8192
)

var Region = new(ip2region)

type (
	Location struct {
		Id       int64  `json:"id"`
		Country  string `json:"country"`
		Region   string `json:"region"`
		Province string `json:"province"`
		City     string `json:"city"`
		ISP      string `json:"isp"`
		Err      error  `json:"err"`
	}
	ip2region struct {
		dbFileHandler *os.File
		headerSip     []int64
		headerPtr     []int64
		headerLen     int64
		firstIndexPtr int64
		lastIndexPtr  int64
		totalBlocks   int64
		dbBinStr      []byte
		dbFile        string
	}
)

func (ip Location) String() string {
	b, _ := json.Marshal(&ip)
	return string(b)
}

// 内存查找法
func (r *ip2region) Find(ipStr string) Location {
	if r == nil {
		return Location{Err: errors.New("未初始化")}
	}
	var err error
	if r.totalBlocks == 0 {
		if r.dbBinStr, err = ioutil.ReadFile(r.dbFile); err != nil {
			return Location{Err: err}
		}
		r.firstIndexPtr = getLong(r.dbBinStr, 0)
		r.lastIndexPtr = getLong(r.dbBinStr, 4)
		r.totalBlocks = (r.lastIndexPtr-r.firstIndexPtr)/indexBlockLength + 1
	}
	var ip int64
	if ip, err = ip2long(ipStr); err != nil {
		return Location{Err: err}
	}
	h := r.totalBlocks
	var dataPtr, l int64
	for l <= h {
		m := (l + h) >> 1
		p := r.firstIndexPtr + m*indexBlockLength
		sip := getLong(r.dbBinStr, p)
		if ip < sip {
			h = m - 1
		} else {
			eip := getLong(r.dbBinStr, p+4)
			if ip > eip {
				l = m + 1
			} else {
				dataPtr = getLong(r.dbBinStr, p+8)
				break
			}
		}
	}
	if dataPtr == 0 {
		return Location{Err: errors.New("not found")}
	}
	dataLen := (dataPtr >> 24) & 0xFF
	dataPtr = dataPtr & 0x00FFFFFF
	return getIpInfo(getLong(r.dbBinStr, dataPtr), r.dbBinStr[(dataPtr)+4:dataPtr+dataLen])
}
func (r *ip2region) BinaryFind(ipStr string) Location {
	if r == nil {
		return Location{Err: errors.New("未初始化")}
	}
	var err error
	if r.totalBlocks == 0 {
		_, _ = r.dbFileHandler.Seek(0, 0)
		superBlock := make([]byte, 8)
		_, _ = r.dbFileHandler.Read(superBlock)
		r.firstIndexPtr = getLong(superBlock, 0)
		r.lastIndexPtr = getLong(superBlock, 4)
		r.totalBlocks = (r.lastIndexPtr-r.firstIndexPtr)/indexBlockLength + 1
	}
	var l, dataPtr, p int64
	h := r.totalBlocks
	var ip int64
	if ip, err = ip2long(ipStr); err != nil {
		return Location{Err: err}
	}
	for l <= h {
		m := (l + h) >> 1
		p = m * indexBlockLength
		if _, err = r.dbFileHandler.Seek(r.firstIndexPtr+p, 0); err != nil {
			return Location{Err: err}
		}
		buffer := make([]byte, indexBlockLength)
		if _, err = r.dbFileHandler.Read(buffer); err != nil {
			return Location{Err: err}
		}
		sip := getLong(buffer, 0)
		if ip < sip {
			h = m - 1
		} else {
			eip := getLong(buffer, 4)
			if ip > eip {
				l = m + 1
			} else {
				dataPtr = getLong(buffer, 8)
				break
			}
		}
	}
	if dataPtr == 0 {
		return Location{Err: errors.New("not found")}
	}
	dataLen := (dataPtr >> 24) & 0xFF
	dataPtr = dataPtr & 0x00FFFFFF
	_, _ = r.dbFileHandler.Seek(dataPtr, 0)
	data := make([]byte, dataLen)
	_, _ = r.dbFileHandler.Read(data)
	return getIpInfo(getLong(data, 0), data[4:dataLen])
}
func (r *ip2region) BtreeFind(ipStr string) Location {
	if r == nil {
		return Location{Err: errors.New("未初始化")}
	}
	var err error
	var ip int64
	if ip, err = ip2long(ipStr); err != nil {
		return Location{Err: err}
	}
	if r.headerLen == 0 {
		_, _ = r.dbFileHandler.Seek(8, 0)
		buffer := make([]byte, totalHeaderLength)
		_, _ = r.dbFileHandler.Read(buffer)
		var idx int64
		for i := 0; i < totalHeaderLength; i += 8 {
			startIp := getLong(buffer, int64(i))
			dataPar := getLong(buffer, int64(i+4))
			if dataPar == 0 {
				break
			}
			r.headerSip = append(r.headerSip, startIp)
			r.headerPtr = append(r.headerPtr, dataPar)
			idx++
		}
		r.headerLen = idx
	}
	var l, sPtr, ePtr int64
	h := r.headerLen
	for l <= h {
		m := (l + h) >> 1
		if m < r.headerLen {
			if ip == r.headerSip[m] {
				if m > 0 {
					sPtr = r.headerPtr[m-1]
					ePtr = r.headerPtr[m]
				} else {
					sPtr = r.headerPtr[m]
					ePtr = r.headerPtr[m+1]
				}
				break
			}
			if ip < r.headerSip[m] {
				if m == 0 {
					sPtr = r.headerPtr[m]
					ePtr = r.headerPtr[m+1]
					break
				} else if ip > r.headerSip[m-1] {
					sPtr = r.headerPtr[m-1]
					ePtr = r.headerPtr[m]
					break
				}
				h = m - 1
			} else {
				if m == r.headerLen-1 {
					sPtr = r.headerPtr[m-1]
					ePtr = r.headerPtr[m]
					break
				} else if ip <= r.headerSip[m+1] {
					sPtr = r.headerPtr[m]
					ePtr = r.headerPtr[m+1]
					break
				}
				l = m + 1
			}
		}

	}
	if sPtr == 0 {
		return Location{Err: errors.New("not found")}
	}
	blockLen := ePtr - sPtr
	_, _ = r.dbFileHandler.Seek(sPtr, 0)
	index := make([]byte, blockLen+indexBlockLength)
	_, _ = r.dbFileHandler.Read(index)
	var dataPtr int64
	h = blockLen / indexBlockLength
	l = 0
	for l <= h {
		m := (l + h) >> 1
		p := m * indexBlockLength
		sip := getLong(index, p)
		if ip < sip {
			h = m - 1
		} else {
			eip := getLong(index, p+4)
			if ip > eip {
				l = m + 1
			} else {
				dataPtr = getLong(index, p+8)
				break
			}
		}
	}
	if dataPtr == 0 {
		return Location{Err: errors.New("not found")}
	}
	dataLen := (dataPtr >> 24) & 0xFF
	dataPtr = dataPtr & 0x00FFFFFF
	_, _ = r.dbFileHandler.Seek(dataPtr, 0)
	data := make([]byte, dataLen)
	_, _ = r.dbFileHandler.Read(data)
	return getIpInfo(getLong(data, 0), data[4:])
}
func (r *ip2region) Close() {
	if r.dbFileHandler != nil {
		r.dbFileHandler.Close()
	}
}
func New(paths ...string) (*ip2region, error) {
	path := "./tools/ip2region/ip2region.db"
	if len(paths) > 0 {
		path = paths[0]
	}
	file, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	return &ip2region{
		dbFile:        path,
		dbFileHandler: file,
	}, nil
}
func getIpInfo(cityId int64, line []byte) Location {
	lineSlice := make([]string, 5)
	copy(lineSlice, strings.Split(string(line), "|"))
	for i := 0; i < 5; i++ {
		if lineSlice[i] == "0" {
			lineSlice[i] = ""
		}
	}
	var location = Location{Id: cityId}
	location.Country = lineSlice[0]
	location.Region = lineSlice[1]
	location.Province = lineSlice[2]
	location.City = lineSlice[3]
	location.ISP = lineSlice[4]
	return location
}
func getLong(b []byte, offset int64) int64 {
	return int64(b[offset]) |
		int64(b[offset+1])<<8 |
		int64(b[offset+2])<<16 |
		int64(b[offset+3])<<24
}
func ip2long(IpStr string) (int64, error) {
	bits := strings.Split(IpStr, ".")
	if len(bits) != 4 {
		return 0, errors.New("ip format error")
	}
	var sum int64
	for i, n := range bits {
		bit, _ := strconv.ParseInt(n, 10, 64)
		sum += bit << uint(24-8*i)
	}
	return sum, nil
}
func init() {
	var err error
	if Region, err = New(); err != nil {
		log.Println(err)
		return
	}
	iris.RegisterOnInterrupt(func() {
		Region.Close()
	})
}
