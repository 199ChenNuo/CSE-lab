
obj/user/testbss.debug:     file format elf32-i386


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
  80002c:	e8 ab 00 00 00       	call   8000dc <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t bigarray[ARRAYSIZE];

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 14             	sub    $0x14,%esp
	int i;

	cprintf("Making sure bss works right...\n");
  800039:	68 c0 11 80 00       	push   $0x8011c0
  80003e:	e8 cf 01 00 00       	call   800212 <cprintf>
  800043:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < ARRAYSIZE; i++)
  800046:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != 0)
  80004b:	83 3c 85 20 20 80 00 	cmpl   $0x0,0x802020(,%eax,4)
  800052:	00 
  800053:	75 63                	jne    8000b8 <umain+0x85>
	for (i = 0; i < ARRAYSIZE; i++)
  800055:	83 c0 01             	add    $0x1,%eax
  800058:	3d 00 00 10 00       	cmp    $0x100000,%eax
  80005d:	75 ec                	jne    80004b <umain+0x18>
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
  80005f:	b8 00 00 00 00       	mov    $0x0,%eax
		bigarray[i] = i;
  800064:	89 04 85 20 20 80 00 	mov    %eax,0x802020(,%eax,4)
	for (i = 0; i < ARRAYSIZE; i++)
  80006b:	83 c0 01             	add    $0x1,%eax
  80006e:	3d 00 00 10 00       	cmp    $0x100000,%eax
  800073:	75 ef                	jne    800064 <umain+0x31>
	for (i = 0; i < ARRAYSIZE; i++)
  800075:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != i)
  80007a:	39 04 85 20 20 80 00 	cmp    %eax,0x802020(,%eax,4)
  800081:	75 47                	jne    8000ca <umain+0x97>
	for (i = 0; i < ARRAYSIZE; i++)
  800083:	83 c0 01             	add    $0x1,%eax
  800086:	3d 00 00 10 00       	cmp    $0x100000,%eax
  80008b:	75 ed                	jne    80007a <umain+0x47>
			panic("bigarray[%d] didn't hold its value!\n", i);

	cprintf("Yes, good.  Now doing a wild write off the end...\n");
  80008d:	83 ec 0c             	sub    $0xc,%esp
  800090:	68 08 12 80 00       	push   $0x801208
  800095:	e8 78 01 00 00       	call   800212 <cprintf>
	bigarray[ARRAYSIZE+1024] = 0;
  80009a:	c7 05 20 30 c0 00 00 	movl   $0x0,0xc03020
  8000a1:	00 00 00 
	panic("SHOULD HAVE TRAPPED!!!");
  8000a4:	83 c4 0c             	add    $0xc,%esp
  8000a7:	68 67 12 80 00       	push   $0x801267
  8000ac:	6a 1a                	push   $0x1a
  8000ae:	68 58 12 80 00       	push   $0x801258
  8000b3:	e8 7f 00 00 00       	call   800137 <_panic>
			panic("bigarray[%d] isn't cleared!\n", i);
  8000b8:	50                   	push   %eax
  8000b9:	68 3b 12 80 00       	push   $0x80123b
  8000be:	6a 11                	push   $0x11
  8000c0:	68 58 12 80 00       	push   $0x801258
  8000c5:	e8 6d 00 00 00       	call   800137 <_panic>
			panic("bigarray[%d] didn't hold its value!\n", i);
  8000ca:	50                   	push   %eax
  8000cb:	68 e0 11 80 00       	push   $0x8011e0
  8000d0:	6a 16                	push   $0x16
  8000d2:	68 58 12 80 00       	push   $0x801258
  8000d7:	e8 5b 00 00 00       	call   800137 <_panic>

008000dc <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000dc:	55                   	push   %ebp
  8000dd:	89 e5                	mov    %esp,%ebp
  8000df:	56                   	push   %esi
  8000e0:	53                   	push   %ebx
  8000e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000e4:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  8000e7:	e8 00 0c 00 00       	call   800cec <sys_getenvid>
  8000ec:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f1:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8000f7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000fc:	a3 20 20 c0 00       	mov    %eax,0xc02020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800101:	85 db                	test   %ebx,%ebx
  800103:	7e 07                	jle    80010c <libmain+0x30>
		binaryname = argv[0];
  800105:	8b 06                	mov    (%esi),%eax
  800107:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80010c:	83 ec 08             	sub    $0x8,%esp
  80010f:	56                   	push   %esi
  800110:	53                   	push   %ebx
  800111:	e8 1d ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800116:	e8 0a 00 00 00       	call   800125 <exit>
}
  80011b:	83 c4 10             	add    $0x10,%esp
  80011e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800121:	5b                   	pop    %ebx
  800122:	5e                   	pop    %esi
  800123:	5d                   	pop    %ebp
  800124:	c3                   	ret    

00800125 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800125:	55                   	push   %ebp
  800126:	89 e5                	mov    %esp,%ebp
  800128:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80012b:	6a 00                	push   $0x0
  80012d:	e8 79 0b 00 00       	call   800cab <sys_env_destroy>
}
  800132:	83 c4 10             	add    $0x10,%esp
  800135:	c9                   	leave  
  800136:	c3                   	ret    

00800137 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800137:	55                   	push   %ebp
  800138:	89 e5                	mov    %esp,%ebp
  80013a:	56                   	push   %esi
  80013b:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80013c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80013f:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800145:	e8 a2 0b 00 00       	call   800cec <sys_getenvid>
  80014a:	83 ec 0c             	sub    $0xc,%esp
  80014d:	ff 75 0c             	pushl  0xc(%ebp)
  800150:	ff 75 08             	pushl  0x8(%ebp)
  800153:	56                   	push   %esi
  800154:	50                   	push   %eax
  800155:	68 88 12 80 00       	push   $0x801288
  80015a:	e8 b3 00 00 00       	call   800212 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80015f:	83 c4 18             	add    $0x18,%esp
  800162:	53                   	push   %ebx
  800163:	ff 75 10             	pushl  0x10(%ebp)
  800166:	e8 56 00 00 00       	call   8001c1 <vcprintf>
	cprintf("\n");
  80016b:	c7 04 24 56 12 80 00 	movl   $0x801256,(%esp)
  800172:	e8 9b 00 00 00       	call   800212 <cprintf>
  800177:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80017a:	cc                   	int3   
  80017b:	eb fd                	jmp    80017a <_panic+0x43>

0080017d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80017d:	55                   	push   %ebp
  80017e:	89 e5                	mov    %esp,%ebp
  800180:	53                   	push   %ebx
  800181:	83 ec 04             	sub    $0x4,%esp
  800184:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800187:	8b 13                	mov    (%ebx),%edx
  800189:	8d 42 01             	lea    0x1(%edx),%eax
  80018c:	89 03                	mov    %eax,(%ebx)
  80018e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800191:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800195:	3d ff 00 00 00       	cmp    $0xff,%eax
  80019a:	74 09                	je     8001a5 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80019c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001a3:	c9                   	leave  
  8001a4:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001a5:	83 ec 08             	sub    $0x8,%esp
  8001a8:	68 ff 00 00 00       	push   $0xff
  8001ad:	8d 43 08             	lea    0x8(%ebx),%eax
  8001b0:	50                   	push   %eax
  8001b1:	e8 b8 0a 00 00       	call   800c6e <sys_cputs>
		b->idx = 0;
  8001b6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001bc:	83 c4 10             	add    $0x10,%esp
  8001bf:	eb db                	jmp    80019c <putch+0x1f>

008001c1 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001c1:	55                   	push   %ebp
  8001c2:	89 e5                	mov    %esp,%ebp
  8001c4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001ca:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001d1:	00 00 00 
	b.cnt = 0;
  8001d4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001db:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001de:	ff 75 0c             	pushl  0xc(%ebp)
  8001e1:	ff 75 08             	pushl  0x8(%ebp)
  8001e4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001ea:	50                   	push   %eax
  8001eb:	68 7d 01 80 00       	push   $0x80017d
  8001f0:	e8 4a 01 00 00       	call   80033f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001f5:	83 c4 08             	add    $0x8,%esp
  8001f8:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001fe:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800204:	50                   	push   %eax
  800205:	e8 64 0a 00 00       	call   800c6e <sys_cputs>

	return b.cnt;
}
  80020a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800210:	c9                   	leave  
  800211:	c3                   	ret    

00800212 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800212:	55                   	push   %ebp
  800213:	89 e5                	mov    %esp,%ebp
  800215:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800218:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80021b:	50                   	push   %eax
  80021c:	ff 75 08             	pushl  0x8(%ebp)
  80021f:	e8 9d ff ff ff       	call   8001c1 <vcprintf>
	va_end(ap);

	return cnt;
}
  800224:	c9                   	leave  
  800225:	c3                   	ret    

