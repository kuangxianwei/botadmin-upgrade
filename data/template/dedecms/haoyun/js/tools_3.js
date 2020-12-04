function checkBlood(){
	var result;
	var b1=document.getElementById("blood1").value;
	var b2=document.getElementById("blood2").value;
	if(b1=='A' && b2=='B') result='您的孩子的血型可能为 A 型、B 型、AB 型、O 型' ;
	if(b1=='B' && b2=='A') result='您的孩子的血型可能为 A 型、B 型、AB 型、O 型' ;
	if(b1=='A' && b2=='A') result='您的孩子的血型可能为 A 型或 O 型，不可能为 B 型 和 AB 型' ;
	if(b1=='A' && b2=='O') result='您的孩子的血型可能为 A 型或 O 型，不可能为 B 型 和 AB 型' ;
	if(b1=='O' && b2=='A') result='您的孩子的血型可能为 A 型或 O 型，不可能为 B 型 和 AB 型' ;
	if(b1=='A' && b2=='AB') result='您的孩子的血型可能为  A 型 、B型 及 AB型之一，不可能为 O 型' ;
	if(b1=='AB' && b2=='A') result='您的孩子的血型可能为  A 型 、B型 及 AB型之一，不可能为 O 型' ;
	if(b1=='B' && b2=='B') result='您的孩子的血型可能为 B 型或 O 型，不可能为 A 型 和 AB 型' ;
	if(b1=='B' && b2=='O') result='您的孩子的血型可能为 B 型或 O 型，不可能为 A 型 和 AB 型' ;
	if(b1=='O' && b2=='B') result='您的孩子的血型可能为 B 型或 O 型，不可能为 A 型 和 AB 型' ;
	if(b1=='B' && b2=='AB') result='您的孩子的血型可能为  A 型 、B型 及 AB型之一，不可能为 O 型' ;
	if(b1=='AB' && b2=='B') result='您的孩子的血型可能为  A 型 、B型 及 AB型之一，不可能为 O 型' ;
	if(b1=='O' && b2=='O') result='您的孩子的血型可能为 O 型，不可能为 A 型、B 型和 AB 型' ;
	if(b1=='O' && b2=='AB') result='您的孩子的血型可能为 A 型或 B 型，不可能为 O 型 和 AB 型' ;
	if(b1=='AB' && b2=='O') result='您的孩子的血型可能为 A 型或 B 型，不可能为 O 型 和 AB 型' ;
	if(b1=='AB' && b2=='AB') result='您的孩子的血型可能为  A 型 、B型 及 AB型之一，不可能为 O 型' ;
	if(result.length>0) document.getElementById("results").innerHTML=result ;
}
