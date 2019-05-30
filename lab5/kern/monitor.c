// Simple command-line kernel monitor useful for
// controlling the kernel and exploring the system interactively.

#include <inc/stdio.h>
#include <inc/string.h>
#include <inc/memlayout.h>
#include <inc/assert.h>
#include <inc/x86.h>

#include <kern/console.h>
#include <kern/monitor.h>
#include <kern/kdebug.h>
#include <kern/trap.h>
#include <kern/pmap.h>

#define CMDBUF_SIZE	80	// enough for one VGA text line


struct Command {
	const char *name;
	const char *desc;
	// return -1 to force monitor to exit
	int (*func)(int argc, char** argv, struct Trapframe* tf);
};

static struct Command commands[] = {
	{ "help", "Display this list of commands", mon_help },
	{ "kerninfo", "Display information about the kernel", mon_kerninfo },
	{ "backtrace", "Stack backtrace", mon_backtrace },
	{ "time", "counts the program's running time. usage: time [command]", mon_time },
	{ "showmappings", "show physical pages mapped to virtual pages", mon_showmapping },
	{ "setpageperm", "set the permission of a page, include r w u k", mon_setperm },
	{ "dumpva", "dump va, usage: dumpva va size", mon_dumpva },
	{ "dumppa", "dump pa, usage: dumppa va size", mon_dumppa },
};

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
	return 0;
}

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
	cprintf("  _start                  %08x (phys)\n", _start);
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
	cprintf("Kernel executable memory footprint: %dKB\n",
		ROUNDUP(end - entry, 1024) / 1024);
	return 0;
}

// Lab1 only
// read the pointer to the retaddr on the stack
static uint32_t
read_pretaddr() {
    uint32_t pretaddr;
    __asm __volatile("leal 4(%%ebp), %0" : "=r" (pretaddr)); 
    return pretaddr;
}

void
do_overflow(void)
{
    cprintf("Overflow success\n");
}

void
start_overflow(void)
{
	// You should use a techique similar to buffer overflow
	// to invoke the do_overflow function and
	// the procedure must return normally.

    // And you must use the "cprintf" function with %n specifier
    // you augmented in the "Exercise 9" to do this job.

    // hint: You can use the read_pretaddr function to retrieve 
    //       the pointer to the function call return address;

    char str[256] = {};
    int nstr = 0;
    char *pret_addr;

    pret_addr = (char*)read_pretaddr();
	uint32_t int_pret = *(uint32_t *)pret_addr;
	int over_addr = (int)do_overflow;
	for (int i = 0; i < 4; ++i) {
		memset(str, ' ', 256);
		memset(str+(int)(over_addr&0xff), 0, 8);
		cprintf("%s%n", str, pret_addr + i);
		over_addr = over_addr >> 8;
	}
	for (int i = 4; i < 8; ++i) {
		memset(str, ' ', 256);
		memset(str+(int)(int_pret&0xff), 0, 8);
		cprintf("%s%n", str, pret_addr + i);
		int_pret = int_pret >> 8;
	}
}

void
overflow_me(void)
{
        start_overflow();
}

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
	// Your code here.
	overflow_me();
	cprintf("Stack backtrace\n");
	
	uint32_t *ebp = (uint32_t*) read_ebp();
	struct Eipdebuginfo info;
	while(ebp!=NULL){
		// eip: M(4(%ebp))
		cprintf("  eip %08x ebp %08x args %08x %08x %08x %08x %08x\n", 
			*(ebp+1), (uint32_t)ebp, *(ebp+2), *(ebp+3), *(ebp+4), *(ebp+5), *(ebp+6));
		// debuginfo returns negtive if info not found
		if(debuginfo_eip((uintptr_t)(*(ebp+1)), &info)>=0)
	        	cprintf("        %s:%u %.*s+%u\n",
				info.eip_file, info.eip_line, info.eip_fn_namelen, info.eip_fn_name,
	                	(*(ebp+1)) - (uint32_t)info.eip_fn_addr);
	        ebp = (uint32_t *) (*ebp);
	}
    	cprintf("Backtrace success\n");
	return 0;
}



/***** Kernel monitor command interpreter *****/

#define WHITESPACE "\t\r\n "
#define MAXARGS 16

static int
runcmd(char *buf, struct Trapframe *tf)
{
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
		if (*buf == 0)
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
	}
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
	return 0;
}

