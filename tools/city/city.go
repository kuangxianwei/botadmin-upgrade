package city

import (
	"strings"
)

const DirectCity = "直辖市"

type (
	Location struct {
		Id            int    `json:"id"`             //排序
		Code          int    `json:"code"`           //编码
		Province      string `json:"province"`       //省名称
		ProvinceShort string `json:"province_short"` // 省简称
		City          string `json:"city"`           // 城市名称
		CityShort     string `json:"city_short"`     // 城市简称
	}
	locations []Location
)

func (l *Location) GetProvinceShort() string {
	if l.ProvinceShort == "" {
		if l.Province == DirectCity {
			l.ProvinceShort = ProvinceShort[l.CityShort]
		} else {
			l.ProvinceShort = ProvinceShort[l.Province]
		}
	}
	return l.ProvinceShort
}

var (
	// 省简称
	ProvinceShort = map[string]string{
		"北京":  "京",
		"天津":  "津",
		"河北":  "冀",
		"山西":  "晋",
		"内蒙古": "蒙",
		"辽宁":  "辽",
		"吉林":  "吉",
		"黑龙江": "黑",
		"上海":  "沪",
		"江苏":  "苏",
		"浙江":  "浙",
		"安徽":  "皖",
		"福建":  "闽",
		"江西":  "赣",
		"山东":  "鲁",
		"河南":  "豫",
		"湖北":  "鄂",
		"湖南":  "湘",
		"广东":  "粤",
		"广西":  "桂",
		"海南":  "琼",
		"重庆":  "渝",
		"四川":  "川",
		"贵州":  "黔",
		"云南":  "滇",
		"西藏":  "藏",
		"陕西":  "陕",
		"甘肃":  "甘",
		"青海":  "青",
		"宁夏":  "宁",
		"新疆":  "新",
		"台湾":  "台",
		"香港":  "港",
		"澳门":  "澳",
	}
	// 位置列表
	Locations = locations{
		{Id: 0, Code: 131, Province: DirectCity, ProvinceShort: "京", City: "北京市", CityShort: "北京"},
		{Id: 1, Code: 289, Province: DirectCity, ProvinceShort: "沪", City: "上海市", CityShort: "上海"},
		{Id: 2, Code: 257, Province: "广东", ProvinceShort: "粤", City: "广州市", CityShort: "广州"},
		{Id: 3, Code: 340, Province: "广东", ProvinceShort: "粤", City: "深圳市", CityShort: "深圳"},
		{Id: 4, Code: 179, Province: "浙江", ProvinceShort: "浙", City: "杭州市", CityShort: "杭州"},
		{Id: 5, Code: 224, Province: "江苏", ProvinceShort: "苏", City: "苏州市", CityShort: "苏州"},
		{Id: 6, Code: 218, Province: "湖北", ProvinceShort: "鄂", City: "武汉市", CityShort: "武汉"},
		{Id: 7, Code: 315, Province: "江苏", ProvinceShort: "苏", City: "南京市", CityShort: "南京"},
		{Id: 8, Code: 132, Province: DirectCity, ProvinceShort: "渝", City: "重庆市", CityShort: "重庆"},
		{Id: 9, Code: 75, Province: "四川", ProvinceShort: "川", City: "成都市", CityShort: "成都"},
		{Id: 10, Code: 332, Province: DirectCity, ProvinceShort: "津", City: "天津市", CityShort: "天津"},
		{Id: 11, Code: 317, Province: "江苏", ProvinceShort: "苏", City: "无锡市", CityShort: "无锡"},
		{Id: 12, Code: 158, Province: "湖南", ProvinceShort: "湘", City: "长沙市", CityShort: "长沙"},
		{Id: 13, Code: 268, Province: "河南", ProvinceShort: "豫", City: "郑州市", CityShort: "郑州"},
		{Id: 14, Code: 180, Province: "浙江", ProvinceShort: "浙", City: "宁波市", CityShort: "宁波"},
		{Id: 15, Code: 233, Province: "陕西", ProvinceShort: "陕", City: "西安市", CityShort: "西安"},
		{Id: 16, Code: 288, Province: "山东", ProvinceShort: "鲁", City: "济南市", CityShort: "济南"},
		{Id: 17, Code: 236, Province: "山东", ProvinceShort: "鲁", City: "青岛市", CityShort: "青岛"},
		{Id: 18, Code: 300, Province: "福建", ProvinceShort: "闽", City: "福州市", CityShort: "福州"},
		{Id: 19, Code: 127, Province: "安徽", ProvinceShort: "皖", City: "合肥市", CityShort: "合肥"},
		{Id: 20, Code: 138, Province: "广东", ProvinceShort: "粤", City: "佛山市", CityShort: "佛山"},
		{Id: 21, Code: 167, Province: "辽宁", ProvinceShort: "辽", City: "大连市", CityShort: "大连"},
		{Id: 22, Code: 161, Province: "江苏", ProvinceShort: "苏", City: "南通市", CityShort: "南通"},
		{Id: 23, Code: 58, Province: "辽宁", ProvinceShort: "辽", City: "沈阳市", CityShort: "沈阳"},
		{Id: 24, Code: 119, Province: "广东", ProvinceShort: "粤", City: "东莞市", CityShort: "东莞"},
		{Id: 25, Code: 348, Province: "江苏", ProvinceShort: "苏", City: "常州市", CityShort: "常州"},
		{Id: 26, Code: 104, Province: "云南", ProvinceShort: "滇", City: "昆明市", CityShort: "昆明"},
		{Id: 27, Code: 326, Province: "山东", ProvinceShort: "鲁", City: "烟台市", CityShort: "烟台"},
		{Id: 28, Code: 194, Province: "福建", ProvinceShort: "闽", City: "厦门市", CityShort: "厦门"},
		{Id: 29, Code: 134, Province: "福建", ProvinceShort: "闽", City: "泉州市", CityShort: "泉州"},
		{Id: 30, Code: 293, Province: "浙江", ProvinceShort: "浙", City: "绍兴市", CityShort: "绍兴"},
		{Id: 31, Code: 176, Province: "山西", ProvinceShort: "晋", City: "太原市", CityShort: "太原"},
		{Id: 32, Code: 163, Province: "江西", ProvinceShort: "赣", City: "南昌市", CityShort: "南昌"},
		{Id: 33, Code: 53, Province: "吉林", ProvinceShort: "吉", City: "长春市", CityShort: "长春"},
		{Id: 34, Code: 265, Province: "河北", ProvinceShort: "冀", City: "唐山市", CityShort: "唐山"},
		{Id: 35, Code: 178, Province: "浙江", ProvinceShort: "浙", City: "温州市", CityShort: "温州"},
		{Id: 36, Code: 334, Province: "浙江", ProvinceShort: "浙", City: "嘉兴市", CityShort: "嘉兴"},
		{Id: 37, Code: 150, Province: "河北", ProvinceShort: "冀", City: "石家庄市", CityShort: "石家庄"},
		{Id: 38, Code: 316, Province: "江苏", ProvinceShort: "苏", City: "徐州市", CityShort: "徐州"},
		{Id: 39, Code: 48, Province: "黑龙江", ProvinceShort: "黑", City: "哈尔滨市", CityShort: "哈尔滨"},
		{Id: 40, Code: 244, Province: "浙江", ProvinceShort: "浙", City: "台州市", CityShort: "台州"},
		{Id: 41, Code: 346, Province: "江苏", ProvinceShort: "苏", City: "扬州市", CityShort: "扬州"},
		{Id: 42, Code: 287, Province: "山东", ProvinceShort: "鲁", City: "潍坊市", CityShort: "潍坊"},
		{Id: 43, Code: 92, Province: "新疆", ProvinceShort: "新", City: "乌鲁木齐市", CityShort: "乌鲁木齐"},
		{Id: 44, Code: 140, Province: "广东", ProvinceShort: "粤", City: "珠海市", CityShort: "珠海"},
		{Id: 45, Code: 283, Province: "内蒙古", ProvinceShort: "蒙", City: "鄂尔多斯市", CityShort: "鄂尔多斯"},
		{Id: 46, Code: 333, Province: "浙江", ProvinceShort: "浙", City: "金华市", CityShort: "金华"},
		{Id: 47, Code: 153, Province: "河南", ProvinceShort: "豫", City: "洛阳市", CityShort: "洛阳"},
		{Id: 48, Code: 146, Province: "贵州", ProvinceShort: "黔", City: "贵阳市", CityShort: "贵阳"},
		{Id: 49, Code: 160, Province: "江苏", ProvinceShort: "苏", City: "镇江市", CityShort: "镇江"},
		{Id: 50, Code: 354, Province: "山东", ProvinceShort: "鲁", City: "淄博市", CityShort: "淄博"},
		{Id: 51, Code: 276, Province: "江苏", ProvinceShort: "苏", City: "泰州市", CityShort: "泰州"},
		{Id: 52, Code: 223, Province: "江苏", ProvinceShort: "苏", City: "盐城市", CityShort: "盐城"},
		{Id: 53, Code: 261, Province: "广西", ProvinceShort: "桂", City: "南宁市", CityShort: "南宁"},
		{Id: 54, Code: 294, Province: "浙江", ProvinceShort: "浙", City: "湖州市", CityShort: "湖州"},
		{Id: 55, Code: 286, Province: "山东", ProvinceShort: "鲁", City: "济宁市", CityShort: "济宁"},
		{Id: 56, Code: 270, Province: "湖北", ProvinceShort: "鄂", City: "宜昌市", CityShort: "宜昌"},
		{Id: 57, Code: 175, Province: "山东", ProvinceShort: "鲁", City: "威海市", CityShort: "威海"},
		{Id: 58, Code: 129, Province: "安徽", ProvinceShort: "皖", City: "芜湖市", CityShort: "芜湖"},
		{Id: 59, Code: 301, Province: "广东", ProvinceShort: "粤", City: "惠州市", CityShort: "惠州"},
		{Id: 60, Code: 174, Province: "山东", ProvinceShort: "鲁", City: "东营市", CityShort: "东营"},
		{Id: 61, Code: 191, Province: "河北", ProvinceShort: "冀", City: "廊坊市", CityShort: "廊坊"},
		{Id: 62, Code: 187, Province: "广东", ProvinceShort: "粤", City: "中山市", CityShort: "中山"},
		{Id: 63, Code: 36, Province: "甘肃", ProvinceShort: "甘", City: "兰州市", CityShort: "兰州"},
		{Id: 64, Code: 156, Province: "湖北", ProvinceShort: "鄂", City: "襄阳市", CityShort: "襄阳"},
		{Id: 65, Code: 321, Province: "内蒙古", ProvinceShort: "蒙", City: "呼和浩特市", CityShort: "呼和浩特"},
		{Id: 66, Code: 255, Province: "福建", ProvinceShort: "闽", City: "漳州市", CityShort: "漳州"},
		{Id: 67, Code: 231, Province: "陕西", ProvinceShort: "陕", City: "榆林市", CityShort: "榆林"},
		{Id: 68, Code: 234, Province: "山东", ProvinceShort: "鲁", City: "临沂市", CityShort: "临沂"},
		{Id: 69, Code: 149, Province: "河北", ProvinceShort: "冀", City: "沧州市", CityShort: "沧州"},
		{Id: 70, Code: 222, Province: "湖南", ProvinceShort: "湘", City: "株洲市", CityShort: "株洲"},
		{Id: 71, Code: 302, Province: "广东", ProvinceShort: "粤", City: "江门市", CityShort: "江门"},
		{Id: 72, Code: 307, Province: "河北", ProvinceShort: "冀", City: "保定市", CityShort: "保定"},
		{Id: 73, Code: 349, Province: "江西", ProvinceShort: "赣", City: "九江市", CityShort: "九江"},
		{Id: 74, Code: 50, Province: "黑龙江", ProvinceShort: "黑", City: "大庆市", CityShort: "大庆"},
		{Id: 75, Code: 229, Province: "内蒙古", ProvinceShort: "蒙", City: "包头市", CityShort: "包头"},
		{Id: 76, Code: 365, Province: "江西", ProvinceShort: "赣", City: "赣州市", CityShort: "赣州"},
		{Id: 77, Code: 325, Province: "山东", ProvinceShort: "鲁", City: "泰安市", CityShort: "泰安"},
		{Id: 78, Code: 162, Province: "江苏", ProvinceShort: "苏", City: "淮安市", CityShort: "淮安"},
		{Id: 79, Code: 219, Province: "湖南", ProvinceShort: "湘", City: "常德市", CityShort: "常德"},
		{Id: 80, Code: 151, Province: "河北", ProvinceShort: "冀", City: "邯郸市", CityShort: "邯郸"},
		{Id: 81, Code: 305, Province: "广西", ProvinceShort: "桂", City: "柳州市", CityShort: "柳州"},
		{Id: 82, Code: 347, Province: "江苏", ProvinceShort: "苏", City: "连云港市", CityShort: "连云港"},
		{Id: 83, Code: 155, Province: "河南", ProvinceShort: "豫", City: "许昌市", CityShort: "许昌"},
		{Id: 84, Code: 262, Province: "贵州", ProvinceShort: "黔", City: "遵义市", CityShort: "遵义"},
		{Id: 85, Code: 240, Province: "四川", ProvinceShort: "川", City: "绵阳市", CityShort: "绵阳"},
		{Id: 86, Code: 193, Province: "福建", ProvinceShort: "闽", City: "龙岩市", CityShort: "龙岩"},
		{Id: 87, Code: 372, Province: "山东", ProvinceShort: "鲁", City: "德州市", CityShort: "德州"},
		{Id: 88, Code: 211, Province: "河南", ProvinceShort: "豫", City: "焦作市", CityShort: "焦作"},
		{Id: 89, Code: 189, Province: "安徽", ProvinceShort: "皖", City: "滁州市", CityShort: "滁州"},
		{Id: 90, Code: 152, Province: "河南", ProvinceShort: "豫", City: "新乡市", CityShort: "新乡"},
		{Id: 91, Code: 159, Province: "湖南", ProvinceShort: "湘", City: "衡阳市", CityShort: "衡阳"},
		{Id: 92, Code: 353, Province: "山东", ProvinceShort: "鲁", City: "菏泽市", CityShort: "菏泽"},
		{Id: 93, Code: 277, Province: "江苏", ProvinceShort: "苏", City: "宿迁市", CityShort: "宿迁"},
		{Id: 94, Code: 195, Province: "福建", ProvinceShort: "闽", City: "莆田市", CityShort: "莆田"},
		{Id: 95, Code: 220, Province: "湖南", ProvinceShort: "湘", City: "岳阳市", CityShort: "岳阳"},
		{Id: 96, Code: 254, Province: "福建", ProvinceShort: "闽", City: "三明市", CityShort: "三明"},
		{Id: 97, Code: 309, Province: "河南", ProvinceShort: "豫", City: "南阳市", CityShort: "南阳"},
		{Id: 98, Code: 278, Province: "江西", ProvinceShort: "赣", City: "宜春市", CityShort: "宜春"},
		{Id: 99, Code: 198, Province: "广东", ProvinceShort: "粤", City: "湛江市", CityShort: "湛江"},
		{Id: 100, Code: 199, Province: "广东", ProvinceShort: "粤", City: "阳江市", CityShort: "阳江"},
		{Id: 101, Code: 320, Province: "辽宁", ProvinceShort: "辽", City: "鞍山市", CityShort: "鞍山"},
		{Id: 102, Code: 328, Province: "山西", ProvinceShort: "晋", City: "运城市", CityShort: "运城"},
		{Id: 103, Code: 62, Province: "内蒙古", ProvinceShort: "蒙", City: "兴安盟", CityShort: "兴安盟"},
		{Id: 104, Code: 264, Province: "河北", ProvinceShort: "冀", City: "张家口市", CityShort: "张家口"},
		{Id: 105, Code: 373, Province: "湖北", ProvinceShort: "鄂", City: "恩施土家族苗族自治州", CityShort: "恩施"},
		{Id: 106, Code: 51, Province: "吉林", ProvinceShort: "吉", City: "白城市", CityShort: "白城"},
		{Id: 107, Code: 59, Province: "辽宁", ProvinceShort: "辽", City: "阜新市", CityShort: "阜新"},
		{Id: 108, Code: 252, Province: "安徽", ProvinceShort: "皖", City: "黄山市", CityShort: "黄山"},
		{Id: 109, Code: 41, Province: "黑龙江", ProvinceShort: "黑", City: "齐齐哈尔市", CityShort: "齐齐哈尔"},
		{Id: 110, Code: 2734, Province: "湖北", ProvinceShort: "鄂", City: "神农架林区", CityShort: "神农架林区"},
		{Id: 111, Code: 200, Province: "广东", ProvinceShort: "粤", City: "河源市", CityShort: "河源"},
		{Id: 112, Code: 65, Province: "青海", ProvinceShort: "青", City: "海西蒙古族藏族自治州", CityShort: "海西州"},
		{Id: 113, Code: 279, Province: "江西", ProvinceShort: "赣", City: "鹰潭市", CityShort: "鹰潭"},
		{Id: 114, Code: 1293, Province: "湖北", ProvinceShort: "鄂", City: "潜江市", CityShort: "潜江"},
		{Id: 115, Code: 77, Province: "四川", ProvinceShort: "川", City: "眉山市", CityShort: "眉山"},
		{Id: 116, Code: 359, Province: "甘肃", ProvinceShort: "甘", City: "平凉市", CityShort: "平凉"},
		{Id: 117, Code: 114, Province: "云南", ProvinceShort: "滇", City: "丽江市", CityShort: "丽江"},
		{Id: 118, Code: 125, Province: "海南", ProvinceShort: "琼", City: "海口市", CityShort: "海口"},
		{Id: 119, Code: 364, Province: "江西", ProvinceShort: "赣", City: "上饶市", CityShort: "上饶"},
		{Id: 120, Code: 44, Province: "黑龙江", ProvinceShort: "黑", City: "绥化市", CityShort: "绥化"},
		{Id: 121, Code: 157, Province: "湖北", ProvinceShort: "鄂", City: "荆州市", CityShort: "荆州"},
		{Id: 122, Code: 37, Province: "甘肃", ProvinceShort: "甘", City: "酒泉市", CityShort: "酒泉"},
		{Id: 123, Code: 188, Province: "安徽", ProvinceShort: "皖", City: "亳州市", CityShort: "亳州"},
		{Id: 124, Code: 89, Province: "新疆", ProvinceShort: "新", City: "吐鲁番地区", CityShort: "吐鲁番"},
		{Id: 125, Code: 269, Province: "河南", ProvinceShort: "豫", City: "驻马店市", CityShort: "驻马店"},
		{Id: 126, Code: 322, Province: "宁夏", ProvinceShort: "宁", City: "吴忠市", CityShort: "吴忠"},
		{Id: 127, Code: 310, Province: "湖北", ProvinceShort: "鄂", City: "孝感市", CityShort: "孝感"},
		{Id: 128, Code: 235, Province: "山东", ProvinceShort: "鲁", City: "滨州市", CityShort: "滨州"},
		{Id: 129, Code: 358, Province: "辽宁", ProvinceShort: "辽", City: "马鞍山市", CityShort: "马鞍山"},
		{Id: 130, Code: 327, Province: "山西", ProvinceShort: "晋", City: "吕梁市", CityShort: "吕梁"},
		{Id: 131, Code: 206, Province: "贵州", ProvinceShort: "黔", City: "毕节地区", CityShort: "毕节"},
		{Id: 132, Code: 66, Province: "青海", ProvinceShort: "青", City: "西宁市", CityShort: "西宁"},
		{Id: 133, Code: 42, Province: "黑龙江", ProvinceShort: "黑", City: "佳木斯市", CityShort: "佳木斯"},
		{Id: 134, Code: 115, Province: "云南", ProvinceShort: "滇", City: "迪庆藏族自治州", CityShort: "迪庆州"},
		{Id: 135, Code: 2911, Province: DirectCity, ProvinceShort: "澳", City: "澳门特别行政区", CityShort: "澳门"},
		{Id: 136, Code: 260, Province: "广西", ProvinceShort: "桂", City: "贺州市", CityShort: "贺州"},
		{Id: 137, Code: 110, Province: "云南", ProvinceShort: "滇", City: "临沧市", CityShort: "临沧"},
		{Id: 138, Code: 52, Province: "吉林", ProvinceShort: "吉", City: "松原市", CityShort: "松原"},
		{Id: 139, Code: 111, Province: "云南", ProvinceShort: "滇", City: "大理白族自治州", CityShort: "大理州"},
		{Id: 140, Code: 267, Province: "河南", ProvinceShort: "豫", City: "安阳市", CityShort: "安阳"},
		{Id: 141, Code: 33, Province: "甘肃", ProvinceShort: "甘", City: "嘉峪关市", CityShort: "嘉峪关"},
		{Id: 142, Code: 112, Province: "云南", ProvinceShort: "滇", City: "保山市", CityShort: "保山"},
		{Id: 143, Code: 85, Province: "新疆", ProvinceShort: "新", City: "阿克苏地区", CityShort: "阿克苏"},
		{Id: 144, Code: 39, Province: "黑龙江", ProvinceShort: "黑", City: "黑河市", CityShort: "黑河"},
		{Id: 145, Code: 2358, Province: "海南", ProvinceShort: "琼", City: "琼海市", CityShort: "琼海"},
		{Id: 146, Code: 70, Province: "青海", ProvinceShort: "青", City: "黄南藏族自治州", CityShort: "黄南州"},
		{Id: 147, Code: 362, Province: "湖北", ProvinceShort: "鄂", City: "咸宁市", CityShort: "咸宁"},
		{Id: 148, Code: 204, Province: "广西", ProvinceShort: "桂", City: "防城港市", CityShort: "防城港"},
		{Id: 149, Code: 69, Province: "青海", ProvinceShort: "青", City: "海东地区", CityShort: "海东"},
		{Id: 150, Code: 243, Province: "浙江", ProvinceShort: "浙", City: "衢州市", CityShort: "衢州"},
		{Id: 151, Code: 271, Province: "湖北", ProvinceShort: "鄂", City: "黄冈市", CityShort: "黄冈"},
		{Id: 152, Code: 251, Province: "安徽", ProvinceShort: "皖", City: "巢湖市", CityShort: "巢湖"},
		{Id: 153, Code: 76, Province: "四川", ProvinceShort: "川", City: "雅安市", CityShort: "雅安"},
		{Id: 154, Code: 67, Province: "青海", ProvinceShort: "青", City: "海北藏族自治州", CityShort: "海北州"},
		{Id: 155, Code: 93, Province: "新疆", ProvinceShort: "新", City: "昌吉回族自治州", CityShort: "昌吉"},
		{Id: 156, Code: 250, Province: "安徽", ProvinceShort: "皖", City: "淮南市", CityShort: "淮南"},
		{Id: 157, Code: 63, Province: "内蒙古自治区", ProvinceShort: "", City: "锡林郭勒盟", CityShort: "锡林郭勒盟"},
		{Id: 158, Code: 370, Province: "安徽", ProvinceShort: "皖", City: "宿州市", CityShort: "宿州"},
		{Id: 159, Code: 9014, Province: "台湾", ProvinceShort: "台", City: "云林县", CityShort: "云林县"},
		{Id: 160, Code: 284, Province: "陕西", ProvinceShort: "陕", City: "延安市", CityShort: "延安"},
		{Id: 161, Code: 216, Province: "湖北", ProvinceShort: "鄂", City: "十堰市", CityShort: "十堰"},
		{Id: 162, Code: 329, Province: "四川", ProvinceShort: "川", City: "广元市", CityShort: "广元"},
		{Id: 163, Code: 145, Province: "广西", ProvinceShort: "桂", City: "钦州市", CityShort: "钦州"},
		{Id: 164, Code: 9007, Province: "台湾", ProvinceShort: "台", City: "澎湖县", CityShort: "澎湖县"},
		{Id: 165, Code: 60, Province: "辽宁", ProvinceShort: "辽", City: "铁岭市", CityShort: "铁岭"},
		{Id: 166, Code: 313, Province: "湖南", ProvinceShort: "湘", City: "湘潭市", CityShort: "湘潭"},
		{Id: 167, Code: 124, Province: "山东", ProvinceShort: "鲁", City: "莱芜市", CityShort: "莱芜"},
		{Id: 168, Code: 82, Province: "新疆", ProvinceShort: "新", City: "和田地区", CityShort: "和田"},
		{Id: 169, Code: 355, Province: "山西", ProvinceShort: "晋", City: "大同市", CityShort: "大同"},
		{Id: 170, Code: 256, Province: "甘肃", ProvinceShort: "甘", City: "陇南市", CityShort: "陇南"},
		{Id: 171, Code: 319, Province: "辽宁", ProvinceShort: "辽", City: "葫芦岛市", CityShort: "葫芦岛"},
		{Id: 172, Code: 203, Province: "广西", ProvinceShort: "桂", City: "百色市", CityShort: "百色"},
		{Id: 173, Code: 292, Province: "浙江", ProvinceShort: "浙", City: "丽水市", CityShort: "丽水"},
		{Id: 174, Code: 78, Province: "四川", ProvinceShort: "川", City: "自贡市", CityShort: "自贡"},
		{Id: 175, Code: 1515, Province: "海南", ProvinceShort: "琼", City: "南沙群岛", CityShort: "南沙群岛"},
		{Id: 176, Code: 9002, Province: "台湾", ProvinceShort: "台", City: "台北市", CityShort: "台北"},
		{Id: 177, Code: 54, Province: "吉林", ProvinceShort: "吉", City: "延边朝鲜族自治州", CityShort: "延边"},
		{Id: 178, Code: 323, Province: "陕西", ProvinceShort: "陕", City: "咸阳市", CityShort: "咸阳"},
		{Id: 179, Code: 1277, Province: "河南", ProvinceShort: "豫", City: "济源市", CityShort: "济源"},
		{Id: 180, Code: 1641, Province: "海南", ProvinceShort: "琼", City: "屯昌县", CityShort: "屯昌"},
		{Id: 181, Code: 311, Province: "湖北", ProvinceShort: "鄂", City: "黄石市", CityShort: "黄石"},
		{Id: 182, Code: 731, Province: "新疆", ProvinceShort: "新", City: "阿拉尔市", CityShort: "阿拉尔"},
		{Id: 183, Code: 43, Province: "黑龙江", ProvinceShort: "黑", City: "鹤岗市", CityShort: "鹤岗"},
		{Id: 184, Code: 9006, Province: "台湾", ProvinceShort: "台", City: "新竹县", CityShort: "新竹县"},
		{Id: 185, Code: 226, Province: "江西", ProvinceShort: "赣", City: "抚州市", CityShort: "抚州"},
		{Id: 186, Code: 789, Province: "新疆", ProvinceShort: "新", City: "五家渠市", CityShort: "五家渠"},
		{Id: 187, Code: 183, Province: "吉林", ProvinceShort: "吉", City: "辽源市", CityShort: "辽源"},
		{Id: 188, Code: 246, Province: "宁夏", ProvinceShort: "宁", City: "固原市", CityShort: "固原"},
		{Id: 189, Code: 109, Province: "云南", ProvinceShort: "滇", City: "西双版纳傣族自治州", CityShort: "西双版纳"},
		{Id: 190, Code: 61, Province: "内蒙古", ProvinceShort: "蒙", City: "呼伦贝尔市", CityShort: "呼伦贝尔"},
		{Id: 191, Code: 242, Province: "四川", ProvinceShort: "川", City: "资阳市", CityShort: "资阳"},
		{Id: 192, Code: 207, Province: "河北", ProvinceShort: "冀", City: "承德市", CityShort: "承德"},
		{Id: 193, Code: 137, Province: "广东", ProvinceShort: "粤", City: "韶关市", CityShort: "韶关"},
		{Id: 194, Code: 282, Province: "辽宁", ProvinceShort: "辽", City: "丹东市", CityShort: "丹东"},
		{Id: 195, Code: 164, Province: "江西", ProvinceShort: "赣", City: "新余市", CityShort: "新余"},
		{Id: 196, Code: 86, Province: "新疆", ProvinceShort: "新", City: "巴音郭楞蒙古自治州", CityShort: "巴音郭楞蒙古"},
		{Id: 197, Code: 770, Province: "新疆", ProvinceShort: "新", City: "石河子市", CityShort: "石河子"},
		{Id: 198, Code: 232, Province: "陕西", ProvinceShort: "陕", City: "铜川市", CityShort: "铜川"},
		{Id: 199, Code: 126, Province: "安徽", ProvinceShort: "皖", City: "蚌埠市", CityShort: "蚌埠"},
		{Id: 200, Code: 336, Province: "云南", ProvinceShort: "滇", City: "昭通市", CityShort: "昭通"},
		{Id: 201, Code: 84, Province: "新疆", ProvinceShort: "新", City: "克孜勒苏柯尔克孜自治州", CityShort: "克孜勒苏柯尔克孜"},
		{Id: 202, Code: 249, Province: "云南", ProvinceShort: "滇", City: "曲靖市", CityShort: "曲靖"},
		{Id: 203, Code: 2654, Province: "湖北", ProvinceShort: "鄂", City: "天门市", CityShort: "天门"},
		{Id: 204, Code: 141, Province: "广东", ProvinceShort: "粤", City: "梅州市", CityShort: "梅州"},
		{Id: 205, Code: 97, Province: "西藏", ProvinceShort: "藏", City: "山南地区", CityShort: "山南"},
		{Id: 206, Code: 214, Province: "河南", ProvinceShort: "豫", City: "信阳市", CityShort: "信阳"},
		{Id: 207, Code: 40, Province: "黑龙江", ProvinceShort: "黑", City: "伊春市", CityShort: "伊春"},
		{Id: 208, Code: 96, Province: "新疆", ProvinceShort: "新", City: "阿勒泰地区", CityShort: "阿勒泰"},
		{Id: 209, Code: 266, Province: "河北", ProvinceShort: "冀", City: "邢台市", CityShort: "邢台"},
		{Id: 210, Code: 142, Province: "广西", ProvinceShort: "桂", City: "桂林市", CityShort: "桂林"},
		{Id: 211, Code: 166, Province: "辽宁", ProvinceShort: "辽", City: "锦州市", CityShort: "锦州"},
		{Id: 212, Code: 100, Province: "西藏", ProvinceShort: "藏", City: "拉萨市", CityShort: "拉萨"},
		{Id: 213, Code: 248, Province: "四川", ProvinceShort: "川", City: "内江市", CityShort: "内江"},
		{Id: 214, Code: 9001, Province: "台湾", ProvinceShort: "台", City: "桃园市", CityShort: "桃园"},
		{Id: 215, Code: 253, Province: "安徽", ProvinceShort: "皖", City: "淮北市", CityShort: "淮北"},
		{Id: 216, Code: 314, Province: "湖南", ProvinceShort: "湘", City: "永州市", CityShort: "永州"},
		{Id: 217, Code: 56, Province: "吉林", ProvinceShort: "吉", City: "四平市", CityShort: "四平"},
		{Id: 218, Code: 258, Province: "广东", ProvinceShort: "粤", City: "云浮市", CityShort: "云浮"},
		{Id: 219, Code: 9010, Province: "台湾", ProvinceShort: "台", City: "新北市", CityShort: "新北"},
		{Id: 220, Code: 34, Province: "甘肃", ProvinceShort: "甘", City: "金昌市", CityShort: "金昌"},
		{Id: 221, Code: 2634, Province: "海南", ProvinceShort: "琼", City: "东方市", CityShort: "东方"},
		{Id: 222, Code: 212, Province: "河南", ProvinceShort: "豫", City: "三门峡市", CityShort: "三门峡"},
		{Id: 223, Code: 1643, Province: "海南", ProvinceShort: "琼", City: "陵水黎族自治县", CityShort: "陵水"},
		{Id: 224, Code: 2033, Province: "海南", ProvinceShort: "琼", City: "临高县", CityShort: "临高"},
		{Id: 225, Code: 81, Province: "四川", ProvinceShort: "川", City: "攀枝花市", CityShort: "攀枝花"},
		{Id: 226, Code: 196, Province: "甘肃", ProvinceShort: "甘", City: "天水市", CityShort: "天水"},
		{Id: 227, Code: 118, Province: "甘肃", ProvinceShort: "甘", City: "武威市", CityShort: "武威"},
		{Id: 228, Code: 363, Province: "湖南", ProvinceShort: "湘", City: "怀化市", CityShort: "怀化"},
		{Id: 229, Code: 273, Province: "湖南", ProvinceShort: "湘", City: "邵阳市", CityShort: "邵阳"},
		{Id: 230, Code: 245, Province: "浙江", ProvinceShort: "浙", City: "舟山市", CityShort: "舟山"},
		{Id: 231, Code: 238, Province: "山西", ProvinceShort: "晋", City: "晋中市", CityShort: "晋中"},
		{Id: 232, Code: 9013, Province: "台湾", ProvinceShort: "台", City: "嘉义县", CityShort: "嘉义县"},
		{Id: 233, Code: 35, Province: "甘肃", ProvinceShort: "甘", City: "白银市", CityShort: "白银"},
		{Id: 234, Code: 208, Province: "河北", ProvinceShort: "冀", City: "衡水市", CityShort: "衡水"},
		{Id: 235, Code: 46, Province: "黑龙江", ProvinceShort: "黑", City: "鸡西市", CityShort: "鸡西"},
		{Id: 236, Code: 202, Province: "广西", ProvinceShort: "桂", City: "来宾市", CityShort: "来宾"},
		{Id: 237, Code: 1217, Province: "海南", ProvinceShort: "琼", City: "保亭黎族苗族自治县", CityShort: "保亭"},
		{Id: 238, Code: 312, Province: "湖南", ProvinceShort: "湘", City: "张家界市", CityShort: "张家界"},
		{Id: 239, Code: 185, Province: "四川", ProvinceShort: "川", City: "阿坝藏族羌族自治州", CityShort: "阿坝州"},
		{Id: 240, Code: 101, Province: "西藏", ProvinceShort: "藏", City: "那曲地区", CityShort: "那曲"},
		{Id: 241, Code: 38, Province: "黑龙江", ProvinceShort: "黑", City: "大兴安岭地区", CityShort: "大兴安岭"},
		{Id: 242, Code: 68, Province: "青海", ProvinceShort: "青", City: "海南藏族自治州", CityShort: "海南州"},
		{Id: 243, Code: 168, Province: "内蒙古", ProvinceShort: "蒙", City: "乌兰察布市", CityShort: "乌兰察布"},
		{Id: 244, Code: 308, Province: "河南", ProvinceShort: "豫", City: "周口市", CityShort: "周口"},
		{Id: 245, Code: 304, Province: "广西", ProvinceShort: "桂", City: "梧州市", CityShort: "梧州"},
		{Id: 246, Code: 9005, Province: "台湾", ProvinceShort: "台", City: "彰化县", CityShort: "彰化县"},
		{Id: 247, Code: 184, Province: "辽宁", ProvinceShort: "辽", City: "抚顺市", CityShort: "抚顺"},
		{Id: 248, Code: 335, Province: "宁夏", ProvinceShort: "宁", City: "石嘴山市", CityShort: "石嘴山"},
		{Id: 249, Code: 213, Province: "河南", ProvinceShort: "豫", City: "平顶山市", CityShort: "平顶山"},
		{Id: 250, Code: 225, Province: "江西", ProvinceShort: "赣", City: "景德镇市", CityShort: "景德镇"},
		{Id: 251, Code: 1713, Province: "湖北", ProvinceShort: "鄂", City: "仙桃市", CityShort: "仙桃"},
		{Id: 252, Code: 1498, Province: "海南", ProvinceShort: "琼", City: "中沙群岛", CityShort: "中沙群岛"},
		{Id: 253, Code: 367, Province: "山西", ProvinceShort: "晋", City: "忻州市", CityShort: "忻州"},
		{Id: 254, Code: 331, Province: "四川", ProvinceShort: "川", City: "泸州市", CityShort: "泸州"},
		{Id: 255, Code: 247, Province: "甘肃", ProvinceShort: "甘", City: "甘南藏族自治州", CityShort: "甘南州"},
		{Id: 256, Code: 103, Province: "西藏", ProvinceShort: "藏", City: "阿里地区", CityShort: "阿里"},
		{Id: 257, Code: 357, Province: "山西", ProvinceShort: "晋", City: "阳泉市", CityShort: "阳泉"},
		{Id: 258, Code: 169, Province: "内蒙古", ProvinceShort: "蒙", City: "巴彦淖尔市", CityShort: "巴彦淖尔"},
		{Id: 259, Code: 154, Province: "河南", ProvinceShort: "豫", City: "商丘市", CityShort: "商丘"},
		{Id: 260, Code: 57, Province: "吉林", ProvinceShort: "吉", City: "白山市", CityShort: "白山"},
		{Id: 261, Code: 182, Province: "甘肃", ProvinceShort: "甘", City: "临夏回族自治州", CityShort: "临夏"},
		{Id: 262, Code: 343, Province: "贵州", ProvinceShort: "黔", City: "黔西南布依族苗族自治州", CityShort: "黔西南州"},
		{Id: 263, Code: 88, Province: "新疆", ProvinceShort: "新", City: "博尔塔拉蒙古自治州", CityShort: "博尔塔拉"},
		{Id: 264, Code: 227, Province: "辽宁", ProvinceShort: "辽", City: "本溪市", CityShort: "本溪"},
		{Id: 265, Code: 2912, Province: DirectCity, ProvinceShort: "港", City: "香港特别行政区", CityShort: "香港"},
		{Id: 266, Code: 181, Province: "宁夏", ProvinceShort: "宁", City: "中卫市", CityShort: "中卫"},
		{Id: 267, Code: 2359, Province: "海南", ProvinceShort: "琼", City: "白沙黎族自治县", CityShort: "白沙"},
		{Id: 268, Code: 128, Province: "安徽", ProvinceShort: "皖", City: "阜阳市", CityShort: "阜阳"},
		{Id: 269, Code: 295, Province: "广西", ProvinceShort: "桂", City: "北海市", CityShort: "北海"},
		{Id: 270, Code: 352, Province: "陕西", ProvinceShort: "陕", City: "汉中市", CityShort: "汉中"},
		{Id: 271, Code: 330, Province: "四川", ProvinceShort: "川", City: "遂宁市", CityShort: "遂宁"},
		{Id: 272, Code: 133, Province: "福建", ProvinceShort: "闽", City: "南平市", CityShort: "南平"},
		{Id: 273, Code: 215, Province: "河南", ProvinceShort: "豫", City: "鹤壁市", CityShort: "鹤壁"},
		{Id: 274, Code: 1214, Province: "海南", ProvinceShort: "琼", City: "定安县", CityShort: "定安"},
		{Id: 275, Code: 9017, Province: "台湾", ProvinceShort: "台", City: "台中市", CityShort: "台中"},
		{Id: 276, Code: 228, Province: "辽宁", ProvinceShort: "辽", City: "盘锦市", CityShort: "盘锦"},
		{Id: 277, Code: 99, Province: "西藏", ProvinceShort: "藏", City: "昌都地区", CityShort: "昌都"},
		{Id: 278, Code: 237, Province: "山西", ProvinceShort: "晋", City: "朔州市", CityShort: "朔州"},
		{Id: 279, Code: 107, Province: "云南", ProvinceShort: "滇", City: "红河哈尼族彝族自治州", CityShort: "红河州"},
		{Id: 280, Code: 113, Province: "云南", ProvinceShort: "滇", City: "怒江傈僳族自治州", CityShort: "怒江州"},
		{Id: 281, Code: 339, Province: "广东", ProvinceShort: "粤", City: "汕尾市", CityShort: "汕尾"},
		{Id: 282, Code: 117, Province: "甘肃", ProvinceShort: "甘", City: "张掖市", CityShort: "张掖"},
		{Id: 283, Code: 9016, Province: "台湾", ProvinceShort: "台", City: "台南市", CityShort: "台南"},
		{Id: 284, Code: 73, Province: "四川", ProvinceShort: "川", City: "甘孜藏族自治州", CityShort: "甘孜州"},
		{Id: 285, Code: 9003, Province: "台湾", ProvinceShort: "台", City: "南投县", CityShort: "南投县"},
		{Id: 286, Code: 45, Province: "黑龙江", ProvinceShort: "黑", City: "双鸭山市", CityShort: "双鸭山"},
		{Id: 287, Code: 9019, Province: "台湾", ProvinceShort: "台", City: "高雄市", CityShort: "高雄"},
		{Id: 288, Code: 290, Province: "山西", ProvinceShort: "晋", City: "晋城市", CityShort: "晋城"},
		{Id: 289, Code: 122, Province: "湖北", ProvinceShort: "鄂", City: "鄂州市", CityShort: "鄂州"},
		{Id: 290, Code: 106, Province: "云南", ProvinceShort: "滇", City: "玉溪市", CityShort: "玉溪"},
		{Id: 291, Code: 201, Province: "广东", ProvinceShort: "粤", City: "潮州市", CityShort: "潮州"},
		{Id: 292, Code: 274, Province: "湖南", ProvinceShort: "湘", City: "湘西土家族苗族自治州", CityShort: "湘西"},
		{Id: 293, Code: 297, Province: "内蒙古", ProvinceShort: "蒙", City: "赤峰市", CityShort: "赤峰"},
		{Id: 294, Code: 2758, Province: "海南", ProvinceShort: "琼", City: "文昌市", CityShort: "文昌"},
		{Id: 295, Code: 1218, Province: "海南", ProvinceShort: "琼", City: "西沙群岛", CityShort: "西沙群岛"},
		{Id: 296, Code: 91, Province: "新疆", ProvinceShort: "新", City: "哈密地区", CityShort: "哈密"},
		{Id: 297, Code: 105, Province: "云南", ProvinceShort: "滇", City: "楚雄彝族自治州", CityShort: "楚雄州"},
		{Id: 298, Code: 298, Province: "安徽", ProvinceShort: "皖", City: "六安市", CityShort: "六安"},
		{Id: 299, Code: 285, Province: "陕西", ProvinceShort: "陕", City: "商洛市", CityShort: "商洛"},
		{Id: 300, Code: 792, Province: "新疆", ProvinceShort: "新", City: "图木舒克市", CityShort: "图木舒克"},
		{Id: 301, Code: 9009, Province: "台湾", ProvinceShort: "台", City: "宜兰县", CityShort: "宜兰县"},
		{Id: 302, Code: 371, Province: "湖北", ProvinceShort: "鄂", City: "随州市", CityShort: "随州"},
		{Id: 303, Code: 192, Province: "福建", ProvinceShort: "闽", City: "宁德市", CityShort: "宁德"},
		{Id: 304, Code: 368, Province: "山西", ProvinceShort: "晋", City: "临汾市", CityShort: "临汾"},
		{Id: 305, Code: 80, Province: "四川", ProvinceShort: "川", City: "凉山彝族自治州", CityShort: "凉山州"},
		{Id: 306, Code: 217, Province: "湖北", ProvinceShort: "鄂", City: "荆门市", CityShort: "荆门"},
		{Id: 307, Code: 291, Province: "四川", ProvinceShort: "川", City: "南充市", CityShort: "南充"},
		{Id: 308, Code: 344, Province: "河南", ProvinceShort: "豫", City: "漯河市", CityShort: "漯河"},
		{Id: 309, Code: 71, Province: "青海", ProvinceShort: "青", City: "玉树藏族自治州", CityShort: "玉树州"},
		{Id: 310, Code: 139, Province: "广东", ProvinceShort: "粤", City: "茂名市", CityShort: "茂名"},
		{Id: 311, Code: 165, Province: "吉林", ProvinceShort: "吉", City: "通化市", CityShort: "通化"},
		{Id: 312, Code: 170, Province: "陕西", ProvinceShort: "陕", City: "渭南市", CityShort: "渭南"},
		{Id: 313, Code: 130, Province: "安徽", ProvinceShort: "皖", City: "安庆市", CityShort: "安庆"},
		{Id: 314, Code: 259, Province: "广东", ProvinceShort: "粤", City: "揭阳市", CityShort: "揭阳"},
		{Id: 315, Code: 356, Province: "山西", ProvinceShort: "晋", City: "长治市", CityShort: "长治"},
		{Id: 316, Code: 9008, Province: "台湾", ProvinceShort: "台", City: "台东县", CityShort: "台东县"},
		{Id: 317, Code: 2032, Province: "海南", ProvinceShort: "琼", City: "乐东黎族自治县", CityShort: "乐东"},
		{Id: 318, Code: 2031, Province: "海南", ProvinceShort: "琼", City: "琼中黎族苗族自治县", CityShort: "琼中"},
		{Id: 319, Code: 197, Province: "广东", ProvinceShort: "粤", City: "清远市", CityShort: "清远"},
		{Id: 320, Code: 9012, Province: "台湾", ProvinceShort: "台", City: "屏东县", CityShort: "屏东县"},
		{Id: 321, Code: 361, Province: "广西", ProvinceShort: "桂", City: "玉林市", CityShort: "玉林"},
		{Id: 322, Code: 147, Province: "贵州", ProvinceShort: "黔", City: "六盘水市", CityShort: "六盘水"},
		{Id: 323, Code: 64, Province: "内蒙古", ProvinceShort: "蒙", City: "通辽市", CityShort: "通辽"},
		{Id: 324, Code: 47, Province: "黑龙江", ProvinceShort: "黑", City: "七台河市", CityShort: "七台河"},
		{Id: 325, Code: 338, Province: "广东", ProvinceShort: "粤", City: "肇庆市", CityShort: "肇庆"},
		{Id: 326, Code: 366, Province: "山东", ProvinceShort: "鲁", City: "聊城市", CityShort: "聊城"},
		{Id: 327, Code: 74, Province: "四川", ProvinceShort: "川", City: "德阳市", CityShort: "德阳"},
		{Id: 328, Code: 9018, Province: "台湾", ProvinceShort: "台", City: "新竹市", CityShort: "新竹"},
		{Id: 329, Code: 263, Province: "贵州", ProvinceShort: "黔", City: "安顺市", CityShort: "安顺"},
		{Id: 330, Code: 9011, Province: "台湾", ProvinceShort: "台", City: "基隆市", CityShort: "基隆"},
		{Id: 331, Code: 303, Province: "广东", ProvinceShort: "粤", City: "汕头市", CityShort: "汕头"},
		{Id: 332, Code: 148, Province: "河北", ProvinceShort: "冀", City: "秦皇岛市", CityShort: "秦皇岛"},
		{Id: 333, Code: 350, Province: "江西", ProvinceShort: "赣", City: "萍乡市", CityShort: "萍乡"},
		{Id: 334, Code: 123, Province: "内蒙古", ProvinceShort: "蒙", City: "乌海市", CityShort: "乌海"},
		{Id: 335, Code: 241, Province: "四川", ProvinceShort: "川", City: "广安市", CityShort: "广安"},
		{Id: 336, Code: 1644, Province: "海南", ProvinceShort: "琼", City: "五指山市", CityShort: "五指山"},
		{Id: 337, Code: 55, Province: "吉林", ProvinceShort: "吉", City: "吉林市", CityShort: "吉林"},
		{Id: 338, Code: 90, Province: "新疆", ProvinceShort: "新", City: "伊犁哈萨克自治州", CityShort: "伊犁哈萨克"},
		{Id: 339, Code: 172, Province: "山东", ProvinceShort: "鲁", City: "枣庄市", CityShort: "枣庄"},
		{Id: 340, Code: 190, Province: "安徽", ProvinceShort: "皖", City: "宣城市", CityShort: "宣城"},
		{Id: 341, Code: 239, Province: "四川", ProvinceShort: "川", City: "巴中市", CityShort: "巴中"},
		{Id: 342, Code: 351, Province: "辽宁", ProvinceShort: "辽", City: "辽阳市", CityShort: "辽阳"},
		{Id: 343, Code: 1642, Province: "海南", ProvinceShort: "琼", City: "昌江黎族自治县", CityShort: "昌江"},
		{Id: 344, Code: 209, Province: "河南", ProvinceShort: "豫", City: "濮阳市", CityShort: "濮阳"},
		{Id: 345, Code: 324, Province: "陕西", ProvinceShort: "陕", City: "安康市", CityShort: "安康"},
		{Id: 346, Code: 318, Province: "江西", ProvinceShort: "赣", City: "吉安市", CityShort: "吉安"},
		{Id: 347, Code: 94, Province: "新疆", ProvinceShort: "新", City: "塔城地区", CityShort: "塔城"},
		{Id: 348, Code: 108, Province: "云南", ProvinceShort: "滇", City: "普洱市", CityShort: "普洱"},
		{Id: 349, Code: 341, Province: "广西", ProvinceShort: "桂", City: "贵港市", CityShort: "贵港"},
		{Id: 350, Code: 205, Province: "贵州", ProvinceShort: "黔", City: "铜仁地区", CityShort: "铜仁"},
		{Id: 351, Code: 186, Province: "四川", ProvinceShort: "川", City: "宜宾市", CityShort: "宜宾"},
		{Id: 352, Code: 49, Province: "黑龙江", ProvinceShort: "黑", City: "牡丹江市", CityShort: "牡丹江"},
		{Id: 353, Code: 2757, Province: "海南", ProvinceShort: "琼", City: "澄迈县", CityShort: "澄迈"},
		{Id: 354, Code: 1216, Province: "海南", ProvinceShort: "琼", City: "万宁市", CityShort: "万宁"},
		{Id: 355, Code: 95, Province: "新疆", ProvinceShort: "新", City: "克拉玛依市", CityShort: "克拉玛依"},
		{Id: 356, Code: 281, Province: "辽宁", ProvinceShort: "辽", City: "营口市", CityShort: "营口"},
		{Id: 357, Code: 121, Province: "海南", ProvinceShort: "琼", City: "三亚市", CityShort: "三亚"},
		{Id: 358, Code: 9020, Province: "台湾", ProvinceShort: "台", City: "苗栗县", CityShort: "苗栗县"},
		{Id: 359, Code: 1215, Province: "海南", ProvinceShort: "琼", City: "儋州市", CityShort: "儋州"},
		{Id: 360, Code: 143, Province: "广西", ProvinceShort: "桂", City: "河池市", CityShort: "河池"},
		{Id: 361, Code: 9004, Province: "台湾", ProvinceShort: "台", City: "嘉义市", CityShort: "嘉义"},
		{Id: 362, Code: 272, Province: "湖南", ProvinceShort: "湘", City: "益阳市", CityShort: "益阳"},
		{Id: 363, Code: 306, Province: "贵州", ProvinceShort: "黔", City: "黔南布依族苗族自治州", CityShort: "黔南"},
		{Id: 364, Code: 177, Province: "云南", ProvinceShort: "滇", City: "文山壮族苗族自治州", CityShort: "文山"},
		{Id: 365, Code: 369, Province: "四川", ProvinceShort: "川", City: "达州市", CityShort: "达州"},
		{Id: 366, Code: 98, Province: "西藏", ProvinceShort: "藏", City: "林芝地区", CityShort: "林芝"},
		{Id: 367, Code: 135, Province: "甘肃", ProvinceShort: "甘", City: "庆阳市", CityShort: "庆阳"},
		{Id: 368, Code: 280, Province: "辽宁", ProvinceShort: "辽", City: "朝阳市", CityShort: "朝阳"},
		{Id: 369, Code: 9015, Province: "台湾", ProvinceShort: "台", City: "花莲县", CityShort: "花莲县"},
		{Id: 370, Code: 221, Province: "湖南", ProvinceShort: "湘", City: "娄底市", CityShort: "娄底"},
		{Id: 371, Code: 116, Province: "云南", ProvinceShort: "滇", City: "德宏傣族景颇族自治州", CityShort: "德宏州"},
		{Id: 372, Code: 102, Province: "西藏", ProvinceShort: "藏", City: "日喀则地区", CityShort: "日喀则"},
		{Id: 373, Code: 230, Province: "内蒙古", ProvinceShort: "蒙", City: "阿拉善盟", CityShort: "阿拉善盟"},
		{Id: 374, Code: 72, Province: "青海", ProvinceShort: "青", City: "果洛藏族自治州", CityShort: "果洛州"},
		{Id: 375, Code: 210, Province: "河南", ProvinceShort: "豫", City: "开封市", CityShort: "开封"},
		{Id: 376, Code: 120, Province: "广东", ProvinceShort: "粤", City: "东沙群岛", CityShort: "东沙群岛"},
		{Id: 377, Code: 299, Province: "安徽", ProvinceShort: "皖", City: "池州市", CityShort: "池州"},
		{Id: 378, Code: 342, Province: "贵州", ProvinceShort: "黔", City: "黔东南苗族侗族自治州", CityShort: "黔东南"},
		{Id: 379, Code: 337, Province: "安徽", ProvinceShort: "皖", City: "铜陵市", CityShort: "铜陵"},
		{Id: 380, Code: 275, Province: "湖南", ProvinceShort: "湘", City: "郴州市", CityShort: "郴州"},
		{Id: 381, Code: 83, Province: "新疆", ProvinceShort: "新", City: "喀什地区", CityShort: "喀什"},
		{Id: 382, Code: 79, Province: "四川", ProvinceShort: "川", City: "乐山市", CityShort: "乐山"},
		{Id: 383, Code: 173, Province: "山东", ProvinceShort: "鲁", City: "日照市", CityShort: "日照"},
		{Id: 384, Code: 360, Province: "宁夏", ProvinceShort: "宁", City: "银川市", CityShort: "银川"},
		{Id: 385, Code: 171, Province: "陕西", ProvinceShort: "陕", City: "宝鸡市", CityShort: "宝鸡"},
		{Id: 386, Code: 136, Province: "甘肃", ProvinceShort: "甘", City: "定西市", CityShort: "定西"},
		{Id: 387, Code: 144, Province: "广西", ProvinceShort: "桂", City: "崇左市", CityShort: "崇左"},
	}
	Cities = Locations.Cities()
	Map    = Locations.ByCityMap()
	IdMap  = Locations.ByIdMap()
)

