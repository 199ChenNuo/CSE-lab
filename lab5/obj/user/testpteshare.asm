
obj/user/testpteshare.debug:     file format elf32-i386


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
  80002c:	e8 63 01 00 00       	call   800194 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <childofspawn>:
	breakpoint();
}

void
childofspawn(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	strcpy(VA, msg2);
  800039:	ff 35 00 40 80 00    	pushl  0x804000
  80003f:	68 00 00 00 a0       	push   $0xa0000000
  800044:	e8 a7 09 00 00       	call   8009f0 <strcpy>
	exit();
  800049:	e8 8f 01 00 00       	call   8001dd <exit>
}
  80004e:	83 c4 10             	add    $0x10,%esp
  800051:	c9                   	leave  
  800052:	c3                   	ret    

00800053 <umain>:
{
  800053:	55                   	push   %ebp
  800054:	89 e5                	mov    %esp,%ebp
  800056:	53                   	push   %ebx
  800057:	83 ec 04             	sub    $0x4,%esp
	if (argc != 0)
  80005a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80005e:	0f 85 d0 00 00 00    	jne    800134 <umain+0xe1>
	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800064:	83 ec 04             	sub    $0x4,%esp
  800067:	68 07 04 00 00       	push   $0x407
  80006c:	68 00 00 00 a0       	push   $0xa0000000
  800071:	6a 00                	push   $0x0
  800073:	e8 6a 0d 00 00       	call   800de2 <sys_page_alloc>
  800078:	83 c4 10             	add    $0x10,%esp
  80007b:	85 c0                	test   %eax,%eax
  80007d:	0f 88 bb 00 00 00    	js     80013e <umain+0xeb>
	if ((r = fork()) < 0)
  800083:	e8 88 10 00 00       	call   801110 <fork>
  800088:	89 c3                	mov    %eax,%ebx
  80008a:	85 c0                	test   %eax,%eax
  80008c:	0f 88 be 00 00 00    	js     800150 <umain+0xfd>
	if (r == 0) {
  800092:	0f 84 ca 00 00 00    	je     800162 <umain+0x10f>
	wait(r);
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	53                   	push   %ebx
  80009c:	e8 ef 18 00 00       	call   801990 <wait>
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	ff 35 04 40 80 00    	pushl  0x804004
  8000aa:	68 00 00 00 a0       	push   $0xa0000000
  8000af:	e8 e7 09 00 00       	call   800a9b <strcmp>
  8000b4:	83 c4 08             	add    $0x8,%esp
  8000b7:	85 c0                	test   %eax,%eax
  8000b9:	b8 80 2a 80 00       	mov    $0x802a80,%eax
  8000be:	ba 86 2a 80 00       	mov    $0x802a86,%edx
  8000c3:	0f 45 c2             	cmovne %edx,%eax
  8000c6:	50                   	push   %eax
  8000c7:	68 bc 2a 80 00       	push   $0x802abc
  8000cc:	e8 f9 01 00 00       	call   8002ca <cprintf>
	if ((r = spawnl("/testpteshare", "testpteshare", "arg", 0)) < 0)
  8000d1:	6a 00                	push   $0x0
  8000d3:	68 d7 2a 80 00       	push   $0x802ad7
  8000d8:	68 dc 2a 80 00       	push   $0x802adc
  8000dd:	68 db 2a 80 00       	push   $0x802adb
  8000e2:	e8 2c 18 00 00       	call   801913 <spawnl>
  8000e7:	83 c4 20             	add    $0x20,%esp
  8000ea:	85 c0                	test   %eax,%eax
  8000ec:	0f 88 90 00 00 00    	js     800182 <umain+0x12f>
	wait(r);
  8000f2:	83 ec 0c             	sub    $0xc,%esp
  8000f5:	50                   	push   %eax
  8000f6:	e8 95 18 00 00       	call   801990 <wait>
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  8000fb:	83 c4 08             	add    $0x8,%esp
  8000fe:	ff 35 00 40 80 00    	pushl  0x804000
  800104:	68 00 00 00 a0       	push   $0xa0000000
  800109:	e8 8d 09 00 00       	call   800a9b <strcmp>
  80010e:	83 c4 08             	add    $0x8,%esp
  800111:	85 c0                	test   %eax,%eax
  800113:	b8 80 2a 80 00       	mov    $0x802a80,%eax
  800118:	ba 86 2a 80 00       	mov    $0x802a86,%edx
  80011d:	0f 45 c2             	cmovne %edx,%eax
  800120:	50                   	push   %eax
  800121:	68 f3 2a 80 00       	push   $0x802af3
  800126:	e8 9f 01 00 00       	call   8002ca <cprintf>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  80012b:	cc                   	int3   
}
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800132:	c9                   	leave  
  800133:	c3                   	ret    
		childofspawn();
  800134:	e8 fa fe ff ff       	call   800033 <childofspawn>
  800139:	e9 26 ff ff ff       	jmp    800064 <umain+0x11>
		panic("sys_page_alloc: %e", r);
  80013e:	50                   	push   %eax
  80013f:	68 8c 2a 80 00       	push   $0x802a8c
  800144:	6a 13                	push   $0x13
  800146:	68 9f 2a 80 00       	push   $0x802a9f
  80014b:	e8 9f 00 00 00       	call   8001ef <_panic>
		panic("fork: %e", r);
  800150:	50                   	push   %eax
  800151:	68 b3 2a 80 00       	push   $0x802ab3
  800156:	6a 17                	push   $0x17
  800158:	68 9f 2a 80 00       	push   $0x802a9f
  80015d:	e8 8d 00 00 00       	call   8001ef <_panic>
		strcpy(VA, msg);
  800162:	83 ec 08             	sub    $0x8,%esp
  800165:	ff 35 04 40 80 00    	pushl  0x804004
  80016b:	68 00 00 00 a0       	push   $0xa0000000
  800170:	e8 7b 08 00 00       	call   8009f0 <strcpy>
		exit();
  800175:	e8 63 00 00 00       	call   8001dd <exit>
  80017a:	83 c4 10             	add    $0x10,%esp
  80017d:	e9 16 ff ff ff       	jmp    800098 <umain+0x45>
		panic("spawn: %e", r);
  800182:	50                   	push   %eax
  800183:	68 e9 2a 80 00       	push   $0x802ae9
  800188:	6a 21                	push   $0x21
  80018a:	68 9f 2a 80 00       	push   $0x802a9f
  80018f:	e8 5b 00 00 00       	call   8001ef <_panic>

00800194 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800194:	55                   	push   %ebp
  800195:	89 e5                	mov    %esp,%ebp
  800197:	56                   	push   %esi
  800198:	53                   	push   %ebx
  800199:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80019c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  80019f:	e8 00 0c 00 00       	call   800da4 <sys_getenvid>
  8001a4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001a9:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8001af:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001b4:	a3 04 50 80 00       	mov    %eax,0x805004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001b9:	85 db                	test   %ebx,%ebx
  8001bb:	7e 07                	jle    8001c4 <libmain+0x30>
		binaryname = argv[0];
  8001bd:	8b 06                	mov    (%esi),%eax
  8001bf:	a3 08 40 80 00       	mov    %eax,0x804008

	// call user main routine
	umain(argc, argv);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	56                   	push   %esi
  8001c8:	53                   	push   %ebx
  8001c9:	e8 85 fe ff ff       	call   800053 <umain>

	// exit gracefully
	exit();
  8001ce:	e8 0a 00 00 00       	call   8001dd <exit>
}
  8001d3:	83 c4 10             	add    $0x10,%esp
  8001d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001d9:	5b                   	pop    %ebx
  8001da:	5e                   	pop    %esi
  8001db:	5d                   	pop    %ebp
  8001dc:	c3                   	ret    

008001dd <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001dd:	55                   	push   %ebp
  8001de:	89 e5                	mov    %esp,%ebp
  8001e0:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8001e3:	6a 00                	push   $0x0
  8001e5:	e8 79 0b 00 00       	call   800d63 <sys_env_destroy>
}
  8001ea:	83 c4 10             	add    $0x10,%esp
  8001ed:	c9                   	leave  
  8001ee:	c3                   	ret    

008001ef <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001ef:	55                   	push   %ebp
  8001f0:	89 e5                	mov    %esp,%ebp
  8001f2:	56                   	push   %esi
  8001f3:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8001f4:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001f7:	8b 35 08 40 80 00    	mov    0x804008,%esi
  8001fd:	e8 a2 0b 00 00       	call   800da4 <sys_getenvid>
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	ff 75 0c             	pushl  0xc(%ebp)
  800208:	ff 75 08             	pushl  0x8(%ebp)
  80020b:	56                   	push   %esi
  80020c:	50                   	push   %eax
  80020d:	68 38 2b 80 00       	push   $0x802b38
  800212:	e8 b3 00 00 00       	call   8002ca <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800217:	83 c4 18             	add    $0x18,%esp
  80021a:	53                   	push   %ebx
  80021b:	ff 75 10             	pushl  0x10(%ebp)
  80021e:	e8 56 00 00 00       	call   800279 <vcprintf>
	cprintf("\n");
  800223:	c7 04 24 15 2f 80 00 	movl   $0x802f15,(%esp)
  80022a:	e8 9b 00 00 00       	call   8002ca <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800232:	cc                   	int3   
  800233:	eb fd                	jmp    800232 <_panic+0x43>

00800235 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800235:	55                   	push   %ebp
  800236:	89 e5                	mov    %esp,%ebp
  800238:	53                   	push   %ebx
  800239:	83 ec 04             	sub    $0x4,%esp
  80023c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80023f:	8b 13                	mov    (%ebx),%edx
  800241:	8d 42 01             	lea    0x1(%edx),%eax
  800244:	89 03                	mov    %eax,(%ebx)
  800246:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800249:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80024d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800252:	74 09                	je     80025d <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800254:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800258:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80025b:	c9                   	leave  
  80025c:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80025d:	83 ec 08             	sub    $0x8,%esp
  800260:	68 ff 00 00 00       	push   $0xff
  800265:	8d 43 08             	lea    0x8(%ebx),%eax
  800268:	50                   	push   %eax
  800269:	e8 b8 0a 00 00       	call   800d26 <sys_cputs>
		b->idx = 0;
  80026e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800274:	83 c4 10             	add    $0x10,%esp
  800277:	eb db                	jmp    800254 <putch+0x1f>

00800279 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800279:	55                   	push   %ebp
  80027a:	89 e5                	mov    %esp,%ebp
  80027c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800282:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800289:	00 00 00 
	b.cnt = 0;
  80028c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800293:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800296:	ff 75 0c             	pushl  0xc(%ebp)
  800299:	ff 75 08             	pushl  0x8(%ebp)
  80029c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002a2:	50                   	push   %eax
  8002a3:	68 35 02 80 00       	push   $0x800235
  8002a8:	e8 4a 01 00 00       	call   8003f7 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002ad:	83 c4 08             	add    $0x8,%esp
  8002b0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002b6:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002bc:	50                   	push   %eax
  8002bd:	e8 64 0a 00 00       	call   800d26 <sys_cputs>

	return b.cnt;
}
  8002c2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002c8:	c9                   	leave  
  8002c9:	c3                   	ret    

008002ca <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002ca:	55                   	push   %ebp
  8002cb:	89 e5                	mov    %esp,%ebp
  8002cd:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002d0:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002d3:	50                   	push   %eax
  8002d4:	ff 75 08             	pushl  0x8(%ebp)
  8002d7:	e8 9d ff ff ff       	call   800279 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002dc:	c9                   	leave  
  8002dd:	c3                   	ret    

008002de <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002de:	55                   	push   %ebp
  8002df:	89 e5                	mov    %esp,%ebp
  8002e1:	57                   	push   %edi
  8002e2:	56                   	push   %esi
  8002e3:	53                   	push   %ebx
  8002e4:	83 ec 1c             	sub    $0x1c,%esp
  8002e7:	89 c6                	mov    %eax,%esi
  8002e9:	89 d7                	mov    %edx,%edi
  8002eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002f4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8002f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8002fa:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  8002fd:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800301:	74 2c                	je     80032f <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800303:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800306:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80030d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800310:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800313:	39 c2                	cmp    %eax,%edx
  800315:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800318:	73 43                	jae    80035d <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80031a:	83 eb 01             	sub    $0x1,%ebx
  80031d:	85 db                	test   %ebx,%ebx
  80031f:	7e 6c                	jle    80038d <printnum+0xaf>
			putch(padc, putdat);
  800321:	83 ec 08             	sub    $0x8,%esp
  800324:	57                   	push   %edi
  800325:	ff 75 18             	pushl  0x18(%ebp)
  800328:	ff d6                	call   *%esi
  80032a:	83 c4 10             	add    $0x10,%esp
  80032d:	eb eb                	jmp    80031a <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80032f:	83 ec 0c             	sub    $0xc,%esp
  800332:	6a 20                	push   $0x20
  800334:	6a 00                	push   $0x0
  800336:	50                   	push   %eax
  800337:	ff 75 e4             	pushl  -0x1c(%ebp)
  80033a:	ff 75 e0             	pushl  -0x20(%ebp)
  80033d:	89 fa                	mov    %edi,%edx
  80033f:	89 f0                	mov    %esi,%eax
  800341:	e8 98 ff ff ff       	call   8002de <printnum>
		while (--width > 0)
  800346:	83 c4 20             	add    $0x20,%esp
  800349:	83 eb 01             	sub    $0x1,%ebx
  80034c:	85 db                	test   %ebx,%ebx
  80034e:	7e 65                	jle    8003b5 <printnum+0xd7>
			putch(' ', putdat);
  800350:	83 ec 08             	sub    $0x8,%esp
  800353:	57                   	push   %edi
  800354:	6a 20                	push   $0x20
  800356:	ff d6                	call   *%esi
  800358:	83 c4 10             	add    $0x10,%esp
  80035b:	eb ec                	jmp    800349 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80035d:	83 ec 0c             	sub    $0xc,%esp
  800360:	ff 75 18             	pushl  0x18(%ebp)
  800363:	83 eb 01             	sub    $0x1,%ebx
  800366:	53                   	push   %ebx
  800367:	50                   	push   %eax
  800368:	83 ec 08             	sub    $0x8,%esp
  80036b:	ff 75 dc             	pushl  -0x24(%ebp)
  80036e:	ff 75 d8             	pushl  -0x28(%ebp)
  800371:	ff 75 e4             	pushl  -0x1c(%ebp)
  800374:	ff 75 e0             	pushl  -0x20(%ebp)
  800377:	e8 b4 24 00 00       	call   802830 <__udivdi3>
  80037c:	83 c4 18             	add    $0x18,%esp
  80037f:	52                   	push   %edx
  800380:	50                   	push   %eax
  800381:	89 fa                	mov    %edi,%edx
  800383:	89 f0                	mov    %esi,%eax
  800385:	e8 54 ff ff ff       	call   8002de <printnum>
  80038a:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80038d:	83 ec 08             	sub    $0x8,%esp
  800390:	57                   	push   %edi
  800391:	83 ec 04             	sub    $0x4,%esp
  800394:	ff 75 dc             	pushl  -0x24(%ebp)
  800397:	ff 75 d8             	pushl  -0x28(%ebp)
  80039a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80039d:	ff 75 e0             	pushl  -0x20(%ebp)
  8003a0:	e8 9b 25 00 00       	call   802940 <__umoddi3>
  8003a5:	83 c4 14             	add    $0x14,%esp
  8003a8:	0f be 80 5b 2b 80 00 	movsbl 0x802b5b(%eax),%eax
  8003af:	50                   	push   %eax
  8003b0:	ff d6                	call   *%esi
  8003b2:	83 c4 10             	add    $0x10,%esp
}
  8003b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003b8:	5b                   	pop    %ebx
  8003b9:	5e                   	pop    %esi
  8003ba:	5f                   	pop    %edi
  8003bb:	5d                   	pop    %ebp
  8003bc:	c3                   	ret    

008003bd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003bd:	55                   	push   %ebp
  8003be:	89 e5                	mov    %esp,%ebp
  8003c0:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003c3:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003c7:	8b 10                	mov    (%eax),%edx
  8003c9:	3b 50 04             	cmp    0x4(%eax),%edx
  8003cc:	73 0a                	jae    8003d8 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003ce:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003d1:	89 08                	mov    %ecx,(%eax)
  8003d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d6:	88 02                	mov    %al,(%edx)
}
  8003d8:	5d                   	pop    %ebp
  8003d9:	c3                   	ret    

008003da <printfmt>:
{
  8003da:	55                   	push   %ebp
  8003db:	89 e5                	mov    %esp,%ebp
  8003dd:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003e0:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003e3:	50                   	push   %eax
  8003e4:	ff 75 10             	pushl  0x10(%ebp)
  8003e7:	ff 75 0c             	pushl  0xc(%ebp)
  8003ea:	ff 75 08             	pushl  0x8(%ebp)
  8003ed:	e8 05 00 00 00       	call   8003f7 <vprintfmt>
}
  8003f2:	83 c4 10             	add    $0x10,%esp
  8003f5:	c9                   	leave  
  8003f6:	c3                   	ret    

