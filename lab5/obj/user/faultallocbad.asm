
obj/user/faultallocbad.debug:     file format elf32-i386


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
  80002c:	e8 84 00 00 00       	call   8000b5 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
	int r;
	void *addr = (void*)utf->utf_fault_va;
  80003a:	8b 45 08             	mov    0x8(%ebp),%eax
  80003d:	8b 18                	mov    (%eax),%ebx

	cprintf("fault %x\n", addr);
  80003f:	53                   	push   %ebx
  800040:	68 20 12 80 00       	push   $0x801220
  800045:	e8 a1 01 00 00       	call   8001eb <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004a:	83 c4 0c             	add    $0xc,%esp
  80004d:	6a 07                	push   $0x7
  80004f:	89 d8                	mov    %ebx,%eax
  800051:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800056:	50                   	push   %eax
  800057:	6a 00                	push   $0x0
  800059:	e8 a5 0c 00 00       	call   800d03 <sys_page_alloc>
  80005e:	83 c4 10             	add    $0x10,%esp
  800061:	85 c0                	test   %eax,%eax
  800063:	78 16                	js     80007b <handler+0x48>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800065:	53                   	push   %ebx
  800066:	68 6c 12 80 00       	push   $0x80126c
  80006b:	6a 64                	push   $0x64
  80006d:	53                   	push   %ebx
  80006e:	e8 4b 08 00 00       	call   8008be <snprintf>
}
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800079:	c9                   	leave  
  80007a:	c3                   	ret    
		panic("allocating at %x in page fault handler: %e", addr, r);
  80007b:	83 ec 0c             	sub    $0xc,%esp
  80007e:	50                   	push   %eax
  80007f:	53                   	push   %ebx
  800080:	68 40 12 80 00       	push   $0x801240
  800085:	6a 0f                	push   $0xf
  800087:	68 2a 12 80 00       	push   $0x80122a
  80008c:	e8 7f 00 00 00       	call   800110 <_panic>

00800091 <umain>:

void
umain(int argc, char **argv)
{
  800091:	55                   	push   %ebp
  800092:	89 e5                	mov    %esp,%ebp
  800094:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800097:	68 33 00 80 00       	push   $0x800033
  80009c:	e8 94 0e 00 00       	call   800f35 <set_pgfault_handler>
	sys_cputs((char*)0xDEADBEEF, 4);
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	6a 04                	push   $0x4
  8000a6:	68 ef be ad de       	push   $0xdeadbeef
  8000ab:	e8 97 0b 00 00       	call   800c47 <sys_cputs>
}
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	c9                   	leave  
  8000b4:	c3                   	ret    

008000b5 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
  8000ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000bd:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  8000c0:	e8 00 0c 00 00       	call   800cc5 <sys_getenvid>
  8000c5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000ca:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8000d0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000d5:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000da:	85 db                	test   %ebx,%ebx
  8000dc:	7e 07                	jle    8000e5 <libmain+0x30>
		binaryname = argv[0];
  8000de:	8b 06                	mov    (%esi),%eax
  8000e0:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000e5:	83 ec 08             	sub    $0x8,%esp
  8000e8:	56                   	push   %esi
  8000e9:	53                   	push   %ebx
  8000ea:	e8 a2 ff ff ff       	call   800091 <umain>

	// exit gracefully
	exit();
  8000ef:	e8 0a 00 00 00       	call   8000fe <exit>
}
  8000f4:	83 c4 10             	add    $0x10,%esp
  8000f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000fa:	5b                   	pop    %ebx
  8000fb:	5e                   	pop    %esi
  8000fc:	5d                   	pop    %ebp
  8000fd:	c3                   	ret    

008000fe <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000fe:	55                   	push   %ebp
  8000ff:	89 e5                	mov    %esp,%ebp
  800101:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800104:	6a 00                	push   $0x0
  800106:	e8 79 0b 00 00       	call   800c84 <sys_env_destroy>
}
  80010b:	83 c4 10             	add    $0x10,%esp
  80010e:	c9                   	leave  
  80010f:	c3                   	ret    

00800110 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800110:	55                   	push   %ebp
  800111:	89 e5                	mov    %esp,%ebp
  800113:	56                   	push   %esi
  800114:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800115:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800118:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80011e:	e8 a2 0b 00 00       	call   800cc5 <sys_getenvid>
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	ff 75 0c             	pushl  0xc(%ebp)
  800129:	ff 75 08             	pushl  0x8(%ebp)
  80012c:	56                   	push   %esi
  80012d:	50                   	push   %eax
  80012e:	68 98 12 80 00       	push   $0x801298
  800133:	e8 b3 00 00 00       	call   8001eb <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800138:	83 c4 18             	add    $0x18,%esp
  80013b:	53                   	push   %ebx
  80013c:	ff 75 10             	pushl  0x10(%ebp)
  80013f:	e8 56 00 00 00       	call   80019a <vcprintf>
	cprintf("\n");
  800144:	c7 04 24 28 12 80 00 	movl   $0x801228,(%esp)
  80014b:	e8 9b 00 00 00       	call   8001eb <cprintf>
  800150:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800153:	cc                   	int3   
  800154:	eb fd                	jmp    800153 <_panic+0x43>

00800156 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800156:	55                   	push   %ebp
  800157:	89 e5                	mov    %esp,%ebp
  800159:	53                   	push   %ebx
  80015a:	83 ec 04             	sub    $0x4,%esp
  80015d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800160:	8b 13                	mov    (%ebx),%edx
  800162:	8d 42 01             	lea    0x1(%edx),%eax
  800165:	89 03                	mov    %eax,(%ebx)
  800167:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80016a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80016e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800173:	74 09                	je     80017e <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800175:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800179:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80017c:	c9                   	leave  
  80017d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80017e:	83 ec 08             	sub    $0x8,%esp
  800181:	68 ff 00 00 00       	push   $0xff
  800186:	8d 43 08             	lea    0x8(%ebx),%eax
  800189:	50                   	push   %eax
  80018a:	e8 b8 0a 00 00       	call   800c47 <sys_cputs>
		b->idx = 0;
  80018f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800195:	83 c4 10             	add    $0x10,%esp
  800198:	eb db                	jmp    800175 <putch+0x1f>

0080019a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80019a:	55                   	push   %ebp
  80019b:	89 e5                	mov    %esp,%ebp
  80019d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001a3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001aa:	00 00 00 
	b.cnt = 0;
  8001ad:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001b4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001b7:	ff 75 0c             	pushl  0xc(%ebp)
  8001ba:	ff 75 08             	pushl  0x8(%ebp)
  8001bd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001c3:	50                   	push   %eax
  8001c4:	68 56 01 80 00       	push   $0x800156
  8001c9:	e8 4a 01 00 00       	call   800318 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001ce:	83 c4 08             	add    $0x8,%esp
  8001d1:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001d7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001dd:	50                   	push   %eax
  8001de:	e8 64 0a 00 00       	call   800c47 <sys_cputs>

	return b.cnt;
}
  8001e3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001e9:	c9                   	leave  
  8001ea:	c3                   	ret    

008001eb <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001eb:	55                   	push   %ebp
  8001ec:	89 e5                	mov    %esp,%ebp
  8001ee:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001f1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001f4:	50                   	push   %eax
  8001f5:	ff 75 08             	pushl  0x8(%ebp)
  8001f8:	e8 9d ff ff ff       	call   80019a <vcprintf>
	va_end(ap);

	return cnt;
}
  8001fd:	c9                   	leave  
  8001fe:	c3                   	ret    

008001ff <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001ff:	55                   	push   %ebp
  800200:	89 e5                	mov    %esp,%ebp
  800202:	57                   	push   %edi
  800203:	56                   	push   %esi
  800204:	53                   	push   %ebx
  800205:	83 ec 1c             	sub    $0x1c,%esp
  800208:	89 c6                	mov    %eax,%esi
  80020a:	89 d7                	mov    %edx,%edi
  80020c:	8b 45 08             	mov    0x8(%ebp),%eax
  80020f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800212:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800215:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800218:	8b 45 10             	mov    0x10(%ebp),%eax
  80021b:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  80021e:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800222:	74 2c                	je     800250 <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800224:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800227:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80022e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800231:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800234:	39 c2                	cmp    %eax,%edx
  800236:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800239:	73 43                	jae    80027e <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80023b:	83 eb 01             	sub    $0x1,%ebx
  80023e:	85 db                	test   %ebx,%ebx
  800240:	7e 6c                	jle    8002ae <printnum+0xaf>
			putch(padc, putdat);
  800242:	83 ec 08             	sub    $0x8,%esp
  800245:	57                   	push   %edi
  800246:	ff 75 18             	pushl  0x18(%ebp)
  800249:	ff d6                	call   *%esi
  80024b:	83 c4 10             	add    $0x10,%esp
  80024e:	eb eb                	jmp    80023b <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800250:	83 ec 0c             	sub    $0xc,%esp
  800253:	6a 20                	push   $0x20
  800255:	6a 00                	push   $0x0
  800257:	50                   	push   %eax
  800258:	ff 75 e4             	pushl  -0x1c(%ebp)
  80025b:	ff 75 e0             	pushl  -0x20(%ebp)
  80025e:	89 fa                	mov    %edi,%edx
  800260:	89 f0                	mov    %esi,%eax
  800262:	e8 98 ff ff ff       	call   8001ff <printnum>
		while (--width > 0)
  800267:	83 c4 20             	add    $0x20,%esp
  80026a:	83 eb 01             	sub    $0x1,%ebx
  80026d:	85 db                	test   %ebx,%ebx
  80026f:	7e 65                	jle    8002d6 <printnum+0xd7>
			putch(' ', putdat);
  800271:	83 ec 08             	sub    $0x8,%esp
  800274:	57                   	push   %edi
  800275:	6a 20                	push   $0x20
  800277:	ff d6                	call   *%esi
  800279:	83 c4 10             	add    $0x10,%esp
  80027c:	eb ec                	jmp    80026a <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	ff 75 18             	pushl  0x18(%ebp)
  800284:	83 eb 01             	sub    $0x1,%ebx
  800287:	53                   	push   %ebx
  800288:	50                   	push   %eax
  800289:	83 ec 08             	sub    $0x8,%esp
  80028c:	ff 75 dc             	pushl  -0x24(%ebp)
  80028f:	ff 75 d8             	pushl  -0x28(%ebp)
  800292:	ff 75 e4             	pushl  -0x1c(%ebp)
  800295:	ff 75 e0             	pushl  -0x20(%ebp)
  800298:	e8 33 0d 00 00       	call   800fd0 <__udivdi3>
  80029d:	83 c4 18             	add    $0x18,%esp
  8002a0:	52                   	push   %edx
  8002a1:	50                   	push   %eax
  8002a2:	89 fa                	mov    %edi,%edx
  8002a4:	89 f0                	mov    %esi,%eax
  8002a6:	e8 54 ff ff ff       	call   8001ff <printnum>
  8002ab:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002ae:	83 ec 08             	sub    $0x8,%esp
  8002b1:	57                   	push   %edi
  8002b2:	83 ec 04             	sub    $0x4,%esp
  8002b5:	ff 75 dc             	pushl  -0x24(%ebp)
  8002b8:	ff 75 d8             	pushl  -0x28(%ebp)
  8002bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002be:	ff 75 e0             	pushl  -0x20(%ebp)
  8002c1:	e8 1a 0e 00 00       	call   8010e0 <__umoddi3>
  8002c6:	83 c4 14             	add    $0x14,%esp
  8002c9:	0f be 80 bb 12 80 00 	movsbl 0x8012bb(%eax),%eax
  8002d0:	50                   	push   %eax
  8002d1:	ff d6                	call   *%esi
  8002d3:	83 c4 10             	add    $0x10,%esp
}
  8002d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d9:	5b                   	pop    %ebx
  8002da:	5e                   	pop    %esi
  8002db:	5f                   	pop    %edi
  8002dc:	5d                   	pop    %ebp
  8002dd:	c3                   	ret    

