
obj/user/faultalloc.debug:     file format elf32-i386


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
  80002c:	e8 99 00 00 00       	call   8000ca <libmain>
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
  800040:	68 40 12 80 00       	push   $0x801240
  800045:	e8 b6 01 00 00       	call   800200 <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004a:	83 c4 0c             	add    $0xc,%esp
  80004d:	6a 07                	push   $0x7
  80004f:	89 d8                	mov    %ebx,%eax
  800051:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800056:	50                   	push   %eax
  800057:	6a 00                	push   $0x0
  800059:	e8 ba 0c 00 00       	call   800d18 <sys_page_alloc>
  80005e:	83 c4 10             	add    $0x10,%esp
  800061:	85 c0                	test   %eax,%eax
  800063:	78 16                	js     80007b <handler+0x48>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800065:	53                   	push   %ebx
  800066:	68 8c 12 80 00       	push   $0x80128c
  80006b:	6a 64                	push   $0x64
  80006d:	53                   	push   %ebx
  80006e:	e8 60 08 00 00       	call   8008d3 <snprintf>
}
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800079:	c9                   	leave  
  80007a:	c3                   	ret    
		panic("allocating at %x in page fault handler: %e", addr, r);
  80007b:	83 ec 0c             	sub    $0xc,%esp
  80007e:	50                   	push   %eax
  80007f:	53                   	push   %ebx
  800080:	68 60 12 80 00       	push   $0x801260
  800085:	6a 0e                	push   $0xe
  800087:	68 4a 12 80 00       	push   $0x80124a
  80008c:	e8 94 00 00 00       	call   800125 <_panic>

00800091 <umain>:

void
umain(int argc, char **argv)
{
  800091:	55                   	push   %ebp
  800092:	89 e5                	mov    %esp,%ebp
  800094:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800097:	68 33 00 80 00       	push   $0x800033
  80009c:	e8 a9 0e 00 00       	call   800f4a <set_pgfault_handler>
	cprintf("%s\n", (char*)0xDeadBeef);
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	68 ef be ad de       	push   $0xdeadbeef
  8000a9:	68 5c 12 80 00       	push   $0x80125c
  8000ae:	e8 4d 01 00 00       	call   800200 <cprintf>
	cprintf("%s\n", (char*)0xCafeBffe);
  8000b3:	83 c4 08             	add    $0x8,%esp
  8000b6:	68 fe bf fe ca       	push   $0xcafebffe
  8000bb:	68 5c 12 80 00       	push   $0x80125c
  8000c0:	e8 3b 01 00 00       	call   800200 <cprintf>
}
  8000c5:	83 c4 10             	add    $0x10,%esp
  8000c8:	c9                   	leave  
  8000c9:	c3                   	ret    

008000ca <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000ca:	55                   	push   %ebp
  8000cb:	89 e5                	mov    %esp,%ebp
  8000cd:	56                   	push   %esi
  8000ce:	53                   	push   %ebx
  8000cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000d2:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  8000d5:	e8 00 0c 00 00       	call   800cda <sys_getenvid>
  8000da:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000df:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8000e5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000ea:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ef:	85 db                	test   %ebx,%ebx
  8000f1:	7e 07                	jle    8000fa <libmain+0x30>
		binaryname = argv[0];
  8000f3:	8b 06                	mov    (%esi),%eax
  8000f5:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000fa:	83 ec 08             	sub    $0x8,%esp
  8000fd:	56                   	push   %esi
  8000fe:	53                   	push   %ebx
  8000ff:	e8 8d ff ff ff       	call   800091 <umain>

	// exit gracefully
	exit();
  800104:	e8 0a 00 00 00       	call   800113 <exit>
}
  800109:	83 c4 10             	add    $0x10,%esp
  80010c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80010f:	5b                   	pop    %ebx
  800110:	5e                   	pop    %esi
  800111:	5d                   	pop    %ebp
  800112:	c3                   	ret    

00800113 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800113:	55                   	push   %ebp
  800114:	89 e5                	mov    %esp,%ebp
  800116:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800119:	6a 00                	push   $0x0
  80011b:	e8 79 0b 00 00       	call   800c99 <sys_env_destroy>
}
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	c9                   	leave  
  800124:	c3                   	ret    

00800125 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800125:	55                   	push   %ebp
  800126:	89 e5                	mov    %esp,%ebp
  800128:	56                   	push   %esi
  800129:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80012a:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80012d:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800133:	e8 a2 0b 00 00       	call   800cda <sys_getenvid>
  800138:	83 ec 0c             	sub    $0xc,%esp
  80013b:	ff 75 0c             	pushl  0xc(%ebp)
  80013e:	ff 75 08             	pushl  0x8(%ebp)
  800141:	56                   	push   %esi
  800142:	50                   	push   %eax
  800143:	68 b8 12 80 00       	push   $0x8012b8
  800148:	e8 b3 00 00 00       	call   800200 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80014d:	83 c4 18             	add    $0x18,%esp
  800150:	53                   	push   %ebx
  800151:	ff 75 10             	pushl  0x10(%ebp)
  800154:	e8 56 00 00 00       	call   8001af <vcprintf>
	cprintf("\n");
  800159:	c7 04 24 5e 12 80 00 	movl   $0x80125e,(%esp)
  800160:	e8 9b 00 00 00       	call   800200 <cprintf>
  800165:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800168:	cc                   	int3   
  800169:	eb fd                	jmp    800168 <_panic+0x43>

0080016b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80016b:	55                   	push   %ebp
  80016c:	89 e5                	mov    %esp,%ebp
  80016e:	53                   	push   %ebx
  80016f:	83 ec 04             	sub    $0x4,%esp
  800172:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800175:	8b 13                	mov    (%ebx),%edx
  800177:	8d 42 01             	lea    0x1(%edx),%eax
  80017a:	89 03                	mov    %eax,(%ebx)
  80017c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80017f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800183:	3d ff 00 00 00       	cmp    $0xff,%eax
  800188:	74 09                	je     800193 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80018a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80018e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800191:	c9                   	leave  
  800192:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800193:	83 ec 08             	sub    $0x8,%esp
  800196:	68 ff 00 00 00       	push   $0xff
  80019b:	8d 43 08             	lea    0x8(%ebx),%eax
  80019e:	50                   	push   %eax
  80019f:	e8 b8 0a 00 00       	call   800c5c <sys_cputs>
		b->idx = 0;
  8001a4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001aa:	83 c4 10             	add    $0x10,%esp
  8001ad:	eb db                	jmp    80018a <putch+0x1f>

008001af <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001af:	55                   	push   %ebp
  8001b0:	89 e5                	mov    %esp,%ebp
  8001b2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001b8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001bf:	00 00 00 
	b.cnt = 0;
  8001c2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001c9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001cc:	ff 75 0c             	pushl  0xc(%ebp)
  8001cf:	ff 75 08             	pushl  0x8(%ebp)
  8001d2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001d8:	50                   	push   %eax
  8001d9:	68 6b 01 80 00       	push   $0x80016b
  8001de:	e8 4a 01 00 00       	call   80032d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001e3:	83 c4 08             	add    $0x8,%esp
  8001e6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001ec:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001f2:	50                   	push   %eax
  8001f3:	e8 64 0a 00 00       	call   800c5c <sys_cputs>

	return b.cnt;
}
  8001f8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001fe:	c9                   	leave  
  8001ff:	c3                   	ret    

00800200 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800200:	55                   	push   %ebp
  800201:	89 e5                	mov    %esp,%ebp
  800203:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800206:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800209:	50                   	push   %eax
  80020a:	ff 75 08             	pushl  0x8(%ebp)
  80020d:	e8 9d ff ff ff       	call   8001af <vcprintf>
	va_end(ap);

	return cnt;
}
  800212:	c9                   	leave  
  800213:	c3                   	ret    

00800214 <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800214:	55                   	push   %ebp
  800215:	89 e5                	mov    %esp,%ebp
  800217:	57                   	push   %edi
  800218:	56                   	push   %esi
  800219:	53                   	push   %ebx
  80021a:	83 ec 1c             	sub    $0x1c,%esp
  80021d:	89 c6                	mov    %eax,%esi
  80021f:	89 d7                	mov    %edx,%edi
  800221:	8b 45 08             	mov    0x8(%ebp),%eax
  800224:	8b 55 0c             	mov    0xc(%ebp),%edx
  800227:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80022a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80022d:	8b 45 10             	mov    0x10(%ebp),%eax
  800230:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  800233:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800237:	74 2c                	je     800265 <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800239:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80023c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800243:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800246:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800249:	39 c2                	cmp    %eax,%edx
  80024b:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80024e:	73 43                	jae    800293 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800250:	83 eb 01             	sub    $0x1,%ebx
  800253:	85 db                	test   %ebx,%ebx
  800255:	7e 6c                	jle    8002c3 <printnum+0xaf>
			putch(padc, putdat);
  800257:	83 ec 08             	sub    $0x8,%esp
  80025a:	57                   	push   %edi
  80025b:	ff 75 18             	pushl  0x18(%ebp)
  80025e:	ff d6                	call   *%esi
  800260:	83 c4 10             	add    $0x10,%esp
  800263:	eb eb                	jmp    800250 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800265:	83 ec 0c             	sub    $0xc,%esp
  800268:	6a 20                	push   $0x20
  80026a:	6a 00                	push   $0x0
  80026c:	50                   	push   %eax
  80026d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800270:	ff 75 e0             	pushl  -0x20(%ebp)
  800273:	89 fa                	mov    %edi,%edx
  800275:	89 f0                	mov    %esi,%eax
  800277:	e8 98 ff ff ff       	call   800214 <printnum>
		while (--width > 0)
  80027c:	83 c4 20             	add    $0x20,%esp
  80027f:	83 eb 01             	sub    $0x1,%ebx
  800282:	85 db                	test   %ebx,%ebx
  800284:	7e 65                	jle    8002eb <printnum+0xd7>
			putch(' ', putdat);
  800286:	83 ec 08             	sub    $0x8,%esp
  800289:	57                   	push   %edi
  80028a:	6a 20                	push   $0x20
  80028c:	ff d6                	call   *%esi
  80028e:	83 c4 10             	add    $0x10,%esp
  800291:	eb ec                	jmp    80027f <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800293:	83 ec 0c             	sub    $0xc,%esp
  800296:	ff 75 18             	pushl  0x18(%ebp)
  800299:	83 eb 01             	sub    $0x1,%ebx
  80029c:	53                   	push   %ebx
  80029d:	50                   	push   %eax
  80029e:	83 ec 08             	sub    $0x8,%esp
  8002a1:	ff 75 dc             	pushl  -0x24(%ebp)
  8002a4:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002aa:	ff 75 e0             	pushl  -0x20(%ebp)
  8002ad:	e8 2e 0d 00 00       	call   800fe0 <__udivdi3>
  8002b2:	83 c4 18             	add    $0x18,%esp
  8002b5:	52                   	push   %edx
  8002b6:	50                   	push   %eax
  8002b7:	89 fa                	mov    %edi,%edx
  8002b9:	89 f0                	mov    %esi,%eax
  8002bb:	e8 54 ff ff ff       	call   800214 <printnum>
  8002c0:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002c3:	83 ec 08             	sub    $0x8,%esp
  8002c6:	57                   	push   %edi
  8002c7:	83 ec 04             	sub    $0x4,%esp
  8002ca:	ff 75 dc             	pushl  -0x24(%ebp)
  8002cd:	ff 75 d8             	pushl  -0x28(%ebp)
  8002d0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d3:	ff 75 e0             	pushl  -0x20(%ebp)
  8002d6:	e8 15 0e 00 00       	call   8010f0 <__umoddi3>
  8002db:	83 c4 14             	add    $0x14,%esp
  8002de:	0f be 80 db 12 80 00 	movsbl 0x8012db(%eax),%eax
  8002e5:	50                   	push   %eax
  8002e6:	ff d6                	call   *%esi
  8002e8:	83 c4 10             	add    $0x10,%esp
}
  8002eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ee:	5b                   	pop    %ebx
  8002ef:	5e                   	pop    %esi
  8002f0:	5f                   	pop    %edi
  8002f1:	5d                   	pop    %ebp
  8002f2:	c3                   	ret    