008003f7 <vprintfmt>:
{
  8003f7:	55                   	push   %ebp
  8003f8:	89 e5                	mov    %esp,%ebp
  8003fa:	57                   	push   %edi
  8003fb:	56                   	push   %esi
  8003fc:	53                   	push   %ebx
  8003fd:	83 ec 3c             	sub    $0x3c,%esp
  800400:	8b 75 08             	mov    0x8(%ebp),%esi
  800403:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800406:	8b 7d 10             	mov    0x10(%ebp),%edi
  800409:	e9 1e 04 00 00       	jmp    80082c <vprintfmt+0x435>
		posflag = 0;
  80040e:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  800415:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800419:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800420:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800427:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80042e:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  800435:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80043a:	8d 47 01             	lea    0x1(%edi),%eax
  80043d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800440:	0f b6 17             	movzbl (%edi),%edx
  800443:	8d 42 dd             	lea    -0x23(%edx),%eax
  800446:	3c 55                	cmp    $0x55,%al
  800448:	0f 87 d9 04 00 00    	ja     800927 <vprintfmt+0x530>
  80044e:	0f b6 c0             	movzbl %al,%eax
  800451:	ff 24 85 40 2d 80 00 	jmp    *0x802d40(,%eax,4)
  800458:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80045b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80045f:	eb d9                	jmp    80043a <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800461:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  800464:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  80046b:	eb cd                	jmp    80043a <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80046d:	0f b6 d2             	movzbl %dl,%edx
  800470:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800473:	b8 00 00 00 00       	mov    $0x0,%eax
  800478:	89 75 08             	mov    %esi,0x8(%ebp)
  80047b:	eb 0c                	jmp    800489 <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  80047d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800480:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  800484:	eb b4                	jmp    80043a <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  800486:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800489:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80048c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800490:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800493:	8d 72 d0             	lea    -0x30(%edx),%esi
  800496:	83 fe 09             	cmp    $0x9,%esi
  800499:	76 eb                	jbe    800486 <vprintfmt+0x8f>
  80049b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80049e:	8b 75 08             	mov    0x8(%ebp),%esi
  8004a1:	eb 14                	jmp    8004b7 <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  8004a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a6:	8b 00                	mov    (%eax),%eax
  8004a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ae:	8d 40 04             	lea    0x4(%eax),%eax
  8004b1:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004b4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004b7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004bb:	0f 89 79 ff ff ff    	jns    80043a <vprintfmt+0x43>
				width = precision, precision = -1;
  8004c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004c7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004ce:	e9 67 ff ff ff       	jmp    80043a <vprintfmt+0x43>
  8004d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004d6:	85 c0                	test   %eax,%eax
  8004d8:	0f 48 c1             	cmovs  %ecx,%eax
  8004db:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004de:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004e1:	e9 54 ff ff ff       	jmp    80043a <vprintfmt+0x43>
  8004e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004e9:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8004f0:	e9 45 ff ff ff       	jmp    80043a <vprintfmt+0x43>
			lflag++;
  8004f5:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004fc:	e9 39 ff ff ff       	jmp    80043a <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800501:	8b 45 14             	mov    0x14(%ebp),%eax
  800504:	8d 78 04             	lea    0x4(%eax),%edi
  800507:	83 ec 08             	sub    $0x8,%esp
  80050a:	53                   	push   %ebx
  80050b:	ff 30                	pushl  (%eax)
  80050d:	ff d6                	call   *%esi
			break;
  80050f:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800512:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800515:	e9 0f 03 00 00       	jmp    800829 <vprintfmt+0x432>
			err = va_arg(ap, int);
  80051a:	8b 45 14             	mov    0x14(%ebp),%eax
  80051d:	8d 78 04             	lea    0x4(%eax),%edi
  800520:	8b 00                	mov    (%eax),%eax
  800522:	99                   	cltd   
  800523:	31 d0                	xor    %edx,%eax
  800525:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800527:	83 f8 0f             	cmp    $0xf,%eax
  80052a:	7f 23                	jg     80054f <vprintfmt+0x158>
  80052c:	8b 14 85 a0 2e 80 00 	mov    0x802ea0(,%eax,4),%edx
  800533:	85 d2                	test   %edx,%edx
  800535:	74 18                	je     80054f <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  800537:	52                   	push   %edx
  800538:	68 1b 31 80 00       	push   $0x80311b
  80053d:	53                   	push   %ebx
  80053e:	56                   	push   %esi
  80053f:	e8 96 fe ff ff       	call   8003da <printfmt>
  800544:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800547:	89 7d 14             	mov    %edi,0x14(%ebp)
  80054a:	e9 da 02 00 00       	jmp    800829 <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  80054f:	50                   	push   %eax
  800550:	68 73 2b 80 00       	push   $0x802b73
  800555:	53                   	push   %ebx
  800556:	56                   	push   %esi
  800557:	e8 7e fe ff ff       	call   8003da <printfmt>
  80055c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80055f:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800562:	e9 c2 02 00 00       	jmp    800829 <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  800567:	8b 45 14             	mov    0x14(%ebp),%eax
  80056a:	83 c0 04             	add    $0x4,%eax
  80056d:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800570:	8b 45 14             	mov    0x14(%ebp),%eax
  800573:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800575:	85 c9                	test   %ecx,%ecx
  800577:	b8 6c 2b 80 00       	mov    $0x802b6c,%eax
  80057c:	0f 45 c1             	cmovne %ecx,%eax
  80057f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800582:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800586:	7e 06                	jle    80058e <vprintfmt+0x197>
  800588:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80058c:	75 0d                	jne    80059b <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  80058e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800591:	89 c7                	mov    %eax,%edi
  800593:	03 45 e0             	add    -0x20(%ebp),%eax
  800596:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800599:	eb 53                	jmp    8005ee <vprintfmt+0x1f7>
  80059b:	83 ec 08             	sub    $0x8,%esp
  80059e:	ff 75 d8             	pushl  -0x28(%ebp)
  8005a1:	50                   	push   %eax
  8005a2:	e8 28 04 00 00       	call   8009cf <strnlen>
  8005a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005aa:	29 c1                	sub    %eax,%ecx
  8005ac:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  8005af:	83 c4 10             	add    $0x10,%esp
  8005b2:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8005b4:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8005b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005bb:	eb 0f                	jmp    8005cc <vprintfmt+0x1d5>
					putch(padc, putdat);
  8005bd:	83 ec 08             	sub    $0x8,%esp
  8005c0:	53                   	push   %ebx
  8005c1:	ff 75 e0             	pushl  -0x20(%ebp)
  8005c4:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c6:	83 ef 01             	sub    $0x1,%edi
  8005c9:	83 c4 10             	add    $0x10,%esp
  8005cc:	85 ff                	test   %edi,%edi
  8005ce:	7f ed                	jg     8005bd <vprintfmt+0x1c6>
  8005d0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  8005d3:	85 c9                	test   %ecx,%ecx
  8005d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8005da:	0f 49 c1             	cmovns %ecx,%eax
  8005dd:	29 c1                	sub    %eax,%ecx
  8005df:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005e2:	eb aa                	jmp    80058e <vprintfmt+0x197>
					putch(ch, putdat);
  8005e4:	83 ec 08             	sub    $0x8,%esp
  8005e7:	53                   	push   %ebx
  8005e8:	52                   	push   %edx
  8005e9:	ff d6                	call   *%esi
  8005eb:	83 c4 10             	add    $0x10,%esp
  8005ee:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005f1:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005f3:	83 c7 01             	add    $0x1,%edi
  8005f6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005fa:	0f be d0             	movsbl %al,%edx
  8005fd:	85 d2                	test   %edx,%edx
  8005ff:	74 4b                	je     80064c <vprintfmt+0x255>
  800601:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800605:	78 06                	js     80060d <vprintfmt+0x216>
  800607:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80060b:	78 1e                	js     80062b <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  80060d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800611:	74 d1                	je     8005e4 <vprintfmt+0x1ed>
  800613:	0f be c0             	movsbl %al,%eax
  800616:	83 e8 20             	sub    $0x20,%eax
  800619:	83 f8 5e             	cmp    $0x5e,%eax
  80061c:	76 c6                	jbe    8005e4 <vprintfmt+0x1ed>
					putch('?', putdat);
  80061e:	83 ec 08             	sub    $0x8,%esp
  800621:	53                   	push   %ebx
  800622:	6a 3f                	push   $0x3f
  800624:	ff d6                	call   *%esi
  800626:	83 c4 10             	add    $0x10,%esp
  800629:	eb c3                	jmp    8005ee <vprintfmt+0x1f7>
  80062b:	89 cf                	mov    %ecx,%edi
  80062d:	eb 0e                	jmp    80063d <vprintfmt+0x246>
				putch(' ', putdat);
  80062f:	83 ec 08             	sub    $0x8,%esp
  800632:	53                   	push   %ebx
  800633:	6a 20                	push   $0x20
  800635:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800637:	83 ef 01             	sub    $0x1,%edi
  80063a:	83 c4 10             	add    $0x10,%esp
  80063d:	85 ff                	test   %edi,%edi
  80063f:	7f ee                	jg     80062f <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  800641:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800644:	89 45 14             	mov    %eax,0x14(%ebp)
  800647:	e9 dd 01 00 00       	jmp    800829 <vprintfmt+0x432>
  80064c:	89 cf                	mov    %ecx,%edi
  80064e:	eb ed                	jmp    80063d <vprintfmt+0x246>
	if (lflag >= 2)
  800650:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800654:	7f 21                	jg     800677 <vprintfmt+0x280>
	else if (lflag)
  800656:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80065a:	74 6a                	je     8006c6 <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8b 00                	mov    (%eax),%eax
  800661:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800664:	89 c1                	mov    %eax,%ecx
  800666:	c1 f9 1f             	sar    $0x1f,%ecx
  800669:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	8d 40 04             	lea    0x4(%eax),%eax
  800672:	89 45 14             	mov    %eax,0x14(%ebp)
  800675:	eb 17                	jmp    80068e <vprintfmt+0x297>
		return va_arg(*ap, long long);
  800677:	8b 45 14             	mov    0x14(%ebp),%eax
  80067a:	8b 50 04             	mov    0x4(%eax),%edx
  80067d:	8b 00                	mov    (%eax),%eax
  80067f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800682:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800685:	8b 45 14             	mov    0x14(%ebp),%eax
  800688:	8d 40 08             	lea    0x8(%eax),%eax
  80068b:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80068e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800691:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  800696:	85 d2                	test   %edx,%edx
  800698:	0f 89 5c 01 00 00    	jns    8007fa <vprintfmt+0x403>
				putch('-', putdat);
  80069e:	83 ec 08             	sub    $0x8,%esp
  8006a1:	53                   	push   %ebx
  8006a2:	6a 2d                	push   $0x2d
  8006a4:	ff d6                	call   *%esi
				num = -(long long) num;
  8006a6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006a9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006ac:	f7 d8                	neg    %eax
  8006ae:	83 d2 00             	adc    $0x0,%edx
  8006b1:	f7 da                	neg    %edx
  8006b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b9:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006bc:	bf 0a 00 00 00       	mov    $0xa,%edi
  8006c1:	e9 45 01 00 00       	jmp    80080b <vprintfmt+0x414>
		return va_arg(*ap, int);
  8006c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c9:	8b 00                	mov    (%eax),%eax
  8006cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ce:	89 c1                	mov    %eax,%ecx
  8006d0:	c1 f9 1f             	sar    $0x1f,%ecx
  8006d3:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d9:	8d 40 04             	lea    0x4(%eax),%eax
  8006dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8006df:	eb ad                	jmp    80068e <vprintfmt+0x297>
	if (lflag >= 2)
  8006e1:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8006e5:	7f 29                	jg     800710 <vprintfmt+0x319>
	else if (lflag)
  8006e7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8006eb:	74 44                	je     800731 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  8006ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f0:	8b 00                	mov    (%eax),%eax
  8006f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800700:	8d 40 04             	lea    0x4(%eax),%eax
  800703:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800706:	bf 0a 00 00 00       	mov    $0xa,%edi
  80070b:	e9 ea 00 00 00       	jmp    8007fa <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800710:	8b 45 14             	mov    0x14(%ebp),%eax
  800713:	8b 50 04             	mov    0x4(%eax),%edx
  800716:	8b 00                	mov    (%eax),%eax
  800718:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80071b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80071e:	8b 45 14             	mov    0x14(%ebp),%eax
  800721:	8d 40 08             	lea    0x8(%eax),%eax
  800724:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800727:	bf 0a 00 00 00       	mov    $0xa,%edi
  80072c:	e9 c9 00 00 00       	jmp    8007fa <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800731:	8b 45 14             	mov    0x14(%ebp),%eax
  800734:	8b 00                	mov    (%eax),%eax
  800736:	ba 00 00 00 00       	mov    $0x0,%edx
  80073b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800741:	8b 45 14             	mov    0x14(%ebp),%eax
  800744:	8d 40 04             	lea    0x4(%eax),%eax
  800747:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80074a:	bf 0a 00 00 00       	mov    $0xa,%edi
  80074f:	e9 a6 00 00 00       	jmp    8007fa <vprintfmt+0x403>
			putch('0', putdat);
  800754:	83 ec 08             	sub    $0x8,%esp
  800757:	53                   	push   %ebx
  800758:	6a 30                	push   $0x30
  80075a:	ff d6                	call   *%esi
	if (lflag >= 2)
  80075c:	83 c4 10             	add    $0x10,%esp
  80075f:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800763:	7f 26                	jg     80078b <vprintfmt+0x394>
	else if (lflag)
  800765:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800769:	74 3e                	je     8007a9 <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  80076b:	8b 45 14             	mov    0x14(%ebp),%eax
  80076e:	8b 00                	mov    (%eax),%eax
  800770:	ba 00 00 00 00       	mov    $0x0,%edx
  800775:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800778:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80077b:	8b 45 14             	mov    0x14(%ebp),%eax
  80077e:	8d 40 04             	lea    0x4(%eax),%eax
  800781:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800784:	bf 08 00 00 00       	mov    $0x8,%edi
  800789:	eb 6f                	jmp    8007fa <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  80078b:	8b 45 14             	mov    0x14(%ebp),%eax
  80078e:	8b 50 04             	mov    0x4(%eax),%edx
  800791:	8b 00                	mov    (%eax),%eax
  800793:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800796:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800799:	8b 45 14             	mov    0x14(%ebp),%eax
  80079c:	8d 40 08             	lea    0x8(%eax),%eax
  80079f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007a2:	bf 08 00 00 00       	mov    $0x8,%edi
  8007a7:	eb 51                	jmp    8007fa <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8007a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ac:	8b 00                	mov    (%eax),%eax
  8007ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bc:	8d 40 04             	lea    0x4(%eax),%eax
  8007bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007c2:	bf 08 00 00 00       	mov    $0x8,%edi
  8007c7:	eb 31                	jmp    8007fa <vprintfmt+0x403>
			putch('0', putdat);
  8007c9:	83 ec 08             	sub    $0x8,%esp
  8007cc:	53                   	push   %ebx
  8007cd:	6a 30                	push   $0x30
  8007cf:	ff d6                	call   *%esi
			putch('x', putdat);
  8007d1:	83 c4 08             	add    $0x8,%esp
  8007d4:	53                   	push   %ebx
  8007d5:	6a 78                	push   $0x78
  8007d7:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dc:	8b 00                	mov    (%eax),%eax
  8007de:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e6:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007e9:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ef:	8d 40 04             	lea    0x4(%eax),%eax
  8007f2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f5:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  8007fa:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007fe:	74 0b                	je     80080b <vprintfmt+0x414>
				putch('+', putdat);
  800800:	83 ec 08             	sub    $0x8,%esp
  800803:	53                   	push   %ebx
  800804:	6a 2b                	push   $0x2b
  800806:	ff d6                	call   *%esi
  800808:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  80080b:	83 ec 0c             	sub    $0xc,%esp
  80080e:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800812:	50                   	push   %eax
  800813:	ff 75 e0             	pushl  -0x20(%ebp)
  800816:	57                   	push   %edi
  800817:	ff 75 dc             	pushl  -0x24(%ebp)
  80081a:	ff 75 d8             	pushl  -0x28(%ebp)
  80081d:	89 da                	mov    %ebx,%edx
  80081f:	89 f0                	mov    %esi,%eax
  800821:	e8 b8 fa ff ff       	call   8002de <printnum>
			break;
  800826:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  800829:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80082c:	83 c7 01             	add    $0x1,%edi
  80082f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800833:	83 f8 25             	cmp    $0x25,%eax
  800836:	0f 84 d2 fb ff ff    	je     80040e <vprintfmt+0x17>
			if (ch == '\0')
  80083c:	85 c0                	test   %eax,%eax
  80083e:	0f 84 03 01 00 00    	je     800947 <vprintfmt+0x550>
			putch(ch, putdat);
  800844:	83 ec 08             	sub    $0x8,%esp
  800847:	53                   	push   %ebx
  800848:	50                   	push   %eax
  800849:	ff d6                	call   *%esi
  80084b:	83 c4 10             	add    $0x10,%esp
  80084e:	eb dc                	jmp    80082c <vprintfmt+0x435>
	if (lflag >= 2)
  800850:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  800854:	7f 29                	jg     80087f <vprintfmt+0x488>
	else if (lflag)
  800856:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80085a:	74 44                	je     8008a0 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  80085c:	8b 45 14             	mov    0x14(%ebp),%eax
  80085f:	8b 00                	mov    (%eax),%eax
  800861:	ba 00 00 00 00       	mov    $0x0,%edx
  800866:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800869:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80086c:	8b 45 14             	mov    0x14(%ebp),%eax
  80086f:	8d 40 04             	lea    0x4(%eax),%eax
  800872:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800875:	bf 10 00 00 00       	mov    $0x10,%edi
  80087a:	e9 7b ff ff ff       	jmp    8007fa <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	8b 50 04             	mov    0x4(%eax),%edx
  800885:	8b 00                	mov    (%eax),%eax
  800887:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80088a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80088d:	8b 45 14             	mov    0x14(%ebp),%eax
  800890:	8d 40 08             	lea    0x8(%eax),%eax
  800893:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800896:	bf 10 00 00 00       	mov    $0x10,%edi
  80089b:	e9 5a ff ff ff       	jmp    8007fa <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8008a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a3:	8b 00                	mov    (%eax),%eax
  8008a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8008aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008ad:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b3:	8d 40 04             	lea    0x4(%eax),%eax
  8008b6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008b9:	bf 10 00 00 00       	mov    $0x10,%edi
  8008be:	e9 37 ff ff ff       	jmp    8007fa <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  8008c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c6:	8d 78 04             	lea    0x4(%eax),%edi
  8008c9:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  8008cb:	85 c0                	test   %eax,%eax
  8008cd:	74 2c                	je     8008fb <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  8008cf:	8b 13                	mov    (%ebx),%edx
  8008d1:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  8008d3:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  8008d6:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  8008d9:	0f 8e 4a ff ff ff    	jle    800829 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  8008df:	68 c8 2c 80 00       	push   $0x802cc8
  8008e4:	68 1b 31 80 00       	push   $0x80311b
  8008e9:	53                   	push   %ebx
  8008ea:	56                   	push   %esi
  8008eb:	e8 ea fa ff ff       	call   8003da <printfmt>
  8008f0:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  8008f3:	89 7d 14             	mov    %edi,0x14(%ebp)
  8008f6:	e9 2e ff ff ff       	jmp    800829 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  8008fb:	68 90 2c 80 00       	push   $0x802c90
  800900:	68 1b 31 80 00       	push   $0x80311b
  800905:	53                   	push   %ebx
  800906:	56                   	push   %esi
  800907:	e8 ce fa ff ff       	call   8003da <printfmt>
        		break;
  80090c:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  80090f:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  800912:	e9 12 ff ff ff       	jmp    800829 <vprintfmt+0x432>
			putch(ch, putdat);
  800917:	83 ec 08             	sub    $0x8,%esp
  80091a:	53                   	push   %ebx
  80091b:	6a 25                	push   $0x25
  80091d:	ff d6                	call   *%esi
			break;
  80091f:	83 c4 10             	add    $0x10,%esp
  800922:	e9 02 ff ff ff       	jmp    800829 <vprintfmt+0x432>
			putch('%', putdat);
  800927:	83 ec 08             	sub    $0x8,%esp
  80092a:	53                   	push   %ebx
  80092b:	6a 25                	push   $0x25
  80092d:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80092f:	83 c4 10             	add    $0x10,%esp
  800932:	89 f8                	mov    %edi,%eax
  800934:	eb 03                	jmp    800939 <vprintfmt+0x542>
  800936:	83 e8 01             	sub    $0x1,%eax
  800939:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80093d:	75 f7                	jne    800936 <vprintfmt+0x53f>
  80093f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800942:	e9 e2 fe ff ff       	jmp    800829 <vprintfmt+0x432>
}
  800947:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80094a:	5b                   	pop    %ebx
  80094b:	5e                   	pop    %esi
  80094c:	5f                   	pop    %edi
  80094d:	5d                   	pop    %ebp
  80094e:	c3                   	ret    

0080094f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80094f:	55                   	push   %ebp
  800950:	89 e5                	mov    %esp,%ebp
  800952:	83 ec 18             	sub    $0x18,%esp
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80095b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80095e:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800962:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800965:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80096c:	85 c0                	test   %eax,%eax
  80096e:	74 26                	je     800996 <vsnprintf+0x47>
  800970:	85 d2                	test   %edx,%edx
  800972:	7e 22                	jle    800996 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800974:	ff 75 14             	pushl  0x14(%ebp)
  800977:	ff 75 10             	pushl  0x10(%ebp)
  80097a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80097d:	50                   	push   %eax
  80097e:	68 bd 03 80 00       	push   $0x8003bd
  800983:	e8 6f fa ff ff       	call   8003f7 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800988:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80098b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80098e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800991:	83 c4 10             	add    $0x10,%esp
}
  800994:	c9                   	leave  
  800995:	c3                   	ret    
		return -E_INVAL;
  800996:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80099b:	eb f7                	jmp    800994 <vsnprintf+0x45>

0080099d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80099d:	55                   	push   %ebp
  80099e:	89 e5                	mov    %esp,%ebp
  8009a0:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009a3:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009a6:	50                   	push   %eax
  8009a7:	ff 75 10             	pushl  0x10(%ebp)
  8009aa:	ff 75 0c             	pushl  0xc(%ebp)
  8009ad:	ff 75 08             	pushl  0x8(%ebp)
  8009b0:	e8 9a ff ff ff       	call   80094f <vsnprintf>
	va_end(ap);

	return rc;
}
  8009b5:	c9                   	leave  
  8009b6:	c3                   	ret    

008009b7 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8009c2:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009c6:	74 05                	je     8009cd <strlen+0x16>
		n++;
  8009c8:	83 c0 01             	add    $0x1,%eax
  8009cb:	eb f5                	jmp    8009c2 <strlen+0xb>
	return n;
}
  8009cd:	5d                   	pop    %ebp
  8009ce:	c3                   	ret    

008009cf <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009cf:	55                   	push   %ebp
  8009d0:	89 e5                	mov    %esp,%ebp
  8009d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009d5:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8009dd:	39 c2                	cmp    %eax,%edx
  8009df:	74 0d                	je     8009ee <strnlen+0x1f>
  8009e1:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8009e5:	74 05                	je     8009ec <strnlen+0x1d>
		n++;
  8009e7:	83 c2 01             	add    $0x1,%edx
  8009ea:	eb f1                	jmp    8009dd <strnlen+0xe>
  8009ec:	89 d0                	mov    %edx,%eax
	return n;
}
  8009ee:	5d                   	pop    %ebp
  8009ef:	c3                   	ret    

008009f0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009f0:	55                   	push   %ebp
  8009f1:	89 e5                	mov    %esp,%ebp
  8009f3:	53                   	push   %ebx
  8009f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ff:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a03:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a06:	83 c2 01             	add    $0x1,%edx
  800a09:	84 c9                	test   %cl,%cl
  800a0b:	75 f2                	jne    8009ff <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a0d:	5b                   	pop    %ebx
  800a0e:	5d                   	pop    %ebp
  800a0f:	c3                   	ret    

00800a10 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a10:	55                   	push   %ebp
  800a11:	89 e5                	mov    %esp,%ebp
  800a13:	53                   	push   %ebx
  800a14:	83 ec 10             	sub    $0x10,%esp
  800a17:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a1a:	53                   	push   %ebx
  800a1b:	e8 97 ff ff ff       	call   8009b7 <strlen>
  800a20:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a23:	ff 75 0c             	pushl  0xc(%ebp)
  800a26:	01 d8                	add    %ebx,%eax
  800a28:	50                   	push   %eax
  800a29:	e8 c2 ff ff ff       	call   8009f0 <strcpy>
	return dst;
}
  800a2e:	89 d8                	mov    %ebx,%eax
  800a30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a33:	c9                   	leave  
  800a34:	c3                   	ret    

00800a35 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a35:	55                   	push   %ebp
  800a36:	89 e5                	mov    %esp,%ebp
  800a38:	56                   	push   %esi
  800a39:	53                   	push   %ebx
  800a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a40:	89 c6                	mov    %eax,%esi
  800a42:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a45:	89 c2                	mov    %eax,%edx
  800a47:	39 f2                	cmp    %esi,%edx
  800a49:	74 11                	je     800a5c <strncpy+0x27>
		*dst++ = *src;
  800a4b:	83 c2 01             	add    $0x1,%edx
  800a4e:	0f b6 19             	movzbl (%ecx),%ebx
  800a51:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a54:	80 fb 01             	cmp    $0x1,%bl
  800a57:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a5a:	eb eb                	jmp    800a47 <strncpy+0x12>
	}
	return ret;
}
  800a5c:	5b                   	pop    %ebx
  800a5d:	5e                   	pop    %esi
  800a5e:	5d                   	pop    %ebp
  800a5f:	c3                   	ret    

00800a60 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
  800a63:	56                   	push   %esi
  800a64:	53                   	push   %ebx
  800a65:	8b 75 08             	mov    0x8(%ebp),%esi
  800a68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a6b:	8b 55 10             	mov    0x10(%ebp),%edx
  800a6e:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a70:	85 d2                	test   %edx,%edx
  800a72:	74 21                	je     800a95 <strlcpy+0x35>
  800a74:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a78:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a7a:	39 c2                	cmp    %eax,%edx
  800a7c:	74 14                	je     800a92 <strlcpy+0x32>
  800a7e:	0f b6 19             	movzbl (%ecx),%ebx
  800a81:	84 db                	test   %bl,%bl
  800a83:	74 0b                	je     800a90 <strlcpy+0x30>
			*dst++ = *src++;
  800a85:	83 c1 01             	add    $0x1,%ecx
  800a88:	83 c2 01             	add    $0x1,%edx
  800a8b:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a8e:	eb ea                	jmp    800a7a <strlcpy+0x1a>
  800a90:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a92:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a95:	29 f0                	sub    %esi,%eax
}
  800a97:	5b                   	pop    %ebx
  800a98:	5e                   	pop    %esi
  800a99:	5d                   	pop    %ebp
  800a9a:	c3                   	ret    

00800a9b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a9b:	55                   	push   %ebp
  800a9c:	89 e5                	mov    %esp,%ebp
  800a9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aa1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800aa4:	0f b6 01             	movzbl (%ecx),%eax
  800aa7:	84 c0                	test   %al,%al
  800aa9:	74 0c                	je     800ab7 <strcmp+0x1c>
  800aab:	3a 02                	cmp    (%edx),%al
  800aad:	75 08                	jne    800ab7 <strcmp+0x1c>
		p++, q++;
  800aaf:	83 c1 01             	add    $0x1,%ecx
  800ab2:	83 c2 01             	add    $0x1,%edx
  800ab5:	eb ed                	jmp    800aa4 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ab7:	0f b6 c0             	movzbl %al,%eax
  800aba:	0f b6 12             	movzbl (%edx),%edx
  800abd:	29 d0                	sub    %edx,%eax
}
  800abf:	5d                   	pop    %ebp
  800ac0:	c3                   	ret    

00800ac1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ac1:	55                   	push   %ebp
  800ac2:	89 e5                	mov    %esp,%ebp
  800ac4:	53                   	push   %ebx
  800ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800acb:	89 c3                	mov    %eax,%ebx
  800acd:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ad0:	eb 06                	jmp    800ad8 <strncmp+0x17>
		n--, p++, q++;
  800ad2:	83 c0 01             	add    $0x1,%eax
  800ad5:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ad8:	39 d8                	cmp    %ebx,%eax
  800ada:	74 16                	je     800af2 <strncmp+0x31>
  800adc:	0f b6 08             	movzbl (%eax),%ecx
  800adf:	84 c9                	test   %cl,%cl
  800ae1:	74 04                	je     800ae7 <strncmp+0x26>
  800ae3:	3a 0a                	cmp    (%edx),%cl
  800ae5:	74 eb                	je     800ad2 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ae7:	0f b6 00             	movzbl (%eax),%eax
  800aea:	0f b6 12             	movzbl (%edx),%edx
  800aed:	29 d0                	sub    %edx,%eax
}
  800aef:	5b                   	pop    %ebx
  800af0:	5d                   	pop    %ebp
  800af1:	c3                   	ret    
		return 0;
  800af2:	b8 00 00 00 00       	mov    $0x0,%eax
  800af7:	eb f6                	jmp    800aef <strncmp+0x2e>

00800af9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800af9:	55                   	push   %ebp
  800afa:	89 e5                	mov    %esp,%ebp
  800afc:	8b 45 08             	mov    0x8(%ebp),%eax
  800aff:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b03:	0f b6 10             	movzbl (%eax),%edx
  800b06:	84 d2                	test   %dl,%dl
  800b08:	74 09                	je     800b13 <strchr+0x1a>
		if (*s == c)
  800b0a:	38 ca                	cmp    %cl,%dl
  800b0c:	74 0a                	je     800b18 <strchr+0x1f>
	for (; *s; s++)
  800b0e:	83 c0 01             	add    $0x1,%eax
  800b11:	eb f0                	jmp    800b03 <strchr+0xa>
			return (char *) s;
	return 0;
  800b13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b18:	5d                   	pop    %ebp
  800b19:	c3                   	ret    

00800b1a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b1a:	55                   	push   %ebp
  800b1b:	89 e5                	mov    %esp,%ebp
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b24:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b27:	38 ca                	cmp    %cl,%dl
  800b29:	74 09                	je     800b34 <strfind+0x1a>
  800b2b:	84 d2                	test   %dl,%dl
  800b2d:	74 05                	je     800b34 <strfind+0x1a>
	for (; *s; s++)
  800b2f:	83 c0 01             	add    $0x1,%eax
  800b32:	eb f0                	jmp    800b24 <strfind+0xa>
			break;
	return (char *) s;
}
  800b34:	5d                   	pop    %ebp
  800b35:	c3                   	ret    

