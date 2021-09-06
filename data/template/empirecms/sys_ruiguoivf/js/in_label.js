function in_label(){
    var Bg=['#68b4be','#80b2a0','#3c8b95','#6eb9c3','#5cb0bc','#77bea0'];
    var oDiv = document.getElementById('in_label');
    var aA = oDiv.getElementsByTagName('a');
    var i = 0;
    for (i = 0; i < aA.length; i++) {
        aA[i].pause = 1;
        aA[i].time = null;
        aA[i].style.width=aA[i].offsetWidth+'px';
        aA[i].style.position='absolute';
        aA[i].style.left=Math.round(Math.random()*10)*10+'%';


        initialize(aA[i]);
        aA[i].onmouseover = function() {
            this.pause = 0;
        };
        aA[i].onmouseout = function() {
            this.pause = 1;
        };
    }
    setInterval(starmove,56);

    function starmove() {
        for (i = 0; i < aA.length; i++) {
            if (aA[i].pause) {
                domove(aA[i]);
            }
        }
    }
    function domove(obj) {
        if (obj.offsetLeft <= -obj.offsetWidth) {
            obj.style.left = oDiv.offsetWidth + "px";
            initialize(obj);
        } else {
            obj.style.left = obj.offsetLeft -obj.ispeed + "px";
        }
    }

    function initialize(obj) {
        var iLeft = parseInt(Math.random() * oDiv.offsetHeight);
        var scale = Math.random() * 1 + 1;
        var iTimer = parseInt(Math.random() * 1500);
        obj.pause = 0;
        obj.style.fontSize = Math.round(Math.random()*(17-13)+13)+ 'px';

        if ((iLeft - obj.offsetHeight) > 0) {
            obj.style.top = iLeft - obj.offsetHeight + "px";
        } else {
            obj.style.top = iLeft + "px";
        }

        obj.getElementsByTagName('i')[0].style.background=Bg[Math.round(Math.random()*6)];
        obj.getElementsByTagName('i')[0].style.opacity=(Math.round(Math.random()*(8-5)+5))/10;
        clearTimeout(obj.time);
        obj.time = setTimeout(function() {
            obj.pause = 1;
        }, iTimer);
        obj.ispeed = Math.ceil(Math.random() * 4) + 1;
    }

}

in_label();