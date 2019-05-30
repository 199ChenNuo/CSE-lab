
obj/user/spawnfaultio.debug:     file format elf32-i386


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
  80002c:	e8 4a 00 00 00       	call   80007b <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	int r;
	cprintf("i am parent environment %08x\n", thisenv->env_id);
  800039:	a1 04 40 80 00       	mov    0x804004,%eax
  80003e:	8b 40 48             	mov    0x48(%eax),%eax
  800041:	50                   	push   %eax
  800042:	68 60 24 80 00       	push   $0x802460
  800047:	e8 65 01 00 00       	call   8001b1 <cprintf>
	if ((r = spawnl("faultio", "faultio", 0)) < 0)
  80004c:	83 c4 0c             	add    $0xc,%esp
  80004f:	6a 00                	push   $0x0
  800051:	68 7e 24 80 00       	push   $0x80247e
  800056:	68 7e 24 80 00       	push   $0x80247e
  80005b:	e8 7e 13 00 00       	call   8013de <spawnl>
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	85 c0                	test   %eax,%eax
  800065:	78 02                	js     800069 <umain+0x36>
		panic("spawn(faultio) failed: %e", r);
}
  800067:	c9                   	leave  
  800068:	c3                   	ret    
		panic("spawn(faultio) failed: %e", r);
  800069:	50                   	push   %eax
  80006a:	68 86 24 80 00       	push   $0x802486
  80006f:	6a 09                	push   $0x9
  800071:	68 a0 24 80 00       	push   $0x8024a0
  800076:	e8 5b 00 00 00       	call   8000d6 <_panic>

0080007b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80007b:	55                   	push   %ebp
  80007c:	89 e5                	mov    %esp,%ebp
  80007e:	56                   	push   %esi
  80007f:	53                   	push   %ebx
  800080:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800083:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	// thisenv = 0;
	thisenv = &(envs[ENVX(sys_getenvid())]);
  800086:	e8 00 0c 00 00       	call   800c8b <sys_getenvid>
  80008b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800090:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  800096:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80009b:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a0:	85 db                	test   %ebx,%ebx
  8000a2:	7e 07                	jle    8000ab <libmain+0x30>
		binaryname = argv[0];
  8000a4:	8b 06                	mov    (%esi),%eax
  8000a6:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000ab:	83 ec 08             	sub    $0x8,%esp
  8000ae:	56                   	push   %esi
  8000af:	53                   	push   %ebx
  8000b0:	e8 7e ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000b5:	e8 0a 00 00 00       	call   8000c4 <exit>
}
  8000ba:	83 c4 10             	add    $0x10,%esp
  8000bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000c0:	5b                   	pop    %ebx
  8000c1:	5e                   	pop    %esi
  8000c2:	5d                   	pop    %ebp
  8000c3:	c3                   	ret    

008000c4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000c4:	55                   	push   %ebp
  8000c5:	89 e5                	mov    %esp,%ebp
  8000c7:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8000ca:	6a 00                	push   $0x0
  8000cc:	e8 79 0b 00 00       	call   800c4a <sys_env_destroy>
}
  8000d1:	83 c4 10             	add    $0x10,%esp
  8000d4:	c9                   	leave  
  8000d5:	c3                   	ret    

008000d6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8000d6:	55                   	push   %ebp
  8000d7:	89 e5                	mov    %esp,%ebp
  8000d9:	56                   	push   %esi
  8000da:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8000db:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8000de:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8000e4:	e8 a2 0b 00 00       	call   800c8b <sys_getenvid>
  8000e9:	83 ec 0c             	sub    $0xc,%esp
  8000ec:	ff 75 0c             	pushl  0xc(%ebp)
  8000ef:	ff 75 08             	pushl  0x8(%ebp)
  8000f2:	56                   	push   %esi
  8000f3:	50                   	push   %eax
  8000f4:	68 c0 24 80 00       	push   $0x8024c0
  8000f9:	e8 b3 00 00 00       	call   8001b1 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8000fe:	83 c4 18             	add    $0x18,%esp
  800101:	53                   	push   %ebx
  800102:	ff 75 10             	pushl  0x10(%ebp)
  800105:	e8 56 00 00 00       	call   800160 <vcprintf>
	cprintf("\n");
  80010a:	c7 04 24 20 2a 80 00 	movl   $0x802a20,(%esp)
  800111:	e8 9b 00 00 00       	call   8001b1 <cprintf>
  800116:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800119:	cc                   	int3   
  80011a:	eb fd                	jmp    800119 <_panic+0x43>

0080011c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80011c:	55                   	push   %ebp
  80011d:	89 e5                	mov    %esp,%ebp
  80011f:	53                   	push   %ebx
  800120:	83 ec 04             	sub    $0x4,%esp
  800123:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800126:	8b 13                	mov    (%ebx),%edx
  800128:	8d 42 01             	lea    0x1(%edx),%eax
  80012b:	89 03                	mov    %eax,(%ebx)
  80012d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800130:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800134:	3d ff 00 00 00       	cmp    $0xff,%eax
  800139:	74 09                	je     800144 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80013b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80013f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800142:	c9                   	leave  
  800143:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800144:	83 ec 08             	sub    $0x8,%esp
  800147:	68 ff 00 00 00       	push   $0xff
  80014c:	8d 43 08             	lea    0x8(%ebx),%eax
  80014f:	50                   	push   %eax
  800150:	e8 b8 0a 00 00       	call   800c0d <sys_cputs>
		b->idx = 0;
  800155:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80015b:	83 c4 10             	add    $0x10,%esp
  80015e:	eb db                	jmp    80013b <putch+0x1f>

00800160 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800160:	55                   	push   %ebp
  800161:	89 e5                	mov    %esp,%ebp
  800163:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800169:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800170:	00 00 00 
	b.cnt = 0;
  800173:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80017a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80017d:	ff 75 0c             	pushl  0xc(%ebp)
  800180:	ff 75 08             	pushl  0x8(%ebp)
  800183:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800189:	50                   	push   %eax
  80018a:	68 1c 01 80 00       	push   $0x80011c
  80018f:	e8 4a 01 00 00       	call   8002de <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800194:	83 c4 08             	add    $0x8,%esp
  800197:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80019d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001a3:	50                   	push   %eax
  8001a4:	e8 64 0a 00 00       	call   800c0d <sys_cputs>

	return b.cnt;
}
  8001a9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001af:	c9                   	leave  
  8001b0:	c3                   	ret    

008001b1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001b1:	55                   	push   %ebp
  8001b2:	89 e5                	mov    %esp,%ebp
  8001b4:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001b7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001ba:	50                   	push   %eax
  8001bb:	ff 75 08             	pushl  0x8(%ebp)
  8001be:	e8 9d ff ff ff       	call   800160 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001c3:	c9                   	leave  
  8001c4:	c3                   	ret    

008001c5 <printnum>:


static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001c5:	55                   	push   %ebp
  8001c6:	89 e5                	mov    %esp,%ebp
  8001c8:	57                   	push   %edi
  8001c9:	56                   	push   %esi
  8001ca:	53                   	push   %ebx
  8001cb:	83 ec 1c             	sub    $0x1c,%esp
  8001ce:	89 c6                	mov    %eax,%esi
  8001d0:	89 d7                	mov    %edx,%edi
  8001d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001db:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8001de:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e1:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	// to support '-'
	if(padc == '-'){
  8001e4:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001e8:	74 2c                	je     800216 <printnum+0x51>
		while (--width > 0)
			putch(' ', putdat);
		return;
	}
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001ed:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001f4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001f7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001fa:	39 c2                	cmp    %eax,%edx
  8001fc:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001ff:	73 43                	jae    800244 <printnum+0x7f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800201:	83 eb 01             	sub    $0x1,%ebx
  800204:	85 db                	test   %ebx,%ebx
  800206:	7e 6c                	jle    800274 <printnum+0xaf>
			putch(padc, putdat);
  800208:	83 ec 08             	sub    $0x8,%esp
  80020b:	57                   	push   %edi
  80020c:	ff 75 18             	pushl  0x18(%ebp)
  80020f:	ff d6                	call   *%esi
  800211:	83 c4 10             	add    $0x10,%esp
  800214:	eb eb                	jmp    800201 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800216:	83 ec 0c             	sub    $0xc,%esp
  800219:	6a 20                	push   $0x20
  80021b:	6a 00                	push   $0x0
  80021d:	50                   	push   %eax
  80021e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800221:	ff 75 e0             	pushl  -0x20(%ebp)
  800224:	89 fa                	mov    %edi,%edx
  800226:	89 f0                	mov    %esi,%eax
  800228:	e8 98 ff ff ff       	call   8001c5 <printnum>
		while (--width > 0)
  80022d:	83 c4 20             	add    $0x20,%esp
  800230:	83 eb 01             	sub    $0x1,%ebx
  800233:	85 db                	test   %ebx,%ebx
  800235:	7e 65                	jle    80029c <printnum+0xd7>
			putch(' ', putdat);
  800237:	83 ec 08             	sub    $0x8,%esp
  80023a:	57                   	push   %edi
  80023b:	6a 20                	push   $0x20
  80023d:	ff d6                	call   *%esi
  80023f:	83 c4 10             	add    $0x10,%esp
  800242:	eb ec                	jmp    800230 <printnum+0x6b>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	ff 75 18             	pushl  0x18(%ebp)
  80024a:	83 eb 01             	sub    $0x1,%ebx
  80024d:	53                   	push   %ebx
  80024e:	50                   	push   %eax
  80024f:	83 ec 08             	sub    $0x8,%esp
  800252:	ff 75 dc             	pushl  -0x24(%ebp)
  800255:	ff 75 d8             	pushl  -0x28(%ebp)
  800258:	ff 75 e4             	pushl  -0x1c(%ebp)
  80025b:	ff 75 e0             	pushl  -0x20(%ebp)
  80025e:	e8 ad 1f 00 00       	call   802210 <__udivdi3>
  800263:	83 c4 18             	add    $0x18,%esp
  800266:	52                   	push   %edx
  800267:	50                   	push   %eax
  800268:	89 fa                	mov    %edi,%edx
  80026a:	89 f0                	mov    %esi,%eax
  80026c:	e8 54 ff ff ff       	call   8001c5 <printnum>
  800271:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800274:	83 ec 08             	sub    $0x8,%esp
  800277:	57                   	push   %edi
  800278:	83 ec 04             	sub    $0x4,%esp
  80027b:	ff 75 dc             	pushl  -0x24(%ebp)
  80027e:	ff 75 d8             	pushl  -0x28(%ebp)
  800281:	ff 75 e4             	pushl  -0x1c(%ebp)
  800284:	ff 75 e0             	pushl  -0x20(%ebp)
  800287:	e8 94 20 00 00       	call   802320 <__umoddi3>
  80028c:	83 c4 14             	add    $0x14,%esp
  80028f:	0f be 80 e3 24 80 00 	movsbl 0x8024e3(%eax),%eax
  800296:	50                   	push   %eax
  800297:	ff d6                	call   *%esi
  800299:	83 c4 10             	add    $0x10,%esp
}
  80029c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80029f:	5b                   	pop    %ebx
  8002a0:	5e                   	pop    %esi
  8002a1:	5f                   	pop    %edi
  8002a2:	5d                   	pop    %ebp
  8002a3:	c3                   	ret    

008002a4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002a4:	55                   	push   %ebp
  8002a5:	89 e5                	mov    %esp,%ebp
  8002a7:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002aa:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002ae:	8b 10                	mov    (%eax),%edx
  8002b0:	3b 50 04             	cmp    0x4(%eax),%edx
  8002b3:	73 0a                	jae    8002bf <sprintputch+0x1b>
		*b->buf++ = ch;
  8002b5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002b8:	89 08                	mov    %ecx,(%eax)
  8002ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8002bd:	88 02                	mov    %al,(%edx)
}
  8002bf:	5d                   	pop    %ebp
  8002c0:	c3                   	ret    

008002c1 <printfmt>:
{
  8002c1:	55                   	push   %ebp
  8002c2:	89 e5                	mov    %esp,%ebp
  8002c4:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002c7:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002ca:	50                   	push   %eax
  8002cb:	ff 75 10             	pushl  0x10(%ebp)
  8002ce:	ff 75 0c             	pushl  0xc(%ebp)
  8002d1:	ff 75 08             	pushl  0x8(%ebp)
  8002d4:	e8 05 00 00 00       	call   8002de <vprintfmt>
}
  8002d9:	83 c4 10             	add    $0x10,%esp
  8002dc:	c9                   	leave  
  8002dd:	c3                   	ret    

