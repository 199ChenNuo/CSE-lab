
obj/user/dumbfork.debug:     file format elf32-i386


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
  80002c:	e8 1e 02 00 00       	call   80024f <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <duppage>:
	}
}

void
duppage(envid_t dstenv, void *addr)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 75 08             	mov    0x8(%ebp),%esi
  80003b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	cprintf("duppage() 29\n");
  80003e:	83 ec 0c             	sub    $0xc,%esp
  800041:	68 20 13 80 00       	push   $0x801320
  800046:	e8 3a 03 00 00       	call   800385 <cprintf>
	// This is NOT what you should do in your fork.
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  80004b:	83 c4 0c             	add    $0xc,%esp
  80004e:	6a 07                	push   $0x7
  800050:	53                   	push   %ebx
  800051:	56                   	push   %esi
  800052:	e8 46 0e 00 00       	call   800e9d <sys_page_alloc>
  800057:	83 c4 10             	add    $0x10,%esp
  80005a:	85 c0                	test   %eax,%eax
  80005c:	78 4a                	js     8000a8 <duppage+0x75>
		panic("sys_page_alloc: %e", r);
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80005e:	83 ec 0c             	sub    $0xc,%esp
  800061:	6a 07                	push   $0x7
  800063:	68 00 00 40 00       	push   $0x400000
  800068:	6a 00                	push   $0x0
  80006a:	53                   	push   %ebx
  80006b:	56                   	push   %esi
  80006c:	e8 6f 0e 00 00       	call   800ee0 <sys_page_map>
  800071:	83 c4 20             	add    $0x20,%esp
  800074:	85 c0                	test   %eax,%eax
  800076:	78 42                	js     8000ba <duppage+0x87>
		panic("sys_page_map: %e", r);
	memmove(UTEMP, addr, PGSIZE);
  800078:	83 ec 04             	sub    $0x4,%esp
  80007b:	68 00 10 00 00       	push   $0x1000
  800080:	53                   	push   %ebx
  800081:	68 00 00 40 00       	push   $0x400000
  800086:	e8 ae 0b 00 00       	call   800c39 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80008b:	83 c4 08             	add    $0x8,%esp
  80008e:	68 00 00 40 00       	push   $0x400000
  800093:	6a 00                	push   $0x0
  800095:	e8 88 0e 00 00       	call   800f22 <sys_page_unmap>
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	85 c0                	test   %eax,%eax
  80009f:	78 2b                	js     8000cc <duppage+0x99>
		panic("sys_page_unmap: %e", r);
}
  8000a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000a4:	5b                   	pop    %ebx
  8000a5:	5e                   	pop    %esi
  8000a6:	5d                   	pop    %ebp
  8000a7:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  8000a8:	50                   	push   %eax
  8000a9:	68 2e 13 80 00       	push   $0x80132e
  8000ae:	6a 20                	push   $0x20
  8000b0:	68 41 13 80 00       	push   $0x801341
  8000b5:	e8 f0 01 00 00       	call   8002aa <_panic>
		panic("sys_page_map: %e", r);
  8000ba:	50                   	push   %eax
  8000bb:	68 51 13 80 00       	push   $0x801351
  8000c0:	6a 22                	push   $0x22
  8000c2:	68 41 13 80 00       	push   $0x801341
  8000c7:	e8 de 01 00 00       	call   8002aa <_panic>
		panic("sys_page_unmap: %e", r);
  8000cc:	50                   	push   %eax
  8000cd:	68 62 13 80 00       	push   $0x801362
  8000d2:	6a 25                	push   $0x25
  8000d4:	68 41 13 80 00       	push   $0x801341
  8000d9:	e8 cc 01 00 00       	call   8002aa <_panic>

008000de <dumbfork>:

envid_t
dumbfork(void)
{
  8000de:	55                   	push   %ebp
  8000df:	89 e5                	mov    %esp,%ebp
  8000e1:	56                   	push   %esi
  8000e2:	53                   	push   %ebx
  8000e3:	83 ec 1c             	sub    $0x1c,%esp
	envid_t envid;
	uint8_t *addr;
	int r;
	extern unsigned char end[];
	cprintf("before sys_exofork()\n");
  8000e6:	68 75 13 80 00       	push   $0x801375
  8000eb:	e8 95 02 00 00       	call   800385 <cprintf>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8000f0:	b8 07 00 00 00       	mov    $0x7,%eax
  8000f5:	cd 30                	int    $0x30
  8000f7:	89 c3                	mov    %eax,%ebx
  8000f9:	89 c6                	mov    %eax,%esi
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
	cprintf("dumbfork(): envid:%d\n", envid);
  8000fb:	83 c4 08             	add    $0x8,%esp
  8000fe:	50                   	push   %eax
  8000ff:	68 8b 13 80 00       	push   $0x80138b
  800104:	e8 7c 02 00 00       	call   800385 <cprintf>
	if (envid < 0)
  800109:	83 c4 10             	add    $0x10,%esp
  80010c:	85 db                	test   %ebx,%ebx
  80010e:	78 3a                	js     80014a <dumbfork+0x6c>
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
  800110:	74 4a                	je     80015c <dumbfork+0x7e>
		return 0;
	}
	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	cprintf("parent\n");
  800112:	83 ec 0c             	sub    $0xc,%esp
  800115:	68 b8 13 80 00       	push   $0x8013b8
  80011a:	e8 66 02 00 00       	call   800385 <cprintf>
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  80011f:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  800126:	83 c4 10             	add    $0x10,%esp
  800129:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80012c:	81 fa 08 20 80 00    	cmp    $0x802008,%edx
  800132:	73 54                	jae    800188 <dumbfork+0xaa>
		duppage(envid, addr);
  800134:	83 ec 08             	sub    $0x8,%esp
  800137:	52                   	push   %edx
  800138:	56                   	push   %esi
  800139:	e8 f5 fe ff ff       	call   800033 <duppage>
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  80013e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  800145:	83 c4 10             	add    $0x10,%esp
  800148:	eb df                	jmp    800129 <dumbfork+0x4b>
		panic("sys_exofork: %e", envid);
  80014a:	53                   	push   %ebx
  80014b:	68 a1 13 80 00       	push   $0x8013a1
  800150:	6a 38                	push   $0x38
  800152:	68 41 13 80 00       	push   $0x801341
  800157:	e8 4e 01 00 00       	call   8002aa <_panic>
		cprintf("child\n");
  80015c:	83 ec 0c             	sub    $0xc,%esp
  80015f:	68 b1 13 80 00       	push   $0x8013b1
  800164:	e8 1c 02 00 00       	call   800385 <cprintf>
		thisenv = &envs[ENVX(sys_getenvid())];
  800169:	e8 f1 0c 00 00       	call   800e5f <sys_getenvid>
  80016e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800173:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  800179:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80017e:	a3 04 20 80 00       	mov    %eax,0x802004
		return 0;
  800183:	83 c4 10             	add    $0x10,%esp
  800186:	eb 3d                	jmp    8001c5 <dumbfork+0xe7>
	cprintf("dumbfork() 70\n");
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	68 c0 13 80 00       	push   $0x8013c0
  800190:	e8 f0 01 00 00       	call   800385 <cprintf>
	// Also copy the stack we are currently running on.
	duppage(envid, ROUNDDOWN(&addr, PGSIZE));
  800195:	83 c4 08             	add    $0x8,%esp
  800198:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80019b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001a0:	50                   	push   %eax
  8001a1:	53                   	push   %ebx
  8001a2:	e8 8c fe ff ff       	call   800033 <duppage>
	cprintf("dumbfork() 73\n");
  8001a7:	c7 04 24 cf 13 80 00 	movl   $0x8013cf,(%esp)
  8001ae:	e8 d2 01 00 00       	call   800385 <cprintf>
	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8001b3:	83 c4 08             	add    $0x8,%esp
  8001b6:	6a 02                	push   $0x2
  8001b8:	53                   	push   %ebx
  8001b9:	e8 a6 0d 00 00       	call   800f64 <sys_env_set_status>
  8001be:	83 c4 10             	add    $0x10,%esp
  8001c1:	85 c0                	test   %eax,%eax
  8001c3:	78 09                	js     8001ce <dumbfork+0xf0>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  8001c5:	89 d8                	mov    %ebx,%eax
  8001c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001ca:	5b                   	pop    %ebx
  8001cb:	5e                   	pop    %esi
  8001cc:	5d                   	pop    %ebp
  8001cd:	c3                   	ret    
		panic("sys_env_set_status: %e", r);
  8001ce:	50                   	push   %eax
  8001cf:	68 de 13 80 00       	push   $0x8013de
  8001d4:	6a 4e                	push   $0x4e
  8001d6:	68 41 13 80 00       	push   $0x801341
  8001db:	e8 ca 00 00 00       	call   8002aa <_panic>

008001e0 <umain>:
{
  8001e0:	55                   	push   %ebp
  8001e1:	89 e5                	mov    %esp,%ebp
  8001e3:	57                   	push   %edi
  8001e4:	56                   	push   %esi
  8001e5:	53                   	push   %ebx
  8001e6:	83 ec 18             	sub    $0x18,%esp
	cprintf("umain()\n");
  8001e9:	68 f5 13 80 00       	push   $0x8013f5
  8001ee:	e8 92 01 00 00       	call   800385 <cprintf>
	who = dumbfork();
  8001f3:	e8 e6 fe ff ff       	call   8000de <dumbfork>
  8001f8:	89 c7                	mov    %eax,%edi
	cprintf("17\n");
  8001fa:	c7 04 24 fe 13 80 00 	movl   $0x8013fe,(%esp)
  800201:	e8 7f 01 00 00       	call   800385 <cprintf>
  800206:	83 c4 10             	add    $0x10,%esp
  800209:	85 ff                	test   %edi,%edi
  80020b:	be 02 14 80 00       	mov    $0x801402,%esi
  800210:	b8 09 14 80 00       	mov    $0x801409,%eax
  800215:	0f 44 f0             	cmove  %eax,%esi
	for (i = 0; i < (who ? 10 : 20); i++) {
  800218:	bb 00 00 00 00       	mov    $0x0,%ebx
  80021d:	eb 1f                	jmp    80023e <umain+0x5e>
  80021f:	83 fb 13             	cmp    $0x13,%ebx
  800222:	7f 23                	jg     800247 <umain+0x67>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  800224:	83 ec 04             	sub    $0x4,%esp
  800227:	56                   	push   %esi
  800228:	53                   	push   %ebx
  800229:	68 0f 14 80 00       	push   $0x80140f
  80022e:	e8 52 01 00 00       	call   800385 <cprintf>
		sys_yield();
  800233:	e8 46 0c 00 00       	call   800e7e <sys_yield>
	for (i = 0; i < (who ? 10 : 20); i++) {
  800238:	83 c3 01             	add    $0x1,%ebx
  80023b:	83 c4 10             	add    $0x10,%esp
  80023e:	85 ff                	test   %edi,%edi
  800240:	74 dd                	je     80021f <umain+0x3f>
  800242:	83 fb 09             	cmp    $0x9,%ebx
  800245:	7e dd                	jle    800224 <umain+0x44>
}
  800247:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80024a:	5b                   	pop    %ebx
  80024b:	5e                   	pop    %esi
  80024c:	5f                   	pop    %edi
  80024d:	5d                   	pop    %ebp
  80024e:	c3                   	ret    

0080024f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80024f:	55                   	push   %ebp
  800250:	89 e5                	mov    %esp,%ebp
  800252:	56                   	push   %esi
  800253:	53                   	push   %ebx
  800254:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800257:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  80025a:	e8 00 0c 00 00       	call   800e5f <sys_getenvid>
  80025f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800264:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80026a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80026f:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800274:	85 db                	test   %ebx,%ebx
  800276:	7e 07                	jle    80027f <libmain+0x30>
		binaryname = argv[0];
  800278:	8b 06                	mov    (%esi),%eax
  80027a:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80027f:	83 ec 08             	sub    $0x8,%esp
  800282:	56                   	push   %esi
  800283:	53                   	push   %ebx
  800284:	e8 57 ff ff ff       	call   8001e0 <umain>

	// exit gracefully
	exit();
  800289:	e8 0a 00 00 00       	call   800298 <exit>
}
  80028e:	83 c4 10             	add    $0x10,%esp
  800291:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800294:	5b                   	pop    %ebx
  800295:	5e                   	pop    %esi
  800296:	5d                   	pop    %ebp
  800297:	c3                   	ret    

00800298 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800298:	55                   	push   %ebp
  800299:	89 e5                	mov    %esp,%ebp
  80029b:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80029e:	6a 00                	push   $0x0
  8002a0:	e8 79 0b 00 00       	call   800e1e <sys_env_destroy>
}
  8002a5:	83 c4 10             	add    $0x10,%esp
  8002a8:	c9                   	leave  
  8002a9:	c3                   	ret    

