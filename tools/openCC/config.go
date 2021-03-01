package openCC

const (
	Hk2s  = "hk2s"
	S2hk  = "s2hk"
	S2t   = "s2t"
	S2tw  = "s2tw"
	S2twp = "s2twp"
	T2hk  = "t2hk"
	T2s   = "t2s"
	T2tw  = "t2tw"
	Tw2s  = "tw2s"
	Tw2sp = "tw2sp"
)

type (
	Dict struct {
		Type  string `json:"type"`
		File  string `json:"file"`
		Dicts []Dict `json:"dicts"`
	}
	Segmentation struct {
		Type string `json:"type"`
		Dict Dict   `json:"dict"`
	}
	Config struct {
		Name            string       `json:"name"`
		Alias           string       `json:"alias"`
		Segmentation    Segmentation `json:"segmentation"`
		ConversionChain []Dict       `json:"conversion_chain"`
	}
)

var (
	Conversions = []Config{
		{
			Name:         T2s,
			Alias:        "繁体->简体",
			Segmentation: Segmentation{Type: "mmseg", Dict: Dict{Type: "txt", File: "TSPhrases.txt"}},
			ConversionChain: []Dict{
				{Type: "group", Dicts: []Dict{
					{Type: "txt", File: "TSPhrases.txt"},
					{Type: "txt", File: "TSCharacters.txt"},
				}},
			},
		},
		{
			Name:         S2t,
			Alias:        "简体->繁体",
			Segmentation: Segmentation{Type: "mmseg", Dict: Dict{Type: "txt", File: "STPhrases.txt"}},
			ConversionChain: []Dict{
				{Type: "group", Dicts: []Dict{
					{Type: "txt", File: "STPhrases.txt"},
					{Type: "txt", File: "STCharacters.txt"},
				}},
			},
		},
		{
			Name:         Tw2s,
			Alias:        "繁体->简体(台湾)",
			Segmentation: Segmentation{Type: "mmseg", Dict: Dict{Type: "txt", File: "TSPhrases.txt"}},
			ConversionChain: []Dict{
				{Type: "group", Dicts: []Dict{
					{Type: "txt", File: "TWVariantsRevPhrases.txt"},
					{Type: "txt", File: "TWVariantsRev.txt"},
				}},
				{Type: "group", Dicts: []Dict{
					{Type: "txt", File: "TSPhrases.txt"},
					{Type: "txt", File: "TSCharacters.txt"},
				}},
			},
		},
		{
			Name:         S2tw,
			Alias:        "简体->繁体(台湾)",
			Segmentation: Segmentation{Type: "mmseg", Dict: Dict{Type: "txt", File: "STPhrases.txt"}},
			ConversionChain: []Dict{
				{Type: "group", Dicts: []Dict{
					{Type: "txt", File: "STPhrases.txt"},
					{Type: "txt", File: "STCharacters.txt"},
				}},
				{Type: "txt", File: "TWVariants.txt"},
			},
		},
		{
			Name:         Hk2s,
			Alias:        "繁体->简体(香港)",
			Segmentation: Segmentation{Type: "mmseg", Dict: Dict{Type: "txt", File: "TSPhrases.txt"}},
			ConversionChain: []Dict{
				{Type: "group", Dicts: []Dict{
					{Type: "txt", File: "HKVariantsRevPhrases.txt"},
					{Type: "txt", File: "HKVariantsRev.txt"},
				}},
				{Type: "group", Dicts: []Dict{
					{Type: "txt", File: "TSPhrases.txt"},
					{Type: "txt", File: "TSCharacters.txt"},
				}},
			},
		},
		{
			Name:         S2hk,
			Alias:        "简体->繁体(香港)",
			Segmentation: Segmentation{Type: "mmseg", Dict: Dict{Type: "txt", File: "STPhrases.txt"}},
			ConversionChain: []Dict{
				{Type: "group", Dicts: []Dict{
					{Type: "txt", File: "STPhrases.txt"},
					{Type: "txt", File: "STCharacters.txt"},
				}},
				{Type: "group", Dicts: []Dict{
					{Type: "txt", File: "HKVariantsPhrases.txt"},
					{Type: "txt", File: "HKVariants.txt"},
				}},
			},
		},
		{
			Name:         Tw2sp,
			Alias:        "繁体->简体(台湾,带短语)",
			Segmentation: Segmentation{Type: "mmseg", Dict: Dict{Type: "txt", File: "TSPhrases.txt"}},
			ConversionChain: []Dict{
				{Type: "group", Dicts: []Dict{
					{Type: "txt", File: "TWVariantsRevPhrases.txt"},
					{Type: "txt", File: "TWVariantsRev.txt"},
				}},
				{Type: "txt", File: "TWPhrasesRev.txt"},
				{Type: "group", Dicts: []Dict{
					{Type: "txt", File: "TSPhrases.txt"},
					{Type: "txt", File: "TSCharacters.txt"},
				}},
			},
		},
		{
			Name:         S2twp,
			Alias:        "简体->繁体(台湾,带短语)",
			Segmentation: Segmentation{Type: "mmseg", Dict: Dict{Type: "txt", File: "STPhrases.txt"}},
			ConversionChain: []Dict{
				{Type: "group", Dicts: []Dict{
					{Type: "txt", File: "STPhrases.txt"},
					{Type: "txt", File: "STCharacters.txt"},
				}},
				{Type: "txt", File: "TWPhrases.txt"},
				{Type: "txt", File: "TWVariants.txt"},
			},
		},
		{
			Name:         T2hk,
			Alias:        "繁体->繁体(香港)",
			Segmentation: Segmentation{Type: "mmseg", Dict: Dict{Type: "txt", File: "HKVariants.txt"}},
			ConversionChain: []Dict{
				{Type: "txt", File: "HKVariants.txt"},
			},
		},
		{
			Name:         T2tw,
			Alias:        "繁体->繁体(台湾)",
			Segmentation: Segmentation{Type: "mmseg", Dict: Dict{Type: "txt", File: "TWVariants.txt"}},
			ConversionChain: []Dict{
				{Type: "txt", File: "TWVariants.txt"},
			},
		},
	}
	conversionMap map[string]Config
)

func HasConversion(conversion string) bool {
	_, has := conversionMap[conversion]
	return has
}
func tidyConversionMap() {
	if conversionMap == nil {
		conversionMap = make(map[string]Config, len(Conversions))
		for _, v := range Conversions {
			conversionMap[v.Name] = v
		}
	}
}

func init() {
	tidyConversionMap()
}