008002de <vprintfmt>:
{
  8002de:	55                   	push   %ebp
  8002df:	89 e5                	mov    %esp,%ebp
  8002e1:	57                   	push   %edi
  8002e2:	56                   	push   %esi
  8002e3:	53                   	push   %ebx
  8002e4:	83 ec 3c             	sub    $0x3c,%esp
  8002e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8002ea:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002ed:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002f0:	e9 1e 04 00 00       	jmp    800713 <vprintfmt+0x435>
		posflag = 0;
  8002f5:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		padc = ' ';
  8002fc:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800300:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800307:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80030e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800315:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  80031c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800321:	8d 47 01             	lea    0x1(%edi),%eax
  800324:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800327:	0f b6 17             	movzbl (%edi),%edx
  80032a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80032d:	3c 55                	cmp    $0x55,%al
  80032f:	0f 87 d9 04 00 00    	ja     80080e <vprintfmt+0x530>
  800335:	0f b6 c0             	movzbl %al,%eax
  800338:	ff 24 85 c0 26 80 00 	jmp    *0x8026c0(,%eax,4)
  80033f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800342:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800346:	eb d9                	jmp    800321 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800348:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			posflag = 1;
  80034b:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  800352:	eb cd                	jmp    800321 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800354:	0f b6 d2             	movzbl %dl,%edx
  800357:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80035a:	b8 00 00 00 00       	mov    $0x0,%eax
  80035f:	89 75 08             	mov    %esi,0x8(%ebp)
  800362:	eb 0c                	jmp    800370 <vprintfmt+0x92>
		switch (ch = *(unsigned char *) fmt++) {
  800364:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800367:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
			goto reswitch;
  80036b:	eb b4                	jmp    800321 <vprintfmt+0x43>
			for (precision = 0; ; ++fmt) {
  80036d:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800370:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800373:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800377:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80037a:	8d 72 d0             	lea    -0x30(%edx),%esi
  80037d:	83 fe 09             	cmp    $0x9,%esi
  800380:	76 eb                	jbe    80036d <vprintfmt+0x8f>
  800382:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800385:	8b 75 08             	mov    0x8(%ebp),%esi
  800388:	eb 14                	jmp    80039e <vprintfmt+0xc0>
			precision = va_arg(ap, int);
  80038a:	8b 45 14             	mov    0x14(%ebp),%eax
  80038d:	8b 00                	mov    (%eax),%eax
  80038f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800392:	8b 45 14             	mov    0x14(%ebp),%eax
  800395:	8d 40 04             	lea    0x4(%eax),%eax
  800398:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80039b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80039e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003a2:	0f 89 79 ff ff ff    	jns    800321 <vprintfmt+0x43>
				width = precision, precision = -1;
  8003a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003ae:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003b5:	e9 67 ff ff ff       	jmp    800321 <vprintfmt+0x43>
  8003ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003bd:	85 c0                	test   %eax,%eax
  8003bf:	0f 48 c1             	cmovs  %ecx,%eax
  8003c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003c8:	e9 54 ff ff ff       	jmp    800321 <vprintfmt+0x43>
  8003cd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003d0:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003d7:	e9 45 ff ff ff       	jmp    800321 <vprintfmt+0x43>
			lflag++;
  8003dc:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003e3:	e9 39 ff ff ff       	jmp    800321 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8003e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003eb:	8d 78 04             	lea    0x4(%eax),%edi
  8003ee:	83 ec 08             	sub    $0x8,%esp
  8003f1:	53                   	push   %ebx
  8003f2:	ff 30                	pushl  (%eax)
  8003f4:	ff d6                	call   *%esi
			break;
  8003f6:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003f9:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003fc:	e9 0f 03 00 00       	jmp    800710 <vprintfmt+0x432>
			err = va_arg(ap, int);
  800401:	8b 45 14             	mov    0x14(%ebp),%eax
  800404:	8d 78 04             	lea    0x4(%eax),%edi
  800407:	8b 00                	mov    (%eax),%eax
  800409:	99                   	cltd   
  80040a:	31 d0                	xor    %edx,%eax
  80040c:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80040e:	83 f8 0f             	cmp    $0xf,%eax
  800411:	7f 23                	jg     800436 <vprintfmt+0x158>
  800413:	8b 14 85 20 28 80 00 	mov    0x802820(,%eax,4),%edx
  80041a:	85 d2                	test   %edx,%edx
  80041c:	74 18                	je     800436 <vprintfmt+0x158>
				printfmt(putch, putdat, "%s", p);
  80041e:	52                   	push   %edx
  80041f:	68 b7 28 80 00       	push   $0x8028b7
  800424:	53                   	push   %ebx
  800425:	56                   	push   %esi
  800426:	e8 96 fe ff ff       	call   8002c1 <printfmt>
  80042b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80042e:	89 7d 14             	mov    %edi,0x14(%ebp)
  800431:	e9 da 02 00 00       	jmp    800710 <vprintfmt+0x432>
				printfmt(putch, putdat, "error %d", err);
  800436:	50                   	push   %eax
  800437:	68 fb 24 80 00       	push   $0x8024fb
  80043c:	53                   	push   %ebx
  80043d:	56                   	push   %esi
  80043e:	e8 7e fe ff ff       	call   8002c1 <printfmt>
  800443:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800446:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800449:	e9 c2 02 00 00       	jmp    800710 <vprintfmt+0x432>
			if ((p = va_arg(ap, char *)) == NULL)
  80044e:	8b 45 14             	mov    0x14(%ebp),%eax
  800451:	83 c0 04             	add    $0x4,%eax
  800454:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800457:	8b 45 14             	mov    0x14(%ebp),%eax
  80045a:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80045c:	85 c9                	test   %ecx,%ecx
  80045e:	b8 f4 24 80 00       	mov    $0x8024f4,%eax
  800463:	0f 45 c1             	cmovne %ecx,%eax
  800466:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800469:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80046d:	7e 06                	jle    800475 <vprintfmt+0x197>
  80046f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800473:	75 0d                	jne    800482 <vprintfmt+0x1a4>
				for (width -= strnlen(p, precision); width > 0; width--)
  800475:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800478:	89 c7                	mov    %eax,%edi
  80047a:	03 45 e0             	add    -0x20(%ebp),%eax
  80047d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800480:	eb 53                	jmp    8004d5 <vprintfmt+0x1f7>
  800482:	83 ec 08             	sub    $0x8,%esp
  800485:	ff 75 d8             	pushl  -0x28(%ebp)
  800488:	50                   	push   %eax
  800489:	e8 28 04 00 00       	call   8008b6 <strnlen>
  80048e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800491:	29 c1                	sub    %eax,%ecx
  800493:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  800496:	83 c4 10             	add    $0x10,%esp
  800499:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80049b:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80049f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a2:	eb 0f                	jmp    8004b3 <vprintfmt+0x1d5>
					putch(padc, putdat);
  8004a4:	83 ec 08             	sub    $0x8,%esp
  8004a7:	53                   	push   %ebx
  8004a8:	ff 75 e0             	pushl  -0x20(%ebp)
  8004ab:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ad:	83 ef 01             	sub    $0x1,%edi
  8004b0:	83 c4 10             	add    $0x10,%esp
  8004b3:	85 ff                	test   %edi,%edi
  8004b5:	7f ed                	jg     8004a4 <vprintfmt+0x1c6>
  8004b7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  8004ba:	85 c9                	test   %ecx,%ecx
  8004bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c1:	0f 49 c1             	cmovns %ecx,%eax
  8004c4:	29 c1                	sub    %eax,%ecx
  8004c6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004c9:	eb aa                	jmp    800475 <vprintfmt+0x197>
					putch(ch, putdat);
  8004cb:	83 ec 08             	sub    $0x8,%esp
  8004ce:	53                   	push   %ebx
  8004cf:	52                   	push   %edx
  8004d0:	ff d6                	call   *%esi
  8004d2:	83 c4 10             	add    $0x10,%esp
  8004d5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004d8:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004da:	83 c7 01             	add    $0x1,%edi
  8004dd:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004e1:	0f be d0             	movsbl %al,%edx
  8004e4:	85 d2                	test   %edx,%edx
  8004e6:	74 4b                	je     800533 <vprintfmt+0x255>
  8004e8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004ec:	78 06                	js     8004f4 <vprintfmt+0x216>
  8004ee:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004f2:	78 1e                	js     800512 <vprintfmt+0x234>
				if (altflag && (ch < ' ' || ch > '~'))
  8004f4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004f8:	74 d1                	je     8004cb <vprintfmt+0x1ed>
  8004fa:	0f be c0             	movsbl %al,%eax
  8004fd:	83 e8 20             	sub    $0x20,%eax
  800500:	83 f8 5e             	cmp    $0x5e,%eax
  800503:	76 c6                	jbe    8004cb <vprintfmt+0x1ed>
					putch('?', putdat);
  800505:	83 ec 08             	sub    $0x8,%esp
  800508:	53                   	push   %ebx
  800509:	6a 3f                	push   $0x3f
  80050b:	ff d6                	call   *%esi
  80050d:	83 c4 10             	add    $0x10,%esp
  800510:	eb c3                	jmp    8004d5 <vprintfmt+0x1f7>
  800512:	89 cf                	mov    %ecx,%edi
  800514:	eb 0e                	jmp    800524 <vprintfmt+0x246>
				putch(' ', putdat);
  800516:	83 ec 08             	sub    $0x8,%esp
  800519:	53                   	push   %ebx
  80051a:	6a 20                	push   $0x20
  80051c:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80051e:	83 ef 01             	sub    $0x1,%edi
  800521:	83 c4 10             	add    $0x10,%esp
  800524:	85 ff                	test   %edi,%edi
  800526:	7f ee                	jg     800516 <vprintfmt+0x238>
			if ((p = va_arg(ap, char *)) == NULL)
  800528:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80052b:	89 45 14             	mov    %eax,0x14(%ebp)
  80052e:	e9 dd 01 00 00       	jmp    800710 <vprintfmt+0x432>
  800533:	89 cf                	mov    %ecx,%edi
  800535:	eb ed                	jmp    800524 <vprintfmt+0x246>
	if (lflag >= 2)
  800537:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80053b:	7f 21                	jg     80055e <vprintfmt+0x280>
	else if (lflag)
  80053d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800541:	74 6a                	je     8005ad <vprintfmt+0x2cf>
		return va_arg(*ap, long);
  800543:	8b 45 14             	mov    0x14(%ebp),%eax
  800546:	8b 00                	mov    (%eax),%eax
  800548:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80054b:	89 c1                	mov    %eax,%ecx
  80054d:	c1 f9 1f             	sar    $0x1f,%ecx
  800550:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800553:	8b 45 14             	mov    0x14(%ebp),%eax
  800556:	8d 40 04             	lea    0x4(%eax),%eax
  800559:	89 45 14             	mov    %eax,0x14(%ebp)
  80055c:	eb 17                	jmp    800575 <vprintfmt+0x297>
		return va_arg(*ap, long long);
  80055e:	8b 45 14             	mov    0x14(%ebp),%eax
  800561:	8b 50 04             	mov    0x4(%eax),%edx
  800564:	8b 00                	mov    (%eax),%eax
  800566:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800569:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80056c:	8b 45 14             	mov    0x14(%ebp),%eax
  80056f:	8d 40 08             	lea    0x8(%eax),%eax
  800572:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800575:	8b 55 dc             	mov    -0x24(%ebp),%edx
			base = 10;
  800578:	bf 0a 00 00 00       	mov    $0xa,%edi
			if ((long long) num < 0) {
  80057d:	85 d2                	test   %edx,%edx
  80057f:	0f 89 5c 01 00 00    	jns    8006e1 <vprintfmt+0x403>
				putch('-', putdat);
  800585:	83 ec 08             	sub    $0x8,%esp
  800588:	53                   	push   %ebx
  800589:	6a 2d                	push   $0x2d
  80058b:	ff d6                	call   *%esi
				num = -(long long) num;
  80058d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800590:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800593:	f7 d8                	neg    %eax
  800595:	83 d2 00             	adc    $0x0,%edx
  800598:	f7 da                	neg    %edx
  80059a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80059d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005a0:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005a3:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005a8:	e9 45 01 00 00       	jmp    8006f2 <vprintfmt+0x414>
		return va_arg(*ap, int);
  8005ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b0:	8b 00                	mov    (%eax),%eax
  8005b2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b5:	89 c1                	mov    %eax,%ecx
  8005b7:	c1 f9 1f             	sar    $0x1f,%ecx
  8005ba:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c0:	8d 40 04             	lea    0x4(%eax),%eax
  8005c3:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c6:	eb ad                	jmp    800575 <vprintfmt+0x297>
	if (lflag >= 2)
  8005c8:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  8005cc:	7f 29                	jg     8005f7 <vprintfmt+0x319>
	else if (lflag)
  8005ce:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8005d2:	74 44                	je     800618 <vprintfmt+0x33a>
		return va_arg(*ap, unsigned long);
  8005d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d7:	8b 00                	mov    (%eax),%eax
  8005d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005de:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e7:	8d 40 04             	lea    0x4(%eax),%eax
  8005ea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ed:	bf 0a 00 00 00       	mov    $0xa,%edi
  8005f2:	e9 ea 00 00 00       	jmp    8006e1 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  8005f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fa:	8b 50 04             	mov    0x4(%eax),%edx
  8005fd:	8b 00                	mov    (%eax),%eax
  8005ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800602:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800605:	8b 45 14             	mov    0x14(%ebp),%eax
  800608:	8d 40 08             	lea    0x8(%eax),%eax
  80060b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80060e:	bf 0a 00 00 00       	mov    $0xa,%edi
  800613:	e9 c9 00 00 00       	jmp    8006e1 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800618:	8b 45 14             	mov    0x14(%ebp),%eax
  80061b:	8b 00                	mov    (%eax),%eax
  80061d:	ba 00 00 00 00       	mov    $0x0,%edx
  800622:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800625:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800628:	8b 45 14             	mov    0x14(%ebp),%eax
  80062b:	8d 40 04             	lea    0x4(%eax),%eax
  80062e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800631:	bf 0a 00 00 00       	mov    $0xa,%edi
  800636:	e9 a6 00 00 00       	jmp    8006e1 <vprintfmt+0x403>
			putch('0', putdat);
  80063b:	83 ec 08             	sub    $0x8,%esp
  80063e:	53                   	push   %ebx
  80063f:	6a 30                	push   $0x30
  800641:	ff d6                	call   *%esi
	if (lflag >= 2)
  800643:	83 c4 10             	add    $0x10,%esp
  800646:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80064a:	7f 26                	jg     800672 <vprintfmt+0x394>
	else if (lflag)
  80064c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800650:	74 3e                	je     800690 <vprintfmt+0x3b2>
		return va_arg(*ap, unsigned long);
  800652:	8b 45 14             	mov    0x14(%ebp),%eax
  800655:	8b 00                	mov    (%eax),%eax
  800657:	ba 00 00 00 00       	mov    $0x0,%edx
  80065c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800662:	8b 45 14             	mov    0x14(%ebp),%eax
  800665:	8d 40 04             	lea    0x4(%eax),%eax
  800668:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80066b:	bf 08 00 00 00       	mov    $0x8,%edi
  800670:	eb 6f                	jmp    8006e1 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800672:	8b 45 14             	mov    0x14(%ebp),%eax
  800675:	8b 50 04             	mov    0x4(%eax),%edx
  800678:	8b 00                	mov    (%eax),%eax
  80067a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800680:	8b 45 14             	mov    0x14(%ebp),%eax
  800683:	8d 40 08             	lea    0x8(%eax),%eax
  800686:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800689:	bf 08 00 00 00       	mov    $0x8,%edi
  80068e:	eb 51                	jmp    8006e1 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800690:	8b 45 14             	mov    0x14(%ebp),%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	ba 00 00 00 00       	mov    $0x0,%edx
  80069a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a3:	8d 40 04             	lea    0x4(%eax),%eax
  8006a6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006a9:	bf 08 00 00 00       	mov    $0x8,%edi
  8006ae:	eb 31                	jmp    8006e1 <vprintfmt+0x403>
			putch('0', putdat);
  8006b0:	83 ec 08             	sub    $0x8,%esp
  8006b3:	53                   	push   %ebx
  8006b4:	6a 30                	push   $0x30
  8006b6:	ff d6                	call   *%esi
			putch('x', putdat);
  8006b8:	83 c4 08             	add    $0x8,%esp
  8006bb:	53                   	push   %ebx
  8006bc:	6a 78                	push   $0x78
  8006be:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006cd:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006d0:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d6:	8d 40 04             	lea    0x4(%eax),%eax
  8006d9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006dc:	bf 10 00 00 00       	mov    $0x10,%edi
			if(posflag)
  8006e1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006e5:	74 0b                	je     8006f2 <vprintfmt+0x414>
				putch('+', putdat);
  8006e7:	83 ec 08             	sub    $0x8,%esp
  8006ea:	53                   	push   %ebx
  8006eb:	6a 2b                	push   $0x2b
  8006ed:	ff d6                	call   *%esi
  8006ef:	83 c4 10             	add    $0x10,%esp
			printnum(putch, putdat, num, base, width, padc);
  8006f2:	83 ec 0c             	sub    $0xc,%esp
  8006f5:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006f9:	50                   	push   %eax
  8006fa:	ff 75 e0             	pushl  -0x20(%ebp)
  8006fd:	57                   	push   %edi
  8006fe:	ff 75 dc             	pushl  -0x24(%ebp)
  800701:	ff 75 d8             	pushl  -0x28(%ebp)
  800704:	89 da                	mov    %ebx,%edx
  800706:	89 f0                	mov    %esi,%eax
  800708:	e8 b8 fa ff ff       	call   8001c5 <printnum>
			break;
  80070d:	83 c4 20             	add    $0x20,%esp
			char* cp = va_arg(ap, char *);
  800710:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800713:	83 c7 01             	add    $0x1,%edi
  800716:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80071a:	83 f8 25             	cmp    $0x25,%eax
  80071d:	0f 84 d2 fb ff ff    	je     8002f5 <vprintfmt+0x17>
			if (ch == '\0')
  800723:	85 c0                	test   %eax,%eax
  800725:	0f 84 03 01 00 00    	je     80082e <vprintfmt+0x550>
			putch(ch, putdat);
  80072b:	83 ec 08             	sub    $0x8,%esp
  80072e:	53                   	push   %ebx
  80072f:	50                   	push   %eax
  800730:	ff d6                	call   *%esi
  800732:	83 c4 10             	add    $0x10,%esp
  800735:	eb dc                	jmp    800713 <vprintfmt+0x435>
	if (lflag >= 2)
  800737:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
  80073b:	7f 29                	jg     800766 <vprintfmt+0x488>
	else if (lflag)
  80073d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800741:	74 44                	je     800787 <vprintfmt+0x4a9>
		return va_arg(*ap, unsigned long);
  800743:	8b 45 14             	mov    0x14(%ebp),%eax
  800746:	8b 00                	mov    (%eax),%eax
  800748:	ba 00 00 00 00       	mov    $0x0,%edx
  80074d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800750:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800753:	8b 45 14             	mov    0x14(%ebp),%eax
  800756:	8d 40 04             	lea    0x4(%eax),%eax
  800759:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80075c:	bf 10 00 00 00       	mov    $0x10,%edi
  800761:	e9 7b ff ff ff       	jmp    8006e1 <vprintfmt+0x403>
		return va_arg(*ap, unsigned long long);
  800766:	8b 45 14             	mov    0x14(%ebp),%eax
  800769:	8b 50 04             	mov    0x4(%eax),%edx
  80076c:	8b 00                	mov    (%eax),%eax
  80076e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800771:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800774:	8b 45 14             	mov    0x14(%ebp),%eax
  800777:	8d 40 08             	lea    0x8(%eax),%eax
  80077a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80077d:	bf 10 00 00 00       	mov    $0x10,%edi
  800782:	e9 5a ff ff ff       	jmp    8006e1 <vprintfmt+0x403>
		return va_arg(*ap, unsigned int);
  800787:	8b 45 14             	mov    0x14(%ebp),%eax
  80078a:	8b 00                	mov    (%eax),%eax
  80078c:	ba 00 00 00 00       	mov    $0x0,%edx
  800791:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800794:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800797:	8b 45 14             	mov    0x14(%ebp),%eax
  80079a:	8d 40 04             	lea    0x4(%eax),%eax
  80079d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007a0:	bf 10 00 00 00       	mov    $0x10,%edi
  8007a5:	e9 37 ff ff ff       	jmp    8006e1 <vprintfmt+0x403>
			char* cp = va_arg(ap, char *);
  8007aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ad:	8d 78 04             	lea    0x4(%eax),%edi
  8007b0:	8b 00                	mov    (%eax),%eax
    			if (cp == NULL) {
  8007b2:	85 c0                	test   %eax,%eax
  8007b4:	74 2c                	je     8007e2 <vprintfmt+0x504>
    			*cp = *(int *)putdat;
  8007b6:	8b 13                	mov    (%ebx),%edx
  8007b8:	88 10                	mov    %dl,(%eax)
			char* cp = va_arg(ap, char *);
  8007ba:	89 7d 14             	mov    %edi,0x14(%ebp)
    			if ((*(int *) putdat) > 127)
  8007bd:	83 3b 7f             	cmpl   $0x7f,(%ebx)
  8007c0:	0f 8e 4a ff ff ff    	jle    800710 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", overflow_error);
  8007c6:	68 50 26 80 00       	push   $0x802650
  8007cb:	68 b7 28 80 00       	push   $0x8028b7
  8007d0:	53                   	push   %ebx
  8007d1:	56                   	push   %esi
  8007d2:	e8 ea fa ff ff       	call   8002c1 <printfmt>
  8007d7:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  8007da:	89 7d 14             	mov    %edi,0x14(%ebp)
  8007dd:	e9 2e ff ff ff       	jmp    800710 <vprintfmt+0x432>
        			printfmt(putch, putdat, "%s", null_error);
  8007e2:	68 18 26 80 00       	push   $0x802618
  8007e7:	68 b7 28 80 00       	push   $0x8028b7
  8007ec:	53                   	push   %ebx
  8007ed:	56                   	push   %esi
  8007ee:	e8 ce fa ff ff       	call   8002c1 <printfmt>
        		break;
  8007f3:	83 c4 10             	add    $0x10,%esp
			char* cp = va_arg(ap, char *);
  8007f6:	89 7d 14             	mov    %edi,0x14(%ebp)
        		break;
  8007f9:	e9 12 ff ff ff       	jmp    800710 <vprintfmt+0x432>
			putch(ch, putdat);
  8007fe:	83 ec 08             	sub    $0x8,%esp
  800801:	53                   	push   %ebx
  800802:	6a 25                	push   $0x25
  800804:	ff d6                	call   *%esi
			break;
  800806:	83 c4 10             	add    $0x10,%esp
  800809:	e9 02 ff ff ff       	jmp    800710 <vprintfmt+0x432>
			putch('%', putdat);
  80080e:	83 ec 08             	sub    $0x8,%esp
  800811:	53                   	push   %ebx
  800812:	6a 25                	push   $0x25
  800814:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800816:	83 c4 10             	add    $0x10,%esp
  800819:	89 f8                	mov    %edi,%eax
  80081b:	eb 03                	jmp    800820 <vprintfmt+0x542>
  80081d:	83 e8 01             	sub    $0x1,%eax
  800820:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800824:	75 f7                	jne    80081d <vprintfmt+0x53f>
  800826:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800829:	e9 e2 fe ff ff       	jmp    800710 <vprintfmt+0x432>
}
  80082e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800831:	5b                   	pop    %ebx
  800832:	5e                   	pop    %esi
  800833:	5f                   	pop    %edi
  800834:	5d                   	pop    %ebp
  800835:	c3                   	ret    

00800836 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800836:	55                   	push   %ebp
  800837:	89 e5                	mov    %esp,%ebp
  800839:	83 ec 18             	sub    $0x18,%esp
  80083c:	8b 45 08             	mov    0x8(%ebp),%eax
  80083f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800842:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800845:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800849:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80084c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800853:	85 c0                	test   %eax,%eax
  800855:	74 26                	je     80087d <vsnprintf+0x47>
  800857:	85 d2                	test   %edx,%edx
  800859:	7e 22                	jle    80087d <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80085b:	ff 75 14             	pushl  0x14(%ebp)
  80085e:	ff 75 10             	pushl  0x10(%ebp)
  800861:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800864:	50                   	push   %eax
  800865:	68 a4 02 80 00       	push   $0x8002a4
  80086a:	e8 6f fa ff ff       	call   8002de <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80086f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800872:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800878:	83 c4 10             	add    $0x10,%esp
}
  80087b:	c9                   	leave  
  80087c:	c3                   	ret    
		return -E_INVAL;
  80087d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800882:	eb f7                	jmp    80087b <vsnprintf+0x45>

00800884 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800884:	55                   	push   %ebp
  800885:	89 e5                	mov    %esp,%ebp
  800887:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80088a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80088d:	50                   	push   %eax
  80088e:	ff 75 10             	pushl  0x10(%ebp)
  800891:	ff 75 0c             	pushl  0xc(%ebp)
  800894:	ff 75 08             	pushl  0x8(%ebp)
  800897:	e8 9a ff ff ff       	call   800836 <vsnprintf>
	va_end(ap);

	return rc;
}
  80089c:	c9                   	leave  
  80089d:	c3                   	ret    

0080089e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80089e:	55                   	push   %ebp
  80089f:	89 e5                	mov    %esp,%ebp
  8008a1:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a9:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008ad:	74 05                	je     8008b4 <strlen+0x16>
		n++;
  8008af:	83 c0 01             	add    $0x1,%eax
  8008b2:	eb f5                	jmp    8008a9 <strlen+0xb>
	return n;
}
  8008b4:	5d                   	pop    %ebp
  8008b5:	c3                   	ret    

008008b6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008b6:	55                   	push   %ebp
  8008b7:	89 e5                	mov    %esp,%ebp
  8008b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008bc:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c4:	39 c2                	cmp    %eax,%edx
  8008c6:	74 0d                	je     8008d5 <strnlen+0x1f>
  8008c8:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008cc:	74 05                	je     8008d3 <strnlen+0x1d>
		n++;
  8008ce:	83 c2 01             	add    $0x1,%edx
  8008d1:	eb f1                	jmp    8008c4 <strnlen+0xe>
  8008d3:	89 d0                	mov    %edx,%eax
	return n;
}
  8008d5:	5d                   	pop    %ebp
  8008d6:	c3                   	ret    

008008d7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008d7:	55                   	push   %ebp
  8008d8:	89 e5                	mov    %esp,%ebp
  8008da:	53                   	push   %ebx
  8008db:	8b 45 08             	mov    0x8(%ebp),%eax
  8008de:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e6:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008ea:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008ed:	83 c2 01             	add    $0x1,%edx
  8008f0:	84 c9                	test   %cl,%cl
  8008f2:	75 f2                	jne    8008e6 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008f4:	5b                   	pop    %ebx
  8008f5:	5d                   	pop    %ebp
  8008f6:	c3                   	ret    

008008f7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008f7:	55                   	push   %ebp
  8008f8:	89 e5                	mov    %esp,%ebp
  8008fa:	53                   	push   %ebx
  8008fb:	83 ec 10             	sub    $0x10,%esp
  8008fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800901:	53                   	push   %ebx
  800902:	e8 97 ff ff ff       	call   80089e <strlen>
  800907:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80090a:	ff 75 0c             	pushl  0xc(%ebp)
  80090d:	01 d8                	add    %ebx,%eax
  80090f:	50                   	push   %eax
  800910:	e8 c2 ff ff ff       	call   8008d7 <strcpy>
	return dst;
}
  800915:	89 d8                	mov    %ebx,%eax
  800917:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80091a:	c9                   	leave  
  80091b:	c3                   	ret    

0080091c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80091c:	55                   	push   %ebp
  80091d:	89 e5                	mov    %esp,%ebp
  80091f:	56                   	push   %esi
  800920:	53                   	push   %ebx
  800921:	8b 45 08             	mov    0x8(%ebp),%eax
  800924:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800927:	89 c6                	mov    %eax,%esi
  800929:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80092c:	89 c2                	mov    %eax,%edx
  80092e:	39 f2                	cmp    %esi,%edx
  800930:	74 11                	je     800943 <strncpy+0x27>
		*dst++ = *src;
  800932:	83 c2 01             	add    $0x1,%edx
  800935:	0f b6 19             	movzbl (%ecx),%ebx
  800938:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80093b:	80 fb 01             	cmp    $0x1,%bl
  80093e:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800941:	eb eb                	jmp    80092e <strncpy+0x12>
	}
	return ret;
}
  800943:	5b                   	pop    %ebx
  800944:	5e                   	pop    %esi
  800945:	5d                   	pop    %ebp
  800946:	c3                   	ret    