008002aa <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002aa:	55                   	push   %ebp
  8002ab:	89 e5                	mov    %esp,%ebp
  8002ad:	56                   	push   %esi
  8002ae:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8002af:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002b2:	8b 35 00 20 80 00    	mov    0x802000,%esi
  8002b8:	e8 a2 0b 00 00       	call   800e5f <sys_getenvid>
  8002bd:	83 ec 0c             	sub    $0xc,%esp
  8002c0:	ff 75 0c             	pushl  0xc(%ebp)
  8002c3:	ff 75 08             	pushl  0x8(%ebp)
  8002c6:	56                   	push   %esi
  8002c7:	50                   	push   %eax
  8002c8:	68 2c 14 80 00       	push   $0x80142c
  8002cd:	e8 b3 00 00 00       	call   800385 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002d2:	83 c4 18             	add    $0x18,%esp
  8002d5:	53                   	push   %ebx
  8002d6:	ff 75 10             	pushl  0x10(%ebp)
  8002d9:	e8 56 00 00 00       	call   800334 <vcprintf>
	cprintf("\n");
  8002de:	c7 04 24 1f 14 80 00 	movl   $0x80141f,(%esp)
  8002e5:	e8 9b 00 00 00       	call   800385 <cprintf>
  8002ea:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002ed:	cc                   	int3   
  8002ee:	eb fd                	jmp    8002ed <_panic+0x43>

008002f0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002f0:	55                   	push   %ebp
  8002f1:	89 e5                	mov    %esp,%ebp
  8002f3:	53                   	push   %ebx
  8002f4:	83 ec 04             	sub    $0x4,%esp
  8002f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002fa:	8b 13                	mov    (%ebx),%edx
  8002fc:	8d 42 01             	lea    0x1(%edx),%eax
  8002ff:	89 03                	mov    %eax,(%ebx)
  800301:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800304:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800308:	3d ff 00 00 00       	cmp    $0xff,%eax
  80030d:	74 09                	je     800318 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80030f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800313:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800316:	c9                   	leave  
  800317:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800318:	83 ec 08             	sub    $0x8,%esp
  80031b:	68 ff 00 00 00       	push   $0xff
  800320:	8d 43 08             	lea    0x8(%ebx),%eax
  800323:	50                   	push   %eax
  800324:	e8 b8 0a 00 00       	call   800de1 <sys_cputs>
		b->idx = 0;
  800329:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80032f:	83 c4 10             	add    $0x10,%esp
  800332:	eb db                	jmp    80030f <putch+0x1f>

00800334 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800334:	55                   	push   %ebp
  800335:	89 e5                	mov    %esp,%ebp
  800337:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80033d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800344:	00 00 00 
	b.cnt = 0;
  800347:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80034e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800351:	ff 75 0c             	pushl  0xc(%ebp)
  800354:	ff 75 08             	pushl  0x8(%ebp)
  800357:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80035d:	50                   	push   %eax
  80035e:	68 f0 02 80 00       	push   $0x8002f0
  800363:	e8 4a 01 00 00       	call   8004b2 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800368:	83 c4 08             	add    $0x8,%esp
  80036b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800371:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800377:	50                   	push   %eax
  800378:	e8 64 0a 00 00       	call   800de1 <sys_cputs>

	return b.cnt;
}
  80037d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800383:	c9                   	leave  
  800384:	c3                   	ret    

00800385 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800385:	55                   	push   %ebp
  800386:	89 e5                	mov    %esp,%ebp
  800388:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80038b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80038e:	50                   	push   %eax
  80038f:	ff 75 08             	pushl  0x8(%ebp)
  800392:	e8 9d ff ff ff       	call   800334 <vcprintf>
	va_end(ap);

	return cnt;
}
  800397:	c9                   	leave  
  800398:	c3                   	ret    

00800399 <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800399:	55                   	push   %ebp
  80039a:	89 e5                	mov    %esp,%ebp
  80039c:	57                   	push   %edi
  80039d:	56                   	push   %esi
  80039e:	53                   	push   %ebx
  80039f:	83 ec 1c             	sub    $0x1c,%esp
  8003a2:	89 c6                	mov    %eax,%esi
  8003a4:	89 d7                	mov    %edx,%edi
  8003a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003af:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8003b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b5:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  8003b8:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8003bc:	74 2c                	je     8003ea <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003c1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8003c8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003cb:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003ce:	39 c2                	cmp    %eax,%edx
  8003d0:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8003d3:	73 43                	jae    800418 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003d5:	83 eb 01             	sub    $0x1,%ebx
  8003d8:	85 db                	test   %ebx,%ebx
  8003da:	7e 6c                	jle    800448 <printnum+0xaf>
			putch(padc, putdat);
  8003dc:	83 ec 08             	sub    $0x8,%esp
  8003df:	57                   	push   %edi
  8003e0:	ff 75 18             	pushl  0x18(%ebp)
  8003e3:	ff d6                	call   *%esi
  8003e5:	83 c4 10             	add    $0x10,%esp
  8003e8:	eb eb                	jmp    8003d5 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8003ea:	83 ec 0c             	sub    $0xc,%esp
  8003ed:	6a 20                	push   $0x20
  8003ef:	6a 00                	push   $0x0
  8003f1:	50                   	push   %eax
  8003f2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003f5:	ff 75 e0             	pushl  -0x20(%ebp)
  8003f8:	89 fa                	mov    %edi,%edx
  8003fa:	89 f0                	mov    %esi,%eax
  8003fc:	e8 98 ff ff ff       	call   800399 <printnum>
		while (--width > 0)
  800401:	83 c4 20             	add    $0x20,%esp
  800404:	83 eb 01             	sub    $0x1,%ebx
  800407:	85 db                	test   %ebx,%ebx
  800409:	7e 65                	jle    800470 <printnum+0xd7>
			putch(' ', putdat);
  80040b:	83 ec 08             	sub    $0x8,%esp
  80040e:	57                   	push   %edi
  80040f:	6a 20                	push   $0x20
  800411:	ff d6                	call   *%esi
  800413:	83 c4 10             	add    $0x10,%esp
  800416:	eb ec                	jmp    800404 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800418:	83 ec 0c             	sub    $0xc,%esp
  80041b:	ff 75 18             	pushl  0x18(%ebp)
  80041e:	83 eb 01             	sub    $0x1,%ebx
  800421:	53                   	push   %ebx
  800422:	50                   	push   %eax
  800423:	83 ec 08             	sub    $0x8,%esp
  800426:	ff 75 dc             	pushl  -0x24(%ebp)
  800429:	ff 75 d8             	pushl  -0x28(%ebp)
  80042c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80042f:	ff 75 e0             	pushl  -0x20(%ebp)
  800432:	e8 99 0c 00 00       	call   8010d0 <__udivdi3>
  800437:	83 c4 18             	add    $0x18,%esp
  80043a:	52                   	push   %edx
  80043b:	50                   	push   %eax
  80043c:	89 fa                	mov    %edi,%edx
  80043e:	89 f0                	mov    %esi,%eax
  800440:	e8 54 ff ff ff       	call   800399 <printnum>
  800445:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800448:	83 ec 08             	sub    $0x8,%esp
  80044b:	57                   	push   %edi
  80044c:	83 ec 04             	sub    $0x4,%esp
  80044f:	ff 75 dc             	pushl  -0x24(%ebp)
  800452:	ff 75 d8             	pushl  -0x28(%ebp)
  800455:	ff 75 e4             	pushl  -0x1c(%ebp)
  800458:	ff 75 e0             	pushl  -0x20(%ebp)
  80045b:	e8 80 0d 00 00       	call   8011e0 <__umoddi3>
  800460:	83 c4 14             	add    $0x14,%esp
  800463:	0f be 80 4f 14 80 00 	movsbl 0x80144f(%eax),%eax
  80046a:	50                   	push   %eax
  80046b:	ff d6                	call   *%esi
  80046d:	83 c4 10             	add    $0x10,%esp
}
  800470:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800473:	5b                   	pop    %ebx
  800474:	5e                   	pop    %esi
  800475:	5f                   	pop    %edi
  800476:	5d                   	pop    %ebp
  800477:	c3                   	ret    

00800478 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800478:	55                   	push   %ebp
  800479:	89 e5                	mov    %esp,%ebp
  80047b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80047e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800482:	8b 10                	mov    (%eax),%edx
  800484:	3b 50 04             	cmp    0x4(%eax),%edx
  800487:	73 0a                	jae    800493 <sprintputch+0x1b>
		*b->buf++ = ch;
  800489:	8d 4a 01             	lea    0x1(%edx),%ecx
  80048c:	89 08                	mov    %ecx,(%eax)
  80048e:	8b 45 08             	mov    0x8(%ebp),%eax
  800491:	88 02                	mov    %al,(%edx)
}
  800493:	5d                   	pop    %ebp
  800494:	c3                   	ret    

00800495 <printfmt>:
{
  800495:	55                   	push   %ebp
  800496:	89 e5                	mov    %esp,%ebp
  800498:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80049b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80049e:	50                   	push   %eax
  80049f:	ff 75 10             	pushl  0x10(%ebp)
  8004a2:	ff 75 0c             	pushl  0xc(%ebp)
  8004a5:	ff 75 08             	pushl  0x8(%ebp)
  8004a8:	e8 05 00 00 00       	call   8004b2 <vprintfmt>
}
  8004ad:	83 c4 10             	add    $0x10,%esp
  8004b0:	c9                   	leave  
  8004b1:	c3                   	ret    

