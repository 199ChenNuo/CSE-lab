
obj/user/primes.debug:     file format elf32-i386


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
  80002c:	e8 c5 00 00 00       	call   8000f6 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  80003c:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80003f:	83 ec 04             	sub    $0x4,%esp
  800042:	6a 00                	push   $0x0
  800044:	6a 00                	push   $0x0
  800046:	56                   	push   %esi
  800047:	e8 46 13 00 00       	call   801392 <ipc_recv>
  80004c:	89 c3                	mov    %eax,%ebx
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  80004e:	a1 04 20 80 00       	mov    0x802004,%eax
  800053:	8b 40 5c             	mov    0x5c(%eax),%eax
  800056:	83 c4 0c             	add    $0xc,%esp
  800059:	53                   	push   %ebx
  80005a:	50                   	push   %eax
  80005b:	68 80 17 80 00       	push   $0x801780
  800060:	e8 c7 01 00 00       	call   80022c <cprintf>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  800065:	e8 08 10 00 00       	call   801072 <fork>
  80006a:	89 c7                	mov    %eax,%edi
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	85 c0                	test   %eax,%eax
  800071:	78 07                	js     80007a <primeproc+0x47>
		panic("fork: %e", id);
	if (id == 0)
  800073:	74 ca                	je     80003f <primeproc+0xc>
		goto top;

	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  800075:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  800078:	eb 20                	jmp    80009a <primeproc+0x67>
		panic("fork: %e", id);
  80007a:	50                   	push   %eax
  80007b:	68 8c 17 80 00       	push   $0x80178c
  800080:	6a 1a                	push   $0x1a
  800082:	68 95 17 80 00       	push   $0x801795
  800087:	e8 c5 00 00 00       	call   800151 <_panic>
		if (i % p)
			ipc_send(id, i, 0, 0);
  80008c:	6a 00                	push   $0x0
  80008e:	6a 00                	push   $0x0
  800090:	51                   	push   %ecx
  800091:	57                   	push   %edi
  800092:	e8 64 13 00 00       	call   8013fb <ipc_send>
  800097:	83 c4 10             	add    $0x10,%esp
		i = ipc_recv(&envid, 0, 0);
  80009a:	83 ec 04             	sub    $0x4,%esp
  80009d:	6a 00                	push   $0x0
  80009f:	6a 00                	push   $0x0
  8000a1:	56                   	push   %esi
  8000a2:	e8 eb 12 00 00       	call   801392 <ipc_recv>
  8000a7:	89 c1                	mov    %eax,%ecx
		if (i % p)
  8000a9:	99                   	cltd   
  8000aa:	f7 fb                	idiv   %ebx
  8000ac:	83 c4 10             	add    $0x10,%esp
  8000af:	85 d2                	test   %edx,%edx
  8000b1:	74 e7                	je     80009a <primeproc+0x67>
  8000b3:	eb d7                	jmp    80008c <primeproc+0x59>

008000b5 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  8000ba:	e8 b3 0f 00 00       	call   801072 <fork>
  8000bf:	89 c6                	mov    %eax,%esi
  8000c1:	85 c0                	test   %eax,%eax
  8000c3:	78 1a                	js     8000df <umain+0x2a>
		panic("fork: %e", id);
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
  8000c5:	bb 02 00 00 00       	mov    $0x2,%ebx
	if (id == 0)
  8000ca:	74 25                	je     8000f1 <umain+0x3c>
		ipc_send(id, i, 0, 0);
  8000cc:	6a 00                	push   $0x0
  8000ce:	6a 00                	push   $0x0
  8000d0:	53                   	push   %ebx
  8000d1:	56                   	push   %esi
  8000d2:	e8 24 13 00 00       	call   8013fb <ipc_send>
	for (i = 2; ; i++)
  8000d7:	83 c3 01             	add    $0x1,%ebx
  8000da:	83 c4 10             	add    $0x10,%esp
  8000dd:	eb ed                	jmp    8000cc <umain+0x17>
		panic("fork: %e", id);
  8000df:	50                   	push   %eax
  8000e0:	68 8c 17 80 00       	push   $0x80178c
  8000e5:	6a 2d                	push   $0x2d
  8000e7:	68 95 17 80 00       	push   $0x801795
  8000ec:	e8 60 00 00 00       	call   800151 <_panic>
		primeproc();
  8000f1:	e8 3d ff ff ff       	call   800033 <primeproc>

008000f6 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000f6:	55                   	push   %ebp
  8000f7:	89 e5                	mov    %esp,%ebp
  8000f9:	56                   	push   %esi
  8000fa:	53                   	push   %ebx
  8000fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000fe:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  800101:	e8 00 0c 00 00       	call   800d06 <sys_getenvid>
  800106:	25 ff 03 00 00       	and    $0x3ff,%eax
  80010b:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  800111:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800116:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80011b:	85 db                	test   %ebx,%ebx
  80011d:	7e 07                	jle    800126 <libmain+0x30>
		binaryname = argv[0];
  80011f:	8b 06                	mov    (%esi),%eax
  800121:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800126:	83 ec 08             	sub    $0x8,%esp
  800129:	56                   	push   %esi
  80012a:	53                   	push   %ebx
  80012b:	e8 85 ff ff ff       	call   8000b5 <umain>

	// exit gracefully
	exit();
  800130:	e8 0a 00 00 00       	call   80013f <exit>
}
  800135:	83 c4 10             	add    $0x10,%esp
  800138:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80013b:	5b                   	pop    %ebx
  80013c:	5e                   	pop    %esi
  80013d:	5d                   	pop    %ebp
  80013e:	c3                   	ret    

0080013f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80013f:	55                   	push   %ebp
  800140:	89 e5                	mov    %esp,%ebp
  800142:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800145:	6a 00                	push   $0x0
  800147:	e8 79 0b 00 00       	call   800cc5 <sys_env_destroy>
}
  80014c:	83 c4 10             	add    $0x10,%esp
  80014f:	c9                   	leave  
  800150:	c3                   	ret    

00800151 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800151:	55                   	push   %ebp
  800152:	89 e5                	mov    %esp,%ebp
  800154:	56                   	push   %esi
  800155:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800156:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800159:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80015f:	e8 a2 0b 00 00       	call   800d06 <sys_getenvid>
  800164:	83 ec 0c             	sub    $0xc,%esp
  800167:	ff 75 0c             	pushl  0xc(%ebp)
  80016a:	ff 75 08             	pushl  0x8(%ebp)
  80016d:	56                   	push   %esi
  80016e:	50                   	push   %eax
  80016f:	68 b0 17 80 00       	push   $0x8017b0
  800174:	e8 b3 00 00 00       	call   80022c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800179:	83 c4 18             	add    $0x18,%esp
  80017c:	53                   	push   %ebx
  80017d:	ff 75 10             	pushl  0x10(%ebp)
  800180:	e8 56 00 00 00       	call   8001db <vcprintf>
	cprintf("\n");
  800185:	c7 04 24 95 1b 80 00 	movl   $0x801b95,(%esp)
  80018c:	e8 9b 00 00 00       	call   80022c <cprintf>
  800191:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800194:	cc                   	int3   
  800195:	eb fd                	jmp    800194 <_panic+0x43>

00800197 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800197:	55                   	push   %ebp
  800198:	89 e5                	mov    %esp,%ebp
  80019a:	53                   	push   %ebx
  80019b:	83 ec 04             	sub    $0x4,%esp
  80019e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001a1:	8b 13                	mov    (%ebx),%edx
  8001a3:	8d 42 01             	lea    0x1(%edx),%eax
  8001a6:	89 03                	mov    %eax,(%ebx)
  8001a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001ab:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001af:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001b4:	74 09                	je     8001bf <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001b6:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001bd:	c9                   	leave  
  8001be:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001bf:	83 ec 08             	sub    $0x8,%esp
  8001c2:	68 ff 00 00 00       	push   $0xff
  8001c7:	8d 43 08             	lea    0x8(%ebx),%eax
  8001ca:	50                   	push   %eax
  8001cb:	e8 b8 0a 00 00       	call   800c88 <sys_cputs>
		b->idx = 0;
  8001d0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001d6:	83 c4 10             	add    $0x10,%esp
  8001d9:	eb db                	jmp    8001b6 <putch+0x1f>

008001db <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001db:	55                   	push   %ebp
  8001dc:	89 e5                	mov    %esp,%ebp
  8001de:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001e4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001eb:	00 00 00 
	b.cnt = 0;
  8001ee:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001f5:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001f8:	ff 75 0c             	pushl  0xc(%ebp)
  8001fb:	ff 75 08             	pushl  0x8(%ebp)
  8001fe:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800204:	50                   	push   %eax
  800205:	68 97 01 80 00       	push   $0x800197
  80020a:	e8 4a 01 00 00       	call   800359 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80020f:	83 c4 08             	add    $0x8,%esp
  800212:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800218:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80021e:	50                   	push   %eax
  80021f:	e8 64 0a 00 00       	call   800c88 <sys_cputs>

	return b.cnt;
}
  800224:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80022a:	c9                   	leave  
  80022b:	c3                   	ret    

0080022c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80022c:	55                   	push   %ebp
  80022d:	89 e5                	mov    %esp,%ebp
  80022f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800232:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800235:	50                   	push   %eax
  800236:	ff 75 08             	pushl  0x8(%ebp)
  800239:	e8 9d ff ff ff       	call   8001db <vcprintf>
	va_end(ap);

	return cnt;
}
  80023e:	c9                   	leave  
  80023f:	c3                   	ret    

00800240 <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800240:	55                   	push   %ebp
  800241:	89 e5                	mov    %esp,%ebp
  800243:	57                   	push   %edi
  800244:	56                   	push   %esi
  800245:	53                   	push   %ebx
  800246:	83 ec 1c             	sub    $0x1c,%esp
  800249:	89 c6                	mov    %eax,%esi
  80024b:	89 d7                	mov    %edx,%edi
  80024d:	8b 45 08             	mov    0x8(%ebp),%eax
  800250:	8b 55 0c             	mov    0xc(%ebp),%edx
  800253:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800256:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800259:	8b 45 10             	mov    0x10(%ebp),%eax
  80025c:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  80025f:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800263:	74 2c                	je     800291 <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800265:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800268:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80026f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800272:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800275:	39 c2                	cmp    %eax,%edx
  800277:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80027a:	73 43                	jae    8002bf <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80027c:	83 eb 01             	sub    $0x1,%ebx
  80027f:	85 db                	test   %ebx,%ebx
  800281:	7e 6c                	jle    8002ef <printnum+0xaf>
			putch(padc, putdat);
  800283:	83 ec 08             	sub    $0x8,%esp
  800286:	57                   	push   %edi
  800287:	ff 75 18             	pushl  0x18(%ebp)
  80028a:	ff d6                	call   *%esi
  80028c:	83 c4 10             	add    $0x10,%esp
  80028f:	eb eb                	jmp    80027c <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800291:	83 ec 0c             	sub    $0xc,%esp
  800294:	6a 20                	push   $0x20
  800296:	6a 00                	push   $0x0
  800298:	50                   	push   %eax
  800299:	ff 75 e4             	pushl  -0x1c(%ebp)
  80029c:	ff 75 e0             	pushl  -0x20(%ebp)
  80029f:	89 fa                	mov    %edi,%edx
  8002a1:	89 f0                	mov    %esi,%eax
  8002a3:	e8 98 ff ff ff       	call   800240 <printnum>
		while (--width > 0)
  8002a8:	83 c4 20             	add    $0x20,%esp
  8002ab:	83 eb 01             	sub    $0x1,%ebx
  8002ae:	85 db                	test   %ebx,%ebx
  8002b0:	7e 65                	jle    800317 <printnum+0xd7>
			putch(' ', putdat);
  8002b2:	83 ec 08             	sub    $0x8,%esp
  8002b5:	57                   	push   %edi
  8002b6:	6a 20                	push   $0x20
  8002b8:	ff d6                	call   *%esi
  8002ba:	83 c4 10             	add    $0x10,%esp
  8002bd:	eb ec                	jmp    8002ab <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002bf:	83 ec 0c             	sub    $0xc,%esp
  8002c2:	ff 75 18             	pushl  0x18(%ebp)
  8002c5:	83 eb 01             	sub    $0x1,%ebx
  8002c8:	53                   	push   %ebx
  8002c9:	50                   	push   %eax
  8002ca:	83 ec 08             	sub    $0x8,%esp
  8002cd:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d0:	ff 75 d8             	pushl  -0x28(%ebp)
  8002d3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d6:	ff 75 e0             	pushl  -0x20(%ebp)
  8002d9:	e8 42 12 00 00       	call   801520 <__udivdi3>
  8002de:	83 c4 18             	add    $0x18,%esp
  8002e1:	52                   	push   %edx
  8002e2:	50                   	push   %eax
  8002e3:	89 fa                	mov    %edi,%edx
  8002e5:	89 f0                	mov    %esi,%eax
  8002e7:	e8 54 ff ff ff       	call   800240 <printnum>
  8002ec:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002ef:	83 ec 08             	sub    $0x8,%esp
  8002f2:	57                   	push   %edi
  8002f3:	83 ec 04             	sub    $0x4,%esp
  8002f6:	ff 75 dc             	pushl  -0x24(%ebp)
  8002f9:	ff 75 d8             	pushl  -0x28(%ebp)
  8002fc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ff:	ff 75 e0             	pushl  -0x20(%ebp)
  800302:	e8 29 13 00 00       	call   801630 <__umoddi3>
  800307:	83 c4 14             	add    $0x14,%esp
  80030a:	0f be 80 d3 17 80 00 	movsbl 0x8017d3(%eax),%eax
  800311:	50                   	push   %eax
  800312:	ff d6                	call   *%esi
  800314:	83 c4 10             	add    $0x10,%esp
}
  800317:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80031a:	5b                   	pop    %ebx
  80031b:	5e                   	pop    %esi
  80031c:	5f                   	pop    %edi
  80031d:	5d                   	pop    %ebp
  80031e:	c3                   	ret    

