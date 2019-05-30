
obj/fs/fs:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 e5 12 00 00       	call   801316 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <ide_wait_ready>:

static int diskno = 1;

static int
ide_wait_ready(bool check_error)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	89 c1                	mov    %eax,%ecx

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800039:	ba f7 01 00 00       	mov    $0x1f7,%edx
  80003e:	ec                   	in     (%dx),%al
  80003f:	89 c3                	mov    %eax,%ebx
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  800041:	83 e0 c0             	and    $0xffffffc0,%eax
  800044:	3c 40                	cmp    $0x40,%al
  800046:	75 f6                	jne    80003e <ide_wait_ready+0xb>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
		return -1;
	return 0;
  800048:	b8 00 00 00 00       	mov    $0x0,%eax
	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  80004d:	84 c9                	test   %cl,%cl
  80004f:	74 0b                	je     80005c <ide_wait_ready+0x29>
  800051:	f6 c3 21             	test   $0x21,%bl
  800054:	0f 95 c0             	setne  %al
  800057:	0f b6 c0             	movzbl %al,%eax
  80005a:	f7 d8                	neg    %eax
}
  80005c:	5b                   	pop    %ebx
  80005d:	5d                   	pop    %ebp
  80005e:	c3                   	ret    

0080005f <ide_probe_disk1>:

bool
ide_probe_disk1(void)
{
  80005f:	55                   	push   %ebp
  800060:	89 e5                	mov    %esp,%ebp
  800062:	53                   	push   %ebx
  800063:	83 ec 04             	sub    $0x4,%esp
	int r, x;

	// wait for Device 0 to be ready
	ide_wait_ready(0);
  800066:	b8 00 00 00 00       	mov    $0x0,%eax
  80006b:	e8 c3 ff ff ff       	call   800033 <ide_wait_ready>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800070:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800075:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80007a:	ee                   	out    %al,(%dx)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  80007b:	b9 00 00 00 00       	mov    $0x0,%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800080:	ba f7 01 00 00       	mov    $0x1f7,%edx
  800085:	ec                   	in     (%dx),%al
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
  800086:	a8 a1                	test   $0xa1,%al
  800088:	74 0b                	je     800095 <ide_probe_disk1+0x36>
	     x++)
  80008a:	83 c1 01             	add    $0x1,%ecx
	for (x = 0;
  80008d:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
  800093:	75 f0                	jne    800085 <ide_probe_disk1+0x26>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800095:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  80009a:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80009f:	ee                   	out    %al,(%dx)
		/* do nothing */;

	// switch back to Device 0
	outb(0x1F6, 0xE0 | (0<<4));

	cprintf("Device 1 presence: %d\n", (x < 1000));
  8000a0:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
  8000a6:	0f 9e c3             	setle  %bl
  8000a9:	83 ec 08             	sub    $0x8,%esp
  8000ac:	0f b6 c3             	movzbl %bl,%eax
  8000af:	50                   	push   %eax
  8000b0:	68 40 32 80 00       	push   $0x803240
  8000b5:	e8 92 13 00 00       	call   80144c <cprintf>
	return (x < 1000);
}
  8000ba:	89 d8                	mov    %ebx,%eax
  8000bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000bf:	c9                   	leave  
  8000c0:	c3                   	ret    

008000c1 <ide_set_disk>:

void
ide_set_disk(int d)
{
  8000c1:	55                   	push   %ebp
  8000c2:	89 e5                	mov    %esp,%ebp
  8000c4:	83 ec 08             	sub    $0x8,%esp
  8000c7:	8b 45 08             	mov    0x8(%ebp),%eax
	if (d != 0 && d != 1)
  8000ca:	83 f8 01             	cmp    $0x1,%eax
  8000cd:	77 07                	ja     8000d6 <ide_set_disk+0x15>
		panic("bad disk number");
	diskno = d;
  8000cf:	a3 00 40 80 00       	mov    %eax,0x804000
}
  8000d4:	c9                   	leave  
  8000d5:	c3                   	ret    
		panic("bad disk number");
  8000d6:	83 ec 04             	sub    $0x4,%esp
  8000d9:	68 57 32 80 00       	push   $0x803257
  8000de:	6a 3a                	push   $0x3a
  8000e0:	68 67 32 80 00       	push   $0x803267
  8000e5:	e8 87 12 00 00       	call   801371 <_panic>

008000ea <ide_read>:


int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  8000ea:	55                   	push   %ebp
  8000eb:	89 e5                	mov    %esp,%ebp
  8000ed:	57                   	push   %edi
  8000ee:	56                   	push   %esi
  8000ef:	53                   	push   %ebx
  8000f0:	83 ec 0c             	sub    $0xc,%esp
  8000f3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8000f6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8000f9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	assert(nsecs <= 256);
  8000fc:	81 fe 00 01 00 00    	cmp    $0x100,%esi
  800102:	0f 87 87 00 00 00    	ja     80018f <ide_read+0xa5>

	ide_wait_ready(0);
  800108:	b8 00 00 00 00       	mov    $0x0,%eax
  80010d:	e8 21 ff ff ff       	call   800033 <ide_wait_ready>
  800112:	ba f2 01 00 00       	mov    $0x1f2,%edx
  800117:	89 f0                	mov    %esi,%eax
  800119:	ee                   	out    %al,(%dx)
  80011a:	ba f3 01 00 00       	mov    $0x1f3,%edx
  80011f:	89 f8                	mov    %edi,%eax
  800121:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
  800122:	89 f8                	mov    %edi,%eax
  800124:	c1 e8 08             	shr    $0x8,%eax
  800127:	ba f4 01 00 00       	mov    $0x1f4,%edx
  80012c:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  80012d:	89 f8                	mov    %edi,%eax
  80012f:	c1 e8 10             	shr    $0x10,%eax
  800132:	ba f5 01 00 00       	mov    $0x1f5,%edx
  800137:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800138:	0f b6 05 00 40 80 00 	movzbl 0x804000,%eax
  80013f:	c1 e0 04             	shl    $0x4,%eax
  800142:	83 e0 10             	and    $0x10,%eax
  800145:	c1 ef 18             	shr    $0x18,%edi
  800148:	83 e7 0f             	and    $0xf,%edi
  80014b:	09 f8                	or     %edi,%eax
  80014d:	83 c8 e0             	or     $0xffffffe0,%eax
  800150:	ba f6 01 00 00       	mov    $0x1f6,%edx
  800155:	ee                   	out    %al,(%dx)
  800156:	b8 20 00 00 00       	mov    $0x20,%eax
  80015b:	ba f7 01 00 00       	mov    $0x1f7,%edx
  800160:	ee                   	out    %al,(%dx)
  800161:	c1 e6 09             	shl    $0x9,%esi
  800164:	01 de                	add    %ebx,%esi
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  800166:	39 f3                	cmp    %esi,%ebx
  800168:	74 3b                	je     8001a5 <ide_read+0xbb>
		if ((r = ide_wait_ready(1)) < 0)
  80016a:	b8 01 00 00 00       	mov    $0x1,%eax
  80016f:	e8 bf fe ff ff       	call   800033 <ide_wait_ready>
  800174:	85 c0                	test   %eax,%eax
  800176:	78 32                	js     8001aa <ide_read+0xc0>
	asm volatile("cld\n\trepne\n\tinsl"
  800178:	89 df                	mov    %ebx,%edi
  80017a:	b9 80 00 00 00       	mov    $0x80,%ecx
  80017f:	ba f0 01 00 00       	mov    $0x1f0,%edx
  800184:	fc                   	cld    
  800185:	f2 6d                	repnz insl (%dx),%es:(%edi)
	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  800187:	81 c3 00 02 00 00    	add    $0x200,%ebx
  80018d:	eb d7                	jmp    800166 <ide_read+0x7c>
	assert(nsecs <= 256);
  80018f:	68 70 32 80 00       	push   $0x803270
  800194:	68 7d 32 80 00       	push   $0x80327d
  800199:	6a 44                	push   $0x44
  80019b:	68 67 32 80 00       	push   $0x803267
  8001a0:	e8 cc 11 00 00       	call   801371 <_panic>
			return r;
		insl(0x1F0, dst, SECTSIZE/4);
	}

	return 0;
  8001a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8001aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ad:	5b                   	pop    %ebx
  8001ae:	5e                   	pop    %esi
  8001af:	5f                   	pop    %edi
  8001b0:	5d                   	pop    %ebp
  8001b1:	c3                   	ret    

008001b2 <ide_write>:

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  8001b2:	55                   	push   %ebp
  8001b3:	89 e5                	mov    %esp,%ebp
  8001b5:	57                   	push   %edi
  8001b6:	56                   	push   %esi
  8001b7:	53                   	push   %ebx
  8001b8:	83 ec 0c             	sub    $0xc,%esp
  8001bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8001be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8001c1:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	assert(nsecs <= 256);
  8001c4:	81 ff 00 01 00 00    	cmp    $0x100,%edi
  8001ca:	0f 87 87 00 00 00    	ja     800257 <ide_write+0xa5>

	ide_wait_ready(0);
  8001d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8001d5:	e8 59 fe ff ff       	call   800033 <ide_wait_ready>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8001da:	ba f2 01 00 00       	mov    $0x1f2,%edx
  8001df:	89 f8                	mov    %edi,%eax
  8001e1:	ee                   	out    %al,(%dx)
  8001e2:	ba f3 01 00 00       	mov    $0x1f3,%edx
  8001e7:	89 f0                	mov    %esi,%eax
  8001e9:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
  8001ea:	89 f0                	mov    %esi,%eax
  8001ec:	c1 e8 08             	shr    $0x8,%eax
  8001ef:	ba f4 01 00 00       	mov    $0x1f4,%edx
  8001f4:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  8001f5:	89 f0                	mov    %esi,%eax
  8001f7:	c1 e8 10             	shr    $0x10,%eax
  8001fa:	ba f5 01 00 00       	mov    $0x1f5,%edx
  8001ff:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800200:	0f b6 05 00 40 80 00 	movzbl 0x804000,%eax
  800207:	c1 e0 04             	shl    $0x4,%eax
  80020a:	83 e0 10             	and    $0x10,%eax
  80020d:	c1 ee 18             	shr    $0x18,%esi
  800210:	83 e6 0f             	and    $0xf,%esi
  800213:	09 f0                	or     %esi,%eax
  800215:	83 c8 e0             	or     $0xffffffe0,%eax
  800218:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80021d:	ee                   	out    %al,(%dx)
  80021e:	b8 30 00 00 00       	mov    $0x30,%eax
  800223:	ba f7 01 00 00       	mov    $0x1f7,%edx
  800228:	ee                   	out    %al,(%dx)
  800229:	c1 e7 09             	shl    $0x9,%edi
  80022c:	01 df                	add    %ebx,%edi
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  80022e:	39 fb                	cmp    %edi,%ebx
  800230:	74 3b                	je     80026d <ide_write+0xbb>
		if ((r = ide_wait_ready(1)) < 0)
  800232:	b8 01 00 00 00       	mov    $0x1,%eax
  800237:	e8 f7 fd ff ff       	call   800033 <ide_wait_ready>
  80023c:	85 c0                	test   %eax,%eax
  80023e:	78 32                	js     800272 <ide_write+0xc0>
}

