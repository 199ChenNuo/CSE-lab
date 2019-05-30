
obj/user/testfdsharing.debug:     file format elf32-i386


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
  80002c:	e8 99 01 00 00       	call   8001ca <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char buf[512], buf2[512];

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 14             	sub    $0x14,%esp
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  80003c:	6a 00                	push   $0x0
  80003e:	68 60 25 80 00       	push   $0x802560
  800043:	e8 39 1b 00 00       	call   801b81 <open>
  800048:	89 c3                	mov    %eax,%ebx
  80004a:	83 c4 10             	add    $0x10,%esp
  80004d:	85 c0                	test   %eax,%eax
  80004f:	0f 88 ff 00 00 00    	js     800154 <umain+0x121>
		panic("open motd: %e", fd);
	seek(fd, 0);
  800055:	83 ec 08             	sub    $0x8,%esp
  800058:	6a 00                	push   $0x0
  80005a:	50                   	push   %eax
  80005b:	e8 38 18 00 00       	call   801898 <seek>
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  800060:	83 c4 0c             	add    $0xc,%esp
  800063:	68 00 02 00 00       	push   $0x200
  800068:	68 20 42 80 00       	push   $0x804220
  80006d:	53                   	push   %ebx
  80006e:	e8 5e 17 00 00       	call   8017d1 <readn>
  800073:	89 c6                	mov    %eax,%esi
  800075:	83 c4 10             	add    $0x10,%esp
  800078:	85 c0                	test   %eax,%eax
  80007a:	0f 8e e6 00 00 00    	jle    800166 <umain+0x133>
		panic("readn: %e", n);

	if ((r = fork()) < 0)
  800080:	e8 c1 10 00 00       	call   801146 <fork>
  800085:	89 c7                	mov    %eax,%edi
  800087:	85 c0                	test   %eax,%eax
  800089:	0f 88 e9 00 00 00    	js     800178 <umain+0x145>
		panic("fork: %e", r);
	if (r == 0) {
  80008f:	75 7b                	jne    80010c <umain+0xd9>
		seek(fd, 0);
  800091:	83 ec 08             	sub    $0x8,%esp
  800094:	6a 00                	push   $0x0
  800096:	53                   	push   %ebx
  800097:	e8 fc 17 00 00       	call   801898 <seek>
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  80009c:	c7 04 24 d0 25 80 00 	movl   $0x8025d0,(%esp)
  8000a3:	e8 58 02 00 00       	call   800300 <cprintf>
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8000a8:	83 c4 0c             	add    $0xc,%esp
  8000ab:	68 00 02 00 00       	push   $0x200
  8000b0:	68 20 40 80 00       	push   $0x804020
  8000b5:	53                   	push   %ebx
  8000b6:	e8 16 17 00 00       	call   8017d1 <readn>
  8000bb:	83 c4 10             	add    $0x10,%esp
  8000be:	39 c6                	cmp    %eax,%esi
  8000c0:	0f 85 c4 00 00 00    	jne    80018a <umain+0x157>
			panic("read in parent got %d, read in child got %d", n, n2);
		if (memcmp(buf, buf2, n) != 0)
  8000c6:	83 ec 04             	sub    $0x4,%esp
  8000c9:	56                   	push   %esi
  8000ca:	68 20 40 80 00       	push   $0x804020
  8000cf:	68 20 42 80 00       	push   $0x804220
  8000d4:	e8 53 0b 00 00       	call   800c2c <memcmp>
  8000d9:	83 c4 10             	add    $0x10,%esp
  8000dc:	85 c0                	test   %eax,%eax
  8000de:	0f 85 bc 00 00 00    	jne    8001a0 <umain+0x16d>
			panic("read in parent got different bytes from read in child");
		cprintf("read in child succeeded\n");
  8000e4:	83 ec 0c             	sub    $0xc,%esp
  8000e7:	68 9b 25 80 00       	push   $0x80259b
  8000ec:	e8 0f 02 00 00       	call   800300 <cprintf>
		seek(fd, 0);
  8000f1:	83 c4 08             	add    $0x8,%esp
  8000f4:	6a 00                	push   $0x0
  8000f6:	53                   	push   %ebx
  8000f7:	e8 9c 17 00 00       	call   801898 <seek>
		close(fd);
  8000fc:	89 1c 24             	mov    %ebx,(%esp)
  8000ff:	e8 08 15 00 00       	call   80160c <close>
		exit();
  800104:	e8 0a 01 00 00       	call   800213 <exit>
  800109:	83 c4 10             	add    $0x10,%esp
	}
	wait(r);
  80010c:	83 ec 0c             	sub    $0xc,%esp
  80010f:	57                   	push   %edi
  800110:	e8 5f 1e 00 00       	call   801f74 <wait>
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800115:	83 c4 0c             	add    $0xc,%esp
  800118:	68 00 02 00 00       	push   $0x200
  80011d:	68 20 40 80 00       	push   $0x804020
  800122:	53                   	push   %ebx
  800123:	e8 a9 16 00 00       	call   8017d1 <readn>
  800128:	83 c4 10             	add    $0x10,%esp
  80012b:	39 c6                	cmp    %eax,%esi
  80012d:	0f 85 81 00 00 00    	jne    8001b4 <umain+0x181>
		panic("read in parent got %d, then got %d", n, n2);
	cprintf("read in parent succeeded\n");
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	68 b4 25 80 00       	push   $0x8025b4
  80013b:	e8 c0 01 00 00       	call   800300 <cprintf>
	close(fd);
  800140:	89 1c 24             	mov    %ebx,(%esp)
  800143:	e8 c4 14 00 00       	call   80160c <close>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  800148:	cc                   	int3   

	breakpoint();
}
  800149:	83 c4 10             	add    $0x10,%esp
  80014c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80014f:	5b                   	pop    %ebx
  800150:	5e                   	pop    %esi
  800151:	5f                   	pop    %edi
  800152:	5d                   	pop    %ebp
  800153:	c3                   	ret    
		panic("open motd: %e", fd);
  800154:	50                   	push   %eax
  800155:	68 65 25 80 00       	push   $0x802565
  80015a:	6a 0c                	push   $0xc
  80015c:	68 73 25 80 00       	push   $0x802573
  800161:	e8 bf 00 00 00       	call   800225 <_panic>
		panic("readn: %e", n);
  800166:	50                   	push   %eax
  800167:	68 88 25 80 00       	push   $0x802588
  80016c:	6a 0f                	push   $0xf
  80016e:	68 73 25 80 00       	push   $0x802573
  800173:	e8 ad 00 00 00       	call   800225 <_panic>
		panic("fork: %e", r);
  800178:	50                   	push   %eax
  800179:	68 92 25 80 00       	push   $0x802592
  80017e:	6a 12                	push   $0x12
  800180:	68 73 25 80 00       	push   $0x802573
  800185:	e8 9b 00 00 00       	call   800225 <_panic>
			panic("read in parent got %d, read in child got %d", n, n2);
  80018a:	83 ec 0c             	sub    $0xc,%esp
  80018d:	50                   	push   %eax
  80018e:	56                   	push   %esi
  80018f:	68 14 26 80 00       	push   $0x802614
  800194:	6a 17                	push   $0x17
  800196:	68 73 25 80 00       	push   $0x802573
  80019b:	e8 85 00 00 00       	call   800225 <_panic>
			panic("read in parent got different bytes from read in child");
  8001a0:	83 ec 04             	sub    $0x4,%esp
  8001a3:	68 40 26 80 00       	push   $0x802640
  8001a8:	6a 19                	push   $0x19
  8001aa:	68 73 25 80 00       	push   $0x802573
  8001af:	e8 71 00 00 00       	call   800225 <_panic>
		panic("read in parent got %d, then got %d", n, n2);
  8001b4:	83 ec 0c             	sub    $0xc,%esp
  8001b7:	50                   	push   %eax
  8001b8:	56                   	push   %esi
  8001b9:	68 78 26 80 00       	push   $0x802678
  8001be:	6a 21                	push   $0x21
  8001c0:	68 73 25 80 00       	push   $0x802573
  8001c5:	e8 5b 00 00 00       	call   800225 <_panic>

008001ca <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001ca:	55                   	push   %ebp
  8001cb:	89 e5                	mov    %esp,%ebp
  8001cd:	56                   	push   %esi
  8001ce:	53                   	push   %ebx
  8001cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001d2:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  8001d5:	e8 00 0c 00 00       	call   800dda <sys_getenvid>
  8001da:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001df:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8001e5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001ea:	a3 20 44 80 00       	mov    %eax,0x804420

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ef:	85 db                	test   %ebx,%ebx
  8001f1:	7e 07                	jle    8001fa <libmain+0x30>
		binaryname = argv[0];
  8001f3:	8b 06                	mov    (%esi),%eax
  8001f5:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8001fa:	83 ec 08             	sub    $0x8,%esp
  8001fd:	56                   	push   %esi
  8001fe:	53                   	push   %ebx
  8001ff:	e8 2f fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800204:	e8 0a 00 00 00       	call   800213 <exit>
}
  800209:	83 c4 10             	add    $0x10,%esp
  80020c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80020f:	5b                   	pop    %ebx
  800210:	5e                   	pop    %esi
  800211:	5d                   	pop    %ebp
  800212:	c3                   	ret    

00800213 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800213:	55                   	push   %ebp
  800214:	89 e5                	mov    %esp,%ebp
  800216:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800219:	6a 00                	push   $0x0
  80021b:	e8 79 0b 00 00       	call   800d99 <sys_env_destroy>
}
  800220:	83 c4 10             	add    $0x10,%esp
  800223:	c9                   	leave  
  800224:	c3                   	ret    

00800225 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800225:	55                   	push   %ebp
  800226:	89 e5                	mov    %esp,%ebp
  800228:	56                   	push   %esi
  800229:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80022a:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80022d:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800233:	e8 a2 0b 00 00       	call   800dda <sys_getenvid>
  800238:	83 ec 0c             	sub    $0xc,%esp
  80023b:	ff 75 0c             	pushl  0xc(%ebp)
  80023e:	ff 75 08             	pushl  0x8(%ebp)
  800241:	56                   	push   %esi
  800242:	50                   	push   %eax
  800243:	68 a8 26 80 00       	push   $0x8026a8
  800248:	e8 b3 00 00 00       	call   800300 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80024d:	83 c4 18             	add    $0x18,%esp
  800250:	53                   	push   %ebx
  800251:	ff 75 10             	pushl  0x10(%ebp)
  800254:	e8 56 00 00 00       	call   8002af <vcprintf>
	cprintf("\n");
  800259:	c7 04 24 75 2a 80 00 	movl   $0x802a75,(%esp)
  800260:	e8 9b 00 00 00       	call   800300 <cprintf>
  800265:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800268:	cc                   	int3   
  800269:	eb fd                	jmp    800268 <_panic+0x43>

0080026b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80026b:	55                   	push   %ebp
  80026c:	89 e5                	mov    %esp,%ebp
  80026e:	53                   	push   %ebx
  80026f:	83 ec 04             	sub    $0x4,%esp
  800272:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800275:	8b 13                	mov    (%ebx),%edx
  800277:	8d 42 01             	lea    0x1(%edx),%eax
  80027a:	89 03                	mov    %eax,(%ebx)
  80027c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80027f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800283:	3d ff 00 00 00       	cmp    $0xff,%eax
  800288:	74 09                	je     800293 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80028a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80028e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800291:	c9                   	leave  
  800292:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800293:	83 ec 08             	sub    $0x8,%esp
  800296:	68 ff 00 00 00       	push   $0xff
  80029b:	8d 43 08             	lea    0x8(%ebx),%eax
  80029e:	50                   	push   %eax
  80029f:	e8 b8 0a 00 00       	call   800d5c <sys_cputs>
		b->idx = 0;
  8002a4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002aa:	83 c4 10             	add    $0x10,%esp
  8002ad:	eb db                	jmp    80028a <putch+0x1f>

008002af <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002af:	55                   	push   %ebp
  8002b0:	89 e5                	mov    %esp,%ebp
  8002b2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002b8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002bf:	00 00 00 
	b.cnt = 0;
  8002c2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002c9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002cc:	ff 75 0c             	pushl  0xc(%ebp)
  8002cf:	ff 75 08             	pushl  0x8(%ebp)
  8002d2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002d8:	50                   	push   %eax
  8002d9:	68 6b 02 80 00       	push   $0x80026b
  8002de:	e8 4a 01 00 00       	call   80042d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002e3:	83 c4 08             	add    $0x8,%esp
  8002e6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002ec:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002f2:	50                   	push   %eax
  8002f3:	e8 64 0a 00 00       	call   800d5c <sys_cputs>

	return b.cnt;
}
  8002f8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002fe:	c9                   	leave  
  8002ff:	c3                   	ret    

00800300 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800300:	55                   	push   %ebp
  800301:	89 e5                	mov    %esp,%ebp
  800303:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800306:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800309:	50                   	push   %eax
  80030a:	ff 75 08             	pushl  0x8(%ebp)
  80030d:	e8 9d ff ff ff       	call   8002af <vcprintf>
	va_end(ap);

	return cnt;
}
  800312:	c9                   	leave  
  800313:	c3                   	ret    

00800314 <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800314:	55                   	push   %ebp
  800315:	89 e5                	mov    %esp,%ebp
  800317:	57                   	push   %edi
  800318:	56                   	push   %esi
  800319:	53                   	push   %ebx
  80031a:	83 ec 1c             	sub    $0x1c,%esp
  80031d:	89 c6                	mov    %eax,%esi
  80031f:	89 d7                	mov    %edx,%edi
  800321:	8b 45 08             	mov    0x8(%ebp),%eax
  800324:	8b 55 0c             	mov    0xc(%ebp),%edx
  800327:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80032a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80032d:	8b 45 10             	mov    0x10(%ebp),%eax
  800330:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  800333:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800337:	74 2c                	je     800365 <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800339:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80033c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800343:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800346:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800349:	39 c2                	cmp    %eax,%edx
  80034b:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80034e:	73 43                	jae    800393 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800350:	83 eb 01             	sub    $0x1,%ebx
  800353:	85 db                	test   %ebx,%ebx
  800355:	7e 6c                	jle    8003c3 <printnum+0xaf>
			putch(padc, putdat);
  800357:	83 ec 08             	sub    $0x8,%esp
  80035a:	57                   	push   %edi
  80035b:	ff 75 18             	pushl  0x18(%ebp)
  80035e:	ff d6                	call   *%esi
  800360:	83 c4 10             	add    $0x10,%esp
  800363:	eb eb                	jmp    800350 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800365:	83 ec 0c             	sub    $0xc,%esp
  800368:	6a 20                	push   $0x20
  80036a:	6a 00                	push   $0x0
  80036c:	50                   	push   %eax
  80036d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800370:	ff 75 e0             	pushl  -0x20(%ebp)
  800373:	89 fa                	mov    %edi,%edx
  800375:	89 f0                	mov    %esi,%eax
  800377:	e8 98 ff ff ff       	call   800314 <printnum>
		while (--width > 0)
  80037c:	83 c4 20             	add    $0x20,%esp
  80037f:	83 eb 01             	sub    $0x1,%ebx
  800382:	85 db                	test   %ebx,%ebx
  800384:	7e 65                	jle    8003eb <printnum+0xd7>
			putch(' ', putdat);
  800386:	83 ec 08             	sub    $0x8,%esp
  800389:	57                   	push   %edi
  80038a:	6a 20                	push   $0x20
  80038c:	ff d6                	call   *%esi
  80038e:	83 c4 10             	add    $0x10,%esp
  800391:	eb ec                	jmp    80037f <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800393:	83 ec 0c             	sub    $0xc,%esp
  800396:	ff 75 18             	pushl  0x18(%ebp)
  800399:	83 eb 01             	sub    $0x1,%ebx
  80039c:	53                   	push   %ebx
  80039d:	50                   	push   %eax
  80039e:	83 ec 08             	sub    $0x8,%esp
  8003a1:	ff 75 dc             	pushl  -0x24(%ebp)
  8003a4:	ff 75 d8             	pushl  -0x28(%ebp)
  8003a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003aa:	ff 75 e0             	pushl  -0x20(%ebp)
  8003ad:	e8 4e 1f 00 00       	call   802300 <__udivdi3>
  8003b2:	83 c4 18             	add    $0x18,%esp
  8003b5:	52                   	push   %edx
  8003b6:	50                   	push   %eax
  8003b7:	89 fa                	mov    %edi,%edx
  8003b9:	89 f0                	mov    %esi,%eax
  8003bb:	e8 54 ff ff ff       	call   800314 <printnum>
  8003c0:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003c3:	83 ec 08             	sub    $0x8,%esp
  8003c6:	57                   	push   %edi
  8003c7:	83 ec 04             	sub    $0x4,%esp
  8003ca:	ff 75 dc             	pushl  -0x24(%ebp)
  8003cd:	ff 75 d8             	pushl  -0x28(%ebp)
  8003d0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003d3:	ff 75 e0             	pushl  -0x20(%ebp)
  8003d6:	e8 35 20 00 00       	call   802410 <__umoddi3>
  8003db:	83 c4 14             	add    $0x14,%esp
  8003de:	0f be 80 cb 26 80 00 	movsbl 0x8026cb(%eax),%eax
  8003e5:	50                   	push   %eax
  8003e6:	ff d6                	call   *%esi
  8003e8:	83 c4 10             	add    $0x10,%esp
}
  8003eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003ee:	5b                   	pop    %ebx
  8003ef:	5e                   	pop    %esi
  8003f0:	5f                   	pop    %edi
  8003f1:	5d                   	pop    %ebp
  8003f2:	c3                   	ret    

008003f3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003f3:	55                   	push   %ebp
  8003f4:	89 e5                	mov    %esp,%ebp
  8003f6:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003f9:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003fd:	8b 10                	mov    (%eax),%edx
  8003ff:	3b 50 04             	cmp    0x4(%eax),%edx
  800402:	73 0a                	jae    80040e <sprintputch+0x1b>
		*b->buf++ = ch;
  800404:	8d 4a 01             	lea    0x1(%edx),%ecx
  800407:	89 08                	mov    %ecx,(%eax)
  800409:	8b 45 08             	mov    0x8(%ebp),%eax
  80040c:	88 02                	mov    %al,(%edx)
}
  80040e:	5d                   	pop    %ebp
  80040f:	c3                   	ret    

00800410 <printfmt>:
{
  800410:	55                   	push   %ebp
  800411:	89 e5                	mov    %esp,%ebp
  800413:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800416:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800419:	50                   	push   %eax
  80041a:	ff 75 10             	pushl  0x10(%ebp)
  80041d:	ff 75 0c             	pushl  0xc(%ebp)
  800420:	ff 75 08             	pushl  0x8(%ebp)
  800423:	e8 05 00 00 00       	call   80042d <vprintfmt>
}
  800428:	83 c4 10             	add    $0x10,%esp
  80042b:	c9                   	leave  
  80042c:	c3                   	ret    

