package pool

import (
	"sync"
)

type (
	Result struct {
		Res interface{}
		Err error
	}
	WithReturnPool interface {
		Add(jobs ...func() Result) //添加任务
		Do(thread int)             //执行
		Next() (Result, bool)      //获取结果
	}
	withReturnPool struct {
		jobs       []func() Result //任务列表
		jobsCount  int
		jobChan    chan func() Result
		resultChan chan Result
		thread     int
		sync.Mutex
	}
)

//添加任务
func (p *withReturnPool) Add(jobs ...func() Result) {
	p.Lock()
	defer p.Unlock()
	if p.jobChan == nil {
		p.jobs = append(p.jobs, jobs...)
	}
}

//执行
func (p *withReturnPool) Do(thread int) {
	p.Lock()
	defer p.Unlock()
	p.jobsCount = len(p.jobs)
	p.thread = thread
	if p.thread > p.jobsCount || p.thread < 1 {
		p.thread = p.jobsCount
	}
	p.jobChan = make(chan func() Result, p.jobsCount)
	p.resultChan = make(chan Result, p.jobsCount)
	for _, v := range p.jobs {
		p.jobChan <- v
	}
	close(p.jobChan)
	p.jobs = nil
	//执行任务
	for i := 0; i < p.thread; i++ {
		go func() {
			for t := range p.jobChan {
				p.resultChan <- t()
			}
		}()
	}
}

//获取结果
func (p *withReturnPool) Next() (Result, bool) {
	p.Lock()
	defer p.Unlock()
	if p.jobsCount <= 0 {
		p.jobChan = nil
		return Result{}, false
	}
	p.jobsCount--
	return <-p.resultChan, true
}

//新建
func NewWithReturn(jobs ...func() Result) WithReturnPool {
	var p = new(withReturnPool)
	p.jobs = make([]func() Result, 0, len(jobs))
	for _, job := range jobs {
		if job != nil {
			p.jobs = append(p.jobs, job)
		}
	}
	return p
}