// 输出
func (l locations) ByCityMap() map[string]Location {
	m := make(map[string]Location, len(l))
	for _, v := range l {
		m[v.CityShort] = v
	}
	return m
}
func (l locations) ByIdMap() map[int]Location {
	m := make(map[int]Location, len(l))
	for _, v := range l {
		m[v.Id] = v
	}
	return m
}
func (l locations) Cities() []string {
	cities := make([]string, len(l))
	for i, v := range l {
		cities[i] = v.CityShort
	}
	return cities
}

//根据城市获取省份
func ProvinceByCity(city string) string {
	city = strings.ReplaceAll(city, "市", "")
	if location, ok := Map[city]; ok {
		if location.Province == DirectCity {
			return city
		}
		return location.Province
	}
	return ""
}

//根据省份获取城市
func CitiesByProvince(province string) (cities []string) {
	cities = make([]string, 0, 20)
	for k, v := range Map {
		if province == v.Province {
			cities = append(cities, k)
		}
	}
	return cities
}

//随机选择城市
func ChoiceCity() string {
	return ChoiceString(Cities)
}

//随机选择多个城市
func ChoiceCityN(n int) []Location {
	if n < 1 {
		return []Location{Map[ChoiceString(Cities)]}
	}
	var locations []Location
	for _, v := range ChoiceStringN(Cities, n) {
		locations = append(locations, Map[v])
	}
	return locations
}
func GetCityById(id int) string {
	if l, ok := IdMap[id]; ok {
		return l.CityShort
	}
	return ""
}
func GetCityByIds(ids ...int) []string {
	ls := make([]string, 0, len(ids))
	for _, id := range ids {
		if l, ok := IdMap[id]; ok {
			ls = append(ls, l.CityShort)
		}
	}
	return ls
}
