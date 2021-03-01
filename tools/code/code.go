package code

const (
	Unicode = "unicode"
)

type Decoder func(string) string

var (
	Decodes = map[string]Decoder{
		Unicode: DeUnicode,
	}
	Encodes = map[string]Decoder{
		Unicode: EnUnicode,
	}
)