0080031f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80031f:	55                   	push   %ebp
  800320:	89 e5                	mov    %esp,%ebp
  800322:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800325:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800329:	8b 10                	mov    (%eax),%edx
  80032b:	3b 50 04             	cmp    0x4(%eax),%edx
  80032e:	73 0a                	jae    80033a <sprintputch+0x1b>
		*b->buf++ = ch;
  800330:	8d 4a 01             	lea    0x1(%edx),%ecx
  800333:	89 08                	mov    %ecx,(%eax)
  800335:	8b 45 08             	mov    0x8(%ebp),%eax
  800338:	88 02                	mov    %al,(%edx)
}
  80033a:	5d                   	pop    %ebp
  80033b:	c3                   	ret    

0080033c <printfmt>:
{
  80033c:	55                   	push   %ebp
  80033d:	89 e5                	mov    %esp,%ebp
  80033f:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800342:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800345:	50                   	push   %eax
  800346:	ff 75 10             	pushl  0x10(%ebp)
  800349:	ff 75 0c             	pushl  0xc(%ebp)
  80034c:	ff 75 08             	pushl  0x8(%ebp)
  80034f:	e8 05 00 00 00       	call   800359 <vprintfmt>
}
  800354:	83 c4 10             	add    $0x10,%esp
  800357:	c9                   	leave  
  800358:	c3                   	ret    

00800359 <vprintfmt>:
{
  800359:	55                   	push   %ebp
  80035a:	89 e5                	mov    %esp,%ebp
  80035c:	57                   	push   %edi
  80035d:	56                   	push   %esi
  80035e:	53                   	push   %ebx
  80035f:	83 ec 3c             	sub    $0x3c,%esp
  800362:	8b 75 08             	mov    0x8(%ebp),%esi
  800365:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800368:	8b 7d 10             	mov    0x10(%ebp),%edi
  80036b:	e9 1e 04 00 00       	jmp    80078e <vprintfmt+0x435>
		posflag = 0;
  800370:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  800377:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80037b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800382:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800389:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800390:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  800397:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80039c:	8d 47 01             	lea    0x1(%edi),%eax
  80039f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003a2:	0f b6 17             	movzbl (%edi),%edx
  8003a5:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003a8:	3c 55                	cmp    $0x55,%al
  8003aa:	0f 87 d9 04 00 00    	ja     800889 <vprintfmt+0x530>
  8003b0:	0f b6 c0             	movzbl %al,%eax
  8003b3:	ff 24 85 c0 19 80 00 	jmp    *0x8019c0(,%eax,4)
  8003ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003bd:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8003c1:	eb d9                	jmp    80039c <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  8003c6:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  8003cd:	eb cd                	jmp    80039c <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003cf:	0f b6 d2             	movzbl %dl,%edx
  8003d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003da:	89 75 08             	mov    %esi,0x8(%ebp)
  8003dd:	eb 0c                	jmp    8003eb <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  8003df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003e2:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  8003e6:	eb b4                	jmp    80039c <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  8003e8:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003eb:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003ee:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003f2:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003f5:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003f8:	83 fe 09             	cmp    $0x9,%esi
  8003fb:	76 eb                	jbe    8003e8 <vprintfmt+0x8f>
  8003fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800400:	8b 75 08             	mov    0x8(%ebp),%esi
  800403:	eb 14                	jmp    800419 <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  800405:	8b 45 14             	mov    0x14(%ebp),%eax
  800408:	8b 00                	mov    (%eax),%eax
  80040a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80040d:	8b 45 14             	mov    0x14(%ebp),%eax
  800410:	8d 40 04             	lea    0x4(%eax),%eax
  800413:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800416:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800419:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80041d:	0f 89 79 ff ff ff    	jns    80039c <vprintfmt+0x43>
				width = precision, precision = -1;
  800423:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800426:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800429:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800430:	e9 67 ff ff ff       	jmp    80039c <vprintfmt+0x43>
  800435:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800438:	85 c0                	test   %eax,%eax
  80043a:	0f 48 c1             	cmovs  %ecx,%eax
  80043d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800440:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800443:	e9 54 ff ff ff       	jmp    80039c <vprintfmt+0x43>
  800448:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80044b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800452:	e9 45 ff ff ff       	jmp    80039c <vprintfmt+0x43>
			lflag++;
  800457:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80045b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80045e:	e9 39 ff ff ff       	jmp    80039c <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800463:	8b 45 14             	mov    0x14(%ebp),%eax
  800466:	8d 78 04             	lea    0x4(%eax),%edi
  800469:	83 ec 08             	sub    $0x8,%esp
  80046c:	53                   	push   %ebx
  80046d:	ff 30                	pushl  (%eax)
  80046f:	ff d6                	call   *%esi
			break;
  800471:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800474:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800477:	e9 0f 03 00 00       	jmp    80078b <vprintfmt+0x432>
			err = va_arg(ap, int);
  80047c:	8b 45 14             	mov    0x14(%ebp),%eax
  80047f:	8d 78 04             	lea    0x4(%eax),%edi
  800482:	8b 00                	mov    (%eax),%eax
  800484:	99                   	cltd   
  800485:	31 d0                	xor    %edx,%eax
  800487:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800489:	83 f8 0f             	cmp    $0xf,%eax
  80048c:	7f 23                	jg     8004b1 <vprintfmt+0x158>
  80048e:	8b 14 85 20 1b 80 00 	mov    0x801b20(,%eax,4),%edx
  800495:	85 d2                	test   %edx,%edx
  800497:	74 18                	je     8004b1 <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  800499:	52                   	push   %edx
  80049a:	68 f4 17 80 00       	push   $0x8017f4
  80049f:	53                   	push   %ebx
  8004a0:	56                   	push   %esi
  8004a1:	e8 96 fe ff ff       	call   80033c <printfmt>
  8004a6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004a9:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004ac:	e9 da 02 00 00       	jmp    80078b <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  8004b1:	50                   	push   %eax
  8004b2:	68 eb 17 80 00       	push   $0x8017eb
  8004b7:	53                   	push   %ebx
  8004b8:	56                   	push   %esi
  8004b9:	e8 7e fe ff ff       	call   80033c <printfmt>
  8004be:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004c1:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004c4:	e9 c2 02 00 00       	jmp    80078b <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  8004c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cc:	83 c0 04             	add    $0x4,%eax
  8004cf:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8004d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d5:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004d7:	85 c9                	test   %ecx,%ecx
  8004d9:	b8 e4 17 80 00       	mov    $0x8017e4,%eax
  8004de:	0f 45 c1             	cmovne %ecx,%eax
  8004e1:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004e4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004e8:	7e 06                	jle    8004f0 <vprintfmt+0x197>
  8004ea:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004ee:	75 0d                	jne    8004fd <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004f3:	89 c7                	mov    %eax,%edi
  8004f5:	03 45 e0             	add    -0x20(%ebp),%eax
  8004f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004fb:	eb 53                	jmp    800550 <vprintfmt+0x1f7>
  8004fd:	83 ec 08             	sub    $0x8,%esp
  800500:	ff 75 d8             	pushl  -0x28(%ebp)
  800503:	50                   	push   %eax
  800504:	e8 28 04 00 00       	call   800931 <strnlen>
  800509:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80050c:	29 c1                	sub    %eax,%ecx
  80050e:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800511:	83 c4 10             	add    $0x10,%esp
  800514:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800516:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80051a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80051d:	eb 0f                	jmp    80052e <vprintfmt+0x1d5>
					putch(padc, putdat);
  80051f:	83 ec 08             	sub    $0x8,%esp
  800522:	53                   	push   %ebx
  800523:	ff 75 e0             	pushl  -0x20(%ebp)
  800526:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800528:	83 ef 01             	sub    $0x1,%edi
  80052b:	83 c4 10             	add    $0x10,%esp
  80052e:	85 ff                	test   %edi,%edi
  800530:	7f ed                	jg     80051f <vprintfmt+0x1c6>
  800532:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800535:	85 c9                	test   %ecx,%ecx
  800537:	b8 00 00 00 00       	mov    $0x0,%eax
  80053c:	0f 49 c1             	cmovns %ecx,%eax
  80053f:	29 c1                	sub    %eax,%ecx
  800541:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800544:	eb aa                	jmp    8004f0 <vprintfmt+0x197>
					putch(ch, putdat);
  800546:	83 ec 08             	sub    $0x8,%esp
  800549:	53                   	push   %ebx
  80054a:	52                   	push   %edx
  80054b:	ff d6                	call   *%esi
  80054d:	83 c4 10             	add    $0x10,%esp
  800550:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800553:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800555:	83 c7 01             	add    $0x1,%edi
  800558:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80055c:	0f be d0             	movsbl %al,%edx
  80055f:	85 d2                	test   %edx,%edx
  800561:	74 4b                	je     8005ae <vprintfmt+0x255>
  800563:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800567:	78 06                	js     80056f <vprintfmt+0x216>
  800569:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80056d:	78 1e                	js     80058d <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  80056f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800573:	74 d1                	je     800546 <vprintfmt+0x1ed>
  800575:	0f be c0             	movsbl %al,%eax
  800578:	83 e8 20             	sub    $0x20,%eax
  80057b:	83 f8 5e             	cmp    $0x5e,%eax
  80057e:	76 c6                	jbe    800546 <vprintfmt+0x1ed>
					putch('?', putdat);
  800580:	83 ec 08             	sub    $0x8,%esp
  800583:	53                   	push   %ebx
  800584:	6a 3f                	push   $0x3f
  800586:	ff d6                	call   *%esi
  800588:	83 c4 10             	add    $0x10,%esp
  80058b:	eb c3                	jmp    800550 <vprintfmt+0x1f7>
  80058d:	89 cf                	mov    %ecx,%edi
  80058f:	eb 0e                	jmp    80059f <vprintfmt+0x246>
				putch(' ', putdat);
  800591:	83 ec 08             	sub    $0x8,%esp
  800594:	53                   	push   %ebx
  800595:	6a 20                	push   $0x20
  800597:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800599:	83 ef 01             	sub    $0x1,%edi
  80059c:	83 c4 10             	add    $0x10,%esp
  80059f:	85 ff                	test   %edi,%edi
  8005a1:	7f ee                	jg     800591 <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  8005a3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005a6:	89 45 14             	mov    %eax,0x14(%ebp)
  8005a9:	e9 dd 01 00 00       	jmp    80078b <vprintfmt+0x432>
  8005ae:	89 cf                	mov    %ecx,%edi
  8005b0:	eb ed                	jmp    80059f <vprintfmt+0x246>
	if (lflag >= 2)
  8005b2:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8005b6:	7f 21                	jg     8005d9 <vprintfmt+0x280>
	else if (lflag)
  8005b8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8005bc:	74 6a                	je     800628 <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  8005be:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c1:	8b 00                	mov    (%eax),%eax
  8005c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c6:	89 c1                	mov    %eax,%ecx
  8005c8:	c1 f9 1f             	sar    $0x1f,%ecx
  8005cb:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d1:	8d 40 04             	lea    0x4(%eax),%eax
  8005d4:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d7:	eb 17                	jmp    8005f0 <vprintfmt+0x297>
		return va_arg(*ap, long long);
  8005d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dc:	8b 50 04             	mov    0x4(%eax),%edx
  8005df:	8b 00                	mov    (%eax),%eax
  8005e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ea:	8d 40 08             	lea    0x8(%eax),%eax
  8005ed:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005f0:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  8005f3:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8005f8:	85 d2                	test   %edx,%edx
  8005fa:	0f 89 5c 01 00 00    	jns    80075c <vprintfmt+0x403>
				putch('-', putdat);
  800600:	83 ec 08             	sub    $0x8,%esp
  800603:	53                   	push   %ebx
  800604:	6a 2d                	push   $0x2d
  800606:	ff d6                	call   *%esi
				num = -(long long) num;
  800608:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80060b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80060e:	f7 d8                	neg    %eax
  800610:	83 d2 00             	adc    $0x0,%edx
  800613:	f7 da                	neg    %edx
  800615:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800618:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80061b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80061e:	bf 0a 00 00 00       	mov    $0xa,%edi
  800623:	e9 45 01 00 00       	jmp    80076d <vprintfmt+0x414>
		return va_arg(*ap, int);
  800628:	8b 45 14             	mov    0x14(%ebp),%eax
  80062b:	8b 00                	mov    (%eax),%eax
  80062d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800630:	89 c1                	mov    %eax,%ecx
  800632:	c1 f9 1f             	sar    $0x1f,%ecx
  800635:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800638:	8b 45 14             	mov    0x14(%ebp),%eax
  80063b:	8d 40 04             	lea    0x4(%eax),%eax
  80063e:	89 45 14             	mov    %eax,0x14(%ebp)
  800641:	eb ad                	jmp    8005f0 <vprintfmt+0x297>
	if (lflag >= 2)
  800643:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800647:	7f 29                	jg     800672 <vprintfmt+0x319>
	else if (lflag)
  800649:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80064d:	74 44                	je     800693 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  80064f:	8b 45 14             	mov    0x14(%ebp),%eax
  800652:	8b 00                	mov    (%eax),%eax
  800654:	ba 00 00 00 00       	mov    $0x0,%edx
  800659:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80065f:	8b 45 14             	mov    0x14(%ebp),%eax
  800662:	8d 40 04             	lea    0x4(%eax),%eax
  800665:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800668:	bf 0a 00 00 00       	mov    $0xa,%edi
  80066d:	e9 ea 00 00 00       	jmp    80075c <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800672:	8b 45 14             	mov    0x14(%ebp),%eax
  800675:	8b 50 04             	mov    0x4(%eax),%edx
  800678:	8b 00                	mov    (%eax),%eax
  80067a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800680:	8b 45 14             	mov    0x14(%ebp),%eax
  800683:	8d 40 08             	lea    0x8(%eax),%eax
  800686:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800689:	bf 0a 00 00 00       	mov    $0xa,%edi
  80068e:	e9 c9 00 00 00       	jmp    80075c <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800693:	8b 45 14             	mov    0x14(%ebp),%eax
  800696:	8b 00                	mov    (%eax),%eax
  800698:	ba 00 00 00 00       	mov    $0x0,%edx
  80069d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a6:	8d 40 04             	lea    0x4(%eax),%eax
  8006a9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ac:	bf 0a 00 00 00       	mov    $0xa,%edi
  8006b1:	e9 a6 00 00 00       	jmp    80075c <vprintfmt+0x403>
			putch('0', putdat);
  8006b6:	83 ec 08             	sub    $0x8,%esp
  8006b9:	53                   	push   %ebx
  8006ba:	6a 30                	push   $0x30
  8006bc:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006be:	83 c4 10             	add    $0x10,%esp
  8006c1:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8006c5:	7f 26                	jg     8006ed <vprintfmt+0x394>
	else if (lflag)
  8006c7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8006cb:	74 3e                	je     80070b <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  8006cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d0:	8b 00                	mov    (%eax),%eax
  8006d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006da:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e0:	8d 40 04             	lea    0x4(%eax),%eax
  8006e3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006e6:	bf 08 00 00 00       	mov    $0x8,%edi
  8006eb:	eb 6f                	jmp    80075c <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8006ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f0:	8b 50 04             	mov    0x4(%eax),%edx
  8006f3:	8b 00                	mov    (%eax),%eax
  8006f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fe:	8d 40 08             	lea    0x8(%eax),%eax
  800701:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800704:	bf 08 00 00 00       	mov    $0x8,%edi
  800709:	eb 51                	jmp    80075c <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  80070b:	8b 45 14             	mov    0x14(%ebp),%eax
  80070e:	8b 00                	mov    (%eax),%eax
  800710:	ba 00 00 00 00       	mov    $0x0,%edx
  800715:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800718:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80071b:	8b 45 14             	mov    0x14(%ebp),%eax
  80071e:	8d 40 04             	lea    0x4(%eax),%eax
  800721:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800724:	bf 08 00 00 00       	mov    $0x8,%edi
  800729:	eb 31                	jmp    80075c <vprintfmt+0x403>
			putch('0', putdat);
  80072b:	83 ec 08             	sub    $0x8,%esp
  80072e:	53                   	push   %ebx
  80072f:	6a 30                	push   $0x30
  800731:	ff d6                	call   *%esi
			putch('x', putdat);
  800733:	83 c4 08             	add    $0x8,%esp
  800736:	53                   	push   %ebx
  800737:	6a 78                	push   $0x78
  800739:	ff d6                	call   *%esi
			num = (unsigned long long)
  80073b:	8b 45 14             	mov    0x14(%ebp),%eax
  80073e:	8b 00                	mov    (%eax),%eax
  800740:	ba 00 00 00 00       	mov    $0x0,%edx
  800745:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800748:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80074b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80074e:	8b 45 14             	mov    0x14(%ebp),%eax
  800751:	8d 40 04             	lea    0x4(%eax),%eax
  800754:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800757:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  80075c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800760:	74 0b                	je     80076d <vprintfmt+0x414>
				putch('+', putdat);
  800762:	83 ec 08             	sub    $0x8,%esp
  800765:	53                   	push   %ebx
  800766:	6a 2b                	push   $0x2b
  800768:	ff d6                	call   *%esi
  80076a:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  80076d:	83 ec 0c             	sub    $0xc,%esp
  800770:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800774:	50                   	push   %eax
  800775:	ff 75 e0             	pushl  -0x20(%ebp)
  800778:	57                   	push   %edi
  800779:	ff 75 dc             	pushl  -0x24(%ebp)
  80077c:	ff 75 d8             	pushl  -0x28(%ebp)
  80077f:	89 da                	mov    %ebx,%edx
  800781:	89 f0                	mov    %esi,%eax
  800783:	e8 b8 fa ff ff       	call   800240 <printnum>
			break;
  800788:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  80078b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80078e:	83 c7 01             	add    $0x1,%edi
  800791:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800795:	83 f8 25             	cmp    $0x25,%eax
  800798:	0f 84 d2 fb ff ff    	je     800370 <vprintfmt+0x17>
			if (ch == '\0')
  80079e:	85 c0                	test   %eax,%eax
  8007a0:	0f 84 03 01 00 00    	je     8008a9 <vprintfmt+0x550>
			putch(ch, putdat);
  8007a6:	83 ec 08             	sub    $0x8,%esp
  8007a9:	53                   	push   %ebx
  8007aa:	50                   	push   %eax
  8007ab:	ff d6                	call   *%esi
  8007ad:	83 c4 10             	add    $0x10,%esp
  8007b0:	eb dc                	jmp    80078e <vprintfmt+0x435>
	if (lflag >= 2)
  8007b2:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8007b6:	7f 29                	jg     8007e1 <vprintfmt+0x488>
	else if (lflag)
  8007b8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8007bc:	74 44                	je     800802 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  8007be:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c1:	8b 00                	mov    (%eax),%eax
  8007c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007cb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d1:	8d 40 04             	lea    0x4(%eax),%eax
  8007d4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d7:	bf 10 00 00 00       	mov    $0x10,%edi
  8007dc:	e9 7b ff ff ff       	jmp    80075c <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8007e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e4:	8b 50 04             	mov    0x4(%eax),%edx
  8007e7:	8b 00                	mov    (%eax),%eax
  8007e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ec:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f2:	8d 40 08             	lea    0x8(%eax),%eax
  8007f5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f8:	bf 10 00 00 00       	mov    $0x10,%edi
  8007fd:	e9 5a ff ff ff       	jmp    80075c <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800802:	8b 45 14             	mov    0x14(%ebp),%eax
  800805:	8b 00                	mov    (%eax),%eax
  800807:	ba 00 00 00 00       	mov    $0x0,%edx
  80080c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80080f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800812:	8b 45 14             	mov    0x14(%ebp),%eax
  800815:	8d 40 04             	lea    0x4(%eax),%eax
  800818:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80081b:	bf 10 00 00 00       	mov    $0x10,%edi
  800820:	e9 37 ff ff ff       	jmp    80075c <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  800825:	8b 45 14             	mov    0x14(%ebp),%eax
  800828:	8d 78 04             	lea    0x4(%eax),%edi
  80082b:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  80082d:	85 c0                	test   %eax,%eax
  80082f:	74 2c                	je     80085d <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  800831:	8b 13                	mov    (%ebx),%edx
  800833:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  800835:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  800838:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  80083b:	0f 8e 4a ff ff ff    	jle    80078b <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  800841:	68 44 19 80 00       	push   $0x801944
  800846:	68 f4 17 80 00       	push   $0x8017f4
  80084b:	53                   	push   %ebx
  80084c:	56                   	push   %esi
  80084d:	e8 ea fa ff ff       	call   80033c <printfmt>
  800852:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800855:	89 7d 14             	mov    %edi,0x14(%ebp)
  800858:	e9 2e ff ff ff       	jmp    80078b <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  80085d:	68 0c 19 80 00       	push   $0x80190c
  800862:	68 f4 17 80 00       	push   $0x8017f4
  800867:	53                   	push   %ebx
  800868:	56                   	push   %esi
  800869:	e8 ce fa ff ff       	call   80033c <printfmt>
        		break;
  80086e:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800871:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  800874:	e9 12 ff ff ff       	jmp    80078b <vprintfmt+0x432>
			putch(ch, putdat);
  800879:	83 ec 08             	sub    $0x8,%esp
  80087c:	53                   	push   %ebx
  80087d:	6a 25                	push   $0x25
  80087f:	ff d6                	call   *%esi
			break;
  800881:	83 c4 10             	add    $0x10,%esp
  800884:	e9 02 ff ff ff       	jmp    80078b <vprintfmt+0x432>
			putch('%', putdat);
  800889:	83 ec 08             	sub    $0x8,%esp
  80088c:	53                   	push   %ebx
  80088d:	6a 25                	push   $0x25
  80088f:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800891:	83 c4 10             	add    $0x10,%esp
  800894:	89 f8                	mov    %edi,%eax
  800896:	eb 03                	jmp    80089b <vprintfmt+0x542>
  800898:	83 e8 01             	sub    $0x1,%eax
  80089b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80089f:	75 f7                	jne    800898 <vprintfmt+0x53f>
  8008a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008a4:	e9 e2 fe ff ff       	jmp    80078b <vprintfmt+0x432>
}
  8008a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008ac:	5b                   	pop    %ebx
  8008ad:	5e                   	pop    %esi
  8008ae:	5f                   	pop    %edi
  8008af:	5d                   	pop    %ebp
  8008b0:	c3                   	ret    

