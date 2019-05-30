
obj/user/testpiperace2.debug:     file format elf32-i386


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
  80002c:	e8 a2 01 00 00       	call   8001d3 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 28             	sub    $0x28,%esp
	int p[2], r, i;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for pipeisclosed race...\n");
  80003c:	68 20 25 80 00       	push   $0x802520
  800041:	e8 c3 02 00 00       	call   800309 <cprintf>
	if ((r = pipe(p)) < 0)
  800046:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800049:	89 04 24             	mov    %eax,(%esp)
  80004c:	e8 af 1d 00 00       	call   801e00 <pipe>
  800051:	83 c4 10             	add    $0x10,%esp
  800054:	85 c0                	test   %eax,%eax
  800056:	78 5e                	js     8000b6 <umain+0x83>
		panic("pipe: %e", r);
	if ((r = fork()) < 0)
  800058:	e8 f2 10 00 00       	call   80114f <fork>
  80005d:	89 c7                	mov    %eax,%edi
  80005f:	85 c0                	test   %eax,%eax
  800061:	78 65                	js     8000c8 <umain+0x95>
		panic("fork: %e", r);
	if (r == 0) {
  800063:	74 75                	je     8000da <umain+0xa7>
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  800065:	89 fb                	mov    %edi,%ebx
  800067:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (kid->env_status == ENV_RUNNABLE)
  80006d:	69 db 84 00 00 00    	imul   $0x84,%ebx,%ebx
  800073:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800079:	8b 43 54             	mov    0x54(%ebx),%eax
  80007c:	83 f8 02             	cmp    $0x2,%eax
  80007f:	0f 85 d1 00 00 00    	jne    800156 <umain+0x123>
		if (pipeisclosed(p[0]) != 0) {
  800085:	83 ec 0c             	sub    $0xc,%esp
  800088:	ff 75 e0             	pushl  -0x20(%ebp)
  80008b:	e8 ba 1e 00 00       	call   801f4a <pipeisclosed>
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	85 c0                	test   %eax,%eax
  800095:	74 e2                	je     800079 <umain+0x46>
			cprintf("\nRACE: pipe appears closed\n");
  800097:	83 ec 0c             	sub    $0xc,%esp
  80009a:	68 99 25 80 00       	push   $0x802599
  80009f:	e8 65 02 00 00       	call   800309 <cprintf>
			sys_env_destroy(r);
  8000a4:	89 3c 24             	mov    %edi,(%esp)
  8000a7:	e8 f6 0c 00 00       	call   800da2 <sys_env_destroy>
			exit();
  8000ac:	e8 6b 01 00 00       	call   80021c <exit>
  8000b1:	83 c4 10             	add    $0x10,%esp
  8000b4:	eb c3                	jmp    800079 <umain+0x46>
		panic("pipe: %e", r);
  8000b6:	50                   	push   %eax
  8000b7:	68 6e 25 80 00       	push   $0x80256e
  8000bc:	6a 0d                	push   $0xd
  8000be:	68 77 25 80 00       	push   $0x802577
  8000c3:	e8 66 01 00 00       	call   80022e <_panic>
		panic("fork: %e", r);
  8000c8:	50                   	push   %eax
  8000c9:	68 8c 25 80 00       	push   $0x80258c
  8000ce:	6a 0f                	push   $0xf
  8000d0:	68 77 25 80 00       	push   $0x802577
  8000d5:	e8 54 01 00 00       	call   80022e <_panic>
		close(p[1]);
  8000da:	83 ec 0c             	sub    $0xc,%esp
  8000dd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000e0:	e8 30 15 00 00       	call   801615 <close>
  8000e5:	83 c4 10             	add    $0x10,%esp
		for (i = 0; i < 200; i++) {
  8000e8:	89 fb                	mov    %edi,%ebx
			if (i % 10 == 0)
  8000ea:	be 67 66 66 66       	mov    $0x66666667,%esi
  8000ef:	eb 42                	jmp    800133 <umain+0x100>
				cprintf("%d.", i);
  8000f1:	83 ec 08             	sub    $0x8,%esp
  8000f4:	53                   	push   %ebx
  8000f5:	68 95 25 80 00       	push   $0x802595
  8000fa:	e8 0a 02 00 00       	call   800309 <cprintf>
  8000ff:	83 c4 10             	add    $0x10,%esp
			dup(p[0], 10);
  800102:	83 ec 08             	sub    $0x8,%esp
  800105:	6a 0a                	push   $0xa
  800107:	ff 75 e0             	pushl  -0x20(%ebp)
  80010a:	e8 58 15 00 00       	call   801667 <dup>
			sys_yield();
  80010f:	e8 ee 0c 00 00       	call   800e02 <sys_yield>
			close(10);
  800114:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  80011b:	e8 f5 14 00 00       	call   801615 <close>
			sys_yield();
  800120:	e8 dd 0c 00 00       	call   800e02 <sys_yield>
		for (i = 0; i < 200; i++) {
  800125:	83 c3 01             	add    $0x1,%ebx
  800128:	83 c4 10             	add    $0x10,%esp
  80012b:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
  800131:	74 19                	je     80014c <umain+0x119>
			if (i % 10 == 0)
  800133:	89 d8                	mov    %ebx,%eax
  800135:	f7 ee                	imul   %esi
  800137:	c1 fa 02             	sar    $0x2,%edx
  80013a:	89 d8                	mov    %ebx,%eax
  80013c:	c1 f8 1f             	sar    $0x1f,%eax
  80013f:	29 c2                	sub    %eax,%edx
  800141:	8d 04 92             	lea    (%edx,%edx,4),%eax
  800144:	01 c0                	add    %eax,%eax
  800146:	39 c3                	cmp    %eax,%ebx
  800148:	75 b8                	jne    800102 <umain+0xcf>
  80014a:	eb a5                	jmp    8000f1 <umain+0xbe>
		exit();
  80014c:	e8 cb 00 00 00       	call   80021c <exit>
  800151:	e9 0f ff ff ff       	jmp    800065 <umain+0x32>
		}
	cprintf("child done with loop\n");
  800156:	83 ec 0c             	sub    $0xc,%esp
  800159:	68 b5 25 80 00       	push   $0x8025b5
  80015e:	e8 a6 01 00 00       	call   800309 <cprintf>
	if (pipeisclosed(p[0]))
  800163:	83 c4 04             	add    $0x4,%esp
  800166:	ff 75 e0             	pushl  -0x20(%ebp)
  800169:	e8 dc 1d 00 00       	call   801f4a <pipeisclosed>
  80016e:	83 c4 10             	add    $0x10,%esp
  800171:	85 c0                	test   %eax,%eax
  800173:	75 38                	jne    8001ad <umain+0x17a>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  800175:	83 ec 08             	sub    $0x8,%esp
  800178:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80017b:	50                   	push   %eax
  80017c:	ff 75 e0             	pushl  -0x20(%ebp)
  80017f:	e8 64 13 00 00       	call   8014e8 <fd_lookup>
  800184:	83 c4 10             	add    $0x10,%esp
  800187:	85 c0                	test   %eax,%eax
  800189:	78 36                	js     8001c1 <umain+0x18e>
		panic("cannot look up p[0]: %e", r);
	(void) fd2data(fd);
  80018b:	83 ec 0c             	sub    $0xc,%esp
  80018e:	ff 75 dc             	pushl  -0x24(%ebp)
  800191:	e8 e9 12 00 00       	call   80147f <fd2data>
	cprintf("race didn't happen\n");
  800196:	c7 04 24 e3 25 80 00 	movl   $0x8025e3,(%esp)
  80019d:	e8 67 01 00 00       	call   800309 <cprintf>
}
  8001a2:	83 c4 10             	add    $0x10,%esp
  8001a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001a8:	5b                   	pop    %ebx
  8001a9:	5e                   	pop    %esi
  8001aa:	5f                   	pop    %edi
  8001ab:	5d                   	pop    %ebp
  8001ac:	c3                   	ret    
		panic("somehow the other end of p[0] got closed!");
  8001ad:	83 ec 04             	sub    $0x4,%esp
  8001b0:	68 44 25 80 00       	push   $0x802544
  8001b5:	6a 40                	push   $0x40
  8001b7:	68 77 25 80 00       	push   $0x802577
  8001bc:	e8 6d 00 00 00       	call   80022e <_panic>
		panic("cannot look up p[0]: %e", r);
  8001c1:	50                   	push   %eax
  8001c2:	68 cb 25 80 00       	push   $0x8025cb
  8001c7:	6a 42                	push   $0x42
  8001c9:	68 77 25 80 00       	push   $0x802577
  8001ce:	e8 5b 00 00 00       	call   80022e <_panic>

008001d3 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001d3:	55                   	push   %ebp
  8001d4:	89 e5                	mov    %esp,%ebp
  8001d6:	56                   	push   %esi
  8001d7:	53                   	push   %ebx
  8001d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001db:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  8001de:	e8 00 0c 00 00       	call   800de3 <sys_getenvid>
  8001e3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001e8:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8001ee:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001f3:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001f8:	85 db                	test   %ebx,%ebx
  8001fa:	7e 07                	jle    800203 <libmain+0x30>
		binaryname = argv[0];
  8001fc:	8b 06                	mov    (%esi),%eax
  8001fe:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800203:	83 ec 08             	sub    $0x8,%esp
  800206:	56                   	push   %esi
  800207:	53                   	push   %ebx
  800208:	e8 26 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80020d:	e8 0a 00 00 00       	call   80021c <exit>
}
  800212:	83 c4 10             	add    $0x10,%esp
  800215:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800218:	5b                   	pop    %ebx
  800219:	5e                   	pop    %esi
  80021a:	5d                   	pop    %ebp
  80021b:	c3                   	ret    

0080021c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80021c:	55                   	push   %ebp
  80021d:	89 e5                	mov    %esp,%ebp
  80021f:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800222:	6a 00                	push   $0x0
  800224:	e8 79 0b 00 00       	call   800da2 <sys_env_destroy>
}
  800229:	83 c4 10             	add    $0x10,%esp
  80022c:	c9                   	leave  
  80022d:	c3                   	ret    

0080022e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80022e:	55                   	push   %ebp
  80022f:	89 e5                	mov    %esp,%ebp
  800231:	56                   	push   %esi
  800232:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800233:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800236:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80023c:	e8 a2 0b 00 00       	call   800de3 <sys_getenvid>
  800241:	83 ec 0c             	sub    $0xc,%esp
  800244:	ff 75 0c             	pushl  0xc(%ebp)
  800247:	ff 75 08             	pushl  0x8(%ebp)
  80024a:	56                   	push   %esi
  80024b:	50                   	push   %eax
  80024c:	68 04 26 80 00       	push   $0x802604
  800251:	e8 b3 00 00 00       	call   800309 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800256:	83 c4 18             	add    $0x18,%esp
  800259:	53                   	push   %ebx
  80025a:	ff 75 10             	pushl  0x10(%ebp)
  80025d:	e8 56 00 00 00       	call   8002b8 <vcprintf>
	cprintf("\n");
  800262:	c7 04 24 d5 29 80 00 	movl   $0x8029d5,(%esp)
  800269:	e8 9b 00 00 00       	call   800309 <cprintf>
  80026e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800271:	cc                   	int3   
  800272:	eb fd                	jmp    800271 <_panic+0x43>

00800274 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	53                   	push   %ebx
  800278:	83 ec 04             	sub    $0x4,%esp
  80027b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80027e:	8b 13                	mov    (%ebx),%edx
  800280:	8d 42 01             	lea    0x1(%edx),%eax
  800283:	89 03                	mov    %eax,(%ebx)
  800285:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800288:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80028c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800291:	74 09                	je     80029c <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800293:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800297:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80029a:	c9                   	leave  
  80029b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80029c:	83 ec 08             	sub    $0x8,%esp
  80029f:	68 ff 00 00 00       	push   $0xff
  8002a4:	8d 43 08             	lea    0x8(%ebx),%eax
  8002a7:	50                   	push   %eax
  8002a8:	e8 b8 0a 00 00       	call   800d65 <sys_cputs>
		b->idx = 0;
  8002ad:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002b3:	83 c4 10             	add    $0x10,%esp
  8002b6:	eb db                	jmp    800293 <putch+0x1f>

008002b8 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002b8:	55                   	push   %ebp
  8002b9:	89 e5                	mov    %esp,%ebp
  8002bb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002c1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002c8:	00 00 00 
	b.cnt = 0;
  8002cb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002d2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002d5:	ff 75 0c             	pushl  0xc(%ebp)
  8002d8:	ff 75 08             	pushl  0x8(%ebp)
  8002db:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002e1:	50                   	push   %eax
  8002e2:	68 74 02 80 00       	push   $0x800274
  8002e7:	e8 4a 01 00 00       	call   800436 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002ec:	83 c4 08             	add    $0x8,%esp
  8002ef:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002f5:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002fb:	50                   	push   %eax
  8002fc:	e8 64 0a 00 00       	call   800d65 <sys_cputs>

	return b.cnt;
}
  800301:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800307:	c9                   	leave  
  800308:	c3                   	ret    

00800309 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800309:	55                   	push   %ebp
  80030a:	89 e5                	mov    %esp,%ebp
  80030c:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80030f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800312:	50                   	push   %eax
  800313:	ff 75 08             	pushl  0x8(%ebp)
  800316:	e8 9d ff ff ff       	call   8002b8 <vcprintf>
	va_end(ap);

	return cnt;
}
  80031b:	c9                   	leave  
  80031c:	c3                   	ret    

0080031d <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80031d:	55                   	push   %ebp
  80031e:	89 e5                	mov    %esp,%ebp
  800320:	57                   	push   %edi
  800321:	56                   	push   %esi
  800322:	53                   	push   %ebx
  800323:	83 ec 1c             	sub    $0x1c,%esp
  800326:	89 c6                	mov    %eax,%esi
  800328:	89 d7                	mov    %edx,%edi
  80032a:	8b 45 08             	mov    0x8(%ebp),%eax
  80032d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800330:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800333:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800336:	8b 45 10             	mov    0x10(%ebp),%eax
  800339:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  80033c:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800340:	74 2c                	je     80036e <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800342:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800345:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80034c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80034f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800352:	39 c2                	cmp    %eax,%edx
  800354:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800357:	73 43                	jae    80039c <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800359:	83 eb 01             	sub    $0x1,%ebx
  80035c:	85 db                	test   %ebx,%ebx
  80035e:	7e 6c                	jle    8003cc <printnum+0xaf>
			putch(padc, putdat);
  800360:	83 ec 08             	sub    $0x8,%esp
  800363:	57                   	push   %edi
  800364:	ff 75 18             	pushl  0x18(%ebp)
  800367:	ff d6                	call   *%esi
  800369:	83 c4 10             	add    $0x10,%esp
  80036c:	eb eb                	jmp    800359 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80036e:	83 ec 0c             	sub    $0xc,%esp
  800371:	6a 20                	push   $0x20
  800373:	6a 00                	push   $0x0
  800375:	50                   	push   %eax
  800376:	ff 75 e4             	pushl  -0x1c(%ebp)
  800379:	ff 75 e0             	pushl  -0x20(%ebp)
  80037c:	89 fa                	mov    %edi,%edx
  80037e:	89 f0                	mov    %esi,%eax
  800380:	e8 98 ff ff ff       	call   80031d <printnum>
		while (--width > 0)
  800385:	83 c4 20             	add    $0x20,%esp
  800388:	83 eb 01             	sub    $0x1,%ebx
  80038b:	85 db                	test   %ebx,%ebx
  80038d:	7e 65                	jle    8003f4 <printnum+0xd7>
			putch(' ', putdat);
  80038f:	83 ec 08             	sub    $0x8,%esp
  800392:	57                   	push   %edi
  800393:	6a 20                	push   $0x20
  800395:	ff d6                	call   *%esi
  800397:	83 c4 10             	add    $0x10,%esp
  80039a:	eb ec                	jmp    800388 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80039c:	83 ec 0c             	sub    $0xc,%esp
  80039f:	ff 75 18             	pushl  0x18(%ebp)
  8003a2:	83 eb 01             	sub    $0x1,%ebx
  8003a5:	53                   	push   %ebx
  8003a6:	50                   	push   %eax
  8003a7:	83 ec 08             	sub    $0x8,%esp
  8003aa:	ff 75 dc             	pushl  -0x24(%ebp)
  8003ad:	ff 75 d8             	pushl  -0x28(%ebp)
  8003b0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003b3:	ff 75 e0             	pushl  -0x20(%ebp)
  8003b6:	e8 05 1f 00 00       	call   8022c0 <__udivdi3>
  8003bb:	83 c4 18             	add    $0x18,%esp
  8003be:	52                   	push   %edx
  8003bf:	50                   	push   %eax
  8003c0:	89 fa                	mov    %edi,%edx
  8003c2:	89 f0                	mov    %esi,%eax
  8003c4:	e8 54 ff ff ff       	call   80031d <printnum>
  8003c9:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003cc:	83 ec 08             	sub    $0x8,%esp
  8003cf:	57                   	push   %edi
  8003d0:	83 ec 04             	sub    $0x4,%esp
  8003d3:	ff 75 dc             	pushl  -0x24(%ebp)
  8003d6:	ff 75 d8             	pushl  -0x28(%ebp)
  8003d9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003dc:	ff 75 e0             	pushl  -0x20(%ebp)
  8003df:	e8 ec 1f 00 00       	call   8023d0 <__umoddi3>
  8003e4:	83 c4 14             	add    $0x14,%esp
  8003e7:	0f be 80 27 26 80 00 	movsbl 0x802627(%eax),%eax
  8003ee:	50                   	push   %eax
  8003ef:	ff d6                	call   *%esi
  8003f1:	83 c4 10             	add    $0x10,%esp
}
  8003f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003f7:	5b                   	pop    %ebx
  8003f8:	5e                   	pop    %esi
  8003f9:	5f                   	pop    %edi
  8003fa:	5d                   	pop    %ebp
  8003fb:	c3                   	ret    

008003fc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003fc:	55                   	push   %ebp
  8003fd:	89 e5                	mov    %esp,%ebp
  8003ff:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800402:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800406:	8b 10                	mov    (%eax),%edx
  800408:	3b 50 04             	cmp    0x4(%eax),%edx
  80040b:	73 0a                	jae    800417 <sprintputch+0x1b>
		*b->buf++ = ch;
  80040d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800410:	89 08                	mov    %ecx,(%eax)
  800412:	8b 45 08             	mov    0x8(%ebp),%eax
  800415:	88 02                	mov    %al,(%edx)
}
  800417:	5d                   	pop    %ebp
  800418:	c3                   	ret    

00800419 <printfmt>:
{
  800419:	55                   	push   %ebp
  80041a:	89 e5                	mov    %esp,%ebp
  80041c:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80041f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800422:	50                   	push   %eax
  800423:	ff 75 10             	pushl  0x10(%ebp)
  800426:	ff 75 0c             	pushl  0xc(%ebp)
  800429:	ff 75 08             	pushl  0x8(%ebp)
  80042c:	e8 05 00 00 00       	call   800436 <vprintfmt>
}
  800431:	83 c4 10             	add    $0x10,%esp
  800434:	c9                   	leave  
  800435:	c3                   	ret    

