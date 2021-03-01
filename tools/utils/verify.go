package utils

import "regexp"

var (
	PatternName     = regexp.MustCompile(`^[a-zA-Z0-9_.]{1,16}$`)
	PatternNamePlus = regexp.MustCompile(`^[^-][a-zA-Z0-9_.-]{1,16}$`)
	PatternPassword = regexp.MustCompile(`^\S{1,16}$`)
)

func VerifyName(name string) bool {
	return PatternName.MatchString(name)
}
func VerifyNamePlus(name string) bool {
	return PatternNamePlus.MatchString(name)
}
func VerifyPassword(name string) bool {
	return PatternPassword.MatchString(name)
}
