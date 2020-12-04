function ckvaild(inp){var flag=$(inp).attr("vname");$.ajax({type:"GET",url:"ajax.php?r="+Math.random()+'&vaild='+inp.value+"&flag="+flag,dataType:"text",async:false,error:function(err){alert(err);},success:function(msg){r=msg;}});if(r==0){if(flag=='hvalid')
$("#hr_verify").attr("src",'valid.php?cookieName=hvalid&rand='+Math.random()*5);else
$("#verify").attr("src",'valid.php?rand='+Math.random()*5);return false;}else{return true;}}