0080042d <vprintfmt>:
{
  80042d:	55                   	push   %ebp
  80042e:	89 e5                	mov    %esp,%ebp
  800430:	57                   	push   %edi
  800431:	56                   	push   %esi
  800432:	53                   	push   %ebx
  800433:	83 ec 3c             	sub    $0x3c,%esp
  800436:	8b 75 08             	mov    0x8(%ebp),%esi
  800439:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80043c:	8b 7d 10             	mov    0x10(%ebp),%edi
  80043f:	e9 1e 04 00 00       	jmp    800862 <vprintfmt+0x435>
		posflag = 0;
  800444:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  80044b:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80044f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800456:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80045d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800464:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  80046b:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800470:	8d 47 01             	lea    0x1(%edi),%eax
  800473:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800476:	0f b6 17             	movzbl (%edi),%edx
  800479:	8d 42 dd             	lea    -0x23(%edx),%eax
  80047c:	3c 55                	cmp    $0x55,%al
  80047e:	0f 87 d9 04 00 00    	ja     80095d <vprintfmt+0x530>
  800484:	0f b6 c0             	movzbl %al,%eax
  800487:	ff 24 85 a0 28 80 00 	jmp    *0x8028a0(,%eax,4)
  80048e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800491:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800495:	eb d9                	jmp    800470 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800497:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  80049a:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  8004a1:	eb cd                	jmp    800470 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004a3:	0f b6 d2             	movzbl %dl,%edx
  8004a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ae:	89 75 08             	mov    %esi,0x8(%ebp)
  8004b1:	eb 0c                	jmp    8004bf <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  8004b3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8004b6:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  8004ba:	eb b4                	jmp    800470 <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  8004bc:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004bf:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004c2:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004c6:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004c9:	8d 72 d0             	lea    -0x30(%edx),%esi
  8004cc:	83 fe 09             	cmp    $0x9,%esi
  8004cf:	76 eb                	jbe    8004bc <vprintfmt+0x8f>
  8004d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004d4:	8b 75 08             	mov    0x8(%ebp),%esi
  8004d7:	eb 14                	jmp    8004ed <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  8004d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004dc:	8b 00                	mov    (%eax),%eax
  8004de:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e4:	8d 40 04             	lea    0x4(%eax),%eax
  8004e7:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004ed:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004f1:	0f 89 79 ff ff ff    	jns    800470 <vprintfmt+0x43>
				width = precision, precision = -1;
  8004f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004fd:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800504:	e9 67 ff ff ff       	jmp    800470 <vprintfmt+0x43>
  800509:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80050c:	85 c0                	test   %eax,%eax
  80050e:	0f 48 c1             	cmovs  %ecx,%eax
  800511:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800514:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800517:	e9 54 ff ff ff       	jmp    800470 <vprintfmt+0x43>
  80051c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80051f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800526:	e9 45 ff ff ff       	jmp    800470 <vprintfmt+0x43>
			lflag++;
  80052b:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80052f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800532:	e9 39 ff ff ff       	jmp    800470 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800537:	8b 45 14             	mov    0x14(%ebp),%eax
  80053a:	8d 78 04             	lea    0x4(%eax),%edi
  80053d:	83 ec 08             	sub    $0x8,%esp
  800540:	53                   	push   %ebx
  800541:	ff 30                	pushl  (%eax)
  800543:	ff d6                	call   *%esi
			break;
  800545:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800548:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80054b:	e9 0f 03 00 00       	jmp    80085f <vprintfmt+0x432>
			err = va_arg(ap, int);
  800550:	8b 45 14             	mov    0x14(%ebp),%eax
  800553:	8d 78 04             	lea    0x4(%eax),%edi
  800556:	8b 00                	mov    (%eax),%eax
  800558:	99                   	cltd   
  800559:	31 d0                	xor    %edx,%eax
  80055b:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80055d:	83 f8 0f             	cmp    $0xf,%eax
  800560:	7f 23                	jg     800585 <vprintfmt+0x158>
  800562:	8b 14 85 00 2a 80 00 	mov    0x802a00(,%eax,4),%edx
  800569:	85 d2                	test   %edx,%edx
  80056b:	74 18                	je     800585 <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  80056d:	52                   	push   %edx
  80056e:	68 1e 2d 80 00       	push   $0x802d1e
  800573:	53                   	push   %ebx
  800574:	56                   	push   %esi
  800575:	e8 96 fe ff ff       	call   800410 <printfmt>
  80057a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80057d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800580:	e9 da 02 00 00       	jmp    80085f <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  800585:	50                   	push   %eax
  800586:	68 e3 26 80 00       	push   $0x8026e3
  80058b:	53                   	push   %ebx
  80058c:	56                   	push   %esi
  80058d:	e8 7e fe ff ff       	call   800410 <printfmt>
  800592:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800595:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800598:	e9 c2 02 00 00       	jmp    80085f <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  80059d:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a0:	83 c0 04             	add    $0x4,%eax
  8005a3:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8005a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a9:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8005ab:	85 c9                	test   %ecx,%ecx
  8005ad:	b8 dc 26 80 00       	mov    $0x8026dc,%eax
  8005b2:	0f 45 c1             	cmovne %ecx,%eax
  8005b5:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8005b8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005bc:	7e 06                	jle    8005c4 <vprintfmt+0x197>
  8005be:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8005c2:	75 0d                	jne    8005d1 <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005c7:	89 c7                	mov    %eax,%edi
  8005c9:	03 45 e0             	add    -0x20(%ebp),%eax
  8005cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005cf:	eb 53                	jmp    800624 <vprintfmt+0x1f7>
  8005d1:	83 ec 08             	sub    $0x8,%esp
  8005d4:	ff 75 d8             	pushl  -0x28(%ebp)
  8005d7:	50                   	push   %eax
  8005d8:	e8 28 04 00 00       	call   800a05 <strnlen>
  8005dd:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005e0:	29 c1                	sub    %eax,%ecx
  8005e2:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  8005e5:	83 c4 10             	add    $0x10,%esp
  8005e8:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8005ea:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8005ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005f1:	eb 0f                	jmp    800602 <vprintfmt+0x1d5>
					putch(padc, putdat);
  8005f3:	83 ec 08             	sub    $0x8,%esp
  8005f6:	53                   	push   %ebx
  8005f7:	ff 75 e0             	pushl  -0x20(%ebp)
  8005fa:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005fc:	83 ef 01             	sub    $0x1,%edi
  8005ff:	83 c4 10             	add    $0x10,%esp
  800602:	85 ff                	test   %edi,%edi
  800604:	7f ed                	jg     8005f3 <vprintfmt+0x1c6>
  800606:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800609:	85 c9                	test   %ecx,%ecx
  80060b:	b8 00 00 00 00       	mov    $0x0,%eax
  800610:	0f 49 c1             	cmovns %ecx,%eax
  800613:	29 c1                	sub    %eax,%ecx
  800615:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800618:	eb aa                	jmp    8005c4 <vprintfmt+0x197>
					putch(ch, putdat);
  80061a:	83 ec 08             	sub    $0x8,%esp
  80061d:	53                   	push   %ebx
  80061e:	52                   	push   %edx
  80061f:	ff d6                	call   *%esi
  800621:	83 c4 10             	add    $0x10,%esp
  800624:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800627:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800629:	83 c7 01             	add    $0x1,%edi
  80062c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800630:	0f be d0             	movsbl %al,%edx
  800633:	85 d2                	test   %edx,%edx
  800635:	74 4b                	je     800682 <vprintfmt+0x255>
  800637:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80063b:	78 06                	js     800643 <vprintfmt+0x216>
  80063d:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800641:	78 1e                	js     800661 <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  800643:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800647:	74 d1                	je     80061a <vprintfmt+0x1ed>
  800649:	0f be c0             	movsbl %al,%eax
  80064c:	83 e8 20             	sub    $0x20,%eax
  80064f:	83 f8 5e             	cmp    $0x5e,%eax
  800652:	76 c6                	jbe    80061a <vprintfmt+0x1ed>
					putch('?', putdat);
  800654:	83 ec 08             	sub    $0x8,%esp
  800657:	53                   	push   %ebx
  800658:	6a 3f                	push   $0x3f
  80065a:	ff d6                	call   *%esi
  80065c:	83 c4 10             	add    $0x10,%esp
  80065f:	eb c3                	jmp    800624 <vprintfmt+0x1f7>
  800661:	89 cf                	mov    %ecx,%edi
  800663:	eb 0e                	jmp    800673 <vprintfmt+0x246>
				putch(' ', putdat);
  800665:	83 ec 08             	sub    $0x8,%esp
  800668:	53                   	push   %ebx
  800669:	6a 20                	push   $0x20
  80066b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80066d:	83 ef 01             	sub    $0x1,%edi
  800670:	83 c4 10             	add    $0x10,%esp
  800673:	85 ff                	test   %edi,%edi
  800675:	7f ee                	jg     800665 <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  800677:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80067a:	89 45 14             	mov    %eax,0x14(%ebp)
  80067d:	e9 dd 01 00 00       	jmp    80085f <vprintfmt+0x432>
  800682:	89 cf                	mov    %ecx,%edi
  800684:	eb ed                	jmp    800673 <vprintfmt+0x246>
	if (lflag >= 2)
  800686:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80068a:	7f 21                	jg     8006ad <vprintfmt+0x280>
	else if (lflag)
  80068c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800690:	74 6a                	je     8006fc <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  800692:	8b 45 14             	mov    0x14(%ebp),%eax
  800695:	8b 00                	mov    (%eax),%eax
  800697:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069a:	89 c1                	mov    %eax,%ecx
  80069c:	c1 f9 1f             	sar    $0x1f,%ecx
  80069f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a5:	8d 40 04             	lea    0x4(%eax),%eax
  8006a8:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ab:	eb 17                	jmp    8006c4 <vprintfmt+0x297>
		return va_arg(*ap, long long);
  8006ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b0:	8b 50 04             	mov    0x4(%eax),%edx
  8006b3:	8b 00                	mov    (%eax),%eax
  8006b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006be:	8d 40 08             	lea    0x8(%eax),%eax
  8006c1:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8006c4:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  8006c7:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8006cc:	85 d2                	test   %edx,%edx
  8006ce:	0f 89 5c 01 00 00    	jns    800830 <vprintfmt+0x403>
				putch('-', putdat);
  8006d4:	83 ec 08             	sub    $0x8,%esp
  8006d7:	53                   	push   %ebx
  8006d8:	6a 2d                	push   $0x2d
  8006da:	ff d6                	call   *%esi
				num = -(long long) num;
  8006dc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006df:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006e2:	f7 d8                	neg    %eax
  8006e4:	83 d2 00             	adc    $0x0,%edx
  8006e7:	f7 da                	neg    %edx
  8006e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ec:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ef:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006f2:	bf 0a 00 00 00       	mov    $0xa,%edi
  8006f7:	e9 45 01 00 00       	jmp    800841 <vprintfmt+0x414>
		return va_arg(*ap, int);
  8006fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ff:	8b 00                	mov    (%eax),%eax
  800701:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800704:	89 c1                	mov    %eax,%ecx
  800706:	c1 f9 1f             	sar    $0x1f,%ecx
  800709:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80070c:	8b 45 14             	mov    0x14(%ebp),%eax
  80070f:	8d 40 04             	lea    0x4(%eax),%eax
  800712:	89 45 14             	mov    %eax,0x14(%ebp)
  800715:	eb ad                	jmp    8006c4 <vprintfmt+0x297>
	if (lflag >= 2)
  800717:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80071b:	7f 29                	jg     800746 <vprintfmt+0x319>
	else if (lflag)
  80071d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800721:	74 44                	je     800767 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  800723:	8b 45 14             	mov    0x14(%ebp),%eax
  800726:	8b 00                	mov    (%eax),%eax
  800728:	ba 00 00 00 00       	mov    $0x0,%edx
  80072d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800730:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800733:	8b 45 14             	mov    0x14(%ebp),%eax
  800736:	8d 40 04             	lea    0x4(%eax),%eax
  800739:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80073c:	bf 0a 00 00 00       	mov    $0xa,%edi
  800741:	e9 ea 00 00 00       	jmp    800830 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800746:	8b 45 14             	mov    0x14(%ebp),%eax
  800749:	8b 50 04             	mov    0x4(%eax),%edx
  80074c:	8b 00                	mov    (%eax),%eax
  80074e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800751:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800754:	8b 45 14             	mov    0x14(%ebp),%eax
  800757:	8d 40 08             	lea    0x8(%eax),%eax
  80075a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80075d:	bf 0a 00 00 00       	mov    $0xa,%edi
  800762:	e9 c9 00 00 00       	jmp    800830 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800767:	8b 45 14             	mov    0x14(%ebp),%eax
  80076a:	8b 00                	mov    (%eax),%eax
  80076c:	ba 00 00 00 00       	mov    $0x0,%edx
  800771:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800774:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800777:	8b 45 14             	mov    0x14(%ebp),%eax
  80077a:	8d 40 04             	lea    0x4(%eax),%eax
  80077d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800780:	bf 0a 00 00 00       	mov    $0xa,%edi
  800785:	e9 a6 00 00 00       	jmp    800830 <vprintfmt+0x403>
			putch('0', putdat);
  80078a:	83 ec 08             	sub    $0x8,%esp
  80078d:	53                   	push   %ebx
  80078e:	6a 30                	push   $0x30
  800790:	ff d6                	call   *%esi
	if (lflag >= 2)
  800792:	83 c4 10             	add    $0x10,%esp
  800795:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800799:	7f 26                	jg     8007c1 <vprintfmt+0x394>
	else if (lflag)
  80079b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80079f:	74 3e                	je     8007df <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  8007a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ae:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b4:	8d 40 04             	lea    0x4(%eax),%eax
  8007b7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007ba:	bf 08 00 00 00       	mov    $0x8,%edi
  8007bf:	eb 6f                	jmp    800830 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8007c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c4:	8b 50 04             	mov    0x4(%eax),%edx
  8007c7:	8b 00                	mov    (%eax),%eax
  8007c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007cc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d2:	8d 40 08             	lea    0x8(%eax),%eax
  8007d5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007d8:	bf 08 00 00 00       	mov    $0x8,%edi
  8007dd:	eb 51                	jmp    800830 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8007df:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e2:	8b 00                	mov    (%eax),%eax
  8007e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ec:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f2:	8d 40 04             	lea    0x4(%eax),%eax
  8007f5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007f8:	bf 08 00 00 00       	mov    $0x8,%edi
  8007fd:	eb 31                	jmp    800830 <vprintfmt+0x403>
			putch('0', putdat);
  8007ff:	83 ec 08             	sub    $0x8,%esp
  800802:	53                   	push   %ebx
  800803:	6a 30                	push   $0x30
  800805:	ff d6                	call   *%esi
			putch('x', putdat);
  800807:	83 c4 08             	add    $0x8,%esp
  80080a:	53                   	push   %ebx
  80080b:	6a 78                	push   $0x78
  80080d:	ff d6                	call   *%esi
			num = (unsigned long long)
  80080f:	8b 45 14             	mov    0x14(%ebp),%eax
  800812:	8b 00                	mov    (%eax),%eax
  800814:	ba 00 00 00 00       	mov    $0x0,%edx
  800819:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80081c:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80081f:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800822:	8b 45 14             	mov    0x14(%ebp),%eax
  800825:	8d 40 04             	lea    0x4(%eax),%eax
  800828:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80082b:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  800830:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800834:	74 0b                	je     800841 <vprintfmt+0x414>
				putch('+', putdat);
  800836:	83 ec 08             	sub    $0x8,%esp
  800839:	53                   	push   %ebx
  80083a:	6a 2b                	push   $0x2b
  80083c:	ff d6                	call   *%esi
  80083e:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  800841:	83 ec 0c             	sub    $0xc,%esp
  800844:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800848:	50                   	push   %eax
  800849:	ff 75 e0             	pushl  -0x20(%ebp)
  80084c:	57                   	push   %edi
  80084d:	ff 75 dc             	pushl  -0x24(%ebp)
  800850:	ff 75 d8             	pushl  -0x28(%ebp)
  800853:	89 da                	mov    %ebx,%edx
  800855:	89 f0                	mov    %esi,%eax
  800857:	e8 b8 fa ff ff       	call   800314 <printnum>
			break;
  80085c:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  80085f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800862:	83 c7 01             	add    $0x1,%edi
  800865:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800869:	83 f8 25             	cmp    $0x25,%eax
  80086c:	0f 84 d2 fb ff ff    	je     800444 <vprintfmt+0x17>
			if (ch == '\0')
  800872:	85 c0                	test   %eax,%eax
  800874:	0f 84 03 01 00 00    	je     80097d <vprintfmt+0x550>
			putch(ch, putdat);
  80087a:	83 ec 08             	sub    $0x8,%esp
  80087d:	53                   	push   %ebx
  80087e:	50                   	push   %eax
  80087f:	ff d6                	call   *%esi
  800881:	83 c4 10             	add    $0x10,%esp
  800884:	eb dc                	jmp    800862 <vprintfmt+0x435>
	if (lflag >= 2)
  800886:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80088a:	7f 29                	jg     8008b5 <vprintfmt+0x488>
	else if (lflag)
  80088c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800890:	74 44                	je     8008d6 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  800892:	8b 45 14             	mov    0x14(%ebp),%eax
  800895:	8b 00                	mov    (%eax),%eax
  800897:	ba 00 00 00 00       	mov    $0x0,%edx
  80089c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80089f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a5:	8d 40 04             	lea    0x4(%eax),%eax
  8008a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008ab:	bf 10 00 00 00       	mov    $0x10,%edi
  8008b0:	e9 7b ff ff ff       	jmp    800830 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8008b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b8:	8b 50 04             	mov    0x4(%eax),%edx
  8008bb:	8b 00                	mov    (%eax),%eax
  8008bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008c0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c6:	8d 40 08             	lea    0x8(%eax),%eax
  8008c9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008cc:	bf 10 00 00 00       	mov    $0x10,%edi
  8008d1:	e9 5a ff ff ff       	jmp    800830 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8008d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d9:	8b 00                	mov    (%eax),%eax
  8008db:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008e3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e9:	8d 40 04             	lea    0x4(%eax),%eax
  8008ec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008ef:	bf 10 00 00 00       	mov    $0x10,%edi
  8008f4:	e9 37 ff ff ff       	jmp    800830 <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  8008f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fc:	8d 78 04             	lea    0x4(%eax),%edi
  8008ff:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  800901:	85 c0                	test   %eax,%eax
  800903:	74 2c                	je     800931 <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  800905:	8b 13                	mov    (%ebx),%edx
  800907:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  800909:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  80090c:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  80090f:	0f 8e 4a ff ff ff    	jle    80085f <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  800915:	68 38 28 80 00       	push   $0x802838
  80091a:	68 1e 2d 80 00       	push   $0x802d1e
  80091f:	53                   	push   %ebx
  800920:	56                   	push   %esi
  800921:	e8 ea fa ff ff       	call   800410 <printfmt>
  800926:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800929:	89 7d 14             	mov    %edi,0x14(%ebp)
  80092c:	e9 2e ff ff ff       	jmp    80085f <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  800931:	68 00 28 80 00       	push   $0x802800
  800936:	68 1e 2d 80 00       	push   $0x802d1e
  80093b:	53                   	push   %ebx
  80093c:	56                   	push   %esi
  80093d:	e8 ce fa ff ff       	call   800410 <printfmt>
        		break;
  800942:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800945:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  800948:	e9 12 ff ff ff       	jmp    80085f <vprintfmt+0x432>
			putch(ch, putdat);
  80094d:	83 ec 08             	sub    $0x8,%esp
  800950:	53                   	push   %ebx
  800951:	6a 25                	push   $0x25
  800953:	ff d6                	call   *%esi
			break;
  800955:	83 c4 10             	add    $0x10,%esp
  800958:	e9 02 ff ff ff       	jmp    80085f <vprintfmt+0x432>
			putch('%', putdat);
  80095d:	83 ec 08             	sub    $0x8,%esp
  800960:	53                   	push   %ebx
  800961:	6a 25                	push   $0x25
  800963:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800965:	83 c4 10             	add    $0x10,%esp
  800968:	89 f8                	mov    %edi,%eax
  80096a:	eb 03                	jmp    80096f <vprintfmt+0x542>
  80096c:	83 e8 01             	sub    $0x1,%eax
  80096f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800973:	75 f7                	jne    80096c <vprintfmt+0x53f>
  800975:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800978:	e9 e2 fe ff ff       	jmp    80085f <vprintfmt+0x432>
}
  80097d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800980:	5b                   	pop    %ebx
  800981:	5e                   	pop    %esi
  800982:	5f                   	pop    %edi
  800983:	5d                   	pop    %ebp
  800984:	c3                   	ret    

00800985 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800985:	55                   	push   %ebp
  800986:	89 e5                	mov    %esp,%ebp
  800988:	83 ec 18             	sub    $0x18,%esp
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800991:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800994:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800998:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80099b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009a2:	85 c0                	test   %eax,%eax
  8009a4:	74 26                	je     8009cc <vsnprintf+0x47>
  8009a6:	85 d2                	test   %edx,%edx
  8009a8:	7e 22                	jle    8009cc <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009aa:	ff 75 14             	pushl  0x14(%ebp)
  8009ad:	ff 75 10             	pushl  0x10(%ebp)
  8009b0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009b3:	50                   	push   %eax
  8009b4:	68 f3 03 80 00       	push   $0x8003f3
  8009b9:	e8 6f fa ff ff       	call   80042d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009c1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009c7:	83 c4 10             	add    $0x10,%esp
}
  8009ca:	c9                   	leave  
  8009cb:	c3                   	ret    
		return -E_INVAL;
  8009cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009d1:	eb f7                	jmp    8009ca <vsnprintf+0x45>

008009d3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009d3:	55                   	push   %ebp
  8009d4:	89 e5                	mov    %esp,%ebp
  8009d6:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009d9:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009dc:	50                   	push   %eax
  8009dd:	ff 75 10             	pushl  0x10(%ebp)
  8009e0:	ff 75 0c             	pushl  0xc(%ebp)
  8009e3:	ff 75 08             	pushl  0x8(%ebp)
  8009e6:	e8 9a ff ff ff       	call   800985 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009eb:	c9                   	leave  
  8009ec:	c3                   	ret    

008009ed <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009ed:	55                   	push   %ebp
  8009ee:	89 e5                	mov    %esp,%ebp
  8009f0:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f8:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009fc:	74 05                	je     800a03 <strlen+0x16>
		n++;
  8009fe:	83 c0 01             	add    $0x1,%eax
  800a01:	eb f5                	jmp    8009f8 <strlen+0xb>
	return n;
}
  800a03:	5d                   	pop    %ebp
  800a04:	c3                   	ret    

00800a05 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a05:	55                   	push   %ebp
  800a06:	89 e5                	mov    %esp,%ebp
  800a08:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a0b:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a0e:	ba 00 00 00 00       	mov    $0x0,%edx
  800a13:	39 c2                	cmp    %eax,%edx
  800a15:	74 0d                	je     800a24 <strnlen+0x1f>
  800a17:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a1b:	74 05                	je     800a22 <strnlen+0x1d>
		n++;
  800a1d:	83 c2 01             	add    $0x1,%edx
  800a20:	eb f1                	jmp    800a13 <strnlen+0xe>
  800a22:	89 d0                	mov    %edx,%eax
	return n;
}
  800a24:	5d                   	pop    %ebp
  800a25:	c3                   	ret    

00800a26 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
  800a29:	53                   	push   %ebx
  800a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a30:	ba 00 00 00 00       	mov    $0x0,%edx
  800a35:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a39:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a3c:	83 c2 01             	add    $0x1,%edx
  800a3f:	84 c9                	test   %cl,%cl
  800a41:	75 f2                	jne    800a35 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a43:	5b                   	pop    %ebx
  800a44:	5d                   	pop    %ebp
  800a45:	c3                   	ret    

00800a46 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a46:	55                   	push   %ebp
  800a47:	89 e5                	mov    %esp,%ebp
  800a49:	53                   	push   %ebx
  800a4a:	83 ec 10             	sub    $0x10,%esp
  800a4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a50:	53                   	push   %ebx
  800a51:	e8 97 ff ff ff       	call   8009ed <strlen>
  800a56:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a59:	ff 75 0c             	pushl  0xc(%ebp)
  800a5c:	01 d8                	add    %ebx,%eax
  800a5e:	50                   	push   %eax
  800a5f:	e8 c2 ff ff ff       	call   800a26 <strcpy>
	return dst;
}
  800a64:	89 d8                	mov    %ebx,%eax
  800a66:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a69:	c9                   	leave  
  800a6a:	c3                   	ret    