00800b36 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	57                   	push   %edi
  800b3a:	56                   	push   %esi
  800b3b:	53                   	push   %ebx
  800b3c:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b42:	85 c9                	test   %ecx,%ecx
  800b44:	74 31                	je     800b77 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b46:	89 f8                	mov    %edi,%eax
  800b48:	09 c8                	or     %ecx,%eax
  800b4a:	a8 03                	test   $0x3,%al
  800b4c:	75 23                	jne    800b71 <memset+0x3b>
		c &= 0xFF;
  800b4e:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b52:	89 d3                	mov    %edx,%ebx
  800b54:	c1 e3 08             	shl    $0x8,%ebx
  800b57:	89 d0                	mov    %edx,%eax
  800b59:	c1 e0 18             	shl    $0x18,%eax
  800b5c:	89 d6                	mov    %edx,%esi
  800b5e:	c1 e6 10             	shl    $0x10,%esi
  800b61:	09 f0                	or     %esi,%eax
  800b63:	09 c2                	or     %eax,%edx
  800b65:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b67:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b6a:	89 d0                	mov    %edx,%eax
  800b6c:	fc                   	cld    
  800b6d:	f3 ab                	rep stos %eax,%es:(%edi)
  800b6f:	eb 06                	jmp    800b77 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b74:	fc                   	cld    
  800b75:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b77:	89 f8                	mov    %edi,%eax
  800b79:	5b                   	pop    %ebx
  800b7a:	5e                   	pop    %esi
  800b7b:	5f                   	pop    %edi
  800b7c:	5d                   	pop    %ebp
  800b7d:	c3                   	ret    

00800b7e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b7e:	55                   	push   %ebp
  800b7f:	89 e5                	mov    %esp,%ebp
  800b81:	57                   	push   %edi
  800b82:	56                   	push   %esi
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
  800b86:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b89:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b8c:	39 c6                	cmp    %eax,%esi
  800b8e:	73 32                	jae    800bc2 <memmove+0x44>
  800b90:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b93:	39 c2                	cmp    %eax,%edx
  800b95:	76 2b                	jbe    800bc2 <memmove+0x44>
		s += n;
		d += n;
  800b97:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b9a:	89 fe                	mov    %edi,%esi
  800b9c:	09 ce                	or     %ecx,%esi
  800b9e:	09 d6                	or     %edx,%esi
  800ba0:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ba6:	75 0e                	jne    800bb6 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ba8:	83 ef 04             	sub    $0x4,%edi
  800bab:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bae:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800bb1:	fd                   	std    
  800bb2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bb4:	eb 09                	jmp    800bbf <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bb6:	83 ef 01             	sub    $0x1,%edi
  800bb9:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bbc:	fd                   	std    
  800bbd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bbf:	fc                   	cld    
  800bc0:	eb 1a                	jmp    800bdc <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bc2:	89 c2                	mov    %eax,%edx
  800bc4:	09 ca                	or     %ecx,%edx
  800bc6:	09 f2                	or     %esi,%edx
  800bc8:	f6 c2 03             	test   $0x3,%dl
  800bcb:	75 0a                	jne    800bd7 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bcd:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800bd0:	89 c7                	mov    %eax,%edi
  800bd2:	fc                   	cld    
  800bd3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bd5:	eb 05                	jmp    800bdc <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800bd7:	89 c7                	mov    %eax,%edi
  800bd9:	fc                   	cld    
  800bda:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bdc:	5e                   	pop    %esi
  800bdd:	5f                   	pop    %edi
  800bde:	5d                   	pop    %ebp
  800bdf:	c3                   	ret    

00800be0 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800be6:	ff 75 10             	pushl  0x10(%ebp)
  800be9:	ff 75 0c             	pushl  0xc(%ebp)
  800bec:	ff 75 08             	pushl  0x8(%ebp)
  800bef:	e8 8a ff ff ff       	call   800b7e <memmove>
}
  800bf4:	c9                   	leave  
  800bf5:	c3                   	ret    

00800bf6 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
  800bf9:	56                   	push   %esi
  800bfa:	53                   	push   %ebx
  800bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c01:	89 c6                	mov    %eax,%esi
  800c03:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c06:	39 f0                	cmp    %esi,%eax
  800c08:	74 1c                	je     800c26 <memcmp+0x30>
		if (*s1 != *s2)
  800c0a:	0f b6 08             	movzbl (%eax),%ecx
  800c0d:	0f b6 1a             	movzbl (%edx),%ebx
  800c10:	38 d9                	cmp    %bl,%cl
  800c12:	75 08                	jne    800c1c <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c14:	83 c0 01             	add    $0x1,%eax
  800c17:	83 c2 01             	add    $0x1,%edx
  800c1a:	eb ea                	jmp    800c06 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c1c:	0f b6 c1             	movzbl %cl,%eax
  800c1f:	0f b6 db             	movzbl %bl,%ebx
  800c22:	29 d8                	sub    %ebx,%eax
  800c24:	eb 05                	jmp    800c2b <memcmp+0x35>
	}

	return 0;
  800c26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c2b:	5b                   	pop    %ebx
  800c2c:	5e                   	pop    %esi
  800c2d:	5d                   	pop    %ebp
  800c2e:	c3                   	ret    

00800c2f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c2f:	55                   	push   %ebp
  800c30:	89 e5                	mov    %esp,%ebp
  800c32:	8b 45 08             	mov    0x8(%ebp),%eax
  800c35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c38:	89 c2                	mov    %eax,%edx
  800c3a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c3d:	39 d0                	cmp    %edx,%eax
  800c3f:	73 09                	jae    800c4a <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c41:	38 08                	cmp    %cl,(%eax)
  800c43:	74 05                	je     800c4a <memfind+0x1b>
	for (; s < ends; s++)
  800c45:	83 c0 01             	add    $0x1,%eax
  800c48:	eb f3                	jmp    800c3d <memfind+0xe>
			break;
	return (void *) s;
}
  800c4a:	5d                   	pop    %ebp
  800c4b:	c3                   	ret    

00800c4c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c4c:	55                   	push   %ebp
  800c4d:	89 e5                	mov    %esp,%ebp
  800c4f:	57                   	push   %edi
  800c50:	56                   	push   %esi
  800c51:	53                   	push   %ebx
  800c52:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c55:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c58:	eb 03                	jmp    800c5d <strtol+0x11>
		s++;
  800c5a:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c5d:	0f b6 01             	movzbl (%ecx),%eax
  800c60:	3c 20                	cmp    $0x20,%al
  800c62:	74 f6                	je     800c5a <strtol+0xe>
  800c64:	3c 09                	cmp    $0x9,%al
  800c66:	74 f2                	je     800c5a <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c68:	3c 2b                	cmp    $0x2b,%al
  800c6a:	74 2a                	je     800c96 <strtol+0x4a>
	int neg = 0;
  800c6c:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c71:	3c 2d                	cmp    $0x2d,%al
  800c73:	74 2b                	je     800ca0 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c75:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c7b:	75 0f                	jne    800c8c <strtol+0x40>
  800c7d:	80 39 30             	cmpb   $0x30,(%ecx)
  800c80:	74 28                	je     800caa <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c82:	85 db                	test   %ebx,%ebx
  800c84:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c89:	0f 44 d8             	cmove  %eax,%ebx
  800c8c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c91:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c94:	eb 50                	jmp    800ce6 <strtol+0x9a>
		s++;
  800c96:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c99:	bf 00 00 00 00       	mov    $0x0,%edi
  800c9e:	eb d5                	jmp    800c75 <strtol+0x29>
		s++, neg = 1;
  800ca0:	83 c1 01             	add    $0x1,%ecx
  800ca3:	bf 01 00 00 00       	mov    $0x1,%edi
  800ca8:	eb cb                	jmp    800c75 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800caa:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800cae:	74 0e                	je     800cbe <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800cb0:	85 db                	test   %ebx,%ebx
  800cb2:	75 d8                	jne    800c8c <strtol+0x40>
		s++, base = 8;
  800cb4:	83 c1 01             	add    $0x1,%ecx
  800cb7:	bb 08 00 00 00       	mov    $0x8,%ebx
  800cbc:	eb ce                	jmp    800c8c <strtol+0x40>
		s += 2, base = 16;
  800cbe:	83 c1 02             	add    $0x2,%ecx
  800cc1:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cc6:	eb c4                	jmp    800c8c <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800cc8:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ccb:	89 f3                	mov    %esi,%ebx
  800ccd:	80 fb 19             	cmp    $0x19,%bl
  800cd0:	77 29                	ja     800cfb <strtol+0xaf>
			dig = *s - 'a' + 10;
  800cd2:	0f be d2             	movsbl %dl,%edx
  800cd5:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cd8:	3b 55 10             	cmp    0x10(%ebp),%edx
  800cdb:	7d 30                	jge    800d0d <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cdd:	83 c1 01             	add    $0x1,%ecx
  800ce0:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ce4:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ce6:	0f b6 11             	movzbl (%ecx),%edx
  800ce9:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cec:	89 f3                	mov    %esi,%ebx
  800cee:	80 fb 09             	cmp    $0x9,%bl
  800cf1:	77 d5                	ja     800cc8 <strtol+0x7c>
			dig = *s - '0';
  800cf3:	0f be d2             	movsbl %dl,%edx
  800cf6:	83 ea 30             	sub    $0x30,%edx
  800cf9:	eb dd                	jmp    800cd8 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800cfb:	8d 72 bf             	lea    -0x41(%edx),%esi
  800cfe:	89 f3                	mov    %esi,%ebx
  800d00:	80 fb 19             	cmp    $0x19,%bl
  800d03:	77 08                	ja     800d0d <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d05:	0f be d2             	movsbl %dl,%edx
  800d08:	83 ea 37             	sub    $0x37,%edx
  800d0b:	eb cb                	jmp    800cd8 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d0d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d11:	74 05                	je     800d18 <strtol+0xcc>
		*endptr = (char *) s;
  800d13:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d16:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d18:	89 c2                	mov    %eax,%edx
  800d1a:	f7 da                	neg    %edx
  800d1c:	85 ff                	test   %edi,%edi
  800d1e:	0f 45 c2             	cmovne %edx,%eax
}
  800d21:	5b                   	pop    %ebx
  800d22:	5e                   	pop    %esi
  800d23:	5f                   	pop    %edi
  800d24:	5d                   	pop    %ebp
  800d25:	c3                   	ret    

00800d26 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	57                   	push   %edi
  800d2a:	56                   	push   %esi
  800d2b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d31:	8b 55 08             	mov    0x8(%ebp),%edx
  800d34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d37:	89 c3                	mov    %eax,%ebx
  800d39:	89 c7                	mov    %eax,%edi
  800d3b:	89 c6                	mov    %eax,%esi
  800d3d:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d3f:	5b                   	pop    %ebx
  800d40:	5e                   	pop    %esi
  800d41:	5f                   	pop    %edi
  800d42:	5d                   	pop    %ebp
  800d43:	c3                   	ret    

00800d44 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
  800d47:	57                   	push   %edi
  800d48:	56                   	push   %esi
  800d49:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d4a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d4f:	b8 01 00 00 00       	mov    $0x1,%eax
  800d54:	89 d1                	mov    %edx,%ecx
  800d56:	89 d3                	mov    %edx,%ebx
  800d58:	89 d7                	mov    %edx,%edi
  800d5a:	89 d6                	mov    %edx,%esi
  800d5c:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d5e:	5b                   	pop    %ebx
  800d5f:	5e                   	pop    %esi
  800d60:	5f                   	pop    %edi
  800d61:	5d                   	pop    %ebp
  800d62:	c3                   	ret    

00800d63 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
  800d66:	57                   	push   %edi
  800d67:	56                   	push   %esi
  800d68:	53                   	push   %ebx
  800d69:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d6c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d71:	8b 55 08             	mov    0x8(%ebp),%edx
  800d74:	b8 03 00 00 00       	mov    $0x3,%eax
  800d79:	89 cb                	mov    %ecx,%ebx
  800d7b:	89 cf                	mov    %ecx,%edi
  800d7d:	89 ce                	mov    %ecx,%esi
  800d7f:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d81:	85 c0                	test   %eax,%eax
  800d83:	7f 08                	jg     800d8d <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d85:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d88:	5b                   	pop    %ebx
  800d89:	5e                   	pop    %esi
  800d8a:	5f                   	pop    %edi
  800d8b:	5d                   	pop    %ebp
  800d8c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d8d:	83 ec 0c             	sub    $0xc,%esp
  800d90:	50                   	push   %eax
  800d91:	6a 03                	push   $0x3
  800d93:	68 e0 2e 80 00       	push   $0x802ee0
  800d98:	6a 4c                	push   $0x4c
  800d9a:	68 fd 2e 80 00       	push   $0x802efd
  800d9f:	e8 4b f4 ff ff       	call   8001ef <_panic>

00800da4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800da4:	55                   	push   %ebp
  800da5:	89 e5                	mov    %esp,%ebp
  800da7:	57                   	push   %edi
  800da8:	56                   	push   %esi
  800da9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800daa:	ba 00 00 00 00       	mov    $0x0,%edx
  800daf:	b8 02 00 00 00       	mov    $0x2,%eax
  800db4:	89 d1                	mov    %edx,%ecx
  800db6:	89 d3                	mov    %edx,%ebx
  800db8:	89 d7                	mov    %edx,%edi
  800dba:	89 d6                	mov    %edx,%esi
  800dbc:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800dbe:	5b                   	pop    %ebx
  800dbf:	5e                   	pop    %esi
  800dc0:	5f                   	pop    %edi
  800dc1:	5d                   	pop    %ebp
  800dc2:	c3                   	ret    

00800dc3 <sys_yield>:

void
sys_yield(void)
{
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
  800dc6:	57                   	push   %edi
  800dc7:	56                   	push   %esi
  800dc8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dc9:	ba 00 00 00 00       	mov    $0x0,%edx
  800dce:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dd3:	89 d1                	mov    %edx,%ecx
  800dd5:	89 d3                	mov    %edx,%ebx
  800dd7:	89 d7                	mov    %edx,%edi
  800dd9:	89 d6                	mov    %edx,%esi
  800ddb:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ddd:	5b                   	pop    %ebx
  800dde:	5e                   	pop    %esi
  800ddf:	5f                   	pop    %edi
  800de0:	5d                   	pop    %ebp
  800de1:	c3                   	ret    

00800de2 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800de2:	55                   	push   %ebp
  800de3:	89 e5                	mov    %esp,%ebp
  800de5:	57                   	push   %edi
  800de6:	56                   	push   %esi
  800de7:	53                   	push   %ebx
  800de8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800deb:	be 00 00 00 00       	mov    $0x0,%esi
  800df0:	8b 55 08             	mov    0x8(%ebp),%edx
  800df3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df6:	b8 04 00 00 00       	mov    $0x4,%eax
  800dfb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dfe:	89 f7                	mov    %esi,%edi
  800e00:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e02:	85 c0                	test   %eax,%eax
  800e04:	7f 08                	jg     800e0e <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e06:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e09:	5b                   	pop    %ebx
  800e0a:	5e                   	pop    %esi
  800e0b:	5f                   	pop    %edi
  800e0c:	5d                   	pop    %ebp
  800e0d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0e:	83 ec 0c             	sub    $0xc,%esp
  800e11:	50                   	push   %eax
  800e12:	6a 04                	push   $0x4
  800e14:	68 e0 2e 80 00       	push   $0x802ee0
  800e19:	6a 4c                	push   $0x4c
  800e1b:	68 fd 2e 80 00       	push   $0x802efd
  800e20:	e8 ca f3 ff ff       	call   8001ef <_panic>

00800e25 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e25:	55                   	push   %ebp
  800e26:	89 e5                	mov    %esp,%ebp
  800e28:	57                   	push   %edi
  800e29:	56                   	push   %esi
  800e2a:	53                   	push   %ebx
  800e2b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e34:	b8 05 00 00 00       	mov    $0x5,%eax
  800e39:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e3c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e3f:	8b 75 18             	mov    0x18(%ebp),%esi
  800e42:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e44:	85 c0                	test   %eax,%eax
  800e46:	7f 08                	jg     800e50 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e48:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e4b:	5b                   	pop    %ebx
  800e4c:	5e                   	pop    %esi
  800e4d:	5f                   	pop    %edi
  800e4e:	5d                   	pop    %ebp
  800e4f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e50:	83 ec 0c             	sub    $0xc,%esp
  800e53:	50                   	push   %eax
  800e54:	6a 05                	push   $0x5
  800e56:	68 e0 2e 80 00       	push   $0x802ee0
  800e5b:	6a 4c                	push   $0x4c
  800e5d:	68 fd 2e 80 00       	push   $0x802efd
  800e62:	e8 88 f3 ff ff       	call   8001ef <_panic>

00800e67 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	57                   	push   %edi
  800e6b:	56                   	push   %esi
  800e6c:	53                   	push   %ebx
  800e6d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e70:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e75:	8b 55 08             	mov    0x8(%ebp),%edx
  800e78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e7b:	b8 06 00 00 00       	mov    $0x6,%eax
  800e80:	89 df                	mov    %ebx,%edi
  800e82:	89 de                	mov    %ebx,%esi
  800e84:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e86:	85 c0                	test   %eax,%eax
  800e88:	7f 08                	jg     800e92 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e8d:	5b                   	pop    %ebx
  800e8e:	5e                   	pop    %esi
  800e8f:	5f                   	pop    %edi
  800e90:	5d                   	pop    %ebp
  800e91:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e92:	83 ec 0c             	sub    $0xc,%esp
  800e95:	50                   	push   %eax
  800e96:	6a 06                	push   $0x6
  800e98:	68 e0 2e 80 00       	push   $0x802ee0
  800e9d:	6a 4c                	push   $0x4c
  800e9f:	68 fd 2e 80 00       	push   $0x802efd
  800ea4:	e8 46 f3 ff ff       	call   8001ef <_panic>

00800ea9 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ea9:	55                   	push   %ebp
  800eaa:	89 e5                	mov    %esp,%ebp
  800eac:	57                   	push   %edi
  800ead:	56                   	push   %esi
  800eae:	53                   	push   %ebx
  800eaf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eb2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ebd:	b8 08 00 00 00       	mov    $0x8,%eax
  800ec2:	89 df                	mov    %ebx,%edi
  800ec4:	89 de                	mov    %ebx,%esi
  800ec6:	cd 30                	int    $0x30
	if (check && ret > 0)
  800ec8:	85 c0                	test   %eax,%eax
  800eca:	7f 08                	jg     800ed4 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ecc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ecf:	5b                   	pop    %ebx
  800ed0:	5e                   	pop    %esi
  800ed1:	5f                   	pop    %edi
  800ed2:	5d                   	pop    %ebp
  800ed3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed4:	83 ec 0c             	sub    $0xc,%esp
  800ed7:	50                   	push   %eax
  800ed8:	6a 08                	push   $0x8
  800eda:	68 e0 2e 80 00       	push   $0x802ee0
  800edf:	6a 4c                	push   $0x4c
  800ee1:	68 fd 2e 80 00       	push   $0x802efd
  800ee6:	e8 04 f3 ff ff       	call   8001ef <_panic>

00800eeb <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800eeb:	55                   	push   %ebp
  800eec:	89 e5                	mov    %esp,%ebp
  800eee:	57                   	push   %edi
  800eef:	56                   	push   %esi
  800ef0:	53                   	push   %ebx
  800ef1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ef4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ef9:	8b 55 08             	mov    0x8(%ebp),%edx
  800efc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eff:	b8 09 00 00 00       	mov    $0x9,%eax
  800f04:	89 df                	mov    %ebx,%edi
  800f06:	89 de                	mov    %ebx,%esi
  800f08:	cd 30                	int    $0x30
	if (check && ret > 0)
  800f0a:	85 c0                	test   %eax,%eax
  800f0c:	7f 08                	jg     800f16 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f11:	5b                   	pop    %ebx
  800f12:	5e                   	pop    %esi
  800f13:	5f                   	pop    %edi
  800f14:	5d                   	pop    %ebp
  800f15:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f16:	83 ec 0c             	sub    $0xc,%esp
  800f19:	50                   	push   %eax
  800f1a:	6a 09                	push   $0x9
  800f1c:	68 e0 2e 80 00       	push   $0x802ee0
  800f21:	6a 4c                	push   $0x4c
  800f23:	68 fd 2e 80 00       	push   $0x802efd
  800f28:	e8 c2 f2 ff ff       	call   8001ef <_panic>

00800f2d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f2d:	55                   	push   %ebp
  800f2e:	89 e5                	mov    %esp,%ebp
  800f30:	57                   	push   %edi
  800f31:	56                   	push   %esi
  800f32:	53                   	push   %ebx
  800f33:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f36:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f3b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f41:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f46:	89 df                	mov    %ebx,%edi
  800f48:	89 de                	mov    %ebx,%esi
  800f4a:	cd 30                	int    $0x30
	if (check && ret > 0)
  800f4c:	85 c0                	test   %eax,%eax
  800f4e:	7f 08                	jg     800f58 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f53:	5b                   	pop    %ebx
  800f54:	5e                   	pop    %esi
  800f55:	5f                   	pop    %edi
  800f56:	5d                   	pop    %ebp
  800f57:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f58:	83 ec 0c             	sub    $0xc,%esp
  800f5b:	50                   	push   %eax
  800f5c:	6a 0a                	push   $0xa
  800f5e:	68 e0 2e 80 00       	push   $0x802ee0
  800f63:	6a 4c                	push   $0x4c
  800f65:	68 fd 2e 80 00       	push   $0x802efd
  800f6a:	e8 80 f2 ff ff       	call   8001ef <_panic>

00800f6f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	57                   	push   %edi
  800f73:	56                   	push   %esi
  800f74:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f75:	8b 55 08             	mov    0x8(%ebp),%edx
  800f78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7b:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f80:	be 00 00 00 00       	mov    $0x0,%esi
  800f85:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f88:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f8b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f8d:	5b                   	pop    %ebx
  800f8e:	5e                   	pop    %esi
  800f8f:	5f                   	pop    %edi
  800f90:	5d                   	pop    %ebp
  800f91:	c3                   	ret    

00800f92 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f92:	55                   	push   %ebp
  800f93:	89 e5                	mov    %esp,%ebp
  800f95:	57                   	push   %edi
  800f96:	56                   	push   %esi
  800f97:	53                   	push   %ebx
  800f98:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f9b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fa0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa3:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fa8:	89 cb                	mov    %ecx,%ebx
  800faa:	89 cf                	mov    %ecx,%edi
  800fac:	89 ce                	mov    %ecx,%esi
  800fae:	cd 30                	int    $0x30
	if (check && ret > 0)
  800fb0:	85 c0                	test   %eax,%eax
  800fb2:	7f 08                	jg     800fbc <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb7:	5b                   	pop    %ebx
  800fb8:	5e                   	pop    %esi
  800fb9:	5f                   	pop    %edi
  800fba:	5d                   	pop    %ebp
  800fbb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fbc:	83 ec 0c             	sub    $0xc,%esp
  800fbf:	50                   	push   %eax
  800fc0:	6a 0d                	push   $0xd
  800fc2:	68 e0 2e 80 00       	push   $0x802ee0
  800fc7:	6a 4c                	push   $0x4c
  800fc9:	68 fd 2e 80 00       	push   $0x802efd
  800fce:	e8 1c f2 ff ff       	call   8001ef <_panic>

00800fd3 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800fd3:	55                   	push   %ebp
  800fd4:	89 e5                	mov    %esp,%ebp
  800fd6:	57                   	push   %edi
  800fd7:	56                   	push   %esi
  800fd8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fd9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fde:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe4:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fe9:	89 df                	mov    %ebx,%edi
  800feb:	89 de                	mov    %ebx,%esi
  800fed:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800fef:	5b                   	pop    %ebx
  800ff0:	5e                   	pop    %esi
  800ff1:	5f                   	pop    %edi
  800ff2:	5d                   	pop    %ebp
  800ff3:	c3                   	ret    

00800ff4 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800ff4:	55                   	push   %ebp
  800ff5:	89 e5                	mov    %esp,%ebp
  800ff7:	57                   	push   %edi
  800ff8:	56                   	push   %esi
  800ff9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ffa:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fff:	8b 55 08             	mov    0x8(%ebp),%edx
  801002:	b8 0f 00 00 00       	mov    $0xf,%eax
  801007:	89 cb                	mov    %ecx,%ebx
  801009:	89 cf                	mov    %ecx,%edi
  80100b:	89 ce                	mov    %ecx,%esi
  80100d:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80100f:	5b                   	pop    %ebx
  801010:	5e                   	pop    %esi
  801011:	5f                   	pop    %edi
  801012:	5d                   	pop    %ebp
  801013:	c3                   	ret    

00801014 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801014:	55                   	push   %ebp
  801015:	89 e5                	mov    %esp,%ebp
  801017:	53                   	push   %ebx
  801018:	83 ec 04             	sub    $0x4,%esp
  80101b:	8b 55 08             	mov    0x8(%ebp),%edx
	// cprintf("pgfault()\n");
	void *addr = (void *) utf->utf_fault_va;
  80101e:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpd[PDX(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_P) || !(uvpt[PGNUM(addr)] & PTE_COW))
  801020:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801024:	0f 84 9c 00 00 00    	je     8010c6 <pgfault+0xb2>
  80102a:	89 c2                	mov    %eax,%edx
  80102c:	c1 ea 16             	shr    $0x16,%edx
  80102f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801036:	f6 c2 01             	test   $0x1,%dl
  801039:	0f 84 87 00 00 00    	je     8010c6 <pgfault+0xb2>
  80103f:	89 c2                	mov    %eax,%edx
  801041:	c1 ea 0c             	shr    $0xc,%edx
  801044:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80104b:	f6 c1 01             	test   $0x1,%cl
  80104e:	74 76                	je     8010c6 <pgfault+0xb2>
  801050:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801057:	f6 c6 08             	test   $0x8,%dh
  80105a:	74 6a                	je     8010c6 <pgfault+0xb2>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  80105c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801061:	89 c3                	mov    %eax,%ebx

	r = sys_page_alloc(0, PFTEMP, PTE_P|PTE_U|PTE_W);
  801063:	83 ec 04             	sub    $0x4,%esp
  801066:	6a 07                	push   $0x7
  801068:	68 00 f0 7f 00       	push   $0x7ff000
  80106d:	6a 00                	push   $0x0
  80106f:	e8 6e fd ff ff       	call   800de2 <sys_page_alloc>
	if(r < 0){
  801074:	83 c4 10             	add    $0x10,%esp
  801077:	85 c0                	test   %eax,%eax
  801079:	78 5f                	js     8010da <pgfault+0xc6>
		panic("pgfault: sys_page_alloc fail, r: %d", r);
	}

	memmove(PFTEMP, addr, PGSIZE);
  80107b:	83 ec 04             	sub    $0x4,%esp
  80107e:	68 00 10 00 00       	push   $0x1000
  801083:	53                   	push   %ebx
  801084:	68 00 f0 7f 00       	push   $0x7ff000
  801089:	e8 f0 fa ff ff       	call   800b7e <memmove>

	r = sys_page_map(0, PFTEMP, 0, addr, PTE_P|PTE_U|PTE_W);
  80108e:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801095:	53                   	push   %ebx
  801096:	6a 00                	push   $0x0
  801098:	68 00 f0 7f 00       	push   $0x7ff000
  80109d:	6a 00                	push   $0x0
  80109f:	e8 81 fd ff ff       	call   800e25 <sys_page_map>
	if(r < 0){
  8010a4:	83 c4 20             	add    $0x20,%esp
  8010a7:	85 c0                	test   %eax,%eax
  8010a9:	78 41                	js     8010ec <pgfault+0xd8>
		panic("pgfault: sys_page_map fail, r: %d", r);
	}

	r = sys_page_unmap(0, PFTEMP);
  8010ab:	83 ec 08             	sub    $0x8,%esp
  8010ae:	68 00 f0 7f 00       	push   $0x7ff000
  8010b3:	6a 00                	push   $0x0
  8010b5:	e8 ad fd ff ff       	call   800e67 <sys_page_unmap>
	if(r < 0){
  8010ba:	83 c4 10             	add    $0x10,%esp
  8010bd:	85 c0                	test   %eax,%eax
  8010bf:	78 3d                	js     8010fe <pgfault+0xea>
		panic("sys_page_unmap: %e", r);
	}
}
  8010c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010c4:	c9                   	leave  
  8010c5:	c3                   	ret    
		panic("pgfault: 1\n");
  8010c6:	83 ec 04             	sub    $0x4,%esp
  8010c9:	68 0b 2f 80 00       	push   $0x802f0b
  8010ce:	6a 20                	push   $0x20
  8010d0:	68 17 2f 80 00       	push   $0x802f17
  8010d5:	e8 15 f1 ff ff       	call   8001ef <_panic>
		panic("pgfault: sys_page_alloc fail, r: %d", r);
  8010da:	50                   	push   %eax
  8010db:	68 6c 2f 80 00       	push   $0x802f6c
  8010e0:	6a 2e                	push   $0x2e
  8010e2:	68 17 2f 80 00       	push   $0x802f17
  8010e7:	e8 03 f1 ff ff       	call   8001ef <_panic>
		panic("pgfault: sys_page_map fail, r: %d", r);
  8010ec:	50                   	push   %eax
  8010ed:	68 90 2f 80 00       	push   $0x802f90
  8010f2:	6a 35                	push   $0x35
  8010f4:	68 17 2f 80 00       	push   $0x802f17
  8010f9:	e8 f1 f0 ff ff       	call   8001ef <_panic>
		panic("sys_page_unmap: %e", r);
  8010fe:	50                   	push   %eax
  8010ff:	68 22 2f 80 00       	push   $0x802f22
  801104:	6a 3a                	push   $0x3a
  801106:	68 17 2f 80 00       	push   $0x802f17
  80110b:	e8 df f0 ff ff       	call   8001ef <_panic>

