package fileutils

import (
	"fmt"
	"io/ioutil"
	"os"
)

func TempDir(namePrefix string, cb func(tmpDir string, err error)) {
	tmpDir, err := ioutil.TempDir("", namePrefix)

	fmt.Println("Tmp Dir:", tmpDir)
	// defer func() {
	// 	os.RemoveAll(tmpDir)
	// }()

	cb(tmpDir, err)
}

func TempFile(namePrefix string, cb func(tmpFile *os.File, err error)) {
	tmpFile, err := ioutil.TempFile("", namePrefix)

	fmt.Println("Tmp File:", tmpFile.Name())
	// defer func() {
	// 	tmpFile.Close()
	// 	os.Remove(tmpFile.Name())
	// }()

	cb(tmpFile, err)
}
