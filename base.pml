mtype = { none, puback, suback, rej, pub, sub, err }

int mas_table_size = 5
int mas_table_number = 0
byte mas_table[mas_table_size] = {'x', 'x', 'a', 'x', 'x'}

chan n2m = [0] of {mtype, byte}
chan m2n = [0] of {mtype, byte}
chan p2s = [0] of {byte}

proctype master(chan in, out)
{
	byte namespace ;
	do
	:: in?pub, namespace ->	
		printf("Pub requesting registration\n");
		atomic
		{
			mas_table[mas_table_number] = namespace ;
			printf("New byte %c received and stored in position %d\n",namespace,mas_table_number) ;
			mas_table_number++ ;
			out!puback,namespace ;
		}
	:: in?sub, namespace->
			printf("Sub requesting registration\n");
			if
			:: mas_table[0] == namespace -> out!suback,namespace ;
			:: mas_table[1] == namespace -> out!suback,namespace ;
			:: mas_table[2] == namespace -> out!suback,namespace ;
			:: mas_table[3] == namespace -> out!suback,namespace ;
			:: mas_table[4] == namespace -> out!suback,namespace ;
			:: skip
			fi
	od
}

proctype publisher(chan in, out, publish)
{
	byte namespace ;
	bit registered = 0;
	do
	:: 	if
		:: registered == 0 ->
				atomic
				{
					printf("Requesting Publisher Registration\n") ;
					out!pub,'a' ;
					in?puback, namespace -> registered = 1 ;
				}
		:: registered == 1 ->
			printf("Publisher Registered\n") ;
			do
			:: p2s!'f' -> printf("Publishing f\n") ;
			:: p2s!'g' -> printf("Publishing g\n") ; 
			:: p2s!'h' -> printf("Publishing h\n") ;
			od
		fi
	od
}

proctype subscriber(chan in, out, publish)
{
	byte namespace, inputMessage ;
	bit registered = 0;
	do
	:: 	if
		:: registered == 0 ->
				atomic
				{
					printf("Requesting Subscriber Registration\n") ;
					out!sub,'a' ;
					in?suback, namespace -> registered = 1 ;
				}
		:: registered == 1 ->
			printf("Subscriber Registered\n") ;
			do
			:: p2s?inputMessage -> printf("Subscriber Recieved %c\n",inputMessage) ;
			od
		fi
	od
}

init 
{
	atomic
	{
		run master(n2m,m2n) ;
		run publisher(m2n,n2m,p2s) ;
		run subscriber(m2n,n2m,p2s) ;
	}
}