00801110 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801110:	55                   	push   %ebp
  801111:	89 e5                	mov    %esp,%ebp
  801113:	57                   	push   %edi
  801114:	56                   	push   %esi
  801115:	53                   	push   %ebx
  801116:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	// panic("fork not implemented");
	int r;
	set_pgfault_handler(pgfault);
  801119:	68 14 10 80 00       	push   $0x801014
  80111e:	e8 bf 08 00 00       	call   8019e2 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801123:	b8 07 00 00 00       	mov    $0x7,%eax
  801128:	cd 30                	int    $0x30
  80112a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int i;
	uintptr_t va;
	envid_t childid = sys_exofork();
	if (childid < 0){
  80112d:	83 c4 10             	add    $0x10,%esp
  801130:	85 c0                	test   %eax,%eax
  801132:	78 2c                	js     801160 <fork+0x50>
  801134:	89 c7                	mov    %eax,%edi
	}

	extern volatile pde_t uvpd[];
	extern volatile pte_t uvpt[];

	for (va = UTEXT; va < USTACKTOP; va += PGSIZE){
  801136:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (childid == 0) {
  80113b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80113f:	75 72                	jne    8011b3 <fork+0xa3>
		thisenv = &envs[ENVX(sys_getenvid())];
  801141:	e8 5e fc ff ff       	call   800da4 <sys_getenvid>
  801146:	25 ff 03 00 00       	and    $0x3ff,%eax
  80114b:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801151:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801156:	a3 04 50 80 00       	mov    %eax,0x805004
		return 0;
  80115b:	e9 36 01 00 00       	jmp    801296 <fork+0x186>
		panic("fork: child id < 0: %d", childid);
  801160:	50                   	push   %eax
  801161:	68 35 2f 80 00       	push   $0x802f35
  801166:	68 83 00 00 00       	push   $0x83
  80116b:	68 17 2f 80 00       	push   $0x802f17
  801170:	e8 7a f0 ff ff       	call   8001ef <_panic>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  801175:	50                   	push   %eax
  801176:	68 b4 2f 80 00       	push   $0x802fb4
  80117b:	6a 56                	push   $0x56
  80117d:	68 17 2f 80 00       	push   $0x802f17
  801182:	e8 68 f0 ff ff       	call   8001ef <_panic>
		r = sys_page_map((envid_t)0, va, envid, va, PTE_U | PTE_P);
  801187:	83 ec 0c             	sub    $0xc,%esp
  80118a:	6a 05                	push   $0x5
  80118c:	56                   	push   %esi
  80118d:	57                   	push   %edi
  80118e:	56                   	push   %esi
  80118f:	6a 00                	push   $0x0
  801191:	e8 8f fc ff ff       	call   800e25 <sys_page_map>
		if(r < 0){
  801196:	83 c4 20             	add    $0x20,%esp
  801199:	85 c0                	test   %eax,%eax
  80119b:	0f 88 9f 00 00 00    	js     801240 <fork+0x130>
	for (va = UTEXT; va < USTACKTOP; va += PGSIZE){
  8011a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8011a7:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8011ad:	0f 84 9f 00 00 00    	je     801252 <fork+0x142>
		if ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_U)){
  8011b3:	89 d8                	mov    %ebx,%eax
  8011b5:	c1 e8 16             	shr    $0x16,%eax
  8011b8:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011bf:	a8 01                	test   $0x1,%al
  8011c1:	74 de                	je     8011a1 <fork+0x91>
  8011c3:	89 d8                	mov    %ebx,%eax
  8011c5:	c1 e8 0c             	shr    $0xc,%eax
  8011c8:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011cf:	f6 c2 01             	test   $0x1,%dl
  8011d2:	74 cd                	je     8011a1 <fork+0x91>
  8011d4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011db:	f6 c2 04             	test   $0x4,%dl
  8011de:	74 c1                	je     8011a1 <fork+0x91>
	void * va = (void *)(pn * PGSIZE);
  8011e0:	89 c6                	mov    %eax,%esi
  8011e2:	c1 e6 0c             	shl    $0xc,%esi
	int perm = (uvpt[pn]);
  8011e5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (perm & (PTE_W | PTE_COW)) {
  8011ec:	a9 02 08 00 00       	test   $0x802,%eax
  8011f1:	74 94                	je     801187 <fork+0x77>
		r = sys_page_map((envid_t)0, va, envid, va, PTE_U | PTE_P | PTE_COW);
  8011f3:	83 ec 0c             	sub    $0xc,%esp
  8011f6:	68 05 08 00 00       	push   $0x805
  8011fb:	56                   	push   %esi
  8011fc:	57                   	push   %edi
  8011fd:	56                   	push   %esi
  8011fe:	6a 00                	push   $0x0
  801200:	e8 20 fc ff ff       	call   800e25 <sys_page_map>
		if(r < 0){
  801205:	83 c4 20             	add    $0x20,%esp
  801208:	85 c0                	test   %eax,%eax
  80120a:	0f 88 65 ff ff ff    	js     801175 <fork+0x65>
		r = sys_page_map((envid_t)0, va, (envid_t)0, va, PTE_U | PTE_P | PTE_COW);
  801210:	83 ec 0c             	sub    $0xc,%esp
  801213:	68 05 08 00 00       	push   $0x805
  801218:	56                   	push   %esi
  801219:	6a 00                	push   $0x0
  80121b:	56                   	push   %esi
  80121c:	6a 00                	push   $0x0
  80121e:	e8 02 fc ff ff       	call   800e25 <sys_page_map>
		if(r < 0){
  801223:	83 c4 20             	add    $0x20,%esp
  801226:	85 c0                	test   %eax,%eax
  801228:	0f 89 73 ff ff ff    	jns    8011a1 <fork+0x91>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  80122e:	50                   	push   %eax
  80122f:	68 b4 2f 80 00       	push   $0x802fb4
  801234:	6a 5b                	push   $0x5b
  801236:	68 17 2f 80 00       	push   $0x802f17
  80123b:	e8 af ef ff ff       	call   8001ef <_panic>
			panic("sys_page_map: sys_page_map fail, r:%d\n", r);
  801240:	50                   	push   %eax
  801241:	68 b4 2f 80 00       	push   $0x802fb4
  801246:	6a 61                	push   $0x61
  801248:	68 17 2f 80 00       	push   $0x802f17
  80124d:	e8 9d ef ff ff       	call   8001ef <_panic>
			duppage(childid, PGNUM(va));
		}
	}

	r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801252:	83 ec 04             	sub    $0x4,%esp
  801255:	6a 07                	push   $0x7
  801257:	68 00 f0 bf ee       	push   $0xeebff000
  80125c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80125f:	e8 7e fb ff ff       	call   800de2 <sys_page_alloc>
	if (r < 0){
  801264:	83 c4 10             	add    $0x10,%esp
  801267:	85 c0                	test   %eax,%eax
  801269:	78 36                	js     8012a1 <fork+0x191>
		panic("fork: allocate user exception stack for child env error, %d", r);
	}
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  80126b:	83 ec 08             	sub    $0x8,%esp
  80126e:	68 4d 1a 80 00       	push   $0x801a4d
  801273:	ff 75 e4             	pushl  -0x1c(%ebp)
  801276:	e8 b2 fc ff ff       	call   800f2d <sys_env_set_pgfault_upcall>
	if (r < 0){
  80127b:	83 c4 10             	add    $0x10,%esp
  80127e:	85 c0                	test   %eax,%eax
  801280:	78 34                	js     8012b6 <fork+0x1a6>
		panic("fork: sys_env_set_pgfault_upcall error, %d", r);
	}
	r = sys_env_set_status(childid, ENV_RUNNABLE);
  801282:	83 ec 08             	sub    $0x8,%esp
  801285:	6a 02                	push   $0x2
  801287:	ff 75 e4             	pushl  -0x1c(%ebp)
  80128a:	e8 1a fc ff ff       	call   800ea9 <sys_env_set_status>
	if(r < 0){
  80128f:	83 c4 10             	add    $0x10,%esp
  801292:	85 c0                	test   %eax,%eax
  801294:	78 35                	js     8012cb <fork+0x1bb>
		panic("forK: sys_env_set_status, r%d", r);
	}
	return childid;
}
  801296:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801299:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80129c:	5b                   	pop    %ebx
  80129d:	5e                   	pop    %esi
  80129e:	5f                   	pop    %edi
  80129f:	5d                   	pop    %ebp
  8012a0:	c3                   	ret    
		panic("fork: allocate user exception stack for child env error, %d", r);
  8012a1:	50                   	push   %eax
  8012a2:	68 dc 2f 80 00       	push   $0x802fdc
  8012a7:	68 96 00 00 00       	push   $0x96
  8012ac:	68 17 2f 80 00       	push   $0x802f17
  8012b1:	e8 39 ef ff ff       	call   8001ef <_panic>
		panic("fork: sys_env_set_pgfault_upcall error, %d", r);
  8012b6:	50                   	push   %eax
  8012b7:	68 18 30 80 00       	push   $0x803018
  8012bc:	68 9a 00 00 00       	push   $0x9a
  8012c1:	68 17 2f 80 00       	push   $0x802f17
  8012c6:	e8 24 ef ff ff       	call   8001ef <_panic>
		panic("forK: sys_env_set_status, r%d", r);
  8012cb:	50                   	push   %eax
  8012cc:	68 4c 2f 80 00       	push   $0x802f4c
  8012d1:	68 9e 00 00 00       	push   $0x9e
  8012d6:	68 17 2f 80 00       	push   $0x802f17
  8012db:	e8 0f ef ff ff       	call   8001ef <_panic>

008012e0 <sfork>:

// Challenge!
int
sfork(void)
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
  8012e3:	57                   	push   %edi
  8012e4:	56                   	push   %esi
  8012e5:	53                   	push   %ebx
  8012e6:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// return -E_INVAL;
	set_pgfault_handler(pgfault);
  8012e9:	68 14 10 80 00       	push   $0x801014
  8012ee:	e8 ef 06 00 00       	call   8019e2 <set_pgfault_handler>
  8012f3:	b8 07 00 00 00       	mov    $0x7,%eax
  8012f8:	cd 30                	int    $0x30
  8012fa:	89 c6                	mov    %eax,%esi
	int i;
	uintptr_t va;
	envid_t childid = sys_exofork();
	int r;
	if (childid < 0){
  8012fc:	83 c4 10             	add    $0x10,%esp
  8012ff:	85 c0                	test   %eax,%eax
  801301:	78 28                	js     80132b <sfork+0x4b>
  801303:	89 c7                	mov    %eax,%edi
	}

	extern volatile pde_t uvpd[];
	extern volatile pte_t uvpt[];

	for (va = 0; va < USTACKTOP; va += PGSIZE){
  801305:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (childid == 0) {
  80130a:	75 42                	jne    80134e <sfork+0x6e>
		thisenv = &envs[ENVX(sys_getenvid())];
  80130c:	e8 93 fa ff ff       	call   800da4 <sys_getenvid>
  801311:	25 ff 03 00 00       	and    $0x3ff,%eax
  801316:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80131c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801321:	a3 04 50 80 00       	mov    %eax,0x805004
		return 0;
  801326:	e9 bc 00 00 00       	jmp    8013e7 <sfork+0x107>
		panic("fork: child id < 0: %d", childid);
  80132b:	50                   	push   %eax
  80132c:	68 35 2f 80 00       	push   $0x802f35
  801331:	68 af 00 00 00       	push   $0xaf
  801336:	68 17 2f 80 00       	push   $0x802f17
  80133b:	e8 af ee ff ff       	call   8001ef <_panic>
	for (va = 0; va < USTACKTOP; va += PGSIZE){
  801340:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801346:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80134c:	74 5b                	je     8013a9 <sfork+0xc9>
		if ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_U)){
  80134e:	89 d8                	mov    %ebx,%eax
  801350:	c1 e8 16             	shr    $0x16,%eax
  801353:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80135a:	a8 01                	test   $0x1,%al
  80135c:	74 e2                	je     801340 <sfork+0x60>
  80135e:	89 d8                	mov    %ebx,%eax
  801360:	c1 e8 0c             	shr    $0xc,%eax
  801363:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80136a:	f6 c2 01             	test   $0x1,%dl
  80136d:	74 d1                	je     801340 <sfork+0x60>
  80136f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801376:	f6 c2 04             	test   $0x4,%dl
  801379:	74 c5                	je     801340 <sfork+0x60>
			void *addr = (void *)(PGNUM(va) * PGSIZE);
  80137b:	c1 e0 0c             	shl    $0xc,%eax
			struct PageInfo *page;
			pte_t *pte;
			
			// page = page_lookup((envid_t)0->env_pgdir, addr, &pte);
			// page_insert(dstenv->env_pgdir, page, addr, PTE_U | PTE_P);
			r = sys_page_map((envid_t)0, addr, childid, addr, PTE_U | PTE_P);
  80137e:	83 ec 0c             	sub    $0xc,%esp
  801381:	6a 05                	push   $0x5
  801383:	50                   	push   %eax
  801384:	57                   	push   %edi
  801385:	50                   	push   %eax
  801386:	6a 00                	push   $0x0
  801388:	e8 98 fa ff ff       	call   800e25 <sys_page_map>
			if(r < 0){
  80138d:	83 c4 20             	add    $0x20,%esp
  801390:	85 c0                	test   %eax,%eax
  801392:	79 ac                	jns    801340 <sfork+0x60>
				panic("sfork: sys_page_map fail, r:%d\n", r);
  801394:	50                   	push   %eax
  801395:	68 44 30 80 00       	push   $0x803044
  80139a:	68 c4 00 00 00       	push   $0xc4
  80139f:	68 17 2f 80 00       	push   $0x802f17
  8013a4:	e8 46 ee ff ff       	call   8001ef <_panic>
			}
		}
	}

	r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8013a9:	83 ec 04             	sub    $0x4,%esp
  8013ac:	6a 07                	push   $0x7
  8013ae:	68 00 f0 bf ee       	push   $0xeebff000
  8013b3:	56                   	push   %esi
  8013b4:	e8 29 fa ff ff       	call   800de2 <sys_page_alloc>
	if (r < 0){
  8013b9:	83 c4 10             	add    $0x10,%esp
  8013bc:	85 c0                	test   %eax,%eax
  8013be:	78 31                	js     8013f1 <sfork+0x111>
		panic("sfork: allocate user exception stack for child env error, %d", r);
	}
	r = sys_env_set_pgfault_upcall(childid, _pgfault_upcall);
  8013c0:	83 ec 08             	sub    $0x8,%esp
  8013c3:	68 4d 1a 80 00       	push   $0x801a4d
  8013c8:	56                   	push   %esi
  8013c9:	e8 5f fb ff ff       	call   800f2d <sys_env_set_pgfault_upcall>
	if (r < 0){
  8013ce:	83 c4 10             	add    $0x10,%esp
  8013d1:	85 c0                	test   %eax,%eax
  8013d3:	78 31                	js     801406 <sfork+0x126>
		panic("sfork: sys_env_set_pgfault_upcall error, %d", r);
	}
	r = sys_env_set_status(childid, ENV_RUNNABLE);
  8013d5:	83 ec 08             	sub    $0x8,%esp
  8013d8:	6a 02                	push   $0x2
  8013da:	56                   	push   %esi
  8013db:	e8 c9 fa ff ff       	call   800ea9 <sys_env_set_status>
	if(r < 0){
  8013e0:	83 c4 10             	add    $0x10,%esp
  8013e3:	85 c0                	test   %eax,%eax
  8013e5:	78 34                	js     80141b <sfork+0x13b>
		panic("sforK: sys_env_set_status, r%d", r);
	}
	return childid;
}
  8013e7:	89 f0                	mov    %esi,%eax
  8013e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013ec:	5b                   	pop    %ebx
  8013ed:	5e                   	pop    %esi
  8013ee:	5f                   	pop    %edi
  8013ef:	5d                   	pop    %ebp
  8013f0:	c3                   	ret    
		panic("sfork: allocate user exception stack for child env error, %d", r);
  8013f1:	50                   	push   %eax
  8013f2:	68 64 30 80 00       	push   $0x803064
  8013f7:	68 cb 00 00 00       	push   $0xcb
  8013fc:	68 17 2f 80 00       	push   $0x802f17
  801401:	e8 e9 ed ff ff       	call   8001ef <_panic>
		panic("sfork: sys_env_set_pgfault_upcall error, %d", r);
  801406:	50                   	push   %eax
  801407:	68 a4 30 80 00       	push   $0x8030a4
  80140c:	68 cf 00 00 00       	push   $0xcf
  801411:	68 17 2f 80 00       	push   $0x802f17
  801416:	e8 d4 ed ff ff       	call   8001ef <_panic>
		panic("sforK: sys_env_set_status, r%d", r);
  80141b:	50                   	push   %eax
  80141c:	68 d0 30 80 00       	push   $0x8030d0
  801421:	68 d3 00 00 00       	push   $0xd3
  801426:	68 17 2f 80 00       	push   $0x802f17
  80142b:	e8 bf ed ff ff       	call   8001ef <_panic>

00801430 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801430:	55                   	push   %ebp
  801431:	89 e5                	mov    %esp,%ebp
  801433:	57                   	push   %edi
  801434:	56                   	push   %esi
  801435:	53                   	push   %ebx
  801436:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  80143c:	6a 00                	push   $0x0
  80143e:	ff 75 08             	pushl  0x8(%ebp)
  801441:	e8 48 0d 00 00       	call   80218e <open>
  801446:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  80144c:	83 c4 10             	add    $0x10,%esp
  80144f:	85 c0                	test   %eax,%eax
  801451:	0f 88 72 04 00 00    	js     8018c9 <spawn+0x499>
  801457:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801459:	83 ec 04             	sub    $0x4,%esp
  80145c:	68 00 02 00 00       	push   $0x200
  801461:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801467:	50                   	push   %eax
  801468:	52                   	push   %edx
  801469:	e8 70 09 00 00       	call   801dde <readn>
  80146e:	83 c4 10             	add    $0x10,%esp
  801471:	3d 00 02 00 00       	cmp    $0x200,%eax
  801476:	75 60                	jne    8014d8 <spawn+0xa8>
	    || elf->e_magic != ELF_MAGIC) {
  801478:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  80147f:	45 4c 46 
  801482:	75 54                	jne    8014d8 <spawn+0xa8>
  801484:	b8 07 00 00 00       	mov    $0x7,%eax
  801489:	cd 30                	int    $0x30
  80148b:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801491:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801497:	85 c0                	test   %eax,%eax
  801499:	0f 88 1e 04 00 00    	js     8018bd <spawn+0x48d>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80149f:	25 ff 03 00 00       	and    $0x3ff,%eax
  8014a4:	69 f0 84 00 00 00    	imul   $0x84,%eax,%esi
  8014aa:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  8014b0:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8014b6:	b9 11 00 00 00       	mov    $0x11,%ecx
  8014bb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8014bd:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  8014c3:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8014c9:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  8014ce:	be 00 00 00 00       	mov    $0x0,%esi
  8014d3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8014d6:	eb 4b                	jmp    801523 <spawn+0xf3>
		close(fd);
  8014d8:	83 ec 0c             	sub    $0xc,%esp
  8014db:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8014e1:	e8 33 07 00 00       	call   801c19 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8014e6:	83 c4 0c             	add    $0xc,%esp
  8014e9:	68 7f 45 4c 46       	push   $0x464c457f
  8014ee:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  8014f4:	68 ef 30 80 00       	push   $0x8030ef
  8014f9:	e8 cc ed ff ff       	call   8002ca <cprintf>
		return -E_NOT_EXEC;
  8014fe:	83 c4 10             	add    $0x10,%esp
  801501:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801508:	ff ff ff 
  80150b:	e9 b9 03 00 00       	jmp    8018c9 <spawn+0x499>
		string_size += strlen(argv[argc]) + 1;
  801510:	83 ec 0c             	sub    $0xc,%esp
  801513:	50                   	push   %eax
  801514:	e8 9e f4 ff ff       	call   8009b7 <strlen>
  801519:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  80151d:	83 c3 01             	add    $0x1,%ebx
  801520:	83 c4 10             	add    $0x10,%esp
  801523:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  80152a:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  80152d:	85 c0                	test   %eax,%eax
  80152f:	75 df                	jne    801510 <spawn+0xe0>
  801531:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801537:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  80153d:	bf 00 10 40 00       	mov    $0x401000,%edi
  801542:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801544:	89 fa                	mov    %edi,%edx
  801546:	83 e2 fc             	and    $0xfffffffc,%edx
  801549:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801550:	29 c2                	sub    %eax,%edx
  801552:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801558:	8d 42 f8             	lea    -0x8(%edx),%eax
  80155b:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801560:	0f 86 86 03 00 00    	jbe    8018ec <spawn+0x4bc>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801566:	83 ec 04             	sub    $0x4,%esp
  801569:	6a 07                	push   $0x7
  80156b:	68 00 00 40 00       	push   $0x400000
  801570:	6a 00                	push   $0x0
  801572:	e8 6b f8 ff ff       	call   800de2 <sys_page_alloc>
  801577:	83 c4 10             	add    $0x10,%esp
  80157a:	85 c0                	test   %eax,%eax
  80157c:	0f 88 6f 03 00 00    	js     8018f1 <spawn+0x4c1>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801582:	be 00 00 00 00       	mov    $0x0,%esi
  801587:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  80158d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801590:	eb 30                	jmp    8015c2 <spawn+0x192>
		argv_store[i] = UTEMP2USTACK(string_store);
  801592:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801598:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  80159e:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  8015a1:	83 ec 08             	sub    $0x8,%esp
  8015a4:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8015a7:	57                   	push   %edi
  8015a8:	e8 43 f4 ff ff       	call   8009f0 <strcpy>
		string_store += strlen(argv[i]) + 1;
  8015ad:	83 c4 04             	add    $0x4,%esp
  8015b0:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8015b3:	e8 ff f3 ff ff       	call   8009b7 <strlen>
  8015b8:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  8015bc:	83 c6 01             	add    $0x1,%esi
  8015bf:	83 c4 10             	add    $0x10,%esp
  8015c2:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  8015c8:	7f c8                	jg     801592 <spawn+0x162>
	}
	argv_store[argc] = 0;
  8015ca:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8015d0:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  8015d6:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8015dd:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  8015e3:	0f 85 86 00 00 00    	jne    80166f <spawn+0x23f>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8015e9:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  8015ef:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  8015f5:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  8015f8:	89 c8                	mov    %ecx,%eax
  8015fa:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  801600:	89 48 f8             	mov    %ecx,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801603:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801608:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80160e:	83 ec 0c             	sub    $0xc,%esp
  801611:	6a 07                	push   $0x7
  801613:	68 00 d0 bf ee       	push   $0xeebfd000
  801618:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80161e:	68 00 00 40 00       	push   $0x400000
  801623:	6a 00                	push   $0x0
  801625:	e8 fb f7 ff ff       	call   800e25 <sys_page_map>
  80162a:	89 c3                	mov    %eax,%ebx
  80162c:	83 c4 20             	add    $0x20,%esp
  80162f:	85 c0                	test   %eax,%eax
  801631:	0f 88 c2 02 00 00    	js     8018f9 <spawn+0x4c9>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801637:	83 ec 08             	sub    $0x8,%esp
  80163a:	68 00 00 40 00       	push   $0x400000
  80163f:	6a 00                	push   $0x0
  801641:	e8 21 f8 ff ff       	call   800e67 <sys_page_unmap>
  801646:	89 c3                	mov    %eax,%ebx
  801648:	83 c4 10             	add    $0x10,%esp
  80164b:	85 c0                	test   %eax,%eax
  80164d:	0f 88 a6 02 00 00    	js     8018f9 <spawn+0x4c9>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801653:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801659:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801660:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  801667:	00 00 00 
  80166a:	e9 4f 01 00 00       	jmp    8017be <spawn+0x38e>
	assert(string_store == (char*)UTEMP + PGSIZE);
  80166f:	68 78 31 80 00       	push   $0x803178
  801674:	68 09 31 80 00       	push   $0x803109
  801679:	68 f2 00 00 00       	push   $0xf2
  80167e:	68 1e 31 80 00       	push   $0x80311e
  801683:	e8 67 eb ff ff       	call   8001ef <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801688:	83 ec 04             	sub    $0x4,%esp
  80168b:	6a 07                	push   $0x7
  80168d:	68 00 00 40 00       	push   $0x400000
  801692:	6a 00                	push   $0x0
  801694:	e8 49 f7 ff ff       	call   800de2 <sys_page_alloc>
  801699:	83 c4 10             	add    $0x10,%esp
  80169c:	85 c0                	test   %eax,%eax
  80169e:	0f 88 33 02 00 00    	js     8018d7 <spawn+0x4a7>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8016a4:	83 ec 08             	sub    $0x8,%esp
  8016a7:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  8016ad:	01 f0                	add    %esi,%eax
  8016af:	50                   	push   %eax
  8016b0:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8016b6:	e8 ea 07 00 00       	call   801ea5 <seek>
  8016bb:	83 c4 10             	add    $0x10,%esp
  8016be:	85 c0                	test   %eax,%eax
  8016c0:	0f 88 18 02 00 00    	js     8018de <spawn+0x4ae>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8016c6:	83 ec 04             	sub    $0x4,%esp
  8016c9:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8016cf:	29 f0                	sub    %esi,%eax
  8016d1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016d6:	ba 00 10 00 00       	mov    $0x1000,%edx
  8016db:	0f 47 c2             	cmova  %edx,%eax
  8016de:	50                   	push   %eax
  8016df:	68 00 00 40 00       	push   $0x400000
  8016e4:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8016ea:	e8 ef 06 00 00       	call   801dde <readn>
  8016ef:	83 c4 10             	add    $0x10,%esp
  8016f2:	85 c0                	test   %eax,%eax
  8016f4:	0f 88 eb 01 00 00    	js     8018e5 <spawn+0x4b5>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8016fa:	83 ec 0c             	sub    $0xc,%esp
  8016fd:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801703:	53                   	push   %ebx
  801704:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  80170a:	68 00 00 40 00       	push   $0x400000
  80170f:	6a 00                	push   $0x0
  801711:	e8 0f f7 ff ff       	call   800e25 <sys_page_map>
  801716:	83 c4 20             	add    $0x20,%esp
  801719:	85 c0                	test   %eax,%eax
  80171b:	78 7c                	js     801799 <spawn+0x369>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  80171d:	83 ec 08             	sub    $0x8,%esp
  801720:	68 00 00 40 00       	push   $0x400000
  801725:	6a 00                	push   $0x0
  801727:	e8 3b f7 ff ff       	call   800e67 <sys_page_unmap>
  80172c:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  80172f:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801735:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80173b:	89 fe                	mov    %edi,%esi
  80173d:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801743:	76 69                	jbe    8017ae <spawn+0x37e>
		if (i >= filesz) {
  801745:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  80174b:	0f 87 37 ff ff ff    	ja     801688 <spawn+0x258>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801751:	83 ec 04             	sub    $0x4,%esp
  801754:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  80175a:	53                   	push   %ebx
  80175b:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801761:	e8 7c f6 ff ff       	call   800de2 <sys_page_alloc>
  801766:	83 c4 10             	add    $0x10,%esp
  801769:	85 c0                	test   %eax,%eax
  80176b:	79 c2                	jns    80172f <spawn+0x2ff>
  80176d:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  80176f:	83 ec 0c             	sub    $0xc,%esp
  801772:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801778:	e8 e6 f5 ff ff       	call   800d63 <sys_env_destroy>
	close(fd);
  80177d:	83 c4 04             	add    $0x4,%esp
  801780:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801786:	e8 8e 04 00 00       	call   801c19 <close>
	return r;
  80178b:	83 c4 10             	add    $0x10,%esp
  80178e:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801794:	e9 30 01 00 00       	jmp    8018c9 <spawn+0x499>
				panic("spawn: sys_page_map data: %e", r);
  801799:	50                   	push   %eax
  80179a:	68 2a 31 80 00       	push   $0x80312a
  80179f:	68 25 01 00 00       	push   $0x125
  8017a4:	68 1e 31 80 00       	push   $0x80311e
  8017a9:	e8 41 ea ff ff       	call   8001ef <_panic>
  8017ae:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8017b4:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  8017bb:	83 c6 20             	add    $0x20,%esi
  8017be:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  8017c5:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  8017cb:	7e 6d                	jle    80183a <spawn+0x40a>
		if (ph->p_type != ELF_PROG_LOAD)
  8017cd:	83 3e 01             	cmpl   $0x1,(%esi)
  8017d0:	75 e2                	jne    8017b4 <spawn+0x384>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8017d2:	8b 46 18             	mov    0x18(%esi),%eax
  8017d5:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  8017d8:	83 f8 01             	cmp    $0x1,%eax
  8017db:	19 c0                	sbb    %eax,%eax
  8017dd:	83 e0 fe             	and    $0xfffffffe,%eax
  8017e0:	83 c0 07             	add    $0x7,%eax
  8017e3:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  8017e9:	8b 4e 04             	mov    0x4(%esi),%ecx
  8017ec:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  8017f2:	8b 56 10             	mov    0x10(%esi),%edx
  8017f5:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  8017fb:	8b 7e 14             	mov    0x14(%esi),%edi
  8017fe:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  801804:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801807:	89 d8                	mov    %ebx,%eax
  801809:	25 ff 0f 00 00       	and    $0xfff,%eax
  80180e:	74 1a                	je     80182a <spawn+0x3fa>
		va -= i;
  801810:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801812:	01 c7                	add    %eax,%edi
  801814:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  80181a:	01 c2                	add    %eax,%edx
  80181c:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  801822:	29 c1                	sub    %eax,%ecx
  801824:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  80182a:	bf 00 00 00 00       	mov    $0x0,%edi
  80182f:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801835:	e9 01 ff ff ff       	jmp    80173b <spawn+0x30b>
	close(fd);
  80183a:	83 ec 0c             	sub    $0xc,%esp
  80183d:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801843:	e8 d1 03 00 00       	call   801c19 <close>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801848:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  80184f:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801852:	83 c4 08             	add    $0x8,%esp
  801855:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  80185b:	50                   	push   %eax
  80185c:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801862:	e8 84 f6 ff ff       	call   800eeb <sys_env_set_trapframe>
  801867:	83 c4 10             	add    $0x10,%esp
  80186a:	85 c0                	test   %eax,%eax
  80186c:	78 25                	js     801893 <spawn+0x463>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  80186e:	83 ec 08             	sub    $0x8,%esp
  801871:	6a 02                	push   $0x2
  801873:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801879:	e8 2b f6 ff ff       	call   800ea9 <sys_env_set_status>
  80187e:	83 c4 10             	add    $0x10,%esp
  801881:	85 c0                	test   %eax,%eax
  801883:	78 23                	js     8018a8 <spawn+0x478>
	return child;
  801885:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80188b:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801891:	eb 36                	jmp    8018c9 <spawn+0x499>
		panic("sys_env_set_trapframe: %e", r);
  801893:	50                   	push   %eax
  801894:	68 47 31 80 00       	push   $0x803147
  801899:	68 86 00 00 00       	push   $0x86
  80189e:	68 1e 31 80 00       	push   $0x80311e
  8018a3:	e8 47 e9 ff ff       	call   8001ef <_panic>
		panic("sys_env_set_status: %e", r);
  8018a8:	50                   	push   %eax
  8018a9:	68 61 31 80 00       	push   $0x803161
  8018ae:	68 89 00 00 00       	push   $0x89
  8018b3:	68 1e 31 80 00       	push   $0x80311e
  8018b8:	e8 32 e9 ff ff       	call   8001ef <_panic>
		return r;
  8018bd:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8018c3:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  8018c9:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8018cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018d2:	5b                   	pop    %ebx
  8018d3:	5e                   	pop    %esi
  8018d4:	5f                   	pop    %edi
  8018d5:	5d                   	pop    %ebp
  8018d6:	c3                   	ret    
  8018d7:	89 c7                	mov    %eax,%edi
  8018d9:	e9 91 fe ff ff       	jmp    80176f <spawn+0x33f>
  8018de:	89 c7                	mov    %eax,%edi
  8018e0:	e9 8a fe ff ff       	jmp    80176f <spawn+0x33f>
  8018e5:	89 c7                	mov    %eax,%edi
  8018e7:	e9 83 fe ff ff       	jmp    80176f <spawn+0x33f>
		return -E_NO_MEM;
  8018ec:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8018f1:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8018f7:	eb d0                	jmp    8018c9 <spawn+0x499>
	sys_page_unmap(0, UTEMP);
  8018f9:	83 ec 08             	sub    $0x8,%esp
  8018fc:	68 00 00 40 00       	push   $0x400000
  801901:	6a 00                	push   $0x0
  801903:	e8 5f f5 ff ff       	call   800e67 <sys_page_unmap>
  801908:	83 c4 10             	add    $0x10,%esp
  80190b:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801911:	eb b6                	jmp    8018c9 <spawn+0x499>

00801913 <spawnl>:
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
  801916:	57                   	push   %edi
  801917:	56                   	push   %esi
  801918:	53                   	push   %ebx
  801919:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  80191c:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  80191f:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801924:	8d 4a 04             	lea    0x4(%edx),%ecx
  801927:	83 3a 00             	cmpl   $0x0,(%edx)
  80192a:	74 07                	je     801933 <spawnl+0x20>
		argc++;
  80192c:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  80192f:	89 ca                	mov    %ecx,%edx
  801931:	eb f1                	jmp    801924 <spawnl+0x11>
	const char *argv[argc+2];
  801933:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  80193a:	83 e2 f0             	and    $0xfffffff0,%edx
  80193d:	29 d4                	sub    %edx,%esp
  80193f:	8d 54 24 03          	lea    0x3(%esp),%edx
  801943:	c1 ea 02             	shr    $0x2,%edx
  801946:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  80194d:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  80194f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801952:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801959:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801960:	00 
	va_start(vl, arg0);
  801961:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801964:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801966:	b8 00 00 00 00       	mov    $0x0,%eax
  80196b:	eb 0b                	jmp    801978 <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  80196d:	83 c0 01             	add    $0x1,%eax
  801970:	8b 39                	mov    (%ecx),%edi
  801972:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801975:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801978:	39 d0                	cmp    %edx,%eax
  80197a:	75 f1                	jne    80196d <spawnl+0x5a>
	return spawn(prog, argv);
  80197c:	83 ec 08             	sub    $0x8,%esp
  80197f:	56                   	push   %esi
  801980:	ff 75 08             	pushl  0x8(%ebp)
  801983:	e8 a8 fa ff ff       	call   801430 <spawn>
}
  801988:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80198b:	5b                   	pop    %ebx
  80198c:	5e                   	pop    %esi
  80198d:	5f                   	pop    %edi
  80198e:	5d                   	pop    %ebp
  80198f:	c3                   	ret    

00801990 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
  801993:	56                   	push   %esi
  801994:	53                   	push   %ebx
  801995:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  801998:	85 f6                	test   %esi,%esi
  80199a:	74 16                	je     8019b2 <wait+0x22>
	e = &envs[ENVX(envid)];
  80199c:	89 f3                	mov    %esi,%ebx
  80199e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8019a4:	69 db 84 00 00 00    	imul   $0x84,%ebx,%ebx
  8019aa:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8019b0:	eb 1b                	jmp    8019cd <wait+0x3d>
	assert(envid != 0);
  8019b2:	68 9e 31 80 00       	push   $0x80319e
  8019b7:	68 09 31 80 00       	push   $0x803109
  8019bc:	6a 09                	push   $0x9
  8019be:	68 a9 31 80 00       	push   $0x8031a9
  8019c3:	e8 27 e8 ff ff       	call   8001ef <_panic>
		sys_yield();
  8019c8:	e8 f6 f3 ff ff       	call   800dc3 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8019cd:	8b 43 48             	mov    0x48(%ebx),%eax
  8019d0:	39 f0                	cmp    %esi,%eax
  8019d2:	75 07                	jne    8019db <wait+0x4b>
  8019d4:	8b 43 54             	mov    0x54(%ebx),%eax
  8019d7:	85 c0                	test   %eax,%eax
  8019d9:	75 ed                	jne    8019c8 <wait+0x38>
}
  8019db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019de:	5b                   	pop    %ebx
  8019df:	5e                   	pop    %esi
  8019e0:	5d                   	pop    %ebp
  8019e1:	c3                   	ret    

