// This file was generated by counterfeiter
package fakes

import (
	. "github.com/cloudfoundry/cli/cf/terminal"
	"sync"
)

type FakeTerminalOutputSwitch struct {
	DisableTerminalOutputStub        func(bool)
	disableTerminalOutputMutex       sync.RWMutex
	disableTerminalOutputArgsForCall []struct {
		arg1 bool
	}
}

func (fake *FakeTerminalOutputSwitch) DisableTerminalOutput(arg1 bool) {
	fake.disableTerminalOutputMutex.Lock()
	defer fake.disableTerminalOutputMutex.Unlock()
	fake.disableTerminalOutputArgsForCall = append(fake.disableTerminalOutputArgsForCall, struct {
		arg1 bool
	}{arg1})
	if fake.DisableTerminalOutputStub != nil {
		fake.DisableTerminalOutputStub(arg1)
	}
}

func (fake *FakeTerminalOutputSwitch) DisableTerminalOutputCallCount() int {
	fake.disableTerminalOutputMutex.RLock()
	defer fake.disableTerminalOutputMutex.RUnlock()
	return len(fake.disableTerminalOutputArgsForCall)
}

func (fake *FakeTerminalOutputSwitch) DisableTerminalOutputArgsForCall(i int) bool {
	fake.disableTerminalOutputMutex.RLock()
	defer fake.disableTerminalOutputMutex.RUnlock()
	return fake.disableTerminalOutputArgsForCall[i].arg1
}

var _ TerminalOutputSwitch = new(FakeTerminalOutputSwitch)
