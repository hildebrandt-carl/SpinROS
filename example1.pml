byte cnt
byte x, y, z

active [2] proctype user()
{	
    byte me = _pid+1

    L1:	x = me
    if
        :: (y != 0 && y != me) -> goto L1
        :: (y == 0 || y == me)
    fi
        z = me
    if
        :: (x != me)  -> goto L1
        :: (x == me)
    fi
    y = me
    if
        :: (z != me) -> goto L1
        :: (z == me)
    fi
    			                       
    cnt++
    assert(cnt == 1)
    cnt--
}