00800436 <vprintfmt>:
{
  800436:	55                   	push   %ebp
  800437:	89 e5                	mov    %esp,%ebp
  800439:	57                   	push   %edi
  80043a:	56                   	push   %esi
  80043b:	53                   	push   %ebx
  80043c:	83 ec 3c             	sub    $0x3c,%esp
  80043f:	8b 75 08             	mov    0x8(%ebp),%esi
  800442:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800445:	8b 7d 10             	mov    0x10(%ebp),%edi
  800448:	e9 1e 04 00 00       	jmp    80086b <vprintfmt+0x435>
		posflag = 0;
  80044d:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  800454:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800458:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80045f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800466:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80046d:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  800474:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800479:	8d 47 01             	lea    0x1(%edi),%eax
  80047c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80047f:	0f b6 17             	movzbl (%edi),%edx
  800482:	8d 42 dd             	lea    -0x23(%edx),%eax
  800485:	3c 55                	cmp    $0x55,%al
  800487:	0f 87 d9 04 00 00    	ja     800966 <vprintfmt+0x530>
  80048d:	0f b6 c0             	movzbl %al,%eax
  800490:	ff 24 85 00 28 80 00 	jmp    *0x802800(,%eax,4)
  800497:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80049a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80049e:	eb d9                	jmp    800479 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  8004a3:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  8004aa:	eb cd                	jmp    800479 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004ac:	0f b6 d2             	movzbl %dl,%edx
  8004af:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b7:	89 75 08             	mov    %esi,0x8(%ebp)
  8004ba:	eb 0c                	jmp    8004c8 <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  8004bc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8004bf:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  8004c3:	eb b4                	jmp    800479 <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  8004c5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004c8:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004cb:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004cf:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004d2:	8d 72 d0             	lea    -0x30(%edx),%esi
  8004d5:	83 fe 09             	cmp    $0x9,%esi
  8004d8:	76 eb                	jbe    8004c5 <vprintfmt+0x8f>
  8004da:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004dd:	8b 75 08             	mov    0x8(%ebp),%esi
  8004e0:	eb 14                	jmp    8004f6 <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  8004e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e5:	8b 00                	mov    (%eax),%eax
  8004e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ed:	8d 40 04             	lea    0x4(%eax),%eax
  8004f0:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004f6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004fa:	0f 89 79 ff ff ff    	jns    800479 <vprintfmt+0x43>
				width = precision, precision = -1;
  800500:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800503:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800506:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80050d:	e9 67 ff ff ff       	jmp    800479 <vprintfmt+0x43>
  800512:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800515:	85 c0                	test   %eax,%eax
  800517:	0f 48 c1             	cmovs  %ecx,%eax
  80051a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80051d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800520:	e9 54 ff ff ff       	jmp    800479 <vprintfmt+0x43>
  800525:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800528:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80052f:	e9 45 ff ff ff       	jmp    800479 <vprintfmt+0x43>
			lflag++;
  800534:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800538:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80053b:	e9 39 ff ff ff       	jmp    800479 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800540:	8b 45 14             	mov    0x14(%ebp),%eax
  800543:	8d 78 04             	lea    0x4(%eax),%edi
  800546:	83 ec 08             	sub    $0x8,%esp
  800549:	53                   	push   %ebx
  80054a:	ff 30                	pushl  (%eax)
  80054c:	ff d6                	call   *%esi
			break;
  80054e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800551:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800554:	e9 0f 03 00 00       	jmp    800868 <vprintfmt+0x432>
			err = va_arg(ap, int);
  800559:	8b 45 14             	mov    0x14(%ebp),%eax
  80055c:	8d 78 04             	lea    0x4(%eax),%edi
  80055f:	8b 00                	mov    (%eax),%eax
  800561:	99                   	cltd   
  800562:	31 d0                	xor    %edx,%eax
  800564:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800566:	83 f8 0f             	cmp    $0xf,%eax
  800569:	7f 23                	jg     80058e <vprintfmt+0x158>
  80056b:	8b 14 85 60 29 80 00 	mov    0x802960(,%eax,4),%edx
  800572:	85 d2                	test   %edx,%edx
  800574:	74 18                	je     80058e <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  800576:	52                   	push   %edx
  800577:	68 7e 2c 80 00       	push   $0x802c7e
  80057c:	53                   	push   %ebx
  80057d:	56                   	push   %esi
  80057e:	e8 96 fe ff ff       	call   800419 <printfmt>
  800583:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800586:	89 7d 14             	mov    %edi,0x14(%ebp)
  800589:	e9 da 02 00 00       	jmp    800868 <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  80058e:	50                   	push   %eax
  80058f:	68 3f 26 80 00       	push   $0x80263f
  800594:	53                   	push   %ebx
  800595:	56                   	push   %esi
  800596:	e8 7e fe ff ff       	call   800419 <printfmt>
  80059b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80059e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005a1:	e9 c2 02 00 00       	jmp    800868 <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  8005a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a9:	83 c0 04             	add    $0x4,%eax
  8005ac:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8005af:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b2:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8005b4:	85 c9                	test   %ecx,%ecx
  8005b6:	b8 38 26 80 00       	mov    $0x802638,%eax
  8005bb:	0f 45 c1             	cmovne %ecx,%eax
  8005be:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8005c1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005c5:	7e 06                	jle    8005cd <vprintfmt+0x197>
  8005c7:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8005cb:	75 0d                	jne    8005da <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005cd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005d0:	89 c7                	mov    %eax,%edi
  8005d2:	03 45 e0             	add    -0x20(%ebp),%eax
  8005d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005d8:	eb 53                	jmp    80062d <vprintfmt+0x1f7>
  8005da:	83 ec 08             	sub    $0x8,%esp
  8005dd:	ff 75 d8             	pushl  -0x28(%ebp)
  8005e0:	50                   	push   %eax
  8005e1:	e8 28 04 00 00       	call   800a0e <strnlen>
  8005e6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005e9:	29 c1                	sub    %eax,%ecx
  8005eb:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  8005ee:	83 c4 10             	add    $0x10,%esp
  8005f1:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8005f3:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8005f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005fa:	eb 0f                	jmp    80060b <vprintfmt+0x1d5>
					putch(padc, putdat);
  8005fc:	83 ec 08             	sub    $0x8,%esp
  8005ff:	53                   	push   %ebx
  800600:	ff 75 e0             	pushl  -0x20(%ebp)
  800603:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800605:	83 ef 01             	sub    $0x1,%edi
  800608:	83 c4 10             	add    $0x10,%esp
  80060b:	85 ff                	test   %edi,%edi
  80060d:	7f ed                	jg     8005fc <vprintfmt+0x1c6>
  80060f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800612:	85 c9                	test   %ecx,%ecx
  800614:	b8 00 00 00 00       	mov    $0x0,%eax
  800619:	0f 49 c1             	cmovns %ecx,%eax
  80061c:	29 c1                	sub    %eax,%ecx
  80061e:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800621:	eb aa                	jmp    8005cd <vprintfmt+0x197>
					putch(ch, putdat);
  800623:	83 ec 08             	sub    $0x8,%esp
  800626:	53                   	push   %ebx
  800627:	52                   	push   %edx
  800628:	ff d6                	call   *%esi
  80062a:	83 c4 10             	add    $0x10,%esp
  80062d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800630:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800632:	83 c7 01             	add    $0x1,%edi
  800635:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800639:	0f be d0             	movsbl %al,%edx
  80063c:	85 d2                	test   %edx,%edx
  80063e:	74 4b                	je     80068b <vprintfmt+0x255>
  800640:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800644:	78 06                	js     80064c <vprintfmt+0x216>
  800646:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80064a:	78 1e                	js     80066a <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  80064c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800650:	74 d1                	je     800623 <vprintfmt+0x1ed>
  800652:	0f be c0             	movsbl %al,%eax
  800655:	83 e8 20             	sub    $0x20,%eax
  800658:	83 f8 5e             	cmp    $0x5e,%eax
  80065b:	76 c6                	jbe    800623 <vprintfmt+0x1ed>
					putch('?', putdat);
  80065d:	83 ec 08             	sub    $0x8,%esp
  800660:	53                   	push   %ebx
  800661:	6a 3f                	push   $0x3f
  800663:	ff d6                	call   *%esi
  800665:	83 c4 10             	add    $0x10,%esp
  800668:	eb c3                	jmp    80062d <vprintfmt+0x1f7>
  80066a:	89 cf                	mov    %ecx,%edi
  80066c:	eb 0e                	jmp    80067c <vprintfmt+0x246>
				putch(' ', putdat);
  80066e:	83 ec 08             	sub    $0x8,%esp
  800671:	53                   	push   %ebx
  800672:	6a 20                	push   $0x20
  800674:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800676:	83 ef 01             	sub    $0x1,%edi
  800679:	83 c4 10             	add    $0x10,%esp
  80067c:	85 ff                	test   %edi,%edi
  80067e:	7f ee                	jg     80066e <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  800680:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800683:	89 45 14             	mov    %eax,0x14(%ebp)
  800686:	e9 dd 01 00 00       	jmp    800868 <vprintfmt+0x432>
  80068b:	89 cf                	mov    %ecx,%edi
  80068d:	eb ed                	jmp    80067c <vprintfmt+0x246>
	if (lflag >= 2)
  80068f:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800693:	7f 21                	jg     8006b6 <vprintfmt+0x280>
	else if (lflag)
  800695:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800699:	74 6a                	je     800705 <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  80069b:	8b 45 14             	mov    0x14(%ebp),%eax
  80069e:	8b 00                	mov    (%eax),%eax
  8006a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a3:	89 c1                	mov    %eax,%ecx
  8006a5:	c1 f9 1f             	sar    $0x1f,%ecx
  8006a8:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ae:	8d 40 04             	lea    0x4(%eax),%eax
  8006b1:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b4:	eb 17                	jmp    8006cd <vprintfmt+0x297>
		return va_arg(*ap, long long);
  8006b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b9:	8b 50 04             	mov    0x4(%eax),%edx
  8006bc:	8b 00                	mov    (%eax),%eax
  8006be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c7:	8d 40 08             	lea    0x8(%eax),%eax
  8006ca:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8006cd:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  8006d0:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8006d5:	85 d2                	test   %edx,%edx
  8006d7:	0f 89 5c 01 00 00    	jns    800839 <vprintfmt+0x403>
				putch('-', putdat);
  8006dd:	83 ec 08             	sub    $0x8,%esp
  8006e0:	53                   	push   %ebx
  8006e1:	6a 2d                	push   $0x2d
  8006e3:	ff d6                	call   *%esi
				num = -(long long) num;
  8006e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006e8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006eb:	f7 d8                	neg    %eax
  8006ed:	83 d2 00             	adc    $0x0,%edx
  8006f0:	f7 da                	neg    %edx
  8006f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f8:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006fb:	bf 0a 00 00 00       	mov    $0xa,%edi
  800700:	e9 45 01 00 00       	jmp    80084a <vprintfmt+0x414>
		return va_arg(*ap, int);
  800705:	8b 45 14             	mov    0x14(%ebp),%eax
  800708:	8b 00                	mov    (%eax),%eax
  80070a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80070d:	89 c1                	mov    %eax,%ecx
  80070f:	c1 f9 1f             	sar    $0x1f,%ecx
  800712:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800715:	8b 45 14             	mov    0x14(%ebp),%eax
  800718:	8d 40 04             	lea    0x4(%eax),%eax
  80071b:	89 45 14             	mov    %eax,0x14(%ebp)
  80071e:	eb ad                	jmp    8006cd <vprintfmt+0x297>
	if (lflag >= 2)
  800720:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800724:	7f 29                	jg     80074f <vprintfmt+0x319>
	else if (lflag)
  800726:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80072a:	74 44                	je     800770 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  80072c:	8b 45 14             	mov    0x14(%ebp),%eax
  80072f:	8b 00                	mov    (%eax),%eax
  800731:	ba 00 00 00 00       	mov    $0x0,%edx
  800736:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800739:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80073c:	8b 45 14             	mov    0x14(%ebp),%eax
  80073f:	8d 40 04             	lea    0x4(%eax),%eax
  800742:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800745:	bf 0a 00 00 00       	mov    $0xa,%edi
  80074a:	e9 ea 00 00 00       	jmp    800839 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  80074f:	8b 45 14             	mov    0x14(%ebp),%eax
  800752:	8b 50 04             	mov    0x4(%eax),%edx
  800755:	8b 00                	mov    (%eax),%eax
  800757:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80075a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80075d:	8b 45 14             	mov    0x14(%ebp),%eax
  800760:	8d 40 08             	lea    0x8(%eax),%eax
  800763:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800766:	bf 0a 00 00 00       	mov    $0xa,%edi
  80076b:	e9 c9 00 00 00       	jmp    800839 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800770:	8b 45 14             	mov    0x14(%ebp),%eax
  800773:	8b 00                	mov    (%eax),%eax
  800775:	ba 00 00 00 00       	mov    $0x0,%edx
  80077a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800780:	8b 45 14             	mov    0x14(%ebp),%eax
  800783:	8d 40 04             	lea    0x4(%eax),%eax
  800786:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800789:	bf 0a 00 00 00       	mov    $0xa,%edi
  80078e:	e9 a6 00 00 00       	jmp    800839 <vprintfmt+0x403>
			putch('0', putdat);
  800793:	83 ec 08             	sub    $0x8,%esp
  800796:	53                   	push   %ebx
  800797:	6a 30                	push   $0x30
  800799:	ff d6                	call   *%esi
	if (lflag >= 2)
  80079b:	83 c4 10             	add    $0x10,%esp
  80079e:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8007a2:	7f 26                	jg     8007ca <vprintfmt+0x394>
	else if (lflag)
  8007a4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8007a8:	74 3e                	je     8007e8 <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  8007aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ad:	8b 00                	mov    (%eax),%eax
  8007af:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bd:	8d 40 04             	lea    0x4(%eax),%eax
  8007c0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007c3:	bf 08 00 00 00       	mov    $0x8,%edi
  8007c8:	eb 6f                	jmp    800839 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8007ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cd:	8b 50 04             	mov    0x4(%eax),%edx
  8007d0:	8b 00                	mov    (%eax),%eax
  8007d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007db:	8d 40 08             	lea    0x8(%eax),%eax
  8007de:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007e1:	bf 08 00 00 00       	mov    $0x8,%edi
  8007e6:	eb 51                	jmp    800839 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8007e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007eb:	8b 00                	mov    (%eax),%eax
  8007ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fb:	8d 40 04             	lea    0x4(%eax),%eax
  8007fe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800801:	bf 08 00 00 00       	mov    $0x8,%edi
  800806:	eb 31                	jmp    800839 <vprintfmt+0x403>
			putch('0', putdat);
  800808:	83 ec 08             	sub    $0x8,%esp
  80080b:	53                   	push   %ebx
  80080c:	6a 30                	push   $0x30
  80080e:	ff d6                	call   *%esi
			putch('x', putdat);
  800810:	83 c4 08             	add    $0x8,%esp
  800813:	53                   	push   %ebx
  800814:	6a 78                	push   $0x78
  800816:	ff d6                	call   *%esi
			num = (unsigned long long)
  800818:	8b 45 14             	mov    0x14(%ebp),%eax
  80081b:	8b 00                	mov    (%eax),%eax
  80081d:	ba 00 00 00 00       	mov    $0x0,%edx
  800822:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800825:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800828:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80082b:	8b 45 14             	mov    0x14(%ebp),%eax
  80082e:	8d 40 04             	lea    0x4(%eax),%eax
  800831:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800834:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  800839:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80083d:	74 0b                	je     80084a <vprintfmt+0x414>
				putch('+', putdat);
  80083f:	83 ec 08             	sub    $0x8,%esp
  800842:	53                   	push   %ebx
  800843:	6a 2b                	push   $0x2b
  800845:	ff d6                	call   *%esi
  800847:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  80084a:	83 ec 0c             	sub    $0xc,%esp
  80084d:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800851:	50                   	push   %eax
  800852:	ff 75 e0             	pushl  -0x20(%ebp)
  800855:	57                   	push   %edi
  800856:	ff 75 dc             	pushl  -0x24(%ebp)
  800859:	ff 75 d8             	pushl  -0x28(%ebp)
  80085c:	89 da                	mov    %ebx,%edx
  80085e:	89 f0                	mov    %esi,%eax
  800860:	e8 b8 fa ff ff       	call   80031d <printnum>
			break;
  800865:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  800868:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80086b:	83 c7 01             	add    $0x1,%edi
  80086e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800872:	83 f8 25             	cmp    $0x25,%eax
  800875:	0f 84 d2 fb ff ff    	je     80044d <vprintfmt+0x17>
			if (ch == '\0')
  80087b:	85 c0                	test   %eax,%eax
  80087d:	0f 84 03 01 00 00    	je     800986 <vprintfmt+0x550>
			putch(ch, putdat);
  800883:	83 ec 08             	sub    $0x8,%esp
  800886:	53                   	push   %ebx
  800887:	50                   	push   %eax
  800888:	ff d6                	call   *%esi
  80088a:	83 c4 10             	add    $0x10,%esp
  80088d:	eb dc                	jmp    80086b <vprintfmt+0x435>
	if (lflag >= 2)
  80088f:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800893:	7f 29                	jg     8008be <vprintfmt+0x488>
	else if (lflag)
  800895:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800899:	74 44                	je     8008df <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  80089b:	8b 45 14             	mov    0x14(%ebp),%eax
  80089e:	8b 00                	mov    (%eax),%eax
  8008a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ae:	8d 40 04             	lea    0x4(%eax),%eax
  8008b1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008b4:	bf 10 00 00 00       	mov    $0x10,%edi
  8008b9:	e9 7b ff ff ff       	jmp    800839 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8008be:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c1:	8b 50 04             	mov    0x4(%eax),%edx
  8008c4:	8b 00                	mov    (%eax),%eax
  8008c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008c9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cf:	8d 40 08             	lea    0x8(%eax),%eax
  8008d2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008d5:	bf 10 00 00 00       	mov    $0x10,%edi
  8008da:	e9 5a ff ff ff       	jmp    800839 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8008df:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e2:	8b 00                	mov    (%eax),%eax
  8008e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008ec:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f2:	8d 40 04             	lea    0x4(%eax),%eax
  8008f5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008f8:	bf 10 00 00 00       	mov    $0x10,%edi
  8008fd:	e9 37 ff ff ff       	jmp    800839 <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  800902:	8b 45 14             	mov    0x14(%ebp),%eax
  800905:	8d 78 04             	lea    0x4(%eax),%edi
  800908:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  80090a:	85 c0                	test   %eax,%eax
  80090c:	74 2c                	je     80093a <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  80090e:	8b 13                	mov    (%ebx),%edx
  800910:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  800912:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  800915:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800918:	0f 8e 4a ff ff ff    	jle    800868 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  80091e:	68 94 27 80 00       	push   $0x802794
  800923:	68 7e 2c 80 00       	push   $0x802c7e
  800928:	53                   	push   %ebx
  800929:	56                   	push   %esi
  80092a:	e8 ea fa ff ff       	call   800419 <printfmt>
  80092f:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800932:	89 7d 14             	mov    %edi,0x14(%ebp)
  800935:	e9 2e ff ff ff       	jmp    800868 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  80093a:	68 5c 27 80 00       	push   $0x80275c
  80093f:	68 7e 2c 80 00       	push   $0x802c7e
  800944:	53                   	push   %ebx
  800945:	56                   	push   %esi
  800946:	e8 ce fa ff ff       	call   800419 <printfmt>
        		break;
  80094b:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  80094e:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  800951:	e9 12 ff ff ff       	jmp    800868 <vprintfmt+0x432>
			putch(ch, putdat);
  800956:	83 ec 08             	sub    $0x8,%esp
  800959:	53                   	push   %ebx
  80095a:	6a 25                	push   $0x25
  80095c:	ff d6                	call   *%esi
			break;
  80095e:	83 c4 10             	add    $0x10,%esp
  800961:	e9 02 ff ff ff       	jmp    800868 <vprintfmt+0x432>
			putch('%', putdat);
  800966:	83 ec 08             	sub    $0x8,%esp
  800969:	53                   	push   %ebx
  80096a:	6a 25                	push   $0x25
  80096c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80096e:	83 c4 10             	add    $0x10,%esp
  800971:	89 f8                	mov    %edi,%eax
  800973:	eb 03                	jmp    800978 <vprintfmt+0x542>
  800975:	83 e8 01             	sub    $0x1,%eax
  800978:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80097c:	75 f7                	jne    800975 <vprintfmt+0x53f>
  80097e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800981:	e9 e2 fe ff ff       	jmp    800868 <vprintfmt+0x432>
}
  800986:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800989:	5b                   	pop    %ebx
  80098a:	5e                   	pop    %esi
  80098b:	5f                   	pop    %edi
  80098c:	5d                   	pop    %ebp
  80098d:	c3                   	ret    

0080098e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80098e:	55                   	push   %ebp
  80098f:	89 e5                	mov    %esp,%ebp
  800991:	83 ec 18             	sub    $0x18,%esp
  800994:	8b 45 08             	mov    0x8(%ebp),%eax
  800997:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80099a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80099d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009a1:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009ab:	85 c0                	test   %eax,%eax
  8009ad:	74 26                	je     8009d5 <vsnprintf+0x47>
  8009af:	85 d2                	test   %edx,%edx
  8009b1:	7e 22                	jle    8009d5 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009b3:	ff 75 14             	pushl  0x14(%ebp)
  8009b6:	ff 75 10             	pushl  0x10(%ebp)
  8009b9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009bc:	50                   	push   %eax
  8009bd:	68 fc 03 80 00       	push   $0x8003fc
  8009c2:	e8 6f fa ff ff       	call   800436 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009ca:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009d0:	83 c4 10             	add    $0x10,%esp
}
  8009d3:	c9                   	leave  
  8009d4:	c3                   	ret    
		return -E_INVAL;
  8009d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009da:	eb f7                	jmp    8009d3 <vsnprintf+0x45>

008009dc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009dc:	55                   	push   %ebp
  8009dd:	89 e5                	mov    %esp,%ebp
  8009df:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009e2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009e5:	50                   	push   %eax
  8009e6:	ff 75 10             	pushl  0x10(%ebp)
  8009e9:	ff 75 0c             	pushl  0xc(%ebp)
  8009ec:	ff 75 08             	pushl  0x8(%ebp)
  8009ef:	e8 9a ff ff ff       	call   80098e <vsnprintf>
	va_end(ap);

	return rc;
}
  8009f4:	c9                   	leave  
  8009f5:	c3                   	ret    

008009f6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009f6:	55                   	push   %ebp
  8009f7:	89 e5                	mov    %esp,%ebp
  8009f9:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800a01:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a05:	74 05                	je     800a0c <strlen+0x16>
		n++;
  800a07:	83 c0 01             	add    $0x1,%eax
  800a0a:	eb f5                	jmp    800a01 <strlen+0xb>
	return n;
}
  800a0c:	5d                   	pop    %ebp
  800a0d:	c3                   	ret    

00800a0e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a0e:	55                   	push   %ebp
  800a0f:	89 e5                	mov    %esp,%ebp
  800a11:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a14:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a17:	ba 00 00 00 00       	mov    $0x0,%edx
  800a1c:	39 c2                	cmp    %eax,%edx
  800a1e:	74 0d                	je     800a2d <strnlen+0x1f>
  800a20:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a24:	74 05                	je     800a2b <strnlen+0x1d>
		n++;
  800a26:	83 c2 01             	add    $0x1,%edx
  800a29:	eb f1                	jmp    800a1c <strnlen+0xe>
  800a2b:	89 d0                	mov    %edx,%eax
	return n;
}
  800a2d:	5d                   	pop    %ebp
  800a2e:	c3                   	ret    

00800a2f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a2f:	55                   	push   %ebp
  800a30:	89 e5                	mov    %esp,%ebp
  800a32:	53                   	push   %ebx
  800a33:	8b 45 08             	mov    0x8(%ebp),%eax
  800a36:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a39:	ba 00 00 00 00       	mov    $0x0,%edx
  800a3e:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a42:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a45:	83 c2 01             	add    $0x1,%edx
  800a48:	84 c9                	test   %cl,%cl
  800a4a:	75 f2                	jne    800a3e <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a4c:	5b                   	pop    %ebx
  800a4d:	5d                   	pop    %ebp
  800a4e:	c3                   	ret    

