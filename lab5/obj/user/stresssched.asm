
obj/user/stresssched.debug:     file format elf32-i386


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
  80002c:	e8 b5 00 00 00       	call   8000e6 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

volatile int counter;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();
  800038:	e8 b9 0c 00 00       	call   800cf6 <sys_getenvid>
  80003d:	89 c6                	mov    %eax,%esi

	// Fork several environments
	for (i = 0; i < 20; i++)
  80003f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fork() == 0)
  800044:	e8 19 10 00 00       	call   801062 <fork>
  800049:	85 c0                	test   %eax,%eax
  80004b:	74 0f                	je     80005c <umain+0x29>
	for (i = 0; i < 20; i++)
  80004d:	83 c3 01             	add    $0x1,%ebx
  800050:	83 fb 14             	cmp    $0x14,%ebx
  800053:	75 ef                	jne    800044 <umain+0x11>
			break;
	if (i == 20) {
		sys_yield();
  800055:	e8 bb 0c 00 00       	call   800d15 <sys_yield>
		return;
  80005a:	eb 6c                	jmp    8000c8 <umain+0x95>
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  80005c:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  800062:	69 d6 84 00 00 00    	imul   $0x84,%esi,%edx
  800068:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80006e:	eb 02                	jmp    800072 <umain+0x3f>
		asm volatile("pause");
  800070:	f3 90                	pause  
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  800072:	8b 42 54             	mov    0x54(%edx),%eax
  800075:	85 c0                	test   %eax,%eax
  800077:	75 f7                	jne    800070 <umain+0x3d>
  800079:	bb 0a 00 00 00       	mov    $0xa,%ebx

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
  80007e:	e8 92 0c 00 00       	call   800d15 <sys_yield>
  800083:	ba 10 27 00 00       	mov    $0x2710,%edx
		for (j = 0; j < 10000; j++)
			counter++;
  800088:	a1 04 20 80 00       	mov    0x802004,%eax
  80008d:	83 c0 01             	add    $0x1,%eax
  800090:	a3 04 20 80 00       	mov    %eax,0x802004
		for (j = 0; j < 10000; j++)
  800095:	83 ea 01             	sub    $0x1,%edx
  800098:	75 ee                	jne    800088 <umain+0x55>
	for (i = 0; i < 10; i++) {
  80009a:	83 eb 01             	sub    $0x1,%ebx
  80009d:	75 df                	jne    80007e <umain+0x4b>
	}

	if (counter != 10*10000)
  80009f:	a1 04 20 80 00       	mov    0x802004,%eax
  8000a4:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  8000a9:	75 24                	jne    8000cf <umain+0x9c>
		panic("ran on two CPUs at once (counter is %d)", counter);

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  8000ab:	a1 08 20 80 00       	mov    0x802008,%eax
  8000b0:	8b 50 5c             	mov    0x5c(%eax),%edx
  8000b3:	8b 40 48             	mov    0x48(%eax),%eax
  8000b6:	83 ec 04             	sub    $0x4,%esp
  8000b9:	52                   	push   %edx
  8000ba:	50                   	push   %eax
  8000bb:	68 bb 16 80 00       	push   $0x8016bb
  8000c0:	e8 57 01 00 00       	call   80021c <cprintf>
  8000c5:	83 c4 10             	add    $0x10,%esp

}
  8000c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000cb:	5b                   	pop    %ebx
  8000cc:	5e                   	pop    %esi
  8000cd:	5d                   	pop    %ebp
  8000ce:	c3                   	ret    
		panic("ran on two CPUs at once (counter is %d)", counter);
  8000cf:	a1 04 20 80 00       	mov    0x802004,%eax
  8000d4:	50                   	push   %eax
  8000d5:	68 80 16 80 00       	push   $0x801680
  8000da:	6a 21                	push   $0x21
  8000dc:	68 a8 16 80 00       	push   $0x8016a8
  8000e1:	e8 5b 00 00 00       	call   800141 <_panic>

008000e6 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e6:	55                   	push   %ebp
  8000e7:	89 e5                	mov    %esp,%ebp
  8000e9:	56                   	push   %esi
  8000ea:	53                   	push   %ebx
  8000eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000ee:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  8000f1:	e8 00 0c 00 00       	call   800cf6 <sys_getenvid>
  8000f6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000fb:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  800101:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800106:	a3 08 20 80 00       	mov    %eax,0x802008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80010b:	85 db                	test   %ebx,%ebx
  80010d:	7e 07                	jle    800116 <libmain+0x30>
		binaryname = argv[0];
  80010f:	8b 06                	mov    (%esi),%eax
  800111:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800116:	83 ec 08             	sub    $0x8,%esp
  800119:	56                   	push   %esi
  80011a:	53                   	push   %ebx
  80011b:	e8 13 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800120:	e8 0a 00 00 00       	call   80012f <exit>
}
  800125:	83 c4 10             	add    $0x10,%esp
  800128:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80012b:	5b                   	pop    %ebx
  80012c:	5e                   	pop    %esi
  80012d:	5d                   	pop    %ebp
  80012e:	c3                   	ret    

0080012f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80012f:	55                   	push   %ebp
  800130:	89 e5                	mov    %esp,%ebp
  800132:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800135:	6a 00                	push   $0x0
  800137:	e8 79 0b 00 00       	call   800cb5 <sys_env_destroy>
}
  80013c:	83 c4 10             	add    $0x10,%esp
  80013f:	c9                   	leave  
  800140:	c3                   	ret    

00800141 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800141:	55                   	push   %ebp
  800142:	89 e5                	mov    %esp,%ebp
  800144:	56                   	push   %esi
  800145:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800146:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800149:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80014f:	e8 a2 0b 00 00       	call   800cf6 <sys_getenvid>
  800154:	83 ec 0c             	sub    $0xc,%esp
  800157:	ff 75 0c             	pushl  0xc(%ebp)
  80015a:	ff 75 08             	pushl  0x8(%ebp)
  80015d:	56                   	push   %esi
  80015e:	50                   	push   %eax
  80015f:	68 e4 16 80 00       	push   $0x8016e4
  800164:	e8 b3 00 00 00       	call   80021c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800169:	83 c4 18             	add    $0x18,%esp
  80016c:	53                   	push   %ebx
  80016d:	ff 75 10             	pushl  0x10(%ebp)
  800170:	e8 56 00 00 00       	call   8001cb <vcprintf>
	cprintf("\n");
  800175:	c7 04 24 b5 1a 80 00 	movl   $0x801ab5,(%esp)
  80017c:	e8 9b 00 00 00       	call   80021c <cprintf>
  800181:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800184:	cc                   	int3   
  800185:	eb fd                	jmp    800184 <_panic+0x43>

00800187 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800187:	55                   	push   %ebp
  800188:	89 e5                	mov    %esp,%ebp
  80018a:	53                   	push   %ebx
  80018b:	83 ec 04             	sub    $0x4,%esp
  80018e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800191:	8b 13                	mov    (%ebx),%edx
  800193:	8d 42 01             	lea    0x1(%edx),%eax
  800196:	89 03                	mov    %eax,(%ebx)
  800198:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80019b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80019f:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001a4:	74 09                	je     8001af <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001a6:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001ad:	c9                   	leave  
  8001ae:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001af:	83 ec 08             	sub    $0x8,%esp
  8001b2:	68 ff 00 00 00       	push   $0xff
  8001b7:	8d 43 08             	lea    0x8(%ebx),%eax
  8001ba:	50                   	push   %eax
  8001bb:	e8 b8 0a 00 00       	call   800c78 <sys_cputs>
		b->idx = 0;
  8001c0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001c6:	83 c4 10             	add    $0x10,%esp
  8001c9:	eb db                	jmp    8001a6 <putch+0x1f>

008001cb <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001cb:	55                   	push   %ebp
  8001cc:	89 e5                	mov    %esp,%ebp
  8001ce:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001d4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001db:	00 00 00 
	b.cnt = 0;
  8001de:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001e5:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001e8:	ff 75 0c             	pushl  0xc(%ebp)
  8001eb:	ff 75 08             	pushl  0x8(%ebp)
  8001ee:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001f4:	50                   	push   %eax
  8001f5:	68 87 01 80 00       	push   $0x800187
  8001fa:	e8 4a 01 00 00       	call   800349 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001ff:	83 c4 08             	add    $0x8,%esp
  800202:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800208:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80020e:	50                   	push   %eax
  80020f:	e8 64 0a 00 00       	call   800c78 <sys_cputs>

	return b.cnt;
}
  800214:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80021a:	c9                   	leave  
  80021b:	c3                   	ret    

0080021c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80021c:	55                   	push   %ebp
  80021d:	89 e5                	mov    %esp,%ebp
  80021f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800222:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800225:	50                   	push   %eax
  800226:	ff 75 08             	pushl  0x8(%ebp)
  800229:	e8 9d ff ff ff       	call   8001cb <vcprintf>
	va_end(ap);

	return cnt;
}
  80022e:	c9                   	leave  
  80022f:	c3                   	ret    

00800230 <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800230:	55                   	push   %ebp
  800231:	89 e5                	mov    %esp,%ebp
  800233:	57                   	push   %edi
  800234:	56                   	push   %esi
  800235:	53                   	push   %ebx
  800236:	83 ec 1c             	sub    $0x1c,%esp
  800239:	89 c6                	mov    %eax,%esi
  80023b:	89 d7                	mov    %edx,%edi
  80023d:	8b 45 08             	mov    0x8(%ebp),%eax
  800240:	8b 55 0c             	mov    0xc(%ebp),%edx
  800243:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800246:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800249:	8b 45 10             	mov    0x10(%ebp),%eax
  80024c:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  80024f:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800253:	74 2c                	je     800281 <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800255:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800258:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80025f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800262:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800265:	39 c2                	cmp    %eax,%edx
  800267:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80026a:	73 43                	jae    8002af <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80026c:	83 eb 01             	sub    $0x1,%ebx
  80026f:	85 db                	test   %ebx,%ebx
  800271:	7e 6c                	jle    8002df <printnum+0xaf>
			putch(padc, putdat);
  800273:	83 ec 08             	sub    $0x8,%esp
  800276:	57                   	push   %edi
  800277:	ff 75 18             	pushl  0x18(%ebp)
  80027a:	ff d6                	call   *%esi
  80027c:	83 c4 10             	add    $0x10,%esp
  80027f:	eb eb                	jmp    80026c <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800281:	83 ec 0c             	sub    $0xc,%esp
  800284:	6a 20                	push   $0x20
  800286:	6a 00                	push   $0x0
  800288:	50                   	push   %eax
  800289:	ff 75 e4             	pushl  -0x1c(%ebp)
  80028c:	ff 75 e0             	pushl  -0x20(%ebp)
  80028f:	89 fa                	mov    %edi,%edx
  800291:	89 f0                	mov    %esi,%eax
  800293:	e8 98 ff ff ff       	call   800230 <printnum>
		while (--width > 0)
  800298:	83 c4 20             	add    $0x20,%esp
  80029b:	83 eb 01             	sub    $0x1,%ebx
  80029e:	85 db                	test   %ebx,%ebx
  8002a0:	7e 65                	jle    800307 <printnum+0xd7>
			putch(' ', putdat);
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	57                   	push   %edi
  8002a6:	6a 20                	push   $0x20
  8002a8:	ff d6                	call   *%esi
  8002aa:	83 c4 10             	add    $0x10,%esp
  8002ad:	eb ec                	jmp    80029b <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002af:	83 ec 0c             	sub    $0xc,%esp
  8002b2:	ff 75 18             	pushl  0x18(%ebp)
  8002b5:	83 eb 01             	sub    $0x1,%ebx
  8002b8:	53                   	push   %ebx
  8002b9:	50                   	push   %eax
  8002ba:	83 ec 08             	sub    $0x8,%esp
  8002bd:	ff 75 dc             	pushl  -0x24(%ebp)
  8002c0:	ff 75 d8             	pushl  -0x28(%ebp)
  8002c3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c6:	ff 75 e0             	pushl  -0x20(%ebp)
  8002c9:	e8 52 11 00 00       	call   801420 <__udivdi3>
  8002ce:	83 c4 18             	add    $0x18,%esp
  8002d1:	52                   	push   %edx
  8002d2:	50                   	push   %eax
  8002d3:	89 fa                	mov    %edi,%edx
  8002d5:	89 f0                	mov    %esi,%eax
  8002d7:	e8 54 ff ff ff       	call   800230 <printnum>
  8002dc:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002df:	83 ec 08             	sub    $0x8,%esp
  8002e2:	57                   	push   %edi
  8002e3:	83 ec 04             	sub    $0x4,%esp
  8002e6:	ff 75 dc             	pushl  -0x24(%ebp)
  8002e9:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ec:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ef:	ff 75 e0             	pushl  -0x20(%ebp)
  8002f2:	e8 39 12 00 00       	call   801530 <__umoddi3>
  8002f7:	83 c4 14             	add    $0x14,%esp
  8002fa:	0f be 80 07 17 80 00 	movsbl 0x801707(%eax),%eax
  800301:	50                   	push   %eax
  800302:	ff d6                	call   *%esi
  800304:	83 c4 10             	add    $0x10,%esp
}
  800307:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80030a:	5b                   	pop    %ebx
  80030b:	5e                   	pop    %esi
  80030c:	5f                   	pop    %edi
  80030d:	5d                   	pop    %ebp
  80030e:	c3                   	ret    