008019e2 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
  8019e5:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8019e8:	83 3d 08 50 80 00 00 	cmpl   $0x0,0x805008
  8019ef:	74 0a                	je     8019fb <set_pgfault_handler+0x19>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	a3 08 50 80 00       	mov    %eax,0x805008
}
  8019f9:	c9                   	leave  
  8019fa:	c3                   	ret    
		ret = sys_page_alloc((envid_t)0, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W);
  8019fb:	83 ec 04             	sub    $0x4,%esp
  8019fe:	6a 07                	push   $0x7
  801a00:	68 00 f0 bf ee       	push   $0xeebff000
  801a05:	6a 00                	push   $0x0
  801a07:	e8 d6 f3 ff ff       	call   800de2 <sys_page_alloc>
		if(ret < 0){
  801a0c:	83 c4 10             	add    $0x10,%esp
  801a0f:	85 c0                	test   %eax,%eax
  801a11:	78 28                	js     801a3b <set_pgfault_handler+0x59>
    	ret = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  801a13:	83 ec 08             	sub    $0x8,%esp
  801a16:	68 4d 1a 80 00       	push   $0x801a4d
  801a1b:	6a 00                	push   $0x0
  801a1d:	e8 0b f5 ff ff       	call   800f2d <sys_env_set_pgfault_upcall>
		if(ret < 0){
  801a22:	83 c4 10             	add    $0x10,%esp
  801a25:	85 c0                	test   %eax,%eax
  801a27:	79 c8                	jns    8019f1 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: sys_env_set_pgfault_upcall fail, ret:%d", ret);
  801a29:	50                   	push   %eax
  801a2a:	68 e8 31 80 00       	push   $0x8031e8
  801a2f:	6a 28                	push   $0x28
  801a31:	68 25 32 80 00       	push   $0x803225
  801a36:	e8 b4 e7 ff ff       	call   8001ef <_panic>
			panic("set_pgfault_handler: sys_page_alloc fail, ret:%d", ret);
  801a3b:	50                   	push   %eax
  801a3c:	68 b4 31 80 00       	push   $0x8031b4
  801a41:	6a 24                	push   $0x24
  801a43:	68 25 32 80 00       	push   $0x803225
  801a48:	e8 a2 e7 ff ff       	call   8001ef <_panic>

00801a4d <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801a4d:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801a4e:	a1 08 50 80 00       	mov    0x805008,%eax
	call *%eax
  801a53:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801a55:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edi
  801a58:	8b 7c 24 28          	mov    0x28(%esp),%edi
	movl 0x30(%esp), %esi
  801a5c:	8b 74 24 30          	mov    0x30(%esp),%esi
	subl $4, %esi
  801a60:	83 ee 04             	sub    $0x4,%esi
	movl %edi, (%esi)
  801a63:	89 3e                	mov    %edi,(%esi)
	movl %esi, 0x30(%esp)
  801a65:	89 74 24 30          	mov    %esi,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  801a69:	83 c4 08             	add    $0x8,%esp
	popal
  801a6c:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  801a6d:	83 c4 04             	add    $0x4,%esp
	popfl
  801a70:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801a71:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  801a72:	c3                   	ret    

00801a73 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801a76:	8b 45 08             	mov    0x8(%ebp),%eax
  801a79:	05 00 00 00 30       	add    $0x30000000,%eax
  801a7e:	c1 e8 0c             	shr    $0xc,%eax
}
  801a81:	5d                   	pop    %ebp
  801a82:	c3                   	ret    

00801a83 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801a86:	8b 45 08             	mov    0x8(%ebp),%eax
  801a89:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801a8e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a93:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801a98:	5d                   	pop    %ebp
  801a99:	c3                   	ret    

00801a9a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
  801a9d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801aa2:	89 c2                	mov    %eax,%edx
  801aa4:	c1 ea 16             	shr    $0x16,%edx
  801aa7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801aae:	f6 c2 01             	test   $0x1,%dl
  801ab1:	74 2d                	je     801ae0 <fd_alloc+0x46>
  801ab3:	89 c2                	mov    %eax,%edx
  801ab5:	c1 ea 0c             	shr    $0xc,%edx
  801ab8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801abf:	f6 c2 01             	test   $0x1,%dl
  801ac2:	74 1c                	je     801ae0 <fd_alloc+0x46>
  801ac4:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801ac9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801ace:	75 d2                	jne    801aa2 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801ad9:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801ade:	eb 0a                	jmp    801aea <fd_alloc+0x50>
			*fd_store = fd;
  801ae0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ae3:	89 01                	mov    %eax,(%ecx)
			return 0;
  801ae5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aea:	5d                   	pop    %ebp
  801aeb:	c3                   	ret    

00801aec <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
  801aef:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801af2:	83 f8 1f             	cmp    $0x1f,%eax
  801af5:	77 30                	ja     801b27 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801af7:	c1 e0 0c             	shl    $0xc,%eax
  801afa:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801aff:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801b05:	f6 c2 01             	test   $0x1,%dl
  801b08:	74 24                	je     801b2e <fd_lookup+0x42>
  801b0a:	89 c2                	mov    %eax,%edx
  801b0c:	c1 ea 0c             	shr    $0xc,%edx
  801b0f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801b16:	f6 c2 01             	test   $0x1,%dl
  801b19:	74 1a                	je     801b35 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801b1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1e:	89 02                	mov    %eax,(%edx)
	return 0;
  801b20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b25:	5d                   	pop    %ebp
  801b26:	c3                   	ret    
		return -E_INVAL;
  801b27:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b2c:	eb f7                	jmp    801b25 <fd_lookup+0x39>
		return -E_INVAL;
  801b2e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b33:	eb f0                	jmp    801b25 <fd_lookup+0x39>
  801b35:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b3a:	eb e9                	jmp    801b25 <fd_lookup+0x39>

00801b3c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
  801b3f:	83 ec 08             	sub    $0x8,%esp
  801b42:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b45:	ba b4 32 80 00       	mov    $0x8032b4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801b4a:	b8 0c 40 80 00       	mov    $0x80400c,%eax
		if (devtab[i]->dev_id == dev_id) {
  801b4f:	39 08                	cmp    %ecx,(%eax)
  801b51:	74 33                	je     801b86 <dev_lookup+0x4a>
  801b53:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801b56:	8b 02                	mov    (%edx),%eax
  801b58:	85 c0                	test   %eax,%eax
  801b5a:	75 f3                	jne    801b4f <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801b5c:	a1 04 50 80 00       	mov    0x805004,%eax
  801b61:	8b 40 48             	mov    0x48(%eax),%eax
  801b64:	83 ec 04             	sub    $0x4,%esp
  801b67:	51                   	push   %ecx
  801b68:	50                   	push   %eax
  801b69:	68 34 32 80 00       	push   $0x803234
  801b6e:	e8 57 e7 ff ff       	call   8002ca <cprintf>
	*dev = 0;
  801b73:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b76:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801b7c:	83 c4 10             	add    $0x10,%esp
  801b7f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801b84:	c9                   	leave  
  801b85:	c3                   	ret    
			*dev = devtab[i];
  801b86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b89:	89 01                	mov    %eax,(%ecx)
			return 0;
  801b8b:	b8 00 00 00 00       	mov    $0x0,%eax
  801b90:	eb f2                	jmp    801b84 <dev_lookup+0x48>

00801b92 <fd_close>:
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
  801b95:	57                   	push   %edi
  801b96:	56                   	push   %esi
  801b97:	53                   	push   %ebx
  801b98:	83 ec 24             	sub    $0x24,%esp
  801b9b:	8b 75 08             	mov    0x8(%ebp),%esi
  801b9e:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801ba1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801ba4:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801ba5:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801bab:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801bae:	50                   	push   %eax
  801baf:	e8 38 ff ff ff       	call   801aec <fd_lookup>
  801bb4:	89 c3                	mov    %eax,%ebx
  801bb6:	83 c4 10             	add    $0x10,%esp
  801bb9:	85 c0                	test   %eax,%eax
  801bbb:	78 05                	js     801bc2 <fd_close+0x30>
	    || fd != fd2)
  801bbd:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801bc0:	74 16                	je     801bd8 <fd_close+0x46>
		return (must_exist ? r : 0);
  801bc2:	89 f8                	mov    %edi,%eax
  801bc4:	84 c0                	test   %al,%al
  801bc6:	b8 00 00 00 00       	mov    $0x0,%eax
  801bcb:	0f 44 d8             	cmove  %eax,%ebx
}
  801bce:	89 d8                	mov    %ebx,%eax
  801bd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bd3:	5b                   	pop    %ebx
  801bd4:	5e                   	pop    %esi
  801bd5:	5f                   	pop    %edi
  801bd6:	5d                   	pop    %ebp
  801bd7:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801bd8:	83 ec 08             	sub    $0x8,%esp
  801bdb:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801bde:	50                   	push   %eax
  801bdf:	ff 36                	pushl  (%esi)
  801be1:	e8 56 ff ff ff       	call   801b3c <dev_lookup>
  801be6:	89 c3                	mov    %eax,%ebx
  801be8:	83 c4 10             	add    $0x10,%esp
  801beb:	85 c0                	test   %eax,%eax
  801bed:	78 1a                	js     801c09 <fd_close+0x77>
		if (dev->dev_close)
  801bef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bf2:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801bf5:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801bfa:	85 c0                	test   %eax,%eax
  801bfc:	74 0b                	je     801c09 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801bfe:	83 ec 0c             	sub    $0xc,%esp
  801c01:	56                   	push   %esi
  801c02:	ff d0                	call   *%eax
  801c04:	89 c3                	mov    %eax,%ebx
  801c06:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801c09:	83 ec 08             	sub    $0x8,%esp
  801c0c:	56                   	push   %esi
  801c0d:	6a 00                	push   $0x0
  801c0f:	e8 53 f2 ff ff       	call   800e67 <sys_page_unmap>
	return r;
  801c14:	83 c4 10             	add    $0x10,%esp
  801c17:	eb b5                	jmp    801bce <fd_close+0x3c>