008002de <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002de:	55                   	push   %ebp
  8002df:	89 e5                	mov    %esp,%ebp
  8002e1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002e4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002e8:	8b 10                	mov    (%eax),%edx
  8002ea:	3b 50 04             	cmp    0x4(%eax),%edx
  8002ed:	73 0a                	jae    8002f9 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002ef:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002f2:	89 08                	mov    %ecx,(%eax)
  8002f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f7:	88 02                	mov    %al,(%edx)
}
  8002f9:	5d                   	pop    %ebp
  8002fa:	c3                   	ret    

008002fb <printfmt>:
{
  8002fb:	55                   	push   %ebp
  8002fc:	89 e5                	mov    %esp,%ebp
  8002fe:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800301:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800304:	50                   	push   %eax
  800305:	ff 75 10             	pushl  0x10(%ebp)
  800308:	ff 75 0c             	pushl  0xc(%ebp)
  80030b:	ff 75 08             	pushl  0x8(%ebp)
  80030e:	e8 05 00 00 00       	call   800318 <vprintfmt>
}
  800313:	83 c4 10             	add    $0x10,%esp
  800316:	c9                   	leave  
  800317:	c3                   	ret    

00800318 <vprintfmt>:
{
  800318:	55                   	push   %ebp
  800319:	89 e5                	mov    %esp,%ebp
  80031b:	57                   	push   %edi
  80031c:	56                   	push   %esi
  80031d:	53                   	push   %ebx
  80031e:	83 ec 3c             	sub    $0x3c,%esp
  800321:	8b 75 08             	mov    0x8(%ebp),%esi
  800324:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800327:	8b 7d 10             	mov    0x10(%ebp),%edi
  80032a:	e9 1e 04 00 00       	jmp    80074d <vprintfmt+0x435>
		posflag = 0;
  80032f:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  800336:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80033a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800341:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800348:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80034f:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  800356:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80035b:	8d 47 01             	lea    0x1(%edi),%eax
  80035e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800361:	0f b6 17             	movzbl (%edi),%edx
  800364:	8d 42 dd             	lea    -0x23(%edx),%eax
  800367:	3c 55                	cmp    $0x55,%al
  800369:	0f 87 d9 04 00 00    	ja     800848 <vprintfmt+0x530>
  80036f:	0f b6 c0             	movzbl %al,%eax
  800372:	ff 24 85 a0 14 80 00 	jmp    *0x8014a0(,%eax,4)
  800379:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80037c:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800380:	eb d9                	jmp    80035b <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800382:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  800385:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  80038c:	eb cd                	jmp    80035b <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80038e:	0f b6 d2             	movzbl %dl,%edx
  800391:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800394:	b8 00 00 00 00       	mov    $0x0,%eax
  800399:	89 75 08             	mov    %esi,0x8(%ebp)
  80039c:	eb 0c                	jmp    8003aa <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  80039e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003a1:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  8003a5:	eb b4                	jmp    80035b <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  8003a7:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003aa:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003ad:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003b1:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003b4:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003b7:	83 fe 09             	cmp    $0x9,%esi
  8003ba:	76 eb                	jbe    8003a7 <vprintfmt+0x8f>
  8003bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003bf:	8b 75 08             	mov    0x8(%ebp),%esi
  8003c2:	eb 14                	jmp    8003d8 <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  8003c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c7:	8b 00                	mov    (%eax),%eax
  8003c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8003cf:	8d 40 04             	lea    0x4(%eax),%eax
  8003d2:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003d8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003dc:	0f 89 79 ff ff ff    	jns    80035b <vprintfmt+0x43>
				width = precision, precision = -1;
  8003e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003e8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003ef:	e9 67 ff ff ff       	jmp    80035b <vprintfmt+0x43>
  8003f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003f7:	85 c0                	test   %eax,%eax
  8003f9:	0f 48 c1             	cmovs  %ecx,%eax
  8003fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ff:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800402:	e9 54 ff ff ff       	jmp    80035b <vprintfmt+0x43>
  800407:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80040a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800411:	e9 45 ff ff ff       	jmp    80035b <vprintfmt+0x43>
			lflag++;
  800416:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80041a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80041d:	e9 39 ff ff ff       	jmp    80035b <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800422:	8b 45 14             	mov    0x14(%ebp),%eax
  800425:	8d 78 04             	lea    0x4(%eax),%edi
  800428:	83 ec 08             	sub    $0x8,%esp
  80042b:	53                   	push   %ebx
  80042c:	ff 30                	pushl  (%eax)
  80042e:	ff d6                	call   *%esi
			break;
  800430:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800433:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800436:	e9 0f 03 00 00       	jmp    80074a <vprintfmt+0x432>
			err = va_arg(ap, int);
  80043b:	8b 45 14             	mov    0x14(%ebp),%eax
  80043e:	8d 78 04             	lea    0x4(%eax),%edi
  800441:	8b 00                	mov    (%eax),%eax
  800443:	99                   	cltd   
  800444:	31 d0                	xor    %edx,%eax
  800446:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800448:	83 f8 0f             	cmp    $0xf,%eax
  80044b:	7f 23                	jg     800470 <vprintfmt+0x158>
  80044d:	8b 14 85 00 16 80 00 	mov    0x801600(,%eax,4),%edx
  800454:	85 d2                	test   %edx,%edx
  800456:	74 18                	je     800470 <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  800458:	52                   	push   %edx
  800459:	68 dc 12 80 00       	push   $0x8012dc
  80045e:	53                   	push   %ebx
  80045f:	56                   	push   %esi
  800460:	e8 96 fe ff ff       	call   8002fb <printfmt>
  800465:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800468:	89 7d 14             	mov    %edi,0x14(%ebp)
  80046b:	e9 da 02 00 00       	jmp    80074a <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  800470:	50                   	push   %eax
  800471:	68 d3 12 80 00       	push   $0x8012d3
  800476:	53                   	push   %ebx
  800477:	56                   	push   %esi
  800478:	e8 7e fe ff ff       	call   8002fb <printfmt>
  80047d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800480:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800483:	e9 c2 02 00 00       	jmp    80074a <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  800488:	8b 45 14             	mov    0x14(%ebp),%eax
  80048b:	83 c0 04             	add    $0x4,%eax
  80048e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800491:	8b 45 14             	mov    0x14(%ebp),%eax
  800494:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800496:	85 c9                	test   %ecx,%ecx
  800498:	b8 cc 12 80 00       	mov    $0x8012cc,%eax
  80049d:	0f 45 c1             	cmovne %ecx,%eax
  8004a0:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004a3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004a7:	7e 06                	jle    8004af <vprintfmt+0x197>
  8004a9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004ad:	75 0d                	jne    8004bc <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004af:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004b2:	89 c7                	mov    %eax,%edi
  8004b4:	03 45 e0             	add    -0x20(%ebp),%eax
  8004b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004ba:	eb 53                	jmp    80050f <vprintfmt+0x1f7>
  8004bc:	83 ec 08             	sub    $0x8,%esp
  8004bf:	ff 75 d8             	pushl  -0x28(%ebp)
  8004c2:	50                   	push   %eax
  8004c3:	e8 28 04 00 00       	call   8008f0 <strnlen>
  8004c8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004cb:	29 c1                	sub    %eax,%ecx
  8004cd:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  8004d0:	83 c4 10             	add    $0x10,%esp
  8004d3:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004d5:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004dc:	eb 0f                	jmp    8004ed <vprintfmt+0x1d5>
					putch(padc, putdat);
  8004de:	83 ec 08             	sub    $0x8,%esp
  8004e1:	53                   	push   %ebx
  8004e2:	ff 75 e0             	pushl  -0x20(%ebp)
  8004e5:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e7:	83 ef 01             	sub    $0x1,%edi
  8004ea:	83 c4 10             	add    $0x10,%esp
  8004ed:	85 ff                	test   %edi,%edi
  8004ef:	7f ed                	jg     8004de <vprintfmt+0x1c6>
  8004f1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  8004f4:	85 c9                	test   %ecx,%ecx
  8004f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004fb:	0f 49 c1             	cmovns %ecx,%eax
  8004fe:	29 c1                	sub    %eax,%ecx
  800500:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800503:	eb aa                	jmp    8004af <vprintfmt+0x197>
					putch(ch, putdat);
  800505:	83 ec 08             	sub    $0x8,%esp
  800508:	53                   	push   %ebx
  800509:	52                   	push   %edx
  80050a:	ff d6                	call   *%esi
  80050c:	83 c4 10             	add    $0x10,%esp
  80050f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800512:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800514:	83 c7 01             	add    $0x1,%edi
  800517:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80051b:	0f be d0             	movsbl %al,%edx
  80051e:	85 d2                	test   %edx,%edx
  800520:	74 4b                	je     80056d <vprintfmt+0x255>
  800522:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800526:	78 06                	js     80052e <vprintfmt+0x216>
  800528:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80052c:	78 1e                	js     80054c <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  80052e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800532:	74 d1                	je     800505 <vprintfmt+0x1ed>
  800534:	0f be c0             	movsbl %al,%eax
  800537:	83 e8 20             	sub    $0x20,%eax
  80053a:	83 f8 5e             	cmp    $0x5e,%eax
  80053d:	76 c6                	jbe    800505 <vprintfmt+0x1ed>
					putch('?', putdat);
  80053f:	83 ec 08             	sub    $0x8,%esp
  800542:	53                   	push   %ebx
  800543:	6a 3f                	push   $0x3f
  800545:	ff d6                	call   *%esi
  800547:	83 c4 10             	add    $0x10,%esp
  80054a:	eb c3                	jmp    80050f <vprintfmt+0x1f7>
  80054c:	89 cf                	mov    %ecx,%edi
  80054e:	eb 0e                	jmp    80055e <vprintfmt+0x246>
				putch(' ', putdat);
  800550:	83 ec 08             	sub    $0x8,%esp
  800553:	53                   	push   %ebx
  800554:	6a 20                	push   $0x20
  800556:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800558:	83 ef 01             	sub    $0x1,%edi
  80055b:	83 c4 10             	add    $0x10,%esp
  80055e:	85 ff                	test   %edi,%edi
  800560:	7f ee                	jg     800550 <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  800562:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800565:	89 45 14             	mov    %eax,0x14(%ebp)
  800568:	e9 dd 01 00 00       	jmp    80074a <vprintfmt+0x432>
  80056d:	89 cf                	mov    %ecx,%edi
  80056f:	eb ed                	jmp    80055e <vprintfmt+0x246>
	if (lflag >= 2)
  800571:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800575:	7f 21                	jg     800598 <vprintfmt+0x280>
	else if (lflag)
  800577:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80057b:	74 6a                	je     8005e7 <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  80057d:	8b 45 14             	mov    0x14(%ebp),%eax
  800580:	8b 00                	mov    (%eax),%eax
  800582:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800585:	89 c1                	mov    %eax,%ecx
  800587:	c1 f9 1f             	sar    $0x1f,%ecx
  80058a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80058d:	8b 45 14             	mov    0x14(%ebp),%eax
  800590:	8d 40 04             	lea    0x4(%eax),%eax
  800593:	89 45 14             	mov    %eax,0x14(%ebp)
  800596:	eb 17                	jmp    8005af <vprintfmt+0x297>
		return va_arg(*ap, long long);
  800598:	8b 45 14             	mov    0x14(%ebp),%eax
  80059b:	8b 50 04             	mov    0x4(%eax),%edx
  80059e:	8b 00                	mov    (%eax),%eax
  8005a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a9:	8d 40 08             	lea    0x8(%eax),%eax
  8005ac:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005af:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  8005b2:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8005b7:	85 d2                	test   %edx,%edx
  8005b9:	0f 89 5c 01 00 00    	jns    80071b <vprintfmt+0x403>
				putch('-', putdat);
  8005bf:	83 ec 08             	sub    $0x8,%esp
  8005c2:	53                   	push   %ebx
  8005c3:	6a 2d                	push   $0x2d
  8005c5:	ff d6                	call   *%esi
				num = -(long long) num;
  8005c7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005ca:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005cd:	f7 d8                	neg    %eax
  8005cf:	83 d2 00             	adc    $0x0,%edx
  8005d2:	f7 da                	neg    %edx
  8005d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005da:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005dd:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005e2:	e9 45 01 00 00       	jmp    80072c <vprintfmt+0x414>
		return va_arg(*ap, int);
  8005e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ea:	8b 00                	mov    (%eax),%eax
  8005ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ef:	89 c1                	mov    %eax,%ecx
  8005f1:	c1 f9 1f             	sar    $0x1f,%ecx
  8005f4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fa:	8d 40 04             	lea    0x4(%eax),%eax
  8005fd:	89 45 14             	mov    %eax,0x14(%ebp)
  800600:	eb ad                	jmp    8005af <vprintfmt+0x297>
	if (lflag >= 2)
  800602:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800606:	7f 29                	jg     800631 <vprintfmt+0x319>
	else if (lflag)
  800608:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80060c:	74 44                	je     800652 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  80060e:	8b 45 14             	mov    0x14(%ebp),%eax
  800611:	8b 00                	mov    (%eax),%eax
  800613:	ba 00 00 00 00       	mov    $0x0,%edx
  800618:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80061e:	8b 45 14             	mov    0x14(%ebp),%eax
  800621:	8d 40 04             	lea    0x4(%eax),%eax
  800624:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800627:	bf 0a 00 00 00       	mov    $0xa,%edi
  80062c:	e9 ea 00 00 00       	jmp    80071b <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800631:	8b 45 14             	mov    0x14(%ebp),%eax
  800634:	8b 50 04             	mov    0x4(%eax),%edx
  800637:	8b 00                	mov    (%eax),%eax
  800639:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80063c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80063f:	8b 45 14             	mov    0x14(%ebp),%eax
  800642:	8d 40 08             	lea    0x8(%eax),%eax
  800645:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800648:	bf 0a 00 00 00       	mov    $0xa,%edi
  80064d:	e9 c9 00 00 00       	jmp    80071b <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800652:	8b 45 14             	mov    0x14(%ebp),%eax
  800655:	8b 00                	mov    (%eax),%eax
  800657:	ba 00 00 00 00       	mov    $0x0,%edx
  80065c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800662:	8b 45 14             	mov    0x14(%ebp),%eax
  800665:	8d 40 04             	lea    0x4(%eax),%eax
  800668:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80066b:	bf 0a 00 00 00       	mov    $0xa,%edi
  800670:	e9 a6 00 00 00       	jmp    80071b <vprintfmt+0x403>
			putch('0', putdat);
  800675:	83 ec 08             	sub    $0x8,%esp
  800678:	53                   	push   %ebx
  800679:	6a 30                	push   $0x30
  80067b:	ff d6                	call   *%esi
	if (lflag >= 2)
  80067d:	83 c4 10             	add    $0x10,%esp
  800680:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800684:	7f 26                	jg     8006ac <vprintfmt+0x394>
	else if (lflag)
  800686:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80068a:	74 3e                	je     8006ca <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  80068c:	8b 45 14             	mov    0x14(%ebp),%eax
  80068f:	8b 00                	mov    (%eax),%eax
  800691:	ba 00 00 00 00       	mov    $0x0,%edx
  800696:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800699:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80069c:	8b 45 14             	mov    0x14(%ebp),%eax
  80069f:	8d 40 04             	lea    0x4(%eax),%eax
  8006a2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006a5:	bf 08 00 00 00       	mov    $0x8,%edi
  8006aa:	eb 6f                	jmp    80071b <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8006ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8006af:	8b 50 04             	mov    0x4(%eax),%edx
  8006b2:	8b 00                	mov    (%eax),%eax
  8006b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bd:	8d 40 08             	lea    0x8(%eax),%eax
  8006c0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006c3:	bf 08 00 00 00       	mov    $0x8,%edi
  8006c8:	eb 51                	jmp    80071b <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8006ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cd:	8b 00                	mov    (%eax),%eax
  8006cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006da:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dd:	8d 40 04             	lea    0x4(%eax),%eax
  8006e0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006e3:	bf 08 00 00 00       	mov    $0x8,%edi
  8006e8:	eb 31                	jmp    80071b <vprintfmt+0x403>
			putch('0', putdat);
  8006ea:	83 ec 08             	sub    $0x8,%esp
  8006ed:	53                   	push   %ebx
  8006ee:	6a 30                	push   $0x30
  8006f0:	ff d6                	call   *%esi
			putch('x', putdat);
  8006f2:	83 c4 08             	add    $0x8,%esp
  8006f5:	53                   	push   %ebx
  8006f6:	6a 78                	push   $0x78
  8006f8:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fd:	8b 00                	mov    (%eax),%eax
  8006ff:	ba 00 00 00 00       	mov    $0x0,%edx
  800704:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800707:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80070a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80070d:	8b 45 14             	mov    0x14(%ebp),%eax
  800710:	8d 40 04             	lea    0x4(%eax),%eax
  800713:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800716:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  80071b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80071f:	74 0b                	je     80072c <vprintfmt+0x414>
				putch('+', putdat);
  800721:	83 ec 08             	sub    $0x8,%esp
  800724:	53                   	push   %ebx
  800725:	6a 2b                	push   $0x2b
  800727:	ff d6                	call   *%esi
  800729:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  80072c:	83 ec 0c             	sub    $0xc,%esp
  80072f:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800733:	50                   	push   %eax
  800734:	ff 75 e0             	pushl  -0x20(%ebp)
  800737:	57                   	push   %edi
  800738:	ff 75 dc             	pushl  -0x24(%ebp)
  80073b:	ff 75 d8             	pushl  -0x28(%ebp)
  80073e:	89 da                	mov    %ebx,%edx
  800740:	89 f0                	mov    %esi,%eax
  800742:	e8 b8 fa ff ff       	call   8001ff <printnum>
			break;
  800747:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  80074a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80074d:	83 c7 01             	add    $0x1,%edi
  800750:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800754:	83 f8 25             	cmp    $0x25,%eax
  800757:	0f 84 d2 fb ff ff    	je     80032f <vprintfmt+0x17>
			if (ch == '\0')
  80075d:	85 c0                	test   %eax,%eax
  80075f:	0f 84 03 01 00 00    	je     800868 <vprintfmt+0x550>
			putch(ch, putdat);
  800765:	83 ec 08             	sub    $0x8,%esp
  800768:	53                   	push   %ebx
  800769:	50                   	push   %eax
  80076a:	ff d6                	call   *%esi
  80076c:	83 c4 10             	add    $0x10,%esp
  80076f:	eb dc                	jmp    80074d <vprintfmt+0x435>
	if (lflag >= 2)
  800771:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800775:	7f 29                	jg     8007a0 <vprintfmt+0x488>
	else if (lflag)
  800777:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80077b:	74 44                	je     8007c1 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  80077d:	8b 45 14             	mov    0x14(%ebp),%eax
  800780:	8b 00                	mov    (%eax),%eax
  800782:	ba 00 00 00 00       	mov    $0x0,%edx
  800787:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80078d:	8b 45 14             	mov    0x14(%ebp),%eax
  800790:	8d 40 04             	lea    0x4(%eax),%eax
  800793:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800796:	bf 10 00 00 00       	mov    $0x10,%edi
  80079b:	e9 7b ff ff ff       	jmp    80071b <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8007a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a3:	8b 50 04             	mov    0x4(%eax),%edx
  8007a6:	8b 00                	mov    (%eax),%eax
  8007a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ab:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b1:	8d 40 08             	lea    0x8(%eax),%eax
  8007b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007b7:	bf 10 00 00 00       	mov    $0x10,%edi
  8007bc:	e9 5a ff ff ff       	jmp    80071b <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8007c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c4:	8b 00                	mov    (%eax),%eax
  8007c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8007cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ce:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d4:	8d 40 04             	lea    0x4(%eax),%eax
  8007d7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007da:	bf 10 00 00 00       	mov    $0x10,%edi
  8007df:	e9 37 ff ff ff       	jmp    80071b <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  8007e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e7:	8d 78 04             	lea    0x4(%eax),%edi
  8007ea:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  8007ec:	85 c0                	test   %eax,%eax
  8007ee:	74 2c                	je     80081c <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  8007f0:	8b 13                	mov    (%ebx),%edx
  8007f2:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  8007f4:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  8007f7:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  8007fa:	0f 8e 4a ff ff ff    	jle    80074a <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  800800:	68 2c 14 80 00       	push   $0x80142c
  800805:	68 dc 12 80 00       	push   $0x8012dc
  80080a:	53                   	push   %ebx
  80080b:	56                   	push   %esi
  80080c:	e8 ea fa ff ff       	call   8002fb <printfmt>
  800811:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800814:	89 7d 14             	mov    %edi,0x14(%ebp)
  800817:	e9 2e ff ff ff       	jmp    80074a <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  80081c:	68 f4 13 80 00       	push   $0x8013f4
  800821:	68 dc 12 80 00       	push   $0x8012dc
  800826:	53                   	push   %ebx
  800827:	56                   	push   %esi
  800828:	e8 ce fa ff ff       	call   8002fb <printfmt>
        		break;
  80082d:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800830:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  800833:	e9 12 ff ff ff       	jmp    80074a <vprintfmt+0x432>
			putch(ch, putdat);
  800838:	83 ec 08             	sub    $0x8,%esp
  80083b:	53                   	push   %ebx
  80083c:	6a 25                	push   $0x25
  80083e:	ff d6                	call   *%esi
			break;
  800840:	83 c4 10             	add    $0x10,%esp
  800843:	e9 02 ff ff ff       	jmp    80074a <vprintfmt+0x432>
			putch('%', putdat);
  800848:	83 ec 08             	sub    $0x8,%esp
  80084b:	53                   	push   %ebx
  80084c:	6a 25                	push   $0x25
  80084e:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800850:	83 c4 10             	add    $0x10,%esp
  800853:	89 f8                	mov    %edi,%eax
  800855:	eb 03                	jmp    80085a <vprintfmt+0x542>
  800857:	83 e8 01             	sub    $0x1,%eax
  80085a:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80085e:	75 f7                	jne    800857 <vprintfmt+0x53f>
  800860:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800863:	e9 e2 fe ff ff       	jmp    80074a <vprintfmt+0x432>
}
  800868:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80086b:	5b                   	pop    %ebx
  80086c:	5e                   	pop    %esi
  80086d:	5f                   	pop    %edi
  80086e:	5d                   	pop    %ebp
  80086f:	c3                   	ret    