008002f3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002f3:	55                   	push   %ebp
  8002f4:	89 e5                	mov    %esp,%ebp
  8002f6:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002f9:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002fd:	8b 10                	mov    (%eax),%edx
  8002ff:	3b 50 04             	cmp    0x4(%eax),%edx
  800302:	73 0a                	jae    80030e <sprintputch+0x1b>
		*b->buf++ = ch;
  800304:	8d 4a 01             	lea    0x1(%edx),%ecx
  800307:	89 08                	mov    %ecx,(%eax)
  800309:	8b 45 08             	mov    0x8(%ebp),%eax
  80030c:	88 02                	mov    %al,(%edx)
}
  80030e:	5d                   	pop    %ebp
  80030f:	c3                   	ret    

00800310 <printfmt>:
{
  800310:	55                   	push   %ebp
  800311:	89 e5                	mov    %esp,%ebp
  800313:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800316:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800319:	50                   	push   %eax
  80031a:	ff 75 10             	pushl  0x10(%ebp)
  80031d:	ff 75 0c             	pushl  0xc(%ebp)
  800320:	ff 75 08             	pushl  0x8(%ebp)
  800323:	e8 05 00 00 00       	call   80032d <vprintfmt>
}
  800328:	83 c4 10             	add    $0x10,%esp
  80032b:	c9                   	leave  
  80032c:	c3                   	ret    

