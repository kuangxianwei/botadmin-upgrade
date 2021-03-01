package openCC

import (
	"bufio"
	"fmt"
	"github.com/liuzl/cedar-go"
	"io"
	"os"
	"strings"
)

type dict struct {
	Trie   *cedar.Cedar
	Values [][]string
}

// PrefixMatch str by dict, returns the matched string and its according values
func (d *dict) PrefixMatch(str string) (map[string][]string, error) {
	if d.Trie == nil {
		return nil, fmt.Errorf("Trie is nil")
	}
	ret := make(map[string][]string)
	for _, id := range d.Trie.PrefixMatch([]byte(str), 0) {
		key, err := d.Trie.Key(id)
		if err != nil {
			return nil, err
		}
		value, err := d.Trie.Value(id)
		if err != nil {
			return nil, err
		}
		ret[string(key)] = d.Values[value]
	}
	return ret, nil
}

// Get the values of str, like map
func (d *dict) Get(str string) ([]string, error) {
	if d.Trie == nil {
		return nil, fmt.Errorf("trie is nil")
	}
	id, err := d.Trie.Get([]byte(str))
	if err != nil {
		return nil, err
	}
	value, err := d.Trie.Value(id)
	if err != nil {
		return nil, err
	}
	return d.Values[value], nil
}

// BuildFromFile builds the da dict from fileName
func BuildFromFile(fileName string) (*dict, error) {
	file, err := os.Open(fileName)
	if err != nil {
		return nil, err
	}
	defer file.Close()
	return Build(file)
}

// Build da dict from io.Reader
func Build(in io.Reader) (*dict, error) {
	trie := cedar.New()
	var values [][]string
	br := bufio.NewReader(in)
	for {
		line, err := br.ReadString('\n')
		if err == io.EOF {
			break
		}
		items := strings.Split(strings.TrimSpace(line), "\t")
		if len(items) < 2 {
			continue
		}
		err = trie.Insert([]byte(items[0]), len(values))
		if err != nil {
			return nil, err
		}

		if len(items) > 2 {
			values = append(values, items[1:])
		} else {
			values = append(values, strings.Fields(items[1]))
		}
	}
	return &dict{Trie: trie, Values: values}, nil
}