00800947 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800947:	55                   	push   %ebp
  800948:	89 e5                	mov    %esp,%ebp
  80094a:	56                   	push   %esi
  80094b:	53                   	push   %ebx
  80094c:	8b 75 08             	mov    0x8(%ebp),%esi
  80094f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800952:	8b 55 10             	mov    0x10(%ebp),%edx
  800955:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800957:	85 d2                	test   %edx,%edx
  800959:	74 21                	je     80097c <strlcpy+0x35>
  80095b:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80095f:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800961:	39 c2                	cmp    %eax,%edx
  800963:	74 14                	je     800979 <strlcpy+0x32>
  800965:	0f b6 19             	movzbl (%ecx),%ebx
  800968:	84 db                	test   %bl,%bl
  80096a:	74 0b                	je     800977 <strlcpy+0x30>
			*dst++ = *src++;
  80096c:	83 c1 01             	add    $0x1,%ecx
  80096f:	83 c2 01             	add    $0x1,%edx
  800972:	88 5a ff             	mov    %bl,-0x1(%edx)
  800975:	eb ea                	jmp    800961 <strlcpy+0x1a>
  800977:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800979:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80097c:	29 f0                	sub    %esi,%eax
}
  80097e:	5b                   	pop    %ebx
  80097f:	5e                   	pop    %esi
  800980:	5d                   	pop    %ebp
  800981:	c3                   	ret    

00800982 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800982:	55                   	push   %ebp
  800983:	89 e5                	mov    %esp,%ebp
  800985:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800988:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80098b:	0f b6 01             	movzbl (%ecx),%eax
  80098e:	84 c0                	test   %al,%al
  800990:	74 0c                	je     80099e <strcmp+0x1c>
  800992:	3a 02                	cmp    (%edx),%al
  800994:	75 08                	jne    80099e <strcmp+0x1c>
		p++, q++;
  800996:	83 c1 01             	add    $0x1,%ecx
  800999:	83 c2 01             	add    $0x1,%edx
  80099c:	eb ed                	jmp    80098b <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80099e:	0f b6 c0             	movzbl %al,%eax
  8009a1:	0f b6 12             	movzbl (%edx),%edx
  8009a4:	29 d0                	sub    %edx,%eax
}
  8009a6:	5d                   	pop    %ebp
  8009a7:	c3                   	ret    

008009a8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009a8:	55                   	push   %ebp
  8009a9:	89 e5                	mov    %esp,%ebp
  8009ab:	53                   	push   %ebx
  8009ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8009af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b2:	89 c3                	mov    %eax,%ebx
  8009b4:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009b7:	eb 06                	jmp    8009bf <strncmp+0x17>
		n--, p++, q++;
  8009b9:	83 c0 01             	add    $0x1,%eax
  8009bc:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009bf:	39 d8                	cmp    %ebx,%eax
  8009c1:	74 16                	je     8009d9 <strncmp+0x31>
  8009c3:	0f b6 08             	movzbl (%eax),%ecx
  8009c6:	84 c9                	test   %cl,%cl
  8009c8:	74 04                	je     8009ce <strncmp+0x26>
  8009ca:	3a 0a                	cmp    (%edx),%cl
  8009cc:	74 eb                	je     8009b9 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009ce:	0f b6 00             	movzbl (%eax),%eax
  8009d1:	0f b6 12             	movzbl (%edx),%edx
  8009d4:	29 d0                	sub    %edx,%eax
}
  8009d6:	5b                   	pop    %ebx
  8009d7:	5d                   	pop    %ebp
  8009d8:	c3                   	ret    
		return 0;
  8009d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8009de:	eb f6                	jmp    8009d6 <strncmp+0x2e>

008009e0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009e0:	55                   	push   %ebp
  8009e1:	89 e5                	mov    %esp,%ebp
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009ea:	0f b6 10             	movzbl (%eax),%edx
  8009ed:	84 d2                	test   %dl,%dl
  8009ef:	74 09                	je     8009fa <strchr+0x1a>
		if (*s == c)
  8009f1:	38 ca                	cmp    %cl,%dl
  8009f3:	74 0a                	je     8009ff <strchr+0x1f>
	for (; *s; s++)
  8009f5:	83 c0 01             	add    $0x1,%eax
  8009f8:	eb f0                	jmp    8009ea <strchr+0xa>
			return (char *) s;
	return 0;
  8009fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009ff:	5d                   	pop    %ebp
  800a00:	c3                   	ret    

00800a01 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a01:	55                   	push   %ebp
  800a02:	89 e5                	mov    %esp,%ebp
  800a04:	8b 45 08             	mov    0x8(%ebp),%eax
  800a07:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a0b:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a0e:	38 ca                	cmp    %cl,%dl
  800a10:	74 09                	je     800a1b <strfind+0x1a>
  800a12:	84 d2                	test   %dl,%dl
  800a14:	74 05                	je     800a1b <strfind+0x1a>
	for (; *s; s++)
  800a16:	83 c0 01             	add    $0x1,%eax
  800a19:	eb f0                	jmp    800a0b <strfind+0xa>
			break;
	return (char *) s;
}
  800a1b:	5d                   	pop    %ebp
  800a1c:	c3                   	ret    

00800a1d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a1d:	55                   	push   %ebp
  800a1e:	89 e5                	mov    %esp,%ebp
  800a20:	57                   	push   %edi
  800a21:	56                   	push   %esi
  800a22:	53                   	push   %ebx
  800a23:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a26:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a29:	85 c9                	test   %ecx,%ecx
  800a2b:	74 31                	je     800a5e <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a2d:	89 f8                	mov    %edi,%eax
  800a2f:	09 c8                	or     %ecx,%eax
  800a31:	a8 03                	test   $0x3,%al
  800a33:	75 23                	jne    800a58 <memset+0x3b>
		c &= 0xFF;
  800a35:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a39:	89 d3                	mov    %edx,%ebx
  800a3b:	c1 e3 08             	shl    $0x8,%ebx
  800a3e:	89 d0                	mov    %edx,%eax
  800a40:	c1 e0 18             	shl    $0x18,%eax
  800a43:	89 d6                	mov    %edx,%esi
  800a45:	c1 e6 10             	shl    $0x10,%esi
  800a48:	09 f0                	or     %esi,%eax
  800a4a:	09 c2                	or     %eax,%edx
  800a4c:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a4e:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a51:	89 d0                	mov    %edx,%eax
  800a53:	fc                   	cld    
  800a54:	f3 ab                	rep stos %eax,%es:(%edi)
  800a56:	eb 06                	jmp    800a5e <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5b:	fc                   	cld    
  800a5c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a5e:	89 f8                	mov    %edi,%eax
  800a60:	5b                   	pop    %ebx
  800a61:	5e                   	pop    %esi
  800a62:	5f                   	pop    %edi
  800a63:	5d                   	pop    %ebp
  800a64:	c3                   	ret    

00800a65 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a65:	55                   	push   %ebp
  800a66:	89 e5                	mov    %esp,%ebp
  800a68:	57                   	push   %edi
  800a69:	56                   	push   %esi
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a70:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a73:	39 c6                	cmp    %eax,%esi
  800a75:	73 32                	jae    800aa9 <memmove+0x44>
  800a77:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a7a:	39 c2                	cmp    %eax,%edx
  800a7c:	76 2b                	jbe    800aa9 <memmove+0x44>
		s += n;
		d += n;
  800a7e:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a81:	89 fe                	mov    %edi,%esi
  800a83:	09 ce                	or     %ecx,%esi
  800a85:	09 d6                	or     %edx,%esi
  800a87:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a8d:	75 0e                	jne    800a9d <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a8f:	83 ef 04             	sub    $0x4,%edi
  800a92:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a95:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a98:	fd                   	std    
  800a99:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a9b:	eb 09                	jmp    800aa6 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a9d:	83 ef 01             	sub    $0x1,%edi
  800aa0:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800aa3:	fd                   	std    
  800aa4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800aa6:	fc                   	cld    
  800aa7:	eb 1a                	jmp    800ac3 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aa9:	89 c2                	mov    %eax,%edx
  800aab:	09 ca                	or     %ecx,%edx
  800aad:	09 f2                	or     %esi,%edx
  800aaf:	f6 c2 03             	test   $0x3,%dl
  800ab2:	75 0a                	jne    800abe <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ab4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ab7:	89 c7                	mov    %eax,%edi
  800ab9:	fc                   	cld    
  800aba:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800abc:	eb 05                	jmp    800ac3 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800abe:	89 c7                	mov    %eax,%edi
  800ac0:	fc                   	cld    
  800ac1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ac3:	5e                   	pop    %esi
  800ac4:	5f                   	pop    %edi
  800ac5:	5d                   	pop    %ebp
  800ac6:	c3                   	ret    

00800ac7 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ac7:	55                   	push   %ebp
  800ac8:	89 e5                	mov    %esp,%ebp
  800aca:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800acd:	ff 75 10             	pushl  0x10(%ebp)
  800ad0:	ff 75 0c             	pushl  0xc(%ebp)
  800ad3:	ff 75 08             	pushl  0x8(%ebp)
  800ad6:	e8 8a ff ff ff       	call   800a65 <memmove>
}
  800adb:	c9                   	leave  
  800adc:	c3                   	ret    

00800add <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800add:	55                   	push   %ebp
  800ade:	89 e5                	mov    %esp,%ebp
  800ae0:	56                   	push   %esi
  800ae1:	53                   	push   %ebx
  800ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae8:	89 c6                	mov    %eax,%esi
  800aea:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800aed:	39 f0                	cmp    %esi,%eax
  800aef:	74 1c                	je     800b0d <memcmp+0x30>
		if (*s1 != *s2)
  800af1:	0f b6 08             	movzbl (%eax),%ecx
  800af4:	0f b6 1a             	movzbl (%edx),%ebx
  800af7:	38 d9                	cmp    %bl,%cl
  800af9:	75 08                	jne    800b03 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800afb:	83 c0 01             	add    $0x1,%eax
  800afe:	83 c2 01             	add    $0x1,%edx
  800b01:	eb ea                	jmp    800aed <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b03:	0f b6 c1             	movzbl %cl,%eax
  800b06:	0f b6 db             	movzbl %bl,%ebx
  800b09:	29 d8                	sub    %ebx,%eax
  800b0b:	eb 05                	jmp    800b12 <memcmp+0x35>
	}

	return 0;
  800b0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b12:	5b                   	pop    %ebx
  800b13:	5e                   	pop    %esi
  800b14:	5d                   	pop    %ebp
  800b15:	c3                   	ret    

00800b16 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b16:	55                   	push   %ebp
  800b17:	89 e5                	mov    %esp,%ebp
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b1f:	89 c2                	mov    %eax,%edx
  800b21:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b24:	39 d0                	cmp    %edx,%eax
  800b26:	73 09                	jae    800b31 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b28:	38 08                	cmp    %cl,(%eax)
  800b2a:	74 05                	je     800b31 <memfind+0x1b>
	for (; s < ends; s++)
  800b2c:	83 c0 01             	add    $0x1,%eax
  800b2f:	eb f3                	jmp    800b24 <memfind+0xe>
			break;
	return (void *) s;
}
  800b31:	5d                   	pop    %ebp
  800b32:	c3                   	ret    

00800b33 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b33:	55                   	push   %ebp
  800b34:	89 e5                	mov    %esp,%ebp
  800b36:	57                   	push   %edi
  800b37:	56                   	push   %esi
  800b38:	53                   	push   %ebx
  800b39:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b3c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b3f:	eb 03                	jmp    800b44 <strtol+0x11>
		s++;
  800b41:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b44:	0f b6 01             	movzbl (%ecx),%eax
  800b47:	3c 20                	cmp    $0x20,%al
  800b49:	74 f6                	je     800b41 <strtol+0xe>
  800b4b:	3c 09                	cmp    $0x9,%al
  800b4d:	74 f2                	je     800b41 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b4f:	3c 2b                	cmp    $0x2b,%al
  800b51:	74 2a                	je     800b7d <strtol+0x4a>
	int neg = 0;
  800b53:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b58:	3c 2d                	cmp    $0x2d,%al
  800b5a:	74 2b                	je     800b87 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b5c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b62:	75 0f                	jne    800b73 <strtol+0x40>
  800b64:	80 39 30             	cmpb   $0x30,(%ecx)
  800b67:	74 28                	je     800b91 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b69:	85 db                	test   %ebx,%ebx
  800b6b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b70:	0f 44 d8             	cmove  %eax,%ebx
  800b73:	b8 00 00 00 00       	mov    $0x0,%eax
  800b78:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b7b:	eb 50                	jmp    800bcd <strtol+0x9a>
		s++;
  800b7d:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b80:	bf 00 00 00 00       	mov    $0x0,%edi
  800b85:	eb d5                	jmp    800b5c <strtol+0x29>
		s++, neg = 1;
  800b87:	83 c1 01             	add    $0x1,%ecx
  800b8a:	bf 01 00 00 00       	mov    $0x1,%edi
  800b8f:	eb cb                	jmp    800b5c <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b91:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b95:	74 0e                	je     800ba5 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b97:	85 db                	test   %ebx,%ebx
  800b99:	75 d8                	jne    800b73 <strtol+0x40>
		s++, base = 8;
  800b9b:	83 c1 01             	add    $0x1,%ecx
  800b9e:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ba3:	eb ce                	jmp    800b73 <strtol+0x40>
		s += 2, base = 16;
  800ba5:	83 c1 02             	add    $0x2,%ecx
  800ba8:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bad:	eb c4                	jmp    800b73 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800baf:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bb2:	89 f3                	mov    %esi,%ebx
  800bb4:	80 fb 19             	cmp    $0x19,%bl
  800bb7:	77 29                	ja     800be2 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bb9:	0f be d2             	movsbl %dl,%edx
  800bbc:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bbf:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bc2:	7d 30                	jge    800bf4 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bc4:	83 c1 01             	add    $0x1,%ecx
  800bc7:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bcb:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bcd:	0f b6 11             	movzbl (%ecx),%edx
  800bd0:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bd3:	89 f3                	mov    %esi,%ebx
  800bd5:	80 fb 09             	cmp    $0x9,%bl
  800bd8:	77 d5                	ja     800baf <strtol+0x7c>
			dig = *s - '0';
  800bda:	0f be d2             	movsbl %dl,%edx
  800bdd:	83 ea 30             	sub    $0x30,%edx
  800be0:	eb dd                	jmp    800bbf <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800be2:	8d 72 bf             	lea    -0x41(%edx),%esi
  800be5:	89 f3                	mov    %esi,%ebx
  800be7:	80 fb 19             	cmp    $0x19,%bl
  800bea:	77 08                	ja     800bf4 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bec:	0f be d2             	movsbl %dl,%edx
  800bef:	83 ea 37             	sub    $0x37,%edx
  800bf2:	eb cb                	jmp    800bbf <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bf4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf8:	74 05                	je     800bff <strtol+0xcc>
		*endptr = (char *) s;
  800bfa:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bfd:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bff:	89 c2                	mov    %eax,%edx
  800c01:	f7 da                	neg    %edx
  800c03:	85 ff                	test   %edi,%edi
  800c05:	0f 45 c2             	cmovne %edx,%eax
}
  800c08:	5b                   	pop    %ebx
  800c09:	5e                   	pop    %esi
  800c0a:	5f                   	pop    %edi
  800c0b:	5d                   	pop    %ebp
  800c0c:	c3                   	ret    

00800c0d <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c0d:	55                   	push   %ebp
  800c0e:	89 e5                	mov    %esp,%ebp
  800c10:	57                   	push   %edi
  800c11:	56                   	push   %esi
  800c12:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c13:	b8 00 00 00 00       	mov    $0x0,%eax
  800c18:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c1e:	89 c3                	mov    %eax,%ebx
  800c20:	89 c7                	mov    %eax,%edi
  800c22:	89 c6                	mov    %eax,%esi
  800c24:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c26:	5b                   	pop    %ebx
  800c27:	5e                   	pop    %esi
  800c28:	5f                   	pop    %edi
  800c29:	5d                   	pop    %ebp
  800c2a:	c3                   	ret    

00800c2b <sys_cgetc>:

int
sys_cgetc(void)
{
  800c2b:	55                   	push   %ebp
  800c2c:	89 e5                	mov    %esp,%ebp
  800c2e:	57                   	push   %edi
  800c2f:	56                   	push   %esi
  800c30:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c31:	ba 00 00 00 00       	mov    $0x0,%edx
  800c36:	b8 01 00 00 00       	mov    $0x1,%eax
  800c3b:	89 d1                	mov    %edx,%ecx
  800c3d:	89 d3                	mov    %edx,%ebx
  800c3f:	89 d7                	mov    %edx,%edi
  800c41:	89 d6                	mov    %edx,%esi
  800c43:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c45:	5b                   	pop    %ebx
  800c46:	5e                   	pop    %esi
  800c47:	5f                   	pop    %edi
  800c48:	5d                   	pop    %ebp
  800c49:	c3                   	ret    

00800c4a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c4a:	55                   	push   %ebp
  800c4b:	89 e5                	mov    %esp,%ebp
  800c4d:	57                   	push   %edi
  800c4e:	56                   	push   %esi
  800c4f:	53                   	push   %ebx
  800c50:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c53:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c58:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5b:	b8 03 00 00 00       	mov    $0x3,%eax
  800c60:	89 cb                	mov    %ecx,%ebx
  800c62:	89 cf                	mov    %ecx,%edi
  800c64:	89 ce                	mov    %ecx,%esi
  800c66:	cd 30                	int    $0x30
	if (check && ret > 0)
  800c68:	85 c0                	test   %eax,%eax
  800c6a:	7f 08                	jg     800c74 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c6f:	5b                   	pop    %ebx
  800c70:	5e                   	pop    %esi
  800c71:	5f                   	pop    %edi
  800c72:	5d                   	pop    %ebp
  800c73:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c74:	83 ec 0c             	sub    $0xc,%esp
  800c77:	50                   	push   %eax
  800c78:	6a 03                	push   $0x3
  800c7a:	68 60 28 80 00       	push   $0x802860
  800c7f:	6a 4c                	push   $0x4c
  800c81:	68 7d 28 80 00       	push   $0x80287d
  800c86:	e8 4b f4 ff ff       	call   8000d6 <_panic>

00800c8b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c8b:	55                   	push   %ebp
  800c8c:	89 e5                	mov    %esp,%ebp
  800c8e:	57                   	push   %edi
  800c8f:	56                   	push   %esi
  800c90:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c91:	ba 00 00 00 00       	mov    $0x0,%edx
  800c96:	b8 02 00 00 00       	mov    $0x2,%eax
  800c9b:	89 d1                	mov    %edx,%ecx
  800c9d:	89 d3                	mov    %edx,%ebx
  800c9f:	89 d7                	mov    %edx,%edi
  800ca1:	89 d6                	mov    %edx,%esi
  800ca3:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ca5:	5b                   	pop    %ebx
  800ca6:	5e                   	pop    %esi
  800ca7:	5f                   	pop    %edi
  800ca8:	5d                   	pop    %ebp
  800ca9:	c3                   	ret    

00800caa <sys_yield>:

void
sys_yield(void)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	57                   	push   %edi
  800cae:	56                   	push   %esi
  800caf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cb0:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb5:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cba:	89 d1                	mov    %edx,%ecx
  800cbc:	89 d3                	mov    %edx,%ebx
  800cbe:	89 d7                	mov    %edx,%edi
  800cc0:	89 d6                	mov    %edx,%esi
  800cc2:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cc4:	5b                   	pop    %ebx
  800cc5:	5e                   	pop    %esi
  800cc6:	5f                   	pop    %edi
  800cc7:	5d                   	pop    %ebp
  800cc8:	c3                   	ret    

00800cc9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
  800ccc:	57                   	push   %edi
  800ccd:	56                   	push   %esi
  800cce:	53                   	push   %ebx
  800ccf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cd2:	be 00 00 00 00       	mov    $0x0,%esi
  800cd7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cdd:	b8 04 00 00 00       	mov    $0x4,%eax
  800ce2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ce5:	89 f7                	mov    %esi,%edi
  800ce7:	cd 30                	int    $0x30
	if (check && ret > 0)
  800ce9:	85 c0                	test   %eax,%eax
  800ceb:	7f 08                	jg     800cf5 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ced:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf0:	5b                   	pop    %ebx
  800cf1:	5e                   	pop    %esi
  800cf2:	5f                   	pop    %edi
  800cf3:	5d                   	pop    %ebp
  800cf4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf5:	83 ec 0c             	sub    $0xc,%esp
  800cf8:	50                   	push   %eax
  800cf9:	6a 04                	push   $0x4
  800cfb:	68 60 28 80 00       	push   $0x802860
  800d00:	6a 4c                	push   $0x4c
  800d02:	68 7d 28 80 00       	push   $0x80287d
  800d07:	e8 ca f3 ff ff       	call   8000d6 <_panic>

00800d0c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d0c:	55                   	push   %ebp
  800d0d:	89 e5                	mov    %esp,%ebp
  800d0f:	57                   	push   %edi
  800d10:	56                   	push   %esi
  800d11:	53                   	push   %ebx
  800d12:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d15:	8b 55 08             	mov    0x8(%ebp),%edx
  800d18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d1b:	b8 05 00 00 00       	mov    $0x5,%eax
  800d20:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d23:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d26:	8b 75 18             	mov    0x18(%ebp),%esi
  800d29:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d2b:	85 c0                	test   %eax,%eax
  800d2d:	7f 08                	jg     800d37 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d32:	5b                   	pop    %ebx
  800d33:	5e                   	pop    %esi
  800d34:	5f                   	pop    %edi
  800d35:	5d                   	pop    %ebp
  800d36:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d37:	83 ec 0c             	sub    $0xc,%esp
  800d3a:	50                   	push   %eax
  800d3b:	6a 05                	push   $0x5
  800d3d:	68 60 28 80 00       	push   $0x802860
  800d42:	6a 4c                	push   $0x4c
  800d44:	68 7d 28 80 00       	push   $0x80287d
  800d49:	e8 88 f3 ff ff       	call   8000d6 <_panic>

00800d4e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d4e:	55                   	push   %ebp
  800d4f:	89 e5                	mov    %esp,%ebp
  800d51:	57                   	push   %edi
  800d52:	56                   	push   %esi
  800d53:	53                   	push   %ebx
  800d54:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d57:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d62:	b8 06 00 00 00       	mov    $0x6,%eax
  800d67:	89 df                	mov    %ebx,%edi
  800d69:	89 de                	mov    %ebx,%esi
  800d6b:	cd 30                	int    $0x30
	if (check && ret > 0)
  800d6d:	85 c0                	test   %eax,%eax
  800d6f:	7f 08                	jg     800d79 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d74:	5b                   	pop    %ebx
  800d75:	5e                   	pop    %esi
  800d76:	5f                   	pop    %edi
  800d77:	5d                   	pop    %ebp
  800d78:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d79:	83 ec 0c             	sub    $0xc,%esp
  800d7c:	50                   	push   %eax
  800d7d:	6a 06                	push   $0x6
  800d7f:	68 60 28 80 00       	push   $0x802860
  800d84:	6a 4c                	push   $0x4c
  800d86:	68 7d 28 80 00       	push   $0x80287d
  800d8b:	e8 46 f3 ff ff       	call   8000d6 <_panic>

00800d90 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d90:	55                   	push   %ebp
  800d91:	89 e5                	mov    %esp,%ebp
  800d93:	57                   	push   %edi
  800d94:	56                   	push   %esi
  800d95:	53                   	push   %ebx
  800d96:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d99:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800da1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da4:	b8 08 00 00 00       	mov    $0x8,%eax
  800da9:	89 df                	mov    %ebx,%edi
  800dab:	89 de                	mov    %ebx,%esi
  800dad:	cd 30                	int    $0x30
	if (check && ret > 0)
  800daf:	85 c0                	test   %eax,%eax
  800db1:	7f 08                	jg     800dbb <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800db3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db6:	5b                   	pop    %ebx
  800db7:	5e                   	pop    %esi
  800db8:	5f                   	pop    %edi
  800db9:	5d                   	pop    %ebp
  800dba:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dbb:	83 ec 0c             	sub    $0xc,%esp
  800dbe:	50                   	push   %eax
  800dbf:	6a 08                	push   $0x8
  800dc1:	68 60 28 80 00       	push   $0x802860
  800dc6:	6a 4c                	push   $0x4c
  800dc8:	68 7d 28 80 00       	push   $0x80287d
  800dcd:	e8 04 f3 ff ff       	call   8000d6 <_panic>

00800dd2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800dd2:	55                   	push   %ebp
  800dd3:	89 e5                	mov    %esp,%ebp
  800dd5:	57                   	push   %edi
  800dd6:	56                   	push   %esi
  800dd7:	53                   	push   %ebx
  800dd8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ddb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800de0:	8b 55 08             	mov    0x8(%ebp),%edx
  800de3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de6:	b8 09 00 00 00       	mov    $0x9,%eax
  800deb:	89 df                	mov    %ebx,%edi
  800ded:	89 de                	mov    %ebx,%esi
  800def:	cd 30                	int    $0x30
	if (check && ret > 0)
  800df1:	85 c0                	test   %eax,%eax
  800df3:	7f 08                	jg     800dfd <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800df5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df8:	5b                   	pop    %ebx
  800df9:	5e                   	pop    %esi
  800dfa:	5f                   	pop    %edi
  800dfb:	5d                   	pop    %ebp
  800dfc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dfd:	83 ec 0c             	sub    $0xc,%esp
  800e00:	50                   	push   %eax
  800e01:	6a 09                	push   $0x9
  800e03:	68 60 28 80 00       	push   $0x802860
  800e08:	6a 4c                	push   $0x4c
  800e0a:	68 7d 28 80 00       	push   $0x80287d
  800e0f:	e8 c2 f2 ff ff       	call   8000d6 <_panic>

00800e14 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e14:	55                   	push   %ebp
  800e15:	89 e5                	mov    %esp,%ebp
  800e17:	57                   	push   %edi
  800e18:	56                   	push   %esi
  800e19:	53                   	push   %ebx
  800e1a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e1d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e22:	8b 55 08             	mov    0x8(%ebp),%edx
  800e25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e28:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e2d:	89 df                	mov    %ebx,%edi
  800e2f:	89 de                	mov    %ebx,%esi
  800e31:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e33:	85 c0                	test   %eax,%eax
  800e35:	7f 08                	jg     800e3f <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e3a:	5b                   	pop    %ebx
  800e3b:	5e                   	pop    %esi
  800e3c:	5f                   	pop    %edi
  800e3d:	5d                   	pop    %ebp
  800e3e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3f:	83 ec 0c             	sub    $0xc,%esp
  800e42:	50                   	push   %eax
  800e43:	6a 0a                	push   $0xa
  800e45:	68 60 28 80 00       	push   $0x802860
  800e4a:	6a 4c                	push   $0x4c
  800e4c:	68 7d 28 80 00       	push   $0x80287d
  800e51:	e8 80 f2 ff ff       	call   8000d6 <_panic>

00800e56 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e56:	55                   	push   %ebp
  800e57:	89 e5                	mov    %esp,%ebp
  800e59:	57                   	push   %edi
  800e5a:	56                   	push   %esi
  800e5b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e62:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e67:	be 00 00 00 00       	mov    $0x0,%esi
  800e6c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e6f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e72:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e74:	5b                   	pop    %ebx
  800e75:	5e                   	pop    %esi
  800e76:	5f                   	pop    %edi
  800e77:	5d                   	pop    %ebp
  800e78:	c3                   	ret    

00800e79 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
  800e7c:	57                   	push   %edi
  800e7d:	56                   	push   %esi
  800e7e:	53                   	push   %ebx
  800e7f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e82:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e87:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8a:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e8f:	89 cb                	mov    %ecx,%ebx
  800e91:	89 cf                	mov    %ecx,%edi
  800e93:	89 ce                	mov    %ecx,%esi
  800e95:	cd 30                	int    $0x30
	if (check && ret > 0)
  800e97:	85 c0                	test   %eax,%eax
  800e99:	7f 08                	jg     800ea3 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e9e:	5b                   	pop    %ebx
  800e9f:	5e                   	pop    %esi
  800ea0:	5f                   	pop    %edi
  800ea1:	5d                   	pop    %ebp
  800ea2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea3:	83 ec 0c             	sub    $0xc,%esp
  800ea6:	50                   	push   %eax
  800ea7:	6a 0d                	push   $0xd
  800ea9:	68 60 28 80 00       	push   $0x802860
  800eae:	6a 4c                	push   $0x4c
  800eb0:	68 7d 28 80 00       	push   $0x80287d
  800eb5:	e8 1c f2 ff ff       	call   8000d6 <_panic>

00800eba <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800eba:	55                   	push   %ebp
  800ebb:	89 e5                	mov    %esp,%ebp
  800ebd:	57                   	push   %edi
  800ebe:	56                   	push   %esi
  800ebf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ec0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ecb:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ed0:	89 df                	mov    %ebx,%edi
  800ed2:	89 de                	mov    %ebx,%esi
  800ed4:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800ed6:	5b                   	pop    %ebx
  800ed7:	5e                   	pop    %esi
  800ed8:	5f                   	pop    %edi
  800ed9:	5d                   	pop    %ebp
  800eda:	c3                   	ret    

00800edb <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800edb:	55                   	push   %ebp
  800edc:	89 e5                	mov    %esp,%ebp
  800ede:	57                   	push   %edi
  800edf:	56                   	push   %esi
  800ee0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ee6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee9:	b8 0f 00 00 00       	mov    $0xf,%eax
  800eee:	89 cb                	mov    %ecx,%ebx
  800ef0:	89 cf                	mov    %ecx,%edi
  800ef2:	89 ce                	mov    %ecx,%esi
  800ef4:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800ef6:	5b                   	pop    %ebx
  800ef7:	5e                   	pop    %esi
  800ef8:	5f                   	pop    %edi
  800ef9:	5d                   	pop    %ebp
  800efa:	c3                   	ret    

00800efb <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  800efb:	55                   	push   %ebp
  800efc:	89 e5                	mov    %esp,%ebp
  800efe:	57                   	push   %edi
  800eff:	56                   	push   %esi
  800f00:	53                   	push   %ebx
  800f01:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  800f07:	6a 00                	push   $0x0
  800f09:	ff 75 08             	pushl  0x8(%ebp)
  800f0c:	e8 65 0c 00 00       	call   801b76 <open>
  800f11:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  800f17:	83 c4 10             	add    $0x10,%esp
  800f1a:	85 c0                	test   %eax,%eax
  800f1c:	0f 88 72 04 00 00    	js     801394 <spawn+0x499>
  800f22:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  800f24:	83 ec 04             	sub    $0x4,%esp
  800f27:	68 00 02 00 00       	push   $0x200
  800f2c:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  800f32:	50                   	push   %eax
  800f33:	52                   	push   %edx
  800f34:	e8 8d 08 00 00       	call   8017c6 <readn>
  800f39:	83 c4 10             	add    $0x10,%esp
  800f3c:	3d 00 02 00 00       	cmp    $0x200,%eax
  800f41:	75 60                	jne    800fa3 <spawn+0xa8>
	    || elf->e_magic != ELF_MAGIC) {
  800f43:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  800f4a:	45 4c 46 
  800f4d:	75 54                	jne    800fa3 <spawn+0xa8>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f4f:	b8 07 00 00 00       	mov    $0x7,%eax
  800f54:	cd 30                	int    $0x30
  800f56:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  800f5c:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  800f62:	85 c0                	test   %eax,%eax
  800f64:	0f 88 1e 04 00 00    	js     801388 <spawn+0x48d>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  800f6a:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f6f:	69 f0 84 00 00 00    	imul   $0x84,%eax,%esi
  800f75:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  800f7b:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  800f81:	b9 11 00 00 00       	mov    $0x11,%ecx
  800f86:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  800f88:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  800f8e:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  800f94:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  800f99:	be 00 00 00 00       	mov    $0x0,%esi
  800f9e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800fa1:	eb 4b                	jmp    800fee <spawn+0xf3>
		close(fd);
  800fa3:	83 ec 0c             	sub    $0xc,%esp
  800fa6:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  800fac:	e8 50 06 00 00       	call   801601 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  800fb1:	83 c4 0c             	add    $0xc,%esp
  800fb4:	68 7f 45 4c 46       	push   $0x464c457f
  800fb9:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  800fbf:	68 8b 28 80 00       	push   $0x80288b
  800fc4:	e8 e8 f1 ff ff       	call   8001b1 <cprintf>
		return -E_NOT_EXEC;
  800fc9:	83 c4 10             	add    $0x10,%esp
  800fcc:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  800fd3:	ff ff ff 
  800fd6:	e9 b9 03 00 00       	jmp    801394 <spawn+0x499>
		string_size += strlen(argv[argc]) + 1;
  800fdb:	83 ec 0c             	sub    $0xc,%esp
  800fde:	50                   	push   %eax
  800fdf:	e8 ba f8 ff ff       	call   80089e <strlen>
  800fe4:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  800fe8:	83 c3 01             	add    $0x1,%ebx
  800feb:	83 c4 10             	add    $0x10,%esp
  800fee:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  800ff5:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  800ff8:	85 c0                	test   %eax,%eax
  800ffa:	75 df                	jne    800fdb <spawn+0xe0>
  800ffc:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801002:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801008:	bf 00 10 40 00       	mov    $0x401000,%edi
  80100d:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  80100f:	89 fa                	mov    %edi,%edx
  801011:	83 e2 fc             	and    $0xfffffffc,%edx
  801014:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  80101b:	29 c2                	sub    %eax,%edx
  80101d:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801023:	8d 42 f8             	lea    -0x8(%edx),%eax
  801026:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  80102b:	0f 86 86 03 00 00    	jbe    8013b7 <spawn+0x4bc>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801031:	83 ec 04             	sub    $0x4,%esp
  801034:	6a 07                	push   $0x7
  801036:	68 00 00 40 00       	push   $0x400000
  80103b:	6a 00                	push   $0x0
  80103d:	e8 87 fc ff ff       	call   800cc9 <sys_page_alloc>
  801042:	83 c4 10             	add    $0x10,%esp
  801045:	85 c0                	test   %eax,%eax
  801047:	0f 88 6f 03 00 00    	js     8013bc <spawn+0x4c1>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80104d:	be 00 00 00 00       	mov    $0x0,%esi
  801052:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801058:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80105b:	eb 30                	jmp    80108d <spawn+0x192>
		argv_store[i] = UTEMP2USTACK(string_store);
  80105d:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801063:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801069:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  80106c:	83 ec 08             	sub    $0x8,%esp
  80106f:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801072:	57                   	push   %edi
  801073:	e8 5f f8 ff ff       	call   8008d7 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801078:	83 c4 04             	add    $0x4,%esp
  80107b:	ff 34 b3             	pushl  (%ebx,%esi,4)
  80107e:	e8 1b f8 ff ff       	call   80089e <strlen>
  801083:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801087:	83 c6 01             	add    $0x1,%esi
  80108a:	83 c4 10             	add    $0x10,%esp
  80108d:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801093:	7f c8                	jg     80105d <spawn+0x162>
	}
	argv_store[argc] = 0;
  801095:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80109b:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  8010a1:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8010a8:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  8010ae:	0f 85 86 00 00 00    	jne    80113a <spawn+0x23f>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8010b4:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  8010ba:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  8010c0:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  8010c3:	89 c8                	mov    %ecx,%eax
  8010c5:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  8010cb:	89 48 f8             	mov    %ecx,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8010ce:	2d 08 30 80 11       	sub    $0x11803008,%eax
  8010d3:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8010d9:	83 ec 0c             	sub    $0xc,%esp
  8010dc:	6a 07                	push   $0x7
  8010de:	68 00 d0 bf ee       	push   $0xeebfd000
  8010e3:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8010e9:	68 00 00 40 00       	push   $0x400000
  8010ee:	6a 00                	push   $0x0
  8010f0:	e8 17 fc ff ff       	call   800d0c <sys_page_map>
  8010f5:	89 c3                	mov    %eax,%ebx
  8010f7:	83 c4 20             	add    $0x20,%esp
  8010fa:	85 c0                	test   %eax,%eax
  8010fc:	0f 88 c2 02 00 00    	js     8013c4 <spawn+0x4c9>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801102:	83 ec 08             	sub    $0x8,%esp
  801105:	68 00 00 40 00       	push   $0x400000
  80110a:	6a 00                	push   $0x0
  80110c:	e8 3d fc ff ff       	call   800d4e <sys_page_unmap>
  801111:	89 c3                	mov    %eax,%ebx
  801113:	83 c4 10             	add    $0x10,%esp
  801116:	85 c0                	test   %eax,%eax
  801118:	0f 88 a6 02 00 00    	js     8013c4 <spawn+0x4c9>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  80111e:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801124:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80112b:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  801132:	00 00 00 
  801135:	e9 4f 01 00 00       	jmp    801289 <spawn+0x38e>
	assert(string_store == (char*)UTEMP + PGSIZE);
  80113a:	68 14 29 80 00       	push   $0x802914
  80113f:	68 a5 28 80 00       	push   $0x8028a5
  801144:	68 f2 00 00 00       	push   $0xf2
  801149:	68 ba 28 80 00       	push   $0x8028ba
  80114e:	e8 83 ef ff ff       	call   8000d6 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801153:	83 ec 04             	sub    $0x4,%esp
  801156:	6a 07                	push   $0x7
  801158:	68 00 00 40 00       	push   $0x400000
  80115d:	6a 00                	push   $0x0
  80115f:	e8 65 fb ff ff       	call   800cc9 <sys_page_alloc>
  801164:	83 c4 10             	add    $0x10,%esp
  801167:	85 c0                	test   %eax,%eax
  801169:	0f 88 33 02 00 00    	js     8013a2 <spawn+0x4a7>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  80116f:	83 ec 08             	sub    $0x8,%esp
  801172:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801178:	01 f0                	add    %esi,%eax
  80117a:	50                   	push   %eax
  80117b:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801181:	e8 07 07 00 00       	call   80188d <seek>
  801186:	83 c4 10             	add    $0x10,%esp
  801189:	85 c0                	test   %eax,%eax
  80118b:	0f 88 18 02 00 00    	js     8013a9 <spawn+0x4ae>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801191:	83 ec 04             	sub    $0x4,%esp
  801194:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80119a:	29 f0                	sub    %esi,%eax
  80119c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8011a1:	ba 00 10 00 00       	mov    $0x1000,%edx
  8011a6:	0f 47 c2             	cmova  %edx,%eax
  8011a9:	50                   	push   %eax
  8011aa:	68 00 00 40 00       	push   $0x400000
  8011af:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8011b5:	e8 0c 06 00 00       	call   8017c6 <readn>
  8011ba:	83 c4 10             	add    $0x10,%esp
  8011bd:	85 c0                	test   %eax,%eax
  8011bf:	0f 88 eb 01 00 00    	js     8013b0 <spawn+0x4b5>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8011c5:	83 ec 0c             	sub    $0xc,%esp
  8011c8:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8011ce:	53                   	push   %ebx
  8011cf:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  8011d5:	68 00 00 40 00       	push   $0x400000
  8011da:	6a 00                	push   $0x0
  8011dc:	e8 2b fb ff ff       	call   800d0c <sys_page_map>
  8011e1:	83 c4 20             	add    $0x20,%esp
  8011e4:	85 c0                	test   %eax,%eax
  8011e6:	78 7c                	js     801264 <spawn+0x369>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  8011e8:	83 ec 08             	sub    $0x8,%esp
  8011eb:	68 00 00 40 00       	push   $0x400000
  8011f0:	6a 00                	push   $0x0
  8011f2:	e8 57 fb ff ff       	call   800d4e <sys_page_unmap>
  8011f7:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  8011fa:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801200:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801206:	89 fe                	mov    %edi,%esi
  801208:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  80120e:	76 69                	jbe    801279 <spawn+0x37e>
		if (i >= filesz) {
  801210:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801216:	0f 87 37 ff ff ff    	ja     801153 <spawn+0x258>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  80121c:	83 ec 04             	sub    $0x4,%esp
  80121f:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801225:	53                   	push   %ebx
  801226:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  80122c:	e8 98 fa ff ff       	call   800cc9 <sys_page_alloc>
  801231:	83 c4 10             	add    $0x10,%esp
  801234:	85 c0                	test   %eax,%eax
  801236:	79 c2                	jns    8011fa <spawn+0x2ff>
  801238:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  80123a:	83 ec 0c             	sub    $0xc,%esp
  80123d:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801243:	e8 02 fa ff ff       	call   800c4a <sys_env_destroy>
	close(fd);
  801248:	83 c4 04             	add    $0x4,%esp
  80124b:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801251:	e8 ab 03 00 00       	call   801601 <close>
	return r;
  801256:	83 c4 10             	add    $0x10,%esp
  801259:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  80125f:	e9 30 01 00 00       	jmp    801394 <spawn+0x499>
				panic("spawn: sys_page_map data: %e", r);
  801264:	50                   	push   %eax
  801265:	68 c6 28 80 00       	push   $0x8028c6
  80126a:	68 25 01 00 00       	push   $0x125
  80126f:	68 ba 28 80 00       	push   $0x8028ba
  801274:	e8 5d ee ff ff       	call   8000d6 <_panic>
  801279:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80127f:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801286:	83 c6 20             	add    $0x20,%esi
  801289:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801290:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801296:	7e 6d                	jle    801305 <spawn+0x40a>
		if (ph->p_type != ELF_PROG_LOAD)
  801298:	83 3e 01             	cmpl   $0x1,(%esi)
  80129b:	75 e2                	jne    80127f <spawn+0x384>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  80129d:	8b 46 18             	mov    0x18(%esi),%eax
  8012a0:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  8012a3:	83 f8 01             	cmp    $0x1,%eax
  8012a6:	19 c0                	sbb    %eax,%eax
  8012a8:	83 e0 fe             	and    $0xfffffffe,%eax
  8012ab:	83 c0 07             	add    $0x7,%eax
  8012ae:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  8012b4:	8b 4e 04             	mov    0x4(%esi),%ecx
  8012b7:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  8012bd:	8b 56 10             	mov    0x10(%esi),%edx
  8012c0:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  8012c6:	8b 7e 14             	mov    0x14(%esi),%edi
  8012c9:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  8012cf:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  8012d2:	89 d8                	mov    %ebx,%eax
  8012d4:	25 ff 0f 00 00       	and    $0xfff,%eax
  8012d9:	74 1a                	je     8012f5 <spawn+0x3fa>
		va -= i;
  8012db:	29 c3                	sub    %eax,%ebx
		memsz += i;
  8012dd:	01 c7                	add    %eax,%edi
  8012df:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  8012e5:	01 c2                	add    %eax,%edx
  8012e7:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  8012ed:	29 c1                	sub    %eax,%ecx
  8012ef:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  8012f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8012fa:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801300:	e9 01 ff ff ff       	jmp    801206 <spawn+0x30b>
	close(fd);
  801305:	83 ec 0c             	sub    $0xc,%esp
  801308:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80130e:	e8 ee 02 00 00       	call   801601 <close>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801313:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  80131a:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  80131d:	83 c4 08             	add    $0x8,%esp
  801320:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801326:	50                   	push   %eax
  801327:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80132d:	e8 a0 fa ff ff       	call   800dd2 <sys_env_set_trapframe>
  801332:	83 c4 10             	add    $0x10,%esp
  801335:	85 c0                	test   %eax,%eax
  801337:	78 25                	js     80135e <spawn+0x463>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801339:	83 ec 08             	sub    $0x8,%esp
  80133c:	6a 02                	push   $0x2
  80133e:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801344:	e8 47 fa ff ff       	call   800d90 <sys_env_set_status>
  801349:	83 c4 10             	add    $0x10,%esp
  80134c:	85 c0                	test   %eax,%eax
  80134e:	78 23                	js     801373 <spawn+0x478>
	return child;
  801350:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801356:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  80135c:	eb 36                	jmp    801394 <spawn+0x499>
		panic("sys_env_set_trapframe: %e", r);
  80135e:	50                   	push   %eax
  80135f:	68 e3 28 80 00       	push   $0x8028e3
  801364:	68 86 00 00 00       	push   $0x86
  801369:	68 ba 28 80 00       	push   $0x8028ba
  80136e:	e8 63 ed ff ff       	call   8000d6 <_panic>
		panic("sys_env_set_status: %e", r);
  801373:	50                   	push   %eax
  801374:	68 fd 28 80 00       	push   $0x8028fd
  801379:	68 89 00 00 00       	push   $0x89
  80137e:	68 ba 28 80 00       	push   $0x8028ba
  801383:	e8 4e ed ff ff       	call   8000d6 <_panic>
		return r;
  801388:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80138e:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  801394:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  80139a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80139d:	5b                   	pop    %ebx
  80139e:	5e                   	pop    %esi
  80139f:	5f                   	pop    %edi
  8013a0:	5d                   	pop    %ebp
  8013a1:	c3                   	ret    
  8013a2:	89 c7                	mov    %eax,%edi
  8013a4:	e9 91 fe ff ff       	jmp    80123a <spawn+0x33f>
  8013a9:	89 c7                	mov    %eax,%edi
  8013ab:	e9 8a fe ff ff       	jmp    80123a <spawn+0x33f>
  8013b0:	89 c7                	mov    %eax,%edi
  8013b2:	e9 83 fe ff ff       	jmp    80123a <spawn+0x33f>
		return -E_NO_MEM;
  8013b7:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8013bc:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8013c2:	eb d0                	jmp    801394 <spawn+0x499>
	sys_page_unmap(0, UTEMP);
  8013c4:	83 ec 08             	sub    $0x8,%esp
  8013c7:	68 00 00 40 00       	push   $0x400000
  8013cc:	6a 00                	push   $0x0
  8013ce:	e8 7b f9 ff ff       	call   800d4e <sys_page_unmap>
  8013d3:	83 c4 10             	add    $0x10,%esp
  8013d6:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  8013dc:	eb b6                	jmp    801394 <spawn+0x499>

008013de <spawnl>:
{
  8013de:	55                   	push   %ebp
  8013df:	89 e5                	mov    %esp,%ebp
  8013e1:	57                   	push   %edi
  8013e2:	56                   	push   %esi
  8013e3:	53                   	push   %ebx
  8013e4:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  8013e7:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  8013ea:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  8013ef:	8d 4a 04             	lea    0x4(%edx),%ecx
  8013f2:	83 3a 00             	cmpl   $0x0,(%edx)
  8013f5:	74 07                	je     8013fe <spawnl+0x20>
		argc++;
  8013f7:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  8013fa:	89 ca                	mov    %ecx,%edx
  8013fc:	eb f1                	jmp    8013ef <spawnl+0x11>
	const char *argv[argc+2];
  8013fe:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  801405:	83 e2 f0             	and    $0xfffffff0,%edx
  801408:	29 d4                	sub    %edx,%esp
  80140a:	8d 54 24 03          	lea    0x3(%esp),%edx
  80140e:	c1 ea 02             	shr    $0x2,%edx
  801411:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801418:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  80141a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80141d:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801424:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  80142b:	00 
	va_start(vl, arg0);
  80142c:	8d 4d 10             	lea    0x10(%ebp),%ecx
  80142f:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801431:	b8 00 00 00 00       	mov    $0x0,%eax
  801436:	eb 0b                	jmp    801443 <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  801438:	83 c0 01             	add    $0x1,%eax
  80143b:	8b 39                	mov    (%ecx),%edi
  80143d:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801440:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801443:	39 d0                	cmp    %edx,%eax
  801445:	75 f1                	jne    801438 <spawnl+0x5a>
	return spawn(prog, argv);
  801447:	83 ec 08             	sub    $0x8,%esp
  80144a:	56                   	push   %esi
  80144b:	ff 75 08             	pushl  0x8(%ebp)
  80144e:	e8 a8 fa ff ff       	call   800efb <spawn>
}
  801453:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801456:	5b                   	pop    %ebx
  801457:	5e                   	pop    %esi
  801458:	5f                   	pop    %edi
  801459:	5d                   	pop    %ebp
  80145a:	c3                   	ret    

0080145b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80145b:	55                   	push   %ebp
  80145c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80145e:	8b 45 08             	mov    0x8(%ebp),%eax
  801461:	05 00 00 00 30       	add    $0x30000000,%eax
  801466:	c1 e8 0c             	shr    $0xc,%eax
}
  801469:	5d                   	pop    %ebp
  80146a:	c3                   	ret    