0080030f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80030f:	55                   	push   %ebp
  800310:	89 e5                	mov    %esp,%ebp
  800312:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800315:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800319:	8b 10                	mov    (%eax),%edx
  80031b:	3b 50 04             	cmp    0x4(%eax),%edx
  80031e:	73 0a                	jae    80032a <sprintputch+0x1b>
		*b->buf++ = ch;
  800320:	8d 4a 01             	lea    0x1(%edx),%ecx
  800323:	89 08                	mov    %ecx,(%eax)
  800325:	8b 45 08             	mov    0x8(%ebp),%eax
  800328:	88 02                	mov    %al,(%edx)
}
  80032a:	5d                   	pop    %ebp
  80032b:	c3                   	ret    

0080032c <printfmt>:
{
  80032c:	55                   	push   %ebp
  80032d:	89 e5                	mov    %esp,%ebp
  80032f:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800332:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800335:	50                   	push   %eax
  800336:	ff 75 10             	pushl  0x10(%ebp)
  800339:	ff 75 0c             	pushl  0xc(%ebp)
  80033c:	ff 75 08             	pushl  0x8(%ebp)
  80033f:	e8 05 00 00 00       	call   800349 <vprintfmt>
}
  800344:	83 c4 10             	add    $0x10,%esp
  800347:	c9                   	leave  
  800348:	c3                   	ret    

00800349 <vprintfmt>:
{
  800349:	55                   	push   %ebp
  80034a:	89 e5                	mov    %esp,%ebp
  80034c:	57                   	push   %edi
  80034d:	56                   	push   %esi
  80034e:	53                   	push   %ebx
  80034f:	83 ec 3c             	sub    $0x3c,%esp
  800352:	8b 75 08             	mov    0x8(%ebp),%esi
  800355:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800358:	8b 7d 10             	mov    0x10(%ebp),%edi
  80035b:	e9 1e 04 00 00       	jmp    80077e <vprintfmt+0x435>
		posflag = 0;
  800360:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  800367:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80036b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800372:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800379:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800380:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  800387:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80038c:	8d 47 01             	lea    0x1(%edi),%eax
  80038f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800392:	0f b6 17             	movzbl (%edi),%edx
  800395:	8d 42 dd             	lea    -0x23(%edx),%eax
  800398:	3c 55                	cmp    $0x55,%al
  80039a:	0f 87 d9 04 00 00    	ja     800879 <vprintfmt+0x530>
  8003a0:	0f b6 c0             	movzbl %al,%eax
  8003a3:	ff 24 85 e0 18 80 00 	jmp    *0x8018e0(,%eax,4)
  8003aa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003ad:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8003b1:	eb d9                	jmp    80038c <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003b3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  8003b6:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  8003bd:	eb cd                	jmp    80038c <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003bf:	0f b6 d2             	movzbl %dl,%edx
  8003c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ca:	89 75 08             	mov    %esi,0x8(%ebp)
  8003cd:	eb 0c                	jmp    8003db <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  8003cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003d2:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  8003d6:	eb b4                	jmp    80038c <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  8003d8:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003db:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003de:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003e2:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003e5:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003e8:	83 fe 09             	cmp    $0x9,%esi
  8003eb:	76 eb                	jbe    8003d8 <vprintfmt+0x8f>
  8003ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003f0:	8b 75 08             	mov    0x8(%ebp),%esi
  8003f3:	eb 14                	jmp    800409 <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  8003f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f8:	8b 00                	mov    (%eax),%eax
  8003fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800400:	8d 40 04             	lea    0x4(%eax),%eax
  800403:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800406:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800409:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80040d:	0f 89 79 ff ff ff    	jns    80038c <vprintfmt+0x43>
				width = precision, precision = -1;
  800413:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800416:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800419:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800420:	e9 67 ff ff ff       	jmp    80038c <vprintfmt+0x43>
  800425:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800428:	85 c0                	test   %eax,%eax
  80042a:	0f 48 c1             	cmovs  %ecx,%eax
  80042d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800430:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800433:	e9 54 ff ff ff       	jmp    80038c <vprintfmt+0x43>
  800438:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80043b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800442:	e9 45 ff ff ff       	jmp    80038c <vprintfmt+0x43>
			lflag++;
  800447:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80044b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80044e:	e9 39 ff ff ff       	jmp    80038c <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800453:	8b 45 14             	mov    0x14(%ebp),%eax
  800456:	8d 78 04             	lea    0x4(%eax),%edi
  800459:	83 ec 08             	sub    $0x8,%esp
  80045c:	53                   	push   %ebx
  80045d:	ff 30                	pushl  (%eax)
  80045f:	ff d6                	call   *%esi
			break;
  800461:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800464:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800467:	e9 0f 03 00 00       	jmp    80077b <vprintfmt+0x432>
			err = va_arg(ap, int);
  80046c:	8b 45 14             	mov    0x14(%ebp),%eax
  80046f:	8d 78 04             	lea    0x4(%eax),%edi
  800472:	8b 00                	mov    (%eax),%eax
  800474:	99                   	cltd   
  800475:	31 d0                	xor    %edx,%eax
  800477:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800479:	83 f8 0f             	cmp    $0xf,%eax
  80047c:	7f 23                	jg     8004a1 <vprintfmt+0x158>
  80047e:	8b 14 85 40 1a 80 00 	mov    0x801a40(,%eax,4),%edx
  800485:	85 d2                	test   %edx,%edx
  800487:	74 18                	je     8004a1 <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  800489:	52                   	push   %edx
  80048a:	68 28 17 80 00       	push   $0x801728
  80048f:	53                   	push   %ebx
  800490:	56                   	push   %esi
  800491:	e8 96 fe ff ff       	call   80032c <printfmt>
  800496:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800499:	89 7d 14             	mov    %edi,0x14(%ebp)
  80049c:	e9 da 02 00 00       	jmp    80077b <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  8004a1:	50                   	push   %eax
  8004a2:	68 1f 17 80 00       	push   $0x80171f
  8004a7:	53                   	push   %ebx
  8004a8:	56                   	push   %esi
  8004a9:	e8 7e fe ff ff       	call   80032c <printfmt>
  8004ae:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004b1:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004b4:	e9 c2 02 00 00       	jmp    80077b <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  8004b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bc:	83 c0 04             	add    $0x4,%eax
  8004bf:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8004c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c5:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004c7:	85 c9                	test   %ecx,%ecx
  8004c9:	b8 18 17 80 00       	mov    $0x801718,%eax
  8004ce:	0f 45 c1             	cmovne %ecx,%eax
  8004d1:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004d4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004d8:	7e 06                	jle    8004e0 <vprintfmt+0x197>
  8004da:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004de:	75 0d                	jne    8004ed <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004e3:	89 c7                	mov    %eax,%edi
  8004e5:	03 45 e0             	add    -0x20(%ebp),%eax
  8004e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004eb:	eb 53                	jmp    800540 <vprintfmt+0x1f7>
  8004ed:	83 ec 08             	sub    $0x8,%esp
  8004f0:	ff 75 d8             	pushl  -0x28(%ebp)
  8004f3:	50                   	push   %eax
  8004f4:	e8 28 04 00 00       	call   800921 <strnlen>
  8004f9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004fc:	29 c1                	sub    %eax,%ecx
  8004fe:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800501:	83 c4 10             	add    $0x10,%esp
  800504:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800506:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80050a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80050d:	eb 0f                	jmp    80051e <vprintfmt+0x1d5>
					putch(padc, putdat);
  80050f:	83 ec 08             	sub    $0x8,%esp
  800512:	53                   	push   %ebx
  800513:	ff 75 e0             	pushl  -0x20(%ebp)
  800516:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800518:	83 ef 01             	sub    $0x1,%edi
  80051b:	83 c4 10             	add    $0x10,%esp
  80051e:	85 ff                	test   %edi,%edi
  800520:	7f ed                	jg     80050f <vprintfmt+0x1c6>
  800522:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800525:	85 c9                	test   %ecx,%ecx
  800527:	b8 00 00 00 00       	mov    $0x0,%eax
  80052c:	0f 49 c1             	cmovns %ecx,%eax
  80052f:	29 c1                	sub    %eax,%ecx
  800531:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800534:	eb aa                	jmp    8004e0 <vprintfmt+0x197>
					putch(ch, putdat);
  800536:	83 ec 08             	sub    $0x8,%esp
  800539:	53                   	push   %ebx
  80053a:	52                   	push   %edx
  80053b:	ff d6                	call   *%esi
  80053d:	83 c4 10             	add    $0x10,%esp
  800540:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800543:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800545:	83 c7 01             	add    $0x1,%edi
  800548:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80054c:	0f be d0             	movsbl %al,%edx
  80054f:	85 d2                	test   %edx,%edx
  800551:	74 4b                	je     80059e <vprintfmt+0x255>
  800553:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800557:	78 06                	js     80055f <vprintfmt+0x216>
  800559:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80055d:	78 1e                	js     80057d <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  80055f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800563:	74 d1                	je     800536 <vprintfmt+0x1ed>
  800565:	0f be c0             	movsbl %al,%eax
  800568:	83 e8 20             	sub    $0x20,%eax
  80056b:	83 f8 5e             	cmp    $0x5e,%eax
  80056e:	76 c6                	jbe    800536 <vprintfmt+0x1ed>
					putch('?', putdat);
  800570:	83 ec 08             	sub    $0x8,%esp
  800573:	53                   	push   %ebx
  800574:	6a 3f                	push   $0x3f
  800576:	ff d6                	call   *%esi
  800578:	83 c4 10             	add    $0x10,%esp
  80057b:	eb c3                	jmp    800540 <vprintfmt+0x1f7>
  80057d:	89 cf                	mov    %ecx,%edi
  80057f:	eb 0e                	jmp    80058f <vprintfmt+0x246>
				putch(' ', putdat);
  800581:	83 ec 08             	sub    $0x8,%esp
  800584:	53                   	push   %ebx
  800585:	6a 20                	push   $0x20
  800587:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800589:	83 ef 01             	sub    $0x1,%edi
  80058c:	83 c4 10             	add    $0x10,%esp
  80058f:	85 ff                	test   %edi,%edi
  800591:	7f ee                	jg     800581 <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  800593:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800596:	89 45 14             	mov    %eax,0x14(%ebp)
  800599:	e9 dd 01 00 00       	jmp    80077b <vprintfmt+0x432>
  80059e:	89 cf                	mov    %ecx,%edi
  8005a0:	eb ed                	jmp    80058f <vprintfmt+0x246>
	if (lflag >= 2)
  8005a2:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8005a6:	7f 21                	jg     8005c9 <vprintfmt+0x280>
	else if (lflag)
  8005a8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8005ac:	74 6a                	je     800618 <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  8005ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b1:	8b 00                	mov    (%eax),%eax
  8005b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b6:	89 c1                	mov    %eax,%ecx
  8005b8:	c1 f9 1f             	sar    $0x1f,%ecx
  8005bb:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005be:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c1:	8d 40 04             	lea    0x4(%eax),%eax
  8005c4:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c7:	eb 17                	jmp    8005e0 <vprintfmt+0x297>
		return va_arg(*ap, long long);
  8005c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cc:	8b 50 04             	mov    0x4(%eax),%edx
  8005cf:	8b 00                	mov    (%eax),%eax
  8005d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005da:	8d 40 08             	lea    0x8(%eax),%eax
  8005dd:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005e0:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  8005e3:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8005e8:	85 d2                	test   %edx,%edx
  8005ea:	0f 89 5c 01 00 00    	jns    80074c <vprintfmt+0x403>
				putch('-', putdat);
  8005f0:	83 ec 08             	sub    $0x8,%esp
  8005f3:	53                   	push   %ebx
  8005f4:	6a 2d                	push   $0x2d
  8005f6:	ff d6                	call   *%esi
				num = -(long long) num;
  8005f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005fb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005fe:	f7 d8                	neg    %eax
  800600:	83 d2 00             	adc    $0x0,%edx
  800603:	f7 da                	neg    %edx
  800605:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800608:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80060b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80060e:	bf 0a 00 00 00       	mov    $0xa,%edi
  800613:	e9 45 01 00 00       	jmp    80075d <vprintfmt+0x414>
		return va_arg(*ap, int);
  800618:	8b 45 14             	mov    0x14(%ebp),%eax
  80061b:	8b 00                	mov    (%eax),%eax
  80061d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800620:	89 c1                	mov    %eax,%ecx
  800622:	c1 f9 1f             	sar    $0x1f,%ecx
  800625:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800628:	8b 45 14             	mov    0x14(%ebp),%eax
  80062b:	8d 40 04             	lea    0x4(%eax),%eax
  80062e:	89 45 14             	mov    %eax,0x14(%ebp)
  800631:	eb ad                	jmp    8005e0 <vprintfmt+0x297>
	if (lflag >= 2)
  800633:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800637:	7f 29                	jg     800662 <vprintfmt+0x319>
	else if (lflag)
  800639:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80063d:	74 44                	je     800683 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  80063f:	8b 45 14             	mov    0x14(%ebp),%eax
  800642:	8b 00                	mov    (%eax),%eax
  800644:	ba 00 00 00 00       	mov    $0x0,%edx
  800649:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80064f:	8b 45 14             	mov    0x14(%ebp),%eax
  800652:	8d 40 04             	lea    0x4(%eax),%eax
  800655:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800658:	bf 0a 00 00 00       	mov    $0xa,%edi
  80065d:	e9 ea 00 00 00       	jmp    80074c <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800662:	8b 45 14             	mov    0x14(%ebp),%eax
  800665:	8b 50 04             	mov    0x4(%eax),%edx
  800668:	8b 00                	mov    (%eax),%eax
  80066a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800670:	8b 45 14             	mov    0x14(%ebp),%eax
  800673:	8d 40 08             	lea    0x8(%eax),%eax
  800676:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800679:	bf 0a 00 00 00       	mov    $0xa,%edi
  80067e:	e9 c9 00 00 00       	jmp    80074c <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800683:	8b 45 14             	mov    0x14(%ebp),%eax
  800686:	8b 00                	mov    (%eax),%eax
  800688:	ba 00 00 00 00       	mov    $0x0,%edx
  80068d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800690:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800693:	8b 45 14             	mov    0x14(%ebp),%eax
  800696:	8d 40 04             	lea    0x4(%eax),%eax
  800699:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80069c:	bf 0a 00 00 00       	mov    $0xa,%edi
  8006a1:	e9 a6 00 00 00       	jmp    80074c <vprintfmt+0x403>
			putch('0', putdat);
  8006a6:	83 ec 08             	sub    $0x8,%esp
  8006a9:	53                   	push   %ebx
  8006aa:	6a 30                	push   $0x30
  8006ac:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006ae:	83 c4 10             	add    $0x10,%esp
  8006b1:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8006b5:	7f 26                	jg     8006dd <vprintfmt+0x394>
	else if (lflag)
  8006b7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8006bb:	74 3e                	je     8006fb <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  8006bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c0:	8b 00                	mov    (%eax),%eax
  8006c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ca:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d0:	8d 40 04             	lea    0x4(%eax),%eax
  8006d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006d6:	bf 08 00 00 00       	mov    $0x8,%edi
  8006db:	eb 6f                	jmp    80074c <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8006dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e0:	8b 50 04             	mov    0x4(%eax),%edx
  8006e3:	8b 00                	mov    (%eax),%eax
  8006e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ee:	8d 40 08             	lea    0x8(%eax),%eax
  8006f1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006f4:	bf 08 00 00 00       	mov    $0x8,%edi
  8006f9:	eb 51                	jmp    80074c <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8006fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	ba 00 00 00 00       	mov    $0x0,%edx
  800705:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800708:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80070b:	8b 45 14             	mov    0x14(%ebp),%eax
  80070e:	8d 40 04             	lea    0x4(%eax),%eax
  800711:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800714:	bf 08 00 00 00       	mov    $0x8,%edi
  800719:	eb 31                	jmp    80074c <vprintfmt+0x403>
			putch('0', putdat);
  80071b:	83 ec 08             	sub    $0x8,%esp
  80071e:	53                   	push   %ebx
  80071f:	6a 30                	push   $0x30
  800721:	ff d6                	call   *%esi
			putch('x', putdat);
  800723:	83 c4 08             	add    $0x8,%esp
  800726:	53                   	push   %ebx
  800727:	6a 78                	push   $0x78
  800729:	ff d6                	call   *%esi
			num = (unsigned long long)
  80072b:	8b 45 14             	mov    0x14(%ebp),%eax
  80072e:	8b 00                	mov    (%eax),%eax
  800730:	ba 00 00 00 00       	mov    $0x0,%edx
  800735:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800738:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80073b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80073e:	8b 45 14             	mov    0x14(%ebp),%eax
  800741:	8d 40 04             	lea    0x4(%eax),%eax
  800744:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800747:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  80074c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800750:	74 0b                	je     80075d <vprintfmt+0x414>
				putch('+', putdat);
  800752:	83 ec 08             	sub    $0x8,%esp
  800755:	53                   	push   %ebx
  800756:	6a 2b                	push   $0x2b
  800758:	ff d6                	call   *%esi
  80075a:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  80075d:	83 ec 0c             	sub    $0xc,%esp
  800760:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800764:	50                   	push   %eax
  800765:	ff 75 e0             	pushl  -0x20(%ebp)
  800768:	57                   	push   %edi
  800769:	ff 75 dc             	pushl  -0x24(%ebp)
  80076c:	ff 75 d8             	pushl  -0x28(%ebp)
  80076f:	89 da                	mov    %ebx,%edx
  800771:	89 f0                	mov    %esi,%eax
  800773:	e8 b8 fa ff ff       	call   800230 <printnum>
			break;
  800778:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  80077b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80077e:	83 c7 01             	add    $0x1,%edi
  800781:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800785:	83 f8 25             	cmp    $0x25,%eax
  800788:	0f 84 d2 fb ff ff    	je     800360 <vprintfmt+0x17>
			if (ch == '\0')
  80078e:	85 c0                	test   %eax,%eax
  800790:	0f 84 03 01 00 00    	je     800899 <vprintfmt+0x550>
			putch(ch, putdat);
  800796:	83 ec 08             	sub    $0x8,%esp
  800799:	53                   	push   %ebx
  80079a:	50                   	push   %eax
  80079b:	ff d6                	call   *%esi
  80079d:	83 c4 10             	add    $0x10,%esp
  8007a0:	eb dc                	jmp    80077e <vprintfmt+0x435>
	if (lflag >= 2)
  8007a2:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8007a6:	7f 29                	jg     8007d1 <vprintfmt+0x488>
	else if (lflag)
  8007a8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8007ac:	74 44                	je     8007f2 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  8007ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007bb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007be:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c1:	8d 40 04             	lea    0x4(%eax),%eax
  8007c4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c7:	bf 10 00 00 00       	mov    $0x10,%edi
  8007cc:	e9 7b ff ff ff       	jmp    80074c <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8007d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d4:	8b 50 04             	mov    0x4(%eax),%edx
  8007d7:	8b 00                	mov    (%eax),%eax
  8007d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007dc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007df:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e2:	8d 40 08             	lea    0x8(%eax),%eax
  8007e5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e8:	bf 10 00 00 00       	mov    $0x10,%edi
  8007ed:	e9 5a ff ff ff       	jmp    80074c <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8007f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8007fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ff:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800802:	8b 45 14             	mov    0x14(%ebp),%eax
  800805:	8d 40 04             	lea    0x4(%eax),%eax
  800808:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80080b:	bf 10 00 00 00       	mov    $0x10,%edi
  800810:	e9 37 ff ff ff       	jmp    80074c <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  800815:	8b 45 14             	mov    0x14(%ebp),%eax
  800818:	8d 78 04             	lea    0x4(%eax),%edi
  80081b:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  80081d:	85 c0                	test   %eax,%eax
  80081f:	74 2c                	je     80084d <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  800821:	8b 13                	mov    (%ebx),%edx
  800823:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  800825:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  800828:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  80082b:	0f 8e 4a ff ff ff    	jle    80077b <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  800831:	68 78 18 80 00       	push   $0x801878
  800836:	68 28 17 80 00       	push   $0x801728
  80083b:	53                   	push   %ebx
  80083c:	56                   	push   %esi
  80083d:	e8 ea fa ff ff       	call   80032c <printfmt>
  800842:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800845:	89 7d 14             	mov    %edi,0x14(%ebp)
  800848:	e9 2e ff ff ff       	jmp    80077b <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  80084d:	68 40 18 80 00       	push   $0x801840
  800852:	68 28 17 80 00       	push   $0x801728
  800857:	53                   	push   %ebx
  800858:	56                   	push   %esi
  800859:	e8 ce fa ff ff       	call   80032c <printfmt>
        		break;
  80085e:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800861:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  800864:	e9 12 ff ff ff       	jmp    80077b <vprintfmt+0x432>
			putch(ch, putdat);
  800869:	83 ec 08             	sub    $0x8,%esp
  80086c:	53                   	push   %ebx
  80086d:	6a 25                	push   $0x25
  80086f:	ff d6                	call   *%esi
			break;
  800871:	83 c4 10             	add    $0x10,%esp
  800874:	e9 02 ff ff ff       	jmp    80077b <vprintfmt+0x432>
			putch('%', putdat);
  800879:	83 ec 08             	sub    $0x8,%esp
  80087c:	53                   	push   %ebx
  80087d:	6a 25                	push   $0x25
  80087f:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800881:	83 c4 10             	add    $0x10,%esp
  800884:	89 f8                	mov    %edi,%eax
  800886:	eb 03                	jmp    80088b <vprintfmt+0x542>
  800888:	83 e8 01             	sub    $0x1,%eax
  80088b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80088f:	75 f7                	jne    800888 <vprintfmt+0x53f>
  800891:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800894:	e9 e2 fe ff ff       	jmp    80077b <vprintfmt+0x432>
}
  800899:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80089c:	5b                   	pop    %ebx
  80089d:	5e                   	pop    %esi
  80089e:	5f                   	pop    %edi
  80089f:	5d                   	pop    %ebp
  8008a0:	c3                   	ret    

