package base_t

// 分页
type Pagination struct {
	Data  interface{} `json:"data" form:"data" xorm:"-" html:"-"`
	Code  int         `json:"code" form:"code" xorm:"-" html:"-"`
	Count int64       `json:"count" form:"count" xorm:"-" html:"-"`
	Msg   string      `json:"msg" form:"msg" xorm:"-" html:"-"`
	Path  string      `json:"path" form:"path" xorm:"-" html:"-"`
	Page  int         `json:"page" form:"page" xorm:"-" html:"-"`
	Limit int         `json:"limit" form:"limit" xorm:"-" html:"-"`
}

// 获取切片开始和结束
func (p *Pagination) Slice() (start, end int) {
	if p.Limit < 0 {
		p.Limit = 0
	}
	if p.Page < 1 {
		p.Page = 1
	}
	start = p.Limit * (p.Page - 1)
	if int64(start) >= p.Count {
		start = int(p.Count - 1)
	}
	end = start + p.Limit
	if int64(end) > p.Count {
		end = int(p.Count)
	}
	return start, end
}

// 数据库查询的
func (p *Pagination) Limits() (limit, start int) {
	var end int
	start, end = p.Slice()
	return end - start, start
}

// 整理错误
func (p *Pagination) Tidy(err error) {
	if err != nil {
		p.Code = -1
		p.Msg = err.Error()
		return
	}
	if p.Count == 0 {
		p.Code = -1
		if p.Path != "" {
			p.Msg = p.Path + " is a empty folder! "
		} else {
			p.Msg = "data is empty! "
		}
		return
	}
}