0080146b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80146b:	55                   	push   %ebp
  80146c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801476:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80147b:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801480:	5d                   	pop    %ebp
  801481:	c3                   	ret    

00801482 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801482:	55                   	push   %ebp
  801483:	89 e5                	mov    %esp,%ebp
  801485:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80148a:	89 c2                	mov    %eax,%edx
  80148c:	c1 ea 16             	shr    $0x16,%edx
  80148f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801496:	f6 c2 01             	test   $0x1,%dl
  801499:	74 2d                	je     8014c8 <fd_alloc+0x46>
  80149b:	89 c2                	mov    %eax,%edx
  80149d:	c1 ea 0c             	shr    $0xc,%edx
  8014a0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014a7:	f6 c2 01             	test   $0x1,%dl
  8014aa:	74 1c                	je     8014c8 <fd_alloc+0x46>
  8014ac:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8014b1:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8014b6:	75 d2                	jne    80148a <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8014b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8014c1:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8014c6:	eb 0a                	jmp    8014d2 <fd_alloc+0x50>
			*fd_store = fd;
  8014c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014cb:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014d2:	5d                   	pop    %ebp
  8014d3:	c3                   	ret    

008014d4 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8014d4:	55                   	push   %ebp
  8014d5:	89 e5                	mov    %esp,%ebp
  8014d7:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8014da:	83 f8 1f             	cmp    $0x1f,%eax
  8014dd:	77 30                	ja     80150f <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8014df:	c1 e0 0c             	shl    $0xc,%eax
  8014e2:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8014e7:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8014ed:	f6 c2 01             	test   $0x1,%dl
  8014f0:	74 24                	je     801516 <fd_lookup+0x42>
  8014f2:	89 c2                	mov    %eax,%edx
  8014f4:	c1 ea 0c             	shr    $0xc,%edx
  8014f7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014fe:	f6 c2 01             	test   $0x1,%dl
  801501:	74 1a                	je     80151d <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801503:	8b 55 0c             	mov    0xc(%ebp),%edx
  801506:	89 02                	mov    %eax,(%edx)
	return 0;
  801508:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80150d:	5d                   	pop    %ebp
  80150e:	c3                   	ret    
		return -E_INVAL;
  80150f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801514:	eb f7                	jmp    80150d <fd_lookup+0x39>
		return -E_INVAL;
  801516:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80151b:	eb f0                	jmp    80150d <fd_lookup+0x39>
  80151d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801522:	eb e9                	jmp    80150d <fd_lookup+0x39>

00801524 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
  801527:	83 ec 08             	sub    $0x8,%esp
  80152a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80152d:	ba bc 29 80 00       	mov    $0x8029bc,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801532:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801537:	39 08                	cmp    %ecx,(%eax)
  801539:	74 33                	je     80156e <dev_lookup+0x4a>
  80153b:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80153e:	8b 02                	mov    (%edx),%eax
  801540:	85 c0                	test   %eax,%eax
  801542:	75 f3                	jne    801537 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801544:	a1 04 40 80 00       	mov    0x804004,%eax
  801549:	8b 40 48             	mov    0x48(%eax),%eax
  80154c:	83 ec 04             	sub    $0x4,%esp
  80154f:	51                   	push   %ecx
  801550:	50                   	push   %eax
  801551:	68 3c 29 80 00       	push   $0x80293c
  801556:	e8 56 ec ff ff       	call   8001b1 <cprintf>
	*dev = 0;
  80155b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801564:	83 c4 10             	add    $0x10,%esp
  801567:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80156c:	c9                   	leave  
  80156d:	c3                   	ret    
			*dev = devtab[i];
  80156e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801571:	89 01                	mov    %eax,(%ecx)
			return 0;
  801573:	b8 00 00 00 00       	mov    $0x0,%eax
  801578:	eb f2                	jmp    80156c <dev_lookup+0x48>

0080157a <fd_close>:
{
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
  80157d:	57                   	push   %edi
  80157e:	56                   	push   %esi
  80157f:	53                   	push   %ebx
  801580:	83 ec 24             	sub    $0x24,%esp
  801583:	8b 75 08             	mov    0x8(%ebp),%esi
  801586:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801589:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80158c:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80158d:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801593:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801596:	50                   	push   %eax
  801597:	e8 38 ff ff ff       	call   8014d4 <fd_lookup>
  80159c:	89 c3                	mov    %eax,%ebx
  80159e:	83 c4 10             	add    $0x10,%esp
  8015a1:	85 c0                	test   %eax,%eax
  8015a3:	78 05                	js     8015aa <fd_close+0x30>
	    || fd != fd2)
  8015a5:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8015a8:	74 16                	je     8015c0 <fd_close+0x46>
		return (must_exist ? r : 0);
  8015aa:	89 f8                	mov    %edi,%eax
  8015ac:	84 c0                	test   %al,%al
  8015ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b3:	0f 44 d8             	cmove  %eax,%ebx
}
  8015b6:	89 d8                	mov    %ebx,%eax
  8015b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015bb:	5b                   	pop    %ebx
  8015bc:	5e                   	pop    %esi
  8015bd:	5f                   	pop    %edi
  8015be:	5d                   	pop    %ebp
  8015bf:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8015c0:	83 ec 08             	sub    $0x8,%esp
  8015c3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8015c6:	50                   	push   %eax
  8015c7:	ff 36                	pushl  (%esi)
  8015c9:	e8 56 ff ff ff       	call   801524 <dev_lookup>
  8015ce:	89 c3                	mov    %eax,%ebx
  8015d0:	83 c4 10             	add    $0x10,%esp
  8015d3:	85 c0                	test   %eax,%eax
  8015d5:	78 1a                	js     8015f1 <fd_close+0x77>
		if (dev->dev_close)
  8015d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015da:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8015dd:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8015e2:	85 c0                	test   %eax,%eax
  8015e4:	74 0b                	je     8015f1 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8015e6:	83 ec 0c             	sub    $0xc,%esp
  8015e9:	56                   	push   %esi
  8015ea:	ff d0                	call   *%eax
  8015ec:	89 c3                	mov    %eax,%ebx
  8015ee:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8015f1:	83 ec 08             	sub    $0x8,%esp
  8015f4:	56                   	push   %esi
  8015f5:	6a 00                	push   $0x0
  8015f7:	e8 52 f7 ff ff       	call   800d4e <sys_page_unmap>
	return r;
  8015fc:	83 c4 10             	add    $0x10,%esp
  8015ff:	eb b5                	jmp    8015b6 <fd_close+0x3c>

00801601 <close>:

int
close(int fdnum)
{
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
  801604:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801607:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80160a:	50                   	push   %eax
  80160b:	ff 75 08             	pushl  0x8(%ebp)
  80160e:	e8 c1 fe ff ff       	call   8014d4 <fd_lookup>
  801613:	83 c4 10             	add    $0x10,%esp
  801616:	85 c0                	test   %eax,%eax
  801618:	79 02                	jns    80161c <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80161a:	c9                   	leave  
  80161b:	c3                   	ret    
		return fd_close(fd, 1);
  80161c:	83 ec 08             	sub    $0x8,%esp
  80161f:	6a 01                	push   $0x1
  801621:	ff 75 f4             	pushl  -0xc(%ebp)
  801624:	e8 51 ff ff ff       	call   80157a <fd_close>
  801629:	83 c4 10             	add    $0x10,%esp
  80162c:	eb ec                	jmp    80161a <close+0x19>

0080162e <close_all>:

void
close_all(void)
{
  80162e:	55                   	push   %ebp
  80162f:	89 e5                	mov    %esp,%ebp
  801631:	53                   	push   %ebx
  801632:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801635:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80163a:	83 ec 0c             	sub    $0xc,%esp
  80163d:	53                   	push   %ebx
  80163e:	e8 be ff ff ff       	call   801601 <close>
	for (i = 0; i < MAXFD; i++)
  801643:	83 c3 01             	add    $0x1,%ebx
  801646:	83 c4 10             	add    $0x10,%esp
  801649:	83 fb 20             	cmp    $0x20,%ebx
  80164c:	75 ec                	jne    80163a <close_all+0xc>
}
  80164e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801651:	c9                   	leave  
  801652:	c3                   	ret    

00801653 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
  801656:	57                   	push   %edi
  801657:	56                   	push   %esi
  801658:	53                   	push   %ebx
  801659:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80165c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80165f:	50                   	push   %eax
  801660:	ff 75 08             	pushl  0x8(%ebp)
  801663:	e8 6c fe ff ff       	call   8014d4 <fd_lookup>
  801668:	89 c3                	mov    %eax,%ebx
  80166a:	83 c4 10             	add    $0x10,%esp
  80166d:	85 c0                	test   %eax,%eax
  80166f:	0f 88 81 00 00 00    	js     8016f6 <dup+0xa3>
		return r;
	close(newfdnum);
  801675:	83 ec 0c             	sub    $0xc,%esp
  801678:	ff 75 0c             	pushl  0xc(%ebp)
  80167b:	e8 81 ff ff ff       	call   801601 <close>

	newfd = INDEX2FD(newfdnum);
  801680:	8b 75 0c             	mov    0xc(%ebp),%esi
  801683:	c1 e6 0c             	shl    $0xc,%esi
  801686:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80168c:	83 c4 04             	add    $0x4,%esp
  80168f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801692:	e8 d4 fd ff ff       	call   80146b <fd2data>
  801697:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801699:	89 34 24             	mov    %esi,(%esp)
  80169c:	e8 ca fd ff ff       	call   80146b <fd2data>
  8016a1:	83 c4 10             	add    $0x10,%esp
  8016a4:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8016a6:	89 d8                	mov    %ebx,%eax
  8016a8:	c1 e8 16             	shr    $0x16,%eax
  8016ab:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016b2:	a8 01                	test   $0x1,%al
  8016b4:	74 11                	je     8016c7 <dup+0x74>
  8016b6:	89 d8                	mov    %ebx,%eax
  8016b8:	c1 e8 0c             	shr    $0xc,%eax
  8016bb:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8016c2:	f6 c2 01             	test   $0x1,%dl
  8016c5:	75 39                	jne    801700 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016ca:	89 d0                	mov    %edx,%eax
  8016cc:	c1 e8 0c             	shr    $0xc,%eax
  8016cf:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016d6:	83 ec 0c             	sub    $0xc,%esp
  8016d9:	25 07 0e 00 00       	and    $0xe07,%eax
  8016de:	50                   	push   %eax
  8016df:	56                   	push   %esi
  8016e0:	6a 00                	push   $0x0
  8016e2:	52                   	push   %edx
  8016e3:	6a 00                	push   $0x0
  8016e5:	e8 22 f6 ff ff       	call   800d0c <sys_page_map>
  8016ea:	89 c3                	mov    %eax,%ebx
  8016ec:	83 c4 20             	add    $0x20,%esp
  8016ef:	85 c0                	test   %eax,%eax
  8016f1:	78 31                	js     801724 <dup+0xd1>
		goto err;

	return newfdnum;
  8016f3:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8016f6:	89 d8                	mov    %ebx,%eax
  8016f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016fb:	5b                   	pop    %ebx
  8016fc:	5e                   	pop    %esi
  8016fd:	5f                   	pop    %edi
  8016fe:	5d                   	pop    %ebp
  8016ff:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801700:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801707:	83 ec 0c             	sub    $0xc,%esp
  80170a:	25 07 0e 00 00       	and    $0xe07,%eax
  80170f:	50                   	push   %eax
  801710:	57                   	push   %edi
  801711:	6a 00                	push   $0x0
  801713:	53                   	push   %ebx
  801714:	6a 00                	push   $0x0
  801716:	e8 f1 f5 ff ff       	call   800d0c <sys_page_map>
  80171b:	89 c3                	mov    %eax,%ebx
  80171d:	83 c4 20             	add    $0x20,%esp
  801720:	85 c0                	test   %eax,%eax
  801722:	79 a3                	jns    8016c7 <dup+0x74>
	sys_page_unmap(0, newfd);
  801724:	83 ec 08             	sub    $0x8,%esp
  801727:	56                   	push   %esi
  801728:	6a 00                	push   $0x0
  80172a:	e8 1f f6 ff ff       	call   800d4e <sys_page_unmap>
	sys_page_unmap(0, nva);
  80172f:	83 c4 08             	add    $0x8,%esp
  801732:	57                   	push   %edi
  801733:	6a 00                	push   $0x0
  801735:	e8 14 f6 ff ff       	call   800d4e <sys_page_unmap>
	return r;
  80173a:	83 c4 10             	add    $0x10,%esp
  80173d:	eb b7                	jmp    8016f6 <dup+0xa3>

0080173f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80173f:	55                   	push   %ebp
  801740:	89 e5                	mov    %esp,%ebp
  801742:	53                   	push   %ebx
  801743:	83 ec 1c             	sub    $0x1c,%esp
  801746:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801749:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80174c:	50                   	push   %eax
  80174d:	53                   	push   %ebx
  80174e:	e8 81 fd ff ff       	call   8014d4 <fd_lookup>
  801753:	83 c4 10             	add    $0x10,%esp
  801756:	85 c0                	test   %eax,%eax
  801758:	78 3f                	js     801799 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80175a:	83 ec 08             	sub    $0x8,%esp
  80175d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801760:	50                   	push   %eax
  801761:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801764:	ff 30                	pushl  (%eax)
  801766:	e8 b9 fd ff ff       	call   801524 <dev_lookup>
  80176b:	83 c4 10             	add    $0x10,%esp
  80176e:	85 c0                	test   %eax,%eax
  801770:	78 27                	js     801799 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801772:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801775:	8b 42 08             	mov    0x8(%edx),%eax
  801778:	83 e0 03             	and    $0x3,%eax
  80177b:	83 f8 01             	cmp    $0x1,%eax
  80177e:	74 1e                	je     80179e <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801783:	8b 40 08             	mov    0x8(%eax),%eax
  801786:	85 c0                	test   %eax,%eax
  801788:	74 35                	je     8017bf <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80178a:	83 ec 04             	sub    $0x4,%esp
  80178d:	ff 75 10             	pushl  0x10(%ebp)
  801790:	ff 75 0c             	pushl  0xc(%ebp)
  801793:	52                   	push   %edx
  801794:	ff d0                	call   *%eax
  801796:	83 c4 10             	add    $0x10,%esp
}
  801799:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80179c:	c9                   	leave  
  80179d:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80179e:	a1 04 40 80 00       	mov    0x804004,%eax
  8017a3:	8b 40 48             	mov    0x48(%eax),%eax
  8017a6:	83 ec 04             	sub    $0x4,%esp
  8017a9:	53                   	push   %ebx
  8017aa:	50                   	push   %eax
  8017ab:	68 80 29 80 00       	push   $0x802980
  8017b0:	e8 fc e9 ff ff       	call   8001b1 <cprintf>
		return -E_INVAL;
  8017b5:	83 c4 10             	add    $0x10,%esp
  8017b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017bd:	eb da                	jmp    801799 <read+0x5a>
		return -E_NOT_SUPP;
  8017bf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017c4:	eb d3                	jmp    801799 <read+0x5a>

