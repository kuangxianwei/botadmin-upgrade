package utils

import (
	"bytes"
	"unicode/utf8"
)

var (
	hexes   = "0123456789abcdef"
	safeSet = [utf8.RuneSelf]bool{
		' ':      true,
		'!':      true,
		'"':      false,
		'#':      true,
		'$':      true,
		'%':      true,
		'&':      true,
		'\'':     true,
		'(':      true,
		')':      true,
		'*':      true,
		'+':      true,
		',':      true,
		'-':      true,
		'.':      true,
		'/':      true,
		'0':      true,
		'1':      true,
		'2':      true,
		'3':      true,
		'4':      true,
		'5':      true,
		'6':      true,
		'7':      true,
		'8':      true,
		'9':      true,
		':':      true,
		';':      true,
		'<':      true,
		'=':      true,
		'>':      true,
		'?':      true,
		'@':      true,
		'A':      true,
		'B':      true,
		'C':      true,
		'D':      true,
		'E':      true,
		'F':      true,
		'G':      true,
		'H':      true,
		'I':      true,
		'J':      true,
		'K':      true,
		'L':      true,
		'M':      true,
		'N':      true,
		'O':      true,
		'P':      true,
		'Q':      true,
		'R':      true,
		'S':      true,
		'T':      true,
		'U':      true,
		'V':      true,
		'W':      true,
		'X':      true,
		'Y':      true,
		'Z':      true,
		'[':      true,
		'\\':     false,
		']':      true,
		'^':      true,
		'_':      true,
		'`':      true,
		'a':      true,
		'b':      true,
		'c':      true,
		'd':      true,
		'e':      true,
		'f':      true,
		'g':      true,
		'h':      true,
		'i':      true,
		'j':      true,
		'k':      true,
		'l':      true,
		'm':      true,
		'n':      true,
		'o':      true,
		'p':      true,
		'q':      true,
		'r':      true,
		's':      true,
		't':      true,
		'u':      true,
		'v':      true,
		'w':      true,
		'x':      true,
		'y':      true,
		'z':      true,
		'{':      true,
		'|':      true,
		'}':      true,
		'~':      true,
		'\u007f': true,
	}
	htmlSafeSet = [utf8.RuneSelf]bool{
		' ':      true,
		'!':      true,
		'"':      false,
		'#':      true,
		'$':      true,
		'%':      true,
		'&':      false,
		'\'':     true,
		'(':      true,
		')':      true,
		'*':      true,
		'+':      true,
		',':      true,
		'-':      true,
		'.':      true,
		'/':      true,
		'0':      true,
		'1':      true,
		'2':      true,
		'3':      true,
		'4':      true,
		'5':      true,
		'6':      true,
		'7':      true,
		'8':      true,
		'9':      true,
		':':      true,
		';':      true,
		'<':      false,
		'=':      true,
		'>':      false,
		'?':      true,
		'@':      true,
		'A':      true,
		'B':      true,
		'C':      true,
		'D':      true,
		'E':      true,
		'F':      true,
		'G':      true,
		'H':      true,
		'I':      true,
		'J':      true,
		'K':      true,
		'L':      true,
		'M':      true,
		'N':      true,
		'O':      true,
		'P':      true,
		'Q':      true,
		'R':      true,
		'S':      true,
		'T':      true,
		'U':      true,
		'V':      true,
		'W':      true,
		'X':      true,
		'Y':      true,
		'Z':      true,
		'[':      true,
		'\\':     false,
		']':      true,
		'^':      true,
		'_':      true,
		'`':      true,
		'a':      true,
		'b':      true,
		'c':      true,
		'd':      true,
		'e':      true,
		'f':      true,
		'g':      true,
		'h':      true,
		'i':      true,
		'j':      true,
		'k':      true,
		'l':      true,
		'm':      true,
		'n':      true,
		'o':      true,
		'p':      true,
		'q':      true,
		'r':      true,
		's':      true,
		't':      true,
		'u':      true,
		'v':      true,
		'w':      true,
		'x':      true,
		'y':      true,
		'z':      true,
		'{':      true,
		'|':      true,
		'}':      true,
		'~':      true,
		'\u007f': true,
	}
)

func Escape(s string, escapeHTML ...bool) string {
	var buf bytes.Buffer
	var escape bool
	buf.Grow(len(s))
	start := 0
	if len(escapeHTML) > 0 {
		escape = escapeHTML[0]
	}
	for i := 0; i < len(s); {
		if b := s[i]; b < utf8.RuneSelf {
			if htmlSafeSet[b] || (!escape && safeSet[b]) {
				i++
				continue
			}
			if start < i {
				buf.WriteString(s[start:i])
			}
			buf.WriteByte('\\')
			switch b {
			case '\\', '"':
				buf.WriteByte(b)
			case '\n':
				buf.WriteByte('n')
			case '\r':
				buf.WriteByte('r')
			case '\t':
				buf.WriteByte('t')
			default:
				buf.WriteString(`u00`)
				buf.WriteByte(hexes[b>>4])
				buf.WriteByte(hexes[b&0xF])
			}
			i++
			start = i
			continue
		}
		c, size := utf8.DecodeRuneInString(s[i:])
		if c == utf8.RuneError && size == 1 {
			if start < i {
				buf.WriteString(s[start:i])
			}
			buf.WriteString(`\ufffd`)
			i += size
			start = i
			continue
		}
		if c == '\u2028' || c == '\u2029' {
			if start < i {
				buf.WriteString(s[start:i])
			}
			buf.WriteString(`\u202`)
			buf.WriteByte(hexes[c&0xF])
			i += size
			start = i
			continue
		}
		i += size
	}
	if start < len(s) {
		buf.WriteString(s[start:])
	}
	return buf.String()
}