0080032d <vprintfmt>:
{
  80032d:	55                   	push   %ebp
  80032e:	89 e5                	mov    %esp,%ebp
  800330:	57                   	push   %edi
  800331:	56                   	push   %esi
  800332:	53                   	push   %ebx
  800333:	83 ec 3c             	sub    $0x3c,%esp
  800336:	8b 75 08             	mov    0x8(%ebp),%esi
  800339:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80033c:	8b 7d 10             	mov    0x10(%ebp),%edi
  80033f:	e9 1e 04 00 00       	jmp    800762 <vprintfmt+0x435>
		posflag = 0;
  800344:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  80034b:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80034f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800356:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80035d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800364:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  80036b:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800370:	8d 47 01             	lea    0x1(%edi),%eax
  800373:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800376:	0f b6 17             	movzbl (%edi),%edx
  800379:	8d 42 dd             	lea    -0x23(%edx),%eax
  80037c:	3c 55                	cmp    $0x55,%al
  80037e:	0f 87 d9 04 00 00    	ja     80085d <vprintfmt+0x530>
  800384:	0f b6 c0             	movzbl %al,%eax
  800387:	ff 24 85 c0 14 80 00 	jmp    *0x8014c0(,%eax,4)
  80038e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800391:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800395:	eb d9                	jmp    800370 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800397:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  80039a:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  8003a1:	eb cd                	jmp    800370 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003a3:	0f b6 d2             	movzbl %dl,%edx
  8003a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ae:	89 75 08             	mov    %esi,0x8(%ebp)
  8003b1:	eb 0c                	jmp    8003bf <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  8003b3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003b6:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  8003ba:	eb b4                	jmp    800370 <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  8003bc:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003bf:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003c2:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003c6:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003c9:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003cc:	83 fe 09             	cmp    $0x9,%esi
  8003cf:	76 eb                	jbe    8003bc <vprintfmt+0x8f>
  8003d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003d4:	8b 75 08             	mov    0x8(%ebp),%esi
  8003d7:	eb 14                	jmp    8003ed <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  8003d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003dc:	8b 00                	mov    (%eax),%eax
  8003de:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e4:	8d 40 04             	lea    0x4(%eax),%eax
  8003e7:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003ed:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003f1:	0f 89 79 ff ff ff    	jns    800370 <vprintfmt+0x43>
				width = precision, precision = -1;
  8003f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003fd:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800404:	e9 67 ff ff ff       	jmp    800370 <vprintfmt+0x43>
  800409:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80040c:	85 c0                	test   %eax,%eax
  80040e:	0f 48 c1             	cmovs  %ecx,%eax
  800411:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800414:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800417:	e9 54 ff ff ff       	jmp    800370 <vprintfmt+0x43>
  80041c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80041f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800426:	e9 45 ff ff ff       	jmp    800370 <vprintfmt+0x43>
			lflag++;
  80042b:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80042f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800432:	e9 39 ff ff ff       	jmp    800370 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800437:	8b 45 14             	mov    0x14(%ebp),%eax
  80043a:	8d 78 04             	lea    0x4(%eax),%edi
  80043d:	83 ec 08             	sub    $0x8,%esp
  800440:	53                   	push   %ebx
  800441:	ff 30                	pushl  (%eax)
  800443:	ff d6                	call   *%esi
			break;
  800445:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800448:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80044b:	e9 0f 03 00 00       	jmp    80075f <vprintfmt+0x432>
			err = va_arg(ap, int);
  800450:	8b 45 14             	mov    0x14(%ebp),%eax
  800453:	8d 78 04             	lea    0x4(%eax),%edi
  800456:	8b 00                	mov    (%eax),%eax
  800458:	99                   	cltd   
  800459:	31 d0                	xor    %edx,%eax
  80045b:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80045d:	83 f8 0f             	cmp    $0xf,%eax
  800460:	7f 23                	jg     800485 <vprintfmt+0x158>
  800462:	8b 14 85 20 16 80 00 	mov    0x801620(,%eax,4),%edx
  800469:	85 d2                	test   %edx,%edx
  80046b:	74 18                	je     800485 <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  80046d:	52                   	push   %edx
  80046e:	68 fc 12 80 00       	push   $0x8012fc
  800473:	53                   	push   %ebx
  800474:	56                   	push   %esi
  800475:	e8 96 fe ff ff       	call   800310 <printfmt>
  80047a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80047d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800480:	e9 da 02 00 00       	jmp    80075f <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  800485:	50                   	push   %eax
  800486:	68 f3 12 80 00       	push   $0x8012f3
  80048b:	53                   	push   %ebx
  80048c:	56                   	push   %esi
  80048d:	e8 7e fe ff ff       	call   800310 <printfmt>
  800492:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800495:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800498:	e9 c2 02 00 00       	jmp    80075f <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  80049d:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a0:	83 c0 04             	add    $0x4,%eax
  8004a3:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8004a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a9:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004ab:	85 c9                	test   %ecx,%ecx
  8004ad:	b8 ec 12 80 00       	mov    $0x8012ec,%eax
  8004b2:	0f 45 c1             	cmovne %ecx,%eax
  8004b5:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004b8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004bc:	7e 06                	jle    8004c4 <vprintfmt+0x197>
  8004be:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004c2:	75 0d                	jne    8004d1 <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004c7:	89 c7                	mov    %eax,%edi
  8004c9:	03 45 e0             	add    -0x20(%ebp),%eax
  8004cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004cf:	eb 53                	jmp    800524 <vprintfmt+0x1f7>
  8004d1:	83 ec 08             	sub    $0x8,%esp
  8004d4:	ff 75 d8             	pushl  -0x28(%ebp)
  8004d7:	50                   	push   %eax
  8004d8:	e8 28 04 00 00       	call   800905 <strnlen>
  8004dd:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004e0:	29 c1                	sub    %eax,%ecx
  8004e2:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  8004e5:	83 c4 10             	add    $0x10,%esp
  8004e8:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004ea:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f1:	eb 0f                	jmp    800502 <vprintfmt+0x1d5>
					putch(padc, putdat);
  8004f3:	83 ec 08             	sub    $0x8,%esp
  8004f6:	53                   	push   %ebx
  8004f7:	ff 75 e0             	pushl  -0x20(%ebp)
  8004fa:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004fc:	83 ef 01             	sub    $0x1,%edi
  8004ff:	83 c4 10             	add    $0x10,%esp
  800502:	85 ff                	test   %edi,%edi
  800504:	7f ed                	jg     8004f3 <vprintfmt+0x1c6>
  800506:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800509:	85 c9                	test   %ecx,%ecx
  80050b:	b8 00 00 00 00       	mov    $0x0,%eax
  800510:	0f 49 c1             	cmovns %ecx,%eax
  800513:	29 c1                	sub    %eax,%ecx
  800515:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800518:	eb aa                	jmp    8004c4 <vprintfmt+0x197>
					putch(ch, putdat);
  80051a:	83 ec 08             	sub    $0x8,%esp
  80051d:	53                   	push   %ebx
  80051e:	52                   	push   %edx
  80051f:	ff d6                	call   *%esi
  800521:	83 c4 10             	add    $0x10,%esp
  800524:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800527:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800529:	83 c7 01             	add    $0x1,%edi
  80052c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800530:	0f be d0             	movsbl %al,%edx
  800533:	85 d2                	test   %edx,%edx
  800535:	74 4b                	je     800582 <vprintfmt+0x255>
  800537:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80053b:	78 06                	js     800543 <vprintfmt+0x216>
  80053d:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800541:	78 1e                	js     800561 <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  800543:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800547:	74 d1                	je     80051a <vprintfmt+0x1ed>
  800549:	0f be c0             	movsbl %al,%eax
  80054c:	83 e8 20             	sub    $0x20,%eax
  80054f:	83 f8 5e             	cmp    $0x5e,%eax
  800552:	76 c6                	jbe    80051a <vprintfmt+0x1ed>
					putch('?', putdat);
  800554:	83 ec 08             	sub    $0x8,%esp
  800557:	53                   	push   %ebx
  800558:	6a 3f                	push   $0x3f
  80055a:	ff d6                	call   *%esi
  80055c:	83 c4 10             	add    $0x10,%esp
  80055f:	eb c3                	jmp    800524 <vprintfmt+0x1f7>
  800561:	89 cf                	mov    %ecx,%edi
  800563:	eb 0e                	jmp    800573 <vprintfmt+0x246>
				putch(' ', putdat);
  800565:	83 ec 08             	sub    $0x8,%esp
  800568:	53                   	push   %ebx
  800569:	6a 20                	push   $0x20
  80056b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80056d:	83 ef 01             	sub    $0x1,%edi
  800570:	83 c4 10             	add    $0x10,%esp
  800573:	85 ff                	test   %edi,%edi
  800575:	7f ee                	jg     800565 <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  800577:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80057a:	89 45 14             	mov    %eax,0x14(%ebp)
  80057d:	e9 dd 01 00 00       	jmp    80075f <vprintfmt+0x432>
  800582:	89 cf                	mov    %ecx,%edi
  800584:	eb ed                	jmp    800573 <vprintfmt+0x246>
	if (lflag >= 2)
  800586:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80058a:	7f 21                	jg     8005ad <vprintfmt+0x280>
	else if (lflag)
  80058c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800590:	74 6a                	je     8005fc <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  800592:	8b 45 14             	mov    0x14(%ebp),%eax
  800595:	8b 00                	mov    (%eax),%eax
  800597:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80059a:	89 c1                	mov    %eax,%ecx
  80059c:	c1 f9 1f             	sar    $0x1f,%ecx
  80059f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a5:	8d 40 04             	lea    0x4(%eax),%eax
  8005a8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ab:	eb 17                	jmp    8005c4 <vprintfmt+0x297>
		return va_arg(*ap, long long);
  8005ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b0:	8b 50 04             	mov    0x4(%eax),%edx
  8005b3:	8b 00                	mov    (%eax),%eax
  8005b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005be:	8d 40 08             	lea    0x8(%eax),%eax
  8005c1:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005c4:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  8005c7:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8005cc:	85 d2                	test   %edx,%edx
  8005ce:	0f 89 5c 01 00 00    	jns    800730 <vprintfmt+0x403>
				putch('-', putdat);
  8005d4:	83 ec 08             	sub    $0x8,%esp
  8005d7:	53                   	push   %ebx
  8005d8:	6a 2d                	push   $0x2d
  8005da:	ff d6                	call   *%esi
				num = -(long long) num;
  8005dc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005df:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005e2:	f7 d8                	neg    %eax
  8005e4:	83 d2 00             	adc    $0x0,%edx
  8005e7:	f7 da                	neg    %edx
  8005e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ec:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005ef:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005f2:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005f7:	e9 45 01 00 00       	jmp    800741 <vprintfmt+0x414>
		return va_arg(*ap, int);
  8005fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ff:	8b 00                	mov    (%eax),%eax
  800601:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800604:	89 c1                	mov    %eax,%ecx
  800606:	c1 f9 1f             	sar    $0x1f,%ecx
  800609:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80060c:	8b 45 14             	mov    0x14(%ebp),%eax
  80060f:	8d 40 04             	lea    0x4(%eax),%eax
  800612:	89 45 14             	mov    %eax,0x14(%ebp)
  800615:	eb ad                	jmp    8005c4 <vprintfmt+0x297>
	if (lflag >= 2)
  800617:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80061b:	7f 29                	jg     800646 <vprintfmt+0x319>
	else if (lflag)
  80061d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800621:	74 44                	je     800667 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  800623:	8b 45 14             	mov    0x14(%ebp),%eax
  800626:	8b 00                	mov    (%eax),%eax
  800628:	ba 00 00 00 00       	mov    $0x0,%edx
  80062d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800630:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800633:	8b 45 14             	mov    0x14(%ebp),%eax
  800636:	8d 40 04             	lea    0x4(%eax),%eax
  800639:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80063c:	bf 0a 00 00 00       	mov    $0xa,%edi
  800641:	e9 ea 00 00 00       	jmp    800730 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800646:	8b 45 14             	mov    0x14(%ebp),%eax
  800649:	8b 50 04             	mov    0x4(%eax),%edx
  80064c:	8b 00                	mov    (%eax),%eax
  80064e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800651:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800654:	8b 45 14             	mov    0x14(%ebp),%eax
  800657:	8d 40 08             	lea    0x8(%eax),%eax
  80065a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80065d:	bf 0a 00 00 00       	mov    $0xa,%edi
  800662:	e9 c9 00 00 00       	jmp    800730 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800667:	8b 45 14             	mov    0x14(%ebp),%eax
  80066a:	8b 00                	mov    (%eax),%eax
  80066c:	ba 00 00 00 00       	mov    $0x0,%edx
  800671:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800674:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800677:	8b 45 14             	mov    0x14(%ebp),%eax
  80067a:	8d 40 04             	lea    0x4(%eax),%eax
  80067d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800680:	bf 0a 00 00 00       	mov    $0xa,%edi
  800685:	e9 a6 00 00 00       	jmp    800730 <vprintfmt+0x403>
			putch('0', putdat);
  80068a:	83 ec 08             	sub    $0x8,%esp
  80068d:	53                   	push   %ebx
  80068e:	6a 30                	push   $0x30
  800690:	ff d6                	call   *%esi
	if (lflag >= 2)
  800692:	83 c4 10             	add    $0x10,%esp
  800695:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800699:	7f 26                	jg     8006c1 <vprintfmt+0x394>
	else if (lflag)
  80069b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80069f:	74 3e                	je     8006df <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  8006a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ae:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b4:	8d 40 04             	lea    0x4(%eax),%eax
  8006b7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006ba:	bf 08 00 00 00       	mov    $0x8,%edi
  8006bf:	eb 6f                	jmp    800730 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8006c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c4:	8b 50 04             	mov    0x4(%eax),%edx
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006cc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d2:	8d 40 08             	lea    0x8(%eax),%eax
  8006d5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006d8:	bf 08 00 00 00       	mov    $0x8,%edi
  8006dd:	eb 51                	jmp    800730 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8006df:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e2:	8b 00                	mov    (%eax),%eax
  8006e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ec:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f2:	8d 40 04             	lea    0x4(%eax),%eax
  8006f5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006f8:	bf 08 00 00 00       	mov    $0x8,%edi
  8006fd:	eb 31                	jmp    800730 <vprintfmt+0x403>
			putch('0', putdat);
  8006ff:	83 ec 08             	sub    $0x8,%esp
  800702:	53                   	push   %ebx
  800703:	6a 30                	push   $0x30
  800705:	ff d6                	call   *%esi
			putch('x', putdat);
  800707:	83 c4 08             	add    $0x8,%esp
  80070a:	53                   	push   %ebx
  80070b:	6a 78                	push   $0x78
  80070d:	ff d6                	call   *%esi
			num = (unsigned long long)
  80070f:	8b 45 14             	mov    0x14(%ebp),%eax
  800712:	8b 00                	mov    (%eax),%eax
  800714:	ba 00 00 00 00       	mov    $0x0,%edx
  800719:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80071c:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80071f:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800722:	8b 45 14             	mov    0x14(%ebp),%eax
  800725:	8d 40 04             	lea    0x4(%eax),%eax
  800728:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80072b:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  800730:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800734:	74 0b                	je     800741 <vprintfmt+0x414>
				putch('+', putdat);
  800736:	83 ec 08             	sub    $0x8,%esp
  800739:	53                   	push   %ebx
  80073a:	6a 2b                	push   $0x2b
  80073c:	ff d6                	call   *%esi
  80073e:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  800741:	83 ec 0c             	sub    $0xc,%esp
  800744:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800748:	50                   	push   %eax
  800749:	ff 75 e0             	pushl  -0x20(%ebp)
  80074c:	57                   	push   %edi
  80074d:	ff 75 dc             	pushl  -0x24(%ebp)
  800750:	ff 75 d8             	pushl  -0x28(%ebp)
  800753:	89 da                	mov    %ebx,%edx
  800755:	89 f0                	mov    %esi,%eax
  800757:	e8 b8 fa ff ff       	call   800214 <printnum>
			break;
  80075c:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  80075f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800762:	83 c7 01             	add    $0x1,%edi
  800765:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800769:	83 f8 25             	cmp    $0x25,%eax
  80076c:	0f 84 d2 fb ff ff    	je     800344 <vprintfmt+0x17>
			if (ch == '\0')
  800772:	85 c0                	test   %eax,%eax
  800774:	0f 84 03 01 00 00    	je     80087d <vprintfmt+0x550>
			putch(ch, putdat);
  80077a:	83 ec 08             	sub    $0x8,%esp
  80077d:	53                   	push   %ebx
  80077e:	50                   	push   %eax
  80077f:	ff d6                	call   *%esi
  800781:	83 c4 10             	add    $0x10,%esp
  800784:	eb dc                	jmp    800762 <vprintfmt+0x435>
	if (lflag >= 2)
  800786:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80078a:	7f 29                	jg     8007b5 <vprintfmt+0x488>
	else if (lflag)
  80078c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800790:	74 44                	je     8007d6 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  800792:	8b 45 14             	mov    0x14(%ebp),%eax
  800795:	8b 00                	mov    (%eax),%eax
  800797:	ba 00 00 00 00       	mov    $0x0,%edx
  80079c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a5:	8d 40 04             	lea    0x4(%eax),%eax
  8007a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ab:	bf 10 00 00 00       	mov    $0x10,%edi
  8007b0:	e9 7b ff ff ff       	jmp    800730 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8007b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b8:	8b 50 04             	mov    0x4(%eax),%edx
  8007bb:	8b 00                	mov    (%eax),%eax
  8007bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c6:	8d 40 08             	lea    0x8(%eax),%eax
  8007c9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007cc:	bf 10 00 00 00       	mov    $0x10,%edi
  8007d1:	e9 5a ff ff ff       	jmp    800730 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8007d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d9:	8b 00                	mov    (%eax),%eax
  8007db:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e9:	8d 40 04             	lea    0x4(%eax),%eax
  8007ec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ef:	bf 10 00 00 00       	mov    $0x10,%edi
  8007f4:	e9 37 ff ff ff       	jmp    800730 <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  8007f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fc:	8d 78 04             	lea    0x4(%eax),%edi
  8007ff:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  800801:	85 c0                	test   %eax,%eax
  800803:	74 2c                	je     800831 <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  800805:	8b 13                	mov    (%ebx),%edx
  800807:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  800809:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  80080c:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  80080f:	0f 8e 4a ff ff ff    	jle    80075f <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  800815:	68 4c 14 80 00       	push   $0x80144c
  80081a:	68 fc 12 80 00       	push   $0x8012fc
  80081f:	53                   	push   %ebx
  800820:	56                   	push   %esi
  800821:	e8 ea fa ff ff       	call   800310 <printfmt>
  800826:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800829:	89 7d 14             	mov    %edi,0x14(%ebp)
  80082c:	e9 2e ff ff ff       	jmp    80075f <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  800831:	68 14 14 80 00       	push   $0x801414
  800836:	68 fc 12 80 00       	push   $0x8012fc
  80083b:	53                   	push   %ebx
  80083c:	56                   	push   %esi
  80083d:	e8 ce fa ff ff       	call   800310 <printfmt>
        		break;
  800842:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800845:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  800848:	e9 12 ff ff ff       	jmp    80075f <vprintfmt+0x432>
			putch(ch, putdat);
  80084d:	83 ec 08             	sub    $0x8,%esp
  800850:	53                   	push   %ebx
  800851:	6a 25                	push   $0x25
  800853:	ff d6                	call   *%esi
			break;
  800855:	83 c4 10             	add    $0x10,%esp
  800858:	e9 02 ff ff ff       	jmp    80075f <vprintfmt+0x432>
			putch('%', putdat);
  80085d:	83 ec 08             	sub    $0x8,%esp
  800860:	53                   	push   %ebx
  800861:	6a 25                	push   $0x25
  800863:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800865:	83 c4 10             	add    $0x10,%esp
  800868:	89 f8                	mov    %edi,%eax
  80086a:	eb 03                	jmp    80086f <vprintfmt+0x542>
  80086c:	83 e8 01             	sub    $0x1,%eax
  80086f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800873:	75 f7                	jne    80086c <vprintfmt+0x53f>
  800875:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800878:	e9 e2 fe ff ff       	jmp    80075f <vprintfmt+0x432>
}
  80087d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800880:	5b                   	pop    %ebx
  800881:	5e                   	pop    %esi
  800882:	5f                   	pop    %edi
  800883:	5d                   	pop    %ebp
  800884:	c3                   	ret    