008008b1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008b1:	55                   	push   %ebp
  8008b2:	89 e5                	mov    %esp,%ebp
  8008b4:	83 ec 18             	sub    $0x18,%esp
  8008b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ba:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008c0:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008c4:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008ce:	85 c0                	test   %eax,%eax
  8008d0:	74 26                	je     8008f8 <vsnprintf+0x47>
  8008d2:	85 d2                	test   %edx,%edx
  8008d4:	7e 22                	jle    8008f8 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008d6:	ff 75 14             	pushl  0x14(%ebp)
  8008d9:	ff 75 10             	pushl  0x10(%ebp)
  8008dc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008df:	50                   	push   %eax
  8008e0:	68 1f 03 80 00       	push   $0x80031f
  8008e5:	e8 6f fa ff ff       	call   800359 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008ed:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008f3:	83 c4 10             	add    $0x10,%esp
}
  8008f6:	c9                   	leave  
  8008f7:	c3                   	ret    
		return -E_INVAL;
  8008f8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008fd:	eb f7                	jmp    8008f6 <vsnprintf+0x45>

008008ff <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008ff:	55                   	push   %ebp
  800900:	89 e5                	mov    %esp,%ebp
  800902:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800905:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800908:	50                   	push   %eax
  800909:	ff 75 10             	pushl  0x10(%ebp)
  80090c:	ff 75 0c             	pushl  0xc(%ebp)
  80090f:	ff 75 08             	pushl  0x8(%ebp)
  800912:	e8 9a ff ff ff       	call   8008b1 <vsnprintf>
	va_end(ap);

	return rc;
}
  800917:	c9                   	leave  
  800918:	c3                   	ret    

00800919 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800919:	55                   	push   %ebp
  80091a:	89 e5                	mov    %esp,%ebp
  80091c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80091f:	b8 00 00 00 00       	mov    $0x0,%eax
  800924:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800928:	74 05                	je     80092f <strlen+0x16>
		n++;
  80092a:	83 c0 01             	add    $0x1,%eax
  80092d:	eb f5                	jmp    800924 <strlen+0xb>
	return n;
}
  80092f:	5d                   	pop    %ebp
  800930:	c3                   	ret    

00800931 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800931:	55                   	push   %ebp
  800932:	89 e5                	mov    %esp,%ebp
  800934:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800937:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80093a:	ba 00 00 00 00       	mov    $0x0,%edx
  80093f:	39 c2                	cmp    %eax,%edx
  800941:	74 0d                	je     800950 <strnlen+0x1f>
  800943:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800947:	74 05                	je     80094e <strnlen+0x1d>
		n++;
  800949:	83 c2 01             	add    $0x1,%edx
  80094c:	eb f1                	jmp    80093f <strnlen+0xe>
  80094e:	89 d0                	mov    %edx,%eax
	return n;
}
  800950:	5d                   	pop    %ebp
  800951:	c3                   	ret    

00800952 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800952:	55                   	push   %ebp
  800953:	89 e5                	mov    %esp,%ebp
  800955:	53                   	push   %ebx
  800956:	8b 45 08             	mov    0x8(%ebp),%eax
  800959:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80095c:	ba 00 00 00 00       	mov    $0x0,%edx
  800961:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800965:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800968:	83 c2 01             	add    $0x1,%edx
  80096b:	84 c9                	test   %cl,%cl
  80096d:	75 f2                	jne    800961 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80096f:	5b                   	pop    %ebx
  800970:	5d                   	pop    %ebp
  800971:	c3                   	ret    

00800972 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800972:	55                   	push   %ebp
  800973:	89 e5                	mov    %esp,%ebp
  800975:	53                   	push   %ebx
  800976:	83 ec 10             	sub    $0x10,%esp
  800979:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80097c:	53                   	push   %ebx
  80097d:	e8 97 ff ff ff       	call   800919 <strlen>
  800982:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800985:	ff 75 0c             	pushl  0xc(%ebp)
  800988:	01 d8                	add    %ebx,%eax
  80098a:	50                   	push   %eax
  80098b:	e8 c2 ff ff ff       	call   800952 <strcpy>
	return dst;
}
  800990:	89 d8                	mov    %ebx,%eax
  800992:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800995:	c9                   	leave  
  800996:	c3                   	ret    

00800997 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800997:	55                   	push   %ebp
  800998:	89 e5                	mov    %esp,%ebp
  80099a:	56                   	push   %esi
  80099b:	53                   	push   %ebx
  80099c:	8b 45 08             	mov    0x8(%ebp),%eax
  80099f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009a2:	89 c6                	mov    %eax,%esi
  8009a4:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009a7:	89 c2                	mov    %eax,%edx
  8009a9:	39 f2                	cmp    %esi,%edx
  8009ab:	74 11                	je     8009be <strncpy+0x27>
		*dst++ = *src;
  8009ad:	83 c2 01             	add    $0x1,%edx
  8009b0:	0f b6 19             	movzbl (%ecx),%ebx
  8009b3:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009b6:	80 fb 01             	cmp    $0x1,%bl
  8009b9:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009bc:	eb eb                	jmp    8009a9 <strncpy+0x12>
	}
	return ret;
}
  8009be:	5b                   	pop    %ebx
  8009bf:	5e                   	pop    %esi
  8009c0:	5d                   	pop    %ebp
  8009c1:	c3                   	ret    

008009c2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	56                   	push   %esi
  8009c6:	53                   	push   %ebx
  8009c7:	8b 75 08             	mov    0x8(%ebp),%esi
  8009ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009cd:	8b 55 10             	mov    0x10(%ebp),%edx
  8009d0:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009d2:	85 d2                	test   %edx,%edx
  8009d4:	74 21                	je     8009f7 <strlcpy+0x35>
  8009d6:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009da:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009dc:	39 c2                	cmp    %eax,%edx
  8009de:	74 14                	je     8009f4 <strlcpy+0x32>
  8009e0:	0f b6 19             	movzbl (%ecx),%ebx
  8009e3:	84 db                	test   %bl,%bl
  8009e5:	74 0b                	je     8009f2 <strlcpy+0x30>
			*dst++ = *src++;
  8009e7:	83 c1 01             	add    $0x1,%ecx
  8009ea:	83 c2 01             	add    $0x1,%edx
  8009ed:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009f0:	eb ea                	jmp    8009dc <strlcpy+0x1a>
  8009f2:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009f4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009f7:	29 f0                	sub    %esi,%eax
}
  8009f9:	5b                   	pop    %ebx
  8009fa:	5e                   	pop    %esi
  8009fb:	5d                   	pop    %ebp
  8009fc:	c3                   	ret    