008004b2 <vprintfmt>:
{
  8004b2:	55                   	push   %ebp
  8004b3:	89 e5                	mov    %esp,%ebp
  8004b5:	57                   	push   %edi
  8004b6:	56                   	push   %esi
  8004b7:	53                   	push   %ebx
  8004b8:	83 ec 3c             	sub    $0x3c,%esp
  8004bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8004be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004c1:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004c4:	e9 1e 04 00 00       	jmp    8008e7 <vprintfmt+0x435>
		posflag = 0;
  8004c9:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  8004d0:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8004d4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8004db:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8004e2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004e9:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8004f0:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004f5:	8d 47 01             	lea    0x1(%edi),%eax
  8004f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004fb:	0f b6 17             	movzbl (%edi),%edx
  8004fe:	8d 42 dd             	lea    -0x23(%edx),%eax
  800501:	3c 55                	cmp    $0x55,%al
  800503:	0f 87 d9 04 00 00    	ja     8009e2 <vprintfmt+0x530>
  800509:	0f b6 c0             	movzbl %al,%eax
  80050c:	ff 24 85 40 16 80 00 	jmp    *0x801640(,%eax,4)
  800513:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800516:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80051a:	eb d9                	jmp    8004f5 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80051c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  80051f:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  800526:	eb cd                	jmp    8004f5 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800528:	0f b6 d2             	movzbl %dl,%edx
  80052b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80052e:	b8 00 00 00 00       	mov    $0x0,%eax
  800533:	89 75 08             	mov    %esi,0x8(%ebp)
  800536:	eb 0c                	jmp    800544 <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  800538:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80053b:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  80053f:	eb b4                	jmp    8004f5 <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  800541:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800544:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800547:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80054b:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80054e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800551:	83 fe 09             	cmp    $0x9,%esi
  800554:	76 eb                	jbe    800541 <vprintfmt+0x8f>
  800556:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800559:	8b 75 08             	mov    0x8(%ebp),%esi
  80055c:	eb 14                	jmp    800572 <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  80055e:	8b 45 14             	mov    0x14(%ebp),%eax
  800561:	8b 00                	mov    (%eax),%eax
  800563:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800566:	8b 45 14             	mov    0x14(%ebp),%eax
  800569:	8d 40 04             	lea    0x4(%eax),%eax
  80056c:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80056f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800572:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800576:	0f 89 79 ff ff ff    	jns    8004f5 <vprintfmt+0x43>
				width = precision, precision = -1;
  80057c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80057f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800582:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800589:	e9 67 ff ff ff       	jmp    8004f5 <vprintfmt+0x43>
  80058e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800591:	85 c0                	test   %eax,%eax
  800593:	0f 48 c1             	cmovs  %ecx,%eax
  800596:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800599:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80059c:	e9 54 ff ff ff       	jmp    8004f5 <vprintfmt+0x43>
  8005a1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005a4:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8005ab:	e9 45 ff ff ff       	jmp    8004f5 <vprintfmt+0x43>
			lflag++;
  8005b0:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005b4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005b7:	e9 39 ff ff ff       	jmp    8004f5 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8005bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bf:	8d 78 04             	lea    0x4(%eax),%edi
  8005c2:	83 ec 08             	sub    $0x8,%esp
  8005c5:	53                   	push   %ebx
  8005c6:	ff 30                	pushl  (%eax)
  8005c8:	ff d6                	call   *%esi
			break;
  8005ca:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005cd:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005d0:	e9 0f 03 00 00       	jmp    8008e4 <vprintfmt+0x432>
			err = va_arg(ap, int);
  8005d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d8:	8d 78 04             	lea    0x4(%eax),%edi
  8005db:	8b 00                	mov    (%eax),%eax
  8005dd:	99                   	cltd   
  8005de:	31 d0                	xor    %edx,%eax
  8005e0:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005e2:	83 f8 0f             	cmp    $0xf,%eax
  8005e5:	7f 23                	jg     80060a <vprintfmt+0x158>
  8005e7:	8b 14 85 a0 17 80 00 	mov    0x8017a0(,%eax,4),%edx
  8005ee:	85 d2                	test   %edx,%edx
  8005f0:	74 18                	je     80060a <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  8005f2:	52                   	push   %edx
  8005f3:	68 70 14 80 00       	push   $0x801470
  8005f8:	53                   	push   %ebx
  8005f9:	56                   	push   %esi
  8005fa:	e8 96 fe ff ff       	call   800495 <printfmt>
  8005ff:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800602:	89 7d 14             	mov    %edi,0x14(%ebp)
  800605:	e9 da 02 00 00       	jmp    8008e4 <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  80060a:	50                   	push   %eax
  80060b:	68 67 14 80 00       	push   $0x801467
  800610:	53                   	push   %ebx
  800611:	56                   	push   %esi
  800612:	e8 7e fe ff ff       	call   800495 <printfmt>
  800617:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80061a:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80061d:	e9 c2 02 00 00       	jmp    8008e4 <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  800622:	8b 45 14             	mov    0x14(%ebp),%eax
  800625:	83 c0 04             	add    $0x4,%eax
  800628:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80062b:	8b 45 14             	mov    0x14(%ebp),%eax
  80062e:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800630:	85 c9                	test   %ecx,%ecx
  800632:	b8 60 14 80 00       	mov    $0x801460,%eax
  800637:	0f 45 c1             	cmovne %ecx,%eax
  80063a:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80063d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800641:	7e 06                	jle    800649 <vprintfmt+0x197>
  800643:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800647:	75 0d                	jne    800656 <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  800649:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80064c:	89 c7                	mov    %eax,%edi
  80064e:	03 45 e0             	add    -0x20(%ebp),%eax
  800651:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800654:	eb 53                	jmp    8006a9 <vprintfmt+0x1f7>
  800656:	83 ec 08             	sub    $0x8,%esp
  800659:	ff 75 d8             	pushl  -0x28(%ebp)
  80065c:	50                   	push   %eax
  80065d:	e8 28 04 00 00       	call   800a8a <strnlen>
  800662:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800665:	29 c1                	sub    %eax,%ecx
  800667:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  80066a:	83 c4 10             	add    $0x10,%esp
  80066d:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80066f:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800673:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800676:	eb 0f                	jmp    800687 <vprintfmt+0x1d5>
					putch(padc, putdat);
  800678:	83 ec 08             	sub    $0x8,%esp
  80067b:	53                   	push   %ebx
  80067c:	ff 75 e0             	pushl  -0x20(%ebp)
  80067f:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800681:	83 ef 01             	sub    $0x1,%edi
  800684:	83 c4 10             	add    $0x10,%esp
  800687:	85 ff                	test   %edi,%edi
  800689:	7f ed                	jg     800678 <vprintfmt+0x1c6>
  80068b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  80068e:	85 c9                	test   %ecx,%ecx
  800690:	b8 00 00 00 00       	mov    $0x0,%eax
  800695:	0f 49 c1             	cmovns %ecx,%eax
  800698:	29 c1                	sub    %eax,%ecx
  80069a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80069d:	eb aa                	jmp    800649 <vprintfmt+0x197>
					putch(ch, putdat);
  80069f:	83 ec 08             	sub    $0x8,%esp
  8006a2:	53                   	push   %ebx
  8006a3:	52                   	push   %edx
  8006a4:	ff d6                	call   *%esi
  8006a6:	83 c4 10             	add    $0x10,%esp
  8006a9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006ac:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006ae:	83 c7 01             	add    $0x1,%edi
  8006b1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006b5:	0f be d0             	movsbl %al,%edx
  8006b8:	85 d2                	test   %edx,%edx
  8006ba:	74 4b                	je     800707 <vprintfmt+0x255>
  8006bc:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006c0:	78 06                	js     8006c8 <vprintfmt+0x216>
  8006c2:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8006c6:	78 1e                	js     8006e6 <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  8006c8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006cc:	74 d1                	je     80069f <vprintfmt+0x1ed>
  8006ce:	0f be c0             	movsbl %al,%eax
  8006d1:	83 e8 20             	sub    $0x20,%eax
  8006d4:	83 f8 5e             	cmp    $0x5e,%eax
  8006d7:	76 c6                	jbe    80069f <vprintfmt+0x1ed>
					putch('?', putdat);
  8006d9:	83 ec 08             	sub    $0x8,%esp
  8006dc:	53                   	push   %ebx
  8006dd:	6a 3f                	push   $0x3f
  8006df:	ff d6                	call   *%esi
  8006e1:	83 c4 10             	add    $0x10,%esp
  8006e4:	eb c3                	jmp    8006a9 <vprintfmt+0x1f7>
  8006e6:	89 cf                	mov    %ecx,%edi
  8006e8:	eb 0e                	jmp    8006f8 <vprintfmt+0x246>
				putch(' ', putdat);
  8006ea:	83 ec 08             	sub    $0x8,%esp
  8006ed:	53                   	push   %ebx
  8006ee:	6a 20                	push   $0x20
  8006f0:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006f2:	83 ef 01             	sub    $0x1,%edi
  8006f5:	83 c4 10             	add    $0x10,%esp
  8006f8:	85 ff                	test   %edi,%edi
  8006fa:	7f ee                	jg     8006ea <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  8006fc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006ff:	89 45 14             	mov    %eax,0x14(%ebp)
  800702:	e9 dd 01 00 00       	jmp    8008e4 <vprintfmt+0x432>
  800707:	89 cf                	mov    %ecx,%edi
  800709:	eb ed                	jmp    8006f8 <vprintfmt+0x246>
	if (lflag >= 2)
  80070b:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80070f:	7f 21                	jg     800732 <vprintfmt+0x280>
	else if (lflag)
  800711:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800715:	74 6a                	je     800781 <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  800717:	8b 45 14             	mov    0x14(%ebp),%eax
  80071a:	8b 00                	mov    (%eax),%eax
  80071c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80071f:	89 c1                	mov    %eax,%ecx
  800721:	c1 f9 1f             	sar    $0x1f,%ecx
  800724:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800727:	8b 45 14             	mov    0x14(%ebp),%eax
  80072a:	8d 40 04             	lea    0x4(%eax),%eax
  80072d:	89 45 14             	mov    %eax,0x14(%ebp)
  800730:	eb 17                	jmp    800749 <vprintfmt+0x297>
		return va_arg(*ap, long long);
  800732:	8b 45 14             	mov    0x14(%ebp),%eax
  800735:	8b 50 04             	mov    0x4(%eax),%edx
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800740:	8b 45 14             	mov    0x14(%ebp),%eax
  800743:	8d 40 08             	lea    0x8(%eax),%eax
  800746:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800749:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  80074c:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800751:	85 d2                	test   %edx,%edx
  800753:	0f 89 5c 01 00 00    	jns    8008b5 <vprintfmt+0x403>
				putch('-', putdat);
  800759:	83 ec 08             	sub    $0x8,%esp
  80075c:	53                   	push   %ebx
  80075d:	6a 2d                	push   $0x2d
  80075f:	ff d6                	call   *%esi
				num = -(long long) num;
  800761:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800764:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800767:	f7 d8                	neg    %eax
  800769:	83 d2 00             	adc    $0x0,%edx
  80076c:	f7 da                	neg    %edx
  80076e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800771:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800774:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800777:	bf 0a 00 00 00       	mov    $0xa,%edi
  80077c:	e9 45 01 00 00       	jmp    8008c6 <vprintfmt+0x414>
		return va_arg(*ap, int);
  800781:	8b 45 14             	mov    0x14(%ebp),%eax
  800784:	8b 00                	mov    (%eax),%eax
  800786:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800789:	89 c1                	mov    %eax,%ecx
  80078b:	c1 f9 1f             	sar    $0x1f,%ecx
  80078e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800791:	8b 45 14             	mov    0x14(%ebp),%eax
  800794:	8d 40 04             	lea    0x4(%eax),%eax
  800797:	89 45 14             	mov    %eax,0x14(%ebp)
  80079a:	eb ad                	jmp    800749 <vprintfmt+0x297>
	if (lflag >= 2)
  80079c:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8007a0:	7f 29                	jg     8007cb <vprintfmt+0x319>
	else if (lflag)
  8007a2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8007a6:	74 44                	je     8007ec <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  8007a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ab:	8b 00                	mov    (%eax),%eax
  8007ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bb:	8d 40 04             	lea    0x4(%eax),%eax
  8007be:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007c1:	bf 0a 00 00 00       	mov    $0xa,%edi
  8007c6:	e9 ea 00 00 00       	jmp    8008b5 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8007cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ce:	8b 50 04             	mov    0x4(%eax),%edx
  8007d1:	8b 00                	mov    (%eax),%eax
  8007d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dc:	8d 40 08             	lea    0x8(%eax),%eax
  8007df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007e2:	bf 0a 00 00 00       	mov    $0xa,%edi
  8007e7:	e9 c9 00 00 00       	jmp    8008b5 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8007ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ef:	8b 00                	mov    (%eax),%eax
  8007f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ff:	8d 40 04             	lea    0x4(%eax),%eax
  800802:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800805:	bf 0a 00 00 00       	mov    $0xa,%edi
  80080a:	e9 a6 00 00 00       	jmp    8008b5 <vprintfmt+0x403>
			putch('0', putdat);
  80080f:	83 ec 08             	sub    $0x8,%esp
  800812:	53                   	push   %ebx
  800813:	6a 30                	push   $0x30
  800815:	ff d6                	call   *%esi
	if (lflag >= 2)
  800817:	83 c4 10             	add    $0x10,%esp
  80081a:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80081e:	7f 26                	jg     800846 <vprintfmt+0x394>
	else if (lflag)
  800820:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800824:	74 3e                	je     800864 <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  800826:	8b 45 14             	mov    0x14(%ebp),%eax
  800829:	8b 00                	mov    (%eax),%eax
  80082b:	ba 00 00 00 00       	mov    $0x0,%edx
  800830:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800833:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800836:	8b 45 14             	mov    0x14(%ebp),%eax
  800839:	8d 40 04             	lea    0x4(%eax),%eax
  80083c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80083f:	bf 08 00 00 00       	mov    $0x8,%edi
  800844:	eb 6f                	jmp    8008b5 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800846:	8b 45 14             	mov    0x14(%ebp),%eax
  800849:	8b 50 04             	mov    0x4(%eax),%edx
  80084c:	8b 00                	mov    (%eax),%eax
  80084e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800851:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800854:	8b 45 14             	mov    0x14(%ebp),%eax
  800857:	8d 40 08             	lea    0x8(%eax),%eax
  80085a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80085d:	bf 08 00 00 00       	mov    $0x8,%edi
  800862:	eb 51                	jmp    8008b5 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800864:	8b 45 14             	mov    0x14(%ebp),%eax
  800867:	8b 00                	mov    (%eax),%eax
  800869:	ba 00 00 00 00       	mov    $0x0,%edx
  80086e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800871:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800874:	8b 45 14             	mov    0x14(%ebp),%eax
  800877:	8d 40 04             	lea    0x4(%eax),%eax
  80087a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80087d:	bf 08 00 00 00       	mov    $0x8,%edi
  800882:	eb 31                	jmp    8008b5 <vprintfmt+0x403>
			putch('0', putdat);
  800884:	83 ec 08             	sub    $0x8,%esp
  800887:	53                   	push   %ebx
  800888:	6a 30                	push   $0x30
  80088a:	ff d6                	call   *%esi
			putch('x', putdat);
  80088c:	83 c4 08             	add    $0x8,%esp
  80088f:	53                   	push   %ebx
  800890:	6a 78                	push   $0x78
  800892:	ff d6                	call   *%esi
			num = (unsigned long long)
  800894:	8b 45 14             	mov    0x14(%ebp),%eax
  800897:	8b 00                	mov    (%eax),%eax
  800899:	ba 00 00 00 00       	mov    $0x0,%edx
  80089e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a1:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8008a4:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008aa:	8d 40 04             	lea    0x4(%eax),%eax
  8008ad:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008b0:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  8008b5:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8008b9:	74 0b                	je     8008c6 <vprintfmt+0x414>
				putch('+', putdat);
  8008bb:	83 ec 08             	sub    $0x8,%esp
  8008be:	53                   	push   %ebx
  8008bf:	6a 2b                	push   $0x2b
  8008c1:	ff d6                	call   *%esi
  8008c3:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  8008c6:	83 ec 0c             	sub    $0xc,%esp
  8008c9:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8008cd:	50                   	push   %eax
  8008ce:	ff 75 e0             	pushl  -0x20(%ebp)
  8008d1:	57                   	push   %edi
  8008d2:	ff 75 dc             	pushl  -0x24(%ebp)
  8008d5:	ff 75 d8             	pushl  -0x28(%ebp)
  8008d8:	89 da                	mov    %ebx,%edx
  8008da:	89 f0                	mov    %esi,%eax
  8008dc:	e8 b8 fa ff ff       	call   800399 <printnum>
			break;
  8008e1:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  8008e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008e7:	83 c7 01             	add    $0x1,%edi
  8008ea:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008ee:	83 f8 25             	cmp    $0x25,%eax
  8008f1:	0f 84 d2 fb ff ff    	je     8004c9 <vprintfmt+0x17>
			if (ch == '\0')
  8008f7:	85 c0                	test   %eax,%eax
  8008f9:	0f 84 03 01 00 00    	je     800a02 <vprintfmt+0x550>
			putch(ch, putdat);
  8008ff:	83 ec 08             	sub    $0x8,%esp
  800902:	53                   	push   %ebx
  800903:	50                   	push   %eax
  800904:	ff d6                	call   *%esi
  800906:	83 c4 10             	add    $0x10,%esp
  800909:	eb dc                	jmp    8008e7 <vprintfmt+0x435>
	if (lflag >= 2)
  80090b:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80090f:	7f 29                	jg     80093a <vprintfmt+0x488>
	else if (lflag)
  800911:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800915:	74 44                	je     80095b <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  800917:	8b 45 14             	mov    0x14(%ebp),%eax
  80091a:	8b 00                	mov    (%eax),%eax
  80091c:	ba 00 00 00 00       	mov    $0x0,%edx
  800921:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800924:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800927:	8b 45 14             	mov    0x14(%ebp),%eax
  80092a:	8d 40 04             	lea    0x4(%eax),%eax
  80092d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800930:	bf 10 00 00 00       	mov    $0x10,%edi
  800935:	e9 7b ff ff ff       	jmp    8008b5 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  80093a:	8b 45 14             	mov    0x14(%ebp),%eax
  80093d:	8b 50 04             	mov    0x4(%eax),%edx
  800940:	8b 00                	mov    (%eax),%eax
  800942:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800945:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800948:	8b 45 14             	mov    0x14(%ebp),%eax
  80094b:	8d 40 08             	lea    0x8(%eax),%eax
  80094e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800951:	bf 10 00 00 00       	mov    $0x10,%edi
  800956:	e9 5a ff ff ff       	jmp    8008b5 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  80095b:	8b 45 14             	mov    0x14(%ebp),%eax
  80095e:	8b 00                	mov    (%eax),%eax
  800960:	ba 00 00 00 00       	mov    $0x0,%edx
  800965:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800968:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80096b:	8b 45 14             	mov    0x14(%ebp),%eax
  80096e:	8d 40 04             	lea    0x4(%eax),%eax
  800971:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800974:	bf 10 00 00 00       	mov    $0x10,%edi
  800979:	e9 37 ff ff ff       	jmp    8008b5 <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  80097e:	8b 45 14             	mov    0x14(%ebp),%eax
  800981:	8d 78 04             	lea    0x4(%eax),%edi
  800984:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  800986:	85 c0                	test   %eax,%eax
  800988:	74 2c                	je     8009b6 <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  80098a:	8b 13                	mov    (%ebx),%edx
  80098c:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  80098e:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  800991:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800994:	0f 8e 4a ff ff ff    	jle    8008e4 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  80099a:	68 c0 15 80 00       	push   $0x8015c0
  80099f:	68 70 14 80 00       	push   $0x801470
  8009a4:	53                   	push   %ebx
  8009a5:	56                   	push   %esi
  8009a6:	e8 ea fa ff ff       	call   800495 <printfmt>
  8009ab:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  8009ae:	89 7d 14             	mov    %edi,0x14(%ebp)
  8009b1:	e9 2e ff ff ff       	jmp    8008e4 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  8009b6:	68 88 15 80 00       	push   $0x801588
  8009bb:	68 70 14 80 00       	push   $0x801470
  8009c0:	53                   	push   %ebx
  8009c1:	56                   	push   %esi
  8009c2:	e8 ce fa ff ff       	call   800495 <printfmt>
        		break;
  8009c7:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  8009ca:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  8009cd:	e9 12 ff ff ff       	jmp    8008e4 <vprintfmt+0x432>
			putch(ch, putdat);
  8009d2:	83 ec 08             	sub    $0x8,%esp
  8009d5:	53                   	push   %ebx
  8009d6:	6a 25                	push   $0x25
  8009d8:	ff d6                	call   *%esi
			break;
  8009da:	83 c4 10             	add    $0x10,%esp
  8009dd:	e9 02 ff ff ff       	jmp    8008e4 <vprintfmt+0x432>
			putch('%', putdat);
  8009e2:	83 ec 08             	sub    $0x8,%esp
  8009e5:	53                   	push   %ebx
  8009e6:	6a 25                	push   $0x25
  8009e8:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009ea:	83 c4 10             	add    $0x10,%esp
  8009ed:	89 f8                	mov    %edi,%eax
  8009ef:	eb 03                	jmp    8009f4 <vprintfmt+0x542>
  8009f1:	83 e8 01             	sub    $0x1,%eax
  8009f4:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009f8:	75 f7                	jne    8009f1 <vprintfmt+0x53f>
  8009fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009fd:	e9 e2 fe ff ff       	jmp    8008e4 <vprintfmt+0x432>
}
  800a02:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a05:	5b                   	pop    %ebx
  800a06:	5e                   	pop    %esi
  800a07:	5f                   	pop    %edi
  800a08:	5d                   	pop    %ebp
  800a09:	c3                   	ret    

