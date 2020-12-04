function getHei( ){
	 fHeig = parseFloat( $("#fhei").val() ) || 0;
	 mHeig = parseFloat( $("#mhei").val() ) || 0;
	 
	 cHeig = ( $("#sex").val()==0) ? ( fHeig + mHeig ) * 1.08 / 2 : ( fHeig*0.923 + mHeig ) / 2;
	 $("#heig").html(cHeig.toFixed(1) + " 厘米（cm）");
	 return false
}

function setKeyup(obj){
	if( !obj.value ) return false;
	re = /^[\d]+$/
	if( !re.test( obj.value ) ){
		alert("请输入阿拉伯数字");
		obj.value = "";
	}
}