00801c19 <close>:

int
close(int fdnum)
{
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
  801c1c:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c1f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c22:	50                   	push   %eax
  801c23:	ff 75 08             	pushl  0x8(%ebp)
  801c26:	e8 c1 fe ff ff       	call   801aec <fd_lookup>
  801c2b:	83 c4 10             	add    $0x10,%esp
  801c2e:	85 c0                	test   %eax,%eax
  801c30:	79 02                	jns    801c34 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    
		return fd_close(fd, 1);
  801c34:	83 ec 08             	sub    $0x8,%esp
  801c37:	6a 01                	push   $0x1
  801c39:	ff 75 f4             	pushl  -0xc(%ebp)
  801c3c:	e8 51 ff ff ff       	call   801b92 <fd_close>
  801c41:	83 c4 10             	add    $0x10,%esp
  801c44:	eb ec                	jmp    801c32 <close+0x19>

00801c46 <close_all>:

void
close_all(void)
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
  801c49:	53                   	push   %ebx
  801c4a:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801c4d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801c52:	83 ec 0c             	sub    $0xc,%esp
  801c55:	53                   	push   %ebx
  801c56:	e8 be ff ff ff       	call   801c19 <close>
	for (i = 0; i < MAXFD; i++)
  801c5b:	83 c3 01             	add    $0x1,%ebx
  801c5e:	83 c4 10             	add    $0x10,%esp
  801c61:	83 fb 20             	cmp    $0x20,%ebx
  801c64:	75 ec                	jne    801c52 <close_all+0xc>
}
  801c66:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
  801c6e:	57                   	push   %edi
  801c6f:	56                   	push   %esi
  801c70:	53                   	push   %ebx
  801c71:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801c74:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801c77:	50                   	push   %eax
  801c78:	ff 75 08             	pushl  0x8(%ebp)
  801c7b:	e8 6c fe ff ff       	call   801aec <fd_lookup>
  801c80:	89 c3                	mov    %eax,%ebx
  801c82:	83 c4 10             	add    $0x10,%esp
  801c85:	85 c0                	test   %eax,%eax
  801c87:	0f 88 81 00 00 00    	js     801d0e <dup+0xa3>
		return r;
	close(newfdnum);
  801c8d:	83 ec 0c             	sub    $0xc,%esp
  801c90:	ff 75 0c             	pushl  0xc(%ebp)
  801c93:	e8 81 ff ff ff       	call   801c19 <close>

	newfd = INDEX2FD(newfdnum);
  801c98:	8b 75 0c             	mov    0xc(%ebp),%esi
  801c9b:	c1 e6 0c             	shl    $0xc,%esi
  801c9e:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801ca4:	83 c4 04             	add    $0x4,%esp
  801ca7:	ff 75 e4             	pushl  -0x1c(%ebp)
  801caa:	e8 d4 fd ff ff       	call   801a83 <fd2data>
  801caf:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801cb1:	89 34 24             	mov    %esi,(%esp)
  801cb4:	e8 ca fd ff ff       	call   801a83 <fd2data>
  801cb9:	83 c4 10             	add    $0x10,%esp
  801cbc:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801cbe:	89 d8                	mov    %ebx,%eax
  801cc0:	c1 e8 16             	shr    $0x16,%eax
  801cc3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801cca:	a8 01                	test   $0x1,%al
  801ccc:	74 11                	je     801cdf <dup+0x74>
  801cce:	89 d8                	mov    %ebx,%eax
  801cd0:	c1 e8 0c             	shr    $0xc,%eax
  801cd3:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801cda:	f6 c2 01             	test   $0x1,%dl
  801cdd:	75 39                	jne    801d18 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801cdf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ce2:	89 d0                	mov    %edx,%eax
  801ce4:	c1 e8 0c             	shr    $0xc,%eax
  801ce7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801cee:	83 ec 0c             	sub    $0xc,%esp
  801cf1:	25 07 0e 00 00       	and    $0xe07,%eax
  801cf6:	50                   	push   %eax
  801cf7:	56                   	push   %esi
  801cf8:	6a 00                	push   $0x0
  801cfa:	52                   	push   %edx
  801cfb:	6a 00                	push   $0x0
  801cfd:	e8 23 f1 ff ff       	call   800e25 <sys_page_map>
  801d02:	89 c3                	mov    %eax,%ebx
  801d04:	83 c4 20             	add    $0x20,%esp
  801d07:	85 c0                	test   %eax,%eax
  801d09:	78 31                	js     801d3c <dup+0xd1>
		goto err;

	return newfdnum;
  801d0b:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801d0e:	89 d8                	mov    %ebx,%eax
  801d10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d13:	5b                   	pop    %ebx
  801d14:	5e                   	pop    %esi
  801d15:	5f                   	pop    %edi
  801d16:	5d                   	pop    %ebp
  801d17:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801d18:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801d1f:	83 ec 0c             	sub    $0xc,%esp
  801d22:	25 07 0e 00 00       	and    $0xe07,%eax
  801d27:	50                   	push   %eax
  801d28:	57                   	push   %edi
  801d29:	6a 00                	push   $0x0
  801d2b:	53                   	push   %ebx
  801d2c:	6a 00                	push   $0x0
  801d2e:	e8 f2 f0 ff ff       	call   800e25 <sys_page_map>
  801d33:	89 c3                	mov    %eax,%ebx
  801d35:	83 c4 20             	add    $0x20,%esp
  801d38:	85 c0                	test   %eax,%eax
  801d3a:	79 a3                	jns    801cdf <dup+0x74>
	sys_page_unmap(0, newfd);
  801d3c:	83 ec 08             	sub    $0x8,%esp
  801d3f:	56                   	push   %esi
  801d40:	6a 00                	push   $0x0
  801d42:	e8 20 f1 ff ff       	call   800e67 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801d47:	83 c4 08             	add    $0x8,%esp
  801d4a:	57                   	push   %edi
  801d4b:	6a 00                	push   $0x0
  801d4d:	e8 15 f1 ff ff       	call   800e67 <sys_page_unmap>
	return r;
  801d52:	83 c4 10             	add    $0x10,%esp
  801d55:	eb b7                	jmp    801d0e <dup+0xa3>

00801d57 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
  801d5a:	53                   	push   %ebx
  801d5b:	83 ec 1c             	sub    $0x1c,%esp
  801d5e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d61:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d64:	50                   	push   %eax
  801d65:	53                   	push   %ebx
  801d66:	e8 81 fd ff ff       	call   801aec <fd_lookup>
  801d6b:	83 c4 10             	add    $0x10,%esp
  801d6e:	85 c0                	test   %eax,%eax
  801d70:	78 3f                	js     801db1 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d72:	83 ec 08             	sub    $0x8,%esp
  801d75:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d78:	50                   	push   %eax
  801d79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d7c:	ff 30                	pushl  (%eax)
  801d7e:	e8 b9 fd ff ff       	call   801b3c <dev_lookup>
  801d83:	83 c4 10             	add    $0x10,%esp
  801d86:	85 c0                	test   %eax,%eax
  801d88:	78 27                	js     801db1 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801d8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d8d:	8b 42 08             	mov    0x8(%edx),%eax
  801d90:	83 e0 03             	and    $0x3,%eax
  801d93:	83 f8 01             	cmp    $0x1,%eax
  801d96:	74 1e                	je     801db6 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9b:	8b 40 08             	mov    0x8(%eax),%eax
  801d9e:	85 c0                	test   %eax,%eax
  801da0:	74 35                	je     801dd7 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801da2:	83 ec 04             	sub    $0x4,%esp
  801da5:	ff 75 10             	pushl  0x10(%ebp)
  801da8:	ff 75 0c             	pushl  0xc(%ebp)
  801dab:	52                   	push   %edx
  801dac:	ff d0                	call   *%eax
  801dae:	83 c4 10             	add    $0x10,%esp
}
  801db1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801db4:	c9                   	leave  
  801db5:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801db6:	a1 04 50 80 00       	mov    0x805004,%eax
  801dbb:	8b 40 48             	mov    0x48(%eax),%eax
  801dbe:	83 ec 04             	sub    $0x4,%esp
  801dc1:	53                   	push   %ebx
  801dc2:	50                   	push   %eax
  801dc3:	68 78 32 80 00       	push   $0x803278
  801dc8:	e8 fd e4 ff ff       	call   8002ca <cprintf>
		return -E_INVAL;
  801dcd:	83 c4 10             	add    $0x10,%esp
  801dd0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801dd5:	eb da                	jmp    801db1 <read+0x5a>
		return -E_NOT_SUPP;
  801dd7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ddc:	eb d3                	jmp    801db1 <read+0x5a>

00801dde <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801dde:	55                   	push   %ebp
  801ddf:	89 e5                	mov    %esp,%ebp
  801de1:	57                   	push   %edi
  801de2:	56                   	push   %esi
  801de3:	53                   	push   %ebx
  801de4:	83 ec 0c             	sub    $0xc,%esp
  801de7:	8b 7d 08             	mov    0x8(%ebp),%edi
  801dea:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801ded:	bb 00 00 00 00       	mov    $0x0,%ebx
  801df2:	39 f3                	cmp    %esi,%ebx
  801df4:	73 23                	jae    801e19 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801df6:	83 ec 04             	sub    $0x4,%esp
  801df9:	89 f0                	mov    %esi,%eax
  801dfb:	29 d8                	sub    %ebx,%eax
  801dfd:	50                   	push   %eax
  801dfe:	89 d8                	mov    %ebx,%eax
  801e00:	03 45 0c             	add    0xc(%ebp),%eax
  801e03:	50                   	push   %eax
  801e04:	57                   	push   %edi
  801e05:	e8 4d ff ff ff       	call   801d57 <read>
		if (m < 0)
  801e0a:	83 c4 10             	add    $0x10,%esp
  801e0d:	85 c0                	test   %eax,%eax
  801e0f:	78 06                	js     801e17 <readn+0x39>
			return m;
		if (m == 0)
  801e11:	74 06                	je     801e19 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801e13:	01 c3                	add    %eax,%ebx
  801e15:	eb db                	jmp    801df2 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801e17:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801e19:	89 d8                	mov    %ebx,%eax
  801e1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e1e:	5b                   	pop    %ebx
  801e1f:	5e                   	pop    %esi
  801e20:	5f                   	pop    %edi
  801e21:	5d                   	pop    %ebp
  801e22:	c3                   	ret    

00801e23 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
  801e26:	53                   	push   %ebx
  801e27:	83 ec 1c             	sub    $0x1c,%esp
  801e2a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801e2d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e30:	50                   	push   %eax
  801e31:	53                   	push   %ebx
  801e32:	e8 b5 fc ff ff       	call   801aec <fd_lookup>
  801e37:	83 c4 10             	add    $0x10,%esp
  801e3a:	85 c0                	test   %eax,%eax
  801e3c:	78 3a                	js     801e78 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801e3e:	83 ec 08             	sub    $0x8,%esp
  801e41:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e44:	50                   	push   %eax
  801e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e48:	ff 30                	pushl  (%eax)
  801e4a:	e8 ed fc ff ff       	call   801b3c <dev_lookup>
  801e4f:	83 c4 10             	add    $0x10,%esp
  801e52:	85 c0                	test   %eax,%eax
  801e54:	78 22                	js     801e78 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801e56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e59:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801e5d:	74 1e                	je     801e7d <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801e5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e62:	8b 52 0c             	mov    0xc(%edx),%edx
  801e65:	85 d2                	test   %edx,%edx
  801e67:	74 35                	je     801e9e <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801e69:	83 ec 04             	sub    $0x4,%esp
  801e6c:	ff 75 10             	pushl  0x10(%ebp)
  801e6f:	ff 75 0c             	pushl  0xc(%ebp)
  801e72:	50                   	push   %eax
  801e73:	ff d2                	call   *%edx
  801e75:	83 c4 10             	add    $0x10,%esp
}
  801e78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e7b:	c9                   	leave  
  801e7c:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801e7d:	a1 04 50 80 00       	mov    0x805004,%eax
  801e82:	8b 40 48             	mov    0x48(%eax),%eax
  801e85:	83 ec 04             	sub    $0x4,%esp
  801e88:	53                   	push   %ebx
  801e89:	50                   	push   %eax
  801e8a:	68 94 32 80 00       	push   $0x803294
  801e8f:	e8 36 e4 ff ff       	call   8002ca <cprintf>
		return -E_INVAL;
  801e94:	83 c4 10             	add    $0x10,%esp
  801e97:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e9c:	eb da                	jmp    801e78 <write+0x55>
		return -E_NOT_SUPP;
  801e9e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ea3:	eb d3                	jmp    801e78 <write+0x55>

00801ea5 <seek>:

int
seek(int fdnum, off_t offset)
{
  801ea5:	55                   	push   %ebp
  801ea6:	89 e5                	mov    %esp,%ebp
  801ea8:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801eab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eae:	50                   	push   %eax
  801eaf:	ff 75 08             	pushl  0x8(%ebp)
  801eb2:	e8 35 fc ff ff       	call   801aec <fd_lookup>
  801eb7:	83 c4 10             	add    $0x10,%esp
  801eba:	85 c0                	test   %eax,%eax
  801ebc:	78 0e                	js     801ecc <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801ebe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec4:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801ec7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ecc:	c9                   	leave  
  801ecd:	c3                   	ret    

00801ece <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801ece:	55                   	push   %ebp
  801ecf:	89 e5                	mov    %esp,%ebp
  801ed1:	53                   	push   %ebx
  801ed2:	83 ec 1c             	sub    $0x1c,%esp
  801ed5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ed8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801edb:	50                   	push   %eax
  801edc:	53                   	push   %ebx
  801edd:	e8 0a fc ff ff       	call   801aec <fd_lookup>
  801ee2:	83 c4 10             	add    $0x10,%esp
  801ee5:	85 c0                	test   %eax,%eax
  801ee7:	78 37                	js     801f20 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ee9:	83 ec 08             	sub    $0x8,%esp
  801eec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eef:	50                   	push   %eax
  801ef0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef3:	ff 30                	pushl  (%eax)
  801ef5:	e8 42 fc ff ff       	call   801b3c <dev_lookup>
  801efa:	83 c4 10             	add    $0x10,%esp
  801efd:	85 c0                	test   %eax,%eax
  801eff:	78 1f                	js     801f20 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801f01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f04:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801f08:	74 1b                	je     801f25 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801f0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f0d:	8b 52 18             	mov    0x18(%edx),%edx
  801f10:	85 d2                	test   %edx,%edx
  801f12:	74 32                	je     801f46 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801f14:	83 ec 08             	sub    $0x8,%esp
  801f17:	ff 75 0c             	pushl  0xc(%ebp)
  801f1a:	50                   	push   %eax
  801f1b:	ff d2                	call   *%edx
  801f1d:	83 c4 10             	add    $0x10,%esp
}
  801f20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f23:	c9                   	leave  
  801f24:	c3                   	ret    
			thisenv->env_id, fdnum);
  801f25:	a1 04 50 80 00       	mov    0x805004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801f2a:	8b 40 48             	mov    0x48(%eax),%eax
  801f2d:	83 ec 04             	sub    $0x4,%esp
  801f30:	53                   	push   %ebx
  801f31:	50                   	push   %eax
  801f32:	68 54 32 80 00       	push   $0x803254
  801f37:	e8 8e e3 ff ff       	call   8002ca <cprintf>
		return -E_INVAL;
  801f3c:	83 c4 10             	add    $0x10,%esp
  801f3f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f44:	eb da                	jmp    801f20 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801f46:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f4b:	eb d3                	jmp    801f20 <ftruncate+0x52>

00801f4d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
  801f50:	53                   	push   %ebx
  801f51:	83 ec 1c             	sub    $0x1c,%esp
  801f54:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801f57:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f5a:	50                   	push   %eax
  801f5b:	ff 75 08             	pushl  0x8(%ebp)
  801f5e:	e8 89 fb ff ff       	call   801aec <fd_lookup>
  801f63:	83 c4 10             	add    $0x10,%esp
  801f66:	85 c0                	test   %eax,%eax
  801f68:	78 4b                	js     801fb5 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801f6a:	83 ec 08             	sub    $0x8,%esp
  801f6d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f70:	50                   	push   %eax
  801f71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f74:	ff 30                	pushl  (%eax)
  801f76:	e8 c1 fb ff ff       	call   801b3c <dev_lookup>
  801f7b:	83 c4 10             	add    $0x10,%esp
  801f7e:	85 c0                	test   %eax,%eax
  801f80:	78 33                	js     801fb5 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f85:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801f89:	74 2f                	je     801fba <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801f8b:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801f8e:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801f95:	00 00 00 
	stat->st_isdir = 0;
  801f98:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801f9f:	00 00 00 
	stat->st_dev = dev;
  801fa2:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801fa8:	83 ec 08             	sub    $0x8,%esp
  801fab:	53                   	push   %ebx
  801fac:	ff 75 f0             	pushl  -0x10(%ebp)
  801faf:	ff 50 14             	call   *0x14(%eax)
  801fb2:	83 c4 10             	add    $0x10,%esp
}
  801fb5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fb8:	c9                   	leave  
  801fb9:	c3                   	ret    
		return -E_NOT_SUPP;
  801fba:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801fbf:	eb f4                	jmp    801fb5 <fstat+0x68>

00801fc1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
  801fc4:	56                   	push   %esi
  801fc5:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801fc6:	83 ec 08             	sub    $0x8,%esp
  801fc9:	6a 00                	push   $0x0
  801fcb:	ff 75 08             	pushl  0x8(%ebp)
  801fce:	e8 bb 01 00 00       	call   80218e <open>
  801fd3:	89 c3                	mov    %eax,%ebx
  801fd5:	83 c4 10             	add    $0x10,%esp
  801fd8:	85 c0                	test   %eax,%eax
  801fda:	78 1b                	js     801ff7 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801fdc:	83 ec 08             	sub    $0x8,%esp
  801fdf:	ff 75 0c             	pushl  0xc(%ebp)
  801fe2:	50                   	push   %eax
  801fe3:	e8 65 ff ff ff       	call   801f4d <fstat>
  801fe8:	89 c6                	mov    %eax,%esi
	close(fd);
  801fea:	89 1c 24             	mov    %ebx,(%esp)
  801fed:	e8 27 fc ff ff       	call   801c19 <close>
	return r;
  801ff2:	83 c4 10             	add    $0x10,%esp
  801ff5:	89 f3                	mov    %esi,%ebx
}
  801ff7:	89 d8                	mov    %ebx,%eax
  801ff9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ffc:	5b                   	pop    %ebx
  801ffd:	5e                   	pop    %esi
  801ffe:	5d                   	pop    %ebp
  801fff:	c3                   	ret    

00802000 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
  802003:	56                   	push   %esi
  802004:	53                   	push   %ebx
  802005:	89 c6                	mov    %eax,%esi
  802007:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  802009:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  802010:	74 27                	je     802039 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802012:	6a 07                	push   $0x7
  802014:	68 00 60 80 00       	push   $0x806000
  802019:	56                   	push   %esi
  80201a:	ff 35 00 50 80 00    	pushl  0x805000
  802020:	e8 3a 07 00 00       	call   80275f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  802025:	83 c4 0c             	add    $0xc,%esp
  802028:	6a 00                	push   $0x0
  80202a:	53                   	push   %ebx
  80202b:	6a 00                	push   $0x0
  80202d:	e8 c4 06 00 00       	call   8026f6 <ipc_recv>
}
  802032:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802035:	5b                   	pop    %ebx
  802036:	5e                   	pop    %esi
  802037:	5d                   	pop    %ebp
  802038:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802039:	83 ec 0c             	sub    $0xc,%esp
  80203c:	6a 01                	push   $0x1
  80203e:	e8 69 07 00 00       	call   8027ac <ipc_find_env>
  802043:	a3 00 50 80 00       	mov    %eax,0x805000
  802048:	83 c4 10             	add    $0x10,%esp
  80204b:	eb c5                	jmp    802012 <fsipc+0x12>

0080204d <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80204d:	55                   	push   %ebp
  80204e:	89 e5                	mov    %esp,%ebp
  802050:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802053:	8b 45 08             	mov    0x8(%ebp),%eax
  802056:	8b 40 0c             	mov    0xc(%eax),%eax
  802059:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  80205e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802061:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  802066:	ba 00 00 00 00       	mov    $0x0,%edx
  80206b:	b8 02 00 00 00       	mov    $0x2,%eax
  802070:	e8 8b ff ff ff       	call   802000 <fsipc>
}
  802075:	c9                   	leave  
  802076:	c3                   	ret    

00802077 <devfile_flush>:
{
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
  80207a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80207d:	8b 45 08             	mov    0x8(%ebp),%eax
  802080:	8b 40 0c             	mov    0xc(%eax),%eax
  802083:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  802088:	ba 00 00 00 00       	mov    $0x0,%edx
  80208d:	b8 06 00 00 00       	mov    $0x6,%eax
  802092:	e8 69 ff ff ff       	call   802000 <fsipc>
}
  802097:	c9                   	leave  
  802098:	c3                   	ret    

