// Types of messages sent
mtype = { none, puback, suback, rej, pub, sub, err }

// Configurable master table size
int mas_table_size = 5
int mas_table_number = 0
byte mas_table[mas_table_size] = {'x', 'x', 'x', 'x', 'x'}

// Communication channels between the nodes
chan n2m = [0] of {mtype, byte}
chan m2n = [0] of {mtype, byte}
chan p2s = [0] of {byte}

proctype master(chan in, out)
{
	byte namespace ;
	do
	// If the master receives a publisher request
	:: in?pub, namespace ->	
		printf("Pub requesting registration\n");
		atomic
		{
			// Add it to the table and accept
			mas_table[mas_table_number] = namespace ;
			printf("New byte %c received and stored in position %d\n",namespace,mas_table_number) ;
			mas_table_number++ ;
			out!puback,namespace ;
		}
	// If the master receives a subscriber request
	:: in?sub, namespace->
			printf("Sub requesting registration\n");
			if
			// Find it in the table and reply back
			:: mas_table[0] == namespace -> out!suback,namespace ;
			:: mas_table[1] == namespace -> out!suback,namespace ;
			:: mas_table[2] == namespace -> out!suback,namespace ;
			:: mas_table[3] == namespace -> out!suback,namespace ;
			:: mas_table[4] == namespace -> out!suback,namespace ;
			:: skip
			fi
	od
}

proctype publisher(chan in, out, publish, topic)
{
	byte namespace ;
	bit registered = 0;
	do
	:: 	if
		// If the node has not registered with the master
		:: registered == 0 ->
				atomic
				{
					// Register
					printf("Requesting Publisher Registration\n") ;
					out!pub,topic ;
					in?puback, namespace -> registered = 1 ;
				}
		// If the node has registered with the master
		:: registered == 1 ->
			printf("Publisher Registered\n") ;
			do
			// Start sending data
			:: p2s!'f' -> printf("Publishing f\n") ;
			:: p2s!'g' -> printf("Publishing g\n") ; 
			:: p2s!'h' -> printf("Publishing h\n") ;
			od
		fi
	od
}

proctype subscriber(chan in, out, publish, topic)
{
	byte namespace, inputMessage ;
	bit registered = 0;
	do
	:: 	if
		// If the subscriber has not registered
		:: registered == 0 ->
				atomic
				{
					// Register
					printf("Requesting Subscriber Registration\n") ;
					out!sub,topic ;
					in?suback, namespace -> registered = 1 ;
				}
		// If the subscriber has registered
		:: registered == 1 ->
			printf("Subscriber Registered\n") ;
			do
			// Listen for input and then print it
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
		run publisher(m2n,n2m,p2s,'a') ;
		run publisher(m2n,n2m,p2s,'a') ;
		run publisher(m2n,n2m,p2s,'a') ;
		run subscriber(m2n,n2m,p2s,'a') ;
	}
}