00800a4f <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
  800a52:	53                   	push   %ebx
  800a53:	83 ec 10             	sub    $0x10,%esp
  800a56:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a59:	53                   	push   %ebx
  800a5a:	e8 97 ff ff ff       	call   8009f6 <strlen>
  800a5f:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a62:	ff 75 0c             	pushl  0xc(%ebp)
  800a65:	01 d8                	add    %ebx,%eax
  800a67:	50                   	push   %eax
  800a68:	e8 c2 ff ff ff       	call   800a2f <strcpy>
	return dst;
}
  800a6d:	89 d8                	mov    %ebx,%eax
  800a6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a72:	c9                   	leave  
  800a73:	c3                   	ret    

00800a74 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a74:	55                   	push   %ebp
  800a75:	89 e5                	mov    %esp,%ebp
  800a77:	56                   	push   %esi
  800a78:	53                   	push   %ebx
  800a79:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a7f:	89 c6                	mov    %eax,%esi
  800a81:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a84:	89 c2                	mov    %eax,%edx
  800a86:	39 f2                	cmp    %esi,%edx
  800a88:	74 11                	je     800a9b <strncpy+0x27>
		*dst++ = *src;
  800a8a:	83 c2 01             	add    $0x1,%edx
  800a8d:	0f b6 19             	movzbl (%ecx),%ebx
  800a90:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a93:	80 fb 01             	cmp    $0x1,%bl
  800a96:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a99:	eb eb                	jmp    800a86 <strncpy+0x12>
	}
	return ret;
}
  800a9b:	5b                   	pop    %ebx
  800a9c:	5e                   	pop    %esi
  800a9d:	5d                   	pop    %ebp
  800a9e:	c3                   	ret    

00800a9f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a9f:	55                   	push   %ebp
  800aa0:	89 e5                	mov    %esp,%ebp
  800aa2:	56                   	push   %esi
  800aa3:	53                   	push   %ebx
  800aa4:	8b 75 08             	mov    0x8(%ebp),%esi
  800aa7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aaa:	8b 55 10             	mov    0x10(%ebp),%edx
  800aad:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800aaf:	85 d2                	test   %edx,%edx
  800ab1:	74 21                	je     800ad4 <strlcpy+0x35>
  800ab3:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800ab7:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800ab9:	39 c2                	cmp    %eax,%edx
  800abb:	74 14                	je     800ad1 <strlcpy+0x32>
  800abd:	0f b6 19             	movzbl (%ecx),%ebx
  800ac0:	84 db                	test   %bl,%bl
  800ac2:	74 0b                	je     800acf <strlcpy+0x30>
			*dst++ = *src++;
  800ac4:	83 c1 01             	add    $0x1,%ecx
  800ac7:	83 c2 01             	add    $0x1,%edx
  800aca:	88 5a ff             	mov    %bl,-0x1(%edx)
  800acd:	eb ea                	jmp    800ab9 <strlcpy+0x1a>
  800acf:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800ad1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ad4:	29 f0                	sub    %esi,%eax
}
  800ad6:	5b                   	pop    %ebx
  800ad7:	5e                   	pop    %esi
  800ad8:	5d                   	pop    %ebp
  800ad9:	c3                   	ret    

00800ada <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ada:	55                   	push   %ebp
  800adb:	89 e5                	mov    %esp,%ebp
  800add:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ae0:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ae3:	0f b6 01             	movzbl (%ecx),%eax
  800ae6:	84 c0                	test   %al,%al
  800ae8:	74 0c                	je     800af6 <strcmp+0x1c>
  800aea:	3a 02                	cmp    (%edx),%al
  800aec:	75 08                	jne    800af6 <strcmp+0x1c>
		p++, q++;
  800aee:	83 c1 01             	add    $0x1,%ecx
  800af1:	83 c2 01             	add    $0x1,%edx
  800af4:	eb ed                	jmp    800ae3 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800af6:	0f b6 c0             	movzbl %al,%eax
  800af9:	0f b6 12             	movzbl (%edx),%edx
  800afc:	29 d0                	sub    %edx,%eax
}
  800afe:	5d                   	pop    %ebp
  800aff:	c3                   	ret    

00800b00 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b00:	55                   	push   %ebp
  800b01:	89 e5                	mov    %esp,%ebp
  800b03:	53                   	push   %ebx
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b0a:	89 c3                	mov    %eax,%ebx
  800b0c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b0f:	eb 06                	jmp    800b17 <strncmp+0x17>
		n--, p++, q++;
  800b11:	83 c0 01             	add    $0x1,%eax
  800b14:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b17:	39 d8                	cmp    %ebx,%eax
  800b19:	74 16                	je     800b31 <strncmp+0x31>
  800b1b:	0f b6 08             	movzbl (%eax),%ecx
  800b1e:	84 c9                	test   %cl,%cl
  800b20:	74 04                	je     800b26 <strncmp+0x26>
  800b22:	3a 0a                	cmp    (%edx),%cl
  800b24:	74 eb                	je     800b11 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b26:	0f b6 00             	movzbl (%eax),%eax
  800b29:	0f b6 12             	movzbl (%edx),%edx
  800b2c:	29 d0                	sub    %edx,%eax
}
  800b2e:	5b                   	pop    %ebx
  800b2f:	5d                   	pop    %ebp
  800b30:	c3                   	ret    
		return 0;
  800b31:	b8 00 00 00 00       	mov    $0x0,%eax
  800b36:	eb f6                	jmp    800b2e <strncmp+0x2e>

00800b38 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b38:	55                   	push   %ebp
  800b39:	89 e5                	mov    %esp,%ebp
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b42:	0f b6 10             	movzbl (%eax),%edx
  800b45:	84 d2                	test   %dl,%dl
  800b47:	74 09                	je     800b52 <strchr+0x1a>
		if (*s == c)
  800b49:	38 ca                	cmp    %cl,%dl
  800b4b:	74 0a                	je     800b57 <strchr+0x1f>
	for (; *s; s++)
  800b4d:	83 c0 01             	add    $0x1,%eax
  800b50:	eb f0                	jmp    800b42 <strchr+0xa>
			return (char *) s;
	return 0;
  800b52:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b57:	5d                   	pop    %ebp
  800b58:	c3                   	ret    

00800b59 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
  800b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b63:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b66:	38 ca                	cmp    %cl,%dl
  800b68:	74 09                	je     800b73 <strfind+0x1a>
  800b6a:	84 d2                	test   %dl,%dl
  800b6c:	74 05                	je     800b73 <strfind+0x1a>
	for (; *s; s++)
  800b6e:	83 c0 01             	add    $0x1,%eax
  800b71:	eb f0                	jmp    800b63 <strfind+0xa>
			break;
	return (char *) s;
}
  800b73:	5d                   	pop    %ebp
  800b74:	c3                   	ret    

00800b75 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b75:	55                   	push   %ebp
  800b76:	89 e5                	mov    %esp,%ebp
  800b78:	57                   	push   %edi
  800b79:	56                   	push   %esi
  800b7a:	53                   	push   %ebx
  800b7b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b7e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b81:	85 c9                	test   %ecx,%ecx
  800b83:	74 31                	je     800bb6 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b85:	89 f8                	mov    %edi,%eax
  800b87:	09 c8                	or     %ecx,%eax
  800b89:	a8 03                	test   $0x3,%al
  800b8b:	75 23                	jne    800bb0 <memset+0x3b>
		c &= 0xFF;
  800b8d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b91:	89 d3                	mov    %edx,%ebx
  800b93:	c1 e3 08             	shl    $0x8,%ebx
  800b96:	89 d0                	mov    %edx,%eax
  800b98:	c1 e0 18             	shl    $0x18,%eax
  800b9b:	89 d6                	mov    %edx,%esi
  800b9d:	c1 e6 10             	shl    $0x10,%esi
  800ba0:	09 f0                	or     %esi,%eax
  800ba2:	09 c2                	or     %eax,%edx
  800ba4:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ba6:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ba9:	89 d0                	mov    %edx,%eax
  800bab:	fc                   	cld    
  800bac:	f3 ab                	rep stos %eax,%es:(%edi)
  800bae:	eb 06                	jmp    800bb6 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb3:	fc                   	cld    
  800bb4:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bb6:	89 f8                	mov    %edi,%eax
  800bb8:	5b                   	pop    %ebx
  800bb9:	5e                   	pop    %esi
  800bba:	5f                   	pop    %edi
  800bbb:	5d                   	pop    %ebp
  800bbc:	c3                   	ret    

00800bbd <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bbd:	55                   	push   %ebp
  800bbe:	89 e5                	mov    %esp,%ebp
  800bc0:	57                   	push   %edi
  800bc1:	56                   	push   %esi
  800bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bc8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bcb:	39 c6                	cmp    %eax,%esi
  800bcd:	73 32                	jae    800c01 <memmove+0x44>
  800bcf:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bd2:	39 c2                	cmp    %eax,%edx
  800bd4:	76 2b                	jbe    800c01 <memmove+0x44>
		s += n;
		d += n;
  800bd6:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bd9:	89 fe                	mov    %edi,%esi
  800bdb:	09 ce                	or     %ecx,%esi
  800bdd:	09 d6                	or     %edx,%esi
  800bdf:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800be5:	75 0e                	jne    800bf5 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800be7:	83 ef 04             	sub    $0x4,%edi
  800bea:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bed:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800bf0:	fd                   	std    
  800bf1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bf3:	eb 09                	jmp    800bfe <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bf5:	83 ef 01             	sub    $0x1,%edi
  800bf8:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bfb:	fd                   	std    
  800bfc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bfe:	fc                   	cld    
  800bff:	eb 1a                	jmp    800c1b <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c01:	89 c2                	mov    %eax,%edx
  800c03:	09 ca                	or     %ecx,%edx
  800c05:	09 f2                	or     %esi,%edx
  800c07:	f6 c2 03             	test   $0x3,%dl
  800c0a:	75 0a                	jne    800c16 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c0c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c0f:	89 c7                	mov    %eax,%edi
  800c11:	fc                   	cld    
  800c12:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c14:	eb 05                	jmp    800c1b <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c16:	89 c7                	mov    %eax,%edi
  800c18:	fc                   	cld    
  800c19:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c1b:	5e                   	pop    %esi
  800c1c:	5f                   	pop    %edi
  800c1d:	5d                   	pop    %ebp
  800c1e:	c3                   	ret    

00800c1f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c25:	ff 75 10             	pushl  0x10(%ebp)
  800c28:	ff 75 0c             	pushl  0xc(%ebp)
  800c2b:	ff 75 08             	pushl  0x8(%ebp)
  800c2e:	e8 8a ff ff ff       	call   800bbd <memmove>
}
  800c33:	c9                   	leave  
  800c34:	c3                   	ret    

00800c35 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	56                   	push   %esi
  800c39:	53                   	push   %ebx
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c40:	89 c6                	mov    %eax,%esi
  800c42:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c45:	39 f0                	cmp    %esi,%eax
  800c47:	74 1c                	je     800c65 <memcmp+0x30>
		if (*s1 != *s2)
  800c49:	0f b6 08             	movzbl (%eax),%ecx
  800c4c:	0f b6 1a             	movzbl (%edx),%ebx
  800c4f:	38 d9                	cmp    %bl,%cl
  800c51:	75 08                	jne    800c5b <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c53:	83 c0 01             	add    $0x1,%eax
  800c56:	83 c2 01             	add    $0x1,%edx
  800c59:	eb ea                	jmp    800c45 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c5b:	0f b6 c1             	movzbl %cl,%eax
  800c5e:	0f b6 db             	movzbl %bl,%ebx
  800c61:	29 d8                	sub    %ebx,%eax
  800c63:	eb 05                	jmp    800c6a <memcmp+0x35>
	}

	return 0;
  800c65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c6a:	5b                   	pop    %ebx
  800c6b:	5e                   	pop    %esi
  800c6c:	5d                   	pop    %ebp
  800c6d:	c3                   	ret    

00800c6e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c77:	89 c2                	mov    %eax,%edx
  800c79:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c7c:	39 d0                	cmp    %edx,%eax
  800c7e:	73 09                	jae    800c89 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c80:	38 08                	cmp    %cl,(%eax)
  800c82:	74 05                	je     800c89 <memfind+0x1b>
	for (; s < ends; s++)
  800c84:	83 c0 01             	add    $0x1,%eax
  800c87:	eb f3                	jmp    800c7c <memfind+0xe>
			break;
	return (void *) s;
}
  800c89:	5d                   	pop    %ebp
  800c8a:	c3                   	ret    

00800c8b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c8b:	55                   	push   %ebp
  800c8c:	89 e5                	mov    %esp,%ebp
  800c8e:	57                   	push   %edi
  800c8f:	56                   	push   %esi
  800c90:	53                   	push   %ebx
  800c91:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c94:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c97:	eb 03                	jmp    800c9c <strtol+0x11>
		s++;
  800c99:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c9c:	0f b6 01             	movzbl (%ecx),%eax
  800c9f:	3c 20                	cmp    $0x20,%al
  800ca1:	74 f6                	je     800c99 <strtol+0xe>
  800ca3:	3c 09                	cmp    $0x9,%al
  800ca5:	74 f2                	je     800c99 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ca7:	3c 2b                	cmp    $0x2b,%al
  800ca9:	74 2a                	je     800cd5 <strtol+0x4a>
	int neg = 0;
  800cab:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cb0:	3c 2d                	cmp    $0x2d,%al
  800cb2:	74 2b                	je     800cdf <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cb4:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cba:	75 0f                	jne    800ccb <strtol+0x40>
  800cbc:	80 39 30             	cmpb   $0x30,(%ecx)
  800cbf:	74 28                	je     800ce9 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cc1:	85 db                	test   %ebx,%ebx
  800cc3:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cc8:	0f 44 d8             	cmove  %eax,%ebx
  800ccb:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cd3:	eb 50                	jmp    800d25 <strtol+0x9a>
		s++;
  800cd5:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cd8:	bf 00 00 00 00       	mov    $0x0,%edi
  800cdd:	eb d5                	jmp    800cb4 <strtol+0x29>
		s++, neg = 1;
  800cdf:	83 c1 01             	add    $0x1,%ecx
  800ce2:	bf 01 00 00 00       	mov    $0x1,%edi
  800ce7:	eb cb                	jmp    800cb4 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ce9:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ced:	74 0e                	je     800cfd <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800cef:	85 db                	test   %ebx,%ebx
  800cf1:	75 d8                	jne    800ccb <strtol+0x40>
		s++, base = 8;
  800cf3:	83 c1 01             	add    $0x1,%ecx
  800cf6:	bb 08 00 00 00       	mov    $0x8,%ebx
  800cfb:	eb ce                	jmp    800ccb <strtol+0x40>
		s += 2, base = 16;
  800cfd:	83 c1 02             	add    $0x2,%ecx
  800d00:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d05:	eb c4                	jmp    800ccb <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d07:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d0a:	89 f3                	mov    %esi,%ebx
  800d0c:	80 fb 19             	cmp    $0x19,%bl
  800d0f:	77 29                	ja     800d3a <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d11:	0f be d2             	movsbl %dl,%edx
  800d14:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d17:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d1a:	7d 30                	jge    800d4c <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d1c:	83 c1 01             	add    $0x1,%ecx
  800d1f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d23:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d25:	0f b6 11             	movzbl (%ecx),%edx
  800d28:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d2b:	89 f3                	mov    %esi,%ebx
  800d2d:	80 fb 09             	cmp    $0x9,%bl
  800d30:	77 d5                	ja     800d07 <strtol+0x7c>
			dig = *s - '0';
  800d32:	0f be d2             	movsbl %dl,%edx
  800d35:	83 ea 30             	sub    $0x30,%edx
  800d38:	eb dd                	jmp    800d17 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d3a:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d3d:	89 f3                	mov    %esi,%ebx
  800d3f:	80 fb 19             	cmp    $0x19,%bl
  800d42:	77 08                	ja     800d4c <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d44:	0f be d2             	movsbl %dl,%edx
  800d47:	83 ea 37             	sub    $0x37,%edx
  800d4a:	eb cb                	jmp    800d17 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d4c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d50:	74 05                	je     800d57 <strtol+0xcc>
		*endptr = (char *) s;
  800d52:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d55:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d57:	89 c2                	mov    %eax,%edx
  800d59:	f7 da                	neg    %edx
  800d5b:	85 ff                	test   %edi,%edi
  800d5d:	0f 45 c2             	cmovne %edx,%eax
}
  800d60:	5b                   	pop    %ebx
  800d61:	5e                   	pop    %esi
  800d62:	5f                   	pop    %edi
  800d63:	5d                   	pop    %ebp
  800d64:	c3                   	ret    

00800d65 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	57                   	push   %edi
  800d69:	56                   	push   %esi
  800d6a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d6b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d70:	8b 55 08             	mov    0x8(%ebp),%edx
  800d73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d76:	89 c3                	mov    %eax,%ebx
  800d78:	89 c7                	mov    %eax,%edi
  800d7a:	89 c6                	mov    %eax,%esi
  800d7c:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d7e:	5b                   	pop    %ebx
  800d7f:	5e                   	pop    %esi
  800d80:	5f                   	pop    %edi
  800d81:	5d                   	pop    %ebp
  800d82:	c3                   	ret    

00800d83 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d83:	55                   	push   %ebp
  800d84:	89 e5                	mov    %esp,%ebp
  800d86:	57                   	push   %edi
  800d87:	56                   	push   %esi
  800d88:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d89:	ba 00 00 00 00       	mov    $0x0,%edx
  800d8e:	b8 01 00 00 00       	mov    $0x1,%eax
  800d93:	89 d1                	mov    %edx,%ecx
  800d95:	89 d3                	mov    %edx,%ebx
  800d97:	89 d7                	mov    %edx,%edi
  800d99:	89 d6                	mov    %edx,%esi
  800d9b:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d9d:	5b                   	pop    %ebx
  800d9e:	5e                   	pop    %esi
  800d9f:	5f                   	pop    %edi
  800da0:	5d                   	pop    %ebp
  800da1:	c3                   	ret    

00800da2 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800da2:	55                   	push   %ebp
  800da3:	89 e5                	mov    %esp,%ebp
  800da5:	57                   	push   %edi
  800da6:	56                   	push   %esi
  800da7:	53                   	push   %ebx
  800da8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dab:	b9 00 00 00 00       	mov    $0x0,%ecx
  800db0:	8b 55 08             	mov    0x8(%ebp),%edx
  800db3:	b8 03 00 00 00       	mov    $0x3,%eax
  800db8:	89 cb                	mov    %ecx,%ebx
  800dba:	89 cf                	mov    %ecx,%edi
  800dbc:	89 ce                	mov    %ecx,%esi
  800dbe:	cd 30                	int    $0x30
	if (check && ret > 0)
  800dc0:	85 c0                	test   %eax,%eax
  800dc2:	7f 08                	jg     800dcc <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800dc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc7:	5b                   	pop    %ebx
  800dc8:	5e                   	pop    %esi
  800dc9:	5f                   	pop    %edi
  800dca:	5d                   	pop    %ebp
  800dcb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dcc:	83 ec 0c             	sub    $0xc,%esp
  800dcf:	50                   	push   %eax
  800dd0:	6a 03                	push   $0x3
  800dd2:	68 a0 29 80 00       	push   $0x8029a0
  800dd7:	6a 4c                	push   $0x4c
  800dd9:	68 bd 29 80 00       	push   $0x8029bd
  800dde:	e8 4b f4 ff ff       	call   80022e <_panic>

00800de3 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800de3:	55                   	push   %ebp
  800de4:	89 e5                	mov    %esp,%ebp
  800de6:	57                   	push   %edi
  800de7:	56                   	push   %esi
  800de8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800de9:	ba 00 00 00 00       	mov    $0x0,%edx
  800dee:	b8 02 00 00 00       	mov    $0x2,%eax
  800df3:	89 d1                	mov    %edx,%ecx
  800df5:	89 d3                	mov    %edx,%ebx
  800df7:	89 d7                	mov    %edx,%edi
  800df9:	89 d6                	mov    %edx,%esi
  800dfb:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800dfd:	5b                   	pop    %ebx
  800dfe:	5e                   	pop    %esi
  800dff:	5f                   	pop    %edi
  800e00:	5d                   	pop    %ebp
  800e01:	c3                   	ret    

00800e02 <sys_yield>:

void
sys_yield(void)
{
  800e02:	55                   	push   %ebp
  800e03:	89 e5                	mov    %esp,%ebp
  800e05:	57                   	push   %edi
  800e06:	56                   	push   %esi
  800e07:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e08:	ba 00 00 00 00       	mov    $0x0,%edx
  800e0d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e12:	89 d1                	mov    %edx,%ecx
  800e14:	89 d3                	mov    %edx,%ebx
  800e16:	89 d7                	mov    %edx,%edi
  800e18:	89 d6                	mov    %edx,%esi
  800e1a:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e1c:	5b                   	pop    %ebx
  800e1d:	5e                   	pop    %esi
  800e1e:	5f                   	pop    %edi
  800e1f:	5d                   	pop    %ebp
  800e20:	c3                   	ret    

00800e21 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e21:	55                   	push   %ebp
  800e22:	89 e5                	mov    %esp,%ebp
  800e24:	57                   	push   %edi
  800e25:	56                   	push   %esi
  800e26:	53                   	push   %ebx
  800e27:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e2a:	be 00 00 00 00       	mov    $0x0,%esi
  800e2f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e35:	b8 04 00 00 00       	mov    $0x4,%eax
  800e3a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e3d:	89 f7                	mov    %esi,%edi
  800e3f:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e41:	85 c0                	test   %eax,%eax
  800e43:	7f 08                	jg     800e4d <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e45:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e48:	5b                   	pop    %ebx
  800e49:	5e                   	pop    %esi
  800e4a:	5f                   	pop    %edi
  800e4b:	5d                   	pop    %ebp
  800e4c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4d:	83 ec 0c             	sub    $0xc,%esp
  800e50:	50                   	push   %eax
  800e51:	6a 04                	push   $0x4
  800e53:	68 a0 29 80 00       	push   $0x8029a0
  800e58:	6a 4c                	push   $0x4c
  800e5a:	68 bd 29 80 00       	push   $0x8029bd
  800e5f:	e8 ca f3 ff ff       	call   80022e <_panic>

00800e64 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
  800e67:	57                   	push   %edi
  800e68:	56                   	push   %esi
  800e69:	53                   	push   %ebx
  800e6a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e6d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e73:	b8 05 00 00 00       	mov    $0x5,%eax
  800e78:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e7b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e7e:	8b 75 18             	mov    0x18(%ebp),%esi
  800e81:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e83:	85 c0                	test   %eax,%eax
  800e85:	7f 08                	jg     800e8f <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e8a:	5b                   	pop    %ebx
  800e8b:	5e                   	pop    %esi
  800e8c:	5f                   	pop    %edi
  800e8d:	5d                   	pop    %ebp
  800e8e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8f:	83 ec 0c             	sub    $0xc,%esp
  800e92:	50                   	push   %eax
  800e93:	6a 05                	push   $0x5
  800e95:	68 a0 29 80 00       	push   $0x8029a0
  800e9a:	6a 4c                	push   $0x4c
  800e9c:	68 bd 29 80 00       	push   $0x8029bd
  800ea1:	e8 88 f3 ff ff       	call   80022e <_panic>

00800ea6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ea6:	55                   	push   %ebp
  800ea7:	89 e5                	mov    %esp,%ebp
  800ea9:	57                   	push   %edi
  800eaa:	56                   	push   %esi
  800eab:	53                   	push   %ebx
  800eac:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eaf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eba:	b8 06 00 00 00       	mov    $0x6,%eax
  800ebf:	89 df                	mov    %ebx,%edi
  800ec1:	89 de                	mov    %ebx,%esi
  800ec3:	cd 30                	int    $0x30
	if (check && ret > 0)
  800ec5:	85 c0                	test   %eax,%eax
  800ec7:	7f 08                	jg     800ed1 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ec9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ecc:	5b                   	pop    %ebx
  800ecd:	5e                   	pop    %esi
  800ece:	5f                   	pop    %edi
  800ecf:	5d                   	pop    %ebp
  800ed0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed1:	83 ec 0c             	sub    $0xc,%esp
  800ed4:	50                   	push   %eax
  800ed5:	6a 06                	push   $0x6
  800ed7:	68 a0 29 80 00       	push   $0x8029a0
  800edc:	6a 4c                	push   $0x4c
  800ede:	68 bd 29 80 00       	push   $0x8029bd
  800ee3:	e8 46 f3 ff ff       	call   80022e <_panic>

00800ee8 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ee8:	55                   	push   %ebp
  800ee9:	89 e5                	mov    %esp,%ebp
  800eeb:	57                   	push   %edi
  800eec:	56                   	push   %esi
  800eed:	53                   	push   %ebx
  800eee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ef1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ef6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800efc:	b8 08 00 00 00       	mov    $0x8,%eax
  800f01:	89 df                	mov    %ebx,%edi
  800f03:	89 de                	mov    %ebx,%esi
  800f05:	cd 30                	int    $0x30
	if (check && ret > 0)
  800f07:	85 c0                	test   %eax,%eax
  800f09:	7f 08                	jg     800f13 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f0e:	5b                   	pop    %ebx
  800f0f:	5e                   	pop    %esi
  800f10:	5f                   	pop    %edi
  800f11:	5d                   	pop    %ebp
  800f12:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f13:	83 ec 0c             	sub    $0xc,%esp
  800f16:	50                   	push   %eax
  800f17:	6a 08                	push   $0x8
  800f19:	68 a0 29 80 00       	push   $0x8029a0
  800f1e:	6a 4c                	push   $0x4c
  800f20:	68 bd 29 80 00       	push   $0x8029bd
  800f25:	e8 04 f3 ff ff       	call   80022e <_panic>

00800f2a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f2a:	55                   	push   %ebp
  800f2b:	89 e5                	mov    %esp,%ebp
  800f2d:	57                   	push   %edi
  800f2e:	56                   	push   %esi
  800f2f:	53                   	push   %ebx
  800f30:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f33:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f38:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3e:	b8 09 00 00 00       	mov    $0x9,%eax
  800f43:	89 df                	mov    %ebx,%edi
  800f45:	89 de                	mov    %ebx,%esi
  800f47:	cd 30                	int    $0x30
	if (check && ret > 0)
  800f49:	85 c0                	test   %eax,%eax
  800f4b:	7f 08                	jg     800f55 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f50:	5b                   	pop    %ebx
  800f51:	5e                   	pop    %esi
  800f52:	5f                   	pop    %edi
  800f53:	5d                   	pop    %ebp
  800f54:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f55:	83 ec 0c             	sub    $0xc,%esp
  800f58:	50                   	push   %eax
  800f59:	6a 09                	push   $0x9
  800f5b:	68 a0 29 80 00       	push   $0x8029a0
  800f60:	6a 4c                	push   $0x4c
  800f62:	68 bd 29 80 00       	push   $0x8029bd
  800f67:	e8 c2 f2 ff ff       	call   80022e <_panic>

00800f6c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f6c:	55                   	push   %ebp
  800f6d:	89 e5                	mov    %esp,%ebp
  800f6f:	57                   	push   %edi
  800f70:	56                   	push   %esi
  800f71:	53                   	push   %ebx
  800f72:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f75:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f80:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f85:	89 df                	mov    %ebx,%edi
  800f87:	89 de                	mov    %ebx,%esi
  800f89:	cd 30                	int    $0x30
	if (check && ret > 0)
  800f8b:	85 c0                	test   %eax,%eax
  800f8d:	7f 08                	jg     800f97 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f92:	5b                   	pop    %ebx
  800f93:	5e                   	pop    %esi
  800f94:	5f                   	pop    %edi
  800f95:	5d                   	pop    %ebp
  800f96:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f97:	83 ec 0c             	sub    $0xc,%esp
  800f9a:	50                   	push   %eax
  800f9b:	6a 0a                	push   $0xa
  800f9d:	68 a0 29 80 00       	push   $0x8029a0
  800fa2:	6a 4c                	push   $0x4c
  800fa4:	68 bd 29 80 00       	push   $0x8029bd
  800fa9:	e8 80 f2 ff ff       	call   80022e <_panic>

00800fae <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fae:	55                   	push   %ebp
  800faf:	89 e5                	mov    %esp,%ebp
  800fb1:	57                   	push   %edi
  800fb2:	56                   	push   %esi
  800fb3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fba:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fbf:	be 00 00 00 00       	mov    $0x0,%esi
  800fc4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fc7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fca:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fcc:	5b                   	pop    %ebx
  800fcd:	5e                   	pop    %esi
  800fce:	5f                   	pop    %edi
  800fcf:	5d                   	pop    %ebp
  800fd0:	c3                   	ret    

00800fd1 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fd1:	55                   	push   %ebp
  800fd2:	89 e5                	mov    %esp,%ebp
  800fd4:	57                   	push   %edi
  800fd5:	56                   	push   %esi
  800fd6:	53                   	push   %ebx
  800fd7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fda:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fdf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe2:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fe7:	89 cb                	mov    %ecx,%ebx
  800fe9:	89 cf                	mov    %ecx,%edi
  800feb:	89 ce                	mov    %ecx,%esi
  800fed:	cd 30                	int    $0x30
	if (check && ret > 0)
  800fef:	85 c0                	test   %eax,%eax
  800ff1:	7f 08                	jg     800ffb <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ff3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff6:	5b                   	pop    %ebx
  800ff7:	5e                   	pop    %esi
  800ff8:	5f                   	pop    %edi
  800ff9:	5d                   	pop    %ebp
  800ffa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ffb:	83 ec 0c             	sub    $0xc,%esp
  800ffe:	50                   	push   %eax
  800fff:	6a 0d                	push   $0xd
  801001:	68 a0 29 80 00       	push   $0x8029a0
  801006:	6a 4c                	push   $0x4c
  801008:	68 bd 29 80 00       	push   $0x8029bd
  80100d:	e8 1c f2 ff ff       	call   80022e <_panic>

00801012 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801012:	55                   	push   %ebp
  801013:	89 e5                	mov    %esp,%ebp
  801015:	57                   	push   %edi
  801016:	56                   	push   %esi
  801017:	53                   	push   %ebx
	asm volatile("int %1\n"
  801018:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101d:	8b 55 08             	mov    0x8(%ebp),%edx
  801020:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801023:	b8 0e 00 00 00       	mov    $0xe,%eax
  801028:	89 df                	mov    %ebx,%edi
  80102a:	89 de                	mov    %ebx,%esi
  80102c:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80102e:	5b                   	pop    %ebx
  80102f:	5e                   	pop    %esi
  801030:	5f                   	pop    %edi
  801031:	5d                   	pop    %ebp
  801032:	c3                   	ret    

00801033 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801033:	55                   	push   %ebp
  801034:	89 e5                	mov    %esp,%ebp
  801036:	57                   	push   %edi
  801037:	56                   	push   %esi
  801038:	53                   	push   %ebx
	asm volatile("int %1\n"
  801039:	b9 00 00 00 00       	mov    $0x0,%ecx
  80103e:	8b 55 08             	mov    0x8(%ebp),%edx
  801041:	b8 0f 00 00 00       	mov    $0xf,%eax
  801046:	89 cb                	mov    %ecx,%ebx
  801048:	89 cf                	mov    %ecx,%edi
  80104a:	89 ce                	mov    %ecx,%esi
  80104c:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80104e:	5b                   	pop    %ebx
  80104f:	5e                   	pop    %esi
  801050:	5f                   	pop    %edi
  801051:	5d                   	pop    %ebp
  801052:	c3                   	ret    

00801053 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801053:	55                   	push   %ebp
  801054:	89 e5                	mov    %esp,%ebp
  801056:	53                   	push   %ebx
  801057:	83 ec 04             	sub    $0x4,%esp
  80105a:	8b 55 08             	mov    0x8(%ebp),%edx
	// cprintf("pgfault()\n");
	void *addr = (void *) utf->utf_fault_va;
  80105d:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpd[PDX(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_COW))
  80105f:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801063:	0f 84 9c 00 00 00    	je     801105 <pgfault+0xb2>
  801069:	89 c2                	mov    %eax,%edx
  80106b:	c1 ea 16             	shr    $0x16,%edx
  80106e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801075:	f6 c2 01             	test   $0x1,%dl
  801078:	0f 84 87 00 00 00    	je     801105 <pgfault+0xb2>
  80107e:	89 c2                	mov    %eax,%edx
  801080:	c1 ea 0c             	shr    $0xc,%edx
  801083:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80108a:	f6 c1 01             	test   $0x1,%cl
  80108d:	74 76                	je     801105 <pgfault+0xb2>
  80108f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801096:	f6 c6 08             	test   $0x8,%dh
  801099:	74 6a                	je     801105 <pgfault+0xb2>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  80109b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010a0:	89 c3                	mov    %eax,%ebx

	r = sys_page_alloc(0, PFTEMP, PTE_P|PTE_U|PTE_W);
  8010a2:	83 ec 04             	sub    $0x4,%esp
  8010a5:	6a 07                	push   $0x7
  8010a7:	68 00 f0 7f 00       	push   $0x7ff000
  8010ac:	6a 00                	push   $0x0
  8010ae:	e8 6e fd ff ff       	call   800e21 <sys_page_alloc>
	if(r < 0){
  8010b3:	83 c4 10             	add    $0x10,%esp
  8010b6:	85 c0                	test   %eax,%eax
  8010b8:	78 5f                	js     801119 <pgfault+0xc6>
		panic("pgfault: sys_page_alloc fail, r: %d", r);
	}

	memmove(PFTEMP, addr, PGSIZE);
  8010ba:	83 ec 04             	sub    $0x4,%esp
  8010bd:	68 00 10 00 00       	push   $0x1000
  8010c2:	53                   	push   %ebx
  8010c3:	68 00 f0 7f 00       	push   $0x7ff000
  8010c8:	e8 f0 fa ff ff       	call   800bbd <memmove>

	r = sys_page_map(0, PFTEMP, 0, addr, PTE_P|PTE_U|PTE_W);
  8010cd:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8010d4:	53                   	push   %ebx
  8010d5:	6a 00                	push   $0x0
  8010d7:	68 00 f0 7f 00       	push   $0x7ff000
  8010dc:	6a 00                	push   $0x0
  8010de:	e8 81 fd ff ff       	call   800e64 <sys_page_map>
	if(r < 0){
  8010e3:	83 c4 20             	add    $0x20,%esp
  8010e6:	85 c0                	test   %eax,%eax
  8010e8:	78 41                	js     80112b <pgfault+0xd8>
		panic("pgfault: sys_page_map fail, r: %d", r);
	}

	r = sys_page_unmap(0, PFTEMP);
  8010ea:	83 ec 08             	sub    $0x8,%esp
  8010ed:	68 00 f0 7f 00       	push   $0x7ff000
  8010f2:	6a 00                	push   $0x0
  8010f4:	e8 ad fd ff ff       	call   800ea6 <sys_page_unmap>
	if(r < 0){
  8010f9:	83 c4 10             	add    $0x10,%esp
  8010fc:	85 c0                	test   %eax,%eax
  8010fe:	78 3d                	js     80113d <pgfault+0xea>
		panic("sys_page_unmap: %e", r);
	}
}
  801100:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801103:	c9                   	leave  
  801104:	c3                   	ret    
		panic("pgfault: 1\n");
  801105:	83 ec 04             	sub    $0x4,%esp
  801108:	68 cb 29 80 00       	push   $0x8029cb
  80110d:	6a 20                	push   $0x20
  80110f:	68 d7 29 80 00       	push   $0x8029d7
  801114:	e8 15 f1 ff ff       	call   80022e <_panic>
		panic("pgfault: sys_page_alloc fail, r: %d", r);
  801119:	50                   	push   %eax
  80111a:	68 2c 2a 80 00       	push   $0x802a2c
  80111f:	6a 2e                	push   $0x2e
  801121:	68 d7 29 80 00       	push   $0x8029d7
  801126:	e8 03 f1 ff ff       	call   80022e <_panic>
		panic("pgfault: sys_page_map fail, r: %d", r);
  80112b:	50                   	push   %eax
  80112c:	68 50 2a 80 00       	push   $0x802a50
  801131:	6a 35                	push   $0x35
  801133:	68 d7 29 80 00       	push   $0x8029d7
  801138:	e8 f1 f0 ff ff       	call   80022e <_panic>
		panic("sys_page_unmap: %e", r);
  80113d:	50                   	push   %eax
  80113e:	68 e2 29 80 00       	push   $0x8029e2
  801143:	6a 3a                	push   $0x3a
  801145:	68 d7 29 80 00       	push   $0x8029d7
  80114a:	e8 df f0 ff ff       	call   80022e <_panic>

0080114f <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80114f:	55                   	push   %ebp
  801150:	89 e5                	mov    %esp,%ebp
  801152:	57                   	push   %edi
  801153:	56                   	push   %esi
  801154:	53                   	push   %ebx
  801155:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	// panic("fork not implemented");
	int r;
	set_pgfault_handler(pgfault);
  801158:	68 53 10 80 00       	push   $0x801053
  80115d:	e8 90 0f 00 00       	call   8020f2 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801162:	b8 07 00 00 00       	mov    $0x7,%eax
  801167:	cd 30                	int    $0x30
  801169:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int i;
	uintptr_t va;
	envid_t childid = sys_exofork();
	if (childid < 0){
  80116c:	83 c4 10             	add    $0x10,%esp
  80116f:	85 c0                	test   %eax,%eax
  801171:	78 2c                	js     80119f <fork+0x50>
  801173:	89 c7                	mov    %eax,%edi
	}

	extern volatile pde_t uvpd[];
	extern volatile pte_t uvpt[];

	for (va = UTEXT; va < USTACKTOP; va += PGSIZE){
  801175:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (childid == 0) {
  80117a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80117e:	75 72                	jne    8011f2 <fork+0xa3>
		thisenv = &envs[ENVX(sys_getenvid())];
  801180:	e8 5e fc ff ff       	call   800de3 <sys_getenvid>
  801185:	25 ff 03 00 00       	and    $0x3ff,%eax
  80118a:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801190:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801195:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  80119a:	e9 36 01 00 00       	jmp    8012d5 <fork+0x186>
		panic("fork: child id < 0: %d", childid);
  80119f:	50                   	push   %eax
  8011a0:	68 f5 29 80 00       	push   $0x8029f5
  8011a5:	68 83 00 00 00       	push   $0x83
  8011aa:	68 d7 29 80 00       	push   $0x8029d7
  8011af:	e8 7a f0 ff ff       	call   80022e <_panic>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  8011b4:	50                   	push   %eax
  8011b5:	68 74 2a 80 00       	push   $0x802a74
  8011ba:	6a 56                	push   $0x56
  8011bc:	68 d7 29 80 00       	push   $0x8029d7
  8011c1:	e8 68 f0 ff ff       	call   80022e <_panic>
		r = sys_page_map((envid_t)0, va, envid, va, PTE_U | PTE_P);
  8011c6:	83 ec 0c             	sub    $0xc,%esp
  8011c9:	6a 05                	push   $0x5
  8011cb:	56                   	push   %esi
  8011cc:	57                   	push   %edi
  8011cd:	56                   	push   %esi
  8011ce:	6a 00                	push   $0x0
  8011d0:	e8 8f fc ff ff       	call   800e64 <sys_page_map>
		if(r < 0){
  8011d5:	83 c4 20             	add    $0x20,%esp
  8011d8:	85 c0                	test   %eax,%eax
  8011da:	0f 88 9f 00 00 00    	js     80127f <fork+0x130>
	for (va = UTEXT; va < USTACKTOP; va += PGSIZE){
  8011e0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8011e6:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8011ec:	0f 84 9f 00 00 00    	je     801291 <fork+0x142>
		if ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_U)){
  8011f2:	89 d8                	mov    %ebx,%eax
  8011f4:	c1 e8 16             	shr    $0x16,%eax
  8011f7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011fe:	a8 01                	test   $0x1,%al
  801200:	74 de                	je     8011e0 <fork+0x91>
  801202:	89 d8                	mov    %ebx,%eax
  801204:	c1 e8 0c             	shr    $0xc,%eax
  801207:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80120e:	f6 c2 01             	test   $0x1,%dl
  801211:	74 cd                	je     8011e0 <fork+0x91>
  801213:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80121a:	f6 c2 04             	test   $0x4,%dl
  80121d:	74 c1                	je     8011e0 <fork+0x91>
	void * va = (void *)(pn * PGSIZE);
  80121f:	89 c6                	mov    %eax,%esi
  801221:	c1 e6 0c             	shl    $0xc,%esi
	int perm = (uvpt[pn]);
  801224:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (perm & (PTE_W | PTE_COW)) {
  80122b:	a9 02 08 00 00       	test   $0x802,%eax
  801230:	74 94                	je     8011c6 <fork+0x77>
		r = sys_page_map((envid_t)0, va, envid, va, PTE_U | PTE_P | PTE_COW);
  801232:	83 ec 0c             	sub    $0xc,%esp
  801235:	68 05 08 00 00       	push   $0x805
  80123a:	56                   	push   %esi
  80123b:	57                   	push   %edi
  80123c:	56                   	push   %esi
  80123d:	6a 00                	push   $0x0
  80123f:	e8 20 fc ff ff       	call   800e64 <sys_page_map>
		if(r < 0){
  801244:	83 c4 20             	add    $0x20,%esp
  801247:	85 c0                	test   %eax,%eax
  801249:	0f 88 65 ff ff ff    	js     8011b4 <fork+0x65>
		r = sys_page_map((envid_t)0, va, (envid_t)0, va, PTE_U | PTE_P | PTE_COW);
  80124f:	83 ec 0c             	sub    $0xc,%esp
  801252:	68 05 08 00 00       	push   $0x805
  801257:	56                   	push   %esi
  801258:	6a 00                	push   $0x0
  80125a:	56                   	push   %esi
  80125b:	6a 00                	push   $0x0
  80125d:	e8 02 fc ff ff       	call   800e64 <sys_page_map>
		if(r < 0){
  801262:	83 c4 20             	add    $0x20,%esp
  801265:	85 c0                	test   %eax,%eax
  801267:	0f 89 73 ff ff ff    	jns    8011e0 <fork+0x91>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  80126d:	50                   	push   %eax
  80126e:	68 74 2a 80 00       	push   $0x802a74
  801273:	6a 5b                	push   $0x5b
  801275:	68 d7 29 80 00       	push   $0x8029d7
  80127a:	e8 af ef ff ff       	call   80022e <_panic>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  80127f:	50                   	push   %eax
  801280:	68 74 2a 80 00       	push   $0x802a74
  801285:	6a 61                	push   $0x61
  801287:	68 d7 29 80 00       	push   $0x8029d7
  80128c:	e8 9d ef ff ff       	call   80022e <_panic>
			duppage(childid, PGNUM(va));
		}
	}

	r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801291:	83 ec 04             	sub    $0x4,%esp
  801294:	6a 07                	push   $0x7
  801296:	68 00 f0 bf ee       	push   $0xeebff000
  80129b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80129e:	e8 7e fb ff ff       	call   800e21 <sys_page_alloc>
	if (r < 0){
  8012a3:	83 c4 10             	add    $0x10,%esp
  8012a6:	85 c0                	test   %eax,%eax
  8012a8:	78 36                	js     8012e0 <fork+0x191>
		panic("fork: allocate user exception stack for child env error, %d", r);
	}
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  8012aa:	83 ec 08             	sub    $0x8,%esp
  8012ad:	68 5d 21 80 00       	push   $0x80215d
  8012b2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012b5:	e8 b2 fc ff ff       	call   800f6c <sys_env_set_pgfault_upcall>
	if (r < 0){
  8012ba:	83 c4 10             	add    $0x10,%esp
  8012bd:	85 c0                	test   %eax,%eax
  8012bf:	78 34                	js     8012f5 <fork+0x1a6>
		panic("fork: sys_env_set_pgfault_upcall error, %d", r);
	}
	r = sys_env_set_status(childid, ENV_RUNNABLE);
  8012c1:	83 ec 08             	sub    $0x8,%esp
  8012c4:	6a 02                	push   $0x2
  8012c6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012c9:	e8 1a fc ff ff       	call   800ee8 <sys_env_set_status>
	if(r < 0){
  8012ce:	83 c4 10             	add    $0x10,%esp
  8012d1:	85 c0                	test   %eax,%eax
  8012d3:	78 35                	js     80130a <fork+0x1bb>
		panic("forK: sys_env_set_status, r%d", r);
	}
	return childid;
}
  8012d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012db:	5b                   	pop    %ebx
  8012dc:	5e                   	pop    %esi
  8012dd:	5f                   	pop    %edi
  8012de:	5d                   	pop    %ebp
  8012df:	c3                   	ret    
		panic("fork: allocate user exception stack for child env error, %d", r);
  8012e0:	50                   	push   %eax
  8012e1:	68 9c 2a 80 00       	push   $0x802a9c
  8012e6:	68 96 00 00 00       	push   $0x96
  8012eb:	68 d7 29 80 00       	push   $0x8029d7
  8012f0:	e8 39 ef ff ff       	call   80022e <_panic>
		panic("fork: sys_env_set_pgfault_upcall error, %d", r);
  8012f5:	50                   	push   %eax
  8012f6:	68 d8 2a 80 00       	push   $0x802ad8
  8012fb:	68 9a 00 00 00       	push   $0x9a
  801300:	68 d7 29 80 00       	push   $0x8029d7
  801305:	e8 24 ef ff ff       	call   80022e <_panic>
		panic("forK: sys_env_set_status, r%d", r);
  80130a:	50                   	push   %eax
  80130b:	68 0c 2a 80 00       	push   $0x802a0c
  801310:	68 9e 00 00 00       	push   $0x9e
  801315:	68 d7 29 80 00       	push   $0x8029d7
  80131a:	e8 0f ef ff ff       	call   80022e <_panic>

0080131f <sfork>:

// Challenge!
int
sfork(void)
{
  80131f:	55                   	push   %ebp
  801320:	89 e5                	mov    %esp,%ebp
  801322:	57                   	push   %edi
  801323:	56                   	push   %esi
  801324:	53                   	push   %ebx
  801325:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// return -E_INVAL;
	set_pgfault_handler(pgfault);
  801328:	68 53 10 80 00       	push   $0x801053
  80132d:	e8 c0 0d 00 00       	call   8020f2 <set_pgfault_handler>
  801332:	b8 07 00 00 00       	mov    $0x7,%eax
  801337:	cd 30                	int    $0x30
  801339:	89 c6                	mov    %eax,%esi
	int i;
	uintptr_t va;
	envid_t childid = sys_exofork();
	int r;
	if (childid < 0){
  80133b:	83 c4 10             	add    $0x10,%esp
  80133e:	85 c0                	test   %eax,%eax
  801340:	78 28                	js     80136a <sfork+0x4b>
  801342:	89 c7                	mov    %eax,%edi
	}

	extern volatile pde_t uvpd[];
	extern volatile pte_t uvpt[];

	for (va = 0; va < USTACKTOP; va += PGSIZE){
  801344:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (childid == 0) {
  801349:	75 42                	jne    80138d <sfork+0x6e>
		thisenv = &envs[ENVX(sys_getenvid())];
  80134b:	e8 93 fa ff ff       	call   800de3 <sys_getenvid>
  801350:	25 ff 03 00 00       	and    $0x3ff,%eax
  801355:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80135b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801360:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  801365:	e9 bc 00 00 00       	jmp    801426 <sfork+0x107>
		panic("fork: child id < 0: %d", childid);
  80136a:	50                   	push   %eax
  80136b:	68 f5 29 80 00       	push   $0x8029f5
  801370:	68 af 00 00 00       	push   $0xaf
  801375:	68 d7 29 80 00       	push   $0x8029d7
  80137a:	e8 af ee ff ff       	call   80022e <_panic>
	for (va = 0; va < USTACKTOP; va += PGSIZE){
  80137f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801385:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80138b:	74 5b                	je     8013e8 <sfork+0xc9>
		if ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_U)){
  80138d:	89 d8                	mov    %ebx,%eax
  80138f:	c1 e8 16             	shr    $0x16,%eax
  801392:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801399:	a8 01                	test   $0x1,%al
  80139b:	74 e2                	je     80137f <sfork+0x60>
  80139d:	89 d8                	mov    %ebx,%eax
  80139f:	c1 e8 0c             	shr    $0xc,%eax
  8013a2:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013a9:	f6 c2 01             	test   $0x1,%dl
  8013ac:	74 d1                	je     80137f <sfork+0x60>
  8013ae:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013b5:	f6 c2 04             	test   $0x4,%dl
  8013b8:	74 c5                	je     80137f <sfork+0x60>
			void *addr = (void *)(PGNUM(va) * PGSIZE);
  8013ba:	c1 e0 0c             	shl    $0xc,%eax
			struct PageInfo *page;
			pte_t *pte;
			
			// page = page_lookup((envid_t)0->env_pgdir, addr, &pte);
			// page_insert(dstenv->env_pgdir, page, addr, PTE_U | PTE_P);
			r = sys_page_map((envid_t)0, addr, childid, addr, PTE_U | PTE_P);
  8013bd:	83 ec 0c             	sub    $0xc,%esp
  8013c0:	6a 05                	push   $0x5
  8013c2:	50                   	push   %eax
  8013c3:	57                   	push   %edi
  8013c4:	50                   	push   %eax
  8013c5:	6a 00                	push   $0x0
  8013c7:	e8 98 fa ff ff       	call   800e64 <sys_page_map>
			if(r < 0){
  8013cc:	83 c4 20             	add    $0x20,%esp
  8013cf:	85 c0                	test   %eax,%eax
  8013d1:	79 ac                	jns    80137f <sfork+0x60>
				panic("sfork: sys_page_map fail, r:%d\n", r);
  8013d3:	50                   	push   %eax
  8013d4:	68 04 2b 80 00       	push   $0x802b04
  8013d9:	68 c4 00 00 00       	push   $0xc4
  8013de:	68 d7 29 80 00       	push   $0x8029d7
  8013e3:	e8 46 ee ff ff       	call   80022e <_panic>
			}
		}
	}

	r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8013e8:	83 ec 04             	sub    $0x4,%esp
  8013eb:	6a 07                	push   $0x7
  8013ed:	68 00 f0 bf ee       	push   $0xeebff000
  8013f2:	56                   	push   %esi
  8013f3:	e8 29 fa ff ff       	call   800e21 <sys_page_alloc>
	if (r < 0){
  8013f8:	83 c4 10             	add    $0x10,%esp
  8013fb:	85 c0                	test   %eax,%eax
  8013fd:	78 31                	js     801430 <sfork+0x111>
		panic("sfork: allocate user exception stack for child env error, %d", r);
	}
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  8013ff:	83 ec 08             	sub    $0x8,%esp
  801402:	68 5d 21 80 00       	push   $0x80215d
  801407:	56                   	push   %esi
  801408:	e8 5f fb ff ff       	call   800f6c <sys_env_set_pgfault_upcall>
	if (r < 0){
  80140d:	83 c4 10             	add    $0x10,%esp
  801410:	85 c0                	test   %eax,%eax
  801412:	78 31                	js     801445 <sfork+0x126>
		panic("sfork: sys_env_set_pgfault_upcall error, %d", r);
	}
	r = sys_env_set_status(childid, ENV_RUNNABLE);
  801414:	83 ec 08             	sub    $0x8,%esp
  801417:	6a 02                	push   $0x2
  801419:	56                   	push   %esi
  80141a:	e8 c9 fa ff ff       	call   800ee8 <sys_env_set_status>
	if(r < 0){
  80141f:	83 c4 10             	add    $0x10,%esp
  801422:	85 c0                	test   %eax,%eax
  801424:	78 34                	js     80145a <sfork+0x13b>
		panic("sforK: sys_env_set_status, r%d", r);
	}
	return childid;
}
  801426:	89 f0                	mov    %esi,%eax
  801428:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80142b:	5b                   	pop    %ebx
  80142c:	5e                   	pop    %esi
  80142d:	5f                   	pop    %edi
  80142e:	5d                   	pop    %ebp
  80142f:	c3                   	ret    
		panic("sfork: allocate user exception stack for child env error, %d", r);
  801430:	50                   	push   %eax
  801431:	68 24 2b 80 00       	push   $0x802b24
  801436:	68 cb 00 00 00       	push   $0xcb
  80143b:	68 d7 29 80 00       	push   $0x8029d7
  801440:	e8 e9 ed ff ff       	call   80022e <_panic>
		panic("sfork: sys_env_set_pgfault_upcall error, %d", r);
  801445:	50                   	push   %eax
  801446:	68 64 2b 80 00       	push   $0x802b64
  80144b:	68 cf 00 00 00       	push   $0xcf
  801450:	68 d7 29 80 00       	push   $0x8029d7
  801455:	e8 d4 ed ff ff       	call   80022e <_panic>
		panic("sforK: sys_env_set_status, r%d", r);
  80145a:	50                   	push   %eax
  80145b:	68 90 2b 80 00       	push   $0x802b90
  801460:	68 d3 00 00 00       	push   $0xd3
  801465:	68 d7 29 80 00       	push   $0x8029d7
  80146a:	e8 bf ed ff ff       	call   80022e <_panic>

0080146f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80146f:	55                   	push   %ebp
  801470:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801472:	8b 45 08             	mov    0x8(%ebp),%eax
  801475:	05 00 00 00 30       	add    $0x30000000,%eax
  80147a:	c1 e8 0c             	shr    $0xc,%eax
}
  80147d:	5d                   	pop    %ebp
  80147e:	c3                   	ret    

0080147f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80147f:	55                   	push   %ebp
  801480:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80148a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80148f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801494:	5d                   	pop    %ebp
  801495:	c3                   	ret    

00801496 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801496:	55                   	push   %ebp
  801497:	89 e5                	mov    %esp,%ebp
  801499:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80149e:	89 c2                	mov    %eax,%edx
  8014a0:	c1 ea 16             	shr    $0x16,%edx
  8014a3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8014aa:	f6 c2 01             	test   $0x1,%dl
  8014ad:	74 2d                	je     8014dc <fd_alloc+0x46>
  8014af:	89 c2                	mov    %eax,%edx
  8014b1:	c1 ea 0c             	shr    $0xc,%edx
  8014b4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014bb:	f6 c2 01             	test   $0x1,%dl
  8014be:	74 1c                	je     8014dc <fd_alloc+0x46>
  8014c0:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8014c5:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8014ca:	75 d2                	jne    80149e <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8014cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8014d5:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8014da:	eb 0a                	jmp    8014e6 <fd_alloc+0x50>
			*fd_store = fd;
  8014dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014df:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014e6:	5d                   	pop    %ebp
  8014e7:	c3                   	ret    

008014e8 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8014e8:	55                   	push   %ebp
  8014e9:	89 e5                	mov    %esp,%ebp
  8014eb:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8014ee:	83 f8 1f             	cmp    $0x1f,%eax
  8014f1:	77 30                	ja     801523 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8014f3:	c1 e0 0c             	shl    $0xc,%eax
  8014f6:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8014fb:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801501:	f6 c2 01             	test   $0x1,%dl
  801504:	74 24                	je     80152a <fd_lookup+0x42>
  801506:	89 c2                	mov    %eax,%edx
  801508:	c1 ea 0c             	shr    $0xc,%edx
  80150b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801512:	f6 c2 01             	test   $0x1,%dl
  801515:	74 1a                	je     801531 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801517:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151a:	89 02                	mov    %eax,(%edx)
	return 0;
  80151c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801521:	5d                   	pop    %ebp
  801522:	c3                   	ret    
		return -E_INVAL;
  801523:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801528:	eb f7                	jmp    801521 <fd_lookup+0x39>
		return -E_INVAL;
  80152a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80152f:	eb f0                	jmp    801521 <fd_lookup+0x39>
  801531:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801536:	eb e9                	jmp    801521 <fd_lookup+0x39>

00801538 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
  80153b:	83 ec 08             	sub    $0x8,%esp
  80153e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801541:	ba 2c 2c 80 00       	mov    $0x802c2c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801546:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80154b:	39 08                	cmp    %ecx,(%eax)
  80154d:	74 33                	je     801582 <dev_lookup+0x4a>
  80154f:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801552:	8b 02                	mov    (%edx),%eax
  801554:	85 c0                	test   %eax,%eax
  801556:	75 f3                	jne    80154b <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801558:	a1 04 40 80 00       	mov    0x804004,%eax
  80155d:	8b 40 48             	mov    0x48(%eax),%eax
  801560:	83 ec 04             	sub    $0x4,%esp
  801563:	51                   	push   %ecx
  801564:	50                   	push   %eax
  801565:	68 b0 2b 80 00       	push   $0x802bb0
  80156a:	e8 9a ed ff ff       	call   800309 <cprintf>
	*dev = 0;
  80156f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801572:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801578:	83 c4 10             	add    $0x10,%esp
  80157b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801580:	c9                   	leave  
  801581:	c3                   	ret    
			*dev = devtab[i];
  801582:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801585:	89 01                	mov    %eax,(%ecx)
			return 0;
  801587:	b8 00 00 00 00       	mov    $0x0,%eax
  80158c:	eb f2                	jmp    801580 <dev_lookup+0x48>

0080158e <fd_close>:
{
  80158e:	55                   	push   %ebp
  80158f:	89 e5                	mov    %esp,%ebp
  801591:	57                   	push   %edi
  801592:	56                   	push   %esi
  801593:	53                   	push   %ebx
  801594:	83 ec 24             	sub    $0x24,%esp
  801597:	8b 75 08             	mov    0x8(%ebp),%esi
  80159a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80159d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015a0:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015a1:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8015a7:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015aa:	50                   	push   %eax
  8015ab:	e8 38 ff ff ff       	call   8014e8 <fd_lookup>
  8015b0:	89 c3                	mov    %eax,%ebx
  8015b2:	83 c4 10             	add    $0x10,%esp
  8015b5:	85 c0                	test   %eax,%eax
  8015b7:	78 05                	js     8015be <fd_close+0x30>
	    || fd != fd2)
  8015b9:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8015bc:	74 16                	je     8015d4 <fd_close+0x46>
		return (must_exist ? r : 0);
  8015be:	89 f8                	mov    %edi,%eax
  8015c0:	84 c0                	test   %al,%al
  8015c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c7:	0f 44 d8             	cmove  %eax,%ebx
}
  8015ca:	89 d8                	mov    %ebx,%eax
  8015cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015cf:	5b                   	pop    %ebx
  8015d0:	5e                   	pop    %esi
  8015d1:	5f                   	pop    %edi
  8015d2:	5d                   	pop    %ebp
  8015d3:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8015d4:	83 ec 08             	sub    $0x8,%esp
  8015d7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8015da:	50                   	push   %eax
  8015db:	ff 36                	pushl  (%esi)
  8015dd:	e8 56 ff ff ff       	call   801538 <dev_lookup>
  8015e2:	89 c3                	mov    %eax,%ebx
  8015e4:	83 c4 10             	add    $0x10,%esp
  8015e7:	85 c0                	test   %eax,%eax
  8015e9:	78 1a                	js     801605 <fd_close+0x77>
		if (dev->dev_close)
  8015eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015ee:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8015f1:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8015f6:	85 c0                	test   %eax,%eax
  8015f8:	74 0b                	je     801605 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8015fa:	83 ec 0c             	sub    $0xc,%esp
  8015fd:	56                   	push   %esi
  8015fe:	ff d0                	call   *%eax
  801600:	89 c3                	mov    %eax,%ebx
  801602:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801605:	83 ec 08             	sub    $0x8,%esp
  801608:	56                   	push   %esi
  801609:	6a 00                	push   $0x0
  80160b:	e8 96 f8 ff ff       	call   800ea6 <sys_page_unmap>
	return r;
  801610:	83 c4 10             	add    $0x10,%esp
  801613:	eb b5                	jmp    8015ca <fd_close+0x3c>

00801615 <close>:

int
close(int fdnum)
{
  801615:	55                   	push   %ebp
  801616:	89 e5                	mov    %esp,%ebp
  801618:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80161b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80161e:	50                   	push   %eax
  80161f:	ff 75 08             	pushl  0x8(%ebp)
  801622:	e8 c1 fe ff ff       	call   8014e8 <fd_lookup>
  801627:	83 c4 10             	add    $0x10,%esp
  80162a:	85 c0                	test   %eax,%eax
  80162c:	79 02                	jns    801630 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80162e:	c9                   	leave  
  80162f:	c3                   	ret    
		return fd_close(fd, 1);
  801630:	83 ec 08             	sub    $0x8,%esp
  801633:	6a 01                	push   $0x1
  801635:	ff 75 f4             	pushl  -0xc(%ebp)
  801638:	e8 51 ff ff ff       	call   80158e <fd_close>
  80163d:	83 c4 10             	add    $0x10,%esp
  801640:	eb ec                	jmp    80162e <close+0x19>

00801642 <close_all>:

void
close_all(void)
{
  801642:	55                   	push   %ebp
  801643:	89 e5                	mov    %esp,%ebp
  801645:	53                   	push   %ebx
  801646:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801649:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80164e:	83 ec 0c             	sub    $0xc,%esp
  801651:	53                   	push   %ebx
  801652:	e8 be ff ff ff       	call   801615 <close>
	for (i = 0; i < MAXFD; i++)
  801657:	83 c3 01             	add    $0x1,%ebx
  80165a:	83 c4 10             	add    $0x10,%esp
  80165d:	83 fb 20             	cmp    $0x20,%ebx
  801660:	75 ec                	jne    80164e <close_all+0xc>
}
  801662:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801665:	c9                   	leave  
  801666:	c3                   	ret    

00801667 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801667:	55                   	push   %ebp
  801668:	89 e5                	mov    %esp,%ebp
  80166a:	57                   	push   %edi
  80166b:	56                   	push   %esi
  80166c:	53                   	push   %ebx
  80166d:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801670:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801673:	50                   	push   %eax
  801674:	ff 75 08             	pushl  0x8(%ebp)
  801677:	e8 6c fe ff ff       	call   8014e8 <fd_lookup>
  80167c:	89 c3                	mov    %eax,%ebx
  80167e:	83 c4 10             	add    $0x10,%esp
  801681:	85 c0                	test   %eax,%eax
  801683:	0f 88 81 00 00 00    	js     80170a <dup+0xa3>
		return r;
	close(newfdnum);
  801689:	83 ec 0c             	sub    $0xc,%esp
  80168c:	ff 75 0c             	pushl  0xc(%ebp)
  80168f:	e8 81 ff ff ff       	call   801615 <close>

	newfd = INDEX2FD(newfdnum);
  801694:	8b 75 0c             	mov    0xc(%ebp),%esi
  801697:	c1 e6 0c             	shl    $0xc,%esi
  80169a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8016a0:	83 c4 04             	add    $0x4,%esp
  8016a3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016a6:	e8 d4 fd ff ff       	call   80147f <fd2data>
  8016ab:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8016ad:	89 34 24             	mov    %esi,(%esp)
  8016b0:	e8 ca fd ff ff       	call   80147f <fd2data>
  8016b5:	83 c4 10             	add    $0x10,%esp
  8016b8:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8016ba:	89 d8                	mov    %ebx,%eax
  8016bc:	c1 e8 16             	shr    $0x16,%eax
  8016bf:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016c6:	a8 01                	test   $0x1,%al
  8016c8:	74 11                	je     8016db <dup+0x74>
  8016ca:	89 d8                	mov    %ebx,%eax
  8016cc:	c1 e8 0c             	shr    $0xc,%eax
  8016cf:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8016d6:	f6 c2 01             	test   $0x1,%dl
  8016d9:	75 39                	jne    801714 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016db:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016de:	89 d0                	mov    %edx,%eax
  8016e0:	c1 e8 0c             	shr    $0xc,%eax
  8016e3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016ea:	83 ec 0c             	sub    $0xc,%esp
  8016ed:	25 07 0e 00 00       	and    $0xe07,%eax
  8016f2:	50                   	push   %eax
  8016f3:	56                   	push   %esi
  8016f4:	6a 00                	push   $0x0
  8016f6:	52                   	push   %edx
  8016f7:	6a 00                	push   $0x0
  8016f9:	e8 66 f7 ff ff       	call   800e64 <sys_page_map>
  8016fe:	89 c3                	mov    %eax,%ebx
  801700:	83 c4 20             	add    $0x20,%esp
  801703:	85 c0                	test   %eax,%eax
  801705:	78 31                	js     801738 <dup+0xd1>
		goto err;

	return newfdnum;
  801707:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80170a:	89 d8                	mov    %ebx,%eax
  80170c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80170f:	5b                   	pop    %ebx
  801710:	5e                   	pop    %esi
  801711:	5f                   	pop    %edi
  801712:	5d                   	pop    %ebp
  801713:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801714:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80171b:	83 ec 0c             	sub    $0xc,%esp
  80171e:	25 07 0e 00 00       	and    $0xe07,%eax
  801723:	50                   	push   %eax
  801724:	57                   	push   %edi
  801725:	6a 00                	push   $0x0
  801727:	53                   	push   %ebx
  801728:	6a 00                	push   $0x0
  80172a:	e8 35 f7 ff ff       	call   800e64 <sys_page_map>
  80172f:	89 c3                	mov    %eax,%ebx
  801731:	83 c4 20             	add    $0x20,%esp
  801734:	85 c0                	test   %eax,%eax
  801736:	79 a3                	jns    8016db <dup+0x74>
	sys_page_unmap(0, newfd);
  801738:	83 ec 08             	sub    $0x8,%esp
  80173b:	56                   	push   %esi
  80173c:	6a 00                	push   $0x0
  80173e:	e8 63 f7 ff ff       	call   800ea6 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801743:	83 c4 08             	add    $0x8,%esp
  801746:	57                   	push   %edi
  801747:	6a 00                	push   $0x0
  801749:	e8 58 f7 ff ff       	call   800ea6 <sys_page_unmap>
	return r;
  80174e:	83 c4 10             	add    $0x10,%esp
  801751:	eb b7                	jmp    80170a <dup+0xa3>

00801753 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
  801756:	53                   	push   %ebx
  801757:	83 ec 1c             	sub    $0x1c,%esp
  80175a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80175d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801760:	50                   	push   %eax
  801761:	53                   	push   %ebx
  801762:	e8 81 fd ff ff       	call   8014e8 <fd_lookup>
  801767:	83 c4 10             	add    $0x10,%esp
  80176a:	85 c0                	test   %eax,%eax
  80176c:	78 3f                	js     8017ad <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80176e:	83 ec 08             	sub    $0x8,%esp
  801771:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801774:	50                   	push   %eax
  801775:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801778:	ff 30                	pushl  (%eax)
  80177a:	e8 b9 fd ff ff       	call   801538 <dev_lookup>
  80177f:	83 c4 10             	add    $0x10,%esp
  801782:	85 c0                	test   %eax,%eax
  801784:	78 27                	js     8017ad <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801786:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801789:	8b 42 08             	mov    0x8(%edx),%eax
  80178c:	83 e0 03             	and    $0x3,%eax
  80178f:	83 f8 01             	cmp    $0x1,%eax
  801792:	74 1e                	je     8017b2 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801797:	8b 40 08             	mov    0x8(%eax),%eax
  80179a:	85 c0                	test   %eax,%eax
  80179c:	74 35                	je     8017d3 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80179e:	83 ec 04             	sub    $0x4,%esp
  8017a1:	ff 75 10             	pushl  0x10(%ebp)
  8017a4:	ff 75 0c             	pushl  0xc(%ebp)
  8017a7:	52                   	push   %edx
  8017a8:	ff d0                	call   *%eax
  8017aa:	83 c4 10             	add    $0x10,%esp
}
  8017ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017b0:	c9                   	leave  
  8017b1:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8017b2:	a1 04 40 80 00       	mov    0x804004,%eax
  8017b7:	8b 40 48             	mov    0x48(%eax),%eax
  8017ba:	83 ec 04             	sub    $0x4,%esp
  8017bd:	53                   	push   %ebx
  8017be:	50                   	push   %eax
  8017bf:	68 f1 2b 80 00       	push   $0x802bf1
  8017c4:	e8 40 eb ff ff       	call   800309 <cprintf>
		return -E_INVAL;
  8017c9:	83 c4 10             	add    $0x10,%esp
  8017cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017d1:	eb da                	jmp    8017ad <read+0x5a>
		return -E_NOT_SUPP;
  8017d3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017d8:	eb d3                	jmp    8017ad <read+0x5a>

008017da <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
  8017dd:	57                   	push   %edi
  8017de:	56                   	push   %esi
  8017df:	53                   	push   %ebx
  8017e0:	83 ec 0c             	sub    $0xc,%esp
  8017e3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017e6:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017e9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017ee:	39 f3                	cmp    %esi,%ebx
  8017f0:	73 23                	jae    801815 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017f2:	83 ec 04             	sub    $0x4,%esp
  8017f5:	89 f0                	mov    %esi,%eax
  8017f7:	29 d8                	sub    %ebx,%eax
  8017f9:	50                   	push   %eax
  8017fa:	89 d8                	mov    %ebx,%eax
  8017fc:	03 45 0c             	add    0xc(%ebp),%eax
  8017ff:	50                   	push   %eax
  801800:	57                   	push   %edi
  801801:	e8 4d ff ff ff       	call   801753 <read>
		if (m < 0)
  801806:	83 c4 10             	add    $0x10,%esp
  801809:	85 c0                	test   %eax,%eax
  80180b:	78 06                	js     801813 <readn+0x39>
			return m;
		if (m == 0)
  80180d:	74 06                	je     801815 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80180f:	01 c3                	add    %eax,%ebx
  801811:	eb db                	jmp    8017ee <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801813:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801815:	89 d8                	mov    %ebx,%eax
  801817:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80181a:	5b                   	pop    %ebx
  80181b:	5e                   	pop    %esi
  80181c:	5f                   	pop    %edi
  80181d:	5d                   	pop    %ebp
  80181e:	c3                   	ret    

0080181f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
  801822:	53                   	push   %ebx
  801823:	83 ec 1c             	sub    $0x1c,%esp
  801826:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801829:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80182c:	50                   	push   %eax
  80182d:	53                   	push   %ebx
  80182e:	e8 b5 fc ff ff       	call   8014e8 <fd_lookup>
  801833:	83 c4 10             	add    $0x10,%esp
  801836:	85 c0                	test   %eax,%eax
  801838:	78 3a                	js     801874 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80183a:	83 ec 08             	sub    $0x8,%esp
  80183d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801840:	50                   	push   %eax
  801841:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801844:	ff 30                	pushl  (%eax)
  801846:	e8 ed fc ff ff       	call   801538 <dev_lookup>
  80184b:	83 c4 10             	add    $0x10,%esp
  80184e:	85 c0                	test   %eax,%eax
  801850:	78 22                	js     801874 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801852:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801855:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801859:	74 1e                	je     801879 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80185b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80185e:	8b 52 0c             	mov    0xc(%edx),%edx
  801861:	85 d2                	test   %edx,%edx
  801863:	74 35                	je     80189a <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801865:	83 ec 04             	sub    $0x4,%esp
  801868:	ff 75 10             	pushl  0x10(%ebp)
  80186b:	ff 75 0c             	pushl  0xc(%ebp)
  80186e:	50                   	push   %eax
  80186f:	ff d2                	call   *%edx
  801871:	83 c4 10             	add    $0x10,%esp
}
  801874:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801877:	c9                   	leave  
  801878:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801879:	a1 04 40 80 00       	mov    0x804004,%eax
  80187e:	8b 40 48             	mov    0x48(%eax),%eax
  801881:	83 ec 04             	sub    $0x4,%esp
  801884:	53                   	push   %ebx
  801885:	50                   	push   %eax
  801886:	68 0d 2c 80 00       	push   $0x802c0d
  80188b:	e8 79 ea ff ff       	call   800309 <cprintf>
		return -E_INVAL;
  801890:	83 c4 10             	add    $0x10,%esp
  801893:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801898:	eb da                	jmp    801874 <write+0x55>
		return -E_NOT_SUPP;
  80189a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80189f:	eb d3                	jmp    801874 <write+0x55>

008018a1 <seek>:

int
seek(int fdnum, off_t offset)
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
  8018a4:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018aa:	50                   	push   %eax
  8018ab:	ff 75 08             	pushl  0x8(%ebp)
  8018ae:	e8 35 fc ff ff       	call   8014e8 <fd_lookup>
  8018b3:	83 c4 10             	add    $0x10,%esp
  8018b6:	85 c0                	test   %eax,%eax
  8018b8:	78 0e                	js     8018c8 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8018ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c0:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8018c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
  8018cd:	53                   	push   %ebx
  8018ce:	83 ec 1c             	sub    $0x1c,%esp
  8018d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018d7:	50                   	push   %eax
  8018d8:	53                   	push   %ebx
  8018d9:	e8 0a fc ff ff       	call   8014e8 <fd_lookup>
  8018de:	83 c4 10             	add    $0x10,%esp
  8018e1:	85 c0                	test   %eax,%eax
  8018e3:	78 37                	js     80191c <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018e5:	83 ec 08             	sub    $0x8,%esp
  8018e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018eb:	50                   	push   %eax
  8018ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ef:	ff 30                	pushl  (%eax)
  8018f1:	e8 42 fc ff ff       	call   801538 <dev_lookup>
  8018f6:	83 c4 10             	add    $0x10,%esp
  8018f9:	85 c0                	test   %eax,%eax
  8018fb:	78 1f                	js     80191c <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801900:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801904:	74 1b                	je     801921 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801906:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801909:	8b 52 18             	mov    0x18(%edx),%edx
  80190c:	85 d2                	test   %edx,%edx
  80190e:	74 32                	je     801942 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801910:	83 ec 08             	sub    $0x8,%esp
  801913:	ff 75 0c             	pushl  0xc(%ebp)
  801916:	50                   	push   %eax
  801917:	ff d2                	call   *%edx
  801919:	83 c4 10             	add    $0x10,%esp
}
  80191c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80191f:	c9                   	leave  
  801920:	c3                   	ret    
			thisenv->env_id, fdnum);
  801921:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801926:	8b 40 48             	mov    0x48(%eax),%eax
  801929:	83 ec 04             	sub    $0x4,%esp
  80192c:	53                   	push   %ebx
  80192d:	50                   	push   %eax
  80192e:	68 d0 2b 80 00       	push   $0x802bd0
  801933:	e8 d1 e9 ff ff       	call   800309 <cprintf>
		return -E_INVAL;
  801938:	83 c4 10             	add    $0x10,%esp
  80193b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801940:	eb da                	jmp    80191c <ftruncate+0x52>
		return -E_NOT_SUPP;
  801942:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801947:	eb d3                	jmp    80191c <ftruncate+0x52>

