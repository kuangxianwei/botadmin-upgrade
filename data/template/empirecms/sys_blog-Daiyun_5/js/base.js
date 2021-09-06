$(document).ready(function() {
    //nav     
    var obj = null;
    var As = document.getElementById('starlist').getElementsByTagName('a');
    obj = As[0];
    for (i = 1; i < As.length; i++) {
        if (window.location.href.indexOf(As[i].href) >= 0) obj = As[i];
    }
    obj.id = 'selected';	
//////notice	
if(document.getElementById("jsfoot02")){
	var scrollup = new ScrollText("jsfoot02");
	scrollup.LineHeight = 22;        //单排文字滚动的高度
	scrollup.Amount = 1;            //注意:子模块(LineHeight)一定要能整除Amount.
	scrollup.Delay = 20;           //延时
	scrollup.Start();             //文字自动滚动
	scrollup.Direction = "up";   //默认设置为文字向上滚动
};

//////search
$('.search_ico').click(function () {
        $('.search_bar').toggleClass('search_open');
        if ($('#keyboard').val().length > 2) {
            $('#keyboard').val('');
            $('#searchform').submit();
        } else {
            return false;
        }
    });
	    //nav
    $("#mnavh").click(function() {
        $("#starlist").toggle();
        $("#mnavh").toggleClass("open");
    });

    $("#weixin").click(function() {
        $("#weixin_num").toggleClass("wxopen");
    });
  

  
     $(".mpnav").click(function(event) {
   $(this).children('.subopen').slideToggle();
   event.stopPropagation(); 
   });

  
  
	
});




//////ScrollText

function ScrollText(content, btnPrevious, btnNext, autoStart) {
  this.Delay = 10;
  this.LineHeight = 20;
  this.Amount = 1; //注意:LineHeight一定要能整除Amount.
  this.Direction = "up";
  this.Timeout = 1500;
  this.ScrollContent = this.$(content);
  this.ScrollContent.innerHTML += this.ScrollContent.innerHTML;
  //this.ScrollContent.scrollTop = 0;
  if (btnNext) {
    this.NextButton = this.$(btnNext);
    this.NextButton.onclick = this.GetFunction(this, "Next");
    this.NextButton.onmouseover = this.GetFunction(this, "Stop");
    this.NextButton.onmouseout = this.GetFunction(this, "Start");
  }
  if (btnPrevious) {
    this.PreviousButton = this.$(btnPrevious);
    this.PreviousButton.onclick = this.GetFunction(this, "Previous");
    this.PreviousButton.onmouseover = this.GetFunction(this, "Stop");
    this.PreviousButton.onmouseout = this.GetFunction(this, "Start");
  }
  this.ScrollContent.onmouseover = this.GetFunction(this, "Stop");
  this.ScrollContent.onmouseout = this.GetFunction(this, "Start");
  if (autoStart) {
    this.Start();
  }
}

ScrollText.prototype.$ = function(element) {
  return document.getElementById(element);
}

ScrollText.prototype.Previous = function() {
  clearTimeout(this.AutoScrollTimer);
  clearTimeout(this.ScrollTimer);
  this.Scroll("up");
}

ScrollText.prototype.Next = function() {
  clearTimeout(this.AutoScrollTimer);
  clearTimeout(this.ScrollTimer);
  this.Scroll("down");
}

ScrollText.prototype.Start = function() {
  clearTimeout(this.AutoScrollTimer);
  this.AutoScrollTimer = setTimeout(this.GetFunction(this, "AutoScroll"), this.Timeout);
}

ScrollText.prototype.Stop = function() {
  clearTimeout(this.ScrollTimer);
  clearTimeout(this.AutoScrollTimer);
}

ScrollText.prototype.AutoScroll = function() {
  if (this.Direction == "up") {
    if (parseInt(this.ScrollContent.scrollTop) >= parseInt(this.ScrollContent.scrollHeight) / 2) {
      this.ScrollContent.scrollTop = 0;
    }
    this.ScrollContent.scrollTop += this.Amount;
  } else {
    if (parseInt(this.ScrollContent.scrollTop) <= 0) {
      this.ScrollContent.scrollTop = parseInt(this.ScrollContent.scrollHeight) / 2;
    }
    this.ScrollContent.scrollTop -= this.Amount;
  }
  if (parseInt(this.ScrollContent.scrollTop) % this.LineHeight != 0) {
    this.ScrollTimer = setTimeout(this.GetFunction(this, "AutoScroll"), this.Delay);
  } else {
    this.AutoScrollTimer = setTimeout(this.GetFunction(this, "AutoScroll"), this.Timeout);
  }
}

ScrollText.prototype.Scroll = function(direction) {
  if (direction == "up") {
    if (this.ScrollContent.scrollTop == 0) {
      this.ScrollContent.scrollTop = parseInt(this.ScrollContent.scrollHeight) / 2;
    }
    this.ScrollContent.scrollTop -= this.Amount;
  } else {
    this.ScrollContent.scrollTop += this.Amount;
  }
  if (parseInt(this.ScrollContent.scrollTop) >= parseInt(this.ScrollContent.scrollHeight) / 2) {
    this.ScrollContent.scrollTop = 0;
  }
  if (parseInt(this.ScrollContent.scrollTop) % this.LineHeight != 0) {
    this.ScrollTimer = setTimeout(this.GetFunction(this, "Scroll", direction), this.Delay);
  }
}

ScrollText.prototype.GetFunction = function(variable, method, param) {
  return function() {
    variable[method](param);
  }
};