008017c6 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8017c6:	55                   	push   %ebp
  8017c7:	89 e5                	mov    %esp,%ebp
  8017c9:	57                   	push   %edi
  8017ca:	56                   	push   %esi
  8017cb:	53                   	push   %ebx
  8017cc:	83 ec 0c             	sub    $0xc,%esp
  8017cf:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017d2:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017d5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017da:	39 f3                	cmp    %esi,%ebx
  8017dc:	73 23                	jae    801801 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017de:	83 ec 04             	sub    $0x4,%esp
  8017e1:	89 f0                	mov    %esi,%eax
  8017e3:	29 d8                	sub    %ebx,%eax
  8017e5:	50                   	push   %eax
  8017e6:	89 d8                	mov    %ebx,%eax
  8017e8:	03 45 0c             	add    0xc(%ebp),%eax
  8017eb:	50                   	push   %eax
  8017ec:	57                   	push   %edi
  8017ed:	e8 4d ff ff ff       	call   80173f <read>
		if (m < 0)
  8017f2:	83 c4 10             	add    $0x10,%esp
  8017f5:	85 c0                	test   %eax,%eax
  8017f7:	78 06                	js     8017ff <readn+0x39>
			return m;
		if (m == 0)
  8017f9:	74 06                	je     801801 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8017fb:	01 c3                	add    %eax,%ebx
  8017fd:	eb db                	jmp    8017da <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017ff:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801801:	89 d8                	mov    %ebx,%eax
  801803:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801806:	5b                   	pop    %ebx
  801807:	5e                   	pop    %esi
  801808:	5f                   	pop    %edi
  801809:	5d                   	pop    %ebp
  80180a:	c3                   	ret    

0080180b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
  80180e:	53                   	push   %ebx
  80180f:	83 ec 1c             	sub    $0x1c,%esp
  801812:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801815:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801818:	50                   	push   %eax
  801819:	53                   	push   %ebx
  80181a:	e8 b5 fc ff ff       	call   8014d4 <fd_lookup>
  80181f:	83 c4 10             	add    $0x10,%esp
  801822:	85 c0                	test   %eax,%eax
  801824:	78 3a                	js     801860 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801826:	83 ec 08             	sub    $0x8,%esp
  801829:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80182c:	50                   	push   %eax
  80182d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801830:	ff 30                	pushl  (%eax)
  801832:	e8 ed fc ff ff       	call   801524 <dev_lookup>
  801837:	83 c4 10             	add    $0x10,%esp
  80183a:	85 c0                	test   %eax,%eax
  80183c:	78 22                	js     801860 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80183e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801841:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801845:	74 1e                	je     801865 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801847:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80184a:	8b 52 0c             	mov    0xc(%edx),%edx
  80184d:	85 d2                	test   %edx,%edx
  80184f:	74 35                	je     801886 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801851:	83 ec 04             	sub    $0x4,%esp
  801854:	ff 75 10             	pushl  0x10(%ebp)
  801857:	ff 75 0c             	pushl  0xc(%ebp)
  80185a:	50                   	push   %eax
  80185b:	ff d2                	call   *%edx
  80185d:	83 c4 10             	add    $0x10,%esp
}
  801860:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801863:	c9                   	leave  
  801864:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801865:	a1 04 40 80 00       	mov    0x804004,%eax
  80186a:	8b 40 48             	mov    0x48(%eax),%eax
  80186d:	83 ec 04             	sub    $0x4,%esp
  801870:	53                   	push   %ebx
  801871:	50                   	push   %eax
  801872:	68 9c 29 80 00       	push   $0x80299c
  801877:	e8 35 e9 ff ff       	call   8001b1 <cprintf>
		return -E_INVAL;
  80187c:	83 c4 10             	add    $0x10,%esp
  80187f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801884:	eb da                	jmp    801860 <write+0x55>
		return -E_NOT_SUPP;
  801886:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80188b:	eb d3                	jmp    801860 <write+0x55>

0080188d <seek>:

int
seek(int fdnum, off_t offset)
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
  801890:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801893:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801896:	50                   	push   %eax
  801897:	ff 75 08             	pushl  0x8(%ebp)
  80189a:	e8 35 fc ff ff       	call   8014d4 <fd_lookup>
  80189f:	83 c4 10             	add    $0x10,%esp
  8018a2:	85 c0                	test   %eax,%eax
  8018a4:	78 0e                	js     8018b4 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8018a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ac:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8018af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	53                   	push   %ebx
  8018ba:	83 ec 1c             	sub    $0x1c,%esp
  8018bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018c3:	50                   	push   %eax
  8018c4:	53                   	push   %ebx
  8018c5:	e8 0a fc ff ff       	call   8014d4 <fd_lookup>
  8018ca:	83 c4 10             	add    $0x10,%esp
  8018cd:	85 c0                	test   %eax,%eax
  8018cf:	78 37                	js     801908 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018d1:	83 ec 08             	sub    $0x8,%esp
  8018d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018d7:	50                   	push   %eax
  8018d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018db:	ff 30                	pushl  (%eax)
  8018dd:	e8 42 fc ff ff       	call   801524 <dev_lookup>
  8018e2:	83 c4 10             	add    $0x10,%esp
  8018e5:	85 c0                	test   %eax,%eax
  8018e7:	78 1f                	js     801908 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ec:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018f0:	74 1b                	je     80190d <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8018f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018f5:	8b 52 18             	mov    0x18(%edx),%edx
  8018f8:	85 d2                	test   %edx,%edx
  8018fa:	74 32                	je     80192e <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8018fc:	83 ec 08             	sub    $0x8,%esp
  8018ff:	ff 75 0c             	pushl  0xc(%ebp)
  801902:	50                   	push   %eax
  801903:	ff d2                	call   *%edx
  801905:	83 c4 10             	add    $0x10,%esp
}
  801908:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80190b:	c9                   	leave  
  80190c:	c3                   	ret    
			thisenv->env_id, fdnum);
  80190d:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801912:	8b 40 48             	mov    0x48(%eax),%eax
  801915:	83 ec 04             	sub    $0x4,%esp
  801918:	53                   	push   %ebx
  801919:	50                   	push   %eax
  80191a:	68 5c 29 80 00       	push   $0x80295c
  80191f:	e8 8d e8 ff ff       	call   8001b1 <cprintf>
		return -E_INVAL;
  801924:	83 c4 10             	add    $0x10,%esp
  801927:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80192c:	eb da                	jmp    801908 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80192e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801933:	eb d3                	jmp    801908 <ftruncate+0x52>

00801935 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
  801938:	53                   	push   %ebx
  801939:	83 ec 1c             	sub    $0x1c,%esp
  80193c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80193f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801942:	50                   	push   %eax
  801943:	ff 75 08             	pushl  0x8(%ebp)
  801946:	e8 89 fb ff ff       	call   8014d4 <fd_lookup>
  80194b:	83 c4 10             	add    $0x10,%esp
  80194e:	85 c0                	test   %eax,%eax
  801950:	78 4b                	js     80199d <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801952:	83 ec 08             	sub    $0x8,%esp
  801955:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801958:	50                   	push   %eax
  801959:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80195c:	ff 30                	pushl  (%eax)
  80195e:	e8 c1 fb ff ff       	call   801524 <dev_lookup>
  801963:	83 c4 10             	add    $0x10,%esp
  801966:	85 c0                	test   %eax,%eax
  801968:	78 33                	js     80199d <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80196a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80196d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801971:	74 2f                	je     8019a2 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801973:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801976:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80197d:	00 00 00 
	stat->st_isdir = 0;
  801980:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801987:	00 00 00 
	stat->st_dev = dev;
  80198a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801990:	83 ec 08             	sub    $0x8,%esp
  801993:	53                   	push   %ebx
  801994:	ff 75 f0             	pushl  -0x10(%ebp)
  801997:	ff 50 14             	call   *0x14(%eax)
  80199a:	83 c4 10             	add    $0x10,%esp
}
  80199d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019a0:	c9                   	leave  
  8019a1:	c3                   	ret    
		return -E_NOT_SUPP;
  8019a2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019a7:	eb f4                	jmp    80199d <fstat+0x68>

008019a9 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
  8019ac:	56                   	push   %esi
  8019ad:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8019ae:	83 ec 08             	sub    $0x8,%esp
  8019b1:	6a 00                	push   $0x0
  8019b3:	ff 75 08             	pushl  0x8(%ebp)
  8019b6:	e8 bb 01 00 00       	call   801b76 <open>
  8019bb:	89 c3                	mov    %eax,%ebx
  8019bd:	83 c4 10             	add    $0x10,%esp
  8019c0:	85 c0                	test   %eax,%eax
  8019c2:	78 1b                	js     8019df <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8019c4:	83 ec 08             	sub    $0x8,%esp
  8019c7:	ff 75 0c             	pushl  0xc(%ebp)
  8019ca:	50                   	push   %eax
  8019cb:	e8 65 ff ff ff       	call   801935 <fstat>
  8019d0:	89 c6                	mov    %eax,%esi
	close(fd);
  8019d2:	89 1c 24             	mov    %ebx,(%esp)
  8019d5:	e8 27 fc ff ff       	call   801601 <close>
	return r;
  8019da:	83 c4 10             	add    $0x10,%esp
  8019dd:	89 f3                	mov    %esi,%ebx
}
  8019df:	89 d8                	mov    %ebx,%eax
  8019e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019e4:	5b                   	pop    %ebx
  8019e5:	5e                   	pop    %esi
  8019e6:	5d                   	pop    %ebp
  8019e7:	c3                   	ret    

008019e8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
  8019eb:	56                   	push   %esi
  8019ec:	53                   	push   %ebx
  8019ed:	89 c6                	mov    %eax,%esi
  8019ef:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8019f1:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8019f8:	74 27                	je     801a21 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8019fa:	6a 07                	push   $0x7
  8019fc:	68 00 50 80 00       	push   $0x805000
  801a01:	56                   	push   %esi
  801a02:	ff 35 00 40 80 00    	pushl  0x804000
  801a08:	e8 3a 07 00 00       	call   802147 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a0d:	83 c4 0c             	add    $0xc,%esp
  801a10:	6a 00                	push   $0x0
  801a12:	53                   	push   %ebx
  801a13:	6a 00                	push   $0x0
  801a15:	e8 c4 06 00 00       	call   8020de <ipc_recv>
}
  801a1a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a1d:	5b                   	pop    %ebx
  801a1e:	5e                   	pop    %esi
  801a1f:	5d                   	pop    %ebp
  801a20:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a21:	83 ec 0c             	sub    $0xc,%esp
  801a24:	6a 01                	push   $0x1
  801a26:	e8 69 07 00 00       	call   802194 <ipc_find_env>
  801a2b:	a3 00 40 80 00       	mov    %eax,0x804000
  801a30:	83 c4 10             	add    $0x10,%esp
  801a33:	eb c5                	jmp    8019fa <fsipc+0x12>

00801a35 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
  801a38:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3e:	8b 40 0c             	mov    0xc(%eax),%eax
  801a41:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801a46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a49:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a4e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a53:	b8 02 00 00 00       	mov    $0x2,%eax
  801a58:	e8 8b ff ff ff       	call   8019e8 <fsipc>
}
  801a5d:	c9                   	leave  
  801a5e:	c3                   	ret    

00801a5f <devfile_flush>:
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
  801a62:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a65:	8b 45 08             	mov    0x8(%ebp),%eax
  801a68:	8b 40 0c             	mov    0xc(%eax),%eax
  801a6b:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801a70:	ba 00 00 00 00       	mov    $0x0,%edx
  801a75:	b8 06 00 00 00       	mov    $0x6,%eax
  801a7a:	e8 69 ff ff ff       	call   8019e8 <fsipc>
}
  801a7f:	c9                   	leave  
  801a80:	c3                   	ret    

00801a81 <devfile_stat>:
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
  801a84:	53                   	push   %ebx
  801a85:	83 ec 04             	sub    $0x4,%esp
  801a88:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8e:	8b 40 0c             	mov    0xc(%eax),%eax
  801a91:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a96:	ba 00 00 00 00       	mov    $0x0,%edx
  801a9b:	b8 05 00 00 00       	mov    $0x5,%eax
  801aa0:	e8 43 ff ff ff       	call   8019e8 <fsipc>
  801aa5:	85 c0                	test   %eax,%eax
  801aa7:	78 2c                	js     801ad5 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801aa9:	83 ec 08             	sub    $0x8,%esp
  801aac:	68 00 50 80 00       	push   $0x805000
  801ab1:	53                   	push   %ebx
  801ab2:	e8 20 ee ff ff       	call   8008d7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801ab7:	a1 80 50 80 00       	mov    0x805080,%eax
  801abc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801ac2:	a1 84 50 80 00       	mov    0x805084,%eax
  801ac7:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801acd:	83 c4 10             	add    $0x10,%esp
  801ad0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ad5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

00801ada <devfile_write>:
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
  801add:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  801ae0:	68 cc 29 80 00       	push   $0x8029cc
  801ae5:	68 90 00 00 00       	push   $0x90
  801aea:	68 ea 29 80 00       	push   $0x8029ea
  801aef:	e8 e2 e5 ff ff       	call   8000d6 <_panic>

00801af4 <devfile_read>:
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
  801af7:	56                   	push   %esi
  801af8:	53                   	push   %ebx
  801af9:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801afc:	8b 45 08             	mov    0x8(%ebp),%eax
  801aff:	8b 40 0c             	mov    0xc(%eax),%eax
  801b02:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801b07:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b0d:	ba 00 00 00 00       	mov    $0x0,%edx
  801b12:	b8 03 00 00 00       	mov    $0x3,%eax
  801b17:	e8 cc fe ff ff       	call   8019e8 <fsipc>
  801b1c:	89 c3                	mov    %eax,%ebx
  801b1e:	85 c0                	test   %eax,%eax
  801b20:	78 1f                	js     801b41 <devfile_read+0x4d>
	assert(r <= n);
  801b22:	39 f0                	cmp    %esi,%eax
  801b24:	77 24                	ja     801b4a <devfile_read+0x56>
	assert(r <= PGSIZE);
  801b26:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b2b:	7f 33                	jg     801b60 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b2d:	83 ec 04             	sub    $0x4,%esp
  801b30:	50                   	push   %eax
  801b31:	68 00 50 80 00       	push   $0x805000
  801b36:	ff 75 0c             	pushl  0xc(%ebp)
  801b39:	e8 27 ef ff ff       	call   800a65 <memmove>
	return r;
  801b3e:	83 c4 10             	add    $0x10,%esp
}
  801b41:	89 d8                	mov    %ebx,%eax
  801b43:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b46:	5b                   	pop    %ebx
  801b47:	5e                   	pop    %esi
  801b48:	5d                   	pop    %ebp
  801b49:	c3                   	ret    
	assert(r <= n);
  801b4a:	68 f5 29 80 00       	push   $0x8029f5
  801b4f:	68 a5 28 80 00       	push   $0x8028a5
  801b54:	6a 7c                	push   $0x7c
  801b56:	68 ea 29 80 00       	push   $0x8029ea
  801b5b:	e8 76 e5 ff ff       	call   8000d6 <_panic>
	assert(r <= PGSIZE);
  801b60:	68 fc 29 80 00       	push   $0x8029fc
  801b65:	68 a5 28 80 00       	push   $0x8028a5
  801b6a:	6a 7d                	push   $0x7d
  801b6c:	68 ea 29 80 00       	push   $0x8029ea
  801b71:	e8 60 e5 ff ff       	call   8000d6 <_panic>

00801b76 <open>:
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
  801b79:	56                   	push   %esi
  801b7a:	53                   	push   %ebx
  801b7b:	83 ec 1c             	sub    $0x1c,%esp
  801b7e:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b81:	56                   	push   %esi
  801b82:	e8 17 ed ff ff       	call   80089e <strlen>
  801b87:	83 c4 10             	add    $0x10,%esp
  801b8a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b8f:	7f 6c                	jg     801bfd <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801b91:	83 ec 0c             	sub    $0xc,%esp
  801b94:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b97:	50                   	push   %eax
  801b98:	e8 e5 f8 ff ff       	call   801482 <fd_alloc>
  801b9d:	89 c3                	mov    %eax,%ebx
  801b9f:	83 c4 10             	add    $0x10,%esp
  801ba2:	85 c0                	test   %eax,%eax
  801ba4:	78 3c                	js     801be2 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801ba6:	83 ec 08             	sub    $0x8,%esp
  801ba9:	56                   	push   %esi
  801baa:	68 00 50 80 00       	push   $0x805000
  801baf:	e8 23 ed ff ff       	call   8008d7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801bb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb7:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801bbc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bbf:	b8 01 00 00 00       	mov    $0x1,%eax
  801bc4:	e8 1f fe ff ff       	call   8019e8 <fsipc>
  801bc9:	89 c3                	mov    %eax,%ebx
  801bcb:	83 c4 10             	add    $0x10,%esp
  801bce:	85 c0                	test   %eax,%eax
  801bd0:	78 19                	js     801beb <open+0x75>
	return fd2num(fd);
  801bd2:	83 ec 0c             	sub    $0xc,%esp
  801bd5:	ff 75 f4             	pushl  -0xc(%ebp)
  801bd8:	e8 7e f8 ff ff       	call   80145b <fd2num>
  801bdd:	89 c3                	mov    %eax,%ebx
  801bdf:	83 c4 10             	add    $0x10,%esp
}
  801be2:	89 d8                	mov    %ebx,%eax
  801be4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801be7:	5b                   	pop    %ebx
  801be8:	5e                   	pop    %esi
  801be9:	5d                   	pop    %ebp
  801bea:	c3                   	ret    
		fd_close(fd, 0);
  801beb:	83 ec 08             	sub    $0x8,%esp
  801bee:	6a 00                	push   $0x0
  801bf0:	ff 75 f4             	pushl  -0xc(%ebp)
  801bf3:	e8 82 f9 ff ff       	call   80157a <fd_close>
		return r;
  801bf8:	83 c4 10             	add    $0x10,%esp
  801bfb:	eb e5                	jmp    801be2 <open+0x6c>
		return -E_BAD_PATH;
  801bfd:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801c02:	eb de                	jmp    801be2 <open+0x6c>

00801c04 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c04:	55                   	push   %ebp
  801c05:	89 e5                	mov    %esp,%ebp
  801c07:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c0a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c0f:	b8 08 00 00 00       	mov    $0x8,%eax
  801c14:	e8 cf fd ff ff       	call   8019e8 <fsipc>
}
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    