00800870 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800870:	55                   	push   %ebp
  800871:	89 e5                	mov    %esp,%ebp
  800873:	83 ec 18             	sub    $0x18,%esp
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80087c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80087f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800883:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800886:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80088d:	85 c0                	test   %eax,%eax
  80088f:	74 26                	je     8008b7 <vsnprintf+0x47>
  800891:	85 d2                	test   %edx,%edx
  800893:	7e 22                	jle    8008b7 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800895:	ff 75 14             	pushl  0x14(%ebp)
  800898:	ff 75 10             	pushl  0x10(%ebp)
  80089b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80089e:	50                   	push   %eax
  80089f:	68 de 02 80 00       	push   $0x8002de
  8008a4:	e8 6f fa ff ff       	call   800318 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008ac:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008b2:	83 c4 10             	add    $0x10,%esp
}
  8008b5:	c9                   	leave  
  8008b6:	c3                   	ret    
		return -E_INVAL;
  8008b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008bc:	eb f7                	jmp    8008b5 <vsnprintf+0x45>

008008be <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008be:	55                   	push   %ebp
  8008bf:	89 e5                	mov    %esp,%ebp
  8008c1:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008c4:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008c7:	50                   	push   %eax
  8008c8:	ff 75 10             	pushl  0x10(%ebp)
  8008cb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ce:	ff 75 08             	pushl  0x8(%ebp)
  8008d1:	e8 9a ff ff ff       	call   800870 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008d6:	c9                   	leave  
  8008d7:	c3                   	ret    

