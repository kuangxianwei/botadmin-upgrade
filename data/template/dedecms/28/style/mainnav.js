/*第一种形式 第二种形式 更换显示样式*/
function setTab(name,cursel,n){
for(i=1;i<=n;i++){
var menu=document.getElementById(name+i);
var con=document.getElementById("con_"+name+"_"+i);
menu.className=i==cursel?"a1":"";
con.style.display=i==cursel?"block":"none";
}
}
function Nav(){
		
		for(i=0; i<Nav_m.length; i++)
		{
			
			if(Nav_u==Nav_m[i])
			{
				document.getElementById(Nav_id[i]).className = "a1";
				document.getElementById("con_one_"+[i+1]).style.display = "block";
				//return;
				return Nav;
				
				return null;
				//break;
			}
			
			
		}
		
	}