008009fd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a03:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a06:	0f b6 01             	movzbl (%ecx),%eax
  800a09:	84 c0                	test   %al,%al
  800a0b:	74 0c                	je     800a19 <strcmp+0x1c>
  800a0d:	3a 02                	cmp    (%edx),%al
  800a0f:	75 08                	jne    800a19 <strcmp+0x1c>
		p++, q++;
  800a11:	83 c1 01             	add    $0x1,%ecx
  800a14:	83 c2 01             	add    $0x1,%edx
  800a17:	eb ed                	jmp    800a06 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a19:	0f b6 c0             	movzbl %al,%eax
  800a1c:	0f b6 12             	movzbl (%edx),%edx
  800a1f:	29 d0                	sub    %edx,%eax
}
  800a21:	5d                   	pop    %ebp
  800a22:	c3                   	ret    

00800a23 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a23:	55                   	push   %ebp
  800a24:	89 e5                	mov    %esp,%ebp
  800a26:	53                   	push   %ebx
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a2d:	89 c3                	mov    %eax,%ebx
  800a2f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a32:	eb 06                	jmp    800a3a <strncmp+0x17>
		n--, p++, q++;
  800a34:	83 c0 01             	add    $0x1,%eax
  800a37:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a3a:	39 d8                	cmp    %ebx,%eax
  800a3c:	74 16                	je     800a54 <strncmp+0x31>
  800a3e:	0f b6 08             	movzbl (%eax),%ecx
  800a41:	84 c9                	test   %cl,%cl
  800a43:	74 04                	je     800a49 <strncmp+0x26>
  800a45:	3a 0a                	cmp    (%edx),%cl
  800a47:	74 eb                	je     800a34 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a49:	0f b6 00             	movzbl (%eax),%eax
  800a4c:	0f b6 12             	movzbl (%edx),%edx
  800a4f:	29 d0                	sub    %edx,%eax
}
  800a51:	5b                   	pop    %ebx
  800a52:	5d                   	pop    %ebp
  800a53:	c3                   	ret    
		return 0;
  800a54:	b8 00 00 00 00       	mov    $0x0,%eax
  800a59:	eb f6                	jmp    800a51 <strncmp+0x2e>

00800a5b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a5b:	55                   	push   %ebp
  800a5c:	89 e5                	mov    %esp,%ebp
  800a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a61:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a65:	0f b6 10             	movzbl (%eax),%edx
  800a68:	84 d2                	test   %dl,%dl
  800a6a:	74 09                	je     800a75 <strchr+0x1a>
		if (*s == c)
  800a6c:	38 ca                	cmp    %cl,%dl
  800a6e:	74 0a                	je     800a7a <strchr+0x1f>
	for (; *s; s++)
  800a70:	83 c0 01             	add    $0x1,%eax
  800a73:	eb f0                	jmp    800a65 <strchr+0xa>
			return (char *) s;
	return 0;
  800a75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a7a:	5d                   	pop    %ebp
  800a7b:	c3                   	ret    

00800a7c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a7c:	55                   	push   %ebp
  800a7d:	89 e5                	mov    %esp,%ebp
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a86:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a89:	38 ca                	cmp    %cl,%dl
  800a8b:	74 09                	je     800a96 <strfind+0x1a>
  800a8d:	84 d2                	test   %dl,%dl
  800a8f:	74 05                	je     800a96 <strfind+0x1a>
	for (; *s; s++)
  800a91:	83 c0 01             	add    $0x1,%eax
  800a94:	eb f0                	jmp    800a86 <strfind+0xa>
			break;
	return (char *) s;
}
  800a96:	5d                   	pop    %ebp
  800a97:	c3                   	ret    

00800a98 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a98:	55                   	push   %ebp
  800a99:	89 e5                	mov    %esp,%ebp
  800a9b:	57                   	push   %edi
  800a9c:	56                   	push   %esi
  800a9d:	53                   	push   %ebx
  800a9e:	8b 7d 08             	mov    0x8(%ebp),%edi
  800aa1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800aa4:	85 c9                	test   %ecx,%ecx
  800aa6:	74 31                	je     800ad9 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800aa8:	89 f8                	mov    %edi,%eax
  800aaa:	09 c8                	or     %ecx,%eax
  800aac:	a8 03                	test   $0x3,%al
  800aae:	75 23                	jne    800ad3 <memset+0x3b>
		c &= 0xFF;
  800ab0:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ab4:	89 d3                	mov    %edx,%ebx
  800ab6:	c1 e3 08             	shl    $0x8,%ebx
  800ab9:	89 d0                	mov    %edx,%eax
  800abb:	c1 e0 18             	shl    $0x18,%eax
  800abe:	89 d6                	mov    %edx,%esi
  800ac0:	c1 e6 10             	shl    $0x10,%esi
  800ac3:	09 f0                	or     %esi,%eax
  800ac5:	09 c2                	or     %eax,%edx
  800ac7:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ac9:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800acc:	89 d0                	mov    %edx,%eax
  800ace:	fc                   	cld    
  800acf:	f3 ab                	rep stos %eax,%es:(%edi)
  800ad1:	eb 06                	jmp    800ad9 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ad3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad6:	fc                   	cld    
  800ad7:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ad9:	89 f8                	mov    %edi,%eax
  800adb:	5b                   	pop    %ebx
  800adc:	5e                   	pop    %esi
  800add:	5f                   	pop    %edi
  800ade:	5d                   	pop    %ebp
  800adf:	c3                   	ret    

00800ae0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ae0:	55                   	push   %ebp
  800ae1:	89 e5                	mov    %esp,%ebp
  800ae3:	57                   	push   %edi
  800ae4:	56                   	push   %esi
  800ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aeb:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800aee:	39 c6                	cmp    %eax,%esi
  800af0:	73 32                	jae    800b24 <memmove+0x44>
  800af2:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800af5:	39 c2                	cmp    %eax,%edx
  800af7:	76 2b                	jbe    800b24 <memmove+0x44>
		s += n;
		d += n;
  800af9:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800afc:	89 fe                	mov    %edi,%esi
  800afe:	09 ce                	or     %ecx,%esi
  800b00:	09 d6                	or     %edx,%esi
  800b02:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b08:	75 0e                	jne    800b18 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b0a:	83 ef 04             	sub    $0x4,%edi
  800b0d:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b10:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b13:	fd                   	std    
  800b14:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b16:	eb 09                	jmp    800b21 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b18:	83 ef 01             	sub    $0x1,%edi
  800b1b:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b1e:	fd                   	std    
  800b1f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b21:	fc                   	cld    
  800b22:	eb 1a                	jmp    800b3e <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b24:	89 c2                	mov    %eax,%edx
  800b26:	09 ca                	or     %ecx,%edx
  800b28:	09 f2                	or     %esi,%edx
  800b2a:	f6 c2 03             	test   $0x3,%dl
  800b2d:	75 0a                	jne    800b39 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b2f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b32:	89 c7                	mov    %eax,%edi
  800b34:	fc                   	cld    
  800b35:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b37:	eb 05                	jmp    800b3e <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b39:	89 c7                	mov    %eax,%edi
  800b3b:	fc                   	cld    
  800b3c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b3e:	5e                   	pop    %esi
  800b3f:	5f                   	pop    %edi
  800b40:	5d                   	pop    %ebp
  800b41:	c3                   	ret    

00800b42 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b42:	55                   	push   %ebp
  800b43:	89 e5                	mov    %esp,%ebp
  800b45:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b48:	ff 75 10             	pushl  0x10(%ebp)
  800b4b:	ff 75 0c             	pushl  0xc(%ebp)
  800b4e:	ff 75 08             	pushl  0x8(%ebp)
  800b51:	e8 8a ff ff ff       	call   800ae0 <memmove>
}
  800b56:	c9                   	leave  
  800b57:	c3                   	ret    

00800b58 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b58:	55                   	push   %ebp
  800b59:	89 e5                	mov    %esp,%ebp
  800b5b:	56                   	push   %esi
  800b5c:	53                   	push   %ebx
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b63:	89 c6                	mov    %eax,%esi
  800b65:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b68:	39 f0                	cmp    %esi,%eax
  800b6a:	74 1c                	je     800b88 <memcmp+0x30>
		if (*s1 != *s2)
  800b6c:	0f b6 08             	movzbl (%eax),%ecx
  800b6f:	0f b6 1a             	movzbl (%edx),%ebx
  800b72:	38 d9                	cmp    %bl,%cl
  800b74:	75 08                	jne    800b7e <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b76:	83 c0 01             	add    $0x1,%eax
  800b79:	83 c2 01             	add    $0x1,%edx
  800b7c:	eb ea                	jmp    800b68 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b7e:	0f b6 c1             	movzbl %cl,%eax
  800b81:	0f b6 db             	movzbl %bl,%ebx
  800b84:	29 d8                	sub    %ebx,%eax
  800b86:	eb 05                	jmp    800b8d <memcmp+0x35>
	}

	return 0;
  800b88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b8d:	5b                   	pop    %ebx
  800b8e:	5e                   	pop    %esi
  800b8f:	5d                   	pop    %ebp
  800b90:	c3                   	ret    

00800b91 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b91:	55                   	push   %ebp
  800b92:	89 e5                	mov    %esp,%ebp
  800b94:	8b 45 08             	mov    0x8(%ebp),%eax
  800b97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b9a:	89 c2                	mov    %eax,%edx
  800b9c:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b9f:	39 d0                	cmp    %edx,%eax
  800ba1:	73 09                	jae    800bac <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ba3:	38 08                	cmp    %cl,(%eax)
  800ba5:	74 05                	je     800bac <memfind+0x1b>
	for (; s < ends; s++)
  800ba7:	83 c0 01             	add    $0x1,%eax
  800baa:	eb f3                	jmp    800b9f <memfind+0xe>
			break;
	return (void *) s;
}
  800bac:	5d                   	pop    %ebp
  800bad:	c3                   	ret    

00800bae <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	57                   	push   %edi
  800bb2:	56                   	push   %esi
  800bb3:	53                   	push   %ebx
  800bb4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bb7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bba:	eb 03                	jmp    800bbf <strtol+0x11>
		s++;
  800bbc:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bbf:	0f b6 01             	movzbl (%ecx),%eax
  800bc2:	3c 20                	cmp    $0x20,%al
  800bc4:	74 f6                	je     800bbc <strtol+0xe>
  800bc6:	3c 09                	cmp    $0x9,%al
  800bc8:	74 f2                	je     800bbc <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bca:	3c 2b                	cmp    $0x2b,%al
  800bcc:	74 2a                	je     800bf8 <strtol+0x4a>
	int neg = 0;
  800bce:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bd3:	3c 2d                	cmp    $0x2d,%al
  800bd5:	74 2b                	je     800c02 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bd7:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bdd:	75 0f                	jne    800bee <strtol+0x40>
  800bdf:	80 39 30             	cmpb   $0x30,(%ecx)
  800be2:	74 28                	je     800c0c <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800be4:	85 db                	test   %ebx,%ebx
  800be6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800beb:	0f 44 d8             	cmove  %eax,%ebx
  800bee:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf3:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bf6:	eb 50                	jmp    800c48 <strtol+0x9a>
		s++;
  800bf8:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bfb:	bf 00 00 00 00       	mov    $0x0,%edi
  800c00:	eb d5                	jmp    800bd7 <strtol+0x29>
		s++, neg = 1;
  800c02:	83 c1 01             	add    $0x1,%ecx
  800c05:	bf 01 00 00 00       	mov    $0x1,%edi
  800c0a:	eb cb                	jmp    800bd7 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c0c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c10:	74 0e                	je     800c20 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c12:	85 db                	test   %ebx,%ebx
  800c14:	75 d8                	jne    800bee <strtol+0x40>
		s++, base = 8;
  800c16:	83 c1 01             	add    $0x1,%ecx
  800c19:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c1e:	eb ce                	jmp    800bee <strtol+0x40>
		s += 2, base = 16;
  800c20:	83 c1 02             	add    $0x2,%ecx
  800c23:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c28:	eb c4                	jmp    800bee <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c2a:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c2d:	89 f3                	mov    %esi,%ebx
  800c2f:	80 fb 19             	cmp    $0x19,%bl
  800c32:	77 29                	ja     800c5d <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c34:	0f be d2             	movsbl %dl,%edx
  800c37:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c3a:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c3d:	7d 30                	jge    800c6f <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c3f:	83 c1 01             	add    $0x1,%ecx
  800c42:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c46:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c48:	0f b6 11             	movzbl (%ecx),%edx
  800c4b:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c4e:	89 f3                	mov    %esi,%ebx
  800c50:	80 fb 09             	cmp    $0x9,%bl
  800c53:	77 d5                	ja     800c2a <strtol+0x7c>
			dig = *s - '0';
  800c55:	0f be d2             	movsbl %dl,%edx
  800c58:	83 ea 30             	sub    $0x30,%edx
  800c5b:	eb dd                	jmp    800c3a <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c5d:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c60:	89 f3                	mov    %esi,%ebx
  800c62:	80 fb 19             	cmp    $0x19,%bl
  800c65:	77 08                	ja     800c6f <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c67:	0f be d2             	movsbl %dl,%edx
  800c6a:	83 ea 37             	sub    $0x37,%edx
  800c6d:	eb cb                	jmp    800c3a <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c73:	74 05                	je     800c7a <strtol+0xcc>
		*endptr = (char *) s;
  800c75:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c78:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c7a:	89 c2                	mov    %eax,%edx
  800c7c:	f7 da                	neg    %edx
  800c7e:	85 ff                	test   %edi,%edi
  800c80:	0f 45 c2             	cmovne %edx,%eax
}
  800c83:	5b                   	pop    %ebx
  800c84:	5e                   	pop    %esi
  800c85:	5f                   	pop    %edi
  800c86:	5d                   	pop    %ebp
  800c87:	c3                   	ret    

00800c88 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
  800c8b:	57                   	push   %edi
  800c8c:	56                   	push   %esi
  800c8d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c8e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c93:	8b 55 08             	mov    0x8(%ebp),%edx
  800c96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c99:	89 c3                	mov    %eax,%ebx
  800c9b:	89 c7                	mov    %eax,%edi
  800c9d:	89 c6                	mov    %eax,%esi
  800c9f:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ca1:	5b                   	pop    %ebx
  800ca2:	5e                   	pop    %esi
  800ca3:	5f                   	pop    %edi
  800ca4:	5d                   	pop    %ebp
  800ca5:	c3                   	ret    

