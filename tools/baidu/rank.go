package baidu

/*
这个是百度站长关键词下载解析
*/
import (
	"botadmin/tools/base_t"
	"botadmin/tools/requests"
	"botadmin/tools/utils"
	"errors"
	"github.com/tealeg/xlsx/v3"
	"math"
	"net/url"
	"os"
	"path/filepath"
	"sort"
	"strconv"
	"strings"
	"sync"
	"time"
)

//百度站长排名下载URL
const (
	bdPcDownloadURL     = "https://ziyuan.baidu.com/keywords/keywordlist?range=month&download=true&site="
	bdMobileDownloadURL = "https://ziyuan.baidu.com/keywords/download?pagetype=11&site="
)

//临时目录
var bdRankTempDir = filepath.Join(os.TempDir(), "bd_rank")

//百度排名表格行
type BdRow struct {
	Target        string  //目标
	Keyword       string  //关键词
	ClickAmount   int     //点击量
	DisplayAmount int     //展示量
	ClickRate     float64 //点击率
	Rank          float64 //排名
}

//赋值
func (r *BdRow) Assign(cells []string) (err error) {
	switch len(cells) {
	case 5:
		r.Keyword = cells[0]
		if r.ClickAmount, err = strconv.Atoi(cells[1]); err != nil {
			return err
		}
		if r.DisplayAmount, err = strconv.Atoi(cells[2]); err != nil {
			return err
		}
		if r.ClickRate, err = strconv.ParseFloat(strings.TrimRight(cells[3], "%"), 64); err != nil {
			return err
		}
		r.ClickRate /= 100
		if r.Rank, err = strconv.ParseFloat(cells[4], 64); err != nil {
			return err
		}
	case 6:
		r.Keyword = cells[1]
		if r.DisplayAmount, err = strconv.Atoi(cells[2]); err != nil {
			return err
		}
		if r.ClickAmount, err = strconv.Atoi(cells[3]); err != nil {
			return err
		}
		if r.ClickRate, err = strconv.ParseFloat(cells[4], 64); err != nil {
			return err
		}
		r.Target = cells[5]
	default:
		return errors.New("关键词列表不完整")
	}
	return nil
}

// 百度排名
type BdRank struct {
	HostUri string         //主机url 例如：https://www.nfivf.com/
	Cookies string         //百度cookies
	Ignores []string       //忽略关键词列表
	Log     *base_t.Buffer //日志记录
	//内部属性
	pcData         []BdRow //PC端数据
	mobileData     []BdRow //移动端数据
	host           string  //主机名称 例如：www.nfivf.com
	pcFilename     string  //pc端文件名
	mobileFilename string  //移动端文件名
	cache          sync.Once
}

//初始化
func (r *BdRank) init() {
	r.cache.Do(func() {
		if r.Log == nil {
			r.Log = new(base_t.Buffer)
		}
		if strings.HasSuffix(r.HostUri, "/") {
			r.HostUri += "/"
		}
		r.host = utils.DomainExp.FindString(r.HostUri)
		if !utils.IsDir(bdRankTempDir) {
			_ = os.MkdirAll(bdRankTempDir, 0755)
		}
		r.pcFilename = filepath.Join(bdRankTempDir, r.host+".pc.xlsx")
		r.mobileFilename = filepath.Join(bdRankTempDir, r.host+".mobile.xlsx")
	})
}

//下载pc端关键词
func (r *BdRank) downloadPc() error {
	r.init()
	r.Log.Write(r.host + " 开始PC端下载关键词...")
	req := requests.New()
	req.SetCookies(r.Cookies)
	res, err := req.Get(bdPcDownloadURL + url.QueryEscape(r.HostUri))
	if err != nil {
		return r.Log.Error(err, "PC: "+r.host)
	}
	if err = res.SaveFile(r.pcFilename, 200); err != nil {
		return r.Log.Error(err, "PC "+r.host)
	}
	r.Log.Write(r.pcFilename + " 下载成功")
	return nil
}

//下载移动端关键词
func (r *BdRank) downloadMobile() error {
	r.init()
	r.Log.Write(r.host + " 开始下载移动端关键词...")
	req := requests.New()
	req.SetCookies(r.Cookies)
	res, err := req.Get(bdMobileDownloadURL + url.QueryEscape(r.HostUri))
	if err != nil {
		return r.Log.Error(err, "Mobile: "+r.host)
	}
	if err = res.SaveFile(r.mobileFilename, 200); err != nil {
		return r.Log.Error(err, "Mobile: "+r.host)
	}
	r.Log.Write(r.mobileFilename + " 下载成功")
	return nil
}

//验证文件是否需要重新下载
func (r *BdRank) isRedownload(filename string) bool {
	fi, err := os.Stat(filename)
	if err != nil {
		return true
	}
	if fi.IsDir() {
		r.Log.Write(filename + " 是一个目录")
		if err = os.RemoveAll(filename); err != nil {
			return true
		}
	}
	return (time.Now().Local().Unix() - fi.ModTime().Unix()) > 3600*6
}

//判断是忽略内容
func (r *BdRank) isIgnore(word string) bool {
	if word == r.host || strings.HasPrefix(word, "site:") || strings.HasPrefix(word, "domain:") {
		return true
	}
	for _, v := range r.Ignores {
		if strings.Contains(word, v) {
			return true
		}
	}
	return false
}