void
monitor(struct Trapframe *tf)
{
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
	cprintf("Type 'help' for a list of commands.\n");

	if (tf != NULL)
		print_trapframe(tf);

	while (1) {
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
	}
}

int
mon_time(int argc, char **argv, struct Trapframe *tf)
{
	uint64_t tsc_start, tsc_end;
	char str[256] = {};

 	// [command] missed
	if (argc == 1) {
		cprintf("Arguement missing: time [command]\n");
		return 0;
	}
	for (int i = 0; i < 4; i++) {
		if (strcmp(argv[1], commands[i].name) == 0) {
			tsc_start = read_tsc();
			strncpy(str, commands[i].name, (size_t)strlen(commands[i].name));
			runcmd(str, tf);
			tsc_end = read_tsc();
			cprintf("%s cycles: %llu\n", argv[1], tsc_end - tsc_start);
			return 0;
		}
	}
	cprintf("Unknown command '%s'\n", argv[1]);
	return 0;
}

size_t
page_size(uintptr_t va){
	pte_t *pte = pgdir_walk_large(kern_pgdir, (void *)va, 0);
	if(pte && ((*pte) & PTE_P) && ((*pte)&PTE_PS))
		return PTSIZE;
	return PGSIZE;
}

void
print_v2p(uintptr_t va)
{
	pte_t *pte = pgdir_walk_large(kern_pgdir, (void *)va, 0);
	size_t size;
	bool write, user, large;

	if(!pte || !(*pte & PTE_P)){
		cprintf("%08p not exists or not mapped\n", va);
		return;
	}

	if(*pte & PTE_W)
		write = true;
	else
		write = false;
	if(*pte & PTE_U)
		user = true;
	else
		user = false;
	if(*pte & PTE_PS){
		large = true;
		size = PTSIZE;
	} else {
		large = false;
		size = PGSIZE;
	}
	cprintf("va:\t\t\tpa:\n");
	cprintf("%08p --- %08p  ->  %08p --- %08p\n", va, va+size-1, PTE_ADDR(*pte), PTE_ADDR(*pte)+size-1);
	cprintf("R/W\tU/K\t4K/4M page\n");
	if(write)
		cprintf("R/W");
	else
		cprintf("R/-");
	if(user)
		cprintf("\tU");
	else
		cprintf("\tK");
	if(large)
		cprintf("\t\t4M page\n");
	else
		cprintf("\t\t4K page\n");	
}

int
mon_showmapping(int argc, char **argv, struct Trapframe *tf)
{
	uintptr_t va0, va1;
	pte_t *pte0, *pte1;

	if(argc == 1){
		cprintf("usage: showmapping va1 [va2]\n");
		return 0;
	}

	if(argc == 2){
		va0 = (uintptr_t)strtol(argv[1], NULL, 0);
		pte0 = pgdir_walk_large(kern_pgdir, (void *)va0, 0);

		if(pte0 && ((*pte0)&PTE_P) && ((*pte0)&PTE_PS))
			va0 = ROUNDDOWN(va0, PTSIZE);
		else
			va0 = ROUNDDOWN(va0, PGSIZE);
		print_v2p(va0);
		return 0;
	}

	if(argc == 3){
		va0 = (uintptr_t)strtol(argv[1], NULL, 0);
		va1 = (uintptr_t)strtol(argv[2], NULL, 0);

		if(va0 > va1){
			cprintf("va2 must larger than va0\n");
			return 0;
		}
		
		if(va1 > 0xf0000000){
			cprintf("va2 out of va range\n");
			return 0;
		}

		pte0 = pgdir_walk_large(kern_pgdir, (void *)va0, 0);
		if(pte0 && ((*pte0)&PTE_P) && ((*pte0)&PTE_PS))
			va0 = ROUNDDOWN(va0, PTSIZE);
		else
			va0 = ROUNDDOWN(va0, PGSIZE);

		pte1 = pgdir_walk_large(kern_pgdir, (void *)va1, 0);
		if(pte1 && ((*pte1)&PTE_P) && (*pte1)&PTE_PS)
			va1 = ROUNDUP(va1, PTSIZE);
		else
			va1 = ROUNDUP(va1, PGSIZE);
		for(; va0<va1; va0+=page_size(va0)){
			print_v2p(va0);
		}

		return 0;
	}
	cprintf("usage: showmapping va1 [va2]\n");
	return 0;
}

