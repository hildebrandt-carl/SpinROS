// Types of messages sent
mtype = { none, puback, suback, rej, pub, sub, err } ;

// The number of publishers
int tot_pubs = 3 ;
int tot_message = 100000

// Configurable master table size
int mas_table_size = 5 ;
int mas_table_number = 0 ;
byte mas_table[mas_table_size] = {'x', 'x', 'x', 'x', 'x'} ;

// Checks the number of message sent
int msgs_sent = 0 ;

// Counting the number of inputs
int a_count = 0 ;
int b_count = 0 ;
int c_count = 0 ;

// Checks if nodes have closed
int active_pubs = 0 ;
int active_subs = 0 ;
int active_mast = 0 ;

// Communication channels between the nodes
chan n2m = [0] of {mtype, byte} ;
chan m2n = [0] of {mtype, byte} ;
chan p2s = [0] of {byte} ;

proctype master(chan in, out)
{
		byte namespace ;
		active_mast++ ;
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
		:: msgs_sent == tot_message -> break ;
		:: msgs_sent > tot_message -> break ;
		:: timeout -> goto start ;
		od
		printf("MASTER: Ended\n") ;
		active_mast-- ;
}

proctype publisher(chan in, out, publish; byte message)
{
		printf("PUBLISHER: HERER\n") ;
		int registered_pub = 0;
		active_pubs++ ;
		
start:	do
		:: 	if
			// If the node has not registered with the master
			:: registered_pub == 0 ->
				// Register
				printf("PUBLISHER: Requesting Publisher Registration\n") ;
				do
				:: out!pub,'a' ;
				:: in?puback, 'a' -> 
					atomic
					{
						registered_pub = 1 ;
						goto start ;
					}
				od

			// If the node has registered with the master
			:: registered_pub == 1 ->
				printf("PUBLISHER: Publisher Registered\n") ;
				do
				// Start sending data
				::	msgs_sent < (tot_message) -> 
					printf("PUBLISHER: Publishing %c\n", message) ;
					p2s!message ;
					msgs_sent++ ;
				:: msgs_sent == (tot_message) ->
						// Disconnect from master
						registered_pub = 2 ;
						break ;
				:: msgs_sent > (tot_message) ->
						// Disconnect from master
						registered_pub = 2 ;
						break ;
				od
			:: registered_pub == 2 -> break ;
			fi
		:: msgs_sent == (tot_message) -> break ;
		od
		printf("PUBLISHER: Ended\n") ;
		active_pubs-- ;
}

proctype subscriber(chan in, out, publish)
{
		printf("SUBSCRIBER: HERER\n") ;
		byte inputMessage ;
		int registered_sub = 0;
		active_subs++ ;
start:	do
		:: 	if
			// If the subscriber has not registered
			:: registered_sub == 0 ->
				printf("SUBSCRIBER: Requesting Subscriber Registration\n") ;
				do
				:: out!sub,'a' ;
				:: in?suback, 'a' -> 
					atomic
					{
						registered_sub = 1 ;
						goto start ;
					}
				od

			// If the subscriber has registered
			:: registered_sub == 1 ->
				printf("SUBSCRIBER: Subscriber Registered\n") ;
				do
				// Listen for input and then print it
				:: p2s?inputMessage ->
					atomic
					{
						printf("SUBSCRIBER: Subscriber Recieved %c\n",inputMessage) ;
						if
						:: inputMessage == 'a' -> a_count++ ;
						:: inputMessage == 'b' -> b_count++ ;
						:: inputMessage == 'c' -> c_count++ ;
						fi
					}
				:: (active_pubs == 0)&&(tot_message > 1) ->
						// Disconnect from master
						registered_sub = 2 ;
						break ;
				:: timeout -> goto start ;
				od
			:: registered_sub == 2 -> break ;
			fi
		:: msgs_sent == tot_message -> break ;
		od
		printf("SUBSCRIBER: Ended\n") ;
		active_subs-- ;
}

init 
{
	// Start the master and subscriber
	run master(n2m,m2n) ;
	run subscriber(m2n,n2m,p2s) ;

	if
	:: tot_pubs == 1 ->
			run publisher(m2n,n2m,p2s,'a') ;
	:: tot_pubs == 2 ->
			run publisher(m2n,n2m,p2s,'a') ;
			run publisher(m2n,n2m,p2s,'b') ;
	:: tot_pubs == 3 ->
			run publisher(m2n,n2m,p2s,'a') ;
			run publisher(m2n,n2m,p2s,'b') ;
			run publisher(m2n,n2m,p2s,'c') ;
	fi

	//Check everything has closed
	do
	:: (active_mast + active_pubs + active_subs) == 0 ->
		break ;
	:: else ->
		skip ;
	od
	// If it reaches here it reaches a valid end state
	printf("Ended safely\n") ;
	printf("Total messages from publisher 1: %d\n", a_count) ;
	printf("Total messages from publisher 2: %d\n", b_count) ;
	printf("Total messages from publisher 3: %d\n", c_count) ;
	
}

