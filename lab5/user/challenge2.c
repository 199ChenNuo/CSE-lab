// Fork a binary tree of processes and display their structure.

#include <inc/lib.h>
#include <inc/string.h>



void
umain(int argc, char **argv)
{
    envid_t who;
    int i;
    childid = fork();

    if(childid == 0){
        sys_env_set_priority(childid, ENV_PRIOR_HIGH);
        cprintf("I'm parent, my priority is higher than child\n");
        sys_yield();
        cprintf("I'm parent, and I got control\n");
    } else {
        cprintf("I'm child, and I got control\n");
    }

}