static inline void
outsl(int port, const void *addr, int cnt)
{
	asm volatile("cld\n\trepne\n\toutsl"
  800240:	89 de                	mov    %ebx,%esi
  800242:	b9 80 00 00 00       	mov    $0x80,%ecx
  800247:	ba f0 01 00 00       	mov    $0x1f0,%edx
  80024c:	fc                   	cld    
  80024d:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  80024f:	81 c3 00 02 00 00    	add    $0x200,%ebx
  800255:	eb d7                	jmp    80022e <ide_write+0x7c>
	assert(nsecs <= 256);
  800257:	68 70 32 80 00       	push   $0x803270
  80025c:	68 7d 32 80 00       	push   $0x80327d
  800261:	6a 5d                	push   $0x5d
  800263:	68 67 32 80 00       	push   $0x803267
  800268:	e8 04 11 00 00       	call   801371 <_panic>
			return r;
		outsl(0x1F0, src, SECTSIZE/4);
	}

	return 0;
  80026d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800272:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800275:	5b                   	pop    %ebx
  800276:	5e                   	pop    %esi
  800277:	5f                   	pop    %edi
  800278:	5d                   	pop    %ebp
  800279:	c3                   	ret    

0080027a <bc_pgfault>:

// Fault any disk block that is read in to memory by
// loading it from disk.
static void
bc_pgfault(struct UTrapframe *utf)
{
  80027a:	55                   	push   %ebp
  80027b:	89 e5                	mov    %esp,%ebp
  80027d:	53                   	push   %ebx
  80027e:	83 ec 04             	sub    $0x4,%esp
  800281:	8b 4d 08             	mov    0x8(%ebp),%ecx
	void *addr = (void *) utf->utf_fault_va;
  800284:	8b 01                	mov    (%ecx),%eax
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  800286:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
  80028c:	89 d3                	mov    %edx,%ebx
  80028e:	c1 eb 0c             	shr    $0xc,%ebx
	int r;

	// Check that the fault was within the block cache region
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  800291:	81 fa ff ff ff bf    	cmp    $0xbfffffff,%edx
  800297:	77 55                	ja     8002ee <bc_pgfault+0x74>
		panic("page fault in FS: eip %08x, va %08x, err %04x",
		      utf->utf_eip, addr, utf->utf_err);

	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
  800299:	8b 15 08 90 80 00    	mov    0x809008,%edx
  80029f:	85 d2                	test   %edx,%edx
  8002a1:	74 05                	je     8002a8 <bc_pgfault+0x2e>
  8002a3:	39 5a 04             	cmp    %ebx,0x4(%edx)
  8002a6:	76 61                	jbe    800309 <bc_pgfault+0x8f>
	//
	// LAB 5: you code here:

	// Clear the dirty bit for the disk block page since we just read the
	// block from disk
	if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  8002a8:	89 c2                	mov    %eax,%edx
  8002aa:	c1 ea 0c             	shr    $0xc,%edx
  8002ad:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8002b4:	83 ec 0c             	sub    $0xc,%esp
  8002b7:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8002bd:	52                   	push   %edx
  8002be:	50                   	push   %eax
  8002bf:	6a 00                	push   $0x0
  8002c1:	50                   	push   %eax
  8002c2:	6a 00                	push   $0x0
  8002c4:	e8 de 1c 00 00       	call   801fa7 <sys_page_map>
  8002c9:	83 c4 20             	add    $0x20,%esp
  8002cc:	85 c0                	test   %eax,%eax
  8002ce:	78 4b                	js     80031b <bc_pgfault+0xa1>
		panic("in bc_pgfault, sys_page_map: %e", r);

	// Check that the block we read was allocated. (exercise for
	// the reader: why do we do this *after* reading the block
	// in?)
	if (bitmap && block_is_free(blockno))
  8002d0:	83 3d 04 90 80 00 00 	cmpl   $0x0,0x809004
  8002d7:	74 10                	je     8002e9 <bc_pgfault+0x6f>
  8002d9:	83 ec 0c             	sub    $0xc,%esp
  8002dc:	53                   	push   %ebx
  8002dd:	e8 6f 03 00 00       	call   800651 <block_is_free>
  8002e2:	83 c4 10             	add    $0x10,%esp
  8002e5:	84 c0                	test   %al,%al
  8002e7:	75 44                	jne    80032d <bc_pgfault+0xb3>
		panic("reading free block %08x\n", blockno);
}
  8002e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002ec:	c9                   	leave  
  8002ed:	c3                   	ret    
		panic("page fault in FS: eip %08x, va %08x, err %04x",
  8002ee:	83 ec 08             	sub    $0x8,%esp
  8002f1:	ff 71 04             	pushl  0x4(%ecx)
  8002f4:	50                   	push   %eax
  8002f5:	ff 71 28             	pushl  0x28(%ecx)
  8002f8:	68 94 32 80 00       	push   $0x803294
  8002fd:	6a 27                	push   $0x27
  8002ff:	68 2a 33 80 00       	push   $0x80332a
  800304:	e8 68 10 00 00       	call   801371 <_panic>
		panic("reading non-existent block %08x\n", blockno);
  800309:	53                   	push   %ebx
  80030a:	68 c4 32 80 00       	push   $0x8032c4
  80030f:	6a 2b                	push   $0x2b
  800311:	68 2a 33 80 00       	push   $0x80332a
  800316:	e8 56 10 00 00       	call   801371 <_panic>
		panic("in bc_pgfault, sys_page_map: %e", r);
  80031b:	50                   	push   %eax
  80031c:	68 e8 32 80 00       	push   $0x8032e8
  800321:	6a 37                	push   $0x37
  800323:	68 2a 33 80 00       	push   $0x80332a
  800328:	e8 44 10 00 00       	call   801371 <_panic>
		panic("reading free block %08x\n", blockno);
  80032d:	53                   	push   %ebx
  80032e:	68 32 33 80 00       	push   $0x803332
  800333:	6a 3d                	push   $0x3d
  800335:	68 2a 33 80 00       	push   $0x80332a
  80033a:	e8 32 10 00 00       	call   801371 <_panic>

0080033f <diskaddr>:
{
  80033f:	55                   	push   %ebp
  800340:	89 e5                	mov    %esp,%ebp
  800342:	83 ec 08             	sub    $0x8,%esp
  800345:	8b 45 08             	mov    0x8(%ebp),%eax
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  800348:	85 c0                	test   %eax,%eax
  80034a:	74 19                	je     800365 <diskaddr+0x26>
  80034c:	8b 15 08 90 80 00    	mov    0x809008,%edx
  800352:	85 d2                	test   %edx,%edx
  800354:	74 05                	je     80035b <diskaddr+0x1c>
  800356:	39 42 04             	cmp    %eax,0x4(%edx)
  800359:	76 0a                	jbe    800365 <diskaddr+0x26>
	return (char*) (DISKMAP + blockno * BLKSIZE);
  80035b:	05 00 00 01 00       	add    $0x10000,%eax
  800360:	c1 e0 0c             	shl    $0xc,%eax
}
  800363:	c9                   	leave  
  800364:	c3                   	ret    
		panic("bad block number %08x in diskaddr", blockno);
  800365:	50                   	push   %eax
  800366:	68 08 33 80 00       	push   $0x803308
  80036b:	6a 09                	push   $0x9
  80036d:	68 2a 33 80 00       	push   $0x80332a
  800372:	e8 fa 0f 00 00       	call   801371 <_panic>

00800377 <va_is_mapped>:
{
  800377:	55                   	push   %ebp
  800378:	89 e5                	mov    %esp,%ebp
  80037a:	8b 55 08             	mov    0x8(%ebp),%edx
	return (uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P);
  80037d:	89 d0                	mov    %edx,%eax
  80037f:	c1 e8 16             	shr    $0x16,%eax
  800382:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
  800389:	b8 00 00 00 00       	mov    $0x0,%eax
  80038e:	f6 c1 01             	test   $0x1,%cl
  800391:	74 0d                	je     8003a0 <va_is_mapped+0x29>
  800393:	c1 ea 0c             	shr    $0xc,%edx
  800396:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80039d:	83 e0 01             	and    $0x1,%eax
  8003a0:	83 e0 01             	and    $0x1,%eax
}
  8003a3:	5d                   	pop    %ebp
  8003a4:	c3                   	ret    

008003a5 <va_is_dirty>:
{
  8003a5:	55                   	push   %ebp
  8003a6:	89 e5                	mov    %esp,%ebp
	return (uvpt[PGNUM(va)] & PTE_D) != 0;
  8003a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ab:	c1 e8 0c             	shr    $0xc,%eax
  8003ae:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8003b5:	c1 e8 06             	shr    $0x6,%eax
  8003b8:	83 e0 01             	and    $0x1,%eax
}
  8003bb:	5d                   	pop    %ebp
  8003bc:	c3                   	ret    

008003bd <flush_block>:
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
  8003bd:	55                   	push   %ebp
  8003be:	89 e5                	mov    %esp,%ebp
  8003c0:	83 ec 08             	sub    $0x8,%esp
  8003c3:	8b 45 08             	mov    0x8(%ebp),%eax
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  8003c6:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx

	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  8003cc:	81 fa ff ff ff bf    	cmp    $0xbfffffff,%edx
  8003d2:	76 12                	jbe    8003e6 <flush_block+0x29>
		panic("flush_block of bad va %08x", addr);
  8003d4:	50                   	push   %eax
  8003d5:	68 4b 33 80 00       	push   $0x80334b
  8003da:	6a 4d                	push   $0x4d
  8003dc:	68 2a 33 80 00       	push   $0x80332a
  8003e1:	e8 8b 0f 00 00       	call   801371 <_panic>

	// LAB 5: Your code here.
	panic("flush_block not implemented");
  8003e6:	83 ec 04             	sub    $0x4,%esp
  8003e9:	68 66 33 80 00       	push   $0x803366
  8003ee:	6a 50                	push   $0x50
  8003f0:	68 2a 33 80 00       	push   $0x80332a
  8003f5:	e8 77 0f 00 00       	call   801371 <_panic>

008003fa <check_bc>:

// Test that the block cache works, by smashing the superblock and
// reading it back.
static void
check_bc(void)
{
  8003fa:	55                   	push   %ebp
  8003fb:	89 e5                	mov    %esp,%ebp
  8003fd:	81 ec 24 01 00 00    	sub    $0x124,%esp
	struct Super backup;

	// back up super block
	memmove(&backup, diskaddr(1), sizeof backup);
  800403:	6a 01                	push   $0x1
  800405:	e8 35 ff ff ff       	call   80033f <diskaddr>
  80040a:	83 c4 0c             	add    $0xc,%esp
  80040d:	68 08 01 00 00       	push   $0x108
  800412:	50                   	push   %eax
  800413:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800419:	50                   	push   %eax
  80041a:	e8 e1 18 00 00       	call   801d00 <memmove>

	// smash it
	strcpy(diskaddr(1), "OOPS!\n");
  80041f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800426:	e8 14 ff ff ff       	call   80033f <diskaddr>
  80042b:	83 c4 08             	add    $0x8,%esp
  80042e:	68 82 33 80 00       	push   $0x803382
  800433:	50                   	push   %eax
  800434:	e8 39 17 00 00       	call   801b72 <strcpy>
	flush_block(diskaddr(1));
  800439:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800440:	e8 fa fe ff ff       	call   80033f <diskaddr>
  800445:	89 04 24             	mov    %eax,(%esp)
  800448:	e8 70 ff ff ff       	call   8003bd <flush_block>

0080044d <bc_init>:
	cprintf("block cache is good\n");
}

void
bc_init(void)
{
  80044d:	55                   	push   %ebp
  80044e:	89 e5                	mov    %esp,%ebp
  800450:	83 ec 14             	sub    $0x14,%esp
	struct Super super;
	set_pgfault_handler(bc_pgfault);
  800453:	68 7a 02 80 00       	push   $0x80027a
  800458:	e8 39 1d 00 00       	call   802196 <set_pgfault_handler>
	check_bc();
  80045d:	e8 98 ff ff ff       	call   8003fa <check_bc>

00800462 <walk_path>:
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
  800462:	55                   	push   %ebp
  800463:	89 e5                	mov    %esp,%ebp
  800465:	57                   	push   %edi
  800466:	56                   	push   %esi
  800467:	53                   	push   %ebx
  800468:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  80046e:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  800474:	89 8d 64 ff ff ff    	mov    %ecx,-0x9c(%ebp)
	while (*p == '/')
  80047a:	80 38 2f             	cmpb   $0x2f,(%eax)
  80047d:	75 05                	jne    800484 <walk_path+0x22>
		p++;
  80047f:	83 c0 01             	add    $0x1,%eax
  800482:	eb f6                	jmp    80047a <walk_path+0x18>
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
	f = &super->s_root;
  800484:	8b 3d 08 90 80 00    	mov    0x809008,%edi
  80048a:	8d 4f 08             	lea    0x8(%edi),%ecx
  80048d:	89 8d 5c ff ff ff    	mov    %ecx,-0xa4(%ebp)
	dir = 0;
	name[0] = 0;
  800493:	c6 85 68 ff ff ff 00 	movb   $0x0,-0x98(%ebp)

	if (pdir)
  80049a:	8b 8d 60 ff ff ff    	mov    -0xa0(%ebp),%ecx
  8004a0:	85 c9                	test   %ecx,%ecx
  8004a2:	0f 84 3c 01 00 00    	je     8005e4 <walk_path+0x182>
		*pdir = 0;
  8004a8:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	*pf = 0;
  8004ae:	8b 8d 64 ff ff ff    	mov    -0x9c(%ebp),%ecx
  8004b4:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	while (*path != '\0') {
  8004ba:	80 38 00             	cmpb   $0x0,(%eax)
  8004bd:	0f 84 ec 00 00 00    	je     8005af <walk_path+0x14d>
{
  8004c3:	89 c3                	mov    %eax,%ebx
  8004c5:	eb 03                	jmp    8004ca <walk_path+0x68>
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
			path++;
  8004c7:	83 c3 01             	add    $0x1,%ebx
		while (*path != '/' && *path != '\0')
  8004ca:	0f b6 13             	movzbl (%ebx),%edx
  8004cd:	80 fa 2f             	cmp    $0x2f,%dl
  8004d0:	74 04                	je     8004d6 <walk_path+0x74>
  8004d2:	84 d2                	test   %dl,%dl
  8004d4:	75 f1                	jne    8004c7 <walk_path+0x65>
		if (path - p >= MAXNAMELEN)
  8004d6:	89 de                	mov    %ebx,%esi
  8004d8:	29 c6                	sub    %eax,%esi
  8004da:	83 fe 7f             	cmp    $0x7f,%esi
  8004dd:	0f 8f f3 00 00 00    	jg     8005d6 <walk_path+0x174>
			return -E_BAD_PATH;
		memmove(name, p, path - p);
  8004e3:	83 ec 04             	sub    $0x4,%esp
  8004e6:	56                   	push   %esi
  8004e7:	50                   	push   %eax
  8004e8:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  8004ee:	50                   	push   %eax
  8004ef:	e8 0c 18 00 00       	call   801d00 <memmove>
		name[path - p] = '\0';
  8004f4:	c6 84 35 68 ff ff ff 	movb   $0x0,-0x98(%ebp,%esi,1)
  8004fb:	00 
  8004fc:	83 c4 10             	add    $0x10,%esp
	while (*p == '/')
  8004ff:	0f b6 13             	movzbl (%ebx),%edx
  800502:	80 fa 2f             	cmp    $0x2f,%dl
  800505:	75 05                	jne    80050c <walk_path+0xaa>
		p++;
  800507:	83 c3 01             	add    $0x1,%ebx
  80050a:	eb f3                	jmp    8004ff <walk_path+0x9d>
		path = skip_slash(path);

		if (dir->f_type != FTYPE_DIR)
  80050c:	83 bf 8c 00 00 00 01 	cmpl   $0x1,0x8c(%edi)
  800513:	0f 85 c4 00 00 00    	jne    8005dd <walk_path+0x17b>
	assert((dir->f_size % BLKSIZE) == 0);
  800519:	8b 87 88 00 00 00    	mov    0x88(%edi),%eax
  80051f:	a9 ff 0f 00 00       	test   $0xfff,%eax
  800524:	75 59                	jne    80057f <walk_path+0x11d>
	for (i = 0; i < nblock; i++) {
  800526:	05 ff 0f 00 00       	add    $0xfff,%eax
  80052b:	3d fe 1f 00 00       	cmp    $0x1ffe,%eax
  800530:	77 66                	ja     800598 <walk_path+0x136>
					*pdir = dir;
				if (lastelem)
					strcpy(lastelem, name);
				*pf = 0;
			}
			return r;
  800532:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
			if (r == -E_NOT_FOUND && *path == '\0') {
  800537:	84 d2                	test   %dl,%dl
  800539:	0f 85 8f 00 00 00    	jne    8005ce <walk_path+0x16c>
				if (pdir)
  80053f:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800545:	85 c0                	test   %eax,%eax
  800547:	74 08                	je     800551 <walk_path+0xef>
					*pdir = dir;
  800549:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  80054f:	89 08                	mov    %ecx,(%eax)
				if (lastelem)
  800551:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800555:	74 15                	je     80056c <walk_path+0x10a>
					strcpy(lastelem, name);
  800557:	83 ec 08             	sub    $0x8,%esp
  80055a:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800560:	50                   	push   %eax
  800561:	ff 75 08             	pushl  0x8(%ebp)
  800564:	e8 09 16 00 00       	call   801b72 <strcpy>
  800569:	83 c4 10             	add    $0x10,%esp
				*pf = 0;
  80056c:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800572:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			return r;
  800578:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  80057d:	eb 4f                	jmp    8005ce <walk_path+0x16c>
	assert((dir->f_size % BLKSIZE) == 0);
  80057f:	68 89 33 80 00       	push   $0x803389
  800584:	68 7d 32 80 00       	push   $0x80327d
  800589:	68 ab 00 00 00       	push   $0xab
  80058e:	68 a6 33 80 00       	push   $0x8033a6
  800593:	e8 d9 0d 00 00       	call   801371 <_panic>
       panic("file_get_block not implemented");
  800598:	83 ec 04             	sub    $0x4,%esp
  80059b:	68 78 34 80 00       	push   $0x803478
  8005a0:	68 99 00 00 00       	push   $0x99
  8005a5:	68 a6 33 80 00       	push   $0x8033a6
  8005aa:	e8 c2 0d 00 00       	call   801371 <_panic>
		}
	}

	if (pdir)
		*pdir = dir;
  8005af:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8005b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pf = f;
  8005bb:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8005c1:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  8005c7:	89 08                	mov    %ecx,(%eax)
	return 0;
  8005c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8005ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005d1:	5b                   	pop    %ebx
  8005d2:	5e                   	pop    %esi
  8005d3:	5f                   	pop    %edi
  8005d4:	5d                   	pop    %ebp
  8005d5:	c3                   	ret    
			return -E_BAD_PATH;
  8005d6:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8005db:	eb f1                	jmp    8005ce <walk_path+0x16c>
			return -E_NOT_FOUND;
  8005dd:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  8005e2:	eb ea                	jmp    8005ce <walk_path+0x16c>
	*pf = 0;
  8005e4:	8b 8d 64 ff ff ff    	mov    -0x9c(%ebp),%ecx
  8005ea:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	while (*path != '\0') {
  8005f0:	80 38 00             	cmpb   $0x0,(%eax)
  8005f3:	0f 85 ca fe ff ff    	jne    8004c3 <walk_path+0x61>
  8005f9:	eb c0                	jmp    8005bb <walk_path+0x159>

008005fb <check_super>:
{
  8005fb:	55                   	push   %ebp
  8005fc:	89 e5                	mov    %esp,%ebp
  8005fe:	83 ec 08             	sub    $0x8,%esp
	if (super->s_magic != FS_MAGIC)
  800601:	a1 08 90 80 00       	mov    0x809008,%eax
  800606:	81 38 ae 30 05 4a    	cmpl   $0x4a0530ae,(%eax)
  80060c:	75 1b                	jne    800629 <check_super+0x2e>
	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  80060e:	81 78 04 00 00 0c 00 	cmpl   $0xc0000,0x4(%eax)
  800615:	77 26                	ja     80063d <check_super+0x42>
	cprintf("superblock is good\n");
  800617:	83 ec 0c             	sub    $0xc,%esp
  80061a:	68 e4 33 80 00       	push   $0x8033e4
  80061f:	e8 28 0e 00 00       	call   80144c <cprintf>
}
  800624:	83 c4 10             	add    $0x10,%esp
  800627:	c9                   	leave  
  800628:	c3                   	ret    
		panic("bad file system magic number");
  800629:	83 ec 04             	sub    $0x4,%esp
  80062c:	68 ae 33 80 00       	push   $0x8033ae
  800631:	6a 0f                	push   $0xf
  800633:	68 a6 33 80 00       	push   $0x8033a6
  800638:	e8 34 0d 00 00       	call   801371 <_panic>
		panic("file system is too large");
  80063d:	83 ec 04             	sub    $0x4,%esp
  800640:	68 cb 33 80 00       	push   $0x8033cb
  800645:	6a 12                	push   $0x12
  800647:	68 a6 33 80 00       	push   $0x8033a6
  80064c:	e8 20 0d 00 00       	call   801371 <_panic>

00800651 <block_is_free>:
{
  800651:	55                   	push   %ebp
  800652:	89 e5                	mov    %esp,%ebp
  800654:	53                   	push   %ebx
  800655:	8b 4d 08             	mov    0x8(%ebp),%ecx
	if (super == 0 || blockno >= super->s_nblocks)
  800658:	8b 15 08 90 80 00    	mov    0x809008,%edx
  80065e:	85 d2                	test   %edx,%edx
  800660:	74 25                	je     800687 <block_is_free+0x36>
		return 0;
  800662:	b8 00 00 00 00       	mov    $0x0,%eax
	if (super == 0 || blockno >= super->s_nblocks)
  800667:	39 4a 04             	cmp    %ecx,0x4(%edx)
  80066a:	76 18                	jbe    800684 <block_is_free+0x33>
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
  80066c:	89 cb                	mov    %ecx,%ebx
  80066e:	c1 eb 05             	shr    $0x5,%ebx
  800671:	b8 01 00 00 00       	mov    $0x1,%eax
  800676:	d3 e0                	shl    %cl,%eax
  800678:	8b 15 04 90 80 00    	mov    0x809004,%edx
  80067e:	85 04 9a             	test   %eax,(%edx,%ebx,4)
  800681:	0f 95 c0             	setne  %al
}
  800684:	5b                   	pop    %ebx
  800685:	5d                   	pop    %ebp
  800686:	c3                   	ret    
		return 0;
  800687:	b8 00 00 00 00       	mov    $0x0,%eax
  80068c:	eb f6                	jmp    800684 <block_is_free+0x33>

0080068e <free_block>:
{
  80068e:	55                   	push   %ebp
  80068f:	89 e5                	mov    %esp,%ebp
  800691:	53                   	push   %ebx
  800692:	83 ec 04             	sub    $0x4,%esp
  800695:	8b 4d 08             	mov    0x8(%ebp),%ecx
	if (blockno == 0)
  800698:	85 c9                	test   %ecx,%ecx
  80069a:	74 1a                	je     8006b6 <free_block+0x28>
	bitmap[blockno/32] |= 1<<(blockno%32);
  80069c:	89 cb                	mov    %ecx,%ebx
  80069e:	c1 eb 05             	shr    $0x5,%ebx
  8006a1:	8b 15 04 90 80 00    	mov    0x809004,%edx
  8006a7:	b8 01 00 00 00       	mov    $0x1,%eax
  8006ac:	d3 e0                	shl    %cl,%eax
  8006ae:	09 04 9a             	or     %eax,(%edx,%ebx,4)
}
  8006b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006b4:	c9                   	leave  
  8006b5:	c3                   	ret    
		panic("attempt to free zero block");
  8006b6:	83 ec 04             	sub    $0x4,%esp
  8006b9:	68 f8 33 80 00       	push   $0x8033f8
  8006be:	6a 2d                	push   $0x2d
  8006c0:	68 a6 33 80 00       	push   $0x8033a6
  8006c5:	e8 a7 0c 00 00       	call   801371 <_panic>

008006ca <alloc_block>:
{
  8006ca:	55                   	push   %ebp
  8006cb:	89 e5                	mov    %esp,%ebp
  8006cd:	83 ec 0c             	sub    $0xc,%esp
	panic("alloc_block not implemented");
  8006d0:	68 13 34 80 00       	push   $0x803413
  8006d5:	6a 41                	push   $0x41
  8006d7:	68 a6 33 80 00       	push   $0x8033a6
  8006dc:	e8 90 0c 00 00       	call   801371 <_panic>

008006e1 <check_bitmap>:
{
  8006e1:	55                   	push   %ebp
  8006e2:	89 e5                	mov    %esp,%ebp
  8006e4:	56                   	push   %esi
  8006e5:	53                   	push   %ebx
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  8006e6:	a1 08 90 80 00       	mov    0x809008,%eax
  8006eb:	8b 70 04             	mov    0x4(%eax),%esi
  8006ee:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006f3:	89 d8                	mov    %ebx,%eax
  8006f5:	c1 e0 0f             	shl    $0xf,%eax
  8006f8:	39 c6                	cmp    %eax,%esi
  8006fa:	76 2e                	jbe    80072a <check_bitmap+0x49>
		assert(!block_is_free(2+i));
  8006fc:	83 ec 0c             	sub    $0xc,%esp
  8006ff:	8d 43 02             	lea    0x2(%ebx),%eax
  800702:	50                   	push   %eax
  800703:	e8 49 ff ff ff       	call   800651 <block_is_free>
  800708:	83 c4 10             	add    $0x10,%esp
  80070b:	84 c0                	test   %al,%al
  80070d:	75 05                	jne    800714 <check_bitmap+0x33>
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  80070f:	83 c3 01             	add    $0x1,%ebx
  800712:	eb df                	jmp    8006f3 <check_bitmap+0x12>
		assert(!block_is_free(2+i));
  800714:	68 2f 34 80 00       	push   $0x80342f
  800719:	68 7d 32 80 00       	push   $0x80327d
  80071e:	6a 50                	push   $0x50
  800720:	68 a6 33 80 00       	push   $0x8033a6
  800725:	e8 47 0c 00 00       	call   801371 <_panic>
	assert(!block_is_free(0));
  80072a:	83 ec 0c             	sub    $0xc,%esp
  80072d:	6a 00                	push   $0x0
  80072f:	e8 1d ff ff ff       	call   800651 <block_is_free>
  800734:	83 c4 10             	add    $0x10,%esp
  800737:	84 c0                	test   %al,%al
  800739:	75 28                	jne    800763 <check_bitmap+0x82>
	assert(!block_is_free(1));
  80073b:	83 ec 0c             	sub    $0xc,%esp
  80073e:	6a 01                	push   $0x1
  800740:	e8 0c ff ff ff       	call   800651 <block_is_free>
  800745:	83 c4 10             	add    $0x10,%esp
  800748:	84 c0                	test   %al,%al
  80074a:	75 2d                	jne    800779 <check_bitmap+0x98>
	cprintf("bitmap is good\n");
  80074c:	83 ec 0c             	sub    $0xc,%esp
  80074f:	68 67 34 80 00       	push   $0x803467
  800754:	e8 f3 0c 00 00       	call   80144c <cprintf>
}
  800759:	83 c4 10             	add    $0x10,%esp
  80075c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80075f:	5b                   	pop    %ebx
  800760:	5e                   	pop    %esi
  800761:	5d                   	pop    %ebp
  800762:	c3                   	ret    
	assert(!block_is_free(0));
  800763:	68 43 34 80 00       	push   $0x803443
  800768:	68 7d 32 80 00       	push   $0x80327d
  80076d:	6a 53                	push   $0x53
  80076f:	68 a6 33 80 00       	push   $0x8033a6
  800774:	e8 f8 0b 00 00       	call   801371 <_panic>
	assert(!block_is_free(1));
  800779:	68 55 34 80 00       	push   $0x803455
  80077e:	68 7d 32 80 00       	push   $0x80327d
  800783:	6a 54                	push   $0x54
  800785:	68 a6 33 80 00       	push   $0x8033a6
  80078a:	e8 e2 0b 00 00       	call   801371 <_panic>

0080078f <fs_init>:
{
  80078f:	55                   	push   %ebp
  800790:	89 e5                	mov    %esp,%ebp
  800792:	83 ec 08             	sub    $0x8,%esp
	if (ide_probe_disk1())
  800795:	e8 c5 f8 ff ff       	call   80005f <ide_probe_disk1>
  80079a:	84 c0                	test   %al,%al
  80079c:	74 41                	je     8007df <fs_init+0x50>
		ide_set_disk(1);
  80079e:	83 ec 0c             	sub    $0xc,%esp
  8007a1:	6a 01                	push   $0x1
  8007a3:	e8 19 f9 ff ff       	call   8000c1 <ide_set_disk>
  8007a8:	83 c4 10             	add    $0x10,%esp
	bc_init();
  8007ab:	e8 9d fc ff ff       	call   80044d <bc_init>
	super = diskaddr(1);
  8007b0:	83 ec 0c             	sub    $0xc,%esp
  8007b3:	6a 01                	push   $0x1
  8007b5:	e8 85 fb ff ff       	call   80033f <diskaddr>
  8007ba:	a3 08 90 80 00       	mov    %eax,0x809008
	check_super();
  8007bf:	e8 37 fe ff ff       	call   8005fb <check_super>
	bitmap = diskaddr(2);
  8007c4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8007cb:	e8 6f fb ff ff       	call   80033f <diskaddr>
  8007d0:	a3 04 90 80 00       	mov    %eax,0x809004
	check_bitmap();
  8007d5:	e8 07 ff ff ff       	call   8006e1 <check_bitmap>
}
  8007da:	83 c4 10             	add    $0x10,%esp
  8007dd:	c9                   	leave  
  8007de:	c3                   	ret    
		ide_set_disk(0);
  8007df:	83 ec 0c             	sub    $0xc,%esp
  8007e2:	6a 00                	push   $0x0
  8007e4:	e8 d8 f8 ff ff       	call   8000c1 <ide_set_disk>
  8007e9:	83 c4 10             	add    $0x10,%esp
  8007ec:	eb bd                	jmp    8007ab <fs_init+0x1c>

008007ee <file_get_block>:
{
  8007ee:	55                   	push   %ebp
  8007ef:	89 e5                	mov    %esp,%ebp
  8007f1:	83 ec 0c             	sub    $0xc,%esp
       panic("file_get_block not implemented");
  8007f4:	68 78 34 80 00       	push   $0x803478
  8007f9:	68 99 00 00 00       	push   $0x99
  8007fe:	68 a6 33 80 00       	push   $0x8033a6
  800803:	e8 69 0b 00 00       	call   801371 <_panic>

00800808 <file_create>:

// Create "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_create(const char *path, struct File **pf)
{
  800808:	55                   	push   %ebp
  800809:	89 e5                	mov    %esp,%ebp
  80080b:	81 ec a4 00 00 00    	sub    $0xa4,%esp
	char name[MAXNAMELEN];
	int r;
	struct File *dir, *f;

	if ((r = walk_path(path, &dir, &f, name)) == 0)
  800811:	8d 85 78 ff ff ff    	lea    -0x88(%ebp),%eax
  800817:	50                   	push   %eax
  800818:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  80081e:	8d 95 74 ff ff ff    	lea    -0x8c(%ebp),%edx
  800824:	8b 45 08             	mov    0x8(%ebp),%eax
  800827:	e8 36 fc ff ff       	call   800462 <walk_path>
  80082c:	83 c4 10             	add    $0x10,%esp
  80082f:	85 c0                	test   %eax,%eax
  800831:	74 7e                	je     8008b1 <file_create+0xa9>
		return -E_FILE_EXISTS;
	if (r != -E_NOT_FOUND || dir == 0)
  800833:	83 f8 f5             	cmp    $0xfffffff5,%eax
  800836:	75 0a                	jne    800842 <file_create+0x3a>
  800838:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
  80083e:	85 d2                	test   %edx,%edx
  800840:	75 02                	jne    800844 <file_create+0x3c>

	strcpy(f->f_name, name);
	*pf = f;
	file_flush(dir);
	return 0;
}
  800842:	c9                   	leave  
  800843:	c3                   	ret    
	assert((dir->f_size % BLKSIZE) == 0);
  800844:	8b 82 80 00 00 00    	mov    0x80(%edx),%eax
  80084a:	a9 ff 0f 00 00       	test   $0xfff,%eax
  80084f:	75 25                	jne    800876 <file_create+0x6e>
	for (i = 0; i < nblock; i++) {
  800851:	8d 88 ff 0f 00 00    	lea    0xfff(%eax),%ecx
  800857:	81 f9 fe 1f 00 00    	cmp    $0x1ffe,%ecx
  80085d:	76 30                	jbe    80088f <file_create+0x87>
       panic("file_get_block not implemented");
  80085f:	83 ec 04             	sub    $0x4,%esp
  800862:	68 78 34 80 00       	push   $0x803478
  800867:	68 99 00 00 00       	push   $0x99
  80086c:	68 a6 33 80 00       	push   $0x8033a6
  800871:	e8 fb 0a 00 00       	call   801371 <_panic>
	assert((dir->f_size % BLKSIZE) == 0);
  800876:	68 89 33 80 00       	push   $0x803389
  80087b:	68 7d 32 80 00       	push   $0x80327d
  800880:	68 c4 00 00 00       	push   $0xc4
  800885:	68 a6 33 80 00       	push   $0x8033a6
  80088a:	e8 e2 0a 00 00       	call   801371 <_panic>
	dir->f_size += BLKSIZE;
  80088f:	05 00 10 00 00       	add    $0x1000,%eax
  800894:	89 82 80 00 00 00    	mov    %eax,0x80(%edx)
       panic("file_get_block not implemented");
  80089a:	83 ec 04             	sub    $0x4,%esp
  80089d:	68 78 34 80 00       	push   $0x803478
  8008a2:	68 99 00 00 00       	push   $0x99
  8008a7:	68 a6 33 80 00       	push   $0x8033a6
  8008ac:	e8 c0 0a 00 00       	call   801371 <_panic>
		return -E_FILE_EXISTS;
  8008b1:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8008b6:	eb 8a                	jmp    800842 <file_create+0x3a>

008008b8 <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	83 ec 14             	sub    $0x14,%esp
	return walk_path(path, 0, pf, 0);
  8008be:	6a 00                	push   $0x0
  8008c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	e8 92 fb ff ff       	call   800462 <walk_path>
}
  8008d0:	c9                   	leave  
  8008d1:	c3                   	ret    

008008d2 <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  8008d2:	55                   	push   %ebp
  8008d3:	89 e5                	mov    %esp,%ebp
  8008d5:	83 ec 08             	sub    $0x8,%esp
  8008d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008db:	8b 55 14             	mov    0x14(%ebp),%edx
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  8008de:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e1:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  8008e7:	39 d0                	cmp    %edx,%eax
  8008e9:	7e 27                	jle    800912 <file_read+0x40>
		return 0;

	count = MIN(count, f->f_size - offset);
  8008eb:	29 d0                	sub    %edx,%eax
  8008ed:	39 c8                	cmp    %ecx,%eax
  8008ef:	0f 47 c1             	cmova  %ecx,%eax

	for (pos = offset; pos < offset + count; ) {
  8008f2:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8008f5:	39 ca                	cmp    %ecx,%edx
  8008f7:	72 02                	jb     8008fb <file_read+0x29>
		pos += bn;
		buf += bn;
	}

	return count;
}
  8008f9:	c9                   	leave  
  8008fa:	c3                   	ret    
       panic("file_get_block not implemented");
  8008fb:	83 ec 04             	sub    $0x4,%esp
  8008fe:	68 78 34 80 00       	push   $0x803478
  800903:	68 99 00 00 00       	push   $0x99
  800908:	68 a6 33 80 00       	push   $0x8033a6
  80090d:	e8 5f 0a 00 00       	call   801371 <_panic>
		return 0;
  800912:	b8 00 00 00 00       	mov    $0x0,%eax
  800917:	eb e0                	jmp    8008f9 <file_read+0x27>

00800919 <file_set_size>:
}

// Set the size of file f, truncating or extending as necessary.
int
file_set_size(struct File *f, off_t newsize)
{
  800919:	55                   	push   %ebp
  80091a:	89 e5                	mov    %esp,%ebp
  80091c:	56                   	push   %esi
  80091d:	53                   	push   %ebx
  80091e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800921:	8b 75 0c             	mov    0xc(%ebp),%esi
	if (f->f_size > newsize)
  800924:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
  80092a:	39 f0                	cmp    %esi,%eax
  80092c:	7f 1b                	jg     800949 <file_set_size+0x30>
		file_truncate_blocks(f, newsize);
	f->f_size = newsize;
  80092e:	89 b3 80 00 00 00    	mov    %esi,0x80(%ebx)
	flush_block(f);
  800934:	83 ec 0c             	sub    $0xc,%esp
  800937:	53                   	push   %ebx
  800938:	e8 80 fa ff ff       	call   8003bd <flush_block>
	return 0;
}
  80093d:	b8 00 00 00 00       	mov    $0x0,%eax
  800942:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800945:	5b                   	pop    %ebx
  800946:	5e                   	pop    %esi
  800947:	5d                   	pop    %ebp
  800948:	c3                   	ret    
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  800949:	8d 96 fe 1f 00 00    	lea    0x1ffe(%esi),%edx
  80094f:	89 f1                	mov    %esi,%ecx
  800951:	81 c1 ff 0f 00 00    	add    $0xfff,%ecx
  800957:	0f 49 d1             	cmovns %ecx,%edx
  80095a:	c1 fa 0c             	sar    $0xc,%edx
	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  80095d:	8d 88 fe 1f 00 00    	lea    0x1ffe(%eax),%ecx
  800963:	05 ff 0f 00 00       	add    $0xfff,%eax
  800968:	0f 48 c1             	cmovs  %ecx,%eax
  80096b:	c1 f8 0c             	sar    $0xc,%eax
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  80096e:	39 d0                	cmp    %edx,%eax
  800970:	77 27                	ja     800999 <file_set_size+0x80>
	if (new_nblocks <= NDIRECT && f->f_indirect) {
  800972:	83 fa 0a             	cmp    $0xa,%edx
  800975:	77 b7                	ja     80092e <file_set_size+0x15>
  800977:	8b 83 b0 00 00 00    	mov    0xb0(%ebx),%eax
  80097d:	85 c0                	test   %eax,%eax
  80097f:	74 ad                	je     80092e <file_set_size+0x15>
		free_block(f->f_indirect);
  800981:	83 ec 0c             	sub    $0xc,%esp
  800984:	50                   	push   %eax
  800985:	e8 04 fd ff ff       	call   80068e <free_block>
		f->f_indirect = 0;
  80098a:	c7 83 b0 00 00 00 00 	movl   $0x0,0xb0(%ebx)
  800991:	00 00 00 
  800994:	83 c4 10             	add    $0x10,%esp
  800997:	eb 95                	jmp    80092e <file_set_size+0x15>
       panic("file_block_walk not implemented");
  800999:	83 ec 04             	sub    $0x4,%esp
  80099c:	68 98 34 80 00       	push   $0x803498
  8009a1:	68 8a 00 00 00       	push   $0x8a
  8009a6:	68 a6 33 80 00       	push   $0x8033a6
  8009ab:	e8 c1 09 00 00       	call   801371 <_panic>

008009b0 <file_write>:
{
  8009b0:	55                   	push   %ebp
  8009b1:	89 e5                	mov    %esp,%ebp
  8009b3:	57                   	push   %edi
  8009b4:	56                   	push   %esi
  8009b5:	53                   	push   %ebx
  8009b6:	83 ec 0c             	sub    $0xc,%esp
  8009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bc:	8b 7d 10             	mov    0x10(%ebp),%edi
  8009bf:	8b 75 14             	mov    0x14(%ebp),%esi
	if (offset + count > f->f_size)
  8009c2:	8d 1c 3e             	lea    (%esi,%edi,1),%ebx
  8009c5:	3b 98 80 00 00 00    	cmp    0x80(%eax),%ebx
  8009cb:	77 0e                	ja     8009db <file_write+0x2b>
	for (pos = offset; pos < offset + count; ) {
  8009cd:	39 de                	cmp    %ebx,%esi
  8009cf:	72 1d                	jb     8009ee <file_write+0x3e>
	return count;
  8009d1:	89 f8                	mov    %edi,%eax
}
  8009d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009d6:	5b                   	pop    %ebx
  8009d7:	5e                   	pop    %esi
  8009d8:	5f                   	pop    %edi
  8009d9:	5d                   	pop    %ebp
  8009da:	c3                   	ret    
		if ((r = file_set_size(f, offset + count)) < 0)
  8009db:	83 ec 08             	sub    $0x8,%esp
  8009de:	53                   	push   %ebx
  8009df:	50                   	push   %eax
  8009e0:	e8 34 ff ff ff       	call   800919 <file_set_size>
  8009e5:	83 c4 10             	add    $0x10,%esp
  8009e8:	85 c0                	test   %eax,%eax
  8009ea:	79 e1                	jns    8009cd <file_write+0x1d>
  8009ec:	eb e5                	jmp    8009d3 <file_write+0x23>
       panic("file_get_block not implemented");
  8009ee:	83 ec 04             	sub    $0x4,%esp
  8009f1:	68 78 34 80 00       	push   $0x803478
  8009f6:	68 99 00 00 00       	push   $0x99
  8009fb:	68 a6 33 80 00       	push   $0x8033a6
  800a00:	e8 6c 09 00 00       	call   801371 <_panic>

00800a05 <file_flush>:
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void
file_flush(struct File *f)
{
  800a05:	55                   	push   %ebp
  800a06:	89 e5                	mov    %esp,%ebp
  800a08:	53                   	push   %ebx
  800a09:	83 ec 04             	sub    $0x4,%esp
  800a0c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  800a0f:	83 bb 80 00 00 00 00 	cmpl   $0x0,0x80(%ebx)
  800a16:	7f 1b                	jg     800a33 <file_flush+0x2e>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
		    pdiskbno == NULL || *pdiskbno == 0)
			continue;
		flush_block(diskaddr(*pdiskbno));
	}
	flush_block(f);
  800a18:	83 ec 0c             	sub    $0xc,%esp
  800a1b:	53                   	push   %ebx
  800a1c:	e8 9c f9 ff ff       	call   8003bd <flush_block>
	if (f->f_indirect)
  800a21:	8b 83 b0 00 00 00    	mov    0xb0(%ebx),%eax
  800a27:	83 c4 10             	add    $0x10,%esp
  800a2a:	85 c0                	test   %eax,%eax
  800a2c:	75 1c                	jne    800a4a <file_flush+0x45>
		flush_block(diskaddr(f->f_indirect));
}
  800a2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a31:	c9                   	leave  
  800a32:	c3                   	ret    
       panic("file_block_walk not implemented");
  800a33:	83 ec 04             	sub    $0x4,%esp
  800a36:	68 98 34 80 00       	push   $0x803498
  800a3b:	68 8a 00 00 00       	push   $0x8a
  800a40:	68 a6 33 80 00       	push   $0x8033a6
  800a45:	e8 27 09 00 00       	call   801371 <_panic>
		flush_block(diskaddr(f->f_indirect));
  800a4a:	83 ec 0c             	sub    $0xc,%esp
  800a4d:	50                   	push   %eax
  800a4e:	e8 ec f8 ff ff       	call   80033f <diskaddr>
  800a53:	89 04 24             	mov    %eax,(%esp)
  800a56:	e8 62 f9 ff ff       	call   8003bd <flush_block>
  800a5b:	83 c4 10             	add    $0x10,%esp
}
  800a5e:	eb ce                	jmp    800a2e <file_flush+0x29>

00800a60 <fs_sync>:


// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
  800a63:	53                   	push   %ebx
  800a64:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  800a67:	bb 01 00 00 00       	mov    $0x1,%ebx
  800a6c:	a1 08 90 80 00       	mov    0x809008,%eax
  800a71:	39 58 04             	cmp    %ebx,0x4(%eax)
  800a74:	76 19                	jbe    800a8f <fs_sync+0x2f>
		flush_block(diskaddr(i));
  800a76:	83 ec 0c             	sub    $0xc,%esp
  800a79:	53                   	push   %ebx
  800a7a:	e8 c0 f8 ff ff       	call   80033f <diskaddr>
  800a7f:	89 04 24             	mov    %eax,(%esp)
  800a82:	e8 36 f9 ff ff       	call   8003bd <flush_block>
	for (i = 1; i < super->s_nblocks; i++)
  800a87:	83 c3 01             	add    $0x1,%ebx
  800a8a:	83 c4 10             	add    $0x10,%esp
  800a8d:	eb dd                	jmp    800a6c <fs_sync+0xc>
}
  800a8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a92:	c9                   	leave  
  800a93:	c3                   	ret    

00800a94 <serve_read>:
	if (debug)
		cprintf("serve_read %08x %08x %08x\n", envid, req->req_fileid, req->req_n);

	// Lab 5: Your code here:
	return 0;
}
  800a94:	b8 00 00 00 00       	mov    $0x0,%eax
  800a99:	c3                   	ret    

00800a9a <serve_write>:
// the current seek position, and update the seek position
// accordingly.  Extend the file if necessary.  Returns the number of
// bytes written, or < 0 on error.
int
serve_write(envid_t envid, struct Fsreq_write *req)
{
  800a9a:	55                   	push   %ebp
  800a9b:	89 e5                	mov    %esp,%ebp
  800a9d:	83 ec 0c             	sub    $0xc,%esp
	if (debug)
		cprintf("serve_write %08x %08x %08x\n", envid, req->req_fileid, req->req_n);

	// LAB 5: Your code here.
	panic("serve_write not implemented");
  800aa0:	68 b8 34 80 00       	push   $0x8034b8
  800aa5:	68 e8 00 00 00       	push   $0xe8
  800aaa:	68 d4 34 80 00       	push   $0x8034d4
  800aaf:	e8 bd 08 00 00       	call   801371 <_panic>

00800ab4 <serve_sync>:
}


int
serve_sync(envid_t envid, union Fsipc *req)
{
  800ab4:	55                   	push   %ebp
  800ab5:	89 e5                	mov    %esp,%ebp
  800ab7:	83 ec 08             	sub    $0x8,%esp
	fs_sync();
  800aba:	e8 a1 ff ff ff       	call   800a60 <fs_sync>
	return 0;
}
  800abf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac4:	c9                   	leave  
  800ac5:	c3                   	ret    

00800ac6 <serve_init>:
{
  800ac6:	ba 60 40 80 00       	mov    $0x804060,%edx
	uintptr_t va = FILEVA;
  800acb:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
	for (i = 0; i < MAXOPEN; i++) {
  800ad0:	b8 00 00 00 00       	mov    $0x0,%eax
		opentab[i].o_fileid = i;
  800ad5:	89 02                	mov    %eax,(%edx)
		opentab[i].o_fd = (struct Fd*) va;
  800ad7:	89 4a 0c             	mov    %ecx,0xc(%edx)
		va += PGSIZE;
  800ada:	81 c1 00 10 00 00    	add    $0x1000,%ecx
	for (i = 0; i < MAXOPEN; i++) {
  800ae0:	83 c0 01             	add    $0x1,%eax
  800ae3:	83 c2 10             	add    $0x10,%edx
  800ae6:	3d 00 04 00 00       	cmp    $0x400,%eax
  800aeb:	75 e8                	jne    800ad5 <serve_init+0xf>
}
  800aed:	c3                   	ret    

00800aee <openfile_alloc>:
{
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
  800af1:	57                   	push   %edi
  800af2:	56                   	push   %esi
  800af3:	53                   	push   %ebx
  800af4:	83 ec 0c             	sub    $0xc,%esp
  800af7:	8b 7d 08             	mov    0x8(%ebp),%edi
	for (i = 0; i < MAXOPEN; i++) {
  800afa:	bb 00 00 00 00       	mov    $0x0,%ebx
  800aff:	89 de                	mov    %ebx,%esi
  800b01:	c1 e6 04             	shl    $0x4,%esi
		switch (pageref(opentab[i].o_fd)) {
  800b04:	83 ec 0c             	sub    $0xc,%esp
  800b07:	ff b6 6c 40 80 00    	pushl  0x80406c(%esi)
  800b0d:	e8 3d 1a 00 00       	call   80254f <pageref>
  800b12:	83 c4 10             	add    $0x10,%esp
  800b15:	85 c0                	test   %eax,%eax
  800b17:	74 17                	je     800b30 <openfile_alloc+0x42>
  800b19:	83 f8 01             	cmp    $0x1,%eax
  800b1c:	74 30                	je     800b4e <openfile_alloc+0x60>
	for (i = 0; i < MAXOPEN; i++) {
  800b1e:	83 c3 01             	add    $0x1,%ebx
  800b21:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  800b27:	75 d6                	jne    800aff <openfile_alloc+0x11>
	return -E_MAX_OPEN;
  800b29:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800b2e:	eb 4f                	jmp    800b7f <openfile_alloc+0x91>
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W)) < 0)
  800b30:	83 ec 04             	sub    $0x4,%esp
  800b33:	6a 07                	push   $0x7
  800b35:	89 d8                	mov    %ebx,%eax
  800b37:	c1 e0 04             	shl    $0x4,%eax
  800b3a:	ff b0 6c 40 80 00    	pushl  0x80406c(%eax)
  800b40:	6a 00                	push   $0x0
  800b42:	e8 1d 14 00 00       	call   801f64 <sys_page_alloc>
  800b47:	83 c4 10             	add    $0x10,%esp
  800b4a:	85 c0                	test   %eax,%eax
  800b4c:	78 31                	js     800b7f <openfile_alloc+0x91>
			opentab[i].o_fileid += MAXOPEN;
  800b4e:	c1 e3 04             	shl    $0x4,%ebx
  800b51:	81 83 60 40 80 00 00 	addl   $0x400,0x804060(%ebx)
  800b58:	04 00 00 
			*o = &opentab[i];
  800b5b:	81 c6 60 40 80 00    	add    $0x804060,%esi
  800b61:	89 37                	mov    %esi,(%edi)
			memset(opentab[i].o_fd, 0, PGSIZE);
  800b63:	83 ec 04             	sub    $0x4,%esp
  800b66:	68 00 10 00 00       	push   $0x1000
  800b6b:	6a 00                	push   $0x0
  800b6d:	ff b3 6c 40 80 00    	pushl  0x80406c(%ebx)
  800b73:	e8 40 11 00 00       	call   801cb8 <memset>
			return (*o)->o_fileid;
  800b78:	8b 07                	mov    (%edi),%eax
  800b7a:	8b 00                	mov    (%eax),%eax
  800b7c:	83 c4 10             	add    $0x10,%esp
}
  800b7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b82:	5b                   	pop    %ebx
  800b83:	5e                   	pop    %esi
  800b84:	5f                   	pop    %edi
  800b85:	5d                   	pop    %ebp
  800b86:	c3                   	ret    

00800b87 <openfile_lookup>:
{
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
  800b8a:	57                   	push   %edi
  800b8b:	56                   	push   %esi
  800b8c:	53                   	push   %ebx
  800b8d:	83 ec 18             	sub    $0x18,%esp
  800b90:	8b 7d 0c             	mov    0xc(%ebp),%edi
	o = &opentab[fileid % MAXOPEN];
  800b93:	89 fb                	mov    %edi,%ebx
  800b95:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  800b9b:	89 de                	mov    %ebx,%esi
  800b9d:	c1 e6 04             	shl    $0x4,%esi
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
  800ba0:	ff b6 6c 40 80 00    	pushl  0x80406c(%esi)
	o = &opentab[fileid % MAXOPEN];
  800ba6:	81 c6 60 40 80 00    	add    $0x804060,%esi
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
  800bac:	e8 9e 19 00 00       	call   80254f <pageref>
  800bb1:	83 c4 10             	add    $0x10,%esp
  800bb4:	83 f8 01             	cmp    $0x1,%eax
  800bb7:	7e 1d                	jle    800bd6 <openfile_lookup+0x4f>
  800bb9:	c1 e3 04             	shl    $0x4,%ebx
  800bbc:	39 bb 60 40 80 00    	cmp    %edi,0x804060(%ebx)
  800bc2:	75 19                	jne    800bdd <openfile_lookup+0x56>
	*po = o;
  800bc4:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc7:	89 30                	mov    %esi,(%eax)
	return 0;
  800bc9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bd1:	5b                   	pop    %ebx
  800bd2:	5e                   	pop    %esi
  800bd3:	5f                   	pop    %edi
  800bd4:	5d                   	pop    %ebp
  800bd5:	c3                   	ret    
		return -E_INVAL;
  800bd6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bdb:	eb f1                	jmp    800bce <openfile_lookup+0x47>
  800bdd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800be2:	eb ea                	jmp    800bce <openfile_lookup+0x47>

00800be4 <serve_set_size>:
{
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	53                   	push   %ebx
  800be8:	83 ec 18             	sub    $0x18,%esp
  800beb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  800bee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800bf1:	50                   	push   %eax
  800bf2:	ff 33                	pushl  (%ebx)
  800bf4:	ff 75 08             	pushl  0x8(%ebp)
  800bf7:	e8 8b ff ff ff       	call   800b87 <openfile_lookup>
  800bfc:	83 c4 10             	add    $0x10,%esp
  800bff:	85 c0                	test   %eax,%eax
  800c01:	78 14                	js     800c17 <serve_set_size+0x33>
	return file_set_size(o->o_file, req->req_size);
  800c03:	83 ec 08             	sub    $0x8,%esp
  800c06:	ff 73 04             	pushl  0x4(%ebx)
  800c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c0c:	ff 70 04             	pushl  0x4(%eax)
  800c0f:	e8 05 fd ff ff       	call   800919 <file_set_size>
  800c14:	83 c4 10             	add    $0x10,%esp
}
  800c17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c1a:	c9                   	leave  
  800c1b:	c3                   	ret    

00800c1c <serve_stat>:
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	53                   	push   %ebx
  800c20:	83 ec 18             	sub    $0x18,%esp
  800c23:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  800c26:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c29:	50                   	push   %eax
  800c2a:	ff 33                	pushl  (%ebx)
  800c2c:	ff 75 08             	pushl  0x8(%ebp)
  800c2f:	e8 53 ff ff ff       	call   800b87 <openfile_lookup>
  800c34:	83 c4 10             	add    $0x10,%esp
  800c37:	85 c0                	test   %eax,%eax
  800c39:	78 3f                	js     800c7a <serve_stat+0x5e>
	strcpy(ret->ret_name, o->o_file->f_name);
  800c3b:	83 ec 08             	sub    $0x8,%esp
  800c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c41:	ff 70 04             	pushl  0x4(%eax)
  800c44:	53                   	push   %ebx
  800c45:	e8 28 0f 00 00       	call   801b72 <strcpy>
	ret->ret_size = o->o_file->f_size;
  800c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c4d:	8b 50 04             	mov    0x4(%eax),%edx
  800c50:	8b 92 80 00 00 00    	mov    0x80(%edx),%edx
  800c56:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  800c5c:	8b 40 04             	mov    0x4(%eax),%eax
  800c5f:	83 c4 10             	add    $0x10,%esp
  800c62:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  800c69:	0f 94 c0             	sete   %al
  800c6c:	0f b6 c0             	movzbl %al,%eax
  800c6f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800c75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c7d:	c9                   	leave  
  800c7e:	c3                   	ret    

00800c7f <serve_flush>:
{
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  800c85:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c88:	50                   	push   %eax
  800c89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8c:	ff 30                	pushl  (%eax)
  800c8e:	ff 75 08             	pushl  0x8(%ebp)
  800c91:	e8 f1 fe ff ff       	call   800b87 <openfile_lookup>
  800c96:	83 c4 10             	add    $0x10,%esp
  800c99:	85 c0                	test   %eax,%eax
  800c9b:	78 16                	js     800cb3 <serve_flush+0x34>
	file_flush(o->o_file);
  800c9d:	83 ec 0c             	sub    $0xc,%esp
  800ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ca3:	ff 70 04             	pushl  0x4(%eax)
  800ca6:	e8 5a fd ff ff       	call   800a05 <file_flush>
	return 0;
  800cab:	83 c4 10             	add    $0x10,%esp
  800cae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cb3:	c9                   	leave  
  800cb4:	c3                   	ret    

00800cb5 <serve_open>:
{
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
  800cb8:	53                   	push   %ebx
  800cb9:	81 ec 18 04 00 00    	sub    $0x418,%esp
  800cbf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	memmove(path, req->req_path, MAXPATHLEN);
  800cc2:	68 00 04 00 00       	push   $0x400
  800cc7:	53                   	push   %ebx
  800cc8:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  800cce:	50                   	push   %eax
  800ccf:	e8 2c 10 00 00       	call   801d00 <memmove>
	path[MAXPATHLEN-1] = 0;
  800cd4:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	if ((r = openfile_alloc(&o)) < 0) {
  800cd8:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  800cde:	89 04 24             	mov    %eax,(%esp)
  800ce1:	e8 08 fe ff ff       	call   800aee <openfile_alloc>
  800ce6:	83 c4 10             	add    $0x10,%esp
  800ce9:	85 c0                	test   %eax,%eax
  800ceb:	0f 88 f0 00 00 00    	js     800de1 <serve_open+0x12c>
	if (req->req_omode & O_CREAT) {
  800cf1:	f6 83 01 04 00 00 01 	testb  $0x1,0x401(%ebx)
  800cf8:	74 33                	je     800d2d <serve_open+0x78>
		if ((r = file_create(path, &f)) < 0) {
  800cfa:	83 ec 08             	sub    $0x8,%esp
  800cfd:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  800d03:	50                   	push   %eax
  800d04:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  800d0a:	50                   	push   %eax
  800d0b:	e8 f8 fa ff ff       	call   800808 <file_create>
  800d10:	83 c4 10             	add    $0x10,%esp
  800d13:	85 c0                	test   %eax,%eax
  800d15:	79 37                	jns    800d4e <serve_open+0x99>
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
  800d17:	f6 83 01 04 00 00 04 	testb  $0x4,0x401(%ebx)
  800d1e:	0f 85 bd 00 00 00    	jne    800de1 <serve_open+0x12c>
  800d24:	83 f8 f3             	cmp    $0xfffffff3,%eax
  800d27:	0f 85 b4 00 00 00    	jne    800de1 <serve_open+0x12c>
		if ((r = file_open(path, &f)) < 0) {
  800d2d:	83 ec 08             	sub    $0x8,%esp
  800d30:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  800d36:	50                   	push   %eax
  800d37:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  800d3d:	50                   	push   %eax
  800d3e:	e8 75 fb ff ff       	call   8008b8 <file_open>
  800d43:	83 c4 10             	add    $0x10,%esp
  800d46:	85 c0                	test   %eax,%eax
  800d48:	0f 88 93 00 00 00    	js     800de1 <serve_open+0x12c>
	if (req->req_omode & O_TRUNC) {
  800d4e:	f6 83 01 04 00 00 02 	testb  $0x2,0x401(%ebx)
  800d55:	74 17                	je     800d6e <serve_open+0xb9>
		if ((r = file_set_size(f, 0)) < 0) {
  800d57:	83 ec 08             	sub    $0x8,%esp
  800d5a:	6a 00                	push   $0x0
  800d5c:	ff b5 f4 fb ff ff    	pushl  -0x40c(%ebp)
  800d62:	e8 b2 fb ff ff       	call   800919 <file_set_size>
  800d67:	83 c4 10             	add    $0x10,%esp
  800d6a:	85 c0                	test   %eax,%eax
  800d6c:	78 73                	js     800de1 <serve_open+0x12c>
	if ((r = file_open(path, &f)) < 0) {
  800d6e:	83 ec 08             	sub    $0x8,%esp
  800d71:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  800d77:	50                   	push   %eax
  800d78:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  800d7e:	50                   	push   %eax
  800d7f:	e8 34 fb ff ff       	call   8008b8 <file_open>
  800d84:	83 c4 10             	add    $0x10,%esp
  800d87:	85 c0                	test   %eax,%eax
  800d89:	78 56                	js     800de1 <serve_open+0x12c>
	o->o_file = f;
  800d8b:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  800d91:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
  800d97:	89 50 04             	mov    %edx,0x4(%eax)
	o->o_fd->fd_file.id = o->o_fileid;
  800d9a:	8b 50 0c             	mov    0xc(%eax),%edx
  800d9d:	8b 08                	mov    (%eax),%ecx
  800d9f:	89 4a 0c             	mov    %ecx,0xc(%edx)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  800da2:	8b 48 0c             	mov    0xc(%eax),%ecx
  800da5:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  800dab:	83 e2 03             	and    $0x3,%edx
  800dae:	89 51 08             	mov    %edx,0x8(%ecx)
	o->o_fd->fd_dev_id = devfile.dev_id;
  800db1:	8b 40 0c             	mov    0xc(%eax),%eax
  800db4:	8b 15 64 80 80 00    	mov    0x808064,%edx
  800dba:	89 10                	mov    %edx,(%eax)
	o->o_mode = req->req_omode;
  800dbc:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  800dc2:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  800dc8:	89 50 08             	mov    %edx,0x8(%eax)
	*pg_store = o->o_fd;
  800dcb:	8b 50 0c             	mov    0xc(%eax),%edx
  800dce:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd1:	89 10                	mov    %edx,(%eax)
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  800dd3:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd6:	c7 00 07 04 00 00    	movl   $0x407,(%eax)
	return 0;
  800ddc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800de1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800de4:	c9                   	leave  
  800de5:	c3                   	ret    

00800de6 <serve>:
	[FSREQ_SYNC] =		serve_sync
};

void
serve(void)
{
  800de6:	55                   	push   %ebp
  800de7:	89 e5                	mov    %esp,%ebp
  800de9:	56                   	push   %esi
  800dea:	53                   	push   %ebx
  800deb:	83 ec 10             	sub    $0x10,%esp
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  800dee:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  800df1:	8d 75 f4             	lea    -0xc(%ebp),%esi
  800df4:	e9 82 00 00 00       	jmp    800e7b <serve+0x95>
			cprintf("Invalid request from %08x: no argument page\n",
				whom);
			continue; // just leave it hanging...
		}

		pg = NULL;
  800df9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		if (req == FSREQ_OPEN) {
  800e00:	83 f8 01             	cmp    $0x1,%eax
  800e03:	74 23                	je     800e28 <serve+0x42>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
		} else if (req < ARRAY_SIZE(handlers) && handlers[req]) {
  800e05:	83 f8 08             	cmp    $0x8,%eax
  800e08:	77 36                	ja     800e40 <serve+0x5a>
  800e0a:	8b 14 85 20 40 80 00 	mov    0x804020(,%eax,4),%edx
  800e11:	85 d2                	test   %edx,%edx
  800e13:	74 2b                	je     800e40 <serve+0x5a>
			r = handlers[req](whom, fsreq);
  800e15:	83 ec 08             	sub    $0x8,%esp
  800e18:	ff 35 44 40 80 00    	pushl  0x804044
  800e1e:	ff 75 f4             	pushl  -0xc(%ebp)
  800e21:	ff d2                	call   *%edx
  800e23:	83 c4 10             	add    $0x10,%esp
  800e26:	eb 31                	jmp    800e59 <serve+0x73>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  800e28:	53                   	push   %ebx
  800e29:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e2c:	50                   	push   %eax
  800e2d:	ff 35 44 40 80 00    	pushl  0x804044
  800e33:	ff 75 f4             	pushl  -0xc(%ebp)
  800e36:	e8 7a fe ff ff       	call   800cb5 <serve_open>
  800e3b:	83 c4 10             	add    $0x10,%esp
  800e3e:	eb 19                	jmp    800e59 <serve+0x73>
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  800e40:	83 ec 04             	sub    $0x4,%esp
  800e43:	ff 75 f4             	pushl  -0xc(%ebp)
  800e46:	50                   	push   %eax
  800e47:	68 30 35 80 00       	push   $0x803530
  800e4c:	e8 fb 05 00 00       	call   80144c <cprintf>
  800e51:	83 c4 10             	add    $0x10,%esp
			r = -E_INVAL;
  800e54:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		}
		ipc_send(whom, r, pg, perm);
  800e59:	ff 75 f0             	pushl  -0x10(%ebp)
  800e5c:	ff 75 ec             	pushl  -0x14(%ebp)
  800e5f:	50                   	push   %eax
  800e60:	ff 75 f4             	pushl  -0xc(%ebp)
  800e63:	e8 28 14 00 00       	call   802290 <ipc_send>
		sys_page_unmap(0, fsreq);
  800e68:	83 c4 08             	add    $0x8,%esp
  800e6b:	ff 35 44 40 80 00    	pushl  0x804044
  800e71:	6a 00                	push   $0x0
  800e73:	e8 71 11 00 00       	call   801fe9 <sys_page_unmap>
  800e78:	83 c4 10             	add    $0x10,%esp
		perm = 0;
  800e7b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  800e82:	83 ec 04             	sub    $0x4,%esp
  800e85:	53                   	push   %ebx
  800e86:	ff 35 44 40 80 00    	pushl  0x804044
  800e8c:	56                   	push   %esi
  800e8d:	e8 95 13 00 00       	call   802227 <ipc_recv>
		if (!(perm & PTE_P)) {
  800e92:	83 c4 10             	add    $0x10,%esp
  800e95:	f6 45 f0 01          	testb  $0x1,-0x10(%ebp)
  800e99:	0f 85 5a ff ff ff    	jne    800df9 <serve+0x13>
			cprintf("Invalid request from %08x: no argument page\n",
  800e9f:	83 ec 08             	sub    $0x8,%esp
  800ea2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ea5:	68 00 35 80 00       	push   $0x803500
  800eaa:	e8 9d 05 00 00       	call   80144c <cprintf>
			continue; // just leave it hanging...
  800eaf:	83 c4 10             	add    $0x10,%esp
  800eb2:	eb c7                	jmp    800e7b <serve+0x95>

00800eb4 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	83 ec 14             	sub    $0x14,%esp
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  800eba:	c7 05 60 80 80 00 de 	movl   $0x8034de,0x808060
  800ec1:	34 80 00 
	cprintf("FS is running\n");
  800ec4:	68 e1 34 80 00       	push   $0x8034e1
  800ec9:	e8 7e 05 00 00       	call   80144c <cprintf>
	asm volatile("outw %0,%w1" : : "a" (data), "d" (port));
  800ece:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
  800ed3:	ba 00 8a 00 00       	mov    $0x8a00,%edx
  800ed8:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  800eda:	c7 04 24 f0 34 80 00 	movl   $0x8034f0,(%esp)
  800ee1:	e8 66 05 00 00       	call   80144c <cprintf>

	serve_init();
  800ee6:	e8 db fb ff ff       	call   800ac6 <serve_init>
	fs_init();
  800eeb:	e8 9f f8 ff ff       	call   80078f <fs_init>
        fs_test();
  800ef0:	e8 05 00 00 00       	call   800efa <fs_test>
	serve();
  800ef5:	e8 ec fe ff ff       	call   800de6 <serve>

00800efa <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  800efa:	55                   	push   %ebp
  800efb:	89 e5                	mov    %esp,%ebp
  800efd:	53                   	push   %ebx
  800efe:	83 ec 18             	sub    $0x18,%esp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  800f01:	6a 07                	push   $0x7
  800f03:	68 00 10 00 00       	push   $0x1000
  800f08:	6a 00                	push   $0x0
  800f0a:	e8 55 10 00 00       	call   801f64 <sys_page_alloc>
  800f0f:	83 c4 10             	add    $0x10,%esp
  800f12:	85 c0                	test   %eax,%eax
  800f14:	0f 88 68 02 00 00    	js     801182 <fs_test+0x288>
		panic("sys_page_alloc: %e", r);
	bits = (uint32_t*) PGSIZE;
	memmove(bits, bitmap, PGSIZE);
  800f1a:	83 ec 04             	sub    $0x4,%esp
  800f1d:	68 00 10 00 00       	push   $0x1000
  800f22:	ff 35 04 90 80 00    	pushl  0x809004
  800f28:	68 00 10 00 00       	push   $0x1000
  800f2d:	e8 ce 0d 00 00       	call   801d00 <memmove>
	// allocate block
	if ((r = alloc_block()) < 0)
  800f32:	e8 93 f7 ff ff       	call   8006ca <alloc_block>
  800f37:	83 c4 10             	add    $0x10,%esp
  800f3a:	85 c0                	test   %eax,%eax
  800f3c:	0f 88 52 02 00 00    	js     801194 <fs_test+0x29a>
		panic("alloc_block: %e", r);
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  800f42:	8d 50 1f             	lea    0x1f(%eax),%edx
  800f45:	0f 49 d0             	cmovns %eax,%edx
  800f48:	c1 fa 05             	sar    $0x5,%edx
  800f4b:	89 c3                	mov    %eax,%ebx
  800f4d:	c1 fb 1f             	sar    $0x1f,%ebx
  800f50:	c1 eb 1b             	shr    $0x1b,%ebx
  800f53:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
  800f56:	83 e1 1f             	and    $0x1f,%ecx
  800f59:	29 d9                	sub    %ebx,%ecx
  800f5b:	b8 01 00 00 00       	mov    $0x1,%eax
  800f60:	d3 e0                	shl    %cl,%eax
  800f62:	85 04 95 00 10 00 00 	test   %eax,0x1000(,%edx,4)
  800f69:	0f 84 37 02 00 00    	je     8011a6 <fs_test+0x2ac>
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  800f6f:	8b 0d 04 90 80 00    	mov    0x809004,%ecx
  800f75:	85 04 91             	test   %eax,(%ecx,%edx,4)
  800f78:	0f 85 3e 02 00 00    	jne    8011bc <fs_test+0x2c2>
	cprintf("alloc_block is good\n");
  800f7e:	83 ec 0c             	sub    $0xc,%esp
  800f81:	68 9b 35 80 00       	push   $0x80359b
  800f86:	e8 c1 04 00 00       	call   80144c <cprintf>

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  800f8b:	83 c4 08             	add    $0x8,%esp
  800f8e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f91:	50                   	push   %eax
  800f92:	68 b0 35 80 00       	push   $0x8035b0
  800f97:	e8 1c f9 ff ff       	call   8008b8 <file_open>
  800f9c:	83 c4 10             	add    $0x10,%esp
  800f9f:	83 f8 f5             	cmp    $0xfffffff5,%eax
  800fa2:	74 08                	je     800fac <fs_test+0xb2>
  800fa4:	85 c0                	test   %eax,%eax
  800fa6:	0f 88 26 02 00 00    	js     8011d2 <fs_test+0x2d8>
		panic("file_open /not-found: %e", r);
	else if (r == 0)
  800fac:	85 c0                	test   %eax,%eax
  800fae:	0f 84 30 02 00 00    	je     8011e4 <fs_test+0x2ea>
		panic("file_open /not-found succeeded!");
	if ((r = file_open("/newmotd", &f)) < 0)
  800fb4:	83 ec 08             	sub    $0x8,%esp
  800fb7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fba:	50                   	push   %eax
  800fbb:	68 d4 35 80 00       	push   $0x8035d4
  800fc0:	e8 f3 f8 ff ff       	call   8008b8 <file_open>
  800fc5:	83 c4 10             	add    $0x10,%esp
  800fc8:	85 c0                	test   %eax,%eax
  800fca:	0f 88 28 02 00 00    	js     8011f8 <fs_test+0x2fe>
		panic("file_open /newmotd: %e", r);
	cprintf("file_open is good\n");
  800fd0:	83 ec 0c             	sub    $0xc,%esp
  800fd3:	68 f4 35 80 00       	push   $0x8035f4
  800fd8:	e8 6f 04 00 00       	call   80144c <cprintf>

	if ((r = file_get_block(f, 0, &blk)) < 0)
  800fdd:	83 c4 0c             	add    $0xc,%esp
  800fe0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800fe3:	50                   	push   %eax
  800fe4:	6a 00                	push   $0x0
  800fe6:	ff 75 f4             	pushl  -0xc(%ebp)
  800fe9:	e8 00 f8 ff ff       	call   8007ee <file_get_block>
  800fee:	83 c4 10             	add    $0x10,%esp
  800ff1:	85 c0                	test   %eax,%eax
  800ff3:	0f 88 11 02 00 00    	js     80120a <fs_test+0x310>
		panic("file_get_block: %e", r);
	if (strcmp(blk, msg) != 0)
  800ff9:	83 ec 08             	sub    $0x8,%esp
  800ffc:	68 38 37 80 00       	push   $0x803738
  801001:	ff 75 f0             	pushl  -0x10(%ebp)
  801004:	e8 14 0c 00 00       	call   801c1d <strcmp>
  801009:	83 c4 10             	add    $0x10,%esp
  80100c:	85 c0                	test   %eax,%eax
  80100e:	0f 85 08 02 00 00    	jne    80121c <fs_test+0x322>
		panic("file_get_block returned wrong data");
	cprintf("file_get_block is good\n");
  801014:	83 ec 0c             	sub    $0xc,%esp
  801017:	68 1a 36 80 00       	push   $0x80361a
  80101c:	e8 2b 04 00 00       	call   80144c <cprintf>

	*(volatile char*)blk = *(volatile char*)blk;
  801021:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801024:	0f b6 10             	movzbl (%eax),%edx
  801027:	88 10                	mov    %dl,(%eax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801029:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80102c:	c1 e8 0c             	shr    $0xc,%eax
  80102f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801036:	83 c4 10             	add    $0x10,%esp
  801039:	a8 40                	test   $0x40,%al
  80103b:	0f 84 ef 01 00 00    	je     801230 <fs_test+0x336>
	file_flush(f);
  801041:	83 ec 0c             	sub    $0xc,%esp
  801044:	ff 75 f4             	pushl  -0xc(%ebp)
  801047:	e8 b9 f9 ff ff       	call   800a05 <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  80104c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80104f:	c1 e8 0c             	shr    $0xc,%eax
  801052:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801059:	83 c4 10             	add    $0x10,%esp
  80105c:	a8 40                	test   $0x40,%al
  80105e:	0f 85 e2 01 00 00    	jne    801246 <fs_test+0x34c>
	cprintf("file_flush is good\n");
  801064:	83 ec 0c             	sub    $0xc,%esp
  801067:	68 4e 36 80 00       	push   $0x80364e
  80106c:	e8 db 03 00 00       	call   80144c <cprintf>

	if ((r = file_set_size(f, 0)) < 0)
  801071:	83 c4 08             	add    $0x8,%esp
  801074:	6a 00                	push   $0x0
  801076:	ff 75 f4             	pushl  -0xc(%ebp)
  801079:	e8 9b f8 ff ff       	call   800919 <file_set_size>
  80107e:	83 c4 10             	add    $0x10,%esp
  801081:	85 c0                	test   %eax,%eax
  801083:	0f 88 d3 01 00 00    	js     80125c <fs_test+0x362>
		panic("file_set_size: %e", r);
	assert(f->f_direct[0] == 0);
  801089:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80108c:	83 b8 88 00 00 00 00 	cmpl   $0x0,0x88(%eax)
  801093:	0f 85 d5 01 00 00    	jne    80126e <fs_test+0x374>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801099:	c1 e8 0c             	shr    $0xc,%eax
  80109c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010a3:	a8 40                	test   $0x40,%al
  8010a5:	0f 85 d9 01 00 00    	jne    801284 <fs_test+0x38a>
	cprintf("file_truncate is good\n");
  8010ab:	83 ec 0c             	sub    $0xc,%esp
  8010ae:	68 a2 36 80 00       	push   $0x8036a2
  8010b3:	e8 94 03 00 00       	call   80144c <cprintf>

	if ((r = file_set_size(f, strlen(msg))) < 0)
  8010b8:	c7 04 24 38 37 80 00 	movl   $0x803738,(%esp)
  8010bf:	e8 75 0a 00 00       	call   801b39 <strlen>
  8010c4:	83 c4 08             	add    $0x8,%esp
  8010c7:	50                   	push   %eax
  8010c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8010cb:	e8 49 f8 ff ff       	call   800919 <file_set_size>
  8010d0:	83 c4 10             	add    $0x10,%esp
  8010d3:	85 c0                	test   %eax,%eax
  8010d5:	0f 88 bf 01 00 00    	js     80129a <fs_test+0x3a0>
		panic("file_set_size 2: %e", r);
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  8010db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010de:	89 c2                	mov    %eax,%edx
  8010e0:	c1 ea 0c             	shr    $0xc,%edx
  8010e3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010ea:	f6 c2 40             	test   $0x40,%dl
  8010ed:	0f 85 b9 01 00 00    	jne    8012ac <fs_test+0x3b2>
	if ((r = file_get_block(f, 0, &blk)) < 0)
  8010f3:	83 ec 04             	sub    $0x4,%esp
  8010f6:	8d 55 f0             	lea    -0x10(%ebp),%edx
  8010f9:	52                   	push   %edx
  8010fa:	6a 00                	push   $0x0
  8010fc:	50                   	push   %eax
  8010fd:	e8 ec f6 ff ff       	call   8007ee <file_get_block>
  801102:	83 c4 10             	add    $0x10,%esp
  801105:	85 c0                	test   %eax,%eax
  801107:	0f 88 b5 01 00 00    	js     8012c2 <fs_test+0x3c8>
		panic("file_get_block 2: %e", r);
	strcpy(blk, msg);
  80110d:	83 ec 08             	sub    $0x8,%esp
  801110:	68 38 37 80 00       	push   $0x803738
  801115:	ff 75 f0             	pushl  -0x10(%ebp)
  801118:	e8 55 0a 00 00       	call   801b72 <strcpy>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  80111d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801120:	c1 e8 0c             	shr    $0xc,%eax
  801123:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80112a:	83 c4 10             	add    $0x10,%esp
  80112d:	a8 40                	test   $0x40,%al
  80112f:	0f 84 9f 01 00 00    	je     8012d4 <fs_test+0x3da>
	file_flush(f);
  801135:	83 ec 0c             	sub    $0xc,%esp
  801138:	ff 75 f4             	pushl  -0xc(%ebp)
  80113b:	e8 c5 f8 ff ff       	call   800a05 <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801140:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801143:	c1 e8 0c             	shr    $0xc,%eax
  801146:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80114d:	83 c4 10             	add    $0x10,%esp
  801150:	a8 40                	test   $0x40,%al
  801152:	0f 85 92 01 00 00    	jne    8012ea <fs_test+0x3f0>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801158:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80115b:	c1 e8 0c             	shr    $0xc,%eax
  80115e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801165:	a8 40                	test   $0x40,%al
  801167:	0f 85 93 01 00 00    	jne    801300 <fs_test+0x406>
	cprintf("file rewrite is good\n");
  80116d:	83 ec 0c             	sub    $0xc,%esp
  801170:	68 e2 36 80 00       	push   $0x8036e2
  801175:	e8 d2 02 00 00       	call   80144c <cprintf>
}
  80117a:	83 c4 10             	add    $0x10,%esp
  80117d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801180:	c9                   	leave  
  801181:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  801182:	50                   	push   %eax
  801183:	68 53 35 80 00       	push   $0x803553
  801188:	6a 12                	push   $0x12
  80118a:	68 66 35 80 00       	push   $0x803566
  80118f:	e8 dd 01 00 00       	call   801371 <_panic>
		panic("alloc_block: %e", r);
  801194:	50                   	push   %eax
  801195:	68 70 35 80 00       	push   $0x803570
  80119a:	6a 17                	push   $0x17
  80119c:	68 66 35 80 00       	push   $0x803566
  8011a1:	e8 cb 01 00 00       	call   801371 <_panic>
	assert(bits[r/32] & (1 << (r%32)));
  8011a6:	68 80 35 80 00       	push   $0x803580
  8011ab:	68 7d 32 80 00       	push   $0x80327d
  8011b0:	6a 19                	push   $0x19
  8011b2:	68 66 35 80 00       	push   $0x803566
  8011b7:	e8 b5 01 00 00       	call   801371 <_panic>
	assert(!(bitmap[r/32] & (1 << (r%32))));
  8011bc:	68 f8 36 80 00       	push   $0x8036f8
  8011c1:	68 7d 32 80 00       	push   $0x80327d
  8011c6:	6a 1b                	push   $0x1b
  8011c8:	68 66 35 80 00       	push   $0x803566
  8011cd:	e8 9f 01 00 00       	call   801371 <_panic>
		panic("file_open /not-found: %e", r);
  8011d2:	50                   	push   %eax
  8011d3:	68 bb 35 80 00       	push   $0x8035bb
  8011d8:	6a 1f                	push   $0x1f
  8011da:	68 66 35 80 00       	push   $0x803566
  8011df:	e8 8d 01 00 00       	call   801371 <_panic>
		panic("file_open /not-found succeeded!");
  8011e4:	83 ec 04             	sub    $0x4,%esp
  8011e7:	68 18 37 80 00       	push   $0x803718
  8011ec:	6a 21                	push   $0x21
  8011ee:	68 66 35 80 00       	push   $0x803566
  8011f3:	e8 79 01 00 00       	call   801371 <_panic>
		panic("file_open /newmotd: %e", r);
  8011f8:	50                   	push   %eax
  8011f9:	68 dd 35 80 00       	push   $0x8035dd
  8011fe:	6a 23                	push   $0x23
  801200:	68 66 35 80 00       	push   $0x803566
  801205:	e8 67 01 00 00       	call   801371 <_panic>
		panic("file_get_block: %e", r);
  80120a:	50                   	push   %eax
  80120b:	68 07 36 80 00       	push   $0x803607
  801210:	6a 27                	push   $0x27
  801212:	68 66 35 80 00       	push   $0x803566
  801217:	e8 55 01 00 00       	call   801371 <_panic>
		panic("file_get_block returned wrong data");
  80121c:	83 ec 04             	sub    $0x4,%esp
  80121f:	68 60 37 80 00       	push   $0x803760
  801224:	6a 29                	push   $0x29
  801226:	68 66 35 80 00       	push   $0x803566
  80122b:	e8 41 01 00 00       	call   801371 <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801230:	68 33 36 80 00       	push   $0x803633
  801235:	68 7d 32 80 00       	push   $0x80327d
  80123a:	6a 2d                	push   $0x2d
  80123c:	68 66 35 80 00       	push   $0x803566
  801241:	e8 2b 01 00 00       	call   801371 <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801246:	68 32 36 80 00       	push   $0x803632
  80124b:	68 7d 32 80 00       	push   $0x80327d
  801250:	6a 2f                	push   $0x2f
  801252:	68 66 35 80 00       	push   $0x803566
  801257:	e8 15 01 00 00       	call   801371 <_panic>
		panic("file_set_size: %e", r);
  80125c:	50                   	push   %eax
  80125d:	68 62 36 80 00       	push   $0x803662
  801262:	6a 33                	push   $0x33
  801264:	68 66 35 80 00       	push   $0x803566
  801269:	e8 03 01 00 00       	call   801371 <_panic>
	assert(f->f_direct[0] == 0);
  80126e:	68 74 36 80 00       	push   $0x803674
  801273:	68 7d 32 80 00       	push   $0x80327d
  801278:	6a 34                	push   $0x34
  80127a:	68 66 35 80 00       	push   $0x803566
  80127f:	e8 ed 00 00 00       	call   801371 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801284:	68 88 36 80 00       	push   $0x803688
  801289:	68 7d 32 80 00       	push   $0x80327d
  80128e:	6a 35                	push   $0x35
  801290:	68 66 35 80 00       	push   $0x803566
  801295:	e8 d7 00 00 00       	call   801371 <_panic>
		panic("file_set_size 2: %e", r);
  80129a:	50                   	push   %eax
  80129b:	68 b9 36 80 00       	push   $0x8036b9
  8012a0:	6a 39                	push   $0x39
  8012a2:	68 66 35 80 00       	push   $0x803566
  8012a7:	e8 c5 00 00 00       	call   801371 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  8012ac:	68 88 36 80 00       	push   $0x803688
  8012b1:	68 7d 32 80 00       	push   $0x80327d
  8012b6:	6a 3a                	push   $0x3a
  8012b8:	68 66 35 80 00       	push   $0x803566
  8012bd:	e8 af 00 00 00       	call   801371 <_panic>
		panic("file_get_block 2: %e", r);
  8012c2:	50                   	push   %eax
  8012c3:	68 cd 36 80 00       	push   $0x8036cd
  8012c8:	6a 3c                	push   $0x3c
  8012ca:	68 66 35 80 00       	push   $0x803566
  8012cf:	e8 9d 00 00 00       	call   801371 <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  8012d4:	68 33 36 80 00       	push   $0x803633
  8012d9:	68 7d 32 80 00       	push   $0x80327d
  8012de:	6a 3e                	push   $0x3e
  8012e0:	68 66 35 80 00       	push   $0x803566
  8012e5:	e8 87 00 00 00       	call   801371 <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  8012ea:	68 32 36 80 00       	push   $0x803632
  8012ef:	68 7d 32 80 00       	push   $0x80327d
  8012f4:	6a 40                	push   $0x40
  8012f6:	68 66 35 80 00       	push   $0x803566
  8012fb:	e8 71 00 00 00       	call   801371 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801300:	68 88 36 80 00       	push   $0x803688
  801305:	68 7d 32 80 00       	push   $0x80327d
  80130a:	6a 41                	push   $0x41
  80130c:	68 66 35 80 00       	push   $0x803566
  801311:	e8 5b 00 00 00       	call   801371 <_panic>

00801316 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
  801319:	56                   	push   %esi
  80131a:	53                   	push   %ebx
  80131b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80131e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  801321:	e8 00 0c 00 00       	call   801f26 <sys_getenvid>
  801326:	25 ff 03 00 00       	and    $0x3ff,%eax
  80132b:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801331:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801336:	a3 0c 90 80 00       	mov    %eax,0x80900c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80133b:	85 db                	test   %ebx,%ebx
  80133d:	7e 07                	jle    801346 <libmain+0x30>
		binaryname = argv[0];
  80133f:	8b 06                	mov    (%esi),%eax
  801341:	a3 60 80 80 00       	mov    %eax,0x808060

	// call user main routine
	umain(argc, argv);
  801346:	83 ec 08             	sub    $0x8,%esp
  801349:	56                   	push   %esi
  80134a:	53                   	push   %ebx
  80134b:	e8 64 fb ff ff       	call   800eb4 <umain>

	// exit gracefully
	exit();
  801350:	e8 0a 00 00 00       	call   80135f <exit>
}
  801355:	83 c4 10             	add    $0x10,%esp
  801358:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80135b:	5b                   	pop    %ebx
  80135c:	5e                   	pop    %esi
  80135d:	5d                   	pop    %ebp
  80135e:	c3                   	ret    

0080135f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80135f:	55                   	push   %ebp
  801360:	89 e5                	mov    %esp,%ebp
  801362:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  801365:	6a 00                	push   $0x0
  801367:	e8 79 0b 00 00       	call   801ee5 <sys_env_destroy>
}
  80136c:	83 c4 10             	add    $0x10,%esp
  80136f:	c9                   	leave  
  801370:	c3                   	ret    

00801371 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801371:	55                   	push   %ebp
  801372:	89 e5                	mov    %esp,%ebp
  801374:	56                   	push   %esi
  801375:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801376:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801379:	8b 35 60 80 80 00    	mov    0x808060,%esi
  80137f:	e8 a2 0b 00 00       	call   801f26 <sys_getenvid>
  801384:	83 ec 0c             	sub    $0xc,%esp
  801387:	ff 75 0c             	pushl  0xc(%ebp)
  80138a:	ff 75 08             	pushl  0x8(%ebp)
  80138d:	56                   	push   %esi
  80138e:	50                   	push   %eax
  80138f:	68 90 37 80 00       	push   $0x803790
  801394:	e8 b3 00 00 00       	call   80144c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801399:	83 c4 18             	add    $0x18,%esp
  80139c:	53                   	push   %ebx
  80139d:	ff 75 10             	pushl  0x10(%ebp)
  8013a0:	e8 56 00 00 00       	call   8013fb <vcprintf>
	cprintf("\n");
  8013a5:	c7 04 24 87 33 80 00 	movl   $0x803387,(%esp)
  8013ac:	e8 9b 00 00 00       	call   80144c <cprintf>
  8013b1:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8013b4:	cc                   	int3   
  8013b5:	eb fd                	jmp    8013b4 <_panic+0x43>

008013b7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
  8013ba:	53                   	push   %ebx
  8013bb:	83 ec 04             	sub    $0x4,%esp
  8013be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8013c1:	8b 13                	mov    (%ebx),%edx
  8013c3:	8d 42 01             	lea    0x1(%edx),%eax
  8013c6:	89 03                	mov    %eax,(%ebx)
  8013c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013cb:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8013cf:	3d ff 00 00 00       	cmp    $0xff,%eax
  8013d4:	74 09                	je     8013df <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8013d6:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8013da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013dd:	c9                   	leave  
  8013de:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8013df:	83 ec 08             	sub    $0x8,%esp
  8013e2:	68 ff 00 00 00       	push   $0xff
  8013e7:	8d 43 08             	lea    0x8(%ebx),%eax
  8013ea:	50                   	push   %eax
  8013eb:	e8 b8 0a 00 00       	call   801ea8 <sys_cputs>
		b->idx = 0;
  8013f0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8013f6:	83 c4 10             	add    $0x10,%esp
  8013f9:	eb db                	jmp    8013d6 <putch+0x1f>

008013fb <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8013fb:	55                   	push   %ebp
  8013fc:	89 e5                	mov    %esp,%ebp
  8013fe:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801404:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80140b:	00 00 00 
	b.cnt = 0;
  80140e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801415:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801418:	ff 75 0c             	pushl  0xc(%ebp)
  80141b:	ff 75 08             	pushl  0x8(%ebp)
  80141e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801424:	50                   	push   %eax
  801425:	68 b7 13 80 00       	push   $0x8013b7
  80142a:	e8 4a 01 00 00       	call   801579 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80142f:	83 c4 08             	add    $0x8,%esp
  801432:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801438:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80143e:	50                   	push   %eax
  80143f:	e8 64 0a 00 00       	call   801ea8 <sys_cputs>

	return b.cnt;
}
  801444:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80144a:	c9                   	leave  
  80144b:	c3                   	ret    

0080144c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80144c:	55                   	push   %ebp
  80144d:	89 e5                	mov    %esp,%ebp
  80144f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801452:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801455:	50                   	push   %eax
  801456:	ff 75 08             	pushl  0x8(%ebp)
  801459:	e8 9d ff ff ff       	call   8013fb <vcprintf>
	va_end(ap);

	return cnt;
}
  80145e:	c9                   	leave  
  80145f:	c3                   	ret    

00801460 <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	57                   	push   %edi
  801464:	56                   	push   %esi
  801465:	53                   	push   %ebx
  801466:	83 ec 1c             	sub    $0x1c,%esp
  801469:	89 c6                	mov    %eax,%esi
  80146b:	89 d7                	mov    %edx,%edi
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	8b 55 0c             	mov    0xc(%ebp),%edx
  801473:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801476:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  801479:	8b 45 10             	mov    0x10(%ebp),%eax
  80147c:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  80147f:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  801483:	74 2c                	je     8014b1 <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801485:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801488:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80148f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801492:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801495:	39 c2                	cmp    %eax,%edx
  801497:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80149a:	73 43                	jae    8014df <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80149c:	83 eb 01             	sub    $0x1,%ebx
  80149f:	85 db                	test   %ebx,%ebx
  8014a1:	7e 6c                	jle    80150f <printnum+0xaf>
			putch(padc, putdat);
  8014a3:	83 ec 08             	sub    $0x8,%esp
  8014a6:	57                   	push   %edi
  8014a7:	ff 75 18             	pushl  0x18(%ebp)
  8014aa:	ff d6                	call   *%esi
  8014ac:	83 c4 10             	add    $0x10,%esp
  8014af:	eb eb                	jmp    80149c <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8014b1:	83 ec 0c             	sub    $0xc,%esp
  8014b4:	6a 20                	push   $0x20
  8014b6:	6a 00                	push   $0x0
  8014b8:	50                   	push   %eax
  8014b9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8014bf:	89 fa                	mov    %edi,%edx
  8014c1:	89 f0                	mov    %esi,%eax
  8014c3:	e8 98 ff ff ff       	call   801460 <printnum>
		while (--width > 0)
  8014c8:	83 c4 20             	add    $0x20,%esp
  8014cb:	83 eb 01             	sub    $0x1,%ebx
  8014ce:	85 db                	test   %ebx,%ebx
  8014d0:	7e 65                	jle    801537 <printnum+0xd7>
			putch(' ', putdat);
  8014d2:	83 ec 08             	sub    $0x8,%esp
  8014d5:	57                   	push   %edi
  8014d6:	6a 20                	push   $0x20
  8014d8:	ff d6                	call   *%esi
  8014da:	83 c4 10             	add    $0x10,%esp
  8014dd:	eb ec                	jmp    8014cb <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8014df:	83 ec 0c             	sub    $0xc,%esp
  8014e2:	ff 75 18             	pushl  0x18(%ebp)
  8014e5:	83 eb 01             	sub    $0x1,%ebx
  8014e8:	53                   	push   %ebx
  8014e9:	50                   	push   %eax
  8014ea:	83 ec 08             	sub    $0x8,%esp
  8014ed:	ff 75 dc             	pushl  -0x24(%ebp)
  8014f0:	ff 75 d8             	pushl  -0x28(%ebp)
  8014f3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014f6:	ff 75 e0             	pushl  -0x20(%ebp)
  8014f9:	e8 e2 1a 00 00       	call   802fe0 <__udivdi3>
  8014fe:	83 c4 18             	add    $0x18,%esp
  801501:	52                   	push   %edx
  801502:	50                   	push   %eax
  801503:	89 fa                	mov    %edi,%edx
  801505:	89 f0                	mov    %esi,%eax
  801507:	e8 54 ff ff ff       	call   801460 <printnum>
  80150c:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80150f:	83 ec 08             	sub    $0x8,%esp
  801512:	57                   	push   %edi
  801513:	83 ec 04             	sub    $0x4,%esp
  801516:	ff 75 dc             	pushl  -0x24(%ebp)
  801519:	ff 75 d8             	pushl  -0x28(%ebp)
  80151c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80151f:	ff 75 e0             	pushl  -0x20(%ebp)
  801522:	e8 c9 1b 00 00       	call   8030f0 <__umoddi3>
  801527:	83 c4 14             	add    $0x14,%esp
  80152a:	0f be 80 b3 37 80 00 	movsbl 0x8037b3(%eax),%eax
  801531:	50                   	push   %eax
  801532:	ff d6                	call   *%esi
  801534:	83 c4 10             	add    $0x10,%esp
}
  801537:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80153a:	5b                   	pop    %ebx
  80153b:	5e                   	pop    %esi
  80153c:	5f                   	pop    %edi
  80153d:	5d                   	pop    %ebp
  80153e:	c3                   	ret    

0080153f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80153f:	55                   	push   %ebp
  801540:	89 e5                	mov    %esp,%ebp
  801542:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801545:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801549:	8b 10                	mov    (%eax),%edx
  80154b:	3b 50 04             	cmp    0x4(%eax),%edx
  80154e:	73 0a                	jae    80155a <sprintputch+0x1b>
		*b->buf++ = ch;
  801550:	8d 4a 01             	lea    0x1(%edx),%ecx
  801553:	89 08                	mov    %ecx,(%eax)
  801555:	8b 45 08             	mov    0x8(%ebp),%eax
  801558:	88 02                	mov    %al,(%edx)
}
  80155a:	5d                   	pop    %ebp
  80155b:	c3                   	ret    

0080155c <printfmt>:
{
  80155c:	55                   	push   %ebp
  80155d:	89 e5                	mov    %esp,%ebp
  80155f:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801562:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801565:	50                   	push   %eax
  801566:	ff 75 10             	pushl  0x10(%ebp)
  801569:	ff 75 0c             	pushl  0xc(%ebp)
  80156c:	ff 75 08             	pushl  0x8(%ebp)
  80156f:	e8 05 00 00 00       	call   801579 <vprintfmt>
}
  801574:	83 c4 10             	add    $0x10,%esp
  801577:	c9                   	leave  
  801578:	c3                   	ret    

00801579 <vprintfmt>:
{
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
  80157c:	57                   	push   %edi
  80157d:	56                   	push   %esi
  80157e:	53                   	push   %ebx
  80157f:	83 ec 3c             	sub    $0x3c,%esp
  801582:	8b 75 08             	mov    0x8(%ebp),%esi
  801585:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801588:	8b 7d 10             	mov    0x10(%ebp),%edi
  80158b:	e9 1e 04 00 00       	jmp    8019ae <vprintfmt+0x435>
		posflag = 0;
  801590:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  801597:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80159b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8015a2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8015a9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8015b0:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8015b7:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8015bc:	8d 47 01             	lea    0x1(%edi),%eax
  8015bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8015c2:	0f b6 17             	movzbl (%edi),%edx
  8015c5:	8d 42 dd             	lea    -0x23(%edx),%eax
  8015c8:	3c 55                	cmp    $0x55,%al
  8015ca:	0f 87 d9 04 00 00    	ja     801aa9 <vprintfmt+0x530>
  8015d0:	0f b6 c0             	movzbl %al,%eax
  8015d3:	ff 24 85 a0 39 80 00 	jmp    *0x8039a0(,%eax,4)
  8015da:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8015dd:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8015e1:	eb d9                	jmp    8015bc <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8015e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  8015e6:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  8015ed:	eb cd                	jmp    8015bc <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8015ef:	0f b6 d2             	movzbl %dl,%edx
  8015f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8015f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015fa:	89 75 08             	mov    %esi,0x8(%ebp)
  8015fd:	eb 0c                	jmp    80160b <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  8015ff:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  801602:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  801606:	eb b4                	jmp    8015bc <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  801608:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80160b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80160e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801612:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801615:	8d 72 d0             	lea    -0x30(%edx),%esi
  801618:	83 fe 09             	cmp    $0x9,%esi
  80161b:	76 eb                	jbe    801608 <vprintfmt+0x8f>
  80161d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801620:	8b 75 08             	mov    0x8(%ebp),%esi
  801623:	eb 14                	jmp    801639 <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  801625:	8b 45 14             	mov    0x14(%ebp),%eax
  801628:	8b 00                	mov    (%eax),%eax
  80162a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80162d:	8b 45 14             	mov    0x14(%ebp),%eax
  801630:	8d 40 04             	lea    0x4(%eax),%eax
  801633:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801636:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801639:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80163d:	0f 89 79 ff ff ff    	jns    8015bc <vprintfmt+0x43>
				width = precision, precision = -1;
  801643:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801646:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801649:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  801650:	e9 67 ff ff ff       	jmp    8015bc <vprintfmt+0x43>
  801655:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801658:	85 c0                	test   %eax,%eax
  80165a:	0f 48 c1             	cmovs  %ecx,%eax
  80165d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801660:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801663:	e9 54 ff ff ff       	jmp    8015bc <vprintfmt+0x43>
  801668:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80166b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  801672:	e9 45 ff ff ff       	jmp    8015bc <vprintfmt+0x43>
			lflag++;
  801677:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80167b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80167e:	e9 39 ff ff ff       	jmp    8015bc <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  801683:	8b 45 14             	mov    0x14(%ebp),%eax
  801686:	8d 78 04             	lea    0x4(%eax),%edi
  801689:	83 ec 08             	sub    $0x8,%esp
  80168c:	53                   	push   %ebx
  80168d:	ff 30                	pushl  (%eax)
  80168f:	ff d6                	call   *%esi
			break;
  801691:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801694:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801697:	e9 0f 03 00 00       	jmp    8019ab <vprintfmt+0x432>
			err = va_arg(ap, int);
  80169c:	8b 45 14             	mov    0x14(%ebp),%eax
  80169f:	8d 78 04             	lea    0x4(%eax),%edi
  8016a2:	8b 00                	mov    (%eax),%eax
  8016a4:	99                   	cltd   
  8016a5:	31 d0                	xor    %edx,%eax
  8016a7:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8016a9:	83 f8 0f             	cmp    $0xf,%eax
  8016ac:	7f 23                	jg     8016d1 <vprintfmt+0x158>
  8016ae:	8b 14 85 00 3b 80 00 	mov    0x803b00(,%eax,4),%edx
  8016b5:	85 d2                	test   %edx,%edx
  8016b7:	74 18                	je     8016d1 <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  8016b9:	52                   	push   %edx
  8016ba:	68 8f 32 80 00       	push   $0x80328f
  8016bf:	53                   	push   %ebx
  8016c0:	56                   	push   %esi
  8016c1:	e8 96 fe ff ff       	call   80155c <printfmt>
  8016c6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8016c9:	89 7d 14             	mov    %edi,0x14(%ebp)
  8016cc:	e9 da 02 00 00       	jmp    8019ab <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  8016d1:	50                   	push   %eax
  8016d2:	68 cb 37 80 00       	push   $0x8037cb
  8016d7:	53                   	push   %ebx
  8016d8:	56                   	push   %esi
  8016d9:	e8 7e fe ff ff       	call   80155c <printfmt>
  8016de:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8016e1:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8016e4:	e9 c2 02 00 00       	jmp    8019ab <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  8016e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ec:	83 c0 04             	add    $0x4,%eax
  8016ef:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8016f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f5:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8016f7:	85 c9                	test   %ecx,%ecx
  8016f9:	b8 c4 37 80 00       	mov    $0x8037c4,%eax
  8016fe:	0f 45 c1             	cmovne %ecx,%eax
  801701:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801704:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801708:	7e 06                	jle    801710 <vprintfmt+0x197>
  80170a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80170e:	75 0d                	jne    80171d <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  801710:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801713:	89 c7                	mov    %eax,%edi
  801715:	03 45 e0             	add    -0x20(%ebp),%eax
  801718:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80171b:	eb 53                	jmp    801770 <vprintfmt+0x1f7>
  80171d:	83 ec 08             	sub    $0x8,%esp
  801720:	ff 75 d8             	pushl  -0x28(%ebp)
  801723:	50                   	push   %eax
  801724:	e8 28 04 00 00       	call   801b51 <strnlen>
  801729:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80172c:	29 c1                	sub    %eax,%ecx
  80172e:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  801731:	83 c4 10             	add    $0x10,%esp
  801734:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  801736:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80173a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80173d:	eb 0f                	jmp    80174e <vprintfmt+0x1d5>
					putch(padc, putdat);
  80173f:	83 ec 08             	sub    $0x8,%esp
  801742:	53                   	push   %ebx
  801743:	ff 75 e0             	pushl  -0x20(%ebp)
  801746:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801748:	83 ef 01             	sub    $0x1,%edi
  80174b:	83 c4 10             	add    $0x10,%esp
  80174e:	85 ff                	test   %edi,%edi
  801750:	7f ed                	jg     80173f <vprintfmt+0x1c6>
  801752:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  801755:	85 c9                	test   %ecx,%ecx
  801757:	b8 00 00 00 00       	mov    $0x0,%eax
  80175c:	0f 49 c1             	cmovns %ecx,%eax
  80175f:	29 c1                	sub    %eax,%ecx
  801761:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  801764:	eb aa                	jmp    801710 <vprintfmt+0x197>
					putch(ch, putdat);
  801766:	83 ec 08             	sub    $0x8,%esp
  801769:	53                   	push   %ebx
  80176a:	52                   	push   %edx
  80176b:	ff d6                	call   *%esi
  80176d:	83 c4 10             	add    $0x10,%esp
  801770:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801773:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801775:	83 c7 01             	add    $0x1,%edi
  801778:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80177c:	0f be d0             	movsbl %al,%edx
  80177f:	85 d2                	test   %edx,%edx
  801781:	74 4b                	je     8017ce <vprintfmt+0x255>
  801783:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801787:	78 06                	js     80178f <vprintfmt+0x216>
  801789:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80178d:	78 1e                	js     8017ad <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  80178f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801793:	74 d1                	je     801766 <vprintfmt+0x1ed>
  801795:	0f be c0             	movsbl %al,%eax
  801798:	83 e8 20             	sub    $0x20,%eax
  80179b:	83 f8 5e             	cmp    $0x5e,%eax
  80179e:	76 c6                	jbe    801766 <vprintfmt+0x1ed>
					putch('?', putdat);
  8017a0:	83 ec 08             	sub    $0x8,%esp
  8017a3:	53                   	push   %ebx
  8017a4:	6a 3f                	push   $0x3f
  8017a6:	ff d6                	call   *%esi
  8017a8:	83 c4 10             	add    $0x10,%esp
  8017ab:	eb c3                	jmp    801770 <vprintfmt+0x1f7>
  8017ad:	89 cf                	mov    %ecx,%edi
  8017af:	eb 0e                	jmp    8017bf <vprintfmt+0x246>
				putch(' ', putdat);
  8017b1:	83 ec 08             	sub    $0x8,%esp
  8017b4:	53                   	push   %ebx
  8017b5:	6a 20                	push   $0x20
  8017b7:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8017b9:	83 ef 01             	sub    $0x1,%edi
  8017bc:	83 c4 10             	add    $0x10,%esp
  8017bf:	85 ff                	test   %edi,%edi
  8017c1:	7f ee                	jg     8017b1 <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  8017c3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8017c6:	89 45 14             	mov    %eax,0x14(%ebp)
  8017c9:	e9 dd 01 00 00       	jmp    8019ab <vprintfmt+0x432>
  8017ce:	89 cf                	mov    %ecx,%edi
  8017d0:	eb ed                	jmp    8017bf <vprintfmt+0x246>
	if (lflag >= 2)
  8017d2:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8017d6:	7f 21                	jg     8017f9 <vprintfmt+0x280>
	else if (lflag)
  8017d8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8017dc:	74 6a                	je     801848 <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  8017de:	8b 45 14             	mov    0x14(%ebp),%eax
  8017e1:	8b 00                	mov    (%eax),%eax
  8017e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8017e6:	89 c1                	mov    %eax,%ecx
  8017e8:	c1 f9 1f             	sar    $0x1f,%ecx
  8017eb:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8017ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8017f1:	8d 40 04             	lea    0x4(%eax),%eax
  8017f4:	89 45 14             	mov    %eax,0x14(%ebp)
  8017f7:	eb 17                	jmp    801810 <vprintfmt+0x297>
		return va_arg(*ap, long long);
  8017f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8017fc:	8b 50 04             	mov    0x4(%eax),%edx
  8017ff:	8b 00                	mov    (%eax),%eax
  801801:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801804:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801807:	8b 45 14             	mov    0x14(%ebp),%eax
  80180a:	8d 40 08             	lea    0x8(%eax),%eax
  80180d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801810:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  801813:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  801818:	85 d2                	test   %edx,%edx
  80181a:	0f 89 5c 01 00 00    	jns    80197c <vprintfmt+0x403>
				putch('-', putdat);
  801820:	83 ec 08             	sub    $0x8,%esp
  801823:	53                   	push   %ebx
  801824:	6a 2d                	push   $0x2d
  801826:	ff d6                	call   *%esi
				num = -(long long) num;
  801828:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80182b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80182e:	f7 d8                	neg    %eax
  801830:	83 d2 00             	adc    $0x0,%edx
  801833:	f7 da                	neg    %edx
  801835:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801838:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80183b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80183e:	bf 0a 00 00 00       	mov    $0xa,%edi
  801843:	e9 45 01 00 00       	jmp    80198d <vprintfmt+0x414>
		return va_arg(*ap, int);
  801848:	8b 45 14             	mov    0x14(%ebp),%eax
  80184b:	8b 00                	mov    (%eax),%eax
  80184d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801850:	89 c1                	mov    %eax,%ecx
  801852:	c1 f9 1f             	sar    $0x1f,%ecx
  801855:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801858:	8b 45 14             	mov    0x14(%ebp),%eax
  80185b:	8d 40 04             	lea    0x4(%eax),%eax
  80185e:	89 45 14             	mov    %eax,0x14(%ebp)
  801861:	eb ad                	jmp    801810 <vprintfmt+0x297>
	if (lflag >= 2)
  801863:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  801867:	7f 29                	jg     801892 <vprintfmt+0x319>
	else if (lflag)
  801869:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80186d:	74 44                	je     8018b3 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  80186f:	8b 45 14             	mov    0x14(%ebp),%eax
  801872:	8b 00                	mov    (%eax),%eax
  801874:	ba 00 00 00 00       	mov    $0x0,%edx
  801879:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80187c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80187f:	8b 45 14             	mov    0x14(%ebp),%eax
  801882:	8d 40 04             	lea    0x4(%eax),%eax
  801885:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801888:	bf 0a 00 00 00       	mov    $0xa,%edi
  80188d:	e9 ea 00 00 00       	jmp    80197c <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  801892:	8b 45 14             	mov    0x14(%ebp),%eax
  801895:	8b 50 04             	mov    0x4(%eax),%edx
  801898:	8b 00                	mov    (%eax),%eax
  80189a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80189d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8018a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8018a3:	8d 40 08             	lea    0x8(%eax),%eax
  8018a6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8018a9:	bf 0a 00 00 00       	mov    $0xa,%edi
  8018ae:	e9 c9 00 00 00       	jmp    80197c <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8018b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8018b6:	8b 00                	mov    (%eax),%eax
  8018b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8018bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8018c0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8018c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8018c6:	8d 40 04             	lea    0x4(%eax),%eax
  8018c9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8018cc:	bf 0a 00 00 00       	mov    $0xa,%edi
  8018d1:	e9 a6 00 00 00       	jmp    80197c <vprintfmt+0x403>
			putch('0', putdat);
  8018d6:	83 ec 08             	sub    $0x8,%esp
  8018d9:	53                   	push   %ebx
  8018da:	6a 30                	push   $0x30
  8018dc:	ff d6                	call   *%esi
	if (lflag >= 2)
  8018de:	83 c4 10             	add    $0x10,%esp
  8018e1:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8018e5:	7f 26                	jg     80190d <vprintfmt+0x394>
	else if (lflag)
  8018e7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8018eb:	74 3e                	je     80192b <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  8018ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8018f0:	8b 00                	mov    (%eax),%eax
  8018f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8018fa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8018fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801900:	8d 40 04             	lea    0x4(%eax),%eax
  801903:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801906:	bf 08 00 00 00       	mov    $0x8,%edi
  80190b:	eb 6f                	jmp    80197c <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  80190d:	8b 45 14             	mov    0x14(%ebp),%eax
  801910:	8b 50 04             	mov    0x4(%eax),%edx
  801913:	8b 00                	mov    (%eax),%eax
  801915:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801918:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80191b:	8b 45 14             	mov    0x14(%ebp),%eax
  80191e:	8d 40 08             	lea    0x8(%eax),%eax
  801921:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801924:	bf 08 00 00 00       	mov    $0x8,%edi
  801929:	eb 51                	jmp    80197c <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  80192b:	8b 45 14             	mov    0x14(%ebp),%eax
  80192e:	8b 00                	mov    (%eax),%eax
  801930:	ba 00 00 00 00       	mov    $0x0,%edx
  801935:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801938:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80193b:	8b 45 14             	mov    0x14(%ebp),%eax
  80193e:	8d 40 04             	lea    0x4(%eax),%eax
  801941:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801944:	bf 08 00 00 00       	mov    $0x8,%edi
  801949:	eb 31                	jmp    80197c <vprintfmt+0x403>
			putch('0', putdat);
  80194b:	83 ec 08             	sub    $0x8,%esp
  80194e:	53                   	push   %ebx
  80194f:	6a 30                	push   $0x30
  801951:	ff d6                	call   *%esi
			putch('x', putdat);
  801953:	83 c4 08             	add    $0x8,%esp
  801956:	53                   	push   %ebx
  801957:	6a 78                	push   $0x78
  801959:	ff d6                	call   *%esi
			num = (unsigned long long)
  80195b:	8b 45 14             	mov    0x14(%ebp),%eax
  80195e:	8b 00                	mov    (%eax),%eax
  801960:	ba 00 00 00 00       	mov    $0x0,%edx
  801965:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801968:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80196b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80196e:	8b 45 14             	mov    0x14(%ebp),%eax
  801971:	8d 40 04             	lea    0x4(%eax),%eax
  801974:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801977:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  80197c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  801980:	74 0b                	je     80198d <vprintfmt+0x414>
				putch('+', putdat);
  801982:	83 ec 08             	sub    $0x8,%esp
  801985:	53                   	push   %ebx
  801986:	6a 2b                	push   $0x2b
  801988:	ff d6                	call   *%esi
  80198a:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  80198d:	83 ec 0c             	sub    $0xc,%esp
  801990:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  801994:	50                   	push   %eax
  801995:	ff 75 e0             	pushl  -0x20(%ebp)
  801998:	57                   	push   %edi
  801999:	ff 75 dc             	pushl  -0x24(%ebp)
  80199c:	ff 75 d8             	pushl  -0x28(%ebp)
  80199f:	89 da                	mov    %ebx,%edx
  8019a1:	89 f0                	mov    %esi,%eax
  8019a3:	e8 b8 fa ff ff       	call   801460 <printnum>
			break;
  8019a8:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  8019ab:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8019ae:	83 c7 01             	add    $0x1,%edi
  8019b1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8019b5:	83 f8 25             	cmp    $0x25,%eax
  8019b8:	0f 84 d2 fb ff ff    	je     801590 <vprintfmt+0x17>
			if (ch == '\0')
  8019be:	85 c0                	test   %eax,%eax
  8019c0:	0f 84 03 01 00 00    	je     801ac9 <vprintfmt+0x550>
			putch(ch, putdat);
  8019c6:	83 ec 08             	sub    $0x8,%esp
  8019c9:	53                   	push   %ebx
  8019ca:	50                   	push   %eax
  8019cb:	ff d6                	call   *%esi
  8019cd:	83 c4 10             	add    $0x10,%esp
  8019d0:	eb dc                	jmp    8019ae <vprintfmt+0x435>
	if (lflag >= 2)
  8019d2:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8019d6:	7f 29                	jg     801a01 <vprintfmt+0x488>
	else if (lflag)
  8019d8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8019dc:	74 44                	je     801a22 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  8019de:	8b 45 14             	mov    0x14(%ebp),%eax
  8019e1:	8b 00                	mov    (%eax),%eax
  8019e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019eb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f1:	8d 40 04             	lea    0x4(%eax),%eax
  8019f4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8019f7:	bf 10 00 00 00       	mov    $0x10,%edi
  8019fc:	e9 7b ff ff ff       	jmp    80197c <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  801a01:	8b 45 14             	mov    0x14(%ebp),%eax
  801a04:	8b 50 04             	mov    0x4(%eax),%edx
  801a07:	8b 00                	mov    (%eax),%eax
  801a09:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a0c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a0f:	8b 45 14             	mov    0x14(%ebp),%eax
  801a12:	8d 40 08             	lea    0x8(%eax),%eax
  801a15:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a18:	bf 10 00 00 00       	mov    $0x10,%edi
  801a1d:	e9 5a ff ff ff       	jmp    80197c <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  801a22:	8b 45 14             	mov    0x14(%ebp),%eax
  801a25:	8b 00                	mov    (%eax),%eax
  801a27:	ba 00 00 00 00       	mov    $0x0,%edx
  801a2c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a2f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a32:	8b 45 14             	mov    0x14(%ebp),%eax
  801a35:	8d 40 04             	lea    0x4(%eax),%eax
  801a38:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a3b:	bf 10 00 00 00       	mov    $0x10,%edi
  801a40:	e9 37 ff ff ff       	jmp    80197c <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  801a45:	8b 45 14             	mov    0x14(%ebp),%eax
  801a48:	8d 78 04             	lea    0x4(%eax),%edi
  801a4b:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  801a4d:	85 c0                	test   %eax,%eax
  801a4f:	74 2c                	je     801a7d <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  801a51:	8b 13                	mov    (%ebx),%edx
  801a53:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  801a55:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  801a58:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  801a5b:	0f 8e 4a ff ff ff    	jle    8019ab <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  801a61:	68 20 39 80 00       	push   $0x803920
  801a66:	68 8f 32 80 00       	push   $0x80328f
  801a6b:	53                   	push   %ebx
  801a6c:	56                   	push   %esi
  801a6d:	e8 ea fa ff ff       	call   80155c <printfmt>
  801a72:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  801a75:	89 7d 14             	mov    %edi,0x14(%ebp)
  801a78:	e9 2e ff ff ff       	jmp    8019ab <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  801a7d:	68 e8 38 80 00       	push   $0x8038e8
  801a82:	68 8f 32 80 00       	push   $0x80328f
  801a87:	53                   	push   %ebx
  801a88:	56                   	push   %esi
  801a89:	e8 ce fa ff ff       	call   80155c <printfmt>
        		break;
  801a8e:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  801a91:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  801a94:	e9 12 ff ff ff       	jmp    8019ab <vprintfmt+0x432>
			putch(ch, putdat);
  801a99:	83 ec 08             	sub    $0x8,%esp
  801a9c:	53                   	push   %ebx
  801a9d:	6a 25                	push   $0x25
  801a9f:	ff d6                	call   *%esi
			break;
  801aa1:	83 c4 10             	add    $0x10,%esp
  801aa4:	e9 02 ff ff ff       	jmp    8019ab <vprintfmt+0x432>
			putch('%', putdat);
  801aa9:	83 ec 08             	sub    $0x8,%esp
  801aac:	53                   	push   %ebx
  801aad:	6a 25                	push   $0x25
  801aaf:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801ab1:	83 c4 10             	add    $0x10,%esp
  801ab4:	89 f8                	mov    %edi,%eax
  801ab6:	eb 03                	jmp    801abb <vprintfmt+0x542>
  801ab8:	83 e8 01             	sub    $0x1,%eax
  801abb:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801abf:	75 f7                	jne    801ab8 <vprintfmt+0x53f>
  801ac1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ac4:	e9 e2 fe ff ff       	jmp    8019ab <vprintfmt+0x432>
}
  801ac9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801acc:	5b                   	pop    %ebx
  801acd:	5e                   	pop    %esi
  801ace:	5f                   	pop    %edi
  801acf:	5d                   	pop    %ebp
  801ad0:	c3                   	ret    

00801ad1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
  801ad4:	83 ec 18             	sub    $0x18,%esp
  801ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ada:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801add:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ae0:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801ae4:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801ae7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801aee:	85 c0                	test   %eax,%eax
  801af0:	74 26                	je     801b18 <vsnprintf+0x47>
  801af2:	85 d2                	test   %edx,%edx
  801af4:	7e 22                	jle    801b18 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801af6:	ff 75 14             	pushl  0x14(%ebp)
  801af9:	ff 75 10             	pushl  0x10(%ebp)
  801afc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801aff:	50                   	push   %eax
  801b00:	68 3f 15 80 00       	push   $0x80153f
  801b05:	e8 6f fa ff ff       	call   801579 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801b0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b0d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b13:	83 c4 10             	add    $0x10,%esp
}
  801b16:	c9                   	leave  
  801b17:	c3                   	ret    
		return -E_INVAL;
  801b18:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b1d:	eb f7                	jmp    801b16 <vsnprintf+0x45>

00801b1f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
  801b22:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801b25:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801b28:	50                   	push   %eax
  801b29:	ff 75 10             	pushl  0x10(%ebp)
  801b2c:	ff 75 0c             	pushl  0xc(%ebp)
  801b2f:	ff 75 08             	pushl  0x8(%ebp)
  801b32:	e8 9a ff ff ff       	call   801ad1 <vsnprintf>
	va_end(ap);

	return rc;
}
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
  801b3c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801b3f:	b8 00 00 00 00       	mov    $0x0,%eax
  801b44:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801b48:	74 05                	je     801b4f <strlen+0x16>
		n++;
  801b4a:	83 c0 01             	add    $0x1,%eax
  801b4d:	eb f5                	jmp    801b44 <strlen+0xb>
	return n;
}
  801b4f:	5d                   	pop    %ebp
  801b50:	c3                   	ret    

00801b51 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
  801b54:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b57:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801b5a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b5f:	39 c2                	cmp    %eax,%edx
  801b61:	74 0d                	je     801b70 <strnlen+0x1f>
  801b63:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  801b67:	74 05                	je     801b6e <strnlen+0x1d>
		n++;
  801b69:	83 c2 01             	add    $0x1,%edx
  801b6c:	eb f1                	jmp    801b5f <strnlen+0xe>
  801b6e:	89 d0                	mov    %edx,%eax
	return n;
}
  801b70:	5d                   	pop    %ebp
  801b71:	c3                   	ret    

00801b72 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
  801b75:	53                   	push   %ebx
  801b76:	8b 45 08             	mov    0x8(%ebp),%eax
  801b79:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801b7c:	ba 00 00 00 00       	mov    $0x0,%edx
  801b81:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  801b85:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  801b88:	83 c2 01             	add    $0x1,%edx
  801b8b:	84 c9                	test   %cl,%cl
  801b8d:	75 f2                	jne    801b81 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  801b8f:	5b                   	pop    %ebx
  801b90:	5d                   	pop    %ebp
  801b91:	c3                   	ret    

00801b92 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
  801b95:	53                   	push   %ebx
  801b96:	83 ec 10             	sub    $0x10,%esp
  801b99:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801b9c:	53                   	push   %ebx
  801b9d:	e8 97 ff ff ff       	call   801b39 <strlen>
  801ba2:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801ba5:	ff 75 0c             	pushl  0xc(%ebp)
  801ba8:	01 d8                	add    %ebx,%eax
  801baa:	50                   	push   %eax
  801bab:	e8 c2 ff ff ff       	call   801b72 <strcpy>
	return dst;
}
  801bb0:	89 d8                	mov    %ebx,%eax
  801bb2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bb5:	c9                   	leave  
  801bb6:	c3                   	ret    

00801bb7 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
  801bba:	56                   	push   %esi
  801bbb:	53                   	push   %ebx
  801bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bc2:	89 c6                	mov    %eax,%esi
  801bc4:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801bc7:	89 c2                	mov    %eax,%edx
  801bc9:	39 f2                	cmp    %esi,%edx
  801bcb:	74 11                	je     801bde <strncpy+0x27>
		*dst++ = *src;
  801bcd:	83 c2 01             	add    $0x1,%edx
  801bd0:	0f b6 19             	movzbl (%ecx),%ebx
  801bd3:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801bd6:	80 fb 01             	cmp    $0x1,%bl
  801bd9:	83 d9 ff             	sbb    $0xffffffff,%ecx
  801bdc:	eb eb                	jmp    801bc9 <strncpy+0x12>
	}
	return ret;
}
  801bde:	5b                   	pop    %ebx
  801bdf:	5e                   	pop    %esi
  801be0:	5d                   	pop    %ebp
  801be1:	c3                   	ret    

00801be2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
  801be5:	56                   	push   %esi
  801be6:	53                   	push   %ebx
  801be7:	8b 75 08             	mov    0x8(%ebp),%esi
  801bea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bed:	8b 55 10             	mov    0x10(%ebp),%edx
  801bf0:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801bf2:	85 d2                	test   %edx,%edx
  801bf4:	74 21                	je     801c17 <strlcpy+0x35>
  801bf6:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801bfa:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801bfc:	39 c2                	cmp    %eax,%edx
  801bfe:	74 14                	je     801c14 <strlcpy+0x32>
  801c00:	0f b6 19             	movzbl (%ecx),%ebx
  801c03:	84 db                	test   %bl,%bl
  801c05:	74 0b                	je     801c12 <strlcpy+0x30>
			*dst++ = *src++;
  801c07:	83 c1 01             	add    $0x1,%ecx
  801c0a:	83 c2 01             	add    $0x1,%edx
  801c0d:	88 5a ff             	mov    %bl,-0x1(%edx)
  801c10:	eb ea                	jmp    801bfc <strlcpy+0x1a>
  801c12:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801c14:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801c17:	29 f0                	sub    %esi,%eax
}
  801c19:	5b                   	pop    %ebx
  801c1a:	5e                   	pop    %esi
  801c1b:	5d                   	pop    %ebp
  801c1c:	c3                   	ret    

00801c1d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
  801c20:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c23:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801c26:	0f b6 01             	movzbl (%ecx),%eax
  801c29:	84 c0                	test   %al,%al
  801c2b:	74 0c                	je     801c39 <strcmp+0x1c>
  801c2d:	3a 02                	cmp    (%edx),%al
  801c2f:	75 08                	jne    801c39 <strcmp+0x1c>
		p++, q++;
  801c31:	83 c1 01             	add    $0x1,%ecx
  801c34:	83 c2 01             	add    $0x1,%edx
  801c37:	eb ed                	jmp    801c26 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801c39:	0f b6 c0             	movzbl %al,%eax
  801c3c:	0f b6 12             	movzbl (%edx),%edx
  801c3f:	29 d0                	sub    %edx,%eax
}
  801c41:	5d                   	pop    %ebp
  801c42:	c3                   	ret    