00801c1b <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
  801c1e:	56                   	push   %esi
  801c1f:	53                   	push   %ebx
  801c20:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c23:	83 ec 0c             	sub    $0xc,%esp
  801c26:	ff 75 08             	pushl  0x8(%ebp)
  801c29:	e8 3d f8 ff ff       	call   80146b <fd2data>
  801c2e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c30:	83 c4 08             	add    $0x8,%esp
  801c33:	68 08 2a 80 00       	push   $0x802a08
  801c38:	53                   	push   %ebx
  801c39:	e8 99 ec ff ff       	call   8008d7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c3e:	8b 46 04             	mov    0x4(%esi),%eax
  801c41:	2b 06                	sub    (%esi),%eax
  801c43:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c49:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c50:	00 00 00 
	stat->st_dev = &devpipe;
  801c53:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801c5a:	30 80 00 
	return 0;
}
  801c5d:	b8 00 00 00 00       	mov    $0x0,%eax
  801c62:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c65:	5b                   	pop    %ebx
  801c66:	5e                   	pop    %esi
  801c67:	5d                   	pop    %ebp
  801c68:	c3                   	ret    

00801c69 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
  801c6c:	53                   	push   %ebx
  801c6d:	83 ec 0c             	sub    $0xc,%esp
  801c70:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c73:	53                   	push   %ebx
  801c74:	6a 00                	push   $0x0
  801c76:	e8 d3 f0 ff ff       	call   800d4e <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c7b:	89 1c 24             	mov    %ebx,(%esp)
  801c7e:	e8 e8 f7 ff ff       	call   80146b <fd2data>
  801c83:	83 c4 08             	add    $0x8,%esp
  801c86:	50                   	push   %eax
  801c87:	6a 00                	push   $0x0
  801c89:	e8 c0 f0 ff ff       	call   800d4e <sys_page_unmap>
}
  801c8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c91:	c9                   	leave  
  801c92:	c3                   	ret    

00801c93 <_pipeisclosed>:
{
  801c93:	55                   	push   %ebp
  801c94:	89 e5                	mov    %esp,%ebp
  801c96:	57                   	push   %edi
  801c97:	56                   	push   %esi
  801c98:	53                   	push   %ebx
  801c99:	83 ec 1c             	sub    $0x1c,%esp
  801c9c:	89 c7                	mov    %eax,%edi
  801c9e:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801ca0:	a1 04 40 80 00       	mov    0x804004,%eax
  801ca5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801ca8:	83 ec 0c             	sub    $0xc,%esp
  801cab:	57                   	push   %edi
  801cac:	e8 22 05 00 00       	call   8021d3 <pageref>
  801cb1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cb4:	89 34 24             	mov    %esi,(%esp)
  801cb7:	e8 17 05 00 00       	call   8021d3 <pageref>
		nn = thisenv->env_runs;
  801cbc:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801cc2:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801cc5:	83 c4 10             	add    $0x10,%esp
  801cc8:	39 cb                	cmp    %ecx,%ebx
  801cca:	74 1b                	je     801ce7 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801ccc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ccf:	75 cf                	jne    801ca0 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801cd1:	8b 42 58             	mov    0x58(%edx),%eax
  801cd4:	6a 01                	push   $0x1
  801cd6:	50                   	push   %eax
  801cd7:	53                   	push   %ebx
  801cd8:	68 0f 2a 80 00       	push   $0x802a0f
  801cdd:	e8 cf e4 ff ff       	call   8001b1 <cprintf>
  801ce2:	83 c4 10             	add    $0x10,%esp
  801ce5:	eb b9                	jmp    801ca0 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801ce7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cea:	0f 94 c0             	sete   %al
  801ced:	0f b6 c0             	movzbl %al,%eax
}
  801cf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cf3:	5b                   	pop    %ebx
  801cf4:	5e                   	pop    %esi
  801cf5:	5f                   	pop    %edi
  801cf6:	5d                   	pop    %ebp
  801cf7:	c3                   	ret    

00801cf8 <devpipe_write>:
{
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
  801cfb:	57                   	push   %edi
  801cfc:	56                   	push   %esi
  801cfd:	53                   	push   %ebx
  801cfe:	83 ec 28             	sub    $0x28,%esp
  801d01:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d04:	56                   	push   %esi
  801d05:	e8 61 f7 ff ff       	call   80146b <fd2data>
  801d0a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d0c:	83 c4 10             	add    $0x10,%esp
  801d0f:	bf 00 00 00 00       	mov    $0x0,%edi
  801d14:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d17:	74 4f                	je     801d68 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d19:	8b 43 04             	mov    0x4(%ebx),%eax
  801d1c:	8b 0b                	mov    (%ebx),%ecx
  801d1e:	8d 51 20             	lea    0x20(%ecx),%edx
  801d21:	39 d0                	cmp    %edx,%eax
  801d23:	72 14                	jb     801d39 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d25:	89 da                	mov    %ebx,%edx
  801d27:	89 f0                	mov    %esi,%eax
  801d29:	e8 65 ff ff ff       	call   801c93 <_pipeisclosed>
  801d2e:	85 c0                	test   %eax,%eax
  801d30:	75 3b                	jne    801d6d <devpipe_write+0x75>
			sys_yield();
  801d32:	e8 73 ef ff ff       	call   800caa <sys_yield>
  801d37:	eb e0                	jmp    801d19 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d3c:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d40:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d43:	89 c2                	mov    %eax,%edx
  801d45:	c1 fa 1f             	sar    $0x1f,%edx
  801d48:	89 d1                	mov    %edx,%ecx
  801d4a:	c1 e9 1b             	shr    $0x1b,%ecx
  801d4d:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d50:	83 e2 1f             	and    $0x1f,%edx
  801d53:	29 ca                	sub    %ecx,%edx
  801d55:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d59:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d5d:	83 c0 01             	add    $0x1,%eax
  801d60:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d63:	83 c7 01             	add    $0x1,%edi
  801d66:	eb ac                	jmp    801d14 <devpipe_write+0x1c>
	return i;
  801d68:	8b 45 10             	mov    0x10(%ebp),%eax
  801d6b:	eb 05                	jmp    801d72 <devpipe_write+0x7a>
				return 0;
  801d6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d72:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d75:	5b                   	pop    %ebx
  801d76:	5e                   	pop    %esi
  801d77:	5f                   	pop    %edi
  801d78:	5d                   	pop    %ebp
  801d79:	c3                   	ret    

00801d7a <devpipe_read>:
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
  801d7d:	57                   	push   %edi
  801d7e:	56                   	push   %esi
  801d7f:	53                   	push   %ebx
  801d80:	83 ec 18             	sub    $0x18,%esp
  801d83:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801d86:	57                   	push   %edi
  801d87:	e8 df f6 ff ff       	call   80146b <fd2data>
  801d8c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d8e:	83 c4 10             	add    $0x10,%esp
  801d91:	be 00 00 00 00       	mov    $0x0,%esi
  801d96:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d99:	75 14                	jne    801daf <devpipe_read+0x35>
	return i;
  801d9b:	8b 45 10             	mov    0x10(%ebp),%eax
  801d9e:	eb 02                	jmp    801da2 <devpipe_read+0x28>
				return i;
  801da0:	89 f0                	mov    %esi,%eax
}
  801da2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801da5:	5b                   	pop    %ebx
  801da6:	5e                   	pop    %esi
  801da7:	5f                   	pop    %edi
  801da8:	5d                   	pop    %ebp
  801da9:	c3                   	ret    
			sys_yield();
  801daa:	e8 fb ee ff ff       	call   800caa <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801daf:	8b 03                	mov    (%ebx),%eax
  801db1:	3b 43 04             	cmp    0x4(%ebx),%eax
  801db4:	75 18                	jne    801dce <devpipe_read+0x54>
			if (i > 0)
  801db6:	85 f6                	test   %esi,%esi
  801db8:	75 e6                	jne    801da0 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801dba:	89 da                	mov    %ebx,%edx
  801dbc:	89 f8                	mov    %edi,%eax
  801dbe:	e8 d0 fe ff ff       	call   801c93 <_pipeisclosed>
  801dc3:	85 c0                	test   %eax,%eax
  801dc5:	74 e3                	je     801daa <devpipe_read+0x30>
				return 0;
  801dc7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dcc:	eb d4                	jmp    801da2 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801dce:	99                   	cltd   
  801dcf:	c1 ea 1b             	shr    $0x1b,%edx
  801dd2:	01 d0                	add    %edx,%eax
  801dd4:	83 e0 1f             	and    $0x1f,%eax
  801dd7:	29 d0                	sub    %edx,%eax
  801dd9:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801dde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801de1:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801de4:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801de7:	83 c6 01             	add    $0x1,%esi
  801dea:	eb aa                	jmp    801d96 <devpipe_read+0x1c>

00801dec <pipe>:
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
  801def:	56                   	push   %esi
  801df0:	53                   	push   %ebx
  801df1:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801df4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801df7:	50                   	push   %eax
  801df8:	e8 85 f6 ff ff       	call   801482 <fd_alloc>
  801dfd:	89 c3                	mov    %eax,%ebx
  801dff:	83 c4 10             	add    $0x10,%esp
  801e02:	85 c0                	test   %eax,%eax
  801e04:	0f 88 23 01 00 00    	js     801f2d <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e0a:	83 ec 04             	sub    $0x4,%esp
  801e0d:	68 07 04 00 00       	push   $0x407
  801e12:	ff 75 f4             	pushl  -0xc(%ebp)
  801e15:	6a 00                	push   $0x0
  801e17:	e8 ad ee ff ff       	call   800cc9 <sys_page_alloc>
  801e1c:	89 c3                	mov    %eax,%ebx
  801e1e:	83 c4 10             	add    $0x10,%esp
  801e21:	85 c0                	test   %eax,%eax
  801e23:	0f 88 04 01 00 00    	js     801f2d <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801e29:	83 ec 0c             	sub    $0xc,%esp
  801e2c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e2f:	50                   	push   %eax
  801e30:	e8 4d f6 ff ff       	call   801482 <fd_alloc>
  801e35:	89 c3                	mov    %eax,%ebx
  801e37:	83 c4 10             	add    $0x10,%esp
  801e3a:	85 c0                	test   %eax,%eax
  801e3c:	0f 88 db 00 00 00    	js     801f1d <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e42:	83 ec 04             	sub    $0x4,%esp
  801e45:	68 07 04 00 00       	push   $0x407
  801e4a:	ff 75 f0             	pushl  -0x10(%ebp)
  801e4d:	6a 00                	push   $0x0
  801e4f:	e8 75 ee ff ff       	call   800cc9 <sys_page_alloc>
  801e54:	89 c3                	mov    %eax,%ebx
  801e56:	83 c4 10             	add    $0x10,%esp
  801e59:	85 c0                	test   %eax,%eax
  801e5b:	0f 88 bc 00 00 00    	js     801f1d <pipe+0x131>
	va = fd2data(fd0);
  801e61:	83 ec 0c             	sub    $0xc,%esp
  801e64:	ff 75 f4             	pushl  -0xc(%ebp)
  801e67:	e8 ff f5 ff ff       	call   80146b <fd2data>
  801e6c:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e6e:	83 c4 0c             	add    $0xc,%esp
  801e71:	68 07 04 00 00       	push   $0x407
  801e76:	50                   	push   %eax
  801e77:	6a 00                	push   $0x0
  801e79:	e8 4b ee ff ff       	call   800cc9 <sys_page_alloc>
  801e7e:	89 c3                	mov    %eax,%ebx
  801e80:	83 c4 10             	add    $0x10,%esp
  801e83:	85 c0                	test   %eax,%eax
  801e85:	0f 88 82 00 00 00    	js     801f0d <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e8b:	83 ec 0c             	sub    $0xc,%esp
  801e8e:	ff 75 f0             	pushl  -0x10(%ebp)
  801e91:	e8 d5 f5 ff ff       	call   80146b <fd2data>
  801e96:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e9d:	50                   	push   %eax
  801e9e:	6a 00                	push   $0x0
  801ea0:	56                   	push   %esi
  801ea1:	6a 00                	push   $0x0
  801ea3:	e8 64 ee ff ff       	call   800d0c <sys_page_map>
  801ea8:	89 c3                	mov    %eax,%ebx
  801eaa:	83 c4 20             	add    $0x20,%esp
  801ead:	85 c0                	test   %eax,%eax
  801eaf:	78 4e                	js     801eff <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801eb1:	a1 20 30 80 00       	mov    0x803020,%eax
  801eb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eb9:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801ebb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ebe:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801ec5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ec8:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801eca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ecd:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801ed4:	83 ec 0c             	sub    $0xc,%esp
  801ed7:	ff 75 f4             	pushl  -0xc(%ebp)
  801eda:	e8 7c f5 ff ff       	call   80145b <fd2num>
  801edf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ee2:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ee4:	83 c4 04             	add    $0x4,%esp
  801ee7:	ff 75 f0             	pushl  -0x10(%ebp)
  801eea:	e8 6c f5 ff ff       	call   80145b <fd2num>
  801eef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ef2:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ef5:	83 c4 10             	add    $0x10,%esp
  801ef8:	bb 00 00 00 00       	mov    $0x0,%ebx
  801efd:	eb 2e                	jmp    801f2d <pipe+0x141>
	sys_page_unmap(0, va);
  801eff:	83 ec 08             	sub    $0x8,%esp
  801f02:	56                   	push   %esi
  801f03:	6a 00                	push   $0x0
  801f05:	e8 44 ee ff ff       	call   800d4e <sys_page_unmap>
  801f0a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f0d:	83 ec 08             	sub    $0x8,%esp
  801f10:	ff 75 f0             	pushl  -0x10(%ebp)
  801f13:	6a 00                	push   $0x0
  801f15:	e8 34 ee ff ff       	call   800d4e <sys_page_unmap>
  801f1a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f1d:	83 ec 08             	sub    $0x8,%esp
  801f20:	ff 75 f4             	pushl  -0xc(%ebp)
  801f23:	6a 00                	push   $0x0
  801f25:	e8 24 ee ff ff       	call   800d4e <sys_page_unmap>
  801f2a:	83 c4 10             	add    $0x10,%esp
}
  801f2d:	89 d8                	mov    %ebx,%eax
  801f2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f32:	5b                   	pop    %ebx
  801f33:	5e                   	pop    %esi
  801f34:	5d                   	pop    %ebp
  801f35:	c3                   	ret    

00801f36 <pipeisclosed>:
{
  801f36:	55                   	push   %ebp
  801f37:	89 e5                	mov    %esp,%ebp
  801f39:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f3c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f3f:	50                   	push   %eax
  801f40:	ff 75 08             	pushl  0x8(%ebp)
  801f43:	e8 8c f5 ff ff       	call   8014d4 <fd_lookup>
  801f48:	83 c4 10             	add    $0x10,%esp
  801f4b:	85 c0                	test   %eax,%eax
  801f4d:	78 18                	js     801f67 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f4f:	83 ec 0c             	sub    $0xc,%esp
  801f52:	ff 75 f4             	pushl  -0xc(%ebp)
  801f55:	e8 11 f5 ff ff       	call   80146b <fd2data>
	return _pipeisclosed(fd, p);
  801f5a:	89 c2                	mov    %eax,%edx
  801f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5f:	e8 2f fd ff ff       	call   801c93 <_pipeisclosed>
  801f64:	83 c4 10             	add    $0x10,%esp
}
  801f67:	c9                   	leave  
  801f68:	c3                   	ret    

00801f69 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801f69:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6e:	c3                   	ret    

00801f6f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
  801f72:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f75:	68 27 2a 80 00       	push   $0x802a27
  801f7a:	ff 75 0c             	pushl  0xc(%ebp)
  801f7d:	e8 55 e9 ff ff       	call   8008d7 <strcpy>
	return 0;
}
  801f82:	b8 00 00 00 00       	mov    $0x0,%eax
  801f87:	c9                   	leave  
  801f88:	c3                   	ret    

00801f89 <devcons_write>:
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
  801f8c:	57                   	push   %edi
  801f8d:	56                   	push   %esi
  801f8e:	53                   	push   %ebx
  801f8f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801f95:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801f9a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801fa0:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fa3:	73 31                	jae    801fd6 <devcons_write+0x4d>
		m = n - tot;
  801fa5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801fa8:	29 f3                	sub    %esi,%ebx
  801faa:	83 fb 7f             	cmp    $0x7f,%ebx
  801fad:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801fb2:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801fb5:	83 ec 04             	sub    $0x4,%esp
  801fb8:	53                   	push   %ebx
  801fb9:	89 f0                	mov    %esi,%eax
  801fbb:	03 45 0c             	add    0xc(%ebp),%eax
  801fbe:	50                   	push   %eax
  801fbf:	57                   	push   %edi
  801fc0:	e8 a0 ea ff ff       	call   800a65 <memmove>
		sys_cputs(buf, m);
  801fc5:	83 c4 08             	add    $0x8,%esp
  801fc8:	53                   	push   %ebx
  801fc9:	57                   	push   %edi
  801fca:	e8 3e ec ff ff       	call   800c0d <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801fcf:	01 de                	add    %ebx,%esi
  801fd1:	83 c4 10             	add    $0x10,%esp
  801fd4:	eb ca                	jmp    801fa0 <devcons_write+0x17>
}
  801fd6:	89 f0                	mov    %esi,%eax
  801fd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fdb:	5b                   	pop    %ebx
  801fdc:	5e                   	pop    %esi
  801fdd:	5f                   	pop    %edi
  801fde:	5d                   	pop    %ebp
  801fdf:	c3                   	ret    

00801fe0 <devcons_read>:
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
  801fe3:	83 ec 08             	sub    $0x8,%esp
  801fe6:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801feb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fef:	74 21                	je     802012 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  801ff1:	e8 35 ec ff ff       	call   800c2b <sys_cgetc>
  801ff6:	85 c0                	test   %eax,%eax
  801ff8:	75 07                	jne    802001 <devcons_read+0x21>
		sys_yield();
  801ffa:	e8 ab ec ff ff       	call   800caa <sys_yield>
  801fff:	eb f0                	jmp    801ff1 <devcons_read+0x11>
	if (c < 0)
  802001:	78 0f                	js     802012 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802003:	83 f8 04             	cmp    $0x4,%eax
  802006:	74 0c                	je     802014 <devcons_read+0x34>
	*(char*)vbuf = c;
  802008:	8b 55 0c             	mov    0xc(%ebp),%edx
  80200b:	88 02                	mov    %al,(%edx)
	return 1;
  80200d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802012:	c9                   	leave  
  802013:	c3                   	ret    
		return 0;
  802014:	b8 00 00 00 00       	mov    $0x0,%eax
  802019:	eb f7                	jmp    802012 <devcons_read+0x32>

0080201b <cputchar>:
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
  80201e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802021:	8b 45 08             	mov    0x8(%ebp),%eax
  802024:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802027:	6a 01                	push   $0x1
  802029:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80202c:	50                   	push   %eax
  80202d:	e8 db eb ff ff       	call   800c0d <sys_cputs>
}
  802032:	83 c4 10             	add    $0x10,%esp
  802035:	c9                   	leave  
  802036:	c3                   	ret    