00801949 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
  80194c:	53                   	push   %ebx
  80194d:	83 ec 1c             	sub    $0x1c,%esp
  801950:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801953:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801956:	50                   	push   %eax
  801957:	ff 75 08             	pushl  0x8(%ebp)
  80195a:	e8 89 fb ff ff       	call   8014e8 <fd_lookup>
  80195f:	83 c4 10             	add    $0x10,%esp
  801962:	85 c0                	test   %eax,%eax
  801964:	78 4b                	js     8019b1 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801966:	83 ec 08             	sub    $0x8,%esp
  801969:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80196c:	50                   	push   %eax
  80196d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801970:	ff 30                	pushl  (%eax)
  801972:	e8 c1 fb ff ff       	call   801538 <dev_lookup>
  801977:	83 c4 10             	add    $0x10,%esp
  80197a:	85 c0                	test   %eax,%eax
  80197c:	78 33                	js     8019b1 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80197e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801981:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801985:	74 2f                	je     8019b6 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801987:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80198a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801991:	00 00 00 
	stat->st_isdir = 0;
  801994:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80199b:	00 00 00 
	stat->st_dev = dev;
  80199e:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8019a4:	83 ec 08             	sub    $0x8,%esp
  8019a7:	53                   	push   %ebx
  8019a8:	ff 75 f0             	pushl  -0x10(%ebp)
  8019ab:	ff 50 14             	call   *0x14(%eax)
  8019ae:	83 c4 10             	add    $0x10,%esp
}
  8019b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    
		return -E_NOT_SUPP;
  8019b6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019bb:	eb f4                	jmp    8019b1 <fstat+0x68>

