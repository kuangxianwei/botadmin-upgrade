/*********箭头控制滚动方向、加速及鼠标拖动***************/
/*********箭头控制滚动方向、加速及鼠标拖动***************/
var MarqueeDiv2Control=new Marquee("MarqueeDiv");		//箭头控制滚动方向、加速及鼠标拖动实例
MarqueeDiv2Control.Direction="left";
MarqueeDiv2Control.Step=1;
MarqueeDiv2Control.Width=692;
MarqueeDiv2Control.Height=152;
MarqueeDiv2Control.Timer=20;
MarqueeDiv2Control.ScrollStep=1;				//若为-1则禁止鼠标控制实例
MarqueeDiv2Control.Start();
MarqueeDiv2Control.BakStep=MarqueeDiv2Control.Step;
$$("LeftButton").onmouseover=function(){MarqueeDiv2Control.Direction=2};
$$("LeftButton").onmouseout=$$("LeftButton").onmouseup=function(){MarqueeDiv2Control.Step=MarqueeDiv2Control.BakStep};
$$("LeftButton").onmousedown=$$("RightButton").onmousedown=function(){MarqueeDiv2Control.Step=MarqueeDiv2Control.BakStep+3};
$$("RightButton").onmouseover=function(){MarqueeDiv2Control.Direction=3};
$$("RightButton").onmouseout=$$("RightButton").onmouseup=function(){MarqueeDiv2Control.Step=MarqueeDiv2Control.BakStep};
function $$(id){return document.getElementById(id)};
