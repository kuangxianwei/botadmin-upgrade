package pool

import (
	"botadmin/tools/utils"
	"fmt"
	"testing"
	"time"
)

func TestNew(t *testing.T) {
	//没有返回值的
	//新建任务列表 类型为 []Job
	var jobs []func()
	for i := 0; i < 10; i++ {
		n := i
		jobs = append(jobs, func() {
			if n > 5 {
				time.Sleep(1 * time.Second)
			}
		})
	}
	//传入任务列表 开启5个携程
	p := New(jobs...)
	//开始执行
	p.Do(5)
	//获取执行结果
	p.Wait()

	//具备返回结果的

	var jobs2 []func() Result
	for i := 0; i < 30; i++ {
		index := i
		jobs2 = append(jobs2, func() Result {
			time.Sleep(time.Duration(utils.Random(1, 3)) * time.Second)
			return Result{Res: index}
		})
	}
	p2 := NewWithReturn(jobs2...)
	p2.Do(20)
	r, ok := p2.Next()
	var results []int
	for ok {
		if i, y := r.Res.(int); y {
			results = append(results, i)
		}
		r, ok = p2.Next()
	}
	fmt.Printf("%#v\n", results)
	fmt.Println(len(results))
}
