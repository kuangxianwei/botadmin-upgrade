package baidu

import (
	"botadmin/tools/requests"
	"botadmin/tools/utils"
	"errors"
	"strconv"
	"strings"
)

const (
	//获取tags api
	TagApi = "https://aip.baidubce.com/rpc/2.0/nlp/v1/keyword?charset=UTF-8&access_token="
	//纠错api
	CorrectApi = "https://aip.baidubce.com/rpc/2.0/nlp/v1/ecnet?charset=UTF-8&access_token="
	//简介
	DescriptionApi = "https://aip.baidubce.com/rpc/2.0/nlp/v1/news_summary?charset=UTF-8&access_token="
	//百度验证文本违禁词链接
	BanApi = "https://aip.baidubce.com/rest/2.0/solution/v1/text_censor/v2/user_defined?access_token="
)

//百度处理文本
type Ai struct {
	BanEnabled         bool `json:"ban_enabled" form:"ban_enabled" html:"alias=违禁,note=启用违禁词过滤"`                  //启用过滤违禁词
	TagEnabled         bool `json:"tag_enabled" form:"tag_enabled" html:"alias=Tags,note=启用获取tags"`               //启用获取tag
	CorrectEnabled     bool `json:"correct_enabled" form:"correct_enabled" html:"alias=纠错,note=启用纠错功能"`           //启用纠错
	DescriptionEnabled bool `json:"description_enabled" form:"description_enabled" html:"alias=简介,note=启用提取简介功能"` //启用获取简介
	AccessToken        `xorm:"extends"`
}

//获取文章标签 tag
func (a *Ai) GetTags(title, content string) (tags []string, err error) {
	if !a.TagEnabled {
		return nil, nil
	}
	titleRs := utils.TrimLabelRunes(title, -1)
	if len(titleRs) > 38 {
		titleRs = titleRs[:38]
	}
	contentRs := utils.TrimLabelRunes(content, -1)
	if len(contentRs) > 32000 {
		contentRs = contentRs[:32000]
	}
	if err = a.SetToken(); err != nil {
		return nil, err
	}
	var r requests.Responder
	if r, err = requests.Post(
		TagApi+a.Token,
		requests.Header{"Content-Type": "application/json"},
		`{"title": "`+string(titleRs)+`", "content": "`+string(contentRs)+`"}`,
	); err != nil {
		return nil, err
	}
	type Item struct {
		Score float64 `json:"score"` //得分 权重
		Tag   string  `json:"tag"`   //tag 名称
	}
	result := struct {
		Items []Item `json:"items"`
		Results
	}{}
	if err = r.Json(&result, "utf-8"); err != nil {
		return nil, err
	}
	if err = result.Err(); err != nil {
		return nil, err
	}
	tags = make([]string, 0, len(result.Items))
	for _, v := range result.Items {
		if v.Score > 0.7 {
			tags = append(tags, v.Tag)
		}
	}
	return tags, nil
}

//获取文章简介
func (a *Ai) GetDescription(title, content string, n ...int) (description string, err error) {
	if !a.DescriptionEnabled {
		return "", nil
	}
	content = utils.TrimLabel(content, -1)
	if content == "" {
		return "", nil
	}
	count := 120
	if len(n) > 0 && n[0] > 0 {
		count = n[0]
	}
	titleRs := []rune(title)
	if len(titleRs) > 100 {
		titleRs = titleRs[:100]
	}
	contentRs := []rune(content)
	if len(contentRs) > 3000 {
		contentRs = contentRs[:3000]
	}
	if err = a.SetToken(); err != nil {
		return "", err
	}
	var r requests.Responder
	if r, err = requests.Post(
		DescriptionApi+a.Token,
		requests.Header{"Content-Type": "application/json"},
		`{"title": "`+string(titleRs)+`", "content": "`+string(contentRs)+`", "max_summary_len": `+strconv.Itoa(count)+`}`,
	); err != nil {
		return "", err
	}
	result := struct {
		Summary string `json:"summary"`
		Results
	}{}
	if err = r.Json(&result, "utf-8"); err != nil {
		return "", err
	}
	if err = result.Err(); err != nil {
		return "", err
	}
	return result.Summary, nil
}

