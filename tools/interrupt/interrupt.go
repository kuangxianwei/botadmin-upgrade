package interrupt

import (
	"log"
	"os"
	"os/signal"
	"sync"
	"syscall"
	"time"
)

var (
	TimeOut   time.Duration = 20
	Interrupt               = new(interrupt)
)

func Register(cb func()) int {
	return Interrupt.Register(cb)
}

type interrupt struct {
	sync.Mutex
	sync.Once
	onInterrupt []func()
}

// 注册任务
func (i *interrupt) Register(cb func()) int {
	if cb != nil {
		i.listenOnce()
		i.Lock()
		defer i.Unlock()
		i.onInterrupt = append(i.onInterrupt, cb)
		return len(i.onInterrupt) - 1
	}
	return 0
}

// 移除
func (i *interrupt) Remove(entryId int) bool {
	if entryId >= len(i.onInterrupt) {
		return false
	}
	i.Lock()
	defer i.Unlock()
	i.onInterrupt = append(i.onInterrupt[:entryId], i.onInterrupt[entryId+1:]...)
	return false
}

// 执行指定的
func (i *interrupt) Execute(entryId int) bool {
	if entryId >= len(i.onInterrupt) {
		return false
	}
	defer func() {
		if e := recover(); e != nil {
			log.Println(e)
		}
	}()
	i.onInterrupt[entryId]()
	return true
}

// 执行全部
func (i *interrupt) ExecuteAll() {
	i.Lock()
	for _, f := range i.onInterrupt {
		func() {
			defer func() {
				if e := recover(); e != nil {
					log.Println(e)
				}
			}()
			f()
		}()
	}
	i.onInterrupt = i.onInterrupt[0:0]
	i.Unlock()
}

// 监听 退出
func (i *interrupt) listenOnce() {
	i.Once.Do(func() {
		c := make(chan int, 1)
		go func() {
			c <- 1
			ch := make(chan os.Signal, 1)
			signal.Notify(ch,
				// kill -SIGINT XXXX or Ctrl+c
				os.Interrupt,
				syscall.SIGINT, // register that too, it should be ok
				// os.Kill  is equivalent with the syscall.SIGKILL
				// os.Kill,
				// syscall.SIGKILL, // register that too, it should be ok
				// kill -SIGTERM XXXX
				syscall.SIGTERM,
			)
			<-ch
			c := make(chan bool, 1)
			go func() {
				i.ExecuteAll()
				c <- true
			}()
			for {
				select {
				case <-c:
					log.Println("成功处理善后")
					os.Exit(0)
				case <-time.After(TimeOut * time.Second):
					log.Println("善后处理超时了")
					os.Exit(1)
				}
			}
		}()
		<-c
	})
}