00801c43 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
  801c46:	53                   	push   %ebx
  801c47:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c4d:	89 c3                	mov    %eax,%ebx
  801c4f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801c52:	eb 06                	jmp    801c5a <strncmp+0x17>
		n--, p++, q++;
  801c54:	83 c0 01             	add    $0x1,%eax
  801c57:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801c5a:	39 d8                	cmp    %ebx,%eax
  801c5c:	74 16                	je     801c74 <strncmp+0x31>
  801c5e:	0f b6 08             	movzbl (%eax),%ecx
  801c61:	84 c9                	test   %cl,%cl
  801c63:	74 04                	je     801c69 <strncmp+0x26>
  801c65:	3a 0a                	cmp    (%edx),%cl
  801c67:	74 eb                	je     801c54 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801c69:	0f b6 00             	movzbl (%eax),%eax
  801c6c:	0f b6 12             	movzbl (%edx),%edx
  801c6f:	29 d0                	sub    %edx,%eax
}
  801c71:	5b                   	pop    %ebx
  801c72:	5d                   	pop    %ebp
  801c73:	c3                   	ret    
		return 0;
  801c74:	b8 00 00 00 00       	mov    $0x0,%eax
  801c79:	eb f6                	jmp    801c71 <strncmp+0x2e>

00801c7b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801c7b:	55                   	push   %ebp
  801c7c:	89 e5                	mov    %esp,%ebp
  801c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c81:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801c85:	0f b6 10             	movzbl (%eax),%edx
  801c88:	84 d2                	test   %dl,%dl
  801c8a:	74 09                	je     801c95 <strchr+0x1a>
		if (*s == c)
  801c8c:	38 ca                	cmp    %cl,%dl
  801c8e:	74 0a                	je     801c9a <strchr+0x1f>
	for (; *s; s++)
  801c90:	83 c0 01             	add    $0x1,%eax
  801c93:	eb f0                	jmp    801c85 <strchr+0xa>
			return (char *) s;
	return 0;
  801c95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c9a:	5d                   	pop    %ebp
  801c9b:	c3                   	ret    

