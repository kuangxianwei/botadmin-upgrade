package utils

import (
	"log"
	"os"
	"path/filepath"
)

var (
	TmpDir = os.TempDir()
	AppDir string
)

func init() {
	var err error
	appFile, _ := filepath.Abs(os.Args[0])
	if AppDir, err = filepath.Abs(filepath.Dir(appFile)); err != nil {
		log.Fatalln(err)
	}
	if err := os.Chdir(AppDir); err != nil {
		log.Fatalln(err)
	}
}