008019bd <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
  8019c0:	56                   	push   %esi
  8019c1:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8019c2:	83 ec 08             	sub    $0x8,%esp
  8019c5:	6a 00                	push   $0x0
  8019c7:	ff 75 08             	pushl  0x8(%ebp)
  8019ca:	e8 bb 01 00 00       	call   801b8a <open>
  8019cf:	89 c3                	mov    %eax,%ebx
  8019d1:	83 c4 10             	add    $0x10,%esp
  8019d4:	85 c0                	test   %eax,%eax
  8019d6:	78 1b                	js     8019f3 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8019d8:	83 ec 08             	sub    $0x8,%esp
  8019db:	ff 75 0c             	pushl  0xc(%ebp)
  8019de:	50                   	push   %eax
  8019df:	e8 65 ff ff ff       	call   801949 <fstat>
  8019e4:	89 c6                	mov    %eax,%esi
	close(fd);
  8019e6:	89 1c 24             	mov    %ebx,(%esp)
  8019e9:	e8 27 fc ff ff       	call   801615 <close>
	return r;
  8019ee:	83 c4 10             	add    $0x10,%esp
  8019f1:	89 f3                	mov    %esi,%ebx
}
  8019f3:	89 d8                	mov    %ebx,%eax
  8019f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019f8:	5b                   	pop    %ebx
  8019f9:	5e                   	pop    %esi
  8019fa:	5d                   	pop    %ebp
  8019fb:	c3                   	ret    

008019fc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
  8019ff:	56                   	push   %esi
  801a00:	53                   	push   %ebx
  801a01:	89 c6                	mov    %eax,%esi
  801a03:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801a05:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801a0c:	74 27                	je     801a35 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a0e:	6a 07                	push   $0x7
  801a10:	68 00 50 80 00       	push   $0x805000
  801a15:	56                   	push   %esi
  801a16:	ff 35 00 40 80 00    	pushl  0x804000
  801a1c:	e8 cb 07 00 00       	call   8021ec <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a21:	83 c4 0c             	add    $0xc,%esp
  801a24:	6a 00                	push   $0x0
  801a26:	53                   	push   %ebx
  801a27:	6a 00                	push   $0x0
  801a29:	e8 55 07 00 00       	call   802183 <ipc_recv>
}
  801a2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a31:	5b                   	pop    %ebx
  801a32:	5e                   	pop    %esi
  801a33:	5d                   	pop    %ebp
  801a34:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a35:	83 ec 0c             	sub    $0xc,%esp
  801a38:	6a 01                	push   $0x1
  801a3a:	e8 fa 07 00 00       	call   802239 <ipc_find_env>
  801a3f:	a3 00 40 80 00       	mov    %eax,0x804000
  801a44:	83 c4 10             	add    $0x10,%esp
  801a47:	eb c5                	jmp    801a0e <fsipc+0x12>

00801a49 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
  801a4c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a52:	8b 40 0c             	mov    0xc(%eax),%eax
  801a55:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801a5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a5d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a62:	ba 00 00 00 00       	mov    $0x0,%edx
  801a67:	b8 02 00 00 00       	mov    $0x2,%eax
  801a6c:	e8 8b ff ff ff       	call   8019fc <fsipc>
}
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <devfile_flush>:
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
  801a76:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	8b 40 0c             	mov    0xc(%eax),%eax
  801a7f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801a84:	ba 00 00 00 00       	mov    $0x0,%edx
  801a89:	b8 06 00 00 00       	mov    $0x6,%eax
  801a8e:	e8 69 ff ff ff       	call   8019fc <fsipc>
}
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <devfile_stat>:
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
  801a98:	53                   	push   %ebx
  801a99:	83 ec 04             	sub    $0x4,%esp
  801a9c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa2:	8b 40 0c             	mov    0xc(%eax),%eax
  801aa5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801aaa:	ba 00 00 00 00       	mov    $0x0,%edx
  801aaf:	b8 05 00 00 00       	mov    $0x5,%eax
  801ab4:	e8 43 ff ff ff       	call   8019fc <fsipc>
  801ab9:	85 c0                	test   %eax,%eax
  801abb:	78 2c                	js     801ae9 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801abd:	83 ec 08             	sub    $0x8,%esp
  801ac0:	68 00 50 80 00       	push   $0x805000
  801ac5:	53                   	push   %ebx
  801ac6:	e8 64 ef ff ff       	call   800a2f <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801acb:	a1 80 50 80 00       	mov    0x805080,%eax
  801ad0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801ad6:	a1 84 50 80 00       	mov    0x805084,%eax
  801adb:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801ae1:	83 c4 10             	add    $0x10,%esp
  801ae4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ae9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <devfile_write>:
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
  801af1:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  801af4:	68 3c 2c 80 00       	push   $0x802c3c
  801af9:	68 90 00 00 00       	push   $0x90
  801afe:	68 5a 2c 80 00       	push   $0x802c5a
  801b03:	e8 26 e7 ff ff       	call   80022e <_panic>

00801b08 <devfile_read>:
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
  801b0b:	56                   	push   %esi
  801b0c:	53                   	push   %ebx
  801b0d:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b10:	8b 45 08             	mov    0x8(%ebp),%eax
  801b13:	8b 40 0c             	mov    0xc(%eax),%eax
  801b16:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801b1b:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b21:	ba 00 00 00 00       	mov    $0x0,%edx
  801b26:	b8 03 00 00 00       	mov    $0x3,%eax
  801b2b:	e8 cc fe ff ff       	call   8019fc <fsipc>
  801b30:	89 c3                	mov    %eax,%ebx
  801b32:	85 c0                	test   %eax,%eax
  801b34:	78 1f                	js     801b55 <devfile_read+0x4d>
	assert(r <= n);
  801b36:	39 f0                	cmp    %esi,%eax
  801b38:	77 24                	ja     801b5e <devfile_read+0x56>
	assert(r <= PGSIZE);
  801b3a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b3f:	7f 33                	jg     801b74 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b41:	83 ec 04             	sub    $0x4,%esp
  801b44:	50                   	push   %eax
  801b45:	68 00 50 80 00       	push   $0x805000
  801b4a:	ff 75 0c             	pushl  0xc(%ebp)
  801b4d:	e8 6b f0 ff ff       	call   800bbd <memmove>
	return r;
  801b52:	83 c4 10             	add    $0x10,%esp
}
  801b55:	89 d8                	mov    %ebx,%eax
  801b57:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b5a:	5b                   	pop    %ebx
  801b5b:	5e                   	pop    %esi
  801b5c:	5d                   	pop    %ebp
  801b5d:	c3                   	ret    
	assert(r <= n);
  801b5e:	68 65 2c 80 00       	push   $0x802c65
  801b63:	68 6c 2c 80 00       	push   $0x802c6c
  801b68:	6a 7c                	push   $0x7c
  801b6a:	68 5a 2c 80 00       	push   $0x802c5a
  801b6f:	e8 ba e6 ff ff       	call   80022e <_panic>
	assert(r <= PGSIZE);
  801b74:	68 81 2c 80 00       	push   $0x802c81
  801b79:	68 6c 2c 80 00       	push   $0x802c6c
  801b7e:	6a 7d                	push   $0x7d
  801b80:	68 5a 2c 80 00       	push   $0x802c5a
  801b85:	e8 a4 e6 ff ff       	call   80022e <_panic>

00801b8a <open>:
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
  801b8d:	56                   	push   %esi
  801b8e:	53                   	push   %ebx
  801b8f:	83 ec 1c             	sub    $0x1c,%esp
  801b92:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b95:	56                   	push   %esi
  801b96:	e8 5b ee ff ff       	call   8009f6 <strlen>
  801b9b:	83 c4 10             	add    $0x10,%esp
  801b9e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ba3:	7f 6c                	jg     801c11 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801ba5:	83 ec 0c             	sub    $0xc,%esp
  801ba8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bab:	50                   	push   %eax
  801bac:	e8 e5 f8 ff ff       	call   801496 <fd_alloc>
  801bb1:	89 c3                	mov    %eax,%ebx
  801bb3:	83 c4 10             	add    $0x10,%esp
  801bb6:	85 c0                	test   %eax,%eax
  801bb8:	78 3c                	js     801bf6 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801bba:	83 ec 08             	sub    $0x8,%esp
  801bbd:	56                   	push   %esi
  801bbe:	68 00 50 80 00       	push   $0x805000
  801bc3:	e8 67 ee ff ff       	call   800a2f <strcpy>
	fsipcbuf.open.req_omode = mode;
  801bc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bcb:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801bd0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bd3:	b8 01 00 00 00       	mov    $0x1,%eax
  801bd8:	e8 1f fe ff ff       	call   8019fc <fsipc>
  801bdd:	89 c3                	mov    %eax,%ebx
  801bdf:	83 c4 10             	add    $0x10,%esp
  801be2:	85 c0                	test   %eax,%eax
  801be4:	78 19                	js     801bff <open+0x75>
	return fd2num(fd);
  801be6:	83 ec 0c             	sub    $0xc,%esp
  801be9:	ff 75 f4             	pushl  -0xc(%ebp)
  801bec:	e8 7e f8 ff ff       	call   80146f <fd2num>
  801bf1:	89 c3                	mov    %eax,%ebx
  801bf3:	83 c4 10             	add    $0x10,%esp
}
  801bf6:	89 d8                	mov    %ebx,%eax
  801bf8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bfb:	5b                   	pop    %ebx
  801bfc:	5e                   	pop    %esi
  801bfd:	5d                   	pop    %ebp
  801bfe:	c3                   	ret    
		fd_close(fd, 0);
  801bff:	83 ec 08             	sub    $0x8,%esp
  801c02:	6a 00                	push   $0x0
  801c04:	ff 75 f4             	pushl  -0xc(%ebp)
  801c07:	e8 82 f9 ff ff       	call   80158e <fd_close>
		return r;
  801c0c:	83 c4 10             	add    $0x10,%esp
  801c0f:	eb e5                	jmp    801bf6 <open+0x6c>
		return -E_BAD_PATH;
  801c11:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801c16:	eb de                	jmp    801bf6 <open+0x6c>

00801c18 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c18:	55                   	push   %ebp
  801c19:	89 e5                	mov    %esp,%ebp
  801c1b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c1e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c23:	b8 08 00 00 00       	mov    $0x8,%eax
  801c28:	e8 cf fd ff ff       	call   8019fc <fsipc>
}
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
  801c32:	56                   	push   %esi
  801c33:	53                   	push   %ebx
  801c34:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c37:	83 ec 0c             	sub    $0xc,%esp
  801c3a:	ff 75 08             	pushl  0x8(%ebp)
  801c3d:	e8 3d f8 ff ff       	call   80147f <fd2data>
  801c42:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c44:	83 c4 08             	add    $0x8,%esp
  801c47:	68 8d 2c 80 00       	push   $0x802c8d
  801c4c:	53                   	push   %ebx
  801c4d:	e8 dd ed ff ff       	call   800a2f <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c52:	8b 46 04             	mov    0x4(%esi),%eax
  801c55:	2b 06                	sub    (%esi),%eax
  801c57:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c5d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c64:	00 00 00 
	stat->st_dev = &devpipe;
  801c67:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801c6e:	30 80 00 
	return 0;
}
  801c71:	b8 00 00 00 00       	mov    $0x0,%eax
  801c76:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c79:	5b                   	pop    %ebx
  801c7a:	5e                   	pop    %esi
  801c7b:	5d                   	pop    %ebp
  801c7c:	c3                   	ret    

