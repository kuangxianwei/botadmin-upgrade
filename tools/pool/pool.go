package pool

import (
	"sync"
)

type (
	Pool interface {
		Add(jobs ...func()) //添加任务
		Do(thread int)      //执行
		Wait()              //等待完成
	}
	pool struct {
		jobs       []func() //任务列表
		jobsCount  int
		jobChan    chan func()
		resultChan chan bool
		thread     int
		sync.Mutex
	}
)

//添加任务
func (p *pool) Add(jobs ...func()) {
	p.Lock()
	defer p.Unlock()
	if p.jobChan == nil {
		p.jobs = append(p.jobs, jobs...)
	}
}

//执行
func (p *pool) Do(thread int) {
	p.Lock()
	defer p.Unlock()
	p.jobsCount = len(p.jobs)
	p.thread = thread
	if p.thread > p.jobsCount || p.thread < 1 {
		p.thread = p.jobsCount
	}
	p.jobChan = make(chan func(), p.jobsCount)
	p.resultChan = make(chan bool, p.jobsCount)
	for _, v := range p.jobs {
		p.jobChan <- v
	}
	close(p.jobChan)
	p.jobs = nil
	//执行任务
	for i := 0; i < p.thread; i++ {
		go func() {
			for t := range p.jobChan {
				t()
				p.resultChan <- true
			}
		}()
	}
}

//获取结果
func (p *pool) Wait() {
	p.Lock()
	defer p.Unlock()
	for p.jobsCount > 0 {
		<-p.resultChan
		p.jobsCount--
	}
}

//新建
func New(jobs ...func()) Pool {
	var p = new(pool)
	p.jobs = make([]func(), 0, len(jobs))
	for _, job := range jobs {
		if job != nil {
			p.jobs = append(p.jobs, job)
		}
	}
	return p
}