00800a6b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a6b:	55                   	push   %ebp
  800a6c:	89 e5                	mov    %esp,%ebp
  800a6e:	56                   	push   %esi
  800a6f:	53                   	push   %ebx
  800a70:	8b 45 08             	mov    0x8(%ebp),%eax
  800a73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a76:	89 c6                	mov    %eax,%esi
  800a78:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a7b:	89 c2                	mov    %eax,%edx
  800a7d:	39 f2                	cmp    %esi,%edx
  800a7f:	74 11                	je     800a92 <strncpy+0x27>
		*dst++ = *src;
  800a81:	83 c2 01             	add    $0x1,%edx
  800a84:	0f b6 19             	movzbl (%ecx),%ebx
  800a87:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a8a:	80 fb 01             	cmp    $0x1,%bl
  800a8d:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a90:	eb eb                	jmp    800a7d <strncpy+0x12>
	}
	return ret;
}
  800a92:	5b                   	pop    %ebx
  800a93:	5e                   	pop    %esi
  800a94:	5d                   	pop    %ebp
  800a95:	c3                   	ret    

00800a96 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a96:	55                   	push   %ebp
  800a97:	89 e5                	mov    %esp,%ebp
  800a99:	56                   	push   %esi
  800a9a:	53                   	push   %ebx
  800a9b:	8b 75 08             	mov    0x8(%ebp),%esi
  800a9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aa1:	8b 55 10             	mov    0x10(%ebp),%edx
  800aa4:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800aa6:	85 d2                	test   %edx,%edx
  800aa8:	74 21                	je     800acb <strlcpy+0x35>
  800aaa:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800aae:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800ab0:	39 c2                	cmp    %eax,%edx
  800ab2:	74 14                	je     800ac8 <strlcpy+0x32>
  800ab4:	0f b6 19             	movzbl (%ecx),%ebx
  800ab7:	84 db                	test   %bl,%bl
  800ab9:	74 0b                	je     800ac6 <strlcpy+0x30>
			*dst++ = *src++;
  800abb:	83 c1 01             	add    $0x1,%ecx
  800abe:	83 c2 01             	add    $0x1,%edx
  800ac1:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ac4:	eb ea                	jmp    800ab0 <strlcpy+0x1a>
  800ac6:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800ac8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800acb:	29 f0                	sub    %esi,%eax
}
  800acd:	5b                   	pop    %ebx
  800ace:	5e                   	pop    %esi
  800acf:	5d                   	pop    %ebp
  800ad0:	c3                   	ret    

00800ad1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ad1:	55                   	push   %ebp
  800ad2:	89 e5                	mov    %esp,%ebp
  800ad4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ad7:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ada:	0f b6 01             	movzbl (%ecx),%eax
  800add:	84 c0                	test   %al,%al
  800adf:	74 0c                	je     800aed <strcmp+0x1c>
  800ae1:	3a 02                	cmp    (%edx),%al
  800ae3:	75 08                	jne    800aed <strcmp+0x1c>
		p++, q++;
  800ae5:	83 c1 01             	add    $0x1,%ecx
  800ae8:	83 c2 01             	add    $0x1,%edx
  800aeb:	eb ed                	jmp    800ada <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800aed:	0f b6 c0             	movzbl %al,%eax
  800af0:	0f b6 12             	movzbl (%edx),%edx
  800af3:	29 d0                	sub    %edx,%eax
}
  800af5:	5d                   	pop    %ebp
  800af6:	c3                   	ret    

00800af7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800af7:	55                   	push   %ebp
  800af8:	89 e5                	mov    %esp,%ebp
  800afa:	53                   	push   %ebx
  800afb:	8b 45 08             	mov    0x8(%ebp),%eax
  800afe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b01:	89 c3                	mov    %eax,%ebx
  800b03:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b06:	eb 06                	jmp    800b0e <strncmp+0x17>
		n--, p++, q++;
  800b08:	83 c0 01             	add    $0x1,%eax
  800b0b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b0e:	39 d8                	cmp    %ebx,%eax
  800b10:	74 16                	je     800b28 <strncmp+0x31>
  800b12:	0f b6 08             	movzbl (%eax),%ecx
  800b15:	84 c9                	test   %cl,%cl
  800b17:	74 04                	je     800b1d <strncmp+0x26>
  800b19:	3a 0a                	cmp    (%edx),%cl
  800b1b:	74 eb                	je     800b08 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b1d:	0f b6 00             	movzbl (%eax),%eax
  800b20:	0f b6 12             	movzbl (%edx),%edx
  800b23:	29 d0                	sub    %edx,%eax
}
  800b25:	5b                   	pop    %ebx
  800b26:	5d                   	pop    %ebp
  800b27:	c3                   	ret    
		return 0;
  800b28:	b8 00 00 00 00       	mov    $0x0,%eax
  800b2d:	eb f6                	jmp    800b25 <strncmp+0x2e>

00800b2f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b2f:	55                   	push   %ebp
  800b30:	89 e5                	mov    %esp,%ebp
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b39:	0f b6 10             	movzbl (%eax),%edx
  800b3c:	84 d2                	test   %dl,%dl
  800b3e:	74 09                	je     800b49 <strchr+0x1a>
		if (*s == c)
  800b40:	38 ca                	cmp    %cl,%dl
  800b42:	74 0a                	je     800b4e <strchr+0x1f>
	for (; *s; s++)
  800b44:	83 c0 01             	add    $0x1,%eax
  800b47:	eb f0                	jmp    800b39 <strchr+0xa>
			return (char *) s;
	return 0;
  800b49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b4e:	5d                   	pop    %ebp
  800b4f:	c3                   	ret    

00800b50 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b50:	55                   	push   %ebp
  800b51:	89 e5                	mov    %esp,%ebp
  800b53:	8b 45 08             	mov    0x8(%ebp),%eax
  800b56:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b5a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b5d:	38 ca                	cmp    %cl,%dl
  800b5f:	74 09                	je     800b6a <strfind+0x1a>
  800b61:	84 d2                	test   %dl,%dl
  800b63:	74 05                	je     800b6a <strfind+0x1a>
	for (; *s; s++)
  800b65:	83 c0 01             	add    $0x1,%eax
  800b68:	eb f0                	jmp    800b5a <strfind+0xa>
			break;
	return (char *) s;
}
  800b6a:	5d                   	pop    %ebp
  800b6b:	c3                   	ret    

00800b6c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	57                   	push   %edi
  800b70:	56                   	push   %esi
  800b71:	53                   	push   %ebx
  800b72:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b75:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b78:	85 c9                	test   %ecx,%ecx
  800b7a:	74 31                	je     800bad <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b7c:	89 f8                	mov    %edi,%eax
  800b7e:	09 c8                	or     %ecx,%eax
  800b80:	a8 03                	test   $0x3,%al
  800b82:	75 23                	jne    800ba7 <memset+0x3b>
		c &= 0xFF;
  800b84:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b88:	89 d3                	mov    %edx,%ebx
  800b8a:	c1 e3 08             	shl    $0x8,%ebx
  800b8d:	89 d0                	mov    %edx,%eax
  800b8f:	c1 e0 18             	shl    $0x18,%eax
  800b92:	89 d6                	mov    %edx,%esi
  800b94:	c1 e6 10             	shl    $0x10,%esi
  800b97:	09 f0                	or     %esi,%eax
  800b99:	09 c2                	or     %eax,%edx
  800b9b:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b9d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ba0:	89 d0                	mov    %edx,%eax
  800ba2:	fc                   	cld    
  800ba3:	f3 ab                	rep stos %eax,%es:(%edi)
  800ba5:	eb 06                	jmp    800bad <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800baa:	fc                   	cld    
  800bab:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bad:	89 f8                	mov    %edi,%eax
  800baf:	5b                   	pop    %ebx
  800bb0:	5e                   	pop    %esi
  800bb1:	5f                   	pop    %edi
  800bb2:	5d                   	pop    %ebp
  800bb3:	c3                   	ret    

00800bb4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	57                   	push   %edi
  800bb8:	56                   	push   %esi
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bbf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bc2:	39 c6                	cmp    %eax,%esi
  800bc4:	73 32                	jae    800bf8 <memmove+0x44>
  800bc6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bc9:	39 c2                	cmp    %eax,%edx
  800bcb:	76 2b                	jbe    800bf8 <memmove+0x44>
		s += n;
		d += n;
  800bcd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bd0:	89 fe                	mov    %edi,%esi
  800bd2:	09 ce                	or     %ecx,%esi
  800bd4:	09 d6                	or     %edx,%esi
  800bd6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bdc:	75 0e                	jne    800bec <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bde:	83 ef 04             	sub    $0x4,%edi
  800be1:	8d 72 fc             	lea    -0x4(%edx),%esi
  800be4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800be7:	fd                   	std    
  800be8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bea:	eb 09                	jmp    800bf5 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bec:	83 ef 01             	sub    $0x1,%edi
  800bef:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bf2:	fd                   	std    
  800bf3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bf5:	fc                   	cld    
  800bf6:	eb 1a                	jmp    800c12 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bf8:	89 c2                	mov    %eax,%edx
  800bfa:	09 ca                	or     %ecx,%edx
  800bfc:	09 f2                	or     %esi,%edx
  800bfe:	f6 c2 03             	test   $0x3,%dl
  800c01:	75 0a                	jne    800c0d <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c03:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c06:	89 c7                	mov    %eax,%edi
  800c08:	fc                   	cld    
  800c09:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c0b:	eb 05                	jmp    800c12 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c0d:	89 c7                	mov    %eax,%edi
  800c0f:	fc                   	cld    
  800c10:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c12:	5e                   	pop    %esi
  800c13:	5f                   	pop    %edi
  800c14:	5d                   	pop    %ebp
  800c15:	c3                   	ret    

00800c16 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c1c:	ff 75 10             	pushl  0x10(%ebp)
  800c1f:	ff 75 0c             	pushl  0xc(%ebp)
  800c22:	ff 75 08             	pushl  0x8(%ebp)
  800c25:	e8 8a ff ff ff       	call   800bb4 <memmove>
}
  800c2a:	c9                   	leave  
  800c2b:	c3                   	ret    

00800c2c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
  800c2f:	56                   	push   %esi
  800c30:	53                   	push   %ebx
  800c31:	8b 45 08             	mov    0x8(%ebp),%eax
  800c34:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c37:	89 c6                	mov    %eax,%esi
  800c39:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c3c:	39 f0                	cmp    %esi,%eax
  800c3e:	74 1c                	je     800c5c <memcmp+0x30>
		if (*s1 != *s2)
  800c40:	0f b6 08             	movzbl (%eax),%ecx
  800c43:	0f b6 1a             	movzbl (%edx),%ebx
  800c46:	38 d9                	cmp    %bl,%cl
  800c48:	75 08                	jne    800c52 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c4a:	83 c0 01             	add    $0x1,%eax
  800c4d:	83 c2 01             	add    $0x1,%edx
  800c50:	eb ea                	jmp    800c3c <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c52:	0f b6 c1             	movzbl %cl,%eax
  800c55:	0f b6 db             	movzbl %bl,%ebx
  800c58:	29 d8                	sub    %ebx,%eax
  800c5a:	eb 05                	jmp    800c61 <memcmp+0x35>
	}

	return 0;
  800c5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c61:	5b                   	pop    %ebx
  800c62:	5e                   	pop    %esi
  800c63:	5d                   	pop    %ebp
  800c64:	c3                   	ret    

00800c65 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c6e:	89 c2                	mov    %eax,%edx
  800c70:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c73:	39 d0                	cmp    %edx,%eax
  800c75:	73 09                	jae    800c80 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c77:	38 08                	cmp    %cl,(%eax)
  800c79:	74 05                	je     800c80 <memfind+0x1b>
	for (; s < ends; s++)
  800c7b:	83 c0 01             	add    $0x1,%eax
  800c7e:	eb f3                	jmp    800c73 <memfind+0xe>
			break;
	return (void *) s;
}
  800c80:	5d                   	pop    %ebp
  800c81:	c3                   	ret    

00800c82 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c82:	55                   	push   %ebp
  800c83:	89 e5                	mov    %esp,%ebp
  800c85:	57                   	push   %edi
  800c86:	56                   	push   %esi
  800c87:	53                   	push   %ebx
  800c88:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c8b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c8e:	eb 03                	jmp    800c93 <strtol+0x11>
		s++;
  800c90:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c93:	0f b6 01             	movzbl (%ecx),%eax
  800c96:	3c 20                	cmp    $0x20,%al
  800c98:	74 f6                	je     800c90 <strtol+0xe>
  800c9a:	3c 09                	cmp    $0x9,%al
  800c9c:	74 f2                	je     800c90 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c9e:	3c 2b                	cmp    $0x2b,%al
  800ca0:	74 2a                	je     800ccc <strtol+0x4a>
	int neg = 0;
  800ca2:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ca7:	3c 2d                	cmp    $0x2d,%al
  800ca9:	74 2b                	je     800cd6 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cab:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cb1:	75 0f                	jne    800cc2 <strtol+0x40>
  800cb3:	80 39 30             	cmpb   $0x30,(%ecx)
  800cb6:	74 28                	je     800ce0 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cb8:	85 db                	test   %ebx,%ebx
  800cba:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cbf:	0f 44 d8             	cmove  %eax,%ebx
  800cc2:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc7:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cca:	eb 50                	jmp    800d1c <strtol+0x9a>
		s++;
  800ccc:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ccf:	bf 00 00 00 00       	mov    $0x0,%edi
  800cd4:	eb d5                	jmp    800cab <strtol+0x29>
		s++, neg = 1;
  800cd6:	83 c1 01             	add    $0x1,%ecx
  800cd9:	bf 01 00 00 00       	mov    $0x1,%edi
  800cde:	eb cb                	jmp    800cab <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ce0:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ce4:	74 0e                	je     800cf4 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ce6:	85 db                	test   %ebx,%ebx
  800ce8:	75 d8                	jne    800cc2 <strtol+0x40>
		s++, base = 8;
  800cea:	83 c1 01             	add    $0x1,%ecx
  800ced:	bb 08 00 00 00       	mov    $0x8,%ebx
  800cf2:	eb ce                	jmp    800cc2 <strtol+0x40>
		s += 2, base = 16;
  800cf4:	83 c1 02             	add    $0x2,%ecx
  800cf7:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cfc:	eb c4                	jmp    800cc2 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800cfe:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d01:	89 f3                	mov    %esi,%ebx
  800d03:	80 fb 19             	cmp    $0x19,%bl
  800d06:	77 29                	ja     800d31 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d08:	0f be d2             	movsbl %dl,%edx
  800d0b:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d0e:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d11:	7d 30                	jge    800d43 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d13:	83 c1 01             	add    $0x1,%ecx
  800d16:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d1a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d1c:	0f b6 11             	movzbl (%ecx),%edx
  800d1f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d22:	89 f3                	mov    %esi,%ebx
  800d24:	80 fb 09             	cmp    $0x9,%bl
  800d27:	77 d5                	ja     800cfe <strtol+0x7c>
			dig = *s - '0';
  800d29:	0f be d2             	movsbl %dl,%edx
  800d2c:	83 ea 30             	sub    $0x30,%edx
  800d2f:	eb dd                	jmp    800d0e <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d31:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d34:	89 f3                	mov    %esi,%ebx
  800d36:	80 fb 19             	cmp    $0x19,%bl
  800d39:	77 08                	ja     800d43 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d3b:	0f be d2             	movsbl %dl,%edx
  800d3e:	83 ea 37             	sub    $0x37,%edx
  800d41:	eb cb                	jmp    800d0e <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d43:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d47:	74 05                	je     800d4e <strtol+0xcc>
		*endptr = (char *) s;
  800d49:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d4c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d4e:	89 c2                	mov    %eax,%edx
  800d50:	f7 da                	neg    %edx
  800d52:	85 ff                	test   %edi,%edi
  800d54:	0f 45 c2             	cmovne %edx,%eax
}
  800d57:	5b                   	pop    %ebx
  800d58:	5e                   	pop    %esi
  800d59:	5f                   	pop    %edi
  800d5a:	5d                   	pop    %ebp
  800d5b:	c3                   	ret    

00800d5c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d5c:	55                   	push   %ebp
  800d5d:	89 e5                	mov    %esp,%ebp
  800d5f:	57                   	push   %edi
  800d60:	56                   	push   %esi
  800d61:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d62:	b8 00 00 00 00       	mov    $0x0,%eax
  800d67:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6d:	89 c3                	mov    %eax,%ebx
  800d6f:	89 c7                	mov    %eax,%edi
  800d71:	89 c6                	mov    %eax,%esi
  800d73:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d75:	5b                   	pop    %ebx
  800d76:	5e                   	pop    %esi
  800d77:	5f                   	pop    %edi
  800d78:	5d                   	pop    %ebp
  800d79:	c3                   	ret    

00800d7a <sys_cgetc>:

int
sys_cgetc(void)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	57                   	push   %edi
  800d7e:	56                   	push   %esi
  800d7f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d80:	ba 00 00 00 00       	mov    $0x0,%edx
  800d85:	b8 01 00 00 00       	mov    $0x1,%eax
  800d8a:	89 d1                	mov    %edx,%ecx
  800d8c:	89 d3                	mov    %edx,%ebx
  800d8e:	89 d7                	mov    %edx,%edi
  800d90:	89 d6                	mov    %edx,%esi
  800d92:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d94:	5b                   	pop    %ebx
  800d95:	5e                   	pop    %esi
  800d96:	5f                   	pop    %edi
  800d97:	5d                   	pop    %ebp
  800d98:	c3                   	ret    

00800d99 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d99:	55                   	push   %ebp
  800d9a:	89 e5                	mov    %esp,%ebp
  800d9c:	57                   	push   %edi
  800d9d:	56                   	push   %esi
  800d9e:	53                   	push   %ebx
  800d9f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800da7:	8b 55 08             	mov    0x8(%ebp),%edx
  800daa:	b8 03 00 00 00       	mov    $0x3,%eax
  800daf:	89 cb                	mov    %ecx,%ebx
  800db1:	89 cf                	mov    %ecx,%edi
  800db3:	89 ce                	mov    %ecx,%esi
  800db5:	cd 30                	int    $0x30
	if (check && ret > 0)
  800db7:	85 c0                	test   %eax,%eax
  800db9:	7f 08                	jg     800dc3 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800dbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dbe:	5b                   	pop    %ebx
  800dbf:	5e                   	pop    %esi
  800dc0:	5f                   	pop    %edi
  800dc1:	5d                   	pop    %ebp
  800dc2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc3:	83 ec 0c             	sub    $0xc,%esp
  800dc6:	50                   	push   %eax
  800dc7:	6a 03                	push   $0x3
  800dc9:	68 40 2a 80 00       	push   $0x802a40
  800dce:	6a 4c                	push   $0x4c
  800dd0:	68 5d 2a 80 00       	push   $0x802a5d
  800dd5:	e8 4b f4 ff ff       	call   800225 <_panic>

00800dda <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800dda:	55                   	push   %ebp
  800ddb:	89 e5                	mov    %esp,%ebp
  800ddd:	57                   	push   %edi
  800dde:	56                   	push   %esi
  800ddf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800de0:	ba 00 00 00 00       	mov    $0x0,%edx
  800de5:	b8 02 00 00 00       	mov    $0x2,%eax
  800dea:	89 d1                	mov    %edx,%ecx
  800dec:	89 d3                	mov    %edx,%ebx
  800dee:	89 d7                	mov    %edx,%edi
  800df0:	89 d6                	mov    %edx,%esi
  800df2:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800df4:	5b                   	pop    %ebx
  800df5:	5e                   	pop    %esi
  800df6:	5f                   	pop    %edi
  800df7:	5d                   	pop    %ebp
  800df8:	c3                   	ret    

00800df9 <sys_yield>:

void
sys_yield(void)
{
  800df9:	55                   	push   %ebp
  800dfa:	89 e5                	mov    %esp,%ebp
  800dfc:	57                   	push   %edi
  800dfd:	56                   	push   %esi
  800dfe:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dff:	ba 00 00 00 00       	mov    $0x0,%edx
  800e04:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e09:	89 d1                	mov    %edx,%ecx
  800e0b:	89 d3                	mov    %edx,%ebx
  800e0d:	89 d7                	mov    %edx,%edi
  800e0f:	89 d6                	mov    %edx,%esi
  800e11:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e13:	5b                   	pop    %ebx
  800e14:	5e                   	pop    %esi
  800e15:	5f                   	pop    %edi
  800e16:	5d                   	pop    %ebp
  800e17:	c3                   	ret    

00800e18 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e18:	55                   	push   %ebp
  800e19:	89 e5                	mov    %esp,%ebp
  800e1b:	57                   	push   %edi
  800e1c:	56                   	push   %esi
  800e1d:	53                   	push   %ebx
  800e1e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e21:	be 00 00 00 00       	mov    $0x0,%esi
  800e26:	8b 55 08             	mov    0x8(%ebp),%edx
  800e29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2c:	b8 04 00 00 00       	mov    $0x4,%eax
  800e31:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e34:	89 f7                	mov    %esi,%edi
  800e36:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e38:	85 c0                	test   %eax,%eax
  800e3a:	7f 08                	jg     800e44 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e3f:	5b                   	pop    %ebx
  800e40:	5e                   	pop    %esi
  800e41:	5f                   	pop    %edi
  800e42:	5d                   	pop    %ebp
  800e43:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e44:	83 ec 0c             	sub    $0xc,%esp
  800e47:	50                   	push   %eax
  800e48:	6a 04                	push   $0x4
  800e4a:	68 40 2a 80 00       	push   $0x802a40
  800e4f:	6a 4c                	push   $0x4c
  800e51:	68 5d 2a 80 00       	push   $0x802a5d
  800e56:	e8 ca f3 ff ff       	call   800225 <_panic>

00800e5b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	57                   	push   %edi
  800e5f:	56                   	push   %esi
  800e60:	53                   	push   %ebx
  800e61:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e64:	8b 55 08             	mov    0x8(%ebp),%edx
  800e67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6a:	b8 05 00 00 00       	mov    $0x5,%eax
  800e6f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e72:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e75:	8b 75 18             	mov    0x18(%ebp),%esi
  800e78:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e7a:	85 c0                	test   %eax,%eax
  800e7c:	7f 08                	jg     800e86 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e81:	5b                   	pop    %ebx
  800e82:	5e                   	pop    %esi
  800e83:	5f                   	pop    %edi
  800e84:	5d                   	pop    %ebp
  800e85:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e86:	83 ec 0c             	sub    $0xc,%esp
  800e89:	50                   	push   %eax
  800e8a:	6a 05                	push   $0x5
  800e8c:	68 40 2a 80 00       	push   $0x802a40
  800e91:	6a 4c                	push   $0x4c
  800e93:	68 5d 2a 80 00       	push   $0x802a5d
  800e98:	e8 88 f3 ff ff       	call   800225 <_panic>

00800e9d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e9d:	55                   	push   %ebp
  800e9e:	89 e5                	mov    %esp,%ebp
  800ea0:	57                   	push   %edi
  800ea1:	56                   	push   %esi
  800ea2:	53                   	push   %ebx
  800ea3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eab:	8b 55 08             	mov    0x8(%ebp),%edx
  800eae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb1:	b8 06 00 00 00       	mov    $0x6,%eax
  800eb6:	89 df                	mov    %ebx,%edi
  800eb8:	89 de                	mov    %ebx,%esi
  800eba:	cd 30                	int    $0x30
	if (check && ret > 0)
  800ebc:	85 c0                	test   %eax,%eax
  800ebe:	7f 08                	jg     800ec8 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ec0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec3:	5b                   	pop    %ebx
  800ec4:	5e                   	pop    %esi
  800ec5:	5f                   	pop    %edi
  800ec6:	5d                   	pop    %ebp
  800ec7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec8:	83 ec 0c             	sub    $0xc,%esp
  800ecb:	50                   	push   %eax
  800ecc:	6a 06                	push   $0x6
  800ece:	68 40 2a 80 00       	push   $0x802a40
  800ed3:	6a 4c                	push   $0x4c
  800ed5:	68 5d 2a 80 00       	push   $0x802a5d
  800eda:	e8 46 f3 ff ff       	call   800225 <_panic>

00800edf <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800edf:	55                   	push   %ebp
  800ee0:	89 e5                	mov    %esp,%ebp
  800ee2:	57                   	push   %edi
  800ee3:	56                   	push   %esi
  800ee4:	53                   	push   %ebx
  800ee5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eed:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef3:	b8 08 00 00 00       	mov    $0x8,%eax
  800ef8:	89 df                	mov    %ebx,%edi
  800efa:	89 de                	mov    %ebx,%esi
  800efc:	cd 30                	int    $0x30
	if (check && ret > 0)
  800efe:	85 c0                	test   %eax,%eax
  800f00:	7f 08                	jg     800f0a <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f02:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f05:	5b                   	pop    %ebx
  800f06:	5e                   	pop    %esi
  800f07:	5f                   	pop    %edi
  800f08:	5d                   	pop    %ebp
  800f09:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f0a:	83 ec 0c             	sub    $0xc,%esp
  800f0d:	50                   	push   %eax
  800f0e:	6a 08                	push   $0x8
  800f10:	68 40 2a 80 00       	push   $0x802a40
  800f15:	6a 4c                	push   $0x4c
  800f17:	68 5d 2a 80 00       	push   $0x802a5d
  800f1c:	e8 04 f3 ff ff       	call   800225 <_panic>

00800f21 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f21:	55                   	push   %ebp
  800f22:	89 e5                	mov    %esp,%ebp
  800f24:	57                   	push   %edi
  800f25:	56                   	push   %esi
  800f26:	53                   	push   %ebx
  800f27:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f2a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f2f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f35:	b8 09 00 00 00       	mov    $0x9,%eax
  800f3a:	89 df                	mov    %ebx,%edi
  800f3c:	89 de                	mov    %ebx,%esi
  800f3e:	cd 30                	int    $0x30
	if (check && ret > 0)
  800f40:	85 c0                	test   %eax,%eax
  800f42:	7f 08                	jg     800f4c <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f44:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f47:	5b                   	pop    %ebx
  800f48:	5e                   	pop    %esi
  800f49:	5f                   	pop    %edi
  800f4a:	5d                   	pop    %ebp
  800f4b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f4c:	83 ec 0c             	sub    $0xc,%esp
  800f4f:	50                   	push   %eax
  800f50:	6a 09                	push   $0x9
  800f52:	68 40 2a 80 00       	push   $0x802a40
  800f57:	6a 4c                	push   $0x4c
  800f59:	68 5d 2a 80 00       	push   $0x802a5d
  800f5e:	e8 c2 f2 ff ff       	call   800225 <_panic>

00800f63 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f63:	55                   	push   %ebp
  800f64:	89 e5                	mov    %esp,%ebp
  800f66:	57                   	push   %edi
  800f67:	56                   	push   %esi
  800f68:	53                   	push   %ebx
  800f69:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f6c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f71:	8b 55 08             	mov    0x8(%ebp),%edx
  800f74:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f77:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f7c:	89 df                	mov    %ebx,%edi
  800f7e:	89 de                	mov    %ebx,%esi
  800f80:	cd 30                	int    $0x30
	if (check && ret > 0)
  800f82:	85 c0                	test   %eax,%eax
  800f84:	7f 08                	jg     800f8e <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f86:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f89:	5b                   	pop    %ebx
  800f8a:	5e                   	pop    %esi
  800f8b:	5f                   	pop    %edi
  800f8c:	5d                   	pop    %ebp
  800f8d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8e:	83 ec 0c             	sub    $0xc,%esp
  800f91:	50                   	push   %eax
  800f92:	6a 0a                	push   $0xa
  800f94:	68 40 2a 80 00       	push   $0x802a40
  800f99:	6a 4c                	push   $0x4c
  800f9b:	68 5d 2a 80 00       	push   $0x802a5d
  800fa0:	e8 80 f2 ff ff       	call   800225 <_panic>

00800fa5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fa5:	55                   	push   %ebp
  800fa6:	89 e5                	mov    %esp,%ebp
  800fa8:	57                   	push   %edi
  800fa9:	56                   	push   %esi
  800faa:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fab:	8b 55 08             	mov    0x8(%ebp),%edx
  800fae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fb6:	be 00 00 00 00       	mov    $0x0,%esi
  800fbb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fbe:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fc1:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fc3:	5b                   	pop    %ebx
  800fc4:	5e                   	pop    %esi
  800fc5:	5f                   	pop    %edi
  800fc6:	5d                   	pop    %ebp
  800fc7:	c3                   	ret    

00800fc8 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fc8:	55                   	push   %ebp
  800fc9:	89 e5                	mov    %esp,%ebp
  800fcb:	57                   	push   %edi
  800fcc:	56                   	push   %esi
  800fcd:	53                   	push   %ebx
  800fce:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fd1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd9:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fde:	89 cb                	mov    %ecx,%ebx
  800fe0:	89 cf                	mov    %ecx,%edi
  800fe2:	89 ce                	mov    %ecx,%esi
  800fe4:	cd 30                	int    $0x30
	if (check && ret > 0)
  800fe6:	85 c0                	test   %eax,%eax
  800fe8:	7f 08                	jg     800ff2 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fed:	5b                   	pop    %ebx
  800fee:	5e                   	pop    %esi
  800fef:	5f                   	pop    %edi
  800ff0:	5d                   	pop    %ebp
  800ff1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff2:	83 ec 0c             	sub    $0xc,%esp
  800ff5:	50                   	push   %eax
  800ff6:	6a 0d                	push   $0xd
  800ff8:	68 40 2a 80 00       	push   $0x802a40
  800ffd:	6a 4c                	push   $0x4c
  800fff:	68 5d 2a 80 00       	push   $0x802a5d
  801004:	e8 1c f2 ff ff       	call   800225 <_panic>

00801009 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801009:	55                   	push   %ebp
  80100a:	89 e5                	mov    %esp,%ebp
  80100c:	57                   	push   %edi
  80100d:	56                   	push   %esi
  80100e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80100f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801014:	8b 55 08             	mov    0x8(%ebp),%edx
  801017:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80101a:	b8 0e 00 00 00       	mov    $0xe,%eax
  80101f:	89 df                	mov    %ebx,%edi
  801021:	89 de                	mov    %ebx,%esi
  801023:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801025:	5b                   	pop    %ebx
  801026:	5e                   	pop    %esi
  801027:	5f                   	pop    %edi
  801028:	5d                   	pop    %ebp
  801029:	c3                   	ret    

0080102a <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	57                   	push   %edi
  80102e:	56                   	push   %esi
  80102f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801030:	b9 00 00 00 00       	mov    $0x0,%ecx
  801035:	8b 55 08             	mov    0x8(%ebp),%edx
  801038:	b8 0f 00 00 00       	mov    $0xf,%eax
  80103d:	89 cb                	mov    %ecx,%ebx
  80103f:	89 cf                	mov    %ecx,%edi
  801041:	89 ce                	mov    %ecx,%esi
  801043:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801045:	5b                   	pop    %ebx
  801046:	5e                   	pop    %esi
  801047:	5f                   	pop    %edi
  801048:	5d                   	pop    %ebp
  801049:	c3                   	ret    

0080104a <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80104a:	55                   	push   %ebp
  80104b:	89 e5                	mov    %esp,%ebp
  80104d:	53                   	push   %ebx
  80104e:	83 ec 04             	sub    $0x4,%esp
  801051:	8b 55 08             	mov    0x8(%ebp),%edx
	// cprintf("pgfault()\n");
	void *addr = (void *) utf->utf_fault_va;
  801054:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpd[PDX(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_COW))
  801056:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  80105a:	0f 84 9c 00 00 00    	je     8010fc <pgfault+0xb2>
  801060:	89 c2                	mov    %eax,%edx
  801062:	c1 ea 16             	shr    $0x16,%edx
  801065:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80106c:	f6 c2 01             	test   $0x1,%dl
  80106f:	0f 84 87 00 00 00    	je     8010fc <pgfault+0xb2>
  801075:	89 c2                	mov    %eax,%edx
  801077:	c1 ea 0c             	shr    $0xc,%edx
  80107a:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801081:	f6 c1 01             	test   $0x1,%cl
  801084:	74 76                	je     8010fc <pgfault+0xb2>
  801086:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80108d:	f6 c6 08             	test   $0x8,%dh
  801090:	74 6a                	je     8010fc <pgfault+0xb2>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  801092:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801097:	89 c3                	mov    %eax,%ebx

	r = sys_page_alloc(0, PFTEMP, PTE_P|PTE_U|PTE_W);
  801099:	83 ec 04             	sub    $0x4,%esp
  80109c:	6a 07                	push   $0x7
  80109e:	68 00 f0 7f 00       	push   $0x7ff000
  8010a3:	6a 00                	push   $0x0
  8010a5:	e8 6e fd ff ff       	call   800e18 <sys_page_alloc>
	if(r < 0){
  8010aa:	83 c4 10             	add    $0x10,%esp
  8010ad:	85 c0                	test   %eax,%eax
  8010af:	78 5f                	js     801110 <pgfault+0xc6>
		panic("pgfault: sys_page_alloc fail, r: %d", r);
	}

	memmove(PFTEMP, addr, PGSIZE);
  8010b1:	83 ec 04             	sub    $0x4,%esp
  8010b4:	68 00 10 00 00       	push   $0x1000
  8010b9:	53                   	push   %ebx
  8010ba:	68 00 f0 7f 00       	push   $0x7ff000
  8010bf:	e8 f0 fa ff ff       	call   800bb4 <memmove>

	r = sys_page_map(0, PFTEMP, 0, addr, PTE_P|PTE_U|PTE_W);
  8010c4:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8010cb:	53                   	push   %ebx
  8010cc:	6a 00                	push   $0x0
  8010ce:	68 00 f0 7f 00       	push   $0x7ff000
  8010d3:	6a 00                	push   $0x0
  8010d5:	e8 81 fd ff ff       	call   800e5b <sys_page_map>
	if(r < 0){
  8010da:	83 c4 20             	add    $0x20,%esp
  8010dd:	85 c0                	test   %eax,%eax
  8010df:	78 41                	js     801122 <pgfault+0xd8>
		panic("pgfault: sys_page_map fail, r: %d", r);
	}

	r = sys_page_unmap(0, PFTEMP);
  8010e1:	83 ec 08             	sub    $0x8,%esp
  8010e4:	68 00 f0 7f 00       	push   $0x7ff000
  8010e9:	6a 00                	push   $0x0
  8010eb:	e8 ad fd ff ff       	call   800e9d <sys_page_unmap>
	if(r < 0){
  8010f0:	83 c4 10             	add    $0x10,%esp
  8010f3:	85 c0                	test   %eax,%eax
  8010f5:	78 3d                	js     801134 <pgfault+0xea>
		panic("sys_page_unmap: %e", r);
	}
}
  8010f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010fa:	c9                   	leave  
  8010fb:	c3                   	ret    
		panic("pgfault: 1\n");
  8010fc:	83 ec 04             	sub    $0x4,%esp
  8010ff:	68 6b 2a 80 00       	push   $0x802a6b
  801104:	6a 20                	push   $0x20
  801106:	68 77 2a 80 00       	push   $0x802a77
  80110b:	e8 15 f1 ff ff       	call   800225 <_panic>
		panic("pgfault: sys_page_alloc fail, r: %d", r);
  801110:	50                   	push   %eax
  801111:	68 cc 2a 80 00       	push   $0x802acc
  801116:	6a 2e                	push   $0x2e
  801118:	68 77 2a 80 00       	push   $0x802a77
  80111d:	e8 03 f1 ff ff       	call   800225 <_panic>
		panic("pgfault: sys_page_map fail, r: %d", r);
  801122:	50                   	push   %eax
  801123:	68 f0 2a 80 00       	push   $0x802af0
  801128:	6a 35                	push   $0x35
  80112a:	68 77 2a 80 00       	push   $0x802a77
  80112f:	e8 f1 f0 ff ff       	call   800225 <_panic>
		panic("sys_page_unmap: %e", r);
  801134:	50                   	push   %eax
  801135:	68 82 2a 80 00       	push   $0x802a82
  80113a:	6a 3a                	push   $0x3a
  80113c:	68 77 2a 80 00       	push   $0x802a77
  801141:	e8 df f0 ff ff       	call   800225 <_panic>