00802099 <devfile_stat>:
{
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
  80209c:	53                   	push   %ebx
  80209d:	83 ec 04             	sub    $0x4,%esp
  8020a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8020a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8020a9:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8020ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8020b3:	b8 05 00 00 00       	mov    $0x5,%eax
  8020b8:	e8 43 ff ff ff       	call   802000 <fsipc>
  8020bd:	85 c0                	test   %eax,%eax
  8020bf:	78 2c                	js     8020ed <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8020c1:	83 ec 08             	sub    $0x8,%esp
  8020c4:	68 00 60 80 00       	push   $0x806000
  8020c9:	53                   	push   %ebx
  8020ca:	e8 21 e9 ff ff       	call   8009f0 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8020cf:	a1 80 60 80 00       	mov    0x806080,%eax
  8020d4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8020da:	a1 84 60 80 00       	mov    0x806084,%eax
  8020df:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8020e5:	83 c4 10             	add    $0x10,%esp
  8020e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020f0:	c9                   	leave  
  8020f1:	c3                   	ret    

008020f2 <devfile_write>:
{
  8020f2:	55                   	push   %ebp
  8020f3:	89 e5                	mov    %esp,%ebp
  8020f5:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  8020f8:	68 c4 32 80 00       	push   $0x8032c4
  8020fd:	68 90 00 00 00       	push   $0x90
  802102:	68 e2 32 80 00       	push   $0x8032e2
  802107:	e8 e3 e0 ff ff       	call   8001ef <_panic>

0080210c <devfile_read>:
{
  80210c:	55                   	push   %ebp
  80210d:	89 e5                	mov    %esp,%ebp
  80210f:	56                   	push   %esi
  802110:	53                   	push   %ebx
  802111:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802114:	8b 45 08             	mov    0x8(%ebp),%eax
  802117:	8b 40 0c             	mov    0xc(%eax),%eax
  80211a:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  80211f:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802125:	ba 00 00 00 00       	mov    $0x0,%edx
  80212a:	b8 03 00 00 00       	mov    $0x3,%eax
  80212f:	e8 cc fe ff ff       	call   802000 <fsipc>
  802134:	89 c3                	mov    %eax,%ebx
  802136:	85 c0                	test   %eax,%eax
  802138:	78 1f                	js     802159 <devfile_read+0x4d>
	assert(r <= n);
  80213a:	39 f0                	cmp    %esi,%eax
  80213c:	77 24                	ja     802162 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80213e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802143:	7f 33                	jg     802178 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802145:	83 ec 04             	sub    $0x4,%esp
  802148:	50                   	push   %eax
  802149:	68 00 60 80 00       	push   $0x806000
  80214e:	ff 75 0c             	pushl  0xc(%ebp)
  802151:	e8 28 ea ff ff       	call   800b7e <memmove>
	return r;
  802156:	83 c4 10             	add    $0x10,%esp
}
  802159:	89 d8                	mov    %ebx,%eax
  80215b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80215e:	5b                   	pop    %ebx
  80215f:	5e                   	pop    %esi
  802160:	5d                   	pop    %ebp
  802161:	c3                   	ret    
	assert(r <= n);
  802162:	68 ed 32 80 00       	push   $0x8032ed
  802167:	68 09 31 80 00       	push   $0x803109
  80216c:	6a 7c                	push   $0x7c
  80216e:	68 e2 32 80 00       	push   $0x8032e2
  802173:	e8 77 e0 ff ff       	call   8001ef <_panic>
	assert(r <= PGSIZE);
  802178:	68 f4 32 80 00       	push   $0x8032f4
  80217d:	68 09 31 80 00       	push   $0x803109
  802182:	6a 7d                	push   $0x7d
  802184:	68 e2 32 80 00       	push   $0x8032e2
  802189:	e8 61 e0 ff ff       	call   8001ef <_panic>

0080218e <open>:
{
  80218e:	55                   	push   %ebp
  80218f:	89 e5                	mov    %esp,%ebp
  802191:	56                   	push   %esi
  802192:	53                   	push   %ebx
  802193:	83 ec 1c             	sub    $0x1c,%esp
  802196:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  802199:	56                   	push   %esi
  80219a:	e8 18 e8 ff ff       	call   8009b7 <strlen>
  80219f:	83 c4 10             	add    $0x10,%esp
  8021a2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8021a7:	7f 6c                	jg     802215 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8021a9:	83 ec 0c             	sub    $0xc,%esp
  8021ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021af:	50                   	push   %eax
  8021b0:	e8 e5 f8 ff ff       	call   801a9a <fd_alloc>
  8021b5:	89 c3                	mov    %eax,%ebx
  8021b7:	83 c4 10             	add    $0x10,%esp
  8021ba:	85 c0                	test   %eax,%eax
  8021bc:	78 3c                	js     8021fa <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8021be:	83 ec 08             	sub    $0x8,%esp
  8021c1:	56                   	push   %esi
  8021c2:	68 00 60 80 00       	push   $0x806000
  8021c7:	e8 24 e8 ff ff       	call   8009f0 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8021cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021cf:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8021d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8021dc:	e8 1f fe ff ff       	call   802000 <fsipc>
  8021e1:	89 c3                	mov    %eax,%ebx
  8021e3:	83 c4 10             	add    $0x10,%esp
  8021e6:	85 c0                	test   %eax,%eax
  8021e8:	78 19                	js     802203 <open+0x75>
	return fd2num(fd);
  8021ea:	83 ec 0c             	sub    $0xc,%esp
  8021ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8021f0:	e8 7e f8 ff ff       	call   801a73 <fd2num>
  8021f5:	89 c3                	mov    %eax,%ebx
  8021f7:	83 c4 10             	add    $0x10,%esp
}
  8021fa:	89 d8                	mov    %ebx,%eax
  8021fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021ff:	5b                   	pop    %ebx
  802200:	5e                   	pop    %esi
  802201:	5d                   	pop    %ebp
  802202:	c3                   	ret    
		fd_close(fd, 0);
  802203:	83 ec 08             	sub    $0x8,%esp
  802206:	6a 00                	push   $0x0
  802208:	ff 75 f4             	pushl  -0xc(%ebp)
  80220b:	e8 82 f9 ff ff       	call   801b92 <fd_close>
		return r;
  802210:	83 c4 10             	add    $0x10,%esp
  802213:	eb e5                	jmp    8021fa <open+0x6c>
		return -E_BAD_PATH;
  802215:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80221a:	eb de                	jmp    8021fa <open+0x6c>

0080221c <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80221c:	55                   	push   %ebp
  80221d:	89 e5                	mov    %esp,%ebp
  80221f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802222:	ba 00 00 00 00       	mov    $0x0,%edx
  802227:	b8 08 00 00 00       	mov    $0x8,%eax
  80222c:	e8 cf fd ff ff       	call   802000 <fsipc>
}
  802231:	c9                   	leave  
  802232:	c3                   	ret    

00802233 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802233:	55                   	push   %ebp
  802234:	89 e5                	mov    %esp,%ebp
  802236:	56                   	push   %esi
  802237:	53                   	push   %ebx
  802238:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80223b:	83 ec 0c             	sub    $0xc,%esp
  80223e:	ff 75 08             	pushl  0x8(%ebp)
  802241:	e8 3d f8 ff ff       	call   801a83 <fd2data>
  802246:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802248:	83 c4 08             	add    $0x8,%esp
  80224b:	68 00 33 80 00       	push   $0x803300
  802250:	53                   	push   %ebx
  802251:	e8 9a e7 ff ff       	call   8009f0 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802256:	8b 46 04             	mov    0x4(%esi),%eax
  802259:	2b 06                	sub    (%esi),%eax
  80225b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802261:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802268:	00 00 00 
	stat->st_dev = &devpipe;
  80226b:	c7 83 88 00 00 00 28 	movl   $0x804028,0x88(%ebx)
  802272:	40 80 00 
	return 0;
}
  802275:	b8 00 00 00 00       	mov    $0x0,%eax
  80227a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80227d:	5b                   	pop    %ebx
  80227e:	5e                   	pop    %esi
  80227f:	5d                   	pop    %ebp
  802280:	c3                   	ret    

00802281 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802281:	55                   	push   %ebp
  802282:	89 e5                	mov    %esp,%ebp
  802284:	53                   	push   %ebx
  802285:	83 ec 0c             	sub    $0xc,%esp
  802288:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80228b:	53                   	push   %ebx
  80228c:	6a 00                	push   $0x0
  80228e:	e8 d4 eb ff ff       	call   800e67 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802293:	89 1c 24             	mov    %ebx,(%esp)
  802296:	e8 e8 f7 ff ff       	call   801a83 <fd2data>
  80229b:	83 c4 08             	add    $0x8,%esp
  80229e:	50                   	push   %eax
  80229f:	6a 00                	push   $0x0
  8022a1:	e8 c1 eb ff ff       	call   800e67 <sys_page_unmap>
}
  8022a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022a9:	c9                   	leave  
  8022aa:	c3                   	ret    

008022ab <_pipeisclosed>:
{
  8022ab:	55                   	push   %ebp
  8022ac:	89 e5                	mov    %esp,%ebp
  8022ae:	57                   	push   %edi
  8022af:	56                   	push   %esi
  8022b0:	53                   	push   %ebx
  8022b1:	83 ec 1c             	sub    $0x1c,%esp
  8022b4:	89 c7                	mov    %eax,%edi
  8022b6:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8022b8:	a1 04 50 80 00       	mov    0x805004,%eax
  8022bd:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8022c0:	83 ec 0c             	sub    $0xc,%esp
  8022c3:	57                   	push   %edi
  8022c4:	e8 22 05 00 00       	call   8027eb <pageref>
  8022c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8022cc:	89 34 24             	mov    %esi,(%esp)
  8022cf:	e8 17 05 00 00       	call   8027eb <pageref>
		nn = thisenv->env_runs;
  8022d4:	8b 15 04 50 80 00    	mov    0x805004,%edx
  8022da:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8022dd:	83 c4 10             	add    $0x10,%esp
  8022e0:	39 cb                	cmp    %ecx,%ebx
  8022e2:	74 1b                	je     8022ff <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8022e4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8022e7:	75 cf                	jne    8022b8 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8022e9:	8b 42 58             	mov    0x58(%edx),%eax
  8022ec:	6a 01                	push   $0x1
  8022ee:	50                   	push   %eax
  8022ef:	53                   	push   %ebx
  8022f0:	68 07 33 80 00       	push   $0x803307
  8022f5:	e8 d0 df ff ff       	call   8002ca <cprintf>
  8022fa:	83 c4 10             	add    $0x10,%esp
  8022fd:	eb b9                	jmp    8022b8 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8022ff:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802302:	0f 94 c0             	sete   %al
  802305:	0f b6 c0             	movzbl %al,%eax
}
  802308:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80230b:	5b                   	pop    %ebx
  80230c:	5e                   	pop    %esi
  80230d:	5f                   	pop    %edi
  80230e:	5d                   	pop    %ebp
  80230f:	c3                   	ret    

00802310 <devpipe_write>:
{
  802310:	55                   	push   %ebp
  802311:	89 e5                	mov    %esp,%ebp
  802313:	57                   	push   %edi
  802314:	56                   	push   %esi
  802315:	53                   	push   %ebx
  802316:	83 ec 28             	sub    $0x28,%esp
  802319:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80231c:	56                   	push   %esi
  80231d:	e8 61 f7 ff ff       	call   801a83 <fd2data>
  802322:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802324:	83 c4 10             	add    $0x10,%esp
  802327:	bf 00 00 00 00       	mov    $0x0,%edi
  80232c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80232f:	74 4f                	je     802380 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802331:	8b 43 04             	mov    0x4(%ebx),%eax
  802334:	8b 0b                	mov    (%ebx),%ecx
  802336:	8d 51 20             	lea    0x20(%ecx),%edx
  802339:	39 d0                	cmp    %edx,%eax
  80233b:	72 14                	jb     802351 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80233d:	89 da                	mov    %ebx,%edx
  80233f:	89 f0                	mov    %esi,%eax
  802341:	e8 65 ff ff ff       	call   8022ab <_pipeisclosed>
  802346:	85 c0                	test   %eax,%eax
  802348:	75 3b                	jne    802385 <devpipe_write+0x75>
			sys_yield();
  80234a:	e8 74 ea ff ff       	call   800dc3 <sys_yield>
  80234f:	eb e0                	jmp    802331 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802351:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802354:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802358:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80235b:	89 c2                	mov    %eax,%edx
  80235d:	c1 fa 1f             	sar    $0x1f,%edx
  802360:	89 d1                	mov    %edx,%ecx
  802362:	c1 e9 1b             	shr    $0x1b,%ecx
  802365:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802368:	83 e2 1f             	and    $0x1f,%edx
  80236b:	29 ca                	sub    %ecx,%edx
  80236d:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802371:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802375:	83 c0 01             	add    $0x1,%eax
  802378:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80237b:	83 c7 01             	add    $0x1,%edi
  80237e:	eb ac                	jmp    80232c <devpipe_write+0x1c>
	return i;
  802380:	8b 45 10             	mov    0x10(%ebp),%eax
  802383:	eb 05                	jmp    80238a <devpipe_write+0x7a>
				return 0;
  802385:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80238a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80238d:	5b                   	pop    %ebx
  80238e:	5e                   	pop    %esi
  80238f:	5f                   	pop    %edi
  802390:	5d                   	pop    %ebp
  802391:	c3                   	ret    

00802392 <devpipe_read>:
{
  802392:	55                   	push   %ebp
  802393:	89 e5                	mov    %esp,%ebp
  802395:	57                   	push   %edi
  802396:	56                   	push   %esi
  802397:	53                   	push   %ebx
  802398:	83 ec 18             	sub    $0x18,%esp
  80239b:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80239e:	57                   	push   %edi
  80239f:	e8 df f6 ff ff       	call   801a83 <fd2data>
  8023a4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8023a6:	83 c4 10             	add    $0x10,%esp
  8023a9:	be 00 00 00 00       	mov    $0x0,%esi
  8023ae:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023b1:	75 14                	jne    8023c7 <devpipe_read+0x35>
	return i;
  8023b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8023b6:	eb 02                	jmp    8023ba <devpipe_read+0x28>
				return i;
  8023b8:	89 f0                	mov    %esi,%eax
}
  8023ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023bd:	5b                   	pop    %ebx
  8023be:	5e                   	pop    %esi
  8023bf:	5f                   	pop    %edi
  8023c0:	5d                   	pop    %ebp
  8023c1:	c3                   	ret    
			sys_yield();
  8023c2:	e8 fc e9 ff ff       	call   800dc3 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8023c7:	8b 03                	mov    (%ebx),%eax
  8023c9:	3b 43 04             	cmp    0x4(%ebx),%eax
  8023cc:	75 18                	jne    8023e6 <devpipe_read+0x54>
			if (i > 0)
  8023ce:	85 f6                	test   %esi,%esi
  8023d0:	75 e6                	jne    8023b8 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8023d2:	89 da                	mov    %ebx,%edx
  8023d4:	89 f8                	mov    %edi,%eax
  8023d6:	e8 d0 fe ff ff       	call   8022ab <_pipeisclosed>
  8023db:	85 c0                	test   %eax,%eax
  8023dd:	74 e3                	je     8023c2 <devpipe_read+0x30>
				return 0;
  8023df:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e4:	eb d4                	jmp    8023ba <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8023e6:	99                   	cltd   
  8023e7:	c1 ea 1b             	shr    $0x1b,%edx
  8023ea:	01 d0                	add    %edx,%eax
  8023ec:	83 e0 1f             	and    $0x1f,%eax
  8023ef:	29 d0                	sub    %edx,%eax
  8023f1:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8023f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023f9:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8023fc:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8023ff:	83 c6 01             	add    $0x1,%esi
  802402:	eb aa                	jmp    8023ae <devpipe_read+0x1c>

00802404 <pipe>:
{
  802404:	55                   	push   %ebp
  802405:	89 e5                	mov    %esp,%ebp
  802407:	56                   	push   %esi
  802408:	53                   	push   %ebx
  802409:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80240c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80240f:	50                   	push   %eax
  802410:	e8 85 f6 ff ff       	call   801a9a <fd_alloc>
  802415:	89 c3                	mov    %eax,%ebx
  802417:	83 c4 10             	add    $0x10,%esp
  80241a:	85 c0                	test   %eax,%eax
  80241c:	0f 88 23 01 00 00    	js     802545 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802422:	83 ec 04             	sub    $0x4,%esp
  802425:	68 07 04 00 00       	push   $0x407
  80242a:	ff 75 f4             	pushl  -0xc(%ebp)
  80242d:	6a 00                	push   $0x0
  80242f:	e8 ae e9 ff ff       	call   800de2 <sys_page_alloc>
  802434:	89 c3                	mov    %eax,%ebx
  802436:	83 c4 10             	add    $0x10,%esp
  802439:	85 c0                	test   %eax,%eax
  80243b:	0f 88 04 01 00 00    	js     802545 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802441:	83 ec 0c             	sub    $0xc,%esp
  802444:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802447:	50                   	push   %eax
  802448:	e8 4d f6 ff ff       	call   801a9a <fd_alloc>
  80244d:	89 c3                	mov    %eax,%ebx
  80244f:	83 c4 10             	add    $0x10,%esp
  802452:	85 c0                	test   %eax,%eax
  802454:	0f 88 db 00 00 00    	js     802535 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80245a:	83 ec 04             	sub    $0x4,%esp
  80245d:	68 07 04 00 00       	push   $0x407
  802462:	ff 75 f0             	pushl  -0x10(%ebp)
  802465:	6a 00                	push   $0x0
  802467:	e8 76 e9 ff ff       	call   800de2 <sys_page_alloc>
  80246c:	89 c3                	mov    %eax,%ebx
  80246e:	83 c4 10             	add    $0x10,%esp
  802471:	85 c0                	test   %eax,%eax
  802473:	0f 88 bc 00 00 00    	js     802535 <pipe+0x131>
	va = fd2data(fd0);
  802479:	83 ec 0c             	sub    $0xc,%esp
  80247c:	ff 75 f4             	pushl  -0xc(%ebp)
  80247f:	e8 ff f5 ff ff       	call   801a83 <fd2data>
  802484:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802486:	83 c4 0c             	add    $0xc,%esp
  802489:	68 07 04 00 00       	push   $0x407
  80248e:	50                   	push   %eax
  80248f:	6a 00                	push   $0x0
  802491:	e8 4c e9 ff ff       	call   800de2 <sys_page_alloc>
  802496:	89 c3                	mov    %eax,%ebx
  802498:	83 c4 10             	add    $0x10,%esp
  80249b:	85 c0                	test   %eax,%eax
  80249d:	0f 88 82 00 00 00    	js     802525 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024a3:	83 ec 0c             	sub    $0xc,%esp
  8024a6:	ff 75 f0             	pushl  -0x10(%ebp)
  8024a9:	e8 d5 f5 ff ff       	call   801a83 <fd2data>
  8024ae:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8024b5:	50                   	push   %eax
  8024b6:	6a 00                	push   $0x0
  8024b8:	56                   	push   %esi
  8024b9:	6a 00                	push   $0x0
  8024bb:	e8 65 e9 ff ff       	call   800e25 <sys_page_map>
  8024c0:	89 c3                	mov    %eax,%ebx
  8024c2:	83 c4 20             	add    $0x20,%esp
  8024c5:	85 c0                	test   %eax,%eax
  8024c7:	78 4e                	js     802517 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8024c9:	a1 28 40 80 00       	mov    0x804028,%eax
  8024ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d1:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8024d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d6:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8024dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024e0:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8024e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8024ec:	83 ec 0c             	sub    $0xc,%esp
  8024ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8024f2:	e8 7c f5 ff ff       	call   801a73 <fd2num>
  8024f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024fa:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8024fc:	83 c4 04             	add    $0x4,%esp
  8024ff:	ff 75 f0             	pushl  -0x10(%ebp)
  802502:	e8 6c f5 ff ff       	call   801a73 <fd2num>
  802507:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80250a:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80250d:	83 c4 10             	add    $0x10,%esp
  802510:	bb 00 00 00 00       	mov    $0x0,%ebx
  802515:	eb 2e                	jmp    802545 <pipe+0x141>
	sys_page_unmap(0, va);
  802517:	83 ec 08             	sub    $0x8,%esp
  80251a:	56                   	push   %esi
  80251b:	6a 00                	push   $0x0
  80251d:	e8 45 e9 ff ff       	call   800e67 <sys_page_unmap>
  802522:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802525:	83 ec 08             	sub    $0x8,%esp
  802528:	ff 75 f0             	pushl  -0x10(%ebp)
  80252b:	6a 00                	push   $0x0
  80252d:	e8 35 e9 ff ff       	call   800e67 <sys_page_unmap>
  802532:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802535:	83 ec 08             	sub    $0x8,%esp
  802538:	ff 75 f4             	pushl  -0xc(%ebp)
  80253b:	6a 00                	push   $0x0
  80253d:	e8 25 e9 ff ff       	call   800e67 <sys_page_unmap>
  802542:	83 c4 10             	add    $0x10,%esp
}
  802545:	89 d8                	mov    %ebx,%eax
  802547:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80254a:	5b                   	pop    %ebx
  80254b:	5e                   	pop    %esi
  80254c:	5d                   	pop    %ebp
  80254d:	c3                   	ret    

0080254e <pipeisclosed>:
{
  80254e:	55                   	push   %ebp
  80254f:	89 e5                	mov    %esp,%ebp
  802551:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802554:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802557:	50                   	push   %eax
  802558:	ff 75 08             	pushl  0x8(%ebp)
  80255b:	e8 8c f5 ff ff       	call   801aec <fd_lookup>
  802560:	83 c4 10             	add    $0x10,%esp
  802563:	85 c0                	test   %eax,%eax
  802565:	78 18                	js     80257f <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802567:	83 ec 0c             	sub    $0xc,%esp
  80256a:	ff 75 f4             	pushl  -0xc(%ebp)
  80256d:	e8 11 f5 ff ff       	call   801a83 <fd2data>
	return _pipeisclosed(fd, p);
  802572:	89 c2                	mov    %eax,%edx
  802574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802577:	e8 2f fd ff ff       	call   8022ab <_pipeisclosed>
  80257c:	83 c4 10             	add    $0x10,%esp
}
  80257f:	c9                   	leave  
  802580:	c3                   	ret    

00802581 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802581:	b8 00 00 00 00       	mov    $0x0,%eax
  802586:	c3                   	ret    

00802587 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802587:	55                   	push   %ebp
  802588:	89 e5                	mov    %esp,%ebp
  80258a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80258d:	68 1f 33 80 00       	push   $0x80331f
  802592:	ff 75 0c             	pushl  0xc(%ebp)
  802595:	e8 56 e4 ff ff       	call   8009f0 <strcpy>
	return 0;
}
  80259a:	b8 00 00 00 00       	mov    $0x0,%eax
  80259f:	c9                   	leave  
  8025a0:	c3                   	ret    

008025a1 <devcons_write>:
{
  8025a1:	55                   	push   %ebp
  8025a2:	89 e5                	mov    %esp,%ebp
  8025a4:	57                   	push   %edi
  8025a5:	56                   	push   %esi
  8025a6:	53                   	push   %ebx
  8025a7:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8025ad:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8025b2:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8025b8:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025bb:	73 31                	jae    8025ee <devcons_write+0x4d>
		m = n - tot;
  8025bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8025c0:	29 f3                	sub    %esi,%ebx
  8025c2:	83 fb 7f             	cmp    $0x7f,%ebx
  8025c5:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8025ca:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8025cd:	83 ec 04             	sub    $0x4,%esp
  8025d0:	53                   	push   %ebx
  8025d1:	89 f0                	mov    %esi,%eax
  8025d3:	03 45 0c             	add    0xc(%ebp),%eax
  8025d6:	50                   	push   %eax
  8025d7:	57                   	push   %edi
  8025d8:	e8 a1 e5 ff ff       	call   800b7e <memmove>
		sys_cputs(buf, m);
  8025dd:	83 c4 08             	add    $0x8,%esp
  8025e0:	53                   	push   %ebx
  8025e1:	57                   	push   %edi
  8025e2:	e8 3f e7 ff ff       	call   800d26 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8025e7:	01 de                	add    %ebx,%esi
  8025e9:	83 c4 10             	add    $0x10,%esp
  8025ec:	eb ca                	jmp    8025b8 <devcons_write+0x17>
}
  8025ee:	89 f0                	mov    %esi,%eax
  8025f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025f3:	5b                   	pop    %ebx
  8025f4:	5e                   	pop    %esi
  8025f5:	5f                   	pop    %edi
  8025f6:	5d                   	pop    %ebp
  8025f7:	c3                   	ret    

