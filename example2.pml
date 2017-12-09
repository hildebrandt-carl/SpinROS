// Alternating bit protocol implentation
mtype {MSG, ACK} ;

chan toR = [0] of { mtype , bit} ;
chan toS = [0] of { mtype , bit } ;

proctype sender(chan in, out) 
{
    int sendBit, recievedBit ;
    out!MSG, sendBit ;
    do
    :: in?ACK, recievedBit 
            ->  out!MSG , sendBit ;
                printf("sender an ACK, %d\n", recievedBit) ;
            if
                :: sendBit == recievedBit -> sendBit = 1 - sendBit;
                :: else
            fi
    od
}

proctype reciever(chan in, out)
{
    int recievedBit
    do
    :: in?MSG, recievedBit 
            ->  out!ACK, recievedBit ; 
                printf("reciever a MSG, %d\n", recievedBit) ;
    od
}

init 
{
    int lastpid;
    atomic
    {
        printf("init process, my pid is: %d\n", _pid);
        lastpid = run reciever(toR, toS);
        lastpid = run sender( toS, toR);
        printf("last pid was: %d\n", lastpid);
    }
}