008008d8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008d8:	55                   	push   %ebp
  8008d9:	89 e5                	mov    %esp,%ebp
  8008db:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008de:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008e7:	74 05                	je     8008ee <strlen+0x16>
		n++;
  8008e9:	83 c0 01             	add    $0x1,%eax
  8008ec:	eb f5                	jmp    8008e3 <strlen+0xb>
	return n;
}
  8008ee:	5d                   	pop    %ebp
  8008ef:	c3                   	ret    

008008f0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008f0:	55                   	push   %ebp
  8008f1:	89 e5                	mov    %esp,%ebp
  8008f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008f6:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8008fe:	39 c2                	cmp    %eax,%edx
  800900:	74 0d                	je     80090f <strnlen+0x1f>
  800902:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800906:	74 05                	je     80090d <strnlen+0x1d>
		n++;
  800908:	83 c2 01             	add    $0x1,%edx
  80090b:	eb f1                	jmp    8008fe <strnlen+0xe>
  80090d:	89 d0                	mov    %edx,%eax
	return n;
}
  80090f:	5d                   	pop    %ebp
  800910:	c3                   	ret    

00800911 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800911:	55                   	push   %ebp
  800912:	89 e5                	mov    %esp,%ebp
  800914:	53                   	push   %ebx
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80091b:	ba 00 00 00 00       	mov    $0x0,%edx
  800920:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800924:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800927:	83 c2 01             	add    $0x1,%edx
  80092a:	84 c9                	test   %cl,%cl
  80092c:	75 f2                	jne    800920 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80092e:	5b                   	pop    %ebx
  80092f:	5d                   	pop    %ebp
  800930:	c3                   	ret    

00800931 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800931:	55                   	push   %ebp
  800932:	89 e5                	mov    %esp,%ebp
  800934:	53                   	push   %ebx
  800935:	83 ec 10             	sub    $0x10,%esp
  800938:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80093b:	53                   	push   %ebx
  80093c:	e8 97 ff ff ff       	call   8008d8 <strlen>
  800941:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800944:	ff 75 0c             	pushl  0xc(%ebp)
  800947:	01 d8                	add    %ebx,%eax
  800949:	50                   	push   %eax
  80094a:	e8 c2 ff ff ff       	call   800911 <strcpy>
	return dst;
}
  80094f:	89 d8                	mov    %ebx,%eax
  800951:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800954:	c9                   	leave  
  800955:	c3                   	ret    

00800956 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800956:	55                   	push   %ebp
  800957:	89 e5                	mov    %esp,%ebp
  800959:	56                   	push   %esi
  80095a:	53                   	push   %ebx
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800961:	89 c6                	mov    %eax,%esi
  800963:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800966:	89 c2                	mov    %eax,%edx
  800968:	39 f2                	cmp    %esi,%edx
  80096a:	74 11                	je     80097d <strncpy+0x27>
		*dst++ = *src;
  80096c:	83 c2 01             	add    $0x1,%edx
  80096f:	0f b6 19             	movzbl (%ecx),%ebx
  800972:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800975:	80 fb 01             	cmp    $0x1,%bl
  800978:	83 d9 ff             	sbb    $0xffffffff,%ecx
  80097b:	eb eb                	jmp    800968 <strncpy+0x12>
	}
	return ret;
}
  80097d:	5b                   	pop    %ebx
  80097e:	5e                   	pop    %esi
  80097f:	5d                   	pop    %ebp
  800980:	c3                   	ret    

00800981 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800981:	55                   	push   %ebp
  800982:	89 e5                	mov    %esp,%ebp
  800984:	56                   	push   %esi
  800985:	53                   	push   %ebx
  800986:	8b 75 08             	mov    0x8(%ebp),%esi
  800989:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80098c:	8b 55 10             	mov    0x10(%ebp),%edx
  80098f:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800991:	85 d2                	test   %edx,%edx
  800993:	74 21                	je     8009b6 <strlcpy+0x35>
  800995:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800999:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80099b:	39 c2                	cmp    %eax,%edx
  80099d:	74 14                	je     8009b3 <strlcpy+0x32>
  80099f:	0f b6 19             	movzbl (%ecx),%ebx
  8009a2:	84 db                	test   %bl,%bl
  8009a4:	74 0b                	je     8009b1 <strlcpy+0x30>
			*dst++ = *src++;
  8009a6:	83 c1 01             	add    $0x1,%ecx
  8009a9:	83 c2 01             	add    $0x1,%edx
  8009ac:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009af:	eb ea                	jmp    80099b <strlcpy+0x1a>
  8009b1:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009b3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009b6:	29 f0                	sub    %esi,%eax
}
  8009b8:	5b                   	pop    %ebx
  8009b9:	5e                   	pop    %esi
  8009ba:	5d                   	pop    %ebp
  8009bb:	c3                   	ret    

008009bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009c2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009c5:	0f b6 01             	movzbl (%ecx),%eax
  8009c8:	84 c0                	test   %al,%al
  8009ca:	74 0c                	je     8009d8 <strcmp+0x1c>
  8009cc:	3a 02                	cmp    (%edx),%al
  8009ce:	75 08                	jne    8009d8 <strcmp+0x1c>
		p++, q++;
  8009d0:	83 c1 01             	add    $0x1,%ecx
  8009d3:	83 c2 01             	add    $0x1,%edx
  8009d6:	eb ed                	jmp    8009c5 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009d8:	0f b6 c0             	movzbl %al,%eax
  8009db:	0f b6 12             	movzbl (%edx),%edx
  8009de:	29 d0                	sub    %edx,%eax
}
  8009e0:	5d                   	pop    %ebp
  8009e1:	c3                   	ret    

008009e2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009e2:	55                   	push   %ebp
  8009e3:	89 e5                	mov    %esp,%ebp
  8009e5:	53                   	push   %ebx
  8009e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ec:	89 c3                	mov    %eax,%ebx
  8009ee:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009f1:	eb 06                	jmp    8009f9 <strncmp+0x17>
		n--, p++, q++;
  8009f3:	83 c0 01             	add    $0x1,%eax
  8009f6:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009f9:	39 d8                	cmp    %ebx,%eax
  8009fb:	74 16                	je     800a13 <strncmp+0x31>
  8009fd:	0f b6 08             	movzbl (%eax),%ecx
  800a00:	84 c9                	test   %cl,%cl
  800a02:	74 04                	je     800a08 <strncmp+0x26>
  800a04:	3a 0a                	cmp    (%edx),%cl
  800a06:	74 eb                	je     8009f3 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a08:	0f b6 00             	movzbl (%eax),%eax
  800a0b:	0f b6 12             	movzbl (%edx),%edx
  800a0e:	29 d0                	sub    %edx,%eax
}
  800a10:	5b                   	pop    %ebx
  800a11:	5d                   	pop    %ebp
  800a12:	c3                   	ret    
		return 0;
  800a13:	b8 00 00 00 00       	mov    $0x0,%eax
  800a18:	eb f6                	jmp    800a10 <strncmp+0x2e>