00800ca6 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	57                   	push   %edi
  800caa:	56                   	push   %esi
  800cab:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cac:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb1:	b8 01 00 00 00       	mov    $0x1,%eax
  800cb6:	89 d1                	mov    %edx,%ecx
  800cb8:	89 d3                	mov    %edx,%ebx
  800cba:	89 d7                	mov    %edx,%edi
  800cbc:	89 d6                	mov    %edx,%esi
  800cbe:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cc0:	5b                   	pop    %ebx
  800cc1:	5e                   	pop    %esi
  800cc2:	5f                   	pop    %edi
  800cc3:	5d                   	pop    %ebp
  800cc4:	c3                   	ret    

00800cc5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	57                   	push   %edi
  800cc9:	56                   	push   %esi
  800cca:	53                   	push   %ebx
  800ccb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cce:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd6:	b8 03 00 00 00       	mov    $0x3,%eax
  800cdb:	89 cb                	mov    %ecx,%ebx
  800cdd:	89 cf                	mov    %ecx,%edi
  800cdf:	89 ce                	mov    %ecx,%esi
  800ce1:	cd 30                	int    $0x30
	if (check && ret > 0)
  800ce3:	85 c0                	test   %eax,%eax
  800ce5:	7f 08                	jg     800cef <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ce7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cea:	5b                   	pop    %ebx
  800ceb:	5e                   	pop    %esi
  800cec:	5f                   	pop    %edi
  800ced:	5d                   	pop    %ebp
  800cee:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cef:	83 ec 0c             	sub    $0xc,%esp
  800cf2:	50                   	push   %eax
  800cf3:	6a 03                	push   $0x3
  800cf5:	68 60 1b 80 00       	push   $0x801b60
  800cfa:	6a 4c                	push   $0x4c
  800cfc:	68 7d 1b 80 00       	push   $0x801b7d
  800d01:	e8 4b f4 ff ff       	call   800151 <_panic>

00800d06 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	57                   	push   %edi
  800d0a:	56                   	push   %esi
  800d0b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d0c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d11:	b8 02 00 00 00       	mov    $0x2,%eax
  800d16:	89 d1                	mov    %edx,%ecx
  800d18:	89 d3                	mov    %edx,%ebx
  800d1a:	89 d7                	mov    %edx,%edi
  800d1c:	89 d6                	mov    %edx,%esi
  800d1e:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d20:	5b                   	pop    %ebx
  800d21:	5e                   	pop    %esi
  800d22:	5f                   	pop    %edi
  800d23:	5d                   	pop    %ebp
  800d24:	c3                   	ret    

00800d25 <sys_yield>:

void
sys_yield(void)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
  800d28:	57                   	push   %edi
  800d29:	56                   	push   %esi
  800d2a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d2b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d30:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d35:	89 d1                	mov    %edx,%ecx
  800d37:	89 d3                	mov    %edx,%ebx
  800d39:	89 d7                	mov    %edx,%edi
  800d3b:	89 d6                	mov    %edx,%esi
  800d3d:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d3f:	5b                   	pop    %ebx
  800d40:	5e                   	pop    %esi
  800d41:	5f                   	pop    %edi
  800d42:	5d                   	pop    %ebp
  800d43:	c3                   	ret    

00800d44 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
  800d47:	57                   	push   %edi
  800d48:	56                   	push   %esi
  800d49:	53                   	push   %ebx
  800d4a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d4d:	be 00 00 00 00       	mov    $0x0,%esi
  800d52:	8b 55 08             	mov    0x8(%ebp),%edx
  800d55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d58:	b8 04 00 00 00       	mov    $0x4,%eax
  800d5d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d60:	89 f7                	mov    %esi,%edi
  800d62:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d64:	85 c0                	test   %eax,%eax
  800d66:	7f 08                	jg     800d70 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d68:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6b:	5b                   	pop    %ebx
  800d6c:	5e                   	pop    %esi
  800d6d:	5f                   	pop    %edi
  800d6e:	5d                   	pop    %ebp
  800d6f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d70:	83 ec 0c             	sub    $0xc,%esp
  800d73:	50                   	push   %eax
  800d74:	6a 04                	push   $0x4
  800d76:	68 60 1b 80 00       	push   $0x801b60
  800d7b:	6a 4c                	push   $0x4c
  800d7d:	68 7d 1b 80 00       	push   $0x801b7d
  800d82:	e8 ca f3 ff ff       	call   800151 <_panic>

00800d87 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d87:	55                   	push   %ebp
  800d88:	89 e5                	mov    %esp,%ebp
  800d8a:	57                   	push   %edi
  800d8b:	56                   	push   %esi
  800d8c:	53                   	push   %ebx
  800d8d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d90:	8b 55 08             	mov    0x8(%ebp),%edx
  800d93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d96:	b8 05 00 00 00       	mov    $0x5,%eax
  800d9b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d9e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800da1:	8b 75 18             	mov    0x18(%ebp),%esi
  800da4:	cd 30                	int    $0x30
	if (check && ret > 0)
  800da6:	85 c0                	test   %eax,%eax
  800da8:	7f 08                	jg     800db2 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800daa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dad:	5b                   	pop    %ebx
  800dae:	5e                   	pop    %esi
  800daf:	5f                   	pop    %edi
  800db0:	5d                   	pop    %ebp
  800db1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db2:	83 ec 0c             	sub    $0xc,%esp
  800db5:	50                   	push   %eax
  800db6:	6a 05                	push   $0x5
  800db8:	68 60 1b 80 00       	push   $0x801b60
  800dbd:	6a 4c                	push   $0x4c
  800dbf:	68 7d 1b 80 00       	push   $0x801b7d
  800dc4:	e8 88 f3 ff ff       	call   800151 <_panic>

00800dc9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dc9:	55                   	push   %ebp
  800dca:	89 e5                	mov    %esp,%ebp
  800dcc:	57                   	push   %edi
  800dcd:	56                   	push   %esi
  800dce:	53                   	push   %ebx
  800dcf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd7:	8b 55 08             	mov    0x8(%ebp),%edx
  800dda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ddd:	b8 06 00 00 00       	mov    $0x6,%eax
  800de2:	89 df                	mov    %ebx,%edi
  800de4:	89 de                	mov    %ebx,%esi
  800de6:	cd 30                	int    $0x30
	if (check && ret > 0)
  800de8:	85 c0                	test   %eax,%eax
  800dea:	7f 08                	jg     800df4 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800def:	5b                   	pop    %ebx
  800df0:	5e                   	pop    %esi
  800df1:	5f                   	pop    %edi
  800df2:	5d                   	pop    %ebp
  800df3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df4:	83 ec 0c             	sub    $0xc,%esp
  800df7:	50                   	push   %eax
  800df8:	6a 06                	push   $0x6
  800dfa:	68 60 1b 80 00       	push   $0x801b60
  800dff:	6a 4c                	push   $0x4c
  800e01:	68 7d 1b 80 00       	push   $0x801b7d
  800e06:	e8 46 f3 ff ff       	call   800151 <_panic>

00800e0b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e0b:	55                   	push   %ebp
  800e0c:	89 e5                	mov    %esp,%ebp
  800e0e:	57                   	push   %edi
  800e0f:	56                   	push   %esi
  800e10:	53                   	push   %ebx
  800e11:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e14:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e19:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1f:	b8 08 00 00 00       	mov    $0x8,%eax
  800e24:	89 df                	mov    %ebx,%edi
  800e26:	89 de                	mov    %ebx,%esi
  800e28:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e2a:	85 c0                	test   %eax,%eax
  800e2c:	7f 08                	jg     800e36 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e31:	5b                   	pop    %ebx
  800e32:	5e                   	pop    %esi
  800e33:	5f                   	pop    %edi
  800e34:	5d                   	pop    %ebp
  800e35:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e36:	83 ec 0c             	sub    $0xc,%esp
  800e39:	50                   	push   %eax
  800e3a:	6a 08                	push   $0x8
  800e3c:	68 60 1b 80 00       	push   $0x801b60
  800e41:	6a 4c                	push   $0x4c
  800e43:	68 7d 1b 80 00       	push   $0x801b7d
  800e48:	e8 04 f3 ff ff       	call   800151 <_panic>

00800e4d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e4d:	55                   	push   %ebp
  800e4e:	89 e5                	mov    %esp,%ebp
  800e50:	57                   	push   %edi
  800e51:	56                   	push   %esi
  800e52:	53                   	push   %ebx
  800e53:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e56:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e61:	b8 09 00 00 00       	mov    $0x9,%eax
  800e66:	89 df                	mov    %ebx,%edi
  800e68:	89 de                	mov    %ebx,%esi
  800e6a:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e6c:	85 c0                	test   %eax,%eax
  800e6e:	7f 08                	jg     800e78 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e73:	5b                   	pop    %ebx
  800e74:	5e                   	pop    %esi
  800e75:	5f                   	pop    %edi
  800e76:	5d                   	pop    %ebp
  800e77:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e78:	83 ec 0c             	sub    $0xc,%esp
  800e7b:	50                   	push   %eax
  800e7c:	6a 09                	push   $0x9
  800e7e:	68 60 1b 80 00       	push   $0x801b60
  800e83:	6a 4c                	push   $0x4c
  800e85:	68 7d 1b 80 00       	push   $0x801b7d
  800e8a:	e8 c2 f2 ff ff       	call   800151 <_panic>

00800e8f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e8f:	55                   	push   %ebp
  800e90:	89 e5                	mov    %esp,%ebp
  800e92:	57                   	push   %edi
  800e93:	56                   	push   %esi
  800e94:	53                   	push   %ebx
  800e95:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e98:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9d:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea3:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ea8:	89 df                	mov    %ebx,%edi
  800eaa:	89 de                	mov    %ebx,%esi
  800eac:	cd 30                	int    $0x30
	if (check && ret > 0)
  800eae:	85 c0                	test   %eax,%eax
  800eb0:	7f 08                	jg     800eba <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800eb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb5:	5b                   	pop    %ebx
  800eb6:	5e                   	pop    %esi
  800eb7:	5f                   	pop    %edi
  800eb8:	5d                   	pop    %ebp
  800eb9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eba:	83 ec 0c             	sub    $0xc,%esp
  800ebd:	50                   	push   %eax
  800ebe:	6a 0a                	push   $0xa
  800ec0:	68 60 1b 80 00       	push   $0x801b60
  800ec5:	6a 4c                	push   $0x4c
  800ec7:	68 7d 1b 80 00       	push   $0x801b7d
  800ecc:	e8 80 f2 ff ff       	call   800151 <_panic>

00800ed1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ed1:	55                   	push   %ebp
  800ed2:	89 e5                	mov    %esp,%ebp
  800ed4:	57                   	push   %edi
  800ed5:	56                   	push   %esi
  800ed6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ed7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800edd:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ee2:	be 00 00 00 00       	mov    $0x0,%esi
  800ee7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eea:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eed:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800eef:	5b                   	pop    %ebx
  800ef0:	5e                   	pop    %esi
  800ef1:	5f                   	pop    %edi
  800ef2:	5d                   	pop    %ebp
  800ef3:	c3                   	ret    

00800ef4 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ef4:	55                   	push   %ebp
  800ef5:	89 e5                	mov    %esp,%ebp
  800ef7:	57                   	push   %edi
  800ef8:	56                   	push   %esi
  800ef9:	53                   	push   %ebx
  800efa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800efd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f02:	8b 55 08             	mov    0x8(%ebp),%edx
  800f05:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f0a:	89 cb                	mov    %ecx,%ebx
  800f0c:	89 cf                	mov    %ecx,%edi
  800f0e:	89 ce                	mov    %ecx,%esi
  800f10:	cd 30                	int    $0x30
	if (check && ret > 0)
  800f12:	85 c0                	test   %eax,%eax
  800f14:	7f 08                	jg     800f1e <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f16:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f19:	5b                   	pop    %ebx
  800f1a:	5e                   	pop    %esi
  800f1b:	5f                   	pop    %edi
  800f1c:	5d                   	pop    %ebp
  800f1d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1e:	83 ec 0c             	sub    $0xc,%esp
  800f21:	50                   	push   %eax
  800f22:	6a 0d                	push   $0xd
  800f24:	68 60 1b 80 00       	push   $0x801b60
  800f29:	6a 4c                	push   $0x4c
  800f2b:	68 7d 1b 80 00       	push   $0x801b7d
  800f30:	e8 1c f2 ff ff       	call   800151 <_panic>

00800f35 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f35:	55                   	push   %ebp
  800f36:	89 e5                	mov    %esp,%ebp
  800f38:	57                   	push   %edi
  800f39:	56                   	push   %esi
  800f3a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f3b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f40:	8b 55 08             	mov    0x8(%ebp),%edx
  800f43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f46:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f4b:	89 df                	mov    %ebx,%edi
  800f4d:	89 de                	mov    %ebx,%esi
  800f4f:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f51:	5b                   	pop    %ebx
  800f52:	5e                   	pop    %esi
  800f53:	5f                   	pop    %edi
  800f54:	5d                   	pop    %ebp
  800f55:	c3                   	ret    

00800f56 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f56:	55                   	push   %ebp
  800f57:	89 e5                	mov    %esp,%ebp
  800f59:	57                   	push   %edi
  800f5a:	56                   	push   %esi
  800f5b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f5c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f61:	8b 55 08             	mov    0x8(%ebp),%edx
  800f64:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f69:	89 cb                	mov    %ecx,%ebx
  800f6b:	89 cf                	mov    %ecx,%edi
  800f6d:	89 ce                	mov    %ecx,%esi
  800f6f:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f71:	5b                   	pop    %ebx
  800f72:	5e                   	pop    %esi
  800f73:	5f                   	pop    %edi
  800f74:	5d                   	pop    %ebp
  800f75:	c3                   	ret    