00800a0a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a0a:	55                   	push   %ebp
  800a0b:	89 e5                	mov    %esp,%ebp
  800a0d:	83 ec 18             	sub    $0x18,%esp
  800a10:	8b 45 08             	mov    0x8(%ebp),%eax
  800a13:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a16:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a19:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a1d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a20:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a27:	85 c0                	test   %eax,%eax
  800a29:	74 26                	je     800a51 <vsnprintf+0x47>
  800a2b:	85 d2                	test   %edx,%edx
  800a2d:	7e 22                	jle    800a51 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a2f:	ff 75 14             	pushl  0x14(%ebp)
  800a32:	ff 75 10             	pushl  0x10(%ebp)
  800a35:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a38:	50                   	push   %eax
  800a39:	68 78 04 80 00       	push   $0x800478
  800a3e:	e8 6f fa ff ff       	call   8004b2 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a46:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a4c:	83 c4 10             	add    $0x10,%esp
}
  800a4f:	c9                   	leave  
  800a50:	c3                   	ret    
		return -E_INVAL;
  800a51:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a56:	eb f7                	jmp    800a4f <vsnprintf+0x45>

00800a58 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a58:	55                   	push   %ebp
  800a59:	89 e5                	mov    %esp,%ebp
  800a5b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a5e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a61:	50                   	push   %eax
  800a62:	ff 75 10             	pushl  0x10(%ebp)
  800a65:	ff 75 0c             	pushl  0xc(%ebp)
  800a68:	ff 75 08             	pushl  0x8(%ebp)
  800a6b:	e8 9a ff ff ff       	call   800a0a <vsnprintf>
	va_end(ap);

	return rc;
}
  800a70:	c9                   	leave  
  800a71:	c3                   	ret    

00800a72 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a72:	55                   	push   %ebp
  800a73:	89 e5                	mov    %esp,%ebp
  800a75:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a78:	b8 00 00 00 00       	mov    $0x0,%eax
  800a7d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a81:	74 05                	je     800a88 <strlen+0x16>
		n++;
  800a83:	83 c0 01             	add    $0x1,%eax
  800a86:	eb f5                	jmp    800a7d <strlen+0xb>
	return n;
}
  800a88:	5d                   	pop    %ebp
  800a89:	c3                   	ret    

