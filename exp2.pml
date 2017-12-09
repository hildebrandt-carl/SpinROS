
mtype = {RED, YELLOW, GREEN} ;

proctype Robot() 
{
    byte state = GREEN ;
    do
    :: (state == GREEN) -> state = YELLOW ; printf("Yellow\n") ;
    :: (state == YELLOW) -> state = RED ; printf("Red\n") ;
    :: (state == RED) -> state = GREEN ; printf("Green\n") ;
    od
}

init 
{
    int lastpid;
    atomic
    {
        printf("init process, my pid is: %d\n", _pid);
        lastpid = run Robot();
        printf("last pid was: %d\n", lastpid);
    }
}