00800226 <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800226:	55                   	push   %ebp
  800227:	89 e5                	mov    %esp,%ebp
  800229:	57                   	push   %edi
  80022a:	56                   	push   %esi
  80022b:	53                   	push   %ebx
  80022c:	83 ec 1c             	sub    $0x1c,%esp
  80022f:	89 c6                	mov    %eax,%esi
  800231:	89 d7                	mov    %edx,%edi
  800233:	8b 45 08             	mov    0x8(%ebp),%eax
  800236:	8b 55 0c             	mov    0xc(%ebp),%edx
  800239:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80023c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80023f:	8b 45 10             	mov    0x10(%ebp),%eax
  800242:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  800245:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800249:	74 2c                	je     800277 <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80024b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80024e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800255:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800258:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80025b:	39 c2                	cmp    %eax,%edx
  80025d:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800260:	73 43                	jae    8002a5 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800262:	83 eb 01             	sub    $0x1,%ebx
  800265:	85 db                	test   %ebx,%ebx
  800267:	7e 6c                	jle    8002d5 <printnum+0xaf>
			putch(padc, putdat);
  800269:	83 ec 08             	sub    $0x8,%esp
  80026c:	57                   	push   %edi
  80026d:	ff 75 18             	pushl  0x18(%ebp)
  800270:	ff d6                	call   *%esi
  800272:	83 c4 10             	add    $0x10,%esp
  800275:	eb eb                	jmp    800262 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800277:	83 ec 0c             	sub    $0xc,%esp
  80027a:	6a 20                	push   $0x20
  80027c:	6a 00                	push   $0x0
  80027e:	50                   	push   %eax
  80027f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800282:	ff 75 e0             	pushl  -0x20(%ebp)
  800285:	89 fa                	mov    %edi,%edx
  800287:	89 f0                	mov    %esi,%eax
  800289:	e8 98 ff ff ff       	call   800226 <printnum>
		while (--width > 0)
  80028e:	83 c4 20             	add    $0x20,%esp
  800291:	83 eb 01             	sub    $0x1,%ebx
  800294:	85 db                	test   %ebx,%ebx
  800296:	7e 65                	jle    8002fd <printnum+0xd7>
			putch(' ', putdat);
  800298:	83 ec 08             	sub    $0x8,%esp
  80029b:	57                   	push   %edi
  80029c:	6a 20                	push   $0x20
  80029e:	ff d6                	call   *%esi
  8002a0:	83 c4 10             	add    $0x10,%esp
  8002a3:	eb ec                	jmp    800291 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002a5:	83 ec 0c             	sub    $0xc,%esp
  8002a8:	ff 75 18             	pushl  0x18(%ebp)
  8002ab:	83 eb 01             	sub    $0x1,%ebx
  8002ae:	53                   	push   %ebx
  8002af:	50                   	push   %eax
  8002b0:	83 ec 08             	sub    $0x8,%esp
  8002b3:	ff 75 dc             	pushl  -0x24(%ebp)
  8002b6:	ff 75 d8             	pushl  -0x28(%ebp)
  8002b9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8002bf:	e8 9c 0c 00 00       	call   800f60 <__udivdi3>
  8002c4:	83 c4 18             	add    $0x18,%esp
  8002c7:	52                   	push   %edx
  8002c8:	50                   	push   %eax
  8002c9:	89 fa                	mov    %edi,%edx
  8002cb:	89 f0                	mov    %esi,%eax
  8002cd:	e8 54 ff ff ff       	call   800226 <printnum>
  8002d2:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002d5:	83 ec 08             	sub    $0x8,%esp
  8002d8:	57                   	push   %edi
  8002d9:	83 ec 04             	sub    $0x4,%esp
  8002dc:	ff 75 dc             	pushl  -0x24(%ebp)
  8002df:	ff 75 d8             	pushl  -0x28(%ebp)
  8002e2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e5:	ff 75 e0             	pushl  -0x20(%ebp)
  8002e8:	e8 83 0d 00 00       	call   801070 <__umoddi3>
  8002ed:	83 c4 14             	add    $0x14,%esp
  8002f0:	0f be 80 ab 12 80 00 	movsbl 0x8012ab(%eax),%eax
  8002f7:	50                   	push   %eax
  8002f8:	ff d6                	call   *%esi
  8002fa:	83 c4 10             	add    $0x10,%esp
}
  8002fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800300:	5b                   	pop    %ebx
  800301:	5e                   	pop    %esi
  800302:	5f                   	pop    %edi
  800303:	5d                   	pop    %ebp
  800304:	c3                   	ret    

00800305 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800305:	55                   	push   %ebp
  800306:	89 e5                	mov    %esp,%ebp
  800308:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80030b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80030f:	8b 10                	mov    (%eax),%edx
  800311:	3b 50 04             	cmp    0x4(%eax),%edx
  800314:	73 0a                	jae    800320 <sprintputch+0x1b>
		*b->buf++ = ch;
  800316:	8d 4a 01             	lea    0x1(%edx),%ecx
  800319:	89 08                	mov    %ecx,(%eax)
  80031b:	8b 45 08             	mov    0x8(%ebp),%eax
  80031e:	88 02                	mov    %al,(%edx)
}
  800320:	5d                   	pop    %ebp
  800321:	c3                   	ret    

00800322 <printfmt>:
{
  800322:	55                   	push   %ebp
  800323:	89 e5                	mov    %esp,%ebp
  800325:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800328:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80032b:	50                   	push   %eax
  80032c:	ff 75 10             	pushl  0x10(%ebp)
  80032f:	ff 75 0c             	pushl  0xc(%ebp)
  800332:	ff 75 08             	pushl  0x8(%ebp)
  800335:	e8 05 00 00 00       	call   80033f <vprintfmt>
}
  80033a:	83 c4 10             	add    $0x10,%esp
  80033d:	c9                   	leave  
  80033e:	c3                   	ret    