00801146 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801146:	55                   	push   %ebp
  801147:	89 e5                	mov    %esp,%ebp
  801149:	57                   	push   %edi
  80114a:	56                   	push   %esi
  80114b:	53                   	push   %ebx
  80114c:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	// panic("fork not implemented");
	int r;
	set_pgfault_handler(pgfault);
  80114f:	68 4a 10 80 00       	push   $0x80104a
  801154:	e8 e2 0f 00 00       	call   80213b <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801159:	b8 07 00 00 00       	mov    $0x7,%eax
  80115e:	cd 30                	int    $0x30
  801160:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int i;
	uintptr_t va;
	envid_t childid = sys_exofork();
	if (childid < 0){
  801163:	83 c4 10             	add    $0x10,%esp
  801166:	85 c0                	test   %eax,%eax
  801168:	78 2c                	js     801196 <fork+0x50>
  80116a:	89 c7                	mov    %eax,%edi
	}

	extern volatile pde_t uvpd[];
	extern volatile pte_t uvpt[];

	for (va = UTEXT; va < USTACKTOP; va += PGSIZE){
  80116c:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (childid == 0) {
  801171:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801175:	75 72                	jne    8011e9 <fork+0xa3>
		thisenv = &envs[ENVX(sys_getenvid())];
  801177:	e8 5e fc ff ff       	call   800dda <sys_getenvid>
  80117c:	25 ff 03 00 00       	and    $0x3ff,%eax
  801181:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801187:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80118c:	a3 20 44 80 00       	mov    %eax,0x804420
		return 0;
  801191:	e9 36 01 00 00       	jmp    8012cc <fork+0x186>
		panic("fork: child id < 0: %d", childid);
  801196:	50                   	push   %eax
  801197:	68 95 2a 80 00       	push   $0x802a95
  80119c:	68 83 00 00 00       	push   $0x83
  8011a1:	68 77 2a 80 00       	push   $0x802a77
  8011a6:	e8 7a f0 ff ff       	call   800225 <_panic>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  8011ab:	50                   	push   %eax
  8011ac:	68 14 2b 80 00       	push   $0x802b14
  8011b1:	6a 56                	push   $0x56
  8011b3:	68 77 2a 80 00       	push   $0x802a77
  8011b8:	e8 68 f0 ff ff       	call   800225 <_panic>
		r = sys_page_map((envid_t)0, va, envid, va, PTE_U | PTE_P);
  8011bd:	83 ec 0c             	sub    $0xc,%esp
  8011c0:	6a 05                	push   $0x5
  8011c2:	56                   	push   %esi
  8011c3:	57                   	push   %edi
  8011c4:	56                   	push   %esi
  8011c5:	6a 00                	push   $0x0
  8011c7:	e8 8f fc ff ff       	call   800e5b <sys_page_map>
		if(r < 0){
  8011cc:	83 c4 20             	add    $0x20,%esp
  8011cf:	85 c0                	test   %eax,%eax
  8011d1:	0f 88 9f 00 00 00    	js     801276 <fork+0x130>
	for (va = UTEXT; va < USTACKTOP; va += PGSIZE){
  8011d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8011dd:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8011e3:	0f 84 9f 00 00 00    	je     801288 <fork+0x142>
		if ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_U)){
  8011e9:	89 d8                	mov    %ebx,%eax
  8011eb:	c1 e8 16             	shr    $0x16,%eax
  8011ee:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011f5:	a8 01                	test   $0x1,%al
  8011f7:	74 de                	je     8011d7 <fork+0x91>
  8011f9:	89 d8                	mov    %ebx,%eax
  8011fb:	c1 e8 0c             	shr    $0xc,%eax
  8011fe:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801205:	f6 c2 01             	test   $0x1,%dl
  801208:	74 cd                	je     8011d7 <fork+0x91>
  80120a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801211:	f6 c2 04             	test   $0x4,%dl
  801214:	74 c1                	je     8011d7 <fork+0x91>
	void * va = (void *)(pn * PGSIZE);
  801216:	89 c6                	mov    %eax,%esi
  801218:	c1 e6 0c             	shl    $0xc,%esi
	int perm = (uvpt[pn]);
  80121b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (perm & (PTE_W | PTE_COW)) {
  801222:	a9 02 08 00 00       	test   $0x802,%eax
  801227:	74 94                	je     8011bd <fork+0x77>
		r = sys_page_map((envid_t)0, va, envid, va, PTE_U | PTE_P | PTE_COW);
  801229:	83 ec 0c             	sub    $0xc,%esp
  80122c:	68 05 08 00 00       	push   $0x805
  801231:	56                   	push   %esi
  801232:	57                   	push   %edi
  801233:	56                   	push   %esi
  801234:	6a 00                	push   $0x0
  801236:	e8 20 fc ff ff       	call   800e5b <sys_page_map>
		if(r < 0){
  80123b:	83 c4 20             	add    $0x20,%esp
  80123e:	85 c0                	test   %eax,%eax
  801240:	0f 88 65 ff ff ff    	js     8011ab <fork+0x65>
		r = sys_page_map((envid_t)0, va, (envid_t)0, va, PTE_U | PTE_P | PTE_COW);
  801246:	83 ec 0c             	sub    $0xc,%esp
  801249:	68 05 08 00 00       	push   $0x805
  80124e:	56                   	push   %esi
  80124f:	6a 00                	push   $0x0
  801251:	56                   	push   %esi
  801252:	6a 00                	push   $0x0
  801254:	e8 02 fc ff ff       	call   800e5b <sys_page_map>
		if(r < 0){
  801259:	83 c4 20             	add    $0x20,%esp
  80125c:	85 c0                	test   %eax,%eax
  80125e:	0f 89 73 ff ff ff    	jns    8011d7 <fork+0x91>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  801264:	50                   	push   %eax
  801265:	68 14 2b 80 00       	push   $0x802b14
  80126a:	6a 5b                	push   $0x5b
  80126c:	68 77 2a 80 00       	push   $0x802a77
  801271:	e8 af ef ff ff       	call   800225 <_panic>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  801276:	50                   	push   %eax
  801277:	68 14 2b 80 00       	push   $0x802b14
  80127c:	6a 61                	push   $0x61
  80127e:	68 77 2a 80 00       	push   $0x802a77
  801283:	e8 9d ef ff ff       	call   800225 <_panic>
			duppage(childid, PGNUM(va));
		}
	}

	r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801288:	83 ec 04             	sub    $0x4,%esp
  80128b:	6a 07                	push   $0x7
  80128d:	68 00 f0 bf ee       	push   $0xeebff000
  801292:	ff 75 e4             	pushl  -0x1c(%ebp)
  801295:	e8 7e fb ff ff       	call   800e18 <sys_page_alloc>
	if (r < 0){
  80129a:	83 c4 10             	add    $0x10,%esp
  80129d:	85 c0                	test   %eax,%eax
  80129f:	78 36                	js     8012d7 <fork+0x191>
		panic("fork: allocate user exception stack for child env error, %d", r);
	}
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  8012a1:	83 ec 08             	sub    $0x8,%esp
  8012a4:	68 a6 21 80 00       	push   $0x8021a6
  8012a9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012ac:	e8 b2 fc ff ff       	call   800f63 <sys_env_set_pgfault_upcall>
	if (r < 0){
  8012b1:	83 c4 10             	add    $0x10,%esp
  8012b4:	85 c0                	test   %eax,%eax
  8012b6:	78 34                	js     8012ec <fork+0x1a6>
		panic("fork: sys_env_set_pgfault_upcall error, %d", r);
	}
	r = sys_env_set_status(childid, ENV_RUNNABLE);
  8012b8:	83 ec 08             	sub    $0x8,%esp
  8012bb:	6a 02                	push   $0x2
  8012bd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012c0:	e8 1a fc ff ff       	call   800edf <sys_env_set_status>
	if(r < 0){
  8012c5:	83 c4 10             	add    $0x10,%esp
  8012c8:	85 c0                	test   %eax,%eax
  8012ca:	78 35                	js     801301 <fork+0x1bb>
		panic("forK: sys_env_set_status, r%d", r);
	}
	return childid;
}
  8012cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012d2:	5b                   	pop    %ebx
  8012d3:	5e                   	pop    %esi
  8012d4:	5f                   	pop    %edi
  8012d5:	5d                   	pop    %ebp
  8012d6:	c3                   	ret    
		panic("fork: allocate user exception stack for child env error, %d", r);
  8012d7:	50                   	push   %eax
  8012d8:	68 3c 2b 80 00       	push   $0x802b3c
  8012dd:	68 96 00 00 00       	push   $0x96
  8012e2:	68 77 2a 80 00       	push   $0x802a77
  8012e7:	e8 39 ef ff ff       	call   800225 <_panic>
		panic("fork: sys_env_set_pgfault_upcall error, %d", r);
  8012ec:	50                   	push   %eax
  8012ed:	68 78 2b 80 00       	push   $0x802b78
  8012f2:	68 9a 00 00 00       	push   $0x9a
  8012f7:	68 77 2a 80 00       	push   $0x802a77
  8012fc:	e8 24 ef ff ff       	call   800225 <_panic>
		panic("forK: sys_env_set_status, r%d", r);
  801301:	50                   	push   %eax
  801302:	68 ac 2a 80 00       	push   $0x802aac
  801307:	68 9e 00 00 00       	push   $0x9e
  80130c:	68 77 2a 80 00       	push   $0x802a77
  801311:	e8 0f ef ff ff       	call   800225 <_panic>

00801316 <sfork>:

// Challenge!
int
sfork(void)
{
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
  801319:	57                   	push   %edi
  80131a:	56                   	push   %esi
  80131b:	53                   	push   %ebx
  80131c:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// return -E_INVAL;
	set_pgfault_handler(pgfault);
  80131f:	68 4a 10 80 00       	push   $0x80104a
  801324:	e8 12 0e 00 00       	call   80213b <set_pgfault_handler>
  801329:	b8 07 00 00 00       	mov    $0x7,%eax
  80132e:	cd 30                	int    $0x30
  801330:	89 c6                	mov    %eax,%esi
	int i;
	uintptr_t va;
	envid_t childid = sys_exofork();
	int r;
	if (childid < 0){
  801332:	83 c4 10             	add    $0x10,%esp
  801335:	85 c0                	test   %eax,%eax
  801337:	78 28                	js     801361 <sfork+0x4b>
  801339:	89 c7                	mov    %eax,%edi
	}

	extern volatile pde_t uvpd[];
	extern volatile pte_t uvpt[];

	for (va = 0; va < USTACKTOP; va += PGSIZE){
  80133b:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (childid == 0) {
  801340:	75 42                	jne    801384 <sfork+0x6e>
		thisenv = &envs[ENVX(sys_getenvid())];
  801342:	e8 93 fa ff ff       	call   800dda <sys_getenvid>
  801347:	25 ff 03 00 00       	and    $0x3ff,%eax
  80134c:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801352:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801357:	a3 20 44 80 00       	mov    %eax,0x804420
		return 0;
  80135c:	e9 bc 00 00 00       	jmp    80141d <sfork+0x107>
		panic("fork: child id < 0: %d", childid);
  801361:	50                   	push   %eax
  801362:	68 95 2a 80 00       	push   $0x802a95
  801367:	68 af 00 00 00       	push   $0xaf
  80136c:	68 77 2a 80 00       	push   $0x802a77
  801371:	e8 af ee ff ff       	call   800225 <_panic>
	for (va = 0; va < USTACKTOP; va += PGSIZE){
  801376:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80137c:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801382:	74 5b                	je     8013df <sfork+0xc9>
		if ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_U)){
  801384:	89 d8                	mov    %ebx,%eax
  801386:	c1 e8 16             	shr    $0x16,%eax
  801389:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801390:	a8 01                	test   $0x1,%al
  801392:	74 e2                	je     801376 <sfork+0x60>
  801394:	89 d8                	mov    %ebx,%eax
  801396:	c1 e8 0c             	shr    $0xc,%eax
  801399:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013a0:	f6 c2 01             	test   $0x1,%dl
  8013a3:	74 d1                	je     801376 <sfork+0x60>
  8013a5:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013ac:	f6 c2 04             	test   $0x4,%dl
  8013af:	74 c5                	je     801376 <sfork+0x60>
			void *addr = (void *)(PGNUM(va) * PGSIZE);
  8013b1:	c1 e0 0c             	shl    $0xc,%eax
			struct PageInfo *page;
			pte_t *pte;
			
			// page = page_lookup((envid_t)0->env_pgdir, addr, &pte);
			// page_insert(dstenv->env_pgdir, page, addr, PTE_U | PTE_P);
			r = sys_page_map((envid_t)0, addr, childid, addr, PTE_U | PTE_P);
  8013b4:	83 ec 0c             	sub    $0xc,%esp
  8013b7:	6a 05                	push   $0x5
  8013b9:	50                   	push   %eax
  8013ba:	57                   	push   %edi
  8013bb:	50                   	push   %eax
  8013bc:	6a 00                	push   $0x0
  8013be:	e8 98 fa ff ff       	call   800e5b <sys_page_map>
			if(r < 0){
  8013c3:	83 c4 20             	add    $0x20,%esp
  8013c6:	85 c0                	test   %eax,%eax
  8013c8:	79 ac                	jns    801376 <sfork+0x60>
				panic("sfork: sys_page_map fail, r:%d\n", r);
  8013ca:	50                   	push   %eax
  8013cb:	68 a4 2b 80 00       	push   $0x802ba4
  8013d0:	68 c4 00 00 00       	push   $0xc4
  8013d5:	68 77 2a 80 00       	push   $0x802a77
  8013da:	e8 46 ee ff ff       	call   800225 <_panic>
			}
		}
	}

	r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8013df:	83 ec 04             	sub    $0x4,%esp
  8013e2:	6a 07                	push   $0x7
  8013e4:	68 00 f0 bf ee       	push   $0xeebff000
  8013e9:	56                   	push   %esi
  8013ea:	e8 29 fa ff ff       	call   800e18 <sys_page_alloc>
	if (r < 0){
  8013ef:	83 c4 10             	add    $0x10,%esp
  8013f2:	85 c0                	test   %eax,%eax
  8013f4:	78 31                	js     801427 <sfork+0x111>
		panic("sfork: allocate user exception stack for child env error, %d", r);
	}
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  8013f6:	83 ec 08             	sub    $0x8,%esp
  8013f9:	68 a6 21 80 00       	push   $0x8021a6
  8013fe:	56                   	push   %esi
  8013ff:	e8 5f fb ff ff       	call   800f63 <sys_env_set_pgfault_upcall>
	if (r < 0){
  801404:	83 c4 10             	add    $0x10,%esp
  801407:	85 c0                	test   %eax,%eax
  801409:	78 31                	js     80143c <sfork+0x126>
		panic("sfork: sys_env_set_pgfault_upcall error, %d", r);
	}
	r = sys_env_set_status(childid, ENV_RUNNABLE);
  80140b:	83 ec 08             	sub    $0x8,%esp
  80140e:	6a 02                	push   $0x2
  801410:	56                   	push   %esi
  801411:	e8 c9 fa ff ff       	call   800edf <sys_env_set_status>
	if(r < 0){
  801416:	83 c4 10             	add    $0x10,%esp
  801419:	85 c0                	test   %eax,%eax
  80141b:	78 34                	js     801451 <sfork+0x13b>
		panic("sforK: sys_env_set_status, r%d", r);
	}
	return childid;
}
  80141d:	89 f0                	mov    %esi,%eax
  80141f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801422:	5b                   	pop    %ebx
  801423:	5e                   	pop    %esi
  801424:	5f                   	pop    %edi
  801425:	5d                   	pop    %ebp
  801426:	c3                   	ret    
		panic("sfork: allocate user exception stack for child env error, %d", r);
  801427:	50                   	push   %eax
  801428:	68 c4 2b 80 00       	push   $0x802bc4
  80142d:	68 cb 00 00 00       	push   $0xcb
  801432:	68 77 2a 80 00       	push   $0x802a77
  801437:	e8 e9 ed ff ff       	call   800225 <_panic>
		panic("sfork: sys_env_set_pgfault_upcall error, %d", r);
  80143c:	50                   	push   %eax
  80143d:	68 04 2c 80 00       	push   $0x802c04
  801442:	68 cf 00 00 00       	push   $0xcf
  801447:	68 77 2a 80 00       	push   $0x802a77
  80144c:	e8 d4 ed ff ff       	call   800225 <_panic>
		panic("sforK: sys_env_set_status, r%d", r);
  801451:	50                   	push   %eax
  801452:	68 30 2c 80 00       	push   $0x802c30
  801457:	68 d3 00 00 00       	push   $0xd3
  80145c:	68 77 2a 80 00       	push   $0x802a77
  801461:	e8 bf ed ff ff       	call   800225 <_panic>

00801466 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801466:	55                   	push   %ebp
  801467:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801469:	8b 45 08             	mov    0x8(%ebp),%eax
  80146c:	05 00 00 00 30       	add    $0x30000000,%eax
  801471:	c1 e8 0c             	shr    $0xc,%eax
}
  801474:	5d                   	pop    %ebp
  801475:	c3                   	ret    

00801476 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801476:	55                   	push   %ebp
  801477:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801479:	8b 45 08             	mov    0x8(%ebp),%eax
  80147c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801481:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801486:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80148b:	5d                   	pop    %ebp
  80148c:	c3                   	ret    

0080148d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80148d:	55                   	push   %ebp
  80148e:	89 e5                	mov    %esp,%ebp
  801490:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801495:	89 c2                	mov    %eax,%edx
  801497:	c1 ea 16             	shr    $0x16,%edx
  80149a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8014a1:	f6 c2 01             	test   $0x1,%dl
  8014a4:	74 2d                	je     8014d3 <fd_alloc+0x46>
  8014a6:	89 c2                	mov    %eax,%edx
  8014a8:	c1 ea 0c             	shr    $0xc,%edx
  8014ab:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014b2:	f6 c2 01             	test   $0x1,%dl
  8014b5:	74 1c                	je     8014d3 <fd_alloc+0x46>
  8014b7:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8014bc:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8014c1:	75 d2                	jne    801495 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8014c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8014cc:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8014d1:	eb 0a                	jmp    8014dd <fd_alloc+0x50>
			*fd_store = fd;
  8014d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014d6:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014dd:	5d                   	pop    %ebp
  8014de:	c3                   	ret    

008014df <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8014df:	55                   	push   %ebp
  8014e0:	89 e5                	mov    %esp,%ebp
  8014e2:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8014e5:	83 f8 1f             	cmp    $0x1f,%eax
  8014e8:	77 30                	ja     80151a <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8014ea:	c1 e0 0c             	shl    $0xc,%eax
  8014ed:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8014f2:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8014f8:	f6 c2 01             	test   $0x1,%dl
  8014fb:	74 24                	je     801521 <fd_lookup+0x42>
  8014fd:	89 c2                	mov    %eax,%edx
  8014ff:	c1 ea 0c             	shr    $0xc,%edx
  801502:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801509:	f6 c2 01             	test   $0x1,%dl
  80150c:	74 1a                	je     801528 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80150e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801511:	89 02                	mov    %eax,(%edx)
	return 0;
  801513:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801518:	5d                   	pop    %ebp
  801519:	c3                   	ret    
		return -E_INVAL;
  80151a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80151f:	eb f7                	jmp    801518 <fd_lookup+0x39>
		return -E_INVAL;
  801521:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801526:	eb f0                	jmp    801518 <fd_lookup+0x39>
  801528:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80152d:	eb e9                	jmp    801518 <fd_lookup+0x39>

0080152f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80152f:	55                   	push   %ebp
  801530:	89 e5                	mov    %esp,%ebp
  801532:	83 ec 08             	sub    $0x8,%esp
  801535:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801538:	ba cc 2c 80 00       	mov    $0x802ccc,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80153d:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801542:	39 08                	cmp    %ecx,(%eax)
  801544:	74 33                	je     801579 <dev_lookup+0x4a>
  801546:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801549:	8b 02                	mov    (%edx),%eax
  80154b:	85 c0                	test   %eax,%eax
  80154d:	75 f3                	jne    801542 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80154f:	a1 20 44 80 00       	mov    0x804420,%eax
  801554:	8b 40 48             	mov    0x48(%eax),%eax
  801557:	83 ec 04             	sub    $0x4,%esp
  80155a:	51                   	push   %ecx
  80155b:	50                   	push   %eax
  80155c:	68 50 2c 80 00       	push   $0x802c50
  801561:	e8 9a ed ff ff       	call   800300 <cprintf>
	*dev = 0;
  801566:	8b 45 0c             	mov    0xc(%ebp),%eax
  801569:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80156f:	83 c4 10             	add    $0x10,%esp
  801572:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801577:	c9                   	leave  
  801578:	c3                   	ret    
			*dev = devtab[i];
  801579:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80157c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80157e:	b8 00 00 00 00       	mov    $0x0,%eax
  801583:	eb f2                	jmp    801577 <dev_lookup+0x48>

00801585 <fd_close>:
{
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
  801588:	57                   	push   %edi
  801589:	56                   	push   %esi
  80158a:	53                   	push   %ebx
  80158b:	83 ec 24             	sub    $0x24,%esp
  80158e:	8b 75 08             	mov    0x8(%ebp),%esi
  801591:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801594:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801597:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801598:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80159e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015a1:	50                   	push   %eax
  8015a2:	e8 38 ff ff ff       	call   8014df <fd_lookup>
  8015a7:	89 c3                	mov    %eax,%ebx
  8015a9:	83 c4 10             	add    $0x10,%esp
  8015ac:	85 c0                	test   %eax,%eax
  8015ae:	78 05                	js     8015b5 <fd_close+0x30>
	    || fd != fd2)
  8015b0:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8015b3:	74 16                	je     8015cb <fd_close+0x46>
		return (must_exist ? r : 0);
  8015b5:	89 f8                	mov    %edi,%eax
  8015b7:	84 c0                	test   %al,%al
  8015b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8015be:	0f 44 d8             	cmove  %eax,%ebx
}
  8015c1:	89 d8                	mov    %ebx,%eax
  8015c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015c6:	5b                   	pop    %ebx
  8015c7:	5e                   	pop    %esi
  8015c8:	5f                   	pop    %edi
  8015c9:	5d                   	pop    %ebp
  8015ca:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8015cb:	83 ec 08             	sub    $0x8,%esp
  8015ce:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8015d1:	50                   	push   %eax
  8015d2:	ff 36                	pushl  (%esi)
  8015d4:	e8 56 ff ff ff       	call   80152f <dev_lookup>
  8015d9:	89 c3                	mov    %eax,%ebx
  8015db:	83 c4 10             	add    $0x10,%esp
  8015de:	85 c0                	test   %eax,%eax
  8015e0:	78 1a                	js     8015fc <fd_close+0x77>
		if (dev->dev_close)
  8015e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015e5:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8015e8:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8015ed:	85 c0                	test   %eax,%eax
  8015ef:	74 0b                	je     8015fc <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8015f1:	83 ec 0c             	sub    $0xc,%esp
  8015f4:	56                   	push   %esi
  8015f5:	ff d0                	call   *%eax
  8015f7:	89 c3                	mov    %eax,%ebx
  8015f9:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8015fc:	83 ec 08             	sub    $0x8,%esp
  8015ff:	56                   	push   %esi
  801600:	6a 00                	push   $0x0
  801602:	e8 96 f8 ff ff       	call   800e9d <sys_page_unmap>
	return r;
  801607:	83 c4 10             	add    $0x10,%esp
  80160a:	eb b5                	jmp    8015c1 <fd_close+0x3c>

0080160c <close>:

int
close(int fdnum)
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
  80160f:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801612:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801615:	50                   	push   %eax
  801616:	ff 75 08             	pushl  0x8(%ebp)
  801619:	e8 c1 fe ff ff       	call   8014df <fd_lookup>
  80161e:	83 c4 10             	add    $0x10,%esp
  801621:	85 c0                	test   %eax,%eax
  801623:	79 02                	jns    801627 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801625:	c9                   	leave  
  801626:	c3                   	ret    
		return fd_close(fd, 1);
  801627:	83 ec 08             	sub    $0x8,%esp
  80162a:	6a 01                	push   $0x1
  80162c:	ff 75 f4             	pushl  -0xc(%ebp)
  80162f:	e8 51 ff ff ff       	call   801585 <fd_close>
  801634:	83 c4 10             	add    $0x10,%esp
  801637:	eb ec                	jmp    801625 <close+0x19>

00801639 <close_all>:

void
close_all(void)
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
  80163c:	53                   	push   %ebx
  80163d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801640:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801645:	83 ec 0c             	sub    $0xc,%esp
  801648:	53                   	push   %ebx
  801649:	e8 be ff ff ff       	call   80160c <close>
	for (i = 0; i < MAXFD; i++)
  80164e:	83 c3 01             	add    $0x1,%ebx
  801651:	83 c4 10             	add    $0x10,%esp
  801654:	83 fb 20             	cmp    $0x20,%ebx
  801657:	75 ec                	jne    801645 <close_all+0xc>
}
  801659:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80165c:	c9                   	leave  
  80165d:	c3                   	ret    

0080165e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
  801661:	57                   	push   %edi
  801662:	56                   	push   %esi
  801663:	53                   	push   %ebx
  801664:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801667:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80166a:	50                   	push   %eax
  80166b:	ff 75 08             	pushl  0x8(%ebp)
  80166e:	e8 6c fe ff ff       	call   8014df <fd_lookup>
  801673:	89 c3                	mov    %eax,%ebx
  801675:	83 c4 10             	add    $0x10,%esp
  801678:	85 c0                	test   %eax,%eax
  80167a:	0f 88 81 00 00 00    	js     801701 <dup+0xa3>
		return r;
	close(newfdnum);
  801680:	83 ec 0c             	sub    $0xc,%esp
  801683:	ff 75 0c             	pushl  0xc(%ebp)
  801686:	e8 81 ff ff ff       	call   80160c <close>

	newfd = INDEX2FD(newfdnum);
  80168b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80168e:	c1 e6 0c             	shl    $0xc,%esi
  801691:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801697:	83 c4 04             	add    $0x4,%esp
  80169a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80169d:	e8 d4 fd ff ff       	call   801476 <fd2data>
  8016a2:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8016a4:	89 34 24             	mov    %esi,(%esp)
  8016a7:	e8 ca fd ff ff       	call   801476 <fd2data>
  8016ac:	83 c4 10             	add    $0x10,%esp
  8016af:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8016b1:	89 d8                	mov    %ebx,%eax
  8016b3:	c1 e8 16             	shr    $0x16,%eax
  8016b6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016bd:	a8 01                	test   $0x1,%al
  8016bf:	74 11                	je     8016d2 <dup+0x74>
  8016c1:	89 d8                	mov    %ebx,%eax
  8016c3:	c1 e8 0c             	shr    $0xc,%eax
  8016c6:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8016cd:	f6 c2 01             	test   $0x1,%dl
  8016d0:	75 39                	jne    80170b <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016d5:	89 d0                	mov    %edx,%eax
  8016d7:	c1 e8 0c             	shr    $0xc,%eax
  8016da:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016e1:	83 ec 0c             	sub    $0xc,%esp
  8016e4:	25 07 0e 00 00       	and    $0xe07,%eax
  8016e9:	50                   	push   %eax
  8016ea:	56                   	push   %esi
  8016eb:	6a 00                	push   $0x0
  8016ed:	52                   	push   %edx
  8016ee:	6a 00                	push   $0x0
  8016f0:	e8 66 f7 ff ff       	call   800e5b <sys_page_map>
  8016f5:	89 c3                	mov    %eax,%ebx
  8016f7:	83 c4 20             	add    $0x20,%esp
  8016fa:	85 c0                	test   %eax,%eax
  8016fc:	78 31                	js     80172f <dup+0xd1>
		goto err;

	return newfdnum;
  8016fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801701:	89 d8                	mov    %ebx,%eax
  801703:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801706:	5b                   	pop    %ebx
  801707:	5e                   	pop    %esi
  801708:	5f                   	pop    %edi
  801709:	5d                   	pop    %ebp
  80170a:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80170b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801712:	83 ec 0c             	sub    $0xc,%esp
  801715:	25 07 0e 00 00       	and    $0xe07,%eax
  80171a:	50                   	push   %eax
  80171b:	57                   	push   %edi
  80171c:	6a 00                	push   $0x0
  80171e:	53                   	push   %ebx
  80171f:	6a 00                	push   $0x0
  801721:	e8 35 f7 ff ff       	call   800e5b <sys_page_map>
  801726:	89 c3                	mov    %eax,%ebx
  801728:	83 c4 20             	add    $0x20,%esp
  80172b:	85 c0                	test   %eax,%eax
  80172d:	79 a3                	jns    8016d2 <dup+0x74>
	sys_page_unmap(0, newfd);
  80172f:	83 ec 08             	sub    $0x8,%esp
  801732:	56                   	push   %esi
  801733:	6a 00                	push   $0x0
  801735:	e8 63 f7 ff ff       	call   800e9d <sys_page_unmap>
	sys_page_unmap(0, nva);
  80173a:	83 c4 08             	add    $0x8,%esp
  80173d:	57                   	push   %edi
  80173e:	6a 00                	push   $0x0
  801740:	e8 58 f7 ff ff       	call   800e9d <sys_page_unmap>
	return r;
  801745:	83 c4 10             	add    $0x10,%esp
  801748:	eb b7                	jmp    801701 <dup+0xa3>

