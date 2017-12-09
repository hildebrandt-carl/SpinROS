mtype = { a0, a1, p1, s1, d, err }

chan p2s = [0] of { mtype }	
chan n2m = [0] of { mtype }	
chan out = [0] of { mtype }	

proctype m()
{
	goto Q1 ;
Q1:	if
	:: n2m?p1  -> goto Q2 ;
	:: n2m?s1 -> goto Q3 ;
	:: n2m?err -> goto Q4 ;
	fi
Q2:	n2m!a0  -> goto Q1 ;
Q3:	n2m!a1  -> goto Q2 ;
Q4:	out!err ;
} 

proctype p()
{
	goto Q1 ;
Q1:	n2m!p1 ;
Q2:	n2m?a0 -> goto Q3 ;
Q3:	if 
	:: p2s!d  -> goto Q3 ;
	:: p2s?err -> goto Q4 ;
	fi
Q4:	out!err
}

proctype s()
{
	goto Q1 ;
Q1:	n2m!s1 ;
Q2:	n2m?a1 -> goto Q3 ;
Q3:	if
	:: p2s?d  -> goto Q3 ;
	:: p2s?err  -> goto Q4 ;
	fi
Q4:	out!err
}

init
{
	run m() ;
	run p() ;
	run s() ;

	assert(out != err) ;
	assert(n2m != err) ;
	assert(p2s != err) ;
}

//Could put in a loop at the end of the automata to check for any dataloss?