00800a1a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a1a:	55                   	push   %ebp
  800a1b:	89 e5                	mov    %esp,%ebp
  800a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a20:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a24:	0f b6 10             	movzbl (%eax),%edx
  800a27:	84 d2                	test   %dl,%dl
  800a29:	74 09                	je     800a34 <strchr+0x1a>
		if (*s == c)
  800a2b:	38 ca                	cmp    %cl,%dl
  800a2d:	74 0a                	je     800a39 <strchr+0x1f>
	for (; *s; s++)
  800a2f:	83 c0 01             	add    $0x1,%eax
  800a32:	eb f0                	jmp    800a24 <strchr+0xa>
			return (char *) s;
	return 0;
  800a34:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a39:	5d                   	pop    %ebp
  800a3a:	c3                   	ret    

00800a3b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a3b:	55                   	push   %ebp
  800a3c:	89 e5                	mov    %esp,%ebp
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a45:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a48:	38 ca                	cmp    %cl,%dl
  800a4a:	74 09                	je     800a55 <strfind+0x1a>
  800a4c:	84 d2                	test   %dl,%dl
  800a4e:	74 05                	je     800a55 <strfind+0x1a>
	for (; *s; s++)
  800a50:	83 c0 01             	add    $0x1,%eax
  800a53:	eb f0                	jmp    800a45 <strfind+0xa>
			break;
	return (char *) s;
}
  800a55:	5d                   	pop    %ebp
  800a56:	c3                   	ret    

00800a57 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a57:	55                   	push   %ebp
  800a58:	89 e5                	mov    %esp,%ebp
  800a5a:	57                   	push   %edi
  800a5b:	56                   	push   %esi
  800a5c:	53                   	push   %ebx
  800a5d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a60:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a63:	85 c9                	test   %ecx,%ecx
  800a65:	74 31                	je     800a98 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a67:	89 f8                	mov    %edi,%eax
  800a69:	09 c8                	or     %ecx,%eax
  800a6b:	a8 03                	test   $0x3,%al
  800a6d:	75 23                	jne    800a92 <memset+0x3b>
		c &= 0xFF;
  800a6f:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a73:	89 d3                	mov    %edx,%ebx
  800a75:	c1 e3 08             	shl    $0x8,%ebx
  800a78:	89 d0                	mov    %edx,%eax
  800a7a:	c1 e0 18             	shl    $0x18,%eax
  800a7d:	89 d6                	mov    %edx,%esi
  800a7f:	c1 e6 10             	shl    $0x10,%esi
  800a82:	09 f0                	or     %esi,%eax
  800a84:	09 c2                	or     %eax,%edx
  800a86:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a88:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a8b:	89 d0                	mov    %edx,%eax
  800a8d:	fc                   	cld    
  800a8e:	f3 ab                	rep stos %eax,%es:(%edi)
  800a90:	eb 06                	jmp    800a98 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a95:	fc                   	cld    
  800a96:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a98:	89 f8                	mov    %edi,%eax
  800a9a:	5b                   	pop    %ebx
  800a9b:	5e                   	pop    %esi
  800a9c:	5f                   	pop    %edi
  800a9d:	5d                   	pop    %ebp
  800a9e:	c3                   	ret    

00800a9f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a9f:	55                   	push   %ebp
  800aa0:	89 e5                	mov    %esp,%ebp
  800aa2:	57                   	push   %edi
  800aa3:	56                   	push   %esi
  800aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aaa:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800aad:	39 c6                	cmp    %eax,%esi
  800aaf:	73 32                	jae    800ae3 <memmove+0x44>
  800ab1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ab4:	39 c2                	cmp    %eax,%edx
  800ab6:	76 2b                	jbe    800ae3 <memmove+0x44>
		s += n;
		d += n;
  800ab8:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800abb:	89 fe                	mov    %edi,%esi
  800abd:	09 ce                	or     %ecx,%esi
  800abf:	09 d6                	or     %edx,%esi
  800ac1:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ac7:	75 0e                	jne    800ad7 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ac9:	83 ef 04             	sub    $0x4,%edi
  800acc:	8d 72 fc             	lea    -0x4(%edx),%esi
  800acf:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ad2:	fd                   	std    
  800ad3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ad5:	eb 09                	jmp    800ae0 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ad7:	83 ef 01             	sub    $0x1,%edi
  800ada:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800add:	fd                   	std    
  800ade:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ae0:	fc                   	cld    
  800ae1:	eb 1a                	jmp    800afd <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ae3:	89 c2                	mov    %eax,%edx
  800ae5:	09 ca                	or     %ecx,%edx
  800ae7:	09 f2                	or     %esi,%edx
  800ae9:	f6 c2 03             	test   $0x3,%dl
  800aec:	75 0a                	jne    800af8 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800aee:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800af1:	89 c7                	mov    %eax,%edi
  800af3:	fc                   	cld    
  800af4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800af6:	eb 05                	jmp    800afd <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800af8:	89 c7                	mov    %eax,%edi
  800afa:	fc                   	cld    
  800afb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800afd:	5e                   	pop    %esi
  800afe:	5f                   	pop    %edi
  800aff:	5d                   	pop    %ebp
  800b00:	c3                   	ret    

00800b01 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b01:	55                   	push   %ebp
  800b02:	89 e5                	mov    %esp,%ebp
  800b04:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b07:	ff 75 10             	pushl  0x10(%ebp)
  800b0a:	ff 75 0c             	pushl  0xc(%ebp)
  800b0d:	ff 75 08             	pushl  0x8(%ebp)
  800b10:	e8 8a ff ff ff       	call   800a9f <memmove>
}
  800b15:	c9                   	leave  
  800b16:	c3                   	ret    

00800b17 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b17:	55                   	push   %ebp
  800b18:	89 e5                	mov    %esp,%ebp
  800b1a:	56                   	push   %esi
  800b1b:	53                   	push   %ebx
  800b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b22:	89 c6                	mov    %eax,%esi
  800b24:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b27:	39 f0                	cmp    %esi,%eax
  800b29:	74 1c                	je     800b47 <memcmp+0x30>
		if (*s1 != *s2)
  800b2b:	0f b6 08             	movzbl (%eax),%ecx
  800b2e:	0f b6 1a             	movzbl (%edx),%ebx
  800b31:	38 d9                	cmp    %bl,%cl
  800b33:	75 08                	jne    800b3d <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b35:	83 c0 01             	add    $0x1,%eax
  800b38:	83 c2 01             	add    $0x1,%edx
  800b3b:	eb ea                	jmp    800b27 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b3d:	0f b6 c1             	movzbl %cl,%eax
  800b40:	0f b6 db             	movzbl %bl,%ebx
  800b43:	29 d8                	sub    %ebx,%eax
  800b45:	eb 05                	jmp    800b4c <memcmp+0x35>
	}

	return 0;
  800b47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b4c:	5b                   	pop    %ebx
  800b4d:	5e                   	pop    %esi
  800b4e:	5d                   	pop    %ebp
  800b4f:	c3                   	ret    

00800b50 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b50:	55                   	push   %ebp
  800b51:	89 e5                	mov    %esp,%ebp
  800b53:	8b 45 08             	mov    0x8(%ebp),%eax
  800b56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b59:	89 c2                	mov    %eax,%edx
  800b5b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b5e:	39 d0                	cmp    %edx,%eax
  800b60:	73 09                	jae    800b6b <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b62:	38 08                	cmp    %cl,(%eax)
  800b64:	74 05                	je     800b6b <memfind+0x1b>
	for (; s < ends; s++)
  800b66:	83 c0 01             	add    $0x1,%eax
  800b69:	eb f3                	jmp    800b5e <memfind+0xe>
			break;
	return (void *) s;
}
  800b6b:	5d                   	pop    %ebp
  800b6c:	c3                   	ret    

00800b6d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b6d:	55                   	push   %ebp
  800b6e:	89 e5                	mov    %esp,%ebp
  800b70:	57                   	push   %edi
  800b71:	56                   	push   %esi
  800b72:	53                   	push   %ebx
  800b73:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b76:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b79:	eb 03                	jmp    800b7e <strtol+0x11>
		s++;
  800b7b:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b7e:	0f b6 01             	movzbl (%ecx),%eax
  800b81:	3c 20                	cmp    $0x20,%al
  800b83:	74 f6                	je     800b7b <strtol+0xe>
  800b85:	3c 09                	cmp    $0x9,%al
  800b87:	74 f2                	je     800b7b <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b89:	3c 2b                	cmp    $0x2b,%al
  800b8b:	74 2a                	je     800bb7 <strtol+0x4a>
	int neg = 0;
  800b8d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b92:	3c 2d                	cmp    $0x2d,%al
  800b94:	74 2b                	je     800bc1 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b96:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b9c:	75 0f                	jne    800bad <strtol+0x40>
  800b9e:	80 39 30             	cmpb   $0x30,(%ecx)
  800ba1:	74 28                	je     800bcb <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ba3:	85 db                	test   %ebx,%ebx
  800ba5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800baa:	0f 44 d8             	cmove  %eax,%ebx
  800bad:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb2:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bb5:	eb 50                	jmp    800c07 <strtol+0x9a>
		s++;
  800bb7:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bba:	bf 00 00 00 00       	mov    $0x0,%edi
  800bbf:	eb d5                	jmp    800b96 <strtol+0x29>
		s++, neg = 1;
  800bc1:	83 c1 01             	add    $0x1,%ecx
  800bc4:	bf 01 00 00 00       	mov    $0x1,%edi
  800bc9:	eb cb                	jmp    800b96 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bcb:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bcf:	74 0e                	je     800bdf <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bd1:	85 db                	test   %ebx,%ebx
  800bd3:	75 d8                	jne    800bad <strtol+0x40>
		s++, base = 8;
  800bd5:	83 c1 01             	add    $0x1,%ecx
  800bd8:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bdd:	eb ce                	jmp    800bad <strtol+0x40>
		s += 2, base = 16;
  800bdf:	83 c1 02             	add    $0x2,%ecx
  800be2:	bb 10 00 00 00       	mov    $0x10,%ebx
  800be7:	eb c4                	jmp    800bad <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800be9:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bec:	89 f3                	mov    %esi,%ebx
  800bee:	80 fb 19             	cmp    $0x19,%bl
  800bf1:	77 29                	ja     800c1c <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bf3:	0f be d2             	movsbl %dl,%edx
  800bf6:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bf9:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bfc:	7d 30                	jge    800c2e <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bfe:	83 c1 01             	add    $0x1,%ecx
  800c01:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c05:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c07:	0f b6 11             	movzbl (%ecx),%edx
  800c0a:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c0d:	89 f3                	mov    %esi,%ebx
  800c0f:	80 fb 09             	cmp    $0x9,%bl
  800c12:	77 d5                	ja     800be9 <strtol+0x7c>
			dig = *s - '0';
  800c14:	0f be d2             	movsbl %dl,%edx
  800c17:	83 ea 30             	sub    $0x30,%edx
  800c1a:	eb dd                	jmp    800bf9 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c1c:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c1f:	89 f3                	mov    %esi,%ebx
  800c21:	80 fb 19             	cmp    $0x19,%bl
  800c24:	77 08                	ja     800c2e <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c26:	0f be d2             	movsbl %dl,%edx
  800c29:	83 ea 37             	sub    $0x37,%edx
  800c2c:	eb cb                	jmp    800bf9 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c2e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c32:	74 05                	je     800c39 <strtol+0xcc>
		*endptr = (char *) s;
  800c34:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c37:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c39:	89 c2                	mov    %eax,%edx
  800c3b:	f7 da                	neg    %edx
  800c3d:	85 ff                	test   %edi,%edi
  800c3f:	0f 45 c2             	cmovne %edx,%eax
}
  800c42:	5b                   	pop    %ebx
  800c43:	5e                   	pop    %esi
  800c44:	5f                   	pop    %edi
  800c45:	5d                   	pop    %ebp
  800c46:	c3                   	ret    

