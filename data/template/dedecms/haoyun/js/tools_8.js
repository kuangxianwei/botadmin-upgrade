function getWei( ){
	if( !document.getElementById("val1").value ){alert("请输入身高");document.getElementById("val1").focus();return; }
	if( !document.getElementById("val2").value ){alert("请输入孕前体重");document.getElementById("val2").focus();return; }	
	var setR;
	var Hig = parseFloat( document.getElementById("val1").value ) / 100;
	var Wei = parseFloat( document.getElementById("val2").value );
	var bmi = Wei / (Hig * Hig )
	bmi = bmi.toFixed(1)
	if( bmi < 19.8 ) setR = (Wei+12.5)+" - "+(Wei+18)
	else if ( bmi >= 19.8 && bmi <= 26 ) setR = (Wei+11.5)+" - "+(Wei+16)
	else if ( bmi > 26 && bmi <= 30 ) setR = (Wei+7)+" - "+(Wei+11.5)
	else setR = "大于6"
	document.getElementById("results").innerHTML = setR +"公斤(南方IVF)";
	return false
}
