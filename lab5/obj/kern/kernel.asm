
obj/kern/kernel:     file format elf32-i386


Disassembly of section .text:

f0100000 <_start+0xeffffff4>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
f0100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
f0100006:	00 00                	add    %al,(%eax)
f0100008:	fe 4f 52             	decb   0x52(%edi)
f010000b:	e4                   	.byte 0xe4

f010000c <entry>:
f010000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f0100013:	34 12 
	# sufficient until we set up our real page table in mem_init
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
f0100015:	b8 00 40 12 00       	mov    $0x124000,%eax
	movl	%eax, %cr3
f010001a:	0f 22 d8             	mov    %eax,%cr3
	# Turn on huge page
	movl	%cr4, %eax
f010001d:	0f 20 e0             	mov    %cr4,%eax
	orl	$(CR4_PSE), %eax
f0100020:	83 c8 10             	or     $0x10,%eax
	movl	%eax, %cr4
f0100023:	0f 22 e0             	mov    %eax,%cr4
	# Turn on paging.
	movl	%cr0, %eax
f0100026:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
f0100029:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0
f010002e:	0f 22 c0             	mov    %eax,%cr0
	# Turn on page size extension.

	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
f0100031:	b8 38 00 10 f0       	mov    $0xf0100038,%eax
	jmp	*%eax
f0100036:	ff e0                	jmp    *%eax

f0100038 <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
f0100038:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
f010003d:	bc 00 40 12 f0       	mov    $0xf0124000,%esp

	# now to C code
	call	i386_init
f0100042:	e8 5e 00 00 00       	call   f01000a5 <i386_init>

f0100047 <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f0100047:	eb fe                	jmp    f0100047 <spin>

f0100049 <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f0100049:	55                   	push   %ebp
f010004a:	89 e5                	mov    %esp,%ebp
f010004c:	56                   	push   %esi
f010004d:	53                   	push   %ebx
f010004e:	8b 75 10             	mov    0x10(%ebp),%esi
	va_list ap;

	if (panicstr)
f0100051:	83 3d 80 5e 34 f0 00 	cmpl   $0x0,0xf0345e80
f0100058:	74 0f                	je     f0100069 <_panic+0x20>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f010005a:	83 ec 0c             	sub    $0xc,%esp
f010005d:	6a 00                	push   $0x0
f010005f:	e8 85 10 00 00       	call   f01010e9 <monitor>
f0100064:	83 c4 10             	add    $0x10,%esp
f0100067:	eb f1                	jmp    f010005a <_panic+0x11>
	panicstr = fmt;
f0100069:	89 35 80 5e 34 f0    	mov    %esi,0xf0345e80
	asm volatile("cli; cld");
f010006f:	fa                   	cli    
f0100070:	fc                   	cld    
	va_start(ap, fmt);
f0100071:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel panic on CPU %d at %s:%d: ", cpunum(), file, line);
f0100074:	e8 21 6d 00 00       	call   f0106d9a <cpunum>
f0100079:	ff 75 0c             	pushl  0xc(%ebp)
f010007c:	ff 75 08             	pushl  0x8(%ebp)
f010007f:	50                   	push   %eax
f0100080:	68 e0 73 10 f0       	push   $0xf01073e0
f0100085:	e8 5f 45 00 00       	call   f01045e9 <cprintf>
	vcprintf(fmt, ap);
f010008a:	83 c4 08             	add    $0x8,%esp
f010008d:	53                   	push   %ebx
f010008e:	56                   	push   %esi
f010008f:	e8 2f 45 00 00       	call   f01045c3 <vcprintf>
	cprintf("\n");
f0100094:	c7 04 24 33 8b 10 f0 	movl   $0xf0108b33,(%esp)
f010009b:	e8 49 45 00 00       	call   f01045e9 <cprintf>
f01000a0:	83 c4 10             	add    $0x10,%esp
f01000a3:	eb b5                	jmp    f010005a <_panic+0x11>

f01000a5 <i386_init>:
{
f01000a5:	55                   	push   %ebp
f01000a6:	89 e5                	mov    %esp,%ebp
f01000a8:	57                   	push   %edi
f01000a9:	53                   	push   %ebx
f01000aa:	81 ec 14 01 00 00    	sub    $0x114,%esp
	char ntest[256] = {};
f01000b0:	8d bd f0 fe ff ff    	lea    -0x110(%ebp),%edi
f01000b6:	b9 40 00 00 00       	mov    $0x40,%ecx
f01000bb:	b8 00 00 00 00       	mov    $0x0,%eax
f01000c0:	f3 ab                	rep stos %eax,%es:(%edi)
	memset(edata, 0, end - edata);
f01000c2:	b8 08 70 38 f0       	mov    $0xf0387008,%eax
f01000c7:	2d 00 40 34 f0       	sub    $0xf0344000,%eax
f01000cc:	50                   	push   %eax
f01000cd:	6a 00                	push   $0x0
f01000cf:	68 00 40 34 f0       	push   $0xf0344000
f01000d4:	e8 bb 66 00 00       	call   f0106794 <memset>
	cons_init();
f01000d9:	e8 fd 05 00 00       	call   f01006db <cons_init>
	cprintf("6828 decimal is %o octal!%n\n%n", 6828, &chnum1, &chnum2);
f01000de:	8d 45 f0             	lea    -0x10(%ebp),%eax
f01000e1:	50                   	push   %eax
f01000e2:	8d 7d f4             	lea    -0xc(%ebp),%edi
f01000e5:	57                   	push   %edi
f01000e6:	68 ac 1a 00 00       	push   $0x1aac
f01000eb:	68 04 74 10 f0       	push   $0xf0107404
f01000f0:	e8 f4 44 00 00       	call   f01045e9 <cprintf>
	cprintf("pading space in the right to number 22: %-8d.\n", 22);
f01000f5:	83 c4 18             	add    $0x18,%esp
f01000f8:	6a 16                	push   $0x16
f01000fa:	68 24 74 10 f0       	push   $0xf0107424
f01000ff:	e8 e5 44 00 00       	call   f01045e9 <cprintf>
	cprintf("chnum1: %d chnum2: %d\n", chnum1, chnum2);
f0100104:	83 c4 0c             	add    $0xc,%esp
f0100107:	ff 75 f0             	pushl  -0x10(%ebp)
f010010a:	ff 75 f4             	pushl  -0xc(%ebp)
f010010d:	68 9c 74 10 f0       	push   $0xf010749c
f0100112:	e8 d2 44 00 00       	call   f01045e9 <cprintf>
	cprintf("%n", NULL);
f0100117:	83 c4 08             	add    $0x8,%esp
f010011a:	6a 00                	push   $0x0
f010011c:	68 b5 74 10 f0       	push   $0xf01074b5
f0100121:	e8 c3 44 00 00       	call   f01045e9 <cprintf>
	memset(ntest, 0xd, sizeof(ntest) - 1);
f0100126:	83 c4 0c             	add    $0xc,%esp
f0100129:	68 ff 00 00 00       	push   $0xff
f010012e:	6a 0d                	push   $0xd
f0100130:	8d 9d f0 fe ff ff    	lea    -0x110(%ebp),%ebx
f0100136:	53                   	push   %ebx
f0100137:	e8 58 66 00 00       	call   f0106794 <memset>
	cprintf("%s%n", ntest, &chnum1); 
f010013c:	83 c4 0c             	add    $0xc,%esp
f010013f:	57                   	push   %edi
f0100140:	53                   	push   %ebx
f0100141:	68 b3 74 10 f0       	push   $0xf01074b3
f0100146:	e8 9e 44 00 00       	call   f01045e9 <cprintf>
	cprintf("chnum1: %d\n", chnum1);
f010014b:	83 c4 08             	add    $0x8,%esp
f010014e:	ff 75 f4             	pushl  -0xc(%ebp)
f0100151:	68 b8 74 10 f0       	push   $0xf01074b8
f0100156:	e8 8e 44 00 00       	call   f01045e9 <cprintf>
	cprintf("show me the sign: %+d, %+d\n", 1024, -1024);
f010015b:	83 c4 0c             	add    $0xc,%esp
f010015e:	68 00 fc ff ff       	push   $0xfffffc00
f0100163:	68 00 04 00 00       	push   $0x400
f0100168:	68 c4 74 10 f0       	push   $0xf01074c4
f010016d:	e8 77 44 00 00       	call   f01045e9 <cprintf>
	mem_init();
f0100172:	e8 fa 1c 00 00       	call   f0101e71 <mem_init>
	env_init();
f0100177:	e8 f5 3a 00 00       	call   f0103c71 <env_init>
	trap_init();
f010017c:	e8 54 45 00 00       	call   f01046d5 <trap_init>
	mp_init();
f0100181:	e8 1d 69 00 00       	call   f0106aa3 <mp_init>
	lapic_init();
f0100186:	e8 25 6c 00 00       	call   f0106db0 <lapic_init>
	pic_init();
f010018b:	e8 70 43 00 00       	call   f0104500 <pic_init>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f0100190:	c7 04 24 c0 53 12 f0 	movl   $0xf01253c0,(%esp)
f0100197:	e8 6e 6e 00 00       	call   f010700a <spin_lock>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f010019c:	83 c4 10             	add    $0x10,%esp
f010019f:	83 3d 88 5e 34 f0 07 	cmpl   $0x7,0xf0345e88
f01001a6:	76 27                	jbe    f01001cf <i386_init+0x12a>
	memmove(code, mpentry_start, mpentry_end - mpentry_start);
f01001a8:	83 ec 04             	sub    $0x4,%esp
f01001ab:	b8 06 6a 10 f0       	mov    $0xf0106a06,%eax
f01001b0:	2d 84 69 10 f0       	sub    $0xf0106984,%eax
f01001b5:	50                   	push   %eax
f01001b6:	68 84 69 10 f0       	push   $0xf0106984
f01001bb:	68 00 70 00 f0       	push   $0xf0007000
f01001c0:	e8 17 66 00 00       	call   f01067dc <memmove>
f01001c5:	83 c4 10             	add    $0x10,%esp
	for (c = cpus; c < cpus + ncpu; c++) {
f01001c8:	bb 20 60 34 f0       	mov    $0xf0346020,%ebx
f01001cd:	eb 19                	jmp    f01001e8 <i386_init+0x143>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01001cf:	68 00 70 00 00       	push   $0x7000
f01001d4:	68 54 74 10 f0       	push   $0xf0107454
f01001d9:	6a 64                	push   $0x64
f01001db:	68 e0 74 10 f0       	push   $0xf01074e0
f01001e0:	e8 64 fe ff ff       	call   f0100049 <_panic>
f01001e5:	83 c3 74             	add    $0x74,%ebx
f01001e8:	6b 05 c4 63 34 f0 74 	imul   $0x74,0xf03463c4,%eax
f01001ef:	05 20 60 34 f0       	add    $0xf0346020,%eax
f01001f4:	39 c3                	cmp    %eax,%ebx
f01001f6:	73 4d                	jae    f0100245 <i386_init+0x1a0>
		if (c == cpus + cpunum())  // We've started already.
f01001f8:	e8 9d 6b 00 00       	call   f0106d9a <cpunum>
f01001fd:	6b c0 74             	imul   $0x74,%eax,%eax
f0100200:	05 20 60 34 f0       	add    $0xf0346020,%eax
f0100205:	39 c3                	cmp    %eax,%ebx
f0100207:	74 dc                	je     f01001e5 <i386_init+0x140>
		mpentry_kstack = percpu_kstacks[c - cpus] + KSTKSIZE;
f0100209:	89 d8                	mov    %ebx,%eax
f010020b:	2d 20 60 34 f0       	sub    $0xf0346020,%eax
f0100210:	c1 f8 02             	sar    $0x2,%eax
f0100213:	69 c0 35 c2 72 4f    	imul   $0x4f72c235,%eax,%eax
f0100219:	c1 e0 0f             	shl    $0xf,%eax
f010021c:	8d 80 00 f0 34 f0    	lea    -0xfcb1000(%eax),%eax
f0100222:	a3 84 5e 34 f0       	mov    %eax,0xf0345e84
		lapic_startap(c->cpu_id, PADDR(code));
f0100227:	83 ec 08             	sub    $0x8,%esp
f010022a:	68 00 70 00 00       	push   $0x7000
f010022f:	0f b6 03             	movzbl (%ebx),%eax
f0100232:	50                   	push   %eax
f0100233:	e8 ca 6c 00 00       	call   f0106f02 <lapic_startap>
f0100238:	83 c4 10             	add    $0x10,%esp
		while(c->cpu_status != CPU_STARTED)
f010023b:	8b 43 04             	mov    0x4(%ebx),%eax
f010023e:	83 f8 01             	cmp    $0x1,%eax
f0100241:	75 f8                	jne    f010023b <i386_init+0x196>
f0100243:	eb a0                	jmp    f01001e5 <i386_init+0x140>
	ENV_CREATE(TEST, ENV_TYPE_USER);
f0100245:	83 ec 08             	sub    $0x8,%esp
f0100248:	6a 00                	push   $0x0
f010024a:	68 ac ef 25 f0       	push   $0xf025efac
f010024f:	e8 f8 3c 00 00       	call   f0103f4c <env_create>
	sched_yield();
f0100254:	e8 48 50 00 00       	call   f01052a1 <sched_yield>

f0100259 <mp_main>:
{
f0100259:	55                   	push   %ebp
f010025a:	89 e5                	mov    %esp,%ebp
f010025c:	83 ec 08             	sub    $0x8,%esp
	lcr3(PADDR(kern_pgdir));
f010025f:	a1 8c 5e 34 f0       	mov    0xf0345e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f0100264:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100269:	76 52                	jbe    f01002bd <mp_main+0x64>
	return (physaddr_t)kva - KERNBASE;
f010026b:	05 00 00 00 10       	add    $0x10000000,%eax
}

static inline void
lcr3(uint32_t val)
{
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0100270:	0f 22 d8             	mov    %eax,%cr3
	cprintf("SMP: CPU %d starting\n", cpunum());
f0100273:	e8 22 6b 00 00       	call   f0106d9a <cpunum>
f0100278:	83 ec 08             	sub    $0x8,%esp
f010027b:	50                   	push   %eax
f010027c:	68 ec 74 10 f0       	push   $0xf01074ec
f0100281:	e8 63 43 00 00       	call   f01045e9 <cprintf>
	lapic_init();
f0100286:	e8 25 6b 00 00       	call   f0106db0 <lapic_init>
	env_init_percpu();
f010028b:	e8 b5 39 00 00       	call   f0103c45 <env_init_percpu>
	trap_init_percpu();
f0100290:	e8 68 43 00 00       	call   f01045fd <trap_init_percpu>
	xchg(&thiscpu->cpu_status, CPU_STARTED); // tell boot_aps() we're up
f0100295:	e8 00 6b 00 00       	call   f0106d9a <cpunum>
f010029a:	6b d0 74             	imul   $0x74,%eax,%edx
f010029d:	83 c2 04             	add    $0x4,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1"
f01002a0:	b8 01 00 00 00       	mov    $0x1,%eax
f01002a5:	f0 87 82 20 60 34 f0 	lock xchg %eax,-0xfcb9fe0(%edx)
f01002ac:	c7 04 24 c0 53 12 f0 	movl   $0xf01253c0,(%esp)
f01002b3:	e8 52 6d 00 00       	call   f010700a <spin_lock>
	sched_yield();
f01002b8:	e8 e4 4f 00 00       	call   f01052a1 <sched_yield>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01002bd:	50                   	push   %eax
f01002be:	68 78 74 10 f0       	push   $0xf0107478
f01002c3:	6a 7b                	push   $0x7b
f01002c5:	68 e0 74 10 f0       	push   $0xf01074e0
f01002ca:	e8 7a fd ff ff       	call   f0100049 <_panic>

f01002cf <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f01002cf:	55                   	push   %ebp
f01002d0:	89 e5                	mov    %esp,%ebp
f01002d2:	53                   	push   %ebx
f01002d3:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
f01002d6:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel warning at %s:%d: ", file, line);
f01002d9:	ff 75 0c             	pushl  0xc(%ebp)
f01002dc:	ff 75 08             	pushl  0x8(%ebp)
f01002df:	68 02 75 10 f0       	push   $0xf0107502
f01002e4:	e8 00 43 00 00       	call   f01045e9 <cprintf>
	vcprintf(fmt, ap);
f01002e9:	83 c4 08             	add    $0x8,%esp
f01002ec:	53                   	push   %ebx
f01002ed:	ff 75 10             	pushl  0x10(%ebp)
f01002f0:	e8 ce 42 00 00       	call   f01045c3 <vcprintf>
	cprintf("\n");
f01002f5:	c7 04 24 33 8b 10 f0 	movl   $0xf0108b33,(%esp)
f01002fc:	e8 e8 42 00 00       	call   f01045e9 <cprintf>
	va_end(ap);
}
f0100301:	83 c4 10             	add    $0x10,%esp
f0100304:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100307:	c9                   	leave  
f0100308:	c3                   	ret    

f0100309 <serial_proc_data>:
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100309:	ba fd 03 00 00       	mov    $0x3fd,%edx
f010030e:	ec                   	in     (%dx),%al
static bool serial_exists;

static int
serial_proc_data(void)
{
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f010030f:	a8 01                	test   $0x1,%al
f0100311:	74 0a                	je     f010031d <serial_proc_data+0x14>
f0100313:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100318:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f0100319:	0f b6 c0             	movzbl %al,%eax
f010031c:	c3                   	ret    
		return -1;
f010031d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f0100322:	c3                   	ret    

f0100323 <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f0100323:	55                   	push   %ebp
f0100324:	89 e5                	mov    %esp,%ebp
f0100326:	53                   	push   %ebx
f0100327:	83 ec 04             	sub    $0x4,%esp
f010032a:	89 c3                	mov    %eax,%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f010032c:	ff d3                	call   *%ebx
f010032e:	83 f8 ff             	cmp    $0xffffffff,%eax
f0100331:	74 29                	je     f010035c <cons_intr+0x39>
		if (c == 0)
f0100333:	85 c0                	test   %eax,%eax
f0100335:	74 f5                	je     f010032c <cons_intr+0x9>
			continue;
		cons.buf[cons.wpos++] = c;
f0100337:	8b 0d 24 42 34 f0    	mov    0xf0344224,%ecx
f010033d:	8d 51 01             	lea    0x1(%ecx),%edx
f0100340:	88 81 20 40 34 f0    	mov    %al,-0xfcbbfe0(%ecx)
		if (cons.wpos == CONSBUFSIZE)
f0100346:	81 fa 00 02 00 00    	cmp    $0x200,%edx
			cons.wpos = 0;
f010034c:	b8 00 00 00 00       	mov    $0x0,%eax
f0100351:	0f 44 d0             	cmove  %eax,%edx
f0100354:	89 15 24 42 34 f0    	mov    %edx,0xf0344224
f010035a:	eb d0                	jmp    f010032c <cons_intr+0x9>
	}
}
f010035c:	83 c4 04             	add    $0x4,%esp
f010035f:	5b                   	pop    %ebx
f0100360:	5d                   	pop    %ebp
f0100361:	c3                   	ret    

f0100362 <kbd_proc_data>:
{
f0100362:	55                   	push   %ebp
f0100363:	89 e5                	mov    %esp,%ebp
f0100365:	53                   	push   %ebx
f0100366:	83 ec 04             	sub    $0x4,%esp
f0100369:	ba 64 00 00 00       	mov    $0x64,%edx
f010036e:	ec                   	in     (%dx),%al
	if ((stat & KBS_DIB) == 0)
f010036f:	a8 01                	test   $0x1,%al
f0100371:	0f 84 f2 00 00 00    	je     f0100469 <kbd_proc_data+0x107>
	if (stat & KBS_TERR)
f0100377:	a8 20                	test   $0x20,%al
f0100379:	0f 85 f1 00 00 00    	jne    f0100470 <kbd_proc_data+0x10e>
f010037f:	ba 60 00 00 00       	mov    $0x60,%edx
f0100384:	ec                   	in     (%dx),%al
f0100385:	89 c2                	mov    %eax,%edx
	if (data == 0xE0) {
f0100387:	3c e0                	cmp    $0xe0,%al
f0100389:	74 61                	je     f01003ec <kbd_proc_data+0x8a>
	} else if (data & 0x80) {
f010038b:	84 c0                	test   %al,%al
f010038d:	78 70                	js     f01003ff <kbd_proc_data+0x9d>
	} else if (shift & E0ESC) {
f010038f:	8b 0d 00 40 34 f0    	mov    0xf0344000,%ecx
f0100395:	f6 c1 40             	test   $0x40,%cl
f0100398:	74 0e                	je     f01003a8 <kbd_proc_data+0x46>
		data |= 0x80;
f010039a:	83 c8 80             	or     $0xffffff80,%eax
f010039d:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f010039f:	83 e1 bf             	and    $0xffffffbf,%ecx
f01003a2:	89 0d 00 40 34 f0    	mov    %ecx,0xf0344000
	shift |= shiftcode[data];
f01003a8:	0f b6 d2             	movzbl %dl,%edx
f01003ab:	0f b6 82 80 76 10 f0 	movzbl -0xfef8980(%edx),%eax
f01003b2:	0b 05 00 40 34 f0    	or     0xf0344000,%eax
	shift ^= togglecode[data];
f01003b8:	0f b6 8a 80 75 10 f0 	movzbl -0xfef8a80(%edx),%ecx
f01003bf:	31 c8                	xor    %ecx,%eax
f01003c1:	a3 00 40 34 f0       	mov    %eax,0xf0344000
	c = charcode[shift & (CTL | SHIFT)][data];
f01003c6:	89 c1                	mov    %eax,%ecx
f01003c8:	83 e1 03             	and    $0x3,%ecx
f01003cb:	8b 0c 8d 60 75 10 f0 	mov    -0xfef8aa0(,%ecx,4),%ecx
f01003d2:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
f01003d6:	0f b6 da             	movzbl %dl,%ebx
	if (shift & CAPSLOCK) {
f01003d9:	a8 08                	test   $0x8,%al
f01003db:	74 61                	je     f010043e <kbd_proc_data+0xdc>
		if ('a' <= c && c <= 'z')
f01003dd:	89 da                	mov    %ebx,%edx
f01003df:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
f01003e2:	83 f9 19             	cmp    $0x19,%ecx
f01003e5:	77 4b                	ja     f0100432 <kbd_proc_data+0xd0>
			c += 'A' - 'a';
f01003e7:	83 eb 20             	sub    $0x20,%ebx
f01003ea:	eb 0c                	jmp    f01003f8 <kbd_proc_data+0x96>
		shift |= E0ESC;
f01003ec:	83 0d 00 40 34 f0 40 	orl    $0x40,0xf0344000
		return 0;
f01003f3:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f01003f8:	89 d8                	mov    %ebx,%eax
f01003fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01003fd:	c9                   	leave  
f01003fe:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
f01003ff:	8b 0d 00 40 34 f0    	mov    0xf0344000,%ecx
f0100405:	89 cb                	mov    %ecx,%ebx
f0100407:	83 e3 40             	and    $0x40,%ebx
f010040a:	83 e0 7f             	and    $0x7f,%eax
f010040d:	85 db                	test   %ebx,%ebx
f010040f:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f0100412:	0f b6 d2             	movzbl %dl,%edx
f0100415:	0f b6 82 80 76 10 f0 	movzbl -0xfef8980(%edx),%eax
f010041c:	83 c8 40             	or     $0x40,%eax
f010041f:	0f b6 c0             	movzbl %al,%eax
f0100422:	f7 d0                	not    %eax
f0100424:	21 c8                	and    %ecx,%eax
f0100426:	a3 00 40 34 f0       	mov    %eax,0xf0344000
		return 0;
f010042b:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100430:	eb c6                	jmp    f01003f8 <kbd_proc_data+0x96>
		else if ('A' <= c && c <= 'Z')
f0100432:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
f0100435:	8d 4b 20             	lea    0x20(%ebx),%ecx
f0100438:	83 fa 1a             	cmp    $0x1a,%edx
f010043b:	0f 42 d9             	cmovb  %ecx,%ebx
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f010043e:	f7 d0                	not    %eax
f0100440:	a8 06                	test   $0x6,%al
f0100442:	75 b4                	jne    f01003f8 <kbd_proc_data+0x96>
f0100444:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f010044a:	75 ac                	jne    f01003f8 <kbd_proc_data+0x96>
		cprintf("Rebooting!\n");
f010044c:	83 ec 0c             	sub    $0xc,%esp
f010044f:	68 1c 75 10 f0       	push   $0xf010751c
f0100454:	e8 90 41 00 00       	call   f01045e9 <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100459:	b8 03 00 00 00       	mov    $0x3,%eax
f010045e:	ba 92 00 00 00       	mov    $0x92,%edx
f0100463:	ee                   	out    %al,(%dx)
f0100464:	83 c4 10             	add    $0x10,%esp
f0100467:	eb 8f                	jmp    f01003f8 <kbd_proc_data+0x96>
		return -1;
f0100469:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f010046e:	eb 88                	jmp    f01003f8 <kbd_proc_data+0x96>
		return -1;
f0100470:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f0100475:	eb 81                	jmp    f01003f8 <kbd_proc_data+0x96>

f0100477 <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f0100477:	55                   	push   %ebp
f0100478:	89 e5                	mov    %esp,%ebp
f010047a:	57                   	push   %edi
f010047b:	56                   	push   %esi
f010047c:	53                   	push   %ebx
f010047d:	83 ec 1c             	sub    $0x1c,%esp
f0100480:	89 c1                	mov    %eax,%ecx
	for (i = 0;
f0100482:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100487:	bf fd 03 00 00       	mov    $0x3fd,%edi
f010048c:	bb 84 00 00 00       	mov    $0x84,%ebx
f0100491:	89 fa                	mov    %edi,%edx
f0100493:	ec                   	in     (%dx),%al
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f0100494:	a8 20                	test   $0x20,%al
f0100496:	75 13                	jne    f01004ab <cons_putc+0x34>
f0100498:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f010049e:	7f 0b                	jg     f01004ab <cons_putc+0x34>
f01004a0:	89 da                	mov    %ebx,%edx
f01004a2:	ec                   	in     (%dx),%al
f01004a3:	ec                   	in     (%dx),%al
f01004a4:	ec                   	in     (%dx),%al
f01004a5:	ec                   	in     (%dx),%al
	     i++)
f01004a6:	83 c6 01             	add    $0x1,%esi
f01004a9:	eb e6                	jmp    f0100491 <cons_putc+0x1a>
	outb(COM1 + COM_TX, c);
f01004ab:	88 4d e7             	mov    %cl,-0x19(%ebp)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01004ae:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01004b3:	89 c8                	mov    %ecx,%eax
f01004b5:	ee                   	out    %al,(%dx)
	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f01004b6:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01004bb:	bf 79 03 00 00       	mov    $0x379,%edi
f01004c0:	bb 84 00 00 00       	mov    $0x84,%ebx
f01004c5:	89 fa                	mov    %edi,%edx
f01004c7:	ec                   	in     (%dx),%al
f01004c8:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f01004ce:	7f 0f                	jg     f01004df <cons_putc+0x68>
f01004d0:	84 c0                	test   %al,%al
f01004d2:	78 0b                	js     f01004df <cons_putc+0x68>
f01004d4:	89 da                	mov    %ebx,%edx
f01004d6:	ec                   	in     (%dx),%al
f01004d7:	ec                   	in     (%dx),%al
f01004d8:	ec                   	in     (%dx),%al
f01004d9:	ec                   	in     (%dx),%al
f01004da:	83 c6 01             	add    $0x1,%esi
f01004dd:	eb e6                	jmp    f01004c5 <cons_putc+0x4e>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01004df:	ba 78 03 00 00       	mov    $0x378,%edx
f01004e4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
f01004e8:	ee                   	out    %al,(%dx)
f01004e9:	ba 7a 03 00 00       	mov    $0x37a,%edx
f01004ee:	b8 0d 00 00 00       	mov    $0xd,%eax
f01004f3:	ee                   	out    %al,(%dx)
f01004f4:	b8 08 00 00 00       	mov    $0x8,%eax
f01004f9:	ee                   	out    %al,(%dx)
	if (!(c & ~0xFF))
f01004fa:	89 ca                	mov    %ecx,%edx
f01004fc:	81 e2 00 ff ff ff    	and    $0xffffff00,%edx
		c |= 0x0700;
f0100502:	89 c8                	mov    %ecx,%eax
f0100504:	80 cc 07             	or     $0x7,%ah
f0100507:	85 d2                	test   %edx,%edx
f0100509:	0f 44 c8             	cmove  %eax,%ecx
	switch (c & 0xff) {
f010050c:	0f b6 c1             	movzbl %cl,%eax
f010050f:	83 f8 09             	cmp    $0x9,%eax
f0100512:	0f 84 b0 00 00 00    	je     f01005c8 <cons_putc+0x151>
f0100518:	7e 73                	jle    f010058d <cons_putc+0x116>
f010051a:	83 f8 0a             	cmp    $0xa,%eax
f010051d:	0f 84 98 00 00 00    	je     f01005bb <cons_putc+0x144>
f0100523:	83 f8 0d             	cmp    $0xd,%eax
f0100526:	0f 85 d3 00 00 00    	jne    f01005ff <cons_putc+0x188>
		crt_pos -= (crt_pos % CRT_COLS);
f010052c:	0f b7 05 28 42 34 f0 	movzwl 0xf0344228,%eax
f0100533:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f0100539:	c1 e8 16             	shr    $0x16,%eax
f010053c:	8d 04 80             	lea    (%eax,%eax,4),%eax
f010053f:	c1 e0 04             	shl    $0x4,%eax
f0100542:	66 a3 28 42 34 f0    	mov    %ax,0xf0344228
	if (crt_pos >= CRT_SIZE) {
f0100548:	66 81 3d 28 42 34 f0 	cmpw   $0x7cf,0xf0344228
f010054f:	cf 07 
f0100551:	0f 87 cb 00 00 00    	ja     f0100622 <cons_putc+0x1ab>
	outb(addr_6845, 14);
f0100557:	8b 0d 30 42 34 f0    	mov    0xf0344230,%ecx
f010055d:	b8 0e 00 00 00       	mov    $0xe,%eax
f0100562:	89 ca                	mov    %ecx,%edx
f0100564:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f0100565:	0f b7 1d 28 42 34 f0 	movzwl 0xf0344228,%ebx
f010056c:	8d 71 01             	lea    0x1(%ecx),%esi
f010056f:	89 d8                	mov    %ebx,%eax
f0100571:	66 c1 e8 08          	shr    $0x8,%ax
f0100575:	89 f2                	mov    %esi,%edx
f0100577:	ee                   	out    %al,(%dx)
f0100578:	b8 0f 00 00 00       	mov    $0xf,%eax
f010057d:	89 ca                	mov    %ecx,%edx
f010057f:	ee                   	out    %al,(%dx)
f0100580:	89 d8                	mov    %ebx,%eax
f0100582:	89 f2                	mov    %esi,%edx
f0100584:	ee                   	out    %al,(%dx)
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f0100585:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100588:	5b                   	pop    %ebx
f0100589:	5e                   	pop    %esi
f010058a:	5f                   	pop    %edi
f010058b:	5d                   	pop    %ebp
f010058c:	c3                   	ret    
f010058d:	83 f8 08             	cmp    $0x8,%eax
f0100590:	75 6d                	jne    f01005ff <cons_putc+0x188>
		if (crt_pos > 0) {
f0100592:	0f b7 05 28 42 34 f0 	movzwl 0xf0344228,%eax
f0100599:	66 85 c0             	test   %ax,%ax
f010059c:	74 b9                	je     f0100557 <cons_putc+0xe0>
			crt_pos--;
f010059e:	83 e8 01             	sub    $0x1,%eax
f01005a1:	66 a3 28 42 34 f0    	mov    %ax,0xf0344228
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f01005a7:	0f b7 c0             	movzwl %ax,%eax
f01005aa:	b1 00                	mov    $0x0,%cl
f01005ac:	83 c9 20             	or     $0x20,%ecx
f01005af:	8b 15 2c 42 34 f0    	mov    0xf034422c,%edx
f01005b5:	66 89 0c 42          	mov    %cx,(%edx,%eax,2)
f01005b9:	eb 8d                	jmp    f0100548 <cons_putc+0xd1>
		crt_pos += CRT_COLS;
f01005bb:	66 83 05 28 42 34 f0 	addw   $0x50,0xf0344228
f01005c2:	50 
f01005c3:	e9 64 ff ff ff       	jmp    f010052c <cons_putc+0xb5>
		cons_putc(' ');
f01005c8:	b8 20 00 00 00       	mov    $0x20,%eax
f01005cd:	e8 a5 fe ff ff       	call   f0100477 <cons_putc>
		cons_putc(' ');
f01005d2:	b8 20 00 00 00       	mov    $0x20,%eax
f01005d7:	e8 9b fe ff ff       	call   f0100477 <cons_putc>
		cons_putc(' ');
f01005dc:	b8 20 00 00 00       	mov    $0x20,%eax
f01005e1:	e8 91 fe ff ff       	call   f0100477 <cons_putc>
		cons_putc(' ');
f01005e6:	b8 20 00 00 00       	mov    $0x20,%eax
f01005eb:	e8 87 fe ff ff       	call   f0100477 <cons_putc>
		cons_putc(' ');
f01005f0:	b8 20 00 00 00       	mov    $0x20,%eax
f01005f5:	e8 7d fe ff ff       	call   f0100477 <cons_putc>
f01005fa:	e9 49 ff ff ff       	jmp    f0100548 <cons_putc+0xd1>
		crt_buf[crt_pos++] = c;		/* write the character */
f01005ff:	0f b7 05 28 42 34 f0 	movzwl 0xf0344228,%eax
f0100606:	8d 50 01             	lea    0x1(%eax),%edx
f0100609:	66 89 15 28 42 34 f0 	mov    %dx,0xf0344228
f0100610:	0f b7 c0             	movzwl %ax,%eax
f0100613:	8b 15 2c 42 34 f0    	mov    0xf034422c,%edx
f0100619:	66 89 0c 42          	mov    %cx,(%edx,%eax,2)
f010061d:	e9 26 ff ff ff       	jmp    f0100548 <cons_putc+0xd1>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f0100622:	a1 2c 42 34 f0       	mov    0xf034422c,%eax
f0100627:	83 ec 04             	sub    $0x4,%esp
f010062a:	68 00 0f 00 00       	push   $0xf00
f010062f:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f0100635:	52                   	push   %edx
f0100636:	50                   	push   %eax
f0100637:	e8 a0 61 00 00       	call   f01067dc <memmove>
			crt_buf[i] = 0x0700 | ' ';
f010063c:	8b 15 2c 42 34 f0    	mov    0xf034422c,%edx
f0100642:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f0100648:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f010064e:	83 c4 10             	add    $0x10,%esp
f0100651:	66 c7 00 20 07       	movw   $0x720,(%eax)
f0100656:	83 c0 02             	add    $0x2,%eax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f0100659:	39 d0                	cmp    %edx,%eax
f010065b:	75 f4                	jne    f0100651 <cons_putc+0x1da>
		crt_pos -= CRT_COLS;
f010065d:	66 83 2d 28 42 34 f0 	subw   $0x50,0xf0344228
f0100664:	50 
f0100665:	e9 ed fe ff ff       	jmp    f0100557 <cons_putc+0xe0>

f010066a <serial_intr>:
	if (serial_exists)
f010066a:	80 3d 34 42 34 f0 00 	cmpb   $0x0,0xf0344234
f0100671:	75 01                	jne    f0100674 <serial_intr+0xa>
f0100673:	c3                   	ret    
{
f0100674:	55                   	push   %ebp
f0100675:	89 e5                	mov    %esp,%ebp
f0100677:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
f010067a:	b8 09 03 10 f0       	mov    $0xf0100309,%eax
f010067f:	e8 9f fc ff ff       	call   f0100323 <cons_intr>
}
f0100684:	c9                   	leave  
f0100685:	c3                   	ret    

f0100686 <kbd_intr>:
{
f0100686:	55                   	push   %ebp
f0100687:	89 e5                	mov    %esp,%ebp
f0100689:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f010068c:	b8 62 03 10 f0       	mov    $0xf0100362,%eax
f0100691:	e8 8d fc ff ff       	call   f0100323 <cons_intr>
}
f0100696:	c9                   	leave  
f0100697:	c3                   	ret    

f0100698 <cons_getc>:
{
f0100698:	55                   	push   %ebp
f0100699:	89 e5                	mov    %esp,%ebp
f010069b:	83 ec 08             	sub    $0x8,%esp
	serial_intr();
f010069e:	e8 c7 ff ff ff       	call   f010066a <serial_intr>
	kbd_intr();
f01006a3:	e8 de ff ff ff       	call   f0100686 <kbd_intr>
	if (cons.rpos != cons.wpos) {
f01006a8:	8b 15 20 42 34 f0    	mov    0xf0344220,%edx
	return 0;
f01006ae:	b8 00 00 00 00       	mov    $0x0,%eax
	if (cons.rpos != cons.wpos) {
f01006b3:	3b 15 24 42 34 f0    	cmp    0xf0344224,%edx
f01006b9:	74 1e                	je     f01006d9 <cons_getc+0x41>
		c = cons.buf[cons.rpos++];
f01006bb:	8d 4a 01             	lea    0x1(%edx),%ecx
f01006be:	0f b6 82 20 40 34 f0 	movzbl -0xfcbbfe0(%edx),%eax
			cons.rpos = 0;
f01006c5:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
f01006cb:	ba 00 00 00 00       	mov    $0x0,%edx
f01006d0:	0f 44 ca             	cmove  %edx,%ecx
f01006d3:	89 0d 20 42 34 f0    	mov    %ecx,0xf0344220
}
f01006d9:	c9                   	leave  
f01006da:	c3                   	ret    

f01006db <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f01006db:	55                   	push   %ebp
f01006dc:	89 e5                	mov    %esp,%ebp
f01006de:	57                   	push   %edi
f01006df:	56                   	push   %esi
f01006e0:	53                   	push   %ebx
f01006e1:	83 ec 0c             	sub    $0xc,%esp
	was = *cp;
f01006e4:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f01006eb:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f01006f2:	5a a5 
	if (*cp != 0xA55A) {
f01006f4:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f01006fb:	66 3d 5a a5          	cmp    $0xa55a,%ax
f01006ff:	0f 84 de 00 00 00    	je     f01007e3 <cons_init+0x108>
		addr_6845 = MONO_BASE;
f0100705:	c7 05 30 42 34 f0 b4 	movl   $0x3b4,0xf0344230
f010070c:	03 00 00 
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f010070f:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
	outb(addr_6845, 14);
f0100714:	8b 3d 30 42 34 f0    	mov    0xf0344230,%edi
f010071a:	b8 0e 00 00 00       	mov    $0xe,%eax
f010071f:	89 fa                	mov    %edi,%edx
f0100721:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f0100722:	8d 4f 01             	lea    0x1(%edi),%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100725:	89 ca                	mov    %ecx,%edx
f0100727:	ec                   	in     (%dx),%al
f0100728:	0f b6 c0             	movzbl %al,%eax
f010072b:	c1 e0 08             	shl    $0x8,%eax
f010072e:	89 c3                	mov    %eax,%ebx
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100730:	b8 0f 00 00 00       	mov    $0xf,%eax
f0100735:	89 fa                	mov    %edi,%edx
f0100737:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100738:	89 ca                	mov    %ecx,%edx
f010073a:	ec                   	in     (%dx),%al
	crt_buf = (uint16_t*) cp;
f010073b:	89 35 2c 42 34 f0    	mov    %esi,0xf034422c
	pos |= inb(addr_6845 + 1);
f0100741:	0f b6 c0             	movzbl %al,%eax
f0100744:	09 d8                	or     %ebx,%eax
	crt_pos = pos;
f0100746:	66 a3 28 42 34 f0    	mov    %ax,0xf0344228
	kbd_intr();
f010074c:	e8 35 ff ff ff       	call   f0100686 <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_KBD));
f0100751:	83 ec 0c             	sub    $0xc,%esp
f0100754:	0f b7 05 a8 53 12 f0 	movzwl 0xf01253a8,%eax
f010075b:	25 fd ff 00 00       	and    $0xfffd,%eax
f0100760:	50                   	push   %eax
f0100761:	e8 1c 3d 00 00       	call   f0104482 <irq_setmask_8259A>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100766:	bb 00 00 00 00       	mov    $0x0,%ebx
f010076b:	b9 fa 03 00 00       	mov    $0x3fa,%ecx
f0100770:	89 d8                	mov    %ebx,%eax
f0100772:	89 ca                	mov    %ecx,%edx
f0100774:	ee                   	out    %al,(%dx)
f0100775:	bf fb 03 00 00       	mov    $0x3fb,%edi
f010077a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f010077f:	89 fa                	mov    %edi,%edx
f0100781:	ee                   	out    %al,(%dx)
f0100782:	b8 0c 00 00 00       	mov    $0xc,%eax
f0100787:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010078c:	ee                   	out    %al,(%dx)
f010078d:	be f9 03 00 00       	mov    $0x3f9,%esi
f0100792:	89 d8                	mov    %ebx,%eax
f0100794:	89 f2                	mov    %esi,%edx
f0100796:	ee                   	out    %al,(%dx)
f0100797:	b8 03 00 00 00       	mov    $0x3,%eax
f010079c:	89 fa                	mov    %edi,%edx
f010079e:	ee                   	out    %al,(%dx)
f010079f:	ba fc 03 00 00       	mov    $0x3fc,%edx
f01007a4:	89 d8                	mov    %ebx,%eax
f01007a6:	ee                   	out    %al,(%dx)
f01007a7:	b8 01 00 00 00       	mov    $0x1,%eax
f01007ac:	89 f2                	mov    %esi,%edx
f01007ae:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01007af:	ba fd 03 00 00       	mov    $0x3fd,%edx
f01007b4:	ec                   	in     (%dx),%al
f01007b5:	89 c3                	mov    %eax,%ebx
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f01007b7:	83 c4 10             	add    $0x10,%esp
f01007ba:	3c ff                	cmp    $0xff,%al
f01007bc:	0f 95 05 34 42 34 f0 	setne  0xf0344234
f01007c3:	89 ca                	mov    %ecx,%edx
f01007c5:	ec                   	in     (%dx),%al
f01007c6:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01007cb:	ec                   	in     (%dx),%al
	if (serial_exists)
f01007cc:	80 fb ff             	cmp    $0xff,%bl
f01007cf:	75 2d                	jne    f01007fe <cons_init+0x123>
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
		cprintf("Serial port does not exist!\n");
f01007d1:	83 ec 0c             	sub    $0xc,%esp
f01007d4:	68 28 75 10 f0       	push   $0xf0107528
f01007d9:	e8 0b 3e 00 00       	call   f01045e9 <cprintf>
f01007de:	83 c4 10             	add    $0x10,%esp
}
f01007e1:	eb 3c                	jmp    f010081f <cons_init+0x144>
		*cp = was;
f01007e3:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f01007ea:	c7 05 30 42 34 f0 d4 	movl   $0x3d4,0xf0344230
f01007f1:	03 00 00 
	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f01007f4:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
f01007f9:	e9 16 ff ff ff       	jmp    f0100714 <cons_init+0x39>
		irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_SERIAL));
f01007fe:	83 ec 0c             	sub    $0xc,%esp
f0100801:	0f b7 05 a8 53 12 f0 	movzwl 0xf01253a8,%eax
f0100808:	25 ef ff 00 00       	and    $0xffef,%eax
f010080d:	50                   	push   %eax
f010080e:	e8 6f 3c 00 00       	call   f0104482 <irq_setmask_8259A>
	if (!serial_exists)
f0100813:	83 c4 10             	add    $0x10,%esp
f0100816:	80 3d 34 42 34 f0 00 	cmpb   $0x0,0xf0344234
f010081d:	74 b2                	je     f01007d1 <cons_init+0xf6>
}
f010081f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100822:	5b                   	pop    %ebx
f0100823:	5e                   	pop    %esi
f0100824:	5f                   	pop    %edi
f0100825:	5d                   	pop    %ebp
f0100826:	c3                   	ret    

f0100827 <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f0100827:	55                   	push   %ebp
f0100828:	89 e5                	mov    %esp,%ebp
f010082a:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f010082d:	8b 45 08             	mov    0x8(%ebp),%eax
f0100830:	e8 42 fc ff ff       	call   f0100477 <cons_putc>
}
f0100835:	c9                   	leave  
f0100836:	c3                   	ret    

f0100837 <getchar>:

int
getchar(void)
{
f0100837:	55                   	push   %ebp
f0100838:	89 e5                	mov    %esp,%ebp
f010083a:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f010083d:	e8 56 fe ff ff       	call   f0100698 <cons_getc>
f0100842:	85 c0                	test   %eax,%eax
f0100844:	74 f7                	je     f010083d <getchar+0x6>
		/* do nothing */;
	return c;
}
f0100846:	c9                   	leave  
f0100847:	c3                   	ret    

f0100848 <iscons>:
int
iscons(int fdnum)
{
	// used by readline
	return 1;
}
f0100848:	b8 01 00 00 00       	mov    $0x1,%eax
f010084d:	c3                   	ret    

f010084e <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f010084e:	55                   	push   %ebp
f010084f:	89 e5                	mov    %esp,%ebp
f0100851:	56                   	push   %esi
f0100852:	53                   	push   %ebx
f0100853:	bb 60 7d 10 f0       	mov    $0xf0107d60,%ebx
f0100858:	be c0 7d 10 f0       	mov    $0xf0107dc0,%esi
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f010085d:	83 ec 04             	sub    $0x4,%esp
f0100860:	ff 73 04             	pushl  0x4(%ebx)
f0100863:	ff 33                	pushl  (%ebx)
f0100865:	68 80 77 10 f0       	push   $0xf0107780
f010086a:	e8 7a 3d 00 00       	call   f01045e9 <cprintf>
f010086f:	83 c3 0c             	add    $0xc,%ebx
	for (i = 0; i < ARRAY_SIZE(commands); i++)
f0100872:	83 c4 10             	add    $0x10,%esp
f0100875:	39 f3                	cmp    %esi,%ebx
f0100877:	75 e4                	jne    f010085d <mon_help+0xf>
	return 0;
}
f0100879:	b8 00 00 00 00       	mov    $0x0,%eax
f010087e:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100881:	5b                   	pop    %ebx
f0100882:	5e                   	pop    %esi
f0100883:	5d                   	pop    %ebp
f0100884:	c3                   	ret    

f0100885 <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f0100885:	55                   	push   %ebp
f0100886:	89 e5                	mov    %esp,%ebp
f0100888:	83 ec 14             	sub    $0x14,%esp
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f010088b:	68 89 77 10 f0       	push   $0xf0107789
f0100890:	e8 54 3d 00 00       	call   f01045e9 <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f0100895:	83 c4 08             	add    $0x8,%esp
f0100898:	68 0c 00 10 00       	push   $0x10000c
f010089d:	68 14 7a 10 f0       	push   $0xf0107a14
f01008a2:	e8 42 3d 00 00       	call   f01045e9 <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f01008a7:	83 c4 0c             	add    $0xc,%esp
f01008aa:	68 0c 00 10 00       	push   $0x10000c
f01008af:	68 0c 00 10 f0       	push   $0xf010000c
f01008b4:	68 3c 7a 10 f0       	push   $0xf0107a3c
f01008b9:	e8 2b 3d 00 00       	call   f01045e9 <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f01008be:	83 c4 0c             	add    $0xc,%esp
f01008c1:	68 df 73 10 00       	push   $0x1073df
f01008c6:	68 df 73 10 f0       	push   $0xf01073df
f01008cb:	68 60 7a 10 f0       	push   $0xf0107a60
f01008d0:	e8 14 3d 00 00       	call   f01045e9 <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f01008d5:	83 c4 0c             	add    $0xc,%esp
f01008d8:	68 00 40 34 00       	push   $0x344000
f01008dd:	68 00 40 34 f0       	push   $0xf0344000
f01008e2:	68 84 7a 10 f0       	push   $0xf0107a84
f01008e7:	e8 fd 3c 00 00       	call   f01045e9 <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f01008ec:	83 c4 0c             	add    $0xc,%esp
f01008ef:	68 08 70 38 00       	push   $0x387008
f01008f4:	68 08 70 38 f0       	push   $0xf0387008
f01008f9:	68 a8 7a 10 f0       	push   $0xf0107aa8
f01008fe:	e8 e6 3c 00 00       	call   f01045e9 <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f0100903:	83 c4 08             	add    $0x8,%esp
		ROUNDUP(end - entry, 1024) / 1024);
f0100906:	b8 08 70 38 f0       	mov    $0xf0387008,%eax
f010090b:	2d 0d fc 0f f0       	sub    $0xf00ffc0d,%eax
	cprintf("Kernel executable memory footprint: %dKB\n",
f0100910:	c1 f8 0a             	sar    $0xa,%eax
f0100913:	50                   	push   %eax
f0100914:	68 cc 7a 10 f0       	push   $0xf0107acc
f0100919:	e8 cb 3c 00 00       	call   f01045e9 <cprintf>
	return 0;
}
f010091e:	b8 00 00 00 00       	mov    $0x0,%eax
f0100923:	c9                   	leave  
f0100924:	c3                   	ret    

f0100925 <do_overflow>:
    return pretaddr;
}

void
do_overflow(void)
{
f0100925:	55                   	push   %ebp
f0100926:	89 e5                	mov    %esp,%ebp
f0100928:	83 ec 14             	sub    $0x14,%esp
    cprintf("Overflow success\n");
f010092b:	68 a2 77 10 f0       	push   $0xf01077a2
f0100930:	e8 b4 3c 00 00       	call   f01045e9 <cprintf>
}
f0100935:	83 c4 10             	add    $0x10,%esp
f0100938:	c9                   	leave  
f0100939:	c3                   	ret    

f010093a <runcmd>:
#define WHITESPACE "\t\r\n "
#define MAXARGS 16

static int
runcmd(char *buf, struct Trapframe *tf)
{
f010093a:	55                   	push   %ebp
f010093b:	89 e5                	mov    %esp,%ebp
f010093d:	57                   	push   %edi
f010093e:	56                   	push   %esi
f010093f:	53                   	push   %ebx
f0100940:	83 ec 5c             	sub    $0x5c,%esp
f0100943:	89 c3                	mov    %eax,%ebx
f0100945:	89 55 a4             	mov    %edx,-0x5c(%ebp)
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
f0100948:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	argc = 0;
f010094f:	be 00 00 00 00       	mov    $0x0,%esi
f0100954:	eb 5d                	jmp    f01009b3 <runcmd+0x79>
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
f0100956:	83 ec 08             	sub    $0x8,%esp
f0100959:	0f be c0             	movsbl %al,%eax
f010095c:	50                   	push   %eax
f010095d:	68 b4 77 10 f0       	push   $0xf01077b4
f0100962:	e8 f0 5d 00 00       	call   f0106757 <strchr>
f0100967:	83 c4 10             	add    $0x10,%esp
f010096a:	85 c0                	test   %eax,%eax
f010096c:	74 0a                	je     f0100978 <runcmd+0x3e>
			*buf++ = 0;
f010096e:	c6 03 00             	movb   $0x0,(%ebx)
f0100971:	89 f7                	mov    %esi,%edi
f0100973:	8d 5b 01             	lea    0x1(%ebx),%ebx
f0100976:	eb 39                	jmp    f01009b1 <runcmd+0x77>
		if (*buf == 0)
f0100978:	0f b6 03             	movzbl (%ebx),%eax
f010097b:	84 c0                	test   %al,%al
f010097d:	74 3b                	je     f01009ba <runcmd+0x80>
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
f010097f:	83 fe 0f             	cmp    $0xf,%esi
f0100982:	0f 84 81 00 00 00    	je     f0100a09 <runcmd+0xcf>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
f0100988:	8d 7e 01             	lea    0x1(%esi),%edi
f010098b:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
		while (*buf && !strchr(WHITESPACE, *buf))
f010098f:	83 ec 08             	sub    $0x8,%esp
f0100992:	0f be c0             	movsbl %al,%eax
f0100995:	50                   	push   %eax
f0100996:	68 b4 77 10 f0       	push   $0xf01077b4
f010099b:	e8 b7 5d 00 00       	call   f0106757 <strchr>
f01009a0:	83 c4 10             	add    $0x10,%esp
f01009a3:	85 c0                	test   %eax,%eax
f01009a5:	75 0a                	jne    f01009b1 <runcmd+0x77>
			buf++;
f01009a7:	83 c3 01             	add    $0x1,%ebx
		while (*buf && !strchr(WHITESPACE, *buf))
f01009aa:	0f b6 03             	movzbl (%ebx),%eax
f01009ad:	84 c0                	test   %al,%al
f01009af:	75 de                	jne    f010098f <runcmd+0x55>
			*buf++ = 0;
f01009b1:	89 fe                	mov    %edi,%esi
		while (*buf && strchr(WHITESPACE, *buf))
f01009b3:	0f b6 03             	movzbl (%ebx),%eax
f01009b6:	84 c0                	test   %al,%al
f01009b8:	75 9c                	jne    f0100956 <runcmd+0x1c>
	}
	argv[argc] = 0;
f01009ba:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f01009c1:	00 

	// Lookup and invoke the command
	if (argc == 0)
f01009c2:	85 f6                	test   %esi,%esi
f01009c4:	74 5a                	je     f0100a20 <runcmd+0xe6>
		return 0;
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f01009c6:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (strcmp(argv[0], commands[i].name) == 0)
f01009cb:	83 ec 08             	sub    $0x8,%esp
f01009ce:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f01009d1:	ff 34 85 60 7d 10 f0 	pushl  -0xfef82a0(,%eax,4)
f01009d8:	ff 75 a8             	pushl  -0x58(%ebp)
f01009db:	e8 19 5d 00 00       	call   f01066f9 <strcmp>
f01009e0:	83 c4 10             	add    $0x10,%esp
f01009e3:	85 c0                	test   %eax,%eax
f01009e5:	74 43                	je     f0100a2a <runcmd+0xf0>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f01009e7:	83 c3 01             	add    $0x1,%ebx
f01009ea:	83 fb 08             	cmp    $0x8,%ebx
f01009ed:	75 dc                	jne    f01009cb <runcmd+0x91>
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
f01009ef:	83 ec 08             	sub    $0x8,%esp
f01009f2:	ff 75 a8             	pushl  -0x58(%ebp)
f01009f5:	68 d6 77 10 f0       	push   $0xf01077d6
f01009fa:	e8 ea 3b 00 00       	call   f01045e9 <cprintf>
	return 0;
f01009ff:	83 c4 10             	add    $0x10,%esp
f0100a02:	be 00 00 00 00       	mov    $0x0,%esi
f0100a07:	eb 17                	jmp    f0100a20 <runcmd+0xe6>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100a09:	83 ec 08             	sub    $0x8,%esp
f0100a0c:	6a 10                	push   $0x10
f0100a0e:	68 b9 77 10 f0       	push   $0xf01077b9
f0100a13:	e8 d1 3b 00 00       	call   f01045e9 <cprintf>
			return 0;
f0100a18:	83 c4 10             	add    $0x10,%esp
f0100a1b:	be 00 00 00 00       	mov    $0x0,%esi
}
f0100a20:	89 f0                	mov    %esi,%eax
f0100a22:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100a25:	5b                   	pop    %ebx
f0100a26:	5e                   	pop    %esi
f0100a27:	5f                   	pop    %edi
f0100a28:	5d                   	pop    %ebp
f0100a29:	c3                   	ret    
			return commands[i].func(argc, argv, tf);
f0100a2a:	83 ec 04             	sub    $0x4,%esp
f0100a2d:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100a30:	ff 75 a4             	pushl  -0x5c(%ebp)
f0100a33:	8d 55 a8             	lea    -0x58(%ebp),%edx
f0100a36:	52                   	push   %edx
f0100a37:	56                   	push   %esi
f0100a38:	ff 14 85 68 7d 10 f0 	call   *-0xfef8298(,%eax,4)
f0100a3f:	89 c6                	mov    %eax,%esi
f0100a41:	83 c4 10             	add    $0x10,%esp
f0100a44:	eb da                	jmp    f0100a20 <runcmd+0xe6>

f0100a46 <mon_time>:
	}
}

int
mon_time(int argc, char **argv, struct Trapframe *tf)
{
f0100a46:	55                   	push   %ebp
f0100a47:	89 e5                	mov    %esp,%ebp
f0100a49:	57                   	push   %edi
f0100a4a:	56                   	push   %esi
f0100a4b:	53                   	push   %ebx
f0100a4c:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
f0100a52:	8b 75 0c             	mov    0xc(%ebp),%esi
	uint64_t tsc_start, tsc_end;
	char str[256] = {};
f0100a55:	8d bd e8 fe ff ff    	lea    -0x118(%ebp),%edi
f0100a5b:	b9 40 00 00 00       	mov    $0x40,%ecx
f0100a60:	b8 00 00 00 00       	mov    $0x0,%eax
f0100a65:	f3 ab                	rep stos %eax,%es:(%edi)
f0100a67:	bb 60 7d 10 f0       	mov    $0xf0107d60,%ebx

 	// [command] missed
	if (argc == 1) {
f0100a6c:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
f0100a70:	74 40                	je     f0100ab2 <mon_time+0x6c>
		cprintf("Arguement missing: time [command]\n");
		return 0;
	}
	for (int i = 0; i < 4; i++) {
		if (strcmp(argv[1], commands[i].name) == 0) {
f0100a72:	8b 3b                	mov    (%ebx),%edi
f0100a74:	83 ec 08             	sub    $0x8,%esp
f0100a77:	57                   	push   %edi
f0100a78:	ff 76 04             	pushl  0x4(%esi)
f0100a7b:	e8 79 5c 00 00       	call   f01066f9 <strcmp>
f0100a80:	83 c4 10             	add    $0x10,%esp
f0100a83:	85 c0                	test   %eax,%eax
f0100a85:	74 3d                	je     f0100ac4 <mon_time+0x7e>
f0100a87:	83 c3 0c             	add    $0xc,%ebx
	for (int i = 0; i < 4; i++) {
f0100a8a:	81 fb 90 7d 10 f0    	cmp    $0xf0107d90,%ebx
f0100a90:	75 e0                	jne    f0100a72 <mon_time+0x2c>
			tsc_end = read_tsc();
			cprintf("%s cycles: %llu\n", argv[1], tsc_end - tsc_start);
			return 0;
		}
	}
	cprintf("Unknown command '%s'\n", argv[1]);
f0100a92:	83 ec 08             	sub    $0x8,%esp
f0100a95:	ff 76 04             	pushl  0x4(%esi)
f0100a98:	68 d6 77 10 f0       	push   $0xf01077d6
f0100a9d:	e8 47 3b 00 00       	call   f01045e9 <cprintf>
	return 0;
f0100aa2:	83 c4 10             	add    $0x10,%esp
}
f0100aa5:	b8 00 00 00 00       	mov    $0x0,%eax
f0100aaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100aad:	5b                   	pop    %ebx
f0100aae:	5e                   	pop    %esi
f0100aaf:	5f                   	pop    %edi
f0100ab0:	5d                   	pop    %ebp
f0100ab1:	c3                   	ret    
		cprintf("Arguement missing: time [command]\n");
f0100ab2:	83 ec 0c             	sub    $0xc,%esp
f0100ab5:	68 f8 7a 10 f0       	push   $0xf0107af8
f0100aba:	e8 2a 3b 00 00       	call   f01045e9 <cprintf>
		return 0;
f0100abf:	83 c4 10             	add    $0x10,%esp
f0100ac2:	eb e1                	jmp    f0100aa5 <mon_time+0x5f>
	asm volatile("rdtsc" : "=A" (tsc));
f0100ac4:	0f 31                	rdtsc  
f0100ac6:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
f0100acc:	89 95 e4 fe ff ff    	mov    %edx,-0x11c(%ebp)
			strncpy(str, commands[i].name, (size_t)strlen(commands[i].name));
f0100ad2:	83 ec 0c             	sub    $0xc,%esp
f0100ad5:	57                   	push   %edi
f0100ad6:	e8 3a 5b 00 00       	call   f0106615 <strlen>
f0100adb:	83 c4 0c             	add    $0xc,%esp
f0100ade:	50                   	push   %eax
f0100adf:	57                   	push   %edi
f0100ae0:	8d 9d e8 fe ff ff    	lea    -0x118(%ebp),%ebx
f0100ae6:	53                   	push   %ebx
f0100ae7:	e8 a7 5b 00 00       	call   f0106693 <strncpy>
			runcmd(str, tf);
f0100aec:	8b 55 10             	mov    0x10(%ebp),%edx
f0100aef:	89 d8                	mov    %ebx,%eax
f0100af1:	e8 44 fe ff ff       	call   f010093a <runcmd>
f0100af6:	0f 31                	rdtsc  
			cprintf("%s cycles: %llu\n", argv[1], tsc_end - tsc_start);
f0100af8:	2b 85 e0 fe ff ff    	sub    -0x120(%ebp),%eax
f0100afe:	1b 95 e4 fe ff ff    	sbb    -0x11c(%ebp),%edx
f0100b04:	52                   	push   %edx
f0100b05:	50                   	push   %eax
f0100b06:	ff 76 04             	pushl  0x4(%esi)
f0100b09:	68 ec 77 10 f0       	push   $0xf01077ec
f0100b0e:	e8 d6 3a 00 00       	call   f01045e9 <cprintf>
			return 0;
f0100b13:	83 c4 20             	add    $0x20,%esp
f0100b16:	eb 8d                	jmp    f0100aa5 <mon_time+0x5f>

f0100b18 <mon_dumpva>:
	}
	return 0;
}

int mon_dumpva(int argc, char **argv, struct Trapframe *tf)
{
f0100b18:	55                   	push   %ebp
f0100b19:	89 e5                	mov    %esp,%ebp
f0100b1b:	57                   	push   %edi
f0100b1c:	56                   	push   %esi
f0100b1d:	53                   	push   %ebx
f0100b1e:	83 ec 1c             	sub    $0x1c,%esp
f0100b21:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if(argc != 3){
f0100b24:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
f0100b28:	74 1d                	je     f0100b47 <mon_dumpva+0x2f>
		cprintf("usage: dumpva va size\n");
f0100b2a:	83 ec 0c             	sub    $0xc,%esp
f0100b2d:	68 fd 77 10 f0       	push   $0xf01077fd
f0100b32:	e8 b2 3a 00 00       	call   f01045e9 <cprintf>
		return 0;
f0100b37:	83 c4 10             	add    $0x10,%esp
			cprintf("\n%08p: ", va0+i+1);
		}
	}
	cprintf("\n");
	return 0;
}
f0100b3a:	b8 00 00 00 00       	mov    $0x0,%eax
f0100b3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100b42:	5b                   	pop    %ebx
f0100b43:	5e                   	pop    %esi
f0100b44:	5f                   	pop    %edi
f0100b45:	5d                   	pop    %ebp
f0100b46:	c3                   	ret    
	va0 = (uintptr_t)strtol(argv[1], NULL, 0);
f0100b47:	83 ec 04             	sub    $0x4,%esp
f0100b4a:	6a 00                	push   $0x0
f0100b4c:	6a 00                	push   $0x0
f0100b4e:	ff 73 04             	pushl  0x4(%ebx)
f0100b51:	e8 54 5d 00 00       	call   f01068aa <strtol>
f0100b56:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	size = (size_t)strtol(argv[2], NULL, 0);
f0100b59:	83 c4 0c             	add    $0xc,%esp
f0100b5c:	6a 00                	push   $0x0
f0100b5e:	6a 00                	push   $0x0
f0100b60:	ff 73 08             	pushl  0x8(%ebx)
f0100b63:	e8 42 5d 00 00       	call   f01068aa <strtol>
f0100b68:	89 c7                	mov    %eax,%edi
	if(size<0 || size>4096){
f0100b6a:	83 c4 10             	add    $0x10,%esp
f0100b6d:	3d 00 10 00 00       	cmp    $0x1000,%eax
f0100b72:	77 64                	ja     f0100bd8 <mon_dumpva+0xc0>
	va1 = va0 + size;
f0100b74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100b77:	8d 34 38             	lea    (%eax,%edi,1),%esi
	pte0 = pgdir_walk_large(kern_pgdir, (void *)va0, 0);
f0100b7a:	83 ec 04             	sub    $0x4,%esp
f0100b7d:	6a 00                	push   $0x0
f0100b7f:	50                   	push   %eax
f0100b80:	ff 35 8c 5e 34 f0    	pushl  0xf0345e8c
f0100b86:	e8 db 0f 00 00       	call   f0101b66 <pgdir_walk_large>
f0100b8b:	89 c3                	mov    %eax,%ebx
	if(pte0 && ((*pte0)&PTE_P) && ((*pte0)&PTE_PS))
f0100b8d:	83 c4 10             	add    $0x10,%esp
f0100b90:	85 c0                	test   %eax,%eax
f0100b92:	0f 84 44 01 00 00    	je     f0100cdc <mon_dumpva+0x1c4>
f0100b98:	8b 00                	mov    (%eax),%eax
f0100b9a:	25 81 00 00 00       	and    $0x81,%eax
f0100b9f:	3d 81 00 00 00       	cmp    $0x81,%eax
f0100ba4:	74 47                	je     f0100bed <mon_dumpva+0xd5>
		va0 = ROUNDDOWN(va0, PGSIZE);
f0100ba6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100ba9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100bae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	pte1 = pgdir_walk_large(kern_pgdir, (void *)va1, 0);
f0100bb1:	83 ec 04             	sub    $0x4,%esp
f0100bb4:	6a 00                	push   $0x0
f0100bb6:	56                   	push   %esi
f0100bb7:	ff 35 8c 5e 34 f0    	pushl  0xf0345e8c
f0100bbd:	e8 a4 0f 00 00       	call   f0101b66 <pgdir_walk_large>
f0100bc2:	83 c4 10             	add    $0x10,%esp
	if(pte0 && ((*pte0)&PTE_P) && ((*pte0)&PTE_PS))
f0100bc5:	8b 03                	mov    (%ebx),%eax
f0100bc7:	25 81 00 00 00       	and    $0x81,%eax
f0100bcc:	3d 81 00 00 00       	cmp    $0x81,%eax
f0100bd1:	74 3b                	je     f0100c0e <mon_dumpva+0xf6>
	for(va=va0; va<va1; va++){
f0100bd3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0100bd6:	eb 4b                	jmp    f0100c23 <mon_dumpva+0x10b>
		cprintf("size out of range: [0, 4096]\n");
f0100bd8:	83 ec 0c             	sub    $0xc,%esp
f0100bdb:	68 14 78 10 f0       	push   $0xf0107814
f0100be0:	e8 04 3a 00 00       	call   f01045e9 <cprintf>
		return 0;
f0100be5:	83 c4 10             	add    $0x10,%esp
f0100be8:	e9 4d ff ff ff       	jmp    f0100b3a <mon_dumpva+0x22>
		va0 = ROUNDDOWN(va0, PTSIZE);
f0100bed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100bf0:	25 00 00 c0 ff       	and    $0xffc00000,%eax
f0100bf5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	pte1 = pgdir_walk_large(kern_pgdir, (void *)va1, 0);
f0100bf8:	83 ec 04             	sub    $0x4,%esp
f0100bfb:	6a 00                	push   $0x0
f0100bfd:	56                   	push   %esi
f0100bfe:	ff 35 8c 5e 34 f0    	pushl  0xf0345e8c
f0100c04:	e8 5d 0f 00 00       	call   f0101b66 <pgdir_walk_large>
f0100c09:	83 c4 10             	add    $0x10,%esp
f0100c0c:	eb b7                	jmp    f0100bc5 <mon_dumpva+0xad>
		va0 = ROUNDUP(va0, PTSIZE);
f0100c0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100c11:	05 ff ff 3f 00       	add    $0x3fffff,%eax
f0100c16:	25 00 00 c0 ff       	and    $0xffc00000,%eax
f0100c1b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0100c1e:	eb b3                	jmp    f0100bd3 <mon_dumpva+0xbb>
	for(va=va0; va<va1; va++){
f0100c20:	83 c3 01             	add    $0x1,%ebx
f0100c23:	39 f3                	cmp    %esi,%ebx
f0100c25:	73 36                	jae    f0100c5d <mon_dumpva+0x145>
		pte = pgdir_walk_large(kern_pgdir, (void *)va, 0);
f0100c27:	83 ec 04             	sub    $0x4,%esp
f0100c2a:	6a 00                	push   $0x0
f0100c2c:	53                   	push   %ebx
f0100c2d:	ff 35 8c 5e 34 f0    	pushl  0xf0345e8c
f0100c33:	e8 2e 0f 00 00       	call   f0101b66 <pgdir_walk_large>
		if(!(pte && ((*pte)&PTE_P))){
f0100c38:	83 c4 10             	add    $0x10,%esp
f0100c3b:	85 c0                	test   %eax,%eax
f0100c3d:	74 05                	je     f0100c44 <mon_dumpva+0x12c>
f0100c3f:	f6 00 01             	testb  $0x1,(%eax)
f0100c42:	75 dc                	jne    f0100c20 <mon_dumpva+0x108>
			cprintf("%08p-%08p not exists or not mapped\n", va, va+size);
f0100c44:	83 ec 04             	sub    $0x4,%esp
f0100c47:	01 df                	add    %ebx,%edi
f0100c49:	57                   	push   %edi
f0100c4a:	53                   	push   %ebx
f0100c4b:	68 1c 7b 10 f0       	push   $0xf0107b1c
f0100c50:	e8 94 39 00 00       	call   f01045e9 <cprintf>
			return 0;
f0100c55:	83 c4 10             	add    $0x10,%esp
f0100c58:	e9 dd fe ff ff       	jmp    f0100b3a <mon_dumpva+0x22>
	cprintf("%08p: ", va0);
f0100c5d:	83 ec 08             	sub    $0x8,%esp
f0100c60:	ff 75 e4             	pushl  -0x1c(%ebp)
f0100c63:	68 39 78 10 f0       	push   $0xf0107839
f0100c68:	e8 7c 39 00 00       	call   f01045e9 <cprintf>
	for(i=0; i<size; i++){
f0100c6d:	83 c4 10             	add    $0x10,%esp
f0100c70:	bb 00 00 00 00       	mov    $0x0,%ebx
		if((i+1)%10 == 0 && (i+1)<size){
f0100c75:	be cd cc cc cc       	mov    $0xcccccccd,%esi
	for(i=0; i<size; i++){
f0100c7a:	eb 16                	jmp    f0100c92 <mon_dumpva+0x17a>
			cprintf("\n%08p: ", va0+i+1);
f0100c7c:	83 ec 08             	sub    $0x8,%esp
f0100c7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100c82:	01 d8                	add    %ebx,%eax
f0100c84:	50                   	push   %eax
f0100c85:	68 38 78 10 f0       	push   $0xf0107838
f0100c8a:	e8 5a 39 00 00       	call   f01045e9 <cprintf>
f0100c8f:	83 c4 10             	add    $0x10,%esp
	for(i=0; i<size; i++){
f0100c92:	39 fb                	cmp    %edi,%ebx
f0100c94:	74 31                	je     f0100cc7 <mon_dumpva+0x1af>
		cprintf("%02x ", *(unsigned char*)(va0+i));
f0100c96:	83 ec 08             	sub    $0x8,%esp
f0100c99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100c9c:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
f0100ca0:	50                   	push   %eax
f0100ca1:	68 32 78 10 f0       	push   $0xf0107832
f0100ca6:	e8 3e 39 00 00       	call   f01045e9 <cprintf>
		if((i+1)%10 == 0 && (i+1)<size){
f0100cab:	83 c3 01             	add    $0x1,%ebx
f0100cae:	89 d8                	mov    %ebx,%eax
f0100cb0:	f7 e6                	mul    %esi
f0100cb2:	c1 ea 03             	shr    $0x3,%edx
f0100cb5:	8d 04 92             	lea    (%edx,%edx,4),%eax
f0100cb8:	01 c0                	add    %eax,%eax
f0100cba:	83 c4 10             	add    $0x10,%esp
f0100cbd:	39 c3                	cmp    %eax,%ebx
f0100cbf:	75 d1                	jne    f0100c92 <mon_dumpva+0x17a>
f0100cc1:	39 fb                	cmp    %edi,%ebx
f0100cc3:	73 cd                	jae    f0100c92 <mon_dumpva+0x17a>
f0100cc5:	eb b5                	jmp    f0100c7c <mon_dumpva+0x164>
	cprintf("\n");
f0100cc7:	83 ec 0c             	sub    $0xc,%esp
f0100cca:	68 33 8b 10 f0       	push   $0xf0108b33
f0100ccf:	e8 15 39 00 00       	call   f01045e9 <cprintf>
	return 0;
f0100cd4:	83 c4 10             	add    $0x10,%esp
f0100cd7:	e9 5e fe ff ff       	jmp    f0100b3a <mon_dumpva+0x22>
		va0 = ROUNDDOWN(va0, PGSIZE);
f0100cdc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100cdf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100ce4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	pte1 = pgdir_walk_large(kern_pgdir, (void *)va1, 0);
f0100ce7:	83 ec 04             	sub    $0x4,%esp
f0100cea:	6a 00                	push   $0x0
f0100cec:	56                   	push   %esi
f0100ced:	ff 35 8c 5e 34 f0    	pushl  0xf0345e8c
f0100cf3:	e8 6e 0e 00 00       	call   f0101b66 <pgdir_walk_large>
f0100cf8:	83 c4 10             	add    $0x10,%esp
f0100cfb:	e9 d3 fe ff ff       	jmp    f0100bd3 <mon_dumpva+0xbb>

f0100d00 <mon_setperm>:
int mon_setperm(int argc, char **argv, struct Trapframe *tf){
f0100d00:	55                   	push   %ebp
f0100d01:	89 e5                	mov    %esp,%ebp
f0100d03:	57                   	push   %edi
f0100d04:	56                   	push   %esi
f0100d05:	53                   	push   %ebx
f0100d06:	83 ec 1c             	sub    $0x1c,%esp
	if(argc <= 2){
f0100d09:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
f0100d0d:	7e 44                	jle    f0100d53 <mon_setperm+0x53>
	va = (uintptr_t)strtol(argv[1], NULL, 0);
f0100d0f:	83 ec 04             	sub    $0x4,%esp
f0100d12:	6a 00                	push   $0x0
f0100d14:	6a 00                	push   $0x0
f0100d16:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100d19:	ff 70 04             	pushl  0x4(%eax)
f0100d1c:	e8 89 5b 00 00       	call   f01068aa <strtol>
f0100d21:	89 c7                	mov    %eax,%edi
	pte = pgdir_walk(kern_pgdir, (void *)va, false);
f0100d23:	83 c4 0c             	add    $0xc,%esp
f0100d26:	6a 00                	push   $0x0
f0100d28:	50                   	push   %eax
f0100d29:	ff 35 8c 5e 34 f0    	pushl  0xf0345e8c
f0100d2f:	e8 cf 0c 00 00       	call   f0101a03 <pgdir_walk>
f0100d34:	89 c6                	mov    %eax,%esi
	if(!pte || !((*pte)&PTE_P)){
f0100d36:	83 c4 10             	add    $0x10,%esp
f0100d39:	85 c0                	test   %eax,%eax
f0100d3b:	74 33                	je     f0100d70 <mon_setperm+0x70>
f0100d3d:	f6 00 01             	testb  $0x1,(%eax)
f0100d40:	74 2e                	je     f0100d70 <mon_setperm+0x70>
f0100d42:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100d45:	8d 58 08             	lea    0x8(%eax),%ebx
f0100d48:	8b 55 08             	mov    0x8(%ebp),%edx
f0100d4b:	8d 04 90             	lea    (%eax,%edx,4),%eax
f0100d4e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0100d51:	eb 66                	jmp    f0100db9 <mon_setperm+0xb9>
		cprintf("usage: setpageperm va perm0 {perm1}\n");
f0100d53:	83 ec 0c             	sub    $0xc,%esp
f0100d56:	68 40 7b 10 f0       	push   $0xf0107b40
f0100d5b:	e8 89 38 00 00       	call   f01045e9 <cprintf>
		return 0;
f0100d60:	83 c4 10             	add    $0x10,%esp
}
f0100d63:	b8 00 00 00 00       	mov    $0x0,%eax
f0100d68:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100d6b:	5b                   	pop    %ebx
f0100d6c:	5e                   	pop    %esi
f0100d6d:	5f                   	pop    %edi
f0100d6e:	5d                   	pop    %ebp
f0100d6f:	c3                   	ret    
		cprintf("%08p not exists or not mapped\n", va);
f0100d70:	83 ec 08             	sub    $0x8,%esp
f0100d73:	57                   	push   %edi
f0100d74:	68 68 7b 10 f0       	push   $0xf0107b68
f0100d79:	e8 6b 38 00 00       	call   f01045e9 <cprintf>
		return 0;
f0100d7e:	83 c4 10             	add    $0x10,%esp
f0100d81:	eb e0                	jmp    f0100d63 <mon_setperm+0x63>
f0100d83:	3c 6b                	cmp    $0x6b,%al
f0100d85:	75 71                	jne    f0100df8 <mon_setperm+0xf8>
				*pte = (*pte) & ~PTE_U;
f0100d87:	83 26 fb             	andl   $0xfffffffb,(%esi)
				cprintf("set page %08p perm to ~PTE_U\n", va);
f0100d8a:	83 ec 08             	sub    $0x8,%esp
f0100d8d:	57                   	push   %edi
f0100d8e:	68 98 78 10 f0       	push   $0xf0107898
f0100d93:	e8 51 38 00 00       	call   f01045e9 <cprintf>
				break;
f0100d98:	83 c4 10             	add    $0x10,%esp
f0100d9b:	eb 14                	jmp    f0100db1 <mon_setperm+0xb1>
				*pte = (*pte) & ~PTE_W;
f0100d9d:	83 26 fd             	andl   $0xfffffffd,(%esi)
				cprintf("set page %08p perm to ~PTE_W\n", va);
f0100da0:	83 ec 08             	sub    $0x8,%esp
f0100da3:	57                   	push   %edi
f0100da4:	68 40 78 10 f0       	push   $0xf0107840
f0100da9:	e8 3b 38 00 00       	call   f01045e9 <cprintf>
				break;
f0100dae:	83 c4 10             	add    $0x10,%esp
f0100db1:	83 c3 04             	add    $0x4,%ebx
	for(i=2; i<argc; i++){
f0100db4:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f0100db7:	74 aa                	je     f0100d63 <mon_setperm+0x63>
		perm = argv[i][0];
f0100db9:	8b 03                	mov    (%ebx),%eax
f0100dbb:	0f b6 00             	movzbl (%eax),%eax
f0100dbe:	3c 72                	cmp    $0x72,%al
f0100dc0:	74 db                	je     f0100d9d <mon_setperm+0x9d>
f0100dc2:	7e bf                	jle    f0100d83 <mon_setperm+0x83>
f0100dc4:	3c 75                	cmp    $0x75,%al
f0100dc6:	74 1a                	je     f0100de2 <mon_setperm+0xe2>
f0100dc8:	3c 77                	cmp    $0x77,%al
f0100dca:	75 2c                	jne    f0100df8 <mon_setperm+0xf8>
				*pte = (*pte) | PTE_W;
f0100dcc:	83 0e 02             	orl    $0x2,(%esi)
				cprintf("set page %08p perm to PTE_W\n", va);
f0100dcf:	83 ec 08             	sub    $0x8,%esp
f0100dd2:	57                   	push   %edi
f0100dd3:	68 5e 78 10 f0       	push   $0xf010785e
f0100dd8:	e8 0c 38 00 00       	call   f01045e9 <cprintf>
				break;
f0100ddd:	83 c4 10             	add    $0x10,%esp
f0100de0:	eb cf                	jmp    f0100db1 <mon_setperm+0xb1>
				*pte = (*pte) | PTE_U;
f0100de2:	83 0e 04             	orl    $0x4,(%esi)
				cprintf("set page %08p perm to PTE_U\n", va);
f0100de5:	83 ec 08             	sub    $0x8,%esp
f0100de8:	57                   	push   %edi
f0100de9:	68 7b 78 10 f0       	push   $0xf010787b
f0100dee:	e8 f6 37 00 00       	call   f01045e9 <cprintf>
				break;
f0100df3:	83 c4 10             	add    $0x10,%esp
f0100df6:	eb b9                	jmp    f0100db1 <mon_setperm+0xb1>
				cprintf("useage: u(user) k(kernel) r(R/-) W(R/W)\n");
f0100df8:	83 ec 0c             	sub    $0xc,%esp
f0100dfb:	68 88 7b 10 f0       	push   $0xf0107b88
f0100e00:	e8 e4 37 00 00       	call   f01045e9 <cprintf>
				break;
f0100e05:	83 c4 10             	add    $0x10,%esp
f0100e08:	eb a7                	jmp    f0100db1 <mon_setperm+0xb1>

f0100e0a <mon_dumppa>:

int mon_dumppa(int argc, char **argv, struct Trapframe *tf)
{
f0100e0a:	55                   	push   %ebp
f0100e0b:	89 e5                	mov    %esp,%ebp
f0100e0d:	57                   	push   %edi
f0100e0e:	56                   	push   %esi
f0100e0f:	53                   	push   %ebx
f0100e10:	83 ec 1c             	sub    $0x1c,%esp
f0100e13:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if(argc != 3){
f0100e16:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
f0100e1a:	74 1d                	je     f0100e39 <mon_dumppa+0x2f>
		cprintf("usage: dumppa pa size\n");
f0100e1c:	83 ec 0c             	sub    $0xc,%esp
f0100e1f:	68 b6 78 10 f0       	push   $0xf01078b6
f0100e24:	e8 c0 37 00 00       	call   f01045e9 <cprintf>
		return 0;
f0100e29:	83 c4 10             	add    $0x10,%esp
			cprintf("\n%08p: ", pa+i+1);
		}
	}
	cprintf("\n");
	return 0;
}
f0100e2c:	b8 00 00 00 00       	mov    $0x0,%eax
f0100e31:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100e34:	5b                   	pop    %ebx
f0100e35:	5e                   	pop    %esi
f0100e36:	5f                   	pop    %edi
f0100e37:	5d                   	pop    %ebp
f0100e38:	c3                   	ret    
	pa = (physaddr_t)strtol(argv[1], NULL, 0);
f0100e39:	83 ec 04             	sub    $0x4,%esp
f0100e3c:	6a 00                	push   $0x0
f0100e3e:	6a 00                	push   $0x0
f0100e40:	ff 73 04             	pushl  0x4(%ebx)
f0100e43:	e8 62 5a 00 00       	call   f01068aa <strtol>
f0100e48:	89 45 e0             	mov    %eax,-0x20(%ebp)
	size = (size_t)strtol(argv[2], NULL, 0);
f0100e4b:	83 c4 0c             	add    $0xc,%esp
f0100e4e:	6a 00                	push   $0x0
f0100e50:	6a 00                	push   $0x0
f0100e52:	ff 73 08             	pushl  0x8(%ebx)
f0100e55:	e8 50 5a 00 00       	call   f01068aa <strtol>
f0100e5a:	89 c7                	mov    %eax,%edi
	if(size<0 || size>4096){
f0100e5c:	83 c4 10             	add    $0x10,%esp
f0100e5f:	3d 00 10 00 00       	cmp    $0x1000,%eax
f0100e64:	77 28                	ja     f0100e8e <mon_dumppa+0x84>
	if(pa >= npages*PGSIZE || pa+size >= npages*PGSIZE || pa<0 || pa+size<0){
f0100e66:	a1 88 5e 34 f0       	mov    0xf0345e88,%eax
f0100e6b:	c1 e0 0c             	shl    $0xc,%eax
f0100e6e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0100e71:	39 c8                	cmp    %ecx,%eax
f0100e73:	76 07                	jbe    f0100e7c <mon_dumppa+0x72>
f0100e75:	8d 14 39             	lea    (%ecx,%edi,1),%edx
f0100e78:	39 d0                	cmp    %edx,%eax
f0100e7a:	77 24                	ja     f0100ea0 <mon_dumppa+0x96>
		cprintf("size out of range: [0, 4096]\n");
f0100e7c:	83 ec 0c             	sub    $0xc,%esp
f0100e7f:	68 14 78 10 f0       	push   $0xf0107814
f0100e84:	e8 60 37 00 00       	call   f01045e9 <cprintf>
		return 0;
f0100e89:	83 c4 10             	add    $0x10,%esp
f0100e8c:	eb 9e                	jmp    f0100e2c <mon_dumppa+0x22>
		cprintf("size out of range: [0, 4096]\n");
f0100e8e:	83 ec 0c             	sub    $0xc,%esp
f0100e91:	68 14 78 10 f0       	push   $0xf0107814
f0100e96:	e8 4e 37 00 00       	call   f01045e9 <cprintf>
		return 0;
f0100e9b:	83 c4 10             	add    $0x10,%esp
f0100e9e:	eb 8c                	jmp    f0100e2c <mon_dumppa+0x22>
	cprintf("%08p: ", pa);
f0100ea0:	83 ec 08             	sub    $0x8,%esp
f0100ea3:	8b 75 e0             	mov    -0x20(%ebp),%esi
f0100ea6:	56                   	push   %esi
f0100ea7:	68 39 78 10 f0       	push   $0xf0107839
f0100eac:	e8 38 37 00 00       	call   f01045e9 <cprintf>
	if (PGNUM(pa) >= npages)
f0100eb1:	89 f1                	mov    %esi,%ecx
f0100eb3:	c1 e9 0c             	shr    $0xc,%ecx
f0100eb6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
f0100eb9:	8d b6 00 00 00 f0    	lea    -0x10000000(%esi),%esi
	for(i=0; i<size; i++){
f0100ebf:	83 c4 10             	add    $0x10,%esp
f0100ec2:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100ec7:	eb 31                	jmp    f0100efa <mon_dumppa+0xf0>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100ec9:	ff 75 e0             	pushl  -0x20(%ebp)
f0100ecc:	68 54 74 10 f0       	push   $0xf0107454
f0100ed1:	68 cf 01 00 00       	push   $0x1cf
f0100ed6:	68 cd 78 10 f0       	push   $0xf01078cd
f0100edb:	e8 69 f1 ff ff       	call   f0100049 <_panic>
			cprintf("\n%08p: ", pa+i+1);
f0100ee0:	83 ec 08             	sub    $0x8,%esp
f0100ee3:	8d 86 01 00 00 10    	lea    0x10000001(%esi),%eax
f0100ee9:	50                   	push   %eax
f0100eea:	68 38 78 10 f0       	push   $0xf0107838
f0100eef:	e8 f5 36 00 00       	call   f01045e9 <cprintf>
f0100ef4:	83 c4 10             	add    $0x10,%esp
f0100ef7:	83 c6 01             	add    $0x1,%esi
	for(i=0; i<size; i++){
f0100efa:	39 fb                	cmp    %edi,%ebx
f0100efc:	74 3b                	je     f0100f39 <mon_dumppa+0x12f>
	if (PGNUM(pa) >= npages)
f0100efe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100f01:	3b 05 88 5e 34 f0    	cmp    0xf0345e88,%eax
f0100f07:	73 c0                	jae    f0100ec9 <mon_dumppa+0xbf>
		cprintf("%02x ", *((unsigned char*)KADDR(pa)+i));
f0100f09:	83 ec 08             	sub    $0x8,%esp
f0100f0c:	0f b6 06             	movzbl (%esi),%eax
f0100f0f:	50                   	push   %eax
f0100f10:	68 32 78 10 f0       	push   $0xf0107832
f0100f15:	e8 cf 36 00 00       	call   f01045e9 <cprintf>
		if((i+1)%10==0 && (i+1)<size){
f0100f1a:	83 c3 01             	add    $0x1,%ebx
f0100f1d:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
f0100f22:	f7 e3                	mul    %ebx
f0100f24:	c1 ea 03             	shr    $0x3,%edx
f0100f27:	8d 04 92             	lea    (%edx,%edx,4),%eax
f0100f2a:	01 c0                	add    %eax,%eax
f0100f2c:	83 c4 10             	add    $0x10,%esp
f0100f2f:	39 c3                	cmp    %eax,%ebx
f0100f31:	75 c4                	jne    f0100ef7 <mon_dumppa+0xed>
f0100f33:	39 fb                	cmp    %edi,%ebx
f0100f35:	73 c0                	jae    f0100ef7 <mon_dumppa+0xed>
f0100f37:	eb a7                	jmp    f0100ee0 <mon_dumppa+0xd6>
	cprintf("\n");
f0100f39:	83 ec 0c             	sub    $0xc,%esp
f0100f3c:	68 33 8b 10 f0       	push   $0xf0108b33
f0100f41:	e8 a3 36 00 00       	call   f01045e9 <cprintf>
	return 0;
f0100f46:	83 c4 10             	add    $0x10,%esp
f0100f49:	e9 de fe ff ff       	jmp    f0100e2c <mon_dumppa+0x22>

f0100f4e <start_overflow>:
{
f0100f4e:	55                   	push   %ebp
f0100f4f:	89 e5                	mov    %esp,%ebp
f0100f51:	57                   	push   %edi
f0100f52:	56                   	push   %esi
f0100f53:	53                   	push   %ebx
f0100f54:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
    char str[256] = {};
f0100f5a:	8d bd e8 fe ff ff    	lea    -0x118(%ebp),%edi
f0100f60:	b9 40 00 00 00       	mov    $0x40,%ecx
f0100f65:	b8 00 00 00 00       	mov    $0x0,%eax
f0100f6a:	f3 ab                	rep stos %eax,%es:(%edi)
    __asm __volatile("leal 4(%%ebp), %0" : "=r" (pretaddr)); 
f0100f6c:	8d 45 04             	lea    0x4(%ebp),%eax
f0100f6f:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)
	uint32_t int_pret = *(uint32_t *)pret_addr;
f0100f75:	8b 10                	mov    (%eax),%edx
f0100f77:	89 95 e0 fe ff ff    	mov    %edx,-0x120(%ebp)
	int over_addr = (int)do_overflow;
f0100f7d:	ba 25 09 10 f0       	mov    $0xf0100925,%edx
f0100f82:	8d 58 04             	lea    0x4(%eax),%ebx
f0100f85:	89 c6                	mov    %eax,%esi
		memset(str, ' ', 256);
f0100f87:	8d bd e8 fe ff ff    	lea    -0x118(%ebp),%edi
f0100f8d:	89 9d e4 fe ff ff    	mov    %ebx,-0x11c(%ebp)
f0100f93:	89 d3                	mov    %edx,%ebx
f0100f95:	83 ec 04             	sub    $0x4,%esp
f0100f98:	68 00 01 00 00       	push   $0x100
f0100f9d:	6a 20                	push   $0x20
f0100f9f:	57                   	push   %edi
f0100fa0:	e8 ef 57 00 00       	call   f0106794 <memset>
		memset(str+(int)(over_addr&0xff), 0, 8);
f0100fa5:	83 c4 0c             	add    $0xc,%esp
f0100fa8:	6a 08                	push   $0x8
f0100faa:	6a 00                	push   $0x0
f0100fac:	0f b6 c3             	movzbl %bl,%eax
f0100faf:	01 f8                	add    %edi,%eax
f0100fb1:	50                   	push   %eax
f0100fb2:	e8 dd 57 00 00       	call   f0106794 <memset>
		cprintf("%s%n", str, pret_addr + i);
f0100fb7:	83 c4 0c             	add    $0xc,%esp
f0100fba:	56                   	push   %esi
f0100fbb:	57                   	push   %edi
f0100fbc:	68 b3 74 10 f0       	push   $0xf01074b3
f0100fc1:	e8 23 36 00 00       	call   f01045e9 <cprintf>
		over_addr = over_addr >> 8;
f0100fc6:	c1 fb 08             	sar    $0x8,%ebx
f0100fc9:	83 c6 01             	add    $0x1,%esi
	for (int i = 0; i < 4; ++i) {
f0100fcc:	83 c4 10             	add    $0x10,%esp
f0100fcf:	39 b5 e4 fe ff ff    	cmp    %esi,-0x11c(%ebp)
f0100fd5:	75 be                	jne    f0100f95 <start_overflow+0x47>
f0100fd7:	8b 9d e4 fe ff ff    	mov    -0x11c(%ebp),%ebx
f0100fdd:	8b bd dc fe ff ff    	mov    -0x124(%ebp),%edi
f0100fe3:	83 c7 08             	add    $0x8,%edi
		memset(str, ' ', 256);
f0100fe6:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
f0100fec:	89 bd e4 fe ff ff    	mov    %edi,-0x11c(%ebp)
f0100ff2:	8b bd e0 fe ff ff    	mov    -0x120(%ebp),%edi
f0100ff8:	83 ec 04             	sub    $0x4,%esp
f0100ffb:	68 00 01 00 00       	push   $0x100
f0101000:	6a 20                	push   $0x20
f0101002:	56                   	push   %esi
f0101003:	e8 8c 57 00 00       	call   f0106794 <memset>
		memset(str+(int)(int_pret&0xff), 0, 8);
f0101008:	83 c4 0c             	add    $0xc,%esp
f010100b:	6a 08                	push   $0x8
f010100d:	6a 00                	push   $0x0
f010100f:	89 f8                	mov    %edi,%eax
f0101011:	0f b6 c0             	movzbl %al,%eax
f0101014:	01 f0                	add    %esi,%eax
f0101016:	50                   	push   %eax
f0101017:	e8 78 57 00 00       	call   f0106794 <memset>
		cprintf("%s%n", str, pret_addr + i);
f010101c:	83 c4 0c             	add    $0xc,%esp
f010101f:	53                   	push   %ebx
f0101020:	56                   	push   %esi
f0101021:	68 b3 74 10 f0       	push   $0xf01074b3
f0101026:	e8 be 35 00 00       	call   f01045e9 <cprintf>
		int_pret = int_pret >> 8;
f010102b:	c1 ef 08             	shr    $0x8,%edi
f010102e:	83 c3 01             	add    $0x1,%ebx
	for (int i = 4; i < 8; ++i) {
f0101031:	83 c4 10             	add    $0x10,%esp
f0101034:	39 9d e4 fe ff ff    	cmp    %ebx,-0x11c(%ebp)
f010103a:	75 bc                	jne    f0100ff8 <start_overflow+0xaa>
}
f010103c:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010103f:	5b                   	pop    %ebx
f0101040:	5e                   	pop    %esi
f0101041:	5f                   	pop    %edi
f0101042:	5d                   	pop    %ebp
f0101043:	c3                   	ret    

f0101044 <mon_backtrace>:
{
f0101044:	55                   	push   %ebp
f0101045:	89 e5                	mov    %esp,%ebp
f0101047:	56                   	push   %esi
f0101048:	53                   	push   %ebx
f0101049:	83 ec 20             	sub    $0x20,%esp
        start_overflow();
f010104c:	e8 fd fe ff ff       	call   f0100f4e <start_overflow>
	cprintf("Stack backtrace\n");
f0101051:	83 ec 0c             	sub    $0xc,%esp
f0101054:	68 dc 78 10 f0       	push   $0xf01078dc
f0101059:	e8 8b 35 00 00       	call   f01045e9 <cprintf>
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f010105e:	89 eb                	mov    %ebp,%ebx
	while(ebp!=NULL){
f0101060:	83 c4 10             	add    $0x10,%esp
		if(debuginfo_eip((uintptr_t)(*(ebp+1)), &info)>=0)
f0101063:	8d 75 e0             	lea    -0x20(%ebp),%esi
	while(ebp!=NULL){
f0101066:	eb 02                	jmp    f010106a <mon_backtrace+0x26>
	        ebp = (uint32_t *) (*ebp);
f0101068:	8b 1b                	mov    (%ebx),%ebx
	while(ebp!=NULL){
f010106a:	85 db                	test   %ebx,%ebx
f010106c:	74 55                	je     f01010c3 <mon_backtrace+0x7f>
		cprintf("  eip %08x ebp %08x args %08x %08x %08x %08x %08x\n", 
f010106e:	ff 73 18             	pushl  0x18(%ebx)
f0101071:	ff 73 14             	pushl  0x14(%ebx)
f0101074:	ff 73 10             	pushl  0x10(%ebx)
f0101077:	ff 73 0c             	pushl  0xc(%ebx)
f010107a:	ff 73 08             	pushl  0x8(%ebx)
f010107d:	53                   	push   %ebx
f010107e:	ff 73 04             	pushl  0x4(%ebx)
f0101081:	68 b4 7b 10 f0       	push   $0xf0107bb4
f0101086:	e8 5e 35 00 00       	call   f01045e9 <cprintf>
		if(debuginfo_eip((uintptr_t)(*(ebp+1)), &info)>=0)
f010108b:	83 c4 18             	add    $0x18,%esp
f010108e:	56                   	push   %esi
f010108f:	ff 73 04             	pushl  0x4(%ebx)
f0101092:	e8 c7 4a 00 00       	call   f0105b5e <debuginfo_eip>
f0101097:	83 c4 10             	add    $0x10,%esp
f010109a:	85 c0                	test   %eax,%eax
f010109c:	78 ca                	js     f0101068 <mon_backtrace+0x24>
	        	cprintf("        %s:%u %.*s+%u\n",
f010109e:	83 ec 08             	sub    $0x8,%esp
f01010a1:	8b 43 04             	mov    0x4(%ebx),%eax
f01010a4:	2b 45 f0             	sub    -0x10(%ebp),%eax
f01010a7:	50                   	push   %eax
f01010a8:	ff 75 e8             	pushl  -0x18(%ebp)
f01010ab:	ff 75 ec             	pushl  -0x14(%ebp)
f01010ae:	ff 75 e4             	pushl  -0x1c(%ebp)
f01010b1:	ff 75 e0             	pushl  -0x20(%ebp)
f01010b4:	68 ed 78 10 f0       	push   $0xf01078ed
f01010b9:	e8 2b 35 00 00       	call   f01045e9 <cprintf>
f01010be:	83 c4 20             	add    $0x20,%esp
f01010c1:	eb a5                	jmp    f0101068 <mon_backtrace+0x24>
    	cprintf("Backtrace success\n");
f01010c3:	83 ec 0c             	sub    $0xc,%esp
f01010c6:	68 04 79 10 f0       	push   $0xf0107904
f01010cb:	e8 19 35 00 00       	call   f01045e9 <cprintf>
}
f01010d0:	b8 00 00 00 00       	mov    $0x0,%eax
f01010d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01010d8:	5b                   	pop    %ebx
f01010d9:	5e                   	pop    %esi
f01010da:	5d                   	pop    %ebp
f01010db:	c3                   	ret    

f01010dc <overflow_me>:
{
f01010dc:	55                   	push   %ebp
f01010dd:	89 e5                	mov    %esp,%ebp
f01010df:	83 ec 08             	sub    $0x8,%esp
        start_overflow();
f01010e2:	e8 67 fe ff ff       	call   f0100f4e <start_overflow>
}
f01010e7:	c9                   	leave  
f01010e8:	c3                   	ret    

f01010e9 <monitor>:
{
f01010e9:	55                   	push   %ebp
f01010ea:	89 e5                	mov    %esp,%ebp
f01010ec:	53                   	push   %ebx
f01010ed:	83 ec 10             	sub    $0x10,%esp
f01010f0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("Welcome to the JOS kernel monitor!\n");
f01010f3:	68 e8 7b 10 f0       	push   $0xf0107be8
f01010f8:	e8 ec 34 00 00       	call   f01045e9 <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f01010fd:	c7 04 24 0c 7c 10 f0 	movl   $0xf0107c0c,(%esp)
f0101104:	e8 e0 34 00 00       	call   f01045e9 <cprintf>
	if (tf != NULL)
f0101109:	83 c4 10             	add    $0x10,%esp
f010110c:	85 db                	test   %ebx,%ebx
f010110e:	74 0c                	je     f010111c <monitor+0x33>
		print_trapframe(tf);
f0101110:	83 ec 0c             	sub    $0xc,%esp
f0101113:	53                   	push   %ebx
f0101114:	e8 5f 3a 00 00       	call   f0104b78 <print_trapframe>
f0101119:	83 c4 10             	add    $0x10,%esp
		buf = readline("K> ");
f010111c:	83 ec 0c             	sub    $0xc,%esp
f010111f:	68 17 79 10 f0       	push   $0xf0107917
f0101124:	e8 fe 53 00 00       	call   f0106527 <readline>
		if (buf != NULL)
f0101129:	83 c4 10             	add    $0x10,%esp
f010112c:	85 c0                	test   %eax,%eax
f010112e:	74 ec                	je     f010111c <monitor+0x33>
			if (runcmd(buf, tf) < 0)
f0101130:	89 da                	mov    %ebx,%edx
f0101132:	e8 03 f8 ff ff       	call   f010093a <runcmd>
f0101137:	85 c0                	test   %eax,%eax
f0101139:	79 e1                	jns    f010111c <monitor+0x33>
}
f010113b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010113e:	c9                   	leave  
f010113f:	c3                   	ret    

f0101140 <page_size>:
page_size(uintptr_t va){
f0101140:	55                   	push   %ebp
f0101141:	89 e5                	mov    %esp,%ebp
f0101143:	83 ec 0c             	sub    $0xc,%esp
	pte_t *pte = pgdir_walk_large(kern_pgdir, (void *)va, 0);
f0101146:	6a 00                	push   $0x0
f0101148:	ff 75 08             	pushl  0x8(%ebp)
f010114b:	ff 35 8c 5e 34 f0    	pushl  0xf0345e8c
f0101151:	e8 10 0a 00 00       	call   f0101b66 <pgdir_walk_large>
	if(pte && ((*pte) & PTE_P) && ((*pte)&PTE_PS))
f0101156:	83 c4 10             	add    $0x10,%esp
	return PGSIZE;
f0101159:	ba 00 10 00 00       	mov    $0x1000,%edx
	if(pte && ((*pte) & PTE_P) && ((*pte)&PTE_PS))
f010115e:	85 c0                	test   %eax,%eax
f0101160:	74 14                	je     f0101176 <page_size+0x36>
f0101162:	8b 00                	mov    (%eax),%eax
f0101164:	25 81 00 00 00       	and    $0x81,%eax
		return PTSIZE;
f0101169:	3d 81 00 00 00       	cmp    $0x81,%eax
f010116e:	b8 00 00 40 00       	mov    $0x400000,%eax
f0101173:	0f 44 d0             	cmove  %eax,%edx
}
f0101176:	89 d0                	mov    %edx,%eax
f0101178:	c9                   	leave  
f0101179:	c3                   	ret    

f010117a <print_v2p>:
{
f010117a:	55                   	push   %ebp
f010117b:	89 e5                	mov    %esp,%ebp
f010117d:	57                   	push   %edi
f010117e:	56                   	push   %esi
f010117f:	53                   	push   %ebx
f0101180:	83 ec 20             	sub    $0x20,%esp
	pte_t *pte = pgdir_walk_large(kern_pgdir, (void *)va, 0);
f0101183:	6a 00                	push   $0x0
f0101185:	ff 75 08             	pushl  0x8(%ebp)
f0101188:	ff 35 8c 5e 34 f0    	pushl  0xf0345e8c
f010118e:	e8 d3 09 00 00       	call   f0101b66 <pgdir_walk_large>
	if(!pte || !(*pte & PTE_P)){
f0101193:	83 c4 10             	add    $0x10,%esp
f0101196:	85 c0                	test   %eax,%eax
f0101198:	0f 84 bf 00 00 00    	je     f010125d <print_v2p+0xe3>
f010119e:	89 c6                	mov    %eax,%esi
f01011a0:	8b 00                	mov    (%eax),%eax
f01011a2:	a8 01                	test   $0x1,%al
f01011a4:	0f 84 b3 00 00 00    	je     f010125d <print_v2p+0xe3>
	if(*pte & PTE_W)
f01011aa:	89 c1                	mov    %eax,%ecx
f01011ac:	83 e1 02             	and    $0x2,%ecx
f01011af:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	if(*pte & PTE_U)
f01011b2:	89 c2                	mov    %eax,%edx
f01011b4:	83 e2 04             	and    $0x4,%edx
f01011b7:	89 55 e0             	mov    %edx,-0x20(%ebp)
	if(*pte & PTE_PS){
f01011ba:	25 80 00 00 00       	and    $0x80,%eax
		large = false;
f01011bf:	83 f8 01             	cmp    $0x1,%eax
f01011c2:	19 ff                	sbb    %edi,%edi
f01011c4:	83 c7 01             	add    $0x1,%edi
f01011c7:	83 f8 01             	cmp    $0x1,%eax
f01011ca:	19 db                	sbb    %ebx,%ebx
f01011cc:	81 e3 00 10 c0 ff    	and    $0xffc01000,%ebx
f01011d2:	81 c3 00 00 40 00    	add    $0x400000,%ebx
	cprintf("va:\t\t\tpa:\n");
f01011d8:	83 ec 0c             	sub    $0xc,%esp
f01011db:	68 1b 79 10 f0       	push   $0xf010791b
f01011e0:	e8 04 34 00 00       	call   f01045e9 <cprintf>
	cprintf("%08p --- %08p  ->  %08p --- %08p\n", va, va+size-1, PTE_ADDR(*pte), PTE_ADDR(*pte)+size-1);
f01011e5:	8b 06                	mov    (%esi),%eax
f01011e7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01011ec:	8d 54 18 ff          	lea    -0x1(%eax,%ebx,1),%edx
f01011f0:	89 14 24             	mov    %edx,(%esp)
f01011f3:	50                   	push   %eax
f01011f4:	8b 45 08             	mov    0x8(%ebp),%eax
f01011f7:	8d 44 03 ff          	lea    -0x1(%ebx,%eax,1),%eax
f01011fb:	50                   	push   %eax
f01011fc:	ff 75 08             	pushl  0x8(%ebp)
f01011ff:	68 34 7c 10 f0       	push   $0xf0107c34
f0101204:	e8 e0 33 00 00       	call   f01045e9 <cprintf>
	cprintf("R/W\tU/K\t4K/4M page\n");
f0101209:	83 c4 14             	add    $0x14,%esp
f010120c:	68 26 79 10 f0       	push   $0xf0107926
f0101211:	e8 d3 33 00 00       	call   f01045e9 <cprintf>
	if(write)
f0101216:	83 c4 10             	add    $0x10,%esp
f0101219:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f010121d:	74 59                	je     f0101278 <print_v2p+0xfe>
		cprintf("R/W");
f010121f:	83 ec 0c             	sub    $0xc,%esp
f0101222:	68 3a 79 10 f0       	push   $0xf010793a
f0101227:	e8 bd 33 00 00       	call   f01045e9 <cprintf>
f010122c:	83 c4 10             	add    $0x10,%esp
	if(user)
f010122f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0101233:	74 55                	je     f010128a <print_v2p+0x110>
		cprintf("\tU");
f0101235:	83 ec 0c             	sub    $0xc,%esp
f0101238:	68 42 79 10 f0       	push   $0xf0107942
f010123d:	e8 a7 33 00 00       	call   f01045e9 <cprintf>
f0101242:	83 c4 10             	add    $0x10,%esp
	if(large)
f0101245:	89 f8                	mov    %edi,%eax
f0101247:	84 c0                	test   %al,%al
f0101249:	74 51                	je     f010129c <print_v2p+0x122>
		cprintf("\t\t4M page\n");
f010124b:	83 ec 0c             	sub    $0xc,%esp
f010124e:	68 48 79 10 f0       	push   $0xf0107948
f0101253:	e8 91 33 00 00       	call   f01045e9 <cprintf>
f0101258:	83 c4 10             	add    $0x10,%esp
f010125b:	eb 13                	jmp    f0101270 <print_v2p+0xf6>
		cprintf("%08p not exists or not mapped\n", va);
f010125d:	83 ec 08             	sub    $0x8,%esp
f0101260:	ff 75 08             	pushl  0x8(%ebp)
f0101263:	68 68 7b 10 f0       	push   $0xf0107b68
f0101268:	e8 7c 33 00 00       	call   f01045e9 <cprintf>
		return;
f010126d:	83 c4 10             	add    $0x10,%esp
}
f0101270:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101273:	5b                   	pop    %ebx
f0101274:	5e                   	pop    %esi
f0101275:	5f                   	pop    %edi
f0101276:	5d                   	pop    %ebp
f0101277:	c3                   	ret    
		cprintf("R/-");
f0101278:	83 ec 0c             	sub    $0xc,%esp
f010127b:	68 3e 79 10 f0       	push   $0xf010793e
f0101280:	e8 64 33 00 00       	call   f01045e9 <cprintf>
f0101285:	83 c4 10             	add    $0x10,%esp
f0101288:	eb a5                	jmp    f010122f <print_v2p+0xb5>
		cprintf("\tK");
f010128a:	83 ec 0c             	sub    $0xc,%esp
f010128d:	68 45 79 10 f0       	push   $0xf0107945
f0101292:	e8 52 33 00 00       	call   f01045e9 <cprintf>
f0101297:	83 c4 10             	add    $0x10,%esp
f010129a:	eb a9                	jmp    f0101245 <print_v2p+0xcb>
		cprintf("\t\t4K page\n");	
f010129c:	83 ec 0c             	sub    $0xc,%esp
f010129f:	68 53 79 10 f0       	push   $0xf0107953
f01012a4:	e8 40 33 00 00       	call   f01045e9 <cprintf>
f01012a9:	83 c4 10             	add    $0x10,%esp
f01012ac:	eb c2                	jmp    f0101270 <print_v2p+0xf6>

f01012ae <mon_showmapping>:
{
f01012ae:	55                   	push   %ebp
f01012af:	89 e5                	mov    %esp,%ebp
f01012b1:	56                   	push   %esi
f01012b2:	53                   	push   %ebx
f01012b3:	8b 45 08             	mov    0x8(%ebp),%eax
	if(argc == 1){
f01012b6:	83 f8 01             	cmp    $0x1,%eax
f01012b9:	74 2a                	je     f01012e5 <mon_showmapping+0x37>
	if(argc == 2){
f01012bb:	83 f8 02             	cmp    $0x2,%eax
f01012be:	74 37                	je     f01012f7 <mon_showmapping+0x49>
	if(argc == 3){
f01012c0:	83 f8 03             	cmp    $0x3,%eax
f01012c3:	0f 84 84 00 00 00    	je     f010134d <mon_showmapping+0x9f>
	cprintf("usage: showmapping va1 [va2]\n");
f01012c9:	83 ec 0c             	sub    $0xc,%esp
f01012cc:	68 5e 79 10 f0       	push   $0xf010795e
f01012d1:	e8 13 33 00 00       	call   f01045e9 <cprintf>
	return 0;
f01012d6:	83 c4 10             	add    $0x10,%esp
}
f01012d9:	b8 00 00 00 00       	mov    $0x0,%eax
f01012de:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01012e1:	5b                   	pop    %ebx
f01012e2:	5e                   	pop    %esi
f01012e3:	5d                   	pop    %ebp
f01012e4:	c3                   	ret    
		cprintf("usage: showmapping va1 [va2]\n");
f01012e5:	83 ec 0c             	sub    $0xc,%esp
f01012e8:	68 5e 79 10 f0       	push   $0xf010795e
f01012ed:	e8 f7 32 00 00       	call   f01045e9 <cprintf>
		return 0;
f01012f2:	83 c4 10             	add    $0x10,%esp
f01012f5:	eb e2                	jmp    f01012d9 <mon_showmapping+0x2b>
		va0 = (uintptr_t)strtol(argv[1], NULL, 0);
f01012f7:	83 ec 04             	sub    $0x4,%esp
f01012fa:	6a 00                	push   $0x0
f01012fc:	6a 00                	push   $0x0
f01012fe:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101301:	ff 70 04             	pushl  0x4(%eax)
f0101304:	e8 a1 55 00 00       	call   f01068aa <strtol>
f0101309:	89 c3                	mov    %eax,%ebx
		pte0 = pgdir_walk_large(kern_pgdir, (void *)va0, 0);
f010130b:	83 c4 0c             	add    $0xc,%esp
f010130e:	6a 00                	push   $0x0
f0101310:	50                   	push   %eax
f0101311:	ff 35 8c 5e 34 f0    	pushl  0xf0345e8c
f0101317:	e8 4a 08 00 00       	call   f0101b66 <pgdir_walk_large>
		if(pte0 && ((*pte0)&PTE_P) && ((*pte0)&PTE_PS))
f010131c:	83 c4 10             	add    $0x10,%esp
f010131f:	85 c0                	test   %eax,%eax
f0101321:	74 0e                	je     f0101331 <mon_showmapping+0x83>
f0101323:	8b 00                	mov    (%eax),%eax
f0101325:	25 81 00 00 00       	and    $0x81,%eax
f010132a:	3d 81 00 00 00       	cmp    $0x81,%eax
f010132f:	74 14                	je     f0101345 <mon_showmapping+0x97>
			va0 = ROUNDDOWN(va0, PGSIZE);
f0101331:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
		print_v2p(va0);
f0101337:	83 ec 0c             	sub    $0xc,%esp
f010133a:	53                   	push   %ebx
f010133b:	e8 3a fe ff ff       	call   f010117a <print_v2p>
		return 0;
f0101340:	83 c4 10             	add    $0x10,%esp
f0101343:	eb 94                	jmp    f01012d9 <mon_showmapping+0x2b>
			va0 = ROUNDDOWN(va0, PTSIZE);
f0101345:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
f010134b:	eb ea                	jmp    f0101337 <mon_showmapping+0x89>
		va0 = (uintptr_t)strtol(argv[1], NULL, 0);
f010134d:	83 ec 04             	sub    $0x4,%esp
f0101350:	6a 00                	push   $0x0
f0101352:	6a 00                	push   $0x0
f0101354:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101357:	ff 70 04             	pushl  0x4(%eax)
f010135a:	e8 4b 55 00 00       	call   f01068aa <strtol>
f010135f:	89 c3                	mov    %eax,%ebx
		va1 = (uintptr_t)strtol(argv[2], NULL, 0);
f0101361:	83 c4 0c             	add    $0xc,%esp
f0101364:	6a 00                	push   $0x0
f0101366:	6a 00                	push   $0x0
f0101368:	8b 45 0c             	mov    0xc(%ebp),%eax
f010136b:	ff 70 08             	pushl  0x8(%eax)
f010136e:	e8 37 55 00 00       	call   f01068aa <strtol>
f0101373:	89 c6                	mov    %eax,%esi
		if(va0 > va1){
f0101375:	83 c4 10             	add    $0x10,%esp
f0101378:	39 c3                	cmp    %eax,%ebx
f010137a:	77 1c                	ja     f0101398 <mon_showmapping+0xea>
		if(va1 > 0xf0000000){
f010137c:	3d 00 00 00 f0       	cmp    $0xf0000000,%eax
f0101381:	76 2a                	jbe    f01013ad <mon_showmapping+0xff>
			cprintf("va2 out of va range\n");
f0101383:	83 ec 0c             	sub    $0xc,%esp
f0101386:	68 96 79 10 f0       	push   $0xf0107996
f010138b:	e8 59 32 00 00       	call   f01045e9 <cprintf>
			return 0;
f0101390:	83 c4 10             	add    $0x10,%esp
f0101393:	e9 41 ff ff ff       	jmp    f01012d9 <mon_showmapping+0x2b>
			cprintf("va2 must larger than va0\n");
f0101398:	83 ec 0c             	sub    $0xc,%esp
f010139b:	68 7c 79 10 f0       	push   $0xf010797c
f01013a0:	e8 44 32 00 00       	call   f01045e9 <cprintf>
			return 0;
f01013a5:	83 c4 10             	add    $0x10,%esp
f01013a8:	e9 2c ff ff ff       	jmp    f01012d9 <mon_showmapping+0x2b>
		pte0 = pgdir_walk_large(kern_pgdir, (void *)va0, 0);
f01013ad:	83 ec 04             	sub    $0x4,%esp
f01013b0:	6a 00                	push   $0x0
f01013b2:	53                   	push   %ebx
f01013b3:	ff 35 8c 5e 34 f0    	pushl  0xf0345e8c
f01013b9:	e8 a8 07 00 00       	call   f0101b66 <pgdir_walk_large>
		if(pte0 && ((*pte0)&PTE_P) && ((*pte0)&PTE_PS))
f01013be:	83 c4 10             	add    $0x10,%esp
f01013c1:	85 c0                	test   %eax,%eax
f01013c3:	74 0e                	je     f01013d3 <mon_showmapping+0x125>
f01013c5:	8b 00                	mov    (%eax),%eax
f01013c7:	25 81 00 00 00       	and    $0x81,%eax
f01013cc:	3d 81 00 00 00       	cmp    $0x81,%eax
f01013d1:	74 58                	je     f010142b <mon_showmapping+0x17d>
			va0 = ROUNDDOWN(va0, PGSIZE);
f01013d3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
		pte1 = pgdir_walk_large(kern_pgdir, (void *)va1, 0);
f01013d9:	83 ec 04             	sub    $0x4,%esp
f01013dc:	6a 00                	push   $0x0
f01013de:	56                   	push   %esi
f01013df:	ff 35 8c 5e 34 f0    	pushl  0xf0345e8c
f01013e5:	e8 7c 07 00 00       	call   f0101b66 <pgdir_walk_large>
		if(pte1 && ((*pte1)&PTE_P) && (*pte1)&PTE_PS)
f01013ea:	83 c4 10             	add    $0x10,%esp
f01013ed:	85 c0                	test   %eax,%eax
f01013ef:	74 0e                	je     f01013ff <mon_showmapping+0x151>
f01013f1:	8b 00                	mov    (%eax),%eax
f01013f3:	25 81 00 00 00       	and    $0x81,%eax
f01013f8:	3d 81 00 00 00       	cmp    $0x81,%eax
f01013fd:	74 34                	je     f0101433 <mon_showmapping+0x185>
			va1 = ROUNDUP(va1, PGSIZE);
f01013ff:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
f0101405:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
		for(; va0<va1; va0+=page_size(va0)){
f010140b:	39 f3                	cmp    %esi,%ebx
f010140d:	0f 83 c6 fe ff ff    	jae    f01012d9 <mon_showmapping+0x2b>
			print_v2p(va0);
f0101413:	83 ec 0c             	sub    $0xc,%esp
f0101416:	53                   	push   %ebx
f0101417:	e8 5e fd ff ff       	call   f010117a <print_v2p>
		for(; va0<va1; va0+=page_size(va0)){
f010141c:	89 1c 24             	mov    %ebx,(%esp)
f010141f:	e8 1c fd ff ff       	call   f0101140 <page_size>
f0101424:	01 c3                	add    %eax,%ebx
f0101426:	83 c4 10             	add    $0x10,%esp
f0101429:	eb e0                	jmp    f010140b <mon_showmapping+0x15d>
			va0 = ROUNDDOWN(va0, PTSIZE);
f010142b:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
f0101431:	eb a6                	jmp    f01013d9 <mon_showmapping+0x12b>
			va1 = ROUNDUP(va1, PTSIZE);
f0101433:	81 c6 ff ff 3f 00    	add    $0x3fffff,%esi
f0101439:	81 e6 00 00 c0 ff    	and    $0xffc00000,%esi
f010143f:	eb ca                	jmp    f010140b <mon_showmapping+0x15d>

f0101441 <nvram_read>:
// Detect machine's physical memory setup.
// --------------------------------------------------------------

static int
nvram_read(int r)
{
f0101441:	55                   	push   %ebp
f0101442:	89 e5                	mov    %esp,%ebp
f0101444:	56                   	push   %esi
f0101445:	53                   	push   %ebx
f0101446:	89 c6                	mov    %eax,%esi
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0101448:	83 ec 0c             	sub    $0xc,%esp
f010144b:	50                   	push   %eax
f010144c:	e8 03 30 00 00       	call   f0104454 <mc146818_read>
f0101451:	89 c3                	mov    %eax,%ebx
f0101453:	83 c6 01             	add    $0x1,%esi
f0101456:	89 34 24             	mov    %esi,(%esp)
f0101459:	e8 f6 2f 00 00       	call   f0104454 <mc146818_read>
f010145e:	c1 e0 08             	shl    $0x8,%eax
f0101461:	09 d8                	or     %ebx,%eax
}
f0101463:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101466:	5b                   	pop    %ebx
f0101467:	5e                   	pop    %esi
f0101468:	5d                   	pop    %ebp
f0101469:	c3                   	ret    

f010146a <check_va2pa>:
static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f010146a:	89 d1                	mov    %edx,%ecx
f010146c:	c1 e9 16             	shr    $0x16,%ecx
	if (!(*pgdir & PTE_P))
f010146f:	8b 04 88             	mov    (%eax,%ecx,4),%eax
f0101472:	a8 01                	test   $0x1,%al
f0101474:	74 52                	je     f01014c8 <check_va2pa+0x5e>
		return ~0;
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f0101476:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f010147b:	89 c1                	mov    %eax,%ecx
f010147d:	c1 e9 0c             	shr    $0xc,%ecx
f0101480:	3b 0d 88 5e 34 f0    	cmp    0xf0345e88,%ecx
f0101486:	73 25                	jae    f01014ad <check_va2pa+0x43>
	if (!(p[PTX(va)] & PTE_P))
f0101488:	c1 ea 0c             	shr    $0xc,%edx
f010148b:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0101491:	8b 84 90 00 00 00 f0 	mov    -0x10000000(%eax,%edx,4),%eax
f0101498:	89 c2                	mov    %eax,%edx
f010149a:	83 e2 01             	and    $0x1,%edx
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
f010149d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01014a2:	85 d2                	test   %edx,%edx
f01014a4:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f01014a9:	0f 44 c2             	cmove  %edx,%eax
f01014ac:	c3                   	ret    
{
f01014ad:	55                   	push   %ebp
f01014ae:	89 e5                	mov    %esp,%ebp
f01014b0:	83 ec 08             	sub    $0x8,%esp
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01014b3:	50                   	push   %eax
f01014b4:	68 54 74 10 f0       	push   $0xf0107454
f01014b9:	68 09 04 00 00       	push   $0x409
f01014be:	68 61 87 10 f0       	push   $0xf0108761
f01014c3:	e8 81 eb ff ff       	call   f0100049 <_panic>
		return ~0;
f01014c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f01014cd:	c3                   	ret    

f01014ce <boot_alloc>:
	if (!nextfree) {
f01014ce:	83 3d 38 42 34 f0 00 	cmpl   $0x0,0xf0344238
f01014d5:	74 42                	je     f0101519 <boot_alloc+0x4b>
	if(0 == n){
f01014d7:	85 c0                	test   %eax,%eax
f01014d9:	74 51                	je     f010152c <boot_alloc+0x5e>
{
f01014db:	55                   	push   %ebp
f01014dc:	89 e5                	mov    %esp,%ebp
f01014de:	83 ec 08             	sub    $0x8,%esp
f01014e1:	89 c2                	mov    %eax,%edx
	result = nextfree;
f01014e3:	a1 38 42 34 f0       	mov    0xf0344238,%eax
	nextfree += ROUNDUP(n, PGSIZE);
f01014e8:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
f01014ee:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f01014f4:	01 c2                	add    %eax,%edx
f01014f6:	89 15 38 42 34 f0    	mov    %edx,0xf0344238
	if ((uint32_t)kva < KERNBASE)
f01014fc:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f0101502:	76 2e                	jbe    f0101532 <boot_alloc+0x64>
	if(PADDR(nextfree) > npages*PGSIZE){
f0101504:	8b 0d 88 5e 34 f0    	mov    0xf0345e88,%ecx
f010150a:	c1 e1 0c             	shl    $0xc,%ecx
	return (physaddr_t)kva - KERNBASE;
f010150d:	81 c2 00 00 00 10    	add    $0x10000000,%edx
f0101513:	39 d1                	cmp    %edx,%ecx
f0101515:	72 2d                	jb     f0101544 <boot_alloc+0x76>
}
f0101517:	c9                   	leave  
f0101518:	c3                   	ret    
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0101519:	ba 07 80 38 f0       	mov    $0xf0388007,%edx
f010151e:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101524:	89 15 38 42 34 f0    	mov    %edx,0xf0344238
f010152a:	eb ab                	jmp    f01014d7 <boot_alloc+0x9>
		return nextfree;
f010152c:	a1 38 42 34 f0       	mov    0xf0344238,%eax
}
f0101531:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0101532:	52                   	push   %edx
f0101533:	68 78 74 10 f0       	push   $0xf0107478
f0101538:	6a 77                	push   $0x77
f010153a:	68 61 87 10 f0       	push   $0xf0108761
f010153f:	e8 05 eb ff ff       	call   f0100049 <_panic>
		panic("boot_alloc: out of memory\n");
f0101544:	83 ec 04             	sub    $0x4,%esp
f0101547:	68 6d 87 10 f0       	push   $0xf010876d
f010154c:	6a 78                	push   $0x78
f010154e:	68 61 87 10 f0       	push   $0xf0108761
f0101553:	e8 f1 ea ff ff       	call   f0100049 <_panic>

f0101558 <check_page_free_list>:
{
f0101558:	55                   	push   %ebp
f0101559:	89 e5                	mov    %esp,%ebp
f010155b:	57                   	push   %edi
f010155c:	56                   	push   %esi
f010155d:	53                   	push   %ebx
f010155e:	83 ec 2c             	sub    $0x2c,%esp
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0101561:	84 c0                	test   %al,%al
f0101563:	0f 85 77 02 00 00    	jne    f01017e0 <check_page_free_list+0x288>
	if (!page_free_list)
f0101569:	83 3d 40 42 34 f0 00 	cmpl   $0x0,0xf0344240
f0101570:	74 0a                	je     f010157c <check_page_free_list+0x24>
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0101572:	be 00 04 00 00       	mov    $0x400,%esi
f0101577:	e9 bf 02 00 00       	jmp    f010183b <check_page_free_list+0x2e3>
		panic("'page_free_list' is a null pointer!");
f010157c:	83 ec 04             	sub    $0x4,%esp
f010157f:	68 c0 7d 10 f0       	push   $0xf0107dc0
f0101584:	68 35 03 00 00       	push   $0x335
f0101589:	68 61 87 10 f0       	push   $0xf0108761
f010158e:	e8 b6 ea ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101593:	50                   	push   %eax
f0101594:	68 54 74 10 f0       	push   $0xf0107454
f0101599:	6a 58                	push   $0x58
f010159b:	68 88 87 10 f0       	push   $0xf0108788
f01015a0:	e8 a4 ea ff ff       	call   f0100049 <_panic>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f01015a5:	8b 1b                	mov    (%ebx),%ebx
f01015a7:	85 db                	test   %ebx,%ebx
f01015a9:	74 41                	je     f01015ec <check_page_free_list+0x94>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f01015ab:	89 d8                	mov    %ebx,%eax
f01015ad:	2b 05 90 5e 34 f0    	sub    0xf0345e90,%eax
f01015b3:	c1 f8 03             	sar    $0x3,%eax
f01015b6:	c1 e0 0c             	shl    $0xc,%eax
		if (PDX(page2pa(pp)) < pdx_limit)
f01015b9:	89 c2                	mov    %eax,%edx
f01015bb:	c1 ea 16             	shr    $0x16,%edx
f01015be:	39 f2                	cmp    %esi,%edx
f01015c0:	73 e3                	jae    f01015a5 <check_page_free_list+0x4d>
	if (PGNUM(pa) >= npages)
f01015c2:	89 c2                	mov    %eax,%edx
f01015c4:	c1 ea 0c             	shr    $0xc,%edx
f01015c7:	3b 15 88 5e 34 f0    	cmp    0xf0345e88,%edx
f01015cd:	73 c4                	jae    f0101593 <check_page_free_list+0x3b>
			memset(page2kva(pp), 0x97, 128);
f01015cf:	83 ec 04             	sub    $0x4,%esp
f01015d2:	68 80 00 00 00       	push   $0x80
f01015d7:	68 97 00 00 00       	push   $0x97
	return (void *)(pa + KERNBASE);
f01015dc:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01015e1:	50                   	push   %eax
f01015e2:	e8 ad 51 00 00       	call   f0106794 <memset>
f01015e7:	83 c4 10             	add    $0x10,%esp
f01015ea:	eb b9                	jmp    f01015a5 <check_page_free_list+0x4d>
	first_free_page = (char *) boot_alloc(0);
f01015ec:	b8 00 00 00 00       	mov    $0x0,%eax
f01015f1:	e8 d8 fe ff ff       	call   f01014ce <boot_alloc>
f01015f6:	89 45 cc             	mov    %eax,-0x34(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f01015f9:	8b 15 40 42 34 f0    	mov    0xf0344240,%edx
		assert(pp >= pages);
f01015ff:	8b 0d 90 5e 34 f0    	mov    0xf0345e90,%ecx
		assert(pp < pages + npages);
f0101605:	a1 88 5e 34 f0       	mov    0xf0345e88,%eax
f010160a:	89 45 d0             	mov    %eax,-0x30(%ebp)
f010160d:	8d 34 c1             	lea    (%ecx,%eax,8),%esi
	int nfree_basemem = 0, nfree_extmem = 0;
f0101610:	bf 00 00 00 00       	mov    $0x0,%edi
f0101615:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0101618:	e9 f9 00 00 00       	jmp    f0101716 <check_page_free_list+0x1be>
		assert(pp >= pages);
f010161d:	68 96 87 10 f0       	push   $0xf0108796
f0101622:	68 a2 87 10 f0       	push   $0xf01087a2
f0101627:	68 4f 03 00 00       	push   $0x34f
f010162c:	68 61 87 10 f0       	push   $0xf0108761
f0101631:	e8 13 ea ff ff       	call   f0100049 <_panic>
		assert(pp < pages + npages);
f0101636:	68 b7 87 10 f0       	push   $0xf01087b7
f010163b:	68 a2 87 10 f0       	push   $0xf01087a2
f0101640:	68 50 03 00 00       	push   $0x350
f0101645:	68 61 87 10 f0       	push   $0xf0108761
f010164a:	e8 fa e9 ff ff       	call   f0100049 <_panic>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f010164f:	68 e4 7d 10 f0       	push   $0xf0107de4
f0101654:	68 a2 87 10 f0       	push   $0xf01087a2
f0101659:	68 51 03 00 00       	push   $0x351
f010165e:	68 61 87 10 f0       	push   $0xf0108761
f0101663:	e8 e1 e9 ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) != 0);
f0101668:	68 cb 87 10 f0       	push   $0xf01087cb
f010166d:	68 a2 87 10 f0       	push   $0xf01087a2
f0101672:	68 54 03 00 00       	push   $0x354
f0101677:	68 61 87 10 f0       	push   $0xf0108761
f010167c:	e8 c8 e9 ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f0101681:	68 dc 87 10 f0       	push   $0xf01087dc
f0101686:	68 a2 87 10 f0       	push   $0xf01087a2
f010168b:	68 55 03 00 00       	push   $0x355
f0101690:	68 61 87 10 f0       	push   $0xf0108761
f0101695:	e8 af e9 ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f010169a:	68 18 7e 10 f0       	push   $0xf0107e18
f010169f:	68 a2 87 10 f0       	push   $0xf01087a2
f01016a4:	68 56 03 00 00       	push   $0x356
f01016a9:	68 61 87 10 f0       	push   $0xf0108761
f01016ae:	e8 96 e9 ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f01016b3:	68 f5 87 10 f0       	push   $0xf01087f5
f01016b8:	68 a2 87 10 f0       	push   $0xf01087a2
f01016bd:	68 57 03 00 00       	push   $0x357
f01016c2:	68 61 87 10 f0       	push   $0xf0108761
f01016c7:	e8 7d e9 ff ff       	call   f0100049 <_panic>
	if (PGNUM(pa) >= npages)
f01016cc:	89 c3                	mov    %eax,%ebx
f01016ce:	c1 eb 0c             	shr    $0xc,%ebx
f01016d1:	39 5d d0             	cmp    %ebx,-0x30(%ebp)
f01016d4:	76 0f                	jbe    f01016e5 <check_page_free_list+0x18d>
	return (void *)(pa + KERNBASE);
f01016d6:	2d 00 00 00 10       	sub    $0x10000000,%eax
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f01016db:	39 45 cc             	cmp    %eax,-0x34(%ebp)
f01016de:	77 17                	ja     f01016f7 <check_page_free_list+0x19f>
			++nfree_extmem;
f01016e0:	83 c7 01             	add    $0x1,%edi
f01016e3:	eb 2f                	jmp    f0101714 <check_page_free_list+0x1bc>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01016e5:	50                   	push   %eax
f01016e6:	68 54 74 10 f0       	push   $0xf0107454
f01016eb:	6a 58                	push   $0x58
f01016ed:	68 88 87 10 f0       	push   $0xf0108788
f01016f2:	e8 52 e9 ff ff       	call   f0100049 <_panic>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f01016f7:	68 3c 7e 10 f0       	push   $0xf0107e3c
f01016fc:	68 a2 87 10 f0       	push   $0xf01087a2
f0101701:	68 58 03 00 00       	push   $0x358
f0101706:	68 61 87 10 f0       	push   $0xf0108761
f010170b:	e8 39 e9 ff ff       	call   f0100049 <_panic>
			++nfree_basemem;
f0101710:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0101714:	8b 12                	mov    (%edx),%edx
f0101716:	85 d2                	test   %edx,%edx
f0101718:	74 74                	je     f010178e <check_page_free_list+0x236>
		assert(pp >= pages);
f010171a:	39 d1                	cmp    %edx,%ecx
f010171c:	0f 87 fb fe ff ff    	ja     f010161d <check_page_free_list+0xc5>
		assert(pp < pages + npages);
f0101722:	39 d6                	cmp    %edx,%esi
f0101724:	0f 86 0c ff ff ff    	jbe    f0101636 <check_page_free_list+0xde>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f010172a:	89 d0                	mov    %edx,%eax
f010172c:	29 c8                	sub    %ecx,%eax
f010172e:	a8 07                	test   $0x7,%al
f0101730:	0f 85 19 ff ff ff    	jne    f010164f <check_page_free_list+0xf7>
	return (pp - pages) << PGSHIFT;
f0101736:	c1 f8 03             	sar    $0x3,%eax
		assert(page2pa(pp) != 0);
f0101739:	c1 e0 0c             	shl    $0xc,%eax
f010173c:	0f 84 26 ff ff ff    	je     f0101668 <check_page_free_list+0x110>
		assert(page2pa(pp) != IOPHYSMEM);
f0101742:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0101747:	0f 84 34 ff ff ff    	je     f0101681 <check_page_free_list+0x129>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f010174d:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f0101752:	0f 84 42 ff ff ff    	je     f010169a <check_page_free_list+0x142>
		assert(page2pa(pp) != EXTPHYSMEM);
f0101758:	3d 00 00 10 00       	cmp    $0x100000,%eax
f010175d:	0f 84 50 ff ff ff    	je     f01016b3 <check_page_free_list+0x15b>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0101763:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f0101768:	0f 87 5e ff ff ff    	ja     f01016cc <check_page_free_list+0x174>
		assert(page2pa(pp) != MPENTRY_PADDR);
f010176e:	3d 00 70 00 00       	cmp    $0x7000,%eax
f0101773:	75 9b                	jne    f0101710 <check_page_free_list+0x1b8>
f0101775:	68 0f 88 10 f0       	push   $0xf010880f
f010177a:	68 a2 87 10 f0       	push   $0xf01087a2
f010177f:	68 5a 03 00 00       	push   $0x35a
f0101784:	68 61 87 10 f0       	push   $0xf0108761
f0101789:	e8 bb e8 ff ff       	call   f0100049 <_panic>
f010178e:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
	assert(nfree_basemem > 0);
f0101791:	85 db                	test   %ebx,%ebx
f0101793:	7e 19                	jle    f01017ae <check_page_free_list+0x256>
	assert(nfree_extmem > 0);
f0101795:	85 ff                	test   %edi,%edi
f0101797:	7e 2e                	jle    f01017c7 <check_page_free_list+0x26f>
	cprintf("check_page_free_list() succeeded!\n");
f0101799:	83 ec 0c             	sub    $0xc,%esp
f010179c:	68 84 7e 10 f0       	push   $0xf0107e84
f01017a1:	e8 43 2e 00 00       	call   f01045e9 <cprintf>
}
f01017a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01017a9:	5b                   	pop    %ebx
f01017aa:	5e                   	pop    %esi
f01017ab:	5f                   	pop    %edi
f01017ac:	5d                   	pop    %ebp
f01017ad:	c3                   	ret    
	assert(nfree_basemem > 0);
f01017ae:	68 2c 88 10 f0       	push   $0xf010882c
f01017b3:	68 a2 87 10 f0       	push   $0xf01087a2
f01017b8:	68 62 03 00 00       	push   $0x362
f01017bd:	68 61 87 10 f0       	push   $0xf0108761
f01017c2:	e8 82 e8 ff ff       	call   f0100049 <_panic>
	assert(nfree_extmem > 0);
f01017c7:	68 3e 88 10 f0       	push   $0xf010883e
f01017cc:	68 a2 87 10 f0       	push   $0xf01087a2
f01017d1:	68 63 03 00 00       	push   $0x363
f01017d6:	68 61 87 10 f0       	push   $0xf0108761
f01017db:	e8 69 e8 ff ff       	call   f0100049 <_panic>
	if (!page_free_list)
f01017e0:	a1 40 42 34 f0       	mov    0xf0344240,%eax
f01017e5:	85 c0                	test   %eax,%eax
f01017e7:	0f 84 8f fd ff ff    	je     f010157c <check_page_free_list+0x24>
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f01017ed:	8d 55 d8             	lea    -0x28(%ebp),%edx
f01017f0:	89 55 e0             	mov    %edx,-0x20(%ebp)
f01017f3:	8d 55 dc             	lea    -0x24(%ebp),%edx
f01017f6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f01017f9:	89 c2                	mov    %eax,%edx
f01017fb:	2b 15 90 5e 34 f0    	sub    0xf0345e90,%edx
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f0101801:	f7 c2 00 e0 7f 00    	test   $0x7fe000,%edx
f0101807:	0f 95 c2             	setne  %dl
f010180a:	0f b6 d2             	movzbl %dl,%edx
			*tp[pagetype] = pp;
f010180d:	8b 4c 95 e0          	mov    -0x20(%ebp,%edx,4),%ecx
f0101811:	89 01                	mov    %eax,(%ecx)
			tp[pagetype] = &pp->pp_link;
f0101813:	89 44 95 e0          	mov    %eax,-0x20(%ebp,%edx,4)
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f0101817:	8b 00                	mov    (%eax),%eax
f0101819:	85 c0                	test   %eax,%eax
f010181b:	75 dc                	jne    f01017f9 <check_page_free_list+0x2a1>
		*tp[1] = 0;
f010181d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0101820:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f0101826:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0101829:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010182c:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f010182e:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0101831:	a3 40 42 34 f0       	mov    %eax,0xf0344240
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0101836:	be 01 00 00 00       	mov    $0x1,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link)
f010183b:	8b 1d 40 42 34 f0    	mov    0xf0344240,%ebx
f0101841:	e9 61 fd ff ff       	jmp    f01015a7 <check_page_free_list+0x4f>

f0101846 <page_init>:
{
f0101846:	55                   	push   %ebp
f0101847:	89 e5                	mov    %esp,%ebp
f0101849:	57                   	push   %edi
f010184a:	56                   	push   %esi
f010184b:	53                   	push   %ebx
f010184c:	83 ec 0c             	sub    $0xc,%esp
	uint32_t next_free = PADDR(boot_alloc(0))/PGSIZE;
f010184f:	b8 00 00 00 00       	mov    $0x0,%eax
f0101854:	e8 75 fc ff ff       	call   f01014ce <boot_alloc>
	if ((uint32_t)kva < KERNBASE)
f0101859:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010185e:	76 21                	jbe    f0101881 <page_init+0x3b>
	return (physaddr_t)kva - KERNBASE;
f0101860:	8d 98 00 00 00 10    	lea    0x10000000(%eax),%ebx
f0101866:	c1 eb 0c             	shr    $0xc,%ebx
		if((i>=next_free) || (i<npages_basemem)){
f0101869:	8b 3d 44 42 34 f0    	mov    0xf0344244,%edi
f010186f:	8b 35 40 42 34 f0    	mov    0xf0344240,%esi
	for(i = 1; i<npages; i++){
f0101875:	b8 00 00 00 00       	mov    $0x0,%eax
f010187a:	ba 01 00 00 00       	mov    $0x1,%edx
f010187f:	eb 51                	jmp    f01018d2 <page_init+0x8c>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0101881:	50                   	push   %eax
f0101882:	68 78 74 10 f0       	push   $0xf0107478
f0101887:	68 59 01 00 00       	push   $0x159
f010188c:	68 61 87 10 f0       	push   $0xf0108761
f0101891:	e8 b3 e7 ff ff       	call   f0100049 <_panic>
			pages[i].pp_ref = 1;
f0101896:	8b 0d 90 5e 34 f0    	mov    0xf0345e90,%ecx
f010189c:	66 c7 41 3c 01 00    	movw   $0x1,0x3c(%ecx)
			pages[i].pp_link = NULL;
f01018a2:	c7 41 38 00 00 00 00 	movl   $0x0,0x38(%ecx)
			continue;
f01018a9:	eb 24                	jmp    f01018cf <page_init+0x89>
f01018ab:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
			pages[i].pp_ref = 0;
f01018b2:	89 c1                	mov    %eax,%ecx
f01018b4:	03 0d 90 5e 34 f0    	add    0xf0345e90,%ecx
f01018ba:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
			pages[i].pp_link = page_free_list;
f01018c0:	89 31                	mov    %esi,(%ecx)
			page_free_list = &pages[i];
f01018c2:	03 05 90 5e 34 f0    	add    0xf0345e90,%eax
f01018c8:	89 c6                	mov    %eax,%esi
f01018ca:	b8 01 00 00 00       	mov    $0x1,%eax
	for(i = 1; i<npages; i++){
f01018cf:	83 c2 01             	add    $0x1,%edx
f01018d2:	39 15 88 5e 34 f0    	cmp    %edx,0xf0345e88
f01018d8:	76 0f                	jbe    f01018e9 <page_init+0xa3>
		if(i == MPENTRY_PADDR / PGSIZE){
f01018da:	83 fa 07             	cmp    $0x7,%edx
f01018dd:	74 b7                	je     f0101896 <page_init+0x50>
		if((i>=next_free) || (i<npages_basemem)){
f01018df:	39 da                	cmp    %ebx,%edx
f01018e1:	73 c8                	jae    f01018ab <page_init+0x65>
f01018e3:	39 d7                	cmp    %edx,%edi
f01018e5:	76 e8                	jbe    f01018cf <page_init+0x89>
f01018e7:	eb c2                	jmp    f01018ab <page_init+0x65>
f01018e9:	84 c0                	test   %al,%al
f01018eb:	74 06                	je     f01018f3 <page_init+0xad>
f01018ed:	89 35 40 42 34 f0    	mov    %esi,0xf0344240
}
f01018f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01018f6:	5b                   	pop    %ebx
f01018f7:	5e                   	pop    %esi
f01018f8:	5f                   	pop    %edi
f01018f9:	5d                   	pop    %ebp
f01018fa:	c3                   	ret    

f01018fb <page_alloc>:
{
f01018fb:	55                   	push   %ebp
f01018fc:	89 e5                	mov    %esp,%ebp
f01018fe:	53                   	push   %ebx
f01018ff:	83 ec 04             	sub    $0x4,%esp
	if(page_free_list == NULL)
f0101902:	8b 1d 40 42 34 f0    	mov    0xf0344240,%ebx
f0101908:	85 db                	test   %ebx,%ebx
f010190a:	74 13                	je     f010191f <page_alloc+0x24>
	page_free_list = page_free_list->pp_link;
f010190c:	8b 03                	mov    (%ebx),%eax
f010190e:	a3 40 42 34 f0       	mov    %eax,0xf0344240
	page->pp_link = NULL;
f0101913:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	if(alloc_flags & ALLOC_ZERO){
f0101919:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
f010191d:	75 07                	jne    f0101926 <page_alloc+0x2b>
}
f010191f:	89 d8                	mov    %ebx,%eax
f0101921:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101924:	c9                   	leave  
f0101925:	c3                   	ret    
	return (pp - pages) << PGSHIFT;
f0101926:	89 d8                	mov    %ebx,%eax
f0101928:	2b 05 90 5e 34 f0    	sub    0xf0345e90,%eax
f010192e:	c1 f8 03             	sar    $0x3,%eax
f0101931:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101934:	89 c2                	mov    %eax,%edx
f0101936:	c1 ea 0c             	shr    $0xc,%edx
f0101939:	3b 15 88 5e 34 f0    	cmp    0xf0345e88,%edx
f010193f:	73 1a                	jae    f010195b <page_alloc+0x60>
		memset(page2kva(page), '\0', PGSIZE);
f0101941:	83 ec 04             	sub    $0x4,%esp
f0101944:	68 00 10 00 00       	push   $0x1000
f0101949:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f010194b:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101950:	50                   	push   %eax
f0101951:	e8 3e 4e 00 00       	call   f0106794 <memset>
f0101956:	83 c4 10             	add    $0x10,%esp
f0101959:	eb c4                	jmp    f010191f <page_alloc+0x24>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010195b:	50                   	push   %eax
f010195c:	68 54 74 10 f0       	push   $0xf0107454
f0101961:	6a 58                	push   $0x58
f0101963:	68 88 87 10 f0       	push   $0xf0108788
f0101968:	e8 dc e6 ff ff       	call   f0100049 <_panic>

f010196d <page_free>:
{
f010196d:	55                   	push   %ebp
f010196e:	89 e5                	mov    %esp,%ebp
f0101970:	83 ec 08             	sub    $0x8,%esp
f0101973:	8b 45 08             	mov    0x8(%ebp),%eax
	if(!pp) panic("page_free: pp is NULL\n");
f0101976:	85 c0                	test   %eax,%eax
f0101978:	74 1b                	je     f0101995 <page_free+0x28>
	if(pp->pp_ref){
f010197a:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f010197f:	75 2b                	jne    f01019ac <page_free+0x3f>
	if(pp->pp_link != NULL){
f0101981:	83 38 00             	cmpl   $0x0,(%eax)
f0101984:	75 3d                	jne    f01019c3 <page_free+0x56>
	pp->pp_link = page_free_list;
f0101986:	8b 15 40 42 34 f0    	mov    0xf0344240,%edx
f010198c:	89 10                	mov    %edx,(%eax)
	page_free_list = pp;
f010198e:	a3 40 42 34 f0       	mov    %eax,0xf0344240
}
f0101993:	c9                   	leave  
f0101994:	c3                   	ret    
	if(!pp) panic("page_free: pp is NULL\n");
f0101995:	83 ec 04             	sub    $0x4,%esp
f0101998:	68 4f 88 10 f0       	push   $0xf010884f
f010199d:	68 95 01 00 00       	push   $0x195
f01019a2:	68 61 87 10 f0       	push   $0xf0108761
f01019a7:	e8 9d e6 ff ff       	call   f0100049 <_panic>
		panic("page_free: pp_ref nonzero\n");
f01019ac:	83 ec 04             	sub    $0x4,%esp
f01019af:	68 66 88 10 f0       	push   $0xf0108866
f01019b4:	68 97 01 00 00       	push   $0x197
f01019b9:	68 61 87 10 f0       	push   $0xf0108761
f01019be:	e8 86 e6 ff ff       	call   f0100049 <_panic>
		panic("page_free: pp_link not NULL\n");
f01019c3:	83 ec 04             	sub    $0x4,%esp
f01019c6:	68 81 88 10 f0       	push   $0xf0108881
f01019cb:	68 9a 01 00 00       	push   $0x19a
f01019d0:	68 61 87 10 f0       	push   $0xf0108761
f01019d5:	e8 6f e6 ff ff       	call   f0100049 <_panic>

f01019da <page_decref>:
{
f01019da:	55                   	push   %ebp
f01019db:	89 e5                	mov    %esp,%ebp
f01019dd:	83 ec 08             	sub    $0x8,%esp
f01019e0:	8b 55 08             	mov    0x8(%ebp),%edx
	if (--pp->pp_ref == 0)
f01019e3:	0f b7 42 04          	movzwl 0x4(%edx),%eax
f01019e7:	83 e8 01             	sub    $0x1,%eax
f01019ea:	66 89 42 04          	mov    %ax,0x4(%edx)
f01019ee:	66 85 c0             	test   %ax,%ax
f01019f1:	74 02                	je     f01019f5 <page_decref+0x1b>
}
f01019f3:	c9                   	leave  
f01019f4:	c3                   	ret    
		page_free(pp);
f01019f5:	83 ec 0c             	sub    $0xc,%esp
f01019f8:	52                   	push   %edx
f01019f9:	e8 6f ff ff ff       	call   f010196d <page_free>
f01019fe:	83 c4 10             	add    $0x10,%esp
}
f0101a01:	eb f0                	jmp    f01019f3 <page_decref+0x19>

f0101a03 <pgdir_walk>:
{
f0101a03:	55                   	push   %ebp
f0101a04:	89 e5                	mov    %esp,%ebp
f0101a06:	56                   	push   %esi
f0101a07:	53                   	push   %ebx
f0101a08:	8b 45 08             	mov    0x8(%ebp),%eax
f0101a0b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if (!pgdir) panic("pgdir_walk: pgdir is NULL\n");
f0101a0e:	85 c0                	test   %eax,%eax
f0101a10:	74 39                	je     f0101a4b <pgdir_walk+0x48>
	pde_t pde = pgdir[PDX(va)];
f0101a12:	89 da                	mov    %ebx,%edx
f0101a14:	c1 ea 16             	shr    $0x16,%edx
f0101a17:	8d 34 90             	lea    (%eax,%edx,4),%esi
f0101a1a:	8b 06                	mov    (%esi),%eax
	if (pde & PTE_P) {
f0101a1c:	a8 01                	test   $0x1,%al
f0101a1e:	74 57                	je     f0101a77 <pgdir_walk+0x74>
		pgtbl = KADDR(PTE_ADDR(pde));
f0101a20:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0101a25:	89 c2                	mov    %eax,%edx
f0101a27:	c1 ea 0c             	shr    $0xc,%edx
f0101a2a:	39 15 88 5e 34 f0    	cmp    %edx,0xf0345e88
f0101a30:	76 30                	jbe    f0101a62 <pgdir_walk+0x5f>
	return (void *)(pa + KERNBASE);
f0101a32:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
	return &pgtbl[PTX(va)];
f0101a38:	c1 eb 0a             	shr    $0xa,%ebx
f0101a3b:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
f0101a41:	8d 04 1a             	lea    (%edx,%ebx,1),%eax
}
f0101a44:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101a47:	5b                   	pop    %ebx
f0101a48:	5e                   	pop    %esi
f0101a49:	5d                   	pop    %ebp
f0101a4a:	c3                   	ret    
	if (!pgdir) panic("pgdir_walk: pgdir is NULL\n");
f0101a4b:	83 ec 04             	sub    $0x4,%esp
f0101a4e:	68 9e 88 10 f0       	push   $0xf010889e
f0101a53:	68 c8 01 00 00       	push   $0x1c8
f0101a58:	68 61 87 10 f0       	push   $0xf0108761
f0101a5d:	e8 e7 e5 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101a62:	50                   	push   %eax
f0101a63:	68 54 74 10 f0       	push   $0xf0107454
f0101a68:	68 d4 01 00 00       	push   $0x1d4
f0101a6d:	68 61 87 10 f0       	push   $0xf0108761
f0101a72:	e8 d2 e5 ff ff       	call   f0100049 <_panic>
		if (!create) return NULL;
f0101a77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0101a7b:	74 56                	je     f0101ad3 <pgdir_walk+0xd0>
		pageInfo = page_alloc(ALLOC_ZERO);
f0101a7d:	83 ec 0c             	sub    $0xc,%esp
f0101a80:	6a 01                	push   $0x1
f0101a82:	e8 74 fe ff ff       	call   f01018fb <page_alloc>
		if (!pageInfo) return NULL;
f0101a87:	83 c4 10             	add    $0x10,%esp
f0101a8a:	85 c0                	test   %eax,%eax
f0101a8c:	74 4f                	je     f0101add <pgdir_walk+0xda>
		pageInfo->pp_ref++;
f0101a8e:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0101a93:	2b 05 90 5e 34 f0    	sub    0xf0345e90,%eax
f0101a99:	c1 f8 03             	sar    $0x3,%eax
f0101a9c:	c1 e0 0c             	shl    $0xc,%eax
		pgdir[PDX(va)] = pte_addr | PTE_U | PTE_W | PTE_P;
f0101a9f:	89 c2                	mov    %eax,%edx
f0101aa1:	83 ca 07             	or     $0x7,%edx
f0101aa4:	89 16                	mov    %edx,(%esi)
	if (PGNUM(pa) >= npages)
f0101aa6:	89 c2                	mov    %eax,%edx
f0101aa8:	c1 ea 0c             	shr    $0xc,%edx
f0101aab:	3b 15 88 5e 34 f0    	cmp    0xf0345e88,%edx
f0101ab1:	73 0b                	jae    f0101abe <pgdir_walk+0xbb>
	return (void *)(pa + KERNBASE);
f0101ab3:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
f0101ab9:	e9 7a ff ff ff       	jmp    f0101a38 <pgdir_walk+0x35>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101abe:	50                   	push   %eax
f0101abf:	68 54 74 10 f0       	push   $0xf0107454
f0101ac4:	68 e2 01 00 00       	push   $0x1e2
f0101ac9:	68 61 87 10 f0       	push   $0xf0108761
f0101ace:	e8 76 e5 ff ff       	call   f0100049 <_panic>
		if (!create) return NULL;
f0101ad3:	b8 00 00 00 00       	mov    $0x0,%eax
f0101ad8:	e9 67 ff ff ff       	jmp    f0101a44 <pgdir_walk+0x41>
		if (!pageInfo) return NULL;
f0101add:	b8 00 00 00 00       	mov    $0x0,%eax
f0101ae2:	e9 5d ff ff ff       	jmp    f0101a44 <pgdir_walk+0x41>

f0101ae7 <boot_map_region>:
{
f0101ae7:	55                   	push   %ebp
f0101ae8:	89 e5                	mov    %esp,%ebp
f0101aea:	57                   	push   %edi
f0101aeb:	56                   	push   %esi
f0101aec:	53                   	push   %ebx
f0101aed:	83 ec 1c             	sub    $0x1c,%esp
f0101af0:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	if (!pgdir) panic("boot_map_region: null pointer 'pgdir'\n");
f0101af3:	85 c0                	test   %eax,%eax
f0101af5:	74 39                	je     f0101b30 <boot_map_region+0x49>
f0101af7:	89 c6                	mov    %eax,%esi
f0101af9:	89 d7                	mov    %edx,%edi
	for(pos=0; pos<size; pos+=PGSIZE){
f0101afb:	bb 00 00 00 00       	mov    $0x0,%ebx
f0101b00:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f0101b03:	73 59                	jae    f0101b5e <boot_map_region+0x77>
		pte_t *pte = pgdir_walk(pgdir, (void *)(va+pos), true);
f0101b05:	83 ec 04             	sub    $0x4,%esp
f0101b08:	6a 01                	push   $0x1
f0101b0a:	8d 04 3b             	lea    (%ebx,%edi,1),%eax
f0101b0d:	50                   	push   %eax
f0101b0e:	56                   	push   %esi
f0101b0f:	e8 ef fe ff ff       	call   f0101a03 <pgdir_walk>
		if(!pte) panic("boot_map_region: pgdir_walk returns NULL\n");
f0101b14:	83 c4 10             	add    $0x10,%esp
f0101b17:	85 c0                	test   %eax,%eax
f0101b19:	74 2c                	je     f0101b47 <boot_map_region+0x60>
		(*pte) = (pa+pos) | perm | PTE_P;
f0101b1b:	89 da                	mov    %ebx,%edx
f0101b1d:	03 55 08             	add    0x8(%ebp),%edx
f0101b20:	0b 55 0c             	or     0xc(%ebp),%edx
f0101b23:	83 ca 01             	or     $0x1,%edx
f0101b26:	89 10                	mov    %edx,(%eax)
	for(pos=0; pos<size; pos+=PGSIZE){
f0101b28:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0101b2e:	eb d0                	jmp    f0101b00 <boot_map_region+0x19>
	if (!pgdir) panic("boot_map_region: null pointer 'pgdir'\n");
f0101b30:	83 ec 04             	sub    $0x4,%esp
f0101b33:	68 a8 7e 10 f0       	push   $0xf0107ea8
f0101b38:	68 1d 02 00 00       	push   $0x21d
f0101b3d:	68 61 87 10 f0       	push   $0xf0108761
f0101b42:	e8 02 e5 ff ff       	call   f0100049 <_panic>
		if(!pte) panic("boot_map_region: pgdir_walk returns NULL\n");
f0101b47:	83 ec 04             	sub    $0x4,%esp
f0101b4a:	68 d0 7e 10 f0       	push   $0xf0107ed0
f0101b4f:	68 22 02 00 00       	push   $0x222
f0101b54:	68 61 87 10 f0       	push   $0xf0108761
f0101b59:	e8 eb e4 ff ff       	call   f0100049 <_panic>
}
f0101b5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101b61:	5b                   	pop    %ebx
f0101b62:	5e                   	pop    %esi
f0101b63:	5f                   	pop    %edi
f0101b64:	5d                   	pop    %ebp
f0101b65:	c3                   	ret    

f0101b66 <pgdir_walk_large>:
{
f0101b66:	55                   	push   %ebp
f0101b67:	89 e5                	mov    %esp,%ebp
f0101b69:	56                   	push   %esi
f0101b6a:	53                   	push   %ebx
f0101b6b:	8b 45 08             	mov    0x8(%ebp),%eax
f0101b6e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if (!pgdir) panic("pgdir_walk: pgdir is NULL\n");
f0101b71:	85 c0                	test   %eax,%eax
f0101b73:	74 3e                	je     f0101bb3 <pgdir_walk_large+0x4d>
	pde_t pde = pgdir[PDX(va)];
f0101b75:	89 da                	mov    %ebx,%edx
f0101b77:	c1 ea 16             	shr    $0x16,%edx
f0101b7a:	8d 34 90             	lea    (%eax,%edx,4),%esi
f0101b7d:	8b 06                	mov    (%esi),%eax
	if (pde & PTE_P) {
f0101b7f:	a8 01                	test   $0x1,%al
f0101b81:	74 5c                	je     f0101bdf <pgdir_walk_large+0x79>
		if(pde & PTE_PS)
f0101b83:	a8 80                	test   $0x80,%al
f0101b85:	75 23                	jne    f0101baa <pgdir_walk_large+0x44>
		pgtbl = KADDR(PTE_ADDR(pde));
f0101b87:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0101b8c:	89 c2                	mov    %eax,%edx
f0101b8e:	c1 ea 0c             	shr    $0xc,%edx
f0101b91:	39 15 88 5e 34 f0    	cmp    %edx,0xf0345e88
f0101b97:	76 31                	jbe    f0101bca <pgdir_walk_large+0x64>
	return (void *)(pa + KERNBASE);
f0101b99:	2d 00 00 00 10       	sub    $0x10000000,%eax
	return &pgtbl[PTX(va)];
f0101b9e:	c1 eb 0a             	shr    $0xa,%ebx
f0101ba1:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
f0101ba7:	8d 34 18             	lea    (%eax,%ebx,1),%esi
}
f0101baa:	89 f0                	mov    %esi,%eax
f0101bac:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101baf:	5b                   	pop    %ebx
f0101bb0:	5e                   	pop    %esi
f0101bb1:	5d                   	pop    %ebp
f0101bb2:	c3                   	ret    
	if (!pgdir) panic("pgdir_walk: pgdir is NULL\n");
f0101bb3:	83 ec 04             	sub    $0x4,%esp
f0101bb6:	68 9e 88 10 f0       	push   $0xf010889e
f0101bbb:	68 ec 01 00 00       	push   $0x1ec
f0101bc0:	68 61 87 10 f0       	push   $0xf0108761
f0101bc5:	e8 7f e4 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101bca:	50                   	push   %eax
f0101bcb:	68 54 74 10 f0       	push   $0xf0107454
f0101bd0:	68 fa 01 00 00       	push   $0x1fa
f0101bd5:	68 61 87 10 f0       	push   $0xf0108761
f0101bda:	e8 6a e4 ff ff       	call   f0100049 <_panic>
		if (!create) return NULL;
f0101bdf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0101be3:	74 55                	je     f0101c3a <pgdir_walk_large+0xd4>
		pageInfo = page_alloc(ALLOC_ZERO);
f0101be5:	83 ec 0c             	sub    $0xc,%esp
f0101be8:	6a 01                	push   $0x1
f0101bea:	e8 0c fd ff ff       	call   f01018fb <page_alloc>
		if (!pageInfo) return NULL;
f0101bef:	83 c4 10             	add    $0x10,%esp
f0101bf2:	85 c0                	test   %eax,%eax
f0101bf4:	74 4e                	je     f0101c44 <pgdir_walk_large+0xde>
		pageInfo->pp_ref++;
f0101bf6:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0101bfb:	2b 05 90 5e 34 f0    	sub    0xf0345e90,%eax
f0101c01:	c1 f8 03             	sar    $0x3,%eax
f0101c04:	c1 e0 0c             	shl    $0xc,%eax
		pgdir[PDX(va)] = pte_addr | PTE_U | PTE_W | PTE_P;
f0101c07:	89 c2                	mov    %eax,%edx
f0101c09:	83 ca 07             	or     $0x7,%edx
f0101c0c:	89 16                	mov    %edx,(%esi)
	if (PGNUM(pa) >= npages)
f0101c0e:	89 c2                	mov    %eax,%edx
f0101c10:	c1 ea 0c             	shr    $0xc,%edx
f0101c13:	3b 15 88 5e 34 f0    	cmp    0xf0345e88,%edx
f0101c19:	73 0a                	jae    f0101c25 <pgdir_walk_large+0xbf>
	return (void *)(pa + KERNBASE);
f0101c1b:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101c20:	e9 79 ff ff ff       	jmp    f0101b9e <pgdir_walk_large+0x38>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101c25:	50                   	push   %eax
f0101c26:	68 54 74 10 f0       	push   $0xf0107454
f0101c2b:	68 08 02 00 00       	push   $0x208
f0101c30:	68 61 87 10 f0       	push   $0xf0108761
f0101c35:	e8 0f e4 ff ff       	call   f0100049 <_panic>
		if (!create) return NULL;
f0101c3a:	be 00 00 00 00       	mov    $0x0,%esi
f0101c3f:	e9 66 ff ff ff       	jmp    f0101baa <pgdir_walk_large+0x44>
		if (!pageInfo) return NULL;
f0101c44:	be 00 00 00 00       	mov    $0x0,%esi
f0101c49:	e9 5c ff ff ff       	jmp    f0101baa <pgdir_walk_large+0x44>

f0101c4e <page_lookup>:
{
f0101c4e:	55                   	push   %ebp
f0101c4f:	89 e5                	mov    %esp,%ebp
f0101c51:	53                   	push   %ebx
f0101c52:	83 ec 04             	sub    $0x4,%esp
f0101c55:	8b 55 08             	mov    0x8(%ebp),%edx
f0101c58:	8b 5d 10             	mov    0x10(%ebp),%ebx
	if(!pgdir) panic("page_lookup: pgdir is NULL\n");
f0101c5b:	85 d2                	test   %edx,%edx
f0101c5d:	74 41                	je     f0101ca0 <page_lookup+0x52>
	pte_t *pte = pgdir_walk(pgdir, (void *)va, false);
f0101c5f:	83 ec 04             	sub    $0x4,%esp
f0101c62:	6a 00                	push   $0x0
	va = ROUNDDOWN(va, PGSIZE);
f0101c64:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101c67:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	pte_t *pte = pgdir_walk(pgdir, (void *)va, false);
f0101c6c:	50                   	push   %eax
f0101c6d:	52                   	push   %edx
f0101c6e:	e8 90 fd ff ff       	call   f0101a03 <pgdir_walk>
	if(!pte)
f0101c73:	83 c4 10             	add    $0x10,%esp
f0101c76:	85 c0                	test   %eax,%eax
f0101c78:	74 51                	je     f0101ccb <page_lookup+0x7d>
	if(!(*pte & PTE_P))
f0101c7a:	f6 00 01             	testb  $0x1,(%eax)
f0101c7d:	74 53                	je     f0101cd2 <page_lookup+0x84>
	if(pte_store){
f0101c7f:	85 db                	test   %ebx,%ebx
f0101c81:	74 02                	je     f0101c85 <page_lookup+0x37>
		*pte_store = pte;
f0101c83:	89 03                	mov    %eax,(%ebx)
f0101c85:	8b 00                	mov    (%eax),%eax
f0101c87:	c1 e8 0c             	shr    $0xc,%eax
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101c8a:	39 05 88 5e 34 f0    	cmp    %eax,0xf0345e88
f0101c90:	76 25                	jbe    f0101cb7 <page_lookup+0x69>
		panic("pa2page called with invalid pa");
	return &pages[PGNUM(pa)];
f0101c92:	8b 15 90 5e 34 f0    	mov    0xf0345e90,%edx
f0101c98:	8d 04 c2             	lea    (%edx,%eax,8),%eax
}
f0101c9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101c9e:	c9                   	leave  
f0101c9f:	c3                   	ret    
	if(!pgdir) panic("page_lookup: pgdir is NULL\n");
f0101ca0:	83 ec 04             	sub    $0x4,%esp
f0101ca3:	68 b9 88 10 f0       	push   $0xf01088b9
f0101ca8:	68 7f 02 00 00       	push   $0x27f
f0101cad:	68 61 87 10 f0       	push   $0xf0108761
f0101cb2:	e8 92 e3 ff ff       	call   f0100049 <_panic>
		panic("pa2page called with invalid pa");
f0101cb7:	83 ec 04             	sub    $0x4,%esp
f0101cba:	68 fc 7e 10 f0       	push   $0xf0107efc
f0101cbf:	6a 51                	push   $0x51
f0101cc1:	68 88 87 10 f0       	push   $0xf0108788
f0101cc6:	e8 7e e3 ff ff       	call   f0100049 <_panic>
		return NULL;
f0101ccb:	b8 00 00 00 00       	mov    $0x0,%eax
f0101cd0:	eb c9                	jmp    f0101c9b <page_lookup+0x4d>
		return NULL;
f0101cd2:	b8 00 00 00 00       	mov    $0x0,%eax
f0101cd7:	eb c2                	jmp    f0101c9b <page_lookup+0x4d>

f0101cd9 <tlb_invalidate>:
{
f0101cd9:	55                   	push   %ebp
f0101cda:	89 e5                	mov    %esp,%ebp
f0101cdc:	83 ec 08             	sub    $0x8,%esp
	if (!curenv || curenv->env_pgdir == pgdir)
f0101cdf:	e8 b6 50 00 00       	call   f0106d9a <cpunum>
f0101ce4:	6b c0 74             	imul   $0x74,%eax,%eax
f0101ce7:	83 b8 28 60 34 f0 00 	cmpl   $0x0,-0xfcb9fd8(%eax)
f0101cee:	74 16                	je     f0101d06 <tlb_invalidate+0x2d>
f0101cf0:	e8 a5 50 00 00       	call   f0106d9a <cpunum>
f0101cf5:	6b c0 74             	imul   $0x74,%eax,%eax
f0101cf8:	8b 80 28 60 34 f0    	mov    -0xfcb9fd8(%eax),%eax
f0101cfe:	8b 55 08             	mov    0x8(%ebp),%edx
f0101d01:	39 50 60             	cmp    %edx,0x60(%eax)
f0101d04:	75 06                	jne    f0101d0c <tlb_invalidate+0x33>
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f0101d06:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101d09:	0f 01 38             	invlpg (%eax)
}
f0101d0c:	c9                   	leave  
f0101d0d:	c3                   	ret    

f0101d0e <page_remove>:
{
f0101d0e:	55                   	push   %ebp
f0101d0f:	89 e5                	mov    %esp,%ebp
f0101d11:	56                   	push   %esi
f0101d12:	53                   	push   %ebx
f0101d13:	83 ec 10             	sub    $0x10,%esp
f0101d16:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0101d19:	8b 75 0c             	mov    0xc(%ebp),%esi
	if(!pgdir) panic("page_remove: pgdir is NULL\n");
f0101d1c:	85 db                	test   %ebx,%ebx
f0101d1e:	74 3b                	je     f0101d5b <page_remove+0x4d>
	struct PageInfo *pageInfo = page_lookup(pgdir, (void *)va, &pte);
f0101d20:	83 ec 04             	sub    $0x4,%esp
f0101d23:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0101d26:	50                   	push   %eax
f0101d27:	56                   	push   %esi
f0101d28:	53                   	push   %ebx
f0101d29:	e8 20 ff ff ff       	call   f0101c4e <page_lookup>
	if(!pageInfo)
f0101d2e:	83 c4 10             	add    $0x10,%esp
f0101d31:	85 c0                	test   %eax,%eax
f0101d33:	74 1f                	je     f0101d54 <page_remove+0x46>
	*pte = 0;
f0101d35:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0101d38:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	page_decref(pageInfo);
f0101d3e:	83 ec 0c             	sub    $0xc,%esp
f0101d41:	50                   	push   %eax
f0101d42:	e8 93 fc ff ff       	call   f01019da <page_decref>
	tlb_invalidate(pgdir, va);
f0101d47:	83 c4 08             	add    $0x8,%esp
f0101d4a:	56                   	push   %esi
f0101d4b:	53                   	push   %ebx
f0101d4c:	e8 88 ff ff ff       	call   f0101cd9 <tlb_invalidate>
f0101d51:	83 c4 10             	add    $0x10,%esp
}
f0101d54:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101d57:	5b                   	pop    %ebx
f0101d58:	5e                   	pop    %esi
f0101d59:	5d                   	pop    %ebp
f0101d5a:	c3                   	ret    
	if(!pgdir) panic("page_remove: pgdir is NULL\n");
f0101d5b:	83 ec 04             	sub    $0x4,%esp
f0101d5e:	68 d5 88 10 f0       	push   $0xf01088d5
f0101d63:	68 a1 02 00 00       	push   $0x2a1
f0101d68:	68 61 87 10 f0       	push   $0xf0108761
f0101d6d:	e8 d7 e2 ff ff       	call   f0100049 <_panic>

f0101d72 <page_insert>:
{
f0101d72:	55                   	push   %ebp
f0101d73:	89 e5                	mov    %esp,%ebp
f0101d75:	57                   	push   %edi
f0101d76:	56                   	push   %esi
f0101d77:	53                   	push   %ebx
f0101d78:	83 ec 0c             	sub    $0xc,%esp
f0101d7b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if(!pgdir) panic("page_insert: pgdir is NULL");
f0101d7e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0101d82:	74 4b                	je     f0101dcf <page_insert+0x5d>
	va = ROUNDDOWN(va, PGSIZE);	
f0101d84:	8b 75 10             	mov    0x10(%ebp),%esi
f0101d87:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	pte_t *pte = pgdir_walk(pgdir, (void *)va, true);
f0101d8d:	83 ec 04             	sub    $0x4,%esp
f0101d90:	6a 01                	push   $0x1
f0101d92:	56                   	push   %esi
f0101d93:	ff 75 08             	pushl  0x8(%ebp)
f0101d96:	e8 68 fc ff ff       	call   f0101a03 <pgdir_walk>
f0101d9b:	89 c7                	mov    %eax,%edi
	if(!pte) return -E_NO_MEM;
f0101d9d:	83 c4 10             	add    $0x10,%esp
f0101da0:	85 c0                	test   %eax,%eax
f0101da2:	74 53                	je     f0101df7 <page_insert+0x85>
	pp->pp_ref += 1;
f0101da4:	66 83 43 04 01       	addw   $0x1,0x4(%ebx)
	if(*pte & PTE_P)
f0101da9:	f6 00 01             	testb  $0x1,(%eax)
f0101dac:	75 38                	jne    f0101de6 <page_insert+0x74>
	return (pp - pages) << PGSHIFT;
f0101dae:	2b 1d 90 5e 34 f0    	sub    0xf0345e90,%ebx
f0101db4:	c1 fb 03             	sar    $0x3,%ebx
f0101db7:	c1 e3 0c             	shl    $0xc,%ebx
	*pte = page2pa(pp) | perm | PTE_P;
f0101dba:	0b 5d 14             	or     0x14(%ebp),%ebx
f0101dbd:	83 cb 01             	or     $0x1,%ebx
f0101dc0:	89 1f                	mov    %ebx,(%edi)
	return 0;
f0101dc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0101dc7:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101dca:	5b                   	pop    %ebx
f0101dcb:	5e                   	pop    %esi
f0101dcc:	5f                   	pop    %edi
f0101dcd:	5d                   	pop    %ebp
f0101dce:	c3                   	ret    
	if(!pgdir) panic("page_insert: pgdir is NULL");
f0101dcf:	83 ec 04             	sub    $0x4,%esp
f0101dd2:	68 f1 88 10 f0       	push   $0xf01088f1
f0101dd7:	68 63 02 00 00       	push   $0x263
f0101ddc:	68 61 87 10 f0       	push   $0xf0108761
f0101de1:	e8 63 e2 ff ff       	call   f0100049 <_panic>
		page_remove(pgdir, (void *)va);
f0101de6:	83 ec 08             	sub    $0x8,%esp
f0101de9:	56                   	push   %esi
f0101dea:	ff 75 08             	pushl  0x8(%ebp)
f0101ded:	e8 1c ff ff ff       	call   f0101d0e <page_remove>
f0101df2:	83 c4 10             	add    $0x10,%esp
f0101df5:	eb b7                	jmp    f0101dae <page_insert+0x3c>
	if(!pte) return -E_NO_MEM;
f0101df7:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0101dfc:	eb c9                	jmp    f0101dc7 <page_insert+0x55>

f0101dfe <mmio_map_region>:
{
f0101dfe:	55                   	push   %ebp
f0101dff:	89 e5                	mov    %esp,%ebp
f0101e01:	53                   	push   %ebx
f0101e02:	83 ec 04             	sub    $0x4,%esp
f0101e05:	8b 45 08             	mov    0x8(%ebp),%eax
	size = ROUNDUP(size+PGOFF(pa), PGSIZE);
f0101e08:	89 c2                	mov    %eax,%edx
f0101e0a:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
f0101e10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0101e13:	8d 9c 11 ff 0f 00 00 	lea    0xfff(%ecx,%edx,1),%ebx
f0101e1a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	pa = ROUNDDOWN(pa, PGSIZE);
f0101e20:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if(base+size >= MMIOLIM){
f0101e25:	8b 15 00 53 12 f0    	mov    0xf0125300,%edx
f0101e2b:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
f0101e2e:	81 f9 ff ff bf ef    	cmp    $0xefbfffff,%ecx
f0101e34:	77 24                	ja     f0101e5a <mmio_map_region+0x5c>
	boot_map_region(kern_pgdir, base, size, pa, PTE_W | PTE_PWT | PTE_PCD);
f0101e36:	83 ec 08             	sub    $0x8,%esp
f0101e39:	6a 1a                	push   $0x1a
f0101e3b:	50                   	push   %eax
f0101e3c:	89 d9                	mov    %ebx,%ecx
f0101e3e:	a1 8c 5e 34 f0       	mov    0xf0345e8c,%eax
f0101e43:	e8 9f fc ff ff       	call   f0101ae7 <boot_map_region>
	base += size;
f0101e48:	a1 00 53 12 f0       	mov    0xf0125300,%eax
f0101e4d:	01 c3                	add    %eax,%ebx
f0101e4f:	89 1d 00 53 12 f0    	mov    %ebx,0xf0125300
}
f0101e55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101e58:	c9                   	leave  
f0101e59:	c3                   	ret    
		panic("mmio_map_region: overflow");
f0101e5a:	83 ec 04             	sub    $0x4,%esp
f0101e5d:	68 0c 89 10 f0       	push   $0xf010890c
f0101e62:	68 dd 02 00 00       	push   $0x2dd
f0101e67:	68 61 87 10 f0       	push   $0xf0108761
f0101e6c:	e8 d8 e1 ff ff       	call   f0100049 <_panic>

f0101e71 <mem_init>:
{
f0101e71:	55                   	push   %ebp
f0101e72:	89 e5                	mov    %esp,%ebp
f0101e74:	57                   	push   %edi
f0101e75:	56                   	push   %esi
f0101e76:	53                   	push   %ebx
f0101e77:	83 ec 3c             	sub    $0x3c,%esp
	basemem = nvram_read(NVRAM_BASELO);
f0101e7a:	b8 15 00 00 00       	mov    $0x15,%eax
f0101e7f:	e8 bd f5 ff ff       	call   f0101441 <nvram_read>
f0101e84:	89 c3                	mov    %eax,%ebx
	extmem = nvram_read(NVRAM_EXTLO);
f0101e86:	b8 17 00 00 00       	mov    $0x17,%eax
f0101e8b:	e8 b1 f5 ff ff       	call   f0101441 <nvram_read>
f0101e90:	89 c6                	mov    %eax,%esi
	ext16mem = nvram_read(NVRAM_EXT16LO) * 64;
f0101e92:	b8 34 00 00 00       	mov    $0x34,%eax
f0101e97:	e8 a5 f5 ff ff       	call   f0101441 <nvram_read>
	if (ext16mem)
f0101e9c:	c1 e0 06             	shl    $0x6,%eax
f0101e9f:	0f 84 d1 00 00 00    	je     f0101f76 <mem_init+0x105>
		totalmem = 16 * 1024 + ext16mem;
f0101ea5:	05 00 40 00 00       	add    $0x4000,%eax
	npages = totalmem / (PGSIZE / 1024);
f0101eaa:	89 c2                	mov    %eax,%edx
f0101eac:	c1 ea 02             	shr    $0x2,%edx
f0101eaf:	89 15 88 5e 34 f0    	mov    %edx,0xf0345e88
	npages_basemem = basemem / (PGSIZE / 1024);
f0101eb5:	89 da                	mov    %ebx,%edx
f0101eb7:	c1 ea 02             	shr    $0x2,%edx
f0101eba:	89 15 44 42 34 f0    	mov    %edx,0xf0344244
	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f0101ec0:	89 c2                	mov    %eax,%edx
f0101ec2:	29 da                	sub    %ebx,%edx
f0101ec4:	52                   	push   %edx
f0101ec5:	53                   	push   %ebx
f0101ec6:	50                   	push   %eax
f0101ec7:	68 1c 7f 10 f0       	push   $0xf0107f1c
f0101ecc:	e8 18 27 00 00       	call   f01045e9 <cprintf>
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f0101ed1:	b8 00 10 00 00       	mov    $0x1000,%eax
f0101ed6:	e8 f3 f5 ff ff       	call   f01014ce <boot_alloc>
f0101edb:	a3 8c 5e 34 f0       	mov    %eax,0xf0345e8c
	memset(kern_pgdir, 0, PGSIZE);
f0101ee0:	83 c4 0c             	add    $0xc,%esp
f0101ee3:	68 00 10 00 00       	push   $0x1000
f0101ee8:	6a 00                	push   $0x0
f0101eea:	50                   	push   %eax
f0101eeb:	e8 a4 48 00 00       	call   f0106794 <memset>
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f0101ef0:	a1 8c 5e 34 f0       	mov    0xf0345e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f0101ef5:	83 c4 10             	add    $0x10,%esp
f0101ef8:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0101efd:	0f 86 83 00 00 00    	jbe    f0101f86 <mem_init+0x115>
	return (physaddr_t)kva - KERNBASE;
f0101f03:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0101f09:	83 ca 05             	or     $0x5,%edx
f0101f0c:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	pages = (struct PageInfo *)boot_alloc(npages * sizeof(struct PageInfo));
f0101f12:	a1 88 5e 34 f0       	mov    0xf0345e88,%eax
f0101f17:	c1 e0 03             	shl    $0x3,%eax
f0101f1a:	e8 af f5 ff ff       	call   f01014ce <boot_alloc>
f0101f1f:	a3 90 5e 34 f0       	mov    %eax,0xf0345e90
	envs = (struct Env*)boot_alloc(NENV * sizeof(struct Env));
f0101f24:	b8 00 10 02 00       	mov    $0x21000,%eax
f0101f29:	e8 a0 f5 ff ff       	call   f01014ce <boot_alloc>
f0101f2e:	a3 48 42 34 f0       	mov    %eax,0xf0344248
	memset(envs, 0, NENV * sizeof(struct Env));
f0101f33:	83 ec 04             	sub    $0x4,%esp
f0101f36:	68 00 10 02 00       	push   $0x21000
f0101f3b:	6a 00                	push   $0x0
f0101f3d:	50                   	push   %eax
f0101f3e:	e8 51 48 00 00       	call   f0106794 <memset>
	page_init();
f0101f43:	e8 fe f8 ff ff       	call   f0101846 <page_init>
	check_page_free_list(1);
f0101f48:	b8 01 00 00 00       	mov    $0x1,%eax
f0101f4d:	e8 06 f6 ff ff       	call   f0101558 <check_page_free_list>
	if (!pages)
f0101f52:	83 c4 10             	add    $0x10,%esp
f0101f55:	83 3d 90 5e 34 f0 00 	cmpl   $0x0,0xf0345e90
f0101f5c:	74 3d                	je     f0101f9b <mem_init+0x12a>
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101f5e:	a1 40 42 34 f0       	mov    0xf0344240,%eax
f0101f63:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
f0101f6a:	85 c0                	test   %eax,%eax
f0101f6c:	74 44                	je     f0101fb2 <mem_init+0x141>
		++nfree;
f0101f6e:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101f72:	8b 00                	mov    (%eax),%eax
f0101f74:	eb f4                	jmp    f0101f6a <mem_init+0xf9>
		totalmem = 1 * 1024 + extmem;
f0101f76:	8d 86 00 04 00 00    	lea    0x400(%esi),%eax
f0101f7c:	85 f6                	test   %esi,%esi
f0101f7e:	0f 44 c3             	cmove  %ebx,%eax
f0101f81:	e9 24 ff ff ff       	jmp    f0101eaa <mem_init+0x39>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0101f86:	50                   	push   %eax
f0101f87:	68 78 74 10 f0       	push   $0xf0107478
f0101f8c:	68 a1 00 00 00       	push   $0xa1
f0101f91:	68 61 87 10 f0       	push   $0xf0108761
f0101f96:	e8 ae e0 ff ff       	call   f0100049 <_panic>
		panic("'pages' is a null pointer!");
f0101f9b:	83 ec 04             	sub    $0x4,%esp
f0101f9e:	68 26 89 10 f0       	push   $0xf0108926
f0101fa3:	68 76 03 00 00       	push   $0x376
f0101fa8:	68 61 87 10 f0       	push   $0xf0108761
f0101fad:	e8 97 e0 ff ff       	call   f0100049 <_panic>
	assert((pp0 = page_alloc(0)));
f0101fb2:	83 ec 0c             	sub    $0xc,%esp
f0101fb5:	6a 00                	push   $0x0
f0101fb7:	e8 3f f9 ff ff       	call   f01018fb <page_alloc>
f0101fbc:	89 c3                	mov    %eax,%ebx
f0101fbe:	83 c4 10             	add    $0x10,%esp
f0101fc1:	85 c0                	test   %eax,%eax
f0101fc3:	0f 84 00 02 00 00    	je     f01021c9 <mem_init+0x358>
	assert((pp1 = page_alloc(0)));
f0101fc9:	83 ec 0c             	sub    $0xc,%esp
f0101fcc:	6a 00                	push   $0x0
f0101fce:	e8 28 f9 ff ff       	call   f01018fb <page_alloc>
f0101fd3:	89 c6                	mov    %eax,%esi
f0101fd5:	83 c4 10             	add    $0x10,%esp
f0101fd8:	85 c0                	test   %eax,%eax
f0101fda:	0f 84 02 02 00 00    	je     f01021e2 <mem_init+0x371>
	assert((pp2 = page_alloc(0)));
f0101fe0:	83 ec 0c             	sub    $0xc,%esp
f0101fe3:	6a 00                	push   $0x0
f0101fe5:	e8 11 f9 ff ff       	call   f01018fb <page_alloc>
f0101fea:	89 c7                	mov    %eax,%edi
f0101fec:	83 c4 10             	add    $0x10,%esp
f0101fef:	85 c0                	test   %eax,%eax
f0101ff1:	0f 84 04 02 00 00    	je     f01021fb <mem_init+0x38a>
	assert(pp1 && pp1 != pp0);
f0101ff7:	39 f3                	cmp    %esi,%ebx
f0101ff9:	0f 84 15 02 00 00    	je     f0102214 <mem_init+0x3a3>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101fff:	39 c6                	cmp    %eax,%esi
f0102001:	0f 84 26 02 00 00    	je     f010222d <mem_init+0x3bc>
f0102007:	39 c3                	cmp    %eax,%ebx
f0102009:	0f 84 1e 02 00 00    	je     f010222d <mem_init+0x3bc>
	return (pp - pages) << PGSHIFT;
f010200f:	8b 0d 90 5e 34 f0    	mov    0xf0345e90,%ecx
	assert(page2pa(pp0) < npages*PGSIZE);
f0102015:	8b 15 88 5e 34 f0    	mov    0xf0345e88,%edx
f010201b:	c1 e2 0c             	shl    $0xc,%edx
f010201e:	89 d8                	mov    %ebx,%eax
f0102020:	29 c8                	sub    %ecx,%eax
f0102022:	c1 f8 03             	sar    $0x3,%eax
f0102025:	c1 e0 0c             	shl    $0xc,%eax
f0102028:	39 d0                	cmp    %edx,%eax
f010202a:	0f 83 16 02 00 00    	jae    f0102246 <mem_init+0x3d5>
f0102030:	89 f0                	mov    %esi,%eax
f0102032:	29 c8                	sub    %ecx,%eax
f0102034:	c1 f8 03             	sar    $0x3,%eax
f0102037:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp1) < npages*PGSIZE);
f010203a:	39 c2                	cmp    %eax,%edx
f010203c:	0f 86 1d 02 00 00    	jbe    f010225f <mem_init+0x3ee>
f0102042:	89 f8                	mov    %edi,%eax
f0102044:	29 c8                	sub    %ecx,%eax
f0102046:	c1 f8 03             	sar    $0x3,%eax
f0102049:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp2) < npages*PGSIZE);
f010204c:	39 c2                	cmp    %eax,%edx
f010204e:	0f 86 24 02 00 00    	jbe    f0102278 <mem_init+0x407>
	fl = page_free_list;
f0102054:	a1 40 42 34 f0       	mov    0xf0344240,%eax
f0102059:	89 45 d0             	mov    %eax,-0x30(%ebp)
	page_free_list = 0;
f010205c:	c7 05 40 42 34 f0 00 	movl   $0x0,0xf0344240
f0102063:	00 00 00 
	assert(!page_alloc(0));
f0102066:	83 ec 0c             	sub    $0xc,%esp
f0102069:	6a 00                	push   $0x0
f010206b:	e8 8b f8 ff ff       	call   f01018fb <page_alloc>
f0102070:	83 c4 10             	add    $0x10,%esp
f0102073:	85 c0                	test   %eax,%eax
f0102075:	0f 85 16 02 00 00    	jne    f0102291 <mem_init+0x420>
	page_free(pp0);
f010207b:	83 ec 0c             	sub    $0xc,%esp
f010207e:	53                   	push   %ebx
f010207f:	e8 e9 f8 ff ff       	call   f010196d <page_free>
	page_free(pp1);
f0102084:	89 34 24             	mov    %esi,(%esp)
f0102087:	e8 e1 f8 ff ff       	call   f010196d <page_free>
	page_free(pp2);
f010208c:	89 3c 24             	mov    %edi,(%esp)
f010208f:	e8 d9 f8 ff ff       	call   f010196d <page_free>
	assert((pp0 = page_alloc(0)));
f0102094:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f010209b:	e8 5b f8 ff ff       	call   f01018fb <page_alloc>
f01020a0:	89 c3                	mov    %eax,%ebx
f01020a2:	83 c4 10             	add    $0x10,%esp
f01020a5:	85 c0                	test   %eax,%eax
f01020a7:	0f 84 fd 01 00 00    	je     f01022aa <mem_init+0x439>
	assert((pp1 = page_alloc(0)));
f01020ad:	83 ec 0c             	sub    $0xc,%esp
f01020b0:	6a 00                	push   $0x0
f01020b2:	e8 44 f8 ff ff       	call   f01018fb <page_alloc>
f01020b7:	89 c6                	mov    %eax,%esi
f01020b9:	83 c4 10             	add    $0x10,%esp
f01020bc:	85 c0                	test   %eax,%eax
f01020be:	0f 84 ff 01 00 00    	je     f01022c3 <mem_init+0x452>
	assert((pp2 = page_alloc(0)));
f01020c4:	83 ec 0c             	sub    $0xc,%esp
f01020c7:	6a 00                	push   $0x0
f01020c9:	e8 2d f8 ff ff       	call   f01018fb <page_alloc>
f01020ce:	89 c7                	mov    %eax,%edi
f01020d0:	83 c4 10             	add    $0x10,%esp
f01020d3:	85 c0                	test   %eax,%eax
f01020d5:	0f 84 01 02 00 00    	je     f01022dc <mem_init+0x46b>
	assert(pp1 && pp1 != pp0);
f01020db:	39 f3                	cmp    %esi,%ebx
f01020dd:	0f 84 12 02 00 00    	je     f01022f5 <mem_init+0x484>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01020e3:	39 c3                	cmp    %eax,%ebx
f01020e5:	0f 84 23 02 00 00    	je     f010230e <mem_init+0x49d>
f01020eb:	39 c6                	cmp    %eax,%esi
f01020ed:	0f 84 1b 02 00 00    	je     f010230e <mem_init+0x49d>
	assert(!page_alloc(0));
f01020f3:	83 ec 0c             	sub    $0xc,%esp
f01020f6:	6a 00                	push   $0x0
f01020f8:	e8 fe f7 ff ff       	call   f01018fb <page_alloc>
f01020fd:	83 c4 10             	add    $0x10,%esp
f0102100:	85 c0                	test   %eax,%eax
f0102102:	0f 85 1f 02 00 00    	jne    f0102327 <mem_init+0x4b6>
f0102108:	89 d8                	mov    %ebx,%eax
f010210a:	2b 05 90 5e 34 f0    	sub    0xf0345e90,%eax
f0102110:	c1 f8 03             	sar    $0x3,%eax
f0102113:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0102116:	89 c2                	mov    %eax,%edx
f0102118:	c1 ea 0c             	shr    $0xc,%edx
f010211b:	3b 15 88 5e 34 f0    	cmp    0xf0345e88,%edx
f0102121:	0f 83 19 02 00 00    	jae    f0102340 <mem_init+0x4cf>
	memset(page2kva(pp0), 1, PGSIZE);
f0102127:	83 ec 04             	sub    $0x4,%esp
f010212a:	68 00 10 00 00       	push   $0x1000
f010212f:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0102131:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102136:	50                   	push   %eax
f0102137:	e8 58 46 00 00       	call   f0106794 <memset>
	page_free(pp0);
f010213c:	89 1c 24             	mov    %ebx,(%esp)
f010213f:	e8 29 f8 ff ff       	call   f010196d <page_free>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0102144:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f010214b:	e8 ab f7 ff ff       	call   f01018fb <page_alloc>
f0102150:	83 c4 10             	add    $0x10,%esp
f0102153:	85 c0                	test   %eax,%eax
f0102155:	0f 84 f7 01 00 00    	je     f0102352 <mem_init+0x4e1>
	assert(pp && pp0 == pp);
f010215b:	39 c3                	cmp    %eax,%ebx
f010215d:	0f 85 08 02 00 00    	jne    f010236b <mem_init+0x4fa>
	return (pp - pages) << PGSHIFT;
f0102163:	2b 05 90 5e 34 f0    	sub    0xf0345e90,%eax
f0102169:	c1 f8 03             	sar    $0x3,%eax
f010216c:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f010216f:	89 c2                	mov    %eax,%edx
f0102171:	c1 ea 0c             	shr    $0xc,%edx
f0102174:	3b 15 88 5e 34 f0    	cmp    0xf0345e88,%edx
f010217a:	0f 83 04 02 00 00    	jae    f0102384 <mem_init+0x513>
	return (void *)(pa + KERNBASE);
f0102180:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
f0102186:	2d 00 f0 ff 0f       	sub    $0xffff000,%eax
		assert(c[i] == 0);
f010218b:	80 3a 00             	cmpb   $0x0,(%edx)
f010218e:	0f 85 02 02 00 00    	jne    f0102396 <mem_init+0x525>
f0102194:	83 c2 01             	add    $0x1,%edx
	for (i = 0; i < PGSIZE; i++)
f0102197:	39 c2                	cmp    %eax,%edx
f0102199:	75 f0                	jne    f010218b <mem_init+0x31a>
	page_free_list = fl;
f010219b:	8b 45 d0             	mov    -0x30(%ebp),%eax
f010219e:	a3 40 42 34 f0       	mov    %eax,0xf0344240
	page_free(pp0);
f01021a3:	83 ec 0c             	sub    $0xc,%esp
f01021a6:	53                   	push   %ebx
f01021a7:	e8 c1 f7 ff ff       	call   f010196d <page_free>
	page_free(pp1);
f01021ac:	89 34 24             	mov    %esi,(%esp)
f01021af:	e8 b9 f7 ff ff       	call   f010196d <page_free>
	page_free(pp2);
f01021b4:	89 3c 24             	mov    %edi,(%esp)
f01021b7:	e8 b1 f7 ff ff       	call   f010196d <page_free>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f01021bc:	a1 40 42 34 f0       	mov    0xf0344240,%eax
f01021c1:	83 c4 10             	add    $0x10,%esp
f01021c4:	e9 ec 01 00 00       	jmp    f01023b5 <mem_init+0x544>
	assert((pp0 = page_alloc(0)));
f01021c9:	68 41 89 10 f0       	push   $0xf0108941
f01021ce:	68 a2 87 10 f0       	push   $0xf01087a2
f01021d3:	68 7e 03 00 00       	push   $0x37e
f01021d8:	68 61 87 10 f0       	push   $0xf0108761
f01021dd:	e8 67 de ff ff       	call   f0100049 <_panic>
	assert((pp1 = page_alloc(0)));
f01021e2:	68 57 89 10 f0       	push   $0xf0108957
f01021e7:	68 a2 87 10 f0       	push   $0xf01087a2
f01021ec:	68 7f 03 00 00       	push   $0x37f
f01021f1:	68 61 87 10 f0       	push   $0xf0108761
f01021f6:	e8 4e de ff ff       	call   f0100049 <_panic>
	assert((pp2 = page_alloc(0)));
f01021fb:	68 6d 89 10 f0       	push   $0xf010896d
f0102200:	68 a2 87 10 f0       	push   $0xf01087a2
f0102205:	68 80 03 00 00       	push   $0x380
f010220a:	68 61 87 10 f0       	push   $0xf0108761
f010220f:	e8 35 de ff ff       	call   f0100049 <_panic>
	assert(pp1 && pp1 != pp0);
f0102214:	68 83 89 10 f0       	push   $0xf0108983
f0102219:	68 a2 87 10 f0       	push   $0xf01087a2
f010221e:	68 83 03 00 00       	push   $0x383
f0102223:	68 61 87 10 f0       	push   $0xf0108761
f0102228:	e8 1c de ff ff       	call   f0100049 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f010222d:	68 58 7f 10 f0       	push   $0xf0107f58
f0102232:	68 a2 87 10 f0       	push   $0xf01087a2
f0102237:	68 84 03 00 00       	push   $0x384
f010223c:	68 61 87 10 f0       	push   $0xf0108761
f0102241:	e8 03 de ff ff       	call   f0100049 <_panic>
	assert(page2pa(pp0) < npages*PGSIZE);
f0102246:	68 95 89 10 f0       	push   $0xf0108995
f010224b:	68 a2 87 10 f0       	push   $0xf01087a2
f0102250:	68 85 03 00 00       	push   $0x385
f0102255:	68 61 87 10 f0       	push   $0xf0108761
f010225a:	e8 ea dd ff ff       	call   f0100049 <_panic>
	assert(page2pa(pp1) < npages*PGSIZE);
f010225f:	68 b2 89 10 f0       	push   $0xf01089b2
f0102264:	68 a2 87 10 f0       	push   $0xf01087a2
f0102269:	68 86 03 00 00       	push   $0x386
f010226e:	68 61 87 10 f0       	push   $0xf0108761
f0102273:	e8 d1 dd ff ff       	call   f0100049 <_panic>
	assert(page2pa(pp2) < npages*PGSIZE);
f0102278:	68 cf 89 10 f0       	push   $0xf01089cf
f010227d:	68 a2 87 10 f0       	push   $0xf01087a2
f0102282:	68 87 03 00 00       	push   $0x387
f0102287:	68 61 87 10 f0       	push   $0xf0108761
f010228c:	e8 b8 dd ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f0102291:	68 ec 89 10 f0       	push   $0xf01089ec
f0102296:	68 a2 87 10 f0       	push   $0xf01087a2
f010229b:	68 8e 03 00 00       	push   $0x38e
f01022a0:	68 61 87 10 f0       	push   $0xf0108761
f01022a5:	e8 9f dd ff ff       	call   f0100049 <_panic>
	assert((pp0 = page_alloc(0)));
f01022aa:	68 41 89 10 f0       	push   $0xf0108941
f01022af:	68 a2 87 10 f0       	push   $0xf01087a2
f01022b4:	68 95 03 00 00       	push   $0x395
f01022b9:	68 61 87 10 f0       	push   $0xf0108761
f01022be:	e8 86 dd ff ff       	call   f0100049 <_panic>
	assert((pp1 = page_alloc(0)));
f01022c3:	68 57 89 10 f0       	push   $0xf0108957
f01022c8:	68 a2 87 10 f0       	push   $0xf01087a2
f01022cd:	68 96 03 00 00       	push   $0x396
f01022d2:	68 61 87 10 f0       	push   $0xf0108761
f01022d7:	e8 6d dd ff ff       	call   f0100049 <_panic>
	assert((pp2 = page_alloc(0)));
f01022dc:	68 6d 89 10 f0       	push   $0xf010896d
f01022e1:	68 a2 87 10 f0       	push   $0xf01087a2
f01022e6:	68 97 03 00 00       	push   $0x397
f01022eb:	68 61 87 10 f0       	push   $0xf0108761
f01022f0:	e8 54 dd ff ff       	call   f0100049 <_panic>
	assert(pp1 && pp1 != pp0);
f01022f5:	68 83 89 10 f0       	push   $0xf0108983
f01022fa:	68 a2 87 10 f0       	push   $0xf01087a2
f01022ff:	68 99 03 00 00       	push   $0x399
f0102304:	68 61 87 10 f0       	push   $0xf0108761
f0102309:	e8 3b dd ff ff       	call   f0100049 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f010230e:	68 58 7f 10 f0       	push   $0xf0107f58
f0102313:	68 a2 87 10 f0       	push   $0xf01087a2
f0102318:	68 9a 03 00 00       	push   $0x39a
f010231d:	68 61 87 10 f0       	push   $0xf0108761
f0102322:	e8 22 dd ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f0102327:	68 ec 89 10 f0       	push   $0xf01089ec
f010232c:	68 a2 87 10 f0       	push   $0xf01087a2
f0102331:	68 9b 03 00 00       	push   $0x39b
f0102336:	68 61 87 10 f0       	push   $0xf0108761
f010233b:	e8 09 dd ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102340:	50                   	push   %eax
f0102341:	68 54 74 10 f0       	push   $0xf0107454
f0102346:	6a 58                	push   $0x58
f0102348:	68 88 87 10 f0       	push   $0xf0108788
f010234d:	e8 f7 dc ff ff       	call   f0100049 <_panic>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0102352:	68 fb 89 10 f0       	push   $0xf01089fb
f0102357:	68 a2 87 10 f0       	push   $0xf01087a2
f010235c:	68 a0 03 00 00       	push   $0x3a0
f0102361:	68 61 87 10 f0       	push   $0xf0108761
f0102366:	e8 de dc ff ff       	call   f0100049 <_panic>
	assert(pp && pp0 == pp);
f010236b:	68 19 8a 10 f0       	push   $0xf0108a19
f0102370:	68 a2 87 10 f0       	push   $0xf01087a2
f0102375:	68 a1 03 00 00       	push   $0x3a1
f010237a:	68 61 87 10 f0       	push   $0xf0108761
f010237f:	e8 c5 dc ff ff       	call   f0100049 <_panic>
f0102384:	50                   	push   %eax
f0102385:	68 54 74 10 f0       	push   $0xf0107454
f010238a:	6a 58                	push   $0x58
f010238c:	68 88 87 10 f0       	push   $0xf0108788
f0102391:	e8 b3 dc ff ff       	call   f0100049 <_panic>
		assert(c[i] == 0);
f0102396:	68 29 8a 10 f0       	push   $0xf0108a29
f010239b:	68 a2 87 10 f0       	push   $0xf01087a2
f01023a0:	68 a4 03 00 00       	push   $0x3a4
f01023a5:	68 61 87 10 f0       	push   $0xf0108761
f01023aa:	e8 9a dc ff ff       	call   f0100049 <_panic>
		--nfree;
f01023af:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link)
f01023b3:	8b 00                	mov    (%eax),%eax
f01023b5:	85 c0                	test   %eax,%eax
f01023b7:	75 f6                	jne    f01023af <mem_init+0x53e>
	assert(nfree == 0);
f01023b9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f01023bd:	0f 85 61 09 00 00    	jne    f0102d24 <mem_init+0xeb3>
	cprintf("check_page_alloc() succeeded!\n");
f01023c3:	83 ec 0c             	sub    $0xc,%esp
f01023c6:	68 78 7f 10 f0       	push   $0xf0107f78
f01023cb:	e8 19 22 00 00       	call   f01045e9 <cprintf>
	int i;
	extern pde_t entry_pgdir[];

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f01023d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01023d7:	e8 1f f5 ff ff       	call   f01018fb <page_alloc>
f01023dc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01023df:	83 c4 10             	add    $0x10,%esp
f01023e2:	85 c0                	test   %eax,%eax
f01023e4:	0f 84 53 09 00 00    	je     f0102d3d <mem_init+0xecc>
	assert((pp1 = page_alloc(0)));
f01023ea:	83 ec 0c             	sub    $0xc,%esp
f01023ed:	6a 00                	push   $0x0
f01023ef:	e8 07 f5 ff ff       	call   f01018fb <page_alloc>
f01023f4:	89 c7                	mov    %eax,%edi
f01023f6:	83 c4 10             	add    $0x10,%esp
f01023f9:	85 c0                	test   %eax,%eax
f01023fb:	0f 84 55 09 00 00    	je     f0102d56 <mem_init+0xee5>
	assert((pp2 = page_alloc(0)));
f0102401:	83 ec 0c             	sub    $0xc,%esp
f0102404:	6a 00                	push   $0x0
f0102406:	e8 f0 f4 ff ff       	call   f01018fb <page_alloc>
f010240b:	89 c3                	mov    %eax,%ebx
f010240d:	83 c4 10             	add    $0x10,%esp
f0102410:	85 c0                	test   %eax,%eax
f0102412:	0f 84 57 09 00 00    	je     f0102d6f <mem_init+0xefe>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0102418:	39 7d d4             	cmp    %edi,-0x2c(%ebp)
f010241b:	0f 84 67 09 00 00    	je     f0102d88 <mem_init+0xf17>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0102421:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f0102424:	0f 84 77 09 00 00    	je     f0102da1 <mem_init+0xf30>
f010242a:	39 c7                	cmp    %eax,%edi
f010242c:	0f 84 6f 09 00 00    	je     f0102da1 <mem_init+0xf30>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0102432:	a1 40 42 34 f0       	mov    0xf0344240,%eax
f0102437:	89 45 cc             	mov    %eax,-0x34(%ebp)
	page_free_list = 0;
f010243a:	c7 05 40 42 34 f0 00 	movl   $0x0,0xf0344240
f0102441:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f0102444:	83 ec 0c             	sub    $0xc,%esp
f0102447:	6a 00                	push   $0x0
f0102449:	e8 ad f4 ff ff       	call   f01018fb <page_alloc>
f010244e:	83 c4 10             	add    $0x10,%esp
f0102451:	85 c0                	test   %eax,%eax
f0102453:	0f 85 61 09 00 00    	jne    f0102dba <mem_init+0xf49>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0102459:	83 ec 04             	sub    $0x4,%esp
f010245c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010245f:	50                   	push   %eax
f0102460:	6a 00                	push   $0x0
f0102462:	ff 35 8c 5e 34 f0    	pushl  0xf0345e8c
f0102468:	e8 e1 f7 ff ff       	call   f0101c4e <page_lookup>
f010246d:	83 c4 10             	add    $0x10,%esp
f0102470:	85 c0                	test   %eax,%eax
f0102472:	0f 85 5b 09 00 00    	jne    f0102dd3 <mem_init+0xf62>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0102478:	6a 02                	push   $0x2
f010247a:	6a 00                	push   $0x0
f010247c:	57                   	push   %edi
f010247d:	ff 35 8c 5e 34 f0    	pushl  0xf0345e8c
f0102483:	e8 ea f8 ff ff       	call   f0101d72 <page_insert>
f0102488:	83 c4 10             	add    $0x10,%esp
f010248b:	85 c0                	test   %eax,%eax
f010248d:	0f 89 59 09 00 00    	jns    f0102dec <mem_init+0xf7b>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f0102493:	83 ec 0c             	sub    $0xc,%esp
f0102496:	ff 75 d4             	pushl  -0x2c(%ebp)
f0102499:	e8 cf f4 ff ff       	call   f010196d <page_free>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f010249e:	6a 02                	push   $0x2
f01024a0:	6a 00                	push   $0x0
f01024a2:	57                   	push   %edi
f01024a3:	ff 35 8c 5e 34 f0    	pushl  0xf0345e8c
f01024a9:	e8 c4 f8 ff ff       	call   f0101d72 <page_insert>
f01024ae:	83 c4 20             	add    $0x20,%esp
f01024b1:	85 c0                	test   %eax,%eax
f01024b3:	0f 85 4c 09 00 00    	jne    f0102e05 <mem_init+0xf94>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01024b9:	8b 35 8c 5e 34 f0    	mov    0xf0345e8c,%esi
	return (pp - pages) << PGSHIFT;
f01024bf:	8b 0d 90 5e 34 f0    	mov    0xf0345e90,%ecx
f01024c5:	89 4d d0             	mov    %ecx,-0x30(%ebp)
f01024c8:	8b 16                	mov    (%esi),%edx
f01024ca:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f01024d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01024d3:	29 c8                	sub    %ecx,%eax
f01024d5:	c1 f8 03             	sar    $0x3,%eax
f01024d8:	c1 e0 0c             	shl    $0xc,%eax
f01024db:	39 c2                	cmp    %eax,%edx
f01024dd:	0f 85 3b 09 00 00    	jne    f0102e1e <mem_init+0xfad>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f01024e3:	ba 00 00 00 00       	mov    $0x0,%edx
f01024e8:	89 f0                	mov    %esi,%eax
f01024ea:	e8 7b ef ff ff       	call   f010146a <check_va2pa>
f01024ef:	89 fa                	mov    %edi,%edx
f01024f1:	2b 55 d0             	sub    -0x30(%ebp),%edx
f01024f4:	c1 fa 03             	sar    $0x3,%edx
f01024f7:	c1 e2 0c             	shl    $0xc,%edx
f01024fa:	39 d0                	cmp    %edx,%eax
f01024fc:	0f 85 35 09 00 00    	jne    f0102e37 <mem_init+0xfc6>
	assert(pp1->pp_ref == 1);
f0102502:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0102507:	0f 85 43 09 00 00    	jne    f0102e50 <mem_init+0xfdf>
	assert(pp0->pp_ref == 1);
f010250d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102510:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0102515:	0f 85 4e 09 00 00    	jne    f0102e69 <mem_init+0xff8>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f010251b:	6a 02                	push   $0x2
f010251d:	68 00 10 00 00       	push   $0x1000
f0102522:	53                   	push   %ebx
f0102523:	56                   	push   %esi
f0102524:	e8 49 f8 ff ff       	call   f0101d72 <page_insert>
f0102529:	83 c4 10             	add    $0x10,%esp
f010252c:	85 c0                	test   %eax,%eax
f010252e:	0f 85 4e 09 00 00    	jne    f0102e82 <mem_init+0x1011>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102534:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102539:	a1 8c 5e 34 f0       	mov    0xf0345e8c,%eax
f010253e:	e8 27 ef ff ff       	call   f010146a <check_va2pa>
f0102543:	89 da                	mov    %ebx,%edx
f0102545:	2b 15 90 5e 34 f0    	sub    0xf0345e90,%edx
f010254b:	c1 fa 03             	sar    $0x3,%edx
f010254e:	c1 e2 0c             	shl    $0xc,%edx
f0102551:	39 d0                	cmp    %edx,%eax
f0102553:	0f 85 42 09 00 00    	jne    f0102e9b <mem_init+0x102a>
	assert(pp2->pp_ref == 1);
f0102559:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f010255e:	0f 85 50 09 00 00    	jne    f0102eb4 <mem_init+0x1043>

	// should be no free memory
	assert(!page_alloc(0));
f0102564:	83 ec 0c             	sub    $0xc,%esp
f0102567:	6a 00                	push   $0x0
f0102569:	e8 8d f3 ff ff       	call   f01018fb <page_alloc>
f010256e:	83 c4 10             	add    $0x10,%esp
f0102571:	85 c0                	test   %eax,%eax
f0102573:	0f 85 54 09 00 00    	jne    f0102ecd <mem_init+0x105c>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102579:	6a 02                	push   $0x2
f010257b:	68 00 10 00 00       	push   $0x1000
f0102580:	53                   	push   %ebx
f0102581:	ff 35 8c 5e 34 f0    	pushl  0xf0345e8c
f0102587:	e8 e6 f7 ff ff       	call   f0101d72 <page_insert>
f010258c:	83 c4 10             	add    $0x10,%esp
f010258f:	85 c0                	test   %eax,%eax
f0102591:	0f 85 4f 09 00 00    	jne    f0102ee6 <mem_init+0x1075>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102597:	ba 00 10 00 00       	mov    $0x1000,%edx
f010259c:	a1 8c 5e 34 f0       	mov    0xf0345e8c,%eax
f01025a1:	e8 c4 ee ff ff       	call   f010146a <check_va2pa>
f01025a6:	89 da                	mov    %ebx,%edx
f01025a8:	2b 15 90 5e 34 f0    	sub    0xf0345e90,%edx
f01025ae:	c1 fa 03             	sar    $0x3,%edx
f01025b1:	c1 e2 0c             	shl    $0xc,%edx
f01025b4:	39 d0                	cmp    %edx,%eax
f01025b6:	0f 85 43 09 00 00    	jne    f0102eff <mem_init+0x108e>
	assert(pp2->pp_ref == 1);
f01025bc:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f01025c1:	0f 85 51 09 00 00    	jne    f0102f18 <mem_init+0x10a7>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
f01025c7:	83 ec 0c             	sub    $0xc,%esp
f01025ca:	6a 00                	push   $0x0
f01025cc:	e8 2a f3 ff ff       	call   f01018fb <page_alloc>
f01025d1:	83 c4 10             	add    $0x10,%esp
f01025d4:	85 c0                	test   %eax,%eax
f01025d6:	0f 85 55 09 00 00    	jne    f0102f31 <mem_init+0x10c0>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f01025dc:	8b 15 8c 5e 34 f0    	mov    0xf0345e8c,%edx
f01025e2:	8b 02                	mov    (%edx),%eax
f01025e4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f01025e9:	89 c1                	mov    %eax,%ecx
f01025eb:	c1 e9 0c             	shr    $0xc,%ecx
f01025ee:	3b 0d 88 5e 34 f0    	cmp    0xf0345e88,%ecx
f01025f4:	0f 83 50 09 00 00    	jae    f0102f4a <mem_init+0x10d9>
	return (void *)(pa + KERNBASE);
f01025fa:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01025ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0102602:	83 ec 04             	sub    $0x4,%esp
f0102605:	6a 00                	push   $0x0
f0102607:	68 00 10 00 00       	push   $0x1000
f010260c:	52                   	push   %edx
f010260d:	e8 f1 f3 ff ff       	call   f0101a03 <pgdir_walk>
f0102612:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0102615:	8d 51 04             	lea    0x4(%ecx),%edx
f0102618:	83 c4 10             	add    $0x10,%esp
f010261b:	39 d0                	cmp    %edx,%eax
f010261d:	0f 85 3c 09 00 00    	jne    f0102f5f <mem_init+0x10ee>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0102623:	6a 06                	push   $0x6
f0102625:	68 00 10 00 00       	push   $0x1000
f010262a:	53                   	push   %ebx
f010262b:	ff 35 8c 5e 34 f0    	pushl  0xf0345e8c
f0102631:	e8 3c f7 ff ff       	call   f0101d72 <page_insert>
f0102636:	83 c4 10             	add    $0x10,%esp
f0102639:	85 c0                	test   %eax,%eax
f010263b:	0f 85 37 09 00 00    	jne    f0102f78 <mem_init+0x1107>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102641:	8b 35 8c 5e 34 f0    	mov    0xf0345e8c,%esi
f0102647:	ba 00 10 00 00       	mov    $0x1000,%edx
f010264c:	89 f0                	mov    %esi,%eax
f010264e:	e8 17 ee ff ff       	call   f010146a <check_va2pa>
	return (pp - pages) << PGSHIFT;
f0102653:	89 da                	mov    %ebx,%edx
f0102655:	2b 15 90 5e 34 f0    	sub    0xf0345e90,%edx
f010265b:	c1 fa 03             	sar    $0x3,%edx
f010265e:	c1 e2 0c             	shl    $0xc,%edx
f0102661:	39 d0                	cmp    %edx,%eax
f0102663:	0f 85 28 09 00 00    	jne    f0102f91 <mem_init+0x1120>
	assert(pp2->pp_ref == 1);
f0102669:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f010266e:	0f 85 36 09 00 00    	jne    f0102faa <mem_init+0x1139>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f0102674:	83 ec 04             	sub    $0x4,%esp
f0102677:	6a 00                	push   $0x0
f0102679:	68 00 10 00 00       	push   $0x1000
f010267e:	56                   	push   %esi
f010267f:	e8 7f f3 ff ff       	call   f0101a03 <pgdir_walk>
f0102684:	83 c4 10             	add    $0x10,%esp
f0102687:	f6 00 04             	testb  $0x4,(%eax)
f010268a:	0f 84 33 09 00 00    	je     f0102fc3 <mem_init+0x1152>
	assert(kern_pgdir[0] & PTE_U);
f0102690:	a1 8c 5e 34 f0       	mov    0xf0345e8c,%eax
f0102695:	f6 00 04             	testb  $0x4,(%eax)
f0102698:	0f 84 3e 09 00 00    	je     f0102fdc <mem_init+0x116b>

	// should be able to remap with fewer permissions
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f010269e:	6a 02                	push   $0x2
f01026a0:	68 00 10 00 00       	push   $0x1000
f01026a5:	53                   	push   %ebx
f01026a6:	50                   	push   %eax
f01026a7:	e8 c6 f6 ff ff       	call   f0101d72 <page_insert>
f01026ac:	83 c4 10             	add    $0x10,%esp
f01026af:	85 c0                	test   %eax,%eax
f01026b1:	0f 85 3e 09 00 00    	jne    f0102ff5 <mem_init+0x1184>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f01026b7:	83 ec 04             	sub    $0x4,%esp
f01026ba:	6a 00                	push   $0x0
f01026bc:	68 00 10 00 00       	push   $0x1000
f01026c1:	ff 35 8c 5e 34 f0    	pushl  0xf0345e8c
f01026c7:	e8 37 f3 ff ff       	call   f0101a03 <pgdir_walk>
f01026cc:	83 c4 10             	add    $0x10,%esp
f01026cf:	f6 00 02             	testb  $0x2,(%eax)
f01026d2:	0f 84 36 09 00 00    	je     f010300e <mem_init+0x119d>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f01026d8:	83 ec 04             	sub    $0x4,%esp
f01026db:	6a 00                	push   $0x0
f01026dd:	68 00 10 00 00       	push   $0x1000
f01026e2:	ff 35 8c 5e 34 f0    	pushl  0xf0345e8c
f01026e8:	e8 16 f3 ff ff       	call   f0101a03 <pgdir_walk>
f01026ed:	83 c4 10             	add    $0x10,%esp
f01026f0:	f6 00 04             	testb  $0x4,(%eax)
f01026f3:	0f 85 2e 09 00 00    	jne    f0103027 <mem_init+0x11b6>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f01026f9:	6a 02                	push   $0x2
f01026fb:	68 00 00 40 00       	push   $0x400000
f0102700:	ff 75 d4             	pushl  -0x2c(%ebp)
f0102703:	ff 35 8c 5e 34 f0    	pushl  0xf0345e8c
f0102709:	e8 64 f6 ff ff       	call   f0101d72 <page_insert>
f010270e:	83 c4 10             	add    $0x10,%esp
f0102711:	85 c0                	test   %eax,%eax
f0102713:	0f 89 27 09 00 00    	jns    f0103040 <mem_init+0x11cf>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0102719:	6a 02                	push   $0x2
f010271b:	68 00 10 00 00       	push   $0x1000
f0102720:	57                   	push   %edi
f0102721:	ff 35 8c 5e 34 f0    	pushl  0xf0345e8c
f0102727:	e8 46 f6 ff ff       	call   f0101d72 <page_insert>
f010272c:	83 c4 10             	add    $0x10,%esp
f010272f:	85 c0                	test   %eax,%eax
f0102731:	0f 85 22 09 00 00    	jne    f0103059 <mem_init+0x11e8>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0102737:	83 ec 04             	sub    $0x4,%esp
f010273a:	6a 00                	push   $0x0
f010273c:	68 00 10 00 00       	push   $0x1000
f0102741:	ff 35 8c 5e 34 f0    	pushl  0xf0345e8c
f0102747:	e8 b7 f2 ff ff       	call   f0101a03 <pgdir_walk>
f010274c:	83 c4 10             	add    $0x10,%esp
f010274f:	f6 00 04             	testb  $0x4,(%eax)
f0102752:	0f 85 1a 09 00 00    	jne    f0103072 <mem_init+0x1201>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0102758:	a1 8c 5e 34 f0       	mov    0xf0345e8c,%eax
f010275d:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0102760:	ba 00 00 00 00       	mov    $0x0,%edx
f0102765:	e8 00 ed ff ff       	call   f010146a <check_va2pa>
f010276a:	89 fe                	mov    %edi,%esi
f010276c:	2b 35 90 5e 34 f0    	sub    0xf0345e90,%esi
f0102772:	c1 fe 03             	sar    $0x3,%esi
f0102775:	c1 e6 0c             	shl    $0xc,%esi
f0102778:	39 f0                	cmp    %esi,%eax
f010277a:	0f 85 0b 09 00 00    	jne    f010308b <mem_init+0x121a>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102780:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102785:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102788:	e8 dd ec ff ff       	call   f010146a <check_va2pa>
f010278d:	39 c6                	cmp    %eax,%esi
f010278f:	0f 85 0f 09 00 00    	jne    f01030a4 <mem_init+0x1233>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f0102795:	66 83 7f 04 02       	cmpw   $0x2,0x4(%edi)
f010279a:	0f 85 1d 09 00 00    	jne    f01030bd <mem_init+0x124c>
	assert(pp2->pp_ref == 0);
f01027a0:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f01027a5:	0f 85 2b 09 00 00    	jne    f01030d6 <mem_init+0x1265>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp2);
f01027ab:	83 ec 0c             	sub    $0xc,%esp
f01027ae:	6a 00                	push   $0x0
f01027b0:	e8 46 f1 ff ff       	call   f01018fb <page_alloc>
f01027b5:	83 c4 10             	add    $0x10,%esp
f01027b8:	85 c0                	test   %eax,%eax
f01027ba:	0f 84 2f 09 00 00    	je     f01030ef <mem_init+0x127e>
f01027c0:	39 c3                	cmp    %eax,%ebx
f01027c2:	0f 85 27 09 00 00    	jne    f01030ef <mem_init+0x127e>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f01027c8:	83 ec 08             	sub    $0x8,%esp
f01027cb:	6a 00                	push   $0x0
f01027cd:	ff 35 8c 5e 34 f0    	pushl  0xf0345e8c
f01027d3:	e8 36 f5 ff ff       	call   f0101d0e <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01027d8:	8b 35 8c 5e 34 f0    	mov    0xf0345e8c,%esi
f01027de:	ba 00 00 00 00       	mov    $0x0,%edx
f01027e3:	89 f0                	mov    %esi,%eax
f01027e5:	e8 80 ec ff ff       	call   f010146a <check_va2pa>
f01027ea:	83 c4 10             	add    $0x10,%esp
f01027ed:	83 f8 ff             	cmp    $0xffffffff,%eax
f01027f0:	0f 85 12 09 00 00    	jne    f0103108 <mem_init+0x1297>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01027f6:	ba 00 10 00 00       	mov    $0x1000,%edx
f01027fb:	89 f0                	mov    %esi,%eax
f01027fd:	e8 68 ec ff ff       	call   f010146a <check_va2pa>
f0102802:	89 fa                	mov    %edi,%edx
f0102804:	2b 15 90 5e 34 f0    	sub    0xf0345e90,%edx
f010280a:	c1 fa 03             	sar    $0x3,%edx
f010280d:	c1 e2 0c             	shl    $0xc,%edx
f0102810:	39 d0                	cmp    %edx,%eax
f0102812:	0f 85 09 09 00 00    	jne    f0103121 <mem_init+0x12b0>
	assert(pp1->pp_ref == 1);
f0102818:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f010281d:	0f 85 17 09 00 00    	jne    f010313a <mem_init+0x12c9>
	assert(pp2->pp_ref == 0);
f0102823:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0102828:	0f 85 25 09 00 00    	jne    f0103153 <mem_init+0x12e2>

	// test re-inserting pp1 at PGSIZE
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f010282e:	6a 00                	push   $0x0
f0102830:	68 00 10 00 00       	push   $0x1000
f0102835:	57                   	push   %edi
f0102836:	56                   	push   %esi
f0102837:	e8 36 f5 ff ff       	call   f0101d72 <page_insert>
f010283c:	83 c4 10             	add    $0x10,%esp
f010283f:	85 c0                	test   %eax,%eax
f0102841:	0f 85 25 09 00 00    	jne    f010316c <mem_init+0x12fb>
	assert(pp1->pp_ref);
f0102847:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f010284c:	0f 84 33 09 00 00    	je     f0103185 <mem_init+0x1314>
	assert(pp1->pp_link == NULL);
f0102852:	83 3f 00             	cmpl   $0x0,(%edi)
f0102855:	0f 85 43 09 00 00    	jne    f010319e <mem_init+0x132d>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, (void*) PGSIZE);
f010285b:	83 ec 08             	sub    $0x8,%esp
f010285e:	68 00 10 00 00       	push   $0x1000
f0102863:	ff 35 8c 5e 34 f0    	pushl  0xf0345e8c
f0102869:	e8 a0 f4 ff ff       	call   f0101d0e <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f010286e:	8b 35 8c 5e 34 f0    	mov    0xf0345e8c,%esi
f0102874:	ba 00 00 00 00       	mov    $0x0,%edx
f0102879:	89 f0                	mov    %esi,%eax
f010287b:	e8 ea eb ff ff       	call   f010146a <check_va2pa>
f0102880:	83 c4 10             	add    $0x10,%esp
f0102883:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102886:	0f 85 2b 09 00 00    	jne    f01031b7 <mem_init+0x1346>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f010288c:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102891:	89 f0                	mov    %esi,%eax
f0102893:	e8 d2 eb ff ff       	call   f010146a <check_va2pa>
f0102898:	83 f8 ff             	cmp    $0xffffffff,%eax
f010289b:	0f 85 2f 09 00 00    	jne    f01031d0 <mem_init+0x135f>
	assert(pp1->pp_ref == 0);
f01028a1:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f01028a6:	0f 85 3d 09 00 00    	jne    f01031e9 <mem_init+0x1378>
	assert(pp2->pp_ref == 0);
f01028ac:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f01028b1:	0f 85 4b 09 00 00    	jne    f0103202 <mem_init+0x1391>

	// so it should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp1);
f01028b7:	83 ec 0c             	sub    $0xc,%esp
f01028ba:	6a 00                	push   $0x0
f01028bc:	e8 3a f0 ff ff       	call   f01018fb <page_alloc>
f01028c1:	83 c4 10             	add    $0x10,%esp
f01028c4:	39 c7                	cmp    %eax,%edi
f01028c6:	0f 85 4f 09 00 00    	jne    f010321b <mem_init+0x13aa>
f01028cc:	85 c0                	test   %eax,%eax
f01028ce:	0f 84 47 09 00 00    	je     f010321b <mem_init+0x13aa>

	// should be no free memory
	assert(!page_alloc(0));
f01028d4:	83 ec 0c             	sub    $0xc,%esp
f01028d7:	6a 00                	push   $0x0
f01028d9:	e8 1d f0 ff ff       	call   f01018fb <page_alloc>
f01028de:	83 c4 10             	add    $0x10,%esp
f01028e1:	85 c0                	test   %eax,%eax
f01028e3:	0f 85 4b 09 00 00    	jne    f0103234 <mem_init+0x13c3>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01028e9:	8b 0d 8c 5e 34 f0    	mov    0xf0345e8c,%ecx
f01028ef:	8b 11                	mov    (%ecx),%edx
f01028f1:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f01028f7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01028fa:	2b 05 90 5e 34 f0    	sub    0xf0345e90,%eax
f0102900:	c1 f8 03             	sar    $0x3,%eax
f0102903:	c1 e0 0c             	shl    $0xc,%eax
f0102906:	39 c2                	cmp    %eax,%edx
f0102908:	0f 85 3f 09 00 00    	jne    f010324d <mem_init+0x13dc>
	kern_pgdir[0] = 0;
f010290e:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0102914:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102917:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f010291c:	0f 85 44 09 00 00    	jne    f0103266 <mem_init+0x13f5>
	pp0->pp_ref = 0;
f0102922:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102925:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f010292b:	83 ec 0c             	sub    $0xc,%esp
f010292e:	50                   	push   %eax
f010292f:	e8 39 f0 ff ff       	call   f010196d <page_free>
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f0102934:	83 c4 0c             	add    $0xc,%esp
f0102937:	6a 01                	push   $0x1
f0102939:	68 00 10 40 00       	push   $0x401000
f010293e:	ff 35 8c 5e 34 f0    	pushl  0xf0345e8c
f0102944:	e8 ba f0 ff ff       	call   f0101a03 <pgdir_walk>
f0102949:	89 c1                	mov    %eax,%ecx
f010294b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f010294e:	a1 8c 5e 34 f0       	mov    0xf0345e8c,%eax
f0102953:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0102956:	8b 40 04             	mov    0x4(%eax),%eax
f0102959:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f010295e:	8b 35 88 5e 34 f0    	mov    0xf0345e88,%esi
f0102964:	89 c2                	mov    %eax,%edx
f0102966:	c1 ea 0c             	shr    $0xc,%edx
f0102969:	83 c4 10             	add    $0x10,%esp
f010296c:	39 f2                	cmp    %esi,%edx
f010296e:	0f 83 0b 09 00 00    	jae    f010327f <mem_init+0x140e>
	assert(ptep == ptep1 + PTX(va));
f0102974:	2d fc ff ff 0f       	sub    $0xffffffc,%eax
f0102979:	39 c1                	cmp    %eax,%ecx
f010297b:	0f 85 13 09 00 00    	jne    f0103294 <mem_init+0x1423>
	kern_pgdir[PDX(va)] = 0;
f0102981:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102984:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	pp0->pp_ref = 0;
f010298b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010298e:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0102994:	2b 05 90 5e 34 f0    	sub    0xf0345e90,%eax
f010299a:	c1 f8 03             	sar    $0x3,%eax
f010299d:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01029a0:	89 c2                	mov    %eax,%edx
f01029a2:	c1 ea 0c             	shr    $0xc,%edx
f01029a5:	39 d6                	cmp    %edx,%esi
f01029a7:	0f 86 00 09 00 00    	jbe    f01032ad <mem_init+0x143c>

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f01029ad:	83 ec 04             	sub    $0x4,%esp
f01029b0:	68 00 10 00 00       	push   $0x1000
f01029b5:	68 ff 00 00 00       	push   $0xff
	return (void *)(pa + KERNBASE);
f01029ba:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01029bf:	50                   	push   %eax
f01029c0:	e8 cf 3d 00 00       	call   f0106794 <memset>
	page_free(pp0);
f01029c5:	8b 75 d4             	mov    -0x2c(%ebp),%esi
f01029c8:	89 34 24             	mov    %esi,(%esp)
f01029cb:	e8 9d ef ff ff       	call   f010196d <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f01029d0:	83 c4 0c             	add    $0xc,%esp
f01029d3:	6a 01                	push   $0x1
f01029d5:	6a 00                	push   $0x0
f01029d7:	ff 35 8c 5e 34 f0    	pushl  0xf0345e8c
f01029dd:	e8 21 f0 ff ff       	call   f0101a03 <pgdir_walk>
	return (pp - pages) << PGSHIFT;
f01029e2:	89 f0                	mov    %esi,%eax
f01029e4:	2b 05 90 5e 34 f0    	sub    0xf0345e90,%eax
f01029ea:	c1 f8 03             	sar    $0x3,%eax
f01029ed:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01029f0:	89 c2                	mov    %eax,%edx
f01029f2:	c1 ea 0c             	shr    $0xc,%edx
f01029f5:	83 c4 10             	add    $0x10,%esp
f01029f8:	3b 15 88 5e 34 f0    	cmp    0xf0345e88,%edx
f01029fe:	0f 83 bb 08 00 00    	jae    f01032bf <mem_init+0x144e>
	return (void *)(pa + KERNBASE);
f0102a04:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
	ptep = (pte_t *) page2kva(pp0);
f0102a0a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0102a0d:	2d 00 f0 ff 0f       	sub    $0xffff000,%eax
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f0102a12:	f6 02 01             	testb  $0x1,(%edx)
f0102a15:	0f 85 b6 08 00 00    	jne    f01032d1 <mem_init+0x1460>
f0102a1b:	83 c2 04             	add    $0x4,%edx
	for(i=0; i<NPTENTRIES; i++)
f0102a1e:	39 c2                	cmp    %eax,%edx
f0102a20:	75 f0                	jne    f0102a12 <mem_init+0xba1>
	kern_pgdir[0] = 0;
f0102a22:	a1 8c 5e 34 f0       	mov    0xf0345e8c,%eax
f0102a27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f0102a2d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102a30:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// give free list back
	page_free_list = fl;
f0102a36:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0102a39:	89 0d 40 42 34 f0    	mov    %ecx,0xf0344240

	// free the pages we took
	page_free(pp0);
f0102a3f:	83 ec 0c             	sub    $0xc,%esp
f0102a42:	50                   	push   %eax
f0102a43:	e8 25 ef ff ff       	call   f010196d <page_free>
	page_free(pp1);
f0102a48:	89 3c 24             	mov    %edi,(%esp)
f0102a4b:	e8 1d ef ff ff       	call   f010196d <page_free>
	page_free(pp2);
f0102a50:	89 1c 24             	mov    %ebx,(%esp)
f0102a53:	e8 15 ef ff ff       	call   f010196d <page_free>

	// test mmio_map_region
	mm1 = (uintptr_t) mmio_map_region(0, 4097);
f0102a58:	83 c4 08             	add    $0x8,%esp
f0102a5b:	68 01 10 00 00       	push   $0x1001
f0102a60:	6a 00                	push   $0x0
f0102a62:	e8 97 f3 ff ff       	call   f0101dfe <mmio_map_region>
f0102a67:	89 c3                	mov    %eax,%ebx
	mm2 = (uintptr_t) mmio_map_region(0, 4096);
f0102a69:	83 c4 08             	add    $0x8,%esp
f0102a6c:	68 00 10 00 00       	push   $0x1000
f0102a71:	6a 00                	push   $0x0
f0102a73:	e8 86 f3 ff ff       	call   f0101dfe <mmio_map_region>
f0102a78:	89 c6                	mov    %eax,%esi
	// check that they're in the right region
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f0102a7a:	8d 83 00 20 00 00    	lea    0x2000(%ebx),%eax
f0102a80:	83 c4 10             	add    $0x10,%esp
f0102a83:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f0102a89:	0f 86 5b 08 00 00    	jbe    f01032ea <mem_init+0x1479>
f0102a8f:	3d ff ff bf ef       	cmp    $0xefbfffff,%eax
f0102a94:	0f 87 50 08 00 00    	ja     f01032ea <mem_init+0x1479>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f0102a9a:	8d 96 00 20 00 00    	lea    0x2000(%esi),%edx
f0102aa0:	81 fa ff ff bf ef    	cmp    $0xefbfffff,%edx
f0102aa6:	0f 87 57 08 00 00    	ja     f0103303 <mem_init+0x1492>
f0102aac:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f0102ab2:	0f 86 4b 08 00 00    	jbe    f0103303 <mem_init+0x1492>
	// check that they're page-aligned
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f0102ab8:	89 da                	mov    %ebx,%edx
f0102aba:	09 f2                	or     %esi,%edx
f0102abc:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f0102ac2:	0f 85 54 08 00 00    	jne    f010331c <mem_init+0x14ab>
	// check that they don't overlap
	assert(mm1 + 8192 <= mm2);
f0102ac8:	39 c6                	cmp    %eax,%esi
f0102aca:	0f 82 65 08 00 00    	jb     f0103335 <mem_init+0x14c4>
	// check page mappings
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f0102ad0:	8b 3d 8c 5e 34 f0    	mov    0xf0345e8c,%edi
f0102ad6:	89 da                	mov    %ebx,%edx
f0102ad8:	89 f8                	mov    %edi,%eax
f0102ada:	e8 8b e9 ff ff       	call   f010146a <check_va2pa>
f0102adf:	85 c0                	test   %eax,%eax
f0102ae1:	0f 85 67 08 00 00    	jne    f010334e <mem_init+0x14dd>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f0102ae7:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
f0102aed:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0102af0:	89 c2                	mov    %eax,%edx
f0102af2:	89 f8                	mov    %edi,%eax
f0102af4:	e8 71 e9 ff ff       	call   f010146a <check_va2pa>
f0102af9:	3d 00 10 00 00       	cmp    $0x1000,%eax
f0102afe:	0f 85 63 08 00 00    	jne    f0103367 <mem_init+0x14f6>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0102b04:	89 f2                	mov    %esi,%edx
f0102b06:	89 f8                	mov    %edi,%eax
f0102b08:	e8 5d e9 ff ff       	call   f010146a <check_va2pa>
f0102b0d:	85 c0                	test   %eax,%eax
f0102b0f:	0f 85 6b 08 00 00    	jne    f0103380 <mem_init+0x150f>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f0102b15:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
f0102b1b:	89 f8                	mov    %edi,%eax
f0102b1d:	e8 48 e9 ff ff       	call   f010146a <check_va2pa>
f0102b22:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102b25:	0f 85 6e 08 00 00    	jne    f0103399 <mem_init+0x1528>
	// check permissions
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f0102b2b:	83 ec 04             	sub    $0x4,%esp
f0102b2e:	6a 00                	push   $0x0
f0102b30:	53                   	push   %ebx
f0102b31:	57                   	push   %edi
f0102b32:	e8 cc ee ff ff       	call   f0101a03 <pgdir_walk>
f0102b37:	83 c4 10             	add    $0x10,%esp
f0102b3a:	f6 00 1a             	testb  $0x1a,(%eax)
f0102b3d:	0f 84 6f 08 00 00    	je     f01033b2 <mem_init+0x1541>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f0102b43:	83 ec 04             	sub    $0x4,%esp
f0102b46:	6a 00                	push   $0x0
f0102b48:	53                   	push   %ebx
f0102b49:	ff 35 8c 5e 34 f0    	pushl  0xf0345e8c
f0102b4f:	e8 af ee ff ff       	call   f0101a03 <pgdir_walk>
f0102b54:	83 c4 10             	add    $0x10,%esp
f0102b57:	f6 00 04             	testb  $0x4,(%eax)
f0102b5a:	0f 85 6b 08 00 00    	jne    f01033cb <mem_init+0x155a>
	// clear the mappings
	*pgdir_walk(kern_pgdir, (void*) mm1, 0) = 0;
f0102b60:	83 ec 04             	sub    $0x4,%esp
f0102b63:	6a 00                	push   $0x0
f0102b65:	53                   	push   %ebx
f0102b66:	ff 35 8c 5e 34 f0    	pushl  0xf0345e8c
f0102b6c:	e8 92 ee ff ff       	call   f0101a03 <pgdir_walk>
f0102b71:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm1 + PGSIZE, 0) = 0;
f0102b77:	83 c4 0c             	add    $0xc,%esp
f0102b7a:	6a 00                	push   $0x0
f0102b7c:	ff 75 d4             	pushl  -0x2c(%ebp)
f0102b7f:	ff 35 8c 5e 34 f0    	pushl  0xf0345e8c
f0102b85:	e8 79 ee ff ff       	call   f0101a03 <pgdir_walk>
f0102b8a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm2, 0) = 0;
f0102b90:	83 c4 0c             	add    $0xc,%esp
f0102b93:	6a 00                	push   $0x0
f0102b95:	56                   	push   %esi
f0102b96:	ff 35 8c 5e 34 f0    	pushl  0xf0345e8c
f0102b9c:	e8 62 ee ff ff       	call   f0101a03 <pgdir_walk>
f0102ba1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("check_page() succeeded!\n");
f0102ba7:	c7 04 24 1c 8b 10 f0 	movl   $0xf0108b1c,(%esp)
f0102bae:	e8 36 1a 00 00       	call   f01045e9 <cprintf>
	boot_map_region(kern_pgdir, UPAGES, PTSIZE, PADDR(pages), PTE_U);
f0102bb3:	a1 90 5e 34 f0       	mov    0xf0345e90,%eax
	if ((uint32_t)kva < KERNBASE)
f0102bb8:	83 c4 10             	add    $0x10,%esp
f0102bbb:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102bc0:	0f 86 1e 08 00 00    	jbe    f01033e4 <mem_init+0x1573>
f0102bc6:	83 ec 08             	sub    $0x8,%esp
f0102bc9:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f0102bcb:	05 00 00 00 10       	add    $0x10000000,%eax
f0102bd0:	50                   	push   %eax
f0102bd1:	b9 00 00 40 00       	mov    $0x400000,%ecx
f0102bd6:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f0102bdb:	a1 8c 5e 34 f0       	mov    0xf0345e8c,%eax
f0102be0:	e8 02 ef ff ff       	call   f0101ae7 <boot_map_region>
	boot_map_region(kern_pgdir, UENVS, PTSIZE, PADDR(envs), PTE_U);
f0102be5:	a1 48 42 34 f0       	mov    0xf0344248,%eax
	if ((uint32_t)kva < KERNBASE)
f0102bea:	83 c4 10             	add    $0x10,%esp
f0102bed:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102bf2:	0f 86 01 08 00 00    	jbe    f01033f9 <mem_init+0x1588>
f0102bf8:	83 ec 08             	sub    $0x8,%esp
f0102bfb:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f0102bfd:	05 00 00 00 10       	add    $0x10000000,%eax
f0102c02:	50                   	push   %eax
f0102c03:	b9 00 00 40 00       	mov    $0x400000,%ecx
f0102c08:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f0102c0d:	a1 8c 5e 34 f0       	mov    0xf0345e8c,%eax
f0102c12:	e8 d0 ee ff ff       	call   f0101ae7 <boot_map_region>
	if ((uint32_t)kva < KERNBASE)
f0102c17:	83 c4 10             	add    $0x10,%esp
f0102c1a:	b8 00 c0 11 f0       	mov    $0xf011c000,%eax
f0102c1f:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102c24:	0f 86 e4 07 00 00    	jbe    f010340e <mem_init+0x159d>
	boot_map_region(kern_pgdir, KSTACKTOP - KSTKSIZE, KSTKSIZE, PADDR(bootstack), PTE_W);
f0102c2a:	83 ec 08             	sub    $0x8,%esp
f0102c2d:	6a 02                	push   $0x2
f0102c2f:	68 00 c0 11 00       	push   $0x11c000
f0102c34:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0102c39:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f0102c3e:	a1 8c 5e 34 f0       	mov    0xf0345e8c,%eax
f0102c43:	e8 9f ee ff ff       	call   f0101ae7 <boot_map_region>
	boot_map_region(kern_pgdir, KERNBASE, (size_t)(0-KERNBASE), 0, PTE_W);
f0102c48:	83 c4 08             	add    $0x8,%esp
f0102c4b:	6a 02                	push   $0x2
f0102c4d:	6a 00                	push   $0x0
f0102c4f:	b9 00 00 00 10       	mov    $0x10000000,%ecx
f0102c54:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0102c59:	a1 8c 5e 34 f0       	mov    0xf0345e8c,%eax
f0102c5e:	e8 84 ee ff ff       	call   f0101ae7 <boot_map_region>
f0102c63:	c7 45 d0 00 70 34 f0 	movl   $0xf0347000,-0x30(%ebp)
f0102c6a:	83 c4 10             	add    $0x10,%esp
f0102c6d:	bb 00 70 34 f0       	mov    $0xf0347000,%ebx
f0102c72:	be 00 80 ff ef       	mov    $0xefff8000,%esi
f0102c77:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0102c7d:	0f 86 a0 07 00 00    	jbe    f0103423 <mem_init+0x15b2>
		boot_map_region(kern_pgdir, va, KSTKSIZE, PADDR(percpu_kstacks[i]), PTE_W);
f0102c83:	83 ec 08             	sub    $0x8,%esp
f0102c86:	6a 02                	push   $0x2
f0102c88:	8d 83 00 00 00 10    	lea    0x10000000(%ebx),%eax
f0102c8e:	50                   	push   %eax
f0102c8f:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0102c94:	89 f2                	mov    %esi,%edx
f0102c96:	a1 8c 5e 34 f0       	mov    0xf0345e8c,%eax
f0102c9b:	e8 47 ee ff ff       	call   f0101ae7 <boot_map_region>
f0102ca0:	81 c3 00 80 00 00    	add    $0x8000,%ebx
f0102ca6:	81 ee 00 00 01 00    	sub    $0x10000,%esi
	for(i=0; i<NCPU; ++i){
f0102cac:	83 c4 10             	add    $0x10,%esp
f0102caf:	81 fb 00 70 38 f0    	cmp    $0xf0387000,%ebx
f0102cb5:	75 c0                	jne    f0102c77 <mem_init+0xe06>
	pgdir = kern_pgdir;
f0102cb7:	8b 3d 8c 5e 34 f0    	mov    0xf0345e8c,%edi
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f0102cbd:	a1 88 5e 34 f0       	mov    0xf0345e88,%eax
f0102cc2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f0102cc5:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f0102ccc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0102cd1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102cd4:	8b 35 90 5e 34 f0    	mov    0xf0345e90,%esi
f0102cda:	89 75 cc             	mov    %esi,-0x34(%ebp)
	return (physaddr_t)kva - KERNBASE;
f0102cdd:	8d 86 00 00 00 10    	lea    0x10000000(%esi),%eax
f0102ce3:	89 45 c8             	mov    %eax,-0x38(%ebp)
	for (i = 0; i < n; i += PGSIZE)
f0102ce6:	bb 00 00 00 00       	mov    $0x0,%ebx
f0102ceb:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
f0102cee:	0f 86 72 07 00 00    	jbe    f0103466 <mem_init+0x15f5>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102cf4:	8d 93 00 00 00 ef    	lea    -0x11000000(%ebx),%edx
f0102cfa:	89 f8                	mov    %edi,%eax
f0102cfc:	e8 69 e7 ff ff       	call   f010146a <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f0102d01:	81 7d cc ff ff ff ef 	cmpl   $0xefffffff,-0x34(%ebp)
f0102d08:	0f 86 2a 07 00 00    	jbe    f0103438 <mem_init+0x15c7>
f0102d0e:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f0102d11:	8d 14 0b             	lea    (%ebx,%ecx,1),%edx
f0102d14:	39 d0                	cmp    %edx,%eax
f0102d16:	0f 85 31 07 00 00    	jne    f010344d <mem_init+0x15dc>
	for (i = 0; i < n; i += PGSIZE)
f0102d1c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102d22:	eb c7                	jmp    f0102ceb <mem_init+0xe7a>
	assert(nfree == 0);
f0102d24:	68 33 8a 10 f0       	push   $0xf0108a33
f0102d29:	68 a2 87 10 f0       	push   $0xf01087a2
f0102d2e:	68 b1 03 00 00       	push   $0x3b1
f0102d33:	68 61 87 10 f0       	push   $0xf0108761
f0102d38:	e8 0c d3 ff ff       	call   f0100049 <_panic>
	assert((pp0 = page_alloc(0)));
f0102d3d:	68 41 89 10 f0       	push   $0xf0108941
f0102d42:	68 a2 87 10 f0       	push   $0xf01087a2
f0102d47:	68 26 04 00 00       	push   $0x426
f0102d4c:	68 61 87 10 f0       	push   $0xf0108761
f0102d51:	e8 f3 d2 ff ff       	call   f0100049 <_panic>
	assert((pp1 = page_alloc(0)));
f0102d56:	68 57 89 10 f0       	push   $0xf0108957
f0102d5b:	68 a2 87 10 f0       	push   $0xf01087a2
f0102d60:	68 27 04 00 00       	push   $0x427
f0102d65:	68 61 87 10 f0       	push   $0xf0108761
f0102d6a:	e8 da d2 ff ff       	call   f0100049 <_panic>
	assert((pp2 = page_alloc(0)));
f0102d6f:	68 6d 89 10 f0       	push   $0xf010896d
f0102d74:	68 a2 87 10 f0       	push   $0xf01087a2
f0102d79:	68 28 04 00 00       	push   $0x428
f0102d7e:	68 61 87 10 f0       	push   $0xf0108761
f0102d83:	e8 c1 d2 ff ff       	call   f0100049 <_panic>
	assert(pp1 && pp1 != pp0);
f0102d88:	68 83 89 10 f0       	push   $0xf0108983
f0102d8d:	68 a2 87 10 f0       	push   $0xf01087a2
f0102d92:	68 2b 04 00 00       	push   $0x42b
f0102d97:	68 61 87 10 f0       	push   $0xf0108761
f0102d9c:	e8 a8 d2 ff ff       	call   f0100049 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0102da1:	68 58 7f 10 f0       	push   $0xf0107f58
f0102da6:	68 a2 87 10 f0       	push   $0xf01087a2
f0102dab:	68 2c 04 00 00       	push   $0x42c
f0102db0:	68 61 87 10 f0       	push   $0xf0108761
f0102db5:	e8 8f d2 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f0102dba:	68 ec 89 10 f0       	push   $0xf01089ec
f0102dbf:	68 a2 87 10 f0       	push   $0xf01087a2
f0102dc4:	68 33 04 00 00       	push   $0x433
f0102dc9:	68 61 87 10 f0       	push   $0xf0108761
f0102dce:	e8 76 d2 ff ff       	call   f0100049 <_panic>
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0102dd3:	68 98 7f 10 f0       	push   $0xf0107f98
f0102dd8:	68 a2 87 10 f0       	push   $0xf01087a2
f0102ddd:	68 36 04 00 00       	push   $0x436
f0102de2:	68 61 87 10 f0       	push   $0xf0108761
f0102de7:	e8 5d d2 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0102dec:	68 d0 7f 10 f0       	push   $0xf0107fd0
f0102df1:	68 a2 87 10 f0       	push   $0xf01087a2
f0102df6:	68 39 04 00 00       	push   $0x439
f0102dfb:	68 61 87 10 f0       	push   $0xf0108761
f0102e00:	e8 44 d2 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0102e05:	68 00 80 10 f0       	push   $0xf0108000
f0102e0a:	68 a2 87 10 f0       	push   $0xf01087a2
f0102e0f:	68 3d 04 00 00       	push   $0x43d
f0102e14:	68 61 87 10 f0       	push   $0xf0108761
f0102e19:	e8 2b d2 ff ff       	call   f0100049 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102e1e:	68 30 80 10 f0       	push   $0xf0108030
f0102e23:	68 a2 87 10 f0       	push   $0xf01087a2
f0102e28:	68 3e 04 00 00       	push   $0x43e
f0102e2d:	68 61 87 10 f0       	push   $0xf0108761
f0102e32:	e8 12 d2 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0102e37:	68 58 80 10 f0       	push   $0xf0108058
f0102e3c:	68 a2 87 10 f0       	push   $0xf01087a2
f0102e41:	68 3f 04 00 00       	push   $0x43f
f0102e46:	68 61 87 10 f0       	push   $0xf0108761
f0102e4b:	e8 f9 d1 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 1);
f0102e50:	68 3e 8a 10 f0       	push   $0xf0108a3e
f0102e55:	68 a2 87 10 f0       	push   $0xf01087a2
f0102e5a:	68 40 04 00 00       	push   $0x440
f0102e5f:	68 61 87 10 f0       	push   $0xf0108761
f0102e64:	e8 e0 d1 ff ff       	call   f0100049 <_panic>
	assert(pp0->pp_ref == 1);
f0102e69:	68 4f 8a 10 f0       	push   $0xf0108a4f
f0102e6e:	68 a2 87 10 f0       	push   $0xf01087a2
f0102e73:	68 41 04 00 00       	push   $0x441
f0102e78:	68 61 87 10 f0       	push   $0xf0108761
f0102e7d:	e8 c7 d1 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102e82:	68 88 80 10 f0       	push   $0xf0108088
f0102e87:	68 a2 87 10 f0       	push   $0xf01087a2
f0102e8c:	68 44 04 00 00       	push   $0x444
f0102e91:	68 61 87 10 f0       	push   $0xf0108761
f0102e96:	e8 ae d1 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102e9b:	68 c4 80 10 f0       	push   $0xf01080c4
f0102ea0:	68 a2 87 10 f0       	push   $0xf01087a2
f0102ea5:	68 45 04 00 00       	push   $0x445
f0102eaa:	68 61 87 10 f0       	push   $0xf0108761
f0102eaf:	e8 95 d1 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 1);
f0102eb4:	68 60 8a 10 f0       	push   $0xf0108a60
f0102eb9:	68 a2 87 10 f0       	push   $0xf01087a2
f0102ebe:	68 46 04 00 00       	push   $0x446
f0102ec3:	68 61 87 10 f0       	push   $0xf0108761
f0102ec8:	e8 7c d1 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f0102ecd:	68 ec 89 10 f0       	push   $0xf01089ec
f0102ed2:	68 a2 87 10 f0       	push   $0xf01087a2
f0102ed7:	68 49 04 00 00       	push   $0x449
f0102edc:	68 61 87 10 f0       	push   $0xf0108761
f0102ee1:	e8 63 d1 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102ee6:	68 88 80 10 f0       	push   $0xf0108088
f0102eeb:	68 a2 87 10 f0       	push   $0xf01087a2
f0102ef0:	68 4c 04 00 00       	push   $0x44c
f0102ef5:	68 61 87 10 f0       	push   $0xf0108761
f0102efa:	e8 4a d1 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102eff:	68 c4 80 10 f0       	push   $0xf01080c4
f0102f04:	68 a2 87 10 f0       	push   $0xf01087a2
f0102f09:	68 4d 04 00 00       	push   $0x44d
f0102f0e:	68 61 87 10 f0       	push   $0xf0108761
f0102f13:	e8 31 d1 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 1);
f0102f18:	68 60 8a 10 f0       	push   $0xf0108a60
f0102f1d:	68 a2 87 10 f0       	push   $0xf01087a2
f0102f22:	68 4e 04 00 00       	push   $0x44e
f0102f27:	68 61 87 10 f0       	push   $0xf0108761
f0102f2c:	e8 18 d1 ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f0102f31:	68 ec 89 10 f0       	push   $0xf01089ec
f0102f36:	68 a2 87 10 f0       	push   $0xf01087a2
f0102f3b:	68 52 04 00 00       	push   $0x452
f0102f40:	68 61 87 10 f0       	push   $0xf0108761
f0102f45:	e8 ff d0 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102f4a:	50                   	push   %eax
f0102f4b:	68 54 74 10 f0       	push   $0xf0107454
f0102f50:	68 55 04 00 00       	push   $0x455
f0102f55:	68 61 87 10 f0       	push   $0xf0108761
f0102f5a:	e8 ea d0 ff ff       	call   f0100049 <_panic>
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0102f5f:	68 f4 80 10 f0       	push   $0xf01080f4
f0102f64:	68 a2 87 10 f0       	push   $0xf01087a2
f0102f69:	68 56 04 00 00       	push   $0x456
f0102f6e:	68 61 87 10 f0       	push   $0xf0108761
f0102f73:	e8 d1 d0 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0102f78:	68 34 81 10 f0       	push   $0xf0108134
f0102f7d:	68 a2 87 10 f0       	push   $0xf01087a2
f0102f82:	68 59 04 00 00       	push   $0x459
f0102f87:	68 61 87 10 f0       	push   $0xf0108761
f0102f8c:	e8 b8 d0 ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102f91:	68 c4 80 10 f0       	push   $0xf01080c4
f0102f96:	68 a2 87 10 f0       	push   $0xf01087a2
f0102f9b:	68 5a 04 00 00       	push   $0x45a
f0102fa0:	68 61 87 10 f0       	push   $0xf0108761
f0102fa5:	e8 9f d0 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 1);
f0102faa:	68 60 8a 10 f0       	push   $0xf0108a60
f0102faf:	68 a2 87 10 f0       	push   $0xf01087a2
f0102fb4:	68 5b 04 00 00       	push   $0x45b
f0102fb9:	68 61 87 10 f0       	push   $0xf0108761
f0102fbe:	e8 86 d0 ff ff       	call   f0100049 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f0102fc3:	68 74 81 10 f0       	push   $0xf0108174
f0102fc8:	68 a2 87 10 f0       	push   $0xf01087a2
f0102fcd:	68 5c 04 00 00       	push   $0x45c
f0102fd2:	68 61 87 10 f0       	push   $0xf0108761
f0102fd7:	e8 6d d0 ff ff       	call   f0100049 <_panic>
	assert(kern_pgdir[0] & PTE_U);
f0102fdc:	68 71 8a 10 f0       	push   $0xf0108a71
f0102fe1:	68 a2 87 10 f0       	push   $0xf01087a2
f0102fe6:	68 5d 04 00 00       	push   $0x45d
f0102feb:	68 61 87 10 f0       	push   $0xf0108761
f0102ff0:	e8 54 d0 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102ff5:	68 88 80 10 f0       	push   $0xf0108088
f0102ffa:	68 a2 87 10 f0       	push   $0xf01087a2
f0102fff:	68 60 04 00 00       	push   $0x460
f0103004:	68 61 87 10 f0       	push   $0xf0108761
f0103009:	e8 3b d0 ff ff       	call   f0100049 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f010300e:	68 a8 81 10 f0       	push   $0xf01081a8
f0103013:	68 a2 87 10 f0       	push   $0xf01087a2
f0103018:	68 61 04 00 00       	push   $0x461
f010301d:	68 61 87 10 f0       	push   $0xf0108761
f0103022:	e8 22 d0 ff ff       	call   f0100049 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0103027:	68 dc 81 10 f0       	push   $0xf01081dc
f010302c:	68 a2 87 10 f0       	push   $0xf01087a2
f0103031:	68 62 04 00 00       	push   $0x462
f0103036:	68 61 87 10 f0       	push   $0xf0108761
f010303b:	e8 09 d0 ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0103040:	68 14 82 10 f0       	push   $0xf0108214
f0103045:	68 a2 87 10 f0       	push   $0xf01087a2
f010304a:	68 65 04 00 00       	push   $0x465
f010304f:	68 61 87 10 f0       	push   $0xf0108761
f0103054:	e8 f0 cf ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0103059:	68 4c 82 10 f0       	push   $0xf010824c
f010305e:	68 a2 87 10 f0       	push   $0xf01087a2
f0103063:	68 68 04 00 00       	push   $0x468
f0103068:	68 61 87 10 f0       	push   $0xf0108761
f010306d:	e8 d7 cf ff ff       	call   f0100049 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0103072:	68 dc 81 10 f0       	push   $0xf01081dc
f0103077:	68 a2 87 10 f0       	push   $0xf01087a2
f010307c:	68 69 04 00 00       	push   $0x469
f0103081:	68 61 87 10 f0       	push   $0xf0108761
f0103086:	e8 be cf ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f010308b:	68 88 82 10 f0       	push   $0xf0108288
f0103090:	68 a2 87 10 f0       	push   $0xf01087a2
f0103095:	68 6c 04 00 00       	push   $0x46c
f010309a:	68 61 87 10 f0       	push   $0xf0108761
f010309f:	e8 a5 cf ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01030a4:	68 b4 82 10 f0       	push   $0xf01082b4
f01030a9:	68 a2 87 10 f0       	push   $0xf01087a2
f01030ae:	68 6d 04 00 00       	push   $0x46d
f01030b3:	68 61 87 10 f0       	push   $0xf0108761
f01030b8:	e8 8c cf ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 2);
f01030bd:	68 87 8a 10 f0       	push   $0xf0108a87
f01030c2:	68 a2 87 10 f0       	push   $0xf01087a2
f01030c7:	68 6f 04 00 00       	push   $0x46f
f01030cc:	68 61 87 10 f0       	push   $0xf0108761
f01030d1:	e8 73 cf ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 0);
f01030d6:	68 98 8a 10 f0       	push   $0xf0108a98
f01030db:	68 a2 87 10 f0       	push   $0xf01087a2
f01030e0:	68 70 04 00 00       	push   $0x470
f01030e5:	68 61 87 10 f0       	push   $0xf0108761
f01030ea:	e8 5a cf ff ff       	call   f0100049 <_panic>
	assert((pp = page_alloc(0)) && pp == pp2);
f01030ef:	68 e4 82 10 f0       	push   $0xf01082e4
f01030f4:	68 a2 87 10 f0       	push   $0xf01087a2
f01030f9:	68 73 04 00 00       	push   $0x473
f01030fe:	68 61 87 10 f0       	push   $0xf0108761
f0103103:	e8 41 cf ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0103108:	68 08 83 10 f0       	push   $0xf0108308
f010310d:	68 a2 87 10 f0       	push   $0xf01087a2
f0103112:	68 77 04 00 00       	push   $0x477
f0103117:	68 61 87 10 f0       	push   $0xf0108761
f010311c:	e8 28 cf ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0103121:	68 b4 82 10 f0       	push   $0xf01082b4
f0103126:	68 a2 87 10 f0       	push   $0xf01087a2
f010312b:	68 78 04 00 00       	push   $0x478
f0103130:	68 61 87 10 f0       	push   $0xf0108761
f0103135:	e8 0f cf ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 1);
f010313a:	68 3e 8a 10 f0       	push   $0xf0108a3e
f010313f:	68 a2 87 10 f0       	push   $0xf01087a2
f0103144:	68 79 04 00 00       	push   $0x479
f0103149:	68 61 87 10 f0       	push   $0xf0108761
f010314e:	e8 f6 ce ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 0);
f0103153:	68 98 8a 10 f0       	push   $0xf0108a98
f0103158:	68 a2 87 10 f0       	push   $0xf01087a2
f010315d:	68 7a 04 00 00       	push   $0x47a
f0103162:	68 61 87 10 f0       	push   $0xf0108761
f0103167:	e8 dd ce ff ff       	call   f0100049 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f010316c:	68 2c 83 10 f0       	push   $0xf010832c
f0103171:	68 a2 87 10 f0       	push   $0xf01087a2
f0103176:	68 7d 04 00 00       	push   $0x47d
f010317b:	68 61 87 10 f0       	push   $0xf0108761
f0103180:	e8 c4 ce ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref);
f0103185:	68 a9 8a 10 f0       	push   $0xf0108aa9
f010318a:	68 a2 87 10 f0       	push   $0xf01087a2
f010318f:	68 7e 04 00 00       	push   $0x47e
f0103194:	68 61 87 10 f0       	push   $0xf0108761
f0103199:	e8 ab ce ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_link == NULL);
f010319e:	68 b5 8a 10 f0       	push   $0xf0108ab5
f01031a3:	68 a2 87 10 f0       	push   $0xf01087a2
f01031a8:	68 7f 04 00 00       	push   $0x47f
f01031ad:	68 61 87 10 f0       	push   $0xf0108761
f01031b2:	e8 92 ce ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01031b7:	68 08 83 10 f0       	push   $0xf0108308
f01031bc:	68 a2 87 10 f0       	push   $0xf01087a2
f01031c1:	68 83 04 00 00       	push   $0x483
f01031c6:	68 61 87 10 f0       	push   $0xf0108761
f01031cb:	e8 79 ce ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f01031d0:	68 64 83 10 f0       	push   $0xf0108364
f01031d5:	68 a2 87 10 f0       	push   $0xf01087a2
f01031da:	68 84 04 00 00       	push   $0x484
f01031df:	68 61 87 10 f0       	push   $0xf0108761
f01031e4:	e8 60 ce ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 0);
f01031e9:	68 ca 8a 10 f0       	push   $0xf0108aca
f01031ee:	68 a2 87 10 f0       	push   $0xf01087a2
f01031f3:	68 85 04 00 00       	push   $0x485
f01031f8:	68 61 87 10 f0       	push   $0xf0108761
f01031fd:	e8 47 ce ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 0);
f0103202:	68 98 8a 10 f0       	push   $0xf0108a98
f0103207:	68 a2 87 10 f0       	push   $0xf01087a2
f010320c:	68 86 04 00 00       	push   $0x486
f0103211:	68 61 87 10 f0       	push   $0xf0108761
f0103216:	e8 2e ce ff ff       	call   f0100049 <_panic>
	assert((pp = page_alloc(0)) && pp == pp1);
f010321b:	68 8c 83 10 f0       	push   $0xf010838c
f0103220:	68 a2 87 10 f0       	push   $0xf01087a2
f0103225:	68 89 04 00 00       	push   $0x489
f010322a:	68 61 87 10 f0       	push   $0xf0108761
f010322f:	e8 15 ce ff ff       	call   f0100049 <_panic>
	assert(!page_alloc(0));
f0103234:	68 ec 89 10 f0       	push   $0xf01089ec
f0103239:	68 a2 87 10 f0       	push   $0xf01087a2
f010323e:	68 8c 04 00 00       	push   $0x48c
f0103243:	68 61 87 10 f0       	push   $0xf0108761
f0103248:	e8 fc cd ff ff       	call   f0100049 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f010324d:	68 30 80 10 f0       	push   $0xf0108030
f0103252:	68 a2 87 10 f0       	push   $0xf01087a2
f0103257:	68 8f 04 00 00       	push   $0x48f
f010325c:	68 61 87 10 f0       	push   $0xf0108761
f0103261:	e8 e3 cd ff ff       	call   f0100049 <_panic>
	assert(pp0->pp_ref == 1);
f0103266:	68 4f 8a 10 f0       	push   $0xf0108a4f
f010326b:	68 a2 87 10 f0       	push   $0xf01087a2
f0103270:	68 91 04 00 00       	push   $0x491
f0103275:	68 61 87 10 f0       	push   $0xf0108761
f010327a:	e8 ca cd ff ff       	call   f0100049 <_panic>
f010327f:	50                   	push   %eax
f0103280:	68 54 74 10 f0       	push   $0xf0107454
f0103285:	68 98 04 00 00       	push   $0x498
f010328a:	68 61 87 10 f0       	push   $0xf0108761
f010328f:	e8 b5 cd ff ff       	call   f0100049 <_panic>
	assert(ptep == ptep1 + PTX(va));
f0103294:	68 db 8a 10 f0       	push   $0xf0108adb
f0103299:	68 a2 87 10 f0       	push   $0xf01087a2
f010329e:	68 99 04 00 00       	push   $0x499
f01032a3:	68 61 87 10 f0       	push   $0xf0108761
f01032a8:	e8 9c cd ff ff       	call   f0100049 <_panic>
f01032ad:	50                   	push   %eax
f01032ae:	68 54 74 10 f0       	push   $0xf0107454
f01032b3:	6a 58                	push   $0x58
f01032b5:	68 88 87 10 f0       	push   $0xf0108788
f01032ba:	e8 8a cd ff ff       	call   f0100049 <_panic>
f01032bf:	50                   	push   %eax
f01032c0:	68 54 74 10 f0       	push   $0xf0107454
f01032c5:	6a 58                	push   $0x58
f01032c7:	68 88 87 10 f0       	push   $0xf0108788
f01032cc:	e8 78 cd ff ff       	call   f0100049 <_panic>
		assert((ptep[i] & PTE_P) == 0);
f01032d1:	68 f3 8a 10 f0       	push   $0xf0108af3
f01032d6:	68 a2 87 10 f0       	push   $0xf01087a2
f01032db:	68 a3 04 00 00       	push   $0x4a3
f01032e0:	68 61 87 10 f0       	push   $0xf0108761
f01032e5:	e8 5f cd ff ff       	call   f0100049 <_panic>
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f01032ea:	68 b0 83 10 f0       	push   $0xf01083b0
f01032ef:	68 a2 87 10 f0       	push   $0xf01087a2
f01032f4:	68 b3 04 00 00       	push   $0x4b3
f01032f9:	68 61 87 10 f0       	push   $0xf0108761
f01032fe:	e8 46 cd ff ff       	call   f0100049 <_panic>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f0103303:	68 d8 83 10 f0       	push   $0xf01083d8
f0103308:	68 a2 87 10 f0       	push   $0xf01087a2
f010330d:	68 b4 04 00 00       	push   $0x4b4
f0103312:	68 61 87 10 f0       	push   $0xf0108761
f0103317:	e8 2d cd ff ff       	call   f0100049 <_panic>
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f010331c:	68 00 84 10 f0       	push   $0xf0108400
f0103321:	68 a2 87 10 f0       	push   $0xf01087a2
f0103326:	68 b6 04 00 00       	push   $0x4b6
f010332b:	68 61 87 10 f0       	push   $0xf0108761
f0103330:	e8 14 cd ff ff       	call   f0100049 <_panic>
	assert(mm1 + 8192 <= mm2);
f0103335:	68 0a 8b 10 f0       	push   $0xf0108b0a
f010333a:	68 a2 87 10 f0       	push   $0xf01087a2
f010333f:	68 b8 04 00 00       	push   $0x4b8
f0103344:	68 61 87 10 f0       	push   $0xf0108761
f0103349:	e8 fb cc ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f010334e:	68 28 84 10 f0       	push   $0xf0108428
f0103353:	68 a2 87 10 f0       	push   $0xf01087a2
f0103358:	68 ba 04 00 00       	push   $0x4ba
f010335d:	68 61 87 10 f0       	push   $0xf0108761
f0103362:	e8 e2 cc ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f0103367:	68 4c 84 10 f0       	push   $0xf010844c
f010336c:	68 a2 87 10 f0       	push   $0xf01087a2
f0103371:	68 bb 04 00 00       	push   $0x4bb
f0103376:	68 61 87 10 f0       	push   $0xf0108761
f010337b:	e8 c9 cc ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0103380:	68 7c 84 10 f0       	push   $0xf010847c
f0103385:	68 a2 87 10 f0       	push   $0xf01087a2
f010338a:	68 bc 04 00 00       	push   $0x4bc
f010338f:	68 61 87 10 f0       	push   $0xf0108761
f0103394:	e8 b0 cc ff ff       	call   f0100049 <_panic>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f0103399:	68 a0 84 10 f0       	push   $0xf01084a0
f010339e:	68 a2 87 10 f0       	push   $0xf01087a2
f01033a3:	68 bd 04 00 00       	push   $0x4bd
f01033a8:	68 61 87 10 f0       	push   $0xf0108761
f01033ad:	e8 97 cc ff ff       	call   f0100049 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f01033b2:	68 cc 84 10 f0       	push   $0xf01084cc
f01033b7:	68 a2 87 10 f0       	push   $0xf01087a2
f01033bc:	68 bf 04 00 00       	push   $0x4bf
f01033c1:	68 61 87 10 f0       	push   $0xf0108761
f01033c6:	e8 7e cc ff ff       	call   f0100049 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f01033cb:	68 10 85 10 f0       	push   $0xf0108510
f01033d0:	68 a2 87 10 f0       	push   $0xf01087a2
f01033d5:	68 c0 04 00 00       	push   $0x4c0
f01033da:	68 61 87 10 f0       	push   $0xf0108761
f01033df:	e8 65 cc ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01033e4:	50                   	push   %eax
f01033e5:	68 78 74 10 f0       	push   $0xf0107478
f01033ea:	68 c9 00 00 00       	push   $0xc9
f01033ef:	68 61 87 10 f0       	push   $0xf0108761
f01033f4:	e8 50 cc ff ff       	call   f0100049 <_panic>
f01033f9:	50                   	push   %eax
f01033fa:	68 78 74 10 f0       	push   $0xf0107478
f01033ff:	68 d2 00 00 00       	push   $0xd2
f0103404:	68 61 87 10 f0       	push   $0xf0108761
f0103409:	e8 3b cc ff ff       	call   f0100049 <_panic>
f010340e:	50                   	push   %eax
f010340f:	68 78 74 10 f0       	push   $0xf0107478
f0103414:	68 df 00 00 00       	push   $0xdf
f0103419:	68 61 87 10 f0       	push   $0xf0108761
f010341e:	e8 26 cc ff ff       	call   f0100049 <_panic>
f0103423:	53                   	push   %ebx
f0103424:	68 78 74 10 f0       	push   $0xf0107478
f0103429:	68 25 01 00 00       	push   $0x125
f010342e:	68 61 87 10 f0       	push   $0xf0108761
f0103433:	e8 11 cc ff ff       	call   f0100049 <_panic>
f0103438:	56                   	push   %esi
f0103439:	68 78 74 10 f0       	push   $0xf0107478
f010343e:	68 c9 03 00 00       	push   $0x3c9
f0103443:	68 61 87 10 f0       	push   $0xf0108761
f0103448:	e8 fc cb ff ff       	call   f0100049 <_panic>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f010344d:	68 44 85 10 f0       	push   $0xf0108544
f0103452:	68 a2 87 10 f0       	push   $0xf01087a2
f0103457:	68 c9 03 00 00       	push   $0x3c9
f010345c:	68 61 87 10 f0       	push   $0xf0108761
f0103461:	e8 e3 cb ff ff       	call   f0100049 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0103466:	a1 48 42 34 f0       	mov    0xf0344248,%eax
f010346b:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if ((uint32_t)kva < KERNBASE)
f010346e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0103471:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
f0103476:	8d b0 00 00 40 21    	lea    0x21400000(%eax),%esi
f010347c:	89 da                	mov    %ebx,%edx
f010347e:	89 f8                	mov    %edi,%eax
f0103480:	e8 e5 df ff ff       	call   f010146a <check_va2pa>
f0103485:	81 7d d4 ff ff ff ef 	cmpl   $0xefffffff,-0x2c(%ebp)
f010348c:	76 47                	jbe    f01034d5 <mem_init+0x1664>
f010348e:	8d 14 1e             	lea    (%esi,%ebx,1),%edx
f0103491:	39 d0                	cmp    %edx,%eax
f0103493:	75 57                	jne    f01034ec <mem_init+0x167b>
f0103495:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	for (i = 0; i < n; i += PGSIZE)
f010349b:	81 fb 00 10 c2 ee    	cmp    $0xeec21000,%ebx
f01034a1:	75 d9                	jne    f010347c <mem_init+0x160b>
	if (!(*pgdir & PTE_P) | !(*pgdir & PTE_PS))
f01034a3:	8b 87 00 0f 00 00    	mov    0xf00(%edi),%eax
f01034a9:	89 c2                	mov    %eax,%edx
f01034ab:	81 e2 81 00 00 00    	and    $0x81,%edx
f01034b1:	81 fa 81 00 00 00    	cmp    $0x81,%edx
f01034b7:	0f 85 7e 01 00 00    	jne    f010363b <mem_init+0x17ca>
	if (check_va2pa_large(pgdir, KERNBASE) == 0) {
f01034bd:	a9 00 f0 ff ff       	test   $0xfffff000,%eax
f01034c2:	0f 85 73 01 00 00    	jne    f010363b <mem_init+0x17ca>
		for (i = 0; i < npages * PGSIZE; i += PTSIZE)
f01034c8:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f01034cb:	c1 e3 0c             	shl    $0xc,%ebx
f01034ce:	b8 00 00 00 00       	mov    $0x0,%eax
f01034d3:	eb 3f                	jmp    f0103514 <mem_init+0x16a3>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01034d5:	ff 75 cc             	pushl  -0x34(%ebp)
f01034d8:	68 78 74 10 f0       	push   $0xf0107478
f01034dd:	68 ce 03 00 00       	push   $0x3ce
f01034e2:	68 61 87 10 f0       	push   $0xf0108761
f01034e7:	e8 5d cb ff ff       	call   f0100049 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f01034ec:	68 78 85 10 f0       	push   $0xf0108578
f01034f1:	68 a2 87 10 f0       	push   $0xf01087a2
f01034f6:	68 ce 03 00 00       	push   $0x3ce
f01034fb:	68 61 87 10 f0       	push   $0xf0108761
f0103500:	e8 44 cb ff ff       	call   f0100049 <_panic>
	return PTE_ADDR(*pgdir);
f0103505:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
			assert(check_va2pa_large(pgdir, KERNBASE + i) == i);
f010350b:	39 d0                	cmp    %edx,%eax
f010350d:	75 25                	jne    f0103534 <mem_init+0x16c3>
		for (i = 0; i < npages * PGSIZE; i += PTSIZE)
f010350f:	05 00 00 40 00       	add    $0x400000,%eax
f0103514:	39 d8                	cmp    %ebx,%eax
f0103516:	73 35                	jae    f010354d <mem_init+0x16dc>
	pgdir = &pgdir[PDX(va)];
f0103518:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
f010351e:	c1 ea 16             	shr    $0x16,%edx
	if (!(*pgdir & PTE_P) | !(*pgdir & PTE_PS))
f0103521:	8b 14 97             	mov    (%edi,%edx,4),%edx
f0103524:	89 d1                	mov    %edx,%ecx
f0103526:	81 e1 81 00 00 00    	and    $0x81,%ecx
f010352c:	81 f9 81 00 00 00    	cmp    $0x81,%ecx
f0103532:	74 d1                	je     f0103505 <mem_init+0x1694>
			assert(check_va2pa_large(pgdir, KERNBASE + i) == i);
f0103534:	68 ac 85 10 f0       	push   $0xf01085ac
f0103539:	68 a2 87 10 f0       	push   $0xf01087a2
f010353e:	68 d3 03 00 00       	push   $0x3d3
f0103543:	68 61 87 10 f0       	push   $0xf0108761
f0103548:	e8 fc ca ff ff       	call   f0100049 <_panic>
		cprintf("large page installed!\n");
f010354d:	83 ec 0c             	sub    $0xc,%esp
f0103550:	68 35 8b 10 f0       	push   $0xf0108b35
f0103555:	e8 8f 10 00 00       	call   f01045e9 <cprintf>
f010355a:	83 c4 10             	add    $0x10,%esp
        for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f010355d:	b8 00 70 34 f0       	mov    $0xf0347000,%eax
f0103562:	be 00 80 ff ef       	mov    $0xefff8000,%esi
f0103567:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f010356a:	89 c7                	mov    %eax,%edi
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f010356c:	89 7d c4             	mov    %edi,-0x3c(%ebp)
f010356f:	89 f3                	mov    %esi,%ebx
f0103571:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0103574:	05 00 80 00 20       	add    $0x20008000,%eax
f0103579:	89 45 cc             	mov    %eax,-0x34(%ebp)
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f010357c:	8d 86 00 80 00 00    	lea    0x8000(%esi),%eax
f0103582:	89 45 c8             	mov    %eax,-0x38(%ebp)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0103585:	89 da                	mov    %ebx,%edx
f0103587:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010358a:	e8 db de ff ff       	call   f010146a <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f010358f:	81 ff ff ff ff ef    	cmp    $0xefffffff,%edi
f0103595:	0f 86 ad 00 00 00    	jbe    f0103648 <mem_init+0x17d7>
f010359b:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f010359e:	8d 14 19             	lea    (%ecx,%ebx,1),%edx
f01035a1:	39 d0                	cmp    %edx,%eax
f01035a3:	0f 85 b6 00 00 00    	jne    f010365f <mem_init+0x17ee>
f01035a9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f01035af:	3b 5d c8             	cmp    -0x38(%ebp),%ebx
f01035b2:	75 d1                	jne    f0103585 <mem_init+0x1714>
f01035b4:	8d 9e 00 80 ff ff    	lea    -0x8000(%esi),%ebx
			assert(check_va2pa(pgdir, base + i) == ~0);
f01035ba:	89 da                	mov    %ebx,%edx
f01035bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01035bf:	e8 a6 de ff ff       	call   f010146a <check_va2pa>
f01035c4:	83 f8 ff             	cmp    $0xffffffff,%eax
f01035c7:	0f 85 ab 00 00 00    	jne    f0103678 <mem_init+0x1807>
f01035cd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		for (i = 0; i < KSTKGAP; i += PGSIZE)
f01035d3:	39 f3                	cmp    %esi,%ebx
f01035d5:	75 e3                	jne    f01035ba <mem_init+0x1749>
f01035d7:	81 ee 00 00 01 00    	sub    $0x10000,%esi
f01035dd:	81 45 d0 00 80 01 00 	addl   $0x18000,-0x30(%ebp)
f01035e4:	81 c7 00 80 00 00    	add    $0x8000,%edi
	for (n = 0; n < NCPU; n++) {
f01035ea:	81 ff 00 70 38 f0    	cmp    $0xf0387000,%edi
f01035f0:	0f 85 76 ff ff ff    	jne    f010356c <mem_init+0x16fb>
f01035f6:	8b 7d d4             	mov    -0x2c(%ebp),%edi
	for (i = 0; i < NPDENTRIES; i++) {
f01035f9:	b8 00 00 00 00       	mov    $0x0,%eax
f01035fe:	e9 c4 00 00 00       	jmp    f01036c7 <mem_init+0x1856>
        for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0103603:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0103609:	39 f3                	cmp    %esi,%ebx
f010360b:	0f 83 4c ff ff ff    	jae    f010355d <mem_init+0x16ec>
            assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0103611:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
f0103617:	89 f8                	mov    %edi,%eax
f0103619:	e8 4c de ff ff       	call   f010146a <check_va2pa>
f010361e:	39 c3                	cmp    %eax,%ebx
f0103620:	74 e1                	je     f0103603 <mem_init+0x1792>
f0103622:	68 d8 85 10 f0       	push   $0xf01085d8
f0103627:	68 a2 87 10 f0       	push   $0xf01087a2
f010362c:	68 d8 03 00 00       	push   $0x3d8
f0103631:	68 61 87 10 f0       	push   $0xf0108761
f0103636:	e8 0e ca ff ff       	call   f0100049 <_panic>
        for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f010363b:	8b 75 c4             	mov    -0x3c(%ebp),%esi
f010363e:	c1 e6 0c             	shl    $0xc,%esi
f0103641:	bb 00 00 00 00       	mov    $0x0,%ebx
f0103646:	eb c1                	jmp    f0103609 <mem_init+0x1798>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103648:	ff 75 c4             	pushl  -0x3c(%ebp)
f010364b:	68 78 74 10 f0       	push   $0xf0107478
f0103650:	68 e1 03 00 00       	push   $0x3e1
f0103655:	68 61 87 10 f0       	push   $0xf0108761
f010365a:	e8 ea c9 ff ff       	call   f0100049 <_panic>
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f010365f:	68 00 86 10 f0       	push   $0xf0108600
f0103664:	68 a2 87 10 f0       	push   $0xf01087a2
f0103669:	68 e1 03 00 00       	push   $0x3e1
f010366e:	68 61 87 10 f0       	push   $0xf0108761
f0103673:	e8 d1 c9 ff ff       	call   f0100049 <_panic>
			assert(check_va2pa(pgdir, base + i) == ~0);
f0103678:	68 48 86 10 f0       	push   $0xf0108648
f010367d:	68 a2 87 10 f0       	push   $0xf01087a2
f0103682:	68 e3 03 00 00       	push   $0x3e3
f0103687:	68 61 87 10 f0       	push   $0xf0108761
f010368c:	e8 b8 c9 ff ff       	call   f0100049 <_panic>
			assert(pgdir[i] & PTE_P);
f0103691:	f6 04 87 01          	testb  $0x1,(%edi,%eax,4)
f0103695:	75 48                	jne    f01036df <mem_init+0x186e>
f0103697:	68 4c 8b 10 f0       	push   $0xf0108b4c
f010369c:	68 a2 87 10 f0       	push   $0xf01087a2
f01036a1:	68 ee 03 00 00       	push   $0x3ee
f01036a6:	68 61 87 10 f0       	push   $0xf0108761
f01036ab:	e8 99 c9 ff ff       	call   f0100049 <_panic>
				assert(pgdir[i] & PTE_P);
f01036b0:	8b 14 87             	mov    (%edi,%eax,4),%edx
f01036b3:	f6 c2 01             	test   $0x1,%dl
f01036b6:	74 2c                	je     f01036e4 <mem_init+0x1873>
				assert(pgdir[i] & PTE_W);
f01036b8:	f6 c2 02             	test   $0x2,%dl
f01036bb:	74 40                	je     f01036fd <mem_init+0x188c>
	for (i = 0; i < NPDENTRIES; i++) {
f01036bd:	83 c0 01             	add    $0x1,%eax
f01036c0:	3d 00 04 00 00       	cmp    $0x400,%eax
f01036c5:	74 68                	je     f010372f <mem_init+0x18be>
		switch (i) {
f01036c7:	8d 90 45 fc ff ff    	lea    -0x3bb(%eax),%edx
f01036cd:	83 fa 04             	cmp    $0x4,%edx
f01036d0:	76 bf                	jbe    f0103691 <mem_init+0x1820>
			if (i >= PDX(KERNBASE)) {
f01036d2:	3d bf 03 00 00       	cmp    $0x3bf,%eax
f01036d7:	77 d7                	ja     f01036b0 <mem_init+0x183f>
				assert(pgdir[i] == 0);
f01036d9:	83 3c 87 00          	cmpl   $0x0,(%edi,%eax,4)
f01036dd:	75 37                	jne    f0103716 <mem_init+0x18a5>
	for (i = 0; i < NPDENTRIES; i++) {
f01036df:	83 c0 01             	add    $0x1,%eax
f01036e2:	eb e3                	jmp    f01036c7 <mem_init+0x1856>
				assert(pgdir[i] & PTE_P);
f01036e4:	68 4c 8b 10 f0       	push   $0xf0108b4c
f01036e9:	68 a2 87 10 f0       	push   $0xf01087a2
f01036ee:	68 f2 03 00 00       	push   $0x3f2
f01036f3:	68 61 87 10 f0       	push   $0xf0108761
f01036f8:	e8 4c c9 ff ff       	call   f0100049 <_panic>
				assert(pgdir[i] & PTE_W);
f01036fd:	68 5d 8b 10 f0       	push   $0xf0108b5d
f0103702:	68 a2 87 10 f0       	push   $0xf01087a2
f0103707:	68 f3 03 00 00       	push   $0x3f3
f010370c:	68 61 87 10 f0       	push   $0xf0108761
f0103711:	e8 33 c9 ff ff       	call   f0100049 <_panic>
				assert(pgdir[i] == 0);
f0103716:	68 6e 8b 10 f0       	push   $0xf0108b6e
f010371b:	68 a2 87 10 f0       	push   $0xf01087a2
f0103720:	68 f5 03 00 00       	push   $0x3f5
f0103725:	68 61 87 10 f0       	push   $0xf0108761
f010372a:	e8 1a c9 ff ff       	call   f0100049 <_panic>
	cprintf("check_kern_pgdir() succeeded!\n");
f010372f:	83 ec 0c             	sub    $0xc,%esp
f0103732:	68 6c 86 10 f0       	push   $0xf010866c
f0103737:	e8 ad 0e 00 00       	call   f01045e9 <cprintf>
	asm volatile("movl %%cr4,%0" : "=r" (cr4));
f010373c:	0f 20 e0             	mov    %cr4,%eax
	cr4 |= CR4_PSE;
f010373f:	83 c8 10             	or     $0x10,%eax
	asm volatile("movl %0,%%cr4" : : "r" (val));
f0103742:	0f 22 e0             	mov    %eax,%cr4
	lcr3(PADDR(kern_pgdir));
f0103745:	a1 8c 5e 34 f0       	mov    0xf0345e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f010374a:	83 c4 10             	add    $0x10,%esp
f010374d:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103752:	0f 86 fb 01 00 00    	jbe    f0103953 <mem_init+0x1ae2>
	return (physaddr_t)kva - KERNBASE;
f0103758:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f010375d:	0f 22 d8             	mov    %eax,%cr3
	check_page_free_list(0);
f0103760:	b8 00 00 00 00       	mov    $0x0,%eax
f0103765:	e8 ee dd ff ff       	call   f0101558 <check_page_free_list>
	asm volatile("movl %%cr0,%0" : "=r" (val));
f010376a:	0f 20 c0             	mov    %cr0,%eax
	cr0 &= ~(CR0_TS|CR0_EM);
f010376d:	83 e0 f3             	and    $0xfffffff3,%eax
f0103770:	0d 23 00 05 80       	or     $0x80050023,%eax
	asm volatile("movl %0,%%cr0" : : "r" (val));
f0103775:	0f 22 c0             	mov    %eax,%cr0
	uintptr_t va;
	int i;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0103778:	83 ec 0c             	sub    $0xc,%esp
f010377b:	6a 00                	push   $0x0
f010377d:	e8 79 e1 ff ff       	call   f01018fb <page_alloc>
f0103782:	89 c6                	mov    %eax,%esi
f0103784:	83 c4 10             	add    $0x10,%esp
f0103787:	85 c0                	test   %eax,%eax
f0103789:	0f 84 d9 01 00 00    	je     f0103968 <mem_init+0x1af7>
	assert((pp1 = page_alloc(0)));
f010378f:	83 ec 0c             	sub    $0xc,%esp
f0103792:	6a 00                	push   $0x0
f0103794:	e8 62 e1 ff ff       	call   f01018fb <page_alloc>
f0103799:	89 c7                	mov    %eax,%edi
f010379b:	83 c4 10             	add    $0x10,%esp
f010379e:	85 c0                	test   %eax,%eax
f01037a0:	0f 84 db 01 00 00    	je     f0103981 <mem_init+0x1b10>
	assert((pp2 = page_alloc(0)));
f01037a6:	83 ec 0c             	sub    $0xc,%esp
f01037a9:	6a 00                	push   $0x0
f01037ab:	e8 4b e1 ff ff       	call   f01018fb <page_alloc>
f01037b0:	89 c3                	mov    %eax,%ebx
f01037b2:	83 c4 10             	add    $0x10,%esp
f01037b5:	85 c0                	test   %eax,%eax
f01037b7:	0f 84 dd 01 00 00    	je     f010399a <mem_init+0x1b29>
	page_free(pp0);
f01037bd:	83 ec 0c             	sub    $0xc,%esp
f01037c0:	56                   	push   %esi
f01037c1:	e8 a7 e1 ff ff       	call   f010196d <page_free>
	return (pp - pages) << PGSHIFT;
f01037c6:	89 f8                	mov    %edi,%eax
f01037c8:	2b 05 90 5e 34 f0    	sub    0xf0345e90,%eax
f01037ce:	c1 f8 03             	sar    $0x3,%eax
f01037d1:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01037d4:	89 c2                	mov    %eax,%edx
f01037d6:	c1 ea 0c             	shr    $0xc,%edx
f01037d9:	83 c4 10             	add    $0x10,%esp
f01037dc:	3b 15 88 5e 34 f0    	cmp    0xf0345e88,%edx
f01037e2:	0f 83 cb 01 00 00    	jae    f01039b3 <mem_init+0x1b42>
	memset(page2kva(pp1), 1, PGSIZE);
f01037e8:	83 ec 04             	sub    $0x4,%esp
f01037eb:	68 00 10 00 00       	push   $0x1000
f01037f0:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f01037f2:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01037f7:	50                   	push   %eax
f01037f8:	e8 97 2f 00 00       	call   f0106794 <memset>
	return (pp - pages) << PGSHIFT;
f01037fd:	89 d8                	mov    %ebx,%eax
f01037ff:	2b 05 90 5e 34 f0    	sub    0xf0345e90,%eax
f0103805:	c1 f8 03             	sar    $0x3,%eax
f0103808:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f010380b:	89 c2                	mov    %eax,%edx
f010380d:	c1 ea 0c             	shr    $0xc,%edx
f0103810:	83 c4 10             	add    $0x10,%esp
f0103813:	3b 15 88 5e 34 f0    	cmp    0xf0345e88,%edx
f0103819:	0f 83 a6 01 00 00    	jae    f01039c5 <mem_init+0x1b54>
	memset(page2kva(pp2), 2, PGSIZE);
f010381f:	83 ec 04             	sub    $0x4,%esp
f0103822:	68 00 10 00 00       	push   $0x1000
f0103827:	6a 02                	push   $0x2
	return (void *)(pa + KERNBASE);
f0103829:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010382e:	50                   	push   %eax
f010382f:	e8 60 2f 00 00       	call   f0106794 <memset>
	page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W);
f0103834:	6a 02                	push   $0x2
f0103836:	68 00 10 00 00       	push   $0x1000
f010383b:	57                   	push   %edi
f010383c:	ff 35 8c 5e 34 f0    	pushl  0xf0345e8c
f0103842:	e8 2b e5 ff ff       	call   f0101d72 <page_insert>
	assert(pp1->pp_ref == 1);
f0103847:	83 c4 20             	add    $0x20,%esp
f010384a:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f010384f:	0f 85 82 01 00 00    	jne    f01039d7 <mem_init+0x1b66>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0103855:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f010385c:	01 01 01 
f010385f:	0f 85 8b 01 00 00    	jne    f01039f0 <mem_init+0x1b7f>
	page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W);
f0103865:	6a 02                	push   $0x2
f0103867:	68 00 10 00 00       	push   $0x1000
f010386c:	53                   	push   %ebx
f010386d:	ff 35 8c 5e 34 f0    	pushl  0xf0345e8c
f0103873:	e8 fa e4 ff ff       	call   f0101d72 <page_insert>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0103878:	83 c4 10             	add    $0x10,%esp
f010387b:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f0103882:	02 02 02 
f0103885:	0f 85 7e 01 00 00    	jne    f0103a09 <mem_init+0x1b98>
	assert(pp2->pp_ref == 1);
f010388b:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0103890:	0f 85 8c 01 00 00    	jne    f0103a22 <mem_init+0x1bb1>
	assert(pp1->pp_ref == 0);
f0103896:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f010389b:	0f 85 9a 01 00 00    	jne    f0103a3b <mem_init+0x1bca>
	*(uint32_t *)PGSIZE = 0x03030303U;
f01038a1:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f01038a8:	03 03 03 
	return (pp - pages) << PGSHIFT;
f01038ab:	89 d8                	mov    %ebx,%eax
f01038ad:	2b 05 90 5e 34 f0    	sub    0xf0345e90,%eax
f01038b3:	c1 f8 03             	sar    $0x3,%eax
f01038b6:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01038b9:	89 c2                	mov    %eax,%edx
f01038bb:	c1 ea 0c             	shr    $0xc,%edx
f01038be:	3b 15 88 5e 34 f0    	cmp    0xf0345e88,%edx
f01038c4:	0f 83 8a 01 00 00    	jae    f0103a54 <mem_init+0x1be3>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f01038ca:	81 b8 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%eax)
f01038d1:	03 03 03 
f01038d4:	0f 85 8c 01 00 00    	jne    f0103a66 <mem_init+0x1bf5>
	page_remove(kern_pgdir, (void*) PGSIZE);
f01038da:	83 ec 08             	sub    $0x8,%esp
f01038dd:	68 00 10 00 00       	push   $0x1000
f01038e2:	ff 35 8c 5e 34 f0    	pushl  0xf0345e8c
f01038e8:	e8 21 e4 ff ff       	call   f0101d0e <page_remove>
	assert(pp2->pp_ref == 0);
f01038ed:	83 c4 10             	add    $0x10,%esp
f01038f0:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f01038f5:	0f 85 84 01 00 00    	jne    f0103a7f <mem_init+0x1c0e>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01038fb:	8b 0d 8c 5e 34 f0    	mov    0xf0345e8c,%ecx
f0103901:	8b 11                	mov    (%ecx),%edx
f0103903:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	return (pp - pages) << PGSHIFT;
f0103909:	89 f0                	mov    %esi,%eax
f010390b:	2b 05 90 5e 34 f0    	sub    0xf0345e90,%eax
f0103911:	c1 f8 03             	sar    $0x3,%eax
f0103914:	c1 e0 0c             	shl    $0xc,%eax
f0103917:	39 c2                	cmp    %eax,%edx
f0103919:	0f 85 79 01 00 00    	jne    f0103a98 <mem_init+0x1c27>
	kern_pgdir[0] = 0;
f010391f:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0103925:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f010392a:	0f 85 81 01 00 00    	jne    f0103ab1 <mem_init+0x1c40>
	pp0->pp_ref = 0;
f0103930:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

	// free the pages we took
	page_free(pp0);
f0103936:	83 ec 0c             	sub    $0xc,%esp
f0103939:	56                   	push   %esi
f010393a:	e8 2e e0 ff ff       	call   f010196d <page_free>

	cprintf("check_page_installed_pgdir() succeeded!\n");
f010393f:	c7 04 24 00 87 10 f0 	movl   $0xf0108700,(%esp)
f0103946:	e8 9e 0c 00 00       	call   f01045e9 <cprintf>
}
f010394b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010394e:	5b                   	pop    %ebx
f010394f:	5e                   	pop    %esi
f0103950:	5f                   	pop    %edi
f0103951:	5d                   	pop    %ebp
f0103952:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103953:	50                   	push   %eax
f0103954:	68 78 74 10 f0       	push   $0xf0107478
f0103959:	68 fd 00 00 00       	push   $0xfd
f010395e:	68 61 87 10 f0       	push   $0xf0108761
f0103963:	e8 e1 c6 ff ff       	call   f0100049 <_panic>
	assert((pp0 = page_alloc(0)));
f0103968:	68 41 89 10 f0       	push   $0xf0108941
f010396d:	68 a2 87 10 f0       	push   $0xf01087a2
f0103972:	68 d5 04 00 00       	push   $0x4d5
f0103977:	68 61 87 10 f0       	push   $0xf0108761
f010397c:	e8 c8 c6 ff ff       	call   f0100049 <_panic>
	assert((pp1 = page_alloc(0)));
f0103981:	68 57 89 10 f0       	push   $0xf0108957
f0103986:	68 a2 87 10 f0       	push   $0xf01087a2
f010398b:	68 d6 04 00 00       	push   $0x4d6
f0103990:	68 61 87 10 f0       	push   $0xf0108761
f0103995:	e8 af c6 ff ff       	call   f0100049 <_panic>
	assert((pp2 = page_alloc(0)));
f010399a:	68 6d 89 10 f0       	push   $0xf010896d
f010399f:	68 a2 87 10 f0       	push   $0xf01087a2
f01039a4:	68 d7 04 00 00       	push   $0x4d7
f01039a9:	68 61 87 10 f0       	push   $0xf0108761
f01039ae:	e8 96 c6 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01039b3:	50                   	push   %eax
f01039b4:	68 54 74 10 f0       	push   $0xf0107454
f01039b9:	6a 58                	push   $0x58
f01039bb:	68 88 87 10 f0       	push   $0xf0108788
f01039c0:	e8 84 c6 ff ff       	call   f0100049 <_panic>
f01039c5:	50                   	push   %eax
f01039c6:	68 54 74 10 f0       	push   $0xf0107454
f01039cb:	6a 58                	push   $0x58
f01039cd:	68 88 87 10 f0       	push   $0xf0108788
f01039d2:	e8 72 c6 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 1);
f01039d7:	68 3e 8a 10 f0       	push   $0xf0108a3e
f01039dc:	68 a2 87 10 f0       	push   $0xf01087a2
f01039e1:	68 dc 04 00 00       	push   $0x4dc
f01039e6:	68 61 87 10 f0       	push   $0xf0108761
f01039eb:	e8 59 c6 ff ff       	call   f0100049 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f01039f0:	68 8c 86 10 f0       	push   $0xf010868c
f01039f5:	68 a2 87 10 f0       	push   $0xf01087a2
f01039fa:	68 dd 04 00 00       	push   $0x4dd
f01039ff:	68 61 87 10 f0       	push   $0xf0108761
f0103a04:	e8 40 c6 ff ff       	call   f0100049 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0103a09:	68 b0 86 10 f0       	push   $0xf01086b0
f0103a0e:	68 a2 87 10 f0       	push   $0xf01087a2
f0103a13:	68 df 04 00 00       	push   $0x4df
f0103a18:	68 61 87 10 f0       	push   $0xf0108761
f0103a1d:	e8 27 c6 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 1);
f0103a22:	68 60 8a 10 f0       	push   $0xf0108a60
f0103a27:	68 a2 87 10 f0       	push   $0xf01087a2
f0103a2c:	68 e0 04 00 00       	push   $0x4e0
f0103a31:	68 61 87 10 f0       	push   $0xf0108761
f0103a36:	e8 0e c6 ff ff       	call   f0100049 <_panic>
	assert(pp1->pp_ref == 0);
f0103a3b:	68 ca 8a 10 f0       	push   $0xf0108aca
f0103a40:	68 a2 87 10 f0       	push   $0xf01087a2
f0103a45:	68 e1 04 00 00       	push   $0x4e1
f0103a4a:	68 61 87 10 f0       	push   $0xf0108761
f0103a4f:	e8 f5 c5 ff ff       	call   f0100049 <_panic>
f0103a54:	50                   	push   %eax
f0103a55:	68 54 74 10 f0       	push   $0xf0107454
f0103a5a:	6a 58                	push   $0x58
f0103a5c:	68 88 87 10 f0       	push   $0xf0108788
f0103a61:	e8 e3 c5 ff ff       	call   f0100049 <_panic>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0103a66:	68 d4 86 10 f0       	push   $0xf01086d4
f0103a6b:	68 a2 87 10 f0       	push   $0xf01087a2
f0103a70:	68 e3 04 00 00       	push   $0x4e3
f0103a75:	68 61 87 10 f0       	push   $0xf0108761
f0103a7a:	e8 ca c5 ff ff       	call   f0100049 <_panic>
	assert(pp2->pp_ref == 0);
f0103a7f:	68 98 8a 10 f0       	push   $0xf0108a98
f0103a84:	68 a2 87 10 f0       	push   $0xf01087a2
f0103a89:	68 e5 04 00 00       	push   $0x4e5
f0103a8e:	68 61 87 10 f0       	push   $0xf0108761
f0103a93:	e8 b1 c5 ff ff       	call   f0100049 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0103a98:	68 30 80 10 f0       	push   $0xf0108030
f0103a9d:	68 a2 87 10 f0       	push   $0xf01087a2
f0103aa2:	68 e8 04 00 00       	push   $0x4e8
f0103aa7:	68 61 87 10 f0       	push   $0xf0108761
f0103aac:	e8 98 c5 ff ff       	call   f0100049 <_panic>
	assert(pp0->pp_ref == 1);
f0103ab1:	68 4f 8a 10 f0       	push   $0xf0108a4f
f0103ab6:	68 a2 87 10 f0       	push   $0xf01087a2
f0103abb:	68 ea 04 00 00       	push   $0x4ea
f0103ac0:	68 61 87 10 f0       	push   $0xf0108761
f0103ac5:	e8 7f c5 ff ff       	call   f0100049 <_panic>

f0103aca <user_mem_check>:
{
f0103aca:	55                   	push   %ebp
f0103acb:	89 e5                	mov    %esp,%ebp
f0103acd:	57                   	push   %edi
f0103ace:	56                   	push   %esi
f0103acf:	53                   	push   %ebx
f0103ad0:	83 ec 1c             	sub    $0x1c,%esp
	va_start = ROUNDDOWN((uintptr_t)va, PGSIZE);
f0103ad3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0103ad6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f0103adc:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
	va_end = ROUNDUP((uintptr_t)(va+len), PGSIZE);
f0103adf:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0103ae2:	03 7d 10             	add    0x10(%ebp),%edi
f0103ae5:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
f0103aeb:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
	perm |= PTE_U;
f0103af1:	8b 75 14             	mov    0x14(%ebp),%esi
f0103af4:	83 ce 04             	or     $0x4,%esi
	for(; va_start<va_end; va_start+=PGSIZE){
f0103af7:	39 fb                	cmp    %edi,%ebx
f0103af9:	73 57                	jae    f0103b52 <user_mem_check+0x88>
		pte = pgdir_walk(env->env_pgdir, (void *)va_start, 0);
f0103afb:	83 ec 04             	sub    $0x4,%esp
f0103afe:	6a 00                	push   $0x0
f0103b00:	53                   	push   %ebx
f0103b01:	8b 45 08             	mov    0x8(%ebp),%eax
f0103b04:	ff 70 60             	pushl  0x60(%eax)
f0103b07:	e8 f7 de ff ff       	call   f0101a03 <pgdir_walk>
		if((int)va_start>ULIM || pte==NULL || ((uint32_t)(*pte)&perm)!=perm){
f0103b0c:	83 c4 10             	add    $0x10,%esp
f0103b0f:	81 fb 00 00 80 ef    	cmp    $0xef800000,%ebx
f0103b15:	77 14                	ja     f0103b2b <user_mem_check+0x61>
f0103b17:	85 c0                	test   %eax,%eax
f0103b19:	74 10                	je     f0103b2b <user_mem_check+0x61>
f0103b1b:	89 f2                	mov    %esi,%edx
f0103b1d:	23 10                	and    (%eax),%edx
f0103b1f:	39 d6                	cmp    %edx,%esi
f0103b21:	75 08                	jne    f0103b2b <user_mem_check+0x61>
	for(; va_start<va_end; va_start+=PGSIZE){
f0103b23:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0103b29:	eb cc                	jmp    f0103af7 <user_mem_check+0x2d>
			if(va_start == ROUNDDOWN((uintptr_t)va, PGSIZE))
f0103b2b:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f0103b2e:	74 13                	je     f0103b43 <user_mem_check+0x79>
				user_mem_check_addr = (uintptr_t)va_start;
f0103b30:	89 1d 3c 42 34 f0    	mov    %ebx,0xf034423c
			return -E_FAULT;
f0103b36:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
}
f0103b3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103b3e:	5b                   	pop    %ebx
f0103b3f:	5e                   	pop    %esi
f0103b40:	5f                   	pop    %edi
f0103b41:	5d                   	pop    %ebp
f0103b42:	c3                   	ret    
				user_mem_check_addr = (uintptr_t)va;
f0103b43:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103b46:	a3 3c 42 34 f0       	mov    %eax,0xf034423c
			return -E_FAULT;
f0103b4b:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f0103b50:	eb e9                	jmp    f0103b3b <user_mem_check+0x71>
	return 0;
f0103b52:	b8 00 00 00 00       	mov    $0x0,%eax
f0103b57:	eb e2                	jmp    f0103b3b <user_mem_check+0x71>

f0103b59 <user_mem_assert>:
{
f0103b59:	55                   	push   %ebp
f0103b5a:	89 e5                	mov    %esp,%ebp
f0103b5c:	53                   	push   %ebx
f0103b5d:	83 ec 04             	sub    $0x4,%esp
f0103b60:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f0103b63:	8b 45 14             	mov    0x14(%ebp),%eax
f0103b66:	83 c8 04             	or     $0x4,%eax
f0103b69:	50                   	push   %eax
f0103b6a:	ff 75 10             	pushl  0x10(%ebp)
f0103b6d:	ff 75 0c             	pushl  0xc(%ebp)
f0103b70:	53                   	push   %ebx
f0103b71:	e8 54 ff ff ff       	call   f0103aca <user_mem_check>
f0103b76:	83 c4 10             	add    $0x10,%esp
f0103b79:	85 c0                	test   %eax,%eax
f0103b7b:	78 05                	js     f0103b82 <user_mem_assert+0x29>
}
f0103b7d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103b80:	c9                   	leave  
f0103b81:	c3                   	ret    
		cprintf("[%08x] user_mem_check assertion failure for "
f0103b82:	83 ec 04             	sub    $0x4,%esp
f0103b85:	ff 35 3c 42 34 f0    	pushl  0xf034423c
f0103b8b:	ff 73 48             	pushl  0x48(%ebx)
f0103b8e:	68 2c 87 10 f0       	push   $0xf010872c
f0103b93:	e8 51 0a 00 00       	call   f01045e9 <cprintf>
		env_destroy(env);	// may not return
f0103b98:	89 1c 24             	mov    %ebx,(%esp)
f0103b9b:	e8 0a 07 00 00       	call   f01042aa <env_destroy>
f0103ba0:	83 c4 10             	add    $0x10,%esp
}
f0103ba3:	eb d8                	jmp    f0103b7d <user_mem_assert+0x24>

f0103ba5 <envid2env>:
//   On success, sets *env_store to the environment.
//   On error, sets *env_store to NULL.
//
int
envid2env(envid_t envid, struct Env **env_store, bool checkperm)
{
f0103ba5:	55                   	push   %ebp
f0103ba6:	89 e5                	mov    %esp,%ebp
f0103ba8:	56                   	push   %esi
f0103ba9:	53                   	push   %ebx
f0103baa:	8b 45 08             	mov    0x8(%ebp),%eax
f0103bad:	8b 55 10             	mov    0x10(%ebp),%edx
	struct Env *e;

	// If envid is zero, return the current environment.
	if (envid == 0) {
f0103bb0:	85 c0                	test   %eax,%eax
f0103bb2:	74 31                	je     f0103be5 <envid2env+0x40>
	// Look up the Env structure via the index part of the envid,
	// then check the env_id field in that struct Env
	// to ensure that the envid is not stale
	// (i.e., does not refer to a _previous_ environment
	// that used the same slot in the envs[] array).
	e = &envs[ENVX(envid)];
f0103bb4:	89 c3                	mov    %eax,%ebx
f0103bb6:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f0103bbc:	69 db 84 00 00 00    	imul   $0x84,%ebx,%ebx
f0103bc2:	03 1d 48 42 34 f0    	add    0xf0344248,%ebx
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f0103bc8:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f0103bcc:	74 31                	je     f0103bff <envid2env+0x5a>
f0103bce:	39 43 48             	cmp    %eax,0x48(%ebx)
f0103bd1:	75 2c                	jne    f0103bff <envid2env+0x5a>
	// Check that the calling environment has legitimate permission
	// to manipulate the specified environment.
	// If checkperm is set, the specified environment
	// must be either the current environment
	// or an immediate child of the current environment.
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f0103bd3:	84 d2                	test   %dl,%dl
f0103bd5:	75 38                	jne    f0103c0f <envid2env+0x6a>
		*env_store = 0;
		return -E_BAD_ENV;
	}

	*env_store = e;
f0103bd7:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103bda:	89 18                	mov    %ebx,(%eax)
	return 0;
f0103bdc:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103be1:	5b                   	pop    %ebx
f0103be2:	5e                   	pop    %esi
f0103be3:	5d                   	pop    %ebp
f0103be4:	c3                   	ret    
		*env_store = curenv;
f0103be5:	e8 b0 31 00 00       	call   f0106d9a <cpunum>
f0103bea:	6b c0 74             	imul   $0x74,%eax,%eax
f0103bed:	8b 80 28 60 34 f0    	mov    -0xfcb9fd8(%eax),%eax
f0103bf3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0103bf6:	89 01                	mov    %eax,(%ecx)
		return 0;
f0103bf8:	b8 00 00 00 00       	mov    $0x0,%eax
f0103bfd:	eb e2                	jmp    f0103be1 <envid2env+0x3c>
		*env_store = 0;
f0103bff:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103c02:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f0103c08:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103c0d:	eb d2                	jmp    f0103be1 <envid2env+0x3c>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f0103c0f:	e8 86 31 00 00       	call   f0106d9a <cpunum>
f0103c14:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c17:	39 98 28 60 34 f0    	cmp    %ebx,-0xfcb9fd8(%eax)
f0103c1d:	74 b8                	je     f0103bd7 <envid2env+0x32>
f0103c1f:	8b 73 4c             	mov    0x4c(%ebx),%esi
f0103c22:	e8 73 31 00 00       	call   f0106d9a <cpunum>
f0103c27:	6b c0 74             	imul   $0x74,%eax,%eax
f0103c2a:	8b 80 28 60 34 f0    	mov    -0xfcb9fd8(%eax),%eax
f0103c30:	3b 70 48             	cmp    0x48(%eax),%esi
f0103c33:	74 a2                	je     f0103bd7 <envid2env+0x32>
		*env_store = 0;
f0103c35:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103c38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f0103c3e:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103c43:	eb 9c                	jmp    f0103be1 <envid2env+0x3c>

f0103c45 <env_init_percpu>:
	asm volatile("lgdt (%0)" : : "r" (p));
f0103c45:	b8 20 53 12 f0       	mov    $0xf0125320,%eax
f0103c4a:	0f 01 10             	lgdtl  (%eax)
env_init_percpu(void)
{
	lgdt(&gdt_pd);
	// The kernel never uses GS or FS, so we leave those set to
	// the user data segment.
	asm volatile("movw %%ax,%%gs" : : "a" (GD_UD|3));
f0103c4d:	b8 23 00 00 00       	mov    $0x23,%eax
f0103c52:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" : : "a" (GD_UD|3));
f0103c54:	8e e0                	mov    %eax,%fs
	// The kernel does use ES, DS, and SS.  We'll change between
	// the kernel and user data segments as needed.
	asm volatile("movw %%ax,%%es" : : "a" (GD_KD));
f0103c56:	b8 10 00 00 00       	mov    $0x10,%eax
f0103c5b:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" : : "a" (GD_KD));
f0103c5d:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" : : "a" (GD_KD));
f0103c5f:	8e d0                	mov    %eax,%ss
	// Load the kernel text segment into CS.
	asm volatile("ljmp %0,$1f\n 1:\n" : : "i" (GD_KT));
f0103c61:	ea 68 3c 10 f0 08 00 	ljmp   $0x8,$0xf0103c68
	asm volatile("lldt %0" : : "r" (sel));
f0103c68:	b8 00 00 00 00       	mov    $0x0,%eax
f0103c6d:	0f 00 d0             	lldt   %ax
	// For good measure, clear the local descriptor table (LDT),
	// since we don't use it.
	lldt(0);
}
f0103c70:	c3                   	ret    

f0103c71 <env_init>:
{
f0103c71:	55                   	push   %ebp
f0103c72:	89 e5                	mov    %esp,%ebp
f0103c74:	56                   	push   %esi
f0103c75:	53                   	push   %ebx
		envs[i].env_id = 0;
f0103c76:	8b 35 48 42 34 f0    	mov    0xf0344248,%esi
f0103c7c:	8d 86 7c 0f 02 00    	lea    0x20f7c(%esi),%eax
f0103c82:	89 f3                	mov    %esi,%ebx
f0103c84:	ba 00 00 00 00       	mov    $0x0,%edx
f0103c89:	eb 02                	jmp    f0103c8d <env_init+0x1c>
f0103c8b:	89 c8                	mov    %ecx,%eax
f0103c8d:	c7 40 48 00 00 00 00 	movl   $0x0,0x48(%eax)
		envs[i].env_link = env_free_list;
f0103c94:	89 50 44             	mov    %edx,0x44(%eax)
		envs[i].env_status = ENV_FREE;		
f0103c97:	c7 40 54 00 00 00 00 	movl   $0x0,0x54(%eax)
f0103c9e:	8d 88 7c ff ff ff    	lea    -0x84(%eax),%ecx
		env_free_list = &envs[i];
f0103ca4:	89 c2                	mov    %eax,%edx
	for (; i >= 0; i--) {
f0103ca6:	39 d8                	cmp    %ebx,%eax
f0103ca8:	75 e1                	jne    f0103c8b <env_init+0x1a>
f0103caa:	89 35 4c 42 34 f0    	mov    %esi,0xf034424c
	env_init_percpu();
f0103cb0:	e8 90 ff ff ff       	call   f0103c45 <env_init_percpu>
}
f0103cb5:	5b                   	pop    %ebx
f0103cb6:	5e                   	pop    %esi
f0103cb7:	5d                   	pop    %ebp
f0103cb8:	c3                   	ret    

f0103cb9 <env_alloc>:
//	-E_NO_FREE_ENV if all NENV environments are allocated
//	-E_NO_MEM on memory exhaustion
//
int
env_alloc(struct Env **newenv_store, envid_t parent_id)
{
f0103cb9:	55                   	push   %ebp
f0103cba:	89 e5                	mov    %esp,%ebp
f0103cbc:	53                   	push   %ebx
f0103cbd:	83 ec 04             	sub    $0x4,%esp
	int32_t generation;
	int r;
	struct Env *e;

	if (!(e = env_free_list))
f0103cc0:	8b 1d 4c 42 34 f0    	mov    0xf034424c,%ebx
f0103cc6:	85 db                	test   %ebx,%ebx
f0103cc8:	0f 84 85 01 00 00    	je     f0103e53 <env_alloc+0x19a>
	if (!(p = page_alloc(ALLOC_ZERO)))
f0103cce:	83 ec 0c             	sub    $0xc,%esp
f0103cd1:	6a 01                	push   $0x1
f0103cd3:	e8 23 dc ff ff       	call   f01018fb <page_alloc>
f0103cd8:	83 c4 10             	add    $0x10,%esp
f0103cdb:	85 c0                	test   %eax,%eax
f0103cdd:	0f 84 77 01 00 00    	je     f0103e5a <env_alloc+0x1a1>
	p->pp_ref++;
f0103ce3:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0103ce8:	2b 05 90 5e 34 f0    	sub    0xf0345e90,%eax
f0103cee:	c1 f8 03             	sar    $0x3,%eax
f0103cf1:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0103cf4:	89 c2                	mov    %eax,%edx
f0103cf6:	c1 ea 0c             	shr    $0xc,%edx
f0103cf9:	3b 15 88 5e 34 f0    	cmp    0xf0345e88,%edx
f0103cff:	0f 83 27 01 00 00    	jae    f0103e2c <env_alloc+0x173>
	return (void *)(pa + KERNBASE);
f0103d05:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0103d0a:	89 43 60             	mov    %eax,0x60(%ebx)
	e->env_pgdir = page2kva(p);
f0103d0d:	b8 ec 0e 00 00       	mov    $0xeec,%eax
		e->env_pgdir[i] = kern_pgdir[i];
f0103d12:	8b 15 8c 5e 34 f0    	mov    0xf0345e8c,%edx
f0103d18:	8b 0c 02             	mov    (%edx,%eax,1),%ecx
f0103d1b:	8b 53 60             	mov    0x60(%ebx),%edx
f0103d1e:	89 0c 02             	mov    %ecx,(%edx,%eax,1)
f0103d21:	83 c0 04             	add    $0x4,%eax
	for(i=PDX(UTOP); i<NPDENTRIES; ++i){
f0103d24:	3d 00 10 00 00       	cmp    $0x1000,%eax
f0103d29:	75 e7                	jne    f0103d12 <env_alloc+0x59>
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f0103d2b:	8b 43 60             	mov    0x60(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f0103d2e:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103d33:	0f 86 05 01 00 00    	jbe    f0103e3e <env_alloc+0x185>
	return (physaddr_t)kva - KERNBASE;
f0103d39:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0103d3f:	83 ca 05             	or     $0x5,%edx
f0103d42:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	// Allocate and set up the page directory for this environment.
	if ((r = env_setup_vm(e)) < 0)
		return r;

	// Generate an env_id for this environment.
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f0103d48:	8b 43 48             	mov    0x48(%ebx),%eax
f0103d4b:	05 00 10 00 00       	add    $0x1000,%eax
	if (generation <= 0)	// Don't create a negative env_id.
f0103d50:	25 00 fc ff ff       	and    $0xfffffc00,%eax
		generation = 1 << ENVGENSHIFT;
f0103d55:	ba 00 10 00 00       	mov    $0x1000,%edx
f0103d5a:	0f 4e c2             	cmovle %edx,%eax
	e->env_id = generation | (e - envs);
f0103d5d:	89 da                	mov    %ebx,%edx
f0103d5f:	2b 15 48 42 34 f0    	sub    0xf0344248,%edx
f0103d65:	c1 fa 02             	sar    $0x2,%edx
f0103d68:	69 d2 e1 83 0f 3e    	imul   $0x3e0f83e1,%edx,%edx
f0103d6e:	09 d0                	or     %edx,%eax
f0103d70:	89 43 48             	mov    %eax,0x48(%ebx)

	// Set the basic status variables.
	e->env_parent_id = parent_id;
f0103d73:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103d76:	89 43 4c             	mov    %eax,0x4c(%ebx)
	e->env_type = ENV_TYPE_USER;
f0103d79:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
	e->env_status = ENV_RUNNABLE;
f0103d80:	c7 43 54 02 00 00 00 	movl   $0x2,0x54(%ebx)
	e->env_runs = 0;
f0103d87:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
	e->env_priority = ENV_PRIOR_NORMAL;
f0103d8e:	c7 83 80 00 00 00 67 	movl   $0x67,0x80(%ebx)
f0103d95:	00 00 00 

	// Clear out all the saved register state,
	// to prevent the register values
	// of a prior environment inhabiting this Env structure
	// from "leaking" into our new environment.
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f0103d98:	83 ec 04             	sub    $0x4,%esp
f0103d9b:	6a 44                	push   $0x44
f0103d9d:	6a 00                	push   $0x0
f0103d9f:	53                   	push   %ebx
f0103da0:	e8 ef 29 00 00       	call   f0106794 <memset>
	// The low 2 bits of each segment register contains the
	// Requestor Privilege Level (RPL); 3 means user mode.  When
	// we switch privilege levels, the hardware does various
	// checks involving the RPL and the Descriptor Privilege Level
	// (DPL) stored in the descriptors themselves.
	e->env_tf.tf_ds = GD_UD | 3;
f0103da5:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f0103dab:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f0103db1:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f0103db7:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;
f0103dbe:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
	// You will set e->env_tf.tf_eip later.

	// Enable interrupts while in user mode.
	// LAB 4: Your code here.
	e->env_tf.tf_eflags |= FL_IF;
f0103dc4:	81 4b 38 00 02 00 00 	orl    $0x200,0x38(%ebx)

	// Clear the page fault handler until user installs one.
	e->env_pgfault_upcall = 0;
f0103dcb:	c7 43 64 00 00 00 00 	movl   $0x0,0x64(%ebx)

	// Also clear the IPC receiving flag.
	e->env_ipc_recving = 0;
f0103dd2:	c6 43 68 00          	movb   $0x0,0x68(%ebx)

	// commit the allocation
	env_free_list = e->env_link;
f0103dd6:	8b 43 44             	mov    0x44(%ebx),%eax
f0103dd9:	a3 4c 42 34 f0       	mov    %eax,0xf034424c
	*newenv_store = e;
f0103dde:	8b 45 08             	mov    0x8(%ebp),%eax
f0103de1:	89 18                	mov    %ebx,(%eax)

	cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f0103de3:	8b 5b 48             	mov    0x48(%ebx),%ebx
f0103de6:	e8 af 2f 00 00       	call   f0106d9a <cpunum>
f0103deb:	6b c0 74             	imul   $0x74,%eax,%eax
f0103dee:	83 c4 10             	add    $0x10,%esp
f0103df1:	ba 00 00 00 00       	mov    $0x0,%edx
f0103df6:	83 b8 28 60 34 f0 00 	cmpl   $0x0,-0xfcb9fd8(%eax)
f0103dfd:	74 11                	je     f0103e10 <env_alloc+0x157>
f0103dff:	e8 96 2f 00 00       	call   f0106d9a <cpunum>
f0103e04:	6b c0 74             	imul   $0x74,%eax,%eax
f0103e07:	8b 80 28 60 34 f0    	mov    -0xfcb9fd8(%eax),%eax
f0103e0d:	8b 50 48             	mov    0x48(%eax),%edx
f0103e10:	83 ec 04             	sub    $0x4,%esp
f0103e13:	53                   	push   %ebx
f0103e14:	52                   	push   %edx
f0103e15:	68 ca 8b 10 f0       	push   $0xf0108bca
f0103e1a:	e8 ca 07 00 00       	call   f01045e9 <cprintf>
	return 0;
f0103e1f:	83 c4 10             	add    $0x10,%esp
f0103e22:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103e27:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103e2a:	c9                   	leave  
f0103e2b:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103e2c:	50                   	push   %eax
f0103e2d:	68 54 74 10 f0       	push   $0xf0107454
f0103e32:	6a 58                	push   $0x58
f0103e34:	68 88 87 10 f0       	push   $0xf0108788
f0103e39:	e8 0b c2 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103e3e:	50                   	push   %eax
f0103e3f:	68 78 74 10 f0       	push   $0xf0107478
f0103e44:	68 ca 00 00 00       	push   $0xca
f0103e49:	68 bf 8b 10 f0       	push   $0xf0108bbf
f0103e4e:	e8 f6 c1 ff ff       	call   f0100049 <_panic>
		return -E_NO_FREE_ENV;
f0103e53:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f0103e58:	eb cd                	jmp    f0103e27 <env_alloc+0x16e>
		return -E_NO_MEM;
f0103e5a:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0103e5f:	eb c6                	jmp    f0103e27 <env_alloc+0x16e>

f0103e61 <region_alloc>:
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
void
region_alloc(struct Env *e, void *va, size_t len)
{
f0103e61:	55                   	push   %ebp
f0103e62:	89 e5                	mov    %esp,%ebp
f0103e64:	57                   	push   %edi
f0103e65:	56                   	push   %esi
f0103e66:	53                   	push   %ebx
f0103e67:	83 ec 0c             	sub    $0xc,%esp
f0103e6a:	8b 7d 08             	mov    0x8(%ebp),%edi
f0103e6d:	8b 45 0c             	mov    0xc(%ebp),%eax
	//
	// Hint: It is easier to use region_alloc if the caller can pass
	//   'va' and 'len' values that are not page-aligned.
	//   You should round va down, and round (va + len) up.
	//   (Watch out for corner-cases!)
	if(!e) panic("region_alloc: e is NULL");
f0103e70:	85 ff                	test   %edi,%edi
f0103e72:	74 5d                	je     f0103ed1 <region_alloc+0x70>

	uintptr_t va_start = (uintptr_t) ROUNDDOWN(va, PGSIZE);
f0103e74:	89 c3                	mov    %eax,%ebx
f0103e76:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uintptr_t va_end = (uintptr_t) ROUNDUP(va+len, PGSIZE);
f0103e7c:	8b 55 10             	mov    0x10(%ebp),%edx
f0103e7f:	8d b4 10 ff 0f 00 00 	lea    0xfff(%eax,%edx,1),%esi
f0103e86:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	
	if(va_end>UTOP) panic("region_alloc: va out of range");
f0103e8c:	81 fe 00 00 c0 ee    	cmp    $0xeec00000,%esi
f0103e92:	77 54                	ja     f0103ee8 <region_alloc+0x87>
	if(va_start > va_end) panic("region_alloc: va out of range");
f0103e94:	39 f3                	cmp    %esi,%ebx
f0103e96:	77 67                	ja     f0103eff <region_alloc+0x9e>

	for(uintptr_t pos=va_start; pos<va_end; pos+=PGSIZE){
f0103e98:	39 f3                	cmp    %esi,%ebx
f0103e9a:	0f 83 a4 00 00 00    	jae    f0103f44 <region_alloc+0xe3>
		struct PageInfo *pageinfo = page_alloc(ALLOC_ZERO);
f0103ea0:	83 ec 0c             	sub    $0xc,%esp
f0103ea3:	6a 01                	push   $0x1
f0103ea5:	e8 51 da ff ff       	call   f01018fb <page_alloc>
		if(!pageinfo) panic("region_alloc: alloc PageInfo fail");
f0103eaa:	83 c4 10             	add    $0x10,%esp
f0103ead:	85 c0                	test   %eax,%eax
f0103eaf:	74 65                	je     f0103f16 <region_alloc+0xb5>
		pageinfo->pp_ref++;
f0103eb1:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
		if(page_insert(e->env_pgdir, pageinfo, (void *)pos, PTE_W | PTE_U) < 0)
f0103eb6:	6a 06                	push   $0x6
f0103eb8:	53                   	push   %ebx
f0103eb9:	50                   	push   %eax
f0103eba:	ff 77 60             	pushl  0x60(%edi)
f0103ebd:	e8 b0 de ff ff       	call   f0101d72 <page_insert>
f0103ec2:	83 c4 10             	add    $0x10,%esp
f0103ec5:	85 c0                	test   %eax,%eax
f0103ec7:	78 64                	js     f0103f2d <region_alloc+0xcc>
	for(uintptr_t pos=va_start; pos<va_end; pos+=PGSIZE){
f0103ec9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0103ecf:	eb c7                	jmp    f0103e98 <region_alloc+0x37>
	if(!e) panic("region_alloc: e is NULL");
f0103ed1:	83 ec 04             	sub    $0x4,%esp
f0103ed4:	68 df 8b 10 f0       	push   $0xf0108bdf
f0103ed9:	68 2a 01 00 00       	push   $0x12a
f0103ede:	68 bf 8b 10 f0       	push   $0xf0108bbf
f0103ee3:	e8 61 c1 ff ff       	call   f0100049 <_panic>
	if(va_end>UTOP) panic("region_alloc: va out of range");
f0103ee8:	83 ec 04             	sub    $0x4,%esp
f0103eeb:	68 f7 8b 10 f0       	push   $0xf0108bf7
f0103ef0:	68 2f 01 00 00       	push   $0x12f
f0103ef5:	68 bf 8b 10 f0       	push   $0xf0108bbf
f0103efa:	e8 4a c1 ff ff       	call   f0100049 <_panic>
	if(va_start > va_end) panic("region_alloc: va out of range");
f0103eff:	83 ec 04             	sub    $0x4,%esp
f0103f02:	68 f7 8b 10 f0       	push   $0xf0108bf7
f0103f07:	68 30 01 00 00       	push   $0x130
f0103f0c:	68 bf 8b 10 f0       	push   $0xf0108bbf
f0103f11:	e8 33 c1 ff ff       	call   f0100049 <_panic>
		if(!pageinfo) panic("region_alloc: alloc PageInfo fail");
f0103f16:	83 ec 04             	sub    $0x4,%esp
f0103f19:	68 7c 8b 10 f0       	push   $0xf0108b7c
f0103f1e:	68 34 01 00 00       	push   $0x134
f0103f23:	68 bf 8b 10 f0       	push   $0xf0108bbf
f0103f28:	e8 1c c1 ff ff       	call   f0100049 <_panic>
			panic("region_alloc: page_insert fail");
f0103f2d:	83 ec 04             	sub    $0x4,%esp
f0103f30:	68 a0 8b 10 f0       	push   $0xf0108ba0
f0103f35:	68 37 01 00 00       	push   $0x137
f0103f3a:	68 bf 8b 10 f0       	push   $0xf0108bbf
f0103f3f:	e8 05 c1 ff ff       	call   f0100049 <_panic>
	}
}
f0103f44:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103f47:	5b                   	pop    %ebx
f0103f48:	5e                   	pop    %esi
f0103f49:	5f                   	pop    %edi
f0103f4a:	5d                   	pop    %ebp
f0103f4b:	c3                   	ret    

f0103f4c <env_create>:
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, enum EnvType type)
{
f0103f4c:	55                   	push   %ebp
f0103f4d:	89 e5                	mov    %esp,%ebp
f0103f4f:	57                   	push   %edi
f0103f50:	56                   	push   %esi
f0103f51:	53                   	push   %ebx
f0103f52:	83 ec 2c             	sub    $0x2c,%esp
	// LAB 3: Your code here.
	if(!binary) panic("env_create: binary is NULL");
f0103f55:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0103f59:	74 50                	je     f0103fab <env_create+0x5f>

	struct Env *e;
	if(env_alloc(&e, 0) < 0)
f0103f5b:	83 ec 08             	sub    $0x8,%esp
f0103f5e:	6a 00                	push   $0x0
f0103f60:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0103f63:	50                   	push   %eax
f0103f64:	e8 50 fd ff ff       	call   f0103cb9 <env_alloc>
f0103f69:	83 c4 10             	add    $0x10,%esp
f0103f6c:	85 c0                	test   %eax,%eax
f0103f6e:	78 52                	js     f0103fc2 <env_create+0x76>
		panic("env_create: env_alloc() fail");
	
	e->env_type = type;
f0103f70:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0103f73:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103f76:	89 47 50             	mov    %eax,0x50(%edi)

	lcr3(PADDR(e->env_pgdir));
f0103f79:	8b 47 60             	mov    0x60(%edi),%eax
	if ((uint32_t)kva < KERNBASE)
f0103f7c:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103f81:	76 56                	jbe    f0103fd9 <env_create+0x8d>
	return (physaddr_t)kva - KERNBASE;
f0103f83:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0103f88:	0f 22 d8             	mov    %eax,%cr3
	struct Proghdr *ph = (struct Proghdr *)(binary + elf->e_phoff);
f0103f8b:	8b 45 08             	mov    0x8(%ebp),%eax
f0103f8e:	89 c3                	mov    %eax,%ebx
f0103f90:	03 58 1c             	add    0x1c(%eax),%ebx
	struct Proghdr *eph = ph + elf->e_phnum;
f0103f93:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
f0103f97:	c1 e0 05             	shl    $0x5,%eax
f0103f9a:	01 d8                	add    %ebx,%eax
f0103f9c:	89 45 cc             	mov    %eax,-0x34(%ebp)
	e->env_heap = UTEXT;
f0103f9f:	c7 47 7c 00 00 80 00 	movl   $0x800000,0x7c(%edi)
f0103fa6:	e9 98 00 00 00       	jmp    f0104043 <env_create+0xf7>
	if(!binary) panic("env_create: binary is NULL");
f0103fab:	83 ec 04             	sub    $0x4,%esp
f0103fae:	68 15 8c 10 f0       	push   $0xf0108c15
f0103fb3:	68 a0 01 00 00       	push   $0x1a0
f0103fb8:	68 bf 8b 10 f0       	push   $0xf0108bbf
f0103fbd:	e8 87 c0 ff ff       	call   f0100049 <_panic>
		panic("env_create: env_alloc() fail");
f0103fc2:	83 ec 04             	sub    $0x4,%esp
f0103fc5:	68 30 8c 10 f0       	push   $0xf0108c30
f0103fca:	68 a4 01 00 00       	push   $0x1a4
f0103fcf:	68 bf 8b 10 f0       	push   $0xf0108bbf
f0103fd4:	e8 70 c0 ff ff       	call   f0100049 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103fd9:	50                   	push   %eax
f0103fda:	68 78 74 10 f0       	push   $0xf0107478
f0103fdf:	68 a8 01 00 00       	push   $0x1a8
f0103fe4:	68 bf 8b 10 f0       	push   $0xf0108bbf
f0103fe9:	e8 5b c0 ff ff       	call   f0100049 <_panic>
			if(filesz > memsz) panic("load_icode: filesz > memsz");
f0103fee:	83 ec 04             	sub    $0x4,%esp
f0103ff1:	68 4d 8c 10 f0       	push   $0xf0108c4d
f0103ff6:	68 81 01 00 00       	push   $0x181
f0103ffb:	68 bf 8b 10 f0       	push   $0xf0108bbf
f0104000:	e8 44 c0 ff ff       	call   f0100049 <_panic>
			region_alloc(e, (void *)va, memsz);
f0104005:	83 ec 04             	sub    $0x4,%esp
f0104008:	56                   	push   %esi
f0104009:	ff 75 d4             	pushl  -0x2c(%ebp)
f010400c:	57                   	push   %edi
f010400d:	e8 4f fe ff ff       	call   f0103e61 <region_alloc>
			memmove((void *)va, binary + ph->p_offset, filesz);
f0104012:	83 c4 0c             	add    $0xc,%esp
f0104015:	ff 75 d0             	pushl  -0x30(%ebp)
f0104018:	8b 45 08             	mov    0x8(%ebp),%eax
f010401b:	03 43 04             	add    0x4(%ebx),%eax
f010401e:	50                   	push   %eax
f010401f:	ff 75 d4             	pushl  -0x2c(%ebp)
f0104022:	e8 b5 27 00 00       	call   f01067dc <memmove>
			memset((void *)(va + filesz), 0, memsz - filesz);
f0104027:	83 c4 0c             	add    $0xc,%esp
f010402a:	8b 55 d0             	mov    -0x30(%ebp),%edx
f010402d:	29 d6                	sub    %edx,%esi
f010402f:	56                   	push   %esi
f0104030:	6a 00                	push   $0x0
f0104032:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0104035:	01 d0                	add    %edx,%eax
f0104037:	50                   	push   %eax
f0104038:	e8 57 27 00 00       	call   f0106794 <memset>
f010403d:	83 c4 10             	add    $0x10,%esp
	for(; ph<eph; ph++){
f0104040:	83 c3 20             	add    $0x20,%ebx
f0104043:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
f0104046:	76 31                	jbe    f0104079 <env_create+0x12d>
		if(ph->p_type == ELF_PROG_LOAD){
f0104048:	83 3b 01             	cmpl   $0x1,(%ebx)
f010404b:	75 f3                	jne    f0104040 <env_create+0xf4>
			uint32_t va = ph->p_va;
f010404d:	8b 43 08             	mov    0x8(%ebx),%eax
f0104050:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			uint32_t memsz = ph->p_memsz;
f0104053:	8b 73 14             	mov    0x14(%ebx),%esi
			uint32_t filesz = ph->p_filesz;
f0104056:	8b 43 10             	mov    0x10(%ebx),%eax
f0104059:	89 45 d0             	mov    %eax,-0x30(%ebp)
			if(filesz > memsz) panic("load_icode: filesz > memsz");
f010405c:	39 c6                	cmp    %eax,%esi
f010405e:	72 8e                	jb     f0103fee <env_create+0xa2>
			if(va+memsz > e->env_heap){
f0104060:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0104063:	01 f0                	add    %esi,%eax
f0104065:	3b 47 7c             	cmp    0x7c(%edi),%eax
f0104068:	76 9b                	jbe    f0104005 <env_create+0xb9>
				e->env_heap = ROUNDUP(va + memsz, PGSIZE);
f010406a:	05 ff 0f 00 00       	add    $0xfff,%eax
f010406f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0104074:	89 47 7c             	mov    %eax,0x7c(%edi)
f0104077:	eb 8c                	jmp    f0104005 <env_create+0xb9>
	e->env_tf.tf_eip = elf->e_entry;
f0104079:	8b 45 08             	mov    0x8(%ebp),%eax
f010407c:	8b 40 18             	mov    0x18(%eax),%eax
f010407f:	89 47 30             	mov    %eax,0x30(%edi)
	region_alloc(e, (void *)(USTACKTOP - PGSIZE), PGSIZE);
f0104082:	83 ec 04             	sub    $0x4,%esp
f0104085:	68 00 10 00 00       	push   $0x1000
f010408a:	68 00 d0 bf ee       	push   $0xeebfd000
f010408f:	57                   	push   %edi
f0104090:	e8 cc fd ff ff       	call   f0103e61 <region_alloc>
	load_icode(e, binary);
	lcr3(PADDR(kern_pgdir));
f0104095:	a1 8c 5e 34 f0       	mov    0xf0345e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f010409a:	83 c4 10             	add    $0x10,%esp
f010409d:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01040a2:	76 10                	jbe    f01040b4 <env_create+0x168>
	return (physaddr_t)kva - KERNBASE;
f01040a4:	05 00 00 00 10       	add    $0x10000000,%eax
f01040a9:	0f 22 d8             	mov    %eax,%cr3

}
f01040ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01040af:	5b                   	pop    %ebx
f01040b0:	5e                   	pop    %esi
f01040b1:	5f                   	pop    %edi
f01040b2:	5d                   	pop    %ebp
f01040b3:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01040b4:	50                   	push   %eax
f01040b5:	68 78 74 10 f0       	push   $0xf0107478
f01040ba:	68 aa 01 00 00       	push   $0x1aa
f01040bf:	68 bf 8b 10 f0       	push   $0xf0108bbf
f01040c4:	e8 80 bf ff ff       	call   f0100049 <_panic>

f01040c9 <env_free>:
//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e)
{
f01040c9:	55                   	push   %ebp
f01040ca:	89 e5                	mov    %esp,%ebp
f01040cc:	57                   	push   %edi
f01040cd:	56                   	push   %esi
f01040ce:	53                   	push   %ebx
f01040cf:	83 ec 1c             	sub    $0x1c,%esp
f01040d2:	8b 7d 08             	mov    0x8(%ebp),%edi
	physaddr_t pa;

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f01040d5:	e8 c0 2c 00 00       	call   f0106d9a <cpunum>
f01040da:	6b c0 74             	imul   $0x74,%eax,%eax
f01040dd:	39 b8 28 60 34 f0    	cmp    %edi,-0xfcb9fd8(%eax)
f01040e3:	74 48                	je     f010412d <env_free+0x64>
		lcr3(PADDR(kern_pgdir));

	// Note the environment's demise.
	cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f01040e5:	8b 5f 48             	mov    0x48(%edi),%ebx
f01040e8:	e8 ad 2c 00 00       	call   f0106d9a <cpunum>
f01040ed:	6b c0 74             	imul   $0x74,%eax,%eax
f01040f0:	ba 00 00 00 00       	mov    $0x0,%edx
f01040f5:	83 b8 28 60 34 f0 00 	cmpl   $0x0,-0xfcb9fd8(%eax)
f01040fc:	74 11                	je     f010410f <env_free+0x46>
f01040fe:	e8 97 2c 00 00       	call   f0106d9a <cpunum>
f0104103:	6b c0 74             	imul   $0x74,%eax,%eax
f0104106:	8b 80 28 60 34 f0    	mov    -0xfcb9fd8(%eax),%eax
f010410c:	8b 50 48             	mov    0x48(%eax),%edx
f010410f:	83 ec 04             	sub    $0x4,%esp
f0104112:	53                   	push   %ebx
f0104113:	52                   	push   %edx
f0104114:	68 68 8c 10 f0       	push   $0xf0108c68
f0104119:	e8 cb 04 00 00       	call   f01045e9 <cprintf>
f010411e:	83 c4 10             	add    $0x10,%esp
f0104121:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f0104128:	e9 a9 00 00 00       	jmp    f01041d6 <env_free+0x10d>
		lcr3(PADDR(kern_pgdir));
f010412d:	a1 8c 5e 34 f0       	mov    0xf0345e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f0104132:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0104137:	76 0a                	jbe    f0104143 <env_free+0x7a>
	return (physaddr_t)kva - KERNBASE;
f0104139:	05 00 00 00 10       	add    $0x10000000,%eax
f010413e:	0f 22 d8             	mov    %eax,%cr3
f0104141:	eb a2                	jmp    f01040e5 <env_free+0x1c>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0104143:	50                   	push   %eax
f0104144:	68 78 74 10 f0       	push   $0xf0107478
f0104149:	68 bc 01 00 00       	push   $0x1bc
f010414e:	68 bf 8b 10 f0       	push   $0xf0108bbf
f0104153:	e8 f1 be ff ff       	call   f0100049 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0104158:	56                   	push   %esi
f0104159:	68 54 74 10 f0       	push   $0xf0107454
f010415e:	68 cb 01 00 00       	push   $0x1cb
f0104163:	68 bf 8b 10 f0       	push   $0xf0108bbf
f0104168:	e8 dc be ff ff       	call   f0100049 <_panic>
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f010416d:	83 ec 08             	sub    $0x8,%esp
f0104170:	89 d8                	mov    %ebx,%eax
f0104172:	c1 e0 0c             	shl    $0xc,%eax
f0104175:	0b 45 e4             	or     -0x1c(%ebp),%eax
f0104178:	50                   	push   %eax
f0104179:	ff 77 60             	pushl  0x60(%edi)
f010417c:	e8 8d db ff ff       	call   f0101d0e <page_remove>
f0104181:	83 c4 10             	add    $0x10,%esp
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0104184:	83 c3 01             	add    $0x1,%ebx
f0104187:	83 c6 04             	add    $0x4,%esi
f010418a:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
f0104190:	74 07                	je     f0104199 <env_free+0xd0>
			if (pt[pteno] & PTE_P)
f0104192:	f6 06 01             	testb  $0x1,(%esi)
f0104195:	74 ed                	je     f0104184 <env_free+0xbb>
f0104197:	eb d4                	jmp    f010416d <env_free+0xa4>
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f0104199:	8b 47 60             	mov    0x60(%edi),%eax
f010419c:	8b 55 e0             	mov    -0x20(%ebp),%edx
f010419f:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	if (PGNUM(pa) >= npages)
f01041a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01041a9:	3b 05 88 5e 34 f0    	cmp    0xf0345e88,%eax
f01041af:	73 69                	jae    f010421a <env_free+0x151>
		page_decref(pa2page(pa));
f01041b1:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f01041b4:	a1 90 5e 34 f0       	mov    0xf0345e90,%eax
f01041b9:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01041bc:	8d 04 d0             	lea    (%eax,%edx,8),%eax
f01041bf:	50                   	push   %eax
f01041c0:	e8 15 d8 ff ff       	call   f01019da <page_decref>
f01041c5:	83 c4 10             	add    $0x10,%esp
f01041c8:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
f01041cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f01041cf:	3d ec 0e 00 00       	cmp    $0xeec,%eax
f01041d4:	74 58                	je     f010422e <env_free+0x165>
		if (!(e->env_pgdir[pdeno] & PTE_P))
f01041d6:	8b 47 60             	mov    0x60(%edi),%eax
f01041d9:	8b 55 e0             	mov    -0x20(%ebp),%edx
f01041dc:	8b 34 10             	mov    (%eax,%edx,1),%esi
f01041df:	f7 c6 01 00 00 00    	test   $0x1,%esi
f01041e5:	74 e1                	je     f01041c8 <env_free+0xff>
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f01041e7:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if (PGNUM(pa) >= npages)
f01041ed:	89 f0                	mov    %esi,%eax
f01041ef:	c1 e8 0c             	shr    $0xc,%eax
f01041f2:	89 45 dc             	mov    %eax,-0x24(%ebp)
f01041f5:	39 05 88 5e 34 f0    	cmp    %eax,0xf0345e88
f01041fb:	0f 86 57 ff ff ff    	jbe    f0104158 <env_free+0x8f>
	return (void *)(pa + KERNBASE);
f0104201:	81 ee 00 00 00 10    	sub    $0x10000000,%esi
f0104207:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010420a:	c1 e0 14             	shl    $0x14,%eax
f010420d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0104210:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104215:	e9 78 ff ff ff       	jmp    f0104192 <env_free+0xc9>
		panic("pa2page called with invalid pa");
f010421a:	83 ec 04             	sub    $0x4,%esp
f010421d:	68 fc 7e 10 f0       	push   $0xf0107efc
f0104222:	6a 51                	push   $0x51
f0104224:	68 88 87 10 f0       	push   $0xf0108788
f0104229:	e8 1b be ff ff       	call   f0100049 <_panic>
	}

	// free the page directory
	pa = PADDR(e->env_pgdir);
f010422e:	8b 47 60             	mov    0x60(%edi),%eax
	if ((uint32_t)kva < KERNBASE)
f0104231:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0104236:	76 49                	jbe    f0104281 <env_free+0x1b8>
	e->env_pgdir = 0;
f0104238:	c7 47 60 00 00 00 00 	movl   $0x0,0x60(%edi)
	return (physaddr_t)kva - KERNBASE;
f010423f:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f0104244:	c1 e8 0c             	shr    $0xc,%eax
f0104247:	3b 05 88 5e 34 f0    	cmp    0xf0345e88,%eax
f010424d:	73 47                	jae    f0104296 <env_free+0x1cd>
	page_decref(pa2page(pa));
f010424f:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f0104252:	8b 15 90 5e 34 f0    	mov    0xf0345e90,%edx
f0104258:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f010425b:	50                   	push   %eax
f010425c:	e8 79 d7 ff ff       	call   f01019da <page_decref>

	// return the environment to the free list
	e->env_status = ENV_FREE;
f0104261:	c7 47 54 00 00 00 00 	movl   $0x0,0x54(%edi)
	e->env_link = env_free_list;
f0104268:	a1 4c 42 34 f0       	mov    0xf034424c,%eax
f010426d:	89 47 44             	mov    %eax,0x44(%edi)
	env_free_list = e;
f0104270:	89 3d 4c 42 34 f0    	mov    %edi,0xf034424c
}
f0104276:	83 c4 10             	add    $0x10,%esp
f0104279:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010427c:	5b                   	pop    %ebx
f010427d:	5e                   	pop    %esi
f010427e:	5f                   	pop    %edi
f010427f:	5d                   	pop    %ebp
f0104280:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0104281:	50                   	push   %eax
f0104282:	68 78 74 10 f0       	push   $0xf0107478
f0104287:	68 d9 01 00 00       	push   $0x1d9
f010428c:	68 bf 8b 10 f0       	push   $0xf0108bbf
f0104291:	e8 b3 bd ff ff       	call   f0100049 <_panic>
		panic("pa2page called with invalid pa");
f0104296:	83 ec 04             	sub    $0x4,%esp
f0104299:	68 fc 7e 10 f0       	push   $0xf0107efc
f010429e:	6a 51                	push   $0x51
f01042a0:	68 88 87 10 f0       	push   $0xf0108788
f01042a5:	e8 9f bd ff ff       	call   f0100049 <_panic>

f01042aa <env_destroy>:
// If e was the current env, then runs a new environment (and does not return
// to the caller).
//
void
env_destroy(struct Env *e)
{
f01042aa:	55                   	push   %ebp
f01042ab:	89 e5                	mov    %esp,%ebp
f01042ad:	53                   	push   %ebx
f01042ae:	83 ec 04             	sub    $0x4,%esp
f01042b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// If e is currently running on other CPUs, we change its state to
	// ENV_DYING. A zombie environment will be freed the next time
	// it traps to the kernel.
	if (e->env_status == ENV_RUNNING && curenv != e) {
f01042b4:	83 7b 54 03          	cmpl   $0x3,0x54(%ebx)
f01042b8:	74 21                	je     f01042db <env_destroy+0x31>
		e->env_status = ENV_DYING;
		return;
	}

	env_free(e);
f01042ba:	83 ec 0c             	sub    $0xc,%esp
f01042bd:	53                   	push   %ebx
f01042be:	e8 06 fe ff ff       	call   f01040c9 <env_free>

	if (curenv == e) {
f01042c3:	e8 d2 2a 00 00       	call   f0106d9a <cpunum>
f01042c8:	6b c0 74             	imul   $0x74,%eax,%eax
f01042cb:	83 c4 10             	add    $0x10,%esp
f01042ce:	39 98 28 60 34 f0    	cmp    %ebx,-0xfcb9fd8(%eax)
f01042d4:	74 1e                	je     f01042f4 <env_destroy+0x4a>
		curenv = NULL;
		sched_yield();
	}
}
f01042d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01042d9:	c9                   	leave  
f01042da:	c3                   	ret    
	if (e->env_status == ENV_RUNNING && curenv != e) {
f01042db:	e8 ba 2a 00 00       	call   f0106d9a <cpunum>
f01042e0:	6b c0 74             	imul   $0x74,%eax,%eax
f01042e3:	39 98 28 60 34 f0    	cmp    %ebx,-0xfcb9fd8(%eax)
f01042e9:	74 cf                	je     f01042ba <env_destroy+0x10>
		e->env_status = ENV_DYING;
f01042eb:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
		return;
f01042f2:	eb e2                	jmp    f01042d6 <env_destroy+0x2c>
		curenv = NULL;
f01042f4:	e8 a1 2a 00 00       	call   f0106d9a <cpunum>
f01042f9:	6b c0 74             	imul   $0x74,%eax,%eax
f01042fc:	c7 80 28 60 34 f0 00 	movl   $0x0,-0xfcb9fd8(%eax)
f0104303:	00 00 00 
		sched_yield();
f0104306:	e8 96 0f 00 00       	call   f01052a1 <sched_yield>

f010430b <env_pop_tf>:
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf)
{
f010430b:	55                   	push   %ebp
f010430c:	89 e5                	mov    %esp,%ebp
f010430e:	53                   	push   %ebx
f010430f:	83 ec 04             	sub    $0x4,%esp
	// Record the CPU we are running on for user-space debugging
	curenv->env_cpunum = cpunum();
f0104312:	e8 83 2a 00 00       	call   f0106d9a <cpunum>
f0104317:	6b c0 74             	imul   $0x74,%eax,%eax
f010431a:	8b 98 28 60 34 f0    	mov    -0xfcb9fd8(%eax),%ebx
f0104320:	e8 75 2a 00 00       	call   f0106d9a <cpunum>
f0104325:	89 43 5c             	mov    %eax,0x5c(%ebx)
	// cprintf("env_pop_tf()\n");
	// print_trapframe(tf);
	

	asm volatile(
f0104328:	8b 65 08             	mov    0x8(%ebp),%esp
f010432b:	61                   	popa   
f010432c:	07                   	pop    %es
f010432d:	1f                   	pop    %ds
f010432e:	83 c4 08             	add    $0x8,%esp
f0104331:	cf                   	iret   
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret\n"
		: : "g" (tf) : "memory");
	// cprintf("irte finish\n");
	panic("iret failed");  /* mostly to placate the compiler */
f0104332:	83 ec 04             	sub    $0x4,%esp
f0104335:	68 7e 8c 10 f0       	push   $0xf0108c7e
f010433a:	68 14 02 00 00       	push   $0x214
f010433f:	68 bf 8b 10 f0       	push   $0xf0108bbf
f0104344:	e8 00 bd ff ff       	call   f0100049 <_panic>

f0104349 <env_run>:
//
// This function does not return.
//
void
env_run(struct Env *e)
{
f0104349:	55                   	push   %ebp
f010434a:	89 e5                	mov    %esp,%ebp
f010434c:	53                   	push   %ebx
f010434d:	83 ec 04             	sub    $0x4,%esp
f0104350:	8b 5d 08             	mov    0x8(%ebp),%ebx

	// LAB 3: Your code here.

	// panic("env_run not yet implemented");
	// cprintf("env_run()\n");
	if(!e) panic("env_run: e is NULL");
f0104353:	85 db                	test   %ebx,%ebx
f0104355:	0f 84 b3 00 00 00    	je     f010440e <env_run+0xc5>

	if(curenv != e){
f010435b:	e8 3a 2a 00 00       	call   f0106d9a <cpunum>
f0104360:	6b c0 74             	imul   $0x74,%eax,%eax
f0104363:	39 98 28 60 34 f0    	cmp    %ebx,-0xfcb9fd8(%eax)
f0104369:	74 7e                	je     f01043e9 <env_run+0xa0>
		if(curenv && curenv->env_status == ENV_RUNNING){
f010436b:	e8 2a 2a 00 00       	call   f0106d9a <cpunum>
f0104370:	6b c0 74             	imul   $0x74,%eax,%eax
f0104373:	83 b8 28 60 34 f0 00 	cmpl   $0x0,-0xfcb9fd8(%eax)
f010437a:	74 18                	je     f0104394 <env_run+0x4b>
f010437c:	e8 19 2a 00 00       	call   f0106d9a <cpunum>
f0104381:	6b c0 74             	imul   $0x74,%eax,%eax
f0104384:	8b 80 28 60 34 f0    	mov    -0xfcb9fd8(%eax),%eax
f010438a:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f010438e:	0f 84 91 00 00 00    	je     f0104425 <env_run+0xdc>
			curenv->env_status = ENV_RUNNABLE;
		}

		curenv = e;
f0104394:	e8 01 2a 00 00       	call   f0106d9a <cpunum>
f0104399:	6b c0 74             	imul   $0x74,%eax,%eax
f010439c:	89 98 28 60 34 f0    	mov    %ebx,-0xfcb9fd8(%eax)
		curenv->env_status = ENV_RUNNING;
f01043a2:	e8 f3 29 00 00       	call   f0106d9a <cpunum>
f01043a7:	6b c0 74             	imul   $0x74,%eax,%eax
f01043aa:	8b 80 28 60 34 f0    	mov    -0xfcb9fd8(%eax),%eax
f01043b0:	c7 40 54 03 00 00 00 	movl   $0x3,0x54(%eax)
		curenv->env_runs++;
f01043b7:	e8 de 29 00 00       	call   f0106d9a <cpunum>
f01043bc:	6b c0 74             	imul   $0x74,%eax,%eax
f01043bf:	8b 80 28 60 34 f0    	mov    -0xfcb9fd8(%eax),%eax
f01043c5:	83 40 58 01          	addl   $0x1,0x58(%eax)
		lcr3(PADDR(curenv->env_pgdir));
f01043c9:	e8 cc 29 00 00       	call   f0106d9a <cpunum>
f01043ce:	6b c0 74             	imul   $0x74,%eax,%eax
f01043d1:	8b 80 28 60 34 f0    	mov    -0xfcb9fd8(%eax),%eax
f01043d7:	8b 40 60             	mov    0x60(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f01043da:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01043df:	76 5e                	jbe    f010443f <env_run+0xf6>
	return (physaddr_t)kva - KERNBASE;
f01043e1:	05 00 00 00 10       	add    $0x10000000,%eax
f01043e6:	0f 22 d8             	mov    %eax,%cr3
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f01043e9:	83 ec 0c             	sub    $0xc,%esp
f01043ec:	68 c0 53 12 f0       	push   $0xf01253c0
f01043f1:	e8 b0 2c 00 00       	call   f01070a6 <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f01043f6:	f3 90                	pause  
	}

	unlock_kernel();
	// cprintf("env_run() end\n");
	env_pop_tf(&curenv->env_tf);
f01043f8:	e8 9d 29 00 00       	call   f0106d9a <cpunum>
f01043fd:	83 c4 04             	add    $0x4,%esp
f0104400:	6b c0 74             	imul   $0x74,%eax,%eax
f0104403:	ff b0 28 60 34 f0    	pushl  -0xfcb9fd8(%eax)
f0104409:	e8 fd fe ff ff       	call   f010430b <env_pop_tf>
	if(!e) panic("env_run: e is NULL");
f010440e:	83 ec 04             	sub    $0x4,%esp
f0104411:	68 8a 8c 10 f0       	push   $0xf0108c8a
f0104416:	68 35 02 00 00       	push   $0x235
f010441b:	68 bf 8b 10 f0       	push   $0xf0108bbf
f0104420:	e8 24 bc ff ff       	call   f0100049 <_panic>
			curenv->env_status = ENV_RUNNABLE;
f0104425:	e8 70 29 00 00       	call   f0106d9a <cpunum>
f010442a:	6b c0 74             	imul   $0x74,%eax,%eax
f010442d:	8b 80 28 60 34 f0    	mov    -0xfcb9fd8(%eax),%eax
f0104433:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
f010443a:	e9 55 ff ff ff       	jmp    f0104394 <env_run+0x4b>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010443f:	50                   	push   %eax
f0104440:	68 78 74 10 f0       	push   $0xf0107478
f0104445:	68 3f 02 00 00       	push   $0x23f
f010444a:	68 bf 8b 10 f0       	push   $0xf0108bbf
f010444f:	e8 f5 bb ff ff       	call   f0100049 <_panic>

f0104454 <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f0104454:	55                   	push   %ebp
f0104455:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0104457:	8b 45 08             	mov    0x8(%ebp),%eax
f010445a:	ba 70 00 00 00       	mov    $0x70,%edx
f010445f:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0104460:	ba 71 00 00 00       	mov    $0x71,%edx
f0104465:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f0104466:	0f b6 c0             	movzbl %al,%eax
}
f0104469:	5d                   	pop    %ebp
f010446a:	c3                   	ret    

f010446b <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f010446b:	55                   	push   %ebp
f010446c:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010446e:	8b 45 08             	mov    0x8(%ebp),%eax
f0104471:	ba 70 00 00 00       	mov    $0x70,%edx
f0104476:	ee                   	out    %al,(%dx)
f0104477:	8b 45 0c             	mov    0xc(%ebp),%eax
f010447a:	ba 71 00 00 00       	mov    $0x71,%edx
f010447f:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f0104480:	5d                   	pop    %ebp
f0104481:	c3                   	ret    

f0104482 <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f0104482:	55                   	push   %ebp
f0104483:	89 e5                	mov    %esp,%ebp
f0104485:	56                   	push   %esi
f0104486:	53                   	push   %ebx
f0104487:	8b 45 08             	mov    0x8(%ebp),%eax
	int i;
	irq_mask_8259A = mask;
f010448a:	66 a3 a8 53 12 f0    	mov    %ax,0xf01253a8
	if (!didinit)
f0104490:	80 3d 50 42 34 f0 00 	cmpb   $0x0,0xf0344250
f0104497:	75 07                	jne    f01044a0 <irq_setmask_8259A+0x1e>
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
}
f0104499:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010449c:	5b                   	pop    %ebx
f010449d:	5e                   	pop    %esi
f010449e:	5d                   	pop    %ebp
f010449f:	c3                   	ret    
f01044a0:	89 c6                	mov    %eax,%esi
f01044a2:	ba 21 00 00 00       	mov    $0x21,%edx
f01044a7:	ee                   	out    %al,(%dx)
	outb(IO_PIC2+1, (char)(mask >> 8));
f01044a8:	66 c1 e8 08          	shr    $0x8,%ax
f01044ac:	ba a1 00 00 00       	mov    $0xa1,%edx
f01044b1:	ee                   	out    %al,(%dx)
	cprintf("enabled interrupts:");
f01044b2:	83 ec 0c             	sub    $0xc,%esp
f01044b5:	68 9d 8c 10 f0       	push   $0xf0108c9d
f01044ba:	e8 2a 01 00 00       	call   f01045e9 <cprintf>
f01044bf:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f01044c2:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (~mask & (1<<i))
f01044c7:	0f b7 f6             	movzwl %si,%esi
f01044ca:	f7 d6                	not    %esi
f01044cc:	eb 19                	jmp    f01044e7 <irq_setmask_8259A+0x65>
			cprintf(" %d", i);
f01044ce:	83 ec 08             	sub    $0x8,%esp
f01044d1:	53                   	push   %ebx
f01044d2:	68 9b 91 10 f0       	push   $0xf010919b
f01044d7:	e8 0d 01 00 00       	call   f01045e9 <cprintf>
f01044dc:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f01044df:	83 c3 01             	add    $0x1,%ebx
f01044e2:	83 fb 10             	cmp    $0x10,%ebx
f01044e5:	74 07                	je     f01044ee <irq_setmask_8259A+0x6c>
		if (~mask & (1<<i))
f01044e7:	0f a3 de             	bt     %ebx,%esi
f01044ea:	73 f3                	jae    f01044df <irq_setmask_8259A+0x5d>
f01044ec:	eb e0                	jmp    f01044ce <irq_setmask_8259A+0x4c>
	cprintf("\n");
f01044ee:	83 ec 0c             	sub    $0xc,%esp
f01044f1:	68 33 8b 10 f0       	push   $0xf0108b33
f01044f6:	e8 ee 00 00 00       	call   f01045e9 <cprintf>
f01044fb:	83 c4 10             	add    $0x10,%esp
f01044fe:	eb 99                	jmp    f0104499 <irq_setmask_8259A+0x17>

f0104500 <pic_init>:
{
f0104500:	55                   	push   %ebp
f0104501:	89 e5                	mov    %esp,%ebp
f0104503:	57                   	push   %edi
f0104504:	56                   	push   %esi
f0104505:	53                   	push   %ebx
f0104506:	83 ec 0c             	sub    $0xc,%esp
	didinit = 1;
f0104509:	c6 05 50 42 34 f0 01 	movb   $0x1,0xf0344250
f0104510:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104515:	bb 21 00 00 00       	mov    $0x21,%ebx
f010451a:	89 da                	mov    %ebx,%edx
f010451c:	ee                   	out    %al,(%dx)
f010451d:	b9 a1 00 00 00       	mov    $0xa1,%ecx
f0104522:	89 ca                	mov    %ecx,%edx
f0104524:	ee                   	out    %al,(%dx)
f0104525:	bf 11 00 00 00       	mov    $0x11,%edi
f010452a:	be 20 00 00 00       	mov    $0x20,%esi
f010452f:	89 f8                	mov    %edi,%eax
f0104531:	89 f2                	mov    %esi,%edx
f0104533:	ee                   	out    %al,(%dx)
f0104534:	b8 20 00 00 00       	mov    $0x20,%eax
f0104539:	89 da                	mov    %ebx,%edx
f010453b:	ee                   	out    %al,(%dx)
f010453c:	b8 04 00 00 00       	mov    $0x4,%eax
f0104541:	ee                   	out    %al,(%dx)
f0104542:	b8 03 00 00 00       	mov    $0x3,%eax
f0104547:	ee                   	out    %al,(%dx)
f0104548:	bb a0 00 00 00       	mov    $0xa0,%ebx
f010454d:	89 f8                	mov    %edi,%eax
f010454f:	89 da                	mov    %ebx,%edx
f0104551:	ee                   	out    %al,(%dx)
f0104552:	b8 28 00 00 00       	mov    $0x28,%eax
f0104557:	89 ca                	mov    %ecx,%edx
f0104559:	ee                   	out    %al,(%dx)
f010455a:	b8 02 00 00 00       	mov    $0x2,%eax
f010455f:	ee                   	out    %al,(%dx)
f0104560:	b8 01 00 00 00       	mov    $0x1,%eax
f0104565:	ee                   	out    %al,(%dx)
f0104566:	bf 68 00 00 00       	mov    $0x68,%edi
f010456b:	89 f8                	mov    %edi,%eax
f010456d:	89 f2                	mov    %esi,%edx
f010456f:	ee                   	out    %al,(%dx)
f0104570:	b9 0a 00 00 00       	mov    $0xa,%ecx
f0104575:	89 c8                	mov    %ecx,%eax
f0104577:	ee                   	out    %al,(%dx)
f0104578:	89 f8                	mov    %edi,%eax
f010457a:	89 da                	mov    %ebx,%edx
f010457c:	ee                   	out    %al,(%dx)
f010457d:	89 c8                	mov    %ecx,%eax
f010457f:	ee                   	out    %al,(%dx)
	if (irq_mask_8259A != 0xFFFF)
f0104580:	0f b7 05 a8 53 12 f0 	movzwl 0xf01253a8,%eax
f0104587:	66 83 f8 ff          	cmp    $0xffff,%ax
f010458b:	75 08                	jne    f0104595 <pic_init+0x95>
}
f010458d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104590:	5b                   	pop    %ebx
f0104591:	5e                   	pop    %esi
f0104592:	5f                   	pop    %edi
f0104593:	5d                   	pop    %ebp
f0104594:	c3                   	ret    
		irq_setmask_8259A(irq_mask_8259A);
f0104595:	83 ec 0c             	sub    $0xc,%esp
f0104598:	0f b7 c0             	movzwl %ax,%eax
f010459b:	50                   	push   %eax
f010459c:	e8 e1 fe ff ff       	call   f0104482 <irq_setmask_8259A>
f01045a1:	83 c4 10             	add    $0x10,%esp
}
f01045a4:	eb e7                	jmp    f010458d <pic_init+0x8d>

f01045a6 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f01045a6:	55                   	push   %ebp
f01045a7:	89 e5                	mov    %esp,%ebp
f01045a9:	53                   	push   %ebx
f01045aa:	83 ec 10             	sub    $0x10,%esp
f01045ad:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	cputchar(ch);
f01045b0:	ff 75 08             	pushl  0x8(%ebp)
f01045b3:	e8 6f c2 ff ff       	call   f0100827 <cputchar>
	(*cnt)++;
f01045b8:	83 03 01             	addl   $0x1,(%ebx)
}
f01045bb:	83 c4 10             	add    $0x10,%esp
f01045be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01045c1:	c9                   	leave  
f01045c2:	c3                   	ret    

f01045c3 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f01045c3:	55                   	push   %ebp
f01045c4:	89 e5                	mov    %esp,%ebp
f01045c6:	83 ec 18             	sub    $0x18,%esp
	int cnt = 0;
f01045c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f01045d0:	ff 75 0c             	pushl  0xc(%ebp)
f01045d3:	ff 75 08             	pushl  0x8(%ebp)
f01045d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01045d9:	50                   	push   %eax
f01045da:	68 a6 45 10 f0       	push   $0xf01045a6
f01045df:	e8 83 19 00 00       	call   f0105f67 <vprintfmt>
	return cnt;
}
f01045e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01045e7:	c9                   	leave  
f01045e8:	c3                   	ret    

f01045e9 <cprintf>:

int
cprintf(const char *fmt, ...)
{
f01045e9:	55                   	push   %ebp
f01045ea:	89 e5                	mov    %esp,%ebp
f01045ec:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f01045ef:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f01045f2:	50                   	push   %eax
f01045f3:	ff 75 08             	pushl  0x8(%ebp)
f01045f6:	e8 c8 ff ff ff       	call   f01045c3 <vcprintf>
	va_end(ap);

	return cnt;
}
f01045fb:	c9                   	leave  
f01045fc:	c3                   	ret    

f01045fd <trap_init_percpu>:
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
f01045fd:	55                   	push   %ebp
f01045fe:	89 e5                	mov    %esp,%ebp
f0104600:	57                   	push   %edi
f0104601:	56                   	push   %esi
f0104602:	53                   	push   %ebx
f0104603:	83 ec 1c             	sub    $0x1c,%esp

	// // Load the TSS selector (like other segment selectors, the
	// // bottom three bits are special; we leave them 0)
	// ltr(GD_TSS0);

	int cpu_idx = thiscpu->cpu_id;
f0104606:	e8 8f 27 00 00       	call   f0106d9a <cpunum>
f010460b:	6b c0 74             	imul   $0x74,%eax,%eax
f010460e:	0f b6 98 20 60 34 f0 	movzbl -0xfcb9fe0(%eax),%ebx
	thiscpu->cpu_ts.ts_esp0 = KSTACKTOP - cpu_idx * (KSTKSIZE + KSTKGAP);
f0104615:	e8 80 27 00 00       	call   f0106d9a <cpunum>
f010461a:	6b c0 74             	imul   $0x74,%eax,%eax
f010461d:	89 d9                	mov    %ebx,%ecx
f010461f:	c1 e1 10             	shl    $0x10,%ecx
f0104622:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0104627:	29 ca                	sub    %ecx,%edx
f0104629:	89 90 30 60 34 f0    	mov    %edx,-0xfcb9fd0(%eax)
	thiscpu->cpu_ts.ts_ss0 = GD_KD;
f010462f:	e8 66 27 00 00       	call   f0106d9a <cpunum>
f0104634:	6b c0 74             	imul   $0x74,%eax,%eax
f0104637:	66 c7 80 34 60 34 f0 	movw   $0x10,-0xfcb9fcc(%eax)
f010463e:	10 00 
	thiscpu->cpu_ts.ts_iomb = sizeof(struct Taskstate);
f0104640:	e8 55 27 00 00       	call   f0106d9a <cpunum>
f0104645:	6b c0 74             	imul   $0x74,%eax,%eax
f0104648:	66 c7 80 92 60 34 f0 	movw   $0x68,-0xfcb9f6e(%eax)
f010464f:	68 00 

	int GD_TSS_idx = GD_TSS0 + (cpu_idx << 3);
f0104651:	8d 3c dd 28 00 00 00 	lea    0x28(,%ebx,8),%edi
	gdt[GD_TSS_idx >> 3] = SEG16(STS_T32A, (uint32_t)(&(thiscpu->cpu_ts)), sizeof(struct Taskstate)-1, 0);
f0104658:	89 fb                	mov    %edi,%ebx
f010465a:	c1 fb 03             	sar    $0x3,%ebx
f010465d:	e8 38 27 00 00       	call   f0106d9a <cpunum>
f0104662:	89 c6                	mov    %eax,%esi
f0104664:	e8 31 27 00 00       	call   f0106d9a <cpunum>
f0104669:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010466c:	e8 29 27 00 00       	call   f0106d9a <cpunum>
f0104671:	66 c7 04 dd 40 53 12 	movw   $0x67,-0xfedacc0(,%ebx,8)
f0104678:	f0 67 00 
f010467b:	6b f6 74             	imul   $0x74,%esi,%esi
f010467e:	81 c6 2c 60 34 f0    	add    $0xf034602c,%esi
f0104684:	66 89 34 dd 42 53 12 	mov    %si,-0xfedacbe(,%ebx,8)
f010468b:	f0 
f010468c:	6b 55 e4 74          	imul   $0x74,-0x1c(%ebp),%edx
f0104690:	81 c2 2c 60 34 f0    	add    $0xf034602c,%edx
f0104696:	c1 ea 10             	shr    $0x10,%edx
f0104699:	88 14 dd 44 53 12 f0 	mov    %dl,-0xfedacbc(,%ebx,8)
f01046a0:	c6 04 dd 46 53 12 f0 	movb   $0x40,-0xfedacba(,%ebx,8)
f01046a7:	40 
f01046a8:	6b c0 74             	imul   $0x74,%eax,%eax
f01046ab:	05 2c 60 34 f0       	add    $0xf034602c,%eax
f01046b0:	c1 e8 18             	shr    $0x18,%eax
f01046b3:	88 04 dd 47 53 12 f0 	mov    %al,-0xfedacb9(,%ebx,8)
	gdt[GD_TSS_idx >> 3].sd_s = 0;
f01046ba:	c6 04 dd 45 53 12 f0 	movb   $0x89,-0xfedacbb(,%ebx,8)
f01046c1:	89 
	asm volatile("ltr %0" : : "r" (sel));
f01046c2:	0f 00 df             	ltr    %di
	asm volatile("lidt (%0)" : : "r" (p));
f01046c5:	b8 ac 53 12 f0       	mov    $0xf01253ac,%eax
f01046ca:	0f 01 18             	lidtl  (%eax)

	ltr(GD_TSS_idx);

	// Load the IDT
	lidt(&idt_pd);
}
f01046cd:	83 c4 1c             	add    $0x1c,%esp
f01046d0:	5b                   	pop    %ebx
f01046d1:	5e                   	pop    %esi
f01046d2:	5f                   	pop    %edi
f01046d3:	5d                   	pop    %ebp
f01046d4:	c3                   	ret    

f01046d5 <trap_init>:
{
f01046d5:	55                   	push   %ebp
f01046d6:	89 e5                	mov    %esp,%ebp
f01046d8:	83 ec 08             	sub    $0x8,%esp
	SETGATE(idt[T_DIVIDE], 0, GD_KT, divide_handler, 0);
f01046db:	b8 90 50 10 f0       	mov    $0xf0105090,%eax
f01046e0:	66 a3 60 42 34 f0    	mov    %ax,0xf0344260
f01046e6:	66 c7 05 62 42 34 f0 	movw   $0x8,0xf0344262
f01046ed:	08 00 
f01046ef:	c6 05 64 42 34 f0 00 	movb   $0x0,0xf0344264
f01046f6:	c6 05 65 42 34 f0 8e 	movb   $0x8e,0xf0344265
f01046fd:	c1 e8 10             	shr    $0x10,%eax
f0104700:	66 a3 66 42 34 f0    	mov    %ax,0xf0344266
	SETGATE(idt[T_DEBUG], 0, GD_KT, debug_handler, 0);
f0104706:	66 c7 05 6a 42 34 f0 	movw   $0x8,0xf034426a
f010470d:	08 00 
f010470f:	c6 05 6c 42 34 f0 00 	movb   $0x0,0xf034426c
f0104716:	c6 05 6d 42 34 f0 8e 	movb   $0x8e,0xf034426d
	SETGATE(idt[T_DEBUG], 0, GD_KT, nmi_handler, 0);
f010471d:	b8 a4 50 10 f0       	mov    $0xf01050a4,%eax
f0104722:	66 a3 68 42 34 f0    	mov    %ax,0xf0344268
f0104728:	c1 e8 10             	shr    $0x10,%eax
f010472b:	66 a3 6e 42 34 f0    	mov    %ax,0xf034426e
	SETGATE(idt[T_BRKPT], 0, GD_KT, brkpt_handler, 3);
f0104731:	b8 ae 50 10 f0       	mov    $0xf01050ae,%eax
f0104736:	66 a3 78 42 34 f0    	mov    %ax,0xf0344278
f010473c:	66 c7 05 7a 42 34 f0 	movw   $0x8,0xf034427a
f0104743:	08 00 
f0104745:	c6 05 7c 42 34 f0 00 	movb   $0x0,0xf034427c
f010474c:	c6 05 7d 42 34 f0 ee 	movb   $0xee,0xf034427d
f0104753:	c1 e8 10             	shr    $0x10,%eax
f0104756:	66 a3 7e 42 34 f0    	mov    %ax,0xf034427e
	SETGATE(idt[T_OFLOW], 0, GD_KT, oflow_handler, 0);
f010475c:	b8 b8 50 10 f0       	mov    $0xf01050b8,%eax
f0104761:	66 a3 80 42 34 f0    	mov    %ax,0xf0344280
f0104767:	66 c7 05 82 42 34 f0 	movw   $0x8,0xf0344282
f010476e:	08 00 
f0104770:	c6 05 84 42 34 f0 00 	movb   $0x0,0xf0344284
f0104777:	c6 05 85 42 34 f0 8e 	movb   $0x8e,0xf0344285
f010477e:	c1 e8 10             	shr    $0x10,%eax
f0104781:	66 a3 86 42 34 f0    	mov    %ax,0xf0344286
	SETGATE(idt[T_BOUND], 0, GD_KT, bound_handler, 0);
f0104787:	b8 c2 50 10 f0       	mov    $0xf01050c2,%eax
f010478c:	66 a3 88 42 34 f0    	mov    %ax,0xf0344288
f0104792:	66 c7 05 8a 42 34 f0 	movw   $0x8,0xf034428a
f0104799:	08 00 
f010479b:	c6 05 8c 42 34 f0 00 	movb   $0x0,0xf034428c
f01047a2:	c6 05 8d 42 34 f0 8e 	movb   $0x8e,0xf034428d
f01047a9:	c1 e8 10             	shr    $0x10,%eax
f01047ac:	66 a3 8e 42 34 f0    	mov    %ax,0xf034428e
	SETGATE(idt[T_ILLOP], 0, GD_KT, illop_handler, 0);
f01047b2:	b8 cc 50 10 f0       	mov    $0xf01050cc,%eax
f01047b7:	66 a3 90 42 34 f0    	mov    %ax,0xf0344290
f01047bd:	66 c7 05 92 42 34 f0 	movw   $0x8,0xf0344292
f01047c4:	08 00 
f01047c6:	c6 05 94 42 34 f0 00 	movb   $0x0,0xf0344294
f01047cd:	c6 05 95 42 34 f0 8e 	movb   $0x8e,0xf0344295
f01047d4:	c1 e8 10             	shr    $0x10,%eax
f01047d7:	66 a3 96 42 34 f0    	mov    %ax,0xf0344296
	SETGATE(idt[T_DEVICE], 0, GD_KT, device_handler, 0);
f01047dd:	b8 d6 50 10 f0       	mov    $0xf01050d6,%eax
f01047e2:	66 a3 98 42 34 f0    	mov    %ax,0xf0344298
f01047e8:	66 c7 05 9a 42 34 f0 	movw   $0x8,0xf034429a
f01047ef:	08 00 
f01047f1:	c6 05 9c 42 34 f0 00 	movb   $0x0,0xf034429c
f01047f8:	c6 05 9d 42 34 f0 8e 	movb   $0x8e,0xf034429d
f01047ff:	c1 e8 10             	shr    $0x10,%eax
f0104802:	66 a3 9e 42 34 f0    	mov    %ax,0xf034429e
	SETGATE(idt[T_DBLFLT], 0, GD_KT, dblflt_handler, 0);
f0104808:	b8 e0 50 10 f0       	mov    $0xf01050e0,%eax
f010480d:	66 a3 a0 42 34 f0    	mov    %ax,0xf03442a0
f0104813:	66 c7 05 a2 42 34 f0 	movw   $0x8,0xf03442a2
f010481a:	08 00 
f010481c:	c6 05 a4 42 34 f0 00 	movb   $0x0,0xf03442a4
f0104823:	c6 05 a5 42 34 f0 8e 	movb   $0x8e,0xf03442a5
f010482a:	c1 e8 10             	shr    $0x10,%eax
f010482d:	66 a3 a6 42 34 f0    	mov    %ax,0xf03442a6
	SETGATE(idt[T_TSS], 0, GD_KT, tss_handler, 0);
f0104833:	b8 e8 50 10 f0       	mov    $0xf01050e8,%eax
f0104838:	66 a3 b0 42 34 f0    	mov    %ax,0xf03442b0
f010483e:	66 c7 05 b2 42 34 f0 	movw   $0x8,0xf03442b2
f0104845:	08 00 
f0104847:	c6 05 b4 42 34 f0 00 	movb   $0x0,0xf03442b4
f010484e:	c6 05 b5 42 34 f0 8e 	movb   $0x8e,0xf03442b5
f0104855:	c1 e8 10             	shr    $0x10,%eax
f0104858:	66 a3 b6 42 34 f0    	mov    %ax,0xf03442b6
	SETGATE(idt[T_SEGNP], 0, GD_KT, segnp_handler, 0);
f010485e:	b8 f0 50 10 f0       	mov    $0xf01050f0,%eax
f0104863:	66 a3 b8 42 34 f0    	mov    %ax,0xf03442b8
f0104869:	66 c7 05 ba 42 34 f0 	movw   $0x8,0xf03442ba
f0104870:	08 00 
f0104872:	c6 05 bc 42 34 f0 00 	movb   $0x0,0xf03442bc
f0104879:	c6 05 bd 42 34 f0 8e 	movb   $0x8e,0xf03442bd
f0104880:	c1 e8 10             	shr    $0x10,%eax
f0104883:	66 a3 be 42 34 f0    	mov    %ax,0xf03442be
	SETGATE(idt[T_STACK], 0, GD_KT, stack_handler, 0);
f0104889:	b8 f8 50 10 f0       	mov    $0xf01050f8,%eax
f010488e:	66 a3 c0 42 34 f0    	mov    %ax,0xf03442c0
f0104894:	66 c7 05 c2 42 34 f0 	movw   $0x8,0xf03442c2
f010489b:	08 00 
f010489d:	c6 05 c4 42 34 f0 00 	movb   $0x0,0xf03442c4
f01048a4:	c6 05 c5 42 34 f0 8e 	movb   $0x8e,0xf03442c5
f01048ab:	c1 e8 10             	shr    $0x10,%eax
f01048ae:	66 a3 c6 42 34 f0    	mov    %ax,0xf03442c6
	SETGATE(idt[T_GPFLT], 0, GD_KT, gpflt_handler, 0);
f01048b4:	b8 00 51 10 f0       	mov    $0xf0105100,%eax
f01048b9:	66 a3 c8 42 34 f0    	mov    %ax,0xf03442c8
f01048bf:	66 c7 05 ca 42 34 f0 	movw   $0x8,0xf03442ca
f01048c6:	08 00 
f01048c8:	c6 05 cc 42 34 f0 00 	movb   $0x0,0xf03442cc
f01048cf:	c6 05 cd 42 34 f0 8e 	movb   $0x8e,0xf03442cd
f01048d6:	c1 e8 10             	shr    $0x10,%eax
f01048d9:	66 a3 ce 42 34 f0    	mov    %ax,0xf03442ce
	SETGATE(idt[T_PGFLT], 0, GD_KT, pgflt_handler, 0);
f01048df:	b8 08 51 10 f0       	mov    $0xf0105108,%eax
f01048e4:	66 a3 d0 42 34 f0    	mov    %ax,0xf03442d0
f01048ea:	66 c7 05 d2 42 34 f0 	movw   $0x8,0xf03442d2
f01048f1:	08 00 
f01048f3:	c6 05 d4 42 34 f0 00 	movb   $0x0,0xf03442d4
f01048fa:	c6 05 d5 42 34 f0 8e 	movb   $0x8e,0xf03442d5
f0104901:	c1 e8 10             	shr    $0x10,%eax
f0104904:	66 a3 d6 42 34 f0    	mov    %ax,0xf03442d6
	SETGATE(idt[T_FPERR], 0, GD_KT, fperr_handler, 0);
f010490a:	b8 10 51 10 f0       	mov    $0xf0105110,%eax
f010490f:	66 a3 e0 42 34 f0    	mov    %ax,0xf03442e0
f0104915:	66 c7 05 e2 42 34 f0 	movw   $0x8,0xf03442e2
f010491c:	08 00 
f010491e:	c6 05 e4 42 34 f0 00 	movb   $0x0,0xf03442e4
f0104925:	c6 05 e5 42 34 f0 8e 	movb   $0x8e,0xf03442e5
f010492c:	c1 e8 10             	shr    $0x10,%eax
f010492f:	66 a3 e6 42 34 f0    	mov    %ax,0xf03442e6
	SETGATE(idt[T_ALIGN], 0, GD_KT, align_handler, 0);
f0104935:	b8 1a 51 10 f0       	mov    $0xf010511a,%eax
f010493a:	66 a3 e8 42 34 f0    	mov    %ax,0xf03442e8
f0104940:	66 c7 05 ea 42 34 f0 	movw   $0x8,0xf03442ea
f0104947:	08 00 
f0104949:	c6 05 ec 42 34 f0 00 	movb   $0x0,0xf03442ec
f0104950:	c6 05 ed 42 34 f0 8e 	movb   $0x8e,0xf03442ed
f0104957:	c1 e8 10             	shr    $0x10,%eax
f010495a:	66 a3 ee 42 34 f0    	mov    %ax,0xf03442ee
	SETGATE(idt[T_MCHK], 0, GD_KT, mchk_handler, 0);
f0104960:	b8 24 51 10 f0       	mov    $0xf0105124,%eax
f0104965:	66 a3 f0 42 34 f0    	mov    %ax,0xf03442f0
f010496b:	66 c7 05 f2 42 34 f0 	movw   $0x8,0xf03442f2
f0104972:	08 00 
f0104974:	c6 05 f4 42 34 f0 00 	movb   $0x0,0xf03442f4
f010497b:	c6 05 f5 42 34 f0 8e 	movb   $0x8e,0xf03442f5
f0104982:	c1 e8 10             	shr    $0x10,%eax
f0104985:	66 a3 f6 42 34 f0    	mov    %ax,0xf03442f6
	SETGATE(idt[T_SIMDERR], 0, GD_KT, simderr_handler, 0);
f010498b:	b8 2e 51 10 f0       	mov    $0xf010512e,%eax
f0104990:	66 a3 f8 42 34 f0    	mov    %ax,0xf03442f8
f0104996:	66 c7 05 fa 42 34 f0 	movw   $0x8,0xf03442fa
f010499d:	08 00 
f010499f:	c6 05 fc 42 34 f0 00 	movb   $0x0,0xf03442fc
f01049a6:	c6 05 fd 42 34 f0 8e 	movb   $0x8e,0xf03442fd
f01049ad:	c1 e8 10             	shr    $0x10,%eax
f01049b0:	66 a3 fe 42 34 f0    	mov    %ax,0xf03442fe
	SETGATE(idt[T_SYSCALL], 0, GD_KT, syscall_handler, 3);
f01049b6:	b8 38 51 10 f0       	mov    $0xf0105138,%eax
f01049bb:	66 a3 e0 43 34 f0    	mov    %ax,0xf03443e0
f01049c1:	66 c7 05 e2 43 34 f0 	movw   $0x8,0xf03443e2
f01049c8:	08 00 
f01049ca:	c6 05 e4 43 34 f0 00 	movb   $0x0,0xf03443e4
f01049d1:	c6 05 e5 43 34 f0 ee 	movb   $0xee,0xf03443e5
f01049d8:	c1 e8 10             	shr    $0x10,%eax
f01049db:	66 a3 e6 43 34 f0    	mov    %ax,0xf03443e6
	SETGATE(idt[IRQ_OFFSET+IRQ_TIMER], 0, GD_KT, irq_timer_handler, 0);
f01049e1:	b8 42 51 10 f0       	mov    $0xf0105142,%eax
f01049e6:	66 a3 60 43 34 f0    	mov    %ax,0xf0344360
f01049ec:	66 c7 05 62 43 34 f0 	movw   $0x8,0xf0344362
f01049f3:	08 00 
f01049f5:	c6 05 64 43 34 f0 00 	movb   $0x0,0xf0344364
f01049fc:	c6 05 65 43 34 f0 8e 	movb   $0x8e,0xf0344365
f0104a03:	c1 e8 10             	shr    $0x10,%eax
f0104a06:	66 a3 66 43 34 f0    	mov    %ax,0xf0344366
	SETGATE(idt[IRQ_OFFSET+IRQ_KBD], 0, GD_KT, irq_kbd_handler, 0);
f0104a0c:	b8 48 51 10 f0       	mov    $0xf0105148,%eax
f0104a11:	66 a3 68 43 34 f0    	mov    %ax,0xf0344368
f0104a17:	66 c7 05 6a 43 34 f0 	movw   $0x8,0xf034436a
f0104a1e:	08 00 
f0104a20:	c6 05 6c 43 34 f0 00 	movb   $0x0,0xf034436c
f0104a27:	c6 05 6d 43 34 f0 8e 	movb   $0x8e,0xf034436d
f0104a2e:	c1 e8 10             	shr    $0x10,%eax
f0104a31:	66 a3 6e 43 34 f0    	mov    %ax,0xf034436e
	SETGATE(idt[IRQ_OFFSET+2], 0, GD_KT, irq_2_handler, 0);
f0104a37:	b8 4e 51 10 f0       	mov    $0xf010514e,%eax
f0104a3c:	66 a3 70 43 34 f0    	mov    %ax,0xf0344370
f0104a42:	66 c7 05 72 43 34 f0 	movw   $0x8,0xf0344372
f0104a49:	08 00 
f0104a4b:	c6 05 74 43 34 f0 00 	movb   $0x0,0xf0344374
f0104a52:	c6 05 75 43 34 f0 8e 	movb   $0x8e,0xf0344375
f0104a59:	c1 e8 10             	shr    $0x10,%eax
f0104a5c:	66 a3 76 43 34 f0    	mov    %ax,0xf0344376
	SETGATE(idt[IRQ_OFFSET+3], 0, GD_KT, irq_3_handler, 0);
f0104a62:	b8 54 51 10 f0       	mov    $0xf0105154,%eax
f0104a67:	66 a3 78 43 34 f0    	mov    %ax,0xf0344378
f0104a6d:	66 c7 05 7a 43 34 f0 	movw   $0x8,0xf034437a
f0104a74:	08 00 
f0104a76:	c6 05 7c 43 34 f0 00 	movb   $0x0,0xf034437c
f0104a7d:	c6 05 7d 43 34 f0 8e 	movb   $0x8e,0xf034437d
f0104a84:	c1 e8 10             	shr    $0x10,%eax
f0104a87:	66 a3 7e 43 34 f0    	mov    %ax,0xf034437e
	SETGATE(idt[IRQ_OFFSET+IRQ_SERIAL], 0, GD_KT, irq_serial_handler, 0);
f0104a8d:	b8 5a 51 10 f0       	mov    $0xf010515a,%eax
f0104a92:	66 a3 80 43 34 f0    	mov    %ax,0xf0344380
f0104a98:	66 c7 05 82 43 34 f0 	movw   $0x8,0xf0344382
f0104a9f:	08 00 
f0104aa1:	c6 05 84 43 34 f0 00 	movb   $0x0,0xf0344384
f0104aa8:	c6 05 85 43 34 f0 8e 	movb   $0x8e,0xf0344385
f0104aaf:	c1 e8 10             	shr    $0x10,%eax
f0104ab2:	66 a3 86 43 34 f0    	mov    %ax,0xf0344386
	SETGATE(idt[IRQ_OFFSET+5], 0, GD_KT, irq_5_handler, 0);
f0104ab8:	66 c7 05 8a 43 34 f0 	movw   $0x8,0xf034438a
f0104abf:	08 00 
f0104ac1:	c6 05 8c 43 34 f0 00 	movb   $0x0,0xf034438c
f0104ac8:	c6 05 8d 43 34 f0 8e 	movb   $0x8e,0xf034438d
	SETGATE(idt[IRQ_OFFSET+5], 0, GD_KT, irq_error_handler, 0);
f0104acf:	b8 aa 51 10 f0       	mov    $0xf01051aa,%eax
f0104ad4:	66 a3 88 43 34 f0    	mov    %ax,0xf0344388
f0104ada:	c1 e8 10             	shr    $0x10,%eax
f0104add:	66 a3 8e 43 34 f0    	mov    %ax,0xf034438e
	trap_init_percpu();
f0104ae3:	e8 15 fb ff ff       	call   f01045fd <trap_init_percpu>
}
f0104ae8:	c9                   	leave  
f0104ae9:	c3                   	ret    

f0104aea <print_regs>:
	}
}

void
print_regs(struct PushRegs *regs)
{
f0104aea:	55                   	push   %ebp
f0104aeb:	89 e5                	mov    %esp,%ebp
f0104aed:	53                   	push   %ebx
f0104aee:	83 ec 0c             	sub    $0xc,%esp
f0104af1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f0104af4:	ff 33                	pushl  (%ebx)
f0104af6:	68 b1 8c 10 f0       	push   $0xf0108cb1
f0104afb:	e8 e9 fa ff ff       	call   f01045e9 <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f0104b00:	83 c4 08             	add    $0x8,%esp
f0104b03:	ff 73 04             	pushl  0x4(%ebx)
f0104b06:	68 c0 8c 10 f0       	push   $0xf0108cc0
f0104b0b:	e8 d9 fa ff ff       	call   f01045e9 <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f0104b10:	83 c4 08             	add    $0x8,%esp
f0104b13:	ff 73 08             	pushl  0x8(%ebx)
f0104b16:	68 cf 8c 10 f0       	push   $0xf0108ccf
f0104b1b:	e8 c9 fa ff ff       	call   f01045e9 <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f0104b20:	83 c4 08             	add    $0x8,%esp
f0104b23:	ff 73 0c             	pushl  0xc(%ebx)
f0104b26:	68 de 8c 10 f0       	push   $0xf0108cde
f0104b2b:	e8 b9 fa ff ff       	call   f01045e9 <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f0104b30:	83 c4 08             	add    $0x8,%esp
f0104b33:	ff 73 10             	pushl  0x10(%ebx)
f0104b36:	68 ed 8c 10 f0       	push   $0xf0108ced
f0104b3b:	e8 a9 fa ff ff       	call   f01045e9 <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f0104b40:	83 c4 08             	add    $0x8,%esp
f0104b43:	ff 73 14             	pushl  0x14(%ebx)
f0104b46:	68 fc 8c 10 f0       	push   $0xf0108cfc
f0104b4b:	e8 99 fa ff ff       	call   f01045e9 <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f0104b50:	83 c4 08             	add    $0x8,%esp
f0104b53:	ff 73 18             	pushl  0x18(%ebx)
f0104b56:	68 0b 8d 10 f0       	push   $0xf0108d0b
f0104b5b:	e8 89 fa ff ff       	call   f01045e9 <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f0104b60:	83 c4 08             	add    $0x8,%esp
f0104b63:	ff 73 1c             	pushl  0x1c(%ebx)
f0104b66:	68 1a 8d 10 f0       	push   $0xf0108d1a
f0104b6b:	e8 79 fa ff ff       	call   f01045e9 <cprintf>
}
f0104b70:	83 c4 10             	add    $0x10,%esp
f0104b73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104b76:	c9                   	leave  
f0104b77:	c3                   	ret    

f0104b78 <print_trapframe>:
{
f0104b78:	55                   	push   %ebp
f0104b79:	89 e5                	mov    %esp,%ebp
f0104b7b:	56                   	push   %esi
f0104b7c:	53                   	push   %ebx
f0104b7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
f0104b80:	e8 15 22 00 00       	call   f0106d9a <cpunum>
f0104b85:	83 ec 04             	sub    $0x4,%esp
f0104b88:	50                   	push   %eax
f0104b89:	53                   	push   %ebx
f0104b8a:	68 7e 8d 10 f0       	push   $0xf0108d7e
f0104b8f:	e8 55 fa ff ff       	call   f01045e9 <cprintf>
	print_regs(&tf->tf_regs);
f0104b94:	89 1c 24             	mov    %ebx,(%esp)
f0104b97:	e8 4e ff ff ff       	call   f0104aea <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f0104b9c:	83 c4 08             	add    $0x8,%esp
f0104b9f:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f0104ba3:	50                   	push   %eax
f0104ba4:	68 9c 8d 10 f0       	push   $0xf0108d9c
f0104ba9:	e8 3b fa ff ff       	call   f01045e9 <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f0104bae:	83 c4 08             	add    $0x8,%esp
f0104bb1:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f0104bb5:	50                   	push   %eax
f0104bb6:	68 af 8d 10 f0       	push   $0xf0108daf
f0104bbb:	e8 29 fa ff ff       	call   f01045e9 <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0104bc0:	8b 43 28             	mov    0x28(%ebx),%eax
	if (trapno < ARRAY_SIZE(excnames))
f0104bc3:	83 c4 10             	add    $0x10,%esp
f0104bc6:	83 f8 13             	cmp    $0x13,%eax
f0104bc9:	0f 86 e1 00 00 00    	jbe    f0104cb0 <print_trapframe+0x138>
		return "System call";
f0104bcf:	ba 29 8d 10 f0       	mov    $0xf0108d29,%edx
	if (trapno == T_SYSCALL)
f0104bd4:	83 f8 30             	cmp    $0x30,%eax
f0104bd7:	74 13                	je     f0104bec <print_trapframe+0x74>
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f0104bd9:	8d 50 e0             	lea    -0x20(%eax),%edx
		return "Hardware Interrupt";
f0104bdc:	83 fa 0f             	cmp    $0xf,%edx
f0104bdf:	ba 35 8d 10 f0       	mov    $0xf0108d35,%edx
f0104be4:	b9 44 8d 10 f0       	mov    $0xf0108d44,%ecx
f0104be9:	0f 46 d1             	cmovbe %ecx,%edx
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0104bec:	83 ec 04             	sub    $0x4,%esp
f0104bef:	52                   	push   %edx
f0104bf0:	50                   	push   %eax
f0104bf1:	68 c2 8d 10 f0       	push   $0xf0108dc2
f0104bf6:	e8 ee f9 ff ff       	call   f01045e9 <cprintf>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0104bfb:	83 c4 10             	add    $0x10,%esp
f0104bfe:	39 1d 60 4a 34 f0    	cmp    %ebx,0xf0344a60
f0104c04:	0f 84 b2 00 00 00    	je     f0104cbc <print_trapframe+0x144>
	cprintf("  err  0x%08x", tf->tf_err);
f0104c0a:	83 ec 08             	sub    $0x8,%esp
f0104c0d:	ff 73 2c             	pushl  0x2c(%ebx)
f0104c10:	68 e3 8d 10 f0       	push   $0xf0108de3
f0104c15:	e8 cf f9 ff ff       	call   f01045e9 <cprintf>
	if (tf->tf_trapno == T_PGFLT)
f0104c1a:	83 c4 10             	add    $0x10,%esp
f0104c1d:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0104c21:	0f 85 b8 00 00 00    	jne    f0104cdf <print_trapframe+0x167>
			tf->tf_err & 1 ? "protection" : "not-present");
f0104c27:	8b 43 2c             	mov    0x2c(%ebx),%eax
		cprintf(" [%s, %s, %s]\n",
f0104c2a:	89 c2                	mov    %eax,%edx
f0104c2c:	83 e2 01             	and    $0x1,%edx
f0104c2f:	b9 57 8d 10 f0       	mov    $0xf0108d57,%ecx
f0104c34:	ba 62 8d 10 f0       	mov    $0xf0108d62,%edx
f0104c39:	0f 44 ca             	cmove  %edx,%ecx
f0104c3c:	89 c2                	mov    %eax,%edx
f0104c3e:	83 e2 02             	and    $0x2,%edx
f0104c41:	be 6e 8d 10 f0       	mov    $0xf0108d6e,%esi
f0104c46:	ba 74 8d 10 f0       	mov    $0xf0108d74,%edx
f0104c4b:	0f 45 d6             	cmovne %esi,%edx
f0104c4e:	83 e0 04             	and    $0x4,%eax
f0104c51:	b8 79 8d 10 f0       	mov    $0xf0108d79,%eax
f0104c56:	be ae 8e 10 f0       	mov    $0xf0108eae,%esi
f0104c5b:	0f 44 c6             	cmove  %esi,%eax
f0104c5e:	51                   	push   %ecx
f0104c5f:	52                   	push   %edx
f0104c60:	50                   	push   %eax
f0104c61:	68 f1 8d 10 f0       	push   $0xf0108df1
f0104c66:	e8 7e f9 ff ff       	call   f01045e9 <cprintf>
f0104c6b:	83 c4 10             	add    $0x10,%esp
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f0104c6e:	83 ec 08             	sub    $0x8,%esp
f0104c71:	ff 73 30             	pushl  0x30(%ebx)
f0104c74:	68 00 8e 10 f0       	push   $0xf0108e00
f0104c79:	e8 6b f9 ff ff       	call   f01045e9 <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f0104c7e:	83 c4 08             	add    $0x8,%esp
f0104c81:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f0104c85:	50                   	push   %eax
f0104c86:	68 0f 8e 10 f0       	push   $0xf0108e0f
f0104c8b:	e8 59 f9 ff ff       	call   f01045e9 <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f0104c90:	83 c4 08             	add    $0x8,%esp
f0104c93:	ff 73 38             	pushl  0x38(%ebx)
f0104c96:	68 22 8e 10 f0       	push   $0xf0108e22
f0104c9b:	e8 49 f9 ff ff       	call   f01045e9 <cprintf>
	if ((tf->tf_cs & 3) != 0) {
f0104ca0:	83 c4 10             	add    $0x10,%esp
f0104ca3:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f0104ca7:	75 4b                	jne    f0104cf4 <print_trapframe+0x17c>
}
f0104ca9:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0104cac:	5b                   	pop    %ebx
f0104cad:	5e                   	pop    %esi
f0104cae:	5d                   	pop    %ebp
f0104caf:	c3                   	ret    
		return excnames[trapno];
f0104cb0:	8b 14 85 60 90 10 f0 	mov    -0xfef6fa0(,%eax,4),%edx
f0104cb7:	e9 30 ff ff ff       	jmp    f0104bec <print_trapframe+0x74>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0104cbc:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0104cc0:	0f 85 44 ff ff ff    	jne    f0104c0a <print_trapframe+0x92>
	asm volatile("movl %%cr2,%0" : "=r" (val));
f0104cc6:	0f 20 d0             	mov    %cr2,%eax
		cprintf("  cr2  0x%08x\n", rcr2());
f0104cc9:	83 ec 08             	sub    $0x8,%esp
f0104ccc:	50                   	push   %eax
f0104ccd:	68 d4 8d 10 f0       	push   $0xf0108dd4
f0104cd2:	e8 12 f9 ff ff       	call   f01045e9 <cprintf>
f0104cd7:	83 c4 10             	add    $0x10,%esp
f0104cda:	e9 2b ff ff ff       	jmp    f0104c0a <print_trapframe+0x92>
		cprintf("\n");
f0104cdf:	83 ec 0c             	sub    $0xc,%esp
f0104ce2:	68 33 8b 10 f0       	push   $0xf0108b33
f0104ce7:	e8 fd f8 ff ff       	call   f01045e9 <cprintf>
f0104cec:	83 c4 10             	add    $0x10,%esp
f0104cef:	e9 7a ff ff ff       	jmp    f0104c6e <print_trapframe+0xf6>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
f0104cf4:	83 ec 08             	sub    $0x8,%esp
f0104cf7:	ff 73 3c             	pushl  0x3c(%ebx)
f0104cfa:	68 31 8e 10 f0       	push   $0xf0108e31
f0104cff:	e8 e5 f8 ff ff       	call   f01045e9 <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
f0104d04:	83 c4 08             	add    $0x8,%esp
f0104d07:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f0104d0b:	50                   	push   %eax
f0104d0c:	68 40 8e 10 f0       	push   $0xf0108e40
f0104d11:	e8 d3 f8 ff ff       	call   f01045e9 <cprintf>
f0104d16:	83 c4 10             	add    $0x10,%esp
}
f0104d19:	eb 8e                	jmp    f0104ca9 <print_trapframe+0x131>

f0104d1b <page_fault_handler>:
}


void
page_fault_handler(struct Trapframe *tf)
{
f0104d1b:	55                   	push   %ebp
f0104d1c:	89 e5                	mov    %esp,%ebp
f0104d1e:	57                   	push   %edi
f0104d1f:	56                   	push   %esi
f0104d20:	53                   	push   %ebx
f0104d21:	83 ec 0c             	sub    $0xc,%esp
f0104d24:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0104d27:	0f 20 d0             	mov    %cr2,%eax
f0104d2a:	0f 20 d6             	mov    %cr2,%esi

	// Handle kernel-mode page faults.

	// LAB 3: Your code here.
	fault_va = rcr2();
	if((tf->tf_cs & 0x3) == 0)
f0104d2d:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f0104d31:	74 5d                	je     f0104d90 <page_fault_handler+0x75>
	//   user_mem_assert() and env_run() are useful here.
	//   To change what the user environment runs, modify 'curenv->env_tf'
	//   (the 'tf' variable points at 'curenv->env_tf').

	// LAB 4: Your code here.
	if (curenv->env_pgfault_upcall) {
f0104d33:	e8 62 20 00 00       	call   f0106d9a <cpunum>
f0104d38:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d3b:	8b 80 28 60 34 f0    	mov    -0xfcb9fd8(%eax),%eax
f0104d41:	83 78 64 00          	cmpl   $0x0,0x64(%eax)
f0104d45:	75 60                	jne    f0104da7 <page_fault_handler+0x8c>
		curenv->env_tf.tf_esp = (uintptr_t)utf;
		env_run(curenv);
	}

	// Destroy the environment that caused the fault.
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104d47:	8b 7b 30             	mov    0x30(%ebx),%edi
		curenv->env_id, fault_va, tf->tf_eip);
f0104d4a:	e8 4b 20 00 00       	call   f0106d9a <cpunum>
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104d4f:	57                   	push   %edi
f0104d50:	56                   	push   %esi
		curenv->env_id, fault_va, tf->tf_eip);
f0104d51:	6b c0 74             	imul   $0x74,%eax,%eax
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104d54:	8b 80 28 60 34 f0    	mov    -0xfcb9fd8(%eax),%eax
f0104d5a:	ff 70 48             	pushl  0x48(%eax)
f0104d5d:	68 24 90 10 f0       	push   $0xf0109024
f0104d62:	e8 82 f8 ff ff       	call   f01045e9 <cprintf>
	print_trapframe(tf);
f0104d67:	89 1c 24             	mov    %ebx,(%esp)
f0104d6a:	e8 09 fe ff ff       	call   f0104b78 <print_trapframe>
	env_destroy(curenv);
f0104d6f:	e8 26 20 00 00       	call   f0106d9a <cpunum>
f0104d74:	83 c4 04             	add    $0x4,%esp
f0104d77:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d7a:	ff b0 28 60 34 f0    	pushl  -0xfcb9fd8(%eax)
f0104d80:	e8 25 f5 ff ff       	call   f01042aa <env_destroy>
}
f0104d85:	83 c4 10             	add    $0x10,%esp
f0104d88:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104d8b:	5b                   	pop    %ebx
f0104d8c:	5e                   	pop    %esi
f0104d8d:	5f                   	pop    %edi
f0104d8e:	5d                   	pop    %ebp
f0104d8f:	c3                   	ret    
		panic("page_fault_handler: kernel model page fault");
f0104d90:	83 ec 04             	sub    $0x4,%esp
f0104d93:	68 f8 8f 10 f0       	push   $0xf0108ff8
f0104d98:	68 ac 01 00 00       	push   $0x1ac
f0104d9d:	68 53 8e 10 f0       	push   $0xf0108e53
f0104da2:	e8 a2 b2 ff ff       	call   f0100049 <_panic>
		if ((uint32_t)(UXSTACKTOP - tf->tf_esp) < PGSIZE)
f0104da7:	8b 53 3c             	mov    0x3c(%ebx),%edx
f0104daa:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
f0104daf:	29 d0                	sub    %edx,%eax
			utf = (struct UTrapframe *)(UXSTACKTOP - sizeof(struct UTrapframe));
f0104db1:	bf cc ff bf ee       	mov    $0xeebfffcc,%edi
		if ((uint32_t)(UXSTACKTOP - tf->tf_esp) < PGSIZE)
f0104db6:	3d ff 0f 00 00       	cmp    $0xfff,%eax
f0104dbb:	77 05                	ja     f0104dc2 <page_fault_handler+0xa7>
			utf = (struct UTrapframe *)(tf->tf_esp - sizeof(void *) - sizeof(struct UTrapframe));
f0104dbd:	8d 42 c8             	lea    -0x38(%edx),%eax
f0104dc0:	89 c7                	mov    %eax,%edi
		user_mem_assert(curenv, (void *)utf, sizeof(struct UTrapframe), PTE_W);
f0104dc2:	e8 d3 1f 00 00       	call   f0106d9a <cpunum>
f0104dc7:	6a 02                	push   $0x2
f0104dc9:	6a 34                	push   $0x34
f0104dcb:	57                   	push   %edi
f0104dcc:	6b c0 74             	imul   $0x74,%eax,%eax
f0104dcf:	ff b0 28 60 34 f0    	pushl  -0xfcb9fd8(%eax)
f0104dd5:	e8 7f ed ff ff       	call   f0103b59 <user_mem_assert>
		utf->utf_fault_va = fault_va;
f0104dda:	89 fa                	mov    %edi,%edx
f0104ddc:	89 37                	mov    %esi,(%edi)
		utf->utf_err      = tf->tf_err;
f0104dde:	8b 43 2c             	mov    0x2c(%ebx),%eax
f0104de1:	89 47 04             	mov    %eax,0x4(%edi)
		utf->utf_regs     = tf->tf_regs;
f0104de4:	8d 7f 08             	lea    0x8(%edi),%edi
f0104de7:	b9 08 00 00 00       	mov    $0x8,%ecx
f0104dec:	89 de                	mov    %ebx,%esi
f0104dee:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		utf->utf_eip      = tf->tf_eip;
f0104df0:	8b 43 30             	mov    0x30(%ebx),%eax
f0104df3:	89 42 28             	mov    %eax,0x28(%edx)
		utf->utf_eflags   = tf->tf_eflags;
f0104df6:	8b 43 38             	mov    0x38(%ebx),%eax
f0104df9:	89 d7                	mov    %edx,%edi
f0104dfb:	89 42 2c             	mov    %eax,0x2c(%edx)
		utf->utf_esp      = tf->tf_esp;
f0104dfe:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0104e01:	89 42 30             	mov    %eax,0x30(%edx)
		curenv->env_tf.tf_eip = (uintptr_t)curenv->env_pgfault_upcall;
f0104e04:	e8 91 1f 00 00       	call   f0106d9a <cpunum>
f0104e09:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e0c:	8b 80 28 60 34 f0    	mov    -0xfcb9fd8(%eax),%eax
f0104e12:	8b 58 64             	mov    0x64(%eax),%ebx
f0104e15:	e8 80 1f 00 00       	call   f0106d9a <cpunum>
f0104e1a:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e1d:	8b 80 28 60 34 f0    	mov    -0xfcb9fd8(%eax),%eax
f0104e23:	89 58 30             	mov    %ebx,0x30(%eax)
		curenv->env_tf.tf_esp = (uintptr_t)utf;
f0104e26:	e8 6f 1f 00 00       	call   f0106d9a <cpunum>
f0104e2b:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e2e:	8b 80 28 60 34 f0    	mov    -0xfcb9fd8(%eax),%eax
f0104e34:	89 78 3c             	mov    %edi,0x3c(%eax)
		env_run(curenv);
f0104e37:	e8 5e 1f 00 00       	call   f0106d9a <cpunum>
f0104e3c:	83 c4 04             	add    $0x4,%esp
f0104e3f:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e42:	ff b0 28 60 34 f0    	pushl  -0xfcb9fd8(%eax)
f0104e48:	e8 fc f4 ff ff       	call   f0104349 <env_run>

f0104e4d <trap>:
{
f0104e4d:	55                   	push   %ebp
f0104e4e:	89 e5                	mov    %esp,%ebp
f0104e50:	57                   	push   %edi
f0104e51:	56                   	push   %esi
f0104e52:	8b 75 08             	mov    0x8(%ebp),%esi
	asm volatile("cld" ::: "cc");
f0104e55:	fc                   	cld    
	if (panicstr)
f0104e56:	83 3d 80 5e 34 f0 00 	cmpl   $0x0,0xf0345e80
f0104e5d:	74 01                	je     f0104e60 <trap+0x13>
		asm volatile("hlt");
f0104e5f:	f4                   	hlt    
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
f0104e60:	e8 35 1f 00 00       	call   f0106d9a <cpunum>
f0104e65:	6b d0 74             	imul   $0x74,%eax,%edx
f0104e68:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f0104e6b:	b8 01 00 00 00       	mov    $0x1,%eax
f0104e70:	f0 87 82 20 60 34 f0 	lock xchg %eax,-0xfcb9fe0(%edx)
f0104e77:	83 f8 02             	cmp    $0x2,%eax
f0104e7a:	0f 84 87 00 00 00    	je     f0104f07 <trap+0xba>
	asm volatile("pushfl; popl %0" : "=r" (eflags));
f0104e80:	9c                   	pushf  
f0104e81:	58                   	pop    %eax
	assert(!(read_eflags() & FL_IF));
f0104e82:	f6 c4 02             	test   $0x2,%ah
f0104e85:	0f 85 91 00 00 00    	jne    f0104f1c <trap+0xcf>
	if ((tf->tf_cs & 3) == 3) {
f0104e8b:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f0104e8f:	83 e0 03             	and    $0x3,%eax
f0104e92:	66 83 f8 03          	cmp    $0x3,%ax
f0104e96:	0f 84 99 00 00 00    	je     f0104f35 <trap+0xe8>
	last_tf = tf;
f0104e9c:	89 35 60 4a 34 f0    	mov    %esi,0xf0344a60
	switch (tf->tf_trapno)
f0104ea2:	8b 46 28             	mov    0x28(%esi),%eax
f0104ea5:	83 f8 0e             	cmp    $0xe,%eax
f0104ea8:	0f 84 2c 01 00 00    	je     f0104fda <trap+0x18d>
f0104eae:	83 f8 30             	cmp    $0x30,%eax
f0104eb1:	0f 84 67 01 00 00    	je     f010501e <trap+0x1d1>
f0104eb7:	83 f8 03             	cmp    $0x3,%eax
f0104eba:	0f 84 50 01 00 00    	je     f0105010 <trap+0x1c3>
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
f0104ec0:	83 f8 27             	cmp    $0x27,%eax
f0104ec3:	0f 84 76 01 00 00    	je     f010503f <trap+0x1f2>
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_TIMER) {
f0104ec9:	83 f8 20             	cmp    $0x20,%eax
f0104ecc:	0f 84 87 01 00 00    	je     f0105059 <trap+0x20c>
	print_trapframe(tf);
f0104ed2:	83 ec 0c             	sub    $0xc,%esp
f0104ed5:	56                   	push   %esi
f0104ed6:	e8 9d fc ff ff       	call   f0104b78 <print_trapframe>
	if (tf->tf_cs == GD_KT)
f0104edb:	83 c4 10             	add    $0x10,%esp
f0104ede:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f0104ee3:	0f 84 7a 01 00 00    	je     f0105063 <trap+0x216>
		env_destroy(curenv);
f0104ee9:	e8 ac 1e 00 00       	call   f0106d9a <cpunum>
f0104eee:	83 ec 0c             	sub    $0xc,%esp
f0104ef1:	6b c0 74             	imul   $0x74,%eax,%eax
f0104ef4:	ff b0 28 60 34 f0    	pushl  -0xfcb9fd8(%eax)
f0104efa:	e8 ab f3 ff ff       	call   f01042aa <env_destroy>
f0104eff:	83 c4 10             	add    $0x10,%esp
f0104f02:	e9 df 00 00 00       	jmp    f0104fe6 <trap+0x199>
	spin_lock(&kernel_lock);
f0104f07:	83 ec 0c             	sub    $0xc,%esp
f0104f0a:	68 c0 53 12 f0       	push   $0xf01253c0
f0104f0f:	e8 f6 20 00 00       	call   f010700a <spin_lock>
f0104f14:	83 c4 10             	add    $0x10,%esp
f0104f17:	e9 64 ff ff ff       	jmp    f0104e80 <trap+0x33>
	assert(!(read_eflags() & FL_IF));
f0104f1c:	68 5f 8e 10 f0       	push   $0xf0108e5f
f0104f21:	68 a2 87 10 f0       	push   $0xf01087a2
f0104f26:	68 75 01 00 00       	push   $0x175
f0104f2b:	68 53 8e 10 f0       	push   $0xf0108e53
f0104f30:	e8 14 b1 ff ff       	call   f0100049 <_panic>
f0104f35:	83 ec 0c             	sub    $0xc,%esp
f0104f38:	68 c0 53 12 f0       	push   $0xf01253c0
f0104f3d:	e8 c8 20 00 00       	call   f010700a <spin_lock>
		assert(curenv);
f0104f42:	e8 53 1e 00 00       	call   f0106d9a <cpunum>
f0104f47:	6b c0 74             	imul   $0x74,%eax,%eax
f0104f4a:	83 c4 10             	add    $0x10,%esp
f0104f4d:	83 b8 28 60 34 f0 00 	cmpl   $0x0,-0xfcb9fd8(%eax)
f0104f54:	74 3e                	je     f0104f94 <trap+0x147>
		if (curenv->env_status == ENV_DYING) {
f0104f56:	e8 3f 1e 00 00       	call   f0106d9a <cpunum>
f0104f5b:	6b c0 74             	imul   $0x74,%eax,%eax
f0104f5e:	8b 80 28 60 34 f0    	mov    -0xfcb9fd8(%eax),%eax
f0104f64:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f0104f68:	74 43                	je     f0104fad <trap+0x160>
		curenv->env_tf = *tf;
f0104f6a:	e8 2b 1e 00 00       	call   f0106d9a <cpunum>
f0104f6f:	6b c0 74             	imul   $0x74,%eax,%eax
f0104f72:	8b 80 28 60 34 f0    	mov    -0xfcb9fd8(%eax),%eax
f0104f78:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104f7d:	89 c7                	mov    %eax,%edi
f0104f7f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		tf = &curenv->env_tf;
f0104f81:	e8 14 1e 00 00       	call   f0106d9a <cpunum>
f0104f86:	6b c0 74             	imul   $0x74,%eax,%eax
f0104f89:	8b b0 28 60 34 f0    	mov    -0xfcb9fd8(%eax),%esi
f0104f8f:	e9 08 ff ff ff       	jmp    f0104e9c <trap+0x4f>
		assert(curenv);
f0104f94:	68 78 8e 10 f0       	push   $0xf0108e78
f0104f99:	68 a2 87 10 f0       	push   $0xf01087a2
f0104f9e:	68 7d 01 00 00       	push   $0x17d
f0104fa3:	68 53 8e 10 f0       	push   $0xf0108e53
f0104fa8:	e8 9c b0 ff ff       	call   f0100049 <_panic>
			env_free(curenv);
f0104fad:	e8 e8 1d 00 00       	call   f0106d9a <cpunum>
f0104fb2:	83 ec 0c             	sub    $0xc,%esp
f0104fb5:	6b c0 74             	imul   $0x74,%eax,%eax
f0104fb8:	ff b0 28 60 34 f0    	pushl  -0xfcb9fd8(%eax)
f0104fbe:	e8 06 f1 ff ff       	call   f01040c9 <env_free>
			curenv = NULL;
f0104fc3:	e8 d2 1d 00 00       	call   f0106d9a <cpunum>
f0104fc8:	6b c0 74             	imul   $0x74,%eax,%eax
f0104fcb:	c7 80 28 60 34 f0 00 	movl   $0x0,-0xfcb9fd8(%eax)
f0104fd2:	00 00 00 
			sched_yield();
f0104fd5:	e8 c7 02 00 00       	call   f01052a1 <sched_yield>
			page_fault_handler(tf);
f0104fda:	83 ec 0c             	sub    $0xc,%esp
f0104fdd:	56                   	push   %esi
f0104fde:	e8 38 fd ff ff       	call   f0104d1b <page_fault_handler>
f0104fe3:	83 c4 10             	add    $0x10,%esp
	if (curenv && curenv->env_status == ENV_RUNNING)
f0104fe6:	e8 af 1d 00 00       	call   f0106d9a <cpunum>
f0104feb:	6b c0 74             	imul   $0x74,%eax,%eax
f0104fee:	83 b8 28 60 34 f0 00 	cmpl   $0x0,-0xfcb9fd8(%eax)
f0104ff5:	74 14                	je     f010500b <trap+0x1be>
f0104ff7:	e8 9e 1d 00 00       	call   f0106d9a <cpunum>
f0104ffc:	6b c0 74             	imul   $0x74,%eax,%eax
f0104fff:	8b 80 28 60 34 f0    	mov    -0xfcb9fd8(%eax),%eax
f0105005:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0105009:	74 6f                	je     f010507a <trap+0x22d>
		sched_yield();
f010500b:	e8 91 02 00 00       	call   f01052a1 <sched_yield>
			monitor(tf);
f0105010:	83 ec 0c             	sub    $0xc,%esp
f0105013:	56                   	push   %esi
f0105014:	e8 d0 c0 ff ff       	call   f01010e9 <monitor>
f0105019:	83 c4 10             	add    $0x10,%esp
f010501c:	eb c8                	jmp    f0104fe6 <trap+0x199>
			ret_code =  syscall(
f010501e:	83 ec 08             	sub    $0x8,%esp
f0105021:	ff 76 04             	pushl  0x4(%esi)
f0105024:	ff 36                	pushl  (%esi)
f0105026:	ff 76 10             	pushl  0x10(%esi)
f0105029:	ff 76 18             	pushl  0x18(%esi)
f010502c:	ff 76 14             	pushl  0x14(%esi)
f010502f:	ff 76 1c             	pushl  0x1c(%esi)
f0105032:	e8 32 03 00 00       	call   f0105369 <syscall>
			tf->tf_regs.reg_eax = ret_code;
f0105037:	89 46 1c             	mov    %eax,0x1c(%esi)
f010503a:	83 c4 20             	add    $0x20,%esp
f010503d:	eb a7                	jmp    f0104fe6 <trap+0x199>
		cprintf("Spurious interrupt on irq 7\n");
f010503f:	83 ec 0c             	sub    $0xc,%esp
f0105042:	68 7f 8e 10 f0       	push   $0xf0108e7f
f0105047:	e8 9d f5 ff ff       	call   f01045e9 <cprintf>
		print_trapframe(tf);
f010504c:	89 34 24             	mov    %esi,(%esp)
f010504f:	e8 24 fb ff ff       	call   f0104b78 <print_trapframe>
f0105054:	83 c4 10             	add    $0x10,%esp
f0105057:	eb 8d                	jmp    f0104fe6 <trap+0x199>
		lapic_eoi();
f0105059:	e8 83 1e 00 00       	call   f0106ee1 <lapic_eoi>
		sched_yield();
f010505e:	e8 3e 02 00 00       	call   f01052a1 <sched_yield>
		panic("unhandled trap in kernel");
f0105063:	83 ec 04             	sub    $0x4,%esp
f0105066:	68 9c 8e 10 f0       	push   $0xf0108e9c
f010506b:	68 5b 01 00 00       	push   $0x15b
f0105070:	68 53 8e 10 f0       	push   $0xf0108e53
f0105075:	e8 cf af ff ff       	call   f0100049 <_panic>
		env_run(curenv);
f010507a:	e8 1b 1d 00 00       	call   f0106d9a <cpunum>
f010507f:	83 ec 0c             	sub    $0xc,%esp
f0105082:	6b c0 74             	imul   $0x74,%eax,%eax
f0105085:	ff b0 28 60 34 f0    	pushl  -0xfcb9fd8(%eax)
f010508b:	e8 b9 f2 ff ff       	call   f0104349 <env_run>

f0105090 <divide_handler>:

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */

TRAPHANDLER_NOEC(divide_handler, T_DIVIDE)
f0105090:	6a 00                	push   $0x0
f0105092:	6a 00                	push   $0x0
f0105094:	e9 29 01 00 00       	jmp    f01051c2 <_alltraps>
f0105099:	90                   	nop

f010509a <debug_handler>:
TRAPHANDLER_NOEC(debug_handler, T_DEBUG)
f010509a:	6a 00                	push   $0x0
f010509c:	6a 01                	push   $0x1
f010509e:	e9 1f 01 00 00       	jmp    f01051c2 <_alltraps>
f01050a3:	90                   	nop

f01050a4 <nmi_handler>:
TRAPHANDLER_NOEC(nmi_handler, T_NMI)
f01050a4:	6a 00                	push   $0x0
f01050a6:	6a 02                	push   $0x2
f01050a8:	e9 15 01 00 00       	jmp    f01051c2 <_alltraps>
f01050ad:	90                   	nop

f01050ae <brkpt_handler>:
TRAPHANDLER_NOEC(brkpt_handler, T_BRKPT)
f01050ae:	6a 00                	push   $0x0
f01050b0:	6a 03                	push   $0x3
f01050b2:	e9 0b 01 00 00       	jmp    f01051c2 <_alltraps>
f01050b7:	90                   	nop

f01050b8 <oflow_handler>:
TRAPHANDLER_NOEC(oflow_handler, T_OFLOW)
f01050b8:	6a 00                	push   $0x0
f01050ba:	6a 04                	push   $0x4
f01050bc:	e9 01 01 00 00       	jmp    f01051c2 <_alltraps>
f01050c1:	90                   	nop

f01050c2 <bound_handler>:
TRAPHANDLER_NOEC(bound_handler, T_BOUND)
f01050c2:	6a 00                	push   $0x0
f01050c4:	6a 05                	push   $0x5
f01050c6:	e9 f7 00 00 00       	jmp    f01051c2 <_alltraps>
f01050cb:	90                   	nop

f01050cc <illop_handler>:
TRAPHANDLER_NOEC(illop_handler, T_ILLOP)
f01050cc:	6a 00                	push   $0x0
f01050ce:	6a 06                	push   $0x6
f01050d0:	e9 ed 00 00 00       	jmp    f01051c2 <_alltraps>
f01050d5:	90                   	nop

f01050d6 <device_handler>:
TRAPHANDLER_NOEC(device_handler, T_DEVICE)
f01050d6:	6a 00                	push   $0x0
f01050d8:	6a 07                	push   $0x7
f01050da:	e9 e3 00 00 00       	jmp    f01051c2 <_alltraps>
f01050df:	90                   	nop

f01050e0 <dblflt_handler>:
TRAPHANDLER(dblflt_handler, T_DBLFLT)
f01050e0:	6a 08                	push   $0x8
f01050e2:	e9 db 00 00 00       	jmp    f01051c2 <_alltraps>
f01050e7:	90                   	nop

f01050e8 <tss_handler>:
TRAPHANDLER(tss_handler, T_TSS)
f01050e8:	6a 0a                	push   $0xa
f01050ea:	e9 d3 00 00 00       	jmp    f01051c2 <_alltraps>
f01050ef:	90                   	nop

f01050f0 <segnp_handler>:
TRAPHANDLER(segnp_handler, T_SEGNP)
f01050f0:	6a 0b                	push   $0xb
f01050f2:	e9 cb 00 00 00       	jmp    f01051c2 <_alltraps>
f01050f7:	90                   	nop

f01050f8 <stack_handler>:
TRAPHANDLER(stack_handler, T_STACK)
f01050f8:	6a 0c                	push   $0xc
f01050fa:	e9 c3 00 00 00       	jmp    f01051c2 <_alltraps>
f01050ff:	90                   	nop

f0105100 <gpflt_handler>:
TRAPHANDLER(gpflt_handler, T_GPFLT)
f0105100:	6a 0d                	push   $0xd
f0105102:	e9 bb 00 00 00       	jmp    f01051c2 <_alltraps>
f0105107:	90                   	nop

f0105108 <pgflt_handler>:
TRAPHANDLER(pgflt_handler, T_PGFLT)
f0105108:	6a 0e                	push   $0xe
f010510a:	e9 b3 00 00 00       	jmp    f01051c2 <_alltraps>
f010510f:	90                   	nop

f0105110 <fperr_handler>:
TRAPHANDLER_NOEC(fperr_handler, T_FPERR)
f0105110:	6a 00                	push   $0x0
f0105112:	6a 10                	push   $0x10
f0105114:	e9 a9 00 00 00       	jmp    f01051c2 <_alltraps>
f0105119:	90                   	nop

f010511a <align_handler>:
TRAPHANDLER_NOEC(align_handler, T_ALIGN)
f010511a:	6a 00                	push   $0x0
f010511c:	6a 11                	push   $0x11
f010511e:	e9 9f 00 00 00       	jmp    f01051c2 <_alltraps>
f0105123:	90                   	nop

f0105124 <mchk_handler>:
TRAPHANDLER_NOEC(mchk_handler, T_MCHK)
f0105124:	6a 00                	push   $0x0
f0105126:	6a 12                	push   $0x12
f0105128:	e9 95 00 00 00       	jmp    f01051c2 <_alltraps>
f010512d:	90                   	nop

f010512e <simderr_handler>:
TRAPHANDLER_NOEC(simderr_handler, T_SIMDERR)
f010512e:	6a 00                	push   $0x0
f0105130:	6a 13                	push   $0x13
f0105132:	e9 8b 00 00 00       	jmp    f01051c2 <_alltraps>
f0105137:	90                   	nop

f0105138 <syscall_handler>:


TRAPHANDLER_NOEC(syscall_handler, T_SYSCALL)
f0105138:	6a 00                	push   $0x0
f010513a:	6a 30                	push   $0x30
f010513c:	e9 81 00 00 00       	jmp    f01051c2 <_alltraps>
f0105141:	90                   	nop

f0105142 <irq_timer_handler>:


TRAPHANDLER_NOEC(irq_timer_handler, IRQ_OFFSET+IRQ_TIMER)
f0105142:	6a 00                	push   $0x0
f0105144:	6a 20                	push   $0x20
f0105146:	eb 7a                	jmp    f01051c2 <_alltraps>

f0105148 <irq_kbd_handler>:
TRAPHANDLER_NOEC(irq_kbd_handler, IRQ_OFFSET+IRQ_KBD)
f0105148:	6a 00                	push   $0x0
f010514a:	6a 21                	push   $0x21
f010514c:	eb 74                	jmp    f01051c2 <_alltraps>

f010514e <irq_2_handler>:
TRAPHANDLER_NOEC(irq_2_handler, IRQ_OFFSET+2)
f010514e:	6a 00                	push   $0x0
f0105150:	6a 22                	push   $0x22
f0105152:	eb 6e                	jmp    f01051c2 <_alltraps>

f0105154 <irq_3_handler>:
TRAPHANDLER_NOEC(irq_3_handler, IRQ_OFFSET+3)
f0105154:	6a 00                	push   $0x0
f0105156:	6a 23                	push   $0x23
f0105158:	eb 68                	jmp    f01051c2 <_alltraps>

f010515a <irq_serial_handler>:
TRAPHANDLER_NOEC(irq_serial_handler, IRQ_OFFSET+irq_serial_handler)
f010515a:	6a 00                	push   $0x0
f010515c:	68 7a 51 10 f0       	push   $0xf010517a
f0105161:	eb 5f                	jmp    f01051c2 <_alltraps>
f0105163:	90                   	nop

f0105164 <irq_5_handler>:
TRAPHANDLER_NOEC(irq_5_handler, IRQ_OFFSET+5)
f0105164:	6a 00                	push   $0x0
f0105166:	6a 25                	push   $0x25
f0105168:	eb 58                	jmp    f01051c2 <_alltraps>

f010516a <irq_6_handler>:
TRAPHANDLER_NOEC(irq_6_handler, IRQ_OFFSET+6)
f010516a:	6a 00                	push   $0x0
f010516c:	6a 26                	push   $0x26
f010516e:	eb 52                	jmp    f01051c2 <_alltraps>

f0105170 <irq_spurious_handler>:
TRAPHANDLER_NOEC( irq_spurious_handler, IRQ_OFFSET+irq_spurious_handler)
f0105170:	6a 00                	push   $0x0
f0105172:	68 90 51 10 f0       	push   $0xf0105190
f0105177:	eb 49                	jmp    f01051c2 <_alltraps>
f0105179:	90                   	nop

f010517a <irq_8_handler>:
TRAPHANDLER_NOEC(irq_8_handler, IRQ_OFFSET+8)
f010517a:	6a 00                	push   $0x0
f010517c:	6a 28                	push   $0x28
f010517e:	eb 42                	jmp    f01051c2 <_alltraps>

f0105180 <irq_9_handler>:
TRAPHANDLER_NOEC(irq_9_handler, IRQ_OFFSET+9)
f0105180:	6a 00                	push   $0x0
f0105182:	6a 29                	push   $0x29
f0105184:	eb 3c                	jmp    f01051c2 <_alltraps>

f0105186 <irq_10_handler>:
TRAPHANDLER_NOEC(irq_10_handler, IRQ_OFFSET+10)
f0105186:	6a 00                	push   $0x0
f0105188:	6a 2a                	push   $0x2a
f010518a:	eb 36                	jmp    f01051c2 <_alltraps>

f010518c <irq_11_handler>:
TRAPHANDLER_NOEC(irq_11_handler, IRQ_OFFSET+11)
f010518c:	6a 00                	push   $0x0
f010518e:	6a 2b                	push   $0x2b
f0105190:	eb 30                	jmp    f01051c2 <_alltraps>

f0105192 <irq_12_handler>:
TRAPHANDLER_NOEC(irq_12_handler, IRQ_OFFSET+12)
f0105192:	6a 00                	push   $0x0
f0105194:	6a 2c                	push   $0x2c
f0105196:	eb 2a                	jmp    f01051c2 <_alltraps>

f0105198 <irq_13_handler>:
TRAPHANDLER_NOEC(irq_13_handler, IRQ_OFFSET+13)
f0105198:	6a 00                	push   $0x0
f010519a:	6a 2d                	push   $0x2d
f010519c:	eb 24                	jmp    f01051c2 <_alltraps>

f010519e <irq_ide_handler>:
TRAPHANDLER_NOEC(irq_ide_handler, IRQ_OFFSET+IRQ_IDE)
f010519e:	6a 00                	push   $0x0
f01051a0:	6a 2e                	push   $0x2e
f01051a2:	eb 1e                	jmp    f01051c2 <_alltraps>

f01051a4 <irq_15_handler>:
TRAPHANDLER_NOEC(irq_15_handler, IRQ_OFFSET+15)
f01051a4:	6a 00                	push   $0x0
f01051a6:	6a 2f                	push   $0x2f
f01051a8:	eb 18                	jmp    f01051c2 <_alltraps>

f01051aa <irq_error_handler>:
TRAPHANDLER_NOEC(irq_error_handler, IRQ_OFFSET+IRQ_ERROR)
f01051aa:	6a 00                	push   $0x0
f01051ac:	6a 33                	push   $0x33
f01051ae:	eb 12                	jmp    f01051c2 <_alltraps>

f01051b0 <sysenter_handler>:

.globl sysenter_handler;
.type sysenter_handler, @function;
.align 2;
sysenter_handler:
  pushl $0
f01051b0:	6a 00                	push   $0x0
  pushl %edi
f01051b2:	57                   	push   %edi
  pushl %ebx
f01051b3:	53                   	push   %ebx
  pushl %ecx
f01051b4:	51                   	push   %ecx
  pushl %edx
f01051b5:	52                   	push   %edx
  pushl %eax
f01051b6:	50                   	push   %eax
  call syscall
f01051b7:	e8 ad 01 00 00       	call   f0105369 <syscall>
  movl %ebp, %ecx
f01051bc:	89 e9                	mov    %ebp,%ecx
  movl %esi, %edx
f01051be:	89 f2                	mov    %esi,%edx
  sysexit
f01051c0:	0f 35                	sysexit 

f01051c2 <_alltraps>:

.globl _alltraps;
.type _alltraps, @function
.align 2;
_alltraps:
	pushl %ds 
f01051c2:	1e                   	push   %ds
	pushl %es 
f01051c3:	06                   	push   %es
	pushal
f01051c4:	60                   	pusha  
	movl $GD_KD, %eax
f01051c5:	b8 10 00 00 00       	mov    $0x10,%eax
	movw %ax, %ds 
f01051ca:	8e d8                	mov    %eax,%ds
	movw %ax, %es
f01051cc:	8e c0                	mov    %eax,%es
	pushl %esp 
f01051ce:	54                   	push   %esp
	call trap 
f01051cf:	e8 79 fc ff ff       	call   f0104e4d <trap>

f01051d4 <sched_halt>:
// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
{
f01051d4:	55                   	push   %ebp
f01051d5:	89 e5                	mov    %esp,%ebp
f01051d7:	83 ec 08             	sub    $0x8,%esp
f01051da:	a1 48 42 34 f0       	mov    0xf0344248,%eax
f01051df:	8d 50 54             	lea    0x54(%eax),%edx
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
f01051e2:	b9 00 00 00 00       	mov    $0x0,%ecx
		if ((envs[i].env_status == ENV_RUNNABLE ||
		     envs[i].env_status == ENV_RUNNING ||
f01051e7:	8b 02                	mov    (%edx),%eax
f01051e9:	83 e8 01             	sub    $0x1,%eax
		if ((envs[i].env_status == ENV_RUNNABLE ||
f01051ec:	83 f8 02             	cmp    $0x2,%eax
f01051ef:	76 30                	jbe    f0105221 <sched_halt+0x4d>
	for (i = 0; i < NENV; i++) {
f01051f1:	83 c1 01             	add    $0x1,%ecx
f01051f4:	81 c2 84 00 00 00    	add    $0x84,%edx
f01051fa:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
f0105200:	75 e5                	jne    f01051e7 <sched_halt+0x13>
		     envs[i].env_status == ENV_DYING))
			break;
	}
	if (i == NENV) {
		cprintf("No runnable environments in the system!\n");
f0105202:	83 ec 0c             	sub    $0xc,%esp
f0105205:	68 b0 90 10 f0       	push   $0xf01090b0
f010520a:	e8 da f3 ff ff       	call   f01045e9 <cprintf>
f010520f:	83 c4 10             	add    $0x10,%esp
		while (1)
			monitor(NULL);
f0105212:	83 ec 0c             	sub    $0xc,%esp
f0105215:	6a 00                	push   $0x0
f0105217:	e8 cd be ff ff       	call   f01010e9 <monitor>
f010521c:	83 c4 10             	add    $0x10,%esp
f010521f:	eb f1                	jmp    f0105212 <sched_halt+0x3e>
	}

	// Mark that no environment is running on this CPU
	curenv = NULL;
f0105221:	e8 74 1b 00 00       	call   f0106d9a <cpunum>
f0105226:	6b c0 74             	imul   $0x74,%eax,%eax
f0105229:	c7 80 28 60 34 f0 00 	movl   $0x0,-0xfcb9fd8(%eax)
f0105230:	00 00 00 
	lcr3(PADDR(kern_pgdir));
f0105233:	a1 8c 5e 34 f0       	mov    0xf0345e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f0105238:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010523d:	76 50                	jbe    f010528f <sched_halt+0xbb>
	return (physaddr_t)kva - KERNBASE;
f010523f:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0105244:	0f 22 d8             	mov    %eax,%cr3

	// Mark that this CPU is in the HALT state, so that when
	// timer interupts come in, we know we should re-acquire the
	// big kernel lock
	xchg(&thiscpu->cpu_status, CPU_HALTED);
f0105247:	e8 4e 1b 00 00       	call   f0106d9a <cpunum>
f010524c:	6b d0 74             	imul   $0x74,%eax,%edx
f010524f:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f0105252:	b8 02 00 00 00       	mov    $0x2,%eax
f0105257:	f0 87 82 20 60 34 f0 	lock xchg %eax,-0xfcb9fe0(%edx)
	spin_unlock(&kernel_lock);
f010525e:	83 ec 0c             	sub    $0xc,%esp
f0105261:	68 c0 53 12 f0       	push   $0xf01253c0
f0105266:	e8 3b 1e 00 00       	call   f01070a6 <spin_unlock>
	asm volatile("pause");
f010526b:	f3 90                	pause  
		// Uncomment the following line after completing exercise 13
		"sti\n"
		"1:\n"
		"hlt\n"
		"jmp 1b\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
f010526d:	e8 28 1b 00 00       	call   f0106d9a <cpunum>
f0105272:	6b c0 74             	imul   $0x74,%eax,%eax
	asm volatile (
f0105275:	8b 80 30 60 34 f0    	mov    -0xfcb9fd0(%eax),%eax
f010527b:	bd 00 00 00 00       	mov    $0x0,%ebp
f0105280:	89 c4                	mov    %eax,%esp
f0105282:	6a 00                	push   $0x0
f0105284:	6a 00                	push   $0x0
f0105286:	fb                   	sti    
f0105287:	f4                   	hlt    
f0105288:	eb fd                	jmp    f0105287 <sched_halt+0xb3>
}
f010528a:	83 c4 10             	add    $0x10,%esp
f010528d:	c9                   	leave  
f010528e:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010528f:	50                   	push   %eax
f0105290:	68 78 74 10 f0       	push   $0xf0107478
f0105295:	6a 68                	push   $0x68
f0105297:	68 d9 90 10 f0       	push   $0xf01090d9
f010529c:	e8 a8 ad ff ff       	call   f0100049 <_panic>

f01052a1 <sched_yield>:
{
f01052a1:	55                   	push   %ebp
f01052a2:	89 e5                	mov    %esp,%ebp
f01052a4:	57                   	push   %edi
f01052a5:	56                   	push   %esi
f01052a6:	53                   	push   %ebx
f01052a7:	83 ec 1c             	sub    $0x1c,%esp
	idle = thiscpu->cpu_env;
f01052aa:	e8 eb 1a 00 00       	call   f0106d9a <cpunum>
f01052af:	6b c0 74             	imul   $0x74,%eax,%eax
f01052b2:	8b 80 28 60 34 f0    	mov    -0xfcb9fd8(%eax),%eax
f01052b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	start = (idle != NULL) ? ENVX(idle->env_id) : 0;
f01052bb:	be 00 00 00 00       	mov    $0x0,%esi
f01052c0:	85 c0                	test   %eax,%eax
f01052c2:	74 0e                	je     f01052d2 <sched_yield+0x31>
f01052c4:	8b 40 48             	mov    0x48(%eax),%eax
f01052c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01052ca:	89 c6                	mov    %eax,%esi
f01052cc:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
			if (envs[j].env_status == ENV_RUNNABLE) {
f01052d2:	8b 3d 48 42 34 f0    	mov    0xf0344248,%edi
f01052d8:	89 f2                	mov    %esi,%edx
f01052da:	81 c6 00 04 00 00    	add    $0x400,%esi
	runenv = NULL;
f01052e0:	bb 00 00 00 00       	mov    $0x0,%ebx
f01052e5:	eb 09                	jmp    f01052f0 <sched_yield+0x4f>
							runenv = &envs[j];
f01052e7:	89 c3                	mov    %eax,%ebx
f01052e9:	83 c2 01             	add    $0x1,%edx
	for (i = 0; i < NENV; i++) {
f01052ec:	39 f2                	cmp    %esi,%edx
f01052ee:	74 35                	je     f0105325 <sched_yield+0x84>
			j = (start + i) % NENV;
f01052f0:	89 d1                	mov    %edx,%ecx
f01052f2:	c1 f9 1f             	sar    $0x1f,%ecx
f01052f5:	c1 e9 16             	shr    $0x16,%ecx
f01052f8:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
f01052fb:	25 ff 03 00 00       	and    $0x3ff,%eax
f0105300:	29 c8                	sub    %ecx,%eax
			if (envs[j].env_status == ENV_RUNNABLE) {
f0105302:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
f0105308:	01 f8                	add    %edi,%eax
f010530a:	83 78 54 02          	cmpl   $0x2,0x54(%eax)
f010530e:	75 d9                	jne    f01052e9 <sched_yield+0x48>
					if (runenv == NULL || envs[j].env_priority < runenv->env_priority)
f0105310:	85 db                	test   %ebx,%ebx
f0105312:	74 d3                	je     f01052e7 <sched_yield+0x46>
f0105314:	8b 88 80 00 00 00    	mov    0x80(%eax),%ecx
							runenv = &envs[j];
f010531a:	3b 8b 80 00 00 00    	cmp    0x80(%ebx),%ecx
f0105320:	0f 4c d8             	cmovl  %eax,%ebx
f0105323:	eb c4                	jmp    f01052e9 <sched_yield+0x48>
	if ((idle && idle->env_status == ENV_RUNNING) && (runenv == NULL || idle->env_priority < runenv->env_priority)){
f0105325:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105328:	85 c0                	test   %eax,%eax
f010532a:	74 06                	je     f0105332 <sched_yield+0x91>
f010532c:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0105330:	74 11                	je     f0105343 <sched_yield+0xa2>
	if (runenv) {
f0105332:	85 db                	test   %ebx,%ebx
f0105334:	75 1f                	jne    f0105355 <sched_yield+0xb4>
	sched_halt();
f0105336:	e8 99 fe ff ff       	call   f01051d4 <sched_halt>
}
f010533b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010533e:	5b                   	pop    %ebx
f010533f:	5e                   	pop    %esi
f0105340:	5f                   	pop    %edi
f0105341:	5d                   	pop    %ebp
f0105342:	c3                   	ret    
	if ((idle && idle->env_status == ENV_RUNNING) && (runenv == NULL || idle->env_priority < runenv->env_priority)){
f0105343:	85 db                	test   %ebx,%ebx
f0105345:	74 17                	je     f010535e <sched_yield+0xbd>
f0105347:	8b bb 80 00 00 00    	mov    0x80(%ebx),%edi
f010534d:	39 b8 80 00 00 00    	cmp    %edi,0x80(%eax)
f0105353:	7c 09                	jl     f010535e <sched_yield+0xbd>
			env_run(runenv);
f0105355:	83 ec 0c             	sub    $0xc,%esp
f0105358:	53                   	push   %ebx
f0105359:	e8 eb ef ff ff       	call   f0104349 <env_run>
			env_run(idle);
f010535e:	83 ec 0c             	sub    $0xc,%esp
f0105361:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105364:	e8 e0 ef ff ff       	call   f0104349 <env_run>

f0105369 <syscall>:


// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f0105369:	55                   	push   %ebp
f010536a:	89 e5                	mov    %esp,%ebp
f010536c:	57                   	push   %edi
f010536d:	56                   	push   %esi
f010536e:	53                   	push   %ebx
f010536f:	83 ec 1c             	sub    $0x1c,%esp
f0105372:	8b 45 08             	mov    0x8(%ebp),%eax
	// Return any appropriate return value.
	// LAB 3: Your code here.

	// panic("syscall not implemented");

	switch (syscallno) {
f0105375:	83 f8 10             	cmp    $0x10,%eax
f0105378:	0f 87 dc 06 00 00    	ja     f0105a5a <syscall+0x6f1>
f010537e:	ff 24 85 30 91 10 f0 	jmp    *-0xfef6ed0(,%eax,4)
	return cons_getc();
f0105385:	e8 0e b3 ff ff       	call   f0100698 <cons_getc>
f010538a:	89 c3                	mov    %eax,%ebx
		case SYS_env_set_priority:
			return sys_env_set_priority((envid_t)a1, a2);
		default:
			return -E_INVAL;
	}
}
f010538c:	89 d8                	mov    %ebx,%eax
f010538e:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105391:	5b                   	pop    %ebx
f0105392:	5e                   	pop    %esi
f0105393:	5f                   	pop    %edi
f0105394:	5d                   	pop    %ebp
f0105395:	c3                   	ret    
	user_mem_assert(curenv, s, len, 0);
f0105396:	e8 ff 19 00 00       	call   f0106d9a <cpunum>
f010539b:	6a 00                	push   $0x0
f010539d:	ff 75 10             	pushl  0x10(%ebp)
f01053a0:	ff 75 0c             	pushl  0xc(%ebp)
f01053a3:	6b c0 74             	imul   $0x74,%eax,%eax
f01053a6:	ff b0 28 60 34 f0    	pushl  -0xfcb9fd8(%eax)
f01053ac:	e8 a8 e7 ff ff       	call   f0103b59 <user_mem_assert>
	cprintf("%.*s", len, s);
f01053b1:	83 c4 0c             	add    $0xc,%esp
f01053b4:	ff 75 0c             	pushl  0xc(%ebp)
f01053b7:	ff 75 10             	pushl  0x10(%ebp)
f01053ba:	68 e6 90 10 f0       	push   $0xf01090e6
f01053bf:	e8 25 f2 ff ff       	call   f01045e9 <cprintf>
f01053c4:	83 c4 10             	add    $0x10,%esp
			return 0;
f01053c7:	bb 00 00 00 00       	mov    $0x0,%ebx
f01053cc:	eb be                	jmp    f010538c <syscall+0x23>
	if ((r = envid2env(envid, &e, 1)) < 0)
f01053ce:	83 ec 04             	sub    $0x4,%esp
f01053d1:	6a 01                	push   $0x1
f01053d3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01053d6:	50                   	push   %eax
f01053d7:	ff 75 0c             	pushl  0xc(%ebp)
f01053da:	e8 c6 e7 ff ff       	call   f0103ba5 <envid2env>
f01053df:	89 c3                	mov    %eax,%ebx
f01053e1:	83 c4 10             	add    $0x10,%esp
f01053e4:	85 c0                	test   %eax,%eax
f01053e6:	78 a4                	js     f010538c <syscall+0x23>
	if (e == curenv)
f01053e8:	e8 ad 19 00 00       	call   f0106d9a <cpunum>
f01053ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01053f0:	6b c0 74             	imul   $0x74,%eax,%eax
f01053f3:	39 90 28 60 34 f0    	cmp    %edx,-0xfcb9fd8(%eax)
f01053f9:	74 3d                	je     f0105438 <syscall+0xcf>
		cprintf("[%08x] destroying %08x\n", curenv->env_id, e->env_id);
f01053fb:	8b 5a 48             	mov    0x48(%edx),%ebx
f01053fe:	e8 97 19 00 00       	call   f0106d9a <cpunum>
f0105403:	83 ec 04             	sub    $0x4,%esp
f0105406:	53                   	push   %ebx
f0105407:	6b c0 74             	imul   $0x74,%eax,%eax
f010540a:	8b 80 28 60 34 f0    	mov    -0xfcb9fd8(%eax),%eax
f0105410:	ff 70 48             	pushl  0x48(%eax)
f0105413:	68 06 91 10 f0       	push   $0xf0109106
f0105418:	e8 cc f1 ff ff       	call   f01045e9 <cprintf>
f010541d:	83 c4 10             	add    $0x10,%esp
	env_destroy(e);
f0105420:	83 ec 0c             	sub    $0xc,%esp
f0105423:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105426:	e8 7f ee ff ff       	call   f01042aa <env_destroy>
f010542b:	83 c4 10             	add    $0x10,%esp
	return 0;
f010542e:	bb 00 00 00 00       	mov    $0x0,%ebx
			return sys_env_destroy(a1);
f0105433:	e9 54 ff ff ff       	jmp    f010538c <syscall+0x23>
		cprintf("[%08x] exiting gracefully\n", curenv->env_id);
f0105438:	e8 5d 19 00 00       	call   f0106d9a <cpunum>
f010543d:	83 ec 08             	sub    $0x8,%esp
f0105440:	6b c0 74             	imul   $0x74,%eax,%eax
f0105443:	8b 80 28 60 34 f0    	mov    -0xfcb9fd8(%eax),%eax
f0105449:	ff 70 48             	pushl  0x48(%eax)
f010544c:	68 eb 90 10 f0       	push   $0xf01090eb
f0105451:	e8 93 f1 ff ff       	call   f01045e9 <cprintf>
f0105456:	83 c4 10             	add    $0x10,%esp
f0105459:	eb c5                	jmp    f0105420 <syscall+0xb7>
	return curenv->env_id;
f010545b:	e8 3a 19 00 00       	call   f0106d9a <cpunum>
f0105460:	6b c0 74             	imul   $0x74,%eax,%eax
f0105463:	8b 80 28 60 34 f0    	mov    -0xfcb9fd8(%eax),%eax
f0105469:	8b 58 48             	mov    0x48(%eax),%ebx
			return sys_getenvid();
f010546c:	e9 1b ff ff ff       	jmp    f010538c <syscall+0x23>
	if ((uint32_t)kva < KERNBASE)
f0105471:	81 7d 0c ff ff ff ef 	cmpl   $0xefffffff,0xc(%ebp)
f0105478:	76 4a                	jbe    f01054c4 <syscall+0x15b>
	return (physaddr_t)kva - KERNBASE;
f010547a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010547d:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f0105482:	c1 e8 0c             	shr    $0xc,%eax
f0105485:	3b 05 88 5e 34 f0    	cmp    0xf0345e88,%eax
f010548b:	73 4e                	jae    f01054db <syscall+0x172>
	return &pages[PGNUM(pa)];
f010548d:	8b 15 90 5e 34 f0    	mov    0xf0345e90,%edx
f0105493:	8d 1c c2             	lea    (%edx,%eax,8),%ebx
    if (p == NULL)
f0105496:	85 db                	test   %ebx,%ebx
f0105498:	0f 84 c6 05 00 00    	je     f0105a64 <syscall+0x6fb>
    r = page_insert(curenv->env_pgdir, p, va, PTE_U | PTE_W);
f010549e:	e8 f7 18 00 00       	call   f0106d9a <cpunum>
f01054a3:	6a 06                	push   $0x6
f01054a5:	ff 75 10             	pushl  0x10(%ebp)
f01054a8:	53                   	push   %ebx
f01054a9:	6b c0 74             	imul   $0x74,%eax,%eax
f01054ac:	8b 80 28 60 34 f0    	mov    -0xfcb9fd8(%eax),%eax
f01054b2:	ff 70 60             	pushl  0x60(%eax)
f01054b5:	e8 b8 c8 ff ff       	call   f0101d72 <page_insert>
f01054ba:	89 c3                	mov    %eax,%ebx
f01054bc:	83 c4 10             	add    $0x10,%esp
f01054bf:	e9 c8 fe ff ff       	jmp    f010538c <syscall+0x23>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01054c4:	ff 75 0c             	pushl  0xc(%ebp)
f01054c7:	68 78 74 10 f0       	push   $0xf0107478
f01054cc:	68 ec 01 00 00       	push   $0x1ec
f01054d1:	68 1e 91 10 f0       	push   $0xf010911e
f01054d6:	e8 6e ab ff ff       	call   f0100049 <_panic>
		panic("pa2page called with invalid pa");
f01054db:	83 ec 04             	sub    $0x4,%esp
f01054de:	68 fc 7e 10 f0       	push   $0xf0107efc
f01054e3:	6a 51                	push   $0x51
f01054e5:	68 88 87 10 f0       	push   $0xf0108788
f01054ea:	e8 5a ab ff ff       	call   f0100049 <_panic>
	uint32_t size = ROUNDUP(inc, PGSIZE);
f01054ef:	8b 45 0c             	mov    0xc(%ebp),%eax
f01054f2:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
f01054f8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	region_alloc(curenv, (void *)curenv->env_heap, size);
f01054fe:	e8 97 18 00 00       	call   f0106d9a <cpunum>
f0105503:	6b c0 74             	imul   $0x74,%eax,%eax
f0105506:	8b 80 28 60 34 f0    	mov    -0xfcb9fd8(%eax),%eax
f010550c:	8b 70 7c             	mov    0x7c(%eax),%esi
f010550f:	e8 86 18 00 00       	call   f0106d9a <cpunum>
f0105514:	83 ec 04             	sub    $0x4,%esp
f0105517:	53                   	push   %ebx
f0105518:	56                   	push   %esi
f0105519:	6b c0 74             	imul   $0x74,%eax,%eax
f010551c:	ff b0 28 60 34 f0    	pushl  -0xfcb9fd8(%eax)
f0105522:	e8 3a e9 ff ff       	call   f0103e61 <region_alloc>
	curenv->env_heap += size;
f0105527:	e8 6e 18 00 00       	call   f0106d9a <cpunum>
f010552c:	6b c0 74             	imul   $0x74,%eax,%eax
f010552f:	8b 80 28 60 34 f0    	mov    -0xfcb9fd8(%eax),%eax
f0105535:	01 58 7c             	add    %ebx,0x7c(%eax)
	return curenv->env_heap;
f0105538:	e8 5d 18 00 00       	call   f0106d9a <cpunum>
f010553d:	6b c0 74             	imul   $0x74,%eax,%eax
f0105540:	8b 80 28 60 34 f0    	mov    -0xfcb9fd8(%eax),%eax
f0105546:	8b 58 7c             	mov    0x7c(%eax),%ebx
			return sys_sbrk(a1);
f0105549:	83 c4 10             	add    $0x10,%esp
f010554c:	e9 3b fe ff ff       	jmp    f010538c <syscall+0x23>
	sched_yield();
f0105551:	e8 4b fd ff ff       	call   f01052a1 <sched_yield>
	ret = env_alloc(&e, curenv->env_id);
f0105556:	e8 3f 18 00 00       	call   f0106d9a <cpunum>
f010555b:	83 ec 08             	sub    $0x8,%esp
f010555e:	6b c0 74             	imul   $0x74,%eax,%eax
f0105561:	8b 80 28 60 34 f0    	mov    -0xfcb9fd8(%eax),%eax
f0105567:	ff 70 48             	pushl  0x48(%eax)
f010556a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010556d:	50                   	push   %eax
f010556e:	e8 46 e7 ff ff       	call   f0103cb9 <env_alloc>
f0105573:	89 c3                	mov    %eax,%ebx
	if(ret < 0){
f0105575:	83 c4 10             	add    $0x10,%esp
f0105578:	85 c0                	test   %eax,%eax
f010557a:	0f 88 0c fe ff ff    	js     f010538c <syscall+0x23>
	e->env_status = ENV_NOT_RUNNABLE;
f0105580:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105583:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	e->env_tf = curenv->env_tf;
f010558a:	e8 0b 18 00 00       	call   f0106d9a <cpunum>
f010558f:	6b c0 74             	imul   $0x74,%eax,%eax
f0105592:	8b b0 28 60 34 f0    	mov    -0xfcb9fd8(%eax),%esi
f0105598:	b9 11 00 00 00       	mov    $0x11,%ecx
f010559d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01055a0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	e->env_tf.tf_regs.reg_eax = 0;
f01055a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01055a5:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	e->env_heap = curenv->env_heap;
f01055ac:	e8 e9 17 00 00       	call   f0106d9a <cpunum>
f01055b1:	6b c0 74             	imul   $0x74,%eax,%eax
f01055b4:	8b 80 28 60 34 f0    	mov    -0xfcb9fd8(%eax),%eax
f01055ba:	8b 50 7c             	mov    0x7c(%eax),%edx
f01055bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01055c0:	89 50 7c             	mov    %edx,0x7c(%eax)
	e->env_priority = curenv->env_priority;
f01055c3:	e8 d2 17 00 00       	call   f0106d9a <cpunum>
f01055c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01055cb:	6b c0 74             	imul   $0x74,%eax,%eax
f01055ce:	8b 80 28 60 34 f0    	mov    -0xfcb9fd8(%eax),%eax
f01055d4:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
f01055da:	89 82 80 00 00 00    	mov    %eax,0x80(%edx)
	return e->env_id;
f01055e0:	8b 5a 48             	mov    0x48(%edx),%ebx
			return sys_exofork();
f01055e3:	e9 a4 fd ff ff       	jmp    f010538c <syscall+0x23>
	if((status != ENV_RUNNABLE) && (status != ENV_NOT_RUNNABLE)){
f01055e8:	8b 45 10             	mov    0x10(%ebp),%eax
f01055eb:	83 e8 02             	sub    $0x2,%eax
f01055ee:	a9 fd ff ff ff       	test   $0xfffffffd,%eax
f01055f3:	75 4d                	jne    f0105642 <syscall+0x2d9>
	ret = envid2env(envid, &e, 1);
f01055f5:	83 ec 04             	sub    $0x4,%esp
f01055f8:	6a 01                	push   $0x1
f01055fa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01055fd:	50                   	push   %eax
f01055fe:	ff 75 0c             	pushl  0xc(%ebp)
f0105601:	e8 9f e5 ff ff       	call   f0103ba5 <envid2env>
f0105606:	89 c3                	mov    %eax,%ebx
	if(ret < 0){
f0105608:	83 c4 10             	add    $0x10,%esp
f010560b:	85 c0                	test   %eax,%eax
f010560d:	0f 88 79 fd ff ff    	js     f010538c <syscall+0x23>
	if(status > 100){
f0105613:	83 7d 10 64          	cmpl   $0x64,0x10(%ebp)
f0105617:	7f 13                	jg     f010562c <syscall+0x2c3>
	e->env_status = status;
f0105619:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010561c:	8b 7d 10             	mov    0x10(%ebp),%edi
f010561f:	89 78 54             	mov    %edi,0x54(%eax)
	return 0;
f0105622:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105627:	e9 60 fd ff ff       	jmp    f010538c <syscall+0x23>
		e->env_priority = status;
f010562c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010562f:	8b 7d 10             	mov    0x10(%ebp),%edi
f0105632:	89 b8 80 00 00 00    	mov    %edi,0x80(%eax)
		return 0;
f0105638:	bb 00 00 00 00       	mov    $0x0,%ebx
f010563d:	e9 4a fd ff ff       	jmp    f010538c <syscall+0x23>
		return -E_INVAL;
f0105642:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			return sys_env_set_status((envid_t)a1, (int)a2);
f0105647:	e9 40 fd ff ff       	jmp    f010538c <syscall+0x23>
	if((uintptr_t)va >= UTOP || PGOFF(va)){
f010564c:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105653:	77 78                	ja     f01056cd <syscall+0x364>
f0105655:	8b 45 10             	mov    0x10(%ebp),%eax
f0105658:	25 ff 0f 00 00       	and    $0xfff,%eax
	if(!(perm & (PTE_U | PTE_P))){
f010565d:	f6 45 14 05          	testb  $0x5,0x14(%ebp)
f0105661:	74 74                	je     f01056d7 <syscall+0x36e>
	if(perm & (~PTE_SYSCALL)){
f0105663:	8b 5d 14             	mov    0x14(%ebp),%ebx
f0105666:	81 e3 f8 f1 ff ff    	and    $0xfffff1f8,%ebx
f010566c:	09 c3                	or     %eax,%ebx
f010566e:	75 71                	jne    f01056e1 <syscall+0x378>
	ret = envid2env(envid, &e, 1);
f0105670:	83 ec 04             	sub    $0x4,%esp
f0105673:	6a 01                	push   $0x1
f0105675:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105678:	50                   	push   %eax
f0105679:	ff 75 0c             	pushl  0xc(%ebp)
f010567c:	e8 24 e5 ff ff       	call   f0103ba5 <envid2env>
	if(ret < 0){
f0105681:	83 c4 10             	add    $0x10,%esp
f0105684:	85 c0                	test   %eax,%eax
f0105686:	78 63                	js     f01056eb <syscall+0x382>
	page = page_alloc(ALLOC_ZERO);
f0105688:	83 ec 0c             	sub    $0xc,%esp
f010568b:	6a 01                	push   $0x1
f010568d:	e8 69 c2 ff ff       	call   f01018fb <page_alloc>
f0105692:	89 c6                	mov    %eax,%esi
	if(!page){
f0105694:	83 c4 10             	add    $0x10,%esp
f0105697:	85 c0                	test   %eax,%eax
f0105699:	74 57                	je     f01056f2 <syscall+0x389>
	ret = page_insert(e->env_pgdir, page, va, perm);
f010569b:	ff 75 14             	pushl  0x14(%ebp)
f010569e:	ff 75 10             	pushl  0x10(%ebp)
f01056a1:	50                   	push   %eax
f01056a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01056a5:	ff 70 60             	pushl  0x60(%eax)
f01056a8:	e8 c5 c6 ff ff       	call   f0101d72 <page_insert>
f01056ad:	89 c7                	mov    %eax,%edi
	if(ret < 0){
f01056af:	83 c4 10             	add    $0x10,%esp
f01056b2:	85 c0                	test   %eax,%eax
f01056b4:	0f 89 d2 fc ff ff    	jns    f010538c <syscall+0x23>
		page_free(page);
f01056ba:	83 ec 0c             	sub    $0xc,%esp
f01056bd:	56                   	push   %esi
f01056be:	e8 aa c2 ff ff       	call   f010196d <page_free>
f01056c3:	83 c4 10             	add    $0x10,%esp
		return ret;
f01056c6:	89 fb                	mov    %edi,%ebx
f01056c8:	e9 bf fc ff ff       	jmp    f010538c <syscall+0x23>
		return -E_INVAL;
f01056cd:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01056d2:	e9 b5 fc ff ff       	jmp    f010538c <syscall+0x23>
		return -E_INVAL;
f01056d7:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01056dc:	e9 ab fc ff ff       	jmp    f010538c <syscall+0x23>
		return -E_INVAL;
f01056e1:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01056e6:	e9 a1 fc ff ff       	jmp    f010538c <syscall+0x23>
		return ret;
f01056eb:	89 c3                	mov    %eax,%ebx
f01056ed:	e9 9a fc ff ff       	jmp    f010538c <syscall+0x23>
		return -E_NO_MEM;
f01056f2:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
			return sys_page_alloc((envid_t)a1, (void *)a2, (int)a3);
f01056f7:	e9 90 fc ff ff       	jmp    f010538c <syscall+0x23>
	if((uintptr_t)srcva >= UTOP || PGOFF(srcva)){
f01056fc:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105703:	0f 87 bd 00 00 00    	ja     f01057c6 <syscall+0x45d>
	if((uintptr_t)dstva >= UTOP || PGOFF(dstva)){
f0105709:	81 7d 18 ff ff bf ee 	cmpl   $0xeebfffff,0x18(%ebp)
f0105710:	0f 87 ba 00 00 00    	ja     f01057d0 <syscall+0x467>
	if(!(perm & (PTE_U | PTE_P))){
f0105716:	f6 45 1c 05          	testb  $0x5,0x1c(%ebp)
f010571a:	0f 84 ba 00 00 00    	je     f01057da <syscall+0x471>
	if(perm & (~PTE_SYSCALL)){
f0105720:	8b 45 10             	mov    0x10(%ebp),%eax
f0105723:	0b 45 18             	or     0x18(%ebp),%eax
f0105726:	25 ff 0f 00 00       	and    $0xfff,%eax
f010572b:	8b 55 1c             	mov    0x1c(%ebp),%edx
f010572e:	81 e2 f8 f1 ff ff    	and    $0xfffff1f8,%edx
f0105734:	09 d0                	or     %edx,%eax
f0105736:	0f 85 a8 00 00 00    	jne    f01057e4 <syscall+0x47b>
	ret = envid2env(srcenvid, &srcenv, 1);
f010573c:	83 ec 04             	sub    $0x4,%esp
f010573f:	6a 01                	push   $0x1
f0105741:	8d 45 dc             	lea    -0x24(%ebp),%eax
f0105744:	50                   	push   %eax
f0105745:	ff 75 0c             	pushl  0xc(%ebp)
f0105748:	e8 58 e4 ff ff       	call   f0103ba5 <envid2env>
f010574d:	89 c3                	mov    %eax,%ebx
	if(ret < 0){
f010574f:	83 c4 10             	add    $0x10,%esp
f0105752:	85 c0                	test   %eax,%eax
f0105754:	0f 88 32 fc ff ff    	js     f010538c <syscall+0x23>
	ret = envid2env(dstenvid, &dstenv, 1);
f010575a:	83 ec 04             	sub    $0x4,%esp
f010575d:	6a 01                	push   $0x1
f010575f:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0105762:	50                   	push   %eax
f0105763:	ff 75 14             	pushl  0x14(%ebp)
f0105766:	e8 3a e4 ff ff       	call   f0103ba5 <envid2env>
f010576b:	89 c3                	mov    %eax,%ebx
	if(ret < 0){
f010576d:	83 c4 10             	add    $0x10,%esp
f0105770:	85 c0                	test   %eax,%eax
f0105772:	0f 88 14 fc ff ff    	js     f010538c <syscall+0x23>
	page = page_lookup(srcenv->env_pgdir, srcva, &pte);
f0105778:	83 ec 04             	sub    $0x4,%esp
f010577b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010577e:	50                   	push   %eax
f010577f:	ff 75 10             	pushl  0x10(%ebp)
f0105782:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0105785:	ff 70 60             	pushl  0x60(%eax)
f0105788:	e8 c1 c4 ff ff       	call   f0101c4e <page_lookup>
	if(!page){
f010578d:	83 c4 10             	add    $0x10,%esp
f0105790:	85 c0                	test   %eax,%eax
f0105792:	74 5a                	je     f01057ee <syscall+0x485>
	if((perm & PTE_W) && !(*pte & PTE_W)){
f0105794:	f6 45 1c 02          	testb  $0x2,0x1c(%ebp)
f0105798:	74 08                	je     f01057a2 <syscall+0x439>
f010579a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f010579d:	f6 02 02             	testb  $0x2,(%edx)
f01057a0:	74 56                	je     f01057f8 <syscall+0x48f>
	ret = page_insert(dstenv->env_pgdir, page, dstva, perm);
f01057a2:	ff 75 1c             	pushl  0x1c(%ebp)
f01057a5:	ff 75 18             	pushl  0x18(%ebp)
f01057a8:	50                   	push   %eax
f01057a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01057ac:	ff 70 60             	pushl  0x60(%eax)
f01057af:	e8 be c5 ff ff       	call   f0101d72 <page_insert>
f01057b4:	83 c4 10             	add    $0x10,%esp
f01057b7:	85 c0                	test   %eax,%eax
f01057b9:	bb 00 00 00 00       	mov    $0x0,%ebx
f01057be:	0f 4e d8             	cmovle %eax,%ebx
f01057c1:	e9 c6 fb ff ff       	jmp    f010538c <syscall+0x23>
		return -E_INVAL;
f01057c6:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01057cb:	e9 bc fb ff ff       	jmp    f010538c <syscall+0x23>
		return -E_INVAL;
f01057d0:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01057d5:	e9 b2 fb ff ff       	jmp    f010538c <syscall+0x23>
		return -E_INVAL;
f01057da:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01057df:	e9 a8 fb ff ff       	jmp    f010538c <syscall+0x23>
		return -E_INVAL;
f01057e4:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01057e9:	e9 9e fb ff ff       	jmp    f010538c <syscall+0x23>
		return -E_INVAL;
f01057ee:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01057f3:	e9 94 fb ff ff       	jmp    f010538c <syscall+0x23>
		return -E_INVAL;
f01057f8:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			return sys_page_map((envid_t)a1, (void *)a2, (envid_t)a3, (void *)a4, (int)a5);
f01057fd:	e9 8a fb ff ff       	jmp    f010538c <syscall+0x23>
	if((uintptr_t)va >= UTOP || PGOFF(va)){
f0105802:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105809:	77 45                	ja     f0105850 <syscall+0x4e7>
f010580b:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f0105812:	75 46                	jne    f010585a <syscall+0x4f1>
	ret = envid2env(envid, &e, 1);
f0105814:	83 ec 04             	sub    $0x4,%esp
f0105817:	6a 01                	push   $0x1
f0105819:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010581c:	50                   	push   %eax
f010581d:	ff 75 0c             	pushl  0xc(%ebp)
f0105820:	e8 80 e3 ff ff       	call   f0103ba5 <envid2env>
f0105825:	89 c3                	mov    %eax,%ebx
	if(ret < 0){
f0105827:	83 c4 10             	add    $0x10,%esp
f010582a:	85 c0                	test   %eax,%eax
f010582c:	0f 88 5a fb ff ff    	js     f010538c <syscall+0x23>
	page_remove(e->env_pgdir, va);
f0105832:	83 ec 08             	sub    $0x8,%esp
f0105835:	ff 75 10             	pushl  0x10(%ebp)
f0105838:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010583b:	ff 70 60             	pushl  0x60(%eax)
f010583e:	e8 cb c4 ff ff       	call   f0101d0e <page_remove>
f0105843:	83 c4 10             	add    $0x10,%esp
	return 0;
f0105846:	bb 00 00 00 00       	mov    $0x0,%ebx
f010584b:	e9 3c fb ff ff       	jmp    f010538c <syscall+0x23>
		return -E_INVAL;
f0105850:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105855:	e9 32 fb ff ff       	jmp    f010538c <syscall+0x23>
f010585a:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			return sys_page_unmap((envid_t)a1, (void *)a2);
f010585f:	e9 28 fb ff ff       	jmp    f010538c <syscall+0x23>
	ret = envid2env(envid, &e, 1);
f0105864:	83 ec 04             	sub    $0x4,%esp
f0105867:	6a 01                	push   $0x1
f0105869:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010586c:	50                   	push   %eax
f010586d:	ff 75 0c             	pushl  0xc(%ebp)
f0105870:	e8 30 e3 ff ff       	call   f0103ba5 <envid2env>
f0105875:	89 c3                	mov    %eax,%ebx
	if(ret < 0){
f0105877:	83 c4 10             	add    $0x10,%esp
f010587a:	85 c0                	test   %eax,%eax
f010587c:	0f 88 0a fb ff ff    	js     f010538c <syscall+0x23>
	e->env_pgfault_upcall = func;
f0105882:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105885:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0105888:	89 48 64             	mov    %ecx,0x64(%eax)
	return 0;
f010588b:	bb 00 00 00 00       	mov    $0x0,%ebx
			return sys_env_set_pgfault_upcall((envid_t)a1, (void *)a2);
f0105890:	e9 f7 fa ff ff       	jmp    f010538c <syscall+0x23>
	ret = envid2env(envid, &e, 0);
f0105895:	83 ec 04             	sub    $0x4,%esp
f0105898:	6a 00                	push   $0x0
f010589a:	8d 45 e0             	lea    -0x20(%ebp),%eax
f010589d:	50                   	push   %eax
f010589e:	ff 75 0c             	pushl  0xc(%ebp)
f01058a1:	e8 ff e2 ff ff       	call   f0103ba5 <envid2env>
f01058a6:	89 c3                	mov    %eax,%ebx
	if(ret < 0){
f01058a8:	83 c4 10             	add    $0x10,%esp
f01058ab:	85 c0                	test   %eax,%eax
f01058ad:	0f 88 d9 fa ff ff    	js     f010538c <syscall+0x23>
  	if(!e->env_ipc_recving){
f01058b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01058b6:	80 78 68 00          	cmpb   $0x0,0x68(%eax)
f01058ba:	0f 84 d8 00 00 00    	je     f0105998 <syscall+0x62f>
  	if(srcva < (void*)UTOP){
f01058c0:	81 7d 14 ff ff bf ee 	cmpl   $0xeebfffff,0x14(%ebp)
f01058c7:	77 72                	ja     f010593b <syscall+0x5d2>
    	if(PGOFF(srcva) || !(perm & PTE_P) || !(perm & PTE_U)){
f01058c9:	8b 55 14             	mov    0x14(%ebp),%edx
f01058cc:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
f01058d2:	8b 45 18             	mov    0x18(%ebp),%eax
f01058d5:	83 e0 05             	and    $0x5,%eax
f01058d8:	83 f8 05             	cmp    $0x5,%eax
f01058db:	0f 85 c1 00 00 00    	jne    f01059a2 <syscall+0x639>
		if(perm & (~PTE_SYSCALL)){
f01058e1:	8b 45 18             	mov    0x18(%ebp),%eax
f01058e4:	25 f8 f1 ff ff       	and    $0xfffff1f8,%eax
f01058e9:	09 d0                	or     %edx,%eax
f01058eb:	0f 85 bb 00 00 00    	jne    f01059ac <syscall+0x643>
		page = page_lookup(curenv->env_pgdir, srcva, &pte);
f01058f1:	e8 a4 14 00 00       	call   f0106d9a <cpunum>
f01058f6:	83 ec 04             	sub    $0x4,%esp
f01058f9:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f01058fc:	52                   	push   %edx
f01058fd:	ff 75 14             	pushl  0x14(%ebp)
f0105900:	6b c0 74             	imul   $0x74,%eax,%eax
f0105903:	8b 80 28 60 34 f0    	mov    -0xfcb9fd8(%eax),%eax
f0105909:	ff 70 60             	pushl  0x60(%eax)
f010590c:	e8 3d c3 ff ff       	call   f0101c4e <page_lookup>
		if(!page){
f0105911:	83 c4 10             	add    $0x10,%esp
f0105914:	85 c0                	test   %eax,%eax
f0105916:	0f 84 9a 00 00 00    	je     f01059b6 <syscall+0x64d>
		if((*pte & PTE_W) != (perm & PTE_W)){
f010591c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f010591f:	8b 4d 18             	mov    0x18(%ebp),%ecx
f0105922:	33 0a                	xor    (%edx),%ecx
f0105924:	f6 c1 02             	test   $0x2,%cl
f0105927:	0f 85 93 00 00 00    	jne    f01059c0 <syscall+0x657>
		if(e->env_ipc_dstva < (void *)UTOP){
f010592d:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105930:	8b 4a 6c             	mov    0x6c(%edx),%ecx
f0105933:	81 f9 ff ff bf ee    	cmp    $0xeebfffff,%ecx
f0105939:	76 42                	jbe    f010597d <syscall+0x614>
	e->env_ipc_recving = 0;
f010593b:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010593e:	c6 40 68 00          	movb   $0x0,0x68(%eax)
	e->env_ipc_from = curenv->env_id;
f0105942:	e8 53 14 00 00       	call   f0106d9a <cpunum>
f0105947:	8b 55 e0             	mov    -0x20(%ebp),%edx
f010594a:	6b c0 74             	imul   $0x74,%eax,%eax
f010594d:	8b 80 28 60 34 f0    	mov    -0xfcb9fd8(%eax),%eax
f0105953:	8b 40 48             	mov    0x48(%eax),%eax
f0105956:	89 42 74             	mov    %eax,0x74(%edx)
	e->env_ipc_value = value;
f0105959:	8b 45 10             	mov    0x10(%ebp),%eax
f010595c:	89 42 70             	mov    %eax,0x70(%edx)
	e->env_ipc_perm = perm;
f010595f:	8b 45 18             	mov    0x18(%ebp),%eax
f0105962:	89 42 78             	mov    %eax,0x78(%edx)
	e->env_status = ENV_RUNNABLE;
f0105965:	c7 42 54 02 00 00 00 	movl   $0x2,0x54(%edx)
	e->env_tf.tf_regs.reg_eax = 0;
f010596c:	c7 42 1c 00 00 00 00 	movl   $0x0,0x1c(%edx)
	return 0;
f0105973:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105978:	e9 0f fa ff ff       	jmp    f010538c <syscall+0x23>
			ret = page_insert(e->env_pgdir, page, e->env_ipc_dstva, perm);
f010597d:	ff 75 18             	pushl  0x18(%ebp)
f0105980:	51                   	push   %ecx
f0105981:	50                   	push   %eax
f0105982:	ff 72 60             	pushl  0x60(%edx)
f0105985:	e8 e8 c3 ff ff       	call   f0101d72 <page_insert>
f010598a:	89 c3                	mov    %eax,%ebx
			if(ret < 0){
f010598c:	83 c4 10             	add    $0x10,%esp
f010598f:	85 c0                	test   %eax,%eax
f0105991:	79 a8                	jns    f010593b <syscall+0x5d2>
f0105993:	e9 f4 f9 ff ff       	jmp    f010538c <syscall+0x23>
		return -E_IPC_NOT_RECV;
f0105998:	bb f9 ff ff ff       	mov    $0xfffffff9,%ebx
f010599d:	e9 ea f9 ff ff       	jmp    f010538c <syscall+0x23>
      		return -E_INVAL;
f01059a2:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01059a7:	e9 e0 f9 ff ff       	jmp    f010538c <syscall+0x23>
			return -E_INVAL;
f01059ac:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01059b1:	e9 d6 f9 ff ff       	jmp    f010538c <syscall+0x23>
			return -E_INVAL;
f01059b6:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01059bb:	e9 cc f9 ff ff       	jmp    f010538c <syscall+0x23>
			return -E_INVAL;
f01059c0:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
			return sys_ipc_try_send((envid_t)a1, (uint32_t)a2, (void *)a3, (unsigned)a4);
f01059c5:	e9 c2 f9 ff ff       	jmp    f010538c <syscall+0x23>
	if((uintptr_t)dstva < UTOP && PGOFF(dstva)){
f01059ca:	81 7d 0c ff ff bf ee 	cmpl   $0xeebfffff,0xc(%ebp)
f01059d1:	77 13                	ja     f01059e6 <syscall+0x67d>
f01059d3:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
f01059da:	74 0a                	je     f01059e6 <syscall+0x67d>
			return sys_ipc_recv((void *)a1);
f01059dc:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01059e1:	e9 a6 f9 ff ff       	jmp    f010538c <syscall+0x23>
	curenv->env_ipc_recving = 1;
f01059e6:	e8 af 13 00 00       	call   f0106d9a <cpunum>
f01059eb:	6b c0 74             	imul   $0x74,%eax,%eax
f01059ee:	8b 80 28 60 34 f0    	mov    -0xfcb9fd8(%eax),%eax
f01059f4:	c6 40 68 01          	movb   $0x1,0x68(%eax)
	curenv->env_ipc_dstva = dstva;
f01059f8:	e8 9d 13 00 00       	call   f0106d9a <cpunum>
f01059fd:	6b c0 74             	imul   $0x74,%eax,%eax
f0105a00:	8b 80 28 60 34 f0    	mov    -0xfcb9fd8(%eax),%eax
f0105a06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105a09:	89 48 6c             	mov    %ecx,0x6c(%eax)
	curenv->env_status = ENV_NOT_RUNNABLE;
f0105a0c:	e8 89 13 00 00       	call   f0106d9a <cpunum>
f0105a11:	6b c0 74             	imul   $0x74,%eax,%eax
f0105a14:	8b 80 28 60 34 f0    	mov    -0xfcb9fd8(%eax),%eax
f0105a1a:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	sched_yield();
f0105a21:	e8 7b f8 ff ff       	call   f01052a1 <sched_yield>
        if ((ret = envid2env(envid, &env, 1)) < 0)
f0105a26:	83 ec 04             	sub    $0x4,%esp
f0105a29:	6a 01                	push   $0x1
f0105a2b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105a2e:	50                   	push   %eax
f0105a2f:	ff 75 0c             	pushl  0xc(%ebp)
f0105a32:	e8 6e e1 ff ff       	call   f0103ba5 <envid2env>
f0105a37:	89 c3                	mov    %eax,%ebx
f0105a39:	83 c4 10             	add    $0x10,%esp
f0105a3c:	85 c0                	test   %eax,%eax
f0105a3e:	0f 88 48 f9 ff ff    	js     f010538c <syscall+0x23>
        env->env_priority = priority;
f0105a44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105a47:	8b 7d 10             	mov    0x10(%ebp),%edi
f0105a4a:	89 b8 80 00 00 00    	mov    %edi,0x80(%eax)
        return 0;
f0105a50:	bb 00 00 00 00       	mov    $0x0,%ebx
			return sys_env_set_priority((envid_t)a1, a2);
f0105a55:	e9 32 f9 ff ff       	jmp    f010538c <syscall+0x23>
			return -E_INVAL;
f0105a5a:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105a5f:	e9 28 f9 ff ff       	jmp    f010538c <syscall+0x23>
        return E_INVAL;
f0105a64:	bb 03 00 00 00       	mov    $0x3,%ebx
f0105a69:	e9 1e f9 ff ff       	jmp    f010538c <syscall+0x23>

f0105a6e <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f0105a6e:	55                   	push   %ebp
f0105a6f:	89 e5                	mov    %esp,%ebp
f0105a71:	57                   	push   %edi
f0105a72:	56                   	push   %esi
f0105a73:	53                   	push   %ebx
f0105a74:	83 ec 14             	sub    $0x14,%esp
f0105a77:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0105a7a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0105a7d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0105a80:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f0105a83:	8b 1a                	mov    (%edx),%ebx
f0105a85:	8b 01                	mov    (%ecx),%eax
f0105a87:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0105a8a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
f0105a91:	eb 23                	jmp    f0105ab6 <stab_binsearch+0x48>

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
		if (m < l) {	// no match in [l, m]
			l = true_m + 1;
f0105a93:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f0105a96:	eb 1e                	jmp    f0105ab6 <stab_binsearch+0x48>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f0105a98:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0105a9b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0105a9e:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0105aa2:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0105aa5:	73 41                	jae    f0105ae8 <stab_binsearch+0x7a>
			*region_left = m;
f0105aa7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0105aaa:	89 03                	mov    %eax,(%ebx)
			l = true_m + 1;
f0105aac:	8d 5f 01             	lea    0x1(%edi),%ebx
		any_matches = 1;
f0105aaf:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	while (l <= r) {
f0105ab6:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
f0105ab9:	7f 5a                	jg     f0105b15 <stab_binsearch+0xa7>
		int true_m = (l + r) / 2, m = true_m;
f0105abb:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0105abe:	01 d8                	add    %ebx,%eax
f0105ac0:	89 c7                	mov    %eax,%edi
f0105ac2:	c1 ef 1f             	shr    $0x1f,%edi
f0105ac5:	01 c7                	add    %eax,%edi
f0105ac7:	d1 ff                	sar    %edi
f0105ac9:	8d 04 7f             	lea    (%edi,%edi,2),%eax
f0105acc:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0105acf:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f0105ad3:	89 f8                	mov    %edi,%eax
		while (m >= l && stabs[m].n_type != type)
f0105ad5:	39 c3                	cmp    %eax,%ebx
f0105ad7:	7f ba                	jg     f0105a93 <stab_binsearch+0x25>
f0105ad9:	0f b6 0a             	movzbl (%edx),%ecx
f0105adc:	83 ea 0c             	sub    $0xc,%edx
f0105adf:	39 f1                	cmp    %esi,%ecx
f0105ae1:	74 b5                	je     f0105a98 <stab_binsearch+0x2a>
			m--;
f0105ae3:	83 e8 01             	sub    $0x1,%eax
f0105ae6:	eb ed                	jmp    f0105ad5 <stab_binsearch+0x67>
		} else if (stabs[m].n_value > addr) {
f0105ae8:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0105aeb:	76 14                	jbe    f0105b01 <stab_binsearch+0x93>
			*region_right = m - 1;
f0105aed:	83 e8 01             	sub    $0x1,%eax
f0105af0:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0105af3:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0105af6:	89 07                	mov    %eax,(%edi)
		any_matches = 1;
f0105af8:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0105aff:	eb b5                	jmp    f0105ab6 <stab_binsearch+0x48>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f0105b01:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105b04:	89 07                	mov    %eax,(%edi)
			l = m;
			addr++;
f0105b06:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0105b0a:	89 c3                	mov    %eax,%ebx
		any_matches = 1;
f0105b0c:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0105b13:	eb a1                	jmp    f0105ab6 <stab_binsearch+0x48>
		}
	}

	if (!any_matches)
f0105b15:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0105b19:	75 15                	jne    f0105b30 <stab_binsearch+0xc2>
		*region_right = *region_left - 1;
f0105b1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105b1e:	8b 00                	mov    (%eax),%eax
f0105b20:	83 e8 01             	sub    $0x1,%eax
f0105b23:	8b 75 e0             	mov    -0x20(%ebp),%esi
f0105b26:	89 06                	mov    %eax,(%esi)
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f0105b28:	83 c4 14             	add    $0x14,%esp
f0105b2b:	5b                   	pop    %ebx
f0105b2c:	5e                   	pop    %esi
f0105b2d:	5f                   	pop    %edi
f0105b2e:	5d                   	pop    %ebp
f0105b2f:	c3                   	ret    
		for (l = *region_right;
f0105b30:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105b33:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f0105b35:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105b38:	8b 0f                	mov    (%edi),%ecx
f0105b3a:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0105b3d:	8b 7d ec             	mov    -0x14(%ebp),%edi
f0105b40:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
		for (l = *region_right;
f0105b44:	eb 03                	jmp    f0105b49 <stab_binsearch+0xdb>
		     l--)
f0105b46:	83 e8 01             	sub    $0x1,%eax
		for (l = *region_right;
f0105b49:	39 c1                	cmp    %eax,%ecx
f0105b4b:	7d 0a                	jge    f0105b57 <stab_binsearch+0xe9>
		     l > *region_left && stabs[l].n_type != type;
f0105b4d:	0f b6 1a             	movzbl (%edx),%ebx
f0105b50:	83 ea 0c             	sub    $0xc,%edx
f0105b53:	39 f3                	cmp    %esi,%ebx
f0105b55:	75 ef                	jne    f0105b46 <stab_binsearch+0xd8>
		*region_left = l;
f0105b57:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0105b5a:	89 06                	mov    %eax,(%esi)
}
f0105b5c:	eb ca                	jmp    f0105b28 <stab_binsearch+0xba>

f0105b5e <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0105b5e:	55                   	push   %ebp
f0105b5f:	89 e5                	mov    %esp,%ebp
f0105b61:	57                   	push   %edi
f0105b62:	56                   	push   %esi
f0105b63:	53                   	push   %ebx
f0105b64:	83 ec 4c             	sub    $0x4c,%esp
f0105b67:	8b 7d 08             	mov    0x8(%ebp),%edi
f0105b6a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0105b6d:	c7 03 74 91 10 f0    	movl   $0xf0109174,(%ebx)
	info->eip_line = 0;
f0105b73:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	info->eip_fn_name = "<unknown>";
f0105b7a:	c7 43 08 74 91 10 f0 	movl   $0xf0109174,0x8(%ebx)
	info->eip_fn_namelen = 9;
f0105b81:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
	info->eip_fn_addr = addr;
f0105b88:	89 7b 10             	mov    %edi,0x10(%ebx)
	info->eip_fn_narg = 0;
f0105b8b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0105b92:	81 ff ff ff 7f ef    	cmp    $0xef7fffff,%edi
f0105b98:	0f 86 22 01 00 00    	jbe    f0105cc0 <debuginfo_eip+0x162>
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
		stabstr_end = __STABSTR_END__;
f0105b9e:	c7 45 b8 9b b6 11 f0 	movl   $0xf011b69b,-0x48(%ebp)
		stabstr = __STABSTR_BEGIN__;
f0105ba5:	c7 45 b4 cd 7b 11 f0 	movl   $0xf0117bcd,-0x4c(%ebp)
		stab_end = __STAB_END__;
f0105bac:	be cc 7b 11 f0       	mov    $0xf0117bcc,%esi
		stabs = __STAB_BEGIN__;
f0105bb1:	c7 45 bc 90 97 10 f0 	movl   $0xf0109790,-0x44(%ebp)
		if(user_mem_check(curenv, stabstr, stabstr_end-stabstr, PTE_U) < 0)
			return -1;
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0105bb8:	8b 4d b8             	mov    -0x48(%ebp),%ecx
f0105bbb:	39 4d b4             	cmp    %ecx,-0x4c(%ebp)
f0105bbe:	0f 83 61 02 00 00    	jae    f0105e25 <debuginfo_eip+0x2c7>
f0105bc4:	80 79 ff 00          	cmpb   $0x0,-0x1(%ecx)
f0105bc8:	0f 85 5e 02 00 00    	jne    f0105e2c <debuginfo_eip+0x2ce>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f0105bce:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f0105bd5:	2b 75 bc             	sub    -0x44(%ebp),%esi
f0105bd8:	c1 fe 02             	sar    $0x2,%esi
f0105bdb:	69 c6 ab aa aa aa    	imul   $0xaaaaaaab,%esi,%eax
f0105be1:	83 e8 01             	sub    $0x1,%eax
f0105be4:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0105be7:	83 ec 08             	sub    $0x8,%esp
f0105bea:	57                   	push   %edi
f0105beb:	6a 64                	push   $0x64
f0105bed:	8d 55 e0             	lea    -0x20(%ebp),%edx
f0105bf0:	89 d1                	mov    %edx,%ecx
f0105bf2:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0105bf5:	8b 75 bc             	mov    -0x44(%ebp),%esi
f0105bf8:	89 f0                	mov    %esi,%eax
f0105bfa:	e8 6f fe ff ff       	call   f0105a6e <stab_binsearch>
	if (lfile == 0)
f0105bff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105c02:	83 c4 10             	add    $0x10,%esp
f0105c05:	85 c0                	test   %eax,%eax
f0105c07:	0f 84 26 02 00 00    	je     f0105e33 <debuginfo_eip+0x2d5>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0105c0d:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f0105c10:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105c13:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0105c16:	83 ec 08             	sub    $0x8,%esp
f0105c19:	57                   	push   %edi
f0105c1a:	6a 24                	push   $0x24
f0105c1c:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0105c1f:	89 d1                	mov    %edx,%ecx
f0105c21:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0105c24:	89 f0                	mov    %esi,%eax
f0105c26:	e8 43 fe ff ff       	call   f0105a6e <stab_binsearch>

	if (lfun <= rfun) {
f0105c2b:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0105c2e:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0105c31:	83 c4 10             	add    $0x10,%esp
f0105c34:	39 d0                	cmp    %edx,%eax
f0105c36:	0f 8f 31 01 00 00    	jg     f0105d6d <debuginfo_eip+0x20f>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0105c3c:	8d 0c 40             	lea    (%eax,%eax,2),%ecx
f0105c3f:	8d 34 8e             	lea    (%esi,%ecx,4),%esi
f0105c42:	89 75 c4             	mov    %esi,-0x3c(%ebp)
f0105c45:	8b 36                	mov    (%esi),%esi
f0105c47:	8b 4d b8             	mov    -0x48(%ebp),%ecx
f0105c4a:	2b 4d b4             	sub    -0x4c(%ebp),%ecx
f0105c4d:	39 ce                	cmp    %ecx,%esi
f0105c4f:	73 06                	jae    f0105c57 <debuginfo_eip+0xf9>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0105c51:	03 75 b4             	add    -0x4c(%ebp),%esi
f0105c54:	89 73 08             	mov    %esi,0x8(%ebx)
		info->eip_fn_addr = stabs[lfun].n_value;
f0105c57:	8b 75 c4             	mov    -0x3c(%ebp),%esi
f0105c5a:	8b 4e 08             	mov    0x8(%esi),%ecx
f0105c5d:	89 4b 10             	mov    %ecx,0x10(%ebx)
		addr -= info->eip_fn_addr;
f0105c60:	29 cf                	sub    %ecx,%edi
		// Search within the function definition for the line number.
		lline = lfun;
f0105c62:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f0105c65:	89 55 d0             	mov    %edx,-0x30(%ebp)
		info->eip_fn_addr = addr;
		lline = lfile;
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0105c68:	83 ec 08             	sub    $0x8,%esp
f0105c6b:	6a 3a                	push   $0x3a
f0105c6d:	ff 73 08             	pushl  0x8(%ebx)
f0105c70:	e8 03 0b 00 00       	call   f0106778 <strfind>
f0105c75:	2b 43 08             	sub    0x8(%ebx),%eax
f0105c78:	89 43 0c             	mov    %eax,0xc(%ebx)
	uint8_t n_other;        // misc info (usually empty)
	uint16_t n_desc;        // description field
	uintptr_t n_value;	// value of symbol
};
*/
	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f0105c7b:	83 c4 08             	add    $0x8,%esp
f0105c7e:	57                   	push   %edi
f0105c7f:	6a 44                	push   $0x44
f0105c81:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0105c84:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0105c87:	8b 75 bc             	mov    -0x44(%ebp),%esi
f0105c8a:	89 f0                	mov    %esi,%eax
f0105c8c:	e8 dd fd ff ff       	call   f0105a6e <stab_binsearch>
	// set eip number
	if (lline <= rline)
f0105c91:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0105c94:	83 c4 10             	add    $0x10,%esp
f0105c97:	3b 55 d0             	cmp    -0x30(%ebp),%edx
f0105c9a:	0f 8f 9a 01 00 00    	jg     f0105e3a <debuginfo_eip+0x2dc>
		info->eip_line = stabs[lline].n_desc;
f0105ca0:	89 d0                	mov    %edx,%eax
f0105ca2:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0105ca5:	c1 e2 02             	shl    $0x2,%edx
f0105ca8:	0f b7 4c 16 06       	movzwl 0x6(%esi,%edx,1),%ecx
f0105cad:	89 4b 04             	mov    %ecx,0x4(%ebx)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0105cb0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105cb3:	8d 54 16 04          	lea    0x4(%esi,%edx,1),%edx
f0105cb7:	c6 45 c4 00          	movb   $0x0,-0x3c(%ebp)
f0105cbb:	e9 cb 00 00 00       	jmp    f0105d8b <debuginfo_eip+0x22d>
		if(user_mem_check(curenv, usd, sizeof(*usd), PTE_U) < 0)
f0105cc0:	e8 d5 10 00 00       	call   f0106d9a <cpunum>
f0105cc5:	6a 04                	push   $0x4
f0105cc7:	6a 10                	push   $0x10
f0105cc9:	68 00 00 20 00       	push   $0x200000
f0105cce:	6b c0 74             	imul   $0x74,%eax,%eax
f0105cd1:	ff b0 28 60 34 f0    	pushl  -0xfcb9fd8(%eax)
f0105cd7:	e8 ee dd ff ff       	call   f0103aca <user_mem_check>
f0105cdc:	83 c4 10             	add    $0x10,%esp
f0105cdf:	85 c0                	test   %eax,%eax
f0105ce1:	0f 88 30 01 00 00    	js     f0105e17 <debuginfo_eip+0x2b9>
		stabs = usd->stabs;
f0105ce7:	8b 0d 00 00 20 00    	mov    0x200000,%ecx
f0105ced:	89 4d bc             	mov    %ecx,-0x44(%ebp)
		stab_end = usd->stab_end;
f0105cf0:	8b 35 04 00 20 00    	mov    0x200004,%esi
		stabstr = usd->stabstr;
f0105cf6:	a1 08 00 20 00       	mov    0x200008,%eax
f0105cfb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		stabstr_end = usd->stabstr_end;
f0105cfe:	8b 15 0c 00 20 00    	mov    0x20000c,%edx
f0105d04:	89 55 b8             	mov    %edx,-0x48(%ebp)
		if(user_mem_check(curenv, stabs, stab_end - stabs, PTE_U) < 0)
f0105d07:	e8 8e 10 00 00       	call   f0106d9a <cpunum>
f0105d0c:	6a 04                	push   $0x4
f0105d0e:	89 f2                	mov    %esi,%edx
f0105d10:	8b 4d bc             	mov    -0x44(%ebp),%ecx
f0105d13:	29 ca                	sub    %ecx,%edx
f0105d15:	c1 fa 02             	sar    $0x2,%edx
f0105d18:	69 d2 ab aa aa aa    	imul   $0xaaaaaaab,%edx,%edx
f0105d1e:	52                   	push   %edx
f0105d1f:	51                   	push   %ecx
f0105d20:	6b c0 74             	imul   $0x74,%eax,%eax
f0105d23:	ff b0 28 60 34 f0    	pushl  -0xfcb9fd8(%eax)
f0105d29:	e8 9c dd ff ff       	call   f0103aca <user_mem_check>
f0105d2e:	83 c4 10             	add    $0x10,%esp
f0105d31:	85 c0                	test   %eax,%eax
f0105d33:	0f 88 e5 00 00 00    	js     f0105e1e <debuginfo_eip+0x2c0>
		if(user_mem_check(curenv, stabstr, stabstr_end-stabstr, PTE_U) < 0)
f0105d39:	e8 5c 10 00 00       	call   f0106d9a <cpunum>
f0105d3e:	6a 04                	push   $0x4
f0105d40:	8b 55 b8             	mov    -0x48(%ebp),%edx
f0105d43:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
f0105d46:	29 ca                	sub    %ecx,%edx
f0105d48:	52                   	push   %edx
f0105d49:	51                   	push   %ecx
f0105d4a:	6b c0 74             	imul   $0x74,%eax,%eax
f0105d4d:	ff b0 28 60 34 f0    	pushl  -0xfcb9fd8(%eax)
f0105d53:	e8 72 dd ff ff       	call   f0103aca <user_mem_check>
f0105d58:	83 c4 10             	add    $0x10,%esp
f0105d5b:	85 c0                	test   %eax,%eax
f0105d5d:	0f 89 55 fe ff ff    	jns    f0105bb8 <debuginfo_eip+0x5a>
			return -1;
f0105d63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105d68:	e9 d9 00 00 00       	jmp    f0105e46 <debuginfo_eip+0x2e8>
		info->eip_fn_addr = addr;
f0105d6d:	89 7b 10             	mov    %edi,0x10(%ebx)
		lline = lfile;
f0105d70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105d73:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f0105d76:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105d79:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0105d7c:	e9 e7 fe ff ff       	jmp    f0105c68 <debuginfo_eip+0x10a>
f0105d81:	83 e8 01             	sub    $0x1,%eax
f0105d84:	83 ea 0c             	sub    $0xc,%edx
f0105d87:	c6 45 c4 01          	movb   $0x1,-0x3c(%ebp)
f0105d8b:	89 45 c0             	mov    %eax,-0x40(%ebp)
	while (lline >= lfile
f0105d8e:	39 c7                	cmp    %eax,%edi
f0105d90:	7f 45                	jg     f0105dd7 <debuginfo_eip+0x279>
	       && stabs[lline].n_type != N_SOL
f0105d92:	0f b6 0a             	movzbl (%edx),%ecx
f0105d95:	80 f9 84             	cmp    $0x84,%cl
f0105d98:	74 19                	je     f0105db3 <debuginfo_eip+0x255>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0105d9a:	80 f9 64             	cmp    $0x64,%cl
f0105d9d:	75 e2                	jne    f0105d81 <debuginfo_eip+0x223>
f0105d9f:	83 7a 04 00          	cmpl   $0x0,0x4(%edx)
f0105da3:	74 dc                	je     f0105d81 <debuginfo_eip+0x223>
f0105da5:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0105da9:	74 11                	je     f0105dbc <debuginfo_eip+0x25e>
f0105dab:	8b 7d c0             	mov    -0x40(%ebp),%edi
f0105dae:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f0105db1:	eb 09                	jmp    f0105dbc <debuginfo_eip+0x25e>
f0105db3:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0105db7:	74 03                	je     f0105dbc <debuginfo_eip+0x25e>
f0105db9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0105dbc:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0105dbf:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0105dc2:	8b 14 87             	mov    (%edi,%eax,4),%edx
f0105dc5:	8b 45 b8             	mov    -0x48(%ebp),%eax
f0105dc8:	8b 7d b4             	mov    -0x4c(%ebp),%edi
f0105dcb:	29 f8                	sub    %edi,%eax
f0105dcd:	39 c2                	cmp    %eax,%edx
f0105dcf:	73 06                	jae    f0105dd7 <debuginfo_eip+0x279>
		info->eip_file = stabstr + stabs[lline].n_strx;
f0105dd1:	89 f8                	mov    %edi,%eax
f0105dd3:	01 d0                	add    %edx,%eax
f0105dd5:	89 03                	mov    %eax,(%ebx)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0105dd7:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0105dda:	8b 75 d8             	mov    -0x28(%ebp),%esi
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f0105ddd:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lfun < rfun)
f0105de2:	39 f2                	cmp    %esi,%edx
f0105de4:	7d 60                	jge    f0105e46 <debuginfo_eip+0x2e8>
		for (lline = lfun + 1;
f0105de6:	83 c2 01             	add    $0x1,%edx
f0105de9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0105dec:	89 d0                	mov    %edx,%eax
f0105dee:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0105df1:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0105df4:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
f0105df8:	eb 04                	jmp    f0105dfe <debuginfo_eip+0x2a0>
			info->eip_fn_narg++;
f0105dfa:	83 43 14 01          	addl   $0x1,0x14(%ebx)
		for (lline = lfun + 1;
f0105dfe:	39 c6                	cmp    %eax,%esi
f0105e00:	7e 3f                	jle    f0105e41 <debuginfo_eip+0x2e3>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0105e02:	0f b6 0a             	movzbl (%edx),%ecx
f0105e05:	83 c0 01             	add    $0x1,%eax
f0105e08:	83 c2 0c             	add    $0xc,%edx
f0105e0b:	80 f9 a0             	cmp    $0xa0,%cl
f0105e0e:	74 ea                	je     f0105dfa <debuginfo_eip+0x29c>
	return 0;
f0105e10:	b8 00 00 00 00       	mov    $0x0,%eax
f0105e15:	eb 2f                	jmp    f0105e46 <debuginfo_eip+0x2e8>
			return -1;
f0105e17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105e1c:	eb 28                	jmp    f0105e46 <debuginfo_eip+0x2e8>
			return -1;
f0105e1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105e23:	eb 21                	jmp    f0105e46 <debuginfo_eip+0x2e8>
		return -1;
f0105e25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105e2a:	eb 1a                	jmp    f0105e46 <debuginfo_eip+0x2e8>
f0105e2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105e31:	eb 13                	jmp    f0105e46 <debuginfo_eip+0x2e8>
		return -1;
f0105e33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105e38:	eb 0c                	jmp    f0105e46 <debuginfo_eip+0x2e8>
		return -1;
f0105e3a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105e3f:	eb 05                	jmp    f0105e46 <debuginfo_eip+0x2e8>
	return 0;
f0105e41:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105e46:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105e49:	5b                   	pop    %ebx
f0105e4a:	5e                   	pop    %esi
f0105e4b:	5f                   	pop    %edi
f0105e4c:	5d                   	pop    %ebp
f0105e4d:	c3                   	ret    

f0105e4e <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0105e4e:	55                   	push   %ebp
f0105e4f:	89 e5                	mov    %esp,%ebp
f0105e51:	57                   	push   %edi
f0105e52:	56                   	push   %esi
f0105e53:	53                   	push   %ebx
f0105e54:	83 ec 1c             	sub    $0x1c,%esp
f0105e57:	89 c6                	mov    %eax,%esi
f0105e59:	89 d7                	mov    %edx,%edi
f0105e5b:	8b 45 08             	mov    0x8(%ebp),%eax
f0105e5e:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105e61:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105e64:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0105e67:	8b 45 10             	mov    0x10(%ebp),%eax
f0105e6a:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
f0105e6d:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
f0105e71:	74 2c                	je     f0105e9f <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f0105e73:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105e76:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
f0105e7d:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105e80:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0105e83:	39 c2                	cmp    %eax,%edx
f0105e85:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
f0105e88:	73 43                	jae    f0105ecd <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
f0105e8a:	83 eb 01             	sub    $0x1,%ebx
f0105e8d:	85 db                	test   %ebx,%ebx
f0105e8f:	7e 6c                	jle    f0105efd <printnum+0xaf>
			putch(padc, putdat);
f0105e91:	83 ec 08             	sub    $0x8,%esp
f0105e94:	57                   	push   %edi
f0105e95:	ff 75 18             	pushl  0x18(%ebp)
f0105e98:	ff d6                	call   *%esi
f0105e9a:	83 c4 10             	add    $0x10,%esp
f0105e9d:	eb eb                	jmp    f0105e8a <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
f0105e9f:	83 ec 0c             	sub    $0xc,%esp
f0105ea2:	6a 20                	push   $0x20
f0105ea4:	6a 00                	push   $0x0
f0105ea6:	50                   	push   %eax
f0105ea7:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105eaa:	ff 75 e0             	pushl  -0x20(%ebp)
f0105ead:	89 fa                	mov    %edi,%edx
f0105eaf:	89 f0                	mov    %esi,%eax
f0105eb1:	e8 98 ff ff ff       	call   f0105e4e <printnum>
		while (--width > 0)
f0105eb6:	83 c4 20             	add    $0x20,%esp
f0105eb9:	83 eb 01             	sub    $0x1,%ebx
f0105ebc:	85 db                	test   %ebx,%ebx
f0105ebe:	7e 65                	jle    f0105f25 <printnum+0xd7>
			putch(' ', putdat);
f0105ec0:	83 ec 08             	sub    $0x8,%esp
f0105ec3:	57                   	push   %edi
f0105ec4:	6a 20                	push   $0x20
f0105ec6:	ff d6                	call   *%esi
f0105ec8:	83 c4 10             	add    $0x10,%esp
f0105ecb:	eb ec                	jmp    f0105eb9 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f0105ecd:	83 ec 0c             	sub    $0xc,%esp
f0105ed0:	ff 75 18             	pushl  0x18(%ebp)
f0105ed3:	83 eb 01             	sub    $0x1,%ebx
f0105ed6:	53                   	push   %ebx
f0105ed7:	50                   	push   %eax
f0105ed8:	83 ec 08             	sub    $0x8,%esp
f0105edb:	ff 75 dc             	pushl  -0x24(%ebp)
f0105ede:	ff 75 d8             	pushl  -0x28(%ebp)
f0105ee1:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105ee4:	ff 75 e0             	pushl  -0x20(%ebp)
f0105ee7:	e8 a4 12 00 00       	call   f0107190 <__udivdi3>
f0105eec:	83 c4 18             	add    $0x18,%esp
f0105eef:	52                   	push   %edx
f0105ef0:	50                   	push   %eax
f0105ef1:	89 fa                	mov    %edi,%edx
f0105ef3:	89 f0                	mov    %esi,%eax
f0105ef5:	e8 54 ff ff ff       	call   f0105e4e <printnum>
f0105efa:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f0105efd:	83 ec 08             	sub    $0x8,%esp
f0105f00:	57                   	push   %edi
f0105f01:	83 ec 04             	sub    $0x4,%esp
f0105f04:	ff 75 dc             	pushl  -0x24(%ebp)
f0105f07:	ff 75 d8             	pushl  -0x28(%ebp)
f0105f0a:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105f0d:	ff 75 e0             	pushl  -0x20(%ebp)
f0105f10:	e8 8b 13 00 00       	call   f01072a0 <__umoddi3>
f0105f15:	83 c4 14             	add    $0x14,%esp
f0105f18:	0f be 80 7e 91 10 f0 	movsbl -0xfef6e82(%eax),%eax
f0105f1f:	50                   	push   %eax
f0105f20:	ff d6                	call   *%esi
f0105f22:	83 c4 10             	add    $0x10,%esp
}
f0105f25:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105f28:	5b                   	pop    %ebx
f0105f29:	5e                   	pop    %esi
f0105f2a:	5f                   	pop    %edi
f0105f2b:	5d                   	pop    %ebp
f0105f2c:	c3                   	ret    

f0105f2d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0105f2d:	55                   	push   %ebp
f0105f2e:	89 e5                	mov    %esp,%ebp
f0105f30:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f0105f33:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0105f37:	8b 10                	mov    (%eax),%edx
f0105f39:	3b 50 04             	cmp    0x4(%eax),%edx
f0105f3c:	73 0a                	jae    f0105f48 <sprintputch+0x1b>
		*b->buf++ = ch;
f0105f3e:	8d 4a 01             	lea    0x1(%edx),%ecx
f0105f41:	89 08                	mov    %ecx,(%eax)
f0105f43:	8b 45 08             	mov    0x8(%ebp),%eax
f0105f46:	88 02                	mov    %al,(%edx)
}
f0105f48:	5d                   	pop    %ebp
f0105f49:	c3                   	ret    

f0105f4a <printfmt>:
{
f0105f4a:	55                   	push   %ebp
f0105f4b:	89 e5                	mov    %esp,%ebp
f0105f4d:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f0105f50:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f0105f53:	50                   	push   %eax
f0105f54:	ff 75 10             	pushl  0x10(%ebp)
f0105f57:	ff 75 0c             	pushl  0xc(%ebp)
f0105f5a:	ff 75 08             	pushl  0x8(%ebp)
f0105f5d:	e8 05 00 00 00       	call   f0105f67 <vprintfmt>
}
f0105f62:	83 c4 10             	add    $0x10,%esp
f0105f65:	c9                   	leave  
f0105f66:	c3                   	ret    

f0105f67 <vprintfmt>:
{
f0105f67:	55                   	push   %ebp
f0105f68:	89 e5                	mov    %esp,%ebp
f0105f6a:	57                   	push   %edi
f0105f6b:	56                   	push   %esi
f0105f6c:	53                   	push   %ebx
f0105f6d:	83 ec 3c             	sub    $0x3c,%esp
f0105f70:	8b 75 08             	mov    0x8(%ebp),%esi
f0105f73:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0105f76:	8b 7d 10             	mov    0x10(%ebp),%edi
f0105f79:	e9 1e 04 00 00       	jmp    f010639c <vprintfmt+0x435>
		posflag = 0;
f0105f7e:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
f0105f85:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
f0105f89:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
f0105f90:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
f0105f97:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
f0105f9e:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
f0105fa5:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f0105faa:	8d 47 01             	lea    0x1(%edi),%eax
f0105fad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105fb0:	0f b6 17             	movzbl (%edi),%edx
f0105fb3:	8d 42 dd             	lea    -0x23(%edx),%eax
f0105fb6:	3c 55                	cmp    $0x55,%al
f0105fb8:	0f 87 d9 04 00 00    	ja     f0106497 <vprintfmt+0x530>
f0105fbe:	0f b6 c0             	movzbl %al,%eax
f0105fc1:	ff 24 85 60 93 10 f0 	jmp    *-0xfef6ca0(,%eax,4)
f0105fc8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
f0105fcb:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
f0105fcf:	eb d9                	jmp    f0105faa <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
f0105fd1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
f0105fd4:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
f0105fdb:	eb cd                	jmp    f0105faa <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
f0105fdd:	0f b6 d2             	movzbl %dl,%edx
f0105fe0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
f0105fe3:	b8 00 00 00 00       	mov    $0x0,%eax
f0105fe8:	89 75 08             	mov    %esi,0x8(%ebp)
f0105feb:	eb 0c                	jmp    f0105ff9 <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
f0105fed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
f0105ff0:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
f0105ff4:	eb b4                	jmp    f0105faa <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
f0105ff6:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
f0105ff9:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0105ffc:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f0106000:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
f0106003:	8d 72 d0             	lea    -0x30(%edx),%esi
f0106006:	83 fe 09             	cmp    $0x9,%esi
f0106009:	76 eb                	jbe    f0105ff6 <vprintfmt+0x8f>
f010600b:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010600e:	8b 75 08             	mov    0x8(%ebp),%esi
f0106011:	eb 14                	jmp    f0106027 <vprintfmt+0xc0>
			precision = va_arg(ap, int);
f0106013:	8b 45 14             	mov    0x14(%ebp),%eax
f0106016:	8b 00                	mov    (%eax),%eax
f0106018:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010601b:	8b 45 14             	mov    0x14(%ebp),%eax
f010601e:	8d 40 04             	lea    0x4(%eax),%eax
f0106021:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0106024:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
f0106027:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f010602b:	0f 89 79 ff ff ff    	jns    f0105faa <vprintfmt+0x43>
				width = precision, precision = -1;
f0106031:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0106034:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0106037:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
f010603e:	e9 67 ff ff ff       	jmp    f0105faa <vprintfmt+0x43>
f0106043:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0106046:	85 c0                	test   %eax,%eax
f0106048:	0f 48 c1             	cmovs  %ecx,%eax
f010604b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f010604e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0106051:	e9 54 ff ff ff       	jmp    f0105faa <vprintfmt+0x43>
f0106056:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
f0106059:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
f0106060:	e9 45 ff ff ff       	jmp    f0105faa <vprintfmt+0x43>
			lflag++;
f0106065:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0106069:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f010606c:	e9 39 ff ff ff       	jmp    f0105faa <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
f0106071:	8b 45 14             	mov    0x14(%ebp),%eax
f0106074:	8d 78 04             	lea    0x4(%eax),%edi
f0106077:	83 ec 08             	sub    $0x8,%esp
f010607a:	53                   	push   %ebx
f010607b:	ff 30                	pushl  (%eax)
f010607d:	ff d6                	call   *%esi
			break;
f010607f:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f0106082:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
f0106085:	e9 0f 03 00 00       	jmp    f0106399 <vprintfmt+0x432>
			err = va_arg(ap, int);
f010608a:	8b 45 14             	mov    0x14(%ebp),%eax
f010608d:	8d 78 04             	lea    0x4(%eax),%edi
f0106090:	8b 00                	mov    (%eax),%eax
f0106092:	99                   	cltd   
f0106093:	31 d0                	xor    %edx,%eax
f0106095:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f0106097:	83 f8 0f             	cmp    $0xf,%eax
f010609a:	7f 23                	jg     f01060bf <vprintfmt+0x158>
f010609c:	8b 14 85 c0 94 10 f0 	mov    -0xfef6b40(,%eax,4),%edx
f01060a3:	85 d2                	test   %edx,%edx
f01060a5:	74 18                	je     f01060bf <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
f01060a7:	52                   	push   %edx
f01060a8:	68 b4 87 10 f0       	push   $0xf01087b4
f01060ad:	53                   	push   %ebx
f01060ae:	56                   	push   %esi
f01060af:	e8 96 fe ff ff       	call   f0105f4a <printfmt>
f01060b4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f01060b7:	89 7d 14             	mov    %edi,0x14(%ebp)
f01060ba:	e9 da 02 00 00       	jmp    f0106399 <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
f01060bf:	50                   	push   %eax
f01060c0:	68 96 91 10 f0       	push   $0xf0109196
f01060c5:	53                   	push   %ebx
f01060c6:	56                   	push   %esi
f01060c7:	e8 7e fe ff ff       	call   f0105f4a <printfmt>
f01060cc:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f01060cf:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f01060d2:	e9 c2 02 00 00       	jmp    f0106399 <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
f01060d7:	8b 45 14             	mov    0x14(%ebp),%eax
f01060da:	83 c0 04             	add    $0x4,%eax
f01060dd:	89 45 c8             	mov    %eax,-0x38(%ebp)
f01060e0:	8b 45 14             	mov    0x14(%ebp),%eax
f01060e3:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
f01060e5:	85 c9                	test   %ecx,%ecx
f01060e7:	b8 8f 91 10 f0       	mov    $0xf010918f,%eax
f01060ec:	0f 45 c1             	cmovne %ecx,%eax
f01060ef:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
f01060f2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f01060f6:	7e 06                	jle    f01060fe <vprintfmt+0x197>
f01060f8:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
f01060fc:	75 0d                	jne    f010610b <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
f01060fe:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0106101:	89 c7                	mov    %eax,%edi
f0106103:	03 45 e0             	add    -0x20(%ebp),%eax
f0106106:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0106109:	eb 53                	jmp    f010615e <vprintfmt+0x1f7>
f010610b:	83 ec 08             	sub    $0x8,%esp
f010610e:	ff 75 d8             	pushl  -0x28(%ebp)
f0106111:	50                   	push   %eax
f0106112:	e8 16 05 00 00       	call   f010662d <strnlen>
f0106117:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f010611a:	29 c1                	sub    %eax,%ecx
f010611c:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
f010611f:	83 c4 10             	add    $0x10,%esp
f0106122:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
f0106124:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
f0106128:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
f010612b:	eb 0f                	jmp    f010613c <vprintfmt+0x1d5>
					putch(padc, putdat);
f010612d:	83 ec 08             	sub    $0x8,%esp
f0106130:	53                   	push   %ebx
f0106131:	ff 75 e0             	pushl  -0x20(%ebp)
f0106134:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
f0106136:	83 ef 01             	sub    $0x1,%edi
f0106139:	83 c4 10             	add    $0x10,%esp
f010613c:	85 ff                	test   %edi,%edi
f010613e:	7f ed                	jg     f010612d <vprintfmt+0x1c6>
f0106140:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f0106143:	85 c9                	test   %ecx,%ecx
f0106145:	b8 00 00 00 00       	mov    $0x0,%eax
f010614a:	0f 49 c1             	cmovns %ecx,%eax
f010614d:	29 c1                	sub    %eax,%ecx
f010614f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0106152:	eb aa                	jmp    f01060fe <vprintfmt+0x197>
					putch(ch, putdat);
f0106154:	83 ec 08             	sub    $0x8,%esp
f0106157:	53                   	push   %ebx
f0106158:	52                   	push   %edx
f0106159:	ff d6                	call   *%esi
f010615b:	83 c4 10             	add    $0x10,%esp
f010615e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0106161:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0106163:	83 c7 01             	add    $0x1,%edi
f0106166:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f010616a:	0f be d0             	movsbl %al,%edx
f010616d:	85 d2                	test   %edx,%edx
f010616f:	74 4b                	je     f01061bc <vprintfmt+0x255>
f0106171:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0106175:	78 06                	js     f010617d <vprintfmt+0x216>
f0106177:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
f010617b:	78 1e                	js     f010619b <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
f010617d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0106181:	74 d1                	je     f0106154 <vprintfmt+0x1ed>
f0106183:	0f be c0             	movsbl %al,%eax
f0106186:	83 e8 20             	sub    $0x20,%eax
f0106189:	83 f8 5e             	cmp    $0x5e,%eax
f010618c:	76 c6                	jbe    f0106154 <vprintfmt+0x1ed>
					putch('?', putdat);
f010618e:	83 ec 08             	sub    $0x8,%esp
f0106191:	53                   	push   %ebx
f0106192:	6a 3f                	push   $0x3f
f0106194:	ff d6                	call   *%esi
f0106196:	83 c4 10             	add    $0x10,%esp
f0106199:	eb c3                	jmp    f010615e <vprintfmt+0x1f7>
f010619b:	89 cf                	mov    %ecx,%edi
f010619d:	eb 0e                	jmp    f01061ad <vprintfmt+0x246>
				putch(' ', putdat);
f010619f:	83 ec 08             	sub    $0x8,%esp
f01061a2:	53                   	push   %ebx
f01061a3:	6a 20                	push   $0x20
f01061a5:	ff d6                	call   *%esi
			for (; width > 0; width--)
f01061a7:	83 ef 01             	sub    $0x1,%edi
f01061aa:	83 c4 10             	add    $0x10,%esp
f01061ad:	85 ff                	test   %edi,%edi
f01061af:	7f ee                	jg     f010619f <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
f01061b1:	8b 45 c8             	mov    -0x38(%ebp),%eax
f01061b4:	89 45 14             	mov    %eax,0x14(%ebp)
f01061b7:	e9 dd 01 00 00       	jmp    f0106399 <vprintfmt+0x432>
f01061bc:	89 cf                	mov    %ecx,%edi
f01061be:	eb ed                	jmp    f01061ad <vprintfmt+0x246>
	if (lflag >= 2)
f01061c0:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
f01061c4:	7f 21                	jg     f01061e7 <vprintfmt+0x280>
	else if (lflag)
f01061c6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
f01061ca:	74 6a                	je     f0106236 <vprintfmt+0x2cf>
		return va_arg(*ap, long);
f01061cc:	8b 45 14             	mov    0x14(%ebp),%eax
f01061cf:	8b 00                	mov    (%eax),%eax
f01061d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01061d4:	89 c1                	mov    %eax,%ecx
f01061d6:	c1 f9 1f             	sar    $0x1f,%ecx
f01061d9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f01061dc:	8b 45 14             	mov    0x14(%ebp),%eax
f01061df:	8d 40 04             	lea    0x4(%eax),%eax
f01061e2:	89 45 14             	mov    %eax,0x14(%ebp)
f01061e5:	eb 17                	jmp    f01061fe <vprintfmt+0x297>
		return va_arg(*ap, long long);
f01061e7:	8b 45 14             	mov    0x14(%ebp),%eax
f01061ea:	8b 50 04             	mov    0x4(%eax),%edx
f01061ed:	8b 00                	mov    (%eax),%eax
f01061ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01061f2:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01061f5:	8b 45 14             	mov    0x14(%ebp),%eax
f01061f8:	8d 40 08             	lea    0x8(%eax),%eax
f01061fb:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
f01061fe:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
f0106201:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
f0106206:	85 d2                	test   %edx,%edx
f0106208:	0f 89 5c 01 00 00    	jns    f010636a <vprintfmt+0x403>
				putch('-', putdat);
f010620e:	83 ec 08             	sub    $0x8,%esp
f0106211:	53                   	push   %ebx
f0106212:	6a 2d                	push   $0x2d
f0106214:	ff d6                	call   *%esi
				num = -(long long) num;
f0106216:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0106219:	8b 55 dc             	mov    -0x24(%ebp),%edx
f010621c:	f7 d8                	neg    %eax
f010621e:	83 d2 00             	adc    $0x0,%edx
f0106221:	f7 da                	neg    %edx
f0106223:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106226:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106229:	83 c4 10             	add    $0x10,%esp
			base = 10;
f010622c:	bf 0a 00 00 00       	mov    $0xa,%edi
f0106231:	e9 45 01 00 00       	jmp    f010637b <vprintfmt+0x414>
		return va_arg(*ap, int);
f0106236:	8b 45 14             	mov    0x14(%ebp),%eax
f0106239:	8b 00                	mov    (%eax),%eax
f010623b:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010623e:	89 c1                	mov    %eax,%ecx
f0106240:	c1 f9 1f             	sar    $0x1f,%ecx
f0106243:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0106246:	8b 45 14             	mov    0x14(%ebp),%eax
f0106249:	8d 40 04             	lea    0x4(%eax),%eax
f010624c:	89 45 14             	mov    %eax,0x14(%ebp)
f010624f:	eb ad                	jmp    f01061fe <vprintfmt+0x297>
	if (lflag >= 2)
f0106251:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
f0106255:	7f 29                	jg     f0106280 <vprintfmt+0x319>
	else if (lflag)
f0106257:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
f010625b:	74 44                	je     f01062a1 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
f010625d:	8b 45 14             	mov    0x14(%ebp),%eax
f0106260:	8b 00                	mov    (%eax),%eax
f0106262:	ba 00 00 00 00       	mov    $0x0,%edx
f0106267:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010626a:	89 55 dc             	mov    %edx,-0x24(%ebp)
f010626d:	8b 45 14             	mov    0x14(%ebp),%eax
f0106270:	8d 40 04             	lea    0x4(%eax),%eax
f0106273:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0106276:	bf 0a 00 00 00       	mov    $0xa,%edi
f010627b:	e9 ea 00 00 00       	jmp    f010636a <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
f0106280:	8b 45 14             	mov    0x14(%ebp),%eax
f0106283:	8b 50 04             	mov    0x4(%eax),%edx
f0106286:	8b 00                	mov    (%eax),%eax
f0106288:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010628b:	89 55 dc             	mov    %edx,-0x24(%ebp)
f010628e:	8b 45 14             	mov    0x14(%ebp),%eax
f0106291:	8d 40 08             	lea    0x8(%eax),%eax
f0106294:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0106297:	bf 0a 00 00 00       	mov    $0xa,%edi
f010629c:	e9 c9 00 00 00       	jmp    f010636a <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
f01062a1:	8b 45 14             	mov    0x14(%ebp),%eax
f01062a4:	8b 00                	mov    (%eax),%eax
f01062a6:	ba 00 00 00 00       	mov    $0x0,%edx
f01062ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01062ae:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01062b1:	8b 45 14             	mov    0x14(%ebp),%eax
f01062b4:	8d 40 04             	lea    0x4(%eax),%eax
f01062b7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f01062ba:	bf 0a 00 00 00       	mov    $0xa,%edi
f01062bf:	e9 a6 00 00 00       	jmp    f010636a <vprintfmt+0x403>
			putch('0', putdat);
f01062c4:	83 ec 08             	sub    $0x8,%esp
f01062c7:	53                   	push   %ebx
f01062c8:	6a 30                	push   $0x30
f01062ca:	ff d6                	call   *%esi
	if (lflag >= 2)
f01062cc:	83 c4 10             	add    $0x10,%esp
f01062cf:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
f01062d3:	7f 26                	jg     f01062fb <vprintfmt+0x394>
	else if (lflag)
f01062d5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
f01062d9:	74 3e                	je     f0106319 <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
f01062db:	8b 45 14             	mov    0x14(%ebp),%eax
f01062de:	8b 00                	mov    (%eax),%eax
f01062e0:	ba 00 00 00 00       	mov    $0x0,%edx
f01062e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01062e8:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01062eb:	8b 45 14             	mov    0x14(%ebp),%eax
f01062ee:	8d 40 04             	lea    0x4(%eax),%eax
f01062f1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f01062f4:	bf 08 00 00 00       	mov    $0x8,%edi
f01062f9:	eb 6f                	jmp    f010636a <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
f01062fb:	8b 45 14             	mov    0x14(%ebp),%eax
f01062fe:	8b 50 04             	mov    0x4(%eax),%edx
f0106301:	8b 00                	mov    (%eax),%eax
f0106303:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106306:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106309:	8b 45 14             	mov    0x14(%ebp),%eax
f010630c:	8d 40 08             	lea    0x8(%eax),%eax
f010630f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f0106312:	bf 08 00 00 00       	mov    $0x8,%edi
f0106317:	eb 51                	jmp    f010636a <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
f0106319:	8b 45 14             	mov    0x14(%ebp),%eax
f010631c:	8b 00                	mov    (%eax),%eax
f010631e:	ba 00 00 00 00       	mov    $0x0,%edx
f0106323:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106326:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106329:	8b 45 14             	mov    0x14(%ebp),%eax
f010632c:	8d 40 04             	lea    0x4(%eax),%eax
f010632f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f0106332:	bf 08 00 00 00       	mov    $0x8,%edi
f0106337:	eb 31                	jmp    f010636a <vprintfmt+0x403>
			putch('0', putdat);
f0106339:	83 ec 08             	sub    $0x8,%esp
f010633c:	53                   	push   %ebx
f010633d:	6a 30                	push   $0x30
f010633f:	ff d6                	call   *%esi
			putch('x', putdat);
f0106341:	83 c4 08             	add    $0x8,%esp
f0106344:	53                   	push   %ebx
f0106345:	6a 78                	push   $0x78
f0106347:	ff d6                	call   *%esi
			num = (unsigned long long)
f0106349:	8b 45 14             	mov    0x14(%ebp),%eax
f010634c:	8b 00                	mov    (%eax),%eax
f010634e:	ba 00 00 00 00       	mov    $0x0,%edx
f0106353:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0106356:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
f0106359:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f010635c:	8b 45 14             	mov    0x14(%ebp),%eax
f010635f:	8d 40 04             	lea    0x4(%eax),%eax
f0106362:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0106365:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
f010636a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f010636e:	74 0b                	je     f010637b <vprintfmt+0x414>
				putch('+', putdat);
f0106370:	83 ec 08             	sub    $0x8,%esp
f0106373:	53                   	push   %ebx
f0106374:	6a 2b                	push   $0x2b
f0106376:	ff d6                	call   *%esi
f0106378:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
f010637b:	83 ec 0c             	sub    $0xc,%esp
f010637e:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
f0106382:	50                   	push   %eax
f0106383:	ff 75 e0             	pushl  -0x20(%ebp)
f0106386:	57                   	push   %edi
f0106387:	ff 75 dc             	pushl  -0x24(%ebp)
f010638a:	ff 75 d8             	pushl  -0x28(%ebp)
f010638d:	89 da                	mov    %ebx,%edx
f010638f:	89 f0                	mov    %esi,%eax
f0106391:	e8 b8 fa ff ff       	call   f0105e4e <printnum>
			break;
f0106396:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
f0106399:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
f010639c:	83 c7 01             	add    $0x1,%edi
f010639f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f01063a3:	83 f8 25             	cmp    $0x25,%eax
f01063a6:	0f 84 d2 fb ff ff    	je     f0105f7e <vprintfmt+0x17>
			if (ch == '\0')
f01063ac:	85 c0                	test   %eax,%eax
f01063ae:	0f 84 03 01 00 00    	je     f01064b7 <vprintfmt+0x550>
			putch(ch, putdat);
f01063b4:	83 ec 08             	sub    $0x8,%esp
f01063b7:	53                   	push   %ebx
f01063b8:	50                   	push   %eax
f01063b9:	ff d6                	call   *%esi
f01063bb:	83 c4 10             	add    $0x10,%esp
f01063be:	eb dc                	jmp    f010639c <vprintfmt+0x435>
	if (lflag >= 2)
f01063c0:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
f01063c4:	7f 29                	jg     f01063ef <vprintfmt+0x488>
	else if (lflag)
f01063c6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
f01063ca:	74 44                	je     f0106410 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
f01063cc:	8b 45 14             	mov    0x14(%ebp),%eax
f01063cf:	8b 00                	mov    (%eax),%eax
f01063d1:	ba 00 00 00 00       	mov    $0x0,%edx
f01063d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01063d9:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01063dc:	8b 45 14             	mov    0x14(%ebp),%eax
f01063df:	8d 40 04             	lea    0x4(%eax),%eax
f01063e2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01063e5:	bf 10 00 00 00       	mov    $0x10,%edi
f01063ea:	e9 7b ff ff ff       	jmp    f010636a <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
f01063ef:	8b 45 14             	mov    0x14(%ebp),%eax
f01063f2:	8b 50 04             	mov    0x4(%eax),%edx
f01063f5:	8b 00                	mov    (%eax),%eax
f01063f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01063fa:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01063fd:	8b 45 14             	mov    0x14(%ebp),%eax
f0106400:	8d 40 08             	lea    0x8(%eax),%eax
f0106403:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0106406:	bf 10 00 00 00       	mov    $0x10,%edi
f010640b:	e9 5a ff ff ff       	jmp    f010636a <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
f0106410:	8b 45 14             	mov    0x14(%ebp),%eax
f0106413:	8b 00                	mov    (%eax),%eax
f0106415:	ba 00 00 00 00       	mov    $0x0,%edx
f010641a:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010641d:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0106420:	8b 45 14             	mov    0x14(%ebp),%eax
f0106423:	8d 40 04             	lea    0x4(%eax),%eax
f0106426:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0106429:	bf 10 00 00 00       	mov    $0x10,%edi
f010642e:	e9 37 ff ff ff       	jmp    f010636a <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
f0106433:	8b 45 14             	mov    0x14(%ebp),%eax
f0106436:	8d 78 04             	lea    0x4(%eax),%edi
f0106439:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
f010643b:	85 c0                	test   %eax,%eax
f010643d:	74 2c                	je     f010646b <vprintfmt+0x504>
    			*cp = *(int *)putdat;
f010643f:	8b 13                	mov    (%ebx),%edx
f0106441:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
f0106443:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
f0106446:	83 3b 7f             	cmpl   $0x7f,(%ebx)
f0106449:	0f 8e 4a ff ff ff    	jle    f0106399 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
f010644f:	68 ec 92 10 f0       	push   $0xf01092ec
f0106454:	68 b4 87 10 f0       	push   $0xf01087b4
f0106459:	53                   	push   %ebx
f010645a:	56                   	push   %esi
f010645b:	e8 ea fa ff ff       	call   f0105f4a <printfmt>
f0106460:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
f0106463:	89 7d 14             	mov    %edi,0x14(%ebp)
f0106466:	e9 2e ff ff ff       	jmp    f0106399 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
f010646b:	68 b4 92 10 f0       	push   $0xf01092b4
f0106470:	68 b4 87 10 f0       	push   $0xf01087b4
f0106475:	53                   	push   %ebx
f0106476:	56                   	push   %esi
f0106477:	e8 ce fa ff ff       	call   f0105f4a <printfmt>
        		break;
f010647c:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
f010647f:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
f0106482:	e9 12 ff ff ff       	jmp    f0106399 <vprintfmt+0x432>
			putch(ch, putdat);
f0106487:	83 ec 08             	sub    $0x8,%esp
f010648a:	53                   	push   %ebx
f010648b:	6a 25                	push   $0x25
f010648d:	ff d6                	call   *%esi
			break;
f010648f:	83 c4 10             	add    $0x10,%esp
f0106492:	e9 02 ff ff ff       	jmp    f0106399 <vprintfmt+0x432>
			putch('%', putdat);
f0106497:	83 ec 08             	sub    $0x8,%esp
f010649a:	53                   	push   %ebx
f010649b:	6a 25                	push   $0x25
f010649d:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
f010649f:	83 c4 10             	add    $0x10,%esp
f01064a2:	89 f8                	mov    %edi,%eax
f01064a4:	eb 03                	jmp    f01064a9 <vprintfmt+0x542>
f01064a6:	83 e8 01             	sub    $0x1,%eax
f01064a9:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f01064ad:	75 f7                	jne    f01064a6 <vprintfmt+0x53f>
f01064af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01064b2:	e9 e2 fe ff ff       	jmp    f0106399 <vprintfmt+0x432>
}
f01064b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01064ba:	5b                   	pop    %ebx
f01064bb:	5e                   	pop    %esi
f01064bc:	5f                   	pop    %edi
f01064bd:	5d                   	pop    %ebp
f01064be:	c3                   	ret    

f01064bf <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f01064bf:	55                   	push   %ebp
f01064c0:	89 e5                	mov    %esp,%ebp
f01064c2:	83 ec 18             	sub    $0x18,%esp
f01064c5:	8b 45 08             	mov    0x8(%ebp),%eax
f01064c8:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f01064cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01064ce:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f01064d2:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f01064d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f01064dc:	85 c0                	test   %eax,%eax
f01064de:	74 26                	je     f0106506 <vsnprintf+0x47>
f01064e0:	85 d2                	test   %edx,%edx
f01064e2:	7e 22                	jle    f0106506 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f01064e4:	ff 75 14             	pushl  0x14(%ebp)
f01064e7:	ff 75 10             	pushl  0x10(%ebp)
f01064ea:	8d 45 ec             	lea    -0x14(%ebp),%eax
f01064ed:	50                   	push   %eax
f01064ee:	68 2d 5f 10 f0       	push   $0xf0105f2d
f01064f3:	e8 6f fa ff ff       	call   f0105f67 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f01064f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
f01064fb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f01064fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0106501:	83 c4 10             	add    $0x10,%esp
}
f0106504:	c9                   	leave  
f0106505:	c3                   	ret    
		return -E_INVAL;
f0106506:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010650b:	eb f7                	jmp    f0106504 <vsnprintf+0x45>

f010650d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f010650d:	55                   	push   %ebp
f010650e:	89 e5                	mov    %esp,%ebp
f0106510:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0106513:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f0106516:	50                   	push   %eax
f0106517:	ff 75 10             	pushl  0x10(%ebp)
f010651a:	ff 75 0c             	pushl  0xc(%ebp)
f010651d:	ff 75 08             	pushl  0x8(%ebp)
f0106520:	e8 9a ff ff ff       	call   f01064bf <vsnprintf>
	va_end(ap);

	return rc;
}
f0106525:	c9                   	leave  
f0106526:	c3                   	ret    

f0106527 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f0106527:	55                   	push   %ebp
f0106528:	89 e5                	mov    %esp,%ebp
f010652a:	57                   	push   %edi
f010652b:	56                   	push   %esi
f010652c:	53                   	push   %ebx
f010652d:	83 ec 0c             	sub    $0xc,%esp
f0106530:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
f0106533:	85 c0                	test   %eax,%eax
f0106535:	74 11                	je     f0106548 <readline+0x21>
		cprintf("%s", prompt);
f0106537:	83 ec 08             	sub    $0x8,%esp
f010653a:	50                   	push   %eax
f010653b:	68 b4 87 10 f0       	push   $0xf01087b4
f0106540:	e8 a4 e0 ff ff       	call   f01045e9 <cprintf>
f0106545:	83 c4 10             	add    $0x10,%esp
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
	echoing = iscons(0);
f0106548:	83 ec 0c             	sub    $0xc,%esp
f010654b:	6a 00                	push   $0x0
f010654d:	e8 f6 a2 ff ff       	call   f0100848 <iscons>
f0106552:	89 c7                	mov    %eax,%edi
f0106554:	83 c4 10             	add    $0x10,%esp
	i = 0;
f0106557:	be 00 00 00 00       	mov    $0x0,%esi
f010655c:	eb 57                	jmp    f01065b5 <readline+0x8e>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
f010655e:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
f0106563:	83 fb f8             	cmp    $0xfffffff8,%ebx
f0106566:	75 08                	jne    f0106570 <readline+0x49>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f0106568:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010656b:	5b                   	pop    %ebx
f010656c:	5e                   	pop    %esi
f010656d:	5f                   	pop    %edi
f010656e:	5d                   	pop    %ebp
f010656f:	c3                   	ret    
				cprintf("read error: %e\n", c);
f0106570:	83 ec 08             	sub    $0x8,%esp
f0106573:	53                   	push   %ebx
f0106574:	68 00 95 10 f0       	push   $0xf0109500
f0106579:	e8 6b e0 ff ff       	call   f01045e9 <cprintf>
f010657e:	83 c4 10             	add    $0x10,%esp
			return NULL;
f0106581:	b8 00 00 00 00       	mov    $0x0,%eax
f0106586:	eb e0                	jmp    f0106568 <readline+0x41>
			if (echoing)
f0106588:	85 ff                	test   %edi,%edi
f010658a:	75 05                	jne    f0106591 <readline+0x6a>
			i--;
f010658c:	83 ee 01             	sub    $0x1,%esi
f010658f:	eb 24                	jmp    f01065b5 <readline+0x8e>
				cputchar('\b');
f0106591:	83 ec 0c             	sub    $0xc,%esp
f0106594:	6a 08                	push   $0x8
f0106596:	e8 8c a2 ff ff       	call   f0100827 <cputchar>
f010659b:	83 c4 10             	add    $0x10,%esp
f010659e:	eb ec                	jmp    f010658c <readline+0x65>
				cputchar(c);
f01065a0:	83 ec 0c             	sub    $0xc,%esp
f01065a3:	53                   	push   %ebx
f01065a4:	e8 7e a2 ff ff       	call   f0100827 <cputchar>
f01065a9:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
f01065ac:	88 9e 80 4a 34 f0    	mov    %bl,-0xfcbb580(%esi)
f01065b2:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
f01065b5:	e8 7d a2 ff ff       	call   f0100837 <getchar>
f01065ba:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f01065bc:	85 c0                	test   %eax,%eax
f01065be:	78 9e                	js     f010655e <readline+0x37>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f01065c0:	83 f8 08             	cmp    $0x8,%eax
f01065c3:	0f 94 c2             	sete   %dl
f01065c6:	83 f8 7f             	cmp    $0x7f,%eax
f01065c9:	0f 94 c0             	sete   %al
f01065cc:	08 c2                	or     %al,%dl
f01065ce:	74 04                	je     f01065d4 <readline+0xad>
f01065d0:	85 f6                	test   %esi,%esi
f01065d2:	7f b4                	jg     f0106588 <readline+0x61>
		} else if (c >= ' ' && i < BUFLEN-1) {
f01065d4:	83 fb 1f             	cmp    $0x1f,%ebx
f01065d7:	7e 0e                	jle    f01065e7 <readline+0xc0>
f01065d9:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f01065df:	7f 06                	jg     f01065e7 <readline+0xc0>
			if (echoing)
f01065e1:	85 ff                	test   %edi,%edi
f01065e3:	74 c7                	je     f01065ac <readline+0x85>
f01065e5:	eb b9                	jmp    f01065a0 <readline+0x79>
		} else if (c == '\n' || c == '\r') {
f01065e7:	83 fb 0a             	cmp    $0xa,%ebx
f01065ea:	74 05                	je     f01065f1 <readline+0xca>
f01065ec:	83 fb 0d             	cmp    $0xd,%ebx
f01065ef:	75 c4                	jne    f01065b5 <readline+0x8e>
			if (echoing)
f01065f1:	85 ff                	test   %edi,%edi
f01065f3:	75 11                	jne    f0106606 <readline+0xdf>
			buf[i] = 0;
f01065f5:	c6 86 80 4a 34 f0 00 	movb   $0x0,-0xfcbb580(%esi)
			return buf;
f01065fc:	b8 80 4a 34 f0       	mov    $0xf0344a80,%eax
f0106601:	e9 62 ff ff ff       	jmp    f0106568 <readline+0x41>
				cputchar('\n');
f0106606:	83 ec 0c             	sub    $0xc,%esp
f0106609:	6a 0a                	push   $0xa
f010660b:	e8 17 a2 ff ff       	call   f0100827 <cputchar>
f0106610:	83 c4 10             	add    $0x10,%esp
f0106613:	eb e0                	jmp    f01065f5 <readline+0xce>

f0106615 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0106615:	55                   	push   %ebp
f0106616:	89 e5                	mov    %esp,%ebp
f0106618:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f010661b:	b8 00 00 00 00       	mov    $0x0,%eax
f0106620:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0106624:	74 05                	je     f010662b <strlen+0x16>
		n++;
f0106626:	83 c0 01             	add    $0x1,%eax
f0106629:	eb f5                	jmp    f0106620 <strlen+0xb>
	return n;
}
f010662b:	5d                   	pop    %ebp
f010662c:	c3                   	ret    

f010662d <strnlen>:

int
strnlen(const char *s, size_t size)
{
f010662d:	55                   	push   %ebp
f010662e:	89 e5                	mov    %esp,%ebp
f0106630:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0106633:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0106636:	ba 00 00 00 00       	mov    $0x0,%edx
f010663b:	39 c2                	cmp    %eax,%edx
f010663d:	74 0d                	je     f010664c <strnlen+0x1f>
f010663f:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
f0106643:	74 05                	je     f010664a <strnlen+0x1d>
		n++;
f0106645:	83 c2 01             	add    $0x1,%edx
f0106648:	eb f1                	jmp    f010663b <strnlen+0xe>
f010664a:	89 d0                	mov    %edx,%eax
	return n;
}
f010664c:	5d                   	pop    %ebp
f010664d:	c3                   	ret    

f010664e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f010664e:	55                   	push   %ebp
f010664f:	89 e5                	mov    %esp,%ebp
f0106651:	53                   	push   %ebx
f0106652:	8b 45 08             	mov    0x8(%ebp),%eax
f0106655:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f0106658:	ba 00 00 00 00       	mov    $0x0,%edx
f010665d:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
f0106661:	88 0c 10             	mov    %cl,(%eax,%edx,1)
f0106664:	83 c2 01             	add    $0x1,%edx
f0106667:	84 c9                	test   %cl,%cl
f0106669:	75 f2                	jne    f010665d <strcpy+0xf>
		/* do nothing */;
	return ret;
}
f010666b:	5b                   	pop    %ebx
f010666c:	5d                   	pop    %ebp
f010666d:	c3                   	ret    

f010666e <strcat>:

char *
strcat(char *dst, const char *src)
{
f010666e:	55                   	push   %ebp
f010666f:	89 e5                	mov    %esp,%ebp
f0106671:	53                   	push   %ebx
f0106672:	83 ec 10             	sub    $0x10,%esp
f0106675:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f0106678:	53                   	push   %ebx
f0106679:	e8 97 ff ff ff       	call   f0106615 <strlen>
f010667e:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
f0106681:	ff 75 0c             	pushl  0xc(%ebp)
f0106684:	01 d8                	add    %ebx,%eax
f0106686:	50                   	push   %eax
f0106687:	e8 c2 ff ff ff       	call   f010664e <strcpy>
	return dst;
}
f010668c:	89 d8                	mov    %ebx,%eax
f010668e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0106691:	c9                   	leave  
f0106692:	c3                   	ret    

f0106693 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f0106693:	55                   	push   %ebp
f0106694:	89 e5                	mov    %esp,%ebp
f0106696:	56                   	push   %esi
f0106697:	53                   	push   %ebx
f0106698:	8b 45 08             	mov    0x8(%ebp),%eax
f010669b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f010669e:	89 c6                	mov    %eax,%esi
f01066a0:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f01066a3:	89 c2                	mov    %eax,%edx
f01066a5:	39 f2                	cmp    %esi,%edx
f01066a7:	74 11                	je     f01066ba <strncpy+0x27>
		*dst++ = *src;
f01066a9:	83 c2 01             	add    $0x1,%edx
f01066ac:	0f b6 19             	movzbl (%ecx),%ebx
f01066af:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f01066b2:	80 fb 01             	cmp    $0x1,%bl
f01066b5:	83 d9 ff             	sbb    $0xffffffff,%ecx
f01066b8:	eb eb                	jmp    f01066a5 <strncpy+0x12>
	}
	return ret;
}
f01066ba:	5b                   	pop    %ebx
f01066bb:	5e                   	pop    %esi
f01066bc:	5d                   	pop    %ebp
f01066bd:	c3                   	ret    

f01066be <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f01066be:	55                   	push   %ebp
f01066bf:	89 e5                	mov    %esp,%ebp
f01066c1:	56                   	push   %esi
f01066c2:	53                   	push   %ebx
f01066c3:	8b 75 08             	mov    0x8(%ebp),%esi
f01066c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01066c9:	8b 55 10             	mov    0x10(%ebp),%edx
f01066cc:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f01066ce:	85 d2                	test   %edx,%edx
f01066d0:	74 21                	je     f01066f3 <strlcpy+0x35>
f01066d2:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
f01066d6:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
f01066d8:	39 c2                	cmp    %eax,%edx
f01066da:	74 14                	je     f01066f0 <strlcpy+0x32>
f01066dc:	0f b6 19             	movzbl (%ecx),%ebx
f01066df:	84 db                	test   %bl,%bl
f01066e1:	74 0b                	je     f01066ee <strlcpy+0x30>
			*dst++ = *src++;
f01066e3:	83 c1 01             	add    $0x1,%ecx
f01066e6:	83 c2 01             	add    $0x1,%edx
f01066e9:	88 5a ff             	mov    %bl,-0x1(%edx)
f01066ec:	eb ea                	jmp    f01066d8 <strlcpy+0x1a>
f01066ee:	89 d0                	mov    %edx,%eax
		*dst = '\0';
f01066f0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f01066f3:	29 f0                	sub    %esi,%eax
}
f01066f5:	5b                   	pop    %ebx
f01066f6:	5e                   	pop    %esi
f01066f7:	5d                   	pop    %ebp
f01066f8:	c3                   	ret    

f01066f9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f01066f9:	55                   	push   %ebp
f01066fa:	89 e5                	mov    %esp,%ebp
f01066fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01066ff:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f0106702:	0f b6 01             	movzbl (%ecx),%eax
f0106705:	84 c0                	test   %al,%al
f0106707:	74 0c                	je     f0106715 <strcmp+0x1c>
f0106709:	3a 02                	cmp    (%edx),%al
f010670b:	75 08                	jne    f0106715 <strcmp+0x1c>
		p++, q++;
f010670d:	83 c1 01             	add    $0x1,%ecx
f0106710:	83 c2 01             	add    $0x1,%edx
f0106713:	eb ed                	jmp    f0106702 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0106715:	0f b6 c0             	movzbl %al,%eax
f0106718:	0f b6 12             	movzbl (%edx),%edx
f010671b:	29 d0                	sub    %edx,%eax
}
f010671d:	5d                   	pop    %ebp
f010671e:	c3                   	ret    

f010671f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f010671f:	55                   	push   %ebp
f0106720:	89 e5                	mov    %esp,%ebp
f0106722:	53                   	push   %ebx
f0106723:	8b 45 08             	mov    0x8(%ebp),%eax
f0106726:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106729:	89 c3                	mov    %eax,%ebx
f010672b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f010672e:	eb 06                	jmp    f0106736 <strncmp+0x17>
		n--, p++, q++;
f0106730:	83 c0 01             	add    $0x1,%eax
f0106733:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f0106736:	39 d8                	cmp    %ebx,%eax
f0106738:	74 16                	je     f0106750 <strncmp+0x31>
f010673a:	0f b6 08             	movzbl (%eax),%ecx
f010673d:	84 c9                	test   %cl,%cl
f010673f:	74 04                	je     f0106745 <strncmp+0x26>
f0106741:	3a 0a                	cmp    (%edx),%cl
f0106743:	74 eb                	je     f0106730 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0106745:	0f b6 00             	movzbl (%eax),%eax
f0106748:	0f b6 12             	movzbl (%edx),%edx
f010674b:	29 d0                	sub    %edx,%eax
}
f010674d:	5b                   	pop    %ebx
f010674e:	5d                   	pop    %ebp
f010674f:	c3                   	ret    
		return 0;
f0106750:	b8 00 00 00 00       	mov    $0x0,%eax
f0106755:	eb f6                	jmp    f010674d <strncmp+0x2e>

f0106757 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0106757:	55                   	push   %ebp
f0106758:	89 e5                	mov    %esp,%ebp
f010675a:	8b 45 08             	mov    0x8(%ebp),%eax
f010675d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0106761:	0f b6 10             	movzbl (%eax),%edx
f0106764:	84 d2                	test   %dl,%dl
f0106766:	74 09                	je     f0106771 <strchr+0x1a>
		if (*s == c)
f0106768:	38 ca                	cmp    %cl,%dl
f010676a:	74 0a                	je     f0106776 <strchr+0x1f>
	for (; *s; s++)
f010676c:	83 c0 01             	add    $0x1,%eax
f010676f:	eb f0                	jmp    f0106761 <strchr+0xa>
			return (char *) s;
	return 0;
f0106771:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0106776:	5d                   	pop    %ebp
f0106777:	c3                   	ret    

f0106778 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f0106778:	55                   	push   %ebp
f0106779:	89 e5                	mov    %esp,%ebp
f010677b:	8b 45 08             	mov    0x8(%ebp),%eax
f010677e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0106782:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f0106785:	38 ca                	cmp    %cl,%dl
f0106787:	74 09                	je     f0106792 <strfind+0x1a>
f0106789:	84 d2                	test   %dl,%dl
f010678b:	74 05                	je     f0106792 <strfind+0x1a>
	for (; *s; s++)
f010678d:	83 c0 01             	add    $0x1,%eax
f0106790:	eb f0                	jmp    f0106782 <strfind+0xa>
			break;
	return (char *) s;
}
f0106792:	5d                   	pop    %ebp
f0106793:	c3                   	ret    

f0106794 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f0106794:	55                   	push   %ebp
f0106795:	89 e5                	mov    %esp,%ebp
f0106797:	57                   	push   %edi
f0106798:	56                   	push   %esi
f0106799:	53                   	push   %ebx
f010679a:	8b 7d 08             	mov    0x8(%ebp),%edi
f010679d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f01067a0:	85 c9                	test   %ecx,%ecx
f01067a2:	74 31                	je     f01067d5 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f01067a4:	89 f8                	mov    %edi,%eax
f01067a6:	09 c8                	or     %ecx,%eax
f01067a8:	a8 03                	test   $0x3,%al
f01067aa:	75 23                	jne    f01067cf <memset+0x3b>
		c &= 0xFF;
f01067ac:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f01067b0:	89 d3                	mov    %edx,%ebx
f01067b2:	c1 e3 08             	shl    $0x8,%ebx
f01067b5:	89 d0                	mov    %edx,%eax
f01067b7:	c1 e0 18             	shl    $0x18,%eax
f01067ba:	89 d6                	mov    %edx,%esi
f01067bc:	c1 e6 10             	shl    $0x10,%esi
f01067bf:	09 f0                	or     %esi,%eax
f01067c1:	09 c2                	or     %eax,%edx
f01067c3:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
f01067c5:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f01067c8:	89 d0                	mov    %edx,%eax
f01067ca:	fc                   	cld    
f01067cb:	f3 ab                	rep stos %eax,%es:(%edi)
f01067cd:	eb 06                	jmp    f01067d5 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f01067cf:	8b 45 0c             	mov    0xc(%ebp),%eax
f01067d2:	fc                   	cld    
f01067d3:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f01067d5:	89 f8                	mov    %edi,%eax
f01067d7:	5b                   	pop    %ebx
f01067d8:	5e                   	pop    %esi
f01067d9:	5f                   	pop    %edi
f01067da:	5d                   	pop    %ebp
f01067db:	c3                   	ret    

f01067dc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f01067dc:	55                   	push   %ebp
f01067dd:	89 e5                	mov    %esp,%ebp
f01067df:	57                   	push   %edi
f01067e0:	56                   	push   %esi
f01067e1:	8b 45 08             	mov    0x8(%ebp),%eax
f01067e4:	8b 75 0c             	mov    0xc(%ebp),%esi
f01067e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f01067ea:	39 c6                	cmp    %eax,%esi
f01067ec:	73 32                	jae    f0106820 <memmove+0x44>
f01067ee:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f01067f1:	39 c2                	cmp    %eax,%edx
f01067f3:	76 2b                	jbe    f0106820 <memmove+0x44>
		s += n;
		d += n;
f01067f5:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f01067f8:	89 fe                	mov    %edi,%esi
f01067fa:	09 ce                	or     %ecx,%esi
f01067fc:	09 d6                	or     %edx,%esi
f01067fe:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0106804:	75 0e                	jne    f0106814 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0106806:	83 ef 04             	sub    $0x4,%edi
f0106809:	8d 72 fc             	lea    -0x4(%edx),%esi
f010680c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f010680f:	fd                   	std    
f0106810:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0106812:	eb 09                	jmp    f010681d <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f0106814:	83 ef 01             	sub    $0x1,%edi
f0106817:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f010681a:	fd                   	std    
f010681b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f010681d:	fc                   	cld    
f010681e:	eb 1a                	jmp    f010683a <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0106820:	89 c2                	mov    %eax,%edx
f0106822:	09 ca                	or     %ecx,%edx
f0106824:	09 f2                	or     %esi,%edx
f0106826:	f6 c2 03             	test   $0x3,%dl
f0106829:	75 0a                	jne    f0106835 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f010682b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f010682e:	89 c7                	mov    %eax,%edi
f0106830:	fc                   	cld    
f0106831:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0106833:	eb 05                	jmp    f010683a <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
f0106835:	89 c7                	mov    %eax,%edi
f0106837:	fc                   	cld    
f0106838:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f010683a:	5e                   	pop    %esi
f010683b:	5f                   	pop    %edi
f010683c:	5d                   	pop    %ebp
f010683d:	c3                   	ret    

f010683e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f010683e:	55                   	push   %ebp
f010683f:	89 e5                	mov    %esp,%ebp
f0106841:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f0106844:	ff 75 10             	pushl  0x10(%ebp)
f0106847:	ff 75 0c             	pushl  0xc(%ebp)
f010684a:	ff 75 08             	pushl  0x8(%ebp)
f010684d:	e8 8a ff ff ff       	call   f01067dc <memmove>
}
f0106852:	c9                   	leave  
f0106853:	c3                   	ret    

f0106854 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0106854:	55                   	push   %ebp
f0106855:	89 e5                	mov    %esp,%ebp
f0106857:	56                   	push   %esi
f0106858:	53                   	push   %ebx
f0106859:	8b 45 08             	mov    0x8(%ebp),%eax
f010685c:	8b 55 0c             	mov    0xc(%ebp),%edx
f010685f:	89 c6                	mov    %eax,%esi
f0106861:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0106864:	39 f0                	cmp    %esi,%eax
f0106866:	74 1c                	je     f0106884 <memcmp+0x30>
		if (*s1 != *s2)
f0106868:	0f b6 08             	movzbl (%eax),%ecx
f010686b:	0f b6 1a             	movzbl (%edx),%ebx
f010686e:	38 d9                	cmp    %bl,%cl
f0106870:	75 08                	jne    f010687a <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f0106872:	83 c0 01             	add    $0x1,%eax
f0106875:	83 c2 01             	add    $0x1,%edx
f0106878:	eb ea                	jmp    f0106864 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
f010687a:	0f b6 c1             	movzbl %cl,%eax
f010687d:	0f b6 db             	movzbl %bl,%ebx
f0106880:	29 d8                	sub    %ebx,%eax
f0106882:	eb 05                	jmp    f0106889 <memcmp+0x35>
	}

	return 0;
f0106884:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0106889:	5b                   	pop    %ebx
f010688a:	5e                   	pop    %esi
f010688b:	5d                   	pop    %ebp
f010688c:	c3                   	ret    

f010688d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f010688d:	55                   	push   %ebp
f010688e:	89 e5                	mov    %esp,%ebp
f0106890:	8b 45 08             	mov    0x8(%ebp),%eax
f0106893:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f0106896:	89 c2                	mov    %eax,%edx
f0106898:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f010689b:	39 d0                	cmp    %edx,%eax
f010689d:	73 09                	jae    f01068a8 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
f010689f:	38 08                	cmp    %cl,(%eax)
f01068a1:	74 05                	je     f01068a8 <memfind+0x1b>
	for (; s < ends; s++)
f01068a3:	83 c0 01             	add    $0x1,%eax
f01068a6:	eb f3                	jmp    f010689b <memfind+0xe>
			break;
	return (void *) s;
}
f01068a8:	5d                   	pop    %ebp
f01068a9:	c3                   	ret    

f01068aa <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f01068aa:	55                   	push   %ebp
f01068ab:	89 e5                	mov    %esp,%ebp
f01068ad:	57                   	push   %edi
f01068ae:	56                   	push   %esi
f01068af:	53                   	push   %ebx
f01068b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01068b3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f01068b6:	eb 03                	jmp    f01068bb <strtol+0x11>
		s++;
f01068b8:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
f01068bb:	0f b6 01             	movzbl (%ecx),%eax
f01068be:	3c 20                	cmp    $0x20,%al
f01068c0:	74 f6                	je     f01068b8 <strtol+0xe>
f01068c2:	3c 09                	cmp    $0x9,%al
f01068c4:	74 f2                	je     f01068b8 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
f01068c6:	3c 2b                	cmp    $0x2b,%al
f01068c8:	74 2a                	je     f01068f4 <strtol+0x4a>
	int neg = 0;
f01068ca:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f01068cf:	3c 2d                	cmp    $0x2d,%al
f01068d1:	74 2b                	je     f01068fe <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f01068d3:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f01068d9:	75 0f                	jne    f01068ea <strtol+0x40>
f01068db:	80 39 30             	cmpb   $0x30,(%ecx)
f01068de:	74 28                	je     f0106908 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
f01068e0:	85 db                	test   %ebx,%ebx
f01068e2:	b8 0a 00 00 00       	mov    $0xa,%eax
f01068e7:	0f 44 d8             	cmove  %eax,%ebx
f01068ea:	b8 00 00 00 00       	mov    $0x0,%eax
f01068ef:	89 5d 10             	mov    %ebx,0x10(%ebp)
f01068f2:	eb 50                	jmp    f0106944 <strtol+0x9a>
		s++;
f01068f4:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
f01068f7:	bf 00 00 00 00       	mov    $0x0,%edi
f01068fc:	eb d5                	jmp    f01068d3 <strtol+0x29>
		s++, neg = 1;
f01068fe:	83 c1 01             	add    $0x1,%ecx
f0106901:	bf 01 00 00 00       	mov    $0x1,%edi
f0106906:	eb cb                	jmp    f01068d3 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0106908:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f010690c:	74 0e                	je     f010691c <strtol+0x72>
	else if (base == 0 && s[0] == '0')
f010690e:	85 db                	test   %ebx,%ebx
f0106910:	75 d8                	jne    f01068ea <strtol+0x40>
		s++, base = 8;
f0106912:	83 c1 01             	add    $0x1,%ecx
f0106915:	bb 08 00 00 00       	mov    $0x8,%ebx
f010691a:	eb ce                	jmp    f01068ea <strtol+0x40>
		s += 2, base = 16;
f010691c:	83 c1 02             	add    $0x2,%ecx
f010691f:	bb 10 00 00 00       	mov    $0x10,%ebx
f0106924:	eb c4                	jmp    f01068ea <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
f0106926:	8d 72 9f             	lea    -0x61(%edx),%esi
f0106929:	89 f3                	mov    %esi,%ebx
f010692b:	80 fb 19             	cmp    $0x19,%bl
f010692e:	77 29                	ja     f0106959 <strtol+0xaf>
			dig = *s - 'a' + 10;
f0106930:	0f be d2             	movsbl %dl,%edx
f0106933:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f0106936:	3b 55 10             	cmp    0x10(%ebp),%edx
f0106939:	7d 30                	jge    f010696b <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
f010693b:	83 c1 01             	add    $0x1,%ecx
f010693e:	0f af 45 10          	imul   0x10(%ebp),%eax
f0106942:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
f0106944:	0f b6 11             	movzbl (%ecx),%edx
f0106947:	8d 72 d0             	lea    -0x30(%edx),%esi
f010694a:	89 f3                	mov    %esi,%ebx
f010694c:	80 fb 09             	cmp    $0x9,%bl
f010694f:	77 d5                	ja     f0106926 <strtol+0x7c>
			dig = *s - '0';
f0106951:	0f be d2             	movsbl %dl,%edx
f0106954:	83 ea 30             	sub    $0x30,%edx
f0106957:	eb dd                	jmp    f0106936 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
f0106959:	8d 72 bf             	lea    -0x41(%edx),%esi
f010695c:	89 f3                	mov    %esi,%ebx
f010695e:	80 fb 19             	cmp    $0x19,%bl
f0106961:	77 08                	ja     f010696b <strtol+0xc1>
			dig = *s - 'A' + 10;
f0106963:	0f be d2             	movsbl %dl,%edx
f0106966:	83 ea 37             	sub    $0x37,%edx
f0106969:	eb cb                	jmp    f0106936 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
f010696b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f010696f:	74 05                	je     f0106976 <strtol+0xcc>
		*endptr = (char *) s;
f0106971:	8b 75 0c             	mov    0xc(%ebp),%esi
f0106974:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
f0106976:	89 c2                	mov    %eax,%edx
f0106978:	f7 da                	neg    %edx
f010697a:	85 ff                	test   %edi,%edi
f010697c:	0f 45 c2             	cmovne %edx,%eax
}
f010697f:	5b                   	pop    %ebx
f0106980:	5e                   	pop    %esi
f0106981:	5f                   	pop    %edi
f0106982:	5d                   	pop    %ebp
f0106983:	c3                   	ret    

f0106984 <mpentry_start>:
.set PROT_MODE_DSEG, 0x10	# kernel data segment selector

.code16           
.globl mpentry_start
mpentry_start:
	cli            
f0106984:	fa                   	cli    

	xorw    %ax, %ax
f0106985:	31 c0                	xor    %eax,%eax
	movw    %ax, %ds
f0106987:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f0106989:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f010698b:	8e d0                	mov    %eax,%ss

	lgdt    MPBOOTPHYS(gdtdesc)
f010698d:	0f 01 16             	lgdtl  (%esi)
f0106990:	7c 70                	jl     f0106a02 <gdtdesc+0x2>
	movl    %cr0, %eax
f0106992:	0f 20 c0             	mov    %cr0,%eax
	orl     $CR0_PE, %eax
f0106995:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
f0106999:	0f 22 c0             	mov    %eax,%cr0

	ljmpl   $(PROT_MODE_CSEG), $(MPBOOTPHYS(start32))
f010699c:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
f01069a2:	08 00                	or     %al,(%eax)

f01069a4 <start32>:

.code32
start32:
	movw    $(PROT_MODE_DSEG), %ax
f01069a4:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds
f01069a8:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f01069aa:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f01069ac:	8e d0                	mov    %eax,%ss
	movw    $0, %ax
f01069ae:	66 b8 00 00          	mov    $0x0,%ax
	movw    %ax, %fs
f01069b2:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs
f01069b4:	8e e8                	mov    %eax,%gs

	# Set up initial page table. We cannot use kern_pgdir yet because
	# we are still running at a low EIP.
	movl    $(RELOC(entry_pgdir)), %eax
f01069b6:	b8 00 40 12 00       	mov    $0x124000,%eax
	movl    %eax, %cr3
f01069bb:	0f 22 d8             	mov    %eax,%cr3
	# Turn on huge page
	movl    %cr4, %eax
f01069be:	0f 20 e0             	mov    %cr4,%eax
	orl     $(CR4_PSE), %eax
f01069c1:	83 c8 10             	or     $0x10,%eax
	movl    %eax, %cr4
f01069c4:	0f 22 e0             	mov    %eax,%cr4
	# Turn on paging.
	movl    %cr0, %eax
f01069c7:	0f 20 c0             	mov    %cr0,%eax
	orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
f01069ca:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl    %eax, %cr0
f01069cf:	0f 22 c0             	mov    %eax,%cr0

	# Switch to the per-cpu stack allocated in boot_aps()
	movl    mpentry_kstack, %esp
f01069d2:	8b 25 84 5e 34 f0    	mov    0xf0345e84,%esp
	movl    $0x0, %ebp       # nuke frame pointer
f01069d8:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Call mp_main().  (Exercise for the reader: why the indirect call?)
	movl    $mp_main, %eax
f01069dd:	b8 59 02 10 f0       	mov    $0xf0100259,%eax
	call    *%eax
f01069e2:	ff d0                	call   *%eax

f01069e4 <spin>:

	# If mp_main returns (it shouldn't), loop.
spin:
	jmp     spin
f01069e4:	eb fe                	jmp    f01069e4 <spin>
f01069e6:	66 90                	xchg   %ax,%ax

f01069e8 <gdt>:
	...
f01069f0:	ff                   	(bad)  
f01069f1:	ff 00                	incl   (%eax)
f01069f3:	00 00                	add    %al,(%eax)
f01069f5:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f01069fc:	00                   	.byte 0x0
f01069fd:	92                   	xchg   %eax,%edx
f01069fe:	cf                   	iret   
	...

f0106a00 <gdtdesc>:
f0106a00:	17                   	pop    %ss
f0106a01:	00 64 70 00          	add    %ah,0x0(%eax,%esi,2)
	...

f0106a06 <mpentry_end>:
	.word   0x17				# sizeof(gdt) - 1
	.long   MPBOOTPHYS(gdt)			# address gdt

.globl mpentry_end
mpentry_end:
	nop
f0106a06:	90                   	nop

f0106a07 <mpsearch1>:
}

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
f0106a07:	55                   	push   %ebp
f0106a08:	89 e5                	mov    %esp,%ebp
f0106a0a:	57                   	push   %edi
f0106a0b:	56                   	push   %esi
f0106a0c:	53                   	push   %ebx
f0106a0d:	83 ec 0c             	sub    $0xc,%esp
	if (PGNUM(pa) >= npages)
f0106a10:	8b 0d 88 5e 34 f0    	mov    0xf0345e88,%ecx
f0106a16:	89 c3                	mov    %eax,%ebx
f0106a18:	c1 eb 0c             	shr    $0xc,%ebx
f0106a1b:	39 cb                	cmp    %ecx,%ebx
f0106a1d:	73 1a                	jae    f0106a39 <mpsearch1+0x32>
	return (void *)(pa + KERNBASE);
f0106a1f:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
	struct mp *mp = KADDR(a), *end = KADDR(a + len);
f0106a25:	8d 3c 02             	lea    (%edx,%eax,1),%edi
	if (PGNUM(pa) >= npages)
f0106a28:	89 f8                	mov    %edi,%eax
f0106a2a:	c1 e8 0c             	shr    $0xc,%eax
f0106a2d:	39 c8                	cmp    %ecx,%eax
f0106a2f:	73 1a                	jae    f0106a4b <mpsearch1+0x44>
	return (void *)(pa + KERNBASE);
f0106a31:	81 ef 00 00 00 10    	sub    $0x10000000,%edi

	for (; mp < end; mp++)
f0106a37:	eb 27                	jmp    f0106a60 <mpsearch1+0x59>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106a39:	50                   	push   %eax
f0106a3a:	68 54 74 10 f0       	push   $0xf0107454
f0106a3f:	6a 57                	push   $0x57
f0106a41:	68 9d 96 10 f0       	push   $0xf010969d
f0106a46:	e8 fe 95 ff ff       	call   f0100049 <_panic>
f0106a4b:	57                   	push   %edi
f0106a4c:	68 54 74 10 f0       	push   $0xf0107454
f0106a51:	6a 57                	push   $0x57
f0106a53:	68 9d 96 10 f0       	push   $0xf010969d
f0106a58:	e8 ec 95 ff ff       	call   f0100049 <_panic>
f0106a5d:	83 c3 10             	add    $0x10,%ebx
f0106a60:	39 fb                	cmp    %edi,%ebx
f0106a62:	73 30                	jae    f0106a94 <mpsearch1+0x8d>
f0106a64:	89 de                	mov    %ebx,%esi
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0106a66:	83 ec 04             	sub    $0x4,%esp
f0106a69:	6a 04                	push   $0x4
f0106a6b:	68 ad 96 10 f0       	push   $0xf01096ad
f0106a70:	53                   	push   %ebx
f0106a71:	e8 de fd ff ff       	call   f0106854 <memcmp>
f0106a76:	83 c4 10             	add    $0x10,%esp
f0106a79:	85 c0                	test   %eax,%eax
f0106a7b:	75 e0                	jne    f0106a5d <mpsearch1+0x56>
f0106a7d:	89 da                	mov    %ebx,%edx
	for (i = 0; i < len; i++)
f0106a7f:	83 c6 10             	add    $0x10,%esi
		sum += ((uint8_t *)addr)[i];
f0106a82:	0f b6 0a             	movzbl (%edx),%ecx
f0106a85:	01 c8                	add    %ecx,%eax
f0106a87:	83 c2 01             	add    $0x1,%edx
	for (i = 0; i < len; i++)
f0106a8a:	39 f2                	cmp    %esi,%edx
f0106a8c:	75 f4                	jne    f0106a82 <mpsearch1+0x7b>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0106a8e:	84 c0                	test   %al,%al
f0106a90:	75 cb                	jne    f0106a5d <mpsearch1+0x56>
f0106a92:	eb 05                	jmp    f0106a99 <mpsearch1+0x92>
		    sum(mp, sizeof(*mp)) == 0)
			return mp;
	return NULL;
f0106a94:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f0106a99:	89 d8                	mov    %ebx,%eax
f0106a9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106a9e:	5b                   	pop    %ebx
f0106a9f:	5e                   	pop    %esi
f0106aa0:	5f                   	pop    %edi
f0106aa1:	5d                   	pop    %ebp
f0106aa2:	c3                   	ret    

f0106aa3 <mp_init>:
	return conf;
}

void
mp_init(void)
{
f0106aa3:	55                   	push   %ebp
f0106aa4:	89 e5                	mov    %esp,%ebp
f0106aa6:	57                   	push   %edi
f0106aa7:	56                   	push   %esi
f0106aa8:	53                   	push   %ebx
f0106aa9:	83 ec 1c             	sub    $0x1c,%esp
	struct mpconf *conf;
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
f0106aac:	c7 05 c0 63 34 f0 20 	movl   $0xf0346020,0xf03463c0
f0106ab3:	60 34 f0 
	if (PGNUM(pa) >= npages)
f0106ab6:	83 3d 88 5e 34 f0 00 	cmpl   $0x0,0xf0345e88
f0106abd:	0f 84 a3 00 00 00    	je     f0106b66 <mp_init+0xc3>
	if ((p = *(uint16_t *) (bda + 0x0E))) {
f0106ac3:	0f b7 05 0e 04 00 f0 	movzwl 0xf000040e,%eax
f0106aca:	85 c0                	test   %eax,%eax
f0106acc:	0f 84 aa 00 00 00    	je     f0106b7c <mp_init+0xd9>
		p <<= 4;	// Translate from segment to PA
f0106ad2:	c1 e0 04             	shl    $0x4,%eax
		if ((mp = mpsearch1(p, 1024)))
f0106ad5:	ba 00 04 00 00       	mov    $0x400,%edx
f0106ada:	e8 28 ff ff ff       	call   f0106a07 <mpsearch1>
f0106adf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0106ae2:	85 c0                	test   %eax,%eax
f0106ae4:	75 1a                	jne    f0106b00 <mp_init+0x5d>
	return mpsearch1(0xF0000, 0x10000);
f0106ae6:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106aeb:	b8 00 00 0f 00       	mov    $0xf0000,%eax
f0106af0:	e8 12 ff ff ff       	call   f0106a07 <mpsearch1>
f0106af5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if ((mp = mpsearch()) == 0)
f0106af8:	85 c0                	test   %eax,%eax
f0106afa:	0f 84 31 02 00 00    	je     f0106d31 <mp_init+0x28e>
	if (mp->physaddr == 0 || mp->type != 0) {
f0106b00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0106b03:	8b 58 04             	mov    0x4(%eax),%ebx
f0106b06:	85 db                	test   %ebx,%ebx
f0106b08:	0f 84 97 00 00 00    	je     f0106ba5 <mp_init+0x102>
f0106b0e:	80 78 0b 00          	cmpb   $0x0,0xb(%eax)
f0106b12:	0f 85 8d 00 00 00    	jne    f0106ba5 <mp_init+0x102>
f0106b18:	89 d8                	mov    %ebx,%eax
f0106b1a:	c1 e8 0c             	shr    $0xc,%eax
f0106b1d:	3b 05 88 5e 34 f0    	cmp    0xf0345e88,%eax
f0106b23:	0f 83 91 00 00 00    	jae    f0106bba <mp_init+0x117>
	return (void *)(pa + KERNBASE);
f0106b29:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
f0106b2f:	89 de                	mov    %ebx,%esi
	if (memcmp(conf, "PCMP", 4) != 0) {
f0106b31:	83 ec 04             	sub    $0x4,%esp
f0106b34:	6a 04                	push   $0x4
f0106b36:	68 b2 96 10 f0       	push   $0xf01096b2
f0106b3b:	53                   	push   %ebx
f0106b3c:	e8 13 fd ff ff       	call   f0106854 <memcmp>
f0106b41:	83 c4 10             	add    $0x10,%esp
f0106b44:	85 c0                	test   %eax,%eax
f0106b46:	0f 85 83 00 00 00    	jne    f0106bcf <mp_init+0x12c>
f0106b4c:	0f b7 7b 04          	movzwl 0x4(%ebx),%edi
f0106b50:	01 df                	add    %ebx,%edi
	sum = 0;
f0106b52:	89 c2                	mov    %eax,%edx
	for (i = 0; i < len; i++)
f0106b54:	39 fb                	cmp    %edi,%ebx
f0106b56:	0f 84 88 00 00 00    	je     f0106be4 <mp_init+0x141>
		sum += ((uint8_t *)addr)[i];
f0106b5c:	0f b6 0b             	movzbl (%ebx),%ecx
f0106b5f:	01 ca                	add    %ecx,%edx
f0106b61:	83 c3 01             	add    $0x1,%ebx
f0106b64:	eb ee                	jmp    f0106b54 <mp_init+0xb1>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106b66:	68 00 04 00 00       	push   $0x400
f0106b6b:	68 54 74 10 f0       	push   $0xf0107454
f0106b70:	6a 6f                	push   $0x6f
f0106b72:	68 9d 96 10 f0       	push   $0xf010969d
f0106b77:	e8 cd 94 ff ff       	call   f0100049 <_panic>
		p = *(uint16_t *) (bda + 0x13) * 1024;
f0106b7c:	0f b7 05 13 04 00 f0 	movzwl 0xf0000413,%eax
f0106b83:	c1 e0 0a             	shl    $0xa,%eax
		if ((mp = mpsearch1(p - 1024, 1024)))
f0106b86:	2d 00 04 00 00       	sub    $0x400,%eax
f0106b8b:	ba 00 04 00 00       	mov    $0x400,%edx
f0106b90:	e8 72 fe ff ff       	call   f0106a07 <mpsearch1>
f0106b95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0106b98:	85 c0                	test   %eax,%eax
f0106b9a:	0f 85 60 ff ff ff    	jne    f0106b00 <mp_init+0x5d>
f0106ba0:	e9 41 ff ff ff       	jmp    f0106ae6 <mp_init+0x43>
		cprintf("SMP: Default configurations not implemented\n");
f0106ba5:	83 ec 0c             	sub    $0xc,%esp
f0106ba8:	68 10 95 10 f0       	push   $0xf0109510
f0106bad:	e8 37 da ff ff       	call   f01045e9 <cprintf>
f0106bb2:	83 c4 10             	add    $0x10,%esp
f0106bb5:	e9 77 01 00 00       	jmp    f0106d31 <mp_init+0x28e>
f0106bba:	53                   	push   %ebx
f0106bbb:	68 54 74 10 f0       	push   $0xf0107454
f0106bc0:	68 90 00 00 00       	push   $0x90
f0106bc5:	68 9d 96 10 f0       	push   $0xf010969d
f0106bca:	e8 7a 94 ff ff       	call   f0100049 <_panic>
		cprintf("SMP: Incorrect MP configuration table signature\n");
f0106bcf:	83 ec 0c             	sub    $0xc,%esp
f0106bd2:	68 40 95 10 f0       	push   $0xf0109540
f0106bd7:	e8 0d da ff ff       	call   f01045e9 <cprintf>
f0106bdc:	83 c4 10             	add    $0x10,%esp
f0106bdf:	e9 4d 01 00 00       	jmp    f0106d31 <mp_init+0x28e>
	if (sum(conf, conf->length) != 0) {
f0106be4:	84 d2                	test   %dl,%dl
f0106be6:	75 16                	jne    f0106bfe <mp_init+0x15b>
	if (conf->version != 1 && conf->version != 4) {
f0106be8:	0f b6 56 06          	movzbl 0x6(%esi),%edx
f0106bec:	80 fa 01             	cmp    $0x1,%dl
f0106bef:	74 05                	je     f0106bf6 <mp_init+0x153>
f0106bf1:	80 fa 04             	cmp    $0x4,%dl
f0106bf4:	75 1d                	jne    f0106c13 <mp_init+0x170>
f0106bf6:	0f b7 4e 28          	movzwl 0x28(%esi),%ecx
f0106bfa:	01 d9                	add    %ebx,%ecx
f0106bfc:	eb 36                	jmp    f0106c34 <mp_init+0x191>
		cprintf("SMP: Bad MP configuration checksum\n");
f0106bfe:	83 ec 0c             	sub    $0xc,%esp
f0106c01:	68 74 95 10 f0       	push   $0xf0109574
f0106c06:	e8 de d9 ff ff       	call   f01045e9 <cprintf>
f0106c0b:	83 c4 10             	add    $0x10,%esp
f0106c0e:	e9 1e 01 00 00       	jmp    f0106d31 <mp_init+0x28e>
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
f0106c13:	83 ec 08             	sub    $0x8,%esp
f0106c16:	0f b6 d2             	movzbl %dl,%edx
f0106c19:	52                   	push   %edx
f0106c1a:	68 98 95 10 f0       	push   $0xf0109598
f0106c1f:	e8 c5 d9 ff ff       	call   f01045e9 <cprintf>
f0106c24:	83 c4 10             	add    $0x10,%esp
f0106c27:	e9 05 01 00 00       	jmp    f0106d31 <mp_init+0x28e>
		sum += ((uint8_t *)addr)[i];
f0106c2c:	0f b6 13             	movzbl (%ebx),%edx
f0106c2f:	01 d0                	add    %edx,%eax
f0106c31:	83 c3 01             	add    $0x1,%ebx
	for (i = 0; i < len; i++)
f0106c34:	39 d9                	cmp    %ebx,%ecx
f0106c36:	75 f4                	jne    f0106c2c <mp_init+0x189>
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
f0106c38:	02 46 2a             	add    0x2a(%esi),%al
f0106c3b:	75 1c                	jne    f0106c59 <mp_init+0x1b6>
	if ((conf = mpconfig(&mp)) == 0)
		return;
	ismp = 1;
f0106c3d:	c7 05 00 60 34 f0 01 	movl   $0x1,0xf0346000
f0106c44:	00 00 00 
	lapicaddr = conf->lapicaddr;
f0106c47:	8b 46 24             	mov    0x24(%esi),%eax
f0106c4a:	a3 00 70 38 f0       	mov    %eax,0xf0387000

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0106c4f:	8d 7e 2c             	lea    0x2c(%esi),%edi
f0106c52:	bb 00 00 00 00       	mov    $0x0,%ebx
f0106c57:	eb 4d                	jmp    f0106ca6 <mp_init+0x203>
		cprintf("SMP: Bad MP configuration extended checksum\n");
f0106c59:	83 ec 0c             	sub    $0xc,%esp
f0106c5c:	68 b8 95 10 f0       	push   $0xf01095b8
f0106c61:	e8 83 d9 ff ff       	call   f01045e9 <cprintf>
f0106c66:	83 c4 10             	add    $0x10,%esp
f0106c69:	e9 c3 00 00 00       	jmp    f0106d31 <mp_init+0x28e>
		switch (*p) {
		case MPPROC:
			proc = (struct mpproc *)p;
			if (proc->flags & MPPROC_BOOT)
f0106c6e:	f6 47 03 02          	testb  $0x2,0x3(%edi)
f0106c72:	74 11                	je     f0106c85 <mp_init+0x1e2>
				bootcpu = &cpus[ncpu];
f0106c74:	6b 05 c4 63 34 f0 74 	imul   $0x74,0xf03463c4,%eax
f0106c7b:	05 20 60 34 f0       	add    $0xf0346020,%eax
f0106c80:	a3 c0 63 34 f0       	mov    %eax,0xf03463c0
			if (ncpu < NCPU) {
f0106c85:	a1 c4 63 34 f0       	mov    0xf03463c4,%eax
f0106c8a:	83 f8 07             	cmp    $0x7,%eax
f0106c8d:	7f 2f                	jg     f0106cbe <mp_init+0x21b>
				cpus[ncpu].cpu_id = ncpu;
f0106c8f:	6b d0 74             	imul   $0x74,%eax,%edx
f0106c92:	88 82 20 60 34 f0    	mov    %al,-0xfcb9fe0(%edx)
				ncpu++;
f0106c98:	83 c0 01             	add    $0x1,%eax
f0106c9b:	a3 c4 63 34 f0       	mov    %eax,0xf03463c4
			} else {
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
					proc->apicid);
			}
			p += sizeof(struct mpproc);
f0106ca0:	83 c7 14             	add    $0x14,%edi
	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0106ca3:	83 c3 01             	add    $0x1,%ebx
f0106ca6:	0f b7 46 22          	movzwl 0x22(%esi),%eax
f0106caa:	39 d8                	cmp    %ebx,%eax
f0106cac:	76 4b                	jbe    f0106cf9 <mp_init+0x256>
		switch (*p) {
f0106cae:	0f b6 07             	movzbl (%edi),%eax
f0106cb1:	84 c0                	test   %al,%al
f0106cb3:	74 b9                	je     f0106c6e <mp_init+0x1cb>
f0106cb5:	3c 04                	cmp    $0x4,%al
f0106cb7:	77 1c                	ja     f0106cd5 <mp_init+0x232>
			continue;
		case MPBUS:
		case MPIOAPIC:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
f0106cb9:	83 c7 08             	add    $0x8,%edi
			continue;
f0106cbc:	eb e5                	jmp    f0106ca3 <mp_init+0x200>
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
f0106cbe:	83 ec 08             	sub    $0x8,%esp
f0106cc1:	0f b6 47 01          	movzbl 0x1(%edi),%eax
f0106cc5:	50                   	push   %eax
f0106cc6:	68 e8 95 10 f0       	push   $0xf01095e8
f0106ccb:	e8 19 d9 ff ff       	call   f01045e9 <cprintf>
f0106cd0:	83 c4 10             	add    $0x10,%esp
f0106cd3:	eb cb                	jmp    f0106ca0 <mp_init+0x1fd>
		default:
			cprintf("mpinit: unknown config type %x\n", *p);
f0106cd5:	83 ec 08             	sub    $0x8,%esp
		switch (*p) {
f0106cd8:	0f b6 c0             	movzbl %al,%eax
			cprintf("mpinit: unknown config type %x\n", *p);
f0106cdb:	50                   	push   %eax
f0106cdc:	68 10 96 10 f0       	push   $0xf0109610
f0106ce1:	e8 03 d9 ff ff       	call   f01045e9 <cprintf>
			ismp = 0;
f0106ce6:	c7 05 00 60 34 f0 00 	movl   $0x0,0xf0346000
f0106ced:	00 00 00 
			i = conf->entry;
f0106cf0:	0f b7 5e 22          	movzwl 0x22(%esi),%ebx
f0106cf4:	83 c4 10             	add    $0x10,%esp
f0106cf7:	eb aa                	jmp    f0106ca3 <mp_init+0x200>
		}
	}

	bootcpu->cpu_status = CPU_STARTED;
f0106cf9:	a1 c0 63 34 f0       	mov    0xf03463c0,%eax
f0106cfe:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	if (!ismp) {
f0106d05:	83 3d 00 60 34 f0 00 	cmpl   $0x0,0xf0346000
f0106d0c:	74 2b                	je     f0106d39 <mp_init+0x296>
		ncpu = 1;
		lapicaddr = 0;
		cprintf("SMP: configuration not found, SMP disabled\n");
		return;
	}
	cprintf("SMP: CPU %d found %d CPU(s)\n", bootcpu->cpu_id,  ncpu);
f0106d0e:	83 ec 04             	sub    $0x4,%esp
f0106d11:	ff 35 c4 63 34 f0    	pushl  0xf03463c4
f0106d17:	0f b6 00             	movzbl (%eax),%eax
f0106d1a:	50                   	push   %eax
f0106d1b:	68 b7 96 10 f0       	push   $0xf01096b7
f0106d20:	e8 c4 d8 ff ff       	call   f01045e9 <cprintf>

	if (mp->imcrp) {
f0106d25:	83 c4 10             	add    $0x10,%esp
f0106d28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0106d2b:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
f0106d2f:	75 2e                	jne    f0106d5f <mp_init+0x2bc>
		// switch to getting interrupts from the LAPIC.
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
		outb(0x22, 0x70);   // Select IMCR
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
	}
}
f0106d31:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106d34:	5b                   	pop    %ebx
f0106d35:	5e                   	pop    %esi
f0106d36:	5f                   	pop    %edi
f0106d37:	5d                   	pop    %ebp
f0106d38:	c3                   	ret    
		ncpu = 1;
f0106d39:	c7 05 c4 63 34 f0 01 	movl   $0x1,0xf03463c4
f0106d40:	00 00 00 
		lapicaddr = 0;
f0106d43:	c7 05 00 70 38 f0 00 	movl   $0x0,0xf0387000
f0106d4a:	00 00 00 
		cprintf("SMP: configuration not found, SMP disabled\n");
f0106d4d:	83 ec 0c             	sub    $0xc,%esp
f0106d50:	68 30 96 10 f0       	push   $0xf0109630
f0106d55:	e8 8f d8 ff ff       	call   f01045e9 <cprintf>
		return;
f0106d5a:	83 c4 10             	add    $0x10,%esp
f0106d5d:	eb d2                	jmp    f0106d31 <mp_init+0x28e>
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
f0106d5f:	83 ec 0c             	sub    $0xc,%esp
f0106d62:	68 5c 96 10 f0       	push   $0xf010965c
f0106d67:	e8 7d d8 ff ff       	call   f01045e9 <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0106d6c:	b8 70 00 00 00       	mov    $0x70,%eax
f0106d71:	ba 22 00 00 00       	mov    $0x22,%edx
f0106d76:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0106d77:	ba 23 00 00 00       	mov    $0x23,%edx
f0106d7c:	ec                   	in     (%dx),%al
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
f0106d7d:	83 c8 01             	or     $0x1,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0106d80:	ee                   	out    %al,(%dx)
f0106d81:	83 c4 10             	add    $0x10,%esp
f0106d84:	eb ab                	jmp    f0106d31 <mp_init+0x28e>

f0106d86 <lapicw>:
volatile uint32_t *lapic;

static void
lapicw(int index, int value)
{
	lapic[index] = value;
f0106d86:	8b 0d 04 70 38 f0    	mov    0xf0387004,%ecx
f0106d8c:	8d 04 81             	lea    (%ecx,%eax,4),%eax
f0106d8f:	89 10                	mov    %edx,(%eax)
	lapic[ID];  // wait for write to finish, by reading
f0106d91:	a1 04 70 38 f0       	mov    0xf0387004,%eax
f0106d96:	8b 40 20             	mov    0x20(%eax),%eax
}
f0106d99:	c3                   	ret    

f0106d9a <cpunum>:
}

int
cpunum(void)
{
	if (lapic)
f0106d9a:	8b 15 04 70 38 f0    	mov    0xf0387004,%edx
		return lapic[ID] >> 24;
	return 0;
f0106da0:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lapic)
f0106da5:	85 d2                	test   %edx,%edx
f0106da7:	74 06                	je     f0106daf <cpunum+0x15>
		return lapic[ID] >> 24;
f0106da9:	8b 42 20             	mov    0x20(%edx),%eax
f0106dac:	c1 e8 18             	shr    $0x18,%eax
}
f0106daf:	c3                   	ret    

f0106db0 <lapic_init>:
	if (!lapicaddr)
f0106db0:	a1 00 70 38 f0       	mov    0xf0387000,%eax
f0106db5:	85 c0                	test   %eax,%eax
f0106db7:	75 01                	jne    f0106dba <lapic_init+0xa>
f0106db9:	c3                   	ret    
{
f0106dba:	55                   	push   %ebp
f0106dbb:	89 e5                	mov    %esp,%ebp
f0106dbd:	83 ec 10             	sub    $0x10,%esp
	lapic = mmio_map_region(lapicaddr, 4096);
f0106dc0:	68 00 10 00 00       	push   $0x1000
f0106dc5:	50                   	push   %eax
f0106dc6:	e8 33 b0 ff ff       	call   f0101dfe <mmio_map_region>
f0106dcb:	a3 04 70 38 f0       	mov    %eax,0xf0387004
	lapicw(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));
f0106dd0:	ba 27 01 00 00       	mov    $0x127,%edx
f0106dd5:	b8 3c 00 00 00       	mov    $0x3c,%eax
f0106dda:	e8 a7 ff ff ff       	call   f0106d86 <lapicw>
	lapicw(TDCR, X1);
f0106ddf:	ba 0b 00 00 00       	mov    $0xb,%edx
f0106de4:	b8 f8 00 00 00       	mov    $0xf8,%eax
f0106de9:	e8 98 ff ff ff       	call   f0106d86 <lapicw>
	lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
f0106dee:	ba 20 00 02 00       	mov    $0x20020,%edx
f0106df3:	b8 c8 00 00 00       	mov    $0xc8,%eax
f0106df8:	e8 89 ff ff ff       	call   f0106d86 <lapicw>
	lapicw(TICR, 10000000); 
f0106dfd:	ba 80 96 98 00       	mov    $0x989680,%edx
f0106e02:	b8 e0 00 00 00       	mov    $0xe0,%eax
f0106e07:	e8 7a ff ff ff       	call   f0106d86 <lapicw>
	if (thiscpu != bootcpu)
f0106e0c:	e8 89 ff ff ff       	call   f0106d9a <cpunum>
f0106e11:	6b c0 74             	imul   $0x74,%eax,%eax
f0106e14:	05 20 60 34 f0       	add    $0xf0346020,%eax
f0106e19:	83 c4 10             	add    $0x10,%esp
f0106e1c:	39 05 c0 63 34 f0    	cmp    %eax,0xf03463c0
f0106e22:	74 0f                	je     f0106e33 <lapic_init+0x83>
		lapicw(LINT0, MASKED);
f0106e24:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106e29:	b8 d4 00 00 00       	mov    $0xd4,%eax
f0106e2e:	e8 53 ff ff ff       	call   f0106d86 <lapicw>
	lapicw(LINT1, MASKED);
f0106e33:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106e38:	b8 d8 00 00 00       	mov    $0xd8,%eax
f0106e3d:	e8 44 ff ff ff       	call   f0106d86 <lapicw>
	if (((lapic[VER]>>16) & 0xFF) >= 4)
f0106e42:	a1 04 70 38 f0       	mov    0xf0387004,%eax
f0106e47:	8b 40 30             	mov    0x30(%eax),%eax
f0106e4a:	c1 e8 10             	shr    $0x10,%eax
f0106e4d:	a8 fc                	test   $0xfc,%al
f0106e4f:	75 7c                	jne    f0106ecd <lapic_init+0x11d>
	lapicw(ERROR, IRQ_OFFSET + IRQ_ERROR);
f0106e51:	ba 33 00 00 00       	mov    $0x33,%edx
f0106e56:	b8 dc 00 00 00       	mov    $0xdc,%eax
f0106e5b:	e8 26 ff ff ff       	call   f0106d86 <lapicw>
	lapicw(ESR, 0);
f0106e60:	ba 00 00 00 00       	mov    $0x0,%edx
f0106e65:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0106e6a:	e8 17 ff ff ff       	call   f0106d86 <lapicw>
	lapicw(ESR, 0);
f0106e6f:	ba 00 00 00 00       	mov    $0x0,%edx
f0106e74:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0106e79:	e8 08 ff ff ff       	call   f0106d86 <lapicw>
	lapicw(EOI, 0);
f0106e7e:	ba 00 00 00 00       	mov    $0x0,%edx
f0106e83:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0106e88:	e8 f9 fe ff ff       	call   f0106d86 <lapicw>
	lapicw(ICRHI, 0);
f0106e8d:	ba 00 00 00 00       	mov    $0x0,%edx
f0106e92:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106e97:	e8 ea fe ff ff       	call   f0106d86 <lapicw>
	lapicw(ICRLO, BCAST | INIT | LEVEL);
f0106e9c:	ba 00 85 08 00       	mov    $0x88500,%edx
f0106ea1:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106ea6:	e8 db fe ff ff       	call   f0106d86 <lapicw>
	while(lapic[ICRLO] & DELIVS)
f0106eab:	8b 15 04 70 38 f0    	mov    0xf0387004,%edx
f0106eb1:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0106eb7:	f6 c4 10             	test   $0x10,%ah
f0106eba:	75 f5                	jne    f0106eb1 <lapic_init+0x101>
	lapicw(TPR, 0);
f0106ebc:	ba 00 00 00 00       	mov    $0x0,%edx
f0106ec1:	b8 20 00 00 00       	mov    $0x20,%eax
f0106ec6:	e8 bb fe ff ff       	call   f0106d86 <lapicw>
}
f0106ecb:	c9                   	leave  
f0106ecc:	c3                   	ret    
		lapicw(PCINT, MASKED);
f0106ecd:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106ed2:	b8 d0 00 00 00       	mov    $0xd0,%eax
f0106ed7:	e8 aa fe ff ff       	call   f0106d86 <lapicw>
f0106edc:	e9 70 ff ff ff       	jmp    f0106e51 <lapic_init+0xa1>

f0106ee1 <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
	if (lapic)
f0106ee1:	83 3d 04 70 38 f0 00 	cmpl   $0x0,0xf0387004
f0106ee8:	74 17                	je     f0106f01 <lapic_eoi+0x20>
{
f0106eea:	55                   	push   %ebp
f0106eeb:	89 e5                	mov    %esp,%ebp
f0106eed:	83 ec 08             	sub    $0x8,%esp
		lapicw(EOI, 0);
f0106ef0:	ba 00 00 00 00       	mov    $0x0,%edx
f0106ef5:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0106efa:	e8 87 fe ff ff       	call   f0106d86 <lapicw>
}
f0106eff:	c9                   	leave  
f0106f00:	c3                   	ret    
f0106f01:	c3                   	ret    

f0106f02 <lapic_startap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr)
{
f0106f02:	55                   	push   %ebp
f0106f03:	89 e5                	mov    %esp,%ebp
f0106f05:	56                   	push   %esi
f0106f06:	53                   	push   %ebx
f0106f07:	8b 75 08             	mov    0x8(%ebp),%esi
f0106f0a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0106f0d:	b8 0f 00 00 00       	mov    $0xf,%eax
f0106f12:	ba 70 00 00 00       	mov    $0x70,%edx
f0106f17:	ee                   	out    %al,(%dx)
f0106f18:	b8 0a 00 00 00       	mov    $0xa,%eax
f0106f1d:	ba 71 00 00 00       	mov    $0x71,%edx
f0106f22:	ee                   	out    %al,(%dx)
	if (PGNUM(pa) >= npages)
f0106f23:	83 3d 88 5e 34 f0 00 	cmpl   $0x0,0xf0345e88
f0106f2a:	74 7e                	je     f0106faa <lapic_startap+0xa8>
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
	outb(IO_RTC+1, 0x0A);
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
	wrv[0] = 0;
f0106f2c:	66 c7 05 67 04 00 f0 	movw   $0x0,0xf0000467
f0106f33:	00 00 
	wrv[1] = addr >> 4;
f0106f35:	89 d8                	mov    %ebx,%eax
f0106f37:	c1 e8 04             	shr    $0x4,%eax
f0106f3a:	66 a3 69 04 00 f0    	mov    %ax,0xf0000469

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f0106f40:	c1 e6 18             	shl    $0x18,%esi
f0106f43:	89 f2                	mov    %esi,%edx
f0106f45:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106f4a:	e8 37 fe ff ff       	call   f0106d86 <lapicw>
	lapicw(ICRLO, INIT | LEVEL | ASSERT);
f0106f4f:	ba 00 c5 00 00       	mov    $0xc500,%edx
f0106f54:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106f59:	e8 28 fe ff ff       	call   f0106d86 <lapicw>
	microdelay(200);
	lapicw(ICRLO, INIT | LEVEL);
f0106f5e:	ba 00 85 00 00       	mov    $0x8500,%edx
f0106f63:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106f68:	e8 19 fe ff ff       	call   f0106d86 <lapicw>
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106f6d:	c1 eb 0c             	shr    $0xc,%ebx
f0106f70:	80 cf 06             	or     $0x6,%bh
		lapicw(ICRHI, apicid << 24);
f0106f73:	89 f2                	mov    %esi,%edx
f0106f75:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106f7a:	e8 07 fe ff ff       	call   f0106d86 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106f7f:	89 da                	mov    %ebx,%edx
f0106f81:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106f86:	e8 fb fd ff ff       	call   f0106d86 <lapicw>
		lapicw(ICRHI, apicid << 24);
f0106f8b:	89 f2                	mov    %esi,%edx
f0106f8d:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106f92:	e8 ef fd ff ff       	call   f0106d86 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106f97:	89 da                	mov    %ebx,%edx
f0106f99:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106f9e:	e8 e3 fd ff ff       	call   f0106d86 <lapicw>
		microdelay(200);
	}
}
f0106fa3:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0106fa6:	5b                   	pop    %ebx
f0106fa7:	5e                   	pop    %esi
f0106fa8:	5d                   	pop    %ebp
f0106fa9:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106faa:	68 67 04 00 00       	push   $0x467
f0106faf:	68 54 74 10 f0       	push   $0xf0107454
f0106fb4:	68 98 00 00 00       	push   $0x98
f0106fb9:	68 d4 96 10 f0       	push   $0xf01096d4
f0106fbe:	e8 86 90 ff ff       	call   f0100049 <_panic>

f0106fc3 <lapic_ipi>:

void
lapic_ipi(int vector)
{
f0106fc3:	55                   	push   %ebp
f0106fc4:	89 e5                	mov    %esp,%ebp
f0106fc6:	83 ec 08             	sub    $0x8,%esp
	lapicw(ICRLO, OTHERS | FIXED | vector);
f0106fc9:	8b 55 08             	mov    0x8(%ebp),%edx
f0106fcc:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
f0106fd2:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106fd7:	e8 aa fd ff ff       	call   f0106d86 <lapicw>
	while (lapic[ICRLO] & DELIVS)
f0106fdc:	8b 15 04 70 38 f0    	mov    0xf0387004,%edx
f0106fe2:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0106fe8:	f6 c4 10             	test   $0x10,%ah
f0106feb:	75 f5                	jne    f0106fe2 <lapic_ipi+0x1f>
		;
}
f0106fed:	c9                   	leave  
f0106fee:	c3                   	ret    

f0106fef <__spin_initlock>:
}
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
f0106fef:	55                   	push   %ebp
f0106ff0:	89 e5                	mov    %esp,%ebp
f0106ff2:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->locked = 0;
f0106ff5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f0106ffb:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106ffe:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu = 0;
f0107001:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
#endif
}
f0107008:	5d                   	pop    %ebp
f0107009:	c3                   	ret    

f010700a <spin_lock>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
f010700a:	55                   	push   %ebp
f010700b:	89 e5                	mov    %esp,%ebp
f010700d:	56                   	push   %esi
f010700e:	53                   	push   %ebx
f010700f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	return lock->locked && lock->cpu == thiscpu;
f0107012:	83 3b 00             	cmpl   $0x0,(%ebx)
f0107015:	75 12                	jne    f0107029 <spin_lock+0x1f>
	asm volatile("lock; xchgl %0, %1"
f0107017:	ba 01 00 00 00       	mov    $0x1,%edx
f010701c:	89 d0                	mov    %edx,%eax
f010701e:	f0 87 03             	lock xchg %eax,(%ebx)
#endif

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
f0107021:	85 c0                	test   %eax,%eax
f0107023:	74 36                	je     f010705b <spin_lock+0x51>
		asm volatile ("pause");
f0107025:	f3 90                	pause  
f0107027:	eb f3                	jmp    f010701c <spin_lock+0x12>
	return lock->locked && lock->cpu == thiscpu;
f0107029:	8b 73 08             	mov    0x8(%ebx),%esi
f010702c:	e8 69 fd ff ff       	call   f0106d9a <cpunum>
f0107031:	6b c0 74             	imul   $0x74,%eax,%eax
f0107034:	05 20 60 34 f0       	add    $0xf0346020,%eax
	if (holding(lk))
f0107039:	39 c6                	cmp    %eax,%esi
f010703b:	75 da                	jne    f0107017 <spin_lock+0xd>
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
f010703d:	8b 5b 04             	mov    0x4(%ebx),%ebx
f0107040:	e8 55 fd ff ff       	call   f0106d9a <cpunum>
f0107045:	83 ec 0c             	sub    $0xc,%esp
f0107048:	53                   	push   %ebx
f0107049:	50                   	push   %eax
f010704a:	68 e4 96 10 f0       	push   $0xf01096e4
f010704f:	6a 41                	push   $0x41
f0107051:	68 48 97 10 f0       	push   $0xf0109748
f0107056:	e8 ee 8f ff ff       	call   f0100049 <_panic>

	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
f010705b:	e8 3a fd ff ff       	call   f0106d9a <cpunum>
f0107060:	6b c0 74             	imul   $0x74,%eax,%eax
f0107063:	05 20 60 34 f0       	add    $0xf0346020,%eax
f0107068:	89 43 08             	mov    %eax,0x8(%ebx)
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f010706b:	89 ea                	mov    %ebp,%edx
	for (i = 0; i < 10; i++){
f010706d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f0107072:	83 f8 09             	cmp    $0x9,%eax
f0107075:	7f 16                	jg     f010708d <spin_lock+0x83>
f0107077:	81 fa ff ff 7f ef    	cmp    $0xef7fffff,%edx
f010707d:	76 0e                	jbe    f010708d <spin_lock+0x83>
		pcs[i] = ebp[1];          // saved %eip
f010707f:	8b 4a 04             	mov    0x4(%edx),%ecx
f0107082:	89 4c 83 0c          	mov    %ecx,0xc(%ebx,%eax,4)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f0107086:	8b 12                	mov    (%edx),%edx
	for (i = 0; i < 10; i++){
f0107088:	83 c0 01             	add    $0x1,%eax
f010708b:	eb e5                	jmp    f0107072 <spin_lock+0x68>
	for (; i < 10; i++)
f010708d:	83 f8 09             	cmp    $0x9,%eax
f0107090:	7f 0d                	jg     f010709f <spin_lock+0x95>
		pcs[i] = 0;
f0107092:	c7 44 83 0c 00 00 00 	movl   $0x0,0xc(%ebx,%eax,4)
f0107099:	00 
	for (; i < 10; i++)
f010709a:	83 c0 01             	add    $0x1,%eax
f010709d:	eb ee                	jmp    f010708d <spin_lock+0x83>
	get_caller_pcs(lk->pcs);
#endif
}
f010709f:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01070a2:	5b                   	pop    %ebx
f01070a3:	5e                   	pop    %esi
f01070a4:	5d                   	pop    %ebp
f01070a5:	c3                   	ret    

f01070a6 <spin_unlock>:

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
f01070a6:	55                   	push   %ebp
f01070a7:	89 e5                	mov    %esp,%ebp
f01070a9:	57                   	push   %edi
f01070aa:	56                   	push   %esi
f01070ab:	53                   	push   %ebx
f01070ac:	83 ec 4c             	sub    $0x4c,%esp
f01070af:	8b 75 08             	mov    0x8(%ebp),%esi
	return lock->locked && lock->cpu == thiscpu;
f01070b2:	83 3e 00             	cmpl   $0x0,(%esi)
f01070b5:	75 35                	jne    f01070ec <spin_unlock+0x46>
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
f01070b7:	83 ec 04             	sub    $0x4,%esp
f01070ba:	6a 28                	push   $0x28
f01070bc:	8d 46 0c             	lea    0xc(%esi),%eax
f01070bf:	50                   	push   %eax
f01070c0:	8d 5d c0             	lea    -0x40(%ebp),%ebx
f01070c3:	53                   	push   %ebx
f01070c4:	e8 13 f7 ff ff       	call   f01067dc <memmove>
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
f01070c9:	8b 46 08             	mov    0x8(%esi),%eax
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
f01070cc:	0f b6 38             	movzbl (%eax),%edi
f01070cf:	8b 76 04             	mov    0x4(%esi),%esi
f01070d2:	e8 c3 fc ff ff       	call   f0106d9a <cpunum>
f01070d7:	57                   	push   %edi
f01070d8:	56                   	push   %esi
f01070d9:	50                   	push   %eax
f01070da:	68 10 97 10 f0       	push   $0xf0109710
f01070df:	e8 05 d5 ff ff       	call   f01045e9 <cprintf>
f01070e4:	83 c4 20             	add    $0x20,%esp
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
f01070e7:	8d 7d a8             	lea    -0x58(%ebp),%edi
f01070ea:	eb 4e                	jmp    f010713a <spin_unlock+0x94>
	return lock->locked && lock->cpu == thiscpu;
f01070ec:	8b 5e 08             	mov    0x8(%esi),%ebx
f01070ef:	e8 a6 fc ff ff       	call   f0106d9a <cpunum>
f01070f4:	6b c0 74             	imul   $0x74,%eax,%eax
f01070f7:	05 20 60 34 f0       	add    $0xf0346020,%eax
	if (!holding(lk)) {
f01070fc:	39 c3                	cmp    %eax,%ebx
f01070fe:	75 b7                	jne    f01070b7 <spin_unlock+0x11>
				cprintf("  %08x\n", pcs[i]);
		}
		panic("spin_unlock");
	}

	lk->pcs[0] = 0;
f0107100:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
	lk->cpu = 0;
f0107107:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
	asm volatile("lock; xchgl %0, %1"
f010710e:	b8 00 00 00 00       	mov    $0x0,%eax
f0107113:	f0 87 06             	lock xchg %eax,(%esi)
	// respect to any other instruction which references the same memory.
	// x86 CPUs will not reorder loads/stores across locked instructions
	// (vol 3, 8.2.2). Because xchg() is implemented using asm volatile,
	// gcc will not reorder C statements across the xchg.
	xchg(&lk->locked, 0);
}
f0107116:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0107119:	5b                   	pop    %ebx
f010711a:	5e                   	pop    %esi
f010711b:	5f                   	pop    %edi
f010711c:	5d                   	pop    %ebp
f010711d:	c3                   	ret    
				cprintf("  %08x\n", pcs[i]);
f010711e:	83 ec 08             	sub    $0x8,%esp
f0107121:	ff 36                	pushl  (%esi)
f0107123:	68 6f 97 10 f0       	push   $0xf010976f
f0107128:	e8 bc d4 ff ff       	call   f01045e9 <cprintf>
f010712d:	83 c4 10             	add    $0x10,%esp
f0107130:	83 c3 04             	add    $0x4,%ebx
		for (i = 0; i < 10 && pcs[i]; i++) {
f0107133:	8d 45 e8             	lea    -0x18(%ebp),%eax
f0107136:	39 c3                	cmp    %eax,%ebx
f0107138:	74 40                	je     f010717a <spin_unlock+0xd4>
f010713a:	89 de                	mov    %ebx,%esi
f010713c:	8b 03                	mov    (%ebx),%eax
f010713e:	85 c0                	test   %eax,%eax
f0107140:	74 38                	je     f010717a <spin_unlock+0xd4>
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0107142:	83 ec 08             	sub    $0x8,%esp
f0107145:	57                   	push   %edi
f0107146:	50                   	push   %eax
f0107147:	e8 12 ea ff ff       	call   f0105b5e <debuginfo_eip>
f010714c:	83 c4 10             	add    $0x10,%esp
f010714f:	85 c0                	test   %eax,%eax
f0107151:	78 cb                	js     f010711e <spin_unlock+0x78>
					pcs[i] - info.eip_fn_addr);
f0107153:	8b 06                	mov    (%esi),%eax
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
f0107155:	83 ec 04             	sub    $0x4,%esp
f0107158:	89 c2                	mov    %eax,%edx
f010715a:	2b 55 b8             	sub    -0x48(%ebp),%edx
f010715d:	52                   	push   %edx
f010715e:	ff 75 b0             	pushl  -0x50(%ebp)
f0107161:	ff 75 b4             	pushl  -0x4c(%ebp)
f0107164:	ff 75 ac             	pushl  -0x54(%ebp)
f0107167:	ff 75 a8             	pushl  -0x58(%ebp)
f010716a:	50                   	push   %eax
f010716b:	68 58 97 10 f0       	push   $0xf0109758
f0107170:	e8 74 d4 ff ff       	call   f01045e9 <cprintf>
f0107175:	83 c4 20             	add    $0x20,%esp
f0107178:	eb b6                	jmp    f0107130 <spin_unlock+0x8a>
		panic("spin_unlock");
f010717a:	83 ec 04             	sub    $0x4,%esp
f010717d:	68 77 97 10 f0       	push   $0xf0109777
f0107182:	6a 67                	push   $0x67
f0107184:	68 48 97 10 f0       	push   $0xf0109748
f0107189:	e8 bb 8e ff ff       	call   f0100049 <_panic>
f010718e:	66 90                	xchg   %ax,%ax

f0107190 <__udivdi3>:
f0107190:	55                   	push   %ebp
f0107191:	57                   	push   %edi
f0107192:	56                   	push   %esi
f0107193:	53                   	push   %ebx
f0107194:	83 ec 1c             	sub    $0x1c,%esp
f0107197:	8b 54 24 3c          	mov    0x3c(%esp),%edx
f010719b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f010719f:	8b 74 24 34          	mov    0x34(%esp),%esi
f01071a3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f01071a7:	85 d2                	test   %edx,%edx
f01071a9:	75 4d                	jne    f01071f8 <__udivdi3+0x68>
f01071ab:	39 f3                	cmp    %esi,%ebx
f01071ad:	76 19                	jbe    f01071c8 <__udivdi3+0x38>
f01071af:	31 ff                	xor    %edi,%edi
f01071b1:	89 e8                	mov    %ebp,%eax
f01071b3:	89 f2                	mov    %esi,%edx
f01071b5:	f7 f3                	div    %ebx
f01071b7:	89 fa                	mov    %edi,%edx
f01071b9:	83 c4 1c             	add    $0x1c,%esp
f01071bc:	5b                   	pop    %ebx
f01071bd:	5e                   	pop    %esi
f01071be:	5f                   	pop    %edi
f01071bf:	5d                   	pop    %ebp
f01071c0:	c3                   	ret    
f01071c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01071c8:	89 d9                	mov    %ebx,%ecx
f01071ca:	85 db                	test   %ebx,%ebx
f01071cc:	75 0b                	jne    f01071d9 <__udivdi3+0x49>
f01071ce:	b8 01 00 00 00       	mov    $0x1,%eax
f01071d3:	31 d2                	xor    %edx,%edx
f01071d5:	f7 f3                	div    %ebx
f01071d7:	89 c1                	mov    %eax,%ecx
f01071d9:	31 d2                	xor    %edx,%edx
f01071db:	89 f0                	mov    %esi,%eax
f01071dd:	f7 f1                	div    %ecx
f01071df:	89 c6                	mov    %eax,%esi
f01071e1:	89 e8                	mov    %ebp,%eax
f01071e3:	89 f7                	mov    %esi,%edi
f01071e5:	f7 f1                	div    %ecx
f01071e7:	89 fa                	mov    %edi,%edx
f01071e9:	83 c4 1c             	add    $0x1c,%esp
f01071ec:	5b                   	pop    %ebx
f01071ed:	5e                   	pop    %esi
f01071ee:	5f                   	pop    %edi
f01071ef:	5d                   	pop    %ebp
f01071f0:	c3                   	ret    
f01071f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01071f8:	39 f2                	cmp    %esi,%edx
f01071fa:	77 1c                	ja     f0107218 <__udivdi3+0x88>
f01071fc:	0f bd fa             	bsr    %edx,%edi
f01071ff:	83 f7 1f             	xor    $0x1f,%edi
f0107202:	75 2c                	jne    f0107230 <__udivdi3+0xa0>
f0107204:	39 f2                	cmp    %esi,%edx
f0107206:	72 06                	jb     f010720e <__udivdi3+0x7e>
f0107208:	31 c0                	xor    %eax,%eax
f010720a:	39 eb                	cmp    %ebp,%ebx
f010720c:	77 a9                	ja     f01071b7 <__udivdi3+0x27>
f010720e:	b8 01 00 00 00       	mov    $0x1,%eax
f0107213:	eb a2                	jmp    f01071b7 <__udivdi3+0x27>
f0107215:	8d 76 00             	lea    0x0(%esi),%esi
f0107218:	31 ff                	xor    %edi,%edi
f010721a:	31 c0                	xor    %eax,%eax
f010721c:	89 fa                	mov    %edi,%edx
f010721e:	83 c4 1c             	add    $0x1c,%esp
f0107221:	5b                   	pop    %ebx
f0107222:	5e                   	pop    %esi
f0107223:	5f                   	pop    %edi
f0107224:	5d                   	pop    %ebp
f0107225:	c3                   	ret    
f0107226:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f010722d:	8d 76 00             	lea    0x0(%esi),%esi
f0107230:	89 f9                	mov    %edi,%ecx
f0107232:	b8 20 00 00 00       	mov    $0x20,%eax
f0107237:	29 f8                	sub    %edi,%eax
f0107239:	d3 e2                	shl    %cl,%edx
f010723b:	89 54 24 08          	mov    %edx,0x8(%esp)
f010723f:	89 c1                	mov    %eax,%ecx
f0107241:	89 da                	mov    %ebx,%edx
f0107243:	d3 ea                	shr    %cl,%edx
f0107245:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0107249:	09 d1                	or     %edx,%ecx
f010724b:	89 f2                	mov    %esi,%edx
f010724d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0107251:	89 f9                	mov    %edi,%ecx
f0107253:	d3 e3                	shl    %cl,%ebx
f0107255:	89 c1                	mov    %eax,%ecx
f0107257:	d3 ea                	shr    %cl,%edx
f0107259:	89 f9                	mov    %edi,%ecx
f010725b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f010725f:	89 eb                	mov    %ebp,%ebx
f0107261:	d3 e6                	shl    %cl,%esi
f0107263:	89 c1                	mov    %eax,%ecx
f0107265:	d3 eb                	shr    %cl,%ebx
f0107267:	09 de                	or     %ebx,%esi
f0107269:	89 f0                	mov    %esi,%eax
f010726b:	f7 74 24 08          	divl   0x8(%esp)
f010726f:	89 d6                	mov    %edx,%esi
f0107271:	89 c3                	mov    %eax,%ebx
f0107273:	f7 64 24 0c          	mull   0xc(%esp)
f0107277:	39 d6                	cmp    %edx,%esi
f0107279:	72 15                	jb     f0107290 <__udivdi3+0x100>
f010727b:	89 f9                	mov    %edi,%ecx
f010727d:	d3 e5                	shl    %cl,%ebp
f010727f:	39 c5                	cmp    %eax,%ebp
f0107281:	73 04                	jae    f0107287 <__udivdi3+0xf7>
f0107283:	39 d6                	cmp    %edx,%esi
f0107285:	74 09                	je     f0107290 <__udivdi3+0x100>
f0107287:	89 d8                	mov    %ebx,%eax
f0107289:	31 ff                	xor    %edi,%edi
f010728b:	e9 27 ff ff ff       	jmp    f01071b7 <__udivdi3+0x27>
f0107290:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0107293:	31 ff                	xor    %edi,%edi
f0107295:	e9 1d ff ff ff       	jmp    f01071b7 <__udivdi3+0x27>
f010729a:	66 90                	xchg   %ax,%ax
f010729c:	66 90                	xchg   %ax,%ax
f010729e:	66 90                	xchg   %ax,%ax

f01072a0 <__umoddi3>:
f01072a0:	55                   	push   %ebp
f01072a1:	57                   	push   %edi
f01072a2:	56                   	push   %esi
f01072a3:	53                   	push   %ebx
f01072a4:	83 ec 1c             	sub    $0x1c,%esp
f01072a7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f01072ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
f01072af:	8b 74 24 30          	mov    0x30(%esp),%esi
f01072b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
f01072b7:	89 da                	mov    %ebx,%edx
f01072b9:	85 c0                	test   %eax,%eax
f01072bb:	75 43                	jne    f0107300 <__umoddi3+0x60>
f01072bd:	39 df                	cmp    %ebx,%edi
f01072bf:	76 17                	jbe    f01072d8 <__umoddi3+0x38>
f01072c1:	89 f0                	mov    %esi,%eax
f01072c3:	f7 f7                	div    %edi
f01072c5:	89 d0                	mov    %edx,%eax
f01072c7:	31 d2                	xor    %edx,%edx
f01072c9:	83 c4 1c             	add    $0x1c,%esp
f01072cc:	5b                   	pop    %ebx
f01072cd:	5e                   	pop    %esi
f01072ce:	5f                   	pop    %edi
f01072cf:	5d                   	pop    %ebp
f01072d0:	c3                   	ret    
f01072d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01072d8:	89 fd                	mov    %edi,%ebp
f01072da:	85 ff                	test   %edi,%edi
f01072dc:	75 0b                	jne    f01072e9 <__umoddi3+0x49>
f01072de:	b8 01 00 00 00       	mov    $0x1,%eax
f01072e3:	31 d2                	xor    %edx,%edx
f01072e5:	f7 f7                	div    %edi
f01072e7:	89 c5                	mov    %eax,%ebp
f01072e9:	89 d8                	mov    %ebx,%eax
f01072eb:	31 d2                	xor    %edx,%edx
f01072ed:	f7 f5                	div    %ebp
f01072ef:	89 f0                	mov    %esi,%eax
f01072f1:	f7 f5                	div    %ebp
f01072f3:	89 d0                	mov    %edx,%eax
f01072f5:	eb d0                	jmp    f01072c7 <__umoddi3+0x27>
f01072f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01072fe:	66 90                	xchg   %ax,%ax
f0107300:	89 f1                	mov    %esi,%ecx
f0107302:	39 d8                	cmp    %ebx,%eax
f0107304:	76 0a                	jbe    f0107310 <__umoddi3+0x70>
f0107306:	89 f0                	mov    %esi,%eax
f0107308:	83 c4 1c             	add    $0x1c,%esp
f010730b:	5b                   	pop    %ebx
f010730c:	5e                   	pop    %esi
f010730d:	5f                   	pop    %edi
f010730e:	5d                   	pop    %ebp
f010730f:	c3                   	ret    
f0107310:	0f bd e8             	bsr    %eax,%ebp
f0107313:	83 f5 1f             	xor    $0x1f,%ebp
f0107316:	75 20                	jne    f0107338 <__umoddi3+0x98>
f0107318:	39 d8                	cmp    %ebx,%eax
f010731a:	0f 82 b0 00 00 00    	jb     f01073d0 <__umoddi3+0x130>
f0107320:	39 f7                	cmp    %esi,%edi
f0107322:	0f 86 a8 00 00 00    	jbe    f01073d0 <__umoddi3+0x130>
f0107328:	89 c8                	mov    %ecx,%eax
f010732a:	83 c4 1c             	add    $0x1c,%esp
f010732d:	5b                   	pop    %ebx
f010732e:	5e                   	pop    %esi
f010732f:	5f                   	pop    %edi
f0107330:	5d                   	pop    %ebp
f0107331:	c3                   	ret    
f0107332:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0107338:	89 e9                	mov    %ebp,%ecx
f010733a:	ba 20 00 00 00       	mov    $0x20,%edx
f010733f:	29 ea                	sub    %ebp,%edx
f0107341:	d3 e0                	shl    %cl,%eax
f0107343:	89 44 24 08          	mov    %eax,0x8(%esp)
f0107347:	89 d1                	mov    %edx,%ecx
f0107349:	89 f8                	mov    %edi,%eax
f010734b:	d3 e8                	shr    %cl,%eax
f010734d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0107351:	89 54 24 04          	mov    %edx,0x4(%esp)
f0107355:	8b 54 24 04          	mov    0x4(%esp),%edx
f0107359:	09 c1                	or     %eax,%ecx
f010735b:	89 d8                	mov    %ebx,%eax
f010735d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0107361:	89 e9                	mov    %ebp,%ecx
f0107363:	d3 e7                	shl    %cl,%edi
f0107365:	89 d1                	mov    %edx,%ecx
f0107367:	d3 e8                	shr    %cl,%eax
f0107369:	89 e9                	mov    %ebp,%ecx
f010736b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f010736f:	d3 e3                	shl    %cl,%ebx
f0107371:	89 c7                	mov    %eax,%edi
f0107373:	89 d1                	mov    %edx,%ecx
f0107375:	89 f0                	mov    %esi,%eax
f0107377:	d3 e8                	shr    %cl,%eax
f0107379:	89 e9                	mov    %ebp,%ecx
f010737b:	89 fa                	mov    %edi,%edx
f010737d:	d3 e6                	shl    %cl,%esi
f010737f:	09 d8                	or     %ebx,%eax
f0107381:	f7 74 24 08          	divl   0x8(%esp)
f0107385:	89 d1                	mov    %edx,%ecx
f0107387:	89 f3                	mov    %esi,%ebx
f0107389:	f7 64 24 0c          	mull   0xc(%esp)
f010738d:	89 c6                	mov    %eax,%esi
f010738f:	89 d7                	mov    %edx,%edi
f0107391:	39 d1                	cmp    %edx,%ecx
f0107393:	72 06                	jb     f010739b <__umoddi3+0xfb>
f0107395:	75 10                	jne    f01073a7 <__umoddi3+0x107>
f0107397:	39 c3                	cmp    %eax,%ebx
f0107399:	73 0c                	jae    f01073a7 <__umoddi3+0x107>
f010739b:	2b 44 24 0c          	sub    0xc(%esp),%eax
f010739f:	1b 54 24 08          	sbb    0x8(%esp),%edx
f01073a3:	89 d7                	mov    %edx,%edi
f01073a5:	89 c6                	mov    %eax,%esi
f01073a7:	89 ca                	mov    %ecx,%edx
f01073a9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f01073ae:	29 f3                	sub    %esi,%ebx
f01073b0:	19 fa                	sbb    %edi,%edx
f01073b2:	89 d0                	mov    %edx,%eax
f01073b4:	d3 e0                	shl    %cl,%eax
f01073b6:	89 e9                	mov    %ebp,%ecx
f01073b8:	d3 eb                	shr    %cl,%ebx
f01073ba:	d3 ea                	shr    %cl,%edx
f01073bc:	09 d8                	or     %ebx,%eax
f01073be:	83 c4 1c             	add    $0x1c,%esp
f01073c1:	5b                   	pop    %ebx
f01073c2:	5e                   	pop    %esi
f01073c3:	5f                   	pop    %edi
f01073c4:	5d                   	pop    %ebp
f01073c5:	c3                   	ret    
f01073c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01073cd:	8d 76 00             	lea    0x0(%esi),%esi
f01073d0:	89 da                	mov    %ebx,%edx
f01073d2:	29 fe                	sub    %edi,%esi
f01073d4:	19 c2                	sbb    %eax,%edx
f01073d6:	89 f1                	mov    %esi,%ecx
f01073d8:	89 c8                	mov    %ecx,%eax
f01073da:	e9 4b ff ff ff       	jmp    f010732a <__umoddi3+0x8a>