00801c9c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
  801c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801ca6:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801ca9:	38 ca                	cmp    %cl,%dl
  801cab:	74 09                	je     801cb6 <strfind+0x1a>
  801cad:	84 d2                	test   %dl,%dl
  801caf:	74 05                	je     801cb6 <strfind+0x1a>
	for (; *s; s++)
  801cb1:	83 c0 01             	add    $0x1,%eax
  801cb4:	eb f0                	jmp    801ca6 <strfind+0xa>
			break;
	return (char *) s;
}
  801cb6:	5d                   	pop    %ebp
  801cb7:	c3                   	ret    

00801cb8 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
  801cbb:	57                   	push   %edi
  801cbc:	56                   	push   %esi
  801cbd:	53                   	push   %ebx
  801cbe:	8b 7d 08             	mov    0x8(%ebp),%edi
  801cc1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801cc4:	85 c9                	test   %ecx,%ecx
  801cc6:	74 31                	je     801cf9 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801cc8:	89 f8                	mov    %edi,%eax
  801cca:	09 c8                	or     %ecx,%eax
  801ccc:	a8 03                	test   $0x3,%al
  801cce:	75 23                	jne    801cf3 <memset+0x3b>
		c &= 0xFF;
  801cd0:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801cd4:	89 d3                	mov    %edx,%ebx
  801cd6:	c1 e3 08             	shl    $0x8,%ebx
  801cd9:	89 d0                	mov    %edx,%eax
  801cdb:	c1 e0 18             	shl    $0x18,%eax
  801cde:	89 d6                	mov    %edx,%esi
  801ce0:	c1 e6 10             	shl    $0x10,%esi
  801ce3:	09 f0                	or     %esi,%eax
  801ce5:	09 c2                	or     %eax,%edx
  801ce7:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801ce9:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801cec:	89 d0                	mov    %edx,%eax
  801cee:	fc                   	cld    
  801cef:	f3 ab                	rep stos %eax,%es:(%edi)
  801cf1:	eb 06                	jmp    801cf9 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801cf3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf6:	fc                   	cld    
  801cf7:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801cf9:	89 f8                	mov    %edi,%eax
  801cfb:	5b                   	pop    %ebx
  801cfc:	5e                   	pop    %esi
  801cfd:	5f                   	pop    %edi
  801cfe:	5d                   	pop    %ebp
  801cff:	c3                   	ret    

