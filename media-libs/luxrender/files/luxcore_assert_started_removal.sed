s/assert (started);/if(!started){LC_LOG("ERROR: " << __PRETTY_FUNCTION__ << " excepts 'started' member set, but it is not"); return;}/g
s/assert (!started);/if(started){LC_LOG("ERROR: " << __PRETTY_FUNCTION__ << " excepts 'started' member unset, but it is"); return;}/g