00801c7d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
  801c80:	53                   	push   %ebx
  801c81:	83 ec 0c             	sub    $0xc,%esp
  801c84:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c87:	53                   	push   %ebx
  801c88:	6a 00                	push   $0x0
  801c8a:	e8 17 f2 ff ff       	call   800ea6 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c8f:	89 1c 24             	mov    %ebx,(%esp)
  801c92:	e8 e8 f7 ff ff       	call   80147f <fd2data>
  801c97:	83 c4 08             	add    $0x8,%esp
  801c9a:	50                   	push   %eax
  801c9b:	6a 00                	push   $0x0
  801c9d:	e8 04 f2 ff ff       	call   800ea6 <sys_page_unmap>
}
  801ca2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <_pipeisclosed>:
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
  801caa:	57                   	push   %edi
  801cab:	56                   	push   %esi
  801cac:	53                   	push   %ebx
  801cad:	83 ec 1c             	sub    $0x1c,%esp
  801cb0:	89 c7                	mov    %eax,%edi
  801cb2:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801cb4:	a1 04 40 80 00       	mov    0x804004,%eax
  801cb9:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801cbc:	83 ec 0c             	sub    $0xc,%esp
  801cbf:	57                   	push   %edi
  801cc0:	e8 b3 05 00 00       	call   802278 <pageref>
  801cc5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cc8:	89 34 24             	mov    %esi,(%esp)
  801ccb:	e8 a8 05 00 00       	call   802278 <pageref>
		nn = thisenv->env_runs;
  801cd0:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801cd6:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801cd9:	83 c4 10             	add    $0x10,%esp
  801cdc:	39 cb                	cmp    %ecx,%ebx
  801cde:	74 1b                	je     801cfb <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801ce0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ce3:	75 cf                	jne    801cb4 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801ce5:	8b 42 58             	mov    0x58(%edx),%eax
  801ce8:	6a 01                	push   $0x1
  801cea:	50                   	push   %eax
  801ceb:	53                   	push   %ebx
  801cec:	68 94 2c 80 00       	push   $0x802c94
  801cf1:	e8 13 e6 ff ff       	call   800309 <cprintf>
  801cf6:	83 c4 10             	add    $0x10,%esp
  801cf9:	eb b9                	jmp    801cb4 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801cfb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cfe:	0f 94 c0             	sete   %al
  801d01:	0f b6 c0             	movzbl %al,%eax
}
  801d04:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d07:	5b                   	pop    %ebx
  801d08:	5e                   	pop    %esi
  801d09:	5f                   	pop    %edi
  801d0a:	5d                   	pop    %ebp
  801d0b:	c3                   	ret    

00801d0c <devpipe_write>:
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
  801d0f:	57                   	push   %edi
  801d10:	56                   	push   %esi
  801d11:	53                   	push   %ebx
  801d12:	83 ec 28             	sub    $0x28,%esp
  801d15:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d18:	56                   	push   %esi
  801d19:	e8 61 f7 ff ff       	call   80147f <fd2data>
  801d1e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d20:	83 c4 10             	add    $0x10,%esp
  801d23:	bf 00 00 00 00       	mov    $0x0,%edi
  801d28:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d2b:	74 4f                	je     801d7c <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d2d:	8b 43 04             	mov    0x4(%ebx),%eax
  801d30:	8b 0b                	mov    (%ebx),%ecx
  801d32:	8d 51 20             	lea    0x20(%ecx),%edx
  801d35:	39 d0                	cmp    %edx,%eax
  801d37:	72 14                	jb     801d4d <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d39:	89 da                	mov    %ebx,%edx
  801d3b:	89 f0                	mov    %esi,%eax
  801d3d:	e8 65 ff ff ff       	call   801ca7 <_pipeisclosed>
  801d42:	85 c0                	test   %eax,%eax
  801d44:	75 3b                	jne    801d81 <devpipe_write+0x75>
			sys_yield();
  801d46:	e8 b7 f0 ff ff       	call   800e02 <sys_yield>
  801d4b:	eb e0                	jmp    801d2d <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d50:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d54:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d57:	89 c2                	mov    %eax,%edx
  801d59:	c1 fa 1f             	sar    $0x1f,%edx
  801d5c:	89 d1                	mov    %edx,%ecx
  801d5e:	c1 e9 1b             	shr    $0x1b,%ecx
  801d61:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d64:	83 e2 1f             	and    $0x1f,%edx
  801d67:	29 ca                	sub    %ecx,%edx
  801d69:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d6d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d71:	83 c0 01             	add    $0x1,%eax
  801d74:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d77:	83 c7 01             	add    $0x1,%edi
  801d7a:	eb ac                	jmp    801d28 <devpipe_write+0x1c>
	return i;
  801d7c:	8b 45 10             	mov    0x10(%ebp),%eax
  801d7f:	eb 05                	jmp    801d86 <devpipe_write+0x7a>
				return 0;
  801d81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d86:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d89:	5b                   	pop    %ebx
  801d8a:	5e                   	pop    %esi
  801d8b:	5f                   	pop    %edi
  801d8c:	5d                   	pop    %ebp
  801d8d:	c3                   	ret    

00801d8e <devpipe_read>:
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
  801d91:	57                   	push   %edi
  801d92:	56                   	push   %esi
  801d93:	53                   	push   %ebx
  801d94:	83 ec 18             	sub    $0x18,%esp
  801d97:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801d9a:	57                   	push   %edi
  801d9b:	e8 df f6 ff ff       	call   80147f <fd2data>
  801da0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801da2:	83 c4 10             	add    $0x10,%esp
  801da5:	be 00 00 00 00       	mov    $0x0,%esi
  801daa:	3b 75 10             	cmp    0x10(%ebp),%esi
  801dad:	75 14                	jne    801dc3 <devpipe_read+0x35>
	return i;
  801daf:	8b 45 10             	mov    0x10(%ebp),%eax
  801db2:	eb 02                	jmp    801db6 <devpipe_read+0x28>
				return i;
  801db4:	89 f0                	mov    %esi,%eax
}
  801db6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801db9:	5b                   	pop    %ebx
  801dba:	5e                   	pop    %esi
  801dbb:	5f                   	pop    %edi
  801dbc:	5d                   	pop    %ebp
  801dbd:	c3                   	ret    
			sys_yield();
  801dbe:	e8 3f f0 ff ff       	call   800e02 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801dc3:	8b 03                	mov    (%ebx),%eax
  801dc5:	3b 43 04             	cmp    0x4(%ebx),%eax
  801dc8:	75 18                	jne    801de2 <devpipe_read+0x54>
			if (i > 0)
  801dca:	85 f6                	test   %esi,%esi
  801dcc:	75 e6                	jne    801db4 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801dce:	89 da                	mov    %ebx,%edx
  801dd0:	89 f8                	mov    %edi,%eax
  801dd2:	e8 d0 fe ff ff       	call   801ca7 <_pipeisclosed>
  801dd7:	85 c0                	test   %eax,%eax
  801dd9:	74 e3                	je     801dbe <devpipe_read+0x30>
				return 0;
  801ddb:	b8 00 00 00 00       	mov    $0x0,%eax
  801de0:	eb d4                	jmp    801db6 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801de2:	99                   	cltd   
  801de3:	c1 ea 1b             	shr    $0x1b,%edx
  801de6:	01 d0                	add    %edx,%eax
  801de8:	83 e0 1f             	and    $0x1f,%eax
  801deb:	29 d0                	sub    %edx,%eax
  801ded:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801df2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801df5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801df8:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801dfb:	83 c6 01             	add    $0x1,%esi
  801dfe:	eb aa                	jmp    801daa <devpipe_read+0x1c>

00801e00 <pipe>:
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
  801e03:	56                   	push   %esi
  801e04:	53                   	push   %ebx
  801e05:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e08:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e0b:	50                   	push   %eax
  801e0c:	e8 85 f6 ff ff       	call   801496 <fd_alloc>
  801e11:	89 c3                	mov    %eax,%ebx
  801e13:	83 c4 10             	add    $0x10,%esp
  801e16:	85 c0                	test   %eax,%eax
  801e18:	0f 88 23 01 00 00    	js     801f41 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e1e:	83 ec 04             	sub    $0x4,%esp
  801e21:	68 07 04 00 00       	push   $0x407
  801e26:	ff 75 f4             	pushl  -0xc(%ebp)
  801e29:	6a 00                	push   $0x0
  801e2b:	e8 f1 ef ff ff       	call   800e21 <sys_page_alloc>
  801e30:	89 c3                	mov    %eax,%ebx
  801e32:	83 c4 10             	add    $0x10,%esp
  801e35:	85 c0                	test   %eax,%eax
  801e37:	0f 88 04 01 00 00    	js     801f41 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801e3d:	83 ec 0c             	sub    $0xc,%esp
  801e40:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e43:	50                   	push   %eax
  801e44:	e8 4d f6 ff ff       	call   801496 <fd_alloc>
  801e49:	89 c3                	mov    %eax,%ebx
  801e4b:	83 c4 10             	add    $0x10,%esp
  801e4e:	85 c0                	test   %eax,%eax
  801e50:	0f 88 db 00 00 00    	js     801f31 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e56:	83 ec 04             	sub    $0x4,%esp
  801e59:	68 07 04 00 00       	push   $0x407
  801e5e:	ff 75 f0             	pushl  -0x10(%ebp)
  801e61:	6a 00                	push   $0x0
  801e63:	e8 b9 ef ff ff       	call   800e21 <sys_page_alloc>
  801e68:	89 c3                	mov    %eax,%ebx
  801e6a:	83 c4 10             	add    $0x10,%esp
  801e6d:	85 c0                	test   %eax,%eax
  801e6f:	0f 88 bc 00 00 00    	js     801f31 <pipe+0x131>
	va = fd2data(fd0);
  801e75:	83 ec 0c             	sub    $0xc,%esp
  801e78:	ff 75 f4             	pushl  -0xc(%ebp)
  801e7b:	e8 ff f5 ff ff       	call   80147f <fd2data>
  801e80:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e82:	83 c4 0c             	add    $0xc,%esp
  801e85:	68 07 04 00 00       	push   $0x407
  801e8a:	50                   	push   %eax
  801e8b:	6a 00                	push   $0x0
  801e8d:	e8 8f ef ff ff       	call   800e21 <sys_page_alloc>
  801e92:	89 c3                	mov    %eax,%ebx
  801e94:	83 c4 10             	add    $0x10,%esp
  801e97:	85 c0                	test   %eax,%eax
  801e99:	0f 88 82 00 00 00    	js     801f21 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e9f:	83 ec 0c             	sub    $0xc,%esp
  801ea2:	ff 75 f0             	pushl  -0x10(%ebp)
  801ea5:	e8 d5 f5 ff ff       	call   80147f <fd2data>
  801eaa:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801eb1:	50                   	push   %eax
  801eb2:	6a 00                	push   $0x0
  801eb4:	56                   	push   %esi
  801eb5:	6a 00                	push   $0x0
  801eb7:	e8 a8 ef ff ff       	call   800e64 <sys_page_map>
  801ebc:	89 c3                	mov    %eax,%ebx
  801ebe:	83 c4 20             	add    $0x20,%esp
  801ec1:	85 c0                	test   %eax,%eax
  801ec3:	78 4e                	js     801f13 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801ec5:	a1 20 30 80 00       	mov    0x803020,%eax
  801eca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ecd:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801ecf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ed2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801ed9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801edc:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801ede:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801ee8:	83 ec 0c             	sub    $0xc,%esp
  801eeb:	ff 75 f4             	pushl  -0xc(%ebp)
  801eee:	e8 7c f5 ff ff       	call   80146f <fd2num>
  801ef3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ef6:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ef8:	83 c4 04             	add    $0x4,%esp
  801efb:	ff 75 f0             	pushl  -0x10(%ebp)
  801efe:	e8 6c f5 ff ff       	call   80146f <fd2num>
  801f03:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f06:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f09:	83 c4 10             	add    $0x10,%esp
  801f0c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f11:	eb 2e                	jmp    801f41 <pipe+0x141>
	sys_page_unmap(0, va);
  801f13:	83 ec 08             	sub    $0x8,%esp
  801f16:	56                   	push   %esi
  801f17:	6a 00                	push   $0x0
  801f19:	e8 88 ef ff ff       	call   800ea6 <sys_page_unmap>
  801f1e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f21:	83 ec 08             	sub    $0x8,%esp
  801f24:	ff 75 f0             	pushl  -0x10(%ebp)
  801f27:	6a 00                	push   $0x0
  801f29:	e8 78 ef ff ff       	call   800ea6 <sys_page_unmap>
  801f2e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f31:	83 ec 08             	sub    $0x8,%esp
  801f34:	ff 75 f4             	pushl  -0xc(%ebp)
  801f37:	6a 00                	push   $0x0
  801f39:	e8 68 ef ff ff       	call   800ea6 <sys_page_unmap>
  801f3e:	83 c4 10             	add    $0x10,%esp
}
  801f41:	89 d8                	mov    %ebx,%eax
  801f43:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f46:	5b                   	pop    %ebx
  801f47:	5e                   	pop    %esi
  801f48:	5d                   	pop    %ebp
  801f49:	c3                   	ret    

00801f4a <pipeisclosed>:
{
  801f4a:	55                   	push   %ebp
  801f4b:	89 e5                	mov    %esp,%ebp
  801f4d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f50:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f53:	50                   	push   %eax
  801f54:	ff 75 08             	pushl  0x8(%ebp)
  801f57:	e8 8c f5 ff ff       	call   8014e8 <fd_lookup>
  801f5c:	83 c4 10             	add    $0x10,%esp
  801f5f:	85 c0                	test   %eax,%eax
  801f61:	78 18                	js     801f7b <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f63:	83 ec 0c             	sub    $0xc,%esp
  801f66:	ff 75 f4             	pushl  -0xc(%ebp)
  801f69:	e8 11 f5 ff ff       	call   80147f <fd2data>
	return _pipeisclosed(fd, p);
  801f6e:	89 c2                	mov    %eax,%edx
  801f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f73:	e8 2f fd ff ff       	call   801ca7 <_pipeisclosed>
  801f78:	83 c4 10             	add    $0x10,%esp
}
  801f7b:	c9                   	leave  
  801f7c:	c3                   	ret    

00801f7d <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801f7d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f82:	c3                   	ret    

00801f83 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f83:	55                   	push   %ebp
  801f84:	89 e5                	mov    %esp,%ebp
  801f86:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f89:	68 ac 2c 80 00       	push   $0x802cac
  801f8e:	ff 75 0c             	pushl  0xc(%ebp)
  801f91:	e8 99 ea ff ff       	call   800a2f <strcpy>
	return 0;
}
  801f96:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9b:	c9                   	leave  
  801f9c:	c3                   	ret    

00801f9d <devcons_write>:
{
  801f9d:	55                   	push   %ebp
  801f9e:	89 e5                	mov    %esp,%ebp
  801fa0:	57                   	push   %edi
  801fa1:	56                   	push   %esi
  801fa2:	53                   	push   %ebx
  801fa3:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fa9:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fae:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801fb4:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fb7:	73 31                	jae    801fea <devcons_write+0x4d>
		m = n - tot;
  801fb9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801fbc:	29 f3                	sub    %esi,%ebx
  801fbe:	83 fb 7f             	cmp    $0x7f,%ebx
  801fc1:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801fc6:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801fc9:	83 ec 04             	sub    $0x4,%esp
  801fcc:	53                   	push   %ebx
  801fcd:	89 f0                	mov    %esi,%eax
  801fcf:	03 45 0c             	add    0xc(%ebp),%eax
  801fd2:	50                   	push   %eax
  801fd3:	57                   	push   %edi
  801fd4:	e8 e4 eb ff ff       	call   800bbd <memmove>
		sys_cputs(buf, m);
  801fd9:	83 c4 08             	add    $0x8,%esp
  801fdc:	53                   	push   %ebx
  801fdd:	57                   	push   %edi
  801fde:	e8 82 ed ff ff       	call   800d65 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801fe3:	01 de                	add    %ebx,%esi
  801fe5:	83 c4 10             	add    $0x10,%esp
  801fe8:	eb ca                	jmp    801fb4 <devcons_write+0x17>
}
  801fea:	89 f0                	mov    %esi,%eax
  801fec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fef:	5b                   	pop    %ebx
  801ff0:	5e                   	pop    %esi
  801ff1:	5f                   	pop    %edi
  801ff2:	5d                   	pop    %ebp
  801ff3:	c3                   	ret    

00801ff4 <devcons_read>:
{
  801ff4:	55                   	push   %ebp
  801ff5:	89 e5                	mov    %esp,%ebp
  801ff7:	83 ec 08             	sub    $0x8,%esp
  801ffa:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801fff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802003:	74 21                	je     802026 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802005:	e8 79 ed ff ff       	call   800d83 <sys_cgetc>
  80200a:	85 c0                	test   %eax,%eax
  80200c:	75 07                	jne    802015 <devcons_read+0x21>
		sys_yield();
  80200e:	e8 ef ed ff ff       	call   800e02 <sys_yield>
  802013:	eb f0                	jmp    802005 <devcons_read+0x11>
	if (c < 0)
  802015:	78 0f                	js     802026 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802017:	83 f8 04             	cmp    $0x4,%eax
  80201a:	74 0c                	je     802028 <devcons_read+0x34>
	*(char*)vbuf = c;
  80201c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80201f:	88 02                	mov    %al,(%edx)
	return 1;
  802021:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802026:	c9                   	leave  
  802027:	c3                   	ret    
		return 0;
  802028:	b8 00 00 00 00       	mov    $0x0,%eax
  80202d:	eb f7                	jmp    802026 <devcons_read+0x32>

0080202f <cputchar>:
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
  802032:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802035:	8b 45 08             	mov    0x8(%ebp),%eax
  802038:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80203b:	6a 01                	push   $0x1
  80203d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802040:	50                   	push   %eax
  802041:	e8 1f ed ff ff       	call   800d65 <sys_cputs>
}
  802046:	83 c4 10             	add    $0x10,%esp
  802049:	c9                   	leave  
  80204a:	c3                   	ret    