0080174a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
  80174d:	53                   	push   %ebx
  80174e:	83 ec 1c             	sub    $0x1c,%esp
  801751:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801754:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801757:	50                   	push   %eax
  801758:	53                   	push   %ebx
  801759:	e8 81 fd ff ff       	call   8014df <fd_lookup>
  80175e:	83 c4 10             	add    $0x10,%esp
  801761:	85 c0                	test   %eax,%eax
  801763:	78 3f                	js     8017a4 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801765:	83 ec 08             	sub    $0x8,%esp
  801768:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80176b:	50                   	push   %eax
  80176c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176f:	ff 30                	pushl  (%eax)
  801771:	e8 b9 fd ff ff       	call   80152f <dev_lookup>
  801776:	83 c4 10             	add    $0x10,%esp
  801779:	85 c0                	test   %eax,%eax
  80177b:	78 27                	js     8017a4 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80177d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801780:	8b 42 08             	mov    0x8(%edx),%eax
  801783:	83 e0 03             	and    $0x3,%eax
  801786:	83 f8 01             	cmp    $0x1,%eax
  801789:	74 1e                	je     8017a9 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80178b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80178e:	8b 40 08             	mov    0x8(%eax),%eax
  801791:	85 c0                	test   %eax,%eax
  801793:	74 35                	je     8017ca <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801795:	83 ec 04             	sub    $0x4,%esp
  801798:	ff 75 10             	pushl  0x10(%ebp)
  80179b:	ff 75 0c             	pushl  0xc(%ebp)
  80179e:	52                   	push   %edx
  80179f:	ff d0                	call   *%eax
  8017a1:	83 c4 10             	add    $0x10,%esp
}
  8017a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017a7:	c9                   	leave  
  8017a8:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8017a9:	a1 20 44 80 00       	mov    0x804420,%eax
  8017ae:	8b 40 48             	mov    0x48(%eax),%eax
  8017b1:	83 ec 04             	sub    $0x4,%esp
  8017b4:	53                   	push   %ebx
  8017b5:	50                   	push   %eax
  8017b6:	68 91 2c 80 00       	push   $0x802c91
  8017bb:	e8 40 eb ff ff       	call   800300 <cprintf>
		return -E_INVAL;
  8017c0:	83 c4 10             	add    $0x10,%esp
  8017c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017c8:	eb da                	jmp    8017a4 <read+0x5a>
		return -E_NOT_SUPP;
  8017ca:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017cf:	eb d3                	jmp    8017a4 <read+0x5a>

008017d1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8017d1:	55                   	push   %ebp
  8017d2:	89 e5                	mov    %esp,%ebp
  8017d4:	57                   	push   %edi
  8017d5:	56                   	push   %esi
  8017d6:	53                   	push   %ebx
  8017d7:	83 ec 0c             	sub    $0xc,%esp
  8017da:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017dd:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017e0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017e5:	39 f3                	cmp    %esi,%ebx
  8017e7:	73 23                	jae    80180c <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017e9:	83 ec 04             	sub    $0x4,%esp
  8017ec:	89 f0                	mov    %esi,%eax
  8017ee:	29 d8                	sub    %ebx,%eax
  8017f0:	50                   	push   %eax
  8017f1:	89 d8                	mov    %ebx,%eax
  8017f3:	03 45 0c             	add    0xc(%ebp),%eax
  8017f6:	50                   	push   %eax
  8017f7:	57                   	push   %edi
  8017f8:	e8 4d ff ff ff       	call   80174a <read>
		if (m < 0)
  8017fd:	83 c4 10             	add    $0x10,%esp
  801800:	85 c0                	test   %eax,%eax
  801802:	78 06                	js     80180a <readn+0x39>
			return m;
		if (m == 0)
  801804:	74 06                	je     80180c <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801806:	01 c3                	add    %eax,%ebx
  801808:	eb db                	jmp    8017e5 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80180a:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80180c:	89 d8                	mov    %ebx,%eax
  80180e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801811:	5b                   	pop    %ebx
  801812:	5e                   	pop    %esi
  801813:	5f                   	pop    %edi
  801814:	5d                   	pop    %ebp
  801815:	c3                   	ret    

00801816 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801816:	55                   	push   %ebp
  801817:	89 e5                	mov    %esp,%ebp
  801819:	53                   	push   %ebx
  80181a:	83 ec 1c             	sub    $0x1c,%esp
  80181d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801820:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801823:	50                   	push   %eax
  801824:	53                   	push   %ebx
  801825:	e8 b5 fc ff ff       	call   8014df <fd_lookup>
  80182a:	83 c4 10             	add    $0x10,%esp
  80182d:	85 c0                	test   %eax,%eax
  80182f:	78 3a                	js     80186b <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801831:	83 ec 08             	sub    $0x8,%esp
  801834:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801837:	50                   	push   %eax
  801838:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80183b:	ff 30                	pushl  (%eax)
  80183d:	e8 ed fc ff ff       	call   80152f <dev_lookup>
  801842:	83 c4 10             	add    $0x10,%esp
  801845:	85 c0                	test   %eax,%eax
  801847:	78 22                	js     80186b <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801849:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80184c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801850:	74 1e                	je     801870 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801852:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801855:	8b 52 0c             	mov    0xc(%edx),%edx
  801858:	85 d2                	test   %edx,%edx
  80185a:	74 35                	je     801891 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80185c:	83 ec 04             	sub    $0x4,%esp
  80185f:	ff 75 10             	pushl  0x10(%ebp)
  801862:	ff 75 0c             	pushl  0xc(%ebp)
  801865:	50                   	push   %eax
  801866:	ff d2                	call   *%edx
  801868:	83 c4 10             	add    $0x10,%esp
}
  80186b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801870:	a1 20 44 80 00       	mov    0x804420,%eax
  801875:	8b 40 48             	mov    0x48(%eax),%eax
  801878:	83 ec 04             	sub    $0x4,%esp
  80187b:	53                   	push   %ebx
  80187c:	50                   	push   %eax
  80187d:	68 ad 2c 80 00       	push   $0x802cad
  801882:	e8 79 ea ff ff       	call   800300 <cprintf>
		return -E_INVAL;
  801887:	83 c4 10             	add    $0x10,%esp
  80188a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80188f:	eb da                	jmp    80186b <write+0x55>
		return -E_NOT_SUPP;
  801891:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801896:	eb d3                	jmp    80186b <write+0x55>

00801898 <seek>:

int
seek(int fdnum, off_t offset)
{
  801898:	55                   	push   %ebp
  801899:	89 e5                	mov    %esp,%ebp
  80189b:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80189e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018a1:	50                   	push   %eax
  8018a2:	ff 75 08             	pushl  0x8(%ebp)
  8018a5:	e8 35 fc ff ff       	call   8014df <fd_lookup>
  8018aa:	83 c4 10             	add    $0x10,%esp
  8018ad:	85 c0                	test   %eax,%eax
  8018af:	78 0e                	js     8018bf <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8018b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b7:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8018ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	53                   	push   %ebx
  8018c5:	83 ec 1c             	sub    $0x1c,%esp
  8018c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018cb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018ce:	50                   	push   %eax
  8018cf:	53                   	push   %ebx
  8018d0:	e8 0a fc ff ff       	call   8014df <fd_lookup>
  8018d5:	83 c4 10             	add    $0x10,%esp
  8018d8:	85 c0                	test   %eax,%eax
  8018da:	78 37                	js     801913 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018dc:	83 ec 08             	sub    $0x8,%esp
  8018df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018e2:	50                   	push   %eax
  8018e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e6:	ff 30                	pushl  (%eax)
  8018e8:	e8 42 fc ff ff       	call   80152f <dev_lookup>
  8018ed:	83 c4 10             	add    $0x10,%esp
  8018f0:	85 c0                	test   %eax,%eax
  8018f2:	78 1f                	js     801913 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018f7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018fb:	74 1b                	je     801918 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8018fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801900:	8b 52 18             	mov    0x18(%edx),%edx
  801903:	85 d2                	test   %edx,%edx
  801905:	74 32                	je     801939 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801907:	83 ec 08             	sub    $0x8,%esp
  80190a:	ff 75 0c             	pushl  0xc(%ebp)
  80190d:	50                   	push   %eax
  80190e:	ff d2                	call   *%edx
  801910:	83 c4 10             	add    $0x10,%esp
}
  801913:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801916:	c9                   	leave  
  801917:	c3                   	ret    
			thisenv->env_id, fdnum);
  801918:	a1 20 44 80 00       	mov    0x804420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80191d:	8b 40 48             	mov    0x48(%eax),%eax
  801920:	83 ec 04             	sub    $0x4,%esp
  801923:	53                   	push   %ebx
  801924:	50                   	push   %eax
  801925:	68 70 2c 80 00       	push   $0x802c70
  80192a:	e8 d1 e9 ff ff       	call   800300 <cprintf>
		return -E_INVAL;
  80192f:	83 c4 10             	add    $0x10,%esp
  801932:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801937:	eb da                	jmp    801913 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801939:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80193e:	eb d3                	jmp    801913 <ftruncate+0x52>

00801940 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
  801943:	53                   	push   %ebx
  801944:	83 ec 1c             	sub    $0x1c,%esp
  801947:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80194a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80194d:	50                   	push   %eax
  80194e:	ff 75 08             	pushl  0x8(%ebp)
  801951:	e8 89 fb ff ff       	call   8014df <fd_lookup>
  801956:	83 c4 10             	add    $0x10,%esp
  801959:	85 c0                	test   %eax,%eax
  80195b:	78 4b                	js     8019a8 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80195d:	83 ec 08             	sub    $0x8,%esp
  801960:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801963:	50                   	push   %eax
  801964:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801967:	ff 30                	pushl  (%eax)
  801969:	e8 c1 fb ff ff       	call   80152f <dev_lookup>
  80196e:	83 c4 10             	add    $0x10,%esp
  801971:	85 c0                	test   %eax,%eax
  801973:	78 33                	js     8019a8 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801978:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80197c:	74 2f                	je     8019ad <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80197e:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801981:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801988:	00 00 00 
	stat->st_isdir = 0;
  80198b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801992:	00 00 00 
	stat->st_dev = dev;
  801995:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80199b:	83 ec 08             	sub    $0x8,%esp
  80199e:	53                   	push   %ebx
  80199f:	ff 75 f0             	pushl  -0x10(%ebp)
  8019a2:	ff 50 14             	call   *0x14(%eax)
  8019a5:	83 c4 10             	add    $0x10,%esp
}
  8019a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    
		return -E_NOT_SUPP;
  8019ad:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019b2:	eb f4                	jmp    8019a8 <fstat+0x68>

008019b4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
  8019b7:	56                   	push   %esi
  8019b8:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8019b9:	83 ec 08             	sub    $0x8,%esp
  8019bc:	6a 00                	push   $0x0
  8019be:	ff 75 08             	pushl  0x8(%ebp)
  8019c1:	e8 bb 01 00 00       	call   801b81 <open>
  8019c6:	89 c3                	mov    %eax,%ebx
  8019c8:	83 c4 10             	add    $0x10,%esp
  8019cb:	85 c0                	test   %eax,%eax
  8019cd:	78 1b                	js     8019ea <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8019cf:	83 ec 08             	sub    $0x8,%esp
  8019d2:	ff 75 0c             	pushl  0xc(%ebp)
  8019d5:	50                   	push   %eax
  8019d6:	e8 65 ff ff ff       	call   801940 <fstat>
  8019db:	89 c6                	mov    %eax,%esi
	close(fd);
  8019dd:	89 1c 24             	mov    %ebx,(%esp)
  8019e0:	e8 27 fc ff ff       	call   80160c <close>
	return r;
  8019e5:	83 c4 10             	add    $0x10,%esp
  8019e8:	89 f3                	mov    %esi,%ebx
}
  8019ea:	89 d8                	mov    %ebx,%eax
  8019ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ef:	5b                   	pop    %ebx
  8019f0:	5e                   	pop    %esi
  8019f1:	5d                   	pop    %ebp
  8019f2:	c3                   	ret    

008019f3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
  8019f6:	56                   	push   %esi
  8019f7:	53                   	push   %ebx
  8019f8:	89 c6                	mov    %eax,%esi
  8019fa:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8019fc:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801a03:	74 27                	je     801a2c <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a05:	6a 07                	push   $0x7
  801a07:	68 00 50 80 00       	push   $0x805000
  801a0c:	56                   	push   %esi
  801a0d:	ff 35 00 40 80 00    	pushl  0x804000
  801a13:	e8 1d 08 00 00       	call   802235 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a18:	83 c4 0c             	add    $0xc,%esp
  801a1b:	6a 00                	push   $0x0
  801a1d:	53                   	push   %ebx
  801a1e:	6a 00                	push   $0x0
  801a20:	e8 a7 07 00 00       	call   8021cc <ipc_recv>
}
  801a25:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a28:	5b                   	pop    %ebx
  801a29:	5e                   	pop    %esi
  801a2a:	5d                   	pop    %ebp
  801a2b:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a2c:	83 ec 0c             	sub    $0xc,%esp
  801a2f:	6a 01                	push   $0x1
  801a31:	e8 4c 08 00 00       	call   802282 <ipc_find_env>
  801a36:	a3 00 40 80 00       	mov    %eax,0x804000
  801a3b:	83 c4 10             	add    $0x10,%esp
  801a3e:	eb c5                	jmp    801a05 <fsipc+0x12>

00801a40 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
  801a43:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a46:	8b 45 08             	mov    0x8(%ebp),%eax
  801a49:	8b 40 0c             	mov    0xc(%eax),%eax
  801a4c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801a51:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a54:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a59:	ba 00 00 00 00       	mov    $0x0,%edx
  801a5e:	b8 02 00 00 00       	mov    $0x2,%eax
  801a63:	e8 8b ff ff ff       	call   8019f3 <fsipc>
}
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <devfile_flush>:
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
  801a6d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a70:	8b 45 08             	mov    0x8(%ebp),%eax
  801a73:	8b 40 0c             	mov    0xc(%eax),%eax
  801a76:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801a7b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a80:	b8 06 00 00 00       	mov    $0x6,%eax
  801a85:	e8 69 ff ff ff       	call   8019f3 <fsipc>
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <devfile_stat>:
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
  801a8f:	53                   	push   %ebx
  801a90:	83 ec 04             	sub    $0x4,%esp
  801a93:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a96:	8b 45 08             	mov    0x8(%ebp),%eax
  801a99:	8b 40 0c             	mov    0xc(%eax),%eax
  801a9c:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801aa1:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa6:	b8 05 00 00 00       	mov    $0x5,%eax
  801aab:	e8 43 ff ff ff       	call   8019f3 <fsipc>
  801ab0:	85 c0                	test   %eax,%eax
  801ab2:	78 2c                	js     801ae0 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801ab4:	83 ec 08             	sub    $0x8,%esp
  801ab7:	68 00 50 80 00       	push   $0x805000
  801abc:	53                   	push   %ebx
  801abd:	e8 64 ef ff ff       	call   800a26 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801ac2:	a1 80 50 80 00       	mov    0x805080,%eax
  801ac7:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801acd:	a1 84 50 80 00       	mov    0x805084,%eax
  801ad2:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801ad8:	83 c4 10             	add    $0x10,%esp
  801adb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ae0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <devfile_write>:
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
  801ae8:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  801aeb:	68 dc 2c 80 00       	push   $0x802cdc
  801af0:	68 90 00 00 00       	push   $0x90
  801af5:	68 fa 2c 80 00       	push   $0x802cfa
  801afa:	e8 26 e7 ff ff       	call   800225 <_panic>

00801aff <devfile_read>:
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
  801b02:	56                   	push   %esi
  801b03:	53                   	push   %ebx
  801b04:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b07:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0a:	8b 40 0c             	mov    0xc(%eax),%eax
  801b0d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801b12:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b18:	ba 00 00 00 00       	mov    $0x0,%edx
  801b1d:	b8 03 00 00 00       	mov    $0x3,%eax
  801b22:	e8 cc fe ff ff       	call   8019f3 <fsipc>
  801b27:	89 c3                	mov    %eax,%ebx
  801b29:	85 c0                	test   %eax,%eax
  801b2b:	78 1f                	js     801b4c <devfile_read+0x4d>
	assert(r <= n);
  801b2d:	39 f0                	cmp    %esi,%eax
  801b2f:	77 24                	ja     801b55 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801b31:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b36:	7f 33                	jg     801b6b <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b38:	83 ec 04             	sub    $0x4,%esp
  801b3b:	50                   	push   %eax
  801b3c:	68 00 50 80 00       	push   $0x805000
  801b41:	ff 75 0c             	pushl  0xc(%ebp)
  801b44:	e8 6b f0 ff ff       	call   800bb4 <memmove>
	return r;
  801b49:	83 c4 10             	add    $0x10,%esp
}
  801b4c:	89 d8                	mov    %ebx,%eax
  801b4e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b51:	5b                   	pop    %ebx
  801b52:	5e                   	pop    %esi
  801b53:	5d                   	pop    %ebp
  801b54:	c3                   	ret    
	assert(r <= n);
  801b55:	68 05 2d 80 00       	push   $0x802d05
  801b5a:	68 0c 2d 80 00       	push   $0x802d0c
  801b5f:	6a 7c                	push   $0x7c
  801b61:	68 fa 2c 80 00       	push   $0x802cfa
  801b66:	e8 ba e6 ff ff       	call   800225 <_panic>
	assert(r <= PGSIZE);
  801b6b:	68 21 2d 80 00       	push   $0x802d21
  801b70:	68 0c 2d 80 00       	push   $0x802d0c
  801b75:	6a 7d                	push   $0x7d
  801b77:	68 fa 2c 80 00       	push   $0x802cfa
  801b7c:	e8 a4 e6 ff ff       	call   800225 <_panic>

00801b81 <open>:
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
  801b84:	56                   	push   %esi
  801b85:	53                   	push   %ebx
  801b86:	83 ec 1c             	sub    $0x1c,%esp
  801b89:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b8c:	56                   	push   %esi
  801b8d:	e8 5b ee ff ff       	call   8009ed <strlen>
  801b92:	83 c4 10             	add    $0x10,%esp
  801b95:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b9a:	7f 6c                	jg     801c08 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801b9c:	83 ec 0c             	sub    $0xc,%esp
  801b9f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ba2:	50                   	push   %eax
  801ba3:	e8 e5 f8 ff ff       	call   80148d <fd_alloc>
  801ba8:	89 c3                	mov    %eax,%ebx
  801baa:	83 c4 10             	add    $0x10,%esp
  801bad:	85 c0                	test   %eax,%eax
  801baf:	78 3c                	js     801bed <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801bb1:	83 ec 08             	sub    $0x8,%esp
  801bb4:	56                   	push   %esi
  801bb5:	68 00 50 80 00       	push   $0x805000
  801bba:	e8 67 ee ff ff       	call   800a26 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc2:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801bc7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bca:	b8 01 00 00 00       	mov    $0x1,%eax
  801bcf:	e8 1f fe ff ff       	call   8019f3 <fsipc>
  801bd4:	89 c3                	mov    %eax,%ebx
  801bd6:	83 c4 10             	add    $0x10,%esp
  801bd9:	85 c0                	test   %eax,%eax
  801bdb:	78 19                	js     801bf6 <open+0x75>
	return fd2num(fd);
  801bdd:	83 ec 0c             	sub    $0xc,%esp
  801be0:	ff 75 f4             	pushl  -0xc(%ebp)
  801be3:	e8 7e f8 ff ff       	call   801466 <fd2num>
  801be8:	89 c3                	mov    %eax,%ebx
  801bea:	83 c4 10             	add    $0x10,%esp
}
  801bed:	89 d8                	mov    %ebx,%eax
  801bef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bf2:	5b                   	pop    %ebx
  801bf3:	5e                   	pop    %esi
  801bf4:	5d                   	pop    %ebp
  801bf5:	c3                   	ret    
		fd_close(fd, 0);
  801bf6:	83 ec 08             	sub    $0x8,%esp
  801bf9:	6a 00                	push   $0x0
  801bfb:	ff 75 f4             	pushl  -0xc(%ebp)
  801bfe:	e8 82 f9 ff ff       	call   801585 <fd_close>
		return r;
  801c03:	83 c4 10             	add    $0x10,%esp
  801c06:	eb e5                	jmp    801bed <open+0x6c>
		return -E_BAD_PATH;
  801c08:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801c0d:	eb de                	jmp    801bed <open+0x6c>

00801c0f <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c0f:	55                   	push   %ebp
  801c10:	89 e5                	mov    %esp,%ebp
  801c12:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c15:	ba 00 00 00 00       	mov    $0x0,%edx
  801c1a:	b8 08 00 00 00       	mov    $0x8,%eax
  801c1f:	e8 cf fd ff ff       	call   8019f3 <fsipc>
}
  801c24:	c9                   	leave  
  801c25:	c3                   	ret    

00801c26 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
  801c29:	56                   	push   %esi
  801c2a:	53                   	push   %ebx
  801c2b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c2e:	83 ec 0c             	sub    $0xc,%esp
  801c31:	ff 75 08             	pushl  0x8(%ebp)
  801c34:	e8 3d f8 ff ff       	call   801476 <fd2data>
  801c39:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c3b:	83 c4 08             	add    $0x8,%esp
  801c3e:	68 2d 2d 80 00       	push   $0x802d2d
  801c43:	53                   	push   %ebx
  801c44:	e8 dd ed ff ff       	call   800a26 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c49:	8b 46 04             	mov    0x4(%esi),%eax
  801c4c:	2b 06                	sub    (%esi),%eax
  801c4e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c54:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c5b:	00 00 00 
	stat->st_dev = &devpipe;
  801c5e:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801c65:	30 80 00 
	return 0;
}
  801c68:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c70:	5b                   	pop    %ebx
  801c71:	5e                   	pop    %esi
  801c72:	5d                   	pop    %ebp
  801c73:	c3                   	ret    