int mon_setperm(int argc, char **argv, struct Trapframe *tf){
	if(argc <= 2){
		cprintf("usage: setpageperm va perm0 {perm1}\n");
		return 0;
	}
	uintptr_t va;
	pte_t *pte;
	size_t i;
	char perm;

	va = (uintptr_t)strtol(argv[1], NULL, 0);
	pte = pgdir_walk(kern_pgdir, (void *)va, false);
	if(!pte || !((*pte)&PTE_P)){
		cprintf("%08p not exists or not mapped\n", va);
		return 0;
	}
	for(i=2; i<argc; i++){
		perm = argv[i][0];
		switch (perm)
		{
			case 'r':
				*pte = (*pte) & ~PTE_W;
				cprintf("set page %08p perm to ~PTE_W\n", va);
				break;
			case 'w':
				*pte = (*pte) | PTE_W;
				cprintf("set page %08p perm to PTE_W\n", va);
				break;
			case 'u':
				*pte = (*pte) | PTE_U;
				cprintf("set page %08p perm to PTE_U\n", va);
				break;
			case 'k':
				*pte = (*pte) & ~PTE_U;
				cprintf("set page %08p perm to ~PTE_U\n", va);
				break;
			default:
				cprintf("useage: u(user) k(kernel) r(R/-) W(R/W)\n");
				break;
		}
	}
	return 0;
}

int mon_dumpva(int argc, char **argv, struct Trapframe *tf)
{
	if(argc != 3){
		cprintf("usage: dumpva va size\n");
		return 0;
	}

	uintptr_t va0, va1, va;
	size_t size, i;
	pte_t *pte0, *pte1, *pte;

	va0 = (uintptr_t)strtol(argv[1], NULL, 0);
	size = (size_t)strtol(argv[2], NULL, 0);

	if(size<0 || size>4096){
		cprintf("size out of range: [0, 4096]\n");
		return 0;
	}
	va1 = va0 + size;

	pte0 = pgdir_walk_large(kern_pgdir, (void *)va0, 0);
	if(pte0 && ((*pte0)&PTE_P) && ((*pte0)&PTE_PS))
		va0 = ROUNDDOWN(va0, PTSIZE);
	else
		va0 = ROUNDDOWN(va0, PGSIZE);
	
	pte1 = pgdir_walk_large(kern_pgdir, (void *)va1, 0);
	if(pte0 && ((*pte0)&PTE_P) && ((*pte0)&PTE_PS))
		va0 = ROUNDUP(va0, PTSIZE);
	else
		va0 = ROUNDUP(va0, PGSIZE);
	
	for(va=va0; va<va1; va++){
		pte = pgdir_walk_large(kern_pgdir, (void *)va, 0);
		if(!(pte && ((*pte)&PTE_P))){
			cprintf("%08p-%08p not exists or not mapped\n", va, va+size);
			return 0;
		}
	}

	cprintf("%08p: ", va0);
	for(i=0; i<size; i++){
		cprintf("%02x ", *(unsigned char*)(va0+i));
		if((i+1)%10 == 0 && (i+1)<size){
			cprintf("\n%08p: ", va0+i+1);
		}
	}
	cprintf("\n");
	return 0;
}

int mon_dumppa(int argc, char **argv, struct Trapframe *tf)
{
	if(argc != 3){
		cprintf("usage: dumppa pa size\n");
		return 0;
	}

	physaddr_t pa;
	size_t size, i;

	pa = (physaddr_t)strtol(argv[1], NULL, 0);
	size = (size_t)strtol(argv[2], NULL, 0);

	if(size<0 || size>4096){
		cprintf("size out of range: [0, 4096]\n");
		return 0;
	}

	if(pa >= npages*PGSIZE || pa+size >= npages*PGSIZE || pa<0 || pa+size<0){
		cprintf("size out of range: [0, 4096]\n");
		return 0;
	}
	cprintf("%08p: ", pa);
	for(i=0; i<size; i++){
		cprintf("%02x ", *((unsigned char*)KADDR(pa)+i));
		if((i+1)%10==0 && (i+1)<size){
			cprintf("\n%08p: ", pa+i+1);
		}
	}
	cprintf("\n");
	return 0;
}