0080033f <vprintfmt>:
{
  80033f:	55                   	push   %ebp
  800340:	89 e5                	mov    %esp,%ebp
  800342:	57                   	push   %edi
  800343:	56                   	push   %esi
  800344:	53                   	push   %ebx
  800345:	83 ec 3c             	sub    $0x3c,%esp
  800348:	8b 75 08             	mov    0x8(%ebp),%esi
  80034b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80034e:	8b 7d 10             	mov    0x10(%ebp),%edi
  800351:	e9 1e 04 00 00       	jmp    800774 <vprintfmt+0x435>
		posflag = 0;
  800356:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  80035d:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800361:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800368:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80036f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800376:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  80037d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800382:	8d 47 01             	lea    0x1(%edi),%eax
  800385:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800388:	0f b6 17             	movzbl (%edi),%edx
  80038b:	8d 42 dd             	lea    -0x23(%edx),%eax
  80038e:	3c 55                	cmp    $0x55,%al
  800390:	0f 87 d9 04 00 00    	ja     80086f <vprintfmt+0x530>
  800396:	0f b6 c0             	movzbl %al,%eax
  800399:	ff 24 85 80 14 80 00 	jmp    *0x801480(,%eax,4)
  8003a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003a3:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8003a7:	eb d9                	jmp    800382 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003a9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  8003ac:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  8003b3:	eb cd                	jmp    800382 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003b5:	0f b6 d2             	movzbl %dl,%edx
  8003b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c0:	89 75 08             	mov    %esi,0x8(%ebp)
  8003c3:	eb 0c                	jmp    8003d1 <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  8003c5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003c8:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  8003cc:	eb b4                	jmp    800382 <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  8003ce:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003d1:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003d4:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003d8:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003db:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003de:	83 fe 09             	cmp    $0x9,%esi
  8003e1:	76 eb                	jbe    8003ce <vprintfmt+0x8f>
  8003e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003e6:	8b 75 08             	mov    0x8(%ebp),%esi
  8003e9:	eb 14                	jmp    8003ff <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  8003eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ee:	8b 00                	mov    (%eax),%eax
  8003f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f6:	8d 40 04             	lea    0x4(%eax),%eax
  8003f9:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003ff:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800403:	0f 89 79 ff ff ff    	jns    800382 <vprintfmt+0x43>
				width = precision, precision = -1;
  800409:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80040c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80040f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800416:	e9 67 ff ff ff       	jmp    800382 <vprintfmt+0x43>
  80041b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80041e:	85 c0                	test   %eax,%eax
  800420:	0f 48 c1             	cmovs  %ecx,%eax
  800423:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800426:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800429:	e9 54 ff ff ff       	jmp    800382 <vprintfmt+0x43>
  80042e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800431:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800438:	e9 45 ff ff ff       	jmp    800382 <vprintfmt+0x43>
			lflag++;
  80043d:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800441:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800444:	e9 39 ff ff ff       	jmp    800382 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800449:	8b 45 14             	mov    0x14(%ebp),%eax
  80044c:	8d 78 04             	lea    0x4(%eax),%edi
  80044f:	83 ec 08             	sub    $0x8,%esp
  800452:	53                   	push   %ebx
  800453:	ff 30                	pushl  (%eax)
  800455:	ff d6                	call   *%esi
			break;
  800457:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80045a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80045d:	e9 0f 03 00 00       	jmp    800771 <vprintfmt+0x432>
			err = va_arg(ap, int);
  800462:	8b 45 14             	mov    0x14(%ebp),%eax
  800465:	8d 78 04             	lea    0x4(%eax),%edi
  800468:	8b 00                	mov    (%eax),%eax
  80046a:	99                   	cltd   
  80046b:	31 d0                	xor    %edx,%eax
  80046d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80046f:	83 f8 0f             	cmp    $0xf,%eax
  800472:	7f 23                	jg     800497 <vprintfmt+0x158>
  800474:	8b 14 85 e0 15 80 00 	mov    0x8015e0(,%eax,4),%edx
  80047b:	85 d2                	test   %edx,%edx
  80047d:	74 18                	je     800497 <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  80047f:	52                   	push   %edx
  800480:	68 cc 12 80 00       	push   $0x8012cc
  800485:	53                   	push   %ebx
  800486:	56                   	push   %esi
  800487:	e8 96 fe ff ff       	call   800322 <printfmt>
  80048c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80048f:	89 7d 14             	mov    %edi,0x14(%ebp)
  800492:	e9 da 02 00 00       	jmp    800771 <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  800497:	50                   	push   %eax
  800498:	68 c3 12 80 00       	push   $0x8012c3
  80049d:	53                   	push   %ebx
  80049e:	56                   	push   %esi
  80049f:	e8 7e fe ff ff       	call   800322 <printfmt>
  8004a4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004a7:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004aa:	e9 c2 02 00 00       	jmp    800771 <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  8004af:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b2:	83 c0 04             	add    $0x4,%eax
  8004b5:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8004b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bb:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004bd:	85 c9                	test   %ecx,%ecx
  8004bf:	b8 bc 12 80 00       	mov    $0x8012bc,%eax
  8004c4:	0f 45 c1             	cmovne %ecx,%eax
  8004c7:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004ca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004ce:	7e 06                	jle    8004d6 <vprintfmt+0x197>
  8004d0:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004d4:	75 0d                	jne    8004e3 <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004d9:	89 c7                	mov    %eax,%edi
  8004db:	03 45 e0             	add    -0x20(%ebp),%eax
  8004de:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004e1:	eb 53                	jmp    800536 <vprintfmt+0x1f7>
  8004e3:	83 ec 08             	sub    $0x8,%esp
  8004e6:	ff 75 d8             	pushl  -0x28(%ebp)
  8004e9:	50                   	push   %eax
  8004ea:	e8 28 04 00 00       	call   800917 <strnlen>
  8004ef:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004f2:	29 c1                	sub    %eax,%ecx
  8004f4:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  8004f7:	83 c4 10             	add    $0x10,%esp
  8004fa:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004fc:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800500:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800503:	eb 0f                	jmp    800514 <vprintfmt+0x1d5>
					putch(padc, putdat);
  800505:	83 ec 08             	sub    $0x8,%esp
  800508:	53                   	push   %ebx
  800509:	ff 75 e0             	pushl  -0x20(%ebp)
  80050c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80050e:	83 ef 01             	sub    $0x1,%edi
  800511:	83 c4 10             	add    $0x10,%esp
  800514:	85 ff                	test   %edi,%edi
  800516:	7f ed                	jg     800505 <vprintfmt+0x1c6>
  800518:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  80051b:	85 c9                	test   %ecx,%ecx
  80051d:	b8 00 00 00 00       	mov    $0x0,%eax
  800522:	0f 49 c1             	cmovns %ecx,%eax
  800525:	29 c1                	sub    %eax,%ecx
  800527:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80052a:	eb aa                	jmp    8004d6 <vprintfmt+0x197>
					putch(ch, putdat);
  80052c:	83 ec 08             	sub    $0x8,%esp
  80052f:	53                   	push   %ebx
  800530:	52                   	push   %edx
  800531:	ff d6                	call   *%esi
  800533:	83 c4 10             	add    $0x10,%esp
  800536:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800539:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80053b:	83 c7 01             	add    $0x1,%edi
  80053e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800542:	0f be d0             	movsbl %al,%edx
  800545:	85 d2                	test   %edx,%edx
  800547:	74 4b                	je     800594 <vprintfmt+0x255>
  800549:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80054d:	78 06                	js     800555 <vprintfmt+0x216>
  80054f:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800553:	78 1e                	js     800573 <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  800555:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800559:	74 d1                	je     80052c <vprintfmt+0x1ed>
  80055b:	0f be c0             	movsbl %al,%eax
  80055e:	83 e8 20             	sub    $0x20,%eax
  800561:	83 f8 5e             	cmp    $0x5e,%eax
  800564:	76 c6                	jbe    80052c <vprintfmt+0x1ed>
					putch('?', putdat);
  800566:	83 ec 08             	sub    $0x8,%esp
  800569:	53                   	push   %ebx
  80056a:	6a 3f                	push   $0x3f
  80056c:	ff d6                	call   *%esi
  80056e:	83 c4 10             	add    $0x10,%esp
  800571:	eb c3                	jmp    800536 <vprintfmt+0x1f7>
  800573:	89 cf                	mov    %ecx,%edi
  800575:	eb 0e                	jmp    800585 <vprintfmt+0x246>
				putch(' ', putdat);
  800577:	83 ec 08             	sub    $0x8,%esp
  80057a:	53                   	push   %ebx
  80057b:	6a 20                	push   $0x20
  80057d:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80057f:	83 ef 01             	sub    $0x1,%edi
  800582:	83 c4 10             	add    $0x10,%esp
  800585:	85 ff                	test   %edi,%edi
  800587:	7f ee                	jg     800577 <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  800589:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80058c:	89 45 14             	mov    %eax,0x14(%ebp)
  80058f:	e9 dd 01 00 00       	jmp    800771 <vprintfmt+0x432>
  800594:	89 cf                	mov    %ecx,%edi
  800596:	eb ed                	jmp    800585 <vprintfmt+0x246>
	if (lflag >= 2)
  800598:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80059c:	7f 21                	jg     8005bf <vprintfmt+0x280>
	else if (lflag)
  80059e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8005a2:	74 6a                	je     80060e <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  8005a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a7:	8b 00                	mov    (%eax),%eax
  8005a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ac:	89 c1                	mov    %eax,%ecx
  8005ae:	c1 f9 1f             	sar    $0x1f,%ecx
  8005b1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b7:	8d 40 04             	lea    0x4(%eax),%eax
  8005ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8005bd:	eb 17                	jmp    8005d6 <vprintfmt+0x297>
		return va_arg(*ap, long long);
  8005bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c2:	8b 50 04             	mov    0x4(%eax),%edx
  8005c5:	8b 00                	mov    (%eax),%eax
  8005c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ca:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d0:	8d 40 08             	lea    0x8(%eax),%eax
  8005d3:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005d6:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  8005d9:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  8005de:	85 d2                	test   %edx,%edx
  8005e0:	0f 89 5c 01 00 00    	jns    800742 <vprintfmt+0x403>
				putch('-', putdat);
  8005e6:	83 ec 08             	sub    $0x8,%esp
  8005e9:	53                   	push   %ebx
  8005ea:	6a 2d                	push   $0x2d
  8005ec:	ff d6                	call   *%esi
				num = -(long long) num;
  8005ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005f1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005f4:	f7 d8                	neg    %eax
  8005f6:	83 d2 00             	adc    $0x0,%edx
  8005f9:	f7 da                	neg    %edx
  8005fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005fe:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800601:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800604:	bf 0a 00 00 00       	mov    $0xa,%edi
  800609:	e9 45 01 00 00       	jmp    800753 <vprintfmt+0x414>
		return va_arg(*ap, int);
  80060e:	8b 45 14             	mov    0x14(%ebp),%eax
  800611:	8b 00                	mov    (%eax),%eax
  800613:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800616:	89 c1                	mov    %eax,%ecx
  800618:	c1 f9 1f             	sar    $0x1f,%ecx
  80061b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80061e:	8b 45 14             	mov    0x14(%ebp),%eax
  800621:	8d 40 04             	lea    0x4(%eax),%eax
  800624:	89 45 14             	mov    %eax,0x14(%ebp)
  800627:	eb ad                	jmp    8005d6 <vprintfmt+0x297>
	if (lflag >= 2)
  800629:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80062d:	7f 29                	jg     800658 <vprintfmt+0x319>
	else if (lflag)
  80062f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800633:	74 44                	je     800679 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  800635:	8b 45 14             	mov    0x14(%ebp),%eax
  800638:	8b 00                	mov    (%eax),%eax
  80063a:	ba 00 00 00 00       	mov    $0x0,%edx
  80063f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800642:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800645:	8b 45 14             	mov    0x14(%ebp),%eax
  800648:	8d 40 04             	lea    0x4(%eax),%eax
  80064b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80064e:	bf 0a 00 00 00       	mov    $0xa,%edi
  800653:	e9 ea 00 00 00       	jmp    800742 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800658:	8b 45 14             	mov    0x14(%ebp),%eax
  80065b:	8b 50 04             	mov    0x4(%eax),%edx
  80065e:	8b 00                	mov    (%eax),%eax
  800660:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800663:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800666:	8b 45 14             	mov    0x14(%ebp),%eax
  800669:	8d 40 08             	lea    0x8(%eax),%eax
  80066c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80066f:	bf 0a 00 00 00       	mov    $0xa,%edi
  800674:	e9 c9 00 00 00       	jmp    800742 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800679:	8b 45 14             	mov    0x14(%ebp),%eax
  80067c:	8b 00                	mov    (%eax),%eax
  80067e:	ba 00 00 00 00       	mov    $0x0,%edx
  800683:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800686:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800689:	8b 45 14             	mov    0x14(%ebp),%eax
  80068c:	8d 40 04             	lea    0x4(%eax),%eax
  80068f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800692:	bf 0a 00 00 00       	mov    $0xa,%edi
  800697:	e9 a6 00 00 00       	jmp    800742 <vprintfmt+0x403>
			putch('0', putdat);
  80069c:	83 ec 08             	sub    $0x8,%esp
  80069f:	53                   	push   %ebx
  8006a0:	6a 30                	push   $0x30
  8006a2:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006a4:	83 c4 10             	add    $0x10,%esp
  8006a7:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8006ab:	7f 26                	jg     8006d3 <vprintfmt+0x394>
	else if (lflag)
  8006ad:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8006b1:	74 3e                	je     8006f1 <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  8006b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b6:	8b 00                	mov    (%eax),%eax
  8006b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8006bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c6:	8d 40 04             	lea    0x4(%eax),%eax
  8006c9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006cc:	bf 08 00 00 00       	mov    $0x8,%edi
  8006d1:	eb 6f                	jmp    800742 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8006d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d6:	8b 50 04             	mov    0x4(%eax),%edx
  8006d9:	8b 00                	mov    (%eax),%eax
  8006db:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006de:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e4:	8d 40 08             	lea    0x8(%eax),%eax
  8006e7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006ea:	bf 08 00 00 00       	mov    $0x8,%edi
  8006ef:	eb 51                	jmp    800742 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8006f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f4:	8b 00                	mov    (%eax),%eax
  8006f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fe:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800701:	8b 45 14             	mov    0x14(%ebp),%eax
  800704:	8d 40 04             	lea    0x4(%eax),%eax
  800707:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80070a:	bf 08 00 00 00       	mov    $0x8,%edi
  80070f:	eb 31                	jmp    800742 <vprintfmt+0x403>
			putch('0', putdat);
  800711:	83 ec 08             	sub    $0x8,%esp
  800714:	53                   	push   %ebx
  800715:	6a 30                	push   $0x30
  800717:	ff d6                	call   *%esi
			putch('x', putdat);
  800719:	83 c4 08             	add    $0x8,%esp
  80071c:	53                   	push   %ebx
  80071d:	6a 78                	push   $0x78
  80071f:	ff d6                	call   *%esi
			num = (unsigned long long)
  800721:	8b 45 14             	mov    0x14(%ebp),%eax
  800724:	8b 00                	mov    (%eax),%eax
  800726:	ba 00 00 00 00       	mov    $0x0,%edx
  80072b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80072e:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800731:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800734:	8b 45 14             	mov    0x14(%ebp),%eax
  800737:	8d 40 04             	lea    0x4(%eax),%eax
  80073a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80073d:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  800742:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800746:	74 0b                	je     800753 <vprintfmt+0x414>
				putch('+', putdat);
  800748:	83 ec 08             	sub    $0x8,%esp
  80074b:	53                   	push   %ebx
  80074c:	6a 2b                	push   $0x2b
  80074e:	ff d6                	call   *%esi
  800750:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  800753:	83 ec 0c             	sub    $0xc,%esp
  800756:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80075a:	50                   	push   %eax
  80075b:	ff 75 e0             	pushl  -0x20(%ebp)
  80075e:	57                   	push   %edi
  80075f:	ff 75 dc             	pushl  -0x24(%ebp)
  800762:	ff 75 d8             	pushl  -0x28(%ebp)
  800765:	89 da                	mov    %ebx,%edx
  800767:	89 f0                	mov    %esi,%eax
  800769:	e8 b8 fa ff ff       	call   800226 <printnum>
			break;
  80076e:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  800771:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800774:	83 c7 01             	add    $0x1,%edi
  800777:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80077b:	83 f8 25             	cmp    $0x25,%eax
  80077e:	0f 84 d2 fb ff ff    	je     800356 <vprintfmt+0x17>
			if (ch == '\0')
  800784:	85 c0                	test   %eax,%eax
  800786:	0f 84 03 01 00 00    	je     80088f <vprintfmt+0x550>
			putch(ch, putdat);
  80078c:	83 ec 08             	sub    $0x8,%esp
  80078f:	53                   	push   %ebx
  800790:	50                   	push   %eax
  800791:	ff d6                	call   *%esi
  800793:	83 c4 10             	add    $0x10,%esp
  800796:	eb dc                	jmp    800774 <vprintfmt+0x435>
	if (lflag >= 2)
  800798:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80079c:	7f 29                	jg     8007c7 <vprintfmt+0x488>
	else if (lflag)
  80079e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8007a2:	74 44                	je     8007e8 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  8007a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a7:	8b 00                	mov    (%eax),%eax
  8007a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b7:	8d 40 04             	lea    0x4(%eax),%eax
  8007ba:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007bd:	bf 10 00 00 00       	mov    $0x10,%edi
  8007c2:	e9 7b ff ff ff       	jmp    800742 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8007c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ca:	8b 50 04             	mov    0x4(%eax),%edx
  8007cd:	8b 00                	mov    (%eax),%eax
  8007cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d8:	8d 40 08             	lea    0x8(%eax),%eax
  8007db:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007de:	bf 10 00 00 00       	mov    $0x10,%edi
  8007e3:	e9 5a ff ff ff       	jmp    800742 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  8007e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007eb:	8b 00                	mov    (%eax),%eax
  8007ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fb:	8d 40 04             	lea    0x4(%eax),%eax
  8007fe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800801:	bf 10 00 00 00       	mov    $0x10,%edi
  800806:	e9 37 ff ff ff       	jmp    800742 <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  80080b:	8b 45 14             	mov    0x14(%ebp),%eax
  80080e:	8d 78 04             	lea    0x4(%eax),%edi
  800811:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  800813:	85 c0                	test   %eax,%eax
  800815:	74 2c                	je     800843 <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  800817:	8b 13                	mov    (%ebx),%edx
  800819:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  80081b:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  80081e:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  800821:	0f 8e 4a ff ff ff    	jle    800771 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  800827:	68 1c 14 80 00       	push   $0x80141c
  80082c:	68 cc 12 80 00       	push   $0x8012cc
  800831:	53                   	push   %ebx
  800832:	56                   	push   %esi
  800833:	e8 ea fa ff ff       	call   800322 <printfmt>
  800838:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  80083b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80083e:	e9 2e ff ff ff       	jmp    800771 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  800843:	68 e4 13 80 00       	push   $0x8013e4
  800848:	68 cc 12 80 00       	push   $0x8012cc
  80084d:	53                   	push   %ebx
  80084e:	56                   	push   %esi
  80084f:	e8 ce fa ff ff       	call   800322 <printfmt>
        		break;
  800854:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  800857:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  80085a:	e9 12 ff ff ff       	jmp    800771 <vprintfmt+0x432>
			putch(ch, putdat);
  80085f:	83 ec 08             	sub    $0x8,%esp
  800862:	53                   	push   %ebx
  800863:	6a 25                	push   $0x25
  800865:	ff d6                	call   *%esi
			break;
  800867:	83 c4 10             	add    $0x10,%esp
  80086a:	e9 02 ff ff ff       	jmp    800771 <vprintfmt+0x432>
			putch('%', putdat);
  80086f:	83 ec 08             	sub    $0x8,%esp
  800872:	53                   	push   %ebx
  800873:	6a 25                	push   $0x25
  800875:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800877:	83 c4 10             	add    $0x10,%esp
  80087a:	89 f8                	mov    %edi,%eax
  80087c:	eb 03                	jmp    800881 <vprintfmt+0x542>
  80087e:	83 e8 01             	sub    $0x1,%eax
  800881:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800885:	75 f7                	jne    80087e <vprintfmt+0x53f>
  800887:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80088a:	e9 e2 fe ff ff       	jmp    800771 <vprintfmt+0x432>
}
  80088f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800892:	5b                   	pop    %ebx
  800893:	5e                   	pop    %esi
  800894:	5f                   	pop    %edi
  800895:	5d                   	pop    %ebp
  800896:	c3                   	ret    

