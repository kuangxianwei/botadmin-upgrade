package utils

import (
	"bytes"
	"context"
	"errors"
	"os/exec"
	"strings"
	"time"
)

type Std struct {
	Out      string
	OutBytes []byte
	Err      error
	In       string
	Code     int
	Pid      int
}

// 执行外部命令
func Execute(timeout time.Duration, dir, name string, args ...string) *Std {
	std := new(Std)
	var cmd *exec.Cmd
	if timeout > 0 {
		ctxt, cancel := context.WithTimeout(context.Background(), timeout)
		defer cancel()
		if ctxt == nil {
			std.Err = errors.New("nil Context")
			std.Code = -1
			return std
		}
		cmd = exec.CommandContext(ctxt, name, args...)
	} else {
		cmd = exec.Command(name, args...)
	}
	cmd.Dir = dir
	var stdout, stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr
	if err := cmd.Run(); err != nil {
		std.Code = -1
		std.Err = errors.New(stderr.String())
	} else {
		std.Out = strings.TrimSpace(stdout.String())
		std.OutBytes = bytes.TrimSpace(stdout.Bytes())
	}
	if cmd.ProcessState != nil {
		std.Code = cmd.ProcessState.ExitCode()
	}
	if cmd.Process != nil {
		std.Pid = cmd.Process.Pid
	}
	if std.Code != 0 {
		std.Err = errors.New(stderr.String())
	}
	return std
}

// 进入到指定工作目录后执行shell命令
func CommandToDir(dir, name string, args ...string) *Std {
	return Execute(0, dir, name, args...)
}

// 执行shell命令
func Command(name string, args ...string) *Std {
	return Execute(0, "", name, args...)
}