00801c74 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
  801c77:	53                   	push   %ebx
  801c78:	83 ec 0c             	sub    $0xc,%esp
  801c7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c7e:	53                   	push   %ebx
  801c7f:	6a 00                	push   $0x0
  801c81:	e8 17 f2 ff ff       	call   800e9d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c86:	89 1c 24             	mov    %ebx,(%esp)
  801c89:	e8 e8 f7 ff ff       	call   801476 <fd2data>
  801c8e:	83 c4 08             	add    $0x8,%esp
  801c91:	50                   	push   %eax
  801c92:	6a 00                	push   $0x0
  801c94:	e8 04 f2 ff ff       	call   800e9d <sys_page_unmap>
}
  801c99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <_pipeisclosed>:
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	57                   	push   %edi
  801ca2:	56                   	push   %esi
  801ca3:	53                   	push   %ebx
  801ca4:	83 ec 1c             	sub    $0x1c,%esp
  801ca7:	89 c7                	mov    %eax,%edi
  801ca9:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801cab:	a1 20 44 80 00       	mov    0x804420,%eax
  801cb0:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801cb3:	83 ec 0c             	sub    $0xc,%esp
  801cb6:	57                   	push   %edi
  801cb7:	e8 05 06 00 00       	call   8022c1 <pageref>
  801cbc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cbf:	89 34 24             	mov    %esi,(%esp)
  801cc2:	e8 fa 05 00 00       	call   8022c1 <pageref>
		nn = thisenv->env_runs;
  801cc7:	8b 15 20 44 80 00    	mov    0x804420,%edx
  801ccd:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801cd0:	83 c4 10             	add    $0x10,%esp
  801cd3:	39 cb                	cmp    %ecx,%ebx
  801cd5:	74 1b                	je     801cf2 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801cd7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cda:	75 cf                	jne    801cab <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801cdc:	8b 42 58             	mov    0x58(%edx),%eax
  801cdf:	6a 01                	push   $0x1
  801ce1:	50                   	push   %eax
  801ce2:	53                   	push   %ebx
  801ce3:	68 34 2d 80 00       	push   $0x802d34
  801ce8:	e8 13 e6 ff ff       	call   800300 <cprintf>
  801ced:	83 c4 10             	add    $0x10,%esp
  801cf0:	eb b9                	jmp    801cab <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801cf2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cf5:	0f 94 c0             	sete   %al
  801cf8:	0f b6 c0             	movzbl %al,%eax
}
  801cfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cfe:	5b                   	pop    %ebx
  801cff:	5e                   	pop    %esi
  801d00:	5f                   	pop    %edi
  801d01:	5d                   	pop    %ebp
  801d02:	c3                   	ret    

00801d03 <devpipe_write>:
{
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
  801d06:	57                   	push   %edi
  801d07:	56                   	push   %esi
  801d08:	53                   	push   %ebx
  801d09:	83 ec 28             	sub    $0x28,%esp
  801d0c:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d0f:	56                   	push   %esi
  801d10:	e8 61 f7 ff ff       	call   801476 <fd2data>
  801d15:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d17:	83 c4 10             	add    $0x10,%esp
  801d1a:	bf 00 00 00 00       	mov    $0x0,%edi
  801d1f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d22:	74 4f                	je     801d73 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d24:	8b 43 04             	mov    0x4(%ebx),%eax
  801d27:	8b 0b                	mov    (%ebx),%ecx
  801d29:	8d 51 20             	lea    0x20(%ecx),%edx
  801d2c:	39 d0                	cmp    %edx,%eax
  801d2e:	72 14                	jb     801d44 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d30:	89 da                	mov    %ebx,%edx
  801d32:	89 f0                	mov    %esi,%eax
  801d34:	e8 65 ff ff ff       	call   801c9e <_pipeisclosed>
  801d39:	85 c0                	test   %eax,%eax
  801d3b:	75 3b                	jne    801d78 <devpipe_write+0x75>
			sys_yield();
  801d3d:	e8 b7 f0 ff ff       	call   800df9 <sys_yield>
  801d42:	eb e0                	jmp    801d24 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d44:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d47:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d4b:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d4e:	89 c2                	mov    %eax,%edx
  801d50:	c1 fa 1f             	sar    $0x1f,%edx
  801d53:	89 d1                	mov    %edx,%ecx
  801d55:	c1 e9 1b             	shr    $0x1b,%ecx
  801d58:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d5b:	83 e2 1f             	and    $0x1f,%edx
  801d5e:	29 ca                	sub    %ecx,%edx
  801d60:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d64:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d68:	83 c0 01             	add    $0x1,%eax
  801d6b:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d6e:	83 c7 01             	add    $0x1,%edi
  801d71:	eb ac                	jmp    801d1f <devpipe_write+0x1c>
	return i;
  801d73:	8b 45 10             	mov    0x10(%ebp),%eax
  801d76:	eb 05                	jmp    801d7d <devpipe_write+0x7a>
				return 0;
  801d78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d80:	5b                   	pop    %ebx
  801d81:	5e                   	pop    %esi
  801d82:	5f                   	pop    %edi
  801d83:	5d                   	pop    %ebp
  801d84:	c3                   	ret    

00801d85 <devpipe_read>:
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
  801d88:	57                   	push   %edi
  801d89:	56                   	push   %esi
  801d8a:	53                   	push   %ebx
  801d8b:	83 ec 18             	sub    $0x18,%esp
  801d8e:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801d91:	57                   	push   %edi
  801d92:	e8 df f6 ff ff       	call   801476 <fd2data>
  801d97:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d99:	83 c4 10             	add    $0x10,%esp
  801d9c:	be 00 00 00 00       	mov    $0x0,%esi
  801da1:	3b 75 10             	cmp    0x10(%ebp),%esi
  801da4:	75 14                	jne    801dba <devpipe_read+0x35>
	return i;
  801da6:	8b 45 10             	mov    0x10(%ebp),%eax
  801da9:	eb 02                	jmp    801dad <devpipe_read+0x28>
				return i;
  801dab:	89 f0                	mov    %esi,%eax
}
  801dad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801db0:	5b                   	pop    %ebx
  801db1:	5e                   	pop    %esi
  801db2:	5f                   	pop    %edi
  801db3:	5d                   	pop    %ebp
  801db4:	c3                   	ret    
			sys_yield();
  801db5:	e8 3f f0 ff ff       	call   800df9 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801dba:	8b 03                	mov    (%ebx),%eax
  801dbc:	3b 43 04             	cmp    0x4(%ebx),%eax
  801dbf:	75 18                	jne    801dd9 <devpipe_read+0x54>
			if (i > 0)
  801dc1:	85 f6                	test   %esi,%esi
  801dc3:	75 e6                	jne    801dab <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801dc5:	89 da                	mov    %ebx,%edx
  801dc7:	89 f8                	mov    %edi,%eax
  801dc9:	e8 d0 fe ff ff       	call   801c9e <_pipeisclosed>
  801dce:	85 c0                	test   %eax,%eax
  801dd0:	74 e3                	je     801db5 <devpipe_read+0x30>
				return 0;
  801dd2:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd7:	eb d4                	jmp    801dad <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801dd9:	99                   	cltd   
  801dda:	c1 ea 1b             	shr    $0x1b,%edx
  801ddd:	01 d0                	add    %edx,%eax
  801ddf:	83 e0 1f             	and    $0x1f,%eax
  801de2:	29 d0                	sub    %edx,%eax
  801de4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801de9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dec:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801def:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801df2:	83 c6 01             	add    $0x1,%esi
  801df5:	eb aa                	jmp    801da1 <devpipe_read+0x1c>

00801df7 <pipe>:
{
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
  801dfa:	56                   	push   %esi
  801dfb:	53                   	push   %ebx
  801dfc:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801dff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e02:	50                   	push   %eax
  801e03:	e8 85 f6 ff ff       	call   80148d <fd_alloc>
  801e08:	89 c3                	mov    %eax,%ebx
  801e0a:	83 c4 10             	add    $0x10,%esp
  801e0d:	85 c0                	test   %eax,%eax
  801e0f:	0f 88 23 01 00 00    	js     801f38 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e15:	83 ec 04             	sub    $0x4,%esp
  801e18:	68 07 04 00 00       	push   $0x407
  801e1d:	ff 75 f4             	pushl  -0xc(%ebp)
  801e20:	6a 00                	push   $0x0
  801e22:	e8 f1 ef ff ff       	call   800e18 <sys_page_alloc>
  801e27:	89 c3                	mov    %eax,%ebx
  801e29:	83 c4 10             	add    $0x10,%esp
  801e2c:	85 c0                	test   %eax,%eax
  801e2e:	0f 88 04 01 00 00    	js     801f38 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801e34:	83 ec 0c             	sub    $0xc,%esp
  801e37:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e3a:	50                   	push   %eax
  801e3b:	e8 4d f6 ff ff       	call   80148d <fd_alloc>
  801e40:	89 c3                	mov    %eax,%ebx
  801e42:	83 c4 10             	add    $0x10,%esp
  801e45:	85 c0                	test   %eax,%eax
  801e47:	0f 88 db 00 00 00    	js     801f28 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e4d:	83 ec 04             	sub    $0x4,%esp
  801e50:	68 07 04 00 00       	push   $0x407
  801e55:	ff 75 f0             	pushl  -0x10(%ebp)
  801e58:	6a 00                	push   $0x0
  801e5a:	e8 b9 ef ff ff       	call   800e18 <sys_page_alloc>
  801e5f:	89 c3                	mov    %eax,%ebx
  801e61:	83 c4 10             	add    $0x10,%esp
  801e64:	85 c0                	test   %eax,%eax
  801e66:	0f 88 bc 00 00 00    	js     801f28 <pipe+0x131>
	va = fd2data(fd0);
  801e6c:	83 ec 0c             	sub    $0xc,%esp
  801e6f:	ff 75 f4             	pushl  -0xc(%ebp)
  801e72:	e8 ff f5 ff ff       	call   801476 <fd2data>
  801e77:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e79:	83 c4 0c             	add    $0xc,%esp
  801e7c:	68 07 04 00 00       	push   $0x407
  801e81:	50                   	push   %eax
  801e82:	6a 00                	push   $0x0
  801e84:	e8 8f ef ff ff       	call   800e18 <sys_page_alloc>
  801e89:	89 c3                	mov    %eax,%ebx
  801e8b:	83 c4 10             	add    $0x10,%esp
  801e8e:	85 c0                	test   %eax,%eax
  801e90:	0f 88 82 00 00 00    	js     801f18 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e96:	83 ec 0c             	sub    $0xc,%esp
  801e99:	ff 75 f0             	pushl  -0x10(%ebp)
  801e9c:	e8 d5 f5 ff ff       	call   801476 <fd2data>
  801ea1:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ea8:	50                   	push   %eax
  801ea9:	6a 00                	push   $0x0
  801eab:	56                   	push   %esi
  801eac:	6a 00                	push   $0x0
  801eae:	e8 a8 ef ff ff       	call   800e5b <sys_page_map>
  801eb3:	89 c3                	mov    %eax,%ebx
  801eb5:	83 c4 20             	add    $0x20,%esp
  801eb8:	85 c0                	test   %eax,%eax
  801eba:	78 4e                	js     801f0a <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801ebc:	a1 20 30 80 00       	mov    0x803020,%eax
  801ec1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ec4:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801ec6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ec9:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801ed0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ed3:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801ed5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed8:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801edf:	83 ec 0c             	sub    $0xc,%esp
  801ee2:	ff 75 f4             	pushl  -0xc(%ebp)
  801ee5:	e8 7c f5 ff ff       	call   801466 <fd2num>
  801eea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801eed:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801eef:	83 c4 04             	add    $0x4,%esp
  801ef2:	ff 75 f0             	pushl  -0x10(%ebp)
  801ef5:	e8 6c f5 ff ff       	call   801466 <fd2num>
  801efa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801efd:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f00:	83 c4 10             	add    $0x10,%esp
  801f03:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f08:	eb 2e                	jmp    801f38 <pipe+0x141>
	sys_page_unmap(0, va);
  801f0a:	83 ec 08             	sub    $0x8,%esp
  801f0d:	56                   	push   %esi
  801f0e:	6a 00                	push   $0x0
  801f10:	e8 88 ef ff ff       	call   800e9d <sys_page_unmap>
  801f15:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f18:	83 ec 08             	sub    $0x8,%esp
  801f1b:	ff 75 f0             	pushl  -0x10(%ebp)
  801f1e:	6a 00                	push   $0x0
  801f20:	e8 78 ef ff ff       	call   800e9d <sys_page_unmap>
  801f25:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f28:	83 ec 08             	sub    $0x8,%esp
  801f2b:	ff 75 f4             	pushl  -0xc(%ebp)
  801f2e:	6a 00                	push   $0x0
  801f30:	e8 68 ef ff ff       	call   800e9d <sys_page_unmap>
  801f35:	83 c4 10             	add    $0x10,%esp
}
  801f38:	89 d8                	mov    %ebx,%eax
  801f3a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f3d:	5b                   	pop    %ebx
  801f3e:	5e                   	pop    %esi
  801f3f:	5d                   	pop    %ebp
  801f40:	c3                   	ret    

00801f41 <pipeisclosed>:
{
  801f41:	55                   	push   %ebp
  801f42:	89 e5                	mov    %esp,%ebp
  801f44:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f47:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f4a:	50                   	push   %eax
  801f4b:	ff 75 08             	pushl  0x8(%ebp)
  801f4e:	e8 8c f5 ff ff       	call   8014df <fd_lookup>
  801f53:	83 c4 10             	add    $0x10,%esp
  801f56:	85 c0                	test   %eax,%eax
  801f58:	78 18                	js     801f72 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f5a:	83 ec 0c             	sub    $0xc,%esp
  801f5d:	ff 75 f4             	pushl  -0xc(%ebp)
  801f60:	e8 11 f5 ff ff       	call   801476 <fd2data>
	return _pipeisclosed(fd, p);
  801f65:	89 c2                	mov    %eax,%edx
  801f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6a:	e8 2f fd ff ff       	call   801c9e <_pipeisclosed>
  801f6f:	83 c4 10             	add    $0x10,%esp
}
  801f72:	c9                   	leave  
  801f73:	c3                   	ret    

00801f74 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  801f74:	55                   	push   %ebp
  801f75:	89 e5                	mov    %esp,%ebp
  801f77:	56                   	push   %esi
  801f78:	53                   	push   %ebx
  801f79:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  801f7c:	85 f6                	test   %esi,%esi
  801f7e:	74 16                	je     801f96 <wait+0x22>
	e = &envs[ENVX(envid)];
  801f80:	89 f3                	mov    %esi,%ebx
  801f82:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801f88:	69 db 84 00 00 00    	imul   $0x84,%ebx,%ebx
  801f8e:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  801f94:	eb 1b                	jmp    801fb1 <wait+0x3d>
	assert(envid != 0);
  801f96:	68 4c 2d 80 00       	push   $0x802d4c
  801f9b:	68 0c 2d 80 00       	push   $0x802d0c
  801fa0:	6a 09                	push   $0x9
  801fa2:	68 57 2d 80 00       	push   $0x802d57
  801fa7:	e8 79 e2 ff ff       	call   800225 <_panic>
		sys_yield();
  801fac:	e8 48 ee ff ff       	call   800df9 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801fb1:	8b 43 48             	mov    0x48(%ebx),%eax
  801fb4:	39 f0                	cmp    %esi,%eax
  801fb6:	75 07                	jne    801fbf <wait+0x4b>
  801fb8:	8b 43 54             	mov    0x54(%ebx),%eax
  801fbb:	85 c0                	test   %eax,%eax
  801fbd:	75 ed                	jne    801fac <wait+0x38>
}
  801fbf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fc2:	5b                   	pop    %ebx
  801fc3:	5e                   	pop    %esi
  801fc4:	5d                   	pop    %ebp
  801fc5:	c3                   	ret    

00801fc6 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801fc6:	b8 00 00 00 00       	mov    $0x0,%eax
  801fcb:	c3                   	ret    

00801fcc <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801fcc:	55                   	push   %ebp
  801fcd:	89 e5                	mov    %esp,%ebp
  801fcf:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801fd2:	68 62 2d 80 00       	push   $0x802d62
  801fd7:	ff 75 0c             	pushl  0xc(%ebp)
  801fda:	e8 47 ea ff ff       	call   800a26 <strcpy>
	return 0;
}
  801fdf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe4:	c9                   	leave  
  801fe5:	c3                   	ret    

00801fe6 <devcons_write>:
{
  801fe6:	55                   	push   %ebp
  801fe7:	89 e5                	mov    %esp,%ebp
  801fe9:	57                   	push   %edi
  801fea:	56                   	push   %esi
  801feb:	53                   	push   %ebx
  801fec:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801ff2:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801ff7:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801ffd:	3b 75 10             	cmp    0x10(%ebp),%esi
  802000:	73 31                	jae    802033 <devcons_write+0x4d>
		m = n - tot;
  802002:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802005:	29 f3                	sub    %esi,%ebx
  802007:	83 fb 7f             	cmp    $0x7f,%ebx
  80200a:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80200f:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802012:	83 ec 04             	sub    $0x4,%esp
  802015:	53                   	push   %ebx
  802016:	89 f0                	mov    %esi,%eax
  802018:	03 45 0c             	add    0xc(%ebp),%eax
  80201b:	50                   	push   %eax
  80201c:	57                   	push   %edi
  80201d:	e8 92 eb ff ff       	call   800bb4 <memmove>
		sys_cputs(buf, m);
  802022:	83 c4 08             	add    $0x8,%esp
  802025:	53                   	push   %ebx
  802026:	57                   	push   %edi
  802027:	e8 30 ed ff ff       	call   800d5c <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80202c:	01 de                	add    %ebx,%esi
  80202e:	83 c4 10             	add    $0x10,%esp
  802031:	eb ca                	jmp    801ffd <devcons_write+0x17>
}
  802033:	89 f0                	mov    %esi,%eax
  802035:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802038:	5b                   	pop    %ebx
  802039:	5e                   	pop    %esi
  80203a:	5f                   	pop    %edi
  80203b:	5d                   	pop    %ebp
  80203c:	c3                   	ret    