00800897 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800897:	55                   	push   %ebp
  800898:	89 e5                	mov    %esp,%ebp
  80089a:	83 ec 18             	sub    $0x18,%esp
  80089d:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a0:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008a6:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008aa:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008b4:	85 c0                	test   %eax,%eax
  8008b6:	74 26                	je     8008de <vsnprintf+0x47>
  8008b8:	85 d2                	test   %edx,%edx
  8008ba:	7e 22                	jle    8008de <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008bc:	ff 75 14             	pushl  0x14(%ebp)
  8008bf:	ff 75 10             	pushl  0x10(%ebp)
  8008c2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008c5:	50                   	push   %eax
  8008c6:	68 05 03 80 00       	push   $0x800305
  8008cb:	e8 6f fa ff ff       	call   80033f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008d3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008d9:	83 c4 10             	add    $0x10,%esp
}
  8008dc:	c9                   	leave  
  8008dd:	c3                   	ret    
		return -E_INVAL;
  8008de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008e3:	eb f7                	jmp    8008dc <vsnprintf+0x45>

008008e5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008e5:	55                   	push   %ebp
  8008e6:	89 e5                	mov    %esp,%ebp
  8008e8:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008eb:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008ee:	50                   	push   %eax
  8008ef:	ff 75 10             	pushl  0x10(%ebp)
  8008f2:	ff 75 0c             	pushl  0xc(%ebp)
  8008f5:	ff 75 08             	pushl  0x8(%ebp)
  8008f8:	e8 9a ff ff ff       	call   800897 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008fd:	c9                   	leave  
  8008fe:	c3                   	ret    

008008ff <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008ff:	55                   	push   %ebp
  800900:	89 e5                	mov    %esp,%ebp
  800902:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800905:	b8 00 00 00 00       	mov    $0x0,%eax
  80090a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80090e:	74 05                	je     800915 <strlen+0x16>
		n++;
  800910:	83 c0 01             	add    $0x1,%eax
  800913:	eb f5                	jmp    80090a <strlen+0xb>
	return n;
}
  800915:	5d                   	pop    %ebp
  800916:	c3                   	ret    

00800917 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
  80091a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80091d:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800920:	ba 00 00 00 00       	mov    $0x0,%edx
  800925:	39 c2                	cmp    %eax,%edx
  800927:	74 0d                	je     800936 <strnlen+0x1f>
  800929:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80092d:	74 05                	je     800934 <strnlen+0x1d>
		n++;
  80092f:	83 c2 01             	add    $0x1,%edx
  800932:	eb f1                	jmp    800925 <strnlen+0xe>
  800934:	89 d0                	mov    %edx,%eax
	return n;
}
  800936:	5d                   	pop    %ebp
  800937:	c3                   	ret    

00800938 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800938:	55                   	push   %ebp
  800939:	89 e5                	mov    %esp,%ebp
  80093b:	53                   	push   %ebx
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800942:	ba 00 00 00 00       	mov    $0x0,%edx
  800947:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80094b:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80094e:	83 c2 01             	add    $0x1,%edx
  800951:	84 c9                	test   %cl,%cl
  800953:	75 f2                	jne    800947 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800955:	5b                   	pop    %ebx
  800956:	5d                   	pop    %ebp
  800957:	c3                   	ret    

00800958 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800958:	55                   	push   %ebp
  800959:	89 e5                	mov    %esp,%ebp
  80095b:	53                   	push   %ebx
  80095c:	83 ec 10             	sub    $0x10,%esp
  80095f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800962:	53                   	push   %ebx
  800963:	e8 97 ff ff ff       	call   8008ff <strlen>
  800968:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80096b:	ff 75 0c             	pushl  0xc(%ebp)
  80096e:	01 d8                	add    %ebx,%eax
  800970:	50                   	push   %eax
  800971:	e8 c2 ff ff ff       	call   800938 <strcpy>
	return dst;
}
  800976:	89 d8                	mov    %ebx,%eax
  800978:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80097b:	c9                   	leave  
  80097c:	c3                   	ret    

0080097d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80097d:	55                   	push   %ebp
  80097e:	89 e5                	mov    %esp,%ebp
  800980:	56                   	push   %esi
  800981:	53                   	push   %ebx
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800988:	89 c6                	mov    %eax,%esi
  80098a:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80098d:	89 c2                	mov    %eax,%edx
  80098f:	39 f2                	cmp    %esi,%edx
  800991:	74 11                	je     8009a4 <strncpy+0x27>
		*dst++ = *src;
  800993:	83 c2 01             	add    $0x1,%edx
  800996:	0f b6 19             	movzbl (%ecx),%ebx
  800999:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80099c:	80 fb 01             	cmp    $0x1,%bl
  80099f:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009a2:	eb eb                	jmp    80098f <strncpy+0x12>
	}
	return ret;
}
  8009a4:	5b                   	pop    %ebx
  8009a5:	5e                   	pop    %esi
  8009a6:	5d                   	pop    %ebp
  8009a7:	c3                   	ret    

008009a8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009a8:	55                   	push   %ebp
  8009a9:	89 e5                	mov    %esp,%ebp
  8009ab:	56                   	push   %esi
  8009ac:	53                   	push   %ebx
  8009ad:	8b 75 08             	mov    0x8(%ebp),%esi
  8009b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009b3:	8b 55 10             	mov    0x10(%ebp),%edx
  8009b6:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009b8:	85 d2                	test   %edx,%edx
  8009ba:	74 21                	je     8009dd <strlcpy+0x35>
  8009bc:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009c0:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009c2:	39 c2                	cmp    %eax,%edx
  8009c4:	74 14                	je     8009da <strlcpy+0x32>
  8009c6:	0f b6 19             	movzbl (%ecx),%ebx
  8009c9:	84 db                	test   %bl,%bl
  8009cb:	74 0b                	je     8009d8 <strlcpy+0x30>
			*dst++ = *src++;
  8009cd:	83 c1 01             	add    $0x1,%ecx
  8009d0:	83 c2 01             	add    $0x1,%edx
  8009d3:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009d6:	eb ea                	jmp    8009c2 <strlcpy+0x1a>
  8009d8:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009da:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009dd:	29 f0                	sub    %esi,%eax
}
  8009df:	5b                   	pop    %ebx
  8009e0:	5e                   	pop    %esi
  8009e1:	5d                   	pop    %ebp
  8009e2:	c3                   	ret    