00802037 <getchar>:
{
  802037:	55                   	push   %ebp
  802038:	89 e5                	mov    %esp,%ebp
  80203a:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80203d:	6a 01                	push   $0x1
  80203f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802042:	50                   	push   %eax
  802043:	6a 00                	push   $0x0
  802045:	e8 f5 f6 ff ff       	call   80173f <read>
	if (r < 0)
  80204a:	83 c4 10             	add    $0x10,%esp
  80204d:	85 c0                	test   %eax,%eax
  80204f:	78 06                	js     802057 <getchar+0x20>
	if (r < 1)
  802051:	74 06                	je     802059 <getchar+0x22>
	return c;
  802053:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802057:	c9                   	leave  
  802058:	c3                   	ret    
		return -E_EOF;
  802059:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80205e:	eb f7                	jmp    802057 <getchar+0x20>

00802060 <iscons>:
{
  802060:	55                   	push   %ebp
  802061:	89 e5                	mov    %esp,%ebp
  802063:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802066:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802069:	50                   	push   %eax
  80206a:	ff 75 08             	pushl  0x8(%ebp)
  80206d:	e8 62 f4 ff ff       	call   8014d4 <fd_lookup>
  802072:	83 c4 10             	add    $0x10,%esp
  802075:	85 c0                	test   %eax,%eax
  802077:	78 11                	js     80208a <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802079:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207c:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802082:	39 10                	cmp    %edx,(%eax)
  802084:	0f 94 c0             	sete   %al
  802087:	0f b6 c0             	movzbl %al,%eax
}
  80208a:	c9                   	leave  
  80208b:	c3                   	ret    

0080208c <opencons>:
{
  80208c:	55                   	push   %ebp
  80208d:	89 e5                	mov    %esp,%ebp
  80208f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802092:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802095:	50                   	push   %eax
  802096:	e8 e7 f3 ff ff       	call   801482 <fd_alloc>
  80209b:	83 c4 10             	add    $0x10,%esp
  80209e:	85 c0                	test   %eax,%eax
  8020a0:	78 3a                	js     8020dc <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020a2:	83 ec 04             	sub    $0x4,%esp
  8020a5:	68 07 04 00 00       	push   $0x407
  8020aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8020ad:	6a 00                	push   $0x0
  8020af:	e8 15 ec ff ff       	call   800cc9 <sys_page_alloc>
  8020b4:	83 c4 10             	add    $0x10,%esp
  8020b7:	85 c0                	test   %eax,%eax
  8020b9:	78 21                	js     8020dc <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8020bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020be:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020c4:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8020c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8020d0:	83 ec 0c             	sub    $0xc,%esp
  8020d3:	50                   	push   %eax
  8020d4:	e8 82 f3 ff ff       	call   80145b <fd2num>
  8020d9:	83 c4 10             	add    $0x10,%esp
}
  8020dc:	c9                   	leave  
  8020dd:	c3                   	ret    

008020de <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8020de:	55                   	push   %ebp
  8020df:	89 e5                	mov    %esp,%ebp
  8020e1:	56                   	push   %esi
  8020e2:	53                   	push   %ebx
  8020e3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8020e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e9:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// return 0;
	if(!pg)
  8020ec:	85 c0                	test   %eax,%eax
		pg = (void*)UTOP;
  8020ee:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8020f3:	0f 44 c2             	cmove  %edx,%eax
	
	int ret;

	ret = sys_ipc_recv(pg);
  8020f6:	83 ec 0c             	sub    $0xc,%esp
  8020f9:	50                   	push   %eax
  8020fa:	e8 7a ed ff ff       	call   800e79 <sys_ipc_recv>
	if(ret < 0){
  8020ff:	83 c4 10             	add    $0x10,%esp
  802102:	85 c0                	test   %eax,%eax
  802104:	78 2b                	js     802131 <ipc_recv+0x53>
		if(perm_store) *perm_store = 0;
		if(from_env_store) *from_env_store = 0;
		return ret;
	}
	
	if(perm_store)
  802106:	85 f6                	test   %esi,%esi
  802108:	74 0a                	je     802114 <ipc_recv+0x36>
		*perm_store = thisenv->env_ipc_perm;
  80210a:	a1 04 40 80 00       	mov    0x804004,%eax
  80210f:	8b 40 78             	mov    0x78(%eax),%eax
  802112:	89 06                	mov    %eax,(%esi)
	if(from_env_store)
  802114:	85 db                	test   %ebx,%ebx
  802116:	74 0a                	je     802122 <ipc_recv+0x44>
		*from_env_store = thisenv->env_ipc_from;
  802118:	a1 04 40 80 00       	mov    0x804004,%eax
  80211d:	8b 40 74             	mov    0x74(%eax),%eax
  802120:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  802122:	a1 04 40 80 00       	mov    0x804004,%eax
  802127:	8b 40 70             	mov    0x70(%eax),%eax
}
  80212a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80212d:	5b                   	pop    %ebx
  80212e:	5e                   	pop    %esi
  80212f:	5d                   	pop    %ebp
  802130:	c3                   	ret    
		if(perm_store) *perm_store = 0;
  802131:	85 f6                	test   %esi,%esi
  802133:	74 06                	je     80213b <ipc_recv+0x5d>
  802135:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(from_env_store) *from_env_store = 0;
  80213b:	85 db                	test   %ebx,%ebx
  80213d:	74 eb                	je     80212a <ipc_recv+0x4c>
  80213f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802145:	eb e3                	jmp    80212a <ipc_recv+0x4c>

00802147 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802147:	55                   	push   %ebp
  802148:	89 e5                	mov    %esp,%ebp
  80214a:	57                   	push   %edi
  80214b:	56                   	push   %esi
  80214c:	53                   	push   %ebx
  80214d:	83 ec 0c             	sub    $0xc,%esp
  802150:	8b 7d 08             	mov    0x8(%ebp),%edi
  802153:	8b 75 0c             	mov    0xc(%ebp),%esi
  802156:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
	if (!pg)
  802159:	85 db                	test   %ebx,%ebx
		pg = (void*)UTOP;
  80215b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802160:	0f 44 d8             	cmove  %eax,%ebx

	int ret = -E_IPC_NOT_RECV;
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))) {
  802163:	ff 75 14             	pushl  0x14(%ebp)
  802166:	53                   	push   %ebx
  802167:	56                   	push   %esi
  802168:	57                   	push   %edi
  802169:	e8 e8 ec ff ff       	call   800e56 <sys_ipc_try_send>
  80216e:	83 c4 10             	add    $0x10,%esp
  802171:	85 c0                	test   %eax,%eax
  802173:	74 17                	je     80218c <ipc_send+0x45>
		if(ret != -E_IPC_NOT_RECV){
  802175:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802178:	74 e9                	je     802163 <ipc_send+0x1c>
			panic("ipc_send: ret : %d", ret);
  80217a:	50                   	push   %eax
  80217b:	68 33 2a 80 00       	push   $0x802a33
  802180:	6a 43                	push   $0x43
  802182:	68 46 2a 80 00       	push   $0x802a46
  802187:	e8 4a df ff ff       	call   8000d6 <_panic>
			sys_yield();
		}
	}
}
  80218c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80218f:	5b                   	pop    %ebx
  802190:	5e                   	pop    %esi
  802191:	5f                   	pop    %edi
  802192:	5d                   	pop    %ebp
  802193:	c3                   	ret    

00802194 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802194:	55                   	push   %ebp
  802195:	89 e5                	mov    %esp,%ebp
  802197:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80219a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80219f:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8021a5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8021ab:	8b 52 50             	mov    0x50(%edx),%edx
  8021ae:	39 ca                	cmp    %ecx,%edx
  8021b0:	74 11                	je     8021c3 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8021b2:	83 c0 01             	add    $0x1,%eax
  8021b5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8021ba:	75 e3                	jne    80219f <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8021bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c1:	eb 0e                	jmp    8021d1 <ipc_find_env+0x3d>
			return envs[i].env_id;
  8021c3:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8021c9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8021ce:	8b 40 48             	mov    0x48(%eax),%eax
}
  8021d1:	5d                   	pop    %ebp
  8021d2:	c3                   	ret    

008021d3 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8021d3:	55                   	push   %ebp
  8021d4:	89 e5                	mov    %esp,%ebp
  8021d6:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8021d9:	89 d0                	mov    %edx,%eax
  8021db:	c1 e8 16             	shr    $0x16,%eax
  8021de:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8021e5:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8021ea:	f6 c1 01             	test   $0x1,%cl
  8021ed:	74 1d                	je     80220c <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8021ef:	c1 ea 0c             	shr    $0xc,%edx
  8021f2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8021f9:	f6 c2 01             	test   $0x1,%dl
  8021fc:	74 0e                	je     80220c <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8021fe:	c1 ea 0c             	shr    $0xc,%edx
  802201:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802208:	ef 
  802209:	0f b7 c0             	movzwl %ax,%eax
}
  80220c:	5d                   	pop    %ebp
  80220d:	c3                   	ret    
  80220e:	66 90                	xchg   %ax,%ax

00802210 <__udivdi3>:
  802210:	55                   	push   %ebp
  802211:	57                   	push   %edi
  802212:	56                   	push   %esi
  802213:	53                   	push   %ebx
  802214:	83 ec 1c             	sub    $0x1c,%esp
  802217:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80221b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80221f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802223:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802227:	85 d2                	test   %edx,%edx
  802229:	75 4d                	jne    802278 <__udivdi3+0x68>
  80222b:	39 f3                	cmp    %esi,%ebx
  80222d:	76 19                	jbe    802248 <__udivdi3+0x38>
  80222f:	31 ff                	xor    %edi,%edi
  802231:	89 e8                	mov    %ebp,%eax
  802233:	89 f2                	mov    %esi,%edx
  802235:	f7 f3                	div    %ebx
  802237:	89 fa                	mov    %edi,%edx
  802239:	83 c4 1c             	add    $0x1c,%esp
  80223c:	5b                   	pop    %ebx
  80223d:	5e                   	pop    %esi
  80223e:	5f                   	pop    %edi
  80223f:	5d                   	pop    %ebp
  802240:	c3                   	ret    
  802241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802248:	89 d9                	mov    %ebx,%ecx
  80224a:	85 db                	test   %ebx,%ebx
  80224c:	75 0b                	jne    802259 <__udivdi3+0x49>
  80224e:	b8 01 00 00 00       	mov    $0x1,%eax
  802253:	31 d2                	xor    %edx,%edx
  802255:	f7 f3                	div    %ebx
  802257:	89 c1                	mov    %eax,%ecx
  802259:	31 d2                	xor    %edx,%edx
  80225b:	89 f0                	mov    %esi,%eax
  80225d:	f7 f1                	div    %ecx
  80225f:	89 c6                	mov    %eax,%esi
  802261:	89 e8                	mov    %ebp,%eax
  802263:	89 f7                	mov    %esi,%edi
  802265:	f7 f1                	div    %ecx
  802267:	89 fa                	mov    %edi,%edx
  802269:	83 c4 1c             	add    $0x1c,%esp
  80226c:	5b                   	pop    %ebx
  80226d:	5e                   	pop    %esi
  80226e:	5f                   	pop    %edi
  80226f:	5d                   	pop    %ebp
  802270:	c3                   	ret    
  802271:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802278:	39 f2                	cmp    %esi,%edx
  80227a:	77 1c                	ja     802298 <__udivdi3+0x88>
  80227c:	0f bd fa             	bsr    %edx,%edi
  80227f:	83 f7 1f             	xor    $0x1f,%edi
  802282:	75 2c                	jne    8022b0 <__udivdi3+0xa0>
  802284:	39 f2                	cmp    %esi,%edx
  802286:	72 06                	jb     80228e <__udivdi3+0x7e>
  802288:	31 c0                	xor    %eax,%eax
  80228a:	39 eb                	cmp    %ebp,%ebx
  80228c:	77 a9                	ja     802237 <__udivdi3+0x27>
  80228e:	b8 01 00 00 00       	mov    $0x1,%eax
  802293:	eb a2                	jmp    802237 <__udivdi3+0x27>
  802295:	8d 76 00             	lea    0x0(%esi),%esi
  802298:	31 ff                	xor    %edi,%edi
  80229a:	31 c0                	xor    %eax,%eax
  80229c:	89 fa                	mov    %edi,%edx
  80229e:	83 c4 1c             	add    $0x1c,%esp
  8022a1:	5b                   	pop    %ebx
  8022a2:	5e                   	pop    %esi
  8022a3:	5f                   	pop    %edi
  8022a4:	5d                   	pop    %ebp
  8022a5:	c3                   	ret    
  8022a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022ad:	8d 76 00             	lea    0x0(%esi),%esi
  8022b0:	89 f9                	mov    %edi,%ecx
  8022b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8022b7:	29 f8                	sub    %edi,%eax
  8022b9:	d3 e2                	shl    %cl,%edx
  8022bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022bf:	89 c1                	mov    %eax,%ecx
  8022c1:	89 da                	mov    %ebx,%edx
  8022c3:	d3 ea                	shr    %cl,%edx
  8022c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8022c9:	09 d1                	or     %edx,%ecx
  8022cb:	89 f2                	mov    %esi,%edx
  8022cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022d1:	89 f9                	mov    %edi,%ecx
  8022d3:	d3 e3                	shl    %cl,%ebx
  8022d5:	89 c1                	mov    %eax,%ecx
  8022d7:	d3 ea                	shr    %cl,%edx
  8022d9:	89 f9                	mov    %edi,%ecx
  8022db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8022df:	89 eb                	mov    %ebp,%ebx
  8022e1:	d3 e6                	shl    %cl,%esi
  8022e3:	89 c1                	mov    %eax,%ecx
  8022e5:	d3 eb                	shr    %cl,%ebx
  8022e7:	09 de                	or     %ebx,%esi
  8022e9:	89 f0                	mov    %esi,%eax
  8022eb:	f7 74 24 08          	divl   0x8(%esp)
  8022ef:	89 d6                	mov    %edx,%esi
  8022f1:	89 c3                	mov    %eax,%ebx
  8022f3:	f7 64 24 0c          	mull   0xc(%esp)
  8022f7:	39 d6                	cmp    %edx,%esi
  8022f9:	72 15                	jb     802310 <__udivdi3+0x100>
  8022fb:	89 f9                	mov    %edi,%ecx
  8022fd:	d3 e5                	shl    %cl,%ebp
  8022ff:	39 c5                	cmp    %eax,%ebp
  802301:	73 04                	jae    802307 <__udivdi3+0xf7>
  802303:	39 d6                	cmp    %edx,%esi
  802305:	74 09                	je     802310 <__udivdi3+0x100>
  802307:	89 d8                	mov    %ebx,%eax
  802309:	31 ff                	xor    %edi,%edi
  80230b:	e9 27 ff ff ff       	jmp    802237 <__udivdi3+0x27>
  802310:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802313:	31 ff                	xor    %edi,%edi
  802315:	e9 1d ff ff ff       	jmp    802237 <__udivdi3+0x27>
  80231a:	66 90                	xchg   %ax,%ax
  80231c:	66 90                	xchg   %ax,%ax
  80231e:	66 90                	xchg   %ax,%ax

00802320 <__umoddi3>:
  802320:	55                   	push   %ebp
  802321:	57                   	push   %edi
  802322:	56                   	push   %esi
  802323:	53                   	push   %ebx
  802324:	83 ec 1c             	sub    $0x1c,%esp
  802327:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80232b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80232f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802333:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802337:	89 da                	mov    %ebx,%edx
  802339:	85 c0                	test   %eax,%eax
  80233b:	75 43                	jne    802380 <__umoddi3+0x60>
  80233d:	39 df                	cmp    %ebx,%edi
  80233f:	76 17                	jbe    802358 <__umoddi3+0x38>
  802341:	89 f0                	mov    %esi,%eax
  802343:	f7 f7                	div    %edi
  802345:	89 d0                	mov    %edx,%eax
  802347:	31 d2                	xor    %edx,%edx
  802349:	83 c4 1c             	add    $0x1c,%esp
  80234c:	5b                   	pop    %ebx
  80234d:	5e                   	pop    %esi
  80234e:	5f                   	pop    %edi
  80234f:	5d                   	pop    %ebp
  802350:	c3                   	ret    
  802351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802358:	89 fd                	mov    %edi,%ebp
  80235a:	85 ff                	test   %edi,%edi
  80235c:	75 0b                	jne    802369 <__umoddi3+0x49>
  80235e:	b8 01 00 00 00       	mov    $0x1,%eax
  802363:	31 d2                	xor    %edx,%edx
  802365:	f7 f7                	div    %edi
  802367:	89 c5                	mov    %eax,%ebp
  802369:	89 d8                	mov    %ebx,%eax
  80236b:	31 d2                	xor    %edx,%edx
  80236d:	f7 f5                	div    %ebp
  80236f:	89 f0                	mov    %esi,%eax
  802371:	f7 f5                	div    %ebp
  802373:	89 d0                	mov    %edx,%eax
  802375:	eb d0                	jmp    802347 <__umoddi3+0x27>
  802377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80237e:	66 90                	xchg   %ax,%ax
  802380:	89 f1                	mov    %esi,%ecx
  802382:	39 d8                	cmp    %ebx,%eax
  802384:	76 0a                	jbe    802390 <__umoddi3+0x70>
  802386:	89 f0                	mov    %esi,%eax
  802388:	83 c4 1c             	add    $0x1c,%esp
  80238b:	5b                   	pop    %ebx
  80238c:	5e                   	pop    %esi
  80238d:	5f                   	pop    %edi
  80238e:	5d                   	pop    %ebp
  80238f:	c3                   	ret    
  802390:	0f bd e8             	bsr    %eax,%ebp
  802393:	83 f5 1f             	xor    $0x1f,%ebp
  802396:	75 20                	jne    8023b8 <__umoddi3+0x98>
  802398:	39 d8                	cmp    %ebx,%eax
  80239a:	0f 82 b0 00 00 00    	jb     802450 <__umoddi3+0x130>
  8023a0:	39 f7                	cmp    %esi,%edi
  8023a2:	0f 86 a8 00 00 00    	jbe    802450 <__umoddi3+0x130>
  8023a8:	89 c8                	mov    %ecx,%eax
  8023aa:	83 c4 1c             	add    $0x1c,%esp
  8023ad:	5b                   	pop    %ebx
  8023ae:	5e                   	pop    %esi
  8023af:	5f                   	pop    %edi
  8023b0:	5d                   	pop    %ebp
  8023b1:	c3                   	ret    
  8023b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8023b8:	89 e9                	mov    %ebp,%ecx
  8023ba:	ba 20 00 00 00       	mov    $0x20,%edx
  8023bf:	29 ea                	sub    %ebp,%edx
  8023c1:	d3 e0                	shl    %cl,%eax
  8023c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023c7:	89 d1                	mov    %edx,%ecx
  8023c9:	89 f8                	mov    %edi,%eax
  8023cb:	d3 e8                	shr    %cl,%eax
  8023cd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8023d5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8023d9:	09 c1                	or     %eax,%ecx
  8023db:	89 d8                	mov    %ebx,%eax
  8023dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023e1:	89 e9                	mov    %ebp,%ecx
  8023e3:	d3 e7                	shl    %cl,%edi
  8023e5:	89 d1                	mov    %edx,%ecx
  8023e7:	d3 e8                	shr    %cl,%eax
  8023e9:	89 e9                	mov    %ebp,%ecx
  8023eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023ef:	d3 e3                	shl    %cl,%ebx
  8023f1:	89 c7                	mov    %eax,%edi
  8023f3:	89 d1                	mov    %edx,%ecx
  8023f5:	89 f0                	mov    %esi,%eax
  8023f7:	d3 e8                	shr    %cl,%eax
  8023f9:	89 e9                	mov    %ebp,%ecx
  8023fb:	89 fa                	mov    %edi,%edx
  8023fd:	d3 e6                	shl    %cl,%esi
  8023ff:	09 d8                	or     %ebx,%eax
  802401:	f7 74 24 08          	divl   0x8(%esp)
  802405:	89 d1                	mov    %edx,%ecx
  802407:	89 f3                	mov    %esi,%ebx
  802409:	f7 64 24 0c          	mull   0xc(%esp)
  80240d:	89 c6                	mov    %eax,%esi
  80240f:	89 d7                	mov    %edx,%edi
  802411:	39 d1                	cmp    %edx,%ecx
  802413:	72 06                	jb     80241b <__umoddi3+0xfb>
  802415:	75 10                	jne    802427 <__umoddi3+0x107>
  802417:	39 c3                	cmp    %eax,%ebx
  802419:	73 0c                	jae    802427 <__umoddi3+0x107>
  80241b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80241f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802423:	89 d7                	mov    %edx,%edi
  802425:	89 c6                	mov    %eax,%esi
  802427:	89 ca                	mov    %ecx,%edx
  802429:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80242e:	29 f3                	sub    %esi,%ebx
  802430:	19 fa                	sbb    %edi,%edx
  802432:	89 d0                	mov    %edx,%eax
  802434:	d3 e0                	shl    %cl,%eax
  802436:	89 e9                	mov    %ebp,%ecx
  802438:	d3 eb                	shr    %cl,%ebx
  80243a:	d3 ea                	shr    %cl,%edx
  80243c:	09 d8                	or     %ebx,%eax
  80243e:	83 c4 1c             	add    $0x1c,%esp
  802441:	5b                   	pop    %ebx
  802442:	5e                   	pop    %esi
  802443:	5f                   	pop    %edi
  802444:	5d                   	pop    %ebp
  802445:	c3                   	ret    
  802446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80244d:	8d 76 00             	lea    0x0(%esi),%esi
  802450:	89 da                	mov    %ebx,%edx
  802452:	29 fe                	sub    %edi,%esi
  802454:	19 c2                	sbb    %eax,%edx
  802456:	89 f1                	mov    %esi,%ecx
  802458:	89 c8                	mov    %ecx,%eax
  80245a:	e9 4b ff ff ff       	jmp    8023aa <__umoddi3+0x8a>