00801d00 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
  801d03:	57                   	push   %edi
  801d04:	56                   	push   %esi
  801d05:	8b 45 08             	mov    0x8(%ebp),%eax
  801d08:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d0b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801d0e:	39 c6                	cmp    %eax,%esi
  801d10:	73 32                	jae    801d44 <memmove+0x44>
  801d12:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801d15:	39 c2                	cmp    %eax,%edx
  801d17:	76 2b                	jbe    801d44 <memmove+0x44>
		s += n;
		d += n;
  801d19:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d1c:	89 fe                	mov    %edi,%esi
  801d1e:	09 ce                	or     %ecx,%esi
  801d20:	09 d6                	or     %edx,%esi
  801d22:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801d28:	75 0e                	jne    801d38 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801d2a:	83 ef 04             	sub    $0x4,%edi
  801d2d:	8d 72 fc             	lea    -0x4(%edx),%esi
  801d30:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801d33:	fd                   	std    
  801d34:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801d36:	eb 09                	jmp    801d41 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801d38:	83 ef 01             	sub    $0x1,%edi
  801d3b:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801d3e:	fd                   	std    
  801d3f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801d41:	fc                   	cld    
  801d42:	eb 1a                	jmp    801d5e <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d44:	89 c2                	mov    %eax,%edx
  801d46:	09 ca                	or     %ecx,%edx
  801d48:	09 f2                	or     %esi,%edx
  801d4a:	f6 c2 03             	test   $0x3,%dl
  801d4d:	75 0a                	jne    801d59 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801d4f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801d52:	89 c7                	mov    %eax,%edi
  801d54:	fc                   	cld    
  801d55:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801d57:	eb 05                	jmp    801d5e <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  801d59:	89 c7                	mov    %eax,%edi
  801d5b:	fc                   	cld    
  801d5c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801d5e:	5e                   	pop    %esi
  801d5f:	5f                   	pop    %edi
  801d60:	5d                   	pop    %ebp
  801d61:	c3                   	ret    

00801d62 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
  801d65:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801d68:	ff 75 10             	pushl  0x10(%ebp)
  801d6b:	ff 75 0c             	pushl  0xc(%ebp)
  801d6e:	ff 75 08             	pushl  0x8(%ebp)
  801d71:	e8 8a ff ff ff       	call   801d00 <memmove>
}
  801d76:	c9                   	leave  
  801d77:	c3                   	ret    

00801d78 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801d78:	55                   	push   %ebp
  801d79:	89 e5                	mov    %esp,%ebp
  801d7b:	56                   	push   %esi
  801d7c:	53                   	push   %ebx
  801d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d83:	89 c6                	mov    %eax,%esi
  801d85:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801d88:	39 f0                	cmp    %esi,%eax
  801d8a:	74 1c                	je     801da8 <memcmp+0x30>
		if (*s1 != *s2)
  801d8c:	0f b6 08             	movzbl (%eax),%ecx
  801d8f:	0f b6 1a             	movzbl (%edx),%ebx
  801d92:	38 d9                	cmp    %bl,%cl
  801d94:	75 08                	jne    801d9e <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801d96:	83 c0 01             	add    $0x1,%eax
  801d99:	83 c2 01             	add    $0x1,%edx
  801d9c:	eb ea                	jmp    801d88 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801d9e:	0f b6 c1             	movzbl %cl,%eax
  801da1:	0f b6 db             	movzbl %bl,%ebx
  801da4:	29 d8                	sub    %ebx,%eax
  801da6:	eb 05                	jmp    801dad <memcmp+0x35>
	}

	return 0;
  801da8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dad:	5b                   	pop    %ebx
  801dae:	5e                   	pop    %esi
  801daf:	5d                   	pop    %ebp
  801db0:	c3                   	ret    

00801db1 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
  801db4:	8b 45 08             	mov    0x8(%ebp),%eax
  801db7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801dba:	89 c2                	mov    %eax,%edx
  801dbc:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801dbf:	39 d0                	cmp    %edx,%eax
  801dc1:	73 09                	jae    801dcc <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801dc3:	38 08                	cmp    %cl,(%eax)
  801dc5:	74 05                	je     801dcc <memfind+0x1b>
	for (; s < ends; s++)
  801dc7:	83 c0 01             	add    $0x1,%eax
  801dca:	eb f3                	jmp    801dbf <memfind+0xe>
			break;
	return (void *) s;
}
  801dcc:	5d                   	pop    %ebp
  801dcd:	c3                   	ret    

00801dce <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
  801dd1:	57                   	push   %edi
  801dd2:	56                   	push   %esi
  801dd3:	53                   	push   %ebx
  801dd4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dd7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801dda:	eb 03                	jmp    801ddf <strtol+0x11>
		s++;
  801ddc:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801ddf:	0f b6 01             	movzbl (%ecx),%eax
  801de2:	3c 20                	cmp    $0x20,%al
  801de4:	74 f6                	je     801ddc <strtol+0xe>
  801de6:	3c 09                	cmp    $0x9,%al
  801de8:	74 f2                	je     801ddc <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801dea:	3c 2b                	cmp    $0x2b,%al
  801dec:	74 2a                	je     801e18 <strtol+0x4a>
	int neg = 0;
  801dee:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801df3:	3c 2d                	cmp    $0x2d,%al
  801df5:	74 2b                	je     801e22 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801df7:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801dfd:	75 0f                	jne    801e0e <strtol+0x40>
  801dff:	80 39 30             	cmpb   $0x30,(%ecx)
  801e02:	74 28                	je     801e2c <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801e04:	85 db                	test   %ebx,%ebx
  801e06:	b8 0a 00 00 00       	mov    $0xa,%eax
  801e0b:	0f 44 d8             	cmove  %eax,%ebx
  801e0e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e13:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801e16:	eb 50                	jmp    801e68 <strtol+0x9a>
		s++;
  801e18:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801e1b:	bf 00 00 00 00       	mov    $0x0,%edi
  801e20:	eb d5                	jmp    801df7 <strtol+0x29>
		s++, neg = 1;
  801e22:	83 c1 01             	add    $0x1,%ecx
  801e25:	bf 01 00 00 00       	mov    $0x1,%edi
  801e2a:	eb cb                	jmp    801df7 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e2c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801e30:	74 0e                	je     801e40 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  801e32:	85 db                	test   %ebx,%ebx
  801e34:	75 d8                	jne    801e0e <strtol+0x40>
		s++, base = 8;
  801e36:	83 c1 01             	add    $0x1,%ecx
  801e39:	bb 08 00 00 00       	mov    $0x8,%ebx
  801e3e:	eb ce                	jmp    801e0e <strtol+0x40>
		s += 2, base = 16;
  801e40:	83 c1 02             	add    $0x2,%ecx
  801e43:	bb 10 00 00 00       	mov    $0x10,%ebx
  801e48:	eb c4                	jmp    801e0e <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801e4a:	8d 72 9f             	lea    -0x61(%edx),%esi
  801e4d:	89 f3                	mov    %esi,%ebx
  801e4f:	80 fb 19             	cmp    $0x19,%bl
  801e52:	77 29                	ja     801e7d <strtol+0xaf>
			dig = *s - 'a' + 10;
  801e54:	0f be d2             	movsbl %dl,%edx
  801e57:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801e5a:	3b 55 10             	cmp    0x10(%ebp),%edx
  801e5d:	7d 30                	jge    801e8f <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801e5f:	83 c1 01             	add    $0x1,%ecx
  801e62:	0f af 45 10          	imul   0x10(%ebp),%eax
  801e66:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801e68:	0f b6 11             	movzbl (%ecx),%edx
  801e6b:	8d 72 d0             	lea    -0x30(%edx),%esi
  801e6e:	89 f3                	mov    %esi,%ebx
  801e70:	80 fb 09             	cmp    $0x9,%bl
  801e73:	77 d5                	ja     801e4a <strtol+0x7c>
			dig = *s - '0';
  801e75:	0f be d2             	movsbl %dl,%edx
  801e78:	83 ea 30             	sub    $0x30,%edx
  801e7b:	eb dd                	jmp    801e5a <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  801e7d:	8d 72 bf             	lea    -0x41(%edx),%esi
  801e80:	89 f3                	mov    %esi,%ebx
  801e82:	80 fb 19             	cmp    $0x19,%bl
  801e85:	77 08                	ja     801e8f <strtol+0xc1>
			dig = *s - 'A' + 10;
  801e87:	0f be d2             	movsbl %dl,%edx
  801e8a:	83 ea 37             	sub    $0x37,%edx
  801e8d:	eb cb                	jmp    801e5a <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  801e8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e93:	74 05                	je     801e9a <strtol+0xcc>
		*endptr = (char *) s;
  801e95:	8b 75 0c             	mov    0xc(%ebp),%esi
  801e98:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801e9a:	89 c2                	mov    %eax,%edx
  801e9c:	f7 da                	neg    %edx
  801e9e:	85 ff                	test   %edi,%edi
  801ea0:	0f 45 c2             	cmovne %edx,%eax
}
  801ea3:	5b                   	pop    %ebx
  801ea4:	5e                   	pop    %esi
  801ea5:	5f                   	pop    %edi
  801ea6:	5d                   	pop    %ebp
  801ea7:	c3                   	ret    

