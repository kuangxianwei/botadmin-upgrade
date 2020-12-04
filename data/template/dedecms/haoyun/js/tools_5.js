var pagec = function(){
    var sex ={
            num : 0,
            lastnum : 19,
            cannext : false,
            sexs : ["男孩","女孩"],
            sexnum : [],
            sexnums : 0,
            sexnump : 0,
            sexhtml : ""
        },
        $checksex = $("#checksex"),
        $back = $("#back"),
        $next = $("#next"),
        $nownum = $("#nownum"),
        $results = $("#results"),
        sexshow = function(i){
            if(i==0){
                $back.hide()
            }
            else if(i==1){
                $back.show()
            }
            else if(i==sex.lastnum-1){
                $next.val("下一题")
            }
            else if(i==sex.lastnum){
                $next.val("提 交")
            }
            $nownum.html(i+1)
            $checksex.find("li").eq(i).show()
        },
        sexcheckn = function(){
            sexcheck(sex.num)
            if(sex.cannext){
                if(sex.num==sex.lastnum){
                    sex.sexnums=0
                    for(var i=0;i<sex.sexnum.length;i++){
                        sex.sexnums += parseFloat(sex.sexnum[i])
                    }
                    sex.sexnump = parseInt(sex.sexnums/20*1000)/10
                    if(sex.sexnump>=50){
                        sex.sexhtml = sex.sexs[0]+sex.sexnump+"%"
                    }
                    else{
                        sex.sexhtml = sex.sexs[1]+(100-sex.sexnump)+"%"
                    }
                    $results.html(sex.sexhtml)
                }
                else{
                    $checksex.find("li").eq(sex.num).hide()
                    sex.num++
                    sexshow(sex.num)
                }
                sex.cannext= false

            }
            else{
                alert("请选择")
            }
        },
        sexcheckb = function(){
            $checksex.find("li").eq(sex.num).hide()
            sex.num = sex.num-1
            sexshow(sex.num)
        },
        sexcheck = function(i){
            $checksex.find("li").eq(i).find("input").each(function(){
                if(this.checked){
                    sex.sexnum[i] = $(this).val()
                    sex.cannext = true
                    return
                }
            })
        },
        checksex =function(){
            sexshow(sex.num)
            $next.click(function(){
                sexcheckn()
            })
            $back.click(function(){
                sexcheckb()
            })
        }
    checksex()
}()