//解析PC
func (r *BdRank) parsePc() error {
	if r.isRedownload(r.pcFilename) {
		if err := r.downloadPc(); err != nil {
			return err
		}
	}
	r.Log.Write("开始解析: " + r.pcFilename)
	wb, err := xlsx.OpenFile(r.pcFilename)
	if err != nil {
		return r.Log.Error(err, r.pcFilename)
	}
	r.pcData = make([]BdRow, 0, len(wb.Sheets))
	for _, sheet := range wb.Sheets {
		if err := sheet.ForEachRow(func(row *xlsx.Row) error {
			var cells []string
			var err error
			if err = row.ForEachCell(func(c *xlsx.Cell) error {
				cells = append(cells, c.Value)
				return nil
			}); err != nil {
				return err
			}
			var bdRank BdRow
			if err = bdRank.Assign(cells); err == nil {
				r.pcData = append(r.pcData, bdRank)
			}
			return nil
		}); err != nil {
			return r.Log.Error(err, r.pcFilename)
		}
	}
	sort.SliceStable(r.pcData, func(i, j int) bool {
		return r.pcData[i].DisplayAmount > r.pcData[j].DisplayAmount
	})
	return nil
}

//解析移动
func (r *BdRank) parseMobile() error {
	if r.isRedownload(r.mobileFilename) {
		if err := r.downloadMobile(); err != nil {
			return err
		}
	}
	r.Log.Write("开始解析: " + r.mobileFilename)
	wb, err := xlsx.OpenFile(r.mobileFilename)
	if err != nil {
		return r.Log.Error(err, r.mobileFilename)
	}
	r.mobileData = make([]BdRow, 0, len(wb.Sheets))
	for _, sheet := range wb.Sheets {
		if err := sheet.ForEachRow(func(row *xlsx.Row) error {
			var cells []string
			var err error
			if err = row.ForEachCell(func(c *xlsx.Cell) error {
				cells = append(cells, c.Value)
				return nil
			}); err != nil {
				return err
			}
			var bdRank BdRow
			if err = bdRank.Assign(cells); err == nil {
				r.mobileData = append(r.mobileData, bdRank)
			}
			return nil
		}); err != nil {
			return r.Log.Error(err, r.mobileFilename)
		}
	}
	sort.SliceStable(r.mobileData, func(i, j int) bool {
		return r.mobileData[i].DisplayAmount > r.mobileData[j].DisplayAmount
	})
	return nil
}

// 构造排名数据
func (r *BdRank) buildData(reach func(row BdRow) bool, datas []BdRow) []string {
	var results []string
	for _, v := range datas {
		if reach(v) && !r.isIgnore(v.Keyword) {
			n := 2
			if rate := int(math.RoundToEven(float64(v.DisplayAmount) / 30 * 0.1)); rate > 2 {
				n = rate
			}
			results = append(results, v.Keyword+">"+r.host+">"+strconv.Itoa(n))
		}
	}
	return results
}

//删除
func (r *BdRank) del(filename string) error {
	if utils.IsFile(filename) {
		if err := os.Remove(filename); err != nil {
			return r.Log.Error(err, "删除 "+filename)
		}
		r.Log.Write("成功删除 " + filename)
	}
	return nil
}

//设置cookies
func (r *BdRank) SetCookies(cookies string) {
	r.Cookies = cookies
}

//获取PC端
func (r *BdRank) GetPc(reach func(row BdRow) bool) ([]string, error) {
	r.init()
	if err := r.parsePc(); err != nil {
		return nil, err
	}
	return r.buildData(reach, r.pcData), nil
}

//获取移动端
func (r *BdRank) GetMobile(reach func(row BdRow) bool) ([]string, error) {
	r.init()
	if err := r.parseMobile(); err != nil {
		return nil, err
	}
	return r.buildData(reach, r.mobileData), nil
}

//删除缓存
func (r *BdRank) Del(hosts ...string) error {
	r.init()
	if len(hosts) > 0 && hosts[0] == "all" {
		if err := os.RemoveAll(bdRankTempDir); err != nil {
			return err
		}
		r.Log.Write("删除成功: " + bdRankTempDir)
		return os.MkdirAll(bdRankTempDir, 0755)
	}
	for i := 0; i < len(hosts); i++ {
		hosts[i] = utils.DomainExp.FindString(hosts[i])
		if hosts[i] == "" {
			hosts = append(hosts[i:], hosts[:i+1]...)
			i--
		}
	}
	if len(hosts) == 0 {
		hosts = append(hosts, r.host)
	}
	for _, host := range hosts {
		if err := r.del(filepath.Join(bdRankTempDir, host+".pc.xlsx")); err != nil {
			return err
		}
		if err := r.del(filepath.Join(bdRankTempDir, host+".mobile.xlsx")); err != nil {
			return err
		}
	}
	return nil
}

/*
func main() {
	r := BdRank{HostUri: "https://m.nfivf.com/"}
	r.SetCookies("BDUSS=DEycmd-dk9oRThON1ppSkRPdFFLbnRxLWpEZ25FUkMwNjlFSWdSTUxueFg5a0JmSVFBQUFBJCQAAAAAAAAAAAEAAADCjSYT2vfPzc6wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFdpGV9XaRlfZ")
	if data, err := r.GetPc(func(row BdRow) bool {
		return row.DisplayAmount > 59 && row.Rank < 100)
	}); err != nil {
		panic(err)
	} else {
		fmt.Printf("%#v\n", data)
	}
}
*/