008008a1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008a1:	55                   	push   %ebp
  8008a2:	89 e5                	mov    %esp,%ebp
  8008a4:	83 ec 18             	sub    $0x18,%esp
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008b0:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008b4:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008be:	85 c0                	test   %eax,%eax
  8008c0:	74 26                	je     8008e8 <vsnprintf+0x47>
  8008c2:	85 d2                	test   %edx,%edx
  8008c4:	7e 22                	jle    8008e8 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008c6:	ff 75 14             	pushl  0x14(%ebp)
  8008c9:	ff 75 10             	pushl  0x10(%ebp)
  8008cc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008cf:	50                   	push   %eax
  8008d0:	68 0f 03 80 00       	push   $0x80030f
  8008d5:	e8 6f fa ff ff       	call   800349 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008dd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008e3:	83 c4 10             	add    $0x10,%esp
}
  8008e6:	c9                   	leave  
  8008e7:	c3                   	ret    
		return -E_INVAL;
  8008e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008ed:	eb f7                	jmp    8008e6 <vsnprintf+0x45>

008008ef <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008ef:	55                   	push   %ebp
  8008f0:	89 e5                	mov    %esp,%ebp
  8008f2:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008f5:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008f8:	50                   	push   %eax
  8008f9:	ff 75 10             	pushl  0x10(%ebp)
  8008fc:	ff 75 0c             	pushl  0xc(%ebp)
  8008ff:	ff 75 08             	pushl  0x8(%ebp)
  800902:	e8 9a ff ff ff       	call   8008a1 <vsnprintf>
	va_end(ap);

	return rc;
}
  800907:	c9                   	leave  
  800908:	c3                   	ret    

00800909 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800909:	55                   	push   %ebp
  80090a:	89 e5                	mov    %esp,%ebp
  80090c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80090f:	b8 00 00 00 00       	mov    $0x0,%eax
  800914:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800918:	74 05                	je     80091f <strlen+0x16>
		n++;
  80091a:	83 c0 01             	add    $0x1,%eax
  80091d:	eb f5                	jmp    800914 <strlen+0xb>
	return n;
}
  80091f:	5d                   	pop    %ebp
  800920:	c3                   	ret    

00800921 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800921:	55                   	push   %ebp
  800922:	89 e5                	mov    %esp,%ebp
  800924:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800927:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80092a:	ba 00 00 00 00       	mov    $0x0,%edx
  80092f:	39 c2                	cmp    %eax,%edx
  800931:	74 0d                	je     800940 <strnlen+0x1f>
  800933:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800937:	74 05                	je     80093e <strnlen+0x1d>
		n++;
  800939:	83 c2 01             	add    $0x1,%edx
  80093c:	eb f1                	jmp    80092f <strnlen+0xe>
  80093e:	89 d0                	mov    %edx,%eax
	return n;
}
  800940:	5d                   	pop    %ebp
  800941:	c3                   	ret    

00800942 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800942:	55                   	push   %ebp
  800943:	89 e5                	mov    %esp,%ebp
  800945:	53                   	push   %ebx
  800946:	8b 45 08             	mov    0x8(%ebp),%eax
  800949:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80094c:	ba 00 00 00 00       	mov    $0x0,%edx
  800951:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800955:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800958:	83 c2 01             	add    $0x1,%edx
  80095b:	84 c9                	test   %cl,%cl
  80095d:	75 f2                	jne    800951 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80095f:	5b                   	pop    %ebx
  800960:	5d                   	pop    %ebp
  800961:	c3                   	ret    

00800962 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800962:	55                   	push   %ebp
  800963:	89 e5                	mov    %esp,%ebp
  800965:	53                   	push   %ebx
  800966:	83 ec 10             	sub    $0x10,%esp
  800969:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80096c:	53                   	push   %ebx
  80096d:	e8 97 ff ff ff       	call   800909 <strlen>
  800972:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800975:	ff 75 0c             	pushl  0xc(%ebp)
  800978:	01 d8                	add    %ebx,%eax
  80097a:	50                   	push   %eax
  80097b:	e8 c2 ff ff ff       	call   800942 <strcpy>
	return dst;
}
  800980:	89 d8                	mov    %ebx,%eax
  800982:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800985:	c9                   	leave  
  800986:	c3                   	ret    

00800987 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800987:	55                   	push   %ebp
  800988:	89 e5                	mov    %esp,%ebp
  80098a:	56                   	push   %esi
  80098b:	53                   	push   %ebx
  80098c:	8b 45 08             	mov    0x8(%ebp),%eax
  80098f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800992:	89 c6                	mov    %eax,%esi
  800994:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800997:	89 c2                	mov    %eax,%edx
  800999:	39 f2                	cmp    %esi,%edx
  80099b:	74 11                	je     8009ae <strncpy+0x27>
		*dst++ = *src;
  80099d:	83 c2 01             	add    $0x1,%edx
  8009a0:	0f b6 19             	movzbl (%ecx),%ebx
  8009a3:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009a6:	80 fb 01             	cmp    $0x1,%bl
  8009a9:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009ac:	eb eb                	jmp    800999 <strncpy+0x12>
	}
	return ret;
}
  8009ae:	5b                   	pop    %ebx
  8009af:	5e                   	pop    %esi
  8009b0:	5d                   	pop    %ebp
  8009b1:	c3                   	ret    