00800f76 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f76:	55                   	push   %ebp
  800f77:	89 e5                	mov    %esp,%ebp
  800f79:	53                   	push   %ebx
  800f7a:	83 ec 04             	sub    $0x4,%esp
  800f7d:	8b 55 08             	mov    0x8(%ebp),%edx
	// cprintf("pgfault()\n");
	void *addr = (void *) utf->utf_fault_va;
  800f80:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpd[PDX(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_COW))
  800f82:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  800f86:	0f 84 9c 00 00 00    	je     801028 <pgfault+0xb2>
  800f8c:	89 c2                	mov    %eax,%edx
  800f8e:	c1 ea 16             	shr    $0x16,%edx
  800f91:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f98:	f6 c2 01             	test   $0x1,%dl
  800f9b:	0f 84 87 00 00 00    	je     801028 <pgfault+0xb2>
  800fa1:	89 c2                	mov    %eax,%edx
  800fa3:	c1 ea 0c             	shr    $0xc,%edx
  800fa6:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800fad:	f6 c1 01             	test   $0x1,%cl
  800fb0:	74 76                	je     801028 <pgfault+0xb2>
  800fb2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fb9:	f6 c6 08             	test   $0x8,%dh
  800fbc:	74 6a                	je     801028 <pgfault+0xb2>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800fbe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fc3:	89 c3                	mov    %eax,%ebx

	r = sys_page_alloc(0, PFTEMP, PTE_P|PTE_U|PTE_W);
  800fc5:	83 ec 04             	sub    $0x4,%esp
  800fc8:	6a 07                	push   $0x7
  800fca:	68 00 f0 7f 00       	push   $0x7ff000
  800fcf:	6a 00                	push   $0x0
  800fd1:	e8 6e fd ff ff       	call   800d44 <sys_page_alloc>
	if(r < 0){
  800fd6:	83 c4 10             	add    $0x10,%esp
  800fd9:	85 c0                	test   %eax,%eax
  800fdb:	78 5f                	js     80103c <pgfault+0xc6>
		panic("pgfault: sys_page_alloc fail, r: %d", r);
	}

	memmove(PFTEMP, addr, PGSIZE);
  800fdd:	83 ec 04             	sub    $0x4,%esp
  800fe0:	68 00 10 00 00       	push   $0x1000
  800fe5:	53                   	push   %ebx
  800fe6:	68 00 f0 7f 00       	push   $0x7ff000
  800feb:	e8 f0 fa ff ff       	call   800ae0 <memmove>

	r = sys_page_map(0, PFTEMP, 0, addr, PTE_P|PTE_U|PTE_W);
  800ff0:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800ff7:	53                   	push   %ebx
  800ff8:	6a 00                	push   $0x0
  800ffa:	68 00 f0 7f 00       	push   $0x7ff000
  800fff:	6a 00                	push   $0x0
  801001:	e8 81 fd ff ff       	call   800d87 <sys_page_map>
	if(r < 0){
  801006:	83 c4 20             	add    $0x20,%esp
  801009:	85 c0                	test   %eax,%eax
  80100b:	78 41                	js     80104e <pgfault+0xd8>
		panic("pgfault: sys_page_map fail, r: %d", r);
	}

	r = sys_page_unmap(0, PFTEMP);
  80100d:	83 ec 08             	sub    $0x8,%esp
  801010:	68 00 f0 7f 00       	push   $0x7ff000
  801015:	6a 00                	push   $0x0
  801017:	e8 ad fd ff ff       	call   800dc9 <sys_page_unmap>
	if(r < 0){
  80101c:	83 c4 10             	add    $0x10,%esp
  80101f:	85 c0                	test   %eax,%eax
  801021:	78 3d                	js     801060 <pgfault+0xea>
		panic("sys_page_unmap: %e", r);
	}
}
  801023:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801026:	c9                   	leave  
  801027:	c3                   	ret    
		panic("pgfault: 1\n");
  801028:	83 ec 04             	sub    $0x4,%esp
  80102b:	68 8b 1b 80 00       	push   $0x801b8b
  801030:	6a 20                	push   $0x20
  801032:	68 97 1b 80 00       	push   $0x801b97
  801037:	e8 15 f1 ff ff       	call   800151 <_panic>
		panic("pgfault: sys_page_alloc fail, r: %d", r);
  80103c:	50                   	push   %eax
  80103d:	68 ec 1b 80 00       	push   $0x801bec
  801042:	6a 2e                	push   $0x2e
  801044:	68 97 1b 80 00       	push   $0x801b97
  801049:	e8 03 f1 ff ff       	call   800151 <_panic>
		panic("pgfault: sys_page_map fail, r: %d", r);
  80104e:	50                   	push   %eax
  80104f:	68 10 1c 80 00       	push   $0x801c10
  801054:	6a 35                	push   $0x35
  801056:	68 97 1b 80 00       	push   $0x801b97
  80105b:	e8 f1 f0 ff ff       	call   800151 <_panic>
		panic("sys_page_unmap: %e", r);
  801060:	50                   	push   %eax
  801061:	68 a2 1b 80 00       	push   $0x801ba2
  801066:	6a 3a                	push   $0x3a
  801068:	68 97 1b 80 00       	push   $0x801b97
  80106d:	e8 df f0 ff ff       	call   800151 <_panic>

