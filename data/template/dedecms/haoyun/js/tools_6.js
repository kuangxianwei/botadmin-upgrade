function checkWeight(){
	 if(document.getElementById("val1").value == ""){ alert('请输入双顶径值');return; }
	 if(document.getElementById("val2").value == ""){ alert('请输入腹围值');return; }
	 if(document.getElementById("val3").value == ""){ alert('请输入股骨长值');return; }
	 var val1 = document.getElementById("val1").value;
	 var val2 = document.getElementById("val2").value;
	 var val3 = document.getElementById("val3").value;
	 var wei = 1.07*val1*val1*val1 + 0.3*val2*val2*val3;
	 document.getElementById("results").innerHTML = ForDight(wei/500,2)+"斤,即"+0.5*ForDight(wei/500,2)+"千克(Kg)";
	 return false;
}

function  ForDight(Dight,How) {
   Dight  =  Math.round(Dight*Math.pow(10,How))/Math.pow(10,How);
   return  Dight;
}