008025f8 <devcons_read>:
{
  8025f8:	55                   	push   %ebp
  8025f9:	89 e5                	mov    %esp,%ebp
  8025fb:	83 ec 08             	sub    $0x8,%esp
  8025fe:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802603:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802607:	74 21                	je     80262a <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802609:	e8 36 e7 ff ff       	call   800d44 <sys_cgetc>
  80260e:	85 c0                	test   %eax,%eax
  802610:	75 07                	jne    802619 <devcons_read+0x21>
		sys_yield();
  802612:	e8 ac e7 ff ff       	call   800dc3 <sys_yield>
  802617:	eb f0                	jmp    802609 <devcons_read+0x11>
	if (c < 0)
  802619:	78 0f                	js     80262a <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80261b:	83 f8 04             	cmp    $0x4,%eax
  80261e:	74 0c                	je     80262c <devcons_read+0x34>
	*(char*)vbuf = c;
  802620:	8b 55 0c             	mov    0xc(%ebp),%edx
  802623:	88 02                	mov    %al,(%edx)
	return 1;
  802625:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80262a:	c9                   	leave  
  80262b:	c3                   	ret    
		return 0;
  80262c:	b8 00 00 00 00       	mov    $0x0,%eax
  802631:	eb f7                	jmp    80262a <devcons_read+0x32>

00802633 <cputchar>:
{
  802633:	55                   	push   %ebp
  802634:	89 e5                	mov    %esp,%ebp
  802636:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802639:	8b 45 08             	mov    0x8(%ebp),%eax
  80263c:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80263f:	6a 01                	push   $0x1
  802641:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802644:	50                   	push   %eax
  802645:	e8 dc e6 ff ff       	call   800d26 <sys_cputs>
}
  80264a:	83 c4 10             	add    $0x10,%esp
  80264d:	c9                   	leave  
  80264e:	c3                   	ret    

0080264f <getchar>:
{
  80264f:	55                   	push   %ebp
  802650:	89 e5                	mov    %esp,%ebp
  802652:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802655:	6a 01                	push   $0x1
  802657:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80265a:	50                   	push   %eax
  80265b:	6a 00                	push   $0x0
  80265d:	e8 f5 f6 ff ff       	call   801d57 <read>
	if (r < 0)
  802662:	83 c4 10             	add    $0x10,%esp
  802665:	85 c0                	test   %eax,%eax
  802667:	78 06                	js     80266f <getchar+0x20>
	if (r < 1)
  802669:	74 06                	je     802671 <getchar+0x22>
	return c;
  80266b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80266f:	c9                   	leave  
  802670:	c3                   	ret    
		return -E_EOF;
  802671:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802676:	eb f7                	jmp    80266f <getchar+0x20>

00802678 <iscons>:
{
  802678:	55                   	push   %ebp
  802679:	89 e5                	mov    %esp,%ebp
  80267b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80267e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802681:	50                   	push   %eax
  802682:	ff 75 08             	pushl  0x8(%ebp)
  802685:	e8 62 f4 ff ff       	call   801aec <fd_lookup>
  80268a:	83 c4 10             	add    $0x10,%esp
  80268d:	85 c0                	test   %eax,%eax
  80268f:	78 11                	js     8026a2 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802694:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80269a:	39 10                	cmp    %edx,(%eax)
  80269c:	0f 94 c0             	sete   %al
  80269f:	0f b6 c0             	movzbl %al,%eax
}
  8026a2:	c9                   	leave  
  8026a3:	c3                   	ret    

008026a4 <opencons>:
{
  8026a4:	55                   	push   %ebp
  8026a5:	89 e5                	mov    %esp,%ebp
  8026a7:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8026aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026ad:	50                   	push   %eax
  8026ae:	e8 e7 f3 ff ff       	call   801a9a <fd_alloc>
  8026b3:	83 c4 10             	add    $0x10,%esp
  8026b6:	85 c0                	test   %eax,%eax
  8026b8:	78 3a                	js     8026f4 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8026ba:	83 ec 04             	sub    $0x4,%esp
  8026bd:	68 07 04 00 00       	push   $0x407
  8026c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8026c5:	6a 00                	push   $0x0
  8026c7:	e8 16 e7 ff ff       	call   800de2 <sys_page_alloc>
  8026cc:	83 c4 10             	add    $0x10,%esp
  8026cf:	85 c0                	test   %eax,%eax
  8026d1:	78 21                	js     8026f4 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8026d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d6:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8026dc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8026de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8026e8:	83 ec 0c             	sub    $0xc,%esp
  8026eb:	50                   	push   %eax
  8026ec:	e8 82 f3 ff ff       	call   801a73 <fd2num>
  8026f1:	83 c4 10             	add    $0x10,%esp
}
  8026f4:	c9                   	leave  
  8026f5:	c3                   	ret    

008026f6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8026f6:	55                   	push   %ebp
  8026f7:	89 e5                	mov    %esp,%ebp
  8026f9:	56                   	push   %esi
  8026fa:	53                   	push   %ebx
  8026fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8026fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802701:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// return 0;
	if(!pg)
  802704:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  802706:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80270b:	0f 44 c2             	cmove  %edx,%eax
	
	int ret;

	ret = sys_ipc_recv(pg);
  80270e:	83 ec 0c             	sub    $0xc,%esp
  802711:	50                   	push   %eax
  802712:	e8 7b e8 ff ff       	call   800f92 <sys_ipc_recv>
	if(ret < 0){
  802717:	83 c4 10             	add    $0x10,%esp
  80271a:	85 c0                	test   %eax,%eax
  80271c:	78 2b                	js     802749 <ipc_recv+0x53>
		if(perm_store) *perm_store = 0;
		if(from_env_store) *from_env_store = 0;
		return ret;
	}
	
	if(perm_store)
  80271e:	85 f6                	test   %esi,%esi
  802720:	74 0a                	je     80272c <ipc_recv+0x36>
		*perm_store = thisenv->env_ipc_perm;
  802722:	a1 04 50 80 00       	mov    0x805004,%eax
  802727:	8b 40 78             	mov    0x78(%eax),%eax
  80272a:	89 06                	mov    %eax,(%esi)
	if(from_env_store)
  80272c:	85 db                	test   %ebx,%ebx
  80272e:	74 0a                	je     80273a <ipc_recv+0x44>
		*from_env_store = thisenv->env_ipc_from;
  802730:	a1 04 50 80 00       	mov    0x805004,%eax
  802735:	8b 40 74             	mov    0x74(%eax),%eax
  802738:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  80273a:	a1 04 50 80 00       	mov    0x805004,%eax
  80273f:	8b 40 70             	mov    0x70(%eax),%eax
}
  802742:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802745:	5b                   	pop    %ebx
  802746:	5e                   	pop    %esi
  802747:	5d                   	pop    %ebp
  802748:	c3                   	ret    
		if(perm_store) *perm_store = 0;
  802749:	85 f6                	test   %esi,%esi
  80274b:	74 06                	je     802753 <ipc_recv+0x5d>
  80274d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(from_env_store) *from_env_store = 0;
  802753:	85 db                	test   %ebx,%ebx
  802755:	74 eb                	je     802742 <ipc_recv+0x4c>
  802757:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80275d:	eb e3                	jmp    802742 <ipc_recv+0x4c>

0080275f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80275f:	55                   	push   %ebp
  802760:	89 e5                	mov    %esp,%ebp
  802762:	57                   	push   %edi
  802763:	56                   	push   %esi
  802764:	53                   	push   %ebx
  802765:	83 ec 0c             	sub    $0xc,%esp
  802768:	8b 7d 08             	mov    0x8(%ebp),%edi
  80276b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80276e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
	if (!pg)
  802771:	85 db                	test   %ebx,%ebx
		pg = (void*)UTOP;
  802773:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802778:	0f 44 d8             	cmove  %eax,%ebx

	int ret = -E_IPC_NOT_RECV;
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))) {
  80277b:	ff 75 14             	pushl  0x14(%ebp)
  80277e:	53                   	push   %ebx
  80277f:	56                   	push   %esi
  802780:	57                   	push   %edi
  802781:	e8 e9 e7 ff ff       	call   800f6f <sys_ipc_try_send>
  802786:	83 c4 10             	add    $0x10,%esp
  802789:	85 c0                	test   %eax,%eax
  80278b:	74 17                	je     8027a4 <ipc_send+0x45>
		if(ret != -E_IPC_NOT_RECV){
  80278d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802790:	74 e9                	je     80277b <ipc_send+0x1c>
			panic("ipc_send: ret : %d", ret);
  802792:	50                   	push   %eax
  802793:	68 2b 33 80 00       	push   $0x80332b
  802798:	6a 43                	push   $0x43
  80279a:	68 3e 33 80 00       	push   $0x80333e
  80279f:	e8 4b da ff ff       	call   8001ef <_panic>
			sys_yield();
		}
	}
}
  8027a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027a7:	5b                   	pop    %ebx
  8027a8:	5e                   	pop    %esi
  8027a9:	5f                   	pop    %edi
  8027aa:	5d                   	pop    %ebp
  8027ab:	c3                   	ret    

008027ac <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8027ac:	55                   	push   %ebp
  8027ad:	89 e5                	mov    %esp,%ebp
  8027af:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8027b2:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8027b7:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8027bd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8027c3:	8b 52 50             	mov    0x50(%edx),%edx
  8027c6:	39 ca                	cmp    %ecx,%edx
  8027c8:	74 11                	je     8027db <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8027ca:	83 c0 01             	add    $0x1,%eax
  8027cd:	3d 00 04 00 00       	cmp    $0x400,%eax
  8027d2:	75 e3                	jne    8027b7 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8027d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d9:	eb 0e                	jmp    8027e9 <ipc_find_env+0x3d>
			return envs[i].env_id;
  8027db:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8027e1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8027e6:	8b 40 48             	mov    0x48(%eax),%eax
}
  8027e9:	5d                   	pop    %ebp
  8027ea:	c3                   	ret    

008027eb <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8027eb:	55                   	push   %ebp
  8027ec:	89 e5                	mov    %esp,%ebp
  8027ee:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8027f1:	89 d0                	mov    %edx,%eax
  8027f3:	c1 e8 16             	shr    $0x16,%eax
  8027f6:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8027fd:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802802:	f6 c1 01             	test   $0x1,%cl
  802805:	74 1d                	je     802824 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802807:	c1 ea 0c             	shr    $0xc,%edx
  80280a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802811:	f6 c2 01             	test   $0x1,%dl
  802814:	74 0e                	je     802824 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802816:	c1 ea 0c             	shr    $0xc,%edx
  802819:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802820:	ef 
  802821:	0f b7 c0             	movzwl %ax,%eax
}
  802824:	5d                   	pop    %ebp
  802825:	c3                   	ret    
  802826:	66 90                	xchg   %ax,%ax
  802828:	66 90                	xchg   %ax,%ax
  80282a:	66 90                	xchg   %ax,%ax
  80282c:	66 90                	xchg   %ax,%ax
  80282e:	66 90                	xchg   %ax,%ax

00802830 <__udivdi3>:
  802830:	55                   	push   %ebp
  802831:	57                   	push   %edi
  802832:	56                   	push   %esi
  802833:	53                   	push   %ebx
  802834:	83 ec 1c             	sub    $0x1c,%esp
  802837:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80283b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80283f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802843:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802847:	85 d2                	test   %edx,%edx
  802849:	75 4d                	jne    802898 <__udivdi3+0x68>
  80284b:	39 f3                	cmp    %esi,%ebx
  80284d:	76 19                	jbe    802868 <__udivdi3+0x38>
  80284f:	31 ff                	xor    %edi,%edi
  802851:	89 e8                	mov    %ebp,%eax
  802853:	89 f2                	mov    %esi,%edx
  802855:	f7 f3                	div    %ebx
  802857:	89 fa                	mov    %edi,%edx
  802859:	83 c4 1c             	add    $0x1c,%esp
  80285c:	5b                   	pop    %ebx
  80285d:	5e                   	pop    %esi
  80285e:	5f                   	pop    %edi
  80285f:	5d                   	pop    %ebp
  802860:	c3                   	ret    
  802861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802868:	89 d9                	mov    %ebx,%ecx
  80286a:	85 db                	test   %ebx,%ebx
  80286c:	75 0b                	jne    802879 <__udivdi3+0x49>
  80286e:	b8 01 00 00 00       	mov    $0x1,%eax
  802873:	31 d2                	xor    %edx,%edx
  802875:	f7 f3                	div    %ebx
  802877:	89 c1                	mov    %eax,%ecx
  802879:	31 d2                	xor    %edx,%edx
  80287b:	89 f0                	mov    %esi,%eax
  80287d:	f7 f1                	div    %ecx
  80287f:	89 c6                	mov    %eax,%esi
  802881:	89 e8                	mov    %ebp,%eax
  802883:	89 f7                	mov    %esi,%edi
  802885:	f7 f1                	div    %ecx
  802887:	89 fa                	mov    %edi,%edx
  802889:	83 c4 1c             	add    $0x1c,%esp
  80288c:	5b                   	pop    %ebx
  80288d:	5e                   	pop    %esi
  80288e:	5f                   	pop    %edi
  80288f:	5d                   	pop    %ebp
  802890:	c3                   	ret    
  802891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802898:	39 f2                	cmp    %esi,%edx
  80289a:	77 1c                	ja     8028b8 <__udivdi3+0x88>
  80289c:	0f bd fa             	bsr    %edx,%edi
  80289f:	83 f7 1f             	xor    $0x1f,%edi
  8028a2:	75 2c                	jne    8028d0 <__udivdi3+0xa0>
  8028a4:	39 f2                	cmp    %esi,%edx
  8028a6:	72 06                	jb     8028ae <__udivdi3+0x7e>
  8028a8:	31 c0                	xor    %eax,%eax
  8028aa:	39 eb                	cmp    %ebp,%ebx
  8028ac:	77 a9                	ja     802857 <__udivdi3+0x27>
  8028ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8028b3:	eb a2                	jmp    802857 <__udivdi3+0x27>
  8028b5:	8d 76 00             	lea    0x0(%esi),%esi
  8028b8:	31 ff                	xor    %edi,%edi
  8028ba:	31 c0                	xor    %eax,%eax
  8028bc:	89 fa                	mov    %edi,%edx
  8028be:	83 c4 1c             	add    $0x1c,%esp
  8028c1:	5b                   	pop    %ebx
  8028c2:	5e                   	pop    %esi
  8028c3:	5f                   	pop    %edi
  8028c4:	5d                   	pop    %ebp
  8028c5:	c3                   	ret    
  8028c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028cd:	8d 76 00             	lea    0x0(%esi),%esi
  8028d0:	89 f9                	mov    %edi,%ecx
  8028d2:	b8 20 00 00 00       	mov    $0x20,%eax
  8028d7:	29 f8                	sub    %edi,%eax
  8028d9:	d3 e2                	shl    %cl,%edx
  8028db:	89 54 24 08          	mov    %edx,0x8(%esp)
  8028df:	89 c1                	mov    %eax,%ecx
  8028e1:	89 da                	mov    %ebx,%edx
  8028e3:	d3 ea                	shr    %cl,%edx
  8028e5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8028e9:	09 d1                	or     %edx,%ecx
  8028eb:	89 f2                	mov    %esi,%edx
  8028ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8028f1:	89 f9                	mov    %edi,%ecx
  8028f3:	d3 e3                	shl    %cl,%ebx
  8028f5:	89 c1                	mov    %eax,%ecx
  8028f7:	d3 ea                	shr    %cl,%edx
  8028f9:	89 f9                	mov    %edi,%ecx
  8028fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8028ff:	89 eb                	mov    %ebp,%ebx
  802901:	d3 e6                	shl    %cl,%esi
  802903:	89 c1                	mov    %eax,%ecx
  802905:	d3 eb                	shr    %cl,%ebx
  802907:	09 de                	or     %ebx,%esi
  802909:	89 f0                	mov    %esi,%eax
  80290b:	f7 74 24 08          	divl   0x8(%esp)
  80290f:	89 d6                	mov    %edx,%esi
  802911:	89 c3                	mov    %eax,%ebx
  802913:	f7 64 24 0c          	mull   0xc(%esp)
  802917:	39 d6                	cmp    %edx,%esi
  802919:	72 15                	jb     802930 <__udivdi3+0x100>
  80291b:	89 f9                	mov    %edi,%ecx
  80291d:	d3 e5                	shl    %cl,%ebp
  80291f:	39 c5                	cmp    %eax,%ebp
  802921:	73 04                	jae    802927 <__udivdi3+0xf7>
  802923:	39 d6                	cmp    %edx,%esi
  802925:	74 09                	je     802930 <__udivdi3+0x100>
  802927:	89 d8                	mov    %ebx,%eax
  802929:	31 ff                	xor    %edi,%edi
  80292b:	e9 27 ff ff ff       	jmp    802857 <__udivdi3+0x27>
  802930:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802933:	31 ff                	xor    %edi,%edi
  802935:	e9 1d ff ff ff       	jmp    802857 <__udivdi3+0x27>
  80293a:	66 90                	xchg   %ax,%ax
  80293c:	66 90                	xchg   %ax,%ax
  80293e:	66 90                	xchg   %ax,%ax

00802940 <__umoddi3>:
  802940:	55                   	push   %ebp
  802941:	57                   	push   %edi
  802942:	56                   	push   %esi
  802943:	53                   	push   %ebx
  802944:	83 ec 1c             	sub    $0x1c,%esp
  802947:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80294b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80294f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802953:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802957:	89 da                	mov    %ebx,%edx
  802959:	85 c0                	test   %eax,%eax
  80295b:	75 43                	jne    8029a0 <__umoddi3+0x60>
  80295d:	39 df                	cmp    %ebx,%edi
  80295f:	76 17                	jbe    802978 <__umoddi3+0x38>
  802961:	89 f0                	mov    %esi,%eax
  802963:	f7 f7                	div    %edi
  802965:	89 d0                	mov    %edx,%eax
  802967:	31 d2                	xor    %edx,%edx
  802969:	83 c4 1c             	add    $0x1c,%esp
  80296c:	5b                   	pop    %ebx
  80296d:	5e                   	pop    %esi
  80296e:	5f                   	pop    %edi
  80296f:	5d                   	pop    %ebp
  802970:	c3                   	ret    
  802971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802978:	89 fd                	mov    %edi,%ebp
  80297a:	85 ff                	test   %edi,%edi
  80297c:	75 0b                	jne    802989 <__umoddi3+0x49>
  80297e:	b8 01 00 00 00       	mov    $0x1,%eax
  802983:	31 d2                	xor    %edx,%edx
  802985:	f7 f7                	div    %edi
  802987:	89 c5                	mov    %eax,%ebp
  802989:	89 d8                	mov    %ebx,%eax
  80298b:	31 d2                	xor    %edx,%edx
  80298d:	f7 f5                	div    %ebp
  80298f:	89 f0                	mov    %esi,%eax
  802991:	f7 f5                	div    %ebp
  802993:	89 d0                	mov    %edx,%eax
  802995:	eb d0                	jmp    802967 <__umoddi3+0x27>
  802997:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80299e:	66 90                	xchg   %ax,%ax
  8029a0:	89 f1                	mov    %esi,%ecx
  8029a2:	39 d8                	cmp    %ebx,%eax
  8029a4:	76 0a                	jbe    8029b0 <__umoddi3+0x70>
  8029a6:	89 f0                	mov    %esi,%eax
  8029a8:	83 c4 1c             	add    $0x1c,%esp
  8029ab:	5b                   	pop    %ebx
  8029ac:	5e                   	pop    %esi
  8029ad:	5f                   	pop    %edi
  8029ae:	5d                   	pop    %ebp
  8029af:	c3                   	ret    
  8029b0:	0f bd e8             	bsr    %eax,%ebp
  8029b3:	83 f5 1f             	xor    $0x1f,%ebp
  8029b6:	75 20                	jne    8029d8 <__umoddi3+0x98>
  8029b8:	39 d8                	cmp    %ebx,%eax
  8029ba:	0f 82 b0 00 00 00    	jb     802a70 <__umoddi3+0x130>
  8029c0:	39 f7                	cmp    %esi,%edi
  8029c2:	0f 86 a8 00 00 00    	jbe    802a70 <__umoddi3+0x130>
  8029c8:	89 c8                	mov    %ecx,%eax
  8029ca:	83 c4 1c             	add    $0x1c,%esp
  8029cd:	5b                   	pop    %ebx
  8029ce:	5e                   	pop    %esi
  8029cf:	5f                   	pop    %edi
  8029d0:	5d                   	pop    %ebp
  8029d1:	c3                   	ret    
  8029d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8029d8:	89 e9                	mov    %ebp,%ecx
  8029da:	ba 20 00 00 00       	mov    $0x20,%edx
  8029df:	29 ea                	sub    %ebp,%edx
  8029e1:	d3 e0                	shl    %cl,%eax
  8029e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8029e7:	89 d1                	mov    %edx,%ecx
  8029e9:	89 f8                	mov    %edi,%eax
  8029eb:	d3 e8                	shr    %cl,%eax
  8029ed:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8029f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8029f5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8029f9:	09 c1                	or     %eax,%ecx
  8029fb:	89 d8                	mov    %ebx,%eax
  8029fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a01:	89 e9                	mov    %ebp,%ecx
  802a03:	d3 e7                	shl    %cl,%edi
  802a05:	89 d1                	mov    %edx,%ecx
  802a07:	d3 e8                	shr    %cl,%eax
  802a09:	89 e9                	mov    %ebp,%ecx
  802a0b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a0f:	d3 e3                	shl    %cl,%ebx
  802a11:	89 c7                	mov    %eax,%edi
  802a13:	89 d1                	mov    %edx,%ecx
  802a15:	89 f0                	mov    %esi,%eax
  802a17:	d3 e8                	shr    %cl,%eax
  802a19:	89 e9                	mov    %ebp,%ecx
  802a1b:	89 fa                	mov    %edi,%edx
  802a1d:	d3 e6                	shl    %cl,%esi
  802a1f:	09 d8                	or     %ebx,%eax
  802a21:	f7 74 24 08          	divl   0x8(%esp)
  802a25:	89 d1                	mov    %edx,%ecx
  802a27:	89 f3                	mov    %esi,%ebx
  802a29:	f7 64 24 0c          	mull   0xc(%esp)
  802a2d:	89 c6                	mov    %eax,%esi
  802a2f:	89 d7                	mov    %edx,%edi
  802a31:	39 d1                	cmp    %edx,%ecx
  802a33:	72 06                	jb     802a3b <__umoddi3+0xfb>
  802a35:	75 10                	jne    802a47 <__umoddi3+0x107>
  802a37:	39 c3                	cmp    %eax,%ebx
  802a39:	73 0c                	jae    802a47 <__umoddi3+0x107>
  802a3b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802a3f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802a43:	89 d7                	mov    %edx,%edi
  802a45:	89 c6                	mov    %eax,%esi
  802a47:	89 ca                	mov    %ecx,%edx
  802a49:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802a4e:	29 f3                	sub    %esi,%ebx
  802a50:	19 fa                	sbb    %edi,%edx
  802a52:	89 d0                	mov    %edx,%eax
  802a54:	d3 e0                	shl    %cl,%eax
  802a56:	89 e9                	mov    %ebp,%ecx
  802a58:	d3 eb                	shr    %cl,%ebx
  802a5a:	d3 ea                	shr    %cl,%edx
  802a5c:	09 d8                	or     %ebx,%eax
  802a5e:	83 c4 1c             	add    $0x1c,%esp
  802a61:	5b                   	pop    %ebx
  802a62:	5e                   	pop    %esi
  802a63:	5f                   	pop    %edi
  802a64:	5d                   	pop    %ebp
  802a65:	c3                   	ret    
  802a66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a6d:	8d 76 00             	lea    0x0(%esi),%esi
  802a70:	89 da                	mov    %ebx,%edx
  802a72:	29 fe                	sub    %edi,%esi
  802a74:	19 c2                	sbb    %eax,%edx
  802a76:	89 f1                	mov    %esi,%ecx
  802a78:	89 c8                	mov    %ecx,%eax
  802a7a:	e9 4b ff ff ff       	jmp    8029ca <__umoddi3+0x8a>