008009b2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009b2:	55                   	push   %ebp
  8009b3:	89 e5                	mov    %esp,%ebp
  8009b5:	56                   	push   %esi
  8009b6:	53                   	push   %ebx
  8009b7:	8b 75 08             	mov    0x8(%ebp),%esi
  8009ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009bd:	8b 55 10             	mov    0x10(%ebp),%edx
  8009c0:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009c2:	85 d2                	test   %edx,%edx
  8009c4:	74 21                	je     8009e7 <strlcpy+0x35>
  8009c6:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009ca:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009cc:	39 c2                	cmp    %eax,%edx
  8009ce:	74 14                	je     8009e4 <strlcpy+0x32>
  8009d0:	0f b6 19             	movzbl (%ecx),%ebx
  8009d3:	84 db                	test   %bl,%bl
  8009d5:	74 0b                	je     8009e2 <strlcpy+0x30>
			*dst++ = *src++;
  8009d7:	83 c1 01             	add    $0x1,%ecx
  8009da:	83 c2 01             	add    $0x1,%edx
  8009dd:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009e0:	eb ea                	jmp    8009cc <strlcpy+0x1a>
  8009e2:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009e4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009e7:	29 f0                	sub    %esi,%eax
}
  8009e9:	5b                   	pop    %ebx
  8009ea:	5e                   	pop    %esi
  8009eb:	5d                   	pop    %ebp
  8009ec:	c3                   	ret    

008009ed <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009ed:	55                   	push   %ebp
  8009ee:	89 e5                	mov    %esp,%ebp
  8009f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009f3:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009f6:	0f b6 01             	movzbl (%ecx),%eax
  8009f9:	84 c0                	test   %al,%al
  8009fb:	74 0c                	je     800a09 <strcmp+0x1c>
  8009fd:	3a 02                	cmp    (%edx),%al
  8009ff:	75 08                	jne    800a09 <strcmp+0x1c>
		p++, q++;
  800a01:	83 c1 01             	add    $0x1,%ecx
  800a04:	83 c2 01             	add    $0x1,%edx
  800a07:	eb ed                	jmp    8009f6 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a09:	0f b6 c0             	movzbl %al,%eax
  800a0c:	0f b6 12             	movzbl (%edx),%edx
  800a0f:	29 d0                	sub    %edx,%eax
}
  800a11:	5d                   	pop    %ebp
  800a12:	c3                   	ret    

00800a13 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a13:	55                   	push   %ebp
  800a14:	89 e5                	mov    %esp,%ebp
  800a16:	53                   	push   %ebx
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a1d:	89 c3                	mov    %eax,%ebx
  800a1f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a22:	eb 06                	jmp    800a2a <strncmp+0x17>
		n--, p++, q++;
  800a24:	83 c0 01             	add    $0x1,%eax
  800a27:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a2a:	39 d8                	cmp    %ebx,%eax
  800a2c:	74 16                	je     800a44 <strncmp+0x31>
  800a2e:	0f b6 08             	movzbl (%eax),%ecx
  800a31:	84 c9                	test   %cl,%cl
  800a33:	74 04                	je     800a39 <strncmp+0x26>
  800a35:	3a 0a                	cmp    (%edx),%cl
  800a37:	74 eb                	je     800a24 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a39:	0f b6 00             	movzbl (%eax),%eax
  800a3c:	0f b6 12             	movzbl (%edx),%edx
  800a3f:	29 d0                	sub    %edx,%eax
}
  800a41:	5b                   	pop    %ebx
  800a42:	5d                   	pop    %ebp
  800a43:	c3                   	ret    
		return 0;
  800a44:	b8 00 00 00 00       	mov    $0x0,%eax
  800a49:	eb f6                	jmp    800a41 <strncmp+0x2e>

00800a4b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a4b:	55                   	push   %ebp
  800a4c:	89 e5                	mov    %esp,%ebp
  800a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a51:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a55:	0f b6 10             	movzbl (%eax),%edx
  800a58:	84 d2                	test   %dl,%dl
  800a5a:	74 09                	je     800a65 <strchr+0x1a>
		if (*s == c)
  800a5c:	38 ca                	cmp    %cl,%dl
  800a5e:	74 0a                	je     800a6a <strchr+0x1f>
	for (; *s; s++)
  800a60:	83 c0 01             	add    $0x1,%eax
  800a63:	eb f0                	jmp    800a55 <strchr+0xa>
			return (char *) s;
	return 0;
  800a65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a6a:	5d                   	pop    %ebp
  800a6b:	c3                   	ret    

00800a6c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a6c:	55                   	push   %ebp
  800a6d:	89 e5                	mov    %esp,%ebp
  800a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a72:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a76:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a79:	38 ca                	cmp    %cl,%dl
  800a7b:	74 09                	je     800a86 <strfind+0x1a>
  800a7d:	84 d2                	test   %dl,%dl
  800a7f:	74 05                	je     800a86 <strfind+0x1a>
	for (; *s; s++)
  800a81:	83 c0 01             	add    $0x1,%eax
  800a84:	eb f0                	jmp    800a76 <strfind+0xa>
			break;
	return (char *) s;
}
  800a86:	5d                   	pop    %ebp
  800a87:	c3                   	ret    

00800a88 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a88:	55                   	push   %ebp
  800a89:	89 e5                	mov    %esp,%ebp
  800a8b:	57                   	push   %edi
  800a8c:	56                   	push   %esi
  800a8d:	53                   	push   %ebx
  800a8e:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a91:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a94:	85 c9                	test   %ecx,%ecx
  800a96:	74 31                	je     800ac9 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a98:	89 f8                	mov    %edi,%eax
  800a9a:	09 c8                	or     %ecx,%eax
  800a9c:	a8 03                	test   $0x3,%al
  800a9e:	75 23                	jne    800ac3 <memset+0x3b>
		c &= 0xFF;
  800aa0:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800aa4:	89 d3                	mov    %edx,%ebx
  800aa6:	c1 e3 08             	shl    $0x8,%ebx
  800aa9:	89 d0                	mov    %edx,%eax
  800aab:	c1 e0 18             	shl    $0x18,%eax
  800aae:	89 d6                	mov    %edx,%esi
  800ab0:	c1 e6 10             	shl    $0x10,%esi
  800ab3:	09 f0                	or     %esi,%eax
  800ab5:	09 c2                	or     %eax,%edx
  800ab7:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ab9:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800abc:	89 d0                	mov    %edx,%eax
  800abe:	fc                   	cld    
  800abf:	f3 ab                	rep stos %eax,%es:(%edi)
  800ac1:	eb 06                	jmp    800ac9 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ac3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac6:	fc                   	cld    
  800ac7:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ac9:	89 f8                	mov    %edi,%eax
  800acb:	5b                   	pop    %ebx
  800acc:	5e                   	pop    %esi
  800acd:	5f                   	pop    %edi
  800ace:	5d                   	pop    %ebp
  800acf:	c3                   	ret    

00800ad0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ad0:	55                   	push   %ebp
  800ad1:	89 e5                	mov    %esp,%ebp
  800ad3:	57                   	push   %edi
  800ad4:	56                   	push   %esi
  800ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800adb:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ade:	39 c6                	cmp    %eax,%esi
  800ae0:	73 32                	jae    800b14 <memmove+0x44>
  800ae2:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ae5:	39 c2                	cmp    %eax,%edx
  800ae7:	76 2b                	jbe    800b14 <memmove+0x44>
		s += n;
		d += n;
  800ae9:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aec:	89 fe                	mov    %edi,%esi
  800aee:	09 ce                	or     %ecx,%esi
  800af0:	09 d6                	or     %edx,%esi
  800af2:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800af8:	75 0e                	jne    800b08 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800afa:	83 ef 04             	sub    $0x4,%edi
  800afd:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b00:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b03:	fd                   	std    
  800b04:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b06:	eb 09                	jmp    800b11 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b08:	83 ef 01             	sub    $0x1,%edi
  800b0b:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b0e:	fd                   	std    
  800b0f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b11:	fc                   	cld    
  800b12:	eb 1a                	jmp    800b2e <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b14:	89 c2                	mov    %eax,%edx
  800b16:	09 ca                	or     %ecx,%edx
  800b18:	09 f2                	or     %esi,%edx
  800b1a:	f6 c2 03             	test   $0x3,%dl
  800b1d:	75 0a                	jne    800b29 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b1f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b22:	89 c7                	mov    %eax,%edi
  800b24:	fc                   	cld    
  800b25:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b27:	eb 05                	jmp    800b2e <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b29:	89 c7                	mov    %eax,%edi
  800b2b:	fc                   	cld    
  800b2c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b2e:	5e                   	pop    %esi
  800b2f:	5f                   	pop    %edi
  800b30:	5d                   	pop    %ebp
  800b31:	c3                   	ret    

00800b32 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b32:	55                   	push   %ebp
  800b33:	89 e5                	mov    %esp,%ebp
  800b35:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b38:	ff 75 10             	pushl  0x10(%ebp)
  800b3b:	ff 75 0c             	pushl  0xc(%ebp)
  800b3e:	ff 75 08             	pushl  0x8(%ebp)
  800b41:	e8 8a ff ff ff       	call   800ad0 <memmove>
}
  800b46:	c9                   	leave  
  800b47:	c3                   	ret    

00800b48 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b48:	55                   	push   %ebp
  800b49:	89 e5                	mov    %esp,%ebp
  800b4b:	56                   	push   %esi
  800b4c:	53                   	push   %ebx
  800b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b50:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b53:	89 c6                	mov    %eax,%esi
  800b55:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b58:	39 f0                	cmp    %esi,%eax
  800b5a:	74 1c                	je     800b78 <memcmp+0x30>
		if (*s1 != *s2)
  800b5c:	0f b6 08             	movzbl (%eax),%ecx
  800b5f:	0f b6 1a             	movzbl (%edx),%ebx
  800b62:	38 d9                	cmp    %bl,%cl
  800b64:	75 08                	jne    800b6e <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b66:	83 c0 01             	add    $0x1,%eax
  800b69:	83 c2 01             	add    $0x1,%edx
  800b6c:	eb ea                	jmp    800b58 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b6e:	0f b6 c1             	movzbl %cl,%eax
  800b71:	0f b6 db             	movzbl %bl,%ebx
  800b74:	29 d8                	sub    %ebx,%eax
  800b76:	eb 05                	jmp    800b7d <memcmp+0x35>
	}

	return 0;
  800b78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b7d:	5b                   	pop    %ebx
  800b7e:	5e                   	pop    %esi
  800b7f:	5d                   	pop    %ebp
  800b80:	c3                   	ret    

00800b81 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b81:	55                   	push   %ebp
  800b82:	89 e5                	mov    %esp,%ebp
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b8a:	89 c2                	mov    %eax,%edx
  800b8c:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b8f:	39 d0                	cmp    %edx,%eax
  800b91:	73 09                	jae    800b9c <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b93:	38 08                	cmp    %cl,(%eax)
  800b95:	74 05                	je     800b9c <memfind+0x1b>
	for (; s < ends; s++)
  800b97:	83 c0 01             	add    $0x1,%eax
  800b9a:	eb f3                	jmp    800b8f <memfind+0xe>
			break;
	return (void *) s;
}
  800b9c:	5d                   	pop    %ebp
  800b9d:	c3                   	ret    

00800b9e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b9e:	55                   	push   %ebp
  800b9f:	89 e5                	mov    %esp,%ebp
  800ba1:	57                   	push   %edi
  800ba2:	56                   	push   %esi
  800ba3:	53                   	push   %ebx
  800ba4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ba7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800baa:	eb 03                	jmp    800baf <strtol+0x11>
		s++;
  800bac:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800baf:	0f b6 01             	movzbl (%ecx),%eax
  800bb2:	3c 20                	cmp    $0x20,%al
  800bb4:	74 f6                	je     800bac <strtol+0xe>
  800bb6:	3c 09                	cmp    $0x9,%al
  800bb8:	74 f2                	je     800bac <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bba:	3c 2b                	cmp    $0x2b,%al
  800bbc:	74 2a                	je     800be8 <strtol+0x4a>
	int neg = 0;
  800bbe:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bc3:	3c 2d                	cmp    $0x2d,%al
  800bc5:	74 2b                	je     800bf2 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bc7:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bcd:	75 0f                	jne    800bde <strtol+0x40>
  800bcf:	80 39 30             	cmpb   $0x30,(%ecx)
  800bd2:	74 28                	je     800bfc <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bd4:	85 db                	test   %ebx,%ebx
  800bd6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bdb:	0f 44 d8             	cmove  %eax,%ebx
  800bde:	b8 00 00 00 00       	mov    $0x0,%eax
  800be3:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800be6:	eb 50                	jmp    800c38 <strtol+0x9a>
		s++;
  800be8:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800beb:	bf 00 00 00 00       	mov    $0x0,%edi
  800bf0:	eb d5                	jmp    800bc7 <strtol+0x29>
		s++, neg = 1;
  800bf2:	83 c1 01             	add    $0x1,%ecx
  800bf5:	bf 01 00 00 00       	mov    $0x1,%edi
  800bfa:	eb cb                	jmp    800bc7 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bfc:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c00:	74 0e                	je     800c10 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c02:	85 db                	test   %ebx,%ebx
  800c04:	75 d8                	jne    800bde <strtol+0x40>
		s++, base = 8;
  800c06:	83 c1 01             	add    $0x1,%ecx
  800c09:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c0e:	eb ce                	jmp    800bde <strtol+0x40>
		s += 2, base = 16;
  800c10:	83 c1 02             	add    $0x2,%ecx
  800c13:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c18:	eb c4                	jmp    800bde <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c1a:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c1d:	89 f3                	mov    %esi,%ebx
  800c1f:	80 fb 19             	cmp    $0x19,%bl
  800c22:	77 29                	ja     800c4d <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c24:	0f be d2             	movsbl %dl,%edx
  800c27:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c2a:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c2d:	7d 30                	jge    800c5f <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c2f:	83 c1 01             	add    $0x1,%ecx
  800c32:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c36:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c38:	0f b6 11             	movzbl (%ecx),%edx
  800c3b:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c3e:	89 f3                	mov    %esi,%ebx
  800c40:	80 fb 09             	cmp    $0x9,%bl
  800c43:	77 d5                	ja     800c1a <strtol+0x7c>
			dig = *s - '0';
  800c45:	0f be d2             	movsbl %dl,%edx
  800c48:	83 ea 30             	sub    $0x30,%edx
  800c4b:	eb dd                	jmp    800c2a <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c4d:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c50:	89 f3                	mov    %esi,%ebx
  800c52:	80 fb 19             	cmp    $0x19,%bl
  800c55:	77 08                	ja     800c5f <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c57:	0f be d2             	movsbl %dl,%edx
  800c5a:	83 ea 37             	sub    $0x37,%edx
  800c5d:	eb cb                	jmp    800c2a <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c5f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c63:	74 05                	je     800c6a <strtol+0xcc>
		*endptr = (char *) s;
  800c65:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c68:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c6a:	89 c2                	mov    %eax,%edx
  800c6c:	f7 da                	neg    %edx
  800c6e:	85 ff                	test   %edi,%edi
  800c70:	0f 45 c2             	cmovne %edx,%eax
}
  800c73:	5b                   	pop    %ebx
  800c74:	5e                   	pop    %esi
  800c75:	5f                   	pop    %edi
  800c76:	5d                   	pop    %ebp
  800c77:	c3                   	ret    

