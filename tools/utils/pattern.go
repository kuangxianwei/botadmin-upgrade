package utils

import "regexp"

const (
	DomainContent = `(?:[a-z0-9][a-z0-9-]*?\.)`
	IP            = `(?:\b|\D)((?:(?:\d{1,2}|(?:1\d{1,2})|(?:2[0-4]\d)|(?:25[0-5]))\.){3}(?:(?:\d{1,2})|(?:1\d{1,2})|(?:2[0-4]\d)|(?:25[0-5])))(?:\b|\D)`
	Phone         = `(?:\b|\D)((?:\+\d{1,4})*?\d{11})(?:\b|\D)`
)

var (
	DomainPattern = regexp.MustCompile(`(?i)(` + DomainContent + `+` + DomainSuffix + `)`)
	HostPattern   = regexp.MustCompile(`(?i)(` + DomainContent + `{1}` + DomainSuffix + `)`)
	IpPattern     = regexp.MustCompile(IP)
)