00800885 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800885:	55                   	push   %ebp
  800886:	89 e5                	mov    %esp,%ebp
  800888:	83 ec 18             	sub    $0x18,%esp
  80088b:	8b 45 08             	mov    0x8(%ebp),%eax
  80088e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800891:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800894:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800898:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80089b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008a2:	85 c0                	test   %eax,%eax
  8008a4:	74 26                	je     8008cc <vsnprintf+0x47>
  8008a6:	85 d2                	test   %edx,%edx
  8008a8:	7e 22                	jle    8008cc <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008aa:	ff 75 14             	pushl  0x14(%ebp)
  8008ad:	ff 75 10             	pushl  0x10(%ebp)
  8008b0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008b3:	50                   	push   %eax
  8008b4:	68 f3 02 80 00       	push   $0x8002f3
  8008b9:	e8 6f fa ff ff       	call   80032d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008c7:	83 c4 10             	add    $0x10,%esp
}
  8008ca:	c9                   	leave  
  8008cb:	c3                   	ret    
		return -E_INVAL;
  8008cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008d1:	eb f7                	jmp    8008ca <vsnprintf+0x45>

008008d3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008d3:	55                   	push   %ebp
  8008d4:	89 e5                	mov    %esp,%ebp
  8008d6:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008d9:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008dc:	50                   	push   %eax
  8008dd:	ff 75 10             	pushl  0x10(%ebp)
  8008e0:	ff 75 0c             	pushl  0xc(%ebp)
  8008e3:	ff 75 08             	pushl  0x8(%ebp)
  8008e6:	e8 9a ff ff ff       	call   800885 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008eb:	c9                   	leave  
  8008ec:	c3                   	ret    

008008ed <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008ed:	55                   	push   %ebp
  8008ee:	89 e5                	mov    %esp,%ebp
  8008f0:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f8:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008fc:	74 05                	je     800903 <strlen+0x16>
		n++;
  8008fe:	83 c0 01             	add    $0x1,%eax
  800901:	eb f5                	jmp    8008f8 <strlen+0xb>
	return n;
}
  800903:	5d                   	pop    %ebp
  800904:	c3                   	ret    

00800905 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800905:	55                   	push   %ebp
  800906:	89 e5                	mov    %esp,%ebp
  800908:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80090b:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80090e:	ba 00 00 00 00       	mov    $0x0,%edx
  800913:	39 c2                	cmp    %eax,%edx
  800915:	74 0d                	je     800924 <strnlen+0x1f>
  800917:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80091b:	74 05                	je     800922 <strnlen+0x1d>
		n++;
  80091d:	83 c2 01             	add    $0x1,%edx
  800920:	eb f1                	jmp    800913 <strnlen+0xe>
  800922:	89 d0                	mov    %edx,%eax
	return n;
}
  800924:	5d                   	pop    %ebp
  800925:	c3                   	ret    

00800926 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800926:	55                   	push   %ebp
  800927:	89 e5                	mov    %esp,%ebp
  800929:	53                   	push   %ebx
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800930:	ba 00 00 00 00       	mov    $0x0,%edx
  800935:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800939:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80093c:	83 c2 01             	add    $0x1,%edx
  80093f:	84 c9                	test   %cl,%cl
  800941:	75 f2                	jne    800935 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800943:	5b                   	pop    %ebx
  800944:	5d                   	pop    %ebp
  800945:	c3                   	ret    

00800946 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800946:	55                   	push   %ebp
  800947:	89 e5                	mov    %esp,%ebp
  800949:	53                   	push   %ebx
  80094a:	83 ec 10             	sub    $0x10,%esp
  80094d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800950:	53                   	push   %ebx
  800951:	e8 97 ff ff ff       	call   8008ed <strlen>
  800956:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800959:	ff 75 0c             	pushl  0xc(%ebp)
  80095c:	01 d8                	add    %ebx,%eax
  80095e:	50                   	push   %eax
  80095f:	e8 c2 ff ff ff       	call   800926 <strcpy>
	return dst;
}
  800964:	89 d8                	mov    %ebx,%eax
  800966:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800969:	c9                   	leave  
  80096a:	c3                   	ret    

0080096b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80096b:	55                   	push   %ebp
  80096c:	89 e5                	mov    %esp,%ebp
  80096e:	56                   	push   %esi
  80096f:	53                   	push   %ebx
  800970:	8b 45 08             	mov    0x8(%ebp),%eax
  800973:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800976:	89 c6                	mov    %eax,%esi
  800978:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80097b:	89 c2                	mov    %eax,%edx
  80097d:	39 f2                	cmp    %esi,%edx
  80097f:	74 11                	je     800992 <strncpy+0x27>
		*dst++ = *src;
  800981:	83 c2 01             	add    $0x1,%edx
  800984:	0f b6 19             	movzbl (%ecx),%ebx
  800987:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80098a:	80 fb 01             	cmp    $0x1,%bl
  80098d:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800990:	eb eb                	jmp    80097d <strncpy+0x12>
	}
	return ret;
}
  800992:	5b                   	pop    %ebx
  800993:	5e                   	pop    %esi
  800994:	5d                   	pop    %ebp
  800995:	c3                   	ret    

00800996 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800996:	55                   	push   %ebp
  800997:	89 e5                	mov    %esp,%ebp
  800999:	56                   	push   %esi
  80099a:	53                   	push   %ebx
  80099b:	8b 75 08             	mov    0x8(%ebp),%esi
  80099e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009a1:	8b 55 10             	mov    0x10(%ebp),%edx
  8009a4:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009a6:	85 d2                	test   %edx,%edx
  8009a8:	74 21                	je     8009cb <strlcpy+0x35>
  8009aa:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009ae:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009b0:	39 c2                	cmp    %eax,%edx
  8009b2:	74 14                	je     8009c8 <strlcpy+0x32>
  8009b4:	0f b6 19             	movzbl (%ecx),%ebx
  8009b7:	84 db                	test   %bl,%bl
  8009b9:	74 0b                	je     8009c6 <strlcpy+0x30>
			*dst++ = *src++;
  8009bb:	83 c1 01             	add    $0x1,%ecx
  8009be:	83 c2 01             	add    $0x1,%edx
  8009c1:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009c4:	eb ea                	jmp    8009b0 <strlcpy+0x1a>
  8009c6:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009c8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009cb:	29 f0                	sub    %esi,%eax
}
  8009cd:	5b                   	pop    %ebx
  8009ce:	5e                   	pop    %esi
  8009cf:	5d                   	pop    %ebp
  8009d0:	c3                   	ret    

008009d1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009d7:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009da:	0f b6 01             	movzbl (%ecx),%eax
  8009dd:	84 c0                	test   %al,%al
  8009df:	74 0c                	je     8009ed <strcmp+0x1c>
  8009e1:	3a 02                	cmp    (%edx),%al
  8009e3:	75 08                	jne    8009ed <strcmp+0x1c>
		p++, q++;
  8009e5:	83 c1 01             	add    $0x1,%ecx
  8009e8:	83 c2 01             	add    $0x1,%edx
  8009eb:	eb ed                	jmp    8009da <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009ed:	0f b6 c0             	movzbl %al,%eax
  8009f0:	0f b6 12             	movzbl (%edx),%edx
  8009f3:	29 d0                	sub    %edx,%eax
}
  8009f5:	5d                   	pop    %ebp
  8009f6:	c3                   	ret    

008009f7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009f7:	55                   	push   %ebp
  8009f8:	89 e5                	mov    %esp,%ebp
  8009fa:	53                   	push   %ebx
  8009fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a01:	89 c3                	mov    %eax,%ebx
  800a03:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a06:	eb 06                	jmp    800a0e <strncmp+0x17>
		n--, p++, q++;
  800a08:	83 c0 01             	add    $0x1,%eax
  800a0b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a0e:	39 d8                	cmp    %ebx,%eax
  800a10:	74 16                	je     800a28 <strncmp+0x31>
  800a12:	0f b6 08             	movzbl (%eax),%ecx
  800a15:	84 c9                	test   %cl,%cl
  800a17:	74 04                	je     800a1d <strncmp+0x26>
  800a19:	3a 0a                	cmp    (%edx),%cl
  800a1b:	74 eb                	je     800a08 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a1d:	0f b6 00             	movzbl (%eax),%eax
  800a20:	0f b6 12             	movzbl (%edx),%edx
  800a23:	29 d0                	sub    %edx,%eax
}
  800a25:	5b                   	pop    %ebx
  800a26:	5d                   	pop    %ebp
  800a27:	c3                   	ret    
		return 0;
  800a28:	b8 00 00 00 00       	mov    $0x0,%eax
  800a2d:	eb f6                	jmp    800a25 <strncmp+0x2e>

