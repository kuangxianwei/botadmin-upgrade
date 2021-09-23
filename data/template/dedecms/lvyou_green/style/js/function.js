function showtable(tbflag,tbnum,curtable,tdyes,tdno)
{
	for(i=1; i<=tbnum;i++)
	{
		if(i==curtable)
		{
			document.getElementById("td_"+tbflag+"_"+i).className=tdyes;
			document.getElementById("div_"+tbflag+"_"+i).style.display='';
		}
		else
		{
			document.getElementById("td_"+tbflag+"_"+i).className=tdno;
			document.getElementById("div_"+tbflag+"_"+i).style.display='none';
		}
	}
}

function showdiv(tbflag,tbnum,curtable)
{
	for(i=1; i<=tbnum;i++)
	{
		switch (curtable)
	   {
		   case 1:
			document.getElementById("li_"+tbflag+"_1").className="lybd02_1";
			document.getElementById("li_"+tbflag+"_2").className="lybd01_2";
			document.getElementById("li_"+tbflag+"_3").className="lybd01_3";
			document.getElementById("li_"+tbflag+"_4").className="lybd01_4";
			document.getElementById("li_"+tbflag+"_5").className="lybd01_5";
			document.getElementById("li_"+tbflag+"_6").className="lybd01_6";
			break
		   case 2:
			document.getElementById("li_"+tbflag+"_1").className="lybd01_1";
			document.getElementById("li_"+tbflag+"_2").className="lybd02_2";
			document.getElementById("li_"+tbflag+"_3").className="lybd01_3";
			document.getElementById("li_"+tbflag+"_4").className="lybd01_4";
			document.getElementById("li_"+tbflag+"_5").className="lybd01_5";
			document.getElementById("li_"+tbflag+"_6").className="lybd01_6";
			 break
		   case 3:
		    document.getElementById("li_"+tbflag+"_1").className="lybd01_1";
			document.getElementById("li_"+tbflag+"_2").className="lybd01_2";
			document.getElementById("li_"+tbflag+"_3").className="lybd02_3";
			document.getElementById("li_"+tbflag+"_4").className="lybd01_4";
			document.getElementById("li_"+tbflag+"_5").className="lybd01_5";
			document.getElementById("li_"+tbflag+"_6").className="lybd01_6";
			 break
		   case 4:
			document.getElementById("li_"+tbflag+"_1").className="lybd01_1";
			document.getElementById("li_"+tbflag+"_2").className="lybd01_2";
			document.getElementById("li_"+tbflag+"_3").className="lybd01_3";
			document.getElementById("li_"+tbflag+"_4").className="lybd02_4";
			document.getElementById("li_"+tbflag+"_5").className="lybd01_5";
			document.getElementById("li_"+tbflag+"_6").className="lybd01_6";
			break
		   case 5:
			document.getElementById("li_"+tbflag+"_1").className="lybd01_1";
			document.getElementById("li_"+tbflag+"_2").className="lybd01_2";
			document.getElementById("li_"+tbflag+"_3").className="lybd01_3";
			document.getElementById("li_"+tbflag+"_4").className="lybd01_4";
			document.getElementById("li_"+tbflag+"_5").className="lybd02_5";
			document.getElementById("li_"+tbflag+"_6").className="lybd01_6";
			break
		   case 6:
			document.getElementById("li_"+tbflag+"_1").className="lybd01_1";
			document.getElementById("li_"+tbflag+"_2").className="lybd01_2";
			document.getElementById("li_"+tbflag+"_3").className="lybd01_3";
			document.getElementById("li_"+tbflag+"_4").className="lybd01_4";
			document.getElementById("li_"+tbflag+"_5").className="lybd01_5";
			document.getElementById("li_"+tbflag+"_6").className="lybd02_6";
			 break
			}

		if(i==curtable)
		{
			document.getElementById("div_"+tbflag+"_"+i).style.display='';
		}
		else
		{
			document.getElementById("div_"+tbflag+"_"+i).style.display='none';
		}
	}
}