0080204b <getchar>:
{
  80204b:	55                   	push   %ebp
  80204c:	89 e5                	mov    %esp,%ebp
  80204e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802051:	6a 01                	push   $0x1
  802053:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802056:	50                   	push   %eax
  802057:	6a 00                	push   $0x0
  802059:	e8 f5 f6 ff ff       	call   801753 <read>
	if (r < 0)
  80205e:	83 c4 10             	add    $0x10,%esp
  802061:	85 c0                	test   %eax,%eax
  802063:	78 06                	js     80206b <getchar+0x20>
	if (r < 1)
  802065:	74 06                	je     80206d <getchar+0x22>
	return c;
  802067:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80206b:	c9                   	leave  
  80206c:	c3                   	ret    
		return -E_EOF;
  80206d:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802072:	eb f7                	jmp    80206b <getchar+0x20>

00802074 <iscons>:
{
  802074:	55                   	push   %ebp
  802075:	89 e5                	mov    %esp,%ebp
  802077:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80207a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80207d:	50                   	push   %eax
  80207e:	ff 75 08             	pushl  0x8(%ebp)
  802081:	e8 62 f4 ff ff       	call   8014e8 <fd_lookup>
  802086:	83 c4 10             	add    $0x10,%esp
  802089:	85 c0                	test   %eax,%eax
  80208b:	78 11                	js     80209e <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80208d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802090:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802096:	39 10                	cmp    %edx,(%eax)
  802098:	0f 94 c0             	sete   %al
  80209b:	0f b6 c0             	movzbl %al,%eax
}
  80209e:	c9                   	leave  
  80209f:	c3                   	ret    

008020a0 <opencons>:
{
  8020a0:	55                   	push   %ebp
  8020a1:	89 e5                	mov    %esp,%ebp
  8020a3:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020a9:	50                   	push   %eax
  8020aa:	e8 e7 f3 ff ff       	call   801496 <fd_alloc>
  8020af:	83 c4 10             	add    $0x10,%esp
  8020b2:	85 c0                	test   %eax,%eax
  8020b4:	78 3a                	js     8020f0 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020b6:	83 ec 04             	sub    $0x4,%esp
  8020b9:	68 07 04 00 00       	push   $0x407
  8020be:	ff 75 f4             	pushl  -0xc(%ebp)
  8020c1:	6a 00                	push   $0x0
  8020c3:	e8 59 ed ff ff       	call   800e21 <sys_page_alloc>
  8020c8:	83 c4 10             	add    $0x10,%esp
  8020cb:	85 c0                	test   %eax,%eax
  8020cd:	78 21                	js     8020f0 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8020cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d2:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020d8:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8020da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020dd:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8020e4:	83 ec 0c             	sub    $0xc,%esp
  8020e7:	50                   	push   %eax
  8020e8:	e8 82 f3 ff ff       	call   80146f <fd2num>
  8020ed:	83 c4 10             	add    $0x10,%esp
}
  8020f0:	c9                   	leave  
  8020f1:	c3                   	ret    

008020f2 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8020f2:	55                   	push   %ebp
  8020f3:	89 e5                	mov    %esp,%ebp
  8020f5:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8020f8:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8020ff:	74 0a                	je     80210b <set_pgfault_handler+0x19>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802101:	8b 45 08             	mov    0x8(%ebp),%eax
  802104:	a3 00 60 80 00       	mov    %eax,0x806000
}
  802109:	c9                   	leave  
  80210a:	c3                   	ret    
		ret = sys_page_alloc((envid_t)0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W);
  80210b:	83 ec 04             	sub    $0x4,%esp
  80210e:	6a 07                	push   $0x7
  802110:	68 00 f0 bf ee       	push   $0xeebff000
  802115:	6a 00                	push   $0x0
  802117:	e8 05 ed ff ff       	call   800e21 <sys_page_alloc>
		if(ret < 0){
  80211c:	83 c4 10             	add    $0x10,%esp
  80211f:	85 c0                	test   %eax,%eax
  802121:	78 28                	js     80214b <set_pgfault_handler+0x59>
    	ret = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802123:	83 ec 08             	sub    $0x8,%esp
  802126:	68 5d 21 80 00       	push   $0x80215d
  80212b:	6a 00                	push   $0x0
  80212d:	e8 3a ee ff ff       	call   800f6c <sys_env_set_pgfault_upcall>
		if(ret < 0){
  802132:	83 c4 10             	add    $0x10,%esp
  802135:	85 c0                	test   %eax,%eax
  802137:	79 c8                	jns    802101 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
  802139:	50                   	push   %eax
  80213a:	68 ec 2c 80 00       	push   $0x802cec
  80213f:	6a 28                	push   $0x28
  802141:	68 2c 2d 80 00       	push   $0x802d2c
  802146:	e8 e3 e0 ff ff       	call   80022e <_panic>
			panic("set_pgfault_handler: sys_page_alloc fail, ret:%d", ret);
  80214b:	50                   	push   %eax
  80214c:	68 b8 2c 80 00       	push   $0x802cb8
  802151:	6a 24                	push   $0x24
  802153:	68 2c 2d 80 00       	push   $0x802d2c
  802158:	e8 d1 e0 ff ff       	call   80022e <_panic>

0080215d <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80215d:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80215e:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  802163:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802165:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edi
  802168:	8b 7c 24 28          	mov    0x28(%esp),%edi
	movl 0x30(%esp), %esi
  80216c:	8b 74 24 30          	mov    0x30(%esp),%esi
	subl $4, %esi
  802170:	83 ee 04             	sub    $0x4,%esi
	movl %edi, (%esi)
  802173:	89 3e                	mov    %edi,(%esi)
	movl %esi, 0x30(%esp)
  802175:	89 74 24 30          	mov    %esi,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  802179:	83 c4 08             	add    $0x8,%esp
	popal
  80217c:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80217d:	83 c4 04             	add    $0x4,%esp
	popfl
  802180:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802181:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802182:	c3                   	ret    

00802183 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802183:	55                   	push   %ebp
  802184:	89 e5                	mov    %esp,%ebp
  802186:	56                   	push   %esi
  802187:	53                   	push   %ebx
  802188:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80218b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80218e:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// return 0;
	if(!pg)
  802191:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  802193:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802198:	0f 44 c2             	cmove  %edx,%eax
	
	int ret;

	ret = sys_ipc_recv(pg);
  80219b:	83 ec 0c             	sub    $0xc,%esp
  80219e:	50                   	push   %eax
  80219f:	e8 2d ee ff ff       	call   800fd1 <sys_ipc_recv>
	if(ret < 0){
  8021a4:	83 c4 10             	add    $0x10,%esp
  8021a7:	85 c0                	test   %eax,%eax
  8021a9:	78 2b                	js     8021d6 <ipc_recv+0x53>
		if(perm_store) *perm_store = 0;
		if(from_env_store) *from_env_store = 0;
		return ret;
	}
	
	if(perm_store)
  8021ab:	85 f6                	test   %esi,%esi
  8021ad:	74 0a                	je     8021b9 <ipc_recv+0x36>
		*perm_store = thisenv->env_ipc_perm;
  8021af:	a1 04 40 80 00       	mov    0x804004,%eax
  8021b4:	8b 40 78             	mov    0x78(%eax),%eax
  8021b7:	89 06                	mov    %eax,(%esi)
	if(from_env_store)
  8021b9:	85 db                	test   %ebx,%ebx
  8021bb:	74 0a                	je     8021c7 <ipc_recv+0x44>
		*from_env_store = thisenv->env_ipc_from;
  8021bd:	a1 04 40 80 00       	mov    0x804004,%eax
  8021c2:	8b 40 74             	mov    0x74(%eax),%eax
  8021c5:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  8021c7:	a1 04 40 80 00       	mov    0x804004,%eax
  8021cc:	8b 40 70             	mov    0x70(%eax),%eax
}
  8021cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021d2:	5b                   	pop    %ebx
  8021d3:	5e                   	pop    %esi
  8021d4:	5d                   	pop    %ebp
  8021d5:	c3                   	ret    
		if(perm_store) *perm_store = 0;
  8021d6:	85 f6                	test   %esi,%esi
  8021d8:	74 06                	je     8021e0 <ipc_recv+0x5d>
  8021da:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(from_env_store) *from_env_store = 0;
  8021e0:	85 db                	test   %ebx,%ebx
  8021e2:	74 eb                	je     8021cf <ipc_recv+0x4c>
  8021e4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8021ea:	eb e3                	jmp    8021cf <ipc_recv+0x4c>

008021ec <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8021ec:	55                   	push   %ebp
  8021ed:	89 e5                	mov    %esp,%ebp
  8021ef:	57                   	push   %edi
  8021f0:	56                   	push   %esi
  8021f1:	53                   	push   %ebx
  8021f2:	83 ec 0c             	sub    $0xc,%esp
  8021f5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8021f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8021fb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
	if (!pg)
  8021fe:	85 db                	test   %ebx,%ebx
		pg = (void*)UTOP;
  802200:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802205:	0f 44 d8             	cmove  %eax,%ebx

	int ret = -E_IPC_NOT_RECV;
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))) {
  802208:	ff 75 14             	pushl  0x14(%ebp)
  80220b:	53                   	push   %ebx
  80220c:	56                   	push   %esi
  80220d:	57                   	push   %edi
  80220e:	e8 9b ed ff ff       	call   800fae <sys_ipc_try_send>
  802213:	83 c4 10             	add    $0x10,%esp
  802216:	85 c0                	test   %eax,%eax
  802218:	74 17                	je     802231 <ipc_send+0x45>
		if(ret != -E_IPC_NOT_RECV){
  80221a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80221d:	74 e9                	je     802208 <ipc_send+0x1c>
			panic("ipc_send: ret : %d", ret);
  80221f:	50                   	push   %eax
  802220:	68 3a 2d 80 00       	push   $0x802d3a
  802225:	6a 43                	push   $0x43
  802227:	68 4d 2d 80 00       	push   $0x802d4d
  80222c:	e8 fd df ff ff       	call   80022e <_panic>
			sys_yield();
		}
	}
}
  802231:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802234:	5b                   	pop    %ebx
  802235:	5e                   	pop    %esi
  802236:	5f                   	pop    %edi
  802237:	5d                   	pop    %ebp
  802238:	c3                   	ret    

00802239 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802239:	55                   	push   %ebp
  80223a:	89 e5                	mov    %esp,%ebp
  80223c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80223f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802244:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  80224a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802250:	8b 52 50             	mov    0x50(%edx),%edx
  802253:	39 ca                	cmp    %ecx,%edx
  802255:	74 11                	je     802268 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802257:	83 c0 01             	add    $0x1,%eax
  80225a:	3d 00 04 00 00       	cmp    $0x400,%eax
  80225f:	75 e3                	jne    802244 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802261:	b8 00 00 00 00       	mov    $0x0,%eax
  802266:	eb 0e                	jmp    802276 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802268:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80226e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802273:	8b 40 48             	mov    0x48(%eax),%eax
}
  802276:	5d                   	pop    %ebp
  802277:	c3                   	ret    

00802278 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802278:	55                   	push   %ebp
  802279:	89 e5                	mov    %esp,%ebp
  80227b:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80227e:	89 d0                	mov    %edx,%eax
  802280:	c1 e8 16             	shr    $0x16,%eax
  802283:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80228a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80228f:	f6 c1 01             	test   $0x1,%cl
  802292:	74 1d                	je     8022b1 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802294:	c1 ea 0c             	shr    $0xc,%edx
  802297:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80229e:	f6 c2 01             	test   $0x1,%dl
  8022a1:	74 0e                	je     8022b1 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022a3:	c1 ea 0c             	shr    $0xc,%edx
  8022a6:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8022ad:	ef 
  8022ae:	0f b7 c0             	movzwl %ax,%eax
}
  8022b1:	5d                   	pop    %ebp
  8022b2:	c3                   	ret    
  8022b3:	66 90                	xchg   %ax,%ax
  8022b5:	66 90                	xchg   %ax,%ax
  8022b7:	66 90                	xchg   %ax,%ax
  8022b9:	66 90                	xchg   %ax,%ax
  8022bb:	66 90                	xchg   %ax,%ax
  8022bd:	66 90                	xchg   %ax,%ax
  8022bf:	90                   	nop

008022c0 <__udivdi3>:
  8022c0:	55                   	push   %ebp
  8022c1:	57                   	push   %edi
  8022c2:	56                   	push   %esi
  8022c3:	53                   	push   %ebx
  8022c4:	83 ec 1c             	sub    $0x1c,%esp
  8022c7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8022cb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8022cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022d3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8022d7:	85 d2                	test   %edx,%edx
  8022d9:	75 4d                	jne    802328 <__udivdi3+0x68>
  8022db:	39 f3                	cmp    %esi,%ebx
  8022dd:	76 19                	jbe    8022f8 <__udivdi3+0x38>
  8022df:	31 ff                	xor    %edi,%edi
  8022e1:	89 e8                	mov    %ebp,%eax
  8022e3:	89 f2                	mov    %esi,%edx
  8022e5:	f7 f3                	div    %ebx
  8022e7:	89 fa                	mov    %edi,%edx
  8022e9:	83 c4 1c             	add    $0x1c,%esp
  8022ec:	5b                   	pop    %ebx
  8022ed:	5e                   	pop    %esi
  8022ee:	5f                   	pop    %edi
  8022ef:	5d                   	pop    %ebp
  8022f0:	c3                   	ret    
  8022f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022f8:	89 d9                	mov    %ebx,%ecx
  8022fa:	85 db                	test   %ebx,%ebx
  8022fc:	75 0b                	jne    802309 <__udivdi3+0x49>
  8022fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802303:	31 d2                	xor    %edx,%edx
  802305:	f7 f3                	div    %ebx
  802307:	89 c1                	mov    %eax,%ecx
  802309:	31 d2                	xor    %edx,%edx
  80230b:	89 f0                	mov    %esi,%eax
  80230d:	f7 f1                	div    %ecx
  80230f:	89 c6                	mov    %eax,%esi
  802311:	89 e8                	mov    %ebp,%eax
  802313:	89 f7                	mov    %esi,%edi
  802315:	f7 f1                	div    %ecx
  802317:	89 fa                	mov    %edi,%edx
  802319:	83 c4 1c             	add    $0x1c,%esp
  80231c:	5b                   	pop    %ebx
  80231d:	5e                   	pop    %esi
  80231e:	5f                   	pop    %edi
  80231f:	5d                   	pop    %ebp
  802320:	c3                   	ret    
  802321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802328:	39 f2                	cmp    %esi,%edx
  80232a:	77 1c                	ja     802348 <__udivdi3+0x88>
  80232c:	0f bd fa             	bsr    %edx,%edi
  80232f:	83 f7 1f             	xor    $0x1f,%edi
  802332:	75 2c                	jne    802360 <__udivdi3+0xa0>
  802334:	39 f2                	cmp    %esi,%edx
  802336:	72 06                	jb     80233e <__udivdi3+0x7e>
  802338:	31 c0                	xor    %eax,%eax
  80233a:	39 eb                	cmp    %ebp,%ebx
  80233c:	77 a9                	ja     8022e7 <__udivdi3+0x27>
  80233e:	b8 01 00 00 00       	mov    $0x1,%eax
  802343:	eb a2                	jmp    8022e7 <__udivdi3+0x27>
  802345:	8d 76 00             	lea    0x0(%esi),%esi
  802348:	31 ff                	xor    %edi,%edi
  80234a:	31 c0                	xor    %eax,%eax
  80234c:	89 fa                	mov    %edi,%edx
  80234e:	83 c4 1c             	add    $0x1c,%esp
  802351:	5b                   	pop    %ebx
  802352:	5e                   	pop    %esi
  802353:	5f                   	pop    %edi
  802354:	5d                   	pop    %ebp
  802355:	c3                   	ret    
  802356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80235d:	8d 76 00             	lea    0x0(%esi),%esi
  802360:	89 f9                	mov    %edi,%ecx
  802362:	b8 20 00 00 00       	mov    $0x20,%eax
  802367:	29 f8                	sub    %edi,%eax
  802369:	d3 e2                	shl    %cl,%edx
  80236b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80236f:	89 c1                	mov    %eax,%ecx
  802371:	89 da                	mov    %ebx,%edx
  802373:	d3 ea                	shr    %cl,%edx
  802375:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802379:	09 d1                	or     %edx,%ecx
  80237b:	89 f2                	mov    %esi,%edx
  80237d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802381:	89 f9                	mov    %edi,%ecx
  802383:	d3 e3                	shl    %cl,%ebx
  802385:	89 c1                	mov    %eax,%ecx
  802387:	d3 ea                	shr    %cl,%edx
  802389:	89 f9                	mov    %edi,%ecx
  80238b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80238f:	89 eb                	mov    %ebp,%ebx
  802391:	d3 e6                	shl    %cl,%esi
  802393:	89 c1                	mov    %eax,%ecx
  802395:	d3 eb                	shr    %cl,%ebx
  802397:	09 de                	or     %ebx,%esi
  802399:	89 f0                	mov    %esi,%eax
  80239b:	f7 74 24 08          	divl   0x8(%esp)
  80239f:	89 d6                	mov    %edx,%esi
  8023a1:	89 c3                	mov    %eax,%ebx
  8023a3:	f7 64 24 0c          	mull   0xc(%esp)
  8023a7:	39 d6                	cmp    %edx,%esi
  8023a9:	72 15                	jb     8023c0 <__udivdi3+0x100>
  8023ab:	89 f9                	mov    %edi,%ecx
  8023ad:	d3 e5                	shl    %cl,%ebp
  8023af:	39 c5                	cmp    %eax,%ebp
  8023b1:	73 04                	jae    8023b7 <__udivdi3+0xf7>
  8023b3:	39 d6                	cmp    %edx,%esi
  8023b5:	74 09                	je     8023c0 <__udivdi3+0x100>
  8023b7:	89 d8                	mov    %ebx,%eax
  8023b9:	31 ff                	xor    %edi,%edi
  8023bb:	e9 27 ff ff ff       	jmp    8022e7 <__udivdi3+0x27>
  8023c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023c3:	31 ff                	xor    %edi,%edi
  8023c5:	e9 1d ff ff ff       	jmp    8022e7 <__udivdi3+0x27>
  8023ca:	66 90                	xchg   %ax,%ax
  8023cc:	66 90                	xchg   %ax,%ax
  8023ce:	66 90                	xchg   %ax,%ax

008023d0 <__umoddi3>:
  8023d0:	55                   	push   %ebp
  8023d1:	57                   	push   %edi
  8023d2:	56                   	push   %esi
  8023d3:	53                   	push   %ebx
  8023d4:	83 ec 1c             	sub    $0x1c,%esp
  8023d7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8023db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8023df:	8b 74 24 30          	mov    0x30(%esp),%esi
  8023e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023e7:	89 da                	mov    %ebx,%edx
  8023e9:	85 c0                	test   %eax,%eax
  8023eb:	75 43                	jne    802430 <__umoddi3+0x60>
  8023ed:	39 df                	cmp    %ebx,%edi
  8023ef:	76 17                	jbe    802408 <__umoddi3+0x38>
  8023f1:	89 f0                	mov    %esi,%eax
  8023f3:	f7 f7                	div    %edi
  8023f5:	89 d0                	mov    %edx,%eax
  8023f7:	31 d2                	xor    %edx,%edx
  8023f9:	83 c4 1c             	add    $0x1c,%esp
  8023fc:	5b                   	pop    %ebx
  8023fd:	5e                   	pop    %esi
  8023fe:	5f                   	pop    %edi
  8023ff:	5d                   	pop    %ebp
  802400:	c3                   	ret    
  802401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802408:	89 fd                	mov    %edi,%ebp
  80240a:	85 ff                	test   %edi,%edi
  80240c:	75 0b                	jne    802419 <__umoddi3+0x49>
  80240e:	b8 01 00 00 00       	mov    $0x1,%eax
  802413:	31 d2                	xor    %edx,%edx
  802415:	f7 f7                	div    %edi
  802417:	89 c5                	mov    %eax,%ebp
  802419:	89 d8                	mov    %ebx,%eax
  80241b:	31 d2                	xor    %edx,%edx
  80241d:	f7 f5                	div    %ebp
  80241f:	89 f0                	mov    %esi,%eax
  802421:	f7 f5                	div    %ebp
  802423:	89 d0                	mov    %edx,%eax
  802425:	eb d0                	jmp    8023f7 <__umoddi3+0x27>
  802427:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80242e:	66 90                	xchg   %ax,%ax
  802430:	89 f1                	mov    %esi,%ecx
  802432:	39 d8                	cmp    %ebx,%eax
  802434:	76 0a                	jbe    802440 <__umoddi3+0x70>
  802436:	89 f0                	mov    %esi,%eax
  802438:	83 c4 1c             	add    $0x1c,%esp
  80243b:	5b                   	pop    %ebx
  80243c:	5e                   	pop    %esi
  80243d:	5f                   	pop    %edi
  80243e:	5d                   	pop    %ebp
  80243f:	c3                   	ret    
  802440:	0f bd e8             	bsr    %eax,%ebp
  802443:	83 f5 1f             	xor    $0x1f,%ebp
  802446:	75 20                	jne    802468 <__umoddi3+0x98>
  802448:	39 d8                	cmp    %ebx,%eax
  80244a:	0f 82 b0 00 00 00    	jb     802500 <__umoddi3+0x130>
  802450:	39 f7                	cmp    %esi,%edi
  802452:	0f 86 a8 00 00 00    	jbe    802500 <__umoddi3+0x130>
  802458:	89 c8                	mov    %ecx,%eax
  80245a:	83 c4 1c             	add    $0x1c,%esp
  80245d:	5b                   	pop    %ebx
  80245e:	5e                   	pop    %esi
  80245f:	5f                   	pop    %edi
  802460:	5d                   	pop    %ebp
  802461:	c3                   	ret    
  802462:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802468:	89 e9                	mov    %ebp,%ecx
  80246a:	ba 20 00 00 00       	mov    $0x20,%edx
  80246f:	29 ea                	sub    %ebp,%edx
  802471:	d3 e0                	shl    %cl,%eax
  802473:	89 44 24 08          	mov    %eax,0x8(%esp)
  802477:	89 d1                	mov    %edx,%ecx
  802479:	89 f8                	mov    %edi,%eax
  80247b:	d3 e8                	shr    %cl,%eax
  80247d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802481:	89 54 24 04          	mov    %edx,0x4(%esp)
  802485:	8b 54 24 04          	mov    0x4(%esp),%edx
  802489:	09 c1                	or     %eax,%ecx
  80248b:	89 d8                	mov    %ebx,%eax
  80248d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802491:	89 e9                	mov    %ebp,%ecx
  802493:	d3 e7                	shl    %cl,%edi
  802495:	89 d1                	mov    %edx,%ecx
  802497:	d3 e8                	shr    %cl,%eax
  802499:	89 e9                	mov    %ebp,%ecx
  80249b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80249f:	d3 e3                	shl    %cl,%ebx
  8024a1:	89 c7                	mov    %eax,%edi
  8024a3:	89 d1                	mov    %edx,%ecx
  8024a5:	89 f0                	mov    %esi,%eax
  8024a7:	d3 e8                	shr    %cl,%eax
  8024a9:	89 e9                	mov    %ebp,%ecx
  8024ab:	89 fa                	mov    %edi,%edx
  8024ad:	d3 e6                	shl    %cl,%esi
  8024af:	09 d8                	or     %ebx,%eax
  8024b1:	f7 74 24 08          	divl   0x8(%esp)
  8024b5:	89 d1                	mov    %edx,%ecx
  8024b7:	89 f3                	mov    %esi,%ebx
  8024b9:	f7 64 24 0c          	mull   0xc(%esp)
  8024bd:	89 c6                	mov    %eax,%esi
  8024bf:	89 d7                	mov    %edx,%edi
  8024c1:	39 d1                	cmp    %edx,%ecx
  8024c3:	72 06                	jb     8024cb <__umoddi3+0xfb>
  8024c5:	75 10                	jne    8024d7 <__umoddi3+0x107>
  8024c7:	39 c3                	cmp    %eax,%ebx
  8024c9:	73 0c                	jae    8024d7 <__umoddi3+0x107>
  8024cb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8024cf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8024d3:	89 d7                	mov    %edx,%edi
  8024d5:	89 c6                	mov    %eax,%esi
  8024d7:	89 ca                	mov    %ecx,%edx
  8024d9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024de:	29 f3                	sub    %esi,%ebx
  8024e0:	19 fa                	sbb    %edi,%edx
  8024e2:	89 d0                	mov    %edx,%eax
  8024e4:	d3 e0                	shl    %cl,%eax
  8024e6:	89 e9                	mov    %ebp,%ecx
  8024e8:	d3 eb                	shr    %cl,%ebx
  8024ea:	d3 ea                	shr    %cl,%edx
  8024ec:	09 d8                	or     %ebx,%eax
  8024ee:	83 c4 1c             	add    $0x1c,%esp
  8024f1:	5b                   	pop    %ebx
  8024f2:	5e                   	pop    %esi
  8024f3:	5f                   	pop    %edi
  8024f4:	5d                   	pop    %ebp
  8024f5:	c3                   	ret    
  8024f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024fd:	8d 76 00             	lea    0x0(%esi),%esi
  802500:	89 da                	mov    %ebx,%edx
  802502:	29 fe                	sub    %edi,%esi
  802504:	19 c2                	sbb    %eax,%edx
  802506:	89 f1                	mov    %esi,%ecx
  802508:	89 c8                	mov    %ecx,%eax
  80250a:	e9 4b ff ff ff       	jmp    80245a <__umoddi3+0x8a>
