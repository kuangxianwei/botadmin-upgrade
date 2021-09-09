//reflush authcode
function reloadcode() {
    newcode = $('#showcode').prop("src") + '?' + Math.random();
    $('#showcode').prop("src", newcode);
}


function register_check() {

    if($('#regname').val() == '' || $('#regpass').val() == '' || $('#repass').val() == '' || $('#email').val() == '' ) {
        alert('每项都必须填写');
        return false;
    };

    if($('#regpass').val() !== $('#repass').val()){
        alert('两次输入的密码不一致');
        return false;
    }
    return true;

}
//addbookcase
function addbookcase(aid,name,cid=null,cname=null){
	if($.cookie('ss_userid') && $.cookie('PHPSESSID') != -1) {
        rico_data = {
            articleid: aid,
            articlename: name,
            chapterid: cid,
            chaptername: cname
        }
        $.ajax({
            type: "post",
            url: "/addbookcase/",
            data: rico_data,
            success: function(data){
                alert(data);
            }
        })       

	}else{
		if (window.confirm("\n永久书架需要登录才能使用，转到登录页面吗？")) {
			window.location.href = "/login/";
		}else{
			return;
		}
	}
}

//delbookcase
function delbookcase(aid){
    if (window.confirm("\n确定要删除吗？")) {
        if($.cookie('ss_userid') && $.cookie('PHPSESSID') != -1) {
            rico_data = {
                articleid: aid,
            },
    
            $.ajax({
                type: "post",
                url: "/delbookcase/",
                data: rico_data,
                success: function(data){
                    alert(data);
                    window.location.reload();
                }
            })       
        }
    }else{
        return;
    }
}