00801ea8 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801ea8:	55                   	push   %ebp
  801ea9:	89 e5                	mov    %esp,%ebp
  801eab:	57                   	push   %edi
  801eac:	56                   	push   %esi
  801ead:	53                   	push   %ebx
	asm volatile("int %1\n"
  801eae:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb3:	8b 55 08             	mov    0x8(%ebp),%edx
  801eb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801eb9:	89 c3                	mov    %eax,%ebx
  801ebb:	89 c7                	mov    %eax,%edi
  801ebd:	89 c6                	mov    %eax,%esi
  801ebf:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801ec1:	5b                   	pop    %ebx
  801ec2:	5e                   	pop    %esi
  801ec3:	5f                   	pop    %edi
  801ec4:	5d                   	pop    %ebp
  801ec5:	c3                   	ret    

00801ec6 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
  801ec9:	57                   	push   %edi
  801eca:	56                   	push   %esi
  801ecb:	53                   	push   %ebx
	asm volatile("int %1\n"
  801ecc:	ba 00 00 00 00       	mov    $0x0,%edx
  801ed1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ed6:	89 d1                	mov    %edx,%ecx
  801ed8:	89 d3                	mov    %edx,%ebx
  801eda:	89 d7                	mov    %edx,%edi
  801edc:	89 d6                	mov    %edx,%esi
  801ede:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801ee0:	5b                   	pop    %ebx
  801ee1:	5e                   	pop    %esi
  801ee2:	5f                   	pop    %edi
  801ee3:	5d                   	pop    %ebp
  801ee4:	c3                   	ret    

00801ee5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801ee5:	55                   	push   %ebp
  801ee6:	89 e5                	mov    %esp,%ebp
  801ee8:	57                   	push   %edi
  801ee9:	56                   	push   %esi
  801eea:	53                   	push   %ebx
  801eeb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801eee:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ef3:	8b 55 08             	mov    0x8(%ebp),%edx
  801ef6:	b8 03 00 00 00       	mov    $0x3,%eax
  801efb:	89 cb                	mov    %ecx,%ebx
  801efd:	89 cf                	mov    %ecx,%edi
  801eff:	89 ce                	mov    %ecx,%esi
  801f01:	cd 30                	int    $0x30
	if (check && ret > 0)
  801f03:	85 c0                	test   %eax,%eax
  801f05:	7f 08                	jg     801f0f <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801f07:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f0a:	5b                   	pop    %ebx
  801f0b:	5e                   	pop    %esi
  801f0c:	5f                   	pop    %edi
  801f0d:	5d                   	pop    %ebp
  801f0e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801f0f:	83 ec 0c             	sub    $0xc,%esp
  801f12:	50                   	push   %eax
  801f13:	6a 03                	push   $0x3
  801f15:	68 40 3b 80 00       	push   $0x803b40
  801f1a:	6a 4c                	push   $0x4c
  801f1c:	68 5d 3b 80 00       	push   $0x803b5d
  801f21:	e8 4b f4 ff ff       	call   801371 <_panic>

00801f26 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
  801f29:	57                   	push   %edi
  801f2a:	56                   	push   %esi
  801f2b:	53                   	push   %ebx
	asm volatile("int %1\n"
  801f2c:	ba 00 00 00 00       	mov    $0x0,%edx
  801f31:	b8 02 00 00 00       	mov    $0x2,%eax
  801f36:	89 d1                	mov    %edx,%ecx
  801f38:	89 d3                	mov    %edx,%ebx
  801f3a:	89 d7                	mov    %edx,%edi
  801f3c:	89 d6                	mov    %edx,%esi
  801f3e:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801f40:	5b                   	pop    %ebx
  801f41:	5e                   	pop    %esi
  801f42:	5f                   	pop    %edi
  801f43:	5d                   	pop    %ebp
  801f44:	c3                   	ret    

00801f45 <sys_yield>:

void
sys_yield(void)
{
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
  801f48:	57                   	push   %edi
  801f49:	56                   	push   %esi
  801f4a:	53                   	push   %ebx
	asm volatile("int %1\n"
  801f4b:	ba 00 00 00 00       	mov    $0x0,%edx
  801f50:	b8 0b 00 00 00       	mov    $0xb,%eax
  801f55:	89 d1                	mov    %edx,%ecx
  801f57:	89 d3                	mov    %edx,%ebx
  801f59:	89 d7                	mov    %edx,%edi
  801f5b:	89 d6                	mov    %edx,%esi
  801f5d:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801f5f:	5b                   	pop    %ebx
  801f60:	5e                   	pop    %esi
  801f61:	5f                   	pop    %edi
  801f62:	5d                   	pop    %ebp
  801f63:	c3                   	ret    

00801f64 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
  801f67:	57                   	push   %edi
  801f68:	56                   	push   %esi
  801f69:	53                   	push   %ebx
  801f6a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801f6d:	be 00 00 00 00       	mov    $0x0,%esi
  801f72:	8b 55 08             	mov    0x8(%ebp),%edx
  801f75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f78:	b8 04 00 00 00       	mov    $0x4,%eax
  801f7d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f80:	89 f7                	mov    %esi,%edi
  801f82:	cd 30                	int    $0x30
	if (check && ret > 0)
  801f84:	85 c0                	test   %eax,%eax
  801f86:	7f 08                	jg     801f90 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801f88:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f8b:	5b                   	pop    %ebx
  801f8c:	5e                   	pop    %esi
  801f8d:	5f                   	pop    %edi
  801f8e:	5d                   	pop    %ebp
  801f8f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801f90:	83 ec 0c             	sub    $0xc,%esp
  801f93:	50                   	push   %eax
  801f94:	6a 04                	push   $0x4
  801f96:	68 40 3b 80 00       	push   $0x803b40
  801f9b:	6a 4c                	push   $0x4c
  801f9d:	68 5d 3b 80 00       	push   $0x803b5d
  801fa2:	e8 ca f3 ff ff       	call   801371 <_panic>

00801fa7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801fa7:	55                   	push   %ebp
  801fa8:	89 e5                	mov    %esp,%ebp
  801faa:	57                   	push   %edi
  801fab:	56                   	push   %esi
  801fac:	53                   	push   %ebx
  801fad:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801fb0:	8b 55 08             	mov    0x8(%ebp),%edx
  801fb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fb6:	b8 05 00 00 00       	mov    $0x5,%eax
  801fbb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801fbe:	8b 7d 14             	mov    0x14(%ebp),%edi
  801fc1:	8b 75 18             	mov    0x18(%ebp),%esi
  801fc4:	cd 30                	int    $0x30
	if (check && ret > 0)
  801fc6:	85 c0                	test   %eax,%eax
  801fc8:	7f 08                	jg     801fd2 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801fca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fcd:	5b                   	pop    %ebx
  801fce:	5e                   	pop    %esi
  801fcf:	5f                   	pop    %edi
  801fd0:	5d                   	pop    %ebp
  801fd1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801fd2:	83 ec 0c             	sub    $0xc,%esp
  801fd5:	50                   	push   %eax
  801fd6:	6a 05                	push   $0x5
  801fd8:	68 40 3b 80 00       	push   $0x803b40
  801fdd:	6a 4c                	push   $0x4c
  801fdf:	68 5d 3b 80 00       	push   $0x803b5d
  801fe4:	e8 88 f3 ff ff       	call   801371 <_panic>

00801fe9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
  801fec:	57                   	push   %edi
  801fed:	56                   	push   %esi
  801fee:	53                   	push   %ebx
  801fef:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801ff2:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ff7:	8b 55 08             	mov    0x8(%ebp),%edx
  801ffa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ffd:	b8 06 00 00 00       	mov    $0x6,%eax
  802002:	89 df                	mov    %ebx,%edi
  802004:	89 de                	mov    %ebx,%esi
  802006:	cd 30                	int    $0x30
	if (check && ret > 0)
  802008:	85 c0                	test   %eax,%eax
  80200a:	7f 08                	jg     802014 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80200c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80200f:	5b                   	pop    %ebx
  802010:	5e                   	pop    %esi
  802011:	5f                   	pop    %edi
  802012:	5d                   	pop    %ebp
  802013:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802014:	83 ec 0c             	sub    $0xc,%esp
  802017:	50                   	push   %eax
  802018:	6a 06                	push   $0x6
  80201a:	68 40 3b 80 00       	push   $0x803b40
  80201f:	6a 4c                	push   $0x4c
  802021:	68 5d 3b 80 00       	push   $0x803b5d
  802026:	e8 46 f3 ff ff       	call   801371 <_panic>

0080202b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80202b:	55                   	push   %ebp
  80202c:	89 e5                	mov    %esp,%ebp
  80202e:	57                   	push   %edi
  80202f:	56                   	push   %esi
  802030:	53                   	push   %ebx
  802031:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802034:	bb 00 00 00 00       	mov    $0x0,%ebx
  802039:	8b 55 08             	mov    0x8(%ebp),%edx
  80203c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80203f:	b8 08 00 00 00       	mov    $0x8,%eax
  802044:	89 df                	mov    %ebx,%edi
  802046:	89 de                	mov    %ebx,%esi
  802048:	cd 30                	int    $0x30
	if (check && ret > 0)
  80204a:	85 c0                	test   %eax,%eax
  80204c:	7f 08                	jg     802056 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80204e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802051:	5b                   	pop    %ebx
  802052:	5e                   	pop    %esi
  802053:	5f                   	pop    %edi
  802054:	5d                   	pop    %ebp
  802055:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802056:	83 ec 0c             	sub    $0xc,%esp
  802059:	50                   	push   %eax
  80205a:	6a 08                	push   $0x8
  80205c:	68 40 3b 80 00       	push   $0x803b40
  802061:	6a 4c                	push   $0x4c
  802063:	68 5d 3b 80 00       	push   $0x803b5d
  802068:	e8 04 f3 ff ff       	call   801371 <_panic>

0080206d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80206d:	55                   	push   %ebp
  80206e:	89 e5                	mov    %esp,%ebp
  802070:	57                   	push   %edi
  802071:	56                   	push   %esi
  802072:	53                   	push   %ebx
  802073:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802076:	bb 00 00 00 00       	mov    $0x0,%ebx
  80207b:	8b 55 08             	mov    0x8(%ebp),%edx
  80207e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802081:	b8 09 00 00 00       	mov    $0x9,%eax
  802086:	89 df                	mov    %ebx,%edi
  802088:	89 de                	mov    %ebx,%esi
  80208a:	cd 30                	int    $0x30
	if (check && ret > 0)
  80208c:	85 c0                	test   %eax,%eax
  80208e:	7f 08                	jg     802098 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  802090:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802093:	5b                   	pop    %ebx
  802094:	5e                   	pop    %esi
  802095:	5f                   	pop    %edi
  802096:	5d                   	pop    %ebp
  802097:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802098:	83 ec 0c             	sub    $0xc,%esp
  80209b:	50                   	push   %eax
  80209c:	6a 09                	push   $0x9
  80209e:	68 40 3b 80 00       	push   $0x803b40
  8020a3:	6a 4c                	push   $0x4c
  8020a5:	68 5d 3b 80 00       	push   $0x803b5d
  8020aa:	e8 c2 f2 ff ff       	call   801371 <_panic>

008020af <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8020af:	55                   	push   %ebp
  8020b0:	89 e5                	mov    %esp,%ebp
  8020b2:	57                   	push   %edi
  8020b3:	56                   	push   %esi
  8020b4:	53                   	push   %ebx
  8020b5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8020b8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8020bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8020c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020c3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8020c8:	89 df                	mov    %ebx,%edi
  8020ca:	89 de                	mov    %ebx,%esi
  8020cc:	cd 30                	int    $0x30
	if (check && ret > 0)
  8020ce:	85 c0                	test   %eax,%eax
  8020d0:	7f 08                	jg     8020da <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8020d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020d5:	5b                   	pop    %ebx
  8020d6:	5e                   	pop    %esi
  8020d7:	5f                   	pop    %edi
  8020d8:	5d                   	pop    %ebp
  8020d9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8020da:	83 ec 0c             	sub    $0xc,%esp
  8020dd:	50                   	push   %eax
  8020de:	6a 0a                	push   $0xa
  8020e0:	68 40 3b 80 00       	push   $0x803b40
  8020e5:	6a 4c                	push   $0x4c
  8020e7:	68 5d 3b 80 00       	push   $0x803b5d
  8020ec:	e8 80 f2 ff ff       	call   801371 <_panic>

008020f1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8020f1:	55                   	push   %ebp
  8020f2:	89 e5                	mov    %esp,%ebp
  8020f4:	57                   	push   %edi
  8020f5:	56                   	push   %esi
  8020f6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8020f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8020fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020fd:	b8 0c 00 00 00       	mov    $0xc,%eax
  802102:	be 00 00 00 00       	mov    $0x0,%esi
  802107:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80210a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80210d:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80210f:	5b                   	pop    %ebx
  802110:	5e                   	pop    %esi
  802111:	5f                   	pop    %edi
  802112:	5d                   	pop    %ebp
  802113:	c3                   	ret    

00802114 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802114:	55                   	push   %ebp
  802115:	89 e5                	mov    %esp,%ebp
  802117:	57                   	push   %edi
  802118:	56                   	push   %esi
  802119:	53                   	push   %ebx
  80211a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80211d:	b9 00 00 00 00       	mov    $0x0,%ecx
  802122:	8b 55 08             	mov    0x8(%ebp),%edx
  802125:	b8 0d 00 00 00       	mov    $0xd,%eax
  80212a:	89 cb                	mov    %ecx,%ebx
  80212c:	89 cf                	mov    %ecx,%edi
  80212e:	89 ce                	mov    %ecx,%esi
  802130:	cd 30                	int    $0x30
	if (check && ret > 0)
  802132:	85 c0                	test   %eax,%eax
  802134:	7f 08                	jg     80213e <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  802136:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802139:	5b                   	pop    %ebx
  80213a:	5e                   	pop    %esi
  80213b:	5f                   	pop    %edi
  80213c:	5d                   	pop    %ebp
  80213d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80213e:	83 ec 0c             	sub    $0xc,%esp
  802141:	50                   	push   %eax
  802142:	6a 0d                	push   $0xd
  802144:	68 40 3b 80 00       	push   $0x803b40
  802149:	6a 4c                	push   $0x4c
  80214b:	68 5d 3b 80 00       	push   $0x803b5d
  802150:	e8 1c f2 ff ff       	call   801371 <_panic>

00802155 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  802155:	55                   	push   %ebp
  802156:	89 e5                	mov    %esp,%ebp
  802158:	57                   	push   %edi
  802159:	56                   	push   %esi
  80215a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80215b:	bb 00 00 00 00       	mov    $0x0,%ebx
  802160:	8b 55 08             	mov    0x8(%ebp),%edx
  802163:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802166:	b8 0e 00 00 00       	mov    $0xe,%eax
  80216b:	89 df                	mov    %ebx,%edi
  80216d:	89 de                	mov    %ebx,%esi
  80216f:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  802171:	5b                   	pop    %ebx
  802172:	5e                   	pop    %esi
  802173:	5f                   	pop    %edi
  802174:	5d                   	pop    %ebp
  802175:	c3                   	ret    

00802176 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
  802179:	57                   	push   %edi
  80217a:	56                   	push   %esi
  80217b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80217c:	b9 00 00 00 00       	mov    $0x0,%ecx
  802181:	8b 55 08             	mov    0x8(%ebp),%edx
  802184:	b8 0f 00 00 00       	mov    $0xf,%eax
  802189:	89 cb                	mov    %ecx,%ebx
  80218b:	89 cf                	mov    %ecx,%edi
  80218d:	89 ce                	mov    %ecx,%esi
  80218f:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  802191:	5b                   	pop    %ebx
  802192:	5e                   	pop    %esi
  802193:	5f                   	pop    %edi
  802194:	5d                   	pop    %ebp
  802195:	c3                   	ret    

00802196 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802196:	55                   	push   %ebp
  802197:	89 e5                	mov    %esp,%ebp
  802199:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80219c:	83 3d 10 90 80 00 00 	cmpl   $0x0,0x809010
  8021a3:	74 0a                	je     8021af <set_pgfault_handler+0x19>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8021a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a8:	a3 10 90 80 00       	mov    %eax,0x809010
}
  8021ad:	c9                   	leave  
  8021ae:	c3                   	ret    
		ret = sys_page_alloc((envid_t)0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W);
  8021af:	83 ec 04             	sub    $0x4,%esp
  8021b2:	6a 07                	push   $0x7
  8021b4:	68 00 f0 bf ee       	push   $0xeebff000
  8021b9:	6a 00                	push   $0x0
  8021bb:	e8 a4 fd ff ff       	call   801f64 <sys_page_alloc>
		if(ret < 0){
  8021c0:	83 c4 10             	add    $0x10,%esp
  8021c3:	85 c0                	test   %eax,%eax
  8021c5:	78 28                	js     8021ef <set_pgfault_handler+0x59>
    	ret = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8021c7:	83 ec 08             	sub    $0x8,%esp
  8021ca:	68 01 22 80 00       	push   $0x802201
  8021cf:	6a 00                	push   $0x0
  8021d1:	e8 d9 fe ff ff       	call   8020af <sys_env_set_pgfault_upcall>
		if(ret < 0){
  8021d6:	83 c4 10             	add    $0x10,%esp
  8021d9:	85 c0                	test   %eax,%eax
  8021db:	79 c8                	jns    8021a5 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
  8021dd:	50                   	push   %eax
  8021de:	68 a0 3b 80 00       	push   $0x803ba0
  8021e3:	6a 28                	push   $0x28
  8021e5:	68 dd 3b 80 00       	push   $0x803bdd
  8021ea:	e8 82 f1 ff ff       	call   801371 <_panic>
			panic("set_pgfault_handler: sys_page_alloc fail, ret:%d", ret);
  8021ef:	50                   	push   %eax
  8021f0:	68 6c 3b 80 00       	push   $0x803b6c
  8021f5:	6a 24                	push   $0x24
  8021f7:	68 dd 3b 80 00       	push   $0x803bdd
  8021fc:	e8 70 f1 ff ff       	call   801371 <_panic>

00802201 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802201:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802202:	a1 10 90 80 00       	mov    0x809010,%eax
	call *%eax
  802207:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802209:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edi
  80220c:	8b 7c 24 28          	mov    0x28(%esp),%edi
	movl 0x30(%esp), %esi
  802210:	8b 74 24 30          	mov    0x30(%esp),%esi
	subl $4, %esi
  802214:	83 ee 04             	sub    $0x4,%esi
	movl %edi, (%esi)
  802217:	89 3e                	mov    %edi,(%esi)
	movl %esi, 0x30(%esp)
  802219:	89 74 24 30          	mov    %esi,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  80221d:	83 c4 08             	add    $0x8,%esp
	popal
  802220:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802221:	83 c4 04             	add    $0x4,%esp
	popfl
  802224:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802225:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802226:	c3                   	ret    

00802227 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802227:	55                   	push   %ebp
  802228:	89 e5                	mov    %esp,%ebp
  80222a:	56                   	push   %esi
  80222b:	53                   	push   %ebx
  80222c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80222f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802232:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// return 0;
	if(!pg)
  802235:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  802237:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80223c:	0f 44 c2             	cmove  %edx,%eax
	
	int ret;

	ret = sys_ipc_recv(pg);
  80223f:	83 ec 0c             	sub    $0xc,%esp
  802242:	50                   	push   %eax
  802243:	e8 cc fe ff ff       	call   802114 <sys_ipc_recv>
	if(ret < 0){
  802248:	83 c4 10             	add    $0x10,%esp
  80224b:	85 c0                	test   %eax,%eax
  80224d:	78 2b                	js     80227a <ipc_recv+0x53>
		if(perm_store) *perm_store = 0;
		if(from_env_store) *from_env_store = 0;
		return ret;
	}
	
	if(perm_store)
  80224f:	85 f6                	test   %esi,%esi
  802251:	74 0a                	je     80225d <ipc_recv+0x36>
		*perm_store = thisenv->env_ipc_perm;
  802253:	a1 0c 90 80 00       	mov    0x80900c,%eax
  802258:	8b 40 78             	mov    0x78(%eax),%eax
  80225b:	89 06                	mov    %eax,(%esi)
	if(from_env_store)
  80225d:	85 db                	test   %ebx,%ebx
  80225f:	74 0a                	je     80226b <ipc_recv+0x44>
		*from_env_store = thisenv->env_ipc_from;
  802261:	a1 0c 90 80 00       	mov    0x80900c,%eax
  802266:	8b 40 74             	mov    0x74(%eax),%eax
  802269:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  80226b:	a1 0c 90 80 00       	mov    0x80900c,%eax
  802270:	8b 40 70             	mov    0x70(%eax),%eax
}
  802273:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802276:	5b                   	pop    %ebx
  802277:	5e                   	pop    %esi
  802278:	5d                   	pop    %ebp
  802279:	c3                   	ret    
		if(perm_store) *perm_store = 0;
  80227a:	85 f6                	test   %esi,%esi
  80227c:	74 06                	je     802284 <ipc_recv+0x5d>
  80227e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(from_env_store) *from_env_store = 0;
  802284:	85 db                	test   %ebx,%ebx
  802286:	74 eb                	je     802273 <ipc_recv+0x4c>
  802288:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80228e:	eb e3                	jmp    802273 <ipc_recv+0x4c>

00802290 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802290:	55                   	push   %ebp
  802291:	89 e5                	mov    %esp,%ebp
  802293:	57                   	push   %edi
  802294:	56                   	push   %esi
  802295:	53                   	push   %ebx
  802296:	83 ec 0c             	sub    $0xc,%esp
  802299:	8b 7d 08             	mov    0x8(%ebp),%edi
  80229c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80229f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
	if (!pg)
  8022a2:	85 db                	test   %ebx,%ebx
		pg = (void*)UTOP;
  8022a4:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8022a9:	0f 44 d8             	cmove  %eax,%ebx

	int ret = -E_IPC_NOT_RECV;
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))) {
  8022ac:	ff 75 14             	pushl  0x14(%ebp)
  8022af:	53                   	push   %ebx
  8022b0:	56                   	push   %esi
  8022b1:	57                   	push   %edi
  8022b2:	e8 3a fe ff ff       	call   8020f1 <sys_ipc_try_send>
  8022b7:	83 c4 10             	add    $0x10,%esp
  8022ba:	85 c0                	test   %eax,%eax
  8022bc:	74 17                	je     8022d5 <ipc_send+0x45>
		if(ret != -E_IPC_NOT_RECV){
  8022be:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8022c1:	74 e9                	je     8022ac <ipc_send+0x1c>
			panic("ipc_send: ret : %d", ret);
  8022c3:	50                   	push   %eax
  8022c4:	68 eb 3b 80 00       	push   $0x803beb
  8022c9:	6a 43                	push   $0x43
  8022cb:	68 fe 3b 80 00       	push   $0x803bfe
  8022d0:	e8 9c f0 ff ff       	call   801371 <_panic>
			sys_yield();
		}
	}
}
  8022d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022d8:	5b                   	pop    %ebx
  8022d9:	5e                   	pop    %esi
  8022da:	5f                   	pop    %edi
  8022db:	5d                   	pop    %ebp
  8022dc:	c3                   	ret    

008022dd <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022dd:	55                   	push   %ebp
  8022de:	89 e5                	mov    %esp,%ebp
  8022e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022e3:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022e8:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8022ee:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022f4:	8b 52 50             	mov    0x50(%edx),%edx
  8022f7:	39 ca                	cmp    %ecx,%edx
  8022f9:	74 11                	je     80230c <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8022fb:	83 c0 01             	add    $0x1,%eax
  8022fe:	3d 00 04 00 00       	cmp    $0x400,%eax
  802303:	75 e3                	jne    8022e8 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802305:	b8 00 00 00 00       	mov    $0x0,%eax
  80230a:	eb 0e                	jmp    80231a <ipc_find_env+0x3d>
			return envs[i].env_id;
  80230c:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  802312:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802317:	8b 40 48             	mov    0x48(%eax),%eax
}
  80231a:	5d                   	pop    %ebp
  80231b:	c3                   	ret    

0080231c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80231c:	55                   	push   %ebp
  80231d:	89 e5                	mov    %esp,%ebp
  80231f:	56                   	push   %esi
  802320:	53                   	push   %ebx
  802321:	89 c6                	mov    %eax,%esi
  802323:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  802325:	83 3d 00 90 80 00 00 	cmpl   $0x0,0x809000
  80232c:	74 27                	je     802355 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80232e:	6a 07                	push   $0x7
  802330:	68 00 a0 80 00       	push   $0x80a000
  802335:	56                   	push   %esi
  802336:	ff 35 00 90 80 00    	pushl  0x809000
  80233c:	e8 4f ff ff ff       	call   802290 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  802341:	83 c4 0c             	add    $0xc,%esp
  802344:	6a 00                	push   $0x0
  802346:	53                   	push   %ebx
  802347:	6a 00                	push   $0x0
  802349:	e8 d9 fe ff ff       	call   802227 <ipc_recv>
}
  80234e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802351:	5b                   	pop    %ebx
  802352:	5e                   	pop    %esi
  802353:	5d                   	pop    %ebp
  802354:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802355:	83 ec 0c             	sub    $0xc,%esp
  802358:	6a 01                	push   $0x1
  80235a:	e8 7e ff ff ff       	call   8022dd <ipc_find_env>
  80235f:	a3 00 90 80 00       	mov    %eax,0x809000
  802364:	83 c4 10             	add    $0x10,%esp
  802367:	eb c5                	jmp    80232e <fsipc+0x12>

00802369 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802369:	55                   	push   %ebp
  80236a:	89 e5                	mov    %esp,%ebp
  80236c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80236f:	8b 45 08             	mov    0x8(%ebp),%eax
  802372:	8b 40 0c             	mov    0xc(%eax),%eax
  802375:	a3 00 a0 80 00       	mov    %eax,0x80a000
	fsipcbuf.set_size.req_size = newsize;
  80237a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80237d:	a3 04 a0 80 00       	mov    %eax,0x80a004
	return fsipc(FSREQ_SET_SIZE, NULL);
  802382:	ba 00 00 00 00       	mov    $0x0,%edx
  802387:	b8 02 00 00 00       	mov    $0x2,%eax
  80238c:	e8 8b ff ff ff       	call   80231c <fsipc>
}
  802391:	c9                   	leave  
  802392:	c3                   	ret    

00802393 <devfile_flush>:
{
  802393:	55                   	push   %ebp
  802394:	89 e5                	mov    %esp,%ebp
  802396:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802399:	8b 45 08             	mov    0x8(%ebp),%eax
  80239c:	8b 40 0c             	mov    0xc(%eax),%eax
  80239f:	a3 00 a0 80 00       	mov    %eax,0x80a000
	return fsipc(FSREQ_FLUSH, NULL);
  8023a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8023a9:	b8 06 00 00 00       	mov    $0x6,%eax
  8023ae:	e8 69 ff ff ff       	call   80231c <fsipc>
}
  8023b3:	c9                   	leave  
  8023b4:	c3                   	ret    

008023b5 <devfile_stat>:
{
  8023b5:	55                   	push   %ebp
  8023b6:	89 e5                	mov    %esp,%ebp
  8023b8:	53                   	push   %ebx
  8023b9:	83 ec 04             	sub    $0x4,%esp
  8023bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8023bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8023c5:	a3 00 a0 80 00       	mov    %eax,0x80a000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8023ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8023cf:	b8 05 00 00 00       	mov    $0x5,%eax
  8023d4:	e8 43 ff ff ff       	call   80231c <fsipc>
  8023d9:	85 c0                	test   %eax,%eax
  8023db:	78 2c                	js     802409 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8023dd:	83 ec 08             	sub    $0x8,%esp
  8023e0:	68 00 a0 80 00       	push   $0x80a000
  8023e5:	53                   	push   %ebx
  8023e6:	e8 87 f7 ff ff       	call   801b72 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8023eb:	a1 80 a0 80 00       	mov    0x80a080,%eax
  8023f0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8023f6:	a1 84 a0 80 00       	mov    0x80a084,%eax
  8023fb:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  802401:	83 c4 10             	add    $0x10,%esp
  802404:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802409:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80240c:	c9                   	leave  
  80240d:	c3                   	ret    

0080240e <devfile_write>:
{
  80240e:	55                   	push   %ebp
  80240f:	89 e5                	mov    %esp,%ebp
  802411:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  802414:	68 08 3c 80 00       	push   $0x803c08
  802419:	68 90 00 00 00       	push   $0x90
  80241e:	68 26 3c 80 00       	push   $0x803c26
  802423:	e8 49 ef ff ff       	call   801371 <_panic>

00802428 <devfile_read>:
{
  802428:	55                   	push   %ebp
  802429:	89 e5                	mov    %esp,%ebp
  80242b:	56                   	push   %esi
  80242c:	53                   	push   %ebx
  80242d:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802430:	8b 45 08             	mov    0x8(%ebp),%eax
  802433:	8b 40 0c             	mov    0xc(%eax),%eax
  802436:	a3 00 a0 80 00       	mov    %eax,0x80a000
	fsipcbuf.read.req_n = n;
  80243b:	89 35 04 a0 80 00    	mov    %esi,0x80a004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802441:	ba 00 00 00 00       	mov    $0x0,%edx
  802446:	b8 03 00 00 00       	mov    $0x3,%eax
  80244b:	e8 cc fe ff ff       	call   80231c <fsipc>
  802450:	89 c3                	mov    %eax,%ebx
  802452:	85 c0                	test   %eax,%eax
  802454:	78 1f                	js     802475 <devfile_read+0x4d>
	assert(r <= n);
  802456:	39 f0                	cmp    %esi,%eax
  802458:	77 24                	ja     80247e <devfile_read+0x56>
	assert(r <= PGSIZE);
  80245a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80245f:	7f 33                	jg     802494 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802461:	83 ec 04             	sub    $0x4,%esp
  802464:	50                   	push   %eax
  802465:	68 00 a0 80 00       	push   $0x80a000
  80246a:	ff 75 0c             	pushl  0xc(%ebp)
  80246d:	e8 8e f8 ff ff       	call   801d00 <memmove>
	return r;
  802472:	83 c4 10             	add    $0x10,%esp
}
  802475:	89 d8                	mov    %ebx,%eax
  802477:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80247a:	5b                   	pop    %ebx
  80247b:	5e                   	pop    %esi
  80247c:	5d                   	pop    %ebp
  80247d:	c3                   	ret    
	assert(r <= n);
  80247e:	68 31 3c 80 00       	push   $0x803c31
  802483:	68 7d 32 80 00       	push   $0x80327d
  802488:	6a 7c                	push   $0x7c
  80248a:	68 26 3c 80 00       	push   $0x803c26
  80248f:	e8 dd ee ff ff       	call   801371 <_panic>
	assert(r <= PGSIZE);
  802494:	68 38 3c 80 00       	push   $0x803c38
  802499:	68 7d 32 80 00       	push   $0x80327d
  80249e:	6a 7d                	push   $0x7d
  8024a0:	68 26 3c 80 00       	push   $0x803c26
  8024a5:	e8 c7 ee ff ff       	call   801371 <_panic>

008024aa <open>:
{
  8024aa:	55                   	push   %ebp
  8024ab:	89 e5                	mov    %esp,%ebp
  8024ad:	56                   	push   %esi
  8024ae:	53                   	push   %ebx
  8024af:	83 ec 1c             	sub    $0x1c,%esp
  8024b2:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8024b5:	56                   	push   %esi
  8024b6:	e8 7e f6 ff ff       	call   801b39 <strlen>
  8024bb:	83 c4 10             	add    $0x10,%esp
  8024be:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8024c3:	7f 6c                	jg     802531 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8024c5:	83 ec 0c             	sub    $0xc,%esp
  8024c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024cb:	50                   	push   %eax
  8024cc:	e8 e0 00 00 00       	call   8025b1 <fd_alloc>
  8024d1:	89 c3                	mov    %eax,%ebx
  8024d3:	83 c4 10             	add    $0x10,%esp
  8024d6:	85 c0                	test   %eax,%eax
  8024d8:	78 3c                	js     802516 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8024da:	83 ec 08             	sub    $0x8,%esp
  8024dd:	56                   	push   %esi
  8024de:	68 00 a0 80 00       	push   $0x80a000
  8024e3:	e8 8a f6 ff ff       	call   801b72 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8024e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024eb:	a3 00 a4 80 00       	mov    %eax,0x80a400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8024f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f3:	b8 01 00 00 00       	mov    $0x1,%eax
  8024f8:	e8 1f fe ff ff       	call   80231c <fsipc>
  8024fd:	89 c3                	mov    %eax,%ebx
  8024ff:	83 c4 10             	add    $0x10,%esp
  802502:	85 c0                	test   %eax,%eax
  802504:	78 19                	js     80251f <open+0x75>
	return fd2num(fd);
  802506:	83 ec 0c             	sub    $0xc,%esp
  802509:	ff 75 f4             	pushl  -0xc(%ebp)
  80250c:	e8 79 00 00 00       	call   80258a <fd2num>
  802511:	89 c3                	mov    %eax,%ebx
  802513:	83 c4 10             	add    $0x10,%esp
}
  802516:	89 d8                	mov    %ebx,%eax
  802518:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80251b:	5b                   	pop    %ebx
  80251c:	5e                   	pop    %esi
  80251d:	5d                   	pop    %ebp
  80251e:	c3                   	ret    
		fd_close(fd, 0);
  80251f:	83 ec 08             	sub    $0x8,%esp
  802522:	6a 00                	push   $0x0
  802524:	ff 75 f4             	pushl  -0xc(%ebp)
  802527:	e8 7d 01 00 00       	call   8026a9 <fd_close>
		return r;
  80252c:	83 c4 10             	add    $0x10,%esp
  80252f:	eb e5                	jmp    802516 <open+0x6c>
		return -E_BAD_PATH;
  802531:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  802536:	eb de                	jmp    802516 <open+0x6c>

00802538 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802538:	55                   	push   %ebp
  802539:	89 e5                	mov    %esp,%ebp
  80253b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80253e:	ba 00 00 00 00       	mov    $0x0,%edx
  802543:	b8 08 00 00 00       	mov    $0x8,%eax
  802548:	e8 cf fd ff ff       	call   80231c <fsipc>
}
  80254d:	c9                   	leave  
  80254e:	c3                   	ret    

0080254f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80254f:	55                   	push   %ebp
  802550:	89 e5                	mov    %esp,%ebp
  802552:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802555:	89 d0                	mov    %edx,%eax
  802557:	c1 e8 16             	shr    $0x16,%eax
  80255a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802561:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802566:	f6 c1 01             	test   $0x1,%cl
  802569:	74 1d                	je     802588 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80256b:	c1 ea 0c             	shr    $0xc,%edx
  80256e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802575:	f6 c2 01             	test   $0x1,%dl
  802578:	74 0e                	je     802588 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80257a:	c1 ea 0c             	shr    $0xc,%edx
  80257d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802584:	ef 
  802585:	0f b7 c0             	movzwl %ax,%eax
}
  802588:	5d                   	pop    %ebp
  802589:	c3                   	ret    

0080258a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80258a:	55                   	push   %ebp
  80258b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80258d:	8b 45 08             	mov    0x8(%ebp),%eax
  802590:	05 00 00 00 30       	add    $0x30000000,%eax
  802595:	c1 e8 0c             	shr    $0xc,%eax
}
  802598:	5d                   	pop    %ebp
  802599:	c3                   	ret    

0080259a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80259a:	55                   	push   %ebp
  80259b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80259d:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a0:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8025a5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8025aa:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8025af:	5d                   	pop    %ebp
  8025b0:	c3                   	ret    

008025b1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8025b1:	55                   	push   %ebp
  8025b2:	89 e5                	mov    %esp,%ebp
  8025b4:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8025b9:	89 c2                	mov    %eax,%edx
  8025bb:	c1 ea 16             	shr    $0x16,%edx
  8025be:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8025c5:	f6 c2 01             	test   $0x1,%dl
  8025c8:	74 2d                	je     8025f7 <fd_alloc+0x46>
  8025ca:	89 c2                	mov    %eax,%edx
  8025cc:	c1 ea 0c             	shr    $0xc,%edx
  8025cf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8025d6:	f6 c2 01             	test   $0x1,%dl
  8025d9:	74 1c                	je     8025f7 <fd_alloc+0x46>
  8025db:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8025e0:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8025e5:	75 d2                	jne    8025b9 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8025e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8025f0:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8025f5:	eb 0a                	jmp    802601 <fd_alloc+0x50>
			*fd_store = fd;
  8025f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025fa:	89 01                	mov    %eax,(%ecx)
			return 0;
  8025fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802601:	5d                   	pop    %ebp
  802602:	c3                   	ret    

