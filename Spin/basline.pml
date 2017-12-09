// Types of messages sent
mtype = { none, puback, suback, rej, pub, sub, err }

// Configurable master table size
int mas_table_size = 5
int mas_table_number = 0
byte mas_table[mas_table_size] = {'x', 'x', 'x', 'x', 'x'}

//Checks the number of message sent
int mgs_sent = 0;

// Communication channels between the nodes
chan n2m = [0] of {mtype, byte}
chan m2n = [0] of {mtype, byte}
chan p2s = [0] of {byte}

proctype master(chan in, out)
{
		byte namespace ;
start:	do
		// If the master receives a publisher request
		:: in?pub, namespace ->	
			printf("MASTER: Pub requesting registration\n");
			atomic
			{
				// Add it to the table and accept
				assert(mas_table_number < 5) ;
				mas_table[mas_table_number] = namespace ;
				printf("MASTER: New byte %c received and stored in position %d\n",namespace,mas_table_number) ;
				mas_table_number++ ;
				out!puback,namespace ;
			}
		// If the master receives a subscriber request
		:: in?sub, namespace->
				printf("MASTER: Sub requesting registration\n");
				if
				// Find it in the table and reply back
				:: mas_table[0] == namespace -> out!suback,namespace ;
				:: mas_table[1] == namespace -> out!suback,namespace ;
				:: mas_table[2] == namespace -> out!suback,namespace ;
				:: mas_table[3] == namespace -> out!suback,namespace ;
				:: mas_table[4] == namespace -> out!suback,namespace ;
				:: skip ;
				fi
		:: timeout -> goto start ;
		od
}

proctype publisher(chan in, out, publish; byte topic, message)
{
		byte namespace ;
		bit registered = 0;
start:	do
		:: 	if
			// If the node has not registered with the master
			:: registered == 0 ->
				// Register
				printf("PUBLISHER: Requesting Publisher Registration\n") ;
				do
				:: out!pub,topic ;
				:: in?puback, namespace -> 
					atomic
					{
						registered = 1 ;
						goto start ;
					}
				od

			// If the node has registered with the master
			:: registered == 1 ->
				printf("PUBLISHER: Publisher Registered\n") ;
				do
				// Start sending data
				:: p2s!message -> printf("PUBLISHER: Publishing %c\n", message) ;
				od
			fi
		od
}

proctype subscriber(chan in, out, publish; byte topic)
{
		byte namespace, inputMessage ;
		bit registered = 0;
start:	do
		:: 	if
			// If the subscriber has not registered
			:: registered == 0 ->
				printf("SUBSCRIBER: Requesting Subscriber Registration\n") ;
				do
				:: out!sub,topic ;
				:: in?suback, namespace -> 
					atomic
					{
						registered = 1 ;
						goto start ;
					}
				od

			// If the subscriber has registered
			:: registered == 1 ->
				printf("SUBSCRIBER: Subscriber Registered\n") ;
				do
				// Listen for input and then print it
				:: p2s?inputMessage ->
					atomic
					{
						printf("SUBSCRIBER: Subscriber Recieved %c\n",inputMessage) ;
						mgs_sent++ ;
					}
				od
			fi
		od
}

init 
{
	atomic
	{
		run master(n2m,m2n) ;
		run publisher(m2n,n2m,p2s,'a','1') ;
		run subscriber(m2n,n2m,p2s,'a') ;
	}

	do
	:: mgs_sent == 10 ->
		break ; 
	od

	// If it reaches here it reaches a valid end state
	printf("Ended safely")
	
}