00800c78 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c78:	55                   	push   %ebp
  800c79:	89 e5                	mov    %esp,%ebp
  800c7b:	57                   	push   %edi
  800c7c:	56                   	push   %esi
  800c7d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c7e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c83:	8b 55 08             	mov    0x8(%ebp),%edx
  800c86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c89:	89 c3                	mov    %eax,%ebx
  800c8b:	89 c7                	mov    %eax,%edi
  800c8d:	89 c6                	mov    %eax,%esi
  800c8f:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c91:	5b                   	pop    %ebx
  800c92:	5e                   	pop    %esi
  800c93:	5f                   	pop    %edi
  800c94:	5d                   	pop    %ebp
  800c95:	c3                   	ret    

00800c96 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c96:	55                   	push   %ebp
  800c97:	89 e5                	mov    %esp,%ebp
  800c99:	57                   	push   %edi
  800c9a:	56                   	push   %esi
  800c9b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c9c:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca1:	b8 01 00 00 00       	mov    $0x1,%eax
  800ca6:	89 d1                	mov    %edx,%ecx
  800ca8:	89 d3                	mov    %edx,%ebx
  800caa:	89 d7                	mov    %edx,%edi
  800cac:	89 d6                	mov    %edx,%esi
  800cae:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cb0:	5b                   	pop    %ebx
  800cb1:	5e                   	pop    %esi
  800cb2:	5f                   	pop    %edi
  800cb3:	5d                   	pop    %ebp
  800cb4:	c3                   	ret    

00800cb5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
  800cb8:	57                   	push   %edi
  800cb9:	56                   	push   %esi
  800cba:	53                   	push   %ebx
  800cbb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cbe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc6:	b8 03 00 00 00       	mov    $0x3,%eax
  800ccb:	89 cb                	mov    %ecx,%ebx
  800ccd:	89 cf                	mov    %ecx,%edi
  800ccf:	89 ce                	mov    %ecx,%esi
  800cd1:	cd 30                	int    $0x30
	if (check && ret > 0)
  800cd3:	85 c0                	test   %eax,%eax
  800cd5:	7f 08                	jg     800cdf <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cda:	5b                   	pop    %ebx
  800cdb:	5e                   	pop    %esi
  800cdc:	5f                   	pop    %edi
  800cdd:	5d                   	pop    %ebp
  800cde:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cdf:	83 ec 0c             	sub    $0xc,%esp
  800ce2:	50                   	push   %eax
  800ce3:	6a 03                	push   $0x3
  800ce5:	68 80 1a 80 00       	push   $0x801a80
  800cea:	6a 4c                	push   $0x4c
  800cec:	68 9d 1a 80 00       	push   $0x801a9d
  800cf1:	e8 4b f4 ff ff       	call   800141 <_panic>

00800cf6 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
  800cf9:	57                   	push   %edi
  800cfa:	56                   	push   %esi
  800cfb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cfc:	ba 00 00 00 00       	mov    $0x0,%edx
  800d01:	b8 02 00 00 00       	mov    $0x2,%eax
  800d06:	89 d1                	mov    %edx,%ecx
  800d08:	89 d3                	mov    %edx,%ebx
  800d0a:	89 d7                	mov    %edx,%edi
  800d0c:	89 d6                	mov    %edx,%esi
  800d0e:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d10:	5b                   	pop    %ebx
  800d11:	5e                   	pop    %esi
  800d12:	5f                   	pop    %edi
  800d13:	5d                   	pop    %ebp
  800d14:	c3                   	ret    

00800d15 <sys_yield>:

void
sys_yield(void)
{
  800d15:	55                   	push   %ebp
  800d16:	89 e5                	mov    %esp,%ebp
  800d18:	57                   	push   %edi
  800d19:	56                   	push   %esi
  800d1a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d1b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d20:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d25:	89 d1                	mov    %edx,%ecx
  800d27:	89 d3                	mov    %edx,%ebx
  800d29:	89 d7                	mov    %edx,%edi
  800d2b:	89 d6                	mov    %edx,%esi
  800d2d:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d2f:	5b                   	pop    %ebx
  800d30:	5e                   	pop    %esi
  800d31:	5f                   	pop    %edi
  800d32:	5d                   	pop    %ebp
  800d33:	c3                   	ret    

00800d34 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
  800d37:	57                   	push   %edi
  800d38:	56                   	push   %esi
  800d39:	53                   	push   %ebx
  800d3a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d3d:	be 00 00 00 00       	mov    $0x0,%esi
  800d42:	8b 55 08             	mov    0x8(%ebp),%edx
  800d45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d48:	b8 04 00 00 00       	mov    $0x4,%eax
  800d4d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d50:	89 f7                	mov    %esi,%edi
  800d52:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d54:	85 c0                	test   %eax,%eax
  800d56:	7f 08                	jg     800d60 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d58:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d5b:	5b                   	pop    %ebx
  800d5c:	5e                   	pop    %esi
  800d5d:	5f                   	pop    %edi
  800d5e:	5d                   	pop    %ebp
  800d5f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d60:	83 ec 0c             	sub    $0xc,%esp
  800d63:	50                   	push   %eax
  800d64:	6a 04                	push   $0x4
  800d66:	68 80 1a 80 00       	push   $0x801a80
  800d6b:	6a 4c                	push   $0x4c
  800d6d:	68 9d 1a 80 00       	push   $0x801a9d
  800d72:	e8 ca f3 ff ff       	call   800141 <_panic>

00800d77 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d77:	55                   	push   %ebp
  800d78:	89 e5                	mov    %esp,%ebp
  800d7a:	57                   	push   %edi
  800d7b:	56                   	push   %esi
  800d7c:	53                   	push   %ebx
  800d7d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d80:	8b 55 08             	mov    0x8(%ebp),%edx
  800d83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d86:	b8 05 00 00 00       	mov    $0x5,%eax
  800d8b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d8e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d91:	8b 75 18             	mov    0x18(%ebp),%esi
  800d94:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d96:	85 c0                	test   %eax,%eax
  800d98:	7f 08                	jg     800da2 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9d:	5b                   	pop    %ebx
  800d9e:	5e                   	pop    %esi
  800d9f:	5f                   	pop    %edi
  800da0:	5d                   	pop    %ebp
  800da1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da2:	83 ec 0c             	sub    $0xc,%esp
  800da5:	50                   	push   %eax
  800da6:	6a 05                	push   $0x5
  800da8:	68 80 1a 80 00       	push   $0x801a80
  800dad:	6a 4c                	push   $0x4c
  800daf:	68 9d 1a 80 00       	push   $0x801a9d
  800db4:	e8 88 f3 ff ff       	call   800141 <_panic>

00800db9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800db9:	55                   	push   %ebp
  800dba:	89 e5                	mov    %esp,%ebp
  800dbc:	57                   	push   %edi
  800dbd:	56                   	push   %esi
  800dbe:	53                   	push   %ebx
  800dbf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc7:	8b 55 08             	mov    0x8(%ebp),%edx
  800dca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dcd:	b8 06 00 00 00       	mov    $0x6,%eax
  800dd2:	89 df                	mov    %ebx,%edi
  800dd4:	89 de                	mov    %ebx,%esi
  800dd6:	cd 30                	int    $0x30
	if (check && ret > 0)
  800dd8:	85 c0                	test   %eax,%eax
  800dda:	7f 08                	jg     800de4 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ddc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ddf:	5b                   	pop    %ebx
  800de0:	5e                   	pop    %esi
  800de1:	5f                   	pop    %edi
  800de2:	5d                   	pop    %ebp
  800de3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de4:	83 ec 0c             	sub    $0xc,%esp
  800de7:	50                   	push   %eax
  800de8:	6a 06                	push   $0x6
  800dea:	68 80 1a 80 00       	push   $0x801a80
  800def:	6a 4c                	push   $0x4c
  800df1:	68 9d 1a 80 00       	push   $0x801a9d
  800df6:	e8 46 f3 ff ff       	call   800141 <_panic>

00800dfb <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	57                   	push   %edi
  800dff:	56                   	push   %esi
  800e00:	53                   	push   %ebx
  800e01:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e04:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e09:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0f:	b8 08 00 00 00       	mov    $0x8,%eax
  800e14:	89 df                	mov    %ebx,%edi
  800e16:	89 de                	mov    %ebx,%esi
  800e18:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e1a:	85 c0                	test   %eax,%eax
  800e1c:	7f 08                	jg     800e26 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e21:	5b                   	pop    %ebx
  800e22:	5e                   	pop    %esi
  800e23:	5f                   	pop    %edi
  800e24:	5d                   	pop    %ebp
  800e25:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e26:	83 ec 0c             	sub    $0xc,%esp
  800e29:	50                   	push   %eax
  800e2a:	6a 08                	push   $0x8
  800e2c:	68 80 1a 80 00       	push   $0x801a80
  800e31:	6a 4c                	push   $0x4c
  800e33:	68 9d 1a 80 00       	push   $0x801a9d
  800e38:	e8 04 f3 ff ff       	call   800141 <_panic>

00800e3d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e3d:	55                   	push   %ebp
  800e3e:	89 e5                	mov    %esp,%ebp
  800e40:	57                   	push   %edi
  800e41:	56                   	push   %esi
  800e42:	53                   	push   %ebx
  800e43:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e46:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e51:	b8 09 00 00 00       	mov    $0x9,%eax
  800e56:	89 df                	mov    %ebx,%edi
  800e58:	89 de                	mov    %ebx,%esi
  800e5a:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e5c:	85 c0                	test   %eax,%eax
  800e5e:	7f 08                	jg     800e68 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e63:	5b                   	pop    %ebx
  800e64:	5e                   	pop    %esi
  800e65:	5f                   	pop    %edi
  800e66:	5d                   	pop    %ebp
  800e67:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e68:	83 ec 0c             	sub    $0xc,%esp
  800e6b:	50                   	push   %eax
  800e6c:	6a 09                	push   $0x9
  800e6e:	68 80 1a 80 00       	push   $0x801a80
  800e73:	6a 4c                	push   $0x4c
  800e75:	68 9d 1a 80 00       	push   $0x801a9d
  800e7a:	e8 c2 f2 ff ff       	call   800141 <_panic>

00800e7f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e7f:	55                   	push   %ebp
  800e80:	89 e5                	mov    %esp,%ebp
  800e82:	57                   	push   %edi
  800e83:	56                   	push   %esi
  800e84:	53                   	push   %ebx
  800e85:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e88:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e93:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e98:	89 df                	mov    %ebx,%edi
  800e9a:	89 de                	mov    %ebx,%esi
  800e9c:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e9e:	85 c0                	test   %eax,%eax
  800ea0:	7f 08                	jg     800eaa <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ea2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ea5:	5b                   	pop    %ebx
  800ea6:	5e                   	pop    %esi
  800ea7:	5f                   	pop    %edi
  800ea8:	5d                   	pop    %ebp
  800ea9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eaa:	83 ec 0c             	sub    $0xc,%esp
  800ead:	50                   	push   %eax
  800eae:	6a 0a                	push   $0xa
  800eb0:	68 80 1a 80 00       	push   $0x801a80
  800eb5:	6a 4c                	push   $0x4c
  800eb7:	68 9d 1a 80 00       	push   $0x801a9d
  800ebc:	e8 80 f2 ff ff       	call   800141 <_panic>

00800ec1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ec1:	55                   	push   %ebp
  800ec2:	89 e5                	mov    %esp,%ebp
  800ec4:	57                   	push   %edi
  800ec5:	56                   	push   %esi
  800ec6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ec7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ecd:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ed2:	be 00 00 00 00       	mov    $0x0,%esi
  800ed7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eda:	8b 7d 14             	mov    0x14(%ebp),%edi
  800edd:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800edf:	5b                   	pop    %ebx
  800ee0:	5e                   	pop    %esi
  800ee1:	5f                   	pop    %edi
  800ee2:	5d                   	pop    %ebp
  800ee3:	c3                   	ret    

00800ee4 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ee4:	55                   	push   %ebp
  800ee5:	89 e5                	mov    %esp,%ebp
  800ee7:	57                   	push   %edi
  800ee8:	56                   	push   %esi
  800ee9:	53                   	push   %ebx
  800eea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eed:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ef2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef5:	b8 0d 00 00 00       	mov    $0xd,%eax
  800efa:	89 cb                	mov    %ecx,%ebx
  800efc:	89 cf                	mov    %ecx,%edi
  800efe:	89 ce                	mov    %ecx,%esi
  800f00:	cd 30                	int    $0x30
	if (check && ret > 0)
  800f02:	85 c0                	test   %eax,%eax
  800f04:	7f 08                	jg     800f0e <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f06:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f09:	5b                   	pop    %ebx
  800f0a:	5e                   	pop    %esi
  800f0b:	5f                   	pop    %edi
  800f0c:	5d                   	pop    %ebp
  800f0d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f0e:	83 ec 0c             	sub    $0xc,%esp
  800f11:	50                   	push   %eax
  800f12:	6a 0d                	push   $0xd
  800f14:	68 80 1a 80 00       	push   $0x801a80
  800f19:	6a 4c                	push   $0x4c
  800f1b:	68 9d 1a 80 00       	push   $0x801a9d
  800f20:	e8 1c f2 ff ff       	call   800141 <_panic>

00800f25 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f25:	55                   	push   %ebp
  800f26:	89 e5                	mov    %esp,%ebp
  800f28:	57                   	push   %edi
  800f29:	56                   	push   %esi
  800f2a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f2b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f30:	8b 55 08             	mov    0x8(%ebp),%edx
  800f33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f36:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f3b:	89 df                	mov    %ebx,%edi
  800f3d:	89 de                	mov    %ebx,%esi
  800f3f:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f41:	5b                   	pop    %ebx
  800f42:	5e                   	pop    %esi
  800f43:	5f                   	pop    %edi
  800f44:	5d                   	pop    %ebp
  800f45:	c3                   	ret    

00800f46 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	57                   	push   %edi
  800f4a:	56                   	push   %esi
  800f4b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f4c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f51:	8b 55 08             	mov    0x8(%ebp),%edx
  800f54:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f59:	89 cb                	mov    %ecx,%ebx
  800f5b:	89 cf                	mov    %ecx,%edi
  800f5d:	89 ce                	mov    %ecx,%esi
  800f5f:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f61:	5b                   	pop    %ebx
  800f62:	5e                   	pop    %esi
  800f63:	5f                   	pop    %edi
  800f64:	5d                   	pop    %ebp
  800f65:	c3                   	ret    

00800f66 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f66:	55                   	push   %ebp
  800f67:	89 e5                	mov    %esp,%ebp
  800f69:	53                   	push   %ebx
  800f6a:	83 ec 04             	sub    $0x4,%esp
  800f6d:	8b 55 08             	mov    0x8(%ebp),%edx
	// cprintf("pgfault()\n");
	void *addr = (void *) utf->utf_fault_va;
  800f70:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpd[PDX(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_COW))
  800f72:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  800f76:	0f 84 9c 00 00 00    	je     801018 <pgfault+0xb2>
  800f7c:	89 c2                	mov    %eax,%edx
  800f7e:	c1 ea 16             	shr    $0x16,%edx
  800f81:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f88:	f6 c2 01             	test   $0x1,%dl
  800f8b:	0f 84 87 00 00 00    	je     801018 <pgfault+0xb2>
  800f91:	89 c2                	mov    %eax,%edx
  800f93:	c1 ea 0c             	shr    $0xc,%edx
  800f96:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800f9d:	f6 c1 01             	test   $0x1,%cl
  800fa0:	74 76                	je     801018 <pgfault+0xb2>
  800fa2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fa9:	f6 c6 08             	test   $0x8,%dh
  800fac:	74 6a                	je     801018 <pgfault+0xb2>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800fae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fb3:	89 c3                	mov    %eax,%ebx

	r = sys_page_alloc(0, PFTEMP, PTE_P|PTE_U|PTE_W);
  800fb5:	83 ec 04             	sub    $0x4,%esp
  800fb8:	6a 07                	push   $0x7
  800fba:	68 00 f0 7f 00       	push   $0x7ff000
  800fbf:	6a 00                	push   $0x0
  800fc1:	e8 6e fd ff ff       	call   800d34 <sys_page_alloc>
	if(r < 0){
  800fc6:	83 c4 10             	add    $0x10,%esp
  800fc9:	85 c0                	test   %eax,%eax
  800fcb:	78 5f                	js     80102c <pgfault+0xc6>
		panic("pgfault: sys_page_alloc fail, r: %d", r);
	}

	memmove(PFTEMP, addr, PGSIZE);
  800fcd:	83 ec 04             	sub    $0x4,%esp
  800fd0:	68 00 10 00 00       	push   $0x1000
  800fd5:	53                   	push   %ebx
  800fd6:	68 00 f0 7f 00       	push   $0x7ff000
  800fdb:	e8 f0 fa ff ff       	call   800ad0 <memmove>

	r = sys_page_map(0, PFTEMP, 0, addr, PTE_P|PTE_U|PTE_W);
  800fe0:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800fe7:	53                   	push   %ebx
  800fe8:	6a 00                	push   $0x0
  800fea:	68 00 f0 7f 00       	push   $0x7ff000
  800fef:	6a 00                	push   $0x0
  800ff1:	e8 81 fd ff ff       	call   800d77 <sys_page_map>
	if(r < 0){
  800ff6:	83 c4 20             	add    $0x20,%esp
  800ff9:	85 c0                	test   %eax,%eax
  800ffb:	78 41                	js     80103e <pgfault+0xd8>
		panic("pgfault: sys_page_map fail, r: %d", r);
	}

	r = sys_page_unmap(0, PFTEMP);
  800ffd:	83 ec 08             	sub    $0x8,%esp
  801000:	68 00 f0 7f 00       	push   $0x7ff000
  801005:	6a 00                	push   $0x0
  801007:	e8 ad fd ff ff       	call   800db9 <sys_page_unmap>
	if(r < 0){
  80100c:	83 c4 10             	add    $0x10,%esp
  80100f:	85 c0                	test   %eax,%eax
  801011:	78 3d                	js     801050 <pgfault+0xea>
		panic("sys_page_unmap: %e", r);
	}
}
  801013:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801016:	c9                   	leave  
  801017:	c3                   	ret    
		panic("pgfault: 1\n");
  801018:	83 ec 04             	sub    $0x4,%esp
  80101b:	68 ab 1a 80 00       	push   $0x801aab
  801020:	6a 20                	push   $0x20
  801022:	68 b7 1a 80 00       	push   $0x801ab7
  801027:	e8 15 f1 ff ff       	call   800141 <_panic>
		panic("pgfault: sys_page_alloc fail, r: %d", r);
  80102c:	50                   	push   %eax
  80102d:	68 0c 1b 80 00       	push   $0x801b0c
  801032:	6a 2e                	push   $0x2e
  801034:	68 b7 1a 80 00       	push   $0x801ab7
  801039:	e8 03 f1 ff ff       	call   800141 <_panic>
		panic("pgfault: sys_page_map fail, r: %d", r);
  80103e:	50                   	push   %eax
  80103f:	68 30 1b 80 00       	push   $0x801b30
  801044:	6a 35                	push   $0x35
  801046:	68 b7 1a 80 00       	push   $0x801ab7
  80104b:	e8 f1 f0 ff ff       	call   800141 <_panic>
		panic("sys_page_unmap: %e", r);
  801050:	50                   	push   %eax
  801051:	68 c2 1a 80 00       	push   $0x801ac2
  801056:	6a 3a                	push   $0x3a
  801058:	68 b7 1a 80 00       	push   $0x801ab7
  80105d:	e8 df f0 ff ff       	call   800141 <_panic>