00802603 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802603:	55                   	push   %ebp
  802604:	89 e5                	mov    %esp,%ebp
  802606:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802609:	83 f8 1f             	cmp    $0x1f,%eax
  80260c:	77 30                	ja     80263e <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80260e:	c1 e0 0c             	shl    $0xc,%eax
  802611:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802616:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80261c:	f6 c2 01             	test   $0x1,%dl
  80261f:	74 24                	je     802645 <fd_lookup+0x42>
  802621:	89 c2                	mov    %eax,%edx
  802623:	c1 ea 0c             	shr    $0xc,%edx
  802626:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80262d:	f6 c2 01             	test   $0x1,%dl
  802630:	74 1a                	je     80264c <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  802632:	8b 55 0c             	mov    0xc(%ebp),%edx
  802635:	89 02                	mov    %eax,(%edx)
	return 0;
  802637:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80263c:	5d                   	pop    %ebp
  80263d:	c3                   	ret    
		return -E_INVAL;
  80263e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802643:	eb f7                	jmp    80263c <fd_lookup+0x39>
		return -E_INVAL;
  802645:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80264a:	eb f0                	jmp    80263c <fd_lookup+0x39>
  80264c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802651:	eb e9                	jmp    80263c <fd_lookup+0x39>

00802653 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802653:	55                   	push   %ebp
  802654:	89 e5                	mov    %esp,%ebp
  802656:	83 ec 08             	sub    $0x8,%esp
  802659:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80265c:	ba c4 3c 80 00       	mov    $0x803cc4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  802661:	b8 64 80 80 00       	mov    $0x808064,%eax
		if (devtab[i]->dev_id == dev_id) {
  802666:	39 08                	cmp    %ecx,(%eax)
  802668:	74 33                	je     80269d <dev_lookup+0x4a>
  80266a:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80266d:	8b 02                	mov    (%edx),%eax
  80266f:	85 c0                	test   %eax,%eax
  802671:	75 f3                	jne    802666 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802673:	a1 0c 90 80 00       	mov    0x80900c,%eax
  802678:	8b 40 48             	mov    0x48(%eax),%eax
  80267b:	83 ec 04             	sub    $0x4,%esp
  80267e:	51                   	push   %ecx
  80267f:	50                   	push   %eax
  802680:	68 44 3c 80 00       	push   $0x803c44
  802685:	e8 c2 ed ff ff       	call   80144c <cprintf>
	*dev = 0;
  80268a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80268d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  802693:	83 c4 10             	add    $0x10,%esp
  802696:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80269b:	c9                   	leave  
  80269c:	c3                   	ret    
			*dev = devtab[i];
  80269d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026a0:	89 01                	mov    %eax,(%ecx)
			return 0;
  8026a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a7:	eb f2                	jmp    80269b <dev_lookup+0x48>

008026a9 <fd_close>:
{
  8026a9:	55                   	push   %ebp
  8026aa:	89 e5                	mov    %esp,%ebp
  8026ac:	57                   	push   %edi
  8026ad:	56                   	push   %esi
  8026ae:	53                   	push   %ebx
  8026af:	83 ec 24             	sub    $0x24,%esp
  8026b2:	8b 75 08             	mov    0x8(%ebp),%esi
  8026b5:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8026b8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8026bb:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8026bc:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8026c2:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8026c5:	50                   	push   %eax
  8026c6:	e8 38 ff ff ff       	call   802603 <fd_lookup>
  8026cb:	89 c3                	mov    %eax,%ebx
  8026cd:	83 c4 10             	add    $0x10,%esp
  8026d0:	85 c0                	test   %eax,%eax
  8026d2:	78 05                	js     8026d9 <fd_close+0x30>
	    || fd != fd2)
  8026d4:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8026d7:	74 16                	je     8026ef <fd_close+0x46>
		return (must_exist ? r : 0);
  8026d9:	89 f8                	mov    %edi,%eax
  8026db:	84 c0                	test   %al,%al
  8026dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e2:	0f 44 d8             	cmove  %eax,%ebx
}
  8026e5:	89 d8                	mov    %ebx,%eax
  8026e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026ea:	5b                   	pop    %ebx
  8026eb:	5e                   	pop    %esi
  8026ec:	5f                   	pop    %edi
  8026ed:	5d                   	pop    %ebp
  8026ee:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8026ef:	83 ec 08             	sub    $0x8,%esp
  8026f2:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8026f5:	50                   	push   %eax
  8026f6:	ff 36                	pushl  (%esi)
  8026f8:	e8 56 ff ff ff       	call   802653 <dev_lookup>
  8026fd:	89 c3                	mov    %eax,%ebx
  8026ff:	83 c4 10             	add    $0x10,%esp
  802702:	85 c0                	test   %eax,%eax
  802704:	78 1a                	js     802720 <fd_close+0x77>
		if (dev->dev_close)
  802706:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802709:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80270c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  802711:	85 c0                	test   %eax,%eax
  802713:	74 0b                	je     802720 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  802715:	83 ec 0c             	sub    $0xc,%esp
  802718:	56                   	push   %esi
  802719:	ff d0                	call   *%eax
  80271b:	89 c3                	mov    %eax,%ebx
  80271d:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  802720:	83 ec 08             	sub    $0x8,%esp
  802723:	56                   	push   %esi
  802724:	6a 00                	push   $0x0
  802726:	e8 be f8 ff ff       	call   801fe9 <sys_page_unmap>
	return r;
  80272b:	83 c4 10             	add    $0x10,%esp
  80272e:	eb b5                	jmp    8026e5 <fd_close+0x3c>

00802730 <close>:

int
close(int fdnum)
{
  802730:	55                   	push   %ebp
  802731:	89 e5                	mov    %esp,%ebp
  802733:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802736:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802739:	50                   	push   %eax
  80273a:	ff 75 08             	pushl  0x8(%ebp)
  80273d:	e8 c1 fe ff ff       	call   802603 <fd_lookup>
  802742:	83 c4 10             	add    $0x10,%esp
  802745:	85 c0                	test   %eax,%eax
  802747:	79 02                	jns    80274b <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  802749:	c9                   	leave  
  80274a:	c3                   	ret    
		return fd_close(fd, 1);
  80274b:	83 ec 08             	sub    $0x8,%esp
  80274e:	6a 01                	push   $0x1
  802750:	ff 75 f4             	pushl  -0xc(%ebp)
  802753:	e8 51 ff ff ff       	call   8026a9 <fd_close>
  802758:	83 c4 10             	add    $0x10,%esp
  80275b:	eb ec                	jmp    802749 <close+0x19>

0080275d <close_all>:

void
close_all(void)
{
  80275d:	55                   	push   %ebp
  80275e:	89 e5                	mov    %esp,%ebp
  802760:	53                   	push   %ebx
  802761:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  802764:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  802769:	83 ec 0c             	sub    $0xc,%esp
  80276c:	53                   	push   %ebx
  80276d:	e8 be ff ff ff       	call   802730 <close>
	for (i = 0; i < MAXFD; i++)
  802772:	83 c3 01             	add    $0x1,%ebx
  802775:	83 c4 10             	add    $0x10,%esp
  802778:	83 fb 20             	cmp    $0x20,%ebx
  80277b:	75 ec                	jne    802769 <close_all+0xc>
}
  80277d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802780:	c9                   	leave  
  802781:	c3                   	ret    

00802782 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802782:	55                   	push   %ebp
  802783:	89 e5                	mov    %esp,%ebp
  802785:	57                   	push   %edi
  802786:	56                   	push   %esi
  802787:	53                   	push   %ebx
  802788:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80278b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80278e:	50                   	push   %eax
  80278f:	ff 75 08             	pushl  0x8(%ebp)
  802792:	e8 6c fe ff ff       	call   802603 <fd_lookup>
  802797:	89 c3                	mov    %eax,%ebx
  802799:	83 c4 10             	add    $0x10,%esp
  80279c:	85 c0                	test   %eax,%eax
  80279e:	0f 88 81 00 00 00    	js     802825 <dup+0xa3>
		return r;
	close(newfdnum);
  8027a4:	83 ec 0c             	sub    $0xc,%esp
  8027a7:	ff 75 0c             	pushl  0xc(%ebp)
  8027aa:	e8 81 ff ff ff       	call   802730 <close>

	newfd = INDEX2FD(newfdnum);
  8027af:	8b 75 0c             	mov    0xc(%ebp),%esi
  8027b2:	c1 e6 0c             	shl    $0xc,%esi
  8027b5:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8027bb:	83 c4 04             	add    $0x4,%esp
  8027be:	ff 75 e4             	pushl  -0x1c(%ebp)
  8027c1:	e8 d4 fd ff ff       	call   80259a <fd2data>
  8027c6:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8027c8:	89 34 24             	mov    %esi,(%esp)
  8027cb:	e8 ca fd ff ff       	call   80259a <fd2data>
  8027d0:	83 c4 10             	add    $0x10,%esp
  8027d3:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8027d5:	89 d8                	mov    %ebx,%eax
  8027d7:	c1 e8 16             	shr    $0x16,%eax
  8027da:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8027e1:	a8 01                	test   $0x1,%al
  8027e3:	74 11                	je     8027f6 <dup+0x74>
  8027e5:	89 d8                	mov    %ebx,%eax
  8027e7:	c1 e8 0c             	shr    $0xc,%eax
  8027ea:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8027f1:	f6 c2 01             	test   $0x1,%dl
  8027f4:	75 39                	jne    80282f <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8027f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027f9:	89 d0                	mov    %edx,%eax
  8027fb:	c1 e8 0c             	shr    $0xc,%eax
  8027fe:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802805:	83 ec 0c             	sub    $0xc,%esp
  802808:	25 07 0e 00 00       	and    $0xe07,%eax
  80280d:	50                   	push   %eax
  80280e:	56                   	push   %esi
  80280f:	6a 00                	push   $0x0
  802811:	52                   	push   %edx
  802812:	6a 00                	push   $0x0
  802814:	e8 8e f7 ff ff       	call   801fa7 <sys_page_map>
  802819:	89 c3                	mov    %eax,%ebx
  80281b:	83 c4 20             	add    $0x20,%esp
  80281e:	85 c0                	test   %eax,%eax
  802820:	78 31                	js     802853 <dup+0xd1>
		goto err;

	return newfdnum;
  802822:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  802825:	89 d8                	mov    %ebx,%eax
  802827:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80282a:	5b                   	pop    %ebx
  80282b:	5e                   	pop    %esi
  80282c:	5f                   	pop    %edi
  80282d:	5d                   	pop    %ebp
  80282e:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80282f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802836:	83 ec 0c             	sub    $0xc,%esp
  802839:	25 07 0e 00 00       	and    $0xe07,%eax
  80283e:	50                   	push   %eax
  80283f:	57                   	push   %edi
  802840:	6a 00                	push   $0x0
  802842:	53                   	push   %ebx
  802843:	6a 00                	push   $0x0
  802845:	e8 5d f7 ff ff       	call   801fa7 <sys_page_map>
  80284a:	89 c3                	mov    %eax,%ebx
  80284c:	83 c4 20             	add    $0x20,%esp
  80284f:	85 c0                	test   %eax,%eax
  802851:	79 a3                	jns    8027f6 <dup+0x74>
	sys_page_unmap(0, newfd);
  802853:	83 ec 08             	sub    $0x8,%esp
  802856:	56                   	push   %esi
  802857:	6a 00                	push   $0x0
  802859:	e8 8b f7 ff ff       	call   801fe9 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80285e:	83 c4 08             	add    $0x8,%esp
  802861:	57                   	push   %edi
  802862:	6a 00                	push   $0x0
  802864:	e8 80 f7 ff ff       	call   801fe9 <sys_page_unmap>
	return r;
  802869:	83 c4 10             	add    $0x10,%esp
  80286c:	eb b7                	jmp    802825 <dup+0xa3>

0080286e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80286e:	55                   	push   %ebp
  80286f:	89 e5                	mov    %esp,%ebp
  802871:	53                   	push   %ebx
  802872:	83 ec 1c             	sub    $0x1c,%esp
  802875:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802878:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80287b:	50                   	push   %eax
  80287c:	53                   	push   %ebx
  80287d:	e8 81 fd ff ff       	call   802603 <fd_lookup>
  802882:	83 c4 10             	add    $0x10,%esp
  802885:	85 c0                	test   %eax,%eax
  802887:	78 3f                	js     8028c8 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802889:	83 ec 08             	sub    $0x8,%esp
  80288c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80288f:	50                   	push   %eax
  802890:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802893:	ff 30                	pushl  (%eax)
  802895:	e8 b9 fd ff ff       	call   802653 <dev_lookup>
  80289a:	83 c4 10             	add    $0x10,%esp
  80289d:	85 c0                	test   %eax,%eax
  80289f:	78 27                	js     8028c8 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8028a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028a4:	8b 42 08             	mov    0x8(%edx),%eax
  8028a7:	83 e0 03             	and    $0x3,%eax
  8028aa:	83 f8 01             	cmp    $0x1,%eax
  8028ad:	74 1e                	je     8028cd <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8028af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b2:	8b 40 08             	mov    0x8(%eax),%eax
  8028b5:	85 c0                	test   %eax,%eax
  8028b7:	74 35                	je     8028ee <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8028b9:	83 ec 04             	sub    $0x4,%esp
  8028bc:	ff 75 10             	pushl  0x10(%ebp)
  8028bf:	ff 75 0c             	pushl  0xc(%ebp)
  8028c2:	52                   	push   %edx
  8028c3:	ff d0                	call   *%eax
  8028c5:	83 c4 10             	add    $0x10,%esp
}
  8028c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8028cb:	c9                   	leave  
  8028cc:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8028cd:	a1 0c 90 80 00       	mov    0x80900c,%eax
  8028d2:	8b 40 48             	mov    0x48(%eax),%eax
  8028d5:	83 ec 04             	sub    $0x4,%esp
  8028d8:	53                   	push   %ebx
  8028d9:	50                   	push   %eax
  8028da:	68 88 3c 80 00       	push   $0x803c88
  8028df:	e8 68 eb ff ff       	call   80144c <cprintf>
		return -E_INVAL;
  8028e4:	83 c4 10             	add    $0x10,%esp
  8028e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028ec:	eb da                	jmp    8028c8 <read+0x5a>
		return -E_NOT_SUPP;
  8028ee:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8028f3:	eb d3                	jmp    8028c8 <read+0x5a>

008028f5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8028f5:	55                   	push   %ebp
  8028f6:	89 e5                	mov    %esp,%ebp
  8028f8:	57                   	push   %edi
  8028f9:	56                   	push   %esi
  8028fa:	53                   	push   %ebx
  8028fb:	83 ec 0c             	sub    $0xc,%esp
  8028fe:	8b 7d 08             	mov    0x8(%ebp),%edi
  802901:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802904:	bb 00 00 00 00       	mov    $0x0,%ebx
  802909:	39 f3                	cmp    %esi,%ebx
  80290b:	73 23                	jae    802930 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80290d:	83 ec 04             	sub    $0x4,%esp
  802910:	89 f0                	mov    %esi,%eax
  802912:	29 d8                	sub    %ebx,%eax
  802914:	50                   	push   %eax
  802915:	89 d8                	mov    %ebx,%eax
  802917:	03 45 0c             	add    0xc(%ebp),%eax
  80291a:	50                   	push   %eax
  80291b:	57                   	push   %edi
  80291c:	e8 4d ff ff ff       	call   80286e <read>
		if (m < 0)
  802921:	83 c4 10             	add    $0x10,%esp
  802924:	85 c0                	test   %eax,%eax
  802926:	78 06                	js     80292e <readn+0x39>
			return m;
		if (m == 0)
  802928:	74 06                	je     802930 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80292a:	01 c3                	add    %eax,%ebx
  80292c:	eb db                	jmp    802909 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80292e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  802930:	89 d8                	mov    %ebx,%eax
  802932:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802935:	5b                   	pop    %ebx
  802936:	5e                   	pop    %esi
  802937:	5f                   	pop    %edi
  802938:	5d                   	pop    %ebp
  802939:	c3                   	ret    

0080293a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80293a:	55                   	push   %ebp
  80293b:	89 e5                	mov    %esp,%ebp
  80293d:	53                   	push   %ebx
  80293e:	83 ec 1c             	sub    $0x1c,%esp
  802941:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802944:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802947:	50                   	push   %eax
  802948:	53                   	push   %ebx
  802949:	e8 b5 fc ff ff       	call   802603 <fd_lookup>
  80294e:	83 c4 10             	add    $0x10,%esp
  802951:	85 c0                	test   %eax,%eax
  802953:	78 3a                	js     80298f <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802955:	83 ec 08             	sub    $0x8,%esp
  802958:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80295b:	50                   	push   %eax
  80295c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295f:	ff 30                	pushl  (%eax)
  802961:	e8 ed fc ff ff       	call   802653 <dev_lookup>
  802966:	83 c4 10             	add    $0x10,%esp
  802969:	85 c0                	test   %eax,%eax
  80296b:	78 22                	js     80298f <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80296d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802970:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802974:	74 1e                	je     802994 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802976:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802979:	8b 52 0c             	mov    0xc(%edx),%edx
  80297c:	85 d2                	test   %edx,%edx
  80297e:	74 35                	je     8029b5 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802980:	83 ec 04             	sub    $0x4,%esp
  802983:	ff 75 10             	pushl  0x10(%ebp)
  802986:	ff 75 0c             	pushl  0xc(%ebp)
  802989:	50                   	push   %eax
  80298a:	ff d2                	call   *%edx
  80298c:	83 c4 10             	add    $0x10,%esp
}
  80298f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802992:	c9                   	leave  
  802993:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802994:	a1 0c 90 80 00       	mov    0x80900c,%eax
  802999:	8b 40 48             	mov    0x48(%eax),%eax
  80299c:	83 ec 04             	sub    $0x4,%esp
  80299f:	53                   	push   %ebx
  8029a0:	50                   	push   %eax
  8029a1:	68 a4 3c 80 00       	push   $0x803ca4
  8029a6:	e8 a1 ea ff ff       	call   80144c <cprintf>
		return -E_INVAL;
  8029ab:	83 c4 10             	add    $0x10,%esp
  8029ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029b3:	eb da                	jmp    80298f <write+0x55>
		return -E_NOT_SUPP;
  8029b5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8029ba:	eb d3                	jmp    80298f <write+0x55>

008029bc <seek>:

int
seek(int fdnum, off_t offset)
{
  8029bc:	55                   	push   %ebp
  8029bd:	89 e5                	mov    %esp,%ebp
  8029bf:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8029c5:	50                   	push   %eax
  8029c6:	ff 75 08             	pushl  0x8(%ebp)
  8029c9:	e8 35 fc ff ff       	call   802603 <fd_lookup>
  8029ce:	83 c4 10             	add    $0x10,%esp
  8029d1:	85 c0                	test   %eax,%eax
  8029d3:	78 0e                	js     8029e3 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8029d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029db:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8029de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029e3:	c9                   	leave  
  8029e4:	c3                   	ret    

008029e5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8029e5:	55                   	push   %ebp
  8029e6:	89 e5                	mov    %esp,%ebp
  8029e8:	53                   	push   %ebx
  8029e9:	83 ec 1c             	sub    $0x1c,%esp
  8029ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029ef:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8029f2:	50                   	push   %eax
  8029f3:	53                   	push   %ebx
  8029f4:	e8 0a fc ff ff       	call   802603 <fd_lookup>
  8029f9:	83 c4 10             	add    $0x10,%esp
  8029fc:	85 c0                	test   %eax,%eax
  8029fe:	78 37                	js     802a37 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a00:	83 ec 08             	sub    $0x8,%esp
  802a03:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a06:	50                   	push   %eax
  802a07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0a:	ff 30                	pushl  (%eax)
  802a0c:	e8 42 fc ff ff       	call   802653 <dev_lookup>
  802a11:	83 c4 10             	add    $0x10,%esp
  802a14:	85 c0                	test   %eax,%eax
  802a16:	78 1f                	js     802a37 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802a1f:	74 1b                	je     802a3c <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  802a21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a24:	8b 52 18             	mov    0x18(%edx),%edx
  802a27:	85 d2                	test   %edx,%edx
  802a29:	74 32                	je     802a5d <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  802a2b:	83 ec 08             	sub    $0x8,%esp
  802a2e:	ff 75 0c             	pushl  0xc(%ebp)
  802a31:	50                   	push   %eax
  802a32:	ff d2                	call   *%edx
  802a34:	83 c4 10             	add    $0x10,%esp
}
  802a37:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802a3a:	c9                   	leave  
  802a3b:	c3                   	ret    
			thisenv->env_id, fdnum);
  802a3c:	a1 0c 90 80 00       	mov    0x80900c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802a41:	8b 40 48             	mov    0x48(%eax),%eax
  802a44:	83 ec 04             	sub    $0x4,%esp
  802a47:	53                   	push   %ebx
  802a48:	50                   	push   %eax
  802a49:	68 64 3c 80 00       	push   $0x803c64
  802a4e:	e8 f9 e9 ff ff       	call   80144c <cprintf>
		return -E_INVAL;
  802a53:	83 c4 10             	add    $0x10,%esp
  802a56:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a5b:	eb da                	jmp    802a37 <ftruncate+0x52>
		return -E_NOT_SUPP;
  802a5d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802a62:	eb d3                	jmp    802a37 <ftruncate+0x52>

00802a64 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802a64:	55                   	push   %ebp
  802a65:	89 e5                	mov    %esp,%ebp
  802a67:	53                   	push   %ebx
  802a68:	83 ec 1c             	sub    $0x1c,%esp
  802a6b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a6e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802a71:	50                   	push   %eax
  802a72:	ff 75 08             	pushl  0x8(%ebp)
  802a75:	e8 89 fb ff ff       	call   802603 <fd_lookup>
  802a7a:	83 c4 10             	add    $0x10,%esp
  802a7d:	85 c0                	test   %eax,%eax
  802a7f:	78 4b                	js     802acc <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a81:	83 ec 08             	sub    $0x8,%esp
  802a84:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a87:	50                   	push   %eax
  802a88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8b:	ff 30                	pushl  (%eax)
  802a8d:	e8 c1 fb ff ff       	call   802653 <dev_lookup>
  802a92:	83 c4 10             	add    $0x10,%esp
  802a95:	85 c0                	test   %eax,%eax
  802a97:	78 33                	js     802acc <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  802a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9c:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  802aa0:	74 2f                	je     802ad1 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  802aa2:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  802aa5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  802aac:	00 00 00 
	stat->st_isdir = 0;
  802aaf:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802ab6:	00 00 00 
	stat->st_dev = dev;
  802ab9:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802abf:	83 ec 08             	sub    $0x8,%esp
  802ac2:	53                   	push   %ebx
  802ac3:	ff 75 f0             	pushl  -0x10(%ebp)
  802ac6:	ff 50 14             	call   *0x14(%eax)
  802ac9:	83 c4 10             	add    $0x10,%esp
}
  802acc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802acf:	c9                   	leave  
  802ad0:	c3                   	ret    
		return -E_NOT_SUPP;
  802ad1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802ad6:	eb f4                	jmp    802acc <fstat+0x68>

00802ad8 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802ad8:	55                   	push   %ebp
  802ad9:	89 e5                	mov    %esp,%ebp
  802adb:	56                   	push   %esi
  802adc:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802add:	83 ec 08             	sub    $0x8,%esp
  802ae0:	6a 00                	push   $0x0
  802ae2:	ff 75 08             	pushl  0x8(%ebp)
  802ae5:	e8 c0 f9 ff ff       	call   8024aa <open>
  802aea:	89 c3                	mov    %eax,%ebx
  802aec:	83 c4 10             	add    $0x10,%esp
  802aef:	85 c0                	test   %eax,%eax
  802af1:	78 1b                	js     802b0e <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  802af3:	83 ec 08             	sub    $0x8,%esp
  802af6:	ff 75 0c             	pushl  0xc(%ebp)
  802af9:	50                   	push   %eax
  802afa:	e8 65 ff ff ff       	call   802a64 <fstat>
  802aff:	89 c6                	mov    %eax,%esi
	close(fd);
  802b01:	89 1c 24             	mov    %ebx,(%esp)
  802b04:	e8 27 fc ff ff       	call   802730 <close>
	return r;
  802b09:	83 c4 10             	add    $0x10,%esp
  802b0c:	89 f3                	mov    %esi,%ebx
}
  802b0e:	89 d8                	mov    %ebx,%eax
  802b10:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802b13:	5b                   	pop    %ebx
  802b14:	5e                   	pop    %esi
  802b15:	5d                   	pop    %ebp
  802b16:	c3                   	ret    

00802b17 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802b17:	55                   	push   %ebp
  802b18:	89 e5                	mov    %esp,%ebp
  802b1a:	56                   	push   %esi
  802b1b:	53                   	push   %ebx
  802b1c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802b1f:	83 ec 0c             	sub    $0xc,%esp
  802b22:	ff 75 08             	pushl  0x8(%ebp)
  802b25:	e8 70 fa ff ff       	call   80259a <fd2data>
  802b2a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802b2c:	83 c4 08             	add    $0x8,%esp
  802b2f:	68 d4 3c 80 00       	push   $0x803cd4
  802b34:	53                   	push   %ebx
  802b35:	e8 38 f0 ff ff       	call   801b72 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802b3a:	8b 46 04             	mov    0x4(%esi),%eax
  802b3d:	2b 06                	sub    (%esi),%eax
  802b3f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802b45:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802b4c:	00 00 00 
	stat->st_dev = &devpipe;
  802b4f:	c7 83 88 00 00 00 80 	movl   $0x808080,0x88(%ebx)
  802b56:	80 80 00 
	return 0;
}
  802b59:	b8 00 00 00 00       	mov    $0x0,%eax
  802b5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802b61:	5b                   	pop    %ebx
  802b62:	5e                   	pop    %esi
  802b63:	5d                   	pop    %ebp
  802b64:	c3                   	ret    

00802b65 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802b65:	55                   	push   %ebp
  802b66:	89 e5                	mov    %esp,%ebp
  802b68:	53                   	push   %ebx
  802b69:	83 ec 0c             	sub    $0xc,%esp
  802b6c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802b6f:	53                   	push   %ebx
  802b70:	6a 00                	push   $0x0
  802b72:	e8 72 f4 ff ff       	call   801fe9 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802b77:	89 1c 24             	mov    %ebx,(%esp)
  802b7a:	e8 1b fa ff ff       	call   80259a <fd2data>
  802b7f:	83 c4 08             	add    $0x8,%esp
  802b82:	50                   	push   %eax
  802b83:	6a 00                	push   $0x0
  802b85:	e8 5f f4 ff ff       	call   801fe9 <sys_page_unmap>
}
  802b8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b8d:	c9                   	leave  
  802b8e:	c3                   	ret    

00802b8f <_pipeisclosed>:
{
  802b8f:	55                   	push   %ebp
  802b90:	89 e5                	mov    %esp,%ebp
  802b92:	57                   	push   %edi
  802b93:	56                   	push   %esi
  802b94:	53                   	push   %ebx
  802b95:	83 ec 1c             	sub    $0x1c,%esp
  802b98:	89 c7                	mov    %eax,%edi
  802b9a:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802b9c:	a1 0c 90 80 00       	mov    0x80900c,%eax
  802ba1:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802ba4:	83 ec 0c             	sub    $0xc,%esp
  802ba7:	57                   	push   %edi
  802ba8:	e8 a2 f9 ff ff       	call   80254f <pageref>
  802bad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802bb0:	89 34 24             	mov    %esi,(%esp)
  802bb3:	e8 97 f9 ff ff       	call   80254f <pageref>
		nn = thisenv->env_runs;
  802bb8:	8b 15 0c 90 80 00    	mov    0x80900c,%edx
  802bbe:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802bc1:	83 c4 10             	add    $0x10,%esp
  802bc4:	39 cb                	cmp    %ecx,%ebx
  802bc6:	74 1b                	je     802be3 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802bc8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802bcb:	75 cf                	jne    802b9c <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802bcd:	8b 42 58             	mov    0x58(%edx),%eax
  802bd0:	6a 01                	push   $0x1
  802bd2:	50                   	push   %eax
  802bd3:	53                   	push   %ebx
  802bd4:	68 db 3c 80 00       	push   $0x803cdb
  802bd9:	e8 6e e8 ff ff       	call   80144c <cprintf>
  802bde:	83 c4 10             	add    $0x10,%esp
  802be1:	eb b9                	jmp    802b9c <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802be3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802be6:	0f 94 c0             	sete   %al
  802be9:	0f b6 c0             	movzbl %al,%eax
}
  802bec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802bef:	5b                   	pop    %ebx
  802bf0:	5e                   	pop    %esi
  802bf1:	5f                   	pop    %edi
  802bf2:	5d                   	pop    %ebp
  802bf3:	c3                   	ret    

