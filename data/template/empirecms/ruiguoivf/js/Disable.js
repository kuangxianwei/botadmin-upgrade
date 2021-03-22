$(function(){

    //禁用浏览器 默认右键菜单
    document.oncontextmenu = new Function("return false;");

    // 禁用右键菜单、复制、选择
    $(document).bind("contextmenu copy selectstart", function() {
        return false;
    });

    // 禁用Ctrl+C和Ctrl+V（所有浏览器均支持）
    $(document).keydown(function(e) {
        if(e.ctrlKey && (e.keyCode == 65 || e.keyCode == 67)) {
            return false;
        }
    });
    //*js屏蔽F12
    document.onkeydown = document.onkeyup = document.onkeypress = function(event) {
        var e = event || window.event || arguments.callee.caller.arguments[0];

        if (e && e.keyCode == 123) {
            mAlert();
            e.returnValue = false;
            return (false);
        }
    }
    function mAlert() {
        alert("禁止操作控制台");
    }

    //css
    $("body").css({
        "-moz-user-select":"none",
        "-webkit-user-select":"none",
        "-ms-user-select":"none",
        "-khtml-user-select":"none",
        "-o-user-select":"none",
        "user-select":"none"
    });

});