00800a2f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a2f:	55                   	push   %ebp
  800a30:	89 e5                	mov    %esp,%ebp
  800a32:	8b 45 08             	mov    0x8(%ebp),%eax
  800a35:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a39:	0f b6 10             	movzbl (%eax),%edx
  800a3c:	84 d2                	test   %dl,%dl
  800a3e:	74 09                	je     800a49 <strchr+0x1a>
		if (*s == c)
  800a40:	38 ca                	cmp    %cl,%dl
  800a42:	74 0a                	je     800a4e <strchr+0x1f>
	for (; *s; s++)
  800a44:	83 c0 01             	add    $0x1,%eax
  800a47:	eb f0                	jmp    800a39 <strchr+0xa>
			return (char *) s;
	return 0;
  800a49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a4e:	5d                   	pop    %ebp
  800a4f:	c3                   	ret    

00800a50 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	8b 45 08             	mov    0x8(%ebp),%eax
  800a56:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a5a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a5d:	38 ca                	cmp    %cl,%dl
  800a5f:	74 09                	je     800a6a <strfind+0x1a>
  800a61:	84 d2                	test   %dl,%dl
  800a63:	74 05                	je     800a6a <strfind+0x1a>
	for (; *s; s++)
  800a65:	83 c0 01             	add    $0x1,%eax
  800a68:	eb f0                	jmp    800a5a <strfind+0xa>
			break;
	return (char *) s;
}
  800a6a:	5d                   	pop    %ebp
  800a6b:	c3                   	ret    

00800a6c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a6c:	55                   	push   %ebp
  800a6d:	89 e5                	mov    %esp,%ebp
  800a6f:	57                   	push   %edi
  800a70:	56                   	push   %esi
  800a71:	53                   	push   %ebx
  800a72:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a75:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a78:	85 c9                	test   %ecx,%ecx
  800a7a:	74 31                	je     800aad <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a7c:	89 f8                	mov    %edi,%eax
  800a7e:	09 c8                	or     %ecx,%eax
  800a80:	a8 03                	test   $0x3,%al
  800a82:	75 23                	jne    800aa7 <memset+0x3b>
		c &= 0xFF;
  800a84:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a88:	89 d3                	mov    %edx,%ebx
  800a8a:	c1 e3 08             	shl    $0x8,%ebx
  800a8d:	89 d0                	mov    %edx,%eax
  800a8f:	c1 e0 18             	shl    $0x18,%eax
  800a92:	89 d6                	mov    %edx,%esi
  800a94:	c1 e6 10             	shl    $0x10,%esi
  800a97:	09 f0                	or     %esi,%eax
  800a99:	09 c2                	or     %eax,%edx
  800a9b:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a9d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800aa0:	89 d0                	mov    %edx,%eax
  800aa2:	fc                   	cld    
  800aa3:	f3 ab                	rep stos %eax,%es:(%edi)
  800aa5:	eb 06                	jmp    800aad <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aaa:	fc                   	cld    
  800aab:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800aad:	89 f8                	mov    %edi,%eax
  800aaf:	5b                   	pop    %ebx
  800ab0:	5e                   	pop    %esi
  800ab1:	5f                   	pop    %edi
  800ab2:	5d                   	pop    %ebp
  800ab3:	c3                   	ret    

00800ab4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ab4:	55                   	push   %ebp
  800ab5:	89 e5                	mov    %esp,%ebp
  800ab7:	57                   	push   %edi
  800ab8:	56                   	push   %esi
  800ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  800abc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800abf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ac2:	39 c6                	cmp    %eax,%esi
  800ac4:	73 32                	jae    800af8 <memmove+0x44>
  800ac6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ac9:	39 c2                	cmp    %eax,%edx
  800acb:	76 2b                	jbe    800af8 <memmove+0x44>
		s += n;
		d += n;
  800acd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ad0:	89 fe                	mov    %edi,%esi
  800ad2:	09 ce                	or     %ecx,%esi
  800ad4:	09 d6                	or     %edx,%esi
  800ad6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800adc:	75 0e                	jne    800aec <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ade:	83 ef 04             	sub    $0x4,%edi
  800ae1:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ae4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ae7:	fd                   	std    
  800ae8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aea:	eb 09                	jmp    800af5 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aec:	83 ef 01             	sub    $0x1,%edi
  800aef:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800af2:	fd                   	std    
  800af3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800af5:	fc                   	cld    
  800af6:	eb 1a                	jmp    800b12 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800af8:	89 c2                	mov    %eax,%edx
  800afa:	09 ca                	or     %ecx,%edx
  800afc:	09 f2                	or     %esi,%edx
  800afe:	f6 c2 03             	test   $0x3,%dl
  800b01:	75 0a                	jne    800b0d <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b03:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b06:	89 c7                	mov    %eax,%edi
  800b08:	fc                   	cld    
  800b09:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b0b:	eb 05                	jmp    800b12 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b0d:	89 c7                	mov    %eax,%edi
  800b0f:	fc                   	cld    
  800b10:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b12:	5e                   	pop    %esi
  800b13:	5f                   	pop    %edi
  800b14:	5d                   	pop    %ebp
  800b15:	c3                   	ret    

00800b16 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b16:	55                   	push   %ebp
  800b17:	89 e5                	mov    %esp,%ebp
  800b19:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b1c:	ff 75 10             	pushl  0x10(%ebp)
  800b1f:	ff 75 0c             	pushl  0xc(%ebp)
  800b22:	ff 75 08             	pushl  0x8(%ebp)
  800b25:	e8 8a ff ff ff       	call   800ab4 <memmove>
}
  800b2a:	c9                   	leave  
  800b2b:	c3                   	ret    

00800b2c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b2c:	55                   	push   %ebp
  800b2d:	89 e5                	mov    %esp,%ebp
  800b2f:	56                   	push   %esi
  800b30:	53                   	push   %ebx
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b37:	89 c6                	mov    %eax,%esi
  800b39:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b3c:	39 f0                	cmp    %esi,%eax
  800b3e:	74 1c                	je     800b5c <memcmp+0x30>
		if (*s1 != *s2)
  800b40:	0f b6 08             	movzbl (%eax),%ecx
  800b43:	0f b6 1a             	movzbl (%edx),%ebx
  800b46:	38 d9                	cmp    %bl,%cl
  800b48:	75 08                	jne    800b52 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b4a:	83 c0 01             	add    $0x1,%eax
  800b4d:	83 c2 01             	add    $0x1,%edx
  800b50:	eb ea                	jmp    800b3c <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b52:	0f b6 c1             	movzbl %cl,%eax
  800b55:	0f b6 db             	movzbl %bl,%ebx
  800b58:	29 d8                	sub    %ebx,%eax
  800b5a:	eb 05                	jmp    800b61 <memcmp+0x35>
	}

	return 0;
  800b5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b61:	5b                   	pop    %ebx
  800b62:	5e                   	pop    %esi
  800b63:	5d                   	pop    %ebp
  800b64:	c3                   	ret    

00800b65 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b6e:	89 c2                	mov    %eax,%edx
  800b70:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b73:	39 d0                	cmp    %edx,%eax
  800b75:	73 09                	jae    800b80 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b77:	38 08                	cmp    %cl,(%eax)
  800b79:	74 05                	je     800b80 <memfind+0x1b>
	for (; s < ends; s++)
  800b7b:	83 c0 01             	add    $0x1,%eax
  800b7e:	eb f3                	jmp    800b73 <memfind+0xe>
			break;
	return (void *) s;
}
  800b80:	5d                   	pop    %ebp
  800b81:	c3                   	ret    

00800b82 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	57                   	push   %edi
  800b86:	56                   	push   %esi
  800b87:	53                   	push   %ebx
  800b88:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b8b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b8e:	eb 03                	jmp    800b93 <strtol+0x11>
		s++;
  800b90:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b93:	0f b6 01             	movzbl (%ecx),%eax
  800b96:	3c 20                	cmp    $0x20,%al
  800b98:	74 f6                	je     800b90 <strtol+0xe>
  800b9a:	3c 09                	cmp    $0x9,%al
  800b9c:	74 f2                	je     800b90 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b9e:	3c 2b                	cmp    $0x2b,%al
  800ba0:	74 2a                	je     800bcc <strtol+0x4a>
	int neg = 0;
  800ba2:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ba7:	3c 2d                	cmp    $0x2d,%al
  800ba9:	74 2b                	je     800bd6 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bab:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bb1:	75 0f                	jne    800bc2 <strtol+0x40>
  800bb3:	80 39 30             	cmpb   $0x30,(%ecx)
  800bb6:	74 28                	je     800be0 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bb8:	85 db                	test   %ebx,%ebx
  800bba:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bbf:	0f 44 d8             	cmove  %eax,%ebx
  800bc2:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc7:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bca:	eb 50                	jmp    800c1c <strtol+0x9a>
		s++;
  800bcc:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bcf:	bf 00 00 00 00       	mov    $0x0,%edi
  800bd4:	eb d5                	jmp    800bab <strtol+0x29>
		s++, neg = 1;
  800bd6:	83 c1 01             	add    $0x1,%ecx
  800bd9:	bf 01 00 00 00       	mov    $0x1,%edi
  800bde:	eb cb                	jmp    800bab <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800be0:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800be4:	74 0e                	je     800bf4 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800be6:	85 db                	test   %ebx,%ebx
  800be8:	75 d8                	jne    800bc2 <strtol+0x40>
		s++, base = 8;
  800bea:	83 c1 01             	add    $0x1,%ecx
  800bed:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bf2:	eb ce                	jmp    800bc2 <strtol+0x40>
		s += 2, base = 16;
  800bf4:	83 c1 02             	add    $0x2,%ecx
  800bf7:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bfc:	eb c4                	jmp    800bc2 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bfe:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c01:	89 f3                	mov    %esi,%ebx
  800c03:	80 fb 19             	cmp    $0x19,%bl
  800c06:	77 29                	ja     800c31 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c08:	0f be d2             	movsbl %dl,%edx
  800c0b:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c0e:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c11:	7d 30                	jge    800c43 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c13:	83 c1 01             	add    $0x1,%ecx
  800c16:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c1a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c1c:	0f b6 11             	movzbl (%ecx),%edx
  800c1f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c22:	89 f3                	mov    %esi,%ebx
  800c24:	80 fb 09             	cmp    $0x9,%bl
  800c27:	77 d5                	ja     800bfe <strtol+0x7c>
			dig = *s - '0';
  800c29:	0f be d2             	movsbl %dl,%edx
  800c2c:	83 ea 30             	sub    $0x30,%edx
  800c2f:	eb dd                	jmp    800c0e <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c31:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c34:	89 f3                	mov    %esi,%ebx
  800c36:	80 fb 19             	cmp    $0x19,%bl
  800c39:	77 08                	ja     800c43 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c3b:	0f be d2             	movsbl %dl,%edx
  800c3e:	83 ea 37             	sub    $0x37,%edx
  800c41:	eb cb                	jmp    800c0e <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c43:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c47:	74 05                	je     800c4e <strtol+0xcc>
		*endptr = (char *) s;
  800c49:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c4c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c4e:	89 c2                	mov    %eax,%edx
  800c50:	f7 da                	neg    %edx
  800c52:	85 ff                	test   %edi,%edi
  800c54:	0f 45 c2             	cmovne %edx,%eax
}
  800c57:	5b                   	pop    %ebx
  800c58:	5e                   	pop    %esi
  800c59:	5f                   	pop    %edi
  800c5a:	5d                   	pop    %ebp
  800c5b:	c3                   	ret    