00801072 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801072:	55                   	push   %ebp
  801073:	89 e5                	mov    %esp,%ebp
  801075:	57                   	push   %edi
  801076:	56                   	push   %esi
  801077:	53                   	push   %ebx
  801078:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	// panic("fork not implemented");
	int r;
	set_pgfault_handler(pgfault);
  80107b:	68 76 0f 80 00       	push   $0x800f76
  801080:	e8 02 04 00 00       	call   801487 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801085:	b8 07 00 00 00       	mov    $0x7,%eax
  80108a:	cd 30                	int    $0x30
  80108c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int i;
	uintptr_t va;
	envid_t childid = sys_exofork();
	if (childid < 0){
  80108f:	83 c4 10             	add    $0x10,%esp
  801092:	85 c0                	test   %eax,%eax
  801094:	78 2c                	js     8010c2 <fork+0x50>
  801096:	89 c7                	mov    %eax,%edi
	}

	extern volatile pde_t uvpd[];
	extern volatile pte_t uvpt[];

	for (va = UTEXT; va < USTACKTOP; va += PGSIZE){
  801098:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (childid == 0) {
  80109d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010a1:	75 72                	jne    801115 <fork+0xa3>
		thisenv = &envs[ENVX(sys_getenvid())];
  8010a3:	e8 5e fc ff ff       	call   800d06 <sys_getenvid>
  8010a8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010ad:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8010b3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010b8:	a3 04 20 80 00       	mov    %eax,0x802004
		return 0;
  8010bd:	e9 36 01 00 00       	jmp    8011f8 <fork+0x186>
		panic("fork: child id < 0: %d", childid);
  8010c2:	50                   	push   %eax
  8010c3:	68 b5 1b 80 00       	push   $0x801bb5
  8010c8:	68 83 00 00 00       	push   $0x83
  8010cd:	68 97 1b 80 00       	push   $0x801b97
  8010d2:	e8 7a f0 ff ff       	call   800151 <_panic>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  8010d7:	50                   	push   %eax
  8010d8:	68 34 1c 80 00       	push   $0x801c34
  8010dd:	6a 56                	push   $0x56
  8010df:	68 97 1b 80 00       	push   $0x801b97
  8010e4:	e8 68 f0 ff ff       	call   800151 <_panic>
		r = sys_page_map((envid_t)0, va, envid, va, PTE_U | PTE_P);
  8010e9:	83 ec 0c             	sub    $0xc,%esp
  8010ec:	6a 05                	push   $0x5
  8010ee:	56                   	push   %esi
  8010ef:	57                   	push   %edi
  8010f0:	56                   	push   %esi
  8010f1:	6a 00                	push   $0x0
  8010f3:	e8 8f fc ff ff       	call   800d87 <sys_page_map>
		if(r < 0){
  8010f8:	83 c4 20             	add    $0x20,%esp
  8010fb:	85 c0                	test   %eax,%eax
  8010fd:	0f 88 9f 00 00 00    	js     8011a2 <fork+0x130>
	for (va = UTEXT; va < USTACKTOP; va += PGSIZE){
  801103:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801109:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80110f:	0f 84 9f 00 00 00    	je     8011b4 <fork+0x142>
		if ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_U)){
  801115:	89 d8                	mov    %ebx,%eax
  801117:	c1 e8 16             	shr    $0x16,%eax
  80111a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801121:	a8 01                	test   $0x1,%al
  801123:	74 de                	je     801103 <fork+0x91>
  801125:	89 d8                	mov    %ebx,%eax
  801127:	c1 e8 0c             	shr    $0xc,%eax
  80112a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801131:	f6 c2 01             	test   $0x1,%dl
  801134:	74 cd                	je     801103 <fork+0x91>
  801136:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80113d:	f6 c2 04             	test   $0x4,%dl
  801140:	74 c1                	je     801103 <fork+0x91>
	void * va = (void *)(pn * PGSIZE);
  801142:	89 c6                	mov    %eax,%esi
  801144:	c1 e6 0c             	shl    $0xc,%esi
	int perm = (uvpt[pn]);
  801147:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (perm & (PTE_W | PTE_COW)) {
  80114e:	a9 02 08 00 00       	test   $0x802,%eax
  801153:	74 94                	je     8010e9 <fork+0x77>
		r = sys_page_map((envid_t)0, va, envid, va, PTE_U | PTE_P | PTE_COW);
  801155:	83 ec 0c             	sub    $0xc,%esp
  801158:	68 05 08 00 00       	push   $0x805
  80115d:	56                   	push   %esi
  80115e:	57                   	push   %edi
  80115f:	56                   	push   %esi
  801160:	6a 00                	push   $0x0
  801162:	e8 20 fc ff ff       	call   800d87 <sys_page_map>
		if(r < 0){
  801167:	83 c4 20             	add    $0x20,%esp
  80116a:	85 c0                	test   %eax,%eax
  80116c:	0f 88 65 ff ff ff    	js     8010d7 <fork+0x65>
		r = sys_page_map((envid_t)0, va, (envid_t)0, va, PTE_U | PTE_P | PTE_COW);
  801172:	83 ec 0c             	sub    $0xc,%esp
  801175:	68 05 08 00 00       	push   $0x805
  80117a:	56                   	push   %esi
  80117b:	6a 00                	push   $0x0
  80117d:	56                   	push   %esi
  80117e:	6a 00                	push   $0x0
  801180:	e8 02 fc ff ff       	call   800d87 <sys_page_map>
		if(r < 0){
  801185:	83 c4 20             	add    $0x20,%esp
  801188:	85 c0                	test   %eax,%eax
  80118a:	0f 89 73 ff ff ff    	jns    801103 <fork+0x91>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  801190:	50                   	push   %eax
  801191:	68 34 1c 80 00       	push   $0x801c34
  801196:	6a 5b                	push   $0x5b
  801198:	68 97 1b 80 00       	push   $0x801b97
  80119d:	e8 af ef ff ff       	call   800151 <_panic>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  8011a2:	50                   	push   %eax
  8011a3:	68 34 1c 80 00       	push   $0x801c34
  8011a8:	6a 61                	push   $0x61
  8011aa:	68 97 1b 80 00       	push   $0x801b97
  8011af:	e8 9d ef ff ff       	call   800151 <_panic>
			duppage(childid, PGNUM(va));
		}
	}

	r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8011b4:	83 ec 04             	sub    $0x4,%esp
  8011b7:	6a 07                	push   $0x7
  8011b9:	68 00 f0 bf ee       	push   $0xeebff000
  8011be:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011c1:	e8 7e fb ff ff       	call   800d44 <sys_page_alloc>
	if (r < 0){
  8011c6:	83 c4 10             	add    $0x10,%esp
  8011c9:	85 c0                	test   %eax,%eax
  8011cb:	78 36                	js     801203 <fork+0x191>
		panic("fork: allocate user exception stack for child env error, %d", r);
	}
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  8011cd:	83 ec 08             	sub    $0x8,%esp
  8011d0:	68 f2 14 80 00       	push   $0x8014f2
  8011d5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011d8:	e8 b2 fc ff ff       	call   800e8f <sys_env_set_pgfault_upcall>
	if (r < 0){
  8011dd:	83 c4 10             	add    $0x10,%esp
  8011e0:	85 c0                	test   %eax,%eax
  8011e2:	78 34                	js     801218 <fork+0x1a6>
		panic("fork: sys_env_set_pgfault_upcall error, %d", r);
	}
	r = sys_env_set_status(childid, ENV_RUNNABLE);
  8011e4:	83 ec 08             	sub    $0x8,%esp
  8011e7:	6a 02                	push   $0x2
  8011e9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011ec:	e8 1a fc ff ff       	call   800e0b <sys_env_set_status>
	if(r < 0){
  8011f1:	83 c4 10             	add    $0x10,%esp
  8011f4:	85 c0                	test   %eax,%eax
  8011f6:	78 35                	js     80122d <fork+0x1bb>
		panic("forK: sys_env_set_status, r%d", r);
	}
	return childid;
}
  8011f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011fe:	5b                   	pop    %ebx
  8011ff:	5e                   	pop    %esi
  801200:	5f                   	pop    %edi
  801201:	5d                   	pop    %ebp
  801202:	c3                   	ret    
		panic("fork: allocate user exception stack for child env error, %d", r);
  801203:	50                   	push   %eax
  801204:	68 5c 1c 80 00       	push   $0x801c5c
  801209:	68 96 00 00 00       	push   $0x96
  80120e:	68 97 1b 80 00       	push   $0x801b97
  801213:	e8 39 ef ff ff       	call   800151 <_panic>
		panic("fork: sys_env_set_pgfault_upcall error, %d", r);
  801218:	50                   	push   %eax
  801219:	68 98 1c 80 00       	push   $0x801c98
  80121e:	68 9a 00 00 00       	push   $0x9a
  801223:	68 97 1b 80 00       	push   $0x801b97
  801228:	e8 24 ef ff ff       	call   800151 <_panic>
		panic("forK: sys_env_set_status, r%d", r);
  80122d:	50                   	push   %eax
  80122e:	68 cc 1b 80 00       	push   $0x801bcc
  801233:	68 9e 00 00 00       	push   $0x9e
  801238:	68 97 1b 80 00       	push   $0x801b97
  80123d:	e8 0f ef ff ff       	call   800151 <_panic>

00801242 <sfork>:

// Challenge!
int
sfork(void)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	57                   	push   %edi
  801246:	56                   	push   %esi
  801247:	53                   	push   %ebx
  801248:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// return -E_INVAL;
	set_pgfault_handler(pgfault);
  80124b:	68 76 0f 80 00       	push   $0x800f76
  801250:	e8 32 02 00 00       	call   801487 <set_pgfault_handler>
  801255:	b8 07 00 00 00       	mov    $0x7,%eax
  80125a:	cd 30                	int    $0x30
  80125c:	89 c6                	mov    %eax,%esi
	int i;
	uintptr_t va;
	envid_t childid = sys_exofork();
	int r;
	if (childid < 0){
  80125e:	83 c4 10             	add    $0x10,%esp
  801261:	85 c0                	test   %eax,%eax
  801263:	78 28                	js     80128d <sfork+0x4b>
  801265:	89 c7                	mov    %eax,%edi
	}

	extern volatile pde_t uvpd[];
	extern volatile pte_t uvpt[];

	for (va = 0; va < USTACKTOP; va += PGSIZE){
  801267:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (childid == 0) {
  80126c:	75 42                	jne    8012b0 <sfork+0x6e>
		thisenv = &envs[ENVX(sys_getenvid())];
  80126e:	e8 93 fa ff ff       	call   800d06 <sys_getenvid>
  801273:	25 ff 03 00 00       	and    $0x3ff,%eax
  801278:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80127e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801283:	a3 04 20 80 00       	mov    %eax,0x802004
		return 0;
  801288:	e9 bc 00 00 00       	jmp    801349 <sfork+0x107>
		panic("fork: child id < 0: %d", childid);
  80128d:	50                   	push   %eax
  80128e:	68 b5 1b 80 00       	push   $0x801bb5
  801293:	68 af 00 00 00       	push   $0xaf
  801298:	68 97 1b 80 00       	push   $0x801b97
  80129d:	e8 af ee ff ff       	call   800151 <_panic>
	for (va = 0; va < USTACKTOP; va += PGSIZE){
  8012a2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8012a8:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8012ae:	74 5b                	je     80130b <sfork+0xc9>
		if ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_U)){
  8012b0:	89 d8                	mov    %ebx,%eax
  8012b2:	c1 e8 16             	shr    $0x16,%eax
  8012b5:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012bc:	a8 01                	test   $0x1,%al
  8012be:	74 e2                	je     8012a2 <sfork+0x60>
  8012c0:	89 d8                	mov    %ebx,%eax
  8012c2:	c1 e8 0c             	shr    $0xc,%eax
  8012c5:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012cc:	f6 c2 01             	test   $0x1,%dl
  8012cf:	74 d1                	je     8012a2 <sfork+0x60>
  8012d1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012d8:	f6 c2 04             	test   $0x4,%dl
  8012db:	74 c5                	je     8012a2 <sfork+0x60>
			void *addr = (void *)(PGNUM(va) * PGSIZE);
  8012dd:	c1 e0 0c             	shl    $0xc,%eax
			struct PageInfo *page;
			pte_t *pte;
			
			// page = page_lookup((envid_t)0->env_pgdir, addr, &pte);
			// page_insert(dstenv->env_pgdir, page, addr, PTE_U | PTE_P);
			r = sys_page_map((envid_t)0, addr, childid, addr, PTE_U | PTE_P);
  8012e0:	83 ec 0c             	sub    $0xc,%esp
  8012e3:	6a 05                	push   $0x5
  8012e5:	50                   	push   %eax
  8012e6:	57                   	push   %edi
  8012e7:	50                   	push   %eax
  8012e8:	6a 00                	push   $0x0
  8012ea:	e8 98 fa ff ff       	call   800d87 <sys_page_map>
			if(r < 0){
  8012ef:	83 c4 20             	add    $0x20,%esp
  8012f2:	85 c0                	test   %eax,%eax
  8012f4:	79 ac                	jns    8012a2 <sfork+0x60>
				panic("sfork: sys_page_map fail, r:%d\n", r);
  8012f6:	50                   	push   %eax
  8012f7:	68 c4 1c 80 00       	push   $0x801cc4
  8012fc:	68 c4 00 00 00       	push   $0xc4
  801301:	68 97 1b 80 00       	push   $0x801b97
  801306:	e8 46 ee ff ff       	call   800151 <_panic>
			}
		}
	}

	r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80130b:	83 ec 04             	sub    $0x4,%esp
  80130e:	6a 07                	push   $0x7
  801310:	68 00 f0 bf ee       	push   $0xeebff000
  801315:	56                   	push   %esi
  801316:	e8 29 fa ff ff       	call   800d44 <sys_page_alloc>
	if (r < 0){
  80131b:	83 c4 10             	add    $0x10,%esp
  80131e:	85 c0                	test   %eax,%eax
  801320:	78 31                	js     801353 <sfork+0x111>
		panic("sfork: allocate user exception stack for child env error, %d", r);
	}
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  801322:	83 ec 08             	sub    $0x8,%esp
  801325:	68 f2 14 80 00       	push   $0x8014f2
  80132a:	56                   	push   %esi
  80132b:	e8 5f fb ff ff       	call   800e8f <sys_env_set_pgfault_upcall>
	if (r < 0){
  801330:	83 c4 10             	add    $0x10,%esp
  801333:	85 c0                	test   %eax,%eax
  801335:	78 31                	js     801368 <sfork+0x126>
		panic("sfork: sys_env_set_pgfault_upcall error, %d", r);
	}
	r = sys_env_set_status(childid, ENV_RUNNABLE);
  801337:	83 ec 08             	sub    $0x8,%esp
  80133a:	6a 02                	push   $0x2
  80133c:	56                   	push   %esi
  80133d:	e8 c9 fa ff ff       	call   800e0b <sys_env_set_status>
	if(r < 0){
  801342:	83 c4 10             	add    $0x10,%esp
  801345:	85 c0                	test   %eax,%eax
  801347:	78 34                	js     80137d <sfork+0x13b>
		panic("sforK: sys_env_set_status, r%d", r);
	}
	return childid;
}
  801349:	89 f0                	mov    %esi,%eax
  80134b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80134e:	5b                   	pop    %ebx
  80134f:	5e                   	pop    %esi
  801350:	5f                   	pop    %edi
  801351:	5d                   	pop    %ebp
  801352:	c3                   	ret    
		panic("sfork: allocate user exception stack for child env error, %d", r);
  801353:	50                   	push   %eax
  801354:	68 e4 1c 80 00       	push   $0x801ce4
  801359:	68 cb 00 00 00       	push   $0xcb
  80135e:	68 97 1b 80 00       	push   $0x801b97
  801363:	e8 e9 ed ff ff       	call   800151 <_panic>
		panic("sfork: sys_env_set_pgfault_upcall error, %d", r);
  801368:	50                   	push   %eax
  801369:	68 24 1d 80 00       	push   $0x801d24
  80136e:	68 cf 00 00 00       	push   $0xcf
  801373:	68 97 1b 80 00       	push   $0x801b97
  801378:	e8 d4 ed ff ff       	call   800151 <_panic>
		panic("sforK: sys_env_set_status, r%d", r);
  80137d:	50                   	push   %eax
  80137e:	68 50 1d 80 00       	push   $0x801d50
  801383:	68 d3 00 00 00       	push   $0xd3
  801388:	68 97 1b 80 00       	push   $0x801b97
  80138d:	e8 bf ed ff ff       	call   800151 <_panic>

00801392 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801392:	55                   	push   %ebp
  801393:	89 e5                	mov    %esp,%ebp
  801395:	56                   	push   %esi
  801396:	53                   	push   %ebx
  801397:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80139a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139d:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// return 0;
	if(!pg)
  8013a0:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  8013a2:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8013a7:	0f 44 c2             	cmove  %edx,%eax
	
	int ret;

	ret = sys_ipc_recv(pg);
  8013aa:	83 ec 0c             	sub    $0xc,%esp
  8013ad:	50                   	push   %eax
  8013ae:	e8 41 fb ff ff       	call   800ef4 <sys_ipc_recv>
	if(ret < 0){
  8013b3:	83 c4 10             	add    $0x10,%esp
  8013b6:	85 c0                	test   %eax,%eax
  8013b8:	78 2b                	js     8013e5 <ipc_recv+0x53>
		if(perm_store) *perm_store = 0;
		if(from_env_store) *from_env_store = 0;
		return ret;
	}
	
	if(perm_store)
  8013ba:	85 f6                	test   %esi,%esi
  8013bc:	74 0a                	je     8013c8 <ipc_recv+0x36>
		*perm_store = thisenv->env_ipc_perm;
  8013be:	a1 04 20 80 00       	mov    0x802004,%eax
  8013c3:	8b 40 78             	mov    0x78(%eax),%eax
  8013c6:	89 06                	mov    %eax,(%esi)
	if(from_env_store)
  8013c8:	85 db                	test   %ebx,%ebx
  8013ca:	74 0a                	je     8013d6 <ipc_recv+0x44>
		*from_env_store = thisenv->env_ipc_from;
  8013cc:	a1 04 20 80 00       	mov    0x802004,%eax
  8013d1:	8b 40 74             	mov    0x74(%eax),%eax
  8013d4:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  8013d6:	a1 04 20 80 00       	mov    0x802004,%eax
  8013db:	8b 40 70             	mov    0x70(%eax),%eax
}
  8013de:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013e1:	5b                   	pop    %ebx
  8013e2:	5e                   	pop    %esi
  8013e3:	5d                   	pop    %ebp
  8013e4:	c3                   	ret    
		if(perm_store) *perm_store = 0;
  8013e5:	85 f6                	test   %esi,%esi
  8013e7:	74 06                	je     8013ef <ipc_recv+0x5d>
  8013e9:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(from_env_store) *from_env_store = 0;
  8013ef:	85 db                	test   %ebx,%ebx
  8013f1:	74 eb                	je     8013de <ipc_recv+0x4c>
  8013f3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8013f9:	eb e3                	jmp    8013de <ipc_recv+0x4c>

008013fb <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8013fb:	55                   	push   %ebp
  8013fc:	89 e5                	mov    %esp,%ebp
  8013fe:	57                   	push   %edi
  8013ff:	56                   	push   %esi
  801400:	53                   	push   %ebx
  801401:	83 ec 0c             	sub    $0xc,%esp
  801404:	8b 7d 08             	mov    0x8(%ebp),%edi
  801407:	8b 75 0c             	mov    0xc(%ebp),%esi
  80140a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
	if (!pg)
  80140d:	85 db                	test   %ebx,%ebx
		pg = (void*)UTOP;
  80140f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801414:	0f 44 d8             	cmove  %eax,%ebx

	int ret = -E_IPC_NOT_RECV;
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))) {
  801417:	ff 75 14             	pushl  0x14(%ebp)
  80141a:	53                   	push   %ebx
  80141b:	56                   	push   %esi
  80141c:	57                   	push   %edi
  80141d:	e8 af fa ff ff       	call   800ed1 <sys_ipc_try_send>
  801422:	83 c4 10             	add    $0x10,%esp
  801425:	85 c0                	test   %eax,%eax
  801427:	74 17                	je     801440 <ipc_send+0x45>
		if(ret != -E_IPC_NOT_RECV){
  801429:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80142c:	74 e9                	je     801417 <ipc_send+0x1c>
			panic("ipc_send: ret : %d", ret);
  80142e:	50                   	push   %eax
  80142f:	68 6f 1d 80 00       	push   $0x801d6f
  801434:	6a 43                	push   $0x43
  801436:	68 82 1d 80 00       	push   $0x801d82
  80143b:	e8 11 ed ff ff       	call   800151 <_panic>
			sys_yield();
		}
	}
}
  801440:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801443:	5b                   	pop    %ebx
  801444:	5e                   	pop    %esi
  801445:	5f                   	pop    %edi
  801446:	5d                   	pop    %ebp
  801447:	c3                   	ret    

00801448 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801448:	55                   	push   %ebp
  801449:	89 e5                	mov    %esp,%ebp
  80144b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80144e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801453:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  801459:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80145f:	8b 52 50             	mov    0x50(%edx),%edx
  801462:	39 ca                	cmp    %ecx,%edx
  801464:	74 11                	je     801477 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801466:	83 c0 01             	add    $0x1,%eax
  801469:	3d 00 04 00 00       	cmp    $0x400,%eax
  80146e:	75 e3                	jne    801453 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801470:	b8 00 00 00 00       	mov    $0x0,%eax
  801475:	eb 0e                	jmp    801485 <ipc_find_env+0x3d>
			return envs[i].env_id;
  801477:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80147d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801482:	8b 40 48             	mov    0x48(%eax),%eax
}
  801485:	5d                   	pop    %ebp
  801486:	c3                   	ret    