008009e3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009e3:	55                   	push   %ebp
  8009e4:	89 e5                	mov    %esp,%ebp
  8009e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009e9:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009ec:	0f b6 01             	movzbl (%ecx),%eax
  8009ef:	84 c0                	test   %al,%al
  8009f1:	74 0c                	je     8009ff <strcmp+0x1c>
  8009f3:	3a 02                	cmp    (%edx),%al
  8009f5:	75 08                	jne    8009ff <strcmp+0x1c>
		p++, q++;
  8009f7:	83 c1 01             	add    $0x1,%ecx
  8009fa:	83 c2 01             	add    $0x1,%edx
  8009fd:	eb ed                	jmp    8009ec <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009ff:	0f b6 c0             	movzbl %al,%eax
  800a02:	0f b6 12             	movzbl (%edx),%edx
  800a05:	29 d0                	sub    %edx,%eax
}
  800a07:	5d                   	pop    %ebp
  800a08:	c3                   	ret    

00800a09 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a09:	55                   	push   %ebp
  800a0a:	89 e5                	mov    %esp,%ebp
  800a0c:	53                   	push   %ebx
  800a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a10:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a13:	89 c3                	mov    %eax,%ebx
  800a15:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a18:	eb 06                	jmp    800a20 <strncmp+0x17>
		n--, p++, q++;
  800a1a:	83 c0 01             	add    $0x1,%eax
  800a1d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a20:	39 d8                	cmp    %ebx,%eax
  800a22:	74 16                	je     800a3a <strncmp+0x31>
  800a24:	0f b6 08             	movzbl (%eax),%ecx
  800a27:	84 c9                	test   %cl,%cl
  800a29:	74 04                	je     800a2f <strncmp+0x26>
  800a2b:	3a 0a                	cmp    (%edx),%cl
  800a2d:	74 eb                	je     800a1a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a2f:	0f b6 00             	movzbl (%eax),%eax
  800a32:	0f b6 12             	movzbl (%edx),%edx
  800a35:	29 d0                	sub    %edx,%eax
}
  800a37:	5b                   	pop    %ebx
  800a38:	5d                   	pop    %ebp
  800a39:	c3                   	ret    
		return 0;
  800a3a:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3f:	eb f6                	jmp    800a37 <strncmp+0x2e>

00800a41 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a41:	55                   	push   %ebp
  800a42:	89 e5                	mov    %esp,%ebp
  800a44:	8b 45 08             	mov    0x8(%ebp),%eax
  800a47:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a4b:	0f b6 10             	movzbl (%eax),%edx
  800a4e:	84 d2                	test   %dl,%dl
  800a50:	74 09                	je     800a5b <strchr+0x1a>
		if (*s == c)
  800a52:	38 ca                	cmp    %cl,%dl
  800a54:	74 0a                	je     800a60 <strchr+0x1f>
	for (; *s; s++)
  800a56:	83 c0 01             	add    $0x1,%eax
  800a59:	eb f0                	jmp    800a4b <strchr+0xa>
			return (char *) s;
	return 0;
  800a5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a60:	5d                   	pop    %ebp
  800a61:	c3                   	ret    

00800a62 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a62:	55                   	push   %ebp
  800a63:	89 e5                	mov    %esp,%ebp
  800a65:	8b 45 08             	mov    0x8(%ebp),%eax
  800a68:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a6c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a6f:	38 ca                	cmp    %cl,%dl
  800a71:	74 09                	je     800a7c <strfind+0x1a>
  800a73:	84 d2                	test   %dl,%dl
  800a75:	74 05                	je     800a7c <strfind+0x1a>
	for (; *s; s++)
  800a77:	83 c0 01             	add    $0x1,%eax
  800a7a:	eb f0                	jmp    800a6c <strfind+0xa>
			break;
	return (char *) s;
}
  800a7c:	5d                   	pop    %ebp
  800a7d:	c3                   	ret    

00800a7e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a7e:	55                   	push   %ebp
  800a7f:	89 e5                	mov    %esp,%ebp
  800a81:	57                   	push   %edi
  800a82:	56                   	push   %esi
  800a83:	53                   	push   %ebx
  800a84:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a87:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a8a:	85 c9                	test   %ecx,%ecx
  800a8c:	74 31                	je     800abf <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a8e:	89 f8                	mov    %edi,%eax
  800a90:	09 c8                	or     %ecx,%eax
  800a92:	a8 03                	test   $0x3,%al
  800a94:	75 23                	jne    800ab9 <memset+0x3b>
		c &= 0xFF;
  800a96:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a9a:	89 d3                	mov    %edx,%ebx
  800a9c:	c1 e3 08             	shl    $0x8,%ebx
  800a9f:	89 d0                	mov    %edx,%eax
  800aa1:	c1 e0 18             	shl    $0x18,%eax
  800aa4:	89 d6                	mov    %edx,%esi
  800aa6:	c1 e6 10             	shl    $0x10,%esi
  800aa9:	09 f0                	or     %esi,%eax
  800aab:	09 c2                	or     %eax,%edx
  800aad:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800aaf:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ab2:	89 d0                	mov    %edx,%eax
  800ab4:	fc                   	cld    
  800ab5:	f3 ab                	rep stos %eax,%es:(%edi)
  800ab7:	eb 06                	jmp    800abf <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ab9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abc:	fc                   	cld    
  800abd:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800abf:	89 f8                	mov    %edi,%eax
  800ac1:	5b                   	pop    %ebx
  800ac2:	5e                   	pop    %esi
  800ac3:	5f                   	pop    %edi
  800ac4:	5d                   	pop    %ebp
  800ac5:	c3                   	ret    

00800ac6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ac6:	55                   	push   %ebp
  800ac7:	89 e5                	mov    %esp,%ebp
  800ac9:	57                   	push   %edi
  800aca:	56                   	push   %esi
  800acb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ace:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ad1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ad4:	39 c6                	cmp    %eax,%esi
  800ad6:	73 32                	jae    800b0a <memmove+0x44>
  800ad8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800adb:	39 c2                	cmp    %eax,%edx
  800add:	76 2b                	jbe    800b0a <memmove+0x44>
		s += n;
		d += n;
  800adf:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ae2:	89 fe                	mov    %edi,%esi
  800ae4:	09 ce                	or     %ecx,%esi
  800ae6:	09 d6                	or     %edx,%esi
  800ae8:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aee:	75 0e                	jne    800afe <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800af0:	83 ef 04             	sub    $0x4,%edi
  800af3:	8d 72 fc             	lea    -0x4(%edx),%esi
  800af6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800af9:	fd                   	std    
  800afa:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800afc:	eb 09                	jmp    800b07 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800afe:	83 ef 01             	sub    $0x1,%edi
  800b01:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b04:	fd                   	std    
  800b05:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b07:	fc                   	cld    
  800b08:	eb 1a                	jmp    800b24 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b0a:	89 c2                	mov    %eax,%edx
  800b0c:	09 ca                	or     %ecx,%edx
  800b0e:	09 f2                	or     %esi,%edx
  800b10:	f6 c2 03             	test   $0x3,%dl
  800b13:	75 0a                	jne    800b1f <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b15:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b18:	89 c7                	mov    %eax,%edi
  800b1a:	fc                   	cld    
  800b1b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b1d:	eb 05                	jmp    800b24 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b1f:	89 c7                	mov    %eax,%edi
  800b21:	fc                   	cld    
  800b22:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b24:	5e                   	pop    %esi
  800b25:	5f                   	pop    %edi
  800b26:	5d                   	pop    %ebp
  800b27:	c3                   	ret    

00800b28 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b28:	55                   	push   %ebp
  800b29:	89 e5                	mov    %esp,%ebp
  800b2b:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b2e:	ff 75 10             	pushl  0x10(%ebp)
  800b31:	ff 75 0c             	pushl  0xc(%ebp)
  800b34:	ff 75 08             	pushl  0x8(%ebp)
  800b37:	e8 8a ff ff ff       	call   800ac6 <memmove>
}
  800b3c:	c9                   	leave  
  800b3d:	c3                   	ret    

00800b3e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b3e:	55                   	push   %ebp
  800b3f:	89 e5                	mov    %esp,%ebp
  800b41:	56                   	push   %esi
  800b42:	53                   	push   %ebx
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b49:	89 c6                	mov    %eax,%esi
  800b4b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b4e:	39 f0                	cmp    %esi,%eax
  800b50:	74 1c                	je     800b6e <memcmp+0x30>
		if (*s1 != *s2)
  800b52:	0f b6 08             	movzbl (%eax),%ecx
  800b55:	0f b6 1a             	movzbl (%edx),%ebx
  800b58:	38 d9                	cmp    %bl,%cl
  800b5a:	75 08                	jne    800b64 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b5c:	83 c0 01             	add    $0x1,%eax
  800b5f:	83 c2 01             	add    $0x1,%edx
  800b62:	eb ea                	jmp    800b4e <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b64:	0f b6 c1             	movzbl %cl,%eax
  800b67:	0f b6 db             	movzbl %bl,%ebx
  800b6a:	29 d8                	sub    %ebx,%eax
  800b6c:	eb 05                	jmp    800b73 <memcmp+0x35>
	}

	return 0;
  800b6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b73:	5b                   	pop    %ebx
  800b74:	5e                   	pop    %esi
  800b75:	5d                   	pop    %ebp
  800b76:	c3                   	ret    

00800b77 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b77:	55                   	push   %ebp
  800b78:	89 e5                	mov    %esp,%ebp
  800b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b80:	89 c2                	mov    %eax,%edx
  800b82:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b85:	39 d0                	cmp    %edx,%eax
  800b87:	73 09                	jae    800b92 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b89:	38 08                	cmp    %cl,(%eax)
  800b8b:	74 05                	je     800b92 <memfind+0x1b>
	for (; s < ends; s++)
  800b8d:	83 c0 01             	add    $0x1,%eax
  800b90:	eb f3                	jmp    800b85 <memfind+0xe>
			break;
	return (void *) s;
}
  800b92:	5d                   	pop    %ebp
  800b93:	c3                   	ret    