00800c5c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	57                   	push   %edi
  800c60:	56                   	push   %esi
  800c61:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c62:	b8 00 00 00 00       	mov    $0x0,%eax
  800c67:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c6d:	89 c3                	mov    %eax,%ebx
  800c6f:	89 c7                	mov    %eax,%edi
  800c71:	89 c6                	mov    %eax,%esi
  800c73:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c75:	5b                   	pop    %ebx
  800c76:	5e                   	pop    %esi
  800c77:	5f                   	pop    %edi
  800c78:	5d                   	pop    %ebp
  800c79:	c3                   	ret    

00800c7a <sys_cgetc>:

int
sys_cgetc(void)
{
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
  800c7d:	57                   	push   %edi
  800c7e:	56                   	push   %esi
  800c7f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c80:	ba 00 00 00 00       	mov    $0x0,%edx
  800c85:	b8 01 00 00 00       	mov    $0x1,%eax
  800c8a:	89 d1                	mov    %edx,%ecx
  800c8c:	89 d3                	mov    %edx,%ebx
  800c8e:	89 d7                	mov    %edx,%edi
  800c90:	89 d6                	mov    %edx,%esi
  800c92:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c94:	5b                   	pop    %ebx
  800c95:	5e                   	pop    %esi
  800c96:	5f                   	pop    %edi
  800c97:	5d                   	pop    %ebp
  800c98:	c3                   	ret    

00800c99 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c99:	55                   	push   %ebp
  800c9a:	89 e5                	mov    %esp,%ebp
  800c9c:	57                   	push   %edi
  800c9d:	56                   	push   %esi
  800c9e:	53                   	push   %ebx
  800c9f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ca2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ca7:	8b 55 08             	mov    0x8(%ebp),%edx
  800caa:	b8 03 00 00 00       	mov    $0x3,%eax
  800caf:	89 cb                	mov    %ecx,%ebx
  800cb1:	89 cf                	mov    %ecx,%edi
  800cb3:	89 ce                	mov    %ecx,%esi
  800cb5:	cd 30                	int    $0x30
	if (check && ret > 0)
  800cb7:	85 c0                	test   %eax,%eax
  800cb9:	7f 08                	jg     800cc3 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cbe:	5b                   	pop    %ebx
  800cbf:	5e                   	pop    %esi
  800cc0:	5f                   	pop    %edi
  800cc1:	5d                   	pop    %ebp
  800cc2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc3:	83 ec 0c             	sub    $0xc,%esp
  800cc6:	50                   	push   %eax
  800cc7:	6a 03                	push   $0x3
  800cc9:	68 60 16 80 00       	push   $0x801660
  800cce:	6a 4c                	push   $0x4c
  800cd0:	68 7d 16 80 00       	push   $0x80167d
  800cd5:	e8 4b f4 ff ff       	call   800125 <_panic>

00800cda <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cda:	55                   	push   %ebp
  800cdb:	89 e5                	mov    %esp,%ebp
  800cdd:	57                   	push   %edi
  800cde:	56                   	push   %esi
  800cdf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ce0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce5:	b8 02 00 00 00       	mov    $0x2,%eax
  800cea:	89 d1                	mov    %edx,%ecx
  800cec:	89 d3                	mov    %edx,%ebx
  800cee:	89 d7                	mov    %edx,%edi
  800cf0:	89 d6                	mov    %edx,%esi
  800cf2:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cf4:	5b                   	pop    %ebx
  800cf5:	5e                   	pop    %esi
  800cf6:	5f                   	pop    %edi
  800cf7:	5d                   	pop    %ebp
  800cf8:	c3                   	ret    

00800cf9 <sys_yield>:

void
sys_yield(void)
{
  800cf9:	55                   	push   %ebp
  800cfa:	89 e5                	mov    %esp,%ebp
  800cfc:	57                   	push   %edi
  800cfd:	56                   	push   %esi
  800cfe:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cff:	ba 00 00 00 00       	mov    $0x0,%edx
  800d04:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d09:	89 d1                	mov    %edx,%ecx
  800d0b:	89 d3                	mov    %edx,%ebx
  800d0d:	89 d7                	mov    %edx,%edi
  800d0f:	89 d6                	mov    %edx,%esi
  800d11:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d13:	5b                   	pop    %ebx
  800d14:	5e                   	pop    %esi
  800d15:	5f                   	pop    %edi
  800d16:	5d                   	pop    %ebp
  800d17:	c3                   	ret    

00800d18 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d18:	55                   	push   %ebp
  800d19:	89 e5                	mov    %esp,%ebp
  800d1b:	57                   	push   %edi
  800d1c:	56                   	push   %esi
  800d1d:	53                   	push   %ebx
  800d1e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d21:	be 00 00 00 00       	mov    $0x0,%esi
  800d26:	8b 55 08             	mov    0x8(%ebp),%edx
  800d29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2c:	b8 04 00 00 00       	mov    $0x4,%eax
  800d31:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d34:	89 f7                	mov    %esi,%edi
  800d36:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d38:	85 c0                	test   %eax,%eax
  800d3a:	7f 08                	jg     800d44 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d3f:	5b                   	pop    %ebx
  800d40:	5e                   	pop    %esi
  800d41:	5f                   	pop    %edi
  800d42:	5d                   	pop    %ebp
  800d43:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d44:	83 ec 0c             	sub    $0xc,%esp
  800d47:	50                   	push   %eax
  800d48:	6a 04                	push   $0x4
  800d4a:	68 60 16 80 00       	push   $0x801660
  800d4f:	6a 4c                	push   $0x4c
  800d51:	68 7d 16 80 00       	push   $0x80167d
  800d56:	e8 ca f3 ff ff       	call   800125 <_panic>

00800d5b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d5b:	55                   	push   %ebp
  800d5c:	89 e5                	mov    %esp,%ebp
  800d5e:	57                   	push   %edi
  800d5f:	56                   	push   %esi
  800d60:	53                   	push   %ebx
  800d61:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d64:	8b 55 08             	mov    0x8(%ebp),%edx
  800d67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6a:	b8 05 00 00 00       	mov    $0x5,%eax
  800d6f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d72:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d75:	8b 75 18             	mov    0x18(%ebp),%esi
  800d78:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d7a:	85 c0                	test   %eax,%eax
  800d7c:	7f 08                	jg     800d86 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d81:	5b                   	pop    %ebx
  800d82:	5e                   	pop    %esi
  800d83:	5f                   	pop    %edi
  800d84:	5d                   	pop    %ebp
  800d85:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d86:	83 ec 0c             	sub    $0xc,%esp
  800d89:	50                   	push   %eax
  800d8a:	6a 05                	push   $0x5
  800d8c:	68 60 16 80 00       	push   $0x801660
  800d91:	6a 4c                	push   $0x4c
  800d93:	68 7d 16 80 00       	push   $0x80167d
  800d98:	e8 88 f3 ff ff       	call   800125 <_panic>

00800d9d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d9d:	55                   	push   %ebp
  800d9e:	89 e5                	mov    %esp,%ebp
  800da0:	57                   	push   %edi
  800da1:	56                   	push   %esi
  800da2:	53                   	push   %ebx
  800da3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dab:	8b 55 08             	mov    0x8(%ebp),%edx
  800dae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db1:	b8 06 00 00 00       	mov    $0x6,%eax
  800db6:	89 df                	mov    %ebx,%edi
  800db8:	89 de                	mov    %ebx,%esi
  800dba:	cd 30                	int    $0x30
	if (check && ret > 0)
  800dbc:	85 c0                	test   %eax,%eax
  800dbe:	7f 08                	jg     800dc8 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc3:	5b                   	pop    %ebx
  800dc4:	5e                   	pop    %esi
  800dc5:	5f                   	pop    %edi
  800dc6:	5d                   	pop    %ebp
  800dc7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc8:	83 ec 0c             	sub    $0xc,%esp
  800dcb:	50                   	push   %eax
  800dcc:	6a 06                	push   $0x6
  800dce:	68 60 16 80 00       	push   $0x801660
  800dd3:	6a 4c                	push   $0x4c
  800dd5:	68 7d 16 80 00       	push   $0x80167d
  800dda:	e8 46 f3 ff ff       	call   800125 <_panic>

00800ddf <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ddf:	55                   	push   %ebp
  800de0:	89 e5                	mov    %esp,%ebp
  800de2:	57                   	push   %edi
  800de3:	56                   	push   %esi
  800de4:	53                   	push   %ebx
  800de5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ded:	8b 55 08             	mov    0x8(%ebp),%edx
  800df0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df3:	b8 08 00 00 00       	mov    $0x8,%eax
  800df8:	89 df                	mov    %ebx,%edi
  800dfa:	89 de                	mov    %ebx,%esi
  800dfc:	cd 30                	int    $0x30
	if (check && ret > 0)
  800dfe:	85 c0                	test   %eax,%eax
  800e00:	7f 08                	jg     800e0a <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e02:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e05:	5b                   	pop    %ebx
  800e06:	5e                   	pop    %esi
  800e07:	5f                   	pop    %edi
  800e08:	5d                   	pop    %ebp
  800e09:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0a:	83 ec 0c             	sub    $0xc,%esp
  800e0d:	50                   	push   %eax
  800e0e:	6a 08                	push   $0x8
  800e10:	68 60 16 80 00       	push   $0x801660
  800e15:	6a 4c                	push   $0x4c
  800e17:	68 7d 16 80 00       	push   $0x80167d
  800e1c:	e8 04 f3 ff ff       	call   800125 <_panic>

00800e21 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e21:	55                   	push   %ebp
  800e22:	89 e5                	mov    %esp,%ebp
  800e24:	57                   	push   %edi
  800e25:	56                   	push   %esi
  800e26:	53                   	push   %ebx
  800e27:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e2a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e2f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e35:	b8 09 00 00 00       	mov    $0x9,%eax
  800e3a:	89 df                	mov    %ebx,%edi
  800e3c:	89 de                	mov    %ebx,%esi
  800e3e:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e40:	85 c0                	test   %eax,%eax
  800e42:	7f 08                	jg     800e4c <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e44:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e47:	5b                   	pop    %ebx
  800e48:	5e                   	pop    %esi
  800e49:	5f                   	pop    %edi
  800e4a:	5d                   	pop    %ebp
  800e4b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4c:	83 ec 0c             	sub    $0xc,%esp
  800e4f:	50                   	push   %eax
  800e50:	6a 09                	push   $0x9
  800e52:	68 60 16 80 00       	push   $0x801660
  800e57:	6a 4c                	push   $0x4c
  800e59:	68 7d 16 80 00       	push   $0x80167d
  800e5e:	e8 c2 f2 ff ff       	call   800125 <_panic>

00800e63 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e63:	55                   	push   %ebp
  800e64:	89 e5                	mov    %esp,%ebp
  800e66:	57                   	push   %edi
  800e67:	56                   	push   %esi
  800e68:	53                   	push   %ebx
  800e69:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e6c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e71:	8b 55 08             	mov    0x8(%ebp),%edx
  800e74:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e77:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e7c:	89 df                	mov    %ebx,%edi
  800e7e:	89 de                	mov    %ebx,%esi
  800e80:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e82:	85 c0                	test   %eax,%eax
  800e84:	7f 08                	jg     800e8e <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e86:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e89:	5b                   	pop    %ebx
  800e8a:	5e                   	pop    %esi
  800e8b:	5f                   	pop    %edi
  800e8c:	5d                   	pop    %ebp
  800e8d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8e:	83 ec 0c             	sub    $0xc,%esp
  800e91:	50                   	push   %eax
  800e92:	6a 0a                	push   $0xa
  800e94:	68 60 16 80 00       	push   $0x801660
  800e99:	6a 4c                	push   $0x4c
  800e9b:	68 7d 16 80 00       	push   $0x80167d
  800ea0:	e8 80 f2 ff ff       	call   800125 <_panic>

00800ea5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	57                   	push   %edi
  800ea9:	56                   	push   %esi
  800eaa:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eab:	8b 55 08             	mov    0x8(%ebp),%edx
  800eae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800eb6:	be 00 00 00 00       	mov    $0x0,%esi
  800ebb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ebe:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ec1:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ec3:	5b                   	pop    %ebx
  800ec4:	5e                   	pop    %esi
  800ec5:	5f                   	pop    %edi
  800ec6:	5d                   	pop    %ebp
  800ec7:	c3                   	ret    

00800ec8 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ec8:	55                   	push   %ebp
  800ec9:	89 e5                	mov    %esp,%ebp
  800ecb:	57                   	push   %edi
  800ecc:	56                   	push   %esi
  800ecd:	53                   	push   %ebx
  800ece:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ed6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed9:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ede:	89 cb                	mov    %ecx,%ebx
  800ee0:	89 cf                	mov    %ecx,%edi
  800ee2:	89 ce                	mov    %ecx,%esi
  800ee4:	cd 30                	int    $0x30
	if (check && ret > 0)
  800ee6:	85 c0                	test   %eax,%eax
  800ee8:	7f 08                	jg     800ef2 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800eea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eed:	5b                   	pop    %ebx
  800eee:	5e                   	pop    %esi
  800eef:	5f                   	pop    %edi
  800ef0:	5d                   	pop    %ebp
  800ef1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef2:	83 ec 0c             	sub    $0xc,%esp
  800ef5:	50                   	push   %eax
  800ef6:	6a 0d                	push   $0xd
  800ef8:	68 60 16 80 00       	push   $0x801660
  800efd:	6a 4c                	push   $0x4c
  800eff:	68 7d 16 80 00       	push   $0x80167d
  800f04:	e8 1c f2 ff ff       	call   800125 <_panic>

00800f09 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f09:	55                   	push   %ebp
  800f0a:	89 e5                	mov    %esp,%ebp
  800f0c:	57                   	push   %edi
  800f0d:	56                   	push   %esi
  800f0e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f0f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f14:	8b 55 08             	mov    0x8(%ebp),%edx
  800f17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1a:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f1f:	89 df                	mov    %ebx,%edi
  800f21:	89 de                	mov    %ebx,%esi
  800f23:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f25:	5b                   	pop    %ebx
  800f26:	5e                   	pop    %esi
  800f27:	5f                   	pop    %edi
  800f28:	5d                   	pop    %ebp
  800f29:	c3                   	ret    

00800f2a <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f2a:	55                   	push   %ebp
  800f2b:	89 e5                	mov    %esp,%ebp
  800f2d:	57                   	push   %edi
  800f2e:	56                   	push   %esi
  800f2f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f30:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f35:	8b 55 08             	mov    0x8(%ebp),%edx
  800f38:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f3d:	89 cb                	mov    %ecx,%ebx
  800f3f:	89 cf                	mov    %ecx,%edi
  800f41:	89 ce                	mov    %ecx,%esi
  800f43:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f45:	5b                   	pop    %ebx
  800f46:	5e                   	pop    %esi
  800f47:	5f                   	pop    %edi
  800f48:	5d                   	pop    %ebp
  800f49:	c3                   	ret    

00800f4a <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800f4a:	55                   	push   %ebp
  800f4b:	89 e5                	mov    %esp,%ebp
  800f4d:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800f50:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  800f57:	74 0a                	je     800f63 <set_pgfault_handler+0x19>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	a3 08 20 80 00       	mov    %eax,0x802008
}
  800f61:	c9                   	leave  
  800f62:	c3                   	ret    
		ret = sys_page_alloc((envid_t)0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W);
  800f63:	83 ec 04             	sub    $0x4,%esp
  800f66:	6a 07                	push   $0x7
  800f68:	68 00 f0 bf ee       	push   $0xeebff000
  800f6d:	6a 00                	push   $0x0
  800f6f:	e8 a4 fd ff ff       	call   800d18 <sys_page_alloc>
		if(ret < 0){
  800f74:	83 c4 10             	add    $0x10,%esp
  800f77:	85 c0                	test   %eax,%eax
  800f79:	78 28                	js     800fa3 <set_pgfault_handler+0x59>
    	ret = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  800f7b:	83 ec 08             	sub    $0x8,%esp
  800f7e:	68 b5 0f 80 00       	push   $0x800fb5
  800f83:	6a 00                	push   $0x0
  800f85:	e8 d9 fe ff ff       	call   800e63 <sys_env_set_pgfault_upcall>
		if(ret < 0){
  800f8a:	83 c4 10             	add    $0x10,%esp
  800f8d:	85 c0                	test   %eax,%eax
  800f8f:	79 c8                	jns    800f59 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
  800f91:	50                   	push   %eax
  800f92:	68 c0 16 80 00       	push   $0x8016c0
  800f97:	6a 28                	push   $0x28
  800f99:	68 00 17 80 00       	push   $0x801700
  800f9e:	e8 82 f1 ff ff       	call   800125 <_panic>
			panic("set_pgfault_handler: sys_page_alloc fail, ret:%d", ret);
  800fa3:	50                   	push   %eax
  800fa4:	68 8c 16 80 00       	push   $0x80168c
  800fa9:	6a 24                	push   $0x24
  800fab:	68 00 17 80 00       	push   $0x801700
  800fb0:	e8 70 f1 ff ff       	call   800125 <_panic>

00800fb5 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800fb5:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800fb6:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  800fbb:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800fbd:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edi
  800fc0:	8b 7c 24 28          	mov    0x28(%esp),%edi
	movl 0x30(%esp), %esi
  800fc4:	8b 74 24 30          	mov    0x30(%esp),%esi
	subl $4, %esi
  800fc8:	83 ee 04             	sub    $0x4,%esi
	movl %edi, (%esi)
  800fcb:	89 3e                	mov    %edi,(%esi)
	movl %esi, 0x30(%esp)
  800fcd:	89 74 24 30          	mov    %esi,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  800fd1:	83 c4 08             	add    $0x8,%esp
	popal
  800fd4:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  800fd5:	83 c4 04             	add    $0x4,%esp
	popfl
  800fd8:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  800fd9:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  800fda:	c3                   	ret    
  800fdb:	66 90                	xchg   %ax,%ax
  800fdd:	66 90                	xchg   %ax,%ax
  800fdf:	90                   	nop

00800fe0 <__udivdi3>:
  800fe0:	55                   	push   %ebp
  800fe1:	57                   	push   %edi
  800fe2:	56                   	push   %esi
  800fe3:	53                   	push   %ebx
  800fe4:	83 ec 1c             	sub    $0x1c,%esp
  800fe7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800feb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800fef:	8b 74 24 34          	mov    0x34(%esp),%esi
  800ff3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800ff7:	85 d2                	test   %edx,%edx
  800ff9:	75 4d                	jne    801048 <__udivdi3+0x68>
  800ffb:	39 f3                	cmp    %esi,%ebx
  800ffd:	76 19                	jbe    801018 <__udivdi3+0x38>
  800fff:	31 ff                	xor    %edi,%edi
  801001:	89 e8                	mov    %ebp,%eax
  801003:	89 f2                	mov    %esi,%edx
  801005:	f7 f3                	div    %ebx
  801007:	89 fa                	mov    %edi,%edx
  801009:	83 c4 1c             	add    $0x1c,%esp
  80100c:	5b                   	pop    %ebx
  80100d:	5e                   	pop    %esi
  80100e:	5f                   	pop    %edi
  80100f:	5d                   	pop    %ebp
  801010:	c3                   	ret    
  801011:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801018:	89 d9                	mov    %ebx,%ecx
  80101a:	85 db                	test   %ebx,%ebx
  80101c:	75 0b                	jne    801029 <__udivdi3+0x49>
  80101e:	b8 01 00 00 00       	mov    $0x1,%eax
  801023:	31 d2                	xor    %edx,%edx
  801025:	f7 f3                	div    %ebx
  801027:	89 c1                	mov    %eax,%ecx
  801029:	31 d2                	xor    %edx,%edx
  80102b:	89 f0                	mov    %esi,%eax
  80102d:	f7 f1                	div    %ecx
  80102f:	89 c6                	mov    %eax,%esi
  801031:	89 e8                	mov    %ebp,%eax
  801033:	89 f7                	mov    %esi,%edi
  801035:	f7 f1                	div    %ecx
  801037:	89 fa                	mov    %edi,%edx
  801039:	83 c4 1c             	add    $0x1c,%esp
  80103c:	5b                   	pop    %ebx
  80103d:	5e                   	pop    %esi
  80103e:	5f                   	pop    %edi
  80103f:	5d                   	pop    %ebp
  801040:	c3                   	ret    
  801041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801048:	39 f2                	cmp    %esi,%edx
  80104a:	77 1c                	ja     801068 <__udivdi3+0x88>
  80104c:	0f bd fa             	bsr    %edx,%edi
  80104f:	83 f7 1f             	xor    $0x1f,%edi
  801052:	75 2c                	jne    801080 <__udivdi3+0xa0>
  801054:	39 f2                	cmp    %esi,%edx
  801056:	72 06                	jb     80105e <__udivdi3+0x7e>
  801058:	31 c0                	xor    %eax,%eax
  80105a:	39 eb                	cmp    %ebp,%ebx
  80105c:	77 a9                	ja     801007 <__udivdi3+0x27>
  80105e:	b8 01 00 00 00       	mov    $0x1,%eax
  801063:	eb a2                	jmp    801007 <__udivdi3+0x27>
  801065:	8d 76 00             	lea    0x0(%esi),%esi
  801068:	31 ff                	xor    %edi,%edi
  80106a:	31 c0                	xor    %eax,%eax
  80106c:	89 fa                	mov    %edi,%edx
  80106e:	83 c4 1c             	add    $0x1c,%esp
  801071:	5b                   	pop    %ebx
  801072:	5e                   	pop    %esi
  801073:	5f                   	pop    %edi
  801074:	5d                   	pop    %ebp
  801075:	c3                   	ret    
  801076:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80107d:	8d 76 00             	lea    0x0(%esi),%esi
  801080:	89 f9                	mov    %edi,%ecx
  801082:	b8 20 00 00 00       	mov    $0x20,%eax
  801087:	29 f8                	sub    %edi,%eax
  801089:	d3 e2                	shl    %cl,%edx
  80108b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80108f:	89 c1                	mov    %eax,%ecx
  801091:	89 da                	mov    %ebx,%edx
  801093:	d3 ea                	shr    %cl,%edx
  801095:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801099:	09 d1                	or     %edx,%ecx
  80109b:	89 f2                	mov    %esi,%edx
  80109d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8010a1:	89 f9                	mov    %edi,%ecx
  8010a3:	d3 e3                	shl    %cl,%ebx
  8010a5:	89 c1                	mov    %eax,%ecx
  8010a7:	d3 ea                	shr    %cl,%edx
  8010a9:	89 f9                	mov    %edi,%ecx
  8010ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8010af:	89 eb                	mov    %ebp,%ebx
  8010b1:	d3 e6                	shl    %cl,%esi
  8010b3:	89 c1                	mov    %eax,%ecx
  8010b5:	d3 eb                	shr    %cl,%ebx
  8010b7:	09 de                	or     %ebx,%esi
  8010b9:	89 f0                	mov    %esi,%eax
  8010bb:	f7 74 24 08          	divl   0x8(%esp)
  8010bf:	89 d6                	mov    %edx,%esi
  8010c1:	89 c3                	mov    %eax,%ebx
  8010c3:	f7 64 24 0c          	mull   0xc(%esp)
  8010c7:	39 d6                	cmp    %edx,%esi
  8010c9:	72 15                	jb     8010e0 <__udivdi3+0x100>
  8010cb:	89 f9                	mov    %edi,%ecx
  8010cd:	d3 e5                	shl    %cl,%ebp
  8010cf:	39 c5                	cmp    %eax,%ebp
  8010d1:	73 04                	jae    8010d7 <__udivdi3+0xf7>
  8010d3:	39 d6                	cmp    %edx,%esi
  8010d5:	74 09                	je     8010e0 <__udivdi3+0x100>
  8010d7:	89 d8                	mov    %ebx,%eax
  8010d9:	31 ff                	xor    %edi,%edi
  8010db:	e9 27 ff ff ff       	jmp    801007 <__udivdi3+0x27>
  8010e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8010e3:	31 ff                	xor    %edi,%edi
  8010e5:	e9 1d ff ff ff       	jmp    801007 <__udivdi3+0x27>
  8010ea:	66 90                	xchg   %ax,%ax
  8010ec:	66 90                	xchg   %ax,%ax
  8010ee:	66 90                	xchg   %ax,%ax

008010f0 <__umoddi3>:
  8010f0:	55                   	push   %ebp
  8010f1:	57                   	push   %edi
  8010f2:	56                   	push   %esi
  8010f3:	53                   	push   %ebx
  8010f4:	83 ec 1c             	sub    $0x1c,%esp
  8010f7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8010fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8010ff:	8b 74 24 30          	mov    0x30(%esp),%esi
  801103:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801107:	89 da                	mov    %ebx,%edx
  801109:	85 c0                	test   %eax,%eax
  80110b:	75 43                	jne    801150 <__umoddi3+0x60>
  80110d:	39 df                	cmp    %ebx,%edi
  80110f:	76 17                	jbe    801128 <__umoddi3+0x38>
  801111:	89 f0                	mov    %esi,%eax
  801113:	f7 f7                	div    %edi
  801115:	89 d0                	mov    %edx,%eax
  801117:	31 d2                	xor    %edx,%edx
  801119:	83 c4 1c             	add    $0x1c,%esp
  80111c:	5b                   	pop    %ebx
  80111d:	5e                   	pop    %esi
  80111e:	5f                   	pop    %edi
  80111f:	5d                   	pop    %ebp
  801120:	c3                   	ret    
  801121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801128:	89 fd                	mov    %edi,%ebp
  80112a:	85 ff                	test   %edi,%edi
  80112c:	75 0b                	jne    801139 <__umoddi3+0x49>
  80112e:	b8 01 00 00 00       	mov    $0x1,%eax
  801133:	31 d2                	xor    %edx,%edx
  801135:	f7 f7                	div    %edi
  801137:	89 c5                	mov    %eax,%ebp
  801139:	89 d8                	mov    %ebx,%eax
  80113b:	31 d2                	xor    %edx,%edx
  80113d:	f7 f5                	div    %ebp
  80113f:	89 f0                	mov    %esi,%eax
  801141:	f7 f5                	div    %ebp
  801143:	89 d0                	mov    %edx,%eax
  801145:	eb d0                	jmp    801117 <__umoddi3+0x27>
  801147:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80114e:	66 90                	xchg   %ax,%ax
  801150:	89 f1                	mov    %esi,%ecx
  801152:	39 d8                	cmp    %ebx,%eax
  801154:	76 0a                	jbe    801160 <__umoddi3+0x70>
  801156:	89 f0                	mov    %esi,%eax
  801158:	83 c4 1c             	add    $0x1c,%esp
  80115b:	5b                   	pop    %ebx
  80115c:	5e                   	pop    %esi
  80115d:	5f                   	pop    %edi
  80115e:	5d                   	pop    %ebp
  80115f:	c3                   	ret    
  801160:	0f bd e8             	bsr    %eax,%ebp
  801163:	83 f5 1f             	xor    $0x1f,%ebp
  801166:	75 20                	jne    801188 <__umoddi3+0x98>
  801168:	39 d8                	cmp    %ebx,%eax
  80116a:	0f 82 b0 00 00 00    	jb     801220 <__umoddi3+0x130>
  801170:	39 f7                	cmp    %esi,%edi
  801172:	0f 86 a8 00 00 00    	jbe    801220 <__umoddi3+0x130>
  801178:	89 c8                	mov    %ecx,%eax
  80117a:	83 c4 1c             	add    $0x1c,%esp
  80117d:	5b                   	pop    %ebx
  80117e:	5e                   	pop    %esi
  80117f:	5f                   	pop    %edi
  801180:	5d                   	pop    %ebp
  801181:	c3                   	ret    
  801182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801188:	89 e9                	mov    %ebp,%ecx
  80118a:	ba 20 00 00 00       	mov    $0x20,%edx
  80118f:	29 ea                	sub    %ebp,%edx
  801191:	d3 e0                	shl    %cl,%eax
  801193:	89 44 24 08          	mov    %eax,0x8(%esp)
  801197:	89 d1                	mov    %edx,%ecx
  801199:	89 f8                	mov    %edi,%eax
  80119b:	d3 e8                	shr    %cl,%eax
  80119d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8011a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8011a5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8011a9:	09 c1                	or     %eax,%ecx
  8011ab:	89 d8                	mov    %ebx,%eax
  8011ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8011b1:	89 e9                	mov    %ebp,%ecx
  8011b3:	d3 e7                	shl    %cl,%edi
  8011b5:	89 d1                	mov    %edx,%ecx
  8011b7:	d3 e8                	shr    %cl,%eax
  8011b9:	89 e9                	mov    %ebp,%ecx
  8011bb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8011bf:	d3 e3                	shl    %cl,%ebx
  8011c1:	89 c7                	mov    %eax,%edi
  8011c3:	89 d1                	mov    %edx,%ecx
  8011c5:	89 f0                	mov    %esi,%eax
  8011c7:	d3 e8                	shr    %cl,%eax
  8011c9:	89 e9                	mov    %ebp,%ecx
  8011cb:	89 fa                	mov    %edi,%edx
  8011cd:	d3 e6                	shl    %cl,%esi
  8011cf:	09 d8                	or     %ebx,%eax
  8011d1:	f7 74 24 08          	divl   0x8(%esp)
  8011d5:	89 d1                	mov    %edx,%ecx
  8011d7:	89 f3                	mov    %esi,%ebx
  8011d9:	f7 64 24 0c          	mull   0xc(%esp)
  8011dd:	89 c6                	mov    %eax,%esi
  8011df:	89 d7                	mov    %edx,%edi
  8011e1:	39 d1                	cmp    %edx,%ecx
  8011e3:	72 06                	jb     8011eb <__umoddi3+0xfb>
  8011e5:	75 10                	jne    8011f7 <__umoddi3+0x107>
  8011e7:	39 c3                	cmp    %eax,%ebx
  8011e9:	73 0c                	jae    8011f7 <__umoddi3+0x107>
  8011eb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8011ef:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8011f3:	89 d7                	mov    %edx,%edi
  8011f5:	89 c6                	mov    %eax,%esi
  8011f7:	89 ca                	mov    %ecx,%edx
  8011f9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8011fe:	29 f3                	sub    %esi,%ebx
  801200:	19 fa                	sbb    %edi,%edx
  801202:	89 d0                	mov    %edx,%eax
  801204:	d3 e0                	shl    %cl,%eax
  801206:	89 e9                	mov    %ebp,%ecx
  801208:	d3 eb                	shr    %cl,%ebx
  80120a:	d3 ea                	shr    %cl,%edx
  80120c:	09 d8                	or     %ebx,%eax
  80120e:	83 c4 1c             	add    $0x1c,%esp
  801211:	5b                   	pop    %ebx
  801212:	5e                   	pop    %esi
  801213:	5f                   	pop    %edi
  801214:	5d                   	pop    %ebp
  801215:	c3                   	ret    
  801216:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80121d:	8d 76 00             	lea    0x0(%esi),%esi
  801220:	89 da                	mov    %ebx,%edx
  801222:	29 fe                	sub    %edi,%esi
  801224:	19 c2                	sbb    %eax,%edx
  801226:	89 f1                	mov    %esi,%ecx
  801228:	89 c8                	mov    %ecx,%eax
  80122a:	e9 4b ff ff ff       	jmp    80117a <__umoddi3+0x8a>