00802bf4 <devpipe_write>:
{
  802bf4:	55                   	push   %ebp
  802bf5:	89 e5                	mov    %esp,%ebp
  802bf7:	57                   	push   %edi
  802bf8:	56                   	push   %esi
  802bf9:	53                   	push   %ebx
  802bfa:	83 ec 28             	sub    $0x28,%esp
  802bfd:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802c00:	56                   	push   %esi
  802c01:	e8 94 f9 ff ff       	call   80259a <fd2data>
  802c06:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802c08:	83 c4 10             	add    $0x10,%esp
  802c0b:	bf 00 00 00 00       	mov    $0x0,%edi
  802c10:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802c13:	74 4f                	je     802c64 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802c15:	8b 43 04             	mov    0x4(%ebx),%eax
  802c18:	8b 0b                	mov    (%ebx),%ecx
  802c1a:	8d 51 20             	lea    0x20(%ecx),%edx
  802c1d:	39 d0                	cmp    %edx,%eax
  802c1f:	72 14                	jb     802c35 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802c21:	89 da                	mov    %ebx,%edx
  802c23:	89 f0                	mov    %esi,%eax
  802c25:	e8 65 ff ff ff       	call   802b8f <_pipeisclosed>
  802c2a:	85 c0                	test   %eax,%eax
  802c2c:	75 3b                	jne    802c69 <devpipe_write+0x75>
			sys_yield();
  802c2e:	e8 12 f3 ff ff       	call   801f45 <sys_yield>
  802c33:	eb e0                	jmp    802c15 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802c35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802c38:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802c3c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802c3f:	89 c2                	mov    %eax,%edx
  802c41:	c1 fa 1f             	sar    $0x1f,%edx
  802c44:	89 d1                	mov    %edx,%ecx
  802c46:	c1 e9 1b             	shr    $0x1b,%ecx
  802c49:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802c4c:	83 e2 1f             	and    $0x1f,%edx
  802c4f:	29 ca                	sub    %ecx,%edx
  802c51:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802c55:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802c59:	83 c0 01             	add    $0x1,%eax
  802c5c:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802c5f:	83 c7 01             	add    $0x1,%edi
  802c62:	eb ac                	jmp    802c10 <devpipe_write+0x1c>
	return i;
  802c64:	8b 45 10             	mov    0x10(%ebp),%eax
  802c67:	eb 05                	jmp    802c6e <devpipe_write+0x7a>
				return 0;
  802c69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802c71:	5b                   	pop    %ebx
  802c72:	5e                   	pop    %esi
  802c73:	5f                   	pop    %edi
  802c74:	5d                   	pop    %ebp
  802c75:	c3                   	ret    

00802c76 <devpipe_read>:
{
  802c76:	55                   	push   %ebp
  802c77:	89 e5                	mov    %esp,%ebp
  802c79:	57                   	push   %edi
  802c7a:	56                   	push   %esi
  802c7b:	53                   	push   %ebx
  802c7c:	83 ec 18             	sub    $0x18,%esp
  802c7f:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802c82:	57                   	push   %edi
  802c83:	e8 12 f9 ff ff       	call   80259a <fd2data>
  802c88:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802c8a:	83 c4 10             	add    $0x10,%esp
  802c8d:	be 00 00 00 00       	mov    $0x0,%esi
  802c92:	3b 75 10             	cmp    0x10(%ebp),%esi
  802c95:	75 14                	jne    802cab <devpipe_read+0x35>
	return i;
  802c97:	8b 45 10             	mov    0x10(%ebp),%eax
  802c9a:	eb 02                	jmp    802c9e <devpipe_read+0x28>
				return i;
  802c9c:	89 f0                	mov    %esi,%eax
}
  802c9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802ca1:	5b                   	pop    %ebx
  802ca2:	5e                   	pop    %esi
  802ca3:	5f                   	pop    %edi
  802ca4:	5d                   	pop    %ebp
  802ca5:	c3                   	ret    
			sys_yield();
  802ca6:	e8 9a f2 ff ff       	call   801f45 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802cab:	8b 03                	mov    (%ebx),%eax
  802cad:	3b 43 04             	cmp    0x4(%ebx),%eax
  802cb0:	75 18                	jne    802cca <devpipe_read+0x54>
			if (i > 0)
  802cb2:	85 f6                	test   %esi,%esi
  802cb4:	75 e6                	jne    802c9c <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802cb6:	89 da                	mov    %ebx,%edx
  802cb8:	89 f8                	mov    %edi,%eax
  802cba:	e8 d0 fe ff ff       	call   802b8f <_pipeisclosed>
  802cbf:	85 c0                	test   %eax,%eax
  802cc1:	74 e3                	je     802ca6 <devpipe_read+0x30>
				return 0;
  802cc3:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc8:	eb d4                	jmp    802c9e <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802cca:	99                   	cltd   
  802ccb:	c1 ea 1b             	shr    $0x1b,%edx
  802cce:	01 d0                	add    %edx,%eax
  802cd0:	83 e0 1f             	and    $0x1f,%eax
  802cd3:	29 d0                	sub    %edx,%eax
  802cd5:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802cda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802cdd:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802ce0:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802ce3:	83 c6 01             	add    $0x1,%esi
  802ce6:	eb aa                	jmp    802c92 <devpipe_read+0x1c>

00802ce8 <pipe>:
{
  802ce8:	55                   	push   %ebp
  802ce9:	89 e5                	mov    %esp,%ebp
  802ceb:	56                   	push   %esi
  802cec:	53                   	push   %ebx
  802ced:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802cf0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802cf3:	50                   	push   %eax
  802cf4:	e8 b8 f8 ff ff       	call   8025b1 <fd_alloc>
  802cf9:	89 c3                	mov    %eax,%ebx
  802cfb:	83 c4 10             	add    $0x10,%esp
  802cfe:	85 c0                	test   %eax,%eax
  802d00:	0f 88 23 01 00 00    	js     802e29 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d06:	83 ec 04             	sub    $0x4,%esp
  802d09:	68 07 04 00 00       	push   $0x407
  802d0e:	ff 75 f4             	pushl  -0xc(%ebp)
  802d11:	6a 00                	push   $0x0
  802d13:	e8 4c f2 ff ff       	call   801f64 <sys_page_alloc>
  802d18:	89 c3                	mov    %eax,%ebx
  802d1a:	83 c4 10             	add    $0x10,%esp
  802d1d:	85 c0                	test   %eax,%eax
  802d1f:	0f 88 04 01 00 00    	js     802e29 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802d25:	83 ec 0c             	sub    $0xc,%esp
  802d28:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802d2b:	50                   	push   %eax
  802d2c:	e8 80 f8 ff ff       	call   8025b1 <fd_alloc>
  802d31:	89 c3                	mov    %eax,%ebx
  802d33:	83 c4 10             	add    $0x10,%esp
  802d36:	85 c0                	test   %eax,%eax
  802d38:	0f 88 db 00 00 00    	js     802e19 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d3e:	83 ec 04             	sub    $0x4,%esp
  802d41:	68 07 04 00 00       	push   $0x407
  802d46:	ff 75 f0             	pushl  -0x10(%ebp)
  802d49:	6a 00                	push   $0x0
  802d4b:	e8 14 f2 ff ff       	call   801f64 <sys_page_alloc>
  802d50:	89 c3                	mov    %eax,%ebx
  802d52:	83 c4 10             	add    $0x10,%esp
  802d55:	85 c0                	test   %eax,%eax
  802d57:	0f 88 bc 00 00 00    	js     802e19 <pipe+0x131>
	va = fd2data(fd0);
  802d5d:	83 ec 0c             	sub    $0xc,%esp
  802d60:	ff 75 f4             	pushl  -0xc(%ebp)
  802d63:	e8 32 f8 ff ff       	call   80259a <fd2data>
  802d68:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d6a:	83 c4 0c             	add    $0xc,%esp
  802d6d:	68 07 04 00 00       	push   $0x407
  802d72:	50                   	push   %eax
  802d73:	6a 00                	push   $0x0
  802d75:	e8 ea f1 ff ff       	call   801f64 <sys_page_alloc>
  802d7a:	89 c3                	mov    %eax,%ebx
  802d7c:	83 c4 10             	add    $0x10,%esp
  802d7f:	85 c0                	test   %eax,%eax
  802d81:	0f 88 82 00 00 00    	js     802e09 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d87:	83 ec 0c             	sub    $0xc,%esp
  802d8a:	ff 75 f0             	pushl  -0x10(%ebp)
  802d8d:	e8 08 f8 ff ff       	call   80259a <fd2data>
  802d92:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802d99:	50                   	push   %eax
  802d9a:	6a 00                	push   $0x0
  802d9c:	56                   	push   %esi
  802d9d:	6a 00                	push   $0x0
  802d9f:	e8 03 f2 ff ff       	call   801fa7 <sys_page_map>
  802da4:	89 c3                	mov    %eax,%ebx
  802da6:	83 c4 20             	add    $0x20,%esp
  802da9:	85 c0                	test   %eax,%eax
  802dab:	78 4e                	js     802dfb <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802dad:	a1 80 80 80 00       	mov    0x808080,%eax
  802db2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802db5:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802db7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dba:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802dc1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dc4:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802dc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc9:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802dd0:	83 ec 0c             	sub    $0xc,%esp
  802dd3:	ff 75 f4             	pushl  -0xc(%ebp)
  802dd6:	e8 af f7 ff ff       	call   80258a <fd2num>
  802ddb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802dde:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802de0:	83 c4 04             	add    $0x4,%esp
  802de3:	ff 75 f0             	pushl  -0x10(%ebp)
  802de6:	e8 9f f7 ff ff       	call   80258a <fd2num>
  802deb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802dee:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802df1:	83 c4 10             	add    $0x10,%esp
  802df4:	bb 00 00 00 00       	mov    $0x0,%ebx
  802df9:	eb 2e                	jmp    802e29 <pipe+0x141>
	sys_page_unmap(0, va);
  802dfb:	83 ec 08             	sub    $0x8,%esp
  802dfe:	56                   	push   %esi
  802dff:	6a 00                	push   $0x0
  802e01:	e8 e3 f1 ff ff       	call   801fe9 <sys_page_unmap>
  802e06:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802e09:	83 ec 08             	sub    $0x8,%esp
  802e0c:	ff 75 f0             	pushl  -0x10(%ebp)
  802e0f:	6a 00                	push   $0x0
  802e11:	e8 d3 f1 ff ff       	call   801fe9 <sys_page_unmap>
  802e16:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802e19:	83 ec 08             	sub    $0x8,%esp
  802e1c:	ff 75 f4             	pushl  -0xc(%ebp)
  802e1f:	6a 00                	push   $0x0
  802e21:	e8 c3 f1 ff ff       	call   801fe9 <sys_page_unmap>
  802e26:	83 c4 10             	add    $0x10,%esp
}
  802e29:	89 d8                	mov    %ebx,%eax
  802e2b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802e2e:	5b                   	pop    %ebx
  802e2f:	5e                   	pop    %esi
  802e30:	5d                   	pop    %ebp
  802e31:	c3                   	ret    

00802e32 <pipeisclosed>:
{
  802e32:	55                   	push   %ebp
  802e33:	89 e5                	mov    %esp,%ebp
  802e35:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802e38:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e3b:	50                   	push   %eax
  802e3c:	ff 75 08             	pushl  0x8(%ebp)
  802e3f:	e8 bf f7 ff ff       	call   802603 <fd_lookup>
  802e44:	83 c4 10             	add    $0x10,%esp
  802e47:	85 c0                	test   %eax,%eax
  802e49:	78 18                	js     802e63 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802e4b:	83 ec 0c             	sub    $0xc,%esp
  802e4e:	ff 75 f4             	pushl  -0xc(%ebp)
  802e51:	e8 44 f7 ff ff       	call   80259a <fd2data>
	return _pipeisclosed(fd, p);
  802e56:	89 c2                	mov    %eax,%edx
  802e58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5b:	e8 2f fd ff ff       	call   802b8f <_pipeisclosed>
  802e60:	83 c4 10             	add    $0x10,%esp
}
  802e63:	c9                   	leave  
  802e64:	c3                   	ret    

00802e65 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802e65:	b8 00 00 00 00       	mov    $0x0,%eax
  802e6a:	c3                   	ret    

00802e6b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802e6b:	55                   	push   %ebp
  802e6c:	89 e5                	mov    %esp,%ebp
  802e6e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802e71:	68 f3 3c 80 00       	push   $0x803cf3
  802e76:	ff 75 0c             	pushl  0xc(%ebp)
  802e79:	e8 f4 ec ff ff       	call   801b72 <strcpy>
	return 0;
}
  802e7e:	b8 00 00 00 00       	mov    $0x0,%eax
  802e83:	c9                   	leave  
  802e84:	c3                   	ret    

00802e85 <devcons_write>:
{
  802e85:	55                   	push   %ebp
  802e86:	89 e5                	mov    %esp,%ebp
  802e88:	57                   	push   %edi
  802e89:	56                   	push   %esi
  802e8a:	53                   	push   %ebx
  802e8b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802e91:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802e96:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802e9c:	3b 75 10             	cmp    0x10(%ebp),%esi
  802e9f:	73 31                	jae    802ed2 <devcons_write+0x4d>
		m = n - tot;
  802ea1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802ea4:	29 f3                	sub    %esi,%ebx
  802ea6:	83 fb 7f             	cmp    $0x7f,%ebx
  802ea9:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802eae:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802eb1:	83 ec 04             	sub    $0x4,%esp
  802eb4:	53                   	push   %ebx
  802eb5:	89 f0                	mov    %esi,%eax
  802eb7:	03 45 0c             	add    0xc(%ebp),%eax
  802eba:	50                   	push   %eax
  802ebb:	57                   	push   %edi
  802ebc:	e8 3f ee ff ff       	call   801d00 <memmove>
		sys_cputs(buf, m);
  802ec1:	83 c4 08             	add    $0x8,%esp
  802ec4:	53                   	push   %ebx
  802ec5:	57                   	push   %edi
  802ec6:	e8 dd ef ff ff       	call   801ea8 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802ecb:	01 de                	add    %ebx,%esi
  802ecd:	83 c4 10             	add    $0x10,%esp
  802ed0:	eb ca                	jmp    802e9c <devcons_write+0x17>
}
  802ed2:	89 f0                	mov    %esi,%eax
  802ed4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802ed7:	5b                   	pop    %ebx
  802ed8:	5e                   	pop    %esi
  802ed9:	5f                   	pop    %edi
  802eda:	5d                   	pop    %ebp
  802edb:	c3                   	ret    

00802edc <devcons_read>:
{
  802edc:	55                   	push   %ebp
  802edd:	89 e5                	mov    %esp,%ebp
  802edf:	83 ec 08             	sub    $0x8,%esp
  802ee2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802ee7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802eeb:	74 21                	je     802f0e <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802eed:	e8 d4 ef ff ff       	call   801ec6 <sys_cgetc>
  802ef2:	85 c0                	test   %eax,%eax
  802ef4:	75 07                	jne    802efd <devcons_read+0x21>
		sys_yield();
  802ef6:	e8 4a f0 ff ff       	call   801f45 <sys_yield>
  802efb:	eb f0                	jmp    802eed <devcons_read+0x11>
	if (c < 0)
  802efd:	78 0f                	js     802f0e <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802eff:	83 f8 04             	cmp    $0x4,%eax
  802f02:	74 0c                	je     802f10 <devcons_read+0x34>
	*(char*)vbuf = c;
  802f04:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f07:	88 02                	mov    %al,(%edx)
	return 1;
  802f09:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802f0e:	c9                   	leave  
  802f0f:	c3                   	ret    
		return 0;
  802f10:	b8 00 00 00 00       	mov    $0x0,%eax
  802f15:	eb f7                	jmp    802f0e <devcons_read+0x32>

00802f17 <cputchar>:
{
  802f17:	55                   	push   %ebp
  802f18:	89 e5                	mov    %esp,%ebp
  802f1a:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f20:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802f23:	6a 01                	push   $0x1
  802f25:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802f28:	50                   	push   %eax
  802f29:	e8 7a ef ff ff       	call   801ea8 <sys_cputs>
}
  802f2e:	83 c4 10             	add    $0x10,%esp
  802f31:	c9                   	leave  
  802f32:	c3                   	ret    

00802f33 <getchar>:
{
  802f33:	55                   	push   %ebp
  802f34:	89 e5                	mov    %esp,%ebp
  802f36:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802f39:	6a 01                	push   $0x1
  802f3b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802f3e:	50                   	push   %eax
  802f3f:	6a 00                	push   $0x0
  802f41:	e8 28 f9 ff ff       	call   80286e <read>
	if (r < 0)
  802f46:	83 c4 10             	add    $0x10,%esp
  802f49:	85 c0                	test   %eax,%eax
  802f4b:	78 06                	js     802f53 <getchar+0x20>
	if (r < 1)
  802f4d:	74 06                	je     802f55 <getchar+0x22>
	return c;
  802f4f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802f53:	c9                   	leave  
  802f54:	c3                   	ret    
		return -E_EOF;
  802f55:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802f5a:	eb f7                	jmp    802f53 <getchar+0x20>

00802f5c <iscons>:
{
  802f5c:	55                   	push   %ebp
  802f5d:	89 e5                	mov    %esp,%ebp
  802f5f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f62:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f65:	50                   	push   %eax
  802f66:	ff 75 08             	pushl  0x8(%ebp)
  802f69:	e8 95 f6 ff ff       	call   802603 <fd_lookup>
  802f6e:	83 c4 10             	add    $0x10,%esp
  802f71:	85 c0                	test   %eax,%eax
  802f73:	78 11                	js     802f86 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f78:	8b 15 9c 80 80 00    	mov    0x80809c,%edx
  802f7e:	39 10                	cmp    %edx,(%eax)
  802f80:	0f 94 c0             	sete   %al
  802f83:	0f b6 c0             	movzbl %al,%eax
}
  802f86:	c9                   	leave  
  802f87:	c3                   	ret    

00802f88 <opencons>:
{
  802f88:	55                   	push   %ebp
  802f89:	89 e5                	mov    %esp,%ebp
  802f8b:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802f8e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f91:	50                   	push   %eax
  802f92:	e8 1a f6 ff ff       	call   8025b1 <fd_alloc>
  802f97:	83 c4 10             	add    $0x10,%esp
  802f9a:	85 c0                	test   %eax,%eax
  802f9c:	78 3a                	js     802fd8 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802f9e:	83 ec 04             	sub    $0x4,%esp
  802fa1:	68 07 04 00 00       	push   $0x407
  802fa6:	ff 75 f4             	pushl  -0xc(%ebp)
  802fa9:	6a 00                	push   $0x0
  802fab:	e8 b4 ef ff ff       	call   801f64 <sys_page_alloc>
  802fb0:	83 c4 10             	add    $0x10,%esp
  802fb3:	85 c0                	test   %eax,%eax
  802fb5:	78 21                	js     802fd8 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fba:	8b 15 9c 80 80 00    	mov    0x80809c,%edx
  802fc0:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802fcc:	83 ec 0c             	sub    $0xc,%esp
  802fcf:	50                   	push   %eax
  802fd0:	e8 b5 f5 ff ff       	call   80258a <fd2num>
  802fd5:	83 c4 10             	add    $0x10,%esp
}
  802fd8:	c9                   	leave  
  802fd9:	c3                   	ret    
  802fda:	66 90                	xchg   %ax,%ax
  802fdc:	66 90                	xchg   %ax,%ax
  802fde:	66 90                	xchg   %ax,%ax

00802fe0 <__udivdi3>:
  802fe0:	55                   	push   %ebp
  802fe1:	57                   	push   %edi
  802fe2:	56                   	push   %esi
  802fe3:	53                   	push   %ebx
  802fe4:	83 ec 1c             	sub    $0x1c,%esp
  802fe7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802feb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802fef:	8b 74 24 34          	mov    0x34(%esp),%esi
  802ff3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802ff7:	85 d2                	test   %edx,%edx
  802ff9:	75 4d                	jne    803048 <__udivdi3+0x68>
  802ffb:	39 f3                	cmp    %esi,%ebx
  802ffd:	76 19                	jbe    803018 <__udivdi3+0x38>
  802fff:	31 ff                	xor    %edi,%edi
  803001:	89 e8                	mov    %ebp,%eax
  803003:	89 f2                	mov    %esi,%edx
  803005:	f7 f3                	div    %ebx
  803007:	89 fa                	mov    %edi,%edx
  803009:	83 c4 1c             	add    $0x1c,%esp
  80300c:	5b                   	pop    %ebx
  80300d:	5e                   	pop    %esi
  80300e:	5f                   	pop    %edi
  80300f:	5d                   	pop    %ebp
  803010:	c3                   	ret    
  803011:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803018:	89 d9                	mov    %ebx,%ecx
  80301a:	85 db                	test   %ebx,%ebx
  80301c:	75 0b                	jne    803029 <__udivdi3+0x49>
  80301e:	b8 01 00 00 00       	mov    $0x1,%eax
  803023:	31 d2                	xor    %edx,%edx
  803025:	f7 f3                	div    %ebx
  803027:	89 c1                	mov    %eax,%ecx
  803029:	31 d2                	xor    %edx,%edx
  80302b:	89 f0                	mov    %esi,%eax
  80302d:	f7 f1                	div    %ecx
  80302f:	89 c6                	mov    %eax,%esi
  803031:	89 e8                	mov    %ebp,%eax
  803033:	89 f7                	mov    %esi,%edi
  803035:	f7 f1                	div    %ecx
  803037:	89 fa                	mov    %edi,%edx
  803039:	83 c4 1c             	add    $0x1c,%esp
  80303c:	5b                   	pop    %ebx
  80303d:	5e                   	pop    %esi
  80303e:	5f                   	pop    %edi
  80303f:	5d                   	pop    %ebp
  803040:	c3                   	ret    
  803041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803048:	39 f2                	cmp    %esi,%edx
  80304a:	77 1c                	ja     803068 <__udivdi3+0x88>
  80304c:	0f bd fa             	bsr    %edx,%edi
  80304f:	83 f7 1f             	xor    $0x1f,%edi
  803052:	75 2c                	jne    803080 <__udivdi3+0xa0>
  803054:	39 f2                	cmp    %esi,%edx
  803056:	72 06                	jb     80305e <__udivdi3+0x7e>
  803058:	31 c0                	xor    %eax,%eax
  80305a:	39 eb                	cmp    %ebp,%ebx
  80305c:	77 a9                	ja     803007 <__udivdi3+0x27>
  80305e:	b8 01 00 00 00       	mov    $0x1,%eax
  803063:	eb a2                	jmp    803007 <__udivdi3+0x27>
  803065:	8d 76 00             	lea    0x0(%esi),%esi
  803068:	31 ff                	xor    %edi,%edi
  80306a:	31 c0                	xor    %eax,%eax
  80306c:	89 fa                	mov    %edi,%edx
  80306e:	83 c4 1c             	add    $0x1c,%esp
  803071:	5b                   	pop    %ebx
  803072:	5e                   	pop    %esi
  803073:	5f                   	pop    %edi
  803074:	5d                   	pop    %ebp
  803075:	c3                   	ret    
  803076:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80307d:	8d 76 00             	lea    0x0(%esi),%esi
  803080:	89 f9                	mov    %edi,%ecx
  803082:	b8 20 00 00 00       	mov    $0x20,%eax
  803087:	29 f8                	sub    %edi,%eax
  803089:	d3 e2                	shl    %cl,%edx
  80308b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80308f:	89 c1                	mov    %eax,%ecx
  803091:	89 da                	mov    %ebx,%edx
  803093:	d3 ea                	shr    %cl,%edx
  803095:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803099:	09 d1                	or     %edx,%ecx
  80309b:	89 f2                	mov    %esi,%edx
  80309d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8030a1:	89 f9                	mov    %edi,%ecx
  8030a3:	d3 e3                	shl    %cl,%ebx
  8030a5:	89 c1                	mov    %eax,%ecx
  8030a7:	d3 ea                	shr    %cl,%edx
  8030a9:	89 f9                	mov    %edi,%ecx
  8030ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8030af:	89 eb                	mov    %ebp,%ebx
  8030b1:	d3 e6                	shl    %cl,%esi
  8030b3:	89 c1                	mov    %eax,%ecx
  8030b5:	d3 eb                	shr    %cl,%ebx
  8030b7:	09 de                	or     %ebx,%esi
  8030b9:	89 f0                	mov    %esi,%eax
  8030bb:	f7 74 24 08          	divl   0x8(%esp)
  8030bf:	89 d6                	mov    %edx,%esi
  8030c1:	89 c3                	mov    %eax,%ebx
  8030c3:	f7 64 24 0c          	mull   0xc(%esp)
  8030c7:	39 d6                	cmp    %edx,%esi
  8030c9:	72 15                	jb     8030e0 <__udivdi3+0x100>
  8030cb:	89 f9                	mov    %edi,%ecx
  8030cd:	d3 e5                	shl    %cl,%ebp
  8030cf:	39 c5                	cmp    %eax,%ebp
  8030d1:	73 04                	jae    8030d7 <__udivdi3+0xf7>
  8030d3:	39 d6                	cmp    %edx,%esi
  8030d5:	74 09                	je     8030e0 <__udivdi3+0x100>
  8030d7:	89 d8                	mov    %ebx,%eax
  8030d9:	31 ff                	xor    %edi,%edi
  8030db:	e9 27 ff ff ff       	jmp    803007 <__udivdi3+0x27>
  8030e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8030e3:	31 ff                	xor    %edi,%edi
  8030e5:	e9 1d ff ff ff       	jmp    803007 <__udivdi3+0x27>
  8030ea:	66 90                	xchg   %ax,%ax
  8030ec:	66 90                	xchg   %ax,%ax
  8030ee:	66 90                	xchg   %ax,%ax

008030f0 <__umoddi3>:
  8030f0:	55                   	push   %ebp
  8030f1:	57                   	push   %edi
  8030f2:	56                   	push   %esi
  8030f3:	53                   	push   %ebx
  8030f4:	83 ec 1c             	sub    $0x1c,%esp
  8030f7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8030fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8030ff:	8b 74 24 30          	mov    0x30(%esp),%esi
  803103:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803107:	89 da                	mov    %ebx,%edx
  803109:	85 c0                	test   %eax,%eax
  80310b:	75 43                	jne    803150 <__umoddi3+0x60>
  80310d:	39 df                	cmp    %ebx,%edi
  80310f:	76 17                	jbe    803128 <__umoddi3+0x38>
  803111:	89 f0                	mov    %esi,%eax
  803113:	f7 f7                	div    %edi
  803115:	89 d0                	mov    %edx,%eax
  803117:	31 d2                	xor    %edx,%edx
  803119:	83 c4 1c             	add    $0x1c,%esp
  80311c:	5b                   	pop    %ebx
  80311d:	5e                   	pop    %esi
  80311e:	5f                   	pop    %edi
  80311f:	5d                   	pop    %ebp
  803120:	c3                   	ret    
  803121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803128:	89 fd                	mov    %edi,%ebp
  80312a:	85 ff                	test   %edi,%edi
  80312c:	75 0b                	jne    803139 <__umoddi3+0x49>
  80312e:	b8 01 00 00 00       	mov    $0x1,%eax
  803133:	31 d2                	xor    %edx,%edx
  803135:	f7 f7                	div    %edi
  803137:	89 c5                	mov    %eax,%ebp
  803139:	89 d8                	mov    %ebx,%eax
  80313b:	31 d2                	xor    %edx,%edx
  80313d:	f7 f5                	div    %ebp
  80313f:	89 f0                	mov    %esi,%eax
  803141:	f7 f5                	div    %ebp
  803143:	89 d0                	mov    %edx,%eax
  803145:	eb d0                	jmp    803117 <__umoddi3+0x27>
  803147:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80314e:	66 90                	xchg   %ax,%ax
  803150:	89 f1                	mov    %esi,%ecx
  803152:	39 d8                	cmp    %ebx,%eax
  803154:	76 0a                	jbe    803160 <__umoddi3+0x70>
  803156:	89 f0                	mov    %esi,%eax
  803158:	83 c4 1c             	add    $0x1c,%esp
  80315b:	5b                   	pop    %ebx
  80315c:	5e                   	pop    %esi
  80315d:	5f                   	pop    %edi
  80315e:	5d                   	pop    %ebp
  80315f:	c3                   	ret    
  803160:	0f bd e8             	bsr    %eax,%ebp
  803163:	83 f5 1f             	xor    $0x1f,%ebp
  803166:	75 20                	jne    803188 <__umoddi3+0x98>
  803168:	39 d8                	cmp    %ebx,%eax
  80316a:	0f 82 b0 00 00 00    	jb     803220 <__umoddi3+0x130>
  803170:	39 f7                	cmp    %esi,%edi
  803172:	0f 86 a8 00 00 00    	jbe    803220 <__umoddi3+0x130>
  803178:	89 c8                	mov    %ecx,%eax
  80317a:	83 c4 1c             	add    $0x1c,%esp
  80317d:	5b                   	pop    %ebx
  80317e:	5e                   	pop    %esi
  80317f:	5f                   	pop    %edi
  803180:	5d                   	pop    %ebp
  803181:	c3                   	ret    
  803182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803188:	89 e9                	mov    %ebp,%ecx
  80318a:	ba 20 00 00 00       	mov    $0x20,%edx
  80318f:	29 ea                	sub    %ebp,%edx
  803191:	d3 e0                	shl    %cl,%eax
  803193:	89 44 24 08          	mov    %eax,0x8(%esp)
  803197:	89 d1                	mov    %edx,%ecx
  803199:	89 f8                	mov    %edi,%eax
  80319b:	d3 e8                	shr    %cl,%eax
  80319d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8031a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8031a5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8031a9:	09 c1                	or     %eax,%ecx
  8031ab:	89 d8                	mov    %ebx,%eax
  8031ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8031b1:	89 e9                	mov    %ebp,%ecx
  8031b3:	d3 e7                	shl    %cl,%edi
  8031b5:	89 d1                	mov    %edx,%ecx
  8031b7:	d3 e8                	shr    %cl,%eax
  8031b9:	89 e9                	mov    %ebp,%ecx
  8031bb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8031bf:	d3 e3                	shl    %cl,%ebx
  8031c1:	89 c7                	mov    %eax,%edi
  8031c3:	89 d1                	mov    %edx,%ecx
  8031c5:	89 f0                	mov    %esi,%eax
  8031c7:	d3 e8                	shr    %cl,%eax
  8031c9:	89 e9                	mov    %ebp,%ecx
  8031cb:	89 fa                	mov    %edi,%edx
  8031cd:	d3 e6                	shl    %cl,%esi
  8031cf:	09 d8                	or     %ebx,%eax
  8031d1:	f7 74 24 08          	divl   0x8(%esp)
  8031d5:	89 d1                	mov    %edx,%ecx
  8031d7:	89 f3                	mov    %esi,%ebx
  8031d9:	f7 64 24 0c          	mull   0xc(%esp)
  8031dd:	89 c6                	mov    %eax,%esi
  8031df:	89 d7                	mov    %edx,%edi
  8031e1:	39 d1                	cmp    %edx,%ecx
  8031e3:	72 06                	jb     8031eb <__umoddi3+0xfb>
  8031e5:	75 10                	jne    8031f7 <__umoddi3+0x107>
  8031e7:	39 c3                	cmp    %eax,%ebx
  8031e9:	73 0c                	jae    8031f7 <__umoddi3+0x107>
  8031eb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8031ef:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8031f3:	89 d7                	mov    %edx,%edi
  8031f5:	89 c6                	mov    %eax,%esi
  8031f7:	89 ca                	mov    %ecx,%edx
  8031f9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8031fe:	29 f3                	sub    %esi,%ebx
  803200:	19 fa                	sbb    %edi,%edx
  803202:	89 d0                	mov    %edx,%eax
  803204:	d3 e0                	shl    %cl,%eax
  803206:	89 e9                	mov    %ebp,%ecx
  803208:	d3 eb                	shr    %cl,%ebx
  80320a:	d3 ea                	shr    %cl,%edx
  80320c:	09 d8                	or     %ebx,%eax
  80320e:	83 c4 1c             	add    $0x1c,%esp
  803211:	5b                   	pop    %ebx
  803212:	5e                   	pop    %esi
  803213:	5f                   	pop    %edi
  803214:	5d                   	pop    %ebp
  803215:	c3                   	ret    
  803216:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80321d:	8d 76 00             	lea    0x0(%esi),%esi
  803220:	89 da                	mov    %ebx,%edx
  803222:	29 fe                	sub    %edi,%esi
  803224:	19 c2                	sbb    %eax,%edx
  803226:	89 f1                	mov    %esi,%ecx
  803228:	89 c8                	mov    %ecx,%eax
  80322a:	e9 4b ff ff ff       	jmp    80317a <__umoddi3+0x8a>
