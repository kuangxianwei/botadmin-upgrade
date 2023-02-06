try {
    var searchBtn = document.getElementById('searchBtn');
    searchBtn.onclick = function(){
        var value = document.getElementById('search').value;
        if (!value) {
            alert('请输入关键字');return;
        }
        window.location.href="/search.html?keywords="+value;
    }
    
} catch (error) {
    
}


try {
    var searchBtn_m = document.getElementById('searchBtn_m');
    if (searchBtn_m) {
        searchBtn_m.onclick = function(){
            var value = document.getElementById('search_m').value;
            if (!value) {
                alert('请输入关键字');return;
            }
            window.location.href="/search.html?keywords="+value;
        }
    }
} catch (error) {
    
}
try {
    var tuijiantag_1 = document.getElementById('tuijiantag_1');
    var html = tuijiantag_1.innerHTML
    if (html.length < 50) {
        var wiki_types = document.getElementById('tuijiantag_0').style.display='none';
        document.getElementsByClassName('wiki-share')[0].style.display='none';
    }
} catch (error) {
    
}

try {
    var tuijiantag_3 = document.getElementById('tuijiantag_3');
    var html = tuijiantag_3.innerHTML
    if (html.length < 50) {
        var wiki_types = document.getElementById('tuijiantag_2').style.display='none';
    }
} catch (error) {
    
}
try {
    var tuijiantag_3 = document.getElementsByClassName('ivf-video-l')[0];
    var html = tuijiantag_3.innerHTML
    if (html.length < 50) {
        var wiki_types = document.getElementsByClassName('ivf-video')[0].style.display='none';
    }
} catch (error) {
    
}

try {
    var tuijiantag_3 = document.getElementById('keyword_');
    if (!tuijiantag_3.innerHTML) {
        document.getElementsByClassName('wiki-content-m')[0].style.display='none';
        document.getElementsByClassName('crumbs')[0].style.display='none';
        document.getElementsByClassName('pc-footer')[0].style.display='none';
        document.getElementsByClassName('search-total-wrap')[0].style.display='none';
        
    }
} catch (error) {
    
}