00801487 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801487:	55                   	push   %ebp
  801488:	89 e5                	mov    %esp,%ebp
  80148a:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80148d:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  801494:	74 0a                	je     8014a0 <set_pgfault_handler+0x19>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	a3 08 20 80 00       	mov    %eax,0x802008
}
  80149e:	c9                   	leave  
  80149f:	c3                   	ret    
		ret = sys_page_alloc((envid_t)0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W);
  8014a0:	83 ec 04             	sub    $0x4,%esp
  8014a3:	6a 07                	push   $0x7
  8014a5:	68 00 f0 bf ee       	push   $0xeebff000
  8014aa:	6a 00                	push   $0x0
  8014ac:	e8 93 f8 ff ff       	call   800d44 <sys_page_alloc>
		if(ret < 0){
  8014b1:	83 c4 10             	add    $0x10,%esp
  8014b4:	85 c0                	test   %eax,%eax
  8014b6:	78 28                	js     8014e0 <set_pgfault_handler+0x59>
    	ret = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8014b8:	83 ec 08             	sub    $0x8,%esp
  8014bb:	68 f2 14 80 00       	push   $0x8014f2
  8014c0:	6a 00                	push   $0x0
  8014c2:	e8 c8 f9 ff ff       	call   800e8f <sys_env_set_pgfault_upcall>
		if(ret < 0){
  8014c7:	83 c4 10             	add    $0x10,%esp
  8014ca:	85 c0                	test   %eax,%eax
  8014cc:	79 c8                	jns    801496 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
  8014ce:	50                   	push   %eax
  8014cf:	68 c0 1d 80 00       	push   $0x801dc0
  8014d4:	6a 28                	push   $0x28
  8014d6:	68 00 1e 80 00       	push   $0x801e00
  8014db:	e8 71 ec ff ff       	call   800151 <_panic>
			panic("set_pgfault_handler: sys_page_alloc fail, ret:%d", ret);
  8014e0:	50                   	push   %eax
  8014e1:	68 8c 1d 80 00       	push   $0x801d8c
  8014e6:	6a 24                	push   $0x24
  8014e8:	68 00 1e 80 00       	push   $0x801e00
  8014ed:	e8 5f ec ff ff       	call   800151 <_panic>

008014f2 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8014f2:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8014f3:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  8014f8:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8014fa:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edi
  8014fd:	8b 7c 24 28          	mov    0x28(%esp),%edi
	movl 0x30(%esp), %esi
  801501:	8b 74 24 30          	mov    0x30(%esp),%esi
	subl $4, %esi
  801505:	83 ee 04             	sub    $0x4,%esi
	movl %edi, (%esi)
  801508:	89 3e                	mov    %edi,(%esi)
	movl %esi, 0x30(%esp)
  80150a:	89 74 24 30          	mov    %esi,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  80150e:	83 c4 08             	add    $0x8,%esp
	popal
  801511:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  801512:	83 c4 04             	add    $0x4,%esp
	popfl
  801515:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801516:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  801517:	c3                   	ret    
  801518:	66 90                	xchg   %ax,%ax
  80151a:	66 90                	xchg   %ax,%ax
  80151c:	66 90                	xchg   %ax,%ax
  80151e:	66 90                	xchg   %ax,%ax

00801520 <__udivdi3>:
  801520:	55                   	push   %ebp
  801521:	57                   	push   %edi
  801522:	56                   	push   %esi
  801523:	53                   	push   %ebx
  801524:	83 ec 1c             	sub    $0x1c,%esp
  801527:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80152b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80152f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801533:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801537:	85 d2                	test   %edx,%edx
  801539:	75 4d                	jne    801588 <__udivdi3+0x68>
  80153b:	39 f3                	cmp    %esi,%ebx
  80153d:	76 19                	jbe    801558 <__udivdi3+0x38>
  80153f:	31 ff                	xor    %edi,%edi
  801541:	89 e8                	mov    %ebp,%eax
  801543:	89 f2                	mov    %esi,%edx
  801545:	f7 f3                	div    %ebx
  801547:	89 fa                	mov    %edi,%edx
  801549:	83 c4 1c             	add    $0x1c,%esp
  80154c:	5b                   	pop    %ebx
  80154d:	5e                   	pop    %esi
  80154e:	5f                   	pop    %edi
  80154f:	5d                   	pop    %ebp
  801550:	c3                   	ret    
  801551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801558:	89 d9                	mov    %ebx,%ecx
  80155a:	85 db                	test   %ebx,%ebx
  80155c:	75 0b                	jne    801569 <__udivdi3+0x49>
  80155e:	b8 01 00 00 00       	mov    $0x1,%eax
  801563:	31 d2                	xor    %edx,%edx
  801565:	f7 f3                	div    %ebx
  801567:	89 c1                	mov    %eax,%ecx
  801569:	31 d2                	xor    %edx,%edx
  80156b:	89 f0                	mov    %esi,%eax
  80156d:	f7 f1                	div    %ecx
  80156f:	89 c6                	mov    %eax,%esi
  801571:	89 e8                	mov    %ebp,%eax
  801573:	89 f7                	mov    %esi,%edi
  801575:	f7 f1                	div    %ecx
  801577:	89 fa                	mov    %edi,%edx
  801579:	83 c4 1c             	add    $0x1c,%esp
  80157c:	5b                   	pop    %ebx
  80157d:	5e                   	pop    %esi
  80157e:	5f                   	pop    %edi
  80157f:	5d                   	pop    %ebp
  801580:	c3                   	ret    
  801581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801588:	39 f2                	cmp    %esi,%edx
  80158a:	77 1c                	ja     8015a8 <__udivdi3+0x88>
  80158c:	0f bd fa             	bsr    %edx,%edi
  80158f:	83 f7 1f             	xor    $0x1f,%edi
  801592:	75 2c                	jne    8015c0 <__udivdi3+0xa0>
  801594:	39 f2                	cmp    %esi,%edx
  801596:	72 06                	jb     80159e <__udivdi3+0x7e>
  801598:	31 c0                	xor    %eax,%eax
  80159a:	39 eb                	cmp    %ebp,%ebx
  80159c:	77 a9                	ja     801547 <__udivdi3+0x27>
  80159e:	b8 01 00 00 00       	mov    $0x1,%eax
  8015a3:	eb a2                	jmp    801547 <__udivdi3+0x27>
  8015a5:	8d 76 00             	lea    0x0(%esi),%esi
  8015a8:	31 ff                	xor    %edi,%edi
  8015aa:	31 c0                	xor    %eax,%eax
  8015ac:	89 fa                	mov    %edi,%edx
  8015ae:	83 c4 1c             	add    $0x1c,%esp
  8015b1:	5b                   	pop    %ebx
  8015b2:	5e                   	pop    %esi
  8015b3:	5f                   	pop    %edi
  8015b4:	5d                   	pop    %ebp
  8015b5:	c3                   	ret    
  8015b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8015bd:	8d 76 00             	lea    0x0(%esi),%esi
  8015c0:	89 f9                	mov    %edi,%ecx
  8015c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8015c7:	29 f8                	sub    %edi,%eax
  8015c9:	d3 e2                	shl    %cl,%edx
  8015cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8015cf:	89 c1                	mov    %eax,%ecx
  8015d1:	89 da                	mov    %ebx,%edx
  8015d3:	d3 ea                	shr    %cl,%edx
  8015d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8015d9:	09 d1                	or     %edx,%ecx
  8015db:	89 f2                	mov    %esi,%edx
  8015dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015e1:	89 f9                	mov    %edi,%ecx
  8015e3:	d3 e3                	shl    %cl,%ebx
  8015e5:	89 c1                	mov    %eax,%ecx
  8015e7:	d3 ea                	shr    %cl,%edx
  8015e9:	89 f9                	mov    %edi,%ecx
  8015eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8015ef:	89 eb                	mov    %ebp,%ebx
  8015f1:	d3 e6                	shl    %cl,%esi
  8015f3:	89 c1                	mov    %eax,%ecx
  8015f5:	d3 eb                	shr    %cl,%ebx
  8015f7:	09 de                	or     %ebx,%esi
  8015f9:	89 f0                	mov    %esi,%eax
  8015fb:	f7 74 24 08          	divl   0x8(%esp)
  8015ff:	89 d6                	mov    %edx,%esi
  801601:	89 c3                	mov    %eax,%ebx
  801603:	f7 64 24 0c          	mull   0xc(%esp)
  801607:	39 d6                	cmp    %edx,%esi
  801609:	72 15                	jb     801620 <__udivdi3+0x100>
  80160b:	89 f9                	mov    %edi,%ecx
  80160d:	d3 e5                	shl    %cl,%ebp
  80160f:	39 c5                	cmp    %eax,%ebp
  801611:	73 04                	jae    801617 <__udivdi3+0xf7>
  801613:	39 d6                	cmp    %edx,%esi
  801615:	74 09                	je     801620 <__udivdi3+0x100>
  801617:	89 d8                	mov    %ebx,%eax
  801619:	31 ff                	xor    %edi,%edi
  80161b:	e9 27 ff ff ff       	jmp    801547 <__udivdi3+0x27>
  801620:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801623:	31 ff                	xor    %edi,%edi
  801625:	e9 1d ff ff ff       	jmp    801547 <__udivdi3+0x27>
  80162a:	66 90                	xchg   %ax,%ax
  80162c:	66 90                	xchg   %ax,%ax
  80162e:	66 90                	xchg   %ax,%ax

00801630 <__umoddi3>:
  801630:	55                   	push   %ebp
  801631:	57                   	push   %edi
  801632:	56                   	push   %esi
  801633:	53                   	push   %ebx
  801634:	83 ec 1c             	sub    $0x1c,%esp
  801637:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80163b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80163f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801643:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801647:	89 da                	mov    %ebx,%edx
  801649:	85 c0                	test   %eax,%eax
  80164b:	75 43                	jne    801690 <__umoddi3+0x60>
  80164d:	39 df                	cmp    %ebx,%edi
  80164f:	76 17                	jbe    801668 <__umoddi3+0x38>
  801651:	89 f0                	mov    %esi,%eax
  801653:	f7 f7                	div    %edi
  801655:	89 d0                	mov    %edx,%eax
  801657:	31 d2                	xor    %edx,%edx
  801659:	83 c4 1c             	add    $0x1c,%esp
  80165c:	5b                   	pop    %ebx
  80165d:	5e                   	pop    %esi
  80165e:	5f                   	pop    %edi
  80165f:	5d                   	pop    %ebp
  801660:	c3                   	ret    
  801661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801668:	89 fd                	mov    %edi,%ebp
  80166a:	85 ff                	test   %edi,%edi
  80166c:	75 0b                	jne    801679 <__umoddi3+0x49>
  80166e:	b8 01 00 00 00       	mov    $0x1,%eax
  801673:	31 d2                	xor    %edx,%edx
  801675:	f7 f7                	div    %edi
  801677:	89 c5                	mov    %eax,%ebp
  801679:	89 d8                	mov    %ebx,%eax
  80167b:	31 d2                	xor    %edx,%edx
  80167d:	f7 f5                	div    %ebp
  80167f:	89 f0                	mov    %esi,%eax
  801681:	f7 f5                	div    %ebp
  801683:	89 d0                	mov    %edx,%eax
  801685:	eb d0                	jmp    801657 <__umoddi3+0x27>
  801687:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80168e:	66 90                	xchg   %ax,%ax
  801690:	89 f1                	mov    %esi,%ecx
  801692:	39 d8                	cmp    %ebx,%eax
  801694:	76 0a                	jbe    8016a0 <__umoddi3+0x70>
  801696:	89 f0                	mov    %esi,%eax
  801698:	83 c4 1c             	add    $0x1c,%esp
  80169b:	5b                   	pop    %ebx
  80169c:	5e                   	pop    %esi
  80169d:	5f                   	pop    %edi
  80169e:	5d                   	pop    %ebp
  80169f:	c3                   	ret    
  8016a0:	0f bd e8             	bsr    %eax,%ebp
  8016a3:	83 f5 1f             	xor    $0x1f,%ebp
  8016a6:	75 20                	jne    8016c8 <__umoddi3+0x98>
  8016a8:	39 d8                	cmp    %ebx,%eax
  8016aa:	0f 82 b0 00 00 00    	jb     801760 <__umoddi3+0x130>
  8016b0:	39 f7                	cmp    %esi,%edi
  8016b2:	0f 86 a8 00 00 00    	jbe    801760 <__umoddi3+0x130>
  8016b8:	89 c8                	mov    %ecx,%eax
  8016ba:	83 c4 1c             	add    $0x1c,%esp
  8016bd:	5b                   	pop    %ebx
  8016be:	5e                   	pop    %esi
  8016bf:	5f                   	pop    %edi
  8016c0:	5d                   	pop    %ebp
  8016c1:	c3                   	ret    
  8016c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8016c8:	89 e9                	mov    %ebp,%ecx
  8016ca:	ba 20 00 00 00       	mov    $0x20,%edx
  8016cf:	29 ea                	sub    %ebp,%edx
  8016d1:	d3 e0                	shl    %cl,%eax
  8016d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016d7:	89 d1                	mov    %edx,%ecx
  8016d9:	89 f8                	mov    %edi,%eax
  8016db:	d3 e8                	shr    %cl,%eax
  8016dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8016e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8016e5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8016e9:	09 c1                	or     %eax,%ecx
  8016eb:	89 d8                	mov    %ebx,%eax
  8016ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8016f1:	89 e9                	mov    %ebp,%ecx
  8016f3:	d3 e7                	shl    %cl,%edi
  8016f5:	89 d1                	mov    %edx,%ecx
  8016f7:	d3 e8                	shr    %cl,%eax
  8016f9:	89 e9                	mov    %ebp,%ecx
  8016fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8016ff:	d3 e3                	shl    %cl,%ebx
  801701:	89 c7                	mov    %eax,%edi
  801703:	89 d1                	mov    %edx,%ecx
  801705:	89 f0                	mov    %esi,%eax
  801707:	d3 e8                	shr    %cl,%eax
  801709:	89 e9                	mov    %ebp,%ecx
  80170b:	89 fa                	mov    %edi,%edx
  80170d:	d3 e6                	shl    %cl,%esi
  80170f:	09 d8                	or     %ebx,%eax
  801711:	f7 74 24 08          	divl   0x8(%esp)
  801715:	89 d1                	mov    %edx,%ecx
  801717:	89 f3                	mov    %esi,%ebx
  801719:	f7 64 24 0c          	mull   0xc(%esp)
  80171d:	89 c6                	mov    %eax,%esi
  80171f:	89 d7                	mov    %edx,%edi
  801721:	39 d1                	cmp    %edx,%ecx
  801723:	72 06                	jb     80172b <__umoddi3+0xfb>
  801725:	75 10                	jne    801737 <__umoddi3+0x107>
  801727:	39 c3                	cmp    %eax,%ebx
  801729:	73 0c                	jae    801737 <__umoddi3+0x107>
  80172b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80172f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801733:	89 d7                	mov    %edx,%edi
  801735:	89 c6                	mov    %eax,%esi
  801737:	89 ca                	mov    %ecx,%edx
  801739:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80173e:	29 f3                	sub    %esi,%ebx
  801740:	19 fa                	sbb    %edi,%edx
  801742:	89 d0                	mov    %edx,%eax
  801744:	d3 e0                	shl    %cl,%eax
  801746:	89 e9                	mov    %ebp,%ecx
  801748:	d3 eb                	shr    %cl,%ebx
  80174a:	d3 ea                	shr    %cl,%edx
  80174c:	09 d8                	or     %ebx,%eax
  80174e:	83 c4 1c             	add    $0x1c,%esp
  801751:	5b                   	pop    %ebx
  801752:	5e                   	pop    %esi
  801753:	5f                   	pop    %edi
  801754:	5d                   	pop    %ebp
  801755:	c3                   	ret    
  801756:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80175d:	8d 76 00             	lea    0x0(%esi),%esi
  801760:	89 da                	mov    %ebx,%edx
  801762:	29 fe                	sub    %edi,%esi
  801764:	19 c2                	sbb    %eax,%edx
  801766:	89 f1                	mov    %esi,%ecx
  801768:	89 c8                	mov    %ecx,%eax
  80176a:	e9 4b ff ff ff       	jmp    8016ba <__umoddi3+0x8a>
