try {
    function GetScondDomain(){
        var url = window.location.href;
        if (url != "" || url != undefined || url != null){
            var FirstUrl = url.match(/([\w-]+\.(?:[a-z]{1,4}\.cn|cn|com|net|cc|info|org|top|vip|xyz)\b.*?$)/ig);
            if (FirstUrl != "" || FirstUrl != undefined || FirstUrl != null){
                return "http://m."+FirstUrl;
            }
        }
    }
    function UaRedirect(){
        var fromapp = window.location.hash;
        if (!fromapp.match("fromapp")){
            var ScondUrl = GetScondDomain();
            if (ScondUrl){
                if ((navigator.userAgent.match(/(iPhone|iPod|Android|ios)/i))) {
                    location.replace(ScondUrl);
                }
            }
        }
    }
    UaRedirect();
}catch(err){}