00800c47 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c47:	55                   	push   %ebp
  800c48:	89 e5                	mov    %esp,%ebp
  800c4a:	57                   	push   %edi
  800c4b:	56                   	push   %esi
  800c4c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c4d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c52:	8b 55 08             	mov    0x8(%ebp),%edx
  800c55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c58:	89 c3                	mov    %eax,%ebx
  800c5a:	89 c7                	mov    %eax,%edi
  800c5c:	89 c6                	mov    %eax,%esi
  800c5e:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c60:	5b                   	pop    %ebx
  800c61:	5e                   	pop    %esi
  800c62:	5f                   	pop    %edi
  800c63:	5d                   	pop    %ebp
  800c64:	c3                   	ret    

00800c65 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	57                   	push   %edi
  800c69:	56                   	push   %esi
  800c6a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c70:	b8 01 00 00 00       	mov    $0x1,%eax
  800c75:	89 d1                	mov    %edx,%ecx
  800c77:	89 d3                	mov    %edx,%ebx
  800c79:	89 d7                	mov    %edx,%edi
  800c7b:	89 d6                	mov    %edx,%esi
  800c7d:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c7f:	5b                   	pop    %ebx
  800c80:	5e                   	pop    %esi
  800c81:	5f                   	pop    %edi
  800c82:	5d                   	pop    %ebp
  800c83:	c3                   	ret    

00800c84 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
  800c87:	57                   	push   %edi
  800c88:	56                   	push   %esi
  800c89:	53                   	push   %ebx
  800c8a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c8d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c92:	8b 55 08             	mov    0x8(%ebp),%edx
  800c95:	b8 03 00 00 00       	mov    $0x3,%eax
  800c9a:	89 cb                	mov    %ecx,%ebx
  800c9c:	89 cf                	mov    %ecx,%edi
  800c9e:	89 ce                	mov    %ecx,%esi
  800ca0:	cd 30                	int    $0x30
	if (check && ret > 0)
  800ca2:	85 c0                	test   %eax,%eax
  800ca4:	7f 08                	jg     800cae <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ca6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca9:	5b                   	pop    %ebx
  800caa:	5e                   	pop    %esi
  800cab:	5f                   	pop    %edi
  800cac:	5d                   	pop    %ebp
  800cad:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cae:	83 ec 0c             	sub    $0xc,%esp
  800cb1:	50                   	push   %eax
  800cb2:	6a 03                	push   $0x3
  800cb4:	68 40 16 80 00       	push   $0x801640
  800cb9:	6a 4c                	push   $0x4c
  800cbb:	68 5d 16 80 00       	push   $0x80165d
  800cc0:	e8 4b f4 ff ff       	call   800110 <_panic>

00800cc5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	57                   	push   %edi
  800cc9:	56                   	push   %esi
  800cca:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ccb:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd0:	b8 02 00 00 00       	mov    $0x2,%eax
  800cd5:	89 d1                	mov    %edx,%ecx
  800cd7:	89 d3                	mov    %edx,%ebx
  800cd9:	89 d7                	mov    %edx,%edi
  800cdb:	89 d6                	mov    %edx,%esi
  800cdd:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cdf:	5b                   	pop    %ebx
  800ce0:	5e                   	pop    %esi
  800ce1:	5f                   	pop    %edi
  800ce2:	5d                   	pop    %ebp
  800ce3:	c3                   	ret    

00800ce4 <sys_yield>:

void
sys_yield(void)
{
  800ce4:	55                   	push   %ebp
  800ce5:	89 e5                	mov    %esp,%ebp
  800ce7:	57                   	push   %edi
  800ce8:	56                   	push   %esi
  800ce9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cea:	ba 00 00 00 00       	mov    $0x0,%edx
  800cef:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cf4:	89 d1                	mov    %edx,%ecx
  800cf6:	89 d3                	mov    %edx,%ebx
  800cf8:	89 d7                	mov    %edx,%edi
  800cfa:	89 d6                	mov    %edx,%esi
  800cfc:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cfe:	5b                   	pop    %ebx
  800cff:	5e                   	pop    %esi
  800d00:	5f                   	pop    %edi
  800d01:	5d                   	pop    %ebp
  800d02:	c3                   	ret    

00800d03 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d03:	55                   	push   %ebp
  800d04:	89 e5                	mov    %esp,%ebp
  800d06:	57                   	push   %edi
  800d07:	56                   	push   %esi
  800d08:	53                   	push   %ebx
  800d09:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d0c:	be 00 00 00 00       	mov    $0x0,%esi
  800d11:	8b 55 08             	mov    0x8(%ebp),%edx
  800d14:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d17:	b8 04 00 00 00       	mov    $0x4,%eax
  800d1c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d1f:	89 f7                	mov    %esi,%edi
  800d21:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d23:	85 c0                	test   %eax,%eax
  800d25:	7f 08                	jg     800d2f <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d27:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2a:	5b                   	pop    %ebx
  800d2b:	5e                   	pop    %esi
  800d2c:	5f                   	pop    %edi
  800d2d:	5d                   	pop    %ebp
  800d2e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d2f:	83 ec 0c             	sub    $0xc,%esp
  800d32:	50                   	push   %eax
  800d33:	6a 04                	push   $0x4
  800d35:	68 40 16 80 00       	push   $0x801640
  800d3a:	6a 4c                	push   $0x4c
  800d3c:	68 5d 16 80 00       	push   $0x80165d
  800d41:	e8 ca f3 ff ff       	call   800110 <_panic>

00800d46 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d46:	55                   	push   %ebp
  800d47:	89 e5                	mov    %esp,%ebp
  800d49:	57                   	push   %edi
  800d4a:	56                   	push   %esi
  800d4b:	53                   	push   %ebx
  800d4c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d55:	b8 05 00 00 00       	mov    $0x5,%eax
  800d5a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d5d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d60:	8b 75 18             	mov    0x18(%ebp),%esi
  800d63:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d65:	85 c0                	test   %eax,%eax
  800d67:	7f 08                	jg     800d71 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d69:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6c:	5b                   	pop    %ebx
  800d6d:	5e                   	pop    %esi
  800d6e:	5f                   	pop    %edi
  800d6f:	5d                   	pop    %ebp
  800d70:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d71:	83 ec 0c             	sub    $0xc,%esp
  800d74:	50                   	push   %eax
  800d75:	6a 05                	push   $0x5
  800d77:	68 40 16 80 00       	push   $0x801640
  800d7c:	6a 4c                	push   $0x4c
  800d7e:	68 5d 16 80 00       	push   $0x80165d
  800d83:	e8 88 f3 ff ff       	call   800110 <_panic>

00800d88 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	57                   	push   %edi
  800d8c:	56                   	push   %esi
  800d8d:	53                   	push   %ebx
  800d8e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d91:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d96:	8b 55 08             	mov    0x8(%ebp),%edx
  800d99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9c:	b8 06 00 00 00       	mov    $0x6,%eax
  800da1:	89 df                	mov    %ebx,%edi
  800da3:	89 de                	mov    %ebx,%esi
  800da5:	cd 30                	int    $0x30
	if (check && ret > 0)
  800da7:	85 c0                	test   %eax,%eax
  800da9:	7f 08                	jg     800db3 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dae:	5b                   	pop    %ebx
  800daf:	5e                   	pop    %esi
  800db0:	5f                   	pop    %edi
  800db1:	5d                   	pop    %ebp
  800db2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db3:	83 ec 0c             	sub    $0xc,%esp
  800db6:	50                   	push   %eax
  800db7:	6a 06                	push   $0x6
  800db9:	68 40 16 80 00       	push   $0x801640
  800dbe:	6a 4c                	push   $0x4c
  800dc0:	68 5d 16 80 00       	push   $0x80165d
  800dc5:	e8 46 f3 ff ff       	call   800110 <_panic>

00800dca <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dca:	55                   	push   %ebp
  800dcb:	89 e5                	mov    %esp,%ebp
  800dcd:	57                   	push   %edi
  800dce:	56                   	push   %esi
  800dcf:	53                   	push   %ebx
  800dd0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dde:	b8 08 00 00 00       	mov    $0x8,%eax
  800de3:	89 df                	mov    %ebx,%edi
  800de5:	89 de                	mov    %ebx,%esi
  800de7:	cd 30                	int    $0x30
	if (check && ret > 0)
  800de9:	85 c0                	test   %eax,%eax
  800deb:	7f 08                	jg     800df5 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ded:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df0:	5b                   	pop    %ebx
  800df1:	5e                   	pop    %esi
  800df2:	5f                   	pop    %edi
  800df3:	5d                   	pop    %ebp
  800df4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df5:	83 ec 0c             	sub    $0xc,%esp
  800df8:	50                   	push   %eax
  800df9:	6a 08                	push   $0x8
  800dfb:	68 40 16 80 00       	push   $0x801640
  800e00:	6a 4c                	push   $0x4c
  800e02:	68 5d 16 80 00       	push   $0x80165d
  800e07:	e8 04 f3 ff ff       	call   800110 <_panic>

00800e0c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	57                   	push   %edi
  800e10:	56                   	push   %esi
  800e11:	53                   	push   %ebx
  800e12:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e15:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e20:	b8 09 00 00 00       	mov    $0x9,%eax
  800e25:	89 df                	mov    %ebx,%edi
  800e27:	89 de                	mov    %ebx,%esi
  800e29:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e2b:	85 c0                	test   %eax,%eax
  800e2d:	7f 08                	jg     800e37 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e32:	5b                   	pop    %ebx
  800e33:	5e                   	pop    %esi
  800e34:	5f                   	pop    %edi
  800e35:	5d                   	pop    %ebp
  800e36:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e37:	83 ec 0c             	sub    $0xc,%esp
  800e3a:	50                   	push   %eax
  800e3b:	6a 09                	push   $0x9
  800e3d:	68 40 16 80 00       	push   $0x801640
  800e42:	6a 4c                	push   $0x4c
  800e44:	68 5d 16 80 00       	push   $0x80165d
  800e49:	e8 c2 f2 ff ff       	call   800110 <_panic>

00800e4e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e4e:	55                   	push   %ebp
  800e4f:	89 e5                	mov    %esp,%ebp
  800e51:	57                   	push   %edi
  800e52:	56                   	push   %esi
  800e53:	53                   	push   %ebx
  800e54:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e57:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e62:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e67:	89 df                	mov    %ebx,%edi
  800e69:	89 de                	mov    %ebx,%esi
  800e6b:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e6d:	85 c0                	test   %eax,%eax
  800e6f:	7f 08                	jg     800e79 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e74:	5b                   	pop    %ebx
  800e75:	5e                   	pop    %esi
  800e76:	5f                   	pop    %edi
  800e77:	5d                   	pop    %ebp
  800e78:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e79:	83 ec 0c             	sub    $0xc,%esp
  800e7c:	50                   	push   %eax
  800e7d:	6a 0a                	push   $0xa
  800e7f:	68 40 16 80 00       	push   $0x801640
  800e84:	6a 4c                	push   $0x4c
  800e86:	68 5d 16 80 00       	push   $0x80165d
  800e8b:	e8 80 f2 ff ff       	call   800110 <_panic>

00800e90 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e90:	55                   	push   %ebp
  800e91:	89 e5                	mov    %esp,%ebp
  800e93:	57                   	push   %edi
  800e94:	56                   	push   %esi
  800e95:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e96:	8b 55 08             	mov    0x8(%ebp),%edx
  800e99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9c:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ea1:	be 00 00 00 00       	mov    $0x0,%esi
  800ea6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ea9:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eac:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800eae:	5b                   	pop    %ebx
  800eaf:	5e                   	pop    %esi
  800eb0:	5f                   	pop    %edi
  800eb1:	5d                   	pop    %ebp
  800eb2:	c3                   	ret    

00800eb3 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800eb3:	55                   	push   %ebp
  800eb4:	89 e5                	mov    %esp,%ebp
  800eb6:	57                   	push   %edi
  800eb7:	56                   	push   %esi
  800eb8:	53                   	push   %ebx
  800eb9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ebc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ec1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec4:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ec9:	89 cb                	mov    %ecx,%ebx
  800ecb:	89 cf                	mov    %ecx,%edi
  800ecd:	89 ce                	mov    %ecx,%esi
  800ecf:	cd 30                	int    $0x30
	if (check && ret > 0)
  800ed1:	85 c0                	test   %eax,%eax
  800ed3:	7f 08                	jg     800edd <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ed5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed8:	5b                   	pop    %ebx
  800ed9:	5e                   	pop    %esi
  800eda:	5f                   	pop    %edi
  800edb:	5d                   	pop    %ebp
  800edc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800edd:	83 ec 0c             	sub    $0xc,%esp
  800ee0:	50                   	push   %eax
  800ee1:	6a 0d                	push   $0xd
  800ee3:	68 40 16 80 00       	push   $0x801640
  800ee8:	6a 4c                	push   $0x4c
  800eea:	68 5d 16 80 00       	push   $0x80165d
  800eef:	e8 1c f2 ff ff       	call   800110 <_panic>

00800ef4 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800ef4:	55                   	push   %ebp
  800ef5:	89 e5                	mov    %esp,%ebp
  800ef7:	57                   	push   %edi
  800ef8:	56                   	push   %esi
  800ef9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800efa:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eff:	8b 55 08             	mov    0x8(%ebp),%edx
  800f02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f05:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f0a:	89 df                	mov    %ebx,%edi
  800f0c:	89 de                	mov    %ebx,%esi
  800f0e:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f10:	5b                   	pop    %ebx
  800f11:	5e                   	pop    %esi
  800f12:	5f                   	pop    %edi
  800f13:	5d                   	pop    %ebp
  800f14:	c3                   	ret    

00800f15 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
  800f18:	57                   	push   %edi
  800f19:	56                   	push   %esi
  800f1a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f1b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f20:	8b 55 08             	mov    0x8(%ebp),%edx
  800f23:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f28:	89 cb                	mov    %ecx,%ebx
  800f2a:	89 cf                	mov    %ecx,%edi
  800f2c:	89 ce                	mov    %ecx,%esi
  800f2e:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f30:	5b                   	pop    %ebx
  800f31:	5e                   	pop    %esi
  800f32:	5f                   	pop    %edi
  800f33:	5d                   	pop    %ebp
  800f34:	c3                   	ret    

00800f35 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800f35:	55                   	push   %ebp
  800f36:	89 e5                	mov    %esp,%ebp
  800f38:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800f3b:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  800f42:	74 0a                	je     800f4e <set_pgfault_handler+0x19>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
  800f47:	a3 08 20 80 00       	mov    %eax,0x802008
}
  800f4c:	c9                   	leave  
  800f4d:	c3                   	ret    
		ret = sys_page_alloc((envid_t)0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W);
  800f4e:	83 ec 04             	sub    $0x4,%esp
  800f51:	6a 07                	push   $0x7
  800f53:	68 00 f0 bf ee       	push   $0xeebff000
  800f58:	6a 00                	push   $0x0
  800f5a:	e8 a4 fd ff ff       	call   800d03 <sys_page_alloc>
		if(ret < 0){
  800f5f:	83 c4 10             	add    $0x10,%esp
  800f62:	85 c0                	test   %eax,%eax
  800f64:	78 28                	js     800f8e <set_pgfault_handler+0x59>
    	ret = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  800f66:	83 ec 08             	sub    $0x8,%esp
  800f69:	68 a0 0f 80 00       	push   $0x800fa0
  800f6e:	6a 00                	push   $0x0
  800f70:	e8 d9 fe ff ff       	call   800e4e <sys_env_set_pgfault_upcall>
		if(ret < 0){
  800f75:	83 c4 10             	add    $0x10,%esp
  800f78:	85 c0                	test   %eax,%eax
  800f7a:	79 c8                	jns    800f44 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
  800f7c:	50                   	push   %eax
  800f7d:	68 a0 16 80 00       	push   $0x8016a0
  800f82:	6a 28                	push   $0x28
  800f84:	68 e0 16 80 00       	push   $0x8016e0
  800f89:	e8 82 f1 ff ff       	call   800110 <_panic>
			panic("set_pgfault_handler: sys_page_alloc fail, ret:%d", ret);
  800f8e:	50                   	push   %eax
  800f8f:	68 6c 16 80 00       	push   $0x80166c
  800f94:	6a 24                	push   $0x24
  800f96:	68 e0 16 80 00       	push   $0x8016e0
  800f9b:	e8 70 f1 ff ff       	call   800110 <_panic>

00800fa0 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800fa0:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800fa1:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  800fa6:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800fa8:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edi
  800fab:	8b 7c 24 28          	mov    0x28(%esp),%edi
	movl 0x30(%esp), %esi
  800faf:	8b 74 24 30          	mov    0x30(%esp),%esi
	subl $4, %esi
  800fb3:	83 ee 04             	sub    $0x4,%esi
	movl %edi, (%esi)
  800fb6:	89 3e                	mov    %edi,(%esi)
	movl %esi, 0x30(%esp)
  800fb8:	89 74 24 30          	mov    %esi,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  800fbc:	83 c4 08             	add    $0x8,%esp
	popal
  800fbf:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  800fc0:	83 c4 04             	add    $0x4,%esp
	popfl
  800fc3:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  800fc4:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  800fc5:	c3                   	ret    
  800fc6:	66 90                	xchg   %ax,%ax
  800fc8:	66 90                	xchg   %ax,%ax
  800fca:	66 90                	xchg   %ax,%ax
  800fcc:	66 90                	xchg   %ax,%ax
  800fce:	66 90                	xchg   %ax,%ax

00800fd0 <__udivdi3>:
  800fd0:	55                   	push   %ebp
  800fd1:	57                   	push   %edi
  800fd2:	56                   	push   %esi
  800fd3:	53                   	push   %ebx
  800fd4:	83 ec 1c             	sub    $0x1c,%esp
  800fd7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800fdb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800fdf:	8b 74 24 34          	mov    0x34(%esp),%esi
  800fe3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800fe7:	85 d2                	test   %edx,%edx
  800fe9:	75 4d                	jne    801038 <__udivdi3+0x68>
  800feb:	39 f3                	cmp    %esi,%ebx
  800fed:	76 19                	jbe    801008 <__udivdi3+0x38>
  800fef:	31 ff                	xor    %edi,%edi
  800ff1:	89 e8                	mov    %ebp,%eax
  800ff3:	89 f2                	mov    %esi,%edx
  800ff5:	f7 f3                	div    %ebx
  800ff7:	89 fa                	mov    %edi,%edx
  800ff9:	83 c4 1c             	add    $0x1c,%esp
  800ffc:	5b                   	pop    %ebx
  800ffd:	5e                   	pop    %esi
  800ffe:	5f                   	pop    %edi
  800fff:	5d                   	pop    %ebp
  801000:	c3                   	ret    
  801001:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801008:	89 d9                	mov    %ebx,%ecx
  80100a:	85 db                	test   %ebx,%ebx
  80100c:	75 0b                	jne    801019 <__udivdi3+0x49>
  80100e:	b8 01 00 00 00       	mov    $0x1,%eax
  801013:	31 d2                	xor    %edx,%edx
  801015:	f7 f3                	div    %ebx
  801017:	89 c1                	mov    %eax,%ecx
  801019:	31 d2                	xor    %edx,%edx
  80101b:	89 f0                	mov    %esi,%eax
  80101d:	f7 f1                	div    %ecx
  80101f:	89 c6                	mov    %eax,%esi
  801021:	89 e8                	mov    %ebp,%eax
  801023:	89 f7                	mov    %esi,%edi
  801025:	f7 f1                	div    %ecx
  801027:	89 fa                	mov    %edi,%edx
  801029:	83 c4 1c             	add    $0x1c,%esp
  80102c:	5b                   	pop    %ebx
  80102d:	5e                   	pop    %esi
  80102e:	5f                   	pop    %edi
  80102f:	5d                   	pop    %ebp
  801030:	c3                   	ret    
  801031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801038:	39 f2                	cmp    %esi,%edx
  80103a:	77 1c                	ja     801058 <__udivdi3+0x88>
  80103c:	0f bd fa             	bsr    %edx,%edi
  80103f:	83 f7 1f             	xor    $0x1f,%edi
  801042:	75 2c                	jne    801070 <__udivdi3+0xa0>
  801044:	39 f2                	cmp    %esi,%edx
  801046:	72 06                	jb     80104e <__udivdi3+0x7e>
  801048:	31 c0                	xor    %eax,%eax
  80104a:	39 eb                	cmp    %ebp,%ebx
  80104c:	77 a9                	ja     800ff7 <__udivdi3+0x27>
  80104e:	b8 01 00 00 00       	mov    $0x1,%eax
  801053:	eb a2                	jmp    800ff7 <__udivdi3+0x27>
  801055:	8d 76 00             	lea    0x0(%esi),%esi
  801058:	31 ff                	xor    %edi,%edi
  80105a:	31 c0                	xor    %eax,%eax
  80105c:	89 fa                	mov    %edi,%edx
  80105e:	83 c4 1c             	add    $0x1c,%esp
  801061:	5b                   	pop    %ebx
  801062:	5e                   	pop    %esi
  801063:	5f                   	pop    %edi
  801064:	5d                   	pop    %ebp
  801065:	c3                   	ret    
  801066:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80106d:	8d 76 00             	lea    0x0(%esi),%esi
  801070:	89 f9                	mov    %edi,%ecx
  801072:	b8 20 00 00 00       	mov    $0x20,%eax
  801077:	29 f8                	sub    %edi,%eax
  801079:	d3 e2                	shl    %cl,%edx
  80107b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80107f:	89 c1                	mov    %eax,%ecx
  801081:	89 da                	mov    %ebx,%edx
  801083:	d3 ea                	shr    %cl,%edx
  801085:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801089:	09 d1                	or     %edx,%ecx
  80108b:	89 f2                	mov    %esi,%edx
  80108d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801091:	89 f9                	mov    %edi,%ecx
  801093:	d3 e3                	shl    %cl,%ebx
  801095:	89 c1                	mov    %eax,%ecx
  801097:	d3 ea                	shr    %cl,%edx
  801099:	89 f9                	mov    %edi,%ecx
  80109b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80109f:	89 eb                	mov    %ebp,%ebx
  8010a1:	d3 e6                	shl    %cl,%esi
  8010a3:	89 c1                	mov    %eax,%ecx
  8010a5:	d3 eb                	shr    %cl,%ebx
  8010a7:	09 de                	or     %ebx,%esi
  8010a9:	89 f0                	mov    %esi,%eax
  8010ab:	f7 74 24 08          	divl   0x8(%esp)
  8010af:	89 d6                	mov    %edx,%esi
  8010b1:	89 c3                	mov    %eax,%ebx
  8010b3:	f7 64 24 0c          	mull   0xc(%esp)
  8010b7:	39 d6                	cmp    %edx,%esi
  8010b9:	72 15                	jb     8010d0 <__udivdi3+0x100>
  8010bb:	89 f9                	mov    %edi,%ecx
  8010bd:	d3 e5                	shl    %cl,%ebp
  8010bf:	39 c5                	cmp    %eax,%ebp
  8010c1:	73 04                	jae    8010c7 <__udivdi3+0xf7>
  8010c3:	39 d6                	cmp    %edx,%esi
  8010c5:	74 09                	je     8010d0 <__udivdi3+0x100>
  8010c7:	89 d8                	mov    %ebx,%eax
  8010c9:	31 ff                	xor    %edi,%edi
  8010cb:	e9 27 ff ff ff       	jmp    800ff7 <__udivdi3+0x27>
  8010d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8010d3:	31 ff                	xor    %edi,%edi
  8010d5:	e9 1d ff ff ff       	jmp    800ff7 <__udivdi3+0x27>
  8010da:	66 90                	xchg   %ax,%ax
  8010dc:	66 90                	xchg   %ax,%ax
  8010de:	66 90                	xchg   %ax,%ax

008010e0 <__umoddi3>:
  8010e0:	55                   	push   %ebp
  8010e1:	57                   	push   %edi
  8010e2:	56                   	push   %esi
  8010e3:	53                   	push   %ebx
  8010e4:	83 ec 1c             	sub    $0x1c,%esp
  8010e7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8010eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8010ef:	8b 74 24 30          	mov    0x30(%esp),%esi
  8010f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8010f7:	89 da                	mov    %ebx,%edx
  8010f9:	85 c0                	test   %eax,%eax
  8010fb:	75 43                	jne    801140 <__umoddi3+0x60>
  8010fd:	39 df                	cmp    %ebx,%edi
  8010ff:	76 17                	jbe    801118 <__umoddi3+0x38>
  801101:	89 f0                	mov    %esi,%eax
  801103:	f7 f7                	div    %edi
  801105:	89 d0                	mov    %edx,%eax
  801107:	31 d2                	xor    %edx,%edx
  801109:	83 c4 1c             	add    $0x1c,%esp
  80110c:	5b                   	pop    %ebx
  80110d:	5e                   	pop    %esi
  80110e:	5f                   	pop    %edi
  80110f:	5d                   	pop    %ebp
  801110:	c3                   	ret    
  801111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801118:	89 fd                	mov    %edi,%ebp
  80111a:	85 ff                	test   %edi,%edi
  80111c:	75 0b                	jne    801129 <__umoddi3+0x49>
  80111e:	b8 01 00 00 00       	mov    $0x1,%eax
  801123:	31 d2                	xor    %edx,%edx
  801125:	f7 f7                	div    %edi
  801127:	89 c5                	mov    %eax,%ebp
  801129:	89 d8                	mov    %ebx,%eax
  80112b:	31 d2                	xor    %edx,%edx
  80112d:	f7 f5                	div    %ebp
  80112f:	89 f0                	mov    %esi,%eax
  801131:	f7 f5                	div    %ebp
  801133:	89 d0                	mov    %edx,%eax
  801135:	eb d0                	jmp    801107 <__umoddi3+0x27>
  801137:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80113e:	66 90                	xchg   %ax,%ax
  801140:	89 f1                	mov    %esi,%ecx
  801142:	39 d8                	cmp    %ebx,%eax
  801144:	76 0a                	jbe    801150 <__umoddi3+0x70>
  801146:	89 f0                	mov    %esi,%eax
  801148:	83 c4 1c             	add    $0x1c,%esp
  80114b:	5b                   	pop    %ebx
  80114c:	5e                   	pop    %esi
  80114d:	5f                   	pop    %edi
  80114e:	5d                   	pop    %ebp
  80114f:	c3                   	ret    
  801150:	0f bd e8             	bsr    %eax,%ebp
  801153:	83 f5 1f             	xor    $0x1f,%ebp
  801156:	75 20                	jne    801178 <__umoddi3+0x98>
  801158:	39 d8                	cmp    %ebx,%eax
  80115a:	0f 82 b0 00 00 00    	jb     801210 <__umoddi3+0x130>
  801160:	39 f7                	cmp    %esi,%edi
  801162:	0f 86 a8 00 00 00    	jbe    801210 <__umoddi3+0x130>
  801168:	89 c8                	mov    %ecx,%eax
  80116a:	83 c4 1c             	add    $0x1c,%esp
  80116d:	5b                   	pop    %ebx
  80116e:	5e                   	pop    %esi
  80116f:	5f                   	pop    %edi
  801170:	5d                   	pop    %ebp
  801171:	c3                   	ret    
  801172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801178:	89 e9                	mov    %ebp,%ecx
  80117a:	ba 20 00 00 00       	mov    $0x20,%edx
  80117f:	29 ea                	sub    %ebp,%edx
  801181:	d3 e0                	shl    %cl,%eax
  801183:	89 44 24 08          	mov    %eax,0x8(%esp)
  801187:	89 d1                	mov    %edx,%ecx
  801189:	89 f8                	mov    %edi,%eax
  80118b:	d3 e8                	shr    %cl,%eax
  80118d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801191:	89 54 24 04          	mov    %edx,0x4(%esp)
  801195:	8b 54 24 04          	mov    0x4(%esp),%edx
  801199:	09 c1                	or     %eax,%ecx
  80119b:	89 d8                	mov    %ebx,%eax
  80119d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8011a1:	89 e9                	mov    %ebp,%ecx
  8011a3:	d3 e7                	shl    %cl,%edi
  8011a5:	89 d1                	mov    %edx,%ecx
  8011a7:	d3 e8                	shr    %cl,%eax
  8011a9:	89 e9                	mov    %ebp,%ecx
  8011ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8011af:	d3 e3                	shl    %cl,%ebx
  8011b1:	89 c7                	mov    %eax,%edi
  8011b3:	89 d1                	mov    %edx,%ecx
  8011b5:	89 f0                	mov    %esi,%eax
  8011b7:	d3 e8                	shr    %cl,%eax
  8011b9:	89 e9                	mov    %ebp,%ecx
  8011bb:	89 fa                	mov    %edi,%edx
  8011bd:	d3 e6                	shl    %cl,%esi
  8011bf:	09 d8                	or     %ebx,%eax
  8011c1:	f7 74 24 08          	divl   0x8(%esp)
  8011c5:	89 d1                	mov    %edx,%ecx
  8011c7:	89 f3                	mov    %esi,%ebx
  8011c9:	f7 64 24 0c          	mull   0xc(%esp)
  8011cd:	89 c6                	mov    %eax,%esi
  8011cf:	89 d7                	mov    %edx,%edi
  8011d1:	39 d1                	cmp    %edx,%ecx
  8011d3:	72 06                	jb     8011db <__umoddi3+0xfb>
  8011d5:	75 10                	jne    8011e7 <__umoddi3+0x107>
  8011d7:	39 c3                	cmp    %eax,%ebx
  8011d9:	73 0c                	jae    8011e7 <__umoddi3+0x107>
  8011db:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8011df:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8011e3:	89 d7                	mov    %edx,%edi
  8011e5:	89 c6                	mov    %eax,%esi
  8011e7:	89 ca                	mov    %ecx,%edx
  8011e9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8011ee:	29 f3                	sub    %esi,%ebx
  8011f0:	19 fa                	sbb    %edi,%edx
  8011f2:	89 d0                	mov    %edx,%eax
  8011f4:	d3 e0                	shl    %cl,%eax
  8011f6:	89 e9                	mov    %ebp,%ecx
  8011f8:	d3 eb                	shr    %cl,%ebx
  8011fa:	d3 ea                	shr    %cl,%edx
  8011fc:	09 d8                	or     %ebx,%eax
  8011fe:	83 c4 1c             	add    $0x1c,%esp
  801201:	5b                   	pop    %ebx
  801202:	5e                   	pop    %esi
  801203:	5f                   	pop    %edi
  801204:	5d                   	pop    %ebp
  801205:	c3                   	ret    
  801206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80120d:	8d 76 00             	lea    0x0(%esi),%esi
  801210:	89 da                	mov    %ebx,%edx
  801212:	29 fe                	sub    %edi,%esi
  801214:	19 c2                	sbb    %eax,%edx
  801216:	89 f1                	mov    %esi,%ecx
  801218:	89 c8                	mov    %ecx,%eax
  80121a:	e9 4b ff ff ff       	jmp    80116a <__umoddi3+0x8a>