0080203d <devcons_read>:
{
  80203d:	55                   	push   %ebp
  80203e:	89 e5                	mov    %esp,%ebp
  802040:	83 ec 08             	sub    $0x8,%esp
  802043:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802048:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80204c:	74 21                	je     80206f <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80204e:	e8 27 ed ff ff       	call   800d7a <sys_cgetc>
  802053:	85 c0                	test   %eax,%eax
  802055:	75 07                	jne    80205e <devcons_read+0x21>
		sys_yield();
  802057:	e8 9d ed ff ff       	call   800df9 <sys_yield>
  80205c:	eb f0                	jmp    80204e <devcons_read+0x11>
	if (c < 0)
  80205e:	78 0f                	js     80206f <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802060:	83 f8 04             	cmp    $0x4,%eax
  802063:	74 0c                	je     802071 <devcons_read+0x34>
	*(char*)vbuf = c;
  802065:	8b 55 0c             	mov    0xc(%ebp),%edx
  802068:	88 02                	mov    %al,(%edx)
	return 1;
  80206a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80206f:	c9                   	leave  
  802070:	c3                   	ret    
		return 0;
  802071:	b8 00 00 00 00       	mov    $0x0,%eax
  802076:	eb f7                	jmp    80206f <devcons_read+0x32>

00802078 <cputchar>:
{
  802078:	55                   	push   %ebp
  802079:	89 e5                	mov    %esp,%ebp
  80207b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80207e:	8b 45 08             	mov    0x8(%ebp),%eax
  802081:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802084:	6a 01                	push   $0x1
  802086:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802089:	50                   	push   %eax
  80208a:	e8 cd ec ff ff       	call   800d5c <sys_cputs>
}
  80208f:	83 c4 10             	add    $0x10,%esp
  802092:	c9                   	leave  
  802093:	c3                   	ret    

00802094 <getchar>:
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
  802097:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80209a:	6a 01                	push   $0x1
  80209c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80209f:	50                   	push   %eax
  8020a0:	6a 00                	push   $0x0
  8020a2:	e8 a3 f6 ff ff       	call   80174a <read>
	if (r < 0)
  8020a7:	83 c4 10             	add    $0x10,%esp
  8020aa:	85 c0                	test   %eax,%eax
  8020ac:	78 06                	js     8020b4 <getchar+0x20>
	if (r < 1)
  8020ae:	74 06                	je     8020b6 <getchar+0x22>
	return c;
  8020b0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020b4:	c9                   	leave  
  8020b5:	c3                   	ret    
		return -E_EOF;
  8020b6:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020bb:	eb f7                	jmp    8020b4 <getchar+0x20>

008020bd <iscons>:
{
  8020bd:	55                   	push   %ebp
  8020be:	89 e5                	mov    %esp,%ebp
  8020c0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020c6:	50                   	push   %eax
  8020c7:	ff 75 08             	pushl  0x8(%ebp)
  8020ca:	e8 10 f4 ff ff       	call   8014df <fd_lookup>
  8020cf:	83 c4 10             	add    $0x10,%esp
  8020d2:	85 c0                	test   %eax,%eax
  8020d4:	78 11                	js     8020e7 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8020d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020df:	39 10                	cmp    %edx,(%eax)
  8020e1:	0f 94 c0             	sete   %al
  8020e4:	0f b6 c0             	movzbl %al,%eax
}
  8020e7:	c9                   	leave  
  8020e8:	c3                   	ret    

008020e9 <opencons>:
{
  8020e9:	55                   	push   %ebp
  8020ea:	89 e5                	mov    %esp,%ebp
  8020ec:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020f2:	50                   	push   %eax
  8020f3:	e8 95 f3 ff ff       	call   80148d <fd_alloc>
  8020f8:	83 c4 10             	add    $0x10,%esp
  8020fb:	85 c0                	test   %eax,%eax
  8020fd:	78 3a                	js     802139 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020ff:	83 ec 04             	sub    $0x4,%esp
  802102:	68 07 04 00 00       	push   $0x407
  802107:	ff 75 f4             	pushl  -0xc(%ebp)
  80210a:	6a 00                	push   $0x0
  80210c:	e8 07 ed ff ff       	call   800e18 <sys_page_alloc>
  802111:	83 c4 10             	add    $0x10,%esp
  802114:	85 c0                	test   %eax,%eax
  802116:	78 21                	js     802139 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802118:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802121:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802123:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802126:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80212d:	83 ec 0c             	sub    $0xc,%esp
  802130:	50                   	push   %eax
  802131:	e8 30 f3 ff ff       	call   801466 <fd2num>
  802136:	83 c4 10             	add    $0x10,%esp
}
  802139:	c9                   	leave  
  80213a:	c3                   	ret    

0080213b <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
  80213e:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802141:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  802148:	74 0a                	je     802154 <set_pgfault_handler+0x19>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80214a:	8b 45 08             	mov    0x8(%ebp),%eax
  80214d:	a3 00 60 80 00       	mov    %eax,0x806000
}
  802152:	c9                   	leave  
  802153:	c3                   	ret    
		ret = sys_page_alloc((envid_t)0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W);
  802154:	83 ec 04             	sub    $0x4,%esp
  802157:	6a 07                	push   $0x7
  802159:	68 00 f0 bf ee       	push   $0xeebff000
  80215e:	6a 00                	push   $0x0
  802160:	e8 b3 ec ff ff       	call   800e18 <sys_page_alloc>
		if(ret < 0){
  802165:	83 c4 10             	add    $0x10,%esp
  802168:	85 c0                	test   %eax,%eax
  80216a:	78 28                	js     802194 <set_pgfault_handler+0x59>
    	ret = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80216c:	83 ec 08             	sub    $0x8,%esp
  80216f:	68 a6 21 80 00       	push   $0x8021a6
  802174:	6a 00                	push   $0x0
  802176:	e8 e8 ed ff ff       	call   800f63 <sys_env_set_pgfault_upcall>
		if(ret < 0){
  80217b:	83 c4 10             	add    $0x10,%esp
  80217e:	85 c0                	test   %eax,%eax
  802180:	79 c8                	jns    80214a <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
  802182:	50                   	push   %eax
  802183:	68 a4 2d 80 00       	push   $0x802da4
  802188:	6a 28                	push   $0x28
  80218a:	68 e4 2d 80 00       	push   $0x802de4
  80218f:	e8 91 e0 ff ff       	call   800225 <_panic>
			panic("set_pgfault_handler: sys_page_alloc fail, ret:%d", ret);
  802194:	50                   	push   %eax
  802195:	68 70 2d 80 00       	push   $0x802d70
  80219a:	6a 24                	push   $0x24
  80219c:	68 e4 2d 80 00       	push   $0x802de4
  8021a1:	e8 7f e0 ff ff       	call   800225 <_panic>

008021a6 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8021a6:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8021a7:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  8021ac:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8021ae:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edi
  8021b1:	8b 7c 24 28          	mov    0x28(%esp),%edi
	movl 0x30(%esp), %esi
  8021b5:	8b 74 24 30          	mov    0x30(%esp),%esi
	subl $4, %esi
  8021b9:	83 ee 04             	sub    $0x4,%esi
	movl %edi, (%esi)
  8021bc:	89 3e                	mov    %edi,(%esi)
	movl %esi, 0x30(%esp)
  8021be:	89 74 24 30          	mov    %esi,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  8021c2:	83 c4 08             	add    $0x8,%esp
	popal
  8021c5:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8021c6:	83 c4 04             	add    $0x4,%esp
	popfl
  8021c9:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8021ca:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8021cb:	c3                   	ret    

008021cc <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021cc:	55                   	push   %ebp
  8021cd:	89 e5                	mov    %esp,%ebp
  8021cf:	56                   	push   %esi
  8021d0:	53                   	push   %ebx
  8021d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8021d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d7:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// return 0;
	if(!pg)
  8021da:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  8021dc:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021e1:	0f 44 c2             	cmove  %edx,%eax
	
	int ret;

	ret = sys_ipc_recv(pg);
  8021e4:	83 ec 0c             	sub    $0xc,%esp
  8021e7:	50                   	push   %eax
  8021e8:	e8 db ed ff ff       	call   800fc8 <sys_ipc_recv>
	if(ret < 0){
  8021ed:	83 c4 10             	add    $0x10,%esp
  8021f0:	85 c0                	test   %eax,%eax
  8021f2:	78 2b                	js     80221f <ipc_recv+0x53>
		if(perm_store) *perm_store = 0;
		if(from_env_store) *from_env_store = 0;
		return ret;
	}
	
	if(perm_store)
  8021f4:	85 f6                	test   %esi,%esi
  8021f6:	74 0a                	je     802202 <ipc_recv+0x36>
		*perm_store = thisenv->env_ipc_perm;
  8021f8:	a1 20 44 80 00       	mov    0x804420,%eax
  8021fd:	8b 40 78             	mov    0x78(%eax),%eax
  802200:	89 06                	mov    %eax,(%esi)
	if(from_env_store)
  802202:	85 db                	test   %ebx,%ebx
  802204:	74 0a                	je     802210 <ipc_recv+0x44>
		*from_env_store = thisenv->env_ipc_from;
  802206:	a1 20 44 80 00       	mov    0x804420,%eax
  80220b:	8b 40 74             	mov    0x74(%eax),%eax
  80220e:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  802210:	a1 20 44 80 00       	mov    0x804420,%eax
  802215:	8b 40 70             	mov    0x70(%eax),%eax
}
  802218:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80221b:	5b                   	pop    %ebx
  80221c:	5e                   	pop    %esi
  80221d:	5d                   	pop    %ebp
  80221e:	c3                   	ret    
		if(perm_store) *perm_store = 0;
  80221f:	85 f6                	test   %esi,%esi
  802221:	74 06                	je     802229 <ipc_recv+0x5d>
  802223:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(from_env_store) *from_env_store = 0;
  802229:	85 db                	test   %ebx,%ebx
  80222b:	74 eb                	je     802218 <ipc_recv+0x4c>
  80222d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802233:	eb e3                	jmp    802218 <ipc_recv+0x4c>

00802235 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802235:	55                   	push   %ebp
  802236:	89 e5                	mov    %esp,%ebp
  802238:	57                   	push   %edi
  802239:	56                   	push   %esi
  80223a:	53                   	push   %ebx
  80223b:	83 ec 0c             	sub    $0xc,%esp
  80223e:	8b 7d 08             	mov    0x8(%ebp),%edi
  802241:	8b 75 0c             	mov    0xc(%ebp),%esi
  802244:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
	if (!pg)
  802247:	85 db                	test   %ebx,%ebx
		pg = (void*)UTOP;
  802249:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80224e:	0f 44 d8             	cmove  %eax,%ebx

	int ret = -E_IPC_NOT_RECV;
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))) {
  802251:	ff 75 14             	pushl  0x14(%ebp)
  802254:	53                   	push   %ebx
  802255:	56                   	push   %esi
  802256:	57                   	push   %edi
  802257:	e8 49 ed ff ff       	call   800fa5 <sys_ipc_try_send>
  80225c:	83 c4 10             	add    $0x10,%esp
  80225f:	85 c0                	test   %eax,%eax
  802261:	74 17                	je     80227a <ipc_send+0x45>
		if(ret != -E_IPC_NOT_RECV){
  802263:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802266:	74 e9                	je     802251 <ipc_send+0x1c>
			panic("ipc_send: ret : %d", ret);
  802268:	50                   	push   %eax
  802269:	68 f2 2d 80 00       	push   $0x802df2
  80226e:	6a 43                	push   $0x43
  802270:	68 05 2e 80 00       	push   $0x802e05
  802275:	e8 ab df ff ff       	call   800225 <_panic>
			sys_yield();
		}
	}
}
  80227a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80227d:	5b                   	pop    %ebx
  80227e:	5e                   	pop    %esi
  80227f:	5f                   	pop    %edi
  802280:	5d                   	pop    %ebp
  802281:	c3                   	ret    

00802282 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802282:	55                   	push   %ebp
  802283:	89 e5                	mov    %esp,%ebp
  802285:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802288:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80228d:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802293:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802299:	8b 52 50             	mov    0x50(%edx),%edx
  80229c:	39 ca                	cmp    %ecx,%edx
  80229e:	74 11                	je     8022b1 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8022a0:	83 c0 01             	add    $0x1,%eax
  8022a3:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022a8:	75 e3                	jne    80228d <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8022af:	eb 0e                	jmp    8022bf <ipc_find_env+0x3d>
			return envs[i].env_id;
  8022b1:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8022b7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022bc:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022bf:	5d                   	pop    %ebp
  8022c0:	c3                   	ret    

008022c1 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022c1:	55                   	push   %ebp
  8022c2:	89 e5                	mov    %esp,%ebp
  8022c4:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022c7:	89 d0                	mov    %edx,%eax
  8022c9:	c1 e8 16             	shr    $0x16,%eax
  8022cc:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8022d3:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8022d8:	f6 c1 01             	test   $0x1,%cl
  8022db:	74 1d                	je     8022fa <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8022dd:	c1 ea 0c             	shr    $0xc,%edx
  8022e0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8022e7:	f6 c2 01             	test   $0x1,%dl
  8022ea:	74 0e                	je     8022fa <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022ec:	c1 ea 0c             	shr    $0xc,%edx
  8022ef:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8022f6:	ef 
  8022f7:	0f b7 c0             	movzwl %ax,%eax
}
  8022fa:	5d                   	pop    %ebp
  8022fb:	c3                   	ret    
  8022fc:	66 90                	xchg   %ax,%ax
  8022fe:	66 90                	xchg   %ax,%ax

00802300 <__udivdi3>:
  802300:	55                   	push   %ebp
  802301:	57                   	push   %edi
  802302:	56                   	push   %esi
  802303:	53                   	push   %ebx
  802304:	83 ec 1c             	sub    $0x1c,%esp
  802307:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80230b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80230f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802313:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802317:	85 d2                	test   %edx,%edx
  802319:	75 4d                	jne    802368 <__udivdi3+0x68>
  80231b:	39 f3                	cmp    %esi,%ebx
  80231d:	76 19                	jbe    802338 <__udivdi3+0x38>
  80231f:	31 ff                	xor    %edi,%edi
  802321:	89 e8                	mov    %ebp,%eax
  802323:	89 f2                	mov    %esi,%edx
  802325:	f7 f3                	div    %ebx
  802327:	89 fa                	mov    %edi,%edx
  802329:	83 c4 1c             	add    $0x1c,%esp
  80232c:	5b                   	pop    %ebx
  80232d:	5e                   	pop    %esi
  80232e:	5f                   	pop    %edi
  80232f:	5d                   	pop    %ebp
  802330:	c3                   	ret    
  802331:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802338:	89 d9                	mov    %ebx,%ecx
  80233a:	85 db                	test   %ebx,%ebx
  80233c:	75 0b                	jne    802349 <__udivdi3+0x49>
  80233e:	b8 01 00 00 00       	mov    $0x1,%eax
  802343:	31 d2                	xor    %edx,%edx
  802345:	f7 f3                	div    %ebx
  802347:	89 c1                	mov    %eax,%ecx
  802349:	31 d2                	xor    %edx,%edx
  80234b:	89 f0                	mov    %esi,%eax
  80234d:	f7 f1                	div    %ecx
  80234f:	89 c6                	mov    %eax,%esi
  802351:	89 e8                	mov    %ebp,%eax
  802353:	89 f7                	mov    %esi,%edi
  802355:	f7 f1                	div    %ecx
  802357:	89 fa                	mov    %edi,%edx
  802359:	83 c4 1c             	add    $0x1c,%esp
  80235c:	5b                   	pop    %ebx
  80235d:	5e                   	pop    %esi
  80235e:	5f                   	pop    %edi
  80235f:	5d                   	pop    %ebp
  802360:	c3                   	ret    
  802361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802368:	39 f2                	cmp    %esi,%edx
  80236a:	77 1c                	ja     802388 <__udivdi3+0x88>
  80236c:	0f bd fa             	bsr    %edx,%edi
  80236f:	83 f7 1f             	xor    $0x1f,%edi
  802372:	75 2c                	jne    8023a0 <__udivdi3+0xa0>
  802374:	39 f2                	cmp    %esi,%edx
  802376:	72 06                	jb     80237e <__udivdi3+0x7e>
  802378:	31 c0                	xor    %eax,%eax
  80237a:	39 eb                	cmp    %ebp,%ebx
  80237c:	77 a9                	ja     802327 <__udivdi3+0x27>
  80237e:	b8 01 00 00 00       	mov    $0x1,%eax
  802383:	eb a2                	jmp    802327 <__udivdi3+0x27>
  802385:	8d 76 00             	lea    0x0(%esi),%esi
  802388:	31 ff                	xor    %edi,%edi
  80238a:	31 c0                	xor    %eax,%eax
  80238c:	89 fa                	mov    %edi,%edx
  80238e:	83 c4 1c             	add    $0x1c,%esp
  802391:	5b                   	pop    %ebx
  802392:	5e                   	pop    %esi
  802393:	5f                   	pop    %edi
  802394:	5d                   	pop    %ebp
  802395:	c3                   	ret    
  802396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80239d:	8d 76 00             	lea    0x0(%esi),%esi
  8023a0:	89 f9                	mov    %edi,%ecx
  8023a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8023a7:	29 f8                	sub    %edi,%eax
  8023a9:	d3 e2                	shl    %cl,%edx
  8023ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023af:	89 c1                	mov    %eax,%ecx
  8023b1:	89 da                	mov    %ebx,%edx
  8023b3:	d3 ea                	shr    %cl,%edx
  8023b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023b9:	09 d1                	or     %edx,%ecx
  8023bb:	89 f2                	mov    %esi,%edx
  8023bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023c1:	89 f9                	mov    %edi,%ecx
  8023c3:	d3 e3                	shl    %cl,%ebx
  8023c5:	89 c1                	mov    %eax,%ecx
  8023c7:	d3 ea                	shr    %cl,%edx
  8023c9:	89 f9                	mov    %edi,%ecx
  8023cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8023cf:	89 eb                	mov    %ebp,%ebx
  8023d1:	d3 e6                	shl    %cl,%esi
  8023d3:	89 c1                	mov    %eax,%ecx
  8023d5:	d3 eb                	shr    %cl,%ebx
  8023d7:	09 de                	or     %ebx,%esi
  8023d9:	89 f0                	mov    %esi,%eax
  8023db:	f7 74 24 08          	divl   0x8(%esp)
  8023df:	89 d6                	mov    %edx,%esi
  8023e1:	89 c3                	mov    %eax,%ebx
  8023e3:	f7 64 24 0c          	mull   0xc(%esp)
  8023e7:	39 d6                	cmp    %edx,%esi
  8023e9:	72 15                	jb     802400 <__udivdi3+0x100>
  8023eb:	89 f9                	mov    %edi,%ecx
  8023ed:	d3 e5                	shl    %cl,%ebp
  8023ef:	39 c5                	cmp    %eax,%ebp
  8023f1:	73 04                	jae    8023f7 <__udivdi3+0xf7>
  8023f3:	39 d6                	cmp    %edx,%esi
  8023f5:	74 09                	je     802400 <__udivdi3+0x100>
  8023f7:	89 d8                	mov    %ebx,%eax
  8023f9:	31 ff                	xor    %edi,%edi
  8023fb:	e9 27 ff ff ff       	jmp    802327 <__udivdi3+0x27>
  802400:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802403:	31 ff                	xor    %edi,%edi
  802405:	e9 1d ff ff ff       	jmp    802327 <__udivdi3+0x27>
  80240a:	66 90                	xchg   %ax,%ax
  80240c:	66 90                	xchg   %ax,%ax
  80240e:	66 90                	xchg   %ax,%ax

00802410 <__umoddi3>:
  802410:	55                   	push   %ebp
  802411:	57                   	push   %edi
  802412:	56                   	push   %esi
  802413:	53                   	push   %ebx
  802414:	83 ec 1c             	sub    $0x1c,%esp
  802417:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80241b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80241f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802423:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802427:	89 da                	mov    %ebx,%edx
  802429:	85 c0                	test   %eax,%eax
  80242b:	75 43                	jne    802470 <__umoddi3+0x60>
  80242d:	39 df                	cmp    %ebx,%edi
  80242f:	76 17                	jbe    802448 <__umoddi3+0x38>
  802431:	89 f0                	mov    %esi,%eax
  802433:	f7 f7                	div    %edi
  802435:	89 d0                	mov    %edx,%eax
  802437:	31 d2                	xor    %edx,%edx
  802439:	83 c4 1c             	add    $0x1c,%esp
  80243c:	5b                   	pop    %ebx
  80243d:	5e                   	pop    %esi
  80243e:	5f                   	pop    %edi
  80243f:	5d                   	pop    %ebp
  802440:	c3                   	ret    
  802441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802448:	89 fd                	mov    %edi,%ebp
  80244a:	85 ff                	test   %edi,%edi
  80244c:	75 0b                	jne    802459 <__umoddi3+0x49>
  80244e:	b8 01 00 00 00       	mov    $0x1,%eax
  802453:	31 d2                	xor    %edx,%edx
  802455:	f7 f7                	div    %edi
  802457:	89 c5                	mov    %eax,%ebp
  802459:	89 d8                	mov    %ebx,%eax
  80245b:	31 d2                	xor    %edx,%edx
  80245d:	f7 f5                	div    %ebp
  80245f:	89 f0                	mov    %esi,%eax
  802461:	f7 f5                	div    %ebp
  802463:	89 d0                	mov    %edx,%eax
  802465:	eb d0                	jmp    802437 <__umoddi3+0x27>
  802467:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80246e:	66 90                	xchg   %ax,%ax
  802470:	89 f1                	mov    %esi,%ecx
  802472:	39 d8                	cmp    %ebx,%eax
  802474:	76 0a                	jbe    802480 <__umoddi3+0x70>
  802476:	89 f0                	mov    %esi,%eax
  802478:	83 c4 1c             	add    $0x1c,%esp
  80247b:	5b                   	pop    %ebx
  80247c:	5e                   	pop    %esi
  80247d:	5f                   	pop    %edi
  80247e:	5d                   	pop    %ebp
  80247f:	c3                   	ret    
  802480:	0f bd e8             	bsr    %eax,%ebp
  802483:	83 f5 1f             	xor    $0x1f,%ebp
  802486:	75 20                	jne    8024a8 <__umoddi3+0x98>
  802488:	39 d8                	cmp    %ebx,%eax
  80248a:	0f 82 b0 00 00 00    	jb     802540 <__umoddi3+0x130>
  802490:	39 f7                	cmp    %esi,%edi
  802492:	0f 86 a8 00 00 00    	jbe    802540 <__umoddi3+0x130>
  802498:	89 c8                	mov    %ecx,%eax
  80249a:	83 c4 1c             	add    $0x1c,%esp
  80249d:	5b                   	pop    %ebx
  80249e:	5e                   	pop    %esi
  80249f:	5f                   	pop    %edi
  8024a0:	5d                   	pop    %ebp
  8024a1:	c3                   	ret    
  8024a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024a8:	89 e9                	mov    %ebp,%ecx
  8024aa:	ba 20 00 00 00       	mov    $0x20,%edx
  8024af:	29 ea                	sub    %ebp,%edx
  8024b1:	d3 e0                	shl    %cl,%eax
  8024b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024b7:	89 d1                	mov    %edx,%ecx
  8024b9:	89 f8                	mov    %edi,%eax
  8024bb:	d3 e8                	shr    %cl,%eax
  8024bd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024c5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024c9:	09 c1                	or     %eax,%ecx
  8024cb:	89 d8                	mov    %ebx,%eax
  8024cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024d1:	89 e9                	mov    %ebp,%ecx
  8024d3:	d3 e7                	shl    %cl,%edi
  8024d5:	89 d1                	mov    %edx,%ecx
  8024d7:	d3 e8                	shr    %cl,%eax
  8024d9:	89 e9                	mov    %ebp,%ecx
  8024db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024df:	d3 e3                	shl    %cl,%ebx
  8024e1:	89 c7                	mov    %eax,%edi
  8024e3:	89 d1                	mov    %edx,%ecx
  8024e5:	89 f0                	mov    %esi,%eax
  8024e7:	d3 e8                	shr    %cl,%eax
  8024e9:	89 e9                	mov    %ebp,%ecx
  8024eb:	89 fa                	mov    %edi,%edx
  8024ed:	d3 e6                	shl    %cl,%esi
  8024ef:	09 d8                	or     %ebx,%eax
  8024f1:	f7 74 24 08          	divl   0x8(%esp)
  8024f5:	89 d1                	mov    %edx,%ecx
  8024f7:	89 f3                	mov    %esi,%ebx
  8024f9:	f7 64 24 0c          	mull   0xc(%esp)
  8024fd:	89 c6                	mov    %eax,%esi
  8024ff:	89 d7                	mov    %edx,%edi
  802501:	39 d1                	cmp    %edx,%ecx
  802503:	72 06                	jb     80250b <__umoddi3+0xfb>
  802505:	75 10                	jne    802517 <__umoddi3+0x107>
  802507:	39 c3                	cmp    %eax,%ebx
  802509:	73 0c                	jae    802517 <__umoddi3+0x107>
  80250b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80250f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802513:	89 d7                	mov    %edx,%edi
  802515:	89 c6                	mov    %eax,%esi
  802517:	89 ca                	mov    %ecx,%edx
  802519:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80251e:	29 f3                	sub    %esi,%ebx
  802520:	19 fa                	sbb    %edi,%edx
  802522:	89 d0                	mov    %edx,%eax
  802524:	d3 e0                	shl    %cl,%eax
  802526:	89 e9                	mov    %ebp,%ecx
  802528:	d3 eb                	shr    %cl,%ebx
  80252a:	d3 ea                	shr    %cl,%edx
  80252c:	09 d8                	or     %ebx,%eax
  80252e:	83 c4 1c             	add    $0x1c,%esp
  802531:	5b                   	pop    %ebx
  802532:	5e                   	pop    %esi
  802533:	5f                   	pop    %edi
  802534:	5d                   	pop    %ebp
  802535:	c3                   	ret    
  802536:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80253d:	8d 76 00             	lea    0x0(%esi),%esi
  802540:	89 da                	mov    %ebx,%edx
  802542:	29 fe                	sub    %edi,%esi
  802544:	19 c2                	sbb    %eax,%edx
  802546:	89 f1                	mov    %esi,%ecx
  802548:	89 c8                	mov    %ecx,%eax
  80254a:	e9 4b ff ff ff       	jmp    80249a <__umoddi3+0x8a>