00800a8a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a8a:	55                   	push   %ebp
  800a8b:	89 e5                	mov    %esp,%ebp
  800a8d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a90:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a93:	ba 00 00 00 00       	mov    $0x0,%edx
  800a98:	39 c2                	cmp    %eax,%edx
  800a9a:	74 0d                	je     800aa9 <strnlen+0x1f>
  800a9c:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800aa0:	74 05                	je     800aa7 <strnlen+0x1d>
		n++;
  800aa2:	83 c2 01             	add    $0x1,%edx
  800aa5:	eb f1                	jmp    800a98 <strnlen+0xe>
  800aa7:	89 d0                	mov    %edx,%eax
	return n;
}
  800aa9:	5d                   	pop    %ebp
  800aaa:	c3                   	ret    

00800aab <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800aab:	55                   	push   %ebp
  800aac:	89 e5                	mov    %esp,%ebp
  800aae:	53                   	push   %ebx
  800aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ab5:	ba 00 00 00 00       	mov    $0x0,%edx
  800aba:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800abe:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800ac1:	83 c2 01             	add    $0x1,%edx
  800ac4:	84 c9                	test   %cl,%cl
  800ac6:	75 f2                	jne    800aba <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800ac8:	5b                   	pop    %ebx
  800ac9:	5d                   	pop    %ebp
  800aca:	c3                   	ret    

00800acb <strcat>:

char *
strcat(char *dst, const char *src)
{
  800acb:	55                   	push   %ebp
  800acc:	89 e5                	mov    %esp,%ebp
  800ace:	53                   	push   %ebx
  800acf:	83 ec 10             	sub    $0x10,%esp
  800ad2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800ad5:	53                   	push   %ebx
  800ad6:	e8 97 ff ff ff       	call   800a72 <strlen>
  800adb:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800ade:	ff 75 0c             	pushl  0xc(%ebp)
  800ae1:	01 d8                	add    %ebx,%eax
  800ae3:	50                   	push   %eax
  800ae4:	e8 c2 ff ff ff       	call   800aab <strcpy>
	return dst;
}
  800ae9:	89 d8                	mov    %ebx,%eax
  800aeb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aee:	c9                   	leave  
  800aef:	c3                   	ret    

00800af0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800af0:	55                   	push   %ebp
  800af1:	89 e5                	mov    %esp,%ebp
  800af3:	56                   	push   %esi
  800af4:	53                   	push   %ebx
  800af5:	8b 45 08             	mov    0x8(%ebp),%eax
  800af8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800afb:	89 c6                	mov    %eax,%esi
  800afd:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b00:	89 c2                	mov    %eax,%edx
  800b02:	39 f2                	cmp    %esi,%edx
  800b04:	74 11                	je     800b17 <strncpy+0x27>
		*dst++ = *src;
  800b06:	83 c2 01             	add    $0x1,%edx
  800b09:	0f b6 19             	movzbl (%ecx),%ebx
  800b0c:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b0f:	80 fb 01             	cmp    $0x1,%bl
  800b12:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800b15:	eb eb                	jmp    800b02 <strncpy+0x12>
	}
	return ret;
}
  800b17:	5b                   	pop    %ebx
  800b18:	5e                   	pop    %esi
  800b19:	5d                   	pop    %ebp
  800b1a:	c3                   	ret    

00800b1b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b1b:	55                   	push   %ebp
  800b1c:	89 e5                	mov    %esp,%ebp
  800b1e:	56                   	push   %esi
  800b1f:	53                   	push   %ebx
  800b20:	8b 75 08             	mov    0x8(%ebp),%esi
  800b23:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b26:	8b 55 10             	mov    0x10(%ebp),%edx
  800b29:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b2b:	85 d2                	test   %edx,%edx
  800b2d:	74 21                	je     800b50 <strlcpy+0x35>
  800b2f:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b33:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800b35:	39 c2                	cmp    %eax,%edx
  800b37:	74 14                	je     800b4d <strlcpy+0x32>
  800b39:	0f b6 19             	movzbl (%ecx),%ebx
  800b3c:	84 db                	test   %bl,%bl
  800b3e:	74 0b                	je     800b4b <strlcpy+0x30>
			*dst++ = *src++;
  800b40:	83 c1 01             	add    $0x1,%ecx
  800b43:	83 c2 01             	add    $0x1,%edx
  800b46:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b49:	eb ea                	jmp    800b35 <strlcpy+0x1a>
  800b4b:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b4d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b50:	29 f0                	sub    %esi,%eax
}
  800b52:	5b                   	pop    %ebx
  800b53:	5e                   	pop    %esi
  800b54:	5d                   	pop    %ebp
  800b55:	c3                   	ret    

00800b56 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b56:	55                   	push   %ebp
  800b57:	89 e5                	mov    %esp,%ebp
  800b59:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b5c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b5f:	0f b6 01             	movzbl (%ecx),%eax
  800b62:	84 c0                	test   %al,%al
  800b64:	74 0c                	je     800b72 <strcmp+0x1c>
  800b66:	3a 02                	cmp    (%edx),%al
  800b68:	75 08                	jne    800b72 <strcmp+0x1c>
		p++, q++;
  800b6a:	83 c1 01             	add    $0x1,%ecx
  800b6d:	83 c2 01             	add    $0x1,%edx
  800b70:	eb ed                	jmp    800b5f <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b72:	0f b6 c0             	movzbl %al,%eax
  800b75:	0f b6 12             	movzbl (%edx),%edx
  800b78:	29 d0                	sub    %edx,%eax
}
  800b7a:	5d                   	pop    %ebp
  800b7b:	c3                   	ret    

00800b7c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b7c:	55                   	push   %ebp
  800b7d:	89 e5                	mov    %esp,%ebp
  800b7f:	53                   	push   %ebx
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b86:	89 c3                	mov    %eax,%ebx
  800b88:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b8b:	eb 06                	jmp    800b93 <strncmp+0x17>
		n--, p++, q++;
  800b8d:	83 c0 01             	add    $0x1,%eax
  800b90:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b93:	39 d8                	cmp    %ebx,%eax
  800b95:	74 16                	je     800bad <strncmp+0x31>
  800b97:	0f b6 08             	movzbl (%eax),%ecx
  800b9a:	84 c9                	test   %cl,%cl
  800b9c:	74 04                	je     800ba2 <strncmp+0x26>
  800b9e:	3a 0a                	cmp    (%edx),%cl
  800ba0:	74 eb                	je     800b8d <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ba2:	0f b6 00             	movzbl (%eax),%eax
  800ba5:	0f b6 12             	movzbl (%edx),%edx
  800ba8:	29 d0                	sub    %edx,%eax
}
  800baa:	5b                   	pop    %ebx
  800bab:	5d                   	pop    %ebp
  800bac:	c3                   	ret    
		return 0;
  800bad:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb2:	eb f6                	jmp    800baa <strncmp+0x2e>

00800bb4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bba:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bbe:	0f b6 10             	movzbl (%eax),%edx
  800bc1:	84 d2                	test   %dl,%dl
  800bc3:	74 09                	je     800bce <strchr+0x1a>
		if (*s == c)
  800bc5:	38 ca                	cmp    %cl,%dl
  800bc7:	74 0a                	je     800bd3 <strchr+0x1f>
	for (; *s; s++)
  800bc9:	83 c0 01             	add    $0x1,%eax
  800bcc:	eb f0                	jmp    800bbe <strchr+0xa>
			return (char *) s;
	return 0;
  800bce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bd3:	5d                   	pop    %ebp
  800bd4:	c3                   	ret    

00800bd5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdb:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bdf:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800be2:	38 ca                	cmp    %cl,%dl
  800be4:	74 09                	je     800bef <strfind+0x1a>
  800be6:	84 d2                	test   %dl,%dl
  800be8:	74 05                	je     800bef <strfind+0x1a>
	for (; *s; s++)
  800bea:	83 c0 01             	add    $0x1,%eax
  800bed:	eb f0                	jmp    800bdf <strfind+0xa>
			break;
	return (char *) s;
}
  800bef:	5d                   	pop    %ebp
  800bf0:	c3                   	ret    

00800bf1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800bf1:	55                   	push   %ebp
  800bf2:	89 e5                	mov    %esp,%ebp
  800bf4:	57                   	push   %edi
  800bf5:	56                   	push   %esi
  800bf6:	53                   	push   %ebx
  800bf7:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bfa:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bfd:	85 c9                	test   %ecx,%ecx
  800bff:	74 31                	je     800c32 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c01:	89 f8                	mov    %edi,%eax
  800c03:	09 c8                	or     %ecx,%eax
  800c05:	a8 03                	test   $0x3,%al
  800c07:	75 23                	jne    800c2c <memset+0x3b>
		c &= 0xFF;
  800c09:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c0d:	89 d3                	mov    %edx,%ebx
  800c0f:	c1 e3 08             	shl    $0x8,%ebx
  800c12:	89 d0                	mov    %edx,%eax
  800c14:	c1 e0 18             	shl    $0x18,%eax
  800c17:	89 d6                	mov    %edx,%esi
  800c19:	c1 e6 10             	shl    $0x10,%esi
  800c1c:	09 f0                	or     %esi,%eax
  800c1e:	09 c2                	or     %eax,%edx
  800c20:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c22:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c25:	89 d0                	mov    %edx,%eax
  800c27:	fc                   	cld    
  800c28:	f3 ab                	rep stos %eax,%es:(%edi)
  800c2a:	eb 06                	jmp    800c32 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2f:	fc                   	cld    
  800c30:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c32:	89 f8                	mov    %edi,%eax
  800c34:	5b                   	pop    %ebx
  800c35:	5e                   	pop    %esi
  800c36:	5f                   	pop    %edi
  800c37:	5d                   	pop    %ebp
  800c38:	c3                   	ret    

00800c39 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
  800c3c:	57                   	push   %edi
  800c3d:	56                   	push   %esi
  800c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c41:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c44:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c47:	39 c6                	cmp    %eax,%esi
  800c49:	73 32                	jae    800c7d <memmove+0x44>
  800c4b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c4e:	39 c2                	cmp    %eax,%edx
  800c50:	76 2b                	jbe    800c7d <memmove+0x44>
		s += n;
		d += n;
  800c52:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c55:	89 fe                	mov    %edi,%esi
  800c57:	09 ce                	or     %ecx,%esi
  800c59:	09 d6                	or     %edx,%esi
  800c5b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c61:	75 0e                	jne    800c71 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c63:	83 ef 04             	sub    $0x4,%edi
  800c66:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c69:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c6c:	fd                   	std    
  800c6d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c6f:	eb 09                	jmp    800c7a <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c71:	83 ef 01             	sub    $0x1,%edi
  800c74:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c77:	fd                   	std    
  800c78:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c7a:	fc                   	cld    
  800c7b:	eb 1a                	jmp    800c97 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c7d:	89 c2                	mov    %eax,%edx
  800c7f:	09 ca                	or     %ecx,%edx
  800c81:	09 f2                	or     %esi,%edx
  800c83:	f6 c2 03             	test   $0x3,%dl
  800c86:	75 0a                	jne    800c92 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c88:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c8b:	89 c7                	mov    %eax,%edi
  800c8d:	fc                   	cld    
  800c8e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c90:	eb 05                	jmp    800c97 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c92:	89 c7                	mov    %eax,%edi
  800c94:	fc                   	cld    
  800c95:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c97:	5e                   	pop    %esi
  800c98:	5f                   	pop    %edi
  800c99:	5d                   	pop    %ebp
  800c9a:	c3                   	ret    

00800c9b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
  800c9e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ca1:	ff 75 10             	pushl  0x10(%ebp)
  800ca4:	ff 75 0c             	pushl  0xc(%ebp)
  800ca7:	ff 75 08             	pushl  0x8(%ebp)
  800caa:	e8 8a ff ff ff       	call   800c39 <memmove>
}
  800caf:	c9                   	leave  
  800cb0:	c3                   	ret    