00800b94 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b94:	55                   	push   %ebp
  800b95:	89 e5                	mov    %esp,%ebp
  800b97:	57                   	push   %edi
  800b98:	56                   	push   %esi
  800b99:	53                   	push   %ebx
  800b9a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b9d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ba0:	eb 03                	jmp    800ba5 <strtol+0x11>
		s++;
  800ba2:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ba5:	0f b6 01             	movzbl (%ecx),%eax
  800ba8:	3c 20                	cmp    $0x20,%al
  800baa:	74 f6                	je     800ba2 <strtol+0xe>
  800bac:	3c 09                	cmp    $0x9,%al
  800bae:	74 f2                	je     800ba2 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bb0:	3c 2b                	cmp    $0x2b,%al
  800bb2:	74 2a                	je     800bde <strtol+0x4a>
	int neg = 0;
  800bb4:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bb9:	3c 2d                	cmp    $0x2d,%al
  800bbb:	74 2b                	je     800be8 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bbd:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bc3:	75 0f                	jne    800bd4 <strtol+0x40>
  800bc5:	80 39 30             	cmpb   $0x30,(%ecx)
  800bc8:	74 28                	je     800bf2 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bca:	85 db                	test   %ebx,%ebx
  800bcc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bd1:	0f 44 d8             	cmove  %eax,%ebx
  800bd4:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bdc:	eb 50                	jmp    800c2e <strtol+0x9a>
		s++;
  800bde:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800be1:	bf 00 00 00 00       	mov    $0x0,%edi
  800be6:	eb d5                	jmp    800bbd <strtol+0x29>
		s++, neg = 1;
  800be8:	83 c1 01             	add    $0x1,%ecx
  800beb:	bf 01 00 00 00       	mov    $0x1,%edi
  800bf0:	eb cb                	jmp    800bbd <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bf2:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bf6:	74 0e                	je     800c06 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bf8:	85 db                	test   %ebx,%ebx
  800bfa:	75 d8                	jne    800bd4 <strtol+0x40>
		s++, base = 8;
  800bfc:	83 c1 01             	add    $0x1,%ecx
  800bff:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c04:	eb ce                	jmp    800bd4 <strtol+0x40>
		s += 2, base = 16;
  800c06:	83 c1 02             	add    $0x2,%ecx
  800c09:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c0e:	eb c4                	jmp    800bd4 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c10:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c13:	89 f3                	mov    %esi,%ebx
  800c15:	80 fb 19             	cmp    $0x19,%bl
  800c18:	77 29                	ja     800c43 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c1a:	0f be d2             	movsbl %dl,%edx
  800c1d:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c20:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c23:	7d 30                	jge    800c55 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c25:	83 c1 01             	add    $0x1,%ecx
  800c28:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c2c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c2e:	0f b6 11             	movzbl (%ecx),%edx
  800c31:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c34:	89 f3                	mov    %esi,%ebx
  800c36:	80 fb 09             	cmp    $0x9,%bl
  800c39:	77 d5                	ja     800c10 <strtol+0x7c>
			dig = *s - '0';
  800c3b:	0f be d2             	movsbl %dl,%edx
  800c3e:	83 ea 30             	sub    $0x30,%edx
  800c41:	eb dd                	jmp    800c20 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c43:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c46:	89 f3                	mov    %esi,%ebx
  800c48:	80 fb 19             	cmp    $0x19,%bl
  800c4b:	77 08                	ja     800c55 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c4d:	0f be d2             	movsbl %dl,%edx
  800c50:	83 ea 37             	sub    $0x37,%edx
  800c53:	eb cb                	jmp    800c20 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c55:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c59:	74 05                	je     800c60 <strtol+0xcc>
		*endptr = (char *) s;
  800c5b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c5e:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c60:	89 c2                	mov    %eax,%edx
  800c62:	f7 da                	neg    %edx
  800c64:	85 ff                	test   %edi,%edi
  800c66:	0f 45 c2             	cmovne %edx,%eax
}
  800c69:	5b                   	pop    %ebx
  800c6a:	5e                   	pop    %esi
  800c6b:	5f                   	pop    %edi
  800c6c:	5d                   	pop    %ebp
  800c6d:	c3                   	ret    

00800c6e <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	57                   	push   %edi
  800c72:	56                   	push   %esi
  800c73:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c74:	b8 00 00 00 00       	mov    $0x0,%eax
  800c79:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c7f:	89 c3                	mov    %eax,%ebx
  800c81:	89 c7                	mov    %eax,%edi
  800c83:	89 c6                	mov    %eax,%esi
  800c85:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c87:	5b                   	pop    %ebx
  800c88:	5e                   	pop    %esi
  800c89:	5f                   	pop    %edi
  800c8a:	5d                   	pop    %ebp
  800c8b:	c3                   	ret    

00800c8c <sys_cgetc>:

int
sys_cgetc(void)
{
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	57                   	push   %edi
  800c90:	56                   	push   %esi
  800c91:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c92:	ba 00 00 00 00       	mov    $0x0,%edx
  800c97:	b8 01 00 00 00       	mov    $0x1,%eax
  800c9c:	89 d1                	mov    %edx,%ecx
  800c9e:	89 d3                	mov    %edx,%ebx
  800ca0:	89 d7                	mov    %edx,%edi
  800ca2:	89 d6                	mov    %edx,%esi
  800ca4:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ca6:	5b                   	pop    %ebx
  800ca7:	5e                   	pop    %esi
  800ca8:	5f                   	pop    %edi
  800ca9:	5d                   	pop    %ebp
  800caa:	c3                   	ret    

00800cab <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cab:	55                   	push   %ebp
  800cac:	89 e5                	mov    %esp,%ebp
  800cae:	57                   	push   %edi
  800caf:	56                   	push   %esi
  800cb0:	53                   	push   %ebx
  800cb1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbc:	b8 03 00 00 00       	mov    $0x3,%eax
  800cc1:	89 cb                	mov    %ecx,%ebx
  800cc3:	89 cf                	mov    %ecx,%edi
  800cc5:	89 ce                	mov    %ecx,%esi
  800cc7:	cd 30                	int    $0x30
	if (check && ret > 0)
  800cc9:	85 c0                	test   %eax,%eax
  800ccb:	7f 08                	jg     800cd5 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ccd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd0:	5b                   	pop    %ebx
  800cd1:	5e                   	pop    %esi
  800cd2:	5f                   	pop    %edi
  800cd3:	5d                   	pop    %ebp
  800cd4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd5:	83 ec 0c             	sub    $0xc,%esp
  800cd8:	50                   	push   %eax
  800cd9:	6a 03                	push   $0x3
  800cdb:	68 20 16 80 00       	push   $0x801620
  800ce0:	6a 4c                	push   $0x4c
  800ce2:	68 3d 16 80 00       	push   $0x80163d
  800ce7:	e8 4b f4 ff ff       	call   800137 <_panic>

00800cec <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cec:	55                   	push   %ebp
  800ced:	89 e5                	mov    %esp,%ebp
  800cef:	57                   	push   %edi
  800cf0:	56                   	push   %esi
  800cf1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cf2:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf7:	b8 02 00 00 00       	mov    $0x2,%eax
  800cfc:	89 d1                	mov    %edx,%ecx
  800cfe:	89 d3                	mov    %edx,%ebx
  800d00:	89 d7                	mov    %edx,%edi
  800d02:	89 d6                	mov    %edx,%esi
  800d04:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d06:	5b                   	pop    %ebx
  800d07:	5e                   	pop    %esi
  800d08:	5f                   	pop    %edi
  800d09:	5d                   	pop    %ebp
  800d0a:	c3                   	ret    

00800d0b <sys_yield>:

void
sys_yield(void)
{
  800d0b:	55                   	push   %ebp
  800d0c:	89 e5                	mov    %esp,%ebp
  800d0e:	57                   	push   %edi
  800d0f:	56                   	push   %esi
  800d10:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d11:	ba 00 00 00 00       	mov    $0x0,%edx
  800d16:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d1b:	89 d1                	mov    %edx,%ecx
  800d1d:	89 d3                	mov    %edx,%ebx
  800d1f:	89 d7                	mov    %edx,%edi
  800d21:	89 d6                	mov    %edx,%esi
  800d23:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d25:	5b                   	pop    %ebx
  800d26:	5e                   	pop    %esi
  800d27:	5f                   	pop    %edi
  800d28:	5d                   	pop    %ebp
  800d29:	c3                   	ret    

00800d2a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	57                   	push   %edi
  800d2e:	56                   	push   %esi
  800d2f:	53                   	push   %ebx
  800d30:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d33:	be 00 00 00 00       	mov    $0x0,%esi
  800d38:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3e:	b8 04 00 00 00       	mov    $0x4,%eax
  800d43:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d46:	89 f7                	mov    %esi,%edi
  800d48:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d4a:	85 c0                	test   %eax,%eax
  800d4c:	7f 08                	jg     800d56 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d51:	5b                   	pop    %ebx
  800d52:	5e                   	pop    %esi
  800d53:	5f                   	pop    %edi
  800d54:	5d                   	pop    %ebp
  800d55:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d56:	83 ec 0c             	sub    $0xc,%esp
  800d59:	50                   	push   %eax
  800d5a:	6a 04                	push   $0x4
  800d5c:	68 20 16 80 00       	push   $0x801620
  800d61:	6a 4c                	push   $0x4c
  800d63:	68 3d 16 80 00       	push   $0x80163d
  800d68:	e8 ca f3 ff ff       	call   800137 <_panic>

00800d6d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
  800d70:	57                   	push   %edi
  800d71:	56                   	push   %esi
  800d72:	53                   	push   %ebx
  800d73:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d76:	8b 55 08             	mov    0x8(%ebp),%edx
  800d79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7c:	b8 05 00 00 00       	mov    $0x5,%eax
  800d81:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d84:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d87:	8b 75 18             	mov    0x18(%ebp),%esi
  800d8a:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d8c:	85 c0                	test   %eax,%eax
  800d8e:	7f 08                	jg     800d98 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d93:	5b                   	pop    %ebx
  800d94:	5e                   	pop    %esi
  800d95:	5f                   	pop    %edi
  800d96:	5d                   	pop    %ebp
  800d97:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d98:	83 ec 0c             	sub    $0xc,%esp
  800d9b:	50                   	push   %eax
  800d9c:	6a 05                	push   $0x5
  800d9e:	68 20 16 80 00       	push   $0x801620
  800da3:	6a 4c                	push   $0x4c
  800da5:	68 3d 16 80 00       	push   $0x80163d
  800daa:	e8 88 f3 ff ff       	call   800137 <_panic>

00800daf <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	57                   	push   %edi
  800db3:	56                   	push   %esi
  800db4:	53                   	push   %ebx
  800db5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dbd:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc3:	b8 06 00 00 00       	mov    $0x6,%eax
  800dc8:	89 df                	mov    %ebx,%edi
  800dca:	89 de                	mov    %ebx,%esi
  800dcc:	cd 30                	int    $0x30
	if (check && ret > 0)
  800dce:	85 c0                	test   %eax,%eax
  800dd0:	7f 08                	jg     800dda <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd5:	5b                   	pop    %ebx
  800dd6:	5e                   	pop    %esi
  800dd7:	5f                   	pop    %edi
  800dd8:	5d                   	pop    %ebp
  800dd9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dda:	83 ec 0c             	sub    $0xc,%esp
  800ddd:	50                   	push   %eax
  800dde:	6a 06                	push   $0x6
  800de0:	68 20 16 80 00       	push   $0x801620
  800de5:	6a 4c                	push   $0x4c
  800de7:	68 3d 16 80 00       	push   $0x80163d
  800dec:	e8 46 f3 ff ff       	call   800137 <_panic>

00800df1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800df1:	55                   	push   %ebp
  800df2:	89 e5                	mov    %esp,%ebp
  800df4:	57                   	push   %edi
  800df5:	56                   	push   %esi
  800df6:	53                   	push   %ebx
  800df7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dfa:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dff:	8b 55 08             	mov    0x8(%ebp),%edx
  800e02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e05:	b8 08 00 00 00       	mov    $0x8,%eax
  800e0a:	89 df                	mov    %ebx,%edi
  800e0c:	89 de                	mov    %ebx,%esi
  800e0e:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e10:	85 c0                	test   %eax,%eax
  800e12:	7f 08                	jg     800e1c <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e17:	5b                   	pop    %ebx
  800e18:	5e                   	pop    %esi
  800e19:	5f                   	pop    %edi
  800e1a:	5d                   	pop    %ebp
  800e1b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1c:	83 ec 0c             	sub    $0xc,%esp
  800e1f:	50                   	push   %eax
  800e20:	6a 08                	push   $0x8
  800e22:	68 20 16 80 00       	push   $0x801620
  800e27:	6a 4c                	push   $0x4c
  800e29:	68 3d 16 80 00       	push   $0x80163d
  800e2e:	e8 04 f3 ff ff       	call   800137 <_panic>

00800e33 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e33:	55                   	push   %ebp
  800e34:	89 e5                	mov    %esp,%ebp
  800e36:	57                   	push   %edi
  800e37:	56                   	push   %esi
  800e38:	53                   	push   %ebx
  800e39:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e3c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e41:	8b 55 08             	mov    0x8(%ebp),%edx
  800e44:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e47:	b8 09 00 00 00       	mov    $0x9,%eax
  800e4c:	89 df                	mov    %ebx,%edi
  800e4e:	89 de                	mov    %ebx,%esi
  800e50:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e52:	85 c0                	test   %eax,%eax
  800e54:	7f 08                	jg     800e5e <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e56:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e59:	5b                   	pop    %ebx
  800e5a:	5e                   	pop    %esi
  800e5b:	5f                   	pop    %edi
  800e5c:	5d                   	pop    %ebp
  800e5d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5e:	83 ec 0c             	sub    $0xc,%esp
  800e61:	50                   	push   %eax
  800e62:	6a 09                	push   $0x9
  800e64:	68 20 16 80 00       	push   $0x801620
  800e69:	6a 4c                	push   $0x4c
  800e6b:	68 3d 16 80 00       	push   $0x80163d
  800e70:	e8 c2 f2 ff ff       	call   800137 <_panic>

00800e75 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e75:	55                   	push   %ebp
  800e76:	89 e5                	mov    %esp,%ebp
  800e78:	57                   	push   %edi
  800e79:	56                   	push   %esi
  800e7a:	53                   	push   %ebx
  800e7b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e7e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e83:	8b 55 08             	mov    0x8(%ebp),%edx
  800e86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e89:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e8e:	89 df                	mov    %ebx,%edi
  800e90:	89 de                	mov    %ebx,%esi
  800e92:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e94:	85 c0                	test   %eax,%eax
  800e96:	7f 08                	jg     800ea0 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e9b:	5b                   	pop    %ebx
  800e9c:	5e                   	pop    %esi
  800e9d:	5f                   	pop    %edi
  800e9e:	5d                   	pop    %ebp
  800e9f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea0:	83 ec 0c             	sub    $0xc,%esp
  800ea3:	50                   	push   %eax
  800ea4:	6a 0a                	push   $0xa
  800ea6:	68 20 16 80 00       	push   $0x801620
  800eab:	6a 4c                	push   $0x4c
  800ead:	68 3d 16 80 00       	push   $0x80163d
  800eb2:	e8 80 f2 ff ff       	call   800137 <_panic>

00800eb7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800eb7:	55                   	push   %ebp
  800eb8:	89 e5                	mov    %esp,%ebp
  800eba:	57                   	push   %edi
  800ebb:	56                   	push   %esi
  800ebc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ebd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec3:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ec8:	be 00 00 00 00       	mov    $0x0,%esi
  800ecd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ed0:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ed3:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ed5:	5b                   	pop    %ebx
  800ed6:	5e                   	pop    %esi
  800ed7:	5f                   	pop    %edi
  800ed8:	5d                   	pop    %ebp
  800ed9:	c3                   	ret    

00800eda <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800eda:	55                   	push   %ebp
  800edb:	89 e5                	mov    %esp,%ebp
  800edd:	57                   	push   %edi
  800ede:	56                   	push   %esi
  800edf:	53                   	push   %ebx
  800ee0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ee8:	8b 55 08             	mov    0x8(%ebp),%edx
  800eeb:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ef0:	89 cb                	mov    %ecx,%ebx
  800ef2:	89 cf                	mov    %ecx,%edi
  800ef4:	89 ce                	mov    %ecx,%esi
  800ef6:	cd 30                	int    $0x30
	if (check && ret > 0)
  800ef8:	85 c0                	test   %eax,%eax
  800efa:	7f 08                	jg     800f04 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800efc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eff:	5b                   	pop    %ebx
  800f00:	5e                   	pop    %esi
  800f01:	5f                   	pop    %edi
  800f02:	5d                   	pop    %ebp
  800f03:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f04:	83 ec 0c             	sub    $0xc,%esp
  800f07:	50                   	push   %eax
  800f08:	6a 0d                	push   $0xd
  800f0a:	68 20 16 80 00       	push   $0x801620
  800f0f:	6a 4c                	push   $0x4c
  800f11:	68 3d 16 80 00       	push   $0x80163d
  800f16:	e8 1c f2 ff ff       	call   800137 <_panic>

00800f1b <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
  800f1e:	57                   	push   %edi
  800f1f:	56                   	push   %esi
  800f20:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f21:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f26:	8b 55 08             	mov    0x8(%ebp),%edx
  800f29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2c:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f31:	89 df                	mov    %ebx,%edi
  800f33:	89 de                	mov    %ebx,%esi
  800f35:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f37:	5b                   	pop    %ebx
  800f38:	5e                   	pop    %esi
  800f39:	5f                   	pop    %edi
  800f3a:	5d                   	pop    %ebp
  800f3b:	c3                   	ret    

00800f3c <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f3c:	55                   	push   %ebp
  800f3d:	89 e5                	mov    %esp,%ebp
  800f3f:	57                   	push   %edi
  800f40:	56                   	push   %esi
  800f41:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f42:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f47:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4a:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f4f:	89 cb                	mov    %ecx,%ebx
  800f51:	89 cf                	mov    %ecx,%edi
  800f53:	89 ce                	mov    %ecx,%esi
  800f55:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f57:	5b                   	pop    %ebx
  800f58:	5e                   	pop    %esi
  800f59:	5f                   	pop    %edi
  800f5a:	5d                   	pop    %ebp
  800f5b:	c3                   	ret    
  800f5c:	66 90                	xchg   %ax,%ax
  800f5e:	66 90                	xchg   %ax,%ax

00800f60 <__udivdi3>:
  800f60:	55                   	push   %ebp
  800f61:	57                   	push   %edi
  800f62:	56                   	push   %esi
  800f63:	53                   	push   %ebx
  800f64:	83 ec 1c             	sub    $0x1c,%esp
  800f67:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800f6b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800f6f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800f73:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800f77:	85 d2                	test   %edx,%edx
  800f79:	75 4d                	jne    800fc8 <__udivdi3+0x68>
  800f7b:	39 f3                	cmp    %esi,%ebx
  800f7d:	76 19                	jbe    800f98 <__udivdi3+0x38>
  800f7f:	31 ff                	xor    %edi,%edi
  800f81:	89 e8                	mov    %ebp,%eax
  800f83:	89 f2                	mov    %esi,%edx
  800f85:	f7 f3                	div    %ebx
  800f87:	89 fa                	mov    %edi,%edx
  800f89:	83 c4 1c             	add    $0x1c,%esp
  800f8c:	5b                   	pop    %ebx
  800f8d:	5e                   	pop    %esi
  800f8e:	5f                   	pop    %edi
  800f8f:	5d                   	pop    %ebp
  800f90:	c3                   	ret    
  800f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f98:	89 d9                	mov    %ebx,%ecx
  800f9a:	85 db                	test   %ebx,%ebx
  800f9c:	75 0b                	jne    800fa9 <__udivdi3+0x49>
  800f9e:	b8 01 00 00 00       	mov    $0x1,%eax
  800fa3:	31 d2                	xor    %edx,%edx
  800fa5:	f7 f3                	div    %ebx
  800fa7:	89 c1                	mov    %eax,%ecx
  800fa9:	31 d2                	xor    %edx,%edx
  800fab:	89 f0                	mov    %esi,%eax
  800fad:	f7 f1                	div    %ecx
  800faf:	89 c6                	mov    %eax,%esi
  800fb1:	89 e8                	mov    %ebp,%eax
  800fb3:	89 f7                	mov    %esi,%edi
  800fb5:	f7 f1                	div    %ecx
  800fb7:	89 fa                	mov    %edi,%edx
  800fb9:	83 c4 1c             	add    $0x1c,%esp
  800fbc:	5b                   	pop    %ebx
  800fbd:	5e                   	pop    %esi
  800fbe:	5f                   	pop    %edi
  800fbf:	5d                   	pop    %ebp
  800fc0:	c3                   	ret    
  800fc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fc8:	39 f2                	cmp    %esi,%edx
  800fca:	77 1c                	ja     800fe8 <__udivdi3+0x88>
  800fcc:	0f bd fa             	bsr    %edx,%edi
  800fcf:	83 f7 1f             	xor    $0x1f,%edi
  800fd2:	75 2c                	jne    801000 <__udivdi3+0xa0>
  800fd4:	39 f2                	cmp    %esi,%edx
  800fd6:	72 06                	jb     800fde <__udivdi3+0x7e>
  800fd8:	31 c0                	xor    %eax,%eax
  800fda:	39 eb                	cmp    %ebp,%ebx
  800fdc:	77 a9                	ja     800f87 <__udivdi3+0x27>
  800fde:	b8 01 00 00 00       	mov    $0x1,%eax
  800fe3:	eb a2                	jmp    800f87 <__udivdi3+0x27>
  800fe5:	8d 76 00             	lea    0x0(%esi),%esi
  800fe8:	31 ff                	xor    %edi,%edi
  800fea:	31 c0                	xor    %eax,%eax
  800fec:	89 fa                	mov    %edi,%edx
  800fee:	83 c4 1c             	add    $0x1c,%esp
  800ff1:	5b                   	pop    %ebx
  800ff2:	5e                   	pop    %esi
  800ff3:	5f                   	pop    %edi
  800ff4:	5d                   	pop    %ebp
  800ff5:	c3                   	ret    
  800ff6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ffd:	8d 76 00             	lea    0x0(%esi),%esi
  801000:	89 f9                	mov    %edi,%ecx
  801002:	b8 20 00 00 00       	mov    $0x20,%eax
  801007:	29 f8                	sub    %edi,%eax
  801009:	d3 e2                	shl    %cl,%edx
  80100b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80100f:	89 c1                	mov    %eax,%ecx
  801011:	89 da                	mov    %ebx,%edx
  801013:	d3 ea                	shr    %cl,%edx
  801015:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801019:	09 d1                	or     %edx,%ecx
  80101b:	89 f2                	mov    %esi,%edx
  80101d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801021:	89 f9                	mov    %edi,%ecx
  801023:	d3 e3                	shl    %cl,%ebx
  801025:	89 c1                	mov    %eax,%ecx
  801027:	d3 ea                	shr    %cl,%edx
  801029:	89 f9                	mov    %edi,%ecx
  80102b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80102f:	89 eb                	mov    %ebp,%ebx
  801031:	d3 e6                	shl    %cl,%esi
  801033:	89 c1                	mov    %eax,%ecx
  801035:	d3 eb                	shr    %cl,%ebx
  801037:	09 de                	or     %ebx,%esi
  801039:	89 f0                	mov    %esi,%eax
  80103b:	f7 74 24 08          	divl   0x8(%esp)
  80103f:	89 d6                	mov    %edx,%esi
  801041:	89 c3                	mov    %eax,%ebx
  801043:	f7 64 24 0c          	mull   0xc(%esp)
  801047:	39 d6                	cmp    %edx,%esi
  801049:	72 15                	jb     801060 <__udivdi3+0x100>
  80104b:	89 f9                	mov    %edi,%ecx
  80104d:	d3 e5                	shl    %cl,%ebp
  80104f:	39 c5                	cmp    %eax,%ebp
  801051:	73 04                	jae    801057 <__udivdi3+0xf7>
  801053:	39 d6                	cmp    %edx,%esi
  801055:	74 09                	je     801060 <__udivdi3+0x100>
  801057:	89 d8                	mov    %ebx,%eax
  801059:	31 ff                	xor    %edi,%edi
  80105b:	e9 27 ff ff ff       	jmp    800f87 <__udivdi3+0x27>
  801060:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801063:	31 ff                	xor    %edi,%edi
  801065:	e9 1d ff ff ff       	jmp    800f87 <__udivdi3+0x27>
  80106a:	66 90                	xchg   %ax,%ax
  80106c:	66 90                	xchg   %ax,%ax
  80106e:	66 90                	xchg   %ax,%ax

00801070 <__umoddi3>:
  801070:	55                   	push   %ebp
  801071:	57                   	push   %edi
  801072:	56                   	push   %esi
  801073:	53                   	push   %ebx
  801074:	83 ec 1c             	sub    $0x1c,%esp
  801077:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80107b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80107f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801083:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801087:	89 da                	mov    %ebx,%edx
  801089:	85 c0                	test   %eax,%eax
  80108b:	75 43                	jne    8010d0 <__umoddi3+0x60>
  80108d:	39 df                	cmp    %ebx,%edi
  80108f:	76 17                	jbe    8010a8 <__umoddi3+0x38>
  801091:	89 f0                	mov    %esi,%eax
  801093:	f7 f7                	div    %edi
  801095:	89 d0                	mov    %edx,%eax
  801097:	31 d2                	xor    %edx,%edx
  801099:	83 c4 1c             	add    $0x1c,%esp
  80109c:	5b                   	pop    %ebx
  80109d:	5e                   	pop    %esi
  80109e:	5f                   	pop    %edi
  80109f:	5d                   	pop    %ebp
  8010a0:	c3                   	ret    
  8010a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010a8:	89 fd                	mov    %edi,%ebp
  8010aa:	85 ff                	test   %edi,%edi
  8010ac:	75 0b                	jne    8010b9 <__umoddi3+0x49>
  8010ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8010b3:	31 d2                	xor    %edx,%edx
  8010b5:	f7 f7                	div    %edi
  8010b7:	89 c5                	mov    %eax,%ebp
  8010b9:	89 d8                	mov    %ebx,%eax
  8010bb:	31 d2                	xor    %edx,%edx
  8010bd:	f7 f5                	div    %ebp
  8010bf:	89 f0                	mov    %esi,%eax
  8010c1:	f7 f5                	div    %ebp
  8010c3:	89 d0                	mov    %edx,%eax
  8010c5:	eb d0                	jmp    801097 <__umoddi3+0x27>
  8010c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010ce:	66 90                	xchg   %ax,%ax
  8010d0:	89 f1                	mov    %esi,%ecx
  8010d2:	39 d8                	cmp    %ebx,%eax
  8010d4:	76 0a                	jbe    8010e0 <__umoddi3+0x70>
  8010d6:	89 f0                	mov    %esi,%eax
  8010d8:	83 c4 1c             	add    $0x1c,%esp
  8010db:	5b                   	pop    %ebx
  8010dc:	5e                   	pop    %esi
  8010dd:	5f                   	pop    %edi
  8010de:	5d                   	pop    %ebp
  8010df:	c3                   	ret    
  8010e0:	0f bd e8             	bsr    %eax,%ebp
  8010e3:	83 f5 1f             	xor    $0x1f,%ebp
  8010e6:	75 20                	jne    801108 <__umoddi3+0x98>
  8010e8:	39 d8                	cmp    %ebx,%eax
  8010ea:	0f 82 b0 00 00 00    	jb     8011a0 <__umoddi3+0x130>
  8010f0:	39 f7                	cmp    %esi,%edi
  8010f2:	0f 86 a8 00 00 00    	jbe    8011a0 <__umoddi3+0x130>
  8010f8:	89 c8                	mov    %ecx,%eax
  8010fa:	83 c4 1c             	add    $0x1c,%esp
  8010fd:	5b                   	pop    %ebx
  8010fe:	5e                   	pop    %esi
  8010ff:	5f                   	pop    %edi
  801100:	5d                   	pop    %ebp
  801101:	c3                   	ret    
  801102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801108:	89 e9                	mov    %ebp,%ecx
  80110a:	ba 20 00 00 00       	mov    $0x20,%edx
  80110f:	29 ea                	sub    %ebp,%edx
  801111:	d3 e0                	shl    %cl,%eax
  801113:	89 44 24 08          	mov    %eax,0x8(%esp)
  801117:	89 d1                	mov    %edx,%ecx
  801119:	89 f8                	mov    %edi,%eax
  80111b:	d3 e8                	shr    %cl,%eax
  80111d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801121:	89 54 24 04          	mov    %edx,0x4(%esp)
  801125:	8b 54 24 04          	mov    0x4(%esp),%edx
  801129:	09 c1                	or     %eax,%ecx
  80112b:	89 d8                	mov    %ebx,%eax
  80112d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801131:	89 e9                	mov    %ebp,%ecx
  801133:	d3 e7                	shl    %cl,%edi
  801135:	89 d1                	mov    %edx,%ecx
  801137:	d3 e8                	shr    %cl,%eax
  801139:	89 e9                	mov    %ebp,%ecx
  80113b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80113f:	d3 e3                	shl    %cl,%ebx
  801141:	89 c7                	mov    %eax,%edi
  801143:	89 d1                	mov    %edx,%ecx
  801145:	89 f0                	mov    %esi,%eax
  801147:	d3 e8                	shr    %cl,%eax
  801149:	89 e9                	mov    %ebp,%ecx
  80114b:	89 fa                	mov    %edi,%edx
  80114d:	d3 e6                	shl    %cl,%esi
  80114f:	09 d8                	or     %ebx,%eax
  801151:	f7 74 24 08          	divl   0x8(%esp)
  801155:	89 d1                	mov    %edx,%ecx
  801157:	89 f3                	mov    %esi,%ebx
  801159:	f7 64 24 0c          	mull   0xc(%esp)
  80115d:	89 c6                	mov    %eax,%esi
  80115f:	89 d7                	mov    %edx,%edi
  801161:	39 d1                	cmp    %edx,%ecx
  801163:	72 06                	jb     80116b <__umoddi3+0xfb>
  801165:	75 10                	jne    801177 <__umoddi3+0x107>
  801167:	39 c3                	cmp    %eax,%ebx
  801169:	73 0c                	jae    801177 <__umoddi3+0x107>
  80116b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80116f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801173:	89 d7                	mov    %edx,%edi
  801175:	89 c6                	mov    %eax,%esi
  801177:	89 ca                	mov    %ecx,%edx
  801179:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80117e:	29 f3                	sub    %esi,%ebx
  801180:	19 fa                	sbb    %edi,%edx
  801182:	89 d0                	mov    %edx,%eax
  801184:	d3 e0                	shl    %cl,%eax
  801186:	89 e9                	mov    %ebp,%ecx
  801188:	d3 eb                	shr    %cl,%ebx
  80118a:	d3 ea                	shr    %cl,%edx
  80118c:	09 d8                	or     %ebx,%eax
  80118e:	83 c4 1c             	add    $0x1c,%esp
  801191:	5b                   	pop    %ebx
  801192:	5e                   	pop    %esi
  801193:	5f                   	pop    %edi
  801194:	5d                   	pop    %ebp
  801195:	c3                   	ret    
  801196:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80119d:	8d 76 00             	lea    0x0(%esi),%esi
  8011a0:	89 da                	mov    %ebx,%edx
  8011a2:	29 fe                	sub    %edi,%esi
  8011a4:	19 c2                	sbb    %eax,%edx
  8011a6:	89 f1                	mov    %esi,%ecx
  8011a8:	89 c8                	mov    %ecx,%eax
  8011aa:	e9 4b ff ff ff       	jmp    8010fa <__umoddi3+0x8a>