//文本纠错
func (a *Ai) Correct(text string) (string, error) {
	if !a.CorrectEnabled {
		return text, nil
	}
	var err error
	if err = a.SetToken(); err != nil {
		return "", err
	}
	textRs := []rune(text)
	var buf strings.Builder
	buf.Grow(len(text))
	var end = 250
	type (
		Item struct {
			Score        float64 `json:"score"`         //得分 权重
			CorrectQuery string  `json:"correct_query"` //纠错后的
		}
		Result struct {
			Item Item `json:"item"`
			Results
		}
	)
	for len(textRs) > 0 {
		c := len(textRs)
		if c < 250 {
			end = c
		}
		var r requests.Responder
		q := string(textRs[:end])
		if r, err = requests.Post(
			CorrectApi+a.Token,
			requests.Header{"Content-Type": "application/json"},
			`{"text": "`+q+`"}`,
		); err != nil {
			return text, err
		}
		var result Result
		if err = r.Json(&result); err != nil {
			return text, err
		}
		if err = result.Err(); err != nil {
			return text, err
		}
		if result.Item.Score > 0.7 {
			buf.WriteString(result.Item.CorrectQuery)
		} else {
			buf.WriteString(q)
		}
		textRs = textRs[end:]
	}
	return buf.String(), nil
}

type (
	Hit struct {
		DatasetName string   `json:"datasetName"`
		Words       []string `json:"words"`
	}
	Item struct {
		Type           int    `json:"type"`
		SubType        int    `json:"subType"`
		Conclusion     string `json:"conclusion"`
		ConclusionType int    `json:"conclusionType"`
		Msg            string `json:"msg"`
		Hits           []Hit  `json:"hits"`
	}
	BanResult struct {
		Results
		Conclusion     string `json:"conclusion"`
		ConclusionType int    `json:"conclusionType"`
		Data           []Item `json:"data"`
	}
)

//违禁词过滤
func (a *Ai) Ban(text string) (bans []string, err error) {
	if !a.BanEnabled {
		return nil, nil
	}
	if err = a.SetToken(); err != nil {
		return nil, err
	}
	textRs := []rune(text)
	var r BanResult
	for len(textRs) > 0 {
		if r, err = a.valid(&textRs); err != nil {
			return nil, err
		}
		if err = r.Err(); err != nil {
			return nil, err
		}
		for _, v := range r.Data {
			for _, hit := range v.Hits {
				bans = append(bans, hit.Words...)
			}
		}
	}
	return bans, nil
}

//执行文本检查
func (a *Ai) valid(raw *[]rune) (result BanResult, err error) {
	count := len(*raw)
	end := count
	if end > 6500 {
		end = 6500
	}
	rs := make([]rune, end)
	copy(rs, *raw)
	*raw = (*raw)[end:]
	var r requests.Responder
	if r, err = requests.Post(BanApi+a.Token, requests.Data{"text": string(rs)}); err != nil {
		return result, err
	}
	if err = r.Json(&result); err != nil {
		return result, err
	}
	return result, nil
}

//直接验证标题合法
func (a *Ai) ValidText(text string) error {
	if err := a.SetToken(); err != nil {
		return err
	}
	rs := []rune(text)
	r, err := a.valid(&rs)
	if err != nil {
		return err
	}
	if err = r.Err(); err != nil {
		return err
	}
	if r.ConclusionType != 1 {
		if len(r.Data) == 0 {
			return errors.New("未知错误")
		}
		var buf strings.Builder
		d := r.Data[0]
		buf.WriteString("Error: " + d.Msg)
		buf.WriteString(" [")
		for _, hit := range d.Hits {
			for _, word := range hit.Words {
				buf.WriteString(word + ", ")
			}
		}
		buf.WriteString("]")
		for _, v := range r.Data[1:] {
			buf.WriteString(" " + v.Msg)
			buf.WriteString(" [")
			for _, hit := range v.Hits {
				for _, word := range hit.Words {
					buf.WriteString(word + ", ")
				}
			}
			buf.WriteString("]")
		}
		return errors.New(buf.String())
	}
	return nil
}