00801062 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801062:	55                   	push   %ebp
  801063:	89 e5                	mov    %esp,%ebp
  801065:	57                   	push   %edi
  801066:	56                   	push   %esi
  801067:	53                   	push   %ebx
  801068:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	// panic("fork not implemented");
	int r;
	set_pgfault_handler(pgfault);
  80106b:	68 66 0f 80 00       	push   $0x800f66
  801070:	e8 0d 03 00 00       	call   801382 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801075:	b8 07 00 00 00       	mov    $0x7,%eax
  80107a:	cd 30                	int    $0x30
  80107c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int i;
	uintptr_t va;
	envid_t childid = sys_exofork();
	if (childid < 0){
  80107f:	83 c4 10             	add    $0x10,%esp
  801082:	85 c0                	test   %eax,%eax
  801084:	78 2c                	js     8010b2 <fork+0x50>
  801086:	89 c7                	mov    %eax,%edi
	}

	extern volatile pde_t uvpd[];
	extern volatile pte_t uvpt[];

	for (va = UTEXT; va < USTACKTOP; va += PGSIZE){
  801088:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (childid == 0) {
  80108d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801091:	75 72                	jne    801105 <fork+0xa3>
		thisenv = &envs[ENVX(sys_getenvid())];
  801093:	e8 5e fc ff ff       	call   800cf6 <sys_getenvid>
  801098:	25 ff 03 00 00       	and    $0x3ff,%eax
  80109d:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8010a3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010a8:	a3 08 20 80 00       	mov    %eax,0x802008
		return 0;
  8010ad:	e9 36 01 00 00       	jmp    8011e8 <fork+0x186>
		panic("fork: child id < 0: %d", childid);
  8010b2:	50                   	push   %eax
  8010b3:	68 d5 1a 80 00       	push   $0x801ad5
  8010b8:	68 83 00 00 00       	push   $0x83
  8010bd:	68 b7 1a 80 00       	push   $0x801ab7
  8010c2:	e8 7a f0 ff ff       	call   800141 <_panic>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  8010c7:	50                   	push   %eax
  8010c8:	68 54 1b 80 00       	push   $0x801b54
  8010cd:	6a 56                	push   $0x56
  8010cf:	68 b7 1a 80 00       	push   $0x801ab7
  8010d4:	e8 68 f0 ff ff       	call   800141 <_panic>
		r = sys_page_map((envid_t)0, va, envid, va, PTE_U | PTE_P);
  8010d9:	83 ec 0c             	sub    $0xc,%esp
  8010dc:	6a 05                	push   $0x5
  8010de:	56                   	push   %esi
  8010df:	57                   	push   %edi
  8010e0:	56                   	push   %esi
  8010e1:	6a 00                	push   $0x0
  8010e3:	e8 8f fc ff ff       	call   800d77 <sys_page_map>
		if(r < 0){
  8010e8:	83 c4 20             	add    $0x20,%esp
  8010eb:	85 c0                	test   %eax,%eax
  8010ed:	0f 88 9f 00 00 00    	js     801192 <fork+0x130>
	for (va = UTEXT; va < USTACKTOP; va += PGSIZE){
  8010f3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8010f9:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8010ff:	0f 84 9f 00 00 00    	je     8011a4 <fork+0x142>
		if ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_U)){
  801105:	89 d8                	mov    %ebx,%eax
  801107:	c1 e8 16             	shr    $0x16,%eax
  80110a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801111:	a8 01                	test   $0x1,%al
  801113:	74 de                	je     8010f3 <fork+0x91>
  801115:	89 d8                	mov    %ebx,%eax
  801117:	c1 e8 0c             	shr    $0xc,%eax
  80111a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801121:	f6 c2 01             	test   $0x1,%dl
  801124:	74 cd                	je     8010f3 <fork+0x91>
  801126:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80112d:	f6 c2 04             	test   $0x4,%dl
  801130:	74 c1                	je     8010f3 <fork+0x91>
	void * va = (void *)(pn * PGSIZE);
  801132:	89 c6                	mov    %eax,%esi
  801134:	c1 e6 0c             	shl    $0xc,%esi
	int perm = (uvpt[pn]);
  801137:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (perm & (PTE_W | PTE_COW)) {
  80113e:	a9 02 08 00 00       	test   $0x802,%eax
  801143:	74 94                	je     8010d9 <fork+0x77>
		r = sys_page_map((envid_t)0, va, envid, va, PTE_U | PTE_P | PTE_COW);
  801145:	83 ec 0c             	sub    $0xc,%esp
  801148:	68 05 08 00 00       	push   $0x805
  80114d:	56                   	push   %esi
  80114e:	57                   	push   %edi
  80114f:	56                   	push   %esi
  801150:	6a 00                	push   $0x0
  801152:	e8 20 fc ff ff       	call   800d77 <sys_page_map>
		if(r < 0){
  801157:	83 c4 20             	add    $0x20,%esp
  80115a:	85 c0                	test   %eax,%eax
  80115c:	0f 88 65 ff ff ff    	js     8010c7 <fork+0x65>
		r = sys_page_map((envid_t)0, va, (envid_t)0, va, PTE_U | PTE_P | PTE_COW);
  801162:	83 ec 0c             	sub    $0xc,%esp
  801165:	68 05 08 00 00       	push   $0x805
  80116a:	56                   	push   %esi
  80116b:	6a 00                	push   $0x0
  80116d:	56                   	push   %esi
  80116e:	6a 00                	push   $0x0
  801170:	e8 02 fc ff ff       	call   800d77 <sys_page_map>
		if(r < 0){
  801175:	83 c4 20             	add    $0x20,%esp
  801178:	85 c0                	test   %eax,%eax
  80117a:	0f 89 73 ff ff ff    	jns    8010f3 <fork+0x91>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  801180:	50                   	push   %eax
  801181:	68 54 1b 80 00       	push   $0x801b54
  801186:	6a 5b                	push   $0x5b
  801188:	68 b7 1a 80 00       	push   $0x801ab7
  80118d:	e8 af ef ff ff       	call   800141 <_panic>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  801192:	50                   	push   %eax
  801193:	68 54 1b 80 00       	push   $0x801b54
  801198:	6a 61                	push   $0x61
  80119a:	68 b7 1a 80 00       	push   $0x801ab7
  80119f:	e8 9d ef ff ff       	call   800141 <_panic>
			duppage(childid, PGNUM(va));
		}
	}

	r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8011a4:	83 ec 04             	sub    $0x4,%esp
  8011a7:	6a 07                	push   $0x7
  8011a9:	68 00 f0 bf ee       	push   $0xeebff000
  8011ae:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011b1:	e8 7e fb ff ff       	call   800d34 <sys_page_alloc>
	if (r < 0){
  8011b6:	83 c4 10             	add    $0x10,%esp
  8011b9:	85 c0                	test   %eax,%eax
  8011bb:	78 36                	js     8011f3 <fork+0x191>
		panic("fork: allocate user exception stack for child env error, %d", r);
	}
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  8011bd:	83 ec 08             	sub    $0x8,%esp
  8011c0:	68 ed 13 80 00       	push   $0x8013ed
  8011c5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011c8:	e8 b2 fc ff ff       	call   800e7f <sys_env_set_pgfault_upcall>
	if (r < 0){
  8011cd:	83 c4 10             	add    $0x10,%esp
  8011d0:	85 c0                	test   %eax,%eax
  8011d2:	78 34                	js     801208 <fork+0x1a6>
		panic("fork: sys_env_set_pgfault_upcall error, %d", r);
	}
	r = sys_env_set_status(childid, ENV_RUNNABLE);
  8011d4:	83 ec 08             	sub    $0x8,%esp
  8011d7:	6a 02                	push   $0x2
  8011d9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011dc:	e8 1a fc ff ff       	call   800dfb <sys_env_set_status>
	if(r < 0){
  8011e1:	83 c4 10             	add    $0x10,%esp
  8011e4:	85 c0                	test   %eax,%eax
  8011e6:	78 35                	js     80121d <fork+0x1bb>
		panic("forK: sys_env_set_status, r%d", r);
	}
	return childid;
}
  8011e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011ee:	5b                   	pop    %ebx
  8011ef:	5e                   	pop    %esi
  8011f0:	5f                   	pop    %edi
  8011f1:	5d                   	pop    %ebp
  8011f2:	c3                   	ret    
		panic("fork: allocate user exception stack for child env error, %d", r);
  8011f3:	50                   	push   %eax
  8011f4:	68 7c 1b 80 00       	push   $0x801b7c
  8011f9:	68 96 00 00 00       	push   $0x96
  8011fe:	68 b7 1a 80 00       	push   $0x801ab7
  801203:	e8 39 ef ff ff       	call   800141 <_panic>
		panic("fork: sys_env_set_pgfault_upcall error, %d", r);
  801208:	50                   	push   %eax
  801209:	68 b8 1b 80 00       	push   $0x801bb8
  80120e:	68 9a 00 00 00       	push   $0x9a
  801213:	68 b7 1a 80 00       	push   $0x801ab7
  801218:	e8 24 ef ff ff       	call   800141 <_panic>
		panic("forK: sys_env_set_status, r%d", r);
  80121d:	50                   	push   %eax
  80121e:	68 ec 1a 80 00       	push   $0x801aec
  801223:	68 9e 00 00 00       	push   $0x9e
  801228:	68 b7 1a 80 00       	push   $0x801ab7
  80122d:	e8 0f ef ff ff       	call   800141 <_panic>

00801232 <sfork>:

// Challenge!
int
sfork(void)
{
  801232:	55                   	push   %ebp
  801233:	89 e5                	mov    %esp,%ebp
  801235:	57                   	push   %edi
  801236:	56                   	push   %esi
  801237:	53                   	push   %ebx
  801238:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// return -E_INVAL;
	set_pgfault_handler(pgfault);
  80123b:	68 66 0f 80 00       	push   $0x800f66
  801240:	e8 3d 01 00 00       	call   801382 <set_pgfault_handler>
  801245:	b8 07 00 00 00       	mov    $0x7,%eax
  80124a:	cd 30                	int    $0x30
  80124c:	89 c6                	mov    %eax,%esi
	int i;
	uintptr_t va;
	envid_t childid = sys_exofork();
	int r;
	if (childid < 0){
  80124e:	83 c4 10             	add    $0x10,%esp
  801251:	85 c0                	test   %eax,%eax
  801253:	78 28                	js     80127d <sfork+0x4b>
  801255:	89 c7                	mov    %eax,%edi
	}

	extern volatile pde_t uvpd[];
	extern volatile pte_t uvpt[];

	for (va = 0; va < USTACKTOP; va += PGSIZE){
  801257:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (childid == 0) {
  80125c:	75 42                	jne    8012a0 <sfork+0x6e>
		thisenv = &envs[ENVX(sys_getenvid())];
  80125e:	e8 93 fa ff ff       	call   800cf6 <sys_getenvid>
  801263:	25 ff 03 00 00       	and    $0x3ff,%eax
  801268:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80126e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801273:	a3 08 20 80 00       	mov    %eax,0x802008
		return 0;
  801278:	e9 bc 00 00 00       	jmp    801339 <sfork+0x107>
		panic("fork: child id < 0: %d", childid);
  80127d:	50                   	push   %eax
  80127e:	68 d5 1a 80 00       	push   $0x801ad5
  801283:	68 af 00 00 00       	push   $0xaf
  801288:	68 b7 1a 80 00       	push   $0x801ab7
  80128d:	e8 af ee ff ff       	call   800141 <_panic>
	for (va = 0; va < USTACKTOP; va += PGSIZE){
  801292:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801298:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80129e:	74 5b                	je     8012fb <sfork+0xc9>
		if ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_U)){
  8012a0:	89 d8                	mov    %ebx,%eax
  8012a2:	c1 e8 16             	shr    $0x16,%eax
  8012a5:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012ac:	a8 01                	test   $0x1,%al
  8012ae:	74 e2                	je     801292 <sfork+0x60>
  8012b0:	89 d8                	mov    %ebx,%eax
  8012b2:	c1 e8 0c             	shr    $0xc,%eax
  8012b5:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012bc:	f6 c2 01             	test   $0x1,%dl
  8012bf:	74 d1                	je     801292 <sfork+0x60>
  8012c1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012c8:	f6 c2 04             	test   $0x4,%dl
  8012cb:	74 c5                	je     801292 <sfork+0x60>
			void *addr = (void *)(PGNUM(va) * PGSIZE);
  8012cd:	c1 e0 0c             	shl    $0xc,%eax
			struct PageInfo *page;
			pte_t *pte;
			
			// page = page_lookup((envid_t)0->env_pgdir, addr, &pte);
			// page_insert(dstenv->env_pgdir, page, addr, PTE_U | PTE_P);
			r = sys_page_map((envid_t)0, addr, childid, addr, PTE_U | PTE_P);
  8012d0:	83 ec 0c             	sub    $0xc,%esp
  8012d3:	6a 05                	push   $0x5
  8012d5:	50                   	push   %eax
  8012d6:	57                   	push   %edi
  8012d7:	50                   	push   %eax
  8012d8:	6a 00                	push   $0x0
  8012da:	e8 98 fa ff ff       	call   800d77 <sys_page_map>
			if(r < 0){
  8012df:	83 c4 20             	add    $0x20,%esp
  8012e2:	85 c0                	test   %eax,%eax
  8012e4:	79 ac                	jns    801292 <sfork+0x60>
				panic("sfork: sys_page_map fail, r:%d\n", r);
  8012e6:	50                   	push   %eax
  8012e7:	68 e4 1b 80 00       	push   $0x801be4
  8012ec:	68 c4 00 00 00       	push   $0xc4
  8012f1:	68 b7 1a 80 00       	push   $0x801ab7
  8012f6:	e8 46 ee ff ff       	call   800141 <_panic>
			}
		}
	}

	r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8012fb:	83 ec 04             	sub    $0x4,%esp
  8012fe:	6a 07                	push   $0x7
  801300:	68 00 f0 bf ee       	push   $0xeebff000
  801305:	56                   	push   %esi
  801306:	e8 29 fa ff ff       	call   800d34 <sys_page_alloc>
	if (r < 0){
  80130b:	83 c4 10             	add    $0x10,%esp
  80130e:	85 c0                	test   %eax,%eax
  801310:	78 31                	js     801343 <sfork+0x111>
		panic("sfork: allocate user exception stack for child env error, %d", r);
	}
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  801312:	83 ec 08             	sub    $0x8,%esp
  801315:	68 ed 13 80 00       	push   $0x8013ed
  80131a:	56                   	push   %esi
  80131b:	e8 5f fb ff ff       	call   800e7f <sys_env_set_pgfault_upcall>
	if (r < 0){
  801320:	83 c4 10             	add    $0x10,%esp
  801323:	85 c0                	test   %eax,%eax
  801325:	78 31                	js     801358 <sfork+0x126>
		panic("sfork: sys_env_set_pgfault_upcall error, %d", r);
	}
	r = sys_env_set_status(childid, ENV_RUNNABLE);
  801327:	83 ec 08             	sub    $0x8,%esp
  80132a:	6a 02                	push   $0x2
  80132c:	56                   	push   %esi
  80132d:	e8 c9 fa ff ff       	call   800dfb <sys_env_set_status>
	if(r < 0){
  801332:	83 c4 10             	add    $0x10,%esp
  801335:	85 c0                	test   %eax,%eax
  801337:	78 34                	js     80136d <sfork+0x13b>
		panic("sforK: sys_env_set_status, r%d", r);
	}
	return childid;
}
  801339:	89 f0                	mov    %esi,%eax
  80133b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80133e:	5b                   	pop    %ebx
  80133f:	5e                   	pop    %esi
  801340:	5f                   	pop    %edi
  801341:	5d                   	pop    %ebp
  801342:	c3                   	ret    
		panic("sfork: allocate user exception stack for child env error, %d", r);
  801343:	50                   	push   %eax
  801344:	68 04 1c 80 00       	push   $0x801c04
  801349:	68 cb 00 00 00       	push   $0xcb
  80134e:	68 b7 1a 80 00       	push   $0x801ab7
  801353:	e8 e9 ed ff ff       	call   800141 <_panic>
		panic("sfork: sys_env_set_pgfault_upcall error, %d", r);
  801358:	50                   	push   %eax
  801359:	68 44 1c 80 00       	push   $0x801c44
  80135e:	68 cf 00 00 00       	push   $0xcf
  801363:	68 b7 1a 80 00       	push   $0x801ab7
  801368:	e8 d4 ed ff ff       	call   800141 <_panic>
		panic("sforK: sys_env_set_status, r%d", r);
  80136d:	50                   	push   %eax
  80136e:	68 70 1c 80 00       	push   $0x801c70
  801373:	68 d3 00 00 00       	push   $0xd3
  801378:	68 b7 1a 80 00       	push   $0x801ab7
  80137d:	e8 bf ed ff ff       	call   800141 <_panic>

00801382 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801382:	55                   	push   %ebp
  801383:	89 e5                	mov    %esp,%ebp
  801385:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801388:	83 3d 0c 20 80 00 00 	cmpl   $0x0,0x80200c
  80138f:	74 0a                	je     80139b <set_pgfault_handler+0x19>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801391:	8b 45 08             	mov    0x8(%ebp),%eax
  801394:	a3 0c 20 80 00       	mov    %eax,0x80200c
}
  801399:	c9                   	leave  
  80139a:	c3                   	ret    
		ret = sys_page_alloc((envid_t)0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W);
  80139b:	83 ec 04             	sub    $0x4,%esp
  80139e:	6a 07                	push   $0x7
  8013a0:	68 00 f0 bf ee       	push   $0xeebff000
  8013a5:	6a 00                	push   $0x0
  8013a7:	e8 88 f9 ff ff       	call   800d34 <sys_page_alloc>
		if(ret < 0){
  8013ac:	83 c4 10             	add    $0x10,%esp
  8013af:	85 c0                	test   %eax,%eax
  8013b1:	78 28                	js     8013db <set_pgfault_handler+0x59>
    	ret = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8013b3:	83 ec 08             	sub    $0x8,%esp
  8013b6:	68 ed 13 80 00       	push   $0x8013ed
  8013bb:	6a 00                	push   $0x0
  8013bd:	e8 bd fa ff ff       	call   800e7f <sys_env_set_pgfault_upcall>
		if(ret < 0){
  8013c2:	83 c4 10             	add    $0x10,%esp
  8013c5:	85 c0                	test   %eax,%eax
  8013c7:	79 c8                	jns    801391 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
  8013c9:	50                   	push   %eax
  8013ca:	68 c4 1c 80 00       	push   $0x801cc4
  8013cf:	6a 28                	push   $0x28
  8013d1:	68 04 1d 80 00       	push   $0x801d04
  8013d6:	e8 66 ed ff ff       	call   800141 <_panic>
			panic("set_pgfault_handler: sys_page_alloc fail, ret:%d", ret);
  8013db:	50                   	push   %eax
  8013dc:	68 90 1c 80 00       	push   $0x801c90
  8013e1:	6a 24                	push   $0x24
  8013e3:	68 04 1d 80 00       	push   $0x801d04
  8013e8:	e8 54 ed ff ff       	call   800141 <_panic>

008013ed <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8013ed:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8013ee:	a1 0c 20 80 00       	mov    0x80200c,%eax
	call *%eax
  8013f3:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8013f5:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edi
  8013f8:	8b 7c 24 28          	mov    0x28(%esp),%edi
	movl 0x30(%esp), %esi
  8013fc:	8b 74 24 30          	mov    0x30(%esp),%esi
	subl $4, %esi
  801400:	83 ee 04             	sub    $0x4,%esi
	movl %edi, (%esi)
  801403:	89 3e                	mov    %edi,(%esi)
	movl %esi, 0x30(%esp)
  801405:	89 74 24 30          	mov    %esi,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  801409:	83 c4 08             	add    $0x8,%esp
	popal
  80140c:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80140d:	83 c4 04             	add    $0x4,%esp
	popfl
  801410:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801411:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  801412:	c3                   	ret    
  801413:	66 90                	xchg   %ax,%ax
  801415:	66 90                	xchg   %ax,%ax
  801417:	66 90                	xchg   %ax,%ax
  801419:	66 90                	xchg   %ax,%ax
  80141b:	66 90                	xchg   %ax,%ax
  80141d:	66 90                	xchg   %ax,%ax
  80141f:	90                   	nop

00801420 <__udivdi3>:
  801420:	55                   	push   %ebp
  801421:	57                   	push   %edi
  801422:	56                   	push   %esi
  801423:	53                   	push   %ebx
  801424:	83 ec 1c             	sub    $0x1c,%esp
  801427:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80142b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80142f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801433:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801437:	85 d2                	test   %edx,%edx
  801439:	75 4d                	jne    801488 <__udivdi3+0x68>
  80143b:	39 f3                	cmp    %esi,%ebx
  80143d:	76 19                	jbe    801458 <__udivdi3+0x38>
  80143f:	31 ff                	xor    %edi,%edi
  801441:	89 e8                	mov    %ebp,%eax
  801443:	89 f2                	mov    %esi,%edx
  801445:	f7 f3                	div    %ebx
  801447:	89 fa                	mov    %edi,%edx
  801449:	83 c4 1c             	add    $0x1c,%esp
  80144c:	5b                   	pop    %ebx
  80144d:	5e                   	pop    %esi
  80144e:	5f                   	pop    %edi
  80144f:	5d                   	pop    %ebp
  801450:	c3                   	ret    
  801451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801458:	89 d9                	mov    %ebx,%ecx
  80145a:	85 db                	test   %ebx,%ebx
  80145c:	75 0b                	jne    801469 <__udivdi3+0x49>
  80145e:	b8 01 00 00 00       	mov    $0x1,%eax
  801463:	31 d2                	xor    %edx,%edx
  801465:	f7 f3                	div    %ebx
  801467:	89 c1                	mov    %eax,%ecx
  801469:	31 d2                	xor    %edx,%edx
  80146b:	89 f0                	mov    %esi,%eax
  80146d:	f7 f1                	div    %ecx
  80146f:	89 c6                	mov    %eax,%esi
  801471:	89 e8                	mov    %ebp,%eax
  801473:	89 f7                	mov    %esi,%edi
  801475:	f7 f1                	div    %ecx
  801477:	89 fa                	mov    %edi,%edx
  801479:	83 c4 1c             	add    $0x1c,%esp
  80147c:	5b                   	pop    %ebx
  80147d:	5e                   	pop    %esi
  80147e:	5f                   	pop    %edi
  80147f:	5d                   	pop    %ebp
  801480:	c3                   	ret    
  801481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801488:	39 f2                	cmp    %esi,%edx
  80148a:	77 1c                	ja     8014a8 <__udivdi3+0x88>
  80148c:	0f bd fa             	bsr    %edx,%edi
  80148f:	83 f7 1f             	xor    $0x1f,%edi
  801492:	75 2c                	jne    8014c0 <__udivdi3+0xa0>
  801494:	39 f2                	cmp    %esi,%edx
  801496:	72 06                	jb     80149e <__udivdi3+0x7e>
  801498:	31 c0                	xor    %eax,%eax
  80149a:	39 eb                	cmp    %ebp,%ebx
  80149c:	77 a9                	ja     801447 <__udivdi3+0x27>
  80149e:	b8 01 00 00 00       	mov    $0x1,%eax
  8014a3:	eb a2                	jmp    801447 <__udivdi3+0x27>
  8014a5:	8d 76 00             	lea    0x0(%esi),%esi
  8014a8:	31 ff                	xor    %edi,%edi
  8014aa:	31 c0                	xor    %eax,%eax
  8014ac:	89 fa                	mov    %edi,%edx
  8014ae:	83 c4 1c             	add    $0x1c,%esp
  8014b1:	5b                   	pop    %ebx
  8014b2:	5e                   	pop    %esi
  8014b3:	5f                   	pop    %edi
  8014b4:	5d                   	pop    %ebp
  8014b5:	c3                   	ret    
  8014b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8014bd:	8d 76 00             	lea    0x0(%esi),%esi
  8014c0:	89 f9                	mov    %edi,%ecx
  8014c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8014c7:	29 f8                	sub    %edi,%eax
  8014c9:	d3 e2                	shl    %cl,%edx
  8014cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8014cf:	89 c1                	mov    %eax,%ecx
  8014d1:	89 da                	mov    %ebx,%edx
  8014d3:	d3 ea                	shr    %cl,%edx
  8014d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8014d9:	09 d1                	or     %edx,%ecx
  8014db:	89 f2                	mov    %esi,%edx
  8014dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014e1:	89 f9                	mov    %edi,%ecx
  8014e3:	d3 e3                	shl    %cl,%ebx
  8014e5:	89 c1                	mov    %eax,%ecx
  8014e7:	d3 ea                	shr    %cl,%edx
  8014e9:	89 f9                	mov    %edi,%ecx
  8014eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8014ef:	89 eb                	mov    %ebp,%ebx
  8014f1:	d3 e6                	shl    %cl,%esi
  8014f3:	89 c1                	mov    %eax,%ecx
  8014f5:	d3 eb                	shr    %cl,%ebx
  8014f7:	09 de                	or     %ebx,%esi
  8014f9:	89 f0                	mov    %esi,%eax
  8014fb:	f7 74 24 08          	divl   0x8(%esp)
  8014ff:	89 d6                	mov    %edx,%esi
  801501:	89 c3                	mov    %eax,%ebx
  801503:	f7 64 24 0c          	mull   0xc(%esp)
  801507:	39 d6                	cmp    %edx,%esi
  801509:	72 15                	jb     801520 <__udivdi3+0x100>
  80150b:	89 f9                	mov    %edi,%ecx
  80150d:	d3 e5                	shl    %cl,%ebp
  80150f:	39 c5                	cmp    %eax,%ebp
  801511:	73 04                	jae    801517 <__udivdi3+0xf7>
  801513:	39 d6                	cmp    %edx,%esi
  801515:	74 09                	je     801520 <__udivdi3+0x100>
  801517:	89 d8                	mov    %ebx,%eax
  801519:	31 ff                	xor    %edi,%edi
  80151b:	e9 27 ff ff ff       	jmp    801447 <__udivdi3+0x27>
  801520:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801523:	31 ff                	xor    %edi,%edi
  801525:	e9 1d ff ff ff       	jmp    801447 <__udivdi3+0x27>
  80152a:	66 90                	xchg   %ax,%ax
  80152c:	66 90                	xchg   %ax,%ax
  80152e:	66 90                	xchg   %ax,%ax

00801530 <__umoddi3>:
  801530:	55                   	push   %ebp
  801531:	57                   	push   %edi
  801532:	56                   	push   %esi
  801533:	53                   	push   %ebx
  801534:	83 ec 1c             	sub    $0x1c,%esp
  801537:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80153b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80153f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801543:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801547:	89 da                	mov    %ebx,%edx
  801549:	85 c0                	test   %eax,%eax
  80154b:	75 43                	jne    801590 <__umoddi3+0x60>
  80154d:	39 df                	cmp    %ebx,%edi
  80154f:	76 17                	jbe    801568 <__umoddi3+0x38>
  801551:	89 f0                	mov    %esi,%eax
  801553:	f7 f7                	div    %edi
  801555:	89 d0                	mov    %edx,%eax
  801557:	31 d2                	xor    %edx,%edx
  801559:	83 c4 1c             	add    $0x1c,%esp
  80155c:	5b                   	pop    %ebx
  80155d:	5e                   	pop    %esi
  80155e:	5f                   	pop    %edi
  80155f:	5d                   	pop    %ebp
  801560:	c3                   	ret    
  801561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801568:	89 fd                	mov    %edi,%ebp
  80156a:	85 ff                	test   %edi,%edi
  80156c:	75 0b                	jne    801579 <__umoddi3+0x49>
  80156e:	b8 01 00 00 00       	mov    $0x1,%eax
  801573:	31 d2                	xor    %edx,%edx
  801575:	f7 f7                	div    %edi
  801577:	89 c5                	mov    %eax,%ebp
  801579:	89 d8                	mov    %ebx,%eax
  80157b:	31 d2                	xor    %edx,%edx
  80157d:	f7 f5                	div    %ebp
  80157f:	89 f0                	mov    %esi,%eax
  801581:	f7 f5                	div    %ebp
  801583:	89 d0                	mov    %edx,%eax
  801585:	eb d0                	jmp    801557 <__umoddi3+0x27>
  801587:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80158e:	66 90                	xchg   %ax,%ax
  801590:	89 f1                	mov    %esi,%ecx
  801592:	39 d8                	cmp    %ebx,%eax
  801594:	76 0a                	jbe    8015a0 <__umoddi3+0x70>
  801596:	89 f0                	mov    %esi,%eax
  801598:	83 c4 1c             	add    $0x1c,%esp
  80159b:	5b                   	pop    %ebx
  80159c:	5e                   	pop    %esi
  80159d:	5f                   	pop    %edi
  80159e:	5d                   	pop    %ebp
  80159f:	c3                   	ret    
  8015a0:	0f bd e8             	bsr    %eax,%ebp
  8015a3:	83 f5 1f             	xor    $0x1f,%ebp
  8015a6:	75 20                	jne    8015c8 <__umoddi3+0x98>
  8015a8:	39 d8                	cmp    %ebx,%eax
  8015aa:	0f 82 b0 00 00 00    	jb     801660 <__umoddi3+0x130>
  8015b0:	39 f7                	cmp    %esi,%edi
  8015b2:	0f 86 a8 00 00 00    	jbe    801660 <__umoddi3+0x130>
  8015b8:	89 c8                	mov    %ecx,%eax
  8015ba:	83 c4 1c             	add    $0x1c,%esp
  8015bd:	5b                   	pop    %ebx
  8015be:	5e                   	pop    %esi
  8015bf:	5f                   	pop    %edi
  8015c0:	5d                   	pop    %ebp
  8015c1:	c3                   	ret    
  8015c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8015c8:	89 e9                	mov    %ebp,%ecx
  8015ca:	ba 20 00 00 00       	mov    $0x20,%edx
  8015cf:	29 ea                	sub    %ebp,%edx
  8015d1:	d3 e0                	shl    %cl,%eax
  8015d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015d7:	89 d1                	mov    %edx,%ecx
  8015d9:	89 f8                	mov    %edi,%eax
  8015db:	d3 e8                	shr    %cl,%eax
  8015dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8015e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8015e5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8015e9:	09 c1                	or     %eax,%ecx
  8015eb:	89 d8                	mov    %ebx,%eax
  8015ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015f1:	89 e9                	mov    %ebp,%ecx
  8015f3:	d3 e7                	shl    %cl,%edi
  8015f5:	89 d1                	mov    %edx,%ecx
  8015f7:	d3 e8                	shr    %cl,%eax
  8015f9:	89 e9                	mov    %ebp,%ecx
  8015fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8015ff:	d3 e3                	shl    %cl,%ebx
  801601:	89 c7                	mov    %eax,%edi
  801603:	89 d1                	mov    %edx,%ecx
  801605:	89 f0                	mov    %esi,%eax
  801607:	d3 e8                	shr    %cl,%eax
  801609:	89 e9                	mov    %ebp,%ecx
  80160b:	89 fa                	mov    %edi,%edx
  80160d:	d3 e6                	shl    %cl,%esi
  80160f:	09 d8                	or     %ebx,%eax
  801611:	f7 74 24 08          	divl   0x8(%esp)
  801615:	89 d1                	mov    %edx,%ecx
  801617:	89 f3                	mov    %esi,%ebx
  801619:	f7 64 24 0c          	mull   0xc(%esp)
  80161d:	89 c6                	mov    %eax,%esi
  80161f:	89 d7                	mov    %edx,%edi
  801621:	39 d1                	cmp    %edx,%ecx
  801623:	72 06                	jb     80162b <__umoddi3+0xfb>
  801625:	75 10                	jne    801637 <__umoddi3+0x107>
  801627:	39 c3                	cmp    %eax,%ebx
  801629:	73 0c                	jae    801637 <__umoddi3+0x107>
  80162b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80162f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801633:	89 d7                	mov    %edx,%edi
  801635:	89 c6                	mov    %eax,%esi
  801637:	89 ca                	mov    %ecx,%edx
  801639:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80163e:	29 f3                	sub    %esi,%ebx
  801640:	19 fa                	sbb    %edi,%edx
  801642:	89 d0                	mov    %edx,%eax
  801644:	d3 e0                	shl    %cl,%eax
  801646:	89 e9                	mov    %ebp,%ecx
  801648:	d3 eb                	shr    %cl,%ebx
  80164a:	d3 ea                	shr    %cl,%edx
  80164c:	09 d8                	or     %ebx,%eax
  80164e:	83 c4 1c             	add    $0x1c,%esp
  801651:	5b                   	pop    %ebx
  801652:	5e                   	pop    %esi
  801653:	5f                   	pop    %edi
  801654:	5d                   	pop    %ebp
  801655:	c3                   	ret    
  801656:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80165d:	8d 76 00             	lea    0x0(%esi),%esi
  801660:	89 da                	mov    %ebx,%edx
  801662:	29 fe                	sub    %edi,%esi
  801664:	19 c2                	sbb    %eax,%edx
  801666:	89 f1                	mov    %esi,%ecx
  801668:	89 c8                	mov    %ecx,%eax
  80166a:	e9 4b ff ff ff       	jmp    8015ba <__umoddi3+0x8a>