00800cb1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	56                   	push   %esi
  800cb5:	53                   	push   %ebx
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cbc:	89 c6                	mov    %eax,%esi
  800cbe:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cc1:	39 f0                	cmp    %esi,%eax
  800cc3:	74 1c                	je     800ce1 <memcmp+0x30>
		if (*s1 != *s2)
  800cc5:	0f b6 08             	movzbl (%eax),%ecx
  800cc8:	0f b6 1a             	movzbl (%edx),%ebx
  800ccb:	38 d9                	cmp    %bl,%cl
  800ccd:	75 08                	jne    800cd7 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ccf:	83 c0 01             	add    $0x1,%eax
  800cd2:	83 c2 01             	add    $0x1,%edx
  800cd5:	eb ea                	jmp    800cc1 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800cd7:	0f b6 c1             	movzbl %cl,%eax
  800cda:	0f b6 db             	movzbl %bl,%ebx
  800cdd:	29 d8                	sub    %ebx,%eax
  800cdf:	eb 05                	jmp    800ce6 <memcmp+0x35>
	}

	return 0;
  800ce1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ce6:	5b                   	pop    %ebx
  800ce7:	5e                   	pop    %esi
  800ce8:	5d                   	pop    %ebp
  800ce9:	c3                   	ret    

00800cea <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800cea:	55                   	push   %ebp
  800ceb:	89 e5                	mov    %esp,%ebp
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800cf3:	89 c2                	mov    %eax,%edx
  800cf5:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cf8:	39 d0                	cmp    %edx,%eax
  800cfa:	73 09                	jae    800d05 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cfc:	38 08                	cmp    %cl,(%eax)
  800cfe:	74 05                	je     800d05 <memfind+0x1b>
	for (; s < ends; s++)
  800d00:	83 c0 01             	add    $0x1,%eax
  800d03:	eb f3                	jmp    800cf8 <memfind+0xe>
			break;
	return (void *) s;
}
  800d05:	5d                   	pop    %ebp
  800d06:	c3                   	ret    

00800d07 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d07:	55                   	push   %ebp
  800d08:	89 e5                	mov    %esp,%ebp
  800d0a:	57                   	push   %edi
  800d0b:	56                   	push   %esi
  800d0c:	53                   	push   %ebx
  800d0d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d10:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d13:	eb 03                	jmp    800d18 <strtol+0x11>
		s++;
  800d15:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d18:	0f b6 01             	movzbl (%ecx),%eax
  800d1b:	3c 20                	cmp    $0x20,%al
  800d1d:	74 f6                	je     800d15 <strtol+0xe>
  800d1f:	3c 09                	cmp    $0x9,%al
  800d21:	74 f2                	je     800d15 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d23:	3c 2b                	cmp    $0x2b,%al
  800d25:	74 2a                	je     800d51 <strtol+0x4a>
	int neg = 0;
  800d27:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d2c:	3c 2d                	cmp    $0x2d,%al
  800d2e:	74 2b                	je     800d5b <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d30:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d36:	75 0f                	jne    800d47 <strtol+0x40>
  800d38:	80 39 30             	cmpb   $0x30,(%ecx)
  800d3b:	74 28                	je     800d65 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d3d:	85 db                	test   %ebx,%ebx
  800d3f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d44:	0f 44 d8             	cmove  %eax,%ebx
  800d47:	b8 00 00 00 00       	mov    $0x0,%eax
  800d4c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d4f:	eb 50                	jmp    800da1 <strtol+0x9a>
		s++;
  800d51:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d54:	bf 00 00 00 00       	mov    $0x0,%edi
  800d59:	eb d5                	jmp    800d30 <strtol+0x29>
		s++, neg = 1;
  800d5b:	83 c1 01             	add    $0x1,%ecx
  800d5e:	bf 01 00 00 00       	mov    $0x1,%edi
  800d63:	eb cb                	jmp    800d30 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d65:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d69:	74 0e                	je     800d79 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d6b:	85 db                	test   %ebx,%ebx
  800d6d:	75 d8                	jne    800d47 <strtol+0x40>
		s++, base = 8;
  800d6f:	83 c1 01             	add    $0x1,%ecx
  800d72:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d77:	eb ce                	jmp    800d47 <strtol+0x40>
		s += 2, base = 16;
  800d79:	83 c1 02             	add    $0x2,%ecx
  800d7c:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d81:	eb c4                	jmp    800d47 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d83:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d86:	89 f3                	mov    %esi,%ebx
  800d88:	80 fb 19             	cmp    $0x19,%bl
  800d8b:	77 29                	ja     800db6 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d8d:	0f be d2             	movsbl %dl,%edx
  800d90:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d93:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d96:	7d 30                	jge    800dc8 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d98:	83 c1 01             	add    $0x1,%ecx
  800d9b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d9f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800da1:	0f b6 11             	movzbl (%ecx),%edx
  800da4:	8d 72 d0             	lea    -0x30(%edx),%esi
  800da7:	89 f3                	mov    %esi,%ebx
  800da9:	80 fb 09             	cmp    $0x9,%bl
  800dac:	77 d5                	ja     800d83 <strtol+0x7c>
			dig = *s - '0';
  800dae:	0f be d2             	movsbl %dl,%edx
  800db1:	83 ea 30             	sub    $0x30,%edx
  800db4:	eb dd                	jmp    800d93 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800db6:	8d 72 bf             	lea    -0x41(%edx),%esi
  800db9:	89 f3                	mov    %esi,%ebx
  800dbb:	80 fb 19             	cmp    $0x19,%bl
  800dbe:	77 08                	ja     800dc8 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800dc0:	0f be d2             	movsbl %dl,%edx
  800dc3:	83 ea 37             	sub    $0x37,%edx
  800dc6:	eb cb                	jmp    800d93 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800dc8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dcc:	74 05                	je     800dd3 <strtol+0xcc>
		*endptr = (char *) s;
  800dce:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dd1:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800dd3:	89 c2                	mov    %eax,%edx
  800dd5:	f7 da                	neg    %edx
  800dd7:	85 ff                	test   %edi,%edi
  800dd9:	0f 45 c2             	cmovne %edx,%eax
}
  800ddc:	5b                   	pop    %ebx
  800ddd:	5e                   	pop    %esi
  800dde:	5f                   	pop    %edi
  800ddf:	5d                   	pop    %ebp
  800de0:	c3                   	ret    

00800de1 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	57                   	push   %edi
  800de5:	56                   	push   %esi
  800de6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800de7:	b8 00 00 00 00       	mov    $0x0,%eax
  800dec:	8b 55 08             	mov    0x8(%ebp),%edx
  800def:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df2:	89 c3                	mov    %eax,%ebx
  800df4:	89 c7                	mov    %eax,%edi
  800df6:	89 c6                	mov    %eax,%esi
  800df8:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800dfa:	5b                   	pop    %ebx
  800dfb:	5e                   	pop    %esi
  800dfc:	5f                   	pop    %edi
  800dfd:	5d                   	pop    %ebp
  800dfe:	c3                   	ret    

00800dff <sys_cgetc>:

int
sys_cgetc(void)
{
  800dff:	55                   	push   %ebp
  800e00:	89 e5                	mov    %esp,%ebp
  800e02:	57                   	push   %edi
  800e03:	56                   	push   %esi
  800e04:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e05:	ba 00 00 00 00       	mov    $0x0,%edx
  800e0a:	b8 01 00 00 00       	mov    $0x1,%eax
  800e0f:	89 d1                	mov    %edx,%ecx
  800e11:	89 d3                	mov    %edx,%ebx
  800e13:	89 d7                	mov    %edx,%edi
  800e15:	89 d6                	mov    %edx,%esi
  800e17:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e19:	5b                   	pop    %ebx
  800e1a:	5e                   	pop    %esi
  800e1b:	5f                   	pop    %edi
  800e1c:	5d                   	pop    %ebp
  800e1d:	c3                   	ret    

00800e1e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	57                   	push   %edi
  800e22:	56                   	push   %esi
  800e23:	53                   	push   %ebx
  800e24:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e27:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2f:	b8 03 00 00 00       	mov    $0x3,%eax
  800e34:	89 cb                	mov    %ecx,%ebx
  800e36:	89 cf                	mov    %ecx,%edi
  800e38:	89 ce                	mov    %ecx,%esi
  800e3a:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e3c:	85 c0                	test   %eax,%eax
  800e3e:	7f 08                	jg     800e48 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e43:	5b                   	pop    %ebx
  800e44:	5e                   	pop    %esi
  800e45:	5f                   	pop    %edi
  800e46:	5d                   	pop    %ebp
  800e47:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e48:	83 ec 0c             	sub    $0xc,%esp
  800e4b:	50                   	push   %eax
  800e4c:	6a 03                	push   $0x3
  800e4e:	68 e0 17 80 00       	push   $0x8017e0
  800e53:	6a 4c                	push   $0x4c
  800e55:	68 fd 17 80 00       	push   $0x8017fd
  800e5a:	e8 4b f4 ff ff       	call   8002aa <_panic>

00800e5f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e5f:	55                   	push   %ebp
  800e60:	89 e5                	mov    %esp,%ebp
  800e62:	57                   	push   %edi
  800e63:	56                   	push   %esi
  800e64:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e65:	ba 00 00 00 00       	mov    $0x0,%edx
  800e6a:	b8 02 00 00 00       	mov    $0x2,%eax
  800e6f:	89 d1                	mov    %edx,%ecx
  800e71:	89 d3                	mov    %edx,%ebx
  800e73:	89 d7                	mov    %edx,%edi
  800e75:	89 d6                	mov    %edx,%esi
  800e77:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e79:	5b                   	pop    %ebx
  800e7a:	5e                   	pop    %esi
  800e7b:	5f                   	pop    %edi
  800e7c:	5d                   	pop    %ebp
  800e7d:	c3                   	ret    

00800e7e <sys_yield>:

void
sys_yield(void)
{
  800e7e:	55                   	push   %ebp
  800e7f:	89 e5                	mov    %esp,%ebp
  800e81:	57                   	push   %edi
  800e82:	56                   	push   %esi
  800e83:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e84:	ba 00 00 00 00       	mov    $0x0,%edx
  800e89:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e8e:	89 d1                	mov    %edx,%ecx
  800e90:	89 d3                	mov    %edx,%ebx
  800e92:	89 d7                	mov    %edx,%edi
  800e94:	89 d6                	mov    %edx,%esi
  800e96:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e98:	5b                   	pop    %ebx
  800e99:	5e                   	pop    %esi
  800e9a:	5f                   	pop    %edi
  800e9b:	5d                   	pop    %ebp
  800e9c:	c3                   	ret    

00800e9d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e9d:	55                   	push   %ebp
  800e9e:	89 e5                	mov    %esp,%ebp
  800ea0:	57                   	push   %edi
  800ea1:	56                   	push   %esi
  800ea2:	53                   	push   %ebx
  800ea3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea6:	be 00 00 00 00       	mov    $0x0,%esi
  800eab:	8b 55 08             	mov    0x8(%ebp),%edx
  800eae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb1:	b8 04 00 00 00       	mov    $0x4,%eax
  800eb6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eb9:	89 f7                	mov    %esi,%edi
  800ebb:	cd 30                	int    $0x30
	if (check && ret > 0)
  800ebd:	85 c0                	test   %eax,%eax
  800ebf:	7f 08                	jg     800ec9 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ec1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec4:	5b                   	pop    %ebx
  800ec5:	5e                   	pop    %esi
  800ec6:	5f                   	pop    %edi
  800ec7:	5d                   	pop    %ebp
  800ec8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec9:	83 ec 0c             	sub    $0xc,%esp
  800ecc:	50                   	push   %eax
  800ecd:	6a 04                	push   $0x4
  800ecf:	68 e0 17 80 00       	push   $0x8017e0
  800ed4:	6a 4c                	push   $0x4c
  800ed6:	68 fd 17 80 00       	push   $0x8017fd
  800edb:	e8 ca f3 ff ff       	call   8002aa <_panic>

00800ee0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
  800ee3:	57                   	push   %edi
  800ee4:	56                   	push   %esi
  800ee5:	53                   	push   %ebx
  800ee6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee9:	8b 55 08             	mov    0x8(%ebp),%edx
  800eec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eef:	b8 05 00 00 00       	mov    $0x5,%eax
  800ef4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ef7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800efa:	8b 75 18             	mov    0x18(%ebp),%esi
  800efd:	cd 30                	int    $0x30
	if (check && ret > 0)
  800eff:	85 c0                	test   %eax,%eax
  800f01:	7f 08                	jg     800f0b <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f03:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f06:	5b                   	pop    %ebx
  800f07:	5e                   	pop    %esi
  800f08:	5f                   	pop    %edi
  800f09:	5d                   	pop    %ebp
  800f0a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f0b:	83 ec 0c             	sub    $0xc,%esp
  800f0e:	50                   	push   %eax
  800f0f:	6a 05                	push   $0x5
  800f11:	68 e0 17 80 00       	push   $0x8017e0
  800f16:	6a 4c                	push   $0x4c
  800f18:	68 fd 17 80 00       	push   $0x8017fd
  800f1d:	e8 88 f3 ff ff       	call   8002aa <_panic>

00800f22 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f22:	55                   	push   %ebp
  800f23:	89 e5                	mov    %esp,%ebp
  800f25:	57                   	push   %edi
  800f26:	56                   	push   %esi
  800f27:	53                   	push   %ebx
  800f28:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f2b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f30:	8b 55 08             	mov    0x8(%ebp),%edx
  800f33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f36:	b8 06 00 00 00       	mov    $0x6,%eax
  800f3b:	89 df                	mov    %ebx,%edi
  800f3d:	89 de                	mov    %ebx,%esi
  800f3f:	cd 30                	int    $0x30
	if (check && ret > 0)
  800f41:	85 c0                	test   %eax,%eax
  800f43:	7f 08                	jg     800f4d <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f45:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f48:	5b                   	pop    %ebx
  800f49:	5e                   	pop    %esi
  800f4a:	5f                   	pop    %edi
  800f4b:	5d                   	pop    %ebp
  800f4c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f4d:	83 ec 0c             	sub    $0xc,%esp
  800f50:	50                   	push   %eax
  800f51:	6a 06                	push   $0x6
  800f53:	68 e0 17 80 00       	push   $0x8017e0
  800f58:	6a 4c                	push   $0x4c
  800f5a:	68 fd 17 80 00       	push   $0x8017fd
  800f5f:	e8 46 f3 ff ff       	call   8002aa <_panic>

00800f64 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f64:	55                   	push   %ebp
  800f65:	89 e5                	mov    %esp,%ebp
  800f67:	57                   	push   %edi
  800f68:	56                   	push   %esi
  800f69:	53                   	push   %ebx
  800f6a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f6d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f72:	8b 55 08             	mov    0x8(%ebp),%edx
  800f75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f78:	b8 08 00 00 00       	mov    $0x8,%eax
  800f7d:	89 df                	mov    %ebx,%edi
  800f7f:	89 de                	mov    %ebx,%esi
  800f81:	cd 30                	int    $0x30
	if (check && ret > 0)
  800f83:	85 c0                	test   %eax,%eax
  800f85:	7f 08                	jg     800f8f <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f8a:	5b                   	pop    %ebx
  800f8b:	5e                   	pop    %esi
  800f8c:	5f                   	pop    %edi
  800f8d:	5d                   	pop    %ebp
  800f8e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8f:	83 ec 0c             	sub    $0xc,%esp
  800f92:	50                   	push   %eax
  800f93:	6a 08                	push   $0x8
  800f95:	68 e0 17 80 00       	push   $0x8017e0
  800f9a:	6a 4c                	push   $0x4c
  800f9c:	68 fd 17 80 00       	push   $0x8017fd
  800fa1:	e8 04 f3 ff ff       	call   8002aa <_panic>

00800fa6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fa6:	55                   	push   %ebp
  800fa7:	89 e5                	mov    %esp,%ebp
  800fa9:	57                   	push   %edi
  800faa:	56                   	push   %esi
  800fab:	53                   	push   %ebx
  800fac:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800faf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fba:	b8 09 00 00 00       	mov    $0x9,%eax
  800fbf:	89 df                	mov    %ebx,%edi
  800fc1:	89 de                	mov    %ebx,%esi
  800fc3:	cd 30                	int    $0x30
	if (check && ret > 0)
  800fc5:	85 c0                	test   %eax,%eax
  800fc7:	7f 08                	jg     800fd1 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fcc:	5b                   	pop    %ebx
  800fcd:	5e                   	pop    %esi
  800fce:	5f                   	pop    %edi
  800fcf:	5d                   	pop    %ebp
  800fd0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd1:	83 ec 0c             	sub    $0xc,%esp
  800fd4:	50                   	push   %eax
  800fd5:	6a 09                	push   $0x9
  800fd7:	68 e0 17 80 00       	push   $0x8017e0
  800fdc:	6a 4c                	push   $0x4c
  800fde:	68 fd 17 80 00       	push   $0x8017fd
  800fe3:	e8 c2 f2 ff ff       	call   8002aa <_panic>

00800fe8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fe8:	55                   	push   %ebp
  800fe9:	89 e5                	mov    %esp,%ebp
  800feb:	57                   	push   %edi
  800fec:	56                   	push   %esi
  800fed:	53                   	push   %ebx
  800fee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ff1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ffc:	b8 0a 00 00 00       	mov    $0xa,%eax
  801001:	89 df                	mov    %ebx,%edi
  801003:	89 de                	mov    %ebx,%esi
  801005:	cd 30                	int    $0x30
	if (check && ret > 0)
  801007:	85 c0                	test   %eax,%eax
  801009:	7f 08                	jg     801013 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80100b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80100e:	5b                   	pop    %ebx
  80100f:	5e                   	pop    %esi
  801010:	5f                   	pop    %edi
  801011:	5d                   	pop    %ebp
  801012:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801013:	83 ec 0c             	sub    $0xc,%esp
  801016:	50                   	push   %eax
  801017:	6a 0a                	push   $0xa
  801019:	68 e0 17 80 00       	push   $0x8017e0
  80101e:	6a 4c                	push   $0x4c
  801020:	68 fd 17 80 00       	push   $0x8017fd
  801025:	e8 80 f2 ff ff       	call   8002aa <_panic>

0080102a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	57                   	push   %edi
  80102e:	56                   	push   %esi
  80102f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801030:	8b 55 08             	mov    0x8(%ebp),%edx
  801033:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801036:	b8 0c 00 00 00       	mov    $0xc,%eax
  80103b:	be 00 00 00 00       	mov    $0x0,%esi
  801040:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801043:	8b 7d 14             	mov    0x14(%ebp),%edi
  801046:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801048:	5b                   	pop    %ebx
  801049:	5e                   	pop    %esi
  80104a:	5f                   	pop    %edi
  80104b:	5d                   	pop    %ebp
  80104c:	c3                   	ret    

0080104d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
  801050:	57                   	push   %edi
  801051:	56                   	push   %esi
  801052:	53                   	push   %ebx
  801053:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801056:	b9 00 00 00 00       	mov    $0x0,%ecx
  80105b:	8b 55 08             	mov    0x8(%ebp),%edx
  80105e:	b8 0d 00 00 00       	mov    $0xd,%eax
  801063:	89 cb                	mov    %ecx,%ebx
  801065:	89 cf                	mov    %ecx,%edi
  801067:	89 ce                	mov    %ecx,%esi
  801069:	cd 30                	int    $0x30
	if (check && ret > 0)
  80106b:	85 c0                	test   %eax,%eax
  80106d:	7f 08                	jg     801077 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80106f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801072:	5b                   	pop    %ebx
  801073:	5e                   	pop    %esi
  801074:	5f                   	pop    %edi
  801075:	5d                   	pop    %ebp
  801076:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801077:	83 ec 0c             	sub    $0xc,%esp
  80107a:	50                   	push   %eax
  80107b:	6a 0d                	push   $0xd
  80107d:	68 e0 17 80 00       	push   $0x8017e0
  801082:	6a 4c                	push   $0x4c
  801084:	68 fd 17 80 00       	push   $0x8017fd
  801089:	e8 1c f2 ff ff       	call   8002aa <_panic>

0080108e <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80108e:	55                   	push   %ebp
  80108f:	89 e5                	mov    %esp,%ebp
  801091:	57                   	push   %edi
  801092:	56                   	push   %esi
  801093:	53                   	push   %ebx
	asm volatile("int %1\n"
  801094:	bb 00 00 00 00       	mov    $0x0,%ebx
  801099:	8b 55 08             	mov    0x8(%ebp),%edx
  80109c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80109f:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010a4:	89 df                	mov    %ebx,%edi
  8010a6:	89 de                	mov    %ebx,%esi
  8010a8:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8010aa:	5b                   	pop    %ebx
  8010ab:	5e                   	pop    %esi
  8010ac:	5f                   	pop    %edi
  8010ad:	5d                   	pop    %ebp
  8010ae:	c3                   	ret    

008010af <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8010af:	55                   	push   %ebp
  8010b0:	89 e5                	mov    %esp,%ebp
  8010b2:	57                   	push   %edi
  8010b3:	56                   	push   %esi
  8010b4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010b5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8010bd:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010c2:	89 cb                	mov    %ecx,%ebx
  8010c4:	89 cf                	mov    %ecx,%edi
  8010c6:	89 ce                	mov    %ecx,%esi
  8010c8:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8010ca:	5b                   	pop    %ebx
  8010cb:	5e                   	pop    %esi
  8010cc:	5f                   	pop    %edi
  8010cd:	5d                   	pop    %ebp
  8010ce:	c3                   	ret    
  8010cf:	90                   	nop

008010d0 <__udivdi3>:
  8010d0:	55                   	push   %ebp
  8010d1:	57                   	push   %edi
  8010d2:	56                   	push   %esi
  8010d3:	53                   	push   %ebx
  8010d4:	83 ec 1c             	sub    $0x1c,%esp
  8010d7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8010db:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8010df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8010e3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8010e7:	85 d2                	test   %edx,%edx
  8010e9:	75 4d                	jne    801138 <__udivdi3+0x68>
  8010eb:	39 f3                	cmp    %esi,%ebx
  8010ed:	76 19                	jbe    801108 <__udivdi3+0x38>
  8010ef:	31 ff                	xor    %edi,%edi
  8010f1:	89 e8                	mov    %ebp,%eax
  8010f3:	89 f2                	mov    %esi,%edx
  8010f5:	f7 f3                	div    %ebx
  8010f7:	89 fa                	mov    %edi,%edx
  8010f9:	83 c4 1c             	add    $0x1c,%esp
  8010fc:	5b                   	pop    %ebx
  8010fd:	5e                   	pop    %esi
  8010fe:	5f                   	pop    %edi
  8010ff:	5d                   	pop    %ebp
  801100:	c3                   	ret    
  801101:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801108:	89 d9                	mov    %ebx,%ecx
  80110a:	85 db                	test   %ebx,%ebx
  80110c:	75 0b                	jne    801119 <__udivdi3+0x49>
  80110e:	b8 01 00 00 00       	mov    $0x1,%eax
  801113:	31 d2                	xor    %edx,%edx
  801115:	f7 f3                	div    %ebx
  801117:	89 c1                	mov    %eax,%ecx
  801119:	31 d2                	xor    %edx,%edx
  80111b:	89 f0                	mov    %esi,%eax
  80111d:	f7 f1                	div    %ecx
  80111f:	89 c6                	mov    %eax,%esi
  801121:	89 e8                	mov    %ebp,%eax
  801123:	89 f7                	mov    %esi,%edi
  801125:	f7 f1                	div    %ecx
  801127:	89 fa                	mov    %edi,%edx
  801129:	83 c4 1c             	add    $0x1c,%esp
  80112c:	5b                   	pop    %ebx
  80112d:	5e                   	pop    %esi
  80112e:	5f                   	pop    %edi
  80112f:	5d                   	pop    %ebp
  801130:	c3                   	ret    
  801131:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801138:	39 f2                	cmp    %esi,%edx
  80113a:	77 1c                	ja     801158 <__udivdi3+0x88>
  80113c:	0f bd fa             	bsr    %edx,%edi
  80113f:	83 f7 1f             	xor    $0x1f,%edi
  801142:	75 2c                	jne    801170 <__udivdi3+0xa0>
  801144:	39 f2                	cmp    %esi,%edx
  801146:	72 06                	jb     80114e <__udivdi3+0x7e>
  801148:	31 c0                	xor    %eax,%eax
  80114a:	39 eb                	cmp    %ebp,%ebx
  80114c:	77 a9                	ja     8010f7 <__udivdi3+0x27>
  80114e:	b8 01 00 00 00       	mov    $0x1,%eax
  801153:	eb a2                	jmp    8010f7 <__udivdi3+0x27>
  801155:	8d 76 00             	lea    0x0(%esi),%esi
  801158:	31 ff                	xor    %edi,%edi
  80115a:	31 c0                	xor    %eax,%eax
  80115c:	89 fa                	mov    %edi,%edx
  80115e:	83 c4 1c             	add    $0x1c,%esp
  801161:	5b                   	pop    %ebx
  801162:	5e                   	pop    %esi
  801163:	5f                   	pop    %edi
  801164:	5d                   	pop    %ebp
  801165:	c3                   	ret    
  801166:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80116d:	8d 76 00             	lea    0x0(%esi),%esi
  801170:	89 f9                	mov    %edi,%ecx
  801172:	b8 20 00 00 00       	mov    $0x20,%eax
  801177:	29 f8                	sub    %edi,%eax
  801179:	d3 e2                	shl    %cl,%edx
  80117b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80117f:	89 c1                	mov    %eax,%ecx
  801181:	89 da                	mov    %ebx,%edx
  801183:	d3 ea                	shr    %cl,%edx
  801185:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801189:	09 d1                	or     %edx,%ecx
  80118b:	89 f2                	mov    %esi,%edx
  80118d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801191:	89 f9                	mov    %edi,%ecx
  801193:	d3 e3                	shl    %cl,%ebx
  801195:	89 c1                	mov    %eax,%ecx
  801197:	d3 ea                	shr    %cl,%edx
  801199:	89 f9                	mov    %edi,%ecx
  80119b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80119f:	89 eb                	mov    %ebp,%ebx
  8011a1:	d3 e6                	shl    %cl,%esi
  8011a3:	89 c1                	mov    %eax,%ecx
  8011a5:	d3 eb                	shr    %cl,%ebx
  8011a7:	09 de                	or     %ebx,%esi
  8011a9:	89 f0                	mov    %esi,%eax
  8011ab:	f7 74 24 08          	divl   0x8(%esp)
  8011af:	89 d6                	mov    %edx,%esi
  8011b1:	89 c3                	mov    %eax,%ebx
  8011b3:	f7 64 24 0c          	mull   0xc(%esp)
  8011b7:	39 d6                	cmp    %edx,%esi
  8011b9:	72 15                	jb     8011d0 <__udivdi3+0x100>
  8011bb:	89 f9                	mov    %edi,%ecx
  8011bd:	d3 e5                	shl    %cl,%ebp
  8011bf:	39 c5                	cmp    %eax,%ebp
  8011c1:	73 04                	jae    8011c7 <__udivdi3+0xf7>
  8011c3:	39 d6                	cmp    %edx,%esi
  8011c5:	74 09                	je     8011d0 <__udivdi3+0x100>
  8011c7:	89 d8                	mov    %ebx,%eax
  8011c9:	31 ff                	xor    %edi,%edi
  8011cb:	e9 27 ff ff ff       	jmp    8010f7 <__udivdi3+0x27>
  8011d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8011d3:	31 ff                	xor    %edi,%edi
  8011d5:	e9 1d ff ff ff       	jmp    8010f7 <__udivdi3+0x27>
  8011da:	66 90                	xchg   %ax,%ax
  8011dc:	66 90                	xchg   %ax,%ax
  8011de:	66 90                	xchg   %ax,%ax

008011e0 <__umoddi3>:
  8011e0:	55                   	push   %ebp
  8011e1:	57                   	push   %edi
  8011e2:	56                   	push   %esi
  8011e3:	53                   	push   %ebx
  8011e4:	83 ec 1c             	sub    $0x1c,%esp
  8011e7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8011eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8011ef:	8b 74 24 30          	mov    0x30(%esp),%esi
  8011f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8011f7:	89 da                	mov    %ebx,%edx
  8011f9:	85 c0                	test   %eax,%eax
  8011fb:	75 43                	jne    801240 <__umoddi3+0x60>
  8011fd:	39 df                	cmp    %ebx,%edi
  8011ff:	76 17                	jbe    801218 <__umoddi3+0x38>
  801201:	89 f0                	mov    %esi,%eax
  801203:	f7 f7                	div    %edi
  801205:	89 d0                	mov    %edx,%eax
  801207:	31 d2                	xor    %edx,%edx
  801209:	83 c4 1c             	add    $0x1c,%esp
  80120c:	5b                   	pop    %ebx
  80120d:	5e                   	pop    %esi
  80120e:	5f                   	pop    %edi
  80120f:	5d                   	pop    %ebp
  801210:	c3                   	ret    
  801211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801218:	89 fd                	mov    %edi,%ebp
  80121a:	85 ff                	test   %edi,%edi
  80121c:	75 0b                	jne    801229 <__umoddi3+0x49>
  80121e:	b8 01 00 00 00       	mov    $0x1,%eax
  801223:	31 d2                	xor    %edx,%edx
  801225:	f7 f7                	div    %edi
  801227:	89 c5                	mov    %eax,%ebp
  801229:	89 d8                	mov    %ebx,%eax
  80122b:	31 d2                	xor    %edx,%edx
  80122d:	f7 f5                	div    %ebp
  80122f:	89 f0                	mov    %esi,%eax
  801231:	f7 f5                	div    %ebp
  801233:	89 d0                	mov    %edx,%eax
  801235:	eb d0                	jmp    801207 <__umoddi3+0x27>
  801237:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80123e:	66 90                	xchg   %ax,%ax
  801240:	89 f1                	mov    %esi,%ecx
  801242:	39 d8                	cmp    %ebx,%eax
  801244:	76 0a                	jbe    801250 <__umoddi3+0x70>
  801246:	89 f0                	mov    %esi,%eax
  801248:	83 c4 1c             	add    $0x1c,%esp
  80124b:	5b                   	pop    %ebx
  80124c:	5e                   	pop    %esi
  80124d:	5f                   	pop    %edi
  80124e:	5d                   	pop    %ebp
  80124f:	c3                   	ret    
  801250:	0f bd e8             	bsr    %eax,%ebp
  801253:	83 f5 1f             	xor    $0x1f,%ebp
  801256:	75 20                	jne    801278 <__umoddi3+0x98>
  801258:	39 d8                	cmp    %ebx,%eax
  80125a:	0f 82 b0 00 00 00    	jb     801310 <__umoddi3+0x130>
  801260:	39 f7                	cmp    %esi,%edi
  801262:	0f 86 a8 00 00 00    	jbe    801310 <__umoddi3+0x130>
  801268:	89 c8                	mov    %ecx,%eax
  80126a:	83 c4 1c             	add    $0x1c,%esp
  80126d:	5b                   	pop    %ebx
  80126e:	5e                   	pop    %esi
  80126f:	5f                   	pop    %edi
  801270:	5d                   	pop    %ebp
  801271:	c3                   	ret    
  801272:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801278:	89 e9                	mov    %ebp,%ecx
  80127a:	ba 20 00 00 00       	mov    $0x20,%edx
  80127f:	29 ea                	sub    %ebp,%edx
  801281:	d3 e0                	shl    %cl,%eax
  801283:	89 44 24 08          	mov    %eax,0x8(%esp)
  801287:	89 d1                	mov    %edx,%ecx
  801289:	89 f8                	mov    %edi,%eax
  80128b:	d3 e8                	shr    %cl,%eax
  80128d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801291:	89 54 24 04          	mov    %edx,0x4(%esp)
  801295:	8b 54 24 04          	mov    0x4(%esp),%edx
  801299:	09 c1                	or     %eax,%ecx
  80129b:	89 d8                	mov    %ebx,%eax
  80129d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8012a1:	89 e9                	mov    %ebp,%ecx
  8012a3:	d3 e7                	shl    %cl,%edi
  8012a5:	89 d1                	mov    %edx,%ecx
  8012a7:	d3 e8                	shr    %cl,%eax
  8012a9:	89 e9                	mov    %ebp,%ecx
  8012ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8012af:	d3 e3                	shl    %cl,%ebx
  8012b1:	89 c7                	mov    %eax,%edi
  8012b3:	89 d1                	mov    %edx,%ecx
  8012b5:	89 f0                	mov    %esi,%eax
  8012b7:	d3 e8                	shr    %cl,%eax
  8012b9:	89 e9                	mov    %ebp,%ecx
  8012bb:	89 fa                	mov    %edi,%edx
  8012bd:	d3 e6                	shl    %cl,%esi
  8012bf:	09 d8                	or     %ebx,%eax
  8012c1:	f7 74 24 08          	divl   0x8(%esp)
  8012c5:	89 d1                	mov    %edx,%ecx
  8012c7:	89 f3                	mov    %esi,%ebx
  8012c9:	f7 64 24 0c          	mull   0xc(%esp)
  8012cd:	89 c6                	mov    %eax,%esi
  8012cf:	89 d7                	mov    %edx,%edi
  8012d1:	39 d1                	cmp    %edx,%ecx
  8012d3:	72 06                	jb     8012db <__umoddi3+0xfb>
  8012d5:	75 10                	jne    8012e7 <__umoddi3+0x107>
  8012d7:	39 c3                	cmp    %eax,%ebx
  8012d9:	73 0c                	jae    8012e7 <__umoddi3+0x107>
  8012db:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8012df:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8012e3:	89 d7                	mov    %edx,%edi
  8012e5:	89 c6                	mov    %eax,%esi
  8012e7:	89 ca                	mov    %ecx,%edx
  8012e9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8012ee:	29 f3                	sub    %esi,%ebx
  8012f0:	19 fa                	sbb    %edi,%edx
  8012f2:	89 d0                	mov    %edx,%eax
  8012f4:	d3 e0                	shl    %cl,%eax
  8012f6:	89 e9                	mov    %ebp,%ecx
  8012f8:	d3 eb                	shr    %cl,%ebx
  8012fa:	d3 ea                	shr    %cl,%edx
  8012fc:	09 d8                	or     %ebx,%eax
  8012fe:	83 c4 1c             	add    $0x1c,%esp
  801301:	5b                   	pop    %ebx
  801302:	5e                   	pop    %esi
  801303:	5f                   	pop    %edi
  801304:	5d                   	pop    %ebp
  801305:	c3                   	ret    
  801306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80130d:	8d 76 00             	lea    0x0(%esi),%esi
  801310:	89 da                	mov    %ebx,%edx
  801312:	29 fe                	sub    %edi,%esi
  801314:	19 c2                	sbb    %eax,%edx
  801316:	89 f1                	mov    %esi,%ecx
  801318:	89 c8                	mov    %ecx,%eax
  80131a:	e9 4b ff ff ff       	jmp    80126a <__umoddi3+0x8a>
